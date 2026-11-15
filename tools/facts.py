#!/usr/bin/env python3
"""The current figures of every ROM, computed from the repository's own files and tools (2026-11-14, owner: "enforce consistency").

  tools/facts.py [--rom-jp ROM] [--rom-us ROM] [--rom-gold ROM] [--rom-kitty ROM] [--rom-proto ROM] [--json]
  tools/facts.py --check FILE...     every number tagged <!--f:KEY--> (the tag right before the number) equals the fact KEY

Why: the READMEs and ROADMAP.md quote figures (bytes never run, uncertain bytes, verdict classes ...) that change each time a run,
a name or a verdict lands; a figure typed by hand goes stale. A current figure is written once with its key right before it,
`<!--f:kitty.reach.red-->2,489` (the comment is invisible on GitHub, and the sentences other checks parse keep their words), and tools/check_repo_consistency.py runs this tool on
ROADMAP.md, README.md and roms/*/README.md: a tagged figure that differs from the fact, or an unknown key, fails. A figure
kept for history ("7,607 before ...") is not tagged.

Keys (TAG = jp, us, gold, kitty, proto):
  TAG.layout.KIND        bytes of a layout-map kind (assets/layout_by_bank_TAG.csv: UNC uncertain, NONE not analysed, ...)
  TAG.reach.CLASS        bytes of a reachability-map class (tools/reach_map.py --tag TAG; red, purple, grey-blue, orange, yellow,
                         light blue, blue, padding, fill, green); needs the ROM; not for jp (its map is drawn by rom_reach_map.py)
  TAG.never_run          bytes of trace/red_TAG.csv (red + purple: the code no run executed), kitty and proto; TAG.never_run_pieces
  TAG.redclass.CLASS     bytes per way in of trace/red_TAG.csv (GATE, BEHIND, TABLE, FORCED, HAND, VECTOR)
  TAG.verdict.CLASS      bytes per verdict class of trace/red_verdicts_TAG.csv (kitty, proto); TAG.unverdicted: never-run pieces with no verdict row
  TAG.names, TAG.names.C / I / Q   rows of disasm/sym_names_TAG.csv and per tag (Q = '?'); TAG.leftovers: its Leftover_* names (TAG.leftovers.C / I: per tag);
                                   TAG.settled, TAG.settled.GROUP: rows of disasm/sym_settled_unused_TAG.csv (settled as unused, final) and per group
  TAG.doubts, TAG.doubts.GROUP   rows of disasm/sym_unconclusive_TAG.csv, and per group where the table has one
  kitty.jpx.CATEGORY     bytes per category of trace/jp_crosscheck_kitty.csv (NO_JP, JP_RAN, JP_VERDICT, JP_RED, JP_PART)
  kitty.puzzle.bgb_games / bgb_solved / core_games / core_solved   tools/kitty_puzzle.py (trace/puzzle_{bgb,core}_kitty.csv)
  kitty.code.bytes / executed / never_ran   proven code bytes (trace/trace_kitty.json) and those an organic core run executed (cov_kitty_*.npz)
  kitty.redcls.total / effect / gate / forced-mode / not-run, kitty.gates   trace/red_classes_kitty.csv, trace/gates_kitty.csv
  kitty.types.padding / typed / default, kitty.kinds.given / left   tools/sym_build.py --report and tools/kitty_layout_kinds.py (with --rom-kitty)
  TAG.ram, TAG.ram.C / I     rows of disasm/ram_names_TAG.csv and per tag (every ROM that has the table)
  kitty.ram.hand / jp / auto  its rows by source (tools/kitty_ram_names.py: the hand layer, a paired Japanese site, routine + address)
  TAG.wram.sites / addrs     rows of wram/wram_access_TAG.csv and its distinct addresses; TAG.sram.sites: rows of sram/sram_access_TAG.csv
  TAG.sram.rows              rows of sram/sram_map_TAG.csv; kitty.sram.checks / failed: rows of sram/sram_saves_kitty.csv and those not ok
  TAG.const.mode / state / sound   named modes (const_names_TAG.csv group mode), states (state_names_TAG.csv), sound ids (sound_names_TAG.csv)
"""
import sys, os, csv, re, json, argparse, subprocess, tempfile, collections
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
DIRS = {'jp': 'jp_rev_a', 'us': 'us_eu', 'gold': 'gold', 'kitty': 'hello_kitty', 'proto': 'prototype_debagame'}
ap = argparse.ArgumentParser()
for t in DIRS: ap.add_argument('--rom-' + t)
ap.add_argument('--json', action='store_true'); ap.add_argument('--check', nargs='+')
ap.add_argument('--fix', nargs='+', help='rewrite every tagged figure of these files with the value the files give today (2026-11-15)')
a = ap.parse_args()

def facts():
    F = {}
    for t, d in DIRS.items():
        p = os.path.join(REPO, 'roms', d, 'assets', 'layout_by_bank_%s.csv' % t)
        if os.path.exists(p):
            tot = collections.Counter()
            for r in csv.DictReader(open(p)):
                if not re.match(r'^[0-9A-Fa-f]{2}$', r['bank']): continue          # the per-bank rows only (not the 'total' row)
                for k, v in r.items():
                    if k != 'bank' and v and v.lstrip('-').isdigit(): tot[k] += int(v)
            for k, v in tot.items(): F['%s.layout.%s' % (t, k)] = v
        rom = getattr(a, 'rom_' + t)
        if rom and t != 'jp':
            with tempfile.TemporaryDirectory() as tmp:
                r = subprocess.run([sys.executable, os.path.join(HERE, 'reach_map.py'), '--tag', t, rom, os.path.join(tmp, 'm.png')], capture_output=True, text=True)
            m = re.search(r'_reach: (.*) bytes', r.stdout)
            if m:
                for part in m.group(1).split(', '):
                    k, v = part.rsplit(' ', 1); F['%s.reach.%s' % (t, k)] = int(v)
        red = os.path.join(REPO, 'roms', d, 'trace', 'red_%s.csv' % t); ver = os.path.join(REPO, 'roms', d, 'trace', 'red_verdicts_%s.csv' % t)
        if os.path.exists(red):
            rows = list(csv.DictReader(open(red))); F['%s.never_run' % t] = sum(int(r['bytes']) for r in rows)
            c = collections.Counter()
            for r in rows: c[r['class']] += int(r['bytes'])
            for k, v in c.items(): F['%s.redclass.%s' % (t, k)] = v
            F['%s.never_run_pieces' % t] = len(rows)
            if os.path.exists(ver):
                size = {(r['bank'], r['start']): int(r['bytes']) for r in rows}; c = collections.Counter(); seen = set()
                for v in csv.DictReader(open(ver)): c[v['class']] += size.get((v['bank'], v['start']), 0); seen.add((v['bank'], v['start']))
                F['%s.unverdicted' % t] = len(set(size) - seen)
                for k, v in c.items(): F['%s.verdict.%s' % (t, k)] = v
    for t, d in DIRS.items():                          # the names and their tags (disasm/sym_names_TAG.csv)
        p = os.path.join(REPO, 'roms', d, 'disasm', 'sym_names_%s.csv' % t)
        if os.path.exists(p):
            rows = list(csv.DictReader(open(p, encoding='utf-8'))); F['%s.names' % t] = len(rows)
            F['%s.names.Q' % t] = 0
            for k, v in collections.Counter(r['conf'] for r in rows).items(): F['%s.names.%s' % (t, {'?': 'Q'}.get(k, k))] = v
            F['%s.leftovers' % t] = sum(r['name'].startswith('Leftover_') for r in rows)
            for c_ in 'CI': F['%s.leftovers.%s' % (t, c_)] = sum(r['name'].startswith('Leftover_') and r['conf'] == c_ for r in rows)
        p = os.path.join(REPO, 'roms', d, 'disasm', 'sym_settled_unused_%s.csv' % t)
        if os.path.exists(p):
            rows = list(csv.DictReader(open(p, encoding='utf-8'))); F['%s.settled' % t] = len(rows)
            for k, v in collections.Counter(r['group'] for r in rows).items(): F['%s.settled.%s' % (t, k.replace(' ', '_'))] = v
    for t, d in DIRS.items():                          # the doubts lists (tools/make_doubts.py, kitty_doubts.py, proto_names.py)
        p = os.path.join(REPO, 'roms', d, 'disasm', 'sym_unconclusive_%s.csv' % t)
        if os.path.exists(p):
            rows = list(csv.DictReader(open(p, encoding='utf-8'))); F['%s.doubts' % t] = len(rows)
            if rows and 'group' in rows[0]:
                for k, v in collections.Counter(r['group'] for r in rows).items(): F['%s.doubts.%s' % (t, k.replace(' ', '_'))] = v
    p = os.path.join(REPO, 'roms', 'hello_kitty', 'trace', 'jp_crosscheck_kitty.csv')
    if os.path.exists(p):
        c = collections.Counter()
        for r in csv.DictReader(open(p)): c[r['category']] += int(r['bytes'])
        for k, v in c.items(): F['kitty.jpx.%s' % k] = v
    for t, d in DIRS.items():                                            # L4: RAM names, RAM / SRAM sites, SRAM map, constants
        D = os.path.join(REPO, 'roms', d)
        def rd(*q): return list(csv.DictReader(open(os.path.join(D, *q), encoding='utf-8'))) if os.path.exists(os.path.join(D, *q)) else None
        r = rd('disasm', 'ram_names_%s.csv' % t)
        if r is not None:
            F['%s.ram' % t] = len(r)
            for k, v in collections.Counter(x['tag'] for x in r).items(): F['%s.ram.%s' % (t, k)] = v
        r = rd('wram', 'wram_access_%s.csv' % t)
        if r is not None: F['%s.wram.sites' % t] = len(r); F['%s.wram.addrs' % t] = len({x['addr'] for x in r})
        r = rd('sram', 'sram_access_%s.csv' % t)
        if r is not None: F['%s.sram.sites' % t] = len(r)
        r = rd('sram', 'sram_map_%s.csv' % t)
        if r is not None: F['%s.sram.rows' % t] = len(r)
        r = rd('disasm', 'const_names_%s.csv' % t)
        if r is not None: F['%s.const.mode' % t] = sum(x['group'] == 'mode' for x in r)
        r = rd('disasm', 'state_names_%s.csv' % t)
        if r is not None: F['%s.const.state' % t] = len(r)
        r = rd('disasm', 'sound_names_%s.csv' % t)
        if r is not None: F['%s.const.sound' % t] = len(r)
    p = os.path.join(REPO, 'roms', 'hello_kitty', 'disasm', 'ram_names_kitty.csv')
    if os.path.exists(p):
        HN = {x['name'] for x in csv.DictReader(open(os.path.join(REPO, 'roms', 'hello_kitty', 'disasm', 'layers', 'ram_names_kitty_hand.csv'), encoding='utf-8'))}
        c = collections.Counter('hand' if x['name'] in HN else ('jp' if x['desc'].startswith('the Japanese') else 'auto') for x in csv.DictReader(open(p, encoding='utf-8')))
        for k, v in c.items(): F['kitty.ram.%s' % k] = v
    KD = os.path.join(REPO, 'roms', 'hello_kitty')                  # the counts of the Kitty L1 / L2 bullets (2026-11-15: they had to be retyped)
    p = os.path.join(KD, 'trace', 'trace_kitty.json')
    if os.path.exists(p):
        import json; import numpy as np; from glob import glob as _glob
        tr = json.load(open(p))['code']; ex = np.zeros(0x200000, bool)
        for f in _glob(os.path.join(KD, "trace", "cov_kitty_*.npz")):
            e = np.load(f)['ex']; ex[:len(e)] |= e > 0
        def fl(b, ad): return ad if b == 0 else b * 0x4000 + ad - 0x4000
        F['kitty.code.bytes'] = sum(tr.values()); F['kitty.code.executed'] = sum(n for k, n in tr.items() if ex[fl(int(k[:2], 16), int(k[3:], 16))])
        F['kitty.code.never_ran'] = F['kitty.code.bytes'] - F['kitty.code.executed']
    p = os.path.join(KD, 'trace', 'red_classes_kitty.csv')
    if os.path.exists(p):
        rc = list(csv.DictReader(open(p, encoding='utf-8'))); F['kitty.redcls.total'] = sum(int(r['red_bytes']) for r in rc)
        for c in ('effect', 'gate', 'forced-mode', 'not-run'): F['kitty.redcls.%s' % c] = sum(int(r[c]) for r in rc)
        F['kitty.gates'] = len(list(csv.DictReader(open(os.path.join(KD, 'trace', 'gates_kitty.csv')))))
    if a.rom_kitty:                                                 # the type counts of tools/sym_build.py and the data kinds of tools/kitty_layout_kinds.py
        _sp = __import__("subprocess")
        tk = __import__("tempfile").mkdtemp(prefix="facts_kitty_")
        r3 = _sp.run([sys.executable, os.path.join(REPO, "tools", "sym_build.py"), a.rom_kitty, '--names', os.path.join(KD, 'disasm', 'sym_names_kitty.csv'),
                             '--types', os.path.join(KD, 'disasm', 'sym_types_kitty.csv'), '--trace', os.path.join(KD, 'trace', 'trace_kitty.json'), '--out', os.path.join(tk, 'k.sym'), '--report'],
                            capture_output=True, text=True, cwd=REPO)
        m3 = re.search(r'bytes by type: (\{.*\})', r3.stdout); m4 = re.search(r'still on the default typing \(\.data, 16 per row\): (\d+)', r3.stdout)
        if m3 and m4:
            import ast
            BYK = ast.literal_eval(m3.group(1)); F['kitty.types.padding'] = BYK['padding']; F['kitty.types.default'] = int(m4.group(1)); F['kitty.types.typed'] = BYK['data'] - int(m4.group(1))
        r6 = _sp.run([sys.executable, os.path.join(REPO, "tools", "kitty_layout_kinds.py"), a.rom_kitty, '--out', os.path.join(tk, 'kinds.csv')], capture_output=True, text=True, cwd=REPO)
        m6 = re.search(r'kitty_layout_kinds: \d+ rows, (\d+) bytes of kind-less blocks given a kind .*?; (\d+) bytes of kind-less blocks left', r6.stdout)
        if m6: F['kitty.kinds.given'] = int(m6.group(1)); F['kitty.kinds.left'] = int(m6.group(2))
        __import__("shutil").rmtree(tk, ignore_errors=True)
    p = os.path.join(REPO, 'roms', 'hello_kitty', 'sram', 'sram_saves_kitty.csv')
    if os.path.exists(p):
        r = list(csv.DictReader(open(p, encoding='utf-8'))); F['kitty.sram.checks'] = len(r); F['kitty.sram.failed'] = sum(x['result'] != 'ok' for x in r)
    for w in ('bgb', 'core'):
        p = os.path.join(REPO, 'roms', 'hello_kitty', 'trace', 'puzzle_%s_kitty.csv' % w)
        if os.path.exists(p):
            rows = list(csv.DictReader(open(p))); F['kitty.puzzle.%s_games' % w] = len(rows); F['kitty.puzzle.%s_solved' % w] = sum(r['solved'] == 'yes' for r in rows)
    return F

F = facts()
if a.fix:                                                    # the figures follow the files: no figure has to be retyped by hand
    for f in a.fix:
        p = os.path.join(REPO, f) if not os.path.isabs(f) else f; txt = open(p, encoding='utf-8').read(); ch = []
        def sub(m):
            k = m.group(1)
            if k not in F: return m.group(0)
            new = format(F[k], ',') if (',' in m.group(2) or F[k] >= 10000) else str(F[k])
            if new != m.group(2): ch.append('%s %s -> %s' % (k, m.group(2), new))
            return '<!--f:%s-->%s' % (k, new)
        t2 = re.sub(r'<!--f:([\w.\- ]+?)-->(\d[\d,]*\d|\d)', sub, txt)
        if t2 != txt: open(p, 'w', encoding='utf-8', newline='\n').write(t2)
        print('facts: %s: %d figure(s) rewritten%s' % (f, len(ch), (': ' + '; '.join(ch)) if ch else ''))
    sys.exit(0)
if a.check:
    bad = 0; n = 0
    for f in a.check:
        txt = open(os.path.join(REPO, f) if not os.path.isabs(f) else f, encoding='utf-8').read()
        for m in re.finditer(r'<!--f:([\w.\- ]+?)-->(\d[\d,]*)', txt):
            n += 1; v, k = int(m.group(2).replace(',', '')), m.group(1)
            line = txt.count('\n', 0, m.start()) + 1
            if k not in F: print('facts: %s:%d unknown key %s (or its ROM was not given)' % (f, line, k)); bad += 1
            elif F[k] != v: print('facts: %s:%d says %s for %s, the files give %s' % (f, line, m.group(1), k, format(F[k], ','))); bad += 1
        for m in re.finditer(r'<!--f:[^>]*-->', txt):
            if not re.match(r'\d', txt[m.end():m.end() + 1]): print('facts: %s:%d a tag with no figure right after it' % (f, txt.count('\n', 0, m.start()) + 1)); bad += 1
        if os.path.basename(f) == 'ROADMAP.md':             # the status tables: a current figure of these kinds must carry its tag
            sec = ''
            for line_no, line in enumerate(txt.split('\n'), 1):
                if line.startswith('## '): sec = line
                if not line.startswith('| L') or '(Japan) (Rev A)' in sec: continue     # the Japanese ROM's figures are frozen and checked by docs checks
                for m in re.finditer(r'(?<![\w>,])(\d[\d,]*) (B red|B purple|never-run bytes|bytes of uncertain kind|doubts|bytes stay red|uncertain bytes)', line):
                    pre = line[max(0, m.start() - 60):m.start()]
                    if re.search(r'(before|earlier|on 20\d\d-\d\d-\d\d[^)]*$)', pre[-25:]): continue
                    print('facts: %s:%d the current figure "%s" has no <!--f:KEY--> tag' % (f, line_no, m.group(0))); bad += 1
    print('facts: %d tagged figures checked in %d files, %d wrong' % (n, len(a.check), bad)); sys.exit(1 if bad else 0)
if a.json: print(json.dumps(F, indent=1, sort_keys=True))
else:
    for k in sorted(F): print('%-34s %s' % (k, format(F[k], ',')))
