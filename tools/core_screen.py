#!/usr/bin/env python3
"""The screen of a project-core state (coverage/src/gbcov.c and gbcov8.c: the same GB struct up to the I/O registers), drawn from its
VRAM, OAM and registers: background (SCX / SCY), window (WX / WY), objects (8x8 or 8x16, OBP0 / OBP1, flips, priority), DMG shades.
The core draws nothing itself; this is the picture its memory holds at the end of a frame. A full-screen picture needs more than the
256 tiles one tile-data area gives the background: the games switch LCDC bit 4 at a line (Hello Kitty: Stat_TileToggle at line $4F),
so with the end-of-frame registers alone the lines after the switch are drawn from the wrong area. Pass `lines` (154 x 6 bytes: the
LCDC, SCY, SCX, BGP, WY, WX each line ended with; coverage/src/gbcov8.c gb_line_regs_ptr) to draw every line with the registers
it started with.

  import core_screen; img = core_screen.render(state_bytes[, lines])      # PIL image 160 x 144, grey levels
"""
import numpy as np
from PIL import Image
VRAM, OAM = 24, 24 + 0x4000                       # a,f,b,c,d,e,h,l, sp, pc, ime, ei_delay, halted, stopped, cycles (u64); vram, wram, oam, hram, io
IO = OAM + 0xA0 + 0x80
SHADE = np.array([255, 170, 85, 0], np.uint8)
def _tile(v, n):
    t = np.zeros((8, 8), np.uint8)
    for y in range(8):
        lo, hi = v[n * 16 + 2 * y], v[n * 16 + 2 * y + 1]
        for x in range(8): t[y, x] = ((lo >> (7 - x)) & 1) | (((hi >> (7 - x)) & 1) << 1)
    return t
def _pal(p): return [(p >> (2 * i)) & 3 for i in range(4)]
def render(st, lines=None):
    v = st[VRAM:VRAM + 0x2000]; oam = st[OAM:OAM + 0xA0]; io = st[IO:IO + 0x80]
    lcdc, obp0, obp1 = io[0x40], io[0x48], io[0x49]
    # a line is drawn with the registers it started with (those the line before ended with): a write made by a LYC handler lands
    # during the line it was asked for, after most of it is drawn
    LR = [tuple(lines[6 * ((y - 1) % 154) + k] for k in range(6)) if lines is not None else
          (io[0x40], io[0x42], io[0x43], io[0x47], io[0x4A], io[0x4B]) for y in range(144)]
    img = np.zeros((144, 160), np.uint8); raw = np.zeros((144, 160), np.uint8)
    if not lcdc & 0x80: return Image.fromarray(np.full((144, 160), 255, np.uint8))
    cache = {}
    def bgtile(code, lc):
        n = code if lc & 0x10 else (256 + (code if code < 128 else code - 256))
        if n not in cache: cache[n] = _tile(v, n)
        return cache[n]
    wline = 0
    for y in range(144):
        lc, scy, scx, bgp, wy, wx = LR[y]; bp = _pal(bgp)
        if not lc & 0x01: continue
        base = 0x1C00 if lc & 0x08 else 0x1800; yy = (y + scy) & 255
        for x in range(160):
            xx = (x + scx) & 255; c = bgtile(v[base + (yy >> 3) * 32 + (xx >> 3)], lc)[yy & 7, xx & 7]; raw[y, x] = c; img[y, x] = bp[c]
        if lc & 0x20 and wx <= 166 and wy <= y:
            base = 0x1C00 if lc & 0x40 else 0x1800; yy = wline; wline += 1
            for x in range(max(0, wx - 7), 160):
                xx = x - (wx - 7); c = bgtile(v[base + (yy >> 3) * 32 + (xx >> 3)], lc)[yy & 7, xx & 7]; raw[y, x] = c; img[y, x] = bp[c]
    if lcdc & 0x02:
        h = 16 if lcdc & 0x04 else 8
        for i in reversed(range(40)):
            oy, ox, tn, fl = oam[4 * i] - 16, oam[4 * i + 1] - 8, oam[4 * i + 2], oam[4 * i + 3]
            if h == 16: tn &= 0xFE
            t = np.vstack([_tile(v, tn), _tile(v, tn + 1)]) if h == 16 else _tile(v, tn)
            if fl & 0x20: t = t[:, ::-1]
            if fl & 0x40: t = t[::-1, :]
            op = _pal(obp1 if fl & 0x10 else obp0)
            for y in range(h):
                for x in range(8):
                    py, px = oy + y, ox + x
                    if 0 <= py < 144 and 0 <= px < 160 and t[y, x] and not (fl & 0x80 and raw[py, px]): img[py, px] = op[t[y, x]]
    return Image.fromarray(SHADE[img])
