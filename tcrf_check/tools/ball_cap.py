#!/usr/bin/env python3
"""Is there an end to BALL and Space Fever II?  (README 16.18, "Is there an end?")
Three checks, all in my core, none needs BGB:
  1. the saturating BCD add `00:0F9C` that both games use for the score is CALLED directly (A = amount, HL = number, B = bytes; the program counter is set to the routine and
     a return address pointing at a `jr $-2` in unused WRAM is pushed, as in albumb_thresholds.py) with B = 2 (BALL, `$D9E6/7`) and B = 4 (Space Fever II, `$D868-$D86B`) at and
     around the limit; the table of results is written to OUT/add_cases.csv;
  2. BALL played at its top: the score is poked to 9990 and the ROM's own autopilot (the port of `05:7DCC-7E88` in ball_play.py) keeps playing; OUT/ball_cap_timeline.csv lists the
     score changes, and the run goes on 3,000 frames after 9999 to show that the score stays and the game stays in state `20:04`;
  3. the BALL speed table (`05:7B6D`, one word for a score below 5 + 50 words indexed by 10 * hundreds-digit pair (40 from 400 on) + tens digit): OUT/ball_speed_jp.csv.
usage: ball_cap.py OUT          (run from the working root, GBCAM_CORE as for the other core tools)
Needs ball_play.py (same directory) for the root (corpus entry 1976 = BALL, game state 20:04, first frame) and the autopilot."""
import sys, os, json, csv
HERE = os.path.dirname(os.path.abspath(__file__))
OUT = sys.argv[1] if len(sys.argv) > 1 else 'ball_cap_out'; os.makedirs(OUT, exist_ok=True)
head = open(os.path.join(HERE, 'ball_play.py')).read().split("if mode == 'play':")[0]
sys.argv = ['ball_play.py', 'head', OUT]
exec(compile(head, os.path.join(HERE, 'ball_play.py'), 'exec'))     # defines g, lib, u8, bscore, alive, AI, root, ...
STUB = 0xC019                       # unused WRAM: `jr $-2`
ROMBANK_OFF = None
def bcd_le(n, nbytes): return [int('%02d' % ((n // 10 ** (2 * i)) % 100), 16) for i in range(nbytes)]
def rd(addr, nbytes): return sum(u8(addr + i) * 256 ** i for i in range(nbytes))
def bcd_str(addr, nbytes): return ''.join('%02x' % u8(addr + i) for i in reversed(range(nbytes)))
def call_add(snap, a, hl, b):
    """call 00:0F9C with A = a, HL = hl, B = b in the state `snap`; returns the final PC (must be STUB) and carry flag"""
    g.restore(snap); g.poke(STUB, 0x18); g.poke(STUB + 1, 0xFE)
    s = bytearray(g.snapshot()); sp = (s[8] | s[9] << 8) - 2
    g.poke(sp, STUB & 0xFF); g.poke(sp + 1, STUB >> 8)
    s = bytearray(g.snapshot())
    s[0] = a; s[1] = 0; s[2] = b; s[3] = 0; s[6] = hl >> 8; s[7] = hl & 0xFF; s[8] = sp & 0xFF; s[9] = sp >> 8; s[10] = 0x9C; s[11] = 0x0F; s[12] = s[13] = s[14] = 0    # layout of the core: a f b c d e h l sp pc ime ei_delay halted (no interrupt while the stub spins)
    g.restore(bytes(s)); g.run(1)
    e = bytearray(g.snapshot()); return (e[10] | e[11] << 8), bool(e[1] & 0x10)
C = root(); g.run(30); snap0 = g.snapshot()
# ---- 1. the add routine ----
cases = [  # (bytes, start, amount)
    (2, 0, 1), (2, 998, 1), (2, 999, 1), (2, 9998, 1), (2, 9990, 9), (2, 9995, 9), (2, 9999, 1), (2, 9999, 9),
    (4, 0, 1), (4, 9999, 1), (4, 12345678, 1), (4, 99999990, 9), (4, 99999995, 9), (4, 99999998, 1), (4, 99999999, 1), (4, 99999999, 9)]
rows = []
for nb, start, amt in cases:
    snap = snap0
    g.restore(snap0)
    base = 0xD9E6 if nb == 2 else 0xD868                  # the real BALL score; for 4 bytes the Space Fever II address (unused in mode $20)
    for i, v in enumerate(bcd_le(start, nb)): g.poke(base + i, v)
    snap = g.snapshot()
    pc, cy = call_add(snap, int('%02d' % amt, 16), base, nb)
    res = bcd_str(base, nb); ok = (pc == STUB)
    rows.append([nb, '%0*d' % (2 * nb, start), '%02d' % amt, res, int(cy), int(ok)])
    print('B=%d  %0*d + %02d -> %s  (returned %s)' % (nb, 2 * nb, start, amt, res, ok))
with open(os.path.join(OUT, 'add_cases.csv'), 'w', newline='') as f:
    w = csv.writer(f); w.writerow(['bytes', 'before_bcd', 'amount_bcd', 'after_bcd', 'carry_out', 'returned_to_stub']); w.writerows(rows)
# ---- 2. BALL at the top ----
C = root(); ai = AI(); g.poke(0xD9E6, 0x90); g.poke(0xD9E7, 0x99)
f = 0; hit = None; tl = [[0, bscore(), '%02X:%02X' % lib.cur()]]
while alive() and f < 200000:
    k = ai.key(); g.keys(k); g.run(1); f += 1; s = bscore()
    if s != tl[-1][1]: tl.append([f, s, '%02X:%02X' % lib.cur()])
    if s == 9999 and hit is None: hit = f
    if hit is not None and f - hit > 3000: break
tl.append([f, bscore(), '%02X:%02X' % lib.cur()])
with open(os.path.join(OUT, 'ball_cap_timeline.csv'), 'w', newline='') as fo:
    w = csv.writer(fo); w.writerow(['frame', 'score', 'state']); w.writerows(tl)
print('BALL from 9990: score %d after %d frames, alive %s, state %s, 9999 reached at frame %s' % (bscore(), f, alive(), '%02X:%02X' % lib.cur(), hit))
# ---- 3. the speed table ----
rom = open(lib.ROM, 'rb').read(); base = 5 * 0x4000 + 0x7B6D - 0x4000
words = [rom[base + 2 * i] | rom[base + 2 * i + 1] << 8 for i in range(51)]
with open(os.path.join(OUT, 'ball_speed_jp.csv'), 'w', newline='') as fo:
    w = csv.writer(fo); w.writerow(['index', 'address', 'word', 'frames_per_step', 'used_for'])
    w.writerow(['below5', '05:7B6D', '%04X' % words[0], '%.1f' % (65536 / words[0]), 'score below 5'])
    for i in range(50):
        use = 'hundreds %d, tens %d' % (i // 10, i % 10) if i < 40 else 'score from 400 on, tens %d (any hundreds)' % (i - 40)
        w.writerow([i, '05:%04X' % (0x7B6F + 2 * i), '%04X' % words[i + 1], '%.1f' % (65536 / words[i + 1]), use])
json.dump(dict(add_cases=rows, ball_from_9990=dict(frames=f, final_score=bscore(), alive=alive(), state='%02X:%02X' % lib.cur(), frame_9999=hit)),
          open(os.path.join(OUT, 'score_caps.json'), 'w'), indent=1)
