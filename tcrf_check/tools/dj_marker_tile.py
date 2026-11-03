#!/usr/bin/env python3
"""TCRF "Unused D.J. music tile" (checklist B14): the picture is a 5 x 6 pixel glyph like the katakana め (2x enlargement, 1 px margin).
Search: every byte offset of the ROM as an 8 x 8 tile (2 bits per pixel); a hit = the glyph sits at some position of the tile, the rest of the tile is blank, and
the tile is two-valued (the glyph pixels are one colour value >= 1, everything else is colour 0); all four flips are tried. Writes the sheet of the D.J. performer
graphics (bank 1A, 4000-4D7F, 16 tiles per row, the block 05:438F copies to VRAM $8000) with the hits outlined, and a CSV of the hits.
usage: dj_marker_tile.py TCRF_PNG JP.gb INTL.gb OUT.png OUT.csv"""
import sys, csv
import numpy as np
from PIL import Image
png, jpf, itf, outpng, outcsv = sys.argv[1:6]
a = np.array(Image.open(png).convert('L'))[1:-1, 1:-1]
g = (a[::2, ::2] < 128)
assert (np.repeat(np.repeat(g, 2, 0), 2, 1) == (a < 128)).all()
h, w = g.shape
print('glyph %d x %d' % (h, w)); print('\n'.join(''.join('#' if v else '.' for v in r) for r in g))
def addr(o): return '%02X:%04X' % (o >> 14, 0x4000 + (o & 0x3FFF)) if o >> 14 else '00:%04X' % o
def tile_at(rom, o):
    t = np.zeros((8, 8), np.uint8)
    for y in range(8):
        lo, hi = rom[o + 2 * y], rom[o + 2 * y + 1]
        for x in range(8): t[y, x] = ((hi >> (7 - x)) & 1) * 2 + ((lo >> (7 - x)) & 1)
    return t
def hits(rom):
    R = np.frombuffer(rom, np.uint8); N = len(R) - 15
    B = np.lib.stride_tricks.sliding_window_view(R, 16); b0 = B[:, 0::2]; b1 = B[:, 1::2]
    T = np.zeros((N, 8, 8), np.uint8)
    for x in range(8): T[:, :, x] = (((b1 >> (7 - x)) & 1) << 1) | ((b0 >> (7 - x)) & 1)
    out = {}
    for fl in range(4):
        gg = g[:, ::-1] if fl & 1 else g
        gg = gg[::-1, :] if fl & 2 else gg
        for dy in range(8 - h + 1):
            for dx in range(8 - w + 1):
                pat = np.zeros((8, 8), bool); pat[dy:dy + h, dx:dx + w] = gg
                ink = T * pat[None]                              # colours under the glyph
                ok = ((T > 0) == pat[None]).all((1, 2))           # blank everywhere else, inked under the glyph
                ok &= (np.where(pat[None], T, ink.max((1, 2), keepdims=True)) == ink.max((1, 2), keepdims=True)).all((1, 2))   # one ink colour
                for i in np.nonzero(ok)[0]: out.setdefault(int(i), (fl, dy, dx, int(T[i][pat].max())))
    return out
rows = []
for name, path in (('JP', jpf), ('INTL', itf)):
    rom = open(path, 'rb').read(); H = hits(rom)
    for o in sorted(H):
        fl, dy, dx, col = H[o]
        rows.append([name, addr(o), 'yes' if o % 16 == 0 else 'no (a row-shifted view of a neighbouring tile)', 'flip %d at (%d,%d), colour %d' % (fl, dy, dx, col)])
    al = [o for o in sorted(H) if o % 16 == 0]
    print(name, len(H), 'hits,', len(al), 'tile-aligned:', ' '.join(addr(o) for o in al))
jp = open(jpf, 'rb').read(); H = hits(jp)
base = 0x1A * 0x4000; n = 0xD80 // 16; cols = 16; S = 3
img = np.full(((n + cols - 1) // cols * 8 * S, cols * 8 * S, 3), 255, np.uint8)
pal = np.array([[255, 255, 255], [190, 190, 190], [110, 110, 110], [20, 20, 20]], np.uint8)
for i in range(n):
    t = tile_at(jp, base + 16 * i); r, c = divmod(i, cols)
    img[r * 8 * S:(r + 1) * 8 * S, c * 8 * S:(c + 1) * 8 * S] = np.kron(pal[t], np.ones((S, S, 1), np.uint8))
    if base + 16 * i in H:      # aligned tiles only
        y0, x0 = r * 8 * S, c * 8 * S
        img[y0:y0 + 8 * S, x0:x0 + 2] = (220, 30, 30); img[y0:y0 + 8 * S, x0 + 8 * S - 2:x0 + 8 * S] = (220, 30, 30)
        img[y0:y0 + 2, x0:x0 + 8 * S] = (220, 30, 30); img[y0 + 8 * S - 2:y0 + 8 * S, x0:x0 + 8 * S] = (220, 30, 30)
Image.fromarray(img).save(outpng)
with open(outcsv, 'w', newline='') as f:
    w_ = csv.writer(f); w_.writerow(['rom', 'tile_address', 'on_a_16_byte_tile_boundary', 'placement']); w_.writerows(rows)
print('wrote', outpng, outcsv)
