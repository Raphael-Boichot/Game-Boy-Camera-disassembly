#!/usr/bin/env python3
"""L2 of a ROM with its own trace (Hello Kitty, the prototype): classify the red bytes of the reachability map, the proven code that no run
executed (2026-11-12, roadmap item 4).

  tools/red_classify.py --tag kitty|proto ROM [--out roms/<folder>/trace/red_<tag>.csv]

Red is what tools/reach_map.py draws red: bytes of proven code (trace/rom_map_<tag>.csv class C) that no run executed (trace/cov_<tag>_*.npz,
trace/wp_exec_<tag>.npz) and no forced run reached (trace/forced_*.npz). They are cut into pieces (runs of red instruction bytes) and each piece
gets its way in, from the static edges of the decoded instructions (fall-through, jr / jp / call with their condition, rst) and from the trace's
record of why each entry was traced (trace_<tag>.json `entries`: table, far call, callback, hand table, interrupt vector):
  GATE        a way in starts at an instruction that RAN: the piece needs that way to be taken, which no run did. The gate is that instruction:
              a conditional branch (jr / jp / call / ret cc) whose other side ran, a fall-through after a conditional branch that was always
              taken, a jump-table or callback entry (an index or a pointer no run produced), a far call site that ran with another target
  BEHIND      every way in comes from other red pieces: the piece is reached only through them (its gate is theirs, column `gate`)
  FORCED      a way in starts at code that only a forced run executed (light blue: a poked mode, a flipped gate, an effect index): the piece
              hangs behind that forced code (gate: its instruction)
  TABLE       the entry is a word of a jump table or a record of a record table (a mode / state table, an effect table ...) that no run
              selected: the index or the state number that would select it was never produced (column gate_insn: the table)
  VECTOR      the entry is an interrupt vector or handler whose interrupt no run raised (timer, serial, joypad ...)
  HAND        reached only through a hand-resolved site of trace/extra_roots_<tag>.json (`hand table`: an indexed `jp hl`) whose other targets ran
  NONE        no way in found (should not happen in a trace: listed for review)
Every verdict is evidence I: it says where the piece hangs, not that the way can never be taken (a value, a save or a link partner may take
it). Columns: bank, start, end (inclusive), bytes, owner (the label that holds the start), class, gate (BB:AAAA of the gate instruction or of
the gate piece for BEHIND), gate_insn (the gate instruction, disassembled briefly), gate_owner, ways (every way in, `;`-separated).
Prints the bytes per class and the largest gates (bytes behind each).
"""
import argparse, collections, csv, glob, json, os, re, bisect
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
ROMS = {'kitty': 'hello_kitty', 'proto': 'prototype_debagame'}
ap = argparse.ArgumentParser(); ap.add_argument('--tag', required=True, choices=sorted(ROMS)); ap.add_argument('rom'); ap.add_argument('--out')
a = ap.parse_args(); T = a.tag; D = os.path.join(REPO, 'roms', ROMS[T]); OUT = a.out or os.path.join(D, 'trace', 'red_%s.csv' % T)
R = open(a.rom, 'rb').read(); N = len(R)
def off(b, ad): return ad if ad < 0x4000 else b * 0x4000 + ad - 0x4000
def key(o): return '%02X:%04X' % ((o >> 14) if o >= 0x4000 else 0, o if o < 0x4000 else 0x4000 + (o & 0x3FFF))
def parse(k): return off(int(k[:2], 16), int(k[3:], 16))
def arr(z, *ks):
    for k in ks:
        if k in z.files: return z[k][:N] > 0
    return np.zeros(N, bool)
ex = np.zeros(N, bool); forced = np.zeros(N, bool)
for f in sorted(glob.glob(os.path.join(D, 'trace', 'cov_%s_*.npz' % T))) + sorted(glob.glob(os.path.join(D, 'trace', 'wp_exec_%s.npz' % T))):
    ex |= arr(np.load(f), 'ex')
for f in sorted(glob.glob(os.path.join(D, 'trace', 'forced_*.npz'))):
    z = np.load(f); forced |= arr(z, 'ex')                       # executed in a forced run (a code byte only read there stays never run, as on the reachability map)
code = np.zeros(N, bool)
for r in csv.DictReader(open(os.path.join(D, 'trace', 'rom_map_%s.csv' % T))):
    if r['class'] == 'C': o = off(int(r['bank'], 16), int(r['start'], 16)); code[o:o + int(r['length'])] = True
red = code & ~ex & ~forced
TR = json.load(open(os.path.join(D, 'trace', 'trace_%s.json' % T)))
ins = {parse(k): n for k, n in TR['code'].items()}                     # instruction start -> length
starts = sorted(ins)
names = sorted((off(int(r['bank'], 16), int(r['addr'], 16)), r['name']) for r in csv.DictReader(open(os.path.join(D, 'disasm', 'sym_names_%s.csv' % T))))
NO = [o for o, _ in names]
def owner(o):
    i = bisect.bisect_right(NO, o) - 1; return names[i][1] if i >= 0 else ''
CC = {0x20: 'jr nz', 0x28: 'jr z', 0x30: 'jr nc', 0x38: 'jr c', 0xC2: 'jp nz', 0xCA: 'jp z', 0xD2: 'jp nc', 0xDA: 'jp c',
      0xC4: 'call nz', 0xCC: 'call z', 0xD4: 'call nc', 0xDC: 'call c', 0xC0: 'ret nz', 0xC8: 'ret z', 0xD0: 'ret nc', 0xD8: 'ret c'}
def brief(o):
    op = R[o]; n = ins.get(o, 1); b = R[o:o + n].hex(' ')
    if op in CC: return CC[op] + ' (' + b + ')'
    return b
ARGS = {parse(k): v for k, v in TR.get('args', {}).items()}
# edges: (source instruction, target, kind)
into = collections.defaultdict(list)
for o, n in ins.items():
    op = R[o]; bank = o >> 14 if o >= 0x4000 else 0
    def tgt(ad): return off(bank, ad) if ad >= 0x4000 and bank else (ad if ad < 0x4000 else None)
    nxt = o + n + ARGS.get(o, 0)                      # a call with inline arguments returns after them
    ends = op in (0xC3, 0x18, 0xC9, 0xD9, 0xE9) or op in (0xC7, 0xCF, 0xD7, 0xDF, 0xE7, 0xEF, 0xF7, 0xFF) and False
    if op in (0x18,) or op in (0x20, 0x28, 0x30, 0x38):
        d = R[o + 1]; d = d - 256 if d >= 128 else d; t = nxt + d
        into[t].append((o, 'branch' if op != 0x18 else 'jr'))
    if op in (0xC3, 0xC2, 0xCA, 0xD2, 0xDA, 0xCD, 0xC4, 0xCC, 0xD4, 0xDC):
        t = tgt(R[o + 1] | R[o + 2] << 8)
        if t is not None: into[t].append((o, 'call' if op in (0xCD,) else 'branch' if op != 0xC3 else 'jp'))
    if op in (0xC7, 0xCF, 0xD7, 0xDF, 0xE7, 0xEF, 0xF7, 0xFF): into[op - 0xC7].append((o, 'rst'))
    if not ends and nxt in ins:
        into[nxt].append((o, 'after ' + ('cc' if op in CC else 'call' if op in (0xCD, 0xC7, 0xCF, 0xD7, 0xDF, 0xE7, 0xEF, 0xF7, 0xFF) else 'insn')))
TBLIN = collections.defaultdict(list)               # entries of the trace's jump tables and record tables (data: the index or record never produced)
for k, v in TR.get('tables', {}).items():
    tb = int(k[:2], 16)
    for t in v: TBLIN[off(tb, t) if t >= 0x4000 else t].append('table ' + k)
for k, v in TR.get('ctables', {}).items():
    for rk in v.get('records', []): TBLIN[parse(rk)].append('record table ' + k)
VEC = {'vblank', 'lcdc', 'timer', 'serial', 'joypad'}
why = {parse(k): v for k, v in TR.get('entries', {}).items()}
def indirect(o):                                   # the trace's reason for an entry, with its source instruction when it names one
    v = why.get(o)
    if not v: return [(None, t) for t in TBLIN.get(o, [])]
    m = re.search(r'(?:from|at|of|created at|given to) ([0-9A-F]{2}:[0-9A-F]{4})', v)
    if v in VEC or v.startswith('rst'): return [(None, v)]
    if v in ('jr cc', 'jr', 'jp', 'call', 'entry'): return [(None, t) for t in TBLIN.get(o, [])]
    return [(parse(m.group(1)) if m else None, v)] + [(None, t) for t in TBLIN.get(o, [])]
# pieces
pieces = []; i = 0; idx = np.flatnonzero(red)
cut = np.flatnonzero(np.diff(idx) > 1) + 1
for seg in np.split(idx, cut) if len(idx) else []:
    s, e = int(seg[0]), int(seg[-1])
    # split at instruction starts that have a way in from outside the run (entries inside a run are separate pieces)
    pieces.append([s, e])
head = {}
rows = []
for s, e in pieces:
    ways = []
    for k in [o for o in starts[bisect.bisect_left(starts, s):bisect.bisect_right(starts, e)]]:
        for src, kind in into.get(k, []) + [(x, y) for x, y in indirect(k)]:
            if src is not None and s <= src <= e: continue                     # inside the piece
            ways.append((k, src, kind))
    rows.append((s, e, ways))
pid = {}
for j, (s, e, _) in enumerate(rows):
    for o in range(s, e + 1): pid[o] = j
cls = {}; gate = {}
for j, (s, e, ways) in enumerate(rows):
    ran = [(k, src, kd) for k, src, kd in ways if src is not None and ex[src]]
    vec = [(k, src, kd) for k, src, kd in ways if src is None and (kd in VEC)]
    tbl = [(k, src, kd) for k, src, kd in ways if src is None and ('table' in kd and not kd.startswith('hand'))]
    hand = [(k, src, kd) for k, src, kd in ways if src is None and kd not in VEC and (k, src, kd) not in tbl]
    if ran:
        k, src, kd = ran[0]; cls[j] = 'GATE'; gate[j] = (src, kd)
    elif vec: cls[j] = 'VECTOR'; gate[j] = (None, vec[0][2])
    elif any(src is not None and forced[src] for _, src, _ in ways):
        k, src, kd = next(w for w in ways if w[1] is not None and forced[w[1]]); cls[j] = 'FORCED'; gate[j] = (src, kd)
    elif tbl: cls[j] = 'TABLE'; gate[j] = (None, tbl[0][2])
    elif any(src is not None and red[src] for _, src, _ in ways): cls[j] = 'BEHIND'
    elif hand: cls[j] = 'HAND'; gate[j] = (None, hand[0][2])
    else: cls[j] = 'NONE'
def root(j, seen=()):                               # the gate piece of a BEHIND piece: follow red predecessors to a classified one
    if cls[j] != 'BEHIND' or j in seen: return j
    for k, src, kd in rows[j][2]:
        if src is not None and red[src] and src in pid:
            r_ = root(pid[src], seen + (j,))
            if cls[r_] != 'BEHIND': return r_
    return j
out = []; tot = collections.Counter(); behind = collections.Counter()
for j, (s, e, ways) in enumerate(rows):
    c = cls[j]; n = e - s + 1; tot[c] += n
    if c == 'BEHIND':
        r_ = root(j); g = key(rows[r_][0]) if r_ != j else ''; gi = 'behind ' + owner(rows[r_][0]) if r_ != j else ''; go = owner(rows[r_][0]) if r_ != j else ''
        if r_ != j: behind[r_] += n
    else:
        src, kd = gate.get(j, (None, ''))
        g = key(src) if src is not None else ''; gi = (brief(src) + ' [' + kd + ']') if src is not None else kd; go = owner(src) if src is not None else ''
        behind[j] += n
    out.append(['%02X' % ((s >> 14) if s >= 0x4000 else 0), key(s)[3:], key(e)[3:], n, owner(s), c, g, gi, go,
                '; '.join('%s<-%s %s' % (key(k), key(src) if src is not None else '-', kd) for k, src, kd in ways[:6])])
HDR = ['bank', 'start', 'end', 'bytes', 'owner', 'class', 'gate', 'gate_insn', 'gate_owner', 'ways']
RV = os.path.join(D, 'trace', 'red_verdicts_%s.csv' % T)          # hand verdicts (prototype, 2026-11-13): one per piece, by its start
if os.path.exists(RV):
    V = {(r['bank'], r['start']): r['class'] for r in csv.DictReader(open(RV))}
    HDR.append('verdict'); out = [o + [V.get((o[0], o[1]), '')] for o in out]
    print('%s_red verdicts: %s' % (T, ', '.join('%s %d' % (k or 'none', sum(o[3] for o in out if o[-1] == k)) for k in sorted({o[-1] for o in out}))))
with open(OUT, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(HDR); w.writerows(out)
print('%s_red: %d bytes in %d pieces: %s' % (T, int(red.sum()), len(rows), ', '.join('%s %d' % (k, tot[k]) for k in ('GATE', 'FORCED', 'TABLE', 'BEHIND', 'VECTOR', 'HAND', 'NONE'))))
for j, n in behind.most_common(12):
    s = rows[j][0]; print('  %6d B  %s %-28s %s %s' % (n, key(s), owner(s)[:28], cls[j], out[j][7][:70]))
print('wrote', os.path.relpath(OUT, REPO))
