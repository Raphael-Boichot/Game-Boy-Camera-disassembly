#!/usr/bin/env python3
"""RUN! RUN! RUN! (mode $21, bank 9) played to the end in my core with the joypad only: who finishes first, and which code runs (README 16.15).
usage: run_race.py OUTDIR [CORPUS] [ENTRY]     (run from the working root; default corpus unlock_runs/f1_organic/corpus.jsonl, entry 649 = state 21:06, the race loop)
Corpus entry 649 = save unl_CE10238211 (unlocking save) + 9 key groups from the boot menu (no RAM poke, not tainted): Space Fever II first wave, shoot the RUN! ship, character pick, start.
In the race loop (09:63D2 and the runner updates 09:6AD6, 6B00 ...) runner 0 only advances while A is pressed, about 1.8 px per press; runners 1 and 2 advance by themselves
(at frame 600: 2055 and 2832 against 3252 for A pressed every 2nd frame).  A runner finishes at x = $1400 (09:6AE5-6AEF, runner 0); the race ends (state 11) once runner 0 is beyond $1580 and at least two runners have finished (09:63E1-63F7).
$D00D / $D016 / $D01F = place of runner 0 / 1 / 2 (1, 2, 3; 09:6AF0-6AFC).  Variants: A pressed every 2nd frame (runner 0 first), every 12th frame (slower), never.
Prints the places and the state after each variant and writes OUTDIR/exec_ranges.csv (all bytes executed in this process, replay included)."""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g
import blocks as B
import numpy as np
out = sys.argv[1]; os.makedirs(out, exist_ok=True)
corpus = sys.argv[2] if len(sys.argv) > 2 else 'unlock_runs/f1_organic/corpus.jsonl'; entry = int(sys.argv[3]) if len(sys.argv) > 3 else 649
EX0 = np.zeros(len(g.cov_exec()), bool); ex = g.cov_exec()
C = lib.Corpus(corpus); g.set_organic(1); C.replay(entry); snap = g.snapshot()
def pos(): return tuple(g.peek(a) | g.peek(a + 1) << 8 for a in (0xD000, 0xD00E, 0xD017))
def show(tag): print('%-26s %02X:%02X x(runner 0,1,2)=%s places D00D=%d D016=%d D01F=%d finished D047=%d' % ((tag,) + lib.cur() + (pos(), g.peek(0xD00D), g.peek(0xD016), g.peek(0xD01F), g.peek(0xD047))))
show('start (corpus entry %d)' % entry)
VARIANTS = [('A every 2nd frame', lambda f: g.A if f % 2 == 0 else 0), ('A every 12th frame', lambda f: g.A if f % 12 == 0 else 0), ('no key', lambda f: 0),
            ('A every 3rd frame', lambda f: g.A if f % 3 == 0 else 0), ('A every 4th frame', lambda f: g.A if f % 4 == 0 else 0)]
for name, p in VARIANTS:
    g.restore(snap)
    for f in range(3000): g.keys(p(f)); g.run(1)
    g.keys(0); g.run(60); show(name)
lib.dump_exec_ranges(out + '/exec_ranges.csv', EX0)
