#!/usr/bin/env python3
"""Find the Japanese routines in the Hello Kitty ROM by their bytes (L3: names ported only where the code really matches).

  tools/kitty_match_jp.py JP_ROM KITTY_ROM OUT.csv [--min 12]

Japanese routines: every label of roms/jp_rev_a/disasm/sym_names_jp.csv that starts proven code in the Japanese trace
(roms/jp_rev_a/... via the .sym code blocks), cut at the next label of the same bank; only the routines of at least --min bytes.
Each is decoded into instructions and turned into a pattern where the operands that depend on the build are wildcards:
16-bit addresses (call / jp / ld rr,nn / ld [nn],a / ld a,[nn] / ld [nn],sp) and the HRAM byte of ldh (the two builds keep
their variables at other addresses); every opcode, every 8-bit immediate and every jr offset must be equal. The pattern is
searched at every instruction start of the Kitty trace (roms/hello_kitty/trace/trace_kitty.json).
OUT.csv: jp_bank, jp_addr, jp_name, jp_tag, bytes, instructions, kitty (BB:AAAA list of the matches, '' if none), hits,
kind: `exact` (the Kitty bytes are equal, operands included), `masked` (equal with the operands above as wildcards).
A match is evidence C that the code is the same routine (the name can be ported); several hits or a very short routine are
listed as they are and decided by hand. No other similarity is scored here.
"""
import sys, csv, re, json, argparse, collections, os
ap = argparse.ArgumentParser(); ap.add_argument('jp'); ap.add_argument('kitty'); ap.add_argument('out'); ap.add_argument('--min', type=int, default=12)
a = ap.parse_args()
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
J = open(a.jp, 'rb').read(); KR = open(a.kitty, 'rb').read()
LEN = [1] * 256
for op in (0x01, 0x08, 0x11, 0x21, 0x31, 0xC2, 0xC3, 0xC4, 0xCA, 0xCC, 0xCD, 0xD2, 0xD4, 0xDA, 0xDC, 0xEA, 0xFA): LEN[op] = 3
for op in (0x06, 0x0E, 0x16, 0x1E, 0x26, 0x2E, 0x36, 0x3E, 0x10, 0x18, 0x20, 0x28, 0x30, 0x38, 0xC6, 0xCB, 0xCE, 0xD6, 0xDE, 0xE0, 0xE6,
           0xE8, 0xEE, 0xF0, 0xF6, 0xF8, 0xFE): LEN[op] = 2
ADDR16 = {0x01, 0x08, 0x11, 0x21, 0x31, 0xC2, 0xC3, 0xC4, 0xCA, 0xCC, 0xCD, 0xD2, 0xD4, 0xDA, 0xDC, 0xEA, 0xFA}
def off(b, ad): return ad if ad < 0x4000 else b * 0x4000 + ad - 0x4000
# Japanese code blocks from the symbol file (.code:LEN lines) and labels
code_jp = []
for l in open(os.path.join(REPO, 'roms/jp_rev_a/pocketcamera_jp.sym')):
    m = re.match(r'([0-9a-fA-F]{2}):([0-9a-fA-F]{4}) \.code:([0-9a-fA-F]+)', l)
    if m: code_jp.append((int(m.group(1), 16), int(m.group(2), 16), int(m.group(3), 16)))
incode = {}
for b, s, n in code_jp:
    for i in range(n): incode[(b, s + i)] = (b, s, n)
labels = collections.defaultdict(list); info = {}
for r in csv.DictReader(open(os.path.join(REPO, 'roms/jp_rev_a/disasm/sym_names_jp.csv'))):
    b, ad = int(r['bank'], 16), int(r['addr'], 16); labels[b].append(ad); info[(b, ad)] = (r['name'], r['conf'])
for b in labels: labels[b] = sorted(set(labels[b]))
T = json.load(open(os.path.join(REPO, 'roms/hello_kitty/trace/trace_kitty.json')))
kstarts = sorted((int(k[:2], 16), int(k[3:], 16)) for k, n in T['code'].items() if n > 0)
KS = {off(b, ad): (b, ad) for b, ad in kstarts}
rows = []; nmatch = 0
for b in sorted(labels):
    L = labels[b]
    for i, ad in enumerate(L):
        if (b, ad) not in incode: continue
        cb, cs, cn = incode[(b, ad)]
        end = min(L[i + 1] if i + 1 < len(L) else 0x8000, cs + cn)
        o = off(b, ad); e = off(b, end); pat = b''; p = o; ni = 0
        while p < e:
            op = J[p]; n = LEN[op]
            if p + n > e: break
            if op in ADDR16: pat += re.escape(bytes([op])) + b'..'
            elif op in (0xE0, 0xF0): pat += re.escape(bytes([op])) + b'.'
            else: pat += re.escape(J[p:p + n])
            p += n; ni += 1
        size = p - o
        if size < a.min: continue
        hits = [h.start() for h in re.finditer(pat, KR, re.S) if h.start() in KS]
        exact = [h for h in hits if KR[h:h + size] == J[o:o + size]]
        if hits: nmatch += 1
        nm, tag = info[(b, ad)]
        rows.append(['%02X' % b, '%04X' % ad, nm, tag, size, ni, ' '.join('%02X:%04X' % KS[h] for h in hits[:8]), len(hits),
                     'exact' if hits and len(exact) == len(hits) else 'masked' if hits else ''])
with open(a.out, 'w', newline='') as f:
    w = csv.writer(f); w.writerow(['jp_bank', 'jp_addr', 'jp_name', 'jp_tag', 'bytes', 'instructions', 'kitty', 'hits', 'kind']); w.writerows(rows)
byb = collections.Counter(r[0] for r in rows if r[7])
print('kitty_match_jp: %d Japanese routines of %d+ bytes, %d found in the Kitty code (%d exact, %d with one hit); by Japanese bank %s' % (
    len(rows), a.min, nmatch, sum(1 for r in rows if r[8] == 'exact'), sum(1 for r in rows if r[7] == 1), dict(sorted(byb.items()))))
