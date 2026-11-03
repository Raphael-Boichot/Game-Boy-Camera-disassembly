#!/usr/bin/env python3
"""GBCAM_ROM=ROM guide_core_check.py SAVE OUT.json : replay every node path of guide_nodes.NODES in the core (real key presses, adaptive waits) and record the (mode,state)."""
import sys, os, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import walk, lib; from lib import g
import guide_nodes as G
us = 'usa' in os.environ.get('GBCAM_ROM', '')
vk = 'R' if us else 'L'
FIXED = '--fixed' in sys.argv      # same timing as the BGB sequences of guide_bgb_walk.py: hold 4, wait 200 after A/B/Start/Select, 60 after a direction
def fixed_tap(t):
    g.keys(lib.KEY[t]); g.run(4); g.keys(0); g.run(60 if t in 'LRUD' else 200)
walk.boot(sys.argv[1], 2)
if FIXED: fixed_tap('A')
else: walk.tap('A')
base = g.snapshot(); res = {}
for chart, nid, label, path, exp in G.NODES:
    g.restore(base)
    for t in G.tokens(path, vk):
        if t[0] == 'w': g.run(int(t[1:]))
        elif FIXED: fixed_tap(t)
        else: walk.tap(t)
    g.run(30 if not FIXED else 0); st = lib.cur(); res[nid] = '%02X:%02X' % st
    print('%-4s %-6s %-60s exp %02X:%02X got %02X:%02X %s' % (nid, chart, label[:60], *exp, *st, '' if st == exp else '<<<'), flush=True)
json.dump(res, open(sys.argv[2], 'w'), indent=1)
