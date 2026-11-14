#!/usr/bin/env python3
"""Render tiles as 8x16 glyph pairs (tile 2k above tile 2k+1): glyph_pairs.py ROM BANK:ADDR:NTILES [..] OUT.png [scale]"""
import sys
from PIL import Image, ImageDraw
rom = open(sys.argv[1], 'rb').read(); out = sys.argv[-2] if sys.argv[-1].isdigit() else sys.argv[-1]
scale = int(sys.argv[-1]) if sys.argv[-1].isdigit() else 3
specs = [a for a in sys.argv[2:] if ':' in a]
PAL = [255, 170, 85, 0]
def tile(off):
    im = Image.new('L', (8, 8)); px = im.load()
    for y in range(8):
        b0 = rom[off + 2 * y]; b1 = rom[off + 2 * y + 1]
        for x in range(8): px[x, y] = PAL[((b1 >> (7 - x)) & 1) << 1 | ((b0 >> (7 - x)) & 1)]
    return im
rows = []
for s in specs:
    b, a, n = s.split(':'); b = int(b, 16); a = int(a, 16); n = int(n, 0)
    base = (b * 0x4000 + a - 0x4000) if b else a
    rows.append((s, [tile(base + 16 * i) for i in range(n)]))
W = max((len(t) + 1) // 2 for _, t in rows) * 8 + 4
S = Image.new('RGB', (W * 1, sum(26 for _ in rows) + 4), (90, 90, 140)); d = ImageDraw.Draw(S); y = 2
for s, ts in rows:
    d.text((2, y), s, fill=(255, 255, 0)); y += 10
    for k, t in enumerate(ts): S.paste(t.convert('RGB'), (2 + (k // 2) * 8, y + (k % 2) * 8))
    y += 16
S = S.resize((S.width * scale, S.height * scale), Image.NEAREST); S.save(out); print(out, S.size)
