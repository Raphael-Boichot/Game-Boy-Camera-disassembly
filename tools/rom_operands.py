#!/usr/bin/env python3
"""Classify the 16-bit operands and table words that look like ROM addresses ($0100-$7FFF) and that the source tree still writes as numbers,
and write the pointers as labels. ($0100-$3FFF: immediate loads, and words of tables proven to be pointer tables; their bank is 0.)

Used by tools/make_source.py on the bank files of roms/jp_rev_a/src/ (after the far-routine pass, before the macros). For every
`ld hl|bc|de, $XXXX` with $0100 <= XXXX < $8000, and every word in $4000-$7FFF of a `dw` table, a short static walk follows the register:
  * ptr  the register (or a copy of it: `ld d, h` / `ld e, l`, push / pop, a routine that returns it) is dereferenced (`[hl]`, `[hl+]`, `[bc]`, `[de]`), directly or in the
         routine it is handed to (two calls deep, tail jumps followed); or it is the source of a banked copy / far call with `ld a, $BB` just
         before (bank BB). The target bank is BB, else the bank mapped at that point: the code's own bank, or the bank written to the MBC on the
         way (`ld a, $BB` ... `ld [$2000], a`, also through a variable such as hBankTmp), or for bank 0 code the bank written earlier in the
         routine; failing that, the bank that this dereferencing instruction (or another one of the same routine, with no MBC write between)
         read in the core's runs (cov.npz, array rdr: the reading instruction of every ROM byte); else undecided. A `dw` table is a pointer table when a reader loads it with `add hl, bc` + `ld a, [hl+]` / `ld h, [hl]` / `ld l, a`
         (or into bc / de) and the loaded value is then a pointer by the same test; all its numeric words are then pointers into that bank.
         Conditional branches and jump tables (`jp hl` after a table load) are walked on every path: a pointer on any path wins.
         `jp hl` on the tracked value counts as a dereference: a code pointer (a callback).
  * num  the register is read as bytes (`ld a, b` then arithmetic, `add c`, `cp`) before any dereference: a number (sprite position, length, count).
  * ?    the walk ends without an answer (return, register overwritten unused, value stored to a variable, indirect jump, limit): left as a number.
A pointer is written `Label` when a label of the tree sits at the address, else `Label + $off` with the nearest label below it in the same bank,
so the operand follows the block when code moves. When the bank came from `ld a, $BB` that line becomes `ld a, BANK(Label)` too.
Every pointer written is evidence C (code). Each decision is a row of roms/jp_rev_a/disasm/rom_operands_jp.csv (bank, site, kind, register,
value, target, expression, evidence, read): `read` says whether the core's runs (cov.npz, arrays dr / ex) read the target byte or ran it.
tools/relocation_test.py checks the result by moving whole banks and replaying the corpus.
Later steps: absolute reads `ld a, [$XXXX]` of ROM bytes; table pages in a high register (`HIGH(Table)` + `ASSERT LOW(Table) == 0`); a font base
handed with its bank in C (`Glyph_LoadFromCharCode`); a value written through is a RAM / VRAM address (labels of the listing on such values go
back to numbers); a word table that holds plain numbers is data (its label words go back to numbers); pointers inside data records (the bytes
the two-read idioms read in the runs, reads past the end of the indexed table left out; the other records of the same table at its stride;
the Blit_SpriteToBg descriptors; the lists of LISTS; the tables whose label note documents {... lo; hi; bank ...}); a label written at an
instruction that a pointer reaches inside a routine; roms/jp_rev_a/disasm/rom_operands_manual_jp.csv for what was read by hand."""
import csv, os, re

COPIERS = ('Mem_CopyFromBank', 'Vram_CopyFromBank', 'Vram_CopyFromBankAuto', 'Vram_CopyFromBank_4', 'Far_Call', 'Sgb_SendPacket', 'Sgb_SendVramTransfer',
           'SpaceFever_CopyTextRows')
A_WRITE = re.compile(r'^(ld a,|ldh a,|xor |or |and |add a|add |sub |adc |sbc |inc a$|dec a$|cpl|rla|rlca|rra|rrca|swap a|sla a|srl a|sra a|pop af|res \d, a$|set \d, a$|rl a|rr a|rlc a|rrc a|call |rst )')
LIMIT = 40
BC_COPIERS = ('Vq_Push',)
C_BANK_CALLEES = ('Glyph_LoadFromCharCode',)
DOC_TABLES = []      # filled by apply() from the label notes
LISTS = (('Parlor_PageTbl', 3, 7, (0,), 0xFF, 'Parlor_LoadPage (04:73EF): records {src lo, hi, bank, dst lo, hi, len lo, hi} ended by $FF, then {lo, hi, bank} of the page map kept in wMenuMapPtr for Map_SpiralWipeIn'),)
STRUCT_READERS = (((0x00, 0x1EAA), 'Blit_SpriteToBg', 8, (2, 5), 'source A / source B {lo, hi, bank} of a Blit_SpriteToBg descriptor (8 bytes, 5 when width bit 7 is set), copied by 00:1EAA'),)    # HL = source, C = its bank    # A = bank, BC = data pointer (a VRAM-queue stream)
READER_SITES = {}     # (bank, JP pc) -> (bank, pc) of the STRUCT_READERS in another build (set by apply)
COORD_CALLEES = ('Oam_AddMeta', 'Run_DrawMeta', 'HotSpotEd_DrawArrows')   # take a sprite position in BC (tools/sym_fix.py)


def parse(out):
    """{bank: [(line index, label or None, code text, address or None)]}, label addresses come from the sym file."""
    banks = {}
    for f in sorted(os.listdir(out)):
        m = re.match(r'bank_([0-9a-f]{3})\.asm$', f)
        if not m: continue
        b = int(m.group(1), 16); L = open(os.path.join(out, f), encoding='utf-8').read().split('\n'); items = []
        for i, l in enumerate(L):
            lm = re.match(r'^([A-Za-z_]\w*)::?\s*$', l)
            if lm: items.append((i, lm.group(1), '', None)); continue
            if not l[:1].isspace(): continue
            c = l.split(';')[0].strip()
            if not c: continue
            am = re.search(r'; \$([0-9A-F]{4})\b', l)
            items.append((i, None, c, int(am.group(1), 16) if am else None))
        banks[b] = (f, L, items)
    return banks


class Walker:
    def __init__(self, banks, labels):
        self.banks = banks; self.labels = labels            # labels: name -> (bank, item index)
        self.added = False                                  # the tracked value was added to HL as a base (base + index)

    def at(self, name):
        return self.labels.get(name)

    def walk(self, bank, idx, regs, mapped, depth=0, steps=None, stack0=None, abank0=None, callee=False):
        """Follow the pointer held in `regs` (a set of 'hl' / 'bc' / 'de') from item idx of bank. Returns (kind, target bank, a-line) with kind
        ptr / num / ?; a-line is (bank, line) of the `ld a, $BB` that gave the bank of a banked copy."""
        f, L, items = self.banks[bank]
        steps = steps if steps is not None else [0, set()]
        regs = set(regs); stack = list(stack0 or []); abank = abank0; pend = {}; alias = {}
        i = idx; n = 0
        key = (bank, idx, frozenset(regs))
        if key in steps[1]: return ('?', None, None)              # a loop or a path already walked
        steps[1].add(key)
        while i < len(items):
            steps[0] += 1; n += 1
            if n > LIMIT or steps[0] > 12 * LIMIT: return ('?', None, None)
            line, lab, t, ad = items[i]
            if lab: i += 1; continue
            if not regs and not any(stack) and not pend: return ('dead', None, None)
            # dereference
            for r in list(regs):
                if re.search(r'\[%s[+-]?\]' % r, t) and not re.match(r'^ld %s,' % r, t):
                    if re.match(r'^(ld \[%s[+-]?\], |inc \[|dec \[|res \d, \[|set \d, \[|rlc? \[|rrc? \[|sla \[|sra \[|srl \[|swap \[)' % r, t):
                        return ('store', None, None, (bank, ad))     # written through: a RAM / VRAM address, ROM cannot be written
                    return ('ptr', mapped, None, (bank, ad))
            # A parked in a variable and loaded back; an MBC write maps the bank in A
            m = re.match(r'^(?:ld|ldh) \[(\w+)\], a$', t)
            if m and abank: alias[m.group(1)] = abank
            m = re.match(r'^(?:ld|ldh) a, \[(\w+)\]$', t)
            if m and m.group(1) in alias: abank = alias[m.group(1)]; i += 1; continue
            if re.match(r'^ld \[(\$2000|\$2100)\], a$', t):
                mapped = abank[0] if abank else None
                i += 1; continue
            # a = bank
            m = re.match(r'^ld a, (?:\$([0-9a-f]{2})|BANK\((\w+)\))$', t)
            if m:
                abank = (int(m.group(1), 16) if m.group(1) else (self.labels[m.group(2)][0] if m.group(2) in self.labels else None), (bank, line))
                i += 1; continue
            # a sprite position: BC handed to a routine that adds it to the sprite coordinates
            m = re.match(r'^call (?:(?:nz|z|nc|c), )?(\w+)$', t)
            if m and 'bc' in regs and m.group(1).startswith(COORD_CALLEES): return ('num', None, None)
            # rst to a routine (wait for VBlank): followed like a call
            m = re.match(r'^rst (Rst08_WaitVBlank)$', t)
            if m: t = 'call ' + m.group(1)
            # base + index: `add hl, rr` with rr the tracked base
            m = re.match(r'^add hl, (bc|de)$', t)
            if m and m.group(1) in regs: regs.add('hl'); self.added = True; i += 1; continue
            # calls and jumps
            m = re.match(r'^(call|jp|jr)( (?:nz|z|nc|c),)? (\w+)$', t)
            if m and m.group(3) != 'hl':
                kind, cond, tgt = m.group(1), m.group(2), m.group(3)
                if kind == 'jp' and tgt == 'Far_Call_Return' and regs & {'hl', 'bc'} and abank and abank[0] is not None:
                    return ('ptr', abank[0], abank[1])           # returned to the far caller as {A = bank, HL / BC = address}
                if kind == 'call' and ((tgt in COPIERS and 'hl' in regs) or (tgt in BC_COPIERS and 'bc' in regs)):
                    if abank and abank[0] is not None: return ('ptr', abank[0], abank[1])
                    return ('?', None, None)
                if cond:                                   # conditional: walk the branch, then the fall-through; a pointer on either path wins
                    pos = self.at(tgt)
                    if not pos or kind == 'call': i += 1; continue
                    if regs or any(stack):
                        rb = self.walk(pos[0], pos[1], regs, mapped, depth, steps, stack, abank, callee)
                        rf = self.walk(bank, i + 1, regs, mapped, depth, steps, stack, abank, callee)
                        if True:
                            for r in sorted((rb, rf), key=lambda r: r[1] is None):
                                if r[0] == 'ptr': return r
                            for r in (rb, rf):
                                if r[0] == 'saved': return r
                            if 'num' in (rb[0], rf[0]) or 'store' in (rb[0], rf[0]): return next(r for r in (rb, rf) if r[0] in ('num', 'store'))
                            rets = [r for r in (rb, rf) if r[0] == 'ret']
                            if rets: return ('ret', frozenset().union(*[r[1] for r in rets]), None)
                            if 'dead' in (rb[0], rf[0]): return ('dead', None, None)
                            return ('num', None, None) if 'num' in (rb[0], rf[0]) else ('?', None, None)
                    i += 1; continue
                pos = self.at(tgt)
                if not pos: return ('?', None, None)
                if kind == 'call':
                    if depth >= 2: return ('?', None, None)
                    r = self.walk(pos[0], pos[1], regs, mapped, depth + 1, steps, [], abank, True)
                    if r[0] == 'dead': regs = set(); abank = None; i += 1; continue   # the routine overwrote it; a saved copy may remain here
                    if r[0] != 'ret': return r
                    regs = set(r[1]); abank = None; i += 1; continue    # back in the caller with what the routine left
                return self.walk(pos[0], pos[1], regs, mapped, depth, steps, stack, abank, callee)    # tail jump
            if t == 'jp hl' and 'hl' in regs:
                return ('ptr', mapped, None, (bank, ad))              # jumped to: a code pointer (callback)
            if t == 'jp hl' and i >= 4 and [x[2] for x in items[i - 3:i]] == ['ld a, [hl+]', 'ld h, [hl]', 'ld l, a']:
                # a jump table: walk every target with the same registers and stack; a pointer on any path wins, num only if all agree
                j = i - 4
                while j >= 0 and items[j][2] in ('add hl, bc', 'add hl, de'): j -= 1
                m2 = re.match(r'^ld hl, (\w+)$', items[j][2]) if j >= 0 else None
                tpos = self.at(m2.group(1)) if m2 else None
                if not tpos: return ('?', None, None)
                tb, tk = tpos; res = []
                for x in self.banks[tb][2][tk + 1:]:
                    if x[1]: break
                    if not x[2].startswith('dw '): break
                    for tg in [y.strip() for y in x[2][3:].split(',')]:
                        p2 = self.at(tg)
                        res.append(self.walk(p2[0], p2[1], regs, mapped, depth, steps, stack, None, callee) if p2 else ('?', None, None))
                for r in sorted(res, key=lambda r: r[1] is None):
                    if r[0] == 'ptr': return r
                for r in res:
                    if r[0] == 'saved': return r
                if any(r[0] == 'num' for r in res): return ('num', None, None)
                rets = [r for r in res if r[0] == 'ret']
                if rets: return ('ret', frozenset().union(*[r[1] for r in rets]), None)
                if any(r[0] == 'dead' for r in res): return ('dead', None, None)
                return ('num', None, None) if any(r[0] == 'num' for r in res) else ('?', None, None)
            if t == 'ret' and callee: return ('ret', frozenset(regs), None)
            if re.match(r'^(ret|reti|jp hl|rst |jp \$|call \$|halt|stop)', t) and not re.match(r'^ret (nz|z|nc|c)$', t):
                return ('?', None, None)
            if re.match(r'^rst ', t): return ('?', None, None)
            if abank and A_WRITE.match(t) and not t.startswith(('call', 'rst')): abank = None
            # register life
            m = re.match(r'^push (hl|bc|de|af)$', t)
            if m: stack.append(m.group(1) in regs); i += 1; continue
            m = re.match(r'^pop (hl|bc|de|af)$', t)
            if m:
                v = stack.pop() if stack else False
                if m.group(1) != 'af':
                    regs.discard(m.group(1))
                    if v: regs.add(m.group(1))
                i += 1; continue
            m = re.match(r'^ld ([bcdehl]), ([bcdehl])$', t)
            if m:
                dst, src = m.group(1), m.group(2)
                pair = {'h': 'hl', 'l': 'hl', 'b': 'bc', 'c': 'bc', 'd': 'de', 'e': 'de'}
                if pair[src] in regs:
                    pend.setdefault(pair[dst], set()).add(('hi' if dst in 'hbd' else 'lo', 'hi' if src in 'hbd' else 'lo'))
                    if pend[pair[dst]] >= {('hi', 'hi'), ('lo', 'lo')}: regs.add(pair[dst]); pend.pop(pair[dst])
                    elif pair[dst] in regs and pair[dst] != pair[src]: regs.discard(pair[dst])
                    i += 1; continue
                if pair[dst] in regs: regs.discard(pair[dst])
                i += 1; continue
            m = re.match(r'^(?:ld|ldh) ([abcdehl]),', t) or re.match(r'^(?:inc|dec|swap|sla|srl|sra|rl|rr|rlc|rrc|res \d,|set \d,) ([bcdehl])$', t)
            if m and m.group(1) in 'bcdehl':
                pr = {'h': 'hl', 'l': 'hl', 'b': 'bc', 'c': 'bc', 'd': 'de', 'e': 'de'}[m.group(1)]
                if pr in regs: regs.discard(pr)
                i += 1; continue
            m = re.match(r'^ld (hl|bc|de), ', t)
            if m: regs.discard(m.group(1)); i += 1; continue
            m = re.match(r'^ld a, ([bcdehl])$', t) or re.match(r'^(?:add|adc|sub|sbc|and|or|xor|cp) (?:a, )?([bcdehl])$', t)
            if m:
                pr = {'h': 'hl', 'l': 'hl', 'b': 'bc', 'c': 'bc', 'd': 'de', 'e': 'de'}[m.group(1)]
                if pr in regs and len(regs) == 1 and not pend:
                    nxt = items[i + 1][2] if i + 1 < len(items) else ''
                    if t.startswith('ld a,') and (re.match(r'^(ld|ldh) \[[wh]\w*( \+ \$[0-9a-f]+)?\], a$', nxt) or nxt.startswith('push')):
                        return ('saved', mapped, nxt.split('[')[1].split(']')[0] if '[' in nxt else 'the stack')                                                       # saved to a variable: used later, not here
                    return ('num', None, None)                                                         # the value is read as bytes
                i += 1; continue
            i += 1
        return ('?', None, None)


IDIOMS = ((('ld a, [hl+]', 'ld h, [hl]', 'ld l, a'), 'hl'), (('ld a, [hl+]', 'ld e, [hl]', 'ld d, a'), None),
          (('ld c, [hl]', 'inc hl', 'ld b, [hl]'), 'bc'), (('ld e, [hl]', 'inc hl', 'ld d, [hl]'), 'de'), (('ld a, [hl+]', 'ld b, [hl]', 'ld c, a'), None))


PAIR = {'hl': ('l', 'h'), 'bc': ('c', 'b'), 'de': ('e', 'd')}


def pair_loads(items, k0):
    """From item k0, up to 6 straight-line instructions: the register pair built from two memory reads.
    Yields (pair, item index of the low read, item index of the high read, item index after the pair is complete)."""
    hold = {}                       # register -> item index of the memory read it holds
    for k in range(k0, min(k0 + 6, len(items))):
        line, lab, t, ad = items[k]
        if lab: return
        m = re.match(r'^ld ([abcdehl]), \[(hl|de|bc)[+-]?\]$', t) or re.match(r'^ld ([bcdehl]), ([abcdehl])$', t)
        if not m:
            if re.match(r'^(inc|dec) (hl|de|bc)$', t): continue
            return
        if m.group(2) in ('hl', 'de', 'bc') or m.group(2).startswith(('hl', 'de', 'bc')): hold[m.group(1)] = k
        elif m.group(2) in hold: hold[m.group(1)] = hold[m.group(2)]
        else: hold.pop(m.group(1), None)
        for p, (lo, hi) in PAIR.items():
            if m.group(1) in (lo, hi) and hold.get(lo) is not None and hold.get(hi) is not None and hold[lo] != hold[hi]:
                yield p, hold[lo], hold[hi], k + 1; return


def record_pointers(banks, labels, addr, inbank, rom, rdr, dr, W, resolve, mapped_for, expr, edits, drop, rows):
    import numpy as np
    def off(b, x): return x if b == 0 else b * 0x4000 + x - 0x4000
    def tag(b, pc): return 0x80000000 | (b << 16) | pc
    # where each ROM byte of a plain `db` block sits: offset -> (bank, label, byte index in the block)
    pos = {}; blocks = {}
    for b, (f, L, items) in banks.items():
        k = 0
        while k < len(items):
            line, lab, t, ad = items[k]
            if not lab or lab not in addr: k += 1; continue
            # the block as it reads now (an earlier step may have rewritten it as leading pointer words + bytes)
            data = []; lines = []; j = k + 1; ok = True; lead = 0; leadtext = []
            while j < len(items) and not items[j][1]:
                if (b, items[j][0]) in drop: lines.append(items[j][0]); j += 1; continue
                if items[j][2].startswith('ds '): break                 # the padding after the block ends it
                text = edits.get((b, items[j][0]), items[j][2])
                for sub in text.split('\n'):
                    tt = sub.split(';')[0].strip()
                    if tt.startswith('dw ') and not data: lead += 2 * (tt.count(',') + 1); leadtext.append(sub); continue
                    if not tt.startswith('db '): ok = False; break
                    ops = [x.strip() for x in tt[3:].split(',')]
                    if not all(re.match(r'^\$[0-9a-f]{2}$', x) for x in ops): ok = False; break
                    data += [int(x[1:], 16) for x in ops]
                if not ok: break
                lines.append(items[j][0]); j += 1
            if ok and data:
                o = off(b, addr[lab][1]) + lead; blocks[(b, lab)] = (o, data, lines, leadtext)
                for n in range(len(data)): pos[o + n] = (b, lab, n)
            k = max(j, k + 1)
    rd = rdr.astype(np.int64)
    found = {}                      # (bank, label) -> {byte index: (expression, far, value, target bank, site, evidence)}
    st = dict(rec_sites=0, rec_words=0, rec_far=0, rec_outside=0, rec_offset=0, rec_stride=0, rec_out_of_table=0)
    for b, (f, L, items) in banks.items():
        for k in range(len(items)):
            for p, klo, khi, kend in pair_loads(items, k):
                slo, shi = items[klo][3], items[khi][3]
                if slo is None or shi is None: continue
                kb = None; abank0 = None           # a bank read right after (`inc hl` / `ld a, [hl]`): {lo, hi, bank} records
                for q in range(kend, min(kend + 3, len(items))):
                    tq = items[q][2]
                    if items[q][1]: break
                    if re.match(r'^ld a, \[(hl|de|bc)[+-]?\]$', tq): kb = q; abank0 = ('BYTE', (b, items[q][0])); break
                    if not re.match(r'^(inc|dec) (hl|de|bc)$', tq): break
                r = W.walk(b, kb + 1 if kb is not None else kend, {p}, mapped_for(b, k), abank0=abank0)
                r = resolve(r, 0x4000)
                if r[0] != 'ptr': continue
                words = [int(x) for x in np.nonzero(rd == tag(b, slo))[0] if x + 1 < len(rd) and rd[x + 1] == tag(b, shi)]
                if not words: continue
                base = None                                  # the table the reader indexes (`ld hl, Table` / `add hl, rr` just before)
                for q in range(klo - 1, max(-1, klo - 6), -1):
                    if items[q][1]: break
                    mb = re.match(r'^ld hl, ([A-Za-z_]\w*)$', items[q][2])
                    if mb: base = mb.group(1) if mb.group(1) in addr else None; break
                    if not re.match(r'^(add hl, (bc|de)|ld [bcde], .*|sla [a-e]|rl [a-e]|add a|ld [a-e], [a-e])$', items[q][2]): break
                if base:                                     # reads past the end of the table (an index out of range in the game) are not its records
                    bb0, ba0 = addr[base]; b0 = off(bb0, ba0)
                    nxt = min((off(bb0, a_) for a_, pr_, n_ in inbank.get(bb0, []) if a_ > ba0 and pr_), default=b0 + 0x4000)
                    out_ = [x for x in words if not (b0 <= x < nxt)]
                    st['rec_out_of_table'] += len(out_); words = [x for x in words if b0 <= x < nxt]
                st['rec_sites'] += 1
                for x in words:
                    v = rom[x] | rom[x + 1] << 8
                    far = kb is not None and r[1] == 'BYTE' and x + 2 < len(rd) and rd[x + 2] == tag(b, items[kb][3])
                    if far: tb = rom[x + 2]
                    elif r[1] == 'BYTE': continue
                    else: tb = r[1]
                    if v < 0x4000: tb = 0
                    if v >= 0x8000 or tb is None or not expr(tb, v): continue
                    if x not in pos or pos.get(x + 1, (0, 0))[1] != pos[x][1] or (far and pos.get(x + 2, (0, 0))[1] != pos[x][1]): st['rec_outside'] += 1; continue
                    bb, lab, n = pos[x]; e = expr(tb, v)
                    if '+' in e and not r[2]: st['rec_offset'] += 1; continue   # an address inside a block, not handed to a banked copy: not taken
                    found.setdefault((bb, lab), {}).setdefault(n, (e, far, v, tb, '%02X:%04X' % (b, slo), r[3]))
    # records copied whole by a known reader (STRUCT_READERS): the runs of bytes it read, cut into records, far-pointer fields at fixed offsets
    for (rb_, rpc), rname, size, fields, why in STRUCT_READERS:
        rb_, rpc = READER_SITES.get((rb_, rpc), (rb_, rpc))
        xs = np.nonzero(rd == tag(rb_, rpc))[0]
        runs = []
        for x in xs:
            x = int(x)
            if runs and x == runs[-1][1] + 1: runs[-1][1] = x
            else: runs.append([x, x])
        # self-relative offset tables handed to the reader routine: start n = T + n + byte n (`ld hl, T` / `add hl, de` / `ld e, [hl]` / `add hl, de`)
        for b2, (f2, L2, it2) in banks.items():
            for k2 in range(len(it2) - 4):
                m2 = re.match(r'^ld hl, (\w+)$', it2[k2][2])
                if not m2 or m2.group(1) not in addr or [x[2] for x in it2[k2 + 1:k2 + 4]] != ['add hl, de', 'ld e, [hl]', 'add hl, de']: continue
                if not any(re.match(r'^(call|jp) %s$' % rname, x[2]) for x in it2[k2 + 4:k2 + 6]): continue
                tb2, ta2 = addr[m2.group(1)]; t0 = tb2 * 0x4000 + ta2 - 0x4000 if tb2 else ta2
                lim = 0x100; n2 = 0
                while n2 < lim: lim = min(lim, n2 + rom[t0 + n2]); n2 += 1
                for n2 in range(lim):
                    q = t0 + n2 + rom[t0 + n2]; runs.append([q, q + (4 if rom[q] & 0x80 else size - 1)])
        for s0, s1 in runs:
            recs = []; q = s0
            while q <= s1:                                   # Blit descriptors: 5 bytes when width bit 7 is set (mask from source A, no source B), else 8
                ln = 5 if rom[q] & 0x80 else size; recs.append((q, (2,) if ln == 5 else fields)); q += ln
            if not (s1 - 3 <= q - 1 <= s1 + 3): st['rec_outside'] += 1; continue      # the walk must end with the run (the copy reads 8 bytes)
            for r0, fl in recs:
                for fo in fl:
                    x = r0 + fo; v = rom[x] | rom[x + 1] << 8; tb = rom[x + 2]
                    if not (0x4000 <= v < 0x8000) or tb >= 0x40 or not expr(tb, v): continue
                    if x not in pos or pos.get(x + 2, (0, 0))[1] != pos[x][1]: st['rec_outside'] += 1; continue
                    bb, lab, n = pos[x]
                    found.setdefault((bb, lab), {}).setdefault(n, (expr(tb, v), True, v, tb, '%02X:%04X' % (rb_, rpc), 'C: %s' % why))
    # described list structures (LISTS): pointer words at the head, then lists of fixed-size records ended by a byte, then a far pointer
    for tname, nptr, size, fields, term, why in LISTS:
        if tname not in addr: continue
        tb_, ta_ = addr[tname]; t0 = off(tb_, ta_)
        for kp in range(nptr):
            q = off(tb_, rom[t0 + 2 * kp] | rom[t0 + 2 * kp + 1] << 8)
            while rom[q] != term:
                for fo in fields:
                    x = q + fo; v = rom[x] | rom[x + 1] << 8; tb = rom[x + 2]
                    if 0x4000 <= v < 0x8000 and tb < 0x40 and expr(tb, v) and x in pos:
                        bb, lab, n = pos[x]; found.setdefault((bb, lab), {}).setdefault(n, (expr(tb, v), True, v, tb, tname, 'C: %s' % why))
                q += size
            x = q + 1; v = rom[x] | rom[x + 1] << 8; tb = rom[x + 2]
            if 0x4000 <= v < 0x8000 and tb < 0x40 and expr(tb, v) and x in pos:
                bb, lab, n = pos[x]; found.setdefault((bb, lab), {}).setdefault(n, (expr(tb, v), True, v, tb, tname, 'C: %s (the far pointer after the end byte)' % why))
    # tables whose label note documents {... lo; hi; bank ...} records: every record (width from the .sym type) at the offset of `lo`
    for tname, width, fo, why in DOC_TABLES:
        if tname not in addr: continue
        tb_, ta_ = addr[tname]; t0 = off(tb_, ta_)
        if t0 not in pos or pos[t0][1] != tname: continue
        o, data, lines, leadtext = blocks[(pos[t0][0], tname)]
        for r0 in range(0, len(data) - width + 1, width):
            x = o + r0 + fo; v = rom[x] | rom[x + 1] << 8; tb = rom[x + 2]
            if 0x4000 <= v < 0x8000 and tb < 0x40 and expr(tb, v):
                found.setdefault((pos[t0][0], tname), {}).setdefault(r0 + fo, (expr(tb, v), True, v, tb, tname, 'C: record of the table described by its label note: %s' % why))
    # a table of {lo, hi, bank} records: its other records at the same stride, when each lands exactly on a label of that bank (unread records)
    for (b, lab), words in list(found.items()):
        o, data, lines, leadtext = blocks[(b, lab)]
        fars = sorted(n for n, w in words.items() if w[1])
        if len(fars) < 2 or any((y - fars[0]) % 3 for y in fars): continue
        n = fars[0] % 3
        while n + 2 < len(data):
            if n not in words and not any(n + d in words or n - d in words for d in (1, 2)):
                v = data[n] | data[n + 1] << 8; tb = data[n + 2]
                e = expr(tb, v) if 0x4000 <= v < 0x8000 and tb < 0x40 else None
                if e and '+' not in e:
                    words[n] = (e, True, v, tb, words[fars[0]][4], 'I: record of the same table, stride 3, not read in the runs; it lands exactly on %s' % e); st['rec_stride'] += 1
            n += 3
    for (b, lab), words in found.items():
        o, data, lines, leadtext = blocks[(b, lab)]
        out = []; buf = []; n = 0
        def flush():
            for q in range(0, len(buf), 16): out.append('    db ' + ', '.join('$%02x' % y for y in buf[q:q + 16]))
            buf.clear()
        while n < len(data):
            w = words.get(n)
            if w and n + 1 < len(data) and (n + 1) not in words:
                flush(); e, far, v, tb, site, ev = w
                if far and n + 2 < len(data):
                    out.append('    dwb %s' % e if '+' not in e else '    dw %s\n    db BANK(%s)' % (e, e.split(' ')[0])); n += 3; st['rec_far'] += 1
                else: out.append('    dw %s' % e); n += 2
                st['rec_words'] += 1
                rows.append((b, lab, 'ptr', 'record', '$%04X' % v, '%02X:%04X' % (tb, v), e, '%s; the word was read by %s%s' % (ev, site, ', the next byte is its bank' if far else ''), 'yes' if dr is not None and dr[off(tb, v)] else 'no'))
                continue
            buf.append(data[n]); n += 1
        flush()
        edits[(b, lines[0])] = '\n'.join(leadtext + out)
        for ln in lines[1:]: drop.add((b, ln))
    return st


def apply(out, sym, rom, cov=None, report=None, names=None, manual_csv=None, reader_sites=None):
    """names: the name csv files in layer order (default: disasm/sym_names_jp.csv beside the sym); manual_csv: the hand decisions
    (default: disasm/rom_operands_manual_jp.csv beside the sym); reader_sites: {(bank, JP pc): (bank, pc)} for the STRUCT_READERS of another
    build. Another build passes its own (tools/make_source.py --tree)."""
    global READER_SITES; READER_SITES = dict(reader_sites or {})
    banks = parse(out)
    labels = {}; defined = {}
    for b, (f, L, items) in banks.items():
        for k, (line, lab, t, ad) in enumerate(items):
            if lab: labels[lab] = (b, k)
    addr = {}; inbank = {}
    for l in open(sym, encoding='utf-8'):
        m = re.match(r'([0-9a-fA-F]{2}):([0-9a-fA-F]{4}) (\S+)', l)
        if m and m.group(3) in labels:
            b, a = int(m.group(1), 16), int(m.group(2), 16); addr[m.group(3)] = (b, a)
            inbank.setdefault(b, []).append((a, 0 if m.group(3).startswith('jr_') else 1, m.group(3)))
    for b in inbank: inbank[b].sort()
    dr = rdr = None
    if cov and os.path.exists(cov):
        import numpy as np
        z = np.load(cov); dr = (z['dr'] > 0) | (z['ex'] > 0); rdr = z['rdr']
    W = Walker(banks, labels)

    def off(b, x): return x if b == 0 else b * 0x4000 + x - 0x4000

    def expr(b, x):
        best = None
        for a, pr, n in inbank.get(b, []):
            if a > x: break
            if best is None or a > best[0] or (a == best[0] and pr > best[1]): best = (a, pr, n)
        if not best: return None
        return best[2] if best[0] == x else '%s + $%X' % (best[2], x - best[0])

    def read(b, x):
        if dr is None: return ''
        return 'yes' if dr[off(b, x)] else 'no'

    def read_by(site, x, span=512):
        """Banks B in which an instruction `site` = (bank, pc) read a byte of B:x .. B:x+span in the runs (rdr = 0x80000000 | bank << 16 | pc)."""
        if rdr is None or site is None or site[1] is None: return set()
        want = 0x80000000 | (site[0] << 16) | site[1]; out = set()
        for bb in range(1, 64):
            o = off(bb, x); seg = rdr[o:o + min(span, 0x8000 - x)]
            if (seg == want).any(): out.add(bb)
        return out

    def abank_before(b, k):
        """`ld a, $BB` / `ld a, BANK(x)` in the two lines before item k with nothing writing A in between: (bank, (b, line))."""
        f, L, items = banks[b]
        for j in range(k - 1, max(-1, k - 3), -1):
            t = items[j][2]
            if items[j][1]: return None
            m = re.match(r'^ld a, (?:\$([0-9a-f]{2})|BANK\((\w+)\))$', t)
            if m: return (int(m.group(1), 16) if m.group(1) else addr.get(m.group(2), (None,))[0], (b, items[j][0]))
            if A_WRITE.match(t): return None
        return None

    def mapped_for(b, k):
        """The bank mapped at $4000 for the code of item k: its own bank, or for bank 0 the bank written to the MBC earlier in the routine."""
        if b: return b
        f, L, items = banks[b]
        cut = False                  # an unconditional ret / jp / jr between: the code above does not fall through to item k
        for j in range(k - 1, max(-1, k - 80), -1):
            t = items[j][2]
            if items[j][1] and not items[j][1].startswith('jr_'): return None
            if re.match(r'^(ret|reti|jp \w+|jr \w+)$', t): cut = True; continue
            if items[j][1]: cut = False; continue           # a jump target: the paths join again
            if cut: continue
            if re.match(r'^ld \[(\$2000|\$2100|rROMB0)\], a$', t):
                for jj in range(j - 1, max(-1, j - 6), -1):
                    m = re.match(r'^ld a, (?:\$([0-9a-f]{2})|BANK\((\w+)\))$', items[jj][2])
                    if m: return int(m.group(1), 16) if m.group(1) else addr.get(m.group(2), (None,))[0]
                    if A_WRITE.match(items[jj][2]) and not items[jj][2].startswith(('ldh a, [hRomBank', 'ld a, [hRomBank')): break
                return None
        return None

    proven = {}          # (bank, pc) of a dereference -> bank it read in the runs, filled as the walks resolve

    def sibling(site):
        """A resolved dereference in the same routine as site (no non-local label and no MBC write between): (bank, its site)."""
        if not site or site[1] is None: return None
        f, L, items = banks[site[0]]
        k = next((n for n, it in enumerate(items) if it[3] == site[1] and not it[1]), None)
        if k is None: return None
        for step in (-1, 1):
            j = k
            while 0 <= j + step < len(items):
                j += step; it = items[j]
                if it[1] and not it[1].startswith('jr_'): break
                if re.match(r'^ld \[(\$2000|\$2100)\], a$', it[2]): break
                if (site[0], it[3]) in proven: return (proven[(site[0], it[3])], (site[0], it[3]))
                if it[3] is not None and re.search(r'\[(hl|bc|de)[+-]?\]', it[2]):
                    bs = read_by((site[0], it[3]), 0x4000, 0x4000)
                    if len(bs) == 1: proven[(site[0], it[3])] = next(iter(bs)); return (proven[(site[0], it[3])], (site[0], it[3]))
        return None

    def resolve(r, v):
        """(kind, bank, a-line, evidence) from a walk result: a pointer whose bank is unknown (bank 0 code) gets the bank its dereference read in the runs."""
        if r[0] == 'ptr':
            if r[1] is None:
                bs = read_by(r[3] if len(r) > 3 else None, v)
                if len(bs) == 1:
                    bb = bs.pop(); return ('ptr', bb, None, 'C: dereferenced at %02X:%04X, which read bank %02X there in the runs' % (r[3][0], r[3][1], bb))
                sib = sibling(r[3]) if len(r) > 3 else None
                if sib: return ('ptr', sib[0], None, 'C: dereferenced at %02X:%04X, in the routine whose read at %02X:%04X hit bank %02X in the runs (no bank write between)' % (r[3][0], r[3][1], sib[1][0], sib[1][1], sib[0]))
                return ('?', None, None, 'dereferenced at %s; the mapped bank is unknown' % ('%02X:%04X' % r[3] if len(r) > 3 and r[3][1] is not None else '?'))
            if r[2]: return ('ptr', r[1], r[2], 'C: handed with its bank in A to a banked copy, a far call or the far return')
            seen = len(r) > 3 and r[1] in read_by(r[3], v)
            return ('ptr', r[1], None, 'C: dereferenced at %02X:%04X (bank %02X mapped)%s' % (r[3][0], r[3][1] or 0, r[1], '; that instruction read the target block in the runs' if seen else ''))
        if r[0] == 'saved':
            return ('?', None, None, 'stored to %s for later use: not followed' % r[2])
        if r[0] == 'num': return ('num', None, None, 'C: read as bytes (arithmetic, comparison) before any dereference')
        if r[0] == 'store': return ('num', None, None, 'C: written through at %02X:%04X: a RAM / VRAM address reached by adding to it, not a ROM pointer' % (r[3][0], r[3][1] or 0))
        if r[0] == 'dead': return ('?', None, None, 'overwritten before any use')
        return ('?', None, None, 'the walk ends without a use')

    inserts_after = {}; aligned_manual = {}
    # label notes that document far-pointer records ({... lo; hi; bank ...}) of a table typed .data:LEN:WIDTH
    disasm = os.path.join(os.path.dirname(os.path.abspath(sym)), 'disasm')
    width = {}
    for l in open(sym, encoding='utf-8'):
        mw = re.match(r'([0-9a-fA-F]{2}):([0-9a-fA-F]{4}) \.data:[0-9a-fA-F]+:([0-9a-fA-F]+)', l)
        if mw: width[(int(mw.group(1), 16), int(mw.group(2), 16))] = int(mw.group(3), 16)
    DOC_TABLES.clear()
    _rows = []
    for _fn in (names or [os.path.join(disasm, 'sym_names_jp.csv')]):
        if os.path.exists(_fn): _rows += list(csv.DictReader(open(_fn, encoding='utf-8')))
    for r_ in _rows:
        if r_['name'] in ('-', ''): continue
        mb = re.search(r'\{([^}]*)\}', r_['note'])
        if not mb or r_['name'].startswith(('Gfx_', 'Map_', 'Src_')): continue
        fl = [x.strip() for x in re.split(r'[;,]', mb.group(1))]
        k_ = next((n for n in range(len(fl) - 2) if fl[n].endswith('lo') and fl[n + 1] == 'hi' and fl[n + 2] == 'bank'), None)
        w_ = width.get((int(r_['bank'], 16), int(r_['addr'], 16)))
        if k_ is not None and w_ and w_ == len(fl) and w_ > 3: DOC_TABLES.append((r_['name'], w_, k_, '{%s}' % mb.group(1)))
    manual = {}
    mpath = manual_csv or os.path.join(os.path.dirname(os.path.abspath(sym)), 'disasm', 'rom_operands_manual_jp.csv')
    if os.path.exists(mpath):
        for r_ in csv.DictReader(open(mpath, encoding='utf-8')): manual[(r_['site'], r_['value'])] = r_
    rows = []; edits = {}       # (bank, line) -> new text
    stats = dict(ptr=0, ptr_table_words=0, num=0, undecided=0)

    def edit(b, line, old, new):
        f, L, items = banks[b]
        edits[(b, line)] = edits.get((b, line), L[line]).replace(old, new, 1)

    # 1. pointer tables: a table label loaded into hl, indexed, read with a word idiom
    table_kind = {}
    for b, (f, L, items) in banks.items():
        for k, (line, lab, t, ad) in enumerate(items):
            m = re.match(r'^ld hl, (\w+)$', t)
            if not m or m.group(1) not in labels: continue
            j = k + 1
            while j < len(items) and items[j][2] in ('add hl, bc', 'add hl, de'): j += 1
            seq = tuple(items[x][2] for x in range(j, min(j + 3, len(items))))
            for idi, reg in IDIOMS:
                if seq == idi and reg:
                    raw = W.walk(b, j + 3, {reg}, mapped_for(b, k), abank0=abank_before(b, k))
                    r = resolve(raw, 0x4000)
                    if r[0] != 'ptr' and raw[0] == 'ptr' and raw[1] is None:     # dereferenced, mapped bank unknown: only its words below $4000 (bank 0) are decided
                        r = ('ptr0', None, None, 'C: dereferenced at %02X:%04X; words below $4000 are bank 0 whatever is mapped' % raw[3])
                    prev = table_kind.get(m.group(1))
                    if prev is None or prev[0] != 'ptr': table_kind[m.group(1)] = (r[0], r[1], r[2], '%02X:%04X' % (b, ad or 0), r[3])
    # 2a. a pointer table typed as bytes, followed by the data it points to (same block): the leading words up to the first target
    drop = set()
    for name, tk in table_kind.items():
        if tk[0] != 'ptr' or tk[1] is None or name not in labels or name not in addr: continue
        b, k0 = labels[name]; f, L, items = banks[b]
        if addr[name][0] != b or tk[1] != b: continue
        rows_ = []; data = []
        for line, lab, t, ad in items[k0 + 1:]:
            if lab: break
            if not t.startswith('db '): rows_ = None; break
            ops = [x.strip() for x in t[3:].split(',')]
            if not all(re.match(r'^\$[0-9a-f]{2}$', x) for x in ops): rows_ = None; break
            rows_.append(line); data += [int(x[1:], 16) for x in ops]
        if not rows_: continue
        start = addr[name][1]; lim = len(data); n = 0; words = []
        while 2 * n + 1 < len(data) and 2 * n < lim:
            w = data[2 * n] | data[2 * n + 1] << 8
            if not (start + 2 <= w < start + len(data)): words = []; break
            words.append(w); lim = min(lim, w - start); n += 1
        if not words or 2 * n != lim: continue                    # the words must end exactly where the first target begins
        out_ = []
        for w in words:
            e = expr(b, w); out_.append('    dw %s' % e); stats['ptr'] += 1; stats['ptr_table_words'] += 1
            rows.append((b, name, 'ptr', 'dw', '$%04X' % w, '%02X:%04X' % (b, w), e, '%s: word of a byte-typed table loaded as a pointer at %s (%s); the words end where the first target begins' % (tk[4][0], tk[3], tk[4][3:]), read(b, w)))
        rest = data[2 * n:]
        out_ += ['    db ' + ', '.join('$%02x' % x for x in rest[q:q + 16]) for q in range(0, len(rest), 16)]
        edits[(b, rows_[0])] = '\n'.join(out_)
        for line in rows_[1:]: drop.add((b, line))
    # 2'. a pointer table that points into its own block: its pointer words end where the first target begins, the rest is data
    #     (positions, counts); a word of that data that the listing wrote as a label goes back to its number
    tail = {}                                       # table label -> byte offset where its pointer words end
    for b, (f, L, items) in banks.items():
        k = 0
        while k < len(items):
            lab = items[k][1]
            tk = table_kind.get(lab) if lab else None
            if not (tk and tk[0] == 'ptr' and tk[1] == b and lab in addr and addr[lab][0] == b): k += 1; continue
            ws = []; j = k + 1
            while j < len(items) and not items[j][1] and items[j][2].startswith('dw '):
                for y in [z.strip() for z in items[j][2][3:].split(',')]:
                    v = int(y[1:], 16) if re.match(r'^\$[0-9a-f]{4}$', y) else (addr[y][1] if y in addr and addr[y][0] in (b, 0) else None)
                    ws.append((items[j][0], y, v))
                j += 1
            start = addr[lab][1]; end = start + 2 * len(ws)
            inside = [v - start for _, _, v in ws if v is not None and start < v < end]
            if inside:
                lim = min(inside); tail[lab] = lim
                for n_, (line, y, v) in enumerate(ws):
                    if 2 * n_ >= lim and not y.startswith('$') and v is not None:
                        edit(b, line, y, '$%04x' % v); stats['num'] += 1
                        rows.append((b, lab, 'num', 'dw', '$%04X' % v, '', '', 'C: data after the pointer words of the table (they end at +$%X, where the first target begins); the listing had the label %s' % (lim, y), ''))
            k = j
    # 2''. a word table that is not a pointer table and holds plain numbers: the words that the listing wrote as labels are numbers that
    #      happen to equal a label address (sound frequencies equal to bank-0 routines)
    for b, (f, L, items) in banks.items():
        k = 0
        while k < len(items):
            lab = items[k][1]
            if not lab: k += 1; continue
            j = k + 1; ws = []
            while j < len(items) and not items[j][1] and items[j][2].startswith('dw '):
                ws += [(items[j][0], y.strip()) for y in items[j][2][3:].split(',')]; j += 1
            tk = table_kind.get(lab)
            nums = sum(1 for _, y in ws if re.match(r'^\$[0-9a-f]{4}$', y) and int(y[1:], 16) >= 0x100)
            labs = [(ln, y) for ln, y in ws if re.match(r'^[A-Za-z_]\w*$', y) and y in addr]
            if labs and nums >= 3 and not (tk and tk[0] in ('ptr', 'ptr0')):
                for ln, y in labs:
                    v = addr[y][1]; edit(b, ln, y, '$%04x' % v); stats['num'] += 1; stats['label_to_num'] = stats.get('label_to_num', 0) + 1
                    rows.append((b, lab, 'num', 'dw', '$%04X' % v, '', '', 'I: word of a table that is not read as pointers and holds %d plain numbers of the same range; the listing had the label %s' % (nums, y), ''))
            k = max(j, k + 1)
    # 2. numeric words of the tables
    for b, (f, L, items) in banks.items():
        cur = None; nw = 0
        for k, (line, lab, t, ad) in enumerate(items):
            if lab: cur = lab; nw = 0; continue
            if not t.startswith('dw '): continue
            nw += t.count(',') + 1
            if cur in tail and 2 * (nw - 1) >= tail[cur]:
                for x in re.findall(r'\$([0-7][0-9a-f]{3})\b', t):
                    stats['num'] += 1; rows.append((b, cur, 'num', 'dw', '$%04X' % int(x, 16), '', '', 'C: data after the pointer words of the table (they end at +$%X, where the first target begins)' % tail[cur], ''))
                continue
            for x in re.findall(r'\$([0-7][0-9a-f]{3})\b', t):
                v = int(x, 16); tk = table_kind.get(cur)
                if v < 0x4000 and not (tk and tk[0] in ('ptr', 'ptr0')): continue      # a low word outside a pointer table: a number, not listed
                tb = 0 if v < 0x4000 else (tk[1] if tk else None)
                if tk and tk[0] == 'ptr0' and v < 0x4000 and expr(0, v):
                    e = expr(0, v); edit(b, line, '$' + x, e); stats['ptr'] += 1; stats['ptr_table_words'] += 1
                    rows.append((b, cur, 'ptr', 'dw', '$%04X' % v, '00:%04X' % v, e, '%s (table loaded at %s)' % (tk[4], tk[3]), read(0, v)))
                elif tk and tk[0] == 'ptr' and tb is not None and expr(tb, v):
                    e = expr(tb, v); tk = (tk[0], tb) + tk[2:]; edit(b, line, '$' + x, e); stats['ptr'] += 1; stats['ptr_table_words'] += 1
                    rows.append((b, cur, 'ptr', 'dw', '$%04X' % v, '%02X:%04X' % (tk[1], v), e, '%s: word of a table loaded as a pointer at %s (%s)' % (tk[4][0], tk[3], tk[4][3:]), read(tk[1], v)))
                elif tk and tk[0] == 'num':
                    stats['num'] += 1; rows.append((b, cur, 'num', 'dw', '$%04X' % v, '', '', 'C: the reader at %s takes the bytes apart' % tk[3], ''))
                else:
                    stats['undecided'] += 1; rows.append((b, cur, '?', 'dw', '$%04X' % v, '', '', 'no reader that loads it as a word found' if not tk else 'the loaded word is not followed to a use', ''))
    # 3'. a font base handed to a routine that takes the bank in C (`ld c, $BB` / `ld hl, base` / `call Glyph_LoadFromCharCode`):
    #     the base is an address of bank BB, whatever the listing wrote (a number, or a label of the current bank at the same address)
    handled = set()
    for b, (f, L, items) in banks.items():
        for k in range(1, len(items) - 1):
            line, lab, t, ad = items[k]
            m = re.match(r'^ld hl, (\$[4-7][0-9a-f]{3}|[A-Za-z_]\w*)$', t)
            mc = re.match(r'^ld c, (?:\$([0-9a-f]{2})|BANK\((\w+)\))$', items[k - 1][2])
            if not (m and mc) or items[k - 1][1]: continue
            if not any(re.match(r'^call (%s)$' % '|'.join(C_BANK_CALLEES), items[q][2]) for q in range(k + 1, min(k + 4, len(items)))): continue
            v = int(m.group(1)[1:], 16) if m.group(1).startswith('$') else addr.get(m.group(1), (None, None))[1]
            tb = int(mc.group(1), 16) if mc.group(1) else addr.get(mc.group(2), (None,))[0]
            if v is None or tb is None or not expr(tb, v): continue
            e = expr(tb, v); edit(b, line, m.group(1), e)
            edits[(b, items[k - 1][0])] = re.sub(r'ld c, (\$[0-9a-f]{2}|BANK\(\w+\))', 'ld c, BANK(%s)' % e.split(' ')[0], edits.get((b, items[k - 1][0]), L[items[k - 1][0]]), 1)
            handled.add((b, line)); stats['ptr'] += 1
            if not m.group(1).startswith('$') and addr[m.group(1)][0] != tb: stats['wrong_bank'] = stats.get('wrong_bank', 0) + 1
            rows.append((b, '%02X:%04X' % (b, ad or 0), 'ptr', 'hl', '$%04X' % v, '%02X:%04X' % (tb, v), e, 'C: font base handed to %s with the bank in C%s' % (items[k + 1][2][5:] if items[k + 1][2].startswith('call') else 'the glyph loader', '' if m.group(1).startswith('$') else '; the listing had %s (bank %02X)' % (m.group(1), addr[m.group(1)][0])), read(tb, v)))
    # 3. immediate loads
    for b, (f, L, items) in banks.items():
        for k, (line, lab, t, ad) in enumerate(items):
            m = re.match(r'^ld (hl|bc|de), \$([0-7][0-9a-f]{3})$', t)
            if not m or int(m.group(2), 16) < 0x100 or (b, line) in handled: continue
            reg, v = m.group(1), int(m.group(2), 16)
            low = v < 0x4000                                # bank 0: always mapped, no bank in A to rewrite
            mp = 0 if low else mapped_for(b, k)
            W.added = False
            r = resolve(W.walk(b, k + 1, {reg}, mp, abank0=None if low else abank_before(b, k)), v)
            if low and W.added and r[0] == 'ptr': r = ('?', None, None, 'added to HL before the dereference: a bank-0 base or an offset')
            if low and r[0] == 'ptr': r = ('ptr', 0, None, r[3])
            site = '%02X:%04X' % (b, ad or 0)
            mr = manual.get((site, '$%04X' % v))
            if r[0] != 'ptr' and mr:                          # read by hand (rom_operands_manual_jp.csv)
                tb = int(mr['bank'], 16); al = None
                if mr['bank_site']:
                    sb, sa = int(mr['bank_site'][:2], 16), int(mr['bank_site'][3:], 16)
                    al = next(((sb, it[0]) for it in banks[sb][2] if it[3] == sa and not it[1]), None)
                r = ('ptr', tb, al, mr['evidence'])
            if r[0] == 'ptr' and r[1] is not None and expr(r[1], v):
                e = expr(r[1], v); edit(b, line, '$%04x' % v, e); stats['ptr'] += 1
                if r[2]:
                    ab, al = r[2]
                    edits[(ab, al)] = re.sub(r'ld ([ac]), \$[0-9a-f]{2}', lambda mm: 'ld %s, BANK(%s)' % (mm.group(1), e.split(' ')[0]), edits.get((ab, al), banks[ab][1][al]), 1)
                rows.append((b, site, 'ptr', reg, '$%04X' % v, '%02X:%04X' % (r[1], v), e, r[3], read(r[1], v)))
            elif r[0] == 'num':
                stats['num'] += 1; rows.append((b, site, 'num', reg, '$%04X' % v, '', '', r[3], ''))
            else:
                stats['undecided'] += 1; rows.append((b, site, '?', reg, '$%04X' % v, '', '', r[3], ''))
    # 3b. labels already written by the listing: a `ld r16, Label` or a table word whose label sits in another bank than the one the
    #     code reads (the automatic labeller names a number after a label of the current bank). Rewritten with a label of the right bank.
    wrong = stats.get('wrong_bank', 0)
    for b, (f, L, items) in banks.items():
        for k, (line, lab, t, ad) in enumerate(items):
            m = re.match(r'^ld (hl|bc|de), ([A-Za-z_]\w*)$', t)
            if not m or m.group(2) not in addr or (b, line) in handled: continue
            lb, v = addr[m.group(2)]
            if lb == 0 or not (0x4000 <= v < 0x8000): continue
            reg = m.group(1); mp = mapped_for(b, k)
            raw = W.walk(b, k + 1, {reg}, mp, abank0=abank_before(b, k))
            if raw[0] == 'store':                          # the listing named a number that is written through (a VRAM / RAM base)
                edit(b, line, m.group(2), '$%04x' % v); stats['num'] += 1; stats['label_to_num'] = stats.get('label_to_num', 0) + 1
                rows.append((b, '%02X:%04X' % (b, ad or 0), 'num', reg, '$%04X' % v, '', '', resolve(raw, v)[3] + '; the listing had the label %s' % m.group(2), ''))
                continue
            r = resolve(raw, v)
            if r[0] == 'ptr' and r[1] is not None and r[1] != lb and expr(r[1], v):
                e = expr(r[1], v); edit(b, line, m.group(2), e); stats['ptr'] += 1; wrong += 1
                if r[2]:
                    ab, al = r[2]
                    edits[(ab, al)] = re.sub(r'ld a, (\$[0-9a-f]{2}|BANK\(\w+\))', 'ld a, BANK(%s)' % e.split(' ')[0], edits.get((ab, al), banks[ab][1][al]), 1)
                rows.append((b, '%02X:%04X' % (b, ad or 0), 'ptr', reg, '$%04X' % v, '%02X:%04X' % (r[1], v), e, r[3] + '; the listing had %s (bank %02X), the wrong bank' % (m.group(2), lb), read(r[1], v)))
    for b, (f, L, items) in banks.items():
        cur = None
        for k, (line, lab, t, ad) in enumerate(items):
            if lab: cur = lab; continue
            if not t.startswith('dw '): continue
            tk = table_kind.get(cur)
            if not (tk and tk[0] == 'ptr' and tk[1] is not None): continue
            for nm in re.findall(r'\b([A-Za-z_]\w*)\b', t[3:]):
                if nm not in addr: continue
                lb, v = addr[nm]
                if lb == 0 or lb == tk[1] or not (0x4000 <= v < 0x8000) or not expr(tk[1], v): continue
                e = expr(tk[1], v); edit(b, line, nm, e); stats['ptr'] += 1; stats['ptr_table_words'] += 1; wrong += 1
                rows.append((b, cur, 'ptr', 'dw', '$%04X' % v, '%02X:%04X' % (tk[1], v), e, '%s: word of a table loaded as a pointer at %s (%s); the listing had %s (bank %02X), the wrong bank' % (tk[4][0], tk[3], tk[4][3:], nm, lb), read(tk[1], v)))
    stats['wrong_bank'] = wrong
    # 4. numeric call / jp targets in $4000-$7FFF (a bank-0 trampoline that maps a bank and calls a fixed entry of it)
    for b, (f, L, items) in banks.items():
        for k, (line, lab, t, ad) in enumerate(items):
            m = re.match(r'^(call|jp) \$([4-7][0-9a-f]{3})$', t)
            if not m: continue
            v = int(m.group(2), 16); mp = mapped_for(b, k); site = '%02X:%04X' % (b, ad or 0)
            if mp is not None and expr(mp, v):
                e = expr(mp, v); edit(b, line, '$%04x' % v, e); stats['ptr'] += 1
                rows.append((b, site, 'ptr', m.group(1), '$%04X' % v, '%02X:%04X' % (mp, v), e, 'C: %s target with bank %02X written to the MBC just before' % (m.group(1), mp), read(mp, v)))
            else:
                stats['undecided'] += 1; rows.append((b, site, '?', m.group(1), '$%04X' % v, '', '', 'the mapped bank is unknown', ''))
    # 5. an address stored as two byte immediates into a variable (ld a, LO / ld [wX], a / ld a, HI / ld [wX + $1], a): written
    #    LOW(Label) / HIGH(Label) only when the value is exactly the address of a label of the mapped bank (a resume address, a callback)
    for b, (f, L, items) in banks.items():
        C_ = [(k, it) for k, it in enumerate(items) if not it[1]]
        for n in range(len(C_) - 3):
            (k0, i0), (k1, i1), (k2, i2), (k3, i3) = C_[n:n + 4]
            if k3 - k0 != 3: continue
            m1 = re.match(r'^ld a, \$([0-9a-f]{2})$', i0[2]); m2 = re.match(r'^ld \[(w\w+)\], a$', i1[2])
            m3 = re.match(r'^ld a, \$([4-7][0-9a-f])$', i2[2]); m4 = re.match(r'^ld \[(w\w+) \+ \$1\], a$', i3[2])
            if not (m1 and m2 and m3 and m4 and m2.group(1) == m4.group(1)): continue
            v = int(m3.group(1) + m1.group(1), 16); mp = mapped_for(b, k0); e = expr(mp, v) if mp is not None else None
            site = '%02X:%04X' % (b, i0[3] or 0)
            if e and '+' not in e:
                edit(b, i0[0], '$' + m1.group(1), 'LOW(%s)' % e); edit(b, i2[0], '$' + m3.group(1), 'HIGH(%s)' % e); stats['ptr'] += 1
                rows.append((b, site, 'ptr', 'lo/hi', '$%04X' % v, '%02X:%04X' % (mp, v), e, 'I: low and high byte stored to %s / %s + 1; the value is exactly the address of %s' % (m2.group(1), m2.group(1), e), read(mp, v)))
            else:
                stats['num'] += 1; rows.append((b, site, 'num', 'lo/hi', '$%04X' % v, '', '', 'I: two bytes stored to %s; no label at that address (data)' % m2.group(1), ''))
    # 5b. a ROM byte read by its absolute address (`ld a, [$XXXX]`, a constant of the code or a table byte): the address of the mapped bank
    for b, (f, L, items) in banks.items():
        for k, (line, lab, t, ad) in enumerate(items):
            m = re.match(r'^ld a, \[\$([0-7][0-9a-f]{3})\]$', t)
            if not m: continue
            v = int(m.group(1), 16); tb = 0 if v < 0x4000 else mapped_for(b, k); site = '%02X:%04X' % (b, ad or 0)
            if tb is not None and expr(tb, v):
                e = expr(tb, v); edit(b, line, '$' + m.group(1), e); stats['ptr'] += 1
                rows.append((b, site, 'ptr', '[abs]', '$%04X' % v, '%02X:%04X' % (tb, v), e, 'C: ROM byte read by its address (bank %02X mapped)' % tb, read(tb, v)))
            else:
                stats['undecided'] += 1; rows.append((b, site, '?', '[abs]', '$%04X' % v, '', '', 'the mapped bank is unknown', ''))
    # 5d. hand-written expressions (rom_operands_manual_jp.csv, column expr): an operand computed from a table address, e.g. `add HIGH(Table)`
    for (msite, mval), mr in manual.items():
        if not mr.get('expr'): continue
        if msite in labels:                                  # a data word: the first word of that table
            sb, k0 = labels[msite]; it = banks[sb][2][k0 + 1]
        else:
            sb, sa = int(msite[:2], 16), int(msite[3:], 16)
            it = next((x for x in banks[sb][2] if x[3] == sa and not x[1]), None)
        mv_ = mval if mval in it[2] else mval.lower()
        if not it or mv_ not in it[2]: stats['undecided'] += 1; continue
        edit(sb, it[0], mv_, mr['expr']); stats['ptr'] += 1
        tbm = re.search(r'\((\w+)\)', mr['expr']); tbn = tbm.group(1) if tbm else None
        if mr['expr'].startswith('HIGH(') and tbn in labels: aligned_manual[tbn] = int(mr['bank'], 16)
        if mr['expr'].startswith('$'): stats['ptr'] -= 1; stats['num'] += 1; stats['label_to_num'] = stats.get('label_to_num', 0) + 1
        rows.append((sb, msite, 'num' if mr['expr'].startswith('$') else 'ptr', 'expr', mval, '%s:%04X' % (mr['bank'], addr[tbn][1]) if tbn in addr else '', mr['expr'], mr['evidence'], ''))
    # 5c. a table page in a high-byte register (`ld h, $73` ... `ld l, a` / `ld a, [hl]`): written HIGH(Table) when a label sits at $XX00 of
    #     the mapped bank and the pair is dereferenced before the high register changes; the table gets `ASSERT LOW(Table) == 0`
    aligned = {}
    for b, (f, L, items) in banks.items():
        for k, (line, lab, t, ad) in enumerate(items):
            m = re.match(r'^ld ([hbd]), \$([0-7][0-9a-f])$', t)
            if not m or m.group(2) == '00': continue
            hi = m.group(1); pr = {'h': 'hl', 'b': 'bc', 'd': 'de'}[hi]; v = int(m.group(2), 16) << 8
            tb = 0 if v < 0x4000 else mapped_for(b, k)
            nm = next((n for a_, pr_, n in inbank.get(tb, []) if a_ == v and pr_), None) if tb is not None else None
            if not nm: continue
            def deref_ahead(bk, k1, depth):
                """[pair] read ahead of item k1 (through fall-through labels and into a called routine) before the high register changes"""
                its = banks[bk][2]
                for q in range(k1, min(k1 + 40, len(its))):
                    tq = its[q][2]
                    if not tq: continue                                         # a label: fall through
                    if re.search(r'\[%s[+-]?\]' % pr, tq) and not re.match(r'^ld \[%s' % pr, tq): return True
                    mcall = re.match(r'^call (\w+)$', tq)
                    if mcall and depth < 1 and mcall.group(1) in labels:
                        cb, ck = labels[mcall.group(1)]
                        if deref_ahead(cb, ck + 1, depth + 1): return True
                        continue
                    if re.match(r'^(ld %s,|pop %s|inc %s|dec %s|ld %s, )' % (hi, pr, pr, pr, pr), tq) or re.match(r'^(ret|reti|jp |call |rst )', tq): return False
                return False
            ok = deref_ahead(b, k + 1, 0)
            site = '%02X:%04X' % (b, ad or 0)
            if ok:
                edit(b, line, '$' + m.group(2), 'HIGH(%s)' % nm); stats['ptr'] += 1; aligned[nm] = tb
                rows.append((b, site, 'ptr', hi, '$%02X' % (v >> 8), '%02X:%04X' % (tb, v), 'HIGH(%s)' % nm, 'C: page of a 256-byte table in %s, dereferenced with the low byte as index' % hi.upper(), read(tb, v)))
    aligned.update(aligned_manual)
    for nm, tb in aligned.items():
        bb, kk = labels[nm]; ln = banks[bb][2][kk][0]
        inserts_after[(bb, ln)] = '    ASSERT LOW(%s) == 0 ; read as a page: HIGH(%s) with the index in the low byte' % (nm, nm)
    stats['aligned'] = len(aligned)
    # 6. pointers stored in data records: code that builds a register pair from two memory reads (`ld a, [hl+]` / `ld h, [hl]` / `ld l, a`,
    #    `ld c, [hl]` / `inc hl` / `ld b, [hl]`, ...) and then uses it as an address (the walk above). The bytes those two reads took in the
    #    core's runs (rdr) are pointer words; when a third read right after gives the bank handed to a banked copy, the record is {lo, hi, bank}.
    if rdr is not None:
        stats.update(record_pointers(banks, labels, addr, inbank, rom, rdr, dr, W, resolve, mapped_for, expr, edits, drop, rows))
    # 7. a pointer to an instruction inside a routine (a callback, a resume address): a label is written at that instruction
    #    (`Routine_AAAA`) so that the pointer follows the code when the routine itself changes size
    inserts = {}; code_at = {}
    for b, (f, L, items) in banks.items():
        for line, lab, t, ad in items:
            if not lab and ad is not None and t and not t.startswith(('db ', 'dw ', 'ds ', 'INCBIN', 'dwb ')): code_at[(b, ad)] = line
    newname = {}
    for n_, r in enumerate(rows):
        if r[2] != 'ptr' or ' + $' not in (r[6] or ''): continue
        tb, v = int(r[5][:2], 16), int(r[5][3:], 16)
        if (tb, v) not in code_at: continue
        nm = newname.get(r[6]) or '%s_%04X' % (r[6].split(' ')[0], v)
        newname[r[6]] = nm; inserts[(tb, code_at[(tb, v)])] = nm
        rows[n_] = r[:6] + (nm,) + r[7:]
    if newname:
        pat = re.compile('|'.join(re.escape(e) + r'(?![0-9A-Fa-f])' for e in sorted(newname, key=len, reverse=True)))
        for k_ in list(edits): edits[k_] = pat.sub(lambda mm: newname[mm.group(0)], edits[k_])
    stats['code_labels'] = len(set(inserts.values()))
    # write
    for (b, line), new in edits.items():
        f, L, items = banks[b]
        if '\n' in new: L[line] = new; continue
        old = L[line]; code, sep, com = new.partition(';')
        L[line] = (code.rstrip().ljust(49) + ' ;' + com) if sep else new.rstrip()
    for b, (f, L, items) in banks.items():
        open(os.path.join(out, f), 'w', encoding='utf-8', newline='\n').write('\n'.join((inserts[(b, n_)] + ':\n' if (b, n_) in inserts else '') + l + ('\n' + inserts_after[(b, n_)] if (b, n_) in inserts_after else '') for n_, l in enumerate(L) if (b, n_) not in drop))
    if report:
        with open(report, 'w', encoding='utf-8', newline='') as fh:
            w = csv.writer(fh, lineterminator='\n'); w.writerow(('bank', 'site', 'kind', 'operand', 'value', 'target', 'expression', 'evidence', 'read'))
            for r in sorted(rows, key=lambda r: (r[0], r[1])): w.writerow(('%02X' % r[0],) + tuple(r[1:]))
    stats['read_no'] = sum(1 for r in rows if r[2] == 'ptr' and r[8] == 'no'); stats['ptr_i'] = sum(1 for r in rows if r[2] == 'ptr' and r[7].startswith('I'))
    return stats
