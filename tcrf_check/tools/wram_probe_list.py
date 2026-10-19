#!/usr/bin/env python3
"""Watch list for wram_probe.py: one row per RAM name of disasm/ram_names_jp.csv that carries the tag ? or U (or a tag listed with --tags), with the access kinds that the static access table
(wram/wram_access.csv) has for it.  Output CSV: name,addr,size,tag,static (sorted set of R / W / P kinds, '-' = no access at all).
usage: wram_probe_list.py OUT.csv [--tags ?,U,I]    (default tags ?,U)"""
import sys, csv, os, collections
R = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))) + '/'
tags = '?,U'
a = sys.argv[1:]
out = a[0]
if '--tags' in a: tags = a[a.index('--tags') + 1]
tags = set(tags.split(','))
by = collections.defaultdict(set)
for r in csv.DictReader(open(R + 'wram/wram_access.csv', encoding='utf-8')): by[int(r['addr'], 16)].add(r['kind'])
rows = []
for r in csv.DictReader(open(R + 'disasm/ram_names_jp.csv', encoding='utf-8')):
    if r['tag'] not in tags: continue
    ad = int(r['addr'], 16); n = int(r['size'])
    k = set()
    for x in range(ad, ad + n): k |= by.get(x, set())
    rows.append((r['name'], '%04X' % ad, n, r['tag'], ''.join(sorted(k)) or '-'))
with open(out, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['name', 'addr', 'size', 'tag', 'static']); w.writerows(rows)
print(len(rows), 'rows ->', out)
