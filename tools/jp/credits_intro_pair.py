#!/usr/bin/env python3
"""The intro pages of the real credits, Japanese vs international (README, docs 1.5): BGB captures made by tools/jp/bgb_credits_intl.py
(unlocking save unl_CE10238211_tagtest, keys A, Start, Right x3, A, then a wait of 300 / 700 frames (JP) and 540 / 900 frames (intl)).
Both builds open on "CLIP THIS." (08:13). The Japanese second page "Dub up to the Future / One Love" (08:14) is replaced in the international build
by two scenes of Nintendo's arcade game Sheriff (TCRF, Regional Differences): "HELP!" (new state 08:14) and the hearts with "BONUS !!" (08:15).
  credits_intro_pair.py [OUT.png]   (default roms/jp_rev_a/experiments/credits_intl/credits_intro_jp_vs_intl.png)"""
import os, sys
from PIL import Image, ImageDraw, ImageFont
A = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), 'roms', 'jp_rev_a', 'experiments', 'credits_intl')
OUT = sys.argv[1] if len(sys.argv) > 1 else os.path.join(A, 'credits_intro_jp_vs_intl.png')
def fnt(sz, bold=True):
    q = '/usr/share/fonts/truetype/dejavu/DejaVuSans%s.ttf' % ('-Bold' if bold else '')
    return ImageFont.truetype(q, sz) if os.path.exists(q) else ImageFont.load_default(size=sz)
S, M, GAP, ROWT = 3, 24, 24, 60
BGB_GREY = {(20, 44, 56): 0, (84, 140, 112): 85, (172, 212, 144): 170, (232, 252, 204): 255}   # BGB's green palette -> the four Game Boy greys (owner 2026-11-01)
def img(n):
    im = Image.open(os.path.join(A, n)).convert('RGB'); g = Image.new('L', im.size); g.putdata([BGB_GREY[c] for c in im.getdata()])
    return g.resize((160 * S, 144 * S), Image.NEAREST)
rows = [('Japanese ROM: 08:13 "CLIP THIS."  ->  08:14 "One Love"', ['jp_08_13_clip_this.bmp', 'jp_08_14_one_love.bmp']),
        ('International ROM: 08:13 "CLIP THIS."  ->  new 08:14 Sheriff "HELP!"  ->  08:15 Sheriff "BONUS !!"',
         ['us_08_13_clip_this.bmp', 'us_08_14_sheriff_help.bmp', 'us_08_15_sheriff_bonus.bmp'])]
W = 2 * M + 3 * 160 * S + 2 * GAP; H = M + len(rows) * (ROWT + 144 * S + M)
im = Image.new('L', (W, H), 255); d = ImageDraw.Draw(im); f1 = fnt(26)
y = M
for t, fs in rows:
    d.text((M, y + 14), t, fill=0, font=f1); y += ROWT
    for i, f in enumerate(fs):
        x = M + i * (160 * S + GAP); im.paste(img(f), (x, y)); d.rectangle([x - 1, y - 1, x + 160 * S, y + 144 * S], outline=0, width=2)
    y += 144 * S + M
im.save(OUT, optimize=True); print(OUT, im.size)
