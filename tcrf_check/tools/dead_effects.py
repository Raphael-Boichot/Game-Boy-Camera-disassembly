#!/usr/bin/env python3
"""Force the camera-effect handlers that the index table 06:60DB never selects (README 16.26): the 22 UNREACHABLE components of the TABLE group.
The effect dispatcher Cam_DispatchEffect (0A:5406) takes the handler number in A and jumps through Cam_EffectJumpTbl (0A:541A).  The game only produces the numbers that the 88-byte table 06:60DB gives, OR 0 / $20 / $40;
here every number 0..$5F is called, with the same pattern in SRAM $A000-$BFFF (the image buffers), and the bytes that the handler writes to WRAM are compared with those of the live handlers
(identical destination bytes = the same function; a prefix = the same function over fewer rows).  The 06:73AF slots (second consumer, XOR passes over $C000..) are called the same way.
usage: dead_effects.py CACHE_DIR OUT.json              (environment as dead_jump.py)"""
import sys, os, json, hashlib
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import numpy as np
import dead_jump as J
g = J.g

def pattern():
    """SRAM bank 0 image buffers: a recognisable byte per address (so that a handler's source can be read off its output)"""
    a = np.arange(0x2000, dtype=np.uint32)
    return ((a * 167 + (a >> 8) * 31 + 13) & 0xFF).astype(np.uint8)

def call(base, bank, entry, a=None, wram_pre=None):
    """one forced call; returns the final WRAM byte per written address (stack pushes dropped) and whether it returned"""
    pat = pattern()
    def setup(r, idle):
        s = g.sram(); s[0:0x2000] = pat
        if wram_pre is not None:
            w = g.wram()
            for off, v in wram_pre: w[off] = v
        g.jump(entry, bank, idle); g.set_stop(idle)
        rr = g.regs(); g.set_regs(rr['a'] if a is None else a, rr['f'], rr['bc'], rr['de'], rr['hl'], rr['sp'])
    rep = J.observe(0, base, setup)
    d = rep['direct']
    return rep['returned'], rep['frames_to_return'], (d['wram'] if d else None), d

def span(w):
    if not w: return None
    ad = [a for a, v in w]; return (min(ad), max(ad), len(ad))

def xor_slots(base):
    """the second consumer: slots of 06:73AF.  06:7457 / 06:7467 (slot numbers $13 / $15) against the live slot $00 (06:73EF, 14 rows): same WRAM pattern, XOR pass over the rows from $C000"""
    pre = [(i, (i * 91 + (i >> 8) * 17 + 5) & 0xFF) for i in range(0x1000)] + [(0x1A44, 0xA5), (0x1A45, 0x3C)]      # $DA44/$DA45 = the 16-bit XOR key; the body does nothing for key 0
    res = {}
    for name, entry in (('slot00_73EF', 0x73EF), ('slot13_7457', 0x7457), ('slot15_7467', 0x7467)):
        ret, fr, w, d = call(base, 0x06, entry, wram_pre=pre)
        res[name] = dict(returned=ret, frames=fr, wram=w, n=len(w) if w else 0, span=span(w))
    return res

if __name__ == '__main__':
    B = J.bases(sys.argv[1]); base = B[16]; out = {}
    for idx in range(0x60):
        ret, fr, w, d = call(base, 0x0A, 0x5406, a=idx)
        out['%02X' % idx] = dict(returned=ret, frames=fr, wram=w, n=len(w) if w else 0, span=span(w), hash=hashlib.md5(repr(w).encode()).hexdigest()[:8] if w else None)
        print('%02X' % idx, ret, fr, out['%02X' % idx]['span'], out['%02X' % idx]['hash'], flush=True)
    json.dump(out, open(sys.argv[2], 'w'))
    xs = xor_slots(base); xs = {k: {kk: vv for kk, vv in e.items() if kk != 'wram'} for k, e in xs.items()}      # the XOR slots of 06:73AF, next to OUT.json
    json.dump(xs, open(os.path.join(os.path.dirname(os.path.abspath(sys.argv[2])), 'xorslots.json'), 'w'))
