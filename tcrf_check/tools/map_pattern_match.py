#!/usr/bin/env python3
"""Is a tile map a renumbered copy of another map?  Compares the PATTERN OF REPEATED TILES of a map with every window of the ROM, whatever the tile numbers.
For the target (cols x rows cells of the map at BANK:ADDR, starting at column first_col) the set A of neighbouring cell pairs (right, below) that hold the same id is taken;
for every ROM offset p the same pairs are read at p + 32 row + col, and the Jaccard index of the two sets of equal neighbours (A, and all the equal neighbours of the
window B) is printed: 1.00 = the same pattern, flat fills and padding give a large B and a low index.  The map itself and its own rows (+-2) are skipped.
Result (README 16.25.2): 26:7080 has no look-alike in the Japanese or the international ROM (best 0.41, a flat fill).
usage: map_pattern_match.py ROM BANK:ADDR [first_col=0 [cols=20 [rows=18]]]"""
import sys
import numpy as np
rom = np.frombuffer(open(sys.argv[1], 'rb').read(), dtype=np.uint8)
bank, addr = [int(x, 16) for x in sys.argv[2].split(':')]
x0 = int(sys.argv[3]) if len(sys.argv) > 3 else 0
cols = int(sys.argv[4]) if len(sys.argv) > 4 else 20
rows = int(sys.argv[5]) if len(sys.argv) > 5 else 18
o = bank * 0x4000 + addr - 0x4000
g = rom[o:o + 32 * rows].reshape(rows, 32)[:, x0:x0 + cols]
Ah = [(r, c) for r in range(rows) for c in range(cols - 1) if g[r, c] == g[r, c + 1]]
Av = [(r, c) for r in range(rows - 1) for c in range(cols) if g[r, c] == g[r + 1, c]]
print('target equal-neighbour pairs: %d horizontal, %d vertical' % (len(Ah), len(Av)))
N = len(rom); M = N - 32 * rows - 32
eqh = np.zeros(N + 64, np.int32); eqh[:N - 1] = (rom[:-1] == rom[1:])
eqv = np.zeros(N + 64, np.int32); eqv[:N - 32] = (rom[:-32] == rom[32:])
inter = np.zeros(M, np.int32)
for r, c in Ah: inter += eqh[32 * r + c:32 * r + c + M]
for r, c in Av: inter += eqv[32 * r + c:32 * r + c + M]
ch = np.concatenate([[0], np.cumsum(eqh)]); cv = np.concatenate([[0], np.cumsum(eqv)]); ix = np.arange(M)
B = np.zeros(M, np.int64)
for r in range(rows): B += ch[32 * r + cols - 1 + ix] - ch[32 * r + ix]
for r in range(rows - 1): B += cv[32 * r + cols + ix] - cv[32 * r + ix]
A = len(Ah) + len(Av)
J = inter / (A + B - inter)
me = o + x0; shown = 0
for p in np.argsort(-J):
    if abs(int(p) - me) <= 2 * 32 + 4: continue
    b = int(p) >> 14; a = 0x4000 + (int(p) & 0x3FFF) if b else int(p)
    print('  window origin %02X:%04X  jaccard %.2f  (%d of %d target pairs repeat there, %d repeats in that window)' % (b, a, J[p], inter[p], A, B[p])); shown += 1
    if shown == 6: break
