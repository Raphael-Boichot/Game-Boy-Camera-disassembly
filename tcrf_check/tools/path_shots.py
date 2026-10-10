#!/usr/bin/env python3
"""Replay a corpus entry (optionally on another save) and screenshot every new (mode,state) met on the way, checking every 4 frames.
usage: path_shots.py CORPUS MODE:STATE OUTDIR [SAVENAME|-] [only_mode_hex]"""
import sys, os, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g, R
from PIL import Image
corpus, sig, out = sys.argv[1], sys.argv[2], sys.argv[3]; sav = sys.argv[4] if len(sys.argv) > 4 and sys.argv[4] != '-' else None
only = int(sys.argv[5], 16) if len(sys.argv) > 5 else None
os.makedirs(out, exist_ok=True)
C = lib.Corpus(corpus); s = tuple(int(x, 16) for x in sig.split(':'))
i = C.best(s); assert i is not None, 'no untainted entry for ' + sig
p = C.path(i); sp = dict(C.E[p[0]]['spec'])
lib.boot(lib.SAV(sav or sp['sav']), combo=sp['combo'], printer=sp['printer'], free=sp['free'])
seen = {}
def watch(nf):
    for _ in range(0, nf, 4):
        g.run(min(4, nf)); ms = lib.cur()
        if ms not in seen and (only is None or ms[0] == only):
            seen[ms] = 1; Image.fromarray(R.screen(g)).save('%s/%02X_%02X.png' % (out, *ms)); print('shot %02X:%02X' % ms, flush=True)
for j in p[1:]:
    for a in C.E[j]['actions']:
        if a[0] == 'P': lib.act(a); continue
        k, hold, wait = a[:3]; g.keys(k); watch(int(hold)); g.keys(0); watch(int(wait))
print('final %02X:%02X' % lib.cur(), 'entry', i, 'save', sav or sp['sav'])
# keep running idle for a while to see the successors of the final state
if len(sys.argv) > 6:
    for _ in range(int(sys.argv[6])): watch(60)
    print('after idle %02X:%02X' % lib.cur())
