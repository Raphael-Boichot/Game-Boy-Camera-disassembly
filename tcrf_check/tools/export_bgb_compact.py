#!/usr/bin/env python3
"""Compact export of the BGB confirmation runs (the full working folders hold BGB state files of ~0.3 MB each, 200 MB in all): keeps the demo (.dem, the
exact joypad byte per frame, 1 byte/frame: A=1 B=2 Select=4 Start=8 Right=$10 Left=$20 Up=$40 Down=$80) and a PNG of the last screen of each run, plus the few
SRAM inputs that are not regenerable by the scripts.   usage: export_bgb_compact.py SRC_BGB_DIR DST_DIR"""
import sys, os, glob, shutil
from PIL import Image
src, dst = sys.argv[1:3]
KEEP_SAV = {'corocoro': 'tag_*.sav', 'corocoro_intl': 'tag_*.sav', 'link': '*.sav', 'credits_gate': '*.sav', 'pokemon_ball': 'pk_ball_*.sav'}
for d in sorted(os.listdir(src)):
    s = os.path.join(src, d)
    if not os.path.isdir(s) or d in ('JP', 'retry'):          # JP (shift 0) and retry are superseded by JP_s3; their summary stays in the CSV
        continue
    o = os.path.join(dst, d); os.makedirs(o, exist_ok=True)
    for f in sorted(glob.glob(s + '/*.bmp')):
        Image.open(f).convert('L').save(os.path.join(o, os.path.basename(f)[:-4] + '.png'), optimize=True)
    for f in sorted(glob.glob(s + '/*.dem')): shutil.copy(f, o)
    for f in glob.glob(s + '/*.png'): shutil.copy(f, o)          # core screenshots / filmstrip already PNG
    if d in KEEP_SAV:
        for f in sorted(glob.glob(os.path.join(s, KEEP_SAV[d]))): shutil.copy(f, o)
for f in glob.glob(src + '/*.csv'): shutil.copy(f, dst)
