#!/usr/bin/env python3
"""Explain the never-executed (but statically traced) code by the conditions that gate it.

 * gating branch = an executed conditional branch (jr/jp/call/ret cc) with one successor executed and the other not;
   the variable it tests is guessed from the nearest preceding memory read (ld a,[nnnn] / ldh a,[ffnn]) and named from the WRAM maps.
 * component = connected group of never-executed traced instructions (jr/jp/call/fallthrough edges). Each is classified:
     GATED  (>=1 executed conditional branch leads in)      -> the condition just never became true in the run
     TABLE  (entered only by an indirect-dispatch table entry: rst18 / jump table / mode table / far)  -> entry never selected
     DEAD   (only DEAD-CODE roots from tools/extra_roots.json lead in)                              -> unreferenced code
     ORPHAN (anything else)
Usage: gating_branches.py OUTDIR merged_cov.npz      (env GBCAM_ROM, GBCAM_TRACE, GBCAM_ROOTS, GBCAM_WRAM_DIR)"""
import sys as _s, os as _o
_s.path.insert(0, _o.path.join(_o.path.dirname(_o.path.abspath(__file__)), '..', 'src'))
import paths
import sys, os, json, csv, glob, collections
import numpy as np
OUT, cov = sys.argv[1], sys.argv[2]
HERE = os.path.dirname(os.path.abspath(__file__))
def env(k, d): return os.environ.get(k, d)
ROM = env('GBCAM_ROM', paths.ROM)
TRACE = env('GBCAM_TRACE', paths.TRACE)
ROOTS = env('GBCAM_ROOTS', paths.ROOTS)
WRAM = env('GBCAM_WRAM_DIR', _o.path.join(paths.PKG, 'wram'))
def flat(b, a): return a if b == 0 and a < 0x4000 else b * 0x4000 + (a - 0x4000)
def unflat(f): return (0, f) if f < 0x4000 else (f >> 14, 0x4000 + (f & 0x3FFF))
def fmt(f): b, a = unflat(f); return '%02X:%04X' % (b, a)
rom = open(ROM, 'rb').read(); N = len(rom); rom += b'\0' * 4
t = json.load(open(TRACE))
ilen = np.zeros(N, np.uint8)
for k, n in t['code'].items():
    if n > 0: b, a = k.split(':'); ilen[flat(int(b, 16), int(a, 16))] = n
z = np.load(cov); oex = z['oex'][:N] == 1; exall = z['ex'][:N] == 1
BASE = env('GBCAM_BASE', 'ex')          # 'ex' = anything executed counts as covered;  'oex' = only organic (button-only) execution counts: the remaining code is what needs forced states
ex = exall if BASE == 'ex' else oex
SUF = '' if BASE == 'ex' else '_organic'
# ---- WRAM names
names = []
for fn in sorted(glob.glob(os.path.join(WRAM, 'wram_*.csv'))):
    try:
        for r in csv.DictReader(open(fn, newline='', encoding='utf-8')):
            try: names.append((int(r['addr'], 16), int(r.get('size') or 1), r['name']))
            except Exception: pass
    except Exception: pass
names.sort()
def vname(a):
    best = None
    for s, n, nm in names:
        if s <= a < s + max(n, 1): best = (s, nm)
    if best is None: return '$%04X' % a
    return '$%04X %s' % (a, best[1]) if best[0] == a else '$%04X (%s+%d)' % (a, best[1], a - best[0])
# ---- decoder
R8 = ['b', 'c', 'd', 'e', 'h', 'l', '[hl]', 'a']; RR = ['bc', 'de', 'hl', 'sp']; RR2 = ['bc', 'de', 'hl', 'af']; CC = ['nz', 'z', 'nc', 'c']
ALU = ['add a,', 'adc a,', 'sub ', 'sbc a,', 'and ', 'xor ', 'or ', 'cp ']
def s8(x): return x - 256 if x > 127 else x
def pcof(f): return (f & 0x3FFF) + 0x4000 if f >= 0x4000 else f
def mnem(f):
    op = rom[f]; b1 = rom[f + 1]; w = b1 | rom[f + 2] << 8; hi, lo = op >> 4, op & 15
    if op == 0xCB:
        o = b1; r = R8[o & 7]; y = (o >> 3) & 7
        return ['rlc', 'rrc', 'rl', 'rr', 'sla', 'sra', 'swap', 'srl'][y] + ' ' + r if o < 0x40 else ['bit', 'res', 'set'][(o >> 6) - 1] + ' %d,%s' % (y, r)
    if op < 0x40:
        if op == 0: return 'nop'
        if lo == 1: return 'ld %s,$%04x' % (RR[hi], w)
        if lo == 2: return 'ld [%s],a' % ['bc', 'de', 'hl+', 'hl-'][hi]
        if lo == 0xA: return 'ld a,[%s]' % ['bc', 'de', 'hl+', 'hl-'][hi]
        if lo == 3: return 'inc ' + RR[hi]
        if lo == 0xB: return 'dec ' + RR[hi]
        if lo == 9: return 'add hl,' + RR[hi]
        if lo in (4, 0xC): return 'inc ' + R8[(op >> 3) & 7]
        if lo in (5, 0xD): return 'dec ' + R8[(op >> 3) & 7]
        if lo in (6, 0xE): return 'ld %s,$%02x' % (R8[(op >> 3) & 7], b1)
        if op == 8: return 'ld [$%04x],sp' % w
        if op == 0x10: return 'stop'
        if op == 0x18: return 'jr $%04x' % ((pcof(f) + 2 + s8(b1)) & 0xFFFF)
        if op in (0x20, 0x28, 0x30, 0x38): return 'jr %s,$%04x' % (CC[(op >> 3) & 3], (pcof(f) + 2 + s8(b1)) & 0xFFFF)
        return {7: 'rlca', 0xF: 'rrca', 0x17: 'rla', 0x1F: 'rra', 0x27: 'daa', 0x2F: 'cpl', 0x37: 'scf', 0x3F: 'ccf'}.get(op, '?')
    if op < 0x80: return 'halt' if op == 0x76 else 'ld %s,%s' % (R8[(op >> 3) & 7], R8[op & 7])
    if op < 0xC0: return ALU[(op >> 3) & 7] + R8[op & 7]
    if lo in (0, 8) and op < 0xE0: return 'ret ' + CC[(op >> 3) & 3]
    if lo == 1: return 'pop ' + RR2[(op >> 4) - 0xC]
    if lo == 5: return 'push ' + RR2[(op >> 4) - 0xC]
    if lo in (2, 0xA) and op < 0xE0: return 'jp %s,$%04x' % (CC[(op >> 3) & 3], w)
    if lo in (4, 0xC) and op < 0xE0: return 'call %s,$%04x' % (CC[(op >> 3) & 3], w)
    if lo in (6, 0xE): return ALU[(op >> 3) & 7] + '$%02x' % b1
    if lo in (7, 0xF): return 'rst $%02x' % (op & 0x38)
    return {0xC3: 'jp $%04x' % w, 0xC9: 'ret', 0xCD: 'call $%04x' % w, 0xD9: 'reti', 0xE0: 'ldh [$ff%02x],a' % b1, 0xE2: 'ld [c],a', 0xE8: 'add sp,%d' % s8(b1),
            0xE9: 'jp hl', 0xEA: 'ld [$%04x],a' % w, 0xF0: 'ldh a,[$ff%02x]' % b1, 0xF2: 'ld a,[c]', 0xF3: 'di', 0xF8: 'ld hl,sp%+d' % s8(b1), 0xF9: 'ld sp,hl',
            0xFA: 'ld a,[$%04x]' % w, 0xFB: 'ei'}.get(op, 'db $%02x' % op)
def mem_read(f):
    op = rom[f]
    if op == 0xFA: return rom[f + 1] | rom[f + 2] << 8
    if op == 0xF0: return 0xFF00 | rom[f + 1]
    return None
# predecessor on the linear path (executed instruction that falls into f)
pred = {}
for p in np.nonzero(ex & (ilen > 0))[0]:
    p = int(p); q = p + int(ilen[p])
    if q < N and ilen[q] and rom[p] not in (0xC3, 0xC9, 0xD9, 0xE9, 0x18): pred.setdefault(q, []).append(p)
def history(f, n=4):
    out = []; cur = f
    for _ in range(n):
        ps = pred.get(cur)
        if not ps: break
        cur = ps[0]; out.append(cur)
    return out[::-1]
def tested_var(f):
    for p in reversed(history(f, 5)):
        a = mem_read(p)
        if a is not None: return a
    return None
def succs(f):
    op = rom[f]; b1 = rom[f + 1]; w = b1 | rom[f + 2] << 8; bank = f >> 14 if f >= 0x4000 else 0
    def tg(a): return flat(bank if a >= 0x4000 else 0, a) if a < 0x8000 else None
    if op in (0x20, 0x28, 0x30, 0x38): return [tg((pcof(f) + 2 + s8(b1)) & 0xFFFF), f + 2], 'jr'
    if op in (0xC2, 0xCA, 0xD2, 0xDA): return [tg(w), f + 3], 'jp'
    if op in (0xC4, 0xCC, 0xD4, 0xDC): return [tg(w), f + 3], 'call'
    if op in (0xC0, 0xC8, 0xD0, 0xD8): return [None, f + 1], 'ret'
    return None, None
def flow(f):
    """static successors (any kind) of a traced instruction"""
    op = rom[f]; L = int(ilen[f]); b1 = rom[f + 1]; w = b1 | rom[f + 2] << 8; bank = f >> 14 if f >= 0x4000 else 0
    def tg(a): return flat(bank if a >= 0x4000 else 0, a) if a < 0x8000 else None
    if op in (0xC9, 0xD9, 0xE9): return []
    if op == 0x18: return [tg((pcof(f) + 2 + s8(b1)) & 0xFFFF)]
    if op == 0xC3: return [tg(w)]
    if op in (0x20, 0x28, 0x30, 0x38): return [tg((pcof(f) + 2 + s8(b1)) & 0xFFFF), f + 2]
    if op in (0xC2, 0xCA, 0xD2, 0xDA, 0xC4, 0xCC, 0xD4, 0xDC, 0xCD): return [tg(w), f + 3]
    return [f + L]
# ---- unexecuted traced instructions and their components
U = [int(f) for f in np.nonzero((ilen > 0) & ~ex)[0]]
Uset = set(U)
parent = {f: f for f in U}
def find(x):
    while parent[x] != x: parent[x] = parent[parent[x]]; x = parent[x]
    return x
for f in U:
    for s in flow(f):
        if s in Uset: parent[find(s)] = find(f)
comp = collections.defaultdict(list)
for f in U: comp[find(f)].append(f)
# ---- gating edges (executed conditional branch -> unexecuted successor)
gate = []   # (branch, target, side, kind)
for f in np.nonzero(ex & (ilen > 0))[0]:
    f = int(f); s, kind = succs(f)
    if not s: continue
    for side, a in (('taken', s[0]), ('fallthrough', s[1])):
        if a is not None and a in Uset: gate.append((f, a, side, kind))
into = collections.defaultdict(list)
for g in gate: into[find(g[1])].append(g)
# non-gating entries by tracer kind
kinds = collections.defaultdict(collections.Counter)
for k, v in t['entries'].items():
    b, a = k.split(':'); f = flat(int(b, 16), int(a, 16))
    if f in Uset: kinds[find(f)][v if isinstance(v, str) else 'other'] += 1
tblof = collections.defaultdict(list)       # flat target -> ['BB:AAAA[i]', ...]  (inline rst $18 tables, jump tables)
for src in ('tables', 'jtables'):
    for k, tg in t[src].items():
        b = int(k.split(':')[0], 16)
        for i, a in enumerate(tg):
            if a < 0x8000:
                f = flat(b if a >= 0x4000 else 0, a)
                if f in Uset: tblof[f].append('%s[%d]' % (k.upper(), i))
def rw(bank, a): f = flat(bank, a); return rom[f] | rom[f + 1] << 8
# tables the tracer cannot see as inline rst $18 tables (see tools/rom_trace.py manual_roots)
p, limit, n = 0x541A, 0x8000, 0
while p < limit and n < 32:
    tv = rw(0x0A, p)
    if not (0x4000 <= tv < 0x8000): break
    f = flat(0x0A, tv)
    if f in Uset: tblof[f].append('0A:541A[%d] effect table' % n)
    n += 1
    if p < tv < limit: limit = tv
    p += 2
for T, nn_ in ((0x41FA, 62), (0x4276, 62), (0x42F2, 10), (0x4306, 10), (0x431A, 18), (0x433E, 18)):
    for i in range(nn_):
        f = flat(0x1F, rw(0x1F, T + 2 * i))
        if f in Uset: tblof[f].append('1F:%04X[%d] sound cmd' % (T, i))
for b_, bt_ in ((0, 0x0357), ):
    pass
ctab = collections.defaultdict(list)
for f, lst in tblof.items(): ctab[find(f)] += lst
dead = set(); aux = {}
for b, a, note in json.load(open(ROOTS)):
    f = flat(b, a)
    if f not in Uset: continue
    if 'DEAD-CODE' in note: dead.add(find(f))
    elif 'table $541A entry' in note: ctab[find(f)].append('0A:541A[%s] effect table' % note.split('entry')[1].split()[0])
    elif 'OAM-DMA stub' in note: aux[find(f)] = 'RAMCODE'
    elif 'return address pushed' in note: aux[find(f)] = 'RETADDR'
rows = []
for c, members in comp.items():
    ks = kinds.get(c, collections.Counter())
    if into.get(c): cls = 'GATED'
    elif c in dead and not (set(ks) - {'root', 'flow'}): cls = 'DEAD'
    elif aux.get(c): cls = aux[c]
    elif ctab.get(c) or set(ks) & {'rst18', 'jptable', 'far', 'callback', 'vector', 'farjump'}: cls = 'TABLE'
    elif c in dead: cls = 'DEAD'
    else: cls = 'ORPHAN'
    nb = sum(int(ilen[f]) for f in members)
    rows.append(dict(forced=sum(1 for f in members if exall[f]), comp=fmt(min(members)), cls=cls, instrs=len(members), bytes=nb, entries=';'.join('%s:%d' % kv for kv in sorted(ks.items())), tables=';'.join(sorted(set(ctab.get(c, [])))[:4]),
                     gates=';'.join('%s%s' % (fmt(g[0]), '' if g[2] == 'taken' else '(ft)') for g in sorted(into.get(c, []))[:6]), first=min(members), c=c))
rows.sort(key=lambda r: -r['instrs'])
os.makedirs(OUT, exist_ok=True)
with open(os.path.join(OUT, 'unexec_components%s.csv' % SUF), 'w', newline='') as fh:
    w = csv.writer(fh); w.writerow(['first_addr', 'class', 'instrs', 'bytes', 'tracer_entry_kinds', 'gating_branches', 'dispatch_table_entries'])
    for r in rows: w.writerow([r['comp'], r['cls'], r['instrs'], r['bytes'], r['entries'], r['gates'], r['tables']])
# ---- gating branches table, with weight = instructions of the component(s) behind it
def reach_size(start, cap=100000):
    seen = set(); st = [start]
    while st and len(seen) < cap:
        f = st.pop()
        if f is None or f in seen or f not in Uset: continue
        seen.add(f); st += flow(f)
    return len(seen)
grows = []
for f, a, side, kind in gate:
    var = tested_var(f); h = history(f, 3)
    grows.append((reach_size(a), f, a, side, var, ' ; '.join(mnem(p) for p in h), bool(oex[f])))
grows.sort(key=lambda r: -r[0])
with open(os.path.join(OUT, 'gating_branches%s.csv' % SUF), 'w', newline='') as fh:
    w = csv.writer(fh); w.writerow(['branch', 'instr', 'gated_side', 'gated_target', 'unexecuted_instrs_reachable', 'tested_variable', 'preceding_instructions', 'branch_executed_organically'])
    for sz, f, a, side, var, hs, org in grows:
        w.writerow([fmt(f), mnem(f), side, fmt(a), sz, vname(var) if var is not None else '', hs, int(org)])
# ---- summary
tot = len(U); totb = sum(int(ilen[f]) for f in U); nstart = int((ilen > 0).sum())
by = collections.defaultdict(lambda: [0, 0, 0, 0])
for r in rows: by[r['cls']][0] += 1; by[r['cls']][1] += r['instrs']; by[r['cls']][2] += r['bytes']; by[r['cls']][3] += r['forced']
with open(os.path.join(OUT, 'gating_summary%s.md' % SUF), 'w') as fh:
    fh.write('# Never-executed traced code, by gating mechanism\n\n')
    fh.write('Traced instructions: %d; never executed: %d (%d bytes, %.1f %%).\n\n' % (nstart, tot, totb, 100.0 * tot / nstart))
    fh.write('Base coverage: %s.\n\n' % ('all executed code' if BASE == 'ex' else 'organic execution only; "of which forced" = executed in forced-state runs (pokes / forced modes)'))
    fh.write('| class | components | instructions | bytes | of which forced-executed |\n|---|---:|---:|---:|---:|\n')
    for k in ('GATED', 'TABLE', 'DEAD', 'RAMCODE', 'RETADDR', 'ORPHAN'): fh.write('| %s | %d | %d | %d | %d |\n' % (k, *by[k]))
    fh.write('\n## 40 largest components\n\n| first address | class | instrs | bytes | gating branches / dispatch-table entries |\n|---|---|---:|---:|---|\n')
    for r in rows[:40]: fh.write('| %s | %s | %d | %d | %s |\n' % (r['comp'], r['cls'], r['instrs'], r['bytes'], r['gates'] or r['tables'] or r['entries']))
    fh.write('\n## 40 gating branches with the most code behind them\n\n| branch | instr | side | target | instrs reachable | tested variable |\n|---|---|---|---|---:|---|\n')
    for sz, f, a, side, var, hs, org in grows[:40]:
        fh.write('| %s | `%s` | %s | %s | %d | %s |\n' % (fmt(f), mnem(f), side, fmt(a), sz, vname(var) if var is not None else ''))
print(open(os.path.join(OUT, 'gating_summary%s.md' % SUF)).read())
