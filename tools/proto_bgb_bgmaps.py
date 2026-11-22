#!/usr/bin/env python3
"""The three BG maps of bank $03 that the prototype never copies (BG_F_SCR, BG_EDIT, BG_EDITW), shown in BGB by the build's own loader.

  BGB_HF=-headless tools/proto_bgb_bgmaps.py PROTO_BGB.gb [--out roms/prototype_debagame/screens/forced_bg_maps_proto.png]

PROTO_BGB.gb is the header-patched copy (md5 1d8097de...; BGB only). MAKE_CONFIG (00:1275) loads the tile set Gfx_03_5A41_CONF2 to $8000
and copies $0240 bytes from Map_03_7241_BG_CONF to the BG map $9800 (`ld hl,$7241` at 00:1294). This tool writes four copies of the ROM
whose operand at 00:1295-1296 is $7241 (unchanged), $7481, $76C1 and $7AC1, runs each to the configuration screen (GAME_SEQ $09: from the
title A, Down x3, A, Start, as tools/proto_bgb_screens.py) from 128 KiB of $00, and pastes the four screenshots side by side.
The configuration code then writes its value texts over the map, as it does over BG_CONF. Evidence: C (BGB, forced: ROM patched) that
the three blocks are BG maps drawn with the configuration tile set; what each screen was for is not shown (I).
"""
import sys, os, argparse, hashlib, tempfile
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); sys.path.insert(0, os.path.join(HERE, 'jp'))
import bgb_run as B
from PIL import Image
ap = argparse.ArgumentParser(); ap.add_argument('rom')
ap.add_argument('--out', default=os.path.join(REPO, 'roms', 'prototype_debagame', 'screens', 'forced_bg_maps_proto.png')); a = ap.parse_args()
src = bytearray(open(a.rom, 'rb').read())
if hashlib.md5(src).hexdigest() != '1d8097de3497db8b182bcd2a984b6063': sys.exit('proto_bgb_bgmaps: expected the BGB copy (md5 1d8097de...)')
assert src[0x1294:0x129D] == bytes([0x21, 0x41, 0x72, 0x11, 0x00, 0x98, 0x01, 0x40, 0x02]), 'MAKE_CONFIG is not where expected'
work = tempfile.mkdtemp(prefix='proto_bgmaps_'); blank = os.path.join(work, 'blank.sav'); open(blank, 'wb').write(bytes(0x20000))
KEYS = [('A', 4, 90)] + [('Down', 4, 20)] * 3 + [('A', 4, 120), ('Start', 4, 120)]
shots = []
for v in (0x7241, 0x7481, 0x76C1, 0x7AC1):
    r = bytearray(src); r[0x1295] = v & 0xFF; r[0x1296] = v >> 8
    p = os.path.join(work, 'proto_bgmap_%04X.gb' % v); open(p, 'wb').write(r)
    res = B.run(p, blank, os.path.join(work, 'run_%04X' % v), KEYS, free=200)
    seq = res['st']['WRAM'][0xA0] if 'WRAM' in res['st'] else None
    if seq != 0x09: sys.exit('proto_bgb_bgmaps: $%04X ended on GAME_SEQ %s, not $09' % (v, seq))
    shots.append(Image.open(res['shot']).convert('RGB')); print('03:%04X -> GAME_SEQ $09, %s' % (v, res['shot']))
w, h = shots[0].size; out = Image.new('RGB', (4 * w + 30, h), 'white')
for i, im in enumerate(shots): out.paste(im, (i * (w + 10), 0))
out.resize((out.width * 2, out.height * 2), Image.NEAREST).save(a.out, optimize=True); print('wrote', a.out)
