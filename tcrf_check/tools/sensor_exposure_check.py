#!/usr/bin/env python3
"""Replay the auto-exposure law and the five-band state machine of Cam_MainDispatch (bank $0A, $4000-$42B9) on recorded live-view exposures and say
how many frame-to-frame steps the ROM's rule explains.

Rule (README section 18.5, read from the ROM):  level L = (sum of the 2-bit pixel values of the sampled bytes) / [D59A]  (0..159, never observed here: it is the unknown),
  d = e >> SH[L]   (SH = table at 0A:7B00, 160 bytes; SH = 16 means 0),   e' = e + d (saturating at $FFFF) if L >= 36, else e - d,
  then the band tests:   band 2: e' < $0800 -> band 1 with e = $0B00;   e' >= $6000 -> band 3 with e = $3500
                         band 3: e' < $2800 -> band 2 with e = $4500;   e' >= $C000 -> band 4 with e = $8500
                         band 4: e' < $6000 -> band 3 with e = $8C00
                         band 0 (N=0, VH=1): e' >= $30 -> band 1 with e = $48;  e' < $10 -> e = $10
                         band 1 (N=1, VH=3): e' < $31 -> band 0 with e = $1F;   e' >= $1200 -> band 2 with e = $0D80
usage: sensor_exposure_check.py ROM.gb  FILE.xlsx[:SHEET]  [...]     (Sheet1 of the workbook, or the named sheet - the 'print' sheet has C in ms and decoded fields)"""
import sys, collections
sys.path.insert(0, __file__.rsplit('/', 1)[0])


def shift_table(rom):
    return [rom[0x0A * 0x4000 + 0x3B00 + i] for i in range(160)]      # 0A:7B00


def law(e, L, SH):
    s = SH[L]; d = (e >> s) if s < 16 else 0
    if L >= 0x24: return min(e + d, 0xFFFF)
    return (e - d) & 0xFFFF


def step(b, e, L, SH):
    e1 = law(e, L, SH)
    if b == 2:
        if e1 < 0x0800: return 1, 0x0B00
        if e1 >= 0x6000: return 3, 0x3500
        return 2, e1
    if b == 3:
        if e1 < 0x2800: return 2, 0x4500
        if e1 >= 0xC000: return 4, 0x8500
        return 3, e1
    if b == 4:
        if e1 < 0x6000: return 3, 0x8C00
        return 4, e1
    if b == 0:
        if e1 >= 0x30: return 1, 0x48
        if e1 < 0x10: e1 = 0x10
        return 0, e1
    if e1 < 0x31: return 0, 0x1F
    if e1 >= 0x1200: return 2, 0x0D80
    return 1, e1


def band_of(reg1):
    n, vh, g = reg1 >> 7, (reg1 >> 5) & 3, reg1 & 31
    if (n, vh) == (0, 1): return 0
    if (n, vh) == (1, 3): return 1 if g < 4 else 2 if g in (4, 5) else 3 if g == 8 else None
    if (n, vh, g) == (0, 0, 0x0A): return 4
    return None


def check(seq, SH, name):
    """seq: list of (band, exposure)"""
    ok = amb = bad = 0; sw = collections.Counter(); badlist = []
    for (b0, e0), (b1, e1) in zip(seq, seq[1:]):
        sol = [L for L in range(160) if step(b0, e0, L, SH) == (b1, e1)]
        if not sol: bad += 1; badlist.append((b0, e0, b1, e1)); continue
        ok += 1
        if b0 != b1: sw[(b0, b1)] += 1
        if len(sol) > 1: amb += 1
    print('%-34s %4d steps: %4d explained by the ROM rule (%d with one level L only), %d not explained, band switches %s' % (name, ok + bad, ok, ok - amb, bad, dict(sorted(sw.items()))))
    for x in badlist[:5]: print('   not explained: band %s e=%04X -> band %s e=%04X' % x)
    return ok, bad


if __name__ == '__main__':
    rom = open(sys.argv[1], 'rb').read(); SH = shift_table(rom)
    import sensor_decode as D
    for arg in sys.argv[2:]:
        fn, _, sheet = arg.partition(':')
        if sheet:
            import openpyxl
            ws = openpyxl.load_workbook(fn, data_only=True)[sheet]
            rows = [r for r in ws.iter_rows(min_row=2, values_only=True) if r[0] is not None]
            seq = []
            for r in rows:                      # N, VH, E, Z, I, C(ms), O, V, G
                reg1 = (r[0] << 7) | (r[1] << 5) | r[8]; seq.append((band_of(reg1), round(r[5] * 1000 / 16)))
        else:
            rows = [d for d in D.rows_of(fn) if d['reg0'] or d['reg1']]
            seq = [(band_of(d['reg1']), d['C']) for d in rows]
        check([s for s in seq if s[0] is not None], SH, arg)
