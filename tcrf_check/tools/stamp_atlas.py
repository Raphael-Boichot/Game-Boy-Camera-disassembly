#!/usr/bin/env python3
"""Capture every scroll position of every stamp category of the stamp tool (mode $11, palette = state 3) with an unlocked save.
usage: stamp_atlas.py OUTDIR [CORPUS]
Navigation uses only real key presses (organic): Right to the category column, Down for the next category, Left back into the grid,
Up/Left to the first item, Down to scroll. Category 3 (CoroCoro) only exists when WRAM $D582 = 1 (CoroCoro tag in the save)."""
import sys, os, hashlib, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g, R
from PIL import Image
out = sys.argv[1]; os.makedirs(out, exist_ok=True)
corpus = sys.argv[2] if len(sys.argv) > 2 else 'unlock_runs/f1_organic/corpus.jsonl'
C = lib.Corpus(corpus); i = C.best((0x11, 3)); g.set_organic(1); C.replay(i); g.run(30)
def st(): return dict(cat=g.peek(0xD63D), page=g.peek(0xD63E), item=g.peek(0xD63F), focus=g.peek(0xD614))
def press(k, hold=4, wait=20): lib.act((k, hold, wait))
res = []
for c in range(0, 17):
    s = st()
    while s['cat'] != c:
        if s['focus'] == 0:
            for _ in range(5): press(g.RIGHT)
        press(g.DOWN); s = st()
        if s['cat'] > c or s['cat'] == 16 and c != 16: break
    if s['focus'] == 1: press(g.LEFT)
    for _ in range(25): press(g.UP, 3, 6)
    for _ in range(4): press(g.LEFT, 3, 6)
    seen = set(); shots = 0; last = None; items = []
    for step in range(60):
        s = st(); img = R.screen(g); h = hashlib.md5(img.tobytes()).hexdigest()
        if h not in seen:
            seen.add(h); Image.fromarray(img).save('%s/cat%02d_s%02d_item%02d.png' % (out, c, shots, s['item'])); shots += 1
        items.append(s['item'])
        press(g.DOWN, 3, 8)
        if st()['item'] == s['item'] and step > 1: break
    nitems = max(items) + 1
    res.append(dict(cat=c, shots=shots, last_item=max(items), page_max=st()['page']))
    print('cat', c, res[-1], flush=True)
    for _ in range(5): press(g.RIGHT)
json.dump(res, open(out + '/cats.json', 'w'))
