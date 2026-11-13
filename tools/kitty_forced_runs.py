#!/usr/bin/env python3
"""Hello Kitty Pocket Camera: forced runs on the gates of the never-run code (roadmap step 9, 2026-11-13).

  tools/kitty_forced_runs.py KITTY.gb [--out trace/forced_kitty_runs.npz] [--report trace/forced_runs_kitty.csv]

Each run boots the core on the unlocked save (Kitts 999999, as tools/kitty_core_paths.py), reaches a screen with keys, then
pokes WRAM (a request byte the game itself would write) and runs on. Nothing here is organic: the coverage goes to a
trace/forced_*.npz, which tools/red_classify.py and tools/reach_map.py read as "run only when forced" (light blue), never
into the trace or the types.

Batches:
  sound   every id of the four request bytes the sound tick reads (Snd_Tick, 0F:5341): $D068 song ($01-$2F, Snd_RequestSong
          takes < $30), $D060 effect channel 1 ($01-$3E, Sfx1_InitTbl), $D070 channel 3 ($01-$09, Sfx3_InitTbl), $D078
          channel 4 ($01-$11, Sfx4_InitTbl); poked on the main menu, 300 frames each.
  state   the 65 (mode, state) pairs that own a never-run piece of trace/red_kitty.csv (TABLE, GATE or BEHIND; listed below): the mode reached by the first organic path of trace/paths_kitty.csv that enters it, then the state
          byte hMODE_STATE ($FF8E) poked 150 frames after the path entered that mode (a mode that no path of the list
          enters is poked itself from the main menu: $FF8D = mode, $FF8E = 0, 150 frames); 600 frames with A, B, Start, the arrows tapped.
  sensor  the auto-exposure driven by a fake light (owner, 2026-11-13): in the live view, the live view with fun lens A, and
          the Strawberry Channel camera, the sensor's picture buffer (SRAM bank 0 $A100-$AEFF) overwritten every frame with a
          plane of one byte ($FF dark, $00 bright, $55, $AA, ramps both ways, a flicker), 1,200 frames, then A (a shot) and
          300 frames more; and the first boot (128 KiB of $00, the sensor calibration) under the same planes.
  gain    the gain band of the auto-exposure ($DA08) poked to 0-11 in the live view, under a $00 and a $FF plane, 600 frames
          each: the bands $08 and $0A (Cam_MainDispatch_Band3 / Band4) that the fake light alone never reaches.
"""
import sys, os, csv, argparse
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); KD = os.path.join(REPO, 'roms', 'hello_kitty')
sys.path.insert(0, os.path.join(REPO, 'coverage', 'src'))
import numpy as np, gbcov as G
ap = argparse.ArgumentParser(); ap.add_argument('rom')
ap.add_argument('--out', default=os.path.join(KD, 'trace', 'forced_kitty_runs.npz')); ap.add_argument('--report', default=os.path.join(KD, 'trace', 'forced_runs_kitty.csv'))
a = ap.parse_args()
BIT = dict(A=1, B=2, Select=4, Start=8, Right=0x10, Left=0x20, Up=0x40, Down=0x80)
def core_mask(b): return ((b << 4) | (b >> 4)) & 0xFF
def tap(k):                                       # as tools/kitty_core_paths.py: 'K', 'K+L*N', '-'
    if k == '-': return [0] * 98
    ks, n = (k.split('*') + [None])[:2]; b = core_mask(sum(BIT[x] for x in ks.split('+')))
    return [b] * int(n) if n else [b] * 8 + [0] * 90
def taps(path): return [x for k in path.split() for x in tap(k)]
G.load_rom(a.rom); G.reset(bytes(0x20000)); G.run(600); base = bytearray(bytes(G.sram()))
KITTS = bytes(base[:0x100A]) + b'\x99\x99\x99' + bytes(base[0x100D:])
def boot(keys):
    G.load_rom(a.rom); G.reset(KITTS); G.L.gb_cov_clear(); G.L.gb_printer_model(1); G.L.gb_attach_printer(1); G.run(700)
    for k in keys: G.keys(k); G.run(1)
    G.keys(0)
def ms(): return '%02X:%02X' % (G.peek(0xFF8D), G.peek(0xFF8E))
tot = None; rows = []
def acc():
    global tot
    ex, dr = np.array(G.cov_exec()), np.array(G.cov_dread())
    if tot is None: tot = [ex.copy(), dr.copy()]
    else: tot[0] |= ex; tot[1] |= dr
# sound: one boot to the main menu, then a snapshot per request
boot(taps('A'))
menu = G.snapshot(); where = ms()
for req, ids, frames, what in ((0xD068, range(0x01, 0x30), 300, 'song'), (0xD060, range(0x01, 0x3F), 300, 'sfx1'), (0xD070, range(0x01, 0x0A), 300, 'sfx3'), (0xD078, range(0x01, 0x12), 300, 'sfx4')):
    for i in ids:
        G.restore(menu); G.L.gb_cov_clear(); G.poke(req, i)
        for _ in range(frames): G.run(1)
        acc(); rows.append(['sound', '%s_%02X' % (what, i), '%s: $%04X = $%02X' % (where, req, i), ms()])
# state: the never-run state handlers of the mode tables
import re, collections
# the (mode, state) of the never-run pieces of trace/red_kitty.csv before these forced runs (2026-11-13; frozen: the table
# shrinks once this file's npz is read)
PAIRS = [(0x06, 0x04), (0x06, 0x13), (0x06, 0x18), (0x06, 0x19), (0x06, 0x27), (0x00, 0x07), (0x0D, 0x01), (0x0D, 0x02), (0x0D, 0x05), (0x02, 0x02), (0x02, 0x04),
         (0x02, 0x06), (0x02, 0x0A), (0x02, 0x0D), (0x02, 0x0E), (0x05, 0x00), (0x05, 0x01), (0x03, 0x0A), (0x03, 0x06), (0x03, 0x00), (0x03, 0x01), (0x03, 0x02),
         (0x03, 0x04), (0x03, 0x05), (0x03, 0x11), (0x15, 0x00), (0x16, 0x00), (0x0B, 0x05), (0x07, 0x02), (0x07, 0x03), (0x07, 0x04), (0x08, 0x00), (0x08, 0x01),
         (0x08, 0x02), (0x08, 0x04), (0x08, 0x05), (0x09, 0x01), (0x09, 0x02), (0x09, 0x03), (0x09, 0x05), (0x09, 0x06), (0x09, 0x08), (0x09, 0x0A), (0x09, 0x0C),
         (0x09, 0x0E), (0x09, 0x0F), (0x09, 0x07), (0x12, 0x02), (0x12, 0x03), (0x11, 0x0A), (0x11, 0x0C), (0x11, 0x0D), (0x11, 0x0E), (0x0F, 0x02), (0x0F, 0x04),
         (0x0F, 0x0C), (0x10, 0x00), (0x10, 0x01), (0x10, 0x04), (0x0E, 0x09), (0x0E, 0x0D), (0x0E, 0x1E)]
PAIRS += [(0x08, 0x03), (0x0F, 0x0D), (0x0E, 0x0F)]       # the states that the first pass revealed (2026-11-13, second pass)
want = collections.OrderedDict((k, 0) for k in PAIRS)
paths = [r for r in csv.DictReader(open(os.path.join(KD, 'trace', 'paths_kitty.csv'))) if r['kind'] == 'organic' and not r['keys'].startswith(('hold:', 'wait:'))]
snap = {}
for r in paths:                                   # first frame in each mode, from the organic paths
    if all(m in snap for m, _ in want): break
    k = r['keys']; ks = (taps('A A A A B') if k.startswith('photo:') else []) + taps(k.replace('photo:', '')) + [0] * 1200
    G.load_rom(a.rom); G.reset(KITTS); G.L.gb_attach_printer(1); G.run(700)
    first = {}
    for i, kk in enumerate(ks):
        G.keys(kk); G.run(1); md = G.peek(0xFF8D)
        first.setdefault(md, i)
        if md not in snap and any(m == md for m, _ in want) and i - first[md] == 150: snap[md] = (G.snapshot(), r['path'])
    G.keys(0)
for m, _ in want:                                 # modes no organic path of the list enters: poked from the main menu (mode, state 0)
    if m in snap: continue
    G.restore(menu); G.poke(0xFF8D, m); G.poke(0xFF8E, 0)
    for _ in range(150): G.run(1)
    if G.peek(0xFF8D) == m: snap[m] = (G.snapshot(), 'main menu, $FF8D = $%02X, $FF8E = $00' % m)
PRESS = taps('A - B - Start - Up - Down - Left - Right - A A')
for (m, st), n in want.items():
    if m not in snap: rows.append(['state', 'mode%02X_state%02X' % (m, st), 'mode $%02X: not entered, even poked' % m, '']); continue
    G.restore(snap[m][0]); G.L.gb_cov_clear(); G.poke(0xFF8E, st)
    for kk in [0] * 120 + PRESS + [0] * 300: G.keys(kk); G.run(1)
    G.keys(0); acc(); rows.append(['state', 'mode%02X_state%02X' % (m, st), '%s, 150 frames into mode $%02X: $FF8E = $%02X' % (snap[m][1], m, st), ms()])
# sensor: the camera's picture buffer replaced by a plane of one byte value, every frame (owner, 2026-11-13: no need for real
# pictures, a byte plane is enough to drive the auto-exposure); bank 0 $A100-$AEFF of SRAM, where the sensor's capture lands
SEQS = [('dark', [0xFF]), ('bright', [0x00]), ('grey55', [0x55]), ('greyAA', [0xAA]), ('dark_to_bright', [0xFF, 0xAA, 0x55, 0x00]),
        ('bright_to_dark', [0x00, 0x55, 0xAA, 0xFF]), ('flicker', [0x00, 0xFF] * 4)]
for where, keys in (('live view', taps('A')), ('live view, fun lens A', taps('A - Down - Down -')), ('strawberry channel camera', None)):
    if keys is None:
        r = [x for x in paths if x['path'].startswith('strawberry')]
        if not r: continue
        k = r[0]['keys']; G.load_rom(a.rom); G.reset(KITTS); G.L.gb_attach_printer(1); G.run(700)
        for kk in taps(k) + [0] * 300: G.keys(kk); G.run(1)
    else:
        G.restore(menu)
        for kk in keys + [0] * 120: G.keys(kk); G.run(1)
    G.keys(0); s0 = G.snapshot(); m0 = ms()
    for nm, vals in SEQS:
        G.restore(s0); G.L.gb_cov_clear(); sr = G.sram()
        for v in vals:
            for _ in range(1200 // len(vals)):
                G.run(1); sr[0x000:0xF00] = v
        G.keys(core_mask(BIT['A'])); G.run(8); G.keys(0)          # a shutter press on the forced light
        for _ in range(300): G.run(1); sr[0x000:0xF00] = vals[-1]
        acc(); rows.append(['sensor', '%s_%s' % (where.replace(' ', '_').replace(',', ''), nm), '%s (%s): SRAM $A100-$AEFF = %s every frame, then A' % (where, m0, '/'.join('$%02X' % v for v in vals)), ms()])
for nm, vals in SEQS:                              # the first boot (all-$00 SRAM: the sensor calibration of Cam_CalibVector_*) under the same planes
    G.load_rom(a.rom); G.reset(bytes(0x20000)); G.L.gb_cov_clear(); G.L.gb_attach_printer(1); sr = G.sram()
    for v in vals:
        for _ in range(1200 // len(vals)): G.run(1); sr[0x000:0xF00] = v
    acc(); rows.append(['sensor', 'first_boot_%s' % nm, 'first boot from 128 KiB of $00: SRAM $A100-$AEFF = %s every frame' % '/'.join('$%02X' % v for v in vals), ms()])
# gain: the auto-exposure's gain band $DA08 poked in the live view (0-11), under a dark and a bright plane (2026-11-13: the fake
# light alone leaves it at 5; with it poked, Cam_MainDispatch runs Band1-4)
G.restore(menu)
for kk in taps('A') + [0] * 120: G.keys(kk); G.run(1)
G.keys(0); s0 = G.snapshot()
for band in range(12):
    for v in (0x00, 0xFF):
        G.restore(s0); G.L.gb_cov_clear(); sr = G.sram(); G.poke(0xDA08, band)
        for _ in range(600): G.run(1); sr[0x000:0xF00] = v
        acc(); rows.append(['gain', 'band%02X_plane%02X' % (band, v), 'live view: $DA08 = $%02X, SRAM $A000-$AEFF = $%02X every frame' % (band, v), ms()])
np.savez_compressed(a.out, ex=tot[0], dr=tot[1])
with open(a.report, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['batch', 'run', 'poke', 'end']); w.writerows(rows)
print('kitty_forced_runs: %d runs; executed %d bytes, read %d bytes' % (len(rows), int((tot[0] > 0).sum()), int((tot[1] > 0).sum())))
