#!/usr/bin/env python3
"""Address map from the Japanese ROM (Pocket Camera Rev A) to a sibling build (Game Boy Camera USA/Europe).

  tools/port_map.py JP.gb OTHER.gb [--trace roms/jp_rev_a/wram/trace_jp_v3.json] [--types roms/jp_rev_a/disasm/sym_types_jp.csv]
                    [--labels roms/jp_rev_a/pocketcamera_jp.sym] [--out roms/us_eu/port/map_segments_us.csv]

Method (per bank; a routine that moved to another bank is not followed, it shows as deleted + inserted):
  1. JP mask: the two operand bytes of every traced instruction with a 16-bit immediate (call / jp / ld rr,nn / ld [nn] ...)
     and every byte of a JP data row of width 2 (word tables) are wildcards: they hold addresses, which move between builds.
  2. Candidate shifts (other address - JP address): every JP code label whose masked bytes (first 48) occur exactly once in the
     same bank of the other ROM, and every 24-byte JP window (unique in its JP bank, >= 6 distinct values) found exactly once
     in the other bank. Shift 0 is always a candidate.
  3. Viterbi over the bank: each JP byte is either mapped with one candidate shift (cost 0 if equal or wildcard, 0.5 if the
     byte differs) or deleted; every inserted or deleted byte costs 0.3, a shift change 8, entering a deletion 4. A changed block
     of the same size therefore stays mapped (same structure, other content). The map keeps the order of both ROMs: a lower
     shift is reached only through a deletion at least as long as the drop.
  4. The segment after a deletion slides back over it while the bytes agree (the edge of a deletion is arbitrary between
     equal bytes); when the previous segment's last byte holds the target, a JP label start wins over a byte inside a block. A deletion facing an insertion of the same length between the same mapped neighbours is mapped 1:1 (a replaced block).
  5. Output: one row per segment of constant shift: bank, jp_start, jp_end, other_start, shift, same, wild, diff
     (byte counts) and, separately, the ranges of the other ROM that no JP byte maps to (inserted bytes).
  The map is checked to be strictly increasing (no two JP bytes on one byte of the other ROM, order kept).
"""
import argparse, json, csv, re, collections, os
import numpy as np

ap = argparse.ArgumentParser()
ap.add_argument('jp'); ap.add_argument('other')
ap.add_argument('--trace', default='roms/jp_rev_a/wram/trace_jp_v3.json')
ap.add_argument('--types', default='roms/jp_rev_a/disasm/sym_types_jp.csv')
ap.add_argument('--labels', default='roms/jp_rev_a/pocketcamera_jp.sym')
ap.add_argument('--out', default='roms/us_eu/port/map_segments_us.csv')
ap.add_argument('--inserted', default='roms/us_eu/port/map_inserted_us.csv')
ap.add_argument('--npz', default=None, help='also save the full per-byte map (numpy) here')
a = ap.parse_args()
JP = open(a.jp, 'rb').read(); OT = open(a.other, 'rb').read()
assert len(JP) == len(OT) == 0x100000
W16 = {0x01, 0x11, 0x21, 0x31, 0x08, 0xC2, 0xC3, 0xCA, 0xD2, 0xDA, 0xC4, 0xCC, 0xCD, 0xD4, 0xDC, 0xEA, 0xFA}
def off(b, ad): return ad if b == 0 else b * 0x4000 + ad - 0x4000
def base(b): return 0 if b == 0 else 0x4000
T = json.load(open(a.trace))['code']
wild = np.zeros(0x100000, bool); code_ins = collections.defaultdict(dict)
for k, n in T.items():
    b, ad = (int(x, 16) for x in k.split(':'))
    if n <= 0: continue
    code_ins[b][ad] = n
    o = off(b, ad)
    if JP[o] in W16 and n == 3: wild[o + 1:o + 3] = True
for r in csv.reader(open(a.types, encoding='utf-8')):
    if not r or r[0] in ('bank',) or r[0].startswith('#'): continue
    if r[3] == 'data' and r[4] == '2':
        b = int(r[0], 16); wild[off(b, int(r[1], 16)):off(b, int(r[2], 16))] = True
labels = collections.defaultdict(list)
for ln in open(a.labels):
    m = re.match(r'([0-9a-f]{2}):([0-9a-f]{4}) ([^.\s]\S*)', ln)
    if m: labels[int(m[1], 16)].append(int(m[2], 16))

def candidates(b):
    lo = b * 0x4000; hi = lo + 0x4000; jb = JP[lo:hi]; ob = OT[lo:hi]; wb = wild[lo:hi]
    sh = collections.Counter({0: 0})
    for ad in sorted(set(labels[b])):
        if ad not in code_ins[b]: continue
        i = ad - base(b); pat = []
        while i < 0x4000 and len(pat) < 48:
            pat.append(None if wb[i] else jb[i]); i += 1
        if sum(x is not None for x in pat) < 8: continue
        rx = re.compile(b''.join(b'.' if x is None else re.escape(bytes([x])) for x in pat), re.S)
        hits = [m.start() for m in rx.finditer(ob)]
        if len(hits) == 1: sh[hits[0] - (ad - base(b))] += 2
    cnt = collections.Counter(jb[i:i + 24] for i in range(0, 0x4000 - 24, 8))
    for i in range(0, 0x4000 - 24, 8):
        w = jb[i:i + 24]
        if wb[i:i + 24].any() or len(set(w)) < 6 or cnt[w] != 1: continue
        j = ob.find(w)
        if j >= 0 and ob.find(w, j + 1) < 0: sh[j - i] += 1
    return sorted(s for s, c in sh.items() if c >= 2 or s == 0)

MIS, GAP, SW, UD = 0.5, 0.3, 8.0, 4.0     # mismatch per byte, inserted / deleted byte, shift change, entering a deletion
def viterbi(b, shifts):
    """States: K shifts (sorted ascending) + K deletion states U_k (deleting after shift k, entered at position e_k).
    shift k -> shift k' directly only if s_k' > s_k (bytes inserted in the other ROM); a lower shift is reached only through
    U_k, and U_k -> k' at p is allowed only if p + s_k' > e_k - 1 + s_k (the other ROM's addresses keep increasing)."""
    lo = b * 0x4000; jb = np.frombuffer(JP[lo:lo + 0x4000], np.uint8); ob = np.frombuffer(OT[lo:lo + 0x4000], np.uint8)
    wb = wild[lo:lo + 0x4000]; n = 0x4000; K = len(shifts); INF = 1e9; S = np.array(shifts); lab_b = set(labels[b])
    C = np.full((n, K), INF, np.float64)
    for k, s in enumerate(shifts):
        p0 = max(0, -s); p1 = min(n, n - s)
        if p1 <= p0: continue
        eq = (jb[p0:p1] == ob[p0 + s:p1 + s]) | wb[p0:p1]
        C[p0:p1, k] = np.where(eq, 0.0, MIS)
    bpS = np.zeros((n, K), np.int32)     # previous state of shift k' (0..K-1 shift, K..2K-1 deletion)
    bpU = np.zeros((n, K), np.int32)     # previous state of U_k (k: stayed in U_k, else from shift k)
    E = np.zeros(K, np.int64)            # entry position of each U_k
    prevS = C[0].copy(); prevU = np.full(K, INF)
    lower = S[None, :] > S[:, None]      # lower[k,k'] : s_k' > s_k
    for p in range(1, n):
        # shift k' from shift k (k==k' stay; s_k' > s_k switch)
        m1 = np.where(lower, prevS[:, None] + SW + GAP * (S[None, :] - S[:, None]), INF); np.fill_diagonal(m1, prevS)
        # shift k' from U_k
        ok = (p + S[None, :]) > (E[:, None] - 1 + S[:, None])
        m2 = np.where(ok, prevU[:, None] + UD + GAP * ((p + S[None, :]) - (E[:, None] - 1 + S[:, None]) - 1), INF)
        m = np.vstack([m1, m2])                      # 2K x K
        src = np.argmin(m, axis=0); best = m[src, np.arange(K)]
        newS = best + C[p]
        # U_k: stay or enter from shift k
        enter = prevS + UD + GAP; stay = prevU + GAP
        newU = np.minimum(stay, enter)
        bpU[p] = np.where(stay <= enter, K, np.arange(K))
        E = np.where(stay <= enter, E, p)
        bpS[p] = src; prevS = newS; prevU = newU
    allc = np.concatenate([prevS, prevU]); st = int(np.argmin(allc)); path = np.empty(n, np.int32)
    for p in range(n - 1, -1, -1):
        path[p] = st
        if st < K: st = bpS[p, st]
        else:
            k = st - K; st = K + k if bpU[p, k] == K else k
    m = np.full(n, -1, np.int32)
    for k, s in enumerate(shifts):
        sel = path == k; m[sel] = np.nonzero(sel)[0] + s
    # the edges of a deletion are arbitrary when the bytes there are equal under two shifts: slide the mapped segment that follows a
    # deletion back over it while the bytes agree and the other ROM's addresses stay increasing
    p = 1
    while p < n:
        if m[p] >= 0 and m[p - 1] < 0:
            s = m[p] - p; q = p - 1
            prev = max([m[k] for k in range(max(0, q - 1), -1, -1) if m[k] >= 0][:1] or [-1])
            while q >= 0 and m[q] < 0 and 0 <= q + s and (jb[q] == ob[q + s] or wb[q]):
                if q + s > prev: m[q] = q + s; q -= 1; continue
                # blocked by the previous segment's last byte on the same target: a JP label start wins over a byte inside a block
                k = int(np.nonzero(m == q + s)[0][0]) if np.any(m == q + s) else -1
                if k >= 0 and (base(b) + q) in lab_b and (base(b) + k) not in lab_b:
                    m[k] = -1; m[q] = q + s; q -= 1
                    prev = max([m[j] for j in range(q, -1, -1) if m[j] >= 0][:1] or [-1])
                    continue
                break
        p += 1
    # a deletion facing an insertion of the same length between the same two mapped bytes is a replaced block: map it 1:1
    p = 0
    while p < n:
        if m[p] >= 0: p += 1; continue
        q = p
        while q < n and m[q] < 0: q += 1
        left = m[p - 1] if p > 0 else -1; right = m[q] if q < n else n
        if right - left - 1 == q - p: m[p:q] = np.arange(left + 1, right)
        p = q
    return m

segs = []; ins = []; full = np.full(0x100000, -1, np.int64); viol = 0
for b in range(64):
    sh = candidates(b); m = viterbi(b, sh)
    mm = m[m >= 0]
    if len(mm) > 1 and np.any(np.diff(mm) <= 0):
        viol += int(np.sum(np.diff(mm) <= 0)); print('bank %02X: map not increasing at %d places' % (b, int(np.sum(np.diff(mm) <= 0))))
    lo = b * 0x4000
    full[lo:lo + 0x4000] = np.where(m >= 0, m + lo, -1)
    p = 0
    while p < 0x4000:
        q = p
        if m[p] < 0:
            while q < 0x4000 and m[q] < 0: q += 1
            segs.append((b, base(b) + p, base(b) + q, '', 'del', 0, 0, 0)); p = q; continue
        s = m[p] - p
        while q < 0x4000 and m[q] >= 0 and m[q] - q == s: q += 1
        same = wl = diff = 0
        for i in range(p, q):
            if wild[lo + i]: wl += 1
            elif JP[lo + i] == OT[lo + i + s]: same += 1
            else: diff += 1
        segs.append((b, base(b) + p, base(b) + q, '%04x' % (base(b) + p + s), s, same, wl, diff)); p = q
    hit = np.zeros(0x4000, bool); hit[mm] = True
    i = 0
    while i < 0x4000:
        if hit[i]: i += 1; continue
        j = i
        while j < 0x4000 and not hit[j]: j += 1
        ins.append((b, base(b) + i, base(b) + j)); i = j
    print('bank %02X: %3d shifts, %3d segments, mapped %5d, inserted %5d' % (b, len(sh), sum(1 for x in segs if x[0] == b), int((m >= 0).sum()), int((~hit).sum())))
os.makedirs(os.path.dirname(a.out), exist_ok=True)
with open(a.out, 'w', newline='') as f:
    w = csv.writer(f); w.writerow(['bank', 'jp_start', 'jp_end', 'other_start', 'shift', 'same', 'wild', 'diff'])
    for r in segs: w.writerow(['%02x' % r[0], '%04x' % r[1], '%04x' % r[2], r[3], r[4], r[5], r[6], r[7]])
with open(a.inserted, 'w', newline='') as f:
    w = csv.writer(f); w.writerow(['bank', 'start', 'end'])
    for r in ins: w.writerow(['%02x' % r[0], '%04x' % r[1], '%04x' % r[2]])
if a.npz: np.save(a.npz, full)
tot = collections.Counter()
for r in segs:
    if r[4] == 'del': tot['deleted'] += r[2] - r[1]
    else: tot['same'] += r[5]; tot['wild'] += r[6]; tot['diff'] += r[7]
tot['inserted'] = sum(e - s for b, s, e in ins)
print(dict(tot), 'order violations', viol)
