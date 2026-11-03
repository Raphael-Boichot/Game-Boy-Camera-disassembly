#!/usr/bin/env python3
"""Seam search for a de-duplicated tile map over EVERY BYTE OFFSET of the ROM, in four layouts that tile_seam_search.py does not try.
tile_seam_search.py only looks at 16-aligned offsets and puts tile id i at S + 16 (i - LO).  This tool also takes
  asc   tile id v at S + t (v - LO)            (t = 16 bytes for 2bpp, 8 for 1bpp; S may be ANY byte offset, assets such as 1A:5182 start at odd addresses)
  desc  tile id v at S + t (HI - v)            (ids numbered in descending raster order, README 16.25.2)
  rot   tile id v at S + t ((v - $80) & $FF)   (the $8800 signed-id addressing of the LCDC tile-data bit: ids 80-FF first, then 00-7F; 2bpp, whole map only)
For each variant the score of an offset is the sum of absolute pixel differences over the seams of the map (right column of a cell against the left column of its
right neighbour, bottom row against the top row of the cell below; every distinct pair of ids once) divided by 8 x the number of seams.  An offset only counts when
>= 97 % of the used tiles are different from each other (a de-duplicated set has no repeated tile; flat or constant data would score 0 otherwise).  The control shuffles
the ids of the map (5 seeds) and takes the best score under the same filter: a true set must be far below it.  Reference (README 16.25.2): the true blocks of the two
known maps give a ratio best/control of 0.33-0.37 with tile_seam_search.py.
usage:  tile_seam_offsets.py ROM BANK:ADDR --ids LO-HI [--desc | --rot] [--bpp 1|2] [--shuffle N] [--top K] [--sym FILE.sym]
        tile_seam_offsets.py ROM BANK:ADDR --all OUT.csv        (the 13 variants of README 16.25.2, one CSV row each, 3-5 minutes)
        tile_seam_offsets.py ROM BANK:ADDR --render OUT.png [d|r]BANK:ADDR[/LO-HI][|label] ...   (draw the map with the tile set at those places, 2x)"""
import sys, csv
import numpy as np

def load_sym(path):
    out = {}
    for line in open(path):
        p = line.split()
        if len(p) == 2 and ':' in p[0] and not p[1].startswith('.'):
            b, a = [int(x, 16) for x in p[0].split(':')]; out.setdefault(b, []).append((a, p[1]))
    for b in out: out[b].sort()
    return out

def sym_at(sym, b, a):
    best = None
    for x, nm in sym.get(b, []):
        if x <= a: best = (x, nm)
        else: break
    return '%s+%d' % (best[1], a - best[0]) if best else '?'

class Seam:
    def __init__(self, rom, bank, addr):
        self.rom = np.frombuffer(rom, dtype=np.uint8); self.n = len(self.rom)
        o = bank * 0x4000 + addr - 0x4000 if bank else addr
        self.G = self.rom[o:o + 32 * 18].reshape(18, 32)[:, :20].astype(int)
        r = self.rom.astype(np.int16); n = self.n; pad = np.concatenate([r, np.zeros(32, np.int16)])
        self.padu = np.concatenate([self.rom, np.zeros(32, np.uint8)]).astype(np.uint64)
        self.e = {}
        for bpp in (1, 2):
            if bpp == 2:
                L = np.stack([((pad[2 * y + 1:2 * y + 1 + n] >> 7) & 1) * 2 + ((pad[2 * y:2 * y + n] >> 7) & 1) for y in range(8)])
                R = np.stack([(pad[2 * y + 1:2 * y + 1 + n] & 1) * 2 + (pad[2 * y:2 * y + n] & 1) for y in range(8)])
                T = np.stack([((pad[1:1 + n] >> (7 - x)) & 1) * 2 + ((pad[0:n] >> (7 - x)) & 1) for x in range(8)])
                B = np.stack([((pad[15:15 + n] >> (7 - x)) & 1) * 2 + ((pad[14:14 + n] >> (7 - x)) & 1) for x in range(8)])
            else:
                L = np.stack([(pad[y:y + n] >> 7) & 1 for y in range(8)]); R = np.stack([pad[y:y + n] & 1 for y in range(8)])
                T = np.stack([(pad[0:n] >> (7 - x)) & 1 for x in range(8)]); B = np.stack([(pad[7:7 + n] >> (7 - x)) & 1 for x in range(8)])
            self.e[bpp] = tuple(a.astype(np.int8) for a in (L, R, T, B))

    def pairs(self, grid, lo, hi):
        H = set(); V = set()
        for y in range(18):
            for x in range(20):
                v = int(grid[y, x])
                if not lo <= v <= hi: continue
                if x + 1 < 20 and lo <= grid[y, x + 1] <= hi: H.add((v, int(grid[y, x + 1])))
                if y + 1 < 18 and lo <= grid[y + 1, x] <= hi: V.add((v, int(grid[y + 1, x])))
        return sorted(H), sorted(V)

    def run(self, lo, hi, order, bpp, nshuf=5, top=4):
        t = 8 * bpp; n = self.n
        kf = {'asc': lambda v: v - lo, 'desc': lambda v: hi - v, 'rot': lambda v: (v - 0x80) & 0xFF}[order]
        span = (255 if order == 'rot' else hi - lo) * t; Ls = n - span - t
        L, R, T, B = self.e[bpp]
        def cost(H, V):
            acc = np.zeros(Ls, np.int32)
            for p, q in H:
                op, oq = t * kf(p), t * kf(q)
                for y in range(8): acc += np.abs(R[y, op:op + Ls] - L[y, oq:oq + Ls])
            for p, q in V:
                op, oq = t * kf(p), t * kf(q)
                for x in range(8): acc += np.abs(B[x, op:op + Ls] - T[x, oq:oq + Ls])
            return acc, (len(H) + len(V)) * 8
        ids = sorted(set(int(v) for v in self.G.ravel() if lo <= v <= hi))
        H, V = self.pairs(self.G, lo, hi); acc, den = cost(H, V)
        hh = np.zeros(n, np.uint64)
        for i in range(t): hh = hh * np.uint64(1000003) + self.padu[i:i + n]
        kk = np.array([kf(v) * t for v in ids]); ok = np.zeros(Ls, bool)
        for c0 in range(0, Ls, 20000):
            cc = np.arange(c0, min(Ls, c0 + 20000)); M = hh[cc[:, None] + kk[None, :]]; M.sort(axis=1)
            ok[c0:c0 + len(cc)] = (1 + (M[:, 1:] != M[:, :-1]).sum(axis=1)) / len(ids) >= 0.97
        g = np.where(ok, acc, 1 << 30); best = np.argsort(g)[:top]
        rng = np.random.default_rng(1); cs = []
        for _ in range(nshuf):
            sh = ids[:]; rng.shuffle(sh); pm = dict(zip(ids, sh))
            G2 = np.vectorize(lambda v: pm.get(int(v), int(v)))(self.G); H2, V2 = self.pairs(G2, lo, hi); a2, d2 = cost(H2, V2)
            cs.append(np.where(ok, a2, 1 << 30).min() / d2)
        return dict(ids=len(ids), seams=len(H) + len(V), ok=int(ok.sum()), top=[(int(s), g[s] / den) for s in best],
                    ctrl_min=min(cs) if cs else float('nan'), ctrl_med=float(np.median(cs)) if cs else float('nan'), ctrl_max=max(cs) if cs else float('nan'))

    def render(self, S, order, lo, hi, bpp=2, zoom=2):
        from PIL import Image
        t = 8 * bpp; im = Image.new('L', (160, 144), 255); rom = self.rom
        kf = {'asc': lambda v: v - lo, 'desc': lambda v: hi - v, 'rot': lambda v: (v - 0x80) & 0xFF}[order]
        for y in range(18):
            for x in range(20):
                off = S + t * kf(int(self.G[y, x]))
                for yy in range(8):
                    if off + t > len(rom): continue
                    if bpp == 2: lo_b, hi_b = int(rom[off + 2 * yy]), int(rom[off + 2 * yy + 1])
                    else: lo_b = hi_b = int(rom[off + yy])
                    for xx in range(8):
                        im.putpixel((x * 8 + xx, y * 8 + yy), [255, 170, 85, 0][((hi_b >> (7 - xx)) & 1) * 2 + ((lo_b >> (7 - xx)) & 1)] if bpp == 2 else 255 * (1 - ((lo_b >> (7 - xx)) & 1)))
        return im.resize((160 * zoom, 144 * zoom), Image.NEAREST)

def where(s):
    b = s // 0x4000; return b, s % 0x4000 + (0x4000 if b else 0)

# the 13 variants: (label, lo, hi, order, bpp)
VARIANTS = [('whole', 0x00, 0xF5, o, 2) for o in ('asc', 'desc', 'rot')] + [('whole', 0x00, 0xF5, o, 1) for o in ('asc', 'desc')] + \
           [('picture', 0x24, 0xDA, o, b) for b in (2, 1) for o in ('asc', 'desc')] + \
           [('strip', 0x00, 0x23, o, 2) for o in ('asc', 'desc')] + [('small blocks', 0xDB, 0xF5, o, 2) for o in ('asc', 'desc')]

if __name__ == '__main__':
    a = sys.argv[1:]
    rom = open(a[0], 'rb').read(); bank, addr = [int(x, 16) for x in a[1].split(':')]
    S = Seam(rom, bank, addr)
    sym = load_sym(a[a.index('--sym') + 1]) if '--sym' in a else None
    def label(s):
        b, ad = where(s); return '%02X:%04X' % (b, ad) + (' (%s)' % sym_at(sym, b, ad) if sym else '')
    if '--all' in a:
        out = a[a.index('--all') + 1]; rows = []
        for (nm, lo, hi, order, bpp) in VARIANTS:
            r = S.run(lo, hi, order, bpp)
            s0, c0 = r['top'][0]; b, ad = where(s0)
            rows.append(dict(block=nm, ids='%02X-%02X' % (lo, hi), order=order, bpp=bpp, used_ids=r['ids'], seams=r['seams'], distinct_offsets=r['ok'],
                             best_addr='%02X:%04X' % (b, ad), best_cost='%.3f' % c0, control_min='%.3f' % r['ctrl_min'], control_median='%.3f' % r['ctrl_med'],
                             control_max='%.3f' % r['ctrl_max'], ratio_best_over_control_median='%.2f' % (c0 / r['ctrl_med'])))
            print(rows[-1], flush=True)
        with open(out, 'w', newline='') as f:
            w = csv.DictWriter(f, fieldnames=list(rows[0])); w.writeheader(); w.writerows(rows)
    elif '--render' in a:
        from PIL import Image, ImageDraw
        k = a.index('--render'); ims = []
        for c in a[k + 2:]:
            c, _, lab = c.partition('|')
            order = {'d': 'desc', 'r': 'rot'}.get(c[0], 'asc'); c = c.lstrip('dr')
            rng_ = (0x00, 0xF5)
            if '/' in c: c, rg = c.split('/'); rng_ = tuple(int(x, 16) for x in rg.split('-'))
            b, ad = [int(x, 16) for x in c.split(':')]
            im = S.render(b * 0x4000 + ad - 0x4000 if b else ad, order, rng_[0], rng_[1])
            if lab:
                strip = Image.new('L', (im.width, 14), 255); ImageDraw.Draw(strip).text((2, 1), lab, fill=0)
                full = Image.new('L', (im.width, im.height + 14), 255); full.paste(strip, (0, 0)); full.paste(im, (0, 14)); im = full
            ims.append(im)
        W = sum(i.width for i in ims) + 8 * (len(ims) - 1); o = Image.new('L', (W, max(i.height for i in ims)), 128); x = 0
        for i in ims: o.paste(i, (x, 0)); x += i.width + 8
        o.save(a[k + 1])
    else:
        lo, hi = [int(x, 16) for x in a[a.index('--ids') + 1].split('-')]
        order = 'desc' if '--desc' in a else 'rot' if '--rot' in a else 'asc'
        bpp = int(a[a.index('--bpp') + 1]) if '--bpp' in a else 2
        r = S.run(lo, hi, order, bpp, int(a[a.index('--shuffle') + 1]) if '--shuffle' in a else 5, int(a[a.index('--top') + 1]) if '--top' in a else 4)
        print('ids %02X-%02X %s %dbpp: %d ids, %d seams, %d offsets with >= 97%% distinct tiles' % (lo, hi, order, bpp, r['ids'], r['seams'], r['ok']))
        for s, c in r['top']: print('  S=%s  cost %.3f per pixel' % (label(s), c))
        print('  controls (ids shuffled, same filter): min %.3f median %.3f max %.3f' % (r['ctrl_min'], r['ctrl_med'], r['ctrl_max']))
