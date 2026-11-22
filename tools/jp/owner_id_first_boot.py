#!/usr/bin/env python3
"""Owner ID of a new camera as a function of the frame at which A is pressed on the title (Japanese ROM, core; 2026-11-22).

  tools/jp/owner_id_first_boot.py JP.gb [--frames 400] [--out roms/jp_rev_a/experiments/owner_id/owner_id_by_press_frame.csv]

A camera leaves the factory with its SRAM filled with $AA except the calibration record (`1B 13` + vector + checksum, slot 3
FF0-FFF, echo in slot 16). Its first boot with the retail ROM turns the boot counter AA -> 95 (bank0:$091A), formats the
slots and writes the default owner block (ID 00000000); the main menu's entry (07:71AF) then calls Owner_GenerateId_Far
(02:51D0), which draws the eight digits from the subtractive generator seeded by that counter. The seed is the same in every
new camera, and the title draws from the generator every frame, so the ID depends only on the frame of the key press that
leaves the title. This run builds that SRAM (a flat vector of twelve $7C with its checksum: the vector is not read by the
generator), boots, lets the title come up (500 frames), then for each delay d presses A at frame 500 + d (4 frames held) and
reads the ID once the main menu has stored it. Writes: delay, press frame since power-on, ID (8 digits as shown), mode:state.
CONTROL: two other vectors ($70, $80) give the same IDs for the first 120 delays (printed).
"""
import argparse, csv, os, sys
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(os.path.dirname(HERE)); sys.path.insert(0, HERE); sys.path.insert(0, os.path.dirname(HERE))
ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('--frames', type=int, default=400)
ap.add_argument('--out', default=os.path.join(REPO, 'roms', 'jp_rev_a', 'experiments', 'owner_id', 'owner_id_by_press_frame.csv'))
a = ap.parse_args(); os.environ['GBCAM_ROM'] = a.rom
import lib; from lib import g
TITLE = 500
def factory_sram(v):
    s = bytearray(b'\xaa' * 0x20000); vec = bytes([v] * 12); x = 0
    for c in vec: x ^= c
    rec = vec + bytes([(sum(vec) + 0x0D) & 0xFF, (x + 0x23) & 0xFF])
    s[0x4FF0:0x5000] = b'\x1b\x13' + rec; s[0x11FF2:0x12000] = rec
    return bytes(s)
def digits(b): return ''.join('%d%d' % ((x >> 4) - 1, (x & 15) - 1) for x in b)
def sweep(v, n):
    g.set_organic(1); g.reset(factory_sram(v)); g.L.gb_attach_printer(0); g.run(TITLE); snap = g.snapshot(); out = []
    for d in range(n):
        g.restore(snap); g.run(d); g.keys(lib.KEY['A']); g.run(4); g.keys(0); m = b''
        for _ in range(60):
            g.run(10); m = bytes(g.sram())[0x2FB8:0x2FBC]
            if m != b'\0\0\0\0': break
        out.append((d, TITLE + d, digits(m) if m != b'\0\0\0\0' else '', '%02X:%02X' % lib.cur()))
    return out
rows = sweep(0x7C, a.frames)
same = all(sweep(v, 120) == rows[:120] for v in (0x70, 0x80))
print('CONTROL: vectors $70 / $80 give the same IDs for the first 120 delays:', same)
os.makedirs(os.path.dirname(a.out), exist_ok=True)
with open(a.out, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['delay_after_title', 'press_frame', 'owner_id', 'mode_state']); w.writerows(rows)
ids = [r[2] for r in rows if r[2]]
print('owner_id_first_boot: %d delays, %d distinct IDs -> %s' % (len(rows), len(set(ids)), os.path.relpath(a.out, REPO)))
