#!/usr/bin/env python3
"""BFS over cursor moves of the album grid (mode 0A state 01) in my core: find the key path that puts the cursor ($D5D8) on a wanted photo index.
usage: album_nav.py CORPUS ENTRY N_ACTIONS_BEFORE_GRID WANTED_INDEX    (the grid is entered after the first N actions of the lineage)"""
import sys, os, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g
corpus, entry, nact, want = sys.argv[1], int(sys.argv[2]), int(sys.argv[3]), int(sys.argv[4])
C = lib.Corpus(corpus); p = C.path(entry); sp = dict(C.E[p[0]]['spec'])
lib.boot(lib.SAV(sp['sav']), combo=sp['combo'], printer=sp['printer'], free=sp['free'])
acts = [a for j in p[1:] for a in C.E[j]['actions']]
for a in acts[:nact]: lib.act(a)
def tap(k, h=4, w=40): g.keys(k); g.run(h); g.keys(0); g.run(w)
KEYS = [(g.RIGHT, 'Right'), (g.DOWN, 'Down'), (g.LEFT, 'Left'), (g.UP, 'Up')]
start = g.snapshot(); seen = {g.peek(0xD5D8): ()}; frontier = [(g.peek(0xD5D8), (), start)]
while frontier and want not in seen:
    nxt = []
    for cur, path, snap in frontier:
        for k, n in KEYS:
            g.restore(snap); tap(k)
            v = g.peek(0xD5D8); st = lib.cur()
            if st != (0x0A, 1) or v in seen: continue
            seen[v] = path + (n,); nxt.append((v, path + (n,), g.snapshot()))
    frontier = nxt
print('reachable cursor values', sorted(seen))
print('path to %d:' % want, seen.get(want))
