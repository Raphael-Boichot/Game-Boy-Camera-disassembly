#!/usr/bin/env python3
"""What the saves written by real play do (README 16.18): the best-score bytes that sf2_play.py / ball_play.py left in the SRAM (SF2 best 7113, BALL best 1100: `sf2_after.sav`, `ball_after.sav`)
are copied byte for byte into an unlocking save whose counters were zeroed (settings block checksum and echo recomputed), and
  (1) the Album B unlock routine of the ROM (02:4D05 Japanese / 02:4D01 international) is called for every picture index (as albumb_thresholds.py): which pictures are unlocked by the played scores;
  (2) the Japanese ROM only: the route to the RUN! RUN! RUN! race loop (corpus entry 649, the third target of the first-wave menu) is replayed with that save and with the zeroed save.
usage: [MIRROR=1] [GBCAM_ROM=intl.gb] play_effects.py JP|INTL SF2_AFTER.sav BALL_AFTER.sav OUTFILE       (run from the working root; MIRROR=1 for the international ROM: its main menu is mirrored)
Writes OUTFILE (text)."""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g
import sram_analyze as S
which, sf2f, ballf, outf = sys.argv[1:5]
C = lib.Corpus('unlock_runs/f1_organic/corpus.jsonl'); i = C.best((0xA, 1)); P = C.path(i); sp = dict(C.E[P[0]]['spec'])
BASE = bytearray(open('saves_unl/%s.sav' % sp['sav'], 'rb').read())
LR = g.LEFT | g.RIGHT
def mirror(k):
    l, r = k & g.LEFT, k & g.RIGHT
    return (k & ~LR) | (g.RIGHT if l else 0) | (g.LEFT if r else 0)
sf2 = open(sf2f, 'rb').read()[0x10C5:0x10C9]; ball = open(ballf, 'rb').read()[0x10C9:0x10CB]
def build(vals):
    b = bytearray(BASE)
    for a in range(0x10BB, 0x10CD): b[a] = 0
    for a, v in vals.items(): b[a] = v
    blk = bytes(b[0x1000:0x1000 + 0xD7]); blk += S.ck(blk, 0, 0xD7); b[0x1000:0x10D9] = blk; b[0x10D9:0x11B2] = blk
    return bytes(b)
VALS = {'zeroed counters': {}, 'SF2 best from the played save (%s)' % sf2.hex(): {0x10C5 + k: v for k, v in enumerate(sf2)}, 'BALL best from the played save (%s)' % ball.hex(): {0x10C9 + k: v for k, v in enumerate(ball)},
        'RUN! record of my fastest race (15:48, run_record.py: $8451)': {0x10CB: 0x51, 0x10CC: 0x84},
        'both played scores': {**{0x10C5 + k: v for k, v in enumerate(sf2)}, **{0x10C9 + k: v for k, v in enumerate(ball)}}}
ENTRY = 0x4D05 if which == 'JP' else 0x4D01; NIDX = 8 if which == 'JP' else 14; STUB = 0xC019
def find_rombank_off():
    s = bytearray(g.snapshot()); cur = g.L.gb_rombank()
    for off in range(0x24230, 0x24250):
        t = bytearray(s); t[off] = (cur + 1) & 0xFF; g.restore(bytes(t))
        if g.L.gb_rombank() == ((cur + 1) & 0xFF): g.restore(bytes(s)); return off
    raise SystemExit('rombank offset not found')
def call_routine(snap, idx, off):
    g.restore(snap); g.poke(STUB, 0x18); g.poke(STUB + 1, 0xFE); g.poke(0xFF9B, 2)
    b = bytearray(snap); sp_ = (b[8] | b[9] << 8) - 2; g.poke(sp_, STUB & 0xFF); g.poke(sp_ + 1, STUB >> 8)
    b = bytearray(g.snapshot()); b[0] = idx; b[8], b[9] = sp_ & 0xFF, sp_ >> 8; b[10], b[11] = ENTRY & 0xFF, ENTRY >> 8; b[12] = b[13] = b[14] = 0; b[off] = 2
    g.restore(bytes(b)); assert g.L.gb_rombank() == 2
    g.run(1); end = bytearray(g.snapshot()); assert (end[10] | end[11] << 8) == STUB; g.restore(snap); return not (end[1] & 0x80)
def routine_row(sav):
    lib.boot(sav, combo=sp['combo'], printer=sp['printer'], free=sp['free'])
    for j in P[1:]:
        for a in C.E[j]['actions']:
            if a[0] != 'P' and os.environ.get('MIRROR') == '1' and lib.cur()[0] == 0 and lib.cur()[1] in (0, 1, 2) and (a[0] & LR): a = (mirror(a[0]),) + tuple(a[1:])
            lib.act(a)
    g.run(60); assert lib.cur() == (0xA, 1), lib.cur()
    snap = g.snapshot(); off = find_rombank_off()
    return [call_routine(snap, 0x10 + k, off) for k in range(NIDX)]
g.set_organic(0); lines = []
for name, vals in VALS.items():
    r = routine_row(build(vals)); lines.append('%s ROM, Album B routine, %-60s unlocked: %s' % (which, name, ' '.join('B%d' % (17 + k) for k, u in enumerate(r) if u) or '-')); print(lines[-1], flush=True)
if which == 'JP':
    g.set_organic(1)
    for name, vals in (('zeroed counters', {}), ('SF2 best from the played save (%s)' % sf2.hex(), VALS['SF2 best from the played save (%s)' % sf2.hex()])):
        sav = bytearray(build(vals)); C.replay(649, sav=bytes(sav)); lines.append('JP ROM, route to the RUN! race loop (corpus entry 649) with %-52s ends in %02X:%02X' % (name, *lib.cur())); print(lines[-1], flush=True)
open(outf, 'w').write('\n'.join(lines) + '\n')
