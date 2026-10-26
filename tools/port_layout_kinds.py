#!/usr/bin/env python3
"""Carry the kind rows of roms/jp_rev_a/assets/layout_kind_overrides_jp.csv (what a Src_* / Data_* block is: tiles, map, table...) to another build.

  tools/port_layout_kinds.py JP.gb OTHER.gb PORT_REPORT.csv OUT.csv [--kinds roms/jp_rev_a/assets/layout_kind_overrides_jp.csv]

A row is keyed by its label: it goes where tools/port_syms.py put that label (port_report: new_loc, new_name), with the same length,
if that length stays inside the bank. Its evidence becomes I in the other build, and the basis says whether the bytes are the same
there (then the JP evidence holds as it is) or not (the kind is inferred from the same consumer).
"""
import csv, argparse
ap = argparse.ArgumentParser(); ap.add_argument('jp'); ap.add_argument('other'); ap.add_argument('report'); ap.add_argument('out')
ap.add_argument('--kinds', default='roms/jp_rev_a/assets/layout_kind_overrides_jp.csv')
a = ap.parse_args()
JP = open(a.jp, 'rb').read(); OT = open(a.other, 'rb').read()
def off(b, ad): return ad if ad < 0x4000 else b * 0x4000 + ad - 0x4000
where = {r['jp_name']: r for r in csv.DictReader(open(a.report, encoding='utf-8')) if r['new_loc']}
rows = list(csv.DictReader(open(a.kinds, encoding='utf-8'))); out = []; lost = 0
for r in rows:
    w = where.get(r['label'])
    if not w: lost += 1; continue
    b, ad = (int(x, 16) for x in w['new_loc'].split(':')); n = int(r['end'], 16) - int(r['start'], 16)
    if (ad < 0x4000 and ad + n > 0x4000) or (ad >= 0x4000 and ad + n > 0x8000): lost += 1; continue
    jo = off(int(r['bank'], 16), int(r['start'], 16)); uo = off(b, ad)
    same = JP[jo:jo + n] == OT[uo:uo + n]
    out.append({'bank': '%02X' % b, 'start': '%04X' % ad, 'end': '%04X' % (ad + n), 'kind': r['kind'], 'ev': 'I', 'label': w['new_name'],
                'basis': ('JP %s:%s, same bytes here: ' % (r['bank'], r['start']) if same else 'JP %s:%s, other bytes here (same consumer): ' % (r['bank'], r['start'])) + r['basis']})
with open(a.out, 'w', newline='', encoding='utf-8') as f:
    w = csv.DictWriter(f, fieldnames=list(rows[0].keys()), lineterminator='\n'); w.writeheader(); w.writerows(out)
print('kind rows: %d carried, %d not (label not carried or block past the bank)' % (len(out), lost))
