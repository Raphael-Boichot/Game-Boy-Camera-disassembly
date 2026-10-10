#!/usr/bin/env python3
"""delta_cov.py BASE_COV.npz NEW_COV.npz [--organic]: ROM bytes executed / read by NEW but not by BASE, as ranges with bank:addr; instruction-level via the static trace."""
import sys, json, numpy as np, os
base = np.load(sys.argv[1]); new = np.load(sys.argv[2]); org = '--organic' in sys.argv
ex_new = (new['oex'] if org else new['ex']) != 0; ex_base = (base['ex'] != 0)
dr_new = (new['odr'] if org else new['dr']) != 0; dr_base = (base['dr'] != 0)
def addr(o):
    b = o // 0x4000; return '%02X:%04X' % (b, (o % 0x4000) + (0x4000 if b else 0))
def runs(mask, gap=0):
    idx = np.flatnonzero(mask); out = []
    if not len(idx): return out
    s = p = idx[0]
    for i in idx[1:]:
        if i > p + 1 + gap: out.append((s, p + 1)); s = i
        p = i
    out.append((s, p + 1)); return out
exn = ex_new & ~ex_base; drn = dr_new & ~dr_base
print('new executed bytes', int(exn.sum()), 'new data-read bytes', int(drn.sum()))
t = json.load(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'package', 'wram', 'trace_jp_v3.json')))
ins = 0
for k, n in t['code'].items():
    b, a = k.split(':'); b = int(b, 16); a = int(a, 16); o = a if b == 0 and a < 0x4000 else b * 0x4000 + a - 0x4000
    if exn[o]: ins += 1
print('new traced instructions executed', ins)
print('-- executed ranges'); 
for s, e in runs(exn, gap=3): print(addr(s), addr(e - 1), e - s)
print('-- data-read ranges (gap<=32)')
for s, e in runs(drn, gap=32):
    if e - s >= 16: print(addr(s), addr(e - 1), e - s)
