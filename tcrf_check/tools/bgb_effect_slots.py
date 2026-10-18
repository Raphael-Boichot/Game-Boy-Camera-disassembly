#!/usr/bin/env python3
"""Run the SHOOT image-effect slots of bank $0A (jump table 0A:541A, 96 entries, dispatcher Cam_DispatchEffect 0A:5406) in the real BGB on test photos and read off what every
slot does to the work buffer (README 16.28).

How the game calls a slot: Shoot_SetupCapture (06:77F5) takes the byte 06:60DB[4 * $D7E3 + $D7E4] (SHOOT variant, phase), ORs $20 / $40 when $D7EB = 1 / 2 and far-calls
0A:7CFE with it; the routine reads the 128 x 112 photo (16 x 14 tiles, 2bpp, 3,584 bytes) at SRAM bank 0 $A100 and writes the work buffer in WRAM $C000.
BGB cannot set the PC, so the ROM is patched (the patch is the experiment, not a feature of the game): the `call Joy_ClearSticky` of Main_Loop (00:2F33) becomes `call $3600` and a hook
sits in the bank-0 padding at $3600 (same method as bgb_dead_hook.py).  After DELAY main-loop passes the hook disables interrupts, copies the test photo P (kept in the save, SRAM bank 1
$B000, because the game clears SRAM bank 0 $A000-$AFFF at boot) to SRAM bank 0 $A100, copies the old work buffer Q (SRAM bank 1 $A000) to WRAM $C000-$CDFF, fills $CE00-$CFFF with $5A,
selects ROM bank $0A and calls Cam_DispatchEffect with A = slot, writes $77 to $DE03 (the ROM never touches $DE00-$DE03) and loops for ever, so the state BGB writes at the end of the
demo (-stateonexit: WRAM, HRAM, SRAM) is the state right after the routine.  The save is the all-unlocked save with the 'Magic' signature (any other is wiped at boot).
A control run (no call) gives the memory the routine did not touch.

Ten runs per slot, all from the same save layout:
  noise    P and Q are random 2-bit pixels: any pixel found in the output has one possible source; the check of everything below (every output pixel = the photo pixel the rules point to)
  struct   a picture a human can read (grey bands, an F, a diagonal, a ring): the contact sheet
  cx0-cy3  P = bits 2j..2j+1 of the x (cx) or y (cy) coordinate of each pixel: the eight outputs decode the source (x, y) of every output pixel of a slot that only samples the photo.
The decoded coordinates are fitted per 8 x 8 tile as sx = floor(a * x + bx), sy = floor(d * y + by) (a, d simple fractions), tiles with the same rule form a region; the noise
output must equal the photo at those coordinates for every pixel ('identity'; the two slots with a wrong table byte are modelled by table_bug_model).  Slots $20-$3F / $40-$5F are
compared pixel by pixel with their base slot (slot - $20 / - $40): 'A' = the base effect applied to the photo flipped left-right / upside down (label _OnFlipH / _OnFlipV), 'B' = the finished
picture of the base slot flipped, 'C' = that picture flipped inside the part of the buffer it writes (both _FlipH / _FlipV).

usage: bgb_effect_slots.py OUTDIR [--slots 0,1,2 | --all] [--rom ROM] [--save SAV] [--workers 2] [--delay 200]
  writes OUTDIR/effect_slots_bgb.csv (one row per slot: the committed evidence), OUTDIR/slots.csv (all columns), OUTDIR/renames.csv (label per routine), OUTDIR/sheet.png,
  OUTDIR/raw/ (one npz per BGB run: a finished run is reused, delete the folder when the ROM or the hook changed), about 1 run per second (970 runs for all 96 slots)
Needs BGB under wine (bgb_run.py: BGB_DIR), rgbasm / rgblink (RGBDS env, default /home/claude/tc/rgbds), numpy, Pillow."""
import sys, os, re, csv, json, glob, shutil, subprocess, tempfile, argparse, collections, concurrent.futures as cf
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import bgb_run
ROOT = os.environ.get('GBCAM_ROOT', '/home/claude/gbcam_jp')
REPO = os.path.dirname(os.path.dirname(HERE))
RGBDS = os.environ.get('RGBDS', '/home/claude/tc/rgbds')
W, H = 128, 112                                   # photo size in pixels; 16 x 14 tiles
NB = 16 * 14 * 16                                 # 3,584 bytes

def flat(bank, addr): return addr if bank == 0 else bank * 0x4000 + addr - 0x4000

# ------------------------------------------------------------------ static map: slot -> routine -> SHOOT variant / phase / option
def static_map(rom, sym_path=None):
    """slot -> dict(addr, label, callers=[(variant, phase, option)]); option = $D7EB (0, 1, 2) -> index OR $00, $20, $40"""
    tbl = rom[flat(6, 0x60DB):flat(6, 0x60DB) + 88]
    jt = rom[flat(0xA, 0x541A):flat(0xA, 0x541A) + 192]
    sym = {}
    sp = sym_path or os.path.join(REPO, 'pocketcamera_jp.sym')
    if os.path.exists(sp):
        for l in open(sp):
            m = re.match(r'0a:([0-9a-f]{4}) ([A-Za-z_]\w*)$', l.strip())
            if m: sym.setdefault(int(m.group(1), 16), m.group(2))
    callers = collections.defaultdict(list)
    for v in range(22):
        for p in range(4):
            for opt, o in ((0, 0), (1, 0x20), (2, 0x40)): callers[tbl[4 * v + p] | o].append((v, p, opt))
    out = {}
    for s in range(96):
        a = jt[2 * s] | jt[2 * s + 1] << 8
        out[s] = dict(addr=a, label=sym.get(a, ''), callers=callers.get(s, []))
    return out

# ------------------------------------------------------------------ test images
# two pairs: NOISE (every pixel random: a byte, tile or pixel found in the output has exactly one possible source, so copies, mirrors and shifts are read off without guessing)
# and STRUCT (a picture a human can look at: it goes on the contact sheet).  P = the photo (SRAM bank 0 $A100), Q = the former content of the work buffer (WRAM $C000).
def img_noise(seed): return np.random.RandomState(seed).randint(0, 4, (H, W)).astype(np.uint8)
def img_P():
    """STRUCT photo: horizontal grey bands (x // 32), a big F top left, a square bottom right, a diagonal and an L top right: nothing in it is symmetric"""
    y, x = np.mgrid[0:H, 0:W]; v = (x // 32).astype(np.uint8)
    v[8:40, 8:16] = 3; v[8:16, 8:32] = 3; v[20:28, 8:28] = 3                       # F
    v[88:104, 104:120] = 1                                                          # square
    for t in range(60): v[100 - t:102 - t, 40 + t:42 + t] = 0                       # diagonal
    v[4:20, 116:120] = 0; v[16:20, 108:120] = 0                                     # L
    return v
def img_Q():
    """STRUCT work buffer: vertical grey bands (y // 28), a ring, a diagonal from the top left and a triangle bottom left"""
    y, x = np.mgrid[0:H, 0:W]; v = (y // 28).astype(np.uint8)
    d = np.hypot(x - 64, y - 56); v[(d > 20) & (d < 25)] = 3
    for t in range(H): v[t, min(t, W - 1)] = 2
    for r in range(24): v[H - 1 - r, 4:4 + 24 - r] = 0
    return v
def img_coord(axis, j):
    """COORD photo: pixel = bits 2j..2j+1 of its x (or y) coordinate; eight of them (x0-x3, y0-y3) decode the source position of every output pixel of a slot that only samples the photo"""
    y, x = np.mgrid[0:H, 0:W]; return (((x if axis == 'x' else y) >> (2 * j)) & 3).astype(np.uint8)
KINDS = ['noise', 'struct'] + ['c%s%d' % (a, j) for a in 'xy' for j in range(4)]
def images(kind):
    if kind == 'noise': return img_noise(1), img_noise(2)
    if kind == 'struct': return img_P(), img_Q()
    return img_coord(kind[1], int(kind[2])), img_noise(2)
def to_tiles(img):
    out = bytearray()
    for ty in range(14):
        for tx in range(16):
            for r in range(8):
                row = img[ty * 8 + r, tx * 8:tx * 8 + 8]
                out.append(sum(((int(p) & 1) << (7 - i)) for i, p in enumerate(row))); out.append(sum(((int(p) >> 1) << (7 - i)) for i, p in enumerate(row)))
    return bytes(out)
def from_tiles(b, ntiles_w=16, ntiles_h=14):
    img = np.zeros((ntiles_h * 8, ntiles_w * 8), np.uint8); b = bytes(b) + bytes(ntiles_w * ntiles_h * 16 - len(b))
    for ty in range(ntiles_h):
        for tx in range(ntiles_w):
            o = (ty * ntiles_w + tx) * 16
            for r in range(8):
                lo, hi = b[o + 2 * r], b[o + 2 * r + 1]
                for i in range(8): img[ty * 8 + r, tx * 8 + i] = ((lo >> (7 - i)) & 1) | (((hi >> (7 - i)) & 1) << 1)
    return img

# ------------------------------------------------------------------ the hook and the patched ROM
def hook_asm(slot, delay, sent):
    def cp(src, dst, bank):
        return ['  ld a,$%02X' % bank, '  ld [$4000],a', '  ld hl,$%04X' % src, '  ld de,$%04X' % dst, '  ld bc,$0E00', '.cp%X%X%d:' % (src >> 8, dst >> 8, bank),
                '  ld a,[hl+]', '  ld [de],a', '  inc de', '  dec bc', '  ld a,b', '  or c', '  jr nz,.cp%X%X%d' % (src >> 8, dst >> 8, bank)]
    a = ['SECTION "hook", ROM0[$3600]', 'Hook:', '  call $0A82', '  ld a,[$DE01]', '  cp $FF', '  ret z', '  ld a,[$DE00]', '  inc a', '  ld [$DE00],a', '  cp %d' % delay, '  ret nz',
         '  ld a,$FF', '  ld [$DE01],a', '  di', '  ld a,$0A', '  ld [$0000],a']
    a += cp(0xB000, 0xC000, 1)                       # P (saved in album slot 1 of SRAM bank 1) -> WRAM
    a += cp(0xC000, 0xA100, 0)                       # -> the photo buffer of SRAM bank 0 (the game clears it at boot, so it cannot come with the save)
    a += cp(0xA000, 0xC000, 1)                       # Q (album slot 0, bank 1) -> the work buffer WRAM $C000
    a += ['  ld hl,$CE00', '  ld bc,$0200', '.fl:', '  ld a,$%02X' % sent, '  ld [hl+],a', '  dec bc', '  ld a,b', '  or c', '  jr nz,.fl', '  xor a', '  ld [$4000],a']   # sentinel behind it
    if slot < 0x100:
        a += ['  ld a,$0A', '  ldh [$FF9B],a', '  ld [$2000],a', '  ld a,$%02X' % slot, '  call $5406']
    a += ['  ld a,$77', '  ld [$DE03],a', '.halt:', '  jr .halt']
    return '\n'.join(a) + '\n'
def patch_rom(rom_bytes, slot, delay, sent):
    rom = bytearray(rom_bytes)
    tmp = tempfile.mkdtemp(prefix='effhook_'); env = dict(os.environ); env['PATH'] = RGBDS + ':' + env['PATH']
    open(tmp + '/h.asm', 'w').write(hook_asm(slot, delay, sent))
    subprocess.check_call(['rgbasm', '-o', tmp + '/h.o', tmp + '/h.asm'], env=env); subprocess.check_call(['rgblink', '-x', '-o', tmp + '/h.bin', tmp + '/h.o'], env=env)
    code = open(tmp + '/h.bin', 'rb').read()[0x3600:0x3700].rstrip(b'\0')
    assert all(v == 0 for v in rom[0x3600:0x3600 + len(code)]), 'bank-0 padding at $3600 is not free'
    rom[0x3600:0x3600 + len(code)] = code
    assert rom[0x2F33:0x2F36] == bytes([0xCD, 0x82, 0x0A]), 'Main_Loop call not where expected'
    rom[0x2F33:0x2F36] = bytes([0xCD, 0x00, 0x36])
    shutil.rmtree(tmp, ignore_errors=True)
    return bytes(rom)

def make_save(base_sav, P, Q):
    s = bytearray(open(base_sav, 'rb').read()); assert len(s) == 131072
    s[0x3000:0x3000 + NB] = to_tiles(P)           # bank 1 $B000 (the hook copies it to bank 0 $A100)
    s[0x2000:0x2000 + NB] = to_tiles(Q)           # bank 1 $A000 (-> WRAM $C000)
    return bytes(s)

def run_slot(args):
    """one BGB run (control = slot >= $100); never raises: a failed run comes back with done = False and an error text; a finished run is cached in OUT/raw and reused (--resume)"""
    slot, rom_bytes, sav_bytes, out, delay, kind = args
    d = os.path.join(out, 'work'); os.makedirs(d, exist_ok=True); os.makedirs(os.path.join(out, 'raw'), exist_ok=True)
    tag = kind + ('_ctl' if slot >= 0x100 else '_%02X' % slot); cache = os.path.join(out, 'raw', tag + '.npz')
    if os.path.exists(cache):
        z = np.load(cache); return dict(slot=slot, kind=kind, rc=0, done=True, wram=z['wram'].tobytes(), hram=z['hram'].tobytes(), sram=z['sram'].tobytes(), pc=int(z['pc']), err='')
    last = None
    for attempt in range(3):
        rom_path = os.path.join(d, 'rom_%s.gb' % tag); sav_path = os.path.join(d, 'in_%s.sav' % tag)
        try:
            open(rom_path, 'wb').write(patch_rom(rom_bytes, slot, delay, 0x5A)); open(sav_path, 'wb').write(sav_bytes)
            r = bgb_run.run(rom_path, sav_path, os.path.join(d, 'run_%s' % tag), [], free=delay + 200, tail=60)
            st = r['st']; w = st.get('WRAM', b'')
            res = dict(slot=slot, kind=kind, rc=r['rc'], done=len(w) == 0x2000 and w[0x1E03] == 0x77, wram=w, hram=st.get('HRAM', b''), sram=st.get('SRAM', b''), pc=r['pc'] or 0, err='')
            last = res
            if res['done'] and len(res['sram']) == 131072: break
        except Exception as e:                                   # wine start-up race, truncated state file ...
            last = dict(slot=slot, kind=kind, rc=-1, done=False, wram=b'', hram=b'', sram=b'', pc=0, err=repr(e)[:200])
        finally:
            for f in glob.glob(os.path.join(d, '*_%s*' % tag)) + glob.glob(os.path.join(d, 'run_%s.*' % tag)):
                try: os.remove(f)
                except OSError: pass
        if last['done']: break
    if last['done']: np.savez_compressed(cache, wram=np.frombuffer(last['wram'], np.uint8), hram=np.frombuffer(last['hram'], np.uint8), sram=np.frombuffer(last['sram'] if kind in ('noise', 'struct') else b'', np.uint8), pc=last['pc'])
    return last

# ------------------------------------------------------------------ analysis
def runs(mask, gap=8):
    idx = np.flatnonzero(mask); out = []
    if not len(idx): return out
    s = p = idx[0]
    for i in idx[1:]:
        if i - p > gap: out.append((s, p + 1)); s = i
        p = i
    out.append((s, p + 1)); return out
def rev8(b): return int('{:08b}'.format(b)[::-1], 2)
def orients(t):
    """the 16 bytes of a tile in the four orientations: id, H (mirrored left-right), V (upside down), HV"""
    rows = [(t[2 * r], t[2 * r + 1]) for r in range(8)]; hh = [(rev8(a), rev8(b)) for a, b in rows]
    f = lambda rr: bytes(x for ab in rr for x in ab)
    return {'id': f(rows), 'H': f(hh), 'V': f(rows[::-1]), 'HV': f(hh[::-1])}
def expr(a, b, v): return v if (a, b) == (1, 0) else ('%d-%s' % (b, v) if a == -1 else '%s%+d' % (v, b))
def analyse(res, ctl, P, Q):
    """what the slot did to the work buffer, from a NOISE run: footprint, byte copies, tile mapping, pixel look-up table"""
    w, c = np.frombuffer(res['wram'], np.uint8), np.frombuffer(ctl['wram'], np.uint8)
    diff = (w != c); diff[0x1E00:] = False                                   # $DE00-$DFFF: hook counters and stack
    info = dict(written=int(diff.sum()), foot=[(a, b) for a, b in runs(diff[:0x1E00], gap=0x30)],
                hram=['%02X' % (0x80 + i) for i in np.flatnonzero(np.frombuffer(res['hram'], np.uint8) != np.frombuffer(ctl['hram'], np.uint8))],
                sram=[(a, b) for a, b in runs(np.frombuffer(res['sram'], np.uint8) != np.frombuffer(ctl['sram'], np.uint8), gap=0x40)])
    Pb, Qb = to_tiles(P), to_tiles(Q); wb = bytes(w[:0x1E00])
    # 1. byte copies at any offset: 4-byte windows of the photo (SRAM $A100 stream) and of the old work buffer
    seg = []; win = {}
    for name, src in (('P', Pb), ('Q', Qb)):
        for i in range(len(src) - 3): win.setdefault(src[i:i + 4], []).append((name, i))
    deltas = {}
    for j in np.flatnonzero(diff[:0x1E00 - 3]):
        for nm, i in win.get(wb[j:j + 4], []): deltas.setdefault((nm, i - j), []).append(j)
    for (nm, d), js in sorted(deltas.items(), key=lambda kv: -len(kv[1])):
        for a, b in runs(np.isin(np.arange(0x1E00), js) , gap=0):
            if b - a + 3 >= 24: seg.append('C%03X-C%03X = %s%+d' % (a, b + 2, nm, d))
    info['bytes'] = seg[:8]
    # 2. tile mapping, four orientations, translations and mirror (x -> k - x, y -> k - y)
    src = {}
    for nm, S in (('P', Pb), ('Q', Qb)):
        for ti in range(224):
            for o, tb in orients(S[ti * 16:ti * 16 + 16]).items(): src.setdefault(tb, []).append((nm, ti, o))
    votes = collections.Counter(); ntile = 0; unm = 0
    for t in range(224):
        if not diff[t * 16:t * 16 + 16].any(): continue
        ntile += 1; hits = src.get(wb[t * 16:t * 16 + 16], [])
        if not hits: unm += 1; continue
        tx, ty = t % 16, t // 16
        for nm, ti, o in hits:
            sx, sy = ti % 16, ti // 16
            for a in (1, -1):
                for cc in (1, -1): votes[(nm, o, a, sx - a * tx, cc, sy - cc * ty)] += 1
    tm = []
    for (nm, o, a, bx, cc, by), n in votes.most_common(12):
        if n >= 4 and a * cc >= -1: tm.append('%s[%s,%s] %s: %d tiles' % (nm, expr(a, bx, 'x'), expr(cc, by, 'y'), o, n))
    info['tiles'] = tm[:5]; info['ntile_changed'] = ntile; info['tile_unmatched'] = unm
    out = from_tiles(w[:NB]); cm = None
    return info, out, cm

from fractions import Fraction
NICE = sorted({Fraction(p, q) for q in range(1, 10) for p in range(1, 19) if Fraction(p, q) <= 4}, key=lambda f: (f.denominator, f))
def nice(v):
    """the simple fraction (denominator <= 9) a fitted slope is closest to, signed, or None"""
    sg = -1 if v < 0 else 1; best = min(NICE, key=lambda f: abs(float(f) - abs(v)))
    return sg * best if abs(float(best) - abs(v)) < 0.04 else None
def interval(a, c, coord, pos):
    """offsets b for which floor(a * pos + b) == coord for every pixel of a tile: [lo, hi) (None when empty)"""
    lo = float((coord - a * pos).max()); hi = float((coord - a * pos).min()) + 1; return (lo, hi) if lo < hi else None
def cluster(items):
    """items: list of (key, lo, hi); greedy 1-D clustering of intervals that share a common offset -> dict key -> (group id, offset)"""
    out = {}; gid = 0; cur = None; members = []
    def close():
        nonlocal gid, cur, members
        if cur is None: return
        lo, hi = cur; cands = [Fraction(k, d) for d in (1, 2, 4, 8) for k in range(int(lo * d) - 1, int(hi * d) + 2)]
        off = next((c for c in cands if lo <= c < hi), Fraction(lo).limit_denominator(8))
        for m in members: out[m] = (gid, off)
        gid += 1; cur = None; members = []
    for key, lo, hi in sorted(items, key=lambda t: t[1]):
        if cur is not None and max(cur[0], lo) < min(cur[1], hi): cur = (max(cur[0], lo), min(cur[1], hi)); members.append(key)
        else: close(); cur = (lo, hi); members = [key]
    close(); return out
def fstr(a, b, v):
    """source coordinate as a formula of the output coordinate v: sign and slope a, offset b (Fractions)"""
    a = Fraction(a); b = Fraction(b); p, q = a.numerator, a.denominator
    if q == 1:
        t = ('-' if p == -1 else '' if p == 1 else '%d*' % p) + v
        return t + ('%+d' % b if b.denominator == 1 and b else '') if b.denominator == 1 else 'floor(%s%+s)' % (t, b)
    k = b * q
    return '(%s%+d)//%d' % (('-' if p == -1 else '' if p == 1 else '%d*' % p) + v, k, q) if k.denominator == 1 else 'floor(%s*%s%+s)' % (a, v, b)
def decode_geometry(R, slot):
    """source coordinates of every output pixel from the eight COORD runs; regions = tiles that share the same exact sampling rule sx = floor(a*x + bx), sy = floor(d*y + by)"""
    Q = img_noise(2); sx = np.zeros((H, W), int); sy = np.zeros((H, W), int); wr = np.zeros((H, W), bool)
    for kind in KINDS[2:]:
        o = from_tiles(np.frombuffer(R[(kind, slot)]['wram'], np.uint8)[:NB]); wr |= (o != Q)
        (sx if kind[1] == 'x' else sy).__iadd__(o.astype(int) << (2 * int(kind[2])))
    ok = (sx < W) & (sy < H)
    tiles = {}; bad = []; nowr = 0
    yy, xx = np.mgrid[0:8, 0:8]; A = np.c_[xx.ravel(), yy.ravel(), np.ones(64)]
    for ty in range(14):
        for tx in range(16):
            sl = (slice(ty * 8, ty * 8 + 8), slice(tx * 8, tx * 8 + 8))
            if not wr[sl].any(): nowr += 1; continue                       # a tile no run changed: the slot did not write it
            if not ok[sl].all(): bad.append((tx, ty)); continue
            cx = np.linalg.lstsq(A, sx[sl].ravel().astype(float), rcond=None)[0]; cy = np.linalg.lstsq(A, sy[sl].ravel().astype(float), rcond=None)[0]
            a, d = nice(cx[0]), nice(cy[1])
            if a is None or d is None or abs(cx[1]) > 0.04 or abs(cy[0]) > 0.04: bad.append((tx, ty)); continue
            ix = interval(float(a), 0, sx[sl], xx + tx * 8); iy = interval(float(d), 0, sy[sl], yy + ty * 8)
            if ix is None or iy is None: bad.append((tx, ty)); continue
            tiles[(tx, ty)] = (a, d, ix, iy)
    gx = {}; gy = {}
    for a in {t[0] for t in tiles.values()}: gx[a] = cluster([(k, v[2][0], v[2][1]) for k, v in tiles.items() if v[0] == a])
    for d in {t[1] for t in tiles.values()}: gy[d] = cluster([(k, v[3][0], v[3][1]) for k, v in tiles.items() if v[1] == d])
    groups = collections.defaultdict(list)
    for k, (a, d, ix, iy) in tiles.items(): groups[(a, d, gx[a][k][0], gy[d][k][0], gx[a][k][1], gy[d][k][1])].append(k)
    regs = []
    for (a, d, _, _, bx, by), tl in sorted(groups.items(), key=lambda kv: -len(kv[1])):
        xs = [t[0] for t in tl]; ys = [t[1] for t in tl]
        regs.append(dict(tiles=len(tl), x0=min(xs), x1=max(xs), y0=min(ys), y1=max(ys), sx=fstr(a, bx, 'x'), sy=fstr(d, by, 'y'), a=a, d=d, bx=bx, by=by, full=len(tl) == (max(xs) - min(xs) + 1) * (max(ys) - min(ys) + 1)))
    return dict(regions=regs, bad_tiles=bad, unwritten_tiles=nowr, coords=(sx, sy, ok), tiles=set(tiles))
def table_bug_model(P, geo):
    """the photo sampled at the decoded coordinates, with the one wrong byte of the double-width look-up table 0A:7700 (entry $4D holds $C0, the pattern wants $0C): for every source plane byte
    equal to $4D the plane bit of source pixel 1 moves to source pixel 3 (the table is used by the mirrored double-width slots 26 and 27 only)"""
    sx, sy, ok = geo['coords']; yy, xx = np.clip(sy, 0, H - 1), np.clip(sx, 0, W - 1); pred = P[yy, xx].astype(int)
    r = P.reshape(H, 16, 8).astype(int); wgt = 128 >> np.arange(8); planes = (((r & 1) * wgt).sum(-1), ((r >> 1) * wgt).sum(-1))
    for bit, pl in enumerate(planes):
        hit = pl[yy, xx // 8] == 0x4D
        pred = np.where(hit & (xx % 8 == 1), pred & ~(1 << bit), pred); pred = np.where(hit & (xx % 8 == 3), pred | (1 << bit), pred)
    return pred
def value_map(out, P, geo):
    """the noise run's output pixels against the photo pixels the decoded coordinates point to: 'identity' (pure copy of grey levels), a 4-entry look-up table, or the share of equal pixels"""
    sx, sy, ok = geo['coords']; m = np.zeros((H, W), bool)
    for tx, ty in geo['tiles']: m[ty * 8:ty * 8 + 8, tx * 8:tx * 8 + 8] = True
    m &= ok
    if not m.any(): return 'no sampled pixels'
    src = P[np.clip(sy, 0, H - 1), np.clip(sx, 0, W - 1)]
    M = np.zeros((4, 4), int)
    for u in range(4):
        for v in range(4): M[u, v] = int(((src[m] == u) & (out[m] == v)).sum())
    tot = int(M.sum()); diag = int(np.trace(M)); det = int(M.max(1).sum())
    if diag >= tot: return 'identity (%d px)' % tot
    if (table_bug_model(P, geo)[m] == out[m]).all(): return 'identity except %d px that follow the wrong table byte 0A:774D (%d px)' % (tot - diag, tot)
    if det >= 0.98 * tot and all(M[u].argmax() == u for u in range(4)): return 'identity except %d px (%d px)' % (tot - diag, tot)
    if det >= 0.98 * tot: return 'LUT %s (%d px)' % (''.join(str(int(M[u].argmax())) for u in range(4)), tot)
    return 'not pointwise: %.0f%% equal, best LUT %s %.0f%% (%d px)' % (100 * diag / tot, ''.join(str(int(M[u].argmax())) for u in range(4)), 100 * det / tot, tot)
def region_text(g, maxn=6):
    out = []
    for r in g['regions'][:maxn]:
        box = 'tx%d-%d,ty%d-%d' % (r['x0'], r['x1'], r['y0'], r['y1']); out.append('%s%s (%d t): sx=%s sy=%s' % (box, '' if r['full'] else '*', r['tiles'], r['sx'], r['sy']))
    if len(g['regions']) > maxn: out.append('+%d more regions' % (len(g['regions']) - maxn))
    if g['bad_tiles']: out.append('%d tiles not a plain sampling: %s' % (len(g['bad_tiles']), ' '.join('%d,%d' % t for t in g['bad_tiles'][:6])))
    return ' | '.join(out)

# ------------------------------------------------------------------ naming: the visible effect from the decoded sampling rules
ONE = Fraction(1); HALF = Fraction(1, 2)
def map_kind(r):
    """how one region samples the photo: identity, flips, x2 zoom (stretch), x2 decimation (reduce), or a shifted / other rule"""
    a, d, bx, by = r['a'], r['d'], r['bx'], r['by']
    xs = {(1, 0): 'x', (-1, 127): '-x'}.get((a, bx)); ys = {(1, 0): 'y', (-1, 111): '-y'}.get((d, by))
    if xs and ys: return {'xy': 'id', '-xy': 'flipH', 'x-y': 'flipV', '-x-y': 'rot180'}[xs + ys]
    if abs(a) == HALF and d == 1: return 'stretchH' + ('-flipped' if a < 0 else '')
    if a == 1 and abs(d) == HALF: return 'stretchV' + ('-flipped' if d < 0 else '')
    if abs(a) == HALF and abs(d) == HALF: return 'zoom2' + ('-flipped' if a < 0 or d < 0 else '')
    if abs(a) == 2 and abs(d) == 2: return 'reduce2' + ('-flipped' if a < 0 or d < 0 else '')
    return 'rule'
def rect(x0, x1, y0, y1): return {(x, y) for x in range(x0, x1 + 1) for y in range(y0, y1 + 1)}
SHAPES = {'LeftHalf': rect(0, 7, 0, 13), 'RightHalf': rect(8, 15, 0, 13), 'TopHalf': rect(0, 15, 0, 6), 'BottomHalf': rect(0, 15, 7, 13), 'QuadTL': rect(0, 7, 0, 6), 'QuadTR': rect(8, 15, 0, 6),
          'QuadBL': rect(0, 7, 7, 13), 'QuadBR': rect(8, 15, 7, 13), 'Top10Rows': rect(0, 15, 0, 9), 'Bottom10Rows': rect(0, 15, 4, 13), 'Top4Rows': rect(0, 15, 0, 3), 'Bottom4Rows': rect(0, 15, 10, 13), 'Window': rect(3, 12, 3, 10)}
def shape_token(tiles):
    """which part of the 16 x 14 tile buffer a slot writes: '' (all), a named rectangle, or a union of quadrants"""
    if tiles == rect(0, 15, 0, 13): return ''
    for k, v in SHAPES.items():
        if tiles == v: return k
    q = [k for k in ('QuadTL', 'QuadTR', 'QuadBL', 'QuadBR') if SHAPES[k] <= tiles]
    if q and set().union(*[SHAPES[k] for k in q]) == tiles: return 'Quads_' + '_'.join(k[4:] for k in q)
    return 'Tiles%d' % len(tiles)
FAMILY = {'id': 'Copy', 'flipH': 'FlipH', 'flipV': 'FlipV', 'rot180': 'Rot180', 'stretchH': 'StretchH2x', 'stretchV': 'StretchV2x', 'zoom2': 'Zoom2x', 'reduce2': 'Reduce2x'}
def effect_token(geo):
    """(token, detail): a short CamelCase name of what the slot writes, from the sampling rules only (the rules, not the code, name the effect)"""
    rs = geo['regions']
    if geo['bad_tiles']: return 'Irregular', '%d tiles are not a plain sampling' % len(geo['bad_tiles'])
    if not rs: return 'NoWrite', 'no tile of the work buffer changed'
    tiles = set(); [tiles.update(rect(r['x0'], r['x1'], r['y0'], r['y1'])) if r['full'] else None for r in rs]
    tiles = set(geo['tiles']); kinds = [map_kind(r) for r in rs]; shape = shape_token(tiles)
    if shape == '' and len(rs) == 2 and set(kinds) <= {'id', 'flipH', 'flipV', 'rot180'}:
        L = [r for r in rs if r['x1'] <= 7]; Rr = [r for r in rs if r['x0'] >= 8]; T = [r for r in rs if r['y1'] <= 6]; B = [r for r in rs if r['y0'] >= 7]
        if len(L) == 1 and len(Rr) == 1:
            kl, kr = map_kind(L[0]), map_kind(Rr[0])
            if (kl, kr) == ('id', 'flipH'): return 'MirrorLtoR', 'right half = left half mirrored'
            if (kl, kr) == ('flipH', 'id'): return 'MirrorRtoL', 'left half = right half mirrored'
        if len(T) == 1 and len(B) == 1:
            kt, kb = map_kind(T[0]), map_kind(B[0])
            if (kt, kb) == ('id', 'flipV'): return 'MirrorTtoB', 'bottom half = top half flipped upside down'
            if (kt, kb) == ('flipV', 'id'): return 'MirrorBtoT', 'top half = bottom half flipped upside down'
    if len(set(kinds)) == 1 and kinds[0] in FAMILY:
        fam = FAMILY[kinds[0]]
        if fam == 'Reduce2x' and shape == '' and len(rs) == 4: return 'Reduce2xTile2x2', 'four half-size copies, one per quadrant'
        if fam == 'Reduce2x' and shape.startswith('Quad'): return fam + shape, 'one half-size copy in the %s quadrant, the rest of the buffer untouched' % shape[4:]
        return fam + shape, region_text(geo, 2)
    return 'Other', region_text(geo, 4)
def tilemask(g):
    m = np.zeros((H, W), bool)
    for tx, ty in g['tiles']: m[ty * 8:ty * 8 + 8, tx * 8:tx * 8 + 8] = True
    return m
def relation(g0, g1, opt):
    """how the slot k + $20 * opt samples the photo compared with its base slot k, tested on every pixel:
    'A' = the base effect applied to the photo flipped (left-right for opt 1, upside down for opt 2), 'B' = the picture of the base effect flipped, 'C' = that picture flipped inside the part of the
    buffer it writes, '' = none of them"""
    sx0, sy0, _ = g0['coords']; sx1, sy1, _ = g1['coords']; m0, m1 = tilemask(g0), tilemask(g1)
    if not m0.any() or not m1.any(): return ''
    sl = (slice(None), slice(None, None, -1)) if opt == 1 else (slice(None, None, -1), slice(None))
    if (m0 == m1).all() and ((sx1 == W - 1 - sx0) & (sy1 == sy0))[m0].all() and opt == 1: return 'A'
    if (m0 == m1).all() and ((sx1 == sx0) & (sy1 == H - 1 - sy0))[m0].all() and opt == 2: return 'A'
    if (m1 == m0[sl]).all() and ((sx1 == sx0[sl]) & (sy1 == sy0[sl]))[m1].all(): return 'B'
    ys, xs = np.nonzero(m0); x0, x1, y0, y1 = xs.min(), xs.max(), ys.min(), ys.max()
    if (m0 == m1).all():
        yy, xx = np.mgrid[0:H, 0:W]
        srcx = (x0 + x1 - xx) if opt == 1 else xx; srcy = (y0 + y1 - yy) if opt == 2 else yy
        if ((sx1 == sx0[srcy.clip(0, H - 1), srcx.clip(0, W - 1)]) & (sy1 == sy0[srcy.clip(0, H - 1), srcx.clip(0, W - 1)]))[m1].all(): return 'C'
    return ''
def slot_token(slot, tok_base, rel):
    """(token, relation text) of slot k + $20 * opt from the token of its base slot k and the measured relation"""
    opt = slot >> 5
    if opt == 0: return tok_base, ''
    ax = 'left-right' if opt == 1 else 'upside down'; f = 'H' if opt == 1 else 'V'
    bs = 'slot %02X' % (slot & 0x1F)
    txt = {'A': '%s applied to the photo flipped %s' % (bs, ax), 'B': '%s with its picture flipped %s' % (bs, ax),
           'C': '%s with its picture flipped %s inside the part of the buffer it writes' % (bs, ax)}.get(rel, 'no simple relation to %s' % bs)
    if tok_base in ('NoWrite', 'Other', 'Irregular') or not rel: return tok_base, txt
    if tok_base == 'Copy': return 'Flip' + f, txt
    return tok_base + ('_OnFlip' if rel == 'A' else '_Flip') + f, txt

def source_box(geo):
    """source pixel range of the sampled tiles: 'x a-b, y c-d'"""
    sx, sy, ok = geo['coords']; m = np.zeros((H, W), bool)
    for tx, ty in geo['tiles']: m[ty * 8:ty * 8 + 8, tx * 8:tx * 8 + 8] = True
    return 'x %d-%d, y %d-%d' % (sx[m].min(), sx[m].max(), sy[m].min(), sy[m].max()) if m.any() else ''
def describe(slot, tok, geo, rel_text=''):
    """one sentence for the label note and the CSV: what the slot writes and what it reads (visible rules, i.e. relative to the photo that was in SRAM)"""
    n = len(geo['tiles']); part = '' if n == 224 else ' (%d of 224 tiles; the rest of the buffer is left alone)' % n
    box = source_box(geo)
    base = re.sub(r'_(On)?Flip[HV]$', '', tok)
    if tok == 'NoWrite': return 'writes nothing (a lone ret)'
    kinds = {'Copy': 'plain copy of the photo', 'FlipH': 'the photo flipped left-right', 'FlipV': 'the photo flipped upside down',
             'MirrorLtoR': 'right half of the picture = left half of the photo mirrored', 'MirrorRtoL': 'left half of the picture = right half of the photo mirrored',
             'MirrorTtoB': 'bottom half of the picture = top half of the photo flipped upside down', 'MirrorBtoT': 'top half of the picture = bottom half of the photo flipped upside down',
             'StretchV2x': 'the middle band of the photo stretched to double height', 'StretchH2x': 'the middle columns of the photo stretched to double width',
             'Zoom2x': 'the centre of the photo magnified x2 (both axes)', 'Reduce2xTile2x2': 'the photo reduced to half size (every second pixel and row) and tiled 2 x 2'}
    vis = effect_token(geo)[0]
    if slot >> 5 and vis in kinds: base = vis                     # the visible result is a named effect: describe that, then say how the option relates to the base slot
    if base in kinds: t = kinds[base]
    elif base.startswith('Reduce2xQuad'): t = 'the photo reduced to half size (every second pixel and row) into the %s quadrant' % base[-2:]
    elif base.startswith('Copy'): t = 'copy of part of the photo (%s)' % base[4:].replace('_', ' ').strip()
    else: t = 'sampling rule not classified'
    if slot >> 5 and tok not in ('FlipH', 'FlipV') and re.search(r'_(On)?Flip[HV]$', tok): t += '; = ' + rel_text
    return '%s%s; reads %s' % (t, part, box)

# ------------------------------------------------------------------ sheet
def sheet(items, P, Q, path):
    """contact sheet: the photo, the old work buffer, then the work buffer after each effect slot (blue = tiles the slot did not write)"""
    from PIL import Image, ImageDraw
    pal = np.array([[255, 255, 255], [170, 170, 170], [85, 85, 85], [0, 0, 0]], np.uint8)
    cols = 8; cw, ch = 128 + 10, 112 + 32; rows = (len(items) + 2 + cols - 1) // cols
    sh = Image.new('RGB', (cols * cw, rows * ch), (255, 255, 255)); dr = ImageDraw.Draw(sh)
    def put(i, img, label, tiles=None):
        x, y = (i % cols) * cw, (i // cols) * ch
        rgb = pal[img].astype(float)
        if tiles is not None:
            for ty in range(14):
                for tx in range(16):
                    if (tx, ty) not in tiles: rgb[ty * 8:ty * 8 + 8, tx * 8:tx * 8 + 8] = rgb[ty * 8:ty * 8 + 8, tx * 8:tx * 8 + 8] * 0.5 + np.array([0, 90, 255]) * 0.5
        sh.paste(Image.fromarray(rgb.astype(np.uint8)), (x + 5, y + 26)); l1, _, l2 = label.partition('|'); dr.text((x + 5, y + 2), l1, fill=(0, 0, 0)); dr.text((x + 5, y + 13), l2, fill=(90, 90, 90))
    put(0, P, 'photo|SRAM bank 0 A100'); put(1, Q, 'old work buffer|WRAM C000')
    def sub(lab):
        m = re.search(r'_(On)?Flip([HV])$', lab)
        return '' if not m else ('on photo flipped ' if m.group(1) else 'picture flipped ') + ('L-R' if m.group(2) == 'H' else 'U-D')
    for i, (slot, lab, img, tiles) in enumerate(items): put(i + 2, img, '%02X %s|%s' % (slot, re.sub(r'_(On)?Flip[HV]$', '', lab), sub(lab)), tiles)
    sh.save(path)

def callers_text(cl):
    g = collections.OrderedDict()
    for v, p, o in cl: g.setdefault((v, o), []).append(p)
    return ' '.join('v%d%s.p%s' % (v, '' if o == 0 else '+o%d' % o, ''.join(map(str, ps))) for (v, o), ps in g.items()) or 'none'
def fmt_ranges(rs, base=0xC000): return ' '.join('%04X-%04X' % (base + a, base + b - 1) for a, b in rs)

# ------------------------------------------------------------------ main
if __name__ == '__main__':
    ap = argparse.ArgumentParser(); ap.add_argument('out'); ap.add_argument('--slots'); ap.add_argument('--all', action='store_true')
    ap.add_argument('--rom', default=os.path.join(ROOT, 'pocketcamera_jp.gb')); ap.add_argument('--save'); ap.add_argument('--workers', type=int, default=2); ap.add_argument('--delay', type=int, default=200)
    A = ap.parse_args(); assert 1 <= A.delay <= 255, 'the hook counts in one byte'; os.makedirs(os.path.join(A.out, 'dump'), exist_ok=True)
    rom = open(A.rom, 'rb').read(); smap = static_map(rom)
    slots = list(range(96)) if A.all else [int(x, 16) for x in (A.slots or '0,1,2').split(',')]
    base = A.save or os.path.join(ROOT, 'saves_unl', 'GAMEBOYCAMERA_all_unlocked.sav')      # a save with the 'Magic' signature, all unlocked, 0 photos (the game wipes any other)
    jobs = []; imgs = {}
    for kind in KINDS:
        P, Q = images(kind); imgs[kind] = (P, Q); sav = make_save(base, P, Q)
        jobs += ([(0x100, rom, sav, A.out, A.delay, kind)] if kind in ('noise', 'struct') else []) + [(s, rom, sav, A.out, A.delay, kind) for s in slots]
    with cf.ThreadPoolExecutor(A.workers) as ex: results = list(ex.map(run_slot, jobs))
    R = {(r['kind'], r['slot']): r for r in results}
    for kind in ('noise', 'struct'):
        c = R[(kind, 0x100)]; P, Q = imgs[kind]; Pb, Qb = to_tiles(P), to_tiles(Q)
        print('control %s: done %s, pc %s; SRAM bank 0 $A100 = P: %s; WRAM $C000 = Q: %s' % (kind, c['done'], c['pc'] and hex(c['pc']), bytes(c['sram'][0x100:0x100 + NB]) == Pb, bytes(c['wram'][:NB]) == Qb))
    rows = []; items = []; (P, Q) = imgs['noise']; (Ps, Qs) = imgs['struct']; ev = []; done = {}
    for s in slots:
        rn, rs = R[('noise', s)], R[('struct', s)]; rc = [R[(k, s)] for k in KINDS[2:]]
        base_row = dict(slot='%02X' % s, addr='%04X' % smap[s]['addr'], routine=smap[s]['label'], reach='yes' if smap[s]['callers'] else 'never')
        if not (rn['done'] and rs['done'] and all(r['done'] for r in rc)):
            rows.append(dict(base_row, verdict='did not finish (pc %s)' % (rn['pc'] and hex(rn['pc'])))); print('slot %02X did not finish' % s); continue
        info, out, cm = analyse(rn, R[('noise', 0x100)], P, Q); geo = decode_geometry(R, s)
        done[s] = dict(row=base_row, info=info, out=out, geo=geo, outs=from_tiles(np.frombuffer(rs['wram'], np.uint8)[:NB]), base_tok=effect_token(geo)[0])
    for s in slots:
        if s not in done: continue
        d = done[s]; info, out, geo, base_row = d['info'], d['out'], d['geo'], d['row']; b = s & 0x1F
        rel = relation(done[b]['geo'], geo, s >> 5) if s >> 5 and b in done else ''
        tok, det = slot_token(s, done[b]['base_tok'] if b in done else effect_token(geo)[0], rel); lut = value_map(out, P, geo)
        if s >> 5 == 0: det = effect_token(geo)[1]
        rows.append(dict(base_row, footprint=fmt_ranges(info['foot']), bytes_written=info['written'], tiles_changed=info['ntile_changed'], tiles_unmatched=info['tile_unmatched'],
                         effect=tok, effect_detail=det, geometry=region_text(geo), unwritten_tiles=geo['unwritten_tiles'], byte_copies=' | '.join(info['bytes']), tile_map=' | '.join(info['tiles']), values=lut,
                         hram_diff=' '.join(info['hram']), sram_diff=fmt_ranges(info['sram'], 0), callers=callers_text(smap[s]['callers']),))
        ev.append(dict(slot=s, entry=smap[s]['addr'], old=smap[s]['label'], tok=tok, rel=rel, what=describe(s, tok, geo, det), rule=region_text(geo), values=lut, tiles=len(geo['tiles']), bytes=info['written'],
                       hram=' '.join(h for h in info['hram'] if h != '9B'), sram=fmt_ranges(info['sram'], 0) or 'no', callers=callers_text(smap[s]['callers']), reach='yes' if smap[s]['callers'] else 'never'))
        if tok != 'NoWrite': items.append((s, tok, d['outs'], geo['tiles']))
        print('%02X %-30s %-30s %-3s %5d B | %s | values: %s' % (s, smap[s]['label'][:30], tok, rel, info['written'], region_text(geo, 3)[:150], lut))
    keys = ['slot', 'addr', 'routine', 'reach', 'footprint', 'bytes_written', 'tiles_changed', 'tiles_unmatched', 'effect', 'effect_detail', 'geometry', 'unwritten_tiles', 'values', 'byte_copies', 'tile_map', 'hram_diff', 'sram_diff', 'callers', 'verdict']
    with open(os.path.join(A.out, 'slots.csv'), 'w', newline='', encoding='utf-8') as f:
        wr = csv.DictWriter(f, keys, extrasaction='ignore'); wr.writeheader(); [wr.writerow(r) for r in rows]
    sheet(items, Ps, Qs, os.path.join(A.out, 'sheet.png'))
    # the committed evidence: one row per slot, the label every slot of a routine shares (named after its lowest slot), and the renames to apply
    by = collections.OrderedDict()
    for e in ev: by.setdefault(e['entry'], []).append(e)
    for e in ev:
        grp = by[e['entry']]; first = grp[0]
        e['label'] = first['old'] if first['tok'] in ('NoWrite', 'Other', 'Irregular') else 'Fx%02X_%s' % (first['slot'], first['tok'])
        e['serves'] = ';'.join('%02X' % g['slot'] for g in grp)
    with open(os.path.join(A.out, 'effect_slots_bgb.csv'), 'w', newline='', encoding='utf-8') as f:
        wr = csv.writer(f, lineterminator='\n')
        wr.writerow(['slot', 'entry', 'label', 'routine_serves_slots', 'reached_by_game', 'shoot_variant_phase', 'effect', 'what_it_does', 'sampling_rule', 'grey_levels', 'tiles_written', 'bytes_changed', 'hram_scratch', 'sram_written'])
        for e in ev: wr.writerow(['%02X' % e['slot'], '0A:%04X' % e['entry'], e['label'], e['serves'], e['reach'], e['callers'], e['tok'], e['what'], e['rule'], e['values'], e['tiles'], e['bytes'], e['hram'], e['sram']])
    with open(os.path.join(A.out, 'renames.csv'), 'w', newline='', encoding='utf-8') as f:
        wr = csv.writer(f, lineterminator='\n'); wr.writerow(['bank', 'addr', 'old', 'new', 'slots', 'what'])
        for entry, grp in by.items():
            if grp[0]['label'] != grp[0]['old']: wr.writerow(['0A', '%04X' % entry, grp[0]['old'], grp[0]['label'], grp[0]['serves'], grp[0]['what']])
