#!/usr/bin/env python3
"""make_doubts.py [disasm/sym_names_jp.csv] [disasm]  ->  disasm/sym_unconclusive_jp.csv and .md: every `?` name plus the `I` names of the groups that deserve a second look

Per-row overrides: doubts_overrides_jp.csv beside the names csv (bank, addr, status, why, settle).  status `final` = proven unused, the tag stays I because
nothing more can be learnt: the row leaves the open list and goes to sym_settled_unused_jp.csv and the last section of the md (not counted as doubtful).
status `open` = the row stays, with its own why / settle text instead of the group's.  Every override must match a row the groups produce."""
import csv, re, collections, os
import sys
NAMES=sys.argv[1] if len(sys.argv)>1 else 'disasm/sym_names_jp.csv'; OUTDIR=sys.argv[2] if len(sys.argv)>2 else 'disasm'
rows=list(csv.DictReader(open(NAMES,encoding='utf-8')))
SYM=sys.argv[3] if len(sys.argv)>3 else 'pocketcamera_jp.sym'
blk={}                        # (bank,addr) -> length of the block that starts there
try:
    for l in open(SYM):
        p=l.split()
        if len(p)==2 and p[1].startswith('.'):
            b,a=p[0].split(':'); blk[(b.upper(),a.upper())]=int(p[1][1:].split(':')[1],16)
except OSError: pass
nxt={}
_k=sorted((int(r['bank'],16),int(r['addr'],16)) for r in rows)
for i,(b,a) in enumerate(_k):
    e=0x8000 if b else 0x4000
    if i+1<len(_k) and _k[i+1][0]==b: e=_k[i+1][1]
    nxt[('%02X'%b,'%04X'%a)]=blk.get(('%02X'%b,'%04X'%a),e-a)
G=[ # group, regex on name, best guess, why doubtful, what settles it
 ('SFX tag','^Sfx\\d','sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine','tag chosen from the routine that triggers the id (key press, erase, shutter...), not by listening','play the effect id in an emulator and compare with the tag'),
 ('dead code','^Unused_','code or data that no trace path and no table reaches (left over from earlier versions)','never executed in the static trace; purpose read from the instructions only','TCRF note, or a debugger test with a forced jump'),
 ('effect slot','^(Fx\\w*|HotSpotFx\\w*|FxShared\\w*)','effect routine of the bank-0A effect table (96 slots, README 16.28) or helper of a bank-03 hot-spot effect','slot roles inferred from the first instructions, not from the visible screen effect','run each effect id in an emulator and look at the screen'),
 ('mode state','^Mode(01|0E|0F|15|16|18|1A|1C|1D|1F)_','state handler or helper of a screen mode','state purpose read from the data it writes; screen function partly guessed','play the screen in an emulator; match with the TCRF / Funtography screen name'),
 ('keyboard / glyph','^Kb_','character-input page or glyph-set loader','glyph set identity (kana / Latin / symbol page) deduced from tile addresses','view the loaded tiles in a VRAM viewer'),
 ('arrow drawing','DrawArrow','small arrow / cursor sprite or tile drawing routine','direction and owner inferred from the table index','single-step with the cursor on screen'),
 ('main-menu slide','^MainMenu_Slide','slide animation between main-menu pages','slide A/B split by code layout only','watch the menu transition frame by frame'),
 ('Run minigame','^Run_','Run (marathon) mini-game routine or table','role of several state variables guessed','play the game with a watch on the named variables'),
 ('song','^Song','music data of the sound engine','titles come from the TCRF / music lists; which byte is the tempo or the loop point is unchecked','compare with the TCRF sound test'),
]
out=[]
def add(r,group,guess,why,settle):
    if 'Owner (review page' in r['note'] and 'by eye' in r['note']:      # a by-eye answer settles the type, not the role
        why='type confirmed by the owner (review page, by eye); role and consumer not found'
        settle='the role only: the owner naming the picture from the bank image, or a reader caught by a BGB read watchpoint on the span over the organic corpus'
    out.append(dict(bank=r['bank'],addr=r['addr'],name=r['name'],conf=r['conf'],group=group,size=nxt.get((r['bank'],r['addr']),''),best_guess=guess,evidence=r['note'],why_doubtful=why,what_would_settle_it=settle))
for r in rows:
    n=r['name']; c=r['conf']; src=r['source']
    if re.match(r'^Data_[0-9A-F]{2}_[0-9A-F]{4}$',n):
        add(r,'unknown data (no reader found)','small unread data block between assets (padding fragment, tile remainder or unused table)','no pointer, table or sheet covers it','VRAM viewer / read breakpoint in an emulator')
    elif n.endswith('_Aux') or n.endswith('_Unref'):
        kd=n.split('_')[0]
        owner=re.sub(r'_Aux$','',re.sub(r'^\w+?_[0-9A-F]{2}_[0-9A-F]{4}_','',n))
        add(r,'content-classified span','%s data placed next to %s; function = same family as its neighbour'%('tile map' if kd=='Map' else '2bpp tile',owner) if not n.endswith('_Unref') else '%s data with no neighbouring consumer'%('tile map' if kd=='Map' else '2bpp tile'),'type chosen from the bytes (map rows vs tiles), consumer not found','view the bank image, then find the reader with a breakpoint on the bank number write')
    elif c=='?' or ('Owner (review page' in r['note'] and 'by eye' in r['note']):
        if src in ('assets','fix') and '(visual' in r['note']: add(r,'visually identified range',r['note'].split('(visual')[0].strip(' ;,.')[:120],'identified from the picture and the neighbouring assets only; no code reads it directly','check against the Spriters Resource sheet or a VRAM view while the screen runs')
        elif src=='assets': add(r,'far-pointer asset, extent unknown','data loaded through a banked copy helper; length not stated at the load site','end taken as the next pointer or asset','read the copy length at run time (breakpoint on the helper)')
        elif src=='auto': add(r,'auto-named table','table or word list found by pattern; no immediate reference','no code loads it directly (indexed or computed access)','breakpoint on reads of the address')
        else: add(r,'hand name, unconfirmed',r['note'][:90] or 'see name','named from neighbours only','emulator trace')
    elif c=='I':
        for g,p,guess,why,settle in G:
            if re.search(p,n):
                add(r,g,guess,why,settle); break
OV={}
_ovp=os.path.join(os.path.dirname(NAMES) or '.','doubts_overrides_jp.csv')
if os.path.exists(_ovp):
    for o in csv.DictReader(open(_ovp,encoding='utf-8')): OV[(o['bank'],o['addr'])]=o
_have={(x['bank'],x['addr']) for x in out}
_miss=[k for k in OV if k not in _have]
if _miss: sys.exit('doubts_overrides_jp.csv: no doubtful row at %s' % ', '.join('%s:%s' % k for k in _miss))
settled=[]
for x in list(out):
    o=OV.get((x['bank'],x['addr']))
    if not o: continue
    if o['status']=='final':
        out.remove(x); settled.append(dict(x,why_doubtful='',what_would_settle_it='',proof=o['why']))
    elif o['status']=='open':
        if o['why']: x['why_doubtful']=o['why']
        if o['settle']: x['what_would_settle_it']=o['settle']
    else: sys.exit('doubts_overrides_jp.csv: status must be final or open, not %r' % o['status'])
settled.sort(key=lambda x:(x['group'],x['bank'],x['addr']))
_sf=['bank','addr','name','conf','group','size','evidence','proof']
w=csv.DictWriter(open(OUTDIR+'/sym_settled_unused_jp.csv','w',newline='',encoding='utf-8'),fieldnames=_sf,extrasaction='ignore'); w.writeheader(); w.writerows(settled)
out.sort(key=lambda x:(x['group'],x['bank'],x['addr']))
w=csv.DictWriter(open(OUTDIR+'/sym_unconclusive_jp.csv','w',newline='',encoding='utf-8'),fieldnames=list(out[0].keys())); w.writeheader(); w.writerows(out)
g=collections.Counter(x['group'] for x in out); sz=collections.defaultdict(int)
for x in out:
    if x['size']!='': sz[x['group']]+=x['size']
banks=sorted(set(x['bank'] for x in out if x['group'] in('content-classified span','far-pointer asset, extent unknown','unknown data (no reader found)')))
print('banks with unresolved data:',' '.join(banks))
print(len(out), 'open;', len(settled), 'settled as unused'); 
for k,v in g.most_common(): print(k,v,sz.get(k,''))
# ---------------------------------------------------------------- markdown
ORDER=['visually identified range','far-pointer asset, extent unknown','content-classified span','unknown data (no reader found)','auto-named table','hand name, unconfirmed','mode state','effect slot','SFX tag','Run minigame','keyboard / glyph','main-menu slide','arrow drawing','dead code']
ASK={'visually identified range':'a yes/no on the family name',
'far-pointer asset, extent unknown':'where each block ends (the length copied at run time) and what it is',
'content-classified span':'what each span is: look at the bank image, or tell me the screen it belongs to',
'unknown data (no reader found)':'nothing urgent: small leftovers; a VRAM-viewer look would settle them',
'auto-named table':'what the table indexes',
'hand name, unconfirmed':'a check of the guess',
'mode state':'the screen / state names seen in the real game (compare with TCRF or Funtography)',
'effect slot':'which visible effect each slot gives',
'SFX tag':'the sound each id plays',
'Run minigame':'variable roles during play',
'keyboard / glyph':'which glyph page each loader fills',
'main-menu slide':'which transition each slide is',
'arrow drawing':'which cursor / arrow each routine draws',
'dead code':'whether the code or data is truly unused, or for a TCRF graphic the owner\'s check of the match'}
L=[]
L.append('# Unconclusive names of the Pocket Camera (Japan) Rev A symbol file\n')
L.append('Generated from `sym_names_jp.csv` by `tools/make_doubts.py` (companion: `sym_unconclusive_jp.csv`, same rows with evidence and "what would settle it"). It lists every label whose name is a guess I could not settle from the code, the README, the WRAM map, TCRF, the Spriters Resource sheets or the bank pictures, plus the `I` (inferred) names in the groups below that deserve a second look. **Nothing here blocks the disassembly**: the `.sym` is complete (every ROM byte is typed and every routine or table has a name) and builds the exact ROM; the names below are the ones most likely to be renamed later.\n')
L.append('Reading the names: `Gfx_BB_AAAA_*` = 2bpp tile data, `Map_BB_AAAA_*` = tile map rows (32 bytes per row, 20 visible), `Src_BB_AAAA_*` = data loaded through a far pointer whose destination class is not known, `*_Aux` = same family as the neighbouring named asset (consumer not found), `*_Unref` = no neighbouring consumer at all, `Data_BB_AAAA` = small unread block.\n')
L.append('Bank pictures of the unresolved data: `sym_unconclusive_banks/bank_BB.png` (every 2bpp tile of the bank, 32 tiles per row, row label = address of the first tile; grey = typed and named, orange = unreferenced span (name ends `_Aux` / `_Unref`, listed in "content-classified span" unless settled as unused, as the four ball-head frames of bank 16 are), blue = other `?` assets).\n')
L.append('| group | rows | bytes (of the block) | what would help |\n|---|---|---|---|')
for gname in ORDER:
    L.append('| %s | %d | %d | %s |'%(gname,g.get(gname,0),sz.get(gname,0),ASK[gname]))
L.append('')
if settled: L.append('Not counted above: %d rows proven unused, whose tag is final (I for most: the verdict is that nothing uses them, so no run or screen can confirm it; C for the four ball-head frames) (`doubts_overrides_jp.csv`, status `final`); they are listed with the proof in the last section and in `sym_settled_unused_jp.csv`.\n' % len(settled))
for gname in ORDER:
    X=[x for x in out if x['group']==gname]
    if not X: continue
    L.append('## %s (%d)\n'%(gname,len(X)))
    _pair=collections.Counter((x['why_doubtful'],x['what_would_settle_it']) for x in X).most_common(1)[0][0]
    L.append('_Why doubtful:_ %s. _To settle:_ %s.\n'%_pair)
    _odd=[x for x in X if (x['why_doubtful'],x['what_would_settle_it'])!=_pair]
    for x in _odd: L.append('- `%s:%s` instead: _why_ %s; _to settle_ %s.'%(x['bank'],x['addr'],x['why_doubtful'],x['what_would_settle_it']))
    if _odd: L.append('')
    if gname in('unknown data (no reader found)','content-classified span'):
        byb=collections.defaultdict(list)
        for x in X: byb[x['bank']].append(x)
        for b in sorted(byb):
            L.append('- bank %s: '%b+', '.join('`%s`%s'%(x['addr'],(' %d B'%x['size']) if x['size']!='' else '') if gname.startswith('unknown') else '`%s` %s (%s B)'%(x['addr'],x['name'].split('_',3)[-1] if x['name'].count('_')>=3 else x['name'],x['size']) for x in byb[b]))
        L.append('')
    else:
        L.append('| address | name | bytes | best guess | evidence |\n|---|---|---|---|---|')
        for x in X:
            L.append('| %s:%s | `%s` | %s | %s | %s |'%(x['bank'],x['addr'],x['name'],x['size'],x['best_guess'].replace('|','/'),x['evidence'].replace('|','/')[:110]))
        L.append('')
if settled:
    L.append('## settled as unused, final I (%d)\n' % len(settled))
    L.append('_Why not doubtful:_ the name and the kind are not in question and no reader can exist; nothing more can be learnt about them.\n')
    L.append('| address | name | bytes | group it left | proof |\n|---|---|---|---|---|')
    for x in settled:
        L.append('| %s:%s | `%s` | %s | %s | %s |'%(x['bank'],x['addr'],x['name'],x['size'],x['group'],x['proof'].replace('|','/')))
    L.append('')
open(OUTDIR+'/sym_unconclusive_jp.md','w',encoding='utf-8').write('\n'.join(L))
print('md lines',len(L))
