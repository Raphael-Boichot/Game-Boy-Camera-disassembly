#!/usr/bin/env python3
"""Is a tile map a renumbered copy, or a variant, of any other map in a ROM?  Stronger than map_pattern_match.py:
 * ALL pairs of cells that hold the same id are compared (not only the right / lower neighbour), so the shape of every repeated tile counts;
 * the row stride of the window is a parameter (32 = the usual stored map, 20 / 22 / 24 = packed or album maps), the map may be in another ROM than the one searched;
 * a window is any byte offset of the searched ROM, whatever the tile numbers.
For the target (cols x rows cells, 20 x 18 by default) E_t = the set of cell pairs with the same id; for a window E_w is the same set read at p + stride * row + col, the score is the
Jaccard index |E_t & E_w| / |E_t | E_w| (1.00 = the same pattern up to a renumbering; a flat fill window has a huge E_w and scores low, a window that repeats other tiles in other places scores low).
usage: map_pattern_match2.py TARGET_ROM BANK:ADDR SEARCH_ROM [--strides 20,22,24,32] [--cols 20] [--rows 18] [--top 6]   (the target's own bytes are skipped when SEARCH_ROM is TARGET_ROM)
 e.g. map_pattern_match2.py pocketcamera_jp.gb 26:7080 gbcam_usa_eu.gb --strides 32   ->  26:6E40 (its counterpart) 1.000, nothing else above 0.13 (README 16.25.2); about 2 minutes per stride and ROM"""
import sys
import numpy as np

def search(rom, G, strides, skip_lo=None, skip_hi=None, top=6, chunk=4000):
    rows, cols = G.shape
    flat = G.ravel(); ids = np.unique(flat)
    classes = [np.nonzero(flat == v)[0] for v in ids]; classes = [c for c in classes if len(c) > 1]
    Et = sum(len(c) * (len(c) - 1) // 2 for c in classes)
    out = []
    for s in strides:
        offs = (np.arange(rows)[:, None] * s + np.arange(cols)[None, :]).ravel()
        N = len(rom); M = N - int(offs.max()) - 1
        romp = np.concatenate([rom, np.zeros(int(offs.max()) + 2, np.uint8)])
        best = np.zeros(M, np.float32)
        for c0 in range(0, M, chunk):
            p = np.arange(c0, min(M, c0 + chunk)); P = len(p)
            W = romp[p[:, None] + offs[None, :]]
            row = (np.arange(P)[:, None] * 256).astype(np.int64)
            H = np.bincount((row + W).ravel(), minlength=P * 256).reshape(P, 256).astype(np.int64)
            Ew = (H * (H - 1) // 2).sum(axis=1)
            inter = np.zeros(P, np.int64)
            for c in classes:
                Hk = np.bincount((row + W[:, c]).ravel(), minlength=P * 256).reshape(P, 256).astype(np.int64)
                inter += (Hk * (Hk - 1) // 2).sum(axis=1)
            best[c0:c0 + P] = inter / (Et + Ew - inter)
        if skip_lo is not None:
            best[max(0, skip_lo - 3 * s):min(M, skip_hi + 3 * s)] = 0
        order = np.argsort(-best)[:top * 8]
        got = []
        for q in order:
            if all(abs(int(q) - int(r[1])) > 2 * s for r in got): got.append((float(best[q]), int(q), s))
            if len(got) == top: break
        out += got
    return sorted(out, reverse=True), Et

def where(p):
    b = p >> 14; return '%02X:%04X' % (b, 0x4000 + (p & 0x3FFF) if b else p)

if __name__ == '__main__':
    a = sys.argv[1:]
    trom = np.frombuffer(open(a[0], 'rb').read(), dtype=np.uint8); srom = np.frombuffer(open(a[2], 'rb').read(), dtype=np.uint8)
    bank, addr = [int(x, 16) for x in a[1].split(':')]
    arg = lambda k, d: a[a.index(k) + 1] if k in a else d
    strides = [int(x) for x in arg('--strides', '20,22,24,32').split(',')]
    cols = int(arg('--cols', 20)); rows = int(arg('--rows', 18)); top = int(arg('--top', 6))
    o = bank * 0x4000 + addr - 0x4000
    G = trom[o:o + 32 * rows].reshape(rows, 32)[:, :cols].astype(int)
    same = a[0] == a[2]
    r, Et = search(srom, G, strides, o if same else None, o + 32 * rows if same else None, top)
    print('target %s: %d equal-id cell pairs in %d distinct ids; best windows of %s:' % (a[1], Et, len(np.unique(G)), a[2].split('/')[-1]))
    for j, p, s in r[:top]: print('  %s stride %2d  jaccard %.3f' % (where(p), s, j))
