#!/usr/bin/env python3
"""BGB screenshots of the two hidden boot screens (docs 8): the factory calibration and the fast calibration sanity check.

  tcrf_check/tools/calib_screens_capture.py JP.gb OUTDIR        (env BGB_DIR, BGB_HF as for bgb_run.py)

Four runs of the Japanese ROM (SystemMode=0), each from a synthetic 128 KB save made here:
  factory_calibration_wait_bgb.bmp  save of $AA (both copies of the calibration record blank), no key, 400 frames: STORE / PLEASE WAIT
  factory_calibration_end_bgb.bmp   the same, 4,000 frames: STORE / END (the jr loop at 0A:6BDB)
  calib_sanity_check_ok_bgb.bmp     save of $AA, every button except B held through power-on ($FD), 4,000 frames
  calib_sanity_check_ng_bgb.bmp     save of $AA with the intense-light record of camera CE10245109 written at $04FF2 and $11FF2
                                    (vector + checksum, §18.13; the tolerance bytes $04FF0-$04FFF stay $AA), same keys
BGB has no sensor: its captures give the same readings every time (slot 10 / 11 = $0B), so the verdict depends on the save only:
|$AA - $0B| = 159 <= 170 = OK; |$BD - $0B| = 178 > 170 = NG.  The saves are synthetic (the vector bytes are the documented ones)."""
import os, sys, subprocess
HERE = os.path.dirname(os.path.abspath(__file__))
ROM, OUT = sys.argv[1], sys.argv[2]; os.makedirs(OUT, exist_ok=True)
VEC = bytes.fromhex('272C4E5B27335D6D809ABDB3')          # CE10245109, intense light (§18.13)
def cks(v):
    s = x = 0
    for b in v: s = (s + b) & 0xFF; x ^= b
    return bytes([(s + 0x0D) & 0xFF, (x + 0x23) & 0xFF])
aa = bytearray(b'\xaa' * 0x20000); ng = bytearray(aa)
for o in (0x4FF2, 0x11FF2): ng[o:o + 14] = VEC + cks(VEC)
for n, d in (('aa', aa), ('ng', ng)): open(os.path.join(OUT, n + '.sav'), 'wb').write(d)
runs = [('factory_calibration_wait_bgb', 'aa', 0, 400), ('factory_calibration_end_bgb', 'aa', 0, 4000),
        ('calib_sanity_check_ok_bgb', 'aa', 253, 4000), ('calib_sanity_check_ng_bgb', 'ng', 253, 4000)]
for name, sav, combo, free in runs:
    work = os.path.join(OUT, 'work_' + name); os.makedirs(work, exist_ok=True)
    s = os.path.join(work, 'in.sav'); open(s, 'wb').write(open(os.path.join(OUT, sav + '.sav'), 'rb').read())
    cmd = [sys.executable, os.path.join(HERE, 'bgb_run.py'), ROM, s, os.path.join(work, 'shot'), '-:1:0', '--free', str(free)] + (['--combo', str(combo)] if combo else [])
    print(name, subprocess.run(cmd, capture_output=True, text=True).stdout.strip().split('\n')[-1])
    os.replace(os.path.join(work, 'shot.bmp'), os.path.join(OUT, name + '.bmp'))
