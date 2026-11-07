#!/usr/bin/env python3
"""Screen names (mode, state, name) for tools/screen_tree.py from the L4 tables of a retail ROM.

  tools/screen_names_from_states.py CONST_NAMES.csv STATE_NAMES.csv OUT.csv

name = the mode's description in CONST_NAMES (group `mode`, up to the first ':' or '(') and the state constant of STATE_NAMES
(group `state_MM`) written in words: MODE_MAIN_MENU / STATE_00_LOAD_PAGE -> "Main menu - load page". The tags are those of
the tables (C / I). Generated: never edit OUT by hand, rename the labels and rerun the tables' own generators instead.
"""
import sys, csv, re
cn, sn, out = sys.argv[1:4]
modes = {}
for r in csv.DictReader(open(cn)):
    if r['group'] == 'mode': modes[r['value'].upper()] = re.split(r'[:(]', r['desc'] or r['name'])[0].strip()
rows = []
for r in csv.DictReader(open(sn)):
    m = re.match(r'state_([0-9a-fA-F]{2})$', r['group'])
    if not m: continue
    mm = m.group(1).upper(); st = r['value'].upper()
    words = re.sub(r'^STATE_[0-9A-F]{2}_', '', r['name']).replace('_', ' ').lower()
    rows.append([mm, st, '%s - %s' % (modes.get(mm, 'mode $' + mm), words), r['tag']])
with open(out, 'w', newline='') as f:
    w = csv.writer(f); w.writerow(['mode', 'state', 'name', 'tag']); w.writerows(rows)
print(out, len(rows))
