#!/usr/bin/env python3
"""L3 pass 4 for a build with no generated listing yet (the Gold ROM): carry the decisions of tools/port_check_names4.py from another port.

  tools/port_check_names4_copy.py FROM_TREE FROM_SUFFIX FROM_ROM TREE SUFFIX ROM

A name still at I here is confirmed (or relabelled) as in FROM when FROM has a pass-4 row for the same name and the block's bytes are equal in the two ROMs
(the block = from the label to the next label of this build, within the bank).  Rows are appended to <TREE>/disasm/sym_names_<s>_checked.csv
(earlier pass-4 rows replaced); the source column says 'checked4 (copied from FROM)'.
"""
import sys, csv, bisect, os
FT, FS, FR, T, S, R = sys.argv[1:7]
def flat(b, a): return a if b == 0 else b * 0x4000 + a - 0x4000
def merged(tree, s, skip4):
    names = {}
    for suf in ('', '_loaders', '_reads', '_checked', '_hand'):
        p = '%s/disasm/sym_names_%s%s.csv' % (tree, s, suf)
        if not os.path.exists(p): continue
        for r in csv.DictReader(open(p, encoding='utf-8')):
            if skip4 and 'checked4 (copied' in r.get('source', ''): continue
            k = (int(r['bank'], 16), int(r['addr'], 16))
            if r['name'] == '-': names.pop(k, None)
            else: names[k] = r
    return names
U = open(FR, 'rb').read(); G = open(R, 'rb').read()
fn = merged(FT, FS, False); gn = merged(T, S, True)
# FROM: pass-4 rows by their original name (the note keeps 'the Japanese name X' for relabels; else the name itself)
import re
byname = {}
for k, r in fn.items():
    if re.search(r'checked[4-7]: ', r.get('source', '')):
        m = re.search(r'(?:the Japanese name|the earlier name) (\S+?)[;,)]?(?: describes| numbered|$|;)', r['note']); byname[m.group(1) if m else r['name']] = (k, r)
gk = sorted(flat(*k) for k in gn); out = []
for (b, a), r in sorted(gn.items()):
    if r['conf'] != 'I' or r['name'] not in byname: continue
    (fb, fa), fr = byname[r['name']]; o = flat(b, a); i = bisect.bisect_right(gk, o); e = min(gk[i] if i < len(gk) else 1 << 20, (o // 0x4000 + 1) * 0x4000)
    fo = flat(fb, fa)
    if G[o:e] != U[fo:fo + (e - o)]: continue
    out.append(['%02x' % b, '%04x' % a, fr['name'], 'C', fr['note'] + '; bytes equal to %s %02X:%04X' % (FT.split('/')[-1], fb, fa), 'checked4 (copied from %s): %s' % (FT, r.get('source', ''))])
p = '%s/disasm/sym_names_%s_checked.csv' % (T, S); keep = [l for l in open(p, encoding='utf-8') if 'checked4 (copied' not in l]
open(p, 'w', encoding='utf-8').write(''.join(keep))
with open(p, 'a', newline='', encoding='utf-8') as fh: csv.writer(fh, lineterminator='\n').writerows(out)
print(len(out), 'names carried to', T)
