#!/usr/bin/env python3
"""Hello Kitty ROM: draw the never-read sprite layouts (assets/sprite_layouts_unread_kitty.csv) with the tiles of a screen (step 6 of the
unused-asset pass). Writes assets/sprite_layouts_unread_kitty.png and assets/sprite_layouts_drawn_kitty.csv (layout, screen, how).

  tools/kitty_draw_layouts.py

A layout is drawn as Obj_DrawSprite does: entries {dy, dx, tile, attributes} (X / Y flip from bits 5 / 6), 8 x 16 objects when LCDC bit 2
is set on that screen, colour 0 transparent. The screen: the screens on which the read layouts just before and after it in bank $03 are
first read (port/layout_screens_kitty.csv, tools/kitty_layout_screens.py) when BGB VRAM of that screen exists (port/vram_screens_kitty.npz,
tools/kitty_vram_screens.py), the one whose tiles are all non-blank with the smallest seam break between side-by-side objects ("neighbour");
otherwise the best such fit over every screen ("best fit"). Evidence I: the right tile set is a guess; a layout that draws as a picture or as
text is a strong hint, one that draws as noise had the wrong tiles.
"""
import numpy as np,csv,sys
from PIL import Image,ImageDraw
import os
REPO=os.path.dirname(os.path.dirname(os.path.abspath(__file__))); KD=os.path.join(REPO,'roms','hello_kitty')
d=open(os.environ.get('KITTY_ROM','/root/work/roms/pocketcamera_kitty.gb'),'rb').read()
V=np.load(os.path.join(KD,'port','vram_screens_kitty.npz'))
SCR=sorted(k for k in V.files if not k.startswith(('lcdc_','oam_')))
def entries(a):
    o=3*0x4000+a-0x4000; E=[]
    for n in range(40):
        dy,dx,t,at=d[o+4*n:o+4*n+4]; E.append((dy-256 if dy>127 else dy,dx-256 if dx>127 else dx,t,at))
        if at&1: break
    return E
def tilepix(vr,t):
    b=vr[t*16:t*16+16]; P=np.zeros((8,8),np.uint8)
    for r in range(8):
        lo,hi=b[2*r],b[2*r+1]
        for c in range(8): P[r,c]=((lo>>(7-c))&1)|(((hi>>(7-c))&1)<<1)
    return P
def draw(a,vr,tall=True):
    E=entries(a); ys=[e[0] for e in E]; xs=[e[1] for e in E]
    y0,x0=min(ys),min(xs); H=max(ys)-y0+(16 if tall else 8); W=max(xs)-x0+8
    can=np.zeros((max(H,1),max(W,1)),np.int16)-1
    for dy,dx,t,at in E:
        tiles=[t&0xFE,t|1] if tall else [t]
        for k,tt in enumerate(tiles):
            P=tilepix(vr,tt)
            if at&0x20: P=P[:,::-1]
            if at&0x40: P=P[::-1,:]
            y=dy-y0+8*k; x=dx-x0
            if at&0x40 and tall: y=dy-y0+8*(1-k)
            m=P>0; sub=can[y:y+8,x:x+8]; sub[m[:sub.shape[0],:sub.shape[1]]]=P[:sub.shape[0],:sub.shape[1]][m[:sub.shape[0],:sub.shape[1]]]
    return can
def score(can):
    filled=(can>=0).sum()
    return filled
PAL={-1:(232,232,240),0:(255,255,255),1:(170,170,170),2:(85,85,85),3:(0,0,0)}
def toimg(can,S=2):
    im=Image.new('RGB',(can.shape[1],can.shape[0])); px=im.load()
    for y in range(can.shape[0]):
        for x in range(can.shape[1]): px[x,y]=PAL[int(can[y,x])]
    return im.resize((im.width*S,im.height*S),Image.NEAREST)
def fit(a,s):
    vr=V[s]; tall=bool(int(V['lcdc_'+s][0])&4); E=entries(a)
    tiles=[]
    for dy,dx,t,at in E: tiles+= [t&0xFE,t|1] if tall else [t]
    ne=sum(1 for t in tiles if vr[t*16:t*16+16].any())/max(len(tiles),1)
    # seam: horizontally adjacent sprites at the same dy
    can=draw(a,vr,tall); seam=0; cnt=0
    pos={(dy,dx) for dy,dx,_,_ in E}
    for dy,dx in pos:
        if (dy,dx+8) in pos:
            y=dy-min(e[0] for e in E); x=dx-min(e[1] for e in E)
            h=16 if tall else 8
            L=can[y:y+h,x+7]; R=can[y:y+h,x+8]
            seam+=int(((L>=1)!=(R>=1)).sum()); cnt+=h
    return ne, (seam/cnt if cnt else 0.5)

import csv,bisect,collections
from PIL import ImageFont
S={int(r['layout'][3:],16):r['next_screens'].split() for r in csv.DictReader(open(os.path.join(KD,'port','layout_screens_kitty.csv')))}
K=sorted(S)
R=list(csv.DictReader(open(os.path.join(KD,'assets','sprite_layouts_unread_kitty.csv'))))
assign={}
for r in R:
    a=int(r['layout'][3:],16); i=bisect.bisect_left(K,a); cands=[]
    for j in (i-1,i):
        if 0<=j<len(K): cands+=[s.replace(':','_') for s in S[K[j]] if not s.startswith('1E')]
    cands=[c for c in dict.fromkeys(cands) if c in SCR]
    how='neighbour' if cands else 'best fit'
    pool=cands or SCR
    assign[r['layout']]=(sorted(pool,key=lambda s:(-fit(a,s)[0],fit(a,s)[1],s))[0],how)
with open(os.path.join(KD,'assets','sprite_layouts_drawn_kitty.csv'),'w',newline='') as f:
    w=csv.writer(f,lineterminator='\n'); w.writerow(['layout','screen','how'])
    for k in sorted(assign): w.writerow([k,assign[k][0].replace('_',':'),assign[k][1]])
by=collections.defaultdict(list)
for k,(s,h) in assign.items(): by[s].append(k)
F=ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf',10)
Wmax=1400; blocks=[]
for s,L in sorted(by.items(),key=lambda x:(-len(x[1]),x[0])):
    ims=[]
    for k in sorted(L):
        a=int(k[3:],16); can=draw(a,V[s],bool(int(V['lcdc_'+s][0])&4))[:160,:200]; ims.append((k,toimg(can,2)))
    lines=[];cur=[];wd=0
    for k,i in ims:
        if wd+i.width+8>Wmax: lines.append(cur); cur=[]; wd=0
        cur.append((k,i)); wd+=i.width+8
    if cur: lines.append(cur)
    blocks.append((s,lines))
H=sum(18+sum(max(i.height for _,i in l)+14 for l in ls) for _,ls in blocks)
out=Image.new('RGB',(Wmax,H),'white'); dr=ImageDraw.Draw(out); y=0
for s,ls in blocks:
    dr.text((4,y+2),'tiles of screen %s (BGB VRAM)'%s.replace('_',':'),fill='black',font=F); y+=18
    for l in ls:
        x=0
        for k,i in l: dr.text((x,y),k,fill=(80,80,80),font=F); out.paste(i,(x,y+12)); x+=i.width+8
        y+=max(i.height for _,i in l)+14
out.save(os.path.join(KD,'assets','sprite_layouts_unread_kitty.png'))
c=collections.Counter(h for _,h in assign.values())
print('kitty_draw_layouts: %d layouts drawn (%d by neighbour, %d by best fit) on %d screens' % (len(assign),c['neighbour'],c['best fit'],len(by)))
