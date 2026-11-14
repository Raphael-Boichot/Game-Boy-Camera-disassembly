#!/usr/bin/env python3
"""Early prototype ("DEBAGAME"): the tester's BGB runs recorded as coverage of the never-run code (roadmap step 8, 2026-11-13).

  tools/proto_red_bgb.py PROTO_BGB.gb [--out-dir DIR]        BGB runs: writes trace/red_bgb_hits_proto.csv and trace/wp_exec_proto.npz
  tools/proto_red_bgb.py PROTO.gb --check                     the npz agrees with the hits CSV
  tools/proto_red_bgb.py PROTO.gb --rebuild                   the npz written again from the hits CSV (no BGB run)

PROTO_BGB.gb is the header-patched copy (md5 1d8097de...; BGB only). Every instruction start of the red code of trace/red_proto.csv
(proven code that no core run executed) is an execution watchpoint that logs `R<bb><aaaa> <GAME_SEQ>` to BGB's debugmsg.txt, and
the VBlank vector `00:0040` is the CONTROL point (a run with 0 CONTROL hits logged nothing and proves nothing). The scenarios are
the tester's own: every menu path of trace/menu_paths_proto.csv, AGING from the menu (protected SRAM: the error branch) and after
PROTECT TEST > OFF, the five DATA SELECT rows and the B-held switch, SRAM WRITE / DUMP, PROTECT TEST ON / OFF, BANK TEST (4M NG in
BGB), MOVIE TEST with each key, its settings screen row by row (Right / Left on each row, then the movie), GALLERY and COM browsed, each
from 128 KiB of $00 after the 250-frame boot hold; four runs from 128 KiB of $FF (a blank cartridge); and the COM link test with two
linked BGB instances (tools/proto_bgb_link.py: one waits on COM, the other presses A and becomes the master). A hit credits its
instruction and the straight line after it up to the first jump, call or return (evidence C: BGB executed it) in trace/wp_exec_proto.npz (ex), which tools/reach_map.py and tools/red_classify.py read
with the core coverage.
"""
import sys, os, csv, json, argparse, hashlib, collections
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); sys.path.insert(0, os.path.join(REPO, 'tools', 'jp'))
import numpy as np
PD = os.path.join(REPO, 'roms', 'prototype_debagame', 'trace'); HITS = os.path.join(PD, 'red_bgb_hits_proto.csv'); NPZ = os.path.join(PD, 'wp_exec_proto.npz')
N = 0x100000
def off(b, a): return a if a < 0x4000 else b * 0x4000 + a - 0x4000
T = json.load(open(os.path.join(PD, 'trace_proto.json')))
INS = {}
for k, n in T['code'].items(): b, a = int(k[:2], 16), int(k[3:], 16); INS[off(b, a)] = (b, a, n)
STOP = {0x18, 0x20, 0x28, 0x30, 0x38, 0xC2, 0xC3, 0xCA, 0xD2, 0xDA, 0xC4, 0xCC, 0xD4, 0xDC, 0xCD, 0xC0, 0xC8, 0xD0, 0xD8, 0xC9, 0xD9, 0xE9, 0xC7, 0xCF, 0xD7, 0xDF, 0xE7, 0xEF, 0xF7, 0xFF, 0x76, 0x10}
def build_npz(rows):
    ex = np.zeros(N, np.uint8)
    for r in rows:
        if r['point'] == 'CONTROL' or int(r['hits']) == 0: continue
        o = off(int(r['point'][:2], 16), int(r['point'][3:], 16))
        while o in INS:                           # the hit instruction and the straight line after it, up to the first jump / call / return
            b, a, n = INS[o]; ex[o:o + n] = 1
            if ROMB[o] in STOP: break
            o += n
    return ex
ap = argparse.ArgumentParser(); ap.add_argument('rom', nargs='?'); ap.add_argument('--out-dir', default='/tmp/proto_red_bgb'); ap.add_argument('--check', action='store_true'); ap.add_argument('--rebuild', action='store_true', help='write the npz from the hits CSV, no BGB run'); ap.add_argument('--only', default=None, help='rerun the scenarios whose name starts with this, keep the other rows of the CSV')
a = ap.parse_args()
ROMB = open(a.rom, 'rb').read()                  # either image: the BGB copy differs from the dump in the header only
if a.rebuild:
    ex = build_npz(list(csv.DictReader(open(HITS)))); np.savez_compressed(NPZ, ex=ex, dr=np.zeros(N, np.uint8)); print('proto_red_bgb: %d bytes credited' % int(ex.sum())); sys.exit(0)
if a.check:
    rows = list(csv.DictReader(open(HITS))); z = np.load(NPZ)['ex']
    if not np.array_equal(z[:N] > 0, build_npz(rows) > 0): sys.exit('proto_red_bgb: trace/wp_exec_proto.npz differs from trace/red_bgb_hits_proto.csv')
    print('proto_red_bgb: npz matches the hits (%d instruction bytes credited)' % int((z > 0).sum())); sys.exit(0)
import bgb_run as B
if hashlib.md5(open(a.rom, 'rb').read()).hexdigest() != '1d8097de3497db8b182bcd2a984b6063': sys.exit('proto_red_bgb: expected the BGB copy (md5 1d8097de...)')
red = list(csv.DictReader(open(os.path.join(PD, 'red_proto.csv'))))
pts = []
for r in red:
    b = int(r['bank'], 16); o, e = off(b, int(r['start'], 16)), off(b, int(r['end'], 16))
    while o < e:
        if o in INS: pts.append(o); o += INS[o][2]
        else: o += 1
def name(o): b, ad, n = INS[o]; return 'R%02X%04X' % (b, ad)
WP = ','.join('%02X:%04X//x/%s %%(c0a0)%%' % (INS[o][0], INS[o][1], name(o)) for o in pts) + ',00:0040//x/CONTROL'
os.environ['BGB_WP'] = WP
os.makedirs(a.out_dir, exist_ok=True); blank = os.path.join(a.out_dir, 'blank.sav'); open(blank, 'wb').write(bytes(0x20000))
T_ = [('A', 4, 90)]
def menu(i): return T_ + [('Down', 4, 20)] * i + [('A', 4, 120)]
OFF = [('Down', 4, 20), ('Down', 4, 20), ('A', 4, 60), ('Down', 4, 20), ('A', 4, 60), ('B', 4, 60), ('Up', 4, 20), ('Up', 4, 20)]
ON = [('Down', 4, 20), ('Down', 4, 20), ('A', 4, 60), ('A', 4, 60), ('B', 4, 60), ('Up', 4, 20), ('Up', 4, 20)]
AGE = [('A', 4, 60), ('Down', 4, 20), ('Down', 4, 20), ('A', 4, 60), ('Down', 4, 20), ('Down', 4, 20), ('A', 4, 600)]
TO_DATA = T_ + OFF + [('A', 4, 60), ('Down', 4, 20), ('Down', 4, 20), ('A', 4, 60)]
def pick(row, run=600): return [('Down', 4, 20)] * row + [('A', 4, run)]
KEYS = ['A', 'B', 'Start', 'Select', 'Up', 'Down', 'Left', 'Right']
SCEN = [('title', []), ('menu', T_), ('sram', menu(0)), ('sram_write', menu(0) + [('Down', 4, 20), ('A', 4, 300)]),
        ('sram_write_off', T_ + OFF + [('A', 4, 60), ('Down', 4, 20), ('A', 4, 300)]),
        ('sram_dump', menu(0) + [('Down', 4, 20)] * 3 + [('A', 4, 120)] + [('Down', 4, 30)] * 6 + [('Right', 4, 30)] * 4 + [('B', 4, 60)]),
        ('bank', menu(1) + [('A', 4, 300), ('B', 4, 60)]), ('protect_off', T_ + OFF + [('B', 4, 60)]), ('protect_on', T_ + ON + [('B', 4, 60)]),
        ('protect_off_on', T_ + OFF + [('Down', 4, 20), ('Down', 4, 20), ('A', 4, 60), ('Up', 4, 20), ('A', 4, 60), ('B', 4, 60)]),
        ('aging_protected', T_ + AGE), ('aging_after_protect_off', T_ + OFF + AGE)]
SCEN += [('aging_row%d' % r, TO_DATA + pick(r)) for r in range(5)]
SCEN += [('aging_switch_held', TO_DATA + pick(0, 300) + [('B', 240, 60)] + pick(1, 300))]
SCEN += [('movie_%s' % k, menu(3) + [(k, 4, 60)] * 3 + [(k, 30, 120)]) for k in KEYS]
SCEN += [('movie_start_keys', menu(3) + [('Start', 4, 120)] + [(k, 4, 40) for k in KEYS] * 2)]
SCEN += [('gallery', menu(4) + [(k, 4, 40) for k in ('Right', 'Right', 'Left', 'Down', 'Up', 'A', 'B', 'Start', 'Select')] * 2)]
SCEN += [('com', menu(5) + [(k, 4, 60) for k in ('A', 'B', 'Start', 'Up', 'Down', 'Select')] + [('-', 4, 600)])]
SCEN += [('idle_title_long', [('-', 4, 3000)]), ('menu_all_keys', T_ + [(k, 4, 30) for k in KEYS] * 2)]
CONF = menu(3) + [('Start', 4, 120)]                      # MOVIE TEST > Start: the settings screen (GAME_SEQ $09)
SCEN += [('config_row%d' % r, CONF + [('Down', 4, 30)] * r + [('Right', 4, 40)] * 8 + [('Left', 4, 40)] * 3 + [('A', 4, 60), ('Start', 4, 300)]) for r in range(10)]
SCEN += [('config_row%d_right%d' % (r, k), CONF + [('Down', 4, 30)] * r + [('Right', 4, 40)] * k + [('B', 4, 60), ('Start', 4, 300)]) for r in range(10) for k in (3, 5)]
FF = os.path.join(a.out_dir, 'ff.sav'); open(FF, 'wb').write(b'\xff' * 0x20000)
SCEN += [('config_hold_row%d_%s' % (r, k), CONF + [('Down', 4, 30)] * r + [(k, 90, 60), ('B', 4, 60), ('Start', 4, 300)]) for r in range(10) for k in ('Right', 'Left')]
SCEN += [('sram_verify_after_write', T_ + OFF + [('A', 4, 60), ('Down', 4, 20), ('A', 4, 900), ('Up', 4, 20), ('A', 4, 900)]),
         ('sram_verify_protected', menu(0) + [('A', 4, 900)])]
SAVE = {}
for nm, seq in [('ff_title', []), ('ff_movie', menu(3) + [('A', 30, 300)]), ('ff_gallery', menu(4) + [(k, 4, 40) for k in ('Right', 'Right', 'Left', 'A', 'B')] * 2),
                ('ff_sram_dump', menu(0) + [('Down', 4, 20)] * 3 + [('A', 4, 120)])]:
    SCEN.append((nm, seq)); SAVE[nm] = FF
LINK = ['link_master_follower']
dbg = os.path.join(B.BGB, 'debugmsg.txt'); cnt = collections.Counter()
def tally(nm, lines):
    c = collections.Counter()
    for l in lines:
        p = l.split()
        if p: c[(p[0], p[1] if len(p) > 1 and p[0] != 'CONTROL' else '')] += 1
    for k, n in c.items(): cnt[(nm,) + k] += n
    return c
COMSEQ = 'A:4:90,' + ','.join(['Down:4:20'] * 5) + ',A:4:200'
import subprocess
for d_ in ('/home/claude/bgbp_1', '/home/claude/bgbp_2'):
    if os.path.exists(os.path.join(d_, 'debugmsg.txt')): os.remove(os.path.join(d_, 'debugmsg.txt'))
if a.only:
    SCEN = [x for x in SCEN if x[0].startswith(a.only)]; LINK = [x for x in LINK if x.startswith(a.only)]
if LINK: subprocess.run([sys.executable, os.path.join(HERE, 'proto_bgb_link.py'), a.rom, os.path.join(a.out_dir, 'link'), COMSEQ + ',-:4:300', COMSEQ + ',-:4:60,A:4:600', '--frames', '2400'], env=dict(os.environ))
lines = []
for d_ in (('/home/claude/bgbp_1', '/home/claude/bgbp_2') if LINK else ()):
    f_ = os.path.join(d_, 'debugmsg.txt'); lines += open(f_, errors='replace').read().split('\n') if os.path.exists(f_) else []
if LINK: c = tally(LINK[0], lines); print(LINK[0], 'control', sum(n for k, n in c.items() if k[0] == 'CONTROL'), 'red points hit', len({k[0] for k in c if k[0] != 'CONTROL'}), flush=True)
for nm, seq in SCEN:
    if os.path.exists(dbg): os.remove(dbg)
    r = B.run(a.rom, SAVE.get(nm, blank), os.path.join(a.out_dir, nm), seq, free=200)
    c = tally(nm, open(dbg, errors='replace').read().split('\n') if os.path.exists(dbg) else [])
    print(nm, 'GAME_SEQ %02X' % r['st']['WRAM'][0xA0], 'control', sum(n for k, n in c.items() if k[0] == 'CONTROL'), 'red points hit', len({k[0] for k in c if k[0] != 'CONTROL'}), flush=True)
rows = []
for (run, pt, sc), n in sorted(cnt.items()):
    if pt.startswith('R'): rows.append({'run': run, 'point': '%s:%s' % (pt[1:3], pt[3:7]), 'game_seq': sc, 'hits': n})
for run in [x[0] for x in SCEN] + LINK: rows.append({'run': run, 'point': 'CONTROL', 'game_seq': '', 'hits': sum(n for k, n in cnt.items() if k[0] == run and k[1] == 'CONTROL')})
if a.only:                                        # keep the rows of the scenarios not rerun
    names = {x[0] for x in SCEN} | set(LINK)
    rows = [r for r in csv.DictReader(open(HITS)) if r['run'] not in names] + rows
with open(HITS, 'w', newline='') as f:
    w = csv.DictWriter(f, ['run', 'point', 'game_seq', 'hits'], lineterminator='\n'); w.writeheader(); w.writerows(rows)
ex = build_npz(rows); np.savez_compressed(NPZ, ex=ex, dr=np.zeros(N, np.uint8))
print('proto_red_bgb: %d watch points, %d scenarios, %d points hit, %d red instruction bytes credited' % (len(pts), len(SCEN), len({r['point'] for r in rows if r['point'] != 'CONTROL'}), int(ex.sum())))
