#!/usr/bin/env python3
"""Main-menu probe: boot a ROM (GBCAM_ROM), wait for the main menu (mode 0 state 1), then for each single d-pad key press
(+A) report the (mode,state) reached.  Shows whether JP and international ROMs map the same input to the same mode.
usage: GBCAM_ROM=... mainmenu_probe.py SAVNAME OUTDIR"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g, R
from PIL import Image
sav, out = sys.argv[1], sys.argv[2]; os.makedirs(out, exist_ok=True)
lib.boot(lib.SAV(sav), combo=0, printer=0, free=400)
# let the intro run until the main menu (00:01) shows up, pressing A/B/Start lightly like a player would
n = 0
while lib.cur() != (25, 3) and n < 3000:       # Mario greeting screen (mode $19)
    g.run(10); n += 10
g.run(30); lib.act((g.A, 6, 10))                 # press A like the manual says
while lib.cur() != (0, 1) and n < 6000:
    g.run(10); n += 10
print('main menu reached after', 250 + 400 + n, 'frames; mode,state =', lib.cur())
g.run(60)
Image.fromarray(R.screen(g)).save(out + '/main_menu.png')
base = g.snapshot()
NAMES = [('none', 0), ('Left', g.LEFT), ('Right', g.RIGHT), ('Up', g.UP), ('Down', g.DOWN)]
for nm, k in NAMES:
    g.restore(base)
    if k: lib.act((k, 6, 20))
    Image.fromarray(R.screen(g)).save(out + '/cursor_%s.png' % nm)
    cur_item = None
    lib.act((g.A, 6, 150))
    print('%-6s + A -> mode:state %02X:%02X' % (nm, *lib.cur()), flush=True)
    Image.fromarray(R.screen(g)).save(out + '/after_%s.png' % nm)
