#!/usr/bin/env python3
"""Screens of the music mode $1F (Trippy-H / D.J.) in my core: replay dj_hit.json (damaged save + 28 taps -> 1F:01), then explore single-key taps and save a screenshot of every (state, page variables) seen.
usage: dj_screens.py OUTDIR"""
import sys, os, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g, R
from PIL import Image
import numpy as np
out = sys.argv[1]; os.makedirs(out, exist_ok=True)
hit = json.load(open('unlock_runs/dj_hit.json'))
d = bytearray(open('package/coverage/saves/%s.sav' % hit['base'], 'rb').read())
for name, off, x in hit['edits']: d[off] ^= x
g.set_organic(1); g.reset(bytes(d)); g.L.gb_attach_printer(1); g.run(300)
for k, w in hit['seq']: g.keys(k); g.run(4); g.keys(0); g.run(w)
KEYS = [(g.A, 'A'), (g.B, 'B'), (g.SELECT, 'Select'), (g.START, 'Start'), (g.RIGHT, 'Right'), (g.LEFT, 'Left'), (g.UP, 'Up'), (g.DOWN, 'Down')]
def tap(k, hold=4, wait=40): g.keys(k); g.run(hold); g.keys(0); g.run(wait)
def shot(path):
    im = R.screen(g)
    if not isinstance(im, Image.Image): im = Image.fromarray(np.array(im))
    im.save(path)
seen = {}; frontier = [((), g.snapshot())]
shot(os.path.join(out, 'state_01_start.png'))
for depth in range(7):
    nxt = []
    for path, snap in frontier:
        for k, n in KEYS:
            g.restore(snap); tap(k); st = lib.cur()
            if st[0] != 0x1F: continue
            key = (st[1], g.peek(0xD985), g.peek(0xD989))
            if key in seen: continue
            seen[key] = path + (n,); nxt.append((path + (n,), g.snapshot()))
            shot(os.path.join(out, 'state_%02X_%s.png' % (st[1], '-'.join(path + (n,)))))
    frontier = nxt
json.dump({'%02X|%02X|%02X' % k: v for k, v in seen.items()}, open(os.path.join(out, 'paths.json'), 'w'), indent=1)
print(len(seen), 'distinct (state, page vars):'); [print(' %02X D985=%02X D989=%02X via %s' % (k[0], k[1], k[2], '+'.join(v))) for k, v in sorted(seen.items())]
