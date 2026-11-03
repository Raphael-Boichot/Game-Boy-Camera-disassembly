#!/usr/bin/env python3
"""Hand-work queue of a ported build: what the Japanese tables could not give it.

  tools/port_queue.py OTHER.gb OTHER_TRACE.json CODE_MAP.csv PORT_REPORT.csv OTHER.sym OUT.csv

Rows (kind, bank, start, end, label_before, detail):
  new_code      a run of traced instructions of this build that pairs with no JP instruction (new or rewritten code)
  lost_name     a JP name that could not be carried (routine start not paired, byte deleted, inside an instruction)
  name_differs  a carried name whose routine or bytes differ from the JP ones (tagged I)
  default_data  a `.data` block of the .sym that no type row covers (16 bytes per row, untyped)
"""
import sys, csv, json, re, bisect, collections
OT = open(sys.argv[1], 'rb').read()
def off(b, a): return a if a < 0x4000 else b * 0x4000 + a - 0x4000
U = {}
for k, n in json.load(open(sys.argv[2]))['code'].items():
    b, a = (int(x, 16) for x in k.split(':'))
    if n > 0: U[(0 if a < 0x4000 else b, a)] = n
paired = set()
for r in csv.DictReader(open(sys.argv[3])): paired.add((int(r['bank'], 16), int(r['other'], 16)))
labels = collections.defaultdict(list); blocks = []
for l in open(sys.argv[5]):
    m = re.match(r'([0-9a-f]{2}):([0-9a-f]{4}) (\S+)', l)
    if not m: continue
    b, a, n = int(m[1], 16), int(m[2], 16), m[3]
    if n.startswith('.'): blocks.append((b, a, n))
    else: labels[b].append((a, n))
for b in labels: labels[b].sort()
def before(b, a):
    L = labels[b]; i = bisect.bisect_right(L, (a, '￿')) - 1
    return '%s+$%X' % (L[i][1], a - L[i][0]) if i >= 0 else ''
rows = []
run = None
for (b, a) in sorted(U):
    if (b, a) in paired: continue
    if run and run[0] == b and run[2] == a: run[2] = a + U[(b, a)]; run[3] += 1
    else:
        if run: rows.append(['new_code', '%02x' % run[0], '%04x' % run[1], '%04x' % run[2], before(run[0], run[1]), '%d instructions' % run[3]])
        run = [b, a, a + U[(b, a)], 1]
if run: rows.append(['new_code', '%02x' % run[0], '%04x' % run[1], '%04x' % run[2], before(run[0], run[1]), '%d instructions' % run[3]])
for r in csv.DictReader(open(sys.argv[4], encoding='utf-8')):
    if r['fate'] == 'lost': rows.append(['lost_name', r['jp_bank'], r['jp_addr'], '', 'JP ' + r['jp_name'], r['why']])
    elif r['why']:
        b, a = r['new_loc'].split(':'); rows.append(['name_differs', b, a, '', r['new_name'], r['why']])
for b, a, n in blocks:
    m = re.match(r'\.data:([0-9a-f]+)$', n)
    if m: rows.append(['default_data', '%02x' % b, '%04x' % a, '%04x' % (a + int(m[1], 16)), before(b, a), '%d bytes' % int(m[1], 16)])
with open(sys.argv[6], 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f); w.writerow(['kind', 'bank', 'start', 'end', 'label_before', 'detail']); w.writerows(rows)
c = collections.Counter(r[0] for r in rows)
nb = sum(int(r[5].split()[0]) for r in rows if r[0] == 'default_data')
ni = sum(int(r[5].split()[0]) for r in rows if r[0] == 'new_code')
print(dict(c), '| new instructions %d | untyped data bytes %d' % (ni, nb))
