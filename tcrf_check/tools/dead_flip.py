#!/usr/bin/env python3
"""Force the UNREACHABLE components (README 16.26): flip the conditional branch that leads into the component and play on.

An UNREACHABLE component is code inside a live routine that a branch could enter but no value of any variable makes it do (README 16.21).  Here the gate is found from the
listing (a `jr / jp / call cc` whose target is the component's first byte, or a conditional branch / `ret cc` right in front of it, so that the component is the fall-through),
`gb_force_flip` makes the core decide the other way at that ROM offset, and the game is run from each base state (the cheapest corpus entry of every mode) under a few key
sequences.  Reported per component: whether the gate was executed (flips counted), whether the component ran, and what differs from the unforced control run (WRAM, VRAM with the
ROM span it came from, sound requests, final mode / state).  An UNREACHABLE fragment is a piece of a larger routine, so what it does is the routine's work with a value the
code never has: read the notes of reach_components_jp.csv for what that value is.
usage: dead_flip.py CACHE_DIR OUT.json [COMPONENT ...]      (environment as dead_jump.py)"""
import sys, os, re, json, collections
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import numpy as np
import dead_jump as J
g = J.g
DIS = os.environ.get('GBCAM_DISASM', '/home/claude/tc/rtrepo/fixed')
_lst = {}
def listing(bank):
    """{addr: (mnemonic text, [bytes])} of an mgbdis bank listing"""
    if bank not in _lst:
        d = {}
        for ln in open(os.path.join(DIS, 'bank_%03x.asm' % bank)):
            m = re.search(r';\s*\$([0-9a-f]{4}):((?:\s*\$[0-9a-f]{2})+)', ln)
            if m: d[int(m.group(1), 16)] = (ln.split(';')[0].strip(), [int(x, 16) for x in re.findall(r'\$([0-9a-f]{2})', m.group(2))])
        _lst[bank] = d
    return _lst[bank]

def gates(bank, entry):
    """addresses of the conditional branches that lead into `entry`: explicit targets and a conditional instruction that ends right at `entry` (fall-through)"""
    L = listing(bank); out = []
    for a, (t, b) in L.items():
        op = b[0]; n = len(b)
        if op in (0x20, 0x28, 0x30, 0x38):                     # jr cc
            tgt = (a + 2 + (b[1] - 256 if b[1] > 127 else b[1])) & 0xFFFF
            if tgt == entry or a + n == entry: out.append(a)
        elif op in (0xC2, 0xCA, 0xD2, 0xDA, 0xC4, 0xCC, 0xD4, 0xDC):   # jp cc / call cc
            tgt = b[1] | b[2] << 8
            if tgt == entry or a + n == entry: out.append(a)
        elif op in (0xC0, 0xC8, 0xD0, 0xD8):                   # ret cc
            if a + n == entry: out.append(a)
    return out

# key sequences played from each base state: (keys, hold frames) then the rest of TOTAL frames idle
SEQS = [('idle', []), ('A', [(J.g.A, 4)]), ('B', [(J.g.B, 4)]), ('Start', [(J.g.START, 4)]), ('Select', [(J.g.SELECT, 4)]), ('Right', [(J.g.RIGHT, 4)]), ('Left', [(J.g.LEFT, 4)]),
        ('Up', [(J.g.UP, 4)]), ('Down', [(J.g.DOWN, 4)]), ('A+Right', [(J.g.A | J.g.RIGHT, 6)]), ('A+Left', [(J.g.A | J.g.LEFT, 6)]), ('A+Up', [(J.g.A | J.g.UP, 6)]), ('A+Down', [(J.g.A | J.g.DOWN, 6)])]

def play(base, seq, flips, bank):
    """restore, set the flips, run J.TOTAL frames pressing `seq` at the start; returns (end state, executed flat offsets, hits per gate, final (mode, state))"""
    g.restore(base['snap']); g.L.gb_cov_clear(); g.snd_clear(); g.set_organic(1); g.force_clear()
    for o in flips: g.force_flip(o, 1)
    f0 = g.L.gb_frame()
    for keys, hold in seq:
        g.keys(keys); g.run(hold); g.keys(0); g.run(3)
    while g.L.gb_frame() < f0 + J.TOTAL: g.run(1)
    hits = {o: g.force_hits(o) for o in flips}
    ex = set(int(x) for x in np.flatnonzero(g.cov_exec())); st = g.state(); snd = set(J.snd_requests())
    g.force_clear()
    return st, ex, hits, (g.peek(0xD5CE), g.peek(0xD5CF)), snd

_ctlc = {}
def run_flip(cid, comp, B):
    bank = comp['bank']; gl = gates(bank, comp['entry']); res = dict(gates=['%02X:%04X' % (bank, a) for a in gl], tries=0, hit_gate=0, ran=[])
    if not gl: return res
    flips = [g.flat(bank, a) for a in gl]
    cbytes = set(g.flat(bank, a) for s, e in comp['runs'] for a in range(s, e + 1))
    for mode, base in B.items():
        for name, seq in SEQS:
            if (mode, name) not in _ctlc: _ctlc[(mode, name)] = play(base, seq, [], bank)
            s0, ex0, _, m0, snd0 = _ctlc[(mode, name)]; s1, ex1, hits, m1, snd1 = play(base, seq, flips, bank)
            res['tries'] += 1
            if sum(hits.values()) == 0: continue
            res['hit_gate'] += 1
            ran = len((ex1 - ex0) & cbytes)
            if ran:
                w0 = np.frombuffer(s0.wram, np.uint8); w1 = np.frombuffer(s1.wram, np.uint8); wd = np.flatnonzero(w0 != w1)
                res['ran'].append(dict(mode=mode, seq=name, gate_hits=sum(hits.values()), comp_bytes_run=ran, mode_ctl=m0, mode_after=m1, snd=sorted(snd1 - snd0), wram_changed=int(len(wd)),
                                       wram_first=[(0xC000 + int(i), int(w0[i]), int(w1[i])) for i in wd[:12]], vram=J.vram_runs(s0, s1)[:12], vram_n=len(J.vram_runs(s0, s1)),
                                       oam_changed=int(sum(1 for i in range(0xA0) if s0.oam[i] != s1.oam[i]))))
    return res

if __name__ == '__main__':
    cache, outf = sys.argv[1], sys.argv[2]; want = sys.argv[3:]
    C = J.components(); B = J.bases(cache)
    todo = [k for k in C if (k in want if want else C[k]['verdict'] in ('UNREACHABLE', 'EDGE'))]
    out = {}
    for k in todo:
        r = run_flip(k, C[k], B); r['comp'] = C[k]; out[k] = r
        print(k, 'gates', r['gates'], 'tries', r['tries'], 'gate executed in', r['hit_gate'], 'component ran in', len(r['ran']), flush=True)
        json.dump(out, open(outf, 'w'))
