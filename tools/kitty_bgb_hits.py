#!/usr/bin/env python3
"""Turn BGB logging-breakpoint hits on never-run block heads into an `exec` array for the Kitty pipeline (L2 observed in BGB).

  tools/kitty_bgb_hits.py ROM TRACE.json HEADS.json OUT.npz HITS.csv [HITS.csv ...]

HEADS.json: the list of block heads given to BGB (BB:AAAA), written with the -wp lists.

HITS.csv: name,hits files of tools/kitty_bgb_link.py, where a name H<bank><addr> is a breakpoint on the first instruction of a
block of traced code that no core run executed (CONTROL is the control breakpoint on the VBlank vector and must be hit). Each
head hit marks its block as executed: the instructions from the head to the end of the run of contiguous traced instructions
(stopped at the next block head of HEADS.json and after an unconditional ret / reti / jp / jr / jp hl). A block is credited when its
first instruction ran; branches inside it are not checked one by one (the block is the unit of this evidence). The array has
the format of tools/kitty_coverage.py (exec 1 = opcode, 2 = operand byte; dread and reader empty).
"""
import sys, json, csv, numpy as np
rom, trace, headsf, out = sys.argv[1:5]; hits = sys.argv[5:]
R = open(rom, 'rb').read()
T = json.load(open(trace)); N = len(open(rom, 'rb').read())
code = {}
for k, n in T['code'].items():
    b, a = int(k[:2], 16), int(k[3:], 16); code[(0 if a < 0x4000 else b, a)] = n
def off(b, a): return a if a < 0x4000 else b * 0x4000 + a - 0x4000
seen = set(); ctrl = 0
for f in hits:
    for r in csv.DictReader(open(f)):
        if r['name'] == 'CONTROL': ctrl += int(r['hits'])
        elif r['name'].startswith('H'): seen.add((int(r['name'][1:3], 16), int(r['name'][3:7], 16)))
heads = {(0 if int(x[3:], 16) < 0x4000 else int(x[:2], 16), int(x[3:], 16)) for x in json.load(open(headsf))}
ex = np.zeros(N, np.uint8)
for b, a in sorted(seen):
    b = 0 if a < 0x4000 else b; cur = a; first = True
    while (b, cur) in code and (first or (b, cur) not in heads):
        n = code[(b, cur)]; o = off(b, cur); ex[o] = 1; ex[o + 1:o + n] = 2
        cur += n; first = False
        if R[o] in (0xC9, 0xD9, 0xC3, 0x18, 0xE9): break
        if cur in (0x4000, 0x8000): break
np.savez_compressed(out, exec=ex, dread=np.zeros(N, np.uint8), reader=np.zeros(N, np.uint32))
print('kitty_bgb_hits: %d of %d block heads hit (control hits %d), %d bytes credited' % (len(seen & heads), len(heads), ctrl, int((ex > 0).sum())))
if ctrl == 0: raise SystemExit('the control breakpoint was never hit: the -wp list did not work')
