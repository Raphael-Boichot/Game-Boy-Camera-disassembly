#!/usr/bin/env python3
"""bank_pics.py ROM.gb NAMES.csv OUTDIR BANK [BANK ...]   one picture per ROM bank: every 2bpp tile drawn 8x8, 32 tiles per row, address labels on the left.
grey = typed and named, orange = unreferenced span (name ends _Aux / _Unref, or a plain Data_BB_AAAA), blue = other `?` name. Needs Pillow."""
import sys, csv, os
from PIL import Image, ImageDraw
rom, names_csv, outdir = sys.argv[1:4]; banks = [int(x, 16) for x in sys.argv[4:]]
ROM = open(rom, 'rb').read(); os.makedirs(outdir, exist_ok=True)
GRAY = [(255,255,255),(170,170,170),(85,85,85),(0,0,0)]; TINT = [(255,240,200),(255,180,90),(200,90,20),(60,20,0)]; BLUE = [(235,245,255),(130,170,230),(40,80,170),(0,10,60)]
labels = {}
for r in csv.DictReader(open(names_csv, encoding='utf-8')): labels[(int(r['bank'], 16), int(r['addr'], 16))] = (r['name'], r['conf'])
for b in banks:
    ks = sorted(a for (bb, a) in labels if bb == b and a >= 0x4000)
    cls = [0] * 1024
    for i, a in enumerate(ks):
        e = ks[i + 1] if i + 1 < len(ks) else 0x8000; nm, cf = labels[(b, a)]
        k = 1 if (nm.startswith('Data_') and len(nm) == 12) or nm.endswith(('_Aux', '_Unref')) else 2 if cf == '?' else 0
        for t in range((a - 0x4000) // 16, (e - 0x4000 + 15) // 16): cls[t] = k
    sc = 2; cols = 32; im = Image.new('RGB', (cols * 8 * sc + 46, 32 * 8 * sc), (255,255,255)); px = im.load(); d = ROM[b * 0x4000:b * 0x4000 + 0x4000]
    for t in range(1024):
        pal = (GRAY, TINT, BLUE)[cls[t]]; tx = (t % cols) * 8; ty = (t // cols) * 8
        for y in range(8):
            lo = d[t * 16 + y * 2]; hi = d[t * 16 + y * 2 + 1]
            for x in range(8):
                c = ((hi >> (7 - x)) & 1) << 1 | ((lo >> (7 - x)) & 1)
                for sy in range(sc):
                    for sx in range(sc): px[46 + (tx + x) * sc + sx, (ty + y) * sc + sy] = pal[c]
    dr = ImageDraw.Draw(im)
    for r in range(32): dr.text((2, r * 8 * sc + 2), '%04X' % (0x4000 + r * cols * 16), fill=(0,0,160))
    im.save(os.path.join(outdir, 'bank_%02X.png' % b), optimize=True)
