#!/usr/bin/env python3
"""Which cell of the MAC-GBD threshold matrix ($A006-$A035) gets which level: decoded from the three writers of Cam_BuildDitherMatrix (README 18.12).
usage: sensor_matrix_order.py ROM [--csv OUT.csv] [--example A B C D] [--reference reference/patterns.mjs]
The matrix is 16 cells x 3 bytes; cell n = (addr-$A006)//3, byte k = (addr-$A006)%3 (so the bytes of a cell are consecutive).  The cell geometry (n = 4*row + col, row = y&3, col = x&3 of the
sensor pixel; pixel8 < t0 -> 3, < t1 -> 2, < t2 -> 1, else 0) is MAME's, not the ROM's (I): the ROM only writes the 48 bytes.  What is read here from the ROM bytes (C):
  D59C = 0  0A:440C  the same 3 bytes ($D583-$D585) in all 16 cells
  D59C = 1  0A:4427  ramp A: one `add hl,bc` per cell, 16 distinct values per byte k (rank 0-15)
  D59C = 2  0A:4307  ramp B: four cells share a value, `add hl,bc` x4 between the groups (4 distinct values per byte k)
with HL = anchor_k * 256 and BC = (anchor_(k+1) - anchor_k) * 16 (8.8 fixed point; $D583-$D586 = anchors a b c d, byte k uses a_k and a_(k+1)):  value = a_k + rank*(a_k+1 - a_k)/16
(ramp A) or a_k + group*(a_k+1 - a_k)/4 (ramp B), truncated per step by the 8.8 accumulator."""
import sys, csv, argparse

def bankoff(bank, addr): return bank * 0x4000 + (addr - 0x4000)
RANGES = {'ramp_B (D59C=2)': (0x4307, 0x440B), 'ramp_A (D59C=1)': (0x4427, 0x4559)}   # start of the first `ld a,[$D583]` .. the `ret`
LEN = {0xFA: 3, 0xEA: 3, 0xCB: 2, 0xE6: 2, 0x2E: 2}

def decode(rom, a0, a1):
    """walk the straight-line subset of SM83 used by the writers; returns [(pass k, address, number of `add hl,bc` so far in the pass)]"""
    pc = a0; k = -1; adds = 0; out = []
    while pc <= a1:
        op = rom[bankoff(0x0A, pc)]
        if op == 0x67: k += 1; adds = 0                       # ld h,a : a new byte k starts with HL = anchor
        elif op == 0x09: adds += 1                            # add hl,bc
        elif op == 0xEA:
            ad = rom[bankoff(0x0A, pc + 1)] | (rom[bankoff(0x0A, pc + 2)] << 8)
            if 0xA006 <= ad <= 0xA035: out.append((k, ad, adds))
        elif op == 0xC9: break
        pc += LEN.get(op, 1)
    return out

BAYER = [[0, 8, 2, 10], [12, 4, 14, 6], [3, 11, 1, 9], [15, 7, 13, 5]]       # textbook 4x4 ordered-dither matrix
def analyse(w, per):
    """w = decoded writes of one variant; per = adds per level step (1 or 4); returns (level matrix [row][col], ok, text)"""
    cells = {}
    for k, ad, adds in w:
        n, kb = divmod(ad - 0xA006, 3)
        assert kb == k, 'byte %d written in pass %d' % (kb, k)
        cells.setdefault(k, {})[n] = adds // per
    ok = sorted(a for _, a, _ in w) == list(range(0xA006, 0xA036)) and all(cells[k] == cells[0] for k in cells)
    M = [[cells[0][4 * r + c] for c in range(4)] for r in range(4)]
    return M, ok

def ramp(an, order, per=1):
    """48 matrix bytes as 16 cells x [t0, t1, t2] from 4 anchors and a cell->level matrix (list of 16): value = floor(a_k + level*per*(a_k+1 - a_k)/16)"""
    return [[an[k] + (lv * per * (an[k + 1] - an[k])) // 16 for k in range(3)] for lv in order]

def check_reference(rom, js):
    """HerrZatacke/dither-pattern-gen reference/patterns.mjs (MIT; commit b153952): 4 sets x 16 patterns x 4 x 4 cells x 3 bytes, [x][y][z] with cell n = 4x + y; set 1 = 'High Light' = the table at 0A:7C20, set 2 = 'Low Light' = 0A:7C60,
    sets 3 and 4 = the same without dither (first value of each sequence in all 16 cells).  Rebuilds the 4 x 16 patterns from the ROM tables and the decoded ramp-A order and compares."""
    import re
    txt = open(js).read(); parts = re.split(r'// Set \d', txt)[1:]; res = []
    w = decode(rom, *RANGES['ramp_A (D59C=1)']); M, ok = analyse(w, 1); order = [M[n // 4][n % 4] for n in range(16)]
    for si, (ta, name) in enumerate([(0x7C20, 'Set 1 High Light'), (0x7C60, 'Set 2 Low Light'), (0x7C20, 'Set 3 No Dither - High Light'), (0x7C60, 'Set 4 No Dither - Low Light')]):
        vals = [int(x, 16) for x in re.findall(r'0x([0-9A-Fa-f]{2})', parts[si])]
        assert len(vals) == 16 * 16 * 3, (name, len(vals))
        bad = 0
        for row in range(16):
            an = list(rom[bankoff(0x0A, ta + 4 * row):bankoff(0x0A, ta + 4 * row) + 4])
            exp = ramp(an, order) if si < 2 else [an[:3]] * 16
            got = [vals[(row * 16 + n) * 3:(row * 16 + n) * 3 + 3] for n in range(16)]
            bad += sum(1 for n in range(16) if exp[n] != got[n])
        res.append((name, bad)); print('%-32s table 0A:%04X: %d of 256 cells differ' % (name, ta, bad))
    return res

def main():
    ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('--csv'); ap.add_argument('--example', nargs=4, type=lambda s: int(s, 16)); ap.add_argument('--reference')
    a = ap.parse_args(); rom = open(a.rom, 'rb').read(); rows = []
    for name, (a0, a1) in RANGES.items():
        w = decode(rom, a0, a1); per = 1 if 'ramp_A' in name else 4
        M, ok = analyse(w, per)
        print('%s: %d writes, every address $A006-$A035 exactly once and the same cell order in the three passes: %s' % (name, len(w), ok))
        print('  level of cell (row = n//4, col = n%4):'); [print('   ', ' '.join('%2d' % v for v in r)) for r in M]
        if 'ramp_A' in name:
            T = [[M[c][r] for c in range(4)] for r in range(4)]
            print('  equals the textbook 4x4 Bayer matrix %s; its transpose %s' % (M == BAYER, T == BAYER))
        else:
            print('  4 levels in 2x2 blocks of cells (top-left 0, bottom-right 1, bottom-left 2, top-right 3)')
        for k, ad, adds in w: rows.append([name, k, (ad - 0xA006) // 3, '$%04X' % ad, (ad - 0xA006) // 3 // 4, (ad - 0xA006) // 3 % 4, adds // per])
        if a.example:
            an = a.example
            print('  thresholds for anchors %s:' % ' '.join('%02X' % x for x in an))
            for k in range(3):
                d = an[k + 1] - an[k]; step = (d & 0xFF) * 16        # 8.8 fixed point: BC = (b - a) * 16, taken mod 256 as the ROM does
                vals = [(an[k] * 256 + lv * per * step) >> 8 & 0xFF for lv in range(16 // per)]
                print('   byte t%d by level 0..%d: %s' % (k, 16 // per - 1, ' '.join('%02X' % v for v in vals)))
    if a.reference: check_reference(rom, a.reference)
    if a.csv:
        with open(a.csv, 'w', newline='') as fh:
            wr = csv.writer(fh, lineterminator='\n'); wr.writerow(['writer', 'byte_k', 'cell_n', 'address', 'cell_row', 'cell_col', 'level'])
            wr.writerows(rows)
        print('wrote', a.csv)

if __name__ == '__main__': main()
