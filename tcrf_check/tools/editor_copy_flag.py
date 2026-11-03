#!/usr/bin/env python3
"""Run in my core (joypad only, no RAM poke) the editor save-back branch 02:47FE-4802 (README 16.19).
02:47C4 (the save-back of an edited photo, called from 07:6A4E) draws the "copy" badge on the thumbnail it writes (02:47F8-4800: `ld a,[$CF33] ; and a ; jr z ; ld d,$CE ; call $29F9`) only
when [$CF33] is non-zero.  $C000-$CFB7 is the work buffer that holds a RAM image of the album slot being viewed or edited (README 2.4), so [$CF33] is the copy flag F33 of THAT photo:
the branch runs when an album Copy (a photo with F33 = 1) is edited and saved.  The unlocking save and the corpus have F33 = 0 everywhere, so no earlier run took it.
usage: editor_copy_flag.py OUTDIR [--f33] [--sav FILE] [--modes 09,10,11] [--starts 10:07,...] [--coarse] [--depth N] [--cap N]   (run from the working root; corpus unlock_runs/f1_organic/corpus.jsonl)
  every distinct (mode, state) of the corpus entries in --modes (or exactly the ones in --starts) is a start state.  Each start is replayed STEP BY STEP on the save (each recorded action
  is applied in turn and 02:47FE is tested after each one, so a hit made by the replay itself is reported with the entry and the action that made it: the core's executed-byte array is
  cumulative, testing only after the replay would credit the first key tapped).  If the replay did not reach 02:47FE, tap every key from the start state (BFS, key held 4 frames, 30 released)
  until it runs.
  --f33     set F33 = 1 in both tag copies of all 30 slots of the save (block checksums recomputed): every photo is then an album copy
  --sav     replay the corpus paths on this save instead of the one the entry was recorded with (link_protocol/saves/flow1_A_sender_before.sav has 27 photos)
  --coarse  state key = (mode, state, [$CF33]) only: far fewer states, so the search gets deeper for the same cap (but it forgets cursor positions)
Writes OUTDIR/editor_copy_flag.json (hit: corpus entry, action, key path; counts; whether the save-back call site 07:6A4E ran) and OUTDIR/exec_ranges.csv (every byte executed in this process,
as ranges: witness_map.py intersects them with the never-run code of the v8 map, so what earlier runs executed does not matter)."""
import sys, os, json, hashlib
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g
import blocks as B
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'tools'))
import sram_analyze as S
a = sys.argv[1:]
def flag(n):
    if n in a: a.remove(n); return True
    return False
def opt(n, d):
    if n in a: i = a.index(n); v = a[i + 1]; del a[i:i + 2]; return v
    return d
F33 = flag('--f33'); COARSE = flag('--coarse')
MODES = [int(m, 16) for m in opt('--modes', '09,10,11').split(',')]
STARTS = opt('--starts', None)
STARTS = [tuple(int(x, 16) for x in s.split(':')) for s in STARTS.split(',')] if STARTS else None
SAVF = opt('--sav', None); depth = int(opt('--depth', '10')); cap = int(opt('--cap', '3000'))
out = a[0]; os.makedirs(out, exist_ok=True)
def with_f33(s):
    b = bytearray(s)
    for n in range(1, 31):
        base = S.slot_base(n)
        for off in (0xF00, 0xF5C):
            b[base + off + 0x33] = 1; b[base + off + 0x5A:base + off + 0x5C] = S.ck(b, base + off, 0x5A)
    return bytes(b)
SAVB = open(SAVF, 'rb').read() if SAVF else None
if F33:
    orig = lib.SAV
    lib.SAV = lambda name: (lambda s: with_f33(s) if s is not None else None)(orig(name))
    if SAVB is not None: SAVB = with_f33(SAVB)
KN = ['Right', 'Left', 'Up', 'Down', 'A', 'B', 'Select', 'Start']
KEY = dict(Right=g.RIGHT, Left=g.LEFT, Up=g.UP, Down=g.DOWN, A=g.A, B=g.B, Select=g.SELECT, Start=g.START)
C = lib.Corpus('unlock_runs/f1_organic/corpus.jsonl'); g.set_organic(1)
ex = g.cov_exec(); TGT = B.flat(2, 0x47FE); TGT2 = B.flat(7, 0x6A4E)      # 07:6A4E = call site of the save-back, reported to say whether the editor save was entered at all
def tap(k, hold=4, wait=30): g.keys(k); g.run(hold); g.keys(0); g.run(wait)
def key():
    if COARSE: return (lib.cur(), g.peek(0xCF33))
    h = hashlib.md5(bytes(g.peek(x) for x in range(0xD5D0, 0xD600)))
    return (lib.cur(), h.hexdigest(), g.peek(0xCF33))
def replay_checked(i):
    """Same as Corpus.replay (boot the root, apply every recorded action) but tests 02:47FE after each action; returns (snapshot, hit or None)."""
    p = C.path(i); sp = dict(C.E[p[0]]['spec']); hit = None
    lib.boot(SAVB if SAVB is not None else lib.SAV(sp['sav']), combo=sp['combo'], printer=sp['printer'], free=sp['free'])
    for j in p[1:]:
        for k, ac in enumerate(C.E[j]['actions']):
            lib.act(ac)
            if hit is None and ex[TGT] > 0:
                hit = {'entry': j, 'action_index': k, 'action': ac, 'state': '%02X:%02X' % lib.cur(), 'cf33': g.peek(0xCF33)}
    return g.snapshot(), p, hit
starts = {}
for i, e in C.E.items():
    s = tuple(e['sig'])
    if (s in STARTS if STARTS else s[0] in MODES) and s not in starts: starts[s] = i
print('start states:', sorted('%02X:%02X' % s for s in starts), flush=True)
res = {'f33': F33, 'coarse': COARSE, 'starts': []}; hit = None
for sig, i in sorted(starts.items()):
    snap0, p, rh = replay_checked(i)
    if rh:
        print('start %02X:%02X (corpus entry %d): 02:47FE run BY THE REPLAY, at entry %d action #%d %s (state %s, $CF33=%d)' % (*sig, i, rh['entry'], rh['action_index'], rh['action'], rh['state'], rh['cf33']), flush=True)
        res['starts'].append({'corpus_entry': i, 'start': '%02X:%02X' % sig, 'path': p, '02:47FE_by_replay': rh, 'states': 0}); hit = i; break
    seen = {key()}; frontier = [((), snap0)]; nst = 0; found = None
    for d in range(depth):
        nxt = []
        for path, snap in frontier:
            for n in KN:
                g.restore(snap); tap(KEY[n]); pp = path + (n,)
                if ex[TGT] > 0: found = list(pp); break
                kk = key()
                if kk in seen: continue
                seen.add(kk); nst += 1
                if nst < cap: nxt.append((pp, g.snapshot()))
            if found: break
        frontier = nxt
        if found or not frontier: break
    print('start %02X:%02X (corpus entry %d): %s, %d states' % (*sig, i, ('02:47FE after ' + ' '.join(found)) if found else 'not reached', nst), flush=True)
    res['starts'].append({'corpus_entry': i, 'start': '%02X:%02X' % sig, '02:47FE_after_keys': found, 'states': nst})
    if found: hit = i; break
res['save_back_call_07:6A4E_executed'] = bool(ex[TGT2] > 0); res['02:47FE_executed'] = bool(ex[TGT] > 0)
print('save-back call site 07:6A4E executed:', res['save_back_call_07:6A4E_executed'], '; 02:47FE executed:', res['02:47FE_executed'])
json.dump(res, open(out + '/editor_copy_flag.json', 'w'), indent=1)
lib.dump_exec_ranges(out + '/exec_ranges.csv', np.zeros(np.array(g.cov_exec()).shape, bool))
