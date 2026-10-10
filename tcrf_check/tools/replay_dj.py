#!/usr/bin/env python3
"""Replay the damaged-save tap sequence that reaches mode $1F, log the (mode,state) trajectory, save screenshots on each mode change"""
import sys, os, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g, R
from PIL import Image
hit = json.load(open(sys.argv[1])); out = sys.argv[2]; os.makedirs(out, exist_ok=True)
d = bytearray(open(os.path.join(lib.ROOT, 'package/coverage/saves', hit['base'] + '.sav'), 'rb').read())
for name, off, x in hit['edits']: d[off] ^= x
g.set_organic(1); g.reset(bytes(d)); g.L.gb_attach_printer(0); g.run(300)
last = None; log = []
KN = {1:'A',2:'B',4:'Select',8:'Start',16:'Right',32:'Left',64:'Up',128:'Down'}
for n, (k, w) in enumerate(hit['seq']):
    g.keys(k); g.run(4); g.keys(0)
    for _ in range(w // 10):
        g.run(10)
        ms = (g.peek(0xD5CE), g.peek(0xD5CF))
        if ms != last:
            log.append(dict(tap=n, key=KN.get(k, k), mode='%02X' % ms[0], state='%02X' % ms[1]))
            Image.fromarray(R.screen(g)).save('%s/t%02d_%02X_%02X.png' % (out, n, *ms)); last = ms
    g.run(w % 10)
print(json.dumps(log))
json.dump(log, open(out + '/trajectory.json', 'w'))
