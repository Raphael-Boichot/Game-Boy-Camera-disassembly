#!/usr/bin/env python3
"""Hot-spot effects and sounds on the international / Gold ROMs (counterpart of tcrf_check/tools/hotspot_effects.py; a FORCED witness: one WRAM poke).
Replays the cheapest corpus entry in mode $0C state 3 (a photo shown with the hot-spot pointer, waiting for A / B), arms hot spot 0 of the displayed photo
at the pointer cell ($D667 / $D668) by writing the WRAM mirror (flag $D643, X $D648, Y $D64D, sound $D652, effect $D657, jump $D65C) and presses A.
Variants: every effect 0-15 with no sound ($FF), then effect $FF (none) with sounds 0-$1F (HotSpot_PlayJingle, the two-frame wait new in this build).
usage: GBCAM_ROM=ROM port_hotspot_forced.py CORPUS OUT.npz         ('ex' = bytes executed by the variants beyond the replay, for port_never_run.py)
PYTHONPATH: coverage/src and tcrf_check/tools; the corpus' saves must be in tcrf_check/saves or saves_unl (links to the save folders, not committed)."""
import sys, os
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, os.path.join(os.path.dirname(HERE), 'tcrf_check', 'tools'))
import lib; from lib import g
C = lib.Corpus(sys.argv[1]); out = sys.argv[2]
i = C.best((0x0C, 3))
if i is None: i = min((C.frames(j), j) for j, e in C.E.items() if tuple(e['sig']) == (0x0C, 3))[1]; print('no untainted entry: tainted entry', i)
g.set_organic(1); C.replay(i); g.run(30)
print('entry', i, 'state %02X:%02X' % lib.cur(), 'pointer', g.peek(0xD667), g.peek(0xD668), flush=True)
snap = g.snapshot(); ex = g.cov_exec(); ex0 = np.array(ex, copy=True) != 0; union = np.zeros(len(ex), bool)
def variant(eff, snd):
    g.restore(snap); px, py = g.peek(0xD667), g.peek(0xD668)
    for a, v in ((0xD643, 1), (0xD648, px), (0xD64D, py), (0xD652, snd), (0xD657, eff), (0xD65C, 0xFF)): g.poke(a, v)
    g.keys(g.A); g.run(4); g.keys(0); g.run(400)
    e = np.array(ex, copy=True) != 0; union[:] |= e & ~ex0
    print('effect %02X sound %02X -> %02X:%02X, new bytes so far %d' % (eff, snd, *lib.cur(), int(union.sum())), flush=True)
for k in range(16): variant(k, 0xFF)
for s in range(0x20): variant(0xFF, s)
np.savez_compressed(out, ex=union.astype(np.uint8)); print('->', out)
