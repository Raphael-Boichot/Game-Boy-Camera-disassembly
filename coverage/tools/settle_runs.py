#!/usr/bin/env python3
"""Streaming replay of a corpus + *settle* runs at selected entries: from each snapshot run idle for N frames (and with one Start/A/B/Select tap after N/3 frames).
Reaches time-gated code (idle timers, long sensor measurements). Untainted lineages stay organic. Coverage -> OUT/cov.npz.
Usage: settle_runs.py STATE OUT [--per-sig 3] [--settle 4000] [--maxsec N]"""
import sys as _s, os as _o
_s.path.insert(0, _o.path.join(_o.path.dirname(_o.path.abspath(__file__)), '..', 'src'))
import paths
import sys, os, json, glob, time, zlib, argparse, random
import numpy as np
import gbcov as g
ap = argparse.ArgumentParser(); ap.add_argument('state'); ap.add_argument('out')
ap.add_argument('--per-sig', type=int, default=3); ap.add_argument('--maxsec', type=int, default=10 ** 9)
ap.add_argument('--settle', type=int, default=4000); ap.add_argument('--variants', default='idle,start,a,b,select')
ap.add_argument('--rom', default=paths.ROM); ap.add_argument('--seed', type=int, default=11)
a = ap.parse_args(); os.makedirs(a.out, exist_ok=True); rng = random.Random(a.seed)
LOG = open(os.path.join(a.out, 'log.txt'), 'a')
def log(*x):
    s = time.strftime('%F %T ') + ' '.join(str(v) for v in x); print(s, flush=True); LOG.write(s + '\n'); LOG.flush()
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
bysig = {}
for i, e in enumerate(entries):
    if not e.get('tainted'): bysig.setdefault(tuple(e['sig']), []).append(i)
chosen = set()
for s_, ids in bysig.items():
    k = min(a.per_sig, len(ids)); step = max(1, len(ids) // k); chosen |= set(ids[::step][:k])
log('entries', len(entries), 'sweep at', len(chosen))
nchild = [0] * len(entries)
for e in entries:
    if e.get('parent', -1) >= 0: nchild[e['parent']] += 1
cache = {}; left = list(nchild); t0 = time.time(); last_ck = time.time(); swept = 0
def values_for(v): return sorted(set([0, 1, 2, 3, 4, 5, 8, 0x10, 0x20, 0x80, 0xFF, (v + 1) & 255, (v - 1) & 255]) - {v})
def ckpt():
    g.cov_save(os.path.join(a.out, 'cov.tmp.npz')); os.replace(os.path.join(a.out, 'cov.tmp.npz'), os.path.join(a.out, 'cov.npz'))
    open(os.path.join(a.out, 'corpus.jsonl'), 'a').close(); json.dump(dict(iters=0, frames=0, secs=int(time.time() - t0), note='replay+settle_runs', swept=swept), open(os.path.join(a.out, 'stats.json'), 'w'))
for i, e in enumerate(entries):
    if time.time() - t0 > a.maxsec: break
    tainted = bool(e.get('tainted', False))
    if 'spec' in e:
        sp = e['spec']; g.set_organic(1); g.reset(SAVES[sp['sav']]); g.L.gb_attach_printer(sp['printer']); g.keys(sp['combo']); g.run(250); g.keys(0); g.run(sp['free'])
    else:
        p = e['parent']; g.restore(zlib.decompress(cache[p])); g.set_organic(not tainted)
        for x in e['actions']:
            apply_action(x)
            if g.wild(): break
        left[p] -= 1
        if left[p] <= 0: cache.pop(p, None)
    snapb = g.snapshot()
    if nchild[i] > 0: cache[i] = zlib.compress(snapb, 1)
    if i in chosen:
        for variant in a.variants.split(','):
            g.restore(snapb); g.set_organic(not tainted)
            if variant == 'idle': g.run(a.settle)
            else:
                g.run(a.settle // 3); g.keys({'start': g.START, 'a': g.A, 'b': g.B, 'select': g.SELECT}[variant]); g.run(6); g.keys(0); g.run(a.settle - a.settle // 3)
            if g.wild(): break
        swept += 1; log('settled entry %d sig %s  exec %d data %d  (%d/%d)  %.0fs' % (i, e['sig'], g.L.gb_cnt_exec(), g.L.gb_cnt_dread(), swept, len(chosen), time.time() - t0))
    if i % 2000 == 0: log('entry %d/%d exec %d data %d cache %d %.0fs' % (i, len(entries), g.L.gb_cnt_exec(), g.L.gb_cnt_dread(), len(cache), time.time() - t0))
    if time.time() - last_ck > 180: ckpt(); last_ck = time.time()
ckpt(); log('done; exec', g.L.gb_cnt_exec(), 'data', g.L.gb_cnt_dread())
