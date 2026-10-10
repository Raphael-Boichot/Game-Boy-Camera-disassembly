#!/usr/bin/env python3
"""Targeted variable sweep (forced-state, non-organic). Loads replayable snapshots from a state dir whose (D5CE) matches --mode,
pokes the cartesian product of the given variable values for N frames each, and writes coverage to OUT/cov.npz (+ empty corpus).
Usage: sweep_vars.py STATE OUT --mode 0x14 --vars 'D7EB=0,1,2;D7E3=0-32;D7E4=0-3' [--frames 40] [--states 12]"""
import sys as _s, os as _o
_s.path.insert(0, _o.path.join(_o.path.dirname(_o.path.abspath(__file__)), '..', 'src'))
import paths
import sys, os, json, glob, itertools, argparse, time
import numpy as np
import gbcov5 as g
ap = argparse.ArgumentParser(); ap.add_argument('state'); ap.add_argument('out')
ap.add_argument('--mode', default='0x14'); ap.add_argument('--vars', required=True); ap.add_argument('--frames', type=int, default=40)
ap.add_argument('--states', type=int, default=12); ap.add_argument('--rom', default=paths.ROM)
a = ap.parse_args(); os.makedirs(a.out, exist_ok=True)
g.load_rom(a.rom)
def flat(b, ad): return ad if b == 0 and ad < 0x4000 else b * 0x4000 + (ad - 0x4000)
KNOWN = np.zeros(g.ROMSZ, np.uint8); t = json.load(open(paths.TRACE))
for k, n in t['code'].items():
    if n > 0: b, ad = k.split(':'); KNOWN[flat(int(b, 16), int(ad, 16))] = 1
g.set_known(KNOWN); g.set_organic(0)
entries = [json.loads(l) for l in open(os.path.join(a.state, 'corpus.jsonl')) if l.strip()]
SAVES = {os.path.basename(p)[:-4]: open(p, 'rb').read() for p in glob.glob(os.path.join(paths.SAVES, '*.sav'))}
SAVES['_zero'] = bytes(0x20000); SAVES['_ff'] = b'\xff' * 0x20000
def apply_action(x):
    if x[0] == 'P':
        _, pf, wait, pairs = x
        for _ in range(pf):
            for ad, v in pairs: g.poke(ad, v)
            g.run(1)
        g.run(wait)
    else:
        k, hold, wait = x; g.keys(k); g.run(hold); g.keys(0); g.run(wait)
cache = {}
def snap(i):
    if i in cache: return cache[i]
    e = entries[i]
    if 'spec' in e:
        sp = e['spec']; g.reset(SAVES[sp['sav']]); g.L.gb_attach_printer(sp['printer']); g.keys(sp['combo']); g.run(250); g.keys(0); g.run(sp['free'])
    else:
        g.restore(snap(e['parent']))
        for x in e['actions']: apply_action(x)
    s = g.snapshot(); cache[i] = s; return s
mode = int(a.mode, 0)
cand = [i for i, e in enumerate(entries) if e['sig'][0] == mode and not e.get('tainted')]
step = max(1, len(cand) // a.states); chosen = cand[::step][:a.states]
print('mode %02X: %d candidate states, using %d' % (mode, len(cand), len(chosen)), flush=True)
spec = []
for part in a.vars.split(';'):
    ad, vals = part.split('='); vs = []
    for v in vals.split(','):
        if '-' in v: lo, hi = v.split('-'); vs += list(range(int(lo, 0), int(hi, 0) + 1))
        else: vs.append(int(v, 0))
    spec.append((int(ad, 16), vs))
combos = list(itertools.product(*[vs for _, vs in spec])); print('combos per state', len(combos), flush=True)
c0 = (g.L.gb_cnt_exec(), g.L.gb_cnt_dread()); t0 = time.time(); wild = 0
for n, i in enumerate(chosen):
    s = snap(i)
    for combo in combos:
        g.restore(s); g.set_organic(0)
        for f in range(a.frames):
            for (ad, _), v in zip(spec, combo): g.poke(ad, v)
            g.run(1)
            if g.wild(): wild += 1; break
    print('state %d (entry %d, sig %s): exec bytes now %d, data %d, wild %d, %.0fs' % (n, i, entries[i]['sig'], g.L.gb_cnt_exec(), g.L.gb_cnt_dread(), wild, time.time() - t0), flush=True)
g.cov_save(os.path.join(a.out, 'cov.npz'))
open(os.path.join(a.out, 'corpus.jsonl'), 'w').write('')
json.dump(dict(iters=0, frames=0, secs=0, note='sweep %s mode %s' % (a.vars, a.mode)), open(os.path.join(a.out, 'stats.json'), 'w'))
print('saved', a.out)
