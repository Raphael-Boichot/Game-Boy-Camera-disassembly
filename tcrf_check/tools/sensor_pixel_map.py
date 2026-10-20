#!/usr/bin/env python3
"""Figure for README 18.3 / 9 / 10: where the pixels the sensor code reads sit in the 128 x 128 raw frame (RAM bank 0 $A000-$AFFF, 2 bpp, 16 x 16 tiles of 16 bytes),
drawn top to bottom by increasing SRAM address.
  calibration pixel test  Cam_PixelTestHelper 0A:4C30: bytes [DE], [DE+2], [DE+4], [DE+6], bits 6-4 (columns 1-3);  DE = $A002 (boot searches, threshold scans, factory test)
                          and DE = $A082 (Cam_FactoryMeasure1, the 12 offset searches of the factory calibration)        -> 12 pixels each, lines 1-4 of tile 0 and of tile 8
  exposure metering       Cam_PopcountSampleLoop 0A:4FBD: 120 reads (loop 1, sum doubled) + 48 reads (loop 2); one read = 2 bytes = one 8-pixel tile row; the addresses are
                          taken from the ROM bytes by the same tiny executor as sensor_meter_geom.py (nothing is transcribed by hand)
  shown area              the 128 x 112 photo = lines 8-119 = $A100-$AEFF (3,584 bytes); lines 0-7 ($A000-$A0FF) and 120-127 ($AF00-$AFFF) are not part of it
  saturated lines         lines 123-128 counted from 1 (y 122-127 counted from 0): measured on one frame supplied by the owner (README 9, frame_line_stats.py), drawn as asked
usage: sensor_pixel_map.py ROM.gb OUT.png"""
import sys
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle, Patch
matplotlib.rcParams['text.parse_math'] = False                                      # '$A002' is an address, not a math delimiter

import os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from sensor_meter_lib import meter_reads, where
rom = open(sys.argv[1], 'rb').read(); out = sys.argv[2]
def rd(a): return rom[0x0A * 0x4000 + a - 0x4000]

# the pixel test reads [DE], [DE+2], [DE+4], [DE+6] with DE = $FF8C:$FF8D; the callers set $A002 (0A:4724, 4956: boot, scans) or $A082 (0A:494B: Cam_FactoryMeasure1)
assert bytes(rd(a) for a in range(0x4C30, 0x4C30 + 18)).hex() == '67afea0040f08c57f08d5f06000e041acb77', 'Cam_PixelTestHelper changed'   # ld h,a; xor a; ld [$4000],a; DE = [$FF8C:$FF8D]; b = 0; c = 4; ld a,[de]; bit 6,a
TEST_A = [0xA002 + 2 * k for k in range(4)]; TEST_B = [0xA082 + 2 * k for k in range(4)]
reads = meter_reads(rom)
assert len(reads) == 168 and sum(1 for l, _ in reads if l == 1) == 120

BLUE1, BLUE2, MAG, ORA, RED = '#1b5e9e', '#7db4de', '#d01c8b', '#e66101', '#c0392b'
fig = plt.figure(figsize=(14, 9.2), dpi=150, facecolor='white')
ax = fig.add_axes([0.085, 0.04, 0.578, 0.88])
ax.set_xlim(0, 128); ax.set_ylim(128, 0); ax.set_aspect('equal')
ax.add_patch(Rectangle((0, 0), 128, 128, fc='#e9e9e9', ec='none'))                 # not shown
ax.add_patch(Rectangle((0, 8), 128, 112, fc='#eaf2fb', ec='none'))                 # shown area (the photo)
ax.add_patch(Rectangle((0, 122), 128, 6, fc='#fbe0dc', ec=RED, hatch='////', lw=0))   # saturated lines 123-128 (1-based)
for k in range(0, 129, 8):                                                         # tile grid
    ax.axhline(k, color='#b4c0cc', lw=0.45, zorder=1); ax.axvline(k, color='#b4c0cc', lw=0.45, zorder=1)
ax.add_patch(Rectangle((0, 8), 128, 112, fc='none', ec='#2a4d75', lw=1.8, zorder=6))
for want, col in ((1, BLUE1), (2, BLUE2)):
    for l, ad in reads:
        if l == want:
            x, y = where(ad); ax.add_patch(Rectangle((x, y), 8, 1, fc=col, ec='none', zorder=3 + want))
for pts, col in ((TEST_A, MAG), (TEST_B, ORA)):                                    # calibration pixels: bits 6-4 of 4 bytes = x 1-3, y 1-4 of the tile
    x0 = ((pts[0] - 0xA000) // 16 % 16) * 8
    ax.add_patch(Rectangle((x0 + 1, 1), 3, 4, fc=col, ec='black', lw=0.7, zorder=8))
ax.text(7.0, 2.2, 'A  $A002 $A004 $A006 $A008', fontsize=6.6, va='center', color='#7d0f52', zorder=9)
ax.text(71.0, 2.2, 'B  $A082 $A084 $A086 $A088', fontsize=6.6, va='center', color='#8a3c00', zorder=9)
ax.text(7.0, 5.9, 'lines 0-7 ($A000-$A0FF): not part of the photo', fontsize=6.0, va='center', color='#555555', zorder=9)
ax.text(64, 15, 'SHOWN AREA = the photo, 128 x 112: lines 8-119 = $A100-$AEFF', ha='center', va='center', fontsize=8.2, color='#2a4d75', weight='bold', zorder=9,
        bbox=dict(fc='#eaf2fb', ec='none', pad=1.2))
ax.text(64, 110, 'the exposure metering never reads below line 103', ha='center', va='center', fontsize=7.6, color='#1b5e9e', zorder=9, bbox=dict(fc='#eaf2fb', ec='none', pad=1.0))
ax.text(64, 121.0, 'lines 120-121', ha='center', va='center', fontsize=5.6, color='#555555', zorder=9)
ax.text(64, 125.0, 'lines 123-128 (counted from 1; y = 122-127): saturated (one owner frame)', ha='center', va='center', fontsize=6.6, color='#7a1f14', weight='bold', zorder=9,
        bbox=dict(fc='#fbe0dc', ec='none', pad=0.6, alpha=0.9))
ax.set_yticks(range(0, 128, 8)); ax.set_yticklabels(['$%04X' % (0xA000 + k * 0x100) for k in range(16)], fontsize=7.6, family='monospace')
ax.set_xticks(range(0, 129, 16)); ax.xaxis.tick_top(); ax.set_xticklabels([str(k) for k in range(0, 129, 16)], fontsize=7.6)
ax.set_xlabel('')
ax.tick_params(length=2, pad=2)
ax2 = ax.twinx(); ax2.set_ylim(128, 0); ax2.set_yticks(range(0, 129, 8)); ax2.set_yticklabels([str(k) for k in range(0, 129, 8)], fontsize=7.6); ax2.tick_params(length=2, pad=2)
fig.text(0.005, 0.50, 'SRAM address (RAM bank 0, flat offset = address - $A000), increasing downwards:  1 tile row = 256 bytes', rotation=90, va='center', fontsize=8.4)
fig.text(0.374, 0.949, 'x (pixel): 16 tiles of 8 pixels; inside a tile row the addresses run tile after tile (16 bytes each); a pixel row = 2 bytes (plane 0, plane 1)', ha='center', fontsize=7.6)
fig.text(0.683, 0.48, 'line y (counted from 0)', rotation=270, va='center', fontsize=8.4)
fig.text(0.085, 0.992, 'Pocket Camera (Japan) Rev A: the raw 128 x 128 sensor frame (RAM bank 0, $A000-$AFFF) and what the code reads in it', fontsize=11.5, weight='bold', va='top')

# right panel: legend, tile-0 zoom, notes
axl = fig.add_axes([0.715, 0.64, 0.275, 0.29]); axl.axis('off')
hs = [Patch(fc=MAG, ec='black', label='A  calibration pixel test, 12 pixels (tile 0):\n    boot gain probe and offset searches, 12 threshold\n    scans (boot, factory calibration, factory test)'),
      Patch(fc=ORA, ec='black', label='B  same test, 12 pixels (tile 8): the 12 offset\n    searches of the factory calibration and test'),
      Patch(fc=BLUE1, label='exposure metering, loop 1: 120 reads of\n8 pixels, sum x 2'),
      Patch(fc=BLUE2, label='exposure metering, loop 2: 48 reads of\n8 pixels, sum x 1'),
      Patch(fc='#eaf2fb', ec='#2a4d75', lw=1.6, label='shown area: the photo, lines 8-119'),
      Patch(fc='#e9e9e9', ec='#999999', label='not shown: lines 0-7 and 120-127'),
      Patch(fc='#fbe0dc', ec=RED, hatch='////', label='saturated lines 123-128 (measured on one\nowner frame, README 9)')]
axl.legend(handles=hs, loc='upper left', fontsize=7.7, frameon=False, labelspacing=0.7, handlelength=2.0, handleheight=1.15)

axz = fig.add_axes([0.755, 0.31, 0.185, 0.28]); axz.set_xlim(0, 8); axz.set_ylim(8, 0); axz.set_aspect('equal')
for r in range(8):
    for c in range(8):
        hit = 1 <= r <= 4 and 1 <= c <= 3
        axz.add_patch(Rectangle((c, r), 1, 1, fc=MAG if hit else 'white', ec='#888888', lw=0.5))
axz.set_xticks([k + 0.5 for k in range(8)]); axz.set_xticklabels(['bit %d' % (7 - k) for k in range(8)], fontsize=6.4); axz.xaxis.tick_top(); axz.tick_params(length=0, pad=2)
axz.set_yticks([k + 0.5 for k in range(8)]); axz.set_yticklabels(['$A0%02X/%02X' % (2 * k, 2 * k + 1) for k in range(8)], fontsize=6.6, family='monospace'); axz.tick_params(length=0, pad=2)
for s in axz.spines.values(): s.set_visible(False)
fig.text(0.848, 0.625, 'Tile 0 (x 0-7, lines 0-7) zoomed: the 12 pixels of A', ha='center', fontsize=8.0, weight='bold')
fig.text(0.848, 0.292, 'bytes $A002 $A004 $A006 $A008 = plane 0 of lines 1-4,\nbits 6, 5, 4 = columns 1-3.  Tile 8 (B) is the same pattern\nat $A082 $A084 $A086 $A088, x 65-67.', ha='center', va='top', fontsize=7.4)
notes = ('Saturated lines, bytes (flat offset = address - $A000): lines 123-128 counted\nfrom 1 are y 122-127 counted from 0, i.e. bytes +4 to +15 of each of the 16 tiles of\ntile row 15 ($AF04-$AF0F, $AF14-$AF1F ... $AFF4-$AFFF = $0F04 ... $0FFF in a .sav).\n'
         'Neither the pixel test (lines 1-4) nor the metering (lines 24-103) reads them.\n'
         'Metering: 60 of the 120 loop-1 reads start at an odd address and straddle two\nrows (drawn at the row of the first byte).\n'
         'Evidence: positions of A, B and the metering are C (ROM bytes, 0A:4C30 and\n0A:4FBD-5090, tool sensor_pixel_map.py); the saturation of lines 123-128 is C for one\nowner frame (README 9).')
fig.text(0.715, 0.205, notes, ha='left', va='top', fontsize=7.0, linespacing=1.35)
fig.savefig(out, dpi=150, facecolor='white')
n1 = sum(1 for l, _ in reads if l == 1); ys = [where(ad)[1] for _, ad in reads]
print('wrote %s: %d + %d metering reads, y %d..%d; test pixels A %s, B %s' % (out, n1, len(reads) - n1, min(ys), max(ys), ['$%04X' % a for a in TEST_A], ['$%04X' % a for a in TEST_B]))
