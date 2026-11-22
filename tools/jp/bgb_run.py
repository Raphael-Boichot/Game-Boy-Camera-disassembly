#!/usr/bin/env python3
"""Run a key sequence in the real BGB (Windows exe under wine, headless) and report the game's (mode,state), a screenshot and a few WRAM bytes.
Library + CLI.  CLI: bgb_run.py ROM SAV OUTPREFIX 'Right:8:5,A:8:30,...' [--combo N] [--free F] [--br ADDR[,ADDR]]
Sequence items are KEYS:hold:wait, KEYS joined with '+' (Right Left Up Down A B Select Start), frames at 59.7 Hz.
Environment: BGB_DIR (the BGB folder), BGB_WP (a -wp list: every run() then logs the hits of those watchpoints to BGB_DIR/debugmsg.txt), BGB_HF = the headless flags (default -hf; in the sandbox of 2026-10-11 a run with -demoplay and the printer link (-connect) hung at the link handshake with -hf,
`BGB_HF=-headless` works: it is not run-fast, but a linked BGB runs at about 50-60 frames per second anyway).
BGB's demo player takes one demo byte per frame it shows: while the LCD is off it does not advance (measured 2026-11-21 on corpus path 1E:01:
the gap between two presses grew by exactly the LCD-off time, 5.6 and 9.3 frames), whereas the core (coverage/src/gbcov.c) counts a frame
every 70,224 cycles with the LCD off. A sequence timed on the core therefore lands later in BGB after every LCD-off stretch (the boot, screen
loads). core_demo() builds the demo by stepping the core and giving BGB one byte per V-Blank start of the core (coverage/src/gbcov.c gb_vblanks), so both see the same keys at the
same game moment; run(..., demo=bytes) plays it instead of make_demo(seq).
BGB takes the first demo byte at power-on, before the first V-Blank (2026-11-22): the V-Blank handler of V-Blank n (the camera reads the
joypad there, Joy_Read 00:0A10) sees byte n, whereas the core's list gives byte n-1 to that V-Blank. core_demo therefore starts with one
lead byte (the key held at power-on; BGB_DEMO_LEAD=0 restores the old demos): without it BGB saw every key one V-Blank early, the "one
frame of lag of BGB's main menu" of docs §16.6 row 1 (on corpus path 0B:01: no lead byte, BGB 07:02; one lead byte, BGB 0B:01 = the core;
the same key-at-V-Blank shift in the core alone gives BGB's 07:02).
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
def core_demo(seq, sav, combo=0, free=400, printer=0, boot_hold=250, tail=90, lead=int(os.environ.get('BGB_DEMO_LEAD', 1))):
    """The demo of seq as the core plays it (combo and seq keys in the core's mask = the corpus spec), one byte per V-Blank start
    (see the module note). Returns (demo bytes, core (mode, state) at the end, core frames without a V-Blank start, i.e. LCD off)."""
    import lib; from lib import g
    names = [(g.RIGHT, 'Right'), (g.LEFT, 'Left'), (g.UP, 'Up'), (g.DOWN, 'Down'), (g.A, 'A'), (g.B, 'B'), (g.SELECT, 'Select'), (g.START, 'Start')]
    def core(k): return sum(m for m, n in names if n in k.split('+'))
    g.set_organic(1); g.reset(sav); g.L.gb_attach_printer(printer)
    dem = bytearray([mask('+'.join(n for m, n in names if combo & m))] * lead); off = [0]   # lead: BGB's power-on byte (module note)
    def frames(ck, db, n):
        for _ in range(n):
            v0 = g.L.gb_vblanks(); g.keys(ck); g.run(1); v = g.L.gb_vblanks() - v0
            dem.extend(bytes([db]) * v); off[0] += v == 0                 # one byte per V-Blank start: none with the LCD off, two if it came back on within the frame
    frames(combo, mask('+'.join(n for m, n in names if combo & m)), boot_hold); frames(0, 0, free)
    for keys, hold, wait in seq: frames(core(keys), mask(keys), hold); frames(0, 0, wait)
    frames(0, 0, tail)
    return bytes(dem), lib.cur(), off[0]
def read_state(path):
    d = open(path, 'rb').read(); i = 0; out = {}
    while i < len(d):
        j = d.index(b'\0', i); name = d[i:j].decode('latin1'); sz = int.from_bytes(d[j + 1:j + 5], 'little')
        out[name] = d[j + 5:j + 5 + sz]; i = j + 5 + sz
    return out
def run(rom, sav, prefix, seq, combo=0, free=400, br=None, timeout=900, extra=(), tail=90, demo=None):
    os.makedirs(os.path.dirname(os.path.abspath(prefix)), exist_ok=True)
    dem, sna, bmp = prefix + '.dem', prefix + '.sna', prefix + '.bmp'
    open(dem, 'wb').write(demo if demo is not None else make_demo(seq, combo, free, tail=tail))
    sv = prefix + '.sav'
    if sav is not None: shutil.copy(sav, sv)
    for f in (sna, bmp):
        if os.path.exists(f): os.remove(f)
    cmd = ['xvfb-run', '-a', 'wine', os.path.join(BGB, 'bgb.exe'), os.environ.get('BGB_HF', '-hf'), '-nowarn', '-nowriteini', '-nobattsave', '-ini', os.path.join(BGB, 'bgb.ini'),
           '-rom', os.path.abspath(rom), '-demoplay', os.path.abspath(dem), '-stateonexit', os.path.abspath(sna), '-screenonexit', os.path.abspath(bmp)]
    if sav is not None: cmd += ['-loadbatt', os.path.abspath(sv)]
    if br: cmd += ['-br', br]
    wp = os.environ.get('BGB_WP')
    if wp:      # logging watchpoints for any runner (printer, link, replay): the hits go to $BGB_DIR/debugmsg.txt (docs §2.13, tools/jp/wram_probe_scen.py)
        cmd += ['-wp', wp, '-setting', 'DebugMsgFile=1']
        if os.path.exists(os.path.join(BGB, 'debugmsg.txt')): os.remove(os.path.join(BGB, 'debugmsg.txt'))
    cmd += list(extra)
    env = dict({k: v for k, v in os.environ.items() if k != 'TMPDIR'}, WINEDEBUG='-all', WINEPREFIX='/root/wineprefix')
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
