#!/usr/bin/env python3
"""The whole JP ROM bank by bank, coloured by WHAT each byte is (README 'Current status', second map), with the tiles that nothing reaches outlined. The ROM is drawn as 2bpp tiles (64 banks of 16 x 64 tiles) exactly like rom_reach_map.py.
usage: rom_layout_map.py OUT.png [--rom pocketcamera_jp.gb] [--csv roms/jp_rev_a/assets/layout_by_bank_jp.csv] [--map ...] [--assets ...] [--witness ...] [--reach ...] [--unused ...] [--kinds roms/jp_rev_a/assets/layout_kind_overrides_jp.csv]
Each ROM byte gets one category:
  code (class C / F / N of coverage/v8/report_v8/rom_map.csv = traced instructions): the function group of the label that owns the byte (rules below; 10 groups);
  data (everything else): tile sets (4 kinds), tile maps, sprite (OAM) layouts, sound data, other tables and text, UNCERTAIN data, padding.
The owner of a byte is the nearest label at or before it in the same bank (roms/jp_rev_a/disasm/sym_names_jp.csv).  The kind of a data label comes from its name (Gfx_ / Sheet_ / Kana_ / TileGap_ / Font_ / DjPrintFont_ = tile set, Map_ / BgMap_ /
*Border*_Map = tile map, Song / Sfx / Snd = sound, OamList / OamPtrTbl = sprite layouts, StampCat*_Gfx = stamps, WildFrame / Border *_Tiles = frames, AlbumB*_Tiles / _Thumb = stock photos, anything else
inside code banks = tables), so the evidence behind a kind is the one of the label (roms/jp_rev_a/disasm/sym_names_jp.csv, column conf).  A label tagged '?' (roms/jp_rev_a/disasm/sym_unconclusive_jp.md) only says that the ROLE of the bytes is doubtful, not their kind: it keeps the kind its name
gives (a Gfx_ block is a tile set whatever its role).  The kind of the Src_* / Data_* blocks (named after the far pointer that loads them, not after what they are) comes from roms/jp_rev_a/assets/layout_kind_overrides_jp.csv,
one row per block with the evidence (the code that copies it and where to, or how the bytes render).  UNCERTAIN = the bytes that stay unidentified after that: a '?' label whose name gives no kind, and any Src_* / Data_*
block without a row.  Padding = runs of >= 16 x 00 / FF that no typed range of roms/jp_rev_a/disasm/sym_types_jp.csv covers (the fill between the assets) and the zero fill named Bank*_Padding / ZeroFill in the symbol file.
The outline marks tiles that contain bytes no run reached, with the classes of rom_reach_map.py (tcrf_check/tools/rom_reach_classes.py): black never-run code, red unused data, blue identified data the v8 run never read.
A magenta cross marks every PURE padding tile: a 16-byte tile (aligned like the tile grid) whose 16 bytes are all padding; shorter padding is not marked."""
import json, sys, os, csv, re, collections
import numpy as np
from PIL import Image, ImageDraw, ImageFont
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(os.path.dirname(HERE)); sys.path.insert(0, HERE)
import rom_reach_classes as RC
a = sys.argv[1:]
def opt(n, d):
    if n in a: i = a.index(n); v = a[i + 1]; del a[i:i + 2]; return v
    return d
ROM = opt('--rom', 'pocketcamera_jp.gb'); MAP = opt('--map', os.path.join(REPO, 'coverage', 'v8', 'report_v8', 'rom_map.csv'))
ASSETS = opt('--assets', os.path.join(REPO, 'roms', 'jp_rev_a', 'assets', 'asset_map_jp.csv')); WIT = opt('--witness', os.path.join(REPO, 'roms', 'jp_rev_a', 'assets', 'witness_jp.csv'))
REACH = opt('--reach', os.path.join(REPO, 'roms', 'jp_rev_a', 'assets', 'reach_ranges_jp.csv'))
UNUSED = opt('--unused', os.path.join(REPO, 'tcrf_check', 'assets', 'unidentified', 'really_unused.csv')); CSVOUT = opt('--csv', None)
KINDS = opt('--kinds', os.path.join(REPO, 'roms', 'jp_rev_a', 'assets', 'layout_kind_overrides_jp.csv')); OUT = a[0]
NAMES = os.path.join(REPO, 'roms', 'jp_rev_a', 'disasm', 'sym_names_jp.csv'); TYPES = os.path.join(REPO, 'roms', 'jp_rev_a', 'disasm', 'sym_types_jp.csv')
# another build (roms/us_eu/us_rom_layout_map.png): its name layers and type files (comma lists, later wins), its title, and --diff = the
# npz of tools/port_diff_bytes.py: the outline then marks what differs from the Japanese ROM instead of what no run reached (no run of that build)
NAMES = opt('--names', NAMES).split(','); TYPES = opt('--types', TYPES).split(','); TITLE = opt('--title', None); DIFF = opt('--diff', None)
# a ROM whose work has not started, or has only started (roms/<rom>/<prefix>_rom_layout_map.png): --unclaimed colours every byte that no
# label owns and no trace runs as NOT ANALYSED YET (instead of 'tables'), --outline none draws no outline, --note1 / --note2 replace the
# two lines under the title; '--names none', '--types none' and '--map none' (every byte class R: no trace yet) are allowed
# bank shape: --bank-tiles WxH (tiles; W x H = 1024, default 16x64, the format of the maps since 2026-10-27) and --bank-cols (banks per
# picture row, default 8: 8 rows of 8 banks, owner 2026-10-31). 16 tiles is the width of the ROM's own tile sheets, so pictures stored in the ROM read as pictures; the
# earlier square banks are --bank-tiles 32x32 --bank-cols 8
BTW, BTH = (int(x) for x in opt('--bank-tiles', '16x64').split('x')); assert BTW * BTH == 1024, 'a bank is 1,024 tiles'
BCOLS = int(opt('--bank-cols', '8')); BROWS = 64 // BCOLS
COV = opt('--cov', None)                                    # coverage npz (dr / ex) of this ROM: which bytes some run read
UNCLAIMED = '--unclaimed' in a
if UNCLAIMED: a.remove('--unclaimed')
OUTLINE = opt('--outline', 'diff' if DIFF else 'reach'); NOTE1 = opt('--note1', None); NOTE2 = opt('--note2', None)
NAMES = [x for x in NAMES if x != 'none']; TYPES = [x for x in TYPES if x != 'none']
if MAP == 'none':
    import tempfile
    MAP = os.path.join(tempfile.mkdtemp(prefix='layout_'), 'rom_map.csv')
    with open(MAP, 'w') as _f:
        _f.write('bank,start,length,class\n')
        for _b in range(os.path.getsize(ROM) // 0x4000): _f.write('%02x,%04x,16384,R\n' % (_b, 0 if _b == 0 else 0x4000))

g = RC.build(ROM, MAP, ASSETS, WIT, REACH, UNUSED, REPO)
N, cls, cat, pad, fill = g['N'], g['cls'], g['cat'], g['pad'], g['fill']
# a byte counts as never reached when a real coverage map says so (class U), or always when this ROM has no run (--map none / a trace map)
RUNS = os.path.basename(MAP) == 'rom_map.csv' and 'report_v8' in MAP
READKNOWN = RUNS or bool(COV)
if RUNS: unreached = (cls == ord('U'))
elif COV:
    _z = np.load(COV); unreached = ~((_z['dr'][:N] != 0) | (_z['ex'][:N] != 0))
else: unreached = np.ones(N, bool)
# $FF fill only where a coverage says no run read it (owner 2026-11-01): elsewhere a $FF run keeps the kind of the block it is in
fill_ok = unreached if READKNOWN else np.zeros(N, bool)
BANKS = N // 0x4000
def flat(b, ad): return b * 0x4000 + (ad - 0x4000 if b else ad)


def _asset_kind(kind, m):
    """bytes m (a Padding label over read or $FF bytes) take the kind of the block before them in the same bank: they are its tail"""
    bad = m | is_code | np.isin(kind, [KEY[k] for k in ('PAD', 'FILL', 'NONE') if k in KEY])   # a data block only
    pos = np.where(~bad, np.arange(len(kind)), -1); pos = np.maximum.accumulate(pos)
    same = (pos >= 0) & ((pos >> 14) == (np.arange(len(kind)) >> 14))
    out = kind.copy(); sel = m & same; out[sel] = kind[pos[sel]]; out[m & ~same] = KEY['UNC']; return out
# ---- categories: key, legend text, colour --------------------------------------------------------------------------------------------------------------------------------------------------------
CATS = [
 ('SYS',   'System: boot, IRQs, VRAM / OAM, blit, math, RNG, banking, SRAM storage, SGB', (68, 80, 104)),
 ('CAM',   'Camera, sensor, image processing, effects, SHOOT modes and parlor',                  (30, 100, 190)),
 ('ALBUM', 'Album, photo view, slide show, hot spots, delete',                                             (96, 170, 236)),
 ('EDIT',  'Editors: pen, stamps, animation, hot spots, text and comments, pickers',                       (120, 80, 196)),
 ('LINK',  'Link cable: menus, photo exchange',                                                            (0, 130, 150)),
 ('PRINT', 'Printer, print screens, frames and borders',                                                   (200, 70, 150)),
 ('GAME',  'Mini-games: Space Fever II, BALL, RUN! RUN! RUN!',                                              (240, 140, 40)),
 ('DJ',    'D.J. music editor, performer, print',                                                          (150, 96, 40)),
 ('UI',    'Menus, title, credits, owner and user screens',                                                (38, 166, 154)),
 ('SND',   'Sound driver (code)',                                                                          (150, 20, 50)),
 ('OTHER', 'Code with no function group (2 bank-0 helpers, 2 dead tile-map loaders)',  (120, 120, 120)),
 ('T_UI',  'Tile sets: screens, menus, fonts, sprites, SGB border',                                         (60, 160, 76)),
 ('T_STP', 'Tile sets: stamps',                                                                            (150, 210, 90)),
 ('T_FRM', 'Tile sets: print frames and photo borders',                                                    (20, 100, 70)),
 ('T_PHO', 'Tile sets: the stock photos of Album B',                                                       (205, 236, 150)),
 ('MAP',   'Tile maps (background layouts)',                                                               (245, 205, 50)),
 ('OAM',   'Sprite layouts (OAM lists and their pointer tables)',                                          (200, 165, 110)),
 ('SOUND', 'Sound data: songs, effect tables and parameters',                                              (255, 110, 100)),
 ('PALT',  'Palettes: colour tables (the Super Game Boy palettes; Game Boy palettes are immediate bytes in code, named DMGPAL_* in the source)', (120, 60, 160)),
 ('TBL',   'Other tables and text: jump / lookup tables, print layout scripts, stamp masks, SGB packets, staff roll, parameters', (150, 168, 184)),
 ('UNC',   'UNCERTAIN: bytes not identified (kind or record format not settled)',                          (255, 0, 200)),
 ('FILL',  'Fill: runs of 16+ x $FF outside every typed asset that no run reads ($FF is never padding; read $FF runs keep the kind of their block)',                                   (236, 224, 200)),
 ('PAD',   'Padding: runs of 16+ x $00 that no run reached, outside every typed asset',                                                           (214, 214, 214)),
]
if DIFF or UNCLAIMED:
    _io = [k for k, _, _ in CATS].index('OTHER'); CATS[_io] = ('OTHER', 'Code with no function group', CATS[_io][2])
LKINDS = '--leftover-kinds' in a      # a build with leftovers of its own making (the prototype): three kinds of their own, before UNCERTAIN
if LKINDS:
    _iu = [k for k, _, _ in CATS].index('UNC')
    CATS[_iu:_iu] = [('SRC',   'Leftover text in clear: the developers\' assembler source and listings of it (Leftover_*_AsmSource / _SrcListing)', (40, 40, 40)),
                     ('PCRAM', 'Leftover PC memory: RAM of the development PC (DOS environment, Windows names) left by the build tool (Leftover_*_PcRam)', (0, 200, 180)),
                     ('LCODE', 'Leftover copies of code: routines of this or an older build that this build never runs (Leftover_*_<routine>)', (110, 100, 30))]
if UNCLAIMED:
    CATS.insert(len(CATS) - 1, ('NONE', 'NOT ANALYSED YET: no label, type row or trace says what these bytes are', (96, 112, 140)))
KEY = {k: i for i, (k, _, _) in enumerate(CATS)}
CODE_KEYS = [k for k, _, _ in CATS[:11]]

# ---- function group of a code label ----------------------------------------------------------------------------------------------------------------------------------------------------------------
MODE_GROUP = {'00': 'UI', '01': 'CAM', '02': 'ALBUM', '03': 'UI', '04': 'EDIT', '05': 'EDIT', '06': 'LINK', '07': 'GAME', '08': 'UI', '09': 'ALBUM', '0A': 'ALBUM', '0B': 'ALBUM', '0C': 'ALBUM',
              '0D': 'ALBUM', '0E': 'LINK', '0F': 'ALBUM', '10': 'EDIT', '11': 'EDIT', '12': 'EDIT', '13': 'EDIT', '14': 'CAM', '15': 'CAM', '16': 'CAM', '17': 'CAM', '18': 'CAM', '19': 'UI',
              '1A': 'EDIT', '1B': 'PRINT', '1C': 'PRINT', '1D': 'PRINT', '1E': 'PRINT', '1F': 'DJ', '20': 'GAME', '21': 'GAME'}      # modes: docs §16.2
PREFIX_GROUP = {}
for grp, names in [
 ('SYS',   'Boot Vec Irq Vram Blit Oam OamDma Mem Math Rng Stat Main Delay Far Joy Vq Pal Wait Bcd Anim Lcd Reti Rst Call Glyph Bank Slide Record Sgb Sram Photo Settings Counters Owner GameFace AlbumB Mode Map Gfx'),
 ('CAM',   'Cam Fx FxShared Shoot Img Compose Parlor Thumb'),
 ('ALBUM', 'Album AlbumPage ViewMenu ShowMenu SaveDialog EraseAnim HotSpot HotSpotFx SlideHub SlideOptA SlideOptB SlidePlay'),
 ('EDIT',  'Pen PenMenu Stamp StampCat AnimEd HotSpotEd PhotoPicker EditMenu DoodleMenu CommentEditor Kb Slider'),
 ('PRINT', 'Prn Print Border BorderPicker WildFrame WildFramePicker Wild CommentCard'),
 ('LINK',  'Link LinkPick LinkMenu'),
 ('GAME',  'SpaceFever Sf Ball Run ResultScreen HiScore'),
 ('DJ',    'Dj DjS DjPerf DjEd DjNs DjPrint DjPrintRow DjTitle DjPanel DjSnd Player'),
 ('SND',   'Snd Sfx Song'),
 ('UI',    'MainMenu Title Credits UserMap OwnerCard ScrollEngine SpecialMenu')]:
    for nm in names.split(): PREFIX_GROUP[nm] = grp
def prefix(name): return re.split(r'[_0-9]', name)[0] or name[:6]
# another build with its own modes (roms/hello_kitty/assets/layout_groups_kitty.csv): --groups CSV (what, key, group, text): rows 'mode' replace the
# Japanese mode groups, rows 'prefix' add name prefixes, rows 'legend' replace the legend text of a group
GROUPS = opt('--groups', None)
if GROUPS and GROUPS != 'none':
    MODE_GROUP = {}
    for r in csv.DictReader(open(GROUPS, encoding='utf-8')):
        if r['what'] == 'mode': MODE_GROUP[r['key'].upper()] = r['group']
        elif r['what'] == 'prefix': PREFIX_GROUP[r['key']] = r['group']
        elif r['what'] == 'legend': CATS[KEY[r['key']]] = (r['key'], r['text'], CATS[KEY[r['key']]][2])
def code_group(name):
    m = re.match(r'Mode([0-9A-F]{2})', name)
    if m and m.group(1) in MODE_GROUP: return MODE_GROUP[m.group(1)]
    if name.startswith('Unused_'): return code_group(name[7:])
    return PREFIX_GROUP.get(prefix(name), 'OTHER')

# ---- kind of a data label ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
def data_kind(name):
    if re.search(r'(Padding|ZeroFill)', name): return 'PAD'
    if name.startswith('Unused_'):
        inner = re.sub(r'^TCRF_', '', name[7:]); k = data_kind(inner)
        if k != 'TBL': return k
        return 'T_UI' if re.search(r'_Gfx(_|$)', name) else ('MAP' if re.search(r'(Tilemap|_Map(_|$))', name) else 'TBL')
    p = prefix(name)
    if p in ('Song', 'Sfx', 'Snd', 'DjSnd'): return 'SOUND'
    if p in ('OamList', 'OamPtrTbl'): return 'OAM'
    if p == 'AlbumB': return 'T_PHO' if re.search(r'_(Tiles|Thumb)$', name) else 'TBL'
    if p == 'StampCat': return 'T_STP' if name.endswith('_Gfx') else 'TBL'
    if p in ('WildFrame', 'Border') or name.startswith('Border'):
        if re.search(r'_Map$|Map$', name) and not name.endswith('SrcTbl'): return 'MAP'
        return 'T_FRM' if re.search(r'(Tiles(Part\d+|Tail)?|LateralStrips)$', name) else 'TBL'
    if p in ('Gfx', 'Sheet', 'Kana', 'TileGap', 'TileSet', 'Font', 'DjPrintFont'): return 'T_UI'
    if p in ('Map', 'BgMap'): return 'MAP'
    if re.search(r'(PalTrnData|Palettes)$', name): return 'PALT'                      # colour data: Sgb_PalTrnData, Sgb_BorderPalettes
    if p == 'Sgb': return 'T_UI' if 'BorderTiles' in name else ('MAP' if 'BorderMap' in name else 'TBL')
    if p == 'Leftover':                       # Leftover_BB_AAAA[_<what>] (owner rule 2026-11-11): bytes nothing in this build reads
        m = re.match(r'Leftover_[0-9A-F]{2}_[0-9A-F]{4}_(.+)$', name)
        if not m: return 'UNC'                                                           # kind not settled
        if m.group(1) in ('AsmSource', 'SrcListing'): return 'SRC' if LKINDS else 'UNC'
        if m.group(1) == 'PcRam': return 'PCRAM' if LKINDS else 'UNC'
        if m.group(1) in CODENAMES: return 'LCODE' if LKINDS else 'UNC'                   # a copy of a routine: never run here
        return data_kind(m.group(1))                                                    # a copy of a named block keeps the block's kind
    if p in ('Src', 'Data'): return 'UNC'                                   # Leftover_: bytes nothing reads (owner rule 2026-11-11), kind not settled
    return 'TBL'

# ---- labels ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
_lab = {}
for _fn in NAMES:
    for r in csv.DictReader(open(_fn, encoding='utf-8')):
        _k = flat(int(r['bank'], 16), int(r['addr'], 16))
        if r['name'] in ('-', ''): _lab.pop(_k, None)
        else: _lab[_k] = r
labels = sorted(_lab.items(), key=lambda x: x[0])
loff = np.array([o for o, _ in labels] or [-1], np.int64); L = len(labels)
CODENAMES = {r['name'] for o, r in labels if cls[o] in b'CFN'}                             # labels on proven code (a leftover copy of one is code never run)
l_code = np.zeros(max(L, 1), np.uint8); l_data = np.zeros(max(L, 1), np.uint8)
for i, (o, r) in enumerate(labels):
    _g = code_group(r['name'])
    if GROUPS and GROUPS != 'none' and _g == 'OTHER' and re.match(r'(Data|Src)_', r['name']) and i and (labels[i - 1][0] >> 14) == (o >> 14):
        l_code[i] = l_code[i - 1]      # --groups: code under an automatic data label follows inline parameters (Copy_FarInline ...): the routine before it owns it
    else: l_code[i] = KEY[_g]
    k = data_kind(r['name'])
    if r['conf'] == '?' and k == 'TBL': k = 'UNC'                                          # role doubtful AND no kind in the name
    l_data[i] = KEY[k]
idx = np.searchsorted(loff, np.arange(N), 'right') - 1
ok = (idx >= 0) & ((loff[np.maximum(idx, 0)] >> 14) == (np.arange(N) >> 14))          # the owner must lie in the same bank
idx = np.where(ok, idx, 0)
is_code = np.isin(cls, np.frombuffer(b'CFN', np.uint8))
kind = np.where(is_code, l_code[idx], l_data[idx]).astype(np.uint8)
kind[~ok & is_code] = KEY['OTHER']; kind[~ok & ~is_code] = KEY['NONE' if UNCLAIMED else 'TBL']
kind[cls == ord('T')] = KEY['TBL']                                                      # inline tables of the code
_m = (kind == KEY['PAD']) & ~(pad & unreached); kind[_m & fill & fill_ok] = KEY['FILL']; kind = _asset_kind(kind, _m & ~(fill & fill_ok))   # a Padding / ZeroFill label over $FF or read bytes is not padding
kind[cat == 3] = KEY['PAD']                                                              # untouched padding (the muted red of the status map); the Bank*_Padding / ZeroFill labels are padding too, read or not
# fill between the assets: bytes that no typed range of roms/jp_rev_a/disasm/sym_types_jp.csv covers, that are not code and lie in a run of >= 16 x 00 / FF (a forced run may have read them)
typed = np.zeros(N, bool)
for _fn in TYPES:
    for r in csv.DictReader(open(_fn, encoding='utf-8')): typed[flat(int(r['bank'], 16), int(r['start'], 16)):flat(int(r['bank'], 16), int(r['start'], 16)) + int(r['end'], 16) - int(r['start'], 16)] = True
kind[~typed & ~is_code & (cls != ord('T')) & pad & unreached] = KEY['PAD']
kind[~typed & ~is_code & (cls != ord('T')) & fill & ~pad & fill_ok] = KEY['FILL']
_m = (kind == KEY['PAD']) & ~(pad & unreached); kind[_m & fill & fill_ok] = KEY['FILL']; kind = _asset_kind(kind, _m & ~(fill & fill_ok))
# kind of the Src_* / Data_* blocks, from the evidence rows of roms/jp_rev_a/assets/layout_kind_overrides_jp.csv (bank, start, end, kind, ev, label, basis); only bytes still UNCERTAIN are changed
OVR = {}      # bytes that the evidence rows reclassify, per kind (the README quotes them; tools/check_repo_consistency.py compares)
if os.path.exists(KINDS):
    for r in csv.DictReader(open(KINDS, encoding='utf-8')):
        o0, o1 = flat(int(r['bank'], 16), int(r['start'], 16)), flat(int(r['bank'], 16), int(r['end'], 16))
        seg = kind[o0:o1]; hit = (seg == KEY['UNC']) & ~is_code[o0:o1]
        if not hit.any() and (seg[~is_code[o0:o1]] == KEY[r['kind']]).all(): continue      # the block was renamed with its kind since (e.g. Src_ -> Map_): the row agrees, nothing to do
        assert hit.any(), 'no uncertain byte left in %s' % r['label']
        seg[hit] = KEY[r['kind']]; OVR[r['kind']] = OVR.get(r['kind'], 0) + int(hit.sum()); OVR['rows'] = OVR.get('rows', 0) + 1
print('layout overrides', OVR.get('rows', 0), 'rows', {k: v for k, v in sorted(OVR.items()) if k != 'rows'}, 'bytes', sum(v for k, v in OVR.items() if k != 'rows'))
_u = np.flatnonzero(kind == KEY['UNC'])
if len(_u):
    _cut = np.flatnonzero(np.diff(_u) > 1) + 1
    for _s in np.split(_u, _cut): print('uncertain span %02X:%04X +%d' % (_s[0] // 0x4000, _s[0] % 0x4000 + (0x4000 if _s[0] >= 0x4000 else 0), len(_s)))

# ---- marks: the bytes no run reached --------------------------------------------------------------------------------------------------------------------------------------------------------------
MARKS = [('code that never ran (proven dead, evidence I; docs §16.15, 16.21)', (0, 0, 0)),
         ('data that no run shows or reads: the REALLY unused assets (evidence I; docs §16.24)', (214, 20, 40)),
         ('data never read by the v8 run, identified (evidence I; docs §16.13); whether the game uses it is not shown', (245, 160, 0)),
         ('untouched padding', (176, 176, 176))]
mark = np.full(N, 255, np.uint8)
mark[cat == 3] = 3; mark[cat == 4] = 2; mark[(cat == 7) | ((cat == 2) & ~is_code)] = 1; mark[(cat == 6) | ((cat == 2) & is_code)] = 0
if DIFF:                                             # outline = difference from the Japanese ROM: 0 code new or changed (black), 2 data that differs (blue)
    _d = np.load(DIFF)['diff']; mark = np.full(N, 255, np.uint8); mark[_d == 1] = 0; mark[(_d == 2) & (kind != KEY['PAD'])] = 2
cmark = mark.copy()                                    # the csv keeps these counts whatever the outline (owner 2026-11-01: differences in the csv, not in the picture)
if OUTLINE == 'none': mark = np.full(N, 255, np.uint8)

big_unused = {}
if os.path.exists(UNUSED):
    for r in csv.DictReader(open(UNUSED, encoding='utf-8')):
        if not (r['tier'] in ('no loader', 'never shown', 'forced only') or (r['tier'] == 'TCRF' and int(r['stable_in_organic_runs']) == 0)): continue
        b = int(r['bank'], 16)
        if int(r['bytes']) > big_unused.get(b, (0, ''))[0]: big_unused[b] = (int(r['bytes']), re.sub(r'(^(Gfx|Map|Src|Unused|TileGap)_([0-9A-F]{2}_[0-9A-F]{4}_)?(TCRF_)?)|(_Gfx$)', '', r['name']) or r['name'])
# ---- numbers ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if os.environ.get('LAYOUT_KIND_NPY'): np.save(os.environ['LAYOUT_KIND_NPY'], kind); json.dump({k: v for k, v in KEY.items()}, open(os.environ['LAYOUT_KIND_NPY'] + '.keys.json', 'w'))   # per-byte kinds for scripts
tot_cat = np.bincount(kind, minlength=len(CATS)); assert tot_cat.sum() == N
per_bank = np.array([np.bincount(kind[b * 0x4000:(b + 1) * 0x4000], minlength=len(CATS)) for b in range(BANKS)])
mk_bank = np.array([[int((mark[b * 0x4000:(b + 1) * 0x4000] == m).sum()) for m in range(4)] for b in range(BANKS)])
mk_tot = mk_bank.sum(0)
ck_bank = np.array([[int((cmark[b * 0x4000:(b + 1) * 0x4000] == m).sum()) for m in range(4)] for b in range(BANKS)]); ck_tot = ck_bank.sum(0)
if CSVOUT:
    with open(CSVOUT, 'w', newline='') as fh:
        w = csv.writer(fh, lineterminator='\n')
        w.writerow(['bank'] + [k for k, _, _ in CATS] + (['code_new_or_changed_vs_jp', 'data_differs_vs_jp'] if DIFF else ['never_run_code', 'unused_data', 'unread_identified_data', 'padding_untouched']))
        _cols = (lambda r: [int(r[0]), int(r[2])]) if DIFF else (lambda r: [int(x) for x in r])
        for b in range(BANKS): w.writerow(['%02X' % b] + [int(x) for x in per_bank[b]] + _cols(ck_bank[b]))
        w.writerow(['total'] + [int(x) for x in tot_cat] + _cols(ck_tot))

# ---- drawing: the whole ROM as 2bpp tiles, like rom_reach_map.py ---------------------------------------------------------------------------------------------------------------------------------
# Layout (owner, 2026-10-31): 8 rows of 8 banks, each bank 16 x 64 tiles; the legend is ONE column above the banks, in large type, wrapped
# to the page width, so that it reads on a screen.
def font(sz, bold=False):
    for p in ('/usr/share/fonts/truetype/dejavu/DejaVuSans%s.ttf' % ('-Bold' if bold else ''), '/usr/share/fonts/dejavu/DejaVuSans%s.ttf' % ('-Bold' if bold else '')):
        if os.path.exists(p): return ImageFont.truetype(p, sz)
    return ImageFont.load_default(size=sz)
F1, F2, F3, F3B, FB, FK = font(46, True), font(28), font(27), font(30, True), font(32, True), font(22)
SHORT = {'SYS': 'system code', 'CAM': 'camera code', 'ALBUM': 'album code', 'EDIT': 'editor code', 'LINK': 'link code', 'PRINT': 'print code', 'GAME': 'game code', 'DJ': 'D.J. code',
         'UI': 'menu code', 'SND': 'sound code', 'OTHER': 'other code', 'SRC': 'source text', 'PCRAM': 'PC memory', 'LCODE': 'code copies', 'T_UI': 'tile sets', 'T_STP': 'stamp tiles', 'T_FRM': 'frame tiles', 'T_PHO': 'stock photos', 'MAP': 'tile maps',
         'OAM': 'sprite layouts', 'SOUND': 'sound data', 'TBL': 'tables / text', 'PALT': 'palettes', 'UNC': 'UNCERTAIN', 'FILL': '$FF fill', 'PAD': 'padding', 'NONE': 'not analysed'}
def ramp(c):                      # 4 shades of one colour: 0 = lightest ... 3 = darkest (the 2 bits of a tile pixel)
    mix = lambda t, k: tuple(int(round(255 * (1 - k) + v * k)) if t == 'w' else int(round(v * k)) for v in c)
    return [mix('w', 0.14), mix('w', 0.55), tuple(c), mix('b', 0.38)]
FAM = [ramp(c) for _, _, c in CATS]
FAM[KEY['PAD']] = [(248, 248, 248), (232, 232, 232), (214, 214, 214), (186, 186, 186)]
FAM[KEY['FILL']] = [(250, 246, 236), (240, 230, 210), (226, 210, 180), (196, 176, 140)]
BG, INK = 4 * len(CATS), 4 * len(CATS) + 1
pal = [c for f in FAM for c in f] + [(255, 255, 255), (0, 0, 0), (214, 20, 40), (0, 70, 220), (110, 110, 110), (205, 0, 160)]
RED, BLUE, GREYI, CROSS = INK + 1, INK + 2, INK + 3, INK + 4
# a tile row is two bytes: the kind of the pair is the one with the lower rank (UNCERTAIN first, then code, then data, padding last)
RANKK = np.zeros(len(CATS), np.int32); order = [KEY['UNC']] + list(range(11)) + list(range(11, len(CATS) - 1)) + [KEY['PAD']]
order = [k for i, k in enumerate(order) if k not in order[:i]]
for r_, k_ in enumerate(order): RANKK[k_] = r_
INVK = np.array(order, np.uint8)
rowkind = INVK[np.minimum(RANKK[kind[0::2]], RANKK[kind[1::2]])].reshape(-1, 8)
t = rom_bytes = g['rom'].reshape(-1, 8, 2); lo = t[:, :, 0]; hi = t[:, :, 1]
sh = np.zeros((len(t), 8, 8), np.uint8)
for x in range(8): sh[:, :, x] = ((lo >> (7 - x)) & 1) | (((hi >> (7 - x)) & 1) << 1)
pix = (rowkind[:, :, None] * 4 + sh).astype(np.uint8)
banks = N // 0x4000
per = pix.reshape(banks, BTH, BTW, 8, 8).transpose(0, 1, 3, 2, 4).reshape(banks, 8 * BTH, 8 * BTW)
S = 2; GX, LEFT = 18, 40
PW, PH = 8 * BTW * S, 8 * BTH * S                      # one bank in pixels
W = LEFT + BCOLS * (PW + GX) + 22
pct = lambda x: '%.1f %%' % (100 * x / N)
fmt = lambda x: format(int(x), ',')
_scratch = ImageDraw.Draw(Image.new('L', (8, 8)))
def wrap(text, fnt, maxw):
    out = []
    for para in text.split('\n'):
        line = ''
        for w_ in para.split(' '):
            cand = (line + ' ' + w_).strip()
            if _scratch.textlength(cand, font=fnt) <= maxw or not line: line = cand
            else: out.append(line); line = w_
        out.append(line)
    return out
# ---- the legend, one column: (kind of swatch, payload, count text, text)
LG = []          # entries: ('head', text) | ('cat', i, count, text) | ('mark', colour, count, text) | ('cross', count, text) | ('note', text)
subtitle = []
if NOTE1 is not None: subtitle = [NOTE1, NOTE2 or '']
elif not DIFF: subtitle = ['Each bank = %d x %d tiles = 16,384 bytes, banks $00..$3F left to right, top to bottom, 8 banks per row. The colour is the KIND of the bytes (symbol file labels and the v8 coverage classes); the shade inside a colour is the tile pixel (2 bits), so graphics, text and code all stay visible. An outline marks the tiles (16 bytes) that no run reached. Kind evidence per label: roms/jp_rev_a/disasm/sym_names_jp.csv (C / I / ?).' % (BTW, BTH)]
else: subtitle = ['Each bank = %d x %d tiles = 16,384 bytes, banks $00..$3F left to right, top to bottom, 8 banks per row. The colour is the KIND of the bytes (the symbol file ported from the Japanese tables and the static trace of this ROM: no emulator run of it exists). The shade is the tile pixel (2 bits). An outline marks the tiles (16 bytes) that differ from the Japanese ROM (docs 1.5). Kind evidence: roms/us_eu/disasm/sym_names_us*.csv.' % (BTW, BTH)]
LG.append(('head', 'CODE (traced instructions), by the function of the routine that owns them'))
for i in range(11): LG.append(('cat', i, fmt(tot_cat[i]) + ' B  ' + pct(tot_cat[i]), CATS[i][1]))
LG.append(('head', 'DATA, by what the bytes are (identified even when no code calls them)'))
for j in range(11, len(CATS)): LG.append(('cat', j, fmt(tot_cat[j]) + ' B  ' + pct(tot_cat[j]), CATS[j][1]))
LG.append(('head', {'reach': 'OUTLINE: tiles that no run reached (16-byte tiles)', 'diff': 'OUTLINE: tiles that differ from the Japanese ROM (16-byte tiles)',
                    'none': 'OUTLINE: none yet (no run and no comparison for this ROM)'}[OUTLINE]))
MTXT = {'reach': {0: 'never-run code, proven dead (evidence I; docs §16.15, 16.21)', 1: 'data that no run shows or reads: the REALLY unused assets (I; docs §16.24)',
                  2: 'identified data the v8 run never read (I; docs §16.13)'},
        'diff': {0: 'code new or changed in this build (no JP instruction pairs with it as the same code)', 2: 'data that differs from the Japanese bytes (new pictures, English text, moved tables)'},
        'none': {}}[OUTLINE]
for m, col in ((0, INK), (1, RED), (2, BLUE)):
    if m in MTXT: LG.append(('mark', col, fmt(mk_tot[m]) + ' B', MTXT[m]))
LG.append(('cross', fmt(n_padtile) if False else None, 'CROSS: a pure padding tile (all 16 bytes are never-reached $00 padding)'))
if OUTLINE == 'none':
    notes = ['Grey-blue = not analysed yet: the colours replace it as names, types and a trace are added to this ROM.', 'Per bank, under its number: the two largest kinds (padding excluded).']
elif not DIFF:
    notes = ['Not outlined: everything that at least one run executed, read or showed, and padding.', 'Per bank, under its number: the two largest kinds (padding excluded) and the unreachable bytes.']
else:
    notes = ['Not outlined: code paired with the Japanese code (identical, or another address operand), data equal to its Japanese bytes, and padding. No emulator run of this ROM: the code colour is its static trace.',
             'Per bank, under its number: the two largest kinds (padding excluded) and the bytes that differ from the Japanese ROM.']
notes.insert(0, 'Padding rule: only runs of 16+ x $00 that no run reached (no run of this ROM: all of them) are padding; $FF is never padding: a $FF run that no run reads, outside the assets, is "fill"; one that is read keeps the kind of its block (no run of this ROM: no fill).')
for n_ in notes: LG.append(('note', n_))
TXW = W - LEFT - 20; SW = 150; CW = 250              # swatch width, count column width
y = 18; title_lines = wrap(TITLE or 'Pocket Camera (Japan) Rev A: what is in each of the 64 banks (the ROM drawn as 2bpp tiles, code, data and padding alike)', F1, TXW)
y += 58 * len(title_lines) + 6
sub_lines = [l for t_ in subtitle for l in wrap(t_, F2, TXW)]
y += 36 * len(sub_lines) + 24
lay = []
for e in LG:
    if e[0] == 'head': y += 16; lay.append((e, y, wrap(e[1], F3B, TXW))); y += 40 * len(lay[-1][2])
    elif e[0] == 'note': lines = wrap(e[1], F3, TXW); lay.append((e, y, lines)); y += 35 * len(lines)
    else: lines = wrap(e[-1], F3, TXW - SW - CW - 30); lay.append((e, y, lines)); y += 35 * len(lines) + 4
TOP = y + 40
PADT = 70                                              # wide space above a bank header, narrow space under it: the header sits with its own bank (owner 2026-11-01)
_hdr_names = ['dead', 'unused', 'unread'] if not DIFF else ['new code', '', 'changed']
def _hdr_n(b):        # lines of outline counts under the two kinds of bank b (0 when the map has no outline)
    if OUTLINE == 'none' or not any(mk_bank[b][m] and n for m, n in enumerate(_hdr_names)): return 0
    return len(wrap('  '.join('%s %s' % (n, fmt(int(mk_bank[b][m]))) for m, n in enumerate(_hdr_names) if mk_bank[b][m] and n), FK, PW + GX - 6)[:2])
# each row of banks gets the header height its banks need: number (42) + two kinds (2 x 28) + the count lines (28 each) + 6 px, so the text sits on its bank
GYR = [PADT + 98 + 28 * max(_hdr_n(b) for b in range(r * BCOLS, min(BANKS, (r + 1) * BCOLS))) + 6 for r in range(BROWS)]
ROWY = [TOP + sum(PH + GYR[k] for k in range(r)) for r in range(BROWS)]
H = ROWY[-1] + GYR[-1] + PH + 20
canvas = np.full((H, W), BG, np.uint8)
for b in range(banks):
    gx = LEFT + (b % BCOLS) * (PW + GX); gy = ROWY[b // BCOLS] + GYR[b // BCOLS]
    canvas[gy:gy + PH, gx:gx + PW] = np.kron(per[b], np.ones((S, S), np.uint8))
# outline the tiles that no run reached: per tile the worst mark (never-run code > unused data > unread identified); padding is not outlined
tilemark = np.full((banks, BTH, BTW), 255, np.uint8)
for b in range(banks):
    m = mark[b * 0x4000:(b + 1) * 0x4000].reshape(BTH, BTW, 16)
    for c_ in (2, 1, 0):
        has = (m == c_).any(2); tilemark[b][has] = c_
LINEC = {0: INK, 1: RED, 2: BLUE}
T = 8 * S
for b in range(banks):
    gx = LEFT + (b % BCOLS) * (PW + GX); gy = ROWY[b // BCOLS] + GYR[b // BCOLS]
    M = tilemark[b]
    for ty in range(BTH):
        for tx in range(BTW):
            c_ = M[ty, tx]
            if c_ == 255: continue
            x0 = gx + tx * T; y0 = gy + ty * T; col = LINEC[int(c_)]
            for dx, dy, edge in ((-1, 0, 'L'), (1, 0, 'R'), (0, -1, 'T'), (0, 1, 'B')):
                nx, ny = tx + dx, ty + dy
                if 0 <= nx < BTW and 0 <= ny < BTH and M[ny, nx] == c_: continue
                if edge == 'L': canvas[y0:y0 + T, x0:x0 + 2] = col
                if edge == 'R': canvas[y0:y0 + T, x0 + T - 2:x0 + T] = col
                if edge == 'T': canvas[y0:y0 + 2, x0:x0 + T] = col
                if edge == 'B': canvas[y0 + T - 2:y0 + T, x0:x0 + T] = col
img = Image.fromarray(canvas, 'P'); img.putpalette([v for c in pal for v in c] + [0] * (768 - 3 * len(pal)))
d = ImageDraw.Draw(img)
padtile = (kind.reshape(banks, BTH, BTW, 16) == KEY['PAD']).all(3); n_padtile = int(padtile.sum())
for b in range(banks):
    gx = LEFT + (b % BCOLS) * (PW + GX); gy = ROWY[b // BCOLS] + GYR[b // BCOLS]
    for ty, tx in zip(*np.nonzero(padtile[b])):
        x0 = gx + int(tx) * T; y0 = gy + int(ty) * T
        d.line([x0 + 1, y0 + 1, x0 + T - 2, y0 + T - 2], fill=CROSS, width=1); d.line([x0 + T - 2, y0 + 1, x0 + 1, y0 + T - 2], fill=CROSS, width=1)
# ---- text
yy = 18
for l in title_lines: d.text((LEFT, yy), l, fill=INK, font=F1); yy += 58
yy += 6
for l in sub_lines: d.text((LEFT, yy), l, fill=INK, font=F2); yy += 36
for e, y0, lines in lay:
    if e[0] == 'head':
        for k_, l in enumerate(lines): d.text((LEFT, y0 + 40 * k_), l, fill=INK, font=F3B)
        continue
    if e[0] == 'note':
        for k_, l in enumerate(lines): d.text((LEFT, y0 + 35 * k_), l, fill=(70, 70, 70) if False else INK, font=F3)
        continue
    if e[0] == 'cat':
        for s_ in range(4): d.rectangle([LEFT + s_ * 34, y0 + 3, LEFT + s_ * 34 + 32, y0 + 29], fill=e[1] * 4 + s_)
    elif e[0] == 'mark':
        d.rectangle([LEFT + 10, y0 + 3, LEFT + 120, y0 + 29], outline=e[1], width=4)
    elif e[0] == 'cross':
        d.rectangle([LEFT + 10, y0 + 3, LEFT + 120, y0 + 29], fill=FAM[KEY['PAD']][1]); d.line([LEFT + 14, y0 + 6, LEFT + 116, y0 + 26], fill=CROSS, width=3); d.line([LEFT + 116, y0 + 6, LEFT + 14, y0 + 26], fill=CROSS, width=3)
    cnt = e[2] if e[0] != 'cross' else fmt(n_padtile) + ' tiles'
    d.text((LEFT + SW + CW - d.textlength(cnt, font=F3), y0), cnt, fill=INK, font=F3)
    for k_, l in enumerate(lines): d.text((LEFT + SW + CW + 30, y0 + 35 * k_), l, fill=INK, font=F3)
for b in range(banks):
    gx = LEFT + (b % BCOLS) * (PW + GX); gy = ROWY[b // BCOLS] + PADT
    d.text((gx, gy), '$%02X' % b, fill=INK, font=FB)
    pb = per_bank[b].copy(); pb[KEY['PAD']] = 0
    top2 = [i for i in np.argsort(-pb, kind='stable')[:2] if pb[i] >= 0x4000 // 100]
    for n_, i in enumerate(top2):
        yk = gy + 42 + 28 * n_
        d.rectangle([gx, yk + 3, gx + 18, yk + 21], fill=CATS[i][2], outline=(60, 60, 60))
        d.text((gx + 26, yk), '%s %d %%' % (SHORT[CATS[i][0]], round(100 * pb[i] / 0x4000)), fill=INK, font=FK)
    names = ['dead', 'unused', 'unread'] if not DIFF else ['new code', '', 'changed']
    parts = [(n, int(mk_bank[b][m])) for m, n in enumerate(names) if m < len(names) and mk_bank[b][m] and n and OUTLINE != 'none']
    if parts:
        for k_, l in enumerate(wrap('  '.join('%s %s' % (n, fmt(v)) for n, v in parts), FK, PW + GX - 6)[:2]): d.text((gx, gy + 98 + 28 * k_), l, fill=INK, font=FK)
img.save(OUT, optimize=True)
print(img.size, os.path.getsize(OUT), 'bytes')
for i, (k, tx, c) in enumerate(CATS): print('%-6s %9s  %5s  %s' % (k, fmt(tot_cat[i]), pct(tot_cat[i]), tx[:60]))
print('marks', [int(x) for x in mk_tot]); print('pure padding tiles', n_padtile, 16 * n_padtile, 'B')
