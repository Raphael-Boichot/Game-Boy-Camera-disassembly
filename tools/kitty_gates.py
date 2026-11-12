#!/usr/bin/env python3
"""Hello Kitty ROM: the gates of the never-run code (step 7). Writes roms/hello_kitty/trace/gates_kitty.csv.

  tools/kitty_gates.py [ROM]

Every instruction of the trace (trace/trace_kitty.json) that ran in an observed run (port/cov_kitty_*.npz) and can go two ways
(jr / jp / call / ret with a condition) is a gate when one of its two ways never ran: the never-run way leads into red code (code that no
run executed). Per gate: site (bank:address), the routine it is in, the instruction, the way that never ran (taken / fall-through), the
first never-run address, the red bytes reached from there through never-run code only (straight-line runs and the static jumps, calls
and branches between them), and the flag test that decides it (the instruction before the branch, as bytes). The same red byte can sit
behind several gates; each gate counts what it alone opens first, so the sum is larger than the red total.
"""
import os, sys, csv, json, glob, bisect, collections
import numpy as np
REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__))); KD = os.path.join(REPO, 'roms', 'hello_kitty')
ROM = open(sys.argv[1] if len(sys.argv) > 1 else '/root/work/roms/pocketcamera_kitty.gb', 'rb').read(); N = len(ROM)
T = json.load(open(os.path.join(KD, 'trace', 'trace_kitty.json')))
def off(b, a): return a if a < 0x4000 else b * 0x4000 + a - 0x4000
ins = {}
for k, n in T['code'].items():
    b, a = int(k[:2], 16), int(k[3:], 16); ins[off(b, a)] = (b, a, n)
ex = np.zeros(N, bool)
for f in sorted(glob.glob(os.path.join(KD, 'trace', 'cov_kitty_*.npz'))) + glob.glob(os.path.join(KD, 'trace', 'wp_exec_kitty.npz')): ex |= np.load(f)['ex'][:N] > 0
code = np.zeros(N, bool)
for o, (b, a, n) in ins.items(): code[o:o + n] = True
red = code & ~ex
names = {}
for l in open(os.path.join(KD, 'pocketcamera_kitty.sym')):
    p = l.split()
    if len(p) == 2 and ':' in p[0] and not p[1].startswith(('.', 'jr_', 'Jump_', 'Call_')): names[off(int(p[0][:2], 16), int(p[0][3:], 16))] = p[1]
K = sorted(names)
def routine(o): i = bisect.bisect_right(K, o) - 1; return names[K[i]] if i >= 0 else '?'
COND = {0x20: 'jr nz', 0x28: 'jr z', 0x30: 'jr nc', 0x38: 'jr c', 0xC2: 'jp nz', 0xCA: 'jp z', 0xD2: 'jp nc', 0xDA: 'jp c',
        0xC4: 'call nz', 0xCC: 'call z', 0xD4: 'call nc', 0xDC: 'call c', 0xC0: 'ret nz', 0xC8: 'ret z', 0xD0: 'ret nc', 0xD8: 'ret c'}
def succ(o):
    """static successors of the instruction at o (file offsets)"""
    b, a, n = ins[o]; op = ROM[o]; out = []
    if op in (0x18,) or op in (0x20, 0x28, 0x30, 0x38):
        d = ROM[o + 1]; d = d - 256 if d > 127 else d; out.append(off(b, a + 2 + d))
    if op in (0xC3, 0xC2, 0xCA, 0xD2, 0xDA, 0xCD, 0xC4, 0xCC, 0xD4, 0xDC):
        t = ROM[o + 1] | ROM[o + 2] << 8; out.append(off(b if t >= 0x4000 else 0, t))
    if op not in (0x18, 0xC3, 0xC9, 0xD9, 0xE9): out.append(o + n)
    return out
def flood(start):
    seen = set(); st = [start]; tot = 0
    while st:
        o = st.pop()
        if o in seen or o not in ins or not red[o]: continue
        seen.add(o); tot += ins[o][2]; st.extend(succ(o))
    return tot, seen
rows = []
starts = sorted(ins)
for o in starts:
    if not ex[o]: continue
    op = ROM[o]
    if op not in COND: continue
    b, a, n = ins[o]
    ways = []
    if op in (0x20, 0x28, 0x30, 0x38):
        d = ROM[o + 1]; d = d - 256 if d > 127 else d; ways.append(('taken', off(b, a + 2 + d)))
    elif op in (0xC2, 0xCA, 0xD2, 0xDA, 0xC4, 0xCC, 0xD4, 0xDC):
        t = ROM[o + 1] | ROM[o + 2] << 8; ways.append(('taken', off(b if t >= 0x4000 else 0, t)))
    ways.append(('fall-through', o + n))
    for way, t in ways:
        if t in ins and red[t]:
            tot, _ = flood(t)
            prev = max((p for p in starts if p < o and p >= o - 4), default=None)
            test = ROM[prev:o].hex(' ') if prev is not None else ''
            tb = t // 0x4000; ta = t % 0x4000 + (0x4000 if tb else 0)
            rows.append(['%02X:%04X' % (b, a), routine(o), COND[op], way, '%02X:%04X' % (tb, ta), tot, test])
rows.sort(key=lambda r: -r[5])
with open(os.path.join(KD, 'trace', 'gates_kitty.csv'), 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['site', 'routine', 'branch', 'never_run_way', 'first_red', 'red_bytes_opened', 'test_before']); w.writerows(rows)
print('kitty_gates: %d red bytes, %d gates' % (int(red.sum()), len(rows)))
