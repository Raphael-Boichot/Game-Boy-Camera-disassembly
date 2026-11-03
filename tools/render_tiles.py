#!/usr/bin/env python3
"""Render 2bpp GB tile data from the ROM. usage: render_tiles.py <rom> <catalog.csv> <outdir>"""
import sys,csv,os
from PIL import Image
rom=open(sys.argv[1],'rb').read(); cat=list(csv.DictReader(open(sys.argv[2]))); out=sys.argv[3]
os.makedirs(out,exist_ok=True)
PAL=[255,170,85,0]
def render(data,cols=16,scale=3):
    n=len(data)//16; rows=(n+cols-1)//cols
    im=Image.new('L',(cols*8,rows*8),255)
    px=im.load()
    for t in range(n):
        for y in range(8):
            b0=data[t*16+y*2]; b1=data[t*16+y*2+1]
            for x in range(8):
                v=((b1>>(7-x))&1)<<1|((b0>>(7-x))&1)
                px[(t%cols)*8+x,(t//cols)*8+y]=PAL[v]
    return im.resize((im.width*scale,im.height*scale),Image.NEAREST)
seen=set(); index=[]
for r in cat:
    d=int(r['dst'],16); src=int(r['src'],16); ln=int(r['length'],16); bank=int(r['src_bank'],16)
    if not(0x8000<=d<0x9800) or ln%16 or src>=0x8000: continue
    key=(bank,src,ln)
    if key in seen: continue
    seen.add(key)
    off=bank*0x4000+(src-0x4000) if src>=0x4000 else src
    im=render(rom[off:off+ln]); name=f"tiles_{bank:02x}_{src:04x}_{ln:04x}.png"
    im.save(os.path.join(out,name)); index.append((name,bank,src,ln,d,r['caller_bank']))
print("rendered",len(index),"tile sets")
with open(os.path.join(out,'INDEX.txt'),'w') as f:
    for x in sorted(index,key=lambda z:(z[1],z[2])): f.write("%s  bank=%02x src=$%04x len=$%04x -> vram $%04x (called from bank %s)\n"%x)
