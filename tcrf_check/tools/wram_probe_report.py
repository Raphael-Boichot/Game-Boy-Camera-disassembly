#!/usr/bin/env python3
"""Summarise the BGB watchpoint log of wram_probe.py (README 2.13).

usage: wram_probe_report.py PROBE.csv WATCH.csv SITES_OUT.csv NAMES_OUT.csv [--sym pocketcamera_jp.sym] [--access wram/wram_access.csv]
  PROBE.csv   output of wram_probe.py: entry, sig, end, kind R|W, addr (start of the watched range), pc, mode, state, rombank, value, a, hits
  WATCH.csv   name, addr, size, tag, static (tcrf_check/tools/wram_probe_list.py)
SITES_OUT   one row per (access kind, name, bank:pc): hits, replays, modes, values, class
              S    the instruction is a proven access site of wram_access.csv (R/W row of that name at that bank:pc)
              ptr  the routine that holds the instruction also loads the address as a pointer (P row), so a pointer-based access is expected there
              boot the cold-boot / soft-reset memory clear (bank 0, game mode 00 or the fill loops of bank 0)
              dyn  anything else: an access that the access table does not list (reported, never silently dropped)
NAMES_OUT   one row per name: tag, hits without the boot clear, replays, modes, values, proven access sites that never fired, sites of class dyn"""
import sys, csv, re, collections, bisect, os
args = sys.argv[1:]
def opt(n, d=None):
    if n in args:
        i = args.index(n); v = args[i + 1]; del args[i:i + 2]; return v
    return d
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sym = opt('--sym', ROOT + '/pocketcamera_jp.sym'); acc = opt('--access', ROOT + '/wram/wram_access.csv')
probe, watch, sites_out, names_out = args[:4]
W = list(csv.DictReader(open(watch, encoding='utf-8')))
byaddr = {int(r['addr'], 16): r for r in W}
labels = collections.defaultdict(list)
for l in open(sym, encoding='utf-8'):
    m = re.match(r'([0-9a-fA-F]{2}):([0-9a-fA-F]{4}) (\S+)', l)
    if m: labels[int(m.group(1), 16)].append((int(m.group(2), 16), m.group(3)))
for b in labels: labels[b].sort()
def routine(bank, pc):
    L = labels.get(bank, [])
    i = bisect.bisect_right([a for a, _ in L], pc) - 1
    return L[i][1] if i >= 0 else '?'
# static sites per watch row
static = collections.defaultdict(set); ptrfn = collections.defaultdict(set)
for r in csv.DictReader(open(acc, encoding='utf-8')):
    a = int(r['addr'], 16)
    for w in W:
        lo = int(w['addr'], 16)
        if lo <= a < lo + int(w['size']):
            b = int(r['bank'], 16); pc = int(r['pc'], 16)
            if r['kind'] in 'RW': static[w['name']].add((r['kind'], b, pc))
            else: ptrfn[w['name']].add(routine(b, pc))
S = collections.OrderedDict()
for r in csv.DictReader(open(probe)):
    lo = int(r['addr'], 16); w = byaddr[lo]
    pc = int(r['pc'], 16); bank = 0 if pc < 0x4000 else int(r['rombank'], 16)
    key = (r['kind'], w['name'], bank, pc)
    d = S.setdefault(key, dict(hits=0, ents=set(), modes=collections.Counter(), vals=collections.Counter(), avals=collections.Counter(), boot=0))
    h = int(r['hits']); d['hits'] += h; d['ents'].add(r['entry']); d['modes'][r['mode'] + ':' + r['state']] += h
    d['vals'][r['value']] += h
    if r['kind'] == 'W': d['avals'][r['a']] += h
def klass(key, d):
    k, n, b, pc = key
    if (k, b, pc) in static[n]: return 'S'
    if routine(b, pc) in ptrfn[n]: return 'ptr'
    if b == 0 and set(m.split(':')[0] for m in d['modes']) <= {'00'}: return 'boot'
    return 'dyn'
def top(c, n=10):
    items = sorted(c.items(), key=lambda kv: (-kv[1], kv[0]))
    s = ' '.join(k for k, _ in items[:n]); return s + (' +%d' % (len(items) - n) if len(items) > n else '')
with open(sites_out, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['kind', 'name', 'addr', 'bank', 'pc', 'routine', 'class', 'hits', 'replays', 'mode_state', 'values', 'a_written'])
    for key in sorted(S, key=lambda k: (int(byaddr_name := 0) or 0, )) if False else sorted(S, key=lambda k: (next(int(x['addr'], 16) for x in W if x['name'] == k[1]), k[0], k[2], k[3])):
        d = S[key]; k, n, b, pc = key; r = next(x for x in W if x['name'] == n)
        w.writerow([k, n, r['addr'], '%02X' % b, '%04X' % pc, routine(b, pc), klass(key, d), d['hits'], len(d['ents']), top(d['modes'], 6),
                    top(d['vals']) if r['size'] == '1' else '', top(d['avals']) if k == 'W' and r['size'] == '1' else ''])
with open(names_out, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n')
    w.writerow(['name', 'addr', 'size', 'tag', 'R_hits', 'W_hits', 'boot_hits', 'replays', 'modes', 'values_read', 'static_sites', 'static_never_fired', 'dyn_sites'])
    for r in W:
        n = r['name']; rd = wr = bt = 0; ents = set(); modes = collections.Counter(); vals = collections.Counter(); seen = set(); dyn = set()
        for key, d in S.items():
            if key[1] != n: continue
            c = klass(key, d)
            if c == 'boot': bt += d['hits']; continue
            if key[0] == 'R': rd += d['hits']; vals.update(d['vals'])
            else: wr += d['hits']
            ents |= d['ents']
            for m, h in d['modes'].items(): modes[m.split(':')[0]] += h
            if c == 'S': seen.add((key[0], key[2], key[3]))
            if c == 'dyn': dyn.add('%s %02X:%04X' % (key[0], key[2], key[3]))
        never = sorted(static[n] - seen)
        w.writerow([n, r['addr'], r['size'], r['tag'], rd, wr, bt, len(ents), ' '.join(sorted(modes)), top(vals) if r['size'] == '1' else '',
                    len(static[n]), ' '.join('%s%02X:%04X' % x for x in never), ' '.join(sorted(dyn))])
print('sites', len(S), '->', sites_out, names_out)
