#!/usr/bin/env python3
"""TCRF "Unused R!R!R! star" (checklist B18): the picture is 14 x 14 = a 1 px margin around a 6 x 6 picture at 2x (colours white / grey / black).
Search: every byte offset of the ROM read as an 8 x 16 block (two vertically stacked tiles = one 8 x 16 OBJ), the 6 x 6 picture at every position of it
(white = colour 0, grey = colour 1, black = colour 3, the mapping seen in the star), everything else of the block blank except the row and the column right of
and below the picture (the picture is the top-left 6 x 6 of a 7 x 7 star).  A single tile never holds the star: it straddles two tiles.
usage: run_star_pair.py TCRF_PNG ROM.gb OUT.png OUT.csv"""
import sys, csv
import numpy as np
from PIL import Image
png, romf, outpng, outcsv = sys.argv[1:5]
a = np.array(Image.open(png).convert('L'))[1:-1, 1:-1][::2, ::2]
lv = np.full(a.shape, 0, np.uint8); lv[a < 64] = 3; lv[(a >= 64) & (a < 200)] = 1
h, w = lv.shape; print('picture %d x %d' % (h, w)); print('\n'.join(''.join('.+*#'[v] for v in r) for r in lv))
rom = open(romf, 'rb').read(); R = np.frombuffer(rom, np.uint8)
def ba(o): return '%02X:%04X' % (o >> 14, 0x4000 + (o & 0x3FFF)) if o >> 14 else '00:%04X' % o
hits = []; CH = 1 << 18
for s in range(0, len(R) - 31, CH):
    e = min(len(R) - 31, s + CH)
    B = np.lib.stride_tricks.sliding_window_view(R[s:e + 31], 32)           # (n, 32)
    n = B.shape[0]; T = np.zeros((n, 16, 8), np.uint8)
    for y in range(16):
        for x in range(8): T[:, y, x] = (((B[:, 2 * y + 1] >> (7 - x)) & 1) << 1) | ((B[:, 2 * y] >> (7 - x)) & 1)
    for dy in range(16 - h):
        for dx in range(8 - w):
            m = np.ones((16, 8), bool); m[dy:dy + h + 1, dx:dx + w + 1] = False       # outside the picture and its right / lower neighbour: blank
            ok = (T[:, dy:dy + h, dx:dx + w] == lv[None]).all((1, 2)) & (T[:, m] == 0).all(1)
            for i in np.nonzero(ok)[0]: hits.append((s + int(i), dy, dx))
print('hits (an 8 x 16 block holding the picture, rest blank):', len(hits))
rows = []
for o, dy, dx in sorted(hits):
    ex = np.zeros((16, 8), np.uint8)
    for y in range(16):
        for x in range(8): ex[y, x] = (((rom[o + 2 * y + 1] >> (7 - x)) & 1) << 1) | ((rom[o + 2 * y] >> (7 - x)) & 1)
    right = ex[dy:dy + h + 1, dx + w].tolist(); below = ex[dy + h, dx:dx + w + 1].tolist()
    rows.append([ba(o), 'aligned tile pair' if o % 16 == 0 else 'the same star seen %d row(s) lower: not a tile boundary' % (o % 16 // 2), 'at (%d,%d)' % (dy, dx), 'right column %s, lower row %s' % (right, below)])
    print(rows[-1])
with open(outcsv, 'w', newline='') as f:
    wr = csv.writer(f); wr.writerow(['block_address', 'alignment', 'position_in_8x16', 'neighbour_pixels']); wr.writerows(rows)
al = [o for o, _, _ in hits if o % 16 == 0]
if al:
    o = al[0]; ex = np.zeros((16, 8), np.uint8)
    for y in range(16):
        for x in range(8): ex[y, x] = (((rom[o + 2 * y + 1] >> (7 - x)) & 1) << 1) | ((rom[o + 2 * y] >> (7 - x)) & 1)
    pal = np.array([255, 190, 110, 20], np.uint8); S = 16
    left = np.kron(pal[lv], np.ones((S, S), np.uint8)); right = np.kron(pal[ex], np.ones((S, S), np.uint8))
    canvas = np.full((max(left.shape[0], right.shape[0]) + 8, left.shape[1] + right.shape[1] + 30), 255, np.uint8)
    canvas[4:4 + left.shape[0], 4:4 + left.shape[1]] = left; canvas[4:4 + right.shape[0], left.shape[1] + 26:left.shape[1] + 26 + right.shape[1]] = right
    Image.fromarray(canvas).save(outpng); print('wrote', outpng)
