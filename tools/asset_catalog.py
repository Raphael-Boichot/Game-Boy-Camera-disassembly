#!/usr/bin/env python3
"""Catalog every banked copy (CopyBanked / CopyBankedVRAM) call in the mgbdis disassembly:
   A=bank, HL=src, DE=dst, BC=len  ->  assets.csv   (usage: asset_catalog.py <disasm_dir> <out.csv>)"""
import re,sys,glob,csv,os
disasm=sys.argv[1]; out=sys.argv[2]
# helper entry labels (JP addresses; pass --intl for 0473/…)
COPY=set(sys.argv[3].split(',')) if len(sys.argv)>3 else {'Call_000_0450','Jump_000_0450','Call_000_0586'}
rows=[]
imm=lambda s:int(s.replace('$',''),16)
for fn in sorted(glob.glob(os.path.join(disasm,'bank_*.asm'))):
    bank=int(re.search(r'bank_([0-9a-f]+)\.asm',fn).group(1),16)
    L=[l.rstrip() for l in open(fn,encoding='utf-8',errors='replace')]
    label=''
    for i,l in enumerate(L):
        m=re.match(r'^([A-Za-z_][A-Za-z0-9_]*)::?$',l)
        if m: label=m.group(1)
        m=re.match(r'\s+(call|jp) (\S+)$',l)
        if not m or m.group(2) not in COPY: continue
        vals={}
        for j in range(i-1,max(i-12,0),-1):
            t=L[j].strip()
            if t.endswith(':') : break
            for reg,pat in (('a',r'ld a, (\$[0-9a-f]+)$'),('hl',r'ld hl, (\$[0-9a-f]+)$'),('de',r'ld de, (\$[0-9a-f]+)$'),('bc',r'ld bc, (\$[0-9a-f]+)$')):
                mm=re.match(pat,t)
                if mm and reg not in vals: vals[reg]=imm(mm.group(1))
        if len(vals)==4:
            rows.append(dict(caller_bank=f'{bank:02x}',caller_label=label,src_bank=f"{vals['a']:02x}",src=f"{vals['hl']:04x}",
                             dst=f"{vals['de']:04x}",length=f"{vals['bc']:04x}",
                             file_offset=f"{(vals['a']*0x4000+(vals['hl']-0x4000)) if vals['hl']>=0x4000 and vals['hl']<0x8000 else -1:x}"))
with open(out,'w',newline='') as f:
    w=csv.DictWriter(f,fieldnames=list(rows[0].keys())); w.writeheader(); w.writerows(rows)
print("catalog rows:",len(rows),"| unique (bank,src,len):",len({(r['src_bank'],r['src'],r['length']) for r in rows}))
