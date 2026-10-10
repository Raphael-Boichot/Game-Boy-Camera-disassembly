#!/usr/bin/env python3
"""Merge several coverage_run state dirs into one: corpus recipes (ids remapped), coverage OR (+organic), bank-select counts.
Usage: merge_states.py OUTDIR DIR1 DIR2 ..."""
import sys as _s, os as _o
_s.path.insert(0, _o.path.join(_o.path.dirname(_o.path.abspath(__file__)), '..', 'src'))
import paths
import sys, os, json, shutil, collections
import numpy as np
out = sys.argv[1]; dirs = sys.argv[2:]; os.makedirs(out, exist_ok=True)
site = site2 = rmode = None; entries = []; ex = oex = dr = odr = rdr = ram = oram = None; bsel = collections.Counter(); bsel_o = collections.Counter(); cs = collections.Counter(); cs_o = collections.Counter(); stats = dict(iters=0, frames=0, secs=0.0, ckpts=0)
for d in dirs:
    off = len(entries)
    cp = os.path.join(d, 'corpus.jsonl')          # the package keeps the corpora gzipped in results/corpus/; a pass folder without corpus.jsonl only contributes coverage
    for line in (open(cp) if os.path.exists(cp) else []):
        if not line.strip(): continue
        e = json.loads(line); e['id'] += off
        if e.get('parent', -1) >= 0: e['parent'] += off
        entries.append(e)
    z = np.load(os.path.join(d, 'cov.npz'))
    zex = z['ex']; zdr = z['dr']; zoex = z['oex'] if 'oex' in z.files else zex; zodr = z['odr'] if 'odr' in z.files else zdr
    def mrg(a, b): return np.where((a == 1) | (b == 1), 1, np.where((a | b) != 0, 2, 0)).astype(np.uint8) if a is not None else b.copy()
    ex = mrg(ex, zex); oex = mrg(oex, zoex)
    dr = zdr.copy() if dr is None else dr | zdr; odr = zodr.copy() if odr is None else odr | zodr
    rdr = z['rdr'].copy() if rdr is None else np.where(rdr != 0, rdr, z['rdr'])
    ram = z['ram'].copy() if ram is None else ram | z['ram']
    zoram = z['oram'] if 'oram' in z.files else z['ram']; oram = zoram.copy() if oram is None else oram | zoram
    for wb, pc, nb, c in z['bsel']: bsel[(int(wb), int(pc), int(nb))] += int(c)
    for wb, pc, nb, c in (z['bsel_org'] if 'bsel_org' in z.files else z['bsel']): bsel_o[(int(wb), int(pc), int(nb))] += int(c)
    if 'site' in z.files:
        site = z['site'].copy() if site is None else np.where(site != 0, site, z['site']); site2 = z['site2'].copy() if site2 is None else np.where(site2 != 0, site2, z['site2']); rmode = z['rmode'].copy() if rmode is None else np.where(rmode != 0, rmode, z['rmode'])
    if 'csite' in z.files:
        for k, c in z['csite']: cs[int(k)] += int(c)
        for k, c in z['csite_org']: cs_o[int(k)] += int(c)
    try:
        s = json.load(open(os.path.join(d, 'stats.json')))
        for k in ('iters', 'frames', 'secs'): stats[k] += s.get(k, 0)
    except Exception: pass
np.savez_compressed(os.path.join(out, 'cov.npz'), **({} if site is None else dict(site=site, site2=site2, rmode=rmode)), csite=np.array(list(cs.items()), dtype=np.uint32).reshape(-1, 2), csite_org=np.array(list(cs_o.items()), dtype=np.uint32).reshape(-1, 2), oex=oex, odr=odr, oram=oram, ex=ex, dr=dr, rdr=rdr, ram=ram,
                    bsel_org=np.array([[a, b, c, n] for (a, b, c), n in bsel_o.items()], dtype=np.uint32).reshape(-1, 4),
                    bsel=np.array([[a, b, c, n] for (a, b, c), n in bsel.items()], dtype=np.uint32).reshape(-1, 4))
open(os.path.join(out, 'corpus.jsonl'), 'w').write('\n'.join(json.dumps(e) for e in entries) + '\n')
json.dump(stats, open(os.path.join(out, 'stats.json'), 'w'))
print('merged', len(entries), 'entries; exec bytes', int((ex != 0).sum()), 'organic', int((oex != 0).sum()))
