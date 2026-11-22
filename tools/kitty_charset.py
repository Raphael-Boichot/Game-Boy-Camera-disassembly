#!/usr/bin/env python3
"""Hello Kitty L6: the character set of the name / comment text, checked against the Japanese ROM's (roms/jp_rev_a/disasm/charset_jp.csv).

  tools/kitty_charset.py KITTY.gb JP.gb [--out roms/hello_kitty/disasm/charset_kitty.csv] [--sheet roms/hello_kitty/screens/charset_kitty.png]

The code of a character is the one of the Japanese ROM: the text routines of bank $05 take the glyph of code c at
  * 12:4000 + 32 (c - 1): a thin 8x16 font (Text_SmallGlyphAddr, drawn by Text_DrawSmallLine into tiles $8100), C (code);
  * 09:4000 + 64 (c - 1): a 16x16 font, four tiles (top left, top right, bottom left, bottom right; Text_BigGlyphAddr, Text_CopyBigLine:
    the album comment, also into $C000 for printing), C (code);
and two more fonts hold the same order: 12:6000 + 32 (c - 1), a bold 8x16 font (the kana pages of the name card editor load ten glyphs
from 12:6000 + $A0 x page, NameCardEdit_LoadKanaPage), and 11:4000, the Japanese ROM's own 8x16 font (2A:4000) one pixel row lower: the 32
bytes at 11:4002 + 32 (c - 1) equal the Japanese glyph of code c for all but the codes listed (column same_as_jp_font).
Every glyph of the four fonts was compared by eye with the Japanese character of its code on the sheet this tool draws (I): all 245 agree.
The ROM holds no text in this code: its screen text is drawn as pictures (README, L6); the set serves the text the player enters.
"""
import csv, os, argparse, hashlib
import numpy as np
from PIL import Image, ImageDraw, ImageFont
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('jp')
ap.add_argument('--out', default=os.path.join(REPO, 'roms', 'hello_kitty', 'disasm', 'charset_kitty.csv'))
ap.add_argument('--sheet', default=os.path.join(REPO, 'roms', 'hello_kitty', 'screens', 'charset_kitty.png')); a = ap.parse_args()
K = open(a.rom, 'rb').read(); J = open(a.jp, 'rb').read()
if hashlib.md5(K).hexdigest() != '0a323bddc4f0159cea76cf44ed0c1a3c': raise SystemExit('kitty_charset: not the Hello Kitty ROM')
def fl(b, ad): return ad if b == 0 else b * 0x4000 + ad - 0x4000
CS = list(csv.DictReader(open(os.path.join(REPO, 'roms', 'jp_rev_a', 'disasm', 'charset_jp.csv'), encoding='utf-8')))
rows = []
for r in CS:
    c = int(r['code'], 16); b, ad = r['glyph_rom'].split(':'); jo = fl(int(b, 16), int(ad, 16))
    same = J[jo:jo + 32] == K[fl(0x11, 0x4002) + 32 * (c - 1):fl(0x11, 0x4002) + 32 * (c - 1) + 32]
    rows.append([r['code'], r['char'], r['class'], '12:%04X' % (0x4000 + 32 * (c - 1)), '09:%04X' % (0x4000 + 64 * (c - 1)),
                 '12:%04X' % (0x6000 + 32 * (c - 1)), '11:%04X' % (0x4002 + 32 * (c - 1)), 'yes' if same else 'no',
                 'C (code: the glyph addresses); I (the glyphs compared by eye with the Japanese character)'])
with open(a.out, 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f, lineterminator='\n')
    w.writerow(['code', 'char', 'class', 'glyph_thin_8x16', 'glyph_16x16', 'glyph_bold_8x16', 'glyph_jp_font', 'same_as_jp_font', 'evidence']); w.writerows(rows)
# the sheet: each code with the Japanese character and its glyph in the four fonts
PAL = np.array([255, 170, 85, 0], np.uint8)
def tile(o):
    t = np.zeros((8, 8), np.uint8)
    for y in range(8):
        lo, hi = K[o + 2 * y], K[o + 2 * y + 1]
        for x in range(8): t[y, x] = ((lo >> (7 - x)) & 1) | (((hi >> (7 - x)) & 1) << 1)
    return t
def g816(o): return np.vstack([tile(o), tile(o + 16)])
def g1616(o): return np.vstack([np.hstack([tile(o), tile(o + 16)]), np.hstack([tile(o + 32), tile(o + 48)])])
jf = ImageFont.truetype('/usr/share/fonts/opentype/noto/NotoSansCJK-Black.ttc', 22); sf = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf', 11)
Z, per, cw, ch = 2, 12, 170, 50
img = Image.new('RGB', (per * cw + 10, ((len(CS) + per - 1) // per) * ch + 40), 'white'); dr = ImageDraw.Draw(img)
dr.text((5, 4), 'code, Japanese character (blue), then the Hello Kitty glyphs: thin 12:4000, bold 12:6000, Japanese font 11:4002, 16x16 09:4000', fill=0, font=sf)
for i, r in enumerate(CS):
    c = int(r['code'], 16) - 1; rr, cc = divmod(i, per); x = 5 + cc * cw; y = 30 + rr * ch
    dr.text((x, y), r['code'], fill=(200, 0, 0), font=sf)
    dr.text((x, y + 14), r['char'] if len(r['char']) == 1 else r['char'][:4], fill=(0, 0, 160), font=jf if len(r['char']) == 1 else sf)
    xx = x + 34
    for g in (g816(fl(0x12, 0x4000) + 32 * c), g816(fl(0x12, 0x6000) + 32 * c), g816(fl(0x11, 0x4002) + 32 * c), g1616(fl(0x09, 0x4000) + 64 * c)):
        img.paste(Image.fromarray(PAL[g]).resize((g.shape[1] * Z, g.shape[0] * Z), Image.NEAREST), (xx, y + 8)); xx += g.shape[1] * Z + 4
os.makedirs(os.path.dirname(a.sheet), exist_ok=True); img.save(a.sheet, optimize=True)
print('kitty_charset: %d codes, %d glyphs of the Japanese font copy equal to the Japanese bytes (11:4002)' % (len(rows), sum(1 for r in rows if r[7] == 'yes')))
