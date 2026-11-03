#!/usr/bin/env python3
"""Coverage-guided exploration of the music editor (Trippy-H, mode $1F) and the D.J. menu, written as a replayable corpus (same JSONL layout as the other corpora).
Root = entry 197 of unlock_runs/f1_organic (save _ff, Up held at boot); entry 1 = its lineage, entry 2 = the Space Fever II shooting phase (tools/dj_route.py), entry 3 = Select (-> 1F:09).
From these states random macros of 1-3 key presses (8 keys + Start+A / Select+A / B+A combinations, hold 4 or 30 frames, wait 20-120 frames) are tried; a macro that executes
a basic-block head (tools/blocks.py) not yet executed by this corpus becomes a new entry.  Printer detached (the BGB re-trace has no printer).
usage: dj_corpus.py OUTDIR SECONDS [seed]"""
import sys, os, json, time, random
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g
import numpy as np, blocks as B
out, secs = sys.argv[1], float(sys.argv[2]); rng = random.Random(int(sys.argv[3]) if len(sys.argv) > 3 else 1); os.makedirs(out, exist_ok=True)
route = json.load(open(os.path.join(lib.ROOT, 'unlock_runs/dj_route.json')))
C0 = lib.Corpus(os.path.join(lib.ROOT, route['corpus'])); p = C0.path(route['entry']); sp = dict(C0.E[p[0]]['spec']); sp['printer'] = 0
heads, members, code = B.blocks(); hoff = np.array([B.flat(*h) for h in heads])
ex = g.cov_exec(); ex[:] = 0
E = []; snaps = {}
def add(parent, actions, spec=None, gain=0):
    e = dict(id=len(E), parent=parent, gain=gain, sig=list(lib.cur()), t=int(time.time() - t0), tainted=False)
    if spec is not None: e['spec'] = spec
    else: e['actions'] = actions
    E.append(e); snaps[e['id']] = g.snapshot(); return e['id']
t0 = time.time()
lib.boot(lib.SAV(sp['sav']), combo=sp['combo'], printer=0, free=sp['free']); r = add(-1, None, spec=sp)
acts = [list(a) for j in p[1:] for a in C0.E[j]['actions']]
for a in acts: lib.act(a)
i1 = add(r, acts)
shoot = [[k, 1, 0] for k in route['shoot']] + [[0, route['after_shoot_idle'], 0]]
for a in shoot: lib.act(a)
i2 = add(i1, shoot)
sel = [route['select'][0], route['select'][1], route['select'][2]]; lib.act(sel); i3 = add(i2, [sel])
assert lib.cur()[0] == 0x1F, lib.cur()
seen_h = ex[hoff] > 0
CONF = os.path.join(lib.ROOT, 'bgbtrace', 'confirmed_heads.json')       # heads already confirmed in BGB by the other corpora do not count as gain
if os.path.exists(CONF):
    cs = set(json.load(open(CONF))); seen_h |= np.array([('%02X:%04X' % h) in cs for h in heads])
seen_ms = {tuple(e['sig']) for e in E}
print('after the route: heads counted as seen', int(seen_h.sum()), 'state %02X:%02X' % lib.cur(), flush=True)
KEYS = [g.A, g.B, g.START, g.SELECT, g.UP, g.DOWN, g.LEFT, g.RIGHT]; COMBO = [g.START | g.A, g.SELECT | g.A, g.B | g.A, g.START | g.B, g.LEFT | g.A, g.RIGHT | g.A, g.UP | g.A, g.DOWN | g.A]
pool = [i2, i3]; n = 0
def macro():
    return [[rng.choice(KEYS if rng.random() < 0.8 else COMBO), rng.choice([4, 4, 4, 30, 90]), rng.choice([20, 40, 40, 120])] for _ in range(rng.choice([1, 1, 2, 3]))]
while time.time() - t0 < secs:
    n += 1
    pid = rng.choice(pool[-60:] if rng.random() < 0.6 else pool); g.restore(snaps[pid]); m = macro()
    for a in m: lib.act(a)
    now = (ex[hoff] > 0) | seen_h; new = int((now & ~seen_h).sum()); ms = lib.cur()
    if new:
        seen_h |= now; seen_ms.add(ms); nid = add(pid, m, gain=new); pool.append(nid)
        print('[%6.0fs it %6d] new entry %d (parent %d): +%d heads, total %d, state %02X:%02X' % (time.time() - t0, n, nid, pid, new, int(seen_h.sum()), *ms), flush=True)
    elif ms not in seen_ms:                              # a new (mode,state) without new heads: keep it as a pool member only if it opens a new screen
        seen_ms.add(ms); nid = add(pid, m, gain=0); pool.append(nid)
        print('[%6.0fs it %6d] new state entry %d: %02X:%02X' % (time.time() - t0, n, nid, *ms), flush=True)
with open(os.path.join(out, 'corpus.jsonl'), 'w') as f:
    for e in E: f.write(json.dumps(e) + '\n')
print('iterations', n, 'entries', len(E), 'heads', int(seen_h.sum()), 'states', sorted('%02X:%02X' % s for s in seen_ms))
