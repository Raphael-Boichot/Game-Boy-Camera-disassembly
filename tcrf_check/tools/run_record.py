#!/usr/bin/env python3
"""RUN! RUN! RUN! finish time -> record -> the three gates that read it (README 16.18, the "Unlockables" list of the GameFAQs cheats page), played in my core with the joypad only.
A save is built from an unlocking save with the 18 counter bytes SRAM $10BB-$10CC zeroed (so the record is stored 0000 = displayed 99:99 and nothing is unlocked; checksum and echo recomputed).
For each variant the race loop of race 1 (corpus entry 649, state 21:06) is played with A every k-th frame (k = 2 ... 14) and with A every 2nd + Up before each hurdle; the player's finish time is the
timer $D028/$D029 when state 0B ends, the record $DAA7:$DAA6 (nine's complement, 09:7261-7283) is written to the save RAM by 02:4BB2. The SRAM after the race is then used as the save of a fresh boot and
  (1) the Album B unlock routine of the ROM (02:4D05) is called for picture B24 (the Japanese ROM has one run condition, DAA7 >= $82),
  (2) the corpus path to the credits (state 08:16, the one of credits_probe.py) is replayed: the real credits (08:17..) are reached only if the record is at least $7799 (09:4CFC).
usage: run_record.py OUTDIR      (run from the working root; Japanese ROM; GBCAM_CORE as for the other core tools)
Writes OUTDIR/run_record.csv (k, frames, player's place, time shown, stored record, B24 unlocked, credits reached)."""
import sys, os, csv
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g
import numpy as np
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'tools'))
import sram_analyze as S
out = sys.argv[1]; os.makedirs(out, exist_ok=True)
C = lib.Corpus('unlock_runs/f1_organic/corpus.jsonl')
sp = dict(C.E[C.path(649)[0]]['spec']); base = bytearray(lib.SAV(sp['sav']))
def zeroed(sav):
    b = bytearray(sav)
    for a in range(0x10BB, 0x10CD): b[a] = 0
    blk = bytes(b[0x1000:0x1000 + 0xD7]); blk += S.ck(blk, 0, 0xD7); b[0x1000:0x10D9] = blk; b[0x10D9:0x11B2] = blk
    return bytes(b)
def with_bytes(sav, vals):
    """vals {SRAM address: byte}; the settings block checksum and its echo are recomputed"""
    b = bytearray(sav)
    for a, v in vals.items(): b[a] = v
    blk = bytes(b[0x1000:0x1000 + 0xD7]); blk += S.ck(blk, 0, 0xD7); b[0x1000:0x10D9] = blk; b[0x10D9:0x11B2] = blk
    return bytes(b)
S0 = zeroed(base)
SF2_1999 = with_bytes(S0, {0x10C5: 0x99, 0x10C6: 0x19}); SF2_2000 = with_bytes(S0, {0x10C5: 0x00, 0x10C6: 0x20})        # best Space Fever II score DAA1:DAA0 = SRAM $10C6:$10C5
S0 = SF2_2000                                                    # the save of the races: nothing unlocked except the RUN! ship (best Space Fever II score 2000), record 0000
A, UP = g.A, g.UP
HURDLES = [0x180, 0x380, 0x580, 0x680, 0x880, 0x940, 0xb40, 0xc40, 0xd00, 0xf00, 0x1000, 0x1200]
def x16(a): return g.peek(a) | g.peek(a + 1) << 8
def step(k): g.keys(k); g.run(1)
def race(pat):
    f = 0
    while lib.cur()[0] == 0x21 and lib.cur()[1] in (0x06, 0x07, 0x0B) and f < 6000: step(pat(f)); f += 1
    for _ in range(60): step(0)
    return f
def every(k): return lambda f: A if f % k == 0 else 0
def autopilot(lead=30):
    jumped = set()
    def pat(f):
        key = A if f % 2 == 0 else 0
        x0 = x16(0xD000); air = (g.peek(0xD009) & 0x7F) >= 0x0C
        for h in HURDLES:
            if h in jumped: continue
            if x0 <= h + 24:
                if not air and 0 <= h - x0 <= lead: key |= UP; jumped.add(h)
                break
        return key
    return pat
# --- the album routine call (as albumb_thresholds.py)
STUB = 0xC019
def rombank_off():
    s = bytearray(g.snapshot()); cur = g.L.gb_rombank()
    for off in range(0x24230, 0x24250):
        t = bytearray(s); t[off] = (cur + 1) & 0xFF; g.restore(bytes(t))
        if g.L.gb_rombank() == ((cur + 1) & 0xFF): g.restore(bytes(s)); return off
    raise SystemExit('rombank offset not found')
def routine(sav, idx):
    """boot `sav`, reach the album grid, call 02:4D05 with A = idx; True = unlocked"""
    i = C.best((0xA, 1)); P = C.path(i)
    lib.boot(sav, combo=sp['combo'], printer=sp['printer'], free=sp['free'])
    for j in P[1:]:
        for a in C.E[j]['actions']: lib.act(a)
    g.run(60); assert lib.cur() == (0xA, 1)
    snap = g.snapshot(); off = rombank_off(); g.restore(snap); g.poke(STUB, 0x18); g.poke(STUB + 1, 0xFE); g.poke(0xFF9B, 2)
    b = bytearray(snap); s = (b[8] | b[9] << 8) - 2; g.poke(s, STUB & 0xFF); g.poke(s + 1, STUB >> 8)
    b = bytearray(g.snapshot()); b[0] = idx; b[8], b[9] = s & 0xFF, s >> 8; b[10], b[11] = 0x05, 0x4D; b[12] = b[13] = b[14] = 0; b[off] = 2
    g.restore(bytes(b)); g.run(1); e = bytearray(g.snapshot()); assert (e[10] | e[11] << 8) == STUB
    return not (e[1] & 0x80)
# --- the credits path
cr = min((C.frames(i), i) for i, e in C.E.items() if tuple(e['sig']) == (8, 0x16))[1]; CP = C.path(cr)
sp2 = dict(C.E[CP[0]]['spec']); base2 = lib.SAV(sp2['sav'])
def with_record(lo, hi):
    """the save of the credits path with every counter zero and only the RUN! record (SRAM $10CB = DAA6, $10CC = DAA7) set"""
    b = bytearray(zeroed(base2)); b[0x10CB], b[0x10CC] = lo, hi
    blk = bytes(b[0x1000:0x1000 + 0xD7]); blk += S.ck(blk, 0, 0xD7); b[0x1000:0x10D9] = blk; b[0x10D9:0x11B2] = blk
    return bytes(b)
def credits_reached(lo, hi):
    lib.boot(with_record(lo, hi), combo=sp2['combo'], printer=sp2['printer'], free=sp2['free']); seen = set()
    for j in CP[1:]:
        for a in C.E[j]['actions']:
            if a[0] == 'P': lib.act(a); seen.add(lib.cur()); continue
            k, hold, wait = a[:3]; g.keys(k)
            for _ in range(hold): g.run(1); seen.add(lib.cur())
            g.keys(0)
            for _ in range(wait): g.run(1); seen.add(lib.cur())
    return sorted('%02X:%02X' % t for t in seen if t[0] == 8 and t[1] >= 0x11)
# the credits path starts from the root of ITS entry: the save of that root is replaced
# --- cheat 2 of the page: the best Space Fever II score must be 2,000 for the third target of the first-wave menu (RUN!) to stay where the route shoots it
for nm, sv in (('best Space Fever II score 0000', zeroed(base)), ('best Space Fever II score 1999', SF2_1999), ('best Space Fever II score 2000', SF2_2000)):
    C.replay(649, sav=sv); print('route to the RUN! race loop (corpus entry 649) with %s: ends in %02X:%02X' % (nm, *lib.cur()), flush=True)
rows = []
VARS = [('A every %d%s frame' % (k, {2: 'nd', 3: 'rd'}.get(k, 'th')), every(k)) for k in range(2, 15)] + [('A every 2nd + Up before each hurdle', autopilot())]
for name, pat in VARS:
    C.replay(649, sav=S0)
    f = race(pat)
    t = (g.peek(0xD029), g.peek(0xD028)); rec = (g.peek(0xDAA7), g.peek(0xDAA6)); place = g.peek(0xD00D)
    sram = bytes(int(v) for v in g.sram()); ok = S.blk_ok(bytearray(sram), 0x1000, 0xD7)
    sav = bytes(sram)
    b24 = routine(sav, 0x17)
    cred = credits_reached(sram[0x10CB], sram[0x10CC])
    rows.append([name, f, place, '%02X:%02X' % t, '%02X%02X' % rec, '%02X%02X' % (sram[0x10CC], sram[0x10CB]), ok, b24, ' '.join(cred) or '-'])
    print('%-38s %4d frames place %d time %02X:%02X record $%02X%02X (SRAM $%02X%02X, block ok %s) B24 %s credits %s' % tuple(rows[-1][:1] + rows[-1][1:3] + [t[0], t[1], rec[0], rec[1], sram[0x10CC], sram[0x10CB], ok, 'unlocked' if b24 else 'locked', ' '.join(cred) or '-']), flush=True)
# the two controls: the fresh save (record 0000) and the unlocking save (record 9999)
for nm, sav in (('fresh save (record 0000, 99:99)', S0), ('unlocking save (record 9999)', bytes(base))):
    b24 = routine(sav, 0x17); cred = credits_reached(sav[0x10CB], sav[0x10CC])
    rows.append([nm, '', '', '', '', '%02X%02X' % (sav[0x10CC], sav[0x10CB]), '', b24, ' '.join(cred) or '-'])
    print('%-38s B24 %s credits %s' % (nm, 'unlocked' if b24 else 'locked', ' '.join(cred) or '-'), flush=True)
# the exact edges of the three gates, with the record bytes written by hand into the save (no race)
for nm, rec in (('record $7799 (displayed 22:00)', 0x7799), ('record $7798 (displayed 22:01)', 0x7798), ('record $82FF (displayed 17:00)', 0x82FF), ('record $81FF (displayed 18:00)', 0x81FF)):
    lo, hi = rec & 0xFF, rec >> 8
    b24 = routine(with_bytes(S0, {0x10CB: lo, 0x10CC: hi}), 0x17); cred = credits_reached(lo, hi)
    rows.append([nm, '', '', '', '', '%02X%02X' % (hi, lo), '', b24, ' '.join(cred) or '-'])
    print('%-38s B24 %s credits %s' % (nm, 'unlocked' if b24 else 'locked', ' '.join(cred) or '-'), flush=True)
with open(os.path.join(out, 'run_record.csv'), 'w', newline='') as fh:
    w = csv.writer(fh, lineterminator='\n'); w.writerow(['variant', 'frames_to_end', 'place_of_player', 'time_shown_D029_D028', 'record_DAA7_DAA6', 'record_in_SRAM_10CC_10CB', 'settings_block_ok', 'B24_unlocked', 'credits_states_reached']); w.writerows(rows)
