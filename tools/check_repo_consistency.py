#!/usr/bin/env python3
"""Repository consistency check: the numbers and names that several files repeat must agree, and the generated files must be fresh.

usage: tools/check_repo_consistency.py [--rom pocketcamera_jp.gb] [--roundtrip] [--mgbdis /path/to/mgbdis.py] [--rgbds /path/to/rgbds] [-q]
  run it from anywhere; it works on the repository that holds it.  Exit status 1 when a check fails (warnings do not fail).
  Without --rom the checks that need the ROM (sym freshness, byte types, yellow bytes, md5 round trip) are skipped and said so.

What it checks (each line of the report is one check)
  names      sym_names_jp.csv: tags C / I / ?, duplicate names, a name that carries another address than its own (only `_Part<addr>` / `_Cont` may),
             a `Map_*` label on a `Gfx` type row (and `Gfx_*` on a `Map` row; the type rows are applied in order, the last row wins, as in sym_build.py)
  maps       the layout maps of the Gold, Hello Kitty and prototype ROMs exist and the README shows them; with --rom-gold / --rom-kitty / --rom-proto they are redrawn and compared
  trees      the screen trees of the Japanese, international, Hello Kitty and prototype ROMs (tools/make_screen_trees.py) are redrawn and compared, and README.md shows them; the reachability maps are shown in the README of their ROM folder, not in README.md
  proto      roms/prototype_debagame (--rom-proto, the image as dumped): the symbol-table CSV, trace, types, copy sites, byte classes, names and
             pocketcamera_proto.sym equal a fresh run of tools/proto_{symtab,trace,types}.py + sym_build.py, the counts its README quotes match,
             and with --roundtrip the .sym rebuilds md5 19b50a5f... linked without rgbfix; L2: trace/observed_proto.md equals a fresh
             tools/proto_observed.py run on trace/cov_proto_runs.npz, the coverage map proto_rom_reachability_map.png equals a fresh
             tools/reach_map.py --tag proto drawing, and the run / BGB-replay counts its README quotes match; L3: the
             old-build matches, the merged names and the doubts list equal a fresh tools/proto_{match_old,names}.py run, every
             routine entry is named, and the README's name count matches
  port       roms/us_eu (docs §1.5): counts quoted for the ported international symbol file; with --rom-us the .sym is rebuilt and, with --roundtrip, assembled plain, after --tables and after --const (md5)
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
             the counts quoted in docs §16.28 (slots that write, lone rets, routines, slots the game selects, flip relations, grey-level checks) equal the csv; every tcrf_check/ file a label note cites exists
  ram        roms/jp_rev_a/disasm/ram_names_jp.csv (the RAM names, docs §2.13): identifiers and prefixes, no clash with a ROM label, roms/jp_rev_a/disasm/ram_jp.inc and pocketcamera_jp_ram.sym equal a fresh tools/ram_names.py run, every access of
             roms/jp_rev_a/wram/wram_access_jp.csv inside $C000-$DFFF / $FF80-$FFFE resolves to exactly one name for its bank, routine and instruction (the pointer loads of ram_exclude_jp.csv are numbers); the counts the README quotes
  forced     tcrf_check/assets/unidentified/forced_first_readers.csv equals a fresh tcrf_check/tools/forced_first_readers.py run on coverage/v8/merged_v8/cov.npz; the README sentences of 16.24 that quote it
  printwatch tcrf_check/assets/unidentified/map_26_7080_print_watch.csv (BGB read watch on 26:7080-72BF during two prints of copied Album B pictures: 0 hits, controls > 0), the organic coverage of Album B and of the maps next to 26:7080, the count of the byte pair 80 70 against the proven code; the README sentences of 16.25.2 that quote them
  seamoffsets tcrf_check/assets/unidentified/map_26_7080_seam_offsets.csv (seam search of 26:7080 at every byte offset: 13 variants, ratio best / control column consistent, none below 0.70 where a true block gives 0.33-0.37); the README sentences of 16.25.2 that quote them
  patternmatch tcrf_check/assets/unidentified/map_26_7080_pattern_match.csv (pattern of repeated ids of 26:7080 and two control maps against every window of both ROMs: a counterpart scores 1.000, no other window 0.20 or more); the README sentences of 16.25.2 that quote them
  handspan   (with --rom) the span 11:5800-693F has fewer different tiles (130 of 276, 95 blank) than the 245 ids of 26:7080 and its four natural layouts cost 0.7 per pixel or more; the README sentence of 16.25.2 that quotes them
  oamlist    (with --rom) no call of Oam_AddMeta_B01_4000 (00:24AF) has a literal id $A6-$BB, no organic run reads those 22 OAM lists ($BA = the hand flipping a newspaper), the README sentence of 16.24 that quotes the call and list counts
  statsplit  what STAT handler 1 splits (docs §2, interrupt map): the census table of the screens that run the split, the ROM sites that turn the interrupt on and off, the README sentences that quote them
  screengif  the whole-screen GIF of the page transitions of the main menu (docs §16.24): 640 x 576, endless loop, the frame count and length the README quotes
  headsets   (with --rom) why the ball head animation is stored twice: the frames F0-F4 and F5-F9 differ only inside the ids $20-$2F (10 or 11 tiles of 16), set A meets the body strip 16:5580 (seam 47-48) and set B the strip 11:4000 (41-42), each twice worse on the other, F4 and F9 carry the collar tiles of their strip byte for byte; the README paragraph of 16.24 that quotes them
  roundtrip  (--roundtrip) mgbdis + rgbasm rebuild the ROM from the sym byte-exact, plain, after sym_fix.py --tables, and after sym_fix.py --tables --ram (RAM names; the listing keeps only the excluded numbers); the plain listing's own labels are counted (`jr_` / `Jump_` / `Call_`, quoted in the README L5 row)
  kinds      in the three source trees, a block named as tiles (Gfx_ / Sheet_ / Font_) is not copied by `farcopy` to the BG map ($9800-$9FFF), and a block named as a map (Map_ / BgMap_) is not copied below $9800 (the layout maps take the kind from the name: 2026-11-02, bank $20)
  source     (--roundtrip) roms/jp_rev_a/src/ is exactly what tools/make_source.py writes, and it builds the ROM byte-exact (PNG -> 2bpp, rgbasm, rgblink, rgbfix); the README sentence that quotes its counts

Frozen inputs that are NOT regenerated: tcrf_check/assets/unidentified/open_assets.csv (the candidate list that display_report.py reads; the checker only compares the README's sentences with it).
Real exceptions (a Map type row that is not a multiple of 32 bytes, a Gfx label on a Map row, datasheet section numbers) are listed in ODD_MAP_ROWS, GFX_ON_MAP and EXTERNAL_REFS with the reason.

Add a quoted number here when the README starts quoting a new one: the point of this file is that a change of a label, a type row or a span
shows up as a failed line instead of as a stale sentence three weeks later.  Update the README / CLAUDE.md / SKILL.md first, then run this again."""
import glob, sys, os, re, csv, io, json, subprocess, tempfile, shutil, argparse, collections, hashlib

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
ap = argparse.ArgumentParser()
ap.add_argument('--rom'); ap.add_argument('--roundtrip', action='store_true'); ap.add_argument('--mgbdis', default='/home/claude/tc/mgbdis/mgbdis.py')
ap.add_argument('--rgbds', default='/home/claude/tc/rgbds'); ap.add_argument('-q', action='store_true')
ap.add_argument('--rom-gold', default=None); ap.add_argument('--rom-kitty', default=None); ap.add_argument('--rom-proto', default=None)
ap.add_argument('--rom-us', default=None, help='the international ROM (gbcam_us.gb): rebuild roms/us_eu/gbcam_us.sym and round-trip it')
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
def same_png(a, b):
    """True when two pictures hold the same pixels. Compared decoded, not byte for byte: the PNG bytes change with the zlib / Pillow /
    matplotlib versions of the machine that drew them (2026-11-03: a fresh container redrew every map pixel-identical, with other bytes)."""
    from PIL import Image
    import numpy as np
    if not (os.path.exists(a) and os.path.exists(b)): return False
    x, y = Image.open(a), Image.open(b)
    return x.size == y.size and np.array_equal(np.asarray(x.convert('RGBA')), np.asarray(y.convert('RGBA')))
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

# ------------------------------------------------------------------ international port (docs §1.5)
US = 'roms/us_eu/'
# the SRAM access tables (tools/sram_db.py) and the SRAM maps (tools/sram_map.py: the Japanese hand table checked, the ported ones carried)
for _t, _f, _r, _sym in (('jp', 'jp_rev_a', A.rom, 'pocketcamera_jp.sym'), ('us', 'us_eu', A.rom_us, 'gbcam_us.sym'), ('gold', 'gold', A.rom_gold, 'gbcam_gold.sym')):
    if _r:
        _tmp = tempfile.mkdtemp(prefix='sram_'); _o = os.path.join(_tmp, 'a.csv')
        _m = subprocess.run([sys.executable, 'tools/sram_db.py', _r, 'roms/%s/trace/trace_%s.json' % (_f, _t), 'roms/%s/%s' % (_f, _sym), _o], capture_output=True, text=True, cwd=ROOT)
        if _m.returncode or open(_o, encoding='utf-8').read() != rd('roms/%s/sram/sram_access_%s.csv' % (_f, _t)): bad('sram', 'roms/%s/sram/sram_access_%s.csv is not what tools/sram_db.py writes today: rerun it' % (_f, _t))
        shutil.rmtree(_tmp, ignore_errors=True)
    _m = subprocess.run([sys.executable, 'tools/sram_map.py', '--tag', _t, '--check'], capture_output=True, text=True, cwd=ROOT)
    (ok if not _m.returncode else bad)('sram', (_m.stdout or _m.stderr).strip().replace('\n', ' / ')[-300:])
# the WRAM summary and INDEX.md of the ported builds (tools/port_wram_index.py)
for _t in ('us', 'gold'):
    _m = subprocess.run([sys.executable, 'tools/port_wram_index.py', '--tag', _t, '--check'], capture_output=True, text=True, cwd=ROOT)
    (ok if not _m.returncode else bad)('wram', (_m.stdout or _m.stderr).strip().replace('\n', ' / ')[-300:])
# the settled-unused and doubts lists of the ported builds are what tools/port_settled.py makes from their final names
for _t in ('us', 'gold'):
    _m = subprocess.run([sys.executable, 'tools/port_settled.py', '--tag', _t, '--check'], capture_output=True, text=True, cwd=ROOT)
    (ok if not _m.returncode else bad)('settled', (_m.stdout or _m.stderr).strip().replace('\n', ' / ')[-300:])
# the final name and type tables of the ported builds are the merge of their layers (HOWTO section 0.1, rule 2)
for _t in ('us', 'gold'):
    _m = subprocess.run([sys.executable, 'tools/merge_name_layers.py', '--tag', _t, '--check'], capture_output=True, text=True, cwd=ROOT)
    (ok if not _m.returncode else bad)('layers', (_m.stdout or _m.stderr).strip().replace('\n', ' / ')[-300:])
if os.path.exists(US + 'disasm/sym_names_us.csv'):
    UN = list(csv.DictReader(io.StringIO(rd(US + 'disasm/sym_names_us.csv')))); ut = collections.Counter(r['conf'] for r in UN)
    UT = len(list(csv.DictReader(io.StringIO(rd(US + 'disasm/sym_types_us.csv')))))
    UPN = list(csv.DictReader(io.StringIO(rd(US + 'disasm/layers/sym_names_us_port.csv')))); upt = collections.Counter(r['conf'] for r in UPN)    # the port layer (what port_syms.py carried)
    UPT = len(list(csv.DictReader(io.StringIO(rd(US + 'disasm/layers/sym_types_us_port.csv')))))
    UR = collections.Counter(r['fate'] for r in csv.DictReader(io.StringIO(rd(US + 'port/port_report_us.csv'))))
    UQ = list(csv.DictReader(io.StringIO(rd(US + 'port/hand_queue_us.csv')))); uq = collections.Counter(r['kind'] for r in UQ)
    uqi = sum(int(r['detail'].split()[0]) for r in UQ if r['kind'] == 'new_code'); uqb = sum(int(r['detail'].split()[0]) for r in UQ if r['kind'] == 'default_data')
    UC = collections.Counter(r['kind'] for r in csv.DictReader(io.StringIO(rd(US + 'port/code_map_us.csv'))))
    UJ = json.loads(rd(US + 'trace/trace_us.json')); uins = [v for v in UJ['code'].values() if v > 0]
    NJI = sum(1 for v in json.loads(rd('roms/jp_rev_a/trace/trace_jp.json'))['code'].values() if v > 0)
    ULINES = rd(US + 'gbcam_us.sym').count('\n')
    if len({r['name'] for r in UN}) != len(UN): bad('port', 'duplicate name in sym_names_us.csv')
    if UJ['unresolved']: bad('port', 'trace_us.json has %d unresolved sites' % len(UJ['unresolved']))
    n_ = quoted('port names', r'The port layer carries ([\d,]+) names \(C ([\d,]+) / I ([\d,]+)\) and ([\d,]+) type rows; (\d+) Japanese names were not carried',
                lambda m: ((len(UPN), upt['C'], upt['I'], UPT, UR['lost']), tuple(num(m.group(i)) for i in range(1, 6))), need=('README.md',))
    n_ += quoted('port queue', r'(\d+) runs of new code \(([\d,]+) instructions.*?(\d+) lost names, ([\d,]+) names whose routine or content differs, and (\d+) data blocks \(([\d,]+) bytes',
                 lambda m: ((uq['new_code'], uqi, uq['lost_name'], uq['name_differs'], uq['default_data'], uqb), tuple(num(m.group(i)) for i in range(1, 7))), need=('README.md',))
    n_ += quoted('port pairs', r'([\d,]+) of the ([\d,]+) Japanese instructions pair with an international one \(([\d,]+) identical, ([\d,]+) with another address operand, (\d+) with another 8-bit operand\)',
                 lambda m: ((sum(UC.values()), NJI, UC['same'], UC['operand'], UC['imm']), tuple(num(m.group(i)) for i in range(1, 6))), need=('README.md',))
    n_ += quoted('port trace', r'traces the international ROM itself: ([\d,]+) instructions \(([\d,]+) code bytes\), (\d+) far calls resolved',
                 lambda m: ((len(uins), sum(uins), len(UJ['far_ok'])), tuple(num(m.group(i)) for i in range(1, 4))), need=('README.md',))
    UH = len(list(csv.DictReader(io.StringIO(rd(US + 'disasm/layers/sym_names_us_hand.csv')))))
    n_ += quoted('port hand', r'Hand corrections live in `roms/us_eu/disasm/layers/sym_names_us_hand.csv` \((\d+) rows', lambda m: ((UH,), (int(m.group(1)),)), need=('README.md',))
    USTATES = len(list(csv.DictReader(io.StringIO(rd(US + 'disasm/state_names_us.csv')))))
    n_ += quoted('port states', r'the state constants from the international tables and handler labels \((\d+):', lambda m: ((USTATES,), (int(m.group(1)),)), need=('README.md',))
    UACC = len(list(csv.DictReader(io.StringIO(rd(US + 'wram/wram_access_us.csv')))))
    n_ += quoted('port access', r'the access table \(([\d,]+) rows carried .*?plus (\d+) rows of `tools/wram_db.py`', lambda m: ((UACC,), (num(m.group(1)) + int(m.group(2)),)), need=('README.md',))
    ULD = len(list(csv.DictReader(io.StringIO(rd(US + 'disasm/layers/sym_names_us_loaders.csv')))))
    n_ += quoted('port loaders', r'the loader layer names the other (\d+) ', lambda m: ((ULD,), (int(m.group(1)),)), need=('README.md',))
    n_ += quoted('port sym', r'writes `roms/us_eu/gbcam_us.sym` \(([\d,]+) lines\)', lambda m: ((ULINES,), (num(m.group(1)),)), need=('README.md',))
    if not any(f.startswith('port') or f.startswith('quoted') for f in FAIL):
        ok('port', 'international: %s names (C %s / I %s), %s type rows, %s lost; %s instruction pairs; trace %s instructions, 0 unresolved; %d sentences checked'
           % (fmt(len(UN)), fmt(ut['C']), fmt(ut['I']), fmt(UT), UR['lost'], fmt(sum(UC.values())), fmt(len(uins)), n_))
    if A.rom_us:
        tmp = tempfile.mkdtemp(prefix='cons_us_'); out = os.path.join(tmp, 'gbcam_us.sym')
        r = subprocess.run([sys.executable, 'tools/sym_build.py', A.rom_us, '--names', US + 'disasm/sym_names_us.csv', '--types', US + 'disasm/sym_types_us.csv',
                            '--trace', US + 'trace/trace_us.json', '--out', out], capture_output=True, text=True)
        if r.returncode: bad('port', 'sym_build.py failed on the international tables: %s' % (r.stderr or r.stdout).strip()[-300:])
        elif open(out).read() != rd(US + 'gbcam_us.sym'): bad('port', 'gbcam_us.sym is not what sym_build.py makes from the csv files: rebuild it')
        elif A.roundtrip:
            shutil.copy(A.rom_us, os.path.join(tmp, 'gbcam_us.gb')); env = dict(os.environ); env['PATH'] = A.rgbds + os.pathsep + env['PATH']
            D_ = US + 'disasm/%s_us.csv'; FH = ['--tables', '--far-helpers', '0473,049C,061B,068D,0734,0950,0956']
            L4 = ['--const', '--ram-names', D_ % 'ram_names', '--ram-access', US + 'wram/wram_access_us.csv', '--ram-exclude', D_ % 'ram_exclude', '--ram-highbyte', D_ % 'ram_highbyte',
                  '--const-names', D_ % 'const_names', '--const-types', D_ % 'const_types', '--const-tables', D_ % 'const_tables', '--const-sounds', D_ % 'sound_names',
                  '--state-names', D_ % 'state_names', '--state-helpers', D_ % 'state_helpers', '--text-tables', 'none']
            for tag, fix in (('plain', None), ('tables', FH), ('const', FH + L4)):
                d = os.path.join(tmp, tag)
                subprocess.run([sys.executable, A.mgbdis, '--overwrite', '--print-hex', '--output-dir', d, os.path.join(tmp, 'gbcam_us.gb')], capture_output=True)
                if fix: subprocess.run([sys.executable, 'tools/sym_fix.py', d, '--rom', os.path.join(tmp, 'gbcam_us.gb'), '--sym', out, '--trace', US + 'trace/trace_us.json'] + fix, capture_output=True)
                subprocess.run(['make'], cwd=d, env=env, capture_output=True)
                g = os.path.join(d, 'game.gb'); md = hashlib.md5(open(g, 'rb').read()).hexdigest() if os.path.exists(g) else 'no ROM built'
                (ok if md == '42d2f65e2549be9d1d126a6828b5d1c1' else bad)('port', 'international round trip %s: md5 %s' % (tag, md))
            # the layout picture of the international ROM (README, after the Japanese one) is what rom_layout_map.py draws today
            pu = os.path.join(tmp, 'us_map.png'); D_ = US + 'disasm/'
            rr = subprocess.run([sys.executable, 'tcrf_check/tools/rom_layout_map.py', pu, '--rom', A.rom_us, '--map', US + 'trace/rom_map_us.csv', '--assets', 'none', '--witness', 'none',
                                 '--reach', 'none', '--unused', 'none', '--kinds', US + 'assets/layout_kind_overrides_us.csv',
                                 '--names', D_ + 'sym_names_us.csv',
                                 '--types', D_ + 'sym_types_us.csv', '--diff', US + 'port/diff_us.npz', '--cov', US + 'port/cov_jp_in_us.npz', '--csv', os.path.join(tmp, 'us_layout.csv'),
                                 '--outline', 'none', '--title', 'Game Boy Camera (USA, Europe): what is in each of the 64 banks (the ROM drawn as 2bpp tiles)'], capture_output=True, text=True)
            if rr.returncode: bad('port', 'rom_layout_map.py failed on the international ROM: %s' % (rr.stderr or rr.stdout)[-300:])
            elif not same_png(pu, US + 'us_rom_layout_map.png') or open(os.path.join(tmp, 'us_layout.csv'), 'rb').read() != open(US + 'assets/layout_by_bank_us.csv', 'rb').read():
                bad('port', 'roms/us_eu/us_rom_layout_map.png or assets/layout_by_bank_us.csv is not what rom_layout_map.py draws: rerun tools/port_build.py')
            else: ok('port', 'roms/us_eu/us_rom_layout_map.png fresh')
            # L5: roms/us_eu/src/ is what tools/make_source.py --tree us_eu writes today, and it builds the ROM byte-exact
            fr = os.path.join(tmp, 'src_us'); rp = os.path.join(tmp, 'rom_operands_us.csv')
            ms = subprocess.run([sys.executable, 'tools/make_source.py', '--tree', 'us_eu', '--rom', A.rom_us, '--mgbdis', A.mgbdis, '--rgbds', A.rgbds, '--out', fr, '--report', rp, '--check'], capture_output=True, text=True)
            if ms.returncode: bad('port', 'make_source.py --tree us_eu failed: %s' % (ms.stderr or ms.stdout)[-300:])
            else:
                def walk_(r): return sorted(os.path.relpath(os.path.join(dp, f), r) for dp, _, fs in os.walk(r) for f in fs)
                srcu = US + 'src'
                a_, b_ = (walk_(fr), walk_(srcu)) if os.path.isdir(srcu) else ([], ['missing'])
                dif = sorted(set(a_) ^ set(b_)) + [f for f in a_ if f in set(b_) and open(os.path.join(fr, f), 'rb').read() != open(os.path.join(srcu, f), 'rb').read()]
                if dif: bad('port', 'roms/us_eu/src/ is not what make_source.py --tree us_eu writes (%d files differ: %s)' % (len(dif), dif[:4]))
                elif open(rp, 'rb').read() != rd(US + 'disasm/rom_operands_us.csv').encode('utf-8'): bad('port', 'roms/us_eu/disasm/rom_operands_us.csv is not fresh')
                else:
                    mu = re.search(r'(\d+) banks, (\d+) INCBIN files \((\d+) bytes, (\d+) tile blocks as PNG\), (\d+) label notes, (\d+) far pointers as labels \((\d+) left', ms.stdout)
                    ok('port', 'roms/us_eu/src/ fresh (%d files), builds md5 42d2f65e2549be9d1d126a6828b5d1c1: %s banks, %s INCBIN files (%s bytes, %s tile PNGs), %s label notes, %s far pointers as labels (%s left)' % ((len(a_),) + mu.groups()))
                    quoted('port tree', r'International tree: (\d+) bank files and ([\d,]+) `INCBIN` files \(([\d,]+) bytes; ([\d,]+) tile blocks as PNG\), ([\d,]+) label notes, ([\d,]+) far pointers written as labels \((\d+) left as numbers\)',
                           lambda mm: (tuple(int(g) for g in mu.groups()), tuple(num(g) for g in mm.groups())), docs=('README.md',), need=('README.md',))
        shutil.rmtree(tmp, ignore_errors=True)
else:
    bad('port', 'roms/us_eu/disasm/sym_names_us.csv missing')
# ------------------------------------------------------------------ L5 of the Gold edition: roms/gold/src/ is what make_source.py --tree gold writes, and it builds byte-exact
if A.roundtrip and getattr(A, 'rom_gold', None) and os.path.isdir('roms/gold/src'):
    tmpg = tempfile.mkdtemp(prefix='cons_gold_'); fr = os.path.join(tmpg, 'src_gold'); rp = os.path.join(tmpg, 'rom_operands_gold.csv')
    ms = subprocess.run([sys.executable, 'tools/make_source.py', '--tree', 'gold', '--rom', A.rom_gold, '--mgbdis', A.mgbdis, '--rgbds', A.rgbds, '--out', fr, '--report', rp, '--check'], capture_output=True, text=True)
    if ms.returncode: bad('port', 'make_source.py --tree gold failed: %s' % (ms.stderr or ms.stdout)[-300:])
    else:
        def walkg(r): return sorted(os.path.relpath(os.path.join(dp, f), r) for dp, _, fs in os.walk(r) for f in fs)
        a_, b_ = walkg(fr), walkg('roms/gold/src')
        dif = sorted(set(a_) ^ set(b_)) + [f for f in a_ if f in set(b_) and open(os.path.join(fr, f), 'rb').read() != open(os.path.join('roms/gold/src', f), 'rb').read()]
        if dif: bad('port', 'roms/gold/src/ is not what make_source.py --tree gold writes (%d files differ: %s)' % (len(dif), dif[:4]))
        elif open(rp, 'rb').read() != rd('roms/gold/disasm/rom_operands_gold.csv').encode('utf-8'): bad('port', 'roms/gold/disasm/rom_operands_gold.csv is not fresh')
        else: ok('port', 'roms/gold/src/ fresh (%d files), builds md5 b2999cfb6dacb439f501a71f30f91762' % len(a_))
    shutil.rmtree(tmpg, ignore_errors=True)
# ------------------------------------------------------------------ L4 / L5 of the prototype (roadmap step 7): RAM tables fresh, roms/prototype_debagame/src/ fresh and byte-exact
_PR = 'roms/prototype_debagame/'
if getattr(A, 'rom_proto', None) and os.path.isdir(_PR + 'src'):
    _tmp = tempfile.mkdtemp(prefix='cons_proto_')
    _m = subprocess.run([sys.executable, 'tools/wram_db.py', A.rom_proto, _PR + 'trace/trace_proto.json', _PR + 'pocketcamera_proto.sym', os.path.join(_tmp, 'w')], capture_output=True, text=True, cwd=ROOT)
    for _k in ('access', 'summary'):
        if _m.returncode or open(os.path.join(_tmp, 'w_%s.csv' % _k), encoding='utf-8').read() != rd(_PR + 'wram/wram_%s_proto.csv' % _k): bad('proto', _PR + 'wram/wram_%s_proto.csv is not what tools/wram_db.py writes today' % _k)
    _m = subprocess.run([sys.executable, 'tools/sram_db.py', A.rom_proto, _PR + 'trace/trace_proto.json', _PR + 'pocketcamera_proto.sym', os.path.join(_tmp, 's.csv')], capture_output=True, text=True, cwd=ROOT)
    if _m.returncode or open(os.path.join(_tmp, 's.csv'), encoding='utf-8').read() != rd(_PR + 'sram/sram_access_proto.csv'): bad('proto', _PR + 'sram/sram_access_proto.csv is not what tools/sram_db.py writes today')
    _m = subprocess.run([sys.executable, 'tools/sram_map.py', '--tag', 'proto', '--check'], capture_output=True, text=True, cwd=ROOT)
    (ok if not _m.returncode else bad)('proto', (_m.stdout or _m.stderr).strip().replace('\n', ' / ')[-300:])
    _m = subprocess.run([sys.executable, 'tools/proto_ram_names.py', A.rom_proto, '--out', os.path.join(_tmp, 'n.csv')], capture_output=True, text=True, cwd=ROOT)
    if _m.returncode or open(os.path.join(_tmp, 'n.csv'), encoding='utf-8').read() != rd(_PR + 'disasm/ram_names_proto.csv'): bad('proto', _PR + 'disasm/ram_names_proto.csv is not what tools/proto_ram_names.py writes today')
    _m = subprocess.run([sys.executable, 'tools/ram_names.py', '--names', _PR + 'disasm/ram_names_proto.csv', '--inc', _PR + 'disasm/ram_proto.inc', '--sym', _PR + 'pocketcamera_proto_ram.sym', '--check'], capture_output=True, text=True, cwd=ROOT)
    if _m.returncode: bad('proto', 'ram_proto.inc / pocketcamera_proto_ram.sym are not what tools/ram_names.py writes: %s' % _m.stdout.strip())
    _raw = []
    for _f in sorted(glob.glob(_PR + 'src/bank_*.asm')):
        for _l in open(_f, encoding='utf-8'):
            _c = _l.split(';', 1)[0]
            _mm = re.search(r'\b(?:ld|ldh)\b[^;]*\[\$([0-9a-fA-F]{2,4})\]', _c)
            if _mm and (0xC000 <= int(_mm.group(1), 16) < 0xE000 or 0xFF80 <= int(_mm.group(1), 16) < 0xFFFF or len(_mm.group(1)) == 2 and int(_mm.group(1), 16) >= 0x80): _raw.append(_l.strip()[:60])
    if _raw: bad('proto', 'roms/prototype_debagame/src/ keeps %d raw RAM operands: %s' % (len(_raw), _raw[:3]))
    else: ok('proto', 'L4: roms/prototype_debagame/src/ has no raw WRAM / HRAM operand of ld / ldh (%d RAM names)' % (sum(1 for _ in open(_PR + 'disasm/ram_names_proto.csv')) - 1))
    if A.roundtrip:
        fr = os.path.join(_tmp, 'src'); rp = os.path.join(_tmp, 'rom_operands_proto.csv')
        ms = subprocess.run([sys.executable, 'tools/make_source.py', '--tree', 'prototype_debagame', '--rom', A.rom_proto, '--mgbdis', A.mgbdis, '--rgbds', A.rgbds, '--out', fr, '--report', rp, '--check'], capture_output=True, text=True)
        if ms.returncode: bad('proto', 'make_source.py --tree prototype_debagame failed: %s' % (ms.stderr or ms.stdout)[-300:])
        else:
            def walkp(r): return sorted(os.path.relpath(os.path.join(dp, f), r) for dp, _, fs in os.walk(r) for f in fs)
            a_, b_ = walkp(fr), walkp(_PR + 'src')
            dif = sorted(set(a_) ^ set(b_)) + [f for f in a_ if f in set(b_) and open(os.path.join(fr, f), 'rb').read() != open(os.path.join(_PR + 'src', f), 'rb').read()]
            if dif: bad('proto', 'roms/prototype_debagame/src/ is not what make_source.py --tree prototype_debagame writes (%d files differ: %s)' % (len(dif), dif[:4]))
            elif open(rp, 'rb').read() != rd(_PR + 'disasm/rom_operands_proto.csv').encode('utf-8'): bad('proto', _PR + 'disasm/rom_operands_proto.csv is not fresh')
            else: ok('proto', 'L5: roms/prototype_debagame/src/ fresh (%d files), builds md5 19b50a5f67ef4f0d015e7d813370756e (no rgbfix)' % len(a_))
    shutil.rmtree(_tmp, ignore_errors=True)
# ------------------------------------------------------------------ unused bytes in two categories, documented by TCRF or not (tools/unused_table.py, owner 2026-11-12)
_m = subprocess.run([sys.executable, 'tools/unused_table.py', '--check'], capture_output=True, text=True, cwd=ROOT)
(ok if not _m.returncode else bad)('unused', (_m.stdout or _m.stderr).strip().replace('\n', ' / ')[-400:])
if os.path.isdir(os.path.join(ROOT, 'source', 'Unused_graphics_TCRF')): bad('tcrf', 'source/Unused_graphics_TCRF/ is back: the repository keeps no TCRF content, only links (tcrf_check/TCRF_SOURCES.md, owner 2026-11-12)')
if getattr(A, 'rom_proto', None):
    _m = subprocess.run([sys.executable, 'tools/proto_reconstruct.py', A.rom_proto, '--check'], capture_output=True, text=True, cwd=ROOT)
    (ok if not _m.returncode else bad)('proto', (_m.stdout or _m.stderr).strip().replace('\n', ' / ')[-300:])
    _m = subprocess.run([sys.executable, 'tools/proto_unused_sheet.py', A.rom_proto, '--check'], capture_output=True, text=True, cwd=ROOT)
    (ok if not _m.returncode else bad)('proto', (_m.stdout or _m.stderr).strip().replace('\n', ' / ')[-300:])
if getattr(A, 'rom_kitty', None):
    _m = subprocess.run([sys.executable, 'tools/kitty_unused_highlights.py', A.rom_kitty, '--check'], capture_output=True, text=True, cwd=ROOT)
    (ok if not _m.returncode else bad)('kitty', (_m.stdout or _m.stderr).strip().replace('\n', ' / ')[-300:])
    _m = subprocess.run([sys.executable, 'tools/kitty_unused_sheet.py', A.rom_kitty, '--check'], capture_output=True, text=True, cwd=ROOT)
    (ok if not _m.returncode else bad)('kitty', (_m.stdout or _m.stderr).strip().replace('\n', ' / ')[-300:])
for _t, _r in (('jp', A.rom), ('us', getattr(A, 'rom_us', None)), ('gold', getattr(A, 'rom_gold', None))):     # the retail unused-asset sheets (tools/retail_unused_sheet.py)
    if _r:
        _m = subprocess.run([sys.executable, 'tools/retail_unused_sheet.py', '--tag', _t, _r, '--check'], capture_output=True, text=True, cwd=ROOT)
        (ok if not _m.returncode else bad)('sheets', (_m.stdout or _m.stderr).strip().replace('\n', ' / ')[-300:])
# ------------------------------------------------------------------ kinds: the name prefix against the copy destination
_kb = []
for _t in ('jp_rev_a', 'us_eu', 'gold', 'prototype_debagame'):
    for _f in sorted(glob.glob('roms/%s/src/bank_*.asm' % _t)):
        for _l in open(_f, encoding='utf-8'):
            _m = re.match(r'\s+farcopy \w+, (\w+)(?: \+ \$[0-9A-Fa-f]+)?, \$([0-9a-f]{4}), \$[0-9a-f]{4}', _l)
            if not _m: continue
            _n, _d = _m.group(1), int(_m.group(2), 16); _p = _n.split('_')[0]
            if (_p in ('Gfx', 'Sheet', 'Font') and 0x9800 <= _d < 0xA000) or (_p in ('Map', 'BgMap') and 0x8000 <= _d < 0x9800): _kb.append('%s: %s -> $%04X' % (_t, _n, _d))
if _kb: bad('kinds', '%d copies whose destination contradicts the kind of the name: %s' % (len(_kb), '; '.join(sorted(set(_kb))[:6])))
else: ok('kinds', 'every farcopy of a Gfx_ / Sheet_ / Font_ block goes to tile memory and of a Map_ / BgMap_ block to the BG map')

# ------------------------------------------------------------------ the screen trees (tools/make_screen_trees.py), the reachability maps in the ROM folders
_main = open(os.path.join(ROOT, 'README.md')).read()
for _f in ('jp_rom_reachability_map.png', 'kitty_rom_reachability_map.png'):
    if _f in _main: bad('maps', 'README.md shows %s: the reachability maps belong to the README of their ROM folder (owner, 2026-11-08)' % _f)
for _d, _f in (('jp_rev_a', 'jp_rom_reachability_map.png'),):
    if '](%s)' % _f not in open(os.path.join(ROOT, 'roms', _d, 'README.md')).read(): bad('maps', 'roms/%s/README.md does not show %s' % (_d, _f))
_tt = tempfile.mkdtemp()
_r = subprocess.run([sys.executable, 'tools/make_screen_trees.py', '--out-dir', _tt], capture_output=True, text=True, cwd=ROOT)
if _r.returncode: bad('trees', 'tools/make_screen_trees.py failed: %s' % (_r.stderr or _r.stdout)[-300:])
else:
    for _d, _s in (('jp_rev_a', 'jp'), ('us_eu', 'us'), ('hello_kitty', 'kitty'), ('prototype_debagame', 'proto')):
        _png = 'roms/%s/%s_screen_tree.png' % (_d, _s)
        if _png not in _main: bad('trees', 'README.md does not show %s' % _png)
        if not same_png(os.path.join(_tt, '%s_screen_tree.png' % _s), os.path.join(ROOT, _png)): bad('trees', '%s is not what tools/make_screen_trees.py draws today: rerun it' % _png)
        else: ok('trees', '%s fresh' % _png)
shutil.rmtree(_tt, ignore_errors=True)
# ------------------------------------------------------------------ the layout maps of the ROMs not done by a pipeline (README, tools/status_maps.py)
_sm = [(k, f, p) for k, f, p in (('gold', 'gold', 'gold'), ('kitty', 'hello_kitty', 'kitty'), ('proto', 'prototype_debagame', 'proto'))]
for k, folder, pre in _sm:
    png = 'roms/%s/%s_rom_layout_map.png' % (folder, pre)
    if not os.path.exists(png): bad('maps', '%s missing (tools/status_maps.py)' % png); continue
    if ('roms/%s/%s_rom_layout_map.png' % (folder, pre)) not in README: bad('maps', 'README does not show %s' % png)
    rom_ = getattr(A, 'rom_' + k)
    if not rom_: continue
    tmp_ = tempfile.mkdtemp(prefix='maps_')
    r_ = subprocess.run([sys.executable, 'tools/status_maps.py', '--' + k, rom_, '--out-dir', tmp_], capture_output=True, text=True)
    if r_.returncode: bad('maps', 'tools/status_maps.py failed for %s: %s' % (k, (r_.stderr or r_.stdout)[-300:]))
    elif not same_png(os.path.join(tmp_, '%s_rom_layout_map.png' % pre), png) or \
         open(os.path.join(tmp_, 'layout_by_bank_%s.csv' % pre), 'rb').read() != open('roms/%s/assets/layout_by_bank_%s.csv' % (folder, pre), 'rb').read():
        bad('maps', '%s is not what tools/status_maps.py draws today: rerun it' % png)
    else: ok('maps', '%s fresh' % png)
    shutil.rmtree(tmp_, ignore_errors=True)
# ------------------------------------------------------------------ Hello Kitty: trace, types, symbol file, round trip (needs --rom-kitty)
# The generated files of roms/hello_kitty/ are rebuilt in a temporary folder and compared; the counts that its README quotes are
# compared with the tools' output (need=: a reworded sentence fails instead of passing silently).
if A.rom_kitty:
    KD = 'roms/hello_kitty/'; tk = tempfile.mkdtemp(prefix='kitty_')
    def _run(*cmd): return subprocess.run([sys.executable] + list(cmd), capture_output=True, text=True)
    OBS = sorted(glob.glob(KD + 'trace/cov_kitty_*.npz')); obs = [x for f in OBS for x in ('--observed', f)]     # the runs (L2)
    r1 = _run('tools/kitty_trace.py', A.rom_kitty, os.path.join(tk, 't.json'), '--roots', KD + 'trace/extra_roots_kitty.json', '--report', os.path.join(tk, 'u.md'), *obs)
    r2 = _run('tools/kitty_types.py', A.rom_kitty, os.path.join(tk, 't.json'), '--types', os.path.join(tk, 'ty.csv'), '--sites', os.path.join(tk, 'cs.csv'),
              '--rommap', os.path.join(tk, 'rm.csv'), '--names', os.path.join(tk, 'na.csv'), *obs) if not r1.returncode else r1
    if not r2.returncode:      # L3 names: the match tables, then the merge of the layers
        r2b = _run('tools/kitty_match_jp.py', A.rom, A.rom_kitty, os.path.join(tk, 'mj.csv'))
        r2c = _run('tools/kitty_similar_jp.py', A.rom, A.rom_kitty, os.path.join(tk, 'sj.csv')) if not r2b.returncode else r2b
        r2d = _run('tools/kitty_names.py', '--auto', os.path.join(tk, 'na.csv'), '--trace', os.path.join(tk, 't.json'), '--out', os.path.join(tk, 'nm.csv'), '--rom', A.rom_kitty, '--jp', A.rom or '') if not r2c.returncode else r2c
        if r2d.returncode: r2 = r2d
    r3 = _run('tools/sym_build.py', A.rom_kitty, '--names', KD + 'disasm/sym_names_kitty.csv', '--types', KD + 'disasm/sym_types_kitty.csv',
              '--trace', KD + 'trace/trace_kitty.json', '--out', os.path.join(tk, 'k.sym'), '--report') if not r2.returncode else r2
    if r3.returncode: bad('kitty', 'the Kitty pipeline failed: %s' % (r3.stderr or r3.stdout)[-300:])
    else:
        stale = [f for f, g in (('trace/trace_kitty.json', 't.json'), ('trace/trace_kitty_unresolved.md', 'u.md'), ('disasm/sym_types_kitty.csv', 'ty.csv'),
                                ('assets/copy_sites_kitty.csv', 'cs.csv'), ('trace/rom_map_kitty.csv', 'rm.csv'), ('disasm/layers/sym_names_kitty_auto.csv', 'na.csv'),
                                ('disasm/match_jp_kitty.csv', 'mj.csv'), ('disasm/similar_jp_kitty.csv', 'sj.csv'), ('disasm/sym_names_kitty.csv', 'nm.csv'),
                                ('pocketcamera_kitty.sym', 'k.sym')) if open(KD + f, 'rb').read() != open(os.path.join(tk, g), 'rb').read()]
        if stale: bad('kitty', 'not what the Kitty pipeline makes today (SETUP.md, Hello Kitty): %s' % ', '.join(stale))
        else: ok('kitty', 'trace, types, copy sites, byte classes, names and pocketcamera_kitty.sym fresh')
        KR = rd(KD + 'README.md')
        m1 = re.search(r'kitty_trace: (\d+) instructions, (\d+) code bytes, (\d+) inline table bytes, (\d+) far calls resolved, (\d+) unresolved', r1.stdout)
        m3 = re.search(r'bytes by type: (\{.*\})', r3.stdout); m4 = re.search(r'still on the default typing \(\.data, 16 per row\): (\d+)', r3.stdout)
        BYK = eval(m3.group(1)); typed = BYK['data'] - int(m4.group(1))
        mn = re.search(r"kitty_names: (\d+) names, tags \{'C': (\d+), 'I': (\d+), '\?': (\d+)\}", r2d.stdout if 'r2d' in dir() else '')
        if mn:
            mm = re.search(r'([\d,]+) names \(C ([\d,]+) / I ([\d,]+) / \? ([\d,]+)\)', KR)
            if not mm: bad('kitty', 'roms/hello_kitty/README.md no longer quotes the name count (need=N names (C a / I b / ? c))')
            elif [int(x.replace(',', '')) for x in mm.groups()] != [int(x) for x in mn.groups()]:
                bad('kitty', 'roms/hello_kitty/README.md: names quoted %s, tools/kitty_names.py gives %s' % (mm.group(0), mn.groups()))
        m2 = re.search(r'observed: (\d+) of (\d+) code bytes executed', r2.stdout)
        if m2:
            mm = re.search(r'([\d,]+) of the [\d,]+ bytes of proven code ran', KR)
            if not mm: bad('kitty', 'roms/hello_kitty/README.md no longer quotes the executed code bytes (need=N of the M bytes of proven code ran)')
            elif int(mm.group(1).replace(',', '')) != int(m2.group(1)): bad('kitty', 'roms/hello_kitty/README.md: executed code bytes quoted %s, the runs give %s' % (mm.group(1), m2.group(1)))
        for what, val, pat in (('code bytes', int(m1.group(2)), r'([\d,]+) bytes of proven code'), ('unresolved', int(m1.group(5)), r'([\d,]+) indirect sites left unresolved'),
                               ('padding', BYK['padding'], r'([\d,]+) bytes of padding'), ('typed data', typed, r'([\d,]+) bytes of data typed by a reason'),
                               ('default data', int(m4.group(1)), r'([\d,]+) bytes of data on the default typing')):
            mm = re.search(pat, KR)
            if not mm: bad('kitty', 'roms/hello_kitty/README.md no longer quotes the %s (need=%r)' % (what, pat))
            elif int(mm.group(1).replace(',', '')) != val: bad('kitty', 'roms/hello_kitty/README.md: %s quoted %s, the tools give %d' % (what, mm.group(1), val))
        if A.roundtrip:
            rt = tempfile.mkdtemp(prefix='kittyrt_'); shutil.copy(A.rom_kitty, os.path.join(rt, 'pocketcamera_kitty.gb')); shutil.copy(KD + 'pocketcamera_kitty.sym', rt)
            r_ = subprocess.run([sys.executable, '/home/claude/tc/mgbdis/mgbdis.py', '--output-dir', os.path.join(rt, 'out'), os.path.join(rt, 'pocketcamera_kitty.gb')], capture_output=True, text=True)
            env_ = dict(os.environ, PATH='/home/claude/tc/rgbds:' + os.environ.get('PATH', ''))
            r_ = subprocess.run(['make'], cwd=os.path.join(rt, 'out'), capture_output=True, text=True, env=env_) if not r_.returncode else r_
            gb = os.path.join(rt, 'out', 'game.gb')
            md = hashlib.md5(open(gb, 'rb').read()).hexdigest() if os.path.exists(gb) else 'none'
            if md != '0a323bddc4f0159cea76cf44ed0c1a3c': bad('kitty', 'round trip with pocketcamera_kitty.sym: md5 %s' % md)
            else: ok('kitty', 'round trip with pocketcamera_kitty.sym: md5 %s' % md)
            shutil.rmtree(rt, ignore_errors=True)
        # the data kinds of the layout map (tools/kitty_layout_kinds.py): regenerated and compared, its counts quoted in the Kitty README
        r6 = _run('tools/kitty_layout_kinds.py', A.rom_kitty, '--out', os.path.join(tk, 'kinds.csv'))
        m6 = re.search(r'kitty_layout_kinds: \d+ rows, (\d+) bytes of kind-less blocks given a kind .*?; (\d+) bytes of kind-less blocks left', r6.stdout)
        if r6.returncode or not m6: bad('kitty', 'tools/kitty_layout_kinds.py failed: %s' % (r6.stderr or r6.stdout)[-300:])
        else:
            if open(os.path.join(tk, 'kinds.csv'), 'rb').read() != open(KD + 'assets/layout_kind_overrides_kitty.csv', 'rb').read():
                bad('kitty', 'assets/layout_kind_overrides_kitty.csv is not what tools/kitty_layout_kinds.py makes today: rerun it, then tools/status_maps.py --kitty')
            else: ok('kitty', 'layout_kind_overrides_kitty.csv fresh')
            mm = re.search(r'([\d,]+) bytes of kind-less blocks given a kind, ([\d,]+) left uncertain', open(KD + 'README.md').read())   # need= the L3 bullet, Data kinds of the layout map
            if not mm: bad('kitty', 'roms/hello_kitty/README.md no longer quotes the data kinds (need=N bytes of kind-less blocks given a kind, M left uncertain)')
            elif (int(mm.group(1).replace(',', '')), int(mm.group(2).replace(',', ''))) != (int(m6.group(1)), int(m6.group(2))):
                bad('kitty', 'roms/hello_kitty/README.md: data kinds quoted %s, tools/kitty_layout_kinds.py gives %s / %s' % (mm.group(0), m6.group(1), m6.group(2)))
        # the unused-asset table (hand-made, assets/never_reached_kitty.csv): its counts quoted in the Kitty README, its picture present
        _ua = list(csv.DictReader(open(KD + 'assets/never_reached_kitty.csv', encoding='utf-8')))
        _uv = collections.Counter(r['verdict'] for r in _ua)
        mm = re.search(r'never_reached_kitty\.csv\)\s+lists (\d+) items: (\d+) unused, (\d+) unused because only an unreachable mode loads them, (\d+) used but not read in the runs, (\d+) open', open(KD + 'README.md', encoding='utf-8').read())   # need= the unused-assets paragraph
        want = (len(_ua), _uv['unused'], _uv['unused (unreachable mode)'], sum(v for k, v in _uv.items() if k.startswith('used')), _uv['open'])
        if not mm: bad('kitty', 'roms/hello_kitty/README.md no longer quotes assets/never_reached_kitty.csv (need=lists N items: a unused, b unused because only an unreachable mode loads them, c used but not read in the runs, d open)')
        elif tuple(int(x) for x in mm.groups()) != want: bad('kitty', 'roms/hello_kitty/README.md: unused assets quoted %s, the table gives %s' % (mm.groups(), want))
        elif not os.path.exists(KD + 'assets/never_reached_kitty.png'): bad('kitty', 'assets/never_reached_kitty.png missing')
        else: ok('kitty', 'unused-asset table and its README quote agree (%d items)' % len(_ua))
        # the never-read sprite layouts (tools/kitty_sprite_layouts.py): its counts quoted in the Kitty README
        _sl = list(csv.DictReader(open(KD + 'assets/sprite_layouts_unread_kitty.csv', encoding='utf-8'))); _sc = collections.Counter(r['class'] for r in _sl)
        mm = re.search(r'([\d,]+) layouts \(([\d,]+) bytes\) are never read in the runs.*?; (\d+) are named only by object scripts of bank `\$02` that no run started.*?, (\d+) by words that a run read.*?, (\d+) only from code, (\d+) by nothing', open(KD + 'README.md', encoding='utf-8').read(), re.S)   # need= the sprite-layout paragraph
        want = (len(_sl), sum(int(r['bytes']) for r in _sl), _sc['unread-data-ref'], _sc['read-ref'], _sc['code-ref'], _sc['none'])
        if not mm: bad('kitty', 'roms/hello_kitty/README.md no longer quotes assets/sprite_layouts_unread_kitty.csv (need=N layouts (B bytes) are never read in the runs ... a ... b ... c only from code, d by nothing)')
        elif tuple(int(x.replace(',', '')) for x in mm.groups()) != want: bad('kitty', 'roms/hello_kitty/README.md: sprite layouts quoted %s, the table gives %s' % (mm.groups(), want))
        else: ok('kitty', 'never-read sprite layouts quoted as in the table (%d)' % len(_sl))
        # the screens the core runs reach (tools/kitty_modes_seen.py): the counts quoted in the Kitty README
        _ms = list(csv.DictReader(open(KD + 'trace/modes_seen_kitty.csv'))); want = (len(_ms), sum(r['check'] == 'end' for r in _ms), sum(r['check'] != 'end' for r in _ms))
        mm = re.search(r'modes_seen_kitty\.csv\)?, written by `tools/kitty_modes_seen\.py` from the four corpora: (\d+) \(mode, state\) pairs.*?; (\d+) of them end on their pair when replayed from a cold boot in the core, (\d+) ', open(KD + 'README.md', encoding='utf-8').read())   # need= the screens-reached bullet
        if not mm: bad('kitty', 'roms/hello_kitty/README.md no longer quotes trace/modes_seen_kitty.csv (need=written by `tools/kitty_modes_seen.py` from the four corpora: N (mode, state) pairs ...; a of them end on their pair when replayed from a cold boot in the core, b ...)')
        elif tuple(int(x) for x in mm.groups()) != want: bad('kitty', 'roms/hello_kitty/README.md: screens reached quoted %s, trace/modes_seen_kitty.csv gives %s' % (mm.groups(), want))
        elif any(not r['keys'] or len(r['keys']) != 2 * int(r['frames']) for r in _ms): bad('kitty', 'trace/modes_seen_kitty.csv: a row whose key history does not have one byte per frame')
        else: ok('kitty', 'screens reached quoted as in trace/modes_seen_kitty.csv (%d pairs)' % want[0])
        # the never-run code (tools/kitty_red_classes.py, tools/kitty_gates.py): the classes quoted in the Kitty README
        _rc = list(csv.DictReader(open(KD + 'trace/red_classes_kitty.csv', encoding='utf-8'))); _ng = len(list(csv.DictReader(open(KD + 'trace/gates_kitty.csv'))))
        _cl = ['effect', 'gate', 'forced-mode', 'not-run']; want = tuple([sum(int(r['red_bytes']) for r in _rc), _ng] + [sum(int(r[c]) for r in _rc) for c in _cl])
        mm = re.search(r'never-run code \(.*?\.\*\* ([\d,]+) bytes of the trace never ran.*?lists the (\d+) executed conditional branches.*?\* ([\d,]+) bytes, effect:.*?\* ([\d,]+) bytes, gate:.*?\* ([\d,]+) bytes, forced-mode:.*?\* ([\d,]+) bytes, not-run:', open(KD + 'README.md', encoding='utf-8').read(), re.S)   # need= the never-run paragraph
        if not mm: bad('kitty', 'roms/hello_kitty/README.md no longer quotes trace/red_classes_kitty.csv (need=never-run code (...).** N bytes of the trace never ran ... lists the G executed conditional branches ... * a bytes, effect: ... * b bytes, gate: ... * c bytes, forced-mode: ... * d bytes, not-run:)')
        elif tuple(int(x.replace(',', '')) for x in mm.groups()) != want: bad('kitty', 'roms/hello_kitty/README.md: never-run code quoted %s, the tables give %s' % (mm.groups(), want))
        else: ok('kitty', 'never-run code classes quoted as in trace/red_classes_kitty.csv (%d bytes)' % want[0])
        # the doubts list (tools/kitty_doubts.py): fresh, and its counts quoted in the Kitty README
        r7 = _run('tools/kitty_doubts.py', '--check')
        if r7.returncode: bad('kitty', 'disasm/sym_unconclusive_kitty.{csv,md}: %s (rerun tools/kitty_doubts.py)' % (r7.stderr or r7.stdout).strip()[-300:])
        else:
            ok('kitty', 'doubts list sym_unconclusive_kitty fresh')
            _dg = collections.Counter(r['group'] for r in csv.DictReader(open(KD + 'disasm/sym_unconclusive_kitty.csv')))
            mm = re.search(r'Doubts list \([^)]*\)\.\*\* (\d+) names: (\d+) in modes reached only by forcing, (\d+) in states the runs did not reach, (\d+) settled as unused', open(KD + 'README.md').read())   # need= the doubts bullet
            if not mm: bad('kitty', 'roms/hello_kitty/README.md no longer quotes the doubts list (need=Doubts list (...).** N names: a in modes reached only by forcing, b in states the runs did not reach, c settled as unused)')
            elif tuple(int(x) for x in mm.groups()) != (sum(_dg.values()), _dg['forced only'], _dg['not run'], _dg['unused']):
                bad('kitty', 'roms/hello_kitty/README.md: doubts quoted %s, the list gives %d / %d / %d / %d' % (mm.group(0)[-90:], sum(_dg.values()), _dg['forced only'], _dg['not run'], _dg['unused']))
        # the reachability picture (tools/reach_map.py --tag kitty): redrawn and compared, its counts quoted in the Kitty README
        # the classification of the red bytes (tools/red_classify.py, roadmap item 4): regenerated and compared, its total quoted in the README
        rc = _run('tools/red_classify.py', '--tag', 'kitty', A.rom_kitty, '--out', os.path.join(tk, 'red.csv'))
        mrc = re.search(r'kitty_red: (\d+) bytes in (\d+) pieces: (.*)', rc.stdout)
        if rc.returncode or not mrc: bad('kitty', 'tools/red_classify.py --tag kitty failed: %s' % (rc.stderr or rc.stdout)[-300:])
        elif open(os.path.join(tk, 'red.csv'), 'rb').read() != open(KD + 'trace/red_kitty.csv', 'rb').read(): bad('kitty', 'trace/red_kitty.csv is not what tools/red_classify.py makes today: rerun it')
        else:
            qq = re.search(r'Classified \(2026-11-12, `tools/red_classify.py`\)\.\*\* ([\d,]+) bytes in ([\d,]+) pieces', open(KD + 'README.md').read())
            if not qq or (int(qq.group(1).replace(',', '')), int(qq.group(2).replace(',', ''))) != (int(mrc.group(1)), int(mrc.group(2))):
                bad('kitty', 'roms/hello_kitty/README.md does not quote the red classification (%s bytes in %s pieces)' % (mrc.group(1), mrc.group(2)))
            else: ok('kitty', 'trace/red_kitty.csv fresh: %s' % mrc.group(3))
        rp = os.path.join(tk, 'reach.png'); r5 = _run('tools/reach_map.py', '--tag', 'kitty', A.rom_kitty, rp)
        m5 = re.search(r'kitty_reach: blue (\d+), red (\d+), grey-blue (\d+), orange (\d+)', r5.stdout)
        if r5.returncode or not m5: bad('kitty', 'tools/reach_map.py --tag kitty failed: %s' % (r5.stderr or r5.stdout)[-300:])
        else:
            if '](kitty_rom_reachability_map.png)' not in open(KD + 'README.md').read(): bad('maps', 'roms/hello_kitty/README.md does not show kitty_rom_reachability_map.png')
            if not same_png(rp, KD + 'kitty_rom_reachability_map.png'): bad('kitty', 'kitty_rom_reachability_map.png is not what tools/reach_map.py --tag kitty draws today: rerun it')
            else: ok('kitty', 'kitty_rom_reachability_map.png fresh')
            KR = open(KD + 'README.md').read()
            for what, pat, val in (('red bytes', r'([\d,]+) bytes of proven code never executed \(red', m5.group(2)), ('grey-blue bytes', r'([\d,]+) bytes of data never read and explained by nothing \(grey-blue', m5.group(3)),
                                   ('orange bytes', r'([\d,]+) bytes never read but explained by a loader site or a table \(orange', m5.group(4)), ('blue bytes', r'([\d,]+) bytes executed or read \(blue', m5.group(1))):
                mm = re.search(pat, KR)     # need= the sentence of the L2 section, What is still missing
                if not mm: bad('kitty', 'roms/hello_kitty/README.md no longer quotes the %s of the reachability map (need=%s)' % (what, pat))
                elif int(mm.group(1).replace(',', '')) != int(val): bad('kitty', 'roms/hello_kitty/README.md: %s quoted %s, tools/reach_map.py --tag kitty gives %s' % (what, mm.group(1), val))
    shutil.rmtree(tk, ignore_errors=True)
# ------------------------------------------------------------------ the early prototype (image as dumped): L1 pipeline (SETUP.md, prototype)
if A.rom_proto:
    PD = 'roms/prototype_debagame/'; tp = tempfile.mkdtemp(prefix='proto_')
    def _runp(*cmd): return subprocess.run([sys.executable] + list(cmd), capture_output=True, text=True)
    j = lambda n: os.path.join(tp, n)
    p0 = _runp('tools/proto_symtab.py', A.rom_proto, '--out', j('st.csv'), '--out-mem', j('stm.csv'))
    p1 = _runp('tools/proto_trace.py', A.rom_proto, j('t.json'), '--roots', PD + 'trace/extra_roots_proto.json', '--report', j('u.md')) if not p0.returncode else p0
    p2 = _runp('tools/proto_types.py', A.rom_proto, j('t.json'), '--types', j('ty.csv'), '--sites', j('cs.csv'), '--rommap', j('rm.csv'),
               '--names', j('na.csv'), '--symtab', j('st.csv')) if not p1.returncode else p1
    p2b = _runp('tools/proto_match_old.py', A.rom_proto, j('st.csv'), j('t.json'), j('mo.csv')) if not p2.returncode else p2      # L3
    p2l = _runp('tools/proto_printer_lib.py', A.rom_proto, A.rom or '/root/work/roms/pocketcamera_jp.gb', '--symtab', j('st.csv'), '--out', j('pl.csv'))     # the old builds' printer library
    p2o = _runp('tools/proto_oldbuilds.py', A.rom_proto, '--symtab', j('st.csv'), '--printer-lib', j('pl.csv'), '--out', j('ob.csv'))     # the older builds' bank 0 (roadmap step 5)
    p2c = _runp('tools/proto_names.py', '--auto', j('na.csv'), '--match', j('mo.csv'), '--symtab', j('st.csv'), '--symtab-mem', j('stm.csv'), '--printer-lib', j('pl.csv'), '--oldbuilds', j('ob.csv'), '--trace', j('t.json'),
                '--types', j('ty.csv'), '--rom', A.rom_proto, '--out', j('nm.csv'), '--doubts', j('dq.md'), '--texts', j('tx.csv')) if not p2b.returncode else p2b
    if p2c.returncode: p2 = p2c
    p3 = _runp('tools/sym_build.py', A.rom_proto, '--names', j('nm.csv'), '--types', j('ty.csv'), '--trace', j('t.json'),
               '--out', j('p.sym'), '--report') if not p2.returncode else p2
    if p3.returncode: bad('proto', 'the prototype pipeline failed: %s' % (p3.stderr or p3.stdout)[-300:])
    else:
        stale = [f for f, g in (('disasm/leftover_symtab_proto.csv', 'st.csv'), ('trace/trace_proto.json', 't.json'), ('trace/trace_proto_unresolved.md', 'u.md'),
                                ('disasm/sym_types_proto.csv', 'ty.csv'), ('assets/copy_sites_proto.csv', 'cs.csv'), ('trace/rom_map_proto.csv', 'rm.csv'),
                                ('disasm/layers/sym_names_proto_auto.csv', 'na.csv'), ('disasm/match_old_proto.csv', 'mo.csv'),
                                ('disasm/sym_names_proto.csv', 'nm.csv'), ('disasm/sym_unconclusive_proto.md', 'dq.md'), ('disasm/sym_unconclusive_proto.csv', 'dq.csv'), ('disasm/sym_settled_unused_proto.csv', 'sym_settled_unused_proto.csv'), ('disasm/leftover_symtab_mem_proto.csv', 'stm.csv'), ('disasm/printer_lib_proto.csv', 'pl.csv'), ('disasm/oldbuilds_proto.csv', 'ob.csv'), ('assets/text_sections_proto.csv', 'tx.csv'), ('pocketcamera_proto.sym', 'p.sym'))
                 if not os.path.exists(PD + f) or open(PD + f, 'rb').read() != open(j(g), 'rb').read()]
        if stale: bad('proto', 'not what the prototype pipeline makes today (SETUP.md, prototype): %s' % ', '.join(stale))
        else: ok('proto', 'symbol tables, trace, types, copy sites, byte classes, old-build matches, names, doubts list and pocketcamera_proto.sym fresh')
        mn = re.search(r"proto_names: (\d+) names, tags \{([^}]*)\}; routine entries (\d+), unnamed (\d+)", p2c.stdout)
        tg = dict((k.strip(" '"), int(v)) for k, v in (x.split(':') for x in mn.group(2).split(','))) if mn else {}
        mm = re.search(r'([\d,]+) names \(C ([\d,]+) / I ([\d,]+) / \? ([\d,]+)\)', rd(PD + 'README.md'))
        if not mn: bad('proto', 'tools/proto_names.py printed no summary')
        elif not mm: bad('proto', 'roms/prototype_debagame/README.md no longer quotes the name count (need=N names (C a / I b / ? c))')
        elif [int(x.replace(',', '')) for x in mm.groups()] != [int(mn.group(1)), tg.get('C', 0), tg.get('I', 0), tg.get('?', 0)]:
            bad('proto', 'roms/prototype_debagame/README.md: names quoted %s, tools/proto_names.py gives %s' % (mm.group(0), mn.group(0)))
        if mn and int(mn.group(4)): bad('proto', 'routine entries left unnamed: %s' % mn.group(0))
        PR = rd(PD + 'README.md')
        m1 = re.search(r'proto_trace: (\d+) instructions, (\d+) code bytes, (\d+) inline table bytes, (\d+) banked calls / jumps resolved, (\d+) unresolved', p1.stdout)
        m2 = re.search(r'proto_types: .*?\((\d+) text bytes in (\d+) rows', p2.stdout)
        m3 = re.search(r'bytes by type: (\{.*\})', p3.stdout); m4 = re.search(r'still on the default typing \(\.data, 16 per row\): (\d+)', p3.stdout)
        BYP = eval(m3.group(1)); typedp = BYP['data'] - int(m4.group(1))
        for what, val, pat in (('instructions', int(m1.group(1)), r'([\d,]+) instructions'), ('code bytes', int(m1.group(2)), r'([\d,]+) bytes of proven code'),
                               ('unresolved', int(m1.group(5)), r'([\d,]+) indirect sites left unresolved'), ('padding', BYP['padding'], r'([\d,]+) bytes of padding'),
                               ('text', BYP['text'], r'([\d,]+) bytes of leftover text'), ('text rows', int(m2.group(2)), r'leftover text in ([\d,]+) blocks'),
                               ('typed data', typedp, r'([\d,]+) bytes of data typed by a reason'), ('default data', int(m4.group(1)), r'([\d,]+) bytes of data on the default typing')):
            mm = re.search(pat, PR)     # need= the L1 section of roms/prototype_debagame/README.md
            if not mm: bad('proto', 'roms/prototype_debagame/README.md no longer quotes the %s (need=%r)' % (what, pat))
            elif int(mm.group(1).replace(',', '')) != val: bad('proto', 'roms/prototype_debagame/README.md: %s quoted %s, the tools give %d' % (what, mm.group(1), val))
        # L2: the union of the core runs against the trace (tools/proto_observed.py), and the BGB replays (tools/proto_bgb_replay.py)
        p4 = _runp('tools/proto_observed.py', A.rom_proto, PD + 'trace/trace_proto.json', PD + 'trace/cov_proto_runs.npz', '--report', j('ob.md'))
        if p4.returncode: bad('proto', 'tools/proto_observed.py failed: %s' % (p4.stderr or p4.stdout)[-300:])
        else:
            if open(PD + 'trace/observed_proto.md', 'rb').read() != open(j('ob.md'), 'rb').read(): bad('proto', 'trace/observed_proto.md is not what tools/proto_observed.py writes today')
            else: ok('proto', 'observed_proto.md fresh')
            prc = _runp('tools/red_classify.py', '--tag', 'proto', A.rom_proto, '--out', j('red.csv'))      # the classification of the red bytes
            mprc = re.search(r'proto_red: (\d+) bytes in (\d+) pieces', prc.stdout)
            if prc.returncode or not mprc or open(j('red.csv'), 'rb').read() != open(PD + 'trace/red_proto.csv', 'rb').read(): bad('proto', 'trace/red_proto.csv is not what tools/red_classify.py makes today: rerun it')
            elif not re.search(r'Classified \(2026-11-12, `tools/red_classify.py`\)\.\*\* %s bytes in %s pieces' % (format(int(mprc.group(1)), ','), mprc.group(2)), open(PD + 'README.md').read()):
                bad('proto', 'roms/prototype_debagame/README.md does not quote the red classification (%s bytes in %s pieces)' % mprc.groups())
            else: ok('proto', 'trace/red_proto.csv fresh')
            p5 = _runp('tools/reach_map.py', '--tag', 'proto', A.rom_proto, j('reach.png'))      # the coverage map, shown in roms/prototype_debagame/README.md
            if p5.returncode: bad('proto', 'tools/reach_map.py --tag proto failed: %s' % (p5.stderr or p5.stdout)[-300:])
            elif not same_png(j('reach.png'), PD + 'proto_rom_reachability_map.png'): bad('proto', 'proto_rom_reachability_map.png is not what tools/reach_map.py --tag proto draws today: rerun it')
            elif '](proto_rom_reachability_map.png)' not in PR: bad('proto', 'roms/prototype_debagame/README.md does not show proto_rom_reachability_map.png')
            else: ok('proto', 'proto_rom_reachability_map.png fresh and shown')
            mo = re.search(r'proto_observed: (\d+) of (\d+) instructions ran, (\d+) of (\d+) code bytes, (\d+) executed bytes outside the trace', p4.stdout)
            bg = list(csv.DictReader(open(PD + 'trace/bgb_game_seq_proto.csv')))
            for what, val, pat in (('instructions run', int(mo.group(1)), r'([\d,]+) of the [\d,]+ traced instructions ran'),
                                   ('code bytes run', int(mo.group(3)), r'([\d,]+) of the [\d,]+ bytes of proven code;'),
                                   ('bytes outside the trace', int(mo.group(5)), r'([\d,]+) executed bytes lie outside the trace'),
                                   ('BGB replays matching', sum(1 for r in bg if r['match'] == 'yes'), r'([\d,]+) of [\d,]+ replays end on'),
                                   ('BGB replays', len(bg), r'[\d,]+ of ([\d,]+) replays end on')):
                mm = re.search(pat, PR)     # need= the L2 section of roms/prototype_debagame/README.md
                if not mm: bad('proto', 'roms/prototype_debagame/README.md no longer quotes the %s (need=%r)' % (what, pat))
                elif int(mm.group(1).replace(',', '')) != val: bad('proto', 'roms/prototype_debagame/README.md: %s quoted %s, the files give %d' % (what, mm.group(1), val))
        if A.roundtrip:      # the image as dumped rebuilds only without rgbfix (its header was never fixed: prototype README, L0)
            rt = tempfile.mkdtemp(prefix='protort_'); shutil.copy(A.rom_proto, os.path.join(rt, 'pocketcamera_proto.gb')); shutil.copy(PD + 'pocketcamera_proto.sym', rt)
            r_ = subprocess.run([sys.executable, '/home/claude/tc/mgbdis/mgbdis.py', '--output-dir', os.path.join(rt, 'out'), os.path.join(rt, 'pocketcamera_proto.gb')], capture_output=True, text=True)
            if not r_.returncode:
                mk = os.path.join(rt, 'out', 'Makefile'); txt_ = open(mk).read().split('\n')
                open(mk, 'w').write('\n'.join(l for l in txt_ if not l.strip().startswith('rgbfix')))
            env_ = dict(os.environ, PATH='/home/claude/tc/rgbds:' + os.environ.get('PATH', ''))
            r_ = subprocess.run(['make'], cwd=os.path.join(rt, 'out'), capture_output=True, text=True, env=env_) if not r_.returncode else r_
            gb = os.path.join(rt, 'out', 'game.gb')
            md = hashlib.md5(open(gb, 'rb').read()).hexdigest() if os.path.exists(gb) else 'none'
            if md != '19b50a5f67ef4f0d015e7d813370756e': bad('proto', 'round trip with pocketcamera_proto.sym (no rgbfix): md5 %s' % md)
            else: ok('proto', 'round trip with pocketcamera_proto.sym (no rgbfix): md5 %s' % md)
            shutil.rmtree(rt, ignore_errors=True)
    shutil.rmtree(tp, ignore_errors=True)
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
            if not same_png(cmp_png, os.path.join(tmp, 'x.png')): bad('yellow', 'jp_rom_reachability_map.png is stale: run tcrf_check/tools/rom_reach_map.py (and rom_layout_map.py)')
            else: ok('yellow', 'roms/jp_rev_a/jp_rom_reachability_map.png fresh')
    shutil.rmtree(tmp, ignore_errors=True)
else:
    skip('yellow', 'no --rom: yellow bytes and the reachability picture not checked')
# layout map: the picture, the per-bank csv and the sentences of the README that quote its legend (needs the ROM)
if A.rom:
    tmp = tempfile.mkdtemp(prefix='cons_l_')
    r = subprocess.run([sys.executable, 'tcrf_check/tools/rom_layout_map.py', os.path.join(tmp, 'l.png'), '--rom', A.rom, '--csv', os.path.join(tmp, 'l.csv')], capture_output=True, text=True)
    if r.returncode: bad('layout', 'rom_layout_map.py failed: %s' % (r.stderr or r.stdout).strip()[-200:])
    else:
        if not same_png(os.path.join(tmp, 'l.png'), P('roms/jp_rev_a/jp_rom_layout_map.png')): bad('layout', 'jp_rom_layout_map.png is stale: run tcrf_check/tools/rom_layout_map.py OUT.png --rom ROM')
        if open(os.path.join(tmp, 'l.csv'), 'rb').read() != open(P('roms/jp_rev_a/assets/layout_by_bank_jp.csv'), 'rb').read(): bad('layout', 'roms/jp_rev_a/assets/layout_by_bank_jp.csv is stale: run rom_layout_map.py --csv roms/jp_rev_a/assets/layout_by_bank_jp.csv')
        K = {m.group(1): num(m.group(2)) for m in re.finditer(r'^([A-Z_]+)\s+([\d,]+)\s+[\d.]+ %', r.stdout, re.M)}
        tiles = K['T_UI'] + K['T_STP'] + K['T_FRM'] + K['T_PHO']
        mk = re.search(r'marks \[(\d+), (\d+), (\d+), (\d+)\]', r.stdout); pt = re.search(r'pure padding tiles (\d+) (\d+) B', r.stdout)
        ov = re.search(r"layout overrides (\d+) rows \{(.*?)\} bytes (\d+)", r.stdout); OV = eval('{' + ov.group(2) + '}'); OVN, OVB = int(ov.group(1)), int(ov.group(3))
        n += quoted('layout legend', r'\*\*Code\*\* \(([\d,]+) B, ', lambda m: ((K['SYS'] + K['CAM'] + K['ALBUM'] + K['EDIT'] + K['LINK'] + K['PRINT'] + K['GAME'] + K['DJ'] + K['UI'] + K['SND'] + K['OTHER'],), (num(m.group(1)),)), docs=('README.md',), need=('README.md',))
        n += quoted('layout legend', r'tile sets ([\d,]+) B \(\d+\.\d %: ([\d,]+) B screens, menus, fonts, sprites and the SGB border; ([\d,]+) B stamps; ([\d,]+) B print frames and photo borders; ([\d,]+) B the 30 stock photos',
                    lambda m: ((tiles, K['T_UI'], K['T_STP'], K['T_FRM'], K['T_PHO']), tuple(num(m.group(i)) for i in range(1, 6))), docs=('README.md',), need=('README.md',))
        n += quoted('layout legend', r'tile maps ([\d,]+) B \(\d+\.\d %\), sprite layouts ([\d,]+) B, sound data ([\d,]+) B, palettes ([\d,]+) B \(.*?\), other tables and text ([\d,]+) B \(.*?\), \*\*uncertain ([\d,]+) B\*\*, `\$FF` fill ([\d,]+) B \(\d+\.\d %\), and padding ([\d,]+) B \(',
                    lambda m: ((K['MAP'], K['OAM'], K['SOUND'], K['PALT'], K['TBL'], K['UNC'], K['FILL'], K['PAD']), tuple(num(m.group(i)) for i in range(1, 9))), docs=('README.md',), need=('README.md',))
        n += quoted('layout legend', r'\(([\d,]+) tiles, ([\d,]+) B of the padding;', lambda m: ((int(pt.group(1)), int(pt.group(2))), (num(m.group(1)), num(m.group(2)))), docs=('README.md',), need=('README.md',))
        n += quoted('layout legend', r'unused code \(black, ([\d,]+) B\), unused assets documented by TCRF \(orange, ([\d,]+) B\), unused assets not documented by TCRF \(cyan, ([\d,]+) B\)',
                    lambda m: (tuple(int(x) for x in mk.groups()[:3]), tuple(num(m.group(i)) for i in range(1, 4))), docs=('README.md',), need=('README.md',))
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

# ------------------------------------------------------------------ reachability maps of the ported builds (tools/reach_map.py, the legend of the Japanese map)
for _t, _f, _r in (('us', 'us_eu', A.rom_us), ('gold', 'gold', A.rom_gold)):
    if not _r: continue
    _tmp = tempfile.mkdtemp(prefix='reach_'); _p = os.path.join(_tmp, 'r.png')
    _m = subprocess.run([sys.executable, 'tools/reach_map.py', '--tag', _t, _r, _p], capture_output=True, text=True)
    if _m.returncode: bad('maps', 'tools/reach_map.py --tag %s failed: %s' % (_t, (_m.stderr or _m.stdout)[-300:]))
    elif not same_png(_p, 'roms/%s/%s_rom_reachability_map.png' % (_f, _t)): bad('maps', 'roms/%s/%s_rom_reachability_map.png is not what tools/reach_map.py --tag %s draws today: rerun it' % (_f, _t, _t))
    elif '](%s_rom_reachability_map.png)' % _t not in rd('roms/%s/README.md' % _f): bad('maps', 'roms/%s/README.md does not show %s_rom_reachability_map.png' % (_f, _t))
    else: ok('maps', 'roms/%s/%s_rom_reachability_map.png fresh and shown' % (_f, _t))
    shutil.rmtree(_tmp, ignore_errors=True)
# ------------------------------------------------------------------ status words (HOWTO_NEW_ROM.md section 0): L3 is `done` only with no placeholder name
_PH = re.compile(r'^(Data|Code|Gfx|Map|Src|JumpTable|Unk)_[0-9A-F]{2}_[0-9A-F]{4}$'); _nf = len(FAIL)
for _f, _t in (('jp_rev_a', 'jp'), ('us_eu', 'us'), ('gold', 'gold'), ('hello_kitty', 'kitty'), ('prototype_debagame', 'proto')):
    _n = sum(1 for r in csv.DictReader(io.StringIO(rd('roms/%s/disasm/sym_names_%s.csv' % (_f, _t)))) if _PH.match(r['name']))
    _rd = rd('roms/%s/README.md' % _f)
    _l3 = re.search(r'^\| L3 \| (done|partial|not started)', _rd, re.M)
    if not _l3: bad('status', 'roms/%s/README.md has no Levels row for L3' % _f); continue
    if _n and _l3.group(1) == 'done': bad('status', 'roms/%s/README.md says L3 done, but %d names are placeholders' % (_f, _n))
    elif _n:
        for _doc in ('roms/%s/README.md' % _f, 'README.md'):
            _q = [int(x.replace(',', '')) for x in re.findall(r'([\d,]+) placeholder (?:data )?names', rd(_doc))] if _doc != 'README.md' else None
            if _q is not None and _n not in _q: bad('status', '%s: placeholder names quoted %s, sym_names_%s.csv has %d' % (_doc, _q, _t, _n))
        if not re.search(r'\b%s placeholder' % _n, README): bad('status', 'README.md does not quote the %d placeholder names of %s' % (_n, _t))
if len(FAIL) == _nf: ok('status', 'L3 status words agree with the placeholder names of every ROM')
# ------------------------------------------------------------------ the level of each ROM: its README, ROADMAP.md and the summary of README.md agree
_LV = ('L0', 'L1', 'L2', 'L3', 'L4', 'L5', 'L6'); _nf2 = len(FAIL)
def _levels(text, start=None):
    out = {}
    if start: text = text[text.index(start):]
    for m in re.finditer(r'^\| (L\d)(?:-(L\d))? \| (done|partial|not started)\b', text, re.M):
        a_, b_ = int(m.group(1)[1]), int((m.group(2) or m.group(1))[1])
        for k in range(a_, b_ + 1): out.setdefault('L%d' % k, m.group(3))
        if b_ < a_: pass
    return out
_RM = rd('ROADMAP.md'); _RD = rd('README.md')
for _f, _title in (('jp_rev_a', 'Pocket Camera (Japan) (Rev A)'), ('us_eu', 'Game Boy Camera (USA, Europe)'), ('gold', 'Game Boy Camera Gold (USA)'),
                   ('hello_kitty', 'Pocket Camera (Hello Kitty)'), ('prototype_debagame', 'Pocket Camera Prototype (Japan) ("DEBAGAME")')):
    _own = _levels(rd('roms/%s/README.md' % _f))
    _sec = _RM.split('\n## ')
    _road = next((_levels(x) for x in _sec if x.startswith(_title)), {})
    _m = re.search(r'^\| %s \| ([^\n]+)\|$' % re.escape(_title), _RD, re.M)
    _sum = dict(zip(_LV, [c.strip() for c in _m.group(1).split('|')])) if _m else {}
    for _l in _LV:
        _v = {_own.get(_l), _road.get(_l), _sum.get(_l)}
        if len(_v) != 1 or None in _v: bad('levels', '%s %s: README of the ROM says %s, ROADMAP.md %s, README.md summary %s' % (_f, _l, _own.get(_l), _road.get(_l), _sum.get(_l)))
if len(FAIL) == _nf2: ok('levels', 'the levels of the five ROMs agree in their READMEs, ROADMAP.md and the README.md summary')
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
        old = [b for b in bl if not same_png(os.path.join(tmp, 'bank_%s.png' % b), os.path.join(bd, 'bank_%s.png' % b))]
        for b in old: bad('bankpics', 'roms/jp_rev_a/disasm/sym_unconclusive_banks/bank_%s.png is stale: run tools/bank_pics.py ROM roms/jp_rev_a/disasm/sym_names_jp.csv roms/jp_rev_a/disasm/sym_unconclusive_banks %s' % (b, ' '.join(bl)))
        if not old: ok('bankpics', '%d bank pictures fresh' % len(bl))
    shutil.rmtree(tmp, ignore_errors=True)
else:
    skip('bankpics', 'no --rom: bank pictures not checked')

# ------------------------------------------------------------------ the 96 effect slots (docs §16.28)
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
        if not m: bad('effects', 'docs §16.28: no sentence matches %r (reword it or fix the checker)' % desc); ef_bad += 1; continue
        exp = tuple(facts[k] for k in keys); got = tuple(int(g) for g in m.groups())
        if exp != got: bad('effects', 'docs §16.28 %s: says %s, %s says %s %s' % (desc, got, EF_CSV, keys, exp)); ef_bad += 1
    if facts['identity'] + facts['identity except table byte'] != facts['slots that write']: bad('effects', 'a writing slot is neither an identity nor the table-byte case'); ef_bad += 1
cited = set()
for r in NAMES:
    for f in re.findall(r'tcrf_check/[\w./\-]*[\w]\.(?:csv|png|py|md)\b', r['note']): cited.add(f)
for f in sorted(cited):
    if not os.path.exists(P(f)): bad('effects', 'a label note cites %s, which does not exist' % f); ef_bad += 1
if not ef_bad: ok('effects', '96 slots, %s; %d tcrf_check files cited by label notes exist' % (', '.join('%s %d' % (k, v) for k, v in facts.items()), len(cited)))

# ------------------------------------------------------------------ RAM names (L4, docs §2.13)
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
for r in csv.DictReader(io.StringIO(rd('roms/jp_rev_a/wram/wram_access_jp.csv'))):
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
    quoted('ram sites', r'resolves? every access of `roms/jp_rev_a/wram/wram_access_jp.csv` \(([\d,]+) instruction sites\)', lambda m: ((len(acc_sites),), (num(m.group(1)),)), docs=('README.md',), need=('README.md',))
    quoted('ram exclusions', r'([\d,]+) pointer loads of the table are numbers that only look like addresses', lambda m: ((len(RAM_EXCL),), (num(m.group(1)),)), docs=('README.md',), need=('README.md',))

# ------------------------------------------------------------------ first readers of the forced-only data bytes (docs §16.24)
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

# ------------------------------------------------------------------ 26:7080 and the printing of Album B (docs §16.25.2)
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
        romb = open(A.rom, 'rb').read(); trc = json.loads(rd('roms/jp_rev_a/trace/trace_jp.json'))['code']
        cov_b = set()
        for k_, L_ in trc.items():
            b_ = int(k_[:2], 16); a_ = int(k_[3:], 16); o_ = a_ if b_ == 0 else b_ * 0x4000 + a_ - 0x4000; cov_b.update(range(o_, o_ + L_))
        occ = [i for i in range(len(romb) - 1) if romb[i] == 0x80 and romb[i + 1] == 0x70]
        touch = sum(1 for i in occ if i in cov_b or i + 1 in cov_b)
        ok('printwatch', 'the byte pair 80 70 occurs %d times in the ROM, %d of them touch a proven instruction byte' % (len(occ), touch))
        quoted('print watch', r'the byte pair `80 70` occurs (\d+) times in the ROM, never inside a proven instruction', lambda m: ((len(occ),), (int(m.group(1)),)), docs=('README.md',), need=('README.md',))
        if touch: bad('printwatch', '%d occurrences of 80 70 touch a proven instruction, the README says never' % touch)
    if cov[3] != 576 or cov[4] != 576: bad('printwatch', '26:4C80 / 26:72C0 organic reads are %d / %d of 576, the README says 576 each' % (cov[3], cov[4]))

# ------------------------------------------------------------------ 26:7080 seam search at every byte offset (docs §16.25.2)
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

# ------------------------------------------------------------------ 26:7080 pattern of repeated ids against every map window (docs §16.25.2)
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

# ------------------------------------------------------------------ 26:7080 against the tiles of the hand-newspaper span 11:5800 (docs §16.25.2)
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

# ------------------------------------------------------------------ the ball head animation is stored twice: two collars for two bodies (docs §16.24)
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

# ------------------------------------------------------------------ nothing draws the OAM list $BA of the hand flipping a newspaper (docs §16.24)
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

# ------------------------------------------------------------------ the main menu turning its page, the whole screen (docs §16.24)
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

# ------------------------------------------------------------------ what STAT handler 1 splits (docs §2, interrupt map)
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

# ------------------------------------------------------------------ RAM runtime check (BGB, docs §2.13)
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

# ------------------------------------------------------------------ constants (L4, docs §2.14)
import const_names as CN
CN_BAD = 0
try:
    C_ROWS = CN.load_names(P('roms/jp_rev_a/disasm/const_names_jp.csv')); C_TYPES = CN.load_types(P('roms/jp_rev_a/disasm/const_types_jp.csv')); C_TABS = CN.load_tables(P('roms/jp_rev_a/disasm/const_tables_jp.csv'))
    S_ROWS = CN.load_sounds(P('roms/jp_rev_a/disasm/sound_names_jp.csv')); ST_ROWS = CN.load_states(P('roms/jp_rev_a/disasm/state_names_jp.csv')); CN.check_unique(C_ROWS + ST_ROWS + S_ROWS)
except Exception as e:
    C_ROWS = []; S_ROWS = []; ST_ROWS = []; C_TYPES = {}; C_TABS = []; bad('const', 'the constant tables do not load: %s' % e); CN_BAD += 1
CNAMER = CN.Namer(C_ROWS + ST_ROWS + S_ROWS)
# state constants (docs §2.14): roms/jp_rev_a/disasm/state_names_jp.csv must be what tools/state_names.py makes from the state tables and the handler labels
if A.rom:
    r = subprocess.run([sys.executable, 'tools/state_names.py', '--rom', A.rom, '--check'], capture_output=True, text=True)
    if r.returncode: bad('const', 'roms/jp_rev_a/disasm/state_names_jp.csv is stale: run tools/state_names.py --rom ROM'); CN_BAD += 1
# text table (docs §16.27): roms/jp_rev_a/disasm/charmap_jp.inc must be what tools/charmap_jp.py makes from roms/jp_rev_a/disasm/charset_jp.csv
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
    if r.group not in ('mode', 'sndch', 'dmgpal'): bad('const', '%s: group %s has no name table (the flag groups use the names of hardware.inc, the sound ids are in sound_names_jp.csv)' % (r.name, r.group)); CN_BAD += 1
if set(C_MODES) != set(range(0x22)) | {0x22, 0xFF} or C_MODES[0x22].name != 'MODE_COUNT' or C_MODES[0xFF].name != 'MODE_NONE':
    bad('const', 'the mode group must name $00-$21 and MODE_COUNT ($22), MODE_NONE ($FF)'); CN_BAD += 1
else:
    for m in range(0x22):    # the name of a mode is the name of its entry label in the mode table 00:2F3F
        if CROM:
            o = 0x2F3F + 3 * m; entry = LABEL_AT.get((CROM[o + 2], CROM[o] | CROM[o + 1] << 8))
        else: entry = next((n for n in NAMESET if re.fullmatch('Mode%02X_\\w+' % m, n) and 'MODE_' + snake(n[7:]) == C_MODES[m].name), None)
        if not entry or not re.fullmatch('Mode%02X_\\w+' % m, entry) or 'MODE_' + snake(entry[7:]) != C_MODES[m].name:
            bad('const', 'mode $%02X is %s, but its entry label is %s (the constant is the label without its number, in capitals)' % (m, C_MODES[m].name, entry)); CN_BAD += 1
C_HW = {'rLCDC', 'rIE', 'rSC', 'rP1', 'rBGP', 'rOBP0', 'rOBP1'}
C_GROUPS = {'mode', 'sndch', 'dmgpal'} | set(CN.FLAGS) | set(CN.EXACT) | set(CN.SOUND_GROUPS)
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

# ------------------------------------------------------------------ sound names (L4, docs §2.14 and 16.24)
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
                # mgbdis' own labels left in the listing (docs §1.1: L5 row): `jr_` targets are normal, a `Jump_` / `Call_` one is a jump / call target that still has no name
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
                subprocess.run([sys.executable, 'tools/sym_fix.py', d, '--tables', '--rom', A.rom, '--sym', 'roms/jp_rev_a/pocketcamera_jp.sym', '--trace', 'roms/jp_rev_a/trace/trace_jp.json'], capture_output=True, text=True)
            else:
                shutil.copytree(os.path.join(tmp, 'hex'), d); [os.remove(os.path.join(d, f)) for f in os.listdir(d) if f.endswith('.o') or f == 'game.gb']
                sf = subprocess.run([sys.executable, 'tools/sym_fix.py', d, '--tables', '--const' if variant == 'const' else '--ram', '--rom', A.rom, '--sym', 'roms/jp_rev_a/pocketcamera_jp.sym', '--trace', 'roms/jp_rev_a/trace/trace_jp.json'], capture_output=True, text=True)
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
