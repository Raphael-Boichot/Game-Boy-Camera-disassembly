#!/usr/bin/env python3
"""Route to the music editor (Trippy-H, mode $1F) in my core, from the Space Fever II first wave, and its score print.
Root = corpus entry 197 of unlock_runs/f1_organic (save _ff, Up held at boot -> 07:02); then, per frame: Right held for the first 30 frames, A pulsed 4 on / 4 off from frame 6
(shoots the D.J. ship: 07:5AFA sets state 5 of mode $07 -> mode $1F), 300 frames in all.  Then Select (-> 1F:09, the SOUND I page), and with --print Start held 8 frames, Start+A 4, Start 4.
usage: dj_route.py [--print] [--frames-after N]      prints (mode,state) after each step and writes unlock_runs/dj_route.json"""
import sys, os, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g
import blocks as B
doprint = '--print' in sys.argv
C = lib.Corpus('unlock_runs/f1_organic/corpus.jsonl')
p = C.path(197); sp = dict(C.E[p[0]]['spec'])
route = dict(corpus='unlock_runs/f1_organic/corpus.jsonl', entry=197, root=sp, shoot=[])
for f in range(300):
    k = 0
    if f < 30: k |= g.RIGHT
    if f >= 6 and (f - 6) % 8 < 4: k |= g.A
    route['shoot'].append(k)
C.replay(197); print('start', '%02X:%02X' % lib.cur())
for k in route['shoot']: g.keys(k); g.run(1)
g.keys(0); print('after the shooting phase', '%02X:%02X' % lib.cur(), flush=True)
g.run(120); print('+120 idle', '%02X:%02X' % lib.cur())
g.keys(g.SELECT); g.run(4); g.keys(0); g.run(60); print('Select ->', '%02X:%02X' % lib.cur())
route['after_shoot_idle'] = 120; route['select'] = [g.SELECT, 4, 60]
json.dump(route, open('unlock_runs/dj_route.json', 'w'))
