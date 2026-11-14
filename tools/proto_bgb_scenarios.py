#!/usr/bin/env python3
"""BGB scenarios of the early prototype (the BGB copy, blank SRAM): which keys lead to which GAME_SEQ, and the SRAM aging test with and
without the write protection switched off.

  tools/proto_bgb_scenarios.py PROTO_BGB.gb OUT_DIR [--paths roms/prototype_debagame/trace/menu_paths_proto.csv] [--aging roms/prototype_debagame/trace/aging_bgb_proto.csv]

PROTO_BGB.gb is the header-patched copy (md5 1d8097de...; BGB only). Each scenario is one BGB run from 128 KiB of $00 (keys in the
format of tools/jp/bgb_run.py, after the 250-frame boot hold and 400 free frames, then 200 free frames); the end state gives
GAME_SEQ ($C0A0) and the SRAM. --paths: one row per menu path (path, keys, GAME_SEQ in BGB). --aging: the AGING screen on the
55,55,AA,AA pattern, once straight from the menu and once after PROTECT TEST > OFF (the only code that writes $0A to $0000, the
SRAM write enable, with PICT_SAVE_GO): GAME_SEQ, the aging COUNT ($C0DA-$C0DB), the error flag ($C0E1) and the error record
($C0DC read value, $C0DD expected value, $C0DE bank), and for each SRAM bank its most frequent byte. Screens: OUT_DIR/<name>.png.
--patterns: after PROTECT TEST > OFF, AGING on each of the five rows of DATA SELECT (Down x row, A), and two switching runs: DECREMENT,
then B (back to DATA SELECT), Down, A (00,00,FF,FF), with B tapped (4 frames) and held (240 frames): does the pattern change and does
COUNT restart; 55,55,AA,AA, then B held and A at once: does DATA SELECT keep the cursor. Per run: the pattern row R0 ($FF88: $35 + $10 x row), COUNT, the error flag, the first 8
bytes of SRAM bank 0 and the most frequent byte of banks 0 and 15.
"""
import sys, os, csv, argparse, collections
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, os.path.join(HERE, '..', 'tools', 'jp'))
import bgb_run as B
from PIL import Image
D = 'roms/prototype_debagame/trace/'
ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('out')
ap.add_argument('--paths', default=D + 'menu_paths_proto.csv'); ap.add_argument('--aging', default=D + 'aging_bgb_proto.csv')
ap.add_argument('--patterns', default=D + 'aging_patterns_bgb_proto.csv'); ap.add_argument('--only-patterns', action='store_true'); a = ap.parse_args()
os.makedirs(a.out, exist_ok=True); blank = os.path.join(a.out, 'blank.sav'); open(blank, 'wb').write(bytes(0x20000))
T = [('A', 4, 90)]
def menu(i): return T + [('Down', 4, 20)] * i + [('A', 4, 120)]
def run(name, seq):
    r = B.run(a.rom, blank, os.path.join(a.out, name), seq, free=200)
    if os.path.exists(r['shot']): Image.open(r['shot']).save(os.path.join(a.out, name + '.png'))
    return r['st']
def keys(seq): return ' '.join('%s%s' % (k, '' if h <= 8 else '(%d frames)' % h) for k, h, w in seq)
PATHS = [('title', []), ('menu', T), ('SRAM TEST', menu(0)), ('SRAM TEST > WRITE', menu(0) + [('Down', 4, 20), ('A', 4, 120)]),
         ('SRAM TEST > AGING', menu(0) + [('Down', 4, 20)] * 2 + [('A', 4, 120)]), ('SRAM TEST > DUMP', menu(0) + [('Down', 4, 20)] * 3 + [('A', 4, 120)]),
         ('BANK TEST', menu(1)), ('PROTECT TEST', menu(2)), ('MOVIE TEST', menu(3)), ('MOVIE TEST > Start', menu(3) + [('Start', 4, 120)]),
         ('MOVIE TEST > A held', menu(3) + [('A', 30, 120)]), ('GALLERY', menu(4)), ('COM', menu(5))]
if not a.only_patterns:
    with open(a.paths, 'w', newline='') as f:
        w = csv.writer(f, lineterminator='\n'); w.writerow(['path', 'keys_after_boot', 'game_seq_in_bgb'])
        for name, seq in PATHS:
            st = run('path_' + name.replace(' > ', '_').replace(' ', '_'), seq)
            w.writerow([name, keys(seq) or '(none)', '%02X' % st['WRAM'][0xA0]]); print(name, '%02X' % st['WRAM'][0xA0], flush=True)

OFF = [('Down', 4, 20), ('Down', 4, 20), ('A', 4, 60), ('Down', 4, 20), ('A', 4, 60), ('B', 4, 60), ('Up', 4, 20), ('Up', 4, 20)]
AGE = [('A', 4, 60), ('Down', 4, 20), ('Down', 4, 20), ('A', 4, 60), ('Down', 4, 20), ('Down', 4, 20), ('A', 4, 600)]
if not a.only_patterns:
    with open(a.aging, 'w', newline='') as f:
        w = csv.writer(f, lineterminator='\n')
        w.writerow(['scenario', 'keys_after_boot', 'game_seq', 'count', 'error_flag', 'error_bank', 'error_expected', 'error_read'] + ['bank_%02d' % b for b in range(16)])
        for name, seq in (('aging_protected', T + AGE), ('aging_after_protect_off', T + OFF + AGE)):
            st = run(name, seq); wr = st['WRAM']; sr = st['SRAM']
            banks = ['%02X' % collections.Counter(sr[b * 0x2000:(b + 1) * 0x2000]).most_common(1)[0][0] for b in range(16)]
            row = [name, keys(seq), '%02X' % wr[0xA0], '%04X' % (wr[0xDA] | wr[0xDB] << 8), '%02X' % wr[0xE1], '%02X' % wr[0xDE], '%02X' % wr[0xDD], '%02X' % wr[0xDC]] + banks
            w.writerow(row); print(row, flush=True)
ROWS = ['DECREMENT', '00,00,FF,FF', '55,55,AA,AA', 'ALL 00', 'ALL FF']
TO_DATA = T + OFF + [('A', 4, 60), ('Down', 4, 20), ('Down', 4, 20), ('A', 4, 60)]          # PROTECT OFF, SRAM TEST > AGING: DATA SELECT
def pick(row, run=600): return [('Down', 4, 20)] * row + [('A', 4, run)]
SCEN = [('row%d %s' % (r, ROWS[r]), TO_DATA + pick(r)) for r in range(5)]
SCEN += [('switch DECREMENT -> B tap Down A', TO_DATA + pick(0, 300) + [('B', 4, 60)] + pick(1, 300)),
         ('switch DECREMENT -> B held Down A', TO_DATA + pick(0, 300) + [('B', 240, 60)] + pick(1, 300)),
         ('reenter 55,55,AA,AA -> B held A', TO_DATA + pick(2, 300) + [('B', 240, 60), ('A', 4, 300)])]
with open(a.patterns, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n')
    w.writerow(['scenario', 'game_seq', 'pattern_row_R0', 'count', 'error_flag', 'bank0_first8', 'bank0_most', 'bank15_most'])
    for name, seq in SCEN:
        st = run('pattern_' + name.split()[0], seq); wr = st['WRAM']; sr = st['SRAM']; hr = st['HRAM']
        row = [name, '%02X' % wr[0xA0], '%02X' % hr[0x08], '%04X' % (wr[0xDA] | wr[0xDB] << 8), '%02X' % wr[0xE1], sr[:8].hex(' '),
               '%02X' % collections.Counter(sr[:0x2000]).most_common(1)[0][0], '%02X' % collections.Counter(sr[15 * 0x2000:]).most_common(1)[0][0]]
        w.writerow(row); print(row, flush=True)
