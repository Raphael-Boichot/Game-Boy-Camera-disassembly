"""Tile provenance: which ROM spans hold the tiles that sit in a VRAM dump (BGB state)."""
import sys, os, collections, csv, bisect
ROOT = os.environ.get('GBCAM_ROOT', '/home/claude/gbcam_jp')   # the working root of README 16.15 (core, tools/lib.py, the ROM)
BGBX = os.environ.get('BGB_DIR', '/home/claude/bgbx')
import numpy as np
ROM = open(ROOT + '/pocketcamera_jp.gb', 'rb').read()
IDX = None
def build():
    global IDX
    if IDX is not None: return
    IDX = collections.defaultdict(list)
    for o in range(0, len(ROM) - 15):
        IDX[ROM[o:o + 16]].append(o)
def flat2ba(o): 
    b = o >> 14
    return (0, o) if b == 0 else (b, 0x4000 + (o & 0x3FFF))
def runs(vram, minlen=4, maxcand=40, base=0x8000):
    """returns list of (vram_tile_start, ntiles, flat_offset) maximal runs where consecutive VRAM tiles are consecutive 16-byte units of the ROM"""
    build()
    cand = []
    for t in range(384):
        tile = bytes(vram[t * 16:(t + 1) * 16])
        if tile == bytes(16) or tile == b'\xff' * 16: cand.append(set()); continue
        c = IDX.get(tile, [])
        cand.append(set(c) if len(c) <= maxcand else set())
    out = []; t = 0
    while t < 384:
        if not cand[t]: t += 1; continue
        # extend from every candidate, keep the longest
        best = (0, None)
        for s in cand[t]:
            n = 1
            while t + n < 384 and (s + 16 * n) in cand[t + n]: n += 1
            if n > best[0]: best = (n, s)
        n, s = best
        if n >= minlen: out.append((t, n, s)); t += n
        else: t += 1
    return out
if __name__ == '__main__':
    for f in sys.argv[1:]:
        v = open(f, 'rb').read()
        for t, n, s in runs(v):
            b, a = flat2ba(s)
            print('%s: VRAM %04X (%d tiles) <- %02X:%04X..%04X' % (os.path.basename(f), 0x8000 + t * 16, n, b, a, a + 16 * n - 1))
