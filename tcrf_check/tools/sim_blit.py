#!/usr/bin/env python3
"""Run the effect blit stubs of bank 6 (06:73F7-7477) in the minimal SM83 simulator sm83sim.py and report which of the six one-byte carry steps 06:7529, 758A, 7645, 76B2, 7776, 77E3 execute (README 16.21).
usage: sim_blit.py [ROM]      (ROM defaults to ./pocketcamera_jp.gb, the Japanese Rev A; no WRAM state is needed: the stubs are entered at their first byte with a sentinel return address)
The mask bytes $DA40-$DA5F that gate the blits (06:7527, 7588, 7643, 76B0, 7774, 77E1) are filled with $FF, $55, $01, $A5 and with the real-looking masks; the result lists the gates that ran and the carry steps that ran (none)."""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from sm83sim import Sim
rom = open(sys.argv[1] if len(sys.argv) > 1 else 'pocketcamera_jp.gb', 'rb').read()
EDGE = [0x7529, 0x758A, 0x7645, 0x76B2, 0x7776, 0x77E3]; GATE = [0x7527, 0x7588, 0x7643, 0x76B0, 0x7774, 0x77E1]
stubs = {9: 0x73F7, 10: 0x73FF, 11: 0x7407, 12: 0x740F, 13: 0x7417, 14: 0x741F, 15: 0x7427, 16: 0x742F, 17: 0x7437, 18: 0x7447, 19: 0x7457, 20: 0x745F, 21: 0x7467, 22: 0x746F, 23: 0x7477}
def run(fill):
    allex = set(); hit = set()
    for k, e in sorted(stubs.items()):
        s = Sim(rom, 6)
        for i in range(0xDA40, 0xDA60): s.m[i] = fill(i)
        s.sp = 0xDFF0; s.m[0xDFF0] = 0xFE; s.m[0xDFF1] = 0xFF; s.pc = e
        while s.steps < 3000000:
            r = s.step()
            if s.pc == 0xFFFE or r in ('halt', 'stop'): break
        allex |= s.ex
        for a in EDGE:
            if (6, a) in s.ex: hit.add((k, hex(a)))
    return allex, hit
for name, fill in (('$FF', lambda i: 0xFF), ('$55', lambda i: 0x55), ('$01', lambda i: 0x01), ('$A5', lambda i: 0xA5), ('0F F0 33 CC', lambda i: (0x0F, 0xF0, 0x33, 0xCC)[(i - 0xDA40) % 4]), ('01 02 04 08', lambda i: (1, 2, 4, 8)[(i - 0xDA40) % 4])):
    allex, hit = run(fill)
    print('masks', name, 'gates run:', [hex(a) for a in GATE if (6, a) in allex], 'carry steps run:', sorted(hit))
