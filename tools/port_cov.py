#!/usr/bin/env python3
"""Carry the Japanese core's coverage arrays (coverage/results/merged_state/cov.npz) to another build, for tools/rom_operands.py.

  tools/port_cov.py MAP.npy CODE_MAP.csv OUT.npz [--cov coverage/results/merged_state/cov.npz]

Only the three arrays rom_operands.py reads are written: `ex` (byte executed) and `dr` (byte read as data), moved through the byte
map (tools/port_map.py), and `rdr` (the instruction that read the byte: 0x80000000 | bank << 16 | pc), whose byte position goes
through the byte map and whose reading instruction goes through the instruction map (tools/port_code_map.py); a read by an
instruction that does not pair is dropped. These are the Japanese runs seen through the maps, NOT runs of the other build: they
let rom_operands.py decide the bank of a pointer and find the pointers inside data records the same way as for the Japanese
tree; a decision that rests on them is as good as the pairing of the code that made the read.
"""
import sys, csv, argparse
import numpy as np
ap = argparse.ArgumentParser(); ap.add_argument('map'); ap.add_argument('codemap'); ap.add_argument('out')
ap.add_argument('--cov', default='coverage/results/merged_state/cov.npz')
a = ap.parse_args()
M = np.load(a.map); z = np.load(a.cov)
CM = {}
for r in csv.DictReader(open(a.codemap)):
    b = int(r['bank'], 16); CM[(b, int(r['jp'], 16))] = int(r['other'], 16)
ok = M >= 0; src = np.nonzero(ok)[0]; dst = M[ok]
ex = np.zeros(0x100000, np.uint8); dr = np.zeros(0x100000, np.uint8); rdr = np.zeros(0x100000, np.uint32)
ex[dst] = z['ex'][src]; dr[dst] = z['dr'][src]
r0 = z['rdr']; nz = np.nonzero(r0[src])[0]; kept = dropped = 0
for i in nz:
    v = int(r0[src[i]]); b = (v >> 16) & 0xFF; pc = v & 0xFFFF
    t = CM.get((0 if pc < 0x4000 else b, pc))
    if t is None: dropped += 1; continue
    rdr[dst[i]] = 0x80000000 | (b << 16) | t; kept += 1
np.savez_compressed(a.out, ex=ex, dr=dr, rdr=rdr)
print('ported coverage: ex %d bytes, dr %d bytes, rdr %d reads kept, %d dropped (reader not paired) -> %s' % (int((ex > 0).sum()), int((dr > 0).sum()), kept, dropped, a.out))
