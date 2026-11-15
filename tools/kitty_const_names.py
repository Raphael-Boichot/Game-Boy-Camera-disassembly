#!/usr/bin/env python3
"""Constants of Hello Kitty (L4, roadmap step 11, 2026-11-15): modes, states, key masks, palettes and sound ids.

  tools/kitty_const_names.py KITTY.gb [--check]

Writes, in the formats of the Japanese tables (tools/const_names.py reads them; tools/sym_fix.py --const will write the values with
these names in the source of L5):
  roms/hello_kitty/disasm/const_names_kitty.csv   group,value,name,tag,desc
      mode    one row per mode of the mode table (disasm/mode_names_kitty.csv): MODE_ + the mode name (CamelCase -> UPPER_SNAKE), its tag
      dmgpal  the Japanese rows (a palette byte means the same on every Game Boy), kept only for the values the code of this ROM
              loads into a palette shadow or the palette target (wBgpShadow / wObp0Shadow / wObp1Shadow / wPaletteTarget: the bytes 2-4 of
              the inline records of Lcd_SetupInline / Lcd_SetupInlineNoIE)
  roms/hello_kitty/disasm/state_names_kitty.csv   group state_NN per mode: a state gets a name only when disasm/screen_names_kitty.csv
      names its screen (STATE_NN_ + the screen name, UPPER_SNAKE, at most 6 words), with that row's tag; the other states stay numbers
  roms/hello_kitty/disasm/sound_names_kitty.csv   channel,id,name,tag,sites,desc,evidence: every immediate the proven code stores in a
      sound mailbox (`ld a, n` then `ld [nn], a`; the mailboxes are the Japanese ones, paired in ram_names_kitty.csv: wSndSfx1 $D060,
      wSndMusicReq $D068, wSndSfx3 $D070, wSndSfx4 $D078). A song is named after the screens that start it (the (mode, state) of each
      site: the state handler itself, else the first screen the routine ran on, trace/entry_modes_kitty.csv; then the screen or mode
      name), tag C; an effect is named after its routines when every site lies in one family of routines (the routine name without
      its trailing state / part), tag I, else it stays a number (SFX1_03), tag C for the channel only. Sound ids that only data holds
      (the object scripts' sound commands, the key-prompt sound tables 06:5DFA-06:5F7F) are typed in L5 with their tables.
  roms/hello_kitty/disasm/const_types_kitty.csv   variable,group,note: which RAM / register operands hold which group
  roms/hello_kitty/disasm/const_kitty.inc         the EQUs (tools/const_names.py)
The key masks (group pad: PADF_*) need no table of their own: Joy_Read stores the keys in the hardware.inc order (bit 0 A .. bit 7 Down),
checked on three boot conditions: $0F soft reset (A + B + Select + Start), $0C the erase screen (Select + Start), $FD the factory check.
"""
import argparse, bisect, collections, csv, io, json, os, re, subprocess, sys
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); KD = os.path.join(REPO, 'roms', 'hello_kitty'); DD = os.path.join(KD, 'disasm')
ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('--check', action='store_true'); a = ap.parse_args()
R = open(a.rom, 'rb').read()
def fl(b, ad): return ad if b == 0 else b * 0x4000 + ad - 0x4000
def snake(s):
    s = re.sub(r'([a-z0-9])([A-Z])', r'\1_\2', s); s = re.sub(r'([A-Z]+)([A-Z][a-z])', r'\1_\2', s); return s.upper()
STOP = {'the', 'a', 'an', 'of', 'in', 'to', 'over', 'while', 'is', 'its', 'with', 'on', 'at', 'for', 'and'}
def words(s, n=5):                                                   # the screen name without its parentheses and filler words, 5 words at most
    s = re.sub(r'\([^)]*\)', ' ', s)
    w = [x for x in re.split(r'[^A-Za-z0-9]+', s) if x and x.lower() not in STOP]
    return '_'.join(w[:n]).upper()

modes = list(csv.DictReader(open(os.path.join(DD, 'mode_names_kitty.csv'), encoding='utf-8')))
MODE = {int(m['mode'], 16): m for m in modes}
screens = {(int(r['mode'], 16), int(r['state'], 16)): r for r in csv.DictReader(open(os.path.join(DD, 'screen_names_kitty.csv'), encoding='utf-8'))
           if re.fullmatch(r'[0-9A-Fa-f]{2}', r['state'])}             # the variants of one state (01-2, 05-W ...) are pictures, not states

# ---- const_names: modes, palettes
cn = [['mode', '%02X' % k, 'MODE_' + snake(m['name']), m['tag'], m['evidence']] for k, m in sorted(MODE.items())]
JPC = list(csv.DictReader(open(os.path.join(REPO, 'roms', 'jp_rev_a', 'disasm', 'const_names_jp.csv'), encoding='utf-8')))
tr = json.load(open(os.path.join(KD, 'trace', 'trace_kitty.json')))['code']
code = {fl(int(k[:2], 16), int(k[3:], 16)): n for k, n in tr.items()}
pal = collections.Counter()
NM = sorted((fl(int(r['bank'], 16), int(r['addr'], 16)), r['name']) for r in csv.DictReader(open(os.path.join(DD, 'sym_names_kitty.csv'), encoding='utf-8')))
NO = [o for o, _ in NM]; BYNAME = {n: o for o, n in NM}
LCD = {BYNAME['Lcd_SetupInline'], BYNAME['Lcd_SetupInlineNoIE']}
for o in code:
    if R[o] == 0xCD and (R[o + 1] | R[o + 2] << 8) in LCD:
        for i in (2, 3, 4): pal[R[o + 3 + i - 1]] += 1               # bytes 2-4 of the record: BGP, OBP0, OBP1
for r in JPC:
    if r['group'] == 'dmgpal' and int(r['value'], 16) in pal:
        cn.append(['dmgpal', r['value'], r['name'], r['tag'], r['desc'] + ' (the Japanese row; %d use(s) in the inline records of Lcd_SetupInline here)' % pal[int(r['value'], 16)]])

# ---- the routine and the screen of an instruction
CODEL = set(code)
def routine(o):
    i = bisect.bisect_right(NO, o) - 1
    while i >= 0 and (NM[i][0] not in CODEL or NM[i][1].startswith('.')): i -= 1
    return NM[i][1] if i >= 0 else '?'
entry = {}
for r in csv.DictReader(open(os.path.join(KD, 'trace', 'entry_modes_kitty.csv'), encoding='utf-8')):
    b, ad = r['entry'].split(':'); entry[fl(int(b, 16), int(ad, 16))] = r['first_screens'].split()[0] if r['first_screens'] else ''
def screen_of(o):
    n = routine(o); m = re.match(r'^Mode([0-9A-F]{2})_State([0-9A-F]{2})$', n)
    if m: return int(m.group(1), 16), int(m.group(2), 16), n
    e = entry.get(BYNAME.get(n))
    if e: mm, ss = e.split(':'); return int(mm, 16), int(ss, 16), n
    return None, None, n
def ctx(mo, st):
    if mo is None: return None
    if mo == 0x1E: return None                                       # the fade runs the set-up of the next screen
    if (mo, st) in screens: return screens[(mo, st)]['name']
    return MODE[mo]['name'] if mo in MODE else None

# ---- sound ids
CH = {0xD060: 'sfx1', 0xD068: 'music', 0xD070: 'sfx3', 0xD078: 'sfx4'}
sites = collections.defaultdict(list)
for o in sorted(code):
    if R[o] == 0x3E and o + 2 in code and R[o + 2] == 0xEA and (R[o + 3] | R[o + 4] << 8) in CH:
        b = o // 0x4000; sites[(CH[R[o + 3] | R[o + 4] << 8], R[o + 1])].append((o, '%02X:%04X' % (b, o if b == 0 else 0x4000 + o % 0x4000)))
HAND = os.path.join(DD, 'layers', 'sound_names_kitty_hand.csv')   # channel,id,name,tag,desc: a name read from the code by hand wins
hand = {(r['channel'], r['id'].upper()): r for r in csv.DictReader(open(HAND, encoding='utf-8'))} if os.path.exists(HAND) else {}
snd = []; used = set()
for (ch, v), ss in sorted(sites.items(), key=lambda kv: (['music', 'sfx1', 'sfx3', 'sfx4'].index(kv[0][0]), kv[0][1])):
    info = [screen_of(o) for o, _ in ss]
    where = []
    for mo, st, n in info:
        c = ctx(mo, st)
        w = ('%s (%02X:%02X %s)' % (n, mo, st, c)) if c else n
        if w not in where: where.append(w)
    pre = 'MUSIC' if ch == 'music' else ch.upper()
    h = hand.get((ch, '%02X' % v))
    if h: name, tag, desc = h['name'], h['tag'], h['desc']
    elif ch == 'music' and v == 0xFF: name, tag, desc = 'MUSIC_STOP', 'C', 'stops the song (as the Japanese MUSIC_STOP)'
    elif ch == 'music':
        cs = []; first = None                                       # the player's screens first: the factory modes ($0D) last
        for mo, st, n in sorted(info, key=lambda x: x[0] == 0x0D):
            c = ctx(mo, st)
            if c and c not in cs: cs.append(c)
            if c and first is None: first = (mo, st, n, c)
        if first:
            mo, st_, n, c = first
            base = 'MUSIC_' + (words(c, 4) if (mo, st_) in screens else snake(c))
            mt = re.search(r'Music(\d+)$', n)
            alt = base + ('_TUNE_%s' % mt.group(1) if mt else '_%02X_%02X' % (mo, st_))
            name, tag, desc = (base if base not in used and not mt else alt), 'C', 'started on: ' + '; '.join(cs)
        else: name, tag, desc = 'MUSIC_%02X' % v, 'C', 'started by ' + ', '.join(n for _, _, n in info)
    else:
        fam = {re.sub(r'(_State[0-9A-F]{2}|_Obj\w+|_FrameCallback\d*|_CursorUpdate|\d+)$', '', n) for _, _, n in info}
        if len(fam) == 1 and len(info) > 1:
            f = fam.pop(); mm = re.fullmatch(r'Mode([0-9A-F]{2})', f)
            lab = snake(MODE[int(mm.group(1), 16)]['name']) if mm and int(mm.group(1), 16) in MODE else snake(f).replace('__', '_')
            name, tag, desc = '%s_%s_%02X' % (pre, lab, v), 'I', 'every site in %s' % f
        else: name, tag, desc = '%s_%02X' % (pre, v), 'C', 'an effect id of channel %s' % ch
    k = name; i = 2
    while k in used: k = '%s_%d' % (name, i); i += 1
    used.add(k)
    snd.append([ch, '%02X' % v, k, tag, str(len(ss)), desc, ' '.join(s for _, s in ss[:8]) + (' ...' if len(ss) > 8 else '') + ' | ' + '; '.join(where[:6])])

# ---- states
st = []
for (mo, s), r in sorted(screens.items()):
    st.append(['state_%02x' % mo, '%02x' % s, 'STATE_%02X_%s' % (mo, words(r['name'])), r['tag'], 'screen: ' + r['name']])
cnt = collections.Counter(r[2] for r in st)
for r in st:
    if cnt[r[2]] > 1: r[2] += '_%s' % r[1].upper()

# ---- types
types = [['hMode', 'mode', 'the mode (Mode_Set); the main loop dispatches on it'], ['hMenuMode', 'mode', 'the mode a menu item names'],
         ['wReturnMode', 'mode', 'mode saved by Mode_SaveReturnD93D'], ['wReturnModeB', 'mode', 'mode saved by Mode_SaveReturnD8F2'],
         ['wKeysHeld', 'pad', 'bit 7 Down .. bit 0 A, 1 = held (Joy_Read)'], ['wKeysNew', 'pad', 'same layout: newly pressed'],
         ['wKeysNewRepeat', 'pad', 'same layout: new press or auto-repeat'], ['wKeysPrev', 'pad', 'same layout: the frame before'],
         ['wLcdcShadow', 'lcdc', 'copied to rLCDC by the VBlank handler'], ['hLcdcShadow', 'lcdc', 'LCDC latched by the VBlank handler'],
         ['wBgpShadow', 'dmgpal', 'copied to rBGP by the VBlank handler'], ['wObp0Shadow', 'dmgpal', 'copied to rOBP0'], ['wObp1Shadow', 'dmgpal', 'copied to rOBP1'],
         ['wPaletteTarget', 'dmgpal', 'the palettes a fade ends on (BGP, OBP0, OBP1)'],
         ['wSndSfx1', 'sfx1', 'request mailbox of effect channel 1'], ['wSndMusicReq', 'music', 'song mailbox'],
         ['wSndSfx3', 'sfx3', 'request mailbox of effect channel 3'], ['wSndSfx4', 'sfx4', 'request mailbox of effect channel 4']]
JPT = list(csv.DictReader(open(os.path.join(REPO, 'roms', 'jp_rev_a', 'disasm', 'const_types_jp.csv'), encoding='utf-8')))
types += [[r['variable'], r['group'], r['note']] for r in JPT if r['variable'].startswith('r')]   # the hardware registers, as in the Japanese table
RN = {r['name'] for r in csv.DictReader(open(os.path.join(DD, 'ram_names_kitty.csv'), encoding='utf-8'))}
miss = [t[0] for t in types if not t[0].startswith('r') and t[0] not in RN]
if miss: sys.exit('kitty_const_names: not in ram_names_kitty.csv: %s' % ', '.join(miss))

def text(head, rows):
    f = io.StringIO(); w = csv.writer(f, lineterminator='\n'); w.writerow(head); w.writerows(rows); return f.getvalue()
OUT = {os.path.join(DD, 'const_names_kitty.csv'): text(['group', 'value', 'name', 'tag', 'desc'], cn),
       os.path.join(DD, 'state_names_kitty.csv'): text(['group', 'value', 'name', 'tag', 'desc'], st),
       os.path.join(DD, 'sound_names_kitty.csv'): text(['channel', 'id', 'name', 'tag', 'sites', 'desc', 'evidence'], snd),
       os.path.join(DD, 'const_types_kitty.csv'): text(['variable', 'group', 'note'], types)}
bad = [p for p, t in OUT.items() if not os.path.exists(p) or open(p, encoding='utf-8').read() != t]
if a.check:
    if bad: sys.exit('kitty_const_names: stale %s' % ', '.join(os.path.relpath(p, REPO) for p in bad))
else:
    for p, t in OUT.items(): open(p, 'w', encoding='utf-8', newline='\n').write(t)
inc = os.path.join(DD, 'const_kitty.inc')
sys.path.insert(0, HERE); import const_names
def inc_now():
    import tempfile
    with tempfile.TemporaryDirectory() as d:
        fs = {}
        for k in ('const_names_kitty.csv', 'state_names_kitty.csv', 'sound_names_kitty.csv'):
            fs[k] = os.path.join(d, k); open(fs[k], 'w', encoding='utf-8').write(OUT[os.path.join(DD, k)])
        rr = const_names.load_names(fs['const_names_kitty.csv']) + const_names.load_states(fs['state_names_kitty.csv']) + const_names.load_sounds(fs['sound_names_kitty.csv'])
    const_names.check_unique(rr)
    return const_names.inc_text(rr).replace('Pocket Camera (Japan) Rev A: constants. Generated by tools/const_names.py from roms/jp_rev_a/disasm/const_names_jp.csv',
        'Pocket Camera Hello Kitty (Japan): constants. Generated by tools/kitty_const_names.py (with tools/const_names.py) from roms/hello_kitty/disasm/const_names_kitty.csv, state_names_kitty.csv, sound_names_kitty.csv').replace(
        'INCLUDE after hardware.inc and ram_jp.inc', 'INCLUDE after hardware.inc and ram_kitty.inc')
T = inc_now()
if a.check:
    if not os.path.exists(inc) or open(inc, encoding='utf-8').read() != T: sys.exit('kitty_const_names: stale %s' % os.path.relpath(inc, REPO))
else: open(inc, 'w', encoding='utf-8', newline='\n').write(T)
c = collections.Counter(r[0] for r in cn)
print('kitty_const_names: %d modes, %d palettes, %d named states, %d sound ids (%s), %d typed operands%s' % (c['mode'], c['dmgpal'], len(st), len(snd),
      ', '.join('%s %d' % kv for kv in sorted(collections.Counter(r[0] for r in snd).items())), len(types), ' (fresh)' if a.check else ''))
