#!/usr/bin/env python3
"""Hello Kitty L4 (roadmap step 11, 2026-11-15): every RAM, SRAM and constant file of the ROM, in dependency order, with one command.

  tools/kitty_l4.py KITTY.gb JP.gb [--check]

  1. tools/wram_db.py         -> roms/hello_kitty/wram/wram_access_kitty.csv, wram_summary_kitty.csv (every proven WRAM / HRAM / I/O site)
  2. tools/sram_db.py         -> roms/hello_kitty/sram/sram_access_kitty.csv (every proven SRAM site)
  3. tools/kitty_ram_names.py -> disasm/ram_names_kitty.csv (hand layer disasm/layers/ram_names_kitty_hand.csv, the Japanese names
                                 through paired sites, then routine + address)
  4. tools/ram_names.py       -> disasm/ram_kitty.inc, pocketcamera_kitty_ram.sym
  5. tools/sram_map.py --tag kitty -> sram/INDEX.md (checks sram/sram_map_kitty.csv, the hand map, against the access sites)
  6. tools/kitty_const_names.py -> disasm/const_names_kitty.csv, state_names_kitty.csv, sound_names_kitty.csv, const_types_kitty.csv,
                                 const_kitty.inc
  7. tools/kitty_sram_saves.py -> sram/sram_saves_kitty.csv (the SRAM map on six saves the game writes in the core)
  8. this script              -> wram/INDEX.md (what the folder holds and the figures of the RAM names)
--check runs each step in its check mode (or compares a fresh copy) and exits 1 on the first stale file; the consistency checker runs it.
"""
import argparse, collections, csv, os, shutil, subprocess, sys, tempfile
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); KD = os.path.join(REPO, 'roms', 'hello_kitty')
ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('jp'); ap.add_argument('--check', action='store_true'); a = ap.parse_args()
PY = sys.executable; CK = ['--check'] if a.check else []
def run(cmd):
    r = subprocess.run(cmd, cwd=REPO, capture_output=True, text=True)
    if r.returncode: sys.exit('kitty_l4: %s failed:\n%s' % (' '.join(os.path.basename(c) for c in cmd[1:3]), (r.stdout + r.stderr).strip()[-2000:]))
    return r.stdout.strip()
def same_or_copy(src, dst):
    t = open(src, encoding='utf-8').read()
    if a.check:
        if not os.path.exists(dst) or open(dst, encoding='utf-8').read() != t: sys.exit('kitty_l4: stale %s' % os.path.relpath(dst, REPO))
    else: open(dst, 'w', encoding='utf-8', newline='\n').write(t)

tmp = tempfile.mkdtemp(prefix='kitty_l4_')
TR, SYM = os.path.join(KD, 'trace', 'trace_kitty.json'), os.path.join(KD, 'pocketcamera_kitty.sym')
run([PY, 'tools/wram_db.py', a.rom, TR, SYM, os.path.join(tmp, 'w')])
same_or_copy(os.path.join(tmp, 'w_access.csv'), os.path.join(KD, 'wram', 'wram_access_kitty.csv'))
same_or_copy(os.path.join(tmp, 'w_summary.csv'), os.path.join(KD, 'wram', 'wram_summary_kitty.csv'))
run([PY, 'tools/sram_db.py', a.rom, TR, SYM, os.path.join(tmp, 's.csv')])
same_or_copy(os.path.join(tmp, 's.csv'), os.path.join(KD, 'sram', 'sram_access_kitty.csv'))
print(run([PY, 'tools/kitty_ram_names.py', a.rom, a.jp] + CK))
print(run([PY, 'tools/ram_names.py', '--names', 'roms/hello_kitty/disasm/ram_names_kitty.csv', '--inc', 'roms/hello_kitty/disasm/ram_kitty.inc',
           '--sym', 'roms/hello_kitty/pocketcamera_kitty_ram.sym'] + CK) or 'ram_names: fresh')
print(run([PY, 'tools/sram_map.py', '--tag', 'kitty'] + CK))
print(run([PY, 'tools/kitty_const_names.py', a.rom] + CK))
print(run([PY, 'tools/kitty_sram_saves.py', a.rom] + CK).splitlines()[-1])

# ---- wram/INDEX.md
acc = list(csv.DictReader(open(os.path.join(KD, 'wram', 'wram_access_kitty.csv'), encoding='utf-8')))
names = list(csv.DictReader(open(os.path.join(KD, 'disasm', 'ram_names_kitty.csv'), encoding='utf-8')))
hand = list(csv.DictReader(open(os.path.join(KD, 'disasm', 'layers', 'ram_names_kitty_hand.csv'), encoding='utf-8')))
HN = {h['name'] for h in hand}
k = collections.Counter(r['kind'] for r in acc)
addrs = {int(r['addr'], 16) for r in acc}; ram = {x for x in addrs if 0xC000 <= x < 0xE000 or 0xFF80 <= x < 0xFFFF}
src = collections.Counter('hand' if r['name'] in HN else ('jp' if r['desc'].startswith('the Japanese') else 'auto') for r in names)
tag = collections.Counter(r['tag'] for r in names)
w = sum(1 for r in names if int(r['addr'], 16) < 0xFF00); h = len(names) - w
md = ['# wram/ - WRAM and HRAM of Pocket Camera Hello Kitty (Japan)', '',
      '| File | Content |', '|---|---|',
      '| `wram_access_kitty.csv` | every proven access site to `$C000-$DFFF`, `$FF00-$FF7F`, `$FF80-$FFFE` (%d rows; `tools/wram_db.py` on `trace/trace_kitty.json`; kinds R %d, W %d, P %d) |' % (len(acc), k['R'], k['W'], k['P']),
      '| `wram_summary_kitty.csv` | one row per address (%d addresses, %d of them WRAM / HRAM): reads, writes, pointer loads, banks, routines, written constants |' % (len(addrs), len(ram)), '',
      'Written by `tools/kitty_l4.py` (roadmap step 11, 2026-11-15), with the names, the SRAM files and the constants; never edit these files by hand.', '',
      '**Names** (`disasm/ram_names_kitty.csv`, %d rows: WRAM %d, HRAM %d; tag C %d, I %d; `tools/kitty_ram_names.py`):' % (len(names), w, h, tag['C'], tag['I']), '',
      '* %d by hand (`disasm/layers/ram_names_kitty_hand.csv`, each with its evidence): the mode and state, the keys (named as the Japanese ROM names its own: `wKeysHeld`, `wKeysNew`, `wKeysNewRepeat`, `wKeyRepeatDelay` ...), the LCD shadows the VBlank handler copies (`wLcdcShadow` ... `wLycShadow`), the fade (`wPaletteTarget`, `wFadeLevel`), the OAM shadow and the VRAM queue, the 15 puzzle, the counters block that mirrors SRAM `$B000-$B011` (`wCountTaken` ... `wKitts`, `wPuzzleDrawingsDone`, `wNameCardMade`), the ID card, the name card photos and the photo tag (`wSlotTag*`, the offsets of the Japanese tag);' % src['hand'],
      '* %d from the Japanese ROM: an access site of this ROM pairs with a Japanese site of the same kind (`disasm/match_jp_kitty.csv`: same code; `disasm/similar_jp_kitty.csv`: an aligned copy) and the Japanese name of that address is taken, at the start most paired sites give; tag C when the code is the same, no other name shares the bytes and every paired site agrees (the sound engine, the printer and link drivers, the camera registers, the RNG);' % src['jp'],
      '* %d named after the routine that touches the address most, `w` / `h` + routine + address (`wMode14_State01_D8ED`), tag I: to be named when their routines are read.' % src['auto'], '',
      'Derived: `disasm/ram_kitty.inc` (`DEF ... EQU`) and `pocketcamera_kitty_ram.sym` (`tools/ram_names.py`). The constants of the values these variables hold (modes, states, keys, palettes, sound ids) are in `disasm/const_*_kitty.csv` and `disasm/const_kitty.inc`.']
t = '\n'.join(md) + '\n'; idx = os.path.join(KD, 'wram', 'INDEX.md')
if a.check:
    if not os.path.exists(idx) or open(idx, encoding='utf-8').read() != t: sys.exit('kitty_l4: stale roms/hello_kitty/wram/INDEX.md')
else: open(idx, 'w', encoding='utf-8', newline='\n').write(t)
shutil.rmtree(tmp, ignore_errors=True)
print('kitty_l4: %s' % ('fresh' if a.check else 'written'))
