#!/usr/bin/env python3
"""Rearrange the tiles of 14:4000-502F (259 tiles) into the strips they really are.  README 16.24 "(3) The small holes".

The block is a stack of tile strips of different widths, each stored with its tile order REVERSED: the last tile of a strip is its top-left
tile, tile s has tile s+1 on its left and tile s+W above it, the tiles themselves are not flipped.  Found by edge continuity:
  - the face (14:4720-4F1F, 128 tiles = two pieces): seam cost of the right edge against the left edge of the next tile, 0.67 for "s+1 on the left"
    against 0.86 for the forward order, and of the bottom edge against the top edge, 0.67 for "s+16 above" against 1.09 for "s-16 above"
    (random pairs 1.21); the tile grid sits on $xxx0 (shifted by 4 bytes the vertical cost doubles);
      * stream tiles 114-209 (14:4720-4D1F) are a clean 6 rows x 16 reversed block, face[r][c] = 209 - 16 r - c;
      * stream tiles 210-241 (14:4D20-4F1F) are NOT the two top rows of a 16 x 8 block (those seams cost 7-13 per tile edge): they are a
        narrower piece whose right edge is column 15, rows of 11, 10, 6 and 5 tiles from the bottom up (row start = rightmost tile, tiles run
        right to left in ascending stream order).  Found by a right-aligned dynamic programme on the seam costs (mean edge cost per 8 px
        seam 2.2-3.4 inside the rows, 2.2-3.5 against the row below; the 16-wide reading costs 7-13, an 11-wide reading 10.3 on its top row).
        The tiles left of the steps, in the upper left corner, are not in the block: drawn as flat blue.
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
# the face: 10 rows x 16 columns; None = no stored tile
UP = [(237, 5), (231, 6), (221, 10), (210, 11)]       # (first stream tile = rightmost, length), top row first
FACE = []
for n, L in UP:
    r = [None] * 16
    for i in range(L): r[16 - L + i] = n + L - 1 - i
    FACE.append(r)
for r in range(6): FACE.append([209 - 16 * r - c for c in range(16)])
def face_img(scale=SC):
    img = np.zeros((len(FACE) * 8, 128, 3), np.uint8)
    for r, row in enumerate(FACE):
        for c, s in enumerate(row):
            img[r * 8:r * 8 + 8, c * 8:c * 8 + 8] = (205, 225, 245) if s is None else PAL[T[s]][..., None]
    return Image.fromarray(img).resize((128 * scale, len(FACE) * 8 * scale), Image.NEAREST)
def fwd(a, b, w): return sheet(T[a:b], w)
panels = [
    ('face: 14:%s-%s, 16 wide x 10 rows (6 full rows + a stepped upper part 14:%s-%s), tile order reversed' % (addr(114), '%04X' % (0x4000 + 16 * 242 - 1), addr(210), '%04X' % (0x4000 + 16 * 242 - 1)), face_img().convert('L')),
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
FACEOUT = os.path.join(os.path.dirname(OUT), '14_4720_face_reassembled.png')
face_img(8).save(FACEOUT); print(FACEOUT)
