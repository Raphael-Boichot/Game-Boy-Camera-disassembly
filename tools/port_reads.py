#!/usr/bin/env python3
"""Name and type the untyped data blocks of a ported build from what the project's core saw read them (the `reads` layer).

  tools/port_reads.py ROM COV.npz NAMES.csv [more names csv ...] --queue HAND_QUEUE.csv --out-names X.csv --out-types Y.csv [--tag DATE]

Input: the `default_data` rows of the port queue (bytes no carried name, loader or hand row types), and a coverage state of
coverage/tools/coverage_run.py replayed with GBCAM_SITE_ALL=1 (the core then keeps, for every ROM byte, the first call site of the
banked read and the {mode,state} of the first read, forced runs included; SETUP.md). A block is named only when at least half of
its bytes were read and one call site holds at least 60 % of the bytes that have a site: `Src_BB_AAAA_<routine of that site>`,
tag C (the read is observed; what the bytes mean is not), note = bytes read, sites, modes. A block whose site is the main loop or
the VBlank handler (a deferred copy: the site is not the consumer) is named after the {mode,state} that read it instead
(`Src_BB_AAAA_ModeMM_StateSS`) when one {mode,state} holds 60 %. One type row per named block: data, width 16. A block that already starts on a name gets the type row only; bank 0 below $0150 (vectors, header) is skipped. Blocks read by
nobody, or by no dominant site, stay untyped.
"""
import sys, csv, collections, bisect, argparse
import numpy as np
ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('cov'); ap.add_argument('names', nargs='+')
ap.add_argument('--queue', required=True); ap.add_argument('--out-names', required=True); ap.add_argument('--out-types', required=True)
ap.add_argument('--tag', default='coverage reads'); ap.add_argument('--skip-types', nargs='*', default=[], help='type csv files (the hand layer): a block that starts inside one of their rows is left to them')
a = ap.parse_args()
z = np.load(a.cov); dr = z['dr'] > 0; site = z['site']; rmode = z['rmode']
def flat(b, ad): return ad if b == 0 else b * 0x4000 + ad - 0x4000
labs = []
for f in a.names:
    for r in csv.DictReader(open(f, encoding='utf-8')): labs.append((flat(int(r['bank'], 16), int(r['addr'], 16)), r['name']))
labs.sort(); keys = [k for k, _ in labs]; KEYSET = set(keys)
def routine(v):
    v = int(v) & 0x7FFFFFFF; b, ad = v >> 16, v & 0xFFFF; o = flat(b if ad >= 0x4000 else 0, ad)
    i = bisect.bisect_right(keys, o) - 1; return labs[i][1] if i >= 0 else None
SKIP = [(flat(int(r['bank'], 16), int(r['start'], 16)), flat(int(r['bank'], 16), int(r['end'], 16))) for f in a.skip_types for r in csv.DictReader(open(f, encoding='utf-8'))]
GENERIC = {'Main_Loop', 'Irq_VBlank', 'Irq_VBlank_CopyRequest'}
N, T = [], []
for r in csv.DictReader(open(a.queue, encoding='utf-8')):
    if r['kind'] != 'default_data': continue
    b = int(r['bank'], 16); s0, e0 = int(r['start'], 16), int(r['end'], 16); s, e = flat(b, s0), flat(b, e0); n = e - s
    rd = dr[s:e]; k = int(rd.sum())
    if n < 4 or k * 2 < n or (b == 0 and s0 < 0x150) or any(x <= s < y for x, y in SKIP): continue      # the vector area of bank 0 is left alone
    sc = collections.Counter(routine(v) for v in site[s:e][rd] if v)
    mc = collections.Counter('Mode%02X_State%02X' % ((int(v) >> 8) & 0x3F, int(v) & 0xFF) for v in rmode[s:e][rd] if v)
    name = None
    if sc:
        top, c = sc.most_common(1)[0]
        if top and top not in GENERIC and c * 10 >= 6 * sum(sc.values()): name = top
    if name is None and mc:
        top, c = mc.most_common(1)[0]
        if c * 10 >= 6 * sum(mc.values()): name = top
    if name is None: continue
    lab = 'Src_%02X_%04X_%s' % (b, s0, name); named = s in KEYSET          # a name already starts here: keep it, add the type row only
    note = 'read in the coverage run (%d of %d bytes); call sites %s; first-read mode:state %s' % (
        k, n, ', '.join('%s x%d' % (x, c) for x, c in sc.most_common(2)) or 'none',
        ', '.join('%s x%d' % (x[4:6] + ':' + x[-2:], c) for x, c in mc.most_common(2)) or 'none')
    if not named: N.append(['%02x' % b, '%04x' % s0, lab, 'C', note, a.tag])
    T.append(['%02x' % b, '%04x' % s0, '%04x' % e0, 'data', 16, 'reads layer'])
with open(a.out_names, 'w', newline='', encoding='utf-8') as fh:
    w = csv.writer(fh, lineterminator='\n'); w.writerow(['bank', 'addr', 'name', 'conf', 'note', 'source']); w.writerows(N)
with open(a.out_types, 'w', newline='', encoding='utf-8') as fh:
    w = csv.writer(fh, lineterminator='\n'); w.writerow(['bank', 'start', 'end', 'type', 'width', 'note']); w.writerows(T)
print('reads layer: %d blocks typed (%d named), %d bytes' % (len(T), len(N), sum(int(t[2], 16) - int(t[1], 16) for t in T)))
