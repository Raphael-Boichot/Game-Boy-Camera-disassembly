#!/usr/bin/env python3
"""Check the O-register successive-approximation search (Cam_ORegister_SAR_Search, 0A:4B6A) against recorded register loads.

The search writes reg0 = $BF (Z = 10, O = +1 V), maybe $9F (O = -1 V), then $A0 (O = 0 V) and six table-driven steps: after each capture the next reg0 is
Above[reg0 & $3F] when the pixel test said 'dark' (A <> 0) and Below[reg0 & $3F] otherwise (tables 0A:7BA0 and 0A:7BE0, 64 bytes each).  The pixel test result is not on
the sensor bus, so each step is checked to be *one of the two* table entries; the result of the search (the reg0 the next routine uses) is the entry after the sixth capture.
usage: sensor_sar_check.py ROM.gb BOOT.xlsx CALIB.xlsx            (real recordings)
       sensor_sar_check.py ROM.gb --bgb CAPTURES.csv [...]          (BGB capture csv written by sensor_bgb_log.py)"""
import sys, csv
sys.path.insert(0, __file__.rsplit('/', 1)[0])


def tables(rom):
    base = 0x0A * 0x4000 - 0x4000
    return list(rom[base + 0x7BA0: base + 0x7BA0 + 64]), list(rom[base + 0x7BE0: base + 0x7BE0 + 64])


def check_group(o_seq, ABOVE, BELOW):
    """o_seq: reg0 values of the captures of one group, from the first $A0 on (6 table-driven captures: $A0 then 5 more). -> (ok_steps, total_steps, result candidates)"""
    ok = tot = 0
    for a, b in zip(o_seq, o_seq[1:]):
        tot += 1
        if b in (ABOVE[a & 0x3F], BELOW[a & 0x3F]): ok += 1
    last = o_seq[-1]
    return ok, tot, (ABOVE[last & 0x3F], BELOW[last & 0x3F])


def real_groups(rows):
    """rows from sensor_decode.rows_of -> list of (reg1, reg7, C, [reg0 of the table-driven captures], [all reg0])"""
    groups, cur = [], None
    for d in rows:
        if d['reg0'] == 0xBF and (cur is None or cur['allo'][-1] != 0xBF or d['reg1'] != cur['reg1'] or d['reg7'] != cur['reg7']):
            if cur: groups.append(cur)
            cur = dict(reg1=d['reg1'], reg7=d['reg7'], C=d['C'], allo=[0xBF])
        elif cur is not None and (d['reg1'], d['C']) == (cur['reg1'], cur['C']): cur['allo'].append(d['reg0'])
        else:
            if cur: groups.append(cur)
            cur = None
    if cur: groups.append(cur)
    for g in groups:
        o = g['allo']; i = o.index(0xA0) if 0xA0 in o else None
        g['table'] = o[i:i + 6] if i is not None else []
    return groups


if __name__ == '__main__':
    rom = open(sys.argv[1], 'rb').read(); ABOVE, BELOW = tables(rom)
    import sensor_decode as D
    if sys.argv[2] == '--bgb':
        for fn in sys.argv[3:]:
            rows = list(csv.DictReader(open(fn))); tot = ok = ng = 0
            seq = []
            for r in rows + [dict(pc='END', reg0='00')]:
                if r['pc'].endswith(':4BFD') or (r['pc'].endswith(':4BF1') ): pass
                if r['pc'] == '0A:4BFD':
                    seq.append(int(r['reg0'], 16))
                else:
                    # a table-driven run ends; a run starts with $A0 (the capture at 4BFD that follows the 4BF1 write)
                    if seq:
                        # the first 4BFD capture of a group has reg0 = $A0
                        if seq[0] == 0xA0:
                            a, b, _ = check_group(seq, ABOVE, BELOW); ok += a; tot += b; ng += 1
                        seq = []
            print('%-60s %d table-driven groups, %d / %d steps are one of Above/Below[O]' % (fn, ng, ok, tot))
    else:
        for name, fn in (('boot', sys.argv[2]), ('calibration', sys.argv[3])):
            gs = real_groups(D.rows_of(fn)); ok = tot = 0
            print('==', name, len(gs), 'SAR groups')
            for g in gs:
                t = g['table']
                a, b, res = check_group(t, ABOVE, BELOW) if len(t) >= 2 else (0, 0, ())
                ok += a; tot += b
                print('   reg1=%02X reg7=%02X C=%04X  captures %s -> table steps %s  result in {%s}' % (g['reg1'], g['reg7'], g['C'], ' '.join('%02X' % x for x in g['allo']), ' '.join('%02X' % x for x in t), ' '.join('%02X' % x for x in res)))
            print('   %d / %d table-driven steps are one of Above[O] / Below[O]' % (ok, tot))
