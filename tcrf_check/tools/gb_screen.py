#!/usr/bin/env python3
"""A small Game Boy picture renderer for checks and animations: background + 8 x 8 / 8 x 16 sprites from a VRAM dump, an OAM dump and the LCD registers (no window, no mid-frame changes), shades 0-3.
render(vram, oam, lcdc, scx, scy, bgp, obp0, obp1) -> a 144 x 160 array of shades (0 = lightest).  Checked against BGB screenshots of the main menu (menu_screen_gif.py --check).
Tile data: LCDC bit 4 = 1: ids 0-255 at $8000; 0: ids 0-127 at $9000 and 128-255 at $8800.  Sprites always use $8000.  Sprite priority: lower X wins, then lower OAM index; 10 sprites per line; OAM bit 7 = behind BG colours 1-3."""
import numpy as np

def tile_px(vram, off):
    t = np.zeros((8, 8), np.uint8)
    for y in range(8):
        lo, hi = vram[off + 2 * y], vram[off + 2 * y + 1]
        for x in range(8): t[y, x] = ((hi >> (7 - x)) & 1) * 2 + ((lo >> (7 - x)) & 1)
    return t

def shades(pal): return [(pal >> (2 * i)) & 3 for i in range(4)]

def render(vram, oam, lcdc, scx, scy, bgp, obp0, obp1, bgmap=None):
    vram = bytes(vram); bg = np.zeros((256, 256), np.uint8)
    mapbase = 0x1C00 if lcdc & 8 else 0x1800
    cache = {}
    for r in range(32):
        for c in range(32):
            i = vram[mapbase + 32 * r + c] if bgmap is None else bgmap[r * 32 + c]
            if lcdc & 0x10: off = 16 * i
            else: off = 0x1000 + 16 * i if i < 128 else 0x800 + 16 * (i - 128)
            if off not in cache: cache[off] = tile_px(vram, off)
            bg[8 * r:8 * r + 8, 8 * c:8 * c + 8] = cache[off]
    ys = (np.arange(144) + scy) % 256; xs = (np.arange(160) + scx) % 256
    bgc = bg[np.ix_(ys, xs)]
    out = np.array(shades(bgp), np.uint8)[bgc] if lcdc & 1 else np.zeros((144, 160), np.uint8)
    if lcdc & 2:
        h = 16 if lcdc & 4 else 8
        spr = [(oam[4 * i] - 16, oam[4 * i + 1] - 8, oam[4 * i + 2], oam[4 * i + 3], i) for i in range(40)]
        for y in range(144):
            online = [s for s in spr if s[0] <= y < s[0] + h][:10]
            online.sort(key=lambda s: (s[1], s[4]))
            line = out[y]; done = np.zeros(160, bool)
            for sy, sx, tile, fl, _ in online:
                row = y - sy
                if fl & 0x40: row = h - 1 - row
                t = tile & 0xFE if h == 16 else tile
                tt = tile_px(vram, 16 * (t + (row >= 8)) if h == 16 else 16 * t)
                pr = tt[row & 7]; pal = shades(obp1 if fl & 0x10 else obp0)
                for x in range(8):
                    px = x if not fl & 0x20 else 7 - x; sxx = sx + x
                    if 0 <= sxx < 160 and pr[px] and not done[sxx]:
                        done[sxx] = True
                        if not (fl & 0x80 and bgc[y, sxx]): line[sxx] = pal[pr[px]]
    return out
