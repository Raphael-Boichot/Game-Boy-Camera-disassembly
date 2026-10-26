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
  * a data name goes where the paired instructions that load its JP address point in this build, when they all agree.
  * a handler name of a JP `rst $18` table goes to the same entry of the other build's table when both tables have the same length;
    likewise the target names of a JP word table (width 2) whose words all point at labels, when the table is carried whole.
  * a name not carried by the maps is searched by its own bytes in the same bank (see `recovery` below), tagged I if found.
  * an upper-case 4-digit hex token of a name that equals the JP address of a label of the same bank, or of the bank written
    just before it (`B02_6E4B`, `25_73A0`), (its own, or the one it refers to) is rewritten to that label's new address; a token whose address does not map is left and listed; RAM / VRAM addresses ($8000+) are left.
Types: each JP row is cut at the shifts of the byte map; deleted bytes are dropped; a piece keeps the row width only if its
length is a multiple of it or it is the whole row (else width 1); a padding piece that is not one repeated byte becomes data. A piece that falls on
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
# data names follow the code that points at them: a paired instruction with a 16-bit immediate (`ld hl|de|bc, nn`, `ld a, [nn]`, ...)
# whose JP operand is the address of a JP data label of the code's bank (or of bank 0) gives that label's address in this build
# (its own operand). A name moves when all its paired references agree (and land outside every traced instruction).
W16R = {0x01, 0x11, 0x21, 0xFA, 0xEA}
votes = collections.defaultdict(collections.Counter)
for jo, uo in CM.items():
    op = JP[jo]
    if op not in W16R or OT[uo] != op: continue
    vj = JP[jo + 1] | JP[jo + 2] << 8; vu = OT[uo + 1] | OT[uo + 2] << 8
    if not (0x0100 <= vj < 0x8000 and 0x0100 <= vu < 0x8000): continue
    cb = jo // 0x4000
    if (vj < 0x4000) != (vu < 0x4000) or (cb == 0 and vj >= 0x4000): continue        # bank-0 code pointing into a switched bank: bank unknown here
    k = (0 if vj < 0x4000 else cb, vj)
    if k not in labels or off(k[0], k[1]) in JI: continue
    votes[k][off(k[0], vu)] += 1
nref = 0
for k, c in votes.items():
    if len(c) != 1: continue
    t = next(iter(c))
    if t in inside or t in ucode: continue
    if newaddr.get(k) != t:
        newaddr[k] = t; nref += 1
        fate[k] = ('data', 'placed by %d paired reference(s) to it (the operand of the same instruction here)' % c[t])
print('data names placed by the code that points at them: %d' % nref)
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
# the same for the JP word tables (type rows of width 2) whose every word points at a JP label of the table's bank (or bank 0):
# when the table was carried whole and holds as many words here, entry i's name goes to the word i of this build's table
JTR = []
for r in csv.reader(open(a.types, encoding='utf-8')):
    if not r or r[0] == 'bank' or r[0].startswith('#') or r[3] != 'data' or r[4] != '2': continue
    JTR.append((int(r[0], 16), int(r[1], 16), int(r[2], 16)))
ntab = 0; nmove = 0; nnew = 0
for b, ts, te in JTR:
    if (b, ts) not in labels: continue
    jo = off(b, ts); nw = (te - ts) // 2
    jw = [JP[jo + 2 * i] | JP[jo + 2 * i + 1] << 8 for i in range(nw)]
    jk = [(0 if w < 0x4000 else b, w) for w in jw]
    if not jw or not all(0x0100 <= w < 0x8000 and k in labels for w, k in zip(jw, jk)): continue
    if (b, ts) not in newaddr: continue
    uo = newaddr[(b, ts)]
    if any(M[jo + i] != uo + i for i in range(2 * nw)): continue            # the table must be carried whole, same length
    uw = [OT[uo + 2 * i] | OT[uo + 2 * i + 1] << 8 for i in range(nw)]
    if not all(0x0100 <= w < 0x8000 for w in uw): continue
    ntab += 1
    for i, (k, w) in enumerate(zip(jk, uw)):
        o2 = off(b, w)
        if o2 in inside: continue
        if (o2 in UI) != (off(k[0], k[1]) in JI): continue                     # code stays code, data stays data
        if newaddr.get(k) != o2:
            if k in newaddr: nmove += 1
            else: nnew += 1
            newaddr[k] = o2; fate[k] = (fate[k][0] if fate[k][0] != 'lost' else ('code' if o2 in UI else 'data'),
                                       'placed by the word table %s (entry %d)' % (labels[(b, ts)][2], i))
print('names placed by their word table: %d tables, %d names moved, %d lost names recovered' % (ntab, nmove, nnew))
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
# one name per address: a name placed by a table wins, then a name whose routine / bytes are the same, then the first in address order
byaddr = collections.defaultdict(list)
for k, t in newaddr.items(): byaddr[t].append(k)
for t, ks in byaddr.items():
    if len(ks) < 2: continue
    ks.sort(key=lambda k: (0 if 'placed by' in fate[k][1] else (1 if not fate[k][1] else 2), k))         # table / reference placements first
    for k in ks[1:]:
        del newaddr[k]; fate[k] = ('lost', 'same address as %s in this build (both point there)' % labels[ks[0]][2])
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
    same_here = False
    if 'placed by' in why:                                     # placed by code evidence: keeps its tag if its bytes (to the next JP label) are the same here
        o = off(b, ad); e = next_label(o); n = min(e - o, 0x8000)
        same_here = n > 0 and JP[o:o + n] == OT[t:t + n] if o not in JI else (CK.get(o) in ('same', 'operand'))
    conf = r[3] if (not why or same_here) else 'I'
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
    b = int(r[0], 16); s = off(b, int(r[1], 16)); e = s + int(r[2], 16) - int(r[1], 16); typ = r[3]; wd = int(r[4]) if r[4] else 0     # end $4000 of bank 0 is not offset 0
    note = r[5] if len(r) > 5 else ''
    p = s
    while p < e:
        if M[p] < 0 or M[p] in ucode: p += 1; continue
        q = p
        while q + 1 < e and M[q + 1] == M[q] + 1 and M[q + 1] not in ucode: q += 1
        t0 = int(M[p]); n = q + 1 - p; tb, ta = loc(t0)
        w2 = wd if (wd and (n % wd == 0 or n == e - s)) else (1 if wd else 0)        # an unsplit row keeps its width
        ty = typ
        if ty == 'padding' and len(set(OT[t0:t0 + n])) != 1: ty = 'data'; w2 = 1
        trows.append(['%02x' % tb, '%04x' % ta, '%04x' % (ta + n), ty, str(w2) if w2 else '', ('JP %02X:%s ' % (b, r[1]) + note).strip()])
        p = q + 1
# a name moved by a table or by its references takes the JP type row that starts at it along (same type, width and length),
# appended after the carried rows so that it wins, if it stays in its bank; it stops at the first traced instruction
jprow = {}
for r in csv.reader(open(a.types, encoding='utf-8')):
    if not r or r[0] == 'bank' or r[0].startswith('#'): continue
    jprow[(int(r[0], 16), int(r[1], 16))] = r
nrow = 0
for k, (kind, why) in fate.items():
    if 'placed by' not in why or k not in newaddr or k not in jprow: continue
    r = jprow[k]; n = int(r[2], 16) - int(r[1], 16); t = newaddr[k]; tb, ta = loc(t)
    if (ta < 0x4000 and ta + n > 0x4000) or (ta >= 0x4000 and ta + n > 0x8000) or t in ucode: continue
    cut = next((i for i in range(n) if t + i in ucode), n)              # the block is shorter here: it stops at traced code
    wd = r[4]
    if cut < n:
        if wd and cut % int(wd): wd = '1'
        why2 = ', cut to $%X bytes at the code that follows it here' % cut
    else: why2 = ''
    trows.append(['%02x' % tb, '%04x' % ta, '%04x' % (ta + cut), r[3], wd, ('JP %02X:%s, moved with its name%s ' % (k[0], r[1], why2) + (r[5] if len(r) > 5 else '')).strip()]); nrow += 1
print('type rows moved with their name: %d' % nrow)
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
