#!/usr/bin/env python3
"""GBCAM_ROM=ROM explore.py SAVE  < paths   (one path per line, tokens ABLRUDsS, optional 'wN' waits; start = main menu after the title A)
prints the (mode,state) after each key and the result of every single key from the end state"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import walk, lib; from lib import g
walk.boot(sys.argv[1], 2); walk.tap('A'); base = g.snapshot()
for line in sys.stdin:
    line = line.strip()
    if not line or line[0] == '#': continue
    g.restore(base); trail = []
    for t in line.split():
        if t[0] == 'w': g.run(int(t[1:]))
        else: walk.tap(t)
        trail.append('%s>%02X:%02X' % (t, *lib.cur()))
    p = walk.probe()
    print('[%s]' % (line if len(line) < 70 else line[:30] + ' … ' + line[-25:]), ' '.join(trail) if len(trail) < 12 else '… ' + ' '.join(trail[-5:])); print('    ', ' '.join('%s=%02X:%02X' % (k, *v) for k, v in p.items() if v != lib.cur()), flush=True)
