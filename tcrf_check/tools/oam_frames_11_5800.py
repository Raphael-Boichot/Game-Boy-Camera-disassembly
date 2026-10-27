#!/usr/bin/env python3
"""Draw the nine frames of the asset 11:5700 (label Gfx_11_5700_MainMenuIconAnimFrames) as sprites, straight from the ROM.  README 16.24 / checklist B16.

A frame is 25 tiles (5 x 5 sprites, 40 x 40 px) in a 512-byte slot: slot j sits at 11:5800 + 0x200 * j (j = 0..8, the last one is cut at 11:693F).
The arrangement is the OAM list $BA of bank 01 (01:5504, entries (Y, X, tile, attr) from bottom-right to top-left, tiles $50..$68, attr $10):
tile T of frame j is the ROM tile at 11:5800 + 0x200 * j + 16 * (T - $50).  No call that draws list $BA or loads these slots was found; the slots are read
only in forced runs (coverage), the first 256 bytes (11:5700-57FF) organically.
usage: oam_frames_11_5800.py [ROM] [out.png] [--gif out.gif]   (default ROM /home/claude/gbcam_jp/pocketcamera_jp.gb, env GBCAM_ROM, GBCAM_REPO)
--gif also writes the frames as an animation (tcrf_check/assets/unidentified/11_5800_hand_newspaper.gif): slots 0 -> 8 then 8 -> 0, 4x,
6 game frames (100 ms) per step and 1 s on the first and last slot. No code plays the frames, so the ORDER (slot order, which shows one
continuous turn of the page) and the SPEED are chosen here (I); colour 0 of the sprites (transparent) is drawn white.
"""
import sys, os
GIF = None
if '--gif' in sys.argv: _i = sys.argv.index('--gif'); GIF = sys.argv[_i + 1]; del sys.argv[_i:_i + 2]
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
if GIF:
    from PIL import ImageFont
    def fnt(sz):
        for q in ('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf', '/usr/share/fonts/dejavu/DejaVuSans-Bold.ttf'):
            if os.path.exists(q): return ImageFont.truetype(q, sz)
        return ImageFont.load_default(size=sz)
    G = 4; f1, f2 = fnt(14), fnt(12); fr = []
    raw = []
    for j in range(9):
        base = off(0x11, 0x5800) + 0x200 * j; img = np.zeros((40, 40), np.uint8)
        for Y, X, T, A in ents:
            o = base + 16 * (T - 0x50)
            if o + 16 > off(0x11, 0x6940): continue
            img[Y:Y + 8, (X + 8) & 0xFF:((X + 8) & 0xFF) + 8] = tile(o)
        raw.append(img)
    order = list(range(9)) + list(range(7, 0, -1))
    for k, j in enumerate(order):
        im = Image.new('P', (40 * G + 24, 40 * G + 58), 0); im.putpalette([255, 255, 255, 170, 170, 170, 85, 85, 85, 0, 0, 0])
        im.paste(Image.fromarray(raw[j]).resize((40 * G, 40 * G), Image.NEAREST), (12, 46))
        dd = ImageDraw.Draw(im); dd.text((12, 6), 'UNUSED (TCRF B16)', fill=3, font=f1); dd.text((12, 25), 'slot %d  11:%04X' % (j, 0x5800 + 0x200 * j), fill=2, font=f2)
        fr.append((im, 100 if j in (0, 8) else 10))
    fr[0][0].save(GIF, save_all=True, append_images=[f[0] for f in fr[1:]], duration=[f[1] * 10 for f in fr], loop=0, optimize=False, disposal=1)
    print(GIF, len(fr), 'frames', fr[0][0].size, '%.1f s' % (sum(f[1] for f in fr) / 100))
