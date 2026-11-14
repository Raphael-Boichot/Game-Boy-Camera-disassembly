#!/usr/bin/env python3
"""tile_view.py OUT.png ROM  BANK:ADDR:NBYTES[:COLS] ...  -> labelled strips of 2bpp tiles (4x), tinted red where the bytes were never read (needs COV via env GBCOV)"""
import sys, os, numpy as np
from PIL import Image, ImageDraw
rom = open(sys.argv[2], 'rb').read(); cov = os.environ.get('GBCOV')
touched = None
if cov:
    z = np.load(cov); touched = (z['dr'] != 0) | (z['ex'] != 0); org = (z['odr'] != 0) | (z['oex'] != 0)
PAL = [255, 170, 85, 0]
def tiles(bank, addr, nbytes, cols=16, scale=4):
    base = (bank * 0x4000 + addr - 0x4000) if addr >= 0x4000 else addr
    n = nbytes // 16; rows = (n + cols - 1) // cols
    im = Image.new('RGB', (cols * 8, rows * 8), (255, 255, 255)); px = im.load()
    for t in range(n):
        o = base + t * 16; seen = True if touched is None else bool(touched[o:o + 16].all())
        for y in range(8):
            b0 = rom[o + y * 2]; b1 = rom[o + y * 2 + 1]
            for x in range(8):
                v = ((b1 >> (7 - x)) & 1) << 1 | ((b0 >> (7 - x)) & 1); g = PAL[v]
                px[(t % cols) * 8 + x, (t // cols) * 8 + y] = (g, g, g) if seen else (min(255, g + 60), int(g * .6), int(g * .6))
    return im.resize((im.width * scale, im.height * scale), Image.NEAREST)
if __name__ == '__main__':
    items = []
    for s in sys.argv[3:]:
        p = s.split(':'); b = int(p[0], 16); a = int(p[1], 16); n = int(p[2], 16); c = int(p[3]) if len(p) > 3 else 16
        items.append((s, tiles(b, a, n, c)))
    W = max(i.width for _, i in items) + 8; H = sum(i.height + 16 for _, i in items) + 8
    M = Image.new('RGB', (W, H), (90, 90, 140)); d = ImageDraw.Draw(M); y = 4
    for s, i in items:
        d.text((4, y), s, fill=(255, 255, 0)); M.paste(i, (4, y + 12)); y += i.height + 16
    M.save(sys.argv[1]); print(sys.argv[1], M.size)
