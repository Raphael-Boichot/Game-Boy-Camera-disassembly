#!/usr/bin/env python3
"""TCRF "Print" (checklist C06): the printer ink-refill syringe of the Japanese ACCESS > PRINT menu is a Game Boy Printer in the international ROM.
The screen is mode $1B state 00 (Mode1B_State00_Init, 08:400A): background tiles 18:6470 (2 KB, ids $00-$7F at $9000) and 18:6C70 (2 KB, ids $80-$FF at $8800),
the map (20 x 18 cells, rows of 32 bytes) 25:7CA0 in the JP ROM (assets/copy_sites_jp.csv, Mode1B_State00_Init) and 25:7A60 in the international ROM (found by the render: it equals
the BGB capture); the icon is the 6 x 5 cells at map
rows 9-13, columns 1-6.  The ROM address of a cell's tile is exact here (id x 16 from the two bases), not a value match.
Writes the two background pictures (160 x 144, no sprites, BGP = identity) side by side with the icon cells boxed, and the cell table of both ROMs.
Optional: two BGB captures of mode $1B state 01 (bgb_capture_state.py, 160 x 144) are compared with the pictures (icon cells, whole background).
usage: printer_menu_icon.py JP.gb INTL.gb OUT.png OUT.csv [JP_BGB.bmp INTL_BGB.bmp]"""
import sys, csv
import numpy as np
from PIL import Image
jpf, itf, outpng, outcsv = sys.argv[1:5]; bgb = sys.argv[5:7]
def fo(bank, a): return bank * 0x4000 + (a - 0x4000) if bank else a
def tile(rom, o):
    t = np.zeros((8, 8), np.uint8)
    for y in range(8):
        lo, hi = rom[o + 2 * y], rom[o + 2 * y + 1]
        for x in range(8): t[y, x] = ((hi >> (7 - x)) & 1) * 2 + ((lo >> (7 - x)) & 1)
    return t
def tile_addr(i): return (0x18, 0x6470 + 16 * i) if i < 0x80 else (0x18, 0x6C70 + 16 * (i - 0x80))
pal = np.array([255, 190, 110, 20], np.uint8); S = 3
panels = []; rows = []
for k, (name, path, mapa) in enumerate((('JP', jpf, 0x7CA0), ('INTL', itf, 0x7A60))):
    rom = open(path, 'rb').read(); m = fo(0x25, mapa)
    pic = np.zeros((144, 160), np.uint8)
    for r in range(18):
        for c in range(20):
            i = rom[m + 32 * r + c]; b, a = tile_addr(i)
            pic[8 * r:8 * r + 8, 8 * c:8 * c + 8] = tile(rom, fo(b, a))
    if bgb:
        a = np.array(Image.open(bgb[k]).convert('L')); lv = sorted(set(a.ravel().tolist())); assert len(lv) == 4, lv
        q = np.vectorize({v: 3 - i for i, v in enumerate(lv)}.get)(a)
        print(name, 'BGB capture: icon cells (rows 9-13, columns 1-6) equal %d of %d pixels; whole background %d of %d (the rest: the sprites of the screen)' % ((q[72:112, 8:56] == pic[72:112, 8:56]).sum(), q[72:112, 8:56].size, (q == pic).sum(), q.size))
    img = np.kron(pal[pic], np.ones((S, S), np.uint8)); rgb = np.stack([img] * 3, -1)
    y0, y1, x0, x1 = 9 * 8 * S, 14 * 8 * S, 1 * 8 * S, 7 * 8 * S                       # the icon: rows 9-13, columns 1-6
    for t in (0, 1):
        rgb[y0 - t, x0:x1] = (220, 30, 30); rgb[y1 + t, x0:x1] = (220, 30, 30); rgb[y0:y1, x0 - t] = (220, 30, 30); rgb[y0:y1, x1 + t] = (220, 30, 30)
    panels.append(rgb)
    for r in range(9, 14):
        for c in range(1, 7):
            i = rom[m + 32 * r + c]; b, a = tile_addr(i)
            rows.append([name, r, c, '%02X' % i, '25:%04X' % (mapa + 32 * r + c), '%02X:%04X' % (b, a)])
sep = np.zeros((panels[0].shape[0], 6, 3), np.uint8); sep[:, :] = (230, 0, 230)
Image.fromarray(np.hstack([panels[0], sep, panels[1]])).save(outpng)
with open(outcsv, 'w', newline='') as f:
    w = csv.writer(f); w.writerow(['rom', 'map_row', 'map_col', 'tile_id', 'map_byte', 'tile_rom_address']); w.writerows(rows)
for name in ('JP', 'INTL'):
    r = [x for x in rows if x[0] == name]
    print(name, '30 cells,', len(set(x[3] for x in r)), 'distinct tile ids,', 'ROM addresses', min(x[5] for x in r), '-', max(x[5] for x in r))
print('cells whose tile id differs between the two ROMs:', sum(1 for a, b in zip([x for x in rows if x[0] == 'JP'], [x for x in rows if x[0] == 'INTL']) if a[3] != b[3]))
