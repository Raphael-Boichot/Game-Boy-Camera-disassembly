#!/usr/bin/env python3
"""The two hidden boot screens of the camera, the factory calibration and the fast calibration sanity check, with the inputs that open them
(README, near the unused assets; docs 8).

  tools/jp/secret_screens_pair.py [OUT.png]    (default roms/jp_rev_a/experiments/secret/secret_calibration_screens.png)

Inputs: the four BGB screenshots of roms/jp_rev_a/experiments/secret/ made by tools/jp/calib_screens_capture.py (Japanese ROM, synthetic saves;
its docstring has the runs):
  factory_calibration_wait_bgb.bmp / factory_calibration_end_bgb.bmp   save of $AA: STORE / PLEASE WAIT, then STORE / END
  calib_sanity_check_ok_bgb.bmp / calib_sanity_check_ng_bgb.bmp       every button except B held: OK with the blank record, NG with the
                                                                      intense-light record of camera CE10245109 (§18.13)
The factory calibration is shown through the blank record; holding every button opens the same code (0A:6B73), but BGB reads a demo byte of
$FF as no key (docs 8)."""
import os, sys
from PIL import Image, ImageDraw, ImageFont
HERE = os.path.dirname(os.path.abspath(__file__)); A = os.path.join(os.path.dirname(os.path.dirname(HERE)), 'roms', 'jp_rev_a', 'experiments', 'secret')
OUT = sys.argv[1] if len(sys.argv) > 1 else os.path.join(A, 'secret_calibration_screens.png')
SC = 3
def gray(fn):
    """BGB's green palette -> the four Game Boy greys (owner 2026-11-01): the screen colours, darkest to lightest, become 0 / 85 / 170 / 255"""
    im = Image.open(os.path.join(A, fn)).convert('RGB'); cols = sorted({c for c in im.getdata()}, key=lambda c: 299 * c[0] + 587 * c[1] + 114 * c[2])
    shade = {c: (0, 85, 170, 255)[round(3 * i / max(1, len(cols) - 1))] if len(cols) < 4 else (0, 85, 170, 255)[min(3, i)] for i, c in enumerate(cols)}
    out = Image.new('RGB', im.size); out.putdata([(shade[c],) * 3 for c in im.getdata()]); return out.resize((im.width * SC, im.height * SC), Image.NEAREST)
def fnt(sz, bold=True):
    for q in ('/usr/share/fonts/truetype/dejavu/DejaVuSans%s.ttf' % ('-Bold' if bold else ''), '/usr/share/fonts/dejavu/DejaVuSans%s.ttf' % ('-Bold' if bold else '')):
        if os.path.exists(q): return ImageFont.truetype(q, sz)
    return ImageFont.load_default(size=sz)
f1, f2, f3, f4 = fnt(30), fnt(22), fnt(20, False), fnt(20)
_sc = ImageDraw.Draw(Image.new('L', (8, 8)))
def wrap(text, fnt_, maxw):
    out, line = [], ''
    for w_ in text.split(' '):
        cand = (line + ' ' + w_).strip()
        if _sc.textlength(cand, font=fnt_) <= maxw or not line: line = cand
        else: out.append(line); line = w_
    return out + [line]
M, GAP, PG = 24, 40, 16
cols = [('Factory calibration', 'Hold every button (A + B + SELECT + START + the four directions) while switching on, or switch on with a blank calibration record (twelve $AA in both copies)',
         'Measures the sensor at its 12 register sets and stores the 12-byte vector and its echo in the save (0A:6B73, Cam_FactoryCalibration). Do it in the dark: a calibration in the light gives a vector that makes the auto-exposure jitter (docs 18.13).',
         [('factory_calibration_wait_bgb.bmp', 'during: STORE / PLEASE WAIT'), ('factory_calibration_end_bgb.bmp', 'done: STORE / END')]),
        ('Fast calibration sanity check', 'Hold A + SELECT + START + Up + Down + Left + Right (every button except B) while switching on',
         'Measures again, writes nothing, and compares the new slot 10 and 11 (GAIN8, GAINA) with the stored ones, against the two tolerance bytes shown top right: OK (tune $16) or NG (tune $29), then loops until power-off (0A:6A7B, Cam_CalibSanityCheck).',
         [('calib_sanity_check_ok_bgb.bmp', 'blank record: OK (9F within AA)'), ('calib_sanity_check_ng_bgb.bmp', 'intense-light record: NG (B2 > AA)')])]
pics = [[gray(f) for f, _ in c[3]] for c in cols]; CW = pics[0][0].width
blocks = [(wrap(a, f1, CW), wrap(b, f2, CW - 20), wrap(c, f3, CW)) for a, b, c, _ in cols]
hdr = max(40 * len(a) + 20 + 30 * len(b) + 26 + 28 * len(c) for a, b, c in blocks) + 16
ph = pics[0][0].height; body = 2 * (ph + 34) + PG
foot = wrap('BGB screenshots of the Japanese ROM from synthetic saves (tools/jp/calib_screens_capture.py); the international ROM has the same code at the same addresses (bank $0A). BGB has no real sensor: its readings are always 0B, so the verdict here depends on the save alone. Columns per row of the check: stored value, new value, sign and difference; top right: the tolerance bytes $AFF0 / $AFF1 (1B 13 in retail saves, AA after a calibration from a blank save).', f3, 2 * CW + GAP)
im = Image.new('RGB', (2 * M + 2 * CW + GAP, 16 + hdr + body + 20 + 28 * len(foot) + 20), 'white'); d = ImageDraw.Draw(im)
for k, ((_, _, _, sub), (a, b, c), pp) in enumerate(zip(cols, blocks, pics)):
    x = M + k * (CW + GAP); y = 16
    for l in a: d.text((x, y), l, fill=(0, 0, 0), font=f1); y += 40
    y += 8; d.rectangle([x, y - 6, x + CW, y + 30 * len(b) + 4], fill=(255, 236, 160))
    for l in b: d.text((x + 10, y), l, fill=(0, 0, 0), font=f2); y += 30
    y += 18
    for l in c: d.text((x, y), l, fill=(60, 60, 60), font=f3); y += 28
    y = 16 + hdr
    for pic, (_, cap) in zip(pp, sub):
        d.text((x, y), cap, fill=(0, 0, 0), font=f4); y += 30
        im.paste(pic, (x, y)); d.rectangle([x - 1, y - 1, x + pic.width, y + pic.height], outline=(0, 0, 0), width=2); y += ph + 4 + PG
y = 16 + hdr + body + 16
for l in foot: d.text((M, y), l, fill=(60, 60, 60), font=f3); y += 28
im.save(OUT, optimize=True); print(OUT, im.size)
