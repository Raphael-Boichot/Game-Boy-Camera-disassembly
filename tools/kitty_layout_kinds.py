#!/usr/bin/env python3
"""Data kinds of the Hello Kitty ROM for its layout map: roms/hello_kitty/assets/layout_kind_overrides_kitty.csv (generated).

  tools/kitty_layout_kinds.py KITTY_ROM [--track roms/hello_kitty/trace/display_kitty.npz] [--out roms/hello_kitty/assets/layout_kind_overrides_kitty.csv]

Labels whose name carries no kind (Data_, Src_, Leftover_; tools/kitty_data_names.py names the other blocks with their kind from the
same evidence, evidence()) are drawn UNCERTAIN by tcrf_check/tools/rom_layout_map.py. This script gives a kind to the bytes of those blocks from five kinds of evidence, the first that applies wins:
  0 role, C: the Japanese kinds where a loader of this ROM proves the role of the asset (code read, the runs and BGB show the loader at work):
    T_FRM the six print frames (blocks of $1500 named by the table 01:687D that PrintFrame_LoadTiles reads) and the 108 camera-frame
          pictures ($380 each, named by the table 07:41CE that FrameCorner_Draw reads);
    the Super Game Boy transfers of bank $08 (Sgb_VramTransferInline: a 16-byte packet, then the data): CHR_TRN data T_UI (border
          tiles), PCT_TRN data MAP (border map, $800) and PALT (its palettes), PAL_TRN data PALT, ATTR_TRN data and the packets TBL
  1 tiles / map, C: the bytes are a 16-byte window seen in VRAM tile memory / in a BG map row while the core corpora were replayed
    (tools/kitty_display_track.py, value-matched; only windows of 3+ distinct values that a run read)
  2 tiles / map, C: a copy routine called with a constant source copies them to tile memory / to a BG map (assets/copy_sites_kitty.csv)
  3 sound, C: the first instruction that read them is in bank $0F, the sound driver (trace/cov_kitty_runs.npz, reader)
  4 sprite layouts and object scripts, I: the first instruction that read them is the object engine (00:1F00-00:2242)
  6 owner, I: the kind the owner gives a bank range by eye (assets/layout_kind_owner_kitty.csv, 2026-11-12), for the bytes no rule above
    types; for the layout map only (the names of tools/kitty_data_names.py keep rules 0-4)
One row per run of equal kind inside one block: bank, start, end (exclusive), kind (T_UI / MAP / SOUND / OAM), ev, label, basis.
The rest of each block stays UNCERTAIN. Prints the bytes per kind and per evidence (the Kitty README quotes them).
"""
import os, csv, argparse, bisect, collections
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); KD = os.path.join(REPO, 'roms', 'hello_kitty')
N = 0x100000
def off(b, ad): return ad if b == 0 else b * 0x4000 + ad - 0x4000
def addr(o): return (o >> 14, o & 0x3FFF if o < 0x4000 else 0x4000 + (o & 0x3FFF))
def evidence(rom_path, track, kd=KD):
    """KIND (1 T_UI, 2 MAP, 3 SOUND, 4 OAM, 5 T_FRM, 6 PALT, 7 TBL, 0 none) and EV (the rule, 5 = rule 0) of every byte that is not
    code and not in a run of 16+ x $00 / $FF, whatever its label (tools/kitty_data_names.py names the blocks from it)"""
    code = np.zeros(N, bool)
    for r in csv.DictReader(open(os.path.join(kd, 'trace', 'rom_map_kitty.csv'))):
        if r['class'] != 'R': o = off(int(r['bank'], 16), int(r['start'], 16)); code[o:o + int(r['length'])] = True
    rom = np.frombuffer(open(rom_path, 'rb').read(), np.uint8); ok = ~code; i = 0
    while i < N:              # runs of 16+ x $00 / $FF: the layout map draws them as padding / fill, they get no kind here
        j = i
        while j < N and rom[j] == rom[i]: j += 1
        if j - i >= 16 and rom[i] in (0, 0xFF): ok[i:j] = False
        i = j
    KIND = np.zeros(N, np.uint8); EV = np.zeros(N, np.uint8)
    def put(m, k, ev):
        m = m & ok & (KIND == 0); KIND[m] = k; EV[m] = ev
    R = bytes(rom)
    role = np.zeros(N, np.uint8)
    t0 = off(1, 0x687D)                      # print frames: {lo, hi, bank} x 6 read by PrintFrame_LoadTiles / PrintFrame_LoadPart
    for i in range(6):
        lo_, hi_, bk = R[t0 + 3 * i:t0 + 3 * i + 3]; role[off(bk, hi_ << 8 | lo_):off(bk, hi_ << 8 | lo_) + 0x1500] = 5
    t1 = off(7, 0x41CE); i = 0                # camera-frame pictures: {lo, hi, bank} records read by FrameCorner_Draw, $380 bytes each
    while True:
        lo_, hi_, bk = R[t1 + 3 * i:t1 + 3 * i + 3]
        if not (0x40 <= hi_ < 0x80 and 0x20 <= bk < 0x40 and lo_ in (0, 0x80)): break
        role[off(bk, hi_ << 8 | lo_):off(bk, hi_ << 8 | lo_) + 0x380] = 5; i += 1
    assert i == 108, i
    for src, nxt in ((0x40D0, 0x4146), (0x4146, 0x41F6), (0x41F6, 0x5206), (0x5206, 0x6216), (0x6216, 0x6A86)):   # the five transfers of bank $08 (next = next packet or code)
        o = off(8, src); cmd = R[o] >> 3; role[o:o + 16] = 7
        if cmd == 0x13: role[o + 16:off(8, nxt)] = 1                                  # CHR_TRN: border tiles
        elif cmd == 0x14: role[o + 16:o + 16 + 0x800] = 2; role[o + 16 + 0x800:off(8, nxt)] = 6     # PCT_TRN: border map, then palettes
        elif cmd == 0x0B: role[o + 16:off(8, nxt)] = 6                                 # PAL_TRN
        elif cmd == 0x15: role[o + 16:off(8, nxt)] = 7                                 # ATTR_TRN
        else: raise SystemExit('unexpected SGB packet %02X at 08:%04X' % (R[o], src))
    for k in (5, 6, 7, 1, 2): put(role == k, k, 5)
    t = np.load(track); put(t['tiles'] > 0, 1, 1); put(t['map'] > 0, 2, 1)
    cs = np.zeros(N, np.uint8)
    for r in csv.DictReader(open(os.path.join(kd, 'assets', 'copy_sites_kitty.csv'))):
        if not r['src'] or not r['src_bank'] or not r['len'] or r['dst_kind'] not in ('tiles', 'map') or int(r['src'], 16) >= 0x8000: continue
        o = off(int(r['src_bank'], 16), int(r['src'], 16)); cs[o:o + int(r['len'], 16)] = 1 if r['dst_kind'] == 'tiles' else 2
    put(cs == 1, 1, 2); put(cs == 2, 2, 2)
    rd = np.load(os.path.join(kd, 'trace', 'cov_kitty_runs.npz'))['rdr'].astype(np.int64)
    rb = (rd >> 16) & 0xFF; pc = rd & 0xFFFF
    put((rd != 0) & (rb == 0x0F) & (pc >= 0x4000), 3, 3)
    put((rd != 0) & (pc >= 0x1F00) & (pc < 0x2243), 4, 4)
    return KIND, EV, code
NOKIND = ('Data_', 'Src_', 'Leftover_')                  # labels whose name carries no kind (tools/kitty_data_names.py gives the others one)
if __name__ == '__main__':
    ap = argparse.ArgumentParser(); ap.add_argument('--track', default=os.path.join(KD, 'trace', 'display_kitty.npz'))
    ap.add_argument('--out', default=os.path.join(KD, 'assets', 'layout_kind_overrides_kitty.csv')); ap.add_argument('rom'); a = ap.parse_args()
    KIND, EV, code = evidence(a.rom, a.track)
    # rule 6, the owner's kinds by eye: for the layout map only (tools/kitty_data_names.py keeps the evidence of rules 0-4 for the names)
    _ok = ~code                    # runs of $00 / $FF inside these ranges are part of the assets (the owner's reading of the whole range)
    KK = {'T_UI': 1, 'MAP': 2, 'SOUND': 3, 'OAM': 4, 'T_FRM': 5, 'PALT': 6, 'TBL': 7}
    for r in csv.DictReader(open(os.path.join(KD, 'assets', 'layout_kind_owner_kitty.csv'), encoding='utf-8')):
        b = int(r['bank'], 16); o0, o1 = off(b, int(r['start'], 16)), off(b, int(r['end'], 16))
        m = np.zeros(N, bool); m[o0:o1] = True; m &= _ok & (KIND == 0); KIND[m] = KK[r['kind']]; EV[m] = 6
    names = {}
    for r in csv.DictReader(open(os.path.join(KD, 'disasm', 'sym_names_kitty.csv'))): names[off(int(r['bank'], 16), int(r['addr'], 16))] = r['name']
    lo = sorted(names)
    owner = np.full(N, -1, np.int64)
    for i, o in enumerate(lo):
        e = lo[i + 1] if i + 1 < len(lo) else N
        e = min(e, (o // 0x4000 + 1) * 0x4000)
        owner[o:e] = o
    isdata = (owner >= 0) & ~code
    isdata[isdata] = [names[o].startswith(NOKIND) for o in owner[isdata]]
    KIND[~isdata] = 0
    KN = {1: 'T_UI', 2: 'MAP', 3: 'SOUND', 4: 'OAM', 5: 'T_FRM', 6: 'PALT', 7: 'TBL'}
    EVT = {1: ('C', 'seen in VRAM %s while the core corpora were replayed (tools/kitty_display_track.py)'), 2: ('C', 'copied to %s by a copy routine with a constant source (assets/copy_sites_kitty.csv)'),
           3: ('C', 'first read by the sound driver (bank $0F) in the core runs'), 4: ('I', 'first read by the object engine (00:1F00-00:2242) in the core runs'),
           5: ('C', 'role from its loader: print frame (table 01:687D), camera-frame picture (table 07:41CE) or Super Game Boy transfer (bank $08)'),
           6: ('I', 'owner, by eye (2026-11-12): the kind of this bank range in assets/layout_kind_owner_kitty.csv')}
    rows = []; tot = collections.Counter()
    nz = np.flatnonzero(KIND)
    if len(nz):
        cut = np.flatnonzero((np.diff(nz) > 1) | (np.diff(KIND[nz]) != 0) | (np.diff(EV[nz]) != 0) | (np.diff(owner[nz]) != 0)) + 1
        for seg in np.split(nz, cut):
            s, e = int(seg[0]), int(seg[-1]) + 1; k, ev = int(KIND[s]), int(EV[s]); b, ad = addr(s)
            where = {1: 'tile memory', 2: 'a BG map'}.get(k, '')
            rows.append(['%02X' % b, '%04X' % ad, '%04X' % (ad + e - s), KN[k], EVT[ev][0], names[int(owner[s])], EVT[ev][1] % where if '%s' in EVT[ev][1] else EVT[ev][1]])
            tot[(KN[k], ev)] += e - s
    with open(a.out, 'w', newline='') as f:
        w = csv.writer(f, lineterminator='\n'); w.writerow(['bank', 'start', 'end', 'kind', 'ev', 'label', 'basis']); w.writerows(rows)
    by_kind = collections.Counter()
    for (k, ev), v in tot.items(): by_kind[k] += v
    print('kitty_layout_kinds: %d rows, %d bytes of kind-less blocks given a kind (T_UI %d, MAP %d, SOUND %d, OAM %d, T_FRM %d, PALT %d, TBL %d); %d bytes of kind-less blocks left' % (
        len(rows), sum(tot.values()), by_kind['T_UI'], by_kind['MAP'], by_kind['SOUND'], by_kind['OAM'], by_kind['T_FRM'], by_kind['PALT'], by_kind['TBL'], int((isdata & (KIND == 0)).sum())))
    print('by evidence rule:', {('%s/%d' % k): v for k, v in sorted(tot.items())})
