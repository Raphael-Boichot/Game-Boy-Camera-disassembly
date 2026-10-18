#!/usr/bin/env python3
"""Album B unlock thresholds tested one counter at a time in my core (README 16.18, the "Unlockables" list of the GameFAQs cheats page).
For every condition of the unlock routine (Japanese 02:4D05: 8 conditions; international 02:4D0D: 14) a save file is built from an unlocking save by zeroing the 18 counter bytes
SRAM $10BB-$10CC (= WRAM $DA96-$DAA7) and writing ONE counter just below the threshold and then AT the threshold (settings block checksum and its echo recomputed, so the game accepts
the save: no RAM poke). Each save is booted, the album grid is reached with a joypad-only path of the corpus (mode $0A state 1) and Right is pressed through all pages; the pages
are compared with the page walk of the save with all counters at zero. A condition unlocks a picture when its page differs from the zero-counter page in exactly one thumbnail slot.
Two checks per save: (1) the unlock routine itself is CALLED for every picture index (the program counter is set to the routine, a return address pointing at a two-byte loop `jr $-2` in unused WRAM is pushed, one frame is run
with interrupts off, then the Z flag is read: NZ = picture unlocked, the caller 02:4CD1 / 02:51AF shows the stored picture, Z = locked, it shows the 秘 placeholder 36:4000; the state is restored afterwards; the counters come from the
save file through the routine's own copy of SRAM $10BB-$10D0, 02:503F); (2) the album pages are walked with Right and compared with the zero-counter walk (background layers only, the centre of each thumbnail).
usage: [MIRROR=1] [GBCAM_ROM=intl.gb] albumb_thresholds.py JP|INTL OUTDIR       (run from the working root; the ROM selected by GBCAM_ROM, default pocketcamera_jp.gb)
Writes OUTDIR/albumb_thresholds_<JP|INTL>.csv (condition, counter, value, differing slots per page) and OUTDIR/albumb_pages_<JP|INTL>_zero.png (the zero-counter pages)."""
import sys, os, csv
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g, R
import numpy as np
from PIL import Image
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'tools'))
import sram_analyze as S, ctypes
which, out = sys.argv[1], sys.argv[2]; os.makedirs(out, exist_ok=True)
C = lib.Corpus('unlock_runs/f1_organic/corpus.jsonl'); i = C.best((0xA, 1)); P = C.path(i); sp = dict(C.E[P[0]]['spec'])
BASE = bytearray(open('saves_unl/%s.sav' % sp['sav'], 'rb').read())
LR = g.LEFT | g.RIGHT
def mirror(k):
    l, r = k & g.LEFT, k & g.RIGHT
    return (k & ~LR) | (g.RIGHT if l else 0) | (g.LEFT if r else 0)
def sav_with(vals):
    """vals: {WRAM address: byte}; every other counter $DA96-$DAA7 = 0 (SRAM $10BB-$10CC)"""
    b = bytearray(BASE)
    for a in range(0x10BB, 0x10CD): b[a] = 0
    for ad, v in vals.items(): b[0x10BB + ad - 0xDA96] = v
    blk = bytes(b[0x1000:0x1000 + 0xD7]); blk += S.ck(blk, 0, 0xD7)
    b[0x1000:0x10D9] = blk; b[0x10D9:0x11B2] = blk
    assert S.blk_ok(b, 0x1000, 0xD7) and S.blk_ok(b, 0x10D9, 0xD7)
    return bytes(b)
class _NoSprites:
    """the hand cursor and the animated icon are sprites whose phase depends on the frame count: render the background and window layers only (LCDC bit 1 = 0)"""
    def __init__(self, core): self.c = core
    def peek(self, a): return self.c.peek(a) & ~2 if a == 0xFF40 else self.c.peek(a)
# --- conditions: (label, counter description, [(WRAM address, byte below), (address, byte at)] for the pair)
def bcd16(lo, hi, v):               # u16 BCD split into two bytes at (lo, hi)
    return {lo: v & 0xFF, hi: v >> 8}
JP = [('shoot 60 photos', 'DA96/97', bcd16(0xDA96, 0xDA97, 0x0059), bcd16(0xDA96, 0xDA97, 0x0060)),
      ('print 30 photos', 'DA9C/9D', bcd16(0xDA9C, 0xDA9D, 0x0029), bcd16(0xDA9C, 0xDA9D, 0x0030)),
      ('transfer 15 photos', 'DA9A/9B', bcd16(0xDA9A, 0xDA9B, 0x0014), bcd16(0xDA9A, 0xDA9B, 0x0015)),
      ('Space Fever II best 3000', 'DAA0-A3', bcd16(0xDAA0, 0xDAA1, 0x2999), bcd16(0xDAA0, 0xDAA1, 0x3000)),
      ('Space Fever II best 5000', 'DAA0-A3', bcd16(0xDAA0, 0xDAA1, 0x4999), bcd16(0xDAA0, 0xDAA1, 0x5000)),
      ('Ball best 700', 'DAA4/A5', bcd16(0xDAA4, 0xDAA5, 0x0699), bcd16(0xDAA4, 0xDAA5, 0x0700)),
      ('Ball best 1000', 'DAA4/A5', bcd16(0xDAA4, 0xDAA5, 0x0999), bcd16(0xDAA4, 0xDAA5, 0x1000)),
      ('RUN! RUN! RUN! best 17 s', 'DAA6/A7', bcd16(0xDAA6, 0xDAA7, 0x81FF), bcd16(0xDAA6, 0xDAA7, 0x8200))]
INTL = [JP[0], ('delete 60 photos', 'DA98/99', bcd16(0xDA98, 0xDA99, 0x0059), bcd16(0xDA98, 0xDA99, 0x0060)), JP[2],
        ('receive 5 photos from males', 'DA9E', {0xDA9E: 0x04}, {0xDA9E: 0x05}), ('receive 5 photos from females', 'DA9F', {0xDA9F: 0x04}, {0xDA9F: 0x05}),
        JP[1], JP[3], JP[4],
        ('Space Fever II best 7000', 'DAA0-A3', bcd16(0xDAA0, 0xDAA1, 0x6999), bcd16(0xDAA0, 0xDAA1, 0x7000)),
        ('Ball best 500', 'DAA4/A5', bcd16(0xDAA4, 0xDAA5, 0x0499), bcd16(0xDAA4, 0xDAA5, 0x0500)), JP[5], JP[6], JP[7],
        ('RUN! RUN! RUN! best 16 s', 'DAA6/A7', bcd16(0xDAA6, 0xDAA7, 0x82FF), bcd16(0xDAA6, 0xDAA7, 0x8300))]
CONDS = JP if which == 'JP' else INTL
CHECKS = [('transfer 5 photos (the number the page gives for B19)', 'DA9A/9B', bcd16(0xDA9A, 0xDA9B, 0x0005), bcd16(0xDA9A, 0xDA9B, 0x0005))]
ENTRY = 0x4D05 if which == 'JP' else 0x4D01; NIDX = 8 if which == 'JP' else 14; STUB = 0xC019
def call_routine(snap, idx):
    """call the unlock routine (bank 2) with A = idx (0x10 + picture number - B17) in the state `snap`; True = unlocked (NZ)"""
    g.restore(snap); g.poke(STUB, 0x18); g.poke(STUB + 1, 0xFE); g.poke(0xFF9B, 2)               # $FF9B = the bank shadow of the bank switcher 00:08C1, as when the real caller runs in bank 2
    b = bytearray(snap); sp = (b[8] | b[9] << 8) - 2
    g.poke(sp, STUB & 0xFF); g.poke(sp + 1, STUB >> 8)
    b = bytearray(g.snapshot()); b[0] = idx; b[8], b[9] = sp & 0xFF, sp >> 8; b[10], b[11] = ENTRY & 0xFF, ENTRY >> 8; b[12] = 0; b[13] = 0; b[14] = 0
    b[ROMBANK_OFF] = 2; g.restore(bytes(b)); assert g.L.gb_rombank() == 2
    g.run(1); end = bytearray(g.snapshot()); pc = end[10] | end[11] << 8
    assert pc == STUB, 'routine did not return (pc=%04X)' % pc
    g.restore(snap); return not (end[1] & 0x80)
def find_rombank_off():
    s = bytearray(g.snapshot()); cur = g.L.gb_rombank()
    for off in range(0x24230, 0x24250):
        t = bytearray(s); t[off] = (cur + 1) & 0xFF; g.restore(bytes(t))
        if g.L.gb_rombank() == ((cur + 1) & 0xFF): g.restore(bytes(s)); return off
    raise SystemExit('rombank offset not found')
def routine_row(vals):
    lib.boot(sav_with(vals), combo=sp['combo'], printer=sp['printer'], free=sp['free'])
    for j in P[1:]:
        for a in C.E[j]['actions']:
            if a[0] != 'P' and os.environ.get('MIRROR') == '1' and lib.cur()[0] == 0 and lib.cur()[1] in (0, 1, 2) and (a[0] & LR): a = (mirror(a[0]),) + tuple(a[1:])
            lib.act(a)
    g.run(60); assert lib.cur() == (0xA, 1), lib.cur()
    snap = g.snapshot()
    return [call_routine(snap, 0x10 + k) for k in range(NIDX)]
g.set_organic(0); ROMBANK_OFF = None
sav_with({}); lib.boot(sav_with({}), combo=sp['combo'], printer=sp['printer'], free=sp['free']); ROMBANK_OFF = find_rombank_off()
RT = []
z = routine_row({}); print('%s routine, all counters zero: unlocked pictures %s' % (which, [17 + k for k, u in enumerate(z) if u]), flush=True)
assert not any(z)
for label, ctr, below, at in CONDS:
    r = {t: routine_row(v) for t, v in (('below', below), ('at', at))}
    RT.append((label, ctr, below, at, r))
    print('%-34s below -> %-14s at -> %s' % (label, ' '.join('B%d' % (17 + k) for k, u in enumerate(r['below']) if u) or '-', ' '.join('B%d' % (17 + k) for k, u in enumerate(r['at']) if u) or '-'), flush=True)
for label, ctr, below, at in CHECKS:
    r = {t: routine_row(v) for t, v in (('below', below), ('at', at))}
    RT.append((label, ctr, below, at, r))
    print('%-34s value 5 -> %s' % (label, ' '.join('B%d' % (17 + k) for k, u in enumerate(r['at']) if u) or '-'), flush=True)
ev = {}
for _, _, _, at, _ in RT[:len(CONDS)]: ev.update(at)
allr = routine_row(ev); print('all thresholds together: %s' % ' '.join('B%d' % (17 + k) for k, u in enumerate(allr) if u), flush=True)
with open(os.path.join(out, 'albumb_routine_%s.csv' % which), 'w', newline='') as fh:
    w = csv.writer(fh, lineterminator='\n'); w.writerow(['condition', 'counters', 'below_bytes', 'below_unlocked', 'at_bytes', 'at_unlocked'])
    for label, ctr, below, at, r in RT:
        w.writerow([label, ctr, ' '.join('%04X=%02X' % kv for kv in sorted(below.items())), ' '.join('B%d' % (17 + k) for k, u in enumerate(r['below']) if u) or '-',
                    ' '.join('%04X=%02X' % kv for kv in sorted(at.items())), ' '.join('B%d' % (17 + k) for k, u in enumerate(r['at']) if u) or '-'])
sys.exit() if os.environ.get('ROUTINE_ONLY') else None
# ---- (2) the album pages in the real UI
STEPS = 24
def cellmask(a, b):
    d = (a != b)
    if d.ndim == 3: d = d.any(axis=2)
    m = np.zeros((18, 20), bool)
    for y, x in zip(*np.nonzero(d)):
        if y // 8 >= 2: m[y // 8, x // 8] = True
    return m
def blocks(m):
    cells = {(int(r), int(c)) for r, c in zip(*np.nonzero(m))}; res = []
    while cells:
        st = [cells.pop()]; blk = list(st)
        while st:
            r, c = st.pop()
            for n in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)):
                if n in cells: cells.remove(n); st.append(n); blk.append(n)
        rs = [x[0] for x in blk]; cs = [x[1] for x in blk]; res.append((min(rs), min(cs), max(rs), max(cs)))
    return sorted(res)
def big(bl): return [x for x in bl if 3 <= (x[2] - x[0] + 1) <= 6 and 3 <= (x[3] - x[1] + 1) <= 6]
def walk(vals, sprites=False):
    """album page walk of the save: one screenshot per press of Right; background layers only unless sprites=True (the hand cursor and the animated icon are sprites whose phase depends on the frame count)"""
    sav = sav_with(vals); lib.boot(sav, combo=sp['combo'], printer=sp['printer'], free=sp['free'])
    for j in P[1:]:
        for a in C.E[j]['actions']:
            if a[0] != 'P' and os.environ.get('MIRROR') == '1' and lib.cur()[0] == 0 and lib.cur()[1] in (0, 1, 2) and (a[0] & LR): a = (mirror(a[0]),) + tuple(a[1:])
            lib.act(a)
    g.run(60); assert lib.cur() == (0xA, 1)
    gg = g if sprites else _NoSprites(g); shots = [R.screen(gg).copy()]
    for n in range(STEPS): lib.act((g.RIGHT, 4, 150)); shots.append(R.screen(gg).copy())
    return shots
zero = walk({}); allv = walk(ev)
RECTS = [(3, 9, 6, 12), (3, 14, 6, 17), (8, 4, 11, 7), (8, 9, 11, 12), (8, 14, 11, 17), (13, 4, 16, 7), (13, 9, 16, 12), (13, 14, 16, 17)]    # the 8 thumbnails of an album page in cell units (row0, col0, row1, col1), read from the all-thresholds page of the Japanese ROM
def interior(sc, r): return sc[(r[0] + 1) * 8:r[2] * 8, (r[1] + 1) * 8:r[3] * 8]
def blank(x): return (x == x.flat[0]).all()
PAGE_OF = {}                                                             # press -> album page that holds gated pictures: in the zero-counter walk such a page shows the same placeholder (an identical interior) in most thumbnails
for k in range(len(zero)):
    ins = [interior(zero[k], r) for r in RECTS]; groups = []
    for x in ins:
        if blank(x): continue
        for gr in groups:
            if (gr[0] == x).all(): gr.append(x); break
        else: groups.append([x])
    big = max((len(gr) for gr in groups), default=0)
    if big >= 7: PAGE_OF[k] = 0                                          # 8 thumbnails, one of them under the cursor or not
    elif big >= 5: PAGE_OF[k] = 1                                        # 6 thumbnails (page B4 of the international ROM)
print('%s presses on the pages that hold gated pictures: %s' % (which, {i: [k for k, v in PAGE_OF.items() if v == i] for i in sorted(set(PAGE_OF.values()))}), flush=True)
def slot_pics():
    """[(press, rect, picture number)] of the thumbnails of the gated pages"""
    return [(k, r, 17 + 8 * i + n) for k, i in sorted(PAGE_OF.items()) for n, r in enumerate(RECTS) if 17 + 8 * i + n < 17 + NIDX]
WALK = {}
for label, ctr, below, at, r in RT:
    for tag, vals in (('below', below), ('at', at)): WALK[(label, tag)] = walk(vals)
WALK[('zero', '')] = zero; WALK[('all', '')] = allv
TRUTH = {(label, tag): r[tag] for label, ctr, below, at, r in RT for tag in ('below', 'at')}
TRUTH[('zero', '')] = [False] * NIDX; TRUTH[('all', '')] = allr
TEMPLATES = []                                                           # every look of the locked-picture placeholder (the 秘 mark is animated: its phase differs from one run to the next), taken from the thumbnails that the routine reports locked
for key, sh in WALK.items():
    for k, r, pic in slot_pics():
        xi = interior(sh[k], r)
        if not TRUTH[key][pic - 17] and not blank(xi) and not any((xi == t).all() for t in TEMPLATES): TEMPLATES.append(xi.copy())
print('%s: %d looks of the locked placeholder' % (which, len(TEMPLATES)), flush=True)
def ui_unlocked(sh):
    """pictures (B17..) shown in place of the placeholder: a thumbnail interior that matches none of the placeholder looks on most of the presses of its page (a blank interior is the thumbnail under the cursor, drawn by sprites: skipped)"""
    votes = {}
    for k, r, pic in slot_pics():
        xi = interior(sh[k], r)
        if blank(xi): continue
        votes.setdefault(pic, []).append(min((xi != t).mean() for t in TEMPLATES) > 0.1)
    return [pic for pic, v in sorted(votes.items()) if sum(v) * 2 > len(v)]
rows = []
for label, ctr, below, at, r in RT:
    ui_b = ui_unlocked(WALK[(label, 'below')]); ui_a = ui_unlocked(WALK[(label, 'at')])
    rt_b = [17 + k for k, u in enumerate(r['below']) if u]; rt_a = [17 + k for k, u in enumerate(r['at']) if u]
    rows.append(dict(condition=label, counters=ctr, below_bytes=' '.join('%04X=%02X' % kv for kv in sorted(below.items())), at_bytes=' '.join('%04X=%02X' % kv for kv in sorted(at.items())),
                     routine_below=' '.join('B%d' % x for x in rt_b) or '-', routine_at=' '.join('B%d' % x for x in rt_a) or '-',
                     album_below=' '.join('B%d' % x for x in ui_b) or '-', album_at=' '.join('B%d' % x for x in ui_a) or '-', agree=str(rt_b == ui_b and rt_a == ui_a)))
    print('%-34s routine %-10s %-14s album %-10s %-14s %s' % (label, rows[-1]['routine_below'], rows[-1]['routine_at'], rows[-1]['album_below'], rows[-1]['album_at'], rows[-1]['agree']), flush=True)
with open(os.path.join(out, 'albumb_thresholds_%s.csv' % which), 'w', newline='') as fh:
    w = csv.DictWriter(fh, fieldnames=list(rows[0]), lineterminator='\n'); w.writeheader(); w.writerows(rows)
# a picture of the album pages: zero counters / every counter at its threshold, with the cursor sprites
zs = walk({}, True); asv = walk(ev, True)
tiles = [np.concatenate([np.asarray(Image.fromarray(zs[k]).convert('RGB')), np.asarray(Image.fromarray(asv[k]).convert('RGB'))], axis=1) for k in sorted({min(k for k, v in PAGE_OF.items() if v == i) for i in set(PAGE_OF.values())})]
Image.fromarray(np.concatenate(tiles, axis=0)).save(os.path.join(out, 'albumb_pages_%s.png' % which))
