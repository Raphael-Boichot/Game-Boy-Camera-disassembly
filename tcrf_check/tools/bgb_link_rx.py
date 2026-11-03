#!/usr/bin/env python3
"""Two real BGB instances (Windows exe under wine, headless) joined by the link cable for a RECEIVER-initiated photo exchange (README 14.3: the initiator
chooses Right = receive, browses the peer's thumbnails, asks for one photo with A, the responder confirms with A in its dialog; flow 2 of link_protocol).
The two instances may run different ROMs (Japanese / international: the link screen is not mirrored, only the main menu is), each with its own -wp list.

usage: bgb_link_rx.py OUTPREFIX ROM_INIT SAV_INIT ROM_RESP SAV_RESP [--wp-init LIST] [--wp-resp LIST] [--confirm FRAME] [--frames N]
  OUTPREFIX   writes OUTPREFIX_{init,resp}.{dem,sav,sna,bmp,debugmsg.txt}
  --wp-init / --wp-resp   BGB -wp lists (see bgb_wp_probe.py); a control on the state byte is added to both: D5CF//w/STATE %(d5ce)% %(d5cf)% %a%
  --confirm   first frame (after the boot hold) of the responder's A presses in its confirmation dialog: A is pressed every 90 frames from there, 12 times
  --frames    length of both demos (default 5200 frames)
Prints, for each instance, the sequence of (mode:state) left at each write of $D5CF (hex, as BGB prints them; the value before the write) and the count of every other message.
BGB_HF = the headless flags (default -headless: the linked pair keeps real speed; with -hf the thumbnail pages missed the game's 180-frame deadline).
Folders: /home/claude/bgbrx_{init,resp} (copies of BGB_DIR, default /home/claude/bgbx; debugmsg.txt is per folder)."""
import sys, os, subprocess, time, shutil, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import bgb_run
a = sys.argv[1:]
def opt(n, d=None):
    if n in a: i = a.index(n); v = a[i + 1]; del a[i:i + 2]; return v
    return d
WPI, WPR = opt('--wp-init', ''), opt('--wp-resp', ''); CONF = int(opt('--confirm', '1700')); N = int(opt('--frames', '5200'))
prefix, rom_i, sav_i, rom_r, sav_r = [os.path.abspath(x) for x in a[:5]]
CTL = 'D5CF//w/STATE %(d5ce)% %(d5cf)% %a%'
SRC = os.environ.get('BGB_DIR', '/home/claude/bgbx')
COMMON = [('B', 12, 60), ('Select', 8, 100), ('Up', 8, 60), ('A', 8, 150), ('Down', 8, 60), ('A', 8, 200)]      # main menu -> LINK -> TRANSFER (bgb_link_wp.py)
INIT = COMMON + [('Right', 8, 40), ('A', 8, int(os.environ.get('RX_BROWSE', '1300'))), ('A', 8, 300)]   # Right = receive, A = start (handshake, first thumbnail page; RX_BROWSE frames in the browse screen), A = ask for the photo under the cursor
def pad(seq, n): return seq + [('-', max(n - sum(h + w for _, h, w in seq), 1), 0)]
t = sum(h + w for _, h, w in COMMON); RESP = COMMON + [('-', CONF - t, 0)] + [('A', 6, 84)] * 12
def start(role, rom, sav, seq, wp, link):
    d = '/home/claude/bgbrx_' + role
    if not os.path.isdir(d): shutil.copytree(SRC, d)
    if os.path.exists(d + '/debugmsg.txt'): os.remove(d + '/debugmsg.txt')
    p = '%s_%s' % (prefix, role)
    open(p + '.dem', 'wb').write(bgb_run.make_demo(pad(seq, N), 0, 403, tail=60)); shutil.copy(sav, p + '.sav')
    for f in (p + '.sna', p + '.bmp'):
        if os.path.exists(f): os.remove(f)
    cmd = ['xvfb-run', '-a', 'wine', d + '/bgb.exe', os.environ.get('BGB_HF', '-headless'), '-nowarn', '-nowriteini', '-nobattsave', '-ini', d + '/bgb.ini', '-rom', rom, '-demoplay', p + '.dem',
           '-stateonexit', p + '.sna', '-screenonexit', p + '.bmp', '-loadbatt', p + '.sav', '-setting', 'DebugMsgFile=1', '-setting', 'SystemMode=0',
           '-wp', ','.join(x for x in (wp, CTL) if x)] + link
    return subprocess.Popen(cmd, env=dict(os.environ, WINEDEBUG='-all', WINEPREFIX='/root/wineprefix'), stdout=subprocess.PIPE, stderr=subprocess.PIPE), d, p
os.makedirs(os.path.dirname(prefix), exist_ok=True); t0 = time.time()
pi, di, xi = start('init', rom_i, sav_i, INIT, WPI, ['-listen', '127.0.0.1:8766']); time.sleep(4)
pr, dr, xr = start('resp', rom_r, sav_r, RESP, WPR, ['-connect', '127.0.0.1:8766'])
for p in (pi, pr):
    try: p.wait(timeout=900)
    except subprocess.TimeoutExpired: p.kill(); print('killed (timeout)')
print('both exited after %.0f s' % (time.time() - t0))
for role, d, x in (('init', di, xi), ('resp', dr, xr)):
    L = [l.strip() for l in open(d + '/debugmsg.txt', errors='replace')] if os.path.exists(d + '/debugmsg.txt') else []
    if L: shutil.copy(d + '/debugmsg.txt', x + '.debugmsg.txt')
    seq = []
    for l in L:
        if l.startswith('STATE '):
            m, s = l.split()[1:3]; k = '%s:%s' % (m, s)       # the state being left (the value before the write: %a% is not the new value after inc [hl])
            if not seq or seq[-1] != k: seq.append(k)
    end = ''
    if os.path.exists(x + '.sna'):
        w = bgb_run.read_state(x + '.sna').get('WRAM', b'')
        if w: end = '%02X:%02X' % (w[0x15CE], w[0x15CF])
    print('%s end %s\n  states written: %s\n  hits: %s' % (role, end, ' '.join(seq), dict(collections.Counter(l for l in L if not l.startswith('STATE ')))))
