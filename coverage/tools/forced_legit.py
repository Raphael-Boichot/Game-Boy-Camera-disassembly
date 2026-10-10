#!/usr/bin/env python3
"""Which forced-state executions are credible?  A forced-only executed instruction (executed after a poke / forced mode, never organically) is *credible*
when it is reachable along static control-flow edges (jr/jp/call/fall-through) from organically executed code, or when it is the entry of a dispatch-table
handler (mode table, rst $18 / jump tables, effect and sound tables) that a poke/mode force selected.  Anything else was entered by an edge that is not in the
static control-flow graph (corrupted return address, wild pointer...) and is reported as SUSPECT.
Usage: forced_legit.py OUTDIR merged_cov.npz  -> OUTDIR/forced_legit.md, forced_suspects.csv"""
import sys as _s, os as _o
_s.path.insert(0, _o.path.join(_o.path.dirname(_o.path.abspath(__file__)), '..', 'src'))
import paths
import sys, os, json, csv, collections
import numpy as np
OUT, cov = sys.argv[1], sys.argv[2]
def env(k, d): return os.environ.get(k, d)
src = open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'gating_branches.py')).read()
a = src.index('# ---- decoder'); b = src.index('# predecessor on the linear path')
ROM = env('GBCAM_ROM', paths.ROM); rom = open(ROM, 'rb').read(); N = len(rom); rom += b'\0' * 8
def flat(b, a): return a if b == 0 and a < 0x4000 else b * 0x4000 + (a - 0x4000)
def unflat(f): return (0, f) if f < 0x4000 else (f >> 14, 0x4000 + (f & 0x3FFF))
def fmt(f): b, a = unflat(f); return '%02X:%04X' % (b, a)
exec(src[a:b])
t = json.load(open(env('GBCAM_TRACE', paths.TRACE)))
ilen = np.zeros(N, np.uint8)
for k, n in t['code'].items():
    if n > 0: bb, aa = k.split(':'); ilen[flat(int(bb, 16), int(aa, 16))] = n
z = np.load(cov); oex = z['oex'][:N] == 1; exall = z['ex'][:N] == 1
def flow(f):
    op = rom[f]; L = int(ilen[f]); b1 = rom[f + 1]; w = b1 | rom[f + 2] << 8; bank = f >> 14 if f >= 0x4000 else 0
    def tg(a): return flat(bank if a >= 0x4000 else 0, a) if a < 0x8000 else None
    if op in (0xC9, 0xD9, 0xE9): return []
    if op == 0x18: return [tg((pcof(f) + 2 + s8(b1)) & 0xFFFF)]
    if op == 0xC3: return [tg(w)]
    if op in (0x20, 0x28, 0x30, 0x38): return [tg((pcof(f) + 2 + s8(b1)) & 0xFFFF), f + 2]
    if op in (0xC2, 0xCA, 0xD2, 0xDA, 0xC4, 0xCC, 0xD4, 0xDC, 0xCD): return [tg(w), f + 3]
    return [f + L]
# legit entries: dispatch-table targets and non-DEAD tracer roots
entry = set()
for srcname in ('tables', 'jtables'):
    for k, tg in t[srcname].items():
        bb = int(k.split(':')[0], 16)
        for aa in tg:
            if aa < 0x8000: entry.add(flat(bb if aa >= 0x4000 else 0, aa))
def rw(bank, a): f = flat(bank, a); return rom[f] | rom[f + 1] << 8
for T, n in ((0x41FA, 62), (0x4276, 62), (0x42F2, 10), (0x4306, 10), (0x431A, 18), (0x433E, 18)):
    for i in range(n): entry.add(flat(0x1F, rw(0x1F, T + 2 * i)))
dead = set(); live_roots = set()
for bb, aa, note in json.load(open(env('GBCAM_ROOTS', paths.ROOTS))):
    (dead if 'DEAD-CODE' in note else live_roots).add(flat(bb, aa))
entry |= live_roots
for k, v in t['entries'].items():
    if v in ('rst18', 'jptable', 'far', 'callback', 'vector', 'farjump', 'sym'):
        bb, aa = k.split(':'); entry.add(flat(int(bb, 16), int(aa, 16)))
# closure
ok = oex.copy(); stack = [int(f) for f in np.nonzero(oex & (ilen > 0))[0]]
while stack:
    f = stack.pop()
    for s in flow(f):
        if s is not None and 0 <= s < N and ilen[s] and exall[s] and not ok[s]: ok[s] = True; stack.append(s)
ents = [f for f in entry if exall[f] and not ok[f] and ilen[f]]
for f in ents: ok[f] = True; stack.append(f)
while stack:
    f = stack.pop()
    for s in flow(f):
        if s is not None and 0 <= s < N and ilen[s] and exall[s] and not ok[s]: ok[s] = True; stack.append(s)
sus = [int(f) for f in np.nonzero(exall & (ilen > 0) & ~ok)[0]]
forced = int((exall & ~oex & (ilen > 0)).sum())
# group suspects into runs
sus.sort(); runs = []
for f in sus:
    if runs and f - runs[-1][1] <= 3: runs[-1][1] = f; runs[-1][2] += 1
    else: runs.append([f, f, 1])
with open(os.path.join(OUT, 'forced_suspects.csv'), 'w', newline='') as fh:
    w = csv.writer(fh); w.writerow(['first', 'last', 'instrs', 'dead_root_inside']);
    for s, e, n in runs: w.writerow([fmt(s), fmt(e), n, int(any(s <= d <= e for d in dead))])
with open(os.path.join(OUT, 'forced_legit.md'), 'w') as fh:
    fh.write('# Credibility of forced-state coverage\n\nInstructions executed only in forced-state runs: **%d**. Reachable along static control flow from organic code or entered at a dispatch-table / root entry: **%d**. '
             'Suspect (entered by an edge that is not in the static CFG): **%d** instructions in %d runs.\n\n' % (forced, forced - len(sus), len(sus), len(runs)))
    fh.write('| first | last | instrs | contains a DEAD-CODE root |\n|---|---|---:|---|\n')
    for s, e, n in runs[:60]: fh.write('| %s | %s | %d | %s |\n' % (fmt(s), fmt(e), n, 'yes' if any(s <= d <= e for d in dead) else ''))
print(open(os.path.join(OUT, 'forced_legit.md')).read()[:3000])
