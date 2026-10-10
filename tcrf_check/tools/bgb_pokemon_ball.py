#!/usr/bin/env python3
"""BGB confirmation of the Pokemon-stamp page rule with a controlled Ball value: take an unlocking save, set the Ball hundreds byte (SRAM $10CA and its
echo $11A3), recompute the two settings checksums ($10D7-$10D8 and $11B0-$11B1), replay the joypad-only path to the stamp tool (sig 11:04) in the real BGB
and print $DAA5, $D642 (expected min($DAA5,5)+4).   usage: bgb_pokemon_ball.py OUTDIR [VALUE ...]   (default 0 1 2 3 4 5 6 0x10)"""
import sys, os
out = sys.argv[1]; vals = [int(x, 0) for x in sys.argv[2:]] or [0, 1, 2, 3, 4, 5, 6, 0x10]
sys.argv = ['x', 'unlock_runs/f1_organic/corpus.jsonl', 'pocketcamera_jp.gb', out]
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import bgb_sig, bgb_run, sram_analyze as S
sp, seq, i = bgb_sig.seq_for('11:04')
base = os.path.join(os.path.dirname(os.path.abspath(bgb_sig.__file__)), '..', 'saves_unl', 'unl_CE10238211.sav')
b0 = open(base, 'rb').read(); os.makedirs(out, exist_ok=True)
for v in vals:
    b = bytearray(b0); b[0x10CA] = v; b[0x11A3] = v
    for blk in (0x1000, 0x10D9): b[blk + 0xD7:blk + 0xD9] = S.ck(b, blk, 0xD7)
    f = '%s/in_ball_%02d.sav' % (out, v); open(f, 'wb').write(b)
    r = bgb_run.run('pocketcamera_jp.gb', f, '%s/pk_ball_%02d' % (out, v), seq, combo=bgb_run.mask(bgb_sig.names(sp['combo'])) if sp['combo'] else 0, free=sp['free'] + 3)
    w = r['st']['WRAM']; daa5, d642 = w[0xDAA5 - 0xC000], w[0xD642 - 0xC000]
    print('SRAM $10CA = %02X: $DAA5 = %02X  $D642 = %02X  expected %02X  mode:state %02X:%02X  %s' % (v, daa5, d642, min(daa5, 5) + 4, r['mode'], r['state'], 'ok' if d642 == min(daa5, 5) + 4 and (r['mode'], r['state']) == (0x11, 4) else 'CHECK'), flush=True)
