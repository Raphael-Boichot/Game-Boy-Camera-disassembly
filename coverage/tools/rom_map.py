#!/usr/bin/env python3
"""Classify every ROM byte. Usage: rom_map.py OUTDIR merged_cov.npz  -> rom_map.csv (run-length ranges) + rom_map_summary.md
Classes: C code executed organically | F code executed only with forced state | N traced code never executed | T inline table |
         R data read (organically) | r data read only with forced state | U untouched (neither traced, executed nor read)"""
import sys as _s, os as _o
_s.path.insert(0, _o.path.join(_o.path.dirname(_o.path.abspath(__file__)), '..', 'src'))
import paths
import sys, os, json, csv
import numpy as np
OUT, cov = sys.argv[1], sys.argv[2]
def flat(b, a): return a if b == 0 and a < 0x4000 else b * 0x4000 + (a - 0x4000)
t = json.load(open(paths.TRACE))
N = 1 << 20; code = np.zeros(N, bool); tab = np.zeros(N, bool)
for k, n in t['code'].items():
    b, a = k.split(':'); f = flat(int(b, 16), int(a, 16))
    if n > 0: code[f:f + n] = True
    else: tab[f:f - n] = True
z = np.load(cov); ex, oex, dr, odr = z['ex'], z['oex'], z['dr'], z['odr']
cls = np.full(N, ord('U'), np.uint8)
cls[(dr != 0)] = ord('r'); cls[(odr != 0)] = ord('R')
cls[tab] = ord('T')
cls[code] = ord('N'); cls[code & (ex != 0)] = ord('F'); cls[code & (oex != 0)] = ord('C')
# executed bytes that are not traced code (should be none)
stray = (ex != 0) & ~code
rows = []; s = 0
for i in range(1, N + 1):
    if i == N or cls[i] != cls[s] or (i & 0x3FFF) == 0:
        b = s >> 14; a = (s & 0x3FFF) + (0x4000 if b else 0)
        rows.append((b, a, i - s, chr(cls[s]))); s = i
with open(os.path.join(OUT, 'rom_map.csv'), 'w', newline='') as fh:
    w = csv.writer(fh); w.writerow(['bank', 'start', 'length', 'class']); [w.writerow(['%02X' % b, '%04X' % a, l, c]) for b, a, l, c in rows]
L = ['# ROM byte classes after the coverage run\n', 'Executed bytes outside traced code: **%d**\n' % int(stray.sum()),
     '| bank | C organic code | F forced-only code | N never-run code | T tables | R read (organic) | r read (forced only) | U untouched |', '|---|---|---|---|---|---|---|---|']
tot = {c: 0 for c in 'CFNTRrU'}
for b in range(64):
    seg = cls[b * 0x4000:(b + 1) * 0x4000]; cnt = {c: int((seg == ord(c)).sum()) for c in 'CFNTRrU'}
    for c in cnt: tot[c] += cnt[c]
    L.append('| %02X | %s |' % (b, ' | '.join(str(cnt[c]) for c in 'CFNTRrU')))
L.append('| **all** | %s |' % ' | '.join('**%d**' % tot[c] for c in 'CFNTRrU'))
open(os.path.join(OUT, 'rom_map_summary.md'), 'w').write('\n'.join(L) + '\n'); print('\n'.join(L[-3:]))
