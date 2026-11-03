#!/usr/bin/env python3
"""Where the two tiles at 1A:7C90 / 1A:7CA0 (the TCRF "photo option icon", 16 x 8 px) are drawn, on the real BGB.  README 16.24 / checklist B11.

The album photo-option menu is mode $09: state 2 shows the photo with four arrows and the labels of the four directions; Right goes to state 4, the page of the two choices
(frame / comment), which scrolls the background to SCX = 32.  Album_ShowPageScreenB (04:6E3D) copies 1A:7600-7CFF to $8900 and the map 24:73E0 to $9800; the map puts the two
tiles ($F9, $FA = $8F90, $8FA0) at cells (22, 8) and (23, 8), which are outside the 20 visible columns in state 2 (SCX = 16) and inside them in state 4 (columns 4-23).
The script replays the cheapest organic corpus entry of (mode 9, state 2) in BGB (tcrf_check/tools/bgbgrab.py), presses Right, reads BGB's state file, finds the VRAM tiles
whose 16 bytes equal the two ROM tiles, finds the BG map cells that use them, checks that the cells are inside the visible 160 x 144 area and writes a PNG (the BGB frame, the
icon boxed, 6x, cropped to the column of choice icons at the right edge so that no photo of the save is in the picture).
usage: photo_option_icon_check.py OUT.png [BGB_DIR]      (GBCAM_ROOT = the working root of README 16.15, GBCAM_ROM; BGB_DIR is copied if it does not exist)"""
import sys, os
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
out = sys.argv[1]; bgbdir = sys.argv[2] if len(sys.argv) > 2 else '/home/claude/bgbq5'
import bgbgrab as B, bgb_run
from PIL import Image, ImageDraw
rom = open(os.environ.get('GBCAM_ROM', B.ROOT + '/pocketcamera_jp.gb'), 'rb').read()
def tile(b, a): o = b * 0x4000 + (a - 0x4000); return rom[o:o + 16]
T = [tile(0x1A, 0x7C90), tile(0x1A, 0x7CA0)]
i, sp, seq, sav = B.entry((9, 2))
res = {}
for tag, extra in (('state2', []), ('right', [('Right', 4, 60)])):
    r = B.grab(os.path.splitext(out)[0] + '_' + tag, sp, sav, seq + extra, bgbdir=bgbdir)
    st = bgb_run.read_state(r['state_file']); V = st['VRAM']; L = st['LCDC'][0]; scx = st['SCX'][0]; scy = st['SCY'][0]
    slots = [[s for s in range(384) if V[s * 16:s * 16 + 16] == t] for t in T]
    base = 0x1C00 if L & 8 else 0x1800
    cells = []
    for c in range(1024):
        idx = V[base + c]; slot = idx if L & 0x10 else (256 + idx if idx < 128 else idx)
        for k in (0, 1):
            if slot in slots[k]: cells.append((k, c % 32, c // 32))
    vis = []
    for k, cx, cy in cells:
        x = (cx * 8 - scx) % 256; y = (cy * 8 - scy) % 256
        vis.append((k, cx, cy, x, y, x < 160 and y < 144))
    print('%-6s mode %d state %d LCDC %02X SCX %d SCY %d: VRAM slots of 1A:7C90 / 7CA0 = %s / %s; BG cells (tile, x, y, screen x, screen y, visible) = %s'
          % (tag, st['WRAM'][0x15CE], st['WRAM'][0x15CF], L, scx, scy, [hex(s) for s in slots[0]], [hex(s) for s in slots[1]], vis))
    res[tag] = (r['shot'], vis)
shot, vis = res['right']
X0, Y0, X1, Y1 = 130, 8, 160, 136
im = Image.open(shot).convert('RGB').crop((X0, Y0, X1, Y1)); SC = 6
im = im.resize((im.width * SC, im.height * SC), Image.NEAREST); d = ImageDraw.Draw(im)
for k, cx, cy, x, y, v in vis:
    if v and k == 0: d.rectangle(((x - X0) * SC - 3, (y - Y0) * SC - 3, (x - X0 + 16) * SC + 2, (y - Y0 + 8) * SC + 2), outline=(255, 0, 0), width=2)
im.save(out); print('->', out)
