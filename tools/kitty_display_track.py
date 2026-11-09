#!/usr/bin/env python3
"""Display tracker of the Hello Kitty ROM: replays the core corpora and records what reaches VRAM (evidence for the data kinds of the layout map).

  tools/kitty_display_track.py ROM OUT.npz --run DIR[,save=S.sav][,printer] [--run ...] [--every 8]

Each --run is an output folder of tools/kitty_coverage.py (corpus.jsonl) with the conditions it was made with: the start save (default:
the formatted save, 600 core frames on an all-$00 SRAM) with the Kitt counter set to 999,999 like the run, and the printer model on
the link. The entries are replayed from their parent entry's snapshot (the longest earlier entry whose keys are a prefix), so each frame
of the corpus runs about once. Every --every frames the tile memory $8000-$97FF and the two BG maps $9800-$9FFF are read; at the end,
every 16-byte window of the ROM whose 16 bytes were read by a run (trace/cov_kitty_runs.npz) and are not a fill (3 or more distinct values) is
looked up among the 16-byte tiles seen in tile memory (kind tiles) and among the 16-byte windows of the 32-byte BG map rows (kind map).
OUT.npz: tiles, map (uint8 per ROM byte: 1 = a matched window covers it), samples, frames. A tile or map row that holds the same bytes
as ROM data read by a run is taken as copied from it (evidence C for the kind, value-matched like the Japanese display tracker).
"""
import sys, os, json, argparse, time
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); sys.path.insert(0, os.path.join(REPO, 'coverage', 'src'))
import numpy as np, gbcov as G
ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('out'); ap.add_argument('--run', action='append', required=True)
ap.add_argument('--every', type=int, default=8); a = ap.parse_args()
tiles, rows = set(), set(); samples = frames = 0; t0 = time.time()
def sample():
    global samples
    v = bytes(G.peek(0x8000 + i) for i in range(0x2000)); samples += 1
    for i in range(0, 0x1800, 16): tiles.add(v[i:i + 16])
    for i in range(0x1800, 0x2000, 32):
        r = v[i:i + 32]
        for j in range(17): rows.add(r[j:j + 16])
def run_keys(ks):
    global frames
    for n, k in enumerate(ks):
        G.keys(k); G.run(1); frames += 1
        if frames % a.every == 0: sample()
for spec in a.run:
    parts = spec.split(','); d = parts[0]; opts = dict(p.split('=', 1) if '=' in p else (p, '1') for p in parts[1:])
    if 'save' in opts: sav = bytearray(open(opts['save'], 'rb').read())
    else:
        G.load_rom(a.rom); G.reset(bytes(0x20000)); G.run(600); sav = bytearray(bytes(G.sram()))
    sav[0x100A:0x100D] = bytes([0x99, 0x99, 0x99])
    G.load_rom(a.rom); G.reset(bytes(sav))
    if 'printer' in opts: G.L.gb_attach_printer(1)
    G.run(250)
    E = [json.loads(l) for l in open(os.path.join(d, 'corpus.jsonl'))]
    K = [bytes.fromhex(e['keys']) for e in E]
    lens = sorted({len(k): i for i, k in reversed(list(enumerate(K)))}.items())
    byk = {}; parent = [None] * len(K)
    for i, k in enumerate(K):
        best = None
        for L, _ in lens:
            if L >= len(k): break
            j = byk.get(k[:L])
            if j is not None: best = j
        parent[i] = best; byk.setdefault(k, i)
    need = {p for p in parent if p is not None}
    snaps = {}
    root = G.snapshot()
    for i, k in enumerate(K):
        p = parent[i]
        if p is None: G.restore(root); run_keys(k[250:] if i else b'')
        else: G.restore(snaps[p]); run_keys(k[len(K[p]):])
        if i in need: snaps[i] = G.snapshot()
        if i % 200 == 0: print('%s: entry %d / %d, frames %d, samples %d, tiles %d, rows %d, %.0f s' % (d, i, len(K), frames, samples, len(tiles), len(rows), time.time() - t0), flush=True)
    snaps.clear()
rom = open(a.rom, 'rb').read(); N = len(rom)
rd = np.load(os.path.join(REPO, 'roms', 'hello_kitty', 'trace', 'cov_kitty_runs.npz'))['dread'] > 0
ok = np.convolve(rd.astype(np.int32), np.ones(16, np.int32), 'full')[15:15 + N] == 16        # window o..o+15 all read (index = start)
T = np.zeros(N, np.uint8); M = np.zeros(N, np.uint8)
for o in np.flatnonzero(ok[:N - 15]):
    w = rom[o:o + 16]
    if len(set(w)) < 3: continue
    if w in tiles: T[o:o + 16] = 1
    elif w in rows: M[o:o + 16] = 1
np.savez_compressed(a.out, tiles=T, map=M, samples=samples, frames=frames)
print('kitty_display_track: %d frames, %d samples, %d distinct tiles, %d map windows; ROM bytes matched: tiles %d, map %d' % (frames, samples, len(tiles), len(rows), int(T.sum()), int(M.sum())))
