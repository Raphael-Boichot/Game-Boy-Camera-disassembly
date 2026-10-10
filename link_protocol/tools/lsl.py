"""Helpers: link-screen roots for any pair of saves, and a serial sniffer."""
import sys, os, json
sys.path.insert(0, '/home/claude/gbcam_jp/cov')
import link_lib as L
SAV = '/home/claude/gbcam_jp/cov/saves'
C = L.Corpus('/home/claude/gbcam_jp/cov/state7_a'); REF = 709
def root_for(g, sav):
    """snapshot of core g (fresh) after the reference key path to the link screen (mode $0E), with the save `sav` (name or bytes)"""
    refp = C.path(REF); sp0 = dict(C.E[refp[0]]['spec'])
    if isinstance(sav, bytes):
        C.SAV['_tmp'] = sav; sp0['sav'] = '_tmp'
    else: sp0['sav'] = sav
    # replay path without cache pollution
    g.set_organic(1); g.reset(C.SAV[sp0['sav']]); g.L.gb_attach_printer(sp0['printer']); g.keys(sp0['combo']); g.run(250); g.keys(0); g.run(sp0['free'])
    for j in refp[1:]:
        for x in C.E[j]['actions']: L.apply_action(g, x)
    return g.snapshot()
class Sniffer:
    def __init__(self):
        self.P = L.Pair(); self.seq = []; P = self.P; me = self
        def ev(self_, X, Y, e):
            if e & 1:
                self_.nx += 1; nameX = 'A' if X is self_.A else 'B'
                ok = self_.connected and (Y.L.gb_link_sc() & 0x81) == 0x80 and Y.L.gb_link_cd() == 0
                if ok:
                    rx = Y.L.gb_link_sb(); tx = X.L.gb_link_out()
                    X.L.gb_link_set_rx(rx); Y.L.gb_link_deliver(tx, X.L.gb_link_cd())
                    me.seq.append(dict(fr=self_.frames, m=nameX, tx=tx, rx=rx, ok=1, st=(self_.state(self_.A), self_.state(self_.B))))
                else:
                    me.seq.append(dict(fr=self_.frames, m=nameX, tx=X.L.gb_link_out(), rx=0xFF, ok=0, st=(self_.state(self_.A), self_.state(self_.B))))
        P._event = lambda X, Y, e: ev(P, X, Y, e)
    def start(self, savA, savB, idle=60):
        P = self.P; sa = root_for(P.A, savA); sb = root_for(P.B, savB)
        P.A.restore(sa); P.B.restore(sb)
        for c in (P.A, P.B): c.link_enable(1); c.set_organic(1)
        P.ta = P.tb = 0; P.frames = 0; self.seq = []; P.nx = 0; P.run(idle)
