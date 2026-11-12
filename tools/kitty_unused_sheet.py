#!/usr/bin/env python3
"""The unused assets of the Hello Kitty ROM, one sheet in the style of the other ROMs (tools/asset_sheet.py, 2026-11-12):
roms/hello_kitty/assets/never_reached_kitty.png, the picture of assets/never_reached_kitty.csv (its unused items; the used ones of
that table are not drawn).

  tools/kitty_unused_sheet.py KITTY.gb [--check]

Documented by TCRF (https://tcrf.net/Hello_Kitty_Pocket_Camera, Pompompurin Picture): mode $18, its tiles 14:5800 drawn by the map
2E:7800, a BGB screenshot with the mode byte forced (screens/extra_18_01.png). Not documented by TCRF: item 1 (11:6000, beside the
picture 11:7000 that is shown), item 2 (the map 31:7CB0: BGB screenshots of the main menu and of the patched copy where this map
replaces 31:7A70, screens/bgb_mainmenu_*.png), item 3 (18:7000, 8x16 sprite text), items 4-9 (the 56 tiles after each print frame),
items 10-11 (mode $17, BGB with the mode byte forced, screens/extra_17_01.png), item 19 (12:4000, the thin 8x16 font), item 20
(31:4380, 31:4A80: two 64 x 56 half pictures). Drawn from the ROM bytes x2 unless the caption says BGB.
"""
import argparse, os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__))); import asset_sheet as A_
from asset_sheet import tiles, tiles16, side, shot
HERE = os.path.dirname(os.path.abspath(__file__)); KD = os.path.join(os.path.dirname(HERE), 'roms', 'hello_kitty')
OUT = os.path.join(KD, 'assets', 'never_reached_kitty.png'); SC = os.path.join(KD, 'screens')
ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('--check', action='store_true'); a = ap.parse_args()
R = open(a.rom, 'rb').read()
def g(b, ad, n): o = b * 0x4000 + ad - 0x4000; return R[o:o + n]
tcrf = [('mode $18: the Pompompurin picture (BGB, mode forced)', 'tiles 14:5800, map 2E:7800 (items 12-13)', shot(os.path.join(SC, 'extra_18_01.png')))]
frames = side(*[tiles(g(b, ad, 0x380), w=8) for b, ad in ((0x1B, 0x5180), (0x1A, 0x5180), (0x1A, 0x6980), (0x19, 0x6980), (0x19, 0x5180), (0x18, 0x5180))])
own = [('picture never requested (left) / the one shown (right)', '11:6000, record 0 of 00:249D / 11:7000 (item 1)', side(tiles(g(0x11, 0x6000, 0xE00)), tiles(g(0x11, 0x7000, 0xE00)))),
       ('main menu map never loaded: the menu / this map in its place (BGB)', '31:7A70 / 31:7CB0, patched copy (item 2)', side(shot(os.path.join(SC, 'bgb_mainmenu_31_7A70.png')), shot(os.path.join(SC, 'bgb_mainmenu_31_7CB0_patched.png')))),
       ('mode $17: print error picture (BGB, mode forced)', 'tiles 14:4000, map 2D:7820 (items 10-11)', shot(os.path.join(SC, 'extra_17_01.png'))),
       ('image-effect names, 8x16 sprite text, never read', '18:7000 (item 3)', tiles16(g(0x18, 0x7000, 0xC00), w=16)),
       ('the 56 tiles after each print frame', '1B:5180 1A:5180 1A:6980 19:6980 19:5180 18:5180 (items 4-9)', frames),
       ('a second, thinner 8x16 font', '12:4000 (item 19)', tiles16(g(0x12, 0x4000, 0x1FE0), w=32)),
       ('two 64 x 56 half pictures (Kitty faces)', '31:4380, 31:4A80 (item 20)', side(tiles(g(0x31, 0x4380, 0x380), w=8), tiles(g(0x31, 0x4A80, 0x380), w=8)))]
sys.exit(A_.sheet('Unused assets, Pocket Camera (Hello Kitty) (prototype)',
                  'Drawn from the ROM bytes x2, or BGB screenshots in the same greys: the unused items of roms/hello_kitty/assets/never_reached_kitty.csv (categories: assets/unused_kitty.csv).',
                  [('Documented by TCRF (https://tcrf.net/Hello_Kitty_Pocket_Camera, Pompompurin Picture)', A_.TCRF_COL, tcrf),
                   ('Not documented by TCRF (found by this project)', A_.OWN_COL, own)], OUT, a.check, 'kitty_unused_sheet'))
