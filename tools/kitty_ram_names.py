#!/usr/bin/env python3
"""RAM names of the Hello Kitty Pocket Camera, L4 (2026-11-15, roadmap step 11): roms/hello_kitty/disasm/ram_names_kitty.csv.

  tools/kitty_ram_names.py KITTY.gb JP.gb [--check]

The columns of roms/jp_rev_a/disasm/ram_names_jp.csv (addr, size, name, scope, tag, desc), one row per WRAM / HRAM range that a proven
instruction of this ROM reads, writes or loads as a pointer (roms/hello_kitty/wram/wram_access_kitty.csv, tools/wram_db.py). The I/O
registers ($FF00-$FF7F) and $FFFF keep the hardware.inc names. Three sources, the first that names an address wins:

  1. hand, disasm/layers/ram_names_kitty_hand.csv: the variables this ROM's own findings name (the 15 puzzle, the Kitt counter, the
     mode / state bytes, the sound requests ...), each with its evidence; tag as given.
  2. the Japanese names, through the same code. A routine of this ROM that is the Japanese routine with only its operands changed
     (disasm/match_jp_kitty.csv, kinds exact / masked) has its instructions at the same offsets; an edited copy
     (disasm/similar_jp_kitty.csv, ratio >= 0.9) is aligned by difflib on the opcode bytes. Each access site of this ROM is paired with
     the Japanese site at the mapped address when it has the same kind (R / W / P; roms/jp_rev_a/wram/wram_access_jp.csv), and the
     Japanese row that covers the Japanese address there (tools/ram_names.py resolver) gives the name and the offset into it: this
     ROM's row starts that offset before the address and has the Japanese size. Tag C when every paired site of the address agrees and
     at least one comes from a same-code routine, I when the pairings come only from edited copies or when a minority disagrees.
     Two Japanese names for one address of this ROM (an overlay: one byte, several buffers) give one row per name, each scoped to the
     routines of this ROM whose sites gave it.
  3. the rest: `w` / `h` + the routine of this ROM that touches the address most + its address (`wMode0F_State0A_D971`), tag I.

size: the Japanese size for a paired row; for the rest, up to the next named address for an address loaded as a pointer (P: a buffer),
at most 256 bytes; else 1. scope `*` unless an overlay. desc: the evidence (paired sites, or the routines of rule 3).
"""
import argparse, bisect, collections, csv, difflib, io, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); KD = os.path.join(REPO, 'roms', 'hello_kitty')
sys.path.insert(0, HERE)
import ram_names
ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('jp'); ap.add_argument('--check', action='store_true')
ap.add_argument('--out', default=os.path.join(KD, 'disasm', 'ram_names_kitty.csv')); a = ap.parse_args()
K = open(a.rom, 'rb').read(); J = open(a.jp, 'rb').read()
def fl(b, ad): return ad if b == 0 else b * 0x4000 + ad - 0x4000
def ba(o): return (o // 0x4000, o if o < 0x4000 else o % 0x4000 + 0x4000)

# ---- the code map: Kitty file offset -> (Japanese file offset, how)
CM = {}
JLEN = {}
for r in csv.DictReader(open(os.path.join(REPO, 'roms', 'jp_rev_a', 'disasm', 'sym_names_jp.csv'), encoding='utf-8')): pass
for r in csv.DictReader(open(os.path.join(KD, 'disasm', 'match_jp_kitty.csv'))):
    if r['kind'] not in ('exact', 'masked'): continue
    jo = fl(int(r['jp_bank'], 16), int(r['jp_addr'], 16)); n = int(r['bytes'])
    for k in r['kitty'].split():
        kb, ka = k.split(':'); ko = fl(int(kb, 16), int(ka, 16))
        for d in range(n): CM.setdefault(ko + d, (jo + d, 'same'))
for r in csv.DictReader(open(os.path.join(KD, 'disasm', 'similar_jp_kitty.csv'))):
    if not r['kitty'] or float(r['ratio']) < 0.9: continue
    kb, ka = r['kitty'].split()[0].split(':'); ko = fl(int(kb, 16), int(ka, 16)); jo = fl(int(r['jp_bank'], 16), int(r['jp_addr'], 16))
    ks, js = K[ko:ko + int(r['kitty_bytes'])], J[jo:jo + int(r['jp_bytes'])]
    for tag, i1, i2, j1, j2 in difflib.SequenceMatcher(None, js, ks, autojunk=False).get_opcodes():
        if tag == 'equal' or (tag == 'replace' and i2 - i1 == j2 - j1):
            for d in range(j2 - j1): CM.setdefault(ko + j1 + d, (jo + i1 + d, 'edited'))

# ---- the sites; the routine of a site = the last name of disasm/sym_names_kitty.csv at or before it (the access table's own
# function column can hold an mgbdis region marker `.code:NN`)
NM = sorted((fl(int(r['bank'], 16), int(r['addr'], 16)), r['name']) for r in csv.DictReader(open(os.path.join(KD, 'disasm', 'sym_names_kitty.csv'), encoding='utf-8')))
NO = [o for o, _ in NM]
def routine(o):
    i = bisect.bisect_right(NO, o) - 1
    while i >= 0 and NO[i] // 0x4000 != o // 0x4000: i = -1
    return re.sub(r'_Part[0-9A-F]{4}$', '', NM[i][1]) if i >= 0 else '%02X:%04X' % ba(o)
ACC = list(csv.DictReader(open(os.path.join(KD, 'wram', 'wram_access_kitty.csv'))))
for r in ACC: r['function'] = routine(fl(int(r['bank'], 16), int(r['pc'], 16)))
JA = {}
for r in csv.DictReader(open(os.path.join(REPO, 'roms', 'jp_rev_a', 'wram', 'wram_access_jp.csv'))):
    JA.setdefault((fl(int(r['bank'], 16), int(r['pc'], 16)), r['kind']), []).append(r)
RES = ram_names.Resolver(ram_names.load(os.path.join(REPO, 'roms', 'jp_rev_a', 'disasm', 'ram_names_jp.csv')))
def ram(ad): return 0xC000 <= ad < 0xE000 or 0xFF80 <= ad < 0xFFFF
pairs = collections.defaultdict(list)      # kitty address -> [(jp row name, offset, size, how, kitty site, kitty function)]
sites = collections.defaultdict(collections.Counter)
for r in ACC:
    ad = int(r['addr'], 16)
    if not ram(ad): continue
    ko = fl(int(r['bank'], 16), int(r['pc'], 16)); sites[ad][r['function']] += 1
    m = None
    for d in range(0, 3):                   # the access site is the instruction's first byte; the map may start at its operand
        if ko + d in CM: m = (CM[ko + d][0] - d, CM[ko + d][1]); break
    if not m: continue
    for j in JA.get((m[0], r['kind']), []):
        jad = int(j['addr'], 16); jb, jpc = ba(m[0])
        try: hit = RES.resolve(jb, jpc, j['function'], jad)
        except ValueError: hit = None
        if hit: row, off = hit; pairs[ad].append((row.name, ad - (jad - row.addr) if False else off, row.size, m[1], '%s:%s' % (r['bank'], r['pc']), r['function'], row.tag))

# ---- hand rows
HAND = os.path.join(KD, 'disasm', 'layers', 'ram_names_kitty_hand.csv')
hand = list(csv.DictReader(open(HAND, encoding='utf-8'))) if os.path.exists(HAND) else []
taken = set()
for h in hand:
    for x in range(int(h['addr'], 16), int(h['addr'], 16) + int(h['size'])): taken.add(x)
rows = [[h['addr'].lower(), h['size'], h['name'], h['scope'], h['tag'], h['desc']] for h in hand]
used = {h['name'] for h in hand}

# ---- the Japanese names: one row per Japanese name, at the start most of its paired sites give
cand = collections.defaultdict(lambda: {'starts': collections.Counter(), 'sites': collections.defaultdict(list), 'size': 1, 'jtag': set()})
for ad in sorted(pairs):
    for n, off, size, how, s_, f, t in pairs[ad]:
        start = ad - off
        if not (ram(start) and ram(start + size - 1)): continue          # a pairing that would start outside the RAM areas
        c = cand[n]; c['starts'][start] += 1; c['sites'][start].append((ad, how, s_, f)); c['size'] = size; c['jtag'].add(t)
chosen = []
for n, c in cand.items():
    start, k = c['starts'].most_common(1)[0]
    others = sum(c['starts'].values()) - k
    chosen.append({'name': n, 'start': start, 'size': c['size'], 'sites': c['sites'][start], 'others': others, 'jtag': c['jtag']})
chosen.sort(key=lambda r: (r['start'], -len(r['sites'])))
# a hand row wins its bytes; two Japanese rows over one byte: an overlay (both kept, scoped to their routines) when each has sites there
for rec in chosen:
    rng = set(range(rec['start'], rec['start'] + rec['size']))
    if rng & taken and rec['size'] <= 16: continue
    over = [o for o in chosen if o is not rec and o['start'] < rec['start'] + rec['size'] and rec['start'] < o['start'] + o['size'] and o['sites']]
    hows = {h for _, h, _, _ in rec['sites']}; fns = sorted({f for _, _, _, f in rec['sites']})
    n = rec['name'] if rec['name'] not in used else '%s_%04X' % (rec['name'], rec['start'])
    if n in used: continue
    used.add(n)
    tag = 'C' if 'same' in hows and not over and rec['jtag'] <= {'C'} and not rec['others'] else 'I'
    scope = ';'.join(fns) if over else '*'
    ss = sorted({s_ for _, _, s_, _ in rec['sites']})
    desc = 'the Japanese %s, through %d paired access site%s (%s%s)%s' % (rec['name'], len(ss), '' if len(ss) == 1 else 's', ', '.join(ss[:4]), ', ...' if len(ss) > 4 else '',
           '; same code' if 'same' in hows else '; edited copies only')
    if rec['others']: desc += '; %d other paired site%s point elsewhere' % (rec['others'], '' if rec['others'] == 1 else 's')
    if over: desc += '; shares bytes with %s (an overlay: scoped to its routines)' % ', '.join(sorted({o['name'] for o in over})[:3])
    rows.append(['%04x' % rec['start'], str(rec['size']), n, scope, tag, desc])
    taken.update(x for x in rng if x in sites or rec['size'] <= 16)

# ---- the rest: routine + address
kinds = collections.defaultdict(set)
for r in ACC: kinds[int(r['addr'], 16)].add(r['kind'])
rest = sorted(ad for ad in sites if ad not in taken)
allstarts = sorted({int(r[0], 16) for r in rows} | set(rest))
for ad in rest:
    fn = sites[ad].most_common(1)[0][0]
    fn = re.sub(r'_Part[0-9A-F]{4}$', '', fn)
    if re.fullmatch(r'[0-9A-Fa-f]{2}:[0-9A-Fa-f]{4}', fn): fn = 'Code' + fn.replace(':', '_')
    n = '%s%s_%04X' % ('h' if ad >= 0xFF80 else 'w', fn, ad)
    if fn.upper().endswith('%04X' % ad): n = '%s%s' % ('h' if ad >= 0xFF80 else 'w', fn)      # the routine already names the address (Puzzle15_ObjSetCC_D977)
    i = bisect.bisect_right(allstarts, ad); nxt = allstarts[i] if i < len(allstarts) else ad + 1
    size = min(256, nxt - ad) if 'P' in kinds[ad] and nxt > ad else 1
    if n in used: n += '_'
    used.add(n)
    rows.append(['%04x' % ad, str(size), n, '*', 'I', 'touched by %s' % ', '.join('%s (%d)' % kv for kv in sites[ad].most_common(3))])

rows.sort(key=lambda r: (int(r[0], 16), r[2]))
f = io.StringIO(); w = csv.writer(f, lineterminator='\n'); w.writerow(['addr', 'size', 'name', 'scope', 'tag', 'desc']); w.writerows(rows)
if a.check:
    if open(a.out, encoding='utf-8').read() != f.getvalue(): sys.exit('kitty_ram_names: %s is not what this tool writes today' % os.path.relpath(a.out, REPO))
    print('kitty_ram_names: fresh'); sys.exit(0)
open(a.out, 'w', encoding='utf-8').write(f.getvalue())
src = collections.Counter('hand' if r[2] in {h['name'] for h in hand} else ('jp' if r[5].startswith('the Japanese') else 'auto') for r in rows)
tags = collections.Counter(r[4] for r in rows)
npair = sum(1 for ad in sites if ad in pairs)
print('kitty_ram_names: %d rows (%s), tags %s; %d of %d addresses have a paired Japanese site' % (len(rows), dict(src), dict(tags), npair, len(sites)))
