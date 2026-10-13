#!/usr/bin/env python3
"""Find the tile block that a de-duplicated picture map was made for: for every 16-byte offset S of the ROM, tile id i is taken from S + 16 i and the edges of
neighbouring cells of the map are compared (right column of the left tile with the left column of the right one, bottom row with top row); the block whose
seams are the smoothest AND whose used tiles are all different (a de-duplicated set has no repeated tile) wins.  Control (README 16.25): the credits picture
26:72C0 gives 19:5260 (0.42 per pixel) against 0.655 for the next block; 25:7814 gives 17:5500 (0.427 against 0.713).  Blocks split in two halves (ids 0-127 / 128-255 in
different places) are not covered; 26:7080 returns nothing convincing (best 0.80).
usage: tile_seam_search.py ROM BANK:ADDR [first_col=0 [cols=20 [rows=18 [width=32]]]]      e.g.  tile_seam_search.py pocketcamera_jp.gb 25:7814 12"""
import sys
import numpy as np
rom = np.frombuffer(open(sys.argv[1], 'rb').read(), dtype=np.uint8)
bank, addr = [int(x, 16) for x in sys.argv[2].split(':')]
x0 = int(sys.argv[3]) if len(sys.argv) > 3 else 0
cols = int(sys.argv[4]) if len(sys.argv) > 4 else 20
rows = int(sys.argv[5]) if len(sys.argv) > 5 else 18
W = int(sys.argv[6]) if len(sys.argv) > 6 else 32
N = len(rom) // 16
t = rom[:N * 16].reshape(N, 8, 2)
T = np.zeros((N, 8, 8), dtype=np.int16)
for x in range(8): T[:, :, x] = ((t[:, :, 1] >> (7 - x)) & 1) * 2 + ((t[:, :, 0] >> (7 - x)) & 1)
Lc, Rc, TOP, BOT = T[:, :, 0], T[:, :, 7], T[:, 0, :], T[:, 7, :]
o = bank * 0x4000 + addr - 0x4000
g = rom[o:o + W * rows].reshape(rows, W)[:, x0:x0 + cols]
pairs = set()
for y in range(rows):
    for x in range(cols):
        a = int(g[y, x])
        if x + 1 < cols and g[y, x + 1] != a: pairs.add(('h', a, int(g[y, x + 1])))
        if y + 1 < rows and g[y + 1, x] != a: pairs.add(('v', a, int(g[y + 1, x])))
ids = sorted(set(int(v) for v in g.ravel()))
n = N - (max(ids) + 1)
cost = np.zeros(n, dtype=np.int32)
for k, a, b in pairs:
    cost += (np.abs(Rc[a:a + n] - Lc[b:b + n]) if k == 'h' else np.abs(BOT[a:a + n] - TOP[b:b + n])).sum(axis=1).astype(np.int32)
print('%d distinct ids, %d seams' % (len(ids), len(pairs)))
shown = 0
for s in np.argsort(cost):
    if len(set(bytes(rom[s * 16 + 16 * i:s * 16 + 16 * i + 16]) for i in ids)) < len(ids): continue
    a = int(s) * 16
    print('  %02X:%04X  %.3f per pixel' % (a // 0x4000, 0x4000 + a % 0x4000, cost[s] / len(pairs) / 8)); shown += 1
    if shown == 6: break
