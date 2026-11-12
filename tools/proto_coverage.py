#!/usr/bin/env python3
"""Coverage run of the early prototype (image as dumped) in the project's core (coverage/src/gbcov.c): novelty search over joypad inputs.

  tools/proto_coverage.py PROTO.gb OUT_DIR [--minutes 20] [--seed 1] [--save SAVE.sav]

The core never reads the cartridge header (its Pocket Camera mapper is built in), so it runs the image as dumped (md5 19b50a5f...,
owner's rule 2026-11-08: the BGB copy is for BGB only). Starts from SAVE (default: 128 KiB of $00). A corpus of emulator snapshots
grows whenever a run executes or reads ROM bytes never seen before; each step restores a random entry and plays 1-6 random inputs
(single taps of the 8 keys, holds, chords of two keys) with waits. Writes to OUT_DIR, every 3 minutes and at the end:
  cov.npz      exec (1 per ROM byte executed as an instruction byte), dread (1 per ROM byte read as data),
               reader (bank << 16 | pc of the first instruction that read each data byte)
  modes.csv    every GAME_SEQ value ($C0A0, the variable the main loop dispatches on at 00:01FE) seen after an input, with the
               number of frames and the exact key history (hex, from a cold boot) that first reached it: replayable as it is
               (tools/proto_bgb_replay.py). The Kitty runner records a corpus index instead, which names another entry whenever
               the step that reached the value added nothing new to the corpus.
  corpus.jsonl the input history of each corpus entry (frames of key bytes from a cold boot, in the core's mask: direction keys
               in the low nibble, buttons high; a BGB demo byte has the nibbles swapped)
Saves are never committed (they hold photos, CLAUDE.md); the owner's prototype save comes from the session attachments.
The core is not the judge for pictures (CLAUDE.md): screenshots come from BGB with the BGB copy.
"""
import sys, os, json, time, random, argparse, csv, hashlib
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, os.path.join(HERE, '..', 'coverage', 'src'))
import numpy as np, gbcov as G
ap = argparse.ArgumentParser()
ap.add_argument('rom'); ap.add_argument('out'); ap.add_argument('--minutes', type=float, default=20); ap.add_argument('--seed', type=int, default=1)
ap.add_argument('--save', default=None)
a = ap.parse_args(); os.makedirs(a.out, exist_ok=True); rnd = random.Random(a.seed)
if hashlib.md5(open(a.rom, 'rb').read()).hexdigest() != '19b50a5f67ef4f0d015e7d813370756e': sys.exit('proto_coverage: expected the prototype as dumped (md5 19b50a5f...)')
sav = bytes(open(a.save, 'rb').read()) if a.save else bytes(0x20000)
G.load_rom(a.rom); G.reset(sav)
KEYS = [1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80]
GAME_SEQ = 0xC0A0
def score(): return int((G.cov_exec() > 0).sum()) + int((G.cov_dread() > 0).sum())
G.run(250)
corpus = [(G.snapshot(), [0] * 250)]; modes = {}
def note_mode(h):
    k = G.peek(GAME_SEQ)
    if k not in modes: modes[k] = list(h)
note_mode([0] * 250)
best = score(); t0 = time.time(); last_dump = t0; steps = 0
def dump():
    ex = G.cov_exec().copy(); dr = G.cov_dread().copy(); rd = G.cov_reader().copy()
    np.savez_compressed(os.path.join(a.out, 'cov.npz'), ex=ex, dr=dr, rdr=rd)
    with open(os.path.join(a.out, 'modes.csv'), 'w', newline='') as f:
        w = csv.writer(f, lineterminator='\n'); w.writerow(['game_seq', 'frames', 'keys'])
        for m, h in sorted(modes.items()): w.writerow(['%02X' % m, len(h), ''.join('%02x' % k for k in h)])
    with open(os.path.join(a.out, 'corpus.jsonl'), 'w') as f:
        for i, (_, h) in enumerate(corpus): f.write(json.dumps({'i': i, 'frames': len(h), 'keys': ''.join('%02x' % k for k in h)}) + '\n')
    banks = sorted(set(int(x) >> 14 for x in np.nonzero(ex)[0]))
    print('%5.1f min  steps %d  corpus %d  exec %d  dread %d  game_seq %d  exec banks %s' % ((time.time() - t0) / 60, steps, len(corpus),
          int((ex > 0).sum()), int((dr > 0).sum()), len(modes), ' '.join('%02X' % b for b in banks)), flush=True)
while time.time() - t0 < a.minutes * 60:
    i = rnd.randrange(len(corpus)) if rnd.random() < 0.8 else len(corpus) - 1 - rnd.randrange(min(5, len(corpus)))
    snap, hist = corpus[i]; G.restore(snap); h = list(hist)
    for _ in range(rnd.randint(1, 6)):
        r = rnd.random()
        if r < 0.6: k = rnd.choice(KEYS); hold = rnd.randint(2, 8); wait = rnd.randint(10, 80)
        elif r < 0.8: k = rnd.choice(KEYS); hold = rnd.randint(20, 120); wait = rnd.randint(5, 40)
        else: k = rnd.choice(KEYS) | rnd.choice(KEYS); hold = rnd.randint(2, 30); wait = rnd.randint(10, 60)
        G.keys(k); G.run(hold); G.keys(0); G.run(wait); h += [k] * hold + [0] * wait; note_mode(h)
    s = score(); steps += 1
    if s > best: best = s; corpus.append((G.snapshot(), h))
    if time.time() - last_dump > 180: dump(); last_dump = time.time()
dump()
