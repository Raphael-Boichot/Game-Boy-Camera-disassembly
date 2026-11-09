#!/usr/bin/env python3
"""L1 typing of the early prototype (image as dumped) from its trace: tables, copy sources, self-test bytes, leftover text and symbol tables.

  tools/proto_types.py PROTO.gb roms/prototype_debagame/trace/trace_proto.json --types roms/prototype_debagame/disasm/sym_types_proto.csv \
        --sites roms/prototype_debagame/assets/copy_sites_proto.csv --rommap roms/prototype_debagame/trace/rom_map_proto.csv \
        --names roms/prototype_debagame/disasm/sym_names_proto.csv --symtab roms/prototype_debagame/disasm/leftover_symtab_proto.csv

All outputs are generated (never edit them; hand rows go in disasm/sym_types_proto_hand.csv, applied after these by sym_build.py).
  copy_sites_proto.csv  every traced call of a copy routine with the constants found on the straight line before it
                        (bank, source, destination, length; '' = not a constant), the routine and the kind of destination
  sym_types_proto.csv   bank,start,end,type,width,note rows, in this order (a later row wins in sym_build.py):
     0. data   the cartridge header 00:0104-014F (no label: it belongs to Entry, as in the Japanese ROM)
     1. text   runs of 32 or more bytes that are printable ASCII (with tab, CR, LF) or Shift-JIS pairs (lead $81-$9F / $E0-$EF, trail
               $40-$7E / $80-$FC), lie outside the code, tables and copy sources, hold at least one CR LF line end and at least 8
               distinct byte values: the developers' leftover text (source lines, assembler listings). Typed by the bytes only.
               Runs without a line end stay data: byte tables of bank 0 (00:17A1, 00:1904) and tile-like patterns (04:4340) are
               printable too, and short NUL-separated strings (the DOS environment) are under 32 bytes or have no line end.
     2. data   the two leftover linker symbol tables (records listed by tools/proto_symtab.py), one row per table.
     3. data   the bank-number bytes $4000 and $7FFF of banks $01-$3F where both hold the bank number: the ROM self-test 00:06F5 reads them.
     4. data,2 the word tables the trace reads (hand jump table 00:3822 of extra_roots_proto.json).
     5. data   the OAM DMA stub 00:0317-0320, copied to HRAM $FFB6 at boot by 00:01A1 (it runs from HRAM, never from ROM).
     6. copy sources with a constant bank, source and length: 2bpp tiles (`data,16`, note `Gfx: ...`) when the destination is
        $8000-$97FF, tile-map rows (`data,32`, note `Map: ...`) when it is $9800-$9FFF, plain `data` otherwise.
  --names    one label per typed block, with the Japanese ROM's prefixes (owner, 2026-11-09): Text_BB_AAAA (kind 1), OldSymbolTable_BB_AAAA (2),
             BankNumber_BB_4000 / _7FFF (3), JumpTable_BB_AAAA (4), Data_00_0317 (5), Gfx_BB_AAAA / Map_BB_AAAA / Data_BB_AAAA (6); tag C:
             the kind is what the bytes are or what the traced code does with them. tools/proto_names.py adds the developers' names as suffixes.
  --rommap   the byte classes of the trace (bank,start,length,class: C code, T inline table, R the rest) for tools/status_maps.py.
Copy routines (bank 0, read in the listing 2026-11-08):
  $02B9  HL = source, DE = destination, BC = byte count, in the bank mapped at the call (`ld a,[hl+]; ld [de],a; inc de; dec bc`)
  $2EF5  HL = source, DE = destination, B = number of 256-byte pages (unrolled `ld a,[hl+]; ld [de],a; inc e` x 256, then
         `inc d; dec b; jp nz,$2EF5`); all its traced callers enter at $2EF5
The bank of a source at $4000-$7FFF is the bank context the trace recorded at the call site; a site with several contexts or none
is listed with an empty bank and types nothing.
"""
import sys, json, csv, argparse, collections, os, hashlib
ap = argparse.ArgumentParser()
ap.add_argument('rom'); ap.add_argument('trace'); ap.add_argument('--types', required=True); ap.add_argument('--sites', required=True)
ap.add_argument('--names', required=True); ap.add_argument('--rommap', required=True); ap.add_argument('--symtab', required=True)
a = ap.parse_args()
ROM = open(a.rom, 'rb').read(); T = json.load(open(a.trace))
if hashlib.md5(ROM).hexdigest() != '19b50a5f67ef4f0d015e7d813370756e': sys.exit('proto_types: expected the prototype as dumped (md5 19b50a5f...)')
def off(b, ad): return ad if ad < 0x4000 else b * 0x4000 + ad - 0x4000
def byte(b, ad): return ROM[off(b, ad)]
def word(b, ad): return byte(b, ad) | byte(b, ad + 1) << 8
def K(s): return int(s[:2], 16), int(s[3:], 16)
def lo_hi(b): return (0, 0x4000) if b == 0 else (0x4000, 0x8000)
code = {K(k): n for k, n in T['code'].items()}
ctx = {K(k): v.split() for k, v in T.get('context', {}).items()}
ENDS = {0xC3, 0xC9, 0xD9, 0xE9, 0x18}
pred = {}; targets = set(K(k) for k in T['entries'])
for (b, ad), n in code.items():
    op = byte(b, ad)
    if op in (0x18, 0x20, 0x28, 0x30, 0x38): targets.add((b, (ad + 2 + (byte(b, ad + 1) ^ 0x80) - 0x80) & 0xFFFF))
    if op in (0xC2, 0xC3, 0xCA, 0xD2, 0xDA): targets.add((0 if word(b, ad + 1) < 0x4000 else b, word(b, ad + 1)))
    if op not in ENDS and (b, ad + n) in code: pred[(b, ad + n)] = (b, ad)
def writes(op, op2):
    R = ['b', 'c', 'd', 'e', 'h', 'l', None, 'a']
    if op == 0xCB: return {R[op2 & 7]} - {None} if op2 >> 6 != 1 else set()
    w = set()
    if 0x40 <= op <= 0x7F and op != 0x76 and R[(op >> 3) & 7]: w.add(R[(op >> 3) & 7])
    if 0x80 <= op <= 0xB7: w.add('a')
    for o, r in {0x01: 'bc', 0x11: 'de', 0x21: 'hl', 0xC1: 'bc', 0xD1: 'de', 0xE1: 'hl', 0xF1: 'a', 0x03: 'bc', 0x0B: 'bc', 0x13: 'de', 0x1B: 'de', 0x23: 'hl',
                 0x2B: 'hl', 0x09: 'hl', 0x19: 'hl', 0x29: 'hl', 0x39: 'hl', 0xF8: 'hl', 0x22: 'hl', 0x2A: 'hla', 0x32: 'hl', 0x3A: 'hla', 0x04: 'b', 0x05: 'b',
                 0x06: 'b', 0x0C: 'c', 0x0D: 'c', 0x0E: 'c', 0x14: 'd', 0x15: 'd', 0x16: 'd', 0x1C: 'e', 0x1D: 'e', 0x1E: 'e', 0x24: 'h', 0x25: 'h', 0x26: 'h',
                 0x2C: 'l', 0x2D: 'l', 0x2E: 'l', 0x3C: 'a', 0x3D: 'a', 0x3E: 'a'}.items():
        if op == o: w |= set(r)
    if op in (0x0A, 0x1A, 0x07, 0x0F, 0x17, 0x1F, 0x27, 0x2F, 0xC6, 0xCE, 0xD6, 0xDE, 0xE6, 0xEE, 0xF6, 0xF0, 0xF2, 0xFA): w.add('a')
    return w
def const(b, ad, reg):
    """value of reg (b, bc, de, hl) at the instruction (b, ad), from the straight line before it, else None"""
    cur = pred.get((b, ad)); n = 0
    while cur is not None and n < 40:
        cb, ca = cur; op = byte(cb, ca); op2 = byte(cb, ca + 1)
        if op in (0xCD, 0xC4, 0xCC, 0xD4, 0xDC) or (op >= 0xC7 and op & 7 == 7): return None
        w = writes(op, op2)
        if reg == 'b' and 'b' in w: return byte(cb, ca + 1) if op == 0x06 else word(cb, ca + 1) >> 8 if op == 0x01 else None
        if len(reg) == 2 and (reg[0] in w or reg[1] in w):
            return word(cb, ca + 1) if op == {'bc': 0x01, 'de': 0x11, 'hl': 0x21}[reg] else None
        if cur in targets: return None
        cur = pred.get(cur); n += 1
    return None

# ---- copy sites
sites = []
for (b, ad), n in sorted(code.items()):
    if byte(b, ad) != 0xCD or word(b, ad + 1) not in (0x02B9, 0x2EF5): continue
    t = word(b, ad + 1); src, dst = const(b, ad, 'hl'), const(b, ad, 'de')
    if t == 0x02B9: ln = const(b, ad, 'bc')
    else: pg = const(b, ad, 'b'); ln = None if pg is None else (pg or 256) * 256
    if src is None: bank = None
    elif src < 0x4000: bank = 0
    elif src < 0x8000: c = ctx.get((b, ad), []); bank = int(c[0], 16) if b == 0 and len(c) == 1 else b if b else None
    else: bank = None                     # RAM source: nothing to type in the ROM
    kind = '' if dst is None else 'tiles' if 0x8000 <= dst < 0x9800 else 'map' if 0x9800 <= dst < 0xA000 else 'oam' if 0xFE00 <= dst < 0xFEA0 else \
           'wram' if 0xC000 <= dst < 0xE000 else 'sram' if 0xA000 <= dst < 0xC000 else 'other'
    sites.append({'bank': '%02X' % b, 'site': '%04X' % ad, 'routine': '%04X' % t, 'src_bank': '' if bank is None else '%02X' % bank,
                  'src': '' if src is None else '%04X' % src, 'dst': '' if dst is None else '%04X' % dst, 'len': '' if ln is None else '%04X' % ln, 'dst_kind': kind})
os.makedirs(os.path.dirname(a.sites), exist_ok=True)
with open(a.sites, 'w', newline='') as f:
    w = csv.DictWriter(f, ['bank', 'site', 'routine', 'src_bank', 'src', 'dst', 'len', 'dst_kind'], lineterminator='\n'); w.writeheader(); w.writerows(sites)

# ---- occupied bytes (code, inline tables, copy sources): text rows stay outside them
taken = set()
for (b, ad), n in code.items():
    for k in range(n): taken.add(off(b, ad + k))
for k_ in T['inline']: b, ad = K(k_); taken.add(off(b, ad))
srcs = collections.defaultdict(list)       # (bank, start) -> [(len, kind, site)]
for s in sites:
    if s['src_bank'] and s['src'] and s['len'] and int(s['src'], 16) < 0x8000:
        b, st, ln = int(s['src_bank'], 16), int(s['src'], 16), int(s['len'], 16)
        lo, hi = lo_hi(b)
        if lo <= st and st + ln <= hi:
            srcs[(b, st)].append((ln, s['dst_kind'], '%s:%s' % (s['bank'], s['site'])))
            for k in range(ln): taken.add(off(b, st + k))

rows = []; names = []
def add(b, s, e, typ, width, note):
    if e > s: rows.append(['%02X' % b, '%04X' % s, '%04X' % e, typ, '' if width is None else str(width), note])

# 0. the cartridge header (Nintendo logo, title, codes, checksums), read by the boot ROM and never by the program
add(0, 0x0104, 0x0150, 'data', None, 'cartridge header: Nintendo logo, title, codes, checksums (as dumped: MBC1, 256 KB, no RAM, global checksum 0)')
# 1. leftover text
def textlen(i):
    """length of the text unit at file offset i (1 ASCII, 2 Shift-JIS pair), 0 if not text"""
    c = ROM[i]
    if 0x20 <= c < 0x7F or c in (0x09, 0x0A, 0x0D): return 1
    if (0x81 <= c <= 0x9F or 0xE0 <= c <= 0xEF) and i + 1 < len(ROM) and (0x40 <= ROM[i + 1] <= 0x7E or 0x80 <= ROM[i + 1] <= 0xFC): return 2
    return 0
ntext = 0
for b in range(64):
    lo, hi = lo_hi(b); i = off(b, lo); end = off(b, lo) + 0x4000
    while i < end:
        j = i
        while j < end and j not in taken:
            L = textlen(j)
            if not L or j + L > end or (L == 2 and j + 1 in taken): break
            j += L
        if j - i >= 32 and b'\r\n' in ROM[i:j] and len(set(ROM[i:j])) >= 8:
            s_ = lo + (i - off(b, lo)); add(b, s_, s_ + (j - i), 'text', None, 'leftover text (ASCII / Shift-JIS bytes, not read by the traced code)'); ntext += j - i
            t0 = s_ + 1 if (s_ == 0x4000 and b and byte(b, 0x4000) == b and byte(b, 0x7FFF) == b) else s_     # the bank-number byte wins (row 3)
            names.append([b, t0, 'Text_%02X_%04X' % (b, t0), 'C', 'leftover text block, %d bytes (typed .text by its bytes: not read by the traced code)' % (s_ + (j - i) - t0)])
        i = j + 1 if j == i else j

# 2. the leftover symbol tables
tabs = collections.defaultdict(list)
for r in csv.DictReader(open(a.symtab)):
    o = int(r['file_offset'], 16); tabs[r['table']].append((o, o + 5 + len(r['name'])))
for t, recs in sorted(tabs.items()):
    s_, e_ = min(x[0] for x in recs), max(x[1] for x in recs); b = s_ >> 14
    add(b, 0x4000 + (s_ & 0x3FFF), 0x4000 + (e_ - 1 & 0x3FFF) + 1, 'data', None, 'leftover linker symbol table of an older build, %d records (disasm/leftover_symtab_proto.csv)' % len(recs))
    names.append([b, 0x4000 + (s_ & 0x3FFF), 'OldSymbolTable_%02X_%04X' % (b, 0x4000 + (s_ & 0x3FFF)), 'C', 'binary symbol table of an older build, %d records (tools/proto_symtab.py)' % len(recs)])

# 3. bank-number bytes read by the ROM self-test
nself = 0
for b in range(1, 64):
    if byte(b, 0x4000) == b and byte(b, 0x7FFF) == b:
        add(b, 0x4000, 0x4001, 'data', None, 'bank number, compared by the ROM self-test 00:06F5'); add(b, 0x7FFF, 0x8000, 'data', None, 'bank number, compared by the ROM self-test 00:06F5')
        names.append([b, 0x4000, 'BankNumber_%02X_4000' % b, 'C', 'the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)']); names.append([b, 0x7FFF, 'BankNumber_%02X_7FFF' % b, 'C', 'the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)']); nself += 1

# 4. word tables of the trace
for tk, recs in sorted(T['tables'].items()):
    b, ad = K(tk); add(b, ad, ad + 2 * len(recs), 'data', 2, 'jump table, %d words (proto_trace.py)' % len(recs))
    names.append([b, ad, 'JumpTable_%02X_%04X' % (b, ad), 'C', 'word table of the jump at 00:3821 (index masked to 0-31 at 00:380C)' if tk == '00:3822' else 'jump table'])

# 5. the OAM DMA stub
add(0, 0x0317, 0x0321, 'data', None, 'OAM DMA routine (ld a,$C0; ldh [$46],a; wait; ret), copied to HRAM $FFB6 by 00:01A1; runs from there')
names.append([0, 0x0317, 'Data_00_0317', 'C', 'OAM DMA routine copied to HRAM $FFB6 at boot (00:01A1); called as $FFB6'])

# 6. copy sources
for (b, st), lst in sorted(srcs.items()):
    ln = max(x[0] for x in lst); kinds = sorted(set(x[1] for x in lst)); who = ', '.join(sorted(set(x[2] for x in lst)))
    if kinds == ['tiles']: typ, wd, pre, note = 'data', 16, 'Gfx', 'Gfx: 2bpp tiles copied to VRAM by %s' % who
    elif kinds == ['map']: typ, wd, pre, note = 'data', 32, 'Map', 'Map: tile-map rows copied to the BG map by %s' % who
    else: typ, wd, pre, note = 'data', None, 'Data', 'copied (%s) by %s' % ('/'.join(k for k in kinds if k) or '?', who)
    if wd and ln % wd: wd = None
    add(b, st, st + ln, typ, wd, note)
    names.append([b, st, '%s_%02X_%04X' % (pre, b, st), 'C', note])

with open(a.types, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['bank', 'start', 'end', 'type', 'width', 'note']); w.writerows(rows)
with open(a.names, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['bank', 'addr', 'name', 'conf', 'note', 'source'])
    for b, ad, n_, c, note in sorted(names, key=lambda x: (x[0], x[1])): w.writerow(['%02X' % b, '%04X' % ad, n_, c, note, 'proto_types'])

# ---- rom map: C code, T inline tables, R the rest
cls = bytearray(b'R' * len(ROM))
for (b, ad), n in code.items():
    for k in range(n): cls[off(b, ad + k)] = ord('C')
for k_ in T['inline']: b, ad = K(k_); cls[off(b, ad)] = ord('T')
with open(a.rommap, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['bank', 'start', 'length', 'class'])
    for b in range(64):
        lo, _ = lo_hi(b); i = off(b, lo); end = i + 0x4000
        while i < end:
            j = i
            while j < end and cls[j] == cls[i]: j += 1
            w.writerow(['%02X' % b, '%04X' % (lo + i - off(b, lo)), j - i, chr(cls[i])]); i = j
cnt = collections.Counter(s['dst_kind'] for s in sites)
print('proto_types: %d copy sites %s, %d typed sources, %d type rows (%d text bytes in %d rows, %d banks with self-test bytes), %d names' % (
    len(sites), dict(cnt), len(srcs), len(rows), ntext, sum(1 for r in rows if r[3] == 'text'), nself, len(names)))
