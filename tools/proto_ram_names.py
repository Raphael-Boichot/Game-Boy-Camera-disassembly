#!/usr/bin/env python3
"""RAM names of the prototype ("DEBAGAME"), L4 (2026-11-12, roadmap step 7): roms/prototype_debagame/disasm/ram_names_proto.csv.

  tools/proto_ram_names.py PROTO.gb [--out roms/prototype_debagame/disasm/ram_names_proto.csv]

The columns of roms/jp_rev_a/disasm/ram_names_jp.csv (addr, size, name, scope, tag, desc), one row per WRAM / HRAM address that a proven
instruction of this build reads, writes or loads as a pointer (roms/prototype_debagame/wram/wram_access_proto.csv, tools/wram_db.py).
The I/O registers ($FF00-$FF7F) and $FFFF keep the hardware.inc names. Names come from the developers, where they can be checked:
  * the two older builds' symbol tables ($2A, $35; disasm/leftover_symtab_proto.csv) and the in-memory records of a fifth build
    (disasm/leftover_symtab_mem_proto.csv) give names to RAM addresses. A name is checked against the code: the routines of this build
    that touch the address (wram_access_proto.csv, the routine = the label before the instruction in disasm/sym_names_proto.csv) and
    the routines of the older build that touch the name's address in its own bank 0 (banks $2C / $37, the labels of
    disasm/oldbuilds_proto.csv and disasm/printer_lib_proto.csv, decoded) share a developers' routine name: tag C. Same name in both
    tables, no shared routine: I. Names that differ between the tables: the one whose build shares a routine, else the table $2A one, I.
  * an address no table names: `w` / `h` + the developers' routine that touches it most + its address (`wSeq09_ConfigMain_D60E`), tag I.
Prefixes `w` (WRAM) and `h` (HRAM) as in the Japanese table, then the developers' name as written (`wLOOP_COUNT`, `hMAIN_AFURE`).
size: up to the next address of the table for an address loaded as a pointer (P: a buffer or an array), at most 256 bytes; else 1.
scope `*` (one view per address in this build). desc: the evidence.
"""
import argparse, bisect, collections, csv, os, re
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); PD = os.path.join(REPO, 'roms', 'prototype_debagame')
ap = argparse.ArgumentParser(); ap.add_argument('rom')
ap.add_argument('--access', default=os.path.join(PD, 'wram', 'wram_access_proto.csv'))
ap.add_argument('--out', default=os.path.join(PD, 'disasm', 'ram_names_proto.csv')); a = ap.parse_args()
P = open(a.rom, 'rb').read()
def fl(b, ad): return ad if b == 0 else b * 0x4000 + ad - 0x4000
NM = sorted((fl(int(r['bank'], 16), int(r['addr'], 16)), r['name']) for r in csv.DictReader(open(os.path.join(PD, 'disasm', 'sym_names_proto.csv'))))
NO = [o for o, _ in NM]
CODE = set()
for r in csv.DictReader(open(os.path.join(PD, 'trace', 'rom_map_proto.csv'))):
    if r['class'] == 'C': o = fl(int(r['bank'], 16), int(r['start'], 16)); CODE.update(range(o, o + int(r['length'])))
def routine(o):                                       # the code label before an instruction (its routine), without _PartAAAA
    i = bisect.bisect_right(NO, o) - 1
    while i >= 0 and NM[i][0] not in CODE: i -= 1
    return re.sub(r'_Part[0-9A-F]{4}$', '', NM[i][1]) if i >= 0 else ''
acc = list(csv.DictReader(open(a.access)))
here = collections.defaultdict(collections.Counter); kinds = collections.defaultdict(set)
for r in acc:
    ad = int(r['addr'], 16)
    if 0xFF00 <= ad < 0xFF80 or ad == 0xFFFF or ad < 0xC000 or 0xE000 <= ad < 0xFF00: continue
    here[ad][routine(fl(int(r['bank'], 16), int(r['pc'], 16)))] += 1; kinds[ad].add(r['kind'])
# the older builds: RAM names and the routines that touch them
S = list(csv.DictReader(open(os.path.join(PD, 'disasm', 'leftover_symtab_proto.csv'))))
tab = collections.defaultdict(dict)                    # address -> {table: name}
for r in S:
    if r['space'] in ('WRAM', 'HRAM-IO') and r['kind'] in ('label', 'equ'): tab[int(r['value'], 16)].setdefault(r['table'], r['name'])
mem = {}
mp = os.path.join(PD, 'disasm', 'leftover_symtab_mem_proto.csv')
if os.path.exists(mp):
    for r in csv.DictReader(open(mp)):
        if r['space'] in ('WRAM', 'HRAM-IO'): mem.setdefault(int(r['value'], 16), r['name'])
LEN = [1] * 256
for op in (0x01, 0x08, 0x11, 0x21, 0x31, 0xC2, 0xC3, 0xC4, 0xCA, 0xCC, 0xCD, 0xD2, 0xD4, 0xDA, 0xDC, 0xEA, 0xFA): LEN[op] = 3
for op in (0x06, 0x0E, 0x16, 0x1E, 0x26, 0x2E, 0x36, 0x3E, 0x10, 0x18, 0x20, 0x28, 0x30, 0x38, 0xC6, 0xCB, 0xCE, 0xD6, 0xDE, 0xE0, 0xE6,
           0xE8, 0xEE, 0xF0, 0xF6, 0xF8, 0xFE): LEN[op] = 2
old = {'2A': collections.defaultdict(set), '35': collections.defaultdict(set)}   # table -> address -> old routine names
for f, cols in (('oldbuilds_proto.csv', ('addr',)), ('printer_lib_proto.csv', ('b2C', 'b37'))):
    p = os.path.join(PD, 'disasm', f)
    if not os.path.exists(p): continue
    for r in csv.DictReader(open(p)):
        if r.get('kind', 'code') != 'code' or r['dev_name'].startswith(('PACKET', 'PREAMBLEDATA')): continue
        for c in cols:
            if not r[c]: continue
            b, ad = int(r[c][:2], 16), int(r[c][3:], 16); t = '2A' if b == 0x2C else '35'
            o = fl(b, ad); e = o + int(r['size']); k = o
            while k < e:
                op = P[k]
                if op in (0xFA, 0xEA, 0x01, 0x11, 0x21) and k + 2 < e: old[t][P[k + 1] | P[k + 2] << 8].add(r['dev_name'])
                elif op in (0xF0, 0xE0) and k + 1 < e: old[t][0xFF00 | P[k + 1]].add(r['dev_name'])
                k += LEN[op]
rows = []; used = set(); st = collections.Counter()
addrs = sorted(here)
for i, ad in enumerate(addrs):
    pre = 'h' if ad >= 0xFF80 else 'w'
    mine = set(here[ad]); cands = []
    for t in ('2A', '35'):
        n = tab[ad].get(t)
        if n: cands.append((t, n, mine & old[t].get(ad, set())))
    name = None; tag = 'I'; ev = ''
    shared = [c for c in cands if c[2]]
    if shared:
        t, n, sh = shared[0]; name = n; tag = 'C'
        ev = 'name of table $%s at this address; the routines %s touch it here and in that build' % (t, ', '.join(sorted(sh)[:3]))
    elif cands:
        names_ = {c[1] for c in cands}; t, n, _ = cands[0]; name = n
        ev = ('the same name in both tables' if len(names_) == 1 and len(cands) == 2 else 'name of table $%s (%s)' % (t, '; '.join('$%s: %s' % (c[0], c[1]) for c in cands))) + \
             '; no routine of this build that touches it touches it in the older build (checked: %s)' % ', '.join(sorted(mine)[:3])
    elif ad in mem:
        name = mem[ad]; ev = 'name in the in-memory symbol records of a fifth build (bank $11)'
    if name:
        name = pre + name
    else:
        top = here[ad].most_common(1)[0][0] or 'Var'
        name = '%s%s_%04X' % (pre, top, ad); ev = 'no table names it: named after the routine that touches it most (%s)' % ', '.join('%s %d' % x for x in here[ad].most_common(3))
        st['generated'] += 1
    if name in used: name = '%s_%04X' % (name, ad)
    used.add(name); st[tag] += 1
    nxt = addrs[i + 1] if i + 1 < len(addrs) else ad + 1
    end = 0xE000 if ad < 0xE000 else 0xFFFF                 # a range stays inside its area (WRAM / HRAM)
    size = min(nxt - ad, 256, end - ad) if 'P' in kinds[ad] and nxt > ad + 1 else 1
    rows.append(['%04x' % ad, size, name, '*', tag, '%s; kinds %s' % (ev, ''.join(sorted(kinds[ad])))])
with open(a.out, 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['addr', 'size', 'name', 'scope', 'tag', 'desc']); w.writerows(rows)
print('proto_ram_names: %d addresses (WRAM %d, HRAM %d): C %d, I %d; %d named after their routine' % (
    len(rows), sum(1 for r in rows if r[2][0] == 'w'), sum(1 for r in rows if r[2][0] == 'h'), st['C'], st['I'], st['generated']))
