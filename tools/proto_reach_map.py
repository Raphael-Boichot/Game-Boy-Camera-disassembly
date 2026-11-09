#!/usr/bin/env python3
"""The early prototype (Debagame Tester) drawn as 2bpp tiles, coloured by what its runs reached: the coverage map of roms/prototype_debagame.

  tools/proto_reach_map.py PROTO.gb [OUT.png]     (default roms/prototype_debagame/proto_rom_reachability_map.png)

PROTO.gb is the image as dumped (md5 19b50a5f...). Same drawing as tools/kitty_reach_map.py and the Japanese
tcrf_check/tools/rom_reach_map.py (8 banks per row, each bank 16 x 64 tiles, the shade inside a colour is the tile pixel):
  blue      executed or read in a run: the core runs of tools/proto_coverage.py (roms/prototype_debagame/port/cov_proto_runs.npz,
            exec or dread; blank SRAM and the owner's save)
  RED       proven code (class C of port/rom_map_proto.csv, the trace) that no run executed (port/observed_proto.md lists the blocks)
  ORANGE    data never read but explained by a type row of disasm/sym_types_proto.csv (copy sources, leftover text, the old symbol
            tables, the bank-number bytes, the header) or an inline table of the trace (class T)
  GREY-BLUE data never read and explained by nothing yet (still on the default typing)
  muted red / beige  never-read runs of 16+ x $00 (padding) / $FF (fill)
A 2-byte tile row takes the worst category of its two bytes (red > grey-blue > orange > fill > padding > blue). There are no forced
runs for this ROM. Prints one line `proto_reach: ...` with the byte counts.
"""
import sys, os, csv
import numpy as np
from PIL import Image, ImageDraw, ImageFont
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); KD = os.path.join(REPO, 'roms', 'prototype_debagame')
ROM = sys.argv[1]; OUT = sys.argv[2] if len(sys.argv) > 2 else os.path.join(KD, 'proto_rom_reachability_map.png')
rom = np.frombuffer(open(ROM, 'rb').read(), np.uint8); N = len(rom)
def off(b, ad): return ad if b == 0 else b * 0x4000 + ad - 0x4000
z = np.load(os.path.join(KD, 'port', 'cov_proto_runs.npz'))
ex = z['exec'] > 0; rd = z['dread'] > 0; hit = ex | rd
forced = np.zeros(N, bool)
code = np.zeros(N, bool); tab = np.zeros(N, bool)
for r in csv.DictReader(open(os.path.join(KD, 'port', 'rom_map_proto.csv'))):
    o = off(int(r['bank'], 16), int(r['start'], 16)); n = int(r['length'])
    if r['class'] == 'C': code[o:o + n] = True
    elif r['class'] == 'T': tab[o:o + n] = True
typed = tab.copy()
for r in csv.DictReader(open(os.path.join(KD, 'disasm', 'sym_types_proto.csv'))):
    b = int(r['bank'], 16); typed[off(b, int(r['start'], 16)):off(b, int(r['end'], 16))] = True
# never-read runs of 16+ equal bytes $00 / $FF
pad = np.zeros(N, bool); fill = np.zeros(N, bool); i = 0
while i < N:
    j = i
    while j < N and rom[j] == rom[i]: j += 1
    if j - i >= 16 and rom[i] in (0, 0xFF): (pad if rom[i] == 0 else fill)[i:j] = True
    i = j
cat = np.zeros(N, np.uint8)                                   # 0 blue
nh = ~hit
cat[nh & ~code & typed] = 4                                    # orange
cat[nh & ~code & ~typed] = 9                                   # grey-blue
cat[nh & ~code & ~typed & pad] = 3; cat[nh & ~code & ~typed & fill] = 8
cat[nh & code] = 2                                             # red
cat[forced] = 5                                                # purple: only in forced runs
cats = [0, 2, 9, 5, 4, 8, 3]
RANK = np.zeros(10, int)
for k, c in enumerate(reversed(cats)): RANK[c] = k
BACK = np.zeros(len(cats), int)
for c in cats: BACK[RANK[c]] = c
rowcat = BACK[np.maximum(RANK[cat[0::2]], RANK[cat[1::2]])].reshape(-1, 8)
t = rom.reshape(-1, 8, 2); lo = t[:, :, 0]; hi = t[:, :, 1]
sh = np.zeros((len(t), 8, 8), np.uint8)
for x in range(8): sh[:, :, x] = ((lo >> (7 - x)) & 1) | (((hi >> (7 - x)) & 1) << 1)
FAM = {0: [(222, 234, 255), (150, 180, 240), (66, 106, 205), (8, 28, 112)],       # reached: blue
       2: [(255, 224, 224), (248, 150, 150), (222, 52, 52), (120, 0, 0)],         # code never run: red
       3: [(246, 238, 238), (226, 206, 206), (198, 168, 168), (150, 112, 112)],   # padding: muted red
       4: [(255, 240, 214), (252, 200, 120), (240, 140, 20), (140, 66, 0)],       # identified data never read: orange
       5: [(240, 226, 250), (204, 168, 236), (150, 90, 200), (70, 20, 110)],      # only in forced runs: purple
       8: [(250, 246, 236), (240, 230, 210), (226, 210, 180), (196, 176, 140)],   # $FF fill: beige
       9: [(232, 236, 242), (190, 200, 216), (128, 144, 170), (60, 72, 96)]}      # data explained by nothing: grey-blue
idx = {c: k for k, c in enumerate(sorted(FAM))}
pix = (np.vectorize(idx.get)(rowcat)[:, :, None] * 4 + sh).astype(np.uint8)
BG, INK = 4 * len(FAM), 4 * len(FAM) + 1
pal = [c for k in sorted(FAM) for c in FAM[k]] + [(255, 255, 255), (0, 0, 0)]
BTW, BTH, BCOLS = 16, 64, 8
banks = N // 0x4000; per = pix.reshape(banks, BTH, BTW, 8, 8).transpose(0, 1, 3, 2, 4).reshape(banks, 8 * BTH, 8 * BTW)
S = 2; GX, LEFT = 18, 40; PADT = 40; GY = PADT + 40
PW, PH = 8 * BTW * S, 8 * BTH * S
W = LEFT + BCOLS * (PW + GX) + 22
def font(sz, bold=True):
    for p in ('/usr/share/fonts/truetype/dejavu/DejaVuSans%s.ttf' % ('-Bold' if bold else ''), '/usr/share/fonts/dejavu/DejaVuSans%s.ttf' % ('-Bold' if bold else '')):
        if os.path.exists(p): return ImageFont.truetype(p, sz)
    return ImageFont.load_default(size=sz)
f1, f2, f3, fb = font(46), font(28, False), font(27, False), font(32)
n = lambda m: int(m.sum())
c_blue, c_red, c_grey, c_or, c_pad, c_fill, c_forced = (n(cat == c) for c in (0, 2, 9, 4, 3, 8, 5))
c_code = n(code); c_ran = n(code & ex)
pc = lambda v: '%s B, %.1f %%' % (format(v, ','), 100 * v / N)
items = [(0, 'blue: executed or read in a run (the core runs of tools/proto_coverage.py on the image as dumped: blank SRAM and the owner\'s save)  (%s)' % pc(c_blue)),
         (2, 'RED: proven code that no run executed  (%s): %s of the %s bytes of proven code ran (the timer interrupt, the self-test error paths, the link code: port/observed_proto.md)' % (pc(c_red), format(c_ran, ','), format(c_code, ','))),
         (9, 'GREY-BLUE: data that no run read and nothing explains yet (still on the default typing: mostly the leftover banks)  (%s)' % pc(c_grey)),
         (4, 'ORANGE: data that no run read, explained by a type row (leftover text, old symbol tables, copy sources, bank numbers, header) or an inline table  (%s)' % pc(c_or)),
         (3, 'muted red: never-read runs of 16+ x $00, padding  (%s)' % pc(c_pad)),
         (8, 'beige: never-read runs of 16+ x $FF, fill  (%s)' % pc(c_fill))]
note = 'Shade inside a colour = the tile pixel (2 bits), so graphics, text and code all stay visible. A 2-byte tile row takes the worst colour of its two bytes (red > grey-blue > orange > fill > padding > blue). The running code is bank $00 alone (L2): every other bank is only read as data.'
_sc = ImageDraw.Draw(Image.new('L', (8, 8)))
def wrap(text, fnt, maxw):
    out, line = [], ''
    for w_ in text.split(' '):
        cand = (line + ' ' + w_).strip()
        if _sc.textlength(cand, font=fnt) <= maxw or not line: line = cand
        else: out.append(line); line = w_
    return out + [line]
TXW = W - LEFT - 20
title = wrap('Pocket Camera Prototype (Japan) ("DEBAGAME"): what the runs reached, the whole ROM drawn as 2bpp tiles, 64 banks of 16 KB', f1, TXW)
sub = wrap('Each bank = 16 x 64 tiles = 16,384 bytes, banks $00..$3F left to right, top to bottom, 8 banks per row, in the colours of the Japanese reachability map. Red and grey-blue are what is still missing.', f2, TXW)
y = 18 + 58 * len(title) + 6 + 36 * len(sub) + 24; lay = []
for c, txt in items:
    lines = wrap(txt, f3, TXW - 170); lay.append((c, y, lines)); y += 35 * len(lines) + 8
notel = wrap(note, f3, TXW); ynote = y + 6; y = ynote + 35 * len(notel)
TOP = y + 40
H = TOP + (banks // BCOLS) * (PH + GY) + 20
canvas = np.full((H, W), BG, np.uint8)
for b in range(banks):
    gx = LEFT + (b % BCOLS) * (PW + GX); gy = TOP + (b // BCOLS) * (PH + GY) + GY
    canvas[gy:gy + PH, gx:gx + PW] = np.kron(per[b], np.ones((S, S), np.uint8))
img = Image.fromarray(canvas, 'P'); img.putpalette([v for c in pal for v in c] + [0] * (768 - 3 * len(pal)))
d = ImageDraw.Draw(img); yy = 18
for l in title: d.text((LEFT, yy), l, fill=INK, font=f1); yy += 58
yy += 6
for l in sub: d.text((LEFT, yy), l, fill=INK, font=f2); yy += 36
for c, y0, lines in lay:
    for s_ in range(4): d.rectangle([LEFT + s_ * 36, y0 + 3, LEFT + s_ * 36 + 34, y0 + 29], fill=idx[c] * 4 + s_)
    for k_, l in enumerate(lines): d.text((LEFT + 170, y0 + 35 * k_), l, fill=INK, font=f3)
for k_, l in enumerate(notel): d.text((LEFT, ynote + 35 * k_), l, fill=INK, font=f3)
for b in range(banks):
    gx = LEFT + (b % BCOLS) * (PW + GX); gy = TOP + (b // BCOLS) * (PH + GY)
    d.text((gx, gy + PADT), '$%02X' % b, fill=INK, font=fb)
img.save(OUT, optimize=True)
per_bank = [(b, n(cat[b * 0x4000:(b + 1) * 0x4000] == 2), n(cat[b * 0x4000:(b + 1) * 0x4000] == 9)) for b in range(banks)]
print('proto_reach: blue %d, red %d, grey-blue %d, orange %d, padding %d, fill %d bytes' % (c_blue, c_red, c_grey, c_or, c_pad, c_fill))
print('most red (code never run):', ', '.join('$%02X %d' % (b, r) for b, r, _ in sorted(per_bank, key=lambda x: -x[1])[:8]))
print('most grey-blue (data unexplained):', ', '.join('$%02X %d' % (b, g) for b, _, g in sorted(per_bank, key=lambda x: -x[2])[:8]))
