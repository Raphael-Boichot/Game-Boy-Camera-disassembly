#!/usr/bin/env python3
"""Census of WRAM ($C000-$DFFF) and HRAM ($FF80-$FFFE) usage in an mgbdis disassembly.
usage: ram_census.py <disasm_dir> <out.csv>"""
import re,sys,glob,os,csv,collections
d=sys.argv[1]; out=sys.argv[2]
ins=re.compile(r'^\s+(ld|ldh|inc|dec|cp|add|adc|sub|sbc|and|or|xor|bit|set|res|swap|sla|sra|srl|rl|rr|rlc|rrc)\b\s*(.*)$')
addr=re.compile(r'\$(c[0-9a-f]{3}|d[0-9a-f]{3}|ff[89a-f][0-9a-f])\b')
st=collections.defaultdict(lambda: dict(read=0,write=0,rmw=0,ptr=0,banks=collections.Counter()))
for fn in sorted(glob.glob(os.path.join(d,'bank_*.asm'))):
    bank=re.search(r'bank_([0-9a-f]+)',fn).group(1)
    for l in open(fn,encoding='utf-8',errors='replace'):
        m=ins.match(l.rstrip())
        if not m: continue
        op,args=m.groups()
        for a in addr.findall(args):
            a=int(a,16); s=st[a]; s['banks'][bank]+=1
            if '[$' in args:
                if op in('ld','ldh'):
                    # destination first
                    if args.strip().startswith('['): s['write']+=1
                    else: s['read']+=1
                elif op in('inc','dec','bit','set','res','swap','sla','sra','srl','rl','rr','rlc','rrc'):
                    s['rmw' if op not in('bit',) else 'read']+=1
                else: s['read']+=1
            elif op=='ld': s['ptr']+=1
with open(out,'w',newline='') as f:
    w=csv.writer(f); w.writerow(['address','region','reads','writes','rmw','as_pointer','n_banks','banks_top'])
    for a in sorted(st):
        s=st[a]; reg='HRAM' if a>=0xff80 else 'WRAM'
        w.writerow([f'{a:04x}',reg,s['read'],s['write'],s['rmw'],s['ptr'],len(s['banks']),' '.join(f'{b}:{c}' for b,c in s['banks'].most_common(4))])
print("distinct RAM addresses referenced:",len(st))
