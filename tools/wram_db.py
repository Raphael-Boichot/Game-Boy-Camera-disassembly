#!/usr/bin/env python3
"""Build the WRAM/HRAM access database from the *proven* code (rom_trace.py output) of the Pocket Camera ROM.

usage: wram_db.py <rom.gb> <trace.json> <sym> <out_prefix>
writes   <out_prefix>_access.csv   one line per instruction touching $C000-$DFFF / $FF80-$FFFE / $FF00-$FF7F (I/O)
         <out_prefix>_summary.csv  one line per address: reads, writes, pointer loads, banks, functions, written constants

Access kinds: R = ld a,[nn] / ldh a,[n]; W = ld [nn],a / ldh [n],a / ld [nn],sp; P = ld rr,nn whose operand is a RAM address
(the address is used as a base/pointer: arrays, buffers, structures).  Read-modify-write through HL is not visible here
(`ld hl,$D615 ... inc [hl]` shows as P on $D615 and the instruction is found by reading the code).
"""
import sys, json, csv, collections, re
sys.path.insert(0, __file__.rsplit('/', 1)[0])
from rom_trace import Rom, load_sym

CONST_OPS = {0x3E: 'imm'}


def main():
    rom = Rom(sys.argv[1])
    tr = json.load(open(sys.argv[2]))
    sym_code, sym_data = load_sym(sys.argv[3])
    prefix = sys.argv[4]
    names = {(b, a): n for b, a, n in sym_code + sym_data}
    code = {}
    for k, n in tr['code'].items():
        b, a = k.split(':')
        if n > 0:
            code[(int(b, 16), int(a, 16))] = n
    # function entries: every non-'flow' entry
    fe = collections.defaultdict(list)
    for k, kind in tr['entries'].items():
        b, a = k.split(':')
        b, a = int(b, 16), int(a, 16)
        if kind != 'flow':
            fe[b].append(a)
    for b in fe:
        fe[b].sort()
    import bisect

    def func_of(b, pc):
        lst = fe.get(b if pc >= 0x4000 else 0, [])
        i = bisect.bisect_right(lst, pc) - 1
        if i < 0:
            return ''
        a = lst[i]
        bb = b if pc >= 0x4000 else 0
        return names.get((bb, a), f'{bb:02x}:{a:04x}')

    # previous-instruction map for constant tracking
    end_of = {}
    for (b, a), n in code.items():
        end_of[(b, a + n)] = (b, a)

    def prev_const(b, pc):
        """value in A if the instruction right before pc (straight line) is `ld a,n` or `xor a`; else None"""
        p = end_of.get((b, pc))
        if not p:
            return None
        op = rom.b(p[0], p[1])
        if op == 0x3E:
            return rom.b(p[0], p[1] + 1)
        if op == 0xAF:
            return 0
        return None

    rows = []
    for (b, a), n in sorted(code.items()):
        op = rom.b(b, a)
        kind = addr = None
        if n == 3:
            nn = rom.w(b, a + 1)
            if op == 0xEA:
                kind, addr = 'W', nn
            elif op == 0xFA:
                kind, addr = 'R', nn
            elif op == 0x08:
                kind, addr = 'W2', nn
            elif op in (0x01, 0x11, 0x21, 0x31):
                kind, addr = 'P', nn
        elif n == 2 and op in (0xE0, 0xF0):
            nn = 0xFF00 + rom.b(b, a + 1)
            kind, addr = ('W' if op == 0xE0 else 'R'), nn
        if kind is None:
            continue
        if not (0xC000 <= addr <= 0xDFFF or 0xFE00 <= addr <= 0xFFFE):
            continue
        val = prev_const(b, a) if kind == 'W' else None
        rows.append((addr, kind, b, a, func_of(b, a), val))

    with open(prefix + '_access.csv', 'w', newline='') as f:
        w = csv.writer(f)
        w.writerow(['addr', 'kind', 'bank', 'pc', 'function', 'const_written'])
        for addr, kind, b, a, fn, val in rows:
            w.writerow([f'{addr:04x}', kind, f'{b:02x}', f'{a:04x}', fn, '' if val is None else f'{val:02x}'])

    st = collections.defaultdict(lambda: dict(R=0, W=0, P=0, banks=collections.Counter(), funcs=collections.Counter(), vals=collections.Counter()))
    for addr, kind, b, a, fn, val in rows:
        s = st[addr]
        s['W' if kind == 'W2' else kind] += 1
        s['banks'][f'{b:02x}'] += 1
        if fn:
            s['funcs'][fn] += 1
        if val is not None:
            s['vals'][f'{val:02x}'] += 1
    with open(prefix + '_summary.csv', 'w', newline='') as f:
        w = csv.writer(f)
        w.writerow(['addr', 'region', 'reads', 'writes', 'ptr_loads', 'banks', 'top_functions', 'written_consts'])
        for addr in sorted(st):
            s = st[addr]
            reg = 'HRAM' if 0xFF80 <= addr else ('OAM/IO' if addr >= 0xFE00 else 'WRAM')
            w.writerow([f'{addr:04x}', reg, s['R'], s['W'], s['P'],
                        ' '.join(f'{k}:{v}' for k, v in sorted(s['banks'].items())),
                        ' '.join(f'{k}:{v}' for k, v in s['funcs'].most_common(4)),
                        ' '.join(f'{k}:{v}' for k, v in s['vals'].most_common(6))])
    print('accesses', len(rows), 'distinct addresses', len(st))


if __name__ == '__main__':
    main()
