#!/usr/bin/env python3
"""The unused assets of the three retail ROMs, one sheet each in the style of the Hello Kitty and prototype sheets (tools/asset_sheet.py,
owner 2026-11-12): roms/<folder>/assets/unused_sheet_<tag>.png.

  tools/retail_unused_sheet.py --tag jp|us|gold ROM [--check]

The blocks are the REALLY unused assets of the Japanese ROM (roms/jp_rev_a/experiments/unidentified/really_unused.csv, docs §16.24: the TCRF
graphics, and the tiers 'no loader', 'never shown' and 'forced only'), found again in the international and Gold ROMs at the address of
roms/<folder>/assets/never_reached_<tag>.csv (rows 'same address' and 'moved'; the other rows are left out). The two unused screens are
drawn from their maps with their tile sets ($8000 addressing); the two maps without a known tile set as their byte values in grey.
The international and Gold sheets add the two Japanese blocks of the name font that their keyboard cannot type (2A:4000, code c at
+ (c - 1) x 32). The scraps and the sounds of the Japanese list are in its text (really_unused.md), not drawn.
"""
import argparse, csv, os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__))); import asset_sheet as A_
from asset_sheet import tiles, side
from PIL import Image
REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DIRS = {'jp': ('jp_rev_a', 'Pocket Camera (Japan) (Rev A)'), 'us': ('us_eu', 'Game Boy Camera (USA, Europe)'), 'gold': ('gold', 'Game Boy Camera Gold (USA)')}
ap = argparse.ArgumentParser(); ap.add_argument('--tag', required=True, choices=list(DIRS)); ap.add_argument('rom'); ap.add_argument('--check', action='store_true'); a = ap.parse_args()
R = open(a.rom, 'rb').read(); D, TITLE = DIRS[a.tag]
def fl(b, ad): return ad if b == 0 else b * 0x4000 + ad - 0x4000
def g(b, ad, n): return R[fl(b, ad):fl(b, ad) + n]
JPR = [r for r in csv.DictReader(open(os.path.join(REPO, 'roms', 'jp_rev_a', 'experiments', 'unidentified', 'really_unused.csv'), encoding='utf-8'))
       if r['tier'] in ('TCRF', 'no loader', 'never shown', 'forced only')]
where = {}
if a.tag != 'jp':
    for r in csv.DictReader(open(os.path.join(REPO, 'roms', D, 'assets', 'never_reached_%s.csv' % a.tag), encoding='utf-8')):
        st, ad = r['%s_status' % a.tag], r['%s_addr' % a.tag]
        if st in ('same address', 'moved') and ad: where[(r['jp_bank'], r['jp_addr'])] = (int(ad[:2], 16), int(ad[3:], 16))
def loc(bank, addr):
    k = (bank, addr)
    if a.tag == 'jp': return int(bank, 16), int(addr, 16)
    return where.get(k)
def screen(mb, ma, tb, ta):
    im = Image.new('L', (160, 144), 255)
    for r in range(18):
        for c in range(20): im.paste(A_.tile(g(tb, ta + R[fl(mb, ma) + r * 32 + c] * 16, 16)), (c * 8, r * 8))
    return im
def greymap(d):
    im = Image.new('L', (32, len(d) // 32)); im.putdata(list(d[:len(d) // 32 * 32])); return im.resize((128, len(d) // 32 * 4), Image.NEAREST)
def glyphs(codes):
    im = Image.new('L', (16 * 9, ((len(codes) + 15) // 16) * 17), 255)
    for i, c in enumerate(codes):
        o = fl(0x2A, 0x4000) + (c - 1) * 32
        im.paste(A_.tile(R[o:o + 16]), (i % 16 * 9, i // 16 * 17)); im.paste(A_.tile(R[o + 16:o + 32]), (i % 16 * 9, i // 16 * 17 + 8))
    return im
short = lambda n: n.replace('Unused_TCRF_', '').replace('_Gfx', '').replace('Gfx_', '')
tcrf, own = [], []
SCREENS = {('23', '5CC0'): ('14', '4000', 'the alternate stand-by screen of the image exchange'), ('25', '7820'): ('17', '5500', 'the one-page main menu with the "DEBA GAME" logo')}
SKIP = {('14', '4000'), ('14', '4554'), ('17', '5500')}          # tile sets drawn through their screens
for r in JPR:
    k = (r['bank'], r['addr'])
    if k in SKIP: continue
    L = loc(*k)
    if not L: continue
    b, ad = L; n = int(r['bytes']); adr = '%02X:%04X, %d B' % (b, ad, n) + ('' if (b, ad) == (int(k[0], 16), int(k[1], 16)) else ' (Japanese %s:%s)' % k)
    if k in SCREENS:
        tb, ta, cap = SCREENS[k]; T = loc(tb, ta)
        if not T: continue
        own.append(('no loader: %s' % cap, adr + ', tiles %02X:%04X' % T, screen(b, ad, T[0], T[1]))); continue
    if r['kind'] == 'Map':
        own.append(('%s: map, its tile set not drawn (bytes as grey)' % r['tier'], adr + ', ' + short(r['name']), greymap(g(b, ad, n)))); continue
    pic = tiles(g(b, ad, n // 16 * 16))
    (tcrf if r['tier'] == 'TCRF' else own).append((short(r['name']) if r['tier'] == 'TCRF' else '%s: %s' % (r['tier'], short(r['name'])), adr, pic))
if a.tag != 'jp':
    own.append(('name font: Japanese codes $01-$55 that the keyboard cannot type', '2A:4000 + (c - 1) x 32', glyphs(list(range(0x01, 0x56)))))
    own.append(('name font: the Japanese Latin block, codes $C9-$F5', '2A:4000 + (c - 1) x 32', glyphs(list(range(0xC9, 0xF6)))))
OUT = os.path.join(REPO, 'roms', D, 'assets', 'unused_sheet_%s.png' % a.tag)
sys.exit(A_.sheet('Unused assets, %s' % TITLE,
                  'Drawn from the ROM bytes x2 (16 tiles per row as stored): the REALLY unused assets of docs 16.24%s; scraps and sounds in roms/jp_rev_a/experiments/unidentified/really_unused.md.' % ('' if a.tag == 'jp' else ', found again in this ROM'),
                  [('Documented by TCRF (https://tcrf.net/Game_Boy_Camera)', A_.TCRF_COL, tcrf), ('Not documented by TCRF (found by this project)', A_.OWN_COL, own)],
                  OUT, a.check, 'retail_unused_sheet %s' % a.tag))
