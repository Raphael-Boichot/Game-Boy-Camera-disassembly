#!/usr/bin/env python3
"""BGB screenshots of the same screens on the Japanese and the international ROM (same key presses; the main menu is mirrored so the first choice is Left on JP and Right on the international ROM).
usage: bgb_us_jp_capture.py OUTDIR STAGE [STAGE ...]     stages: view  picker  stamps  effects
Output: OUTDIR/<jp|us>_<name>.bmp (+ .sna, .dem, .sav), OUTDIR/results_<stage>.json (name -> game mode:state)"""
import sys, os, json
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import bgb_us_jp_job as J
out = os.path.abspath(sys.argv[1]); os.makedirs(out, exist_ok=True); stages = sys.argv[2:]
ROMS = dict(jp=(os.path.join(ROOT, 'pocketcamera_jp.gb'), 'Left'), us=(os.path.join(ROOT, 'roms', 'gbcam_usa_eu.gb'), 'Right'))
SAV = os.path.join(ROOT, 'saves_unl', 'unl_CE10238211.sav')
def K(k, h=4, w=60): return (k, h, w)
def view(lr): return [K('A', 4, 120), K(lr, 4, 60), K('A', 4, 250)]                       # -> 02:01 VIEW menu
def show(lr): return view(lr) + [K('Right', 4, 60), K('A', 4, 250)]                         # -> 0B:01 SHOW menu
def hotspot_viewer(lr): return show(lr) + [K('Down', 4, 60), K('Down', 4, 60), K('A', 4, 250), K('A', 4, 250)]        # -> 0C:03
def editor_grid(lr): return hotspot_viewer(lr) + [K('B', 4, 200)] * 4 + [K('Select', 4, 100), K('Right', 4, 60), K('A', 4, 250), K('A', 4, 250)]   # -> 1A:01
def picker(lr, n): return editor_grid(lr) + [K('A', 4, 250)] * 4 + [K('Up', 4, 60)] * n        # -> 1A:06 effect picker, n x Up (value = n-1, 0 = OFF)
def stamps(lr, pages):         # stamp tool (11:04) -> Start = chooser (11:03) -> category column -> Pokemon category (cat 2) -> first item -> 'pages' x Down
    seq = [K('A', 4, 120), K(lr, 4, 60), K('A', 4, 200), K('A', 4, 200), K('A', 4, 200), K('A', 4, 200), K('Left', 4, 100), K('Down', 4, 100), K('A', 4, 250), K('Start', 4, 200)]
    seq += [K('Right', 4, 24)] * 5 + [K('Down', 4, 24)] * 2 + [K('Left', 4, 24)] + [K('Up', 3, 12)] * 25 + [K('Left', 3, 12)] * 4 + [K('Down', 3, 24)] * pages
    return seq
def make_eff_save(k, jump=1, X=8, Y=7):          # every used photo slot gets hot spot 0 at (X,Y) with effect k and jump target (raw slot index) -> the transition to another photo
    sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'tools'))
    import sram_analyze as S
    b = bytearray(open(SAV, 'rb').read()); used = [i for i in range(30) if b[0x11B2 + i] < 30]
    for sl in used:
        base = S.slot_base(sl + 1) + 0xF00; t = bytearray(b[base:base + 0x5C])
        t[0x36:0x3B] = bytes([1, 0, 0, 0, 0]); t[0x3B:0x40] = bytes([X, 0, 0, 0, 0]); t[0x40:0x45] = bytes([Y, 0, 0, 0, 0]); t[0x45:0x4A] = bytes([0xFF] * 5)
        t[0x4A:0x4F] = bytes([k, 0xFF, 0xFF, 0xFF, 0xFF]); t[0x4F:0x54] = bytes([jump, 0xFF, 0xFF, 0xFF, 0xFF])
        data = bytes(t[:0x5A]); blk = data + S.ck(data, 0, 0x5A); b[base:base + 0x5C] = blk; b[base + 0x5C:base + 0xB8] = blk
    f = os.path.join(out, 'eff_save_%02d_jump%d.sav' % (k, jump)); open(f, 'wb').write(bytes(b)); return f
OFFS = [3, 8, 14, 20, 28, 38, 50, 70]
jobs = []
def add(rom, name, seq, sav=SAV, tail=2):
    jobs.append(('%s_%s' % (rom, name), ROMS[rom][0], sav, seq, out, 2, 400, tail))
for rom, (path, lr) in ROMS.items():
    if 'view' in stages:
        add(rom, '01_view_menu_cursor_left', view(lr)); add(rom, '02_view_menu_cursor_right', view(lr) + [K('Right', 4, 60)])
        add(rom, '03_show_menu_item1', show(lr)); add(rom, '05_show_menu_item3_hotspot', show(lr) + [K('Down', 4, 60), K('Down', 4, 60)])
        add(rom, '06_hotspot_select_photo', show(lr) + [K('Down', 4, 60), K('Down', 4, 60), K('A', 4, 250)]); add(rom, '07_hotspot_viewer', hotspot_viewer(lr))
        add(rom, '08_hotspot_editor_photo_grid', editor_grid(lr)); add(rom, '09_hotspot_editor_slots', editor_grid(lr) + [K('A', 4, 250)])
    if 'picker' in stages:
        for n in range(8): add(rom, 'picker_%d' % n, picker(lr, n))
    if 'stamps' in stages:
        for p in range(10 if rom == 'jp' else 3): add(rom, 'stamps_cat2_page%02d' % p, stamps(lr, p))
    if 'effects' in stages or 'effects1' in stages:
        ks = range(16) if 'effects' in stages else [1]
        for k in ks:
            sv = make_eff_save(k)
            for n in (OFFS if 'effects' in stages else [50]): add(rom, 'effect%02d_jump_f%02d' % (k, n), hotspot_viewer(lr) + [K('A', 4, n)], sav=sv, tail=1)
        if 'effects' in stages and rom == 'us': add(rom, 'stamps_cat2_page03_clamped', stamps(lr, 4))
res = {}
if jobs:
    r = J.run_jobs(jobs, 2); res.update(r)
    json.dump(res, open(os.path.join(out, 'results_%s.json' % '_'.join(stages)), 'w'), indent=1)
