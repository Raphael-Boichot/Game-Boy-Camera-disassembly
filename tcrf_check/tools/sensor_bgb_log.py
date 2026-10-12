#!/usr/bin/env python3
"""Log, in the real BGB (Windows exe under wine, headless), every write of the Japanese ROM to the camera registers A000-A005 (+ the first dither byte A006)
and the entry of the sensor routines of bank $0A, then turn the log into one row per capture (every write of an odd value to A000 = "start").

BGB emulates the MAC-GBD with a fake sensor (a fixed picture, whatever the registers say): what is checked here is the *code path* (which registers are written,
in which order, with which constant), not the pixel-dependent results.  The ROM registers are A001 = sensor reg 1 (N VH G), A002 = C1 (exposure high byte),
A003 = C0 (low byte, 16 us), A004 = reg 7 (E3-E0 I V2-V0), A005 = reg 0 (Z1 Z0 O5-O0); P, M, X (sensor registers 4-6) are added by the MAC-GBD (README section 18).

usage: sensor_bgb_log.py OUTDIR --sav SAV [--rom ROM] [--combo HEX] [--keys 'A:4:200,Left:4:60'] [--free N] [--tail N] [--name NAME]
  --combo : joypad byte held during the 250 boot frames (BGB demo layout: A=1 B=2 Select=4 Start=8 Right=$10 Left=$20 Up=$40 Down=$80; $FD = all but B = the hidden factory test)
  --keys  : KEYS:hold:wait items as in bgb_run.py (frames at 59.7 Hz)
  --free  : free frames after the boot hold (default 400)
output: OUTDIR/NAME.log (raw BGB lines)  OUTDIR/NAME_captures.csv (one row per capture)  OUTDIR/NAME_events.csv (every register write and every marker, in order)
The log lines are 'CAMn BANK VALUE ROMBANK PC TOTALCLKS' (write to A00n) and 'MK name TOTALCLKS ...' (marker); the camera registers are only mapped when the RAM bank is >= $10."""
import sys, os, shutil, csv, re
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
ROOT = os.path.dirname(os.path.dirname(HERE)) if os.path.isdir(os.path.join(os.path.dirname(os.path.dirname(HERE)), 'tcrf_check')) else os.path.dirname(HERE)
BGB_SRC = os.environ.get('BGB_SRC', '/home/claude/bgbx')

MARKERS = [  # (bank:addr, name, extra expressions) - bank $0A sensor routines (README section 18)
    ('0A:7D04', 'BootPing1', ''), ('0A:7D0A', 'CalibFarCall', ''), ('0A:7D10', 'BootPing2', ''),
    ('0A:45C9', 'ValidityCheck', ''), ('0A:46FD', 'CalibLoader', ''), ('0A:4724', 'BootMeasureSeq', ''), ('0A:4859', 'ExposureBandSelect', ''),
    ('0A:4947', 'FullCalibration', ''), ('0A:4961', 'FactoryMeasure1', ''), ('0A:4C6C', 'FactoryMeasure2', ''), ('0A:4E44', 'ThresholdConverge', 'ff8e=%(FF8E)%'),
    ('0A:4F58', 'CommitVector', ''), ('0A:4B6A', 'SAR', ''), ('0A:50AA', 'LiveInit', ''), ('0A:4000', 'MainDispatch', ''),
    ('0A:4C3B', 'PixelTest', 'thr=%H% ptr=%DE%'), ('0A:4C59', 'PixelTestResult', 'count=%B% thr=%H%'),
    ('0A:4011', 'Sum', 'bc=%BC% band=%(D587)% d59b=%(D59B)%'), ('0A:402D', 'Level', 'level=%(FF8A)% d59a=%(D59A)% d59b=%(D59B)% band=%(D587)%'), ('0A:403A', 'ShiftLoaded', 'level=%(FF8A)% shift=%(FF8B)% exp=%(D596)%%(D597)%'), ('0A:4076', 'ExposureNew', 'exp=%HL%'),
]


def build_args(extra_markers=()):
    wps = []
    for r in range(7):
        wps.append('A00%d//w/CAM%d %%XRAMBANK%% %%VALUE%% %%ROMBANK%% %%PC%% %%TOTALCLKS%%' % (r, r))
    brs = []
    for addr, name, ex in list(MARKERS) + list(extra_markers):
        brs.append('%s///MK %s %%TOTALCLKS%% %s' % (addr, name, ex))
    return ','.join(brs), ','.join(wps)


def run(sav, outdir, name, combo=0, keys=(), free=400, tail=60, rom=None, timeout=1800, extra_markers=()):
    mine = os.path.join(outdir, 'bgbdir')                       # a private BGB folder: BGB appends its debug-message file (debugmsg.txt) next to the exe
    if not os.path.isdir(mine): shutil.copytree(BGB_SRC, mine)
    os.environ['BGB_DIR'] = mine                                # bgb_run reads BGB_DIR when it is imported: set it first
    import bgb_run
    bgb_run.BGB = mine                                          # (already imported by an earlier scenario of the same process: set it again)
    rom = rom or os.path.join(ROOT, 'pocketcamera_jp.gb')
    lf = os.path.join(mine, 'debugmsg.txt')
    if os.path.exists(lf): os.remove(lf)
    br, wp = build_args(extra_markers)
    r = bgb_run.run(rom, sav, os.path.join(outdir, name), list(keys), combo=combo, free=free, br=br, extra=['-setting', 'DebugMsgFile=1', '-wp', wp], tail=tail, timeout=timeout)
    lines = open(lf, errors='replace').read().splitlines() if os.path.exists(lf) else []
    open(os.path.join(outdir, name + '.log'), 'w').write('\n'.join(lines) + '\n')
    return r, lines


def parse(lines):
    """-> (events, captures).  events: (kind, name/reg, value, rombank, pc, clocks, extra); captures: one dict per start, with the registers as the ROM has them then."""
    st = dict(r0=None, r1=None, c1=None, c0=None, r7=None, d=None)
    events, caps, ctx = [], [], 'start'
    names = {1: 'r1', 2: 'c1', 3: 'c0', 4: 'r7', 5: 'r0', 6: 'd'}
    for l in lines:
        p = l.split()
        if not p: continue
        if p[0].startswith('CAM') and len(p) >= 6:
            n = int(p[0][3:]); bank = int(p[1], 16); v = int(p[2], 16)
            if bank < 0x10: continue
            events.append(('W', 'A00%d' % n, v, p[3], p[4], int(p[5], 16), ''))
            if n == 0:
                if v & 1: caps.append(dict(idx=len(caps), ctx=ctx, a000=v, rombank=p[3], pc=p[4], clocks=int(p[5], 16), **{k: st[k] for k in st}))
            else: st[names[n]] = v
        elif p[0] == 'MK' and len(p) >= 3:
            events.append(('M', p[1], '', '', '', int(p[2], 16), ' '.join(p[3:])))
            if p[1] in ('BootPing1', 'CalibFarCall', 'BootPing2', 'ValidityCheck', 'CalibLoader', 'BootMeasureSeq', 'ExposureBandSelect', 'FullCalibration', 'FactoryMeasure1', 'FactoryMeasure2', 'CommitVector', 'LiveInit'): ctx = p[1]
    return events, caps


def write_csv(outdir, name, events, caps):
    with open(os.path.join(outdir, name + '_captures.csv'), 'w', newline='') as f:
        w = csv.writer(f); w.writerow(['idx', 'context', 'reg0', 'reg1', 'C1', 'C0', 'reg7', 'dither_byte0', 'A000', 'pc', 'clocks_hex'])
        for c in caps:
            h = lambda x: '' if x is None else '%02X' % x
            w.writerow([c['idx'], c['ctx'], h(c['r0']), h(c['r1']), h(c['c1']), h(c['c0']), h(c['r7']), h(c['d']), '%02X' % c['a000'], c['rombank'] + ':' + c['pc'], '%X' % c['clocks']])
    with open(os.path.join(outdir, name + '_events.csv'), 'w', newline='') as f:
        w = csv.writer(f); w.writerow(['kind', 'what', 'value', 'rombank', 'pc', 'clocks_hex', 'extra'])
        for e in events: w.writerow([e[0], e[1], '' if e[2] == '' else '%02X' % e[2], e[3], e[4], '%X' % e[5], e[6]])


if __name__ == '__main__':
    a = sys.argv[1:]
    def opt(n, d=None):
        if n in a: i = a.index(n); v = a[i + 1]; del a[i:i + 2]; return v
        return d
    sav = opt('--sav'); rom = opt('--rom'); combo = int(opt('--combo', '0'), 16); keys = opt('--keys', ''); free = int(opt('--free', '400')); tail = int(opt('--tail', '60')); name = opt('--name', 'run')
    out = os.path.abspath(a[0]); os.makedirs(out, exist_ok=True)
    seq = bgb_seq = []
    if keys:
        for it in keys.split(','):
            k, h, w = it.split(':'); bgb_seq.append((k, int(h), int(w)))
    r, lines = run(sav, out, name, combo, bgb_seq, free, tail, rom)
    events, caps = parse(lines); write_csv(out, name, events, caps)
    print('rc', r['rc'], 'mode:state', r['mode'], r['state'], 'log lines', len(lines), 'captures', len(caps))
