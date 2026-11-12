#!/usr/bin/env python3
"""The printer library left in the prototype ("DEBAGAME") by its older builds (2026-11-12): roms/prototype_debagame/disasm/printer_lib_proto.csv.

  tools/proto_printer_lib.py PROTO.gb JP.gb [--out roms/prototype_debagame/disasm/printer_lib_proto.csv]

This build has no printer code (nothing it runs talks to a printer), but four of its leftover banks hold the bank-0 code of older builds,
and each holds the whole Game Boy Printer library that the retail ROMs kept (the Japanese `Prn_*` routines of bank $00):
  * bank $2C = the bank 0 of the build of symbol table $2A (README: 57 % of that table's bank-0 code labels are call / jp targets there)
    and bank $37 = the bank 0 of the build of table $35: every label of the table from SIOINT to STARTSTRINGTRANS is a routine or a
    data block of the library at table value + $4000, with the developers' own name (C: read from the table);
  * banks $1D and $20 = two more builds (no table): each routine of bank $2C is found there with its 16-bit operands masked, in the same
    order (C when found, the address of the first match after the previous routine).
Each routine is then compared with the Japanese ROM: the Japanese `Prn_*` routine whose instructions match best (16-bit operands and the
HRAM byte of ldh masked; difflib ratio on the instruction sequence), `exact` when the masked bytes are equal over the whole routine.
Columns: dev_name, size (bytes in bank $2C), b2C, b37, b1D, b20 (BB:AAAA or empty), jp_name, jp_addr, jp_ratio, jp_match (exact / near /
none / short: a routine under 6 bytes, the pair listed but not claimed). tools/proto_names.py names the routines Leftover_BB_AAAA_<dev_name> (code that this build never runs, typed data; tag C where the
table gives the address, I for the copies of banks $1D / $20).
"""
import argparse, csv, difflib, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); PD = os.path.join(REPO, 'roms', 'prototype_debagame')
ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('jp')
ap.add_argument('--symtab', default=os.path.join(PD, 'disasm', 'leftover_symtab_proto.csv'))
ap.add_argument('--out', default=os.path.join(PD, 'disasm', 'printer_lib_proto.csv')); a = ap.parse_args()
P = open(a.rom, 'rb').read(); J = open(a.jp, 'rb').read()
LEN = [1] * 256
for op in (0x01, 0x08, 0x11, 0x21, 0x31, 0xC2, 0xC3, 0xC4, 0xCA, 0xCC, 0xCD, 0xD2, 0xD4, 0xDA, 0xDC, 0xEA, 0xFA): LEN[op] = 3
for op in (0x06, 0x0E, 0x16, 0x1E, 0x26, 0x2E, 0x36, 0x3E, 0x10, 0x18, 0x20, 0x28, 0x30, 0x38, 0xC6, 0xCB, 0xCE, 0xD6, 0xDE, 0xE0, 0xE6,
           0xE8, 0xEE, 0xF0, 0xF6, 0xF8, 0xFE): LEN[op] = 2
ADDR16 = {0x01, 0x08, 0x11, 0x21, 0x31, 0xC2, 0xC3, 0xC4, 0xCA, 0xCC, 0xCD, 0xD2, 0xD4, 0xDA, 0xDC, 0xEA, 0xFA}
def toks(X, o, e):
    t, k = [], o
    while k < e:
        op = X[k]; ln = LEN[op]; t.append((op,) if op in ADDR16 or op in (0xE0, 0xF0) else tuple(X[k:k + ln])); k += ln
    return t
def pattern(X, o, e):
    pat, k = b'', o
    while k < e:
        op = X[k]; ln = min(LEN[op], e - k)
        pat += re.escape(bytes([op])) + (b'..' if op in ADDR16 and ln == 3 else b'.' if op in (0xE0, 0xF0) and ln == 2 else re.escape(X[k + 1:k + ln]))
        k += ln
    return re.compile(pat, re.S)
def hx(o): return '%02X:%04X' % (o >> 14, 0x4000 + (o & 0x3FFF))
S = list(csv.DictReader(open(a.symtab)))
def lib(t, bank):
    L = sorted({(int(r['value'], 16), r['name']) for r in S if r['table'] == t and r['kind'] == 'label'})
    i0 = next(i for i, x in enumerate(L) if x[1] == 'SIOINT'); i1 = next(i for i, x in enumerate(L) if x[1] == 'STARTSTRINGTRANS')
    out = []
    for i in range(i0, i1 + 1):
        v, n = L[i]; nv = L[i + 1][0] if i + 1 < len(L) else v + 0x40
        if nv == v: continue                                         # two names on one address (PACKET3 / PACKET6): the first
        out.append((n, bank * 0x4000 + v, bank * 0x4000 + nv))
    return out
A = lib('2A', 0x2C); B = {n: (o, e) for n, o, e in lib('35', 0x37)}
JL = sorted((int(r['bank'], 16) * 0x4000 + int(r['addr'], 16) - (0x4000 if int(r['bank'], 16) else 0), r['name'])
            for r in csv.DictReader(open(os.path.join(REPO, 'roms', 'jp_rev_a', 'disasm', 'sym_names_jp.csv'))))
JP = [(o, JL[i + 1][0], n) for i, (o, n) in enumerate(JL) if n.startswith('Prn_') and i + 1 < len(JL)]
rows = []; prev = {}                          # bank -> (offset found, offset in bank $2C) of the previous routine
for n, o, e in A:
    pat = pattern(P, o, e); found = {}
    for bk in (0x1D, 0x20):
        if bk in prev:                         # near where the previous routine's distance says (a short pattern alone matches anywhere)
            exp = prev[bk][0] + (o - prev[bk][1]); m = pat.search(P, max(exp - 16, prev[bk][2]), min(exp + 16 + (e - o), bk * 0x4000 + 0x4000))
        else: m = pat.search(P, bk * 0x4000, bk * 0x4000 + 0x4000) if e - o >= 16 else None
        if m: found[bk] = m.start(); prev[bk] = (m.start(), o, m.end())     # the next routine starts after this one
    t = toks(P, o, e); best = (0.0, None, None, '')
    for jo, je, jn in JP:
        tj = toks(J, jo, je); r = difflib.SequenceMatcher(None, t, tj, autojunk=False).ratio()
        if r > best[0]: best = (r, jn, jo, 'exact' if pattern(J, jo, je).fullmatch(P[o:e]) and je - jo == e - o else 'near')
    r, jn, jo, kind = best
    if r < 0.8: jn, jo, kind = '', None, 'none'
    elif e - o < 6 and not n.startswith(('PACKET', 'PREAMBLEDATA')): kind = 'short'     # a `ret` or two instructions match anywhere: listed, not claimed
    b37 = B.get(n)
    rows.append([n, e - o, hx(o), hx(b37[0]) if b37 else '', hx(found[0x1D]) if 0x1D in found else '', hx(found[0x20]) if 0x20 in found else '',
                 jn, '%02X:%04X' % (jo >> 14, jo & 0x3FFF) if jo is not None else '', '%.2f' % r, kind])
with open(a.out, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n')
    w.writerow(['dev_name', 'size', 'b2C', 'b37', 'b1D', 'b20', 'jp_name', 'jp_addr', 'jp_ratio', 'jp_match']); w.writerows(rows)
import collections
print('proto_printer_lib: %d routines and blocks (bank $2C); in bank $37 %d, $1D %d, $20 %d; Japanese match %s' % (
    len(rows), sum(1 for r in rows if r[3]), sum(1 for r in rows if r[4]), sum(1 for r in rows if r[5]), dict(collections.Counter(r[9] for r in rows))))
