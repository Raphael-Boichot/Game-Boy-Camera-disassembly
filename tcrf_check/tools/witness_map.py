#!/usr/bin/env python3
"""Code that the v8 coverage run never executed (class N) but a later targeted run did: writes assets/witness_jp.csv.
usage: witness_map.py OUT.csv [--map coverage/v8/report_v8/rom_map.csv] [--rom pocketcamera_jp.gb]
Witnesses (all outside the v8 merge):
  sgb      BGB with SystemMode=2 (Super Game Boy): the 50 block heads of the SGB sender 00:1D38-1EA0 (tcrf_check/assets/bgb_retrace/trace_report.json, "sgb_only_heads"; README 17.7)
  apu      BGB, music-editor corpus: the 6 heads my core never executed because it does not emulate NR52 / NR12 ("contradictions"; README 17.7)
  hotspot  my core, tcrf_check/tools/hotspot_effects.py: hot spot 0 of the displayed photo armed by a WRAM poke of the mirror $D643-$D65C, then a real A press, for the 16 effect values;
           the bytes executed beyond the replay are in tcrf_check/assets/hotspot_effects/exec_ranges.csv (README 13.4 point 5, 16.8)
  stamp_hold  my core, tcrf_check/tools/stamp_hold_a.py: stamp tool placement state, A held 180 frames then every 100 (joypad only, organic); the bytes executed beyond the replay
           are in tcrf_check/assets/stamp_hold/exec_ranges.csv (stamp_hold_a2.py gives a subset); the same behaviour was seen in BGB on both ROMs (README 15.4, 16.6 row 5)
  bgb_print   BGB with the Game Boy Printer helper (tcrf_check/tools/bgb_print_run.py, bgb_dj_print.py), the same runs as 17.3-17.6 (comment card, 3-photo print, D.J. score print)
           with the 622 block heads that were still unwitnessed logged: tcrf_check/assets/bgb_retrace/printer_heads_n/nh_*.heads_hit.json (README 16.15)
  dj_fields   my core, tcrf_check/tools/dj_fields.py: every key at every field of the three music-editor pages (joypad only); executed bytes in tcrf_check/assets/dj_fields/exec_ranges.csv
  reach_bfs   my core, tcrf_check/tools/reach_bfs.py: breadth-first key search (joypad only) from corpus entries toward chosen targets; one folder per search in
           tcrf_check/assets/reach_bfs/ (exec_ranges.csv = everything executed, reach_bfs.json = key path of every target found)
  bgb_status  BGB + the printer helper with a status byte injected (PRN_ERR; tcrf_check/tools/bgb_printer.py, bgb_print_run.py): the heads hit are in
           tcrf_check/assets/bgb_retrace/printer_status_heads/*.heads_hit.json (README 16.16)
  printer_status  my core with the printer status injected at every packet (tcrf_check/tools/printer_status.py, card and D.J. scenarios): one folder per scenario in
           tcrf_check/assets/printer_status/ (exec_ranges.csv = everything executed by any variant)
  force_open  my core, tcrf_check/tools/force_open.py and dj_pages.py --cursor: WRAM / SRAM bytes poked (hot spot mirror, menu cursors, effect index, state numbers, place counter, printer tables, patched saves), one folder per experiment in
           tcrf_check/assets/easy_wins/force/ (README 16.21)
  state_overrun  my core, force_open.py state_sweep and hotspot_sweep: the state number $D5CF 0..255 in every mode, the mode number $D5CE 0..255 from the main menu and the hot-spot effect numbers 16..255: table overruns (the handler is whatever word follows the table), credited after force_open, one folder each in tcrf_check/assets/easy_wins/force/ (README 16.21)
  run_race    my core, tcrf_check/tools/run_race.py: RUN! RUN! RUN! played to the end with A pressed at different rates, four races in a row, Up before each hurdle (joypad only, unlocking save): tcrf_check/assets/run_race/exec_ranges.csv
              (the six podium orders of README 16.17 were replayed in BGB, tcrf_check/tools/bgb_run_race.py; the block heads it hit are in tcrf_check/assets/run_race/bgb/)
  dj_se    my core, tcrf_check/tools/dj_se.py: the sound-effect selector of the D.J. performance screen (mode $1F state 5) set to SE 1-9 and A pressed (once; 26 times for SE 9), joypad only;
           the bytes executed beyond the replay are in tcrf_check/assets/dj_se/exec_ranges.csv (BGB replays of SE 4, SE 8 and SE 9 x 26, tcrf_check/tools/bgb_dj_se.py, hit the same block heads: tcrf_check/assets/dj_se/bgb/; README 16.18)
  sf2      my core, tcrf_check/tools/sf2_play.py: Space Fever II played with the joypad only from the first-wave menu to the best score 7113 (boss destroyed 9 times, the three boss variants), the death dialog left with B; executed bytes in tcrf_check/assets/sf2/exec_ranges.csv (README 16.18)
           (the same keys do not replay in BGB: the wave offsets come from the random-number table; the ball game, tcrf_check/tools/ball_play.py, reaches 1100 in the core and in BGB and executes no new never-run byte: tcrf_check/assets/ball/)
  cheat_checks  my core, tcrf_check/tools/cheat_checks.py: the behavioural cheats of the GameFAQs page (title-screen and VIEW speed, hold A in the D.J. screen, slide-show options, Start+Select at boot, Select+Start+Up in the erase-album page);
           bytes executed beyond the replay in tcrf_check/assets/cheat_checks/exec_ranges.csv, BGB agreement in cheat_checks.csv (README 16.18)
  link_variants  BGB-to-BGB link runs (tcrf_check/tools/bgb_link_variants.py): owner male / female on both units (the receive-counter branches 02:466D-467C and 07:4A2D-4A3E) and the $55 hello
           (00:2B20, a copy of the ROM whose idle hello byte is $55); the block heads hit are in tcrf_check/assets/easy_wins/link_variants/*.heads_hit.json (README 16.19)
  boot_aa  BGB, boot with the 12 calibration bytes of both SRAM copies set to $AA (blank): the two loops and the exit of Cam_Calib_Loader 0A:470D-4721 (README 16.19);
           heads in tcrf_check/assets/easy_wins/boot_aa/boot_aa.heads_hit.json
  dj_pages  my core, tcrf_check/tools/dj_pages.py: breadth-first search over every state of the D.J. pages (modes $1F / $20, eight keys and chords, joypad only, unlocking save); bytes executed
           beyond the replay in tcrf_check/assets/easy_wins/dj_pages/*/exec_ranges.csv (README 16.19)
  editor_copy_flag  my core, tcrf_check/tools/editor_copy_flag.py --f33: all 30 slots of the unlocking save patched to F33 = 1 (checksums fixed), corpus path 595 replayed (joypad only): the pen-tool exit
           (state 10:09, Right) runs the editor save-back, which draws the copy badge when [$CF33] != 0 (02:47FE); executed bytes in tcrf_check/assets/easy_wins/editor_copy_flag/f33_save/exec_ranges.csv (README 16.19)
  gameface_edit  my core, tcrf_check/tools/gameface_edit.py: a Game Face stored in the SRAM (flag $10D1 and the image $11FC-$1FFB, both settings copies re-checksummed; the SRAM is edited in the core once the game
           sits at the MAGIC menu), Select+Down then A on the Game Face page (06:48E6), then the pen tool of the Game Face editor and its save-back (07:6A58 -> 02:4C37); executed bytes in
           tcrf_check/assets/easy_wins/gameface_edit/face_stored/exec_ranges.csv (README 16.19)
  compose_picker  BGB, tcrf_check/tools/bgb_compose.py: used save unl_PC10696894, COMPOSE two-photo layout (mode $17): A held + Up / Down in the photo pickers (06:523B, 06:5276, 06:5769); heads in
           tcrf_check/assets/easy_wins/compose/bgb_compose.heads_hit.json; a head marker credits only the block up to the next call, so the bytes after the calls come from the same chain in my core
           (tcrf_check/tools/compose_picker.py, executed bytes in tcrf_check/assets/easy_wins/compose/core/exec_ranges.csv; README 16.19)
  slideshow_markers  BGB, tcrf_check/tools/bgb_slideshow.py, and my core, tcrf_check/tools/slideshow_markers.py: used save unl_CE10238211 patched BEFORE the boot (list = photos 0..5, timing markers $82 $02 $42 $81 $41, repeat flag $FF), the slide-show
           player (mode $13) and the preview of the editor (state 12:12); heads in tcrf_check/assets/easy_wins/slideshow_markers/bgb_slideshow.heads_hit.json, executed bytes in .../markers/ and .../loop/exec_ranges.csv (README 16.19)
A BGB head hit means the whole block ran (blocks.py: straight line up to the next head or terminator). Only bytes of class N are written; the printer runs of 17.1-17.6
(tcrf_check/assets/bgb_retrace/printer_heads) hit none."""
import sys, os, csv, json
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(os.path.dirname(HERE)); sys.path.insert(0, HERE)
import blocks as B
a = sys.argv[1:]
def opt(n, d):
    if n in a: i = a.index(n); v = a[i + 1]; del a[i:i + 2]; return v
    return d
MAP = opt('--map', os.path.join(REPO, 'coverage', 'v8', 'report_v8', 'rom_map.csv')); ROM = opt('--rom', 'pocketcamera_jp.gb'); OUT = a[0]
rom = open(ROM, 'rb').read(); trace = json.load(open(os.path.join(REPO, 'wram', 'trace_jp_v3.json')))
heads, members, code = B.blocks(rom, trace)
N = 1 << 20
def flat(b, ad): return ad if (b == 0 and ad < 0x4000) else b * 0x4000 + ad - 0x4000
cls = np.zeros(N, np.uint8)
for r in csv.DictReader(open(MAP)):
    cls[flat(int(r['bank'], 16), int(r['start'], 16)):][:int(r['length'])] = ord(r['class'])
isN = cls == ord('N')
rep = json.load(open(os.path.join(REPO, 'tcrf_check', 'assets', 'bgb_retrace', 'trace_report.json')))
def from_heads(hs, strict=True):                       # strict=False: an address that is not the head of a block of the static trace is only a probe (the D.J. status runs also logged 05:5A21, 05:5A39) and is skipped
    m = np.zeros(N, bool)
    for k in hs:
        b, ad = k.split(':'); key = (int(b, 16), int(ad, 16))
        if key not in members and not strict: continue
        assert key in members, k
        for bb, aa, ln in members[key]: m[flat(bb, aa):flat(bb, aa) + ln] = True
    return m
W = [('sgb', 'BGB SystemMode=2 (Super Game Boy): block heads of the SGB sender', 'C', from_heads(rep['sgb_only_heads']['heads'])),
     ('apu', 'BGB, music-editor corpus: branch on NR52 bit 0 / NR12 that my core cannot take', 'C', from_heads(list(rep['contradictions'])))]
hm = np.zeros(N, bool)
for r in csv.DictReader(open(os.path.join(REPO, 'tcrf_check', 'assets', 'hotspot_effects', 'exec_ranges.csv'))):
    o1 = flat(int(r['bank'], 16), int(r['start'], 16)); o2 = flat(int(r['bank'], 16), int(r['end'], 16)); hm[o1:o2 + 1] = True
W.append(('hotspot', 'my core, hot spot armed by a WRAM poke + real A press, effect values 0-15', 'C', hm))
import glob
pm = np.zeros(N, bool)
for fn in sorted(glob.glob(os.path.join(REPO, 'tcrf_check', 'assets', 'bgb_retrace', 'printer_heads_n', 'nh_*.heads_hit.json'))):
    pm |= from_heads(json.load(open(fn))['hits'])
W.append(('bgb_print', 'BGB + printer helper: comment-card print, 3-photo print, D.J. score print (heads logged)', 'C', pm))
sm = np.zeros(N, bool)
for r in csv.DictReader(open(os.path.join(REPO, 'tcrf_check', 'assets', 'stamp_hold', 'exec_ranges.csv'))):
    o1 = flat(int(r['bank'], 16), int(r['start'], 16)); o2 = flat(int(r['bank'], 16), int(r['end'], 16)); sm[o1:o2 + 1] = True
sbm = np.zeros(N, bool)
for fn in sorted(glob.glob(os.path.join(REPO, 'tcrf_check', 'assets', 'bgb_retrace', 'printer_status_heads', '*.heads_hit.json'))):
    sbm |= from_heads(json.load(open(fn))['hits'], strict=False)
W.append(('bgb_status', 'BGB + printer helper, status byte injected (checksum / busy bits on a DATA reply, the error bits)', 'C', sbm))
W.append(('stamp_hold', 'my core, hold A in the stamp placement state (joypad only): the bit-reversal routine 04:5E4C', 'C', sm))
dm = np.zeros(N, bool)
for r in csv.DictReader(open(os.path.join(REPO, 'tcrf_check', 'assets', 'dj_fields', 'exec_ranges.csv'))):
    o1 = flat(int(r['bank'], 16), int(r['start'], 16)); o2 = flat(int(r['bank'], 16), int(r['end'], 16)); dm[o1:o2 + 1] = True
W.append(('dj_fields', 'my core, every key at every field of the music-editor pages (joypad only): SOUND I field 7, NOISE field 3 and the field-handler branches', 'C', dm))
rb = np.zeros(N, bool)
for fn in sorted(glob.glob(os.path.join(REPO, 'tcrf_check', 'assets', 'reach_bfs', '*', 'exec_ranges.csv'))):
    for r in csv.DictReader(open(fn)):
        o1 = flat(int(r['bank'], 16), int(r['start'], 16)); o2 = flat(int(r['bank'], 16), int(r['end'], 16)); rb[o1:o2 + 1] = True
W.append(('reach_bfs', 'my core, key search (joypad only) from the corpus entries toward a target: MAGIC option screen, banks 3-9 menus', 'C', rb))
rr = np.zeros(N, bool)
for r in csv.DictReader(open(os.path.join(REPO, 'tcrf_check', 'assets', 'run_race', 'exec_ranges.csv'))):
    o1 = flat(int(r['bank'], 16), int(r['start'], 16)); o2 = flat(int(r['bank'], 16), int(r['end'], 16)); rr[o1:o2 + 1] = True
W.append(('run_race', 'my core, RUN! RUN! RUN! races 1-4 played with A at different rates and Up at the hurdles (joypad only; BGB confirms the six podiums, README 16.17): the finish and result code of mode $21', 'C', rr))
psm = np.zeros(N, bool)
for fn in sorted(glob.glob(os.path.join(REPO, 'tcrf_check', 'assets', 'printer_status', '*', 'exec_ranges.csv'))):
    for r in csv.DictReader(open(fn)):
        o1 = flat(int(r['bank'], 16), int(r['start'], 16)); o2 = flat(int(r['bank'], 16), int(r['end'], 16)); psm[o1:o2 + 1] = True
W.append(('printer_status', 'my core, printer status injected at every packet (every bit and combinations) in the card and the D.J. print', 'C', psm))
ds = np.zeros(N, bool)
for r in csv.DictReader(open(os.path.join(REPO, 'tcrf_check', 'assets', 'dj_se', 'exec_ranges.csv'))):
    o1 = flat(int(r['bank'], 16), int(r['start'], 16)); o2 = flat(int(r['bank'], 16), int(r['end'], 16)); ds[o1:o2 + 1] = True
W.append(('dj_se', 'my core, D.J. performance screen: sound-effect selector SE 4, SE 8 and SE 9 (26 presses) with A (joypad only; BGB hits the same block heads, README 16.18): sound-engine handlers 1F:4940, 49E3, 4A42', 'C', ds))
def exec_mask(rel):
    m = np.zeros(N, bool)
    for r in csv.DictReader(open(os.path.join(REPO, *rel.split('/')))):
        m[flat(int(r['bank'], 16), int(r['start'], 16)):flat(int(r['bank'], 16), int(r['end'], 16)) + 1] = True
    return m
W.append(('sf2', 'my core, Space Fever II played with the joypad only to the best score 7113: boss fights (nine boss kills), the three boss variants, the death dialog (README 16.18)', 'C', exec_mask('tcrf_check/assets/sf2/exec_ranges.csv')))
W.append(('cheat_checks', 'my core, the behavioural cheats of the GameFAQs page: Select+Start+Up in the erase-album page, both copies of the shortcut (04:491E, 04:4865; README 16.18)', 'C', exec_mask('tcrf_check/assets/cheat_checks/exec_ranges.csv')))
lm = np.zeros(N, bool)
for fn in sorted(glob.glob(os.path.join(REPO, 'tcrf_check', 'assets', 'easy_wins', 'link_variants', '*.heads_hit.json'))):
    lm |= from_heads(json.load(open(fn))['hits'], strict=False)
W.append(('link_variants', 'BGB-to-BGB link runs: owner male / female on both units (receive counters 02:466D-467C, 07:4A2D-4A3E) and the $55 hello byte (00:2B20)', 'C', lm))
bj = json.load(open(os.path.join(REPO, 'tcrf_check', 'assets', 'easy_wins', 'boot_aa', 'boot_aa.heads_hit.json')))
W.append(('boot_aa', 'BGB, calibration bytes of both SRAM copies = $AA: the loops and the exit of Cam_Calib_Loader (0A:470D-4721)', 'C', from_heads(bj['hits'] + bj['implied_heads'])))
def exec_masks(pattern):
    m = np.zeros(N, bool)
    for fn in sorted(glob.glob(os.path.join(REPO, *pattern.split('/')))):
        for r in csv.DictReader(open(fn)):
            m[flat(int(r['bank'], 16), int(r['start'], 16)):flat(int(r['bank'], 16), int(r['end'], 16)) + 1] = True
    return m
W.append(('dj_pages', 'my core, breadth-first key search over every state of the D.J. pages (joypad only): fields and page handlers of bank 5 (README 16.19)', 'C', exec_masks('tcrf_check/assets/easy_wins/dj_pages/*/exec_ranges.csv')))
W.append(('editor_copy_flag', 'my core, a save whose photos all have F33 = 1, then the pen-tool exit and save-back of a corpus path (joypad only): the copy-badge branch 02:47FE (README 16.19)', 'C', exec_masks('tcrf_check/assets/easy_wins/editor_copy_flag/*/exec_ranges.csv')))
W.append(('gameface_edit', 'my core, a Game Face stored in the SRAM (edited in the core at the MAGIC menu): the hidden third choice of the Game Face page, the Game Face editor and its save-back (README 16.19)', 'C', exec_masks('tcrf_check/assets/easy_wins/gameface_edit/*/exec_ranges.csv')))
cp_ = json.load(open(os.path.join(REPO, 'tcrf_check', 'assets', 'easy_wins', 'compose', 'bgb_compose.heads_hit.json')))
W.append(('compose_picker', 'BGB (block heads 06:523B, 06:5276, 06:5769) and my core (the bytes after the two calls), used save, COMPOSE two-photo layout: A held with Up / Down in the photo pickers (README 16.19)', 'C', from_heads(cp_['hits']) | exec_masks('tcrf_check/assets/easy_wins/compose/*/exec_ranges.csv')))
ss_ = json.load(open(os.path.join(REPO, 'tcrf_check', 'assets', 'easy_wins', 'slideshow_markers', 'bgb_slideshow.heads_hit.json')))
W.append(('slideshow_markers', 'BGB (block heads 03:6155, 03:6264, 03:629A, 03:628B, 03:4D4B, 03:4E21) and my core, used save with start / end markers in the timing array: the slide-show player and the editor preview (README 16.19)', 'C',
          from_heads(ss_['hits']) | exec_masks('tcrf_check/assets/easy_wins/slideshow_markers/markers/exec_ranges.csv') | exec_masks('tcrf_check/assets/easy_wins/slideshow_markers/loop/exec_ranges.csv')))
OVERRUN = ('state_sweep', 'hotspot_sweep')          # table overruns: credited after the designed experiments, as witness state_overrun
W.append(('force_open', 'my core, WRAM / SRAM bytes poked like a save or a game state could hold them (an armed hot spot, an out-of-range menu cursor or effect index, a state number, a place counter, the printer size tables, a patched save) and real key presses at the natural caller; one process per experiment in tcrf_check/tools/force_open.py, plus the D.J. page search with the two cursors in the state key (dj_pages.py --cursor) (README 16.21)', 'C', sum((exec_masks('tcrf_check/assets/easy_wins/force/%s/exec_ranges.csv' % d) for d in sorted(os.listdir(os.path.join(REPO, 'tcrf_check', 'assets', 'easy_wins', 'force'))) if d not in OVERRUN), np.zeros(N, bool))))
W.append(('state_overrun', 'my core, tcrf_check/tools/force_open.py state_sweep: for every game mode the state number $D5CF (and from the main menu the mode number $D5CE) poked to 0..255, 8 frames each, and hotspot_sweep: hot-spot effect numbers 16..255: the handler is fetched from a word table with an index past its end, so the code that runs is whatever the words after the table point to (a table overrun, not a designed path; README 16.21)', 'C', sum((exec_masks('tcrf_check/assets/easy_wins/force/%s/exec_ranges.csv' % d) for d in OVERRUN), np.zeros(N, bool))))
rows = []; seen = np.zeros(N, bool)
for name, desc, ev, m in W:
    m = m & isN & ~seen; seen |= m
    idx = np.flatnonzero(m); runs = []
    for o in idx:
        if runs and runs[-1][1] == o: runs[-1][1] = o + 1
        else: runs.append([o, o + 1])
    for s, e in runs:
        for lo, hi in ((s, e),):
            b = lo >> 14 if lo >= 0x4000 else 0
            while lo < hi:
                top = min(hi, (b + 1) * 0x4000) if b else min(hi, 0x4000)
                ad = lo if b == 0 else 0x4000 + (lo & 0x3FFF)
                rows.append(['%02X' % b, '%04X' % ad, '%04X' % (ad + top - lo - 1), top - lo, name, ev, desc]); lo = top; b += 1 if lo >= 0x4000 else 0
    print('%-8s %5d bytes of class N  (%s)' % (name, int(m.sum()), desc))
with open(OUT, 'w', newline='') as fh:
    w = csv.writer(fh, lineterminator='\n'); w.writerow(['bank', 'start', 'end', 'bytes', 'witness', 'evidence', 'description']); w.writerows(rows)
print('class N bytes in the v8 map: %d, with a witness: %d, left: %d; %d ranges -> %s' % (int(isN.sum()), int(seen.sum()), int(isN.sum() - seen.sum()), len(rows), OUT))
