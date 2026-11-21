#!/usr/bin/env python3
"""Do the printing menus take camera captures? BGB with the Game Boy Printer helper attached (docs/12, 2026-11-15).

  tools/jp/print_capture_check.py JP.gb [--work DIR] [--out roms/jp_rev_a/experiments/print_captures/print_captures.csv]

docs/12 kept "the printing menus" open: the BGB capture logs of §18 had seen no extra capture there, but the printer was not attached,
so the print itself never ran. Here each of the three ways to print runs to the end with the helper (tools/jp/bgb_printer.py) on the
link, and BGB logs every write to the camera registers A000-A005 with the mode and state of the game at that moment (wMode $D5CE,
wState $D5CF), as tools/jp/sensor_bgb_log.py does: a write of an odd value to A000 with RAM bank >= $10 is a capture start.
The save: two photos shot in the core from a blank SRAM (tools/jp/f34_edit_check.py's path). Waits: 150 frames on every menu.
  album   the album's photo menu: title A, Left A A (album), A (photo 1), A (menu), Up (0A:07), A (1C:03), A (print)
  single  the main menu's print entry: title A, Select, Up (00:05), A (06:01), A (1B:01), A (1C:01), A (1C:03), A (print)
  multi   the same entry, OPTION: ... A (1B:01), Right A (1E:01), A (1E:02), A (mark photo 1), Right, A (mark photo 2), Down (1E:03), A (print)
CONTROL: the boot's own captures (the calibration check at power-on) show that the capture watchpoint works; the printer pages show that
the print ran. Writes one row per route and mode:state with the number of capture starts there.
"""
import argparse, collections, csv, os, shutil, sys
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(os.path.dirname(HERE)); sys.path.insert(0, HERE); sys.path.insert(0, os.path.dirname(HERE))
ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('--work', default='/tmp/print_capture_check')
ap.add_argument('--out', default=os.path.join(REPO, 'roms', 'jp_rev_a', 'experiments', 'print_captures', 'print_captures.csv')); ap.add_argument('--port', type=int, default=8793)
a = ap.parse_args(); os.makedirs(a.work, exist_ok=True); os.environ['GBCAM_ROM'] = a.rom

# ---- the save: two photos, shot in the core
import walk, lib; from lib import g
walk.boot(b'\xff' * 0x20000, 0); g.run(600); walk.tap('A')
for k in 'A A A A A A'.split(): walk.tap(k); g.run(120)
SAV = os.path.join(a.work, 'two_photos.sav'); open(SAV, 'wb').write(bytes(g.sram())[:0x20000])

import bgb_run, threading
from bgb_printer import PrinterServer
M = 150
def K(*ks): return [(k, 8, M) for k in ks]
ROUTES = {
    'album': K('A', 'Left', 'A', 'A', 'A', 'A', 'Up', 'A', 'A'),
    'single': K('A', 'Select', 'Up', 'A', 'A', 'A', 'A', 'A'),
    'multi': K('A', 'Select', 'Up', 'A', 'A', 'Right', 'A', 'A', 'A', 'Right', 'A', 'Down', 'A'),
}
WP = ','.join('A00%d//w/CAM%d %%XRAMBANK%% %%VALUE%% %%(D5CE)%% %%(D5CF)%%' % (r, r) for r in range(6))
# BGB on a link runs at the pace of its peer (about 3 frames a second here): the three routes run side by side, each with its own
# BGB folder (BGB writes debugmsg.txt next to its exe) and its own printer port.
RES = {}
def one(i, name, seq):
    out = os.path.join(a.work, name); shutil.rmtree(out, ignore_errors=True); os.makedirs(out)
    mine = os.path.join(a.work, 'bgb_' + name)
    if not os.path.isdir(mine): shutil.copytree(os.environ.get('BGB_SRC', '/home/claude/bgbx'), mine)
    lf = os.path.join(mine, 'debugmsg.txt')
    if os.path.exists(lf): os.remove(lf)
    srv = PrinterServer(a.port + i, out).start(); time.sleep(1)
    try:
        r = run_in(mine, os.path.join(out, 'run'), seq, ['-setting', 'DebugMsgFile=1', '-wp', WP, '-connect', '127.0.0.1:%d' % (a.port + i)])
    finally:
        srv.stop(); srv.write_log()
    RES[name] = (r, open(lf, errors='replace').read().splitlines() if os.path.exists(lf) else [], len(srv.pr.pages))
def run_in(mine, prefix, seq, extra):
    import subprocess
    dem, sna, bmp, sv = prefix + '.dem', prefix + '.sna', prefix + '.bmp', prefix + '.sav'
    open(dem, 'wb').write(bgb_run.make_demo(seq, 0, 400, tail=2400)); shutil.copy(SAV, sv)
    cmd = ['xvfb-run', '-a', 'wine', os.path.join(mine, 'bgb.exe'), os.environ.get('BGB_HF', '-headless'), '-nowarn', '-nowriteini', '-nobattsave', '-ini', os.path.join(mine, 'bgb.ini'),
           '-rom', os.path.abspath(a.rom), '-demoplay', dem, '-stateonexit', sna, '-screenonexit', bmp, '-loadbatt', sv] + extra
    subprocess.run(cmd, env=dict({k: v for k, v in os.environ.items() if k != 'TMPDIR'}, WINEDEBUG='-all', WINEPREFIX='/root/wineprefix'), capture_output=True, timeout=3600)
    st = bgb_run.read_state(sna) if os.path.exists(sna) else {}
    w = st.get('WRAM', b'')
    return dict(mode=w[0x15CE] if len(w) > 0x15CF else None, state=w[0x15CF] if len(w) > 0x15CF else None)
import time
TH = [threading.Thread(target=one, args=(i, n, s)) for i, (n, s) in enumerate(ROUTES.items())]
for t in TH: t.start()
for t in TH: t.join()
rows = []
for name in ROUTES:
    r, lines, pages = RES[name]
    caps = collections.Counter(); seen = []
    for l in lines:
        p = l.split()
        if len(p) < 5 or p[0] != 'CAM0' or int(p[1], 16) < 0x10: continue
        ms = '%02X:%02X' % (int(p[3], 16), int(p[4], 16))
        if ms not in seen: seen.append(ms)
        if int(p[2], 16) & 1: caps[ms] += 1
    end = '%02X:%02X' % (r['mode'], r['state']) if r['mode'] is not None else ''
    print('%-7s end %s, printer pages %d, capture starts by mode:state %s' % (name, end, pages, dict(caps)), flush=True)
    if not caps: sys.exit('print_capture_check: %s: no capture at all, not even at boot (the watchpoint or BGB failed): nothing written' % name)
    for ms in seen: rows.append([name, ms, caps[ms], pages, end])
os.makedirs(os.path.dirname(a.out), exist_ok=True)
with open(a.out, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['route', 'mode_state_at_A000_write', 'capture_starts', 'printer_pages', 'end_mode_state']); w.writerows(rows)
print('print_capture_check ->', os.path.relpath(a.out, REPO))
