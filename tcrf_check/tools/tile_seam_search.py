#!/usr/bin/env python3
"""Find the tile block that a de-duplicated picture map was made for: for every 16-byte offset S of the ROM, tile id i is taken from S + 16 i and the edges of
neighbouring cells of the map are compared (right column of the left tile with the left column of the right one, bottom row with top row); the block whose
seams are the smoothest AND whose used tiles are all different (a de-duplicated set has no repeated tile) wins.  Control (README 16.25): the credits picture
26:72C0 gives 19:5260 (0.42 per pixel) against 0.655 for the next block; 25:7820 gives 17:5500 (0.427 against 0.713).  26:7080 returns nothing convincing (best 0.80 per pixel, ratio 0.69; halves 0.52 / 0.57).
--ids LO-HI[,LO-HI...] (hex) searches each id range as a block of its own (tile of id i at S + 16 (i - LO)), counting only the seams whose two ends are in the range:
use it for a tile set that is split (ids 00-7F / 80-FF loaded from two places) or when part of the ids belong to another list.  Every candidate then also gets a control:
the same seams with the ids of the neighbours shuffled; a true block has a cost far below its control (ratio 0.33-0.37 for the credits picture 00-7F and the unused menu 00-7F,
0.46 or more for the next block there), a smooth or flat region has a ratio near 1 whatever the map.  The ranges are ranked by that ratio.  The upper halves are a weak test: for the
credits picture 80-FF and the unused menu 80-E9 the true block is not ranked first (wrong blocks reach 0.40 and 0.49), so only a negative lower half (00-7F) or whole map is evidence.
--1bpp reads the ROM as 8-byte one-plane tiles (README 16.25.2: no 1bpp block fits 26:7080 either).
usage: tile_seam_search.py ROM BANK:ADDR [first_col=0 [cols=20 [rows=18 [width=32]]]] [--ids 00-7F,80-FF] [--1bpp]      e.g.  tile_seam_search.py pocketcamera_jp.gb 25:7820"""
import sys
import numpy as np
argv = sys.argv[:]; ranges = None; BPP1 = '--1bpp' in argv
if BPP1: argv.remove('--1bpp')
if '--ids' in argv:
    k = argv.index('--ids'); ranges = [tuple(int(v, 16) for v in a.split('-')) for a in argv[k + 1].split(',')]; del argv[k:k + 2]
rom = np.frombuffer(open(argv[1], 'rb').read(), dtype=np.uint8)
bank, addr = [int(x, 16) for x in argv[2].split(':')]
x0 = int(argv[3]) if len(argv) > 3 else 0
cols = int(argv[4]) if len(argv) > 4 else 20
rows = int(argv[5]) if len(argv) > 5 else 18
W = int(argv[6]) if len(argv) > 6 else 32
TS = 8 if BPP1 else 16
N = len(rom) // TS
T = np.zeros((N, 8, 8), dtype=np.int16)
if BPP1:
    t = rom[:N * 8].reshape(N, 8)
    for x in range(8): T[:, :, x] = ((t >> (7 - x)) & 1) * 3
else:
    t = rom[:N * 16].reshape(N, 8, 2)
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
if ranges:
    for lo, hi in ranges:
        pp = [(k, a - lo, b - lo) for k, a, b in pairs if lo <= a <= hi and lo <= b <= hi]
        ids = sorted(set(i for k, a, b in pp for i in (a, b))); n = N - (max(ids) + 1)
        cost = np.zeros(n, dtype=np.int32); cost2 = np.zeros(n, dtype=np.int32); perm = dict(zip(ids, np.random.default_rng(1).permutation(ids)))
        for k, a, b in pp:
            b2 = int(perm[b]); L, R_ = (Rc, Lc) if k == 'h' else (BOT, TOP)
            cost += np.abs(L[a:a + n] - R_[b:b + n]).sum(axis=1).astype(np.int32); cost2 += np.abs(L[a:a + n] - R_[b2:b2 + n]).sum(axis=1).astype(np.int32)
        ratio = cost / np.maximum(cost2, 1)
        print('ids %02X-%02X: %d ids, %d seams' % (lo, hi, len(ids), len(pp))); shown = 0
        for s_ in np.argsort(ratio):
            if len(set(bytes(rom[s_ * TS + TS * i:s_ * TS + TS * i + TS]) for i in ids)) < len(ids): continue
            a_ = int(s_) * TS
            print('  %02X:%04X (tile of id %02X)  %.3f per pixel, shuffled control %.3f, ratio %.2f' % (a_ // 0x4000, 0x4000 + a_ % 0x4000, lo, cost[s_] / len(pp) / 8, cost2[s_] / len(pp) / 8, ratio[s_])); shown += 1
            if shown == 6: break
    sys.exit()
ids = sorted(set(int(v) for v in g.ravel()))
n = N - (max(ids) + 1)
cost = np.zeros(n, dtype=np.int32)
for k, a, b in pairs:
    cost += (np.abs(Rc[a:a + n] - Lc[b:b + n]) if k == 'h' else np.abs(BOT[a:a + n] - TOP[b:b + n])).sum(axis=1).astype(np.int32)
print('%d distinct ids, %d seams' % (len(ids), len(pairs)))
shown = 0
for s in np.argsort(cost):
    if len(set(bytes(rom[s * TS + TS * i:s * TS + TS * i + TS]) for i in ids)) < len(ids): continue
    a = int(s) * TS
    print('  %02X:%04X  %.3f per pixel' % (a // 0x4000, 0x4000 + a % 0x4000, cost[s] / len(pairs) / 8)); shown += 1
    if shown == 6: break
