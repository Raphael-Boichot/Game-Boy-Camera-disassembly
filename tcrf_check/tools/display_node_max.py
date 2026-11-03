#!/usr/bin/env python3
"""How many frames is a ROM span on screen in ONE node of a replay?  README 16.24 (the six tiles at 13:5CA0).

display_replay.py (and display_union.npz built from it) keeps one cumulative counter per ROM byte over a whole corpus: 15 frames anywhere in the replay make a tile "stable", so fifteen
one-frame events in fifteen different nodes look like a tile that is on screen.  This script replays a corpus the same way (depth first, the parent's snapshot restored for every
child, nodes with a state poke in their lineage run with the organic flag off) but keeps, per span, the largest number of frames that the span gets in a SINGLE node: the largest
increase of disp_fro (organic) and of disp_fr (any run) over the 16-byte rows of the span between the start and the end of the node.  It also counts the nodes whose end state
(mode $D5CE, state $D5CF) differs from the one recorded in the corpus, because the snapshot restore of the core does not always reproduce the straight replay of a node
(a diverged node is a node whose frames are not trustworthy).
usage: display_node_max.py OUT.csv SPANS CORPUS.jsonl [CORPUS.jsonl ...]
  SPANS   BB:AAAA-BBBB[,BB:AAAA-BBBB ...]      ROM spans (bank : first address - last address, hex)
  OUT.csv one row per (corpus path relative to GBCAM_ROOT, span), appended (the header is written when the file is new): corpus, span, nodes, nodes_diverged, org_max_frames_one_node, org_max_node, org_max_sig,
          org_nodes_with_frames, any_max_frames_one_node, any_max_node, any_max_sig, any_nodes_ge_15
(GBCAM_ROOT = the working root with saves/, saves_unl/ and package/wram/trace_jp_v3.json; build libgbcov_display.so first, GBCOV_LIB points to another build)"""

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
OUT=sys.argv[1]; SPANS=[]
for sp_ in sys.argv[2].split(','):
    bk,rg=sp_.split(':'); lo,hi=rg.split('-'); bk=int(bk,16); lo=int(lo,16); hi=int(hi,16)
    SPANS.append((sp_.upper(), bk*0x4000+(lo-0x4000) if bk else lo, bk*0x4000+(hi-0x4000) if bk else hi))
STABLE=15
import csv
FIELDS=['corpus','span','nodes','nodes_diverged','org_max_frames_one_node','org_max_node','org_max_sig','org_nodes_with_frames','any_max_frames_one_node','any_max_node','any_max_sig','any_nodes_ge_15']
for corpus in sys.argv[3:]:
    maxn=10**9
    g.disp_clear()
    res=[dict(org_max=0,org_node='',org_sig='',org_nodes=0,any_max=0,any_node='',any_sig='',any_ge=0) for _ in SPANS]; st=dict(diverged=0)
    E={}
    for l in open(corpus):
        if l.strip():
            e=json.loads(l); E[e['id']]=e
    kids=collections.defaultdict(list)
    for i,e in E.items():
        kids[e.get('parent',-1)].append(i)
    sigs=collections.Counter(); nodes=0; t0=time.time(); skipped=0
    def run_node(i,taint):
        global nodes
        e=E[i]
        PRE=[(g.disp_fro()[a:b+1].astype(np.int64).copy(),g.disp_fr()[a:b+1].astype(np.int64).copy()) for _,a,b in SPANS]
        if 'spec' in e:
            sp=e['spec']; sv=SAV(sp['sav'])
            if sv is None: return None
            g.set_organic(1); g.reset(sv); g.L.gb_attach_printer(sp['printer']); g.keys(sp['combo']); g.run(250); g.keys(0); g.run(sp['free'])
        else:
            g.set_organic(0 if taint else 1)
            for a in e['actions']: act(a)
        nodes+=1
        sigs[(g.peek(0xD5CE),g.peek(0xD5CF))]+=1
        sg=(g.peek(0xD5CE),g.peek(0xD5CF)); rs=e.get('sig')
        if rs is not None and tuple(rs)!=sg: st['diverged']+=1
        for k,(nm,a,b) in enumerate(SPANS):
            o=int((g.disp_fro()[a:b+1].astype(np.int64)-PRE[k][0]).max()); y=int((g.disp_fr()[a:b+1].astype(np.int64)-PRE[k][1]).max())
            R=res[k]
            if o>0: R['org_nodes']+=1
            if o>R['org_max']: R['org_max'],R['org_node'],R['org_sig']=o,i,'%d/%d'%sg
            if y>=STABLE: R['any_ge']+=1
            if y>R['any_max']: R['any_max'],R['any_node'],R['any_sig']=y,i,'%d/%d'%sg
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
        if done%20==0: print(os.path.relpath(corpus,ROOT),'roots',done,'/',len(roots),'nodes',nodes,'sigs',len(sigs),'%.0fs'%(time.time()-t0),flush=True)

    new=not os.path.exists(OUT)
    with open(OUT,'a',newline='') as f:
        w=csv.writer(f,lineterminator='\n')
        if new: w.writerow(FIELDS)
        for (nm,a,b),R in zip(SPANS,res):
            w.writerow([os.path.relpath(corpus,ROOT),nm,nodes,st['diverged'],R['org_max'],R['org_node'],R['org_sig'],R['org_nodes'],R['any_max'],R['any_node'],R['any_sig'],R['any_ge']])
    print('done',os.path.relpath(corpus,ROOT),'nodes',nodes,'diverged',st['diverged'],'%.0fs'%(time.time()-t0),flush=True)
