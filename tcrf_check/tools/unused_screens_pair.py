#!/usr/bin/env python3
"""The two unused full screens of the Japanese ROM side by side, large (README, under the sheet of the never-reached assets; docs 16.24).

  tcrf_check/tools/unused_screens_pair.py [OUT.png]   (default tcrf_check/assets/unidentified/unused_screens_pair.png)

Left: the alternate stand-by screen of the image exchange (mode $0E), map 23:5CC0 drawn through the tile set 14:4000-502F
(23_5CC0_map_screen.png, tcrf_check/tools/map_23_5CC0_screen.py: a direct draw of the ROM bytes). Right: the one-page main menu with the
"DEBA GAME" logo, map 25:7820 with the tiles 17:5500 (25_7820_map_screen.png: BGB, patched-ROM capture). Both are 160 x 144 at 6x, grey
palette; neither has a loader in either ROM. This script only lays the two existing pictures out with a caption each.
"""
import os, sys
from PIL import Image, ImageDraw, ImageFont
HERE = os.path.dirname(os.path.abspath(__file__)); A = os.path.join(os.path.dirname(HERE), 'assets', 'unidentified')
OUT = sys.argv[1] if len(sys.argv) > 1 else os.path.join(A, 'unused_screens_pair.png')
L = Image.open(os.path.join(A, '23_5CC0_map_screen.png')).convert('L'); R = Image.open(os.path.join(A, '25_7820_map_screen.png')).convert('L')
def fnt(sz, bold=True):
    for q in ('/usr/share/fonts/truetype/dejavu/DejaVuSans%s.ttf' % ('-Bold' if bold else ''), '/usr/share/fonts/dejavu/DejaVuSans%s.ttf' % ('-Bold' if bold else '')):
        if os.path.exists(q): return ImageFont.truetype(q, sz)
    return ImageFont.load_default(size=sz)
f1, f2 = fnt(30), fnt(21, False)
M, GAP, TOP = 24, 32, 110
im = Image.new('L', (2 * M + L.width + GAP + R.width, TOP + max(L.height, R.height) + M), 255); d = ImageDraw.Draw(im)
for x, pic, t1, t2, t3 in ((M, L, 'Unused image-exchange stand-by screen', 'map 23:5CC0 + tiles 14:4000-502F (mode $0E); drawn from the ROM bytes',
                            'no code loads the map or the tiles, in either ROM'),
                           (M + L.width + GAP, R, 'Unused one-page main menu ("DEBA GAME")', 'map 25:7820 + tiles 17:5500-67FF; BGB, patched-ROM capture',
                            'no code loads the map or the tiles, in either ROM')):
    d.text((x, 14), t1, fill=0, font=f1); d.text((x, 54), t2, fill=70, font=f2); d.text((x, 80), t3, fill=70, font=f2)
    im.paste(pic, (x, TOP)); d.rectangle([x - 1, TOP - 1, x + pic.width, TOP + pic.height], outline=0, width=2)
im.save(OUT, optimize=True); print(OUT, im.size)
