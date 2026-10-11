#!/usr/bin/env python3
"""Which block heads that my core's union never executed (merged_v8, 877 heads) does BGB execute?  Every such head gets a *logging* breakpoint (BGB writes the head
to debugmsg.txt and goes on); the lineage of a corpus entry (root save + joypad actions) is replayed and the hit counts are written out.
usage: bgb_never_probe.py CORPUS ENTRY ROM SYSTEM OUT.json            one entry
       bgb_never_probe.py CORPUS ROM SYSTEM OUT.jsonl --core CORE.json [--worker K/N]   one entry per distinct end (mode,state) of the replayed corpus, cheapest lineage
SYSTEM = BGB SystemMode (0 Game Boy, 2 Super Game Boy, 3 automatic).  Private BGB directory: /home/claude/bgbp<K>."""
import sys, os, json, shutil, collections
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
ROOT = os.path.dirname(HERE)
args = sys.argv[1:]
def opt(name, default=None):
    if name in args:
        i = args.index(name); v = args[i + 1]; del args[i:i + 2]; return v
    return default
core = opt('--core'); worker = opt('--worker', '0/1'); wk, wn = [int(x) for x in worker.split('/')]
mine = '/home/claude/bgbp%d' % wk
if not os.path.isdir(mine): shutil.copytree('/home/claude/bgbx', mine)
os.environ['BGB_DIR'] = mine
import bgb_run, numpy as np, blocks as B
CORE = [(1, 'Right'), (2, 'Left'), (4, 'Up'), (8, 'Down'), (16, 'A'), (32, 'B'), (64, 'Select'), (128, 'Start')]
def names(k): return '+'.join(n for m, n in CORE if k & m) or '-'
def load(corpus):
    C = {}
    for l in open(corpus):
        if l.strip(): e = json.loads(l); C[e['id']] = e
    return C
def probe(C, entry, rom, system, never):
    p = []; i = entry
    while i >= 0: p.append(i); i = C[i].get('parent', -1)
    p = p[::-1]; sp = dict(C[p[0]]['spec']); seq = []
    for j in p[1:]:
        for a in C[j]['actions']: seq.append((names(a[0]), int(a[1]), int(a[2])))
    sav = None
    for d in ('saves_unl', 'saves', 'intl_saves'):
        f = os.path.join(ROOT, d, sp['sav'] + '.sav')
        if os.path.exists(f): sav = f; break
    log = os.path.join(mine, 'debugmsg.txt')
    if os.path.exists(log): os.remove(log)
    tmp = '/home/claude/gbtmp_probe%d' % wk; os.makedirs(tmp, exist_ok=True)
    r = bgb_run.run(rom, sav, tmp + '/probe', seq, combo=0 if not sp['combo'] else bgb_run.mask(names(sp['combo'])), free=sp['free'] + 3,
                    br=','.join('%s///%s' % (h, h) for h in never), extra=['-setting', 'DebugMsgFile=1', '-setting', 'SystemMode=%s' % system], tail=30, timeout=900)
    cnt = collections.Counter(l.strip() for l in open(log, errors='replace') if l.strip()) if os.path.exists(log) else {}
    return dict(entry=entry, system=system, hit=len(cnt), hits=dict(sorted(cnt.items())), end='%02X:%02X' % (r['mode'], r['state']) if r['mode'] is not None else None)
def never_heads(rom):
    heads, members, code = B.blocks(open(rom, 'rb').read())
    ex = np.load(os.path.join(ROOT, 'merged_v8', 'cov.npz'))['ex']
    return ['%02X:%04X' % h for h in heads if not ex[B.flat(*h)]]
if core is None:
    corpus, entry, rom, system, out = args[0], int(args[1]), args[2], args[3], args[4]
    never = never_heads(rom); res = probe(load(corpus), entry, rom, system, never); res.update(corpus=corpus, never_heads=len(never))
    json.dump(res, open(out, 'w'), indent=1)
    print('system', system, 'entry', entry, ': %d of %d never-executed heads hit; end %s' % (res['hit'], len(never), res['end']))
    for h, c in res['hits'].items(): print(' ', h, c)
else:
    corpus, rom, system, out = args[:4]; C = load(corpus); never = never_heads(rom)
    E = json.load(open(core))['entries']; best = {}
    for i, e in E.items():
        if e['printer']: continue
        k = tuple(e['sig'])
        if k not in best or (e['frames'], int(i)) < best[k][:2]: best[k] = (e['frames'], int(i))
    todo = sorted(v[1] for v in best.values()); todo = [i for n, i in enumerate(todo) if n % wn == wk]
    done = set()
    if os.path.exists(out): done = {json.loads(l)['entry'] for l in open(out) if l.strip()}
    o = open(out, 'a')
    for n, i in enumerate(todo):
        if i in done: continue
        res = probe(C, i, rom, system, never); o.write(json.dumps(res) + '\n'); o.flush()
        print('[%d/%d] entry %d end %s (core %s): %d never-heads hit' % (n + 1, len(todo), i, res['end'], '%02X:%02X' % tuple(E[str(i)]['sig']), res['hit']), flush=True)
