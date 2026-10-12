#!/usr/bin/env python3
"""D.J. performance screen (mode $1F state 5): the nine sound effects "SE 1..9" played with the A key, joypad only (README 16.18).
usage: dj_se.py OUTDIR [ROUTE.json]       (run from the working root; default route unlock_runs/dj_route.json, a copy is tcrf_check/assets/bgb_retrace/dj_route.json)
Route: corpus entry 197 (save _ff) = Space Fever II, Right held and A pulsed shoot the D.J. ship -> 1F:05 (the performance screen).  On it Right moves the control cursor `$D8B3`
(0 tempo, 1 SOUND I, 2 SOUND II, 3 NOISE, 4 level = the SE number `$D8B7` 0..8), Up / Down change the level at control 4, A plays: `05:5477-5483` requests the id `[05:554D + 2*$D8B7]`
= `$2C + SE-1` on the channel-1 mailbox `$DD60` through the table routine `00:2A4B`.
Scenarios: each SE alone, then SE 9 pressed 26 times (the handler `1F:4A44` plays one note of a 24-note table per request: London Bridge, and restarts at `1F:4A42` on the 25th), and SE 4 / SE 8
left to play for 900 frames (the table ends: `1F:4940` echo, `1F:49E3` loop).  Writes OUTDIR/dj_se.csv (scenario, requests seen in `$DD60`, `$DD08` after each press, never-run bytes executed) and OUTDIR/exec_ranges.csv."""
import sys, os, json, csv
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g
import numpy as np
out = sys.argv[1]; os.makedirs(out, exist_ok=True)
route = json.load(open(sys.argv[2] if len(sys.argv) > 2 else 'unlock_runs/dj_route.json'))
REPO = os.environ.get('REPO', os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))))
N = len(lib.exec_baseline())
def flat(b, a): return a if (b == 0 and a < 0x4000) else b * 0x4000 + a - 0x4000
cls = np.zeros(N, np.uint8)
for r in csv.DictReader(open(os.path.join(REPO, 'coverage', 'results', 'report_v8', 'rom_map.csv'))):
    cls[flat(int(r['bank'], 16), int(r['start'], 16)):][:int(r['length'])] = ord(r['class'])
isN = cls == ord('N')
WIT = np.zeros(N, bool)
for r in csv.DictReader(open(os.path.join(REPO, 'assets', 'witness_jp.csv'))):
    s = flat(int(r['bank'], 16), int(r['start'], 16)); WIT[s:s + int(r['bytes'])] = True
left = isN & ~WIT
C = lib.Corpus(route['corpus']); g.set_organic(1); C.replay(route['entry'])
for k in route['shoot']: g.keys(k); g.run(1)
g.keys(0); g.run(route['after_shoot_idle'])
assert lib.cur() == (0x1F, 5), lib.cur()
ex = g.cov_exec(); start = g.snapshot()
def ranges(mask):
    rows = []
    for o in np.flatnonzero(mask):
        o = int(o); b = o >> 14 if o >= 0x4000 else 0; a = o if b == 0 else 0x4000 + (o & 0x3FFF)
        if rows and rows[-1][0] == b and rows[-1][2] == a - 1: rows[-1][2] = a
        else: rows.append([b, a, a])
    return ' '.join('%02X:%04X-%04X' % tuple(r) for r in rows)
def tap(k, hold=4, wait=20):
    g.keys(k); g.run(hold); g.keys(0); g.run(wait)
def watch(n):
    """run n frames, return the nonzero values seen in the channel-1 mailbox (the id is consumed in the next frame)"""
    seen = []
    for _ in range(n):
        g.run(1); v = g.peek(0xDD60)
        if v: seen.append(v)
    return seen
def to_se(k):
    for _ in range(4): tap(g.RIGHT, 4, 10)
    for _ in range(k - 1): tap(g.UP, 4, 10)
    assert g.peek(0xD8B3) == 4 and g.peek(0xD8B7) == k - 1, (g.peek(0xD8B3), g.peek(0xD8B7))
rows = []; UNION = np.zeros(N, bool)
def scen(name, k, presses, gap, tail):
    global UNION
    g.restore(start); base = np.array(ex, copy=True) != 0
    to_se(k); reqs = []; dd08 = []; ids = []
    for i in range(presses):
        g.keys(g.A); reqs += watch(4); g.keys(0); reqs += watch(gap)
        dd08.append(g.peek(0xDD08)); ids.append(g.peek(0xDD61))
    reqs += watch(tail)
    new = (np.array(ex, copy=True) != 0) & ~base; UNION |= new
    nl = new & left
    rows.append([name, k, presses, ' '.join('%02X' % v for v in sorted(set(reqs))), ' '.join(str(v) for v in dd08), int(nl.sum()), ranges(nl)])
    print('%-34s SE %d requests seen %s  DD08 after each press %s  never-run bytes run: %d %s' % (name, k, sorted(set('%02X' % v for v in reqs)), dd08 if k == 9 else '', int(nl.sum()), ranges(nl)), flush=True)
for k in range(1, 10): scen('SE %d, one press, 600 frames' % k, k, 1, 20, 600)
scen('SE 9, 26 presses (one per 24 frames)', 9, 26, 20, 100)
scen('SE 4, one press, 1500 frames', 4, 1, 20, 1500)
scen('SE 8, one press, 1500 frames', 8, 1, 20, 1500)
with open(out + '/dj_se.csv', 'w', newline='') as fh:
    w = csv.writer(fh, lineterminator='\n'); w.writerow(['scenario', 'se', 'presses', 'mailbox_values_seen', 'DD08_after_each_press', 'never_run_bytes', 'ranges']); w.writerows(rows)
ex[:] = UNION.astype(np.uint8)
lib.dump_exec_ranges(out + '/exec_ranges.csv', np.zeros(N, bool))
