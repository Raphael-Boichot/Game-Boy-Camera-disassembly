#!/usr/bin/env python3
"""Core-side check of the D.J. (mode $1F) score-print command: replay unlock_runs/dj_hit.json (damaged save + 28 taps that reach 1F:01 through Space Fever II),
search single-key taps for the state 1F:09 whose handler (05:46BE) ends in the print test (05:4744-4758: B -> state $0C; Start held + A pressed -> jp $5959),
then press the candidate command with the printer attached and watch 05:5959 and the print row counter $D8C6."""
import sys, os, json, itertools
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g
import numpy as np, blocks as B
hit = json.load(open('unlock_runs/dj_hit.json'))
d = bytearray(open('package/coverage/saves/%s.sav' % hit['base'], 'rb').read())
for name, off, x in hit['edits']: d[off] ^= x
g.set_organic(1); g.reset(bytes(d)); g.L.gb_attach_printer(1); g.run(300)
for k, w in hit['seq']:
    g.keys(k); g.run(4); g.keys(0); g.run(w)
print('after the 28 taps: mode:state %02X:%02X' % lib.cur())
ex = g.cov_exec(); PR = B.flat(5, 0x5959)
KEYS = [(g.A, 'A'), (g.B, 'B'), (g.SELECT, 'Select'), (g.START, 'Start'), (g.RIGHT, 'Right'), (g.LEFT, 'Left'), (g.UP, 'Up'), (g.DOWN, 'Down')]
def tap(k, hold=4, wait=40): g.keys(k); g.run(hold); g.keys(0); g.run(wait)
seen = {}; frontier = [((), g.snapshot())]; found = None
for depth in range(6):
    nxt = []
    for path, snap in frontier:
        for k, n in KEYS:
            g.restore(snap); tap(k); st = lib.cur()
            if st[0] != 0x1F: continue
            key = (st, g.peek(0xD985), g.peek(0xD989))
            if key in seen: continue
            seen[key] = path + (n,); nxt.append((path + (n,), g.snapshot()))
            if st[1] == 9 and not found: found = (path + (n,), g.snapshot())
    frontier = nxt
    if found: break
print('states of mode 1F seen:', sorted({k[0][1] for k in seen}), ' first 1F:09 path:', found and found[0])
if found:
    snap = found[1]
    for label, run in (('Start held + A (the command read from 05:4744-4758)', lambda: (g.keys(g.START), g.run(8), g.keys(g.START | g.A), g.run(4), g.keys(g.START), g.run(4), g.keys(0))),
                       ('A alone', lambda: (g.keys(g.A), g.run(4), g.keys(0))), ('Start alone', lambda: (g.keys(g.START), g.run(4), g.keys(0)))):
        g.restore(snap); ex[:] = 0; run(); g.run(40); entered = ex[PR] > 0; st = lib.cur()
        g.run(1500)
        print('%-60s 05:5959 executed: %-5s  mode:state after 40 f %02X:%02X; after 1500 more frames %02X:%02X  row counter $D8C6 = %02X' % (label, entered, st[0], st[1], *lib.cur(), g.peek(0xD8C6)))
