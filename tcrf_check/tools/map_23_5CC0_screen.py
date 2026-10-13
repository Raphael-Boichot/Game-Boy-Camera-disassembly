#!/usr/bin/env python3
"""Draw the unreferenced screen of the tile set 14:4000-502F with its tile map 23:5CC0.  README 16.24 "(3) The small holes".

23:5CC0-5F03 (580 bytes) is a BG tile map: 18 rows x 32 columns (576 bytes) + 4 trailing $16 bytes.  Its tile ids index the 259 tiles at 14:4000
directly (id = (address - 14:4000) / 16, checked on the picture: the seams of every neighbouring tile pair match).  Columns 0-19 are the visible screen;
columns 20-27 are $0F (grey) and 28-31 are $16 (white).  The tile set is a de-duplicated tile list: ids DEscend in raster order of first appearance
($F4 = a solid black tile, the first tile of the picture, then $F3, $F2, ... for every new tile, repeats such as $F4, $0F, $16, $ED reuse their id),
which is why a reading of 14:4000-502F as raster strips (width 16, 17, 10 ...) found only fragments.  Ids 245-255 (and the 3 tiles after them, which no
8-bit id can reach) are not used by this map: 14:4F50-502F, the 14-tile "heading row" of outlined kanji.
Not a console capture: a direct draw of ROM bytes with a 4-grey palette; no code loads this map (README 16.24).
usage: map_23_5CC0_screen.py [ROM] [out.png]   (default ROM /home/claude/gbcam_jp/pocketcamera_jp.gb, env GBCAM_ROM, GBCAM_REPO)
"""
import sys, os
import numpy as np
from PIL import Image
REPO = os.environ.get('GBCAM_REPO', os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
ROMF = sys.argv[1] if len(sys.argv) > 1 else os.environ.get('GBCAM_ROM', '/home/claude/gbcam_jp/pocketcamera_jp.gb')
OUT = sys.argv[2] if len(sys.argv) > 2 else REPO + '/tcrf_check/assets/unidentified/23_5CC0_map_screen.png'
rom = np.frombuffer(open(ROMF, 'rb').read(), dtype=np.uint8)
def off(bank, addr): return bank * 0x4000 + (addr - 0x4000)
TILES, NT = off(0x14, 0x4000), 259
MAP = off(0x23, 0x5CC0)
PAL = np.array([255, 170, 85, 0], np.uint8)
def tile(i):
    t = np.zeros((8, 8), np.uint8)
    for y in range(8):
        b0 = int(rom[TILES + 16 * i + 2 * y]); b1 = int(rom[TILES + 16 * i + 2 * y + 1])
        for x in range(8): t[y, x] = ((b1 >> (7 - x)) & 1) << 1 | ((b0 >> (7 - x)) & 1)
    return t
T = [tile(i) for i in range(NT)]
M = np.array([rom[MAP + 32 * r:MAP + 32 * r + 32] for r in range(18)])
ROWS, COLS, SC = 18, 20, 6
img = np.zeros((ROWS * 8, COLS * 8), np.uint8)
for r in range(ROWS):
    for c in range(COLS): img[r * 8:r * 8 + 8, c * 8:c * 8 + 8] = PAL[T[M[r, c]]]
Image.fromarray(img).resize((COLS * 8 * SC, ROWS * 8 * SC), Image.NEAREST).save(OUT)
used = sorted(set(int(x) for x in M.ravel()))
print(OUT, 'distinct ids', len(used), 'unused tiles', [s for s in range(NT) if s not in used][:3], '...', 'trailing', rom[MAP + 576:MAP + 580].tolist())
