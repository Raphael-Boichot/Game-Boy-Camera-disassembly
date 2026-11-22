#!/usr/bin/env python3
"""Hello Kitty L6 (2026-11-22): every stamp of the stamp window selected, page by page, by key presses only (owner, 2026-11-22: "On the
stamps window, just scroll the stamps pages to reach all of them").

  tools/kitty_stamp_sweep.py KITTY.gb [--out roms/hello_kitty/trace/cov_kitty_stamps.npz] [--report roms/hello_kitty/trace/stamp_sweep_kitty.csv]

The code (C, read in bank $05):
  * the window (mode $05 state $06, START): the cursor element is $D9A8; each page has a table of 8-byte elements (x, y, then the
    element reached by Left, Right, Up, Down; $F0 / $F1 = page - / +, $F8 / $F9 = scroll up / down, $FF = none; Stamp_CursorUpdate,
    05:5844), found through the page's 16-byte record ([$D9CA] -> $D9CE-$D9DD; the table pointer is its first word);
  * the page $D996 (0-7) picks an 8-byte entry of Mode02_StateTable + $16F (Stamp_SelectCategory, 05:5465): graphics offset, bank
    ($D9C6-$D9C8), the number of scroll rows ($D9C9), the page record ([$D9CA]) and the list of the four variants ([$D9CC]);
  * A on elements 0 / 1 cycles the variant $D997 (0-3): its entry ($D9DE-$D9E5) gives the mask offset and bank and two pointers of
    small tiles in bank $0D (Stamp_LoadSmallTiles);
  * A on a stamp (element 2 and up) selects it (05:59BE; the window closes, START opens it again with the cursor kept): stamp number
    n = row x ([$D9D4] / [$D9D6]) + element - 2, the row being $D998 + page; its graphics are [$D9D6] bytes at [$D9C6] + n x [$D9D6]
    of bank [$D9C8] (Stamp_LoadGfx), its mask half of that at [$D9DE] + n x [$D9D6] / 2 of bank [$D9E0] when that bank is neither $00
    nor $FF (Stamp_LoadMask): only page 7 has one (0D:6C00, 32 bytes a stamp).
The run: the formatted save (Kitts 999,999), a photo taken and kept, the album, its stamp icon (A A A A B - - Down A - Down A; the path
of tools/kitty_core_paths.py's stamps_page paths), START; then for each page (Down on element 0) every row (Down on a bottom
element, $F9) and on every row each stamp of the top row (each stamp of the bottom row too on the last row) is selected by A, START
opening the window again; then variants 1-3 (A on element 0), one stamp each. The keys are chosen from the state the game is in
(the element, the row, the page read in WRAM), like a player looking at the screen; every key is a press (8 frames held, 40 or 60
free), no poke. Output: the coverage (trace/cov_kitty_stamps.npz, merged with the other runs), the screen of each first read
(trace/read_screens_kitty_stamps.npz, tools/kitty_first_screens.py), and a report per page and variant (stamps selected, the ROM
ranges of their graphics and masks, bytes of them read).
"""
import sys, os, csv, argparse, collections
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); KD = os.path.join(REPO, 'roms', 'hello_kitty')
sys.path.insert(0, os.path.join(REPO, 'coverage', 'src')); sys.path.insert(0, HERE); import gbcov as G, kitty_first_screens
ap = argparse.ArgumentParser(); ap.add_argument('rom')
ap.add_argument('--out', default=os.path.join(KD, 'trace', 'cov_kitty_stamps.npz')); ap.add_argument('--report', default=os.path.join(KD, 'trace', 'stamp_sweep_kitty.csv'))
a = ap.parse_args(); R = open(a.rom, 'rb').read()
def fl(b, ad): return b * 0x4000 + ad - 0x4000
def w5(ad): return R[fl(5, ad)] | R[fl(5, ad) + 1] << 8
BIT = dict(A=1, B=2, Select=4, Start=8, Right=0x10, Left=0x20, Up=0x40, Down=0x80)
DIRS = ['Left', 'Right', 'Up', 'Down']                              # bytes 2-5 of an element (05:587A: e = 2, 3, 4, 5)
def cm(b): return ((b << 4) | (b >> 4)) & 0xFF
FS = kitty_first_screens.FirstScreens(1 << 20); NKEYS = [0]
def tap(k, w=40, hold=8):
    G.keys(cm(BIT[k])); G.run(hold); G.keys(0); G.run(w); NKEYS[0] += 1; FS.update(G.cov_dread(), G.peek(0xFF8D), G.peek(0xFF8E))
def page(): return G.peek(0xD996)
def row(): return G.peek(0xD998 + page())
def elem(): return G.peek(0xD9A8)
def is_open(): return G.peek(0xD993) & 1
def fail(msg): sys.exit('kitty_stamp_sweep: %s (page %d row %d element %d, mode %02X:%02X)' % (msg, page(), row(), elem(), G.peek(0xFF8D), G.peek(0xFF8E)))
# the eight page entries (Mode02_StateTable + $16F; 05:5425) and their records
TBL = 0x52B6 + 0x16F
PAGES = []
for p in range(8):
    e = R[fl(5, TBL + 8 * p):fl(5, TBL + 8 * p) + 8]
    rec = R[fl(5, w5(TBL + 8 * p + 4)):fl(5, w5(TBL + 8 * p + 4)) + 16]
    nav = rec[0] | rec[1] << 8; D4 = rec[6] | rec[7] << 8; D6 = rec[8] | rec[9] << 8
    var = [R[fl(5, w5(TBL + 8 * p + 6) + 8 * j):fl(5, w5(TBL + 8 * p + 6) + 8 * j) + 8] for j in range(4)]
    PAGES.append(dict(off=e[0] | e[1] << 8, bank=e[2], rows=e[3], nav=nav, D4=D4, D6=D6, var=var))
def node(p, i): return R[fl(5, PAGES[p]['nav'] + 8 * i):fl(5, PAGES[p]['nav'] + 8 * i) + 8]
def stamps_of(p):                                                   # the stamp elements: those reached from element 2 by plain moves
    seen = {2}; q = [2]
    while q:
        i = q.pop()
        for t in node(p, i)[2:6]:
            if 2 <= t < 0xF0 and t not in seen: seen.add(t); q.append(t)
    return sorted(seen)
def path(p, src, dst):
    prev = {src: None}; q = collections.deque([src])
    while q:
        i = q.popleft()
        if i == dst: break
        for d, t in zip(DIRS, node(p, i)[2:6]):
            if t < 0xF0 and t not in prev: prev[t] = (i, d); q.append(t)
    if dst not in prev: fail('no way from element %d to %d' % (src, dst))
    ks = []
    while prev[dst]: dst, d = prev[dst]; ks.append(d)
    return ks[::-1]
def goto(e):
    for _ in range(3):
        if elem() == e: return
        for k in path(page(), elem(), e): tap(k)
    if elem() != e: fail('element %d not reached' % e)
def reopen():
    for _ in range(5):
        if is_open(): return
        tap('Start', 60)
    fail('the window does not open')
# the run
G.load_rom(a.rom); G.reset(bytes(0x20000)); G.run(600); FMT = bytearray(bytes(G.sram()))
KITTS = bytes(FMT[:0x100A]) + b'\x99\x99\x99' + bytes(FMT[0x100D:])
G.load_rom(a.rom); G.reset(KITTS); G.L.gb_printer_model(1); G.L.gb_attach_printer(1); G.L.gb_cov_clear(); G.run(700)
for k in 'A A A A B - - Down A - Down A - - - -'.split():
    if k != '-': G.keys(cm(BIT[k]))
    G.run(8); G.keys(0); G.run(90)
if (G.peek(0xFF8D), G.peek(0xFF8E)) != (0x05, 0x06): fail('not on the stamp screen')
reopen(); G.run(30)
picked = collections.defaultdict(set)                               # (page, variant) -> stamp numbers
def select(e):
    p = page(); r = row(); goto(e); tap('A', 60)
    if is_open(): fail('A did not select element %d' % e)
    picked[(p, G.peek(0xD997))].add(r * (PAGES[p]['D4'] // PAGES[p]['D6']) + e - 2)
    reopen()
    if (page(), row(), elem()) != (p, r, e): fail('the cursor moved while the window was closed')
for p in range(8):
    if page() != p:
        goto(0)
        while page() < p: tap('Down')
        if page() != p: fail('page %d not reached' % p)
    P = PAGES[p]; S = stamps_of(p); y0 = node(p, 2)[1]
    top = [i for i in S if node(p, i)[1] == y0]; low = [i for i in S if node(p, i)[1] != y0]
    down = next((i for i in S if node(p, i)[5] == 0xF9), None)
    if down is None: fail('no scroll-down element on page %d' % p)
    while True:
        for e in top + (low if row() == P['rows'] - 1 else []): select(e)
        if row() == P['rows'] - 1: break
        r = row(); goto(down); tap('Down')
        if row() != r + 1: fail('Down did not scroll')
    for v in (1, 2, 3):                                             # the other three variants: one stamp each
        goto(0); tap('A')
        if G.peek(0xD997) != v: fail('variant %d not reached' % v)
        select(top[0])
    goto(0); tap('A')                                               # back to variant 0 for the next page
G.run(200)
dr = G.cov_dread(); rows = []
for (p, v), ns in sorted(picked.items()):
    P = PAGES[p]; ent = P['var'][v]; mb, mo = ent[2], ent[0] | ent[1] << 8; n0, n1 = min(ns), max(ns)
    g0, g1 = fl(P['bank'], P['off'] + n0 * P['D6']), fl(P['bank'], P['off'] + (n1 + 1) * P['D6'])
    has_mask = mb not in (0, 0xFF)
    m0, m1 = (fl(mb, mo + n0 * P['D6'] // 2), fl(mb, mo + (n1 + 1) * P['D6'] // 2)) if has_mask else (0, 0)
    rows.append([p, v, len(ns), '%d-%d' % (n0, n1), '%02X:%04X-%04X' % (P['bank'], P['off'] + n0 * P['D6'], P['off'] + (n1 + 1) * P['D6'] - 1),
                 '%d of %d' % (int((dr[g0:g1] > 0).sum()), g1 - g0),
                 ('%02X:%04X-%04X' % (mb, mo + n0 * P['D6'] // 2, mo + (n1 + 1) * P['D6'] // 2 - 1)) if has_mask else 'none',
                 ('%d of %d' % (int((dr[m0:m1] > 0).sum()), m1 - m0)) if has_mask else ''])
FS.save(os.path.join(os.path.dirname(a.out), 'read_screens_kitty_stamps.npz'))
np.savez_compressed(a.out, ex=np.array(G.cov_exec()), dr=np.array(dr), rdr=np.array(G.cov_reader()))
with open(a.report, 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f, lineterminator='\n')
    w.writerow(['page', 'variant', 'stamps_selected', 'stamp_numbers', 'graphics', 'graphics_bytes_read', 'mask', 'mask_bytes_read']); w.writerows(rows)
for r in rows: print('page %d variant %d: %3d stamps (%s)  gfx %s %s  mask %s %s' % tuple(r))
print('kitty_stamp_sweep: %d key presses; 0D:7460 %d of 32, 0D:7640 %d of 32 read -> %s' % (
    NKEYS[0], int((dr[fl(0xD, 0x7460):fl(0xD, 0x7480)] > 0).sum()), int((dr[fl(0xD, 0x7640):fl(0xD, 0x7660)] > 0).sum()), os.path.relpath(a.out, REPO)))
