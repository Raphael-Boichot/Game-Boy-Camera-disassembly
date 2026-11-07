#!/usr/bin/env python3
"""Static recursive-descent tracer for the Pocket Camera (Hello Kitty) ROM (its own engine: tools/rom_trace.py is for the Japanese one).

  tools/kitty_trace.py ROM OUT.json [--roots roms/hello_kitty/disasm/extra_roots_kitty.json] [--report OUT.md]

Goal (HOWTO_NEW_ROM.md Stage B): separate proven code from everything else, with an explicit list of what is not resolved.
A byte is code only if it lies on a decoded path from a root.

Engine conventions taught to the tracer (read in the Kitty listing, 2026-11-07; addresses are bank 0):
  * ROM bank register $2100 (shadow hFF8B), SRAM bank register $4000 (shadow hFF8C).
  * $0150 `jp hl` (call to HL), $0151 `push bc; ret` (to BC), $0153 `push de; ret` (to DE): computed calls, unresolved unless the
    register is a constant on the straight line before the call.
  * $0155 one-way far jump: A = bank, HL = target.
  * $015B far call: B = bank, HL = target; $0165 the same keeping A (through hFF8A). The callee returns through `jp $0173`
    (pop the caller's bank, switch back, ret): `jp $0173` ends a path like `ret`.
  * $017A: return restoring a bank read from the stack (used by SRAM routines): `jp $017A` ends a path like `ret`.
  * $0189: jump table, A = index, HL = table of words (a call through it is resolved when HL is a constant).
  * $0194 and `rst $18`: jump table of words inline after the call, A = index. Length: up to the lowest target seen (a target
    cannot lie inside the table), capped at 64 entries and at the bank end; every word must point into bank 0 or the same bank.
  * $01A0: far jump table, A = index, HL = table of {lo, hi, bank} records, called through $015B (resolved when HL is a constant).
  * `rst $08` / `rst $10` (wait loops) return; `rst $00` is `di; jp $0150`-style reset (path ends).
  * Interrupt vectors $40 / $48 / $50 / $58 / $60 jump to their handlers; the entry is $0100.
  * Routines that take inline arguments after the call (they start with `pop hl`, read the bytes with `ld a,[hl+]` and return with
    `jp hl` or `push hl ... ret`): INLINE_ARGS gives the byte count read from each routine's code; the path continues after them.
Constants: a register value is known when the instruction that last wrote it on the straight line before the use is a load of an
immediate (`ld b,n`, `ld hl,nn`, `ld a,n`, `xor a`), with no call and no label (jump target) in between. Every resolution is rechecked
at the end against the final set of jump targets; a resolution that crossed a target is reported.
Bank-0 code calling $4000-$7FFF directly needs the bank: it is known only after a constant write to $2100 on the straight line before
the call; otherwise the site is reported as `bank0_banked` (unresolved).
"""
import sys, json, argparse, collections

ap = argparse.ArgumentParser()
ap.add_argument('rom'); ap.add_argument('out'); ap.add_argument('--roots', default=None); ap.add_argument('--report', default=None)
a = ap.parse_args()
ROM = open(a.rom, 'rb').read()
FAR, FARA, FARJ, RET0, RET1, JT, JTI, FJT = 0x015B, 0x0165, 0x0155, 0x0173, 0x017A, 0x0189, 0x0194, 0x01A0
CALLHL, CALLBC, CALLDE = 0x0150, 0x0151, 0x0153
# (bank, routine) -> inline argument bytes, counted on each routine's `ld a,[hl+]` reads (2026-11-07)
INLINE_ARGS = {(0, 0x01D1): 2, (0, 0x01DB): 4, (0, 0x01F2): 4, (0, 0x0206): 6, (0, 0x0245): 7, (0, 0x02F9): 11, (0, 0x032D): 10,
               (0, 0x035E): 2, (0, 0x1680): 2, (0, 0x1AB7): 3, (8, 0x6A92): 3, (8, 0x6AE4): 3}
# $1AB7's three bytes are a far callback {lo, hi, bank} stored in hFF97-99 and called through $015B at 00:1B75 (serial / timer path)
FAR_CALLBACK_ARGS = {(0, 0x1AB7)}
# routines that store a bank-0 callback given in DE (the LCDC-interrupt handler jumps to hFFA4/A5, refilled from hFFA6/A7)
CALLBACK_SETTERS = {(0, 0x18B8): 'de', (0, 0x18BF): 'de'}

LEN = [1] * 256
for op in (0x01, 0x08, 0x11, 0x21, 0x31, 0xC2, 0xC3, 0xC4, 0xCA, 0xCC, 0xCD, 0xD2, 0xD4, 0xDA, 0xDC, 0xEA, 0xFA): LEN[op] = 3
for op in (0x06, 0x0E, 0x16, 0x1E, 0x26, 0x2E, 0x36, 0x3E, 0x10, 0x18, 0x20, 0x28, 0x30, 0x38, 0xC6, 0xCB, 0xCE, 0xD6, 0xDE, 0xE0, 0xE6,
           0xE8, 0xEE, 0xF0, 0xF6, 0xF8, 0xFE): LEN[op] = 2
INVALID = {0xD3, 0xDB, 0xDD, 0xE3, 0xE4, 0xEB, 0xEC, 0xED, 0xF4, 0xFC, 0xFD}

def off(b, ad): return ad if ad < 0x4000 else b * 0x4000 + ad - 0x4000
def byte(b, ad): return ROM[off(b, ad)]
def word(b, ad): return byte(b, ad) | byte(b, ad + 1) << 8
def key(b, ad): return '%02X:%04X' % (0 if ad < 0x4000 else b, ad)

# registers written by each opcode (for the straight-line constant scan); CB handled apart
def writes(op, op2=None):
    w = set()
    if op == 0xCB:
        r = op2 & 7; kind = op2 >> 6
        if kind != 1: w.add(['b', 'c', 'd', 'e', 'h', 'l', None, 'a'][r])     # bit n,r writes nothing
        return w - {None}
    R = ['b', 'c', 'd', 'e', 'h', 'l', None, 'a']
    if 0x40 <= op <= 0x7F and op != 0x76:
        d = R[(op >> 3) & 7]
        if d: w.add(d)
    elif 0x80 <= op <= 0xB7: w.add('a')
    pairs = {0x01: 'bc', 0x11: 'de', 0x21: 'hl', 0xC1: 'bc', 0xD1: 'de', 0xE1: 'hl', 0xF1: 'a', 0x03: 'bc', 0x0B: 'bc', 0x13: 'de', 0x1B: 'de',
             0x23: 'hl', 0x2B: 'hl', 0x09: 'hl', 0x19: 'hl', 0x29: 'hl', 0x39: 'hl', 0xF8: 'hl', 0x22: 'hl', 0x2A: 'hla', 0x32: 'hl', 0x3A: 'hla'}
    if op in pairs: w |= set(pairs[op])
    single = {0x04: 'b', 0x05: 'b', 0x06: 'b', 0x0C: 'c', 0x0D: 'c', 0x0E: 'c', 0x14: 'd', 0x15: 'd', 0x16: 'd', 0x1C: 'e', 0x1D: 'e', 0x1E: 'e',
              0x24: 'h', 0x25: 'h', 0x26: 'h', 0x2C: 'l', 0x2D: 'l', 0x2E: 'l', 0x3C: 'a', 0x3D: 'a', 0x3E: 'a'}
    if op in single: w.add(single[op])
    if op in (0x0A, 0x1A, 0x07, 0x0F, 0x17, 0x1F, 0x27, 0x2F, 0xC6, 0xCE, 0xD6, 0xDE, 0xE6, 0xEE, 0xF6, 0xF0, 0xF2, 0xFA): w.add('a')
    return w

code = {}            # (bank, addr) -> length   (bank 0 for addr < $4000)
inline = {}          # (bank, addr) -> table key that owns this byte
targets = set()      # jump / call targets (labels: the constant scan stops there)
pred = {}            # fall-through predecessor: (b, ad) -> (b, ad) of the instruction before
entries = {}         # root -> why
unresolved = []      # [kind, bank, addr, detail]
ramcalls = []
edges = collections.defaultdict(set)   # root -> roots it pushes (calls, jumps, tables)
owner = {}            # instruction -> root of the walk that decoded it
cur_root = [None]
args = {}            # call site -> inline argument bytes
far_ok = []          # [bank, site, target bank, target]
resolutions = []     # [bank, site, path of addresses scanned] for the final recheck
tables = {}          # inline / constant tables: key -> list of targets
caps = {}         # hand-read table lengths (extra roots file, 'tables')
ctables = {}      # tables at constant addresses (HL): key -> site, width, records
work = collections.deque()

def push(b, ad, why):
    if cur_root[0] is not None: edges[cur_root[0]].add((0 if ad < 0x4000 else b, ad))
    if ad >= 0x8000: unresolved.append(['ram_target', b, ad, why]); return
    b = 0 if ad < 0x4000 else b
    targets.add((b, ad))
    if (b, ad) not in entries: entries[(b, ad)] = why
    work.append((b, ad))

def scan_const(b, ad, reg):
    """walk back on the fall-through path from the instruction at (b, ad) (exclusive); return (value or None, path)."""
    path = []; cur = pred.get((b, ad)); want = reg
    while cur is not None and len(path) < 40:
        cb, ca = cur
        op = byte(cb, ca); op2 = byte(cb, ca + 1) if op == 0xCB else None
        if op in (0xCD, 0xC4, 0xCC, 0xD4, 0xDC) or 0xC7 <= op <= 0xFF and (op & 7) == 7: return None, path   # call / rst clobbers
        w = writes(op, op2)
        if reg == 'b' and 'b' in w: return (byte(cb, ca + 1) if op == 0x06 else word(cb, ca + 1) >> 8 if op == 0x01 else None), path
        if reg == 'a' and 'a' in w:
            return (byte(cb, ca + 1) if op == 0x3E else 0 if op == 0xAF else None), path
        if reg == 'hl' and ('h' in w or 'l' in w): return (word(cb, ca + 1) if op == 0x21 else None), path
        if reg == 'c' and 'c' in w: return (byte(cb, ca + 1) if op == 0x0E else word(cb, ca + 1) & 0xFF if op == 0x01 else None), path
        if reg == 'de' and ('d' in w or 'e' in w): return (word(cb, ca + 1) if op == 0x11 else None), path
        if reg == 'bank':      # last constant write to $2100 (ld [$2100],a with a constant A)
            if op == 0xEA and word(cb, ca + 1) in (0x2000, 0x2100):
                v, p2 = scan_const(cb, ca, 'a'); return v, path + p2
        if cur in targets: return None, path
        path.append(cur)      # crossed without a write: rechecked against the final targets
        cur = pred.get(cur)
    return None, path

def inline_table(b, tab, why, owner):
    """read an inline word table at (b, tab): stop at the lowest target seen, at 64 entries, at a word that is not code space."""
    lo = 0x10000; out = []; i = tab
    while len(out) < 64 and i + 1 < (0x4000 if tab < 0x4000 else 0x8000) and i < lo:
        t = word(b, i)
        if not (t < 0x4000 or (b and 0x4000 <= t < 0x8000)): break
        if key(b, tab) in caps and len(out) >= caps[key(b, tab)]: break
        if t >= tab and t < lo: lo = t
        out.append(t); i += 2
        if i >= lo: break
    for k in range(tab, tab + 2 * len(out)): inline[(0 if tab < 0x4000 else b, k)] = key(b, tab)
    tables[key(b, tab)] = out
    for t in out: push(b, t, 'table %s (%s)' % (key(b, tab), why))
    return out

def const_table(b, tab, width, site):
    """a table at a constant address (HL) read by $0189 (words) or $01A0 ({lo, hi, bank}): read records until the lowest target that
    falls after the table start in the table's own bank, an invalid record, 64 records or the bank end; listed in `ctables` for review."""
    tb = 0 if tab < 0x4000 else b; out = []; i = tab; end = 0x4000 if tab < 0x4000 else 0x8000
    lo = min([ad for (bk, ad) in targets if bk == tb and ad > tab] + [end])
    while len(out) < 64 and i + width <= min(lo, end):
        t = word(tb, i); tbk = byte(tb, i + 2) if width == 3 else tb
        if width == 3 and not (tbk < 0x40 and (t < 0x4000 or 0x4000 <= t < 0x8000)): break
        if width == 2 and not ((tb == 0 and t < 0x4000) or (tb and 0x4000 <= t < 0x8000)): break
        if key(tb, tab) in caps and len(out) >= caps[key(tb, tab)]: break
        out.append((tbk, t)); i += width
        if t < 0x4000 and tb == 0 and tab < t < lo: lo = t
        if tbk == tb and tab < t < lo: lo = t
    ctables[key(tb, tab)] = {'site': site, 'width': width, 'records': ['%02X:%04X' % r for r in out]}
    for k in range(tab, tab + width * len(out)): inline.setdefault((tb, k), key(tb, tab))
    for tbk, t in out: push(tbk, t, 'table %s' % key(tb, tab))

def callback(bb, ad, tk):
    v, p = scan_const(bb, ad, CALLBACK_SETTERS[tk])
    if v is None: unresolved.append(['callback_' + CALLBACK_SETTERS[tk], bb, ad, 'setter %s' % key(*tk)])
    else: resolutions.append([bb, ad, p]); push(bb, v, 'callback given to %s' % key(*tk))

def step(b, ad):
    origin = entries.get((0 if ad < 0x4000 else b, ad), '')
    cur_root[0] = (0 if ad < 0x4000 else b, ad)
    while True:
        bb = 0 if ad < 0x4000 else b
        if (bb, ad) in code: return
        if (bb, ad) in inline: unresolved.append(['into_table', bb, ad, inline[(bb, ad)] + ' <- ' + origin]); return
        if ad >= 0x8000: unresolved.append(['ram_flow', bb, ad, ('') + ' <- ' + origin]); return
        op = byte(bb, ad)
        if op in INVALID: unresolved.append(['invalid_opcode', bb, ad, ('%02X' % op) + ' <- ' + origin]); return
        n = LEN[op]
        if op == 0x10: n = 2
        if ad + n > (0x4000 if ad < 0x4000 else 0x8000): unresolved.append(['bank_end', bb, ad, ('') + ' <- ' + origin]); return
        for k in (1, 2):
            if code.get((bb, ad - k), 0) > k: unresolved.append(['overlap', bb, ad, ('inside the instruction at %04X' % (ad - k)) + ' <- ' + origin]); break
        for k in range(1, n):
            if (bb, ad + k) in code: unresolved.append(['overlap', bb, ad, ('into an instruction') + ' <- ' + origin]); break
        code[(bb, ad)] = n; owner[(bb, ad)] = cur_root[0]; cur_root[0] = (bb, ad)
        nxt = ad + n
        def fall(): pred[(bb, nxt)] = (bb, ad)
        if op == 0x18: push(bb, (nxt + (byte(bb, ad + 1) ^ 0x80) - 0x80) & 0xFFFF, 'jr'); return
        if op in (0x20, 0x28, 0x30, 0x38): push(bb, (nxt + (byte(bb, ad + 1) ^ 0x80) - 0x80) & 0xFFFF, 'jr cc')
        elif op == 0xC3 or op in (0xC2, 0xCA, 0xD2, 0xDA):
            t = word(bb, ad + 1)
            if t in (RET0, RET1):
                if op == 0xC3: return
            elif t >= 0x4000 and bb == 0:
                v, p = scan_const(bb, ad, 'bank')
                if v is None: unresolved.append(['bank0_banked', bb, ad, 'jp %04X' % t])
                else: resolutions.append([bb, ad, p]); push(v, t, 'jp after bank %02X' % v)
            else:
                push(bb, t, 'jp')
                if (0 if t < 0x4000 else bb, t) in CALLBACK_SETTERS: callback(bb, ad, (0 if t < 0x4000 else bb, t))
            if op == 0xC3: return
        elif op in (0xCD, 0xC4, 0xCC, 0xD4, 0xDC):
            t = word(bb, ad + 1)
            if t in (FAR, FARA):
                vb, p1 = scan_const(bb, ad, 'b'); vh, p2 = scan_const(bb, ad, 'hl')
                if vb is None or vh is None: unresolved.append(['farcall', bb, ad, 'B=%s HL=%s' % (vb, None if vh is None else '%04X' % vh)])
                else:
                    resolutions.append([bb, ad, p1 + p2]); far_ok.append([bb, ad, vb, vh]); push(vb, vh, 'far call from %s' % key(bb, ad))
            elif t == FARJ:
                va, p1 = scan_const(bb, ad, 'a'); vh, p2 = scan_const(bb, ad, 'hl')
                if va is None or vh is None: unresolved.append(['farjump', bb, ad, ''])
                else: resolutions.append([bb, ad, p1 + p2]); far_ok.append([bb, ad, va, vh]); push(va, vh, 'far jump from %s' % key(bb, ad))
                return
            elif t == JTI:
                inline_table(bb, nxt, 'call $0194', key(bb, ad)); return
            elif t == JT:
                vh, p = scan_const(bb, ad, 'hl')
                if vh is None: unresolved.append(['jumptable', bb, ad, 'HL unknown'])
                else: resolutions.append([bb, ad, p]); const_table(bb, vh, 2, key(bb, ad))
            elif t == FJT:
                vh, p = scan_const(bb, ad, 'hl')
                if vh is None: unresolved.append(['far_jumptable', bb, ad, 'HL unknown'])
                else: resolutions.append([bb, ad, p]); const_table(bb, vh, 3, key(bb, ad))
            elif t in (CALLHL, CALLBC, CALLDE):
                r = {CALLHL: 'hl', CALLBC: 'bc', CALLDE: 'de'}[t]
                v, p = scan_const(bb, ad, 'hl') if r == 'hl' else (None, [])
                if v is None: unresolved.append(['call_' + r, bb, ad, ''])
                else: resolutions.append([bb, ad, p]); push(bb, v, 'call hl const')
            elif t == 0xFF80: ramcalls.append([bb, ad, t])      # OAM-DMA stub copied to HRAM (to be checked: its source)
            elif t >= 0x4000 and bb == 0:
                v, p = scan_const(bb, ad, 'bank')
                if v is None: unresolved.append(['bank0_banked', bb, ad, 'call %04X' % t])
                else: resolutions.append([bb, ad, p]); push(v, t, 'call after bank %02X' % v)
            else:
                push(bb, t, 'call')
                tk = (0 if t < 0x4000 else bb, t)
                if tk in CALLBACK_SETTERS: callback(bb, ad, tk)
                na = INLINE_ARGS.get(tk)
                if tk in FAR_CALLBACK_ARGS: far_ok.append([bb, ad, byte(bb, nxt + 2), word(bb, nxt)]); push(byte(bb, nxt + 2), word(bb, nxt), 'far callback (args of %s)' % key(bb, ad))
                if na:
                    for k in range(nxt, nxt + na): inline[(bb, k)] = 'args %s' % key(bb, ad)
                    args[key(bb, ad)] = na; nxt += na
        elif op in (0xC9, 0xD9): return
        elif op in (0xC0, 0xC8, 0xD0, 0xD8): pass
        elif op == 0xE9: unresolved.append(['jp_hl', bb, ad, '']); return
        elif 0xC7 <= op and (op & 7) == 7:
            v = op - 0xC7
            if v == 0x18: inline_table(bb, nxt, 'rst $18', key(bb, ad)); return
            if v == 0x00: return
            if v not in (0x08, 0x10): push(0, v, 'rst')
        elif op == 0x76 or op == 0x10: pass
        fall(); ad = nxt

roots = [(0, 0x0100, 'entry'), (0, 0x0040, 'vblank'), (0, 0x0048, 'lcdc'), (0, 0x0050, 'timer'), (0, 0x0058, 'serial'), (0, 0x0060, 'joypad'),
         (0, 0x0008, 'rst $08'), (0, 0x0010, 'rst $10'), (0, 0x0018, 'rst $18 body'), (0, 0x0150, 'helper'), (0, 0x0151, 'helper'), (0, 0x0153, 'helper'),
         (0, FARJ, 'helper'), (0, FAR, 'helper'), (0, FARA, 'helper'), (0, RET0, 'helper'), (0, RET1, 'helper'), (0, JT, 'helper'), (0, JTI, 'helper'), (0, FJT, 'helper')]
hand = json.load(open(a.roots)) if a.roots else {'roots': [], 'resolved': []}
caps.update({k: v['n'] for k, v in hand.get('tables', {}).items()})
for r in hand.get('roots', []): roots.append((int(r['bank'], 16), int(r['addr'], 16), 'hand: ' + r['why']))
for b, ad, why in roots: entries[(0 if ad < 0x4000 else b, ad)] = why; work.append((b, ad)); targets.add((0 if ad < 0x4000 else b, ad))
# helper bodies end in `jp hl` / `ret` with register targets: they are resolved per call site, not reported
helper_jphl = {(0, 0x01DA), (0, 0x032C), (0, 0x035D), (0, 0x1AC1), (0, 0x18DD), (0, 0x1B75), (0, 0x01AE), (0, 0x0150), (0, 0x015A), (0, 0x0164), (0, 0x0172), (0, 0x0193), (0, 0x019F), (0, 0x0023)}
while work: step(*work.popleft())
# resolved by hand: drop listed unresolved sites
done = {(int(r['bank'], 16), int(r['addr'], 16)) for r in hand.get('resolved', [])}
unresolved = [u for u in unresolved if (u[1], u[2]) not in helper_jphl and (u[1], u[2]) not in done]
# recheck the constant scans against the final targets
for bb, ad, path in resolutions:
    for c in path:
        if c in targets: unresolved.append(['crossed_label', bb, ad, key(*c)]); break
# state-table check (a report, not a rule; mode / state setters: $01B2 mode = A, $01BD state = A, $01C8 mode = B and state = C,
# $01D1 inline {mode, state}): for each word table indexed by hFF8E (the state of mode hFF8D), the constant states
# stored to hFF8E by the code reachable from the table's handlers, plus states stored next to a constant store of that mode
# anywhere (`ld a,m / ldh [$8D],a` within 12 bytes of `ld a,s / ldh [$8E],a`): entries past the highest such state are suspect
# edges[i] = targets pushed by instruction i (cur_root follows the instruction being decoded); fall-through from pred
succ = collections.defaultdict(set)
for i, ts in edges.items(): succ[i] |= ts
for nx, pv in pred.items(): succ[pv].add(nx)
def closure(roots):
    seen = set(roots); st = list(roots)
    while st:
        r = st.pop()
        for c in succ.get(r, ()):
            if c not in seen and c in code: seen.add(c); st.append(c)
    return seen
instr_by_root = {k_: [k_] for k_ in code}
def stores(rs):
    out = set()
    for r in rs:
        for (cb, ca) in instr_by_root.get(r, ()):
            if byte(cb, ca) == 0x3E and code.get((cb, ca + 2)) == 2 and byte(cb, ca + 2) == 0xE0 and byte(cb, ca + 3) == 0x8E: out.add(byte(cb, ca + 1))
            if byte(cb, ca) == 0xCD and word(cb, ca + 1) == 0x01BD:       # set state = A
                v, _ = scan_const(cb, ca, 'a')
                if v is not None: out.add(v)
    return out
mode_of_table = {}
mt = ctables.get('00:0D00', {}).get('records', [])
for i, r in enumerate(mt):
    rb_, ra_ = int(r[:2], 16), int(r[3:], 16)
    for (cb, ca) in sorted(closure([(rb_, ra_)]))[:0] or [x for x in closure([(rb_, ra_)]) if x[0] == rb_ and ra_ <= x[1] < ra_ + 24]:
        if byte(cb, ca) == 0xCD and word(cb, ca + 1) == JT:
            vh, _ = scan_const(cb, ca, 'hl')
            if vh is not None: mode_of_table[key(cb, vh)] = i
pairs = collections.defaultdict(set)
for (cb, ca), n_ in code.items():
    if byte(cb, ca) == 0xCD and word(cb, ca + 1) == 0x01C8:             # set mode B, state C
        vb, _ = scan_const(cb, ca, 'b'); vc, _ = scan_const(cb, ca, 'c')
        if vb is not None and vc is not None: pairs[vb].add(vc)
    if byte(cb, ca) == 0xCD and word(cb, ca + 1) == 0x01D1:             # inline {mode, state}
        pairs[byte(cb, ca + 3)].add(byte(cb, ca + 4))
    if byte(cb, ca) == 0x3E and byte(cb, ca + 2) == 0xE0 and byte(cb, ca + 3) == 0x8D:
        m_ = byte(cb, ca + 1)
        for d in range(-12, 13):
            x = ca + d
            if code.get((cb, x)) == 2 and byte(cb, x) == 0x3E and byte(cb, x + 2) == 0xE0 and byte(cb, x + 3) == 0x8E: pairs[m_].add(byte(cb, x + 1))
state_check = {}
for tk, m_ in mode_of_table.items():
    recs = ctables[tk]['records']; hs = [(int(r[:2], 16), int(r[3:], 16)) for r in recs]
    st_ = stores(closure(hs)) | pairs.get(m_, set()) | {0}
    state_check[tk] = {'mode': '%02X' % m_, 'read': len(recs), 'states_stored': sorted(st_), 'suspect_from': max(st_) + 1 if max(st_) + 1 < len(recs) else None}
uk = collections.Counter(u[0] for u in unresolved)
nb = collections.Counter(b for (b, ad) in code)
out = {'code': {key(b, ad): n for (b, ad), n in sorted(code.items())},
       'inline': {key(b, ad): t for (b, ad), t in sorted(inline.items())},
       'unresolved': sorted(unresolved, key=lambda u: (u[1], u[2])), 'far_ok': far_ok, 'tables': tables, 'ctables': ctables, 'ramcalls': ramcalls, 'args': args, 'state_check': state_check,
       'entries': {key(b, ad): w for (b, ad), w in sorted(entries.items())}}
json.dump(out, open(a.out, 'w'), indent=0)
nbytes = sum(code.values())
print('kitty_trace: %d instructions, %d code bytes, %d inline table bytes, %d far calls resolved, %d unresolved %s' % (
    len(code), nbytes, len(inline), len(far_ok), len(unresolved), dict(uk)))
if a.report:
    with open(a.report, 'w') as f:
        f.write('# Kitty static trace: unresolved sites\n\nGenerated by `tools/kitty_trace.py`. %d instructions, %d code bytes, %d unresolved.\n\n| kind | site | detail |\n|---|---|---|\n' % (len(code), nbytes, len(unresolved)))
        for u in out['unresolved']: f.write('| %s | %s | %s |\n' % (u[0], key(u[1], u[2]), u[3]))
