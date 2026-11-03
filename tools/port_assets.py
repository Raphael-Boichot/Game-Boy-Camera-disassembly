#!/usr/bin/env python3
"""Name and type the blocks that another build's banked-copy calls load, where the carried names have no label.

  tools/port_assets.py OTHER.gb OTHER_TRACE.json CODE_MAP.csv NAMES.csv [more names csv ...] --out-names X.csv --out-types Y.csv

Every direct call of the trace (`callargs`) is a candidate; its arguments are re-derived from the ROM: walking back over the
straight line of traced instructions before the call (stopping at a branch target, a call or a jump), a register counts as a
constant only if its last writer is an immediate load (`ld a, n` / `ld hl|bc|de, nn`; an `add hl, de` after the load makes it
unknown). A call to one of the banked copy
helpers (the JP Mem_CopyFromBank $0450, Vram_CopyFromBankAuto $0479, Vram_CopyFromBank_4 $0586, Vram_CopyFromBank $05F8,
Unused_Vram_CopyFromBank_8 $069F, at their addresses in this build through the instruction map) with all four constant and a
ROM source gives a block {bank A, HL, BC bytes} copied to DE. A block is kept only if no byte of it is traced code, and is
written only when no name sits at its start already (410 of the 458 blocks of the international build start on a carried name).
Name: `Gfx_BB_AAAA_<consumer>` (destination $8000-$97FF, tiles), `Map_BB_AAAA_<consumer>` ($9800-$9FFF), `Src_BB_AAAA_<consumer>`
(elsewhere), consumer = the label before the call; tag C (the call and its arguments are in the trace). Type row: data, width 16
for tiles, 32 for a map, 1 otherwise (width kept only if the length is a multiple of it). Where blocks overlap, the first call
(lowest address) names the block.
"""
import sys, json, csv, re, argparse, bisect, collections
ap = argparse.ArgumentParser()
ap.add_argument('rom'); ap.add_argument('trace'); ap.add_argument('codemap'); ap.add_argument('names', nargs='+')
ap.add_argument('--out-names', required=True); ap.add_argument('--out-types', required=True)
a = ap.parse_args()
T = json.load(open(a.trace))
def off(b, ad): return ad if ad < 0x4000 else b * 0x4000 + ad - 0x4000
code = set()
for k, n in T['code'].items():
    b, ad = (int(x, 16) for x in k.split(':'))
    if n > 0:
        for i in range(n): code.add(off(b, ad) + i)
CM = {}
for r in csv.DictReader(open(a.codemap)):
    if r['bank'] == '00': CM[int(r['jp'], 16)] = int(r['other'], 16)
HELPERS = {CM[j]: n for j, n in ((0x0450, 'Mem_CopyFromBank'), (0x0479, 'Vram_CopyFromBankAuto'), (0x0586, 'Vram_CopyFromBank_4'),
                                (0x05F8, 'Vram_CopyFromBank'), (0x069F, 'Unused_Vram_CopyFromBank_8')) if j in CM}
names = {}
for fn in a.names:
    for r in csv.DictReader(open(fn, encoding='utf-8')):
        k = (int(r['bank'], 16), int(r['addr'], 16))
        if r['name'] in ('-', ''): names.pop(k, None)
        else: names[k] = r['name']
bylab = collections.defaultdict(list)
for (b, ad), nm in names.items(): bylab[b].append((ad, nm))
for b in bylab: bylab[b].sort()
def consumer(b, pc):
    L = bylab[0 if pc < 0x4000 else b]; i = bisect.bisect_right(L, (pc, '￿')) - 1
    return L[i][1] if i >= 0 else 'Bank%02X' % b
ROM = open(a.rom, 'rb').read()
INS = {}
for k, n in T['code'].items():
    bb, ad = (int(x, 16) for x in k.split(':'))
    if n > 0: INS[(0 if ad < 0x4000 else bb, ad)] = n
PREV = {(bb, ad + n): ad for (bb, ad), n in INS.items()}
ENTRY = {tuple(int(x, 16) for x in k.split(':')) for k in T['entries']}          # branch targets, routine entries: a straight line stops there
def writes(op, cb):
    """registers (a, hl, bc, de) that the instruction writes, or None when it ends the straight line (call, rst, jumps, ret)"""
    if op in (0xCD, 0xC4, 0xCC, 0xD4, 0xDC, 0xC3, 0xC2, 0xCA, 0xD2, 0xDA, 0x18, 0x20, 0x28, 0x30, 0x38, 0xC9, 0xC0, 0xC8, 0xD0, 0xD8, 0xD9, 0xE9) or (op & 0xC7) == 0xC7: return None
    w = set()
    if op == 0xCB:
        if (cb & 7) == 7 and not (0x40 <= cb < 0x80): w.add('a')
        if (cb & 7) in (0, 1) and not (0x40 <= cb < 0x80): w.add('bc')
        if (cb & 7) in (2, 3) and not (0x40 <= cb < 0x80): w.add('de')
        if (cb & 7) in (4, 5) and not (0x40 <= cb < 0x80): w.add('hl')
        return w
    if op in (0x3E, 0x0A, 0x1A, 0x2A, 0x3A, 0xFA, 0xF0, 0xF2, 0x07, 0x0F, 0x17, 0x1F, 0x27, 0x2F, 0x3C, 0x3D, 0xF1) or 0x78 <= op <= 0x7F \
       or (0x80 <= op <= 0xB7) or op in (0xC6, 0xCE, 0xD6, 0xDE, 0xE6, 0xEE, 0xF6): w.add('a')
    if op in (0x21, 0x09, 0x19, 0x29, 0x39, 0x23, 0x2B, 0x22, 0x2A, 0x32, 0x3A, 0xE1, 0x26, 0x2E, 0xF8, 0x24, 0x25, 0x2C, 0x2D) or 0x60 <= op <= 0x6F: w.add('hl')
    if op in (0x01, 0x03, 0x0B, 0xC1, 0x06, 0x0E, 0x04, 0x05, 0x0C, 0x0D) or 0x40 <= op <= 0x4F: w.add('bc')
    if op in (0x11, 0x13, 0x1B, 0xD1, 0x16, 0x1E, 0x14, 0x15, 0x1C, 0x1D) or 0x50 <= op <= 0x5F: w.add('de')
    return w
def args(bank, pc):
    """the constants that A / HL / BC / DE certainly hold at the call at bank:pc (straight line back, last writer an immediate load)"""
    val = {}; done = set(); cur = pc; steps = 0
    while steps < 24 and len(done) < 4:
        if (bank, cur) in ENTRY and steps: break
        p = PREV.get((bank, cur))
        if p is None: break
        o = off(bank, p); op = ROM[o]; w = writes(op, ROM[o + 1])
        if w is None: break
        for r in w - done:
            imm = {('a', 0x3E): ROM[o + 1], ('hl', 0x21): ROM[o + 1] | ROM[o + 2] << 8, ('bc', 0x01): ROM[o + 1] | ROM[o + 2] << 8, ('de', 0x11): ROM[o + 1] | ROM[o + 2] << 8}.get((r, op))
            val[r] = imm; done.add(r)
        cur = p; steps += 1
    return val
taken = set(names); outn = []; outt = []; seen = set(); stat = collections.Counter()
for b, pc, callee, A, HL, BC, DE in sorted(T['callargs'], key=lambda x: (x[0], x[1])):
    if callee not in HELPERS: continue
    v = args(b if pc >= 0x4000 else 0, pc); A, HL, BC, DE = v.get('a'), v.get('hl'), v.get('bc'), v.get('de')
    if None in (A, HL, BC, DE) or not (HL < 0x8000) or BC == 0: stat['not constant'] += 1; continue
    sb = 0 if HL < 0x4000 else A
    if sb >= 64: stat['bad bank'] += 1; continue
    o = off(sb, HL)
    if (HL < 0x4000 and HL + BC > 0x4000) or (HL >= 0x4000 and HL + BC > 0x8000): stat['crosses the bank'] += 1; continue
    if any(o + i in code for i in range(BC)): stat['on traced code'] += 1; continue
    if (sb, HL, BC) in seen: continue
    seen.add((sb, HL, BC))
    if (sb, HL) in taken: stat['name already there'] += 1; continue
    kind = 'Gfx' if 0x8000 <= DE < 0x9800 else ('Map' if 0x9800 <= DE < 0xA000 else 'Src')
    wd = {'Gfx': 16, 'Map': 32, 'Src': 1}[kind]
    if BC % wd: wd = 1
    nm = '%s_%02X_%04X_%s' % (kind, sb, HL, consumer(b, pc))
    taken.add((sb, HL))
    outn.append(['%02x' % sb, '%04x' % HL, nm, 'C', 'loaded by %s at %02X:%04X: %s $%X bytes to $%04X (this build\'s trace)' % (HELPERS[callee], b if pc >= 0x4000 else 0, pc, kind, BC, DE), 'loader'])
    outt.append(['%02x' % sb, '%04x' % HL, '%04x' % (HL + BC), 'data', str(wd), 'loaded by %02X:%04X' % (b if pc >= 0x4000 else 0, pc)])
    stat['named'] += 1
with open(a.out_names, 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['bank', 'addr', 'name', 'conf', 'note', 'source']); w.writerows(outn)
with open(a.out_types, 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['bank', 'start', 'end', 'type', 'width', 'note']); w.writerows(outt)
print('loader blocks:', dict(stat))
