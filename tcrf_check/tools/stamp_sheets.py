#!/usr/bin/env python3
"""Build one contact sheet per stamp category from the stamp_atlas.py captures: usage stamp_sheets.py DIR"""
import sys, glob, os, re
from PIL import Image, ImageDraw
d = sys.argv[1]
bycat = {}
for f in sorted(glob.glob(d + '/cat??_s??_item*.png')):
    m = re.search(r'cat(\d+)_s(\d+)_item(\d+)', f); bycat.setdefault(int(m[1]), []).append((int(m[2]), int(m[3]), f))
BOX = (16, 88, 134, 144)
allsheets = []
for c, L in sorted(bycat.items()):
    cols = 4 if len(L) > 12 else 3; w = BOX[2] - BOX[0]; h = BOX[3] - BOX[1]
    rows = (len(L) + cols - 1) // cols
    S = Image.new('RGB', (cols * (w + 4) + 4, rows * (h + 14) + 4), (90, 90, 140)); dr = ImageDraw.Draw(S)
    for k, (s, item, f) in enumerate(L):
        im = Image.open(f).convert('RGB').crop(BOX)
        x = 4 + (k % cols) * (w + 4); y = 4 + (k // cols) * (h + 14)
        dr.text((x, y), 'cat%d first item %d' % (c, item), fill=(255, 255, 0)); S.paste(im, (x, y + 11))
    S = S.resize((S.width * 2, S.height * 2), Image.NEAREST)
    p = '%s/sheet_cat%02d.png' % (d, c); S.save(p); allsheets.append(p); print(p, S.size, len(L))
