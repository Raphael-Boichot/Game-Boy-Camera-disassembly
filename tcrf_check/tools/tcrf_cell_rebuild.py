#!/usr/bin/env python3
"""Rebuild a TCRF picture from ROM tiles, cell by cell, and draw picture / rebuild / difference (README 16.24, checklist B06 / B13).

usage: tcrf_cell_rebuild.py ROM PICTURE.png OUT.png [--scale 2] [--box BB:AAAA:COLS:ROWS]
  The picture is reduced by --scale (TCRF pictures are often 2x enlargements), its grey levels are mapped to colours 0-3 (lightest = 0), and every
  non-blank 8 x 8 cell of every grid offset (0-7, 0-7) is looked up as an exact 16-byte tile anywhere in the ROM; the offset with the most hits wins.
  A partial cell at the right or bottom edge is matched against the same part of the tiles (the first hit is used).  OUT shows the picture, the picture
  rebuilt from the found tiles and the pixels that differ; --box outlines a block of tiles of the rebuild (e.g. 13:5CA0:6:1, the label's six tiles, top-left).
  Prints one line per cell (x, y, ROM address or '--') and the number of pixels that differ.
Example (2026-10-25): tcrf_cell_rebuild.py pocketcamera_jp.gb Unused_graphics_TCRF/Game_Boy_Camera_Unused_Album_Hand_Gestures.png
  tcrf_check/assets/unidentified/13_5CA0_hand_gestures_check.png --box 13:5CA0:6:1  ->  31 cells + the left half of 13:5A50, all in 13:5A00-5FFF, 0 pixels differ."""
import sys, collections
import numpy as np
from PIL import Image, ImageDraw, ImageFont
a = sys.argv[1:]
def opt(n, d=None):
    if n in a: i = a.index(n); v = a[i + 1]; del a[i:i + 2]; return v
    return d
SC = int(opt('--scale', '2')); BOX = opt('--box')
romf, picf, outf = a[:3]
rom = open(romf, 'rb').read()
def ba(o): return '%02X:%04X' % (o >> 14, 0x4000 + (o & 0x3FFF)) if o >> 14 else '00:%04X' % o
def tile(o):
    t = np.zeros((8, 8), np.uint8)
    for y in range(8):
        lo, hi = rom[o + 2 * y], rom[o + 2 * y + 1]
        for x in range(8): t[y, x] = ((hi >> (7 - x)) & 1) << 1 | ((lo >> (7 - x)) & 1)
    return t
def enc(c):
    b = bytearray()
    for y in range(8):
        lo = hi = 0
        for x in range(8): v = int(c[y, x]); lo |= (v & 1) << (7 - x); hi |= ((v >> 1) & 1) << (7 - x)
        b += bytes([lo, hi])
    return bytes(b)
TILES = collections.defaultdict(list)
for o in range(0, len(rom) - 15, 16): TILES[rom[o:o + 16]].append(o)
g = np.array(Image.open(picf).convert('L'))[::SC, ::SC]
lv = sorted(set(g.flatten().tolist()), reverse=True)
P = np.vectorize({v: i for i, v in enumerate(lv)}.get)(g).astype(np.uint8)
H, W = P.shape
best = None
for oy in range(8):
    for ox in range(8):
        cells = []
        for y0 in range(oy, H - 7, 8):
            for x0 in range(ox, W - 7, 8):
                c = P[y0:y0 + 8, x0:x0 + 8]
                if (c == 0).all(): continue
                cells.append((x0, y0, TILES.get(enc(c), [])))
        n = sum(1 for c in cells if c[2])
        if best is None or n > best[0]: best = (n, ox, oy, cells)
n, ox, oy, cells = best
Rb = np.zeros_like(P)
for x0, y0, h in cells:
    if h: Rb[y0:y0 + 8, x0:x0 + 8] = tile(h[0])
    print('%3d %3d %s' % (x0, y0, ba(h[0]) if h else '--'))
# partial cells at the right and bottom edges (narrower or shorter than 8 pixels)
for y0 in range(oy, H, 8):
    for x0 in range(ox, W, 8):
        w, h = min(8, W - x0), min(8, H - y0)
        if w == 8 and h == 8: continue
        c = P[y0:y0 + h, x0:x0 + w]
        if (c == 0).all(): continue
        hit = next((o for o in range(0, len(rom) - 15, 16) if (tile(o)[:h, :w] == c).all()), None)
        if hit is not None: Rb[y0:y0 + h, x0:x0 + w] = tile(hit)[:h, :w]
        print('%3d %3d %s (partial %dx%d)' % (x0, y0, ba(hit) if hit is not None else '--', w, h))
diff = Rb != P
print('grid offset %d %d, %d cells found of %d, pixels that differ: %d' % (ox, oy, n, len(cells), int(diff.sum())))
G = np.array([255, 170, 85, 0], np.uint8); S = 4
f = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf', 16)
band = H * S + 48; out = Image.new('RGB', (max(960, W * S + 40), band * 3 + 10), 'white'); d = ImageDraw.Draw(out)
for i, (t, img) in enumerate((('TCRF picture (reduced %dx)' % SC, G[P]), ('Rebuilt from ROM tiles', G[Rb]), ('Difference: %d pixels (red would mark a difference)' % int(diff.sum()), None))):
    y0 = i * band + 8; d.text((20, y0), t, fill='black', font=f); py = y0 + 28
    if img is not None:
        out.paste(Image.fromarray(np.kron(img, np.ones((S, S), np.uint8))).convert('RGB'), (20, py))
        if BOX:
            bb, aa, cols, rows = BOX.split(':')
            d.rectangle([20 + ox * S - 2, py + oy * S - 2, 20 + (ox + 8 * int(cols)) * S + 1, py + (oy + 8 * int(rows)) * S + 1], outline=(0, 120, 255), width=3)
            d.text((20 + W * S + 16, py + 8), '<- blue box: %s:%s, %s x %s tiles' % (bb, aa, cols, rows), fill=(0, 90, 200), font=f)
    else:
        im = np.full((H, W, 3), 255, np.uint8); im[diff] = [220, 0, 0]
        out.paste(Image.fromarray(np.kron(im, np.ones((S, S, 1), np.uint8))), (20, py)); d.rectangle([19, py - 1, 20 + W * S, py + H * S], outline='grey')
out.save(outf)
