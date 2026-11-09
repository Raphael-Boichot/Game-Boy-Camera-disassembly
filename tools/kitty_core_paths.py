#!/usr/bin/env python3
"""Hello Kitty ROM: the key paths found in BGB, replayed in the core for data-read coverage (evidence for the unused-asset pass).

  tools/kitty_core_paths.py ROM [--out roms/hello_kitty/trace/cov_kitty_paths.npz] [--forced-out roms/hello_kitty/trace/forced_kitty.npz]
                            [--report roms/hello_kitty/trace/paths_kitty.csv]

BGB with read watchpoints over hundreds of ROM ranges runs far too slowly for runs of thousands of frames, so the BGB scenarios of
2026-11-08 (README: album print with the six print frames, the printer errors, the Strawberry Channel without Kitts) are replayed
here, in the core, which records every executed and every read ROM byte. Each path is a list of key taps written as in the BGB
tools (A B Select Start Right Left Up Down; each held 8 frames then 90 free; '-' = an idle slot) after a 700-frame boot, then a
number of free frames; the core's printer stand-in (the replies of the real traces, gb_printer_model(1)) answers on the link, and a
path may inject printer replies (cmd 1 INIT, 2 PRINT, 4 DATA, 15 INQUIRY; n-th packet; status; count). Saves: 'kitts' = the core's
formatted SRAM with 999,999 Kitts, 'nokitts' = the same with 0 Kitts; 'photo:' before a path = first take and keep one photo
(title A, take A, shutter A, keep A, B to the main menu); 'hold:KK' first = the key byte KK held for 80 frames from power-on
(Select + Start = $0C opens the erase-all-data question, mode $00 state $02); 'wait:N' first = N more idle frames after the boot
(the Strawberry Channel picks a random page: the waits 0-52 give all eight pages of channel 6, the staff credits). The forced paths patch entry $01 of ModeTable (00:0D00) with the mode
of their name, as tools/kitty_bgb_forced_modes.py does (a copy of the ROM in memory; evidence I: never a way the game runs).
Writes two coverage files in the format of tools/kitty_coverage.py (exec / dread / reader): the organic paths and the forced
ones, and a report: path, end mode:state, the modes seen in order.
"""
import sys, os, csv, argparse
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); KD = os.path.join(REPO, 'roms', 'hello_kitty')
sys.path.insert(0, os.path.join(REPO, 'coverage', 'src'))
import numpy as np, gbcov as G
ap = argparse.ArgumentParser(); ap.add_argument('rom')
ap.add_argument('--out', default=os.path.join(KD, 'trace', 'cov_kitty_paths.npz')); ap.add_argument('--forced-out', default=os.path.join(KD, 'trace', 'forced_kitty.npz'))
ap.add_argument('--report', default=os.path.join(KD, 'trace', 'paths_kitty.csv')); a = ap.parse_args()
ALB = 'photo: - - Down A Down Down A'                      # main menu -> album -> third icon (print): mode $06 state $03
PATHS = [  # name, save, path, free frames, printer injections
    ('album_print_start', 'kitts', ALB + ' Right A Start', 4000, []),
] + [('album_print_frame%d' % n, 'kitts', ALB + ' Right' * n + ' A A', 2500, []) for n in range(6)] + [
    ('print_err_init_ff', 'kitts', 'A A A Start', 1500, [(1, 1, 0xFF, 1)]),
    ('print_err_inq3_10', 'kitts', 'A A A Start', 1500, [(15, 3, 0x10, 1)]),
    ('print_err_inq3_ff', 'kitts', 'A A A Start', 1500, [(15, 3, 0xFF, 1)]),
] + [('print_err_inq12_%02x_w%d' % (s, w), 'kitts', 'A A A' + ' -' * w + ' Start', 1500, [(15, 12, s, 200)]) for s in (0x20, 0x40, 0x80) for w in range(4)] + [
    ('boot_select_start_erase_B', 'kitts', 'hold:0C B', 600, []),
    ('boot_select_start_erase_A', 'kitts', 'hold:0C A', 900, []),
] + [('strawberry_ch6_credits_w%d' % w, 'kitts', 'wait:%d A Up A Up A Right Right Right Right Right Right' % w, 12000, []) for w in (0, 7, 14, 19, 21, 28, 35, 52)] + [
    ('strawberry_no_kitts', 'nokitts', 'A Up A Up A A B A A B', 900, []),
    ('strawberry_no_kitts_right', 'nokitts', 'A Up A Up A Right Right A Right A', 900, []),
]
FORCED = [('forced_mode_%02X' % m, m) for m in (0x13, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D)]
BIT = dict(A=1, B=2, Select=4, Start=8, Right=0x10, Left=0x20, Up=0x40, Down=0x80)
def core_mask(b): return ((b << 4) | (b >> 4)) & 0xFF      # the core's key byte has the nibbles swapped (tools/kitty_scenarios.py)
def taps(path): return [x for k in path.split() for x in ([core_mask(BIT[k])] * 8 if k != '-' else [0] * 8) + [0] * 90]
G.load_rom(a.rom); G.reset(bytes(0x20000)); G.run(600); base = bytearray(bytes(G.sram()))
SAVES = {'kitts': bytes(base[:0x100A]) + b'\x99\x99\x99' + bytes(base[0x100D:]), 'nokitts': bytes(base[:0x100A]) + b'\x00\x00\x00' + bytes(base[0x100D:])}
romb = bytearray(open(a.rom, 'rb').read())
def run(rom_bytes, save, keys, inj, hold=None):
    p = os.path.join('/tmp', 'kitty_core_paths_%d.gb' % os.getpid()); open(p, 'wb').write(rom_bytes)
    G.load_rom(p); G.reset(save); G.L.gb_cov_clear(); G.L.gb_printer_model(1); G.L.gb_attach_printer(1); G.L.gb_printer_inject_clear()
    for c, n, s, k in inj: G.L.gb_printer_inject(c, n, s, k)
    if hold is not None:                                  # keys held from power-on (the game reads them once at boot, $D8D8)
        G.keys(core_mask(hold))
        for _ in range(80): G.run(1)
        G.keys(0); G.run(620)
    else: G.run(700)
    seen = []
    for k in keys:
        G.keys(k); G.run(1); m = '%02X:%02X' % (G.peek(0xFF8D), G.peek(0xFF8E))
        if not seen or seen[-1] != m: seen.append(m)
    os.remove(p)
    return seen, np.array(G.cov_exec()), np.array(G.cov_dread()), np.array(G.cov_reader())
def acc(tot, r):
    _, ex, dr, rd = r
    if tot is None: return [ex.copy(), dr.copy(), rd.copy()]
    tot[0] |= ex; tot[1] |= dr; tot[2] = np.where(tot[2] == 0, rd, tot[2]); return tot
rows = []; org = None; frc = None
for name, save, path, free, inj in PATHS:
    hold = int(path.split()[0][5:], 16) if path.startswith('hold:') else None
    extra = int(path.split()[0][5:]) if path.startswith('wait:') else 0
    body = ' '.join(path.split()[1:]) if path.startswith(('hold:', 'wait:')) else path.replace('photo:', '')
    keys = (taps('A A A A B') if path.startswith('photo:') else []) + (taps(body) if body.strip() else []) + [0] * free
    r = run(romb, SAVES[save], [0] * extra + keys, inj, hold); org = acc(org, r)
    rows.append([name, 'organic', path, r[0][-1], ' '.join(m for m in r[0] if not m.startswith('1E'))]); print(*rows[-1][:4], flush=True)
for name, m in FORCED:
    rb = bytearray(romb); rb[0x0D03:0x0D06] = romb[0x0D00 + 3 * m:0x0D03 + 3 * m]
    keys = taps('A') + [core_mask(BIT['A'])] * 4 + [0] * 600 + [core_mask(BIT['B'])] * 6 + [0] * 120 + [core_mask(BIT['Select'])] * 6 + [0] * 300
    r = run(bytes(rb), SAVES['kitts'], keys, []); frc = acc(frc, r)
    rows.append([name, 'forced', 'A (mode $%02X in ModeTable slot $01), play, B, Select' % m, r[0][-1], ' '.join(x for x in r[0] if not x.startswith('1E'))]); print(*rows[-1][:4], flush=True)
np.savez_compressed(a.out, exec=org[0], dread=org[1], reader=org[2]); np.savez_compressed(a.forced_out, exec=frc[0], dread=frc[1], reader=frc[2])
with open(a.report, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['path', 'kind', 'keys', 'end', 'modes']); w.writerows(rows)
print('kitty_core_paths: %d organic paths, %d forced; read bytes %d / %d' % (len(PATHS), len(FORCED), int((org[1] > 0).sum()), int((frc[1] > 0).sum())))
