#!/usr/bin/env python3
"""Does editing a photo leave its F34-F35 (image checksum) stale? A core run of the Japanese ROM, keys only (docs/12, 2026-11-15).

  tools/jp/f34_edit_check.py JP.gb [--out roms/jp_rev_a/experiments/f34_edit/f34_edit_check.json]

F34-F35 = (8-bit sum, 8-bit XOR) of the 3,584 photo bytes, computed by 02:4005 when a shot is stored (02:46F0). 52 of the 369 used
slots of the real saves hold another non-zero value (docs §11.5). The code read says the editor's save-back 02:47C4 (called from
07:6A4E) rewrites the image and the thumbnail ($F00 bytes) but not the tag; this run shows it on the game itself:
  1. blank SRAM ($FF, formatted by the game at boot), title A, main menu A (shoot), A, A (shoot), A (save): photo 1; A, A: photo 2
  2. B, B back to the main menu, Left A A (album), A (photo 1), A (options), Left A (paint, mode $10)
  3. draw: A+Right held 90 frames, A+Down held 60 frames
  4. B (save dialog "セーブしますか?"), A (yes)
After each stage the stored F34-F35 of every used slot is compared with the sum / XOR of its image in SRAM.
Writes the JSON: the stages, the values, whether 07:6A4E (the save-back call) ran.
"""
import argparse, json, os, sys
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(os.path.dirname(HERE))
ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('--out', default=os.path.join(REPO, 'roms', 'jp_rev_a', 'experiments', 'f34_edit', 'f34_edit_check.json'))
a = ap.parse_args(); os.environ['GBCAM_ROM'] = a.rom
sys.path.insert(0, HERE); sys.path.insert(0, os.path.dirname(HERE))
import walk, lib; from lib import g
import sram_analyze as S

def slots():
    b = bytes(g.sram()); vec = b[0x11B2:0x11D0]; out = []
    for i in range(30):
        if vec[i] == 0xFF: continue
        base = S.slot_base(i + 1); img = b[base:base + 0xE00]; x = 0
        for c in img: x ^= c
        out.append({'slot': i + 1, 'stored_F34_F35': '%02X%02X' % (b[base + 0xF34], b[base + 0xF35]), 'image_sum_xor': '%02X%02X' % (sum(img) & 0xFF, x),
                    'match': b[base + 0xF34] == sum(img) & 0xFF and b[base + 0xF35] == x})
    return out
def step(k, wait=120): walk.tap(k); g.run(wait)
def hold(keys, n): g.keys(keys); g.run(n); g.keys(0); g.run(20)
ex = g.cov_exec(); CALL = 7 * 0x4000 + 0x6A4E - 0x4000
res = {'stages': []}
walk.boot(b'\xff' * 0x20000, 0); g.run(600); walk.tap('A')
for k in 'A A A A A A'.split(): step(k)
res['stages'].append({'stage': 'two photos shot and stored', 'state': '%02X:%02X' % lib.cur(), 'slots': slots()})
for k, w in (('B', 60), ('B', 60), ('L', 60), ('A', 120), ('A', 120), ('A', 120), ('A', 120), ('L', 150), ('A', 150)): step(k, w)
res['stages'].append({'stage': 'paint tool open on photo 1', 'state': '%02X:%02X' % lib.cur(), 'slots': slots()})
hold(lib.KEY['A'] | lib.KEY['R'], 90); hold(lib.KEY['A'] | lib.KEY['D'], 60)
step('B', 210); step('A', 400)
res['stages'].append({'stage': 'drawn on, then saved (B, A: yes)', 'state': '%02X:%02X' % lib.cur(), 'slots': slots()})
res['save_back_call_07_6A4E_ran'] = bool(ex[CALL])
os.makedirs(os.path.dirname(a.out), exist_ok=True); json.dump(res, open(a.out, 'w'), indent=1)
for s in res['stages']: print('%-36s %s  %s' % (s['stage'], s['state'], ', '.join('slot %d %s/%s%s' % (x['slot'], x['stored_F34_F35'], x['image_sum_xor'], '' if x['match'] else ' MISMATCH') for x in s['slots'])))
print('save-back call 07:6A4E ran:', res['save_back_call_07_6A4E_ran'], '->', os.path.relpath(a.out, REPO))
