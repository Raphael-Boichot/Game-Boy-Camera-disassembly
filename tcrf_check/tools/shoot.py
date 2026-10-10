"""Drive the emulator from a corpus anchor with an (optionally unlocked) save and take screenshots.
   shoot(entry, savpath, 'R R D A w60 *', out) : tokens R L U D A B s(elect) S(tart) ; wN = wait N frames ; '*' = take screenshot ; each key is hold 4 + wait 24
   returns list of (token, mode, state) and writes a montage"""
import sys, os; sys.path.insert(0,'/home/claude/gbcam_jp/cov/tcrf_work'); sys.path.insert(0,'/home/claude/gbcam_jp/cov')
from swap import *
import render2 as R
G=L.load_core(os.environ.get('CORE','libgbcov8.so'))
UNL='/home/claude/gbcam_jp/cov/saves_unl/'; REAL='/home/claude/gbcam_jp/cov/saves/'
KEY={'R':G.RIGHT,'L':G.LEFT,'U':G.UP,'D':G.DOWN,'A':G.A,'B':G.B,'s':G.SELECT,'S':G.START}
def anchor(entry, savname=None, unlocked=True, extra=300):
    p=C.path(entry); orig=C.E[p[0]]['spec']['sav']
    name=savname or orig
    path=(UNL+'unl_'+name+'.sav') if unlocked else (REAL+name+'.sav')
    return swapsnap(G,entry,open(path,'rb').read(),extra=extra)
def play(seq, hold=4, wait=24, shots=None, log=None):
    shots=shots if shots is not None else []; log=log if log is not None else []
    for tok in seq.split():
        if tok=='*': shots.append(R.screen(G)); continue
        if tok[0]=='w': G.run(int(tok[1:])); continue
        if tok[0]=='h':   # hold: h<keys>:<frames>, e.g. hA:200
            ks,fr=tok[1:].split(':'); k=0
            for c in ks: k|=KEY[c]
            G.keys(k); G.run(int(fr)); G.keys(0); G.run(wait); continue
        L.apply_action(G,(KEY[tok],hold,wait)); log.append((tok,G.peek(0xD5CE),G.peek(0xD5CF)))
    return shots,log
def save_montage(shots,path,cols=4,scale=1): R.montage(shots,cols,scale=scale).save(path)
