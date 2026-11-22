#!/usr/bin/env python3
"""The Japanese counterpart of every Hello Kitty name, for the owner's validation of names (owner, 2026-11-22: "for the names
waiting for my validation, check counterpart in japanese rom too").

  tools/kitty_jp_counterparts.py KITTY.gb JP.gb [--out roms/hello_kitty/disasm/jp_counterparts_kitty.csv]

For each name of disasm/sym_names_kitty.csv (its block: up to the next name, in its bank):
  * code: the Japanese routine matched to its address by disasm/match_jp_kitty.csv (exact or masked: the same instructions, the
    addresses masked) or disasm/similar_jp_kitty.csv (a near copy, its ratio given);
  * code not matched so: the nearest Japanese routine (whole ROM, instruction sequence ratio >= 0.75; under 0.9, under 16 instructions,
    or with a second one at 0.9 or more, it counts as ambiguous);
  * data: the Japanese label holding the same bytes, when the block (16 bytes or more, not one repeated value) is found exactly once
    in the Japanese ROM (at the start of a Japanese label, or inside one: the offset is given);
then the relation: same (the Kitty name is the Japanese one), same_but_address (the same but for its own address), jp_adds_detail
(the Japanese name is the Kitty one plus a suffix: its use in the Japanese game), ambiguous (a code match shared by several copies,
twin routines that differ only in their addresses, or under 16 bytes: perhaps not the counterpart), differs (to review), none.
The verdict is the owner's; this table only gives the counterparts (C: byte equality and the matches are measured).
"""
import argparse, csv, os, re, bisect, collections
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
KD = os.path.join(REPO, 'roms', 'hello_kitty', 'disasm'); JD = os.path.join(REPO, 'roms', 'jp_rev_a', 'disasm')
ap = argparse.ArgumentParser(); ap.add_argument('kitty'); ap.add_argument('jp')
ap.add_argument('--out', default=os.path.join(KD, 'jp_counterparts_kitty.csv')); a = ap.parse_args()
K = open(a.kitty, 'rb').read(); J = open(a.jp, 'rb').read()
def fl(b, ad): return ad if b == 0 else b * 0x4000 + ad - 0x4000
def key(o): return (0, o) if o < 0x4000 else (o // 0x4000, o % 0x4000 + 0x4000)
KN = [r for r in csv.DictReader(open(os.path.join(KD, 'sym_names_kitty.csv'), encoding='utf-8'))]
JN = {}
for r in csv.DictReader(open(os.path.join(JD, 'sym_names_jp.csv'), encoding='utf-8')): JN[fl(int(r['bank'], 16), int(r['addr'], 16))] = r['name']
JO = sorted(JN)
JBYNAME = {}
for o_, n_ in JN.items(): JBYNAME.setdefault(re.sub(r'^Unused_', '', n_), o_)
# near copies, Kitty -> Japanese (the reverse of tools/kitty_similar_jp.py, over the whole Japanese ROM): the instruction sequence of
# each Kitty code label without a counterpart (opcodes, CB second bytes, 8-bit immediates; addresses dropped) against every Japanese
# label on proven code, candidates sharing 4-instruction pieces, the best difflib ratio kept when >= 0.75
import difflib, importlib.util, json
LEN = [1] * 256
for op in (0x01, 0x08, 0x11, 0x21, 0x31, 0xC2, 0xC3, 0xC4, 0xCA, 0xCC, 0xCD, 0xD2, 0xD4, 0xDA, 0xDC, 0xEA, 0xFA): LEN[op] = 3
for op in (0x06, 0x0E, 0x16, 0x1E, 0x26, 0x2E, 0x36, 0x3E, 0x10, 0x18, 0x20, 0x28, 0x30, 0x38, 0xC6, 0xCB, 0xCE, 0xD6, 0xDE, 0xE0, 0xE6,
           0xE8, 0xEE, 0xF0, 0xF6, 0xF8, 0xFE): LEN[op] = 2
IMM8 = {0x06, 0x0E, 0x16, 0x1E, 0x26, 0x2E, 0x36, 0x3E, 0xC6, 0xCE, 0xD6, 0xDE, 0xE6, 0xEE, 0xF6, 0xFE}
def seq(R, o, e):
    q = []; p = o
    while p < e:
        op = R[p]; n = LEN[op]
        if p + n > e: break
        q.append(op if op != 0xCB else 0x100 + R[p + 1])
        if op in IMM8: q.append(0x200 + R[p + 1])
        p += n
    return tuple(q)
def codeset(sym):
    c = set()
    for l in open(sym):
        m = re.match(r'([0-9a-fA-F]{2}):([0-9a-fA-F]{4}) \.code:([0-9a-fA-F]+)', l)
        if m: o_ = fl(int(m.group(1), 16), int(m.group(2), 16)); c.update(range(o_, o_ + int(m.group(3), 16)))
    return c
JC = codeset(os.path.join(REPO, 'roms', 'jp_rev_a', 'pocketcamera_jp.sym')); KC = codeset(os.path.join(REPO, 'roms', 'hello_kitty', 'pocketcamera_kitty.sym'))
JSEQ = []
for i_, o_ in enumerate(JO):
    if o_ not in JC: continue
    e_ = JO[i_ + 1] if i_ + 1 < len(JO) else len(J); e_ = min(e_, (o_ // 0x4000 + 1) * 0x4000)
    while e_ > o_ and (e_ - 1) not in JC: e_ -= 1
    q_ = seq(J, o_, e_)
    if len(q_) >= 6: JSEQ.append((o_, q_))
SH = collections.defaultdict(set)
for i_, (o_, q_) in enumerate(JSEQ):
    for k_ in range(len(q_) - 3): SH[q_[k_:k_ + 4]].add(i_)
def near(o, e):
    while e > o and (e - 1) not in KC: e -= 1
    q = seq(K, o, e)
    if len(q) < 6: return None
    votes = collections.Counter()
    for k_ in range(len(q) - 3):
        for i_ in SH.get(q[k_:k_ + 4], ()): votes[i_] += 1
    best = []
    for i_, v in votes.most_common(12):
        jq = JSEQ[i_][1]
        if not (0.6 * len(q) <= len(jq) <= 1.67 * len(q)): continue
        best.append((difflib.SequenceMatcher(None, q, jq, autojunk=False).ratio(), JSEQ[i_][0]))
    best.sort(reverse=True)
    if not best or best[0][0] < 0.75: return None
    r_, jo = best[0]; jb, ja = key(jo)
    return (JN[jo], '%02X:%04X' % (jb, ja), 'code near copy, ratio %.2f (%d instructions)%s' % (r_, len(q), '; next %.2f' % best[1][0] if len(best) > 1 else ''))
code = {}
for r in csv.DictReader(open(os.path.join(KD, 'match_jp_kitty.csv'), encoding='utf-8')):
    hits = r['kitty'].split()
    for h in hits:                                  # a Japanese routine found at several Kitty places: each copy gets it
        b, ad = h.split(':'); code.setdefault(fl(int(b, 16), int(ad, 16)), (r['jp_name'], '%s:%s' % (r['jp_bank'], r['jp_addr']), 'code %s, %s bytes' % (r['kind'], r['bytes']) + (' (one of %d copies)' % len(hits) if len(hits) > 1 else '')))
for r in csv.DictReader(open(os.path.join(KD, 'similar_jp_kitty.csv'), encoding='utf-8')):
    b, ad = r['kitty'].split(':'); o = fl(int(b, 16), int(ad, 16))
    if o not in code: code[o] = (r['jp_name'], '%s:%s' % (r['jp_bank'], r['jp_addr']), 'code similar %s' % r['ratio'])
ko = sorted(fl(int(r['bank'], 16), int(r['addr'], 16)) for r in KN)
def norm(n): return re.sub(r'^Unused_', '', n)
def noaddr(n): return re.sub(r'_[0-9A-F]{4}(?=_|$)', '', re.sub(r'_[0-9A-F]{2}_[0-9A-F]{4}(?=_|$)', '', norm(n)))
def weak(basis): return 'copies)' in basis or bool(re.search(r'code (masked|exact), ([0-9]|1[0-5]) bytes', basis)) or bool(re.search(r'near copy, ratio 0\.[0-8]|next (0\.9|1\.0)|\(([0-9]|1[0-5]) instructions\)', basis))
rows = []; cnt = collections.Counter()
for r in KN:
    o = fl(int(r['bank'], 16), int(r['addr'], 16)); i = bisect.bisect_right(ko, o)
    e = min(ko[i] if i < len(ko) else len(K), (o // 0x4000 + 1) * 0x4000)
    cp = code.get(o)
    if cp is None and r['source'] in ('data', 'data_left') or (cp is None and e - o >= 16):
        blk = K[o:e]
        if e - o >= 16 and len(set(blk)) > 1:
            j = J.find(blk)
            if j >= 0 and J.find(blk, j + 1) < 0:
                k = bisect.bisect_right(JO, j) - 1
                if k >= 0 and j // 0x4000 == JO[k] // 0x4000:
                    jb, ja = key(JO[k]); off = j - JO[k]
                    cp = (JN[JO[k]], '%02X:%04X' % (jb, ja) + ('+%X' % off if off else ''), 'data, the same %d bytes' % (e - o))
    if cp is None and o in KC: cp = near(o, e)
    if cp is None: rel = 'none'; cp = ('', '', '')
    elif norm(cp[0]) in (norm(r['name']), re.sub(r'^Leftover_[0-9A-F]{2}_[0-9A-F]{4}_', '', r['name'])) and '+' not in cp[1]: rel = 'same'
    elif noaddr(cp[0]) == noaddr(r['name']) and '+' not in cp[1]: rel = 'same_but_address'      # the same name, its own address in it
    elif noaddr(cp[0]).startswith(noaddr(r['name']) + '_'): rel = 'jp_adds_detail'          # the Japanese name says more (its use there)
    elif cp[2].startswith('code') and norm(r['name']) in JBYNAME:     # the match found a twin of the routine the Japanese ROM has under this very name
        jo = JBYNAME[norm(r['name'])]; jb, ja = key(jo)
        cp = (JN[jo], '%02X:%04X' % (jb, ja), 'the same name in the Japanese ROM; the code match (%s) points to its twin %s %s' % (cp[2], cp[0], cp[1])); rel = 'same'
    elif weak(cp[2]): rel = 'ambiguous'            # a match shared by several copies (twin routines) or under 16 bytes: maybe not the counterpart
    else: rel = 'differs'
    cnt[rel] += 1
    rows.append([r['bank'], r['addr'], r['name'], r['conf'], r['source'], rel, cp[0], cp[1], cp[2]])
with open(a.out, 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['bank', 'addr', 'name', 'tag', 'layer', 'relation', 'jp_name', 'jp_addr', 'basis']); w.writerows(rows)
by = collections.Counter((x[4], x[5]) for x in rows)
print('kitty_jp_counterparts: %d names: %s -> %s' % (len(rows), ', '.join('%s %d' % kv for kv in sorted(cnt.items())), os.path.relpath(a.out, REPO)))
for k in sorted(by): print('   %-16s %-8s %d' % (k + (by[k],)))
