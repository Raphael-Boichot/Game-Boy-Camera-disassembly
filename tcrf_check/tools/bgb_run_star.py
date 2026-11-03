#!/usr/bin/env python3
"""TCRF "Unused R!R!R! star" (checklist B18) is drawn in the real BGB: RUN! RUN! RUN! race (mode $21 state 06, corpus entry 649 of unlock_runs/f1_organic), then a fixed
stream of 33 key presses (A, Left, Right or nothing, held 3 frames each, no waits; the tiles of the star: run_star_pair.py).  The race is replayed in BGB with the first N of the 33 presses, N = 30 ... 33, and the logging watchpoint 00:2464//x (Oam_AddMeta_B02_6E4B) counts every
request of OAM list $1B ... $1E of the table 02:6E4B (the list id is in A).  List $1C (02:727F) = three 8 x 16 sprites $B0 (the star pair 1B:6180 / 6190), $AE, $AC.
usage: bgb_run_star.py CORPUS ROM.gb OUTDIR      (env BGB_DIR = a private copy of the BGB folder, default /home/claude/bgbts)
Writes OUTDIR/run_star_hits.csv (N, requests of lists $1B-$1E) and OUTDIR/run_star_n31.png (the BGB screen at the end of N = 31, enlarged 4x)."""
import sys, os, json, subprocess, csv, shutil, re, collections
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
from PIL import Image
corpus, rom, out = sys.argv[1:4]
os.makedirs(out, exist_ok=True)
# mask (bgb_wp_probe CORE table): 1 Right, 2 Left, 4 Up, 8 Down, 16 A, 32 B; 0 = nothing
STREAM = [16, 16, 2, 16, 2, 2, 2, 16, 0, 1, 16, 2, 0, 16, 0, 16, 1, 16, 1, 16, 0, 16, 16, 0, 2, 16, 1, 16, 16, 1, 16, 0, 16]
rows = [json.loads(l) for l in open(corpus) if l.strip()]
bd = os.environ.get('BGB_DIR', '/home/claude/bgbts'); env = dict(os.environ, BGB_DIR=bd)
res = []
for n in range(30, 34):
    rows_n = rows + [{"id": 99999, "parent": 649, "gain": 0, "sig": [33, 6], "t": 0, "tainted": False, "actions": [[m, 3, 0] for m in STREAM[:n]]}]
    cf = os.path.join(out, 'corpus_n%d.jsonl' % n); open(cf, 'w').write('\n'.join(json.dumps(r) for r in rows_n) + '\n')
    lg = os.path.join(bd, 'debugmsg.txt')
    if os.path.exists(lg): os.remove(lg)
    pre = os.path.join(out, 'n%d' % n)
    subprocess.run([sys.executable, os.path.join(HERE, 'bgb_wp_probe.py'), cf, '99999', '00:2464//x/L%a%,00:0040//x/VBL', pre, '--rom', rom, '--tail', '0', '--system', '3'], env=env, check=True, stdout=subprocess.DEVNULL)
    cnt = collections.Counter(l.strip() for l in open(lg, errors='replace') if l.strip())
    res.append([n] + [cnt.get('L%02X' % i, 0) for i in (0x1B, 0x1C, 0x1D, 0x1E)])
    print('N = %d: lists $1B $1C $1D $1E requested %s times' % (n, res[-1][1:]))
with open(os.path.join(out, 'run_star_hits.csv'), 'w', newline='') as f:
    w = csv.writer(f); w.writerow(['key_presses', 'list_1B', 'list_1C_star', 'list_1D', 'list_1E']); w.writerows(res)
im = Image.open(os.path.join(out, 'n31.bmp')).convert('RGB'); im.resize((im.width * 4, im.height * 4), Image.NEAREST).save(os.path.join(out, 'run_star_n31.png'))
