#!/usr/bin/env python3
"""L2 of a ported build: classify the traced code bytes that no coverage run of this build executed.

  tools/port_never_run.py TREE SUFFIX OUT.csv COV.npz [COV.npz ...] [--rom ROM]

TREE is roms/<folder>; the code is the build's static trace (trace/trace_<s>.json); executed = the union of the COV files (`ex`).
Each never-run byte is classed through the port's instruction map (port/code_map_<s>.csv) against the Japanese ROM:
  JP_DEAD     the paired Japanese byte is proven dead in Japan (roms/jp_rev_a/assets/reach_ranges_jp.csv: UNREFERENCED / UNREACHABLE)
  JP_RAN      the paired Japanese byte ran in Japan (coverage/v8/merged_v8/cov.npz or a witness of roms/jp_rev_a/assets/witness_jp.csv):
              the same code exists, this build's runs have not reached it yet
  JP_EQUIV    (needs --rom) a JP_RAN instruction whose Japanese pair is byte-identical or differs only in relocated address operands, and every static way into it
              (jump / call / jr source, fall-through) is paired the same way: credited by equivalence, the Japanese run is the witness (not executed in this build)
  NEW         no paired Japanese instruction (new or changed code of this build)
  UNUSED      the owner label is Unused_* in this build (code with no reference here: the Japanese leftovers of docs 1.5 and the dead roots)
Runs of bytes are grouped by class and by the label that owns them; OUT gets one row per run.
"""
import sys, csv, json, bisect, collections
import numpy as np
args = sys.argv[1:]; ROM = None
if '--rom' in args: i = args.index('--rom'); ROM = args[i + 1]; del args[i:i + 2]
T, S, OUT = args[0].rstrip('/'), args[1], args[2]; COVS = args[3:]
def flat(b, a): return a if b == 0 or a < 0x4000 else b * 0x4000 + a - 0x4000
N = 1 << 20; code = np.zeros(N, bool)
for k, n in json.load(open('%s/trace/trace_%s.json' % (T, S)))['code'].items():
    b, a = k.split(':')
    if n > 0: o = flat(int(b, 16), int(a, 16)); code[o:o + n] = True
ex = np.zeros(N, bool)
for c in COVS: ex |= np.load(c)['ex'] != 0
jex = np.load('coverage/v8/merged_v8/cov.npz')['ex'] != 0
for r in csv.DictReader(open('roms/jp_rev_a/assets/witness_jp.csv', encoding='utf-8')):
    b = int(r['bank'], 16); jex[flat(b, int(r['start'], 16)):flat(b, int(r['end'], 16)) + 1] = True
jdead = {}
for r in csv.DictReader(open('roms/jp_rev_a/assets/reach_ranges_jp.csv', encoding='utf-8')):
    b = int(r['bank'], 16)
    for o in range(flat(b, int(r['start'], 16)), flat(b, int(r['end'], 16)) + 1): jdead[o] = r['verdict']
pair = {}                               # this build's instruction start -> Japanese instruction start
for r in csv.DictReader(open('%s/port/code_map_%s.csv' % (T, S), encoding='utf-8')):
    b = int(r['bank'], 16); jo, uo = int(r['jp'], 16), int(r['other'], 16); pair[flat(b, uo)] = flat(b, jo)
starts = sorted(pair); 
names = {}
import glob, os
for f in ['%s/disasm/layers/sym_names_%s_%s.csv' % (T, S, l) for l in ('checked', 'loaders', 'port', 'reads')]:     # the order of the former sorted glob (port = the old sym_names_<s>.csv, read after checked and loaders)
    if not os.path.exists(f): continue
    for r in csv.DictReader(open(f, encoding='utf-8')):
        o = flat(int(r['bank'], 16), int(r['addr'], 16))
        if r['name'] != '-': names[o] = r['name']
hand = '%s/disasm/layers/sym_names_%s_hand.csv' % (T, S)
if os.path.exists(hand):
    for r in csv.DictReader(open(hand, encoding='utf-8')):
        o = flat(int(r['bank'], 16), int(r['addr'], 16))
        if r['name'] == '-': names.pop(o, None)
        else: names[o] = r['name']
L = sorted(names.items()); keys = [o for o, _ in L]
def cls(o):
    i = bisect.bisect_right(starts, o) - 1
    if i < 0: return 'NEW'
    s = starts[i]; j = pair[s] + (o - s)
    if (o - s) > 3: return 'NEW'
    if j in jdead: return 'JP_DEAD'
    return 'JP_RAN' if jex[j] else 'JP_NOT_RUN'
# JP_EQUIV (credit by equivalence, owner 2026-11-01): a JP_RAN instruction is credited when its whole basic block is paired with Japanese code that ran,
# byte-identical or differing only in relocated address operands (code_map kind 'same' / 'operand', never 'imm'), and every static way into the block
# (a jump / call / jr source, or the instruction falling through into it) is paired the same way.  Such code is the Japanese code, reached the same way:
# the Japanese run is its witness.  It is a separate class: nothing here claims that this build's runs executed it.
kind = {}
for r in csv.DictReader(open('%s/port/code_map_%s.csv' % (T, S), encoding='utf-8')):
    kind[flat(int(r['bank'], 16), int(r['other'], 16))] = r['kind']
tr = json.load(open('%s/trace/trace_%s.json' % (T, S)))
ins = {}
for k, n in tr['code'].items():
    if n > 0: b_, a_ = k.split(':'); ins[flat(int(b_, 16), int(a_, 16))] = (int(b_, 16), int(a_, 16), n)
rom = open(ROM, 'rb').read() if ROM else None
preds = collections.defaultdict(list); term = set()
if rom:
    for o, (b_, a_, n) in ins.items():
        op = rom[o]; nx = o + n
        def T_(t): return flat(0 if t < 0x4000 else b_, t)
        if op in (0xC3, 0xC2, 0xCA, 0xD2, 0xDA, 0xCD, 0xC4, 0xCC, 0xD4, 0xDC): preds[T_(rom[o + 1] | rom[o + 2] << 8)].append(o)
        if op in (0x18, 0x20, 0x28, 0x30, 0x38): r_ = rom[o + 1] - (256 if rom[o + 1] > 127 else 0); preds[T_(a_ + 2 + r_)].append(o)
        if op in (0xC3, 0x18, 0xC9, 0xD9, 0xE9): term.add(o)
        if op not in (0xC3, 0x18, 0xC9, 0xD9, 0xE9) and nx in ins: preds[nx].append(o)
equiv = np.zeros(N, bool)
if rom:
    for o, (b_, a_, n) in ins.items():
        if not ex[o] and cls(o) == 'JP_RAN' and kind.get(o) in ('same', 'operand') and all(kind.get(p) in ('same', 'operand') for p in preds[o]):
            equiv[o:o + n] = True
idx = np.flatnonzero(code & ~ex); rows = []; tot = collections.Counter()
cur = None
for o in idx:
    i = bisect.bisect_right(keys, o) - 1; owner = L[i][1] if i >= 0 else ''
    c = 'UNUSED' if owner.startswith('Unused_') else cls(int(o))
    if c == 'JP_RAN' and equiv[o]: c = 'JP_EQUIV'
    tot[c] += 1
    if cur and cur[1] == o and cur[2] == c and cur[3] == owner: cur[1] = o + 1
    else:
        if cur: rows.append(cur)
        cur = [int(o), int(o) + 1, c, owner]
if cur: rows.append(cur)
with open(OUT, 'w', newline='', encoding='utf-8') as fh:
    w = csv.writer(fh, lineterminator='\n'); w.writerow(['bank', 'start', 'end', 'bytes', 'class', 'owner'])
    for s, e, c, own in rows: w.writerow(['%02X' % (s // 0x4000), '%04X' % (s % 0x4000 + (0x4000 if s >= 0x4000 else 0)), '%04X' % ((e - 1) % 0x4000 + (0x4000 if s >= 0x4000 else 0)), e - s, c, own])
print('code %d B, executed %d B (%.1f %%), never run %d B:' % (code.sum(), (code & ex).sum(), 100 * (code & ex).sum() / code.sum(), (code & ~ex).sum()), dict(tot), '->', OUT)
