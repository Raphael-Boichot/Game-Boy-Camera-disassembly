#!/usr/bin/env python3
"""Per-bank table of ROM bytes never read as data / never executed, split into padding (runs >=16 of 00 or FF) and content, with the ranges.
usage: unread_ranges.py ROM COV.npz OUT.csv [OUT.md]"""
import sys, numpy as np, csv
rom = np.frombuffer(open(sys.argv[1],'rb').read(), dtype=np.uint8); z = np.load(sys.argv[2])
dr = z['dr'] != 0; odr = z['odr'] != 0; ex = z['ex'] != 0
n = len(rom); pad = np.zeros(n, bool)
for v in (0x00, 0xFF):
    m = rom == v; i = 0
    idx = np.flatnonzero(np.diff(np.concatenate(([0], m.astype(np.int8), [0]))))
    for a, b in zip(idx[0::2], idx[1::2]):
        if b - a >= 16: pad[a:b] = True
touched = dr | ex
rows = []; md = []
def addr(o):
    b = o // 0x4000; return '%02X:%04X' % (b, (o % 0x4000) + (0x4000 if b else 0))
def runs(mask, gap=0):
    idx = np.flatnonzero(mask); out = []
    if not len(idx): return out
    s = p = idx[0]
    for i in idx[1:]:
        if i > p + 1 + gap: out.append((s, p + 1)); s = i
        p = i
    out.append((s, p + 1)); return out
tot = dict(content=0, read=0, orgread=0, unread=0, pad=0)
for b in range(64):
    sl = slice(b * 0x4000, (b + 1) * 0x4000)
    c = ~pad[sl]; r = touched[sl] & c; orr = (odr[sl] | ex[sl] & odr[sl]) & c
    un = c & ~touched[sl]
    tot['content'] += c.sum(); tot['read'] += r.sum(); tot['orgread'] += (odr[sl] & c).sum(); tot['unread'] += un.sum(); tot['pad'] += pad[sl].sum()
    rr = [(s + b * 0x4000, e + b * 0x4000) for s, e in runs(un, gap=7) if e - s >= 8]
    rows.append([ '%02X' % b, int(c.sum()), int(r.sum()), int((odr[sl] & c).sum()), int(un.sum()), int(pad[sl].sum()), len(rr)])
    for s, e in rr:
        rows.append(['  range', addr(s), addr(e - 1), e - s, '', '', ''])
with open(sys.argv[3], 'w', newline='\n') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['bank', 'content_bytes', 'touched', 'organic_read', 'never_touched_content', 'padding', 'ranges']); w.writerows(rows)
print(tot)
