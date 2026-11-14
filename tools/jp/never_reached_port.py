#!/usr/bin/env python3
"""Where the never-reached assets of the Japanese ROM (roms/jp_rev_a/experiments/unidentified/really_unused.csv, tiers other than shown) are in the international ROM
(same address / found elsewhere / absent) and how many of their bytes the international coverage run read (any run / organic runs only).
Inputs: the two ROMs (/root/work/roms), the coverage state cov.npz of coverage/tools/coverage_run.py (path below). Output: a csv, then
roms/us_eu/assets/never_reached_us.csv is written from it (columns renamed; blocks under 64 bytes found elsewhere marked as possible coincidences)."""
import csv,numpy as np,collections
J=open('/root/work/roms/pocketcamera_jp.gb','rb').read(); U=open('/root/work/roms/gbcam_us.gb','rb').read()
z=np.load('/root/work/port/covus/long_a/cov.npz'); dr=z['dr']>0; odr=z['odr']>0
def off(b,a): return b*0x4000+a-(0x4000 if b else 0)
rows=list(csv.DictReader(open('/root/work/repo/roms/jp_rev_a/experiments/unidentified/really_unused.csv',encoding='utf-8')))
print(collections.Counter(r['tier'] for r in rows))
out=[]
for r in rows:
    if r['tier']=='shown': continue
    o=off(int(r['bank'],16),int(r['addr'],16)); n=int(r['bytes']); blk=J[o:o+n]
    f=o if U[o:o+n]==blk else U.find(blk)
    if f<0: st='absent'; rd=ord_=0
    else:
        rd=int(dr[f:f+n].sum()); ord_=int(odr[f:f+n].sum()); st='same address' if f==o else 'moved'
    out.append(dict(r, us=('%02X:%04X'%(f//0x4000,f%0x4000+(0x4000 if f>=0x4000 else 0))) if f>=0 else '', us_status=st, us_read=rd, us_read_org=ord_))
c=collections.Counter((x['tier'],x['us_status'],'read' if x['us_read'] else 'unread') for x in out)
for k,v in sorted(c.items()): print(k,v)
csv.DictWriter(open('/root/work/port/nr/jp_unused_in_us.csv','w',newline='',encoding='utf-8'),fieldnames=list(out[0].keys())).writerows(out)
for x in out:
    if x['us_read'] or x['us_status']=='absent': print(x['bank'],x['addr'],x['bytes'],x['name'][:45],x['tier'],x['us_status'],x['us'],x['us_read'],x['us_read_org'])
