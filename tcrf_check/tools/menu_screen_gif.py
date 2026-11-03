#!/usr/bin/env python3
"""The whole main-menu screen turning its page, frame by frame as the game draws it (README 16.24): a 160 x 144 GIF at a pixel-perfect 4x, looping.
The loop is what two presses of Select do on the Japanese ROM: upper page at rest -> the head turns (MainMenu_SlideA_Tbl0, frames F1-F4) -> the body strips and the shake (MainMenu_SlideB_Tbl0 / Tbl2) -> the map of the
lower page (MainMenu_SlideC_Tbl0) -> lower page at rest -> back (SlideC_Tbl1, SlideB_Tbl3 / Tbl1) -> the head turns back (MainMenu_SlideA_Tbl1, F3-F0) -> upper page at rest.
Two modes:
  capture ROM CAPDIR [--worker I --workers N]   one BGB run per game frame (the demo ends n frames after the key press; BGB writes the LCD picture and the machine state): CAPDIR/P###, F###, R###
       P = the rest frames before the first press, F = after the first press (page down), R = after the second press (page up); the lower rest is the frames just before the second press (F256-F303).
  build ROM CAPDIR OUT.gif [--scale 4] [--rest 48] [--check]   the GIF from the LCD pictures (the game's own output); identical neighbours are merged into one GIF frame whose delay is their number of 59.73 Hz frames
       (rounded on the running total, 2 cs at least).  The committed GIF has every frame of the page-down run and of the rests and every second frame of the page-up run (the odd ones repeat the picture before).  --check also renders every captured state with gb_screen.py (the BG tiles / map / OAM of the state, no BGB picture) and looks every head block, body strip and map-row block of the
       state up in the ROM tables, then prints how many frames agree: what differs is a frame whose state and picture are a fraction of a frame apart (the game was updating VRAM or OAM).
Needs BGB (BGB_DIR) for `capture` only."""
import sys, os, glob
import numpy as np
from PIL import Image
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
PAL = [255, 255, 255, 170, 170, 170, 85, 85, 85, 0, 0, 0]
BGB_SHADE = {(255, 255, 255): 0, (173, 173, 181): 1, (90, 90, 107): 2, (24, 24, 33): 3}
FRAME_CS = 100 / 59.7275
PRESS_GAP = 300                       # frames between the first key press and the second one (the lower page is at rest by then)
FWD_MAX, RET_MAX, LOWER_REST0 = 100, 140, 4 + PRESS_GAP - 48       # last frame sampled after the first press / the second press; first lower-rest frame (the 48 before the second press)

def seq_for(kind, n):
    if kind == 'P': return [('A', 4, PRESS_GAP - n)]                                            # n frames before the first Select press
    first = [('A', 4, PRESS_GAP)]
    if kind == 'F': return first + [('Select', min(n, 4), max(n - 4, 0))]
    return first + [('Select', 4, PRESS_GAP), ('Select', min(n, 4), max(n - 4, 0))]               # R: n frames after the second press

def jobs(rest=48):
    j = [('P', n) for n in range(rest, 0, -1)] + [('F', n) for n in range(1, FWD_MAX + 1)] + [('F', n) for n in range(4 + PRESS_GAP - rest, 4 + PRESS_GAP)] + [('R', n) for n in range(1, RET_MAX + 1)]
    return j

def capture(rom_path, capdir, worker=0, workers=1, rest=48):
    import bgb_run
    os.makedirs(capdir, exist_ok=True)
    for k, (kind, n) in enumerate(jobs(rest)):
        if k % workers != worker: continue
        pre = os.path.join(capdir, '%s%03d' % (kind, n))
        if os.path.exists(pre + '.sna') and os.path.exists(pre + '.bmp'): continue
        r = bgb_run.run(rom_path, None, pre, seq_for(kind, n), tail=0)
        print(kind, n, r['mode'], r['state'], flush=True)
        for ext in ('.dem',):
            if os.path.exists(pre + ext): os.remove(pre + ext)

def shot(path):
    a = np.array(Image.open(path).convert('RGB')); out = np.zeros(a.shape[:2], np.uint8)
    for rgb, s in BGB_SHADE.items(): out[(a == rgb).all(axis=2)] = s
    return out

def upscale(sh, scale):
    im = Image.fromarray(sh, 'P'); im.putpalette(PAL)
    return im.resize((im.width * scale, im.height * scale), Image.NEAREST)

def tables(rom):
    raw = lambda b, a, n: rom[b * 0x4000 + (a - 0x4000 if b else a):][:n]
    heads = {'F%d' % j: raw(0x16, 0x6980 + 0x200 * j, 0x200) for j in range(10)}
    strips = {'%02X:%04X' % (b, a): raw(b, a, 0x500) for b, a in ((0x16, 0x5580), (0x16, 0x5A80), (0x16, 0x5F80), (0x16, 0x6480), (0x11, 0x4000), (0x11, 0x4500), (0x11, 0x4A00))}
    maps = {'%02X:%04X' % (b, a): raw(b, a, 0x1C0) for b, a in ((0x27, 0x54B0), (0x27, 0x5830), (0x27, 0x5670), (0x27, 0x5F30), (0x26, 0x5A60))}
    return heads, strips, maps

def from_tables(st, tabs):
    """(head frames whose 512 bytes are at $9100, body strips at $9200, map-row blocks at $9860) found in the state: the ids $10-$2F are a head block, $20-$6F a strip, rows 3-16 of the map a block."""
    heads, strips, maps = tabs; v = st['VRAM']
    return ([k for k, b in heads.items() if v[0x1100:0x1300] == b], [k for k, b in strips.items() if v[0x1200:0x1700] == b], [k for k, b in maps.items() if v[0x1860:0x1A20] == b])

def check(rom, capdir):
    import bgb_run, gb_screen
    tabs = tables(rom); n = same = tab = 0; odd = []
    for f in sorted(glob.glob(os.path.join(capdir, '*.sna'))):
        st = bgb_run.read_state(f); ref = shot(f[:-4] + '.bmp'); n += 1
        out = gb_screen.render(st['VRAM'], st['OAM'], st['LCDC'][0], st['SCX'][0], st['SCY'][0], st['BGP'][0], st['OBP'][0], st['OBP'][1])
        d = int((ref != out).sum()); same += d == 0
        h, s, m = from_tables(st, tabs)
        hh = [k for k, b in tabs[0].items() if st['VRAM'][0x1100:0x1200] == b[:0x100]]       # ids $10-$1F only: the collar ids $20-$2F belong to the strip once a strip is copied
        ok = bool(m) and (bool(s) or bool(h))
        tab += ok
        if d or not ok: odd.append((os.path.basename(f)[:4], d, h, s, m))
    print('%d captured frames: %d are the BGB picture to the pixel when rendered from the state (gb_screen.py), %d have a ROM head block or body strip and a ROM map block' % (n, same, tab))
    for o in odd: print('  differs:', o)

def build(rom, capdir, out, scale=4, rest=48, do_check=False):
    """The frames in order: the rest before the press, the page-down frames up to the one that brings the lower page's sprites back, the lower rest, the page-up frames up to the first of the upper page at rest + `rest` more.
    A frame that was not captured (every second one of the page-up run, F300, F302) repeats the previous picture."""
    import bgb_run
    have = lambda nm: os.path.exists(os.path.join(capdir, nm + '.bmp')) and os.path.exists(os.path.join(capdir, nm + '.sna'))
    state = lambda nm: bgb_run.read_state(os.path.join(capdir, nm + '.sna'))
    names = ['P%03d' % k for k in range(rest, 0, -1)]
    fwd = []
    for n in range(1, FWD_MAX + 1):
        nm = 'F%03d' % n; fwd.append(nm)
        if have(nm) and n > 20:
            st = state(nm); oam = st['OAM']
            if st['WRAM'][0x15CF] == 4 and sum(1 for i in range(40) if 0 < oam[4 * i] < 160): break
    names += fwd + ['F%03d' % n for n in range(4 + PRESS_GAP - rest, 4 + PRESS_GAP)]
    ret = []
    for n in range(1, RET_MAX + 1):
        nm = 'R%03d' % n; ret.append(nm)
        if have(nm) and n > 20 and state(nm)['WRAM'][0x15CF] == 1: ret += ['R%03d' % m for m in range(n + 1, min(n + rest, RET_MAX) + 1)]; break
    names += ret
    seq = []                                                              # [shade array, game frames] with identical neighbours merged
    for nm in names:
        if have(nm): sh = shot(os.path.join(capdir, nm + '.bmp'))
        if seq and (seq[-1][0] == sh).all(): seq[-1][1] += 1
        else: seq.append([sh, 1])
    ims = [upscale(sh, scale) for sh, _ in seq]; delays = []; acc = 0.0; cum = 0
    for _, k in seq:                                                      # delays on the running total, 2 cs at least (browsers show 0 / 1 cs as 10 cs)
        acc += k * FRAME_CS; d = max(2, int(round(acc)) - cum); delays.append(d); cum += d
    ims[0].save(out, save_all=True, append_images=ims[1:], duration=[d * 10 for d in delays], loop=0, optimize=False, disposal=1)
    print('%s: %d game frames -> %d GIF frames, %.2f s, %s, %d bytes' % (os.path.basename(out), len(names), len(ims), cum / 100, ims[0].size, os.path.getsize(out)))
    if do_check: check(rom, capdir)

if __name__ == '__main__':
    a = sys.argv[1:]
    if not a or a[0] not in ('capture', 'build'): print(__doc__); sys.exit(1)
    opt = lambda k, d: type(d)(a[a.index(k) + 1]) if k in a else d
    rom_path = a[1]; rom = open(rom_path, 'rb').read()
    if a[0] == 'capture': capture(rom_path, a[2], opt('--worker', 0), opt('--workers', 1), opt('--rest', 48))
    else: build(rom, a[2], a[3], opt('--scale', 4), opt('--rest', 48), '--check' in a)
