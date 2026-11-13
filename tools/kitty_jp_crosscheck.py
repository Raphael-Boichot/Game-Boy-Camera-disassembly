#!/usr/bin/env python3
"""Hello Kitty Pocket Camera: every never-run piece against the same code in the Japanese ROM (2026-11-13).

  tools/kitty_jp_crosscheck.py [--check]          writes roms/hello_kitty/trace/jp_crosscheck_kitty.csv

The owner asked whether each never-run piece had first been tried the way the Japanese ROM solved it. For every piece of
trace/red_kitty.csv, the routine it lies in is looked up in disasm/match_jp_kitty.csv (same code, every Kitty copy) and
disasm/similar_jp_kitty.csv (edited copies, ratio >= 0.9); the piece is moved by its offset into the Japanese routine and the
Japanese fate of those bytes is read: executed in the Japanese runs (trace/cov_jp_runs.npz), or the Japanese verdict
(assets/reach_ranges_jp.csv). Columns: the Kitty piece, its Kitty verdict (trace/red_verdicts_kitty.csv), the Japanese
address and routine, the Japanese fate, and a category: JP_RAN (all bytes ran in the Japanese ROM: its route is the one to
copy), JP_PART, JP_VERDICT, JP_RED (no verdict there either), NO_JP (no Japanese counterpart: Kitty code, or a copy too
edited to place the piece).
"""
import sys, os, csv, argparse, collections
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
K = os.path.join(REPO, 'roms', 'hello_kitty'); J = os.path.join(REPO, 'roms', 'jp_rev_a')
ap = argparse.ArgumentParser(); ap.add_argument('--check', action='store_true'); a = ap.parse_args()
ex = np.load(os.path.join(J, 'trace', 'cov_jp_runs.npz'))['ex']
def off(b, x): return b * 0x4000 + x - 0x4000 if b else x
m = []
for r in csv.DictReader(open(os.path.join(K, 'disasm', 'match_jp_kitty.csv'))):
    for k in r['kitty'].split():
        kb, ka = k.split(':'); m.append((int(kb, 16), int(ka, 16), int(r['bytes']), int(r['jp_bank'], 16), int(r['jp_addr'], 16), r['jp_name'], 'same code'))
for r in csv.DictReader(open(os.path.join(K, 'disasm', 'similar_jp_kitty.csv'))):
    if r['kitty'] and float(r['ratio']) >= 0.9:
        kb, ka = r['kitty'].split()[0].split(':'); m.append((int(kb, 16), int(ka, 16), int(r['kitty_bytes']), int(r['jp_bank'], 16), int(r['jp_addr'], 16), r['jp_name'], 'edited copy %s' % r['ratio']))
rng = [(int(r['bank'], 16), int(r['start'], 16), int(r['end'], 16), r['verdict']) for r in csv.DictReader(open(os.path.join(J, 'assets', 'reach_ranges_jp.csv')))]
ver = {(r['bank'], r['start']): r['class'] for r in csv.DictReader(open(os.path.join(K, 'trace', 'red_verdicts_kitty.csv')))}
rows = []; tot = collections.Counter()
for r in csv.DictReader(open(os.path.join(K, 'trace', 'red_kitty.csv'))):
    b, s, e, n = int(r['bank'], 16), int(r['start'], 16), int(r['end'], 16), int(r['bytes'])
    v = ver.get((r['bank'], r['start']), '')
    hit = [x for x in m if x[0] == b and x[1] <= s < x[1] + x[2]]
    if not hit:
        rows.append([r['bank'], r['start'], r['end'], n, r['owner'], v, '', '', '', 'NO_JP']); tot['NO_JP'] += n; continue
    _, ka, _, jb, ja, jn, how = hit[0]; js = ja + s - ka; je = js + e - s
    ran = int(sum(ex[off(jb, x)] > 0 for x in range(js, je + 1)))
    jv = sorted(set(x[3] for x in rng if x[0] == jb and x[1] <= je and js <= x[2]))
    cat = 'JP_RAN' if ran == n else 'JP_PART' if ran else 'JP_VERDICT' if jv else 'JP_RED'
    fate = 'executed %d / %d B' % (ran, n) if ran else 'verdict ' + '/'.join(jv) if jv else 'never run, no verdict'
    rows.append([r['bank'], r['start'], r['end'], n, r['owner'], v, '%02X:%04X' % (jb, js), '%s (%s)' % (jn, how), fate, cat]); tot[cat] += n
OUT = os.path.join(K, 'trace', 'jp_crosscheck_kitty.csv')
import io
f = io.StringIO(); w = csv.writer(f, lineterminator='\n')
w.writerow(['bank', 'start', 'end', 'bytes', 'owner', 'kitty_verdict', 'jp_addr', 'jp_routine', 'jp_fate', 'category']); w.writerows(rows)
if a.check:
    if open(OUT).read() != f.getvalue(): sys.exit('kitty_jp_crosscheck: trace/jp_crosscheck_kitty.csv is not what this tool writes today')
    print('kitty_jp_crosscheck: fresh'); sys.exit(0)
open(OUT, 'w').write(f.getvalue())
print('kitty_jp_crosscheck: %d pieces: %s' % (len(rows), ', '.join('%s %d B' % kv for kv in tot.most_common())))
