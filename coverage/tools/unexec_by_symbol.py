import sys as _s, os as _o
_s.path.insert(0, _o.path.join(_o.path.dirname(_o.path.abspath(__file__)), '..', 'src'))
import paths
import numpy as np, json, re, bisect, collections, sys
t=json.load(open(paths.TRACE))
def flat(b,a): return a if b==0 and a<0x4000 else b*0x4000+(a-0x4000)
ex=np.zeros(1<<20,np.uint8); oex=np.zeros(1<<20,np.uint8)
for f in sys.argv[1:]:
    z=np.load(f); ex=np.where((ex==1)|(z['ex']==1),1,ex); oex=np.where((oex==1)|(z['oex']==1),1,oex)
syms=[]
for line in open(paths.SYM):
    m=re.match(r'([0-9a-fA-F]{2}):([0-9a-fA-F]{4})\s+(\S+)',line)
    if m: syms.append((flat(int(m.group(1),16),int(m.group(2),16)),m.group(3)))
syms.sort(); keys=[s[0] for s in syms]
unex=collections.Counter(); org=collections.Counter(); tot=collections.Counter()
for k,n in t['code'].items():
    if n<=0: continue
    b,a=k.split(':'); f=flat(int(b,16),int(a,16))
    i=bisect.bisect_right(keys,f)-1
    name=syms[i][1] if i>=0 and (f>>14)==(syms[i][0]>>14 if f>=0x4000 else 0) else '?%02X'%(f>>14)
    tot[name]+=1
    if ex[f]!=1: unex[name]+=1
    if oex[f]==1: org[name]+=1
print('total instr',sum(tot.values()),'executed',sum(tot.values())-sum(unex.values()),'organic',sum(org.values()))
for n,c in sorted(unex.items(),key=lambda kv:-kv[1])[:25]: print('%-34s never %4d / %4d  (organic %4d)'%(n,c,tot[n],org[n]))
