#!/usr/bin/env python3
"""ONE contact sheet (open_assets.png) of the asset rows still open in roms/jp_rev_a/disasm/sym_unconclusive_jp.csv (groups: visually identified range,
far-pointer asset, content-classified span, unknown data), rendered as 2bpp tiles straight from the ROM (not from the core's renderer),
with the TCRF checklist ids that overlap each span.  Sections: graphic spans (2bpp), tile maps (byte value as grey), small unread data blocks (2bpp, hex under 16 B). usage: unidentified_sheets.py [ROM] [OUTDIR]"""
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
for r in csv.DictReader(open(REPO + '/roms/jp_rev_a/disasm/sym_unconclusive_jp.csv', encoding='utf-8')):
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
FONTS = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf', 10)
FONTB = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSansMono-Bold.ttf', 12)
SC, GAP, COLN = 2, 14, 5
CELLW = 16 * 8 * SC; CW = CELLW + GAP * 2; WIDTH = CW * COLN + GAP
def tiles(d, cols=16):
    n = len(d) // 16; rows_ = (n + cols - 1) // cols
    im = Image.new('L', (min(n, cols) * 8, max(rows_, 1) * 8), 255); px = im.load()
    for t in range(n):
        for y in range(8):
            b0 = d[t * 16 + y * 2]; b1 = d[t * 16 + y * 2 + 1]
            for x in range(8):
                px[(t % cols) * 8 + x, (t // cols) * 8 + y] = PAL[((b1 >> (7 - x)) & 1) << 1 | ((b0 >> (7 - x)) & 1)]
    return im.resize((im.width * SC, im.height * SC), Image.NEAREST).convert('RGB')
def greymap(d, cols=32):
    rows_ = (len(d) + cols - 1) // cols
    im = Image.new('L', (cols, rows_), 255); im.putdata(list(d) + [255] * (cols * rows_ - len(d)))
    return im.resize((cols * 8, rows_ * 8), Image.NEAREST).convert('RGB')
def wrap(s, n):
    out = []
    while s:
        out.append(s[:n]); s = s[n:]
    return out or ['']
def short(r):
    nm = r['name']; return nm[nm.index('_', 4) + 1:] if nm.count('_') > 1 and nm.split('_')[0] in ('Gfx', 'Map', 'Src', 'Banner') else nm
big = []
for r in rows:
    k = kind(r)
    if k in ('Gfx', 'Banner', 'Map'):
        d = ROM[off(r['b'], r['a']):off(r['b'], r['a']) + r['n']]
        if k == 'Map': img = greymap(d)
        else:
            extra = len(d) % 16; img = tiles(d[:len(d) - extra])
        cap = ['%s:%s  %d B%s' % (r['bank'], r['addr'], r['n'], '  (tile map)' if k == 'Map' else '')] + wrap(short(r), 30)[:2] + [('TCRF ' + ' '.join(r['tcrf'])) if r['tcrf'] else '-']
        big.append((cap, img))
ncol = [0] * COLN; cols_ = [[] for _ in range(COLN)]
for cap, img in big:
    h = 16 * len(cap) + img.height + 18; c = min(range(COLN), key=lambda k: ncol[k]); cols_[c].append((cap, img)); ncol[c] += h
top = 54; H1 = top + max(ncol)
small = [r for r in rows if kind(r) == 'Data']
# small unread data blocks: flow layout
cells = []
for r in small:
    d = ROM[off(r['b'], r['a']):off(r['b'], r['a']) + r['n']]
    cap = '%s:%s %dB' % (r['bank'], r['addr'], r['n'])
    img = tiles(d[:len(d) // 16 * 16], cols=4) if len(d) >= 16 else None
    hexs = d.hex() if len(d) < 16 else ''
    cells.append((cap, img, hexs))
x = GAP; y = 0; rowh = 0; place = []
for cap, img, hexs in cells:
    w = max(img.width if img else 0, len(cap) * 6 + 6, len(hexs) * 6 + 6); h = 12 + (img.height if img else 12) + 4
    if x + w > WIDTH - GAP: x = GAP; y += rowh + 6; rowh = 0
    place.append((x, y, cap, img, hexs, w)); x += w + 10; rowh = max(rowh, h)
H2 = 50 + y + rowh + 10
sheet = Image.new('RGB', (WIDTH, H1 + H2), 'white'); dr = ImageDraw.Draw(sheet)
dr.text((GAP, 8), 'Unidentified assets still open in the Pocket Camera (Japan) Rev A sym: %d graphic spans / tile maps (2bpp, 16 tiles per row, x2), then %d small unread data blocks' % (len(big), len(small)), fill=(0, 0, 0), font=FONTB)
dr.text((GAP, 28), 'caption = bank:address, bytes, label (without Gfx_BB_AAAA_), TCRF checklist ids overlapping the span; the ids only say which TCRF section covers the range', fill=(90, 90, 90), font=FONT)
for ci, col in enumerate(cols_):
    yy = top
    for cap, img in col:
        xx = GAP + ci * CW
        for li, line in enumerate(cap): dr.text((xx, yy + 16 * li), line, fill=(0, 0, 0) if li == 0 else (90, 90, 90), font=FONTB if li == 0 else FONT)
        yy += 16 * len(cap); sheet.paste(img, (xx, yy)); dr.rectangle([xx - 1, yy - 1, xx + img.width, yy + img.height], outline=(200, 160, 120)); yy += img.height + 18
dr.line([(0, H1 + 6), (WIDTH, H1 + 6)], fill=(180, 180, 180))
dr.text((GAP, H1 + 12), 'Small unread data blocks (%d, 3 kB in all): padding fragments or tile scraps between assets (2bpp, 4 tiles per row, x2; under 16 B as hex)' % len(small), fill=(0, 0, 0), font=FONTB)
dr.text((GAP, H1 + 28), 'Not drawn: %d stamp-sheet gaps of 6-23 B (in open_assets.csv)' % sum(1 for r in rows if kind(r) == 'Sheet'), fill=(90, 90, 90), font=FONT)
for x, y, cap, img, hexs, w in place:
    yy = H1 + 50 + y
    dr.text((x, yy), cap, fill=(60, 60, 60), font=FONTS)
    if img: sheet.paste(img, (x, yy + 12)); dr.rectangle([x - 1, yy + 11, x + img.width, yy + 12 + img.height], outline=(220, 200, 180))
    else: dr.text((x, yy + 12), hexs, fill=(120, 120, 120), font=FONTS)
sheet.save(OUT + '/open_assets.png')
print(len(rows), 'rows;', len(big), 'big cells;', len(small), 'small blocks;', sheet.size)
