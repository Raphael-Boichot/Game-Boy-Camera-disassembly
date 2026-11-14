#!/usr/bin/env python3
"""Retry, in BGB, the signatures that did not reproduce, shifting the whole input script by 1..N frames (boot-phase sensitivity test).
usage: bgb_retry.py CORPUS ROM OUTDIR MAXSHIFT SIG [SIG...]"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import bgb_sig, bgb_run
corpus, rom, out, maxshift = sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4])
C = bgb_sig.C
for sig in sys.argv[5:]:
    sp, seq, i = bgb_sig.seq_for(sig)
    base = os.path.dirname(os.path.abspath(bgb_sig.__file__))
    sav = os.path.join(base, '..', 'saves_unl', sp['sav'] + '.sav')
    if not os.path.exists(sav): sav = os.path.join(base, '..', 'saves', sp['sav'] + '.sav')
    if sp['sav'] in ('_ff', '_zero'):
        sav = os.path.join(out, sp['sav'] + '.sav'); open(sav, 'wb').write((b'\xff' if sp['sav'] == '_ff' else b'\0') * 0x20000)
    got = []
    for sh in range(0, maxshift + 1):
        r = bgb_run.run(rom, sav, '%s/retry_%s_s%d' % (out, sig.replace(':', '_'), sh), seq, combo=bgb_run.mask(bgb_sig.names(sp['combo'])) if sp['combo'] else 0, free=sp['free'] + sh)
        got.append('%02X:%02X' % (r['mode'] or 0, r['state'] or 0))
        if got[-1] == sig or (sh and got[-1][:2] == sig[:2]): break
    print(sig, 'shift 0..%d ->' % (len(got) - 1), ' '.join(got), flush=True)
