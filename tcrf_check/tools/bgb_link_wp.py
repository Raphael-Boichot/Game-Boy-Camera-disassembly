#!/usr/bin/env python3
"""bgb_link.py (two real BGB instances, photo exchange of README section 14) with *logging watchpoints* on the receiver: the hits of every -wp item are counted in
the debug-message file of that instance (BGB writes one line per hit and goes on).  The sender and the receiver get private BGB folders (debugmsg.txt is per folder).
usage: bgb_link_wp.py ROM SAV_SENDER SAV_RECEIVER OUTPREFIX WATCHPOINTS [WAIT_FRAMES_AFTER_CONFIRM]
  WATCHPOINTS  BGB -wp list of the receiver, e.g. '02:46E3//x/JP,02:46E6-02:46E8//r/T46E6' (ADDRESS[-ADDRESS]//drwx/NAME; see bgb_wp_probe.py)
Example (L3 pass of 2026-10-14, saves link_protocol/saves/flow1_A_sender_before.sav and flow1_B_receiver_before.sav): the receiver executes the jp at 02:46E3 of
Photo_SaveReceived_Far and never reads 02:46E6-46E8 (3 bytes 00 C0 00)."""
import sys, os, subprocess, time, shutil, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import bgb_run
rom, sa, sb, prefix = [os.path.abspath(x) for x in sys.argv[1:5]]
WPS = sys.argv[5]
WAIT = int(sys.argv[6]) if len(sys.argv) > 6 else 1500
os.makedirs(os.path.dirname(prefix), exist_ok=True)
SRC = os.environ.get('BGB_DIR', '/home/claude/bgbx')
DIRS = {}
for role in ('sender', 'receiver'):
    d = '/home/claude/bgbl_%s' % role
    if not os.path.isdir(d): shutil.copytree(SRC, d)
    if os.path.exists(os.path.join(d, 'debugmsg.txt')): os.remove(os.path.join(d, 'debugmsg.txt'))
    DIRS[role] = d
COMMON = [('B', 12, 60), ('Select', 8, 100), ('Up', 8, 60), ('A', 8, 150), ('Down', 8, 60), ('A', 8, 200)]
SEND = COMMON + [('Left', 8, 40), ('A', 8, 400), ('A', 8, 200), ('A', 8, WAIT)]
n = sum(h + w for _, h, w in SEND)
RECV = COMMON + [('-', n - sum(h + w for _, h, w in COMMON), 0)]
def start(role, sav, seq, extra):
    p = '%s_%s' % (prefix, role)
    open(p + '.dem', 'wb').write(bgb_run.make_demo(seq, 0, 403, tail=60)); shutil.copy(sav, p + '.sav')
    for f in (p + '.sna', p + '.bmp'):
        if os.path.exists(f): os.remove(f)
    d = DIRS[role]
    cmd = ['xvfb-run', '-a', 'wine', os.path.join(d, 'bgb.exe'), '-hf', '-nowarn', '-nowriteini', '-nobattsave', '-ini', os.path.join(d, 'bgb.ini'),
           '-rom', rom, '-demoplay', p + '.dem', '-stateonexit', p + '.sna', '-screenonexit', p + '.bmp', '-loadbatt', p + '.sav', '-setting', 'DebugMsgFile=1'] + extra
    return subprocess.Popen(cmd, env=dict(os.environ, WINEDEBUG='-all', WINEPREFIX='/root/wineprefix'), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
t0 = time.time()
pa = start('sender', sa, SEND, ['-listen', '127.0.0.1:8765']); time.sleep(4)
pb = start('receiver', sb, RECV, ['-connect', '127.0.0.1:8765', '-wp', WPS])
for p in (pa, pb):
    try: p.wait(timeout=600)
    except subprocess.TimeoutExpired: p.kill(); print('killed (timeout)')
print('both exited after %.0f s, rc %s %s' % (time.time() - t0, pa.returncode, pb.returncode))
for role in ('sender', 'receiver'):
    p = '%s_%s' % (prefix, role)
    if os.path.exists(p + '.sna'):
        w = bgb_run.read_state(p + '.sna')['WRAM']
        print('%-8s mode:state %02X:%02X' % (role, w[0x15CE], w[0x15CF]))
log = os.path.join(DIRS['receiver'], 'debugmsg.txt')
cnt = collections.Counter(l.strip() for l in open(log, errors='replace') if l.strip()) if os.path.exists(log) else {}
print('receiver watchpoint hits', dict(cnt))
