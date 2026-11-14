#!/usr/bin/env python3
"""Extract the 30 stock pictures of Album B from the JP ROM (0x0DA000 + i*0x1000: 128x112 2bpp tiles, 0xE00 B, then thumbnail 0xE00-0xEFF and slot footer 0xF00-0xFFF).
usage: extract_albumB.py ROM OUTDIR"""
import sys, os
from PIL import Image, ImageDraw
rom = open(sys.argv[1], 'rb').read(); out = sys.argv[2]; os.makedirs(out, exist_ok=True)
PAL = [255, 170, 85, 0]
def tiles(off, ntiles, cols):
    rows = (ntiles + cols - 1) // cols
    im = Image.new('L', (cols * 8, rows * 8), 255); px = im.load()
    for t in range(ntiles):
        for y in range(8):
            b0 = rom[off + t * 16 + y * 2]; b1 = rom[off + t * 16 + y * 2 + 1]
            for x in range(8):
                px[(t % cols) * 8 + x, (t // cols) * 8 + y] = PAL[((b1 >> (7 - x)) & 1) << 1 | ((b0 >> (7 - x)) & 1)]
    return im
sheet = Image.new('L', (6 * 134, 5 * 134), 230); d = ImageDraw.Draw(sheet)
for i in range(30):
    off = 0xDA000 + i * 0x1000
    im = tiles(off, 224, 16); im.save('%s/B%02d_rom_%06X.png' % (out, i + 1, off))
    th = tiles(off + 0xE00, 16, 4); th.save('%s/B%02d_thumb.png' % (out, i + 1))
    x = (i % 6) * 134 + 3; y = (i // 6) * 134 + 3
    sheet.paste(im.resize((128, 112)), (x, y + 10)); d.text((x, y), 'B%02d @%06X' % (i + 1, off), fill=0)
sheet.save(out + '/albumB_all.png'); print('ok', sheet.size)
