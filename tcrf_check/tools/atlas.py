import sys, os, json; sys.path.insert(0,'/home/claude/gbcam_jp/cov/tcrf_work'); sys.path.insert(0,'/home/claude/gbcam_jp/cov')
import link_lib as L, render2 as R
from PIL import Image
C=L.Corpus('/home/claude/gbcam_jp/cov/state7_a')
g=L.load_core('libgbcov7.so')
best={}
for i,e in enumerate(C.E):
    if C.tainted(i): continue
    s=tuple(e['sig']); fr=0
    for j in C.path(i):
        if 'spec' in C.E[j]: fr+=250+C.E[j]['spec']['free']
        else: fr+=sum(a[1]+a[2] for a in C.E[j]['actions'])
    if s not in best or fr<best[s][0]: best[s]=(fr,i)
OUT='/home/claude/gbcam_jp/cov/tcrf_work/shots/atlas'; os.makedirs(OUT,exist_ok=True)
meta={}
for s in sorted(best):
    fr,i=best[s]
    try:
        snap=C.snap(g,i); g.restore(snap); g.set_organic(1)
        a=R.screen(g); g.keys(0); g.run(40); b=R.screen(g)
        Image.fromarray(a).save('%s/%02X_%02X_a.png'%(OUT,s[0],s[1])); Image.fromarray(b).save('%s/%02X_%02X_b.png'%(OUT,s[0],s[1]))
        meta['%02X:%02X'%s]=dict(entry=i,frames=fr,sig_now=[g.peek(0xD5CE),g.peek(0xD5CF)])
    except Exception as ex: print('fail',s,ex)
json.dump(meta,open(OUT+'/meta.json','w'))
print('done',len(meta))
