#!/usr/bin/env python3
"""Sort the code that no run executed by what keeps it from running (README 16.15).
usage: reach_analysis.py OUT_DIR [ROM] [--manual FILE]       (run from anywhere; ROM defaults to ./pocketcamera_jp.gb, the Japanese Rev A)
Reads (all in the repository): coverage/results/report_v8/rom_map.csv (byte classes of the v8 run), assets/witness_jp.csv (class N bytes that a later run executed:
  16.14), wram/trace_jp_v3.json (static trace), tools/extra_roots.json (hand-resolved roots), wram/wram_*.csv (variable names),
  assets/reach_manual_jp.csv (hand-written verdicts keyed by the first address of a component; may be missing)
Writes: OUT_DIR/reach_components.csv (one row per never-run component), OUT_DIR/reach_summary.md, OUT_DIR/cov_with_witness.npz (intermediate)
What it does:
 1. rebuilds the executed-byte arrays from the map (C, F = executed; N = not) and sets the witnessed bytes, then runs the component analysis of
    coverage/tools/gating_branches.py (components of never-run traced instructions: GATED / TABLE / DEAD / ORPHAN, the gating branch and the variable it tests);
 2. automatic checks:  (a) dead roots: scan the ROM for anything that could point at the root (call / jp / jr, ld rr,nn with a matching bank, and 16-bit words in the
    code banks that sit in a pointer-like table), (b) the 96-entry effect table 0A:541A: the index is read from the 88-byte table 06:60DB (OR $00 / $20 / $40) at the
    only call site 06:781A, so the values that table can produce are enumerated and compared with the slots whose code never ran, (c) one-instruction components behind a
    carry / zero test (pointer arithmetic edge);
 3. merges the manual verdicts.
Verdicts: INPUT (the condition can be produced with the joypad and the save; recipe in the note), PRINTER (needs a printer reply that no status-injection run produced; none left after README 16.16),
LINK (needs a link partner), UNREACHABLE (static argument: nothing can select it), UNREFERENCED (dead root, no reference found), EDGE (arithmetic edge case), OPEN.
Evidence: C = executed in a run, I = inferred from the code, ? = not analysed."""
import sys, os, re, csv, json, collections
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(os.path.dirname(HERE))
a = sys.argv[1:]
def opt(n, d=None):
    if n in a: i = a.index(n); v = a[i + 1]; del a[i:i + 2]; return v
    return d
MANUAL = opt('--manual', os.path.join(REPO, 'assets', 'reach_manual_jp.csv'))
OUT = a[0]; ROM = a[1] if len(a) > 1 else 'pocketcamera_jp.gb'
os.makedirs(OUT, exist_ok=True)
MAP = os.path.join(REPO, 'coverage', 'results', 'report_v8', 'rom_map.csv'); WIT = os.path.join(REPO, 'assets', 'witness_jp.csv')
GATING = os.path.join(REPO, 'coverage', 'tools', 'gating_branches.py')
def flat(b, ad): return ad if (b == 0 and ad < 0x4000) else b * 0x4000 + ad - 0x4000
# ---- 1. coverage arrays from the map + witnesses
N = 1 << 20
ex = np.zeros(N, np.uint8); oex = np.zeros(N, np.uint8)
for r in csv.DictReader(open(MAP)):
    o = flat(int(r['bank'], 16), int(r['start'], 16)); n = int(r['length'])
    if r['class'] == 'C': ex[o:o + n] = 1; oex[o:o + n] = 1
    elif r['class'] == 'F': ex[o:o + n] = 1
wit = 0
for r in csv.DictReader(open(WIT)):
    b = int(r['bank'], 16); o1 = flat(b, int(r['start'], 16)); o2 = flat(b, int(r['end'], 16)); ex[o1:o2 + 1] = 1; wit += o2 - o1 + 1
npz = os.path.join(OUT, 'cov_with_witness.npz'); np.savez(npz, ex=ex, oex=oex)
# ---- component analysis (the code of gating_branches.py up to the sort of its table)
os.environ.update(GBCAM_ROM=ROM, GBCAM_TRACE=os.path.join(REPO, 'wram', 'trace_jp_v3.json'), GBCAM_ROOTS=os.path.join(REPO, 'tools', 'extra_roots.json'),
                  GBCAM_WRAM_DIR=os.path.join(REPO, 'wram'))
src = open(GATING).read().split('rows.sort(')[0]
G = {'__file__': GATING, '__name__': 'gating'}
sys.argv = ['gating_branches.py', OUT, npz]
exec(compile(src, GATING, 'exec'), G)
rom = G['rom']; ilen = G['ilen']; comp = G['comp']; rows = G['rows']; fmt = G['fmt']; mnem = G['mnem']; into = G['into']; vname = G['vname']; tested_var = G['tested_var']
roots = json.load(open(os.environ['GBCAM_ROOTS'])); NR = len(rom) - 4
def A(f): return 0x4000 + (f & 0x3FFF) if f >= 0x4000 else f
def B(f): return (f >> 14) if f >= 0x4000 else 0
istart = bytearray(NR); owner = [-1] * NR
for f in range(NR):
    if ilen[f]:
        istart[f] = 1
        for k in range(int(ilen[f])): owner[f + k] = f
CODEBANKS = (set(range(0, 0x0B)) - {1}) | {0x1F}                  # bank 1 holds sprite-composition lists (data), not code
# ---- 2a. dead-root reference scan
def prev_ld_a(f): return rom[f - 1] if f >= 2 and rom[f - 2] == 0x3E and istart[f - 2] else None
def scan_root(b, ad):
    lo, hi = ad & 0xFF, ad >> 8; code = []; data = []
    for f in range(NR - 1):
        if rom[f] != lo or rom[f + 1] != hi: continue
        sb = B(f); o = owner[f]
        if o >= 0:
            if o == f - 1 and ilen[o] == 3 and rom[o] in (0x01, 0x11, 0x21, 0xCD, 0xC3, 0xC2, 0xCA, 0xD2, 0xDA, 0xC4, 0xCC, 0xD4, 0xDC):
                if ad < 0x4000 or sb == b or prev_ld_a(o) == b: code.append('%02X:%04X %s' % (sb, A(o), mnem(o)))
        elif sb in CODEBANKS:
            nb = sum(1 for d in (-4, -2, 2, 4) if 0 <= f + d < NR - 1 and 0x4000 <= (rom[f + d] | rom[f + d + 1] << 8) < 0x8000)
            if nb >= 2 and (ad < 0x4000 or sb == b or sb == 0): data.append('%02X:%04X' % (sb, A(f)))
    return code, data
# ---- 2b. effect table 0A:541A: index domain
TB, TA, TN = 6, 0x60DB, 88                                    # index table in bank 6, 4 * variant ($D7E3 <= $15) + phase ($D7E4 <= 3)
callers = [m.start() for m in re.finditer(rb'\x3e\x0a\x21\xfe\x7c\xcd\xc1\x08', rom[:NR])]
tab = rom[flat(TB, TA):flat(TB, TA) + TN]
DOMAIN = {v | e for v in tab for e in (0, 0x20, 0x40)}
# ---- classify
man = {}
if os.path.exists(MANUAL):
    for r in csv.DictReader(open(MANUAL)): man[r['first_addr']] = r
out = []
for r in rows:
    c = r['c']; mem = comp[c]; first = r['comp']; cls = r['cls']
    gates = sorted(into.get(c, []))
    gate_txt = ';'.join('%s%s' % (fmt(g[0]), '' if g[2] == 'taken' else '(ft)') for g in gates[:3])
    var = ''
    for g in gates:
        v = tested_var(g[0])
        if v is not None: var = vname(v); break
    entry = gate_txt or r['tables'] or r['entries']
    auto = ''; verdict = ''; ev = ''; note = ''
    tabs = [t for t in r['tables'].split(';') if t]
    if cls == 'TABLE' and tabs and all(t.startswith('0A:541A[') for t in tabs):
        idx = [int(t.split('[')[1].split(']')[0]) for t in tabs]
        auto = 'effect index %s %s the 06:60DB table domain' % (','.join(map(str, idx)), 'outside' if not any(i in DOMAIN for i in idx) else 'INSIDE')
        if not any(i in DOMAIN for i in idx) and len(callers) == 1: verdict, ev, note = 'UNREACHABLE', 'I', 'the only caller (06:781A) takes its index from the 88-byte table 06:60DB; no entry produces this value'
    if cls == 'TABLE' and tabs and all(t.startswith('06:73AF[') for t in tabs):
        idx = [int(t.split('[')[1].split(']')[0]) for t in tabs]            # same index table 06:60DB, without the OR: slot n of 06:73AF is chosen by the table value n
        auto = 'slot %s %s the values of the 06:60DB table' % (','.join(map(str, idx)), 'outside' if not any(i in set(tab) for i in idx) else 'INSIDE')
        if not any(i in set(tab) for i in idx): verdict, ev, note = 'UNREACHABLE', 'I', 'slot of 06:73AF, chosen by the same 88-byte index table 06:60DB (06:738F-73AE), which never produces this value'
    if cls == 'DEAD':
        code = []; data = []
        for b_, a_, n_ in roots:
            if 'DEAD-CODE' in n_ and flat(b_, a_) in set(mem):
                cc, dd = scan_root(b_, a_); code += cc; data += dd
        inside = {fmt(f) for f in mem}
        code = [x for x in code if x.split(' ')[0] not in {s for s in inside}]
        auto = 'refs: code %s; table-like words %s' % (code or 'none', data or 'none')
        if not code and not data: verdict, ev, note = 'UNREFERENCED', 'I', 'no call / jp / jr / ld rr / pointer-table word reaches it (a computed jump is not excluded)'
    if not verdict and int(r['instrs']) == 1 and int(r['bytes']) == 1 and gates:
        verdict, ev, note = 'EDGE', 'I', 'one byte behind a carry / zero test of a pointer or loop update (%s)' % mnem(gates[0][0])
    if not verdict and 'prn_' in var:
        verdict, ev, note = 'PRINTER', 'I', 'the gate tests the printer engine state / status (%s); no status-injection run (README 16.16) executed it' % var
    m = man.get(first)
    if m: verdict, ev, note = m['verdict'], m['evidence'], m['note']
    out.append([first, '%02X' % B(min(mem)), cls, r['instrs'], r['bytes'], entry, var, auto, verdict or 'OPEN', ev or '?', note or 'not analysed'])
out.sort(key=lambda x: -int(x[4]))
with open(os.path.join(OUT, 'reach_components.csv'), 'w', newline='') as fh:
    w = csv.writer(fh, lineterminator='\n'); w.writerow(['first_addr', 'bank', 'class', 'instrs', 'bytes', 'entry', 'tested_variable', 'automatic_check', 'verdict', 'evidence', 'note']); w.writerows(out)
by = collections.defaultdict(lambda: [0, 0]); byc = collections.defaultdict(lambda: [0, 0])
for x in out: by[x[8]][0] += 1; by[x[8]][1] += int(x[4]); byc[(x[8], x[9])][0] += 1; byc[(x[8], x[9])][1] += int(x[4])
tot = sum(int(x[4]) for x in out)
with open(os.path.join(OUT, 'reach_summary.md'), 'w') as fh:
    fh.write('# Never-run code by verdict\n\nWitnessed afterwards (assets/witness_jp.csv): %d bytes. Components left: %d, holding %d bytes of traced instructions.\n\n' % (wit, len(out), tot))
    fh.write('| verdict | components | bytes |\n|---|---:|---:|\n')
    for k in sorted(by, key=lambda k: -by[k][1]): fh.write('| %s | %d | %d |\n' % (k, *by[k]))
    fh.write('\n(the effect-table check found %d call site(s) of 0A:7CFE and %d reachable index values)\n' % (len(callers), len(DOMAIN)))
print(open(os.path.join(OUT, 'reach_summary.md')).read())
print('wrote', os.path.join(OUT, 'reach_components.csv'), len(out), 'components')
