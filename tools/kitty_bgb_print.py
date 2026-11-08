#!/usr/bin/env python3
"""Print from the Hello Kitty ROM in BGB with the project's Game Boy Printer helper on the link (tcrf_check/tools/bgb_printer.py).

  tools/kitty_bgb_print.py ROM OUT_DIR --save S [--path 'A A A Start'] [--frames 300,600,...] [--play 'Left:20,Right:20']

Each run boots BGB from the save, plays the key taps of --path (8 frames held, 90 free, after a 703-frame boot), then N free
frames (or the --play pattern of held keys, repeated, to play the game shown while printing), with the printer helper answering
on 127.0.0.1:8793; BGB writes the screen and state at the end, the helper the printed pages. Default path: take a photo
(title A, Take A, shutter A) and print it (START on the photo-taken screen). Writes OUT_DIR/print_NNNNN.png (screen after N
frames), modes.csv (frames, mode, state) and OUT_DIR/run_NNNNN/ (the helper's printer_log.json and page_NN.png).
"""
import sys, os, csv, argparse, subprocess, shutil, time
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); sys.path.insert(0, os.path.join(REPO, 'tcrf_check', 'tools'))
from bgb_run import read_state
from bgb_printer import PrinterServer
from PIL import Image
ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('out'); ap.add_argument('--save', required=True)
ap.add_argument('--path', default='A A A Start'); ap.add_argument('--frames', default='300,600,900,1200,1800,2400,3000,3600')
ap.add_argument('--play', default=None); ap.add_argument('--port', type=int, default=8793)
a = ap.parse_args(); os.makedirs(a.out, exist_ok=True)
BIT = dict(A=1, B=2, Select=4, Start=8, Right=0x10, Left=0x20, Up=0x40, Down=0x80)
bgb = '/home/claude/bgbx_print'
if not os.path.exists(bgb): shutil.copytree('/home/claude/bgbx', bgb)
pre = bytes(703) + b''.join(bytes([BIT[k]]) * 8 + bytes(90) for k in a.path.split())
play = b''
if a.play:
    for item in a.play.split(','):
        k, n = item.split(':'); play += bytes([BIT[k]]) * int(n)
rows = []
for n in [int(x) for x in a.frames.split(',')]:
    tail = (play * (n // max(len(play), 1) + 1))[:n] if play else bytes(n)
    d = os.path.join(a.out, 'run_%05d' % n); os.makedirs(d, exist_ok=True)
    open(d + '/s.dem', 'wb').write(pre + tail + bytes(1)); shutil.copy(a.save, d + '/s.sav')
    srv = PrinterServer(a.port, d).start(); time.sleep(1)
    subprocess.run(['xvfb-run', '-a', 'wine', bgb + '/bgb.exe', '-hf', '-nowarn', '-nowriteini', '-nobattsave', '-ini', bgb + '/bgb.ini', '-rom', os.path.abspath(a.rom),
                    '-demoplay', d + '/s.dem', '-screenonexit', d + '/s.bmp', '-stateonexit', d + '/s.sna', '-loadbatt', d + '/s.sav',
                    '-connect', '127.0.0.1:%d' % a.port], env=dict(os.environ, WINEDEBUG='-all', WINEPREFIX='/root/wineprefix'), capture_output=True, timeout=900)
    srv.stop()
    try: srv.write_log()
    except Exception: pass
    h = read_state(d + '/s.sna').get('HRAM', b'') if os.path.exists(d + '/s.sna') else b''
    if os.path.exists(d + '/s.bmp'): Image.open(d + '/s.bmp').convert('RGB').save(os.path.join(a.out, 'print_%05d.png' % n))
    pages = len([f for f in os.listdir(d) if f.startswith('page_')])
    rows.append([n, '%02X' % h[0x0D] if len(h) > 0x0E else '?', '%02X' % h[0x0E] if len(h) > 0x0E else '?', pages]); print(*rows[-1], flush=True)
with open(os.path.join(a.out, 'modes.csv'), 'w', newline='') as f:
    w = csv.writer(f); w.writerow(['frames', 'mode', 'state', 'pages']); w.writerows(rows)
