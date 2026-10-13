#!/usr/bin/env python3
"""BGB check of the image-exchange screen (mode $0E, states 06-10): what is in VRAM, and is the unreferenced 14:4000 / 23:5CC0 set ever loaded?  README 14 and 16.24 "(3)".

Input: the end-of-run files of two BGB-to-BGB exchanges (tcrf_check/tools/bgb_link.py, README 14), one per ROM, e.g.
  bgb_link.py pocketcamera_jp.gb link_protocol/saves/flow1_A_sender_before.sav link_protocol/saves/flow1_B_receiver_before.sav OUT/jp 450
  bgb_link.py gbcam_usa_eu.gb    (the same two saves)                                                                          OUT/intl 250
(WAIT 100-450 frames after the confirm = states $08 / $10; each run writes OUT/jp_sender.sna / .bmp ...).  For each sender state file the tool compares BGB's VRAM with the ROM
sources that Mode0E_State06_ExchangeSetup copies (bank $15 $6C00 / $7400 / $7C00 to $9000 / $8800 / $8000, bank $24 $5180 to $9800, bank $24 $53C0 to $9C00; the international ROM's second map is at 22:6340) and with the
unreferenced set 14:4000 (tiles) / 23:5CC0 (map), and draws the two BGB screenshots next to the unreferenced screen.
It also writes OUT_same_palette.png beside OUT.png: the Japanese shipped stand-by screen (BG layer rebuilt from BGB's VRAM, no sprites) and the unused set, both in the plain palette.
usage: exchange_screens_check.py JP_ROM JP_PREFIX INTL_ROM INTL_PREFIX OUT.png"""
import sys, os
import numpy as np
from PIL import Image, ImageDraw
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import bgb_run
jp_rom, jp_pre, in_rom, in_pre, out = sys.argv[1:6]
def off(b, a): return b * 0x4000 + (a - 0x4000)
def same(x, y): return float((np.asarray(x) == np.asarray(y)).mean())
def check(label, romf, pre):
    rom = np.frombuffer(open(romf, 'rb').read(), np.uint8)
    st = bgb_run.read_state(pre + '_sender.sna'); v = np.frombuffer(st['VRAM'], np.uint8)[:0x2000]; w = st['WRAM']
    print('%s: sender mode:state %02X:%02X' % (label, w[0x15CE], w[0x15CF]))
    s = lambda b, a, n: rom[off(b, a):off(b, a) + n]
    print('   VRAM $9000 = bank15:6C00 %.3f | $8800 = 15:7400 %.3f | $8000 (OBJ) = 15:7C00 %.3f | map $9800 = 24:5180 %.3f | map $9C00 = 24:53C0 %.3f / 22:6340 %.3f' % (
        same(v[0x1000:0x1800], s(0x15, 0x6C00, 0x800)), same(v[0x800:0x1000 - 0x100], s(0x15, 0x7400, 0x700)), same(v[:0x400], s(0x15, 0x7C00, 0x400)),
        same(v[0x1800:0x1A40], s(0x24, 0x5180, 0x240)), same(v[0x1C00:0x1D00], s(0x24, 0x53C0, 0x100)), same(v[0x1C00:0x1D00], s(0x22, 0x6340, 0x100))))
    print('   unreferenced set: $9000 vs 14:4000 %.3f | $8800 vs 14:4800 %.3f | map $9800 vs 23:5CC0 %.3f' % (
        same(v[0x1000:0x1800], s(0x14, 0x4000, 0x800)), same(v[0x800:0x1000], s(0x14, 0x4800, 0x800)), same(v[0x1800:0x1A40], s(0x23, 0x5CC0, 0x240))))
    return rom
rj = check('Japanese', jp_rom, jp_pre); ri = check('International', in_rom, in_pre)
a = open(jp_rom, 'rb').read(); b = open(in_rom, 'rb').read()
print('14:4000-502F identical in both ROMs:', a[off(0x14, 0x4000):off(0x14, 0x4000) + 0x1030] == b[off(0x14, 0x4000):off(0x14, 0x4000) + 0x1030],
      '| 23:5CC0-5F03 identical:', a[off(0x23, 0x5CC0):off(0x23, 0x5CC0) + 580] == b[off(0x23, 0x5CC0):off(0x23, 0x5CC0) + 580])
# the unreferenced screen, drawn with the plain palette (colour 0 white ... 3 black; the game's own palette for it is unknown)
M = rj[off(0x23, 0x5CC0):off(0x23, 0x5CC0) + 576].reshape(18, 32)
def tile(i):
    o = off(0x14, 0x4000) + 16 * int(i); t = np.zeros((8, 8), np.uint8)
    for y in range(8):
        b0, b1 = int(rj[o + 2 * y]), int(rj[o + 2 * y + 1])
        for x in range(8): t[y, x] = ((b1 >> (7 - x)) & 1) << 1 | ((b0 >> (7 - x)) & 1)
    return t
img = np.zeros((144, 160), np.uint8)
for r in range(18):
    for c in range(20): img[r * 8:r * 8 + 8, c * 8:c * 8 + 8] = tile(M[r, c])
GREY = np.array([255, 170, 85, 0], np.uint8)
panels = [('Japanese ROM, BGB, exchange (mode 0E:08), sender', Image.open(jp_pre + '_sender.bmp').convert('L')),
          ('international ROM, BGB, exchange (mode 0E:08), sender', Image.open(in_pre + '_sender.bmp').convert('L')),
          ('14:4000 tiles + 23:5CC0 map (both ROMs): never loaded', Image.fromarray(GREY[img]))]
SC = 3; W = 160 * SC; c = Image.new('L', (3 * W + 4 * 10, 144 * SC + 40), 200); d = ImageDraw.Draw(c)
for i, (t, p) in enumerate(panels):
    x = 10 + i * (W + 10); d.text((x, 6), t, fill=0); c.paste(p.resize((W, 144 * SC), Image.NEAREST), (x, 24))
c.save(out); print(out, c.size)
# same-palette comparison: BG layer of the Japanese stand-by screen from BGB's VRAM (map $9800, LCDC.4 = 0 addressing) against the unused set
stj = bgb_run.read_state(jp_pre + '_sender.sna'); vj = np.frombuffer(stj['VRAM'], np.uint8)[:0x2000]
def vtile(i):
    a = (0x9000 + 16 * i if i < 128 else 0x8800 + 16 * (i - 128)) - 0x8000; t = np.zeros((8, 8), np.uint8)
    for y in range(8):
        b0, b1 = int(vj[a + 2 * y]), int(vj[a + 2 * y + 1])
        for x in range(8): t[y, x] = ((b1 >> (7 - x)) & 1) << 1 | ((b0 >> (7 - x)) & 1)
    return t
vm = vj[0x1800:0x1A40].reshape(18, 32); ship = np.zeros((144, 160), np.uint8)
for r in range(18):
    for cc in range(20): ship[r * 8:r * 8 + 8, cc * 8:cc * 8 + 8] = vtile(int(vm[r, cc]))
SC2 = 4; W2 = 160 * SC2; c2 = Image.new('L', (2 * W2 + 30, 144 * SC2 + 52), 200); d2 = ImageDraw.Draw(c2)
for i, (t, arr) in enumerate((('shipped: Japanese ROM, 15:6C00 + 24:5180 (BG layer from BGB VRAM, no sprites; the game shows it inverted)', ship), ('unused: 14:4000 + 23:5CC0 (both ROMs)', img))):
    x = 10 + i * (W2 + 10); d2.text((x, 6), t, fill=0); c2.paste(Image.fromarray(GREY[arr]).resize((W2, 144 * SC2), Image.NEAREST), (x, 40))
out2 = out[:-4] + '_same_palette.png'; c2.save(out2); print(out2, c2.size)
