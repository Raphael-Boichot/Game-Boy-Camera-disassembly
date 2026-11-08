#!/usr/bin/env python3
"""Static recursive-descent tracer for the early prototype (Pocket Camera Prototype (Japan), "DEBAGAME"): its own engine.

  tools/proto_trace.py PROTO.gb OUT.json [--roots roms/prototype_debagame/disasm/extra_roots_proto.json] [--report OUT.md]

PROTO.gb is the image as dumped (md5 19b50a5f67ef4f0d015e7d813370756e, owner's rule 2026-11-08). Goal (HOWTO_NEW_ROM.md Stage B):
separate proven code from everything else, with an explicit list of what is not resolved. A byte is code only if it lies on a
decoded path from a root. The decoder core is the one of tools/kitty_trace.py; the engine conventions differ.

Engine conventions taught to the tracer (read in the no-symbol listing, 2026-11-08; addresses are bank 0):
  * No banked-call helper. Every bank switch is written inline: `ldh a,[$FFFD]; push af` (save BANK_BUF), `ld a,N; ldh [$FFFD],a;
    ld [$2100],a` (select bank N), the work, then `pop af; ldh [$FFFD],a; ld [$2100],a` (restore). A path carries a BANK CONTEXT: the
    bank of the last write of a constant A to $2000-$3FFF on that path (None after any other write, e.g. the restore).
  * A call or jump from bank 0 to $4000-$7FFF goes to the bank of the context; with no context it is reported (`bank0_banked`).
  * Bank-0 code is walked once per (instruction, context) pair, so a shared routine (the copy loop at $02B9) is followed under
    every bank it is called with. A banked site reached with two banks resolves to both and is listed as a report line
    (`banked_multi`), not an error.
  * The context survives calls to bank-0 routines. Checked, not trusted: a bank-0 callee that selects a bank must also restore
    one (`pop af; ldh [$FFFD],a; ld [$2000-$3FFF],a`) on its own paths, otherwise the call site is reported (`bank_switch_callee`).
  * `rst $28`: jump table of words inline after the rst, A = index (`add a; pop hl; ...; jp hl`). Length: up to the lowest target
    seen (a target cannot lie inside the table), capped at 64 entries and at the bank end; every word must point into bank 0 or the
    same bank; a hand length in the extra roots file ('tables': {"BB:AAAA": {"n": N, "why": ...}}) wins.
  * `rst $30` jumps to the word at HL with its low byte already in E (the tail of `rst $28`): a computed jump, reported (`rst30`).
  * `rst $00` and `rst $08` jump to the boot code $0150 (path ends). `rst $38` is the fill byte $FF: reaching it ends the path and
    is reported (`rst38`): executed, it pushes and jumps to itself forever.
  * A write to $2000-$3FFF from a bank other than 0 maps that bank out under its own code: reported (`bank_write_banked`).
  * Interrupt vectors $40 / $48 / $50 / $58 jump to their handlers ($60 is fill); the entry is $0100.
Constants: a register value is known when the instruction that last wrote it on the straight line before the use is a load of an
immediate (`ld a,n`, `ld hl,nn`, `xor a`), with no call and no label (jump target) in between. Every resolution is rechecked at
the end against the final set of jump targets; a resolution that crossed a target is reported (`crossed_label`).
Hand input (extra roots file): 'roots' [{bank, addr, why}], 'resolved' [{bank, addr, why}] (drops that site from the report),
'tables' (inline table lengths), 'jtables' {"BB:AAAA" (the `jp hl`): {table, n, why}} (an indexed word table read by that jump:
its words become roots, its bytes inline table bytes, the site is resolved). Every entry carries its reason.
"""
import sys, json, argparse, collections, hashlib

ap = argparse.ArgumentParser()
ap.add_argument('rom'); ap.add_argument('out'); ap.add_argument('--roots', default=None); ap.add_argument('--report', default=None)
a = ap.parse_args()
ROM = open(a.rom, 'rb').read()
if hashlib.md5(ROM).hexdigest() != '19b50a5f67ef4f0d015e7d813370756e': sys.exit('proto_trace: expected the prototype as dumped (md5 19b50a5f...)')

LEN = [1] * 256
for op in (0x01, 0x08, 0x11, 0x21, 0x31, 0xC2, 0xC3, 0xC4, 0xCA, 0xCC, 0xCD, 0xD2, 0xD4, 0xDA, 0xDC, 0xEA, 0xFA): LEN[op] = 3
for op in (0x06, 0x0E, 0x16, 0x1E, 0x26, 0x2E, 0x36, 0x3E, 0x10, 0x18, 0x20, 0x28, 0x30, 0x38, 0xC6, 0xCB, 0xCE, 0xD6, 0xDE, 0xE0, 0xE6,
           0xE8, 0xEE, 0xF0, 0xF6, 0xF8, 0xFE): LEN[op] = 2
INVALID = {0xD3, 0xDB, 0xDD, 0xE3, 0xE4, 0xEB, 0xEC, 0xED, 0xF4, 0xFC, 0xFD}
CALLS = (0xCD, 0xC4, 0xCC, 0xD4, 0xDC)
JUMPS = (0xC3, 0xC2, 0xCA, 0xD2, 0xDA)
JRS = (0x18, 0x20, 0x28, 0x30, 0x38)

def off(b, ad): return ad if ad < 0x4000 else b * 0x4000 + ad - 0x4000
def byte(b, ad): return ROM[off(b, ad)]
def word(b, ad): return byte(b, ad) | byte(b, ad + 1) << 8
def key(b, ad): return '%02X:%04X' % (0 if ad < 0x4000 else b, ad)
def norm(b, ad): return (0 if ad < 0x4000 else b, ad)
def jr_target(b, ad): return (ad + 2 + (byte(b, ad + 1) ^ 0x80) - 0x80) & 0xFFFF

def writes(op, op2=None):
    """registers written by an opcode (for the straight-line constant scan)"""
    w = set(); R = ['b', 'c', 'd', 'e', 'h', 'l', None, 'a']
    if op == 0xCB:
        if op2 >> 6 != 1 and R[op2 & 7]: w.add(R[op2 & 7])
        return w
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

code = {}; inline = {}; targets = set(); pred = {}; entries = {}; unresolved = []; tables = {}; caps = {}
ctx_of = collections.defaultdict(set)   # bank-0 instruction -> bank contexts it was walked with
visited = set()                          # (bank, addr, context)
resolutions = []      # [bank, site, path] for the final recheck
banked = []           # [site, target bank, target]: calls / jumps from bank 0 resolved by the context
switchers = set()     # bank-0 writes of a constant bank
restores = set()      # bank-0 writes of the saved bank
calls0 = []           # (site, bank-0 callee, context)
work = collections.deque()
reported = set()

def report(kind, b, ad, detail):
    if (kind, b, ad) not in reported: reported.add((kind, b, ad)); unresolved.append([kind, b, ad, detail])

def push(b, ad, why, ctx):
    if ad >= 0x8000: report('ram_target', b, ad, why); return
    k = norm(b, ad); targets.add(k)
    if k not in entries: entries[k] = why
    work.append((k[0], ad, ctx if ad < 0x4000 else None))

def scan_const(b, ad, reg):
    """walk back on the fall-through path from (b, ad), exclusive: (value or None, path crossed)"""
    path = []; cur = pred.get((b, ad))
    while cur is not None and len(path) < 40:
        cb, ca = cur; op = byte(cb, ca); op2 = byte(cb, ca + 1) if op == 0xCB else None
        if op in CALLS or (op >= 0xC7 and (op & 7) == 7): return None, path
        w = writes(op, op2)
        if reg == 'a' and 'a' in w: return (byte(cb, ca + 1) if op == 0x3E else 0 if op == 0xAF else None), path
        if reg == 'hl' and ('h' in w or 'l' in w): return (word(cb, ca + 1) if op == 0x21 else None), path
        if cur in targets: return None, path
        path.append(cur); cur = pred.get(cur)
    return None, path

def is_restore(b, ad):
    p1 = pred.get((b, ad)); p2 = pred.get(p1) if p1 else None
    return bool(p1 and p2 and byte(*p1) == 0xE0 and byte(p1[0], p1[1] + 1) == 0xFD and byte(*p2) == 0xF1)

def inline_table(b, tab, why, ctx):
    if key(b, tab) in tables:
        for t in tables[key(b, tab)]: push(b, t, 'table %s (%s)' % (key(b, tab), why), ctx)
        return
    lo = 0x10000; out = []; i = tab; end = 0x4000 if tab < 0x4000 else 0x8000
    while len(out) < 64 and i + 1 < end and i < lo:
        t = word(b, i)
        if not (t < 0x4000 or (b and 0x4000 <= t < 0x8000)): break
        if key(b, tab) in caps and len(out) >= caps[key(b, tab)]: break
        if tab <= t < lo: lo = t
        out.append(t); i += 2
        if i >= lo: break
    for k in range(tab, tab + 2 * len(out)): inline[norm(b, k)] = key(b, tab)
    tables[key(b, tab)] = out
    for t in out: push(b, t, 'table %s (%s)' % (key(b, tab), why), ctx)

def step(b, ad, ctx):
    origin = entries.get(norm(b, ad), '')
    while True:
        bb = 0 if ad < 0x4000 else b
        if bb: ctx = None                                    # banked code does not switch (checked: bank_write_banked)
        if (bb, ad, ctx) in visited: return
        visited.add((bb, ad, ctx))
        again = (bb, ad) in code                             # decoded before under another context: walk it again, report once
        if not again:
            if (bb, ad) in inline: report('into_table', bb, ad, inline[(bb, ad)] + ' <- ' + origin); return
            if ad >= 0x8000: report('ram_flow', bb, ad, '<- ' + origin); return
            if byte(bb, ad) in INVALID: report('invalid_opcode', bb, ad, '%02X <- %s' % (byte(bb, ad), origin)); return
            if ad + LEN[byte(bb, ad)] > (0x4000 if ad < 0x4000 else 0x8000): report('bank_end', bb, ad, '<- ' + origin); return
            for k in (1, 2):
                if code.get((bb, ad - k), 0) > k: report('overlap', bb, ad, 'inside the instruction at %04X <- %s' % (ad - k, origin)); break
            for k in range(1, LEN[byte(bb, ad)]):
                if (bb, ad + k) in code: report('overlap', bb, ad, 'into an instruction <- ' + origin); break
        op = byte(bb, ad); n = LEN[op]; code[(bb, ad)] = n
        if bb == 0 and ctx is not None: ctx_of[(bb, ad)].add(ctx)
        nxt = ad + n
        CC_ = {0x20: 0, 0x28: 1, 0x30: 2, 0x38: 3, 0xC2: 0, 0xCA: 1, 0xD2: 2, 0xDA: 3}
        pv = pred.get((bb, ad))
        always = op in CC_ and pv is not None and byte(*pv) in CC_ and (CC_[byte(*pv)] ^ 1) == CC_[op] and (bb, ad) not in targets
        if op == 0x18: push(bb, jr_target(bb, ad), 'jr', ctx); return
        if op in JRS:
            push(bb, jr_target(bb, ad), 'jr cc', ctx)
            if always: return
        elif op in JUMPS or op in CALLS:
            t = word(bb, ad + 1); kind = 'call' if op in CALLS else 'jp'
            if 0x4000 <= t < 0x8000 and bb == 0:
                if ctx is None: report('bank0_banked', bb, ad, '%s %04X with no bank context <- %s' % (kind, t, origin))
                else: banked.append([key(bb, ad), '%02X' % ctx, '%04X' % t]); push(ctx, t, '%s after bank %02X (%s)' % (kind, ctx, key(bb, ad)), ctx)
            else:
                push(bb, t, kind, ctx)
                if kind == 'call' and t < 0x4000: calls0.append(((bb, ad), (0, t), ctx))
            if op == 0xC3 or always: return
        elif op == 0xEA and 0x2000 <= word(bb, ad + 1) < 0x4000:
            if bb: report('bank_write_banked', bb, ad, 'ld [%04X],a in bank %02X <- %s' % (word(bb, ad + 1), bb, origin))
            else:
                v, p = scan_const(bb, ad, 'a')
                if v is not None: resolutions.append([bb, ad, p]); switchers.add((bb, ad))
                elif is_restore(bb, ad): restores.add((bb, ad))
                else: report('bank_write_unknown', bb, ad, 'A not a constant and not the saved bank')
                ctx = v
        elif op in (0xC9, 0xD9): return
        elif op == 0xE9: report('jp_hl', bb, ad, '<- ' + origin); return
        elif op >= 0xC7 and (op & 7) == 7:
            v = op - 0xC7
            if v == 0x28: inline_table(bb, nxt, 'rst $28 at %s' % key(bb, ad), ctx); return
            if v == 0x30: report('rst30', bb, ad, '<- ' + origin); return
            if v == 0x38: report('rst38', bb, ad, '<- ' + origin); return
            if v in (0x00, 0x08): return
            push(0, v, 'rst', ctx)
        pred[(bb, nxt)] = (bb, ad); ad = nxt

roots = [(0, 0x0100, 'entry'), (0, 0x0040, 'vblank'), (0, 0x0048, 'lcdc'), (0, 0x0050, 'timer'), (0, 0x0058, 'serial')]
hand = json.load(open(a.roots)) if a.roots else {}
caps.update({k: v['n'] for k, v in hand.get('tables', {}).items()})
for r in hand.get('roots', []): roots.append((int(r['bank'], 16), int(r['addr'], 16), 'hand: ' + r['why']))
for site, v in hand.get('jtables', {}).items():
    tb, ta = int(v['table'][:2], 16), int(v['table'][3:], 16)
    recs = [word(tb, ta + 2 * i) for i in range(v['n'])]
    for k in range(ta, ta + 2 * v['n']): inline[norm(tb, k)] = key(tb, ta)
    tables[key(tb, ta)] = recs
    for t in recs: roots.append((tb, t, 'hand table %s (jp hl at %s)' % (key(tb, ta), site)))
hand_sites = {(int(s_[:2], 16), int(s_[3:], 16)) for s_ in hand.get('jtables', {})}
for b, ad, why in roots:
    k = norm(b, ad); entries[k] = why; targets.add(k); work.append((k[0], ad, None))
while work: step(*work.popleft())

# a bank-0 callee that selects a bank must restore one: walk its bank-0 instructions (fall-through and jumps, not calls)
succ = collections.defaultdict(set)
for nx, pv in pred.items(): succ[pv].add(nx)
def callee_writes(t):
    st = [t]; seen = set(); sel = rest = False
    while st and len(seen) < 4000:
        c = st.pop()
        if c in seen or c not in code or c[0]: continue
        seen.add(c); sel |= c in switchers; rest |= c in restores
        op = byte(*c)
        if op in JRS: st.append((0, jr_target(*c)))
        if op in JUMPS: st.append((0, word(c[0], c[1] + 1)))
        st.extend(succ.get(c, ()))
    return sel, rest
cw = {}
for site, callee, ctx in calls0:
    if ctx is None: continue
    if callee not in cw: cw[callee] = callee_writes(callee)
    sel, rest = cw[callee]
    if sel and not rest: report('bank_switch_callee', site[0], site[1], 'call %04X selects a bank and never restores one (context %02X carried past it)' % (callee[1], ctx))
multi = collections.defaultdict(set)
for site, bk, t in banked: multi[site].add(bk)
report_only = [['banked_multi', int(s_[:2], 16), int(s_[3:], 16), 'banks ' + ' '.join(sorted(v))] for s_, v in sorted(multi.items()) if len(v) > 1]
done = {(int(r['bank'], 16), int(r['addr'], 16)) for r in hand.get('resolved', [])} | hand_sites
unresolved = [u for u in unresolved if (u[1], u[2]) not in done]
for bb, ad, path in resolutions:
    for c in path:
        if c in targets: unresolved.append(['crossed_label', bb, ad, key(*c)]); break
uk = collections.Counter(u[0] for u in unresolved)
nb = collections.Counter(b for (b, ad) in code)
out = {'code': {key(b, ad): n for (b, ad), n in sorted(code.items())},
       'inline': {key(b, ad): t for (b, ad), t in sorted(inline.items())},
       'unresolved': sorted(unresolved, key=lambda u: (u[1], u[2], u[0])), 'report_only': report_only, 'tables': tables,
       'banked': sorted(set(tuple(x) for x in banked)),
       'context': {key(b, ad): ' '.join('%02X' % x for x in sorted(c)) for (b, ad), c in sorted(ctx_of.items()) if c},
       'entries': {key(b, ad): w for (b, ad), w in sorted(entries.items())}}
json.dump(out, open(a.out, 'w'), indent=0)
nbytes = sum(code.values())
print('proto_trace: %d instructions, %d code bytes, %d inline table bytes, %d banked calls / jumps resolved, %d unresolved %s' % (
    len(code), nbytes, len(inline), len(out['banked']), len(unresolved), dict(uk)))
print('code bytes per bank:', ' '.join('%02X:%d' % (b, sum(n for (bk, _), n in code.items() if bk == b)) for b in sorted(nb)))
if a.report:
    with open(a.report, 'w') as f:
        f.write('# Prototype static trace: unresolved sites\n\nGenerated by `tools/proto_trace.py`. %d instructions, %d code bytes, %d unresolved.\n\n| kind | site | detail |\n|---|---|---|\n' % (len(code), nbytes, len(unresolved)))
        for u in out['unresolved']: f.write('| %s | %s | %s |\n' % (u[0], key(u[1], u[2]), u[3]))
        if report_only:
            f.write('\n## Report lines (not errors)\n\n| kind | site | detail |\n|---|---|---|\n')
            for u in report_only: f.write('| %s | %s | %s |\n' % (u[0], key(u[1], u[2]), u[3]))
