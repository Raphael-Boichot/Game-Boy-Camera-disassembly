#!/usr/bin/env python3
"""The whole JP ROM bank by bank, coloured by WHAT each byte is (README 'Current status', second map), with the tiles that nothing reaches outlined. The ROM is drawn as 2bpp tiles (64 banks of 32 x 32 tiles) exactly like rom_reach_map.py.
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
import sys, os, csv, re, collections
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
N, cls, cat, pad = g['N'], g['cls'], g['cat'], g['pad']
BANKS = N // 0x4000
def flat(b, ad): return b * 0x4000 + (ad - 0x4000 if b else ad)

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
 ('TBL',   'Other tables and text: jump / lookup tables, print layout scripts, stamp masks, SGB packets, staff roll, parameters', (150, 168, 184)),
 ('UNC',   'UNCERTAIN: bytes not identified (kind or record format not settled)',                          (255, 0, 200)),
 ('PAD',   'Padding: runs of 00 / FF between the assets (not typed as data)',                                                           (214, 214, 214)),
]
if DIFF or UNCLAIMED:
    _io = [k for k, _, _ in CATS].index('OTHER'); CATS[_io] = ('OTHER', 'Code with no function group', CATS[_io][2])
if UNCLAIMED:
    CATS.insert(len(CATS) - 1, ('NONE', 'NOT ANALYSED YET: no label, type row or trace says what these bytes are', (96, 112, 140)))
KEY = {k: i for i, (k, _, _) in enumerate(CATS)}
CODE_KEYS = [k for k, _, _ in CATS[:11]]

# ---- function group of a code label ----------------------------------------------------------------------------------------------------------------------------------------------------------------
MODE_GROUP = {'00': 'UI', '01': 'CAM', '02': 'ALBUM', '03': 'UI', '04': 'EDIT', '05': 'EDIT', '06': 'LINK', '07': 'GAME', '08': 'UI', '09': 'ALBUM', '0A': 'ALBUM', '0B': 'ALBUM', '0C': 'ALBUM',
              '0D': 'ALBUM', '0E': 'LINK', '0F': 'ALBUM', '10': 'EDIT', '11': 'EDIT', '12': 'EDIT', '13': 'EDIT', '14': 'CAM', '15': 'CAM', '16': 'CAM', '17': 'CAM', '18': 'CAM', '19': 'UI',
              '1A': 'EDIT', '1B': 'PRINT', '1C': 'PRINT', '1D': 'PRINT', '1E': 'PRINT', '1F': 'DJ', '20': 'GAME', '21': 'GAME'}      # modes: README 16.2
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
def code_group(name):
    m = re.match(r'Mode([0-9A-F]{2})', name)
    if m: return MODE_GROUP[m.group(1)]
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
    if p == 'Sgb': return 'T_UI' if 'BorderTiles' in name else ('MAP' if 'BorderMap' in name else 'TBL')
    if p in ('Src', 'Data'): return 'UNC'
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
l_code = np.zeros(max(L, 1), np.uint8); l_data = np.zeros(max(L, 1), np.uint8)
for i, (o, r) in enumerate(labels):
    l_code[i] = KEY[code_group(r['name'])]
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
kind[cat == 3] = KEY['PAD']                                                              # untouched padding (the muted red of the status map); the Bank*_Padding / ZeroFill labels are padding too, read or not
# fill between the assets: bytes that no typed range of roms/jp_rev_a/disasm/sym_types_jp.csv covers, that are not code and lie in a run of >= 16 x 00 / FF (a forced run may have read them)
typed = np.zeros(N, bool)
for _fn in TYPES:
    for r in csv.DictReader(open(_fn, encoding='utf-8')): typed[flat(int(r['bank'], 16), int(r['start'], 16)):flat(int(r['bank'], 16), int(r['start'], 16)) + int(r['end'], 16) - int(r['start'], 16)] = True
kind[~typed & ~is_code & (cls != ord('T')) & g['pad']] = KEY['PAD']
# kind of the Src_* / Data_* blocks, from the evidence rows of roms/jp_rev_a/assets/layout_kind_overrides_jp.csv (bank, start, end, kind, ev, label, basis); only bytes still UNCERTAIN are changed
OVR = {}      # bytes that the evidence rows reclassify, per kind (the README quotes them; tools/check_repo_consistency.py compares)
if os.path.exists(KINDS):
    for r in csv.DictReader(open(KINDS, encoding='utf-8')):
        o0, o1 = flat(int(r['bank'], 16), int(r['start'], 16)), flat(int(r['bank'], 16), int(r['end'], 16))
        seg = kind[o0:o1]; hit = (seg == KEY['UNC']) & ~is_code[o0:o1]; assert hit.any(), 'no uncertain byte left in %s' % r['label']
        seg[hit] = KEY[r['kind']]; OVR[r['kind']] = OVR.get(r['kind'], 0) + int(hit.sum()); OVR['rows'] = OVR.get('rows', 0) + 1
print('layout overrides', OVR.get('rows', 0), 'rows', {k: v for k, v in sorted(OVR.items()) if k != 'rows'}, 'bytes', sum(v for k, v in OVR.items() if k != 'rows'))
_u = np.flatnonzero(kind == KEY['UNC'])
if len(_u):
    _cut = np.flatnonzero(np.diff(_u) > 1) + 1
    for _s in np.split(_u, _cut): print('uncertain span %02X:%04X +%d' % (_s[0] // 0x4000, _s[0] % 0x4000 + (0x4000 if _s[0] >= 0x4000 else 0), len(_s)))

# ---- marks: the bytes no run reached --------------------------------------------------------------------------------------------------------------------------------------------------------------
MARKS = [('code that never ran (proven dead, evidence I; README 16.15, 16.21)', (0, 0, 0)),
         ('data that no run shows or reads: the REALLY unused assets (evidence I; README 16.24)', (214, 20, 40)),
         ('data never read by the v8 run, identified (evidence I; README 16.13); whether the game uses it is not shown', (245, 160, 0)),
         ('untouched padding', (176, 176, 176))]
mark = np.full(N, 255, np.uint8)
mark[cat == 3] = 3; mark[cat == 4] = 2; mark[(cat == 7) | ((cat == 2) & ~is_code)] = 1; mark[(cat == 6) | ((cat == 2) & is_code)] = 0
if OUTLINE == 'none': mark = np.full(N, 255, np.uint8)
elif DIFF:                                             # outline = difference from the Japanese ROM: 0 code new or changed (black), 2 data that differs (blue)
    _d = np.load(DIFF)['diff']; mark = np.full(N, 255, np.uint8); mark[_d == 1] = 0; mark[(_d == 2) & (kind != KEY['PAD'])] = 2

big_unused = {}
if os.path.exists(UNUSED):
    for r in csv.DictReader(open(UNUSED, encoding='utf-8')):
        if not (r['tier'] in ('no loader', 'never shown', 'forced only') or (r['tier'] == 'TCRF' and int(r['stable_in_organic_runs']) == 0)): continue
        b = int(r['bank'], 16)
        if int(r['bytes']) > big_unused.get(b, (0, ''))[0]: big_unused[b] = (int(r['bytes']), re.sub(r'(^(Gfx|Map|Src|Unused|TileGap)_([0-9A-F]{2}_[0-9A-F]{4}_)?(TCRF_)?)|(_Gfx$)', '', r['name']) or r['name'])
# ---- numbers ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
tot_cat = np.bincount(kind, minlength=len(CATS)); assert tot_cat.sum() == N
per_bank = np.array([np.bincount(kind[b * 0x4000:(b + 1) * 0x4000], minlength=len(CATS)) for b in range(BANKS)])
mk_bank = np.array([[int((mark[b * 0x4000:(b + 1) * 0x4000] == m).sum()) for m in range(4)] for b in range(BANKS)])
mk_tot = mk_bank.sum(0)
if CSVOUT:
    with open(CSVOUT, 'w', newline='') as fh:
        w = csv.writer(fh, lineterminator='\n')
        w.writerow(['bank'] + [k for k, _, _ in CATS] + ['never_run_code', 'unused_data', 'unread_identified_data', 'padding_untouched'])
        for b in range(BANKS): w.writerow(['%02X' % b] + [int(x) for x in per_bank[b]] + [int(x) for x in mk_bank[b]])
        w.writerow(['total'] + [int(x) for x in tot_cat] + [int(x) for x in mk_tot])

# ---- drawing: the whole ROM as 2bpp tiles, like rom_reach_map.py ---------------------------------------------------------------------------------------------------------------------------------
def font(sz, bold=False):
    for p in ('/usr/share/fonts/truetype/dejavu/DejaVuSans%s.ttf' % ('-Bold' if bold else ''), '/usr/share/fonts/dejavu/DejaVuSans%s.ttf' % ('-Bold' if bold else '')):
        if os.path.exists(p): return ImageFont.truetype(p, sz)
    return ImageFont.load_default(size=sz)
F1, F2, F3, F3B, F4, F4B, F5 = font(34, True), font(21), font(19), font(20, True), font(16), font(16, True), font(15)
SHORT = {'SYS': 'system code', 'CAM': 'camera code', 'ALBUM': 'album code', 'EDIT': 'editor code', 'LINK': 'link code', 'PRINT': 'print code', 'GAME': 'game code', 'DJ': 'D.J. code',
         'UI': 'menu code', 'SND': 'sound code', 'OTHER': 'other code', 'T_UI': 'tile sets', 'T_STP': 'stamp tiles', 'T_FRM': 'frame tiles', 'T_PHO': 'stock photos', 'MAP': 'tile maps',
         'OAM': 'sprite layouts', 'SOUND': 'sound data', 'TBL': 'tables / text', 'UNC': 'UNCERTAIN', 'PAD': 'padding', 'NONE': 'not analysed'}
def ramp(c):                      # 4 shades of one colour: 0 = lightest ... 3 = darkest (the 2 bits of a tile pixel)
    mix = lambda t, k: tuple(int(round(255 * (1 - k) + v * k)) if t == 'w' else int(round(v * k)) for v in c)
    return [mix('w', 0.14), mix('w', 0.55), tuple(c), mix('b', 0.38)]
FAM = [ramp(c) for _, _, c in CATS]
FAM[KEY['PAD']] = [(248, 248, 248), (232, 232, 232), (214, 214, 214), (186, 186, 186)]
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
per = pix.reshape(banks, 32, 32, 8, 8).transpose(0, 1, 3, 2, 4).reshape(banks, 256, 256)
S = 2; GX, GY, LEFT = 12, 66, 40
TOP = 520
W = LEFT + 8 * (256 * S + GX) + 10; H = TOP + 8 * (256 * S + GY) + 10
canvas = np.full((H, W), BG, np.uint8)
for b in range(banks):
    gx = LEFT + (b % 8) * (256 * S + GX); gy = TOP + (b // 8) * (256 * S + GY) + (GY - 6)
    canvas[gy:gy + 256 * S, gx:gx + 256 * S] = np.kron(per[b], np.ones((S, S), np.uint8))
# outline the tiles that no run reached: per tile the worst mark (never-run code > unused data > unread identified); padding is not outlined
tilemark = np.full((banks, 32, 32), 255, np.uint8)
for b in range(banks):
    m = mark[b * 0x4000:(b + 1) * 0x4000].reshape(32, 32, 16)
    for c_ in (2, 1, 0):
        has = (m == c_).any(2); tilemark[b][has] = c_
LINEC = {0: INK, 1: RED, 2: BLUE}
T = 8 * S
for b in range(banks):
    gx = LEFT + (b % 8) * (256 * S + GX); gy = TOP + (b // 8) * (256 * S + GY) + (GY - 6)
    M = tilemark[b]
    for ty in range(32):
        for tx in range(32):
            c_ = M[ty, tx]
            if c_ == 255: continue
            x0 = gx + tx * T; y0 = gy + ty * T; col = LINEC[int(c_)]
            for dx, dy, edge in ((-1, 0, 'L'), (1, 0, 'R'), (0, -1, 'T'), (0, 1, 'B')):
                nx, ny = tx + dx, ty + dy
                same = 0 <= nx < 32 and 0 <= ny < 32 and M[ny, nx] == c_
                if same: continue
                if edge == 'L': canvas[y0:y0 + T, x0:x0 + 2] = col
                if edge == 'R': canvas[y0:y0 + T, x0 + T - 2:x0 + T] = col
                if edge == 'T': canvas[y0:y0 + 2, x0:x0 + T] = col
                if edge == 'B': canvas[y0 + T - 2:y0 + T, x0:x0 + T] = col
img = Image.fromarray(canvas, 'P'); img.putpalette([v for c in pal for v in c] + [0] * (768 - 3 * len(pal)))
d = ImageDraw.Draw(img)
# magenta cross on every pure padding tile (all 16 bytes of the tile are padding)
padtile = (kind.reshape(banks, 32, 32, 16) == KEY['PAD']).all(3); n_padtile = int(padtile.sum())
for b in range(banks):
    gx = LEFT + (b % 8) * (256 * S + GX); gy = TOP + (b // 8) * (256 * S + GY) + (GY - 6)
    for ty, tx in zip(*np.nonzero(padtile[b])):
        x0 = gx + int(tx) * T; y0 = gy + int(ty) * T
        d.line([x0 + 1, y0 + 1, x0 + T - 2, y0 + T - 2], fill=CROSS, width=1); d.line([x0 + T - 2, y0 + 1, x0 + 1, y0 + T - 2], fill=CROSS, width=1)
pct = lambda x: '%.1f %%' % (100 * x / N)
fmt = lambda x: format(int(x), ',')
d.text((LEFT, 12), TITLE or 'Pocket Camera (Japan) Rev A: what is in each of the 64 banks (the ROM drawn as 2bpp tiles, code, data and padding alike)', fill=INK, font=F1)
if NOTE1 is not None:
    d.text((LEFT, 56), NOTE1, fill=INK, font=F2); d.text((LEFT, 82), NOTE2 or '', fill=INK, font=F2)
elif not DIFF: d.text((LEFT, 56), 'Each bank = 32 x 32 tiles = 16,384 bytes, banks $00..$3F left to right, top to bottom, like the reachability map above. The colour is the KIND of the bytes (symbol file labels and the v8 coverage classes);', fill=INK, font=F2)
if NOTE1 is None and not DIFF: d.text((LEFT, 82), 'the shade inside a colour is the tile pixel (2 bits), so graphics, text and code all stay visible. An outline marks the tiles (16 bytes) that no run reached. Kind evidence per label: roms/jp_rev_a/disasm/sym_names_jp.csv (C / I / ?).', fill=INK, font=F2)
elif NOTE1 is None:
    d.text((LEFT, 56), 'Each bank = 32 x 32 tiles = 16,384 bytes, banks $00..$3F left to right, top to bottom, like the Japanese map above. The colour is the KIND of the bytes (the symbol file ported from the Japanese tables and', fill=INK, font=F2)
    d.text((LEFT, 82), 'the static trace of this ROM: no emulator run of it exists). The shade is the tile pixel (2 bits). An outline marks the tiles (16 bytes) that differ from the Japanese ROM (docs 1.5). Kind evidence: roms/us_eu/disasm/sym_names_us*.csv.', fill=INK, font=F2)
def leg(x, y, i, w1=118, w2=70):
    k, tx, c = CATS[i]
    for s_ in range(4): d.rectangle([x + s_ * 11, y + 1, x + s_ * 11 + 10, y + 18], fill=i * 4 + s_)
    s = fmt(tot_cat[i]) + ' B'; d.text((x + 56 + w1 - d.textlength(s, font=F3), y - 1), s, fill=INK, font=F3)
    s = pct(tot_cat[i]); d.text((x + 56 + w1 + w2 - d.textlength(s, font=F3) + 6, y - 1), s, fill=(90, 90, 90), font=F3)
    d.text((x + 56 + w1 + w2 + 20, y - 1), tx, fill=INK, font=F3)
LEG_TOP = 122; XA, XB, XC = LEFT, LEFT + 1330, LEFT + 2800
d.text((XA, LEG_TOP), 'CODE (traced instructions), by the function of the routine that owns them', fill=INK, font=F3B)
d.text((XB, LEG_TOP), 'DATA, by what the bytes are (identified even when no code calls them)', fill=INK, font=F3B)
for i in range(11): leg(XA, LEG_TOP + 32 + i * 27, i)
for j in range(11, len(CATS)): leg(XB, LEG_TOP + 32 + (j - 11) * 27, j)
d.text((XC, LEG_TOP), {'reach': 'OUTLINE: tiles that no run reached (16-byte tiles)', 'diff': 'OUTLINE: tiles that differ from the Japanese ROM (16-byte tiles)',
                       'none': 'OUTLINE: none yet (no run and no comparison for this ROM)'}[OUTLINE], fill=INK, font=F3B)
yy = LEG_TOP + 32
for m, col in {'reach': ((0, INK), (1, RED), (2, BLUE)), 'diff': ((0, INK), (2, BLUE)), 'none': ()}[OUTLINE]:
    d.rectangle([XC, yy + 1, XC + 34, yy + 18], outline=col, width=3)
    s = fmt(mk_tot[m]) + ' B'; d.text((XC + 46 + 110 - d.textlength(s, font=F3), yy - 1), s, fill=INK, font=F3)
    d.text((XC + 46 + 130, yy - 1), (['never-run code, proven dead (evidence I; README 16.15, 16.21)', 'data that no run shows or reads: the REALLY unused assets (I; README 16.24)',
                                    'identified data the v8 run never read (I; README 16.13)'] if not DIFF else
                                    ['code new or changed in this build (no JP instruction pairs with it as the same code)', '',
                                     'data that differs from the Japanese bytes (new pictures, English text, moved tables)'])[m], fill=INK, font=F3); yy += 27
d.rectangle([XC, yy + 1, XC + 34, yy + 18], fill=FAM[KEY['PAD']][1]); d.line([XC + 4, yy + 3, XC + 30, yy + 16], fill=CROSS, width=2); d.line([XC + 30, yy + 3, XC + 4, yy + 16], fill=CROSS, width=2)
s = fmt(n_padtile) + ' tiles'; d.text((XC + 46 + 110 - d.textlength(s, font=F3), yy - 1), s, fill=INK, font=F3)
d.text((XC + 46 + 130, yy - 1), 'CROSS: a pure padding tile (all 16 bytes are padding)', fill=INK, font=F3); yy += 27
if OUTLINE == 'none':
    d.text((XC, yy + 4), 'Grey-blue = not analysed yet: the colours replace it as names, types and a trace are added to this ROM.', fill=INK, font=F4)
    d.text((XC, yy + 28), 'Padding is %s B (runs of 16+ x 00 / FF); %s B of it lie in whole tiles (crossed).' % (fmt(tot_cat[KEY['PAD']]), fmt(16 * n_padtile)), fill=INK, font=F4)
    d.text((XC, yy + 52), 'Per bank, in the title: the two largest kinds (padding excluded).', fill=INK, font=F4)
elif not DIFF:
    d.text((XC, yy + 4), 'Not outlined: everything that at least one run executed, read or showed, and padding.', fill=INK, font=F4)
    d.text((XC, yy + 28), 'Padding is %s B, of which %s B no run touched; %s B of it lie in whole tiles (crossed).' % (fmt(tot_cat[KEY['PAD']]), fmt(mk_tot[3]), fmt(16 * n_padtile)), fill=INK, font=F4)
    d.text((XC, yy + 52), 'Per bank, in the title: the two largest kinds (padding excluded) and the unreachable bytes.', fill=INK, font=F4)
else:
    d.text((XC, yy + 4), 'Not outlined: code paired with the Japanese code (identical, or another address operand), data equal to its Japanese bytes, and padding.', fill=INK, font=F4)
    d.text((XC, yy + 28), 'Padding is %s B; %s B of it lie in whole tiles (crossed). No emulator run of this ROM: the code colour is its static trace.' % (fmt(tot_cat[KEY['PAD']]), fmt(16 * n_padtile)), fill=INK, font=F4)
    d.text((XC, yy + 52), 'Per bank, in the title: the two largest kinds (padding excluded) and the bytes that differ from the Japanese ROM.', fill=INK, font=F4)
for b in range(banks):
    gx = LEFT + (b % 8) * (256 * S + GX); gy = TOP + (b // 8) * (256 * S + GY)
    d.text((gx, gy + 2), '$%02X' % b, fill=INK, font=F3B)
    pb = per_bank[b].copy(); pb[KEY['PAD']] = 0
    top2 = [i for i in np.argsort(-pb, kind='stable')[:2] if pb[i] >= 0x4000 // 100]
    x = gx + 52
    for i in top2:
        d.rectangle([x, gy + 5, x + 12, gy + 18], fill=CATS[i][2], outline=(60, 60, 60))
        tx_ = '%s %d %%' % (SHORT[CATS[i][0]], round(100 * pb[i] / 0x4000)); d.text((x + 17, gy + 3), tx_, fill=INK, font=F5); x += 17 + int(d.textlength(tx_, font=F5)) + 14
    parts = [(n, int(mk_bank[b][m])) for m, n in enumerate(['never-run code', 'unused data', 'unread, identified'] if not DIFF else ['new / changed code', '', 'changed data']) if mk_bank[b][m]]
    if parts: d.text((gx, gy + 28), '   '.join('%s %s B' % (n, fmt(v)) for n, v in parts), fill=INK, font=F5)
img.save(OUT, optimize=True)
print(img.size, os.path.getsize(OUT), 'bytes')
for i, (k, tx, c) in enumerate(CATS): print('%-6s %9s  %5s  %s' % (k, fmt(tot_cat[i]), pct(tot_cat[i]), tx[:60]))
print('marks', [int(x) for x in mk_tot]); print('pure padding tiles', n_padtile, 16 * n_padtile, 'B')
