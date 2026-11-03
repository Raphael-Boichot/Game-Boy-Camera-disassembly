#!/usr/bin/env python3
"""Capture, in the real BGB, the screen of the cheapest organic corpus entry that ends in a given (mode, state), on any ROM (the replay of a Japanese corpus entry on the
international ROM is a key replay: it can end elsewhere, the result line says where it ended).
usage: bgb_capture_state.py CORPUS MODE:STATE ROM OUTPREFIX [--entry ID]      (MODE:STATE in hex, e.g. 1B:01; cost = frames held + waited; env BGB_DIR = private BGB folder)
Writes OUTPREFIX.{bmp,sna,dem,sav}; prints the entry used and 'end mode:state'."""
import sys, os, json
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
os.environ.setdefault('BGB_DIR', '/home/claude/bgbts')
import bgb_run
CORE = [(1, 'Right'), (2, 'Left'), (4, 'Up'), (8, 'Down'), (16, 'A'), (32, 'B'), (64, 'Select'), (128, 'Start')]
names = lambda k: '+'.join(n for m, n in CORE if k & m) or '-'
args = sys.argv[1:]; entry = None
if '--entry' in args: i = args.index('--entry'); entry = int(args[i + 1]); del args[i:i + 2]
corpus, st, rom, out = args[:4]; sig = [int(x, 16) for x in st.split(':')]
C = {}
for l in open(corpus):
    if l.strip(): e = json.loads(l); C[e['id']] = e
def path(i):
    p = []
    while i >= 0 and i in C: p.append(i); i = C[i].get('parent', -1)
    return p[::-1]
def cost(i): return sum(a[1] + a[2] for j in path(i)[1:] for a in C[j].get('actions', []) if a[0] != 'P')
if entry is None: entry = sorted((cost(i), i) for i, e in C.items() if e['sig'] == sig and not e.get('tainted'))[0][1]
p = path(entry); sp = dict(C[p[0]]['spec']); print('entry', entry, 'root', sp)
seq = [(names(a[0]), int(a[1]), int(a[2])) for j in p[1:] for a in C[j]['actions']]
SAVES = '/home/claude/gbcam_jp/saves_unl:/home/claude/gbcam_jp/saves:/home/claude/gbcam_jp/saves_pseudo:/home/claude/gbcam_jp/intl_saves'.split(':')
sav = next((os.path.join(d, sp['sav'] + '.sav') for d in SAVES if os.path.exists(os.path.join(d, sp['sav'] + '.sav'))), None)
r = bgb_run.run(rom, sav, out, seq, combo=bgb_run.mask(names(sp['combo'])) if sp['combo'] else 0, free=sp['free'] + 3, tail=0, timeout=600)
print('end %s:%s' % (r['mode'], r['state']))
