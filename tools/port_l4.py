#!/usr/bin/env python3
"""Carry the L4 tables (RAM names, RAM access sites, constants) of the Japanese ROM to another build.

  tools/port_l4.py JP.gb OTHER.gb MAP.npy CODE_MAP.csv OUTDIR [--suffix us] [--names OUTDIR/disasm/sym_names_us.csv]

The RAM layout is the same in the international build (of the paired instructions with a WRAM / HRAM operand, 7,580 + 2,919 use
the same address and 22 another one), so the addresses of the names do not change; what changes are the instruction keys:
  * ram_names: scope tokens `BB:AAAA` (routine entry) and `BB@AAAA` (one instruction) go through the instruction map
    (tools/port_code_map.py); a routine-label token (the tracer's first-pass label, as in the `function` column of the access
    table) is kept as it is, since the carried access rows hold the same string. A token that does not map is dropped (listed);
    a row left with no token gets the scope `FF@0000` (applies nowhere) and is listed.
  * wram_access (kind R / W / P rows): the pc and a routine entry `BB:AAAA` in `function` go through the instruction map (a label stays); a row is carried
    only if the other build's instruction is the same opcode and, for an operand access, holds the same address. With
    --fresh-access, the rows of tools/wram_db.py run on the other build's trace are added for every instruction no carried row
    covers (the new code), so its RAM operands are named too.
  * ram_exclude, ram_highbyte: the pc goes through the instruction map; carried only if the operand value is the same.
  * const_tables (bank, addr, len): the address goes through the byte map; carried only if the len bytes are identical
    in both ROMs (a mode table that changed must be typed again).
  * const_names, const_types, sound_names, state_names, state_helpers: keyed by value, variable or routine name: copied as they are
    (state_helpers rows whose routine has no name in the other build are dropped; the rows of state_helpers_<s>_hand.csv are added;
    likewise const_tables_<s>_hand.csv is added to the carried constant tables).
Writes OUTDIR/disasm/{ram_names,ram_exclude,ram_highbyte,const_tables}_<s>.csv, OUTDIR/wram/wram_access_<s>.csv and
OUTDIR/port/port_l4_report_<s>.csv (every dropped row with the reason).
"""
import sys, csv, argparse, collections, os, shutil
import numpy as np
ap = argparse.ArgumentParser()
for x in ('jp', 'other', 'map', 'codemap', 'outdir'): ap.add_argument(x)
ap.add_argument('--suffix', default='us'); ap.add_argument('--names', default=None)
ap.add_argument('--fresh-access', default=None, help="tools/wram_db.py output (<prefix>_access.csv) for the other build's own trace: its rows are added for the instructions that no carried row covers (new code)")
a = ap.parse_args()
S = a.suffix; JD = 'roms/jp_rev_a/disasm/'; OD = os.path.join(a.outdir, 'disasm'); OW = os.path.join(a.outdir, 'wram')
os.makedirs(OD, exist_ok=True); os.makedirs(OW, exist_ok=True)
JP = open(a.jp, 'rb').read(); OT = open(a.other, 'rb').read(); M = np.load(a.map)
def off(b, ad): return ad if ad < 0x4000 else b * 0x4000 + ad - 0x4000
CM = {}
for r in csv.DictReader(open(a.codemap)):
    b = int(r['bank'], 16); CM[(b, int(r['jp'], 16))] = int(r['other'], 16)
def cmap(b, ad):
    if ad < 0x4000: b = 0
    return CM.get((b, ad))
names = {r['name'] for r in csv.DictReader(open(a.names or os.path.join(OD, 'sym_names_%s.csv' % S), encoding='utf-8'))}
HAND = os.path.join(OD, 'sym_names_%s_hand.csv' % S)
if os.path.exists(HAND): names |= {r['name'] for r in csv.DictReader(open(HAND, encoding='utf-8')) if r['name'] not in ('-', '')}
rep = []
def rd(p): return list(csv.DictReader(open(p, encoding='utf-8')))
def wr(p, rows, fields):
    with open(p, 'w', newline='', encoding='utf-8') as f:
        w = csv.DictWriter(f, fieldnames=fields, lineterminator='\n'); w.writeheader(); w.writerows(rows)
# ---------------------------------------------------------------- ram_names
import re
rows = rd(JD + 'ram_names_jp.csv'); out = []; nt = collections.Counter()
for r in rows:
    toks = []
    for t in r['scope'].split(';'):
        m1 = re.fullmatch(r'([0-9A-Fa-f]{2}):([0-9A-Fa-f]{4})', t); m2 = re.fullmatch(r'([0-9A-Fa-f]{2})@([0-9A-Fa-f]{4})', t)
        if m1 or m2:
            m = m1 or m2; b = int(m[1], 16); t2 = cmap(b, int(m[2], 16))
            if t2 is None: rep.append(['ram_names', r['name'], t, 'scope token does not map']); nt['dropped'] += 1; continue
            toks.append('%02X%s%04X' % (b if t2 >= 0x4000 else 0, ':' if m1 else '@', t2)); nt['mapped'] += 1
        elif re.fullmatch(r'[A-Za-z_]\w*', t) and t != '*' and not re.fullmatch(r'[0-9A-Fa-f]{2}', t):
            toks.append(t); nt['label'] += 1           # a routine named by the tracer's first-pass label: the access rows carry the same string
        else: toks.append(t)
    r2 = dict(r); r2['scope'] = ';'.join(toks)
    if not toks: rep.append(['ram_names', r['name'], r['scope'], 'no scope left: the row applies nowhere']); r2['scope'] = 'FF@0000'
    out.append(r2)
wr(os.path.join(OD, 'ram_names_%s.csv' % S), out, list(rows[0].keys()))
print('ram_names: %d rows, scope tokens %s' % (len(out), dict(nt)))
# ---------------------------------------------------------------- wram_access
W16 = {0x01, 0x11, 0x21, 0x31, 0x08, 0xEA, 0xFA}
rows = rd('roms/jp_rev_a/wram/wram_access.csv'); out = []; c = collections.Counter()
for r in rows:
    b = int(r['bank'], 16); pc = int(r['pc'], 16); t = cmap(b, pc)
    if t is None: c['unpaired'] += 1; continue
    jo = off(b, pc); uo = off(b, t); op = JP[jo]
    if OT[uo] != op: c['other opcode'] += 1; continue
    if op in W16 and (JP[jo + 1:jo + 3] != OT[uo + 1:uo + 3]): c['other operand'] += 1; continue
    if op in (0xE0, 0xF0) and JP[jo + 1] != OT[uo + 1]: c['other operand'] += 1; continue
    r2 = dict(r); r2['bank'] = '%02x' % (b if t >= 0x4000 else 0); r2['pc'] = '%04x' % t
    if ':' in r['function']:
        fb, fa = r['function'].split(':'); ft = cmap(int(fb, 16), int(fa, 16))
        r2['function'] = ('%s:%04x' % (fb, ft)) if ft is not None else r['function'] + '?'
        if ft is None: c['routine entry unpaired'] += 1
    out.append(r2); c['carried'] += 1
if a.fresh_access:
    have = {(r['bank'], r['pc']) for r in out}; nf = 0
    for r in csv.DictReader(open(a.fresh_access, encoding='utf-8')):
        if (r['bank'], r['pc']) not in have: out.append(r); nf += 1
    c['added from the fresh table (new code)'] = nf
    out.sort(key=lambda r: (int(r['addr'], 16), r['bank'], r['pc'], r['kind']))
wr(os.path.join(OW, 'wram_access_%s.csv' % S), out, list(rows[0].keys()))
print('wram_access: %d of %d rows carried %s' % (len(out), len(rows), dict(c)))
# ---------------------------------------------------------------- ram_exclude / ram_highbyte
for fn, vk in (('ram_exclude', 'value'), ('ram_highbyte', None)):
    rows = rd(JD + fn + '_jp.csv'); out = []
    for r in rows:
        b = int(r['bank'], 16); pc = int(r['pc'], 16); t = cmap(b, pc); jo = off(b, pc)
        if t is None: rep.append([fn, r['bank'] + ':' + r['pc'], '', 'instruction unpaired']); continue
        uo = off(b, t); n = 3 if JP[jo] in (0x01, 0x11, 0x21, 0x31) else 2
        if JP[jo:jo + n] != OT[uo:uo + n]: rep.append([fn, r['bank'] + ':' + r['pc'], '', 'operand differs']); continue
        r2 = dict(r); r2['bank'] = '%02X' % (b if t >= 0x4000 else 0); r2['pc'] = '%04X' % t; out.append(r2)
    wr(os.path.join(OD, '%s_%s.csv' % (fn, S)), out, list(rows[0].keys()))
    print('%s: %d of %d rows carried' % (fn, len(out), len(rows)))
# ---------------------------------------------------------------- const tables
rows = rd(JD + 'const_tables_jp.csv'); out = []
for r in rows:
    b = int(r['bank'], 16); ad = int(r['addr'], 16); n = int(r['len']); jo = off(b, ad); t = int(M[jo])
    if t < 0 or any(M[jo + i] != t + i for i in range(n)): rep.append(['const_tables', r['bank'] + ':' + r['addr'], '', 'table not mapped in one piece']); continue
    if JP[jo:jo + n] != OT[t:t + n]: rep.append(['const_tables', r['bank'] + ':' + r['addr'], '', 'bytes differ: type again']); continue
    r2 = dict(r); r2['addr'] = '%04X' % (t if t < 0x4000 else (t & 0x3FFF) + 0x4000); out.append(r2)
CH = os.path.join(OD, 'const_tables_%s_hand.csv' % S)          # tables of this build typed by hand (kept across re-ports)
nhand = 0
if os.path.exists(CH): hr = rd(CH); out += hr; nhand = len(hr)
wr(os.path.join(OD, 'const_tables_%s.csv' % S), out, list(rows[0].keys()))
print('const_tables: %d of %d rows carried, %d typed by hand' % (len(out) - nhand, len(rows), nhand))
# ---------------------------------------------------------------- copied as they are
for fn in ('const_names', 'const_types', 'sound_names', 'state_names'):
    shutil.copy(JD + fn + '_jp.csv', os.path.join(OD, '%s_%s.csv' % (fn, S)))
rows = rd(JD + 'state_helpers_jp.csv'); out = [r for r in rows if r['routine'] in names]
for r in rows:
    if r['routine'] not in names: rep.append(['state_helpers', r['routine'], '', 'routine not in this build'])
SH = os.path.join(OD, 'state_helpers_%s_hand.csv' % S)          # helpers of this build's own code, kept across re-ports
if os.path.exists(SH): out += rd(SH)
wr(os.path.join(OD, 'state_helpers_%s.csv' % S), out, list(rows[0].keys()))
with open(os.path.join(a.outdir, 'port', 'port_l4_report_%s.csv' % S), 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f); w.writerow(['table', 'key', 'token', 'why']); w.writerows(rep)
print('dropped rows / tokens listed: %d' % len(rep), collections.Counter(x[0] for x in rep))
