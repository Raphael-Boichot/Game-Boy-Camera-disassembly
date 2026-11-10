#!/usr/bin/env python3
"""The WRAM / HRAM folder of a ported build (HOWTO_NEW_ROM.md section 0.1, rule 5): its summary and its comparison with the Japanese ROM.

  tools/port_wram_index.py --tag us|gold [--check]

From roms/<folder>/wram/wram_access_<tag>.csv (written by tools/port_build.py) it writes
  wram/wram_summary_<tag>.csv  one row per address, the same columns as the Japanese summary (tools/wram_db.py --summary-from)
  wram/INDEX.md                what the folder holds, and how its access sites compare with the Japanese ones: each site of this build is
                               paired through port/code_map_<tag>.csv with a Japanese site (same kind, same address = same use), and the
                               addresses that only one ROM uses are listed; the sites that differ are counted by routine
--check compares both files with a fresh run and exits 1 when one differs (the consistency checker runs it).
"""
import argparse, collections, csv, io, os, subprocess, sys, tempfile
FOLDER = {'us': 'us_eu', 'gold': 'gold'}
TITLE = {'us': 'Game Boy Camera (USA, Europe)', 'gold': 'Game Boy Camera Gold (USA)'}
ap = argparse.ArgumentParser(); ap.add_argument('--tag', required=True, choices=sorted(FOLDER)); ap.add_argument('--check', action='store_true')
a = ap.parse_args(); T = a.tag; D = os.path.join('roms', FOLDER[T]); W = os.path.join(D, 'wram')
ACC = os.path.join(W, 'wram_access_%s.csv' % T)
tmp = tempfile.mkdtemp(prefix='wram_'); sm = os.path.join(tmp, 's.csv')
subprocess.run([sys.executable, os.path.join(os.path.dirname(__file__), 'wram_db.py'), '--summary-from', ACC, sm], check=True, capture_output=True)
out = {os.path.join(W, 'wram_summary_%s.csv' % T): open(sm, encoding='utf-8').read()}
J = list(csv.DictReader(open(os.path.join('roms', 'jp_rev_a', 'wram', 'wram_access_jp.csv'), encoding='utf-8')))
Jsite = {(r['bank'], r['pc']): r for r in J}
U = list(csv.DictReader(open(ACC, encoding='utf-8')))
cm = {(r['bank'].lower(), r['other'].lower()): r['jp'].lower() for r in csv.DictReader(open(os.path.join(D, 'port', 'code_map_%s.csv' % T)))}
sym = {(r['bank'].lower(), r['addr'].lower()): r['name'] for r in csv.DictReader(open(os.path.join(D, 'disasm', 'sym_names_%s.csv' % T), encoding='utf-8'))}
kind = collections.Counter(); byfn = collections.Counter()
for r in U:
    jp = cm.get((r['bank'], r['pc'])); j = Jsite.get((r['bank'], jp)) if jp else None
    k = 'same' if j and j['addr'] == r['addr'] and j['kind'] == r['kind'] else ('other' if j else 'none')
    kind[k] += 1
    if k != 'same':
        fn = r['function']; fn = sym.get(tuple(fn.split(':')), fn) if ':' in fn else fn; byfn[fn] += 1
JA = {r['addr'] for r in J}; UA = {r['addr'] for r in U}
only_here, only_jp = sorted(UA - JA), sorted(JA - UA)
n = len(U); diff = n - kind['same']
md = ['# wram/ - WRAM and HRAM of %s' % TITLE[T], '',
      '| File | Content |', '|---|---|',
      '| `wram_access_%s.csv` | every proven access site to `$C000-$DFFF`, `$FE00-$FF7F`, `$FF80-$FFFE` (%s rows; `tools/port_build.py`: the Japanese rows carried through the code map plus the rows of `tools/wram_db.py` on this build\'s own code) |' % (T, format(n, ',')),
      '| `wram_summary_%s.csv` | one row per address (%s addresses): reads, writes, pointer loads, banks, routines, written constants; the columns of `roms/jp_rev_a/wram/wram_summary_jp.csv` (`tools/port_wram_index.py`) |' % (T, format(len(UA), ',')),
      '', '**The layout is the Japanese one.** The names, sizes and scopes are those of the Japanese map (`roms/jp_rev_a/wram/`, docs §2), carried in `disasm/ram_names_%s.csv`.' % T,
      ('No address is used here that the Japanese code does not use' if not only_here else 'Addresses used only here: %s' % ', '.join('`$%s`' % x.upper() for x in only_here)) +
      ('; %s used only by the Japanese code (`%s`).' % ('one address is' if len(only_jp) == 1 else '%d addresses are' % len(only_jp), '`, `'.join('$' + x.upper() for x in only_jp)) if only_jp else '.'),
      '', 'Access sites: %s of %s (%.1f %%) pair through `port/code_map_%s.csv` with a Japanese site of the same kind at the same address. The %d others are where this build\'s code differs: %d sites have no Japanese pair (new or changed code) and %d use another Japanese address than the Japanese site they pair with. By routine:'
      % (format(kind['same'], ','), format(n, ','), 100 * kind['same'] / n, T, diff, kind['none'], kind['other']), '',
      '| Routine | Sites |', '|---|---|'] + ['| `%s` | %d |' % kv for kv in byfn.most_common()]
out[os.path.join(W, 'INDEX.md')] = '\n'.join(md) + '\n'
bad = 0
for f, t in out.items():
    if a.check:
        if not os.path.exists(f) or open(f, encoding='utf-8').read() != t: print('stale: %s (rerun tools/port_wram_index.py --tag %s)' % (f, T)); bad = 1
    else: open(f, 'w', encoding='utf-8').write(t)
print('wram %s: %d sites, %d paired as in Japan, %d differ (%d new, %d other address), %d addresses only here, %d only in Japan%s'
      % (T, n, kind['same'], diff, kind['none'], kind['other'], len(only_here), len(only_jp), ' (check)' if a.check else ''))
sys.exit(bad)
