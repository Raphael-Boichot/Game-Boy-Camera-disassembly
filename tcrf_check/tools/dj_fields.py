#!/usr/bin/env python3
"""Press every key at every field of the three music-editor pages (SOUND I 1F:09, SOUND II 1F:0A, NOISE 1F:0B) in my core, joypad only (no RAM poke),
and dump the bytes executed beyond the replay of the route (README 16.15).
usage: dj_fields.py OUTDIR [ROUTE.json]      (run from the working root: unlock_runs/f1_organic/corpus.jsonl and unlock_runs/dj_route.json from dj_route.py;
                                              a copy of the route is tcrf_check/assets/bgb_retrace/dj_route.json)
Route: corpus entry 197 (save _ff) = Space Fever II, Right held and A pulsed shoot the D.J. ship -> 1F:05, Select -> 1F:09.  From there a breadth-first search over single
key taps (Right, Left, Up, Down, A, Select; B and Start leave the pages or print) with the page state and the three field cursors ($D8C8 SOUND I, $D8F3 SOUND II,
$D8FA NOISE) as the state key, so every (page, field, key) combination is pressed once.
Findings printed at the end: the key path to every field-handler entry that no earlier run reached (05:6670 = SOUND I field 7: Up, Up, then Right x7 from the note grid;
05:71C3 = NOISE field 3: Select, Select, Up, Up, Right x3), and the executed ranges (OUTDIR/exec_ranges.csv)."""
import sys, os, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g
import blocks as B
out = sys.argv[1]; os.makedirs(out, exist_ok=True)
route = json.load(open(sys.argv[2] if len(sys.argv) > 2 else 'unlock_runs/dj_route.json'))
import numpy as np
EX0 = np.zeros(len(g.cov_exec()), bool)
C = lib.Corpus(route['corpus']); g.set_organic(1); C.replay(route['entry'])
for k in route['shoot']: g.keys(k); g.run(1)
g.keys(0); g.run(route['after_shoot_idle'])
def tap(k, hold=4, wait=30): g.keys(k); g.run(hold); g.keys(0); g.run(wait)
KEYS = [(g.RIGHT, 'Right'), (g.LEFT, 'Left'), (g.UP, 'Up'), (g.DOWN, 'Down'), (g.A, 'A'), (g.SELECT, 'Select')]
ex = g.cov_exec()
def key(): return (lib.cur(), g.peek(0xD8C8), g.peek(0xD8F3), g.peek(0xD8FA))
tap(g.SELECT); print('start page', '%02X:%02X' % lib.cur())
FIRST = {}                                            # entry address -> key path from the SOUND I page
WATCH = {'05:6670 SOUND I field 7': (5, 0x6670), '05:71C3 NOISE field 3': (5, 0x71C3)}
base = {n: bool(ex[B.flat(*a)] > 0) for n, a in WATCH.items()}
seen = {key(): ()}; frontier = [((), g.snapshot())]
for depth in range(24):
    nxt = []
    for path, snap in frontier:
        for k, n in KEYS:
            g.restore(snap); tap(k); kk = key()
            for tn, a in WATCH.items():
                if tn not in FIRST and ex[B.flat(*a)] > 0: FIRST[tn] = path + (n,)
            if kk in seen or kk[0][0] != 0x1F or kk[0][1] not in (9, 10, 11): continue
            seen[kk] = path + (n,); nxt.append((path + (n,), g.snapshot()))
    frontier = nxt
    if not frontier: break
print('states pressed: %d (depth %d)' % (len(seen), depth + 1))
for tn in WATCH: print('%-26s %s' % (tn, 'first executed after the keys ' + ' '.join(FIRST[tn]) if tn in FIRST else 'NOT reached'))
lib.dump_exec_ranges(out + '/exec_ranges.csv', EX0)
