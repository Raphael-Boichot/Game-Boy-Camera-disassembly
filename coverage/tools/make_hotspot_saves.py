#!/usr/bin/env python3
"""Make copies of the real saves in which the first used photo slots carry enabled hotspots (slot bytes F36-F53: flags, X, Y, sound, effect, jump), with the
tag block checksum and its echo recomputed (README section 3.3).  Purpose: the hotspot viewer (mode $0C) only runs the effect handlers (table 03:655D) when
a photo has an enabled hotspot; none of the real saves has one.   Usage: make_hotspot_saves.py SAVDIR OUTDIR"""
import sys as _s, os as _o
_s.path.insert(0, _o.path.join(_o.path.dirname(_o.path.abspath(__file__)), '..', 'src'))
import paths
import sys, os, glob, random
sys.path.insert(0, '' + paths.PKG + '/tools')
import sram_analyze as S
src, out = sys.argv[1], sys.argv[2]; os.makedirs(out, exist_ok=True); rng = random.Random(3)
EFFECTS = [[0, 1, 2, 3, 4], [5, 6, 0xFF, 0, 1], [2, 3, 4, 5, 6], [6, 5, 4, 3, 2], [0xFF, 0xFF, 1, 0, 6], [3, 3, 3, 3, 3]]
for f in sorted(glob.glob(os.path.join(src, '*.sav'))):
    b = bytearray(open(f, 'rb').read()); name = os.path.basename(f)[:-4]
    used = [i for i in range(30) if b[0x11B2 + i] < 30]          # vector entry = photo number, FF = empty
    n = 0
    for k, sl in enumerate(used[:6]):
        base = S.slot_base(sl + 1) + 0xF00
        if not (S.blk_ok(b, base, 0x5A) or S.blk_ok(b, base + 0x5C, 0x5A)): continue
        t = bytearray(b[base:base + 0x5C])
        t[0x36:0x3B] = bytes([1] * 5)                                  # enabled
        t[0x3B:0x40] = bytes([2, 5, 8, 11, 14]); t[0x40:0x45] = bytes([1, 3, 6, 9, 12])
        t[0x45:0x4A] = bytes(rng.choice([rng.randrange(64), 0xFF]) for _ in range(5))
        t[0x4A:0x4F] = bytes(EFFECTS[k % len(EFFECTS)])
        t[0x4F:0x54] = bytes(rng.choice([rng.randrange(30), 0xFF]) for _ in range(5))
        t[0x5A - 2 - 0:0x5A - 2 - 0] = b''
        # block = data 0x5A bytes (ending with 'Magic') + 2 checksum bytes
        data = bytes(t[:0x5A]); assert data[-5:] == b'Magic', (name, sl)
        blk = data + S.ck(data, 0, 0x5A)
        b[base:base + 0x5C] = blk; b[base + 0x5C:base + 0xB8] = blk
        assert S.blk_ok(b, base, 0x5A) and S.blk_ok(b, base + 0x5C, 0x5A)
        n += 1
    open(os.path.join(out, 'hs_' + name + '.sav'), 'wb').write(b)
    print(name, 'used slots', len(used), 'hotspot slots', n)
