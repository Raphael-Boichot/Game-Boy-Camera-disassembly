#!/usr/bin/env python3
"""Who queued the ROM bytes that the interrupt copies (L3 helper): replay a coverage corpus in the core with the copy-queue origin recording on
(coverage/src/gbcov.c, GBCAM_QPC) and write, for every ROM byte that a queue routine read, the routine that wrote the queue entry and the two call
sites above it.
  GBCAM_ROM=ROM port_queue_origin.py SYM CORPUS.jsonl OUT.npz [--limit N]
SYM gives the queue routines: Vq_Process .. the label after Vq_RunStream, and Irq_VBlank_CopyRequest .. the label after it (the copy-request routine).
The corpus is replayed depth first (each entry's own actions once, from its parent's snapshot); saves are looked up as lib.SAV does (tcrf_check/saves*).
OUT.npz: qsite, qsite2, qsite3 = (0x80000000 | bank << 16 | pc) of the writer and its two callers, 0 where no queue routine read the byte;
         site, site2, dr, rdr = the read sites of this replay (set GBCAM_SITE_ALL=1), in the format of a coverage cov.npz (tools/port_check_names4.py reads them).
PYTHONPATH: coverage/src and tools/jp."""
import sys, os, time
import numpy as np
a = sys.argv[1:]
lim = int(a[a.index('--limit') + 1]) if '--limit' in a else 0
sym, corpus, out = a[0], a[1], a[2]
S = {}
for l in open(sym):
    p = l.split()
    if len(p) == 2 and ':' in p[0]: S[p[1]] = (int(p[0][:2], 16), int(p[0][3:], 16))
lab = sorted(v[1] for k, v in S.items() if v[0] == 0)
def nxt(n): return min(x for x in lab if x > S[n][1]) - 1
os.environ['GBCAM_QPC'] = '%x-%x,%x-%x' % (S['Vq_Process'][1], nxt('Vq_RunStream'), S['Irq_VBlank_CopyRequest'][1], nxt('Irq_VBlank_CopyRequest'))
print('GBCAM_QPC', os.environ['GBCAM_QPC'], flush=True)
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, os.path.join(os.path.dirname(HERE), 'tools', 'jp'))
import lib; from lib import g
C = lib.Corpus(corpus); kids = {}
for i, e in C.E.items(): kids.setdefault(e.get('parent', -1), []).append(i)
n = 0; t0 = time.time(); stack = [(r, None) for r in kids.get(-1, [])]
while stack:
    i, snap = stack.pop(); e = C.E[i]
    if 'spec' in e:
        sp = e['spec']; sv = lib.SAV(sp['sav'])
        if sv is None: continue
        lib.boot(sv, combo=sp['combo'], printer=sp['printer'], free=sp['free'])
    else:
        g.restore(snap)
        for x in e['actions']: lib.act(x)
    n += 1
    if i in kids:
        s2 = g.snapshot(); stack += [(k, s2) for k in kids[i]]
    if n % 500 == 0: print(n, 'entries, %.0fs' % (time.time() - t0), int((g.qsite(0) != 0).sum()), 'bytes with an origin', flush=True)
    if lim and n >= lim: break
np.savez_compressed(out, qsite=np.array(g.qsite(0)), qsite2=np.array(g.qsite(1)), qsite3=np.array(g.qsite(2)),
                    site=np.array(g.site()), site2=np.array(g.site2()), dr=(np.array(g.cov_dread()) != 0).astype(np.uint8), rdr=np.array(g.cov_reader()))     # with GBCAM_SITE_ALL=1: read sites, interrupt-safe (gbcov.c 2026-11-02)
print(n, 'entries replayed;', int((g.qsite(0) != 0).sum()), 'ROM bytes with a queue origin ->', out)
