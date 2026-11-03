#!/usr/bin/env python3
"""Core-side helper for walking menus on the ROM selected by GBCAM_ROM with real key presses (adaptive waits), used by guide_walk.py.
CLI:  GBCAM_ROM=ROM walk.py SAVE 'A R A' [--combo 2]  -> replays the path, prints (mode,state) after every key, then (mode,state) after each single key from the end state."""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g, R
from PIL import Image
import numpy as np
KEYS = ['A', 'B', 'L', 'R', 'U', 'D', 's', 'S']
def tap(k, hold=4, wait=30):
    g.keys(lib.KEY[k]); g.run(hold); g.keys(0); g.run(wait)
    last = lib.cur(); same = 0
    for _ in range(40):
        g.run(10); c = lib.cur(); same = same + 1 if c == last else 0; last = c
        if same >= 3: break
def boot(sav, combo=2): lib.boot(open(sav, 'rb').read() if isinstance(sav, str) else sav, combo=combo, free=400)
def replay(path, log=False):
    for k in path:
        tap(k)
        if log: print('  %s -> %02X:%02X' % (k, *lib.cur()))
def probe():
    snap = g.snapshot(); out = {}
    for k in KEYS:
        g.restore(snap); tap(k); out[k] = lib.cur()
    g.restore(snap); return out
def shot(fn, scale=2):
    im = Image.fromarray(np.array(R.screen(g))); im.resize((im.width * scale, im.height * scale), Image.NEAREST).save(fn)
if __name__ == '__main__':
    a = sys.argv[1:]; combo = int(a[a.index('--combo') + 1]) if '--combo' in a else 2
    boot(a[0], combo); path = a[1].split(); print('boot %02X:%02X' % lib.cur()); replay(path, True)
    print('at %02X:%02X' % lib.cur(), ' '.join('%s=%02X:%02X' % (k, *v) for k, v in probe().items()))
