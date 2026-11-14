#!/usr/bin/env python3
"""Hello Kitty ROM: every sliding puzzle played to the end, in the core and in BGB (owner, 2026-11-14).

  tools/kitty_puzzle.py ROM --core      writes roms/hello_kitty/trace/cov_kitty_puzzle.npz and trace/puzzle_core_kitty.csv
  tools/kitty_puzzle.py ROM --bgb       writes trace/puzzle_bgb_kitty.csv and the screenshots screens/puzzle_*.png
  tools/kitty_puzzle.py ROM --core --check   reruns the core campaign and compares it with the two files

The puzzle (Play menu, second item; the Kitt host, mode $0E, takes 25 Kitts; mode $0F) comes in three kinds, chosen on the host's
screen $0E:$0A (`Mode0E_State09` / `0A`): a drawing ($D974 = 0), a photo of the album (1) and the live camera (2). The drawings
come one after the other: the counter $DAD9 (0-5, saved) names the next one and goes up by one each time a drawing is solved
(`Mode0E_State0F`); until it reaches 5 the host offers only the drawing, from 5 on it offers the three kinds (the menu objects
`02:58D4` / `02:58FA`) and the drawing is a random one of the five (`Mode0F_State02`). The board is dealt by playing random legal
moves (`Puzzle15_Shuffle*`), then the keys slide the pieces; tools/puzzle15.py reads the board ($D960-$D96F) and solves it.

The campaign, from the core's formatted save with 999,999 Kitts and one photo taken first (title A, take A, shutter A, keep A, B):
the five drawings in order, a sixth (random) drawing, the photo, the live camera, and a drawing left with B in the middle. Each key
is held 8 frames, then 150 free frames on the menus and 40 between two slides (a slide takes about 20).

BGB (--bgb) plays the same campaign with demo files, one game per BGB run, each from the save the previous one left (the state
file's SRAM): a first run stops on the dealt board and reads it from the state file, a second one replays the same keys (BGB is
deterministic), slides the solution and stops on the solved picture (its screenshot), a third one goes on with A until the Play
menu, whose SRAM is the next save. The boards of BGB and the core differ (the deal depends on the frame of the keys).
"""
import sys, os, csv, argparse, subprocess
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); KD = os.path.join(REPO, 'roms', 'hello_kitty')
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(REPO, 'coverage', 'src'))
import numpy as np
import puzzle15
ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('--core', action='store_true'); ap.add_argument('--bgb', action='store_true')
ap.add_argument('--check', action='store_true'); ap.add_argument('--sheet', action='store_true'); ap.add_argument('--work', default='/tmp/kitty_puzzle_bgb')
a = ap.parse_args()
GAMES = [('drawing_1', []), ('drawing_2', []), ('drawing_3', []), ('drawing_4', []), ('drawing_5', []), ('drawing_random', []),
         ('camera', ['Down']), ('photo', ['Down']), ('drawing_quit_no', []), ('drawing_quit_yes', []), ('too_few_kitts', [])]
# no photo in the album until the game 'photo' (one is taken first: camera A, shutter A, keep A, B), so that the host's menu is seen
# with and without a photo once the drawings are done ($D932, Mode0E_State09): drawing / camera (Down) without one, drawing / photo
# (Down) / camera (Down Down) with one; too_few_kitts: the save's Kitt counter (SRAM $100A-$100C,
# BCD) set to 0, the host refuses (KittHost_PayPuzzle, the far call 06:5B59 returns carry)
# drawing_quit_no: ten slides, B (the host asks whether to stop, $0E:$11), A on "no" (back to the board), then solved;
# drawing_quit_yes: ten slides, B, Up A on "yes" (the host's goodbye, then the Play menu)
QUIT = {'drawing_quit_no': ['B', 'A'], 'drawing_quit_yes': ['B', 'Up', 'A']}
BIT = dict(A=1, B=2, Select=4, Start=8, Right=0x10, Left=0x20, Up=0x40, Down=0x80)
MENU_WAIT, SLIDE_WAIT, HOLD = 150, 40, 8

def core_campaign():
    import gbcov as G
    def cm(b): return ((b << 4) | (b >> 4)) & 0xFF
    G.load_rom(a.rom); G.reset(bytes(0x20000)); G.run(600); base = bytearray(bytes(G.sram()))
    kitts = bytes(base[:0x100A]) + b'\x99\x99\x99' + bytes(base[0x100D:])
    G.reset(kitts); G.L.gb_cov_clear(); G.L.gb_printer_model(1); G.L.gb_attach_printer(1); G.run(700)
    st = lambda: '%02X:%02X' % (G.peek(0xFF8D), G.peek(0xFF8E))
    log = []
    def press(k, wait=MENU_WAIT):
        G.keys(cm(BIT[k])); G.run(HOLD); G.keys(0); G.run(wait); log.append(k)
    press('A')                                                   # title -> main menu
    rows = []
    for name, choice in GAMES:
        if name in ('photo', 'too_few_kitts'):                    # a power cycle on the save as it is, as BGB does between two games
            sv = bytearray(bytes(G.sram()))
            if name == 'too_few_kitts': sv[0x100A:0x100D] = b'\x00\x00\x00'
            G.reset(bytes(sv)); G.run(700); press('A')
            if name == 'photo':
                for k in 'A A A B'.split(): press(k)             # take one photo and keep it, back to the main menu
        if st().startswith('01'): press('Up'); press('A')        # main menu -> Play menu
        for _ in range(4):                                       # Play menu: the cursor on item 1 (the puzzle)
            if G.peek(0xD8F4) == 1: break
            press('Down')
        press('A')
        for _ in range(14):                                      # the host's dialogue: A until the puzzle
            if st() == '0E:0A':
                for k in choice: press(k)
            if st().startswith('0F'): break
            press('A')
        if name == 'too_few_kitts':
            seen = []
            for i in range(60):
                G.run(30); x = st()
                if not seen or seen[-1] != x: seen.append(x)
                if x.startswith('04'): break
                if i % 8 == 7: press('A', 30)
            rows.append([name, '', '', '', G.peek(0xDAD9), '', '', 'no', ' '.join(m for m in seen if not m.startswith('1E')), G.peek(0xDAD9), ''])
            print(*rows[-1][:10], flush=True); continue
        for _ in range(300):                                     # the deal: wait until the board is shuffled and stays still for 60 frames
            if st() in ('0F:0A', '0F:0B', '0F:0C'): break
            G.run(10)
        last, still = None, 0
        for _ in range(300):
            G.run(10); bd = [G.peek(0xD960 + j) for j in range(16)]
            still = still + 1 if bd == last else 0; last = bd
            if still >= 6 and bd != list(range(16)) and st() in ('0F:0A', '0F:0B', '0F:0C'): break
        dealt = st()
        board = [G.peek(0xD960 + j) for j in range(16)]; kind, pic, dad9 = G.peek(0xD974), G.peek(0xD97A), G.peek(0xDAD9)
        ks = puzzle15.keys(board)
        if name in QUIT:
            for k in ks[:10]: press(k, SLIDE_WAIT)
            for k in QUIT[name]: press(k)
            ks = ks[:10] + QUIT[name]
            if name.endswith('_no'):
                rest = puzzle15.keys([G.peek(0xD960 + j) for j in range(16)])
                for k in rest: press(k, SLIDE_WAIT)
                ks += rest
        else:
            for k in ks: press(k, SLIDE_WAIT)
        sol = ' '.join(ks); solved = [G.peek(0xD960 + j) for j in range(16)] == list(range(16))
        seen = []
        for i in range(120):
            G.run(30); x = st()
            if not seen or seen[-1] != x: seen.append(x)
            if x.startswith('04'): break
            if i % 8 == 7: press('A', 30)
        rows.append([name, dealt, kind, pic, dad9, ' '.join('%X' % v for v in board), sum(k in puzzle15.STEP for k in ks) if solved else '', 'yes' if solved else 'no',
                     ' '.join(m for m in seen if not m.startswith('1E')), G.peek(0xDAD9), sol])
        print(*rows[-1][:10], flush=True)
    return rows, np.array(G.cov_exec()), np.array(G.cov_dread()), np.array(G.cov_reader())

HDR = ['game', 'dealt_on', 'kind_D974', 'picture_D97A', 'drawings_DAD9_before', 'board', 'slides', 'solved', 'screens_after', 'drawings_DAD9_after', 'keys']
if a.core:
    rows, ex, dr, rd = core_campaign()
    import io
    f = io.StringIO(); w = csv.writer(f, lineterminator='\n'); w.writerow(HDR); w.writerows(rows)
    OUT = os.path.join(KD, 'trace', 'puzzle_core_kitty.csv'); NPZ = os.path.join(KD, 'trace', 'cov_kitty_puzzle.npz')
    if a.check:
        old = np.load(NPZ)
        if open(OUT).read() != f.getvalue() or not (np.array_equal(old['ex'], ex) and np.array_equal(old['dr'], dr)):
            sys.exit('kitty_puzzle: trace/puzzle_core_kitty.csv or cov_kitty_puzzle.npz is not what the core campaign gives today')
        print('kitty_puzzle: core campaign fresh (%d games, %d solved)' % (len(rows), sum(r[7] == 'yes' for r in rows))); sys.exit(0)
    open(OUT, 'w').write(f.getvalue()); np.savez_compressed(NPZ, ex=ex, dr=dr, rdr=rd)
    print('kitty_puzzle: %d games, %d solved; executed %d bytes, read %d' % (len(rows), sum(r[7] == 'yes' for r in rows), int((ex > 0).sum()), int((dr > 0).sum())))

if a.bgb:
    sys.path.insert(0, os.path.join(HERE, 'jp'))
    from bgb_run import run as bgb, read_state
    os.makedirs(a.work, exist_ok=True)
    import gbcov as G
    G.load_rom(a.rom); G.reset(bytes(0x20000)); G.run(600); base = bytearray(bytes(G.sram()))
    sav = os.path.join(a.work, 'start.sav'); open(sav, 'wb').write(bytes(base[:0x100A]) + b'\x99\x99\x99' + bytes(base[0x100D:]))
    def seq(keys, wait=MENU_WAIT): return [(k, HOLD, wait) for k in keys]
    def hram(st, ad): h = st.get('HRAM', b''); return h[ad - 0xFF80]
    def wram(st, ad): return st['WRAM'][ad - 0xC000]
    rows = []; SH = os.path.join(KD, 'screens')
    for gi, (name, choice) in enumerate(GAMES):
        pre = seq('A A A A B'.split()) if name == 'photo' else seq(['A'])  # title A (and, for the game 'photo', one photo first)
        if name == 'too_few_kitts':                                         # the Kitt counter of the save set to 0
            sv = bytearray(open(sav, 'rb').read()); sv[0x100A:0x100D] = b'\x00\x00\x00'; sav = os.path.join(a.work, 'nokitts.sav'); open(sav, 'wb').write(bytes(sv))
            p0 = bgb(a.rom, sav, os.path.join(a.work, name), pre + seq(['Up', 'A', 'Down', 'A', 'A', 'A', 'A', 'A']), free=450, tail=60)
            h0 = p0['st']; m0 = '%02X:%02X' % (hram(h0, 0xFF8D), hram(h0, 0xFF8E))
            rows.append([name, '', '', '', wram(h0, 0xDAD9), '', '', 'no', 'after A x5 at the host %s' % m0, wram(h0, 0xDAD9), '']); print(*rows[-1][:10], flush=True); continue
        nav = pre + seq(['Up', 'A', 'Down', 'A', 'A', 'A', 'A'])           # main menu -> Play menu -> puzzle item -> the host ($0E:$05, $07, $08, $0A)
        host = seq(choice) + seq(['A'] * 3) + [('-', 0, 900)]              # on the host's choice screen ($0E:$0A): the kind, A; then the deal (900 idle frames)
        p1 = bgb(a.rom, sav, os.path.join(a.work, '%s_1' % name), nav + host, free=450, tail=60)
        st = p1['st']; m = '%02X:%02X' % (hram(st, 0xFF8D), hram(st, 0xFF8E))
        board = [wram(st, 0xD960 + j) for j in range(16)]; kind, pic, dad9 = wram(st, 0xD974), wram(st, 0xD97A), wram(st, 0xDAD9)
        print(name, 'dealt on', m, 'board', board, flush=True)
        if not m.startswith('0F') or sorted(board) != list(range(16)):
            rows.append([name, m, kind, pic, dad9, '', '', 'no', 'did not reach the board', '', '']); continue
        ks = puzzle15.keys(board); tap = lambda k: (k, HOLD, SLIDE_WAIT if k in puzzle15.STEP else MENU_WAIT)
        if name in QUIT:
            ks = ks[:10] + QUIT[name]
            if name.endswith('_no'):                             # the board after the ten slides, solved from there
                ks += puzzle15.keys(puzzle15.apply(board, ks[:10]))
        p2 = bgb(a.rom, sav, os.path.join(a.work, '%s_2' % name), nav + host + [tap(k) for k in ks], free=450, tail=240)
        st2 = p2['st']; b2 = [wram(st2, 0xD960 + j) for j in range(16)]; m2 = '%02X:%02X' % (hram(st2, 0xFF8D), hram(st2, 0xFF8E))
        if name == 'drawing_quit_yes':                           # the host's question after B ($0E:$11), for the screen tree
            pq = bgb(a.rom, sav, os.path.join(a.work, '%s_q' % name), nav + host + [tap(k) for k in ks[:11]], free=450, tail=120)
            subprocess.run(['convert', pq['shot'], os.path.join(SH, 'puzzle_quit_question.png')])
        solved = b2 == list(range(16))
        subprocess.run(['convert', p1['shot'], os.path.join(SH, 'puzzle_%s_dealt.png' % name)])
        subprocess.run(['convert', p2['shot'], os.path.join(SH, 'puzzle_%s_end.png' % name)])
        p3 = bgb(a.rom, sav, os.path.join(a.work, '%s_3' % name), nav + host + [tap(k) for k in ks] + seq(['A'] * 6, 240), free=450, tail=300)
        st3 = p3['st']; m3 = '%02X:%02X' % (hram(st3, 0xFF8D), hram(st3, 0xFF8E))
        nxt = os.path.join(a.work, '%s_next.sav' % name); open(nxt, 'wb').write(st3['SRAM'][:0x20000]); sav = nxt
        rows.append([name, m, kind, pic, dad9, ' '.join('%X' % v for v in board), sum(k in puzzle15.STEP for k in ks) if solved else '', 'yes' if solved else 'no',
                     'after the slides %s, after A x6 %s' % (m2, m3), wram(st3, 0xDAD9), ' '.join(ks)])
        print(*rows[-1][:10], flush=True)
    with open(os.path.join(KD, 'trace', 'puzzle_bgb_kitty.csv'), 'w', newline='') as f:
        w = csv.writer(f, lineterminator='\n'); w.writerow(HDR); w.writerows(rows)
    print('kitty_puzzle: BGB, %d games, %d solved' % (len(rows), sum(r[7] == 'yes' for r in rows)))

if a.sheet or a.bgb:                     # screens/puzzles_kitty.png from the BGB screenshots: each game dealt, then solved
    from PIL import Image, ImageDraw, ImageFont
    SH = os.path.join(KD, 'screens')
    try: F = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf', 13)
    except OSError: F = ImageFont.load_default()
    games = [g for g, _ in GAMES if os.path.exists(os.path.join(SH, 'puzzle_%s_end.png' % g))]
    CAP = {'drawing_1': 'drawing 1 ($DAD9 = 0)', 'drawing_2': 'drawing 2', 'drawing_3': 'drawing 3', 'drawing_4': 'drawing 4', 'drawing_5': 'drawing 5 (then $DAD9 = 5)',
           'drawing_random': 'a random drawing', 'photo': 'a photo (Down)', 'camera': 'the live camera (Down Down)', 'drawing_quit_no': 'B, "no", then solved',
           'drawing_quit_yes': 'B, "yes": back to the Play menu'}
    W, H, P = 320, 288, 10; cols = 4
    out = Image.new('RGB', (cols * (W + P) + P, ((len(games) + 1) // 2) * (H + 34) + 40), 'white'); d = ImageDraw.Draw(out)
    d.text((P, 10), 'Hello Kitty 15 puzzle in BGB (tools/kitty_puzzle.py): the board dealt, then the end after the solver\'s slides', fill='black', font=F)
    for i, g in enumerate(games):
        x0 = (i % 2) * 2 * (W + P) + P; y0 = 40 + (i // 2) * (H + 34)
        d.text((x0, y0), CAP.get(g, g), fill='black', font=F)
        for j, s in enumerate(('dealt', 'end')):
            im = Image.open(os.path.join(SH, 'puzzle_%s_%s.png' % (g, s))).convert('RGB').resize((W, H), Image.NEAREST)
            out.paste(im, (x0 + j * (W + P), y0 + 20))
    out.save(os.path.join(SH, 'puzzles_kitty.png')); print('kitty_puzzle: screens/puzzles_kitty.png, %d games' % len(games))
