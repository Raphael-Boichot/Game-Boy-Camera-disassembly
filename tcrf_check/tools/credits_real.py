"""Run the real credits (unlocking save) from the entry to the end, per-frame log of mode:state and the sound variables, screenshots at every state change and every 45 frames,
and the set of ROM bytes organically read since the credits entry (org_dread)."""
import sys, os, json
ROOT = os.environ.get('GBCAM_ROOT', '/home/claude/gbcam_jp')   # the working root of README 16.15 (core, tools/lib.py, the ROM)
BGBX = os.environ.get('BGB_DIR', '/home/claude/bgbx')
os.chdir(ROOT); sys.path.insert(0, 'tools')
import numpy as np
import lib; from lib import g
import render2 as R
from PIL import Image
OUT = 'work/credits_real'; os.makedirs(OUT, exist_ok=True)
C = lib.Corpus('unlock_runs/f1_organic/corpus.jsonl')
c = sorted((C.frames(i), i) for i, e in C.E.items() if tuple(e['sig']) == (8, 0x17) and not C.tainted(i))
i = c[0][1]; p = C.path(i)[:2]; sp = dict(C.E[p[0]]['spec'])  # stop at the entry (08:12), no B press
print('entry', i, 'save', sp['sav'], 'combo', sp['combo'], 'frames', c[0][0], flush=True)
SND = dict(sfx1_req=0xDD60, sfx1_run=0xDD61, song_req=0xDD68, song=0xDD69, sfx3_req=0xDD70, sfx3_run=0xDD71, sfx4_req=0xDD78, sfx4_run=0xDD79)
frame = [0]; log = []; last = [None]; shots = []; started = [False]; last_shot = [-999]
dread0 = [None]
real_run = g.run
def hook():
    ms = (g.peek(0xD5CE), g.peek(0xD5CF)); snd = {k: g.peek(a) for k, a in SND.items()}
    key = (ms, tuple(snd.values()))
    if ms[0] == 8 and ms[1] >= 0x12 and not started[0]:
        started[0] = True; dread0[0] = np.array(g.org_dread(), copy=True)
        print('credits entry (08:%02X) at frame %d' % (ms[1], frame[0]), flush=True)
    if key != last[0]:
        log.append(dict(f=frame[0], mode=ms[0], state=ms[1], **snd)); last[0] = key
    if started[0]:
        chg = len(log) and log[-1]['f'] == frame[0]
        if chg and (ms[1] != (log[-2]['state'] if len(log) > 1 else -1)) or frame[0] - last_shot[0] >= 45:
            shots.append((frame[0], ms, R.screen(g))); last_shot[0] = frame[0]
def myrun(n):
    for _ in range(n):
        real_run(1); frame[0] += 1; hook()
g.run = myrun
lib.boot(lib.SAV(sp['sav']), combo=sp['combo'], printer=sp['printer'], free=sp['free'])
for j in p[1:]:
    for a in C.E[j]['actions']: lib.act(a)
print('path done at frame', frame[0], 'state', '%02X:%02X' % lib.cur(), flush=True)
# let it run to the end: press A when the game waits for it (state 0x16)
t0 = frame[0]; end_frame = None; wait16 = None
while frame[0] - t0 < 60000:
    ms = lib.cur()
    if ms == (8, 0x16):
        if wait16 is None: wait16 = frame[0]
        if frame[0] - wait16 > 900:
            g.keys(g.A); g.run(3); g.keys(0)
    if ms[0] != 8 or (ms == (8, 0) and started[0] and frame[0] - t0 > 10) or ms == (8, 1) and started[0] and frame[0]-t0>10:
        end_frame = frame[0]; break
    g.run(1)
g.run(60)
print('ended at frame', frame[0], 'final %02X:%02X' % lib.cur(), flush=True)
dread1 = np.array(g.org_dread(), copy=True)
new = np.flatnonzero((dread1 != 0) & (dread0[0] == 0))
json.dump(dict(log=log, end_frame=frame[0], nshots=len(shots)), open(OUT + '/log.json', 'w'))
np.save(OUT + '/dread_new.npy', new)
for k, (f, ms, im) in enumerate(shots):
    Image.fromarray(im).resize((320, 288), Image.NEAREST).save('%s/s%03d_f%05d_%02X_%02X.png' % (OUT, k, f, ms[0], ms[1]))
print('screenshots', len(shots), 'new ROM bytes read since credits entry', len(new))
