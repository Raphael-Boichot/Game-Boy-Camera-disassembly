#!/usr/bin/env python3
"""Verdict of the L3 BGB pass (README 1.3): which inferred names were seen at work, in which screens, and whether that fits the name.

usage: l3_verdict.py HITS(.csv.gz | .partial.jsonl) TARGETS.csv OUT.csv [--names roms/jp_rev_a/disasm/sym_names_jp.csv]
For every target: the replays and hits, the modes ($D5CE) and {mode:state} pairs it ran or was read in, the program counters of the readers (read targets), and a verdict:
  seen       executed / read in organic play, in a mode its name allows
  mode?      seen, but the name places it in a mode (`ModeNN_` prefix of the name or of a consumer in an asset name / note) that none of its hits has
  never      no hit in the 206 replays
The mode a name allows: the NN of every `ModeNN_` in the name (an asset name ends with its consumer) and in its note (`copied to VRAM/WRAM by ...`, `referenced by ...`); a name
without one allows any mode.  OUT.csv: bank, addr, name, kind, verdict, replays, hits, modes, states, readers, expected."""
import sys, os, csv, json, re, collections
REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
a = sys.argv[1:]
def opt(n, d):
    if n in a: i = a.index(n); v = a[i + 1]; del a[i:i + 2]; return v
    return d
names = opt('--names', os.path.join(REPO, 'roms', 'jp_rev_a', 'disasm', 'sym_names_jp.csv')); hitsf, tf, out = a[:3]
T = list(csv.DictReader(open(tf, encoding='utf-8')))
NOTE = {r['name']: r['note'] for r in csv.DictReader(open(names, encoding='utf-8'))}
agg = collections.defaultdict(lambda: dict(rep=set(), hits=0, modes=collections.Counter(), states=collections.Counter(), pcs=collections.Counter()))
seen_entries = set()
def add(i, t, pc, mo, st, v):
    g = agg[int(t[1:], 16)]; g['rep'].add(i); g['hits'] += v; g['modes'][mo] += v; g['states']['%s:%s' % (mo, st)] += v; g['pcs'][pc] += v
if hitsf.endswith('.csv') or hitsf.endswith('.csv.gz'):          # the CSV written by bgb_span_read_probe.py (l3_hits.csv.gz)
    import gzip
    for r in csv.DictReader(gzip.open(hitsf, 'rt') if hitsf.endswith('.gz') else open(hitsf)):
        seen_entries.add(r['entry'])
        if r['tag'].startswith('T'): add(r['entry'], r['tag'], r['pc'], r['mode'], r['state'], int(r['hits']))
else:                                                               # its OUT.partial.jsonl
    for l in open(hitsf):
        if not l.strip(): continue
        i, sig, end, res = json.loads(l)
        if i in seen_entries: continue
        seen_entries.add(i)
        for k, v in res.items():
            m = re.match(r'^(T[0-9A-F]{3})_([0-9A-F]{4})_([0-9A-F]{2})_([0-9A-F]{2})$', k)
            if m: add(i, m.group(1), m.group(2), m.group(3), m.group(4), v)
rows = []; cnt = collections.Counter()
for k, t in enumerate(T):
    exp = sorted(set(re.findall(r'Mode([0-9A-F]{2})_', t['name'] + ' ' + NOTE.get(t['name'], ''))))
    g = agg.get(k)
    if not g: v = 'never'
    elif exp and not (set(exp) & set(g['modes'])): v = 'mode?'
    else: v = 'seen'
    cnt[v] += 1
    rows.append([t['bank'], t['addr'], t['name'], t['kind'], v, len(g['rep']) if g else 0, g['hits'] if g else 0,
                 ' '.join(sorted(g['modes'])) if g else '', ' '.join(s for s, _ in g['states'].most_common(8)) if g else '',
                 ' '.join(p for p, _ in g['pcs'].most_common(6)) if g and t['kind'] == 'r' else '', ' '.join(exp)])
with open(out, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['bank', 'addr', 'name', 'kind', 'verdict', 'replays', 'hits', 'modes', 'states', 'readers', 'expected']); w.writerows(rows)
print('%d replays read; %s -> %s' % (len(seen_entries), dict(cnt), out))
