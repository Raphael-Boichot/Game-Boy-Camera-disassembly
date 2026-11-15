#!/usr/bin/env python3
"""The prototype: where the two assembly listings that TCRF shows lie in the ROM, and the other copies of them (2026-11-15, owner:
"make a special category for the assembly code sections in clear identified by TCRF and search for potential other remaining sections").

  tools/proto_tcrf_source.py PROTO.gb LISTING1.txt LISTING2.txt [--out roms/prototype_debagame/assets/tcrf_source_proto.csv]

LISTING1 / LISTING2: the two listings of TCRF, Proto:Game Boy Camera, section Source Code (https://tcrf.net/Proto:Game_Boy_Camera),
as text files (UTF-8). The repository keeps no copy of them (owner rule: no TCRF content, only links); the owner's copies were
source/Unused_graphics_TCRF/TCRF_Prototype_{first,second}_big_chunk_assembly_code.txt, removed 2026-11-14 (git history).
Each listing line is encoded in Shift-JIS and looked for in the ROM in order, from every place of every 25th line (a copy may lack the start) (each next line within 3,000 bytes of the previous one,
across bank boundaries: the listings run on over them); a line that holds a character the transcription garbled is skipped.
The place where the most lines are found in order is the listing's own place (kind tcrf: C, its byte range is what TCRF shows);
any other place with half of the lines or more in order is a copy at another stage of the file (kind copy: the lines not found
there differ). Writes one row per place: listing, kind, bank, start, end bank, end (exclusive), bytes, lines looked for, lines found in order.
tools/proto_names.py names the text rows inside a tcrf range Unused_TCRF_AsmSource<n>[_Part<k>] (C) and the layout map draws them
in their own colour (TSRC); the copies stay Leftover_BB_AAAA_AsmSource.
"""
import argparse, csv, os, re, sys
ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('listings', nargs=2)
ap.add_argument('--out', default=os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'roms', 'prototype_debagame', 'assets', 'tcrf_source_proto.csv'))
a = ap.parse_args()
ROM = open(a.rom, 'rb').read()
def where(o): return o >> 14, 0x4000 + (o & 0x3FFF) if o >> 14 else o
rows = []
for n, path in enumerate(a.listings, 1):
    enc = []
    for l in open(path, encoding='utf-8', errors='replace').read().splitlines():
        if len(l.strip()) < 4: continue
        try: enc.append(l.encode('cp932'))
        except UnicodeEncodeError: pass                          # a character the transcription garbled
    def follow(seed):
        k0, start = seed; pos = start; first = last = None; ok = 0
        for b in enc[k0:]:
            i = ROM.find(b, pos, pos + 3000 + len(b))
            if i >= 0:
                ok += 1; first = i if first is None else first; last = i + len(b); pos = last
        return ok, first, last
    seeds = {(k, m.start()) for k in range(0, len(enc), 25) if len(enc[k]) >= 16 for m in re.finditer(re.escape(enc[k]), ROM)}   # a copy may lack the start
    found = sorted({follow(s) for s in seeds}, key=lambda x: (-x[0], x[1]))
    if not found or found[0][0] < len(enc) // 2: sys.exit('proto_tcrf_source: listing %d not found in the ROM' % n)
    best = found[0]; seen = []
    for ok, s, e in found:
        if ok < len(enc) // 2 or any(s < e2 and s2 < e for s2, e2 in seen): continue
        seen.append((s, e)); (b0, a0), (b1, a1) = where(s), where(e - 1)
        rows.append([n, 'tcrf' if (ok, s, e) == best else 'copy', '%02X' % b0, '%04X' % a0, '%02X' % b1, '%04X' % (a1 + 1), e - s, len(enc), ok])
with open(a.out, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['listing', 'kind', 'bank', 'start', 'end_bank', 'end', 'bytes', 'lines', 'lines_in_order']); w.writerows(rows)
for r in rows: print('  listing %d %-4s %s:%s-%s:%s %6d bytes, %d of %d lines in order' % (r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[8], r[7]))
print('proto_tcrf_source: %d places -> %s' % (len(rows), os.path.relpath(a.out)))
