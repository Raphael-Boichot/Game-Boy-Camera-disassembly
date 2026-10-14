#!/usr/bin/env python3
"""Builds the owner-answer page of the L3 pass of 2026-10-14 (one self-contained HTML, answers saved through the artifact `db` capability, collection `answers`,
one doc per item: {verdict, note, item, time}; the answers are then copied into disasm/owner_answers_jp.csv by hand / by a short script).
What it asks: what needs ears or eyes and cannot be read from the code -- the sound tags (disasm/sym_unconclusive_jp.csv, group "SFX tag", merged per id), the
SHOOT effect variants (06:60DB -> 0A:541A), the screens of the modes whose state names are generic, and six graphics (the remaining `?` spans and the two TCRF candidates).
usage: owner_page.py OUT.html [TCRF_IMAGE_DIR]     (reads disasm/sym_unconclusive_jp.csv, sym_names_jp.csv, the ROM and the two TCRF PNGs)"""
import sys, os, csv, re, json, base64, collections
REPO = os.environ.get('GBCAM_REPO', os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
OUT = sys.argv[1]
TD = sys.argv[2] if len(sys.argv) > 2 else '/tmp/claude-0/-home-claude/d280987c-d04f-542c-b2b0-9c89688a96f6/scratchpad/tcrfzip/Unused graphics according to TCRF'
ROM = open(os.environ.get('GBCAM_ROM', '/home/claude/gbcam_jp/pocketcamera_jp.gb'), 'rb').read()
def off(b, a): return a if b == 0 else b * 0x4000 + (a - 0x4000)
def rd(b, a, n): o = off(b, a); return ROM[o:o + n]
def b64(x): return base64.b64encode(x).decode()
names = list(csv.DictReader(open(REPO + '/disasm/sym_names_jp.csv', encoding='utf-8')))
doubt = list(csv.DictReader(open(REPO + '/disasm/sym_unconclusive_jp.csv', encoding='utf-8')))
note_of = {(r['bank'], r['addr']): r['note'] for r in names}
H = lambda s: int(s, 16)

# ---------------------------------------------------------------- sounds: one row per (channel, ids), Init and Step handlers merged
CHN = {'1': 'channel 1 (pulse + sweep)', '3': 'channel 3 (wave)', '4': 'channel 4 (noise)'}
groups = collections.OrderedDict()
for r in doubt:
    if r['group'] != 'SFX tag': continue
    m = re.match(r'Sfx(\d)_(Init|Step)_([0-9A-F]{2}(?:_[0-9A-F]{2})*)_?(\w*)$', r['name'])
    if not m: continue
    ch, kind, ids, tag = m.groups(); ids = tuple(ids.split('_'))
    g = groups.setdefault((ch, ids), dict(ch=ch, ids=ids, tags=[], addrs=[], owner=[]))
    if tag and tag not in g['tags']: g['tags'].append(tag)
    g['addrs'].append('%s:%s %s' % (r['bank'], r['addr'], kind))
    n = note_of.get((r['bank'], r['addr']), '')
    mo = re.search(r'Owner[^|]*', n)
    if mo and mo.group(0).strip() not in g['owner']: g['owner'].append(mo.group(0).strip()[:260])
# the two Space Fever II handlers of effect 24 (the owner heard them, no code evidence)
g = groups.setdefault(('1', ('24',)), dict(ch='1', ids=('24',), tags=[], addrs=[], owner=[]))
g['tags'].append('SpaceFeverII'); g['addrs'] += ['1F:43E4 Init', '1F:43EC Step']
g['owner'].append('you heard a Space Fever II sound for this id, no confidence given: which moment of the game is it?')
sounds = []
for (ch, ids), g in sorted(groups.items(), key=lambda kv: (kv[0][0], kv[0][1])):
    sounds.append(dict(key='snd_%s_%s' % (ch, '_'.join(ids)), ch=ch, chn=CHN[ch], ids=' '.join(ids), tag=' / '.join(g['tags']) or '-', addrs=', '.join(g['addrs']), owner=' '.join(g['owner'])))

# ---------------------------------------------------------------- SHOOT effect variants: 06:60DB (22 variants x 4 phases) | page 0 / $20 / $40 -> 0A:541A
tbl = list(rd(6, 0x60DB, 88))
slot_name = {}
for r in names:
    if r['bank'] != '0A': continue
    m = re.match(r'Fx([0-9A-F]{2})_(\w+)$', r['name'])
    if not m: continue
    sl = [m.group(1)]
    mm = re.search(r'effect table slot\(s\) ([0-9A-F;]+)', r['note'])
    if mm: sl = mm.group(1).split(';')
    for s in [x for x in sl if x]: slot_name[int(s, 16)] = (m.group(0), r['bank'] + ':' + r['addr'])
def sname(i):
    n = slot_name.get(i)
    return n[0] if n else 'slot %02X (not in the table of names)' % i
variants = []
for v in range(22):
    ph = tbl[4 * v:4 * v + 4]
    rows = []
    for p in (0x00, 0x20, 0x40): rows.append('page %d: ' % (p // 0x20) + ' '.join('%02X' % (x | p) for x in ph))
    uniq = []
    for x in ph:
        if x not in uniq: uniq.append(x)
    variants.append(dict(key='fx_var_%02X' % v, v='%02X' % v, phases=' '.join('%02X' % x for x in ph), pages=rows, names=[sname(x) for x in uniq]))

# ---------------------------------------------------------------- screens: one card per mode whose state names are generic
modes = collections.OrderedDict()
for r in doubt:
    if r['group'] != 'mode state': continue
    m = re.match(r'Mode([0-9A-F]{2})_(.*)$', r['name'])
    if not m: continue
    modes.setdefault(m.group(1), []).append(dict(n=m.group(2), a='%s:%s' % (r['bank'], r['addr']), e=r['evidence'][:90]))
mode_title = {}
for r in names:
    m = re.match(r'Mode([0-9A-F]{2})_([A-Za-z]+)$', r['name'])
    if m and r['conf'] == 'C' and m.group(1) not in mode_title: mode_title[m.group(1)] = m.group(2)
screens = [dict(key='mode_%s' % k, mode=k, title=mode_title.get(k, ''), states=v) for k, v in sorted(modes.items())]

# ---------------------------------------------------------------- pictures
def img(fn):
    p = os.path.join(TD, fn)
    return 'data:image/png;base64,' + b64(open(p, 'rb').read()) if os.path.exists(p) else ''
pics = [
 dict(key='gfx_0D_7000', title='0D:7000, 1,632 bytes', name='Gfx_0D_7000_FillPatternTiles', cols=16, data=b64(rd(0x0D, 0x7000, 0x660)),
      clue='Dot, crosshatch and dither tiles plus a few glyph pieces. No loader indexes it, nothing reads it in normal play. Do you recognise these as the fill patterns of a tool (paint bucket, pen patterns, hot-spot fills) or as part of a screen?'),
 dict(key='gfx_0C_5800', title='0C:5800, 576 bytes', name='Gfx_0C_5800_AnimEdMenuLabelsAlt', cols=16, data=b64(rd(0x0C, 0x5800, 576)),
      ctx=b64(rd(0x0C, 0x5A40, 0x100)), ctxcap='0C:5A40, loaded by the Animation editor menu (known)',
      clue='Looks like a second copy of the Animation editor menu labels (the strip below is the loaded one). Is it a different wording, a different language, or the same labels?'),
 dict(key='gfx_0C_6AB0', title='0C:6AB0, 384 bytes', name='Gfx_0C_6AB0_AnimEdKanaStrips_Tail', cols=16, data=b64(rd(0x0C, 0x6AB0, 0x180)),
      ctx=b64(rd(0x0C, 0x68D0, 0x1E0)), ctxcap='0C:68D0, the kana strips that are loaded (known)',
      clue='Kana strips like the ones loaded from 0C:68D0, but no loader reaches this tail. Do you see a kana row of the Animation editor that is not in the strip above?'),
 dict(key='gfx_14_4554', title='14:4550, tiles 85-258 of the unused stand-by screen', name='Gfx_14_4554_Mode0E_ExchangeAlt_StrayPtr', cols=16, data=b64(rd(0x14, 0x4550, 0xAE0)),
      clue='Second half of the tile set of the unused alternate stand-by screen of the image exchange (the first half is 14:4000, the map 23:5CC0). Does this look like a picture you have seen on the SEND / RECEIVE screen of any version of the game?'),
 dict(key='tcrf_13_5CA0', title='13:5A00-5FFF, candidate for the TCRF album hand gestures', name='Unused_TCRF_AlbumHandGestures_Gfx', cols=16, data=b64(rd(0x13, 0x5A00, 0x600)), ref=img('Game_Boy_Camera_Unused_Album_Hand_Gestures.png'), refcap='TCRF image',
      clue='The TCRF picture is a crop of this 16-tile-wide sheet (23 of 32 informative tiles found at 13:5CA0-5CF0, 5DA0-5DF0, 5EA0-5EF0 and 5A40-5AF0), but the tiles are on screen in normal play (22-26 frames). Is the TCRF hand gesture something you have seen in the album, or only on TCRF?'),
 dict(key='tcrf_1A_7C90', title='1A:7C80-7CBF, candidate for the TCRF photo option icon', name='Unused_TCRF_PhotoOptionIcon_Candidate_Gfx', cols=4, data=b64(rd(0x1A, 0x7C80, 0x40)), ref=img('Game_Boy_Camera_Unused_Photo_Option_Icon.png'), refcap='TCRF image',
      clue='Exact pixel match of the TCRF icon (2 tiles at 1A:7C90), but these tiles are on screen in normal play. Is this an icon you see in the photo option menu?'),
]
DATA = dict(sounds=sounds, variants=variants, screens=screens, pics=pics)
tpl = open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'owner_page.tpl.html'), encoding='utf-8').read()
html = tpl.replace('__DATA__', json.dumps(DATA, ensure_ascii=False).replace('</', '<\\/'))
open(OUT, 'w', encoding='utf-8').write(html)
print('sounds', len(sounds), 'variants', len(variants), 'screens', len(screens), 'pics', len(pics), 'bytes', len(html))
