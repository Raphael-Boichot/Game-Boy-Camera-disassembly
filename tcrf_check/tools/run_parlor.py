"""SHOOT parlor (mode $01): choose RUN (にげる) over and over; log the shared result screen 09:7290 (picture, message id $DBCF, tune), the parlor page and its music."""
import sys, os, json, random
ROOT = os.environ.get('GBCAM_ROOT', '/home/claude/gbcam_jp')   # the working root of README 16.15 (core, tools/lib.py, the ROM)
BGBX = os.environ.get('BGB_DIR', '/home/claude/bgbx')
os.chdir(ROOT); sys.path.insert(0, 'tools')
import numpy as np
import lib; from lib import g
import render2 as R
from PIL import Image
N = int(sys.argv[1]) if len(sys.argv) > 1 else 100
OUT = 'work/parlor'; os.makedirs(OUT, exist_ok=True)
random.seed(7)
C = lib.Corpus('unlock_runs/f1_organic/corpus.jsonl')
i = C.best((1, 4)) or C.best((1, 0)); p = C.path(i); sp = dict(C.E[p[0]]['spec'])
SND = dict(sfx1_req=0xDD60, sfx1_run=0xDD61, song_req=0xDD68, song=0xDD69, sfx3_req=0xDD70, sfx3_run=0xDD71, sfx4_req=0xDD78, sfx4_run=0xDD79)
frame = [0]; log = []; last = [None]
real_run = g.run
def myrun(n):
    for _ in range(n):
        real_run(1); frame[0] += 1
        ms = (g.peek(0xD5CE), g.peek(0xD5CF)); snd = {k: g.peek(a) for k, a in SND.items()}
        key = (ms, tuple(snd.values()))
        if key != last[0]:
            log.append(dict(f=frame[0], mode=ms[0], state=ms[1], dbcf=g.peek(0xDBCF), **snd)); last[0] = key
g.run = myrun
lib.boot(lib.SAV(sp['sav']), combo=sp['combo'], printer=sp['printer'], free=sp['free'])
for j in p[1:]:
    for a in C.E[j]['actions']: lib.act(a)
g.run(60)
print('entry', i, 'reached %02X:%02X' % lib.cur(), flush=True)
def tap(k, hold=4, wait=14): g.keys(k); g.run(hold); g.keys(0); g.run(wait)
def wait_state(states, maxf=3000):
    f = 0
    while not (lib.cur()[0] == 1 and lib.cur()[1] in states) and f < maxf: g.run(1); f += 1
    return f < maxf
seen_shot = {}; rows = []; dread_seen = np.array(g.org_dread(), copy=True) != 0; new_by_key = {}
def shot(key, tag):
    if key in seen_shot: return
    seen_shot[key] = tag
    Image.fromarray(R.screen(g)).resize((320, 288), Image.NEAREST).save('%s/%s.png' % (OUT, tag))
for it in range(1, N + 1):
    if not wait_state((1, 4, 7)): print('lost the menu', '%02X:%02X' % lib.cur()); break
    page = lib.cur()[1]; f0 = frame[0]
    g.run(30 + random.randint(0, 40))
    shot(('menu', page), 'menu_state%02X' % page)
    for k in (g.UP, g.UP, g.UP, g.LEFT, g.LEFT): tap(k, 3, 6)
    tap(g.RIGHT); tap(g.DOWN); g.run(random.randint(0, 25))
    if it <= 3: shot(('cursor', page), 'cursor_on_RUN_state%02X' % page)
    tap(g.A, 4, 2)
    if not wait_state((0x0A,), 1500): rows.append(dict(it=it, page=page, note='no result screen', end='%02X:%02X' % lib.cur())); continue
    seq = 0
    while True:
        seq += 1
        g.run(150)
        dbcf = g.peek(0xDBCF)
        # picture index: the tile at $9000 compared with the four pictures is done offline; here the tune requested by the result screen identifies it
        snd = [e['song_req'] or e['song'] for e in log if e['f'] >= f0 and e['mode'] == 1 and e['state'] == 0x0A and (e['song_req'] or 0)]
        songs = [e['song_req'] for e in log if e['f'] >= f0 and e['song_req'] not in (0, None)]
        tag = 'result_dbcf%02X_song%s' % (dbcf, '-'.join('%02X' % s for s in songs[-1:]))
        shot(('result', dbcf, tuple(songs[-1:])), tag)
        rows.append(dict(it=it, page=page, seq=seq, dbcf=dbcf, songs=songs, frame0=f0))
        print(rows[-1], flush=True)
        now = np.array(g.org_dread(), copy=True) != 0
        newb = np.flatnonzero(now & ~dread_seen); dread_seen |= now
        if len(newb): new_by_key[(it, seq)] = newb.tolist()
        tap(g.A, 4, 2)
        # after the key: 0B -> 0 (back to the parlor) or 0A again (message $08)
        g.run(5); f = 0
        while lib.cur()[1] in (0x0A, 0x0B) and f < 800:
            if lib.cur()[1] == 0x0A and f > 0 and f % 120 == 0: tap(g.A, 4, 2)
            g.run(1); f += 1
            if lib.cur()[1] == 0x0A and f < 800 and g.peek(0xD5D0) == 0 and f > 30 and g.peek(0xDBCF) == 8: break
        if lib.cur()[1] == 0x0A and g.peek(0xDBCF) == 8: continue
        break
    f0 = frame[0]
json.dump(dict(rows=rows, log=log), open(OUT + '/log.json', 'w'))
json.dump({'%d,%d' % k: v for k, v in new_by_key.items()}, open(OUT + '/newread.json', 'w'))
print('done frames', frame[0], 'iterations', len(rows))
