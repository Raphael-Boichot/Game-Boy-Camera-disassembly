#!/usr/bin/env python3
"""Replay, in BGB, the key sequence that reaches (mode,state) SIG in my corpus, on ROM (JP or international).
usage: bgb_sig.py CORPUS ROM OUTDIR SIG [SIG ...]   -> OUTDIR/MM_SS.bmp/.sna, prints mode:state reached in BGB."""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g
import bgb_run
corpus, rom, out = sys.argv[1:4]; os.makedirs(out, exist_ok=True)
C = lib.Corpus(corpus)
NAMES = [(g.RIGHT, 'Right'), (g.LEFT, 'Left'), (g.UP, 'Up'), (g.DOWN, 'Down'), (g.A, 'A'), (g.B, 'B'), (g.SELECT, 'Select'), (g.START, 'Start')]
def names(k): return '+'.join(n for m, n in NAMES if k & m) or '-'
def seq_for(sig):
    s = tuple(int(x, 16) for x in sig.split(':')); i = C.best(s)
    if i is None: return None
    p = C.path(i); sp = dict(C.E[p[0]]['spec']); seq = []
    for j in p[1:]:
        for a in C.E[j]['actions']:
            if a[0] == 'P': continue
            seq.append((names(a[0]), int(a[1]), int(a[2])))
    return sp, seq, i
if __name__ == '__main__':
    for sig in sys.argv[4:]:
        r = seq_for(sig)
        if r is None: print(sig, 'no entry'); continue
        sp, seq, i = r
        sav = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'saves_unl', sp['sav'] + '.sav')
        if not os.path.exists(sav): sav = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'saves', sp['sav'] + '.sav')
        if not os.path.exists(sav): sav = None
        if sp['sav'] in ('_ff', '_zero'):                       # synthetic all-FF / all-00 saves used by the explorer
            sav = os.path.join(out, sp['sav'] + '.sav'); open(sav, 'wb').write((b'\xff' if sp['sav'] == '_ff' else b'\0') * 0x20000)
        if sp.get('printer'): print(sig, 'SKIP (printer attached in the corpus path)', flush=True); continue
        res = bgb_run.run(rom, sav, '%s/%s' % (out, sig.replace(':', '_')), seq, combo=0 if not sp['combo'] else bgb_run.mask(names(sp['combo'])), free=sp['free'] + int(os.environ.get('BGB_SHIFT', 0)))
        print(sig, 'entry', i, 'BGB rc', res['rc'], 'mode:state = %02X:%02X' % (res['mode'] or 0, res['state'] or 0) if res['mode'] is not None else 'no state', 'PC', hex(res['pc'] or 0), flush=True)
