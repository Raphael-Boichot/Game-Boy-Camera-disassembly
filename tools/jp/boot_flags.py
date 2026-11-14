#!/usr/bin/env python3
"""Boot a ROM (GBCAM_ROM) with each given save and print the (mode,state) sequence of the first ~1200 frames and the CoroCoro flag $D582 / Album-B count $D562
after the boot (the tag routine of 08:72E0 (JP) / 08:730E (international) sets $D582 = 1, $D562 = $1E when the tag 56 56 53 is found).
usage: GBCAM_ROM=... boot_flags.py SAVE ...      SAVE = path to .sav, or _ff / _zero"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g
for sv in sys.argv[1:]:
    sav = open(sv, 'rb').read() if sv.endswith('.sav') else lib.SAV(sv)
    g.set_organic(1); g.reset(sav); g.L.gb_attach_printer(0); g.keys(0); seen = []
    for t in range(0, 1200, 5):
        g.run(5); c = lib.cur()
        if not seen or seen[-1] != c: seen.append(c)
    print('%-34s tag %-8s %s  $D582=%d $D562=%02X' % (os.path.basename(sv), sav[0x1FFD:0x2000].hex(), ' '.join('%02X:%02X' % c for c in seen), g.peek(0xD582), g.peek(0xD562)))
