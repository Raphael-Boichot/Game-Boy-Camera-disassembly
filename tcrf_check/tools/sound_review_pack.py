#!/usr/bin/env python3
"""Review page for the sound ids that no organic run requested (README 16.24, `really_unused_sounds.csv`): one card per id with its BGB clip, the pitch-over-time picture and note list read from
the APU register log, the few lines of code that concern it, the owner's earlier by-ear remark (2026-10-13, from the notes of `disasm/sym_names_jp.csv`) and, for the ids that share their
sound data with a played id, whether the two register logs are identical.  Nothing here is heard by this script; the owner listens.
usage: sound_review_pack.py --rec DIR [--rec DIR ...] --listing DIR --out DIR [--long DIR]
  --rec DIR      a folder of `sound_clips.py ... --apu` runs, one sub-folder per run (SUB/<channel>.json + SUB/<channel>_<ID>.mp3); the first run that holds an id gives its clip and notes
  --long DIR     a run of one id with a much longer window (only used to say whether the sound ends by itself)
  --listing DIR  the generated source with RAM names and constants (`tools/sym_fix.py --const` output), for the code lines
Output: OUT/review.html (one file, clips embedded), OUT/review.json (the data of the cards), OUT/clips/<channel>_<ID>.mp3."""
import sys, os, re, json, csv, glob, base64, html, shutil, math
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import sound_describe as D
REPO = os.path.dirname(os.path.dirname(HERE))

args = sys.argv[1:]
def opts(name):
    out = []
    while name in args:
        i = args.index(name); out.append(args[i + 1]); del args[i:i + 2]
    return out
RECS = opts('--rec'); LONG = (opts('--long') or [None])[0]; LISTING = opts('--listing')[0]; OUT = opts('--out')[0]
os.makedirs(OUT + '/clips', exist_ok=True)

# ---- the 15 ids (really_unused_sounds.csv) and their groups -------------------------------------------------------------------------------------------------------------------------------
UNUSED = [r for r in csv.DictReader(open(REPO + '/tcrf_check/assets/unidentified/really_unused_sounds.csv', encoding='utf-8'))]
GROUPS = [
    ('nothing', 'Nothing in the code asks for it', 'No `ld a, id` in front of a request call, no entry in any of the six id lists, and no other id with the same sound data. The clip is all there is.'),
    ('caller', 'A caller exists, normal use never got there', 'The id is requested by code that the replays did not reach (a printer answer, a link exchange, a branch). The code is shown.'),
    ('joypad', 'Reachable with the joypad, never requested by the replay corpus', 'Found later by a targeted run of the D.J. performance screen.'),
    ('alias', 'Same sound as an id that is played', 'The id table points each of these at the handler of a played id. Where the register log is identical to that sibling\'s, the sound is the same and the id takes the sibling\'s name unless you say otherwise.'),
]
META = {
    ('sfx1', '24'): dict(group='nothing', sib=None),
    ('sfx3', '04'): dict(group='nothing', sib=None),
    ('sfx3', '07'): dict(group='nothing', sib=None),
    ('music', '48'): dict(group='nothing', sib=None),
    ('sfx1', '2B'): dict(group='alias', sib=('sfx1', '23')),
    ('sfx1', '3D'): dict(group='alias', sib=('sfx1', '3C')),
    ('sfx1', '3E'): dict(group='alias', sib=('sfx1', '3C')),
    ('sfx3', '0A'): dict(group='alias', sib=('sfx3', '05')),
    ('music', '08'): dict(group='alias', sib=('music', '0D'), sib2=('music', '1A')),
    ('music', '47'): dict(group='alias', sib=('music', '1C')),
    ('music', '27'): dict(group='caller', sib=None),
    ('music', '44'): dict(group='caller', sib=('music', '11')),
    ('sfx4', '05'): dict(group='caller', sib=None),
    ('sfx4', '11'): dict(group='caller', sib=None),
    ('sfx1', '2F'): dict(group='joypad', sib=None),
}
ORDER = [('sfx1', '24'), ('sfx3', '04'), ('sfx3', '07'), ('music', '48'), ('sfx1', '2B'), ('sfx1', '3D'), ('sfx1', '3E'), ('sfx3', '0A'), ('music', '08'), ('music', '47'),
         ('music', '27'), ('music', '44'), ('sfx4', '05'), ('sfx4', '11'), ('sfx1', '2F')]
assert sorted(ORDER) == sorted((r['channel'], r['id']) for r in UNUSED), 'the page and really_unused_sounds.csv list different ids'

# ---- code lines from the listing ----------------------------------------------------------------------------------------------------------------------------------------------------------
LST = {}
def listing(bank):
    if bank not in LST: LST[bank] = open('%s/bank_%03x.asm' % (LISTING, bank), encoding='utf-8').read().split('\n')
    return LST[bank]
def owner_of(bank, i):
    L = listing(bank)
    for j in range(i, -1, -1):
        m = re.match(r'^([A-Za-z_][\w.]*)::?', L[j])
        if m and not re.match(r'(jr|jp|call)_[0-9a-f]{3}_[0-9a-f]{4}$', m.group(1)): return m.group(1)
    return '?'
def code(bank, addr, before, after, title=None):
    """lines of the listing around the instruction at `addr`: [(addr or None, text)], with the owner label as the title"""
    L = listing(bank); key = '; $%04x:' % addr
    idx = [i for i, l in enumerate(L) if key in l]
    assert len(idx) == 1, (bank, addr, idx)
    i = idx[0]; items = []
    j = i - 1; n = 0
    while j >= 0 and n < before:
        if L[j].strip(): items.insert(0, j); n += 1 if not re.match(r'^[A-Za-z_][\w.]*::?', L[j]) else 0
        j -= 1
    items.append(i); j = i + 1; n = 0
    while j < len(L) and n < after:
        if L[j].strip(): items.append(j); n += 1
        j += 1
    rows = []
    for k in items:
        l = L[k]; m = re.match(r'^(\s+)(.*?)\s*; \$([0-9a-f]{4}):', l)
        if m: rows.append(('$%s' % m.group(3), m.group(2)))
        elif l.strip() and not l.strip().startswith(';'): rows.append((None, l.strip()))
    while rows and rows[-1][0] is None: rows.pop()
    return dict(title=title or ('%s  (%02X:%04X)' % (owner_of(bank, i), bank, addr)), rows=rows)

SNIP = {
    ('sfx1', '24'): [lambda: code(5, 0x7B0C, 0, 2, 'The one computed channel-1 request of the ROM (BALL, 05:7B0C): id = $20 + step index, index 0-2, so $20-$22')],
    ('sfx1', '2B'): [lambda: code(5, 0x7D50, 2, 0, 'Ball_AddPoint asks for id 23, the sibling of 2B (05:7D50)')],
    ('sfx1', '3D'): [lambda: code(7, 0x5623, 2, 0, 'Mode07_State02_Play asks for 3C, the sibling of 3D and 3E (07:5623)'),
                     lambda: code(0x1F, 0x4554, 0, 4, 'The handler that 3C, 3D and 3E share (1F:4554)')],
    ('sfx3', '0A'): [lambda: code(6, SHUTTER_CALL, 4, 2, 'The shutter-sound choice (list 06:7845 = sfx1 28, sfx3 06, sfx3 05, sfx4 03); 05 is the sibling of 0A')],
    ('music', '08'): [lambda: code(6, 0x40AB, 2, 0, 'Mode15_State01_TimerInit asks for 0D, a sibling of 08 and 1A (06:40AB)')],
    ('music', '27'): [lambda: code(0, 0x3374, 0, 10, 'The print step: the song starts after the printer routine answered (not $FF, not $F0) (00:3374)')],
    ('music', '44'): [lambda: code(7, 0x455C, 0, 3, 'Mode0E_State06_ExchangeSetup, the image-exchange stand-by screen (07:455C); State0A asks for it too (07:46B0)')],
    ('sfx4', '05'): [lambda: code(4, 0x5153, 0, 15, 'EraseAnim_Run: variant 0 asks for sfx1 3B, any other variant asks for sfx4 05 (04:5153)')],
    ('sfx4', '11'): [lambda: code(9, 0x6BC8, 0, 14, 'Run_FlagHeight, RUN! RUN! RUN! (09:6BC8)')],
    ('sfx1', '2F'): [lambda: code(5, DJ_CALL, 4, 2, 'The D.J. performance screen posts [05:554D + 2 x level] (SE 1-9 = ids 2C-34); level 4 = 2F')],
}
SNIP[('sfx1', '3E')] = SNIP[('sfx1', '3D')]
# the two calls whose address is found by name
def find_call(bank, label_regex, nth=0):
    L = listing(bank); out = []
    for i, l in enumerate(L):
        if re.search(label_regex, l):
            m = re.search(r'; \$([0-9a-f]{4}):', l); out.append(int(m.group(1), 16))
    return out
SHUTTER_CALL = None; DJ_CALL = None
for a in find_call(6, r'call Snd_PlayFromList'):
    SHUTTER_CALL = a if SHUTTER_CALL is None else SHUTTER_CALL
for a in find_call(5, r'call Snd_PlayFromList'):
    DJ_CALL = a if DJ_CALL is None else DJ_CALL

TEXT = {
    ('sfx1', '24'): ['Callers of the ids around it: 25 SpaceFever_Wave0_Init (07:5A2F), 26 SpaceFever_BossHit (07:675C), 27 SpaceFever_Wave0_Play (07:5ABF). 24: none; the ROM has 334 channel-1 request calls and none loads $24.',
                     'Handler: id table 1F:41FA -> 1F:43E4 (Sfx1_Init_24_SpaceFeverII), step handler 1F:43EC.'],
    ('sfx3', '04'): ['Handler 1F:50AB. Channel-3 ids that are requested: 01 (Shoot item), 02 (menus), 03 (SpaceFever_BossHit), 08 and 09 (delete dialog); 05 and 06 only through lists (shutter sound options). 04: no caller, no list.'],
    ('sfx3', '07'): ['Handler 1F:4F72. Channel-3 ids that are requested: 01, 02, 03, 08, 09; 05 and 06 through lists. 07: no caller, no list.'],
    ('music', '48'): ['Handler 1F:7F1F (Song48_ErrorIncomplete_Hdr, named from your answer). Songs that the id lists hold: 03:61FD (slide-show), 05:781B (BALL: 2E, 2D), 09:733E (result: 28, 29, 30, 2A), 03:7615 (hot-spot editor). 48: none; no `ld a, $48` before `call Snd_Music`.'],
    ('sfx4', '05'): ['Space Fever II\'s player death, SpaceFever_PlayerDie / PlayerDieB, asks for channel-4 id 08 (07:6655, 07:6698); 05 is asked for by EraseAnim_Run only.'],
    ('sfx4', '11'): ['Requested at 09:6BD7 in every case except when A minus wRunFlagLevel is above 2 (the flag height is then set to that difference); handler 1F:4EBC.'],
    ('sfx1', '2B'): ['Id table 1F:41FA: 23 -> 1F:46C3, 2B -> 1F:46C3 (Sfx1_Init_23_2B_BallPoint). No call and no list holds 2B.'],
    ('sfx1', '3E'): ['Same handler as 3D (1F:4554). No call holds 3D or 3E; 3C is requested by Mode07_State02_Play.',
                     'The handler also stops the song (Snd_StopSong) and posts channel-4 id 02.'],
    ('music', '08'): ['Song table 1F:57C6: 08, 0D and 1A all point at 1F:74C2 (Song08_TimerPrintOpt_Hdr). 0D is requested by Mode15_State01_TimerInit (06:40AB), Mode15_State05_IntervalInit (06:41EE) and Mode1E_State00_Init (08:48F0); 08 and 1A have no caller (1A is in the slide-show list).'],
    ('music', '47'): ['Song table 1F:57C6: 1C and 47 both point at 1F:7AB1 (Song1C_Hdr). 1C is entry #13 of the slide-show music list (03:61FD); 47 is in no list and no call holds it.'],
    ('music', '44'): ['Song table 1F:57C6: 11 and 44 both point at 1F:6049 (Song11_Jingle_Hdr). 11 is requested by the credits (09:4D7C), the factory test (0A:6AE6) and the first-boot screen (0A:6BB5).'],
    ('sfx1', '3D'): ['Id table 1F:41FA: 3C, 3D and 3E all point at 1F:4554. 3C is requested by Mode07_State02_Play (07:5623). No call holds 3D or 3E.'],
}

# ---- recordings --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
REC = {}
for d in RECS:
    for sub in sorted(glob.glob(d + '/*/')):
        for jf in sorted(glob.glob(sub + '*.json')):
            if os.path.basename(jf) not in ('sfx1.json', 'sfx3.json', 'sfx4.json', 'music.json'): continue
            j = json.load(open(jf))
            for q in j['requests']:
                if q['id'] == 'FF' or not q.get('apu'): continue
                key = (j['channel'], q['id'])
                if key not in REC: REC[key] = dict(q=q, mp3=os.path.join(sub, '%s_%s.mp3' % (j['channel'], q['id'])))
LONGQ = None
if LONG:
    for jf in glob.glob(LONG + '/*.json'):
        if os.path.basename(jf) not in ('sfx1.json', 'sfx3.json', 'sfx4.json', 'music.json'): continue
        j = json.load(open(jf)); LONGQ = (j['channel'], j['requests'][0]['id'], j['requests'][0])

def compare(a, b):
    """True when the two requests give the same audible notes: same channel, pitch, pitch steps, pulse duty, volume and envelope, wave table or noise setting, in the same order, each start and
    length within 12 ms of its counterpart (times counted from the first audible note of each; the clock log rounds to about 1 ms).  Silent triggers (volume 0, how the engine mutes a
    channel) are not notes, so the pitch that a previous sound left in the registers does not count.  The last note of each channel and the last second of a long window are left out,
    because the next request cuts them."""
    na, nb = D.notes(REC[a]['q']['apu']), D.notes(REC[b]['q']['apu'])
    ta0, tb0 = na[0]['t0'], nb[0]['t0']
    def sig(ns, base): return [(n['ch'], round(n['f0'], 1), tuple(round(f, 1) for _, f in n['steps']), n.get('duty'), (n.get('wave'), n.get('vol'), n.get('vol3'), n.get('pace'), n.get('up'), n.get('poly'), n.get('sweep')),
                                n['t0'] - base, n['t1'] - n['t0']) for n in ns]
    sa, sb = sig(na, ta0), sig(nb, tb0)
    T = min(sa[-1][5], sb[-1][5]); T -= 1.0 if T > 5 else 0.0
    bad = 0; tot = 0
    for ch in (1, 2, 3, 4):                                  # channel by channel: two channels that start in the same tick can be listed in either order
        ca, cb = [x for x in sa if x[0] == ch and x[5] <= T + 0.012], [x for x in sb if x[0] == ch and x[5] <= T + 0.012]
        last = max([x[5] for x in ca] + [0])
        bad += abs(len(ca) - len(cb)) + sum(1 for x, y in zip(ca, cb) if x[:5] != y[:5] or abs(x[5] - y[5]) > 0.012 or (x[5] < last and abs(x[6] - y[6]) > 0.012)); tot += max(len(ca), len(cb))
    return bad == 0, tot, bad

# ---- the owner's earlier remarks ---------------------------------------------------------------------------------------------------------------------------------------------------------
REM = {}
for r in csv.DictReader(open(REPO + '/disasm/sym_names_jp.csv', encoding='utf-8')):
    for m in re.finditer(r'Owner \(review page, 2026-10-13, by ear\): ((?:music|sfx[134]) [0-9A-F]{2}): (.*?)(?:\.(?:\s|$)|$)', r['note']):
        REM.setdefault(m.group(1), m.group(2).split(';')[0].strip())
    for m in re.finditer(r'owner for ([0-9A-F]{2}): (.*?)(?:\.(?:\s|$)|;|$)', r['note']):
        REM.setdefault('sfx1 ' + m.group(1), m.group(2).split(';')[0].strip())

# ---- the cards ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
HANDLER = {(r['channel'], r['id'].upper()): r['handler'] for r in UNUSED}
cards = []
for key in ORDER:
    ch, i = key; meta = META[key]; assert key in REC, 'no recording of %s %s' % key
    q = REC[key]['q']; ns = D.notes(q['apu']); clip = q.get('clip_s', 0)
    shutil.copy(REC[key]['mp3'], '%s/clips/%s_%s.mp3' % (OUT, ch, i))
    desc = D.describe(ns, 8)
    cmp_lines = []
    for sk in ('sib', 'sib2'):
        s = meta.get(sk)
        if s and s in REC:
            same, n, bad = compare(key, s)
            cmp_lines.append('Register log against %s %s: %s' % (s[0], s[1], ('identical (%d note%s compared)' % (n, '' if n == 1 else 's')) if same else 'different (%d of %d notes differ)' % (bad, n)))
    loop = None
    if LONGQ and (LONGQ[0], LONGQ[1]) == key:
        lns = D.notes(LONGQ[2]['apu']); last = max(n['t1'] for n in lns)
        loop = 'Recorded for %.0f s: still retriggering at %.1f s (%d notes), it does not end by itself.' % (LONGQ[2]['apu'][-1][0], last, len(lns))
    snips = []
    for f in SNIP.get(key, []):
        snips.append(f())
    notes_js = []
    for n in ns:
        if n['ch'] == 4: v = math.log2(max(n['f0'], 1)); st = [[round(t, 3), round(math.log2(max(f, 1)), 2)] for t, f in n['steps']]
        else: v = D.midi(n['f0']); st = [[round(t, 3), round(D.midi(f), 2)] for t, f in n['steps']]
        notes_js.append([n['ch'], round(n['t0'], 3), round(n['t1'], 3), round(v, 2), st])
    cards.append(dict(key='%s_%s' % (ch, i), channel=ch, id=i, handler=HANDLER[(ch, i)], group=meta['group'], clip_s=round(clip, 2), cut=bool(q.get('cut')),
                      earlier=REM.get('%s %s' % (ch, i)), describe=desc, compare=cmp_lines, loop=loop, snippets=snips, text=TEXT.get(key, []), notes=notes_js))
json.dump(cards, open(OUT + '/review.json', 'w'), indent=1)

# ---- HTML --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CHNAME = {'sfx1': 'Effect, channel 1', 'sfx3': 'Effect, channel 3', 'sfx4': 'Effect, channel 4', 'music': 'Song'}
def esc(s): return html.escape(s, quote=True)
def card_html(c):
    mp3 = base64.b64encode(open('%s/clips/%s.mp3' % (OUT, c['key']), 'rb').read()).decode()
    h = ['<article class="card" id="c-%s" data-key="%s">' % (c['key'], c['key']),
         '<header><h3><span class="ch">%s</span> <span class="id">%s</span></h3><span class="kind">%s &middot; handler 1F:%s</span></header>' % (c['channel'], c['id'], esc(CHNAME[c['channel']]), c['handler'].split(':')[1])]
    h.append('<audio controls preload="metadata" src="data:audio/mpeg;base64,%s"></audio>' % mp3)
    h.append('<canvas class="roll" aria-label="pitch over time of %s %s"></canvas>' % (c['channel'], c['id']))
    h.append('<p class="clipnote">%.1f s%s</p>' % (c['clip_s'], ' &middot; cut at the end of the recording window' if c['cut'] else ''))
    if c['earlier']:
        h.append('<p class="earlier"><b>Your 2026-10-13 remark:</b> &ldquo;%s&rdquo;</p>' % esc(c['earlier']))
    else:
        h.append('<p class="earlier none">No remark from you on 2026-10-13.</p>')
    for t in c['text']: h.append('<p class="fact">%s</p>' % esc(t))
    for t in c['compare']: h.append('<p class="fact cmp">%s</p>' % esc(t))
    if c['loop']: h.append('<p class="fact cmp">%s</p>' % esc(c['loop']))
    for s in c['snippets']:
        h.append('<figure class="code"><figcaption>%s</figcaption><pre>%s</pre></figure>' % (esc(s['title']), '\n'.join(
            ('<span class="a">%s</span>  %s' % (esc(a), esc(t))) if a else esc(t) for a, t in s['rows'])))
    h.append('<details><summary>Register log, read as notes</summary><pre class="desc">%s</pre></details>' % esc('\n'.join(c['describe'])))
    h.append('<label class="name">Name (role + context)<input type="text" data-name="%s %s" placeholder="e.g. space fever boss death"></label>' % (c['channel'], c['id']))
    h.append('</article>')
    return '\n'.join(h)

body = []
for gk, gt, gd in GROUPS:
    cs = [c for c in cards if c['group'] == gk]
    if not cs: continue
    body.append('<section><h2>%s <small>%d</small></h2><p class="gd">%s</p>%s</section>' % (esc(gt), len(cs), esc(gd), '\n'.join(card_html(c) for c in cs)))
PAGE = open(HERE + '/sound_review_page.html', encoding='utf-8').read()
PAGE = PAGE.replace('@@BODY@@', '\n'.join(body)).replace('@@DATA@@', json.dumps({c['key']: dict(notes=c['notes'], clip=c['clip_s']) for c in cards}, separators=(',', ':')))
open(OUT + '/review.html', 'w', encoding='utf-8').write(PAGE)
print('cards', len(cards), 'html %.0f kB' % (len(PAGE) / 1024))
