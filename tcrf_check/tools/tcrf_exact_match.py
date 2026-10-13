#!/usr/bin/env python3
"""TCRF image -> ROM, exact, scale-aware (README 16.24). usage: GBCAM_ROM=rom.gb TCRF_DIR=dir tcrf_exact_match.py [image.png ...]  (a PNG of the TCRF zip is often a 2x enlargement: reduce it first). Palette hypotheses = monotone surjections colour(0..3) -> grey level (shaded renders fold colours),
tile flips H/V/HV, ALL byte offsets (data spans may start at odd addresses), sub-tile crops with wildcard padding, window clustering of per-tile hits."""
import sys, glob, itertools, collections
import numpy as np
from PIL import Image
ROM = open(__import__('os').environ.get('GBCAM_ROM', 'pocketcamera_jp.gb'), 'rb').read()
D = __import__('os').environ.get('TCRF_DIR', 'Unused graphics according to TCRF') + '/'
R = np.frombuffer(ROM, np.uint8); N = len(R) - 15
B = np.lib.stride_tricks.sliding_window_view(R, 16)
b0 = B[:, 0::2]; b1 = B[:, 1::2]
T = np.zeros((N, 8, 8), np.uint8)
for x in range(8): T[:, :, x] = (((b1 >> (7 - x)) & 1) << 1 | ((b0 >> (7 - x)) & 1))
def ba(o): return '%02X:%04X' % (o >> 14, 0x4000 + (o & 0x3FFF)) if o >> 14 else '00:%04X' % o
def hyps(k):
    out = []
    for f in itertools.product(range(k), repeat=4):
        if set(f) != set(range(k)): continue
        if all(f[i] <= f[i + 1] for i in range(3)) or all(f[i] >= f[i + 1] for i in range(3)): out.append(np.array(f, np.uint8))
    return out
def codes(L):  # L (n,8,8) levels -> (lo,hi) uint64
    rows = np.zeros((L.shape[0], 8), np.uint64)
    for x in range(8): rows |= L[:, :, x].astype(np.uint64) << np.uint64(2 * x)
    lo = np.zeros(L.shape[0], np.uint64); hi = np.zeros(L.shape[0], np.uint64)
    for y in range(4): lo |= rows[:, y] << np.uint64(16 * y); hi |= rows[:, y + 4] << np.uint64(16 * y)
    return lo, hi
def reduce_(a):
    h, w = a.shape
    for s in (4, 3, 2):
        if h % s == 0 and w % s == 0 and (np.repeat(np.repeat(a[::s, ::s], s, 0), s, 1) == a).all(): return a[::s, ::s], s
    return a, 1
def locate(path, minhits=0.5):
    a = np.array(Image.open(path).convert('L')); r, s = reduce_(a); h, w = r.shape
    lv = sorted(set(r.flatten().tolist())); li = np.vectorize({g: i for i, g in enumerate(lv)}.get)(r).astype(np.uint8)
    H8, W8 = (h + 7) // 8 * 8, (w + 7) // 8 * 8; ht, wt = H8 // 8, W8 // 8
    canvas = np.zeros((H8, W8), np.uint8); canvas[:h, :w] = li; wild = np.ones((H8, W8), bool); wild[:h, :w] = False
    # tile list: (i,j,levels8x8,wildmask)
    tl = [(i, j, canvas[i * 8:i * 8 + 8, j * 8:j * 8 + 8], wild[i * 8:i * 8 + 8, j * 8:j * 8 + 8]) for i in range(ht) for j in range(wt)]
    info = [k for k, t in enumerate(tl) if len(set(t[2][~t[3]].flatten().tolist())) > 1]
    res = []
    for f in hyps(len(lv)):
        Lr = f[T]  # (N,8,8) levels
        lo, hi = codes(Lr)
        hits = {}
        for k in info:
            t, m = tl[k][2], tl[k][3]
            pos = set()
            for fl in range(4):
                tt = t if fl == 0 else (t[:, ::-1] if fl == 1 else (t[::-1, :] if fl == 2 else t[::-1, ::-1]))
                mm = m if fl == 0 else (m[:, ::-1] if fl == 1 else (m[::-1, :] if fl == 2 else m[::-1, ::-1]))
                if mm.any():
                    sel = np.ones(N, bool)
                    for y in range(8):
                        for x in range(8):
                            if not mm[y, x]: sel &= (Lr[:, y, x] == tt[y, x])
                    p = np.nonzero(sel)[0]
                else:
                    a_, b_ = codes(tt[None])
                    p = np.nonzero((lo == a_[0]) & (hi == b_[0]))[0]
                pos.update(p.tolist())
            hits[k] = sorted(pos)
        cover = [k for k in info if hits[k]]
        if not cover: continue
        # window clustering
        W = max(384, 16 * len(tl) + 64)
        pairs = sorted((p, k) for k in cover for p in hits[k])
        best = (0, 0, None)
        j = 0; cnt = collections.Counter()
        for i, (p, k) in enumerate(pairs):
            cnt[k] += 1
            while pairs[j][0] < p - W:
                cnt[pairs[j][1]] -= 1
                if cnt[pairs[j][1]] == 0: del cnt[pairs[j][1]]
                j += 1
            if len(cnt) > best[0]: best = (len(cnt), p - W if p - W > 0 else 0, i)
        res.append((best[0], len(info), len(tl), f.tolist(), best, hits))
    res.sort(key=lambda x: -x[0])
    return s, (h, w), lv, res
if __name__ == '__main__':
    files = sorted(glob.glob(D + '*.png')) if len(sys.argv) < 2 else sys.argv[1:]
    for f in files:
        s, hw, lv, res = locate(f)
        print('%-60s scale %d reduced %s levels %s' % (f.split('/')[-1], s, hw, lv), flush=True)
        if not res: print('     no tile hit'); continue
        for nb, ni, nt, hp, best, hits in res[:2]:
            cnt, wstart, i = best
            W = max(384, 16 * nt + 64)
            print('     covers %d of %d informative tiles (%d tiles), hyp %s, window %s' % (nb, ni, nt, hp, ba(wstart)), flush=True)
            for k, ps in sorted(hits.items()):
                inw = [p for p in ps if wstart <= p <= wstart + 2 * W]
                print('        tile %2d (row %d col %d): %s%s' % (k, k // max(1, (hw[1] + 7) // 8), k % max(1, (hw[1] + 7) // 8), ' '.join(ba(p) for p in inw[:6]), ' ...' if len(inw) > 6 else ''))
