import sys, os, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g, R
hit = json.load(open('unlock_runs/dj_hit.json'))
d = bytearray(open('package/coverage/saves/%s.sav' % hit['base'], 'rb').read())
for name, off, x in hit['edits']: d[off] ^= x
g.set_organic(1); g.reset(bytes(d)); g.L.gb_attach_printer(0); g.run(300)
prev = None
for n, (k, w) in enumerate(hit['seq']):
    g.keys(k); g.run(4); g.keys(0)
    for f in range(w):
        g.run(1)
        m = g.peek(0xD5CE)
        if m == 7 or (prev and prev[0] == 7):
            cur = (m, g.peek(0xD5CF), g.peek(0xD502), g.peek(0xD503), g.peek(0xD504), g.peek(0xD84C), g.peek(0xD84B), g.peek(0xD84A), g.peek(0xD88B), g.peek(0xDAA1), g.peek(0xDAA2), g.peek(0xDAA3))
            if cur != prev: print('tap', n, 'f', f, 'mode %02X state %02X  D502-4=%02X %02X %02X  D84A-C=%02X %02X %02X D88B=%02X  best(DAA1..3)=%02X %02X %02X' % (cur[0], cur[1], cur[2], cur[3], cur[4], cur[7], cur[6], cur[5], cur[8], cur[9], cur[10], cur[11])); prev = cur
        elif m != 7: prev = (m,) if prev and prev[0]==7 else prev
