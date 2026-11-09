#!/usr/bin/env python3
"""L3 names of the early prototype: merge the name layers into roms/prototype_debagame/disasm/sym_names_proto.csv (the input of sym_build).

  tools/proto_names.py [--min-port 16] [--auto AUTO.csv] [--match MATCH.csv] [--symtab SYMTAB.csv] [--trace TRACE.json] [--out OUT.csv] [--doubts OUT.md]

Layers, lowest first (a later layer replaces the name at the same address; a name `-` deletes):
  1. auto   disasm/sym_names_proto_auto.csv (tools/proto_types.py --names): Gfx_ / Map_ / Data_ / JumpTable_ BB_AAAA, tag C
  2. assets the banked labels of the two leftover symbol tables (disasm/leftover_symtab_proto.csv, kind label, value $4000-$7FFF,
            byte2 = the bank): all 31 have the same bank and address in both tables. Tag C when this build copies a typed block that
            starts there (layer 1 holds a name at that address; the old kind is kept in the note), I otherwise (an asset of the old
            builds that this build neither copies nor reads in the L2 runs).
  3. port   disasm/match_old_proto.csv (tools/proto_match_old.py): the developers' name of an old-build routine whose code is found
            at exactly one place of this build (operands masked). A name found at several addresses (one per table) keeps the
            address with the longer pattern; an address given several names keeps the name both tables give, else the one with the
            longest pattern, and is tagged ? when two names tie. Tag C at --min-port bytes or more, I below. The note gives the table,
            the old address, the length and the match kind.
  4. hand   disasm/sym_names_proto_hand.csv (every row with its reason)
Checks: one name per address and one address per name (a clash aborts), valid rgbasm labels, every routine entry of the trace
(call targets, jump-table entries, vectors, the entry) named. --doubts writes the doubts list: every name not tagged C, with its note.
Prints `proto_names: N names, tags {...}; routine entries R, unnamed U`.
"""
import csv, json, re, sys, argparse, collections
D = 'roms/prototype_debagame/'
ap = argparse.ArgumentParser(); ap.add_argument('--min-port', type=int, default=16)
ap.add_argument('--auto', default=D + 'disasm/sym_names_proto_auto.csv'); ap.add_argument('--match', default=D + 'disasm/match_old_proto.csv')
ap.add_argument('--symtab', default=D + 'disasm/leftover_symtab_proto.csv'); ap.add_argument('--trace', default=D + 'port/trace_proto.json')
ap.add_argument('--hand', default=D + 'disasm/sym_names_proto_hand.csv'); ap.add_argument('--rom', default='/root/work/roms/pocketcamera_proto.gb')
ap.add_argument('--out', default=D + 'disasm/sym_names_proto.csv'); ap.add_argument('--doubts', default=D + 'disasm/sym_unconclusive_proto.md')
a = ap.parse_args()
names = {}
def put(b, ad, nm, conf, note, src):
    b = 0 if ad < 0x4000 else b
    if nm == '-': names.pop((b, ad), None)
    else: names[(b, ad)] = [nm, conf, note, src]
for r in csv.DictReader(open(a.auto)): put(int(r['bank'], 16), int(r['addr'], 16), r['name'], r['conf'], r['note'], r['source'])
# 2. banked asset labels of the old tables
lab = collections.defaultdict(set)
for r in csv.DictReader(open(a.symtab)):
    if r['kind'] == 'label' and r['space'] == 'ROMX': lab[(r['name'], int(r['byte2']), int(r['value'], 16))].add(r['table'])
for (nm, b, v), tabs in sorted(lab.items(), key=lambda k: (k[0][1], k[0][2])):
    old = names.get((b, v))
    if old: put(b, v, nm, 'C', '%s in both old symbol tables (same bank and address); this build copies a block here (%s)' % (nm, old[0]), 'symtab_asset')
    else: put(b, v, nm, 'I', '%s in %s old symbol table%s at this bank and address; this build neither copies nor reads it (L2 runs)' % (
        nm, 'both' if len(tabs) == 2 else 'one', 's' if len(tabs) == 2 else ''), 'symtab_asset')
# 3. port from the old builds
rows = [r for r in csv.DictReader(open(a.match)) if r['hits'] == '1']
byname = collections.defaultdict(list)
for r in rows: byname[r['name']].append(r)
keep = []
for nm, rs in byname.items():
    best = max(int(r['bytes']) for r in rs)
    keep += [r for r in rs if r['new_addr'] == next(x['new_addr'] for x in rs if int(x['bytes']) == best)]
byaddr = collections.defaultdict(list)
for r in keep: byaddr[r['new_addr']].append(r)
for ad, rs in sorted(byaddr.items()):
    cand = collections.defaultdict(list)
    for r in rs: cand[r['name']].append(r)
    order = sorted(cand.items(), key=lambda kv: (-len({x['table'] for x in kv[1]}), -max(int(x['bytes']) for x in kv[1]), kv[0]))
    nm, rr = order[0]
    tie = len(order) > 1 and len({x['table'] for x in order[1][1]}) == len({x['table'] for x in rr}) and \
          max(int(x['bytes']) for x in order[1][1]) == max(int(x['bytes']) for x in rr)
    ln = max(int(x['bytes']) for x in rr)
    conf = '?' if tie else ('C' if ln >= a.min_port else 'I')
    what = 'the same bytes as the data label' if rr[0]['kind'] == 'data' else 'same code as'
    note = 'developers\' name: %s %s in the old build of table %s (%s bytes, %s match)' % (what, 
        nm, ' and '.join('%s at old %s' % (x['table'], x['old_addr']) for x in sorted(rr, key=lambda x: x['table'])), ln, rr[0]['kind'])
    if len(order) > 1: note += '; other names on this address: ' + ', '.join(o[0] for o in order[1:])
    put(0, int(ad, 16), nm, conf, note, 'port_old')
# 4. hand
for r in csv.DictReader(open(a.hand)): put(int(r['bank'], 16), int(r['addr'], 16), r['name'], r['conf'], r['note'], r['source'])
# checks
LABEL = re.compile(r'^[A-Za-z_][A-Za-z0-9_]*$')
seen = {}
for k, v in names.items():
    if not LABEL.match(v[0]): sys.exit('proto_names: invalid label %s at %02X:%04X' % (v[0], *k))
    if v[0] in seen: sys.exit('proto_names: %s on %02X:%04X and %02X:%04X' % (v[0], *seen[v[0]], *k))
    seen[v[0]] = k
ROM = open(a.rom, 'rb').read(); T = json.load(open(a.trace))
code = {int(k[3:], 16) for k in T['code'] if k.startswith('00:')}
ent = {0x0040, 0x0048, 0x0050, 0x0058, 0x0100} | {t for t in T['tables'].get('00:3822', [])}
for ad in code:
    if ROM[ad] in (0xCD, 0xC4, 0xCC, 0xD4, 0xDC):
        t = ROM[ad + 1] | ROM[ad + 2] << 8
        if t < 0x4000: ent.add(t)
unnamed = sorted(t for t in ent if (0, t) not in names)
with open(a.out, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['bank', 'addr', 'name', 'conf', 'note', 'source'])
    for (b, ad), (nm, c, note, src) in sorted(names.items()): w.writerow(['%02X' % b, '%04X' % ad, nm, c, note, src])
tags = collections.Counter(v[1] for v in names.values())
doubt = sorted((k, v) for k, v in names.items() if v[1] != 'C')
with open(a.doubts, 'w') as f:
    f.write('# Prototype: names not tagged C (doubts list)\n\nGenerated by `tools/proto_names.py` from the name layers (%d names: C %d / I %d / ? %d). '
            'Every name below is a hypothesis until the code or an emulator confirms it.\n\n| address | name | tag | source | reason |\n|---|---|---|---|---|\n' % (
                len(names), tags['C'], tags['I'], tags['?']))
    for (b, ad), (nm, c, note, src) in doubt: f.write('| %02X:%04X | %s | %s | %s | %s |\n' % (b, ad, nm, c, src, note.replace('|', '/')))
print('proto_names: %d names, tags %s; routine entries %d, unnamed %d%s' % (len(names), dict(sorted(tags.items())), len(ent), len(unnamed),
      (' (' + ' '.join('%04X' % t for t in unnamed) + ')') if unnamed else ''))
src = collections.Counter(v[3] for v in names.values()); print('by source:', dict(sorted(src.items())))
