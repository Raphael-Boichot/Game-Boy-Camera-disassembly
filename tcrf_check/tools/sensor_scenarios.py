#!/usr/bin/env python3
"""Run the sensor-register scenarios of README section 18 in BGB (sensor_bgb_log.py) and store the logs under OUTDIR/<scenario>/.
usage: sensor_scenarios.py OUTDIR --rom ROM --sav SAV [--workers 2] [--only a,b,c]
Key paths are those of guide_nodes.py (main menu -> SHOOT ...); the first 'A' passes the title screen (as in guide_bgb_walk.py)."""
import sys, os, json, shutil, multiprocessing
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
NAME = dict(A='A', B='B', L='Left', R='Right', U='Up', D='Down', s='Select', S='Start')
def K(t): return (NAME[t], 4, 60 if t in 'LRUD' else 200)
def path(p): return [('A', 4, 200)] + [K(t) for t in p.split()]
def idle(n): return ('-', 1, n)

# name -> (combo byte held for the 250 boot frames, save kind, key list, free frames after the hold, tail frames)
# save kind: 'sav' = the valid save given with --sav, 'ff' = a 128 kB save of $FF bytes, 'aa' = the valid save with the twelve bytes at AFF2 (bank 2) and BFF2 (bank 8) set to $AA
SCEN = {
    'boot':        (0x00, 'sav', [], 300, 30),                                   # normal boot: ValidityCheck + BootMeasureSeq + LiveInit
    'boot_ff':     (0x00, 'ff', [], 300, 30),                                    # SRAM all $FF: both records invalid -> default vector, but not all $AA -> normal BootMeasureSeq (no calibration)
    'boot_aa':     (0x00, 'aa', [], 3000, 30),                                   # both records = twelve $AA (factory-fresh pattern): Cam_Calib_Loader returns $FF -> STORE PLEASE WAIT -> full calibration
    'boot_fd':     (0xFD, 'sav', [], 3000, 30),                                  # all buttons but B held: the hidden factory test screen, then the calibration
    'boot_ffkeys': (0xFF, 'sav', [], 3000, 30),                                  # all eight buttons held
    'live':        (0x00, 'sav', path('A A') + [idle(1500)], 400, 30),           # SHOOT live view for ~25 s (the picture is BGB's fake sensor: constant)
    'live_bc':     (0x00, 'sav', path('A A U U U U D D D D D D D D U U U U R R R R L L L L L L L L R R R R') + [idle(600)], 400, 30),   # BRIGHTNESS and CONTRAST on the cross
    'live_opt':    (0x00, 'sav', path('A A s L R U D') + [idle(300)], 400, 30),  # option cross (flip / palette / dither / shutter sound)
    'shutter':     (0x00, 'sav', path('A A A') + [idle(600)], 400, 30),          # shutter with the album full (message) ...
    'selftimer':   (0x00, 'sav', path('A D A A') + [idle(900)], 400, 30),
    'timelapse':   (0x00, 'sav', path('A D A D A') + [idle(900)], 400, 30),
    'trick':       (0x00, 'sav', path('A D D A A') + [idle(300)], 400, 30),      # MAGIC -> TRICK LENSES
    'montage':     (0x00, 'sav', path('A D D A D A') + [idle(300)], 400, 30),
    'panorama':    (0x00, 'sav', path('A D D A D D A') + [idle(300)], 400, 30),
    'panorama_a':  (0x00, 'sav', path('A D D A D D A A') + [idle(900)], 400, 30),
    'live_dark':   (0x00, 'sav', path('A A U U U U U U') + [idle(4000)], 400, 30),         # BRIGHTNESS to its maximum (D59A = $0C): the loop keeps asking for more light -> bands 0..4 upwards
    'live_bright': (0x00, 'sav', path('A A D D D D D D D D D') + [idle(4000)], 400, 30),   # BRIGHTNESS to its minimum (D59A = $C0): the exposure falls -> bands downwards
    'shutter_save':(0x00, 'sav', path('L A A A A D A A B B B B R A A A A') + [idle(900)], 400, 30),   # H18 of the flowchart walk: one photo deleted first, then SHUTTER and A = save
    'selftimer_go':(0x00, 'sav', path('A D A A A') + [idle(1500)], 400, 30),
    'timelapse_go':(0x00, 'sav', path('A D A D A A') + [idle(1500)], 400, 30),
    'trick_go':    (0x00, 'sav', path('A D D A A A') + [idle(900)], 400, 30),
    'montage_go':  (0x00, 'sav', path('A D D A D A A') + [idle(900)], 400, 30),
    'panorama_print': (0x00, 'sav', path('A D D A D D A D A') + [idle(900)], 400, 30),     # MAGIC -> PANORAMA -> PRINT
    'gameface_go': (0x00, 'sav', path('A D D A D D D A A A') + [idle(900)], 400, 30),
    'gameface':    (0x00, 'sav', path('A D D A D D D A A') + [idle(900)], 400, 30),
}

def one(args):
    name, outdir, rom, sav = args
    import sensor_bgb_log as S
    combo, kind, keys, free, tail = SCEN[name]
    d = os.path.join(outdir, name); os.makedirs(d, exist_ok=True)
    if kind == 'ff':
        sv = os.path.join(d, 'in_ff.sav'); open(sv, 'wb').write(b'\xff' * 0x20000)
    elif kind == 'aa':
        sv = os.path.join(d, 'in_aa.sav'); b = bytearray(open(sav, 'rb').read())
        for off in (2 * 0x2000 + 0xFF2, 8 * 0x2000 + 0x1FF2): b[off: off + 12] = b'\xaa' * 12      # $AFF2 of RAM bank 2 and $BFF2 of RAM bank 8
        open(sv, 'wb').write(b)
    else: sv = sav
    r, lines = S.run(sv, d, name, combo, keys, free, tail, rom)
    ev, caps = S.parse(lines); S.write_csv(d, name, ev, caps)
    shutil.rmtree(os.path.join(d, 'bgbdir'), ignore_errors=True)
    for e in ('.dem', '.sna', '.sav'):
        try: os.remove(os.path.join(d, name + e))
        except OSError: pass
    return name, r['rc'], r['mode'], r['state'], len(lines), len(caps)

if __name__ == '__main__':
    a = sys.argv[1:]
    def opt(n, dflt=None):
        if n in a: i = a.index(n); v = a[i + 1]; del a[i:i + 2]; return v
        return dflt
    rom = os.path.abspath(opt('--rom')); sav = os.path.abspath(opt('--sav')); workers = int(opt('--workers', '2')); only = opt('--only')
    out = os.path.abspath(a[0]); os.makedirs(out, exist_ok=True)
    names = [n for n in SCEN if (not only or n in only.split(','))]
    with multiprocessing.Pool(workers) as p:
        for res in p.imap_unordered(one, [(n, out, rom, sav) for n in names]):
            print('%-12s rc %s mode:state %s:%s  log lines %d  captures %d' % (res[0], res[1], res[2], res[3], res[4], res[5]), flush=True)
