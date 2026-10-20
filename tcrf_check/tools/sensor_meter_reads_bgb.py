#!/usr/bin/env python3
"""Check, in BGB, which bytes of the raw frame (RAM bank 0, $A000-$AFFF) the exposure metering Cam_PopcountSampleLoop (0A:4FBD) really reads (README 10-B, 18.3).
A logging read watchpoint on $A000-$AFFF writes PC, DE, ROM bank and RAM bank at every read; the helper at 0A:5091 reads the plane 0 byte at PC 5093 and the plane 1 byte at PC 509E
(address in DE, BGB stops before the instruction runs), so the log gives the address of every read of the metering, with no executor in between.
The log of one MainDispatch (the 168 helper calls between two Sum markers) is compared with the address list that sensor_meter_lib.meter_reads() derives from the ROM bytes.
usage: sensor_meter_reads_bgb.py OUTDIR --sav SAV [--rom ROM]     -> OUTDIR/meter.log, OUTDIR/meter_reads.csv (loop, address, x, y), prints the verdict
       sensor_meter_reads_bgb.py OUTDIR --from-log OUTDIR/meter.log [--rom ROM]     the same analysis of a log kept from an earlier run (the log is about 20 MB: not in the repository)
BGB's sensor picture is fake (README 18.9): the addresses read do not depend on it (the loops have fixed bounds), the values read do."""
import sys, os, csv, collections
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import sensor_bgb_log as S
from sensor_meter_lib import meter_reads, where
a = sys.argv[1:]
def opt(n, d=None):
    if n in a: i = a.index(n); v = a[i + 1]; del a[i:i + 2]; return v
    return d
fromlog = opt('--from-log'); sav = os.path.abspath(opt('--sav')) if not fromlog else None; rom = os.path.abspath(opt('--rom', os.path.join(S.ROOT, 'pocketcamera_jp.gb'))); out = os.path.abspath(a[0]); os.makedirs(out, exist_ok=True)
if fromlog: lines = open(fromlog, errors='replace').read().splitlines()
else:
    orig = S.build_args
    S.build_args = lambda extra_markers=(): (lambda br, wp: (br, wp + ',A000-AFFF//r/RD %ROMBANK% %PC% %DE% %XRAMBANK%'))(*orig(extra_markers))
    keys = [('A', 4, 200), ('A', 4, 200), ('A', 4, 200), ('-', 1, 300)]          # title, two more A presses: the live camera view (sensor_scenarios.py 'live')
    r, lines = S.run(sav, out, 'meter', 0, keys, 400, 30, rom)
rd = [l.split() for l in lines if l.startswith('RD ')]                       # RD rombank pc de xrambank
print('reads of $A000-$AFFF logged: %d; by site (ROM bank:PC): %s' % (len(rd), dict(collections.Counter('%s:%s' % (l[1], l[2]) for l in rd).most_common(8))))
mt = [(l[1], l[2], int(l[3], 16), int(l[4], 16)) for l in rd if l[1].upper() == '0A' and l[2] in ('5093', '509E')]   # (bank, pc, de, rambank)
p0 = [m for m in mt if m[1] == '5093']; p1 = [m for m in mt if m[1] == '509E']
print('metering reads: plane 0 (5093) %d, plane 1 (509E) %d, RAM banks seen %s' % (len(p0), len(p1), sorted(set(m[3] for m in mt))))
exp = meter_reads(open(rom, 'rb').read())
n = len(exp)
if len(p0) < n: raise SystemExit('fewer metering reads than one MainDispatch (%d < %d): the live view was not reached' % (len(p0), n))
ok_all = True; first = None
for k in range(len(p0) // n):                                                # every full MainDispatch in the log
    seq = [m[2] for m in p0[k * n:(k + 1) * n]]; pl1 = [m[2] for m in p1[k * n:(k + 1) * n]]
    same = seq == [ad for _, ad in exp] and pl1 == [ad + 1 for _, ad in exp]
    ok_all &= same
    if first is None: first = seq
print('full MainDispatch passes in the log: %d; every one equals the executor list (same 168 addresses, same order, plane 1 = address + 1): %s' % (len(p0) // n, ok_all))
with open(os.path.join(out, 'meter_reads.csv'), 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['loop', 'address', 'x', 'y', 'plane1_address'])
    for (l, _), ad in zip(exp, first): w.writerow([l, '%04X' % ad, *where(ad), '%04X' % (ad + 1)])
xs = [where(ad)[0] for ad in first]; ys = [where(ad)[1] for ad in first]
print('BGB list: x %d..%d (tile row starts), y %d..%d' % (min(xs), max(xs), min(ys), max(ys)))
l1 = [ad for (l, _), ad in zip(exp, first) if l == 1]; l2 = [ad for (l, _), ad in zip(exp, first) if l == 2]
cx = lambda L: sum(where(ad)[0] + 3.5 for ad in L) / len(L); cy = lambda L: sum(where(ad)[1] for ad in L) / len(L)
print('centroid (x of the tile centre, y of the line): loop 1 x %.2f y %.2f, loop 2 x %.2f y %.2f, whole sum (loop 1 counted twice) x %.2f y %.2f; frame centre x 63.5, y 63.5'
      % (cx(l1), cy(l1), cx(l2), cy(l2), (2 * cx(l1) * 120 + cx(l2) * 48) / 288, (2 * cy(l1) * 120 + cy(l2) * 48) / 288))
print('loop 1: %d reads with the tile centre left of x 63.5, %d right; tile columns %s (the mirror of the range 2..14 about 63.5 is 1..13)' % (sum(where(ad)[0] + 3.5 < 63.5 for ad in l1), sum(where(ad)[0] + 3.5 > 63.5 for ad in l1), sorted(set(where(ad)[0] // 8 for ad in l1))))
print('odd-address reads: %d, of which %d start at byte 15 of a tile (the second byte is then byte 0 of the next tile)' % (sum(ad & 1 for ad in first), sum(1 for ad in first if ad & 1 and (ad - 0xA000) % 16 == 15)))
