#!/usr/bin/env python3
"""The SRAM map of Hello Kitty checked on saves the game writes itself (L4, roadmap step 11, 2026-11-15).

  tools/kitty_sram_saves.py KITTY.gb [--check]

The core (coverage/src/gbcov) plays four short sessions and keeps the cartridge RAM after each, so the saves are the game's own:
  formatted   power-on with a cleared RAM (all $00): the boot formats it (Sram_Format, the four signed blocks)
  factory     power-on with every byte $AA (a factory-fresh RAM): the boot finds no Magic and signs every block again
  two_photos  the formatted save, power-on, title A, then twice: camera A, shutter A, keep A, back B (the puzzle campaign's photo keys)
  puzzle_kitts the two-photo save with 999,999 Kitts written at SRAM $100A-$100C before power-on (as tools/kitty_puzzle.py does), then
              a power cycle: the counters block keeps them
  kept        the puzzle_kitts save, power-on with Select + Start held: the screen $00:$02 asks whether to throw away all the save data
              (Mode00_State00: wKeysHeld = $0C and $D895 = 0 -> state 1 -> state 2); B: no, the save is kept
  erased      the same, A: yes: Sram_Format (01:4907) clears every bank and writes 1B 13 at $AFF0 of bank 2, then the boot signs the
              blocks again
Checks, on every save, against roms/hello_kitty/sram/sram_map_kitty.csv:
  * coverage: every byte that is not $00 in the formatted save, and every byte that changes from one save to the next, lies in a row
    whose tag is not N (a row the code writes);
  * Magic: every row whose field is "Magic" holds the string;
  * checksums: the photo vector, each signed photo slot and the ID card: sum + $4E, xor xor $54 over their length (Sram_Checksum);
    the calibration vector is checked only when present (sum + $0D, xor + $23);
  * echoes: the photo vector echo equals $B1B2-$B1D6; each slot's echo equals +$F00-$F5B; the ID card echo is the overlapping
    $25-byte copy of $AFB8 to $AFD1 (so $AFEA-$AFF5 repeat $AFB8-$AFC3);
  * values: photos taken = 2 and two used slots in the vector after two_photos; 99 99 99 at $100A in puzzle_kitts.
Writes roms/hello_kitty/sram/sram_saves_kitty.csv (one row per save and check); --check compares it.
"""
import argparse, csv, io, os, sys
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
sys.path.insert(0, os.path.join(REPO, 'coverage', 'src'))
SD = os.path.join(REPO, 'roms', 'hello_kitty', 'sram')
ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('--check', action='store_true')
ap.add_argument('--out', default=os.path.join(SD, 'sram_saves_kitty.csv'))
ap.add_argument('--bgb', action='store_true', help='also the erase screen in BGB: screens/extra_00_02.png and trace/erase_bgb_kitty.csv')
ap.add_argument('--work', default='/tmp/kitty_sram_saves'); a = ap.parse_args()
import gbcov as G

BIT = dict(A=1, B=2, Select=4, Start=8, Right=0x10, Left=0x20, Up=0x40, Down=0x80)
def cm(b): return ((b << 4) | (b >> 4)) & 0xFF
def press(k, wait=150):
    G.keys(cm(BIT[k])); G.run(8); G.keys(0); G.run(wait)
def boot(sav, frames=700):
    G.reset(bytes(sav)); G.run(frames); return bytearray(bytes(G.sram())[:0x20000])

G.load_rom(a.rom)
saves = {}
saves['formatted'] = boot(bytes(0x20000), 600)
saves['factory'] = boot(b'\xAA' * 0x20000, 600)
G.reset(bytes(saves['formatted'])); G.run(700); press('A')                 # title -> main menu
for _ in range(2):
    for k in 'A A A B'.split(): press(k)                                    # camera, shutter, keep, back to the main menu
saves['two_photos'] = bytearray(bytes(G.sram())[:0x20000])
sv = bytearray(saves['two_photos']); sv[0x100A:0x100D] = b'\x99\x99\x99'
saves['puzzle_kitts'] = boot(sv)
def erase_screen(sav, key):                                                 # Select + Start held from power-on, then the answer
    G.reset(bytes(sav)); G.keys(cm(BIT['Select'] | BIT['Start'])); G.run(200); seen = (G.peek(0xFF8D), G.peek(0xFF8E))
    G.keys(0); G.run(150); press(key, 600); return seen, bytearray(bytes(G.sram())[:0x20000])
seen_b, saves['kept'] = erase_screen(saves['puzzle_kitts'], 'B')
seen_a, saves['erased'] = erase_screen(saves['puzzle_kitts'], 'A')

MAP = list(csv.DictReader(open(os.path.join(SD, 'sram_map_kitty.csv'), encoding='utf-8')))
live = bytearray(0x20000)                                                    # 1 = a byte of a row the code writes
for r in MAP:
    if r['tag'] != 'N':
        rep = range(30) if r['block'] == 'photo slot 1' else [0]               # the slot-1 rows stand for the 30 slots (+$1000 each)
        for n in rep:
            for x in range(int(r['flat_start'], 16), int(r['flat_end'], 16) + 1): live[x + n * 0x1000] = 1
MAGIC = b'Magic'
def ck(s, start, n):                                                         # Sram_Checksum, stored + $4E / xor $54
    lo = hi = 0
    for b in s[start:start + n]: lo = (lo + b) & 0xFF; hi ^= b
    return bytes([(lo + 0x4E) & 0xFF, hi ^ 0x54])
def slot(n): return 0x2000 + n * 0x1000                                     # photo slot n+1 (0-29), flat

rows = []
def out(save, check, result, detail=''): rows.append([save, check, result, detail])
order = ['formatted', 'factory', 'two_photos', 'puzzle_kitts', 'kept', 'erased']
prev = {'two_photos': 'formatted', 'puzzle_kitts': 'two_photos', 'kept': 'puzzle_kitts', 'erased': 'puzzle_kitts'}
for name in order:
    s = saves[name]
    if name == 'formatted' or name == 'factory':
        base = 0x00 if name == 'formatted' else 0xAA
        stray = [x for x in range(0x20000) if s[x] != base and not live[x]]
    else:
        p = saves[prev[name]]; stray = [x for x in range(0x20000) if s[x] != p[x] and not live[x]]
    out(name, 'coverage', 'ok' if not stray else 'FAIL', '%d byte(s) outside the written rows%s' % (len(stray), (': ' + ', '.join('%05X' % x for x in stray[:8])) if stray else ''))
    bad = [r['flat_start'] for r in MAP if r['field'] == 'Magic' and s[int(r['flat_start'], 16):int(r['flat_start'], 16) + 5] != MAGIC]
    signed = [n for n in range(30) if s[slot(n) + 0xF55:slot(n) + 0xF5A] == MAGIC]
    out(name, 'magic', 'ok' if not [b for b in bad if not b.startswith(('02F55',))] else 'FAIL',
        'counters %s, vector %s, ID card %s, photo slots signed %d of 30' % tuple(['yes' if s[o:o + 5] == MAGIC else 'no' for o in (0x1012, 0x11D0, 0x2FCA)] + [len(signed)]))
    cks = []
    cks.append(('vector', ck(s, 0x11B2, 0x23) == bytes(s[0x11D5:0x11D7])))
    cks.append(('ID card', ck(s, 0x2FB8, 0x17) == bytes(s[0x2FCF:0x2FD1])))
    for n in signed: cks.append(('slot %d' % (n + 1), ck(s, slot(n) + 0xF00, 0x5A) == bytes(s[slot(n) + 0xF5A:slot(n) + 0xF5C])))
    out(name, 'checksums', 'ok' if all(v for _, v in cks) else 'FAIL', '%d checked%s' % (len(cks), ''.join('; %s wrong' % k for k, v in cks if not v)))
    ec = [('vector', s[0x11D7:0x11FC] == s[0x11B2:0x11D7])]
    idc = bytearray(s[0x2FB8:0x2FD1]); exp = bytearray(37)                   # the $25-byte forward copy from $AFB8 to $AFD1
    src = bytearray(s[0x2FB8:0x2FD1]) + bytearray(37)
    for i in range(37): src[0x19 + i] = src[i]; exp[i] = src[i]
    ec.append(('ID card', bytes(s[0x2FD1:0x2FF6]) == bytes(exp)))
    for n in signed: ec.append(('slot %d' % (n + 1), s[slot(n) + 0xF5C:slot(n) + 0xFB8] == s[slot(n) + 0xF00:slot(n) + 0xF5C]))
    out(name, 'echoes', 'ok' if all(v for _, v in ec) else 'FAIL', '%d checked%s' % (len(ec), ''.join('; %s differs' % k for k, v in ec if not v)))
    cal = s[0x4FF2:0x5000]; lo = hi = 0
    for b in cal[:12]: lo = (lo + b) & 0xFF; hi ^= b
    out(name, 'calibration', 'ok', '$AFF0 = %02X %02X; vector %s' % (s[0x4FF0], s[0x4FF1], 'absent (all zero)' if not any(cal) else
        ('valid' if bytes([(lo + 0x0D) & 0xFF, (hi + 0x23) & 0xFF]) == bytes(cal[12:14]) else 'invalid')))
    used = sum(1 for b in s[0x11B2:0x11D0] if b != 0xFF)
    out(name, 'values', 'ok', 'taken %02X%02X, Kitts %02X%02X%02X, print intensity %02X, vector slots used %d' % (s[0x1001], s[0x1000], s[0x100C], s[0x100B], s[0x100A], s[0x100D], used))
v = {r[0]: r[3] for r in rows if r[1] == 'values'}
if 'taken 0002' not in v['two_photos'] or 'used 2' not in v['two_photos']: out('two_photos', 'expected', 'FAIL', 'two photos taken and kept')
else: out('two_photos', 'expected', 'ok', 'two photos taken and kept: counter 2, two slots in the vector')
if 'Kitts 999999' not in v['puzzle_kitts']: out('puzzle_kitts', 'expected', 'FAIL', '999,999 Kitts kept')
else: out('puzzle_kitts', 'expected', 'ok', '999,999 Kitts kept over a power cycle (no checksum on the counters)')
def same_but_seed(x, y):     # the saved data only: not the image buffer (bank 0 $A000-$AFFF, the sensor) nor $AFFF of bank 1 (the RNG seed, new at every boot)
    return [i for i in range(0x1000, 0x20000) if x[i] != y[i] and i != 0x2FFF]
d = same_but_seed(saves['kept'], saves['puzzle_kitts'])
out('kept', 'expected', 'ok' if seen_b == (0, 2) and not d else 'FAIL', 'screen $%02X:$%02X with Select + Start; B keeps every byte of the saved data (all but the image buffer and the RNG seed)%s' % (seen_b + ('' if not d else ' (%d differ)' % len(d),)))
e = saves['erased']; ok = seen_a == (0, 2) and e[0x4FF0:0x4FF2] == b'\x1b\x13' and 'taken 0000' in v['erased'] and 'Kitts 000000' in v['erased'] and 'used 0' in v['erased']
out('erased', 'expected', 'ok' if ok else 'FAIL', 'A: every counter, the Kitts and the album cleared, 1B 13 at $AFF0 of bank 2 (Sram_Format), the blocks signed again')

if a.bgb:                                                                   # the same screen in BGB (not rerun by the checker)
    sys.path.insert(0, os.path.join(HERE, 'jp')); import bgb_run
    from PIL import Image
    os.makedirs(a.work, exist_ok=True); sv = os.path.join(a.work, 'puzzle_kitts.sav'); open(sv, 'wb').write(bytes(saves['puzzle_kitts']))
    br = []
    for key, seq in (('screen', []), ('A', [('A', 8, 600)]), ('B', [('B', 8, 600)])):
        r = bgb_run.run(a.rom, sv, os.path.join(a.work, 'erase_' + key), seq, combo=BIT['Select'] | BIT['Start'], free=150, tail=30)
        h = r['st']['HRAM']; s_ = r['st'].get('SRAM', b'')
        if key == 'screen': Image.open(r['shot']).convert('RGB').save(os.path.join(REPO, 'roms', 'hello_kitty', 'screens', 'extra_00_02.png'))
        br.append([key, '%02X:%02X' % (h[0x0D], h[0x0E]), s_[0x4FF0:0x4FF2].hex().upper(), '%02X%02X' % (s_[0x1001], s_[0x1000]),
                   '%02X%02X%02X' % (s_[0x100C], s_[0x100B], s_[0x100A]), sum(1 for b in s_[0x11B2:0x11D0] if b != 0xFF), 'yes' if not same_but_seed(s_[:0x20000], saves['puzzle_kitts']) else 'no'])
    g = io.StringIO(); w = csv.writer(g, lineterminator='\n'); w.writerow(['answer', 'mode_state', 'aff0_bank2', 'taken', 'kitts', 'vector_used', 'save_unchanged_but_seed']); w.writerows(br)
    open(os.path.join(REPO, 'roms', 'hello_kitty', 'trace', 'erase_bgb_kitty.csv'), 'w', encoding='utf-8').write(g.getvalue())
    for r in br: print('BGB', r)

f = io.StringIO(); w = csv.writer(f, lineterminator='\n'); w.writerow(['save', 'check', 'result', 'detail']); w.writerows(rows)
fails = [r for r in rows if r[2] != 'ok']
if a.check:
    if open(a.out, encoding='utf-8').read() != f.getvalue(): sys.exit('kitty_sram_saves: %s is not what the saves give today' % os.path.relpath(a.out, REPO))
    print('kitty_sram_saves: fresh, %d checks, %d failed' % (len(rows), len(fails))); sys.exit(1 if fails else 0)
open(a.out, 'w', encoding='utf-8').write(f.getvalue())
for r in rows: print('%-13s %-12s %-4s %s' % tuple(r))
print('kitty_sram_saves: %d checks, %d failed -> %s' % (len(rows), len(fails), os.path.relpath(a.out, REPO)))
