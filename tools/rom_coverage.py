#!/usr/bin/env python3
"""Coverage report built on rom_trace.py output.

usage: rom_coverage.py <rom.gb> <trace.json> [--csv out.csv]

For every bank: bytes proven code (reachable instructions), bytes of inline jump/mode tables, and the rest, split into
  * referenced data : a proven instruction loads the address of that region (`ld hl/de/bc,nn`, `ld [nn],sp`...)
                      or a table word points to it;
  * padding         : >= 90 % of the region is $00 or $FF;
  * unreferenced    : nothing in the proven code points into the region (graphics/sound data only reachable through
                      computed addresses, or genuinely unreachable code);
The 'unreferenced' bytes inside the *code banks* are what has to be examined by hand.
"""
import sys, json, collections


def main():
    rom = open(sys.argv[1], 'rb').read()
    d = json.load(open(sys.argv[2]))
    code = {}
    for k, n in d['code'].items():
        b, a = k.split(':')
        code[(int(b, 16), int(a, 16))] = n
    nb = len(rom) // 0x4000
    state = [bytearray(0x4000) for _ in range(nb)]   # 0 unknown, 1 code, 2 table, 3 referenced data
    base = lambda b: 0 if b == 0 else 0x4000

    for (b, a), n in code.items():
        o = a - base(b) if a >= 0x4000 or b == 0 else None
        if o is None or not 0 <= o < 0x4000:
            continue
        if n > 0:
            for i in range(n):
                if o + i < 0x4000:
                    state[b][o + i] = 1
        elif n < 0:
            state[b][o] = 2

    # data references: operands of ld rr,nn / ld [nn],sp / ldh-less accesses with ROM addresses, from proven instructions
    refs = collections.defaultdict(set)
    for (b, a), n in code.items():
        if n != 3:
            continue
        p = b * 0x4000 + (a - 0x4000) if a >= 0x4000 else a
        op = rom[p]
        if op in (0x01, 0x11, 0x21, 0x31, 0xFA, 0xEA, 0x08):
            w = rom[p + 1] | (rom[p + 2] << 8)
            if 0x0100 <= w < 0x8000:
                refs[b].add(w)
                if b == 0 or w < 0x4000:
                    refs[0].add(w)
                else:
                    # a bank-0 routine copying from a banked address: bank unknown -> attribute to every banked code bank
                    for bb in range(1, nb):
                        refs[('any', bb)].add(w) if b == 0 else None
    # ROM data blocks referenced by proven calls that load A = bank, HL = banked source address (copy/decompress helpers such as
    # $0450 [length = BC], $05F8, $0479, $0D10 ...).  Lower bound: only blocks with a known length; upper bound: from the start
    # address up to the next referenced start or proven code byte of that bank.
    starts = collections.defaultdict(dict)       # bank -> {start_addr: known_len or None}
    for (cb, cpc, callee, a, hl, bc, de) in d.get('callargs', []):
        if a is not None and 1 <= a < nb and hl is not None and 0x4000 <= hl < 0x8000:
            ln = bc if (callee == 0x0450 and bc) else None
            if hl not in starts[a] or (ln and not starts[a][hl]):
                starts[a][hl] = ln
    for b_, dd in starts.items():
        for w, ln in dd.items():
            o = w - 0x4000
            if ln:
                for i in range(o, min(o + ln, 0x4000)):
                    if state[b_][i] == 0:
                        state[b_][i] = 4            # referenced data, length known
            else:
                refs[b_].add(w)
    # inline word tables (rst $18, jp tables, mode table): their targets are code, already traced; table bytes = state 2
    out = []
    tot = collections.Counter()
    print(f'{"bank":4s} {"code":>6s} {"table":>6s} {"refdata":>8s} {"(len ok)":>8s} {"padding":>8s} {"unref":>7s}   notes')
    for b in range(nb):
        st = state[b]
        # mark referenced-data regions: from a referenced address, extend over the following unknown bytes up to the next code byte
        rset = set(refs[b]) | set(refs.get(('any', b), set()))
        for w in rset:
            o = w - base(b)
            if b != 0 and w < 0x4000:
                continue
            if not 0 <= o < 0x4000:
                continue
            while o < 0x4000 and st[o] in (0, 4):
                if st[o] == 0:
                    st[o] = 3
                o += 1
        # split remaining unknown
        c = collections.Counter(st)
        lenok = c[4]
        c[3] += c[4]
        pad = unref = 0
        s = None
        regions = []
        for i in range(0x4001):
            v = st[i] if i < 0x4000 else 1
            if v == 0 and s is None:
                s = i
            if v != 0 and s is not None:
                seg = rom[b * 0x4000 + s: b * 0x4000 + i]
                z = sum(1 for x in seg if x in (0, 0xFF)) / len(seg)
                if z >= 0.9:
                    pad += len(seg)
                else:
                    unref += len(seg)
                    regions.append((s + base(b), i - 1 + base(b), len(seg)))
                s = None
        notes = ''
        if c[1]:
            notes = 'code bank'
        out.append((b, c[1], c[2], c[3], pad, unref, regions))
        tot['lenok'] += lenok
        tot.update(code=c[1], table=c[2], refdata=c[3], pad=pad, unref=unref)
        print(f'{b:02x}   {c[1]:6d} {c[2]:6d} {c[3]:8d} {lenok:8d} {pad:8d} {unref:7d}   {notes}')
    print(f'TOTAL code {tot["code"]} B, tables {tot["table"]} B, referenced data {tot["refdata"]} B, padding {tot["pad"]} B, '
          f'unreferenced {tot["unref"]} B (of {nb * 0x4000}); referenced data with a known length: {tot["lenok"]} B')
    print('\nUnreferenced regions >= 32 B inside the code banks (these are the ones to review):')
    code_banks = {b for b, c1, *_ in out if c1}
    for b, c1, c2, c3, pad, unref, regions in out:
        if b in code_banks:
            for s, e, n in regions:
                if n >= 32:
                    print(f'  {b:02x}:{s:04x}-{e:04x}  {n:5d} B  {rom[b * 0x4000 + s - base(b): b * 0x4000 + s - base(b) + 10].hex(" ")}')
    if '--csv' in sys.argv:
        import csv
        with open(sys.argv[sys.argv.index('--csv') + 1], 'w', newline='') as f:
            w = csv.writer(f)
            w.writerow(['bank', 'code_B', 'inline_table_B', 'referenced_data_B', 'padding_B', 'unreferenced_B'])
            for b, c1, c2, c3, pad, unref, regions in out:
                w.writerow([f'{b:02x}', c1, c2, c3, pad, unref])


if __name__ == '__main__':
    main()
