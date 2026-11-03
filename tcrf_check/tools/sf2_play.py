#!/usr/bin/env python3
"""Space Fever II played with the joypad only: waves 1-3, boss, rounds 1-7, score above 7,000 (README 16.18).
usage: sf2_play.py search OUTDIR [GOAL_BCD]   a heuristic bot (aims at the lowest ship with a lead, fires when the three shot slots are free, dodges bullets and ships) plays from the start of the shooter;
                                              when the ship dies the core goes back to an earlier snapshot and the next frames are perturbed with random moves until it survives (the final key log is a plain
                                              joypad sequence; the game is deterministic, a replay of the log gives the same game). GOAL_BCD = score to reach as BCD (default 7000)
       sf2_play.py replay OUTDIR              replays OUTDIR/sf2_keys.json in the core, writes the timeline, the never-run bytes executed (exec_ranges.csv) and the effects on the save (best score, Album B)
       sf2_play.py bgb OUTDIR                 the same key log in the real BGB (break-points on the boss / variant / best-score code), end state of the game
Root of every run: corpus entry 197 (save `_ff`, unlock_runs/f1_organic/corpus.jsonl) = the shooter at the start of its first wave (menu wave `D863` = 1, nothing shot).
Writes OUTDIR/sf2_keys.json (RLE key log), sf2_timeline.csv, sf2_play.csv (summary), exec_ranges.csv, bgb_sf2.json.  Run from the working root (GBCAM_CORE as for the other core tools)."""
import sys, os, json, csv, random, time, collections
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE); ROOT = os.path.dirname(HERE)
mode, out = sys.argv[1], sys.argv[2]; os.makedirs(out, exist_ok=True)
ENTRY = 197
CORE = [(1, 'Right'), (2, 'Left'), (4, 'Up'), (8, 'Down'), (16, 'A'), (32, 'B'), (64, 'Select'), (128, 'Start')]
def names(k): return '+'.join(n for m, n in CORE if k & m) or '-'
def u8(g, a): return g.peek(a)
PY = 0x88
class Bot:
    def __init__(s, g, lib): s.g = g; s.lib = lib; s.h = [collections.deque(maxlen=5) for _ in range(3)]; s.f = 0; s.fire = False
    def observe(s):
        g = s.g
        for i in range(3): s.h[i].append((u8(g, 0xD835 + i), u8(g, 0xD838 + i), u8(g, 0xD84A + i)))
    def vel(s, i):
        h = s.h[i]
        if len(h) < 3: return 0.0, 0.0
        n = len(h) - 1
        return (h[-1][0] - h[0][0]) / n, (h[-1][1] - h[0][1]) / n
    def threats(s):
        g = s.g; th = []
        for i in range(8):
            by = u8(g, 0xD856 + i)
            if by < 0xA0: th.append((u8(g, 0xD84E + i), 0, by, 2, 6, 8))          # enemy bullet: 2 px per frame down, hit window |dx| < 4 (+2 margin), |dy| < 8
        for i in range(3):
            ey = u8(g, 0xD838 + i)
            if ey < 0xE0:
                vx, vy = s.vel(i)
                if abs(vy) > 3 or abs(vx) > 3: vx = vy = 0
                th.append((u8(g, 0xD835 + i), vx, ey, vy, 8, 6))                    # ship: |dx| < 6 (+2), |dy| < 6
        return th
    @staticmethod
    def danger(px, plan, th, T=26):
        mv, k = plan; x = px
        for t in range(1, T + 1):
            if t <= k: x = max(0, min(0x50, x + 2 * mv))
            for (tx, vx, ty, vy, hw, hy) in th:
                if abs(PY - (ty + vy * t)) < hy and abs(x - (tx + vx * t)) < hw: return t, x
        return T + 1, x
    def aim(s, w):
        g = s.g; best = None
        for i in range(3):
            if w == 9 and i > 0: break
            ex, ey, es = s.h[i][-1]
            if es != 0 or not (4 < ey < 0x9A): continue
            vx, vy = s.vel(i)
            if abs(vy) > 3 or abs(vx) > 3: vx = vy = 0
            if w == 9: vx = vy = 0
            t = max(0.0, (PY - ey)) / (4.0 + vy); xi = ex + vx * t
            if best is None or ey > best[0]: best = (ey, xi)
        return None if best is None else best[1]
    def choose(s):
        g = s.g; lib = s.lib; s.f += 1; cur = lib.cur(); w = u8(g, 0xD863); s.observe()
        if cur[1] in (3, 4): return g.A if s.f % 10 == 0 else 0
        px = u8(g, 0xD819); th = s.threats(); tg = s.aim(w) if w not in (0, 1) else None     # wave 0 / 1 = the menu wave: shooting a target would start BALL or RUN!
        res = []
        for mv in (-1, 0, 1):
            for k in ((0,) if mv == 0 else range(1, 19)):
                d, xf = s.danger(px, (mv, k), th); res.append((d, abs(xf - (tg if tg is not None else 0x28)) + 0.2 * k, mv))
        safe = [r for r in res if r[0] > 26]
        mv = min(safe, key=lambda r: r[1])[2] if safe else max(res, key=lambda r: (r[0], -r[1]))[2]
        key = 0
        if mv < 0: key |= g.LEFT
        elif mv > 0: key |= g.RIGHT
        free = all(u8(g, 0xD827 + i) >= 0xFC for i in range(3)); al = tg is not None and abs(px - tg) <= 3 and w not in (0, 1)
        if free and al and not s.fire: key |= g.A; s.fire = True
        else: s.fire = False
        if w == 9 and free and not s.fire: key |= g.A; s.fire = True
        return key
def rle(keys):
    r = []
    for k in keys:
        if r and r[-1][0] == k: r[-1][1] += 1
        else: r.append([k, 1])
    return r
def unrle(r): return [k for k, n in r for _ in range(n)]
def score(g): return int.from_bytes(bytes(u8(g, 0xD868 + i) for i in range(4)), 'little')
def bcd(v): return '%08x' % v
def root():
    import lib; from lib import g
    C = lib.Corpus(os.path.join(ROOT, 'unlock_runs', 'f1_organic', 'corpus.jsonl')); g.set_organic(1); C.replay(ENTRY)
    return lib, g, C
if mode == 'search':
    goal = int(sys.argv[3], 16) if len(sys.argv) > 3 else 0x7000
    lib, g, C = root(); rng = random.Random(1); b = Bot(g, lib); keys = []; snaps = []; f = 0; fails = 0; nm = 0; noise = 0; t0 = time.time()
    while f < 200000:
        if f % 20 == 0: snaps.append((f, g.snapshot()))
        if lib.cur()[0] != 7: print('left mode 7', f, lib.cur()); break
        if noise > 0:
            if f % 6 == 0: nm = rng.choice((-1, 0, 1))
            key = {-1: g.LEFT, 0: 0, 1: g.RIGHT}[nm]
            if all(u8(g, 0xD827 + i) >= 0xFC for i in range(3)) and rng.random() < 0.15: key |= g.A
            b.observe(); noise -= 1
        else: key = b.choose()
        g.keys(key); g.run(1); keys.append(key); f += 1
        if u8(g, 0xD88D) == 1 or lib.cur()[1] in (3, 4):
            fails += 1; j = min(len(snaps) - 1, 1 + fails % 7)
            for _ in range(j):
                if len(snaps) > 1: snaps.pop()
            f0, sn = snaps[-1]; g.restore(sn); f = f0; keys = keys[:f0]; noise = rng.choice((20, 40, 60, 80)); b = Bot(g, lib); snaps.pop()
        if score(g) >= goal: print('goal reached at frame', f, 'score', bcd(score(g)), 'roll-backs', fails, '%.0f s' % (time.time() - t0)); break
    json.dump(dict(root_entry=ENTRY, frames=f, rollbacks=fails, keys=rle(keys)), open(os.path.join(out, 'sf2_keys.json'), 'w'))
    sys.exit()
K = json.load(open(os.path.join(out, 'sf2_keys.json'))); KEYS = unrle(K['keys'])
if mode == 'replay':
    lib, g, C = root(); ex0 = lib.exec_baseline()
    events = []; last = {}; prev_w = u8(g, 0xD863); first = {}
    def ev(f, what): events.append([f, what, bcd(score(g)), bcd(int.from_bytes(bytes(u8(g, 0xDAA0 + i) for i in range(4)), 'little')), u8(g, 0xD88E), u8(g, 0xD88F), u8(g, 0xD863), u8(g, 0xD865)]); print(f, what, events[-1][2:], flush=True)
    thr = [0x1000, 0x2000, 0x3000, 0x5000, 0x7000]; ti = 0
    for f, k in enumerate(KEYS):
        w0 = u8(g, 0xD863); r0 = u8(g, 0xD88E); v0 = u8(g, 0xD88F)
        g.keys(k); g.run(1); w1 = u8(g, 0xD863)
        if w1 != w0 and w1 in (8, 9, 10): ev(f + 1, {8: 'boss init (wave state 8)', 9: 'boss fight (wave state 9)', 10: 'boss destroyed (wave state 10)'}[w1])
        if u8(g, 0xD88E) != r0: ev(f + 1, 'round %d -> %d' % (r0, u8(g, 0xD88E)))
        if u8(g, 0xD88F) != v0: ev(f + 1, 'boss variant %d -> %d' % (v0, u8(g, 0xD88F)))
        if ti < len(thr) and score(g) >= thr[ti]: ev(f + 1, 'score reaches %04x' % thr[ti]); ti += 1
    ev(len(KEYS), 'end of the key log, ship alive: %s' % ('yes' if u8(g, 0xD88D) == 0 else 'no'))
    sr = bytes(int(v) for v in g.sram()); live_best = bytes(u8(g, 0xDAA0 + i) for i in range(4)); sram_before = sr[0x10C5:0x10C9]
    g.keys(0)
    for f in range(4000):
        g.run(1)
        if lib.cur()[1] in (3, 4): break
    ev(len(KEYS) + f + 1, 'ship destroyed, dialog %02X:%02X' % lib.cur()); sram_dialog = bytes(int(v) for v in g.sram())[0x10C5:0x10C9]
    g.run(100); g.keys(g.B); g.run(4); g.keys(0); g.run(300); ev(len(KEYS) + f + 400, 'B on the dialog -> %02X:%02X' % lib.cur())
    sram_after = bytes(int(v) for v in g.sram())[0x10C5:0x10C9]
    new = [(o) for o in __import__('numpy').flatnonzero((__import__('numpy').array(g.cov_exec(), copy=True) != 0) & ~ex0)]
    lib.dump_exec_ranges(os.path.join(out, 'exec_ranges.csv'), ex0)
    with open(os.path.join(out, 'sf2_timeline.csv'), 'w', newline='') as fh:
        w = csv.writer(fh, lineterminator='\n'); w.writerow(['frame', 'event', 'score_BCD', 'live_best_BCD', 'round_D88E', 'boss_variant_D88F', 'wave_state_D863', 'boss_hits_D865']); w.writerows(events)
    print('SRAM best score bytes $10C5-$10C8: before the dialog %s, at the dialog %s, after B %s' % (sram_before.hex(), sram_dialog.hex(), sram_after.hex()))
    json.dump(dict(sram_best_before_dialog=sram_before.hex(), sram_best_at_dialog=sram_dialog.hex(), sram_best_after_B=sram_after.hex(), sram_after=sram_after.hex()), open(os.path.join(out, 'sf2_play.json'), 'w'))
    open(os.path.join(out, 'sf2_after.sav'), 'wb').write(bytes(int(v) for v in g.sram()))
    sys.exit()
if mode == 'bgb':
    import shutil
    mine = os.environ.get('BGB_DIR_SF2', '/home/claude/bgbsf2')
    if not os.path.isdir(mine): shutil.copytree('/home/claude/bgbx', mine)
    os.environ['BGB_DIR'] = mine
    import bgb_run, lib as _l
    C = _l.Corpus(os.path.join(ROOT, 'unlock_runs', 'f1_organic', 'corpus.jsonl')); p = C.path(ENTRY); sp = dict(C.E[p[0]]['spec'])
    seq = []
    for j in p[1:]:
        for a in C.E[j]['actions']: seq.append((names(a[0]), int(a[1]), int(a[2])))
    for k, n in K['keys']: seq.append((names(k), n, 0))
    PROBES = {'07:6232': 'boss final animation (timer 50)', '07:6276': 'boss variant wraps 3 -> 0', '07:693A': 'boss variant 2 graphics test', '07:6767': 'boss destroyed, timer reset', '07:67BE': 'best score flag set'}
    log = os.path.join(mine, 'debugmsg.txt')
    if os.path.exists(log): os.remove(log)
    sav = os.path.join(ROOT, 'saves_unl', sp['sav'] + '.sav')
    if not os.path.exists(sav): sav = os.path.join(ROOT, 'saves', sp['sav'] + '.sav')
    if sp['sav'] == '_ff': sav = os.path.join(out, 'in_ff.sav'); open(sav, 'wb').write(b'\xff' * 0x20000)      # the corpus name `_ff` = a save of 128 KiB of $FF (blank camera)
    r = bgb_run.run(os.path.join(ROOT, 'pocketcamera_jp.gb'), sav, os.path.join(out, 'bgb_sf2'), seq, combo=bgb_run.mask(names(sp['combo'])), free=sp['free'] + 3, br=','.join('%s///%s' % (a, a) for a in PROBES),
                    extra=['-setting', 'DebugMsgFile=1'], tail=5, timeout=3000)
    cnt = collections.Counter(l.strip() for l in open(log, errors='replace') if l.strip()) if os.path.exists(log) else {}
    w = r['st'].get('WRAM', b'')
    res = dict(end='%02X:%02X' % (r['mode'] or 0, r['state'] or 0), score_BCD=bcd(int.from_bytes(w[0x1868:0x186C], 'little')) if w else None, best_BCD=bcd(int.from_bytes(w[0x1AA0:0x1AA4], 'little')) if w else None,
               round_D88E=w[0x188E] if w else None, boss_variant_D88F=w[0x188F] if w else None, wave_D863=w[0x1863] if w else None, ship_died_D88D=w[0x188D] if w else None, probe_hits={a: [PROBES[a], cnt.get(a, 0)] for a in PROBES})
    json.dump(res, open(os.path.join(out, 'bgb_sf2.json'), 'w'), indent=1); print(json.dumps(res))
