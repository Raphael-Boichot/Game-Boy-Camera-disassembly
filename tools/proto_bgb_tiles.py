#!/usr/bin/env python3
"""The prototype: which VRAM tiles each screen draws, in BGB (roadmap step 12, 2026-11-15).

  tools/proto_bgb_tiles.py PROTO_BGB.gb [--work DIR]

The doubt on Unused_TCRF_ArrowCursor_TopRow_Gfx / _BottomRow_Gfx (02:42E1, 02:43E1): the sheet Gfx_02_4001_FNTOOE2 is copied to
VRAM $8000 with them (tiles $2E-$2F, $3E-$3F), so the L2 runs read their bytes; the question is whether any screen draws them.
Every screen of roms/prototype_debagame/screens/explore.csv is replayed in BGB along its key path (the paths of
tools/proto_bgb_screens.py, from a blank save), and the snapshot gives the tile maps, LCDC and OAM: the tile addresses the
visible background (LCDC bit 4: $8000 or $8800 addressing; bit 3: map $9800 / $9C00; the 20 x 18 cells under SCX / SCY), the window
(LCDC bit 5, WX / WY) and the sprites on screen (OAM entries with Y 1-159, X 1-167; 8 x 16 sprites when LCDC bit 2) use.
Writes roms/prototype_debagame/trace/bgb_tiles_proto.csv: screen, GAME_SEQ reached, LCDC, the number of BG / window / sprite
tiles in use, where the four arrow tiles are in VRAM (their 16-byte patterns, from the ROM) and whether any of those addresses is among
the tiles in use.
"""
import argparse, csv, hashlib, os, sys
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); sys.path.insert(0, os.path.join(HERE, 'jp'))
import bgb_run as B
ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('--work', default='/tmp/proto_bgb_tiles'); a = ap.parse_args()
if hashlib.md5(open(a.rom, 'rb').read()).hexdigest() != '1d8097de3497db8b182bcd2a984b6063': sys.exit('proto_bgb_tiles: expected the BGB copy (md5 1d8097de...)')
os.makedirs(a.work, exist_ok=True); blank = os.path.join(a.work, 'blank.sav'); open(blank, 'wb').write(bytes(0x20000))
T = [('A', 4, 90)]
def menu(i): return T + [('Down', 4, 20)] * i + [('A', 4, 120)]
SRAM = menu(0)
OFF = [('Down', 4, 20), ('Down', 4, 20), ('A', 4, 60), ('Down', 4, 20), ('A', 4, 60), ('B', 4, 60), ('Up', 4, 20), ('Up', 4, 20)]
SCREENS = [(0x01, []), (0x02, T), (0x04, SRAM), (0x05, SRAM + [('Down', 4, 20)] * 2 + [('A', 4, 120)]),       # the paths of tools/proto_bgb_screens.py
           (0x07, SRAM + [('Down', 4, 20)] * 2 + [('A', 4, 60), ('A', 4, 300)]), (0x08, SRAM + [('Down', 4, 20)] * 3 + [('A', 4, 120)]),
           (0x03, menu(1)), (0x0A, menu(2)), (0x06, menu(3)), (0x09, menu(3) + [('Start', 4, 120)]), (0x0C, menu(3) + [('A', 30, 120)]),
           (0x0D, menu(4)), (0x0B, menu(5)), (0x07, T + OFF + [('A', 4, 60), ('Down', 4, 20), ('Down', 4, 20), ('A', 4, 60), ('A', 4, 300)])]
SHEET = open(a.rom, 'rb').read()[0x8001:0x9001]                                   # Gfx_02_4001_FNTOOE2: the arrow is its tiles $2E, $2F, $3E, $3F
PATS = [SHEET[16 * t:16 * t + 16] for t in (0x2E, 0x2F, 0x3E, 0x3F)]
def tiles(st):
    V = st['VRAM']; O = st['OAM']; L = st['LCDC'][0]; scx, scy = st['SCX'][0], st['SCY'][0]; wx, wy = st['WINX'][0], st['WINY'][0]
    def addr(t): return 0x8000 + 16 * t if L & 0x10 else 0x9000 + 16 * (t - 256 if t >= 128 else t)
    bg = set(); win = set(); spr = set()
    if L & 0x80 and L & 0x01:
        m = 0x1C00 if L & 0x08 else 0x1800
        for y in range(18):
            for x in range(20):
                for yy, xx in ((y * 8 + scy, x * 8 + scx), (y * 8 + 7 + scy, x * 8 + 7 + scx)):
                    bg.add(addr(V[m + ((yy // 8) % 32) * 32 + (xx // 8) % 32]))
        if L & 0x20 and wy < 144 and wx < 167:
            m = 0x1C00 if L & 0x40 else 0x1800
            for y in range((144 - wy + 7) // 8):
                for x in range((167 - wx + 7) // 8): win.add(addr(V[m + y * 32 + x]))
    if L & 0x80 and L & 0x02:
        for i in range(40):
            y, x, t = O[4 * i], O[4 * i + 1], O[4 * i + 2]
            if 0 < y < 160 and 0 < x < 168:
                if L & 0x04: spr.update({0x8000 + 16 * (t & 0xFE), 0x8000 + 16 * (t | 1)})
                else: spr.add(0x8000 + 16 * t)
    return L, bg, win, spr
rows = []
for n, (g, seq) in enumerate(SCREENS):
    r = B.run(a.rom, blank, os.path.join(a.work, 's%02d' % n), seq, free=200)
    st = r['st']; got = st['WRAM'][0xA0] if 'WRAM' in st else None
    L, bg, win, spr = tiles(st)
    V = st['VRAM']; at = {0x8000 + i for i in range(0, 0x1800, 16) if V[i:i + 16] in PATS}
    hit = sorted('$%04X' % t for t in (bg | win | spr) & at)
    rows.append(['%02X' % g, '%02X' % got if got is not None else '', '%02X' % L, len(bg), len(win), len(spr), ' '.join('$%04X' % t for t in sorted(at)) or '-', ' '.join(hit) or '-'])
    print(rows[-1], flush=True)
out = os.path.join(REPO, 'roms', 'prototype_debagame', 'trace', 'bgb_tiles_proto.csv')
with open(out, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['screen', 'game_seq', 'lcdc', 'bg_tiles', 'window_tiles', 'sprite_tiles', 'arrow_tiles_in_vram', 'arrow_tiles_drawn']); w.writerows(rows)
print('proto_bgb_tiles: %d screens, %d draw an arrow tile -> %s' % (len(rows), sum(r[-1] != '-' for r in rows), os.path.relpath(out, REPO)))
