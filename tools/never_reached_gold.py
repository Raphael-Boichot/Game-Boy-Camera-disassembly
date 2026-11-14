#!/usr/bin/env python3
"""Never-reached assets of the Gold edition (README, Gold section), from the Gold ROM's own coverage runs in the core (coverage/tools/coverage_run.py with
GBCAM_ROM = the Gold ROM: a fresh run, a run on the unlocking saves and a third one, about one hour each, 2026-11-01).

  tools/never_reached_gold.py JP.gb INTL.gb GOLD.gb OUTDIR COV.npz [COV.npz ...]

Two tables (OUTDIR):
  never_reached_gold.csv   the never-reached assets of the Japanese ROM (roms/jp_rev_a/experiments/unidentified/really_unused.csv, tiers other than shown) found in the
                                 Gold ROM (same address / moved / absent) and how many of their bytes the Gold runs read (any run / organic runs only)
  gold_own_never_read.csv        the data blocks of the Gold ROM whose bytes differ from the international ROM at the same address (the Gold edition's own content) and
                                 that no organic Gold run read; plus the counts of those that were read
A byte read by a forced run only (state pokes) does not count as organic."""
import sys, os, csv, collections
import numpy as np
J, U, G = (open(p, 'rb').read() for p in sys.argv[1:4]); OUT = sys.argv[4]; COVS = sys.argv[5:]
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__))); os.makedirs(OUT, exist_ok=True)
def off(b, a): return a if b == 0 else b * 0x4000 + a - 0x4000
def loc(o): return '%02X:%04X' % (o // 0x4000, o if o < 0x4000 else o % 0x4000 + 0x4000)
dr = np.zeros(len(G), bool); odr = np.zeros(len(G), bool)
for c in COVS:
    z = np.load(c); dr |= z['dr'][:len(G)] > 0; odr |= z['odr'][:len(G)] > 0
# ---- A: the Japanese never-reached assets in the Gold ROM
rows = list(csv.DictReader(open(os.path.join(ROOT, 'roms', 'jp_rev_a', 'experiments', 'unidentified', 'really_unused.csv'), encoding='utf-8')))
outA = []
for r in rows:
    if r['tier'] == 'shown': continue
    o = off(int(r['bank'], 16), int(r['addr'], 16)); n = int(r['bytes']); blk = J[o:o + n]
    f = o if G[o:o + n] == blk else G.find(blk)
    st = 'absent' if f < 0 else ('same address' if f == o else ('small match elsewhere (coincidence possible)' if n < 64 else 'moved'))
    rd = int(dr[f:f + n].sum()) if f >= 0 else 0; ro = int(odr[f:f + n].sum()) if f >= 0 else 0
    outA.append(dict(jp_bank=r['bank'], jp_addr=r['addr'], bytes=n, jp_name=r['name'], jp_tier=r['tier'], gold_addr=loc(f) if f >= 0 else '', gold_status=st,
                     gold_bytes_read_any_run=rd, gold_bytes_read_organic=ro))
with open(os.path.join(OUT, 'never_reached_gold.csv'), 'w', newline='', encoding='utf-8') as fh:
    w = csv.DictWriter(fh, fieldnames=list(outA[0].keys()), lineterminator='\n'); w.writeheader(); w.writerows(outA)
# ---- B: the Gold edition's own data blocks (bytes differ from the international ROM), read or not
names = {}
for suf in ('', '_loaders', '_reads', '_checked', '_hand'):
    p = os.path.join(ROOT, 'roms', 'gold', 'disasm', 'layers', 'sym_names_gold%s.csv' % (suf or '_port'))
    if not os.path.exists(p): continue
    for r in csv.DictReader(open(p, encoding='utf-8')):
        k = off(int(r['bank'], 16), int(r['addr'], 16))
        if r['name'] == '-': names.pop(k, None)
        else: names[k] = r['name']
starts = sorted(names); code = set()
import json
for k, n in json.load(open(os.path.join(ROOT, 'roms', 'gold', 'trace', 'trace_gold.json')))['code'].items():
    if n > 0: b, a = k.split(':'); o = off(int(b, 16), int(a, 16)); code.update(range(o, o + n))
KINDS = ('Gfx_', 'Map_', 'Sheet_', 'StampCat', 'AlbumB', 'Font_', 'Src_', 'Data_', 'Unused_', 'BgMap_', 'WildFrame', 'Border', 'Song', 'Sfx')
outB = []; cnt = collections.Counter()
for i, o in enumerate(starts):
    nm = names[o]
    if not nm.startswith(KINDS) or o in code: continue
    e = min(starts[i + 1] if i + 1 < len(starts) else len(G), (o // 0x4000 + 1) * 0x4000); n = e - o
    diff = sum(1 for x in range(o, e) if G[x] != U[x])
    if not diff: continue
    ro = int(odr[o:e].sum()); rd = int(dr[o:e].sum())
    cnt['own, read organically' if ro else ('own, read only by forced runs' if rd else 'own, never read')] += 1
    if ro == 0: outB.append(dict(gold_addr=loc(o), bytes=n, name=nm, bytes_differing_from_intl=diff, read_any_run=rd, read_organic=ro))
with open(os.path.join(OUT, 'gold_own_never_read.csv'), 'w', newline='', encoding='utf-8') as fh:
    w = csv.DictWriter(fh, fieldnames=['gold_addr', 'bytes', 'name', 'bytes_differing_from_intl', 'read_any_run', 'read_organic'], lineterminator='\n'); w.writeheader(); w.writerows(outB)
print('A:', collections.Counter((x['gold_status'], 'organic read' if x['gold_bytes_read_organic'] else 'not read organically') for x in outA))
print('B:', dict(cnt))
