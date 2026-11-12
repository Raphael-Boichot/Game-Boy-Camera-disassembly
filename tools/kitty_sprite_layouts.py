#!/usr/bin/env python3
"""Hello Kitty ROM: the sprite layouts of bank $03 that no run read, and what points at them (unused-asset pass, step 6).

  tools/kitty_sprite_layouts.py        (run from the repository root; reads /root/work/roms/pocketcamera_kitty.gb or $KITTY_ROM)

Obj_DrawSprite (00:219C) reads a layout as 4-byte entries {dy, dx, tile, attributes} up to the entry whose attribute byte has bit 0 set.
Bank $03 is cut into layouts by that rule; a layout counts as never read when none of its bytes is read in the runs (core corpora,
core key paths, BGB). For each one, every 16-bit word of banks $00-$07 equal to its address is listed (r = the word is read in a run,
x = inside traced code) and the layout is classed: read-ref (a word that a run read points at it), code-ref (only words inside code),
unread-data-ref (only words in data no run read: object scripts of bank $02 that did not run), none. Words are value matches: a class
is a lead, not a proof. Writes roms/hello_kitty/assets/sprite_layouts_unread_kitty.csv.
"""
import re,collections,bisect,csv,json,sys
import numpy as np
import os
d=open(os.environ.get('KITTY_ROM','/root/work/roms/pocketcamera_kitty.gb'),'rb').read()
def off(b,a): return a if b==0 else b*0x4000+a-0x4000
z=np.load('roms/hello_kitty/trace/cov_kitty_runs.npz'); p=np.load('roms/hello_kitty/trace/cov_kitty_paths.npz'); bg=np.load('roms/hello_kitty/trace/cov_kitty_bgb.npz')
rd=(z['dr']>0)|(p['dr']>0)|(bg['dr']>0)
T=json.load(open('roms/hello_kitty/trace/trace_kitty.json')); code=set()
for r in csv.DictReader(open('roms/hello_kitty/trace/rom_map_kitty.csv')):
    if r['class']=='C':
        o=off(int(r['bank'],16),int(r['start'],16)); code.update(range(o,o+int(r['length'])))
B=3; o3=off(B,0x4000)
# parse bank 3 into layouts: from every read layout start? Simpler: walk bank, chunk by terminator
lay=[]; a=0x4000
while a<0x8000-3:
    s=a; n=0
    while a<0x8000-3:
        attr=d[o3+a-0x4000+3]; a+=4; n+=1
        if attr&1 or n>40: break
    lay.append((s,n))
# references: 16-bit words equal to the layout start in banks 0-7 (code immediates and data)
W=collections.defaultdict(list)
for bank in range(8):
    base=off(bank,0x4000) if bank else 0
    for i in range(base,base+0x4000-1):
        W[d[i]|d[i+1]<<8].append(i)
rows=[]
for s,n in lay:
    o=o3+s-0x4000
    if rd[o:o+4*n].any(): continue
    refs=W.get(s,[])
    rr=['%02X:%04X%s'%(i//0x4000,i%0x4000+(0x4000 if i>=0x4000 else 0),'r' if rd[i] else ('x' if i in code else '')) for i in refs]
    rows.append((s,n,rr))
print('layouts parsed',len(lay),'never read',len(rows),'bytes',sum(4*n for _,n,_ in rows))
c=collections.Counter('none' if not r else ('read-ref' if any(x.endswith('r') for x in r) else ('code-ref' if any(x.endswith('x') for x in r) else 'other')) for _,_,r in rows)
print(c)
out='roms/hello_kitty/assets/sprite_layouts_unread_kitty.csv'
with open(out,'w',newline='') as f:
    w=csv.writer(f,lineterminator='\n'); w.writerow(['layout','entries','bytes','class','words_equal_to_its_address'])
    for s,n,r in rows:
        cl='none' if not r else ('read-ref' if any(x.endswith('r') for x in r) else ('code-ref' if any(x.endswith('x') for x in r) else 'unread-data-ref'))
        w.writerow(['03:%04X'%s,n,4*n,cl,' '.join(r[:12])])
