#!/usr/bin/env python3
"""Data kinds of the Hello Kitty ROM for its layout map: roms/hello_kitty/assets/layout_kind_overrides_kitty.csv (generated).

  tools/kitty_layout_kinds.py KITTY_ROM [--track roms/hello_kitty/port/display_kitty.npz] [--out roms/hello_kitty/assets/layout_kind_overrides_kitty.csv]

The automatic labels of the data blocks (Data_BB_AAAA) carry no kind, so tcrf_check/tools/rom_layout_map.py draws them UNCERTAIN. This
script gives a kind to the bytes of those blocks from four kinds of evidence, the first that applies wins:
  1 tiles / map, C: the bytes are a 16-byte window seen in VRAM tile memory / in a BG map row while the core corpora were replayed
    (tools/kitty_display_track.py, value-matched; only windows of 3+ distinct values that a run read)
  2 tiles / map, C: a copy routine called with a constant source copies them to tile memory / to a BG map (assets/copy_sites_kitty.csv)
  3 sound, C: the first instruction that read them is in bank $0F, the sound driver (port/cov_kitty_runs.npz, reader)
  4 sprite layouts and object scripts, I: the first instruction that read them is the object engine (00:1F00-00:2242)
One row per run of equal kind inside one block: bank, start, end (exclusive), kind (T_UI / MAP / SOUND / OAM), ev, label, basis.
The rest of each block stays UNCERTAIN. Prints the bytes per kind and per evidence (the Kitty README quotes them).
"""
import os, csv, argparse, bisect, collections
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); KD = os.path.join(REPO, 'roms', 'hello_kitty')
ap = argparse.ArgumentParser(); ap.add_argument('--track', default=os.path.join(KD, 'port', 'display_kitty.npz'))
ap.add_argument('--out', default=os.path.join(KD, 'assets', 'layout_kind_overrides_kitty.csv')); ap.add_argument('rom'); a = ap.parse_args()
N = 0x100000
def off(b, ad): return ad if b == 0 else b * 0x4000 + ad - 0x4000
def addr(o): return (o >> 14, o & 0x3FFF if o < 0x4000 else 0x4000 + (o & 0x3FFF))
code = np.zeros(N, bool)
for r in csv.DictReader(open(os.path.join(KD, 'port', 'rom_map_kitty.csv'))):
    if r['class'] != 'R': o = off(int(r['bank'], 16), int(r['start'], 16)); code[o:o + int(r['length'])] = True
names = {}
for f in ('sym_names_kitty.csv',):
    for r in csv.DictReader(open(os.path.join(KD, 'disasm', f))): names[off(int(r['bank'], 16), int(r['addr'], 16))] = r['name']
lo = sorted(names)
owner = np.full(N, -1, np.int64)
for i, o in enumerate(lo):
    e = lo[i + 1] if i + 1 < len(lo) else N
    e = min(e, (o // 0x4000 + 1) * 0x4000)
    owner[o:e] = o
isdata = (owner >= 0) & ~code
isdata[isdata] = [names[o].startswith('Data_') for o in owner[isdata]]
rom = np.frombuffer(open(a.rom, 'rb').read(), np.uint8) if a.rom else None
if rom is not None:          # runs of 16+ x $00 / $FF: the layout map draws them as padding / fill, they get no kind here
    i = 0
    while i < N:
        j = i
        while j < N and rom[j] == rom[i]: j += 1
        if j - i >= 16 and rom[i] in (0, 0xFF): isdata[i:j] = False
        i = j
KIND = np.zeros(N, np.uint8); EV = np.zeros(N, np.uint8)        # kinds 1 T_UI, 2 MAP, 3 SOUND, 4 OAM; evidence rule 1-4
def put(m, k, ev):
    m = m & isdata & (KIND == 0); KIND[m] = k; EV[m] = ev
t = np.load(a.track); put(t['tiles'] > 0, 1, 1); put(t['map'] > 0, 2, 1)
cs = np.zeros(N, np.uint8)
for r in csv.DictReader(open(os.path.join(KD, 'assets', 'copy_sites_kitty.csv'))):
    if not r['src'] or not r['src_bank'] or not r['len'] or r['dst_kind'] not in ('tiles', 'map') or int(r['src'], 16) >= 0x8000: continue
    o = off(int(r['src_bank'], 16), int(r['src'], 16)); cs[o:o + int(r['len'], 16)] = 1 if r['dst_kind'] == 'tiles' else 2
put(cs == 1, 1, 2); put(cs == 2, 2, 2)
rd = np.load(os.path.join(KD, 'port', 'cov_kitty_runs.npz'))['reader'].astype(np.int64)
rb = (rd >> 16) & 0xFF; pc = rd & 0xFFFF
put((rd != 0) & (rb == 0x0F) & (pc >= 0x4000), 3, 3)
put((rd != 0) & (pc >= 0x1F00) & (pc < 0x2243), 4, 4)
KN = {1: 'T_UI', 2: 'MAP', 3: 'SOUND', 4: 'OAM'}
EVT = {1: ('C', 'seen in VRAM %s while the core corpora were replayed (tools/kitty_display_track.py)'), 2: ('C', 'copied to %s by a copy routine with a constant source (assets/copy_sites_kitty.csv)'),
       3: ('C', 'first read by the sound driver (bank $0F) in the core runs'), 4: ('I', 'first read by the object engine (00:1F00-00:2242) in the core runs')}
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
print('kitty_layout_kinds: %d rows, %d bytes of Data_ blocks given a kind (T_UI %d, MAP %d, SOUND %d, OAM %d); %d bytes of Data_ blocks left' % (
    len(rows), sum(tot.values()), by_kind['T_UI'], by_kind['MAP'], by_kind['SOUND'], by_kind['OAM'], int((isdata & (KIND == 0)).sum())))
print('by evidence rule:', {('%s/%d' % k): v for k, v in sorted(tot.items())})
