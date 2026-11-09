#!/usr/bin/env python3
"""Find the routines of the two older builds (leftover symbol tables) in the prototype's code: the developers' names for L3.

  tools/proto_match_old.py PROTO.gb roms/prototype_debagame/disasm/leftover_symtab_proto.csv roms/prototype_debagame/trace/trace_proto.json OUT.csv

The two leftover symbol tables (tools/proto_symtab.py) are the symbol lists of two older builds, and the ROM also holds the bank-0
code of those builds as leftovers: table $2A fits bank $2C (57 % of its bank-0 code labels at or above $0150 are a `call` / `jp`
target there, 50 % in bank $20, at most 29 % elsewhere) and table $35 fits bank $37 (51 %, at most 2 % elsewhere) (C, byte scan,
2026-11-09). OLD below names those pairs.
For every label of kind `label` with a value in $0150-$3FFF, the routine is read in its old bank copy from the label to the next
label of the same table (at most 512 bytes), decoded instruction by instruction (sizes only) and turned into a pattern in which the
build-dependent operands are masked: the 16-bit operand of every 3-byte instruction (calls, jumps, `ld rr,nn`, `ld [nn],a` ...).
The pattern is cut at the first byte that cannot be decoded (an invalid opcode) or at the end of the bank. It is then searched in
the code of this build (bank $00, starting on a traced instruction, every byte inside the traced code): `hits` is the number of
places. One row per (table, label): table, name, old_addr, bytes (pattern length), hits, new_addr (when hits == 1), kind
(exact: the masked bytes are equal and so are the operands; masked: equal only with the operands masked; data: see below).
Data labels: a label whose code pattern is found nowhere (hits 0) is tried as data: its old bytes from the label to the next label
(at most 256, at least 4, not all one value) are searched unmasked in the bytes of this build's bank $00 that are not traced code;
a unique place gives a row of kind `data` (the dither order patterns, the contrast rows, the screen texts ...).
"""
import sys, csv, json, collections
ROM = open(sys.argv[1], 'rb').read(); rows = list(csv.DictReader(open(sys.argv[2]))); T = json.load(open(sys.argv[3])); out = sys.argv[4]
OLD = {'2A': 0x2C, '35': 0x37}
LEN = [1] * 256
for op in (0x01, 0x08, 0x11, 0x21, 0x31, 0xC2, 0xC3, 0xC4, 0xCA, 0xCC, 0xCD, 0xD2, 0xD4, 0xDA, 0xDC, 0xEA, 0xFA): LEN[op] = 3
for op in (0x06, 0x0E, 0x16, 0x1E, 0x26, 0x2E, 0x36, 0x3E, 0x10, 0x18, 0x20, 0x28, 0x30, 0x38, 0xC6, 0xCB, 0xCE, 0xD6, 0xDE, 0xE0, 0xE6,
           0xE8, 0xEE, 0xF0, 0xF6, 0xF8, 0xFE): LEN[op] = 2
INVALID = {0xD3, 0xDB, 0xDD, 0xE3, 0xE4, 0xEB, 0xEC, 0xED, 0xF4, 0xFC, 0xFD}
NEW = ROM[:0x4000]
starts = sorted(int(k[3:], 16) for k in T['code'] if k.startswith('00:'))
incode = bytearray(0x4000)
for k, n in T['code'].items():
    if k.startswith('00:'):
        a = int(k[3:], 16)
        for i in range(n): incode[a + i] = 1
def pattern(old, a, end):
    pat = []; i = a
    while i < end:
        op = old[i]
        if op in INVALID: break
        n = LEN[op]
        if i + n > end: break
        if n == 3: pat += [op, None, None]
        else: pat += list(old[i:i + n])
        i += n
    return pat
def find(pat):
    hits = []
    for s in starts:
        if s + len(pat) > 0x4000: break
        ok = True
        for j, v in enumerate(pat):
            if not incode[s + j] or (v is not None and NEW[s + j] != v): ok = False; break
        if ok: hits.append(s)
    return hits
res = []
for t, ob in OLD.items():
    old = ROM[ob * 0x4000:(ob + 1) * 0x4000]
    labs = sorted(((int(r['value'], 16), r['name']) for r in rows if r['table'] == t and r['kind'] == 'label' and 0x150 <= int(r['value'], 16) < 0x4000))
    for i, (v, nm) in enumerate(labs):
        nxt = labs[i + 1][0] if i + 1 < len(labs) else 0x4000
        if nxt == v: nxt = next((x for x, _ in labs[i + 1:] if x > v), 0x4000)
        pat = pattern(old, v, min(nxt, v + 512, 0x4000))
        if not pat: res.append([t, nm, '%04X' % v, 0, 0, '', '']); continue
        h = find(pat)
        kind = ''
        if len(h) == 1:
            kind = 'exact' if NEW[h[0]:h[0] + len(pat)] == old[v:v + len(pat)] else 'masked'
        if not h:      # try the label as data
            d = old[v:min(nxt, v + 256, 0x4000)]
            if len(d) >= 4 and len(set(d)) > 1:
                hd = [s for s in range(0x150, 0x4000 - len(d) + 1) if NEW[s:s + len(d)] == d and not any(incode[s:s + len(d)])]
                if hd: pat, h, kind = d, hd, ('data' if len(hd) == 1 else '')
        res.append([t, nm, '%04X' % v, len(pat), len(h), '%04X' % h[0] if len(h) == 1 else '', kind])
with open(out, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['table', 'name', 'old_addr', 'bytes', 'hits', 'new_addr', 'kind']); w.writerows(res)
c = collections.Counter((r[0], 'unique' if r[4] == 1 else 'none' if r[4] == 0 else 'several') for r in res)
print('proto_match_old: %d labels; %s' % (len(res), ', '.join('%s %s %d' % (k[0], k[1], v) for k, v in sorted(c.items()))))
