#!/usr/bin/env python3
"""Experiment of README 16.25.4: what does the shipped main-menu code do when the UNUSED one-page main menu (map 25:7814, tiles 17:5500) is on screen instead of the shipped picture?

A copy of the Japanese ROM is patched in two places: the `call Pal_AllWhite` of Mode00_State00_Init (07:723A, `CD 10 0D`) becomes `CD 00 36`, and a hook in the bank-0 padding at $3600 copies
17:5500 (tiles 0-127 to $9000, 128-255 to $8800: the game's LCDC has bit 4 = 0, so BG tile ids are signed from $9000) and the map 25:7814 shifted left by 12 columns (the picture lives in map columns 12-31;
the 12 bytes after the map are `$29`, the blank tile, so a ring shift needs no scroll register) to $9800, then jumps to Pal_AllWhite.  Everything else is the shipped code, so what the buttons do
is the SHIPPED menu logic acting on the wrong picture: this shows whether the seven boxes line up with the seven shipped items, NOT how the unused menu would have worked (C for what BGB draws, nothing more).

usage: bgb_unused_menu_try.py ROM SAVE OUTDIR [--plain] SCENARIO[,SCENARIO...]
  SCENARIO = name=KEYS:hold:wait/KEYS:hold:wait/...   (keys joined with +; the sequence starts when the main menu is up: boot hold 250 + free 433 frames, then A:6:200 to leave the Mario greeting)
  --plain: do not patch (the shipped menu, same timing)
Writes OUTDIR/<name>.png and prints the (mode, state) read from the BGB state file.  Environment: BGB_DIR."""
import sys, os, subprocess, tempfile, shutil
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
args = sys.argv[1:]
plain = '--plain' in args
if plain: args.remove('--plain')
rom_path, sav, outdir, scen = args[0], args[1], args[2], args[3]
os.makedirs(outdir, exist_ok=True)
rom = bytearray(open(rom_path, 'rb').read())
if not plain:
    asm = ['SECTION "hook", ROM0[$3600]', 'Hook:']
    for bank, src, dst, ln in ((0x17, 0x5500, 0x9000, 0x800), (0x17, 0x5D00, 0x8800, 0x800), (0x25, 0x7820, 0x9800, 0x240)):
        asm += ['  ld a,$%02X' % bank, '  ld hl,$%04X' % src, '  ld de,$%04X' % dst, '  ld bc,$%04X' % ln, '  call $0450']
    asm += ['  jp $0D10']
    tmp = tempfile.mkdtemp(prefix='umenu_'); env = dict(os.environ); env['PATH'] = '/home/claude/tc/rgbds:' + env['PATH']
    open(tmp + '/h.asm', 'w').write('\n'.join(asm) + '\n')
    subprocess.check_call(['rgbasm', '-o', tmp + '/h.o', tmp + '/h.asm'], env=env)
    subprocess.check_call(['rgblink', '-x', '-o', tmp + '/h.bin', tmp + '/h.o'], env=env)
    code = open(tmp + '/h.bin', 'rb').read()[0x3600:0x3600 + 200].rstrip(b'\0')
    assert all(v == 0 for v in rom[0x3600:0x3600 + len(code)]), 'bank-0 padding at $3600 is not free'
    rom[0x3600:0x3600 + len(code)] = code
    site = 7 * 0x4000 + (0x723A - 0x4000)
    assert rom[site:site + 3] == bytes([0xCD, 0x10, 0x0D]), 'expected call Pal_AllWhite at 07:723A'
    rom[site:site + 3] = bytes([0xCD, 0x00, 0x36])
    shutil.rmtree(tmp, ignore_errors=True)
work = tempfile.mkdtemp(prefix='umenu_run_'); patched = work + '/rom.gb'; open(patched, 'wb').write(rom)
import bgb_run
from PIL import Image
for sc in scen.split(','):
    name, _, seq = sc.partition('=')
    items = [('A', 6, 200)] + ([tuple((a, int(b), int(c)) for a, b, c in [it.split(':')])[0] for it in seq.split('/')] if seq else [])
    r = bgb_run.run(patched, sav, work + '/' + name, items, combo=0, free=433, tail=2)
    Image.open(r['shot']).convert('RGB').save(os.path.join(outdir, name + '.png'))
    print('%-14s mode:state %s:%s  da16(item)=%s' % (name, r['mode'] if r['mode'] is None else '%02X' % r['mode'], r['state'] if r['state'] is None else '%02X' % r['state'],
          (r['st'].get('WRAM', b'')[0x1A16] if r['st'].get('WRAM') else None)), flush=True)
shutil.rmtree(work, ignore_errors=True)
