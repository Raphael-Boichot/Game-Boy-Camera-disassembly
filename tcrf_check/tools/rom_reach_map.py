#!/usr/bin/env python3
"""Whole JP ROM as 2bpp tiles (code and everything else), coloured by what the v8 coverage run reached.
blue = executed or read by a run (dark: joypad + save only; light: only after a forced RAM / mode state), red = never executed nor read
(including traced code that never ran), orange = never read but identified as asset data (roms/jp_rev_a/assets/asset_map_jp.csv, evidence I or C per row),
green = code the v8 run never executed but a later targeted run did, and three kinds of data the v8 run never read: the data sent to the Super Game Boy (asset_map rows sgb_*, evidence C: README 16.13 (5)), the wild-frame lateral strips (shown to be used by the print path by the BGB blanking test, asset_map rows of type wild_frame_lateral with evidence C: README 16.13 (1)) and the stamp pictures (sym labels StampCat*_Gfx, evidence C) that the stamp-menu walks of the display tracker put on screen in runs without state pokes (README 16.24) (assets/witness_jp.csv: BGB in SGB mode, the hot-spot effect test, the APU-gated branch, the printer runs, the stamp mirror, the music-editor, RUN!, D.J. sound-effect, Space Fever II and erase-all runs, the link counters / $55 hello, the blank calibration, the D.J. pages, the editor copy badge, the Game Face editor, the COMPOSE pickers; README 16.14 / 16.15 / 16.18 / 16.19),
purple = code that never ran and is proven dead (verdict UNREACHABLE or UNREFERENCED in roms/jp_rev_a/assets/reach_ranges_jp.csv, from reach_analysis.py: README 16.15 / 16.21),
yellow = asset data that no replay ever put on screen in a run without state pokes, the REALLY unused assets of README 16.24 (tcrf_check/assets/unidentified/really_unused.csv: tiers 'no loader', 'never shown', 'forced only' and the TCRF-labelled spans never on screen in an organic run; it takes the bytes of those spans away from blue, light blue and orange),
muted red = untouched padding (runs >= 16 of 00 / FF).
usage: rom_reach_map.py OUT.png [--rom pocketcamera_jp.gb] [--map coverage/v8/report_v8/rom_map.csv] [--assets roms/jp_rev_a/assets/asset_map_jp.csv | none] [--witness roms/jp_rev_a/assets/witness_jp.csv | none] [--reach roms/jp_rev_a/assets/reach_ranges_jp.csv | none] [--unused tcrf_check/assets/unidentified/really_unused.csv | none]
The ROM is not in the repository (md5 fdcfe686cf4df461e870b6e53b2b5a8b); the byte-class map is (written by coverage/tools/rom_map.py from the v8 merged coverage)."""
import sys, os, csv
import numpy as np
from PIL import Image, ImageDraw, ImageFont
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(os.path.dirname(HERE)); sys.path.insert(0, HERE)
a = sys.argv[1:]
def opt(n, d):
    if n in a: i = a.index(n); v = a[i + 1]; del a[i:i + 2]; return v
    return d
ROM = opt('--rom', 'pocketcamera_jp.gb'); MAP = opt('--map', os.path.join(REPO, 'coverage', 'v8', 'report_v8', 'rom_map.csv'))
ASSETS = opt('--assets', os.path.join(REPO, 'roms', 'jp_rev_a', 'assets', 'asset_map_jp.csv')); WIT = opt('--witness', os.path.join(REPO, 'roms', 'jp_rev_a', 'assets', 'witness_jp.csv'))
REACH = opt('--reach', os.path.join(REPO, 'roms', 'jp_rev_a', 'assets', 'reach_ranges_jp.csv'))
UNUSED = opt('--unused', os.path.join(REPO, 'tcrf_check', 'assets', 'unidentified', 'really_unused.csv')); OUT = a[0]
import rom_reach_classes as RC
_g = RC.build(ROM, MAP, ASSETS, WIT, REACH, UNUSED, REPO)
rom, N, cls, pad, C, wit, dead, red, forced, organic, ident, lat, sgb, stamp, unused, n_unused_spans, n_unused_tcrf, cat = (_g[k] for k in 'rom N cls pad C wit dead red forced organic ident lat sgb stamp unused n_unused_spans n_unused_tcrf cat'.split())
# category per 2-byte tile row: the worst of the two bytes (red > proven dead > really unused > identified > padding > green > forced > organic) so that a red byte is never hidden
RANK = np.array([0, 1, 7, 3, 4, 2, 6, 5]); BACK = np.array([0, 1, 5, 3, 4, 7, 6, 2])        # category -> rank, rank -> category
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
       [(226, 246, 226), (150, 214, 150), (48, 160, 64), (0, 84, 24)],          # never run by v8, run by a later targeted run: green
       [(244, 226, 250), (214, 160, 232), (150, 70, 190), (72, 10, 104)],       # never run, proven dead (unreachable / unreferenced)
       [(255, 251, 205), (250, 232, 80), (222, 186, 0), (104, 84, 0)]]          # really unused asset data (never on screen in an organic run): purple
BG, INK = 4 * len(FAM), 4 * len(FAM) + 1
pal = [c for f in FAM for c in f] + [(255, 255, 255), (0, 0, 0)]
banks = N // 0x4000; per = pix.reshape(banks, 32, 32, 8, 8).transpose(0, 1, 3, 2, 4).reshape(banks, 256, 256)
S = 2; GX, GY, PADX, PADY, TOP, LEFT = 12, 34, 12, 34, 350, 40
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
r_unused = n(unused); r_pad = n(C('U') & pad & ~lat); r_code = n(C('N') & ~wit); r_dead = n(dead); r_ident = n(ident & ~unused); r_wit = n(wit); r_lat = n(lat); r_stamp = n(stamp); r_sgb = n(sgb)
r_bright = n(red) - r_pad - n(ident | (unused & C('U'))) - r_dead - r_lat - r_stamp - r_sgb; r_org = n(organic & ~unused); r_forc = n(forced & ~unused)
assert int(np.bincount(cat, minlength=8).sum()) == N
assert int((np.bincount(cat, minlength=8)).sum()) == N
d.text((LEFT, 12), 'Pocket Camera (Japan) Rev A: the whole ROM drawn as 2bpp tiles (code, data, padding), 64 banks of 16 KB', fill=INK, font=f1)
d.text((LEFT, 58), 'Each bank = 32 x 32 tiles = 16,384 bytes, banks $00..$3F left to right, top to bottom. Coverage run v8: 238 M frames, 57,582 of 60,449 traced instructions executed.', fill=INK, font=f2)
items = [(0, 'blue: executed or read, by joypad + save only  (%s B, %.1f %%)' % (format(r_org, ','), 100 * r_org / tot)),
         (1, 'light blue: executed or read only after a forced RAM / mode state  (%s B, %.1f %%)' % (format(r_forc, ','), 100 * r_forc / tot)),
         (2, 'RED: never executed nor read, not identified  (%s B, %.1f %%): %s B code that never ran + %s B data' % (format(r_bright, ','), 100 * r_bright / tot, format(r_code - r_dead, ','), format(r_bright - (r_code - r_dead), ','))),
         (5, 'GREEN: never run or read by the v8 run, but a later targeted run did  (%s B, %.1f %%): %s B of code (SGB sender, printer and its error exits, hot-spot effects, stamp mirror, D.J. pages and sound effects, Space Fever II boss, RUN! podium, slide-show markers, COMPOSE pickers, WRAM / SRAM-poked cases; README 16.14, 16.21)\n+ %s B of data: wild-frame lateral strips used by the print path (%s B, BGB blanking test, README 16.13), stamp pictures shown by the stamp-menu walks (%s B, README 16.24), data sent to the Super Game Boy, whose border BGB shows equal to the one rebuilt from it (%s B, README 16.13)' % (format(r_wit + r_lat + r_stamp + r_sgb, ','), 100 * (r_wit + r_lat + r_stamp + r_sgb) / tot, format(r_wit, ','), format(r_lat + r_stamp + r_sgb, ','), format(r_lat, ','), format(r_stamp, ','), format(r_sgb, ','))),
         (6, 'PURPLE: code that never ran and is proven dead  (%s B, %.1f %%): dead functions (nothing calls them) and branches no value can select (UNREFERENCED / UNREACHABLE, evidence I: README 16.15, 16.21)' % (format(r_dead, ','), 100 * r_dead / tot)),
         (4, 'ORANGE: never read, but identified as asset data  (%s B, %.1f %%): tilemaps, kana glyphs and text, tile-set gaps, a few SGB blocks (evidence I)' % (format(r_ident, ','), 100 * r_ident / tot)),
         (7, 'YELLOW: asset data no replay ever put on screen in a run without state pokes, the really unused assets  (%s B, %.1f %%, %d spans, %d of them TCRF-documented): the alternate stand-by screen of the image exchange, TCRF graphics, never-shown strips and tilemaps (README 16.24)' % (format(r_unused, ','), 100 * r_unused / tot, n_unused_spans, n_unused_tcrf)),
         (3, 'muted red: untouched padding, runs of 16+ x 00 / FF  (%s B, %.1f %%)' % (format(r_pad, ','), 100 * r_pad / tot))]
y = 98; widest = 0
for c, txt in items:
    lines = txt.split('\n')
    for s_ in range(4): d.rectangle([LEFT + s_ * 22, y + 1, LEFT + s_ * 22 + 21, y + 18], fill=c * 4 + s_)
    for li, ln in enumerate(lines):
        d.text((LEFT + 100, y + li * 23), ln, fill=INK, font=f3); widest = max(widest, LEFT + 100 + d.textlength(ln, font=f3))
    y += 23 * len(lines)
note = 'Shade inside a colour = the tile pixel (2 bits), so graphics, text and code all stay visible. A red byte inside a 2-byte tile row turns the whole row red; yellow beats orange, orange beats padding, green beats the blues.'
d.text((LEFT, y + 2), note, fill=INK, font=f3)
assert y + 2 + 22 < TOP, 'legend overlaps the first bank row'
if widest > W - 10: print('WARNING: a legend line is cut off (%d px of %d)' % (widest, W))
for b in range(banks):
    gx = LEFT + (b % 8) * (256 * S + GX); gy = TOP + (b // 8) * (256 * S + GY)
    d.text((gx, gy + 1), '$%02X' % b, fill=INK, font=f2)
img.save(OUT, optimize=True)
if ASSETS != 'none' and os.path.exists(ASSETS):
    import collections; brk = collections.Counter()
    for r in csv.DictReader(open(ASSETS)):
        b = int(r['bank'], 16); o1 = b * 0x4000 + (int(r['start'], 16) - 0x4000 if b else int(r['start'], 16)); o2 = b * 0x4000 + (int(r['end'], 16) - 0x4000 if b else int(r['end'], 16))
        m = np.zeros(N, bool); m[o1:o2 + 1] = True; brk[(r['type'], r['evidence'])] += int((m & ident & ~unused).sum())
    print('orange by (type, evidence):', {k: v for k, v in sorted(brk.items()) if v})
print(img.size, os.path.getsize(OUT), 'red', r_bright, 'identified', r_ident, 'unused', r_unused, n_unused_spans, 'witnessed', r_wit, 'lateral', r_lat, 'stamps', r_stamp, 'sgb', r_sgb, 'organic', r_org, 'forced', r_forc, 'pad red', r_pad)
print('yellow takes from: orange', n(unused & ident), 'blue', n(unused & organic), 'light blue', n(unused & forced & ~organic), 'other', n(unused) - n(unused & ident) - n(unused & organic) - n(unused & forced & ~organic))
