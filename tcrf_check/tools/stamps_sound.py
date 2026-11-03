"""Stamp tool (mode $11) explored with random key sequences in the core (unlocking save): every sound the game asks for, with the state, category, page and key."""
import sys, os, json, random, collections
ROOT = os.environ.get('GBCAM_ROOT', '/home/claude/gbcam_jp')   # the working root of README 16.15 (core, tools/lib.py, the ROM)
BGBX = os.environ.get('BGB_DIR', '/home/claude/bgbx')
os.chdir(ROOT); sys.path.insert(0, 'tools')
import lib; from lib import g
import numpy as np
random.seed(int(sys.argv[1]) if len(sys.argv) > 1 else 1)
NSTEPS = int(sys.argv[2]) if len(sys.argv) > 2 else 6000
C = lib.Corpus('unlock_runs/f1_organic/corpus.jsonl'); g.set_organic(1)
i = C.best((0x11, 4)); print('entry', i, 'save', C.E[C.path(i)[0]]['spec']['sav'], flush=True)
C.replay(i); print('start %02X:%02X' % lib.cur(), flush=True)
snap = g.snapshot()
SND = dict(sfx1_req=0xDD60, sfx1_run=0xDD61, song_req=0xDD68, song=0xDD69, sfx3_req=0xDD70, sfx3_run=0xDD71, sfx4_req=0xDD78, sfx4_run=0xDD79)
KEYS = [0, g.UP, g.DOWN, g.LEFT, g.RIGHT, g.A, g.B, g.SELECT, g.START, g.A | g.LEFT, g.A | g.RIGHT, g.A | g.UP, g.A | g.DOWN, g.UP | g.LEFT, g.DOWN | g.RIGHT]
W = [3, 4, 4, 4, 4, 5, 1, 2, 1, 2, 2, 1, 1, 2, 2]
def nm(k):
    out = [n for m, n in ((g.UP, 'Up'), (g.DOWN, 'Down'), (g.LEFT, 'Left'), (g.RIGHT, 'Right'), (g.A, 'A'), (g.B, 'B'), (g.SELECT, 'Select'), (g.START, 'Start')) if k & m]
    return '+'.join(out) or '-'
events = []; last = None; frame = 0; exits = collections.Counter(); states = collections.Counter(); restores = 0
cov0 = np.array(g.org_dread(), copy=True) != 0
for step in range(NSTEPS):
    k = random.choices(KEYS, W)[0]; hold = random.choice((1, 2, 3, 4, 6, 10, 30)); wait = random.choice((0, 2, 5, 10, 20))
    if (k & g.A) and k == g.A and random.random() < 0.06: hold = 200
    g.keys(k)
    for fr in range(hold + wait):
        if fr == hold: g.keys(0)
        g.run(1); frame += 1
        snd = {n: g.peek(a) for n, a in SND.items()}
        key = tuple(snd.values())
        if key != last:
            ms = lib.cur()
            events.append(dict(f=frame, key=nm(k), hold=hold, mode=ms[0], state=ms[1], cat=g.peek(0xD63D), page=g.peek(0xD63E), item=g.peek(0xD63F), **snd)); last = key
    ms = lib.cur(); states[ms] += 1
    if ms[0] != 0x11:
        exits[(ms, nm(k))] += 1; g.restore(snap); restores += 1; last = None
print('frames', frame, 'restores', restores, 'exits', dict(exits), flush=True)
print('states', dict(states), flush=True)
json.dump(events, open('work/stamps_sound_log_%s.json' % (sys.argv[1] if len(sys.argv) > 1 else '1'), 'w'))
seen = collections.OrderedDict()
for e in events:
    for ch, rk, uk in (('sfx1', 'sfx1_req', 'sfx1_run'), ('sfx3', 'sfx3_req', 'sfx3_run'), ('sfx4', 'sfx4_req', 'sfx4_run'), ('music', 'song_req', 'song')):
        for kind, kk in (('req', rk), ('run', uk)):
            v = e[kk]
            if v:
                d = seen.setdefault((ch, v), dict(n=0, req=0, ctx=collections.Counter(), keys=collections.Counter()))
                d['n'] += 1; d['req'] += kind == 'req'; d['ctx'][(e['mode'], e['state'])] += 1; d['keys'][e['key']] += 1
for (ch, v), d in sorted(seen.items()):
    print('%-6s %02X  events %4d (requests %3d) states %s keys %s' % (ch, v, d['n'], d['req'], ' '.join('%02X:%02X' % c for c, _ in d['ctx'].most_common(4)), ' '.join(k for k, _ in d['keys'].most_common(4))))
new = np.flatnonzero((np.array(g.org_dread(), copy=True) != 0) & ~cov0)
print('ROM bytes newly read in this exploration:', len(new))
