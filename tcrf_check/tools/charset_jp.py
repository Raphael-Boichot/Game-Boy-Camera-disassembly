#!/usr/bin/env python3
"""Character table of the Japanese Pocket Camera text fields (photo name F04-F0C, comment F15-F2F, the 30-character comment card) - README 16.27.
The rule (C): the glyph of code c is the 8x16 pair of 2bpp tiles at bank $2A:4000 + (c-1)*32 (flat 0xA8000 + (c-1)*32), drawn by Glyph_LoadFromCharCode (09:4802);
code $00 is a blank cell and $87 is a blank glyph.  The reading of each glyph (which kana / letter it is) is by eye from the atlas (I); for the codes that occur in the 21 stock
comments and names of Album B it is confirmed twice: the BGB comment screens match the bank-$2A glyphs pixel for pixel (bgb_albumb_comments.py) and the sentences read as
sentences.
usage: charset_jp.py ROM [--csv roms/jp_rev_a/disasm/charset_jp.csv] [--atlas OUT.png]        (also a library: T = {code: char}, dec(bytes) -> str)"""
import sys, os, csv, argparse
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(os.path.dirname(HERE))

def build():
    t = {}
    hira = "あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよ、。らりるれろわをん"      # $01-$30
    for i, ch in enumerate(hira): t[0x01 + i] = (ch, 'hiragana' if ch not in '、。' else 'punctuation')
    t[0x31] = ('〜', 'symbol'); t[0x32] = ('♥', 'symbol')
    for i, ch in enumerate("がぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽっゃゅょ"): t[0x33 + i] = (ch, 'hiragana voiced/small')   # $33-$4F
    t[0x50] = ('・', 'punctuation')
    for i, ch in enumerate("ぁぃぅぇぉ"): t[0x51 + i] = (ch, 'hiragana small')                            # $51-$55
    kata = "アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨ!?ラリルレロワヲンヴ "     # $56-$87 ($87 = blank glyph)
    for i, ch in enumerate(kata): t[0x56 + i] = (ch, 'katakana' if ch not in '!? ' else ('punctuation' if ch != ' ' else 'blank glyph'))
    for i, ch in enumerate("ガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポッャュョーァィゥェォ"): t[0x88 + i] = (ch, 'katakana voiced/small/long')   # $88-$AA
    for i, ch in enumerate("ABCDEFGHIJKLMNOPQRSTUVWXYZ_',."): t[0xAB + i] = (ch, 'latin upper / punctuation')      # $AB-$C8
    for i, ch in enumerate("abcdefghijklmnopqrstuvwxyz"): t[0xC9 + i] = (ch, 'latin lower')                  # $C9-$E2
    t[0xE3] = ('[phone]', 'icon'); t[0xE4] = ('[face1]', 'icon'); t[0xE5] = ('[face2]', 'icon'); t[0xE6] = ('-', 'symbol')
    for i, ch in enumerate("0123456789/:~\"@"): t[0xE7 + i] = (ch, 'digit / symbol')                         # $E7-$F5
    t[0x00] = (' ', 'blank cell')
    return t
TT = build()
T = {c: v[0] for c, v in TT.items()}
def dec(bs, blank='　'):
    """text of a code string; $00 and $87 are shown as an ideographic space, unknown codes as <XX>"""
    return ''.join(blank if b in (0x00, 0x87) else T.get(b, '<%02X>' % b) for b in bs)
def glyph(rom, code):
    """the 16x8 pixel matrix (values 0-3) of a code: two stacked 2bpp tiles of bank $2A"""
    o = 0x2A * 0x4000 + (code - 1) * 32; d = rom[o:o + 32]
    return [[((d[t * 16 + y * 2] >> (7 - x)) & 1) | (((d[t * 16 + y * 2 + 1] >> (7 - x)) & 1) << 1) for x in range(8)] for t in range(2) for y in range(8)]

def used_codes(rom):
    """(comments, names): code -> list of 'Bnn' whose comment field F15-F2F / name field F04-F0C of the 30 stock slots (0xDA000 + i*0x1000) contains it"""
    com, nam = {}, {}
    for i in range(30):
        b = 0xDA000 + i * 0x1000
        for c in set(rom[b + 0xF15:b + 0xF15 + 27]):
            if c: com.setdefault(c, []).append('B%02d' % (i + 1))
        for c in set(rom[b + 0xF04:b + 0xF0D]):
            if c: nam.setdefault(c, []).append('B%02d' % (i + 1))
    return com, nam

def write_csv(rom, path):
    com, nam = used_codes(rom)
    with open(path, 'w', newline='', encoding='utf-8') as fh:
        w = csv.writer(fh, lineterminator='\n')
        w.writerow(['code', 'char', 'class', 'glyph_rom', 'in_album_b_comments', 'in_album_b_names', 'evidence'])
        for c in range(0x01, 0xF6):
            ch, cl = TT.get(c, ('', 'not assigned'))
            ev = 'C' if c in com else 'I'     # C: the BGB comment screens show this glyph pixel-exact and the sentence reads; I: reading by eye from the atlas (names only, or no use in the stock fields)
            w.writerow(['%02X' % c, ch, cl, '2A:%04X' % (0x4000 + (c - 1) * 32), ' '.join(com.get(c, [])), ' '.join(nam.get(c, [])), ev])
    return com, nam

def write_atlas(rom, path, scale=3):
    from PIL import Image, ImageDraw
    pal = (255, 174, 92, 25); cols = 16; rows = 16
    cw, ch = 8 * scale + 4, 16 * scale + 14
    im = Image.new('RGB', (cols * cw + 28, rows * ch + 14), 'white'); dr = ImageDraw.Draw(im)
    for c in range(16): dr.text((28 + c * cw + 4, 1), '%X' % c, fill=(120, 0, 0))
    for r in range(16):
        dr.text((2, 14 + r * ch + 14), '%X_' % r, fill=(120, 0, 0))
        for c in range(16):
            code = r * 16 + c
            if code == 0 or code > 0xF5: continue
            g = glyph(rom, code)
            for y in range(16):
                for x in range(8):
                    v = pal[g[y][x]]
                    dr.rectangle([28 + c * cw + 2 + x * scale, 14 + r * ch + y * scale, 28 + c * cw + 2 + x * scale + scale - 1, 14 + r * ch + y * scale + scale - 1], fill=(v, v, v))
    im.save(path)

if __name__ == '__main__':
    ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('--csv'); ap.add_argument('--atlas')
    a = ap.parse_args(); rom = open(a.rom, 'rb').read()
    if a.csv: com, nam = write_csv(rom, a.csv); print('wrote', a.csv, '- %d of the 245 codes occur in the Album B comments, %d more only in the names' % (len(com), len(set(nam) - set(com))))
    if a.atlas: write_atlas(rom, a.atlas); print('wrote', a.atlas)
