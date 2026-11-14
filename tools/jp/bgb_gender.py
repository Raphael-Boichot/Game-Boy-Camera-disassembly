#!/usr/bin/env python3
"""BGB: owner registration, gender page: Start > A (name keyboard) > cursor to the page button > A (gender page) > Right (x1 or x2) > A; prints $DA56 (owner gender / blood byte).
usage: bgb_gender.py ROM SAV OUTDIR"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import bgb_run
rom, sav, out = sys.argv[1:4]
pre = [('B', 12, 60), ('Start', 8, 120), ('A', 8, 150)] + [('Right', 4, 6)] * 13 + [('Down', 4, 6)] * 4 + [('A', 6, 60)]
for label, n in (('? (no move)', 0), ('first symbol after ? (1 x Right)', 1), ('second symbol (2 x Right)', 2)):
    seq = pre + [('Right', 4, 10)] * n + [('A', 6, 40)]
    r = bgb_run.run(rom, sav, '%s/gender_%d' % (out, n), seq, combo=0, free=403, tail=2)
    print('%-34s -> mode:state %02X:%02X  $DA56 = %02X' % (label, r['mode'], r['state'], r['st']['WRAM'][0xDA56 - 0xC000]), flush=True)
