#!/usr/bin/env python3
"""Explore the print screens in my core with the printer attached: replay a corpus lineage (its root save, printer forced to 1), then try each single key from the reached state and
report (mode,state) and the print variables  $D674 (option cursor)  $D7C1 (border)  $D806 (Start option)  $DB6D (layout)  $DBCB (framed flag)  $D5D8 (photo)  $D807 (margin)  $DAAB (density).
usage: print_explore.py CORPUS ENTRY OUTDIR [--depth N] [--sav SAVENAME] [--pre Select,Down]"""
import sys, os, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g, R
from PIL import Image
import numpy as np
corpus, entry, out = sys.argv[1:4]; entry = int(entry); depth = int(sys.argv[sys.argv.index('--depth') + 1]) if '--depth' in sys.argv else 1
os.makedirs(out, exist_ok=True)
SAVOVER = sys.argv[sys.argv.index('--sav') + 1] if '--sav' in sys.argv else None
C = lib.Corpus(corpus); p = C.path(entry); sp = dict(C.E[p[0]]['spec'])
lib.boot(lib.SAV(SAVOVER or sp['sav']), combo=sp['combo'], printer=1, free=sp['free'])
for j in p[1:]:
    for a in C.E[j]['actions']: lib.act(a)
PRE = sys.argv[sys.argv.index('--pre') + 1].split(',') if '--pre' in sys.argv else []
for n in PRE: g.keys(dict(A=g.A, B=g.B, Start=g.START, Select=g.SELECT, Right=g.RIGHT, Left=g.LEFT, Up=g.UP, Down=g.DOWN)[n]); g.run(4); g.keys(0); g.run(40)
def vars_(): return 'D674=%02X D7C1=%02X D806=%02X DB6D=%02X DBCB=%02X D5D8=%02X D807=%02X DAAB=%02X D800=%02X D810=%02X D808=%02X%02X%02X%02X%02X%02X%02X%02X' % tuple(g.peek(x) for x in (0xD674, 0xD7C1, 0xD806, 0xDB6D, 0xDBCB, 0xD5D8, 0xD807, 0xDAAB, 0xD800, 0xD810) + tuple(0xD808 + i for i in range(8)))
def shot(name):
    im = R.screen(g)
    if not isinstance(im, Image.Image): im = Image.fromarray(np.array(im))
    im.resize((im.width * 2, im.height * 2), Image.NEAREST).save(os.path.join(out, name))
print('start %02X:%02X' % lib.cur(), vars_()); shot('start.png')
KEYS = [(g.A, 'A'), (g.B, 'B'), (g.START, 'Start'), (g.SELECT, 'Select'), (g.RIGHT, 'Right'), (g.LEFT, 'Left'), (g.UP, 'Up'), (g.DOWN, 'Down')]
def tap(k, hold=4, wait=30): g.keys(k); g.run(hold); g.keys(0); g.run(wait)
frontier = [((), g.snapshot())]; seen = {}
for d in range(depth):
    nxt = []
    for path, snap in frontier:
        for k, n in KEYS:
            g.restore(snap); tap(k); st = lib.cur(); key = (st, vars_())
            if key in seen: continue
            seen[key] = path + (n,); nxt.append((path + (n,), g.snapshot()))
            print('%-24s -> %02X:%02X %s' % ('+'.join(path + (n,)), st[0], st[1], vars_()), flush=True)
            shot('%s.png' % '-'.join(path + (n,)))
    frontier = nxt
