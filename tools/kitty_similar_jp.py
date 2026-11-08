#!/usr/bin/env python3
"""Near matches of Japanese routines in the Hello Kitty ROM (L3, evidence I): what tools/kitty_match_jp.py does not find exactly.

  tools/kitty_similar_jp.py JP_ROM KITTY_ROM OUT.csv [--banks 00,01,02,0A,1F] [--min-ratio 0.85] [--min 16]

For each Japanese routine of --banks (a label of sym_names_jp.csv starting proven code, cut at the next label, at least --min
bytes) that kitty_match_jp.py found nowhere, the instruction sequence (opcode bytes; for CB the second byte; 8-bit immediates
kept, addresses dropped) is compared with the same sequence of every routine entry of the Kitty trace (an entry that is not a
local jr / jp target, cut at the next such entry of its bank), lengths within 25 %. The best Kitty entry with difflib ratio >= --min-ratio is written:
jp_bank, jp_addr, jp_name, jp_bytes, kitty, kitty_bytes, ratio, second (the ratio of the next best, to see ambiguous cases).
A near match says the routine was edited from the Japanese one; the name ported from it is tagged I and the differences are
for a human to read (L3 doubts).
"""
import sys, csv, re, json, argparse, collections, os, difflib
ap = argparse.ArgumentParser(); ap.add_argument('jp'); ap.add_argument('kitty'); ap.add_argument('out')
ap.add_argument('--banks', default='00,01,02,0A,1F'); ap.add_argument('--min-ratio', type=float, default=0.85); ap.add_argument('--min', type=int, default=16)
a = ap.parse_args(); HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
J = open(a.jp, 'rb').read(); KR = open(a.kitty, 'rb').read()
LEN = [1] * 256
for op in (0x01, 0x08, 0x11, 0x21, 0x31, 0xC2, 0xC3, 0xC4, 0xCA, 0xCC, 0xCD, 0xD2, 0xD4, 0xDA, 0xDC, 0xEA, 0xFA): LEN[op] = 3
for op in (0x06, 0x0E, 0x16, 0x1E, 0x26, 0x2E, 0x36, 0x3E, 0x10, 0x18, 0x20, 0x28, 0x30, 0x38, 0xC6, 0xCB, 0xCE, 0xD6, 0xDE, 0xE0, 0xE6,
           0xE8, 0xEE, 0xF0, 0xF6, 0xF8, 0xFE): LEN[op] = 2
IMM8 = {0x06, 0x0E, 0x16, 0x1E, 0x26, 0x2E, 0x36, 0x3E, 0xC6, 0xCE, 0xD6, 0xDE, 0xE6, 0xEE, 0xF6, 0xFE}
def off(b, ad): return ad if ad < 0x4000 else b * 0x4000 + ad - 0x4000
def seq(R, o, e):
    s = []; p = o
    while p < e:
        op = R[p]; n = LEN[op]
        if p + n > e: break
        s.append(op if op != 0xCB else 0x100 + R[p + 1])
        if op in IMM8: s.append(0x200 + R[p + 1])
        p += n
    return tuple(s), p - o
match = {(r['jp_bank'], r['jp_addr']) for r in csv.DictReader(open(os.path.join(REPO, 'roms/hello_kitty/disasm/match_jp_kitty.csv'))) if r['hits'] != '0'}
code_jp = []
for l in open(os.path.join(REPO, 'roms/jp_rev_a/pocketcamera_jp.sym')):
    m = re.match(r'([0-9a-fA-F]{2}):([0-9a-fA-F]{4}) \.code:([0-9a-fA-F]+)', l)
    if m: code_jp.append((int(m.group(1), 16), int(m.group(2), 16), int(m.group(3), 16)))
incode = {}
for b, s, n in code_jp:
    for i in range(n): incode[(b, s + i)] = (b, s, n)
labels = collections.defaultdict(list); nm = {}
for r in csv.DictReader(open(os.path.join(REPO, 'roms/jp_rev_a/disasm/sym_names_jp.csv'))):
    b, ad = int(r['bank'], 16), int(r['addr'], 16); labels[b].append(ad); nm[(b, ad)] = r['name']
T = json.load(open(os.path.join(REPO, 'roms/hello_kitty/port/trace_kitty.json')))
ent = collections.defaultdict(list)
for k, w in T['entries'].items():
    if w in ('jr', 'jr cc', 'jp'): continue      # local branch targets do not start a routine
    ent[int(k[:2], 16)].append(int(k[3:], 16))
code = {(int(k[:2], 16), int(k[3:], 16)) for k, n in T['code'].items() if n > 0}
kit = []
for b in ent:
    L = sorted(set(ent[b]))
    for i, ad in enumerate(L):
        if (b, ad) not in code: continue
        end = L[i + 1] if i + 1 < len(L) else (0x4000 if ad < 0x4000 else 0x8000)
        s, n = seq(KR, off(b, ad), off(b, end))
        if len(s) >= 4: kit.append(((b, ad), s, n))
rows = []
for b in [int(x, 16) for x in a.banks.split(',')]:
    L = sorted(set(labels[b]))
    for i, ad in enumerate(L):
        if ('%02X' % b, '%04X' % ad) in match or (b, ad) not in incode: continue
        cb, cs, cn = incode[(b, ad)]; end = min(L[i + 1] if i + 1 < len(L) else 0x8000, cs + cn)
        s, n = seq(J, off(b, ad), off(b, end))
        if n < a.min: continue
        best = []
        for k, ks, kn in kit:
            if not (0.75 * len(s) <= len(ks) <= 1.33 * len(s)): continue
            sm = difflib.SequenceMatcher(None, s, ks, autojunk=False)
            if sm.real_quick_ratio() < a.min_ratio or sm.quick_ratio() < a.min_ratio: continue
            best.append((sm.ratio(), k, kn))
        best.sort(reverse=True)
        if best and best[0][0] >= a.min_ratio:
            r0, k, kn = best[0]; r1 = best[1][0] if len(best) > 1 else 0
            rows.append(['%02X' % b, '%04X' % ad, nm[(b, ad)], n, '%02X:%04X' % k, kn, '%.3f' % r0, '%.3f' % r1])
with open(a.out, 'w', newline='') as f:
    w = csv.writer(f); w.writerow(['jp_bank', 'jp_addr', 'jp_name', 'jp_bytes', 'kitty', 'kitty_bytes', 'ratio', 'second']); w.writerows(rows)
print('kitty_similar_jp: %d near matches (ratio >= %.2f) of unmatched Japanese routines of banks %s; %d with a clear best (second < ratio - 0.05)' % (
    len(rows), a.min_ratio, a.banks, sum(1 for r in rows if float(r[7]) < float(r[6]) - 0.05)))
