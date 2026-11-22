#!/usr/bin/env python3
"""Gold L6 (2026-11-22): the Gold edition's own assets read and shown in play, by key presses only (no poke, no forced state).

  GBCOV_LIB=.../libgbcov_display.so tools/gold_own_assets_run.py GOLD.gb SAVE.sav [--out roms/gold/assets/gold_own_organic.csv]

SAVE: an unlocked save (tools/jp/make_synthetic_unlocked_save.py makes one in the core: 30 photos, every counter at its maximum); the
display-tracking core (tools/jp/gbcov_display.c) counts the ROM bytes read (organic) and the bytes on screen in 15 frames or more.
Two routes from the title, each from a fresh boot (403 free frames, as tools/port_l2_rest.py):
  * album B: A, Right, A (VIEW), A (the album grid), then the grid keys to album B pictures 6, 7 and 8 (wPhotoIndex $D5D8 = $23, $24, $25:
    Right x6 Down x2 Right / Right x8 Down x2 / Right x9 Down x2, found by a search of the grid), A (the picture, state 0A:03); and Right x16
    from the grid's first photo, through every page (the thumbnails, the slot table and the unlock gates of album B);
  * stamps: A, Select (STUDIO), A, A (the stamp tool on a photo, 11:01), A, Start (the palette, 11:03); for categories 2 and 3 every
    item of every page (the palette's own limits, Stamp_PaletteCursorTbl: 3 pages of 2 items), each picked (A) and stamped (A).
For each row of roms/gold/assets/gold_own_never_read.csv: bytes read, bytes on screen, and whether the bytes that stay unread are all $00.
"""
import sys, os, csv, argparse
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); sys.path.insert(0, os.path.join(HERE, 'jp'))
import numpy as np
import gbcov_display as g
ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('sav')
ap.add_argument('--out', default=os.path.join(REPO, 'roms', 'gold', 'assets', 'gold_own_organic.csv')); a = ap.parse_args()
g.load_rom(a.rom); ROM = open(a.rom, 'rb').read(); SAV = open(a.sav, 'rb').read()
import json
t = json.load(open(os.path.join(REPO, 'roms', 'gold', 'trace', 'trace_gold.json'))); K = np.zeros(1 << 20, np.uint8)
for k, n in t['code'].items():
    if n > 0:
        b, ad = k.split(':'); b = int(b, 16); ad = int(ad, 16); K[ad if b == 0 and ad < 0x4000 else b * 0x4000 + ad - 0x4000] = 1
g.set_known(K)
KEY = dict(R=g.RIGHT, L=g.LEFT, U=g.UP, D=g.DOWN, A=g.A, B=g.B, s=g.SELECT, S=g.START)
def press(k, wait=40): g.keys(KEY[k]); g.run(4); g.keys(0); g.run(wait)
def boot(): g.set_organic(1); g.reset(SAV); g.L.gb_attach_printer(0); g.run(250); g.run(403)
def cur(): return g.peek(0xD5CE), g.peek(0xD5CF)
def st(): return dict(cat=g.peek(0xD63D), page=g.peek(0xD63E), item=g.peek(0xD63F), focus=g.peek(0xD614))
log = []
# album B pictures 6-8
for tgt, keys in ((0x23, 'RRRRRRDDR'), (0x24, 'RRRRRRRRDD'), (0x25, 'RRRRRRRRRDD')):
    boot(); press('A', 60); press('R', 24); press('A', 200); press('A', 200)
    for k in keys: press(k)
    press('A', 400); log.append('album B $%02X: %02X:%02X, wPhotoIndex $%02X' % (tgt, *cur(), g.peek(0xD5D8)))
    if g.peek(0xD5D8) != tgt or cur() != (0x0A, 3): sys.exit('gold_own_assets_run: ' + log[-1])
boot(); press('A', 60); press('R', 24); press('A', 200); press('A', 200)            # the whole grid: Right through every page (the slot and gate tables)
for _ in range(16): press('R')
log.append('album grid: Right x16 -> wPhotoIndex $%02X' % g.peek(0xD5D8))
# stamp categories 2 and 3
boot(); press('A', 60); press('s', 90); press('A', 90); press('A', 90); press('A', 60); press('S', 60)
if cur() != (0x11, 3): sys.exit('gold_own_assets_run: the stamp palette was not reached (%02X:%02X)' % cur())
for c in (2, 3):
    n = 0
    while st()['focus'] == 0 and n < 8: press('R', 20); n += 1             # right until the category column (focus 1)
    n = 0
    while st()['cat'] != c and n < 20: press('U' if st()['cat'] > c else 'D', 20); n += 1
    press('L', 20); press('L', 20)
    for _ in range(12): press('U', 8)
    items = set()
    for p in range(20):
        for col in 'LR':
            press(col, 8)
            if st()['focus'] == 1: press('L', 8)
            it = st()['item']
            if it in items: continue
            items.add(it); snap = g.snapshot(); press('A', 30); press('A', 40); g.run(20); g.restore(snap)
        press('L', 8); before = st()['page']; press('D', 30)
        if st()['page'] == before: break
    log.append('stamp category %d: items %s' % (c, sorted(items)))
od, fr = g.org_dread(), g.disp_fro()
def fl(b, ad): return ad if b == 0 else b * 0x4000 + ad - 0x4000
rows = []
for r in csv.DictReader(open(os.path.join(REPO, 'roms', 'gold', 'assets', 'gold_own_never_read.csv'))):
    b, ad = r['gold_addr'].split(':'); o = fl(int(b, 16), int(ad, 16)); n = int(r['bytes'])
    rd = od[o:o + n] > 0; rest = bytes(ROM[o + i] for i in range(n) if not rd[i])
    rows.append([r['gold_addr'], n, r['name'], r['bytes_differing_from_intl'], int(rd.sum()), int((fr[o:o + n] >= 15).sum()),
                 'yes' if rest and set(rest) == {0} else ('' if not rest else 'no')])
with open(a.out, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n')
    w.writerow(['gold_addr', 'bytes', 'name', 'bytes_differing_from_intl', 'read_organic', 'on_screen_15_frames', 'unread_bytes_all_zero']); w.writerows(rows)
print('\n'.join(log)); print('gold_own_assets_run: %d rows -> %s' % (len(rows), a.out))
for r in rows: print('  %-42s %5d read %5d shown %5d  rest zero: %s' % (r[2], r[1], r[4], r[5], r[6]))
