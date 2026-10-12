#!/usr/bin/env python3
"""Printer status injection in my core: what the Camera does when the printer answers with an error status (README 16.16).
usage: printer_status.py OUTDIR [--corpus FILE] [--entry N] [--scenario card|dj] [--frames N] [--sweep | --grid | --errors] [--only CMD:NTH:STATUS[:COUNT],...]      (run from the working root; needs GBCAM_CORE and GBCAM_REPO, see below)
The core needs the status-injection API (gb_printer_inject, gb_printer_log; coverage/src/gbcov.c): build it somewhere and set GBCAM_CORE=<dir with gbcov.py and libgbcov.so>; GBCAM_REPO=<this repository>.
Scenario card (default) = the comment-card print of README 17.4, the same keys as the BGB run: corpus entry 289 (unlocking save), five extra Right taps after the 13th action, Start (the print
options), A (print), then 4,100 frames; the printer stand-in is attached from the boot and answers like the BGB helper (real-trace model: PRINT 08, 18 INQUIRY polls 06, two 04, then 00).  Scenario dj = the TRIPY-H score print of 17.6 (route file unlock_runs/dj_route.json or --route).
Each variant restores the snapshot taken just before the last A, clears the executed-byte array
and replaces the reply of the chosen packet(s) by the given status byte:  CMD = init | print | data | inq, NTH = 1-based packet number of that command, STATUS = hex byte, COUNT = packets in a row.
--sweep: baseline, then every single bit (01 02 04 08 10 20 40 80) and a few combinations at the 1st, 2nd and a late DATA packet, the 1st PRINT, the 1st and a late INQUIRY and the INIT.
--errors: every status (15 values) at INIT 1, PRINT 1, DATA 1 and 10, INQUIRY 1, 12 and 23, with $DBCF in the csv (the error screen number - 1).
--grid: every command and every packet number of the baseline with every single bit and the combinations, then the same status for 2-25 packets in a row.
Output: OUTDIR/status_runs.csv (one row per variant: final mode:state, mode:state path, replies, class-N code hit), OUTDIR/exec_ranges.csv (bytes executed by any variant, which
witness_map.py intersects with the never-run code)."""
import sys, os, json, csv, itertools
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
CORE = os.environ.get('GBCAM_CORE')
if CORE: sys.path.insert(0, CORE)
import gbcov
import lib; from lib import g
import numpy as np, ctypes as C
REPO = os.environ.get('GBCAM_REPO') or os.path.dirname(os.path.dirname(HERE))     # the repository (rom_map.csv, assets/); set GBCAM_REPO when the tool runs from the working root
a = sys.argv[1:]
def opt(n, d=None):
    if n in a: i = a.index(n); v = a[i + 1]; del a[i:i + 2]; return v
    return d
corpus = opt('--corpus', 'unlock_runs/f1_organic/corpus.jsonl'); entry = int(opt('--entry', '289')); only = opt('--only'); scen = opt('--scenario', 'card'); FR = int(opt('--frames', '4100'))
sweep = '--sweep' in a; grid = '--grid' in a; errors = '--errors' in a; a = [x for x in a if x not in ('--sweep', '--grid', '--errors')]; out = a[0]; os.makedirs(out, exist_ok=True)
CMD = dict(init=1, print=2, data=4, inq=15); CN = {v: k for k, v in CMD.items()}
# ---- never-run code that is still unwitnessed (class N of the v8 map minus assets/witness_jp.csv) and the first address of each component
def flat(b, ad): return ad if (b == 0 and ad < 0x4000) else b * 0x4000 + ad - 0x4000
N = np.zeros(1 << 20, bool)
for r in csv.DictReader(open(os.path.join(REPO, 'coverage', 'results', 'report_v8', 'rom_map.csv'))):
    if r['class'] == 'N': o = flat(int(r['bank'], 16), int(r['start'], 16)); N[o:o + int(r['length'])] = True
for r in csv.DictReader(open(os.path.join(REPO, 'assets', 'witness_jp.csv'))):
    b = int(r['bank'], 16); N[flat(b, int(r['start'], 16)):flat(b, int(r['end'], 16)) + 1] = False
comps = [(r['first_addr'], int(r['bytes']), r['verdict']) for r in csv.DictReader(open(os.path.join(REPO, 'assets', 'reach_components_jp.csv')))]
def cflat(s): b, ad = s.split(':'); return flat(int(b, 16), int(ad, 16))
# ---- scenario
g.L.gb_printer_model(1)                                    # replies of the real printer traces (the stand-in's default replies 06 to PRINT and the Camera prints again and again)
if scen == 'card':
    Cp = lib.Corpus(corpus); p = Cp.path(entry); sp = dict(Cp.E[p[0]]['spec'])
    lib.boot(lib.SAV(sp['sav']), combo=sp['combo'], printer=1, free=sp['free'])
    seq = [tuple(x) for j in p[1:] for x in Cp.E[j]['actions']]
    seq = seq[:13] + [(g.RIGHT, 4, 40)] * 5 + seq[13:] + [(g.START, 4, 40)]
    for x in seq: lib.act(x)
    def trigger(): g.keys(g.A); g.run(4); g.keys(0)
else:                                                       # D.J. score print (README 17.6): the route of dj_route.json, Select to SOUND I, then Start (8 frames), Start+A (4), Start (4)
    route = json.load(open(opt('--route', 'unlock_runs/dj_route.json')))
    Cp = lib.Corpus(route['corpus']); p = Cp.path(route['entry']); sp = dict(Cp.E[p[0]]['spec'])
    lib.boot(lib.SAV(sp['sav']), combo=sp['combo'], printer=1, free=sp['free'])
    for j in p[1:]:
        for x in Cp.E[j]['actions']: lib.act(x)
    for k in route['shoot']: g.keys(k); g.run(1)
    g.keys(0); g.run(route['after_shoot_idle']); lib.act((g.SELECT, 4, 60)); g.keys(g.START); g.run(8)
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
    cm = (C.c_uint8 * 8192)(); rx = (C.c_uint8 * 8192)(); n = g.L.gb_printer_log(cm, rx, 8192)
    n = min(n, 8192); log = list(zip(cm[:n], rx[:n]))
    hit = N & (np.array(ex, copy=True) != 0); union[:] |= (np.array(ex, copy=True) != 0)
    ch = [(f, b) for f, b, v in comps if hit[cflat(f)]]
    row = dict(variant=name, inject=';'.join('%s:%d:%02X:%d' % (CN[c], n_, s, k) for c, n_, s, k in inj) or '-', end='%02X:%02X' % lib.cur(), path=' '.join('%02X:%02X' % x for x in path),
               packets=len(log), replies=' '.join('%s%02X' % ('ipdq'[[1, 2, 4, 15].index(c)], r) for c, r in log[:400]), classN_bytes=int(hit.sum()), comps_hit=' '.join(f for f, b in ch),
               dc27='%02X' % g.peek(0xDC27), dc0d=g.peek(0xDC0D), dc3b=g.peek(0xDC3B), dc3e=g.peek(0xDC3E), dbcf=g.peek(0xDBCF))
    print('%-14s end %s packets %3d classN %3d comps %s | %s' % (name, row['end'], row['packets'], row['classN_bytes'], row['comps_hit'] or '-', row['inject']), flush=True)
    row['_log'] = log
    return row
rows = []
if only:
    inj = [(CMD[f[0]], int(f[1]), int(f[2], 16), int(f[3]) if len(f) > 3 else 1) for f in (x.split(':') for x in only.split(','))]
    rows.append(variant('only', inj))
else:
    rows.append(variant('baseline', []))
    if grid:
        import collections
        cnt = collections.Counter(c for c, r in rows[0]['_log']); BITS = [0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80]; COMBO = [0x03, 0x11, 0x12, 0x13, 0x0A, 0xFF, 0xF0]
        for cmd in ('init', 'print', 'data', 'inq'):
            for nth in range(1, cnt[CMD[cmd]] + 1):
                for st in BITS + COMBO: rows.append(variant('%s%d_%02X' % (cmd, nth, st), [(CMD[cmd], nth, st, 1)]))
        for cmd, nth in (('data', 1), ('data', 5), ('data', 10), ('inq', 1), ('inq', 8)):          # the same status several packets in a row (retry counter, give-up paths)
            for st in (0x01, 0x02, 0x10, 0x12, 0xFF, 0xF0):
                for k in (2, 3, 5, 8, 25): rows.append(variant('%s%d_%02X_x%d' % (cmd, nth, st, k), [(CMD[cmd], nth, st, k)]))
    elif errors:                                            # error screens: every status at a few packets, with $DBCF (the error number - 1 that 00:340F stores) in the csv
        BITS = [0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80]; COMBO = [0x03, 0x11, 0x12, 0x13, 0x0A, 0xFF, 0xF0]
        for cmd, nth in (('init', 1), ('print', 1), ('data', 1), ('data', 10), ('inq', 1), ('inq', 12), ('inq', 23)):
            for st in BITS + COMBO: rows.append(variant('%s%d_%02X' % (cmd, nth, st), [(CMD[cmd], nth, st, 1)]))
    elif sweep:
        BITS = [0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80]; COMBO = [0x03, 0x11, 0x12, 0x13, 0x0A, 0xFF, 0xF0]
        spots = [('data', 1), ('data', 2), ('data', 9), ('print', 1), ('inq', 1), ('inq', 6), ('init', 1)]
        for cmd, nth in spots:
            for st in BITS + COMBO:
                rows.append(variant('%s%d_%02X' % (cmd, nth, st), [(CMD[cmd], nth, st, 1)]))
with open(os.path.join(out, 'status_runs.csv'), 'w', newline='') as fh:
    w = csv.DictWriter(fh, fieldnames=[k for k in rows[0].keys() if k != '_log'], extrasaction='ignore', lineterminator='\n'); w.writeheader(); w.writerows(rows)
ex[:] = union.astype(np.uint8); lib.dump_exec_ranges(os.path.join(out, 'exec_ranges.csv'), np.zeros(len(union), bool))
