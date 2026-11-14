#!/usr/bin/env python3
"""GBCAM_ROM=ROM shots.py SAVE OUT.png < paths   : one path per line (from the main menu after the title A); contact sheet of the end screen of each path (core render)"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import walk, lib; from lib import g, R
from PIL import Image, ImageDraw
import numpy as np
walk.boot(sys.argv[1], 2); walk.tap('A'); base = g.snapshot(); ims = []
for line in sys.stdin:
    line = line.strip()
    if not line or line[0] == '#': continue
    g.restore(base)
    for t in line.split():
        if t[0] == 'w': g.run(int(t[1:]))
        else: walk.tap(t)
    g.run(60)
    ims.append((line, '%02X:%02X' % lib.cur(), Image.fromarray(np.array(R.screen(g)))))
n = len(ims); cols = min(4, n); rows = (n + cols - 1) // cols
S = Image.new('RGB', (cols * 164, rows * 164), (255, 255, 255)); d = ImageDraw.Draw(S)
for i, (p, st, im) in enumerate(ims):
    x, y = (i % cols) * 164, (i // cols) * 164; S.paste(im, (x + 2, y + 2)); d.text((x + 2, y + 148), st + ' ' + p[:24], fill=(200, 0, 0))
S.save(sys.argv[2])
