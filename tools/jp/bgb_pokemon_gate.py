#!/usr/bin/env python3
"""BGB confirmation of the Pokemon-stamp page rule (04:5827): $D642 = min($DAA5, 5) + 4, where $DAA5 = hundreds byte of the Ball record (SRAM $10CA).
Replays the joypad-only path to the stamp tool (sig 11:04) on every save of a folder and prints $DAA5, $D642 and mode:state.
usage: bgb_pokemon_gate.py OUTDIR SAVE.sav [SAVE.sav ...]"""
import sys, os
out = sys.argv[1]; saves = sys.argv[2:]
sys.argv = ['x', 'unlock_runs/f1_organic/corpus.jsonl', 'pocketcamera_jp.gb', out]
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import bgb_sig, bgb_run
sp, seq, i = bgb_sig.seq_for('11:04')
ok = bad = skipped = 0
for f in saves:
    nm = os.path.basename(f)[:-4]
    r = bgb_run.run('pocketcamera_jp.gb', f, '%s/pk_%s' % (out, nm), seq, combo=bgb_run.mask(bgb_sig.names(sp['combo'])) if sp['combo'] else 0, free=sp['free'] + 3)
    w = r['st']['WRAM']; daa5, d642 = w[0xDAA5 - 0xC000], w[0xD642 - 0xC000]
    exp = min(daa5, 5) + 4; at4 = (r['mode'], r['state']) == (0x11, 4)
    flag = ('ok' if d642 == exp else 'MISMATCH') if at4 else '(path did not reach 11:04: rule not tested)'
    ok += flag == 'ok'; bad += flag == 'MISMATCH'; skipped += not at4
    print('%-34s $DAA5=%02X $D642=%02X expected %02X mode:state %02X:%02X %s' % (nm, daa5, d642, exp, r['mode'], r['state'], flag), flush=True)
print('rule holds on', ok, 'saves; mismatches', bad, '; path did not reach 11:04 on', skipped, 'saves (not tested)')
