#!/usr/bin/env python3
"""Compare the BGB sweep log (bgb_sig.py output) with the (mode,state) my core reaches on the same paths (atlas_replay.py JP result.json).
usage: bgb_compare.py BGB_LOG CORE_RESULT_JSON [OUT.csv]"""
import sys, re, json, csv
log, core = sys.argv[1], json.load(open(sys.argv[2]))
rows = []
for l in open(log):
    m = re.match(r'(\w\w:\w\w) entry (\d+) BGB rc (\d+) mode:state = (\w\w):(\w\w)', l)
    if m:
        sig, e, rc, bm, bs = m.groups(); c = core.get(sig); cr = c['reached'] if c else '?'
        bg = '%s:%s' % (bm, bs); kind = 'exact' if bg == cr else ('same mode' if bg[:2] == cr[:2] else 'different')
        rows.append((sig, int(e), cr, bg, kind))
    elif 'SKIP' in l: rows.append((l.split()[0], '', '', '', 'skipped (printer)'))
    elif 'no entry' in l: rows.append((l.split()[0], '', '', '', 'no entry'))
from collections import Counter
cnt = Counter(r[4] for r in rows); print(dict(cnt), 'total', len(rows))
if len(sys.argv) > 3:
    w = csv.writer(open(sys.argv[3], 'w', newline=''), lineterminator='\n'); w.writerow(['target_sig', 'corpus_entry', 'core_reached', 'bgb_reached', 'comparison']); w.writerows(rows)
for r in rows:
    if r[4] == 'different': print(r)
