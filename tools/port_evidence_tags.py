#!/usr/bin/env python3
"""Evidence tags of another build follow the Japanese convention (owner 2026-11-02: "proceed by evidences").

  tools/port_evidence_tags.py TREE SUFFIX [--dry]      (env ROM_US / ROM_GOLD / ROM_JP: the ROMs, default /root/work/roms)

C = the claim of the name is confirmed (run, code, bytes); I = it rests on the absence of evidence: a block or routine said to be unused, dead,
unreferenced or never loaded cannot be proven so by running the game, so the Japanese listing tags all of them I (87 names).  A name of this
build is set to I when
  - its Japanese counterpart (the same name, or the Japanese label at the same place through the byte map, bytes equal) is I there, or
  - its name says so: Unused_*, *_Dead, *_Unref*, TileGap_*, *_ExtraRow(s), *_HeadRows, *_BlankRows, *_FillRows*, *_Fill, *_ZeroTail, ZeroFill
    (except the padding names Bank*_ZeroFill / *_Padding*, which are typed by their bytes, as in the Japanese listing).
Rows go to <TREE>/disasm/sym_names_<s>_hand.csv with source 'evidence 2026-11-02' (earlier evidence rows replaced; the hand layer is the last one).
The other names keep their tag."""
import sys, os, re, csv, bisect
import numpy as np
a = [x for x in sys.argv[1:] if x != '--dry']; dry = '--dry' in sys.argv; T, S = a[0].rstrip('/'), a[1]; D = T + '/disasm/'
def flat(b, ad): return ad if b == 0 else b * 0x4000 + ad - 0x4000
TAG = 'evidence 2026-11-02'
names = {}
for suf in ('', '_loaders', '_reads', '_checked', '_hand'):
    p = D + 'layers/sym_names_%s%s.csv' % (S, suf or '_port')
    if not os.path.exists(p): continue
    for r in csv.DictReader(open(p, encoding='utf-8')):
        if r.get('source', '').startswith(TAG): continue
        k = (int(r['bank'], 16), int(r['addr'], 16))
        if r['name'] == '-': names.pop(k, None)
        else: names[k] = r
JP = {}
for r in csv.DictReader(open('roms/jp_rev_a/disasm/sym_names_jp.csv', encoding='utf-8')): JP[flat(int(r['bank'], 16), int(r['addr'], 16))] = r
jpname = {r['name']: r for r in JP.values()}
M = np.load('%s/port/map_%s.npy' % (T, S)); idx = np.nonzero(M >= 0)[0]; INV = dict(zip(M[idx].tolist(), idx.tolist()))     # flat here -> flat JP
KW = re.compile(r'(^Unused_|_Dead$|_Dead_|_Unref|^TileGap_|_ExtraRows?$|_HeadRows$|_BlankRows$|_FillRows|_Fill$|_ZeroTail$|ZeroFill_)')
PAD = re.compile(r'^(Bank[0-9A-F]{2}_ZeroFill$|.*_Padding)')
ROM = open(os.environ.get('ROM_' + S.upper(), {'us': '/root/work/roms/gbcam_us.gb', 'gold': '/root/work/roms/gbcam_gold.gb'}[S]), 'rb').read(); JR = open(os.environ.get('ROM_JP', '/root/work/roms/pocketcamera_jp.gb'), 'rb').read()
out = []; cnt = {}
for (b, ad), r in sorted(names.items()):
    n = r['name']; o = flat(b, ad); why = None
    j = jpname.get(n)
    if j is None and INV.get(o, -1) in JP and ROM[o:o + 16] == JR[INV[o]:INV[o] + 16]: j = JP[INV[o]]          # the Japanese label at the same place, same bytes
    if j is not None and j['conf'] == 'I': why = 'the Japanese label %s (%s:%s) is I' % (j['name'], j['bank'], j['addr'])
    elif KW.search(n) and not PAD.match(n): why = 'the name says it is unused / never loaded'
    if why and r['conf'] != 'I':
        cnt[why.split(' (')[0][:40]] = cnt.get(why.split(' (')[0][:40], 0) + 1
        out.append(['%02x' % b, '%04x' % ad, n, 'I', (r['note'] + '; ' if r['note'] else '') + 'evidence I (2026-11-02): ' + why + '; that something is never used rests on the absence of evidence (the Japanese convention)', TAG])
print('%s: %d names to I' % (T, len(out)), {k[:24]: v for k, v in cnt.items() if v > 1})
if dry:
    for x in out[:40]: print('  ', x[0] + ':' + x[1], x[2])
else:
    p = D + 'layers/sym_names_%s_hand.csv' % S; keep = [l for l in open(p, encoding='utf-8') if (',' + TAG) not in l and not l.rstrip().endswith(TAG)]
    open(p, 'w', encoding='utf-8').write(''.join(keep))
    with open(p, 'a', newline='', encoding='utf-8') as fh: csv.writer(fh, lineterminator='\n').writerows(out)
