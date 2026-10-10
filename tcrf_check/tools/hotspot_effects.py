#!/usr/bin/env python3
"""Exercise every hot-spot effect (0..15) with joypad input only after a WRAM-side hotspot is armed under the pointer.
Replays corpus entry (mode $0C, state 3: waiting for A/B) of the unlocking save, then arms hotspot 0 of the displayed photo at the pointer cell (D667,D668)
by writing the WRAM mirror D643-D660 (flag, X, Y, sound FF, effect k, jump FF) and presses A (04-frame tap). Reports which dispatch target ran.
usage: hotspot_effects.py OUTDIR [CORPUS]"""
import sys, os, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g, R
from PIL import Image
out = sys.argv[1]; os.makedirs(out, exist_ok=True)
corpus = sys.argv[2] if len(sys.argv) > 2 else 'unlock_runs/f1_organic/corpus.jsonl'
C = lib.Corpus(corpus); i = C.best((0x0C, 3)); g.set_organic(1); C.replay(i); g.run(30)
print('state', lib.cur(), 'pointer D667/D668 =', g.peek(0xD667), g.peek(0xD668), 'D500', g.peek(0xD500))
snap = g.snapshot(); EX = g.cov_exec(); OEX = g.org_exec()
H = [0x6625, 0x6642, 0x66AF, 0x66DC, 0x67D5, 0x6801, 0x6838, 0x68A4, 0x6901, 0x6983]
def off(a): return 3 * 0x4000 - 0x4000 + a
res = {}
for k in range(16):
    g.restore(snap); g.run(2)
    px, py = g.peek(0xD667), g.peek(0xD668)
    for n, v in ((0xD643, 1), (0xD648, px), (0xD64D, py), (0xD652, 0xFF), (0xD657, k), (0xD65C, 0xFF)): g.poke(n, v)
    before = [int(EX[off(a)]) for a in H] + [int(EX[off(0x6450)])]
    lib.act((g.A, 4, 2)); frames = 0; seq = []
    for _ in range(400):
        g.run(1); frames += 1
        if g.peek(0xD5CE) != 0x0C: break
    after = [int(EX[off(a)]) for a in H] + [int(EX[off(0x6450)])]
    new = [hex(a) for a, b0, b1 in zip(H + [0x6450], before, after) if b1 and not b0]
    print('effect', k, 'state after', lib.cur(), 'frames', frames, 'newly executed:', new, flush=True)
    res[k] = dict(mode_state=list(lib.cur()), newly=new)
    Image.fromarray(R.screen(g)).save('%s/effect_%02d.png' % (out, k))
json.dump(res, open(out + '/results.json', 'w'))
