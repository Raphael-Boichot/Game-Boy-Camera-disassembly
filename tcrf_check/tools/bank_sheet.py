#!/usr/bin/env python3
"""Render a whole ROM bank (or a range) as 2bpp tiles; tiles holding bytes that were never read/executed are tinted red.
usage: bank_sheet.py ROM COV.npz BANK OUT.png [start_addr end_addr] [scale]"""
import sys, numpy as np
from PIL import Image
rom = np.frombuffer(open(sys.argv[1],'rb').read(), dtype=np.uint8); z = np.load(sys.argv[2]); touched = (z['dr'] != 0) | (z['ex'] != 0)
b = int(sys.argv[3], 16); out = sys.argv[4]
s0 = int(sys.argv[5], 16) if len(sys.argv) > 5 else 0x4000; s1 = int(sys.argv[6], 16) if len(sys.argv) > 6 else 0x8000
scale = int(sys.argv[7]) if len(sys.argv) > 7 else 2
base = b * 0x4000 - 0x4000 if b else 0
lo, hi = base + s0, base + s1; n = (hi - lo) // 16; cols = 16; rows = (n + cols - 1) // cols
PAL = np.array([255, 170, 85, 0], dtype=np.uint8)
img = np.zeros((rows * 8, cols * 8, 3), dtype=np.uint8)
for t in range(n):
    d = rom[lo + t * 16: lo + t * 16 + 16]; tt = touched[lo + t * 16: lo + t * 16 + 16]
    lo_, hi_ = d[0::2], d[1::2]; px = np.zeros((8, 8), dtype=np.uint8)
    for x in range(8): px[:, x] = ((lo_ >> (7 - x)) & 1) | (((hi_ >> (7 - x)) & 1) << 1)
    g = PAL[px]; r0 = (t // cols) * 8; c0 = (t % cols) * 8
    rgb = np.stack([g, g, g], -1).astype(np.int32)
    if not tt.all(): rgb[..., 1] = rgb[..., 1] * 0.55; rgb[..., 2] = rgb[..., 2] * 0.55; rgb[..., 0] = np.minimum(255, rgb[..., 0] * 0.9 + 40)
    img[r0:r0 + 8, c0:c0 + 8] = rgb.astype(np.uint8)
Image.fromarray(img).resize((cols * 8 * scale, rows * 8 * scale), Image.NEAREST).save(out)
print(out, n, 'tiles')
