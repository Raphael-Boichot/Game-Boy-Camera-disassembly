#!/usr/bin/env python3
"""Find a key path to given (mode,state) targets with a breadth-first search over real key presses (core, snapshot / restore), on the ROM selected by GBCAM_ROM,
and save the screen reached.  Works on both ROMs, so the same screen can be captured on the Japanese and the international build.
usage: GBCAM_ROM=ROM nav_bfs.py SAVEFILE OUTDIR MM:SS [MM:SS ...] [--combo N] [--depth N] [--keys ABLRUDsS] [--pre 'tokens']
Writes OUTDIR/MM_SS.png (2x) and OUTDIR/paths.json (key tokens, same letters as lib.play; hold 4 frames, wait 30)."""
import sys, os, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g, R
from PIL import Image
import numpy as np
a = sys.argv[1:]
def opt(n, d=None):
    if n in a: i = a.index(n); v = a[i + 1]; del a[i:i + 2]; return v
    return d
combo = int(opt('--combo', '0')); depth = int(opt('--depth', '9')); keys = opt('--keys', 'ABLRUD'); pre = opt('--pre', '')
sav, out = a[0], a[1]; targets = [tuple(int(x, 16) for x in t.split(':')) for t in a[2:]]
os.makedirs(out, exist_ok=True)
K = dict(lib.KEY)
def tap(k, hold=4, wait=30):
    g.keys(K[k]); g.run(hold); g.keys(0); g.run(wait)
    last = lib.cur(); same = 0
    for _ in range(40):                                  # let a screen load finish: (mode,state) unchanged for 3 checks of 10 frames
        g.run(10); c = lib.cur(); same = same + 1 if c == last else 0; last = c
        if same >= 3: break
def node_key():
    m = lib.cur(); return (m, tuple(g.peek(x) for x in (0xD5D8, 0xD5EC, 0xD5EF, 0xD5DA, 0xD614, 0xD63D, 0xD63E, 0xD63F, 0xD665, 0xD666, 0xD667, 0xD668, 0xD674, 0xD642)))
lib.boot(open(sav, 'rb').read(), combo=combo, free=400)
for t in pre.split():
    if t[0] == 'w': g.run(int(t[1:]))
    else: tap(t)
print('start', '%02X:%02X' % lib.cur(), flush=True)
found = {}; seen = {node_key()}; frontier = [((), g.snapshot())]
def shot(path, st):
    im = Image.fromarray(np.array(R.screen(g))); im.resize((im.width * 2, im.height * 2), Image.NEAREST).save('%s/%02X_%02X.png' % (out, *st))
for d in range(depth):
    nxt = []
    for path, snap in frontier:
        for k in keys:
            g.restore(snap); tap(k); st = lib.cur(); nk = node_key()
            if st in targets and st not in found:
                found[st] = path + (k,); shot(path, st); print('FOUND %02X:%02X' % st, ' '.join(found[st]), flush=True)
            if nk in seen: continue
            seen.add(nk); nxt.append((path + (k,), g.snapshot()))
    frontier = nxt; print('depth', d + 1, 'frontier', len(frontier), 'seen', len(seen), 'found', len(found), flush=True)
    if len(found) == len(targets) or not frontier: break
json.dump({'%02X:%02X' % k: ' '.join(v) for k, v in found.items()}, open(out + '/paths.json', 'w'), indent=1)
