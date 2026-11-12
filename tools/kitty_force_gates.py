#!/usr/bin/env python3
"""Hello Kitty ROM: force the gates of the never-run code one at a time in the core (step 7). Writes trace/forced_gates_kitty.npz and
trace/forced_gates_kitty.csv.

  tools/kitty_force_gates.py [ROM] [--banks 04,...]

For every gate of trace/gates_kitty.csv (tools/kitty_gates.py) in the given banks, a copy of the ROM with that one conditional branch
inverted (opcode xor $08: nz <-> z, nc <-> c) boots in the core with a blank save and goes title A, camera A, A (the live view), then
1,500 free frames, A (shutter) and 600 frames. Per gate: whether the flipped site ran, the red bytes of the trace that ran only in this
run, and the (mode, state) at the end. The union of what ran is the purple "forced" layer of the reachability map (evidence I for any
use: a flipped branch is never a way the game runs).
"""
import os, sys, csv, json, glob
import numpy as np
REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__))); KD = os.path.join(REPO, 'roms', 'hello_kitty')
sys.path.insert(0, os.path.join(REPO, 'coverage', 'src')); import gbcov as G
args = [x for x in sys.argv[1:] if not x.startswith('--')]
ROMP = args[0] if args else '/root/work/roms/pocketcamera_kitty.gb'
banks = sys.argv[sys.argv.index('--banks') + 1].split(',') if '--banks' in sys.argv else ['04']
ROM = bytearray(open(ROMP, 'rb').read()); N = len(ROM)
def off(b, a): return a if a < 0x4000 else b * 0x4000 + a - 0x4000
T = json.load(open(os.path.join(KD, 'trace', 'trace_kitty.json')))
code = np.zeros(N, bool)
for k, n in T['code'].items(): o = off(int(k[:2], 16), int(k[3:], 16)); code[o:o + n] = True
ex = np.zeros(N, bool)
for f in sorted(glob.glob(os.path.join(KD, 'trace', 'cov_kitty_*.npz'))) + glob.glob(os.path.join(KD, 'trace', 'wp_exec_kitty.npz')): ex |= np.load(f)['ex'][:N] > 0
red = code & ~ex
gates = [r for r in csv.DictReader(open(os.path.join(KD, 'trace', 'gates_kitty.csv'))) if r['site'][:2] in banks]
G.load_rom(ROMP); G.reset(bytes(0x20000)); G.run(600); sav = bytes(G.sram())
tmp = os.path.join('/tmp', 'kitty_force_gate.gb')
U_ex = np.zeros(N, np.uint32); U_rd = np.zeros(N, np.uint32); rows = []
def play(rb):
    open(tmp, 'wb').write(rb); G.load_rom(tmp); G.reset(sav); G.cov_exec()[:] = 0; G.cov_dread()[:] = 0; G.run(700)
    for k in (16, 16, 16):
        G.keys(k); G.run(8); G.keys(0); G.run(120)
    G.run(1500); G.keys(16); G.run(8); G.keys(0); G.run(600)
    return np.array(G.cov_exec())[:N] > 0, np.array(G.cov_dread())[:N] > 0
c_ex, c_rd = play(ROM)   # control: the same keys on the unpatched ROM
red &= ~c_ex
for g in gates:
    b, a = int(g['site'][:2], 16), int(g['site'][3:], 16); o = off(b, a)
    rb = bytearray(ROM); rb[o] ^= 0x08
    e, dr = play(rb)
    U_ex += e; U_rd += dr
    newred = int((e & red).sum())
    rows.append([g['site'], g['routine'], g['branch'], g['first_red'], 'yes' if e[o] else 'no', newred, '%02X:%02X' % (G.peek(0xFF8D), G.peek(0xFF8E))])
    print(*rows[-1], flush=True)
np.savez_compressed(os.path.join(KD, 'trace', 'forced_gates_kitty.npz'), ex=U_ex, dr=U_rd)
with open(os.path.join(KD, 'trace', 'forced_gates_kitty.csv'), 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['site', 'routine', 'branch', 'first_red', 'site_ran', 'red_bytes_run', 'end']); w.writerows(rows)
print('kitty_force_gates: %d gates, %d ran, %d red bytes run in at least one' % (len(rows), sum(1 for r in rows if r[4] == 'yes'), int(((U_ex > 0) & red).sum())))
