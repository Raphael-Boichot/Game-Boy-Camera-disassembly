#!/usr/bin/env python3
"""Run the OPEN / gated never-run pieces in my core with the WRAM or SRAM value that gates them poked (README 16.21).
usage: force_open.py EXPERIMENT OUTDIR [--list]      (run from the working root; corpus unlock_runs/f1_organic/corpus.jsonl, saves in saves_unl/)
One process per experiment (the core's executed-byte array is cumulative); every experiment replays a corpus entry to a state, pokes WRAM / SRAM like a save or a game state could hold it,
presses keys like a player and tests the target addresses; OUTDIR/<experiment>.json = what was done and which targets ran, OUTDIR/exec_ranges.csv = every byte executed in the process
(witness_map.py intersects it with the never-run code).  Nothing but WRAM / SRAM bytes and joypad keys is touched: no register, no PC.
EXPERIMENTS is the table below; each entry says which component it aims at and what the gate is."""
import sys, os, json
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
CORE = os.environ.get('GBCAM_CORE')        # the printer experiments need the core with the printer stand-in (gb_printer_model); see printer_status.py
if CORE: sys.path.insert(0, CORE); import gbcov      # imported first so that lib.py finds this core (printer_status.py does the same)
import lib; from lib import g
import blocks as B
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'tools'))
import sram_analyze as S
CORPUS = 'unlock_runs/f1_organic/corpus.jsonl'
EXPS = {}
def exp(name, doc):
    def deco(f): EXPS[name] = (f, doc); return f
    return deco
def T(*addrs):      # 'BB:AAAA' strings -> flat offsets
    return {a: B.flat(int(a.split(':')[0], 16), int(a.split(':')[1], 16)) for a in addrs}
def hit(ex, tg): return {a: bool(ex[o] > 0) for a, o in tg.items()}
def st(): return '%02X:%02X' % lib.cur()
def tap(k, hold=4, wait=20): g.keys(k); g.run(hold); g.keys(0); g.run(wait)
def run_until(pred, n=600):
    for i in range(n):
        g.run(1)
        if pred(): return i + 1
    return None
def patch_save(fn, name='unl_CE10238211'):
    """patched copy of a stored save, settings checksums fixed; fn(bytearray) edits it"""
    b = bytearray(lib.SAV(name)); fn(b)
    for off in (0x1000, 0x10D9): b[off + 0xD7:off + 0xD9] = S.ck(b, off, 0xD7)
    return bytes(b)

# ---------------------------------------------------------------- hot-spot jump table slot 0 and the hot-spot jump target (bank 3)
def hotspot_base(effect, jump, sound=0xFF):
    C = lib.Corpus(CORPUS); i = C.best((0x0C, 3)); g.set_organic(1); C.replay(i); g.run(30)
    px, py = g.peek(0xD667), g.peek(0xD668)
    for n, v in ((0xD643, 1), (0xD648, px), (0xD64D, py), (0xD652, sound), (0xD657, effect), (0xD65C, jump)): g.poke(n, v)
    lib.act((g.A, 4, 2))
    for _ in range(400):
        g.run(1)
        if g.peek(0xD5CE) != 0x0C: break
    g.run(60)
@exp('hotspot_ff', 'hot spot 0 armed with effect $FF (jump table index 0 = 03:6625: copy $C000 / $C800 to VRAM) and no jump target')
def hotspot_ff(r):
    tg = T('03:6625'); hotspot_base(0xFF, 0xFF); r['hits'] = hit(g.cov_exec(), tg); r['end'] = st()
@exp('hotspot_jump', 'hot spot 0 armed with a jump target (photo 2, $D65C = 2): 03:6533 draws the target photo; effect $FF')
def hotspot_jump(r):
    tg = T('03:6533', '03:6625'); hotspot_base(0xFF, 2); r['hits'] = hit(g.cov_exec(), tg); r['end'] = st()

def at(sig):
    """replay the cheapest corpus entry that sits in state sig = (mode, state); returns its id"""
    C = lib.Corpus(CORPUS); i = C.best(sig); assert i is not None, sig; g.set_organic(1); C.replay(i); g.run(30); return i
def poke_for(frames, pokes, keys=0):
    """poke (addr, value) pairs once per frame for N frames (the game rewrites some of them), keys held during the first 4 frames"""
    for f in range(frames):
        for ad, v in pokes: g.poke(ad, v)
        if f == 0 and keys: g.keys(keys)
        if f == 4: g.keys(0)
        g.run(1)
    g.keys(0)

# ---------------------------------------------------------------- bank 3: SHOW menu (mode $0B): the mode table 03:79E0 read with an index whose byte is $FF
@exp('show_menu_ff', 'SHOW menu 0B:01: $D5EF (the chosen item, index into the 3-entry table 03:79E0) poked to 41 (ROM byte $FF) then A: 03:79AE (dec state)')
def show_menu_ff(r):
    tg = T('03:79AE'); at((0x0B, 1))
    poke_for(30, [(0xD5EF, 41)], keys=g.A); r['hits'] = hit(g.cov_exec(), tg); r['end'] = st()

# ---------------------------------------------------------------- bank 3: slide-show editor
@exp('editor_count_digits', 'editor Select menu 12:0C: repeat count $D519 >= 10 with $D71C + $D71D = 30: the number sprite offset clamps to $10 (03:4B17)')
def editor_count_digits(r):
    tg = T('03:4B17'); at((0x12, 0x0C)); r['start'] = st()
    for cnt in (10, 12, 25):
        for a_, b_ in ((14, 16), (0, 30), (30, 0), (10, 20)):
            poke_for(8, [(0xD519, cnt), (0xD71C, a_), (0xD71D, b_)])
            if hit(g.cov_exec(), tg)['03:4B17']: r['pokes'] = dict(D519=cnt, D71C=a_, D71D=b_); break
        if 'pokes' in r: break
    r['hits'] = hit(g.cov_exec(), tg); r['end'] = st()
@exp('editor_picker_wrap', 'editor 12:01, A held (state 2, the photo chooser 03:415C) + Left / Right / Up / Down chords: the wraps 03:552F (Left below photo 0, album A) and 03:555A (album B chooser below the first stock picture)')
def editor_picker_wrap(r):
    import itertools
    tg = T('03:552F', '03:555A'); r['trials'] = []; found = {}
    KEYS = [('Left', g.LEFT), ('Right', g.RIGHT), ('Up', g.UP), ('Down', g.DOWN)]
    at((0x12, 1)); base = g.snapshot()
    for n in (1, 2, 3, 4):
        for combo in itertools.product(KEYS, repeat=n):
            g.restore(base); g.keys(g.A); g.run(8)
            for kn, k in combo:
                g.keys(g.A | k); g.run(4); g.keys(g.A); g.run(8)
            g.keys(0); g.run(4)
            h = hit(g.cov_exec(), tg)
            for a_, v in h.items():
                if v and a_ not in found: found[a_] = [kn for kn, k in combo]; r['trials'].append([a_, found[a_], st()])
            if len(found) == len(tg): break
        if len(found) == len(tg): break
    r['found_after_A_held_then'] = found; r['hits'] = hit(g.cov_exec(), tg)


def replay(i):
    """replay corpus entry i (boot + every recorded action) and let the game settle 30 frames"""
    C = lib.Corpus(CORPUS); g.set_organic(1); C.replay(i); g.run(30); return C
def substitute_sav(old, new):
    """replay the lineages recorded on the save `old` on the stored save `new` instead (same menus, other album)"""
    orig = lib.SAV; lib.SAV = lambda name: orig(new) if name == old else orig(name)
def press(k, hold=4, wait=60):
    g.keys(k); g.run(hold); g.keys(0); g.run(wait)

# ---------------------------------------------------------------- bank 4
@exp('erase_browse', 'mode $0A state 3 (04:7593, the "view which photo?" confirm screen): $D67E (photo-changed flag, only ever set by the unreferenced routine 04:7C9D) := 1 and $D5ED := 1: photo 1 has another border number than photo 0, so 04:75C5 redraws the frame background')
def erase_browse(r):
    tg = T('04:75C5', '04:75DD'); replay(262); r['start'] = st(); r['border_before'] = g.peek(0xD7C1)
    g.poke(0xD5ED, 1); g.poke(0xD67E, 1); g.run(200)
    r['border_after'] = g.peek(0xD7C1); r['hits'] = hit(g.cov_exec(), tg); r['end'] = st()
@exp('stamp_cancel_d640', 'stamp tool (mode $11): B on the placement state 11:04 opens the save dialog (11:07); $D640 (the state to return to, written only in state 4 and always 4) := 3 while the dialog is open, B cancels ($D670 = $FF): 04:5D63 (back to the palette)')
def stamp_cancel_d640(r):
    tg = T('04:5D63', '04:5D4E'); C = replay(1006); r['start'] = st(); log = []
    for n, k, h, w in (('B', g.B, 4, 60), ('Down', g.DOWN, 4, 30), ('A', g.A, 4, 60), ('B', g.B, 4, 90), ('B', g.B, 4, 90), ('A', g.A, 4, 90)):
        for f in range(h + w):
            if lib.cur()[0] == 0x11 and lib.cur()[1] >= 5: g.poke(0xD640, 3)
            if f == 0: g.keys(k)
            if f == h: g.keys(0)
            g.run(1)
        log.append([n, st(), g.peek(0xD670)])
    r['log'] = log; r['hits'] = hit(g.cov_exec(), tg); r['end'] = st()
@exp('copy_ten', 'album copy screen (mode $0F state 12, Edit > Album > Copy) on a save with 10 free slots (unl_CE10785322, 20 photos): ten A presses make ten copies, the copies counter $DA0F reaches 10 and 04:4FB8 splits it in tens and units (joypad only, no poke)')
def copy_ten(r):
    tg = T('04:4FB8'); substitute_sav('unl_CE10238211', 'unl_CE10785322'); replay(684); r['start'] = st(); log = []
    for n in range(11):
        press(g.A, 4, 100); log.append([st(), g.peek(0xD561), g.peek(0xDA0F)])
    r['log'] = log; r['hits'] = hit(g.cov_exec(), tg); r['end'] = st()
@exp('scatter_x_off', 'erase effect (mode $0F, delete YES): the 16 particle X positions $DACC-$DADB := $B0 (all off the right edge) while the Y positions are still on screen: the X pass counts no moving particle, 04:52E4 sets the end flag $DB4C')
def scatter_x_off(r):
    tg = T('04:52E4', '04:5301'); substitute_sav('unl_CE10238211', 'unl_CE10785322'); replay(1710); r['start'] = st()
    press(g.A, 4, 60); press(g.A, 4, 0)
    for f in range(120):
        if f >= 8:
            for k in range(16): g.poke(0xDACC + k, 0xB0)
        g.run(1)
    r['hits'] = hit(g.cov_exec(), tg); r['end'] = st(); r['photos_after'] = g.peek(0xD561)

# ---------------------------------------------------------------- bank 8
@exp('print_stock_border', 'print mode $1C: Select opens the layout state (08:4329), then $D5F3 (the printed photo, copied from $D5D8 at the screen init) := 30 (a stock picture: 02:4E31 answers the default border $12) just before B redraws the preview (08:47ED): 08:482C replaces the default border by 0')
def print_stock_border(r):
    tg = T('08:4800', '08:482C'); replay(289); r['start'] = st(); log = []
    press(g.SELECT, 4, 110); log.append(['Select', st()])
    g.poke(0xD5F3, 30); press(g.B, 4, 110); log.append(['B (D5F3 := 30)', st(), g.peek(0xD7C1), g.peek(0xDBCC)])
    r['log'] = log; r['hits'] = hit(g.cov_exec(), tg); r['end'] = st()

# ---------------------------------------------------------------- bank 2: boot-time SRAM check
@exp('owner_blocks_bad', 'boot with a valid save whose two copies of the bank-1 block at $AFB8 / $AFD1 (23 bytes + 2 checksum bytes each, magic at $AFCA / $AFE3 intact) both fail their checksum: 02:43D0 finds the magic, then neither copy valid -> 02:43EC `jp 02:4283` (format the save)')
def owner_blocks_bad(r):
    tg = T('02:43EC', '02:4283', '02:4308', '02:4310')
    def bad(b):
        b[0x2000 + 0xFB8] ^= 0x55; b[0x2000 + 0xFD1] ^= 0x55
    b = patch_save(bad)
    lib.boot(b, combo=0, printer=0, free=300)
    r['hits'] = hit(g.cov_exec(), tg); g.run(600); r['end'] = st(); r['hits_after'] = hit(g.cov_exec(), tg)
    sr = bytes(g.sram()); r['photos_after'] = g.peek(0xD561)

# ---------------------------------------------------------------- bank 9: name entry
@exp('name_dakuten_blank', 'owner NAME keyboard (mode 8 state 7): the name is blank up to the cursor and A is pressed on the dakuten key (code $30 or $31, row 9 of the grid): the routine 09:5C9A walks back over blank characters, finds none and returns at 09:5CAF')
def name_dakuten_blank(r):
    tg = T('09:5C9A', '09:5CAF'); replay(213); r['start'] = st(); r['cell_before'] = g.peek(0xDA3C); log = []
    for n in range(8): press(g.RIGHT, 4, 14)
    for n in range(4): press(g.DOWN, 4, 14)
    r['key_under_cursor'] = g.peek(0xDA3C); r['page'] = g.peek(0xDA3D)
    for k in range(9): g.poke(0xDA4D + k, 0)
    g.poke(0xDA3B, 0); press(g.A, 4, 30)
    r['hits'] = hit(g.cov_exec(), tg); r['end'] = st()

# ---------------------------------------------------------------- bank 1F: sound engine
@exp('sound_ports', 'sound engine: every sound number 1..$FF written to each of the four request ports ($DD60, $DD68, $DD70, $DD78 = the stores of 00:2A7C / 2A88 / 2A80 / 2A84) of the main menu, 150 frames each: the channel set-up 1F:5224-523A (channel structure DD65 / DD75 / DD7D, else 1F:522A)')
def sound_ports(r):
    tg = T('1F:5234', '1F:522A', '1F:522C', '1F:523C'); replay(2); base = g.snapshot(); first = {}
    for port in (0xDD70, 0xDD68, 0xDD60, 0xDD78):
        for sid in range(1, 0x100):
            g.restore(base); g.poke(port, sid); g.run(150)
            h = hit(g.cov_exec(), tg)
            for a_, v in h.items():
                if v and a_ not in first: first[a_] = [hex(port), sid]
    r['first'] = first; r['hits'] = hit(g.cov_exec(), tg)

# ---------------------------------------------------------------- banks 0A / 06: SHOOT effect table (the 88-byte index table 06:60DB)
EFFECT_POKES = [('idx13  k=140', 35, 0, 0), ('idx45  k=140 page 1', 35, 0, 1), ('idx77  k=140 page 2', 35, 0, 2),
                ('idx15  k=111', 27, 3, 0), ('idx47  k=111 page 1', 27, 3, 1), ('idx79  k=111 page 2', 27, 3, 2)]
@exp('effect_cursor', 'SHOOT (mode $14): the variant cursor $D7E3 / $D7E4 and the page $D7EB poked out of their menu range, so that 4 * D7E3 + D7E4 indexes a ROM byte beyond the 88-byte table 06:60DB (06:7804-7817) whose value is 13 (k = 140) or 15 (k = 111), with page 0 / 1 / 2: the effect slots 13, 45, 77 and 15, 47, 79 of 0A:541A (0A:5853, 5E40, 652E, 5900, 5EBF, 65A5) and the jump 06:7417 of 06:73AF')
def effect_cursor(r):
    tg = T('0A:5853', '0A:5E40', '0A:652E', '0A:5900', '0A:5EBF', '0A:65A5', '06:7417'); r['trials'] = []
    for cand in (183, 205, 372, 373, 399, 753, 210, 487):
        try: replay(cand)
        except Exception as e: r['trials'].append([cand, 'replay failed', str(e)]); continue
        base = g.snapshot(); r0 = hit(g.cov_exec(), tg)
        for name, v3, v4, page in EFFECT_POKES:
            g.restore(base)
            poke_for(40, [(0xD7E3, v3), (0xD7E4, v4), (0xD7EB, page)])
            h = hit(g.cov_exec(), tg)
            r['trials'].append([cand, st(), name, [a for a, v in h.items() if v and not r0[a]]])
        if all(hit(g.cov_exec(), tg).values()): break
    r['hits'] = hit(g.cov_exec(), tg)

EFFECT_POKES2 = [('idx60 k=167', 41, 3, 0), ('idx61 k=151', 37, 3, 0), ('idx60 k=192 page 1', 48, 0, 1), ('idx62 k=102', 25, 2, 0)]
@exp('effect_cursor_ret', 'SHOOT (mode $14): the same out-of-range cursor, now for the table bytes 60 (k = 167 or 192) and 61 (k = 151): the placeholder effect slots 60 and 61 of 0A:541A, a bare `ret` each (0A:61AE, 0A:61AF)')
def effect_cursor_ret(r):
    tg = T('0A:61AE', '0A:61AF'); r['trials'] = []
    for cand in (205, 183, 372, 373, 399, 753, 210, 487):
        try: replay(cand)
        except Exception as e: r['trials'].append([cand, 'replay failed', str(e)]); continue
        base = g.snapshot(); r0 = hit(g.cov_exec(), tg)
        for name, v3, v4, page in EFFECT_POKES2:
            g.restore(base)
            poke_for(40, [(0xD7E3, v3), (0xD7E4, v4), (0xD7EB, page)])
            h = hit(g.cov_exec(), tg)
            r['trials'].append([cand, st(), name, [a for a, v in h.items() if v and not r0[a]]])
        if all(hit(g.cov_exec(), tg).values()): break
    r['hits'] = hit(g.cov_exec(), tg)

# ---------------------------------------------------------------- Space Fever II (mode $07): boss variant 2 with a Game Face stored
def sf2_keys():
    here = os.path.dirname(os.path.abspath(__file__))
    for c in (os.environ.get('SF2_KEYS'), os.path.join(here, '..', 'assets', 'sf2', 'sf2_keys.json'), os.path.join(here, '..', 'tcrf_check', 'assets', 'sf2', 'sf2_keys.json')):
        if c and os.path.exists(c): K = json.load(open(c)); return [k for k, n in K['keys'] for _ in range(n)]
    raise SystemExit('sf2_keys.json not found (README 16.18; set SF2_KEYS)')
@exp('sf2_gameface', 'Space Fever II, key log of README 16.18 from corpus entry 197 (the blank `_ff` save): when the wave state $D863 reaches 6-8 poke $D88F := 2 (third boss) and $D581 := 1 (a Game Face is stored: SRAM $B0D1 bit 0); the boss set-up 07:60E1 then asks 00:16A6 for the graphics group 6 whose pointers are WRAM $C000 / $C380 / $C700: 00:1668 -> 00:16C4 takes its `bit 7,h` branch 00:16D7')
def sf2_gameface(r):
    tg = T('00:16D7', '00:16AE', '07:693A', '07:60E1'); KEYS = sf2_keys()
    C = lib.Corpus(CORPUS); g.set_organic(1); C.replay(197); poked = None
    for f, k in enumerate(KEYS):
        if poked is None and g.peek(0xD863) in (6, 7, 8): g.poke(0xD581, 1); g.poke(0xD88F, 2); poked = f
        g.keys(k); g.run(1)
        if hit(g.cov_exec(), tg)['00:16D7']: break
    r['poked_at_frame'] = poked; r['stopped_at_frame'] = f; r['hits'] = hit(g.cov_exec(), tg); r['end'] = st()

# ---------------------------------------------------------------- sound engine mailboxes (bank 1F)
@exp('sound_mailboxes', 'sound engine (1F:52D8 / 52F8 / 5318): every request id 1..$48 poked into each mailbox $DD60 / $DD61 / $DD68 / $DD70 / $DD71 / $DD78 / $DD79 for 4 frames; looking for 1F:5234 (the channel-3 flush `ld hl,$dd3f` of the sound set-up 1F:520A) and 1F:522A (its default exit); both stay unreached: the wave-channel handlers (tables 1F:42F2 / 4306, code 4F72-5127) write NR30-34 themselves and never call 520A')
def sound_mailboxes(r):
    tg = T('1F:5234', '1F:522A', '1F:523C', '1F:5259', '1F:4F72'); at((0x0C, 3)); base = g.snapshot(); r['trials'] = 0
    for slot in (0xDD70, 0xDD71, 0xDD60, 0xDD61, 0xDD78, 0xDD79, 0xDD68):
        for k in range(1, 0x49):
            g.restore(base); g.poke(slot, k); g.run(4); r['trials'] += 1
    r['hits'] = hit(g.cov_exec(), tg)

# ---------------------------------------------------------------- bank 0: printer engine (a print job in the core, printer stand-in attached)
def start_card_print():
    """README 17.4 / printer_status.py 'card' scenario: the comment-card print of corpus entry 289 up to the print key; returns the function that presses it"""
    g.L.gb_printer_model(1)
    Cp = lib.Corpus(CORPUS); p = Cp.path(289); sp = dict(Cp.E[p[0]]['spec']); g.set_organic(1)
    lib.boot(lib.SAV(sp['sav']), combo=sp['combo'], printer=1, free=sp['free'])
    seq = [tuple(x) for j in p[1:] for x in Cp.E[j]['actions']]
    seq = seq[:13] + [(g.RIGHT, 4, 40)] * 5 + seq[13:] + [(g.START, 4, 40)]
    for x in seq: lib.act(x)
def dc0b_tables():
    """the per-band size table $DBEC (9 words) and flag table $DBFE (13 bytes) read by the $DC0B path (written nowhere in the ROM, all zero at power-on): 9 bands of $0280 bytes, flag 0.
    With the tables left at zero the DATA packet of the poked print has a length of 0 = 65536 bytes and never ends"""
    for i in range(9): g.poke(0xDBEC + 2 * i, 0x80); g.poke(0xDBEC + 2 * i + 1, 0x02)
    for i in range(13): g.poke(0xDBFE + i, 0)
@exp('printer_dc0b', 'printer engine, comment-card print (README 17.4) with the compression switch $DC0B (read at 00:1A1B / 1A7E, written nowhere in the ROM) poked to 1 from the A press and the size / flag tables $DBEC / $DBFE filled (9 x $0280, 0): the per-band data path 00:1A24-1A47 and the DATA-packet wait 00:1A51-1A5B')
def printer_dc0b(r):
    tg = T('00:1A24', '00:1A5B', '00:1A87', '00:1A48', '00:1AA8', '00:1B25', '00:1B36'); start_card_print(); r['start'] = st()
    g.keys(g.A); g.run(4); g.keys(0); path = [st()]
    for f in range(4100):
        dc0b_tables(); g.poke(0xDC0B, 1); g.run(1)
        if st() != path[-1]: path.append(st())
    r['path'] = path; r['hits'] = hit(g.cov_exec(), tg); r['end'] = st(); r['dc0d'] = g.peek(0xDC0D)

@exp('printer_dc0b_retry', 'printer engine, comment-card print with $DC0B := 1, the tables filled and the printer answering a DATA packet with an error status (bit 0 / bit 1 = checksum / busy): the retry path of the engine (DC25 = 2) reads $DC0B again at 00:1A7E and takes 00:1A87-1AA7')
def printer_dc0b_retry(r):
    tg = T('00:1A24', '00:1A5B', '00:1A87', '00:1AA8', '00:1AD2', '00:1ACB', '00:1ADC'); start_card_print(); snap = g.snapshot(); r['variants'] = []; ex = g.cov_exec()
    CMDS = dict(init=1, print=2, data=4, inq=15)
    for nth in (1, 2):
        for status in (0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80):
            g.restore(snap); g.L.gb_printer_inject_clear(); g.L.gb_printer_inject(CMDS['data'], nth, status, 1)
            g.keys(g.A); g.run(4); g.keys(0)
            for f in range(1500):
                dc0b_tables(); g.poke(0xDC0B, 1); g.run(1)
            h = hit(ex, tg); r['variants'].append(['data', nth, '%02X' % status, st(), [a for a, v in h.items() if v]])
            if h['00:1A87']: break
        if hit(ex, tg)['00:1A87']: break
    r['hits'] = hit(ex, tg)

# ---------------------------------------------------------------- bank 9: RUN! RUN! RUN! (mode $21)
def x16(a): return g.peek(a) | g.peek(a + 1) << 8
@exp('run_states', 'RUN! RUN! RUN! (mode $21, state table 09:5FE7): (1) a race played with A every 2nd frame; on the first frame of state 07 (the handler with the race-end test, 09:63B4) the three runner positions are poked past the finish line ($D001:$D000 := $1590, $D00F:$D00E and $D018:$D017 := $1500) together with the place counter $D047 := $FF and the three places $D00D / $D016 / $D01F := 0: the placement of runner 0 (09:6AF0-6AFC) wraps the counter to 0 and gives runner 0 the place 0, runners 1 and 2 make it 2, and the race-end test (09:63E1) finds runner 0 unplaced: 09:63FE; (2) after the race the state number $D5CF is poked to 9 (09:6435: sets state 3) and to $0D (09:66BB: a lone ret), states no code ever selects')
def run_states(r):
    tg = T('09:6435', '09:66BB', '09:63FE', '09:6409', '09:6414'); replay(649); r['start'] = st(); ex = g.cov_exec(); n = 0
    def w16(a, v): g.poke(a, v & 255); g.poke(a + 1, v >> 8)
    while lib.cur()[0] == 0x21 and lib.cur()[1] in (0x06, 0x07, 0x0B) and n < 6000:        # the race, A every 2nd frame (run_race.py)
        g.keys(g.A if n % 2 == 0 else 0)
        if lib.cur() == (0x21, 0x07) and 'poked_at' not in r:       # state 07 = the handler with the race-end test (09:63B4); placement and test run in the same frame
            r['poked_at'] = n
            w16(0xD000, 0x1590); w16(0xD00E, 0x1500); w16(0xD017, 0x1500)
            for ad, v in ((0xD047, 0xFF), (0xD00D, 0), (0xD016, 0), (0xD01F, 0)): g.poke(ad, v)
        g.run(1); n += 1
        if r.get('poked_at') == n - 1: r['after_poke'] = dict(D047=g.peek(0xD047), places=[g.peek(0xD00D), g.peek(0xD016), g.peek(0xD01F)], state=st())
    r['race_frames'] = n; r['places'] = [g.peek(0xD00D), g.peek(0xD016), g.peek(0xD01F)]; r['D047'] = g.peek(0xD047)
    g.keys(0); g.run(200); r['after_race'] = st(); r['hits_race'] = hit(ex, tg)
    for n_ in (9, 0x0D):
        g.poke(0xD5CF, n_); g.run(3); r['state_%02X' % n_] = st()
    r['hits'] = hit(ex, tg); r['end'] = st()

@exp('run_record_equal', 'RUN! RUN! RUN! (mode $21): the record test 09:725E (called when runner 0 gets a place) compares the race time ($D029 / $D028, as $99 - x: cpl ; add a,$9a) with the stored best time $DAA7 / $DAA6; when both digits are equal it ends with the `ret` at 09:7273. A race is played (A every 2nd frame); the frame in which runner 0 gets its place is played twice from a snapshot: the first time to read the final time, the second time with the best time $DAA6 / $DAA7 poked to $99 - $D028 / $99 - $D029, i.e. a best time equal to the time run')
def run_record_equal(r):
    tg = T('09:7273', '09:7274', '09:725E'); replay(649); r['start'] = st(); n = 0; done = False
    while n < 3000:
        k = g.A if n % 2 == 0 and lib.cur()[0] == 0x21 and lib.cur()[1] in (0x06, 0x07) else 0
        snap = g.snapshot(); g.keys(k); g.run(1); n += 1
        if not done and g.peek(0xD00D) != 0:
            t6, t7 = g.peek(0xD028), g.peek(0xD029); r['times'] = [t6, t7]
            g.restore(snap); g.poke(0xDAA6, (0x199 - t6) & 255); g.poke(0xDAA7, (0x199 - t7) & 255); g.keys(k); g.run(1); done = True
            r['poked_best'] = [g.peek(0xDAA6), g.peek(0xDAA7)]; r['after'] = [g.peek(0xD028), g.peek(0xD029)]
        if g.cov_exec()[tg['09:7273']] > 0: break
    r['frames'] = n; r['hits'] = hit(g.cov_exec(), tg); r['end'] = st()

# ---------------------------------------------------------------- bank 3: slide-show editor state 3 (03:41B5): the number $D6E2
@exp('editor_d6e2_wrap', 'slide-show editor 12:03 (03:41B5): with A held, Down adds 1 to $D6E2 and wraps 100 to 0 (03:41E8); $D6E2 poked to 99 (the displayed value only reaches 99 after 90 presses from the 9 that the stored lineage shows)')
def editor_d6e2_wrap(r):
    tg = T('03:41E8', '03:41DC'); at((0x12, 3)); r['start'] = st(); r['D6E2_before'] = g.peek(0xD6E2)
    g.poke(0xD6E2, 99); g.keys(g.A | g.DOWN); g.run(4); g.keys(g.A); g.run(6); g.keys(0); g.run(10)
    r['D6E2_after'] = g.peek(0xD6E2); r['hits'] = hit(g.cov_exec(), tg); r['end'] = st()

# ---------------------------------------------------------------- bank 6: SHOOT variant 2 (burst) countdown
@exp('shoot_burst_clamp', 'SHOOT live view with the variant $D7E3 = 2 (corpus entry 779, 3 photos): when the countdown $D7E2 reaches 0 the next count is min(~$D561 + $1F, $D7E8) (06:64E1-64EE); with 3 photos it is 27 < $D7E8 = 30 and the clamp 06:64ED never runs, with $D561 (photo count) := 0 it is 30 = $D7E8: 06:64ED')
def shoot_burst_clamp(r):
    tg = T('06:64DD', '06:64ED'); C = lib.Corpus(CORPUS); i = C.best((20, 3)); g.set_organic(1); C.replay(i); g.run(30); r['entry'] = i; r['start'] = st()
    r['before'] = dict(D7E3=g.peek(0xD7E3), D7E2=g.peek(0xD7E2), D7E8=g.peek(0xD7E8), D561=g.peek(0xD561))
    for f in range(200):
        g.poke(0xD561, 0); g.poke(0xD7E2, 1)
        for k in range(30): g.poke(0xD563 + k, 0xFF)       # the RAM copy of the photo state vector: every slot unused
        g.run(1)
        if lib.cur()[1] != 3 and 'left_state_3' not in r and f > 5: r['left_state_3'] = [f, st()]
    r['after'] = dict(D7E2=g.peek(0xD7E2), D7E8=g.peek(0xD7E8)); r['hits'] = hit(g.cov_exec(), tg); r['end'] = st()

# ---------------------------------------------------------------- bank 0: D.J. SOUND I envelope (00:1100)
def dj_root():
    """the root state of dj_pages.py (SOUND I page of the D.J., 1F:05): route json unlock_runs/dj_route.json"""
    route = json.load(open('unlock_runs/dj_route.json')); C = lib.Corpus(route['corpus']); g.set_organic(1); C.replay(route['entry'])
    for k in route['shoot']: g.keys(k); g.run(1)
    g.keys(0); g.run(route['after_shoot_idle'])
@exp('dj_envelope', 'D.J. SOUND I page (1F:05): the envelope volume of the note about to be played is $D941 - $D8CF (00:1131-1138) and 00:1137 sets it to 0 when $D941 < $D8CF; $D8CF := $FF poked while A, Start and the arrows are pressed')
def dj_envelope(r):
    tg = T('00:1137', '00:1100'); dj_root(); r['start'] = st(); r['trials'] = []
    for key in (g.A, g.START, g.RIGHT, g.UP, g.A | g.UP, g.A | g.RIGHT, g.B):
        for f in range(60):
            g.poke(0xD8CF, 0xFF)
            g.keys(key if f % 20 < 4 else 0); g.run(1)
        r['trials'].append([key, st(), bool(hit(g.cov_exec(), tg)['00:1137'])])
        if hit(g.cov_exec(), tg)['00:1137']: break
    g.keys(0); r['hits'] = hit(g.cov_exec(), tg); r['end'] = st()

# ---------------------------------------------------------------- bank 4: erase-all confirm (mode $0F state 10) with a slide-show list that holds photo numbers
@exp('erase_all_list', 'erase-all confirmation (mode $0F state 10, 04:4D1B): A = YES runs 04:4E26, which sets every entry of the RAM copy of the slide-show list ($D681, 47 bytes) that has bit 7 clear (a photo number) to $FE (04:4E3B); the stored saves hold an empty list ($FE / $FF only). Save unl_CE10238211 patched BEFORE the boot with the list = photos 0..5 then $FF (settings checksums fixed)')
def erase_all_list(r):
    tg = T('04:4E3B', '04:4E26'); ENT = [0, 1, 2, 3, 4, 5]
    def fn(b):
        b[0x1000:0x102F] = bytes([0xFE]) * 0x2F
        for i, v in enumerate(ENT): b[0x1000 + i] = v
        b[0x1000 + len(ENT)] = 0xFF
    orig = lib.SAV; patched = patch_save(fn)
    lib.SAV = lambda name: patched if name == 'unl_CE10238211' else orig(name)
    C = lib.Corpus(CORPUS); r['trials'] = []; ex = g.cov_exec()
    for sig in ((0x0F, 2), (0x0F, 3)):                  # the erase album: Select + Start + Up shows the "erase ALL photos?" confirmation (README 8), A = YES
        i = C.best(sig)
        if i is None: continue
        g.set_organic(1); C.replay(i); g.run(30); r['start_%02X_%02X' % sig] = [i, st()]
        g.keys(g.SELECT | g.START | g.UP); g.run(6); g.keys(0); g.run(60); r['confirm'] = st()
        r['A_presses'] = []
        for _ in range(6):
            g.keys(g.A); g.run(6); g.keys(0); g.run(60); r['A_presses'].append([st(), g.peek(0xD561), g.peek(0xDBCD)])
            if hit(ex, tg)['04:4E26']: break
        h = hit(ex, tg); r['trials'].append(['%02X:%02X' % sig, i, st(), h])
        if h['04:4E3B']: break
    r['D681_after'] = bytes(g.peek(0xD681 + k) for k in range(8)).hex(' '); r['hits'] = hit(ex, tg); r['end'] = st()

@exp('dj_grid_hold', 'D.J. SOUND II wave grid (1F:0A, 05:6A82): the grid is edited only while A STAYS held (05:6A92-6A96 leaves it when A is released); with A kept held, Right moves the cell cursor $D8D0 (05:6ACC) and Up changes the cell value (05:6AE1). Joypad only, from the route of dj_pages.py: Select, Select, Up, Up, then A held for the rest of the sequence')
def dj_grid_hold(r):
    tg = T('05:6ACC', '05:6AE1', '05:6AE2'); dj_root()
    for k in (g.SELECT, g.SELECT, g.UP, g.UP): tap(k, 4, 30)
    r['start'] = st(); g.keys(g.A); g.run(20); r['seq'] = []
    for name, d in (('Right', g.RIGHT), ('Right', g.RIGHT), ('Up', g.UP), ('Down', g.DOWN), ('Left', g.LEFT)):
        g.keys(g.A | d); g.run(4); g.keys(g.A); g.run(8); r['seq'].append([name, g.peek(0xD8D0), g.peek(0xD8D1 + g.peek(0xD8D0)) if g.peek(0xD8D0) < 32 else None])
    g.keys(0); g.run(30); r['hits'] = hit(g.cov_exec(), tg); r['end'] = st()

# ---------------------------------------------------------------- every mode: out-of-range state and mode numbers
@exp('state_sweep', 'every game mode of the corpus (one entry per mode): the state number $D5CF poked to 0..255 (the state handlers are fetched from a word table with that index, so values past the end of the table jump to whatever words follow it), 8 frames each; then the mode number $D5CE poked to 0..255 from the main menu. Only WRAM bytes are written; the code reached through an out-of-range number is a table overrun, not a designed path')
def state_sweep(r):
    C = lib.Corpus(CORPUS); seen = {}
    for e in C.E.values():
        m = e['sig'][0]
        if m not in seen: seen[m] = C.best(tuple(e['sig']))
    r['modes'] = {'%02X' % m: i for m, i in sorted(seen.items())}; ex = g.cov_exec(); r['log'] = []
    for m, i in sorted(seen.items()):
        g.set_organic(1)
        try: C.replay(i); g.run(20)
        except Exception as e: r['log'].append(['%02X' % m, 'replay failed', str(e)]); continue
        base = g.snapshot(); n0 = int((np.array(ex) != 0).sum())
        for v in range(256):
            g.restore(base); g.poke(0xD5CF, v); g.run(8)
        r['log'].append(['mode %02X' % m, 'new bytes', int((np.array(ex) != 0).sum()) - n0]); print(r['log'][-1], flush=True)
    C.replay(C.best((0, 0))); g.run(20); base = g.snapshot(); n0 = int((np.array(ex) != 0).sum())
    for v in range(256):
        g.restore(base); g.poke(0xD5CE, v); g.poke(0xD5CF, 0); g.run(8)
    r['log'].append(['mode number sweep', 'new bytes', int((np.array(ex) != 0).sum()) - n0])

@exp('hotspot_sweep', 'hot spot 0 armed with every effect number 16..255 (the jump table 03:655D has 16 entries; the index is the byte $D657 of the hot-spot mirror) and a real A press, jump target $FF and sound $FF: a table overrun, as in state_sweep')
def hotspot_sweep(r):
    C = lib.Corpus(CORPUS); i = C.best((0x0C, 3)); g.set_organic(1); C.replay(i); g.run(30)
    px, py = g.peek(0xD667), g.peek(0xD668); base = g.snapshot(); ex = g.cov_exec(); n0 = int((np.array(ex) != 0).sum()); r['end_modes'] = {}
    for v in range(16, 256):
        g.restore(base)
        for n, val in ((0xD643, 1), (0xD648, px), (0xD64D, py), (0xD652, 0xFF), (0xD657, v), (0xD65C, 0xFF)): g.poke(n, val)
        lib.act((g.A, 4, 2))
        for _ in range(200):
            g.run(1)
            if g.peek(0xD5CE) != 0x0C: break
        g.run(30); r['end_modes'][v] = st()
    r['new_bytes'] = int((np.array(ex) != 0).sum()) - n0

@exp('dj_numbers', 'D.J. numbers: (1) the performance-screen values $D8B4 / $D8B5 / $D8B6 poked to 50 (the table index 3 * value + $6B at 05:5760-5768 then carries into the high byte, 05:5769; the toggle bytes $D8BA-BC are kept 0 so that the first call takes the value as index; B on a page redraws the numbers); (2) the D.J. score print (printer stand-in attached, route of printer_status.py --scenario dj) with $D9D1 (a number the print sheet writes in decimal, 05:5E5B -> 05:60BF) poked to 7, so that its hundreds digit is 0 (05:60E0)')
def dj_numbers(r):
    tg = T('05:5769', '05:60E0', '05:60D9'); dj_root(); ex = g.cov_exec()
    for f in range(480):
        for n_ in (0xD8B4, 0xD8B5, 0xD8B6): g.poke(n_, 50)
        for n_ in (0xD8BA, 0xD8BB, 0xD8BC): g.poke(n_, 0)       # the toggle bytes of 05:574C (cpl; and 1): even before the call selects the value itself as the table index
        g.keys((g.SELECT if (f // 40) % 4 < 3 else g.B) if f % 40 < 4 else 0); g.run(1)       # Select x3 to another page, B back to the SOUND I page redraws the numbers (05:578B)
    g.keys(0); r['after_perf'] = hit(ex, tg); r['perf_state'] = st()
    # (2) the print
    g.L.gb_printer_model(1)
    route = json.load(open('unlock_runs/dj_route.json')); Cp = lib.Corpus(route['corpus']); p = Cp.path(route['entry']); sp = dict(Cp.E[p[0]]['spec'])
    lib.boot(lib.SAV(sp['sav']), combo=sp['combo'], printer=1, free=sp['free'])
    for j in p[1:]:
        for x in Cp.E[j]['actions']: lib.act(x)
    for k in route['shoot']: g.keys(k); g.run(1)
    g.keys(0); g.run(route['after_shoot_idle']); lib.act((g.SELECT, 4, 60)); g.keys(g.START); g.run(8); r['before_print'] = [st(), g.peek(0xD9D1)]
    g.keys(g.START | g.A); g.run(4); g.keys(g.START); g.run(4); g.keys(0)
    for f in range(4100):
        g.poke(0xD9D1, 7); g.run(1)
    r['hits'] = hit(ex, tg); r['end'] = st()

@exp('dj_noise_hold', 'D.J. NOISE page (1F:0B, three Select from the SOUND I page): a field value stepped with A kept held and Up / Down (05:49BB): Up on a value above its minimum decrements it (05:49C4: the sound request $08 on $D92E and dec); the searches only ever pressed Up on the minimum (05:49C2 returns there). Joypad only: A kept held, Down, Down, Right, Up')
def dj_noise_hold(r):
    tg = T('05:49C2', '05:49C4'); dj_root()
    for k in (g.SELECT, g.SELECT, g.SELECT): tap(k, 4, 40)
    r['start'] = st(); g.keys(g.A); g.run(20); r['seq'] = []
    for name, d in (('Down', g.DOWN), ('Down', g.DOWN), ('Right', g.RIGHT), ('Up', g.UP)):
        g.keys(g.A | d); g.run(4); g.keys(g.A); g.run(10); r['seq'].append([name, g.peek(0xD8CC)])
    g.keys(0); g.run(30); r['hits'] = hit(g.cov_exec(), tg); r['end'] = st()

@exp('list_overrun_18', 'mode $18 state 1 or 2 (the four-slot picture picker, 06:5B2D / 5B96): the picker bound $D562 + $1E poked to 99 + $1E so that the slot values pass the 30 entries of the pointer table 02:5218; 06:5CB2 draws a slot whose table byte read past the table would have to end in $10-$17 for 06:5D3B (the carry of the source pointer) to run; no value does (negative: every value 0..$80 cycled on the four slots with Down, 06:5D0F ran, 06:5D25 and 06:5D3B not)')
def list_overrun_18(r):
    tg = T('06:5D3B', '06:5D0F', '06:5D25'); C = lib.Corpus(CORPUS); g.set_organic(1); C.replay(C.best((0x18, int(os.environ.get('S18', '1'))))); r['start'] = st(); seen = []
    r['d562'] = []
    for slot in range(4):
        for n in range(140):
            g.poke(0xD562, 99); g.keys(g.DOWN); g.run(3); g.keys(0); g.run(8)
            v = g.peek(0xD7EE + slot)
            if v not in seen: seen.append(v)
            if hit(g.cov_exec(), tg)['06:5D3B']: r['taps'] = [slot, n, v]; break
        if 'taps' in r: break
        g.keys(g.RIGHT); g.run(3); g.keys(0); g.run(8)
    r['values_seen'] = seen; r['d562'] = g.peek(0xD562)
    r['hits'] = hit(g.cov_exec(), tg); r['end'] = st()

if __name__ == '__main__':
    a = sys.argv[1:]
    if not a or a[0] == '--list':
        for k, (f, d) in EXPS.items(): print('%-18s %s' % (k, d))
        sys.exit(0)
    name, out = a[0], a[1]; os.makedirs(out, exist_ok=True)
    f, doc = EXPS[name]; r = {'experiment': name, 'doc': doc}
    f(r)
    print(name, json.dumps(r), flush=True)
    json.dump(r, open(os.path.join(out, name + '.json'), 'w'), indent=1)
    lib.dump_exec_ranges(os.path.join(out, 'exec_ranges.csv'), np.zeros(np.array(g.cov_exec()).shape, bool))
