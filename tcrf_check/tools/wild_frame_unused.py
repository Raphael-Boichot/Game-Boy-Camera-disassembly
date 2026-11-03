#!/usr/bin/env python3
"""The unused 8th wild frame of the international ROM (and Gold): a second copy of the Super Mario World frame without the TM mark.

  tcrf_check/tools/wild_frame_unused.py ROM [OUT.png]   (default tcrf_check/assets/hidden/wild_frame_smw_unused.png)

WildFrame_PageSrcTbl (08:5510) lists 8 pages; WildFramePicker_ReadKeys (08:5325) offers 6, or 7 when wCoroFlag is 1, and
Mode19_State00_CopyrightScreens sets wCoroFlag to 1 at every start (08:72FF) in this build, so pages 0-6 are shown and page 7
(33:6800) never is. Page 7 is page 1 (31:5800, the Super Mario World frame) with 18 bytes changed in 4 tiles: the TM mark is
missing. Drawn from the ROM bytes: the first 140 tiles of each sheet, 20 tiles wide (the sheet's own order), at 3x.
"""
import sys, os
from PIL import Image, ImageDraw, ImageFont
R = open(sys.argv[1], 'rb').read()
OUT = sys.argv[2] if len(sys.argv) > 2 else os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'assets', 'hidden', 'wild_frame_smw_unused.png')
def o(b, a): return b * 0x4000 + a - 0x4000
def sheet(off, nt=140, cols=20):
    im = Image.new('L', (cols * 8, (nt // cols) * 8), 255); px = im.load()
    for t in range(nt):
        for y in range(8):
            lo, hi = R[off + t * 16 + 2 * y], R[off + t * 16 + 2 * y + 1]
            for x in range(8): px[(t % cols) * 8 + x, (t // cols) * 8 + y] = (255, 170, 85, 0)[((lo >> (7 - x)) & 1) | (((hi >> (7 - x)) & 1) << 1)]
    return im
def fnt(sz, bold=True):
    q = '/usr/share/fonts/truetype/dejavu/DejaVuSans%s.ttf' % ('-Bold' if bold else '')
    return ImageFont.truetype(q, sz) if os.path.exists(q) else ImageFont.load_default(size=sz)
S, M, GAP, TOP = 3, 24, 32, 90
A, B = sheet(o(0x31, 0x5800)), sheet(o(0x33, 0x6800))
im = Image.new('L', (2 * M + 2 * A.width * S + GAP, TOP + A.height * S + M), 255); d = ImageDraw.Draw(im)
for i, (pic, t1, t2) in enumerate(((A, 'Page 1 (31:5800): shown', 'Super Mario World, with the TM mark'),
                                    (B, 'Page 7 (33:6800): never shown', 'same frame, no TM (18 bytes)'))):
    x = M + i * (A.width * S + GAP); d.text((x, 14), t1, fill=0, font=fnt(26)); d.text((x, 52), t2, fill=70, font=fnt(21, False))
    im.paste(pic.resize((pic.width * S, pic.height * S), Image.NEAREST), (x, TOP)); d.rectangle([x - 1, TOP - 1, x + pic.width * S, TOP + pic.height * S], outline=0, width=2)
im.save(OUT, optimize=True); print(OUT, im.size)
