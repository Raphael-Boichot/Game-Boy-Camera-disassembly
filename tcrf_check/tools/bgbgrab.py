"""BGB helpers: replay a corpus entry in the real BGB, append keys, return screenshot + VRAM/OAM/WRAM from the state file."""
import sys, os, shutil, json
ROOT = os.environ.get('GBCAM_ROOT', '/home/claude/gbcam_jp')   # the working root of README 16.15 (core, tools/lib.py, the ROM)
BGBX = os.environ.get('BGB_DIR', '/home/claude/bgbx')
os.chdir(ROOT); sys.path.insert(0, 'tools')
os.environ.setdefault('BGB_DIR', BGBX)
import lib
import bgb_run
from lib import g
NAMES = [(g.RIGHT, 'Right'), (g.LEFT, 'Left'), (g.UP, 'Up'), (g.DOWN, 'Down'), (g.A, 'A'), (g.B, 'B'), (g.SELECT, 'Select'), (g.START, 'Start')]
def names(k): return '+'.join(n for m, n in NAMES if k & m) or '-'
C = lib.Corpus('unlock_runs/f1_organic/corpus.jsonl')
def entry(sig):
    i = C.best(sig) if not isinstance(sig, int) else sig
    p = C.path(i); sp = dict(C.E[p[0]]['spec']); seq = []
    for j in p[1:]:
        for a in C.E[j]['actions']:
            assert a[0] != 'P', 'poke in path'
            seq.append((names(a[0]), int(a[1]), int(a[2])))
    sav = lib.SAV(sp['sav'])
    return i, sp, seq, sav
def grab(prefix, sp, sav, seq, bgbdir=None, shift=3, tail=2, timeout=2400):
    d = bgbdir or os.environ['BGB_DIR']
    if not os.path.isdir(d): shutil.copytree(BGBX, d)
    os.environ['BGB_DIR'] = d; bgb_run.BGB = d
    os.makedirs(os.path.dirname(os.path.abspath(prefix)), exist_ok=True)
    sv = prefix + '_in.sav'; open(sv, 'wb').write(sav)
    r = bgb_run.run('pocketcamera_jp.gb', sv, prefix, seq, combo=bgb_run.mask(names(sp['combo'])) if sp['combo'] else 0, free=sp['free'] + shift, tail=tail, timeout=timeout)
    return r
