#!/usr/bin/env python3
"""Two linked BGB instances running the prototype's BGB copy: the COM link test (GAME_SEQ $0B, EMI_MAIN) as a scenario.

  tools/proto_bgb_link.py PROTO_BGB.gb OUTPREFIX SEQ_1 SEQ_2 [--frames N]

PROTO_BGB.gb is the header-patched copy (md5 1d8097de...; BGB only, owner's rule 2026-11-08). Instance 1 listens, instance 2 connects
(127.0.0.1:8766), both from 128 KiB of $00, both headless (`-headless`: linked runs stall with `-hf`, SETUP.md). SEQ_1 / SEQ_2 are key
lists in the format of tools/jp/bgb_run.py (`KEYS:hold:wait,...`, played after the 250-frame boot hold and 400 free frames);
each demo is padded with empty frames to --frames so that both instances run the same length. At the end, for each instance:
GAME_SEQ ($C0A0), the link role $C0D7 (0 none, 1 follower: the first byte received was $00, 2 master: the first byte received was
the idle $FE), the shown value $C0DD, and the screen OUTPREFIX_<n>.png.
Menu path to COM: title A, then Down x5 on the menu (SRAM TEST ... COM), A. BGB_WP (a -wp list) logs watchpoint hits to
/home/claude/bgbp_<n>/debugmsg.txt (tools/proto_red_bgb.py).
"""
import sys, os, subprocess, time, shutil, argparse
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, os.path.join(HERE, '..', 'tools', 'jp'))
import bgb_run as B
from PIL import Image
ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('out'); ap.add_argument('seq1'); ap.add_argument('seq2')
ap.add_argument('--frames', type=int, default=2400); a = ap.parse_args()
rom = os.path.abspath(a.rom); os.makedirs(os.path.dirname(os.path.abspath(a.out)), exist_ok=True)
SRC = os.environ.get('BGB_DIR', '/home/claude/bgbx')
procs = []
for n, seq, net in ((1, a.seq1, ['-listen', '127.0.0.1:8766']), (2, a.seq2, ['-connect', '127.0.0.1:8766'])):
    d = '/home/claude/bgbp_%d' % n
    if not os.path.isdir(d): shutil.copytree(SRC, d)
    p = os.path.abspath('%s_%d' % (a.out, n))
    dem = B.make_demo(B.parse_seq(seq) if seq != '-' else [], 0, 400, tail=0)
    open(p + '.dem', 'wb').write(dem + bytes(max(0, a.frames - len(dem))))
    open(p + '.sav', 'wb').write(bytes(0x20000))
    for f in (p + '.sna', p + '.bmp'):
        if os.path.exists(f): os.remove(f)
    cmd = ['xvfb-run', '-a', 'wine', os.path.join(d, 'bgb.exe'), '-headless', '-nowarn', '-nowriteini', '-nobattsave', '-ini', os.path.join(d, 'bgb.ini'),
           '-rom', rom, '-demoplay', p + '.dem', '-stateonexit', p + '.sna', '-screenonexit', p + '.bmp', '-loadbatt', p + '.sav'] + net
    if os.environ.get('BGB_WP'):                  # logging watchpoints (as tools/jp/bgb_run.py): hits go to <instance dir>/debugmsg.txt
        cmd += ['-wp', os.environ['BGB_WP'], '-setting', 'DebugMsgFile=1']
        if os.path.exists(os.path.join(d, 'debugmsg.txt')): os.remove(os.path.join(d, 'debugmsg.txt'))
    procs.append(subprocess.Popen(cmd, env=dict(os.environ, WINEDEBUG='-all', WINEPREFIX='/root/wineprefix'), stdout=subprocess.PIPE, stderr=subprocess.PIPE))
    if n == 1: time.sleep(4)
for p in procs:
    try: p.wait(timeout=600)
    except subprocess.TimeoutExpired: p.kill(); print('killed (timeout)')
for n in (1, 2):
    p = '%s_%d' % (a.out, n)
    if not os.path.exists(p + '.sna'): print('instance %d: no state' % n); continue
    w = B.read_state(p + '.sna')['WRAM']
    if os.path.exists(p + '.bmp'): Image.open(p + '.bmp').save(p + '.png')
    print('instance %d: GAME_SEQ %02X, role $C0D7 = %d, shown $C0DD = %02X' % (n, w[0xA0], w[0xD7], w[0xDD]))
