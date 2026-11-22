#!/usr/bin/env python3
"""Hello Kitty L6 (2026-11-22): photo exchanges between two units run in two instances of the link core, joined by a modelled cable.

  tools/kitty_core_link.py KITTY.gb [--out roms/hello_kitty/trace/cov_kitty_link.npz] [--report roms/hello_kitty/trace/link_core_kitty.csv]

Why: the exchange in which the RECEIVING unit leads (it presses A first on "もらう") has the leader browse the giver's album page by page
(Mode08_State01 -> Exchange_RequestPage: a command with bit 7, then 8 pages, $800 bytes, within a countdown of $B4 frames). BGB's network
link is too slow for it: in a linked BGB run (2026-11-22) 1,521 of the 2,048 bytes went through before the countdown ran out and both
units showed the communication error 14:01. On real hardware the turn protocol (each byte clocked by the unit whose turn it is, after
an 18-tick timer at 65,536 Hz: 1,152 cycles, then 4,096 cycles of transfer) moves 2,048 bytes in about 128 frames.
How: coverage/src/gbcov8.c (the core with the link-cable partner interface, the one of docs §14) is built twice under two names in a
temporary folder (two copies of its globals), one per unit; this host runs them in turn, 96 cycles at a time, the one behind first,
and joins their transfers: a unit that starts a transfer with its own clock (SC = $81) gets the partner's SB, and the partner, if armed
with the external clock (SC = $80), gets the byte, with the clock unit's remaining count, so both serial interrupts fall on the same
cycle; a partner that arms later during the transfer gets it then; two clock units swap their bytes.
Saves: both units start from the core-formatted SRAM with 999,999 Kitts (as tools/kitty_bgb_link.py); no owner save is used.
Keys: the taps of the BGB tools (8 frames held, 90 free; '-' = an idle tap; after a 700-frame boot); paths checked in the core:
giver 'A A A A B Start Up A' = take a photo, keep it, the option menu (Start), Up, A: the exchange screen 07:02 with "あげる" (give)
selected; receiver 'A Start Up A Right A' = the same screen, Right ("もらう"), A (the first A on the screen makes its unit the leader).
Scenarios (each from power-on): recv_leads (the receiver leads; the giver confirms its photo with A), recv_leads_giver_B (the giver
refuses with B on the photo shown), full_album_receiver (the receiver's
save holds 30 photos taken by keys in the plain core: A, A, A A thirty times, B three times; the giver leads), cable_pulled (the receiver leads; the cable is taken out when it reaches the photo train,
08:01, during the first page request: no byte goes through from then on), giver_leads (the receiver waits on "もらう" without pressing A and the giver leads, as the BGB
exchange of 2026-11-08: the control).
Writes the coverage of all scenarios (ex / dr / rdr, as the other trace/cov_kitty_*.npz: organic, no poke) and a report: scenario,
unit, end mode:state, the mode:state changes in order (fades $1E left out), bytes moved, the nonzero bytes of SRAM $2000-$2FFF (the
first photo slot), and the checked points (executed / read).
"""
import sys, os, csv, argparse, textwrap, tempfile, subprocess, shutil, ctypes as C
import numpy as np
from PIL import Image, ImageDraw
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); KD = os.path.join(REPO, 'roms', 'hello_kitty')
ap = argparse.ArgumentParser(); ap.add_argument('rom')
ap.add_argument('--shots', default=os.path.join(KD, 'screens', 'link_core_kitty.png'))
ap.add_argument('--out', default=os.path.join(KD, 'trace', 'cov_kitty_link.npz')); ap.add_argument('--report', default=os.path.join(KD, 'trace', 'link_core_kitty.csv'))
a = ap.parse_args()
FRAME, SL, N = 70224, 96, 1 << 20
BIT = dict(A=1, B=2, Select=4, Start=8, Right=0x10, Left=0x20, Up=0x40, Down=0x80)
def core_mask(b): return ((b << 4) | (b >> 4)) & 0xFF          # the core's key byte has the nibbles swapped (tools/kitty_core_paths.py)
TMP = tempfile.mkdtemp(prefix='kitty_link_')
LIBS = []
for n in ('a', 'b'):
    p = os.path.join(TMP, 'gbcov8_%s.so' % n)
    subprocess.check_call(['cc', '-O2', '-shared', '-fPIC', '-o', p, os.path.join(REPO, 'coverage', 'src', 'gbcov8.c')]); LIBS.append(C.CDLL(p))
for L in LIBS:
    L.gb_load_rom.argtypes = [C.c_char_p]; L.gb_reset.argtypes = [C.c_char_p, C.c_size_t]
    L.gb_set_keys.argtypes = [C.c_uint8]; L.gb_peek.argtypes = [C.c_uint16]; L.gb_peek.restype = C.c_uint8
    L.gb_run_link.argtypes = [C.c_int]; L.gb_run_link.restype = C.c_int64
    L.gb_link_out.restype = C.c_uint8; L.gb_link_cd.restype = C.c_int32; L.gb_link_sc.restype = C.c_uint8; L.gb_link_sb.restype = C.c_uint8
    L.gb_link_set_rx.argtypes = [C.c_uint8]; L.gb_link_deliver.argtypes = [C.c_uint8, C.c_int32]
    L.gb_link_enable.argtypes = [C.c_int]; L.gb_set_organic.argtypes = [C.c_int]; L.gb_state_size.restype = C.c_size_t; L.gb_save.argtypes = [C.c_void_p]
    for f in ('gb_cov_exec_ptr', 'gb_cov_dread_ptr', 'gb_cov_reader_ptr', 'gb_sram_ptr', 'gb_line_regs_ptr'): getattr(L, f).restype = C.c_void_p
    assert L.gb_load_rom(a.rom.encode()) > 0
def arr(L, f, n, t=C.c_uint8): return np.ctypeslib.as_array(C.cast(getattr(L, f)(), C.POINTER(t)), shape=(n,))
# the start save, made in the plain core (as tools/kitty_bgb_link.py)
sys.path.insert(0, os.path.join(REPO, 'coverage', 'src')); sys.path.insert(0, HERE); import gbcov as G, core_screen
def state(L): b = (C.c_uint8 * L.gb_state_size())(); L.gb_save(b); return bytes(b)
SHOTS = []
SHOT_AT = {('recv_leads', 'giver', (0x09, 0x0D)): 'giver, 09:0D: the photo asked for, from Mode09_State0C (map 2C:78D0)',
           ('recv_leads', 'receiver', (0x08, 0x02)): 'receiver (leader), 08:02: the giver\'s album page on the photo train'}
G.load_rom(a.rom); G.reset(bytes(0x20000)); G.run(600); SAV = bytearray(bytes(G.sram())); SAV[0x100A:0x100D] = b'\x99\x99\x99'
def tapc(k, w=90): G.keys(core_mask(BIT[k])); G.run(8); G.keys(0); G.run(w)
G.reset(bytes(SAV)); G.run(703); tapc('A'); tapc('A')              # a full album: 30 photos taken and kept by keys, B to the title
for _ in range(30): tapc('A'); tapc('A')
for _ in range(3): tapc('B')
FULL = bytes(G.sram())
def demo(path, boot=700):
    k = [0] * (3 + boot)
    for x in path.split(): k += ([BIT[x]] * 8 if x != '-' else [0] * 8) + [0] * 90
    return k
GIVE, TAKE = 'A A A A B Start Up A', 'A Start Up A Right A'
def idle(n): return ' -' * n
SCEN = [  # name, giver taps, receiver taps, free frames after the longer path
    ('recv_leads', GIVE + idle(24) + ' A - - A - - A - - A', idle(12) + ' ' + TAKE + idle(10) + ' A - - - A - - - A - - - A - - - A - - - A - - - A', 1500),
    ('recv_leads_giver_B', GIVE + idle(24) + ' B - - B - - B', idle(12) + ' ' + TAKE + idle(10) + ' A - - - A - - - A - - - A', 1500),
    ('cable_pulled', GIVE + idle(24) + ' A - - A', idle(12) + ' ' + TAKE + idle(10) + ' A - - - A', 1500, ('receiver', (0x08, 0x01))),
    ('full_album_receiver', GIVE + idle(8) + ' A - A - A - A - A - A - A - A', 'A Start Up A Right' + idle(30) + ' A - A - A - A', 1500, None, FULL),
    ('giver_leads', GIVE + idle(8) + ' A - A - A - A - A - A - A - A', 'A Start Up A Right' + idle(30) + ' A - A - A - A', 2500),
]
def fl(b, ad): return ad if b == 0 else b * 0x4000 + ad - 0x4000
CHK = [('x', fl(6, 0x6AD4), 1, 'Mode09_State0C'), ('x', fl(6, 0x5FF8), 1, 'KeyPrompt_LoadSoundsB'), ('r', fl(6, 0x5F55), 42, 'KeyPrompt_LoadSounds_Tbl5F7F_Entry5F55'),
       ('r', fl(0x2C, 0x7AB0), 1, 'Map_2C_7AB0_Mode09_ExchangeCommunicating_State0C'), ('x', fl(6, 0x691F), 1, 'Mode09_State06'), ('x', fl(6, 0x6BF8), 1, 'Mode09_State0F')]
EX = np.zeros(N, np.uint8); DR = np.zeros(N, np.uint8); RDR = np.zeros(N, np.uint32); rows = []
for sc in SCEN:
    name, pg, pt, after = sc[:4]; cut = sc[4] if len(sc) > 4 else None; pulled = False; savr = sc[5] if len(sc) > 5 else SAV
    U = []
    for L, role, path in ((LIBS[0], 'giver', pg), (LIBS[1], 'receiver', pt)):
        sv = SAV if role == 'giver' else savr; L.gb_cov_clear(); L.gb_reset(bytes(sv), len(sv)); L.gb_set_organic(1); L.gb_link_enable(1)
        U.append(dict(L=L, role=role, path=path, t=0, keys=demo(path), modes=[], pend=None))
    end = (max(len(u['keys']) for u in U) + after) * FRAME; moved = 0
    while min(u['t'] for u in U) < end:
        i = 0 if U[0]['t'] <= U[1]['t'] else 1; u, p = U[i], U[1 - i]; L, PL = u['L'], p['L']
        f = u['t'] // FRAME; L.gb_set_keys(core_mask(u['keys'][f]) if f < len(u['keys']) else 0)
        r = L.gb_run_link(SL); u['t'] += r >> 2; ev = r & 3
        m = (L.gb_peek(0xFF8D), L.gb_peek(0xFF8E))
        if m[0] != 0x1E and (not u['modes'] or u['modes'][-1] != m):
            u['modes'].append(m); lb = SHOT_AT.get((name, u['role'], m))
            if cut and (u['role'], m) == cut: pulled = True
            if m == (0x14, 0x01): lb = 'message %d (14:01), %s, %s' % (L.gb_peek(0xD8EC), u['role'], name)
            if lb and not any(x[0] == lb or (lb.startswith('message') and x[0].split(' (')[0] == lb.split(' (')[0]) for x in SHOTS): u['shot'] = (u['t'] + 60 * FRAME, lb)
        if u.get('shot') and u['t'] >= u['shot'][0]: SHOTS.append((u['shot'][1], core_screen.render(state(L), bytes(arr(L, 'gb_line_regs_ptr', 154 * 6))))); u['shot'] = None
        if pulled: ev = 0                                    # the cable is out: no byte goes through (a clock unit reads $FF)
        if ev & 1:                                           # u clocks a byte
            b = L.gb_link_out(); psc = PL.gb_link_sc()
            if psc & 0x81 == 0x80: L.gb_link_set_rx(PL.gb_link_sb()); PL.gb_link_deliver(b, L.gb_link_cd()); moved += 1
            elif psc & 0x81 == 0x81 and PL.gb_link_cd() > 0: L.gb_link_set_rx(PL.gb_link_out()); PL.gb_link_set_rx(b); moved += 1
            else: u['pend'] = b
        if ev & 2 and p['pend'] is not None and PL.gb_link_cd() > 0:    # u arms during p's transfer
            PL.gb_link_set_rx(L.gb_link_sb()); L.gb_link_deliver(p['pend'], PL.gb_link_cd()); p['pend'] = None; moved += 1
        if u['pend'] is not None and L.gb_link_cd() <= 0: u['pend'] = None
    for u in U:
        L = u['L']; ex, dr, rd = arr(L, 'gb_cov_exec_ptr', N), arr(L, 'gb_cov_dread_ptr', N), arr(L, 'gb_cov_reader_ptr', N, C.c_uint32)
        m = (RDR == 0) & (rd > 0); RDR[m] = rd[m]; EX[:] = np.maximum(EX, ex); DR[:] = np.maximum(DR, dr)
        sram = arr(L, 'gb_sram_ptr', 0x20000)
        chk = ' '.join('%s %s %d/%d' % (k, nm, int(((ex if k == 'x' else dr)[o:o + n] > 0).sum()), n) for k, o, n, nm in CHK)
        rows.append([name, u['role'], u['path'], '%02X:%02X' % u['modes'][-1], ' '.join('%02X:%02X' % x for x in u['modes']), moved, int((sram[0x2000:0x3000] != 0).sum()), chk])
        print('%-20s %-8s end %s  bytes %6d  slot1 %4d  %s' % (name, u['role'], rows[-1][3], moved, rows[-1][6], chk))
shutil.rmtree(TMP, ignore_errors=True)
W = 336; PER = 4; sheet = Image.new('L', (W * min(PER, len(SHOTS)), 328 * ((len(SHOTS) + PER - 1) // PER)), 255); dr = ImageDraw.Draw(sheet)
for i, (lb, im) in enumerate(SHOTS):
    x0, y0 = (i % PER) * W, (i // PER) * 328
    sheet.paste(im.resize((320, 288), Image.NEAREST), (x0 + 8, y0 + 36))
    for j, part in enumerate(textwrap.wrap(lb, 48)[:2]): dr.text((x0 + 8, y0 + 4 + 14 * j), part, fill=0)
os.makedirs(os.path.dirname(a.shots), exist_ok=True); sheet.save(a.shots, optimize=True)
np.savez_compressed(a.out, ex=EX, dr=DR, rdr=RDR)
with open(a.report, 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f, lineterminator='\n')
    w.writerow(['scenario', 'unit', 'taps', 'end', 'modes', 'bytes_moved', 'sram_slot1_nonzero', 'checked']); w.writerows(rows)
print('kitty_core_link: %d scenarios -> %s, %s' % (len(SCEN), os.path.relpath(a.out, REPO), os.path.relpath(a.report, REPO)))
