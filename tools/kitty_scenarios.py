#!/usr/bin/env python3
"""Named scenarios of the Hello Kitty ROM run in the core (coverage) and in BGB (screenshots): boot conditions that keys
alone never give (keys held at power-on, a blank SRAM).

  tools/kitty_scenarios.py ROM OUT_DIR [--only NAME,NAME] [--no-bgb]

Scenarios (SCEN below): an SRAM image ('zero' = 128 KiB of $00, 'aa' = 128 KiB of $AA, the pattern of a new cartridge
in the retail ROMs' calibration test, 'kitts' = $00 formatted by the core in 600 frames with the Kitt counter at 999,999),
a list of (core key mask, frames) held from power-on, the frames to run, and the frames at which BGB takes its screenshots.
Keys are written as the BGB demo byte (A=1 B=2 Select=4 Start=8 Right=$10 Left=$20 Up=$40 Down=$80), the convention of the
game's own key byte ($D8D8 holds the keys read at boot: $FD = every key but B, as in the Japanese ROM); the core's mask has the
nibbles swapped (direction keys low), converted here.
Writes OUT_DIR/cov_scenarios.npz (ex / dr / rdr of all core runs, the format of tools/kitty_coverage.py),
OUT_DIR/scenarios.csv (scenario, modes in order with the frame of each change, in the core and at each BGB screenshot) and
OUT_DIR/kitty_scen_NAME_FRAME.png (BGB).
"""
import sys, os, csv, argparse, subprocess, shutil
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
sys.path.insert(0, os.path.join(REPO, 'coverage', 'src')); sys.path.insert(0, os.path.join(REPO, 'tcrf_check', 'tools'))
import numpy as np, gbcov as G
from bgb_run import read_state
from PIL import Image
SCEN = [  # name, sram, [(keys, frames)], total frames, BGB shots
    ('blank_sram_aa', 'aa', [], 4000, [200, 600, 1500, 3000]),
    ('hold_all_keys', 'zero', [(0xFF, 60)], 4000, [200, 600, 1500, 3000]),
    ('hold_all_but_B', 'zero', [(0xFD, 60)], 4500, [200, 600, 1500, 3000, 4200]),
    ('hold_all_but_B_kitts', 'kitts', [(0xFD, 60)], 4500, [200, 600, 1500, 3000, 4200]),
]
ap = argparse.ArgumentParser()
ap.add_argument('rom'); ap.add_argument('out'); ap.add_argument('--only', default=None); ap.add_argument('--no-bgb', action='store_true')
a = ap.parse_args(); os.makedirs(a.out, exist_ok=True)
G.load_rom(a.rom); G.reset(bytes(0x20000)); G.run(600); kitts = bytearray(bytes(G.sram())); kitts[0x100A:0x100D] = b'\x99\x99\x99'
SR = {'zero': bytes(0x20000), 'aa': bytes([0xAA]) * 0x20000, 'kitts': bytes(kitts)}
ex = dr = rd = None; rows = []
bgb = '/home/claude/bgbx_w0'
if not os.path.exists(bgb): shutil.copytree('/home/claude/bgbx', bgb)
for name, sram, keys, frames, shots in SCEN:
    if a.only and name not in a.only.split(','): continue
    G.load_rom(a.rom); G.reset(SR[sram]); seq = []
    for k, n in keys: seq += [k] * n
    seq += [0] * (frames - len(seq)); ch = []; last = None
    for f, k in enumerate(seq):
        G.keys(((k & 0x0F) << 4) | (k >> 4)); G.run(1); ms = '%02X:%02X' % (G.peek(0xFF8D), G.peek(0xFF8E))
        if ms != last: ch.append('%d=%s' % (f + 1, ms)); last = ms
    e, d_, r_ = G.cov_exec().copy(), G.cov_dread().copy(), G.cov_reader().copy()
    if ex is None: ex, dr, rd = e, d_, r_
    else: ex = np.where((ex == 1) | (e == 1), 1, np.maximum(ex, e)).astype(np.uint8); dr = np.maximum(dr, d_); rd = np.where(rd != 0, rd, r_)
    rows.append([name, 'core', ' '.join(ch[:40]), ''])
    if a.no_bgb: continue
    tmp = os.path.join(a.out, 'tmp'); os.makedirs(tmp, exist_ok=True)
    for n in shots:      # BGB needs 3 more boot frames than the core
        open(os.path.join(tmp, 's.dem'), 'wb').write(bytes([seq[0]] * 3) + bytes(seq[:n])); open(os.path.join(tmp, 's.sav'), 'wb').write(SR[sram])
        for f in ('s.sna', 's.bmp'):
            if os.path.exists(os.path.join(tmp, f)): os.remove(os.path.join(tmp, f))
        subprocess.run(['xvfb-run', '-a', 'wine', os.path.join(bgb, 'bgb.exe'), '-hf', '-nowarn', '-nowriteini', '-nobattsave', '-ini', os.path.join(bgb, 'bgb.ini'),
                        '-rom', os.path.abspath(a.rom), '-demoplay', os.path.join(tmp, 's.dem'), '-stateonexit', os.path.join(tmp, 's.sna'),
                        '-screenonexit', os.path.join(tmp, 's.bmp'), '-loadbatt', os.path.join(tmp, 's.sav')],
                       env=dict(os.environ, WINEDEBUG='-all', WINEPREFIX='/root/wineprefix'), capture_output=True, timeout=600)
        st = read_state(os.path.join(tmp, 's.sna')) if os.path.exists(os.path.join(tmp, 's.sna')) else {}
        h = st.get('HRAM', b''); pic = 'kitty_scen_%s_%d.png' % (name, n)
        if os.path.exists(os.path.join(tmp, 's.bmp')): Image.open(os.path.join(tmp, 's.bmp')).save(os.path.join(a.out, pic))
        rows.append([name, 'bgb frame %d' % n, '%02X:%02X' % (h[0x0D], h[0x0E]) if len(h) > 0x0E else '?', pic])
    shutil.rmtree(tmp, ignore_errors=True)
np.savez_compressed(os.path.join(a.out, 'cov_scenarios.npz'), ex=ex, dr=dr, rdr=rd)
with open(os.path.join(a.out, 'scenarios.csv'), 'w', newline='') as f:
    w = csv.writer(f); w.writerow(['scenario', 'where', 'modes', 'picture']); w.writerows(rows)
for r in rows: print(*r)
