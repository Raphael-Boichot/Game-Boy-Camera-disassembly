#!/usr/bin/env python3
"""BGB screens of the early prototype for its screen tree (tools/make_screen_trees.py): explore.csv, extra.csv, cancel.csv and screenshots.

  tools/proto_bgb_screens.py PROTO_BGB.gb [--out roms/prototype_debagame/screens]

PROTO_BGB.gb is the header-patched copy (md5 1d8097de...; BGB only). The prototype has no (mode, state) pair: a screen is a GAME_SEQ
value ($C0A0), written here as mode = GAME_SEQ and state 00. Every screen is one BGB run from 128 KiB of $00 along a key path from
the title (keys in the format of tcrf_check/tools/bgb_run.py, after the 250-frame boot hold and 400 free frames, 200 free frames
after the last key); the row keeps it only when BGB ends on the GAME_SEQ expected (same = yes). cancel.csv: the same path, then B
held for 240 frames (the AGING screen reads the keys once per cycle, so a short B is lost there), and where GAME_SEQ ends.
extra.csv: two screens that need a condition: AGING running after PROTECT TEST > OFF (state 01), and COM counting with a second
unit linked (state 01, tools/proto_bgb_link.py, two BGB instances).
"""
import sys, os, csv, argparse, subprocess, hashlib, shutil
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); sys.path.insert(0, os.path.join(REPO, 'tcrf_check', 'tools'))
import bgb_run as B
from PIL import Image
ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('--out', default=os.path.join(REPO, 'roms', 'prototype_debagame', 'screens')); a = ap.parse_args()
if hashlib.md5(open(a.rom, 'rb').read()).hexdigest() != '1d8097de3497db8b182bcd2a984b6063': sys.exit('proto_bgb_screens: expected the BGB copy (md5 1d8097de...)')
os.makedirs(a.out, exist_ok=True); work = os.path.join(a.out, '_work'); os.makedirs(work, exist_ok=True)
blank = os.path.join(work, 'blank.sav'); open(blank, 'wb').write(bytes(0x20000))
T = [('A', 4, 90)]
def menu(i): return T + [('Down', 4, 20)] * i + [('A', 4, 120)]
SRAM = menu(0)
OFF = [('Down', 4, 20), ('Down', 4, 20), ('A', 4, 60), ('Down', 4, 20), ('A', 4, 60), ('B', 4, 60), ('Up', 4, 20), ('Up', 4, 20)]
# GAME_SEQ, key path from power-on, parent GAME_SEQ, label of the arrow from the parent
SCREENS = [(0x01, [], None, ''), (0x02, T, 0x01, 'A'),
           (0x04, SRAM, 0x02, 'A (SRAM TEST)'), (0x05, SRAM + [('Down', 4, 20)] * 2 + [('A', 4, 120)], 0x04, 'Down Down A (AGING)'),
           (0x07, SRAM + [('Down', 4, 20)] * 2 + [('A', 4, 60), ('A', 4, 300)], 0x05, 'A (pattern)'),
           (0x08, SRAM + [('Down', 4, 20)] * 3 + [('A', 4, 120)], 0x04, 'Down x3 A (DUMP)'),
           (0x03, menu(1), 0x02, 'Down A (BANK TEST)'), (0x0A, menu(2), 0x02, 'Down x2 A (PROTECT TEST)'),
           (0x06, menu(3), 0x02, 'Down x3 A (MOVIE TEST)'), (0x09, menu(3) + [('Start', 4, 120)], 0x06, 'Start'),
           (0x0C, menu(3) + [('A', 30, 120)], 0x06, 'A held'), (0x0D, menu(4), 0x02, 'Down x4 A (GALLERY)'), (0x0B, menu(5), 0x02, 'Down x5 A (COM)')]
def run(name, seq):
    r = B.run(a.rom, blank, os.path.join(work, name), seq, free=200)
    return r['st']['WRAM'][0xA0] if 'WRAM' in r['st'] else None, r['shot']
def frames(seq): return 250 + 400 + sum(h + w for _, h, w in seq) + 90
ex = []; ca = []
for g, seq, par, key in SCREENS:
    got, shot = run('s_%02X' % g, seq)
    pic = 'screen_%02X_00.png' % g
    if os.path.exists(shot): Image.open(shot).save(os.path.join(a.out, pic))
    ex.append(['%02X' % g, '00', ' '.join(k for k, _, _ in seq) or '-', frames(seq), '%02X' % got if got is not None else '', '00', 'yes' if got == g else 'no', pic,
               '' if par is None else '%02X:00' % par, key])
    if g != 0x01:
        to, _ = run('c_%02X' % g, seq + [('B', 240, 120)])
        ca.append(['%02X' % g, '00', 'B', '%02X:00' % g, '%02X:00' % to if to is not None else '', 'yes' if to is not None else 'no'])
    print(ex[-1][:7], ca[-1] if ca and ca[-1][0] == '%02X' % g else '', flush=True)
with open(os.path.join(a.out, 'explore.csv'), 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['mode', 'state', 'keys', 'frames', 'bgb_mode', 'bgb_state', 'same', 'picture', 'parent', 'key']); w.writerows(ex)
with open(os.path.join(a.out, 'cancel.csv'), 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['mode', 'state', 'key', 'base', 'to', 'ok']); w.writerows(ca)
# extra screens
xr = []
age = T + OFF + [('A', 4, 60), ('Down', 4, 20), ('Down', 4, 20), ('A', 4, 60), ('A', 4, 300)]
got, shot = run('x_07_01', age)
if got == 0x07 and os.path.exists(shot):
    Image.open(shot).save(os.path.join(a.out, 'extra_07_01.png'))
    xr.append(['07', '01', 'extra_07_01.png', 'PROTECT TEST > OFF first (SRAM writes enabled), then the same path', '05:00', 'A after PROTECT OFF', ''])
COM = 'A:4:90,Down:4:20,Down:4:20,Down:4:20,Down:4:20,Down:4:20,A:4:120'
lp = os.path.join(work, 'link')
r = subprocess.run([sys.executable, os.path.join(HERE, 'proto_bgb_link.py'), a.rom, lp, COM + ',A:4:300', COM, '--frames', '1700'], capture_output=True, text=True)
print(r.stdout.strip())
if 'GAME_SEQ 0B, role $C0D7 = 2' in r.stdout and os.path.exists(lp + '_1.png'):
    shutil.copy(lp + '_1.png', os.path.join(a.out, 'extra_0B_01.png'))
    xr.append(['0B', '01', 'extra_0B_01.png', 'a second unit linked on COM (two BGB instances, tools/proto_bgb_link.py)', '0B:00', 'A, partner on COM', 'master; both units count'])
with open(os.path.join(a.out, 'extra.csv'), 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['mode', 'state', 'picture', 'how', 'parent', 'key', 'note']); w.writerows(xr)
shutil.rmtree(work, ignore_errors=True)
