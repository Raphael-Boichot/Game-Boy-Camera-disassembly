#!/usr/bin/env python3
"""L3 pass 4 of the checked layer: the names still at I in a ported build, checked against how this build's own code uses them.

  tools/port_check_names4.py TREE SUFFIX COV.npz [COV.npz ...] [--dry]      (PORT_ROM = the build's ROM; default /root/work/roms/gbcam_<...>.gb)

TREE is roms/<folder> (its src/ listing must be fresh: tools/make_source.py); the Japanese listing is roms/jp_rev_a/src/.  COV = coverage states with the
read-site arrays (GBCAM_SITE_ALL=1 runs: 'dr', 'site', 'site2').  The name layers are merged as the build does; rows go to
<TREE>/disasm/sym_names_<s>_checked.csv (appended; a later row of the same address replaces an earlier one in the merge).
A "reader" is the routine label that contains an instruction (or a pointer table entry) naming the label in the listing.
Rules, in this order (C when one holds); names that describe the picture itself (Sheet_, Font_, StampCat, WildFrame, TileGap, *Jpn*) are left to a review by eye:
  dispatch ModeNN_StateTable: Mode_Table entry NN points just before it and the table follows ld a,[wState] / rst $18; Mode_Table: every entry points to a ModeNN_ label
  same     the readers of the name here are the readers of the same name in the Japanese listing (auto table suffixes such as _Tbl5E21 / _Tbl5DF1
           compared without their address), and at least one exists: the same code uses it, the role holds
  owner    the name is <Routine>_<suffix> (an auto table / list name) and <Routine> is one of its readers here
  module   a non-picture name Mod_xxx read (>= 90 % of its read bytes, coverage, interrupt / main loop / boot excluded; else the listing) by a routine of the same module Mod_
  unref    an Unused_* / *_Dead / UNREFERENCED name with no reader here other than other unused routines: the claim "nothing uses it" holds
  loader   a Gfx_/Map_/Src_ name whose routine part (a label on traced code; descriptive tails such as FontSlotA1 claim no loader) is one of its readers here (static) or reads at least 90 % of its read bytes (coverage)
  relabel  a Gfx_/Map_ block named after a routine, that is read here by one other routine only (static, or >= 90 % of the read bytes in the coverage, interrupt /
           main loop / boot excluded): renamed Gfx_BB_AAAA_<that routine> (C), the Japanese name kept in the note
The rest stay I; tools/port_settled.py lists them in <TREE>/disasm/sym_settled_unused_<s>.csv.
"""
import sys, csv, re, glob, bisect, collections, os
import numpy as np
args = sys.argv[1:]; dry = '--dry' in args; args = [x for x in args if x != '--dry']
T, S, COVS = args[0].rstrip('/'), args[1], args[2:]
D = T + '/disasm/'
def flat(b, a): return a if b == 0 else b * 0x4000 + a - 0x4000
names = {}
for suf in ('', '_loaders', '_reads', '_checked', '_hand'):
    p = D + 'layers/sym_names_%s%s.csv' % (S, suf or '_port')
    if not os.path.exists(p): continue
    for r in csv.DictReader(open(p, encoding='utf-8')):
        if re.search(r'checked[456]: ', r.get('source', '')): continue        # passes 4-6 decide from the same base (run 4, then 5)
        k = (int(r['bank'], 16), int(r['addr'], 16))
        if r['name'] == '-': names.pop(k, None)
        else: names[k] = r
LAB = re.compile(r'^([A-Za-z_][A-Za-z0-9_]*)::'); TOK = re.compile(r'[A-Za-z_][A-Za-z0-9_]*')
def refs_of(tree):
    R = collections.defaultdict(set)
    for f in sorted(glob.glob('%s/src/bank_*.asm' % tree)):
        cur = None
        for line in open(f, encoding='utf-8'):
            m = LAB.match(line)
            if m: cur = m.group(1); continue
            code = line.split(';')[0]
            if not code.strip() or code.lstrip().startswith(('db', 'INCBIN')): continue
            for t in TOK.findall(code):
                if cur and t != cur: R[t].add(cur)
    return R
RU_ = refs_of(T); RJ = refs_of('roms/jp_rev_a')
SYMADDR = {}                                   # this build's listing may carry the names of an earlier pass: its references are keyed by address
for f_ in glob.glob('%s/*.sym' % T):
    for l_ in open(f_):
        p_ = l_.split()
        if len(p_) == 2 and ':' in p_[0]: SYMADDR[p_[1]] = (int(p_[0][:2], 16), int(p_[0][3:], 16))
ADDRNAME = {}
for k_, v_ in SYMADDR.items(): ADDRNAME.setdefault(v_, k_)
RUA = {SYMADDR[k_]: v_ for k_, v_ in RU_.items() if k_ in SYMADDR}
def norm(n): return re.sub(r'_(Tbl|Map|PtrTbl|Gfx)[0-9A-F]{4}$', r'_\1', n)
UNUSED = re.compile(r'^Unused_|_Dead$|Unused')
def is_unused(n, r): return bool(UNUSED.search(n)) or 'UNREFERENCED' in r.get('note', '')
# coverage readers
dr = None
for c in COVS:
    z = np.load(c); d = z['dr'] != 0
    if dr is None: dr, site, site2 = d.copy(), z['site'].copy(), z['site2'].copy()
    else:
        new = d & (site == 0); dr |= d; site[new] = z['site'][new]; site2[new] = z['site2'][new]
labs = sorted((flat(*k), r['name']) for k, r in names.items()); keys = [x for x, _ in labs]
def lab(v):
    v = int(v) & 0x7FFFFFFF; b, ad = v >> 16, v & 0xFFFF; o = flat(b if ad >= 0x4000 else 0, ad); i = bisect.bisect_right(keys, o) - 1; return labs[i][1]
COPIER = re.compile(r'^(Mem_|Vram_|Far_|Blit_|Img_|Tile_|Tiles_|Lcd_)')
NOISE = re.compile(r'^(Irq_|Main_Loop|Boot_)')
def cov_readers(o, e):
    c = collections.Counter()
    if dr is None: return c
    for x in range(o, e):
        if dr[x] and site[x]:
            l = lab(site[x])
            if COPIER.match(l) and site2[x]: l = lab(site2[x])
            c[l] += 1
    return c
ROM = open(os.environ.get('PORT_ROM', {'us': '/root/work/roms/gbcam_us.gb', 'gold': '/root/work/roms/gbcam_gold.gb'}[S]), 'rb').read()
taken = {r['name'] for r in names.values()}
import json
_tr = json.load(open('%s/trace/trace_%s.json' % (T, S)))['code']
CODE = set()
for k_, n_ in _tr.items():
    if n_ > 0: b_, a_ = k_.split(':'); CODE.add(flat(int(b_, 16), int(a_, 16)))
ROUTINES = {r['name'] for k, r in names.items() if flat(*k) in CODE}     # labels that sit on traced code
out = []; opn = []; cnt = collections.Counter()
for (b, a), r in sorted(names.items()):
    if r['conf'] != 'I': continue
    n = r['name']; o = flat(b, a); i = bisect.bisect_right(keys, o); e = min(keys[i] if i < len(keys) else 1 << 20, (o // 0x4000 + 1) * 0x4000)
    ru = set(RUA.get((b, a), set())); rj = {x for x in RJ.get(n, set())}
    nu = {norm(x) for x in ru}; nj = {norm(x) for x in rj}
    cv = cov_readers(o, e); tot = sum(cv.values()); top = [(k, v) for k, v in cv.most_common() if not NOISE.match(k)]
    why = None; newname = None
    m = re.match(r'(Gfx|Map|Src)_([0-9A-F]{2})_([0-9A-F]{4})_(.+?)(_Part[0-9A-F]{4}|_Cont|_Aux|_HeadRows)?$', n)
    routine = m.group(4) if m and m.group(4) in ROUTINES else None      # only a name whose tail is a routine label claims a loader
    content = bool(re.match(r'(Sheet_|Font_|StampCat|WildFrame|AlbumB_Pic|TileGap)', n)) or 'Jpn' in n     # names that describe the picture itself: checked by eye, not by readers
    ms = re.match(r'Mode([0-9A-F]{2})_StateTable$', n); ROMB = ROM
    if ms and ROMB[o - 4:o] == bytes([0xFA, 0xCF, 0xD5, 0xDF]):
        mm = int(ms.group(1), 16); lo, hi, bk = ROMB[0x3041 + 3 * mm:0x3044 + 3 * mm]
        if bk == b and 0 <= a - (lo | hi << 8) <= 16:
            why = 'dispatch', 'Mode_Table entry $%02X points to %02X:%04X, whose ld a,[wState] / rst $18 is followed by this table' % (mm, bk, lo | hi << 8)
    if why: pass
    elif n == 'Mode_Table' and all(any(r_['name'].startswith('Mode%02X_' % j) for k_, r_ in names.items() if k_ == (ROMB[0x3043 + 3 * j] if (ROMB[0x3041 + 3 * j] | ROMB[0x3042 + 3 * j] << 8) >= 0x4000 else 0, ROMB[0x3041 + 3 * j] | ROMB[0x3042 + 3 * j] << 8)) for j in range(0x22)):
        why = 'dispatch', 'each of its 34 {lo,hi,bank} entries points to the label ModeNN_* of mode NN in this build'
    elif ru and nu <= nj and not content:
        why = 'same', 'the readers here (%s) are the readers of the same name in the Japanese listing' % ', '.join(sorted(ru)[:4])
    elif not m and any(n.startswith(x + '_') for x in ru):
        why = 'owner', 'named after its reader %s, which reads it here' % next(x for x in ru if n.startswith(x + '_'))
    elif not m and not content and '_' in n and (lambda t: t and t[0][0].split('_')[0] == n.split('_')[0] and t[0][1] >= 0.9 * sum(v for _, v in t))(top or [(x, 1) for x in sorted(ru)]) and n.split('_')[0] not in ('Mode', 'Unused'):
        why = 'module', 'read here by %s, of the same module %s_ (%s)' % ((top or [(sorted(ru)[0], 1)])[0][0], n.split('_')[0], 'coverage' if top else 'listing')
    elif is_unused(n, r) and all(is_unused(x, {}) for x in ru):
        why = 'unref', 'no routine of this build names it%s' % (' except unused ones (%s)' % ', '.join(sorted(ru)) if ru else '')
    elif m and routine and (any(x == routine or x.startswith(routine + '_') for x in ru) or (tot and cv.get(routine, 0) >= 0.9 * tot)):
        why = 'loader', '%s loads it in this build (%s)' % (routine, 'listing' if any(x == routine or x.startswith(routine + '_') for x in ru) else 'coverage, %d of %d read bytes' % (cv.get(routine, 0), tot))
    elif m and routine and m.group(1) in ('Gfx', 'Map'):
        stat = [x for x in ru if not x.endswith(('Tbl', 'PtrTbl')) and not re.search(r'_(Tbl|Map|PtrTbl)[0-9A-F]{4}$', x)]
        cand = None
        if len(stat) == 1 and not [x for x in ru if x not in stat]: cand, src = stat[0], 'listing: the only routine that names it'
        elif not ru and top and tot and top[0][1] >= 0.9 * tot: cand, src = top[0][0], 'coverage: %d of %d read bytes' % (top[0][1], tot)
        if cand:
            nn = '%s_%s_%s_%s%s' % (m.group(1), m.group(2), m.group(3), cand, m.group(5) or '')
            if nn not in taken:
                taken.add(nn); newname = nn
                why = 'relabel', 'loaded here by %s (%s); the Japanese name %s describes the Japanese loader' % (cand, src, n)
    if why:
        cnt[why[0]] += 1
        out.append(['%02x' % b, '%04x' % a, newname or n, 'C', (r['note'] + '; ' if r['note'] else '') + 'L3 ' + why[0] + ': ' + why[1], 'checked4: ' + r.get('source', '')])
    else:
        cnt['open'] += 1
        opn.append(['%02X' % b, '%04X' % a, n, ' '.join(sorted(ru)), ' '.join(sorted(rj)), ' '.join('%s=%d' % kv for kv in cv.most_common(3)), (r.get('note') or '')[:120]])
print(dict(cnt))
if not dry:
    p_ = D + 'layers/sym_names_%s_checked.csv' % S; keep_ = [l for l in open(p_, encoding='utf-8') if 'checked4: ' not in l]       # rerunnable: earlier pass-4 rows are replaced
    open(p_, 'w', encoding='utf-8').write(''.join(keep_))
    with open(p_, 'a', newline='', encoding='utf-8') as fh: csv.writer(fh, lineterminator='\n').writerows(out)
    # the names left at I are listed by tools/port_settled.py (disasm/sym_settled_unused_<s>.csv), from the final names table
else:
    for x in out:
        m_ = re.search(r'L3 (\w+): (.*)$', x[4]); print('  %s:%s %-8s %s | %s' % (x[0], x[1], m_.group(1), x[2], m_.group(2)[:170]))
