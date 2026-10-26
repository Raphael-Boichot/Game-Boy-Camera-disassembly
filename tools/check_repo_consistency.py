#!/usr/bin/env python3
"""Repository consistency check: the numbers and names that several files repeat must agree, and the generated files must be fresh.

usage: tools/check_repo_consistency.py [--rom pocketcamera_jp.gb] [--roundtrip] [--mgbdis /path/to/mgbdis.py] [--rgbds /path/to/rgbds] [-q]
  run it from anywhere; it works on the repository that holds it.  Exit status 1 when a check fails (warnings do not fail).
  Without --rom the checks that need the ROM (sym freshness, byte types, yellow bytes, md5 round trip) are skipped and said so.

What it checks (each line of the report is one check)
  names      sym_names_jp.csv: tags C / I / ?, duplicate names, a name that carries another address than its own (only `_Part<addr>` / `_Cont` may),
             a `Map_*` label on a `Gfx` type row (and `Gfx_*` on a `Map` row; the type rows are applied in order, the last row wins, as in sym_build.py)
  sym        pocketcamera_jp.sym equals a fresh sym_build.py run (needs the ROM); block / label / line counts
  doubts     disasm/sym_unconclusive_jp.{md,csv} and sym_settled_unused_jp.csv equal a fresh make_doubts.py run; rows, distinct bytes, rows settled as unused
  renamed    roms/jp_rev_a/disasm/renamed_jp.csv rows against the counts the README quotes
  quoted     every count that README.md, CLAUDE.md, skills/gb-rom-disassembly/SKILL.md and HOWTO_NEW_ROM.md quote (labels per tag, doubtful rows, distinct bytes,
             blocks, bytes per type, sym lines, really-unused totals, tier table, per-bank layout table, TCRF label count) against the files they come from
  layout     (needs --rom) jp_rom_layout_map.png and roms/jp_rev_a/assets/layout_by_bank_jp.csv equal a fresh rom_layout_map.py run; the legend sentences of the README (bytes per kind, padding
             tiles, never-run marks, the Src_* / Data_* evidence rows, the graphic spans tagged `?`) equal what the run prints
  sheet      the really_unused.md table rows are copied verbatim into the README; the README says the same total as the md; the hand-kept tail of the md is still there
  files      files that README.md links or shows (images, markdown links) exist; `§N.M` references point to a heading that exists (datasheet sections are listed in EXTERNAL_REFS)
  csvrows    "`file.csv` (N rows)" claims in the README
  docnames   every `Gfx_BB_AAAA_...` / `Map_` / `Src_` / `Data_` / `Sheet_` label quoted in README, CLAUDE.md, the skill and the HOWTO is a label of sym_names_jp.csv (or the start of one)
  bankpics   (needs --rom) roms/jp_rev_a/disasm/sym_unconclusive_banks/*.png equal a fresh tools/bank_pics.py run
  tcrf       tcrf_check/TCRF_CHECKLIST.md and .csv list the same ids
  effects    tcrf_check/assets/effect_slots/effect_slots_bgb.csv has the 96 slots of the jump table 0A:541A in order, each row's entry address (needs --rom) and label equal the ROM and sym_names_jp.csv;
             the counts quoted in README 16.28 (slots that write, lone rets, routines, slots the game selects, flip relations, grey-level checks) equal the csv; every tcrf_check/ file a label note cites exists
  ram        roms/jp_rev_a/disasm/ram_names_jp.csv (the RAM names, README 2.13): identifiers and prefixes, no clash with a ROM label, roms/jp_rev_a/disasm/ram_jp.inc and pocketcamera_jp_ram.sym equal a fresh tools/ram_names.py run, every access of
             roms/jp_rev_a/wram/wram_access.csv inside $C000-$DFFF / $FF80-$FFFE resolves to exactly one name for its bank, routine and instruction (the pointer loads of ram_exclude_jp.csv are numbers); the counts the README quotes
  forced     tcrf_check/assets/unidentified/forced_first_readers.csv equals a fresh tcrf_check/tools/forced_first_readers.py run on coverage/v8/merged_v8/cov.npz; the README sentences of 16.24 that quote it
  printwatch tcrf_check/assets/unidentified/map_26_7080_print_watch.csv (BGB read watch on 26:7080-72BF during two prints of copied Album B pictures: 0 hits, controls > 0), the organic coverage of Album B and of the maps next to 26:7080, the count of the byte pair 80 70 against the proven code; the README sentences of 16.25.2 that quote them
  seamoffsets tcrf_check/assets/unidentified/map_26_7080_seam_offsets.csv (seam search of 26:7080 at every byte offset: 13 variants, ratio best / control column consistent, none below 0.70 where a true block gives 0.33-0.37); the README sentences of 16.25.2 that quote them
  patternmatch tcrf_check/assets/unidentified/map_26_7080_pattern_match.csv (pattern of repeated ids of 26:7080 and two control maps against every window of both ROMs: a counterpart scores 1.000, no other window 0.20 or more); the README sentences of 16.25.2 that quote them
  handspan   (with --rom) the span 11:5800-693F has fewer different tiles (130 of 276, 95 blank) than the 245 ids of 26:7080 and its four natural layouts cost 0.7 per pixel or more; the README sentence of 16.25.2 that quotes them
  oamlist    (with --rom) no call of Oam_AddMeta_B01_4000 (00:24AF) has a literal id $A6-$BB, no organic run reads those 22 OAM lists ($BA = the hand flipping a newspaper), the README sentence of 16.24 that quotes the call and list counts
  statsplit  what STAT handler 1 splits (README 2, interrupt map): the census table of the screens that run the split, the ROM sites that turn the interrupt on and off, the README sentences that quote them
  screengif  the whole-screen GIF of the page transitions of the main menu (README 16.24): 640 x 576, endless loop, the frame count and length the README quotes
  headsets   (with --rom) why the ball head animation is stored twice: the frames F0-F4 and F5-F9 differ only inside the ids $20-$2F (10 or 11 tiles of 16), set A meets the body strip 16:5580 (seam 47-48) and set B the strip 11:4000 (41-42), each twice worse on the other, F4 and F9 carry the collar tiles of their strip byte for byte; the README paragraph of 16.24 that quotes them
  roundtrip  (--roundtrip) mgbdis + rgbasm rebuild the ROM from the sym byte-exact, plain, after sym_fix.py --tables, and after sym_fix.py --tables --ram (RAM names; the listing keeps only the excluded numbers); the plain listing's own labels are counted (`jr_` / `Jump_` / `Call_`, quoted in the README L5 row)
  source     (--roundtrip) roms/jp_rev_a/src/ is exactly what tools/make_source.py writes, and it builds the ROM byte-exact (PNG -> 2bpp, rgbasm, rgblink, rgbfix); the README sentence that quotes its counts

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

# README.md and the section files of docs/ are read as one document (the notes were one README until 2026-10-26); RDOCS keeps where each part starts
RDOCS = [('README.md', rd('README.md'))] + [(os.path.join('docs', f), rd(os.path.join('docs', f))) for f in sorted(os.listdir(P('docs'))) if f.endswith('.md')]
README = ''; RSTART = []
for _f, _t in RDOCS: RSTART.append((len(README), _f)); README += _t + '\n'
def rwhere(off):
    '''file and line of an offset in the README + docs text'''
    f0, s0 = 'README.md', 0
    for st, f in RSTART:
        if st <= off: f0, s0 = f, st
    return '%s:%d' % (f0, README.count('\n', s0, off) + 1)
CLAUDE = rd('CLAUDE.md'); SKILL = rd('skills/gb-rom-disassembly/SKILL.md'); HOWTO = rd('HOWTO_NEW_ROM.md')
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
                loc = rwhere(m.start()) if d == 'README.md' else '%s:%d' % (d, DOCS[d].count('\n', 0, m.start()) + 1)
                bad('quoted', '%s %s says %s, the files say %s' % (loc, name, got, exp))
    return n

# ------------------------------------------------------------------ names
NAMES = list(csv.DictReader(io.StringIO(rd('roms/jp_rev_a/disasm/sym_names_jp.csv'))))
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
for l in rd('roms/jp_rev_a/disasm/sym_types_jp.csv').split('\n'):
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
        fresh = open(out).read(); cur = rd('roms/jp_rev_a/pocketcamera_jp.sym')
        if fresh != cur: bad('sym', 'pocketcamera_jp.sym is not what sym_build.py makes from the csv files: rebuild it')
        m = re.search(r'(\d+) labels \(\d+ from the legacy file\), (\d+) type rows, (\d+) lines', r.stdout); LINES = int(m.group(3)); BLOCKS = LINES - int(m.group(1))
        m = re.search(r'bytes by type: (\{.*\})', r.stdout); BYTES = eval(m.group(1))
        if int(re.search(r'(\d+) labels', r.stdout).group(1)) != NL: bad('sym', 'label count differs from the names csv')
        if not any(f.startswith('sym') for f in FAIL): ok('sym', '%s lines, %s blocks, bytes %s' % (fmt(LINES), fmt(BLOCKS), {k: fmt(v) for k, v in BYTES.items()}))
    shutil.rmtree(tmp, ignore_errors=True)
else:
    skip('sym', 'no --rom: sym freshness and byte types not checked')

# ------------------------------------------------------------------ doubts
DR = list(csv.DictReader(io.StringIO(rd('roms/jp_rev_a/disasm/sym_unconclusive_jp.csv'))))
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
DS = list(csv.DictReader(io.StringIO(rd('roms/jp_rev_a/disasm/sym_settled_unused_jp.csv'))))     # rows proven unused (doubts_overrides_jp.csv, status final): not doubtful
DSET = len(DS)
tmpd = tempfile.mkdtemp(prefix='cons_d_')
r = subprocess.run([sys.executable, 'tools/make_doubts.py', 'roms/jp_rev_a/disasm/sym_names_jp.csv', tmpd, 'roms/jp_rev_a/pocketcamera_jp.sym'], capture_output=True, text=True)
if r.returncode: bad('doubts', 'make_doubts.py failed: %s' % (r.stderr or r.stdout).strip()[-300:])
else:
    for f in ('sym_unconclusive_jp.csv', 'sym_unconclusive_jp.md', 'sym_settled_unused_jp.csv'):
        if open(os.path.join(tmpd, f), encoding='utf-8').read() != rd('roms/jp_rev_a/disasm/' + f): bad('doubts', 'roms/jp_rev_a/disasm/%s is stale: run tools/make_doubts.py' % f)
    if not any(f.startswith('doubts') for f in FAIL): ok('doubts', '%d rows on %s distinct bytes; %d settled as unused' % (DROWS, fmt(DBYTES), DSET))
shutil.rmtree(tmpd, ignore_errors=True)
if sum(1 for r in DR if r['conf'] == '?') != Q: bad('doubts', 'the doubts csv holds %d `?` rows, the names csv %d' % (sum(1 for r in DR if r['conf'] == '?'), Q))

# ------------------------------------------------------------------ renamed
RN = list(csv.DictReader(io.StringIO(rd('roms/jp_rev_a/disasm/renamed_jp.csv'))))
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
n += quoted('left `?`', r'(?:What is left of the (\d+) `\?`|No name is tagged `\?`)', lambda m: ((Q,), (int(m.group(1) or 0),)), need=('README.md',))
# doubts
n += quoted('doubtful rows', r'\((\d+) rows: every `\?` name', lambda m: ((DROWS,), (int(m.group(1)),)), need=('README.md',))
n += quoted('doubtful rows', r'doubtful rows \d+ -> (\d+)', lambda m: ((DROWS,), (int(m.group(1)),)), need=('README.md',))
n += quoted('doubtful rows', r'; (\d+) doubtful rows are listed', lambda m: ((DROWS,), (int(m.group(1)),)), need=('CLAUDE.md',))
n += quoted('doubtful rows', r'(\d+) doubtful rows on ([\d,]+) distinct bytes', lambda m: ((DROWS, DBYTES), (int(m.group(1)), num(m.group(2)))), need=('SKILL.md',))
n += quoted('doubtful bytes', r'distinct doubtful bytes [\d,]+ -> ([\d,]+)', lambda m: ((DBYTES,), (num(m.group(1)),)), need=('README.md',))
n += quoted('doubtful bytes', r'sit on ([\d,]+) distinct ROM bytes', lambda m: ((DBYTES,), (num(m.group(1)),)), need=('README.md',))
n += quoted('doubtful rows', r'the (\d+) rows of `roms/jp_rev_a/disasm/sym_unconclusive_jp.csv`', lambda m: ((DROWS,), (int(m.group(1)),)), need=('README.md',))
n += quoted('settled rows', r'(\d+) rows proven unused are listed apart \(`roms/jp_rev_a/disasm/sym_settled_unused_jp.csv`', lambda m: ((DSET,), (int(m.group(1)),)), need=('README.md',))
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
n += quoted('left `?`', r'the doubtful list holds (\d+) `\?` names and (\d+) rows', lambda m: ((Q, DROWS), (int(m.group(1) or 0), int(m.group(2)))), need=('README.md',))
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
LB = list(csv.DictReader(io.StringIO(rd('roms/jp_rev_a/assets/layout_by_bank_jp.csv'))))
for r in LB:
    if r['bank'] == 'total':
        TOT_UNUSED = int(r['unused_data']); TOT_CODE = int(r['never_run_code']); TOT_IDENT = int(r['unread_identified_data'])
        n += quoted('layout totals', r'\| \*\*all\*\* \| \*\*([\d,]+)\*\* \| \*\*([\d,]+)\*\* \| \*\*([\d,]+)\*\* \|', lambda m: ((TOT_CODE, TOT_UNUSED, TOT_IDENT), tuple(num(m.group(i)) for i in (1, 2, 3))), docs=('README.md',), need=('README.md',))
        n += quoted('layout totals', r'red = unused data \(([\d,]+) B', lambda m: ((TOT_UNUSED,), (num(m.group(1)),)), docs=('README.md',), need=('README.md',))
        continue
    mm = re.search(r'^\| `\$%s` \|[^|]*\| ([\d,]*) \| ([\d,]*) \|' % r['bank'].upper(), README, re.M)
    if mm and (num(mm.group(1) or '0'), num(mm.group(2) or '0')) != (int(r['unused_data']), int(r['unread_identified_data'])):
        bad('layout', 'README per-bank row $%s says unused %s / identified %s, roms/jp_rev_a/assets/layout_by_bank_jp.csv has %s / %s' % (r['bank'], mm.group(1), mm.group(2), r['unused_data'], r['unread_identified_data']))
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
        if cmp_png := os.path.join(ROOT, 'roms', 'jp_rev_a', 'jp_rom_reachability_map.png'):
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
        if open(os.path.join(tmp, 'l.png'), 'rb').read() != open(P('roms/jp_rev_a/jp_rom_layout_map.png'), 'rb').read(): bad('layout', 'jp_rom_layout_map.png is stale: run tcrf_check/tools/rom_layout_map.py OUT.png --rom ROM')
        if open(os.path.join(tmp, 'l.csv'), 'rb').read() != open(P('roms/jp_rev_a/assets/layout_by_bank_jp.csv'), 'rb').read(): bad('layout', 'roms/jp_rev_a/assets/layout_by_bank_jp.csv is stale: run rom_layout_map.py --csv roms/jp_rev_a/assets/layout_by_bank_jp.csv')
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
        n += quoted('? graphic spans', r'(?:the (\d+) graphic spans tagged `\?` \(([\d,]+) B: ([^)]*)\)|no graphic span is tagged `\?`)',
                    lambda m: ((len(qsp), QB, tuple(sorted(x[0] for x in qsp))), (int(m.group(1) or 0), num(m.group(2) or '0'), tuple(sorted(re.findall(r'`([0-9A-F]{2}:[0-9A-F]{4})`', m.group(3) or ''))))), docs=('README.md',), need=('README.md',))
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
for _f, _t in RDOCS:                       # a link is relative to the file that holds it
    for m in re.finditer(r'!?\[[^\]]*\]\(([^)\s]+)\)', _t):
        t = m.group(1).split('#')[0]
        if not t or t.startswith('http'): continue
        if not os.path.exists(P(os.path.normpath(os.path.join(os.path.dirname(_f), t.lstrip('/'))))): miss.append('%s -> %s' % (_f, m.group(1)))
for t in sorted(set(miss)): bad('files', 'link %s, which does not exist' % t)
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
    cands = [f] + [os.path.join(d, f) for d in ('roms/jp_rev_a/assets', 'roms/jp_rev_a/disasm', 'tcrf_check/assets/unidentified')]
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
    bd = P('roms/jp_rev_a/disasm/sym_unconclusive_banks'); bl = sorted(f[5:7] for f in os.listdir(bd) if re.match(r'bank_[0-9A-F]{2}\.png$', f))
    tmp = tempfile.mkdtemp(prefix='cons_b_')
    r = subprocess.run([sys.executable, 'tools/bank_pics.py', A.rom, 'roms/jp_rev_a/disasm/sym_names_jp.csv', tmp] + bl, capture_output=True, text=True)
    if r.returncode: bad('bankpics', 'bank_pics.py failed: %s' % (r.stderr or r.stdout).strip()[-200:])
    else:
        old = [b for b in bl if open(os.path.join(tmp, 'bank_%s.png' % b), 'rb').read() != open(os.path.join(bd, 'bank_%s.png' % b), 'rb').read()]
        for b in old: bad('bankpics', 'roms/jp_rev_a/disasm/sym_unconclusive_banks/bank_%s.png is stale: run tools/bank_pics.py ROM roms/jp_rev_a/disasm/sym_names_jp.csv roms/jp_rev_a/disasm/sym_unconclusive_banks %s' % (b, ' '.join(bl)))
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
    RAM_ROWS = RN.load(P('roms/jp_rev_a/disasm/ram_names_jp.csv'))
except Exception as e:
    RAM_ROWS = []; bad('ram', 'roms/jp_rev_a/disasm/ram_names_jp.csv does not load: %s' % e); RAM_BAD += 1
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
RAM_EXCL = list(csv.DictReader(io.StringIO(rd('roms/jp_rev_a/disasm/ram_exclude_jp.csv'))))
for fn, text in (('roms/jp_rev_a/disasm/ram_jp.inc', RN.inc_text(RAM_ROWS)), ('roms/jp_rev_a/pocketcamera_jp_ram.sym', RN.sym_text(RAM_ROWS))):
    if not os.path.exists(P(fn)) or open(P(fn), encoding='utf-8', newline='').read() != text:
        bad('ram', '%s is not what tools/ram_names.py writes from roms/jp_rev_a/disasm/ram_names_jp.csv (run it)' % fn); RAM_BAD += 1
# every proven access gets exactly one name; the exclusions are pointer loads of numbers
RES = RN.Resolver(RAM_ROWS)
excl = {(int(r['bank'], 16), int(r['pc'], 16)): int(r['value'], 16) for r in RAM_EXCL}
acc_sites = set(); acc_unnamed = collections.Counter(); acc_kinds = collections.Counter(); excl_seen = set(); named_rows = set()
for r in csv.DictReader(io.StringIO(rd('roms/jp_rev_a/wram/wram_access.csv'))):
    a = int(r['addr'], 16); key = (int(r['bank'], 16), int(r['pc'], 16))
    if r['kind'] == 'P' and excl.get(key) == a: excl_seen.add(key); continue
    if not (0xC000 <= a < 0xE000 or 0xFF80 <= a <= 0xFFFE): continue
    try: res = RES.resolve(key[0], key[1], r['function'], a)
    except ValueError as e: bad('ram', str(e)); RAM_BAD += 1; continue
    if res is None: acc_unnamed[(key[0], a)] += 1; continue
    acc_sites.add(key + (a,)); acc_kinds[r['kind']] += 1; named_rows.add(res[0].name)
for (b, a), n in sorted(acc_unnamed.items()): bad('ram', 'bank %02X address $%04X (%d accesses) has no name for that bank: add a row to roms/jp_rev_a/disasm/ram_names_jp.csv or an exclusion' % (b, a, n)); RAM_BAD += 1
for k, v in excl.items():
    if k not in excl_seen: bad('ram', 'ram_exclude_jp.csv %02X:%04X $%04X is not a pointer load of the access table' % (k[0], k[1], v)); RAM_BAD += 1
if not RAM_BAD:
    ok('ram', '%d names (C %d, I %d, U %d, ? %d), %d rows limited to a bank, routine or instruction, %d proven access sites named, %d exclusions; ram_jp.inc and the .sym are fresh' % (
        len(RAM_ROWS), RAM_TAGS['C'], RAM_TAGS['I'], RAM_TAGS['U'], RAM_TAGS['?'], sum(1 for r in RAM_ROWS if r.scope != '*'), len(acc_sites), len(excl)))
    quoted('ram rows', r'(?<![\w.])([\d,]+) RAM names', lambda m: ((len(RAM_ROWS),), (num(m.group(1)),)), docs=('README.md', 'CLAUDE.md', 'SKILL.md', 'HOWTO_NEW_ROM.md'), need=('README.md',))
    quoted('ram tags', r'RAM names \(C ([\d,]+) / I ([\d,]+) / U ([\d,]+) / \? ([\d,]+)', lambda m: ((RAM_TAGS['C'], RAM_TAGS['I'], RAM_TAGS['U'], RAM_TAGS['?']), tuple(num(g) for g in m.groups())), docs=('README.md',), need=('README.md',))
    quoted('ram sites', r'resolves? every access of `roms/jp_rev_a/wram/wram_access.csv` \(([\d,]+) instruction sites\)', lambda m: ((len(acc_sites),), (num(m.group(1)),)), docs=('README.md',), need=('README.md',))
    quoted('ram exclusions', r'([\d,]+) pointer loads of the table are numbers that only look like addresses', lambda m: ((len(RAM_EXCL),), (num(m.group(1)),)), docs=('README.md',), need=('README.md',))

# ------------------------------------------------------------------ first readers of the forced-only data bytes (README 16.24)
FR_FILE = 'tcrf_check/assets/unidentified/forced_first_readers.csv'
try:
    FR = list(csv.DictReader(io.StringIO(rd(FR_FILE))))
except Exception as e:
    FR = []; bad('forced', '%s does not load: %s' % (FR_FILE, e))
if FR:
    tmp = tempfile.mkdtemp(prefix='cons_f_')
    r = subprocess.run([sys.executable, 'tcrf_check/tools/forced_first_readers.py', P('coverage/v8/merged_v8/cov.npz'), os.path.join(tmp, 'f.csv')], capture_output=True, text=True, cwd=ROOT)
    if r.returncode != 0: bad('forced', 'forced_first_readers.py failed: %s' % r.stderr.strip()[-200:])
    elif open(os.path.join(tmp, 'f.csv'), encoding='utf-8').read() != rd(FR_FILE): bad('forced', '%s is not what forced_first_readers.py writes from coverage/v8/merged_v8/cov.npz (run it)' % FR_FILE)
    shutil.rmtree(tmp, ignore_errors=True)
    FR_ALL = FR[-1]; FR_SP = FR[:-1]
    FR_N = int(FR_ALL['read_forced_only']); FR_A = int(FR_ALL['reader1_bytes']); FR_B = int(FR_ALL['reader2_bytes'])
    FR_PRN = sum(1 for x in FR_SP if x['reader1'] == '00:17E8')
    if FR_ALL['reader1'] != '00:17E8' or FR_ALL['reader2'] != '00:0468': bad('forced', 'the two most frequent first readers are %s and %s, the README names 00:17E8 and 00:0468' % (FR_ALL['reader1'], FR_ALL['reader2']))
    else: ok('forced', '%s: %d bytes read only in forced runs, first read by 00:17E8 %d / 00:0468 %d; %d of %d spans first read by 00:17E8; file fresh' % (FR_FILE, FR_N, FR_A, FR_B, FR_PRN, len(FR_SP)))
    quoted('forced bytes', r'Of the ([\d,]+) ROM bytes that some run read, no organic run read and no run executed, `Prn_SendPacketByte` \(`00:17E8`.*?\) is the first reader of ([\d,]+) \(([\d.]+) %\) and `Mem_CopyFromBank` \(`00:0468`, the bank copy\) of ([\d,]+) \(([\d.]+) %\)',
           lambda m: ((FR_N, FR_A, '%.1f' % (100 * FR_A / FR_N), FR_B, '%.1f' % (100 * FR_B / FR_N)), (num(m.group(1)), num(m.group(2)), m.group(3), num(m.group(4)), m.group(5))), docs=('README.md',), need=('README.md',))
    quoted('forced spans', r'(\d+) of the (\d+) spans of `really_unused.csv` that have such bytes have `Prn_SendPacketByte` as their most frequent first reader', lambda m: ((FR_PRN, len(FR_SP)), (num(m.group(1)), num(m.group(2)))), docs=('README.md',), need=('README.md',))

# ------------------------------------------------------------------ 26:7080 and the printing of Album B (README 16.25.2)
PW_FILE = 'tcrf_check/assets/unidentified/map_26_7080_print_watch.csv'
try:
    PW = list(csv.DictReader(io.StringIO(rd(PW_FILE))))
except Exception as e:
    PW = []; bad('printwatch', '%s does not load: %s' % (PW_FILE, e))
if PW:
    import numpy as np
    zc = np.load(P('coverage/v8/merged_v8/cov.npz')); dr_ = zc['dr'] != 0; odr_ = zc['odr'] != 0
    def span(bank, addr, n): o = bank * 0x4000 + addr - 0x4000; return slice(o, o + n)
    AB = slice(0x0DA000, 0x0DA000 + 30 * 0x1000)
    cov = (int(odr_[AB].sum()), AB.stop - AB.start, int(odr_[span(0x26, 0x7080, 576)].sum()), int(odr_[span(0x26, 0x4C80, 576)].sum()), int(odr_[span(0x26, 0x72C0, 576)].sum()))
    if [r['scenario'] for r in PW] != ['print_single', 'print_card']: bad('printwatch', '%s: unexpected scenarios %s' % (PW_FILE, [r['scenario'] for r in PW]))
    elif any(int(r['hits_26_7080_72BF']) != 0 for r in PW) or any(int(r[k]) <= 0 for r in PW for k in ('hits_26_4000_707F', 'hits_26_72C0_7FFF', 'hits_00_1B73_1B9F', 'printed_pages', 'printer_packets')):
        bad('printwatch', '%s: the watch on 26:7080-72BF must have 0 hits and every control and the prints must be positive' % PW_FILE)
    else: ok('printwatch', '2 prints (%s packets, %s pages), 0 reads of 26:7080-72BF, controls %s; Album B pictures read organically %s of %s B, 26:7080 %d, 26:4C80 %d, 26:72C0 %d' % (
        '/'.join(r['printer_packets'] for r in PW), '/'.join(r['printed_pages'] for r in PW), '/'.join(r['hits_26_4000_707F'] for r in PW), fmt(cov[0]), fmt(cov[1]), cov[2], cov[3], cov[4]))
    pk = [r['printer_packets'] for r in PW]; pg = [r['printed_pages'] for r in PW]
    quoted('print watch', r'B01 alone \((\d+) page, (\d+) packets\) and B06, a bird on a branch, with its comment card \((\d+) pages, (\d+) packets;',
           lambda m: ((int(pg[0]), int(pk[0]), int(pg[1]), int(pk[1])), tuple(int(m.group(i)) for i in (1, 2, 3, 4))), docs=('README.md',), need=('README.md',))
    quoted('print watch', r'fired 0 times in both\*\*, the controls ([\d,]+) and ([\d,]+) times \(`26:4000-707F`\), (\d+) times \(`26:72C0-7FFF`\) and (\d+) and (\d+) times \(packets\)',
           lambda m: ((int(PW[0]['hits_26_4000_707F']), int(PW[1]['hits_26_4000_707F']), int(PW[0]['hits_26_72C0_7FFF']), int(PW[0]['hits_00_1B73_1B9F']), int(PW[1]['hits_00_1B73_1B9F'])), (num(m.group(1)), num(m.group(2)), int(m.group(3)), int(m.group(4)), int(m.group(5)))), docs=('README.md',), need=('README.md',))
    quoted('print watch', r'are read in organic runs \(([\d,]+) of ([\d,]+) B\), `26:7080-72BF` is not \((\d+) of 576 B\), while its neighbours `26:4C80` and `26:72C0` are \((\d+) of 576 B each\)',
           lambda m: (cov[:4], (num(m.group(1)), num(m.group(2)), int(m.group(3)), int(m.group(4)))), docs=('README.md',), need=('README.md',))
    if A.rom:
        romb = open(A.rom, 'rb').read(); trc = json.loads(rd('roms/jp_rev_a/wram/trace_jp_v3.json'))['code']
        cov_b = set()
        for k_, L_ in trc.items():
            b_ = int(k_[:2], 16); a_ = int(k_[3:], 16); o_ = a_ if b_ == 0 else b_ * 0x4000 + a_ - 0x4000; cov_b.update(range(o_, o_ + L_))
        occ = [i for i in range(len(romb) - 1) if romb[i] == 0x80 and romb[i + 1] == 0x70]
        touch = sum(1 for i in occ if i in cov_b or i + 1 in cov_b)
        ok('printwatch', 'the byte pair 80 70 occurs %d times in the ROM, %d of them touch a proven instruction byte' % (len(occ), touch))
        quoted('print watch', r'the byte pair `80 70` occurs (\d+) times in the ROM, never inside a proven instruction', lambda m: ((len(occ),), (int(m.group(1)),)), docs=('README.md',), need=('README.md',))
        if touch: bad('printwatch', '%d occurrences of 80 70 touch a proven instruction, the README says never' % touch)
    if cov[3] != 576 or cov[4] != 576: bad('printwatch', '26:4C80 / 26:72C0 organic reads are %d / %d of 576, the README says 576 each' % (cov[3], cov[4]))

# ------------------------------------------------------------------ 26:7080 seam search at every byte offset (README 16.25.2)
SO_FILE = 'tcrf_check/assets/unidentified/map_26_7080_seam_offsets.csv'
try:
    SO = list(csv.DictReader(io.StringIO(rd(SO_FILE))))
except Exception as e:
    SO = []; bad('seamoffsets', '%s does not load: %s' % (SO_FILE, e))
if SO:
    so = {(r['block'], r['ids'], r['order'], r['bpp']): r for r in SO}
    rat = [float(r['best_cost']) / float(r['control_median']) for r in SO]
    if len(SO) != 13: bad('seamoffsets', '%s has %d rows, the README says 13 variants' % (SO_FILE, len(SO)))
    if any(abs(a - float(r['ratio_best_over_control_median'])) > 0.015 for a, r in zip(rat, SO)): bad('seamoffsets', '%s: a ratio column is not best_cost / control_median' % SO_FILE)
    if min(rat) < 0.70: bad('seamoffsets', '%s: a variant has ratio %.2f, a fit would be 0.33-0.37, the README says none fits' % (SO_FILE, min(rat)))
    else: ok('seamoffsets', '13 variants, best ratio %.2f (a true block gives 0.33-0.37), no fit; the README sentences of 16.25.2 that quote them' % min(rat))
    def sv(k, col): return float(so[k][col])
    try:
        pd_ = ('picture', '24-DA', 'desc', '2'); wd_ = ('whole', '00-F5', 'desc', '2'); wa_ = ('whole', '00-F5', 'asc', '2'); wr_ = ('whole', '00-F5', 'rot', '2')
        quoted('seam offsets', r'the best ratio of the best score to the median of the controls is ([\d.]+) \(picture `24-DA` descending, `2F:7FD2`: ([\d.]+) against ([\d.]+);',
               lambda m: ((round(min(rat), 2), sv(pd_, 'best_cost'), sv(pd_, 'control_median')), tuple(float(m.group(i)) for i in (1, 2, 3))), docs=('README.md',), need=('README.md',))
        quoted('seam offsets', r'the whole map reaches ([\d.]+) descending \(`30:40A2`, controls ([\d.]+)-([\d.]+)\) and ([\d.]+) ascending \(`30:41D1`\), the `\$8800` order ([\d.]+) \(controls ([\d.]+)-([\d.]+)\)',
               lambda m: ((sv(wd_, 'best_cost'), round(sv(wd_, 'control_min'), 2), round(sv(wd_, 'control_max'), 2), sv(wa_, 'best_cost'), sv(wr_, 'best_cost'), round(sv(wr_, 'control_min'), 2), round(sv(wr_, 'control_max'), 2)),
                         tuple(float(m.group(i)) for i in range(1, 8))), docs=('README.md',), need=('README.md',))
        quoted('seam offsets', r'and 1bpp is at the level of its controls \(([\d.]+)-([\d.]+) against ([\d.]+)-([\d.]+)\)',
               lambda m: ((min(sv(('whole', '00-F5', o, '1'), 'best_cost') for o in ('asc', 'desc')), max(sv(('whole', '00-F5', o, '1'), 'best_cost') for o in ('asc', 'desc')),
                           min(sv(('whole', '00-F5', o, '1'), 'control_min') for o in ('asc', 'desc')), max(sv(('whole', '00-F5', o, '1'), 'control_max') for o in ('asc', 'desc'))),
                          tuple(float(m.group(i)) for i in range(1, 5))), docs=('README.md',), need=('README.md',))
    except KeyError as e:
        bad('seamoffsets', '%s lacks the variant %s' % (SO_FILE, e))

# ------------------------------------------------------------------ 26:7080 pattern of repeated ids against every map window (README 16.25.2)
PM_FILE = 'tcrf_check/assets/unidentified/map_26_7080_pattern_match.csv'
try:
    PM = list(csv.DictReader(io.StringIO(rd(PM_FILE))))
except Exception as e:
    PM = []; bad('patternmatch', '%s does not load: %s' % (PM_FILE, e))
if PM:
    pm = {(r['target'], r['search_rom'], r['strides']): r for r in PM}
    cp = [r for r in PM if r['counterpart_addr']]
    if any(float(r['counterpart_jaccard']) != 1.0 for r in cp) or any(float(r['best_other_jaccard']) >= 0.20 for r in PM):
        bad('patternmatch', '%s: a counterpart must score 1.000 and every other window stay below 0.20 (the README says no look-alike)' % PM_FILE)
    else: ok('patternmatch', '%d runs, counterparts %s at 1.000, best other window %.3f' % (len(PM), '/'.join(r['counterpart_addr'] for r in cp), max(float(r['best_other_jaccard']) for r in PM)))
    try:
        j7 = pm[('26:7080', 'JP', '32')]; j7p = pm[('26:7080', 'JP', '20/22/24')]; u7 = pm[('26:7080', 'INTL', '20/22/24')]; u7c = pm[('26:7080', 'INTL', '32')]; m_ = pm[('25:7820', 'INTL', '32')]; cr = pm[('26:72C0', 'INTL', '32')]
        quoted('pattern match', r'the best is ([\d.]+) in the Japanese ROM \(`23:44BF`, a flat fill; ([\d.]+) at the packed strides\) and ([\d.]+) in the international ROM \(`2F:642A` at stride 22\), apart from the map.s own counterpart `26:6E40` \(([\d.]+)\)',
               lambda m: ((float(j7['best_other_jaccard']), float(j7p['best_other_jaccard']), float(u7['best_other_jaccard']), float(u7c['counterpart_jaccard'])), tuple(float(m.group(i)) for i in (1, 2, 3, 4))), docs=('README.md',), need=('README.md',))
        quoted('pattern match', r'finds its counterpart `25:75E0` at ([\d.]+) and nothing else above ([\d.]+), the credits picture `26:72C0` has no copy in the international ROM \(best ([\d.]+)\)',
               lambda m: ((float(m_['counterpart_jaccard']), float(m_['best_other_jaccard']), float(cr['best_other_jaccard'])), tuple(float(m.group(i)) for i in (1, 2, 3))), docs=('README.md',), need=('README.md',))
        if m_['counterpart_addr'] != '25:75E0' or u7c['counterpart_addr'] != '26:6E40': bad('patternmatch', '%s: the counterparts must be 25:75E0 and 26:6E40' % PM_FILE)
    except KeyError as e:
        bad('patternmatch', '%s lacks the run %s' % (PM_FILE, e))

# ------------------------------------------------------------------ 26:7080 against the tiles of the hand-newspaper span 11:5800 (README 16.25.2)
if A.rom:
    sys.path.insert(0, P('tcrf_check/tools'))
    import map_vs_span_layouts as MVS
    hn_ids, (hn_dist, hn_blank, hn_ff), hn_c = MVS.costs(open(A.rom, 'rb').read(), 0x26, 0x7080, 0x11, 0x5800, 276, 25, 512, 0)
    hn_order = ['contiguous ascending', 'contiguous descending', 'slots ascending', 'slots descending']
    hn_v = [round(float(hn_c[k][0]), 2) for k in hn_order]
    if hn_dist >= hn_ids or min(hn_v) < 0.7: bad('handspan', 'the span 11:5800 has %d different tiles for %d different ids, best layout cost %.2f: the README says it cannot be the tile set' % (hn_dist, hn_ids, min(hn_v)))
    else: ok('handspan', '11:5800-693F: 276 tiles, %d blank, %d different (the map has %d different ids); layouts cost %s per pixel' % (hn_blank, hn_dist, hn_ids, '/'.join('%.2f' % v for v in hn_v)))
    quoted('hand span', r'the span holds 276 tiles of which (\d+) are blank and only (\d+) are different',
           lambda m: ((hn_blank, hn_dist), (int(m.group(1)), int(m.group(2)))), docs=('README.md',), need=('README.md',))
    quoted('hand span', r'cost ([\d.]+), ([\d.]+), ([\d.]+) and ([\d.]+) per pixel, against about 0\.4 for a true set',
           lambda m: (tuple(hn_v), tuple(float(m.group(i)) for i in range(1, 5))), docs=('README.md',), need=('README.md',))
    quoted('hand span', r'a de-duplicated picture of (\d+) different ids needs', lambda m: ((hn_ids,), (int(m.group(1)),)), docs=('README.md',), need=('README.md',))

# ------------------------------------------------------------------ the ball head animation is stored twice: two collars for two bodies (README 16.24)
if A.rom:
    sys.path.insert(0, P('tcrf_check/tools'))
    import head_sets as HS
    hs_rom = open(A.rom, 'rb').read()
    hs_d = HS.pair_diffs(hs_rom)
    hs_n = sorted({len(x) for x in hs_d})
    hs_inside = all(0x20 <= 0x10 + t <= 0x2F for x in hs_d for t in x)
    hs_a, hs_a_own = HS.vs_strip(hs_rom, 0x16, 0x5580)
    hs_b, hs_b_own = HS.vs_strip(hs_rom, 0x11, 0x4000)
    hs_fin = [HS.vs_strip(hs_rom, b_, a_) for n_, b_, a_ in HS.STRIPS[2:]]
    hs_fin_seams = [r[2] for res_, own_ in hs_fin for r in res_]; hs_fin_own = sorted({own_ for res_, own_ in hs_fin})
    sa5, sb5, sa4, sb4 = [r[2] for r in hs_a[:5]], [r[2] for r in hs_a[5:]], [r[2] for r in hs_b[:5]], [r[2] for r in hs_b[5:]]
    hs_fits = max(sa5) <= hs_a_own + 2 and min(sb5) >= 1.5 * hs_a_own and max(sb4) <= hs_b_own + 2 and min(sa4) >= 1.5 * hs_b_own
    if not hs_inside or not hs_fits or hs_a[4][1] != 8 or tuple(hs_b[9][:2]) != (8, 8) or hs_fin_own != [17] or min(hs_fin_seams) < 1.5 * 17:
        bad('headsets', 'the two sets of the head animation no longer read as two collars for two bodies: all differences inside $20-$2F %s, seams A/5580 %s own %d, B/4000 %s own %d, F4 row 7 %d of 8, F9 %s of 16' % (hs_inside, sa5, hs_a_own, sb4, hs_b_own, hs_a[4][1], hs_b[9][0] + hs_b[9][1]))
    else:
        ok('headsets', 'F0-F4 / F5-F9 differ in %s of the 16 tiles $20-$2F only; seams: A on 16:5580 %d-%d (own %d) vs B %d-%d, B on 11:4000 %d-%d (own %d) vs A %d-%d; final body 11:4500 / 4A00 own %s, frames %d-%d'
           % ('/'.join(map(str, hs_n)), min(sa5), max(sa5), hs_a_own, min(sb5), max(sb5), min(sb4), max(sb4), hs_b_own, min(sa4), max(sa4), hs_fin_own[0], min(hs_fin_seams), max(hs_fin_seams)))
    quoted('head sets', r'differ only inside the ids `\$20-\$2F` \((\d+) or (\d+) of those 16 tiles',
           lambda m: ((hs_n[0], hs_n[-1]), (int(m.group(1)), int(m.group(2)))), docs=('README.md',), need=('README.md',))
    quoted('head sets', r'costs (\d+)-(\d+) for the five frames of set A on `16:5580` \(the strip\'s own collar: (\d+)\) against (\d+)-(\d+) for set B, and (\d+)-(\d+) for set B on `11:4000` \(own collar: (\d+)\) against (\d+)-(\d+) for set A',
           lambda m: ((min(sa5), max(sa5), hs_a_own, min(sb5), max(sb5), min(sb4), max(sb4), hs_b_own, min(sa4), max(sa4)), tuple(int(m.group(i)) for i in range(1, 11))), docs=('README.md',), need=('README.md',))
    quoted('head sets', r'has a collar of its own \(seam (\d+)\) that fits neither set \((\d+)-(\d+)\)',
           lambda m: ((hs_fin_own[0], min(hs_fin_seams), max(hs_fin_seams)), tuple(int(m.group(i)) for i in range(1, 4))), docs=('README.md',), need=('README.md',))
    quoted('head sets', r'so ([\d,]+) B are stored twice and ([\d,]+) B of them are never read',
           lambda m: ((5 * 512, 4 * 512), tuple(int(m.group(i).replace(',', '')) for i in (1, 2))), docs=('README.md',), need=('README.md',))

# ------------------------------------------------------------------ nothing draws the OAM list $BA of the hand flipping a newspaper (README 16.24)
if A.rom:
    sys.path.insert(0, P('tcrf_check/tools'))
    import oam_list_use as OL
    ol_rom = open(A.rom, 'rb').read(); ol_ids = list(range(0xA6, 0xBC)); ol_s = OL.summary(ol_rom, ol_ids)
    ol_cov = P('coverage/v8/merged_v8/cov.npz'); ol_org = None
    if os.path.exists(ol_cov):
        import numpy as _np
        ol_org = OL.organic(_np.load(ol_cov), ol_rom, ol_ids)
    if ol_s['asked'] or (ol_org and ol_org[1]):
        bad('oamlist', 'a call of 00:24AF has a literal id %s in $A6-$BB, or an organic run reads one of those lists (%s): the README says nothing draws $BA' % (['%02X' % i for i in ol_s['asked']], ol_org))
    else:
        ok('oamlist', '%d calls of 00:24AF, none with a literal id $A6-$BB (the test finds %d sites for %d other ids, %d calls take the id from a table or RAM); %s' % (ol_s['calls'], ol_s['control_sites'], ol_s['control_ids'], ol_s['nolit'], ('organic reads of the 22 lists $A6-$BB: %d, lists unread in organic runs: %d of 249' % (ol_org[1], ol_org[0])) if ol_org else 'coverage file absent: organic part skipped'))
    quoted('oam list', r'none of the (\d+) calls of `00:24AF` has `ld a, \$A6` to `\$BB` within 12 bytes before it, the same test finds (\d+) sites for (\d+) other ids, and (\d+) of the (\d+) calls take the id',
           lambda m: ((ol_s['calls'], ol_s['control_sites'], ol_s['control_ids'], ol_s['nolit'], ol_s['calls']), tuple(int(m.group(i)) for i in range(1, 6))), docs=('README.md',), need=('README.md',))
    if ol_org:
        quoted('oam list', r'\((\d+) of the (\d+) lists are unread in organic runs\)', lambda m: ((ol_org[0], 249), (int(m.group(1)), int(m.group(2)))), docs=('README.md',), need=('README.md',))

# ------------------------------------------------------------------ the main menu turning its page, the whole screen (README 16.24)
SG = 'tcrf_check/assets/unidentified/main_menu_page_turn.gif'
try:
    from PIL import Image as _Im, ImageSequence as _Seq
    _g = _Im.open(P(SG)); sg_n = sum(1 for _ in _Seq.Iterator(_g)); _g.seek(0)
    sg_t = 0
    for _i in range(sg_n): _g.seek(_i); sg_t += _g.info.get('duration', 0)
    sg = (_g.size, sg_n, round(sg_t / 1000, 2), _g.info.get('loop'))
    if sg[0] != (640, 576) or sg[3] != 0: bad('screengif', '%s is %s, loop %s: expected 640 x 576 (160 x 144 at 4x) and an endless loop' % (SG, sg[0], sg[3]))
    else: ok('screengif', '%s: %d x %d, %d frames, %.2f s, loops' % (SG, sg[0][0], sg[0][1], sg[1], sg[2]))
    quoted('page turn gif', r'(\d+) game frames in (\d+) GIF frames, ([\d.]+) s',
           lambda m: ((sg[1], sg[2]), (int(m.group(2)), float(m.group(3)))), docs=('README.md',), need=('README.md',))
except Exception as e:
    bad('screengif', '%s does not load: %s' % (SG, e))

# ------------------------------------------------------------------ what STAT handler 1 splits (README 2, interrupt map)
SS = 'tcrf_check/assets/unidentified/stat_split_census.csv'
try:
    ss_rows = list(csv.DictReader(io.StringIO(rd(SS))))
    ss_on = [r for r in ss_rows if r['stat_irq'] == 'on']; ss_h1 = [r for r in ss_on if r['handler'] == '1']
    ss_test = [r for r in ss_h1 if r['px_split'] != '']; ss_ok = [r for r in ss_test if r['px_split'] == '0']
    ss_off1 = [r for r in ss_rows if r['stat_irq'] == 'off' and r['handler'] == '1']
    ss_px = [int(r['px_unsplit']) for r in ss_ok if int(r['px_unsplit']) > 0]
    ss_bad = sorted(r['screen'] for r in ss_test if r['px_split'] != '0')
    ss_rom = None
    if A.rom:
        ss_r = open(A.rom, 'rb').read()
        def _cnt(pat):
            n = 0; i = ss_r.find(pat)
            while i >= 0: n += 1; i = ss_r.find(pat, i + 1)
            return n
        ss_rom = (_cnt(bytes([0x21, 0xAC, 0xFF, 0xCB, 0xF6])), _cnt(bytes([0x21, 0xAC, 0xFF, 0xCB, 0xB6])), [_cnt(bytes([0x3E, v, 0xE0, 0xC5])) for v in range(1, 8)])
    ok('statsplit', '%d end screens: STAT interrupt on in %d, handler 1 in %d (%d tested, %d reproduced by the flip, unsplit error %d-%d px; not reproduced %s), %d more with FFC5 = 1 and the interrupt off%s'
       % (len(ss_rows), len(ss_on), len(ss_h1), len(ss_test), len(ss_ok), min(ss_px), max(ss_px), '/'.join(ss_bad), len(ss_off1), ('; ROM: %d sites turn it on, %d off, FFC5 := 1..7 at %s sites' % (ss_rom[0], ss_rom[1], '/'.join(map(str, ss_rom[2])))) if ss_rom else ''))
    quoted('stat split', r'In a BGB census of (\d+) end screens .{1,160}? the interrupt is on in (\d+), with handler 1 in (\d+) of those, and (\d+) more screens carry `FFC5 = 1` with the interrupt off',
           lambda m: ((len(ss_rows), len(ss_on), len(ss_h1), len(ss_off1)), tuple(int(m.group(i)) for i in range(1, 5))), docs=('README.md',), need=('README.md',))
    quoted('stat split', r'renders each of the (\d+) handler-1 screens without a window layer with and without the flip: (\d+) equal the BGB picture.*?and without the flip they differ by ([\d,]+)-([\d,]+) pixels',
           lambda m: ((len(ss_test), len(ss_ok), min(ss_px), max(ss_px)), (int(m.group(1)), int(m.group(2)), int(m.group(3).replace(',', '')), int(m.group(4).replace(',', '')))), docs=('README.md',), need=('README.md',))
    quoted('stat split', r'The (\d+) handler-1 screens with the window layer on', lambda m: ((len(ss_h1) - len(ss_test),), (int(m.group(1)),)), docs=('README.md',), need=('README.md',))
    if ss_rom:
        quoted('stat split', r'34 places of the ROM turn it on \(25 with `FFC5 := 1`, 4 with 2, one each with 3, 4, 5, 6 and 7\) and 59 turn it off',
               lambda m: ((ss_rom[0], ss_rom[1], tuple(ss_rom[2])), (34, 59, (25, 4, 1, 1, 1, 1, 1))), docs=('README.md',), need=('README.md',))
except Exception as e:
    bad('statsplit', '%s does not load or does not parse: %s' % (SS, e))

# ------------------------------------------------------------------ RAM runtime check (BGB, README 2.13)
PR_DIR = 'tcrf_check/assets/wram_probe/'
try:
    PR_W = list(csv.DictReader(io.StringIO(rd(PR_DIR + 'watch.csv'))))
    PR_N = list(csv.DictReader(io.StringIO(rd(PR_DIR + 'names.csv'))))
    PR_S = list(csv.DictReader(io.StringIO(rd(PR_DIR + 'sites.csv'))))
except Exception as e:
    PR_W = PR_N = PR_S = []; bad('ram', 'the probe tables of %s do not load: %s' % (PR_DIR, e))
if PR_N:
    pr_bad = 0
    ramrow = {r.name: r for r in RAM_ROWS}
    for r in PR_N:
        x = ramrow.get(r['name'])
        if x is None: bad('ram', '%snames.csv: %s is not a name of ram_names_jp.csv' % (PR_DIR, r['name'])); pr_bad += 1; continue
        if x.tag != r['tag']: bad('ram', '%snames.csv: %s has tag %s, ram_names_jp.csv says %s' % (PR_DIR, r['name'], r['tag'], x.tag)); pr_bad += 1
        if x.addr != int(r['addr'], 16) or int(r['size']) != x.size: bad('ram', '%snames.csv: %s is at $%s size %s, ram_names_jp.csv says $%04X size %d' % (PR_DIR, r['name'], r['addr'], r['size'], x.addr, x.size)); pr_bad += 1
    for s in PR_S:
        if s['name'] not in ramrow: bad('ram', '%ssites.csv: %s is not a name of ram_names_jp.csv' % (PR_DIR, s['name'])); pr_bad += 1; break
    pr_wt = collections.Counter(r['tag'] for r in PR_W)
    pr_sc = collections.Counter(r['class'] for r in PR_S)
    pr_mv = collections.Counter((r['tag_before'], r['tag']) for r in PR_N)
    pr_to_c = {k: sum(v for (b, a), v in pr_mv.items() if a == 'C' and b == k) for k in 'I?U'}
    pr_to_u = {k: sum(v for (b, a), v in pr_mv.items() if a == 'U' and b == k and b != a) for k in 'I?'}
    if not pr_bad:
        ok('ram', 'the BGB probe: %d watched ranges (I %d / U %d / ? %d), %d names with tag before and after (%d to C, %d to U, %d stay I, %d stay U), %d sites that fired, tags equal ram_names_jp.csv' % (
            len(PR_W), pr_wt['I'], pr_wt['U'], pr_wt['?'], len(PR_N), sum(pr_to_c.values()), sum(pr_to_u.values()), pr_mv[('I', 'I')], pr_mv[('U', 'U')], len(PR_S)))
    quoted('probe watch', r'\((\d+) `I`, (\d+) `U` and (\d+) `\?`: (\d+) ranges', lambda m: ((pr_wt['I'], pr_wt['U'], pr_wt['?'], len(PR_W)), tuple(num(g) for g in m.groups())), docs=('README.md',), need=('README.md',))
    quoted('probe sites', r'has the ([\d,]+) instruction sites that fired \(S (\d+) / ptr (\d+) / init (\d+) / dyn (\d+) / other (\d+)\)', lambda m: ((len(PR_S), pr_sc['S'], pr_sc['ptr'], pr_sc['init'], pr_sc['dyn'], pr_sc['other']), tuple(num(g) for g in m.groups())), docs=('README.md',), need=('README.md',))
    quoted('probe names', r'names\.csv` \((\d+) rows', lambda m: ((len(PR_N),), (num(m.group(1)),)), docs=('README.md',), need=('README.md',))
    quoted('probe moves', r'(\d+) became `C` \((\d+) `I`, (\d+) `\?`, (\d+) `U`\), (\d+) became `U` \((\d+) `I`, (\d+) `\?`\), (\d+) stay `I` and (\d+) stay `U`',
           lambda m: ((sum(pr_to_c.values()), pr_to_c['I'], pr_to_c['?'], pr_to_c['U'], sum(pr_to_u.values()), pr_to_u['I'], pr_to_u['?'], pr_mv[('I', 'I')], pr_mv[('U', 'U')]), tuple(num(g) for g in m.groups())), docs=('README.md',), need=('README.md',))

# ------------------------------------------------------------------ constants (L4, README 2.14)
import const_names as CN
CN_BAD = 0
try:
    C_ROWS = CN.load_names(P('roms/jp_rev_a/disasm/const_names_jp.csv')); C_TYPES = CN.load_types(P('roms/jp_rev_a/disasm/const_types_jp.csv')); C_TABS = CN.load_tables(P('roms/jp_rev_a/disasm/const_tables_jp.csv'))
    S_ROWS = CN.load_sounds(P('roms/jp_rev_a/disasm/sound_names_jp.csv')); ST_ROWS = CN.load_states(P('roms/jp_rev_a/disasm/state_names_jp.csv')); CN.check_unique(C_ROWS + ST_ROWS + S_ROWS)
except Exception as e:
    C_ROWS = []; S_ROWS = []; ST_ROWS = []; C_TYPES = {}; C_TABS = []; bad('const', 'the constant tables do not load: %s' % e); CN_BAD += 1
CNAMER = CN.Namer(C_ROWS + ST_ROWS + S_ROWS)
# state constants (README 2.14): roms/jp_rev_a/disasm/state_names_jp.csv must be what tools/state_names.py makes from the state tables and the handler labels
if A.rom:
    r = subprocess.run([sys.executable, 'tools/state_names.py', '--rom', A.rom, '--check'], capture_output=True, text=True)
    if r.returncode: bad('const', 'roms/jp_rev_a/disasm/state_names_jp.csv is stale: run tools/state_names.py --rom ROM'); CN_BAD += 1
# text table (README 16.27): roms/jp_rev_a/disasm/charmap_jp.inc must be what tools/charmap_jp.py makes from roms/jp_rev_a/disasm/charset_jp.csv
r = subprocess.run([sys.executable, 'tools/charmap_jp.py', '--check'], capture_output=True, text=True)
if r.returncode: bad('const', 'roms/jp_rev_a/disasm/charmap_jp.inc is stale: run tools/charmap_jp.py'); CN_BAD += 1
for r in ST_ROWS:
    if r.name in NAMESET or r.name in {x.name for x in RAM_ROWS}: bad('const', '%s is also a ROM label or a RAM name' % r.name); CN_BAD += 1
ST_TAGS = collections.Counter(r.tag for r in ST_ROWS)
C_TAGS = collections.Counter(r.tag for r in C_ROWS)
RAM_IDS = {r.name for r in RAM_ROWS}
def snake(x): return re.sub(r'(?<=[a-z0-9])(?=[A-Z])', '_', x).upper()
CROM = open(A.rom, 'rb').read() if A.rom else None
LABEL_AT = {(int(r['bank'], 16), int(r['addr'], 16)): r['name'] for r in NAMES}
C_MODES = {r.value: r for r in C_ROWS if r.group == 'mode'}
for r in C_ROWS:
    if not re.fullmatch(r'[A-Z][A-Z0-9_]*', r.name): bad('const', '%s: a constant is written in capitals' % r.name); CN_BAD += 1
    if r.name in NAMESET or r.name in RAM_IDS: bad('const', '%s is also a ROM label or a RAM name' % r.name); CN_BAD += 1
    if r.tag not in ('C', 'I'): bad('const', '%s: unknown tag %r' % (r.name, r.tag)); CN_BAD += 1
    if r.group not in ('mode', 'sndch'): bad('const', '%s: group %s has no name table (the flag groups use the names of hardware.inc, the sound ids are in sound_names_jp.csv)' % (r.name, r.group)); CN_BAD += 1
if set(C_MODES) != set(range(0x22)) | {0x22, 0xFF} or C_MODES[0x22].name != 'MODE_COUNT' or C_MODES[0xFF].name != 'MODE_NONE':
    bad('const', 'the mode group must name $00-$21 and MODE_COUNT ($22), MODE_NONE ($FF)'); CN_BAD += 1
else:
    for m in range(0x22):    # the name of a mode is the name of its entry label in the mode table 00:2F3F
        if CROM:
            o = 0x2F3F + 3 * m; entry = LABEL_AT.get((CROM[o + 2], CROM[o] | CROM[o + 1] << 8))
        else: entry = next((n for n in NAMESET if re.fullmatch('Mode%02X_\\w+' % m, n) and 'MODE_' + snake(n[7:]) == C_MODES[m].name), None)
        if not entry or not re.fullmatch('Mode%02X_\\w+' % m, entry) or 'MODE_' + snake(entry[7:]) != C_MODES[m].name:
            bad('const', 'mode $%02X is %s, but its entry label is %s (the constant is the label without its number, in capitals)' % (m, C_MODES[m].name, entry)); CN_BAD += 1
C_HW = {'rLCDC', 'rIE', 'rSC', 'rP1'}
C_GROUPS = {'mode', 'sndch'} | set(CN.FLAGS) | set(CN.EXACT) | set(CN.SOUND_GROUPS)
C_CALLS = {'Snd_Sfx1': 'sfx1', 'Snd_Sfx3': 'sfx3', 'Snd_Sfx4': 'sfx4', 'Snd_Music': 'music'}       # routines whose A is typed: the id spaces are told apart by the call target
for v, g in C_TYPES.items():
    if v in C_CALLS:
        if C_CALLS[v] != g or v not in NAMESET: bad('const', 'const_types_jp.csv: %s must be the ROM routine that takes a %s id in A' % (v, C_CALLS[v])); CN_BAD += 1
    elif v not in RAM_IDS and v not in C_HW: bad('const', 'const_types_jp.csv: %s is neither a RAM name, a request routine nor one of %s' % (v, sorted(C_HW))); CN_BAD += 1
    if g not in C_GROUPS: bad('const', 'const_types_jp.csv: %s has the unknown group %s' % (v, g)); CN_BAD += 1
BLK = {(t[0], t[1]): t for t in TYPES}
C_MODE_BYTES = 0; C_SND_BYTES = 0
for t in C_TABS:
    key = (t['bank'], t['addr']); bl = BLK.get(key)
    if not bl or bl[3] != 'data' or bl[2] - bl[1] != t['len']: bad('const', 'const_tables_jp.csv %02X:%04X: no data block of %d bytes starts there in sym_types_jp.csv' % (key + (t['len'],))); CN_BAD += 1; continue
    if key not in LABEL_AT: bad('const', 'const_tables_jp.csv %02X:%04X: the table has no label' % key); CN_BAD += 1
    if t['layout'] == 'KC' and t['group'] == 'sound' and t['len'] % 2 == 0:       # an (id, channel) list of Snd_PlayFromList: every channel byte is 1-4
        C_SND_BYTES += t['len']
        if CROM:
            o0 = t['addr'] if t['bank'] == 0 else t['bank'] * 0x4000 + t['addr'] - 0x4000
            for i in range(0, t['len'], 2):
                if CROM[o0 + i + 1] not in CN.SNDCH_GROUP: bad('const', 'const_tables_jp.csv %02X:%04X entry %d: channel byte $%02X is not 1-4' % (key + (i // 2 + 1, CROM[o0 + i + 1]))); CN_BAD += 1
        continue
    if not t['layout'] or set(t['layout']) - set('MS') or t['len'] % len(t['layout']) or t['group'] != 'mode': bad('const', 'const_tables_jp.csv %02X:%04X: layout %r / group %r / length %d do not fit' % (key + (t['layout'], t['group'], t['len']))); CN_BAD += 1; continue
    for i in range(t['len']):
        if t['layout'][i % len(t['layout'])] != 'M': continue
        C_MODE_BYTES += 1
        if CROM:
            ad = t['addr'] + i; v = CROM[ad if t['bank'] == 0 else t['bank'] * 0x4000 + ad - 0x4000]
            if CNAMER.value(t['group'], v) is None: bad('const', 'const_tables_jp.csv %02X:%04X byte %d = $%02X is not a mode' % (key + (i, v))); CN_BAD += 1
if not os.path.exists(P('roms/jp_rev_a/disasm/const_jp.inc')) or open(P('roms/jp_rev_a/disasm/const_jp.inc'), encoding='utf-8', newline='').read() != CN.inc_text(C_ROWS + ST_ROWS + S_ROWS):
    bad('const', 'roms/jp_rev_a/disasm/const_jp.inc is not what tools/const_names.py writes from roms/jp_rev_a/disasm/const_names_jp.csv, state_names_jp.csv and sound_names_jp.csv (run it)'); CN_BAD += 1
C_TYPED_VARS = sum(1 for v in C_TYPES if v not in C_CALLS)
if not CN_BAD:
    ok('const', '%d names (C %d, I %d; %d modes, %d sound channels) + %d sound names, %d typed operands and %d typed call targets, %d tables (%d mode bytes, %d sound-list bytes); const_jp.inc is fresh' % (len(C_ROWS), C_TAGS['C'], C_TAGS['I'], len(C_MODES) - 2, 4, len(S_ROWS), C_TYPED_VARS, len(C_CALLS), len(C_TABS), C_MODE_BYTES, C_SND_BYTES))
    quoted('state rows', r'state_names_jp\.csv` names ([\d,]+) states of ([\d,]+) modes \(C ([\d,]+) / I ([\d,]+)\)', lambda m: ((len(ST_ROWS), len({r.group for r in ST_ROWS}), ST_TAGS['C'], ST_TAGS['I']), tuple(num(g) for g in m.groups())), docs=('README.md',), need=('README.md',))
    quoted('const rows', r'const_names_jp\.csv` has ([\d,]+) constants \(C ([\d,]+) / I ([\d,]+)\)', lambda m: ((len(C_ROWS), C_TAGS['C'], C_TAGS['I']), tuple(num(g) for g in m.groups())), docs=('README.md',), need=('README.md',))
    quoted('const types', r'const_types_jp\.csv` types ([\d,]+) operands and ([\d,]+) call targets', lambda m: ((C_TYPED_VARS, len(C_CALLS)), (num(m.group(1)), num(m.group(2)))), docs=('README.md',), need=('README.md',))
    quoted('const tables', r'const_tables_jp\.csv` lists ([\d,]+) byte tables \(([\d,]+) mode bytes and ([\d,]+) bytes of sound lists\)', lambda m: ((len(C_TABS), C_MODE_BYTES, C_SND_BYTES), tuple(num(g) for g in m.groups())), docs=('README.md',), need=('README.md',))

# ------------------------------------------------------------------ sound names (L4, README 2.14 and 16.24)
SND_BAD = 0
SND_ROWS = list(csv.DictReader(io.StringIO(rd('roms/jp_rev_a/disasm/sound_names_jp.csv'))))
SND_INV = {(r['channel'], r['id'].upper()): r for r in csv.DictReader(io.StringIO(rd('tcrf_check/assets/unidentified/sound_inventory.csv')))}
SND_UNUSED = {(r['channel'], r['id'].upper()) for r in csv.DictReader(io.StringIO(rd('tcrf_check/assets/unidentified/really_unused_sounds.csv')))}
SND_OWNER = {r['key'] for r in csv.DictReader(io.StringIO(rd('roms/jp_rev_a/disasm/owner_answers_jp.csv')))}
SND_PREFIX = {'music': 'MUSIC_', 'sfx1': 'SFX1_', 'sfx3': 'SFX3_', 'sfx4': 'SFX4_'}
SND_CONTROL = {('music', 'FE'), ('music', 'FF')}              # requests of the song mailbox that are engine commands, not songs
SND_HELPER = {0x2A7C: 'sfx1', 0x2A80: 'sfx3', 0x2A84: 'sfx4', 0x2A88: 'music'}      # Snd_Sfx1 / Snd_Sfx3 / Snd_Sfx4 / Snd_Music (00:2A7C ...)
SND_MAILBOX = {0xDD60: 'sfx1', 0xDD68: 'music', 0xDD70: 'sfx3', 0xDD78: 'sfx4'}     # the request mailboxes the engine posts its follow-up effects into
SND_SITES = collections.defaultdict(list)
if CROM:                                    # every `ld a, id` right before a call of a request routine (also `call nz, ...`) or before a store into a mailbox
    for o in range(len(CROM) - 5):
        if CROM[o] != 0x3E: continue
        op = CROM[o + 2]; w = CROM[o + 3] | CROM[o + 4] << 8
        if op in (0xCD, 0xC4, 0xCC, 0xD4, 0xDC) and w in SND_HELPER: ch = SND_HELPER[w]
        elif op == 0xEA and w in SND_MAILBOX: ch = SND_MAILBOX[w]
        else: continue
        at = o + 2; bk = at // 0x4000
        SND_SITES[(ch, '%02X' % CROM[o + 1])].append((bk, at % 0x4000 + (0x4000 if bk else 0)))
keys = [(r['channel'], r['id'].upper()) for r in SND_ROWS]
if len(set(keys)) != len(keys) or set(keys) != set(SND_INV) | SND_CONTROL:
    bad('sound', 'sound_names_jp.csv must have one row for each of the %d ids of sound_inventory.csv and the two control requests (%s)' % (len(SND_INV), sorted(set(keys) ^ (set(SND_INV) | SND_CONTROL))[:6])); SND_BAD += 1
SND_NAMED = [r for r in SND_ROWS if r['name']]
for r in SND_ROWS:
    k = (r['channel'], r['id'].upper()); tag = k[0] + ' ' + k[1]
    if r['tag'] not in ('C', 'I', '?') or bool(r['name']) != (r['tag'] != '?'): bad('sound', '%s: tag %r does not fit the name %r (a row without a name has the tag ?)' % (tag, r['tag'], r['name'])); SND_BAD += 1
    if r['name']:
        if not re.fullmatch(SND_PREFIX.get(r['channel'], '@') + r'[A-Z0-9_]+', r['name']): bad('sound', '%s: name %s must be capitals and start with %s' % (tag, r['name'], SND_PREFIX.get(r['channel']))); SND_BAD += 1
        if r['name'] in NAMESET or r['name'] in RAM_IDS or r['name'] in {c.name for c in C_ROWS}: bad('sound', '%s is also a ROM label, a RAM name or another constant' % r['name']); SND_BAD += 1
    elif not r['desc'].startswith('no name') or k not in SND_UNUSED:
        bad('sound', '%s: a row without a name must say "no name" and be one of the ids that no organic run requested (really_unused_sounds.csv)' % tag); SND_BAD += 1
    if not CROM: continue
    ss = sorted(SND_SITES.get(k, []))
    if int(r['sites']) != len(ss): bad('sound', '%s: sites = %s, the ROM has %d (an `ld a, id` before a call of a request routine, or before a store into a mailbox)' % (tag, r['sites'], len(ss))); SND_BAD += 1
    cited = []
    for e in r['evidence'].split():
        m = re.fullmatch(r'([0-9A-F]{2}):([0-9A-F]{4})', e)
        if m: cited.append((int(m.group(1), 16), int(m.group(2), 16))); continue
        m = re.fullmatch(r'list:([0-9A-F]{2}):([0-9A-F]{4})#(\d+)', e)
        if m:
            bk, ad, n = int(m.group(1), 16), int(m.group(2), 16), int(m.group(3)); o = (ad if bk == 0 else bk * 0x4000 + ad - 0x4000) + 2 * (n - 1)
            if CROM[o] != int(r['id'], 16) or CN.SNDCH_GROUP.get(CROM[o + 1]) != r['channel']: bad('sound', '%s: %s does not hold this id at entry %d' % (tag, e[5:].split('#')[0], n)); SND_BAD += 1
            continue
        if e.startswith('same:'):
            if e[5:] not in (SND_INV.get(k, {}).get('same_as') or '').split(): bad('sound', '%s: %s, but sound_inventory.csv does not list it as the same data' % (tag, e)); SND_BAD += 1
            continue
        if e.startswith('owner:'):
            if e[6:] not in SND_OWNER: bad('sound', '%s: %s is not a row of owner_answers_jp.csv' % (tag, e)); SND_BAD += 1
            continue
        bad('sound', '%s: unknown evidence token %r' % (tag, e)); SND_BAD += 1
    if cited != ss[:5]: bad('sound', '%s: the evidence cites %s, the first request sites in the ROM are %s' % (tag, ['%02X:%04X' % c for c in cited], ['%02X:%04X' % c for c in ss[:5]])); SND_BAD += 1
SND_ID = [r for r in SND_NAMED if (r['channel'], r['id'].upper()) not in SND_CONTROL]
SND_TAGS = collections.Counter(r['tag'] for r in SND_ID)
if not SND_BAD:
    ok('sound', '%d of %d ids named (C %d / I %d) and %d control requests; %d unnamed; %d request sites checked against the ROM' % (len(SND_ID), len(SND_INV), SND_TAGS['C'], SND_TAGS['I'], len(SND_NAMED) - len(SND_ID), len(SND_INV) - len(SND_ID), sum(len(v) for v in SND_SITES.values())))
    quoted('sound names', r'sound_names_jp\.csv` names ([\d,]+) of ([\d,]+) sound ids \(C ([\d,]+) / I ([\d,]+)\) and ([\d,]+) control requests', lambda m: ((len(SND_ID), len(SND_INV), SND_TAGS['C'], SND_TAGS['I'], len(SND_NAMED) - len(SND_ID)), tuple(num(g) for g in m.groups())), docs=('README.md',), need=('README.md',))

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
        shutil.copy(A.rom, rom); shutil.copy(P('roms/jp_rev_a/pocketcamera_jp.sym'), os.path.join(tmp, 'in', 'pocketcamera_jp.sym'))
        env = dict(os.environ); env['PATH'] = A.rgbds + ':' + env['PATH']
        want = 'fdcfe686cf4df461e870b6e53b2b5a8b'
        subprocess.run([sys.executable, A.mgbdis, rom, '--output-dir', os.path.join(tmp, 'hex'), '--overwrite', '--print-hex'], capture_output=True, text=True)    # sym_fix.py reads the `; $ADDR: $xx` comments
        for variant in ('plain', 'fixed', 'ram', 'const'):
            d = os.path.join(tmp, variant)
            if variant == 'plain':
                subprocess.run([sys.executable, A.mgbdis, rom, '--output-dir', d, '--overwrite'], capture_output=True, text=True)
                # mgbdis' own labels left in the listing (README 1.1: L5 row): `jr_` targets are normal, a `Jump_` / `Call_` one is a jump / call target that still has no name
                lab = collections.Counter()
                for f in sorted(os.listdir(d)):
                    if re.match(r'bank_[0-9a-f]+\.asm$', f):
                        for line in open(os.path.join(d, f), encoding='utf-8'):
                            m = re.match(r'^(jr|Jump|Call)_[0-9a-f]{3}_[0-9a-f]{4}::?\s*$', line)
                            if m: lab[m.group(1)] += 1
                ok('roundtrip', 'plain listing: %s `jr_` labels, %d `Jump_`, %d `Call_` (mgbdis\' own)' % (fmt(lab['jr']), lab['Jump'], lab['Call']))
                quoted('auto labels', r"([\d,]+) `jr_` local labels are mgbdis' own \(normal for a disassembly\), (\d+) `Jump_` labels left and (\d+) `Call_`",
                       lambda m: ((lab['jr'], lab['Jump'], lab['Call']), (num(m.group(1)), num(m.group(2)), num(m.group(3)))), docs=('README.md',), need=('README.md',))
            elif variant == 'fixed':
                shutil.copytree(os.path.join(tmp, 'hex'), d); [os.remove(os.path.join(d, f)) for f in os.listdir(d) if f.endswith('.o') or f == 'game.gb']
                subprocess.run([sys.executable, 'tools/sym_fix.py', d, '--tables', '--rom', A.rom, '--sym', 'roms/jp_rev_a/pocketcamera_jp.sym', '--trace', 'roms/jp_rev_a/wram/trace_jp_v3.json'], capture_output=True, text=True)
            else:
                shutil.copytree(os.path.join(tmp, 'hex'), d); [os.remove(os.path.join(d, f)) for f in os.listdir(d) if f.endswith('.o') or f == 'game.gb']
                sf = subprocess.run([sys.executable, 'tools/sym_fix.py', d, '--tables', '--const' if variant == 'const' else '--ram', '--rom', A.rom, '--sym', 'roms/jp_rev_a/pocketcamera_jp.sym', '--trace', 'roms/jp_rev_a/wram/trace_jp_v3.json'], capture_output=True, text=True)
                st = {k: int(v) for k, v in re.findall(r'(\w+)=(\d+)', sf.stdout.split('sym_fix:')[-1])}
                if variant == 'const':
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
                if len(left) != nex or st.get('ram_unnamed') or st.get('ram_unproven') or st.get('ram_no_token'): bad('roundtrip', '%s listing: %d raw RAM operands left (the %d exclusions are the only ones allowed), stats %s' % (variant, len(left), nex, st))
                elif variant == 'ram': ok('roundtrip', 'ram: %s instructions use a RAM name (%s absolute, %s ldh, %s address loads, %s rIE), %d raw numbers left (the exclusions)' % (fmt(tot), fmt(named['abs']), fmt(named['ldh']), fmt(named['ptr']), fmt(named['ie']), len(left)))
                if variant == 'const':
                    # a number stored into a typed operand, or compared right after loading one, must have become a constant
                    raw = []
                    for f in sorted(os.listdir(d)):
                        if not re.match(r'bank_[0-9a-f]+\.asm$', f): continue
                        prev = None
                        for line in open(os.path.join(d, f), encoding='utf-8'):
                            t = line.split(';')[0].strip()
                            if not t: continue
                            if not line[0].isspace() or t.startswith(('db ', 'dw ', 'ds ')): prev = None; continue       # a label or data line ends the straight line
                            m = re.match(r'^(?:ld|ldh) \[(\w+)\], a$', t) or re.match(r'^call (?:(?:nz|z|c|nc), )?(\w+)$', t)         # a store into a typed operand, or a call of a request routine
                            if m and m.group(1) in C_TYPES and prev and re.match(r'^ld a, \$[0-9a-f]{2}$', prev) and CNAMER.value(C_TYPES[m.group(1)], int(prev[-2:], 16)): raw.append((f, prev, t))
                            prev = t
                    groups = {g: st.get('const_' + g, 0) for g in ('mode', 'pad', 'lcdc', 'sc', 'p1', 'ie', 'music', 'sfx1', 'sfx3', 'sfx4')}
                    if raw or st.get('const_table_unnamed'): bad('roundtrip', 'const listing: %d typed stores keep a number (%s), %d table bytes unnamed' % (len(raw), raw[:3], st.get('const_table_unnamed', 0)))
                    else: ok('roundtrip', 'const: %s operands read as constants (%s), %d mode table bytes, %d sound list bytes (%d without a name)' % (fmt(sum(groups.values())), ', '.join('%s %d' % kv for kv in groups.items()), st.get('const_table', 0), st.get('const_sound_table', 0), st.get('const_sound_unnamed', 0)))
                    ok('roundtrip', 'const: %d state stores and %d {mode, state} table bytes written as STATE_*, %d constant state stores left as numbers' % (st.get('const_state', 0), st.get('const_state_table', 0), st.get('const_state_unnamed', 0)))
                    quoted('state operands', r'([\d,]+) constant stores of `wState` and ([\d,]+) state bytes of the \{mode, state\} tables read as `STATE_\*`; ([\d,]+) constant stores keep their number',
                           lambda m: ((st.get('const_state', 0), st.get('const_state_table', 0), st.get('const_state_unnamed', 0)), tuple(num(g) for g in m.groups())), docs=('README.md',), need=('README.md',))
                    quoted('const operands', r'([\d,]+) operands read as constants \(([\d,]+) mode, ([\d,]+) key mask, ([\d,]+) LCDC, ([\d,]+) serial control, ([\d,]+) joypad select, ([\d,]+) interrupt enable, ([\d,]+) song id, ([\d,]+) channel-1 effect id, ([\d,]+) channel-3 effect id, ([\d,]+) channel-4 effect id\), ([\d,]+) bytes of mode tables and ([\d,]+) bytes of sound lists',
                           lambda m: ((sum(groups.values()), groups['mode'], groups['pad'], groups['lcdc'], groups['sc'], groups['p1'], groups['ie'], groups['music'], groups['sfx1'], groups['sfx3'], groups['sfx4'], st.get('const_table', 0), st.get('const_sound_table', 0)), tuple(num(g) for g in m.groups())), docs=('README.md',), need=('README.md',))
                if variant == 'ram': quoted('ram operands', r'([\d,]+) instructions use a RAM name \(([\d,]+) absolute loads and stores, ([\d,]+) `ldh`, ([\d,]+) address loads, ([\d,]+) `ld hl, rIE`\)', lambda m: ((tot, named['abs'], named['ldh'], named['ptr'], named['ie']), tuple(num(g) for g in m.groups())), docs=('README.md',), need=('README.md',))
            subprocess.run(['make'], cwd=d, env=env, capture_output=True, text=True)
            import hashlib
            g = os.path.join(d, 'game.gb'); h = hashlib.md5(open(g, 'rb').read()).hexdigest() if os.path.exists(g) else None
            if h != want: bad('roundtrip', '%s round trip gives md5 %s, expected %s' % (variant, h, want))
            else: ok('roundtrip', '%s: md5 %s' % (variant, h))
        # L5: roms/jp_rev_a/src/ is what tools/make_source.py writes today, and it builds the ROM byte-exact (PNG -> 2bpp, rgbasm, rgblink, rgbfix)
        sys.path.insert(0, P('tools')); import make_source
        fresh = os.path.join(tmp, 'src')
        ms = subprocess.run([sys.executable, 'tools/make_source.py', '--rom', A.rom, '--mgbdis', A.mgbdis, '--rgbds', A.rgbds, '--out', fresh, '--report', os.path.join(tmp, 'rom_operands_jp.csv')], capture_output=True, text=True)
        if ms.returncode: bad('source', 'tools/make_source.py failed: %s' % (ms.stderr or ms.stdout)[-300:])
        else:
            m = re.search(r'(\d+) banks, (\d+) INCBIN files \((\d+) bytes, (\d+) tile blocks as PNG\), (\d+) label notes, (\d+) far pointers as labels \((\d+) left', ms.stdout)
            src = P('roms/jp_rev_a/src'); diff = []
            def walk(r): return sorted(os.path.relpath(os.path.join(dp, f), r) for dp, _, fs in os.walk(r) for f in fs)
            if not os.path.isdir(src): diff = ['src/ missing']
            else:
                a_, b_ = walk(fresh), walk(src)
                diff = sorted(set(a_) ^ set(b_)) + [f for f in a_ if f in set(b_) and open(os.path.join(fresh, f), 'rb').read() != open(os.path.join(src, f), 'rb').read()]
            if diff: bad('source', 'roms/jp_rev_a/src/ is not what tools/make_source.py writes (%d files differ: %s); run `make source ROM=...`' % (len(diff), diff[:4]))
            else:
                hsrc = make_source.build(src, os.path.join(tmp, 'src_build.gb'), A.rgbds)
                if hsrc != want: bad('source', 'roms/jp_rev_a/src/ builds md5 %s, expected %s' % (hsrc, want))
                else: ok('source', 'roms/jp_rev_a/src/ fresh (%d files) and builds md5 %s: %s banks, %s INCBIN files (%s bytes, %s tile PNGs), %s label notes, %s far pointers as labels (%s left as numbers)' % ((len(walk(src)), hsrc) + m.groups()))
                mo = re.search(r'ROM operands: (\d+) pointers as labels \((\d+) table words, (\d+) wrong-bank labels corrected\), (\d+) numbers \((\d+) listing labels back to numbers\), (\d+) undecided, (\d+) record words \((\d+) with their bank,[^)]*\), (\d+) labels added at code targets, (\d+) page-aligned tables', ms.stdout)
                if not mo: bad('source', 'tools/make_source.py did not report the ROM operands')
                elif open(os.path.join(tmp, 'rom_operands_jp.csv'), 'rb').read() != open(P('roms/jp_rev_a/disasm/rom_operands_jp.csv'), 'rb').read():
                    bad('source', 'roms/jp_rev_a/disasm/rom_operands_jp.csv is not what tools/rom_operands.py writes; run `make source ROM=...`')
                else:
                    ok('source', 'ROM addresses in the code: %s pointers as labels (%s table words, %s wrong-bank labels corrected), %s numbers (%s listing labels back to numbers), %s undecided, %s record words (%s with their bank), %s labels at code targets, %s page-aligned tables; rom_operands_jp.csv fresh' % mo.groups())
                    quoted('source operands', r'([\d,]+) pointers written as labels \(([\d,]+) of them table words\), ([\d,]+) numbers and ([\d,]+) undecided; ([\d,]+) pointer words inside data records \(([\d,]+) of them with their bank byte\), ([\d,]+) labels added at code targets and ([\d,]+) page-aligned tables',
                           lambda mm: (tuple(int(mo.group(k)) for k in (1, 2, 4, 6, 7, 8, 9, 10)), tuple(num(g) for g in mm.groups())), docs=('README.md',), need=('README.md',))
                mc = re.search(r'macros: farcopy (\d+), farcall (\d+), dwb (\d+), set_state (\d+), next_state (\d+), play_\* (\d+), ui_sfx (\d+), screen_off (\d+), stat_irq_off (\d+), screen_on (\d+), REPT (\d+) \((\d+) lines\)', ms.stdout)
                ok('source', 'macros: farcopy %s, farcall %s, dwb %s, set_state %s, next_state %s, play_* %s, ui_sfx %s, screen_off %s, stat_irq_off %s, screen_on %s, REPT %s (%s lines)' % mc.groups())
                quoted('source macros', r'`farcopy` \(([\d,]+)\), `farcall` \(([\d,]+)\), `dwb` \(([\d,]+)\), `set_state` \(([\d,]+)\), `next_state` \(([\d,]+)\), `play_sfx1` / `play_sfx3` / `play_sfx4` / `play_music` \(([\d,]+)\), `ui_sfx` \(([\d,]+)\), `screen_off` \(([\d,]+)\), `stat_irq_off` \(([\d,]+)\) and `screen_on` \(([\d,]+)\); ([\d,]+) unrolled copies are `REPT` blocks \(([\d,]+) lines\)',
                       lambda mm: (tuple(int(g) for g in mc.groups()), tuple(num(g) for g in mm.groups())), docs=('README.md',), need=('README.md',))
                quoted('source stats', r'(\d+) bank files, ([\d,]+) `INCBIN` files \(([\d,]+) bytes; ([\d,]+) tile blocks as PNG\), ([\d,]+) label notes, ([\d,]+) far pointers written as labels \((\d+) left as numbers\)',
                       lambda mm: (tuple(int(g) for g in m.groups()), tuple(num(g) for g in mm.groups())), docs=('README.md',), need=('README.md',))
        shutil.rmtree(tmp, ignore_errors=True)

print()
print('%d failed, %d warnings, %d skipped' % (len(FAIL), len(WARN), len(SKIP)))
sys.exit(1 if FAIL else 0)
