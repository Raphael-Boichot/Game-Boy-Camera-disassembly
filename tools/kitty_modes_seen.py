#!/usr/bin/env python3
"""Hello Kitty ROM: every (mode, state) the core runs reached, with a key history that reaches it (L2). Writes
roms/hello_kitty/trace/modes_seen_kitty.csv (mode, state, run, frames, keys, check).

  tools/kitty_modes_seen.py ROM RUN_DIR[,printer][,save=SAVE] ...

Each RUN_DIR is a folder of tools/kitty_coverage.py (corpus.jsonl). The corpus is replayed in the core as tools/kitty_entry_modes.py does
(each entry from its parent's snapshot, the run's start conditions: formatted save or SAVE, Kitts 999,999, printer attached), and at
every frame the pair (hFF8D, hFF8E) is read. A pair keeps the shortest history over all runs, cut at the frame it first appears: keys =
the key byte of every frame from a cold boot (hex, core mask: direction keys low nibble, buttons high; the 250 boot frames included),
replayable as it is. A snapshot replay can drift a frame from a cold-boot replay, so the six shortest candidates are replayed from a cold
boot (no snapshot) and the first that shows the pair is cut at that frame: check 'end' (the history ends on the pair); 'differs' when none
of the six shows it in a cold-boot replay.
Run label = the folder name. Formerly the table named a corpus entry, which named another history whenever the step that reached the
pair added nothing new to the corpus (kitty_coverage.py now records the history itself).
"""
import sys, os, json, csv
REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__))); sys.path.insert(0, os.path.join(REPO, 'coverage', 'src'))
import gbcov as G
ROM = sys.argv[1]; best = {}
def start(save, printer):
    if save: sav = bytearray(open(save, 'rb').read())
    else: G.load_rom(ROM); G.reset(bytes(0x20000)); G.run(600); sav = bytearray(bytes(G.sram()))
    sav[0x100A:0x100D] = bytes([0x99] * 3); G.load_rom(ROM); G.reset(bytes(sav))
    G.L.gb_attach_printer(1 if printer else 0)
    G.run(250); return bytes(sav)
conds = {}
for spec in sys.argv[2:]:
    p = spec.split(','); d = p[0]; run = os.path.basename(d.rstrip('/'))
    printer = 'printer' in p; save = next((x[5:] for x in p if x.startswith('save=')), None); conds[run] = (save, printer)
    start(save, printer); root = G.snapshot()
    K = [bytes.fromhex(json.loads(l)['keys']) for l in open(os.path.join(d, 'corpus.jsonl'))]
    lens = sorted({len(k) for k in K}); byk = {}; parent = []
    for i, k in enumerate(K):
        b = None
        for L in lens:
            if L >= len(k): break
            j = byk.get(k[:L])
            if j is not None: b = j
        parent.append(b); byk.setdefault(k, i)
    need = {q for q in parent if q is not None}; snaps = {}
    def note(n, k):
        m = (G.peek(0xFF8D), G.peek(0xFF8E)); c = best.setdefault(m, [])
        if len(c) < 6 or n < c[-1][1]:
            c.append((run, n, k)); c.sort(key=lambda x: x[1]); del c[6:]
    for i, k in enumerate(K):
        q = parent[i]
        if q is None: G.restore(root); a = 250; note(250, k)
        else: G.restore(snaps[q]); a = len(K[q])
        for n in range(a, len(k)):
            G.keys(k[n]); G.run(1); note(n + 1, k)
        if i in need: snaps[i] = G.snapshot()
    print(run, len(K), 'entries,', len(best), 'pairs so far', flush=True)
rows = []
for m in sorted(best):         # the candidates (6 shortest) replayed from a cold boot: the history is cut where that replay first shows the pair
    for run, n, k in best[m]:
        start(*conds[run]); cut = 250 if (G.peek(0xFF8D), G.peek(0xFF8E)) == m else None
        for j in range(250, len(k) if cut is None else 250):
            G.keys(k[j]); G.run(1)
            if (G.peek(0xFF8D), G.peek(0xFF8E)) == m: cut = j + 1; break
        if cut: rows.append(['%02X' % m[0], '%02X' % m[1], run, cut, k[:cut].hex(), 'end']); break
    else: run, n, k = best[m][0]; rows.append(['%02X' % m[0], '%02X' % m[1], run, n, k[:n].hex(), 'differs'])
with open(os.path.join(REPO, 'roms', 'hello_kitty', 'trace', 'modes_seen_kitty.csv'), 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['mode', 'state', 'run', 'frames', 'keys', 'check']); w.writerows(rows)
print('kitty_modes_seen: %d pairs, %d end on their pair when replayed from a cold boot' % (len(rows), sum(r[5] == 'end' for r in rows)))
