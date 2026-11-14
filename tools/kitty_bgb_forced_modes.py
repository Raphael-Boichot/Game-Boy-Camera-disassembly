#!/usr/bin/env python3
"""Screens of the Hello Kitty modes that no run reaches, by forcing (evidence I, never a way the game runs; HOWTO section 6).

  tools/kitty_bgb_forced_modes.py ROM OUT_DIR --modes 13,15,16 --path 'A' [--after 150] [--kitts 999999]

For each mode M a copy of the ROM is patched (outside the repository) so that entry $01 of ModeTable (00:0D00, 3 bytes per
mode) holds entry M: the game's own way into the main menu (the key path --path from the title, found by
tools/kitty_bgb_explore.py) then runs mode M's routine with state 0. BGB plays the boot, the path and --after free frames,
and writes OUT_DIR/kitty_forced_mode_MM.png and forced.csv (mode, picture, the mode / state bytes at the end: hFF8D stays 01,
the patched slot, unless the forced routine sets another mode).
"""
import sys, os, csv, argparse, subprocess, shutil
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
sys.path.insert(0, os.path.join(REPO, 'coverage', 'src')); sys.path.insert(0, os.path.join(REPO, 'tools', 'jp'))
from bgb_run import read_state
from PIL import Image
ap = argparse.ArgumentParser()
ap.add_argument('rom'); ap.add_argument('out'); ap.add_argument('--modes', required=True); ap.add_argument('--path', default='A')
ap.add_argument('--after', type=int, default=150); ap.add_argument('--kitts', type=int, default=999999); ap.add_argument('--boot', type=int, default=700)
ap.add_argument('--save', default=None, help='start from this SRAM image (e.g. the Hello Kitty unlocking save of tools/make_unlocked_saves.py --hello-kitty) instead of the core-formatted one')
a = ap.parse_args(); os.makedirs(a.out, exist_ok=True)
import gbcov as G
G.load_rom(a.rom); G.reset(bytes(0x20000)); G.run(600); sav = bytearray(bytes(G.sram()))
d = '%06d' % a.kitts; sav[0x100A:0x100D] = bytes([int(d[4:6], 16), int(d[2:4], 16), int(d[0:2], 16)])
if a.save: sav = bytearray(open(a.save, 'rb').read())     # the start save given
BIT = dict(A=1, B=2, Select=4, Start=8, Right=0x10, Left=0x20, Up=0x40, Down=0x80)
dem = bytes(3 + a.boot) + b''.join(bytes([BIT[k]]) * 8 + bytes(90) for k in a.path.split()) + bytes(a.after)
rom = bytearray(open(a.rom, 'rb').read()); rows = []
bgb = '/home/claude/bgbx_forced'      # its own BGB folder (the explorers use bgbx_w0 / w1)
if not os.path.exists(bgb): shutil.copytree('/home/claude/bgbx', bgb)
tmp = os.path.join(a.out, 'tmp'); os.makedirs(tmp, exist_ok=True)
for m in [int(x, 16) for x in a.modes.split(',')]:
    r = bytearray(rom); r[0x0D03:0x0D06] = rom[0x0D00 + 3 * m:0x0D03 + 3 * m]
    open(os.path.join(tmp, 'f.gb'), 'wb').write(r); open(os.path.join(tmp, 'f.dem'), 'wb').write(dem); open(os.path.join(tmp, 'f.sav'), 'wb').write(sav)
    for f in ('f.sna', 'f.bmp'):
        if os.path.exists(os.path.join(tmp, f)): os.remove(os.path.join(tmp, f))
    cmd = ['xvfb-run', '-a', 'wine', os.path.join(bgb, 'bgb.exe'), '-hf', '-nowarn', '-nowriteini', '-nobattsave', '-ini', os.path.join(bgb, 'bgb.ini'),
           '-rom', os.path.join(tmp, 'f.gb'), '-demoplay', os.path.join(tmp, 'f.dem'), '-stateonexit', os.path.join(tmp, 'f.sna'),
           '-screenonexit', os.path.join(tmp, 'f.bmp'), '-loadbatt', os.path.join(tmp, 'f.sav')]
    subprocess.run(cmd, env=dict(os.environ, WINEDEBUG='-all', WINEPREFIX='/root/wineprefix'), capture_output=True, timeout=300)
    st = read_state(os.path.join(tmp, 'f.sna')) if os.path.exists(os.path.join(tmp, 'f.sna')) else {}
    h = st.get('HRAM', b''); pic = 'kitty_forced_mode_%02X.png' % m
    if os.path.exists(os.path.join(tmp, 'f.bmp')): Image.open(os.path.join(tmp, 'f.bmp')).save(os.path.join(a.out, pic))
    rows.append(['%02X' % m, pic, '%02X' % h[0x0D] if len(h) > 0x0E else '?', '%02X' % h[0x0E] if len(h) > 0x0E else '?']); print(rows[-1], flush=True)
with open(os.path.join(a.out, 'forced.csv'), 'w', newline='') as f:
    w = csv.writer(f); w.writerow(['mode', 'picture', 'end_mode', 'end_state']); w.writerows(rows)
shutil.rmtree(tmp, ignore_errors=True)
