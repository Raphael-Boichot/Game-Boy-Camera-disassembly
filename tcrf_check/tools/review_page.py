#!/usr/bin/env python3
"""Builds the review page (one self-contained HTML): TCRF image next to the ROM span it matches, every unused graphic / table with tile, map and hex views,
the 17 sounds the replays never asked for, and sound data drawn as tiles for reference (README 16.24).
usage: review_page.py OUT.html [TCRF_IMAGE_DIR]     (reads really_unused.csv, open_assets.csv, really_unused_sounds.csv, display_union.npz, the coverage file, the ROM)"""
import sys, os, csv, json, base64, glob, collections
import numpy as np
REPO = os.environ.get('GBCAM_REPO', os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
OUT = sys.argv[1]
TD = sys.argv[2] if len(sys.argv) > 2 else '/tmp/claude-0/-home-claude/d280987c-d04f-542c-b2b0-9c89688a96f6/scratchpad/tcrfzip/Unused graphics according to TCRF'
ROM = open(os.environ.get('GBCAM_ROM', '/home/claude/tc/pocketcamera_jp.gb'), 'rb').read()
U = np.load(REPO + '/tcrf_check/assets/display_run/display_union.npz'); fr = U['fr'].astype(int); fro = U['fro'].astype(int)
cov = np.load(os.environ.get('COV', '/home/claude/w/test_am/coverage/v8/merged_v8/cov.npz')); dr = cov['dr']; odr = cov['odr']
A = REPO + '/tcrf_check/assets/unidentified/'
def off(b, a): return a if b == 0 else b * 0x4000 + (a - 0x4000)
def H(x): return int(x, 16)
def b64(b): return base64.b64encode(b).decode()
def ev_span(o, n):
    tiles = [(int(fr[o + i:o + i + 16].max()), int(fro[o + i:o + i + 16].max())) for i in range(0, max(n - 15, 1), 16) if any(x not in (0, 255) for x in ROM[o + i:o + i + 16])]
    rd = int((dr[o:o + n] > 0).sum()); ro = int((odr[o:o + n] > 0).sum())
    st = sum(1 for t in tiles if t[0] >= 15); so = sum(1 for t in tiles if t[1] >= 15); mx = max([t[0] for t in tiles] or [0])
    if not tiles: return 'only blank bytes'
    if st == 0: return ('Never on screen in any replay. Read only when state is forced.' if rd and not ro else ('Never on screen in any replay and never read.' if not rd else 'Never on screen (read in play, not shown).'))
    if so == 0: return 'On screen only when state is forced (%d of %d tiles, up to %s frames).' % (st, len(tiles), '65535+' if mx >= 65535 else mx)
    return 'On screen in normal play (%d of %d tiles, up to %s frames).' % (so, len(tiles), '65535+' if mx >= 65535 else mx)
# ---- cards from the report
op = {(r['bank'], r['addr']): r for r in csv.DictReader(open(A + 'open_assets.csv', encoding='utf-8'))}
cards = []
for r in csv.DictReader(open(A + 'really_unused.csv', encoding='utf-8')):
    b, a, n = H(r['bank']), H(r['addr']), int(r['bytes']); o = off(b, a); k = r['kind']; tier = r['tier']
    if tier == 'shown': sec = 'shown'
    elif k == 'Map': sec = 'maps'
    elif tier == 'TCRF': sec = 'tcrf'
    elif tier == 'never shown': sec = 'never'
    elif tier == 'forced only': sec = 'forced'
    elif tier == 'scrap': sec = 'scrap'
    else: sec = 'other'
    if k == 'Map' and tier == 'shown': sec = 'maps_shown'
    x = op.get((r['bank'], r['addr']), {})
    cards.append(dict(k='ast_%s_%s' % (r['bank'], r['addr']), sec=sec, bank=r['bank'], addr=r['addr'], n=n, name=r['name'], kind=k, ev=ev_span(o, n),
                      guess=(x.get('best_guess') or '')[:230], grp=x.get('group', ''), tcrf=x.get('tcrf_ids', ''), d=b64(ROM[o:o + n]),
                      cols=(32 if k == 'Map' else (4 if n < 128 else 16)), mode=('grey' if k == 'Map' else ('hex' if sec in ('other', 'scrap') and n < 64 else 'tiles'))))
# ---- TCRF list: image + the ROM blocks that match
def P(bank, addr, n): return (bank, addr, n)
TCRF = [
 ('GBCamera-CannotCombine', 'Cannot combine the same picture', 'exact', 'All 56 tiles equal, 8 tiles wide.', [dict(parts=[P(0x1E, 0x6600, 896)], cols=8)]),
 ('GBCamera-MiddleBeforeAfterHave', 'Kanji: middle / before / after / have', 'exact', 'All 16 tiles equal under a shaded palette. The strip sits in two rows of a 16-tile-wide sheet, 0x100 bytes apart.', [dict(parts=[P(0x0D, 0x7660, 128), P(0x0D, 0x7760, 128)], cols=8)]),
 ('GBCamera-UnusedX', 'Poorly drawn X after the Magic menu', 'intl', 'Not in this ROM. It is in the international ROM at 0D:5200-5CFF (checklist B12).', []),
 ('Game_Boy_Camera_Unused_Album_Hand_Gestures', 'Album: unused hand gestures', 'partial', 'The picture is a crop of this 16-tile-wide sheet: 23 of 32 non-blank tiles found (13:5CA0-5CF0 and the same columns 0x100 and 0x200 lower, plus 5A40-5AB0, 5AE0-5AF0, 5BC0-5BF0). Part of it is on screen in normal play.', [dict(parts=[P(0x13, 0x5A00, 1536)], cols=16)]),
 ('Game_Boy_Camera_Unused_Bank', 'Unused graphic bank (hand with newspaper)', 'none', 'Not located. Only scattered single tiles match (161 of 496), nothing in a row.', []),
 ('Game_Boy_Camera_Unused_Bank_Tile', 'Tile in the unused bank', 'none', 'No tile of the ROM matches under any palette or flip.', []),
 ('Game_Boy_Camera_Unused_DJ_Music_Tile', 'D.J. music tile', 'none', 'Not located (1 of 4 tiles at 0C:70AF, nothing around it).', []),
 ('Game_Boy_Camera_Unused_Hot_Spot_Graphical_Effects', 'Hot-spot effect icons (8 extra)', 'span', 'Located by span only (checklist B05): 8 icons of 64 bytes at 1C:5920-5B1F. Not pixel-exact in the matcher; compare by eye.', [dict(parts=[P(0x1C, 0x5920 + 64 * i, 64)], cols=2) for i in range(8)]),
 ('Game_Boy_Camera_Unused_Japanese_Menu_Tile', 'Japanese menu tile (circled X)', 'candidate', 'The ROM tile is 8x8 and the picture is 14x14, so no exact match. Three identical copies at 15:4480, 4500, 4580.', [dict(parts=[P(0x15, 0x4480, 16)], cols=1), dict(parts=[P(0x15, 0x4500, 16)], cols=1), dict(parts=[P(0x15, 0x4580, 16)], cols=1)]),
 ('Game_Boy_Camera_Unused_Magic_Bank_Tile', 'Magic bank tile', 'candidate', 'The pattern tile occurs at many offsets of 0D:7000-765F (the fill-pattern tiles, never on screen).', [dict(parts=[P(0x0D, 0x7000, 128)], cols=8)]),
 ('Game_Boy_Camera_Unused_Magic_Bank_Tiles', 'Magic bank tiles', 'partial', 'All 20 non-blank tiles occur somewhere in 0D:7870-7AB0, but not in the layout of the picture. Whole area shown.', [dict(parts=[P(0x0D, 0x7800, 768)], cols=16)]),
 ('Game_Boy_Camera_Unused_Margin_Print_B_Film_Roll', 'Margin print: B film roll', 'span', 'Located by span (checklist B07), 4 of 24 tiles pixel-equal only. Compare by eye.', [dict(parts=[P(0x18, 0x5A50, 96)], cols=6)]),
 ('Game_Boy_Camera_Unused_Margin_Print_Font', 'Margin print: font', 'span', 'Located by span (checklist B07), 5 of 40 tiles pixel-equal only. Compare by eye.', [dict(parts=[P(0x18, 0x5F90, 192)], cols=12)]),
 ('Game_Boy_Camera_Unused_Menu_Tile', 'Menu tile', 'none', 'Not located (2 of 6 tiles at 0A:5435 / 543D).', []),
 ('Game_Boy_Camera_Unused_Photo_Option_B_CANCEL', 'Photo option: B CANCEL', 'exact', 'All 6 tiles equal (the picture is a 2x enlargement, 0 differing pixels of 384).', [dict(parts=[P(0x1A, 0x7D80, 96)], cols=6)]),
 ('Game_Boy_Camera_Unused_Photo_Option_Icon', 'Photo option: icon', 'candidate', 'Two identical tiles at 1A:7C90 and 7CA0 equal the picture, but they are on screen in normal play.', [dict(parts=[P(0x1A, 0x7C90, 32)], cols=2)]),
 ('Game_Boy_Camera_Unused_Photo_Option_Tile', 'Photo option: tile', 'none', 'No tile of the ROM matches under any palette or flip.', []),
 ('Game_Boy_Camera_Unused_Run_Run_Run_Star', 'RUN! RUN! RUN!: star', 'candidate', 'One tile at an odd address, 1B:618A, equals the 7x7 star under a 3-level palette.', [dict(parts=[P(0x1B, 0x618A, 16)], cols=1)]),
 ('Game_Boy_Camera_Unused_SOUND_Print_Modulation_Icon', 'SOUND print modulation icon', 'exact', 'All 4 tiles equal: top row at 10:7A80, bottom row 0x100 bytes later at 10:7B80.', [dict(parts=[P(0x10, 0x7A80, 32), P(0x10, 0x7B80, 32)], cols=2)]),
]
tc = []
for stem, title, status, note, blocks in TCRF:
    f = TD + '/' + stem + '.png'
    from PIL import Image
    im = Image.open(f); w, h = im.size; a = np.array(im.convert('L')); sc = 1
    for s in (2, 3, 4):
        if h % s == 0 and w % s == 0 and (np.repeat(np.repeat(a[::s, ::s], s, 0), s, 1) == a).all(): sc = s; break
    data = b''; bl = []; locs = []; evs = []
    for bk in blocks:
        o0 = len(data)
        for (b, ad, n) in bk['parts']:
            o = off(b, ad); data += ROM[o:o + n]; locs.append('%02X:%04X-%04X' % (b, ad, ad + n - 1)); evs.append(ev_span(o, n))
        bl.append(dict(o=o0, l=len(data) - o0, cols=bk['cols']))
    tc.append(dict(k='tcrf_' + stem.replace('Game_Boy_Camera_Unused_', '').replace('GBCamera-', ''), title=title, status=status, note=note, img='data:image/png;base64,' + b64(open(f, 'rb').read()), w=w, h=h, sc=sc,
                   blocks=bl, d=b64(data), loc=', '.join(locs), ev=(evs[0] if len(set(evs)) == 1 else ' / '.join(sorted(set(evs))))[:300] if evs else ''))
# ---- sounds
KIND = {'music': 'Song', 'sfx1': 'Effect, channel 1 (pulse)', 'sfx3': 'Effect, channel 3 (wave)', 'sfx4': 'Effect, channel 4 (noise)'}
snd = []
for r in csv.DictReader(open(A + 'really_unused_sounds.csv', encoding='utf-8')):
    snd.append(dict(k='snd_%s_%s' % (r['channel'], r['id']), ch=r['channel'], kind=KIND[r['channel']], id=r['id'], tag=r['tag'], status=r['status'], handler=r['handler'], callers=int(r['static_callers']), lists=r['picker_lists'], same=r['same_handler_as'], tier=r['tier'], file='audio/%s_%s.mp3' % (r['channel'], r['id'])))
# ---- reference: sound data drawn as tiles
refs = []
for nm, b, a, n, txt in (('Song data, sound 01 (title music) and the start of the next song', 0x1F, 0x6874, 460, 'Header and note data of the title music, bank 1F (checklist B04).'),
                         ('Four songs of data in a row', 0x1F, 0x6A40, 1024, 'The bytes after it, 1 KB of song data (sounds 03, 35, 05 and neighbours).')):
    o = off(b, a); refs.append(dict(k='ref_%02X_%04X' % (b, a), sec='ref', bank='%02X' % b, addr='%04X' % a, n=n, name=nm, kind='Ref', ev=txt, guess='', grp='', tcrf='', d=b64(ROM[o:o + n]), cols=16, mode='tiles'))
data = dict(cards=cards + refs, tcrf=tc, sounds=snd)
js = json.dumps(data, ensure_ascii=False, separators=(',', ':')).replace('</', '<\\/')
tpl = open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'review_page.tpl.html'), encoding='utf-8').read()
open(OUT, 'w', encoding='utf-8').write(tpl.replace('/*DATA*/', js))
print(collections.Counter(c['sec'] for c in cards), len(tc), len(snd), len(js))
