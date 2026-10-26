#!/usr/bin/env python3
"""Why the main-menu camera ball head animation is stored twice (README 16.24, 16.25.2): frames F0-F4 (16:6980 + $200 j) and F5-F9 (16:7380 + $200 (j - 5)), 32 tiles each, copied to VRAM $9100 (ids $10-$2F).
The head block ($9100-$92FF) and the 80-tile body strip ($9200-$96FF, ids $20-$6F: 16:5580 / 5A80 / 5F80 / 6480 and 11:4000 / 4500 / 4A00, `MainMenu_LoadIconTilesB`, `MainMenu_SlideB_Step`) share the ids $20-$2F:
the lower row of the ball and the collar (BG rows 6 and 7 of the head).  LoadIconTilesB runs first, LoadIconTilesA (F0 / F4 / F9 by [$DA16]) second, so the head frame overwrites the first 16 tiles of the strip.
Prints (1) per pair F(j) / F(j+5) the tile ids that differ (everything above the collar is the same: the eye was drawn once and the collar twice), (2) for each body strip how many of the 8 + 8 collar tiles of
each frame equal the strip's own and the seam (sum of absolute pixel differences, 8 tiles = 64 px) between the collar's bottom pixel row and the strip's body row $30-$37: set A fits the front body 16:5580,
set B fits the back body 11:4000 (the strip's own collar gives the reference), (3) the copy sites of the head frames.
usage: head_sets.py ROM [--png COLLARS.png] [--pairs PAIRING.png]"""
import sys, os, csv
import numpy as np
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
def off(bank, addr): return bank * 0x4000 + addr - 0x4000
STRIPS = [('16:5580', 0x16, 0x5580), ('11:4000', 0x11, 0x4000), ('11:4500', 0x11, 0x4500), ('11:4A00', 0x11, 0x4A00)]

def frames(rom): h = off(0x16, 0x6980); return [rom[h + 512 * i:h + 512 * (i + 1)] for i in range(10)]
def strip(rom, b, a): o = off(b, a); return rom[o:o + 0x500]
def tile(b, i): return b[16 * i:16 * i + 16]
def px(t):
    a = np.zeros((8, 8), int)
    for y in range(8):
        lo, hi = t[2 * y], t[2 * y + 1]
        for x in range(8): a[y, x] = ((hi >> (7 - x)) & 1) * 2 + ((lo >> (7 - x)) & 1)
    return a

def pair_diffs(rom):
    """tile indices (id - $10) that differ between F(j) and F(j + 5), j = 0..4"""
    F = frames(rom); return [[t for t in range(32) if tile(F[j], t) != tile(F[j + 5], t)] for j in range(5)]

def seam(collar_row7, body_row):
    """sum of |pixel differences| between the bottom pixel row of 8 collar tiles and the top pixel row of the 8 body tiles below them"""
    return sum(int(np.abs(px(collar_row7[k])[7, :] - px(body_row[k])[0, :]).sum()) for k in range(8))

def vs_strip(rom, b, a):
    """for one strip: per frame (tiles of ids $20-$27 equal to the strip's, tiles of ids $28-$2F equal, seam to the strip's body) and the strip's own seam"""
    F = frames(rom); s = strip(rom, b, a); body = [tile(s, 16 + k) for k in range(8)]
    out = []
    for f in F:
        r6 = sum(tile(s, i) == tile(f, 16 + i) for i in range(8)); r7 = sum(tile(s, 8 + i) == tile(f, 24 + i) for i in range(8))
        out.append((r6, r7, seam([tile(f, 24 + k) for k in range(8)], body)))
    own = seam([tile(s, 8 + k) for k in range(8)], body)
    return out, own

def result(rom, strip_, frame_):
    """the VRAM ids $10-$6F after LoadIconTilesB(strip) and LoadIconTilesA(frame), as a dict id -> 16 bytes"""
    v = {}
    for i in range(80): v[0x20 + i] = tile(strip_, i)
    for i in range(32): v[0x10 + i] = tile(frame_, i)
    return v

CM = {3: {8: 0x10, 9: 0x11, 10: 0x12, 11: 0x13}, 4: {7 + k: 0x14 + k for k in range(6)}, 5: {7 + k: 0x1A + k for k in range(6)}}
for r, base in zip(range(6, 12), (0x20, 0x28, 0x30, 0x38, 0x40, 0x48)): CM[r] = {6 + k: base + k for k in range(8)}
for r, base in ((12, 0x50), (13, 0x58)): CM[r] = {6 + k: base + k for k in range(8)}
CM[14] = {6 + k: 0x60 + k for k in range(7)}; CM[15] = {7 + k: 0x67 + k for k in range(5)}; CM[16] = {8 + k: 0x6C + k for k in range(4)}   # the central column of the upper-page map 26:5A00 (BGB)

def tile_img(b):
    from PIL import Image
    im = Image.new('L', (8, 8), 255)
    for y in range(8):
        lo, hi = b[2 * y], b[2 * y + 1]
        for x in range(8): im.putpixel((x, y), [255, 170, 85, 0][((hi >> (7 - x)) & 1) * 2 + ((lo >> (7 - x)) & 1)])
    return im
def column_img(v, rows=range(3, 17)):
    from PIL import Image
    im = Image.new('L', (64, 8 * len(rows)), 230)
    for r in rows:
        for c, i in CM[r].items():
            if i in v: im.paste(tile_img(v[i]), ((c - 6) * 8, (r - rows[0]) * 8))
    return im

def collar_png(rom, out):
    """collar rows (BG rows 5-7) of F0-F4 (left) and F5-F9 (right)"""
    from PIL import Image
    F = frames(rom); sheet = Image.new('L', (136, 5 * 28), 128)
    for i in range(5):
        for x0, f in ((0, F[i]), (72, F[i + 5])): sheet.paste(column_img({0x10 + k: tile(f, k) for k in range(32)}, range(5, 8)), (x0, i * 28))
    sheet.resize((sheet.width * 5, sheet.height * 5), Image.NEAREST).save(out)

def pairs_png(rom, out):
    """the head and body as LoadIconTilesB(strip) then LoadIconTilesA(frame) leave them: rows = collar set A (F4) / set B (F9), columns = the strips 16:5580 / 11:4000 / 11:4A00"""
    from PIL import Image, ImageDraw
    F = frames(rom); S = [strip(rom, b, a) for n, b, a in STRIPS[:2] + STRIPS[3:]]
    W = 70; H = 8 * 14 + 4; sheet = Image.new('L', (3 * W + 40, 2 * H + 14), 255); d = ImageDraw.Draw(sheet)
    for c, (n, _, _) in enumerate(STRIPS[:2] + STRIPS[3:]): d.text((40 + c * W, 1), n, fill=0)
    for r, (lab, f) in enumerate((('A F4', F[4]), ('B F9', F[9]))):
        d.text((2, 14 + r * H + 50), lab, fill=0)
        for c, s in enumerate(S): sheet.paste(column_img(result(rom, s, f)), (40 + c * W, 14 + r * H))
    sheet.resize((sheet.width * 3, sheet.height * 3), Image.NEAREST).save(out)

if __name__ == '__main__':
    a = sys.argv[1:]; rom = open(a[0], 'rb').read()
    for j, x in enumerate(pair_diffs(rom)): print('F%d / F%d: %d of 32 tiles differ, ids %s' % (j, j + 5, len(x), ' '.join('%02X' % (0x10 + t) for t in x)))
    for n, b, ad in STRIPS:
        res, own = vs_strip(rom, b, ad)
        print('strip %s: own collar seam %2d | frames F0-F9 [ids $20-27 equal, ids $28-2F equal, seam]: %s' % (n, own, ' '.join('F%d[%d,%d,%d]' % (j, *r) for j, r in enumerate(res))))
    for r in csv.DictReader(open(os.path.join(ROOT, 'roms/jp_rev_a/assets/copy_sites_jp.csv'))):
        if r['src_bank'] == '16' and r['src'] in ('6980', '7180', '7B80'): print('copy site %s:%s %s loads 16:%s to %s' % (r['caller_bank'], r['call_addr'], r['caller_label'], r['src'], r['dst']))
    if '--png' in a: collar_png(rom, a[a.index('--png') + 1])
    if '--pairs' in a: pairs_png(rom, a[a.index('--pairs') + 1])
