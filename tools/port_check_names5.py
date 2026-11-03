#!/usr/bin/env python3
"""L3 pass 5: picture / map / source blocks left at I, placed by this build's own copies and pointer tables (static, no coverage).

  tools/port_check_names5.py TREE SUFFIX ROM [--dry]

Copies: every traced `call` / `jp` to a copy routine (Mem_Copy*, Vram_Copy*, Vram_Fill*, Mem_Fill*, Lcd_Copy*, Tiles_Copy*, Copy*) whose A (bank),
HL (source, $4000-$7FFF) and BC (length) were loaded with constants earlier in the same straight-line run gives an extent {bank, source, length, routine}.
Tables: a `dwb LABEL` line inside a table names the block as entry N of that table (N = the line's index among the table's dwb lines).
Rules (C), for a name still at I (after pass 4 and the hand layer):
  copy-loader   the routine in the block's name is one of the routines whose copy covers the block's first byte: the name holds
  copy-relabel  exactly one routine's copies cover it, another one than the name says: renamed <Kind>_BB_AAAA_<routine>, the old name in the note
  entry         a name numbered after a Japanese table (..._TblNNNN_<n>) whose block is entry N of exactly one pointer table here: renamed <Kind>_BB_AAAA_<table>_<N>
  copy-descr    a descriptive name (its tail is no label of this build and no Japanese table number) whose block a copy here holds: kept, C, the copying routines in the note
Rows go to <TREE>/disasm/sym_names_<s>_checked.csv with source 'checked5: ...' (earlier pass-5 rows replaced; written before the hand layer, which wins).
"""
import sys, os, re, csv, json, bisect, collections, glob
args = sys.argv[1:]; dry = '--dry' in args; args = [x for x in args if x != '--dry']
T, S, ROMF = args[0].rstrip('/'), args[1], args[2]; R = open(ROMF, 'rb').read(); D = T + '/disasm/'
def flat(b, a): return a if b == 0 else b * 0x4000 + a - 0x4000
names = {}
for suf in ('', '_loaders', '_reads', '_checked', '_hand'):
    p = D + 'sym_names_%s%s.csv' % (S, suf)
    if not os.path.exists(p): continue
    for r in csv.DictReader(open(p, encoding='utf-8')):
        if re.search(r'checked[56]: ', r.get('source', '')): continue       # pass 4's decisions stand (run after it)
        k = (int(r['bank'], 16), int(r['addr'], 16))
        if r['name'] == '-': names.pop(k, None)
        else: names[k] = r
byname = {r['name']: k for k, r in names.items()}
labs = sorted((flat(*k), r['name']) for k, r in names.items()); keys = [x for x, _ in labs]
def owner(o): i = bisect.bisect_right(keys, o) - 1; return labs[i][1]
copaddr = {byname[n][1] for n in byname if re.match(r'(Mem_Copy|Vram_Copy|Vram_Fill|Mem_Fill|Lcd_Copy|Tiles_Copy|Copy)', n) and byname[n][0] == 0}
tr = json.load(open('%s/port/trace_%s.json' % (T, S)))['code']
bybank = collections.defaultdict(list)
for k, n in tr.items():
    if n > 0: b, a = k.split(':'); bybank[int(b, 16)].append((int(a, 16), n))
ext = []
for b, L in bybank.items():
    reg = {}
    for a, n in sorted(L):
        o = flat(b, a); op = R[o]
        if op == 0x3E: reg['a'] = R[o + 1]
        elif op == 0x21: reg['hl'] = R[o + 1] | R[o + 2] << 8
        elif op == 0x11: reg['de'] = R[o + 1] | R[o + 2] << 8
        elif op == 0x01: reg['bc'] = R[o + 1] | R[o + 2] << 8
        elif op in (0xCD, 0xC3):
            t = R[o + 1] | R[o + 2] << 8
            if t in copaddr and all(x in reg for x in ('a', 'hl', 'bc')) and 0x4000 <= reg['hl'] < 0x8000: ext.append((reg['a'] & 0x3F, reg['hl'], reg['bc'], owner(o)))
            reg = {}
        elif op in (0xC9, 0x18, 0xE9) or (op & 0xC7) == 0xC7: reg = {}
        elif op in (0x09, 0x19, 0x29, 0x39, 0x23, 0x2B, 0x2A, 0x3A, 0xE5, 0xE1): reg.pop('hl', None)     # hl changed: no constant source any more
# pointer tables: dwb lines in the listing, per enclosing label
LAB = re.compile(r'^([A-Za-z_][A-Za-z0-9_]*)::')
SYMADDR = {}                                   # the listing's current labels -> address (the listing may carry names of an earlier pass)
for f in glob.glob('%s/*.sym' % T):
    for l in open(f):
        p_ = l.split()
        if len(p_) == 2 and ':' in p_[0]: SYMADDR[p_[1]] = (int(p_[0][:2], 16), int(p_[0][3:], 16))
entries = collections.defaultdict(list)
for f in sorted(glob.glob('%s/src/bank_*.asm' % T)):
    cur = None; idx = 0
    for line in open(f, encoding='utf-8'):
        m = LAB.match(line)
        if m: cur = m.group(1); idx = 0; continue
        mm = re.match(r'\s+dwb\s+([A-Za-z_][A-Za-z0-9_]*)\s*(;|$)', line)
        if mm and cur:
            if mm.group(1) in SYMADDR: entries[SYMADDR[mm.group(1)]].append((cur, idx))
            idx += 1
ROUTINES = {r['name'] for k, r in names.items() if '%02X:%04X' % k in {x.upper() for x in tr} or '%02x:%04x' % k in tr}
taken = set(byname); out = []; cnt = collections.Counter()
for (b, a), r in sorted(names.items()):
    if r['conf'] != 'I': continue
    n = r['name']; m = re.match(r'(Gfx|Map|Src)_([0-9A-F]{2})_([0-9A-F]{4})_(.+?)(_Part[0-9A-F]{4}|_Cont|_Aux|_HeadRows|_ExtraRows?)?$', n)
    if not m: continue
    cov = sorted({e[3] for e in ext if e[0] == b and e[1] <= a < e[1] + e[2]}); why = None; nn = None
    tail_is_routine = m.group(4) in ROUTINES
    if re.search(r'_Tbl[0-9A-F]{4}_\d+$', n) and (b, a) in entries and len({t for t, _ in entries[(b, a)]}) == 1:
        t, i = entries[(b, a)][0]; base = re.sub(r'_(Tbl|Map|PtrTbl)[0-9A-F]{4}$', '', t)
        nn = '%s_%s_%s_%s_%d' % (m.group(1), m.group(2), m.group(3), base, i)
        why = 'entry', 'entry %d of the pointer table %s here; the earlier name %s numbered it after a Japanese table' % (i, t, n)
    elif m.group(4) in cov: why = 'copy-loader', '%s copies a range that holds this block (%s)' % (m.group(4), ', '.join(cov))
    elif cov and m.group(4) not in byname and not re.search(r'Tbl[0-9A-F]{4}_\d+$', m.group(4)):
        why = 'copy-descr', 'copied here by %s; the descriptive name is kept' % ', '.join(cov)
    elif len(cov) == 1:
        nn = '%s_%s_%s_%s%s' % (m.group(1), m.group(2), m.group(3), cov[0], m.group(5) or '')
        why = 'copy-relabel', 'the only routine whose copies hold this block here is %s; the earlier name %s' % (cov[0], n)
    if why:
        if nn and nn in taken: continue
        if nn: taken.add(nn)
        cnt[why[0]] += 1
        out.append(['%02x' % b, '%04x' % a, nn or n, 'C', (r['note'] + '; ' if r['note'] else '') + 'L3 ' + why[0] + ': ' + why[1], 'checked5: ' + r.get('source', '')])
print(dict(cnt), '| copy extents found:', len(ext))
if dry:
    for x in out: print('  ', x[0] + ':' + x[1], x[2], '|', x[4][-140:])
else:
    p = D + 'sym_names_%s_checked.csv' % S; keep = [l for l in open(p, encoding='utf-8') if 'checked5: ' not in l]
    open(p, 'w', encoding='utf-8').write(''.join(keep))
    with open(p, 'a', newline='', encoding='utf-8') as fh: csv.writer(fh, lineterminator='\n').writerows(out)
