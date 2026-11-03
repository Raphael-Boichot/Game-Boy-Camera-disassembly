#!/usr/bin/env python3
"""Extract the picture stamps straight from the ROM using the category table at 04:5337 (6 bytes per category: ptr, bank, size, n).
Category 2 (Pokemon): 20 stamps x 0x190 B (5x5 tiles) at 2C:6000.  Category 3 (CoroCoro, only if flag $D582=1): 10 stamps x 0x1E0 B (5x6 tiles) at 2B:4000.
usage: stamps_from_rom.py ROM OUTDIR"""
import sys, os
from PIL import Image, ImageDraw
rom = open(sys.argv[1], 'rb').read(); out = sys.argv[2]; os.makedirs(out, exist_ok=True)
PAL = [255, 170, 85, 0]
def tiles(off, n, cols):
    rows = (n + cols - 1) // cols
    im = Image.new('L', (cols * 8, rows * 8), 255); px = im.load()
    for t in range(n):
        for y in range(8):
            b0 = rom[off + t * 16 + y * 2]; b1 = rom[off + t * 16 + y * 2 + 1]
            for x in range(8): px[(t % cols) * 8 + x, (t // cols) * 8 + y] = PAL[((b1 >> (7 - x)) & 1) << 1 | ((b0 >> (7 - x)) & 1)]
    return im
def table(c):
    o = 4 * 0x4000 + 0x5337 - 0x4000 + 6 * c
    return rom[o] | rom[o + 1] << 8, rom[o + 2], rom[o + 3] | rom[o + 4] << 8, rom[o + 5]
for cat, nstamp, sz, cols, tcrows, name in [(2, 20, 0x190, 5, 5, 'pokemon'), (3, 10, 0x1E0, 5, 6, 'corocoro')]:
    ptr, bank, ps, n = table(cat); base = bank * 0x4000 + ptr - 0x4000
    sheet = Image.new('RGB', (5 * 88, ((nstamp + 4) // 5) * (tcrows * 16 + 16)), (90, 90, 140)); d = ImageDraw.Draw(sheet)
    for k in range(nstamp):
        off = base + k * sz; im = tiles(off, cols * tcrows, cols)
        im.save('%s/cat%d_%s_%02d_rom_%02X_%04X.png' % (out, cat, name, k + 1, bank, ptr + k * sz - 0 if False else (off - bank * 0x4000 + 0x4000)))
        x = (k % 5) * 88 + 4; y = (k // 5) * (tcrows * 16 + 16) + 2
        d.text((x, y), '#%d %02X:%04X' % (k + 1, bank, off - bank * 0x4000 + 0x4000), fill=(255, 255, 0))
        sheet.paste(im.convert('RGB').resize((cols * 16, tcrows * 16), Image.NEAREST), (x, y + 12))
    sheet.save('%s/sheet_cat%d_%s.png' % (out, cat, name)); print(name, nstamp, 'stamps at %02X:%04X' % (bank, ptr))
