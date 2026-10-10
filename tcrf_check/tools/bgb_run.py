#!/usr/bin/env python3
"""Run a key sequence in the real BGB (Windows exe under wine, headless) and report the game's (mode,state), a screenshot and a few WRAM bytes.
Library + CLI.  CLI: bgb_run.py ROM SAV OUTPREFIX 'Right:8:5,A:8:30,...' [--combo N] [--free F] [--br ADDR[,ADDR]]
Sequence items are KEYS:hold:wait, KEYS joined with '+' (Right Left Up Down A B Select Start), frames at 59.7 Hz.
Joypad bits of the BGB demo byte: low nibble A=1 B=2 Select=4 Start=8, high nibble Right=$10 Left=$20 Up=$40 Down=$80 (checked on the camera)."""
import sys, os, subprocess, struct, shutil
BGB = os.environ.get('BGB_DIR', '/home/claude/bgbx')
BIT = dict(A=0x01, B=0x02, Select=0x04, Start=0x08, Right=0x10, Left=0x20, Up=0x40, Down=0x80)
def mask(keys):
    m = 0
    for k in keys.split('+'):
        if k and k != '-': m |= BIT[k]
    return m
def make_demo(seq, combo=0, free=400, boot_hold=250, tail=90):
    b = bytearray([combo & 0xFF]) * boot_hold + bytearray(free)
    for item in seq:
        keys, hold, wait = item
        b += bytes([mask(keys)]) * hold + bytes(wait)
    b += bytes(tail)
    return bytes(b)
def read_state(path):
    d = open(path, 'rb').read(); i = 0; out = {}
    while i < len(d):
        j = d.index(b'\0', i); name = d[i:j].decode('latin1'); sz = int.from_bytes(d[j + 1:j + 5], 'little')
        out[name] = d[j + 5:j + 5 + sz]; i = j + 5 + sz
    return out
def run(rom, sav, prefix, seq, combo=0, free=400, br=None, timeout=900, extra=(), tail=90):
    os.makedirs(os.path.dirname(os.path.abspath(prefix)), exist_ok=True)
    dem, sna, bmp = prefix + '.dem', prefix + '.sna', prefix + '.bmp'
    open(dem, 'wb').write(make_demo(seq, combo, free, tail=tail))
    sv = prefix + '.sav'
    if sav is not None: shutil.copy(sav, sv)
    for f in (sna, bmp):
        if os.path.exists(f): os.remove(f)
    cmd = ['xvfb-run', '-a', 'wine', os.path.join(BGB, 'bgb.exe'), '-hf', '-nowarn', '-nowriteini', '-nobattsave', '-ini', os.path.join(BGB, 'bgb.ini'),
           '-rom', os.path.abspath(rom), '-demoplay', os.path.abspath(dem), '-stateonexit', os.path.abspath(sna), '-screenonexit', os.path.abspath(bmp)]
    if sav is not None: cmd += ['-loadbatt', os.path.abspath(sv)]
    if br: cmd += ['-br', br]
    cmd += list(extra)
    env = dict(os.environ, WINEDEBUG='-all', WINEPREFIX='/root/wineprefix')
    r = subprocess.run(cmd, env=env, capture_output=True, timeout=timeout)
    st = read_state(sna) if os.path.exists(sna) else {}
    w = st.get('WRAM', b'')
    res = dict(rc=r.returncode, mode=w[0x15CE] if w else None, state=w[0x15CF] if w else None, pc=struct.unpack('<H', st['PC'])[0] if 'PC' in st else None, state_file=sna, shot=bmp, st=st)
    return res
def parse_seq(s):
    out = []
    for it in s.split(','):
        k, h, w = it.split(':'); out.append((k, int(h), int(w)))
    return out
if __name__ == '__main__':
    a = sys.argv; rom, sav, prefix, seq = a[1], (a[2] if a[2] != '-' else None), a[3], parse_seq(a[4])
    combo = int(a[a.index('--combo') + 1]) if '--combo' in a else 0
    free = int(a[a.index('--free') + 1]) if '--free' in a else 400
    br = a[a.index('--br') + 1] if '--br' in a else None
    r = run(rom, sav, prefix, seq, combo, free, br)
    print('rc', r['rc'], 'mode:state = %s:%s' % (r['mode'], r['state']), 'PC', r['pc'] and hex(r['pc']), r['shot'])
