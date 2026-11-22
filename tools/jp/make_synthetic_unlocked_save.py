#!/usr/bin/env python3
"""A synthetic stand-in for the owner's unlocked saves: a new camera, 30 photos, every counter at its maximum (Japanese ROM, core; 2026-11-22).

  tools/jp/make_synthetic_unlocked_save.py JP.gb OUT.sav [--photos 30]

Built in my core, no real save involved: the SRAM of a new camera (all $AA + a valid calibration record `1B 13` + a flat
vector of twelve $7C with its checksum, as tools/jp/owner_id_first_boot.py), first boot, A on the title at frame 500,
SHOOT, then (shutter, save) N + 1 times (the first A only opens the viewfinder) with the core's synthetic sensor, B back
to the main menu; then the unlock of tools/jp/make_unlock_saves.py: 10BB-10CC = $99, CoroCoro tag AA 56 56 53 at
01FFC-01FFF, settings block checksum and echo recomputed. The same bytes on every run (one process: the core keeps a
static across g.reset, docs §16.6 row 1). Used for the BGB sweep paths that the explorer had started from the owner's
unlocked saves (docs §16.6 row 1).
"""
import argparse, os, sys
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE); sys.path.insert(0, os.path.dirname(HERE))
ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('out'); ap.add_argument('--photos', type=int, default=30)
a = ap.parse_args(); os.environ['GBCAM_ROM'] = os.path.abspath(a.rom)
import lib; from lib import g
import sram_analyze as S
def factory_sram(v=0x7C):
    s = bytearray(b'\xaa' * 0x20000); vec = bytes([v] * 12); x = 0
    for c in vec: x ^= c
    rec = vec + bytes([(sum(vec) + 0x0D) & 0xFF, (x + 0x23) & 0xFF])
    s[0x4FF0:0x5000] = b'\x1b\x13' + rec; s[0x11FF2:0x12000] = rec
    return bytes(s)
g.set_organic(1); g.reset(factory_sram()); g.L.gb_attach_printer(0); g.run(500)
def tap(k, w): g.keys(lib.KEY[k]); g.run(4); g.keys(0); g.run(w)
for k, w in [('A', 300), ('A', 200), ('A', 300)] + [('A', 200)] * (2 * (a.photos + 1)) + [('B', 60), ('B', 200), ('B', 200)]: tap(k, w)
b = bytearray(g.sram()); n = sum(1 for x in b[0x11B2:0x11B2 + 30] if x != 0xFF)
assert lib.cur() == (0, 1) and n == a.photos, (lib.cur(), b[0x11B2:0x11D0].hex())
for ad in range(0x10BB, 0x10CD): b[ad] = 0x99
blk = bytes(b[0x1000:0x1000 + 0xD7]); blk += S.ck(blk, 0, 0xD7); b[0x1000:0x10D9] = blk; b[0x10D9:0x11B2] = blk
b[0x1FFC:0x2000] = bytes([0xAA, 0x56, 0x56, 0x53])
assert S.blk_ok(b, 0x1000, 0xD7) and S.blk_ok(b, 0x10D9, 0xD7)
open(a.out, 'wb').write(bytes(b)); print('make_synthetic_unlocked_save: %d photos, unlocked -> %s' % (n, a.out))
