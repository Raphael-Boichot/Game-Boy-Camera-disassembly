#!/usr/bin/env python3
"""Contact sheets of screens named MM_SS.png in two directories (JP | INTL) for a list of signatures.
usage: atlas_sheet.py OUT.png JPDIR INTLDIR SIG [SIG...]   (INTLDIR may be '-' for JP only). Layout: one row per signature pair."""
import sys, os
from PIL import Image, ImageDraw
out, jd, idr = sys.argv[1:4]; sigs = sys.argv[4:]
cols = int(os.environ.get('COLS', 3))
S = int(os.environ.get('SCALE', 1)); w, h = 160 * S, 144 * S; cap = 14
pair = idr != '-'
cw = (2 * w + 8) if pair else w
cell_h = h + cap
rows = (len(sigs) + cols - 1) // cols
sheet = Image.new('RGB', (cols * (cw + 8), rows * (cell_h + 6)), (235, 235, 235)); d = ImageDraw.Draw(sheet)
for n, sg in enumerate(sigs):
    fn = sg.replace(':', '_') + '.png'; x = (n % cols) * (cw + 8); y = (n // cols) * (cell_h + 6)
    d.text((x + 2, y + 1), sg, fill=(0, 0, 0))
    for k, dd in enumerate([jd] + ([idr] if pair else [])):
        f = os.path.join(dd, fn)
        if os.path.exists(f):
            sheet.paste(Image.open(f).convert('RGB').resize((w, h), Image.NEAREST), (x + k * (w + 8), y + cap))
        else:
            d.rectangle((x + k * (w + 8), y + cap, x + k * (w + 8) + w, y + cap + h), outline=(200, 0, 0))
sheet.save(out); print(out, sheet.size)
