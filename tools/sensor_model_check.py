#!/usr/bin/env python3
"""The realistic sensor of the core (coverage/src/gbcov.c, gb_cam_model, 2026-11-22) against the real camera: docs §19.12.

  tools/sensor_model_check.py JP.gb KITTY.gb [--out sensor/model_check.txt]

1. Boot: the Japanese ROM booted in the core with the model, the save sensor/calibration_saves/CE10245109_calibration_in_dark.sav with
   camera 1's recorded vector written in (7E 7D 7D 80 7D 7C 7D 7B 7C 7B 79 6A, docs §18.13; checksums Σ + $0D, XOR + $23), a uniform scene
   of 0 ... 3,000 lx at the sensor face: each search's captures (reg 0 values) against camera 1's boot on the real bus
   (sensor/sar_check_real.txt, "== boot").
2. Factory calibration: the blank save (128 KiB of $AA) in the dark: the 12 offset searches against camera 1's calibration on the bus
   ("== calibration"), the 12 threshold scans, and the vector it stores against camera 1's.
3. Hello Kitty: a cold boot (zeroed SRAM, the default vector) at 0, 100 and 1,000 lx: which bytes of its two offset-search tables
   (Cam_ORegSAR_Table_Above 04:48A0, _Below 04:48E0) are read.
Deterministic (the model's noise comes from the core's own generator).
"""
import argparse, os, sys, re, functools
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
sys.path.insert(0, os.path.join(REPO, 'coverage', 'src')); import gbcov as G
ap = argparse.ArgumentParser(); ap.add_argument('jp'); ap.add_argument('kitty'); ap.add_argument('--out', default=os.path.join(REPO, 'sensor', 'model_check.txt'))
a = ap.parse_args()
SV = os.path.join(REPO, 'sensor', 'calibration_saves')
CAM1 = [0x7E, 0x7D, 0x7D, 0x80, 0x7D, 0x7C, 0x7D, 0x7B, 0x7C, 0x7B, 0x79, 0x6A]
def with_vector(base, v):
    s = bytearray(open(base, 'rb').read()); v = bytes(v)
    ck = bytes([(sum(v) + 0x0D) & 0xFF, (functools.reduce(lambda x, y: x ^ y, v) + 0x23) & 0xFF])
    s[0x4FF0:0x5000] = b'\x1b\x13' + v + ck; s[0x11FF2:0x12000] = v + ck; return bytes(s)
def run(rom, sav, lux, frames):
    G.load_rom(rom); G.reset(sav); G.cam_model(True); G.cam_unit(); G.cam_scene(lux); G.cam_log_clear(); G.L.gb_cov_clear(); G.run(frames)
    groups = []
    for q in G.cam_log():
        k = (q[0], q[1], q[3], q[4])
        if not groups or groups[-1][0] != k: groups.append([k, [], []])
        groups[-1][1].append(q[2]); groups[-1][2].append(q[5])
    return groups
def real(section):
    txt = open(os.path.join(REPO, 'sensor', 'sar_check_real.txt')).read().split('== ')
    blk = next(b for b in txt if b.startswith(section))
    return [(int(m.group(1), 16), int(m.group(2), 16), m.group(3), m.group(4).split()) for m in
            re.finditer(r'reg1=(\w\w) reg7=(\w\w) C=(\w{4})\s+captures ([0-9A-F ]+?) ->', blk)]
out = []
def P(s=''): out.append(s); print(s)
P('sensor_model_check: the core sensor model (gbcov.c gb_cam_model) against camera 1 (docs §19.12)')
# 1. boot
R = real('boot'); rb = [r for r in R if r[0] != 0x00]           # the five searches (the gain probe groups apart)
P('\n1. Boot, camera 1 vector, uniform scene (lux at the sensor face): captures of the five searches; real = camera 1 on the bus')
for r in rb: P('   real          reg1=%02X reg7=%02X C=%s  %s' % (r[0], r[1], r[2], ' '.join(r[3])))
sav = with_vector(os.path.join(SV, 'CE10245109_calibration_in_dark.sav'), CAM1)
for lux in (0, 30, 100, 300, 1000, 3000):
    gr = run(a.jp, sav, float(lux), 300); n = sum(len(g[1]) for g in gr)
    se = [g for g in gr if g[0][0] != 0x00 and not (g[0][0] in (1, 2) and g[0][1] == 5)][:5 + 4]
    exact = 0; lines = []
    for g in se:
        os_ = ' '.join('%02X' % o for o in g[1])
        m = next((r for r in rb if (r[0], r[1]) == (g[0][0], g[0][1])), None)
        same = m is not None and m[3] == os_.split(); exact += same
        lines.append('   %5d lx      reg1=%02X reg7=%02X C=%02X%02X  %s%s' % (lux, g[0][0], g[0][1], g[0][2], g[0][3], os_, '   = real' if same else ''))
    P('   -- %d lx: %d captures, gain probe winner G = %d, boot V %s, O %s; %d of 5 searches the same as camera 1' % (
        lux, n, G.peek(0xD588), ' '.join('%X' % G.peek(0xD5C1 + i) for i in range(5)), ' '.join('%02X' % G.peek(0xD5C6 + i) for i in range(5)), exact))
    for l in lines: P(l)
# 2. factory calibration
RC = real('calibration')
gr = run(a.jp, open(os.path.join(SV, 'blank_AA_128KB.sav'), 'rb').read(), 0.0, 1500)
sar = [g for g in gr if len(set(g[1])) > 1]; scans = [g for g in gr if len(set(g[1])) == 1]
vec = [int(G.sram()[0x4FF2 + i]) for i in range(12)]
P('\n2. Factory calibration from the blank save, 0 lx: %d captures (camera 2 in room light: 164, docs §18.13)' % sum(len(g[1]) for g in gr))
ex = one = 0
for g in sar[:12]:
    m = next((r for r in RC if (r[0], r[1], r[2]) == (g[0][0], g[0][1], '%02X%02X' % (g[0][2], g[0][3]))), None)
    res = g[1][-1]; rr = int(m[3][-1], 16) if m else None
    d = abs(res - rr) if m else None; ex += d == 0; one += d is not None and d <= 2
    P('   reg1=%02X C=%02X%02X  model %s | real %s%s' % (g[0][0], g[0][2], g[0][3], ' '.join('%02X' % o for o in g[1]), ' '.join(m[3]) if m else '-',
                                                      '   = real' if d == 0 else ''))
P('   searches ending on camera 1\'s last capture: %d of 12; within one step (the last decision is not on the bus): %d of 12' % (ex, one))
P('   scans: %s' % ' '.join('%d' % len(g[1]) for g in scans[:12]))
P('   vector stored: %s' % ' '.join('%02X' % v for v in vec))
P('   camera 1     : %s' % ' '.join('%02X' % v for v in CAM1))
P('   difference   : %s' % ' '.join('%+d' % (v - c) for v, c in zip(vec, CAM1)))
# 3. Hello Kitty
P('\n3. Hello Kitty cold boot (zeroed SRAM): its offset-search tables read')
def fl(b, ad): return b * 0x4000 + ad - 0x4000
for lux in (0, 100, 1000):
    run(a.kitty, bytes(0x20000), float(lux), 400); d = G.cov_dread()
    for nm, s in (('Cam_ORegSAR_Table_Above 04:48A0', 0x48A0), ('Cam_ORegSAR_Table_Below 04:48E0', 0x48E0)):
        b = ''.join('x' if d[fl(4, s) + i] else '.' for i in range(64))
        P('   %5d lx %-32s %s  (%d of 64)' % (lux, nm, b, b.count('x')))
os.makedirs(os.path.dirname(a.out), exist_ok=True); open(a.out, 'w').write('\n'.join(out) + '\n')
print('-> %s' % os.path.relpath(a.out, REPO))
