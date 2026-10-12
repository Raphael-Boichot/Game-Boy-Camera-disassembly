#!/usr/bin/env python3
"""Core run (joypad only, a used save) of the photo pickers of the two-photo COMPOSE layout: 06:523B, 06:5276, 06:5769 (README 16.19; the BGB replay is bgb_compose.py).
usage: compose_picker.py OUTDIR [ENTRY]      (run from the working root; ENTRY = corpus entry in 17:0A, default 610 = save unl_PC10696894)
The picker changes the photo only while A is held: hold A (17:0A -> 17:0B), then A+Up (+1), A+Down, A+Down (wrap to the last), A+Up (wrap to 0); release A; Right; hold A (17:0C), A+Up; release.
--tap  the control: tap A (4 frames) and every single key in the picker: nothing changes (the picker is left as soon as A is released).
Writes OUTDIR/compose_picker.json and OUTDIR/exec_ranges.csv (every byte executed in this process)."""
import sys, os, json
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g
import blocks as B
a = sys.argv[1:]
TAP = '--tap' in a
if TAP: a.remove('--tap')
out = a[0]; entry = int(a[1]) if len(a) > 1 else 610; os.makedirs(out, exist_ok=True)
C = lib.Corpus('unlock_runs/f1_organic/corpus.jsonl'); g.set_organic(1)
ex = g.cov_exec(); T = {'06:523B': B.flat(6, 0x523B), '06:5276': B.flat(6, 0x5276), '06:5769': B.flat(6, 0x5769), '06:5779': B.flat(6, 0x5779)}
def st(): return '%02X:%02X' % lib.cur()
def hits(): return {k: int(ex[v]) > 0 for k, v in T.items()}
C.replay(entry); g.run(30)
log = [('start', st(), g.peek(0xD7F6), g.peek(0xD7F7), g.peek(0xD7F8), g.peek(0xD562))]
if TAP:
    for name, k in (('A', g.A), ('Up', g.UP), ('Down', g.DOWN), ('Right', g.RIGHT), ('Left', g.LEFT), ('B', g.B)):
        g.keys(k); g.run(4); g.keys(0); g.run(30); log.append((name + ' tap', st(), g.peek(0xD7F7), g.peek(0xD7F8)))
else:
    def step(extra): g.keys(g.A | extra); g.run(4); g.keys(g.A); g.run(14)
    g.keys(g.A); g.run(6); log.append(('hold A', st()))
    for name, extra in (('A+Up', g.UP), ('A+Down', g.DOWN), ('A+Down', g.DOWN), ('A+Up', g.UP)):
        step(extra); log.append((name, st(), g.peek(0xD7F7), hits()))
    g.keys(0); g.run(40); log.append(('release A', st(), g.peek(0xD7F7)))
    g.keys(g.RIGHT); g.run(4); g.keys(0); g.run(20); g.keys(g.A); g.run(6); log.append(('Right, hold A', st(), g.peek(0xD7F6)))
    step(g.UP); log.append(('A+Up', st(), g.peek(0xD7F8), hits()))
    g.keys(0); g.run(40); log.append(('release A', st(), g.peek(0xD7F7), g.peek(0xD7F8)))
res = dict(entry=entry, tap_control=TAP, log=[list(map(str, x)) for x in log], hits=hits())
for x in log: print(x)
print('hits', res['hits'])
json.dump(res, open(out + '/compose_picker.json', 'w'), indent=1)
lib.dump_exec_ranges(out + '/exec_ranges.csv', np.zeros(np.array(g.cov_exec()).shape, bool))
