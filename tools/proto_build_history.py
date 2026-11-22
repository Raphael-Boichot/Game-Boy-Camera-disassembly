#!/usr/bin/env python3
"""The prototype's build history (L6, 2026-11-22): the evidence for placing its older builds in one order.

  tools/proto_build_history.py PROTO.gb [--out roms/prototype_debagame/disasm/build_history_proto.csv]
                                         [--titles roms/prototype_debagame/screens/old_titles_proto.png]

Six builds: this one (bank 0); the bank-0 code of four older builds in banks $1D, $20, $2C (symbol table $2A) and $37 (symbol table $35);
and a sixth known only by the label records found in the PC memory of bank $11 (disasm/leftover_symtab_mem_proto.csv).
  * Titles (C, bytes): the title map of this build (01:5801) is found again, same layout, in banks $2D, $38 and $21; the version after
    `Ver` is read with the menu font's codes (disasm/charset_proto.csv). Each is drawn with the tile set of its own bank ($2D:4001,
    $38:4001; bank $21's set found by the bytes of its glyph `P`), --titles.
  * Routine sizes (C, bytes): the distance from a routine to the next one, for the routines found in all five code builds in the same
    order (disasm/oldbuilds_proto.csv, printer_lib_proto.csv, match_old_proto.csv).
  * Menu-routine addresses (C, tables and records): the same labels in table $2A, this build, table $35 and the bank-$11 records.
Rows: kind (title / size / address), name, then one column per build.
"""
import argparse, csv, os
import numpy as np
from PIL import Image
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); PD = os.path.join(REPO, 'roms', 'prototype_debagame'); D = os.path.join(PD, 'disasm')
ap = argparse.ArgumentParser(); ap.add_argument('rom')
ap.add_argument('--out', default=os.path.join(D, 'build_history_proto.csv')); ap.add_argument('--titles', default=os.path.join(PD, 'screens', 'old_titles_proto.png'))
a = ap.parse_args(); R = open(a.rom, 'rb').read()
def fl(b, ad): return ad if b == 0 else b * 0x4000 + ad - 0x4000
def fls(s): b, ad = s.split(':'); return fl(int(b, 16), int(ad, 16))
B = ['B1D', 'B20', 'T2A', 'T35', 'THIS']
rows = []
# titles: the map of this build has PUSH ($D0 $D5 $D3 $C8) at +$1C3 and Ver ($90 $91) at +$EC
TT = []
for col, bank in (('THIS', 0x01), ('T2A', 0x2D), ('T35', 0x38), ('B20', 0x21)):
    o = R.find(bytes([0xD0, 0xD5, 0xD3, 0xC8]), fl(bank, 0x4000), fl(bank + 1, 0x4000)); mo = o - 0x1C3
    v = R.find(bytes([0x90, 0x91]), mo, mo + 0x240); s = ''
    for x in R[v + 2:v + 8]:
        if 0x80 <= x <= 0x89: s += chr(48 + x - 0x80)
        elif x == 0x92: s += '.'
        else: break
    P = R[fl(1, 0x4001) + 0xD0 * 16:fl(1, 0x4001) + 0xD0 * 16 + 16]
    fo = R.find(P, fl(bank, 0x4000) - 0x4000, fl(bank + 1, 0x4000)) - 0xD0 * 16
    TT.append((col, bank, mo, fo, 'Ver' + s))
    rows.append(['title', 'map %02X:%04X, tile set at flat $%05X' % (bank, 0x4000 + (mo & 0x3FFF), fo), col, 'Ver' + s])
PAL = np.array([255, 170, 85, 0], np.uint8); ims = []
for col, bank, mo, fo, ver in TT:
    img = np.zeros((144, 160), np.uint8)
    for r in range(18):
        for c in range(20):
            n = R[mo + r * 32 + c]; n = n + 256 if n < 128 else n
            for y in range(8):
                lo, hi = R[fo + n * 16 + 2 * y], R[fo + n * 16 + 2 * y + 1]
                for x in range(8): img[r * 8 + y, c * 8 + x] = ((lo >> (7 - x)) & 1) | (((hi >> (7 - x)) & 1) << 1)
    ims.append(np.pad(PAL[img], ((0, 0), (0, 8)), constant_values=128))
os.makedirs(os.path.dirname(a.titles), exist_ok=True)
Image.fromarray(np.hstack(ims)).resize((len(ims) * 168 * 2, 288), Image.NEAREST).save(a.titles, optimize=True)
# routine sizes in the five code builds
P = {}
for r in csv.DictReader(open(os.path.join(D, 'oldbuilds_proto.csv'))):
    if r['kind'] != 'code': continue
    d = P.setdefault(r['dev_name'], {}); d['T' + r['table']] = fls(r['addr'])
    if r['copy_1D']: d['B1D'] = fls(r['copy_1D'])
    if r['copy_20']: d['B20'] = fls(r['copy_20'])
for r in csv.DictReader(open(os.path.join(D, 'printer_lib_proto.csv'))):
    d = P.setdefault(r['dev_name'], {})
    for k, t in (('b2C', 'T2A'), ('b37', 'T35'), ('b1D', 'B1D'), ('b20', 'B20')):
        if r[k]: d[t] = fls(r[k])
for r in csv.DictReader(open(os.path.join(D, 'match_old_proto.csv'))):
    if r['new_addr'] and r['name'] in P: P[r['name']]['THIS'] = int(r['new_addr'], 16)
full = [nm for nm, d in P.items() if all(t in d for t in B)]
order = {t: sorted(full, key=lambda nm: P[nm][t]) for t in B}
base = order['T2A']
for nm, nx in zip(base, base[1:]):
    if all(order[t].index(nx) == order[t].index(nm) + 1 for t in B):
        rows.append(['size', nm] + ['$%X' % (P[nx][t] - P[nm][t]) for t in B])
# menu-routine addresses: table $2A, this build, table $35, the bank-$11 records
T = {'2A': {}, '35': {}}
for r in csv.DictReader(open(os.path.join(D, 'leftover_symtab_proto.csv'))): T[r['table']][r['name']] = r['value']
TH = {r['name']: r['new_addr'] for r in csv.DictReader(open(os.path.join(D, 'match_old_proto.csv'))) if r['new_addr']}
for r in csv.DictReader(open(os.path.join(D, 'leftover_symtab_mem_proto.csv'))):
    if r['table'] == '11' and r['space'] == 'ROM0':
        n = r['name']; rows.append(['address', n, T['2A'].get(n, ''), TH.get(n, ''), T['35'].get(n, ''), r['value']])
with open(a.out, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n')
    w.writerow(['kind', 'name', 'c1', 'c2', 'c3', 'c4', 'c5'])
    w.writerow(['columns', 'title: build, version', 'size: B1D B20 T2A T35 THIS', 'address: table $2A, this build, table $35, bank-$11 records', '', '', ''])
    w.writerows(rows)
print('proto_build_history: %d rows -> %s; titles: %s' % (len(rows), a.out, ', '.join('%s %s' % (t[0], t[4]) for t in TT)))
