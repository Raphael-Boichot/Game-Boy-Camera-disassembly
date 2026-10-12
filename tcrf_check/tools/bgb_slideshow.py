#!/usr/bin/env python3
"""BGB replay of the slide-show repeat markers (README 16.19) on the save written by slideshow_markers.py --loop --out-sav (list = photos 0..5, markers $82 $02 $42 $81 $41, repeat flag $FF).
usage: bgb_slideshow.py ROM SAV OUTDIR [--preview]      (the save is NOT in git: `slideshow_markers.py OUT --loop --out-sav FILE` rebuilds it from unl_CE10238211)
  Keys as the guide walk (guide_bgb_walk.py: A at the title, then direction taps held 4 frames and 60 released, other keys 200 released; boot with B held):
  player   (default)  Left (VIEW), A (VIEW menu), Right, A (SHOW menu), Down (ANIMATION), A (13:01), A (start the show), then 1500 frames: logging breakpoints (BGB writes the address to
           debugmsg.txt and goes on) on 03:6155, 03:6264, 03:629A, 03:628B (carry test of the repeat-all flag), 03:62BA, 03:611A, 03:623D
  --preview           Down, Select (STUDIO), Down, A (EDIT), Down (ANIMATION), A, A (editor 12:01), Select (12:08), Right x3, A (item 3 = play the list), then 900 frames: breakpoints on
           03:4D4B, 03:4E21, 03:4E50, 03:4D1A, 03:4DDA
Private BGB directory /home/claude/bgbs_player or /home/claude/bgbs_preview (copy of /home/claude/bgbx); BGB_HF=-headless in the sandbox. Writes OUTDIR/bgb_slideshow_{player,preview}.json and debugmsg_*.txt."""
import sys, os, json, shutil, collections
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
args = sys.argv[1:]
PREVIEW = '--preview' in args
if PREVIEW: args.remove('--preview')
rom, sav, out = args[0], args[1], args[2]
tag = 'preview' if PREVIEW else 'player'
mine = '/home/claude/bgbs_' + tag
if not os.path.isdir(mine): shutil.copytree('/home/claude/bgbx', mine)
os.environ['BGB_DIR'] = mine
import bgb_run
NAME = dict(A='A', B='B', L='Left', R='Right', U='Up', D='Down', s='Select', S='Start')
def K(t): return (NAME[t], 4, 60 if t in 'LRUD' else 200)
route = 'D s D A D A A s R R R A' if PREVIEW else 'L A R A D A A'
seq = [('A', 4, 200)] + [K(t) for t in route.split()] + [('-', 900 if PREVIEW else 1500, 0)]
targets = ['03:4D4B', '03:4E21', '03:4E50', '03:4D1A', '03:4DDA'] if PREVIEW else ['03:6155', '03:6264', '03:629A', '03:628B', '03:62BA', '03:611A', '03:623D']
log = os.path.join(mine, 'debugmsg.txt')
if os.path.exists(log): os.remove(log)
os.makedirs(out, exist_ok=True)
r = bgb_run.run(rom, sav, os.path.join(out, 'slideshow_' + tag), seq, combo=bgb_run.mask('B'), free=400, br=','.join('%s///%s' % (h, h) for h in targets),
                extra=['-setting', 'DebugMsgFile=1'], tail=60, timeout=1500)
cnt = collections.Counter(l.strip() for l in open(log, errors='replace') if l.strip()) if os.path.exists(log) else {}
res = dict(route=route, save=os.path.basename(sav), seq=seq, hits={h: cnt.get(h, 0) for h in targets}, end='%02X:%02X' % (r['mode'], r['state']) if r['mode'] is not None else None, rc=r['rc'])
json.dump(res, open(os.path.join(out, 'bgb_slideshow_%s.json' % tag), 'w'), indent=1)
print(json.dumps({k: v for k, v in res.items() if k != 'seq'}))
if os.path.exists(log): shutil.copy(log, os.path.join(out, 'debugmsg_%s.txt' % tag))
