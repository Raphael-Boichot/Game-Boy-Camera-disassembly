#!/usr/bin/env python3
"""Goal-directed key search in my core: from the corpus entries that sit in the given modes, tap every key (breadth first) until a target address is executed.
usage: reach_bfs.py OUTDIR MODES TARGETS [--depth N] [--cap N] [--corpus FILE] [--wram A-B[,A-B]] [--keys Right,Left,Up,Down,A,B,Select,Start]   (a key may be a combination: Select+Down)
  MODES    comma list of mode numbers in hex ('16' or '14,15,16'); every distinct (mode, state) of the corpus in these modes is one start state
  TARGETS  comma list of BB:AAAA (bank:address) whose first execution is looked for
  --wram   WRAM ranges (hex, inclusive) hashed into the state key together with (mode, state); default D5D0-D5FF
Each tap = the key held 4 frames, then 30 frames of release.  A state is (mode, state, bytes of the WRAM ranges); it is expanded once.  Joypad only (organic), no RAM poke.
Prints, per target, the start entry and the key path; writes OUTDIR/exec_ranges.csv (everything executed by the search) and OUTDIR/reach_bfs.json (paths).
README 16.15 gives the paths found for the MAGIC menu."""
import sys, os, json, hashlib
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g
import blocks as B
import numpy as np
a = sys.argv[1:]
def opt(n, d):
    if n in a: i = a.index(n); v = a[i + 1]; del a[i:i + 2]; return v
    return d
depth = int(opt('--depth', '6')); cap = int(opt('--cap', '4000')); corpus = opt('--corpus', 'unlock_runs/f1_organic/corpus.jsonl')
wr = [tuple(int(x, 16) for x in r.split('-')) for r in opt('--wram', 'D5D0-D5FF').split(',')]
KN = opt('--keys', 'Right,Left,Up,Down,A,B,Select,Start').split(',')
out, modes, targets = a[0], [int(m, 16) for m in a[1].split(',')], a[2].split(',')
os.makedirs(out, exist_ok=True)
KEY = dict(Right=g.RIGHT, Left=g.LEFT, Up=g.UP, Down=g.DOWN, A=g.A, B=g.B, Select=g.SELECT, Start=g.START)
def kmask(n):
    m = 0
    for part in n.split('+'): m |= KEY[part]
    return m
EX0 = np.zeros(len(g.cov_exec()), bool); ex = g.cov_exec()
T = {t: B.flat(int(t.split(':')[0], 16), int(t.split(':')[1], 16)) for t in targets}
C = lib.Corpus(corpus); g.set_organic(1)
def tap(k, hold=4, wait=30): g.keys(k); g.run(hold); g.keys(0); g.run(wait)
def key():
    h = hashlib.md5()
    for lo, hi in wr: h.update(bytes(g.peek(x) for x in range(lo, hi + 1)))
    return (lib.cur(), h.hexdigest())
starts = {}
for i, e in C.E.items():
    if e['sig'][0] in modes and tuple(e['sig']) not in starts: starts[tuple(e['sig'])] = i
print('start states:', sorted('%02X:%02X' % s for s in starts), flush=True)
found = {}; seen = set(); nst = 0
for sig, i in sorted(starts.items()):
    C.replay(i)
    for t, f in T.items():
        if t not in found and ex[f] > 0: found[t] = ('replay of corpus entry %d' % i, [])
    seen.add(key()); frontier = [((), g.snapshot())]
    for d in range(depth):
        nxt = []
        for path, snap in frontier:
            for n in KN:
                g.restore(snap); tap(kmask(n)); kk = key(); p = path + (n,)
                for t, f in T.items():
                    if t not in found and ex[f] > 0: found[t] = ('corpus entry %d (%02X:%02X)' % (i, *sig), list(p)); print('FOUND', t, found[t], flush=True)
                if kk in seen or kk[0][0] not in modes: continue
                seen.add(kk); nst += 1
                if nst < cap: nxt.append((p, g.snapshot()))
        frontier = nxt
        if not frontier or len(found) == len(T): break
    if len(found) == len(T): break
print('states expanded: %d; found %d of %d targets' % (nst, len(found), len(T)))
for t in T: print('%-8s %s' % (t, found.get(t, 'not reached')))
json.dump(found, open(out + '/reach_bfs.json', 'w'), indent=1)
lib.dump_exec_ranges(out + '/exec_ranges.csv', EX0)
