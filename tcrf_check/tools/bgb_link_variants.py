#!/usr/bin/env python3
"""BGB-to-BGB photo exchange (as bgb_link.py, README 14 / 16.6) with the owner gender byte and the received-from counters set by hand, and a marker (a breakpoint that only
logs) on the never-run pieces that depend on them (README 16.19):
  02:466D  F12 +1 when the RECEIVER's own owner byte DA56 has bit 0 (male)         07:4A2D-4A33  peer byte $CFFF bit 0 (male sender): BCD counter +1 (cap 99)
  02:4678  the same for bit 1 (female), already run                                07:4A3A-4A40  peer byte bit 1 (female sender): BCD counter +1
The saves are edited in SRAM only (owner byte at flat 2FC5 / 2FDE with its block checksum, counters 10BB-10CC cleared with the settings-block checksums): no RAM poke.
env RECV_ROM = a different ROM for the receiver unit (README 16.19: the partner with SB = $55 at link set-up, byte 0x2D65 of the ROM changed from $12 to $55, so that the initiator reads $55 after its hello $29 and runs 00:2B20)
usage: bgb_link_variants.py OUTDIR ROM SENDER.sav RECEIVER.sav NAME SENDER_GENDER RECEIVER_GENDER   (gender byte: 0 = ?, 1 = male, 2 = female; the receiver counters are cleared)
output: OUTDIR/NAME_{sender,receiver}.{sna,bmp,sav,dem}, NAME_markers.txt (marker hits per unit), and the SRAM counters before / after"""
import sys, os, subprocess, time, shutil, struct, collections
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import sram_analyze as S
BGB_SRC = os.environ.get('BGB_SRC', '/home/claude/bgbx')
out, rom, sa, sb, name, gs, gr = sys.argv[1:8]; gs, gr = int(gs), int(gr)
out, rom = os.path.abspath(out), os.path.abspath(rom); os.makedirs(out, exist_ok=True)
os.environ['BGB_DIR'] = BGB_SRC
import bgb_run
def edit(path, owner, clear):
    b = bytearray(open(path, 'rb').read())
    if owner is not None:
        b[0x2FC5] = owner; b[0x2FB8 + 0x17: 0x2FB8 + 0x19] = S.ck(b, 0x2FB8, 0x17); b[0x2FD1:0x2FD1 + 0x19] = b[0x2FB8:0x2FB8 + 0x19]
        assert S.blk_ok(b, 0x2FB8, 0x17) and S.blk_ok(b, 0x2FD1, 0x17)
    if clear:
        for a in range(0x10BB, 0x10CD): b[a] = 0
        blk = bytes(b[0x1000:0x1000 + 0xD7]); blk += S.ck(blk, 0, 0xD7); b[0x1000:0x10D9] = blk; b[0x10D9:0x11B2] = blk
    return bytes(b)
MK = [('02:462F', 'StoreReceived'), ('02:4660', 'CountersAddr'), ('02:466D', 'RecvMale_cap_test'), ('02:4671', 'RecvMale_inc'), ('02:4678', 'RecvFemale_cap_test'), ('02:467C', 'RecvFemale_inc'),
      ('07:4A24', 'PeerByteRead'), ('07:4A2D', 'PeerMale_cap_test'), ('07:4A31', 'PeerMale_add'), ('07:4A3A', 'PeerFemale_cap_test'), ('07:4A3E', 'PeerFemale_add'), ('07:4A42', 'PeerCountersDone'),
      ('00:2AFA', 'ReadSB'), ('00:2B20', 'Hello55'), ('00:2B25', 'Hello12'), ('02:47FE', 'TagCopyRestamp')]
BR = ','.join('%s///MK %s %%TOTALCLKS%% a=%%A%% b=%%B%% hl=%%HL%%' % (a, n) for a, n in MK)
COMMON = [('B', 12, 60), ('Select', 8, 100), ('Up', 8, 60), ('A', 8, 150), ('Down', 8, 60), ('A', 8, 200)]
WAIT = int(os.environ.get('LINK_WAIT', '1500'))
SEND = COMMON + [('Left', 8, 40), ('A', 8, 400), ('A', 8, 200), ('A', 8, WAIT)]
n = sum(h + w for _, h, w in SEND)
RECV = COMMON + [('-', n - sum(h + w for _, h, w in COMMON), 0)]
def start(role, sav, seq, extra, rom=rom):
    d = os.path.join(out, 'bgb_' + role)
    if not os.path.isdir(d): shutil.copytree(BGB_SRC, d)
    lf = os.path.join(d, 'debugmsg.txt')
    if os.path.exists(lf): os.remove(lf)
    p = os.path.join(out, '%s_%s' % (name, role))
    open(p + '.dem', 'wb').write(bgb_run.make_demo(seq, 0, 403, tail=60)); open(p + '.sav', 'wb').write(sav)
    for f in (p + '.sna', p + '.bmp'):
        if os.path.exists(f): os.remove(f)
    cmd = ['xvfb-run', '-a', 'wine', os.path.join(d, 'bgb.exe'), os.environ.get('BGB_HF', '-hf'), '-nowarn', '-nowriteini', '-nobattsave', '-ini', os.path.join(d, 'bgb.ini'),
           '-rom', rom, '-demoplay', p + '.dem', '-stateonexit', p + '.sna', '-screenonexit', p + '.bmp', '-loadbatt', p + '.sav', '-br', BR, '-setting', 'DebugMsgFile=1'] + extra
    return subprocess.Popen(cmd, env=dict(os.environ, WINEDEBUG='-all', WINEPREFIX='/root/wineprefix'), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
if not os.environ.get('POST_ONLY'):     # POST_ONLY=1: do not run, only read the debugmsg files of an earlier run and write the heads file again
    sav_s, sav_r = edit(sa, gs, False), edit(sb, gr, True)
    t0 = time.time(); port = os.environ.get('LINK_PORT', '8766')
    pa = start('sender', sav_s, SEND, ['-listen', '127.0.0.1:' + port]); time.sleep(4)
    pb = start('receiver', sav_r, RECV, ['-connect', '127.0.0.1:' + port], rom=os.path.abspath(os.environ.get('RECV_ROM', rom)))
    for p in (pa, pb):
        try: p.wait(timeout=900)
        except subprocess.TimeoutExpired: p.kill(); print('killed (timeout)')
    print('both exited after %.0f s, rc %s %s' % (time.time() - t0, pa.returncode, pb.returncode))
rows = []
for role in ('sender', 'receiver'):
    lf = os.path.join(out, '%s_%s_debugmsg.txt' % (name, role)) if os.environ.get('POST_ONLY') else os.path.join(out, 'bgb_' + role, 'debugmsg.txt')
    lines = [l for l in (open(lf, errors='replace').read().splitlines() if os.path.exists(lf) else []) if ' MK ' in ' ' + l or l.startswith('MK ')]
    cnt = collections.Counter(l.split('MK ', 1)[1].split()[0] for l in lines)
    if os.path.exists(lf) and not os.environ.get('POST_ONLY'): shutil.copy(lf, os.path.join(out, '%s_%s_debugmsg.txt' % (name, role)))
    rows.append('%-8s owner byte in = %d  hits: %s' % (role, gs if role == 'sender' else gr, ', '.join('%s x%d' % (k, v) for k, v in sorted(cnt.items(), key=lambda kv: [m[1] for m in MK].index(kv[0]) if kv[0] in [m[1] for m in MK] else 99)) or 'none'))
    p = os.path.join(out, '%s_%s' % (name, role))
    if os.path.exists(p + '.sna'):
        st = bgb_run.read_state(p + '.sna'); sr = st.get('SRAM') or st.get('CART RAM') or b''; w = st['WRAM']
        rows.append('         SRAM after: counters 10BF-10C4 = %s  owner byte 2FC5 = %02X  vector = %s  F12-F14 of slot 1/2 = %s  mode:state %02X:%02X' % (
            bytes(sr[0x10BF:0x10C5]).hex(), sr[0x2FC5], [x for x in sr[0x11B2:0x11B2 + 30] if x < 30][:4], bytes(sr[0x2F12:0x2F15]).hex() + '/' + bytes(sr[0x3F12:0x3F15]).hex(), w[0x15CE], w[0x15CF]))
open(os.path.join(out, name + '_markers.txt'), 'w').write('\n'.join(rows) + '\n'); print('\n'.join(rows))
import json
addr = dict((n, a) for a, n in MK); hits = set()
for role in ('sender', 'receiver'):
    f = os.path.join(out, '%s_%s_debugmsg.txt' % (name, role))
    if os.path.exists(f):
        for l in open(f, errors='replace'):
            if 'MK ' in l and l.split('MK ', 1)[1].split()[0] in addr: hits.add(addr[l.split('MK ', 1)[1].split()[0]])
json.dump({'hits': sorted(hits), 'note': 'marker addresses hit by either unit; an address that is not the head of a basic block of the static trace (02:4660, 07:4A24, 07:4A42) is only a probe and is skipped by witness_map.py (blocks.py)'}, open(os.path.join(out, name + '.heads_hit.json'), 'w'), indent=1)
