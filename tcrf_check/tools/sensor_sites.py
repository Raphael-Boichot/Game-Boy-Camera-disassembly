#!/usr/bin/env python3
"""List every traced instruction of the Japanese ROM that writes or reads a camera register ($A000-$A005, `ld [$A00n],a` / `ld a,[$A000]`) with the datasheet name of the
register and, when the previous instruction loads an immediate, the value (README section 18.2).  Indirect forms (`ld hl,$A000` ... `ld [hl],a`) are listed by sensor_sites.py
only as a check: every one is in bank 2/6/9 or a polling loop (they read the busy bit or copy the image; the RAM bank is not $10 there) or in bank 0A band handlers (RAM bank 0).
usage: sensor_sites.py ROM.gb TRACE.json SYM OUT.csv       (TRACE.json = wram/trace_jp_v3.json, SYM = pocketcamera_jp.sym)"""
import sys, json, csv, collections

REG = {0xA000: ('A000', 'control', 'start (bit 0, polled until clear)'),
       0xA001: ('A001', 'reg1 (001)', 'N VH1 VH0 G4-G0'),
       0xA002: ('A002', 'reg2 (010)', 'C1 exposure high byte (4.096 ms)'),
       0xA003: ('A003', 'reg3 (011)', 'C0 exposure low byte (16 us)'),
       0xA004: ('A004', 'reg7 (111)', 'E3-E0 I V2-V0'),
       0xA005: ('A005', 'reg0 (000)', 'Z1 Z0 O5-O0')}


def off(b, a): return a if a < 0x4000 else b * 0x4000 + a - 0x4000


def main(rom_fn, trace_fn, sym_fn, out_fn):
    rom = open(rom_fn, 'rb').read()
    tr = json.load(open(trace_fn))
    code = {tuple(int(x, 16) for x in k.split(':')): v for k, v in tr['code'].items() if v > 0}
    pred = collections.defaultdict(list)
    for (b, a), ln in code.items(): pred[(b, a + ln)].append(a)
    syms = collections.defaultdict(list)
    for l in open(sym_fn):
        p = l.split()
        if len(p) == 2 and ':' in p[0] and not p[1].startswith('.'):
            bb, aa = p[0].split(':'); syms[int(bb, 16)].append((int(aa, 16), p[1]))
    for k in syms: syms[k].sort()

    def label(b, a):
        best = None
        for x, n in syms.get(b, []):
            if x <= a: best = n
        return best or ''

    def prev(b, a):
        out = []
        for p in pred.get((b, a), []):
            o = off(b, p); op = rom[o]
            if op == 0x3E: out.append('ld a,$%02X' % rom[o + 1])
            elif op == 0xAF: out.append('xor a (0)')
            elif op == 0xFA: out.append('ld a,[$%04X]' % (rom[o + 1] | rom[o + 2] << 8))
            elif op == 0xF0: out.append('ldh a,[$FF%02X]' % rom[o + 1])
            elif op == 0xF6: out.append('or $%02X' % rom[o + 1])
            elif op == 0xE6: out.append('and $%02X' % rom[o + 1])
            elif op == 0xCB: out.append('cb %02X (set/res bit)' % rom[o + 1])
            elif op == 0xEA: out.append('(same value as the previous write)')
            else: out.append('op %02X' % op)
        return ' | '.join(out)

    rows = []
    for (b, a), ln in sorted(code.items()):
        o = off(b, a)
        if ln == 3 and rom[o] in (0xEA, 0xFA):
            t = rom[o + 1] | rom[o + 2] << 8
            if 0xA000 <= t <= 0xA005 and (rom[o] == 0xEA or t == 0xA000):
                rows.append(['%02X:%04X' % (b, a), 'write' if rom[o] == 0xEA else 'read', '$%04X' % t, REG[t][1], REG[t][2], label(b, a), prev(b, a)])
    with open(out_fn, 'w', newline='') as f:
        w = csv.writer(f); w.writerow(['site', 'access', 'address', 'sensor register', 'bits', 'routine (nearest label)', 'value source (previous instruction)'])
        w.writerows(rows)
    c = collections.Counter((r[1], r[2]) for r in rows)
    print(len(rows), 'sites:', ', '.join('%s %s x%d' % (k[0], k[1], v) for k, v in sorted(c.items())))


if __name__ == '__main__': main(*sys.argv[1:5])
