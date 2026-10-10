#!/usr/bin/env python3
"""Per-bank state machine ($D5CF) coverage: which state handlers (inline `ld a,[$D5CF]; rst $18` tables) ran, and which static writers of $D5CF exist for each state
and whether those writers ran. Output: state_graph.csv, state_graph.md.   Usage: state_graph.py OUTDIR merged_cov.npz"""
import sys as _s, os as _o
_s.path.insert(0, _o.path.join(_o.path.dirname(_o.path.abspath(__file__)), '..', 'src'))
import paths
import sys, os, json, csv, collections
import numpy as np
OUT, cov = sys.argv[1], sys.argv[2]
def env(k, d): return os.environ.get(k, d)
rom = open(env('GBCAM_ROM', paths.ROM), 'rb').read(); N = len(rom); rom += b'\0' * 8
t = json.load(open(env('GBCAM_TRACE', paths.TRACE)))
def flat(b, a): return a if b == 0 and a < 0x4000 else b * 0x4000 + (a - 0x4000)
def fmt(f): return '%02X:%04X' % ((0, f)[0] if f < 0x4000 else f >> 14, f if f < 0x4000 else 0x4000 + (f & 0x3FFF))
ilen = np.zeros(N, np.uint8)
for k, n in t['code'].items():
    if n > 0: b, a = k.split(':'); ilen[flat(int(b, 16), int(a, 16))] = n
z = np.load(cov); ex = z['ex'][:N] == 1
sym = {}
for ln in open(env('GBCAM_SYM', paths.SYM)):
    ln = ln.split(';')[0].split()
    if len(ln) == 2 and ':' in ln[0]:
        b, a = ln[0].split(':'); sym[(int(b, 16), int(a, 16))] = ln[1]
tables = []
for k, tg in t['tables'].items():
    b, a = k.split(':'); b = int(b, 16); a = int(a, 16); f = flat(b, a)
    if f >= 4 and rom[f - 4:f] == bytes([0xFA, 0xCF, 0xD5, 0xDF]): tables.append((b, a, f, tg))
tables.sort()
# writers of $D5CF per bank: (flat addr, kind, value)
writers = collections.defaultdict(list)
starts = np.nonzero(ilen > 0)[0]
for f in starts:
    f = int(f); bank = 0 if f < 0x4000 else f >> 14
    if rom[f:f + 3] == bytes([0xEA, 0xCF, 0xD5]):
        # previous instruction in linear order
        pv = None
        for L in (1, 2, 3):
            p = f - L
            if p >= 0 and ilen[p] == L and p + L == f: pv = p; break
        if pv is not None and rom[pv] == 0x3E: v = rom[pv + 1]
        elif pv is not None and rom[pv] == 0xAF: v = 0
        else: v = None
        writers[bank].append((f, 'ld [d5cf],a', v))
    if rom[f:f + 3] == bytes([0x21, 0xCF, 0xD5]):
        nxt = f + 3
        if ilen[nxt] and rom[nxt] == 0x34: writers[bank].append((f, 'inc [d5cf]', None))
        elif ilen[nxt] and rom[nxt] == 0x36: writers[bank].append((f, 'ld [d5cf],imm', rom[nxt + 1]))
        elif ilen[nxt] and rom[nxt] == 0x35: writers[bank].append((f, 'dec [d5cf]', None))
rows = []; md = ['# Mode state-machine coverage ($D5CF dispatch tables)\n']
for b, a, f, tg in tables:
    nh = len(set(tg)); md.append('\n## Bank %02X, dispatch at %02X:%04X (%d states)\n' % (b, b, a - 4, len(tg)))
    md.append('| state | handler | executed | static writers of this state value (executed?) |\n|---:|---|---|---|\n')
    ws = writers.get(b, []); incs = [w for w in ws if w[1].startswith('inc') or w[1].startswith('dec')]
    for i, h in enumerate(tg):
        hf = flat(b if h >= 0x4000 else 0, h); done = bool(ex[hf]) if ilen[hf] else False
        wl = [w for w in ws if w[2] == i]
        wtxt = ', '.join('%s%s' % (fmt(w[0]), '' if ex[w[0]] else ' (never)') for w in wl) or '-'
        rows.append([b, i, '%02X:%04X' % (b, h), sym.get((b, h), ''), int(done), wtxt])
        md.append('| %d | %02X:%04X %s | %s | %s |\n' % (i, b, h, sym.get((b, h), ''), 'yes' if done else '**NO**', wtxt))
    if incs: md.append('\nIncrement/decrement writers in this bank: ' + ', '.join('%s %s' % (fmt(w[0]), 'ran' if ex[w[0]] else 'never') for w in incs) + '\n')
with open(os.path.join(OUT, 'state_graph.csv'), 'w', newline='') as fh:
    w = csv.writer(fh); w.writerow(['bank', 'state', 'handler', 'symbol', 'executed', 'static_writers']); w.writerows(rows)
open(os.path.join(OUT, 'state_graph.md'), 'w').write(''.join(md))
nn = [(r[0], r[1], r[2], r[3]) for r in rows if not r[4]]
print(len(tables), 'state tables;', len(rows), 'state slots;', len(nn), 'never executed:')
for r in nn: print('  bank %02X state %2d  %s %s' % r)
