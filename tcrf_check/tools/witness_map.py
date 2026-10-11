#!/usr/bin/env python3
"""Code that the v8 coverage run never executed (class N) but a later targeted run did: writes assets/witness_jp.csv.
usage: witness_map.py OUT.csv [--map coverage/results/report_v8/rom_map.csv] [--rom pocketcamera_jp.gb]
Witnesses (all outside the v8 merge):
  sgb      BGB with SystemMode=2 (Super Game Boy): the 50 block heads of the SGB sender 00:1D38-1EA0 (tcrf_check/assets/bgb_retrace/trace_report.json, "sgb_only_heads"; README 17.7)
  apu      BGB, music-editor corpus: the 6 heads my core never executed because it does not emulate NR52 / NR12 ("contradictions"; README 17.7)
  hotspot  my core, tcrf_check/tools/hotspot_effects.py: hot spot 0 of the displayed photo armed by a WRAM poke of the mirror $D643-$D65C, then a real A press, for the 16 effect values;
           the bytes executed beyond the replay are in tcrf_check/assets/hotspot_effects/exec_ranges.csv (README 13.4 point 5, 16.8)
A BGB head hit means the whole block ran (blocks.py: straight line up to the next head or terminator). Only bytes of class N are written; the printer runs of 17.1-17.6
(tcrf_check/assets/bgb_retrace/printer_heads) hit none."""
import sys, os, csv, json
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(os.path.dirname(HERE)); sys.path.insert(0, HERE)
import blocks as B
a = sys.argv[1:]
def opt(n, d):
    if n in a: i = a.index(n); v = a[i + 1]; del a[i:i + 2]; return v
    return d
MAP = opt('--map', os.path.join(REPO, 'coverage', 'results', 'report_v8', 'rom_map.csv')); ROM = opt('--rom', 'pocketcamera_jp.gb'); OUT = a[0]
rom = open(ROM, 'rb').read(); trace = json.load(open(os.path.join(REPO, 'wram', 'trace_jp_v3.json')))
heads, members, code = B.blocks(rom, trace)
N = 1 << 20
def flat(b, ad): return ad if (b == 0 and ad < 0x4000) else b * 0x4000 + ad - 0x4000
cls = np.zeros(N, np.uint8)
for r in csv.DictReader(open(MAP)):
    cls[flat(int(r['bank'], 16), int(r['start'], 16)):][:int(r['length'])] = ord(r['class'])
isN = cls == ord('N')
rep = json.load(open(os.path.join(REPO, 'tcrf_check', 'assets', 'bgb_retrace', 'trace_report.json')))
def from_heads(hs):
    m = np.zeros(N, bool)
    for k in hs:
        b, ad = k.split(':'); key = (int(b, 16), int(ad, 16))
        assert key in members, k
        for bb, aa, ln in members[key]: m[flat(bb, aa):flat(bb, aa) + ln] = True
    return m
W = [('sgb', 'BGB SystemMode=2 (Super Game Boy): block heads of the SGB sender', 'C', from_heads(rep['sgb_only_heads']['heads'])),
     ('apu', 'BGB, music-editor corpus: branch on NR52 bit 0 / NR12 that my core cannot take', 'C', from_heads(list(rep['contradictions'])))]
hm = np.zeros(N, bool)
for r in csv.DictReader(open(os.path.join(REPO, 'tcrf_check', 'assets', 'hotspot_effects', 'exec_ranges.csv'))):
    o1 = flat(int(r['bank'], 16), int(r['start'], 16)); o2 = flat(int(r['bank'], 16), int(r['end'], 16)); hm[o1:o2 + 1] = True
W.append(('hotspot', 'my core, hot spot armed by a WRAM poke + real A press, effect values 0-15', 'C', hm))
rows = []; seen = np.zeros(N, bool)
for name, desc, ev, m in W:
    m = m & isN & ~seen; seen |= m
    idx = np.flatnonzero(m); runs = []
    for o in idx:
        if runs and runs[-1][1] == o: runs[-1][1] = o + 1
        else: runs.append([o, o + 1])
    for s, e in runs:
        for lo, hi in ((s, e),):
            b = lo >> 14 if lo >= 0x4000 else 0
            while lo < hi:
                top = min(hi, (b + 1) * 0x4000) if b else min(hi, 0x4000)
                ad = lo if b == 0 else 0x4000 + (lo & 0x3FFF)
                rows.append(['%02X' % b, '%04X' % ad, '%04X' % (ad + top - lo - 1), top - lo, name, ev, desc]); lo = top; b += 1 if lo >= 0x4000 else 0
    print('%-8s %5d bytes of class N  (%s)' % (name, int(m.sum()), desc))
with open(OUT, 'w', newline='') as fh:
    w = csv.writer(fh, lineterminator='\n'); w.writerow(['bank', 'start', 'end', 'bytes', 'witness', 'evidence', 'description']); w.writerows(rows)
print('class N bytes in the v8 map: %d, with a witness: %d, left: %d; %d ranges -> %s' % (int(isN.sum()), int(seen.sum()), int(isN.sum() - seen.sum()), len(rows), OUT))
