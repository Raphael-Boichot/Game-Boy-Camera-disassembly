#!/usr/bin/env python3
"""Hello Kitty ROM: the screen on which each ROM byte is first read as data (L3 context for the data names, 2026-11-12).

  tools/kitty_read_screens.py ROM OUT.npz [--minutes 30] [--seed 1] [--printer] [--kitts 999999]
  tools/kitty_read_screens.py --merge OUT.npz IN1.npz IN2.npz ...

The novelty search of tools/kitty_coverage.py (same start: a save formatted in 600 frames with the Kitt counter raised, the same
input steps), played in chunks of at most 8 frames: after each chunk, every ROM byte read as data for the first time gets the
current (mode hFF8D, state hFF8E). Mode $1E is the fade between screens: a byte first read there also gets the first (mode, state)
outside $1E that follows (`next`), so a screen's assets are named after the screen they load for.
OUT.npz: first (uint16 per ROM byte, mode << 8 | state, $FFFF = never read), next (the same after a fade), dread, reader.
--merge keeps, per byte, the value of the first file that has one (give the files in a fixed order).
The core is not the judge for pictures (CLAUDE.md); this only says when a byte is read.
"""
import sys, os, time, random, argparse
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, os.path.join(HERE, '..', 'coverage', 'src'))
import numpy as np
if sys.argv[1] == '--merge':
    out = sys.argv[2]; F = [np.load(f) for f in sys.argv[3:]]
    fi = F[0]['first'].copy(); nx = F[0]['next'].copy()
    for z in F[1:]:
        m = (fi == 0xFFFF) & (z['first'] != 0xFFFF); fi[m] = z['first'][m]; nx[m] = z['next'][m]
    np.savez_compressed(out, first=fi, next=nx); print('merged: %d bytes with a first screen' % int((fi != 0xFFFF).sum())); sys.exit()
import gbcov as G
ap = argparse.ArgumentParser()
ap.add_argument('rom'); ap.add_argument('out'); ap.add_argument('--minutes', type=float, default=30); ap.add_argument('--seed', type=int, default=1)
ap.add_argument('--kitts', type=int, default=999999); ap.add_argument('--printer', action='store_true')
a = ap.parse_args(); rnd = random.Random(a.seed)
G.load_rom(a.rom); G.reset(bytes(0x20000)); G.run(600); sav = bytearray(bytes(G.sram()))
d = '%06d' % a.kitts; sav[0x100A:0x100D] = bytes([int(d[4:6], 16), int(d[2:4], 16), int(d[0:2], 16)])
G.load_rom(a.rom); G.reset(bytes(sav))
if a.printer: G.L.gb_attach_printer(1)
N = 0x100000; first = np.full(N, 0xFFFF, np.uint16); nxt = np.full(N, 0xFFFF, np.uint16); seen = np.zeros(N, bool); pend = []
def ms(): return G.peek(0xFF8D) << 8 | G.peek(0xFF8E)
def look():
    global pend
    m = ms(); dr = G.cov_dread() > 0; new = np.flatnonzero(dr & ~seen)
    if pend and (m >> 8) != 0x1E:
        for p in pend: nxt[p] = m
        pend = []
    if len(new):
        seen[new] = True; first[new] = m
        if (m >> 8) == 0x1E: pend.append(new)
        else: nxt[new] = m
def play(k, n):
    G.keys(k)
    while n > 0:
        s = min(8, n); G.run(s); n -= s; look()
KEYS = [1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80]
def score(): return int((G.cov_exec() > 0).sum()) + int((G.cov_dread() > 0).sum())
play(0, 250)
corpus = [G.snapshot()]; best = score(); t0 = time.time(); last = t0; steps = 0
def dump():
    np.savez_compressed(a.out, first=first, next=nxt, dread=G.cov_dread().copy(), reader=G.cov_reader().copy())
    print('%5.1f min  steps %d  corpus %d  read %d' % ((time.time() - t0) / 60, steps, len(corpus), int(seen.sum())), flush=True)
while time.time() - t0 < a.minutes * 60:
    i = rnd.randrange(len(corpus)) if rnd.random() < 0.8 else len(corpus) - 1 - rnd.randrange(min(5, len(corpus)))
    G.restore(corpus[i])
    for _ in range(rnd.randint(1, 6)):
        r = rnd.random()
        if r < 0.6: k = rnd.choice(KEYS); hold = rnd.randint(2, 8); wait = rnd.randint(10, 80)
        elif r < 0.8: k = rnd.choice(KEYS); hold = rnd.randint(20, 120); wait = rnd.randint(5, 40)
        else: k = rnd.choice(KEYS) | rnd.choice(KEYS); hold = rnd.randint(2, 30); wait = rnd.randint(10, 60)
        play(k, hold); play(0, wait)
    s = score(); steps += 1
    if s > best: best = s; corpus.append(G.snapshot())
    if time.time() - last > 180: dump(); last = time.time()
dump()
