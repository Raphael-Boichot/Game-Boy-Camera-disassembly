#!/usr/bin/env python3
"""Run in my core (joypad only, a save file edit and no RAM poke) the repeat-range code of the slide show (README 16.19).
The slide-show list is SRAM $1000-$102E (47 entries, $FE = empty, $FF = end), the repeat flag $102F (0 / $FF) and the timing / loop markers SRAM $1030-$105E (47 bytes: 0 none, range start $80+t,
interior t, end $40+t, t = number of plays 1..50).  The unlocking saves hold an empty list and no marker, so the player (mode $13, 03:5FA0) never met one: its marker code
03:6155 (start marker on the first entry), 03:6264 (end marker: replay the range or leave it), 03:629A (start marker met after a range ended) and the editor-preview copy 03:4D4B (start marker on the first entry) never ran.
usage: slideshow_markers.py OUTDIR [--no-markers] [--loop] [--out-sav FILE] [--preview]      (run from the working root; corpus unlock_runs/f1_organic/corpus.jsonl)
  The save is unl_CE10238211 (a valid unlocking save with 30 photos, patched BEFORE the boot): list = photos 0..5 then $FF, markers = ranges [0..2] x 2 and [3..4] x 1:
      timing[0] = $82, [1] = $02, [2] = $42 (entries 0-2 played twice), timing[3] = $81, [4] = $41 (entries 3-4 played once); both settings copies get their checksum back.
  --no-markers  control: the same list without any marker      --loop  also sets the repeat flag $102F = $FF (the show wraps to the first entry: the carry tests 03:4E21 / 03:628B)
  --out-sav     write the patched save to FILE (the BGB replay, bgb_slideshow.py, uses it)
  Player: the lineage of corpus entry 995 (main menu -> slide show, 13:01) ends with A, which starts the show (13:02 -> 13:03 -> 13:04); the core then runs 1500 frames, noting every change of the
      displayed index $D51A, the loop start $D727, the repeat counter $D728 and the flags $D729 / $D72A.
  --preview     the editor preview: the lineage of corpus entry 2379 (editor, Select menu, item 3, A, A, Up: state 12:12 plays the list) is replayed on the patched save (03:4D4B is tested after every action),\n      then the preview runs 900 frames; the same noting of $D51A / $D727-$D72A
Writes OUTDIR/slideshow_markers.json and OUTDIR/exec_ranges.csv (every byte executed in this process; witness_map.py intersects it with the never-run code)."""
import sys, os, json
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g
import blocks as B
import sram_analyze as S
a = sys.argv[1:]
def flag(n):
    if n in a: a.remove(n); return True
    return False
def opt(n, d):
    if n in a: i = a.index(n); v = a[i + 1]; del a[i:i + 2]; return v
    return d
NOMARK = flag('--no-markers'); LOOP = flag('--loop'); PREVIEW = flag('--preview'); OUTSAV = opt('--out-sav', None)
out = a[0]; os.makedirs(out, exist_ok=True)
ENTRIES = [0, 1, 2, 3, 4, 5]
TIMING = {0: 0x82, 1: 0x02, 2: 0x42, 3: 0x81, 4: 0x41}
def patch(s):
    b = bytearray(s)
    b[0x1000:0x102F] = bytes([0xFE]) * 0x2F
    for i, v in enumerate(ENTRIES): b[0x1000 + i] = v
    b[0x1000 + len(ENTRIES)] = 0xFF
    b[0x102F] = 0xFF if LOOP else 0
    b[0x1030:0x105F] = bytes(0x2F)
    if not NOMARK:
        for i, v in TIMING.items(): b[0x1030 + i] = v
    for off in (0x1000, 0x10D9):
        b[off + 0xD7:off + 0xD9] = S.ck(b, off, 0xD7)
    assert S.status(bytes(b))['settings'] == (True, True), 'the settings blocks of the patched save are not valid'
    return bytes(b)
orig = lib.SAV
lib.SAV = lambda name: (lambda s: patch(s) if s is not None else None)(orig(name))
if OUTSAV: open(OUTSAV, 'wb').write(lib.SAV('unl_CE10238211'))
C = lib.Corpus('unlock_runs/f1_organic/corpus.jsonl'); g.set_organic(1)
ex = g.cov_exec()
ADDR = {'03:6155': 0x6155, '03:6264': 0x6264, '03:629A': 0x629A, '03:62BA': 0x62BA, '03:4D4B': 0x4D4B, '03:4E50': 0x4E50, '03:4E21': 0x4E21, '03:628B': 0x628B,
        '03:611A': 0x611A, '03:623D': 0x623D, '03:4D1A': 0x4D1A, '03:4DDA': 0x4DDA}
T = {k: B.flat(3, v) for k, v in ADDR.items()}
def hits(): return {k: bool(ex[v] > 0) for k, v in T.items()}
def st(): return '%02X:%02X' % lib.cur()
res = {'markers': not NOMARK, 'loop': LOOP, 'entries': ENTRIES, 'timing': {str(k): '%02X' % v for k, v in TIMING.items()} if not NOMARK else {}}
# ---- the player
ENTRY = 995
p = C.path(ENTRY); sp = dict(C.E[p[0]]['spec'])
lib.boot(lib.SAV(sp['sav']), combo=sp['combo'], printer=sp['printer'], free=sp['free'])
sr = bytes(g.sram()); res['sram_list'] = sr[0x1000:0x1010].hex(' '); res['sram_timing'] = sr[0x1030:0x1038].hex(' '); res['sram_102F'] = sr[0x102F]
for j in p[1:]:
    for ac in C.E[j]['actions']: lib.act(ac)
res['before_show'] = st(); res['hits_before_show'] = hits()
trace = []; last = None
for f in range(1500):
    g.run(1)
    cur = (st(), g.peek(0xD51A), g.peek(0xD727), g.peek(0xD728), g.peek(0xD729), g.peek(0xD72A))
    if cur != last: trace.append((f,) + cur); last = cur
res['player_trace'] = trace
res['player_end'] = {'state': st(), 'D51A': g.peek(0xD51A), 'D72A': g.peek(0xD72A)}
shown = []
for f, s, i, ls, lc, fl, dn in trace:
    if s == '13:04' and (not shown or shown[-1] != i): shown.append(i)
res['indices_shown'] = shown
res['hits_player'] = hits()
print('player: end', res['player_end'], 'indices shown', shown, 'hits', {k: v for k, v in res['hits_player'].items() if v}, flush=True)
# ---- the editor preview
if PREVIEW:
    PENTRY = 2379      # corpus entry in 12:12 (the preview of the editor plays the list): Select menu of the editor, item 3, A, A, Up
    p = C.path(PENTRY); sp = dict(C.E[p[0]]['spec']); first = None
    lib.boot(lib.SAV(sp['sav']), combo=sp['combo'], printer=sp['printer'], free=sp['free'])
    for j in p[1:]:
        for k, ac in enumerate(C.E[j]['actions']):
            lib.act(ac)
            if first is None and ex[T['03:4D4B']] > 0: first = {'entry': j, 'action_index': k, 'action': ac, 'state': st()}      # tested after every action: the executed array is cumulative
    trace = []; last = None
    for f in range(900):
        g.run(1)
        cur = (st(), g.peek(0xD51A), g.peek(0xD727), g.peek(0xD728), g.peek(0xD729), g.peek(0xD72A))
        if cur != last: trace.append((f,) + cur); last = cur
    shown = []
    for f, s_, i, ls, lc, fl, dn in trace:
        if s_ == '12:12' and (not shown or shown[-1] != i): shown.append(i)
    res['preview'] = {'entry': PENTRY, '03:4D4B_first_run': first, 'indices_shown': shown, 'end': {'state': st(), 'D72A': g.peek(0xD72A)}, 'trace': trace, 'hits': hits()}
    print('preview: 03:4D4B first run', first, '; indices shown', shown, '; end', res['preview']['end'], flush=True)
res['final_hits'] = hits()
json.dump(res, open(out + '/slideshow_markers.json', 'w'), indent=1)
lib.dump_exec_ranges(out + '/exec_ranges.csv', np.zeros(np.array(g.cov_exec()).shape, bool))
