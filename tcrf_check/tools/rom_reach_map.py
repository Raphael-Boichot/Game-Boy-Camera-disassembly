#!/usr/bin/env python3
"""Whole JP ROM as 2bpp tiles (code and everything else), coloured by what the v8 coverage run reached.
blue = executed or read by a run (dark: joypad + save only; light: only after a forced RAM / mode state), red = never executed nor read
(including traced code that never ran), orange = never read but identified as asset data (assets/asset_map_jp.csv, evidence I or C per row),
green = code the v8 run never executed but a later targeted run did (assets/witness_jp.csv: BGB in SGB mode, the hot-spot effect test, the APU-gated branch, the printer runs, the stamp mirror, the music-editor, RUN!, D.J. sound-effect, Space Fever II and erase-all runs, the link counters / $55 hello, the blank calibration, the D.J. pages, the editor copy badge; README 16.14 / 16.15 / 16.18 / 16.19),
muted red = untouched padding (runs >= 16 of 00 / FF).
usage: rom_reach_map.py OUT.png [--rom pocketcamera_jp.gb] [--map coverage/results/report_v8/rom_map.csv] [--assets assets/asset_map_jp.csv | none] [--witness assets/witness_jp.csv | none]
The ROM is not in the repository (md5 fdcfe686cf4df461e870b6e53b2b5a8b); the byte-class map is (written by coverage/tools/rom_map.py from the v8 merged coverage)."""
import sys, os, csv
import numpy as np
from PIL import Image, ImageDraw, ImageFont
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(os.path.dirname(HERE))
a = sys.argv[1:]
def opt(n, d):
    if n in a: i = a.index(n); v = a[i + 1]; del a[i:i + 2]; return v
    return d
ROM = opt('--rom', 'pocketcamera_jp.gb'); MAP = opt('--map', os.path.join(REPO, 'coverage', 'results', 'report_v8', 'rom_map.csv'))
ASSETS = opt('--assets', os.path.join(REPO, 'assets', 'asset_map_jp.csv')); WIT = opt('--witness', os.path.join(REPO, 'assets', 'witness_jp.csv')); OUT = a[0]
rom = np.frombuffer(open(ROM, 'rb').read(), np.uint8); N = len(rom)
cls = np.zeros(N, np.uint8)
for r in csv.DictReader(open(MAP)):
    b = int(r['bank'], 16); ad = int(r['start'], 16); o = b * 0x4000 + (ad - 0x4000 if b else ad); cls[o:o + int(r['length'])] = ord(r['class'])
assert (cls > 0).all(), 'the byte-class map does not cover the whole ROM'
pad = np.zeros(N, bool); i = 0
rb = rom.tobytes()
while i < N:
    j = i
    while j < N and rb[j] == rb[i]: j += 1
    if j - i >= 16 and rb[i] in (0, 255): pad[i:j] = True
    i = j
C = lambda ch: cls == ord(ch)
wit = np.zeros(N, bool)         # class N bytes that a later targeted run executed (assets/witness_jp.csv)
if WIT != 'none' and os.path.exists(WIT):
    for r in csv.DictReader(open(WIT)):
        b = int(r['bank'], 16); o1 = b * 0x4000 + (int(r['start'], 16) - 0x4000 if b else int(r['start'], 16)); o2 = b * 0x4000 + (int(r['end'], 16) - 0x4000 if b else int(r['end'], 16))
        wit[o1:o2 + 1] = True
wit &= C('N')
red = (C('N') & ~wit) | C('U'); forced = C('F') | C('r'); organic = C('C') | C('R') | C('T')
# bytes of the never-read data that assets/asset_map_jp.csv labels (padding stays padding)
ident = np.zeros(N, bool)
if ASSETS != 'none' and os.path.exists(ASSETS):
    for r in csv.DictReader(open(ASSETS)):
        b = int(r['bank'], 16); o1 = b * 0x4000 + (int(r['start'], 16) - 0x4000 if b else int(r['start'], 16)); o2 = b * 0x4000 + (int(r['end'], 16) - 0x4000 if b else int(r['end'], 16))
        ident[o1:o2 + 1] = True
ident &= C('U') & ~pad
# category per byte: 0 organic blue, 1 forced-only light blue, 2 red, 3 untouched padding, 4 never read but identified as asset data (orange), 5 executed by a later targeted run (green)
cat = np.zeros(N, np.uint8); cat[forced] = 1; cat[red] = 2; cat[C('U') & pad] = 3; cat[ident] = 4; cat[wit] = 5
# category per 2-byte tile row: the worst of the two bytes (red > identified > padding > green > forced > organic) so that a red byte is never hidden
RANK = np.array([0, 1, 5, 3, 4, 2]); BACK = np.array([0, 1, 5, 3, 4, 2])        # category -> rank, rank -> category
rowcat = BACK[np.maximum(RANK[cat[0::2]], RANK[cat[1::2]])].reshape(-1, 8)  # (tiles, 8 rows)
t = rom.reshape(-1, 8, 2); lo = t[:, :, 0]; hi = t[:, :, 1]
sh = np.zeros((len(t), 8, 8), np.uint8)
for x in range(8): sh[:, :, x] = ((lo >> (7 - x)) & 1) | (((hi >> (7 - x)) & 1) << 1)
# palette index = category * 4 + GB shade (0 = white ... 3 = black)
pix = (rowcat[:, :, None] * 4 + sh).astype(np.uint8)
FAM = [[(222, 234, 255), (150, 180, 240), (66, 106, 205), (8, 28, 112)],        # organic: blue
       [(224, 248, 252), (150, 222, 238), (64, 176, 208), (12, 104, 140)],      # forced only: light blue / cyan
       [(255, 224, 224), (248, 150, 150), (222, 52, 52), (120, 0, 0)],          # never executed nor read: red
       [(246, 238, 238), (226, 206, 206), (198, 168, 168), (150, 112, 112)],    # untouched padding: muted red
       [(255, 240, 214), (252, 200, 120), (240, 140, 20), (140, 66, 0)],        # never read, identified as asset data: orange
       [(226, 246, 226), (150, 214, 150), (48, 160, 64), (0, 84, 24)]]          # never run by v8, run by a later targeted run: green
BG, INK = 24, 25
pal = [c for f in FAM for c in f] + [(255, 255, 255), (0, 0, 0)]
banks = N // 0x4000; per = pix.reshape(banks, 32, 32, 8, 8).transpose(0, 1, 3, 2, 4).reshape(banks, 256, 256)
S = 2; GX, GY, PADX, PADY, TOP, LEFT = 12, 34, 12, 34, 290, 40
W = LEFT + 8 * (256 * S + GX) + 10; H = TOP + 8 * (256 * S + GY) + 10
canvas = np.full((H, W), BG, np.uint8)
for b in range(banks):
    gx = LEFT + (b % 8) * (256 * S + GX); gy = TOP + (b // 8) * (256 * S + GY) + (GY - 6)
    canvas[gy:gy + 256 * S, gx:gx + 256 * S] = np.kron(per[b], np.ones((S, S), np.uint8))
img = Image.fromarray(canvas, 'P'); flat = [v for c in pal for v in c] + [0] * (768 - 3 * len(pal)); img.putpalette(flat)
d = ImageDraw.Draw(img)
def font(sz):
    for p in ('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf', '/usr/share/fonts/dejavu/DejaVuSans-Bold.ttf'):
        if os.path.exists(p): return ImageFont.truetype(p, sz)
    return ImageFont.load_default(size=sz)
f1, f2, f3 = font(34), font(22), font(19)
n = lambda m: int(m.sum())
tot = N; nonpad = tot - n(pad)
r_pad = n(C('U') & pad); r_code = n(C('N') & ~wit); r_ident = n(ident); r_wit = n(wit); r_bright = n(red) - r_pad - r_ident
d.text((LEFT, 12), 'Pocket Camera (Japan) Rev A: the whole ROM drawn as 2bpp tiles (code, data, padding), 64 banks of 16 KB', fill=INK, font=f1)
d.text((LEFT, 58), 'Each bank = 32 x 32 tiles = 16,384 bytes, banks $00..$3F left to right, top to bottom. Coverage run v8: 238 M frames, 57,582 of 60,449 traced instructions executed.', fill=INK, font=f2)
items = [(0, 'blue: executed or read, by joypad + save only  (%s B, %.1f %%)' % (format(n(organic), ','), 100 * n(organic) / tot)),
         (1, 'light blue: executed or read only after a forced RAM / mode state  (%s B, %.1f %%)' % (format(n(forced), ','), 100 * n(forced) / tot)),
         (2, 'RED: never executed nor read, not identified  (%s B, %.1f %%): %s B code that never ran + %s B data' % (format(r_bright, ','), 100 * r_bright / tot, format(r_code, ','), format(r_bright - r_code, ','))),
         (5, 'GREEN: code the v8 run never executed but a later targeted run did  (%s B, %.1f %%): SGB sender, hot-spot effects, stamp mirror, comment card, D.J. score print and fields, printer resend and error exits, RUN! result, D.J. sound effects, Space Fever II boss, erase-all shortcut, MAGIC option (BGB or core)' % (format(r_wit, ','), 100 * r_wit / tot)),
         (4, 'ORANGE: never read, but identified as asset data  (%s B, %.1f %%): tilemaps, kana glyphs, wild-frame side strips, SGB data, tile-set gaps' % (format(r_ident, ','), 100 * r_ident / tot)),
         (3, 'muted red: untouched padding, runs of 16+ x 00 / FF  (%s B, %.1f %%)' % (format(r_pad, ','), 100 * r_pad / tot))]
for k, (c, txt) in enumerate(items):
    y = 98 + k * 23
    for s in range(4): d.rectangle([LEFT + s * 22, y + 1, LEFT + s * 22 + 21, y + 18], fill=c * 4 + s)
    d.text((LEFT + 100, y), txt, fill=INK, font=f3)
d.text((LEFT, 98 + 6 * 23 + 2), 'Shade inside a colour = the tile pixel (2 bits), so graphics, text and code all stay visible. A red byte inside a 2-byte tile row turns the whole row red; orange beats padding, green beats the blues.', fill=INK, font=f3)
for b in range(banks):
    gx = LEFT + (b % 8) * (256 * S + GX); gy = TOP + (b // 8) * (256 * S + GY)
    d.text((gx, gy + 1), '$%02X' % b, fill=INK, font=f2)
img.save(OUT, optimize=True)
print(img.size, os.path.getsize(OUT), 'red', r_bright, 'identified', r_ident, 'witnessed', r_wit, 'organic', n(organic), 'forced', n(forced), 'pad red', r_pad)
