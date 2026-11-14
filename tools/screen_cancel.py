#!/usr/bin/env python3
"""Where the cancel key leads from each screen of a screen tree, measured in BGB (input of tools/screen_tree.py --cancel).

  tools/screen_cancel.py ROM SCREENS_DIR OUT.csv [--save S.sav] [--key B] [--mode-addr FF8D --state-addr FF8E] [--no-kitts]
                         [--boot 700] [--wait 90] [--workers 2] [--tag c]

For every row of SCREENS_DIR/explore.csv (mode, state, keys: the key path of tools/kitty_bgb_explore.py) BGB replays the path from a
cold boot (same demo timing as the explorer: each key held 8 frames then --wait free frames) and then the path plus --key. OUT.csv:
mode, state, key, base (the (mode, state) the path ends on in this run), to (where the path plus the key ends), ok (yes when base is
the screen of the row: only those rows are evidence). A row whose `to` is another screen of the tree is a cancel edge (evidence C).
"""
import sys, os, csv, argparse, subprocess, shutil, concurrent.futures, queue
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, os.path.join(os.path.dirname(HERE), 'tools', 'jp'))
from bgb_run import read_state
ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('screens'); ap.add_argument('out')
ap.add_argument('--save', default=None); ap.add_argument('--key', default='B'); ap.add_argument('--mode-addr', default='FF8D'); ap.add_argument('--state-addr', default='FF8E')
ap.add_argument('--no-kitts', action='store_true'); ap.add_argument('--kitts', type=int, default=999999)
ap.add_argument('--boot', type=int, default=700); ap.add_argument('--wait', type=int, default=90); ap.add_argument('--workers', type=int, default=2); ap.add_argument('--tag', default='c')
a = ap.parse_args()
KEYS = dict(A=1, B=2, Select=4, Start=8, Right=0x10, Left=0x20, Up=0x40, Down=0x80)      # BGB demo bits
MA, SA = int(a.mode_addr, 16), int(a.state_addr, 16)
if a.save: sav = bytearray(open(a.save, 'rb').read())
else:
    sys.path.insert(0, os.path.join(os.path.dirname(HERE), 'coverage', 'src')); import gbcov as G
    G.load_rom(a.rom); G.reset(bytes(0x20000)); G.run(600); sav = bytearray(bytes(G.sram()))
if not a.no_kitts:
    d = '%06d' % a.kitts; sav[0x100A:0x100D] = bytes([int(d[4:6], 16), int(d[2:4], 16), int(d[0:2], 16)])
def demo(keys): return bytes(3 + a.boot) + b''.join(bytes([KEYS[k]]) * 8 + bytes(a.wait) for k in keys)
FREE = queue.Queue()
for w in range(a.workers): FREE.put(w)
def byte(st, ad):
    if ad >= 0xFF80: h = st.get('HRAM', b''); return h[ad - 0xFF80] if len(h) > ad - 0xFF80 else None
    w = st.get('WRAM', b''); return w[ad - 0xC000] if len(w) > ad - 0xC000 else None
def run(keys):
    w = FREE.get()
    try:
        bgb = '/home/claude/bgbx_%s%d' % (a.tag, w)
        if not os.path.exists(bgb): shutil.copytree('/home/claude/bgbx', bgb)
        tmp = os.path.join(bgb, 'cancel'); os.makedirs(tmp, exist_ok=True)
        open(os.path.join(tmp, 'k.dem'), 'wb').write(demo(keys)); open(os.path.join(tmp, 'k.sav'), 'wb').write(sav)
        if os.path.exists(os.path.join(tmp, 'k.sna')): os.remove(os.path.join(tmp, 'k.sna'))
        subprocess.run(['xvfb-run', '-a', 'wine', os.path.join(bgb, 'bgb.exe'), '-hf', '-nowarn', '-nowriteini', '-nobattsave', '-ini', os.path.join(bgb, 'bgb.ini'),
                        '-rom', os.path.abspath(a.rom), '-demoplay', os.path.join(tmp, 'k.dem'), '-stateonexit', os.path.join(tmp, 'k.sna'),
                        '-loadbatt', os.path.join(tmp, 'k.sav')], env=dict(os.environ, WINEDEBUG='-all', WINEPREFIX='/root/wineprefix'), capture_output=True, timeout=300)
        st = read_state(os.path.join(tmp, 'k.sna')) if os.path.exists(os.path.join(tmp, 'k.sna')) else {}
        m, s = byte(st, MA), byte(st, SA)
        return '%02X:%02X' % (m, s) if m is not None and s is not None else '?'
    finally: FREE.put(w)
rows = [r for r in csv.DictReader(open(os.path.join(a.screens, 'explore.csv'))) if r['same'] == 'yes' and r['keys'] != '-']
def job(r):
    keys = r['keys'].split(); return r, run(keys), run(keys + [a.key])
out = []
with concurrent.futures.ThreadPoolExecutor(a.workers) as ex:
    for r, base, to in ex.map(job, rows):
        ok = 'yes' if base == '%s:%s' % (r['mode'], r['state']) else 'no'
        out.append([r['mode'], r['state'], a.key, base, to, ok]); print(r['mode'], r['state'], base, '->', to, ok, flush=True)
with open(a.out, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['mode', 'state', 'key', 'base', 'to', 'ok']); w.writerows(out)
print('screen_cancel: %d screens, %d replayed on their screen, %d where %s changes the screen' % (len(out), sum(1 for r in out if r[5] == 'yes'), sum(1 for r in out if r[5] == 'yes' and r[4] != r[3]), a.key))
