#!/usr/bin/env python3
"""BGB confirmation of the credits gate: replay the joypad-only path of corpus entry for sig 08:17 (dancing-man credits, mode $08 state $17)
on (a) the unlocking save it was found with and (b) the matching ordinary save, in the real BGB.
usage: bgb_credits_gate.py OUTDIR"""
import sys, os
out = sys.argv[1]
sys.argv = ['x', 'unlock_runs/f1_organic/corpus.jsonl', 'pocketcamera_jp.gb', out]
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import bgb_sig, bgb_run
base = os.path.dirname(os.path.abspath(bgb_sig.__file__))
sp, seq, i = bgb_sig.seq_for('08:17')
print('corpus entry', i, 'save', sp['sav'], 'combo', sp['combo'], 'actions', len(seq))
for label, name in (('unlocking save', sp['sav']), ('ordinary save', sp['sav'].replace('unl_', '').replace('hs_', ''))):
    f = os.path.join(base, '..', 'saves_unl', name + '.sav')
    if not os.path.exists(f): f = os.path.join(base, '..', 'saves', name + '.sav')
    r = bgb_run.run('pocketcamera_jp.gb', f, '%s/gate_%s' % (out, label.split()[0]), seq, combo=bgb_run.mask(bgb_sig.names(sp['combo'])) if sp['combo'] else 0, free=sp['free'] + 3)
    w = r['st']['WRAM']
    print('%-15s (%s): BGB mode:state %02X:%02X   best_run $DAA6/$DAA7 = %02X %02X (stored, nine\'s complement)' % (label, name, r['mode'], r['state'], w[0xDAA6 - 0xC000], w[0xDAA7 - 0xC000]), flush=True)
