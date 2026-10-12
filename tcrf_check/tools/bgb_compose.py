#!/usr/bin/env python3
"""BGB replay of the photo pickers of the two-photo COMPOSE layout (mode $17, d600 = 1; README 16.19).
In state 17:0A A opens the picker of the selected picture (state 17:0B for picture 1, 17:0C for picture 2); the picker (06:5750) changes the photo only WHILE A STAYS HELD (06:524D: `ldh a,[$ffa1] ; bit 0,a ; ret nz`,
A released = confirm and back to 17:0A): Up = +1 (wraps at $1E + [$D562] to 0: 06:5769), Down = -1 (wraps from 0 to the last one: 06:5779).  A changed photo number runs 06:523B (picture 1) / 06:5276 (picture 2).
A tap of A (the key searches of README 16.15 used taps and the eight single keys) leaves the picker at once, which is why the three pieces never ran.
usage: bgb_compose.py CORPUS ENTRY ROM OUTDIR [--shot]      (run from the working root; ENTRY = a corpus entry sitting in 17:0A on a used save: 610 = unl_PC10696894, 30 photos)
  replays the joypad lineage of ENTRY in BGB, then: hold A (picker 1), Up (+1: 06:523B), Down, Down (wrap to the last photo: 06:5779), Up (wrap to 0: 06:5769), release A, Right, hold A (picker 2), Up (06:5276), release.
  Logging breakpoints (BGB writes the address to debugmsg.txt and goes on) on 06:523B, 06:5276, 06:5769, 06:5779, 06:5750; the counts and the end state go to OUTDIR/bgb_compose.json.
  --shot  stop the sequence in picker 1 right after the first Up (A still held): the screenshot shows the COMPOSE screen with the photo changed (OUTDIR/compose_picker.bmp)
Private BGB directory /home/claude/bgbc (copy of /home/claude/bgbx); BGB_HF=-headless in the sandbox."""
import sys, os, json, shutil, collections
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
args = sys.argv[1:]
SHOT = '--shot' in args
if SHOT: args.remove('--shot')
corpus, entry, rom, out = args[0], int(args[1]), args[2], args[3]
mine = '/home/claude/bgbc'
if not os.path.isdir(mine): shutil.copytree('/home/claude/bgbx', mine)
os.environ['BGB_DIR'] = mine
import bgb_run
CORE = [(1, 'Right'), (2, 'Left'), (4, 'Up'), (8, 'Down'), (16, 'A'), (32, 'B'), (64, 'Select'), (128, 'Start')]
def names(k): return '+'.join(n for m, n in CORE if k & m) or '-'
C = {}
for l in open(corpus):
    if l.strip(): e = json.loads(l); C[e['id']] = e
p = []; i = entry
while i >= 0: p.append(i); i = C[i].get('parent', -1)
p = p[::-1]; sp = dict(C[p[0]]['spec']); assert all(isinstance(a[0], int) for j in p[1:] for a in C[j]['actions']), 'the lineage has non-joypad actions'
seq = [(names(a[0]), int(a[1]), int(a[2])) for j in p[1:] for a in C[j]['actions']]
sav = next(f for f in (os.path.join(d, sp['sav'] + '.sav') for d in ('saves_unl', 'saves', 'intl_saves')) if os.path.exists(f))
PICK = [('A', 6, 0)]
step = lambda key: [(key, 4, 0), ('A', 14, 0)]
chain = PICK + step('A+Up')
if not SHOT:
    chain += step('A+Down') + step('A+Down') + step('A+Up') + [('-', 40, 0), ('Right', 4, 20), ('A', 6, 0)] + step('A+Up') + [('-', 40, 0)]
else:
    chain += [('A', 20, 0)]
log = os.path.join(mine, 'debugmsg.txt')
if os.path.exists(log): os.remove(log)
targets = ['06:523B', '06:5276', '06:5769', '06:5779', '06:5750']
os.makedirs(out, exist_ok=True)
r = bgb_run.run(rom, sav, os.path.join(out, 'compose_picker' if SHOT else 'compose'), seq + chain, combo=bgb_run.mask(names(sp['combo'])) if sp['combo'] else 0, free=sp['free'] + 3,
                br=','.join('%s///%s' % (h, h) for h in targets), extra=['-setting', 'DebugMsgFile=1'], tail=60, timeout=900)
cnt = collections.Counter(l.strip() for l in open(log, errors='replace') if l.strip()) if os.path.exists(log) else {}
res = dict(entry=entry, save=sp['sav'], lineage_actions=len(seq), chain=chain, hits={h: cnt.get(h, 0) for h in targets}, end='%02X:%02X' % (r['mode'], r['state']) if r['mode'] is not None else None,
           d7f7_d7f8=[r['st']['WRAM'][0x17F7], r['st']['WRAM'][0x17F8]] if r.get('st') and 'WRAM' in r['st'] else None, shot=r['shot'], rc=r['rc'])
json.dump(res, open(os.path.join(out, 'bgb_compose_shot.json' if SHOT else 'bgb_compose.json'), 'w'), indent=1)
print(json.dumps({k: v for k, v in res.items() if k != 'chain'}))
if os.path.exists(log): shutil.copy(log, os.path.join(out, 'debugmsg_shot.txt' if SHOT else 'debugmsg.txt'))
