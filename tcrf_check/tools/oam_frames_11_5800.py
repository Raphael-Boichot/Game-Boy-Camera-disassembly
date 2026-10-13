#!/usr/bin/env python3
"""Draw the nine frames of the asset 11:5700 (label Gfx_11_5700_MainMenuIconAnimFrames) as sprites, straight from the ROM.  README 16.24 / checklist B16.

A frame is 25 tiles (5 x 5 sprites, 40 x 40 px) in a 512-byte slot: slot j sits at 11:5800 + 0x200 * j (j = 0..8, the last one is cut at 11:693F).
The arrangement is the OAM list $BA of bank 01 (01:5504, entries (Y, X, tile, attr) from bottom-right to top-left, tiles $50..$68, attr $10):
tile T of frame j is the ROM tile at 11:5800 + 0x200 * j + 16 * (T - $50).  No call that draws list $BA or loads these slots was found; the slots are read
only in forced runs (coverage), the first 256 bytes (11:5700-57FF) organically.
usage: oam_frames_11_5800.py [ROM] [out.png]   (default ROM /home/claude/gbcam_jp/pocketcamera_jp.gb, env GBCAM_ROM, GBCAM_REPO)
"""
import sys, os
import numpy as np
from PIL import Image, ImageDraw
REPO = os.environ.get('GBCAM_REPO', os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
ROMF = sys.argv[1] if len(sys.argv) > 1 else os.environ.get('GBCAM_ROM', '/home/claude/gbcam_jp/pocketcamera_jp.gb')
OUT = sys.argv[2] if len(sys.argv) > 2 else REPO + '/tcrf_check/assets/unidentified/11_5800_frames_list_BA.png'
rom = open(ROMF, 'rb').read()
def off(b, a): return a if b == 0 else b * 0x4000 + (a - 0x4000)
PAL = [255, 170, 85, 0]
LIST = off(1, 0x5504)
ents = []
p = LIST
while rom[p] != 0x80:
    ents.append(tuple(rom[p:p + 4])); p += 4
assert len(ents) == 25, len(ents)
def tile(o):
    t = np.zeros((8, 8), np.uint8)
    for y in range(8):
        b0, b1 = rom[o + 2 * y], rom[o + 2 * y + 1]
        for x in range(8): t[y, x] = ((b1 >> (7 - x)) & 1) << 1 | ((b0 >> (7 - x)) & 1)
    return t
SC = 3
cells = []
for j in range(9):
    base = off(0x11, 0x5800) + 0x200 * j
    img = np.zeros((40, 40), np.uint8)
    for Y, X, T, A in ents:
        o = base + 16 * (T - 0x50)
        if o + 16 > off(0x11, 0x6940): continue            # the last slot is cut at 11:693F
        img[Y:Y + 8, (X + 8) & 0xFF:((X + 8) & 0xFF) + 8] = tile(o)
    cells.append(Image.fromarray(np.array(PAL, np.uint8)[img]).resize((40 * SC, 40 * SC), Image.NEAREST))
W = 3 * (40 * SC + 16) + 8; H = 3 * (40 * SC + 30) + 8
c = Image.new('L', (W, H), 215); d = ImageDraw.Draw(c)
for j, im in enumerate(cells):
    r, k = divmod(j, 3); x = 8 + k * (40 * SC + 16); y = 8 + r * (40 * SC + 30)
    d.text((x, y), 'slot %d  11:%04X' % (j, 0x5800 + 0x200 * j), fill=0)
    c.paste(im, (x, y + 14)); d.rectangle((x - 1, y + 13, x + 40 * SC, y + 14 + 40 * SC), outline=120)
c.save(OUT); print(OUT, c.size)
