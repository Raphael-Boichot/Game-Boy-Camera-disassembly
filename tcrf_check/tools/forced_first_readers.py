#!/usr/bin/env python3
"""Who is the first reader of the bytes that only forced runs read? (README 16.24)

usage: forced_first_readers.py [COV.npz] [OUT.csv]
  COV.npz  default coverage/v8/merged_v8/cov.npz: `dr` (ROM byte read in any run), `odr` (in an organic run: no RAM poke, no mode poke), `ex` (executed in any
           run; such a byte is code, not a data read, so "forced only" = read in some run, in no organic run, never executed),
           `rdr` (the first instruction that read or fetched the byte: 0x80000000 | bank << 16 | pc; the merge keeps the first one, so this is
           "a reader", never "the only reader")
  OUT.csv  default tcrf_check/assets/unidentified/forced_first_readers.csv: one row per span of really_unused.csv that has bytes read in forced
           runs only (columns: span, bytes, bytes read in any run / organically / only in forced runs, how many of the forced-only bytes have each
           of the three most frequent first readers, as bank:pc and the routine that holds the instruction), and a last row `*` for the whole ROM.
The routine of an address is the nearest label at or before it in the bank (disasm/sym_names_jp.csv)."""
import sys, os, csv, bisect, collections
import numpy as np
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
cov = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, 'coverage/v8/merged_v8/cov.npz')
out = sys.argv[2] if len(sys.argv) > 2 else os.path.join(ROOT, 'tcrf_check/assets/unidentified/forced_first_readers.csv')
z = np.load(cov)
dr = z['dr'] != 0; odr = z['odr'] != 0; ex = z['ex'] != 0; rdr = z['rdr']
forced = dr & ~odr & ~ex
labels = collections.defaultdict(list)
for r in csv.DictReader(open(os.path.join(ROOT, 'disasm/sym_names_jp.csv'), encoding='utf-8')):
    labels[int(r['bank'], 16)].append((int(r['addr'], 16), r['name']))
for b in labels: labels[b].sort()
def routine(bank, pc):
    L = labels.get(bank, [])
    i = bisect.bisect_right([a for a, _ in L], pc) - 1
    return L[i][1] if i >= 0 else '?'
def readers(sel):
    c = collections.Counter((int(x >> 16) & 0xff, int(x) & 0xffff) for x in rdr[sel].tolist() if x)
    return c.most_common(3)
HDR = ['bank', 'addr', 'bytes', 'name', 'tier', 'read_any_run', 'read_organic', 'read_forced_only',
       'reader1', 'reader1_routine', 'reader1_bytes', 'reader2', 'reader2_routine', 'reader2_bytes', 'reader3', 'reader3_routine', 'reader3_bytes']
rows = []
def row(bank, addr, n, name, tier, sl):
    f = forced[sl]; k = int(f.sum())
    r = [bank, addr, n, name, tier, int(dr[sl].sum()), int(odr[sl].sum()), k]
    sel = np.zeros(len(forced), bool); sel[sl] = f
    top = readers(sel)
    for i in range(3):
        if i < len(top):
            (b, pc), v = top[i]; r += ['%02X:%04X' % (b, pc), routine(b, pc), v]
        else: r += ['', '', 0]
    return r
for s in csv.DictReader(open(os.path.join(ROOT, 'tcrf_check/assets/unidentified/really_unused.csv'), encoding='utf-8')):
    b = int(s['bank'], 16); a = int(s['addr'], 16); n = int(s['bytes']); off = b * 0x4000 + a - 0x4000
    r = row(s['bank'], s['addr'], n, s['name'], s['tier'], slice(off, off + n))
    if r[7]: rows.append(r)
rows.append(row('*', '', len(forced), 'whole ROM', '', slice(0, len(forced))))
with open(out, 'w', newline='', encoding='utf-8') as fh:
    w = csv.writer(fh, lineterminator='\n'); w.writerow(HDR); w.writerows(rows)
print('%d rows -> %s' % (len(rows), out))
for r in rows[-1:]: print(r)
