#!/usr/bin/env python3
"""Parse the 'Examples of Image Capture Modes' table (section 13) of the Mitsubishi M64283FP datasheet
(a DIFFERENT sensor from the M64282FP of the Game Boy Camera; used only as a cross-check, README 18.8).

Usage:  pdftotext -layout M64283FP.pdf m64283.txt ; python3 -I tools/sensor_m64283_table.py m64283.txt [out.csv]
Columns of the table are the register addresses 000, 001, 010+011 (= C1C0), 100, 101, 110, 111 of M64283FP section 12.3:
 reg4 = SH AZ CL - P3-P0, reg5 = PX PY MV4 OB M3-M0, reg6 = MV3-MV0 X3-X0, reg7 = E3-E0 I V2-V0.
Prints the set of values of reg4/5/6 and the low nibbles (P, M, X)."""
import re, sys, csv
L = open(sys.argv[1], encoding='utf-8', errors='replace').read().split('\n')
i0 = [i for i, l in enumerate(L) if 'Examples of Image Capture Modes' in l][-1]
H = r'([0-9A-F]{2})h'
pat = re.compile(r'\b' + H + r'\s+' + H + r'\s+(?:[0-9A-F]{4}h(?:\s+to\s+[0-9A-F]{4}h)?)\s+' + r'\s+'.join([H] * 4))
rows = []
for l in L[i0:i0 + 60]:
    m = pat.search(l)
    if m:
        rows.append((l[:m.start()].strip() or '(continuation line)',) + m.groups())
w = csv.writer(open(sys.argv[2], 'w', newline='', encoding='utf-8')) if len(sys.argv) > 2 else None
if w: w.writerow(['mode_text_on_line', 'reg0_000', 'reg1_001', 'reg4_100', 'reg5_101', 'reg6_110', 'reg7_111', 'P=reg4&F', 'M=reg5&F', 'X=reg6&F'])
for r in rows:
    p, m_, x = (int(r[i], 16) & 15 for i in (3, 4, 5))
    if w: w.writerow(list(r) + ['%02X' % p, '%02X' % m_, '%02X' % x])
print(len(rows), 'rows')
print('reg6 (X register) values:', sorted({r[5] for r in rows}), '  X = reg6&F:', sorted({int(r[5], 16) & 15 for r in rows}))
print('P = reg4&F:', sorted({int(r[3], 16) & 15 for r in rows}), '  M = reg5&F:', sorted({int(r[4], 16) & 15 for r in rows}))
print('reg4:', sorted({r[3] for r in rows}), ' reg5:', sorted({r[4] for r in rows}), ' reg7:', sorted({r[6] for r in rows}))
