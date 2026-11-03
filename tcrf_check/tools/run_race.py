#!/usr/bin/env python3
"""RUN! RUN! RUN! (mode $21, bank 9) played to the end in my core with the joypad only: who finishes first, and which code runs (README 16.15, 16.17).
usage: run_race.py OUTDIR [CORPUS] [ENTRY]     (run from the working root; default corpus unlock_runs/f1_organic/corpus.jsonl, entry 649 = state 21:06, the race loop of race 1)
Corpus entry 649 = save unl_CE10238211 (unlocking save) + 9 key groups from the boot menu (no RAM poke, not tainted): Space Fever II first wave, shoot the RUN! ship, character pick, start.
Rules read in bank 9 (README 16.17): A = one running step, Up = jump (09:67C5; B held in the air raises the jump 09:6830), 24 px hurdles stop the runner for 5 frames when he is on the ground (09:69EF).
Runner 1 and 2 are not driven by keys: in steady state runner 1 does 3 px/frame, runner 2 does 4 (5 once the player has led by $A0, $D050); every 4th race since power-on ($D04F and 3 = 0, the counter
is incremented at the end of state 04 and never cleared) runner 1 uses the faster table (5 px/frame) and beats runner 2.
A runner finishes at x = $1400; the race ends (state 0B) once runner 0 is beyond $1580 and at least two runners have finished (09:63E1-63F7); a runner that has not finished gets place 3 (09:63FE, 6409, 6414).
$D00D / $D016 / $D01F = place of runner 0 / 1 / 2.
Variants: race 1 with A pressed at several rates, held, never, with jumps (Up) and B; then races 1-3 played with A every 2nd frame, each followed by Start on the result screen and A presses
until the next race loop (state 06), and race 4 played at several A rates.
Writes OUTDIR/exec_ranges.csv (all bytes executed in this process, replay included), exec_by_variant.csv (variant,bank,start,end: bytes executed beyond the replay of ENTRY, per variant), race_runs.csv (one row per variant), race_paths.json (key bytes of the variants replayed in BGB after the
replay of ENTRY, run-length coded [core key byte, frames]; the core key bits are Right 1 Left 2 Up 4 Down 8 A 16 B 32 Select 64 Start 128) used by bgb_run_race.py."""
import sys, os, json, csv
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g
import numpy as np
out = sys.argv[1]; os.makedirs(out, exist_ok=True)
corpus = sys.argv[2] if len(sys.argv) > 2 else 'unlock_runs/f1_organic/corpus.jsonl'; entry = int(sys.argv[3]) if len(sys.argv) > 3 else 649
C = lib.Corpus(corpus); g.set_organic(1); C.replay(entry); snap = g.snapshot()
EX0 = lib.exec_baseline(); ex = g.cov_exec(); UNION = np.zeros(len(EX0), bool)
def x16(a): return g.peek(a) | g.peek(a + 1) << 8
def places(): return (g.peek(0xD00D), g.peek(0xD016), g.peek(0xD01F))
KEYS = []
def step(k):
    g.keys(k); g.run(1); KEYS.append(k)
def rle(keys):
    r = []
    for k in keys:
        if r and r[-1][0] == k: r[-1][1] += 1
        else: r.append([k, 1])
    return r
ROWS = []; PATHS = {}; BYV = []
def ranges(mask):
    new = np.flatnonzero(mask); rows = []
    for o in new:
        o = int(o); b = o >> 14 if o >= 0x4000 else 0; a = o if b == 0 else 0x4000 + (o & 0x3FFF)
        if rows and rows[-1][0] == b and rows[-1][2] == a - 1: rows[-1][2] = a
        else: rows.append([b, a, a])
    return rows
def finish(name, note, keys_from, first, extra=''):
    """store the variant: executed bytes since the start of the variant, places, key path"""
    global UNION
    cur = (np.array(ex, copy=True) != 0)
    new = cur & ~EX0; UNION |= new
    for b, a, e in ranges(new): BYV.append((name, b, a, e))
    m, s = lib.cur()
    ROWS.append(dict(variant=name, end='%02X:%02X' % (m, s), r0=g.peek(0xD00D), r1=g.peek(0xD016), r2=g.peek(0xD01F), race_counter=g.peek(0xD04F), D050=g.peek(0xD050),
                     first_frames=json.dumps({str(k): v for k, v in first.items()}), frames=len(KEYS) - keys_from, note=note))
    PATHS[name] = rle(KEYS)
    print('%-34s end %02X:%02X places(r0,r1,r2)=%s race#%d first=%s' % (name, m, s, places(), g.peek(0xD04F), first), flush=True)
HURDLES = [0x180, 0x380, 0x580, 0x680, 0x880, 0x940, 0xb40, 0xc40, 0xd00, 0xf00, 0x1000, 0x1200]       # x of the 12 hurdles, word table 09:6F9B
def autopilot(lead=30, delay=0):
    """A every 2nd frame; Up once when the next hurdle is at most `lead` px ahead and the runner is on the ground (a stumble costs 5 frames; a collision needs the runner on the ground
    while 0 < x - hurdle <= 24, 09:69EF); `delay` frames without any key at the start"""
    jumped = set()
    def pat(f):
        if f < delay: return 0
        k = A if (f - delay) % 2 == 0 else 0
        x0 = x16(0xD000); air = (g.peek(0xD009) & 0x7F) >= 0x0C
        for h in HURDLES:
            if h in jumped: continue
            if x0 <= h + 24:
                if not air and 0 <= h - x0 <= lead: k |= UP; jumped.add(h)
                break
        return k
    return pat
def race(pat, maxf=6000, tail=200, first=None, tailpat=lambda i: 0):
    """play the race loop (states 06, 07, 0B) with pat(f), then sit on the result screen `tail` frames with tailpat(i)"""
    f = 0; first = {} if first is None else first
    while lib.cur()[0] == 0x21 and lib.cur()[1] in (0x06, 0x07, 0x0B) and f < maxf:
        step(pat(f)); f += 1
        for i, a in enumerate((0xD00D, 0xD016, 0xD01F)):
            if i not in first and g.peek(a): first[i] = (f, g.peek(a))
    for i in range(tail): step(tailpat(i))
    return first
def to_race(maxf=4000):
    """result screen -> next race loop: Start on the result screen, then A presses (character pick, intro)"""
    f = 0
    while lib.cur() != (0x21, 0x06) and f < maxf:
        s = lib.cur()[1]
        step(g.START if (s in (0x0C, 0x0D) and f % 20 == 0) else (g.A if (s not in (0x0C, 0x0D) and f % 8 == 0) else 0)); f += 1
    return f
def start(): g.restore(snap); ex[:] = EX0.astype(np.uint8); KEYS.clear()
A, UP, B = g.A, g.UP, g.B
def every(p, key=None): return lambda f: (A if f % p == 0 else 0)
V1 = [('race 1, A every 2nd frame', every(2), 'player first'), ('race 1, A every 3rd frame', every(3), ''), ('race 1, A every 4th frame', every(4), ''),
      ('race 1, A every 6th frame', every(6), ''), ('race 1, A every 8th frame', every(8), 'player second'), ('race 1, A every 12th frame', every(12), ''),
      ('race 1, A every 16th frame', every(16), 'player third'), ('race 1, A every 30th frame', every(30), ''),
      ('race 1, A held', lambda f: A, 'a held key is no new press: the runner does not move'), ('race 1, no key', lambda f: 0, 'the race never ends (3000 frames)'),
      ('race 1, A every 2nd + Up every 32nd', lambda f: (A if f % 2 == 0 else 0) | (UP if f % 32 == 0 else 0), 'a jump lasts about 30 frames: hurdles are cleared'),
      ('race 1, A every 2nd + Up every 32nd + B held', lambda f: (A if f % 2 == 0 else 0) | (UP if f % 32 == 0 else 0) | B, 'B held in the air raises the jump'),
      ('race 1, A every 16th + Up every 32nd', lambda f: (A if f % 16 == 0 else 0) | (UP if f % 32 == 0 else 0), 'a jump freezes the speed counter: the runner never gets going (6000 frames)'),
      ('race 1, A every 2nd + Up before each hurdle', autopilot(30), 'no stumble: x = $1400 at frame 881 instead of 939'),
      ('race 1, A every 2nd, then A on the result screen', every(2), 'result screen: A every 2nd frame sends the winner to the top (D048 = 2)'),
      ('race 1, A every 2nd, then one A tap on the result screen', every(2), 'result screen: one tap, the winner hops and lands (sound requests $41 on take-off, $40 on landing)')]
for name, pat, note in V1:
    start(); k0 = 0
    tp = (lambda i: A if i % 2 == 0 else 0) if name.endswith('then A on the result screen') else (lambda i: A if i == 2 else 0) if 'one A tap' in name else (lambda i: 0)
    first = race(pat, maxf=3000 if 'no key' in name or 'held' in name else 6000, tail=60 if 'no key' in name or 'held' in name else 1500 if name.endswith('then A on the result screen') else 400 if 'result screen' in name else 200, tailpat=tp)
    finish(name, note, k0, first)
# races 1-3 with A every 2nd frame (player first), then race 4
start(); k0 = 0
for n in (1, 2, 3):
    race(every(2)); f = to_race()
    print('  race %d played, results %s, next race loop after %d frames, race counter $D04F = %d' % (n, places(), f, g.peek(0xD04F)), flush=True)
chain = list(KEYS); snap4 = g.snapshot(); ex4 = np.array(ex, copy=True)
finish('races 1-3 (A every 2nd) and the way to race 4', 'player first three times; runner 1 third', k0, {})
for p in (2, 3, 4, 6, 8, 12, 16):
    g.restore(snap4); ex[:] = ex4; KEYS[:] = chain
    first = race(every(p)); finish('race 4, A every %d%s frame' % (p, {2: 'nd', 3: 'rd'}.get(p, 'th')), 'race counter 4: runner 1 uses the fast table', len(chain), first)
for name, pat, note in [('race 4, A every 2nd + Up every 32nd', lambda f: (A if f % 2 == 0 else 0) | (UP if f % 32 == 0 else 0), 'jumping without looking at the hurdles'),
                        ('race 4, A every 2nd + Up before each hurdle', autopilot(30), 'fastest run: runner 1 second, runner 2 unplaced when the race ends: 09:6414 gives it place 3'),
                        ('race 4, Up before each hurdle, 40 frames late', autopilot(30, 40), 'same, 40 frames late: runner 2 still unplaced')]:
    g.restore(snap4); ex[:] = ex4; KEYS[:] = chain
    first = race(pat); finish(name, note, len(chain), first)
ex[:] = (EX0 | UNION).astype(np.uint8)
lib.dump_exec_ranges(out + '/exec_ranges.csv', np.zeros(len(EX0), bool))          # everything executed in this process, the replay included (as the earlier version of this script)
with open(out + '/exec_by_variant.csv', 'w') as fh:
    fh.write('variant,bank,start,end\n')
    for v, b, a, e in BYV: fh.write('"%s",%02X,%04X,%04X\n' % (v, b, a, e))
with open(out + '/race_runs.csv', 'w', newline='') as fh:
    w = csv.DictWriter(fh, fieldnames=list(ROWS[0]), lineterminator='\n'); w.writeheader(); w.writerows(ROWS)
KEEP = ['race 1, A every 2nd + Up before each hurdle', 'race 1, A every 8th frame', 'race 1, A every 16th frame', 'race 4, A every 2nd + Up before each hurdle', 'race 4, A every 6th frame',
        'race 4, A every 16th frame', 'race 1, A every 2nd, then one A tap on the result screen', 'race 1, A every 2nd, then A on the result screen']                          # the variants bgb_run_race.py replays
json.dump({k: v for k, v in PATHS.items() if k in KEEP}, open(out + '/race_paths.json', 'w'), separators=(',', ':'))
