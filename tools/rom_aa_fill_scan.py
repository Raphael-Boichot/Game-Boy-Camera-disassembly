#!/usr/bin/env python3
"""Can a camera ROM write the factory $AA fill or the `1B 13` tolerances itself? (2026-11-22)

  tools/rom_aa_fill_scan.py ROM [SYM] [ROM [SYM] ...]

Lists, for each ROM, every immediate load of $AA (`ld r,$AA`, opcodes 06/0E/16/1E/26/2E/3E AA), every 16-bit load of
$AAAA (01/11/21 AA AA) and every raw pair `1B 13` (which covers `ld rr,$131B`), each with its bank:address and, when a
.sym file is given, the label it falls in (label + offset). A fill of SRAM with $AA needs one of the first two (or a fill
value read from data, which this scan does not cover); `1B 13` written as a constant needs the pair somewhere. Reading
the hits against the disassembly is left to the reader (docs/03 §3.3 lists the verdict for the ROMs of the project).
"""
import bisect, re, sys
def load_sym(path):
    s = []
    for l in open(path, errors='replace'):
        m = re.match(r'([0-9A-Fa-f]{2}):([0-9A-Fa-f]{4}) (\S+)', l)
        if m:
            b, a = int(m[1], 16), int(m[2], 16)
            if a < 0x8000: s.append((a if b == 0 else b * 0x4000 + a - 0x4000, m[3]))
    s.sort(); return s
def where(x): b = x // 0x4000; return '%02X:%04X' % (b, x % 0x4000 + (0x4000 if b else 0))
args = sys.argv[1:]; jobs = []
while args:
    rom = args.pop(0); sym = args.pop(0) if args and args[0].endswith('.sym') else None; jobs.append((rom, sym))
for rom, sym in jobs:
    d = open(rom, 'rb').read(); S = load_sym(sym) if sym else []; K = [k for k, _ in S]
    def lab(x):
        i = bisect.bisect_right(K, x) - 1
        return '%s+%X' % (S[i][1], x - S[i][0]) if i >= 0 else ''
    hits = [(m.start(), 'ld %s,$AA' % 'bcdehl?a'[(d[m.start()] >> 3) & 7]) for m in re.finditer(rb'[\x06\x0e\x16\x1e\x26\x2e\x3e]\xaa', d)]
    hits += [(m.start(), 'ld %s,$AAAA' % {1: 'bc', 0x11: 'de', 0x21: 'hl'}[d[m.start()]]) for m in re.finditer(rb'[\x01\x11\x21]\xaa\xaa', d)]
    hits += [(m.start(), 'bytes 1B 13') for m in re.finditer(rb'\x1b\x13', d)]
    print('## %s (%d hits)' % (rom, len(hits)))
    for x, what in sorted(hits): print('  %s  %-12s %s  %s' % (where(x), what, d[max(0, x - 3):x + 8].hex(' '), lab(x)))
