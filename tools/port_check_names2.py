#!/usr/bin/env python3
"""Second pass of the checked layer (after tools/port_check_names.py): three more rules for data names left at I.

  tools/port_check_names2.py JP.gb OTHER.gb MAP.npy DIR SUFFIX COV.npz [--skip-banks 02]

DIR is roms/<folder>/disasm; the layers sym_names_<s>{,_loaders,_reads,_checked,_hand}.csv are merged as the build does, and the
confirmed rows are appended to sym_names_<s>_checked.csv.
  loader  a block named `<Gfx|Map|Src|Data>_BB_AAAA_<Routine>` whose routine is seen reading it (COV call site or first reader,
          GBCAM_SITE_ALL run) or is named in the loader layer's note;
  entry   a block named `entry N of the {lo,hi,bank} table BB:AAAA`, when entry N of this build's table (mapped through MAP) points here;
  equal   the bytes of the Japanese type row of the name are equal here (the change lies after the block).
--skip-banks: banks where COV does not describe this ROM (the Gold ROM borrows the international coverage, except bank 02).
"""
import sys, csv, re, bisect, collections, argparse
import numpy as np
ap = argparse.ArgumentParser(); ap.add_argument('jp'); ap.add_argument('other'); ap.add_argument('map'); ap.add_argument('dir'); ap.add_argument('suffix'); ap.add_argument('cov')
ap.add_argument('--skip-banks', default=''); a = ap.parse_args()
J = open(a.jp, 'rb').read(); U = open(a.other, 'rb').read(); M = np.load(a.map); S = a.suffix; D = a.dir.rstrip('/') + '/'
skip = {int(x, 16) for x in a.skip_banks.split(',') if x}
def flat(b, ad): return ad if b == 0 else b * 0x4000 + ad - 0x4000
names = {}
for f in ['layers/sym_names_%s_port.csv', 'layers/sym_names_%s_loaders.csv', 'layers/sym_names_%s_reads.csv', 'layers/sym_names_%s_checked.csv', 'layers/sym_names_%s_hand.csv']:
    try: rows = list(csv.DictReader(open(D + f % S, encoding='utf-8')))
    except FileNotFoundError: continue
    for r in rows:
        k = (int(r['bank'], 16), int(r['addr'], 16))
        if r['name'] == '-': names.pop(k, None)
        else: names[k] = r
JT = {}
for r in csv.DictReader(open('roms/jp_rev_a/disasm/sym_types_jp.csv', encoding='utf-8')): JT.setdefault(flat(int(r['bank'], 16), int(r['start'], 16)), flat(int(r['bank'], 16), int(r['end'], 16)))
JC = {(int(r['bank'], 16), int(r['addr'], 16)): r['conf'] for r in csv.DictReader(open('roms/jp_rev_a/disasm/sym_names_jp.csv', encoding='utf-8'))}
code = {r['name'] for r in names.values() if not re.match(r'(Gfx|Map|Src|Data|Unused|StampCat|Font|Sheet|OamList|Song|AlbumB|WildFrame)', r['name'])}
z = np.load(a.cov); dr = z['dr'] != 0; site = z['site']; rdr = z['rdr']
labs = sorted((flat(*k), r['name']) for k, r in names.items()); keys = [x for x, _ in labs]
def lab(v):
    v = int(v) & 0x7FFFFFFF; b, ad = v >> 16, v & 0xFFFF; o = flat(b if ad >= 0x4000 else 0, ad); i = bisect.bisect_right(keys, o) - 1; return labs[i][1]
ldn = collections.defaultdict(set)
try:
    for r in csv.DictReader(open(D + 'layers/sym_names_%s_loaders.csv' % S, encoding='utf-8')):
        ldn[(int(r['bank'], 16), int(r['addr'], 16))] |= set(re.findall(r'[A-Za-z0-9_]+', r['note']))
except FileNotFoundError: pass
out = []; cnt = collections.Counter()
for (b, ad), r in names.items():
    if r['conf'] != 'I': continue
    o = flat(b, ad); why = None
    m = re.search(r'entry (\d+) of the \{lo,hi,bank\} table ([0-9A-F]{2}):([0-9A-F]{4})', r['note'])
    if m:
        t = int(M[flat(int(m.group(2), 16), int(m.group(3), 16))]); n = int(m.group(1))
        if t >= 0 and (U[t + 3 * n + 2], U[t + 3 * n] | U[t + 3 * n + 1] << 8) == (b, ad):
            why = 'entry', "C: entry %d of this build's table points here" % n
    if not why and 'content differs' in r['source']:
        mm = re.search(r'port JP ([0-9A-F]{2}):([0-9A-F]{4})', r['source'])
        if mm:
            jb, ja = int(mm.group(1), 16), int(mm.group(2), 16); jo = flat(jb, ja); e = JT.get(jo)
            if e and JC.get((jb, ja)) == 'C' and U[o:o + e - jo] == J[jo:e]:
                why = 'equal', 'C: the %d bytes of the Japanese type row are equal here (the change is after the block)' % (e - jo)
        ml = re.match(r'(Gfx|Map|Src|Data)_[0-9A-F]{2}_[0-9A-F]{4}_(.+?)(_Part[0-9A-F]{4})?$', r['name'])
        if not why and ml and ml.group(2) in code and b not in skip:
            i = bisect.bisect_right(keys, o); e = min(keys[i] if i < len(keys) else 1 << 20, (o // 0x4000 + 1) * 0x4000); rd = dr[o:e]
            seen = {lab(v) for v in site[o:e][rd] if v} | {lab(v) for v in rdr[o:e] if v & 0x80000000}
            if ml.group(2) in seen or ml.group(2) in ldn.get((b, ad), set()):
                why = 'loader', 'C: the bytes changed but %s reads them in this build (coverage call site or loader layer): the name says who loads the block, which holds' % ml.group(2)
    if why:
        cnt[why[0]] += 1
        out.append(['%02x' % b, '%04x' % ad, r['name'], 'C', (r['note'] + '; ' if r['note'] else '') + why[1], 'checked: ' + r['source']])
with open(D + 'layers/sym_names_%s_checked.csv' % S, 'a', newline='', encoding='utf-8') as fh: csv.writer(fh, lineterminator='\n').writerows(out)
print('second pass:', dict(cnt))
