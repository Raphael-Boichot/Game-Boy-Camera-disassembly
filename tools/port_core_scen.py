#!/usr/bin/env python3
"""Targeted scenarios in the project's core (coverage/src/gbcov.c) for the international and Gold ROMs, joypad only (no RAM poke): the international
counterparts of the Japanese tcrf_check/tools/dj_fields.py and the D.J. score print of bgb_dj_print.py.  The routes were found in the core on the
international ROM (lib.play key probes from the boot; written here so that they are not rediscovered):
  main menu  A at the title -> 00:01; Down, A -> Space Fever II (07:01); A -> first wave (07:02); Right held 24 frames with A pulsed every 4 frames from frame 6
             shoots the D.J. ship -> mode $1F (1F:01); A, A, A (source, song, performer menus) -> 1F:05 performance; Select -> SOUND I page (1F:09); Select again -> SOUND II (1F:0A), NOISE (1F:0B).
  print      on a page: Start held 8 frames, Start+A 4 frames, Start 4 frames (the score print; the core's printer is attached at boot).
Scenario dj: breadth-first search over single taps (Right, Left, Up, Down, A, Select) from the SOUND I page, state key = (mode, state, the three field cursors
$D8C8 / $D8F3 / $D8FA, the wave length $D985), depth <= DEPTH; then the print from every page reached, and from every state whose $D985 differs.
usage: GBCAM_ROM=ROM port_core_scen.py OUT.npz [SAV] [--depth N]     OUT.npz: 'ex' = every byte the core executed in this run (union; port_never_run.py reads it)
PYTHONPATH must hold coverage/src and tcrf_check/tools."""
import sys, os, time
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, os.path.join(os.path.dirname(HERE), 'tcrf_check', 'tools')); sys.path.insert(0, os.path.join(os.path.dirname(HERE), 'coverage', 'src'))
import lib; from lib import g
a = sys.argv[1:]
DEPTH = int(a[a.index('--depth') + 1]) if '--depth' in a else 14
if '--depth' in a: i = a.index('--depth'); del a[i:i + 2]
out = a[0]; sav = a[1] if len(a) > 1 else '/root/work/port/saves_unl/unl_CE10001819.sav'
lib._SAVCACHE['s'] = open(sav, 'rb').read()
def tap(k, hold=4, wait=30): g.keys(k); g.run(hold); g.keys(0); g.run(wait)
lib.boot(lib.SAV('s'), combo=0, printer=1, free=403)
lib.play('A w60 D A w60 A', wait=40)
for f in range(24): g.keys(g.RIGHT | (g.A if (f >= 6 and f % 4 < 2) else 0)); g.run(1)
g.keys(0); g.run(120)
print('after the shot %02X:%02X' % lib.cur(), flush=True)
for k in (g.A, g.A, g.A): tap(k, wait=60)                 # 1F:01 source, 1F:02 song, 1F:03 performer -> 1F:04 / 1F:05 performance
g.run(200); print('performance %02X:%02X' % lib.cur(), flush=True)
tap(g.SELECT, wait=120); print('page %02X:%02X' % lib.cur(), flush=True)
KEYS = [(g.RIGHT, 'R'), (g.LEFT, 'L'), (g.UP, 'U'), (g.DOWN, 'D'), (g.A, 'A'), (g.SELECT, 's')]
def key(): return (lib.cur(), g.peek(0xD8C8), g.peek(0xD8F3), g.peek(0xD8FA), g.peek(0xD985))
seen = {key(): ''}; frontier = [('', g.snapshot())]; prints = {}; t0 = time.time()
for depth in range(DEPTH):
    nxt = []
    for path, snap in frontier:
        for k, n in KEYS:
            g.restore(snap); tap(k); kk = key()
            if kk in seen or kk[0][0] != 0x1F or kk[0][1] not in (9, 10, 11): continue
            seen[kk] = path + n; nxt.append((path + n, g.snapshot()))
            pk = (kk[0], kk[4])
            if pk not in prints: prints[pk] = (path + n, g.snapshot())
    frontier = nxt
    print('depth %d: %d states, %d frontier, %.0fs' % (depth + 1, len(seen), len(frontier), time.time() - t0), flush=True)
    if not frontier: break
for (st, wl), (path, snap) in sorted(prints.items()):
    g.restore(snap); g.keys(g.START); g.run(8); g.keys(g.START | g.A); g.run(4); g.keys(g.START); g.run(4); g.keys(0)
    ms = set()
    for i in range(3000): g.run(1); ms.add(lib.cur()[0])
    print('print from %02X:%02X wave length %d (keys %s): modes %s' % (st + (wl, path or '-', ' '.join('%02X' % m for m in sorted(ms)))), flush=True)
np.savez_compressed(out, ex=(np.array(g.cov_exec(), copy=True) != 0).astype(np.uint8))
print('executed bytes', int((np.array(g.cov_exec()) != 0).sum()), '->', out)
