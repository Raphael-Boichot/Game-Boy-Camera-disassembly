#!/usr/bin/env python3
"""Replay every corpus entry's own actions (deterministic) with the v4 core to regenerate full coverage incl. call-site logs.
Usage: replay_corpus.py STATE OUT [--rom ROM]"""
import sys as _s, os as _o
_s.path.insert(0, _o.path.join(_o.path.dirname(_o.path.abspath(__file__)), '..', 'src'))
import paths
import sys, os, json, glob, time, zlib, argparse
import numpy as np
import gbcov5 as g
ap = argparse.ArgumentParser(); ap.add_argument('state'); ap.add_argument('out'); ap.add_argument('--rom', default=paths.ROM)
a = ap.parse_args(); os.makedirs(a.out, exist_ok=True)
g.load_rom(a.rom)
def flat(b, ad): return ad if b == 0 and ad < 0x4000 else b * 0x4000 + (ad - 0x4000)
KNOWN = np.zeros(g.ROMSZ, np.uint8); t = json.load(open(paths.TRACE))
for k, n in t['code'].items():
    if n > 0: b, ad = k.split(':'); KNOWN[flat(int(b, 16), int(ad, 16))] = 1
g.set_known(KNOWN)
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
nchild = [0] * len(entries)
for e in entries:
    if e.get('parent', -1) >= 0: nchild[e['parent']] += 1
cache = {}; left = list(nchild); t0 = time.time(); wild = 0
for i, e in enumerate(entries):
    tainted = bool(e.get('tainted', False))
    if 'spec' in e:
        sp = e['spec']; g.set_organic(1); g.reset(SAVES[sp['sav']]); g.L.gb_attach_printer(sp['printer']); g.keys(sp['combo']); g.run(250); g.keys(0); g.run(sp['free'])
    else:
        p = e['parent']; g.restore(zlib.decompress(cache[p])); g.set_organic(not tainted)
        for x in e['actions']:
            apply_action(x)
            if g.wild(): wild += 1; break
        left[p] -= 1
        if left[p] <= 0: cache.pop(p, None)
    if nchild[i] > 0: cache[i] = zlib.compress(g.snapshot(), 1)
    if i % 1000 == 0: print('entry %d/%d  exec %d data %d  cache %d  wild %d  %.0fs' % (i, len(entries), g.L.gb_cnt_exec(), g.L.gb_cnt_dread(), len(cache), wild, time.time() - t0), flush=True)
g.cov_save(os.path.join(a.out, 'cov.npz')); open(os.path.join(a.out, 'corpus.jsonl'), 'w').write('')
json.dump(dict(iters=0, frames=0, secs=int(time.time() - t0), note='replay of %s' % a.state, wild=wild), open(os.path.join(a.out, 'stats.json'), 'w'))
print('saved', a.out, 'exec', g.L.gb_cnt_exec(), 'data', g.L.gb_cnt_dread(), flush=True)
