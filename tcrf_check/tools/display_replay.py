#!/usr/bin/env python3
"""Replay a coverage corpus (JSONL of root specs and key-action nodes, see lib.Corpus) depth-first in the display-tracking core (gbcov_display.c, README 16.24),
restoring the parent's snapshot for every child, and accumulate which ROM bytes reach the screen (disp, disp_fr, disp_fro), which sound ids are requested / started (snd)
and the first node that did it.  Nodes marked tainted (state pokes somewhere in the lineage) run with the organic flag off.
usage: display_replay.py CORPUS.jsonl OUT.npz [maxnodes]          (GBCAM_ROOT = the working root with saves/, saves_unl/ and package/wram/trace_jp_v3.json; build libgbcov_display.so first)"""
import sys, os, json, time, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import numpy as np
import gbcov_display as g
ROOT = os.environ.get('GBCAM_ROOT', '/home/claude/gbcam_jp')
g.load_rom(os.environ.get('GBCAM_ROM', ROOT + '/pocketcamera_jp.gb'))
import json as _j
# known-code bitmap, as lib.load_known()
t=_j.load(open(ROOT+'/package/wram/trace_jp_v3.json')); K=np.zeros(1<<20,np.uint8)
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
corpus,out=sys.argv[1:3]; maxn=int(sys.argv[3]) if len(sys.argv)>3 else 10**9
E={}
for l in open(corpus):
    if l.strip():
        e=json.loads(l); E[e['id']]=e
kids=collections.defaultdict(list)
for i,e in E.items():
    kids[e.get('parent',-1)].append(i)
first={}      # rom offset -> (node id, sig, organic) of first display
prev=g.disp().copy(); prevn=g.disp_new(); sprev=g.snd().copy(); sprevn=g.snd_new(); sfirst={}
sigs=collections.Counter(); nodes=0; t0=time.time(); skipped=0
def record(i,org):
    global prev,prevn,sprev,sprevn
    sn=g.snd_new()
    if sn!=sprevn:
        cur=g.snd(); sg=(g.peek(0xD5CE),g.peek(0xD5CF))
        for ch,v in zip(*np.nonzero(cur!=sprev)):
            k=(int(ch),int(v))
            if k not in sfirst or ((cur[ch,v]&2) and not (sprev[ch,v]&2)): sfirst[k]=(i,sg,bool(cur[ch,v]&2))
        sprev=cur.copy(); sprevn=sn
    n=g.disp_new()
    if n!=prevn:
        d=g.disp(); idx=np.nonzero(d!=prev)[0]
        sg=(g.peek(0xD5CE),g.peek(0xD5CF))
        for o in idx:
            if o not in first: first[int(o)]=(i,sg,bool(d[o]&2))
            elif (d[o]&2) and not (prev[o]&2): first[int(o)]=(i,sg,True)
        prev=d.copy(); prevn=n
def run_node(i,taint):
    global nodes
    e=E[i]
    if 'spec' in e:
        sp=e['spec']; sv=SAV(sp['sav'])
        if sv is None: return None
        g.set_organic(1); g.reset(sv); g.L.gb_attach_printer(sp['printer']); g.keys(sp['combo']); g.run(250); g.keys(0); g.run(sp['free'])
    else:
        g.set_organic(0 if taint else 1)
        for a in e['actions']: act(a)
    nodes+=1
    sigs[(g.peek(0xD5CE),g.peek(0xD5CF))]+=1
    record(i,not taint)
    return True
roots=kids[-1]
done=0
for r in roots:
    if nodes>=maxn: break
    if run_node(r,False) is None: skipped+=1; continue
    stack=[(g.snapshot(),False,list(kids[r]))]
    while stack:
        snap,taint,todo=stack[-1]
        if not todo: stack.pop(); continue
        c=todo.pop(); ce=E[c]
        g.restore(snap)
        tt=taint or bool(ce.get('tainted'))
        if run_node(c,tt):
            if kids[c]: stack.append((g.snapshot(),tt,list(kids[c])))
        if nodes>=maxn: break
    done+=1
    if done%20==0: print('roots',done,'/',len(roots),'nodes',nodes,'sigs',len(sigs),'%.0fs'%(time.time()-t0),flush=True)
d=g.disp().copy()
np.savez_compressed(out,disp=d,first_off=np.array(list(first.keys()),np.int64),first_node=np.array([v[0] for v in first.values()],np.int64),
    first_sig=np.array([v[1][0]<<8|v[1][1] for v in first.values()],np.int32),first_org=np.array([v[2] for v in first.values()],np.uint8),
    sigs=np.array([(a<<8|b,c) for (a,b),c in sigs.items()],np.int64),
    fr=g.disp_fr().copy(), fro=g.disp_fro().copy(),
    snd=g.snd().copy(), snd_first=np.array([(ch,v,n,sg[0]<<8|sg[1],int(o)) for (ch,v),(n,sg,o) in sfirst.items()],np.int64).reshape(-1,5))
print('done nodes',nodes,'skipped roots',skipped,'sigs',len(sigs),'displayed bytes',int((d>0).sum()),'organic',int((d&2>0).sum()),'%.0fs'%(time.time()-t0))
