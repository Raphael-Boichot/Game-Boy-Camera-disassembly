#!/usr/bin/env python3
"""Analysis helpers for Game Boy Camera / Pocket Camera 128 KB SRAM dumps.

Usage:  python3 -I sram_analyze.py <command> <dir-with-.sav-files> [more dirs]

Commands
  validity   per-save table: are the protected blocks (settings, vector, owner, 30 tags) valid?
  classify   per-save classification: fresh / clean used / atypical / BATTERY-LOSS (00 instead of AA), never-written-area (AA) status,
             Game Face status, CoroCoro tag, seed byte and its position on the boot-seed cycle
  calib      calibration-record (1B 13 + 12-byte vector + 2 checksum bytes) check, both copies
  settings   statistics of the settings-block fields (which bits / values are ever used)
  f34        photo checksum (F34-F35 = sum8, xor8 of the 3584 photo bytes) check per save
  all        everything above

Model of the file: flat offset = bank*0x2000 + (addr-0xA000); slot N (1..30) = 0x2000+(N-1)*0x1000.
Protected-block checksum (bank 2 $432F): lo = (sum8 of data incl. 'Magic') + 0x4E, hi = (xor8 of data) ^ 0x54.
Calibration vector checksum (bank 10 Cam_CommitVectorToSRAM): lo = sum8 + 0x0D, hi = xor8 + 0x23 over 12 bytes.
Boot seed (bank 0 $091A) : the byte at 0x2FFF is replaced at every boot by f(old); orbit below.
"""
import sys, glob, os, collections

MAGIC = b'Magic'
# 54-byte index table at ROM $0977 (Knuth-style initialisation order: (21*i) mod 55)
ROM_SEED_TAB = bytes.fromhex('14 29 07 1c 31 0f 24 02 17 2c 0a 1f 34 12 27 05 1a 2f 0d 22 00 15 2a 08 1d 32 10 25 03 18 '
                             '2d 0b 20 35 13 28 06 1b 30 0e 23 01 16 2b 09 1e 33 11 26 04 19 2e 0c 21')


def ck(b, lo, n):
    s = 0x4E
    x = 0x54
    for v in b[lo:lo + n]:
        s = (s + v) & 255
        x ^= v
    return bytes((s, x))


def slot_base(n):
    return 0x2000 + (n - 1) * 0x1000


def blk_ok(b, off, n):
    """protected block: n data bytes (last 5 = 'Magic'), then the 2 checksum bytes"""
    return b[off + n - 5:off + n] == MAGIC and b[off + n:off + n + 2] == ck(b, off, n)


def status(b):
    r = {}
    r['settings'] = (blk_ok(b, 0x1000, 0xD7), blk_ok(b, 0x10D9, 0xD7))
    r['vector'] = (blk_ok(b, 0x11B2, 0x23), blk_ok(b, 0x11D7, 0x23))
    r['owner'] = (blk_ok(b, 0x2FB8, 0x17), blk_ok(b, 0x2FD1, 0x17))
    r['tags'] = [(blk_ok(b, slot_base(n) + 0xF00, 0x5A), blk_ok(b, slot_base(n) + 0xF5C, 0x5A)) for n in range(1, 31)]
    return r


def load(dirs):
    d = {}
    for dd in dirs:
        for f in sorted(glob.glob(dd + '/**/*.sav', recursive=True)):
            b = open(f, 'rb').read()
            if len(b) == 0x20000:
                d[os.path.relpath(f, dd)] = b
    return d


def short(k, n=34):
    k = k.replace('Saves from used cameras/', 'U:').replace('Saves from cameras new from factory never used/', 'F:')
    return k[:n]


# ---------------------------------------------------------------- boot seed generator (bank 0 $091A..$09D3)
def _sw(a, m, d):
    r = a - m
    if r < 0:
        r = (((r + 256) & 255) + d) & 255
    return r


def seed_next(seed, rom_tab=None, d=255):
    """Re-implementation of the boot-time seeding: new value of byte 0x2FFF given the old one.
    The 54-byte index table (ROM $0977) is embedded above."""
    if rom_tab is None:
        rom_tab = ROM_SEED_TAB
    a = seed
    while a >= d:
        a -= d
    st = [0] * 55
    st[54] = a
    x, e = a, 1
    for c in rom_tab:
        st[c] = e
        e, x = _sw(x, e, d), e
    for _ in range(3):               # $09AD x3 (the loops never advance their pointers: only st[0], st[24] change)
        for _ in range(24):
            st[0] = _sw(st[0], st[31], d)
        for _ in range(31):
            st[24] = _sw(st[24], st[0], d)
    return st[0]                     # first draw ($08F9 with index 0)


def seed_orbit(start=0xAA, n=9):
    o = [start]
    for _ in range(n - 1):
        o.append(seed_next(o[-1]))
    return o


# ---------------------------------------------------------------- never-written area
def expected_nonAA(n, off):
    """tail-zone offsets (FB8-FFF of slot n) that a retail ROM legitimately writes"""
    return ((n == 1 and (0xFB8 <= off <= 0xFE9 or off == 0xFFF)) or
            (n == 3 and off >= 0xFF0) or (n == 16 and off >= 0xFF2))


def tail_unexpected(b, with_zeros=False):
    """(non-AA bytes, total) over the 2079 never-written bytes; with_zeros=True adds the count of 0x00 bytes."""
    unexp = tot = zeros = 0
    for n in range(1, 31):
        s = slot_base(n)
        for off in range(0xFB8, 0x1000):
            if expected_nonAA(n, off):
                continue
            tot += 1
            unexp += b[s + off] != 0xAA
            zeros += b[s + off] == 0
    return (unexp, tot, zeros) if with_zeros else (unexp, tot)


def is_battery_loss(b, threshold=0.75):
    """Rule given by the project owner: a 0x00 where a genuine camera keeps 0xAA means the SRAM was blanked by a battery
    loss (the battery has been replaced; the SRAM chip comes back as 00, not as the factory AA fill).
    Applied here as: >= 75 % of the 2079 never-written bytes are 0x00.
    Boot-seed corollary: a blank chip reads seed 00 and seed_next(0x00) = 0x95 = the 2nd value of the AA cycle, so the seed
    position (cmd_classify) of a battery-loss save is the number of boots since the battery change (mod 8)."""
    u, t, z = tail_unexpected(b, True)
    return z >= threshold * t


def cmd_validity(d):
    print(f"{'file':36s} set  vec  own  tagsOK/30 tagsBothBad")
    for k, b in d.items():
        r = status(b)
        f = lambda t: ''.join('Y' if x else '-' for x in t)
        ok = sum(1 for a, c in r['tags'] if a or c)
        print(f"{short(k):36s} {f(r['settings'])}   {f(r['vector'])}   {f(r['owner'])}   {ok:2d}        {30 - ok:2d}")


def cmd_classify(d):
    orbit = seed_orbit()
    print('boot-seed cycle:', ' -> '.join('%02X' % x for x in orbit))
    print(f"{'file':36s} class       unexpected-nonAA  GameFace-AA  1FFC-1FFF  seed  seed-position")
    for k, b in d.items():
        u, t = tail_unexpected(b)
        gf = sum(1 for x in b[0x11FC:0x1FFC] if x == 0xAA)
        fresh = gf == 3584 and u == 0
        cls = 'fresh' if fresh else ('clean-used' if u == 0 else ('BATT-LOSS' if is_battery_loss(b) else 'ATYPICAL'))
        sd = b[0x2FFF]
        pos = orbit.index(sd) if sd in orbit[:8] else '-'
        print(f"{short(k):36s} {cls:11s} {u:5d}/{t}         {gf:4d}/3584  {b[0x1FFC:0x2000].hex()}   {sd:02x}    {pos}")


def cmd_calib(d):
    print(f"{'file':36s} hdr@FF0 vector(12)                  chk   rule  echo-ok  hdr@FEA")
    for k, b in d.items():
        rec = b[0x4FF0:0x5000]
        v, c = rec[2:14], rec[14:16]
        s = (sum(v) + 0x0D) & 255
        x = 0
        for t in v:
            x ^= t
        ok = (s, (x + 0x23) & 255) == tuple(c)
        ec = b[0x11FF2:0x12000]
        print(f"{short(k):36s} {rec[:2].hex()}    {v.hex()} {c.hex()} {str(ok):5s} {str(ec == rec[2:]):5s}    {b[0x4FEA:0x4FEC].hex()}")


def cmd_settings(d):
    S = {k: b[0x1000:0x10D9] for k, b in d.items()}
    def stat(name, fn):
        print(f"  {name:28s}", dict(collections.Counter(fn(v) for v in S.values())))
    print(f'{len(S)} saves')
    stat('1061 & C0  (never written)', lambda v: v[0x61] & 0xC0)
    stat('1089 & C0  (never written)', lambda v: v[0x89] & 0xC0)
    stat('10A1 & 70  (NOISE env 6-4)', lambda v: v[0xA1] & 0x70)
    stat('1062 & 70  (SOUND I env 6-4)', lambda v: v[0x62] & 0x70)
    stat('10B7-10B8  (NOISE step bitmap)', lambda v: v[0xB7:0xB9].hex())
    stat('10CD-10CF  (dead bytes)', lambda v: v[0xCD:0xD0].hex())
    stat('102F  loop flag', lambda v: v[0x2F])
    stat('1060  border', lambda v: v[0x60])
    stat('10BA  preset saved', lambda v: v[0xBA])
    stat('10D1  Game Face flag', lambda v: v[0xD1])
    for nm, off in (('105F speed', 0x5F), ('10B9 tempo', 0xB9), ('10D0 print intensity', 0xD0)):
        vals = [v[off] for v in S.values()]
        print(f"  {nm:28s} min {min(vals):#04x} max {max(vals):#04x}")


def sx(data):
    s = x = 0
    for v in data:
        s = (s + v) & 255
        x ^= v
    return s, x


def cmd_f34(d):
    tot = collections.Counter()
    print(f"{'file':36s} used-slots match  zero  other-mismatch | F12-14!=0  F30-32!=0  F33==1")
    for k, b in d.items():
        vec = b[0x11B2:0x11B2 + 30]
        c = collections.Counter()
        for n in range(1, 31):
            s = slot_base(n)
            pri, ech = blk_ok(b, s + 0xF00, 0x5A), blk_ok(b, s + 0xF5C, 0x5A)
            if not (pri or ech):
                continue
            t = s + 0xF00 if pri else s + 0xF5C
            if vec[n - 1] != 0xFF:
                c['used'] += 1
                st = (b[t + 0x34], b[t + 0x35])
                if st == sx(b[s:s + 0xE00]):
                    c['match'] += 1
                elif st == (0, 0):
                    c['zero'] += 1
                else:
                    c['mismatch'] += 1
            c['f12'] += any(b[t + 0x12:t + 0x15])
            c['f30'] += any(b[t + 0x30:t + 0x33])
            c['f33'] += b[t + 0x33] == 1
        tot.update(c)
        if c['used'] or c['f12'] or c['f33']:
            print(f"{short(k):36s} {c['used']:5d} {c['match']:6d} {c['zero']:5d} {c['mismatch']:8d}       | {c['f12']:5d} {c['f30']:9d} {c['f33']:8d}")
    print(f"{'TOTAL':36s} {tot['used']:5d} {tot['match']:6d} {tot['zero']:5d} {tot['mismatch']:8d}       | {tot['f12']:5d} {tot['f30']:9d} {tot['f33']:8d}")


if __name__ == '__main__':
    cmds = {'validity': cmd_validity, 'classify': cmd_classify, 'calib': cmd_calib,
            'settings': cmd_settings, 'f34': cmd_f34}
    if len(sys.argv) < 3 or sys.argv[1] not in list(cmds) + ['all']:
        print(__doc__)
        sys.exit(1)
    d = load(sys.argv[2:])
    for name in (cmds if sys.argv[1] == 'all' else [sys.argv[1]]):
        print(f'\n===== {name} =====')
        cmds[name](d)
