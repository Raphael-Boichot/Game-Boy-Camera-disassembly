#!/usr/bin/env python3
"""The SRAM access table of a ROM, from its proven code (the SRAM counterpart of tools/wram_db.py; HOWTO_NEW_ROM.md section 0.1).

  tools/sram_db.py ROM.gb TRACE.json SYM OUT.csv

One row per proven instruction whose 16-bit operand is an address of the cartridge RAM window $A000-$BFFF:
  kind  R = ld a,[nn]; W = ld [nn],a; P = ld rr,nn (the address is used as a base: a block copy, a checksum loop, a field record)
  ram_bank  the RAM bank the instruction sees, when the straight-line code just before it selects one with a constant: a write to
            $4000-$5FFF (`ld [$4000],a`, `ld [hl],n` or `ld [hl],a` with HL = $4000-$5FFF) of a known value of A or n, found by
            walking back over at most 24 instructions of the same straight line (no label, no call in between); empty when the bank
            comes from a variable, a register argument or a caller (read the code: docs §3.5 names those routines)
  flat      bank x $2000 + (address - $A000) when the bank is known and below $10; RAM bank $10 is the sensor register window
            (`sensor` in the column), not memory
  function  the routine that holds the instruction (the trace entry before it, with its name from SYM)
Accesses through HL / DE / BC after an arithmetic step are not in the table (the P row of the base is).
"""
import sys, json, csv, bisect, collections
sys.path.insert(0, __file__.rsplit('/', 1)[0])
from rom_trace import Rom, load_sym
A_WRITERS = set(range(0x78, 0x80)) | set(range(0x80, 0xB8)) | {0x0A, 0x1A, 0x2A, 0x3A, 0x7E, 0xF0, 0xF2, 0xFA, 0xF1, 0x3C, 0x3D, 0x07, 0x0F, 0x17,
             0x1F, 0x27, 0x2F, 0xC6, 0xCE, 0xD6, 0xDE, 0xE6, 0xEE, 0xF6, 0xCB}
HL_WRITERS = {0x22, 0x2A, 0x32, 0x3A, 0x23, 0x2B, 0x29, 0x09, 0x19, 0x39, 0xE1, 0x26, 0x2E, 0xF8} | set(range(0x60, 0x70))
STOP = {0xCD, 0xC4, 0xCC, 0xD4, 0xDC, 0xC7, 0xCF, 0xD7, 0xDF, 0xE7, 0xEF, 0xF7, 0xFF}     # calls and rsts: the callee may change anything
rom = Rom(sys.argv[1]); tr = json.load(open(sys.argv[2])); sym_code, sym_data = load_sym(sys.argv[3]); OUT = sys.argv[4]
names = {(b, a): n for b, a, n in sym_code + sym_data}
code = {}
for k, n in tr['code'].items():
    b, a = k.split(':')
    if n > 0: code[(int(b, 16), int(a, 16))] = n
entries = collections.defaultdict(list)
for k, kind in tr.get('entries', {}).items():
    b, a = (int(x, 16) for x in k.split(':'))
    if kind != 'flow': entries[b].append(a)
for b in entries: entries[b].sort()
labels = {(b, a) for b, a, _ in sym_code}
def func_of(b, pc):
    bb = b if pc >= 0x4000 else 0; lst = entries.get(bb, []); i = bisect.bisect_right(lst, pc) - 1
    if i < 0: return ''
    return names.get((bb, lst[i]), '%02x:%04x' % (bb, lst[i]))
prev = {}
for (b, a), n in code.items(): prev[(b, a + n)] = (b, a)
def window(b, a, k=24):
    out = []; p = prev.get((b, a))
    while p and len(out) < k:
        op = rom.b(*p)
        if op in STOP: break
        out.append(p)
        if p in labels or (p[1] in entries.get(p[0] if p[1] >= 0x4000 else 0, [])): break
        p = prev.get(p)
    return out[::-1]
def bank_at(b, a):
    """the constant RAM bank selected on the straight line before (b, a), or None"""
    A = HL = None; bank = None
    for p in window(b, a):
        op = rom.b(*p); n = code[p]
        if op == 0x3E: A = rom.b(p[0], p[1] + 1)
        elif op == 0xAF: A = 0
        elif op == 0x21: HL = rom.w(p[0], p[1] + 1)
        elif op == 0xEA and 0x4000 <= rom.w(p[0], p[1] + 1) <= 0x5FFF: bank = A
        elif op == 0x36 and HL is not None and 0x4000 <= HL <= 0x5FFF: bank = rom.b(p[0], p[1] + 1)
        elif op == 0x77 and HL is not None and 0x4000 <= HL <= 0x5FFF: bank = A
        else:
            if op in A_WRITERS: A = None
            if op in HL_WRITERS: HL = None
    return bank
rows = []
for (b, a), n in sorted(code.items()):
    if n != 3: continue
    op = rom.b(b, a); nn = rom.w(b, a + 1)
    if not 0xA000 <= nn <= 0xBFFF: continue
    kind = {0xEA: 'W', 0xFA: 'R', 0x01: 'P', 0x11: 'P', 0x21: 'P', 0x31: 'P'}.get(op)
    if not kind: continue
    rb = bank_at(b, a)
    flat = '' if rb is None else ('sensor' if rb >= 0x10 else '%05x' % (rb * 0x2000 + nn - 0xA000))
    rows.append(('%04x' % nn, kind, '%02x' % b, '%04x' % a, func_of(b, a), '' if rb is None else '%02x' % rb, flat))
with open(OUT, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['addr', 'kind', 'bank', 'pc', 'function', 'ram_bank', 'flat']); w.writerows(rows)
kb = sum(1 for r in rows if r[5]); se = sum(1 for r in rows if r[6] == 'sensor')
print('sram_db: %d sites (%s), RAM bank known for %d (%d of them the sensor window), %d distinct addresses'
      % (len(rows), ' '.join('%s %d' % kv for kv in sorted(collections.Counter(r[1] for r in rows).items())), kb, se, len({r[0] for r in rows})))
