#!/usr/bin/env python3
"""Differential replay: replay the untainted (organic) key-sequence trees of earlier fuzz passes with the root save REPLACED by an unlocking save.
Coverage is recorded as organic (joypad + SRAM image only). Anything new versus the earlier merged coverage is unlock-gated.
usage: unlock_replay.py CORPUS.jsonl UNLOCK.sav OUTDIR [--max-roots N] [--ckpt SECONDS]"""
import sys, os, json, time, collections, shutil, argparse
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g
import numpy as np
ap = argparse.ArgumentParser(); ap.add_argument('corpus'); ap.add_argument('sav'); ap.add_argument('out')
ap.add_argument('--max-roots', type=int, default=0); ap.add_argument('--ckpt', type=int, default=240); ap.add_argument('--mirror', default='')
a = ap.parse_args(); os.makedirs(a.out, exist_ok=True)
LOG = open(os.path.join(a.out, 'log.txt'), 'a')
def log(*x):
    s = time.strftime('%F %T ') + ' '.join(str(i) for i in x); print(s, flush=True); LOG.write(s + '\n'); LOG.flush()
es = [json.loads(l) for l in open(a.corpus) if l.strip()]
byid = {e['id']: e for e in es}; kids = collections.defaultdict(list); roots = []
for e in es:
    if e.get('tainted'): continue
    if 'spec' in e:
        if e['spec']['sav'] in ('_zero', '_ff'): continue
        roots.append(e)
    elif e.get('parent', -1) in byid and not byid[e['parent']].get('tainted'): kids[e['parent']].append(e)
# one root per (combo, printer, free): the subtree of the dropped duplicates is attached to the kept root (same snapshot after replacement)
seen = {}; keep = []
for r in roots:
    k = (r['spec']['combo'], r['spec']['printer'], r['spec']['free'])
    if k not in seen: seen[k] = r['id']; keep.append(r)
    else: kids[seen[k]].extend(kids[r['id']])
if a.max_roots: keep = keep[:a.max_roots]
sav = open(a.sav, 'rb').read(); name = os.path.basename(a.sav)[:-4]
log('corpus', a.corpus, 'entries', len(es), 'roots', len(roots), 'kept', len(keep), 'save', name)
g.set_organic(1)
nrep = 0; changed = 0; sigchg = collections.Counter(); t0 = time.time(); t_ck = t0; frames = 0
def ckpt(final=False):
    g.cov_save(os.path.join(a.out, 'cov_tmp.npz')); os.replace(os.path.join(a.out, 'cov_tmp.npz'), os.path.join(a.out, 'cov.npz'))
    json.dump(dict(replayed=nrep, sig_changed=changed, frames=frames, secs=round(time.time() - t0), final=final, save=name, corpus=a.corpus,
                   exec_bytes=int((g.cov_exec() != 0).sum()), organic_exec_bytes=int((g.org_exec() != 0).sum()), data_bytes=int((g.cov_dread() != 0).sum()),
                   top_sig_changes=[[k, v] for k, v in sigchg.most_common(60)]), open(os.path.join(a.out, 'stats.json'), 'w'), indent=1)
    if a.mirror:
        os.makedirs(a.mirror, exist_ok=True)
        for f in ('cov.npz', 'stats.json', 'log.txt'): shutil.copy2(os.path.join(a.out, f), os.path.join(a.mirror, f))
    log('ckpt', nrep, 'replayed', 'exec', int((g.cov_exec() != 0).sum()), 'organic', int((g.org_exec() != 0).sum()), 'sigchg', changed)
for r in keep:
    sp = dict(r['spec']); lib.boot(sav, combo=sp['combo'], printer=sp['printer'], free=sp['free'])
    snap0 = g.snapshot(); stack = [(snap0, iter(kids[r['id']]))]
    while stack:
        snap, it = stack[-1]; c = next(it, None)
        if c is None: stack.pop(); continue
        g.restore(snap)
        for x in c['actions']: lib.act(x); frames += x[1] + x[2]
        s = (g.peek(0xD5CE), g.peek(0xD5CF)); nrep += 1
        if list(s) != list(c['sig']): changed += 1; sigchg['%02X:%02X' % tuple(c['sig']) + ' -> ' + '%02X:%02X' % s] += 1
        if kids[c['id']]: stack.append((g.snapshot(), iter(kids[c['id']])))
        if time.time() - t_ck > a.ckpt: t_ck = time.time(); ckpt()
ckpt(final=True); log('done', nrep, 'entries', frames, 'frames', round(time.time() - t0), 's')
