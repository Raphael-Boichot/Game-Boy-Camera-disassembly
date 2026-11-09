#!/usr/bin/env python3
"""Hello Kitty ROM: what the never-run code is (step 7). Writes port/red_bgb_hits_kitty.csv (with --hits), port/wp_exec_kitty.npz and
port/red_classes_kitty.csv.

  tools/kitty_red_classes.py [ROM] [--hits RUN=FILE ...]

--hits reads BGB watchpoint logs (debugmsg.txt lines "R<bb><aaaa> <mode>:<state>", or the name,hits csv of kitty_bgb_link.py) of
runs made with the watch lists of the never-run entries (gate targets and trace entries); RUN is a label (sgb, link_giver, print_inq20,
...). The table port/red_bgb_hits_kitty.csv keeps (run, point, screen, hits); without --hits the table is read back.
A point that BGB executed credits its straight-line block (up to and including the first jump, call, return or conditional branch)
as observed: port/wp_exec_kitty.npz (exec, evidence C). The other red bytes are classed:
  effect      run only by a picture effect that table 05:4C5F never selects, forced in port/forced_effects_kitty.npz
  gate        run when one sensor-bank gate is inverted, port/forced_gates_kitty.npz
  forced-mode run only in modes reached by patching the mode table, port/forced_kitty.npz
  not-run     run by none of these
Per routine: red bytes per class (port/red_classes_kitty.csv). Forced classes are evidence I: a forced run is not a way the game runs.
"""
import os, sys, csv, json, glob, bisect, collections
import numpy as np
REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__))); KD = os.path.join(REPO, 'roms', 'hello_kitty'); P = os.path.join(KD, 'port')
args = sys.argv[1:]; hits_in = []
if '--hits' in args:
    i = args.index('--hits'); hits_in = [x for x in args[i + 1:] if '=' in x]; args = args[:i]
ROM = open(args[0] if args else '/root/work/roms/pocketcamera_kitty.gb', 'rb').read(); N = len(ROM)
def off(b, a): return a if a < 0x4000 else b * 0x4000 + a - 0x4000
T = json.load(open(os.path.join(P, 'trace_kitty.json')))
ins = {}
for k, n in T['code'].items(): b, a = int(k[:2], 16), int(k[3:], 16); ins[off(b, a)] = (b, a, n)
code = np.zeros(N, bool)
for o, (b, a, n) in ins.items(): code[o:o + n] = True
HT = os.path.join(P, 'red_bgb_hits_kitty.csv')
if hits_in:
    cnt = collections.Counter()
    for spec in hits_in:
        run, fn = spec.split('=', 1)
        if fn.endswith('.csv'):
            for r in csv.DictReader(open(fn)):
                p = r['name'].split(); cnt[(run, p[0], p[1] if len(p) > 1 else '')] += int(r['hits'])
        else:
            for l in open(fn, errors='replace'):
                p = l.split(); 
                if p: cnt[(run, p[0], p[1] if len(p) > 1 else '')] += 1
    with open(HT, 'w', newline='') as f:
        w = csv.writer(f, lineterminator='\n'); w.writerow(['run', 'point', 'screen', 'hits'])
        for (run, pt, sc), n in sorted(cnt.items()):
            if pt.startswith('R'): w.writerow([run, '%s:%s' % (pt[1:3], pt[3:7]), sc, n])
        for run in sorted({k[0] for k in cnt}):   # the control line of every run: 0 hits elsewhere means "not executed"
            w.writerow([run, 'CONTROL', '', sum(n for k, n in cnt.items() if k[0] == run and k[1] == 'CONTROL')])
H = list(csv.DictReader(open(HT)))
for run in {r['run'] for r in H}: assert any(r['run'] == run and r['point'] == 'CONTROL' and int(r['hits']) > 0 for r in H), 'control 0 in ' + run
STOP = {0x18, 0x20, 0x28, 0x30, 0x38, 0xC2, 0xC3, 0xCA, 0xD2, 0xDA, 0xC4, 0xCC, 0xD4, 0xDC, 0xCD, 0xC0, 0xC8, 0xD0, 0xD8, 0xC9, 0xD9, 0xE9, 0xC7, 0xCF, 0xD7, 0xDF, 0xE7, 0xEF, 0xF7, 0xFF, 0x76, 0x10}
bw = np.zeros(N, np.uint8); pts = set()
for r in H:
    if r['point'] == 'CONTROL': continue
    o = off(int(r['point'][:2], 16), int(r['point'][3:], 16)); pts.add(o)
    while o in ins:
        b, a, n = ins[o]; bw[o:o + n] = 1
        if ROM[o] in STOP: break
        o += n
np.savez_compressed(os.path.join(P, 'wp_exec_kitty.npz'), exec=bw, dread=np.zeros(N, np.uint8))
ex = np.zeros(N, bool)
for f in sorted(glob.glob(os.path.join(P, 'cov_kitty_*.npz'))) + [os.path.join(P, 'wp_exec_kitty.npz')]: ex |= np.load(f)['exec'][:N] > 0
red = code & ~ex
def lay(f): z = np.load(os.path.join(P, f)); return (z['exec'][:N] > 0) & red
fe, fg, fm = lay('forced_effects_kitty.npz'), lay('forced_gates_kitty.npz'), lay('forced_kitty.npz')
cls = np.full(N, '', object)
cls[red] = 'not-run'; cls[red & fm] = 'forced-mode'; cls[red & fg & ~fm] = 'gate'; cls[red & fe & ~fg & ~fm] = 'effect'
names = {}
for l in open(os.path.join(KD, 'pocketcamera_kitty.sym')):
    p = l.split()
    if len(p) == 2 and ':' in p[0] and not p[1].startswith(('.', 'jr_', 'Jump_', 'Call_')): names[off(int(p[0][:2], 16), int(p[0][3:], 16))] = p[1]
K = sorted(names)
def routine(o): i = bisect.bisect_right(K, o) - 1; return K[i] if i >= 0 else 0
C = ['effect', 'gate', 'forced-mode', 'not-run']; per = collections.defaultdict(collections.Counter)
for o in np.nonzero(red)[0]: per[routine(int(o))][cls[o]] += 1
rows = []
for k in sorted(per):
    b = k // 0x4000; a = k % 0x4000 + (0x4000 if b else 0)
    rows.append(['%02X:%04X' % (b, a), names.get(k, '?'), sum(per[k].values())] + [per[k][c] for c in C])
with open(os.path.join(P, 'red_classes_kitty.csv'), 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['addr', 'routine', 'red_bytes'] + C); w.writerows(rows)
tot = collections.Counter(cls[red])
print('kitty_red_classes: BGB hit points %d, bytes credited %d; red %d = %s' % (len(pts), int(bw.astype(bool).sum() and (bw.astype(bool) & code).sum()), int(red.sum()),
      ', '.join('%s %d' % (c, tot[c]) for c in C)))
