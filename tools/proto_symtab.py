#!/usr/bin/env python3
"""Extract the two leftover linker symbol tables of the early prototype (Pocket Camera Prototype (Japan), "DEBAGAME").

  python3 tools/proto_symtab.py PROTO.gb [--out roms/prototype_debagame/disasm/leftover_symtab_proto.csv]

PROTO.gb is the as-dumped image (md5 19b50a5f67ef4f0d015e7d813370756e); the BGB copy with the patched header
(1d8097de3497db8b182bcd2a984b6063) gives the same rows, the six header bytes are outside the tables.

Record format (read from the bytes, C): one length byte L, L name bytes (ASCII), one kind byte ($10 = label, $18 = constant
defined with EQU, $00 = 2 records, not decoded), one byte that is 0..6 (a bank or a section number, not decoded), then the value as a little-endian word.
A table is a run of at least 5 records that follow each other with no gap. Two runs exist: bank $2A (674 records) and bank $35
(705 records), both sorted by name from ABORTFLAG to ZERO0. They are the symbol lists of two OLDER builds: the bank-0 code
addresses they give are not the routine starts of this ROM (under 2 % of them are a call / jp target of the bank-0 code),
while the HRAM and I/O values agree between the two tables (README of the prototype folder). Every row is therefore a name
CANDIDATE, evidence I, until the code of this build confirms it.

In-memory fragments (2026-11-12, --out-mem): the same record layout with kind $D0 (label) / $D8 (EQU constant), the two kinds of the
tables with bits 7-6 set (I: the linker's symbol list as held in the PC's memory); runs of 5+ records with no gap, in the leftover
banks $11 and $1E. The bank $1E run agrees with table $2A; the bank $11 runs are a third build (20 of their 34 values differ from
both tables, e.g. MABIKI2 $C0D6, $C0D0 in both). Columns: table (bank
of the run), file_offset, name, kind, byte2, value, space, same_in_2A, same_in_35.

Columns: table (2A / 35), file_offset, name, kind (label / equ / other), byte2, value, space (ROM0 / ROMX / VRAM / SRAM / WRAM / HRAM-IO /
OTHER for a value below $8000 that is a number, not decided here), same_in_other (yes / no / absent: the other table has the
same name with the same kind and value).
"""
import argparse, csv, hashlib, os, re, sys

AS_DUMPED = '19b50a5f67ef4f0d015e7d813370756e'; BGB_COPY = '1d8097de3497db8b182bcd2a984b6063'
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
ap = argparse.ArgumentParser()
ap.add_argument('rom')
ap.add_argument('--out', default=os.path.join(REPO, 'roms', 'prototype_debagame', 'disasm', 'leftover_symtab_proto.csv'))
ap.add_argument('--out-mem', default=os.path.join(REPO, 'roms', 'prototype_debagame', 'disasm', 'leftover_symtab_mem_proto.csv'))
a = ap.parse_args()
p = open(a.rom, 'rb').read()
if hashlib.md5(p).hexdigest() not in (AS_DUMPED, BGB_COPY): sys.exit('%s: not the prototype (md5 %s or %s)' % (a.rom, AS_DUMPED, BGB_COPY))

NAME = re.compile(rb'[A-Za-z_][A-Za-z0-9_@.?]*')
recs, i = [], 0
while i < len(p) - 5:
    L = p[i]
    if 2 <= L <= 32 and i + 5 + L <= len(p) and NAME.fullmatch(p[i + 1:i + 1 + L]) and p[i + 1 + L] in (0x00, 0x10, 0x18) and p[i + 2 + L] <= 6:
        recs.append((i, p[i + 1:i + 1 + L].decode(), p[i + 1 + L], p[i + 2 + L], p[i + 3 + L] | p[i + 4 + L] << 8)); i += 5 + L
    else:
        i += 1
runs, cur = [], []
for r in recs:
    if cur and r[0] == cur[-1][0] + 5 + len(cur[-1][1]): cur.append(r)
    else:
        if len(cur) >= 5: runs.append(cur)
        cur = [r]
if len(cur) >= 5: runs.append(cur)

def space(kind, v):
    if v >= 0xFF00: return 'HRAM-IO'
    if kind == 0x18 and v < 0x8000: return 'OTHER'
    return 'ROM0' if v < 0x4000 else 'ROMX' if v < 0x8000 else 'VRAM' if v < 0xA000 else 'SRAM' if v < 0xC000 else 'WRAM' if v < 0xE000 else 'OTHER'

tables = {'%02X' % (r[0][0] >> 14): r for r in runs}
os.makedirs(os.path.dirname(a.out), exist_ok=True)
with open(a.out, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n')
    w.writerow(['table', 'file_offset', 'name', 'kind', 'byte2', 'value', 'space', 'same_in_other'])
    for t, rows in tables.items():
        other = [{x[1]: x for x in v} for k, v in tables.items() if k != t]
        for o, n, k, b2, v in rows:
            x = other[0].get(n) if other else None
            same = 'absent' if x is None else 'yes' if (x[2], x[4]) == (k, v) else 'no'
            w.writerow([t, '%05X' % o, n, {0x10: 'label', 0x18: 'equ'}.get(k, 'other'), b2, '%04X' % v, space(k, v), same])
for t, rows in tables.items():
    print('table %s: %d records, %s .. %s' % (t, len(rows), rows[0][1], rows[-1][1]))
print('wrote', os.path.relpath(a.out, REPO))

mrecs, i = [], 0                                  # in-memory fragments: kinds $D0 / $D8
while i < len(p) - 5:
    L = p[i]
    if 2 <= L <= 32 and i + 5 + L <= len(p) and NAME.fullmatch(p[i + 1:i + 1 + L]) and p[i + 1 + L] in (0xD0, 0xD8) and p[i + 2 + L] <= 6:
        mrecs.append((i, p[i + 1:i + 1 + L].decode(), p[i + 1 + L] & 0x3F, p[i + 2 + L], p[i + 3 + L] | p[i + 4 + L] << 8)); i += 5 + L
    else:
        i += 1
mruns, cur = [], []
for r in mrecs:
    if cur and r[0] == cur[-1][0] + 5 + len(cur[-1][1]): cur.append(r)
    else:
        if len(cur) >= 5: mruns.append(cur)
        cur = [r]
if len(cur) >= 5: mruns.append(cur)
with open(a.out_mem, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n')
    w.writerow(['table', 'file_offset', 'name', 'kind', 'byte2', 'value', 'space', 'same_in_2A', 'same_in_35'])
    old = {k: {x[1]: x for x in v} for k, v in tables.items()}
    for run in mruns:
        for o, n, k, b2, v in run:
            sm = []
            for t in ('2A', '35'):
                x = old.get(t, {}).get(n); sm.append('absent' if x is None else 'yes' if (x[2], x[4]) == (k, v) else 'no')
            w.writerow(['%02X' % (o >> 14), '%05X' % o, n, {0x10: 'label', 0x18: 'equ'}.get(k, 'other'), b2, '%04X' % v, space(k, v)] + sm)
for run in mruns:
    print('in-memory fragment at %05X (bank %02X): %d records, %s .. %s' % (run[0][0], run[0][0] >> 14, len(run), run[0][1], run[-1][1]))
print('wrote', os.path.relpath(a.out_mem, REPO))
