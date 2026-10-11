#!/usr/bin/env python3
"""BGB check of the CoroCoro-gated screens on the Japanese and the international ROM, with and without the CoroCoro tag in the save.
Screens: print > frames > wild (mode 1C state 0D), pages 0..8 (Right pressed n times); stamp chooser (11:03), category column, categories 2, 3, 4.
usage: bgb_corocoro_intl.py OUTDIR      -> OUTDIR/<jp|us>_<tag|notag>_<wild_pNN|stamp_catN>.bmp, OUTDIR/results.json (name -> mode:state ...)"""
import sys, os, json
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE); ROOT = os.path.dirname(HERE)
import bgb_us_jp_job as J
out = os.path.abspath(sys.argv[1]); os.makedirs(out, exist_ok=True)
ROMS = dict(jp=(os.path.join(ROOT, 'pocketcamera_jp.gb'), 'Left'), us=(os.path.join(ROOT, 'roms', 'gbcam_usa_eu.gb'), 'Right'))
SAV = os.path.join(ROOT, 'saves_unl', 'unl_CE10238211.sav')          # unlocking save; it already carries the tag 56 56 53 at 01FFD-01FFF
b = bytearray(open(SAV, 'rb').read()); assert bytes(b[0x1FFD:0x2000]) == b'\x56\x56\x53'
b[0x1FFD:0x2000] = b'\xAA\xAA\xAA'; NOTAG = os.path.join(out, 'unl_notag.sav'); open(NOTAG, 'wb').write(bytes(b))
SAVS = dict(tag=SAV, notag=NOTAG)
def K(k, h=4, w=60): return (k, h, w)
def A(): return K('A', 4, 200)
def wild(vk, n): return [A(), K(vk, 4, 120), A(), A(), A(), A(), K('Up'), A(), K('Select', 4, 200), K('Down'), K('Right'), A()] + [K('Right')] * n
def stamp(vk, c): return [A(), K(vk, 4, 120), A(), A(), A(), A(), K('Left'), K('Down'), A(), K('Start', 4, 200)] + [K('Right')] * 5 + [K('Down')] * c
jobs = []
for rom, (path, vk) in ROMS.items():
    for tg, sv in SAVS.items():
        for n in range(9): jobs.append(('%s_%s_wild_p%02d' % (rom, tg, n), path, sv, wild(vk, n), out, 2, 400, 2))
        for c in (2, 3, 4): jobs.append(('%s_%s_stamp_cat%d' % (rom, tg, c), path, sv, stamp(vk, c), out, 2, 400, 2))
print(len(jobs), 'jobs', flush=True)
res = J.run_jobs(jobs, 2)
json.dump(res, open(os.path.join(out, 'results.json'), 'w'), indent=1)
