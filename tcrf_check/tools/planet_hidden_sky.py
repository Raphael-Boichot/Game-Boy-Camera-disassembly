#!/usr/bin/env python3
"""The hidden sky of the international USER planet map (TCRF, Regional Differences, "Space"; docs/20).

  tcrf_check/tools/planet_hidden_sky.py WORKDIR [OUT.png]     (default tcrf_check/assets/hidden/planet_hidden_sky.png)

WORKDIR holds the BGB runs of ~/work/port/planet/run.py: us.bmp / us.sna and jp.sna (blank save, A, Start, 300 frames: mode 08:01).
In the international screen the top three BG rows are black (the planet name is repeated there), yet BGB's VRAM still holds the 47 tiles
of the Japanese top rows (the sun and the outer orbits; from the tile set 0F:4000-4300 / 0F:4D00, 43 of them byte-equal to Japanese tiles).
Left: the BGB screenshot of the international ROM. Right: the same VRAM drawn with the Japanese map rows 0-2 put back, i.e. the part of
the space picture that the international build still loads but never shows (BG only: the window and sprites of the label are not drawn).
"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import bgb_run
from PIL import Image, ImageDraw, ImageFont
W = sys.argv[1]; OUT = sys.argv[2] if len(sys.argv) > 2 else os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'assets', 'hidden', 'planet_hidden_sky.png')
GREY = (255, 170, 85, 0); BGB = {(20, 44, 56): 0, (84, 140, 112): 85, (172, 212, 144): 170, (232, 252, 204): 255}
def addr(t): return 0x1000 + t * 16 if t < 128 else 0x800 + (t - 128) * 16
vu = bgb_run.read_state(os.path.join(W, 'us.sna'))['VRAM']; vj = bgb_run.read_state(os.path.join(W, 'jp.sna'))['VRAM']
M = bytearray(vu[0x1800:0x1C00]); MJ = vj[0x1800:0x1C00]
for ty in range(3): M[ty * 32:ty * 32 + 32] = MJ[ty * 32:ty * 32 + 32]
R = Image.new('L', (160, 144)); px = R.load()
for ty in range(18):
    for tx in range(20):
        b = addr(M[ty * 32 + tx])
        for y in range(8):
            lo, hi = vu[b + 2 * y], vu[b + 2 * y + 1]
            for x in range(8): px[tx * 8 + x, ty * 8 + y] = GREY[((lo >> (7 - x)) & 1) | (((hi >> (7 - x)) & 1) << 1)]
s = Image.open(os.path.join(W, 'us.bmp')).convert('RGB'); L = Image.new('L', s.size); L.putdata([BGB.get(c, 128) for c in s.getdata()])
S = 4; M_, GAP, TOP = 24, 32, 90
im = Image.new('L', (2 * M_ + 2 * 160 * S + GAP, TOP + 144 * S + M_), 255); d = ImageDraw.Draw(im)
def fnt(sz, bold=True):
    q = '/usr/share/fonts/truetype/dejavu/DejaVuSans%s.ttf' % ('-Bold' if bold else '')
    return ImageFont.truetype(q, sz) if os.path.exists(q) else ImageFont.load_default(size=sz)
for i, (pic, t1, t2) in enumerate(((L, 'International USER map (BGB)', 'the top three rows are black'), (R, 'Same VRAM, Japanese top rows put back', '47 loaded tiles never shown: the sun and orbits'))):
    x = M_ + i * (160 * S + GAP); d.text((x, 14), t1, fill=0, font=fnt(28)); d.text((x, 52), t2, fill=70, font=fnt(22, False))
    im.paste(pic.resize((160 * S, 144 * S), Image.NEAREST), (x, TOP)); d.rectangle([x - 1, TOP - 1, x + 160 * S, TOP + 144 * S], outline=0, width=2)
im.save(OUT, optimize=True); print(OUT, im.size)
