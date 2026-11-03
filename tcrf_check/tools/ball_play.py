#!/usr/bin/env python3
"""BALL (mode $20, the juggling game "顔ボル") played with the joypad only up to a score above 1,000 (README 16.18).
The player's face stands at one of three places `$D9D7` = 0 / 1 / 2 (Left or B = one place to the left, Right or A = one place to the right, one step per key press); three balls fly between the places
(phase counters `$D9DB`, `$D9DC`, `$D9DD`, one of them advances at each tick, `$D9E5` = whose turn); the face catches a ball when it stands at the right place at the right phase (+1 point, `$D9E6/7`, packed BCD);
a ball that is not caught ends the game (state 6).  The ROM contains its own autopilot for this game: state 5 (`05:7859`, a demo) calls `05:7DCC-7E88`, which clears the key variable `$FFA2` and writes a Right (`$10`)
or Left (`$20`) press from the phases of the balls (at most one decision every other frame, a one-frame pause after a decision).  `AI` below is a Python port of that routine that presses the same keys in the real
game (state 4).  (The demo itself, state 5 entered by a poke of `$D5CF`, ran for 115,000 frames without a miss and reached 2,045 points: the autopilot never loses.)
usage: ball_play.py play OUTDIR [GOAL]    plays from the first frame of the game with the autopilot port until GOAL points (decimal, default 1100); writes OUTDIR/ball_keys.json (RLE key log)
       ball_play.py replay OUTDIR         replays OUTDIR/ball_keys.json: score timeline (100 / 300 / 500 / 700 / 1000), the end of the game (the ball is let fall), the best score in the save
       ball_play.py bgb OUTDIR            the same key log in the real BGB (end state, score, best score)
Root: corpus entry 1976 (save `_ff`) = BALL, game state `20:04`, first frame of the game.  Writes OUTDIR/ball_keys.json, ball_timeline.csv, exec_ranges.csv, ball_play.json, ball_after.sav, bgb_ball.json.
Run from the working root (GBCAM_CORE as for the other core tools)."""
import sys, os, json, csv, time
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE); ROOT = os.path.dirname(HERE)
mode, out = sys.argv[1], sys.argv[2]; os.makedirs(out, exist_ok=True)
ENTRY = 1976
CORE = [(1, 'Right'), (2, 'Left'), (4, 'Up'), (8, 'Down'), (16, 'A'), (32, 'B'), (64, 'Select'), (128, 'Start')]
def names(k): return '+'.join(n for m, n in CORE if k & m) or '-'
import lib; from lib import g
def u8(a): return g.peek(a)
def bscore(): return int('%04x' % (u8(0xD9E6) | u8(0xD9E7) << 8))
def alive(): return lib.cur()[1] in (4, 5)
def keyfor(pos, target, f):
    if pos == target or f % 2 == 1: return 0
    return g.RIGHT if target > pos else g.LEFT
def rollout(target, H):
    s0 = bscore()
    for f in range(H):
        g.keys(keyfor(u8(0xD9D7), target, f)); g.run(1)
        if not alive(): return -1000
    return bscore() - s0
def rle(keys):
    r = []
    for k in keys:
        if r and r[-1][0] == k: r[-1][1] += 1
        else: r.append([k, 1])
    return r
def unrle(r): return [k for k, n in r for _ in range(n)]
def root():
    C = lib.Corpus(os.path.join(ROOT, 'unlock_runs', 'f1_organic', 'corpus.jsonl')); g.set_organic(1); C.replay(ENTRY); return C
class AI:
    """port of 05:7DCC-7E88: returns the key (Left / Right / none) the demo autopilot would press in this frame"""
    def __init__(self): self.cd = 0
    def key(self):
        if self.cd: self.cd -= 1; return 0
        if (u8(0xFFC8) + 1) & 1: return 0                       # the routine acts on even frames of the frame counter $FFC8 (the counter is incremented in the VBlank before the main loop)
        turn = u8(0xD9E5); pos = u8(0xD9D7); R = g.RIGHT; L = g.LEFT
        def done(): self.cd = 1; return 0                       # 05:7E83: pause of one call
        if turn == 0:                                           # ball A: launched at place 2 (phase 0), lands at place 0 (phase 7)
            a = u8(0xD9DB)
            if a == 1:
                if u8(0xD9DE) != 0xFF: return 0
                return done() if pos == 2 else R
            if a != 6 or u8(0xD9DE) != 1: return 0
            return done() if pos == 0 else L
        if turn == 1:                                           # ball B: place 1 (phase 0 and 9)
            a = u8(0xD9DC)
            if a not in (1, 8) or u8(0xD9DF) != (0xFF if a == 1 else 1): return 0
            if pos == 0: return R
            return done() if pos != 2 else L
        a = u8(0xD9DD)                                          # ball C: launched at place 0 (phase 0), lands at place 2 (phase 11)
        if a == 1:
            if u8(0xD9E0) != 0xFF: return 0
            return done() if pos == 0 else L
        if a != 0xA or u8(0xD9E0) != 1: return 0
        return done() if pos == 2 else R
if mode == 'play':
    goal = int(sys.argv[3]) if len(sys.argv) > 3 else 1100
    root(); ai = AI(); keys = []; t0 = time.time()
    while alive() and bscore() < goal and len(keys) < 400000:
        k = ai.key(); g.keys(k); g.run(1); keys.append(k)
    print('score', bscore(), 'after', len(keys), 'frames, alive', alive(), '%.0f s' % (time.time() - t0))
    json.dump(dict(root_entry=ENTRY, frames=len(keys), keys=rle(keys)), open(os.path.join(out, 'ball_keys.json'), 'w')); sys.exit()
K = json.load(open(os.path.join(out, 'ball_keys.json'))); KEYS = unrle(K['keys'])
if mode == 'replay':
    C = root(); ex0 = lib.exec_baseline(); events = []
    def ev(f, what): events.append([f, what, bscore(), '%04x' % (u8(0xDAA4) | u8(0xDAA5) << 8), '%02X:%02X' % lib.cur()]); print(f, what, events[-1][2:], flush=True)
    thr = [100, 300, 500, 700, 1000]; ti = 0; last_speed = None
    for f, k in enumerate(KEYS):
        g.keys(k); g.run(1)
        if ti < len(thr) and bscore() >= thr[ti]: ev(f + 1, 'score reaches %d' % thr[ti]); ti += 1
    ev(len(KEYS), 'end of the key log, game alive: %s' % ('yes' if alive() else 'no'))
    sr = bytes(int(v) for v in g.sram()); before = sr[0x10C9:0x10CB]
    g.keys(0)
    for f in range(3000):
        g.run(1)
        if not alive(): break
    ev(len(KEYS) + f + 1, 'ball lost, state %02X:%02X' % lib.cur()); g.run(600); ev(len(KEYS) + f + 601, 'after 600 idle frames'); sr2 = bytes(int(v) for v in g.sram())
    lib.dump_exec_ranges(os.path.join(out, 'exec_ranges.csv'), ex0)
    with open(os.path.join(out, 'ball_timeline.csv'), 'w', newline='') as fh:
        w = csv.writer(fh, lineterminator='\n'); w.writerow(['frame', 'event', 'score', 'live_best_BCD', 'mode_state']); w.writerows(events)
    print('SRAM best BALL $10C9-$10CA: before %s, after the game %s' % (before.hex(), sr2[0x10C9:0x10CB].hex()))
    json.dump(dict(sram_best_before=before.hex(), sram_best_after=sr2[0x10C9:0x10CB].hex()), open(os.path.join(out, 'ball_play.json'), 'w')); open(os.path.join(out, 'ball_after.sav'), 'wb').write(sr2)
    sys.exit()
if mode == 'bgb':
    import shutil, collections
    mine = os.environ.get('BGB_DIR_BALL', '/home/claude/bgbball')
    if not os.path.isdir(mine): shutil.copytree('/home/claude/bgbx', mine)
    os.environ['BGB_DIR'] = mine
    import bgb_run
    C = lib.Corpus(os.path.join(ROOT, 'unlock_runs', 'f1_organic', 'corpus.jsonl')); p = C.path(ENTRY); sp = dict(C.E[p[0]]['spec']); seq = []
    for j in p[1:]:
        for a in C.E[j]['actions']: seq.append((names(a[0]), int(a[1]), int(a[2])))
    for k, n in K['keys']: seq.append((names(k), n, 0))
    sav = os.path.join(out, 'in_ff.sav'); open(sav, 'wb').write(b'\xff' * 0x20000)
    r = bgb_run.run(os.path.join(ROOT, 'pocketcamera_jp.gb'), sav, os.path.join(out, 'bgb_ball'), seq, combo=bgb_run.mask(names(sp['combo'])), free=sp['free'] + 3, tail=int(os.environ.get('BALL_TAIL', '5')), timeout=3000)
    w = r['st'].get('WRAM', b'')
    res = dict(end='%02X:%02X' % (r['mode'] or 0, r['state'] or 0), score_BCD=w[0x19E6:0x19E8][::-1].hex() if w else None, best_BCD=w[0x1AA4:0x1AA6][::-1].hex() if w else None, position_D9D7=w[0x19D7] if w else None)
    json.dump(res, open(os.path.join(out, 'bgb_ball.json'), 'w'), indent=1); print(json.dumps(res))
