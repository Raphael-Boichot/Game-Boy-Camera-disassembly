#!/usr/bin/env python3
"""Run named BGB jobs (rom, save, key sequence) in parallel and keep the screenshot and the game's (mode,state).  Library for bgb_us_jp_capture.py.
Every worker process has its own copy of the BGB directory (BGB_DIR = /home/claude/bgbp<K>)."""
import os, sys, json, shutil, subprocess
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
from concurrent.futures import ProcessPoolExecutor
def _init(q):
    k = q.get(); d = '/home/claude/bgbq%d' % k
    if not os.path.isdir(d): shutil.copytree('/home/claude/bgbx', d)
    os.environ['BGB_DIR'] = d
    import bgb_run; bgb_run.BGB = d
def _run(job):
    import bgb_run
    name, rom, sav, seq, out, combo, free, tail = job
    for attempt in range(2):
        try:
            r = bgb_run.run(rom, sav, os.path.join(out, name), seq, combo=combo, free=free, tail=tail, timeout=400)
            ok = os.path.exists(os.path.join(out, name + '.bmp'))
            if ok:
                w = r['st'].get('WRAM', b'')
                g = lambda a: w[a - 0xC000] if w else None
                return name, ('%02X:%02X' % (r['mode'], r['state']) if r['mode'] is not None else None) + ' D63D=%s D63E=%s D63F=%s D614=%s D659=%s D642=%s D5D8=%s D665=%s' % tuple(g(a) for a in (0xD63D, 0xD63E, 0xD63F, 0xD614, 0xD659, 0xD642, 0xD5D8, 0xD665))
        except Exception as e:
            err = type(e).__name__
    return name, None
def run_jobs(jobs, workers=3):
    import multiprocessing as mp
    m = mp.Manager(); q = m.Queue()
    for k in range(workers): q.put(k)
    res = {}
    with ProcessPoolExecutor(workers, initializer=_init, initargs=(q,)) as ex:
        for name, st in ex.map(_run, jobs):
            res[name] = st; print('%-40s %s' % (name, st), flush=True)
    return res
