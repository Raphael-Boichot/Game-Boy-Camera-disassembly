#!/usr/bin/env python3
"""VRAM tile-usage census.  For every organic (mode,state) of a corpus: replay it, then sample the screen while idle and after each key tap.
A catalogued ROM tile block (package/assets/catalog_jp.csv: banked copies into $8000-$97FF) counts as LOADED in a sample when the VRAM bytes equal the ROM bytes;
a tile of a loaded block counts as USED when a visible BG / window cell or an on-screen sprite refers to its VRAM tile index.
Output (json): per block {bank, src, dst, len, loaded:n_samples, used:[per-tile count]} -> unused-tile candidates.  usage: tile_census.py CORPUS OUT.json [--sav NAME] [--sigs a:b,...]"""
import sys, os, json, csv, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import numpy as np
import lib; from lib import g
ROM = np.frombuffer(open(lib.ROM, 'rb').read(), dtype=np.uint8)
args = sys.argv[1:]; corpus, out = args[0], args[1]
sav = args[args.index('--sav') + 1] if '--sav' in args else None
only = None
if '--sigs' in args: only = {tuple(int(x, 16) for x in s.split(':')) for s in args[args.index('--sigs') + 1].split(',')}
blocks = {}
for r in csv.DictReader(open(os.path.join(lib.ROOT, 'package/assets/catalog_jp.csv'))):
    dst = int(r['dst'], 16); ln = int(r['length'], 16); off = int(r['file_offset'], 16)
    if 0x8000 <= dst < 0x9800 and ln % 16 == 0 and ln >= 16 and dst + ln <= 0x9800 and 0 <= off and off + ln <= len(ROM): blocks[(off, dst, ln)] = (int(r['src_bank'], 16), int(r['src'], 16))
BL = sorted(blocks)
cnt_loaded = {b: np.zeros(b[2] // 16, dtype=np.int32) for b in BL}; used = {b: np.zeros(b[2] // 16, dtype=np.int32) for b in BL}
RT = {b: ROM[b[0]:b[0] + b[2]].reshape(-1, 16) for b in BL}
nsamp = 0
def sample():
    global nsamp
    bgp = g.peek(0xFF47); lcdc = g.peek(0xFF40)
    if not (lcdc & 0x80): return
    v = np.array([g.peek(0x8000 + i) for i in range(0x1800)], dtype=np.uint8)
    m = np.array([g.peek(0x9800 + i) for i in range(0x800)], dtype=np.uint8)
    scx, scy, wx, wy = g.peek(0xFF43), g.peek(0xFF42), g.peek(0xFF4B), g.peek(0xFF4A)
    ref = set()
    def tid(n): return n if (lcdc & 0x10) else (256 + n if n < 128 else n)
    if (lcdc & 1) and bgp:
        mb = 0x400 if lcdc & 8 else 0
        for ty in range(((scy) >> 3), ((scy + 143) >> 3) + 1):
            for tx in range(((scx) >> 3), ((scx + 159) >> 3) + 1):
                ref.add(tid(int(m[mb + (ty & 31) * 32 + (tx & 31)])))
    if (lcdc & 0x20) and wy < 144 and wx < 167 and bgp:
        mb = 0x400 if lcdc & 0x40 else 0
        for ty in range(0, ((143 - wy) >> 3) + 1):
            for tx in range(0, ((159 - max(wx - 7, 0)) >> 3) + 1):
                ref.add(tid(int(m[mb + ty * 32 + tx])))
    if lcdc & 2:
        h16 = bool(lcdc & 4)
        for s in range(40):
            y = g.peek(0xFE00 + 4 * s); x = g.peek(0xFE00 + 4 * s + 1); n = g.peek(0xFE00 + 4 * s + 2)
            if 0 < y < 160 and 0 < x < 168:
                if h16: ref.add(n & 0xFE); ref.add(n | 1)
                else: ref.add(n)
    nsamp += 1
    V = v.reshape(-1, 16)
    for b in BL:
        off, dst, ln = b; t0 = (dst - 0x8000) // 16; n = ln // 16
        eq = (V[t0:t0 + n] == RT[b]).all(axis=1)
        if eq.any():
            cnt_loaded[b] += eq
            for k in np.nonzero(eq)[0]:
                if (t0 + int(k)) in ref: used[b][k] += 1
C = lib.Corpus(corpus)
sigs = sorted(set(tuple(e['sig']) for e in C.E.values() if not e.get('tainted') and e['sig'][0] <= 0x21))
t0 = time.time(); done = 0
KEYS = [g.A, g.B, g.START, g.SELECT, g.UP, g.DOWN, g.LEFT, g.RIGHT]
for s in sigs:
    if only and s not in only: continue
    i = C.best(s)
    if i is None: continue
    try:
        g.set_organic(1); C.replay(i, SAV_ := (lib.SAV(sav) if sav else None))
    except Exception as ex: print('fail', s, ex); continue
    s0 = g.snapshot()
    for _ in range(10): sample(); g.run(8)
    for k in KEYS:
        g.restore(s0); g.keys(k); g.run(4); g.keys(0)
        for w in (6, 10, 14, 20): g.run(w); sample()
    done += 1
    if done % 20 == 0: print(done, len(sigs), 'samples', nsamp, '%.0fs' % (time.time() - t0), flush=True)
res = [dict(bank=blocks[b][0], src=blocks[b][1], off=b[0], dst=b[1], len=b[2], loaded=cnt_loaded[b].tolist(), used=used[b].tolist()) for b in BL]
json.dump(dict(samples=nsamp, blocks=res), open(out, 'w'))
print('done', done, 'states', nsamp, 'samples', '%.0fs' % (time.time() - t0))
