#!/usr/bin/env python3
"""Album B page walk in the core: reach the album grid (mode $0A state 1, 'view which photo?') with a joypad-only path of the corpus, press Right one cell at a time and
record the page label (A1..B4 text is a tile row at the bottom of the screen: here simply the screen) and the number of non-blank thumbnails on each page.
usage: [MIRROR=1] [GBCAM_ROM=...] albumb_pages.py CORPUS SAVE.sav OUTPNG [STEPS]     (prints one line per distinct page)"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g, R
import numpy as np
from PIL import Image
corpus, sav, out = sys.argv[1:4]; steps = int(sys.argv[4]) if len(sys.argv) > 4 else 60
C = lib.Corpus(corpus); i = C.best((0xA, 1)); p = C.path(i); sp = dict(C.E[p[0]]['spec'])
lib.boot(open(sav, 'rb').read(), combo=sp['combo'], printer=sp['printer'], free=sp['free'])
LR = g.LEFT | g.RIGHT
def mirror(k):
    l, r = k & g.LEFT, k & g.RIGHT
    return (k & ~LR) | (g.RIGHT if l else 0) | (g.LEFT if r else 0)
for j in p[1:]:
    for a in C.E[j]['actions']:
        if a[0] != 'P' and os.environ.get('MIRROR') == '1' and lib.cur()[0] == 0 and lib.cur()[1] in (0, 1, 2) and (a[0] & LR): a = (mirror(a[0]),) + tuple(a[1:])
        lib.act(a)
g.run(60); print('reached %02X:%02X' % lib.cur())
shots = []; prev = None
for n in range(steps):
    img = R.screen(g)
    if prev is None or (img != prev).any():
        shots.append(img.copy())
    prev = img
    lib.act((g.RIGHT, 4, 14))
shots = shots[::3]
print(len(shots), 'screens kept (every 3rd Right press)')
w, h = 160, 144; cols = 8; rows = (len(shots) + cols - 1) // cols
S = Image.new('RGB', (cols * w, rows * h), 'white')
for k, im in enumerate(shots): S.paste(Image.fromarray(im).convert('RGB'), ((k % cols) * w, (k // cols) * h))
S.save(out); print(out, S.size)
