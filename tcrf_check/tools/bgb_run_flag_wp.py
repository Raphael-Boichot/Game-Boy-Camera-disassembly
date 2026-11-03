#!/usr/bin/env python3
"""Watchpoint run of the RUN! RUN! RUN! flag hoist in BGB (2026-10-25): the corpus path of entry 649 (coverage/v8/unlock_fuzz/f1_organic) replayed from
saves_unl/unl_CE10238211.sav, then a key variant of tcrf_check/assets/run_race/race_paths.json; logs the ret of Run_FlagUpConfettiDone (A, $D048), the clamp of
Run_FlagHeight, Run_Celebration, Run_DrawCrown and the state writes.  usage: bgb_run_flag_wp.py 'VARIANT' OUTPREFIX   (BGB folder /home/claude/bgbflag, copy of /home/claude/bgbx)"""
import sys, os, json, collections, shutil
REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))); sys.path.insert(0, REPO + '/tcrf_check/tools')
D = '/home/claude/bgbflag'
if not os.path.isdir(D): shutil.copytree('/home/claude/bgbx', D)
os.environ['BGB_DIR'] = D
WP = ','.join(['09:66BA//x/RET %a% %(d048)% %(d5ce)% %(d5cf)%', '09:6BDB//x/CLAMP2 %(d048)% %(d049)%', '09:6CA1//x/CELEB %(d048)%',
               '09:7008//x/CROWN %(d048)%', 'D5CF//w/CTL %(d5ce)% %(d5cf)%'])
os.environ['BGB_WP'] = WP
import bgb_run
CORE = [(1, 'Right'), (2, 'Left'), (4, 'Up'), (8, 'Down'), (16, 'A'), (32, 'B'), (64, 'Select'), (128, 'Start')]
def names(k): return '+'.join(n for m, n in CORE if k & m) or '-'
E_ = {}
for l in open(REPO + '/coverage/v8/unlock_fuzz/f1_organic/corpus.jsonl'):
    if l.strip(): e = json.loads(l); E_[e['id']] = e
p = []; i = 649
while i >= 0: p.append(i); i = E_[i].get('parent', -1)
p = p[::-1]; sp = dict(E_[p[0]]['spec'])
seq = [(names(a[0]), int(a[1]), int(a[2])) for j in p[1:] for a in E_[j]['actions']]
PATHS = json.load(open(REPO + '/tcrf_check/assets/run_race/race_paths.json'))
var = sys.argv[1]
seq += [(names(kb), n, 0) for kb, n in PATHS[var]]
sav = '/home/claude/gbcam_jp/saves_unl/unl_CE10238211.sav'
out = sys.argv[2]
r = bgb_run.run(os.environ.get('GBCAM_ROM', '/home/claude/gbcam_jp/pocketcamera_jp.gb'), sav, out, seq, combo=0, free=sp['free'] + 3, tail=60, timeout=1800)
L = [l.strip() for l in open(D + '/debugmsg.txt', errors='replace')] if os.path.exists(D + '/debugmsg.txt') else []
shutil.copy(D + '/debugmsg.txt', out + '.debugmsg.txt') if L else None
print('root save of entry 649:', sp['sav'], ' end %02X:%02X' % (r['mode'] or 0, r['state'] or 0), ' frames', sum(h + w for _, h, w in seq))
print(collections.Counter(' '.join(l.split()[:2]) if l.startswith('RET') else l.split()[0] for l in L))
print(collections.Counter(l for l in L if not l.startswith('CTL')).most_common(12))
