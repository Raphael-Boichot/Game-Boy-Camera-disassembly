#!/usr/bin/env python3
"""Hello Kitty L6 (2026-11-22): rare outcomes that no run had shown, reached in the core by key presses only (two doubts of
disasm/sym_unconclusive_kitty.md: 07:6504 and 03:63DC).

  tools/kitty_rare_runs.py KITTY.gb [--out roms/hello_kitty/trace/cov_kitty_rare.npz] [--report roms/hello_kitty/trace/rare_runs_kitty.csv]

A. The three texts of the scratch-card host in Mode0E_State00_Tbl668C_Entry6504.

The code (C): the host of mode $0E state $01 (the scratch card) reads a script of 4-byte records at 07:66F4 (text number into $D946,
next state, $FF, next record) and its texts through the pointer table 07:66A6 (= Mode0E_State00_Tbl668C + $1A: words 13-25 of that
table). Mode0E_State00_Tbl668C_Entry6504 (07:6504-655B, 88 bytes) holds three of those texts, words 22-24:
  * text 9 (07:6504, word 22, record $24): after a lost card (Mode10_State03: the two marked spots differ -> Mode10_State05 -> record
    $20: text 8, then the A prompt, state $1E), A or B calls Rng_Next: 7 times in 8 the script goes to record $18 (text 6, the
    play-again question), once in 8 (Rng_Next & 7 = 0, 07:6BB2) to record $24;
  * text 10 (07:6520, word 23, record $28): "yes" to the card's price with fewer than 10 Kitts (KittHost_PayScratch: Kitts_CheckAfford
    fails -> record $0C: text 3, then A -> record $28);
  * text 11 (07:653D, word 24, record $2C): a won card whose matching symbol is $13 (Mode10_State03_Tbl623A: prize index 3, $D940 = 1,
    Mode10_State04 -> record $2C); Scratch_DealSpots draws the symbols from 07:5F41 (no $13) until a name card is made ($DADA, set
    by Mode0B_State01 at 06:51A2), then from 07:5F21 (one $13 in 16).
Rng_Next takes the next byte of a 55-byte table (refilled when used up): an outcome depends on how many draws came before, so the runs
search key taps (random, seeded) and stop at the first success:
  1. rare: the key history of trace/modes_seen_kitty.csv that reaches mode $0E state $1D (run2: the core-formatted save, Kitts
     999,999, no printer) from a cold boot, then up to 400 taps (A three times in eight, B, Down, Up, Right, Left; held 4 frames, 10,
     20 or 40 free; seed 1) while the game stays in modes $0E / $10 / $1E, each trial from a new cold boot, until 07:6BBE runs;
  2. no_kitts: the same save with 0 Kitts; taps (8 frames held, 90 free, after a 703-frame boot) A, Up, A (the Play menu), A (the
     scratch card), then A and idle slots: the host asks for 10 Kitts, A = yes;
  3. name_card then prize3: from the formatted save (999,999 Kitts), A, Start, A (the name card editor, 0B:10), then random taps
     (seed 2; A three times in nine, B, the four directions, Start; 20, 40 or 90 free) until 06:5199 runs (the card is made), then B
     ten times; the SRAM the game wrote is the start save of the scratch trials: A, Up, A, A (the host), then up to 600 random taps
     (seed 3; A four times in nine) per cold boot until 07:653D is read.
B. The print game's Kitty frame OamList_03_63DC_Obj_DrawSprite (32 bytes). A in the fruit game of a print (mode $06 state $24) gives
Kitty the script 02:7686 (PrintGame_ObjKitty): a jump, then ObjCmd_JumpRandom picks one of five loops; the loop 02:76CF shows the
frame 03:637C for $70 frames, then 03:63DC. With the core's printer model (the replies of the real traces: 12 inquiries answered
busy, $06, during the first print) state $24 lasts 71 frames, less than the jump and the $70 frames; mode $1B (never entered) also
draws it. The run: the album print path of tools/kitty_core_paths.py (photo, album, print icon, Right, A, Start; printer model 1)
with inquiries 29-68 answered busy ($06, injected as the printer-error paths of that tool do: 40 more inquiries of printing, about 4
seconds; a real printer stays busy at least 9 seconds for a regular image, 9 printer packets: owner, 2026-11-22), then
in state $24 taps drawn at random (seed 4; A twice in six, B, Left, Right, idle; held 2, 8 or 20 frames, 2, 10, 30 or 130 free),
each trial from a cold boot, until 03:63DC is read.
C. Message 0 of the message screen (mode $14: text 06:420D, the strip of tiles at 1C:61C0, shared with message 8): copying a photo in the
album when it holds 30 (05:7228 / 05:758D). The run: 30 photos taken by keys (A, A, then A A thirty times, B three times), the SRAM
written is the start save; A, Down, A (the album), then random taps (seed 5; A three times in nine, B, the directions, Select).
The core is deterministic over a whole run of this tool (the same trials and taps succeed every time); a single trial replayed alone
in another process may drift (as noted in tools/kitty_modes_seen.py), so the tool is the replay. Every trial is organic (no poke); the
coverage of all of them is written as the other trace/cov_kitty_*.npz; the report gives, per part, the trial, the taps, the modes and
the bytes of each text read.
"""
import sys, os, csv, random, argparse, textwrap
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); KD = os.path.join(REPO, 'roms', 'hello_kitty')
sys.path.insert(0, os.path.join(REPO, 'coverage', 'src')); sys.path.insert(0, HERE); import gbcov as G, core_screen
from PIL import Image, ImageDraw
ap = argparse.ArgumentParser(); ap.add_argument('rom')
ap.add_argument('--shots', default=os.path.join(KD, 'screens', 'rare_runs_kitty.png'))
ap.add_argument('--out', default=os.path.join(KD, 'trace', 'cov_kitty_rare.npz')); ap.add_argument('--report', default=os.path.join(KD, 'trace', 'rare_runs_kitty.csv'))
a = ap.parse_args()
def fl(b, ad): return b * 0x4000 + ad - 0x4000
TEXTS = [(9, fl(7, 0x6504), 28), (10, fl(7, 0x6520), 29), (11, fl(7, 0x653D), 31)]
BIT = dict(A=1, B=2, Select=4, Start=8, Right=0x10, Left=0x20, Up=0x40, Down=0x80)
def cm(b): return ((b << 4) | (b >> 4)) & 0xFF                    # the core's key byte: buttons in the high nibble
def tap(k, w=90, hold=8):
    if k != '-': G.keys(cm(BIT[k]))
    G.run(hold); G.keys(0); G.run(w)
def ms(): return '%02X:%02X' % (G.peek(0xFF8D), G.peek(0xFF8E))
def boot(save, n=703, printer=0):
    G.load_rom(a.rom); G.reset(bytes(save)); G.L.gb_printer_model(1); G.L.gb_attach_printer(printer); G.L.gb_printer_inject_clear()
    if printer: G.L.gb_printer_inject(15, 29, 0x06, 40)
    G.run(n)
G.load_rom(a.rom); G.reset(bytes(0x20000)); G.run(600); FMT = bytearray(bytes(G.sram()))
KITTS = bytes(FMT[:0x100A]) + b'\x99\x99\x99' + bytes(FMT[0x100D:]); NOKITTS = bytes(FMT[:0x100A]) + b'\x00\x00\x00' + bytes(FMT[0x100D:])
G.L.gb_cov_clear()
def search(seed, ntrial, ntap, start, keys, waits, hold, done, stay):
    rnd = random.Random(seed)
    for trial in range(ntrial):
        start(); seq = []; modes = []
        for t in range(ntap):
            k = rnd.choice(keys); w = rnd.choice(waits); seq.append('%s/%d' % (k, w)); tap(k, w, hold)
            m = ms()
            if m[:2] != '1E' and (not modes or modes[-1] != m): modes.append(m)
            if done(): return trial, seq, modes
            if G.peek(0xFF8D) not in stay: break
    sys.exit('kitty_rare_runs: no success in %d trials (seed %d)' % (ntrial, seed))
rows = []; SHOTS = []
def shot(label, text_no=None, n=0):          # the screen once the text is written (the text step leaves state $03), or n frames on
    if text_no is not None:
        for _ in range(400):
            if G.peek(0xD946) == text_no and G.peek(0xFF8E) != 0x03 and G.peek(0xFF8D) == 0x0E: break
            G.run(1)
    G.run(n); st = G.snapshot()
    if st[core_screen.IO + 0x41] & 0x40 and st[core_screen.IO + 0x80] & 0x02:      # a LYC interrupt is on: the screen may switch LCDC mid-frame
        sys.exit('kitty_rare_runs: %s: a LYC interrupt is active; the plain core keeps no per-line registers (tools/core_screen.py)' % label)
    SHOTS.append((label, core_screen.render(st)))
def read(i): return int((G.cov_dread()[TEXTS[i][1]:TEXTS[i][1] + TEXTS[i][2]] > 0).sum())
# 1. rare: text 9
row = next(r for r in csv.DictReader(open(os.path.join(KD, 'trace', 'modes_seen_kitty.csv'))) if r['mode'] == '0E' and r['state'] == '1D')
H = bytes.fromhex(row['keys'])
def start1():
    boot(KITTS, 250)
    for j in range(250, len(H)): G.keys(H[j]); G.run(1)
tr, seq, modes = search(1, 300, 400, start1, ['A', 'A', 'A', 'B', 'Down', 'Up', 'Right', 'Left'], (10, 20, 40), 4,
                        lambda: G.cov_exec()[fl(7, 0x6BBE)] > 0, (0x0E, 0x10, 0x1E))
shot('text 9 (07:6504): after a lost card, 1 in 8', 9); G.run(300); rows.append(['rare', 'text 9 (07:6504)', 'formatted, Kitts 999,999', tr, 'modes_seen 0E:1D (%d frames), then ' % len(H) + ' '.join(seq), ' '.join(modes), '%d of 28' % read(0)])
# 2. no_kitts: text 10
boot(NOKITTS); modes = []
P2 = 'A Up A A - A - A - A - A - A'
for k in P2.split():
    tap(k); m = ms()
    if m[:2] != '1E' and (not modes or modes[-1] != m): modes.append(m)
    if G.cov_dread()[TEXTS[1][1]] and len(SHOTS) == 1: shot('text 10 (07:6520): yes to a card with 0 Kitts', 10)
rows.append(['no_kitts', 'text 10 (07:6520)', 'formatted, Kitts 0', 0, P2, ' '.join(modes), '%d of 29' % read(1)])
# 3. the name card, then a card won with symbol $13: text 11
def start3a():
    boot(KITTS)
    for k in 'A Start A'.split(): tap(k)
tr, seq, modes = search(2, 50, 300, start3a, ['A', 'A', 'A', 'B', 'Down', 'Up', 'Right', 'Left', 'Start'], (20, 40, 90), 8,
                        lambda: G.cov_exec()[fl(6, 0x5199)] > 0, tuple(range(0x20)))
for _ in range(10): tap('B', 60)
CARD = bytes(G.sram()); made = G.peek(0xDADA)
rows.append(['name_card', 'the name card made ($DADA = $%02X)' % made, 'formatted, Kitts 999,999', tr, 'A Start A, then ' + ' '.join(seq) + ', then B x10', ' '.join(modes), ''])
if made == 0: sys.exit('kitty_rare_runs: the name card flag is not set')
def start3b():
    boot(CARD)
    for k in 'A Up A A'.split(): tap(k)
tr, seq, modes = search(3, 400, 600, start3b, ['A', 'A', 'A', 'A', 'B', 'Down', 'Up', 'Right', 'Left'], (10, 20, 40), 8,
                        lambda: G.cov_dread()[TEXTS[2][1]] > 0, (0x0E, 0x10, 0x1E))
shot('text 11 (07:653D): a card won with symbol $13', 11); G.run(300); rows.append(['prize3', 'text 11 (07:653D)', 'the SRAM after name_card', tr, 'A Up A A, then ' + ' '.join(seq), ' '.join(modes), '%d of 31' % read(2)])
# C. message 0 (06:420D, Mode14 text 0; strip tiles 1C:61C0): the album full when a photo is copied (05:7228 / 05:758D, $D932 = 30)
boot(KITTS); tap('A'); tap('A')
for _ in range(30): tap('A'); tap('A')                           # 30 photos taken and kept: the album is full
for _ in range(3): tap('B')
FULL = bytes(G.sram()); n30 = G.peek(0xD932)
def start5():
    boot(FULL)
    for k in 'A Down A'.split(): tap(k)
tr, seq, modes = search(5, 200, 150, start5, ['A', 'A', 'A', 'B', 'Down', 'Up', 'Right', 'Left', 'Select'], (20, 40, 90), 8,
                        lambda: G.cov_dread()[fl(6, 0x420D)] > 0, (0x03, 0x05, 0x14, 0x1E))
G.run(200)
rows.append(['message0', 'message 0 (06:420D, tiles 1C:61C0)', 'the SRAM after 30 photos taken (A, A, then A A x30, B x3; $D932 = %d)' % n30, tr,
             'A Down A (the album), then ' + ' '.join(seq), ' '.join(modes), '%d of $280 strip bytes' % int((G.cov_dread()[fl(0x1C, 0x61C0):fl(0x1C, 0x6440)] > 0).sum())])
# B. the print game: Kitty's frame 03:63DC
O63 = fl(3, 0x63DC)
def start4():
    boot(KITTS, 700, printer=1)
    for k in 'A A A A B - - Down A Down Down A Right A Start'.split(): tap(k)
    t = 0
    while G.peek(0xFF8E) != 0x24 and t < 3000: G.run(1); t += 1
rnd4 = random.Random(4)
for tr in range(300):
    start4(); seq = []
    while G.peek(0xFF8E) == 0x24 and len(seq) < 200:
        k = rnd4.choice(['A', 'A', 'B', 'Left', 'Right', '-']); w = rnd4.choice((2, 10, 30, 130)); h = rnd4.choice((2, 8, 20))
        seq.append('%s/%d/%d' % (k, h, w)); tap(k, w, h)
        if G.cov_dread()[O63]: break
    if G.cov_dread()[O63]: shot('the frame 03:63DC (Kitty) in the print game', None, 2); break
else: sys.exit('kitty_rare_runs: 03:63DC not read in 300 trials')
G.run(300)
rows.append(['print_game', 'Kitty frame 03:63DC', 'formatted, Kitts 999,999; printer model 1, inquiries 29-68 busy', tr,
             'photo, album print (A A A A B - - Down A Down Down A Right A Start), in state 06:24: ' + ' '.join(seq), '06:24',
             '%d of 32' % int((G.cov_dread()[O63:O63 + 32] > 0).sum())])
W = 160 * 2 + 16; sheet = Image.new('L', (W * len(SHOTS), 288 + 40), 255); dr = ImageDraw.Draw(sheet)
for i, (lb, im) in enumerate(SHOTS):
    sheet.paste(im.resize((320, 288), Image.NEAREST), (i * W + 8, 36))
    for j, part in enumerate(textwrap.wrap(lb, 46)[:2]): dr.text((i * W + 8, 4 + 14 * j), part, fill=0)
os.makedirs(os.path.dirname(a.shots), exist_ok=True); sheet.save(a.shots, optimize=True)
np.savez_compressed(a.out, ex=np.array(G.cov_exec()), dr=np.array(G.cov_dread()), rdr=np.array(G.cov_reader()))
with open(a.report, 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['part', 'goal', 'save', 'trial', 'taps', 'modes', 'text_bytes_read']); w.writerows(rows)
for r in rows: print('%-10s %-36s trial %-4s %s' % (r[0], r[1], r[3], r[6]))
print('kitty_rare_runs: 07:6504-655B: %d of 88 bytes read -> %s' % (int((G.cov_dread()[fl(7, 0x6504):fl(7, 0x655C)] > 0).sum()), os.path.relpath(a.out, REPO)))
