#!/usr/bin/env python3
"""v2: + compare-log guided state pokes, forced mode changes, organic/tainted split.
Resumable snapshot-guided coverage fuzzer for the Pocket Camera (JP Rev A) ROM, on the native gbcov core.
Persistence (state dir): cov.npz (coverage), corpus.jsonl (replayable tree of entries), stats.json, log.txt.
Corpus entries are stored as replay recipes (seed spec / parent + actions) -> tiny files, rebuilt by deterministic replay on resume.
Usage: coverage_run.py [--state DIR] [--mirror DIR] [--hours H] [--seed N]
"""
import sys as _s, os as _o
_s.path.insert(0, _o.path.join(_o.path.dirname(_o.path.abspath(__file__)), '..', 'src'))
import paths
import os, sys, time, json, random, signal, shutil, argparse, glob
import numpy as np
import gbcov as g

ap = argparse.ArgumentParser()
ap.add_argument('--rom', default=paths.ROM)
ap.add_argument('--savdir', default=paths.SAVES)
ap.add_argument('--state', default=_o.path.join(paths.COV, 'state'))
ap.add_argument('--mirror', default=os.path.join(paths.COV, 'results', 'mirror'))
ap.add_argument('--hours', type=float, default=0)
ap.add_argument('--seed', type=int, default=1)
ap.add_argument('--ckpt', type=int, default=120)
ap.add_argument('--maxmem', type=int, default=1200)
args = ap.parse_args()
os.makedirs(args.state, exist_ok=True)
if args.mirror: os.makedirs(args.mirror, exist_ok=True)
LOG = open(os.path.join(args.state, 'log.txt'), 'a')
def log(*a):
    s = time.strftime('%F %T ') + ' '.join(str(x) for x in a); print(s, flush=True); LOG.write(s + '\n'); LOG.flush()

g.load_rom(args.rom)
# known-instruction-start bitmap from the static trace, used as a guard for forced-state (non-organic) runs
def _flat(b, a): return a if b == 0 and a < 0x4000 else b * 0x4000 + (a - 0x4000)
_t = json.load(open(paths.TRACE))
KNOWN = np.zeros(g.ROMSZ, np.uint8)
for _k, _n in _t['code'].items():
    if _n > 0: _b, _a = _k.split(':'); KNOWN[_flat(int(_b, 16), int(_a, 16))] = 1
del _t
g.set_known(KNOWN)
rng = random.Random(args.seed + int(time.time()) % 100000)

# ---------------------------------------------------------------- seeds
SAVES = {}
for p in sorted(glob.glob(os.path.join(args.savdir, '*.sav'))):
    SAVES[os.path.basename(p)[:-4]] = open(p, 'rb').read()
SAVES['_zero'] = bytes(0x20000)
SAVES['_ff'] = b'\xff' * 0x20000
BOOTCOMBOS = [0, g.A, g.B, g.START, g.SELECT, g.UP, g.DOWN, g.LEFT, g.RIGHT, g.A | g.B, g.SELECT | g.START,
              g.A | g.B | g.SELECT | g.START, g.UP | g.SELECT | g.B, g.DOWN | g.SELECT | g.A, g.LEFT | g.A | g.B,
              g.RIGHT | g.START | g.B, g.UP | g.A, g.DOWN | g.B]

if os.environ.get('BOOTCOMBOS'): BOOTCOMBOS = [int(x, 0) for x in os.environ['BOOTCOMBOS'].split(',')]
def seed_snapshot(spec):
    g.set_organic(1)
    g.reset(SAVES[spec['sav']])
    g.L.gb_attach_printer(1 if spec['printer'] else 0)
    g.keys(spec['combo']); g.run(250); g.keys(0); g.run(spec['free'])
    return g.snapshot()

def apply_action(a):
    if a[0] == 'P':
        _, pf, wait, pairs = a
        for _ in range(pf):
            for ad, v in pairs: g.poke(ad, v)
            g.run(1)
        g.run(wait)
    else:
        k, hold, wait = a; g.keys(k); g.run(hold); g.keys(0); g.run(wait)
def apply_actions(actions):
    for a in actions: apply_action(a)

# ---------------------------------------------------------------- corpus
entries = []           # dict(id,parent,spec|actions,gain,sig,t)
snaps = {}             # id -> bytes (in memory subset)
sigs = {}              # (D5CE,D5CF) -> first entry id
def counters(): return (g.L.gb_cnt_exec(), g.L.gb_cnt_dread(), g.L.gb_cnt_ram(), g.L.gb_bsel_n(0))
def csum(c): return sum(c)
def cursig(): return (g.peek(0xD5CE), g.peek(0xD5CF))

def get_snap(i, depth=0):
    if i in snaps: return snaps[i]
    g.set_organic(0)
    e = entries[i]
    if 'spec' in e: s = seed_snapshot(e['spec'])
    else:
        base = get_snap(e['parent'], depth + 1); g.restore(base); apply_actions(e['actions']); s = g.snapshot()
    if depth == 0 or len(snaps) < args.maxmem: snaps[i] = s
    return s

def add_entry(parent, actions=None, spec=None, gain=0, tainted=False):
    e = dict(id=len(entries), parent=parent, gain=int(gain), sig=list(cursig()), t=round(time.time() - T0), tainted=bool(tainted))
    if spec is not None: e['spec'] = spec
    else: e['actions'] = [list(a) for a in actions]
    entries.append(e); snaps[e['id']] = g.snapshot()
    s = tuple(e['sig']); 
    if s not in sigs: sigs[s] = e['id']
    return e['id']

# ---------------------------------------------------------------- persistence
def atomic_write(path, data, mode='wb'):
    tmp = path + '.tmp'
    with open(tmp, mode) as f: f.write(data)
    os.replace(tmp, path)

stats = dict(iters=0, frames=0, secs=0.0, ckpts=0, wild=0)
def checkpoint(final=False):
    t = time.time()
    g.cov_save(os.path.join(args.state, 'cov_tmp.npz')); os.replace(os.path.join(args.state, 'cov_tmp.npz'), os.path.join(args.state, 'cov.npz'))
    atomic_write(os.path.join(args.state, 'corpus.jsonl'), '\n'.join(json.dumps(e) for e in entries) + '\n', 'w')
    st = dict(stats); st.update(counters=dict(zip(('exec_bytes', 'rom_data_bytes', 'ram_exec_addrs', 'bank_select_sites'), counters())),
                       organic_exec_bytes=int((g.org_exec() != 0).sum()), organic_rom_data_bytes=int((g.org_dread() != 0).sum()),
                       entries=len(entries), snaps=len(snaps), sigs=len(sigs), tainted_entries=sum(1 for e in entries if e.get('tainted')), final=final, time=time.strftime('%F %T'))
    st['sig_list'] = sorted(['%02X:%02X' % s for s in sigs])
    atomic_write(os.path.join(args.state, 'stats.json'), json.dumps(st, indent=1), 'w')
    stats['ckpts'] += 1
    if args.mirror:
        for f in ('cov.npz', 'corpus.jsonl', 'stats.json', 'log.txt'):
            try: shutil.copy2(os.path.join(args.state, f), os.path.join(args.mirror, f + '.tmp')); os.replace(os.path.join(args.mirror, f + '.tmp'), os.path.join(args.mirror, f))
            except Exception as ex: log('mirror fail', f, ex)
    log('checkpoint %.1fs' % (time.time() - t), st['counters'], 'entries', len(entries), 'sigs', len(sigs))

# ---------------------------------------------------------------- resume / init
T0 = time.time()
resumed = os.path.exists(os.path.join(args.state, 'corpus.jsonl')) and os.path.exists(os.path.join(args.state, 'cov.npz'))
if resumed:
    log('RESUME from', args.state)
    for line in open(os.path.join(args.state, 'corpus.jsonl')):
        if line.strip(): entries.append(json.loads(line))
    try: stats.update({k: v for k, v in json.load(open(os.path.join(args.state, 'stats.json'))).items() if k in stats})
    except Exception: pass
    # rebuild snapshots: most recent + entries that introduced a new signature + high gain
    first_sig = {}
    for e in entries: first_sig.setdefault(tuple(e['sig']), e['id'])
    keep = set(first_sig.values()) | set(e['id'] for e in sorted(entries, key=lambda e: -e['gain'])[:200]) | set(e['id'] for e in entries[-args.maxmem // 2:]) | set(e['id'] for e in entries if 'spec' in e)
    for i in sorted(keep):
        try: get_snap(i)
        except Exception as ex: log('rebuild fail', i, ex)
    sigs.update({k: v for k, v in first_sig.items()})
    g.cov_restore(os.path.join(args.state, 'cov.npz'))
    log('resumed entries', len(entries), 'snaps', len(snaps), 'counters', counters())
else:
    log('FRESH run; saves', len(SAVES), 'combos', len(BOOTCOMBOS))
    for sv in SAVES:
        for ci, combo in enumerate(BOOTCOMBOS):
            for pr in (0, 1) if ci in (0, 3) else (0,):
                spec = dict(sav=sv, combo=combo, printer=pr, free=rng.choice([60, 200, 400]))
                snaps_tmp = seed_snapshot(spec); add_entry(-1, spec=spec, gain=0)
    log('seeds', len(entries), 'counters', counters())
    checkpoint()

# ---------------------------------------------------------------- fuzz loop
ACT_KEYS = [(g.A, 20), (g.B, 12), (g.START, 8), (g.SELECT, 5), (g.UP, 12), (g.DOWN, 12), (g.LEFT, 10), (g.RIGHT, 10), (0, 6),
            (g.A | g.B, 2), (g.A | g.UP, 1), (g.A | g.DOWN, 1), (g.B | g.UP, 1), (g.B | g.DOWN, 1), (g.SELECT | g.START, 1), (g.A | g.START, 1),
            (g.SELECT | g.A, 1), (g.SELECT | g.B, 1), (g.A | g.B | g.SELECT | g.START, 0.2)]
KEYS = [k for k, w in ACT_KEYS]; WTS = [w for k, w in ACT_KEYS]
HOLDS = [1, 2, 3, 4, 6, 8, 12, 30]; WAITS = [2, 5, 10, 20, 40, 80, 160, 300]
def rand_action(): return (rng.choices(KEYS, WTS)[0], rng.choice(HOLDS), rng.choice(WAITS))
def poke_action(c):
    src, val, kind, pc = c
    if kind == 0:
        v = rng.choice([val, val, val, (val + 1) & 255, (val - 1) & 255, (val + 2) & 255, 0, 255])
    else:
        cur = g.peek(src); v = (cur | val) & 255 if rng.random() < 0.5 else cur & ~val & 255
    return ['P', rng.choice([1, 2, 5, 20]), rng.choice([5, 20, 60, 200]), [[src, v]]]
def mode_action():
    return ['P', 1, rng.choice([30, 100, 300]), [[0xD5CE, rng.randrange(0, 0x22)], [0xD5CF, 0]]]
POOL = {}      # (src,val,kind) -> uses ; persistent pool of exit conditions seen anywhere
RDPOOL = {}    # addr -> last value seen
def havoc_action(addr, val):
    c = rng.random()
    if c < 0.30: v = (val + 1) & 255
    elif c < 0.55: v = (val - 1) & 255
    elif c < 0.75: v = rng.randrange(0, 8)
    elif c < 0.85: v = val ^ (1 << rng.randrange(8))
    elif c < 0.93: v = 0
    else: v = rng.randrange(0, 256)
    return ['P', rng.choice([1, 2, 5]), rng.choice([5, 20, 60, 200]), [[addr, v]]]
P_HAVOC = float(os.environ.get('P_HAVOC', 0.10)); P_POOL = float(os.environ.get('P_POOL', 0.30))
P_POKE = float(os.environ.get('P_POKE', 0.30)); P_MODE = float(os.environ.get('P_MODE', 0.02))

stop = False
def on_sig(sn, fr):
    global stop; stop = True
signal.signal(signal.SIGTERM, on_sig); signal.signal(signal.SIGINT, on_sig)
t_last = time.time(); t_log = time.time(); deadline = time.time() + args.hours * 3600 if args.hours else None
while not stop:
    if deadline and time.time() > deadline: break
    ids = list(snaps.keys())
    pid = rng.choice(ids) if rng.random() < 0.5 else rng.choice(ids[-60:])
    g.restore(snaps[pid])
    tainted = bool(entries[pid].get('tainted', False)); g.set_organic(not tainted)
    c0 = counters(); seq = []; chain_parent = pid
    g.cmp_clear(); cands = []; rdc = []
    if 'poolkeys' not in globals(): poolkeys = []
    n = rng.choice([2, 3, 4, 6, 8, 12])
    for step in range(n):
        a = None; r = rng.random()
        if r < P_POKE and (cands or poolkeys):
            if poolkeys and (not cands or rng.random() < P_POOL): a = poke_action(rng.choice(poolkeys) + (0,))
            else: a = poke_action(rng.choice(cands))
        elif r < P_POKE + P_HAVOC and rdc:
            a = havoc_action(*rng.choice(rdc))
        elif r < P_POKE + P_HAVOC + P_MODE: a = mode_action()
        if a is None: a = rand_action()
        if a[0] == 'P' and not tainted: tainted = True; g.set_organic(0)
        seq.append(a); apply_action(a); stats['frames'] += (a[1] + a[2]) if a[0] == 'P' else (a[1] + a[2])
        if g.wild(): break          # forced state led outside known code: discard the rest of this iteration
        cands = [c_ for c_ in g.cmp_dump() if not 0xDE00 <= c_[0] < 0xE000]; rdc = [x for x in g.rd_dump() if not 0xDE00 <= x[0] < 0xE000]; g.cmp_clear()   # never poke the stack ($DE00-$DFFF): a poked return address lands inside unrelated code
        for c_ in cands:
            k_ = c_[:3]
            if len(POOL) < 30000: POOL.setdefault(k_, 0)
        if cands and (stats['iters'] & 63) == 0: poolkeys = list(POOL.keys())
        c1 = counters()
        if csum(c1) > csum(c0):
            gain = csum(c1) - csum(c0)
            chain_parent = add_entry(chain_parent, actions=seq, gain=gain, tainted=tainted); seq = []; c0 = c1
            if len(snaps) > args.maxmem:
                cand = [i for i in snaps if 'spec' not in entries[i] and sigs.get(tuple(entries[i]['sig'])) != i and i != chain_parent]
                for i in rng.sample(cand, min(len(cand), len(snaps) - args.maxmem)): snaps.pop(i, None)
    stats['iters'] += 1
    if g.wild(): stats['wild'] = stats.get('wild', 0) + 1
    now = time.time()
    if now - t_log > 30:
        t_log = now
        log('it %d fr %d  %s org_ex %d entries %d (tainted %d) sigs %d' % (stats['iters'], stats['frames'], dict(zip(('ex', 'dr', 'ram', 'bsel'), counters())),
            int((g.org_exec() != 0).sum()), len(entries), sum(1 for e in entries[-300:] if e.get('tainted')), len(sigs)))
    if now - t_last > args.ckpt:
        t_last = now; stats['secs'] += args.ckpt; checkpoint()
checkpoint(final=True); log('stopped')
