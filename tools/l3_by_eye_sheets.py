#!/usr/bin/env python3
"""Sheets for the L3 review by eye of the international names that describe a picture (2026-11-01): the Japanese bytes beside this build's bytes,
drawn straight from the ROMs in four greys (a direct draw of ROM bytes, not a console capture).
usage: l3_by_eye_sheets.py JP.gb INTL.gb OUTDIR
  OUTDIR/font_2A_4A60_jp_vs_intl.png    2A:4A60-5909 as 8 x 16 glyphs (32 B each), 16 per row: the Japanese katakana area and the Latin set of this build
  OUTDIR/fill_0D_7000_jp_vs_intl.png    the fill-pattern tiles 0D:7000-78FF (2026-11-02), 16 tiles per row
  OUTDIR/sheets_jp_vs_intl.png          17:7940, 1C:4670, 21:5FD0, 33:4000, 33:4980, 32:4180 as 8 x 8 tiles, 32 per row (the Japanese block through the port's byte map)"""
import sys, os
import numpy as np
from PIL import Image, ImageDraw
J, U = open(sys.argv[1], 'rb').read(), open(sys.argv[2], 'rb').read(); out = sys.argv[3]; os.makedirs(out, exist_ok=True)
M = np.load(os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'roms', 'us_eu', 'port', 'map_us.npy'))
PAL = [(255, 255, 255), (170, 170, 170), (85, 85, 85), (0, 0, 0)]
def flat(b, a): return b * 0x4000 + a - 0x4000
def tile(rom, o):
    im = Image.new('RGB', (8, 8))
    for y in range(8):
        lo, hi = rom[o + 2 * y], rom[o + 2 * y + 1]
        for x in range(8): im.putpixel((x, y), PAL[((lo >> (7 - x)) & 1) | (((hi >> (7 - x)) & 1) << 1)])
    return im
def strip(rom, o, n, per, glyph):
    h = 16 if glyph else 8; im = Image.new('RGB', (per * 9, ((n + per - 1) // per) * (h + 1)), (200, 60, 60))
    for i in range(n):
        x, y = (i % per) * 9, (i // per) * (h + 1)
        if glyph: im.paste(tile(rom, o + 32 * i), (x, y)); im.paste(tile(rom, o + 32 * i + 16), (x, y + 8))
        else: im.paste(tile(rom, o + 16 * i), (x, y))
    return im
o = flat(0x2A, 0x4A60); n = (0x5910 - 0x4A60) // 32; a = strip(J, o, n, 16, True); b = strip(U, o, n, 16, True)
W = Image.new('RGB', (a.width * 2 + 20, a.height + 14), 'white'); d = ImageDraw.Draw(W)
d.text((2, 0), 'JP 2A:4A60', fill='black'); d.text((a.width + 22, 0), 'international 2A:4A60', fill='black'); W.paste(a, (0, 14)); W.paste(b, (a.width + 20, 14))
W.resize((W.width * 3, W.height * 3), Image.NEAREST).save(os.path.join(out, 'font_2A_4A60_jp_vs_intl.png'))
parts = []
for bk, ad, ln in ((0x17, 0x7940, 448), (0x1C, 0x4670, 2288), (0x21, 0x5FD0, 1430), (0x33, 0x4000, 2432), (0x33, 0x4980, 896), (0x32, 0x4180, 896)):
    o = flat(bk, ad); j = int(M[o]); nt = (ln + 15) // 16; parts.append(('%02X:%04X  JP | international' % (bk, ad), strip(J, j, nt, 32, False), strip(U, o, nt, 32, False)))
W = max(p[1].width * 2 + 12 for p in parts); H = sum(p[1].height + 14 for p in parts)
im = Image.new('RGB', (W, H), 'white'); d = ImageDraw.Draw(im); y = 0
for t, A, B in parts:
    d.text((2, y), t, fill='black'); y += 12; im.paste(A, (0, y)); im.paste(B, (A.width + 12, y)); y += A.height + 2
im.resize((im.width * 2, im.height * 2), Image.NEAREST).save(os.path.join(out, 'sheets_jp_vs_intl.png'))
parts = []
for bk, ad, ln in ((0x0D, 0x7000, 0x7E0), (0x0D, 0x77E0, 0x120)):
    o = flat(bk, ad); j = int(M[o]); nt = ln // 16
    parts.append(('%02X:%04X JP | intl (diff %d B)' % (bk, ad, sum(U[o + i] != J[j + i] for i in range(ln))), strip(J, j, nt, 16, False), strip(U, o, nt, 16, False)))
W = max(p[1].width * 2 + 12 for p in parts); H = sum(p[1].height + 14 for p in parts)
im = Image.new('RGB', (W, H), 'white'); d = ImageDraw.Draw(im); y = 0
for t, A, B in parts:
    d.text((2, y), t, fill='black'); y += 12; im.paste(A, (0, y)); im.paste(B, (A.width + 12, y)); y += A.height + 2
im.resize((im.width * 3, im.height * 3), Image.NEAREST).save(os.path.join(out, 'fill_0D_7000_jp_vs_intl.png'))
print('->', out)
