#!/usr/bin/env python3
"""Phase 2 of the BGB re-trace: for every entry of a corpus that has "new heads" in phase 1 (bgb_trace_core.py), replay the entry's lineage (root + actions)
in BGB as a demo, with one *logging* breakpoint per new head (a breakpoint that writes a debug message instead of breaking: -br addr///addr, written to
BGB's debugmsg.txt) and one *breaking* breakpoint per block head that no core run ever executed (BGB exits when one is hit = a contradiction).
Result per entry (JSONL, resumable): heads confirmed / missing in BGB, never-executed heads hit, log lines, seconds.
Hot heads (logged more than HOT times in some run) are thinned with the breakpoint condition ..N (one message every N hits) and, if thinning loses them,
re-run unthinned alone.   usage: [BGB_SYSTEM=0|2|3] bgb_trace_run.py CORE_JSON CORPUS ROM RESULT.jsonl [--worker K/N] [--limit M] [--only ID,ID]
BGB_DIR = a private copy of the BGB directory per worker (debugmsg.txt is written there)."""
import sys, os, json, time, shutil, subprocess, collections
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
args = sys.argv[1:]
def opt(name, default=None):
    if name in args:
        i = args.index(name); v = args[i + 1]; del args[i:i + 2]; return v
    return default
worker = opt('--worker', '0/1'); limit = int(opt('--limit', '0')); only = opt('--only')
wk, wn = [int(x) for x in worker.split('/')]
core_json, corpus, rom, result = args[:4]
# private BGB directory for this worker
src_bgb = os.environ.get('BGB_SRC', '/home/claude/bgbx'); mine = '/home/claude/bgbw%d' % wk
if not os.path.isdir(mine): shutil.copytree(src_bgb, mine)
os.environ['BGB_DIR'] = mine
import bgb_run
import numpy as np
import blocks as B
ROOT = os.path.dirname(HERE)
NAMES = [(0x10, 'Right'), (0x20, 'Left'), (0x40, 'Up'), (0x80, 'Down'), (0x01, 'A'), (0x02, 'B'), (0x04, 'Select'), (0x08, 'Start')]
# core key bits (gbcov): RIGHT=1,LEFT=2,UP=4,DOWN=8,A=16,B=32,SELECT=64,START=128
CORE = [(1, 'Right'), (2, 'Left'), (4, 'Up'), (8, 'Down'), (16, 'A'), (32, 'B'), (64, 'Select'), (128, 'Start')]
def names(k): return '+'.join(n for m, n in CORE if k & m) or '-'
C = {}
for l in open(corpus):
    if l.strip(): e = json.loads(l); C[e['id']] = e
def lineage(i):
    p = []
    while i >= 0: p.append(i); i = C[i].get('parent', -1)
    return p[::-1]
def sav_file(name, tmp):
    for d in ('saves_unl', 'saves', 'intl_saves'):
        f = os.path.join(ROOT, d, name + '.sav')
        if os.path.exists(f): return f
    if name in ('_ff', '_zero'):
        f = os.path.join(tmp, name + '.sav'); open(f, 'wb').write((b'\xff' if name == '_ff' else b'\0') * 0x20000); return f
    return None
D = json.load(open(core_json)); E = D['entries']
heads, members, code = B.blocks(open(rom, 'rb').read())
# block heads never executed by any core run (v8 union, forced runs included): a hit in BGB is a contradiction
never = set()
cov = os.path.join(ROOT, 'merged_v8', 'cov.npz')
if os.path.exists(cov) and 'usa' not in rom and 'intl' not in rom:
    ex = np.load(cov)['ex']
    never = {'%02X:%04X' % h for h in heads if not ex[B.flat(*h)]}
hotfile = result + '.hot.json'; hot = json.load(open(hotfile)) if os.path.exists(hotfile) else {}
SYSTEM = os.environ.get('BGB_SYSTEM', '0')           # BGB SystemMode: 0 = Game Boy (DMG, like my core), 2 = Super Game Boy, 3 = automatic (SGB for this ROM)
HOT = int(os.environ.get('HOT', '3000')); THIN = int(os.environ.get('THIN', '1000'))
done = set()
if os.path.exists(result):
    for l in open(result):
        if l.strip(): done.add(json.loads(l)['id'])
todo = [int(k) for k, v in E.items() if v['new'] and not v['printer']]
todo = [i for i in sorted(todo) if i % wn == wk and i not in done]
if only: todo = [int(x) for x in only.split(',')]
if limit: todo = todo[:limit]
tmp = '/home/claude/gbtmp%d' % wk; os.makedirs(tmp, exist_ok=True)
def bgb_once(i, logheads, breakheads, tag, timeout=420):
    p = lineage(i); sp = dict(C[p[0]]['spec']); seq = []
    for j in p[1:]:
        for a in C[j]['actions']: seq.append((names(a[0]), int(a[1]), int(a[2])))
    sav = sav_file(sp['sav'], tmp)
    items = []
    for h in logheads:
        c = '..%d' % THIN if h in hot else ''
        items.append('%s/%s//%s' % (h, c, h))
    items += ['%s' % h for h in breakheads]
    log = os.path.join(mine, 'debugmsg.txt')
    if os.path.exists(log): os.remove(log)
    t0 = time.time()
    try:
        r = bgb_run.run(rom, sav, '%s/run_%s' % (tmp, tag), seq, combo=0 if not sp['combo'] else bgb_run.mask(names(sp['combo'])),
                        free=sp['free'] + 3, br=','.join(items), extra=['-setting', 'DebugMsgFile=1', '-setting', 'SystemMode=%s' % SYSTEM], tail=30, timeout=timeout)
        timed_out = False
    except subprocess.TimeoutExpired:
        r = None; timed_out = True
        subprocess.run(['pkill', '-f', 'bgbw%d/bgb.exe' % wk])
    cnt = collections.Counter()
    if os.path.exists(log):
        for l in open(log, errors='replace'):
            l = l.strip()
            if l: cnt[l] += 1
    return r, cnt, time.time() - t0, timed_out
out = open(result, 'a')
for n, i in enumerate(todo):
    new = E[str(i)]['new']; lines = 0; secs = 0.0; unexpected = []; confirmed = set(); notes = []
    brk = sorted(never)
    for attempt in range(6):                        # a break hit removes that head and re-runs
        r, cnt, dt, to = bgb_once(i, new, brk, 'e%d' % i); secs += dt; lines += sum(cnt.values())
        for h in list(cnt):
            if h in new: confirmed.add(h)
        for h, c in cnt.items():
            if c > HOT and h not in hot: hot[h] = c
        if to: notes.append('timeout'); break
        pc = r['pc'] if r else None
        if pc is not None:
            b = None
            for h in brk:
                if int(h.split(':')[1], 16) == pc: unexpected.append(h); brk = [x for x in brk if x != h]; break
            else: break
        else: break
    missing = [h for h in new if h not in confirmed]
    if missing and not to:                          # thinned or lost: re-run the missing heads unthinned, alone
        save_hot = dict(hot); hot.clear()
        r, cnt, dt, to = bgb_once(i, missing, [], 'e%dm' % i, timeout=300); secs += dt; lines += sum(cnt.values())
        for h in cnt:
            if h in missing: confirmed.add(h)
        hot.update(save_hot)
        missing = [h for h in new if h not in confirmed]
    rec = dict(id=i, new=len(new), confirmed=len(confirmed), missing=missing, unexpected=unexpected, lines=lines, secs=round(secs, 1), notes=notes,
               core_end=E[str(i)]['mode_state'], bgb_end='%02X:%02X' % (r['mode'], r['state']) if r and r['mode'] is not None else None)
    out.write(json.dumps(rec) + '\n'); out.flush(); json.dump(hot, open(hotfile, 'w'))
    print('[%d/%d] entry %d: %d/%d new heads confirmed, missing %d, unexpected %d, %d lines, %.0f s %s' % (n + 1, len(todo), i, len(confirmed), len(new), len(missing), len(unexpected), lines, secs, notes), flush=True)
