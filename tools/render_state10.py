#!/usr/bin/env python3
"""Compose the Bank004_State10 screen (album 'erase all?' confirmation), BG layer only.
usage: render_state10.py ROM SAV OUT.png [scale]"""
import sys
from PIL import Image
rom=open(sys.argv[1],'rb').read(); sav=open(sys.argv[2],'rb').read()
scale=int(sys.argv[4]) if len(sys.argv)>4 else 3
def R(bank,addr,n): o=bank*0x4000+addr-0x4000; return bytearray(rom[o:o+n])
vram=bytearray(0x1800)                      # $8000-$97FF
vram[0:0x1000]=R(0x13,0x5800,0x1000)        # Bank004_State00: base UI tiles
vram[0x700:0x800]=bytes(0x100)              # State10: clear $8700-$87FF
vram[0xB00:0xC00]=R(0x13,0x6800,0x100)      # Call_004_44bd ($d5d7=0)
vram[0xDF0:0xE00]=R(0x13,0x5830,16)         # Call_004_44f1 ($d5d8=0)
vram[0xDE0:0xDF0]=R(0x13,0x5800,16)
vram[0x800:0xA80]=R(0x19,0x7560,0x280)      # State10: message strip  (text)
vram[0x080:0x680]=R(0x19,0x77e0,0x600)      # State10: replaced art at $8080
# thumbnails: rank -> slot via state vector $011B2 (30 bytes, value=rank, FF=empty)
vec=sav[0x11B2:0x11B2+30]
ranks={v:s for s,v in enumerate(vec) if v!=0xFF}
for r in range(8):
    base=0x1000+r*0x100
    if r in ranks:
        o=0x2000+ranks[r]*0x1000+0xE00
        vram[base:base+0x100]=sav[o:o+0x100]
    else: vram[base:base+0x100]=bytes(0x100)
m=R(0x24,0x54c0,0x240)
pal=[255,170,85,0]
def tile(idx):
    # LCDC.4=0 : ids 0-127 -> $9000, 128-255 -> $8800
    a=0x1000+idx*16 if idx<128 else 0x800+(idx-128)*16
    return vram[a:a+16]
im=Image.new('L',(160,144),255)
for ty in range(18):
    for tx in range(20):
        d=tile(m[ty*32+tx])
        for y in range(8):
            lo,hi=d[2*y],d[2*y+1]
            for x in range(8):
                b=7-x; im.putpixel((tx*8+x,ty*8+y),pal[((lo>>b)&1)|(((hi>>b)&1)<<1)])
im.resize((160*scale,144*scale),Image.NEAREST).save(sys.argv[3])
print('photos in save:',len(ranks))
