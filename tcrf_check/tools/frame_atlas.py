#!/usr/bin/env python3
"""Capture every photo frame (border) in the 'フォト フレーム No.nn' chooser (mode $09 state 9, border number in WRAM $D7C1).
Path: album photo-option menu (mode 09) -> A -> Right (frame/copy submenu) -> A.  usage: frame_atlas.py OUTDIR [CORPUS] [ENTRY] [SAVE]"""
import sys, os, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g, R
from PIL import Image
out = sys.argv[1]; os.makedirs(out, exist_ok=True)
corpus = sys.argv[2] if len(sys.argv) > 2 else 'unlock_runs/f1_organic/corpus.jsonl'
entry = int(sys.argv[3]) if len(sys.argv) > 3 else 263
C = lib.Corpus(corpus); g.set_organic(1); C.replay(entry); g.run(60)
lib.act((g.A, 4, 50)); lib.act((g.RIGHT, 4, 50)); lib.act((g.A, 4, 60))
print('chooser', lib.cur(), 'border', g.peek(0xD7C1))
seen = []; 
for _ in range(40):
    b = g.peek(0xD7C1)
    if b in seen: break
    seen.append(b); Image.fromarray(R.screen(g)).save('%s/frame_border%02d.png' % (out, b))
    lib.act((g.RIGHT, 4, 40))
print('borders', seen)
json.dump(seen, open(out + '/borders.json', 'w'))
