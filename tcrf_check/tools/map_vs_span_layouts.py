#!/usr/bin/env python3
"""Could a tile map be drawn with the tiles of a given ROM span?  Two checks for the span, whatever the layout it uses:
 (1) a de-duplicated map (every id a different tile, README 16.25.2) needs at least as many DIFFERENT tile contents as it has ids: counts the different, blank (all $00) and all-$FF tiles of the span;
 (2) the seam cost (README 16.25.2: sum of absolute pixel differences over the neighbouring cells, per pixel; a true set about 0.4, shuffled ids 1.0-1.3 on blank-rich data) of the natural layouts:
     contiguous ascending (id v at S + 16 v), contiguous descending (id v at S + 16 (HI - v)), and slots of PER tiles every STRIDE bytes (the sprite frames of 11:5800: 25 tiles every $200), both orders.
usage: map_vs_span_layouts.py ROM MAPBANK:ADDR SPANBANK:ADDR TILES [PER STRIDE] [--shuffle N]    e.g.  map_vs_span_layouts.py pocketcamera_jp.gb 26:7080 11:5800 276 25 512 --shuffle 100
Result (README 16.25.2): the hand-newspaper span 11:5800-693F (276 tiles, 130 different, 95 blank) cannot be the tile set of 26:7080 (245 different ids); the six layouts cost 0.76-1.10 per pixel."""
import sys, os
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import tile_seam_offsets as T

def span_stats(rom, base, ntiles):
    tiles = [bytes(rom[base + 16 * i: base + 16 * i + 16]) for i in range(ntiles)]
    return len(set(tiles)), sum(t == bytes(16) for t in tiles), sum(t == b'\xff' * 16 for t in tiles)

def layouts(base, hi, per, stride):
    d = {'contiguous ascending': lambda v: base + 16 * v, 'contiguous descending': lambda v: base + 16 * (hi - v)}
    if per:
        d['slots ascending'] = lambda v: base + stride * (v // per) + 16 * (v % per)
        d['slots descending'] = lambda v: base + stride * ((hi - v) // per) + 16 * ((hi - v) % per)
    return d

def costs(rom, mapbank, mapaddr, spanbank, spanaddr, ntiles, per=0, stride=0, nshuf=0):
    S = T.Seam(rom, mapbank, mapaddr); L, R, Tt, B = S.e[2]
    base = spanbank * 0x4000 + spanaddr - 0x4000
    ids = sorted(set(int(v) for v in S.G.ravel())); hi = max(ids)
    def cost(f, G):
        H, V = S.pairs(G, 0, 255); acc = 0
        for p, q in H: acc += np.abs(R[:, f(p)].astype(int) - L[:, f(q)].astype(int)).sum()
        for p, q in V: acc += np.abs(B[:, f(p)].astype(int) - Tt[:, f(q)].astype(int)).sum()
        return acc / (8 * (len(H) + len(V)))
    rng = np.random.default_rng(7); out = {}
    for name, f in layouts(base, hi, per, stride).items():
        c = cost(f, S.G); cs = []
        for _ in range(nshuf):
            sh = ids[:]; rng.shuffle(sh); pm = dict(zip(ids, sh)); cs.append(cost(f, np.vectorize(lambda v: pm[int(v)])(S.G)))
        out[name] = (c, min(cs) if cs else None, float(np.median(cs)) if cs else None)
    return len(ids), span_stats(S.rom, base, ntiles), out

if __name__ == '__main__':
    a = sys.argv[1:]; rom = open(a[0], 'rb').read()
    mb, ma = [int(x, 16) for x in a[1].split(':')]; sb, sa = [int(x, 16) for x in a[2].split(':')]
    pos = [x for x in a[3:] if not x.startswith('--')]
    nsh = int(a[a.index('--shuffle') + 1]) if '--shuffle' in a else 0
    if nsh: pos = [x for x in pos if x != str(nsh)]
    nt = int(pos[0]); per = int(pos[1]) if len(pos) > 1 else 0; stride = int(pos[2]) if len(pos) > 2 else 0
    nid, (dist, blank, ff), out = costs(rom, mb, ma, sb, sa, nt, per, stride, nsh)
    print('map has %d different ids; span %s has %d tiles: %d different, %d blank, %d all-FF' % (nid, a[2], nt, dist, blank, ff))
    for k, (c, mn, md) in out.items(): print('  %-24s cost %.3f%s' % (k, c, '   shuffled controls min %.3f median %.3f' % (mn, md) if mn is not None else ''))
