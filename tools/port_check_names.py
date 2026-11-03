#!/usr/bin/env python3
"""Confirm (tag C) the carried names of a ported build that the port left at I, from evidence of this build only (the `checked` layer).

  tools/port_check_names.py JP.gb OTHER.gb MAP.npy JP_NAMES.csv OTHER_NAMES.csv COV.npz TRACE.json --out X.csv [--report R.csv]

Rules (a name is confirmed only when its Japanese name is C):
  table   `placed by the word table T (entry N)`: entry N of this build's table points here, so the role is the Japanese entry N's.
  pointers `content differs`: every differing byte lies in a 16-bit word that, read in the Japanese block, maps through the byte map
          (MAP.npy) to the word read here: the block is the Japanese one with relocated pointers.
  ran     `routine differs` with at most a quarter of the Japanese instructions unpaired, and the routine's first byte executed in
          the coverage run of this build (COV ex): the same routine, adapted, and live.
Everything else stays I. The note keeps the port's note and adds the rule that confirmed it.
"""
import sys, csv, re, argparse, json
import numpy as np
ap = argparse.ArgumentParser(); ap.add_argument('jp'); ap.add_argument('other'); ap.add_argument('map'); ap.add_argument('jp_names'); ap.add_argument('names')
ap.add_argument('cov'); ap.add_argument('trace'); ap.add_argument('--out', required=True); ap.add_argument('--report')
a = ap.parse_args()
J = open(a.jp, 'rb').read(); U = open(a.other, 'rb').read(); M = np.load(a.map); ex = np.load(a.cov)['ex'] != 0
def flat(b, ad): return ad if b == 0 or ad < 0x4000 else b * 0x4000 + ad - 0x4000
JC = {}
for r in csv.DictReader(open(a.jp_names, encoding='utf-8')): JC[(int(r['bank'], 16), int(r['addr'], 16))] = r['conf']
rows = list(csv.DictReader(open(a.names, encoding='utf-8')))
offs = sorted(flat(int(r['bank'], 16), int(r['addr'], 16)) for r in rows)
import bisect
out, rep = [], []
for r in rows:
    if r['conf'] != 'I': continue
    m = re.search(r'port JP ([0-9A-F]{2}):([0-9A-F]{4})', r['source'])
    if not m: continue
    jb, ja = int(m.group(1), 16), int(m.group(2), 16)
    if JC.get((jb, ja)) != 'C': continue
    b, ad = int(r['bank'], 16), int(r['addr'], 16); o = flat(b, ad); jo = flat(jb, ja); rule = None
    if 'placed by the word table' in r['source'] and 'routine differs' not in r['source'] and 'content differs' not in r['source']:
        rule = 'table'
    elif 'content differs' in r['source']:
        i = bisect.bisect_right(offs, o); e = min(offs[i] if i < len(offs) else 1 << 20, (o // 0x4000 + 1) * 0x4000); n = e - o
        jb_ = J[jo:jo + n]; ub = U[o:o + n]
        if len(jb_) == n and 0 < n <= 4096:
            diff = [k for k in range(n) if jb_[k] != ub[k]]; ok = bool(diff)
            for k in diff:
                good = False
                for s in (k - 1, k):
                    if 0 <= s and s + 1 < n:
                        wj = jb_[s] | jb_[s + 1] << 8; wu = ub[s] | ub[s + 1] << 8
                        if 0x4000 <= wj < 0x8000 or wj < 0x4000:
                            src = flat(jb if wj >= 0x4000 else 0, wj); t = int(M[src]) if src < len(M) else -1
                            if t >= 0 and ((t & 0x3FFF) | (0x4000 if t >= 0x4000 else 0)) == wu: good = True
                if not good: ok = False; break
            if ok: rule = 'pointers'
    elif 'routine differs' in r['source']:
        mm = re.search(r'routine differs: (\d+) of (\d+)', r['source'])
        if mm and int(mm.group(1)) * 4 <= int(mm.group(2)) and ex[o]: rule = 'ran'
    if rule:
        why = {'table': 'C: entry of the same word table as the Japanese name (structure)',
               'pointers': 'C: the Japanese bytes with relocated pointers only (every differing byte is in a word that maps through the byte map)',
               'ran': 'C: the routine is executed in this build\'s coverage run and at most a quarter of its Japanese instructions are unpaired'}[rule]
        out.append([r['bank'], r['addr'], r['name'], 'C', (r['note'] + '; ' if r['note'] else '') + why, 'checked: ' + r['source']])
    rep.append([r['bank'], r['addr'], r['name'], rule or ''])
with open(a.out, 'w', newline='', encoding='utf-8') as fh:
    w = csv.writer(fh, lineterminator='\n'); w.writerow(['bank', 'addr', 'name', 'conf', 'note', 'source']); w.writerows(out)
import collections; print('checked layer: %d names confirmed' % len(out), dict(collections.Counter(x[3] or 'still I' for x in rep)))
if a.report:
    with open(a.report, 'w', newline='', encoding='utf-8') as fh: csv.writer(fh, lineterminator='\n').writerows(rep)
