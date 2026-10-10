import numpy as np
BASE='/home/claude/gbcam_jp/cov/report_v6/merged_cov.npz'
_z=np.load(BASE); BDR=_z['dr']|(_z['odr']); BEX=_z['ex']
def runs(mask):
    idx=np.flatnonzero(mask); out=[]
    if not len(idx): return out
    st=idx[0]; pv=idx[0]
    for i in idx[1:]:
        if i!=pv+1: out.append((st,pv-st+1)); st=i
        pv=i
    out.append((st,pv-st+1)); return out
def addr(o): 
    b=o//0x4000; return '%02X:%04X'%(b,(o%0x4000)+(0x4000 if b else 0))
def delta(g, kinds=('dr','ex'), minlen=1):
    res={}
    if 'dr' in kinds: res['dr']=[(addr(o),l) for o,l in runs((g.cov_dread()!=0)&(BDR==0)) if l>=minlen]
    if 'ex' in kinds: res['ex']=[(addr(o),l) for o,l in runs((g.cov_exec()!=0)&(BEX==0)) if l>=minlen]
    return res
BODR=_z['odr']; BOEX=_z['oex']
def delta_org(g, minlen=1):
    return dict(dr=[(addr(o),l) for o,l in runs((g.org_dread()!=0)&(BODR==0)) if l>=minlen],
                ex=[(addr(o),l) for o,l in runs((g.org_exec()!=0)&(BOEX==0)) if l>=minlen])
