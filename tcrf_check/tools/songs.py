import numpy as np, sys
rom=open('/home/claude/gbcam_jp/pocketcamera_jp.gb','rb').read()
z=np.load('/home/claude/gbcam_jp/merged_v7/cov.npz'); dr=z['dr']; odr=z['odr']; ex=z['ex']
B=0x1F; base=B*0x4000
def w(a): return rom[base+a-0x4000]|rom[base+a-0x4000+1]<<8
ptr=[w(0x57C6+2*i) for i in range(72)]
valid=sorted(set(p for p in ptr if 0x4000<=p<0x8000))
def extent(p):
    nxt=[q for q in valid if q>p]; return (nxt[0] if nxt else 0x8000)
rows=[]
for i,p in enumerate(ptr):
    sid=i+1
    if not (0x4000<=p<0x8000): rows.append((sid,p,None)); continue
    e=extent(p); rng=range(base+p-0x4000, base+e-0x4000)
    n=len(rng); r=sum(1 for o in rng if dr[o] or ex[o]); orr=sum(1 for o in rng if odr[o])
    # unread runs
    runs=[]; st=None
    for o in rng:
        u=not (dr[o] or ex[o])
        if u and st is None: st=o
        if not u and st is not None: runs.append((st-base+0x4000,o-st)); st=None
    if st is not None: runs.append((st-base+0x4000,rng[-1]+1-st))
    rows.append((sid,p,(e,n,r,orr,runs)))
dups={}
for i,p in enumerate(ptr): dups.setdefault(p,[]).append(i+1)
for sid,p,x in rows:
    if x is None: print('id %02X ptr %04X INVALID pointer'%(sid,p)); continue
    e,n,r,orr,runs=x
    print('id %02X ptr %04X..%04X len %4d read %4d (%3.0f%%) org %4d  same-as %s  unread runs: %s'%(sid,p,e,n,r,100*r/n,orr,[('%02X'%s2) for s2 in dups[p] if s2!=sid],' '.join('%04X+%d'%(a,l) for a,l in runs[:6])))
