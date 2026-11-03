#!/usr/bin/env python3
"""Breadth-first key search over EVERY state of the D.J. (music editor) modes $1F / $20 in my core, joypad only (no RAM poke), with all eight keys and the two-key chords
(README 16.15 / 16.19).  dj_fields.py (16.15) tapped only Right, Left, Up, Down, A and Select on the three pages SOUND I / SOUND II / NOISE; B, Start, the chords and the
other D.J. states were never pressed.  Here the state key is (mode, state, $D8C5, $D8C8, $D8CC, $D8F3, $D8F6, $D8FA, $D8FD, $D985), every (state, key) is pressed once
(key held 4 frames, then 30 frames released), states outside modes $1F / $20 are not expanded (B leaves the editor, Start prints).
usage: dj_pages.py OUTDIR [ROUTE.json] [--cap N] [--coarse] [--cursor] [--hold] [--latch]      (run from the working root, as dj_fields.py)
Prints, for each target (first address of a never-run component of bank 5, from roms/jp_rev_a/assets/reach_components_jp.csv), whether it ran and the key path of the first state in which it did;
writes OUTDIR/exec_ranges.csv (bytes executed beyond the replay of the route) and OUTDIR/paths.json."""
import sys, os, json, csv, itertools
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g
import blocks as B
import numpy as np
a = [x for x in sys.argv[1:] if not x.startswith('--')]
out = a[0]; os.makedirs(out, exist_ok=True)
cap = int(sys.argv[sys.argv.index('--cap') + 1]) if '--cap' in sys.argv else 6000
if '--cap' in sys.argv: a = [x for x in a if x != str(cap)]
COARSE = '--coarse' in sys.argv      # state key = (mode, state, $D8C8, $D8F3, $D8FA, $D985) only: fewer states, so the search gets further for the same cap
CURSOR = '--cursor' in sys.argv      # README 16.21: also key the states on the performance-screen cursor $D8B3 and the level $D8B7 (the first search keyed on neither, so a chord pressed with the cursor on item 4 was never tried)
route = json.load(open(a[1] if len(a) > 1 else 'unlock_runs/dj_route.json'))
COMP = os.environ.get('REACH_CSV', os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), 'roms', 'jp_rev_a', 'assets', 'reach_components_jp.csv'))   # the targets of README 16.19 are the OPEN / EDGE bank-5 rows of the file BEFORE the 16.19 witnesses were added (git: the version of commit 991fc4e)
targets = [(r['first_addr'], int(r['bytes'])) for r in csv.DictReader(open(COMP)) if r['bank'] == '05' and r['verdict'] in ('OPEN', 'EDGE')]
EX0 = np.zeros(len(g.cov_exec()), bool)
C = lib.Corpus(route['corpus']); g.set_organic(1); C.replay(route['entry'])
for k in route['shoot']: g.keys(k); g.run(1)
g.keys(0); g.run(route['after_shoot_idle'])
LATCH = '--latch' in sys.argv         # README 16.21: A (or B) can be KEPT held between key presses (the SOUND II grid of 05:6A82 is edited only while A stays held: 05:6A92-6A96 leaves the grid when A is released); the held key is part of the state
def tap(k, hold=4, wait=30, latch=0):
    if isinstance(k, tuple): g.keys(k[0]); g.run(10); k = k[0] | k[1]          # --hold: the first key is held for 10 frames, then the direction is added
    g.keys(latch | k); g.run(hold); g.keys(latch); g.run(wait)
SING = [(g.RIGHT, 'Right'), (g.LEFT, 'Left'), (g.UP, 'Up'), (g.DOWN, 'Down'), (g.A, 'A'), (g.B, 'B'), (g.SELECT, 'Select'), (g.START, 'Start')]
KEYS = list(SING)
HOLD = '--hold' in sys.argv and not LATCH           # README 16.21: instead of the simultaneous two-key chords, the direction is pressed while A (or B) is ALREADY held (the steppers 05:4960 / 48EA read the held A in $FFA1 and the new direction in $FFA3)
if LATCH:
    KEYS += [(('latch', g.A), 'A kept held'), (('latch', g.B), 'B kept held'), (('latch', 0), 'release')]
elif HOLD:
    for k1, n1 in ((g.A, 'A'), (g.B, 'B')):
        for k2, n2 in SING[:4]: KEYS.append(((k1, k2), n1 + ' held, then ' + n2))
else:
    for (k1, n1), (k2, n2) in itertools.combinations(SING, 2):
        if {n1, n2} in ({'Right', 'Left'}, {'Up', 'Down'}): continue
        KEYS.append((k1 | k2, n1 + '+' + n2))
ex = g.cov_exec()
LAT = [0]                              # the key kept held by the node being expanded (--latch)
def st():
    m, s = lib.cur()
    return (m, s, LAT[0]) + tuple(g.peek(x) for x in ((0xD8C8, 0xD8F3, 0xD8FA, 0xD985) if COARSE else (0xD8C5, 0xD8C8, 0xD8CC, 0xD8F3, 0xD8F6, 0xD8FA, 0xD8FD, 0xD985)) + ((0xD8B3, 0xD8B7) if CURSOR else ()))
def ran(t): b, ad = t.split(':'); return bool(g.cov_exec()[B.flat(int(b, 16), int(ad, 16))] > 0)
base = {t: ran(t) for t, _ in targets}
FIRST = {}
root = st(); seen = {root: ()}; frontier = [((), g.snapshot(), 0)]; depth = 0
print('root state %02X:%02X' % root[:2], '; %d keys; targets %d' % (len(KEYS), len(targets)), flush=True)
while frontier and len(seen) < cap:
    nxt = []
    for path, snap, lat in frontier:
        for k, n in KEYS:
            g.restore(snap)
            if isinstance(k, tuple) and k[0] == 'latch': newlat = k[1]; tap(0, latch=newlat)
            else: newlat = lat; tap(k, latch=lat)
            LAT[0] = newlat; kk = st()
            for t, _ in targets:
                if t not in FIRST and not base[t] and ran(t): FIRST[t] = path + (n,)
            if kk in seen or kk[0] not in (0x1F, 0x20): continue
            seen[kk] = path + (n,); nxt.append((path + (n,), g.snapshot(), newlat))
            if len(seen) >= cap: break
        if len(seen) >= cap: break
    frontier = nxt; depth += 1
    print('depth %d: %d states, frontier %d' % (depth, len(seen), len(frontier)), flush=True)
print('states pressed: %d (depth %d)%s' % (len(seen), depth, ' CAP' if len(seen) >= cap else ''))
import collections
print('(mode,state) of the states:', sorted(collections.Counter('%02X:%02X' % k[:2] for k in seen).items()))
for t, n in targets:
    print('%-8s %3d B  %s' % (t, n, ('RAN after ' + ' '.join(FIRST[t])) if t in FIRST else ('already ran before' if base[t] else 'not reached')))
lib.dump_exec_ranges(out + '/exec_ranges.csv', EX0)
json.dump({t: list(p) for t, p in FIRST.items()}, open(out + '/paths.json', 'w'), indent=1)
