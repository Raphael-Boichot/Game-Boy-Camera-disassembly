#!/usr/bin/env python3
"""Replay the key sequence that reaches JP (mode,state) on the ROM given by GBCAM_ROM and save the final screen.
usage: GBCAM_ROM=roms/gbcam_usa_eu.gb intl_replay.py CORPUS OUTDIR MODE:STATE [MODE:STATE ...]
Prints the key sequence as button names and the (mode,state) reached on that ROM (the inputs are the JP ones)."""
import sys, os, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g, R
from PIL import Image
corpus, out = sys.argv[1], sys.argv[2]; os.makedirs(out, exist_ok=True)
C = lib.Corpus(corpus)
NAMES = [(g.RIGHT, 'Right'), (g.LEFT, 'Left'), (g.UP, 'Up'), (g.DOWN, 'Down'), (g.A, 'A'), (g.B, 'B'), (g.SELECT, 'Select'), (g.START, 'Start')]
def kn(k): return '+'.join(n for m, n in NAMES if k & m) or '-'
for sig in sys.argv[3:]:
    s = tuple(int(x, 16) for x in sig.split(':')); i = C.best(s)
    if i is None: print(sig, 'no entry'); continue
    p = C.path(i); sp = dict(C.E[p[0]]['spec'])
    lib.boot(lib.SAV(sp['sav']), combo=sp['combo'], printer=sp['printer'], free=sp['free'])
    seq = []
    for j in p[1:]:
        for a in C.E[j]['actions']:
            if a[0] == 'P': seq.append('poke'); lib.act(a); continue
            seq.append('%s(%d/%d)' % (kn(a[0]), a[1], a[2])); lib.act(a)
    g.run(30); fn = '%s/%02X_%02X.png' % (out, *s)
    Image.fromarray(R.screen(g)).save(fn)
    print(sig, 'entry', i, 'save', sp['sav'], 'combo', sp['combo'], '->', 'reached %02X:%02X' % lib.cur(), '|', ' '.join(seq), flush=True)
