#!/usr/bin/env python3
"""Boot damaged copies of the real saves (flipped bytes in the settings / vector / calibration blocks and their echoes, in photo-slot tails, and random bytes)
to exercise the SRAM self-repair paths (README section 3.6).  The only input is the SRAM image and the joypad (no RAM pokes) -> counted as organic.
Usage: damaged_saves.py OUT [--n 300] [--taps 60]  -> OUT/cov.npz, OUT/log.txt, OUT/variants.jsonl (every variant is reproducible: base save, list of (offset, xor))"""
import sys as _s, os as _o
_s.path.insert(0, _o.path.join(_o.path.dirname(_o.path.abspath(__file__)), '..', 'src'))
import paths
import sys, os, json, glob, time, argparse, random
import numpy as np
import gbcov as g
ap = argparse.ArgumentParser(); ap.add_argument('out'); ap.add_argument('--n', type=int, default=300); ap.add_argument('--taps', type=int, default=60)
ap.add_argument('--rom', default=paths.ROM); ap.add_argument('--seed', type=int, default=5)
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
SAVES = {os.path.basename(p)[:-4]: open(p, 'rb').read() for p in sorted(glob.glob(os.path.join(paths.SAVES, '*.sav')))}
# damage regions (SRAM flat offsets, README section 3): (name, start, length)
REG = [('settings', 0x1000, 0xD9), ('settings_echo', 0x10D9, 0xD9), ('vector', 0x11B2, 37), ('vector_echo', 0x11D7, 37), ('calib', 0x4FF2, 14), ('calib_echo', 0x11FF2, 14),
       ('owner_magic', 0x4FCA, 2), ('owner_magic2', 0x4FE3, 2), ('gameface_tail', 0x1FF0, 12)]
for s in range(30): REG.append(('slot%02d_tail' % (s + 1), 0x2000 + s * 0x1000 + 0xFE0, 32))
for s in range(30): REG.append(('slot%02d_mid' % (s + 1), 0x2000 + s * 0x1000 + 0xE00, 0x1E0))
def variant(i):
    base = rng.choice(list(SAVES)); d = bytearray(SAVES[base]); edits = []
    k = rng.choice([1, 1, 1, 2, 2, 3, 5])
    for _ in range(k):
        name, st, ln = rng.choice(REG); off = st + rng.randrange(ln); x = rng.choice([1, 0x80, 0xFF, 0x55, rng.randrange(1, 256)])
        d[off] ^= x; edits.append((name, off, x))
    return base, bytes(d), edits
g.set_organic(1); VAR = open(os.path.join(a.out, 'variants.jsonl'), 'a'); t0 = time.time()
KEYS = [g.A, g.B, g.START, g.SELECT, g.UP, g.DOWN, g.LEFT, g.RIGHT]
for i in range(a.n):
    base, data, edits = variant(i)
    VAR.write(json.dumps(dict(i=i, base=base, edits=edits)) + '\n')
    g.reset(data); g.L.gb_attach_printer(0); g.run(300)
    for _ in range(a.taps):
        g.keys(rng.choice(KEYS)); g.run(4); g.keys(0); g.run(rng.choice([10, 30, 60]))
    if i % 25 == 24: log('variant', i + 1, 'exec', g.L.gb_cnt_exec(), 'data', g.L.gb_cnt_dread(), '%.0fs' % (time.time() - t0))
g.cov_save(os.path.join(a.out, 'cov.tmp.npz')); os.replace(os.path.join(a.out, 'cov.tmp.npz'), os.path.join(a.out, 'cov.npz'))
open(os.path.join(a.out, 'corpus.jsonl'), 'a').close(); json.dump(dict(iters=a.n, note='damaged_saves', secs=int(time.time() - t0)), open(os.path.join(a.out, 'stats.json'), 'w'))
log('done', a.n, 'variants; exec', g.L.gb_cnt_exec())
