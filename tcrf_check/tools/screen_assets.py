#!/usr/bin/env python3
"""Compose every full-screen picture that the ROM loads by static tile/tilemap copy calls (catalog_jp.csv groups by caller label).
Each group = tile blocks copied to VRAM ($8000-$97FF) + a tilemap copied to $9800/$9C00; the tilemap is rendered with the
LCDC.4 addressing mode (unsigned $8000 / signed $8800) that hits most loaded tiles. Tiles that come from WRAM (runtime-built) or
are missing are drawn as a hatch. usage: screen_assets.py ROM catalog.csv OUTDIR"""
import sys, os, csv, collections
from PIL import Image, ImageDraw
rom = open(sys.argv[1], 'rb').read(); cat = list(csv.DictReader(open(sys.argv[2]))); out = sys.argv[3]; os.makedirs(out, exist_ok=True)
PAL = [255, 170, 85, 0]
def tile_img(data):
    im = Image.new('L', (8, 8)); px = im.load()
    for y in range(8):
        b0 = data[2 * y]; b1 = data[2 * y + 1]
        for x in range(8): px[x, y] = PAL[((b1 >> (7 - x)) & 1) << 1 | ((b0 >> (7 - x)) & 1)]
    return im
HATCH = Image.new('L', (8, 8), 255)
for i in range(8): HATCH.putpixel((i, i), 120)
groups = collections.OrderedDict()
for r in cat: groups.setdefault((r['caller_bank'], r['caller_label']), []).append(r)
index = []
for (cb, lab), rows in groups.items():
    vram = {}  # tile address -> 16 bytes
    maps = []
    for r in rows:
        d = int(r['dst'], 16); ln = int(r['length'], 16); off = int(r['file_offset'], 16)
        if off < 0: continue
        if 0x8000 <= d < 0x9800 and ln % 16 == 0:
            for t in range(ln // 16): vram[d + 16 * t] = rom[off + 16 * t: off + 16 * t + 16]
        elif d in (0x9800, 0x9C00) and ln >= 0x140:
            maps.append((d, rom[off: off + ln], r))
    for (d, tm, r) in maps:
        rows_n = len(tm) // 32
        best = None
        for mode in ('u', 's'):
            hit = 0
            for t in tm:
                a = 0x8000 + 16 * t if mode == 'u' else (0x9000 + 16 * t if t < 128 else 0x8800 + 16 * (t - 128))
                hit += a in vram
            if best is None or hit > best[0]: best = (hit, mode)
        hit, mode = best
        if hit < len(tm) * 0.25: continue
        W = 20 if len(tm) // 32 <= 18 else 32
        img = Image.new('L', (32 * 8, rows_n * 8), 255)
        for i, t in enumerate(tm):
            a = 0x8000 + 16 * t if mode == 'u' else (0x9000 + 16 * t if t < 128 else 0x8800 + 16 * (t - 128))
            ti = tile_img(vram[a]) if a in vram else HATCH
            img.paste(ti, ((i % 32) * 8, (i // 32) * 8))
        name = '%s_%s_map%04X_src%s_%s.png' % (cb, lab, d, r['src_bank'], r['src'])
        img.crop((0, 0, 160, min(img.height, 144 if rows_n >= 18 else img.height))).save(os.path.join(out, name))
        index.append((name, cb, lab, d, r['src_bank'], r['src'], hit, len(tm), mode))
with open(os.path.join(out, 'INDEX.csv'), 'w') as f:
    f.write('file,caller_bank,caller_label,map_dst,map_src_bank,map_src,tiles_hit,tiles_total,lcdc4_mode\n')
    for x in index: f.write(','.join(str(v) for v in x) + '\n')
print(len(index), 'screens')
