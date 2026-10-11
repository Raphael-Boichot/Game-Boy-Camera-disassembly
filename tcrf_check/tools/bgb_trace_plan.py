#!/usr/bin/env python3
"""Between phase 1 (bgb_trace_core.py, one JSON per replayed corpus) and phase 2 (bgb_trace_run.py): give every block head ONE witness entry across all corpora.
The non-printer entries of the first JSON on the command line are kept as they are (that corpus is the one already tested in BGB); for every other head the witness is the non-printer entry with the
fewest frames among the other corpora (cheapest to replay in BGB).  Heads whose only witnesses are printer lineages are listed apart: BGB has no printer
that can be attached from the command line, so they cannot be tested.
Writes  OUTDIR/plan_<stem>.json (same layout as the phase-1 JSON, 'new' reduced to the assigned heads) and OUTDIR/plan_summary.json.
usage: bgb_trace_plan.py OUTDIR CORE1.json [CORE2.json ...]"""
import sys, os, json
outdir, files = sys.argv[1], sys.argv[2:]
os.makedirs(outdir, exist_ok=True)
D = [json.load(open(f)) for f in files]
stems = [os.path.basename(f)[len('core_'):-len('.json')] for f in files]
best = {}                                   # head -> (printer, frames, corpus index, entry id)
for ci, d in enumerate(D):
    for i, e in d['entries'].items():
        for h in e['new']:
            key = (1 if e['printer'] else 0, e['frames'], ci, int(i))
            if ci == 0 and not e['printer']: key = (-1, 0, 0, int(i))      # heads of the first JSON's non-printer entries stay with it (already tested)
            if h not in best or key < best[h]: best[h] = key
assigned = {ci: {} for ci in range(len(D))}
printer_only = []
for h, (pr, fr, ci, i) in best.items():
    if pr == 1: printer_only.append(h); continue
    assigned[ci].setdefault(i, []).append(h)
summ = dict(corpora=stems, printer_only=sorted(printer_only), witnesses={})
for ci, d in enumerate(D):
    ent = {}
    for i, hs in assigned[ci].items():
        e = dict(d['entries'][str(i)]); e['new'] = sorted(hs); ent[str(i)] = e
    nd = dict(d); nd['entries'] = ent
    json.dump(nd, open(os.path.join(outdir, 'plan_%s.json' % stems[ci]), 'w'))
    summ['witnesses'][stems[ci]] = dict(entries=len(ent), heads=sum(len(v) for v in assigned[ci].values()), frames=sum(ent[k]['frames'] for k in ent))
    print('%-16s witness entries %5d  heads %5d  total frames %9d' % (stems[ci], len(ent), summ['witnesses'][stems[ci]]['heads'], summ['witnesses'][stems[ci]]['frames']))
print('heads with a witness: %d   printer-only: %d' % (len(best) - len(printer_only), len(printer_only)))
json.dump(summ, open(os.path.join(outdir, 'plan_summary.json'), 'w'))
