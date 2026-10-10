#!/usr/bin/env python3
"""From the organic D.J. entry (unlock_runs/dj_hit.json) press random keys and screenshot every new (mode,state) reached (mode $1F states). usage: dj_explore.py OUTDIR SECONDS [seed]"""
import sys, os, json, time, random
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g, R
from PIL import Image
out = sys.argv[1]; secs = float(sys.argv[2]); rng = random.Random(int(sys.argv[3]) if len(sys.argv) > 3 else 1); os.makedirs(out, exist_ok=True)
hit = json.load(open(os.path.join(lib.ROOT, 'unlock_runs/dj_hit.json')))
d = bytearray(open(os.path.join(lib.ROOT, 'package/coverage/saves', hit['base'] + '.sav'), 'rb').read())
for name, off, x in hit['edits']: d[off] ^= x
g.set_organic(1); g.reset(bytes(d)); g.L.gb_attach_printer(0); g.run(300)
for k, w in hit['seq']: g.keys(k); g.run(4); g.keys(0); g.run(w)
assert g.peek(0xD5CE) == 0x1F, hex(g.peek(0xD5CE))

root = g.snapshot(); seen = {}; t0 = time.time(); n = 0
KEYS = [g.A, g.B, g.START, g.SELECT, g.UP, g.DOWN, g.LEFT, g.RIGHT]
def note():
    ms = (g.peek(0xD5CE), g.peek(0xD5CF))
    if ms not in seen:
        seen[ms] = n; Image.fromarray(R.screen(g)).save('%s/%02X_%02X.png' % (out, *ms)); print('new', '%02X:%02X' % ms, 'iter', n, flush=True)
note()
while time.time() - t0 < secs:
    g.restore(root) if rng.random() < 0.02 else None
    n += 1
    k = rng.choice(KEYS); g.keys(k); g.run(4); g.keys(0); g.run(rng.choice([8, 20, 40])); note()
    if g.peek(0xD5CE) != 0x1F and rng.random() < 0.5: g.restore(root)
json.dump({'%02X:%02X' % k: v for k, v in seen.items()}, open(out + '/seen.json', 'w'))
print('iters', n, 'states', sorted('%02X:%02X' % k for k in seen))
