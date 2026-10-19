#!/usr/bin/env python3
"""The picture of README 16.2 'The STAT split': one BGB state of a screen with handler 1 drawn three ways at 2x: the tiles through the tile-data bit of the top part only (what you see without the flip), the BGB picture (the flip from line 85),
and the ids of the visible map (rows 0-17, 20 columns) with the cells that read the second window marked.
usage: stat_split_fig.py STATE.sna BGB.bmp OUT.png [--line 85]"""
import sys, os
import numpy as np
from PIL import Image, ImageDraw
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import bgb_run, gb_screen, menu_screen_gif as M
PAL = [255, 255, 255, 170, 170, 170, 85, 85, 85, 0, 0, 0]
def pic(sh, scale=2, line=None):
    im = Image.fromarray(sh, 'P'); im.putpalette(PAL); im = im.resize((im.width * scale, im.height * scale), Image.NEAREST).convert('RGB')
    if line is not None:
        d = ImageDraw.Draw(im); d.line([(0, line * scale), (im.width, line * scale)], fill=(220, 30, 30), width=1)
    return im
def main(a):
    st = bgb_run.read_state(a[0]); ref = M.shot(a[1]); out = a[2]; line = int(a[a.index('--line') + 1]) if '--line' in a else 85
    h = st['HRAM']; lcdc = h[0x2B]; args = (st['SCX'][0], st['SCY'][0], st['BGP'][0], st['OBP'][0], st['OBP'][1])
    top = gb_screen.render(st['VRAM'], st['OAM'], lcdc, *args); fl = gb_screen.render_split(st['VRAM'], st['OAM'], lcdc, line, *args)
    assert (fl == ref).all(), 'the flip from line %d does not reproduce the BGB picture' % line
    p1, p2 = pic(top, 2, line), pic(ref, 2, line)
    W = p1.width; H = p1.height; sheet = Image.new('RGB', (2 * W + 3 * 8, H + 28), (255, 255, 255)); d = ImageDraw.Draw(sheet)
    sheet.paste(p1, (8, 22)); sheet.paste(p2, (W + 16, 22))
    d.text((8, 6), 'tile data of the top part for all 144 lines (%d px wrong)' % int((top != ref).sum()), fill=(0, 0, 0)); d.text((W + 16, 6), 'BGB: bit 4 of LCDC flipped from line %d' % line, fill=(0, 0, 0))
    sheet.save(out); print(out, sheet.size, 'wrong px without the flip', int((top != ref).sum()))
if __name__ == '__main__': main(sys.argv[1:])
