#!/usr/bin/env python3
"""Carry the Japanese names and type rows to another build.

  tools/port_syms.py JP.gb OTHER.gb MAP.npy CODE_MAP.csv OTHER_TRACE.json OUTDIR [--suffix us]
        [--names roms/jp_rev_a/disasm/sym_names_jp.csv] [--types roms/jp_rev_a/disasm/sym_types_jp.csv]

Names
  * a name on a JP instruction start goes where tools/port_code_map.py paired that instruction; it keeps its JP tag (C / I)
    only if every JP instruction up to the next JP label is paired as `same` or `operand` and lands on the next paired
    address (the routine is the same code); otherwise it is tagged I with a note ("routine differs: ...").
  * any other name goes through the byte map; it keeps its tag only if the bytes up to the next JP label are identical,
    otherwise I ("content differs: n of m bytes"). A name that lands inside an instruction of the other build's trace is
    not carried.
  * a handler name of a JP `rst $18` table goes to the same entry of the other build's table when both tables have the same length.
  * a name not carried by the maps is searched by its own bytes in the same bank (see `recovery` below), tagged I if found.
  * an upper-case 4-digit hex token of a name that equals the JP address of a label of the same bank, or of the bank written
    just before it (`B02_6E4B`, `25_73A0`), (its own, or the one it refers to) is rewritten to that label's new address; a token whose address does not map is left and listed; RAM / VRAM addresses ($8000+) are left.
Types: each JP row is cut at the shifts of the byte map; deleted bytes are dropped; a piece keeps the row width only if its
length is a multiple of it (else width 1); a padding piece that is not one repeated byte becomes data. A piece that falls on
traced code of the other build is dropped (code wins). Every `rst $18` table of the other build's trace is then typed with
its own length (a row appended last, so it wins).
Writes OUTDIR/sym_names_<suffix>.csv, OUTDIR/sym_types_<suffix>.csv and OUTDIR/port_report_<suffix>.csv (every JP name with
its fate).
"""
import sys, csv, json, re, argparse, collections, os
import numpy as np
ap = argparse.ArgumentParser()
for x in ('jp', 'other', 'map', 'codemap', 'trace', 'outdir'): ap.add_argument(x)
ap.add_argument('--suffix', default='us')
ap.add_argument('--names', default='roms/jp_rev_a/disasm/sym_names_jp.csv')
ap.add_argument('--types', default='roms/jp_rev_a/disasm/sym_types_jp.csv')
ap.add_argument('--jptrace', default='roms/jp_rev_a/wram/trace_jp_v3.json')
a = ap.parse_args()
JP = open(a.jp, 'rb').read(); OT = open(a.other, 'rb').read(); M = np.load(a.map)
def off(b, ad): return ad if ad < 0x4000 else b * 0x4000 + ad - 0x4000
def loc(o): return (o // 0x4000, o if o < 0x4000 else (o & 0x3FFF) + 0x4000)
def ins(path):
    d = {}
    for k, n in json.load(open(path))['code'].items():
        b, ad = (int(x, 16) for x in k.split(':'))
        if n > 0: d[off(b, ad)] = n
    return d
JI = ins(a.jptrace); UI = ins(a.trace)
inside = set()                       # offsets inside (not at the start of) an instruction of the other build
for o, n in UI.items():
    for i in range(1, n): inside.add(o + i)
ucode = set()
for o, n in UI.items():
    for i in range(n): ucode.add(o + i)
CM = {}; CK = {}
for r in csv.DictReader(open(a.codemap)):
    b = int(r['bank'], 16); j = off(b, int(r['jp'], 16)); u = off(b, int(r['other'], 16)); CM[j] = u; CK[j] = r['kind']
# ---------------------------------------------------------------- names
rows = []
for r in csv.reader(open(a.names, encoding='utf-8')):
    if not r or r[0] == 'bank' or r[0].startswith('#'): continue
    rows.append(r)
labels = {}
for r in rows:
    k = (int(r[0], 16), int(r[1], 16))
    if r[2] in ('-', ''): labels.pop(k, None)
    else: labels[k] = r
keys = sorted(labels); offs = sorted(off(b, ad) for b, ad in keys)
def next_label(o):
    i = __import__('bisect').bisect_right(offs, o)
    end = (o // 0x4000 + 1) * 0x4000
    return min(offs[i], end) if i < len(offs) else end
newaddr = {}; fate = {}
for (b, ad) in keys:
    o = off(b, ad); nm = labels[(b, ad)][2]
    if o in JI:
        if o not in CM: fate[(b, ad)] = ('lost', 'routine start not paired'); continue
        t = CM[o]; e = next_label(o); bad = 0; tot = 0; p = o
        while p < e and p in JI:
            tot += 1
            if CK.get(p) not in ('same', 'operand') or CM.get(p) is None: bad += 1
            p += JI[p]
        newaddr[(b, ad)] = t
        fate[(b, ad)] = ('code', '' if bad == 0 else 'routine differs: %d of %d JP instructions not paired as same code' % (bad, tot))
    else:
        t = int(M[o])
        if t < 0: fate[(b, ad)] = ('lost', 'byte deleted in this build'); continue
        if t in inside: fate[(b, ad)] = ('lost', 'lands inside an instruction'); continue
        e = next_label(o); n = e - o; d = 0
        for i in range(n):
            tt = M[o + i]
            if tt < 0 or JP[o + i] != OT[tt]: d += 1
        newaddr[(b, ad)] = t
        fate[(b, ad)] = ('data', '' if d == 0 else 'content differs: %d of %d bytes' % (d, n))
# state handlers follow the tables: when a JP `rst $18` table and the table of the other build at the same `rst $18` (paired by the
# instruction map) have the same number of words, the name at JP entry i goes to the other build's entry i, if that is an
# instruction start of its trace (a handler that gained or lost instructions at its head is placed right this way)
JT = json.load(open(a.jptrace))['tables']; UTB = json.load(open(a.trace))['tables']; nfollow = 0
for k, tg in JT.items():
    b, t = (int(x, 16) for x in k.split(':')); rst = off(b, t - 1)
    if rst not in CM: continue
    u = CM[rst] + 1; ub, ua = loc(u); ut = UTB.get('%02x:%04x' % (ub, ua))
    if not ut or len(ut) != len(tg): continue
    for jt, ot in zip(tg, ut):
        jk = (0 if jt < 0x4000 else b, jt); o2 = off(ub, ot)
        if jk not in labels or o2 not in UI: continue
        if newaddr.get(jk) != o2:
            newaddr[jk] = o2; fate[jk] = ('code', 'placed by the state table %02X:%04X (entry of the same index)' % (ub, ua)); nfollow += 1
print('handler names placed by their state table: %d' % nfollow)
# recovery: a lost name whose own bytes (code: up to the next JP label, address operands masked, at most 32 bytes; data: up to
# the next JP label, at most 32 bytes, at least 8) occur exactly once in the same bank of the other build, on a free spot
# (an instruction start for code, outside every instruction for data, no carried label there) -> carried, tagged I
taken = set(newaddr.values())
W16 = {0x01, 0x11, 0x21, 0x31, 0x08, 0xC2, 0xC3, 0xCA, 0xD2, 0xDA, 0xC4, 0xCC, 0xCD, 0xD4, 0xDC, 0xEA, 0xFA}
for (b, ad) in keys:
    if fate[(b, ad)][0] != 'lost': continue
    o = off(b, ad); e = min(next_label(o), o + 32); pat = []
    if o in JI:
        p = o
        while p < e and p in JI:
            n = JI[p]
            for i in range(n): pat.append(None if (JP[p] in W16 and n == 3 and i > 0) else JP[p + i])
            p += n
    else:
        pat = list(JP[o:e])
    if sum(x is not None for x in pat) < 8: continue
    rx = re.compile(b''.join(b'.' if x is None else re.escape(bytes([x])) for x in pat), re.S)
    lo = (o // 0x4000) * 0x4000
    hits = [m.start() for m in rx.finditer(OT, lo, lo + 0x4000)]
    if len(hits) != 1: continue
    t = hits[0]
    if t in taken or (o in JI and t not in UI) or (o not in JI and (t in ucode)): continue
    newaddr[(b, ad)] = t; taken.add(t)
    fate[(b, ad)] = ('code' if o in JI else 'data', 'moved: found by its own bytes (%d) elsewhere in the bank' % len(pat))
# address tokens in names
addr_of = collections.defaultdict(dict)
for (b, ad), t in newaddr.items(): addr_of[b][ad] = t
untok = []
def rewrite(b, ad, nm):
    def sub(m):
        pre, v = m.group(1), int(m.group(3), 16)
        if v >= 0x8000: return m.group(0)                       # a RAM / VRAM address: unchanged
        banks = (int(m.group(2), 16), 0) if m.group(2) else ((b, 0) if b else (0,))
        for bb in banks:
            if v in addr_of[bb]:
                t = addr_of[bb][v]; return (pre or '') + '%04X' % (t if t < 0x4000 else (t & 0x3FFF) + 0x4000)
        untok.append((b, ad, nm, m.group(3))); return m.group(0)
    return re.sub(r'(?<![0-9A-F])(B?([0-9A-F]{2})_)?([0-9A-F]{4})(?![0-9A-Fa-f])', sub, nm)
out = []; rep = []; seen = {}
for (b, ad) in keys:
    r = labels[(b, ad)]; kind, why = fate[(b, ad)]
    if kind == 'lost':
        rep.append(['%02x' % b, '%04x' % ad, r[2], '', '', 'lost', why]); continue
    t = newaddr[(b, ad)]; tb, ta = loc(t); nm = rewrite(b, ad, r[2])
    if nm in seen: nm = nm + '_%04X' % ta
    seen[nm] = 1
    conf = r[3] if not why else 'I'
    note = r[4] if len(r) > 4 else ''
    src = 'port JP %02X:%04X%s' % (b, ad, ('; ' + why) if why else '')
    out.append(['%02x' % tb, '%04x' % ta, nm, conf, note, src])
    rep.append(['%02x' % b, '%04x' % ad, r[2], '%02x:%04x' % (tb, ta), nm, kind if not why else kind + '-differs', why])
os.makedirs(a.outdir, exist_ok=True)
with open(os.path.join(a.outdir, 'sym_names_%s.csv' % a.suffix), 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f); w.writerow(['bank', 'addr', 'name', 'conf', 'note', 'source']); w.writerows(sorted(out, key=lambda x: (x[0], x[1])))
with open(os.path.join(a.outdir, 'port_report_%s.csv' % a.suffix), 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f); w.writerow(['jp_bank', 'jp_addr', 'jp_name', 'new_loc', 'new_name', 'fate', 'why']); w.writerows(rep)
# ---------------------------------------------------------------- types
trows = []
for r in csv.reader(open(a.types, encoding='utf-8')):
    if not r or r[0] == 'bank' or r[0].startswith('#'): continue
    b = int(r[0], 16); s = off(b, int(r[1], 16)); e = off(b, int(r[2], 16)); typ = r[3]; wd = int(r[4]) if r[4] else 0
    note = r[5] if len(r) > 5 else ''
    p = s
    while p < e:
        if M[p] < 0 or M[p] in ucode: p += 1; continue
        q = p
        while q + 1 < e and M[q + 1] == M[q] + 1 and M[q + 1] not in ucode: q += 1
        t0 = int(M[p]); n = q + 1 - p; tb, ta = loc(t0)
        w2 = wd if (wd and n % wd == 0) else (1 if wd else 0)
        ty = typ
        if ty == 'padding' and len(set(OT[t0:t0 + n])) != 1: ty = 'data'; w2 = 1
        trows.append(['%02x' % tb, '%04x' % ta, '%04x' % (ta + n), ty, str(w2) if w2 else '', ('JP %02X:%s ' % (b, r[1]) + note).strip()])
        p = q + 1
# the `rst $18` word tables of the other build's own trace, with their own length (the JP row can be shorter or longer):
# appended last, so they win over the rows carried from the JP layout
for k, tg in sorted(json.load(open(a.trace))['tables'].items()):
    tb, ta = (int(x, 16) for x in k.split(':'))
    if tg: trows.append(['%02x' % tb, '%04x' % ta, '%04x' % (ta + 2 * len(tg)), 'data', '2', 'rst $18 table of this build (%d words, from its trace)' % len(tg)])
with open(os.path.join(a.outdir, 'sym_types_%s.csv' % a.suffix), 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f); w.writerow(['bank', 'start', 'end', 'type', 'width', 'note']); w.writerows(trows)
c = collections.Counter(x[5] for x in rep)
print('names:', dict(c), 'written', len(out)); print('type rows: JP -> %d pieces' % len(trows))
print('address tokens left unchanged (no mapped label at that address): %d' % len(untok))
for x in untok[:15]: print('  %02X:%04X %s token %s' % x)
