#!/usr/bin/env python3
"""Coverage run of the Hello Kitty ROM in the project's core (coverage/src/gbcov.c): novelty search over joypad inputs.

  tools/kitty_coverage.py ROM OUT_DIR [--minutes 20] [--seed 1] [--save SAVE.sav] [--kitts 999999] [--printer]

Starts from SAVE (default: 128 KiB of $00; the game formats it) with the Kitt counter ($100A-$100C, 3 x 2 BCD digits, low
byte first) set to --kitts, so that the paid features are open. A corpus of emulator snapshots grows whenever a run executes
or reads ROM bytes never seen before; each step restores a random entry and plays a random input of 30-400 frames (single
taps of the 8 keys, holds, and chords of two keys). Writes to OUT_DIR, every few minutes and at the end:
  cov.npz      exec (1 per ROM byte executed as an instruction byte), dread (1 per ROM byte read as data),
               reader (the PC + bank of the first instruction that read each data byte: bank << 16 | pc)
  modes.csv    every (mode hFF8D, state hFF8E) pair seen after an input, with the number of frames and the exact key history (hex,
               core mask, from a cold boot, the 250 boot frames included) that first reached it: replayable as it is
  corpus.jsonl the input history of each corpus entry (replayable: frames of key bytes from a cold boot, in the core's mask:
               direction keys in the low nibble, buttons high; a BGB demo byte has the nibbles swapped)
The core is not the judge for pictures (CLAUDE.md): screenshots come from BGB (tools/jp/bgb_run.py).
"""
import sys, os, json, time, random, argparse, csv
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, os.path.join(HERE, '..', 'coverage', 'src'))
import numpy as np, gbcov as G
ap = argparse.ArgumentParser()
ap.add_argument('rom'); ap.add_argument('out'); ap.add_argument('--minutes', type=float, default=20); ap.add_argument('--seed', type=int, default=1)
ap.add_argument('--save', default=None); ap.add_argument('--kitts', type=int, default=999999)
ap.add_argument('--printer', action='store_true', help='attach the core\'s Game Boy Printer model to the link port (print screens answer)')
a = ap.parse_args(); os.makedirs(a.out, exist_ok=True); rnd = random.Random(a.seed)
sav = bytearray(open(a.save, 'rb').read() if a.save else bytes(0x20000))
if a.save is None:      # format first: boot 600 frames on $00, then raise the counter in the formatted save
    G.load_rom(a.rom); G.reset(bytes(sav)); G.run(600); sav = bytearray(bytes(G.sram()))
d = '%06d' % a.kitts; bcd = [int(d[4:6], 16), int(d[2:4], 16), int(d[0:2], 16)]
sav[0x100A:0x100D] = bytes(bcd)
G.load_rom(a.rom); G.reset(bytes(sav))
if a.printer: G.L.gb_attach_printer(1)
KEYS = [1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80]
def score(): return int((G.cov_exec() > 0).sum()) + int((G.cov_dread() > 0).sum())
G.run(250)
corpus = [(G.snapshot(), [0] * 250)]; modes = {}
def note_mode(h):
    k = (G.peek(0xFF8D), G.peek(0xFF8E))
    if k not in modes: modes[k] = list(h)
note_mode([0] * 250)
best = score(); t0 = time.time(); last_dump = t0; steps = 0
def dump():
    ex = G.cov_exec().copy(); dr = G.cov_dread().copy(); rd = G.cov_reader().copy()
    np.savez_compressed(os.path.join(a.out, 'cov.npz'), ex=ex, dr=dr, rdr=rd)
    with open(os.path.join(a.out, 'modes.csv'), 'w', newline='') as f:
        w = csv.writer(f, lineterminator='\n'); w.writerow(['mode', 'state', 'frames', 'keys'])
        for (m, s), h in sorted(modes.items()): w.writerow(['%02X' % m, '%02X' % s, len(h), ''.join('%02x' % k for k in h)])
    with open(os.path.join(a.out, 'corpus.jsonl'), 'w') as f:
        for i, (_, h) in enumerate(corpus): f.write(json.dumps({'i': i, 'frames': len(h), 'keys': ''.join('%02x' % k for k in h)}) + '\n')
    print('%5.1f min  steps %d  corpus %d  exec %d  dread %d  modes %d' % ((time.time() - t0) / 60, steps, len(corpus), int((ex > 0).sum()), int((dr > 0).sum()), len(modes)), flush=True)
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
