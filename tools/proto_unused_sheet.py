#!/usr/bin/env python3
"""The unused assets of the prototype ("DEBAGAME"), one sheet in the style of the Japanese one (2026-11-12):
roms/prototype_debagame/assets/unused_sheet_proto.png.

  tools/proto_unused_sheet.py PROTO.gb [--check]

Two parts, as the categories of assets/unused_proto.csv (tools/unused_table.py):
  documented by TCRF (https://tcrf.net/Proto:Game_Boy_Camera, Unused Graphics): the fourteen pictures (photo 4 is photo 5 with the
    palette inverted, as TCRF shows it; photo 6 with its two top rows from bank $23), the NEO title logo (its map drawn with its
    tiles), the editor UI (the map BG_F_SCR drawn with the editor tiles at ids $80-$FF and the settings font CONF2 below), the
    arrow cursor;
  not documented by TCRF: the edited rows of photo 8 (bank $1D), the head top of bank $1C, the PROGRAM tiles, the settings-font
    glyph of bank $3A (反転 where bank $03 has パレット), the edited glyphs of the font copies (02:6EA1, 02:6F93 against FNTOOE1).
Every picture is drawn from the ROM bytes (white / light grey / dark grey / black), x2, with its address, size and label.
"""
import argparse, io, os, sys
from PIL import Image, ImageDraw, ImageFont
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(os.path.dirname(HERE), 'roms', 'prototype_debagame', 'assets', 'unused_sheet_proto.png')
ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('--check', action='store_true'); a = ap.parse_args()
R = open(a.rom, 'rb').read()
def fl(b, ad): return b * 0x4000 + ad - 0x4000
def g(b, ad, n): return R[fl(b, ad):fl(b, ad) + n]
PAL = (255, 170, 85, 0)
def tile(data, inv=False):
    im = Image.new('L', (8, 8))
    for y in range(8):
        lo, hi = data[2 * y], data[2 * y + 1]
        for x in range(8):
            c = ((lo >> (7 - x)) & 1) | (((hi >> (7 - x)) & 1) << 1)
            im.putpixel((x, y), PAL[3 - c if inv else c])
    return im
def tiles(data, w=16, inv=False):
    n = len(data) // 16; h = (n + w - 1) // w; im = Image.new('L', (w * 8, h * 8), 255)
    for t in range(n): im.paste(tile(data[t * 16:t * 16 + 16], inv), (t % w * 8, t // w * 8))
    return im
def tmap(mp, cols, rows, src, show=(20, 18)):
    im = Image.new('L', (show[0] * 8, show[1] * 8), 255)
    for r in range(show[1]):
        for c in range(show[0]):
            o = src(mp[r * cols + c])
            if o is not None: im.paste(tile(R[o:o + 16]), (c * 8, r * 8))
    return im
def side(*ims, gap=8):
    W = sum(i.width for i in ims) + gap * (len(ims) - 1); H = max(i.height for i in ims); c = Image.new('L', (W, H), 255); x = 0
    for i in ims: c.paste(i, (x, 0)); x += i.width + gap
    return c
PHOTO = 3584
p6 = g(0x23, 0x60E1, 512) + g(0x30, 0x4201, 3072); p8 = g(0x05, 0x4E01, PHOTO)
pics = [('photo 1', '30:4E01', tiles(g(0x30, 0x4E01, PHOTO))), ('photo 2', '30:5C01', tiles(g(0x30, 0x5C01, PHOTO))), ('photo 3', '30:6A01', tiles(g(0x30, 0x6A01, PHOTO))),
        ('photo 4 = photo 5 inverted', '01:5C81', tiles(g(0x01, 0x5C81, PHOTO), inv=True)), ('photo 5 SIMO', '01:5C81', tiles(g(0x01, 0x5C81, PHOTO))),
        ('photo 6 (rows 0-1: 23:60E1)', '30:4201', tiles(p6)), ('photo 7 HOI_U', '05:4001', tiles(g(0x05, 0x4001, PHOTO))), ('photo 8 HOI_D', '05:4E01', tiles(p8)),
        ('photo 9 HOI_L', '05:5C01', tiles(g(0x05, 0x5C01, PHOTO))), ('photo 10 HOI_R', '05:6A01', tiles(g(0x05, 0x6A01, PHOTO))),
        ('drawing 1 FACE5', '06:4001', tiles(g(0x06, 0x4001, PHOTO))), ('drawing 2 FACE6', '06:4E01', tiles(g(0x06, 0x4E01, PHOTO))),
        ('drawing 3 FACE7', '06:5C01', tiles(g(0x06, 0x5C01, PHOTO))), ('drawing 4 FACE8', '06:6A01', tiles(g(0x06, 0x6A01, PHOTO)))]
neo = tmap(g(0x38, 0x5801, 576), 32, 18, lambda i: fl(0x38, 0x5001) + i * 16 if i < 96 else None)
edit = tmap(g(0x03, 0x7481, 576), 32, 18, lambda i: fl(0x02, 0x7581) + (i - 0x80) * 16 if i >= 0x80 else fl(0x03, 0x5A41) + i * 16)
cur = tiles(g(0x02, 0x42E1, 32) + g(0x02, 0x43E1, 32), w=2)
tcrf = [('NEO title logo', 'map 38:5801, tiles 38:5001', neo), ('editor UI: map BG_F_SCR', '03:7481 + tiles 02:7581', edit), ('arrow cursor', '02:42E1 + 02:43E1', cur.resize((64, 64), Image.NEAREST))]
glyph = lambda b: tiles(g(b, 0x6701, 64) + g(b, 0x6801, 64), w=4)
own = [('photo 8 rows 2-3, edited', '1D:4001 (left) / 05:5001', side(tiles(p8[:512] + g(0x1D, 0x4001, 512) + p8[1024:]), tiles(p8))),
       ('a head top found nowhere else', '1C:4001', tiles(g(0x1C, 0x4001, 512))),
       ('PROGRAM, 4 drawn tiles of 128', '02:6581', tiles(g(0x02, 0x6581, 64), w=4).resize((64, 16), Image.NEAREST)),
       ('settings glyph: 反転 (3A) / パレット (03)', '3A:6701 / 03:6701', side(glyph(0x3A).resize((64, 32), Image.NEAREST), glyph(0x03).resize((64, 32), Image.NEAREST))),
       ('font copy, edited glyphs (02) / FNTOOE1 (01)', '02:6E81 / 01:4901', side(tiles(g(0x02, 0x6E81, 0x280)), tiles(g(0x01, 0x4901, 0x280))))]
def font(sz, bold=False):
    p = '/usr/share/fonts/truetype/dejavu/DejaVuSans%s.ttf' % ('-Bold' if bold else '')
    return ImageFont.truetype(p, sz) if os.path.exists(p) else ImageFont.load_default()
F, FB, FT = font(13), font(15, True), font(18, True)
JP = '/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc'
FJ = ImageFont.truetype(JP, 13) if os.path.exists(JP) else F
S = 2; W = 1400; PAD = 14
def lay(items, y, d, img, cols):
    x = PAD; rowh = 0; colw = (W - PAD) // cols
    for k, (cap, adr, im) in enumerate(items):
        im2 = im.resize((im.width * S, im.height * S), Image.NEAREST).convert('RGB')
        if x + max(im2.width, 10) > W - PAD and x > PAD: x = PAD; y += rowh + 12; rowh = 0
        if img is not None:
            d.text((x, y), cap, fill=(0, 0, 0), font=FJ); d.text((x, y + 16), adr, fill=(90, 90, 90), font=F)
            img.paste(im2, (x, y + 34))
        rowh = max(rowh, im2.height + 34); x += max(im2.width, int(d.textlength(cap, font=FJ)) if d else 0) + 18
    return y + rowh + 12
def draw(img):
    d = ImageDraw.Draw(img) if img is not None else ImageDraw.Draw(Image.new('RGB', (8, 8)))
    y = PAD
    if img is not None:
        d.text((PAD, y), 'Unused assets, Pocket Camera Prototype (Japan) ("DEBAGAME")', fill=(0, 0, 0), font=FT)
        d.text((PAD, y + 24), 'Drawn from the ROM bytes, x2 (white / light grey / dark grey / black, 16 tiles per row as the camera stores them). Categories: roms/prototype_debagame/assets/unused_proto.csv (tools/unused_table.py).', fill=(60, 60, 60), font=F)
    y += 52
    for title, col, items in (('Documented by TCRF (https://tcrf.net/Proto:Game_Boy_Camera, Unused Graphics): the fourteen pictures, the NEO logo, the editor UI, the arrow cursor', (150, 60, 0), pics + tcrf),
                              ('Not documented by TCRF (found by this project)', (0, 110, 140), own)):
        if img is not None:
            d.line([(PAD, y), (W - PAD, y)], fill=col, width=3); d.text((PAD, y + 6), title, fill=col, font=FB)
        y = lay(items, y + 30, d, img, 6)
    return y
H = draw(None) + PAD
im = Image.new('RGB', (W, H), (255, 255, 255)); draw(im)
buf = io.BytesIO(); im.save(buf, 'PNG', optimize=True)
if a.check:
    ok = os.path.exists(OUT) and open(OUT, 'rb').read() == buf.getvalue()
    print('proto_unused_sheet: %s' % ('fresh' if ok else 'differs: ' + OUT)); sys.exit(0 if ok else 1)
open(OUT, 'wb').write(buf.getvalue()); print('proto_unused_sheet: %s (%d x %d)' % (OUT, W, H))
