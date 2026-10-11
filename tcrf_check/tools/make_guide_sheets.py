#!/usr/bin/env python3
"""Contact sheets and verdict table of the Funtography flowchart walk: for every node of guide_nodes.NODES (and the Space Fever II routes) the BGB screenshot on the Japanese and the international ROM
side by side, with the (mode,state) the game reported.   usage: make_guide_sheets.py WORKDIR(guide_bgb_walk output) OUTDIR"""
import sys, os, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from PIL import Image, ImageDraw, ImageFont
import guide_nodes as G
import guide_bgb_walk_specials as SP
W, O = sys.argv[1:3]; os.makedirs(O, exist_ok=True)
res = json.load(open(os.path.join(W, 'guide_walk_results.json')))
def st(r, nid):
    v = res.get('%s_%s' % (r, nid)); return v.split()[0] if v else None
def font(sz):
    for f in ('/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc', '/usr/share/fonts/truetype/noto/NotoSansCJK-Regular.ttc', '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf'):
        if os.path.exists(f):
            try: return ImageFont.truetype(f, sz)
            except Exception: pass
    return ImageFont.load_default()
F = font(12); FB = font(15); BG = (60, 60, 100); WHITE = (255, 255, 255); YEL = (255, 255, 0); OK = (120, 255, 120); BAD = (255, 140, 140)
nodes = [(c, i, l, p, e) for c, i, l, p, e in G.NODES] + [(c, i, l, '', e) for c, i, l, e in SP.SPECIAL_NODES]
charts = ['USER', 'SHOOT', 'VIEW', 'PLAY', 'STUDIO']
verdict = {}
for ch in charts:
    rows = [n for n in nodes if n[0] == ch]
    cols = 2; w, h = 160, 144; cw = 2 * w + 20; ch_h = h + 44
    S = Image.new('RGB', (cols * cw + 12, 34 + ((len(rows) + cols - 1) // cols) * ch_h), BG); d = ImageDraw.Draw(S)
    d.text((8, 6), 'Funtography chart %s: BGB, Japanese ROM (left) and international ROM (right), same key presses' % ch, fill=WHITE, font=FB)
    for k, (c, nid, label, path, exp) in enumerate(rows):
        x = 8 + (k % cols) * cw; y = 34 + (k // cols) * ch_h
        j, u = st('jp', nid), st('us', nid)
        d.text((x, y), '%s %s' % (nid, label[:44]), fill=WHITE, font=F)
        for n, (r, v) in enumerate((('jp', j), ('us', u))):
            p = os.path.join(W, '%s_%s.bmp' % (r, nid))
            if os.path.exists(p): S.paste(Image.open(p).convert('RGB'), (x + n * (w + 4), y + 16))
            d.text((x + n * (w + 4), y + 16 + h + 1), '%s %s' % ('JP' if r == 'jp' else 'US', v or '-'), fill=(OK if v and (exp is None or v == '%02X:%02X' % exp) else YEL), font=F)
        verdict[nid] = dict(chart=c, label=label, path=path, expected_jp='%02X:%02X' % exp if exp else None, bgb_jp=j, bgb_us=u)
    fn = 'guide_chart_%s.png' % ch.lower(); S.save(os.path.join(O, fn)); print(fn, S.size)
json.dump(verdict, open(os.path.join(O, 'guide_nodes_verdict.json'), 'w'), indent=1, ensure_ascii=False)
