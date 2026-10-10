"""Helper layer over the package core (coverage/src/gbcov.py): path setup, ROM load, screen render, corpus replay."""
import sys, os, json
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, os.path.join(ROOT, 'package', 'coverage', 'src')); sys.path.insert(0, HERE)
import numpy as np
import gbcov as g
import render2 as R
ROM = os.environ.get('GBCAM_ROM', os.path.join(ROOT, 'pocketcamera_jp.gb'))
g.load_rom(ROM)
TRACE = os.path.join(ROOT, 'package', 'wram', 'trace_jp_v3.json')
def load_known():
    t = json.load(open(TRACE)); K = np.zeros(g.ROMSZ, np.uint8)
    for k, n in t['code'].items():
        if n > 0:
            b, a = k.split(':'); b = int(b, 16); a = int(a, 16); K[a if b == 0 and a < 0x4000 else b * 0x4000 + a - 0x4000] = 1
    g.set_known(K)
def boot(sav, combo=0, printer=0, free=400, organic=True):
    g.set_organic(1 if organic else 0); g.reset(sav if isinstance(sav, bytes) else open(sav, 'rb').read()); g.L.gb_attach_printer(printer)
    g.keys(combo); g.run(250); g.keys(0); g.run(free)
def act(a):
    if a[0] == 'P':
        _, pf, wait, pairs = a
        for _ in range(pf):
            for ad, v in pairs: g.poke(ad, v)
            g.run(1)
        g.run(wait)
    else:
        k, hold, wait = a[:3]; g.keys(k); g.run(hold); g.keys(0); g.run(wait)
KEY = dict(R=g.RIGHT, L=g.LEFT, U=g.UP, D=g.DOWN, A=g.A, B=g.B, s=g.SELECT, S=g.START)
def play(seq, hold=4, wait=24, shots=None, log=None):
    """seq tokens: R L U D A B s S ; wN wait N frames ; '*' screenshot ; hKEYS:N hold keys N frames"""
    shots = shots if shots is not None else []; log = log if log is not None else []
    for tok in seq.split():
        if tok == '*': shots.append(R.screen(g)); continue
        if tok[0] == 'w': g.run(int(tok[1:])); continue
        if tok[0] == 'h':
            ks, fr = tok[1:].split(':'); k = 0
            for c in ks: k |= KEY[c]
            g.keys(k); g.run(int(fr)); g.keys(0); g.run(wait); continue
        act((KEY[tok], hold, wait)); log.append((tok, g.peek(0xD5CE), g.peek(0xD5CF)))
    return shots, log
def cur(): return (g.peek(0xD5CE), g.peek(0xD5CF))

# ---------------------------------------------------------------- corpus helpers
class Corpus:
    def __init__(self, path):
        self.E = {}
        for l in open(path):
            if l.strip():
                e = json.loads(l); self.E[e['id']] = e
    def path(self, i):
        p = []
        while i >= 0: p.append(i); i = self.E[i].get('parent', -1)
        return p[::-1]
    def frames(self, i):
        f = 0
        for j in self.path(i):
            e = self.E[j]
            if 'spec' in e: f += 250 + e['spec']['free']
            else:
                for a in e['actions']: f += int(a[1]) + int(a[2])
        return f
    def tainted(self, i): return any(self.E[j].get('tainted') for j in self.path(i))
    def best(self, sig, sav_ok=lambda s: True):
        """cheapest untainted entry whose recorded (mode,state) == sig"""
        c = [(self.frames(i), i) for i, e in self.E.items() if tuple(e['sig']) == tuple(sig) and not e.get('tainted') and sav_ok(self.path(i)) and not self.tainted(i)]
        return min(c)[1] if c else None
    def replay(self, i, sav=None):
        """boot root (optionally with another save) then apply every action; returns snapshot"""
        p = self.path(i); sp = dict(self.E[p[0]]['spec'])
        boot(sav if sav is not None else SAV(sp['sav']), combo=sp['combo'], printer=sp['printer'], free=sp['free'])
        for j in p[1:]:
            for a in self.E[j]['actions']: act(a)
        return g.snapshot()
_SAVCACHE = {}
def SAV(name):
    if name not in _SAVCACHE:
        for d in ('saves', 'saves_unl'):
            f = os.path.join(ROOT, d, name + '.sav')
            if os.path.exists(f): _SAVCACHE[name] = open(f, 'rb').read(); break
        else:
            _SAVCACHE[name] = bytes(0x20000) if name == '_zero' else (b'\xff' * 0x20000 if name == '_ff' else None)
    return _SAVCACHE[name]
