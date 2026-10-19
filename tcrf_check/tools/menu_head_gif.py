#!/usr/bin/env python3
"""The camera of the main menu turning, drawn from the ROM tiles (README 16.24): GIFs at a pixel-perfect 4x.
 1. main_menu_camera_turn.gif: the BODY turns with the head fixed (the page transition: the seven body strips 16:5580, 5A80, 5F80, 6480, 11:4000, 4500, 4A00 are copied over VRAM $9200-$96FF in the order of
    MainMenu_SlideB_Tbl0 / Tbl2 forward and Tbl3 / Tbl1 back, head frame F4 at $9100), then the HEAD turns with the body fixed (the frames F4 -> F0 -> F4, Tbl1 / Tbl0 of MainMenu_SlideA, each copied over
    VRAM $9100-$92FF on the body strip 16:5580).  Every step lasts 4 frames of the game (67 ms, GIF delay 7 cs), the rests 1 s.
 2. main_menu_head_turn_set_B.gif: the second set of head frames, the one nothing plays (Tbl2 / Tbl3 of MainMenu_SlideA have no caller): F9 -> F5 -> F9 on the back body 11:4000 that its collar fits.
The picture is the central column of the upper-page map 26:5A00 (8 x 14 tiles, 64 x 112 px, palette E4, white background), without the page's boxes, corner heads and text; the BG map is not changed
by the transitions here (the game slides the page's map with the strips).  A step copies the whole block: the strip over the head for the body turn ($20-$6F over $10-$2F), the head over the strip for the head turn.
usage: menu_head_gif.py ROM OUTDIR [--scale 4]"""
import sys, os
import numpy as np
from PIL import Image
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import head_sets as HS
PAL = [255, 255, 255, 170, 170, 170, 85, 85, 85, 0, 0, 0]
ROW0, ROWS, COL0, COLS, MARGIN = 3, 14, 6, 8, 8
STEP, REST = 7, 100        # GIF delays in centiseconds

def vram_strip_over_head(rom, strip, head):
    v = {0x10 + i: HS.tile(head, i) for i in range(32)}
    v.update({0x20 + i: HS.tile(strip, i) for i in range(80)}); return v
def vram_head_over_strip(rom, strip, head):
    v = {0x20 + i: HS.tile(strip, i) for i in range(80)}
    v.update({0x10 + i: HS.tile(head, i) for i in range(32)}); return v

def picture(v, scale):
    a = np.zeros((ROWS * 8 + 2 * MARGIN, COLS * 8 + 2 * MARGIN), np.uint8)
    for r, cells in HS.CM.items():
        for c, i in cells.items():
            if i in v: a[MARGIN + (r - ROW0) * 8:MARGIN + (r - ROW0) * 8 + 8, MARGIN + (c - COL0) * 8:MARGIN + (c - COL0) * 8 + 8] = HS.px(v[i])
    im = Image.fromarray(a, 'P'); im.putpalette(PAL)
    return im.resize((im.width * scale, im.height * scale), Image.NEAREST)

def save(frames, path):
    ims = [f[0] for f in frames]
    ims[0].save(path, save_all=True, append_images=ims[1:], duration=[f[1] * 10 for f in frames], loop=0, optimize=False, disposal=1)
    return len(ims)

def camera_turn(rom, scale):
    F = HS.frames(rom); S = {k: HS.strip(rom, b, a) for k, (b, a) in {'5580': (0x16, 0x5580), '5A80': (0x16, 0x5A80), '5F80': (0x16, 0x5F80), '6480': (0x16, 0x6480), '4000': (0x11, 0x4000), '4500': (0x11, 0x4500), '4A00': (0x11, 0x4A00)}.items()}
    fr = []
    add = lambda v, d: fr.append((picture(v, scale), d))
    add(vram_head_over_strip(rom, S['5580'], F[4]), REST)                                     # rest: upper page, head F4
    fwd = ['5A80', '5F80', '6480', '4000', '4500', '4500', '4A00', '4A00']                    # MainMenu_SlideB_Tbl0 then Tbl2 (the page turns to the lower page)
    back = ['4500', '4500', '4000', '4000', '6480', '5F80', '5A80', '5580']                   # MainMenu_SlideB_Tbl3 then Tbl1
    for k in fwd: add(vram_strip_over_head(rom, S[k], F[4]), STEP)
    fr[-1] = (fr[-1][0], REST)                                                                # rest: lower page body
    for k in back: add(vram_strip_over_head(rom, S[k], F[4]), STEP)
    fr[-1] = (fr[-1][0], REST // 2)
    for j in (3, 2, 1, 0): add(vram_head_over_strip(rom, S['5580'], F[j]), STEP)              # MainMenu_SlideA_Tbl1: F3 F2 F1 F0
    fr[-1] = (fr[-1][0], REST)
    for j in (1, 2, 3, 4): add(vram_head_over_strip(rom, S['5580'], F[j]), STEP)              # MainMenu_SlideA_Tbl0: F1 F2 F3 F4
    fr[-1] = (fr[-1][0], REST // 2)
    return fr

def head_turn_set_b(rom, scale):
    F = HS.frames(rom); s = HS.strip(rom, 0x11, 0x4000); fr = []
    add = lambda j, d: fr.append((picture(vram_head_over_strip(rom, s, F[j]), scale), d))
    add(9, REST)
    for j in (8, 7, 6, 5): add(j, STEP)                                                         # MainMenu_SlideA_Tbl3 (no caller): F8 F7 F6 F5
    fr[-1] = (fr[-1][0], REST)
    for j in (6, 7, 8, 9): add(j, STEP)                                                         # MainMenu_SlideA_Tbl2 (no caller): F6 F7 F8 F9
    fr[-1] = (fr[-1][0], REST // 2)
    return fr

if __name__ == '__main__':
    a = sys.argv[1:]; rom = open(a[0], 'rb').read(); out = a[1]; scale = int(a[a.index('--scale') + 1]) if '--scale' in a else 4
    os.makedirs(out, exist_ok=True)
    for name, fn in (('main_menu_camera_turn.gif', camera_turn), ('main_menu_head_turn_set_B.gif', head_turn_set_b)):
        fr = fn(rom, scale); n = save(fr, os.path.join(out, name)); print(name, n, 'frames', fr[0][0].size, 'total %.1f s' % (sum(f[1] for f in fr) / 100))
