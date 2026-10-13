#!/usr/bin/env python3
"""Show data that no code loads, on the real BGB: patch the Japanese ROM so that it boots straight into a tiny routine (placed in the 0x00 padding of bank 0 at $3600,
entry $0100 = JP $3600) that waits for VBlank, switches the LCD off, copies ROM blocks to VRAM, sets LCDC / SCX / SCY / BGP and loops forever (interrupts off); BGB then renders the frame
(headless, wine, `bgb_run.run`) and the screenshot is converted to PNG.  Evidence class C for what BGB draws; what the game would use as palette is not known, so BGP = $E4 (plain) by default.
usage: bgb_show_unused.py ROM OUT.png --copy BANK:SRC:DST:LEN[,BANK:SRC:DST:LEN...] [--lcdc 91] [--scx 0] [--scy 0] [--bgp E4] [--frames 120]
  numbers are hexadecimal; e.g. --copy 17:5500:8000:1300,25:7814:9800:240 --scx 96   (the map 25:7814 keeps its picture in columns 12-31: SCX = 12 * 8 = 96, decimal)
Environment: BGB_DIR (a BGB folder, default /home/claude/bgbx), RGBDS in PATH or /home/claude/tc/rgbds."""
import sys, os, subprocess, tempfile, shutil
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
args = sys.argv[1:]
def opt(name, default=None):
    if name in args:
        i = args.index(name); v = args[i + 1]; del args[i:i + 2]; return v
    return default
copies = opt('--copy'); lcdc = int(opt('--lcdc', '91'), 16); scx = int(opt('--scx', '0'), 0); scy = int(opt('--scy', '0'), 0); bgp = int(opt('--bgp', 'E4'), 16)
frames = int(opt('--frames', '120'))
rom_path, out_png = args[0], args[1]
cps = [tuple(int(x, 16) for x in c.split(':')) for c in copies.split(',')]
asm = ['SECTION "show", ROM0[$3600]', 'Show:', '  di', '.v: ldh a,[$FF44]', '  cp $90', '  jr c,.v', '  xor a', '  ldh [$FF40],a']
for n, (b, src, dst, ln) in enumerate(cps):
    asm += ['  ld a,$%02X' % b, '  ld [$2000],a', '  ld hl,$%04X' % src, '  ld de,$%04X' % dst, '  ld bc,$%04X' % ln,
            '.c%d: ld a,[hl+]' % n, '  ld [de],a', '  inc de', '  dec bc', '  ld a,b', '  or c', '  jr nz,.c%d' % n]
asm += ['  ld a,$%02X' % bgp, '  ldh [$FF47],a', '  ld a,$%02X' % (scx & 255), '  ldh [$FF43],a', '  ld a,$%02X' % (scy & 255), '  ldh [$FF42],a', '  ld a,$%02X' % lcdc, '  ldh [$FF40],a', '.h: jr .h']
tmp = tempfile.mkdtemp(prefix='show_'); env = dict(os.environ); env['PATH'] = '/home/claude/tc/rgbds:' + env['PATH']
open(tmp + '/s.asm', 'w').write('\n'.join(asm) + '\n')
subprocess.check_call(['rgbasm', '-o', tmp + '/s.o', tmp + '/s.asm'], env=env)
subprocess.check_call(['rgblink', '-x', '-o', tmp + '/s.bin', tmp + '/s.o'], env=env)   # -x: pad to $4000 (bank 0 only)
code = open(tmp + '/s.bin', 'rb').read()[0x3600:0x3600 + 400]
rom = bytearray(open(rom_path, 'rb').read())
assert all(v == 0 for v in rom[0x3600:0x3600 + len(code.rstrip(b'\0'))]), 'bank-0 padding at $3600 is not free'
n = len(code.rstrip(b'\0')); rom[0x3600:0x3600 + n] = code[:n]
rom[0x100:0x104] = bytes([0xC3, 0x00, 0x36, 0x00])
patched = tmp + '/patched.gb'; open(patched, 'wb').write(rom)
import bgb_run
r = bgb_run.run(patched, None, tmp + '/run', [('-', 1, frames)], free=60, tail=30)
from PIL import Image
im = Image.open(r['shot']).convert('RGB'); im.save(out_png)
print('rc', r['rc'], 'PC', r['pc'] and hex(r['pc']), 'size', im.size, '->', out_png)
shutil.rmtree(tmp, ignore_errors=True)
