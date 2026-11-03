#!/usr/bin/env python3
"""Decode the three bus-analyser recordings of the M64282FP register loads (Excel files of the owner) and group them like the ROM does.

The workbooks (Sheet1) hold one row per capture; columns M..BX (index 12..75) are the 64 raw register bits in the order the sensor receives them:
register 1 (001), 2 (010), 3 (011), 4 (100 = P), 5 (101 = M), 6 (110 = X), 7 (111), 0 (000).  Trailing all-zero rows are padding.
usage: sensor_decode.py BOOT.xlsx CALIB.xlsx LIVE.xlsx OUTDIR     -> OUTDIR/{boot,calibration,live}_rows.csv, *_groups.csv  and a text report on stdout
Group rules (README section 18):  a successive-approximation (SAR) group starts at the row with reg0 = $BF (O = +1 V, Z = 10) after a change of reg1 / C / reg7,
and lasts until the next such row;  the factory threshold loops (ThresholdConverge) are runs of identical rows."""
import sys, os, csv


def load_rows(fn, sheet='Sheet1'):
    import openpyxl
    ws = openpyxl.load_workbook(fn, data_only=True)[sheet]
    return [r for r in ws.iter_rows(min_row=3, values_only=True) if not all(v is None for v in r)]


def regs(r):
    """-> dict register number -> byte (0..7), from the raw bit columns"""
    b = [(0 if v is None else int(v)) for v in r[12:76]]
    def byte(i):
        v = 0
        for k in range(8): v = v * 2 + b[i * 8 + k]
        return v
    return {1: byte(0), 2: byte(1), 3: byte(2), 4: byte(3), 5: byte(4), 6: byte(5), 7: byte(6), 0: byte(7)}


def rows_of(fn):
    out = []
    for r in load_rows(fn):
        g = regs(r)
        out.append(dict(reg0=g[0], reg1=g[1], C=(g[2] << 8) | g[3], P=g[4], M=g[5], X=g[6], reg7=g[7]))
    while out and all(v == 0 for v in out[-1].values()): out.pop()          # padding
    return out


def decode(d):
    """datasheet names of one row"""
    r0, r1, r7 = d['reg0'], d['reg1'], d['reg7']
    o = r0 & 0x3F
    return dict(Z=r0 >> 6, O=o, Ovolt=((o - 0x20) if o & 0x20 else -o) * 0.032, N=r1 >> 7, VH=(r1 >> 5) & 3, G=r1 & 0x1F, E=r7 >> 4, I=(r7 >> 3) & 1, V=r7 & 7, C_ms=d['C'] * 0.016)


def mode_name(d):
    n, vh = d['reg1'] >> 7, (d['reg1'] >> 5) & 3
    return {(0, 0): 'positive (no edge operation)', (0, 1): 'H-edge enhancement', (0, 2): 'V-edge (N=0)', (0, 3): '2-D (N=0)', (1, 0): 'N=1,VH=0', (1, 1): 'N=1,VH=1', (1, 2): 'V-edge enhancement', (1, 3): '2-D edge enhancement'}[(n, vh)]


def sar_groups(rows):
    """split into SAR groups: a group starts at reg0 = $BF when the previous row is not part of a V-stepping run of the same group"""
    groups, cur = [], None
    for i, d in enumerate(rows):
        start = d['reg0'] == 0xBF and (cur is None or d['reg1'] != cur[-1]['reg1'] or (cur[-1]['reg0'] not in (0xBF, 0x9F) and True))
        if start:
            if cur: groups.append(cur)
            cur = [dict(d, idx=i)]
        elif cur is not None: cur.append(dict(d, idx=i))
    if cur: groups.append(cur)
    return groups


def runs(rows):
    out, i = [], 0
    while i < len(rows):
        j = i
        while j + 1 < len(rows) and all(rows[j + 1][k] == rows[i][k] for k in ('reg0', 'reg1', 'C', 'reg7', 'P', 'M', 'X')): j += 1
        out.append((i, j - i + 1, rows[i])); i = j + 1
    return out


def fmt(d): return 'reg1=%02X reg7=%02X C=%04X reg0=%02X' % (d['reg1'], d['reg7'], d['C'], d['reg0'])


if __name__ == '__main__':
    boot, calib, live, out = sys.argv[1:5]; os.makedirs(out, exist_ok=True)
    for name, fn in (('boot', boot), ('calibration', calib), ('live', live)):
        rows = rows_of(fn)
        with open(os.path.join(out, name + '_rows.csv'), 'w', newline='') as f:
            w = csv.writer(f); w.writerow(['idx', 'reg0', 'reg1', 'C1', 'C0', 'P', 'M', 'X', 'reg7', 'Z', 'O', 'O_volt', 'N', 'VH', 'G', 'E', 'I', 'V', 'C_ms', 'mode'])
            for i, d in enumerate(rows):
                x = decode(d); w.writerow([i, '%02X' % d['reg0'], '%02X' % d['reg1'], '%02X' % (d['C'] >> 8), '%02X' % (d['C'] & 255), '%02X' % d['P'], '%02X' % d['M'], '%02X' % d['X'], '%02X' % d['reg7'],
                                           x['Z'], x['O'], '%.3f' % x['Ovolt'], x['N'], x['VH'], x['G'], x['E'], x['I'], x['V'], '%.3f' % x['C_ms'], mode_name(d)])
        print('==', name, len(rows), 'rows')
        if name == 'live':
            for i, n, d in runs(rows)[:0]: pass
        else:
            for i, n, d in runs(rows): print('  rows %3d x%-3d %s  P/M/X=%02X/%02X/%02X' % (i, n, fmt(d), d['P'], d['M'], d['X']))
