"""Helpers for the display-tracking core: save loading (saves/, saves_unl/, synthetic _ff / _zero), key actions (act), corpus paths and replay (Corpus).
GBCAM_ROOT = working root with saves/, saves_unl/, package/wram/trace_jp_v3.json (README 16.15).  Used by display_stamps.py (README 16.24)."""
import sys, os, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import numpy as np
import gbcov_display as g
ROOT = os.environ.get('GBCAM_ROOT', '/home/claude/gbcam_jp')
g.load_rom(os.environ.get('GBCAM_ROM', ROOT + '/pocketcamera_jp.gb'))
t = json.load(open(ROOT + '/package/wram/trace_jp_v3.json')); K=np.zeros(1<<20,np.uint8)
for k,n in t['code'].items():
    if n>0:
        b,a=k.split(':'); b=int(b,16); a=int(a,16); K[a if b==0 and a<0x4000 else b*0x4000+a-0x4000]=1
g.set_known(K)
_sav={}
def SAV(name):
    if name in ('_ff','_zero'): return (b'\xff' if name=='_ff' else b'\0')*0x20000
    if name not in _sav:
        for d in ('saves','saves_unl','fuzz_saves_unl'):
            f=os.path.join(ROOT,d,name+'.sav')
            if os.path.exists(f): _sav[name]=open(f,'rb').read(); break
        else: _sav[name]=None
    return _sav[name]
def act(a):
    if a[0]=='P':
        _,pf,wait,pairs=a
        for _ in range(pf):
            for ad,v in pairs: g.poke(ad,v)
            g.run(1)
        g.run(wait)
    else:
        k,hold,wait=a[:3]; g.keys(k); g.run(hold); g.keys(0); g.run(wait)
def press(k,hold=4,wait=20): act((k,hold,wait))
class Corpus:
    def __init__(s,path):
        s.E={}
        for l in open(path):
            if l.strip():
                e=json.loads(l); s.E[e['id']]=e
    def path(s,i):
        p=[]
        while i>=0: p.append(i); i=s.E[i].get('parent',-1)
        return p[::-1]
    def frames(s,i):
        f=0
        for j in s.path(i):
            e=s.E[j]
            if 'spec' in e: f+=250+e['spec']['free']
            else:
                for a in e['actions']: f+=int(a[1])+int(a[2])
        return f
    def tainted(s,i): return any(s.E[j].get('tainted') for j in s.path(i))
    def best(s,sig):
        c=[(s.frames(i),i) for i,e in s.E.items() if tuple(e['sig'])==tuple(sig) and not s.tainted(i)]
        return min(c)[1] if c else None
    def replay(s,i,sav=None,organic=True):
        p=s.path(i); sp=dict(s.E[p[0]]['spec'])
        g.set_organic(1 if organic else 0); g.reset(sav if sav is not None else SAV(sp['sav'])); g.L.gb_attach_printer(sp['printer']); g.keys(sp['combo']); g.run(250); g.keys(0); g.run(sp['free'])
        for j in p[1:]:
            for a in s.E[j]['actions']: act(a)
def cur(): return (g.peek(0xD5CE),g.peek(0xD5CF))
def save(path,tag=''):
    d=g.disp().copy(); np.savez_compressed(path,disp=d,fr=g.disp_fr().copy(),fro=g.disp_fro().copy(),snd=g.snd().copy())
