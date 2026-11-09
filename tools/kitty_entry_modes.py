#!/usr/bin/env python3
"""On which screen each routine entry of the Hello Kitty ROM first runs (L3 context for naming, evidence C).

  tools/kitty_entry_modes.py CORPUS_DIR OUT.csv [SAVE.sav]      (a folder of tools/kitty_coverage.py; 'printer' in its name attaches the printer)

Replays the corpus in the core (each entry from its parent's snapshot) with the conditions of the run (the start save, Kitts 999,999) and,
at every frame, notes the routine entries of trace/trace_kitty.json (not local jr / jp targets) executed for the first time, with the mode
hFF8D and state hFF8E of that frame. Merge the runs with --merge OUT.csv IN.csv ...: roms/hello_kitty/trace/entry_modes_kitty.csv (entry,
first screens, next screens, runs). Mode $1E (the screen fade) runs the set-up of the next screen: next_screens gives, for an entry first
run in mode $1E, the (mode, state) the fade ended on in that replay (the screen the set-up was for); for other entries it repeats the first screen.
"""
import sys, os, json, csv, collections, glob
REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__))); sys.path.insert(0, os.path.join(REPO, 'coverage', 'src'))
if sys.argv[1] == '--merge':
    m = collections.defaultdict(set); nx = collections.defaultdict(set); runs = collections.defaultdict(set)
    for f in sys.argv[3:]:
        for r in csv.DictReader(open(f)):
            m[r['entry']].add(r['first_mode_state']); nx[r['entry']].add(r.get('next_mode_state') or r['first_mode_state']); runs[r['entry']].add(os.path.splitext(os.path.basename(f))[0])
    with open(sys.argv[2], 'w', newline='') as fo:
        w = csv.writer(fo, lineterminator='\n'); w.writerow(['entry', 'first_screens', 'next_screens', 'runs'])
        for k in sorted(m): w.writerow([k, ' '.join(sorted(m[k])), ' '.join(sorted(nx[k])), ' '.join(sorted(runs[k]))])
    sys.exit()
import numpy as np, gbcov as G
rom = os.environ.get('KITTY_ROM', '/root/work/roms/pocketcamera_kitty.gb'); d = sys.argv[1]; out = sys.argv[2]; save = sys.argv[3] if len(sys.argv) > 3 else None
T = json.load(open(os.path.join(REPO, 'roms', 'hello_kitty', 'trace', 'trace_kitty.json')))
def off(k): b, a = int(k[:2], 16), int(k[3:], 16); return a if b == 0 else b * 0x4000 + a - 0x4000
ents = sorted(k for k, w in T['entries'].items() if w not in ('jr', 'jr cc', 'jp'))
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
        ex = G.cov_exec()[offs] > 0
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
    w = csv.writer(f); w.writerow(['entry', 'first_mode_state', 'next_mode_state'])
    for k in ents:
        if k in first: w.writerow([k, first[k], nxt.get(k, first[k])])
print(len(first), 'of', len(ents))
