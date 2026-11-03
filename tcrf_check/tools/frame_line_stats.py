#!/usr/bin/env python3
"""Per-line statistics of one full 128 x 128 sensor frame supplied as a grey-scale PNG (README 9, 18.9): is a line flat (a reference / masked line) or does it carry the scene?
The PNG may be an integer upscale of the frame (--scale 4: every pixel is a 4 x 4 block, checked); address 0x0000 = the top left pixel, line y = row y.
Only numbers are written: the picture itself is not kept in the repository.
usage: frame_line_stats.py FRAME.png OUT.csv [--scale 4] [--lines 0-9,114-127]
Writes OUT.csv (line_y, mean, min, max, std, mean_x0_63, mean_x64_127, pixels_223_226) for the chosen lines and prints the same, then the values of the 12 + 12 pixels of the calibration test
(README 18.3: x 1-3 / y 1-4 and x 65-67 / y 1-4), the column 0 offset on lines 0-12 and the fraction of the frame at the clipping level."""
import sys, csv
import numpy as np
from PIL import Image
args = sys.argv[1:]; png, out = args[0], args[1]
scale = int(args[args.index('--scale') + 1]) if '--scale' in args else 4
spec = args[args.index('--lines') + 1] if '--lines' in args else '0-9,114-127'
a = np.array(Image.open(png).convert('L')).astype(int)
assert a.shape == (128 * scale, 128 * scale), a.shape
blk = a.reshape(128, scale, 128, scale)
assert (blk.max(axis=(1, 3)) == blk.min(axis=(1, 3))).all(), 'not an integer upscale'
p = blk[:, 0, :, 0]
lines = []
for part in spec.split(','):
    lo, _, hi = part.partition('-'); lines += list(range(int(lo), int(hi or lo) + 1))
rows = [[y, round(p[y].mean(), 1), int(p[y].min()), int(p[y].max()), round(p[y].std(), 1), round(p[y, :64].mean(), 1), round(p[y, 64:].mean(), 1), int(((p[y] >= 223) & (p[y] <= 226)).sum())] for y in lines]
with open(out, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['line_y', 'mean', 'min', 'max', 'std', 'mean_x0_63', 'mean_x64_127', 'pixels_223_226']); w.writerows(rows)
print('line   mean  min  max   std  mean x0-63  mean x64-127  pixels 223-226')
for r in rows: print('%4d %6.1f %4d %4d %5.1f %10.1f %12.1f %10d' % tuple(r))
print('test pixels A (x1-3, y1-4):', p[1:5, 1:4].tolist()); print('test pixels B (x65-67, y1-4):', p[1:5, 65:68].tolist())
print('column 0 on lines 0-12:', p[0:13, 0].tolist(), ' column 1-3 mean on the same lines: %.1f' % p[0:13, 1:4].mean())
s = p[0:122]; print('lines 0-121: %d of %d pixels at 223-226, %d above 226' % (((s >= 223) & (s <= 226)).sum(), s.size, (s > 226).sum()))
