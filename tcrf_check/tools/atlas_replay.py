#!/usr/bin/env python3
"""Replay, for every (mode,state) signature of the corpus, the cheapest organic key path on the ROM given by GBCAM_ROM
and save the final screen.  With MIRROR=1 (international ROM) Left/Right pressed on the main menu (mode 0, states 0-2) are swapped,
because the main menu is laid out mirrored in the two ROMs (JP: みる left / とる right ; international: SHOOT left / VIEW right).
usage: [MIRROR=1] GBCAM_ROM=... atlas_replay.py CORPUS OUTDIR [SIG ...]   (no SIG = all)  -> OUTDIR/MM_SS.png + OUTDIR/result.json"""
import sys, os, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g, R
from PIL import Image
corpus, out = sys.argv[1], sys.argv[2]; os.makedirs(out, exist_ok=True)
MIRROR = os.environ.get('MIRROR') == '1'
C = lib.Corpus(corpus)
sigs = sys.argv[3:] or ['%02X:%02X' % s for s in sorted(set(tuple(e['sig']) for e in C.E.values()))]
res = {}
LR = g.LEFT | g.RIGHT
def mirror(k):
    l, r = k & g.LEFT, k & g.RIGHT
    return (k & ~LR) | (g.RIGHT if l else 0) | (g.LEFT if r else 0)
for sig in sigs:
    s = tuple(int(x, 16) for x in sig.split(':')); i = C.best(s)
    if i is None: res[sig] = None; continue
    p = C.path(i); sp = dict(C.E[p[0]]['spec'])
    lib.boot(lib.SAV(sp['sav']), combo=sp['combo'], printer=sp['printer'], free=sp['free'])
    nswap = 0
    for j in p[1:]:
        for a in C.E[j]['actions']:
            if a[0] != 'P' and MIRROR and lib.cur()[0] == 0 and lib.cur()[1] in (0, 1, 2) and (a[0] & LR):
                a = (mirror(a[0]),) + tuple(a[1:]); nswap += 1
            lib.act(a)
    g.run(30); fn = '%s/%02X_%02X.png' % (out, *s)
    Image.fromarray(R.screen(g)).save(fn)
    res[sig] = dict(entry=i, reached='%02X:%02X' % lib.cur(), swaps=nswap, sav=sp['sav'], combo=sp['combo'])
    print(sig, '->', res[sig]['reached'], 'swaps', nswap, flush=True)
json.dump(res, open(out + '/result.json', 'w'), indent=1)
