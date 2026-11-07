#!/usr/bin/env python3
"""Photo exchange between two Hello Kitty units: two BGB instances linked through BGB's own cable (-listen / -connect).

  tools/kitty_bgb_link.py ROM OUT_DIR [--wp-file WP.txt] [--give 'A A A A ...'] [--take '...'] [--frames-after 2400]

Each instance boots from its own save (both: the core-formatted all-$00 SRAM with the Kitt counter at 999,999) and plays
a demo of key taps (8 frames held, 90 free, as tools/kitty_bgb_explore.py; names A B Select Start Right Left Up Down, '-' = one
idle tap slot). Default paths, found with tools/kitty_bgb_explore.py: the giver takes a photo and keeps it, then opens the
exchange screen (option menu Start, Up wraps to the third item, A: mode $07, "あげる <-> もらう") and picks the left item;
the receiver opens the same screen and picks the right item; then both press A a few times.
--wp-file: a BGB -wp list (one item per line, ADDR//x/NAME) given to both instances: every hit is logged to the
instance's debugmsg.txt (BGB's logging watchpoints, CLAUDE.md), so the code each side executes during the exchange can be
listed. Writes OUT_DIR/{giver,receiver}.png (screen at the end), .sna (state), .sav (the SRAM at the end, outside the
repository: it holds the BGB test picture only), hits_{giver,receiver}.csv (watchpoint name, count) and link.csv (mode / state at the end).
"""
import sys, os, csv, time, argparse, subprocess, shutil, collections
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
sys.path.insert(0, os.path.join(REPO, 'coverage', 'src')); sys.path.insert(0, os.path.join(REPO, 'tcrf_check', 'tools'))
from bgb_run import read_state
from PIL import Image
ap = argparse.ArgumentParser()
ap.add_argument('rom'); ap.add_argument('out'); ap.add_argument('--wp-file', default=None)
ap.add_argument('--give', default='A A A A B B B Start Up A Left A - A - A - A - A - A')
ap.add_argument('--take', default='A Start Up A Right A - A - A - A - A - A - A - A - A')
ap.add_argument('--frames-after', type=int, default=2400); ap.add_argument('--boot', type=int, default=700)
ap.add_argument('--save', default=None, help='start from this SRAM image (e.g. the Hello Kitty unlocking save of tools/make_unlocked_saves.py --hello-kitty) instead of the core-formatted one')
a = ap.parse_args(); os.makedirs(a.out, exist_ok=True)
import gbcov as G
G.load_rom(a.rom); G.reset(bytes(0x20000)); G.run(600); sav = bytearray(bytes(G.sram())); sav[0x100A:0x100D] = b'\x99\x99\x99'
if a.save: sav = bytearray(open(a.save, 'rb').read())     # the start save given
BIT = dict(A=1, B=2, Select=4, Start=8, Right=0x10, Left=0x20, Up=0x40, Down=0x80)
def demo(path):
    d = bytes(3 + a.boot) + b''.join((bytes([BIT[k]]) * 8 if k != '-' else bytes(8)) + bytes(90) for k in path.split())
    return d
dg, dr = demo(a.give), demo(a.take); n = max(len(dg), len(dr)) + a.frames_after
dg += bytes(n - len(dg)); dr += bytes(n - len(dr))
wp = ','.join(l.strip() for l in open(a.wp_file) if l.strip()) if a.wp_file else None
procs = {}
for role, d, link in (('giver', dg, ['-listen', '127.0.0.1:8766']), ('receiver', dr, ['-connect', '127.0.0.1:8766'])):
    bgb = '/home/claude/bgbl_kitty_%s' % role
    if not os.path.isdir(bgb): shutil.copytree('/home/claude/bgbx', bgb)
    if os.path.exists(os.path.join(bgb, 'debugmsg.txt')): os.remove(os.path.join(bgb, 'debugmsg.txt'))
    p = os.path.join(a.out, role)
    open(p + '.dem', 'wb').write(d); open(p + '.sav', 'wb').write(sav)
    for f in (p + '.sna', p + '.bmp'):
        if os.path.exists(f): os.remove(f)
    cmd = ['xvfb-run', '-a', 'wine', os.path.join(bgb, 'bgb.exe'), os.environ.get('BGB_HF', '-headless'), '-nowarn', '-nowriteini', '-ini', os.path.join(bgb, 'bgb.ini'),
           '-rom', os.path.abspath(a.rom), '-demoplay', p + '.dem', '-stateonexit', p + '.sna', '-screenonexit', p + '.bmp', '-loadbatt', p + '.sav'] + link
    if wp: cmd += ['-wp', wp, '-setting', 'DebugMsgFile=1']
    procs[role] = subprocess.Popen(cmd, env=dict(os.environ, WINEDEBUG='-all', WINEPREFIX='/root/wineprefix'), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if role == 'giver': time.sleep(4)
for r, p in procs.items():
    try: p.wait(timeout=1200)
    except subprocess.TimeoutExpired: p.kill(); print(r, 'killed (timeout)')
rows = []
for role in ('giver', 'receiver'):
    p = os.path.join(a.out, role); st = read_state(p + '.sna') if os.path.exists(p + '.sna') else {}
    h = st.get('HRAM', b'')
    if os.path.exists(p + '.bmp'): Image.open(p + '.bmp').save(p + '.png'); os.remove(p + '.bmp')
    rows.append([role, '%02X:%02X' % (h[0x0D], h[0x0E]) if len(h) > 0x0E else '?'])
    log = os.path.join('/home/claude/bgbl_kitty_%s' % role, 'debugmsg.txt')
    cnt = collections.Counter(l.strip() for l in open(log, errors='replace') if l.strip()) if os.path.exists(log) else {}
    with open(os.path.join(a.out, 'hits_%s.csv' % role), 'w', newline='') as f:
        w = csv.writer(f); w.writerow(['name', 'hits']); w.writerows(sorted(cnt.items()))
    print(role, rows[-1][1], 'watchpoint names hit:', len(cnt))
with open(os.path.join(a.out, 'link.csv'), 'w', newline='') as f:
    w = csv.writer(f); w.writerow(['role', 'mode_state_end']); w.writerows(rows)
