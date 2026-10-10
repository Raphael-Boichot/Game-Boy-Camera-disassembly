#!/usr/bin/env python3
"""Confirm the 'hold A' branch of the stamp tool (04:5E3B/04:5E4C, timer $D641): pick a stamp in the palette (state 3), hold A and screenshot.
usage: stamp_hold_a.py OUTDIR [CORPUS]   (organic: joypad only, on the unlocking save of corpus entry (0x11,3))"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g, R
from PIL import Image
out = sys.argv[1]; os.makedirs(out, exist_ok=True)
corpus = sys.argv[2] if len(sys.argv) > 2 else 'unlock_runs/f1_organic/corpus.jsonl'
C = lib.Corpus(corpus); i = C.best((0x11, 3)); g.set_organic(1); C.replay(i); g.run(30)
EX = g.cov_exec(); OEX = g.org_exec()
def hit(): return int(EX[0x11E4C]), int(OEX[0x11E4C])
print('start', lib.cur(), 'D641=%d' % g.peek(0xD641), 'ex@5E4C', hit())
Image.fromarray(R.screen(g)).save(out + '/00_palette.png')
lib.act((g.A, 4, 30)); print('after A', lib.cur(), 'D641=%d' % g.peek(0xD641), 'D63D=%d D63E=%d D63F=%d' % (g.peek(0xD63D), g.peek(0xD63E), g.peek(0xD63F)))
Image.fromarray(R.screen(g)).save(out + '/01_placement.png')
for k in range(3): lib.act((g.RIGHT, 6, 4))
g.run(20); Image.fromarray(R.screen(g)).save(out + '/02_moved.png')
g.keys(g.A); log = []
for f in range(0, 520, 10):
    g.run(10); log.append((f + 10, g.peek(0xD641), lib.cur(), hit()))
    if f + 10 in (170, 190, 200, 380, 520) or hit()[0] and len(log) and log[-2][3][0] == 0:
        Image.fromarray(R.screen(g)).save('%s/hold_%03d.png' % (out, f + 10))
g.keys(0); g.run(20); Image.fromarray(R.screen(g)).save(out + '/99_released.png')
for l in log: print(l)
print('end', lib.cur(), 'ex@5E4C', hit())
