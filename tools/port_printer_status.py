#!/usr/bin/env python3
"""Every printer status the Camera can receive, injected in the project's core, for the international and Gold ROMs (counterpart of the Japanese
tcrf_check/tools/printer_status.py, docs §16.16).  The printer stand-in of the core answers like the real-trace model (gb_printer_model(1)); a variant
restores the snapshot taken just before the print key, replaces the status byte of chosen packets (gb_printer_inject: command, n-th packet, status, packets in a row)
and runs FRAMES frames.
Scenarios (joypad routes found in the core on the international ROM, the same on Gold):
  card  title A, Right (VIEW), A, A, A, A, Up, A -> the PRINT screen 1C:03; Start (comment card on); the print key = A.  Photo + comment card.
  dj    Space Fever II, the D.J. ship shot (tools/port_core_scen.py), A A A -> 1F:05, Select -> SOUND I 1F:09, Start held; the print key = Start+A.  The score print.
Variant sets:
  all    every status $01-$FF at the first INIT, PRINT, DATA and INQUIRY packet (1,020 variants)
  grid   the 8 single bits and 7 combinations at every packet number of the baseline, then 6 statuses for 2-25 packets in a row (the JP grid)
  absent the status $FF, then $00, on every command from the first packet on, for 1-200 packets (a printer that is absent is BGB's 'noprinter' scenario,
         tools/port_bgb_witness.py)
usage: GBCAM_ROM=ROM port_printer_status.py OUTDIR card|dj [all,grid,absent] [--frames N] [--never roms/<f>/port/never_run_<s>.csv]
Output: OUTDIR/status_runs.csv (variant, injection, end mode:state, mode:state path, packets, replies, never-run bytes hit, $DC27 last status, $DBCF error number - 1),
        OUTDIR/exec.npz ('ex' = union of the bytes executed by every variant, for port_never_run.py).   PYTHONPATH: coverage/src and tcrf_check/tools."""
import sys, os, csv, collections
import numpy as np, ctypes as C
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, os.path.join(ROOT, 'tcrf_check', 'tools')); sys.path.insert(0, os.path.join(ROOT, 'coverage', 'src'))
import lib; from lib import g
a = sys.argv[1:]
def opt(n, d=None):
    if n in a: i = a.index(n); v = a[i + 1]; del a[i:i + 2]; return v
    return d
FR = int(opt('--frames', '4100')); never = opt('--never'); sav = opt('--sav', '/root/work/port/saves_unl/unl_CE10001819.sav')
out, scen = a[0], a[1]; sets = (a[2] if len(a) > 2 else 'all,grid,absent').split(','); os.makedirs(out, exist_ok=True)
CMD = dict(init=1, print=2, data=4, inq=15); CN = {v: k for k, v in CMD.items()}
def flat(b, ad): return ad if (b == 0 and ad < 0x4000) else b * 0x4000 + ad - 0x4000
NV = np.zeros(1 << 20, bool)
if never:
    for r in csv.DictReader(open(never)):
        b = int(r['bank'], 16); NV[flat(b, int(r['start'], 16)):flat(b, int(r['end'], 16)) + 1] = True
lib._SAVCACHE['s'] = open(sav, 'rb').read()
g.L.gb_printer_model(1)
lib.boot(lib.SAV('s'), combo=0, printer=1, free=403)
if scen == 'card':
    lib.play('A w160 R w60 A w160 A w160 A w160 A w160 U w60 A w160 S w60', wait=40)
    def trigger(): g.keys(g.A); g.run(4); g.keys(0)
else:
    lib.play('A w60 D A w60 A', wait=40)
    for f in range(24): g.keys(g.RIGHT | (g.A if (f >= 6 and f % 4 < 2) else 0)); g.run(1)
    g.keys(0); g.run(120)
    for k in (g.A, g.A, g.A): g.keys(k); g.run(4); g.keys(0); g.run(60)
    g.run(200); g.keys(g.SELECT); g.run(4); g.keys(0); g.run(120); g.keys(g.START); g.run(8)
    def trigger(): g.keys(g.START | g.A); g.run(4); g.keys(g.START); g.run(4); g.keys(0)
snap = g.snapshot(); print('before the print key (%s): %02X:%02X' % (scen, *lib.cur()), flush=True)
ex = g.cov_exec(); union = np.zeros(len(ex), bool)
def variant(name, inj):
    g.restore(snap); ex[:] = 0; g.L.gb_printer_inject_clear()
    for c, n, s, k in inj: g.L.gb_printer_inject(c, n, s, k)
    path = [lib.cur()]; trigger()
    for f in range(FR):
        g.run(1); c = lib.cur()
        if c != path[-1]: path.append(c)
    cm = (C.c_uint8 * 8192)(); rx = (C.c_uint8 * 8192)(); n = min(g.L.gb_printer_log(cm, rx, 8192), 8192); log = list(zip(cm[:n], rx[:n]))
    e = np.array(ex, copy=True) != 0; union[:] |= e
    row = dict(variant=name, inject=';'.join('%s:%d:%02X:%d' % (CN[c], n_, s, k) for c, n_, s, k in inj) or '-', end='%02X:%02X' % lib.cur(),
               path=' '.join('%02X:%02X' % x for x in path), packets=len(log), replies=' '.join('%s%02X' % ('ipdq'[[1, 2, 4, 15].index(c)] if c in (1, 2, 4, 15) else '?', r) for c, r in log[:300]),
               never_run_bytes_hit=int((NV & e).sum()), dc27='%02X' % g.peek(0xDC27), dbcf=g.peek(0xDBCF))
    print('%-16s end %s packets %4d never-run hit %4d | %s' % (name, row['end'], row['packets'], row['never_run_bytes_hit'], row['inject']), flush=True)
    row['_log'] = log; return row
rows = [variant('baseline', [])]
cnt = collections.Counter(c for c, r in rows[0]['_log'])
BITS = [0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80]; COMBO = [0x03, 0x11, 0x12, 0x13, 0x0A, 0xFF, 0xF0]
if 'all' in sets:
    for cmd in ('init', 'print', 'data', 'inq'):
        for st in range(1, 256): rows.append(variant('%s1_%02X' % (cmd, st), [(CMD[cmd], 1, st, 1)]))
if 'grid' in sets:
    for cmd in ('init', 'print', 'data', 'inq'):
        for nth in range(1, cnt[CMD[cmd]] + 1):
            for st in BITS + COMBO: rows.append(variant('%s%d_%02X' % (cmd, nth, st), [(CMD[cmd], nth, st, 1)]))
    for cmd, nth in (('data', 1), ('data', 5), ('data', 10), ('inq', 1), ('inq', 8)):
        for st in (0x01, 0x02, 0x10, 0x12, 0xFF, 0xF0):
            for k in (2, 3, 5, 8, 25): rows.append(variant('%s%d_%02X_x%d' % (cmd, nth, st, k), [(CMD[cmd], nth, st, k)]))
if 'absent' in sets:
    for st in (0xFF, 0x00):
        for k in (1, 5, 50, 200): rows.append(variant('all_%02X_x%d' % (st, k), [(c, 1, st, k) for c in (1, 2, 4, 15)]))
with open(os.path.join(out, 'status_runs.csv'), 'w', newline='') as fh:
    w = csv.DictWriter(fh, fieldnames=[k for k in rows[0] if k != '_log'], extrasaction='ignore', lineterminator='\n'); w.writeheader(); w.writerows(rows)
np.savez_compressed(os.path.join(out, 'exec.npz'), ex=union.astype(np.uint8))
print('%d variants; never-run bytes hit by the union: %d' % (len(rows), int((NV & union).sum())))
