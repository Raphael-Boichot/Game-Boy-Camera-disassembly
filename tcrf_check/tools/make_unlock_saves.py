#!/usr/bin/env python3
"""Make 'unlocking' variants of the real saves: all counters / scores at their maximum BCD value (10BB-10CC = 99), the CoroCoro tag 56 56 53 at 01FFD-01FFF
(01FFC = AA as in the Universal_unlocking_save of the user's repo), settings block checksum and its echo recomputed (README section 3.1).
Unlock conditions (README section 3 / 10): album B counters (bank2 $4D05), CoroCoro flag D582 (bank 8 $72E0), Run!Run!Run! (mode $21), stamp category 3.
Usage: make_unlock_saves.py SAVDIR OUTDIR"""
import sys, os, glob
sys.path.insert(0, '/home/claude/gbcam_jp/tools')
import sram_analyze as S
src, out = sys.argv[1], sys.argv[2]; os.makedirs(out, exist_ok=True)
for f in sorted(glob.glob(os.path.join(src, '*.sav'))):
    b = bytearray(open(f, 'rb').read()); name = os.path.basename(f)[:-4]
    if not (S.blk_ok(b, 0x1000, 0xD7) or S.blk_ok(b, 0x10D9, 0xD7)):
        print(name, 'settings block invalid in both copies - skipped'); continue
    if not S.blk_ok(b, 0x1000, 0xD7): b[0x1000:0x10D9] = b[0x10D9:0x11B2]       # repair primary from the echo
    for a in range(0x10BB, 0x10CD): b[a] = 0x99                                  # taken, erased, transferred, printed, 10C3/10C4, SpaceFever, ball, run
    blk = bytes(b[0x1000:0x1000 + 0xD7]); blk += S.ck(blk, 0, 0xD7)
    b[0x1000:0x10D9] = blk; b[0x10D9:0x11B2] = blk
    b[0x1FFC:0x2000] = bytes([0xAA, 0x56, 0x56, 0x53])
    assert S.blk_ok(b, 0x1000, 0xD7) and S.blk_ok(b, 0x10D9, 0xD7)
    open(os.path.join(out, 'unl_' + name + '.sav'), 'wb').write(b)
    print(name, 'ok')
