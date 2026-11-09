#!/usr/bin/env python3
"""L3 pass 7: picture / map blocks that several routines read (the Japanese policy of shared assets: the name gives one consumer, the note lists the others).

  tools/port_check_names7.py TREE SUFFIX COV.npz [COV.npz ...] [--dry]

COV = read-site files with 'dr', 'site', 'site2' (interrupt-safe, tools/port_queue_origin.py with GBCAM_SITE_ALL=1).  The readers of a block are the
routines of its read sites (a copy helper Mem_* / Vram_* / Far_* / Blit_* / Img_* / Tile_* / Lcd_* is replaced by its caller); interrupt, main-loop and
boot sites, and sites that resolve to a data label, are left out.  For a name still at I after passes 4-6 and the hand layer:
  shared        the routine in the name is one of the readers: C, the other readers in the note
  module        a descriptive name (its tail is no routine label) whose first word (Parlor, Mode16, PenMenu, Kb, AnimEd, MainMenu, ...) is the module of the
                reader of at least half of its read bytes: C, the readers in the note
  relabel-top   the name is after a routine that does not read it here, and one reader holds at least 60 % of the read bytes: renamed after it, C
The rest stay I.  Rows: <TREE>/disasm/sym_names_<s>_checked.csv, source 'checked7: ...' (earlier pass-7 rows replaced).
"""
import sys, os, re, csv, json, bisect, collections
import numpy as np
args = sys.argv[1:]; dry = '--dry' in args; args = [x for x in args if x != '--dry']
T, S, COVS = args[0].rstrip('/'), args[1], args[2:]; D = T + '/disasm/'
def flat(b, a): return a if b == 0 else b * 0x4000 + a - 0x4000
names = {}
for suf in ('', '_loaders', '_reads', '_checked', '_hand'):
    p = D + 'layers/sym_names_%s%s.csv' % (S, suf or '_port')
    if not os.path.exists(p): continue
    for r in csv.DictReader(open(p, encoding='utf-8')):
        if 'checked7: ' in r.get('source', ''): continue
        k = (int(r['bank'], 16), int(r['addr'], 16))
        if r['name'] == '-': names.pop(k, None)
        else: names[k] = r
labs = sorted((flat(*k), r['name']) for k, r in names.items()); keys = [x for x, _ in labs]
tr = json.load(open('%s/trace/trace_%s.json' % (T, S)))['code']
code = {flat(int(k[:2], 16), int(k[3:], 16)) for k, n in tr.items() if n > 0}
ROUT = {r['name'] for k, r in names.items() if flat(*k) in code}
def lab(v):
    v = int(v) & 0x7FFFFFFF; b, ad = v >> 16, v & 0xFFFF; o = flat(b if ad >= 0x4000 else 0, ad); i = bisect.bisect_right(keys, o) - 1; return labs[i][1]
NOISE = re.compile(r'^(Irq_|Main_Loop|Boot_)'); COP = re.compile(r'^(Mem_|Vram_|Far_|Blit_|Img_|Tile_|Tiles_|Lcd_)')
Z = [np.load(c) for c in COVS]
taken = {r['name'] for r in names.values()}; out = []; cnt = collections.Counter()
for (b, a), r in sorted(names.items()):
    n = r['name']
    if r['conf'] != 'I': continue
    m = re.match(r'(Gfx|Map|Src)_([0-9A-F]{2})_([0-9A-F]{4})_(.+?)(_Part[0-9A-F]{4}|_Cont|_Aux|_HeadRows|_ExtraRows?|_Unref)?$', n)
    if not m: continue
    o = flat(b, a); i = bisect.bisect_right(keys, o); e = min(keys[i] if i < len(keys) else 1 << 20, (o // 0x4000 + 1) * 0x4000)
    c = collections.Counter()
    for z in Z:
        dr, site, site2 = z['dr'], z['site'], z['site2']
        for x in range(o, e):
            if dr[x] and site[x]:
                l = lab(site[x])
                if COP.match(l) and site2[x]: l = lab(site2[x])
                if not NOISE.match(l) and l in ROUT: c[l] += 1
    tot = sum(c.values())
    if not tot: continue
    rd = ', '.join('%s (%d)' % kv for kv in c.most_common(5)); tail = m.group(4); why = None; nn = None
    top, k = c.most_common(1)[0]
    if tail in c: why = 'shared', 'read here by %s; the name gives one consumer (read sites of the interrupt-safe coverage replay, bytes read per routine)' % rd
    elif tail not in ROUT:
        mod = tail.split('_')[0]
        if mod and k >= 0.5 * tot and top.split('_')[0] == mod:
            why = 'module', 'read here by %s, of the module its name gives (read sites, bytes per routine)' % rd
    elif k >= 0.6 * tot:
        nn = '%s_%s_%s_%s%s' % (m.group(1), m.group(2), m.group(3), top, m.group(5) or '')
        if nn not in taken:
            taken.add(nn); why = 'relabel-top', 'read here by %s, not by %s; the earlier name %s' % (rd, tail, n)
    if why:
        cnt[why[0]] += 1
        out.append(['%02x' % b, '%04x' % a, nn or n, 'C', (r['note'] + '; ' if r['note'] else '') + 'L3 ' + why[0] + ': ' + why[1], 'checked7: ' + r.get('source', '')])
print(dict(cnt))
if dry:
    for x in out: print('  ', x[0] + ':' + x[1], x[2], '|', x[4][-160:])
else:
    p = D + 'layers/sym_names_%s_checked.csv' % S; keep = [l for l in open(p, encoding='utf-8') if 'checked7: ' not in l]
    open(p, 'w', encoding='utf-8').write(''.join(keep))
    with open(p, 'a', newline='', encoding='utf-8') as fh: csv.writer(fh, lineterminator='\n').writerows(out)
