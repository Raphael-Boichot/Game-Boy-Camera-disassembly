#!/usr/bin/env python3
"""Compose the Japanese / international side-by-side sheets (hot-spot effect icons, Pokemon stamps, どみーる = SHOW) from the captures of
view_show_capture.py, hs_picker_capture.py, stamp_cat_capture.py and from the two ROMs.   usage: make_us_jp_sheets.py WORKDIR OUTDIR"""
import sys, os, glob
from PIL import Image, ImageDraw, ImageFont
W, O = sys.argv[1:3]; os.makedirs(O, exist_ok=True)
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
jp = open(os.path.join(ROOT, 'pocketcamera_jp.gb'), 'rb').read(); us = open(os.path.join(ROOT, 'roms', 'gbcam_usa_eu.gb'), 'rb').read()
BG = (60, 60, 100); YEL = (255, 255, 0); WHITE = (255, 255, 255)
def font(sz):
    for f in ('/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc', '/usr/share/fonts/truetype/noto/NotoSansCJK-Regular.ttc', '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf'):
        if os.path.exists(f):
            try: return ImageFont.truetype(f, sz)
            except Exception: pass
    return ImageFont.load_default()
F = font(13); FS = font(11); FB = font(16)
def im(p, sc=2): return Image.open(p).convert('RGB').resize((Image.open(p).width * sc, Image.open(p).height * sc), Image.NEAREST)
def pair_sheet(rows, fn, title, sc=2):
    """rows: (caption, jp_png, us_png): caption line, then the two screens with a JP / US-EU tag"""
    w, h = 160 * sc, 144 * sc; S = Image.new('RGB', (2 * w + 24, 34 + len(rows) * (h + 40)), BG); d = ImageDraw.Draw(S)
    d.text((8, 6), title, fill=WHITE, font=FB)
    for k, (cap, a, b) in enumerate(rows):
        y = 34 + k * (h + 40); d.text((8, y + 2), cap, fill=WHITE, font=F); d.text((8, y + 18), 'Japanese ROM', fill=YEL, font=FS); d.text((w + 16, y + 18), 'international ROM (US/EU)', fill=YEL, font=FS)
        S.paste(im(a, sc), (8, y + 34)); S.paste(im(b, sc), (w + 16, y + 34))
    S.save(os.path.join(O, fn)); print(fn, S.size)
# ---------------------------------------------------------------- 1. VIEW / SHOW (どみーる)
v = lambda r, n: '%s/%s_%s.bmp' % (W, r, n)
pair_sheet([('VIEW menu, cursor on the left item: みる = ALBUM', v('jp', '01_view_menu_cursor_left'), v('us', '01_view_menu_cursor_left')),
            ('VIEW menu, cursor on the right item: どみーる = SHOW', v('jp', '02_view_menu_cursor_right'), v('us', '02_view_menu_cursor_right')),
            ('SHOW menu (opened by どみーる), cursor on the 3rd item: ピクトリップ = HOT-SPOT', v('jp', '05_show_menu_item3_hotspot'), v('us', '05_show_menu_item3_hotspot')),
            ('HOT-SPOT: choose the photo (mode 0C)', v('jp', '06_hotspot_select_photo'), v('us', '06_hotspot_select_photo')),
            ('HOT-SPOT viewer (mode 0C): captions PICTRIP / HOT SPOT', v('jp', '07_hotspot_viewer'), v('us', '07_hotspot_viewer'))], 'domiiru_view_show_jp_vs_us.png', 'どみーる = SHOW (right item of the VIEW menu); its menu: SLIDE SHOW / ANIMATION / HOT-SPOT (ピクトリップ)')
# ---------------------------------------------------------------- 2. hot-spot editor and effect picker
ed = [('editor, photo grid (1A:01)', v('jp', '08_hotspot_editor_photo_grid'), v('us', '08_hotspot_editor_photo_grid')), ('editor, 5 hot-spot slots (1A:03)', v('jp', '09_hotspot_editor_slots'), v('us', '09_hotspot_editor_slots'))]
names = ['FF', '00', '01', '02', '03', '04', '05', '06']; labels = ['OFF', '01', '02', '03', '04', '05', '06', '07']
box = (0, 96, 160, 144); sc = 2
pw, ph = 160 * sc, 48 * sc
S = Image.new('RGB', (2 * (160 * 2) + 24, 30 + 2 * (144 * 2 + 22) + 8 * (ph + 18) + 40), BG); d = ImageDraw.Draw(S)
d.text((8, 6), 'Hot-spot editor and its EFFECT picker (mode 1A state 6): OFF and 01-07, nothing beyond', fill=WHITE, font=FB)
y = 30
for cap, a, b in ed:
    d.text((8, y + 2), 'JP  ' + cap, fill=YEL, font=FS); d.text((160 * 2 + 16, y + 2), 'US/EU  ' + cap, fill=YEL, font=FS)
    S.paste(im(a), (8, y + 20)); S.paste(im(b), (160 * 2 + 16, y + 20)); y += 144 * 2 + 22
for k in range(8):
    fa = '%s/jp_picker_%d.bmp' % (W, k); fb = '%s/us_picker_%d.bmp' % (W, k)
    d.text((8, y + 2), 'JP  effect picker: %s' % labels[k], fill=YEL, font=FS); d.text((160 * 2 + 16, y + 2), 'US/EU  effect picker: %s' % labels[k], fill=YEL, font=FS)
    S.paste(Image.open(fa).convert('RGB').crop(box).resize((pw, ph), Image.NEAREST), (8, y + 18)); S.paste(Image.open(fb).convert('RGB').crop(box).resize((pw, ph), Image.NEAREST), (160 * 2 + 16, y + 18)); y += ph + 18
S = S.crop((0, 0, S.width, y + 6)); S.save(os.path.join(O, 'hotspot_editor_effect_picker_jp_vs_us.png')); print('picker sheet', S.size)
# ---------------------------------------------------------------- 3. the 16 icons from the ROM (identical in both ROMs)
PAL = [255, 170, 85, 0]
def tile(b, off): return [[((b[off + y * 2 + 1] >> (7 - x)) & 1) << 1 | ((b[off + y * 2] >> (7 - x)) & 1) for x in range(8)] for y in range(8)]
def icon(b, off):
    i = Image.new('L', (16, 16)); px = i.load()
    for t, (tx, ty) in enumerate([(0, 0), (1, 0), (0, 1), (1, 1)]):
        T = tile(b, off + 16 * t)
        for yy in range(8):
            for xx in range(8): px[tx * 8 + xx, ty * 8 + yy] = PAL[T[yy][xx]]
    return i
base = 0x1C * 0x4000 + 0x5760 - 0x4000
same = jp[base:base + 15 * 64] == us[base:base + 15 * 64]
print('15 icons 1C:5760-5B1F identical in both ROMs:', same)
SC = 5; cw = 16 * SC + 16; cols = 8
S = Image.new('RGB', (cols * cw + 8, 70 + 2 * (16 * SC + 62) + 30), BG); d = ImageDraw.Draw(S)
d.text((8, 6), 'The 16 hot-spot effect icons: OFF + 7 in the game (values 0-6) + 8 never offered (values 7-14)', fill=WHITE, font=FB)
d.text((8, 28), 'ROM data 1C:5760 + 64 x value, 2x2 tiles of 16 B; the same bytes in the Japanese and the international ROM = %s' % ('identical' if same else 'DIFFERENT'), fill=YEL, font=F)
off_img = Image.open('%s/jp_picker_0.bmp' % W).convert('L')
items = [('OFF', 'screen crop of the picker\n(graphic in bank 13)', off_img.crop((56, 106, 72, 122)))]
for k in range(15):
    a = 0x5760 + 64 * k
    items.append(('value %d' % k if k < 7 else 'value %d' % k, '1C:%04X\n%s' % (a, ('shown as %02d' % (k + 1)) if k < 7 else 'not selectable'), icon(jp, base + 64 * k)))
for n, (t1, t2, ic) in enumerate(items):
    x = 8 + (n % cols) * cw; y = 56 + (n // cols) * (16 * SC + 62)
    S.paste(ic.convert('RGB').resize((16 * SC, 16 * SC), Image.NEAREST), (x, y + 18)); d.text((x, y), t1, fill=YEL, font=F); d.text((x, y + 18 + 16 * SC + 2), t2, fill=WHITE, font=FS)
S.save(os.path.join(O, 'hotspot_16_effect_icons.png')); print('icons sheet', S.size)
# ---------------------------------------------------------------- 4. Pokemon stamps
NAMES = ['Charmander', 'Bulbasaur', 'Squirtle', 'Rattata', 'Nidoran female', 'Clefairy', 'Pikachu', 'Cubone', 'Poliwhirl', 'Eevee', 'Meowth', 'Jigglypuff', 'Dragonair', 'Machop', 'Horsea', 'Psyduck', 'Abra', 'Oddish', 'Diglett', 'Mew']
USMAP = {1: 1, 2: 2, 3: 3, 4: 7, 5: 11, 6: 20}                       # US stamp number -> JP stamp number (identical 400 bytes)
def stamp(b, n):
    o = 0x2C * 0x4000 + 0x6000 - 0x4000 + 0x190 * (n - 1); i = Image.new('L', (40, 40)); px = i.load()
    for t in range(25):
        T = tile(b, o + 16 * t); tx, ty = t % 5, t // 5
        for yy in range(8):
            for xx in range(8): px[tx * 8 + xx, ty * 8 + yy] = PAL[T[yy][xx]]
    return i
for u, j in USMAP.items(): assert us[0x2C * 0x4000 + 0x2000 + 0x190 * (u - 1):][:0x190] == jp[0x2C * 0x4000 + 0x2000 + 0x190 * (j - 1):][:0x190]
SC = 3; cw = 40 * SC + 16; ch = 40 * SC + 40; cols = 5
S = Image.new('RGB', (max(cols * cw + 8, 780), 60 + 4 * ch + 20), BG); d = ImageDraw.Draw(S); d = ImageDraw.Draw(S)
d.text((8, 6), 'The 20 Pokémon stamps of the Japanese ROM (2C:6000 + n x 190h)', fill=WHITE, font=FB)
d.text((8, 28), 'names: given by the owner of the cameras; orange frame = also in the international ROM (6 stamps, same 400 bytes)', fill=YEL, font=F)
inv = {j: u for u, j in USMAP.items()}
for n in range(1, 21):
    x = 8 + ((n - 1) % cols) * cw; y = 50 + ((n - 1) // cols) * ch
    s = stamp(jp, n).convert('RGB').resize((40 * SC, 40 * SC), Image.NEAREST)
    if n in inv: d.rectangle((x - 3, y + 15, x + 40 * SC + 2, y + 18 + 40 * SC + 2), outline=(255, 120, 0), width=3)
    S.paste(s, (x, y + 18)); d.text((x, y), '#%d %s' % (n, NAMES[n - 1]), fill=YEL, font=F); d.text((x, y + 20 + 40 * SC + 2), ('US/EU stamp %d of 6' % inv[n]) if n in inv else 'JP only', fill=(255, 160, 60) if n in inv else WHITE, font=FS)
S.save(os.path.join(O, 'pokemon_stamps_20_jp_vs_us.png')); print('stamps sheet', S.size)
# chooser screens
jpf = ['%s/jp_stamps_cat2_page%02d.bmp' % (W, k) for k in range(10)]; usf = ['%s/us_stamps_cat2_page%02d.bmp' % (W, k) for k in range(3)]
rows = [('Pokémon category, page %d (2 stamps per page)' % (k + 1), jpf[k], usf[k]) for k in range(3)]
pair_sheet(rows, 'pokemon_stamp_chooser_jp_vs_us_pages1-3.png', 'Stamp chooser, Pokémon category, pages 1-3 (Ball record 99999). JP: 10 pages, US/EU: only 3')
S = Image.new('RGB', (160 * 2 * 5 // 1 + 8, 144 * 2 * 2 + 70), BG)
S.close() if False else None
sc = 1; w, h = 160, 144; S = Image.new('RGB', (5 * (w + 4) + 4, 2 * (h + 20) + 36), BG); d = ImageDraw.Draw(S); d.text((6, 6), 'Japanese ROM: all 10 pages of the Pokémon category of the stamp chooser (2 stamps per page)', fill=WHITE, font=F)
for k, f in enumerate(jpf):
    x = 4 + (k % 5) * (w + 4); y = 28 + (k // 5) * (h + 20); d.text((x, y), 'page %d' % (k + 1), fill=YEL, font=F); S.paste(Image.open(f).convert('RGB'), (x, y + 16))
S.save(os.path.join(O, 'pokemon_stamp_chooser_jp_all_10_pages.png')); print('jp pages sheet', S.size)
# ---------------------------------------------------------------- 5. effects played with a JUMP target (BGB), JP row above US row
OFFS = [3, 8, 14, 20, 28, 38, 50, 70]; SCF = 0.6; fw, fh = int(160 * SCF), int(144 * SCF)
def eff_sheet(ks, fn, title):
    S = Image.new('RGB', (80 + 8 * (fw + 3) + 8, 56 + len(ks) * (2 * (fh + 3) + 24)), BG); d = ImageDraw.Draw(S)
    d.text((8, 6), title, fill=WHITE, font=FB); d.text((8, 30), 'frames: N video frames after the A press (BGB screenshots).  upper row = Japanese ROM, lower row = international ROM', fill=YEL, font=F)
    for r, k in enumerate(ks):
        y = 54 + r * (2 * (fh + 3) + 24)
        d.text((8, y + 4), 'value %d' % k, fill=YEL, font=F)
        if k < 15: S.paste(icon(jp, base + 64 * k).convert('RGB').resize((48, 48), Image.NEAREST), (14, y + 24))
        for row, rom in enumerate(('jp', 'us')):
            for c, n in enumerate(OFFS):
                f = '%s/%s_effect%02d_jump_f%02d.bmp' % (W, rom, k, n)
                if not os.path.exists(f): continue
                x = 80 + c * (fw + 3); yy = y + 20 + row * (fh + 3)
                S.paste(Image.open(f).convert('RGB').resize((fw, fh), Image.NEAREST), (x, yy))
                if row == 0: d.text((x + 2, y + 4), '+%d' % n, fill=WHITE, font=FS)
    S.save(os.path.join(O, fn)); print(fn, S.size)
eff_sheet(range(0, 8), 'hotspot_effects_played_with_jump_values_0-7_jp_vs_us.png', 'Hot-spot effects 0-7 played with a JUMP target (the effect is the transition to the other photo)')
eff_sheet(range(8, 16), 'hotspot_effects_played_with_jump_values_8-15_jp_vs_us.png', 'Hot-spot effects 8-15 (never offered by the picker; stored in the tag) played with a JUMP target')
# JP vs US equality of every effect frame
import numpy as np
eq = {}
for k in range(16):
    for n in OFFS:
        a = '%s/jp_effect%02d_jump_f%02d.bmp' % (W, k, n); b = '%s/us_effect%02d_jump_f%02d.bmp' % (W, k, n)
        if os.path.exists(a) and os.path.exists(b):
            A = np.array(Image.open(a).convert('L')); B = np.array(Image.open(b).convert('L')); eq[(k, n)] = float((A == B).mean())
if eq:
    import json
    vals = np.array(list(eq.values())); print('JP vs US effect frames: %d compared, identical pixels: mean %.4f, min %.4f' % (len(vals), vals.mean(), vals.min()))
    json.dump({'%d@%d' % k: v for k, v in eq.items()}, open(os.path.join(O, 'effects_jp_vs_us_pixel_equality.json'), 'w'), indent=1)
