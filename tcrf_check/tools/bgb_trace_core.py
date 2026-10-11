#!/usr/bin/env python3
"""Phase 1 of the BGB re-trace (core side): replay every entry of a replayable corpus depth-first in my core and record, per entry, the basic-block
heads (tools/blocks.py) that its own segment executes for the first time ("new heads", first in depth-first order).  Every block head executed by the
corpus therefore has exactly one witness entry, whose lineage (root + actions) is what BGB has to replay (phase 2, bgb_trace_run.py).
Entries whose lineage contains a RAM poke ('P' action) or is flagged "tainted" cannot be replayed with joypad input alone and are skipped together with their
descendants (they are counted in the output as "forced").
usage: bgb_trace_core.py CORPUS OUT.json [--all]     (GBCAM_ROM selects the ROM; default Japanese; --all also replays poked / tainted entries)"""
import sys, os, json, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g
import numpy as np
import blocks as B
corpus, out = sys.argv[1:3]; ALL = '--all' in sys.argv; forced = []
C = lib.Corpus(corpus)
heads, members, code = B.blocks()
hoff = np.array([B.flat(*h) for h in heads]); hidx = {h: i for i, h in enumerate(heads)}
kids = {}
for i, e in C.E.items(): kids.setdefault(e.get('parent', -1), []).append(i)
res = {}; t0 = time.time()
ex = g.cov_exec(); ex[:] = 0                                   # coverage of this corpus only
def new_heads(before):
    now = ex[hoff] > 0
    return [heads[i] for i in np.nonzero(now & ~before)[0]]
def seg_frames(e): return 250 + e['spec']['free'] if 'spec' in e else sum(int(a[1]) + int(a[2]) for a in e['actions'])
def visit(i, snap_parent, frames_parent, printer_parent):
    e = C.E[i]
    if not ALL and (e.get('tainted') or any(a[0] == 'P' for a in e.get('actions', []))):
        forced.append(i); return
    before = ex[hoff] > 0
    if 'spec' in e:
        sp = dict(e['spec']); lib.boot(lib.SAV(sp['sav']), combo=sp['combo'], printer=sp['printer'], free=sp['free']); printer = sp['printer']
    else:
        g.restore(snap_parent); printer = printer_parent
        for a in e['actions']: lib.act(a)
    nh = new_heads(before)
    frames = frames_parent + seg_frames(e)
    res[i] = dict(parent=e.get('parent', -1), frames=frames, printer=printer, sig=e['sig'], new=['%02X:%04X' % h for h in nh],
                  mode_state='%02X:%02X' % lib.cur())
    if i in kids:
        snap = g.snapshot()
        for k in kids[i]: visit(k, snap, frames, printer)
sys.setrecursionlimit(10000)
for r in kids.get(-1, []): visit(r, None, 0, 0)
done = ex[hoff] > 0
json.dump(dict(corpus=corpus, rom=lib.ROM, heads=len(heads), executed_heads=int(done.sum()), forced_skipped=len(forced), entries=res), open(out, 'w'))
ninstr = sum(len(members[h]) for i, h in enumerate(heads) if done[i])
print('forced entries skipped (with all descendants):', len(forced), ' replayed entries', len(res))
print('entries', len(res), 'block heads executed', int(done.sum()), 'of', len(heads), '= instructions', ninstr, 'of', len(code), 'in %.0f s' % (time.time() - t0))
print('entries with new heads', sum(1 for v in res.values() if v['new']), ' printer lineages', sum(1 for v in res.values() if v['printer']))
