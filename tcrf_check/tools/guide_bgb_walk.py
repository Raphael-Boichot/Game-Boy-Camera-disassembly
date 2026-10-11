#!/usr/bin/env python3
"""BGB walk of the Funtography flowcharts: every node of guide_nodes.NODES (plus the Space Fever II routes) on the Japanese and the international ROM, same key presses
(main menu mirrored: the VIEW key is Left on the Japanese ROM and Right on the international one), BGB screenshot and game (mode,state) at the end of every path.
usage: guide_bgb_walk.py OUTDIR [--workers N] [--only ID,ID] [--rom jp|us]      -> OUTDIR/<rom>_<id>.bmp, OUTDIR/guide_walk_results.json"""
import sys, os, json
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE); ROOT = os.path.dirname(HERE)
import bgb_us_jp_job as J
import guide_nodes as G
a = sys.argv[1:]
def opt(n, d=None):
    if n in a: i = a.index(n); v = a[i + 1]; del a[i:i + 2]; return v
    return d
workers = int(opt('--workers', '2')); only = opt('--only'); only = set(only.split(',')) if only else None; romsel = opt('--rom')
out = os.path.abspath(a[0]); os.makedirs(out, exist_ok=True)
ROMS = dict(jp=(os.path.join(ROOT, 'pocketcamera_jp.gb'), 'L'), us=(os.path.join(ROOT, 'roms', 'gbcam_usa_eu.gb'), 'R'))
SAV = os.path.join(ROOT, 'saves_unl', 'unl_CE10238211.sav')
NAME = dict(A='A', B='B', L='Left', R='Right', U='Up', D='Down', s='Select', S='Start')
def K(t): return (NAME[t], 4, 60 if t in 'LRUD' else 200)
def seq_for(path, vk): return [('A', 4, 200)] + [K(t) for t in G.tokens(path, vk)]
from guide_bgb_walk_specials import SPECIAL
jobs = []
for rom, (path, vk) in ROMS.items():
    if romsel and rom != romsel: continue
    seen = set()
    for chart, nid, label, p, exp in G.NODES:
        if only and nid not in only: continue
        jobs.append(('%s_%s' % (rom, nid), path, SAV, seq_for(p, vk), out, 2, 400, 2))
    for nid, label, f in SPECIAL:
        if only and nid not in only: continue
        jobs.append(('%s_%s' % (rom, nid), path, SAV, f(vk), out, 2, 400, 2))
print(len(jobs), 'jobs', flush=True)
res = J.run_jobs(jobs, workers)
rf = os.path.join(out, 'guide_walk_results.json')
old = json.load(open(rf)) if os.path.exists(rf) else {}
old.update(res); json.dump(old, open(rf, 'w'), indent=1)
