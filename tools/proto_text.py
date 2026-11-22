#!/usr/bin/env python3
"""The prototype's text (L6): the character set of its menu font and the text of every screen map, decoded.

  tools/proto_text.py PROTO.gb [--charset roms/prototype_debagame/disasm/charset_proto.csv]
                               [--screens roms/prototype_debagame/assets/screen_text_proto.csv]

The menu screens load one of two tile sets to $8000 (Gfx_01_4001_FNTOOE1 for the title and the menu, Gfx_02_4001_FNTOOE2 for the test
screens; 384 tiles) and a 20 x 18 map to $9800, with the LCDC in $8800 mode: map codes $80-$FF are tiles 128-255 of the set (the same
glyphs in both sets: a font), codes $00-$7F tiles 256-383 (a different picture per screen: the logo and the headers, drawn as pictures).
The glyph of each code below is read by eye from the tiles (I); the screen texts decoded with it equal the BGB screenshots of
screens/ (C, BGB) for every map this build copies (TITLE1, MENU1, BG_BANK, BGSRAM1-3, BG_DUMP, BGPROTEC). The pictures are named from the
same screenshots. Not covered: the configuration screen (Gfx_03_5A41_CONF2: words drawn as pictures, kanji and kana) and the movie
screen (Gfx_03_4001_FNTOOE3: the save dialog drawn as sprites of word tiles, SAVE_SURU ... SAVESIMASITA).
"""
import csv, os, argparse, hashlib
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); P = os.path.join(REPO, 'roms', 'prototype_debagame')
ap = argparse.ArgumentParser(); ap.add_argument('rom')
ap.add_argument('--charset', default=os.path.join(P, 'disasm', 'charset_proto.csv')); ap.add_argument('--screens', default=os.path.join(P, 'assets', 'screen_text_proto.csv'))
a = ap.parse_args()
R = open(a.rom, 'rb').read()
if hashlib.md5(R).hexdigest() != '19b50a5f67ef4f0d015e7d813370756e': raise SystemExit('proto_text: expected the image as dumped (md5 19b50a5f...)')
def fl(b, ad): return ad if b == 0 else b * 0x4000 + ad - 0x4000
# code -> (char, class, note); the glyphs of tiles 128-255, read by eye (identical in FNTOOE1 and FNTOOE2 unless the note says)
CS = {0xA0: (' ', 'space', 'blank tile, the inside of the frames')}
for i in range(16): CS[0x80 + i] = ('0123456789ABCDEF'[i], 'digit', 'hexadecimal digits $80-$8F')
for i, ch in enumerate('V.:;()<>[]+-=×/'): CS[0x90 + (i + 1 if i else 0)] = (ch, 'punctuation', '')
CS[0x90] = ('V', 'letter', 'the V of Ver'); CS[0x91] = ('er', 'letter', 'two letters on one tile, the er of Ver (Ver10.24 on the title)')
for k, ch in zip(range(0x92, 0xA0), '.:;()<>[]+-=×/'): CS[k] = (ch, 'punctuation', '')
CS[0xA1] = ('▶', 'symbol', 'a small arrow')
for k in range(0xA2, 0xAA): CS[k] = ('', 'frame', 'window frame piece (A2 A3 A4 top, A5 A6 sides, A7 A8 A9 bottom)')
CS[0xAA] = ('', 'background', 'the grey background of the menu screens')
CS[0xAB] = (',', 'punctuation', '')
CS[0xAC] = ('○', 'symbol', 'FNTOOE2 only (blank in FNTOOE1)'); CS[0xAD] = ('×', 'symbol', 'FNTOOE2 only'); CS[0xAE] = ('→', 'symbol', 'FNTOOE2 only')
CS[0xB0] = ('○', 'symbol', 'large circle, left half (B0 B1); FNTOOE2 only'); CS[0xB1] = ('', 'symbol', 'large circle, right half')
CS[0xB2] = ('×', 'symbol', 'large cross, left half (B2 B3); FNTOOE2 only'); CS[0xB3] = ('', 'symbol', 'large cross, right half')
for i in range(26): CS[0xC1 + i] = (chr(65 + i), 'letter', 'capital letters at $C1-$DA: ASCII + $80')
with open(a.charset, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['code', 'char', 'class', 'glyph_rom', 'note', 'evidence'])
    for k in sorted(CS):
        ch, cl, note = CS[k]
        w.writerow(['%02X' % k, ch, cl, '01:%04X 02:%04X' % (0x4001 + k * 16, 0x4001 + k * 16), note, 'I'])
# pictures of codes $00-$7F (tiles 256-383 of the set) and of the copyright strip, named from the BGB screenshots
PICS = {'TITLE1': [((0x00, 0x5F), 'logo: デバガメテスター in a black box, SECOND IMPACT below'), ((0xF0, 0xFC), 'strip: 1997 Nintendo ... Dept. (drawn as one picture of 13 tiles)')],
        'MENU1': [((0x60, 0x77), 'header MENU')], 'BG_BANK': [((0x00, 0x17), 'header BANK')], 'BGSRAM1': [((0x08, 0x1F), 'header SRAM')],
        'BGSRAM2': [((0x20, 0x2A), 'header DATA SELECT')], 'BGSRAM3': [((0x30, 0x47), 'header AGING'), ((0x2B, 0x2F), 'ERROR on the frame')],
        'BG_DUMP': [((0x3B, 0x3D), 'BANK')], 'BGPROTEC': [((0xE0, 0xEF), 'header PROTECT')]}
MAPS = [('TITLE1', 1, 0x5801, 'screen_01_00.png'), ('MENU1', 1, 0x5A41, 'screen_02_00.png'), ('BG_BANK', 2, 0x5801, 'screen_03_00.png'),
        ('BGSRAM1', 2, 0x5A41, 'screen_04_00.png'), ('BGSRAM2', 2, 0x5C81, 'screen_05_00.png'), ('BGSRAM3', 2, 0x5EC1, 'screen_07_00.png'),
        ('BG_DUMP', 2, 0x6101, 'screen_08_00.png'), ('BGPROTEC', 2, 0x6341, 'screen_0A_00.png')]
SKIP = {0xA0, 0xAA} | set(range(0xA2, 0xAA))
rows = []
for nm, b, ad, shot in MAPS:
    m = R[fl(b, ad):fl(b, ad) + 0x240]
    pics = PICS.get(nm, [])
    for r in range(18):
        row = m[r * 32:r * 32 + 20]; c = 0
        while c < 20:
            k = row[c]
            pic = next((t for (lo, hi), t in pics if lo <= k <= hi), None)
            if pic or k not in CS or k in SKIP:
                if pic:
                    c0 = c
                    while c < 20 and next((t for (lo, hi), t in pics if lo <= row[c] <= hi), None) == pic: c += 1
                    if not any(x[0] == nm and x[4] == pic for x in rows):
                        rows.append([nm, '%02X:%04X' % (b, ad), r, c0, pic, 'picture', '%02X-%02X' % (row[c0], row[c - 1]), 'C (BGB): screens/' + shot])
                    continue
                c += 1; continue
            c0 = c; s = ''; last = c
            while c < 20 and row[c] in CS and row[c] not in SKIP - {0xA0} and not next((t for (lo, hi), t in pics if lo <= row[c] <= hi), None):
                s += CS[row[c]][0]
                if row[c] != 0xA0: last = c + 1
                c += 1
            if s.strip(): rows.append([nm, '%02X:%04X' % (b, ad), r, c0, s.strip(), 'text', ' '.join('%02X' % x for x in row[c0:last]), 'C (BGB): screens/' + shot])
# text tables read by code (tools/proto_names.py names them): the aging pattern names, 11 bytes each from PAT_DEC (00:0B0A)
for i, nm in enumerate(['PAT_DEC', 'PAT_0F', 'PAT_5A', 'PAT_00', 'PAT_FF']):
    o = 0x0B0A + 11 * i; s = ''.join(CS[x][0] for x in R[o:o + 11]).rstrip()
    rows.append([nm, '00:%04X' % o, '', '', s, 'text table', ' '.join('%02X' % x for x in R[o:o + 11]), 'C (code, BGB): copied by PAT_SET to the DATA SELECT and AGING screens (screens/screen_05_00.png, screen_07_00.png)'])
with open(a.screens, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['map', 'rom', 'row', 'col', 'text', 'kind', 'codes', 'evidence']); w.writerows(rows)
print('proto_text: %d codes in the charset, %d screen text rows (%d pictures)' % (len(CS), len(rows), sum(1 for r in rows if r[5] == 'picture')))
