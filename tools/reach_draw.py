#!/usr/bin/env python3
"""The one legend and the one drawing of every reachability map (HOWTO_NEW_ROM.md section 0.1, rule 4).

Imported by tools/rom_reach_map.py (the Japanese ROM) and tools/reach_map.py (every other ROM). A category keeps its
number, its colour and its meaning in every map; a ROM simply has no bytes in the categories it has no evidence for.

  0 blue        executed or read in a run without state pokes (organic)
  1 light blue  executed or read only in a forced run (a RAM / mode state written from outside, a patched table, an inverted gate)
  2 RED         never executed nor read and not explained: proven code that never ran, or data
  3 muted red   never-read runs of 16+ x $00 (padding)
  4 ORANGE      never read, but identified as data (an asset, a loader site, a table length, an inline table of the trace)
  5 GREEN       code that the runs did not execute but is credited: run by a later targeted run (Japanese), or the same code as a
                Japanese routine that ran (ported builds)
  6 PURPLE      code that never ran and is proven dead or unused (nothing calls it, no value selects it)
  7 YELLOW      asset data that no run put on screen without state pokes: the really unused assets
  8 beige       never-read runs of 16+ x $FF (fill; $FF is never padding)
  9 GREY-BLUE   data that no run read and nothing explains yet (no loader, no table, still on the default typing)

A 2-byte tile row takes the worst category of its two bytes, in the order of WORST (red first), so that a red byte is never hidden.
draw() lays the ROM out as 2bpp tiles (8 banks per row, each bank 16 x 64 tiles, the shade inside a colour is the tile pixel) with the
title, subtitle, legend lines and note above it.
"""
import os
import numpy as np
from PIL import Image, ImageDraw, ImageFont
FAM = {0: [(222, 234, 255), (150, 180, 240), (66, 106, 205), (8, 28, 112)],        # organic: blue
       1: [(224, 248, 252), (150, 222, 238), (64, 176, 208), (12, 104, 140)],      # forced only: light blue / cyan
       2: [(255, 224, 224), (248, 150, 150), (222, 52, 52), (120, 0, 0)],          # never executed nor read: red
       3: [(246, 238, 238), (226, 206, 206), (198, 168, 168), (150, 112, 112)],    # untouched padding: muted red
       4: [(255, 240, 214), (252, 200, 120), (240, 140, 20), (140, 66, 0)],        # never read, identified as data: orange
       5: [(226, 246, 226), (150, 214, 150), (48, 160, 64), (0, 84, 24)],          # not run here, credited: green
       6: [(244, 226, 250), (214, 160, 232), (150, 70, 190), (72, 10, 104)],       # never run, proven dead: purple
       7: [(255, 251, 205), (250, 232, 80), (222, 186, 0), (104, 84, 0)],          # really unused asset data: yellow
       8: [(250, 246, 236), (240, 230, 210), (226, 210, 180), (196, 176, 140)],    # never-read $FF fill: beige
       9: [(232, 236, 242), (190, 200, 216), (128, 144, 170), (60, 72, 96)]}       # data explained by nothing: grey-blue
WORST = [2, 6, 9, 7, 4, 8, 3, 5, 1, 0]           # a tile row takes the first of these among its two bytes
NAMES = {0: 'blue', 1: 'light blue', 2: 'RED', 3: 'muted red', 4: 'ORANGE', 5: 'GREEN', 6: 'PURPLE', 7: 'YELLOW', 8: 'beige', 9: 'GREY-BLUE'}


def runs16(rom):
    """Masks of the runs of 16 or more equal bytes $00 (padding) and $FF (fill)."""
    N = len(rom); pad = np.zeros(N, bool); fill = np.zeros(N, bool); i = 0
    while i < N:
        j = i
        while j < N and rom[j] == rom[i]: j += 1
        if j - i >= 16 and rom[i] in (0, 0xFF): (pad if rom[i] == 0 else fill)[i:j] = True
        i = j
    return pad, fill


def _font(sz, bold=True):
    for p in ('/usr/share/fonts/truetype/dejavu/DejaVuSans%s.ttf' % ('-Bold' if bold else ''), '/usr/share/fonts/dejavu/DejaVuSans%s.ttf' % ('-Bold' if bold else '')):
        if os.path.exists(p): return ImageFont.truetype(p, sz)
    return ImageFont.load_default(size=sz)


def draw(rom, cat, title, sub, items, note, out):
    """rom: uint8 array; cat: uint8 array of categories (0-9) per byte; items: [(category, legend text)]; writes the PNG to out."""
    N = len(rom); rank = np.zeros(10, int)
    for k, c in enumerate(reversed(WORST)): rank[c] = k
    back = np.argsort(rank)
    rowcat = back[np.maximum(rank[cat[0::2]], rank[cat[1::2]])].reshape(-1, 8)
    t = rom.reshape(-1, 8, 2); lo = t[:, :, 0]; hi = t[:, :, 1]
    sh = np.zeros((len(t), 8, 8), np.uint8)
    for x in range(8): sh[:, :, x] = ((lo >> (7 - x)) & 1) | (((hi >> (7 - x)) & 1) << 1)
    pix = (rowcat[:, :, None] * 4 + sh).astype(np.uint8)          # palette index = category * 4 + GB shade (0 = white ... 3 = black)
    BG, INK = 4 * len(FAM), 4 * len(FAM) + 1
    pal = [c for k in range(len(FAM)) for c in FAM[k]] + [(255, 255, 255), (0, 0, 0)]
    BTW, BTH, BCOLS = 16, 64, 8
    banks = N // 0x4000; per = pix.reshape(banks, BTH, BTW, 8, 8).transpose(0, 1, 3, 2, 4).reshape(banks, 8 * BTH, 8 * BTW)
    S = 2; GX, LEFT = 18, 40; PADT = 40; GY = PADT + 40     # PADT: space above a bank number, so that it sits with the bank under it
    PW, PH = 8 * BTW * S, 8 * BTH * S
    W = LEFT + BCOLS * (PW + GX) + 22
    f1, f2, f3, fb = _font(46), _font(28, False), _font(27, False), _font(32)
    sc = ImageDraw.Draw(Image.new('L', (8, 8)))
    def wrap(text, fnt, maxw):
        o, line = [], ''
        for w_ in text.split(' '):
            cand = (line + ' ' + w_).strip()
            if sc.textlength(cand, font=fnt) <= maxw or not line: line = cand
            else: o.append(line); line = w_
        return o + [line]
    TXW = W - LEFT - 20
    tl = wrap(title, f1, TXW); sl = wrap(sub, f2, TXW)
    y = 18 + 58 * len(tl) + 6 + 36 * len(sl) + 24; lay = []
    for c, txt in items:
        lines = wrap(txt, f3, TXW - 170); lay.append((c, y, lines)); y += 35 * len(lines) + 8
    nl = wrap(note, f3, TXW); ynote = y + 6; y = ynote + 35 * len(nl)
    TOP = y + 40
    H = TOP + (banks // BCOLS) * (PH + GY) + 20
    canvas = np.full((H, W), BG, np.uint8)
    for b in range(banks):
        gx = LEFT + (b % BCOLS) * (PW + GX); gy = TOP + (b // BCOLS) * (PH + GY) + GY
        canvas[gy:gy + PH, gx:gx + PW] = np.kron(per[b], np.ones((S, S), np.uint8))
    img = Image.fromarray(canvas, 'P'); img.putpalette([v for c in pal for v in c] + [0] * (768 - 3 * len(pal)))
    d = ImageDraw.Draw(img); yy = 18
    for l in tl: d.text((LEFT, yy), l, fill=INK, font=f1); yy += 58
    yy += 6
    for l in sl: d.text((LEFT, yy), l, fill=INK, font=f2); yy += 36
    for c, y0, lines in lay:
        for s_ in range(4): d.rectangle([LEFT + s_ * 36, y0 + 3, LEFT + s_ * 36 + 34, y0 + 29], fill=c * 4 + s_)
        for k_, l in enumerate(lines): d.text((LEFT + 170, y0 + 35 * k_), l, fill=INK, font=f3)
    for k_, l in enumerate(nl): d.text((LEFT, ynote + 35 * k_), l, fill=INK, font=f3)
    for b in range(banks):
        gx = LEFT + (b % BCOLS) * (PW + GX); gy = TOP + (b // BCOLS) * (PH + GY)
        d.text((gx, gy + PADT), '$%02X' % b, fill=INK, font=fb)
    img.save(out, optimize=True)
    return img
