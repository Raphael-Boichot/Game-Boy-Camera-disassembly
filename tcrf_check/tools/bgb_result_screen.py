#!/usr/bin/env python3
"""Replay in BGB the corpus path to mode:state 14:0B (shutter with the album full: "フィルムに空きが必要です。" / "no blank frames.") and log every write of the music
and SFX mailboxes ($DD68 / $DD60, README 16.20): which tune the shared result screen 09:7290 asks for.
usage: bgb_result_screen.py ROM OUTDIR TAG      (run from the working root; BGB_DIR = a private copy of the BGB folder, debugmsg.txt is written next to the exe)
Writes OUTDIR/TAG.{dem,sna,bmp}, OUTDIR/TAG_debugmsg.txt; prints the last music requests (the last "SND68 xx" is the tune: $28 / $29 / $30 / $2A)."""
import sys, os, shutil
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault('BGB_DIR', '/tmp/bgb_result_screen')
if not os.path.isdir(os.environ['BGB_DIR']): shutil.copytree(os.environ.get('BGB_SRC', 'bgbx'), os.environ['BGB_DIR'])
rom, out, tag = sys.argv[1], sys.argv[2], sys.argv[3]
sys.argv = ['bgb_sig', 'unlock_runs/f1_organic/corpus.jsonl', rom, out]       # bgb_sig reads sys.argv[1:4] at import
import bgb_run, bgb_sig
os.makedirs(out, exist_ok=True)
sp, seq, i = bgb_sig.seq_for('14:0B')
sav = os.path.join('saves_unl', sp['sav'] + '.sav')
lf = os.path.join(os.environ['BGB_DIR'], 'debugmsg.txt')
if os.path.exists(lf): os.remove(lf)
wp = 'DD68//w/SND68 %VALUE% %ROMBANK% %PC% %TOTALCLKS%,DD60//w/SND60 %VALUE% %ROMBANK% %PC% %TOTALCLKS%'
res = bgb_run.run(rom, sav, out + '/' + tag, seq, combo=0 if not sp['combo'] else bgb_run.mask(bgb_sig.names(sp['combo'])), free=sp['free'], extra=['-setting', 'DebugMsgFile=1', '-wp', wp])
print(tag, 'corpus entry', i, 'rc', res['rc'], 'mode:state %02X:%02X' % (res['mode'] or 0, res['state'] or 0))
lines = open(lf, errors='replace').read().splitlines() if os.path.exists(lf) else []
open(out + '/' + tag + '_debugmsg.txt', 'w').write('\n'.join(lines) + '\n')
v = [l for l in lines if 'SND68' in l and 'SND68 00' not in l]
print('music mailbox writes (non-zero):', len(v)); print('\n'.join(v[-6:]))
w = res['st'].get('WRAM', b'')
if w: print('$DBCF (message id) = %02X, $D529 (RNG index) = %02X' % (w[0x1BCF], w[0x1529]))
