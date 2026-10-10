#!/usr/bin/env python3
"""What does 04:5E4C do? Dump the stamp work buffers $C000-$C7FF before / after each firing of the hold-A branch and render them as 2bpp tiles (5 tiles wide).
usage: stamp_hold_a2.py OUTDIR [CORPUS]"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g, R
import numpy as np
from PIL import Image
out = sys.argv[1]; os.makedirs(out, exist_ok=True)
corpus = sys.argv[2] if len(sys.argv) > 2 else 'unlock_runs/f1_organic/corpus.jsonl'
C = lib.Corpus(corpus); i = C.best((0x11, 3)); g.set_organic(1); C.replay(i); g.run(30)
W = g.wram()
def buf(a): return bytes(W[a - 0xC000: a - 0xC000 + 0x1E0])
def tiles(b, cols=5, scale=4):
    n = len(b) // 16; rows = (n + cols - 1) // cols; im = np.full((rows * 8, cols * 8), 255, np.uint8)
    for t in range(n):
        for y in range(8):
            lo = b[t * 16 + y * 2]; hi = b[t * 16 + y * 2 + 1]
            for x in range(8):
                v = ((hi >> (7 - x)) & 1) << 1 | ((lo >> (7 - x)) & 1); im[(t // cols) * 8 + y, (t % cols) * 8 + x] = [255, 170, 85, 0][v]
    return Image.fromarray(im).resize((cols * 8 * scale, rows * 8 * scale), Image.NEAREST)
lib.act((g.A, 4, 30)); g.run(10)
snaps = {}
def grab(tag): snaps[tag] = [buf(a) for a in (0xC000, 0xC1E0, 0xC3C0, 0xC5A0)]
EX = g.cov_exec()
g.keys(g.A); f = 0; fired = 0; prev = int(EX[0x11E4C])
grab('t000')
for f in range(1, 520):
    g.run(1)
    if f in (170, 179): grab('t%03d' % f)
    if g.peek(0xD641) in (95, 99, 100) and f > 180 and 'after%d' % fired not in snaps and f - 0 > 0:
        pass
    if f in (185, 190, 200, 280, 285, 295, 300, 380, 395): grab('t%03d' % f)
g.keys(0)
names = sorted(snaps)
W_ = 4 * (5 * 8 * 4 + 8); H_ = len(names) * (6 * 8 * 4 + 8)
M = Image.new('RGB', (W_, H_), (90, 90, 140))
for r, n in enumerate(names):
    for c, b in enumerate(snaps[n]): M.paste(tiles(b).convert('RGB'), (c * (5 * 8 * 4 + 8), r * (6 * 8 * 4 + 8)))
M.save(out + '/stamp_buffers.png'); print(names)
for n in names:
    print(n, [hash(b) & 0xffff for b in snaps[n]], 'same-as-prev-c000' if False else '')
