#!/usr/bin/env python3
"""The camera's printer timing against the printer firmware's limits (docs §17.10; owner 2026-11-23: "for the printer timing questions,
look here: github.com/Raphael-Boichot/Game-Boy-Printer-disassembly").

  tools/printer_timing_check.py KITTY.gb [--out roms/hello_kitty/trace/printer_timing_kitty.txt]

The printer firmware (its Printer_protocol.md §3, §9) drops a packet when a gap between two bytes exceeds 5.12 ms (timer TC4, 20 x 2048
cycles of its 8 MHz crystal) and, while it is not printing, clears its job after 13 main-loop ticks of 10.24 ms with no byte (123-133 ms).
This runs print jobs of the Hello Kitty ROM in the core (its printer driver is the Japanese one: every Prn_ routine "same" in
disasm/jp_counterparts_kitty.csv) with the core's printer stand-in (the replies of the real traces) and logs the cycle of every byte the
printer receives (coverage/src/gbcov.c, gb_printer_tlog; 4,194,304 cycles a second). For each job: the longest gap between two bytes of
one packet, and the longest silence between two packets while the printer is not printing (before the PRINT packet and after the job).
The camera's timing is C for the core (the driver's own loop); the printer's busy time is the stand-in's (20 polls), not a real printer's.
"""
import argparse, os, sys
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
sys.path.insert(0, os.path.join(REPO, 'coverage', 'src')); import gbcov as G
ap = argparse.ArgumentParser(); ap.add_argument('kitty'); ap.add_argument('--out', default=os.path.join(REPO, 'roms', 'hello_kitty', 'trace', 'printer_timing_kitty.txt'))
a = ap.parse_args()
HZ = 4194304.0
BIT = dict(A=1, B=2, Select=4, Start=8, Right=0x10, Left=0x20, Up=0x40, Down=0x80)
def core_mask(b): return ((b << 4) | (b >> 4)) & 0xFF        # the core's key byte has the nibbles swapped (tools/kitty_core_paths.py)
def tap(k):
    if k == '-': return [0] * 98
    keys, n = (k.split('*') + [None])[:2]; b = core_mask(sum(BIT[x] for x in keys.split('+')))
    return [b] * int(n) if n else [b] * 8 + [0] * 90
def taps(p): return [x for k in p.split() for x in tap(k)]
ALB = '- - Down A Down Down A'                                  # main menu -> album -> print (tools/kitty_core_paths.py)
JOBS = [('album print, frame 0', ALB + ' A A', 2500), ('album print, frame 3', ALB + ' Right Right Right A A', 2500),
        ('album print, fruit game', ALB + ' Right A Start', 4000)]
G.load_rom(a.kitty); G.reset(bytes(0x20000)); G.run(600); base = bytearray(bytes(G.sram()))
SAVE = bytes(base[:0x100A]) + b'\x99\x99\x99' + bytes(base[0x100D:])
NAME = {1: 'INIT', 2: 'PRINT', 4: 'DATA', 15: 'INQUIRY'}
out = []
def P(s=''): out.append(s); print(s)
P('printer_timing_check: the camera\'s byte and packet timing in the core against the printer firmware\'s limits (docs §17.10)')
P('limits (printer firmware, 8 MHz crystal): 5.12 ms between two bytes of a packet; 123-133 ms of silence while not printing clears the job')
for name, path, free in JOBS:
    G.load_rom(a.kitty); G.reset(SAVE); G.L.gb_printer_model(1); G.L.gb_attach_printer(1); G.L.gb_printer_inject_clear(); G.run(700)
    for k in taps('A A A A B') + taps(path) + [0] * free: G.keys(k); G.run(1)
    log = G.printer_tlog()
    pk = []                                                     # packets: [first index, last index, command]
    for i, (t, st, tx) in enumerate(log):
        if st == 0 and tx == 0x88: pk.append([i, i, None])
        elif pk and st != 0: pk[-1][1] = i
        if pk and st == 2: pk[-1][2] = tx
    pk = [p for p in pk if p[2] is not None]
    intra = max((log[i + 1][0] - log[i][0]) for p in pk for i in range(p[0], p[1])) / HZ * 1000 if pk else 0
    printing = False; worst = (0, '', '')
    for p, q in zip(pk, pk[1:]):
        if p[2] == 2: printing = True
        if p[2] == 1: printing = False
        gap = (log[q[0]][0] - log[p[1]][0]) / HZ * 1000
        if not printing and gap > worst[0]: worst = (gap, NAME.get(p[2], '%02X' % p[2]), NAME.get(q[2], '%02X' % q[2]))
    allg = max(((log[q[0]][0] - log[p[1]][0]) / HZ * 1000, NAME.get(p[2]), NAME.get(q[2])) for p, q in zip(pk, pk[1:]))
    cmds = [p[2] for p in pk]
    P('\n%s: %d bytes, %d packets (INIT %d, DATA %d, PRINT %d, INQUIRY %d)' % (name, len(log), len(pk), cmds.count(1), cmds.count(4), cmds.count(2), cmds.count(15)))
    P('   longest gap between two bytes of a packet: %.3f ms (one byte on the link at 8,192 Hz: %.3f ms)' % (intra, 4096 / HZ * 1000))
    P('   longest silence between two packets while not printing: %.1f ms (%s -> %s)' % worst)
    P('   longest silence between any two packets of the job: %.1f ms (%s -> %s)' % allg)
    if pk:
        i1 = next((k for k, p in enumerate(pk) if p[2] == 2), None)
        if i1:
            d = (log[pk[i1][0]][0] - log[pk[i1 - 1][1]][0]) / HZ * 1000
            P('   from the last packet before PRINT (%s) to PRINT: %.1f ms' % (NAME.get(pk[i1 - 1][2]), d))
os.makedirs(os.path.dirname(a.out), exist_ok=True); open(a.out, 'w').write('\n'.join(out) + '\n'); print('->', os.path.relpath(a.out, REPO))
