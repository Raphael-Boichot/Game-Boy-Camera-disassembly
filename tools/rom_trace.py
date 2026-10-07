#!/usr/bin/env python3
"""[v2: adds --roots (hand-resolved indirect-flow roots, see disasm/code_gaps.md) and four rules marked "TRY"; with no --roots argument it reproduces the first version exactly: 56,799 instructions, 14 unresolved]
Static recursive-descent tracer for the Game Boy Camera / Pocket Camera ROM (SM83, MBC with ROM bank at $2000).

Goal: separate *proven code* (reachable from the vectors, the boot entry, every code label of the .sym file and the
state tables of the mode banks) from everything else, with an explicit list of what could NOT be resolved.

usage: rom_trace_try.py <rom.gb> <sym> <out.json> [--roots work/extra_roots.json]

Conventions that the tracer knows (all verified in the JP ROM):
  * bank 0 = $0000-$3FFF fixed, banks 1..63 at $4000-$7FFF; the ROM bank is written to $2000.
  * far call helper  `call $08C1` : A = bank, HL = target (bank 0, Call_000_08c1).  Resolved by looking back for
    `ld a,n` / `ld hl,nn` in the instructions already decoded on the same path (no label in between).
  * `rst $18` : jump table; A = index; the table of words follows the rst (inline).  Table length = until the lowest
    target seen so far (handlers follow the table), capped by 64 entries.
  * `rst $08` (wait for LCD/VBlank) and `rst $10` (wait flag) return normally.
  * `call $08BB` : one-way far jump (A = bank, HL = target, `jp hl`); used twice, both times for the main loop 00:2E92.
  * the mode table at $2F3F has 34 entries ($00-$21); entry $1D is a bank-0 routine (00:3015).
  * interrupt vectors $40/$48/$50/$58 jump to their handler; $60 unused.
Everything is *over*-conservative about claiming code: a byte is code only if it is on a decoded path.
"""
import sys, json, re, collections

LEN = [1] * 256
for op in range(256):
    hi, lo = op >> 4, op & 15
    n = 1
    if hi < 4:
        if lo in (1,) and hi < 4: n = 3          # ld rr,nn
        elif lo == 8 and hi == 0: n = 3          # ld [nn],sp
        elif lo in (6, 14): n = 2                # ld r,n
        elif op in (0x10, 0x18, 0x20, 0x28, 0x30, 0x38): n = 2
        if op == 0x31: n = 3
    elif 0xC0 <= op:
        if op in (0xC2, 0xC3, 0xC4, 0xCA, 0xCC, 0xCD, 0xD2, 0xD4, 0xDA, 0xDC, 0xEA, 0xFA): n = 3
        elif op in (0xC6, 0xCB, 0xCE, 0xD6, 0xDE, 0xE0, 0xE6, 0xE8, 0xEE, 0xF0, 0xF6, 0xF8, 0xFE): n = 2
    LEN[op] = n
# helpers that call a routine whose address is passed in a register (found by hand): {bank: {helper: opcode of the load}}
CALLBACK_HELPERS = {7: {0x7BDC: 0x21}}
# TRY: hand-resolved indirect sites (see work/code_gaps.md section A).  A `jp hl` listed here is NOT reported as unresolved: its targets are
# already roots (manual_roots / work/extra_roots.json) and every target was validated to decode to ret/jp.  site -> how it is resolved.
RESOLVED_JPHL = {
    (0, 0x0026): 'rst $18 dispatcher body: inline word table after each rst $18 (handled by the rst $18 rule)',
    (0, 0x03A5): 'mode-table dispatcher body ($038A): 3-byte entries at $2F3F (mode_table())',
    (0, 0x08C0): 'one-way far jump body ($08BB): both users load A=0, HL=$2E92',
    (0, 0x08CF): 'far-call helper body ($08C1): every call site resolved through far_ok',
    (3, 0x5F76): 'tail jump to DE = caller-supplied routine; same 7 DE values as 03:5F68 (all `ret`/50BA, already code)',
    (3, 0x5F9F): 'tail jump to DE = caller-supplied routine; same 7 DE values as 03:5F91',
    (3, 0x5F68): 'callback DE (7 distinct values 4F0E,4F53,4F84,4FC6,4FF7,5039,50BA), all already code; continuation 5F69 is a root',
    (3, 0x5F91): 'callback DE (same 7 values); continuation 5F92 is a root',
    (7, 0x792C): 'callback from the 6-byte tables at 7985,79E5,7A43,7A5E,7A85,7AAC,7AD3 -> 7AF1,7AF6,7AFB,7B00,7B05 (roots); continuation 792D is a root',
    (7, 0x7BF3): 'callback HL of call $7BDC: 7937,7997,79F7,7794 (already code); continuation 7BF4 is a root',
    (7, 0x7C1A): 'tail jump to HL of the $7BDC helper (same values as 7BF3)',
    (7, 0x7C62): 'callback HL of call $7C4B: 74A8,7794 (already code); continuation 7C63 is a root',
    (7, 0x7C89): 'tail jump to HL of the $7C4B helper (same values as 7C62)',
    (7, 0x7CD1): 'callback HL of call $7CBA: 74A8,7794 (already code); continuation 7CD2 is a root',
    (7, 0x7CF8): 'tail jump to HL of the $7CBA helper (same values as 7CD1)',
    (7, 0x7D27): 'callback = HL pushed by $7BDC/$7C4B/$7CBA helpers (read from [sp+8]); same value sets as above',
    (0x0A, 0x5419): '96-entry table at 541A indexed by A (0..95); all 92 distinct targets are roots in extra_roots.json',
    (0x1F, 0x52E9): 'sound driver: table 42F2 (10 entries) roots in manual_roots',
    (0x1F, 0x52F7): 'sound driver: table 4306 (10 entries)',
    (0x1F, 0x5309): 'sound driver: table 41FA (62 entries)',
    (0x1F, 0x5317): 'sound driver: table 4276 (62 entries)',
    (0x1F, 0x5329): 'sound driver: table 431A (18 entries)',
    (0x1F, 0x5337): 'sound driver: table 433E (18 entries)',
}
# TRY: `call $FF80` runs the OAM-DMA stub that 00:03E2 copies from 00:03F0 into HRAM
RAM_IMAGES = {0xFF80: (0, 0x03F0)}
TRY_ON = [False]            # TRY: switched on by --roots; off = byte-identical to tools/rom_trace.py
INVALID = {0xD3, 0xDB, 0xDD, 0xE3, 0xE4, 0xEB, 0xEC, 0xED, 0xF4, 0xFC, 0xFD}


class Rom:
    def __init__(self, path):
        self.d = open(path, 'rb').read()
        self.nb = len(self.d) // 0x4000

    def phys(self, bank, addr):
        if addr < 0x4000:
            return addr
        return bank * 0x4000 + (addr - 0x4000)

    def b(self, bank, addr):
        return self.d[self.phys(bank, addr)]

    def w(self, bank, addr):
        return self.b(bank, addr) | (self.b(bank, addr + 1) << 8)


def load_sym(path):
    code, data = [], []
    for l in open(path):
        l = l.strip()
        m = re.match(r'([0-9a-f]+):([0-9a-f]{4}) (\S+)$', l)
        if m:
            bank, addr, name = int(m.group(1), 16), int(m.group(2), 16), m.group(3)
            (data if name.startswith('.data') else code).append((bank, addr, name))
    return code, data


def trace(rom, sym_code, extra_roots=(), extra_data=()):
    code = {}            # (bank,pc) -> length   (instruction starts)
    owner = {}           # (bank,pc) -> entry label key that reached it first (for function grouping)
    entries = {}         # (bank,addr) -> kind
    unresolved = []      # (bank,pc,kind,detail)
    far_ok = []          # resolved far calls (bank,pc,tbank,taddr)
    by_hand = []         # TRY: jp hl sites listed in RESOLVED_JPHL (bank,pc,why)
    retaddr = []         # TRY: continuation roots found by the `ld rr,pc+1 ; push rr ; ... ; jp hl / ret` rule (bank,pc,cont)
    ramcalls = []        # TRY: calls/jumps to $8000+ (bank,pc,target)
    pushret = []         # TRY: `ld rr,nn; push rr; ret|reti` sites (bank,pc,target)
    tables = {}          # (bank,addr)-> list of word targets (rst $18 tables)
    callargs = []        # (bank,pc,callee,A,HL,BC,DE) register constants seen before every direct call
    jtables = {}         # jump tables found by the ld hl,T/add hl,bc/jp hl pattern
    work = collections.deque()
    queued = set()

    parent = {}
    cur = [None]

    def push(bank, addr, kind='flow'):
        if addr >= 0x8000:
            return
        if addr < 0x4000:
            bank = 0
        k = (bank, addr)
        if k not in queued:
            queued.add(k)
            entries.setdefault(k, kind)
            parent[k] = cur[0]
            work.append(k)

    data_addrs = set(extra_data)
    symset = {(b, a) for b, a, n in sym_code if (b, a) not in data_addrs}     # TRY: code labels, used to stop rst $18 tables
    for b, a, n in sym_code:
        if (b, a) in data_addrs:
            continue
        push(b, a, 'sym')
    for a in (0x0000, 0x0040, 0x0048, 0x0050, 0x0058, 0x0100, 0x0150):
        push(0, a, 'vector')
    for k in extra_roots:
        push(k[0], k[1], 'root')

    rom_banks = rom.nb
    while work:
        bank, pc = work.popleft()
        cur[0] = (bank, pc)
        hist = []                        # list of (pc, op, operand) decoded on this straight path
        curbank = None                   # bank selected via `ld [$2000],a` on this path (bank-0 code only)
        while True:
            if pc >= 0x8000 or pc < 0:
                break
            if (bank, pc) in code:
                break
            op = rom.b(bank, pc)
            if op in INVALID:
                unresolved.append((bank, pc, 'invalid-opcode', hex(op)))
                break
            n = LEN[op]
            code[(bank, pc)] = n
            b1 = rom.b(bank, pc + 1) if pc + 1 < 0x8000 else 0
            b2 = rom.b(bank, pc + 2) if pc + 2 < 0x8000 else 0
            nn = b1 | (b2 << 8)
            hist.append((pc, op, nn if n == 3 else b1))
            nxt = pc + n
            here = bank if pc >= 0x4000 else 0

            def tgt_bank(t):
                if t < 0x4000:
                    return 0
                if here != 0:
                    return here
                return curbank

            if op == 0x18:                                   # jr
                t = pc + 2 + (b1 - 256 if b1 > 127 else b1)
                push(here, t)
                break
            if op in (0x20, 0x28, 0x30, 0x38):
                t = pc + 2 + (b1 - 256 if b1 > 127 else b1)
                push(here, t)
            elif op == 0xC3:                                  # jp nn
                tb = tgt_bank(nn)
                if tb is None:
                    unresolved.append((bank, pc, 'jp-bank-unknown', hex(nn)))
                else:
                    push(tb, nn)
                break
            elif op in (0xC2, 0xCA, 0xD2, 0xDA):
                tb = tgt_bank(nn)
                if tb is None:
                    unresolved.append((bank, pc, 'jp-bank-unknown', hex(nn)))
                else:
                    push(tb, nn)
            elif op == 0xE9:                                  # jp hl
                if TRY_ON[0]:
                    h16 = hist[-16:-1]                                          # TRY: `ld rr,pc+1; push rr; ...; jp hl` = indirect call, pc+1 is code (also for jump-table sites, e.g. 03:6549)
                    for i_, (hp, hop, hv) in enumerate(h16):
                        if hop in (0x01, 0x11, 0x21) and hv == nxt and any(x[1] in (0xC5, 0xD5, 0xE5) for x in h16[i_ + 1:]):
                            retaddr.append((here, pc, nxt)); push(here if nxt >= 0x4000 else 0, nxt, 'retaddr'); break
                ops6 = [h[1] for h in hist[-6:-1]]
                if ops6 in ([0x21, 0x09, 0x2A, 0x66, 0x6F], [0x21, 0x19, 0x2A, 0x66, 0x6F]) and hist[-6][0] >= 0:
                    # standard jump table: ld hl,T ; add hl,bc|de ; ld a,[hl+] ; ld h,[hl] ; ld l,a ; jp hl
                    T = hist[-6][2]
                    targets, limit, p = [], 0x8000, T
                    while p < limit and len(targets) < 64:
                        tv = rom.w(here, p)
                        if not (0x0100 <= tv < 0x8000):
                            break
                        targets.append(tv)
                        if tv > p and tv < limit:
                            limit = tv
                        p += 2
                    jtables[(here, T)] = targets
                    for tv in targets:
                        push(here if tv >= 0x4000 else 0, tv, 'jptable')
                    for q in range(T, T + 2 * len(targets)):
                        code[(here, q)] = -1
                else:
                    if TRY_ON[0] and (here, pc) in RESOLVED_JPHL:
                        by_hand.append((here, pc, RESOLVED_JPHL[(here, pc)]))
                    else:
                        unresolved.append((bank, pc, 'jp-hl', ''))
                break
            elif op in (0xCD, 0xC4, 0xCC, 0xD4, 0xDC):        # call
                if op == 0xCD and nn == 0x08C1:               # far call helper
                    a_val = hl_val = None
                    for (hp, hop, hv) in reversed(hist[:-1][-14:]):
                        if a_val is None and hop == 0x3E:
                            a_val = hv
                        if hl_val is None and hop == 0x21:
                            hl_val = hv
                        if hop in (0xCD, 0xC3, 0xC9, 0x18):
                            break
                    if a_val is not None and hl_val is not None and hl_val < 0x8000:
                        far_ok.append((bank, pc, a_val, hl_val))
                        push(a_val if hl_val >= 0x4000 else 0, hl_val, 'far')
                    else:
                        unresolved.append((bank, pc, 'far-call', f'A={a_val} HL={hl_val}'))
                elif op == 0xCD and nn == 0x08BB:             # one-way far jump: A = bank, HL = target, `jp hl` (never returns)
                    a_val = hl_val = None
                    for (hp, hop, hv) in reversed(hist[:-1][-14:]):
                        if a_val is None and hop == 0x3E:
                            a_val = hv
                        if hl_val is None and hop == 0x21:
                            hl_val = hv
                        if hop in (0xCD, 0xC3, 0xC9, 0x18):
                            break
                    if a_val is not None and hl_val is not None and hl_val < 0x8000:
                        far_ok.append((bank, pc, a_val, hl_val))
                        push(a_val if hl_val >= 0x4000 else 0, hl_val, 'farjump')
                    else:
                        unresolved.append((bank, pc, 'far-jump', f'A={a_val} HL={hl_val}'))
                    break
                elif op == 0xCD and nn in CALLBACK_HELPERS.get(here, {}):
                    reg_op = CALLBACK_HELPERS[here][nn]            # 0x21 = ld hl,nn ; 0x11 = ld de,nn
                    for (hp, hop, hv) in reversed(hist[:-1][-10:]):
                        if hop == reg_op:
                            push(here if hv >= 0x4000 else 0, hv, 'callback')
                            break
                    push(tgt_bank(nn) or here, nn, 'call')
                elif op == 0xCD and nn == 0x038A:              # inline 3-byte table (mode table) follows; never returns here
                    ents, end = mode_table(rom, nxt)
                    for q in range(nxt, end):
                        code[(0, q)] = -1
                    for (b_, w_) in ents:
                        push(b_, w_, 'modetable')
                    break
                else:
                    tb = tgt_bank(nn)
                    if TRY_ON[0] and nn >= 0x8000:                           # TRY: call into RAM/HRAM; HRAM stub image is a root
                        ramcalls.append((here, pc, nn))
                        if nn in RAM_IMAGES:
                            push(RAM_IMAGES[nn][0], RAM_IMAGES[nn][1], 'ramimage')
                    elif tb is None:
                        unresolved.append((bank, pc, 'call-bank-unknown', hex(nn)))
                    else:
                        push(tb, nn, 'call')
                    # remember register arguments loaded just before the call (for the data-reference census)
                    ctx = {}
                    for (hp, hop, hv) in reversed(hist[:-1][-12:]):
                        if hop in (0xC9, 0x18, 0xC3):
                            break
                        key = {0x3E: 'a', 0x21: 'hl', 0x01: 'bc', 0x11: 'de'}.get(hop)
                        if key and key not in ctx:
                            ctx[key] = hv
                    if 'hl' in ctx:
                        callargs.append((here, pc, nn, ctx.get('a'), ctx.get('hl'), ctx.get('bc'), ctx.get('de')))
                    if nn == 0x0018 or nn == 0x0020:
                        pass
            elif op in (0xC9, 0xD9):                          # ret / reti
                if TRY_ON[0] and len(hist) >= 3 and {0xC5: 0x01, 0xD5: 0x11, 0xE5: 0x21}.get(hist[-2][1]) == hist[-3][1]:
                    pushret.append((here, pc, hist[-3][2]))                      # TRY: `ld rr,nn ; push rr ; ret/reti` = jump to nn (soft reset at 00:031A)
                    push(here if hist[-3][2] >= 0x4000 else 0, hist[-3][2], 'pushret')
                if TRY_ON[0] and op == 0xC9 and len(hist) >= 2 and hist[-2][1] in (0xC5, 0xD5, 0xE5):
                    h18 = hist[-18:-2]                                           # TRY: `ld rr,pc+1; push rr; ...; push rr; ret` = computed jump with pushed return address
                    for i_, (hp, hop, hv) in enumerate(h18):
                        if hop in (0x01, 0x11, 0x21) and hv == nxt and any(x[1] in (0xC5, 0xD5, 0xE5) for x in h18[i_ + 1:]):
                            retaddr.append((here, pc, nxt)); push(here if nxt >= 0x4000 else 0, nxt, 'retaddr'); break
                break
            elif op == 0xDF:                                  # rst $18
                # table of words follows
                tbl = nxt
                targets, limit, p = [], 0x8000, tbl
                while p < limit and len(targets) < 64:
                    t = rom.w(here, p)
                    if TRY_ON[0] and targets and ((here, p) in symset or (here, p + 1) in symset):
                        break                                 # TRY: a .sym code label inside the table = first handler (05:48D4 over-run)
                    if t < 0x4000 and here != 0 and t != 0:
                        pass
                    if not (0x0100 <= t < 0x8000):
                        break
                    targets.append(t)
                    if t > p and t < limit:
                        limit = t
                    p += 2
                tables[(here, tbl)] = targets
                for t in targets:
                    push(here if t >= 0x4000 else 0, t, 'rst18')
                for q in range(tbl, tbl + 2 * len(targets)):
                    code.setdefault((here, q), 0)
                    code[(here, q)] = -1                       # marks 'table word' (data)
                break
            elif op in (0xCF, 0xD7):                          # rst $08 / $10 return
                pass
            elif op in (0xC7, 0xE7, 0xEF, 0xF7, 0xFF):        # rst $00/$20/$28/$30/$38: treat as non-returning jump
                unresolved.append((bank, pc, 'rst-other', hex(op)))
                break
            elif op == 0xEA and b1 == 0x00 and b2 == 0x20:    # ld [$2000],a  -> remember bank when A is a constant
                a_val = None
                for (hp, hop, hv) in reversed(hist[:-1][-6:]):
                    if hop == 0x3E:
                        a_val = hv
                        break
                    if hop in (0xF0, 0xFA, 0x7E, 0x78, 0x79, 0x7A, 0x7B, 0x7C, 0x7D, 0xAF):
                        if hop == 0xAF:
                            a_val = 0
                        break
                curbank = a_val
            elif op in (0xC0, 0xC8, 0xD0, 0xD8):              # conditional ret: continue
                pass
            pc = nxt
    trace.parent = parent
    trace.jtables = jtables
    trace.callargs = callargs
    trace.by_hand, trace.retaddr, trace.ramcalls, trace.pushret = by_hand, retaddr, ramcalls, pushret
    return code, entries, unresolved, far_ok, tables


def mode_table(rom, start=0x2F3F):
    """Mode table read by Call_000_2f39 through the inline-table helper $038A: 3-byte entries (addr lo, addr hi, bank)."""
    ents, a = [], start
    while True:
        w, b = rom.w(0, a), rom.b(0, a + 2)
        if not ((0x4000 <= w < 0x8000 and 1 <= b < 0x40) or (0x0100 <= w < 0x4000 and b == 0)):   # bank-0 entry: mode $1D = 00:3015
            break
        ents.append((b, w))
        a += 3
    return ents, a


def manual_roots(rom):
    """Roots that no linear scan can find: tables dispatched with `jp hl` / `push bc; ret`.  Every entry here was read by hand
    from the dispatch code (see README section 'What is lacking')."""
    roots = []
    ents, _ = mode_table(rom)
    roots += ents
    # bank 0 $0341-$034D: serial/timer dispatch, table of 8 words at $0357 (index*2, jp hl)
    for i in range(8):
        roots.append((0, rom.w(0, 0x0357 + 2 * i)))
    # bank 0 $0368: serial IRQ, table at $0385 indexed by [$FFC6] (2 entries: $0F16, $2AE9)
    roots += [(0, rom.w(0, 0x0385)), (0, rom.w(0, 0x0387))]
    # bank $0A $5406: jp hl through a 16-bit table at $541A (variant of the standard pattern, index = A*2)
    p, limit, n = 0x541A, 0x8000, 0
    while p < limit and n < 32:
        tv = rom.w(0x0A, p)
        if not (0x4000 <= tv < 0x8000):
            break
        roots.append((0x0A, tv)); n += 1
        if tv > p and tv < limit:
            limit = tv
        p += 2
    # bank $1F (sound driver): pointer tables indexed by A-1 through Call_01f_5266/$526A; counts from the `cp N` guards
    for T, n in ((0x41FA, 62), (0x4276, 62), (0x42F2, 10), (0x4306, 10), (0x431A, 18), (0x433E, 18)):
        for i in range(n):
            roots.append((0x1F, rom.w(0x1F, T + 2 * i)))
    return roots


def main():
    rom = Rom(sys.argv[1])
    sym_code, sym_data = load_sym(sys.argv[2])
    roots = list(manual_roots(rom))
    if '--roots' in sys.argv:                                 # TRY: extra roots [[bank, addr, reason], ...]
        TRY_ON[0] = True
        roots += [(int(r[0]), int(r[1])) for r in json.load(open(sys.argv[sys.argv.index('--roots') + 1]))]
    code, entries, unresolved, far_ok, tables = trace(rom, sym_code, extra_roots=roots, extra_data=[(b, a) for b, a, n in sym_data])
    out = {'code': {f'{b:02x}:{a:04x}': n for (b, a), n in code.items()},
           'unresolved': unresolved, 'far_ok': far_ok,
           'tables': {f'{b:02x}:{a:04x}': t for (b, a), t in tables.items()},
           'callargs': trace.callargs,
           'jtables': {f'{b:02x}:{a:04x}': t for (b, a), t in trace.jtables.items()},
           'entries': {f'{b:02x}:{a:04x}': k for (b, a), k in entries.items()},
           'parent': {f'{b:02x}:{a:04x}': (f'{p[0]:02x}:{p[1]:04x}' if p else None) for (b, a), p in trace.parent.items()},
           'resolved_by_hand': trace.by_hand, 'retaddr_rule': trace.retaddr, 'ramcalls': trace.ramcalls, 'pushret_rule': trace.pushret}
    json.dump(out, open(sys.argv[3], 'w'))
    per = collections.Counter()
    tbl = collections.Counter()
    for (b, a), n in code.items():
        if n > 0:
            per[b] += n
        else:
            tbl[b] += 1
    print('instructions', sum(1 for n in code.values() if n > 0), 'code bytes', sum(per.values()))
    for b in range(rom.nb):
        print(f'bank {b:02x}: code {per[b]:5d} B  tablewords {tbl[b]*1:4d}')
    kinds = collections.Counter(u[2] for u in unresolved)
    print('unresolved', dict(kinds), 'far resolved', len(far_ok))
    if TRY_ON[0]:
        print('TRY: jp hl resolved by hand', len(trace.by_hand), '| continuation roots from the ld-rr,pc+1/push rule', len({(b, p, c) for b, p, c in trace.retaddr}),
              '| calls into RAM', len(trace.ramcalls), '| ld/push/ret jumps', sorted({(b, hex(p), hex(t)) for b, p, t in trace.pushret}))


if __name__ == '__main__':
    main()
