#!/usr/bin/env python3
"""Explore the menus of a ROM in BGB itself (written for Hello Kitty; --mode-addr / --state-addr / --no-kitts for the others) (the judge for pictures), breadth first over single key taps.

  tools/kitty_bgb_explore.py ROM OUT_DIR [--kitts 999999] [--max-runs 1200] [--depth 7] [--workers 2] [--wait 90]

The core's random corpus does not replay in BGB (input timing differs, so long random paths end elsewhere). Here the paths
are made of key taps with long waits (8 frames held, then --wait frames free, after a 700-frame boot; BGB gets 3 more boot frames), which the game reads
the same way in both emulators. The search is breadth first in the core (fast, with snapshots): a node whose (mode hFF8D,
state hFF8E) or screen (BG maps and OAM) is new gets the 8 children (A, B, Select, Start, Right, Left, Up, Down). Then each (mode, state) found is run
once in BGB from a cold boot with a demo file of its path, and BGB writes the screen and the state at the end; the
(mode, state) BGB ends in is recorded beside the one the core found (they agree when the path is timing-safe), with the
(mode, state) the path came from (parent) and the last key (the edges of the screen tree, tools/screen_tree.py). Start save: an all-$00 SRAM formatted by the core (600 frames), Kitt counter $100A-$100C set to --kitts.
Writes OUT_DIR/kitty_mode_MM_SS.png (the first screen of each (mode, state)) and OUT_DIR/explore.csv (mode, state, key path,
frames, picture). Long jobs: run it in the background (setsid nohup); it writes explore.csv after every level.
"""
import sys, os, csv, argparse, subprocess, shutil, concurrent.futures as CF
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
sys.path.insert(0, os.path.join(REPO, 'coverage', 'src')); sys.path.insert(0, os.path.join(REPO, 'tcrf_check', 'tools'))
from bgb_run import read_state
from PIL import Image
ap = argparse.ArgumentParser()
ap.add_argument('rom'); ap.add_argument('out'); ap.add_argument('--kitts', type=int, default=999999)
ap.add_argument('--max-runs', type=int, default=1200); ap.add_argument('--depth', type=int, default=7)
ap.add_argument('--workers', type=int, default=2); ap.add_argument('--wait', type=int, default=90); ap.add_argument('--boot', type=int, default=700)
ap.add_argument('--prefix', default='', help='start the search after these taps (names, space separated)')
ap.add_argument('--no-oam', action='store_true', help='screen = the BG / window maps only (sprites animate: with them every frame is new)')
ap.add_argument('--by-state', action='store_true', help='a node is new only when its (mode, state) is new (no screen hash): goes deeper')
ap.add_argument('--tag', default='w', help='BGB worker folders /home/claude/bgbx_<tag><n>: give each concurrent exploration its own tag')
ap.add_argument('--mode-addr', default='FF8D', help='the mode byte (Hello Kitty hFF8D; Japanese / international / Gold wMode D5CE)')
ap.add_argument('--state-addr', default='FF8E', help='the state byte (Hello Kitty hFF8E; the retail ROMs D5CF)')
ap.add_argument('--no-kitts', action='store_true', help='do not write the Hello Kitty Kitt counter into the formatted save (other ROMs)')
ap.add_argument('--save', default=None, help='start from this SRAM image (e.g. the Hello Kitty unlocking save of tools/make_unlocked_saves.py --hello-kitty) instead of the core-formatted one')
a = ap.parse_args(); os.makedirs(a.out, exist_ok=True)
MA, SA = int(a.mode_addr, 16), int(a.state_addr, 16)
def st_byte(st, ad):
    if ad >= 0xFF80: h = st.get('HRAM', b''); return h[ad - 0xFF80] if len(h) > ad - 0xFF80 else None
    w = st.get('WRAM', b''); return w[ad - 0xC000] if len(w) > ad - 0xC000 else None
import gbcov as G
G.load_rom(a.rom); G.reset(bytes(0x20000)); G.run(600); sav = bytearray(bytes(G.sram()))
d = '%06d' % a.kitts
if not a.no_kitts: sav[0x100A:0x100D] = bytes([int(d[4:6], 16), int(d[2:4], 16), int(d[0:2], 16)])
if a.save: sav = bytearray(open(a.save, 'rb').read())     # the start save given
# the core's key mask has the direction keys in the low nibble and the buttons in the high one (coverage/src/gbcov.c), the BGB demo
# byte the reverse: SWAP converts
def SWAP(m): return ((m & 0x0F) << 4) | (m >> 4)
KEYS = [('A', 1), ('B', 2), ('Select', 4), ('Start', 8), ('Right', 0x10), ('Left', 0x20), ('Up', 0x40), ('Down', 0x80)]
def demo(path): return bytes(3 + a.boot) + b''.join(bytes([m]) * 8 + bytes(a.wait) for _, m in path)     # BGB: 3 more boot frames
import queue
FREE = queue.Queue()
for _w in range(a.workers): FREE.put(_w)
def run(_unused, path):
    w = FREE.get()
    try: return _run(w, path)
    finally: FREE.put(w)
def _run(w, path):
    bgb = '/home/claude/bgbx_%s%d' % (a.tag, w)
    if not os.path.exists(bgb): shutil.copytree('/home/claude/bgbx', bgb)
    tmp = os.path.join(a.out, 'tmp_w%d' % w); os.makedirs(tmp, exist_ok=True)
    open(os.path.join(tmp, 'k.dem'), 'wb').write(demo(path)); open(os.path.join(tmp, 'k.sav'), 'wb').write(sav)
    for f in ('k.sna', 'k.bmp'):
        if os.path.exists(os.path.join(tmp, f)): os.remove(os.path.join(tmp, f))
    cmd = ['xvfb-run', '-a', 'wine', os.path.join(bgb, 'bgb.exe'), '-hf', '-nowarn', '-nowriteini', '-nobattsave', '-ini', os.path.join(bgb, 'bgb.ini'),
           '-rom', os.path.abspath(a.rom), '-demoplay', os.path.join(tmp, 'k.dem'), '-stateonexit', os.path.join(tmp, 'k.sna'),
           '-screenonexit', os.path.join(tmp, 'k.bmp'), '-loadbatt', os.path.join(tmp, 'k.sav')]
    try: subprocess.run(cmd, env=dict(os.environ, WINEDEBUG='-all', WINEPREFIX='/root/wineprefix'), capture_output=True, timeout=300)
    except subprocess.TimeoutExpired: return path, None, None
    st = read_state(os.path.join(tmp, 'k.sna')) if os.path.exists(os.path.join(tmp, 'k.sna')) else {}
    m_, s_ = st_byte(st, MA), st_byte(st, SA)
    ms = ('%02X' % m_, '%02X' % s_) if m_ is not None and s_ is not None else None
    img = Image.open(os.path.join(tmp, 'k.bmp')).copy() if os.path.exists(os.path.join(tmp, 'k.bmp')) else None
    return path, ms, img
# 1. breadth first search in the core
G.reset(bytes(sav)); G.run(a.boot)
pre = [k for n in a.prefix.split() for k in KEYS if k[0] == n]
for k in pre: G.keys(SWAP(k[1])); G.run(8); G.keys(0); G.run(a.wait)
found = {}; parent = {}; screens = set(); level = [(pre, G.snapshot(), None)]; nodes = 0
for depth in range(a.depth + 1):
    nxt = []
    for p, snap, par in level:
        G.restore(snap); ms = ('%02X' % G.peek(MA), '%02X' % G.peek(SA))
        # a node is new when its (mode, state) or its screen (BG / window maps and OAM) is new: menus keep one state per cursor
        scr = 0 if a.by_state else hash(bytes(G.peek(x) for x in range(0x9800, 0xA000)) + (b'' if a.no_oam else bytes(G.peek(x) for x in range(0xFE00, 0xFEA0))))
        if (ms, scr) in screens: continue
        screens.add((ms, scr))
        if ms not in found: found[ms] = p; parent[ms] = par
        for k in KEYS:
            G.restore(snap); G.keys(SWAP(k[1])); G.run(8); G.keys(0); G.run(a.wait); nxt.append((p + [k], G.snapshot(), ms)); nodes += 1
    print('core depth %d: nodes %d, screens %d, (mode, state) %d, modes %d' % (depth, nodes, len(screens), len(found), len({m for m, _ in found})), flush=True)
    level = nxt
    if nodes > a.max_runs * 40: break
# 2. one BGB run per screen
rows = []
with CF.ThreadPoolExecutor(a.workers) as ex:
    futs = {ex.submit(run, i % a.workers, p): ms for i, (ms, p) in enumerate(sorted(found.items()))}
    for f in CF.as_completed(futs):
        ms = futs[f]; p, bms, img = f.result(); pic = ''
        if img is not None and bms is not None:
            pic = 'kitty_mode_%s_%s.png' % bms
            if not os.path.exists(os.path.join(a.out, pic)) or bms == ms: img.save(os.path.join(a.out, pic))
        pm = parent.get(ms)
        rows.append([ms[0], ms[1], ' '.join(k for k, _ in p) or '-', len(demo(p)), bms[0] if bms else '?', bms[1] if bms else '?', 'yes' if bms == ms else 'no', pic,
                     '%s:%s' % pm if pm else '', p[-1][0] if p else ''])
rows.sort()
with open(os.path.join(a.out, 'explore.csv'), 'w', newline='') as f:
    w = csv.writer(f); w.writerow(['mode', 'state', 'keys', 'frames', 'bgb_mode', 'bgb_state', 'same', 'picture', 'parent', 'key']); w.writerows(rows)
print('BGB: %d runs, %d agree with the core' % (len(rows), sum(r[6] == 'yes' for r in rows)))
for x in os.listdir(a.out):
    if x.startswith('tmp_w'): shutil.rmtree(os.path.join(a.out, x), ignore_errors=True)
