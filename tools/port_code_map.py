#!/usr/bin/env python3
"""Instruction-level map from the Japanese trace to the trace of another build.

  tools/port_code_map.py JP.gb OTHER.gb JP_TRACE.json OTHER_TRACE.json OUT.csv

Per bank, the two lists of traced instructions (sorted by address) are turned into tokens: opcode + operand bytes, with the
two bytes of a 16-bit immediate replaced by a wildcard (they hold addresses, which move), and a gap token wherever the
next instruction does not follow the previous one (a data block or an unreached byte in between). difflib aligns the two
token lists (autojunk off). Kinds in OUT.csv:
  same     the instructions are equal byte for byte
  operand  equal opcode, different 16-bit address operand
  imm      equal opcode and length, different 8-bit operand (inside a `replace` block of equal length, paired 1:1)
Only instructions in an `equal` block or paired as above are written; everything else is new or deleted code.
"""
import sys, json, csv, difflib, collections
JP = open(sys.argv[1], 'rb').read(); OT = open(sys.argv[2], 'rb').read()
W16 = {0x01, 0x11, 0x21, 0x31, 0x08, 0xC2, 0xC3, 0xCA, 0xD2, 0xDA, 0xC4, 0xCC, 0xCD, 0xD4, 0xDC, 0xEA, 0xFA}
def off(b, a): return a if a < 0x4000 else b * 0x4000 + a - 0x4000
def load(path):
    d = collections.defaultdict(dict)
    for k, n in json.load(open(path))['code'].items():
        b, a = (int(x, 16) for x in k.split(':'))
        if n > 0: d[0 if a < 0x4000 else b][a] = n
    return d
def tokens(R, ins, b):
    out = []; prev = None
    for a in sorted(ins):
        n = ins[a]; o = off(b, a); op = R[o]
        if prev is not None and a != prev: out.append(('gap',)); out_addr.append(None)
        tok = (op, 'W') if (op in W16 and n == 3) else tuple(R[o:o + n])
        out.append(tok); out_addr.append(a); prev = a + n
    return out
J = load(sys.argv[3]); U = load(sys.argv[4])
rows = []; tot = collections.Counter()
for b in range(64):
    if not J.get(b) and not U.get(b): continue
    out_addr = []; tj = tokens(JP, J.get(b, {}), b); aj = out_addr
    out_addr = []; tu = tokens(OT, U.get(b, {}), b); au = out_addr
    sm = difflib.SequenceMatcher(None, tj, tu, autojunk=False)
    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        if tag == 'equal':
            for i, j in zip(range(i1, i2), range(j1, j2)):
                if aj[i] is None: continue
                n = J[b][aj[i]]; same = JP[off(b, aj[i]):off(b, aj[i]) + n] == OT[off(b, au[j]):off(b, au[j]) + n]
                k = 'same' if same else 'operand'; rows.append((b, aj[i], au[j], k)); tot[k] += 1
        elif tag == 'replace' and i2 - i1 == j2 - j1:
            for i, j in zip(range(i1, i2), range(j1, j2)):
                if aj[i] is None or au[j] is None: continue
                if tj[i][0] == tu[j][0] and len(tj[i]) == len(tu[j]):
                    rows.append((b, aj[i], au[j], 'imm')); tot['imm'] += 1
    nj = len(J.get(b, {})); paired = sum(1 for r in rows if r[0] == b)
    print('bank %02X: JP %5d, other %5d, paired %5d' % (b, nj, len(U.get(b, {})), paired))
with open(sys.argv[5], 'w', newline='') as f:
    w = csv.writer(f); w.writerow(['bank', 'jp', 'other', 'kind'])
    for b, x, y, k in rows: w.writerow(['%02x' % b, '%04x' % x, '%04x' % y, k])
print(dict(tot), 'of', sum(len(v) for v in J.values()), 'JP instructions')
