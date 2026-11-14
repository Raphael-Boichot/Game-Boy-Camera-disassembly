#!/usr/bin/env python3
"""Calibration record of a save -> the five black-level references the boot uses, one per live band (§6, §18.4, §18.13).

  tools/jp/calib_vector_bands.py OUT.csv LABEL=SAVE.sav [LABEL=SAVE.sav ...]

For each save: the 12-byte vector at flat $04FF2, its checksum at $04FFE-$04FFF (Σ + $0D, XOR + $23), whether the echo at $11FF2 is equal,
and what the ROM does with it (twelve $AA in both copies = factory calibration; valid = used; else the default vector in WRAM; §6).  Then, for each
possible winner g of the gain probe (0-3), the reference bytes of boot searches 1-5 = bands 0-4: slot g, slot 4+g, slot 8 (g = 0, 1) or 9
(g = 2, 3), slot 10, slot 11 (table of §6), and the step between neighbouring bands.  Two reference rows are always added: the ROM's default
vector and camera 1's vector (§18.13).  Only these numbers are written.  The three saves of §18.13 are in sensor/calibration_saves/."""
import sys, csv

DEFAULT = bytes.fromhex('7E7F7F7F7E7D7E7E7D7E7D6A')
CAM1 = bytes.fromhex('7E7D7D807D7C7D7B7C7B796A')


def cks(v):
    s = x = 0
    for b in v: s = (s + b) & 0xFF; x ^= b
    return (s + 0x0D) & 0xFF, (x + 0x23) & 0xFF


def record(d):
    p, e = d[0x4FF2:0x4FFE], d[0x11FF2:0x11FFE]
    pv = cks(p) == tuple(d[0x4FFE:0x5000]); ev = cks(e) == tuple(d[0x11FFE:0x12000])
    if p == b'\xaa' * 12 and e == b'\xaa' * 12: use = 'factory calibration (STORE PLEASE WAIT)'; v = None
    elif pv and (not ev or e == p): v, use = p, 'primary used' + ('' if ev else ' (echo repaired)')
    elif ev and not pv: v, use = e, 'echo used (primary repaired)'
    else: v, use = DEFAULT, 'default vector (WRAM only)'
    return p, pv, ev and e == p, v, use


def bands(v, g): return [v[g], v[4 + g], v[8 if g < 2 else 9], v[10], v[11]]


rows = []
src = [('ROM default vector', DEFAULT, True, True, DEFAULT, 'reference'), ('camera 1 (§18.13)', CAM1, True, True, CAM1, 'reference')]
for a in sys.argv[2:]:
    lab, path = a.split('=', 1); d = open(path, 'rb').read()
    src.append((lab,) + record(d))
for lab, p, pv, eq, v, use in src:
    for g in range(4):
        b = bands(v, g) if v else [None] * 5
        rows.append(dict(save=lab, vector=p.hex(' ').upper(), checksum_ok=pv, echo_equal=eq, rom_uses=use, probe_gain=g,
                         **{'band%d_ref' % k: ('%02X' % x if x is not None else '') for k, x in enumerate(b)},
                         **{'step_%d_%d' % (k, k + 1): ('%+d' % (b[k + 1] - b[k]) if v else '') for k in range(4)}))
with open(sys.argv[1], 'w', newline='', encoding='utf-8') as fh:
    w = csv.DictWriter(fh, fieldnames=list(rows[0].keys()), lineterminator='\n'); w.writeheader(); w.writerows(rows)
for r in rows:
    if r['probe_gain'] == 0:
        print('%-26s %s  ok=%s echo=%s  %s' % (r['save'], r['vector'], r['checksum_ok'], r['echo_equal'], r['rom_uses']))
        print('%-26s g=0 bands %s  steps %s' % ('', ' '.join(r['band%d_ref' % k] for k in range(5)), ' '.join(r['step_%d_%d' % (k, k + 1)] for k in range(4))))
