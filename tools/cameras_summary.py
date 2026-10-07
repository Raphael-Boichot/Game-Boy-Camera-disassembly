#!/usr/bin/env python3
"""One CSV line per camera from a folder holding NAME.sav (128 KB SRAM) and NAME.sgb (1 MB ROM) pairs.

Usage:  python3 -I cameras_summary.py <dir> > cameras_summary.csv
Columns: camera, rom_md5, rom_version ($014C), sram class (fresh / clean-used / ATYPICAL / BATT-LOSS), unexpected non-AA bytes in the
never-written area, seed byte and its position on the boot-seed cycle, owner ID (8 digits), photos listed in the state vector,
FF0-FF1 of slot 3, calibration record position (normal AFF2 / shifted AFEC / invalid) and its 12-byte vector.
"""
import sys, os, glob, hashlib
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import sram_analyze as sa


def ck12(v):
    x = 0
    for a in v:
        x ^= a
    return bytes(((sum(v) + 0x0D) & 255, (x + 0x23) & 255))


def record(b):
    for name, base in (('normal', 0x4FF0), ('shifted', 0x4FEA)):
        v, c = b[base + 2:base + 14], b[base + 14:base + 16]
        if v != b'\xaa' * 12 and ck12(v) == c:
            return name, v.hex()
    return 'invalid', b[0x4FF2:0x4FFE].hex()


def main():
    d = sys.argv[1]
    orbit = sa.seed_orbit()
    print('camera,rom_md5,rom_version,sram_class,unexpected_nonAA,seed,seed_pos,owner_id,photos_listed,ff0_ff1,record,vector')
    for f in sorted(glob.glob(d + '/*.sav')):
        n = os.path.basename(f)[:-4]
        b = open(f, 'rb').read()
        rom = d + '/' + n + '.sgb'
        md5, ver = '', ''
        if os.path.exists(rom):
            r = open(rom, 'rb').read()
            md5, ver = hashlib.md5(r).hexdigest(), r[0x14C]
        u, t = sa.tail_unexpected(b)
        gf = sum(1 for x in b[0x11FC:0x1FFC] if x == 0xAA)
        cls = 'fresh' if (gf == 3584 and u == 0) else ('clean-used' if u == 0 else ('BATT-LOSS' if sa.is_battery_loss(b) else 'ATYPICAL'))
        sd = b[0x2FFF]
        pos = orbit.index(sd) if sd in orbit[:8] else ''
        oid = ''.join(str(((x >> 4) - 1) % 16) + str(((x & 15) - 1) % 16) for x in b[0x2FB8:0x2FBC])
        photos = sum(1 for x in b[0x11B2:0x11B2 + 30] if x != 0xFF)
        kind, vec = record(b)
        print(f'{n},{md5},{ver},{cls},{u},{sd:02x},{pos},{oid},{photos},{b[0x4FF0:0x4FF2].hex()},{kind},{vec}')


main()
