#!/usr/bin/env python3
"""The bank-0 code of the prototype's older builds, named from their symbol tables (2026-11-12, roadmap step 5):
roms/prototype_debagame/disasm/oldbuilds_proto.csv.

  tools/proto_oldbuilds.py PROTO.gb [--out roms/prototype_debagame/disasm/oldbuilds_proto.csv]

Banks $2C and $37 hold the bank 0 of the builds of symbol tables $2A and $35 (README: 57 % / 51 % of the tables' bank-0 code labels are
call / jp targets there), banks $1D and $20 the bank 0 of two more builds without a table. tools/proto_printer_lib.py names the printer
library; this script does the same for every other label of the two tables whose value is below $4000:
  * in bank $2C (table $2A) / $37 (table $35), at value + $4000, unless the label falls inside bytes that are no longer that build's code
    (the PC memory or the source text that overwrote the start of bank $2C: a `_PcRam`, `_AsmSource`, `_SrcListing` label of
    disasm/sym_names_proto.csv holds the address): kind `code` when the bytes from the label to the next label decode with no opcode the
    Game Boy lacks and the instructions end exactly on the next label, or when an instruction of the same bank calls or jumps to it;
    `data` otherwise or when the name reads as data (TBL, TABLE, PAT, DATA, the dither and screw patterns, the save texts); a label that
    this build also has (bank 0) takes the kind it has here. Evidence C: the table gives the address and the name; the kind is read from the bytes (I).
  * in banks $1D and $20: each `code` routine of bank $2C searched with its 16-bit operands masked; the hit nearest to where the previous
    hit and the distance in bank $2C put it (the builds differ by inserted or removed bytes). Evidence I.
Columns: table, dev_name, kind, size (to the next label of the same table), addr (BB:AAAA), copy_1D, copy_20, called (yes / no: an
instruction of the same bank calls or jumps to it), why (when the label is skipped: inside PC memory or source text).
The printer library (SIOINT .. STARTSTRINGTRANS) is left to tools/proto_printer_lib.py.
"""
import argparse, bisect, csv, os, re
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); PD = os.path.join(REPO, 'roms', 'prototype_debagame')
ap = argparse.ArgumentParser(); ap.add_argument('rom')
ap.add_argument('--symtab', default=os.path.join(PD, 'disasm', 'leftover_symtab_proto.csv'))
ap.add_argument('--printer-lib', default=os.path.join(PD, 'disasm', 'printer_lib_proto.csv'))
ap.add_argument('--names', default=os.path.join(PD, 'disasm', 'sym_names_proto.csv'))
ap.add_argument('--out', default=os.path.join(PD, 'disasm', 'oldbuilds_proto.csv')); a = ap.parse_args()
P = open(a.rom, 'rb').read()
LEN = [1] * 256
for op in (0x01, 0x08, 0x11, 0x21, 0x31, 0xC2, 0xC3, 0xC4, 0xCA, 0xCC, 0xCD, 0xD2, 0xD4, 0xDA, 0xDC, 0xEA, 0xFA): LEN[op] = 3
for op in (0x06, 0x0E, 0x16, 0x1E, 0x26, 0x2E, 0x36, 0x3E, 0x10, 0x18, 0x20, 0x28, 0x30, 0x38, 0xC6, 0xCB, 0xCE, 0xD6, 0xDE, 0xE0, 0xE6,
           0xE8, 0xEE, 0xF0, 0xF6, 0xF8, 0xFE): LEN[op] = 2
ADDR16 = {0x01, 0x08, 0x11, 0x21, 0x31, 0xC2, 0xC3, 0xC4, 0xCA, 0xCC, 0xCD, 0xD2, 0xD4, 0xDA, 0xDC, 0xEA, 0xFA}
ILL = {0xD3, 0xDB, 0xDD, 0xE3, 0xE4, 0xEB, 0xEC, 0xED, 0xF4, 0xFC, 0xFD}
EXIT = {0xC9, 0xD9, 0xC3, 0x18, 0xE9}
def hx(o): return '%02X:%04X' % (o >> 14, 0x4000 + (o & 0x3FFF))
def decodes(o, e):
    k, last = o, None
    while k < e:
        op = P[k]
        if op in ILL: return False
        last = op; k += LEN[op]
    return k == e                                    # instruction boundaries meet the next label (a routine may fall into the next one)
def pattern(o, e):
    pat, k = b'', o
    while k < e:
        op = P[k]; ln = min(LEN[op], e - k)
        pat += re.escape(bytes([op])) + (b'..' if op in ADDR16 and ln == 3 else b'.' if op in (0xE0, 0xF0) and ln == 2 else re.escape(P[k + 1:k + ln]))
        k += ln
    return re.compile(pat, re.S)
def targets(bank):                                   # call / jp / jr targets inside a bank (old bank-0 code: operand values below $4000)
    t = set(); base = bank * 0x4000
    for k in range(base, base + 0x4000 - 2):
        op = P[k]
        if op in (0xCD, 0xC3, 0xC2, 0xCA, 0xD2, 0xDA, 0xC4, 0xCC, 0xD4, 0xDC):
            v = P[k + 1] | P[k + 2] << 8
            if v < 0x4000: t.add(base + v)
    return t
S = list(csv.DictReader(open(a.symtab)))
lib = {r['dev_name'] for r in csv.DictReader(open(a.printer_lib))} if os.path.exists(a.printer_lib) else set()
over = []                                            # spans of bytes that are no longer old code (PC memory, source text)
NM = sorted((int(r['bank'], 16) * 0x4000 + int(r['addr'], 16) - (0x4000 if r['bank'] != '00' else 0), r['name']) for r in csv.DictReader(open(a.names)))
NO = [o for o, _ in NM]
def overwritten(o):
    i = bisect.bisect_right(NO, o) - 1
    return i >= 0 and re.search(r'_(PcRam|AsmSource|SrcListing)$', NM[i][1]) is not None
# names that are data: this build's own data labels of the same name (tools/proto_match_old.py found them as data), or a data-like name
CODE0 = set()
for r in csv.DictReader(open(os.path.join(PD, 'trace', 'rom_map_proto.csv'))):
    if r['class'] == 'C': o_ = int(r['bank'], 16) * 0x4000 + int(r['start'], 16) - (0x4000 if r['bank'] != '00' else 0); CODE0.update(range(o_, o_ + int(r['length'])))
PKIND = {n: ('code' if o in CODE0 else 'data') for o, n in NM if o < 0x4000}
DATARE = re.compile(r'(TBL|TABLE|_PAT|PAT_|PAT$|DATA$|_DATA|_OBJ$|SURU|NANBANNI|SIMASITA|^DITH_P|^EDGE\d|^VREF\d|^ZERO\d|^REV\d|^BAYER|^HALF|^SCREW|^DEFAULT_|^CHG_TIME)')
rows = []
for t, bank in (('2A', 0x2C), ('35', 0x37)):
    L = sorted({(int(r['value'], 16), r['name']) for r in S if r['table'] == t and r['kind'] == 'label' and int(r['value'], 16) < 0x4000})
    tg = targets(bank); seen = set()
    for i, (v, n) in enumerate(L):
        nv = next((x for x, _ in L[i + 1:] if x > v), 0x4000)
        if v in seen: continue                       # two names on one address: the first (alphabetical)
        seen.add(v)
        if n in lib: continue
        o = bank * 0x4000 + v; e = bank * 0x4000 + nv
        if v < 0x0150 or overwritten(o):
            rows.append([t, n, 'skipped', nv - v, hx(o), '', '', '', 'inside the PC memory or the source text that overwrote this part of the bank' if v >= 0x0150 else 'below $0150 (vectors, header)']); continue
        called = o in tg
        if n in PKIND: kind = PKIND[n]                    # this build's label of the same name: its kind
        else: kind = 'code' if (decodes(o, e) or called) and not DATARE.search(n) else 'data'
        rows.append([t, n, kind, nv - v, hx(o), '', '', 'yes' if called else 'no', ''])
# copies of the bank $2C code in banks $1D and $20: in the order of bank $2C, each near where the previous one put it
code2C = [r for r in rows if r[0] == '2A' and r[2] == 'code']
code2C.sort(key=lambda r: r[4])
for col, bk in ((5, 0x1D), (6, 0x20)):
    prev = None
    for r in code2C:
        o = 0x2C * 0x4000 + int(r[4][3:], 16) - 0x4000; e = o + int(r[3])
        if e - o < 6: continue                       # a `ret` alone matches anywhere
        pat = pattern(o, e); base = bk * 0x4000
        hits = [m.start() for m in pat.finditer(P, base, base + 0x4000)]
        if not hits: continue
        exp = prev[0] + (o - prev[1]) if prev else base + (o - 0x2C * 0x4000)
        h = min(hits, key=lambda x: abs(x - exp))
        if prev and abs(h - exp) > 0x200 and len(hits) > 1: continue
        r[col] = hx(h); prev = (h, o)
with open(a.out, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n')
    w.writerow(['table', 'dev_name', 'kind', 'size', 'addr', 'copy_1D', 'copy_20', 'called', 'why']); w.writerows(rows)
import collections
c = collections.Counter((r[0], r[2]) for r in rows)
print('proto_oldbuilds: %s; copies of the $2C code in $1D %d, in $20 %d' % (', '.join('%s %s %d' % (k[0], k[1], v) for k, v in sorted(c.items())),
      sum(1 for r in rows if r[5]), sum(1 for r in rows if r[6])))
