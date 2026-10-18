#!/usr/bin/env python3
"""Byte classes of the Japanese ROM for the two maps (rom_reach_map.py, rom_layout_map.py): what the v8 coverage run and the later targeted runs reached.
build(ROM, MAP, ASSETS, WIT, REACH, UNUSED, REPO) -> dict of boolean byte masks (flat ROM offsets) and cat, the category of each byte:
0 organic (blue), 1 forced only (light blue), 2 never executed nor read and not identified (red), 3 untouched padding, 4 never read but identified as asset data (orange),
5 never run by v8 but run / read by a later targeted run (green), 6 never run and proven dead (purple), 7 really unused asset data (yellow).
Definitions and sources: the docstring of rom_reach_map.py and README 16.13-16.15, 16.24."""
import os, csv
import numpy as np

def build(ROM, MAP, ASSETS, WIT, REACH, UNUSED, REPO):
    rom = np.frombuffer(open(ROM, 'rb').read(), np.uint8); N = len(rom)
    cls = np.zeros(N, np.uint8)
    for r in csv.DictReader(open(MAP)):
        b = int(r['bank'], 16); ad = int(r['start'], 16); o = b * 0x4000 + (ad - 0x4000 if b else ad); cls[o:o + int(r['length'])] = ord(r['class'])
    assert (cls > 0).all(), 'the byte-class map does not cover the whole ROM'
    pad = np.zeros(N, bool); i = 0
    rb = rom.tobytes()
    while i < N:
        j = i
        while j < N and rb[j] == rb[i]: j += 1
        if j - i >= 16 and rb[i] in (0, 255): pad[i:j] = True
        i = j
    C = lambda ch: cls == ord(ch)
    wit = np.zeros(N, bool)         # class N bytes that a later targeted run executed (assets/witness_jp.csv)
    if WIT != 'none' and os.path.exists(WIT):
        for r in csv.DictReader(open(WIT)):
            b = int(r['bank'], 16); o1 = b * 0x4000 + (int(r['start'], 16) - 0x4000 if b else int(r['start'], 16)); o2 = b * 0x4000 + (int(r['end'], 16) - 0x4000 if b else int(r['end'], 16))
            wit[o1:o2 + 1] = True
    wit &= C('N')
    dead = np.zeros(N, bool)         # never-run code proven dead by the reachability analysis (verdict UNREACHABLE or UNREFERENCED)
    if REACH != 'none' and os.path.exists(REACH):
        for r in csv.DictReader(open(REACH)):
            if r['verdict'] not in ('UNREACHABLE', 'UNREFERENCED'): continue
            b = int(r['bank'], 16); o1 = b * 0x4000 + (int(r['start'], 16) - 0x4000 if b else int(r['start'], 16)); o2 = b * 0x4000 + (int(r['end'], 16) - 0x4000 if b else int(r['end'], 16))
            dead[o1:o2 + 1] = True
    dead &= C('N') & ~wit
    red = (C('N') & ~wit) | C('U'); forced = C('F') | C('r'); organic = C('C') | C('R') | C('T')
    # bytes of the never-read data that assets/asset_map_jp.csv labels (padding stays padding)
    ident = np.zeros(N, bool)
    if ASSETS != 'none' and os.path.exists(ASSETS):
        for r in csv.DictReader(open(ASSETS)):
            b = int(r['bank'], 16); o1 = b * 0x4000 + (int(r['start'], 16) - 0x4000 if b else int(r['start'], 16)); o2 = b * 0x4000 + (int(r['end'], 16) - 0x4000 if b else int(r['end'], 16))
            ident[o1:o2 + 1] = True
    # the wild-frame lateral strips are NOT unknown data any more: blanking them in BGB changes exactly the lateral tiles of the print (README 16.13 (1), C on frames 02, 03, 05, 06, 07, 08);
    # they are never read by the v8 core runs, so they get the colour of 'never run by v8, shown to be used by a later targeted run'. Their $FF runs (frames 05, 06, 08) are used too, not padding.
    lat = np.zeros(N, bool)
    if ASSETS != 'none' and os.path.exists(ASSETS):
        for r in csv.DictReader(open(ASSETS)):
            if r['type'] != 'wild_frame_lateral' or r['evidence'] != 'C': continue
            b = int(r['bank'], 16); o1 = b * 0x4000 + (int(r['start'], 16) - 0x4000 if b else int(r['start'], 16)); o2 = b * 0x4000 + (int(r['end'], 16) - 0x4000 if b else int(r['end'], 16))
            lat[o1:o2 + 1] = True
    lat &= C('U')
    # the data sent to the Super Game Boy (asset_map rows sgb_*, evidence C): the border that BGB shows in SGB mode equals the one rebuilt from these bytes (README 16.13 (5))
    sgb = np.zeros(N, bool)
    if ASSETS != 'none' and os.path.exists(ASSETS):
        for r in csv.DictReader(open(ASSETS)):
            if not r['type'].startswith('sgb_') or r['evidence'] != 'C': continue
            b = int(r['bank'], 16); o1 = b * 0x4000 + (int(r['start'], 16) - 0x4000 if b else int(r['start'], 16)); o2 = b * 0x4000 + (int(r['end'], 16) - 0x4000 if b else int(r['end'], 16))
            sgb[o1:o2 + 1] = True
    sgb &= C('U') & ~pad
    # the stamp pictures (sym labels StampCat*_Gfx, evidence C: README 16.24) that the v8 run never read but the stamp-menu walks of the display tracker put on screen in runs without state pokes
    stamp = np.zeros(N, bool)
    NM = os.path.join(REPO, 'disasm', 'sym_names_jp.csv'); TY = os.path.join(REPO, 'disasm', 'sym_types_jp.csv'); DU = os.path.join(REPO, 'tcrf_check', 'assets', 'display_run', 'display_union.npz')
    if all(os.path.exists(f) for f in (NM, TY, DU)):
        ends = {}
        for r in csv.DictReader(open(TY, encoding='utf-8')): ends[(int(r['bank'], 16), int(r['start'], 16))] = int(r['end'], 16)      # the last row of a start wins (types_fix)
        tile_on = (np.load(DU)['fro'].astype(np.int64).reshape(-1, 16).max(1) >= 15).repeat(16)[:N]       # a 16-byte tile on screen in >= 15 organic frames
        for r in csv.DictReader(open(NM, encoding='utf-8')):
            if not r['name'].startswith('StampCat') or r['conf'] != 'C' or r['name'].endswith('_Mask'): continue                     # the graphics; the masks are 1bpp
            b = int(r['bank'], 16); a0 = int(r['addr'], 16); o1 = b * 0x4000 + (a0 - 0x4000 if b else a0); stamp[o1:o1 + ends[(b, a0)] - a0] = True
        stamp &= tile_on
    stamp &= C('U') & ~pad
    ident &= C('U') & ~pad & ~lat & ~stamp & ~sgb
    # the really unused assets of README 16.24 (display tracking + hand-listed spans): data only, padding stays padding
    unused = np.zeros(N, bool); n_unused_spans = 0; n_unused_tcrf = 0
    if UNUSED != 'none' and os.path.exists(UNUSED):
        for r in csv.DictReader(open(UNUSED, encoding='utf-8')):
            if not (r['tier'] in ('no loader', 'never shown', 'forced only') or (r['tier'] == 'TCRF' and int(r['stable_in_organic_runs']) == 0)): continue
            b = int(r['bank'], 16); o1 = b * 0x4000 + (int(r['addr'], 16) - 0x4000 if b else int(r['addr'], 16)); unused[o1:o1 + int(r['bytes'])] = True
            n_unused_spans += 1; n_unused_tcrf += r['tier'] == 'TCRF'
    unused &= ~(C('C') | C('F') | C('N')) & ~pad
    # category per byte: 0 organic blue, 1 forced-only light blue, 2 red, 3 untouched padding, 4 never read but identified as asset data (orange), 5 executed by a later targeted run (green)
    cat = np.zeros(N, np.uint8); cat[forced] = 1; cat[red] = 2; cat[dead] = 6; cat[C('U') & pad] = 3; cat[ident] = 4; cat[wit] = 5; cat[lat] = 5; cat[stamp] = 5; cat[sgb] = 5; cat[unused] = 7
    return {k: v for k, v in locals().items() if k in ['rom', 'N', 'cls', 'pad', 'C', 'wit', 'dead', 'red', 'forced', 'organic', 'ident', 'lat', 'sgb', 'stamp', 'unused', 'n_unused_spans', 'n_unused_tcrf', 'cat']}
