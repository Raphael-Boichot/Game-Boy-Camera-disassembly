#!/usr/bin/env python3
"""Localise where BGB stops following my core on one corpus lineage: for every prefix of the entry's action list (root + first k actions) print the
(mode,state) of my core and of BGB after the prefix plus 30 idle frames.  The first line where they differ is the first divergence.
usage: [DIV_SAV=SAVENAME] bgb_divergence.py CORPUS ENTRY ROM [--system 0]       (needs bgb_run.py; BGB_DIR selects the BGB directory)"""
import sys, os, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g
import bgb_run
args = sys.argv[1:]
system = '0'
if '--system' in args: i = args.index('--system'); system = args[i + 1]; del args[i:i + 2]
corpus, entry, rom = args[0], int(args[1]), args[2]
SAVOVER = os.environ.get('DIV_SAV')
C = lib.Corpus(corpus)
CORE = [(g.RIGHT, 'Right'), (g.LEFT, 'Left'), (g.UP, 'Up'), (g.DOWN, 'Down'), (g.A, 'A'), (g.B, 'B'), (g.SELECT, 'Select'), (g.START, 'Start')]
def names(k): return '+'.join(n for m, n in CORE if k & m) or '-'
p = C.path(entry); sp = dict(C.E[p[0]]['spec']); acts = []
for j in p[1:]:
    for a in C.E[j]['actions']:
        acts.append(a)
tmp = '/home/claude/gbtmp_div'; os.makedirs(tmp, exist_ok=True)
sav = os.path.join(tmp, 'in.sav'); open(sav, 'wb').write(lib.SAV(SAVOVER or sp['sav']))
print('entry', entry, 'root', sp, 'actions', len(acts))
for k in range(len(acts) + 1):
    lib.boot(lib.SAV(SAVOVER or sp['sav']), combo=sp['combo'], printer=sp['printer'], free=sp['free'])
    for a in acts[:k]: lib.act(a)
    g.run(30); cm = lib.cur()
    seq = [(names(a[0]), int(a[1]), int(a[2])) for a in acts[:k] if a[0] != 'P']
    r = bgb_run.run(rom, sav, '%s/div_%d' % (tmp, k), seq, combo=0 if not sp['combo'] else bgb_run.mask(names(sp['combo'])), free=sp['free'] + 3, extra=['-setting', 'SystemMode=%s' % system], tail=30 + 0, timeout=300)
    bm = (r['mode'], r['state'])
    print('%3d  %-26s core %02X:%02X   BGB %s   %s' % (k, ('%s %s+%s' % (names(acts[k - 1][0]), acts[k - 1][1], acts[k - 1][2])) if k else 'boot', cm[0], cm[1],
          '%02X:%02X' % bm if bm[0] is not None else '--', '' if bm == cm else '<-- differs'), flush=True)
