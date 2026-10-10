#!/usr/bin/env python3
"""Long organic boot runs: every save x boot combo, run for many frames with only the initial combo held 250 frames (then no input, or a slow
button tap schedule).  Reaches time-gated code (the hidden factory diagnostic needs ~3900 frames to finish its sensor measurements, idle timers...).
Usage: long_runs.py OUT [--frames 9000] [--combos FD,FF,0,...]   -> OUT/cov.npz (mergeable with merge_states.py), OUT/log.txt"""
import sys as _s, os as _o
_s.path.insert(0, _o.path.join(_o.path.dirname(_o.path.abspath(__file__)), '..', 'src'))
import paths
import sys, os, json, glob, time, argparse
import numpy as np
import gbcov as g
ap = argparse.ArgumentParser(); ap.add_argument('out'); ap.add_argument('--frames', type=int, default=9000)
ap.add_argument('--combos', default='FD,FF,0,A,START,SELECT,A+B,SELECT+START,UP,DOWN,LEFT,RIGHT')
ap.add_argument('--rom', default=paths.ROM); ap.add_argument('--taps', type=int, default=1)
a = ap.parse_args(); os.makedirs(a.out, exist_ok=True)
LOG = open(os.path.join(a.out, 'log.txt'), 'a')
def log(*x):
    s = time.strftime('%F %T ') + ' '.join(str(v) for v in x); print(s, flush=True); LOG.write(s + '\n'); LOG.flush()
g.load_rom(a.rom)
def flat(b, ad): return ad if b == 0 and ad < 0x4000 else b * 0x4000 + (ad - 0x4000)
KNOWN = np.zeros(g.ROMSZ, np.uint8); t = json.load(open(paths.TRACE))
for k, n in t['code'].items():
    if n > 0: b, ad = k.split(':'); KNOWN[flat(int(b, 16), int(ad, 16))] = 1
g.set_known(KNOWN)
SAVES = {os.path.basename(p)[:-4]: open(p, 'rb').read() for p in sorted(glob.glob(os.path.join(paths.SAVES, '*.sav')))}
SAVES['_zero'] = bytes(0x20000); SAVES['_ff'] = b'\xff' * 0x20000
def combo(n):
    if n == 'FD': return g.A | g.SELECT | g.START | g.UP | g.DOWN | g.LEFT | g.RIGHT
    if n == 'FF': return g.A | g.B | g.SELECT | g.START | g.UP | g.DOWN | g.LEFT | g.RIGHT
    v = 0
    for p in n.split('+'): v |= 0 if p == '0' else getattr(g, p)
    return v
g.set_organic(1)
t0 = time.time(); k = 0
for sav, data in SAVES.items():
    for cn in a.combos.split(','):
        g.reset(data); g.L.gb_attach_printer(0); g.keys(combo(cn)); g.run(250); g.keys(0)
        done = 250
        while done < a.frames:
            g.run(500); done += 500
            if a.taps and done % 3000 == 0: g.keys(g.A); g.run(6); g.keys(0); done += 6      # one A tap every ~3000 frames (dismiss a prompt)
        k += 1
        if k % 10 == 0: log('run', k, sav, cn, 'exec', g.L.gb_cnt_exec(), 'data', g.L.gb_cnt_dread(), '%.0fs' % (time.time() - t0))
g.cov_save(os.path.join(a.out, 'cov.tmp.npz')); os.replace(os.path.join(a.out, 'cov.tmp.npz'), os.path.join(a.out, 'cov.npz'))
open(os.path.join(a.out, 'corpus.jsonl'), 'a').close(); json.dump(dict(iters=0, frames=0, secs=int(time.time() - t0), note='long_runs', runs=k), open(os.path.join(a.out, 'stats.json'), 'w'))
log('done', k, 'runs; exec', g.L.gb_cnt_exec(), 'data', g.L.gb_cnt_dread())
