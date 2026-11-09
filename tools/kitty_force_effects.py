#!/usr/bin/env python3
"""Hello Kitty ROM: run every picture effect of table 04:5E8A in the core (step 7). Writes trace/forced_effects_kitty.npz and
trace/forced_effects_kitty.csv.

  tools/kitty_force_effects.py [ROM]

The live view (Mode02_State01, 05:4A61) reads the effect byte from table 05:4C5F[D8FD*4 + D8FE] (`add hl,bc; ld a,[hl]` at
05:4A85) and hands it to Cam_ApplyEffectOrFrame (04:4A17). In a copy of the ROM those two bytes become `ld a,EFFECT`; the core boots
with a blank save, goes title A, camera A, waits 300 frames, then runs 240 frames per effect from the same snapshot. Per effect: the
red bytes of the trace (never run in the observed runs, port/cov_kitty_*.npz) that ran. Forced runs: evidence I for any use.
"""
import os, sys, csv, json, glob
import numpy as np
REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__))); KD = os.path.join(REPO, 'roms', 'hello_kitty')
sys.path.insert(0, os.path.join(REPO, 'coverage', 'src')); import gbcov as G
ROMP = sys.argv[1] if len(sys.argv) > 1 else '/root/work/roms/pocketcamera_kitty.gb'
ROM = bytearray(open(ROMP, 'rb').read()); N = len(ROM)
def off(b, a): return a if a < 0x4000 else b * 0x4000 + a - 0x4000
T = json.load(open(os.path.join(KD, 'trace', 'trace_kitty.json')))
code = np.zeros(N, bool)
for k, n in T['code'].items(): o = off(int(k[:2], 16), int(k[3:], 16)); code[o:o + n] = True
ex = np.zeros(N, bool)
for f in sorted(glob.glob(os.path.join(KD, 'trace', 'cov_kitty_*.npz'))) + glob.glob(os.path.join(KD, 'trace', 'wp_exec_kitty.npz')): ex |= np.load(f)['exec'][:N] > 0
red = code & ~ex
o = off(5, 0x4A85); assert ROM[o:o + 2] == b'\x09\x7e', 'not the expected live-view code'
G.load_rom(ROMP); G.reset(bytes(0x20000)); G.run(600); sav = bytes(G.sram())
G.reset(sav); G.run(700)
for k in (16, 16):
    G.keys(k); G.run(8); G.keys(0); G.run(120)
G.run(300); snap = G.snapshot()
tmp = '/tmp/kitty_force_effect.gb'; U_ex = np.zeros(N, np.uint32); U_rd = np.zeros(N, np.uint32); rows = []
tab = off(4, 0x5E8A)
for e in range(0x60):
    rb = bytearray(ROM); rb[o:o + 2] = bytes([0x3E, e]); open(tmp, 'wb').write(rb)
    G.load_rom(tmp); G.restore(snap); G.cov_exec()[:] = 0; G.cov_dread()[:] = 0; G.run(240)
    x = np.array(G.cov_exec())[:N] > 0; U_ex += x; U_rd += np.array(G.cov_dread())[:N] > 0
    rows.append(['%02X' % e, '04:%04X' % (ROM[tab + 2 * e] | ROM[tab + 2 * e + 1] << 8), int((x & red).sum()), '%02X:%02X' % (G.peek(0xFF8D), G.peek(0xFF8E))])
np.savez_compressed(os.path.join(KD, 'trace', 'forced_effects_kitty.npz'), exec=U_ex, dread=U_rd)
with open(os.path.join(KD, 'trace', 'forced_effects_kitty.csv'), 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['effect', 'handler', 'red_bytes_run', 'end']); w.writerows(rows)
print('kitty_force_effects: %d effects, %d red bytes run in at least one, %d bank 04 red bytes left' % (
    len(rows), int(((U_ex > 0) & red).sum()), int((red & ~(U_ex > 0))[off(4, 0x4000):off(4, 0x8000)].sum())))
