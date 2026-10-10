#!/usr/bin/env python3
"""bank_view.py BANKHEX OUT.png [scale=3] : whole ROM bank as 2bpp tiles, 32 tiles per row, address labels every row.
Tint: BLUE = bytes never read/executed (merged v8/v7 coverage), RED = tile loaded into VRAM in the census but never referenced by a visible BG/window cell or OAM entry.
Env: GBCOV=cov.npz, CENSUS=census.json"""
import sys, os, json, numpy as np
from PIL import Image, ImageDraw
ROMP = os.environ.get('GBROM', 'pocketcamera_jp.gb'); rom = np.frombuffer(open(ROMP, 'rb').read(), dtype=np.uint8)
bank = int(sys.argv[1], 16); out = sys.argv[2]; sc = int(sys.argv[3]) if len(sys.argv) > 3 else 3
z = np.load(os.environ['GBCOV']); touched = (z['dr'] != 0) | (z['ex'] != 0)
red = set()
if os.environ.get('CENSUS'):
    for b in json.load(open(os.environ['CENSUS']))['blocks']:
        for k in range(b['len'] // 16):
            if b['loaded'][k] > 0 and b['used'][k] == 0: red.add(b['off'] + 16 * k)
base = bank * 0x4000 if bank else 0
COLS = 32; n = 0x4000 // 16; rows = n // COLS; PAL = np.array([255, 170, 85, 0], dtype=np.uint8)
img = np.zeros((rows * 8, COLS * 8, 3), dtype=np.uint8)
for t in range(n):
    o = base + t * 16; d = rom[o:o + 16]; lo, hi = d[0::2], d[1::2]; px = np.zeros((8, 8), dtype=np.uint8)
    for x in range(8): px[:, x] = ((lo >> (7 - x)) & 1) | (((hi >> (7 - x)) & 1) << 1)
    g = PAL[px].astype(np.int32); rgb = np.stack([g, g, g], -1)
    if not touched[o:o + 16].all(): rgb = (rgb * np.array([.55, .6, 1.0]) + np.array([0, 0, 50])).clip(0, 255)
    elif o in red: rgb = (rgb * np.array([1.0, .55, .55]) + np.array([60, 0, 0])).clip(0, 255)
    img[(t // COLS) * 8:(t // COLS) * 8 + 8, (t % COLS) * 8:(t % COLS) * 8 + 8] = rgb.astype(np.uint8)
im = Image.fromarray(img).resize((COLS * 8 * sc, rows * 8 * sc), Image.NEAREST)
M = Image.new('RGB', (im.width + 34, im.height), (255, 255, 255)); M.paste(im, (34, 0)); dr = ImageDraw.Draw(M)
for r in range(0, rows, 2): dr.text((1, r * 8 * sc + 1), '%04X' % (0x4000 + r * COLS * 16 if bank else r * COLS * 16), fill=(0, 0, 0))
M.save(out); print(out, M.size)
