#!/usr/bin/env python3
"""L3 pass 6: picture / map blocks that only the interrupt's copy queue reads, placed by the routine that queued them.

  tools/port_check_names6.py TREE SUFFIX QUEUE.npz [QUEUE.npz ...] [--dry]

QUEUE.npz come from tools/port_queue_origin.py (the core records, for each ROM byte a queue routine copied, the routine that wrote the queue entry and
the two call sites above it).  The origin of a byte is the first of those three whose label is not a queue helper (a routine named *ViaVBlank*, Vq_*,
Vram_*, Mem_*, Irq_*, or one that only stores a request).  For a name still at I (after passes 4-5 and the hand layer):
  queue-loader   the routine in the block's name is the origin of at least 90 % of its queued bytes: the name holds
  queue-relabel  one other routine is the origin of at least 90 % of its queued bytes, and the name's tail is a routine label: renamed after it
  queue-descr    a descriptive name (its tail is no label) whose queued bytes come from one routine (>= 90 %): kept, C, the routine in the note
Rows go to <TREE>/disasm/sym_names_<s>_checked.csv with source 'checked6: ...' (earlier pass-6 rows replaced).
"""
import sys, os, re, csv, bisect, collections
import numpy as np
args = sys.argv[1:]; dry = '--dry' in args; args = [x for x in args if x != '--dry']
T, S, QS = args[0].rstrip('/'), args[1], args[2:]; D = T + '/disasm/'
def flat(b, a): return a if b == 0 else b * 0x4000 + a - 0x4000
names = {}
for suf in ('', '_loaders', '_reads', '_checked', '_hand'):
    p = D + 'sym_names_%s%s.csv' % (S, suf)
    if not os.path.exists(p): continue
    for r in csv.DictReader(open(p, encoding='utf-8')):
        if 'checked6: ' in r.get('source', ''): continue
        k = (int(r['bank'], 16), int(r['addr'], 16))
        if r['name'] == '-': names.pop(k, None)
        else: names[k] = r
labs = sorted((flat(*k), r['name']) for k, r in names.items()); keys = [x for x, _ in labs]
def lab(v):
    v = int(v) & 0x7FFFFFFF; b, ad = v >> 16, v & 0xFFFF; o = flat(b if ad >= 0x4000 else 0, ad); i = bisect.bisect_right(keys, o) - 1; return labs[i][1]
HELPER = re.compile(r'ViaVBlank|^Vq_|^Vram_|^Mem_|^Irq_|^Far_|Request')
q = [None, None, None]
for f in QS:
    z = np.load(f)
    for j, k in enumerate(('qsite', 'qsite2', 'qsite3')):
        a = z[k].astype(np.uint32)
        q[j] = a.copy() if q[j] is None else np.where(q[j] != 0, q[j], a)
def origin(o):
    for j in range(3):
        v = int(q[j][o])
        if v and not HELPER.search(lab(v)): return lab(v)
    return None
tr = __import__('json').load(open('%s/port/trace_%s.json' % (T, S)))['code']
code = {flat(int(k[:2], 16), int(k[3:], 16)) for k, n in tr.items() if n > 0}
ROUTINES = {r['name'] for k, r in names.items() if flat(*k) in code}
taken_labels = {r['name'] for r in names.values()}
taken = set(taken_labels); out = []; cnt = collections.Counter(); left = []
for (b, a), r in sorted(names.items()):
    if r['conf'] != 'I': continue
    n = r['name']; m = re.match(r'(Gfx|Map|Src)_([0-9A-F]{2})_([0-9A-F]{4})_(.+?)(_Part[0-9A-F]{4}|_Cont|_Aux|_HeadRows|_ExtraRows?|_ExtraRow)?$', n)
    if not m: continue
    o = flat(b, a); i = bisect.bisect_right(keys, o); e = min(keys[i] if i < len(keys) else 1 << 20, (o // 0x4000 + 1) * 0x4000)
    c = collections.Counter(x for x in (origin(x) for x in range(o, e) if q[0][x]) if x)
    tot = sum(c.values())
    if not tot: left.append((n, 'no queued byte')); continue
    top, k = c.most_common(1)[0]; why = None; nn = None
    if k < 0.9 * tot: left.append((n, ' '.join('%s=%d' % x for x in c.most_common(3)))); continue
    ev = '%d of %d queued bytes (%d bytes in the block), core copy-queue origin' % (k, tot, e - o)
    if top == m.group(4): why = 'queue-loader', '%s queues it for the interrupt copy: %s' % (top, ev)
    elif m.group(4) in ROUTINES:
        nn = '%s_%s_%s_%s%s' % (m.group(1), m.group(2), m.group(3), top, m.group(5) or '')
        if nn in taken: left.append((n, 'name taken ' + nn)); continue
        taken.add(nn); why = 'queue-relabel', 'queued here by %s (%s); the earlier name %s' % (top, ev, n)
    elif m.group(4) not in taken_labels:
        why = 'queue-descr', 'queued here by %s (%s); the descriptive name is kept' % (top, ev)
    if why:
        cnt[why[0]] += 1
        out.append(['%02x' % b, '%04x' % a, nn or n, 'C', (r['note'] + '; ' if r['note'] else '') + 'L3 ' + why[0] + ': ' + why[1], 'checked6: ' + r.get('source', '')])
print(dict(cnt), '| left:', len(left))
if dry:
    for x in out: print('  ', x[0] + ':' + x[1], x[2], '|', x[4][-150:])
    for x in left: print('   left', x)
else:
    p = D + 'sym_names_%s_checked.csv' % S; keep = [l for l in open(p, encoding='utf-8') if 'checked6: ' not in l]
    open(p, 'w', encoding='utf-8').write(''.join(keep))
    with open(p, 'a', newline='', encoding='utf-8') as fh: csv.writer(fh, lineterminator='\n').writerows(out)
