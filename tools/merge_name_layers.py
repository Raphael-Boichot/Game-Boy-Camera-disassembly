#!/usr/bin/env python3
"""Merge the name and type layers of a ROM into its final tables (HOWTO_NEW_ROM.md section 0.1, rule 2).

  tools/merge_name_layers.py --tag us [--dir roms/us_eu] [--check]

Reads roms/<folder>/disasm/layers/sym_names_<tag>_<layer>.csv and sym_types_<tag>_<layer>.csv, the layers that exist, in the fixed
order port < auto < loaders < reads < checked < hand (a later layer wins), and writes the two tables a reader opens and every
build tool reads:

  disasm/sym_names_<tag>.csv  bank,addr,name,conf,note,source: one row per labelled address, the row of the last layer that has it
                              (name `-` or empty removes the label, as in tools/sym_build.py), sorted by bank and address; the
                              source column starts with the layer (`hand: evidence 2026-11-02`)
  disasm/sym_types_<tag>.csv  bank,start,end,type,width,note: the rows of the layers one after the other, in layer order (type rows
                              are applied in order and the last one wins, so they are not merged)

Both are generated: edit a layer (the hand layer for a correction), then rerun this script. tools/port_build.py runs it before
tools/sym_build.py; --check compares the committed tables with a fresh merge and exits 1 if they differ (the consistency checker
runs it). The Japanese folder has no layers: its sym_names_jp.csv is the edited table. The Hello Kitty and prototype folders merge
their layers with their own tools (tools/kitty_names.py, tools/proto_names.py), which also read the trace and the older builds.
"""
import argparse, csv, io, os, sys
ORDER = ('port', 'auto', 'loaders', 'reads', 'checked', 'hand')
FOLDER = {'us': 'roms/us_eu', 'gold': 'roms/gold'}
ap = argparse.ArgumentParser(); ap.add_argument('--tag', required=True); ap.add_argument('--dir'); ap.add_argument('--check', action='store_true')
a = ap.parse_args()
D = a.dir or FOLDER[a.tag]; L = os.path.join(D, 'disasm', 'layers')
def layer(kind, l): return os.path.join(L, 'sym_%s_%s_%s.csv' % (kind, a.tag, l))
NCOL = ['bank', 'addr', 'name', 'conf', 'note', 'source']; TCOL = ['bank', 'start', 'end', 'type', 'width', 'note']
names, used_n, used_t = {}, [], []
for l in ORDER:
    f = layer('names', l)
    if not os.path.exists(f): continue
    used_n.append(l)
    for r in csv.DictReader(open(f, encoding='utf-8')):
        if not r.get('bank') or r['bank'].startswith('#'): continue
        k = (int(r['bank'], 16), int(r['addr'], 16))
        if r['name'] in ('-', ''): names.pop(k, None); continue
        src = (r.get('source') or '').strip()
        row = {c: (r.get(c) or '') for c in NCOL}
        row['source'] = src if src == l or src.startswith(l + ':') or src.startswith(l + ' ') else ('%s: %s' % (l, src) if src else l)
        names[k] = row
types = []
for l in ORDER:
    f = layer('types', l)
    if not os.path.exists(f): continue
    used_t.append(l)
    for r in csv.DictReader(open(f, encoding='utf-8')):
        if not r.get('bank') or r['bank'].startswith('#'): continue
        types.append({c: (r.get(c) or '') for c in TCOL})
def text(cols, rows):
    s = io.StringIO(); w = csv.DictWriter(s, cols, lineterminator='\n'); w.writeheader(); w.writerows(rows); return s.getvalue()
out = {os.path.join(D, 'disasm', 'sym_names_%s.csv' % a.tag): text(NCOL, [names[k] for k in sorted(names)])}
if used_t: out[os.path.join(D, 'disasm', 'sym_types_%s.csv' % a.tag)] = text(TCOL, types)
if not used_n: sys.exit('no name layer in %s' % L)
bad = 0
for f, t in out.items():
    if a.check:
        cur = open(f, encoding='utf-8').read() if os.path.exists(f) else None
        if cur != t: print('stale: %s (rerun tools/merge_name_layers.py --tag %s)' % (f, a.tag)); bad = 1
    else: open(f, 'w', encoding='utf-8').write(t)
print('%s: %d names from layers %s; %d type rows from layers %s%s' % (a.tag, len(names), '<'.join(used_n), len(types), '<'.join(used_t) or '-', ' (check)' if a.check else ''))
sys.exit(bad)
