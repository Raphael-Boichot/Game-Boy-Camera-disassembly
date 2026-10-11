#!/usr/bin/env python3
"""Music editor (Trippy-H, mode $1F) and its score print in BGB, with the Game Boy Printer helper (bgb_printer.py) on the link (-connect).
Route (tools/dj_route.py, found in my core): corpus entry 197 (save _ff, Up held at boot) = Space Fever II; Right held 30 frames and A pulsed from frame 6 shoots the D.J. ship -> 1F:05;
Select -> 1F:09 (SOUND I page); with --print: Start held 8 frames, Start+A 4 frames, Start 4 frames (05:4744-4758) -> score print (05:5959).
usage: bgb_dj_print.py OUTDIR [--print] [--noprinter] [--tail FRAMES] [--port N] [--system 0] [--select N] [--br ADDR[,ADDR]]   --select N = extra Select presses (SOUND II, NOISE pages)"""
import sys, os, json, shutil
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE); ROOT = os.path.dirname(HERE)
args = sys.argv[1:]
def opt(n, d=None, flag=False):
    if n in args:
        i = args.index(n)
        if flag: del args[i]; return True
        v = args[i + 1]; del args[i:i + 2]; return v
    return d
tail = int(opt('--tail', '3000')); port = int(opt('--port', '8791')); system = opt('--system', '0'); noprn = opt('--noprinter', flag=True); doprint = opt('--print', flag=True); br = opt('--br'); nsel = int(opt('--select', '0'))
out = args[0]; os.makedirs(out, exist_ok=True)
mine = '/home/claude/bgbpr%d' % (port % 100)
if not os.path.isdir(mine): shutil.copytree('/home/claude/bgbx', mine)
os.environ['BGB_DIR'] = mine
import bgb_run
from bgb_printer import PrinterServer
route = json.load(open(os.path.join(ROOT, 'unlock_runs', 'dj_route.json')))
C = {}
for l in open(os.path.join(ROOT, route['corpus'])):
    if l.strip(): e = json.loads(l); C[e['id']] = e
p = []; i = route['entry']
while i >= 0: p.append(i); i = C[i].get('parent', -1)
p = p[::-1]; sp = dict(C[p[0]]['spec'])
CORE = [(1, 'Right'), (2, 'Left'), (4, 'Up'), (8, 'Down'), (16, 'A'), (32, 'B'), (64, 'Select'), (128, 'Start')]
def names(k): return '+'.join(n for m, n in CORE if k & m) or '-'
seq = []
for j in p[1:]:
    for a in C[j]['actions']: seq.append((names(a[0]), int(a[1]), int(a[2])))
for k in route['shoot']: seq.append((names(k), 1, 0))                        # one entry per frame
seq.append(('-', route['after_shoot_idle'], 0))
seq.append(('Select', 4, 60))
for _ in range(nsel): seq.append(('Select', 4, 60))
if doprint: seq += [('Start', 8, 0), ('Start+A', 4, 0), ('Start', 4, 0)]
sav = os.path.join(out, 'in.sav'); open(sav, 'wb').write(b'\xff' * 0x20000)
extra = ['-setting', 'SystemMode=%s' % system]; srv = None
if br:                                                  # --br LIST of 'bb:aaaa': log every hit (BGB debug-message file) and count them in OUTDIR/heads_hit.json
    br = ','.join('%s///%s' % (h, h) if '///' not in h else h for h in br.split(',')); extra += ['-setting', 'DebugMsgFile=1']
    if os.path.exists(os.path.join(mine, 'debugmsg.txt')): os.remove(os.path.join(mine, 'debugmsg.txt'))
if not noprn: srv = PrinterServer(port, out).start(); extra += ['-connect', '127.0.0.1:%d' % port]
r = bgb_run.run(os.path.join(ROOT, 'pocketcamera_jp.gb'), sav, out + '/run', seq, combo=bgb_run.mask(names(sp['combo'])), free=sp['free'] + 3, extra=extra, tail=tail, br=br, timeout=900)
if srv: srv.stop()
if br:
    import collections
    lf = os.path.join(mine, 'debugmsg.txt'); cnt = collections.Counter(l.strip() for l in open(lf, errors='replace') if l.strip()) if os.path.exists(lf) else {}
    json.dump(dict(hit=len(cnt), hits=dict(sorted(cnt.items()))), open(out + '/heads_hit.json', 'w'), indent=1); print('heads hit', len(cnt))
w = r['st'].get('WRAM', b'')
print('BGB end mode:state %02X:%02X' % (r['mode'], r['state']) if r['mode'] is not None else 'no state', 'rc', r['rc'], ' $D8C6 = %02X' % w[0xD8C6 - 0xC000] if w else '')
if srv: print('link packets', srv.counts, ' printer bytes', srv.pr.bytes, ' printer packets', len(srv.pr.log), ' pages', len(srv.pr.pages)); [print('  page', pg) for pg in srv.pr.pages]
