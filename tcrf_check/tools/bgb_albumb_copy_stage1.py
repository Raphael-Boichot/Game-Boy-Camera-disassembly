#!/usr/bin/env python3
"""BGB: copy the stock pictures B01-B08 into the A album with EDIT > ALBUM > COPY and keep the resulting save (stage 1 of bgb_albumb_comments.py, README 16.27).
usage: bgb_albumb_copy_stage1.py OUTDIR [--swap A:B]      (env GBCAM_ROM = the Japanese ROM, GBCAM_SAV = a save with all unlocked and 0 photos; BGB folder /home/claude/bgbq0, copied from /home/claude/bgbx)
Writes OUTDIR/copy/stage1.sram (the 128 KB save after the copy: slots 0-7 hold B01-B08, 8 photos) and, with --swap A:B, OUTDIR/copy/stage1_swap_A_B.sram (the 0x1000-byte slots A and B
exchanged: slot contents carry their own tag block and checksum, the photo vector stays valid; used to make another picture the first one of the print screen).
Used for the print watch of README 16.25.2 (`26:7080` is not read while a copied B picture and its comment card are printed): put the save into GBCAM_ROOT/saves_pseudo/ and run
  BGB_HF=-headless BGB_WP='26:7080-26:72BF//r/T7080,26:4000-26:707F//r/B26LO,26:72C0-26:7FFF//r/B26HI,1B73-1B9F//r/CTLPKT' \\
  bgb_print_run.py unlock_runs/f1_organic/corpus.jsonl 289 ROM OUT --seq A:4:100 --tail 4000 --port 8830 --sav NAME            (one photo)
  ... --seq Start:4:40,A:4:100 ...                                                                                            (photo + comment card)
and count the message names in $BGB_DIR/debugmsg.txt (bgb_print_run.py makes /home/claude/bgbpr<port % 100> for it)."""
import sys, os, shutil
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
ROM = os.environ.get('GBCAM_ROM', '/home/claude/gbcam_jp/pocketcamera_jp.gb')
SAV = os.environ.get('GBCAM_SAV', '/home/claude/gbcam_jp/saves_unl/GAMEBOYCAMERA_all_unlocked.sav')
args = sys.argv[1:]
swap = None
if '--swap' in args:
    i = args.index('--swap'); swap = [int(x) for x in args[i + 1].split(':')]; del args[i:i + 2]
out = os.path.abspath(args[0]); os.makedirs(out + '/copy', exist_ok=True)
D0 = '/home/claude/bgbq0'
if not os.path.isdir(D0): shutil.copytree('/home/claude/bgbx', D0)
os.environ['BGB_DIR'] = D0
import bgb_run; bgb_run.BGB = D0
import guide_nodes as G
NAME = dict(A='A', B='B', L='Left', R='Right', U='Up', D='Down', s='Select', S='Start')
def K(t): return (NAME[t], 4, 60 if t in 'LRUD' else 150)
def seq(path): return [('A', 4, 200)] + [K(t) for t in G.tokens(path, 'L')]
P1 = 'A R A D L L A R A R A D L L A R A R A'        # page of 8 cells, as in bgb_albumb_comments.py
r1 = bgb_run.run(ROM, SAV, out + '/copy/stage1', seq('D s D A A A' + ' R' * 9 + ' ' + P1 + ' R'), combo=2, free=400, timeout=600, tail=2)
s1 = bytearray(r1['st']['SRAM']); open(out + '/copy/stage1.sram', 'wb').write(s1)
print('stage 1: mode %02X:%02X, photos %d' % (r1['mode'], r1['state'], r1['st']['WRAM'][0xD561 - 0xC000]))
if swap:
    def sl(i): return slice(0x2000 + i * 0x1000, 0x2000 + (i + 1) * 0x1000)
    a, b = bytes(s1[sl(swap[0])]), bytes(s1[sl(swap[1])]); s1[sl(swap[0])] = b; s1[sl(swap[1])] = a
    open(out + '/copy/stage1_swap_%d_%d.sram' % tuple(swap), 'wb').write(s1)
    print('slots %d and %d exchanged' % tuple(swap))
