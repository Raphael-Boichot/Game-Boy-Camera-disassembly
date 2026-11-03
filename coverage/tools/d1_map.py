#!/usr/bin/env python3
"""Map data-bank read extents to the UI modes / call sites that read them. Usage: d1_map.py OUTDIR merged_cov.npz [banks hex,...]"""
import sys as _s, os as _o
_s.path.insert(0, _o.path.join(_o.path.dirname(_o.path.abspath(__file__)), '..', 'src'))
import paths
import sys, os, json, csv, collections
import numpy as np
OUT, cov = sys.argv[1], sys.argv[2]
banks = [int(x, 16) for x in sys.argv[3].split(',')] if len(sys.argv) > 3 else list(range(0x0B, 0x40))
def flat(b, a): return a if b == 0 and a < 0x4000 else b * 0x4000 + (a - 0x4000)
t = json.load(open(paths.TRACE))
N = 1 << 20; code = np.zeros(N, bool)
for k, n in t['code'].items():
    b, a = k.split(':')
    if n > 0: f = flat(int(b, 16), int(a, 16)); code[f:f + n] = True
z = np.load(cov); dr, odr = z['dr'] != 0, z['odr'] != 0
site, site2, rmode = (z['site'], z['site2'], z['rmode']) if 'site' in z.files else (np.zeros(N, np.uint32), np.zeros(N, np.uint32), np.zeros(N, np.uint16))
def dm(v): return '%02X:%02X' % ((int(v) >> 8) & 0x3F, int(v) & 0xFF)
def ds(v): v = int(v) & 0x7FFFFFFF; return '%02X:%04X' % (v >> 16, v & 0xFFFF)
rows = []
for b in banks:
    lo = b * 0x4000; seg = dr[lo:lo + 0x4000] & ~code[lo:lo + 0x4000]
    idx = np.nonzero(seg)[0]
    if not len(idx): rows.append((b, None)); continue
    ext = []; s = p = idx[0]
    for i in idx[1:]:
        if i - p > 32: ext.append((s, p)); s = i
        p = i
    ext.append((s, p))
    for s, e in ext:
        sl = slice(lo + s, lo + e + 1)
        mc = collections.Counter(dm(v) for v in rmode[sl][seg[s:e + 1]] if v)
        sc = collections.Counter(ds(v) for v in site[sl][seg[s:e + 1]] if v)
        s2 = collections.Counter(ds(v) for v in site2[sl][seg[s:e + 1]] if v)
        org = int((odr[sl] & seg[s:e + 1]).sum()); nrd = int(seg[s:e + 1].sum())
        rows.append((b, dict(start=0x4000 + s, end=0x4000 + e, span=e - s + 1, read=nrd, organic=org, modes=mc.most_common(4), sites=sc.most_common(3), sites2=s2.most_common(2))))
with open(os.path.join(OUT, 'data_bank_map.csv'), 'w', newline='') as fh:
    w = csv.writer(fh); w.writerow(['bank', 'start', 'end', 'span', 'bytes_read', 'bytes_read_organic', 'first_read_modes(D5CE:D5CF x bytes)', 'call_sites_level0(x bytes)', 'call_sites_level1(x bytes)'])
    for b, r in rows:
        if r is None: w.writerow(['%02X' % b, '', '', 0, 0, 0, '', '', '']); continue
        w.writerow(['%02X' % b, '%04X' % r['start'], '%04X' % r['end'], r['span'], r['read'], r['organic'], '; '.join('%s x%d' % x for x in r['modes']), '; '.join('%s x%d' % x for x in r['sites']), '; '.join('%s x%d' % x for x in r['sites2'])])
# per-bank summary
L = ['| bank | read bytes | organic | extents | modes that first read it (D5CE:D5CF, bytes) | call sites level 0 |', '|---|---|---|---|---|---|']
for b in banks:
    rs = [r for bb, r in rows if bb == b and r]
    if not rs: L.append('| %02X | 0 | 0 | 0 | never read | |' % b); continue
    mc = collections.Counter(); sc = collections.Counter()
    for r in rs:
        for k, v in r['modes']: mc[k] += v
        for k, v in r['sites']: sc[k] += v
    L.append('| %02X | %d | %d | %d | %s | %s |' % (b, sum(r['read'] for r in rs), sum(r['organic'] for r in rs), len(rs), ', '.join('%s (%d)' % x for x in mc.most_common(4)), ', '.join('%s (%d)' % x for x in sc.most_common(3))))
open(os.path.join(OUT, 'data_bank_map.md'), 'w').write('\n'.join(L) + '\n'); print('\n'.join(L))
