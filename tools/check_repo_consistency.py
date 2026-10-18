#!/usr/bin/env python3
"""Repository consistency check: the numbers and names that several files repeat must agree, and the generated files must be fresh.

usage: tools/check_repo_consistency.py [--rom pocketcamera_jp.gb] [--roundtrip] [--mgbdis /path/to/mgbdis.py] [--rgbds /path/to/rgbds] [-q]
  run it from anywhere; it works on the repository that holds it.  Exit status 1 when a check fails (warnings do not fail).
  Without --rom the checks that need the ROM (sym freshness, byte types, yellow bytes, md5 round trip) are skipped and said so.

What it checks (each line of the report is one check)
  names      sym_names_jp.csv: tags C / I / ?, duplicate names, a name that carries another address than its own (only `_Part<addr>` / `_Cont` may),
             a `Map_*` label on a `Gfx` type row (and `Gfx_*` on a `Map` row; the type rows are applied in order, the last row wins, as in sym_build.py)
  sym        pocketcamera_jp.sym equals a fresh sym_build.py run (needs the ROM); block / label / line counts
  doubts     disasm/sym_unconclusive_jp.{md,csv} equal a fresh make_doubts.py run; rows and distinct bytes
  renamed    disasm/renamed_jp.csv rows against the counts the README quotes
  quoted     every count that README.md, CLAUDE.md, skills/gb-rom-disassembly/SKILL.md and HOWTO_NEW_ROM.md quote (labels per tag, doubtful rows, distinct bytes,
             blocks, bytes per type, sym lines, really-unused totals, tier table, per-bank layout table, TCRF label count) against the files they come from
  layout     (needs --rom) jp_rom_layout_map.png and assets/layout_by_bank_jp.csv equal a fresh rom_layout_map.py run; the legend sentences of the README (bytes per kind, padding
             tiles, never-run marks, the Src_* / Data_* evidence rows, the graphic spans tagged `?`) equal what the run prints
  sheet      the really_unused.md table rows are copied verbatim into the README; the README says the same total as the md; the hand-kept tail of the md is still there
  files      files that README.md links or shows (images, markdown links) exist; `§N.M` references point to a heading that exists (datasheet sections are listed in EXTERNAL_REFS)
  csvrows    "`file.csv` (N rows)" claims in the README
  docnames   every `Gfx_BB_AAAA_...` / `Map_` / `Src_` / `Data_` / `Sheet_` label quoted in README, CLAUDE.md, the skill and the HOWTO is a label of sym_names_jp.csv (or the start of one)
  bankpics   (needs --rom) disasm/sym_unconclusive_banks/*.png equal a fresh tools/bank_pics.py run
  tcrf       tcrf_check/TCRF_CHECKLIST.md and .csv list the same ids
  effects    tcrf_check/assets/effect_slots/effect_slots_bgb.csv has the 96 slots of the jump table 0A:541A in order, each row's entry address (needs --rom) and label equal the ROM and sym_names_jp.csv;
             the counts quoted in README 16.28 (slots that write, lone rets, routines, slots the game selects, flip relations, grey-level checks) equal the csv; every tcrf_check/ file a label note cites exists
  ram        disasm/ram_names_jp.csv (the RAM names, README 2.13): identifiers and prefixes, no clash with a ROM label, disasm/ram_jp.inc and pocketcamera_jp_ram.sym equal a fresh tools/ram_names.py run, every access of
             wram/wram_access.csv inside $C000-$DFFF / $FF80-$FFFE resolves to exactly one name for its bank, routine and instruction (the pointer loads of ram_exclude_jp.csv are numbers); the counts the README quotes
  roundtrip  (--roundtrip) mgbdis + rgbasm rebuild the ROM from the sym byte-exact, plain, after sym_fix.py --tables, and after sym_fix.py --tables --ram (RAM names; the listing keeps only the excluded numbers)

Frozen inputs that are NOT regenerated: tcrf_check/assets/unidentified/open_assets.csv (the candidate list that display_report.py reads; the checker only compares the README's sentences with it).
Real exceptions (a Map type row that is not a multiple of 32 bytes, a Gfx label on a Map row, datasheet section numbers) are listed in ODD_MAP_ROWS, GFX_ON_MAP and EXTERNAL_REFS with the reason.

Add a quoted number here when the README starts quoting a new one: the point of this file is that a change of a label, a type row or a span
shows up as a failed line instead of as a stale sentence three weeks later.  Update the README / CLAUDE.md / SKILL.md first, then run this again."""
import sys, os, re, csv, io, json, subprocess, tempfile, shutil, argparse, collections

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
ap = argparse.ArgumentParser()
ap.add_argument('--rom'); ap.add_argument('--roundtrip', action='store_true'); ap.add_argument('--mgbdis', default='/home/claude/tc/mgbdis/mgbdis.py')
ap.add_argument('--rgbds', default='/home/claude/tc/rgbds'); ap.add_argument('-q', action='store_true')
A = ap.parse_args()
os.chdir(ROOT)
FAIL = []; WARN = []; SKIP = []
def P(p): return os.path.join(ROOT, p)
def rd(p): return open(P(p), encoding='utf-8').read()
def num(s): return int(s.replace(',', ''))
def fmt(n): return '{:,}'.format(n)
def ok(name, msg=''):
    if not A.q: print('ok    %-10s %s' % (name, msg))
def bad(name, msg): FAIL.append('%s: %s' % (name, msg)); print('FAIL  %-10s %s' % (name, msg))
def warn(name, msg): WARN.append('%s: %s' % (name, msg)); print('warn  %-10s %s' % (name, msg))
def skip(name, why): SKIP.append(name); print('skip  %-10s %s' % (name, why))

README = rd('README.md'); CLAUDE = rd('CLAUDE.md'); SKILL = rd('skills/gb-rom-disassembly/SKILL.md'); HOWTO = rd('HOWTO_NEW_ROM.md')
DOCS = {'README.md': README, 'CLAUDE.md': CLAUDE, 'SKILL.md': SKILL, 'HOWTO_NEW_ROM.md': HOWTO}
def quoted(name, pattern, getter, docs=('README.md', 'CLAUDE.md', 'SKILL.md', 'HOWTO_NEW_ROM.md'), need=None):
    """every match of `pattern` in `docs` must give the numbers that getter(match) returns as (expected tuple, found tuple); `need` = docs that must match at least once"""
    n = 0
    for d in docs:
        hits = list(re.finditer(pattern, DOCS[d]))
        if need and d in need and not hits: bad('quoted', '%s: no sentence matches %r (reword it or fix the checker)' % (d, pattern[:60]))
        for m in hits:
            n += 1
            exp, got = getter(m)
            if tuple(exp) != tuple(got):
                line = DOCS[d].count('\n', 0, m.start()) + 1
                bad('quoted', '%s:%d %s says %s, the files say %s' % (d, line, name, got, exp))
    return n

# ------------------------------------------------------------------ names
NAMES = list(csv.DictReader(io.StringIO(rd('disasm/sym_names_jp.csv'))))
tags = collections.Counter(r['conf'] for r in NAMES); NL = len(NAMES)
C, I, Q = tags['C'], tags['I'], tags['?']
if set(tags) - {'C', 'I', '?'}: bad('names', 'unknown tags %s' % (set(tags) - {'C', 'I', '?'}))
seen = collections.Counter(r['name'] for r in NAMES)
for k, v in seen.items():
    if v > 1: bad('names', 'duplicate name %s' % k)
keys = collections.Counter((r['bank'].upper(), r['addr'].upper()) for r in NAMES)
for k, v in keys.items():
    if v > 1: bad('names', 'two rows for %s:%s' % k)
mism = []
for r in NAMES:
    m = re.search(r'_([0-9A-F]{2})_([0-9A-F]{4})(?:_|$)', r['name'])
    if m and (m.group(1) != r['bank'].upper() or m.group(2) != r['addr'].upper()):
        if re.search(r'_Part%s$|_Part%s_' % (r['addr'].upper(), r['addr'].upper()), r['name']) or r['name'].endswith('_Cont'): continue
        mism.append('%s:%s %s' % (r['bank'], r['addr'], r['name']))
for x in mism: bad('names', 'the name carries another address than the label (add `_Part<addr>` or use the own address): %s' % x)
# Real exceptions, each with its reason; add a row here only after reading the code, never to silence the checker.
ODD_MAP_ROWS = {  # Map type rows that are not a multiple of 32 bytes
    (0x27, 0x4470, 0x4472): 'bank-27 album maps are 22-row (0x2C0) maps copied from 4470, 4472 and 44B2, overlapping on purpose with 2-byte shifts',
    (0x27, 0x44B2, 0x4730): 'same family: the third copy source and the rest of its rows',
    (0x27, 0x4730, 0x4772): 'same family: tail rows between the album maps and the blank rows at 4772',
    (0x27, 0x4772, 0x4870): 'same family: Map_27_4772_BlankRows',
}
GFX_ON_MAP = {  # Gfx labels that lie inside a Map type row
    (0x24, 0x6598): 'Mode17_State00_Init copies 8 bytes from the hidden columns 24-31 of the last row of the option-page map 24:63A0-65A0',
}
TYPES = []
for l in rd('disasm/sym_types_jp.csv').split('\n'):
    if not l or l.startswith('bank'): continue
    p = l.split(','); TYPES.append((int(p[0], 16), int(p[1], 16), int(p[2], 16), p[3], p[4], p[5] if len(p) > 5 else ''))
WIN = {}
for t in TYPES:
    for a in range(t[1], t[2]): WIN[(t[0], a)] = t
for r in NAMES:
    t = WIN.get((int(r['bank'], 16), int(r['addr'], 16)))
    if not t: continue
    if r['name'].startswith('Map_') and t[5] == 'Gfx': bad('names', '%s:%s %s is typed as Gfx (type row %02X:%04X-%04X): a map is typed `data,32,Map`' % (r['bank'], r['addr'], r['name'], t[0], t[1], t[2]))
    if r['name'].startswith('Gfx_') and t[5] == 'Map' and (int(r['bank'], 16), int(r['addr'], 16)) not in GFX_ON_MAP: bad('names', '%s:%s %s lies on a Map type row (%02X:%04X-%04X)' % (r['bank'], r['addr'], r['name'], t[0], t[1], t[2]))
for t in TYPES:
    if t[5] == 'Map' and t[4] == '32' and (t[2] - t[1]) % 32 and (t[0], t[1], t[2]) not in ODD_MAP_ROWS:
        warn('names', 'Map type row %02X:%04X-%04X is %d bytes, not a multiple of 32: check where the map really starts (the neighbour chain of 0x240-byte maps)' % (t[0], t[1], t[2], t[2] - t[1]))
if not any('names' in f for f in FAIL): ok('names', '%s labels: C %s / I %s / ? %s' % (fmt(NL), fmt(C), fmt(I), fmt(Q)))
TCRF_LABELS = sum(1 for r in NAMES if r['name'].startswith('Unused_TCRF_'))

# ------------------------------------------------------------------ sym + types (needs the ROM)
LINES = BLOCKS = None; BYTES = {}
if A.rom:
    tmp = tempfile.mkdtemp(prefix='cons_')
    out = os.path.join(tmp, 'x.sym')
    r = subprocess.run([sys.executable, 'tools/sym_build.py', A.rom, '--out', out, '--report'], capture_output=True, text=True)
    if r.returncode: bad('sym', 'sym_build.py failed: %s' % (r.stderr or r.stdout).strip()[-300:])
    else:
        fresh = open(out).read(); cur = rd('pocketcamera_jp.sym')
        if fresh != cur: bad('sym', 'pocketcamera_jp.sym is not what sym_build.py makes from the csv files: rebuild it')
        m = re.search(r'(\d+) labels \(\d+ from the legacy file\), (\d+) type rows, (\d+) lines', r.stdout); LINES = int(m.group(3)); BLOCKS = LINES - int(m.group(1))
        m = re.search(r'bytes by type: (\{.*\})', r.stdout); BYTES = eval(m.group(1))
        if int(re.search(r'(\d+) labels', r.stdout).group(1)) != NL: bad('sym', 'label count differs from the names csv')
        if not any(f.startswith('sym') for f in FAIL): ok('sym', '%s lines, %s blocks, bytes %s' % (fmt(LINES), fmt(BLOCKS), {k: fmt(v) for k, v in BYTES.items()}))
    shutil.rmtree(tmp, ignore_errors=True)
else:
    skip('sym', 'no --rom: sym freshness and byte types not checked')

# ------------------------------------------------------------------ doubts
DR = list(csv.DictReader(io.StringIO(rd('disasm/sym_unconclusive_jp.csv'))))
def union(rows):
    iv = collections.defaultdict(list)
    for r in rows:
        a = int(r['addr'], 16); s = int(r['size'] or 0); iv[r['bank']].append((a, a + s))
    tot = 0
    for b, l in iv.items():
        l.sort(); cur = None
        for x, y in l:
            if cur and x <= cur[1]: cur[1] = max(cur[1], y)
            else:
                if cur: tot += cur[1] - cur[0]
                cur = [x, y]
        tot += cur[1] - cur[0]
    return tot
DROWS = len(DR); DBYTES = union(DR)
tmpd = tempfile.mkdtemp(prefix='cons_d_')
r = subprocess.run([sys.executable, 'tools/make_doubts.py', 'disasm/sym_names_jp.csv', tmpd, 'pocketcamera_jp.sym'], capture_output=True, text=True)
if r.returncode: bad('doubts', 'make_doubts.py failed: %s' % (r.stderr or r.stdout).strip()[-300:])
else:
    for f in ('sym_unconclusive_jp.csv', 'sym_unconclusive_jp.md'):
        if open(os.path.join(tmpd, f), encoding='utf-8').read() != rd('disasm/' + f): bad('doubts', 'disasm/%s is stale: run tools/make_doubts.py' % f)
    if not any(f.startswith('doubts') for f in FAIL): ok('doubts', '%d rows on %s distinct bytes' % (DROWS, fmt(DBYTES)))
shutil.rmtree(tmpd, ignore_errors=True)
if sum(1 for r in DR if r['conf'] == '?') != Q: bad('doubts', 'the doubts csv holds %d `?` rows, the names csv %d' % (sum(1 for r in DR if r['conf'] == '?'), Q))

# ------------------------------------------------------------------ renamed
RN = list(csv.DictReader(io.StringIO(rd('disasm/renamed_jp.csv'))))
def rn_kind(r):
    if not r['old_name']: return 'new'
    if not r['new_name']: return 'removed'
    if r['old_name'] == r['new_name']: return 'kept'
    return 'renamed'
RK = collections.Counter(rn_kind(r) for r in RN)
ok('renamed', '%d rows: %s' % (len(RN), dict(RK)))

# ------------------------------------------------------------------ quoted counts
tn = lambda s: s.replace('`', '')
n = 0
# labels per tag
n += quoted('labels per tag', r'carries ([\d,]+) names tagged C / I / \? \(([\d,]+) / ([\d,]+) / (\d+)\)',
            lambda m: ((NL, C, I, Q), tuple(num(m.group(i)) for i in (1, 2, 3, 4))), need=('CLAUDE.md',))
n += quoted('labels per tag', r'\(([\d,]+) names: C ([\d,]+) / I ([\d,]+) / \? (\d+),',
            lambda m: ((NL, C, I, Q), tuple(num(m.group(i)) for i in (1, 2, 3, 4))), need=('SKILL.md',))
n += quoted('labels per tag', r'\*\*\?\*\* doubtful: ([\d,]+) / ([\d,]+) / (\d+)', lambda m: ((C, I, Q), tuple(num(m.group(i)) for i in (1, 2, 3))), need=('README.md',))
n += quoted('labels per tag', r'names C / I / \? [\d,]+ / [\d,]+ / \d+ -> ([\d,]+) / ([\d,]+) / (\d+)', lambda m: ((C, I, Q), tuple(num(m.group(i)) for i in (1, 2, 3))), need=('README.md',))
n += quoted('labels per tag', r'(\d+) `\?` names \(none of them the placeholder `Data_BB_AAAA` any more\) and ([\d,]+) `I` names \| ([\d,]+) names: C ([\d,]+), I ([\d,]+), \? (\d+)',
            lambda m: ((Q, I, NL, C, I, Q), tuple(num(m.group(i)) for i in range(1, 7))), need=('README.md',))
n += quoted('left `?`', r'What is left of the (\d+) `\?`', lambda m: ((Q,), (int(m.group(1)),)), need=('README.md',))
# doubts
n += quoted('doubtful rows', r'\((\d+) rows: every `\?` name', lambda m: ((DROWS,), (int(m.group(1)),)), need=('README.md',))
n += quoted('doubtful rows', r'doubtful rows \d+ -> (\d+)', lambda m: ((DROWS,), (int(m.group(1)),)), need=('README.md',))
n += quoted('doubtful rows', r'; (\d+) doubtful rows are listed', lambda m: ((DROWS,), (int(m.group(1)),)), need=('CLAUDE.md',))
n += quoted('doubtful rows', r'(\d+) doubtful rows on ([\d,]+) distinct bytes', lambda m: ((DROWS, DBYTES), (int(m.group(1)), num(m.group(2)))), need=('SKILL.md',))
n += quoted('doubtful bytes', r'distinct doubtful bytes [\d,]+ -> ([\d,]+)', lambda m: ((DBYTES,), (num(m.group(1)),)), need=('README.md',))
n += quoted('doubtful bytes', r'sit on ([\d,]+) distinct ROM bytes', lambda m: ((DBYTES,), (num(m.group(1)),)), need=('README.md',))
n += quoted('doubtful rows', r'the (\d+) rows of `disasm/sym_unconclusive_jp.csv`', lambda m: ((DROWS,), (int(m.group(1)),)), need=('README.md',))
# renamed
n += quoted('renamed rows', r'\((\d+) rows against the start of the pass: (\d+) renames with old / new tag and the reason, (\d+) names kept with a better evidence tag, (\d+) labels removed, (\d+) new\)',
            lambda m: ((len(RN), RK['renamed'], RK['kept'], RK['removed'], RK['new']), tuple(int(m.group(i)) for i in range(1, 6))), need=('README.md',))
# sym size
if LINES:
    n += quoted('sym lines', r'([\d,]+) labels and ([\d,]+) lines in mgbdis', lambda m: ((NL, LINES), (num(m.group(1)), num(m.group(2)))), need=('README.md',))
    n += quoted('blocks', r'([\d,]+) blocks cover the 1 MiB: code ([\d,]+) B, data ([\d,]+) B, padding ([\d,]+) B, text ([\d,]+) B',
                lambda m: ((BLOCKS, BYTES['code'], BYTES['data'], BYTES['padding'], BYTES['text']), tuple(num(m.group(i)) for i in range(1, 6))), need=('README.md',))
# TCRF labels
n += quoted('TCRF labels', r'carries (\d+) `Unused_TCRF_\*` labels', lambda m: ((TCRF_LABELS,), (int(m.group(1)),)), need=('README.md',))
n += quoted('left `?`', r'then the (\d+) `\?` and the (\d+) doubtful rows', lambda m: ((Q, DROWS), (int(m.group(1)), int(m.group(2)))), need=('README.md',))
n += quoted('L3 lessons', r'L3 pass of 2026-10-14: 169 `\?` -> (\d+), 610 doubtful rows -> (\d+),', lambda m: ((Q, DROWS), (int(m.group(1)), int(m.group(2)))), docs=('HOWTO_NEW_ROM.md',), need=('HOWTO_NEW_ROM.md',))
if BYTES:
    PAD_BEFORE_L3 = 71681        # padding bytes before the L3 pass of 2026-10-14 (README history, commit a7d7e56)
    n += quoted('padding', r'padding ([\d,]+) \(([\d,]+) B less than before the L3 pass', lambda m: ((BYTES['padding'], PAD_BEFORE_L3 - BYTES['padding']), (num(m.group(1)), num(m.group(2)))), docs=('README.md',), need=('README.md',))
    n += quoted('data bytes', r', data ([\d,]+) \(with a row width', lambda m: ((BYTES['data'],), (num(m.group(1)),)), docs=('README.md',), need=('README.md',))
# the open-assets sheet (a frozen candidate list read by display_report.py): its csv and the sentences about it
OA = list(csv.DictReader(open(P('tcrf_check/assets/unidentified/open_assets.csv'), encoding='utf-8')))
OA_ROWS = len(OA); OA_BYTES = sum(int(r['bytes']) for r in OA); OA_K = collections.Counter(r['name'].split('_')[0] for r in OA)
OA_UNREF = sum(1 for r in OA if r['name'].endswith('_Unref') and r['name'].split('_')[0] in ('Gfx', 'Sheet', 'Map'))
OA_GR = OA_K['Gfx'] + OA_K['Sheet'] + OA_K['Map']
n += quoted('open assets', r'(\d+) rows, ([\d,]+) B = (\d+) graphic spans and tile maps \((\d+) `Gfx`, (\d+) `Sheet`, (\d+) `Map`; (\d+) are `_Unref`, no consumer\) and (\d+) small unread data blocks',
            lambda m: ((OA_ROWS, OA_BYTES, OA_GR, OA_K['Gfx'], OA_K['Sheet'], OA_K['Map'], OA_UNREF, OA_K['Data']), tuple(num(m.group(i)) for i in range(1, 9))), docs=('README.md',), need=('README.md',))
n += quoted('open assets', r'`open_assets\.csv` \(all (\d+) rows', lambda m: ((OA_ROWS,), (int(m.group(1)),)), docs=('README.md',), need=('README.md',))
n += quoted('open assets', r'`open_assets\.csv` has (\d+) rows', lambda m: ((OA_ROWS,), (int(m.group(1)),)), docs=('README.md',), need=('README.md',))
n += quoted('open assets', r'snapshot, (\d+) rows in the csv', lambda m: ((OA_ROWS,), (int(m.group(1)),)), docs=('README.md',), need=('README.md',))
n += quoted('open assets', r'\((\d+) rows, ([\d,]+) B after §16\.25', lambda m: ((OA_ROWS, OA_BYTES), (int(m.group(1)), num(m.group(2)))), docs=('README.md',), need=('README.md',))
# the owner page asks about the pictures that are still doubtful: its count is quoted in the README
OP = rd('tcrf_check/tools/owner_page.py'); OP_PICS = len(re.findall(r"^ dict\(key='(?:gfx|tcrf)_", OP, re.M))
NUMW = {'five': 5, 'six': 6, 'four': 4, 'seven': 7}
n += quoted('owner pictures', r'and (\w+) pictures \(`0D:7000`', lambda m: ((OP_PICS,), (NUMW.get(m.group(1), -1),)), docs=('README.md',), need=('README.md',))

# ------------------------------------------------------------------ really-unused totals, tiers, per-bank table
RU = list(csv.DictReader(io.StringIO(rd('tcrf_check/assets/unidentified/really_unused.csv'))))
tier_n = collections.Counter(); tier_b = collections.Counter()
for r in RU: tier_n[r['tier']] += 1; tier_b[r['tier']] += int(r['bytes'])
md = rd('tcrf_check/assets/unidentified/really_unused.md').split('\n')
mdtot = [l for l in md if l.startswith('| | **')]
if len(mdtot) != 1: bad('sheet', 'really_unused.md has no single total row')
else:
    m = re.match(r'\| \| \*\*([\d,]+)\*\* \| \*\*(\d+) spans\*\*', mdtot[0]); UB, US = num(m.group(1)), int(m.group(2))
    n += quoted('really-unused total', r"Today's count: (\d+) spans, ([\d,]+) B", lambda m: ((US, UB), (int(m.group(1)), num(m.group(2)))), need=('README.md',))
    n += quoted('really-unused total', r'\| on screen only in forced runs[^\n]*\n\| \*\*total\*\* \| \*\*(\d+)\*\* \| \*\*([\d,]+)\*\* \|', lambda m: ((US, UB), (int(m.group(1)), num(m.group(2)))), need=('README.md',))
    n += quoted('really-unused total', r'\| \| \*\*([\d,]+)\*\* \| \*\*(\d+) spans\*\* \|', lambda m: ((UB, US), (num(m.group(1)), int(m.group(2)))), need=('README.md',))
    n += quoted('really-unused total', r'(\d+) / ([\d,]+) B now\.', lambda m: ((US, UB), (int(m.group(1)), num(m.group(2)))), docs=('README.md',))
    n += quoted('really-unused total', r'23,\d\d\d B here', lambda m: ((UB,), (num(m.group(0).split()[0]),)), docs=('README.md',))
# tier table rows (the README's own wording of each tier -> the csv tier)
TIERS = [('no loader in either ROM', ['no loader']), ('never on screen, never read organically', ['never shown']), ('on screen only when state is forced', ['forced only']),
         ('leftovers', ['scrap']), ('head rows of used maps', ['head rows']), ('withdrawn, used', ['used (withdrawn)']), ('on screen in normal play', ['shown']), ('TCRF label', ['TCRF']),
         ('read in play, never shown', ['other', 'read organically, never shown'])]
for label, ts in TIERS:
    cnt = sum(tier_n[t] for t in ts); byt = sum(tier_b[t] for t in ts)
    pat = r'^\| (?:\*\*)?%s[^|]*\| (\d+)[^|]*\| ([\d,]+) \|' % re.escape(label)
    m = [x for x in re.finditer(pat, README, re.M)]
    if not m: bad('tiers', 'no README tier row starts with %r' % label); continue
    for x in m:
        if (int(x.group(1)), num(x.group(2))) != (cnt, byt): bad('tiers', 'tier %r: README says %s spans, %s B; really_unused.csv has %d, %s' % (label, x.group(1), x.group(2), cnt, fmt(byt)))
# per-bank layout table
LB = list(csv.DictReader(io.StringIO(rd('assets/layout_by_bank_jp.csv'))))
for r in LB:
    if r['bank'] == 'total':
        TOT_UNUSED = int(r['unused_data']); TOT_CODE = int(r['never_run_code']); TOT_IDENT = int(r['unread_identified_data'])
        n += quoted('layout totals', r'\| \*\*all\*\* \| \*\*([\d,]+)\*\* \| \*\*([\d,]+)\*\* \| \*\*([\d,]+)\*\* \|', lambda m: ((TOT_CODE, TOT_UNUSED, TOT_IDENT), tuple(num(m.group(i)) for i in (1, 2, 3))), docs=('README.md',), need=('README.md',))
        n += quoted('layout totals', r'red = unused data \(([\d,]+) B', lambda m: ((TOT_UNUSED,), (num(m.group(1)),)), docs=('README.md',), need=('README.md',))
        continue
    mm = re.search(r'^\| `\$%s` \|[^|]*\| ([\d,]*) \| ([\d,]*) \|' % r['bank'].upper(), README, re.M)
    if mm and (num(mm.group(1) or '0'), num(mm.group(2) or '0')) != (int(r['unused_data']), int(r['unread_identified_data'])):
        bad('layout', 'README per-bank row $%s says unused %s / identified %s, assets/layout_by_bank_jp.csv has %s / %s' % (r['bank'], mm.group(1), mm.group(2), r['unused_data'], r['unread_identified_data']))
# yellow bytes need the ROM (rom_reach_map.py)
if A.rom:
    tmp = tempfile.mkdtemp(prefix='cons_y_')
    r = subprocess.run([sys.executable, 'tcrf_check/tools/rom_reach_map.py', '--rom', A.rom, os.path.join(tmp, 'x.png')], capture_output=True, text=True)
    if r.returncode: bad('yellow', 'rom_reach_map.py failed: %s' % (r.stderr or r.stdout).strip()[-200:])
    else:
        m = re.search(r'unused (\d+) (\d+) ', r.stdout); YB, YS = int(m.group(1)), int(m.group(2))
        m2 = re.search(r'yellow takes from: orange (\d+) blue (\d+) light blue (\d+)', r.stdout)
        n += quoted('yellow', r'really unused assets\*\* \(([\d,]+) B, [\d.]+ %, (\d+) spans', lambda m: ((YB, YS), (num(m.group(1)), int(m.group(2)))), docs=('README.md',), need=('README.md',))
        n += quoted('yellow', r'(?:The yellow layer is|\d,\d{3} B of them are yellow|yellow bytes of the map at the top of this README:) ?([\d,]+) B', lambda m: ((YB,), (num(m.group(1)),)), docs=('README.md',))
        n += quoted('yellow', r'yellow takes ([\d,]+) B from orange, ([\d,]+) B from blue and ([\d,]+) B from light blue', lambda m: (tuple(int(m2.group(i)) for i in (1, 2, 3)), tuple(num(m.group(i)) for i in (1, 2, 3))), docs=('README.md',), need=('README.md',))
        if cmp_png := os.path.join(ROOT, 'jp_rom_reachability_map.png'):
            if open(cmp_png, 'rb').read() != open(os.path.join(tmp, 'x.png'), 'rb').read(): bad('yellow', 'jp_rom_reachability_map.png is stale: run tcrf_check/tools/rom_reach_map.py (and rom_layout_map.py)')
    shutil.rmtree(tmp, ignore_errors=True)
else:
    skip('yellow', 'no --rom: yellow bytes and the reachability picture not checked')
# layout map: the picture, the per-bank csv and the sentences of the README that quote its legend (needs the ROM)
if A.rom:
    tmp = tempfile.mkdtemp(prefix='cons_l_')
    r = subprocess.run([sys.executable, 'tcrf_check/tools/rom_layout_map.py', os.path.join(tmp, 'l.png'), '--rom', A.rom, '--csv', os.path.join(tmp, 'l.csv')], capture_output=True, text=True)
    if r.returncode: bad('layout', 'rom_layout_map.py failed: %s' % (r.stderr or r.stdout).strip()[-200:])
    else:
        if open(os.path.join(tmp, 'l.png'), 'rb').read() != open(P('jp_rom_layout_map.png'), 'rb').read(): bad('layout', 'jp_rom_layout_map.png is stale: run tcrf_check/tools/rom_layout_map.py OUT.png --rom ROM')
        if open(os.path.join(tmp, 'l.csv'), 'rb').read() != open(P('assets/layout_by_bank_jp.csv'), 'rb').read(): bad('layout', 'assets/layout_by_bank_jp.csv is stale: run rom_layout_map.py --csv assets/layout_by_bank_jp.csv')
        K = {m.group(1): num(m.group(2)) for m in re.finditer(r'^([A-Z_]+)\s+([\d,]+)\s+[\d.]+ %', r.stdout, re.M)}
        tiles = K['T_UI'] + K['T_STP'] + K['T_FRM'] + K['T_PHO']
        mk = re.search(r'marks \[(\d+), (\d+), (\d+), (\d+)\]', r.stdout); pt = re.search(r'pure padding tiles (\d+) (\d+) B', r.stdout)
        ov = re.search(r"layout overrides (\d+) rows \{(.*?)\} bytes (\d+)", r.stdout); OV = eval('{' + ov.group(2) + '}'); OVN, OVB = int(ov.group(1)), int(ov.group(3))
        n += quoted('layout legend', r'\*\*Code\*\* \(([\d,]+) B, ', lambda m: ((K['SYS'] + K['CAM'] + K['ALBUM'] + K['EDIT'] + K['LINK'] + K['PRINT'] + K['GAME'] + K['DJ'] + K['UI'] + K['SND'] + K['OTHER'],), (num(m.group(1)),)), docs=('README.md',), need=('README.md',))
        n += quoted('layout legend', r'tile sets ([\d,]+) B \(\d+\.\d %: ([\d,]+) B screens, menus, fonts, sprites and the SGB border; ([\d,]+) B stamps; ([\d,]+) B print frames and photo borders; ([\d,]+) B the 30 stock photos',
                    lambda m: ((tiles, K['T_UI'], K['T_STP'], K['T_FRM'], K['T_PHO']), tuple(num(m.group(i)) for i in range(1, 6))), docs=('README.md',), need=('README.md',))
        n += quoted('layout legend', r'tile maps ([\d,]+) B \(\d+\.\d %\), sprite layouts ([\d,]+) B, sound data ([\d,]+) B, other tables and text ([\d,]+) B \(.*?\), \*\*uncertain ([\d,]+) B\*\*, and padding ([\d,]+) B \(',
                    lambda m: ((K['MAP'], K['OAM'], K['SOUND'], K['TBL'], K['UNC'], K['PAD']), tuple(num(m.group(i)) for i in range(1, 7))), docs=('README.md',), need=('README.md',))
        n += quoted('layout legend', r'\(([\d,]+) tiles, ([\d,]+) B of the padding;', lambda m: ((int(pt.group(1)), int(pt.group(2))), (num(m.group(1)), num(m.group(2)))), docs=('README.md',), need=('README.md',))
        n += quoted('layout legend', r'code that never ran \(([\d,]+) B\), red = unused data \(([\d,]+) B\), blue = identified data the v8 run never read \(([\d,]+) B\); of the padding, ([\d,]+) B were never touched',
                    lambda m: (tuple(int(x) for x in mk.groups()), tuple(num(m.group(i)) for i in range(1, 5))), docs=('README.md',), need=('README.md',))
        n += quoted('layout overrides', r'the (\d+) `Src_\*` / `Data_\*` blocks \(([\d,]+) B in banks[^)]*\) are ([\d,]+) B of tile maps .*? and ([\d,]+) B of tile sets',
                    lambda m: ((OVN, OVB, OV['MAP'], OV['T_UI']), tuple(num(m.group(i)) for i in range(1, 5))), docs=('README.md',), need=('README.md',))
        # the graphic spans tagged `?` (a `?` label on a Gfx type row; its extent is the type row) and the total of the formerly uncertain bytes
        qsp = []
        for r2 in NAMES:
            tt = WIN.get((int(r2['bank'], 16), int(r2['addr'], 16)))
            if r2['conf'] == '?' and tt and tt[5] == 'Gfx': qsp.append(('%s:%s' % (r2['bank'].upper(), r2['addr'].upper()), tt[2] - int(r2['addr'], 16)))
        QB = sum(x[1] for x in qsp)
        n += quoted('? graphic spans', r'the (\d+) graphic spans tagged `\?` \(([\d,]+) B: ([^)]*)\)',
                    lambda m: ((len(qsp), QB, tuple(sorted(x[0] for x in qsp))), (int(m.group(1)), num(m.group(2)), tuple(sorted(re.findall(r'`([0-9A-F]{2}:[0-9A-F]{4})`', m.group(3)))))), docs=('README.md',), need=('README.md',))
        n += quoted('? graphic spans', r'classified by evidence \(([\d,]+) B\)', lambda m: ((QB + OVB,), (num(m.group(1)),)), docs=('README.md',), need=('README.md',))
        ok('layout', 'picture and csv fresh; %d override rows reclassify %s B; `?` graphic spans %s (%s B)' % (OVN, fmt(OVB), [x[0] for x in qsp], fmt(QB)))
    shutil.rmtree(tmp, ignore_errors=True)
else:
    skip('layout', 'no --rom: layout picture and csv not checked')
ok('quoted', '%d quoted sentences checked' % n)

# ------------------------------------------------------------------ sheet rows copied into the README
rows_md = [l for l in md if l.startswith('| `') and l.count('|') >= 6]
rd_lines = set(README.split('\n'))
miss = [l.split('|')[1].strip() for l in rows_md if l not in rd_lines]
for s in miss: bad('sheet', 'README copy of the really_unused.md row %s is missing or differs: copy the row from tcrf_check/assets/unidentified/really_unused.md' % s)
if not miss: ok('sheet', '%d rows of really_unused.md are in the README verbatim' % len(rows_md))
HAND_TAIL = [l for l in md if l.startswith('*Withdrawn after the L3 pass')]
if not HAND_TAIL: bad('sheet', 'really_unused.md lost its hand-kept tail ("*Withdrawn after the L3 pass...*"): display_report.py overwrites it, restore it from git')

# ------------------------------------------------------------------ files and section references
miss = []
for m in re.finditer(r'!?\[[^\]]*\]\(([^)\s]+)\)', README):
    t = m.group(1)
    if t.startswith('http') or t.startswith('#'): continue
    if not os.path.exists(P(t.lstrip('/'))): miss.append(t)
for t in sorted(set(miss)): bad('files', 'README links %s, which does not exist' % t)
heads = set()
for m in re.finditer(r'^#{1,6} (\d+(?:\.\d+)*)[ .]', README, re.M): heads.add(m.group(1))
refs = collections.Counter()
for m in re.finditer(r'§(\d+(?:\.\d+)*)', README + CLAUDE + SKILL + HOWTO): refs[m.group(1)] += 1
EXTERNAL_REFS = {'11.6.6', '11.6.10', '11.6.11', '12.3', '12.4.2'}  # sections of the M64282FP datasheet, quoted as such in the sensor sections
unk = sorted(r for r in refs if r not in heads and r not in EXTERNAL_REFS)
for r in unk:
    # a reference with a trailing sub-number that is only a paragraph label, e.g. §16.24 (3), is cut at the space; anything else must be a heading
    warn('files', '§%s is quoted but there is no heading with that number' % r)
if not miss: ok('files', 'README links exist; %d distinct § references, %d without a heading' % (len(refs), len(unk)))
# `file.csv` (N rows)
for m in re.finditer(r'`((?:[\w.\-]+/)*[\w.\-]+\.csv)` \(([\d,]+) rows', README):
    f = m.group(1)
    cands = [f] + [os.path.join(d, f) for d in ('assets', 'disasm', 'tcrf_check/assets/unidentified')]
    pth = next((c for c in cands if os.path.exists(P(c))), None)
    if not pth: warn('csvrows', '%s is quoted with %s rows but was not found' % (f, m.group(2))); continue
    rows = len(list(csv.reader(open(P(pth), encoding='utf-8')))) - 1
    if rows != num(m.group(2)): bad('csvrows', '%s: README says %s rows, the file has %d' % (f, m.group(2), rows))
for m in re.finditer(r'open-assets sheet has ([\d,]+) rows', README):
    if OA_ROWS != num(m.group(1)): bad('csvrows', 'open_assets.csv: README says %s rows, the file has %d' % (m.group(1), OA_ROWS))

# asset labels quoted in the docs must exist (placeholders such as Gfx_BB_AAAA and prefixes of an existing name are fine)
NAMESET = {r['name'] for r in NAMES}
stale = collections.defaultdict(set)
for dn, dt in DOCS.items():
    for m in re.finditer(r'\b(?:Gfx|Map|Src|Data|Sheet)_[0-9A-F]{2}_[0-9A-F]{4}(?:_[A-Za-z0-9]+)*', dt):
        x = m.group(0)
        if '_BB_AAAA' in x: continue
        if x not in NAMESET and not any(nm.startswith(x) for nm in NAMESET): stale[x].add(dn)
for x, ds in sorted(stale.items()): bad('docnames', '%s is quoted in %s but is not a label of sym_names_jp.csv (renamed? fix the sentence)' % (x, sorted(ds)))
if not stale: ok('docnames', 'every asset label quoted in the docs exists')

# bank pictures behind the doubtful rows (tools/bank_pics.py; the colours follow the tags, so a retag changes them)
if A.rom:
    bd = P('disasm/sym_unconclusive_banks'); bl = sorted(f[5:7] for f in os.listdir(bd) if re.match(r'bank_[0-9A-F]{2}\.png$', f))
    tmp = tempfile.mkdtemp(prefix='cons_b_')
    r = subprocess.run([sys.executable, 'tools/bank_pics.py', A.rom, 'disasm/sym_names_jp.csv', tmp] + bl, capture_output=True, text=True)
    if r.returncode: bad('bankpics', 'bank_pics.py failed: %s' % (r.stderr or r.stdout).strip()[-200:])
    else:
        old = [b for b in bl if open(os.path.join(tmp, 'bank_%s.png' % b), 'rb').read() != open(os.path.join(bd, 'bank_%s.png' % b), 'rb').read()]
        for b in old: bad('bankpics', 'disasm/sym_unconclusive_banks/bank_%s.png is stale: run tools/bank_pics.py ROM disasm/sym_names_jp.csv disasm/sym_unconclusive_banks %s' % (b, ' '.join(bl)))
        if not old: ok('bankpics', '%d bank pictures fresh' % len(bl))
    shutil.rmtree(tmp, ignore_errors=True)
else:
    skip('bankpics', 'no --rom: bank pictures not checked')

# ------------------------------------------------------------------ the 96 effect slots (README 16.28)
EF_CSV = 'tcrf_check/assets/effect_slots/effect_slots_bgb.csv'
EF = list(csv.DictReader(io.StringIO(rd(EF_CSV))))
NAME_AT = {(r['bank'].upper(), r['addr'].upper()): r['name'] for r in NAMES}
ef_bad = 0
if [r['slot'] for r in EF] != ['%02X' % i for i in range(96)]:
    bad('effects', '%s does not hold the slots 00-5F in order' % EF_CSV); ef_bad += 1
else:
    if A.rom:
        rom_b = open(A.rom, 'rb').read()
        for i, r in enumerate(EF):
            o = 0x0A * 0x4000 + 0x541A - 0x4000 + 2 * i; a = rom_b[o] | rom_b[o + 1] << 8
            if r['entry'].upper() != '0A:%04X' % a: bad('effects', 'slot %02X: the csv says %s, the jump table holds 0A:%04X' % (i, r['entry'], a)); ef_bad += 1
            elif NAME_AT.get(('0A', '%04X' % a)) != r['label']: bad('effects', 'slot %02X: csv label %s, sym_names_jp.csv has %s at 0A:%04X' % (i, r['label'], NAME_AT.get(('0A', '%04X' % a)), a)); ef_bad += 1
    else:
        skip('effects', 'no --rom: the entry addresses are not compared with the jump table (the rest is checked)')
    writers = [r for r in EF if r['effect'] != 'NoWrite']
    facts = {'slots that write': len(writers), 'lone rets': 96 - len(writers), 'routines': len({r['entry'] for r in EF}),
             'selected by the game': sum(r['reached_by_game'] == 'yes' for r in EF), 'never selected': sum(r['reached_by_game'] != 'yes' for r in EF),
             'never selected, writing': sum(r['reached_by_game'] != 'yes' for r in writers),
             'on the flipped photo': sum(int(r['slot'], 16) >= 0x20 and (r['effect'] in ('FlipH', 'FlipV') or '_OnFlip' in r['effect']) for r in writers),
             'picture flipped': sum(int(r['slot'], 16) >= 0x20 and re.search(r'_Flip[HV]$', r['effect']) is not None for r in writers),
             'identity': sum(r['grey_levels'].startswith('identity (') for r in writers), 'identity except table byte': sum('wrong table byte' in r['grey_levels'] for r in writers)}
    sec = README[README.index('### 16.28 '):README.index('\n## 17.')]
    for desc, pat, keys in (('slots write', r'(\d+) of the 96 slots write the buffer; the other (\d+) ', ('slots that write', 'lone rets')),
                            ('grey levels', r'For (\d+) of the (\d+) the output is exactly', ('identity', 'slots that write')),
                            ('routines', r'the 96 slots hold (\d+) routines', ('routines',)),
                            ('flip options', r'\*\*(\d+) of the 50 slots are the base slot applied to the flipped photo', ('on the flipped photo',)),
                            ('flip picture', r'\*\*(\d+) flip the finished picture instead', ('picture flipped',)),
                            ('never selected', r'The (\d+) slots the game never selects \((\d+) lone `ret`, (\d+) copies\)', ('never selected', 'lone rets', 'never selected, writing'))):
        m = re.search(pat, sec)
        if not m: bad('effects', 'README 16.28: no sentence matches %r (reword it or fix the checker)' % desc); ef_bad += 1; continue
        exp = tuple(facts[k] for k in keys); got = tuple(int(g) for g in m.groups())
        if exp != got: bad('effects', 'README 16.28 %s: says %s, %s says %s %s' % (desc, got, EF_CSV, keys, exp)); ef_bad += 1
    if facts['identity'] + facts['identity except table byte'] != facts['slots that write']: bad('effects', 'a writing slot is neither an identity nor the table-byte case'); ef_bad += 1
cited = set()
for r in NAMES:
    for f in re.findall(r'tcrf_check/[\w./\-]*[\w]\.(?:csv|png|py|md)\b', r['note']): cited.add(f)
for f in sorted(cited):
    if not os.path.exists(P(f)): bad('effects', 'a label note cites %s, which does not exist' % f); ef_bad += 1
if not ef_bad: ok('effects', '96 slots, %s; %d tcrf_check files cited by label notes exist' % (', '.join('%s %d' % (k, v) for k, v in facts.items()), len(cited)))

# ------------------------------------------------------------------ RAM names (L4, README 2.13)
sys.path.insert(0, P('tools'))
import ram_names as RN
RAM_BAD = 0
try:
    RAM_ROWS = RN.load(P('disasm/ram_names_jp.csv'))
except Exception as e:
    RAM_ROWS = []; bad('ram', 'disasm/ram_names_jp.csv does not load: %s' % e); RAM_BAD += 1
RAM_TAGS = collections.Counter(r.tag for r in RAM_ROWS)
ROMNAMES = {r['name'] for r in NAMES}
for r in RAM_ROWS:
    wram = r.name.startswith('w') and 0xC000 <= r.addr and r.end <= 0xE000
    hram = r.name.startswith('h') and 0xFF80 <= r.addr and r.end <= 0xFFFF
    ext = r.name == '_RAM' and r.addr == 0xC000
    if not (re.fullmatch(r'[wh][A-Z][A-Za-z0-9]*', r.name) or ext) or not (wram or hram or ext):
        bad('ram', '%s (%04X, %d bytes): the name must be w + PascalCase inside $C000-$DFFF or h + PascalCase inside $FF80-$FFFF' % (r.name, r.addr, r.size)); RAM_BAD += 1
    if r.name in ROMNAMES: bad('ram', '%s is also a ROM label' % r.name); RAM_BAD += 1
    if r.tag not in ('C', 'I', 'U', '?'): bad('ram', '%s: unknown tag %r' % (r.name, r.tag)); RAM_BAD += 1
RAM_EXCL = list(csv.DictReader(io.StringIO(rd('disasm/ram_exclude_jp.csv'))))
for fn, text in (('disasm/ram_jp.inc', RN.inc_text(RAM_ROWS)), ('pocketcamera_jp_ram.sym', RN.sym_text(RAM_ROWS))):
    if not os.path.exists(P(fn)) or open(P(fn), encoding='utf-8', newline='').read() != text:
        bad('ram', '%s is not what tools/ram_names.py writes from disasm/ram_names_jp.csv (run it)' % fn); RAM_BAD += 1
# every proven access gets exactly one name; the exclusions are pointer loads of numbers
RES = RN.Resolver(RAM_ROWS)
excl = {(int(r['bank'], 16), int(r['pc'], 16)): int(r['value'], 16) for r in RAM_EXCL}
acc_sites = set(); acc_unnamed = collections.Counter(); acc_kinds = collections.Counter(); excl_seen = set(); named_rows = set()
for r in csv.DictReader(io.StringIO(rd('wram/wram_access.csv'))):
    a = int(r['addr'], 16); key = (int(r['bank'], 16), int(r['pc'], 16))
    if r['kind'] == 'P' and excl.get(key) == a: excl_seen.add(key); continue
    if not (0xC000 <= a < 0xE000 or 0xFF80 <= a <= 0xFFFE): continue
    try: res = RES.resolve(key[0], key[1], r['function'], a)
    except ValueError as e: bad('ram', str(e)); RAM_BAD += 1; continue
    if res is None: acc_unnamed[(key[0], a)] += 1; continue
    acc_sites.add(key + (a,)); acc_kinds[r['kind']] += 1; named_rows.add(res[0].name)
for (b, a), n in sorted(acc_unnamed.items()): bad('ram', 'bank %02X address $%04X (%d accesses) has no name for that bank: add a row to disasm/ram_names_jp.csv or an exclusion' % (b, a, n)); RAM_BAD += 1
for k, v in excl.items():
    if k not in excl_seen: bad('ram', 'ram_exclude_jp.csv %02X:%04X $%04X is not a pointer load of the access table' % (k[0], k[1], v)); RAM_BAD += 1
if not RAM_BAD:
    ok('ram', '%d names (C %d, I %d, U %d, ? %d), %d rows limited to a bank, routine or instruction, %d proven access sites named, %d exclusions; ram_jp.inc and the .sym are fresh' % (
        len(RAM_ROWS), RAM_TAGS['C'], RAM_TAGS['I'], RAM_TAGS['U'], RAM_TAGS['?'], sum(1 for r in RAM_ROWS if r.scope != '*'), len(acc_sites), len(excl)))
    quoted('ram rows', r'(?<![\w.])([\d,]+) RAM names', lambda m: ((len(RAM_ROWS),), (num(m.group(1)),)), docs=('README.md', 'CLAUDE.md', 'SKILL.md', 'HOWTO_NEW_ROM.md'), need=('README.md',))
    quoted('ram tags', r'RAM names \(C ([\d,]+) / I ([\d,]+) / U ([\d,]+) / \? ([\d,]+)', lambda m: ((RAM_TAGS['C'], RAM_TAGS['I'], RAM_TAGS['U'], RAM_TAGS['?']), tuple(num(g) for g in m.groups())), docs=('README.md',), need=('README.md',))
    quoted('ram sites', r'resolves? every access of `wram/wram_access.csv` \(([\d,]+) instruction sites\)', lambda m: ((len(acc_sites),), (num(m.group(1)),)), docs=('README.md',), need=('README.md',))
    quoted('ram exclusions', r'([\d,]+) pointer loads of the table are numbers that only look like addresses', lambda m: ((len(RAM_EXCL),), (num(m.group(1)),)), docs=('README.md',), need=('README.md',))

# ------------------------------------------------------------------ TCRF checklist
tm = rd('tcrf_check/TCRF_CHECKLIST.md'); tc = open(P('tcrf_check/TCRF_CHECKLIST.csv'), encoding='utf-8').read()
ids_md = sorted(set(re.findall(r'^\| ([A-Z]\d\d) \|', tm, re.M))); ids_csv = sorted(set(re.findall(r'^"?([A-Z]\d\d)"?,', tc, re.M)))
if ids_md != ids_csv: bad('tcrf', 'checklist ids differ: md %s csv %s' % (ids_md, ids_csv))
else: ok('tcrf', '%d checklist ids in both files' % len(ids_md))

# ------------------------------------------------------------------ round trip
if A.roundtrip:
    if not A.rom: skip('roundtrip', 'needs --rom')
    elif not os.path.exists(A.mgbdis): skip('roundtrip', 'mgbdis not found at %s (--mgbdis)' % A.mgbdis)
    else:
        tmp = tempfile.mkdtemp(prefix='cons_rt_'); rom = os.path.join(tmp, 'in', 'pocketcamera_jp.gb'); os.makedirs(os.path.dirname(rom))
        shutil.copy(A.rom, rom); shutil.copy(P('pocketcamera_jp.sym'), os.path.join(tmp, 'in', 'pocketcamera_jp.sym'))
        env = dict(os.environ); env['PATH'] = A.rgbds + ':' + env['PATH']
        want = 'fdcfe686cf4df461e870b6e53b2b5a8b'
        subprocess.run([sys.executable, A.mgbdis, rom, '--output-dir', os.path.join(tmp, 'hex'), '--overwrite', '--print-hex'], capture_output=True, text=True)    # sym_fix.py reads the `; $ADDR: $xx` comments
        for variant in ('plain', 'fixed', 'ram'):
            d = os.path.join(tmp, variant)
            if variant == 'plain':
                subprocess.run([sys.executable, A.mgbdis, rom, '--output-dir', d, '--overwrite'], capture_output=True, text=True)
            elif variant == 'fixed':
                shutil.copytree(os.path.join(tmp, 'hex'), d); [os.remove(os.path.join(d, f)) for f in os.listdir(d) if f.endswith('.o') or f == 'game.gb']
                subprocess.run([sys.executable, 'tools/sym_fix.py', d, '--tables', '--rom', A.rom, '--sym', 'pocketcamera_jp.sym', '--trace', 'wram/trace_jp_v3.json'], capture_output=True, text=True)
            else:
                shutil.copytree(os.path.join(tmp, 'hex'), d); [os.remove(os.path.join(d, f)) for f in os.listdir(d) if f.endswith('.o') or f == 'game.gb']
                sf = subprocess.run([sys.executable, 'tools/sym_fix.py', d, '--tables', '--ram', '--rom', A.rom, '--sym', 'pocketcamera_jp.sym', '--trace', 'wram/trace_jp_v3.json'], capture_output=True, text=True)
                st = {k: int(v) for k, v in re.findall(r'(\w+)=(\d+)', sf.stdout.split('sym_fix:')[-1])}
                quoted('sym_fix stats', r'\((\d+) MBC writes, (\d+) byte counts and (\d+) sprite positions in `bc`, (\d+) far-pointer loads, ([\d,]+) \+ ([\d,]+) word-table rows as `dw`, (\d+) `\{lo,hi,bank\}` rows',
                       lambda m: (tuple(st.get(k, 0) for k in ('mbc_write', 'bc_count', 'bc_coords', 'far_ptr', 'dw_label', 'dw_numeric', 'far_ptr_row')), tuple(num(g) for g in m.groups())), docs=('README.md',), need=('README.md',))
                named = {k: sum(v for kk, v in st.items() if kk in ks) for k, ks in (('abs', ('ram_mem', 'ram_mem_off')), ('ldh', ('ram_ldh', 'ram_ldh_off')), ('ptr', ('ram_ptr', 'ram_ptr_off')), ('ie', ('ram_ie',)))}
                tot = sum(named.values())
                # what is left: ld / ldh lines with an operand inside $C000-$DFFF or $FF80-$FFFE (the exclusions, nothing else)
                left = []
                for f in sorted(os.listdir(d)):
                    if not re.match(r'bank_[0-9a-f]+\.asm$', f): continue
                    for line in open(os.path.join(d, f), encoding='utf-8'):
                        m = re.match(r'^\s+(ldh?|ld) [^;]*\$([0-9a-f]{4})\b[^;]*; \$([0-9a-f]{4}): ', line)
                        if m and (0xC000 <= int(m.group(2), 16) < 0xE000 or 0xFF80 <= int(m.group(2), 16) <= 0xFFFE): left.append((f, m.group(3), m.group(2)))
                nex = sum(1 for k, v in excl.items() if 0xC000 <= v < 0xE000 or 0xFF80 <= v <= 0xFFFE)
                if len(left) != nex or st.get('ram_unnamed') or st.get('ram_unproven') or st.get('ram_no_token'): bad('roundtrip', 'ram listing: %d raw RAM operands left (the %d exclusions are the only ones allowed), stats %s' % (len(left), nex, st))
                else: ok('roundtrip', 'ram: %s instructions use a RAM name (%s absolute, %s ldh, %s address loads, %s rIE), %d raw numbers left (the exclusions)' % (fmt(tot), fmt(named['abs']), fmt(named['ldh']), fmt(named['ptr']), fmt(named['ie']), len(left)))
                quoted('ram operands', r'([\d,]+) instructions use a RAM name \(([\d,]+) absolute loads and stores, ([\d,]+) `ldh`, ([\d,]+) address loads, ([\d,]+) `ld hl, rIE`\)', lambda m: ((tot, named['abs'], named['ldh'], named['ptr'], named['ie']), tuple(num(g) for g in m.groups())), docs=('README.md',), need=('README.md',))
            subprocess.run(['make'], cwd=d, env=env, capture_output=True, text=True)
            import hashlib
            g = os.path.join(d, 'game.gb'); h = hashlib.md5(open(g, 'rb').read()).hexdigest() if os.path.exists(g) else None
            if h != want: bad('roundtrip', '%s round trip gives md5 %s, expected %s' % (variant, h, want))
            else: ok('roundtrip', '%s: md5 %s' % (variant, h))
        shutil.rmtree(tmp, ignore_errors=True)

print()
print('%d failed, %d warnings, %d skipped' % (len(FAIL), len(WARN), len(SKIP)))
sys.exit(1 if FAIL else 0)
