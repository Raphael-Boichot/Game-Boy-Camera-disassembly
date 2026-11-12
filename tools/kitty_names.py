#!/usr/bin/env python3
"""L3 names of the Hello Kitty ROM: merge the name layers into roms/hello_kitty/disasm/sym_names_kitty.csv (the input of sym_build).

  tools/kitty_names.py [--min-port 16] [--auto AUTO.csv] [--trace TRACE.json] [--out OUT.csv]

Layers, lowest first (a later layer replaces the name at the same address; a name `-` deletes):
  1. auto   disasm/layers/sym_names_kitty_auto.csv (tools/kitty_types.py --names): Gfx_ / Map_ / Data_ / JumpTable_ BB_AAAA, ModeTable
  2. port   disasm/match_jp_kitty.csv (tools/kitty_match_jp.py): the name of a Japanese routine whose code is found at exactly one
            place of the Kitty code with only the build-dependent operands masked (16-bit addresses, the HRAM byte of ldh). Tag C
            when the routine is at least --min-port bytes long, I below; when several Japanese names fall on one Kitty address
            (the Japanese ROM has copies of one routine), the first is kept and tagged ?. The note names the Japanese address.
  2b. near disasm/similar_jp_kitty.csv (tools/kitty_similar_jp.py): a Japanese routine edited in the Kitty build (instruction
            sequence ratio >= 0.85, the best Kitty entry clearly ahead of the second): its name, tagged I, only where layers 1-2 left
            the address unnamed by a port and the Japanese name is not used yet; two Japanese names on one address: the first, tag ?.
  3. modes  disasm/mode_names_kitty.csv (mode, name, tag, evidence) and the trace's ModeTable / state tables: the mode entry
            ModeMM_<Name>, its state table ModeMM_StateTable, each state handler ModeMM_StateSS (a handler shared by several states
            gets the first); the tag of the mode name, C for the state handlers (read from the trace's tables).
  4. hand   disasm/layers/sym_names_kitty_hand.csv
  5. data   tools/kitty_data_names.py: every placeholder data label named by kind and consumer, never-read stretches Leftover_BB_AAAA
            (owner rule 2026-11-11), labels on inline arguments dropped (needs --rom, and --jp for the exact Japanese copies)
Checks: one name per address, one address per name (a clash aborts), names are valid rgbasm labels.
"""
import csv, json, re, sys, argparse, collections
ap = argparse.ArgumentParser(); ap.add_argument('--min-port', type=int, default=16)
ap.add_argument('--auto', default='roms/hello_kitty/disasm/layers/sym_names_kitty_auto.csv'); ap.add_argument('--out', default='roms/hello_kitty/disasm/sym_names_kitty.csv')
ap.add_argument('--trace', default='roms/hello_kitty/trace/trace_kitty.json')
ap.add_argument('--rom', default='/root/work/roms/pocketcamera_kitty.gb'); ap.add_argument('--jp', default='/root/work/roms/pocketcamera_jp.gb'); a = ap.parse_args()
D = 'roms/hello_kitty/disasm/'
names = {}   # (bank, addr) -> [name, conf, note, source]
def put(b, ad, nm, conf, note, src):
    b = 0 if ad < 0x4000 else b
    if nm == '-': names.pop((b, ad), None)
    else: names[(b, ad)] = [nm, conf, note, src]
for r in csv.DictReader(open(a.auto)): put(int(r['bank'], 16), int(r['addr'], 16), r['name'], r['conf'], r['note'], r['source'])
byk = collections.defaultdict(list)
for r in csv.DictReader(open(D + 'match_jp_kitty.csv')):
    if r['hits'] != '1': continue
    byk[r['kitty']].append(r)
nport = collections.Counter()
for k, rs in byk.items():
    b, ad = int(k[:2], 16), int(k[3:], 16); r = rs[0]
    conf = '?' if len(rs) > 1 else ('C' if int(r['bytes']) >= a.min_port else 'I')
    note = 'same code as the Japanese %s (%s:%s, %s bytes, %s match%s)' % (r['jp_name'], r['jp_bank'], r['jp_addr'], r['bytes'], r['kind'],
            '; the Japanese ROM also has %s' % ', '.join(x['jp_name'] for x in rs[1:]) if len(rs) > 1 else '')
    put(b, ad, r['jp_name'], conf, note, 'port_jp'); nport[conf] += 1
used = {v[0] for v in names.values()}
near = collections.defaultdict(list)
for r in csv.DictReader(open(D + 'similar_jp_kitty.csv')):
    if float(r['second']) < float(r['ratio']) - 0.05: near[r['kitty']].append(r)
for k, rs in near.items():
    b, ad = int(k[:2], 16), int(k[3:], 16); key = (0 if ad < 0x4000 else b, ad)
    if key in names and names[key][3] == 'port_jp': continue
    r = rs[0]
    if r['jp_name'] in used: continue
    note = 'edited copy of the Japanese %s (%s:%s): instruction sequence ratio %s against %s bytes%s' % (
        r['jp_name'], r['jp_bank'], r['jp_addr'], r['ratio'], r['jp_bytes'], '; also near %s' % ', '.join(x['jp_name'] for x in rs[1:]) if len(rs) > 1 else '')
    put(b, ad, r['jp_name'], '?' if len(rs) > 1 else 'I', note, 'near_jp'); used.add(r['jp_name'])
T = json.load(open(a.trace))
mn = {r['mode'].upper(): r for r in csv.DictReader(open(D + 'mode_names_kitty.csv'))}
modes = T['ctables']['00:0D00']['records']
tabs = {}
for tk, v in T.get('state_check', {}).items(): tabs[int(v['mode'], 16)] = tk
for i, rec in enumerate(modes):
    m = '%02X' % i; b, ad = int(rec[:2], 16), int(rec[3:], 16); r = mn.get(m)
    if not r: continue
    put(b, ad, 'Mode%s_%s' % (m, r['name']), r['tag'], 'ModeTable entry $%s: %s' % (m, r['evidence']), 'modes')
    tk = tabs.get(i)
    if not tk: continue
    tb, ta = int(tk[:2], 16), int(tk[3:], 16)
    put(tb, ta, 'Mode%s_StateTable' % m, 'C', 'state table of mode $%s, read by $0189 with hFF8E' % m, 'modes')
    seen = set()
    for s, sr in enumerate(T['ctables'][tk]['records']):
        sb, sa = int(sr[:2], 16), int(sr[3:], 16)
        if (sb, sa) in seen: continue
        seen.add((sb, sa))
        put(sb, sa, 'Mode%s_State%02X' % (m, s), 'C', 'handler of state $%02X of mode $%s (word %d of Mode%s_StateTable)' % (s, m, s, m), 'modes')
for r in csv.DictReader(open(D + 'layers/sym_names_kitty_hand.csv')): put(int(r['bank'], 16), int(r['addr'], 16), r['name'], r['conf'], r['note'], r['source'])
import os; sys.path.insert(0, os.path.dirname(os.path.abspath(__file__))); import kitty_data_names
dst = kitty_data_names.run(names, D, a.rom, a.jp, T, put)        # 5. data names by kind and consumer (tools/kitty_data_names.py)
print('kitty_names: data layer %s' % dict(dst))
# checks
bad = [nm for nm, *_ in names.values() if not re.match(r'^[A-Za-z_][A-Za-z0-9_]*$', nm)]
dup = [n for n, c in collections.Counter(v[0] for v in names.values()).items() if c > 1]
if bad or dup: sys.exit('kitty_names: invalid %s, duplicate %s' % (bad[:5], dup[:5]))
with open(a.out, 'w', newline='') as f:
    w = csv.writer(f); w.writerow(['bank', 'addr', 'name', 'conf', 'note', 'source'])
    for (b, ad), (nm, conf, note, src) in sorted(names.items()): w.writerow(['%02X' % b, '%04X' % ad, nm, conf, note, src])
tags = collections.Counter(v[1] for v in names.values()); src = collections.Counter(v[3] for v in names.values())
print("kitty_names: %d names, tags {'C': %d, 'I': %d, '?': %d}, by layer %s" % (len(names), tags['C'], tags['I'], tags['?'], dict(src)))
