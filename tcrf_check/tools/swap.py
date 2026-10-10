import sys, os, json
sys.path.insert(0,'/home/claude/gbcam_jp/cov')
import link_lib as L
C=L.Corpus('/home/claude/gbcam_jp/cov/state7_a')
UNL='/home/claude/gbcam_jp/cov/saves_unlock/'
def swapsnap(g, i, sav, organic=True, extra=300):
    """core g after replaying corpus entry i's whole path but with the root save replaced by `sav` (bytes)"""
    p=C.path(i); sp=dict(C.E[p[0]]['spec'])
    g.set_organic(1 if organic else 0); g.reset(sav); g.L.gb_attach_printer(sp['printer']); g.keys(sp['combo']); g.run(250); g.keys(0); g.run(sp['free']+extra)
    for j in p[1:]:
        for x in C.E[j]['actions']: L.apply_action(g, x)
    return g.snapshot()
def sav(name): return open(UNL+name,'rb').read()
