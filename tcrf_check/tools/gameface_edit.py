#!/usr/bin/env python3
"""Run in my core (joypad only, a save file edit and no RAM poke) the code behind the hidden third choice of the Game Face page, 06:48E6-48FB, and what it leads to (README 16.19).
On the page 16:06 (MAGIC -> GAME FACE) Select+Down moves the cursor to item 2 and A on it runs 06:48CB: far call 02:506A (copies SRAM $B0D1 to $D581 and, when it is set, the Game Face
image $B1FC-$BFFB to $C000), then `ld a,[$D581] ; and a ; jr nz,$48E6`.  With a Game Face stored the 22 B at 06:48E6 run: `$D800 := 1` (the extras / Game Face launch flag), mode 4, state 0.
The save-back of the editor (07:6A43) then takes 07:6A58 (`call 02:4C37`, the Game Face writer) instead of 07:6A4E (`call 02:47C4`, the photo writer).
usage: gameface_edit.py OUTDIR [--no-face] [--face-from SAVNAME] [--depth N] [--cap N]      (run from the working root; corpus unlock_runs/f1_organic/corpus.jsonl entry 2186 = MAGIC menu 16:01)
  Entry 2186 starts from the blank save `_ff` (all $FF), which the game formats at boot: a file patched before the boot would be formatted again, so the SRAM is edited in the core once the game
  sits at the MAGIC menu, before the first key.  The edit is what a Game Face leaves in the SRAM (README 3.2): both settings copies ($1000 and $10D9, 0xD7 data bytes + 2 checksum bytes) get the flag
  $10D1 / $11AA = 1, and the 3584 B of the image of slot 1 of the save --face-from (default unl_CE10238211, a real unlocking save with photos; slot bytes 000-DFF) are copied to $11FC-$1FFB.
  The game reads $B0D1 and the image afresh when A is pressed (02:506A), so this is the same as a save file that held a Game Face.  --no-face leaves the SRAM as the game formatted it (control).
  --chords  the BFS also presses the 26 two-key chords (the corpus reaches the pen-tool exit with A+B and A+Select);  --wait N  frames released after each key (default 30)
  Path: Right, B, Down, A (16:06), Down, Select+Down, A; then every key (BFS, key held 4 frames, 30 released, key = (mode, state, md5 of $D5D0-$D5FF, $D800)) until 07:6A58 runs.
Writes OUTDIR/gameface_edit.json (state after each step, flags, targets hit) and OUTDIR/exec_ranges.csv (every byte executed in this process; witness_map.py intersects it with the never-run code)."""
import sys, os, json, hashlib
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g
import blocks as B
import sram_analyze as S
a = sys.argv[1:]
def flag(n):
    if n in a: a.remove(n); return True
    return False
def opt(n, d):
    if n in a: i = a.index(n); v = a[i + 1]; del a[i:i + 2]; return v
    return d
CHORDS = flag('--chords'); WAIT = int(opt('--wait', '30'))
NOFACE = flag('--no-face'); depth = int(opt('--depth', '8')); cap = int(opt('--cap', '1500'))
out = a[0]; os.makedirs(out, exist_ok=True)
FACE_FROM = opt('--face-from', 'unl_CE10238211')
def patch_sram():
    b = bytearray(bytes(g.sram()))
    donor = lib.SAV(FACE_FROM); b[0x11FC:0x11FC + 0xE00] = donor[S.slot_base(1):S.slot_base(1) + 0xE00]
    for off in (0x1000, 0x10D9):
        b[off + 0xD1] = 1
        b[off + 0xD7:off + 0xD9] = S.ck(b, off, 0xD7)
    assert S.status(bytes(b))['settings'] == (True, True), 'the settings blocks of the formatted SRAM are not valid'
    g.sram()[0x1000:0x2000] = np.frombuffer(bytes(b[0x1000:0x2000]), np.uint8)
    return bytes(b[0x11FC:0x11FC + 0xE00])
KN = ['Right', 'Left', 'Up', 'Down', 'A', 'B', 'Select', 'Start']
KEY = dict(Right=g.RIGHT, Left=g.LEFT, Up=g.UP, Down=g.DOWN, A=g.A, B=g.B, Select=g.SELECT, Start=g.START)
C = lib.Corpus('unlock_runs/f1_organic/corpus.jsonl'); g.set_organic(1)
ex = g.cov_exec()
T = {'06:48CB': B.flat(6, 0x48CB), '06:48E6': B.flat(6, 0x48E6), '06:48F6': B.flat(6, 0x48F6), '07:6A58': B.flat(7, 0x6A58), '02:4C37': B.flat(2, 0x4C37), '02:5078': B.flat(2, 0x5078)}
if CHORDS:      # the eight keys and the 26 two-key chords (all pairs but Left+Right and Up+Down), as dj_pages.py
    import itertools
    for x, y in itertools.combinations(list(KN), 2):
        if {x, y} in ({'Left', 'Right'}, {'Up', 'Down'}): continue
        KEY[x + '+' + y] = KEY[x] | KEY[y]
    KN = list(KEY)
def tap(k, hold=4, wait=None): g.keys(k); g.run(hold); g.keys(0); g.run(WAIT if wait is None else wait)
def st(): return '%02X:%02X' % lib.cur()
def hits(): return {k: int(ex[v]) > 0 for k, v in T.items()}
res = {'face': not NOFACE, 'face_from': None if NOFACE else FACE_FROM, 'steps': []}
C.replay(2186)
assert g.peek(0xD581) == 0 and bytes(g.sram())[0x10D1] == 0, 'expected a formatted save without Game Face'
patched_face = None if NOFACE else patch_sram()
res['flag_10D1'] = int(bytes(g.sram())[0x10D1])
res['start'] = st(); print('start', st(), 'D581', g.peek(0xD581), flush=True)
for name, k in (('Right', g.RIGHT), ('B', g.B), ('Down', g.DOWN), ('A', g.A), ('Down', g.DOWN), ('Select+Down', g.SELECT | g.DOWN), ('A', g.A)):
    tap(k)
    r = {'key': name, 'state': st(), 'D5EB': g.peek(0xD5EB), 'D581': g.peek(0xD581), 'D800': g.peek(0xD800), 'hits': hits()}
    res['steps'].append(r); print(r, flush=True)
res['after_path'] = {'state': st(), 'D800': g.peek(0xD800), 'D581': g.peek(0xD581), 'C000_nonzero': sum(1 for x in range(0xC000, 0xCE00) if g.peek(x)), 'hits': hits()}
print('after path:', res['after_path'], flush=True)
def key(): return (lib.cur(), hashlib.md5(bytes(g.peek(x) for x in range(0xD5D0, 0xD600))).hexdigest(), g.peek(0xD800))
found = None
if res['after_path']['hits']['06:48E6'] and not res['after_path']['hits']['07:6A58']:
    seen = {key()}; frontier = [((), g.snapshot())]; n = 0; log = []
    for d in range(depth):
        nxt = []
        for path, snap in frontier:
            for kn in KN:
                g.restore(snap); tap(KEY[kn]); p = path + (kn,)
                if ex[T['07:6A58']] > 0: found = list(p); break
                kk = key()
                if kk in seen: continue
                seen.add(kk); n += 1; log.append((' '.join(p), st(), g.peek(0xD800)))
                if n < cap: nxt.append((p, g.snapshot()))
            if found: break
        frontier = nxt
        if found or not frontier: break
    res['bfs'] = {'states': n, '07:6A58_after': found, 'seen': log}
    print('BFS from the edited Game Face:', res['bfs'], flush=True)
if found:      # the core stopped right after the key that ran 07:6A58: look at what the game's own Game Face writer left in the SRAM
    sr = bytes(g.sram()); wb = bytes(g.peek(x) for x in range(0xC000, 0xCE00))
    res['after_save_back'] = {'state': st(), 'settings_blocks_valid': list(S.status(sr)['settings']), 'flag_10D1': sr[0x10D1], 'flag_11AA': sr[0x11AA],
                              'face_image_equals_work_buffer_C000': sr[0x11FC:0x11FC + 0xE00] == wb, 'face_image_changed_since_patch': sr[0x11FC:0x11FC + 0xE00] != patched_face}
    print('after the Game Face save-back:', res['after_save_back'], flush=True)
res['final_hits'] = hits()
print('final hits:', res['final_hits'])
json.dump(res, open(out + '/gameface_edit.json', 'w'), indent=1)
lib.dump_exec_ranges(out + '/exec_ranges.csv', np.zeros(np.array(g.cov_exec()).shape, bool))
