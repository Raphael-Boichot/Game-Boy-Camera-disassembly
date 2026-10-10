#!/usr/bin/env python3
"""For each hot-spot effect 0..15 (core): frames spent in state $0C:04 after tapping A on an armed hot spot, number of the first 240 frames whose screen differs from the
screen before the tap, and the largest fraction of differing pixels.   usage: hotspot_visibility.py"""
import sys, os, numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from hotspot_common import *
sav0 = open(SRC, 'rb').read(); prep(sav0); g.run(30); X, Y = g.peek(0xD667), g.peek(0xD668)
for k in range(16):
    prep(make(sav0, k, X, Y)); g.run(30); base = R.screen(g).copy(); ss = []
    g.keys(g.A); g.run(4); g.keys(0); n4 = 0; nd = 0; mx = 0.0; last = 0
    for f in range(240):
        g.run(1)
        if lib.cur() == (0x0C, 4): n4 += 1
        d = float((R.screen(g) != base).any(axis=-1).mean()) if R.screen(g).ndim == 3 else float((R.screen(g) != base).mean())
        if d > 0.002: nd += 1; last = f
        mx = max(mx, d)
    print('effect %2d: frames in 0C:04 = %3d, frames with visible change = %3d (last at +%d), max changed pixels = %4.1f%%, final state %02X:%02X' % (k, n4, nd, last, mx * 100, *lib.cur()), flush=True)
