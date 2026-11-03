#!/usr/bin/env python3
"""Render ROM-resident pictures as a labeled contact sheet. usage: render_album.py <rom> <out.png> <start_hex> <count> <stride_hex> [tiles_h]"""
import sys
from PIL import Image,ImageDraw
rom=open(sys.argv[1],'rb').read(); out=sys.argv[2]
start=int(sys.argv[3],16); count=int(sys.argv[4]); stride=int(sys.argv[5],16); th=int(sys.argv[6]) if len(sys.argv)>6 else 16
PAL=[255,170,85,0]
def pic(off,th):
    im=Image.new('L',(128,th*8),255); px=im.load()
    for t in range(16*th):
        for y in range(8):
            b0=rom[off+t*16+y*2]; b1=rom[off+t*16+y*2+1]
            for x in range(8):
                v=((b1>>(7-x))&1)<<1|((b0>>(7-x))&1); px[(t%16)*8+x,(t//16)*8+y]=PAL[v]
    return im
cols=6; sc=1
rows=(count+cols-1)//cols; cw=128*sc+6; ch=th*8*sc+16
sheet=Image.new('L',(cols*cw,rows*ch),230); d=ImageDraw.Draw(sheet)
for i in range(count):
    off=start+i*stride
    im=pic(off,th); x=(i%cols)*cw+3; y=(i//cols)*ch+2
    d.text((x,y),f"#{i+1:02d} @{off:06x}",fill=0); sheet.paste(im,(x,y+12))
sheet.save(out); print(out,sheet.size)
