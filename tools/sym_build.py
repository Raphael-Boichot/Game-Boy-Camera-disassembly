#!/usr/bin/env python3
"""Build pocketcamera_jp.sym (mgbdis v3 symbol file) for Pocket Camera (Japan) Rev A.

  tools/sym_build.py ROM.gb [--names roms/jp_rev_a/disasm/sym_names_jp.csv] [--types roms/jp_rev_a/disasm/sym_types_jp.csv]
                            [--trace roms/jp_rev_a/wram/trace_jp_v3.json] [--out pocketcamera_jp.sym] [--report]

Inputs
  names csv  bank,addr,name,conf,note   (hex bank / addr; a later row for the same address wins; name `-` deletes the label)
  types csv  bank,start,end,type,width,note   (hex; [start,end) ; type = data | text | padding | code | image)
  trace      wram/trace_jp_v3.json: `code` = {"BB:AAAA": instruction length} of every instruction proven by the static trace
Segmentation
  1. every contiguous run of proven instructions is a `.code` block (not inside 00:0000-014F: mgbdis' default vectors and header block stay)
  2. every other byte is data: a fill run of 16 bytes or more (or 4+ at the end of a bank) is `.padding`, the rest `.data`
  3. the rows of the types csv carve their range out of the above and replace it (so a table gets its width, a string its `.text`)
Checks (the script aborts on any of them)
  * a label inside a code run must sit on a proven instruction start;  * two labels must not share a name;
  * a .padding block must be one repeated byte;  * a type row must lie in one bank.
"""
import sys, os, json, csv, argparse, collections
ap = argparse.ArgumentParser()
ap.add_argument('rom'); ap.add_argument('--names', default='roms/jp_rev_a/disasm/sym_names_jp.csv'); ap.add_argument('--types', action='append', default=None)
ap.add_argument('--trace', default='roms/jp_rev_a/wram/trace_jp_v3.json'); ap.add_argument('--out', default='roms/jp_rev_a/pocketcamera_jp.sym')
ap.add_argument('--extra-names', action='append', default=[]); ap.add_argument('--report', action='store_true')
ap.add_argument('--legacy', default=None, help='older .sym whose label lines are kept where the names csv has none')
a = ap.parse_args()
if not a.types: a.types = ['roms/jp_rev_a/disasm/sym_types_jp.csv']
ROM = open(a.rom, 'rb').read()
assert len(ROM) == 0x100000, 'expected a 1 MiB ROM'
T = json.load(open(a.trace))
def off(b, ad): return ad if b == 0 else b * 0x4000 + (ad - 0x4000)
code = collections.defaultdict(dict)
for k, n in T['code'].items():
    b, ad = k.split(':'); b = int(b, 16); ad = int(ad, 16)
    if n > 0: code[b][ad] = n
def bank_range(b): return (0, 0x4000) if b == 0 else (0x4000, 0x8000)
# ------------------------------------------------------------------ 1/2 baseline
blocks = {b: [] for b in range(64)}      # bank -> list of [start,end,kind,width,curated]
def fills(b, s, e):
    out = []; i = s
    while i < e:
        j = i; v = ROM[off(b, i)]
        while j < e and ROM[off(b, j)] == v: j += 1
        pad = (j - i >= 16) or (e == bank_range(b)[1] and j == e and j - i >= 4)
        out.append([i, j, 'padding' if pad else 'data'])
        i = j
    m = []
    for s2, e2, k in out:
        if m and m[-1][2] == 'data' and k == 'data' and m[-1][1] == s2: m[-1][1] = e2
        else: m.append([s2, e2, k])
    return m
for b in range(64):
    lo, hi = bank_range(b); p = lo
    runs = []; cur = None
    for ad in sorted(code.get(b, {})):
        n = code[b][ad]
        if cur and cur[1] == ad: cur[1] = ad + n
        else:
            if cur: runs.append(tuple(cur))
            cur = [ad, ad + n]
    if cur: runs.append(tuple(cur))
    for s, e in runs:
        if s > p:
            for s2, e2, k in fills(b, p, s): blocks[b].append([s2, e2, k, None, False])
        blocks[b].append([s, e, 'code', None, True]); p = e
    if p < hi:
        for s2, e2, k in fills(b, p, hi): blocks[b].append([s2, e2, k, None, False])
# ------------------------------------------------------------------ 3 type rows
def carve(b, s, e):
    new = []
    for x in blocks[b]:
        if x[1] <= s or x[0] >= e: new.append(x); continue
        if x[0] < s: new.append([x[0], s] + x[2:])
        if x[1] > e: new.append([e, x[1]] + x[2:])
    blocks[b] = new
nt = 0
for tf in a.types:
  if os.path.exists(tf):
    for r in csv.reader(open(tf, encoding='utf-8')):
        if not r or r[0].startswith('#') or r[0] == 'bank': continue
        b = int(r[0], 16); s = int(r[1], 16); e = int(r[2], 16); typ = r[3]; wd = int(r[4]) if len(r) > 4 and r[4] else None
        lo, hi = bank_range(b); assert lo <= s < e <= hi, 'type row out of bank: %s' % r
        carve(b, s, e)
        if typ == 'padding':
            assert len(set(ROM[off(b, i)] for i in range(s, e))) == 1, 'padding row is not one byte: %s' % r
        blocks[b].append([s, e, typ, wd, True]); nt += 1
for b in blocks: blocks[b].sort()
# no gaps, no overlaps
for b in range(64):
    lo, hi = bank_range(b); p = lo
    for s, e, k, wd, cur in blocks[b]:
        assert s == p, 'bank %02X hole or overlap at %04X (expected %04X)' % (b, s, p); p = e
    assert p == hi, 'bank %02X ends at %04X' % (b, p)
# ------------------------------------------------------------------ labels
names = collections.OrderedDict()      # (bank,addr) -> name
conf = {}
for fn in [a.names] + a.extra_names:
    if not os.path.exists(fn): continue
    for r in csv.reader(open(fn, encoding='utf-8')):
        if not r or r[0].startswith('#') or r[0] == 'bank': continue
        k = (int(r[0], 16), int(r[1], 16))
        if r[2] in ('-', ''): names.pop(k, None); conf.pop(k, None); continue      # '-' removes the label of an earlier file
        names[k] = r[2]; conf[k] = r[3] if len(r) > 3 else ''
legacy = 0
if a.legacy and os.path.exists(a.legacy):
    for l in open(a.legacy):
        l = l.strip()
        if not l or l.startswith(';') or '.' in l.split()[1][:1]: continue
        loc, nm = l.split()[:2]; b, ad = loc.split(':'); k = (int(b, 16), int(ad, 16))
        if k not in names: names[k] = nm; conf[k] = 'L'; legacy += 1
seen = {}; dups = []
for k, nm in names.items():
    if nm in seen: dups.append((nm, seen[nm], k))
    else: seen[nm] = k
if dups:
    for nm, k1, k2 in dups: print('duplicate name %s at %02X:%04X and %02X:%04X' % ((nm,) + k1 + k2))
    sys.exit('%d duplicate names' % len(dups))
# mgbdis prints no label inside a .padding block: a padding block that holds a label becomes plain data
npad = 0
for (b, ad), nm in names.items():
    for x in blocks[b]:
        if x[0] <= ad < x[1] and x[2] == 'padding': x[2] = 'data'; x[3] = 16; npad += 1; break
bad = []
for (b, ad), nm in names.items():
    lo, hi = bank_range(b)
    assert lo <= ad < hi, 'label out of bank %02X:%04X %s' % (b, ad, nm)
    for s, e, k, wd, cur in blocks[b]:
        if s <= ad < e:
            if k == 'code' and ad not in code[b]: bad.append((b, ad, nm))
            break
if bad:
    for x in bad[:40]: print('label inside an instruction: %02X:%04X %s' % x)
    sys.exit('%d labels are not on an instruction start' % len(bad))
# ------------------------------------------------------------------ write
out = []
for (b, ad), nm in sorted(names.items()): out.append('%02x:%04x %s' % (b, ad, nm))
for b in range(64):
    for s, e, k, wd, cur in blocks[b]:
        if k == 'code' and b == 0 and s < 0x150: continue
        arg = (':%x' % wd) if (k == 'data' and wd) else ''
        out.append('%02x:%04x .%s:%x%s' % (b, s, k, e - s, arg))
open(a.out, 'w').write('\n'.join(out) + '\n')
print('%d padding blocks turned into data because they hold a label' % npad)
print('%s: %d labels (%d from the legacy file), %d type rows, %d lines' % (a.out, len(names), legacy, nt, len(out)))
if a.report:
    tot = collections.Counter(); curated = collections.Counter()
    for b in range(64):
        for s, e, k, wd, cur in blocks[b]:
            tot[k] += e - s
            if k != 'code' and cur: curated[k] += e - s
    print('bytes by type:', dict(tot))
    dflt = {b: sum(e - s for s, e, k, wd, cur in blocks[b] if k == 'data' and not cur) for b in range(64)}
    print('data bytes still on the default typing (.data, 16 per row): %d' % sum(dflt.values()))
    print(' '.join('%02X:%d' % (b, v) for b, v in dflt.items() if v))
