#!/usr/bin/env python3
"""Hello Kitty ROM: the screen on which each sprite layout of bank $03 is first read in a core corpus (step 6 of the unused-asset pass).

  tools/kitty_layout_screens.py CORPUS_DIR OUT.csv [SAVE]

Same replay as tools/kitty_entry_modes.py (each corpus entry from its parent's snapshot), but it watches the first byte of every layout
of bank $03 (cut as tools/kitty_sprite_layouts.py cuts them) in the data-read coverage: OUT.csv = layout, first (mode, state), the
(mode, state) after the fade when the first read happened in mode $1E. Merge several runs with --merge OUT.csv IN1.csv IN2.csv ...
"""
import sys, os, json, csv, collections, glob
REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__))); sys.path.insert(0, os.path.join(REPO, 'coverage', 'src'))
if sys.argv[1] == '--merge':
    m = collections.defaultdict(set); nx = collections.defaultdict(set); runs = collections.defaultdict(set)
    for f in sys.argv[3:]:
        for r in csv.DictReader(open(f)):
            m[r['layout']].add(r['first_mode_state']); nx[r['layout']].add(r.get('next_mode_state') or r['first_mode_state']); runs[r['layout']].add(os.path.splitext(os.path.basename(f))[0])
    with open(sys.argv[2], 'w', newline='') as fo:
        w = csv.writer(fo, lineterminator='\n'); w.writerow(['layout', 'first_screens', 'next_screens', 'runs'])
        for k in sorted(m): w.writerow([k, ' '.join(sorted(m[k])), ' '.join(sorted(nx[k])), ' '.join(sorted(runs[k]))])
    sys.exit()
import numpy as np, gbcov as G
rom = os.environ.get('KITTY_ROM', '/root/work/roms/pocketcamera_kitty.gb'); d = sys.argv[1]; out = sys.argv[2]; save = sys.argv[3] if len(sys.argv) > 3 else None
T = json.load(open(os.path.join(REPO, 'roms', 'hello_kitty', 'port', 'trace_kitty.json')))
def off(k): b, a = int(k[:2], 16), int(k[3:], 16); return a if b == 0 else b * 0x4000 + a - 0x4000
romb = open(rom, 'rb').read(); o3 = 3 * 0x4000; ents = []; a = 0x4000
while a < 0x8000 - 3:
    s0 = a; n = 0
    while a < 0x8000 - 3:
        attr = romb[o3 + a - 0x4000 + 3]; a += 4; n += 1
        if attr & 1 or n > 40: break
    ents.append('03:%04X' % s0)
offs = np.array([off(k) for k in ents])
if save: sav = bytearray(open(save, 'rb').read())
else: G.load_rom(rom); G.reset(bytes(0x20000)); G.run(600); sav = bytearray(bytes(G.sram()))
sav[0x100A:0x100D] = bytes([0x99] * 3); G.load_rom(rom); G.reset(bytes(sav))
if 'printer' in d: G.L.gb_attach_printer(1)
G.run(250)
K = [bytes.fromhex(json.loads(l)['keys']) for l in open(os.path.join(d, 'corpus.jsonl'))]
lens = sorted({len(k) for k in K}); byk = {}; parent = []
for i, k in enumerate(K):
    best = None
    for L in lens:
        if L >= len(k): break
        j = byk.get(k[:L])
        if j is not None: best = j
    parent.append(best); byk.setdefault(k, i)
need = {p for p in parent if p is not None}; snaps = {}; root = G.snapshot()
seen = np.zeros(len(ents), bool); first = {}; nxt = {}
def seg(ks):
    global seen
    pend = []                       # entries first run in the current stretch of mode $1E
    for k in ks:
        G.keys(k); G.run(1)
        ex = G.cov_dread()[offs] > 0
        new = ex & ~seen
        m = '%02X:%02X' % (G.peek(0xFF8D), G.peek(0xFF8E))
        if pend and not m.startswith('1E'):
            for e in pend: nxt[e] = m
            pend = []
        if new.any():
            for i in np.flatnonzero(new):
                first[ents[i]] = m
                if m.startswith('1E'): pend.append(ents[i])
                else: nxt[ents[i]] = m
            seen |= new
for i, k in enumerate(K):
    p = parent[i]
    if p is None: G.restore(root); seg(k[250:] if i else b'')
    else: G.restore(snaps[p]); seg(k[len(K[p]):])
    if i in need: snaps[i] = G.snapshot()
with open(out, 'w', newline='') as f:
    w = csv.writer(f); w.writerow(['layout', 'first_mode_state', 'next_mode_state'])
    for k in ents:
        if k in first: w.writerow([k, first[k], nxt.get(k, first[k])])
print(len(first), 'of', len(ents))
