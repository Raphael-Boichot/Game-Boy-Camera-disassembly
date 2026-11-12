"""One style for the unused-asset sheets of every ROM (owner 2026-11-12: compact, the same for all): a title, a subtitle, then sections
(a coloured rule and a heading), each a flow of items (a caption, an address line, the picture at x2). The pictures use the project's
four greys (tools/gb_palette.py: BGB screenshots are converted). Used by tools/proto_unused_sheet.py and tools/kitty_unused_sheet.py.

  tile(data, inv) / tiles(data, w, inv) / tiles16(data, w): 2bpp tiles (8x8, or 8x16 sprite pairs) as a picture
  tmap(rom, map_offset, cols, src, show): a BG map drawn with src(id) -> flat offset of the tile (None = blank)
  side(*pictures): pictures side by side;  shot(path): a BGB screenshot in the project's greys
  sheet(title, subtitle, sections, out, check): sections = [(heading, (r, g, b), [(caption, address, picture), ...]), ...]
"""
import io, os, sys
from PIL import Image, ImageDraw, ImageFont
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__))); import gb_palette
PAL = (255, 170, 85, 0)
TCRF_COL, OWN_COL, USED_COL = (150, 60, 0), (0, 110, 140), (90, 90, 90)
def tile(data, inv=False):
    im = Image.new('L', (8, 8))
    for y in range(8):
        lo, hi = data[2 * y], data[2 * y + 1]
        for x in range(8):
            c = ((lo >> (7 - x)) & 1) | (((hi >> (7 - x)) & 1) << 1)
            im.putpixel((x, y), PAL[3 - c if inv else c])
    return im
def tiles(data, w=16, inv=False):
    n = len(data) // 16; h = (n + w - 1) // w; im = Image.new('L', (w * 8, h * 8), 255)
    for t in range(n): im.paste(tile(data[t * 16:t * 16 + 16], inv), (t % w * 8, t // w * 8))
    return im
def tiles16(data, w=16):
    """8x16 sprites: tile 2n on top of tile 2n+1, w sprites per row"""
    n = len(data) // 32; h = (n + w - 1) // w; im = Image.new('L', (w * 8, h * 16), 255)
    for s in range(n):
        im.paste(tile(data[s * 32:s * 32 + 16]), (s % w * 8, s // w * 16)); im.paste(tile(data[s * 32 + 16:s * 32 + 32]), (s % w * 8, s // w * 16 + 8))
    return im
def tmap(rom, mo, cols, src, show=(20, 18)):
    im = Image.new('L', (show[0] * 8, show[1] * 8), 255)
    for r in range(show[1]):
        for c in range(show[0]):
            o = src(rom[mo + r * cols + c])
            if o is not None: im.paste(tile(rom[o:o + 16]), (c * 8, r * 8))
    return im
def side(*ims, gap=8):
    W = sum(i.width for i in ims) + gap * (len(ims) - 1); H = max(i.height for i in ims); c = Image.new('L', (W, H), 255); x = 0
    for i in ims: c.paste(i.convert('L'), (x, 0)); x += i.width + gap
    return c
def shot(path): return gb_palette.gray(Image.open(path)).convert('L')
def _font(sz, bold=False):
    p = '/usr/share/fonts/truetype/dejavu/DejaVuSans%s.ttf' % ('-Bold' if bold else '')
    return ImageFont.truetype(p, sz) if os.path.exists(p) else ImageFont.load_default()
F, FB, FT = _font(13), _font(15, True), _font(18, True)
_JP = '/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc'
FJ = ImageFont.truetype(_JP, 13) if os.path.exists(_JP) else F
S, W, PAD = 2, 1400, 14
def _flow(items, y, d, img):
    x = PAD; rowh = 0
    for cap, adr, im in items:
        im2 = im.resize((im.width * S, im.height * S), Image.NEAREST).convert('RGB')
        wid = max(im2.width, int(d.textlength(cap, font=FJ)), int(d.textlength(adr, font=F)))
        if x + wid > W - PAD and x > PAD: x = PAD; y += rowh + 12; rowh = 0
        if img is not None:
            d.text((x, y), cap, fill=(0, 0, 0), font=FJ); d.text((x, y + 16), adr, fill=(90, 90, 90), font=F); img.paste(im2, (x, y + 34))
        rowh = max(rowh, im2.height + 34); x += wid + 18
    return y + rowh + 12
def _draw(img, title, subtitle, sections):
    d = ImageDraw.Draw(img if img is not None else Image.new('RGB', (8, 8))); y = PAD
    if img is not None:
        d.text((PAD, y), title, fill=(0, 0, 0), font=FT); d.text((PAD, y + 24), subtitle, fill=(60, 60, 60), font=F)
    y += 52
    for head, col, items in sections:
        if not items: continue
        if img is not None: d.line([(PAD, y), (W - PAD, y)], fill=col, width=3); d.text((PAD, y + 6), head, fill=col, font=FB)
        y = _flow(items, y + 30, d, img)
    return y
def sheet(title, subtitle, sections, out, check=False, tag='sheet'):
    H = _draw(None, title, subtitle, sections) + PAD
    im = Image.new('RGB', (W, H), (255, 255, 255)); _draw(im, title, subtitle, sections)
    buf = io.BytesIO(); im.save(buf, 'PNG', optimize=True)
    if check:
        ok = os.path.exists(out) and open(out, 'rb').read() == buf.getvalue(); print('%s: %s' % (tag, 'fresh' if ok else 'differs: ' + out)); return 0 if ok else 1
    open(out, 'wb').write(buf.getvalue()); print('%s: %s (%d x %d)' % (tag, out, W, H)); return 0
