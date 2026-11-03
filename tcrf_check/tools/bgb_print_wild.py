#!/usr/bin/env python3
"""Print one photo with wild frame PAGE (0-7 = frames 01-08; the Japanese ROM needs the CoroCoro tag for 07-08, the saves_unl save has it) in BGB with the printer helper attached.
Path: main menu VIEW, album, PRINT icon, Select, Down (frames), Right (wild), A, PAGE x Right, A (preview 1C:03), A (print engine 1D:0A).
usage: bgb_print_wild.py PAGE OUTDIR [--rom ROM] [--sav SAV] [--vk Left|Right] [--tail N] [--port N]   -> OUTDIR/page_NN.png (what the printer received), printer_log.json, run.bmp"""
import sys, os, json, shutil
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE); ROOT = os.path.dirname(HERE)
a = sys.argv[1:]
def opt(n, d=None):
    if n in a: i = a.index(n); v = a[i + 1]; del a[i:i + 2]; return v
    return d
rom = opt('--rom', os.path.join(ROOT, 'pocketcamera_jp.gb')); sav = opt('--sav', os.path.join(ROOT, 'saves_unl', 'unl_CE10238211.sav')); vk = opt('--vk', 'Left')
tail = int(opt('--tail', '1500')); port = int(opt('--port', '8793')); page = int(a[0]); out = os.path.abspath(a[1]); os.makedirs(out, exist_ok=True)
mine = '/home/claude/bgbpr%d' % (port % 100)
if not os.path.isdir(mine): shutil.copytree('/home/claude/bgbx', mine)
os.environ['BGB_DIR'] = mine
import bgb_run
from bgb_printer import PrinterServer
def K(k, w=60): return (k, 4, 200 if k in ('A', 'B', 'Select', 'Start') else w)
seq = [K('A'), K(vk, 120), K('A'), K('A'), K('A'), K('A'), K('Up'), K('A'), K('Select'), K('Down'), K('Right'), K('A')] + [K('Right')] * page + [K('A'), K('A')]
srv = PrinterServer(port, out).start()
try:
    r = bgb_run.run(rom, sav, out + '/run', seq, combo=2, free=403, extra=['-setting', 'SystemMode=0', '-connect', '127.0.0.1:%d' % port], tail=tail, timeout=900)
finally:
    srv.stop()
print('page', page, 'BGB end %02X:%02X' % (r['mode'], r['state']) if r['mode'] is not None else 'no state', '| link', srv.counts, '| printer bytes', srv.pr.bytes, 'packets', len(srv.pr.log), 'pages', len(srv.pr.pages))
for pg in srv.pr.pages: print('  page', pg)
