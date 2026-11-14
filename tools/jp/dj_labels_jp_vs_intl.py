#!/usr/bin/env python3
"""TCRF Regional Differences, D.J. screens: "TRIPY-H" -> "TRIPPY-H" and "FEQ." -> "FRQ." (checklist C12), drawn from the two ROMs only.
  TRIPY-H / TRIPPY-H : sprite list $A7 of the OAM table 01:5D47 (JP, list at 01:6ED2, 6 sprites, OBJ ids $47-$4C) / 01:5D2B (intl, list at 01:6E9E, 7 sprites, ids $47-$4D);
                       OBJ ids are VRAM $8000 + 16 * id = ROM 1C:78C0 + 16 * (id - $46) (the block 1C:7860-7C5F is copied to $8400 by 05:45CB).
  FEQ. / FRQ.        : BG ids $76 and $77 of the SOUND I page (map cells row 3, cols 15 and 16 of the overlay 23:6B00), tile data 1D:4500 + 16 * (id - $50) = 1D:4760 / 1D:4770
                       (the NOISE page loads the same strip from 1D:4000: 1D:4260 / 4270).
usage: dj_labels_jp_vs_intl.py JP.gb INTL.gb OUT.png OUT.csv"""
import sys, csv
import numpy as np
from PIL import Image
jp = open(sys.argv[1], 'rb').read(); it = open(sys.argv[2], 'rb').read()
SH = (255, 224, 140, 40)   # shades 0-3 as grey levels
def fo(bank, a): return bank * 0x4000 + (a - 0x4000) if bank else a
def tile(rom, bank, a):
    o = fo(bank, a); t = np.zeros((8, 8), np.uint8)
    for y in range(8):
        lo, hi = rom[o + 2 * y], rom[o + 2 * y + 1]
        for x in range(8): t[y, x] = ((hi >> (7 - x)) & 1) * 2 + ((lo >> (7 - x)) & 1)
    return t
def sprite_label(rom, bank, a):
    """records [y, x, id, attr] until a byte >= $80; returns the 8-pixel-high strip and the list [(x, id)]"""
    o = fo(bank, a); recs = []
    while rom[o] < 0x80: recs.append((rom[o + 1] - 256 if rom[o + 1] > 127 else rom[o + 1], rom[o + 2])); o += 4
    x0 = min(x for x, _ in recs); x1 = max(x for x, _ in recs) + 8
    img = np.zeros((8, x1 - x0), np.uint8)
    for x, i in recs:
        t = tile(rom, 0x1C, 0x78C0 + 16 * (i - 0x46))
        sub = img[:, x - x0:x - x0 + 8]; sub[:] = np.where(t > 0, t, sub)
    return img, recs
def render(a, scale):
    return np.kron(np.array(SH, np.uint8)[a], np.ones((scale, scale), np.uint8))
rows = []; panels = []
for name, rom, tb, listaddr in (('JP', jp, 0x5D47, 0x6ED2), ('INTL', it, 0x5D2B, 0x6E9E)):
    p = fo(1, tb + 2 * 0xA7); ptr = rom[p] | rom[p + 1] << 8
    assert ptr == listaddr, (name, hex(ptr))
    img, recs = sprite_label(rom, 1, ptr)
    rows.append([name, 'TRIPY-H' if name == 'JP' else 'TRIPPY-H', 'OBJ list $A7 of 01:%04X at 01:%04X' % (tb, ptr), len(recs), ' '.join('$%02X' % i for _, i in sorted(recs)), '1C:%04X-%04X' % (0x78C0 + 16 * (min(i for _, i in recs) - 0x46), 0x78C0 + 16 * (max(i for _, i in recs) - 0x46 + 1) - 1)])
    strip = [tile(rom, 0x1D, 0x4500 + 16 * (i - 0x50)) for i in (0x75, 0x76, 0x77)]
    bg = np.hstack(strip)
    rows.append([name, 'FEQ.' if name == 'JP' else 'FRQ.', 'BG ids $75 $76 $77 (row 3 cols 14-16)', 3, '$75 $76 $77', '1D:4750 / 4760 / 4770'])
    panels.append((name, img, bg))
S = 6; W = max(p[1].shape[1] for p in panels) * S; WB = 24 * S; gap = 6
canvas = np.full((2 * (8 * S + gap) + 2 * (8 * S + gap) + 2 * gap, max(W, WB) + 20), 255, np.uint8)
y = gap
for name, img, bg in panels:
    r = render(img, S); canvas[y:y + r.shape[0], 10:10 + r.shape[1]] = r; y += 8 * S + gap
for name, img, bg in panels:
    r = render(bg, S); canvas[y:y + r.shape[0], 10:10 + r.shape[1]] = r; y += 8 * S + gap
Image.fromarray(canvas).save(sys.argv[3])
with open(sys.argv[4], 'w', newline='') as f:
    w = csv.writer(f); w.writerow(['rom', 'text', 'what', 'objects_or_tiles', 'ids', 'tile_data'])
    for r in rows: w.writerow(r)
diff = [i for i in range(0x1000, 0x1010) if False]
print('wrote', sys.argv[3], sys.argv[4])
