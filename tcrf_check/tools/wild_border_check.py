#!/usr/bin/env python3
"""Check the never-read tiles of a wild-frame sheet against a BGB printer capture.

usage: wild_border_check.py ROM ROM_MAP.csv K PAGES_DIR [ABLATED_PAGES_DIR]
  K          wild frame index 0-7 (sheet at 0xC4000 + K*0x1800, 384 tiles, 20 tiles per row in the print)
  PAGES_DIR  directory with page_01.png ... written by bgb_print_wild.py (printer capture of the real ROM)
  ABLATED_PAGES_DIR  optional capture of the same print with the never-read tiles overwritten by one fill byte
Reports: how many never-read tiles the printout reproduces (and how many have no twin elsewhere in
the sheet), and, with an ablated capture, which printed tile positions changed and which sheet tiles
they map to."""
import sys, os, glob
from PIL import Image
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from render_marked_tiles import load_classes


def load(d):
    ps = sorted(glob.glob(os.path.join(d, 'page_*.png')))
    ims = [Image.open(p).convert('L') for p in ps]
    H = sum(i.height for i in ims)
    img = Image.new('L', (160, H))
    y = 0
    for i in ims:
        img.paste(i, (0, y)); y += i.height
    return img


def tile_at(px, tx, ty):
    rows = []
    for yy in range(8):
        lo = hi = 0
        for xx in range(8):
            s = 3 - round(px[tx * 8 + xx, ty * 8 + yy] / 85)
            lo = (lo << 1) | (s & 1); hi = (hi << 1) | (s >> 1)
        rows += [lo, hi]
    return bytes(rows)


def main(a):
    rom = open(a[0], 'rb').read()
    cls = load_classes(a[1])
    k = int(a[2])
    base = 0xC4000 + k * 0x1800
    T = [rom[base + i * 16: base + i * 16 + 16] for i in range(384)]
    U = [i for i in range(384) if any(cls[base + i * 16 + j] == ord('U') for j in range(16))]
    img = load(a[3]); px = img.load(); rows = img.height // 8
    printed = {(tx, ty): tile_at(px, tx, ty) for ty in range(rows) for tx in range(20)}
    pset = set(printed.values())
    read = set(T[i] for i in range(384) if i not in U)
    uniq = [i for i in U if T[i] not in read]
    print('frame idx %d: sheet %#x, printout %dx%d tiles' % (k, base, 20, rows))
    print('  tiles with >=1 never-read byte: %d (sheet tiles %d-%d)' % (len(U), min(U) if U else -1, max(U) if U else -1))
    print('  of them reproduced exactly by the printout: %d' % sum(1 for i in U if T[i] in pset))
    print('  with no twin in the read part of the sheet: %d, reproduced: %d' % (len(uniq), sum(1 for i in uniq if T[i] in pset)))
    if len(a) > 4:
        ab = load(a[4]); apx = ab.load()
        if ab.height != img.height:
            print('  ablated capture has a different size', ab.size); return
        where = {}
        for i in range(384): where.setdefault(T[i], []).append(i)
        changed = []
        for pos, t in printed.items():
            if tile_at(apx, *pos) != t:
                changed.append(pos)
        print('  printed tiles changed by the ablation: %d' % len(changed))
        inU = [p for p in changed if any(i in U for i in where.get(printed[p], []))]
        print('  of which the baseline tile also exists in the never-read part: %d' % len(inU))
        notU = [p for p in changed if p not in inU]
        print('  changed but not matching any never-read tile (photo / other): %d' % len(notU))
        fills = {tile_at(apx, *p) for p in changed}
        print('  distinct tiles in the ablated printout at the changed positions: %d%s' % (len(fills), ' (the fill tile)' if len(fills) == 1 else ''))
        print('  changed positions (tx,ty):', sorted(changed)[:130])


if __name__ == '__main__':
    main(sys.argv[1:])
