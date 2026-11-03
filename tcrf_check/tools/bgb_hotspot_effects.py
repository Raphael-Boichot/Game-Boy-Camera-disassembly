#!/usr/bin/env python3
"""BGB vs core: hot-spot trigger.  For each effect number k (0..15) a copy of an unlocking save is made whose first used photo slots carry one enabled hot spot
(effect k, sound FF, jump FF) at the pointer cell of the hot-spot viewer (mode $0C state 3); the joypad-only path (VIEW > SHOW > HOT-SPOT > photo > A) is replayed in
the real BGB and in my core, then A is tapped on the hot spot; the screens N frames later are compared (4-level luminance, fraction of equal pixels).
usage: bgb_hotspot_effects.py OUTDIR [FRAMES_AFTER_A ...]"""
import sys, os, numpy as np
out = sys.argv[1]; FR = [int(x) for x in sys.argv[2:]] or [30, 90]
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g, R
import bgb_run, sram_analyze as S
from PIL import Image
os.makedirs(out, exist_ok=True)
SRC = os.path.join(lib.ROOT, 'saves_unl', 'unl_CE10238211.sav')
PATH = [('B', 12, 10), ('Left', 8, 40), ('A', 10, 150), ('Right', 8, 40), ('A', 10, 150), ('Down', 8, 40), ('Down', 8, 40), ('A', 10, 150), ('A', 10, 150)]
KEY = dict(A=g.A, B=g.B, Left=g.LEFT, Right=g.RIGHT, Up=g.UP, Down=g.DOWN)
def core_run(sav, extra):
    lib.boot(sav, combo=2, free=400)      # BGB needs +3 frames of boot phase
    for k, h, w in PATH + extra: lib.act((KEY[k], h, w))
def quant(a):
    a = np.asarray(a.convert('L')).astype(int); u = sorted(set(a.ravel())); 
    lv = np.digitize(a, [(u[i] + u[i + 1]) / 2 for i in range(len(u) - 1)]) if len(u) > 1 else np.zeros_like(a)
    return lv if len(u) == 4 else None
def make(sav0, k, X, Y):
    b = bytearray(sav0); used = [i for i in range(30) if b[0x11B2 + i] < 30]
    for sl in used[:6]:
        base = S.slot_base(sl + 1) + 0xF00; t = bytearray(b[base:base + 0x5C])
        t[0x36:0x3B] = bytes([1, 0, 0, 0, 0]); t[0x3B:0x40] = bytes([X, 0, 0, 0, 0]); t[0x40:0x45] = bytes([Y, 0, 0, 0, 0])
        t[0x45:0x4A] = bytes([0xFF] * 5); t[0x4A:0x4F] = bytes([k, 0xFF, 0xFF, 0xFF, 0xFF]); t[0x4F:0x54] = bytes([0xFF] * 5)
        data = bytes(t[:0x5A]); blk = data + S.ck(data, 0, 0x5A); b[base:base + 0x5C] = blk; b[base + 0x5C:base + 0xB8] = blk
    return bytes(b)
sav0 = open(SRC, 'rb').read()
core_run(sav0, []); g.run(30); X, Y = g.peek(0xD667), g.peek(0xD668)
print('viewer state %02X:%02X, pointer cell (D667,D668) = (%d,%d)' % (*lib.cur(), X, Y))
tot = []
for k in range(16):
    sv = make(sav0, k, X, Y); f = '%s/hs_effect_%02d.sav' % (out, k); open(f, 'wb').write(sv)
    row = []
    for fr in FR:
        extra = [('A', 4, fr)]
        core_run(sv, extra); cs = (lib.cur(), R.screen(g))
        r = bgb_run.run('pocketcamera_jp.gb', f, '%s/hs_effect_%02d_f%d' % (out, k, fr), PATH + extra, combo=2, free=403 , tail=1)
        qa, qb = quant(Image.fromarray(cs[1])), quant(Image.open(r['shot']))
        eq = float((qa == qb).mean()) if qa is not None and qb is not None else float('nan')
        row.append((fr, '%02X:%02X' % cs[0], '%02X:%02X' % (r['mode'], r['state']), eq))
        Image.fromarray(cs[1]).save('%s/core_effect_%02d_f%d.png' % (out, k, fr))
    print('effect %2d: ' % k + '  '.join('+%d fr core %s bgb %s same-pixels %.2f' % x for x in row), flush=True); tot += [x[3] for x in row]
print('mean pixel agreement', np.nanmean(tot))
