#!/usr/bin/env python3
"""The most interesting unused pictures of the Hello Kitty ROM, one picture for the main README (2026-11-12):
roms/hello_kitty/assets/highlights_kitty.png.

  tools/kitty_unused_highlights.py KITTY.gb [--check]

  11:6000  Unused_Photo_EmptyPicture0_Gfx: record 0 of the table 00:249D, never requested (drawn from the ROM: 224 tiles, 16 per row)
  11:7000  Gfx_11_7000_Photo_LoadEmptyPicture: record 1, the picture for a photo slot without a photo (drawn from the ROM)
  mode $17 the print error screen and mode $18 the Pompompurin picture: BGB screenshots with the mode byte forced
           (screens/extra_17_01.png, screens/extra_18_01.png; no code enters mode $18, Unused_Mode18_*)
"""
import argparse, io, os, sys
from PIL import Image, ImageDraw, ImageFont
HERE = os.path.dirname(os.path.abspath(__file__)); KD = os.path.join(os.path.dirname(HERE), 'roms', 'hello_kitty')
OUT = os.path.join(KD, 'assets', 'highlights_kitty.png')
ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('--check', action='store_true'); a = ap.parse_args()
R = open(a.rom, 'rb').read()
def pic(b, ad, n):
    o = b * 0x4000 + ad - 0x4000; t = n // 16; im = Image.new('L', (128, (t + 15) // 16 * 8), 255); pal = (255, 170, 85, 0)
    for k in range(t):
        for y in range(8):
            lo, hi = R[o + k * 16 + 2 * y], R[o + k * 16 + 2 * y + 1]
            for x in range(8): im.putpixel((k % 16 * 8 + x, k // 16 * 8 + y), pal[((lo >> (7 - x)) & 1) | (((hi >> (7 - x)) & 1) << 1)])
    return im.convert('RGB')
items = [('11:6000, never requested', pic(0x11, 0x6000, 0xE00)), ('11:7000, a photo slot without a photo', pic(0x11, 0x7000, 0xE00)),
         ('mode $17, print error (BGB, forced)', Image.open(os.path.join(KD, 'screens', 'extra_17_01.png')).convert('RGB')),
         ('mode $18, Pompompurin (BGB, forced)', Image.open(os.path.join(KD, 'screens', 'extra_18_01.png')).convert('RGB'))]
p = '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf'; F = ImageFont.truetype(p, 13) if os.path.exists(p) else ImageFont.load_default()
S = 2; GAP = 16; W = sum(max(i.width * S, 180) for _, i in items) + GAP * (len(items) + 1); H = max(i.height for _, i in items) * S + 40
im = Image.new('RGB', (W, H), (255, 255, 255)); d = ImageDraw.Draw(im); x = GAP
for cap, i in items:
    d.text((x, 8), cap, fill=(0, 0, 0), font=F); im.paste(i.resize((i.width * S, i.height * S), Image.NEAREST), (x, 30)); x += max(i.width * S, 180) + GAP
buf = io.BytesIO(); im.save(buf, 'PNG', optimize=True)
if a.check:
    ok = os.path.exists(OUT) and open(OUT, 'rb').read() == buf.getvalue(); print('kitty_unused_highlights: %s' % ('fresh' if ok else 'differs: ' + OUT)); sys.exit(0 if ok else 1)
open(OUT, 'wb').write(buf.getvalue()); print('kitty_unused_highlights: %s' % OUT)
