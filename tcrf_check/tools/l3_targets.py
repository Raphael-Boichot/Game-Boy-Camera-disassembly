#!/usr/bin/env python3
"""Targets of the L3 BGB pass (README 1.3): every name of disasm/sym_names_jp.csv tagged I, with the watchpoint that would show it at work.

usage: l3_targets.py OUT.csv [--names disasm/sym_names_jp.csv] [--sym pocketcamera_jp.sym] [--tag I]
A label inside a `.code` block of the symbol file gets an execute watchpoint on its first byte (kind x); any other label a read watchpoint on its bytes up to the
next label or the end of its block (kind r).  OUT.csv: bank, addr, size, kind, name (input of bgb_span_read_probe.py --targets)."""
import csv, sys, os, bisect
REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
a = sys.argv[1:]
def opt(n, d):
    if n in a: i = a.index(n); v = a[i + 1]; del a[i:i + 2]; return v
    return d
names = opt('--names', os.path.join(REPO, 'disasm', 'sym_names_jp.csv')); sym = opt('--sym', os.path.join(REPO, 'pocketcamera_jp.sym')); tag = opt('--tag', 'I'); out = a[0]
blocks = {}                                   # bank -> sorted [(start, end, type)]
for l in open(sym):
    p = l.split()
    if len(p) == 2 and p[1].startswith('.'):
        b, ad = p[0].split(':'); t = p[1][1:].split(':')
        blocks.setdefault(int(b, 16), []).append((int(ad, 16), int(ad, 16) + int(t[1], 16), t[0]))
for b in blocks: blocks[b].sort()
N = list(csv.DictReader(open(names, encoding='utf-8')))
labs = {}
for r in N: labs.setdefault(int(r['bank'], 16), []).append(int(r['addr'], 16))
for b in labs: labs[b].sort()
rows = []
for r in N:
    if r['conf'] != tag: continue
    b, ad = int(r['bank'], 16), int(r['addr'], 16)
    L = blocks.get(b, []); i = bisect.bisect_right(L, (ad, 1 << 20, 'z')) - 1
    blk = L[i] if i >= 0 and L[i][0] <= ad < L[i][1] else None
    if blk and blk[2] == 'code': rows.append((b, ad, 1, 'x', r['name'])); continue
    end = blk[1] if blk else (0x4000 if b == 0 else 0x8000)
    j = bisect.bisect_right(labs[b], ad)
    if j < len(labs[b]): end = min(end, labs[b][j])
    rows.append((b, ad, max(1, end - ad), 'r', r['name']))
with open(out, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['bank', 'addr', 'size', 'kind', 'name'])
    for b, ad, n, k, nm in rows: w.writerow(['%02X' % b, '%04X' % ad, n, k, nm])
print(len(rows), 'targets:', sum(1 for x in rows if x[3] == 'x'), 'execute,', sum(1 for x in rows if x[3] == 'r'), 'read ->', out)
