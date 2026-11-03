#!/usr/bin/env python3
"""Unlocking saves for the Pocket Camera / Game Boy Camera: a Python port of the owner's Data_injector.m + checksum.m (Raphael Boichot, 2022,
github.com/Raphael-Boichot/Inject-pictures-in-your-Game-Boy-Camera-saves), as used for this project's saves_unl/unl_<camera>.sav.

usage: make_unlocked_saves.py OUTDIR SAVE [SAVE...] [--hello-kitty] [--calibrate] [--force]
  writes OUTDIR/unl_<basename of SAVE>.sav for every SAVE (128 KiB SRAM image)

Blocks (file offsets; Data_injector.m uses 1-based Matlab indices, converted here):
  default      Album B unlock: the 18 counter bytes $10BB-$10CC set to $99 in the settings block $1000-$10D6 and in its echo $10D9-$11AF (+$D9),
               each with its checksum (sum + $4E, xor ^ $54 over the 215 bytes ending in 'Magic', stored at $10D7-$10D8 / $11B0-$11B1; sram_analyze.blk_ok), and the CoroCoro tag
               $1FFD-$1FFF = 56 56 53 ("VVS").  These two are what the unlocking saves of the project carry: unl_CE10238211 (kept as
               tcrf_check/assets/bgb_printer/print_features/unl_CE10238211_tagtest.sav) differs from coverage/saves/CE10238211.sav in exactly
               these bytes, apart from the owner / photo fields of its own tag test at $19F00-$19FB7.
  --hello-kitty  the Hello Kitty Pocket Camera animation unlock of Data_injector.m: 23 bytes at $1000-$1016 (13 x $99, 60 00 00 00 00, "Magic"),
               main copy only ("no echo on this one").  On every other camera $1000-$102E is the slide-show list (README 16.19), so this
               block overwrites it: use it for the Hello Kitty ROM only.
  --calibrate  the "triggers sensor calibration" block: the 14 bytes $4FF2-$4FFF and $11FF2-$11FFF (SRAM banks 2 and 8, $AFF2 / $BFF2) set to $AA,
               which Cam_Calib_Loader (0A:46FD) reads as "no calibration": the next boot recalibrates the sensor (README 18).  Not unlocking.
The blocks Data_injector.m leaves commented out (unerase all images, camera id 66666666, a comment on the first image) are not ported.

checksum.m adjusts the stored sum / xor by the difference of each changed byte, which is right only if the stored checksum was valid: this
script checks both copies first (they hold for the 13 live saves of coverage/saves; CE10000843, the dead-battery save of
README 12, has no valid block) and refuses an invalid save unless --force, then recomputes both checksums from scratch after writing."""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from sram_analyze import blk_ok                 # the protected-block check ('Magic' + sum + $4E / xor ^ $54), one copy only

SET, ECHO, LEN = 0x1000, 0x10D9, 0xD7          # settings block, its echo (+$D9), 215 bytes covered by the checksum at +$D7 / +$D8

def check(b, base): return blk_ok(b, base, LEN)

def inject(b, start, ck, data):
    """checksum.m: write data at start and update the {sum, xor} pair at ck by the difference of each byte"""
    s, x = b[ck], b[ck + 1]
    for i, v in enumerate(data):
        s = (s - b[start + i] + v) & 0xFF; x ^= b[start + i] ^ v; b[start + i] = v
    b[ck], b[ck + 1] = s, x

def unlock(src, hello_kitty=False, calibrate=False, force=False):
    b = bytearray(open(src, 'rb').read())
    if len(b) != 0x20000: raise SystemExit('%s: %d bytes, not a 128 KiB camera SRAM image' % (src, len(b)))
    if not (check(b, SET) and check(b, ECHO)) and not force:
        raise SystemExit('%s: settings block or echo has an invalid checksum (dead battery?); --force to inject anyway' % src)
    if hello_kitty:
        inject(b, 0x1000, 0x10D7, [0x99] * 13 + [0x60, 0, 0, 0, 0] + list(b'Magic'))
    for base in (SET, ECHO):                                           # Album B counters, main copy and echo
        inject(b, base + 0xBB, base + LEN, [0x99] * 18)
    b[0x1FFD:0x2000] = b'VVS'                                           # CoroCoro tag 56 56 53 (no checksum)
    if calibrate:
        b[0x4FF2:0x5000] = b'\xAA' * 14; b[0x11FF2:0x12000] = b'\xAA' * 14
    if not force:
        assert check(b, SET) and check(b, ECHO), 'checksum after injection'
    return bytes(b)

def main():
    a = sys.argv[1:]
    flags = {f for f in a if f.startswith('--')}; a = [x for x in a if not x.startswith('--')]
    if len(a) < 2 or flags - {'--hello-kitty', '--calibrate', '--force'}: raise SystemExit(__doc__)
    out = a[0]; os.makedirs(out, exist_ok=True)
    for src in a[1:]:
        dst = os.path.join(out, 'unl_' + os.path.basename(src))
        try: data = unlock(src, '--hello-kitty' in flags, '--calibrate' in flags, '--force' in flags)
        except SystemExit as e: print('skip', e); continue
        open(dst, 'wb').write(data); print('wrote', dst)

if __name__ == '__main__':
    main()
