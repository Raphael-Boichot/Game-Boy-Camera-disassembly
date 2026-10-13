#!/usr/bin/env python3
"""Contact sheets of the asset rows still open in disasm/sym_unconclusive_jp.csv (groups: visually identified range,
far-pointer asset, content-classified span, unknown data), rendered as 2bpp tiles straight from the ROM (not from the core's renderer),
with the TCRF checklist ids that overlap each span.  usage: unidentified_sheets.py [ROM] [OUTDIR]"""
import sys, os, csv, re, collections
from PIL import Image, ImageDraw, ImageFont
REPO = os.environ.get('GBCAM_REPO', os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
ROM = open(sys.argv[1] if len(sys.argv) > 1 else os.environ.get('GBCAM_ROM', '/home/claude/tc/pocketcamera_jp.gb'), 'rb').read()
OUT = sys.argv[2] if len(sys.argv) > 2 else REPO + '/tcrf_check/assets/unidentified'
os.makedirs(OUT, exist_ok=True)
GROUPS = ['visually identified range', 'far-pointer asset, extent unknown', 'content-classified span', 'unknown data (no reader found)']
PAL = [255, 170, 85, 0]
def off(b, a): return a if b == 0 else b * 0x4000 + (a - 0x4000)
tc = []
for r in csv.DictReader(open(REPO + '/tcrf_check/TCRF_CHECKLIST.csv', encoding='utf-8')):
    for m in re.finditer(r'([0-9A-F]{2}):([0-9A-F]{4})-([0-9A-F]{4})', r['rom']):
        tc.append((r['id'], r['item'], int(m.group(1), 16), int(m.group(2), 16), int(m.group(3), 16)))
rows = []
for r in csv.DictReader(open(REPO + '/disasm/sym_unconclusive_jp.csv', encoding='utf-8')):
    if r['group'] not in GROUPS: continue
    b = int(r['bank'], 16); a = int(r['addr'], 16); n = int(r['size'] or 0)
    if n <= 0: continue
    r['b'], r['a'], r['n'] = b, a, n
    r['tcrf'] = sorted({i for i, it, bb, s, e in tc if bb == b and s < a + n and e >= a})
    rows.append(r)
rows.sort(key=lambda r: (r['b'], r['a']))
def kind(r):
    return r['name'].split('_')[0]
def classify_data(d):
    if not any(d): return 'all 00'
    if all(x == 0xFF for x in d): return 'all FF'
    if len(set(d)) <= 2: return 'two values'
    return 'mixed'
with open(OUT + '/open_assets.csv', 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f, lineterminator='\n')
    w.writerow(['bank', 'addr', 'bytes', 'group', 'name', 'content', 'tcrf_ids', 'best_guess'])
    for r in rows:
        d = ROM[off(r['b'], r['a']):off(r['b'], r['a']) + r['n']]
        w.writerow([r['bank'], r['addr'], r['n'], r['group'], r['name'], classify_data(d), ' '.join(r['tcrf']), r['best_guess']])
FONT = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf', 12)
FONTB = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSansMono-Bold.ttf', 12) if os.path.exists('/usr/share/fonts/truetype/dejavu/DejaVuSansMono-Bold.ttf') else FONT
COLS, SC, CELLW, GAP = 16, 2, 16 * 8 * 2, 14
def tiles(d, cols=COLS):
    n = len(d) // 16; rows_ = (n + cols - 1) // cols
    im = Image.new('L', (cols * 8, max(rows_, 1) * 8), 255); px = im.load()
    for t in range(n):
        for y in range(8):
            b0 = d[t * 16 + y * 2]; b1 = d[t * 16 + y * 2 + 1]
            for x in range(8):
                px[(t % cols) * 8 + x, (t // cols) * 8 + y] = PAL[((b1 >> (7 - x)) & 1) << 1 | ((b0 >> (7 - x)) & 1)]
    return im.resize((im.width * SC, im.height * SC), Image.NEAREST).convert('RGB')
def wrap(s, n):
    out = []
    while s:
        out.append(s[:n]); s = s[n:]
    return out or ['']
items = [r for r in rows if kind(r) == 'Gfx' or (kind(r) == 'Banner')]
cells = []
for r in items:
    d = ROM[off(r['b'], r['a']):off(r['b'], r['a']) + r['n']]
    extra = len(d) % 16
    img = tiles(d[:len(d) - extra])
    cap = ['%s:%s  %d B%s' % (r['bank'], r['addr'], r['n'], ('  (+%d B tail)' % extra) if extra else '')] + wrap(r['name'][r['name'].index('_', 4) + 1 if r['name'].count('_') > 1 else 0:], 30)[:2]
    cap.append('TCRF ' + ' '.join(r['tcrf']) if r['tcrf'] else '-')
    cells.append((cap, img, r))
PAGE_H = 1550; COLN = 4; CW = CELLW + GAP * 2
pages = []; cur = [0] * COLN; page = [[] for _ in range(COLN)]
def new_page():
    global cur, page
    pages.append(page); cur = [0] * COLN; page = [[] for _ in range(COLN)]
pages_first = True
for cap, img, r in cells:
    h = 16 * len(cap) + img.height + 18
    c = min(range(COLN), key=lambda k: cur[k])
    if cur[c] + h > PAGE_H and any(cur):
        new_page(); c = 0
    page[c].append((cap, img, r)); cur[c] += h
pages.append(page)
# the first appended 'page' may be an empty initial; drop empties
pages = [p for p in pages if any(p)]
for pi, pg in enumerate(pages):
    H = max(sum(16 * len(cap) + img.height + 18 for cap, img, r in col) for col in pg) + 40
    sheet = Image.new('RGB', (CW * COLN + GAP, H), 'white'); dr = ImageDraw.Draw(sheet)
    dr.text((GAP, 8), 'Still-open Gfx spans, page %d / %d (2bpp, 16 tiles per row, x2)' % (pi + 1, len(pages)), fill=(0, 0, 0), font=FONTB)
    for ci, col in enumerate(pg):
        y = 30
        for cap, img, r in col:
            x = GAP + ci * CW
            for li, line in enumerate(cap):
                dr.text((x, y + 16 * li), line, fill=(0, 0, 0) if li == 0 else (90, 90, 90), font=FONTB if li == 0 else FONT)
            y += 16 * len(cap)
            sheet.paste(img, (x, y)); dr.rectangle([x - 1, y - 1, x + img.width, y + img.height], outline=(200, 160, 120))
            y += img.height + 18
    sheet.save(OUT + '/open_gfx_%02d.png' % (pi + 1))
print(len(rows), 'rows,', len(items), 'drawn,', len(pages), 'pages')
c = collections.Counter(classify_data(ROM[off(r['b'], r['a']):off(r['b'], r['a']) + r['n']]) for r in rows if kind(r) == 'Data')
print('Data rows by content:', dict(c))
