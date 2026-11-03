#!/usr/bin/env python3
"""Log every read and write of $A000 (the MAC-GBD control byte) in BGB during a normal boot and count the values (README section 18.2, "$A000 bits").
The ROM writes $D594 | 1 = $03 at each capture start and polls bit 0 only; this shows what BGB's MAC-GBD returns: $03 while busy, $02 when idle (bit 1 stays as written).
usage: sensor_a000_reads.py OUTDIR --sav SAV [--rom ROM]       -> OUTDIR/boot.log, prints the counts (also in assets/sensor/a000_reads_boot.txt)"""
import sys, os, collections
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import sensor_bgb_log as S
a = sys.argv[1:]
def opt(n, d=None):
    if n in a: i = a.index(n); v = a[i + 1]; del a[i:i + 2]; return v
    return d
sav = os.path.abspath(opt('--sav')); rom = os.path.abspath(opt('--rom', os.path.join(S.ROOT, 'pocketcamera_jp.gb'))); out = os.path.abspath(a[0]); os.makedirs(out, exist_ok=True)
orig = S.build_args
S.build_args = lambda extra_markers=(): (lambda br, wp: (br, wp + ',A000//r/RD0 %XRAMBANK% %VALUE% %ROMBANK% %PC% %TOTALCLKS%'))(*orig(extra_markers))
r, lines = S.run(sav, out, 'boot', 0, [], 300, 30, rom)
rd = [l.split() for l in lines if l.startswith('RD0')]; wr = [l.split() for l in lines if l.startswith('CAM0')]
cam = lambda l: int(l[1], 16) >= 0x10                       # the camera registers are only mapped when the RAM bank is >= $10
print('reads of $A000 in a normal boot (RAM bank >= $10): %s' % dict(collections.Counter(l[2] for l in rd if cam(l))))
print('writes of $A000: %s' % dict(collections.Counter(l[2] for l in wr)))
print('read sites (ROM bank:PC): %s' % sorted(set('%s:%s' % (l[3], l[4]) for l in rd if cam(l))))
