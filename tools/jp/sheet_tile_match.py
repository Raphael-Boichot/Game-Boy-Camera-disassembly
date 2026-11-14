#!/usr/bin/env python3
"""Find where the tiles of community sprite sheets (PNG) sit in the ROM: every 8 x 8 window of a sheet (all offsets, 4 flips, 2 shade orders) is turned into a 2bpp tile and looked up
in an index of the 16 bytes at every ROM offset.  usage: sheet_tile_match.py ROM OUT.json SHEET.png [SHEET.png ...]
Output per sheet: windows tested, windows found, distinct ROM offsets, and clusters (runs of matching tile offsets, gap <= 48 bytes) as bank:start-end with the number of matched tiles.
Grey pixels give the shade (>= 235 -> 0, 150-234 -> 1, 70-149 -> 2, < 70 -> 3); any coloured pixel (background) counts as shade 0 (transparent)."""
import sys, os, json, collections
import numpy as np
from PIL import Image
rom = open(sys.argv[1], 'rb').read(); N = len(rom)
idx = collections.defaultdict(list)
for o in range(N - 15): idx[rom[o:o + 16]].append(o)
def shades(path):
    im = Image.open(path).convert('RGBA'); a = np.array(im).astype(int); r, g, b, al = a[..., 0], a[..., 1], a[..., 2], a[..., 3]
    grey = (np.maximum(np.maximum(r, g), b) - np.minimum(np.minimum(r, g), b) <= 20) & (al > 0)
    L = (r + g + b) // 3; s = np.zeros(L.shape, np.uint8)
    s[grey & (L < 235)] = 1; s[grey & (L < 150)] = 2; s[grey & (L < 70)] = 3
    return s
def tilekeys(s):
    H, W = s.shape; out = {}
    lo = (s & 1).astype(np.uint8); hi = (s >> 1).astype(np.uint8)
    # byte for each (y, x0) = bits x0..x0+7 packed; build with shifts
    def pack(plane):
        P = np.zeros((H, W - 7), np.uint8)
        for k in range(8): P |= (plane[:, k:W - 7 + k] << (7 - k)).astype(np.uint8)
        return P
    PL, PH = pack(lo), pack(hi)
    return PL, PH
def bitrev(b): return int('{:08b}'.format(b)[::-1], 2)
REV = bytes(bitrev(i) for i in range(256))
def windows(s):
    H, W = s.shape; PL, PH = tilekeys(s); nz = (s > 0)
    res = []
    for y in range(H - 7):
        for x in range(W - 7):
            blk = s[y:y + 8, x:x + 8]
            if np.count_nonzero(blk) < 12 or len(np.unique(blk)) < 2: continue
            rows = [(PL[y + r, x], PH[y + r, x]) for r in range(8)]
            res.append(rows)
    return res
def key(rows, hf, vf, inv):
    rr = rows[::-1] if vf else rows; b = bytearray()
    for l, h in rr:
        if inv: l, h = (~l) & 255, (~h) & 255
        if hf: l, h = REV[l], REV[h]
        b += bytes((l, h))
    return bytes(b)
out = {}
for path in sys.argv[3:]:
    s = shades(path); wins = windows(s); hits = collections.Counter(); found = 0
    for rows in wins:
        hit = False
        for inv in (0, 1):
            for hf in (0, 1):
                for vf in (0, 1):
                    k = key(rows, hf, vf, inv)
                    if k in idx:
                        locs = idx[k]
                        if len(locs) <= 4:
                            hit = True
                            for o in locs: hits[(o, inv)] += 1
        found += hit
    # clusters per inversion mode
    res = dict(windows=len(wins), found=found, clusters=[])
    for inv in (0, 1):
        offs = sorted(o for (o, i) in hits if i == inv); cl = []
        for o in offs:
            if cl and o - cl[-1][1] <= 48: cl[-1][1] = o; cl[-1][2] += 1
            else: cl.append([o, o, 1])
        members = collections.defaultdict(list)
        for o in offs:
            for ci, (a, b, n) in enumerate(cl):
                if a <= o <= b: members[ci].append(o); break
        for ci, (a, b, n) in enumerate(cl):
            if n >= 6: res.setdefault('offsets', []).extend(members[ci])
            if n >= 6: res['clusters'].append(dict(inv=inv, start=a, end=b + 16, tiles=n, loc='%02X:%04X-%04X' % (a // 0x4000, (a % 0x4000) + (0x4000 if a >= 0x4000 else 0), ((b + 16 - 1) % 0x4000) + (0x4000 if a >= 0x4000 else 0))))
    out[os.path.basename(path)] = res
    print('%-70s windows %6d found %6d  clusters(>=6 tiles) %3d' % (os.path.basename(path)[27:], len(wins), found, len(res['clusters'])), flush=True)
json.dump(out, open(sys.argv[2], 'w'), indent=1)
