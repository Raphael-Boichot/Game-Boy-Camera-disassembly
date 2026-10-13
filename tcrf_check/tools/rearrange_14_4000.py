#!/usr/bin/env python3
"""Rearrange the tiles of 14:4000-502F (259 tiles) into the strips they really are.  README 16.24 "(3) The small holes".

The block is a stack of tile strips of different widths, each stored with its tile order REVERSED: the last tile of a strip is its top-left
tile, tile s has tile s+1 on its left and tile s+W above it, the tiles themselves are not flipped.  Found by edge continuity:
  - the face (14:4720-4F1F, W = 16, 8 rows): seam cost of the right edge against the left edge of the next tile, 0.67 for "s+1 on the left"
    against 0.86 for the forward order, and of the bottom edge against the top edge, 0.67 for "s+16 above" against 1.09 for "s-16 above"
    (random pairs 1.21); the tile grid sits on $xxx0 (shifted by 4 bytes the vertical cost doubles);
  - the heading row (stream tiles 242-258) is the exception: forward order, right-edge cost 69 against 144 reversed;
  - the widths of the two text strips (10 for the black kanji block, 17 for the katakana line) are read from the result, not proven.
usage: rearrange_14_4000.py [ROM] [out.png]   (default ROM /home/claude/gbcam_jp/pocketcamera_jp.gb, env GBCAM_ROM, GBCAM_REPO)
"""
import sys, os
import numpy as np
from PIL import Image, ImageDraw
REPO = os.environ.get('GBCAM_REPO', os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
ROMF = sys.argv[1] if len(sys.argv) > 1 else os.environ.get('GBCAM_ROM', '/home/claude/gbcam_jp/pocketcamera_jp.gb')
OUT = sys.argv[2] if len(sys.argv) > 2 else REPO + '/tcrf_check/assets/unidentified/14_4000_strips_rearranged.png'
rom = np.frombuffer(open(ROMF, 'rb').read(), dtype=np.uint8)
BASE = 0x14 * 0x4000        # 14:4000
N = 259                     # tiles up to 14:502F
PAL = np.array([255, 170, 85, 0], np.uint8)
SC = 4
def tile(i):
    t = np.zeros((8, 8), np.uint8)
    for y in range(8):
        b0 = int(rom[BASE + 16 * i + 2 * y]); b1 = int(rom[BASE + 16 * i + 2 * y + 1])
        for x in range(8): t[y, x] = ((b1 >> (7 - x)) & 1) << 1 | ((b0 >> (7 - x)) & 1)
    return t
T = [tile(i) for i in range(N)]
def sheet(seq, w):
    h = (len(seq) + w - 1) // w
    img = np.full((h * 8, w * 8), 255, np.uint8)
    for i, t in enumerate(seq):
        r, c = divmod(i, w); img[r * 8:r * 8 + 8, c * 8:c * 8 + 8] = PAL[t]
    return Image.fromarray(img).resize((w * 8 * SC, h * 8 * SC), Image.NEAREST)
def addr(s): return '%04X' % (0x4000 + 16 * s)
def rev(a, b, w): return sheet(T[a:b][::-1], w)
def fwd(a, b, w): return sheet(T[a:b], w)
panels = [
    ('face: 14:%s-%s, 16 tiles wide x 8 rows, tile order reversed' % (addr(114), '%04X' % (0x4000 + 16 * 242 - 1)), rev(114, 242, 16)),
    ('katakana line: 14:%s-%s, 17 wide x 2 rows, reversed' % (addr(68), '%04X' % (0x4000 + 16 * 102 - 1)), rev(68, 102, 17)),
    ('big black kanji block: 14:%s-%s, 10 wide x 6 rows, reversed' % (addr(0), '%04X' % (0x4000 + 16 * 60 - 1)), rev(0, 60, 10)),
    ('heading row: 14:%s-502F, 17 tiles, FORWARD order' % addr(242), fwd(242, 259, 17)),
]
Wd = max(p.size[0] for _, p in panels) + 16
H = sum(p.size[1] + 26 for _, p in panels) + 8
c = Image.new('L', (Wd, H), 200)
d = ImageDraw.Draw(c); y = 6
for n, p in panels:
    d.text((8, y), n, fill=0); y += 14
    c.paste(p, (8, y)); d.rectangle((7, y - 1, 8 + p.size[0], y + p.size[1]), outline=90); y += p.size[1] + 12
c.save(OUT); print(OUT, c.size)
