#!/usr/bin/env python3
"""The auto-exposure metering of the live view (README sections 10 and 18.6): the exact read addresses of Cam_PopcountSampleLoop (0A:4FBD-5090), taken from the ROM
bytes with a tiny executor that knows only the 14 opcodes the routine uses (so nothing is transcribed by hand), and the sum it produces.
Loop 1 = 120 reads, then the running sum is doubled (sla c / rl b at 0A:5036), loop 2 = 48 reads; one read = 2 bytes = plane 0 then plane 1 of one 8-pixel tile row,
added as popcount(plane 0) + 2 * popcount(plane 1) (helper 0A:5091, table 0A:7300).  60 of the 120 reads of loop 1 start at an odd address.
usage: sensor_meter_geom.py ROM.gb                           prints the geometry
       sensor_meter_geom.py ROM.gb FRAME.bin [EVENTS.csv]    the sum of a 4096-byte frame buffer ($A000-$AFFF of RAM bank 0); with the BGB events of the same run
                                                             (sensor_bgb_log.py, marker Sum at 0A:4011) also the last sum the ROM itself computed"""
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from sensor_meter_lib import meter_reads, where          # the executor (14 opcodes) lives there, shared with sensor_pixel_map.py and sensor_meter_reads_bgb.py
rom = open(sys.argv[1], 'rb').read()
log = meter_reads(rom)
for L in (1, 2):
    pts = [(ad, where(ad)) for lp, ad in log if lp == L]
    xs = [p[1][0] for p in pts]; ys = [p[1][1] for p in pts]
    odd = sum(ad & 1 for ad, _ in pts)
    print('loop %d: %3d reads of 2 bytes (8 pixels each), %d at an odd address; tile x %d..%d, y %d..%d%s' % (L, len(pts), odd, min(xs), max(xs) + 7, min(ys), max(ys), '   (sum doubled afterwards)' if L == 1 else ''))
if len(sys.argv) > 2:
    fr = open(sys.argv[2], 'rb').read(); pop = lambda v: bin(v).count('1')
    s = [0, 0]
    for lp, ad in log: s[lp - 1] += pop(fr[ad - 0xA000]) + 2 * pop(fr[ad - 0xA000 + 1])
    tot = 2 * s[0] + s[1]
    print('sum = 2 x %d + %d = %d ($%04X)' % (s[0], s[1], tot, tot))
    if len(sys.argv) > 3:
        import csv
        sums = [int(dict(p.split('=') for p in e['extra'].split() if '=' in p)['bc'], 16) for e in csv.DictReader(open(sys.argv[3])) if e['kind'] == 'M' and e['what'] == 'Sum']
        print('last sum computed by the ROM in BGB: %d ($%04X) of %d dispatches -> %s' % (sums[-1], sums[-1], len(sums), 'equal' if sums[-1] == tot else 'DIFFERENT'))
