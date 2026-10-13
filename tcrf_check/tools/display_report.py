#!/usr/bin/env python3
"""REALLY unused assets: ONE picture (really_unused.png) + CSVs, from the display-tracking replays (README 16.24).
Inputs : display_union.npz (disp, fr, fro, snd = union of display_replay.py / display_stamps.py runs; or --npz-dir DIR to build it from DIR/*.npz),
         open_assets.csv (unidentified_sheets.py), sound_inventory.csv, disasm/sym_names_jp.csv + sym_types_jp.csv (the Unused_TCRF_* spans),
         the coverage file (organic / forced ROM reads; COV env, default merged_v8/cov.npz), the ROM.
Verdict of a graphic span: the tiles are 'on screen' when a byte of the tile row is fetched by the PPU model in >= STABLE (15) distinct frames
(a screen being loaded flashes tiles for 1-3 frames; those do not count).  organic = no state poke in the lineage of the run.
  TCRF         = a label Unused_TCRF_* (graphics the owner supplied from TCRF, located in the ROM)
  never shown  = no stable frame at all, and never read in an organic run
  forced only  = stable frames only in forced runs (no organic route found)
usage: display_report.py [--npz-dir DIR] [--stable N]"""
import sys, os, csv, glob, json, collections, argparse
import numpy as np
from PIL import Image, ImageDraw, ImageFont
ap = argparse.ArgumentParser(); ap.add_argument('--npz-dir'); ap.add_argument('--stable', type=int, default=15); ap.add_argument('--out')
args = ap.parse_args()
REPO = os.environ.get('GBCAM_REPO', os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
OUT = args.out or REPO + '/tcrf_check/assets/unidentified'
UNION = REPO + '/tcrf_check/assets/display_run/display_union.npz'
ROM = open(os.environ.get('GBCAM_ROM', '/home/claude/tc/pocketcamera_jp.gb'), 'rb').read()
COV = os.environ.get('COV', '/home/claude/w/test_am/coverage/v8/merged_v8/cov.npz')
STABLE = args.stable
if args.npz_dir:
    fr = np.zeros(1 << 20, np.uint32); fro = np.zeros(1 << 20, np.uint32); snd = np.zeros((8, 256), np.uint8); disp = np.zeros(1 << 20, np.uint8)
    for f in sorted(glob.glob(args.npz_dir + '/*.npz')):
        z = np.load(f)
        if 'fr' in z and 'snd' in z: fr += z['fr']; fro += z['fro']; disp |= z['disp']; snd |= z['snd']
    os.makedirs(os.path.dirname(UNION), exist_ok=True)
    np.savez_compressed(UNION, disp=disp, fr=np.minimum(fr, 65535).astype(np.uint16), fro=np.minimum(fro, 65535).astype(np.uint16), snd=snd)
U = np.load(UNION); fr = U['fr'].astype(np.int64); fro = U['fro'].astype(np.int64); snd = U['snd']
cov = np.load(COV); odr = cov['odr']; dr = cov['dr']
def off(b, a): return a if b == 0 else b * 0x4000 + (a - 0x4000)
def ba(o): b = o >> 14; return '%02X:%04X' % (b, 0x4000 + (o & 0x3FFF)) if b else '00:%04X' % o
def tilestat(o):
    seg = ROM[o:o + 16]
    if all(x in (0, 0xFF) for x in seg): return None
    return int(fr[o:o + 16].max()), int(fro[o:o + 16].max())
def verdict(o, n):
    info = [t for t in (tilestat(o + i) for i in range(0, n - 15, 16)) if t is not None]
    nstab = sum(1 for t in info if t[0] >= STABLE); norg = sum(1 for t in info if t[1] >= STABLE); nfl = sum(1 for t in info if 0 < t[0] < STABLE)
    rd = int((dr[o:o + n] > 0).sum()); ro = int((odr[o:o + n] > 0).sum())
    return dict(maxfro=max([t[1] for t in info] or [0]), tiles=len(info), stable=nstab, stable_org=norg, flash=nfl, read=rd, read_org=ro, maxfr=max([t[0] for t in info] or [0]))
# ---- rows
rows = []
for r in csv.DictReader(open(OUT + '/open_assets.csv', encoding='utf-8')):
    b = int(r['bank'], 16); a = int(r['addr'], 16); n = int(r['bytes']); k = r['name'].split('_')[0]
    rows.append(dict(bank=r['bank'], addr=r['addr'], b=b, a=a, n=n, name=r['name'], kind=k, tcrf=r['tcrf_ids'], src='open'))
names = {}
for r in csv.DictReader(open(REPO + '/disasm/sym_names_jp.csv', encoding='utf-8')): names[(int(r['bank'], 16), int(r['addr'], 16))] = r
types = {}
for r in csv.DictReader(open(REPO + '/disasm/sym_types_jp.csv', encoding='utf-8')): types[(int(r['bank'], 16), int(r['start'], 16))] = int(r['end'], 16)
for (b, a), r in sorted(names.items()):
    if r['name'].startswith('Unused_TCRF_'):
        e = types.get((b, a), a + 16)
        rows.append(dict(bank='%02X' % b, addr='%04X' % a, b=b, a=a, n=e - a, name=r['name'], kind='TCRF', tcrf='', src='tcrf', conf=r['conf']))
# spans listed by hand (unused_manual.csv): a code search and BGB say that no ROM code loads them, whatever the tracker saw (README 16.24 (3));
# they replace the open rows they overlap, and a span that is not an open asset in the sym is added
MAN = OUT + '/unused_manual.csv'
if os.path.exists(MAN):
    for m in csv.DictReader(open(MAN, encoding='utf-8')):
        b = int(m['bank'], 16); a = int(m['start'], 16); e = int(m['end'], 16)
        rows[:] = [r for r in rows if not (r['b'] == b and a <= r['a'] <= e)]
        rows.append(dict(bank=m['bank'], addr=m['start'].upper(), b=b, a=a, n=e - a + 1, name=names[(b, a)]['name'], kind=m['kind'], tcrf='', src='manual', note=m['note']))
for r in rows:
    o = off(r['b'], r['a']); r['v'] = verdict(o, r['n'])
    v = r['v']
    if r['src'] == 'manual':
        r['tier'] = 'no loader'
    elif r['kind'] == 'TCRF':
        r['tier'] = 'TCRF'
    elif r['kind'] in ('Gfx', 'Banner', 'Map'):
        r['tier'] = 'shown' if v['stable_org'] else ('forced only' if v['stable'] else ('never shown' if v['read_org'] == 0 else 'read organically, never shown'))
    else:
        r['tier'] = 'scrap' if (v['stable'] == 0 and v['read_org'] == 0) else 'other'
# ---- sounds
CH = {'sfx1': (0, 4), 'music': (1, 5), 'sfx3': (2, 6), 'sfx4': (3, 7)}
# The Space Fever II key-log replay (sf2_sound.py, organic corpus, no poke) is not part of the menu / stamp replays above: an id it requested counts as organic
# (music 32 and sfx1 26 were listed as "only forced" until this was added, although credits_parlor/sf2_sounds.csv had them since §16.18)
SF2 = set()
_sf2 = REPO + '/tcrf_check/assets/credits_parlor/sf2_sounds.csv'
if os.path.exists(_sf2):
    for r in csv.DictReader(open(_sf2, encoding='utf-8')):
        if int(r['mailbox_requests_seen']) > 0: SF2.add((r['channel'], r['id'].upper()))
sounds = []
for r in csv.DictReader(open(OUT + '/sound_inventory.csv', encoding='utf-8')):
    rq, run = CH[r['channel']]; i = int(r['id'], 16); seen = int(snd[rq][i]) | int(snd[run][i])
    dyn = 'organic' if seen & 2 else ('forced only' if seen & 1 else 'never')
    if (r['channel'], r['id'].upper()) in SF2: dyn = 'organic'
    ncall = int(r['static_callers']); lst = bool(r['picker_lists'])
    if dyn == 'organic': continue
    if dyn == 'never' and not ncall and not lst: tier = 'A never requested, no caller, no list'
    elif dyn == 'never': tier = 'B in a picker list, never chosen'
    elif not ncall and not lst and r['same_as']: tier = 'C alias of a used id, only forced'
    elif not ncall and not lst: tier = 'A never requested organically, no caller, no list'
    elif not ncall: tier = 'B in a picker list, never chosen'
    else: tier = 'D has a caller, only reached when forced'
    sounds.append(dict(channel=r['channel'], id=r['id'], tag=r['tag'], status=r['status'], handler=r['handler'], callers=ncall, lists=r['picker_lists'][:60], same_as=r['same_as'], dynamic=dyn, tier=tier))
sounds.sort(key=lambda s: (s['tier'], s['channel'], s['id']))
with open(OUT + '/really_unused_sounds.csv', 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['channel', 'id', 'tag', 'status', 'handler', 'static_callers', 'picker_lists', 'same_handler_as', 'replays', 'tier'])
    for s in sounds: w.writerow([s['channel'], s['id'], s['tag'], s['status'], s['handler'], s['callers'], s['lists'], s['same_as'], s['dynamic'], s['tier']])
with open(OUT + '/really_unused.csv', 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['bank', 'addr', 'bytes', 'name', 'kind', 'tier', 'info_tiles', 'tiles_on_screen_stable', 'stable_in_organic_runs', 'flash_only_tiles', 'max_frames_on_screen', 'bytes_read_any_run', 'bytes_read_organic', 'tcrf_ids', 'note'])
    for r in rows:
        v = r['v']; w.writerow([r['bank'], r['addr'], r['n'], r['name'], r['kind'], r['tier'], v['tiles'], v['stable'], v['stable_org'], v['flash'], v['maxfr'], v['read'], v['read_org'], r['tcrf'], r.get('note', '')])
# ---- picture
PAL = [255, 170, 85, 0]
FONT = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf', 12); FONTS = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf', 10)
FONTB = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSansMono-Bold.ttf', 12); FONTH = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSansMono-Bold.ttf', 15)
SC, GAP, COLN = 2, 14, 5
CW = 16 * 8 * SC + GAP * 2; WIDTH = CW * COLN + GAP
COL = {'no loader': (0, 120, 130), 'TCRF': (160, 40, 160), 'never shown': (200, 30, 30), 'forced only': (215, 150, 20), 'read organically, never shown': (120, 120, 120), 'scrap': (130, 130, 130)}
def tiles(d, cols=16):
    n = len(d) // 16; rws = (n + cols - 1) // cols
    im = Image.new('L', (min(n, cols) * 8, max(rws, 1) * 8), 255); px = im.load()
    for t in range(n):
        for y in range(8):
            b0 = d[t * 16 + y * 2]; b1 = d[t * 16 + y * 2 + 1]
            for x in range(8): px[(t % cols) * 8 + x, (t // cols) * 8 + y] = PAL[((b1 >> (7 - x)) & 1) << 1 | ((b0 >> (7 - x)) & 1)]
    return im.resize((im.width * SC, im.height * SC), Image.NEAREST).convert('RGB')
def greymap(d, cols=32):
    rws = (len(d) + cols - 1) // cols; im = Image.new('L', (cols, rws), 255); im.putdata(list(d) + [255] * (cols * rws - len(d)))
    return im.resize((cols * 8, rws * 8), Image.NEAREST).convert('RGB')
def wrap(s, n):
    import textwrap
    return textwrap.wrap(s, n, break_long_words=True, break_on_hyphens=False) or ['']
def short(nm):
    p = nm.split('_')
    return nm[nm.index('_', 4) + 1:] if p[0] in ('Gfx', 'Map', 'Src', 'Banner') and nm.count('_') > 1 else nm
def evidence(r):
    v = r['v']; fm = ('%d' % v['maxfr']) if v['maxfr'] < 65535 else '65535+'
    if r['tier'] == 'no loader': return 'no loader in either ROM (code search + BGB); tracker: %d of %d tiles on screen, %s frames' % (v['stable'], v['tiles'], fm)
    if r['tier'] == 'forced only': return 'on screen only in forced runs (%d frames)' % v['maxfr']
    if r['tier'] == 'TCRF':
        if v['stable'] == 0 and v['read_org'] == 0: return 'never on screen; read only in forced runs' if v['read'] else 'never read'
        if v['stable'] == 0: return 'never stably on screen (%d flash tiles)' % v['flash']
        o = 'ORGANIC runs: %d of %d tiles, max %d frames' % (v['stable_org'], v['tiles'], v['maxfro']) if v['stable_org'] else ('organic runs: never on screen' if v['maxfro'] == 0 else 'organic runs: at most %d frames (transitional)' % v['maxfro'])
        return 'forced runs: %d of %d tiles stable, max %s frames; %s' % (v['stable'], v['tiles'], fm, o)
    if v['read_org'] == 0 and v['stable'] == 0: return 'never on screen; read only in forced runs' if v['read'] else 'never read'
    if v['stable'] == 0: return 'never stably on screen (%d flash tiles)' % v['flash']
    return 'on screen %s frames (%d of %d tiles stable)' % (fm, v['stable'], v['tiles'])
# ---- the same list as a Markdown table (pasted into README 16.24): spans never on screen in a run without state pokes
TIER_TXT = {'no loader': 'no loader (hand-listed)', 'never shown': 'never shown', 'forced only': 'forced runs only', 'TCRF': 'TCRF label'}
UNUSED_TIERS = ('no loader', 'never shown', 'forced only')
sel = [r for r in rows if r['tier'] in UNUSED_TIERS or (r['tier'] == 'TCRF' and r['v']['stable_org'] == 0)]
sel.sort(key=lambda r: (r['b'], r['a']))
with open(OUT + '/really_unused.md', 'w', encoding='utf-8') as f:
    f.write('| span | bytes | label | tier | what the replays saw |\n|---|---|---|---|---|\n')
    for r in sel:
        f.write('| `%s:%s` | %d | `%s` | %s | %s |\n' % (r['bank'], r['addr'], r['n'], r['name'], TIER_TXT[r['tier']], (evidence(r) + ('; ' + r['note'] if r.get('note') else '')).replace('|', '/')))
    f.write('| | **%s** | **%d spans** | | |\n' % (format(sum(r['n'] for r in sel), ','), len(sel)))
def cell(r):
    o = off(r['b'], r['a']); d = ROM[o:o + r['n']]
    img = greymap(d) if r['kind'] == 'Map' else tiles(d[:len(d) // 16 * 16])
    drawn = ''
    pic = OUT + '/23_5CC0_map_screen.png'      # the unused stand-by screen drawn through its tile set (map_23_5CC0_screen.py): shown instead of the map's byte values
    if r['tier'] == 'no loader' and r['kind'] == 'Map' and os.path.exists(pic):
        im = Image.open(pic).convert('RGB'); img = im.resize((16 * 8 * SC, round(im.height * 16 * 8 * SC / im.width)), Image.NEAREST); drawn = ', drawn through 14:4000'
    cap = ['%s:%s  %d B%s' % (r['bank'], r['addr'], r['n'], ('  (tile map%s)' % drawn) if r['kind'] == 'Map' else '')] + wrap(short(r['name']).replace('Unused_TCRF_', 'TCRF ') + (' (?)' if r.get('conf') == '?' else ''), 34)[:3] + wrap(evidence(r), 34)[:4]
    return cap, img
def section(rs, y0, title, sub):
    big = [cell(r) + (r,) for r in rs if r['kind'] in ('Gfx', 'Banner', 'Map', 'TCRF')]
    ncol = [0] * COLN; cols_ = [[] for _ in range(COLN)]
    for cap, img, r in big:
        h = 16 * len(cap) + img.height + 18; c = min(range(COLN), key=lambda k: ncol[k]); cols_[c].append((cap, img, r)); ncol[c] += h
    return big, cols_, (max(ncol) if big else 0)
by = collections.OrderedDict()
for t, ttl, sub in (('no loader', 'Unused alternate stand-by screen of the image exchange: no loader in either ROM', 'teal = hand-listed from a code search and BGB (unused_manual.csv): the tracker saw these bytes as a thumbnail or as value matches, but the exchange screen loads other banks (README 14.4, 16.24 (3))'),
                    ('TCRF', 'TCRF-documented unused graphics located in this ROM (sym labels Unused_TCRF_*)', 'purple = labelled from the images the owner supplied from TCRF; (?) = candidate (partial pixel match); ORGANIC = the tile was on screen in a run without state pokes'),
                    ('never shown', 'Never on screen and never read in an organic run', 'red = no stable frame in 37,370 replayed menu states and the stamp-menu walks, and only the forced runs ever read it (graphics and tile maps)'),
                    ('forced only', 'On screen only when state variables are forced', 'amber = shown by forced runs only; no organic route found, so probably not reachable on a real camera')):
    by[t] = ([r for r in rows if r['tier'] == t], ttl, sub)
secs = []
y = 70
for t, (rs, ttl, sub) in by.items():
    big, cols_, h = section(rs, y, ttl, sub); secs.append((t, ttl, sub, big, cols_, h))
scraps = [r for r in rows if r['tier'] == 'scrap']
# scraps flow layout
x = GAP; yy = 0; rowh = 0; place = []
for r in scraps:
    o = off(r['b'], r['a']); d = ROM[o:o + r['n']]
    capt = '%s:%s %dB' % (r['bank'], r['addr'], r['n']); img = tiles(d[:len(d) // 16 * 16], cols=4) if len(d) >= 16 else None; hexs = d.hex() if len(d) < 16 else ''
    w_ = max(img.width if img else 0, len(capt) * 6 + 6, len(hexs) * 6 + 6); h_ = 12 + (img.height if img else 12) + 4
    if x + w_ > WIDTH - GAP: x = GAP; yy += rowh + 6; rowh = 0
    place.append((x, yy, capt, img, hexs)); x += w_ + 10; rowh = max(rowh, h_)
scrap_h = yy + rowh + 10
SOUND_ROWH = 15
total = 70 + sum(60 + s[5] for s in secs) + 60 + scrap_h + 70 + SOUND_ROWH * (len(sounds) + 6) + 150
sheet = Image.new('RGB', (WIDTH, total), 'white'); dr_ = ImageDraw.Draw(sheet)
nshown = sum(1 for r in rows if r['tier'] == 'shown')
dr_.text((GAP, 8), 'REALLY unused assets, Game Boy Camera / Pocket Camera (Japan) Rev A', fill=(0, 0, 0), font=FONTH)
dr_.text((GAP, 30), 'Menu states replayed (%s) in an emulator core that follows every ROM byte to the screen; %d spans checked (open assets + 3 hand-listed), %d on screen.' % ('37,370 + stamp walks', sum(1 for r in rows if r['src'] in ('open', 'manual')), nshown), fill=(60, 60, 60), font=FONT)
dr_.text((GAP, 46), 'caption = bank:address, bytes, label, evidence; 2bpp tiles, 16 per row, x2 (tile maps: byte value as grey).', fill=(60, 60, 60), font=FONT)
y = 70
for t, ttl, sub, big, cols_, h in secs:
    c = COL[t]; dr_.rectangle([GAP, y, WIDTH - GAP, y + 3], fill=c)
    dr_.text((GAP, y + 8), '%s  (%d)' % (ttl, len(big)), fill=c, font=FONTB); dr_.text((GAP, y + 26), sub, fill=(90, 90, 90), font=FONT)
    yy = y + 50
    for ci, col in enumerate(cols_):
        y2 = yy
        for cap, img, r in col:
            xx = GAP + ci * CW
            for li, line in enumerate(cap): dr_.text((xx, y2 + 16 * li), line, fill=c if li == 0 else (80, 80, 80), font=FONTB if li == 0 else FONT)
            y2 += 16 * len(cap); sheet.paste(img, (xx, y2)); dr_.rectangle([xx - 1, y2 - 1, xx + img.width, y2 + img.height], outline=c); y2 += img.height + 18
    y += 60 + h
dr_.rectangle([GAP, y, WIDTH - GAP, y + 3], fill=COL['scrap'])
dr_.text((GAP, y + 8), 'Scraps: %d small unread blocks between assets (never on screen, never read in an organic run)' % len(scraps), fill=COL['scrap'], font=FONTB)
dr_.text((GAP, y + 26), '2bpp, 4 tiles per row, x2; under 16 B as hex. Padding fragments or tile slack, not assets of their own.', fill=(90, 90, 90), font=FONT)
for x, y3, capt, img, hexs in place:
    yy = y + 50 + y3; dr_.text((x, yy), capt, fill=(60, 60, 60), font=FONTS)
    if img: sheet.paste(img, (x, yy + 12))
    else: dr_.text((x, yy + 12), hexs, fill=(120, 120, 120), font=FONTS)
y += 60 + scrap_h
dr_.rectangle([GAP, y, WIDTH - GAP, y + 3], fill=(30, 90, 170))
dr_.text((GAP, y + 8), 'Sounds that the replays never asked for in an organic run (%d of 162 ids; the other %d were requested)' % (len(sounds), 162 - len(sounds)), fill=(30, 90, 170), font=FONTB)
dr_.text((GAP, y + 26), 'A = no caller, no list, never requested   B = in a picker list, never chosen   C = alias of a used id, only forced   D = has a caller, only forced', fill=(90, 90, 90), font=FONT)
yy = y + 48
for s in sounds:
    line = '%s  %-5s %s  handler %s  callers %d  %s%s' % (s['tier'][0], s['channel'], s['id'], s['handler'], s['callers'], (s['tag'] or s['status']), ('  same handler as ' + s['same_as']) if s['same_as'] else '')
    dr_.text((GAP, yy), line, fill=(0, 0, 0) if s['tier'][0] in 'AC' else (90, 90, 90), font=FONT); yy += SOUND_ROWH
yy += 8
dr_.text((GAP, yy), 'Nothing was HEARD: the replays log the request mailboxes (ids), not the audio. The core is not a real Game Boy: exploration is large, not exhaustive.', fill=(160, 40, 40), font=FONT); yy += 16
dr_.text((GAP, yy), 'Method and caveats: README 16.24.  Tools: gbcov_display.c, display_replay.py, display_stamps.py, display_report.py.  Data: really_unused.csv, really_unused_sounds.csv.', fill=(90, 90, 90), font=FONT)
sheet = sheet.crop((0, 0, WIDTH, yy + 30)); sheet.save(OUT + '/really_unused.png')
print({t: len(by[t][0]) for t in by}, 'scraps', len(scraps), 'sounds', len(sounds), 'size', sheet.size)
