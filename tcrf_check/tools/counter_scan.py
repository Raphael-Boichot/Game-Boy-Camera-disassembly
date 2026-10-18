#!/usr/bin/env python3
"""Which joypad-only corpus paths change the Album B counters of the settings block ($DA96-$DAA7 = SRAM $10BB-$10CC)? (README 16.18; the unlock conditions of the GameFAQs cheats page)
Every entry of the corpus is replayed (joypad and save only, no RAM poke; the entries marked tainted are skipped) from the save of its root with the 18 counter bytes set to zero
(settings block checksum and echo recomputed); the counters are read at the end from WRAM $DA96 and from SRAM $10BB. Writes OUTDIR/counter_scan.csv (entry, end mode:state, the counters that are not zero) and prints one line per distinct set of non-zero counters.
usage: counter_scan.py CORPUS OUTDIR [FIRST LAST]      (run from the working root; GBCAM_CORE as for the other core tools)"""
import sys, os, csv
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'tools'))
import sram_analyze as S
corpus, out = sys.argv[1], sys.argv[2]; os.makedirs(out, exist_ok=True)
C = lib.Corpus(corpus); ids = sorted(C.E)
if len(sys.argv) > 4: ids = [i for i in ids if int(sys.argv[3]) <= i <= int(sys.argv[4])]
NAMES = {0xDA96: 'taken', 0xDA98: 'erased', 0xDA9A: 'transferred', 0xDA9C: 'printed', 0xDA9E: 'recv_m', 0xDA9F: 'recv_f', 0xDAA0: 'sf2_best', 0xDAA4: 'ball_best', 0xDAA6: 'run_best'}
def zeroed(sav):
    b = bytearray(sav)
    for a in range(0x10BB, 0x10CD): b[a] = 0
    blk = bytes(b[0x1000:0x1000 + 0xD7]); blk += S.ck(blk, 0, 0xD7); b[0x1000:0x10D9] = blk; b[0x10D9:0x11B2] = blk
    return bytes(b)
rows = []; seen = {}
for i in ids:
    e = C.E[i]
    if C.tainted(i): continue
    p = C.path(i); sp = e if 'spec' in e else C.E[p[0]]; name = C.E[p[0]]['spec']['sav']
    sav = lib.SAV(name)
    if sav is None or not (S.blk_ok(bytearray(sav), 0x1000, 0xD7) or S.blk_ok(bytearray(sav), 0x10D9, 0xD7)): continue
    try: C.replay(i, sav=zeroed(sav))
    except Exception as ex: print(i, 'replay failed', ex); continue
    w = g.wram(); s = g.sram(); cnt = bytes(int(s[a]) for a in range(0x10BB, 0x10CD)); wc = bytes(int(w[a - 0xC000]) for a in range(0xDA96, 0xDAA8))
    m, st = lib.cur()
    nz = ' '.join('%s=%s' % (NAMES.get(0xDA96 + k, '%04X' % (0xDA96 + k)), '%02X' % wc[k]) for k in range(18) if wc[k])
    rows.append([i, '%02X:%02X' % (m, st), wc.hex(), cnt.hex(), nz])
    if nz and nz not in seen: seen[nz] = i; print(i, '%02X:%02X' % (m, st), nz, flush=True)
with open(os.path.join(out, 'counter_scan.csv'), 'w', newline='') as fh:
    w = csv.writer(fh, lineterminator='\n'); w.writerow(['entry', 'end', 'wram_DA96_DAA7', 'sram_10BB_10CC', 'non_zero_counters']); w.writerows(rows)
print(len(rows), 'entries replayed;', sum(1 for r in rows if r[4]), 'end with a non-zero counter')
