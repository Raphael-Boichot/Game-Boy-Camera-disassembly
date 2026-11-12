#!/usr/bin/env python3
"""Pictures of the prototype put back together from their pieces (owner 2026-11-12): roms/prototype_debagame/assets/reconstructed/.

  tools/proto_reconstruct.py PROTO.gb [--check]

  FacePhoto6_whole.png      face photo 6 (128 x 112): tile rows 0-1 from 23:60E1 (Leftover_23_60E1_Unused_TCRF_FacePhoto6_Rows0To1_Gfx),
                            rows 2-13 from 30:4201 (Unused_TCRF_FacePhoto6_Rows2To13_Gfx); in bank $23 the two rows are followed by
                            rows 2-3 equal to 30:4201-43FF byte for byte, which ties them to this picture.
  FacePhoto8_variant_1D.png face photo 8 (05:4E01) with its tile rows 2-3 replaced by the edited version of bank $1D
                            (Leftover_1D_4001_Unused_TCRF_FacePhoto8_HOI_D_Gfx_VariantPart5001), next to the original.
  FacePhoto10_variant_1C.png face photo 10 (05:6A01) with its tile rows 6-7 replaced by the edited strip of bank $1C
                            (Leftover_1C_4001_Unused_TCRF_FacePhoto10_HOI_R_Gfx_VariantPart7001), next to the original: the strip
                            sits 3 tiles to the left of its place (its tile c is column c + 3 of the photo); its last 3 columns
                            (a hand-drawn mark) stand right of the picture, on a canvas 3 tiles wider.
Every picture is drawn 2x, white / light grey / dark grey / black, as the camera tiles are stored (16 tiles per row).
"""
import argparse, io, os, sys
from PIL import Image
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(os.path.dirname(HERE), 'roms', 'prototype_debagame', 'assets', 'reconstructed')
ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('--check', action='store_true'); a = ap.parse_args()
R = open(a.rom, 'rb').read()
def g(b, ad, n): o = b * 0x4000 + ad - 0x4000; return R[o:o + n]
def img(data, w=16):
    n = len(data) // 16; h = (n + w - 1) // w; im = Image.new('L', (w * 8, h * 8), 255); pal = (255, 170, 85, 0)
    for t in range(n):
        for y in range(8):
            lo, hi = data[t * 16 + 2 * y], data[t * 16 + 2 * y + 1]
            for x in range(8): im.putpixel((t % w * 8 + x, t // w * 8 + y), pal[((lo >> (7 - x)) & 1) | (((hi >> (7 - x)) & 1) << 1)])
    return im
def side(*ims):
    W = sum(i.width for i in ims) + 8 * (len(ims) - 1); H = max(i.height for i in ims); c = Image.new('L', (W, H), 255); x = 0
    for i in ims: c.paste(i, (x, 0)); x += i.width + 8
    return c
p8 = g(0x05, 0x4E01, 3584); p10 = g(0x05, 0x6A01, 3584); s1c = g(0x1C, 0x4001, 512)
def p10v():                     # photo 10 on a 19-tile-wide canvas; rows 6-7, column c + 3 <- tile c of the $1C strip (c = 0..15:
    b = bytearray(19 * 14 * 16)  # its last 3 tiles, the hand-drawn mark, land in columns 16-18, right of the picture)
    for r in range(14):
        for c in range(16): o = (r * 19 + c) * 16; b[o:o + 16] = p10[(r * 16 + c) * 16:(r * 16 + c + 1) * 16]
    for r in range(2):
        for c in range(16): o = ((6 + r) * 19 + c + 3) * 16; b[o:o + 16] = s1c[(r * 16 + c) * 16:(r * 16 + c + 1) * 16]
    return bytes(b)
pics = {'FacePhoto6_whole.png': img(g(0x23, 0x60E1, 512) + g(0x30, 0x4201, 3072)),
        'FacePhoto8_variant_1D.png': side(img(p8[:512] + g(0x1D, 0x4001, 512) + p8[1024:]), img(p8)),
        'FacePhoto10_variant_1C.png': side(img(p10v(), w=19), img(p10))}
bad = 0
for nm, im in pics.items():
    buf = io.BytesIO(); im.resize((im.width * 2, im.height * 2), Image.NEAREST).save(buf, 'PNG'); p = os.path.join(OUT, nm)
    if a.check:
        if not os.path.exists(p) or open(p, 'rb').read() != buf.getvalue(): print('differs:', p); bad += 1
    else:
        os.makedirs(OUT, exist_ok=True); open(p, 'wb').write(buf.getvalue())
print('proto_reconstruct: %d pictures%s' % (len(pics), ' (check)' if a.check else ''))
sys.exit(1 if bad else 0)
