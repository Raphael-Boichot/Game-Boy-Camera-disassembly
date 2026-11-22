#!/usr/bin/env python3
"""The open print options of docs §17.9, printed in BGB with the printer helper, from a synthetic save (Japanese ROM; 2026-11-22).

  tools/jp/bgb_print_options.py JP.gb OUTDIR [--jobs dens00,dens7F,...] [--port 8800] [--tail 2400]

The save is made in my core, no owner save needed: the SRAM of a new camera (all $AA + a valid calibration record, as
tools/jp/owner_id_first_boot.py), first boot, A on the title at frame 500, SHOOT, five photos saved (the core's synthetic
sensor), back to the main menu; the SRAM is written to OUTDIR/photos5.sav (re-made on every run, the same bytes each
time). The blood-type jobs use a copy whose slot-1 tag (photo number 1) has F0D = $09 / $0E / $10 and a birth date
F0E-F11 = 22 33 44 55, both tag checksums and the echo rewritten (rule of docs §3: lo = sum + $4E, hi = xor ^ $54).
Each job is one key sequence; its demo is built by stepping the core (bgb_run.core_demo, one byte per V-Blank start,
printer attached in the core too), then BGB plays it with tools/jp/bgb_printer.py on the link. OUTDIR/<job>/ gets
run.bmp, printer_log.json and page_NN.png; OUTDIR/print_options.csv one row per PRINT packet (job, page, sheets, margins,
palette, exposure, height in pixels) plus the core's end (mode, state) and BGB's.
Jobs: dens00 / dens7F (density slider 1C:05 held Left / Right 150 frames), border2 (1C:06 SELECT, border picker, Right x2),
wild1 (1C:06 OMAKE, wild-frame picker, Right x1), feed0 / feed9 (1E:01 feed set to 0 / 9, photos 1-3 marked),
bloodB / bloodO / bloodAB (Start = comment card).
"""
import argparse, csv, json, os, shutil, subprocess, sys
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(os.path.dirname(HERE)); sys.path.insert(0, HERE)
ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('out')
ap.add_argument('--jobs', default='dens00,dens7F,border2,wild1,feed0,feed9,bloodB,bloodO,bloodAB')
ap.add_argument('--port', type=int, default=8800); ap.add_argument('--tail', type=int, default=2400); ap.add_argument('--one', help=argparse.SUPPRESS)
a = ap.parse_args(); os.environ['GBCAM_ROM'] = os.path.abspath(a.rom); os.makedirs(a.out, exist_ok=True)
os.environ.setdefault('BGB_HF', '-headless'); os.environ.setdefault('PRN_SYNC3_PERIOD', '0.002')   # sandbox of 2026-11-22: a linked run stalls after the handshake unless the helper sends sync3 packets itself (docs §17.1)

ALBUM = [('A', 4, 200), ('Left', 4, 60), ('A', 4, 200), ('A', 4, 120), ('A', 4, 120), ('A', 4, 120), ('Up', 4, 60), ('A', 4, 200)]   # main menu -> VIEW -> album -> photo 1 -> menu -> 1C:03
MULTI = [('A', 4, 200), ('Select', 4, 120), ('Up', 4, 60), ('A', 4, 200), ('A', 4, 200), ('Right', 4, 40), ('A', 4, 200)]            # main menu -> lower page -> 06:01 -> 1B:01 -> OPTION 1E:01
MARK3 = [('Down', 4, 40), ('A', 4, 30), ('Right', 4, 30), ('A', 4, 30), ('Right', 4, 30), ('A', 4, 30), ('Down', 4, 40), ('A', 4, 100)]
JOBS = {
    'dens00': ('photos5', ALBUM + [('Select', 4, 60), ('Up', 4, 60), ('Left', 150, 30), ('A', 4, 60), ('A', 4, 100)]),
    'dens7F': ('photos5', ALBUM + [('Select', 4, 60), ('Up', 4, 60), ('Right', 150, 30), ('A', 4, 60), ('A', 4, 100)]),
    'border2': ('photos5', ALBUM + [('Select', 4, 60), ('Down', 4, 60), ('A', 4, 200), ('Right', 4, 30), ('Right', 4, 30), ('A', 4, 200), ('A', 4, 100)]),
    'wild1': ('photos5', ALBUM + [('Select', 4, 60), ('Down', 4, 60), ('Right', 4, 30), ('A', 4, 200), ('Right', 4, 30), ('A', 4, 200), ('A', 4, 100)]),
    'feed0': ('photos5', MULTI + [('Left', 4, 30)] * 4 + MARK3),
    'feed9': ('photos5', MULTI + [('Right', 4, 30)] * 7 + MARK3),
    'bloodB': ('blood09', ALBUM + [('Start', 4, 60), ('A', 4, 100)]),
    'bloodO': ('blood0E', ALBUM + [('Start', 4, 60), ('A', 4, 100)]),
    'bloodAB': ('blood10', ALBUM + [('Start', 4, 60), ('A', 4, 100)]),
}

def factory_sram(v=0x7C):
    s = bytearray(b'\xaa' * 0x20000); vec = bytes([v] * 12); x = 0
    for c in vec: x ^= c
    rec = vec + bytes([(sum(vec) + 0x0D) & 0xFF, (x + 0x23) & 0xFF])
    s[0x4FF0:0x5000] = b'\x1b\x13' + rec; s[0x11FF2:0x12000] = rec
    return bytes(s)
def make_photos5():
    import lib; from lib import g
    g.set_organic(1); g.reset(factory_sram()); g.L.gb_attach_printer(0); g.run(500)
    def tap(k, w): g.keys(lib.KEY[k]); g.run(4); g.keys(0); g.run(w)
    for k, w in [('A', 300), ('A', 200), ('A', 300)] + [('A', 200)] * 12 + [('B', 60), ('B', 200), ('B', 200)]: tap(k, w)
    s = bytes(g.sram()); assert lib.cur() == (0, 1) and s[0x11B2:0x11B7] == bytes(range(5)), (lib.cur(), s[0x11B2:0x11BC].hex())
    return s
def with_blood(s, v):
    s = bytearray(s); b = 0x2000                     # slot 1 = photo number 1 (vector 00 01 02 03 04)
    s[b + 0xF0D] = v; s[b + 0xF0E:b + 0xF12] = bytes([0x22, 0x33, 0x44, 0x55]); t = s[b + 0xF00:b + 0xF5A]; x = 0
    for c in t: x ^= c
    s[b + 0xF5A:b + 0xF5C] = bytes([(sum(t) + 0x4E) & 0xFF, x ^ 0x54]); s[b + 0xF5C:b + 0xFB8] = s[b + 0xF00:b + 0xF5C]
    return bytes(s)

if a.one:                                            # child process: one job (the core's state is per process, see docs §16.6 row 1)
    import bgb_run
    from bgb_printer import PrinterServer
    job = a.one; savname, seq = JOBS[job]; out = os.path.join(a.out, job); os.makedirs(out, exist_ok=True)
    sav = os.path.join(a.out, savname + '.sav'); sb = open(sav, 'rb').read()
    demo, core_end, off = bgb_run.core_demo(seq, sb, printer=1, tail=a.tail)
    mine = '/home/claude/bgbpo%d' % (a.port % 100)
    if not os.path.isdir(mine): shutil.copytree(bgb_run.BGB, mine)
    bgb_run.BGB = mine
    srv = PrinterServer(a.port, out).start()
    try: r = bgb_run.run(a.rom, sav, out + '/run', seq, demo=demo, extra=['-setting', 'SystemMode=0', '-connect', '127.0.0.1:%d' % a.port], timeout=1500)
    finally: srv.stop()
    for f in ('run.dem', 'run.sna', 'run.sav'):
        if os.path.exists(os.path.join(out, f)): os.remove(os.path.join(out, f))
    json.dump(dict(job=job, save=savname, core_end='%02X:%02X' % core_end, bgb_end='%02X:%02X' % (r['mode'], r['state']) if r['mode'] is not None else '', rc=r['rc'], seq=seq), open(os.path.join(out, 'job.json'), 'w'), indent=1)
    print(job, 'core', '%02X:%02X' % core_end, 'BGB', r['mode'], r['state'], 'pages', len(srv.pr.pages), flush=True)
    sys.exit(0)

base = make_photos5()
open(os.path.join(a.out, 'photos5.sav'), 'wb').write(base)
for v in (0x09, 0x0E, 0x10): open(os.path.join(a.out, 'blood%02X.sav' % v), 'wb').write(with_blood(base, v))
jobs = a.jobs.split(','); procs = []
for i, j in enumerate(jobs):                         # three at a time, one BGB folder and one port each
    procs.append(subprocess.Popen([sys.executable, __file__, a.rom, a.out, '--one', j, '--port', str(a.port + i), '--tail', str(a.tail)]))
    if len(procs) == 3:
        for p in procs: p.wait()
        procs = []
for p in procs: p.wait()
rows = []
for j in jobs:
    d = os.path.join(a.out, j)
    jj = json.load(open(os.path.join(d, 'job.json'))) if os.path.exists(os.path.join(d, 'job.json')) else {}
    lg = json.load(open(os.path.join(d, 'printer_log.json'))) if os.path.exists(os.path.join(d, 'printer_log.json')) else {'pages': []}
    for k, pg in enumerate(lg['pages'], 1):
        rows.append([j, jj.get('save'), k, pg.get('sheets', ''), pg.get('margins', ''), pg.get('palette', ''), pg.get('exposure', ''), pg.get('height', ''), jj.get('core_end'), jj.get('bgb_end')])
    if not lg['pages']: rows.append([j, jj.get('save'), 0, '', '', '', '', '', jj.get('core_end'), jj.get('bgb_end')])
for f in os.listdir(a.out):
    if f.endswith('.sav'): os.remove(os.path.join(a.out, f))      # synthetic, re-made by every run: not kept
with open(os.path.join(a.out, 'print_options.csv'), 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['job', 'save', 'page', 'sheets', 'margins', 'palette', 'exposure', 'height_px', 'core_end', 'bgb_end']); w.writerows(rows)
for r in rows: print(*r)
