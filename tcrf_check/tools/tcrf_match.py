#!/usr/bin/env python3
"""Locate a TCRF thumbnail in the ROM's 2bpp tile data.
usage: tcrf_match.py PAGE.png x0 y0 x1 y1 [scale=2.7] [thr=0.35] : crop the page, shrink by `scale` (page zoom x image zoom), quantise to 4 grey levels,
try the 64 tile-grid offsets, match every 8x8 cell against all distinct ROM tiles (L2 distance on levels), report the offset with most good cells and the ROM places of those cells."""
import sys, numpy as np
from PIL import Image
page, x0, y0, x1, y1 = sys.argv[1], *map(int, sys.argv[2:6]); sc = float(sys.argv[6]) if len(sys.argv) > 6 else 2.7; thr = float(sys.argv[7]) if len(sys.argv) > 7 else 0.35
rom = np.frombuffer(open('pocketcamera_jp.gb', 'rb').read(), dtype=np.uint8)
n = len(rom) // 16
# all tile-aligned (16-byte aligned) ROM tiles  + offsets aligned to 16 only (assume block alignment 16)
T = rom[:n * 16].reshape(n, 16); lo = T[:, 0::2]; hi = T[:, 1::2]
lv = np.zeros((n, 8, 8), dtype=np.uint8)
for x in range(8): lv[:, :, x] = ((lo >> (7 - x)) & 1) | (((hi >> (7 - x)) & 1) << 1)
# shade: level 0 = white(255) .. 3 = black(0)  (BGP identity)
R = lv.reshape(n, 64).astype(np.float32)
keep = np.nonzero((R.std(axis=1) > 0.3))[0]       # skip blank tiles
Rk = R[keep]; Rn = (Rk ** 2).sum(1)
im = Image.open(page).convert('L').crop((x0, y0, x1, y1)); w, h = im.size
im = im.resize((max(8, round(w / sc)), max(8, round(h / sc))), Image.BOX); a = np.asarray(im, dtype=np.float32)
# quantise to 4 levels by quantiles of the darkness distribution (assume at least some white, some black)
lvl = np.digitize(255 - a, [255 * .17, 255 * .5, 255 * .83]).astype(np.float32)
best = None
for dy in range(8):
    for dx in range(8):
        sub = lvl[dy:, dx:]; th, tw = sub.shape[0] // 8, sub.shape[1] // 8
        if th < 1 or tw < 1: continue
        Q = sub[:th * 8, :tw * 8].reshape(th, 8, tw, 8).transpose(0, 2, 1, 3).reshape(-1, 64)
        nz = Q.std(axis=1) > 0.3
        if nz.sum() < 2: continue
        Qn = Q[nz]; d = (Qn ** 2).sum(1)[:, None] + Rn[None, :] - 2 * Qn @ Rk.T
        m = d.min(1) / 64.0; good = (m < thr).sum()
        if best is None or good > best[0]: best = (good, dy, dx, th, tw, np.nonzero(nz)[0], d.argmin(1), m)
good, dy, dx, th, tw, idx, arg, m = best
print('best offset dy=%d dx=%d  cells (non-blank) %d, matched %d (thr %.2f)' % (dy, dx, len(idx), good, thr))
res = []
for k, j in enumerate(idx):
    if m[k] < thr: res.append((j // tw, j % tw, keep[arg[k]] * 16, m[k]))
res.sort(key=lambda r: r[2])
def bk(o): return '%02X:%04X' % (o // 0x4000, (o % 0x4000) + (0x4000 if o >= 0x4000 else 0))
for r in res[:60]: print('cell(%d,%d) -> %s  d=%.2f' % (r[0], r[1], bk(r[2]), r[3]))
