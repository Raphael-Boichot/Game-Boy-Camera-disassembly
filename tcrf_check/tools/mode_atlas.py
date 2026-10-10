#!/usr/bin/env python3
"""Screenshot of every organically reached (mode,state) of an earlier fuzz pass: usage mode_atlas.py CORPUS OUTDIR"""
import sys, os, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g, R
from PIL import Image, ImageDraw
C = lib.Corpus(sys.argv[1]); out = sys.argv[2]; os.makedirs(out, exist_ok=True)
sigs = sorted(set(tuple(e['sig']) for e in C.E.values() if not e.get('tainted') and e['sig'][0] <= 0x21))
meta = {}
for s in sigs:
    i = C.best(s)
    if i is None: continue
    try:
        lib.g.set_organic(1); C.replay(i)
        a = R.screen(g); g.run(30); b = R.screen(g)
        Image.fromarray(a).save('%s/%02X_%02X_a.png' % (out, *s)); Image.fromarray(b).save('%s/%02X_%02X_b.png' % (out, *s))
        meta['%02X:%02X' % s] = dict(entry=i, frames=C.frames(i), now=[g.peek(0xD5CE), g.peek(0xD5CF)])
    except Exception as ex: print('fail', s, ex)
json.dump(meta, open(out + '/meta.json', 'w'))
# contact sheets (24 per sheet, 6 columns)
names = sorted(meta)
for pg in range(0, len(names), 24):
    chunk = names[pg:pg + 24]; W, H = 160, 144
    M = Image.new('RGB', (6 * (W + 6) + 6, ((len(chunk) + 5) // 6) * (H + 22) + 6), (90, 90, 140)); d = ImageDraw.Draw(M)
    for k, n in enumerate(chunk):
        x = 6 + (k % 6) * (W + 6); y = 6 + (k // 6) * (H + 22)
        im = Image.open('%s/%s_a.png' % (out, n.replace(':', '_'))).convert('RGB'); M.paste(im, (x, y + 16))
        d.text((x + 2, y + 2), '%s  f=%d' % (n, meta[n]['frames']), fill=(255, 255, 0))
    M.save('%s/sheet_%02d.png' % (out, pg // 24))
print('done', len(meta))
