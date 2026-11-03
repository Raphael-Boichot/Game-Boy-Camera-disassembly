#!/usr/bin/env python3
"""Two real BGB instances (wine, headless) joined with -listen / -connect on localhost and driven by demo files (BGB runs both instances with the exact same
timing in this mode).  Runs the photo exchange of README section 14: both cameras go LINK > こうかん > あげる/もらう screen (mode $0E); the initiator (sender) picks
Left = send, presses A, picks photo 0 and confirms; the other unit just waits.  Dumps both SRAMs/WRAMs at the end.
usage: bgb_link.py ROM SAV_SENDER SAV_RECEIVER OUTPREFIX [WAIT_FRAMES_AFTER_CONFIRM]"""
import sys, os, subprocess, time, shutil, struct
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import bgb_run
rom, sa, sb, prefix = [os.path.abspath(x) for x in sys.argv[1:5]]
WAIT = int(sys.argv[5]) if len(sys.argv) > 5 else 1500
os.makedirs(os.path.dirname(prefix), exist_ok=True)
COMMON = [('B', 12, 60), ('Select', 8, 100), ('Up', 8, 60), ('A', 8, 150), ('Down', 8, 60), ('A', 8, 200)]
SEND = COMMON + [('Left', 8, 40), ('A', 8, 400), ('A', 8, 200), ('A', 8, WAIT)]        # Left = send, A = hello, A = pick photo 0, A = confirm
n = sum(h + w for _, h, w in SEND)
RECV = COMMON + [('-', n - sum(h + w for _, h, w in COMMON), 0)]                    # same length, no input
def start(role, sav, seq, extra):
    p = '%s_%s' % (prefix, role)
    open(p + '.dem', 'wb').write(bgb_run.make_demo(seq, 0, 403, tail=60)); shutil.copy(sav, p + '.sav')
    for f in (p + '.sna', p + '.bmp'):
        if os.path.exists(f): os.remove(f)
    cmd = ['xvfb-run', '-a', 'wine', os.path.join(bgb_run.BGB, 'bgb.exe'), '-hf', '-nowarn', '-nowriteini', '-nobattsave', '-ini', os.path.join(bgb_run.BGB, 'bgb.ini'),
           '-rom', rom, '-demoplay', p + '.dem', '-stateonexit', p + '.sna', '-screenonexit', p + '.bmp', '-loadbatt', p + '.sav'] + extra
    return subprocess.Popen(cmd, env=dict(os.environ, WINEDEBUG='-all', WINEPREFIX='/root/wineprefix'), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
t0 = time.time()
pa = start('sender', sa, SEND, ['-listen', '127.0.0.1:8765']); time.sleep(4)
pb = start('receiver', sb, RECV, ['-connect', '127.0.0.1:8765'])
for p in (pa, pb):
    try: p.wait(timeout=600)
    except subprocess.TimeoutExpired: p.kill(); print('killed (timeout)')
print('both exited after %.0f s, rc %s %s' % (time.time() - t0, pa.returncode, pb.returncode))
res = {}
for role in ('sender', 'receiver'):
    p = '%s_%s' % (prefix, role)
    if os.path.exists(p + '.sna'):
        st = bgb_run.read_state(p + '.sna'); res[role] = st
        w = st['WRAM']; sr = st.get('SRAM') or st.get('CART RAM') or b''
        n_ph = sum(1 for x in sr[0x11B2:0x11B2 + 30] if x < 30)
        print('%-8s mode:state %02X:%02X  photos in album vector %d  $DC44=%02X $DC4E=%02X  D561 (photo count)=%d' % (role, w[0x15CE], w[0x15CF], n_ph, w[0xDC44 - 0xC000], w[0xDC4E - 0xC000], w[0xD561 - 0xC000]))
    else: print(role, 'no state file')
