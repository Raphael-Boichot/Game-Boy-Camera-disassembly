#!/usr/bin/env python3
"""Third pass of the checked layer: confirm I names from the role of the equivalent Japanese function or table (context rules).

  tools/port_check_names3.py JP.gb OTHER.gb DIR SUFFIX

  call    a routine: some instruction of this build that calls / jumps to it (call, jp, jr with an absolute target, any condition)
          is paired by the port (port/code_map_<s>.csv) with a Japanese instruction calling / jumping to the Japanese routine of
          the same name: it is the same callee in the same context, whatever changed inside it;
  table   a block placed by a word table, now also when its bytes changed: entry N of this build's table points here and the Japanese
          name is entry N of the Japanese table;
  slot    AlbumB_PhotoNN_{Tiles,Thumb,Footer}: slot NN of AlbumB_SlotTbl points to the tiles (thumb +$E00, footer +$F00);
  page    WildFrameN_*: entry N of WildFrame_PageSrcTbl points to the page (tiles, strips +$1180, tail +$1500);
  border  BorderNN_{Tiles,Map}: entry NN of Border_SrcTbl;
  oam     OamList_Bxx_TTTT_NN: entry NN of the word table OamPtrTbl_Bxx_TTTT points here;
  state   entry N of a state table (a name ending StateTable / SubstateTbl, present in both builds) points here and entry N of the Japanese
          table points to the Japanese routine of the same name;
  ref     an operand of this build that points here is paired with a Japanese operand pointing to the Japanese block (rom_operands).
The Japanese name must be C. Rows are appended to DIR/sym_names_<s>_checked.csv.
"""
import sys, csv, re, collections
J = open(sys.argv[1], 'rb').read(); U = open(sys.argv[2], 'rb').read(); D = sys.argv[3].rstrip('/') + '/'; S = sys.argv[4]
P = D.replace('/disasm/', '/port/')
def flat(b, ad): return ad if b == 0 or ad < 0x4000 else b * 0x4000 + ad - 0x4000
names = {}
for f in ['layers/sym_names_%s_port.csv', 'layers/sym_names_%s_loaders.csv', 'layers/sym_names_%s_reads.csv', 'layers/sym_names_%s_checked.csv', 'layers/sym_names_%s_hand.csv']:
    try: rows = list(csv.DictReader(open(D + f % S, encoding='utf-8')))
    except FileNotFoundError: continue
    for r in rows:
        k = (int(r['bank'], 16), int(r['addr'], 16))
        if r['name'] == '-': names.pop(k, None)
        else: names[k] = r
byname = {r['name']: k for k, r in names.items()}
JN = {}; JC = {}
for r in csv.DictReader(open('roms/jp_rev_a/disasm/sym_names_jp.csv', encoding='utf-8')):
    k = (int(r['bank'], 16), int(r['addr'], 16)); JN[r['name']] = k; JC[k] = r['conf']
def target(R, b, a):        # absolute target of a call / jp at bank b address a, or None
    o = flat(b, a); op = R[o]
    if op in (0xCD, 0xC4, 0xCC, 0xD4, 0xDC, 0xC3, 0xC2, 0xCA, 0xD2, 0xDA):
        t = R[o + 1] | R[o + 2] << 8; return (b if t >= 0x4000 else 0, t)
    return None
callers = collections.defaultdict(list)
for r in csv.DictReader(open(P + 'code_map_%s.csv' % S, encoding='utf-8')):
    b = int(r['bank'], 16); jo, uo = int(r['jp'], 16), int(r['other'], 16)
    ub = b if uo >= 0x4000 else 0; jb = b if jo >= 0x4000 else 0
    tu = target(U, ub, uo); tj = target(J, jb, jo)
    if tu and tj: callers[tu].append(tj)
def tbl(R, k, n, rec=3):
    o = flat(*k) + rec * n; return (R[o + 2], R[o] | R[o + 1] << 8)

# state tables: entry-by-entry pairing of the word tables present under the same name in both builds
statepair = {}
for nm, k in byname.items():
    if not re.search(r'(StateTable|SubstateTbl)$', nm) or nm not in JN: continue
    jk_ = JN[nm]; ou = flat(*k); oj = flat(*jk_)
    for i in range(64):
        wu = U[ou + 2 * i] | U[ou + 2 * i + 1] << 8; wj = J[oj + 2 * i] | J[oj + 2 * i + 1] << 8
        ku = (k[0] if wu >= 0x4000 else 0, wu); kj = (jk_[0] if wj >= 0x4000 else 0, wj)
        if ku not in names or kj not in JC: break
        statepair[ku] = (kj, nm, i)
def key(s_):
    p_ = s_.split(':'); return (int(p_[0], 16), int(p_[1], 16)) if len(p_) == 2 else None
cmap = {}
for r in csv.DictReader(open(P + 'code_map_%s.csv' % S, encoding='utf-8')):
    b = int(r['bank'], 16); jo, uo = int(r['jp'], 16), int(r['other'], 16); cmap[(b if uo >= 0x4000 else 0, uo)] = (b if jo >= 0x4000 else 0, jo)
uref = collections.defaultdict(list); jref = collections.defaultdict(set)
for f_, d_ in ((D + 'rom_operands_%s.csv' % S, 'u'), ('roms/jp_rev_a/disasm/rom_operands_jp.csv', 'j')):
    try: rows_ = list(csv.DictReader(open(f_, encoding='utf-8')))
    except FileNotFoundError: continue                       # the ref rule needs this build's operand table (L5)
    for r in rows_:
        t = key(r['target']) if r['target'] else None; s_ = key(r['site'])
        if t and s_:
            if d_ == 'u': uref[t].append(s_)
            else: jref[s_].add(t)
out = []; cnt = collections.Counter()
for k, r in names.items():
    if r['conf'] != 'I': continue
    m = re.search(r'port JP ([0-9A-F]{2}):([0-9A-F]{4})', r['source'])
    if not m: continue
    jk = (int(m.group(1), 16), int(m.group(2), 16))
    if JC.get(jk) != 'C': continue
    n = r['name']; why = None
    if jk in callers.get(k, []): why = 'call', 'C: called from an instruction that the port pairs with a Japanese call to the Japanese routine (same callee, same context)'
    ms = re.match(r'AlbumB_Photo(\d\d)_(Tiles|Thumb|Footer)$', n)
    if not why and ms and 'AlbumB_SlotTbl' in byname:
        b, a = tbl(U, byname['AlbumB_SlotTbl'], int(ms.group(1)) - 1); a += {'Tiles': 0, 'Thumb': 0xE00, 'Footer': 0xF00}[ms.group(2)]
        if (b, a) == k: why = 'slot', 'C: slot %s of AlbumB_SlotTbl points here (thumbnail +$E00, footer +$F00); the picture may differ, the role holds' % ms.group(1)
    mw = re.match(r'WildFrame(\d)_(Tiles|LateralStrips|TilesTail)$', n)
    if not why and mw and 'WildFrame_PageSrcTbl' in byname:
        b, a = tbl(U, byname['WildFrame_PageSrcTbl'], int(mw.group(1))); a += {'Tiles': 0, 'LateralStrips': 0x1180, 'TilesTail': 0x1500}[mw.group(2)]
        if (b, a) == k: why = 'page', 'C: entry %s of WildFrame_PageSrcTbl points to this page' % mw.group(1)
    mb = re.match(r'Border(\d\d)_(Tiles|Map)$', n)
    if not why and mb and 'Border_SrcTbl' in byname:
        i = int(mb.group(1)) * 2 + (1 if mb.group(2) == 'Map' else 0)
        if tbl(U, byname['Border_SrcTbl'], i) == k: why = 'border', 'C: entry %s of Border_SrcTbl points here' % mb.group(1)
    mt = re.search(r'placed by the word table (\w+) \(entry (\d+)\)', r['source'])
    if not why and mt and mt.group(1) in byname:
        tk = byname[mt.group(1)]; e = int(mt.group(2)); o = flat(*tk) + 2 * e; w = U[o] | U[o + 1] << 8
        if (tk[0] if w >= 0x4000 else 0, w) == k: why = 'table', 'C: entry %s of %s points here, as in the Japanese build (bytes changed, role kept)' % (e, mt.group(1))
    mo = re.match(r'OamList_B([0-9A-F]{2})_([0-9A-F]{4})_([0-9A-F]+)$', n)
    if not why and mo and 'OamPtrTbl_B%s_%s' % (mo.group(1), mo.group(2)) in byname:
        tk = byname['OamPtrTbl_B%s_%s' % (mo.group(1), mo.group(2))]; e = int(mo.group(3), 16); o = flat(*tk) + 2 * e; w = U[o] | U[o + 1] << 8
        if (tk[0], w) == k: why = 'oam', 'C: entry $%s of OamPtrTbl_B%s_%s points here, as in the Japanese build (bytes changed, role kept)' % (mo.group(3), mo.group(1), mo.group(2))
    if not why and k in statepair and statepair[k][0] == jk:
        why = 'state', 'C: entry %d of %s points here, and entry %d of the Japanese table points to the Japanese routine of this name' % (statepair[k][2], statepair[k][1], statepair[k][2])
    if not why and any(s_ in cmap and jk in jref.get(cmap[s_], set()) for s_ in uref.get(k, [])):
        why = 'ref', 'C: an operand pointing here is paired by the port with a Japanese operand pointing to the Japanese block'
    if why:
        cnt[why[0]] += 1
        out.append(['%02x' % k[0], '%04x' % k[1], n, 'C', (r['note'] + '; ' if r['note'] else '') + why[1], 'checked: ' + r['source']])
with open(D + 'layers/sym_names_%s_checked.csv' % S, 'a', newline='', encoding='utf-8') as fh: csv.writer(fh, lineterminator='\n').writerows(out)
print('third pass:', dict(cnt))
