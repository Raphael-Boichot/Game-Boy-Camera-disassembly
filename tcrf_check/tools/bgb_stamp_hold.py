#!/usr/bin/env python3
"""BGB confirmation of the stamp tool's hold-A mirror (04:5E4C): reach the placement state of mode $11 with a joypad-only path,
then hold A for N frames and dump the four stamp work buffers ($C000,$C1E0,$C3C0,$C5A0; 480 bytes each) from the BGB state.
Expected (core, README 15.4): unchanged up to 179 frames, mirrored after 180..279, original again from 280 (period 2).
usage: bgb_stamp_hold.py ROM OUTDIR [N ...]"""
import sys, os, hashlib
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
rom, out = sys.argv[1], sys.argv[2]
Ns = [int(x) for x in sys.argv[3:]] or [0, 150, 175, 185, 230, 275, 285, 330, 385, 395]
sys.argv = ['x', os.environ.get('CORPUS', 'unlock_runs/f1_organic/corpus.jsonl'), rom, out]
import bgb_sig, bgb_run
os.makedirs(out, exist_ok=True)
sp, seq, i = bgb_sig.seq_for('11:04')
base = os.path.dirname(os.path.abspath(bgb_sig.__file__))
sav = os.path.join(base, '..', 'saves_unl', sp['sav'] + '.sav')
if not os.path.exists(sav): sav = os.path.join(base, '..', 'saves', sp['sav'] + '.sav')
BUF = [0xC000, 0xC1E0, 0xC3C0, 0xC5A0]
ref = None
for N in Ns:
    s2 = list(seq) + ([('A', N, 0)] if N else []) + [('-', 40, 0)] * 0
    r = bgb_run.run(rom, sav, '%s/hold_%03d' % (out, N), s2, combo=bgb_run.mask(bgb_sig.names(sp['combo'])) if sp['combo'] else 0, free=sp['free'] + int(os.environ.get('BGB_SHIFT', 3)), tail=2)
    w = r['st']['WRAM']
    h = [hashlib.md5(w[a - 0xC000:a - 0xC000 + 0x1E0]).hexdigest()[:8] for a in BUF]
    if ref is None: ref = h
    print('A held %3d frames: mode:state %02X:%02X  buffers' % (N, r['mode'], r['state']), ' '.join(h), '' if N == 0 else ('== original' if h == ref else '!= original'), '  $D641 timer =', w[0xD641 - 0xC000], flush=True)
