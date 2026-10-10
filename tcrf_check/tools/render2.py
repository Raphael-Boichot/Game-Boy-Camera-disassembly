"""Minimal DMG screen renderer for the gbcov cores (background + window + sprites, no mid-frame effects). Usage: render2.screen(g) -> 144x160 uint8 RGB-ish grey image; render2.save(g, path, scale)"""
import numpy as np
from PIL import Image
PAL=np.array([255,170,85,0],dtype=np.uint8)
def _tiles(v):
    a=np.frombuffer(bytes(v[:0x1800]),dtype=np.uint8).reshape(384,8,2)
    lo=a[:,:,0]; hi=a[:,:,1]
    t=np.zeros((384,8,8),dtype=np.uint8)
    for x in range(8): t[:,:,x]=((lo>>(7-x))&1)|(((hi>>(7-x))&1)<<1)
    return t
def screen(g):
    v=bytes(g.peek(0x8000+i) for i in range(0x2000)); T=_tiles(v)
    lcdc=g.peek(0xFF40); scx=g.peek(0xFF43); scy=g.peek(0xFF42); bgp=g.peek(0xFF47); wx=g.peek(0xFF4B); wy=g.peek(0xFF4A)
    def layer(mapbase):
        m=np.frombuffer(v[mapbase-0x8000:mapbase-0x8000+1024],dtype=np.uint8).reshape(32,32)
        img=np.zeros((256,256),dtype=np.uint8)
        for ty in range(32):
            for tx in range(32):
                n=int(m[ty,tx]); idx=n if (lcdc&0x10) else 256+(n-256 if n>=128 else n)
                img[ty*8:ty*8+8,tx*8:tx*8+8]=T[idx]
        return img
    out=np.zeros((144,160),dtype=np.uint8)
    if lcdc&1:
        bg=layer(0x9C00 if lcdc&8 else 0x9800)
        out=bg[np.ix_((np.arange(144)+scy)%256,(np.arange(160)+scx)%256)]
    if lcdc&0x20 and wy<144:
        wm=layer(0x9C00 if lcdc&0x40 else 0x9800)
        for y in range(wy,144):
            for x in range(max(wx-7,0),160): out[y,x]=wm[y-wy,x-(wx-7)]
    pal=[(bgp>>(2*i))&3 for i in range(4)]
    out=np.array(pal,dtype=np.uint8)[out]
    if lcdc&2:
        obp0=g.peek(0xFF48); obp1=g.peek(0xFF49); h=16 if lcdc&4 else 8
        oam=[g.peek(0xFE00+i) for i in range(160)]
        for s in range(39,-1,-1):
            y,x,n,a=oam[s*4:s*4+4]; y-=16; x-=8
            if h==16: n&=0xFE
            p=obp1 if a&0x10 else obp0
            for r in range(h):
                for c in range(8):
                    yy=y+r; xx=x+c
                    if 0<=yy<144 and 0<=xx<160:
                        rr=(h-1-r) if a&0x40 else r; cc=(7-c) if a&0x20 else c
                        px=T[n+(rr//8)][rr%8][cc]
                        if px: out[yy,xx]=(p>>(2*px))&3
    return PAL[out]
def save(g,path,scale=3):
    Image.fromarray(screen(g)).resize((160*scale,144*scale),Image.NEAREST).save(path)
def montage(imgs,cols,scale=2,pad=4):
    rows=(len(imgs)+cols-1)//cols; W=160*scale; H=144*scale
    M=Image.new('L',(cols*(W+pad)+pad,rows*(H+pad)+pad),128)
    for i,im in enumerate(imgs):
        M.paste(Image.fromarray(im).resize((W,H),Image.NEAREST),(pad+(i%cols)*(W+pad),pad+(i//cols)*(H+pad)))
    return M
