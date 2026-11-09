#!/usr/bin/env python3
"""One picture of the Japanese assets that the international ROM still holds and never shows (README, international section).

  tools/intl_jp_leftovers_sheet.py JP.gb INTL.gb OUT.png

Drawn from the international ROM's own bytes (2bpp tiles, 16 per row, x2, grey palette; the two tile maps as byte values in grey; the font as its
8 x 16 glyph cells).  Every block is checked byte for byte against the Japanese block it comes from (roms/us_eu/assets/never_reached_us.csv:
the never-reached assets of the Japanese ROM found again in this one).  Left out: the exchange stand-by screen and the "DEBA GAME" menu (shown in the
Japanese section of the README), the D.J. printer font (used: printed, not shown) and the small scraps."""
import sys, os
from PIL import Image, ImageDraw, ImageFont
J, U = open(sys.argv[1], 'rb').read(), open(sys.argv[2], 'rb').read(); OUT = sys.argv[3]
def off(b, a): return a if b == 0 else b * 0x4000 + a - 0x4000
PAL = [255, 170, 85, 0]; SC = 2
def tiles(d, cols=16):
    n = len(d) // 16; rows = (n + cols - 1) // cols; im = Image.new('L', (cols * 8, rows * 8), 238); px = im.load()
    for k in range(n):
        for y in range(8):
            lo, hi = d[16 * k + 2 * y], d[16 * k + 2 * y + 1]
            for x in range(8): px[(k % cols) * 8 + x, (k // cols) * 8 + y] = PAL[((lo >> (7 - x)) & 1) | (((hi >> (7 - x)) & 1) << 1)]
    return im.resize((im.width * SC, im.height * SC), Image.NEAREST).convert('RGB')
def greymap(d):
    im = Image.new('L', (32, len(d) // 32)); im.putdata(list(d[:len(d) // 32 * 32]))
    return im.resize((32 * 8, len(d) // 32 * 8), Image.NEAREST).convert('RGB')
def glyphs(codes):
    cols = 16; rows = (len(codes) + cols - 1) // cols; im = Image.new('L', (cols * 10, rows * 18), 238); px = im.load()
    for i, c in enumerate(codes):
        o = off(0x2A, 0x4000) + (c - 1) * 32
        for t in range(2):
            for y in range(8):
                lo, hi = U[o + 16 * t + 2 * y], U[o + 16 * t + 2 * y + 1]
                for x in range(8): px[(i % cols) * 10 + 1 + x, (i // cols) * 18 + 1 + 8 * t + y] = PAL[((lo >> (7 - x)) & 1) | (((hi >> (7 - x)) & 1) << 1)]
    return im.resize((im.width * SC, im.height * SC), Image.NEAREST).convert('RGB')
# (international address, Japanese address, bytes, caption)
SECTIONS = [
 ('Graphics documented by TCRF (Japanese ROM), still here byte for byte and never shown', [
  ((0x0D, 0x7660), (0x0D, 0x7660), 384, 'Kanji tiles (middle, before, after, have)'),
  ((0x11, 0x5800), (0x11, 0x5800), 4416, 'hand-and-newspaper frames'),
  ((0x13, 0x5CA0), (0x13, 0x5CA0), 96, 'album hand gestures'),
  ((0x10, 0x7A80), (0x10, 0x7A80), 32, 'sound-print modulation icon, top row'),
  ((0x10, 0x7B80), (0x10, 0x7B80), 32, 'sound-print modulation icon, bottom row'),
  ((0x18, 0x5A50), (0x18, 0x5A50), 96, 'margin print: B film roll'),
  ((0x18, 0x5F90), (0x18, 0x5F90), 192, 'margin print: outlined text'),
  ((0x1A, 0x7D80), (0x1A, 0x7D80), 96, 'photo option: B CANCEL'),
  ((0x1C, 0x5920), (0x1C, 0x5920), 512, 'extra hot-spot effect icons'),
  ((0x1E, 0x6620), (0x1E, 0x6620), 848, '"cannot combine the same picture" message'),
 ]),
 ('Japanese tile blocks never on screen in either ROM', [
  ((0x0D, 0x7000), (0x0D, 0x7000), 1632, 'fill patterns, a crosshair and Japanese glyph pieces'),
  ((0x18, 0x7D80), (0x18, 0x7D80), 256, 'after the "leave" screen tiles'),
  ((0x1A, 0x5182), (0x1A, 0x5182), 90, 'unreferenced tiles'),
  ((0x1A, 0x7E00), (0x1A, 0x7E00), 501, 'unreferenced tiles'),
  ((0x1C, 0x5C20), (0x1C, 0x5C20), 64, 'after the photo arrows'),
  ((0x1E, 0x7D00), (0x1E, 0x7D00), 184, 'unreferenced tiles'),
  ((0x21, 0x6AC7), (0x21, 0x6AC7), 177, 'unreferenced tiles'),
 ]),
 ('Shown only when state variables are forced: the second collar set of the main-menu ball head (frames F5-F8)', [
  ((0x16, 0x7380), (0x16, 0x7380), 512, 'ball head F5'), ((0x16, 0x7580), (0x16, 0x7580), 512, 'ball head F6'),
  ((0x16, 0x7780), (0x16, 0x7780), 512, 'ball head F7'), ((0x16, 0x7980), (0x16, 0x7980), 512, 'ball head F8'),
 ]),
 ('Unused tile maps (byte values as grey; moved with their bank)', [
  ((0x25, 0x73A0), (0x25, 0x75E0), 576, 'unused photo screen (JP 25:75E0): frame + 16-wide photo ramp', 'map'),
  ((0x26, 0x6E40), (0x26, 0x7080), 576, 'unused full-screen picture (JP 26:7080), tile set not found', 'map'),
 ]),
]
FONT = ImageFont.load_default(); W = 1100; GAP = 16
cells = []
for title, items in SECTIONS:
    row = []
    for it in items:
        (ub, ua), (jb, ja), n, cap = it[:4]; kind = it[4] if len(it) > 4 else 'tiles'
        d = U[off(ub, ua):off(ub, ua) + n]
        same = d == J[off(jb, ja):off(jb, ja) + n]
        img = greymap(d) if kind == 'map' else tiles(d[:n // 16 * 16])
        row.append(('%02X:%04X  %d B%s' % (ub, ua, n, '' if same else '  (DIFFERS from JP)'), cap, img))
    cells.append((title, row))
hira = list(range(0x01, 0x56)); jlat = list(range(0xC9, 0xF6))
cells.append(('The name / comment font keeps two Japanese blocks that no key of the international keyboard types (2A:4000, code c at + (c-1) x 32)', [
    ('codes $01-$55', 'hiragana, punctuation, small kana (equal to JP)', glyphs(hira)),
    ('codes $C9-$F5', 'the Japanese Latin block (a-z, icons, digits; equal to JP)', glyphs(jlat))]))
# layout: flow each section's cells left to right
def layout(draw=None, sheet=None):
    y = 50
    for title, row in cells:
        if draw: draw.rectangle([GAP, y, W - GAP, y + 2], fill=(150, 60, 60)); draw.text((GAP, y + 6), title, fill=(150, 60, 60), font=FONT)
        y += 24; x = GAP; rh = 0
        for c1, c2, img in row:
            w = max(img.width, 6 * max(len(c1), len(c2)))
            if x + w > W - GAP: x = GAP; y += rh + 10; rh = 0
            if draw:
                draw.text((x, y), c1, fill=(0, 0, 0), font=FONT); draw.text((x, y + 12), c2, fill=(90, 90, 90), font=FONT)
                sheet.paste(img, (x, y + 26)); draw.rectangle([x - 1, y + 25, x + img.width, y + 26 + img.height], outline=(180, 180, 180))
            x += w + 14; rh = max(rh, 26 + img.height)
        y += rh + 18
    return y
H = layout() + 30
sheet = Image.new('RGB', (W, H), 'white'); dr = ImageDraw.Draw(sheet)
dr.text((GAP, 10), 'Game Boy Camera (USA, Europe): Japanese assets left in the ROM and never shown', fill=(0, 0, 0), font=FONT)
dr.text((GAP, 26), 'drawn from the international ROM bytes (2bpp tiles, 16 per row, x2, grey palette); every block checked against its Japanese source; Gold: the same bytes', fill=(90, 90, 90), font=FONT)
layout(dr, sheet)
sheet.save(OUT); print(OUT, sheet.size, 'blocks differing from JP:', sum(1 for _, r in cells for c in r if 'DIFFERS' in c[0]))
