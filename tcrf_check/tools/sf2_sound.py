"""Replay the 31,161-frame Space Fever II key log in the core and log every sound the game asks for (mailboxes) with the game context."""
import sys, os, json, collections
ROOT = os.environ.get('GBCAM_ROOT', '/home/claude/gbcam_jp')   # the working root of README 16.15 (core, tools/lib.py, the ROM)
BGBX = os.environ.get('BGB_DIR', '/home/claude/bgbx')
os.chdir(ROOT); sys.path.insert(0, 'tools')
import lib; from lib import g
REPO = os.environ.get('GBCAM_REPO', os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
K = json.load(open(REPO + '/tcrf_check/assets/sf2/sf2_keys.json'))
keys = [k for k, n in K['keys'] for _ in range(n)]
print('key log frames', len(keys), 'root entry', K.get('root_entry'), flush=True)
C = lib.Corpus('unlock_runs/f1_organic/corpus.jsonl'); g.set_organic(1); C.replay(197)
print('start %02X:%02X' % lib.cur(), flush=True)
SND = dict(sfx1_req=0xDD60, sfx1_run=0xDD61, song_req=0xDD68, song=0xDD69, sfx3_req=0xDD70, sfx3_run=0xDD71, sfx4_req=0xDD78, sfx4_run=0xDD79)
def score(): return '%02x%02x%02x%02x' % (g.peek(0xD86B), g.peek(0xD86A), g.peek(0xD869), g.peek(0xD868))
log = []; last = None
for f, k in enumerate(keys):
    g.keys(k); g.run(1)
    ms = lib.cur(); snd = {n: g.peek(a) for n, a in SND.items()}
    key = tuple(snd.values())
    if key != last:
        log.append(dict(f=f, mode=ms[0], state=ms[1], wave=g.peek(0xD863), rnd=g.peek(0xD88E), var=g.peek(0xD88F), score=score(), boss_hits=g.peek(0xD865), **snd)); last = key
print('end %02X:%02X' % lib.cur(), 'score', score(), flush=True)

# ---- continue past the key log: let the ship be shot, look at the game-over dialog, leave it with A then B
def tick(kk, n):
    global last
    for _ in range(n):
        g.keys(kk); g.run(1); f = len(keys) + len(log) * 0 + tick.n; tick.n += 1
        ms = lib.cur(); snd = {nm: g.peek(a) for nm, a in SND.items()}
        key = tuple(snd.values()) + ms
        if key != last:
            log.append(dict(f=f, mode=ms[0], state=ms[1], wave=g.peek(0xD863), rnd=g.peek(0xD88E), var=g.peek(0xD88F), score=score(), boss_hits=g.peek(0xD865), **snd)); last = key
tick.n = len(keys)
import random; random.seed(3)
t = 0
while lib.cur()[1] != 3 and t < 8000:
    tick(g.A if t % 4 == 0 else 0, 1); t += 1
print('ship destroyed after', t, 'extra frames, state %02X:%02X' % lib.cur(), flush=True)
tick(0, 400); print('dialog state %02X:%02X' % lib.cur(), flush=True)
tick(g.A, 3); tick(0, 300); print('after A %02X:%02X' % lib.cur(), flush=True)
tick(g.B, 3); tick(0, 400); print('after B %02X:%02X' % lib.cur(), flush=True)
json.dump(log, open('work/sf2_sound_log.json', 'w'))
# summary: every id seen as a request or a running id
seen = collections.OrderedDict()
for e in log:
    for ch, rk, uk in (('sfx1', 'sfx1_req', 'sfx1_run'), ('sfx3', 'sfx3_req', 'sfx3_run'), ('sfx4', 'sfx4_req', 'sfx4_run'), ('music', 'song_req', 'song')):
        for kind, kk in (('req', rk), ('run', uk)):
            v = e[kk]
            if v:
                d = seen.setdefault((ch, v), dict(first=e['f'], n=0, req=0, ctx=set()))
                d['n'] += 1; d['req'] += kind == 'req'; d['ctx'].add('%02X:%02X w%d' % (e['mode'], e['state'], e['wave']))
for (ch, v), d in sorted(seen.items()):
    print('%-6s %02X first f%-6d seen %4d (requests %3d) %s' % (ch, v, d['first'], d['n'], d['req'], ' '.join(sorted(d['ctx']))[:100]))
