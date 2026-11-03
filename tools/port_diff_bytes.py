#!/usr/bin/env python3
"""Per byte of another build: is it the same as in the Japanese ROM? For the layout picture of that build (roms/us_eu/us_rom_layout_map.png).

  tools/port_diff_bytes.py JP.gb OTHER.gb MAP.npy CODE_MAP.csv OTHER_TRACE.json OUT.npz [--rommap OUT_rom_map.csv]

diff[o] for every byte o of the other ROM:
  0  the same: a traced instruction paired with a JP instruction as identical or differing only by its 16-bit address operand
     (tools/port_code_map.py), or a data byte that a JP byte maps to (tools/port_map.py) with the same value or as an address-operand wildcard
  1  code new or changed in this build: a traced instruction with no JP pair, or paired with another 8-bit operand
  2  data that differs: a non-code byte that no JP byte maps to, or maps to with another value
--rommap writes a byte-class map in the format of coverage/v8/report_v8/rom_map.csv (bank, start, length, class) built from the trace
alone: C = traced instruction bytes, T = rst $18 / jump-table words of the trace, R = every other byte. It says what the static trace
proves, not what an emulator ran (no run of this build exists).
"""
import sys, csv, json, argparse
import numpy as np
ap = argparse.ArgumentParser()
for x in ('jp', 'other', 'map', 'codemap', 'trace', 'out'): ap.add_argument(x)
ap.add_argument('--rommap', default=None)
a = ap.parse_args()
JP = np.frombuffer(open(a.jp, 'rb').read(), np.uint8); OT = np.frombuffer(open(a.other, 'rb').read(), np.uint8); M = np.load(a.map)
N = len(OT)
def off(b, ad): return ad if ad < 0x4000 else b * 0x4000 + ad - 0x4000
T = json.load(open(a.trace))['code']
code = np.zeros(N, bool); table = np.zeros(N, bool); starts = {}
for k, n in T.items():
    b, ad = (int(x, 16) for x in k.split(':')); o = off(b, ad)
    if n > 0: code[o:o + n] = True; starts[o] = n
    else: table[o] = True
pair = {}
for r in csv.DictReader(open(a.codemap)):
    b = int(r['bank'], 16); pair[off(b, int(r['other'], 16))] = r['kind']
diff = np.full(N, 2, np.uint8)
# data: same where a JP byte maps here with the same value (or as a wildcard of an address operand: those differ by design)
W16 = {0x01, 0x11, 0x21, 0x31, 0x08, 0xC2, 0xC3, 0xCA, 0xD2, 0xDA, 0xC4, 0xCC, 0xCD, 0xD4, 0xDC, 0xEA, 0xFA}
ok = M >= 0; src = np.nonzero(ok)[0]; dst = M[ok]
eq = JP[src] == OT[dst]
diff[dst[eq]] = 0
# code: per instruction of this build
for o, n in starts.items():
    k = pair.get(o)
    diff[o:o + n] = 0 if k in ('same', 'operand') else 1
np.savez_compressed(a.out, diff=diff)
print('bytes the same as JP %d, code new or changed %d, data that differs %d' % ((diff == 0).sum(), (diff == 1).sum(), (diff == 2).sum()))
if a.rommap:
    cls = np.full(N, ord('R'), np.uint8); cls[table] = ord('T'); cls[code] = ord('C')
    with open(a.rommap, 'w', newline='') as f:
        w = csv.writer(f, lineterminator='\n'); w.writerow(['bank', 'start', 'length', 'class'])
        i = 0
        while i < N:
            j = i
            while j < N and cls[j] == cls[i] and (j >> 14) == (i >> 14): j += 1
            b = i >> 14; ad = i if b == 0 else (i & 0x3FFF) + 0x4000
            w.writerow(['%02x' % b, '%04x' % ad, j - i, chr(cls[i])]); i = j
