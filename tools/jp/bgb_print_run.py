#!/usr/bin/env python3
"""Replay a corpus lineage in BGB with the Game Boy Printer helper (bgb_printer.py) attached through the link (-connect), and report what was printed.
usage: bgb_print_run.py CORPUS ENTRY ROM OUTDIR [--tail FRAMES] [--port N] [--system 0] [--noprinter] [--br LIST] [--seq 'Start:4:30,A:4:600'] [--ins 13:Right:4:40,Down:4:40] [--sav SAVENAME] [--cut N] [--heads FILE.json]
OUTDIR gets run.dem/.sna/.bmp, printer_log.json and page_NN.png.   (--noprinter: same run without the helper, for comparison)"""
import sys, os, json, shutil
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
args = sys.argv[1:]
def opt(name, default=None, flag=False):
    if name in args:
        i = args.index(name)
        if flag: del args[i]; return True
        v = args[i + 1]; del args[i:i + 2]; return v
    return default
TMO = None
tail = int(opt('--tail', '900')); port = int(opt('--port', '8791')); system = opt('--system', '0'); noprn = opt('--noprinter', flag=True); br = opt('--br'); extra_seq = opt('--seq'); ins = opt('--ins'); savover = opt('--sav'); cut = opt('--cut'); headsf = opt('--heads')
corpus, entry, rom, out = args[0], int(args[1]), args[2], args[3]
os.makedirs(out, exist_ok=True)
mine = '/home/claude/bgbpr%d' % (port % 100)
if not os.path.isdir(mine): shutil.copytree('/home/claude/bgbx', mine)
os.environ['BGB_DIR'] = mine
import bgb_run
from bgb_printer import PrinterServer
ROOT = os.path.dirname(HERE)
CORE = [(1, 'Right'), (2, 'Left'), (4, 'Up'), (8, 'Down'), (16, 'A'), (32, 'B'), (64, 'Select'), (128, 'Start')]
def names(k): return '+'.join(n for m, n in CORE if k & m) or '-'
C = {}
for l in open(corpus):
    if l.strip(): e = json.loads(l); C[e['id']] = e
p = []; i = entry
while i >= 0: p.append(i); i = C[i].get('parent', -1)
p = p[::-1]; sp = dict(C[p[0]]['spec']); seq = []
for j in p[1:]:
    for a in C[j]['actions']: seq.append((names(a[0]), int(a[1]), int(a[2])))
sav = None
for d in ('saves_unl', 'saves', 'intl_saves', 'saves_pseudo'):
    f = os.path.join(ROOT, d, (savover or sp['sav']) + '.sav')
    if os.path.exists(f): sav = f; break
if cut: seq = seq[:int(cut)]                          # --cut N = keep only the first N actions of the lineage
if ins:                                               # --ins N:KEYS:h:w,KEYS:h:w  = insert keys after the first N actions of the lineage
    n, rest = ins.split(':', 1); n = int(n); add = []
    for it in rest.split(','):
        k, h, w = it.split(':'); add.append((k, int(h), int(w)))
    seq[n:n] = add
if extra_seq:
    for it in extra_seq.split(','):
        k, h, w = it.split(':'); seq.append((k, int(h), int(w)))
extra = ['-setting', 'SystemMode=%s' % system]
heads = None
if headsf:                                              # --heads FILE.json: log (not break at) every listed block head 'bb:aaaa' and count the hits
    heads = json.load(open(headsf)); br = ','.join('%s///%s' % (h, h) for h in heads); extra += ['-setting', 'DebugMsgFile=1']
    if os.path.exists(os.path.join(mine, 'debugmsg.txt')): os.remove(os.path.join(mine, 'debugmsg.txt'))
srv = None
if not noprn:
    srv = PrinterServer(port, out).start(); extra += ['-connect', '127.0.0.1:%d' % port]
TMO = int(opt('--timeout', '900'))
try:
    r = bgb_run.run(rom, sav, out + '/run', seq, combo=0 if not sp['combo'] else bgb_run.mask(names(sp['combo'])), free=sp['free'] + 3, extra=extra, tail=tail, br=br, timeout=TMO)
except Exception as ex:
    print('BGB run failed:', type(ex).__name__)
    os.system("pkill -f 'wine.*[b]gb.exe'")
    if srv: srv.stop(); print('link packets', srv.counts, 'printer bytes', srv.pr.bytes, 'packets', len(srv.pr.log), 'pages', len(srv.pr.pages))
    sys.exit(1)
if srv: srv.stop()
if heads is not None:
    import collections
    lf = os.path.join(mine, 'debugmsg.txt'); cnt = collections.Counter(l.strip() for l in open(lf, errors='replace') if l.strip()) if os.path.exists(lf) else {}
    json.dump(dict(listed=len(heads), hit=len(cnt), hits=dict(sorted(cnt.items()))), open(out + '/heads_hit.json', 'w'), indent=1); print('heads listed', len(heads), 'hit', len(cnt))
print('entry', entry, 'root', sp, 'core end sig', C[entry]['sig'], '-> BGB end %02X:%02X' % (r['mode'], r['state']) if r['mode'] is not None else 'no state', 'rc', r['rc'])
if srv:
    print('link packets', srv.counts, ' printer bytes', srv.pr.bytes, ' printer packets', len(srv.pr.log), ' pages', len(srv.pr.pages))
    for pg in srv.pr.pages: print('  page', pg)
