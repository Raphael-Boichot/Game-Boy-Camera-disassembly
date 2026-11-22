#!/usr/bin/env python3
"""The prototype's 381-byte grids (2026-11-22): the uncertain runs of banks $08-$19, measured and drawn 381 bytes wide.

  tools/proto_grids.py PROTO.gb [--csv roms/prototype_debagame/assets/grids_proto.csv] [--png roms/prototype_debagame/screens/grids_381_proto.png]

Two forms of one kind of data (C, measured; what the data is stays open, I):
  * binary: banks $08-$10 after their PC-memory head (x86 code at $4000-$41FF): one small value per byte ($00, $01, $03, $80, $81 ...);
  * digits: banks $11-$19: one byte $30-$3F per cell (the digits 0-9 and : ; < = > ?, i.e. $30 + a value 0-15), in runs of 64 bytes or
    more with no line end; in banks $13-$17 they follow a few hundred bytes of the developers' source (tools/proto_types.py ends the
    text there since 2026-11-22: 79,586 bytes counted as source before were these digits).
For each run: the distances between the places where the value changes, the most common ones (in both forms multiples of 381 come
first: 381, 762, 1,143, 1,524 ...), and the drawing: 381 cells a row, a grey per value (binary: the low nibble, +8 when bit 7 is set;
digits: the value 0-15), one band per bank.
"""
import argparse, csv, os, re, collections, hashlib
import numpy as np
from PIL import Image, ImageDraw
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); P = os.path.join(REPO, 'roms', 'prototype_debagame')
ap = argparse.ArgumentParser(); ap.add_argument('rom')
ap.add_argument('--csv', default=os.path.join(P, 'assets', 'grids_proto.csv')); ap.add_argument('--png', default=os.path.join(P, 'screens', 'grids_381_proto.png'))
a = ap.parse_args(); R = open(a.rom, 'rb').read()
if hashlib.md5(R).hexdigest() != '19b50a5f67ef4f0d015e7d813370756e': raise SystemExit('proto_grids: expected the image as dumped (md5 19b50a5f...)')
W = 381
def runs(b):
    o = b * 0x4000; d = R[o:o + 0x4000]
    if b <= 0x10: return [('binary', 0x4200, 0x7FFF)]          # after the 512-byte PC-memory head; the bank-number byte at $7FFF excluded
    return [('digits', 0x4000 + m.start(), 0x4000 + m.end()) for m in re.finditer(rb'[\x30-\x3F]{64,}', d)]
rows = []; bands = []
for b in range(0x08, 0x1A):
    for form, s, e in runs(b):
        if e - s < 4 * W: continue
        v = np.frombuffer(R[b * 0x4000 + s - 0x4000:b * 0x4000 + e - 0x4000], np.uint8).astype(int)
        t = np.flatnonzero(v[1:] != v[:-1]); c = collections.Counter()
        for i in range(len(t)):
            for j in range(i + 1, len(t)):
                dd = int(t[j] - t[i])
                if dd > 8000: break
                if dd >= 16: c[dd] += 1
        top = [d for d, n in c.most_common(6)]
        vals = collections.Counter(v.tolist()).most_common(6)
        rows.append(['%02X' % b, '%04X' % s, '%04X' % e, e - s, form, ' '.join('%02X:%d' % x for x in vals), ' '.join(map(str, top)),
                     sum(1 for d in top if d % W == 0)])
        g = (v & 0x0F) + np.where(v & 0x80, 8, 0) if form == 'binary' else v - 0x30
        n = len(g) // W
        if n: bands.append(('%02X:%04X' % (b, s), (255 - np.clip(g[:n * W], 0, 15) * 16).reshape(n, W).astype(np.uint8)))
with open(a.csv, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n')
    w.writerow(['bank', 'start', 'end', 'bytes', 'form', 'most_common_values', 'most_common_change_distances', 'of_them_multiples_of_381']); w.writerows(rows)
Z = 2; LW = 60; H = sum(im.shape[0] + 3 for _, im in bands)
img = Image.new('L', (LW + W * Z, H * Z), 255); dr = ImageDraw.Draw(img); y = 0
for lb, im in bands:
    img.paste(Image.fromarray(im).resize((W * Z, im.shape[0] * Z), Image.NEAREST), (LW, y)); dr.text((2, y), lb, fill=0)
    y += (im.shape[0] + 3) * Z
os.makedirs(os.path.dirname(a.png), exist_ok=True); img.save(a.png, optimize=True)
print('proto_grids: %d runs, %d bytes (binary %d, digits %d); runs whose two most common change distances are multiples of 381: %d' % (
    len(rows), sum(r[3] for r in rows), sum(r[3] for r in rows if r[4] == 'binary'), sum(r[3] for r in rows if r[4] == 'digits'),
    sum(1 for r in rows if all(int(d) % W == 0 for d in r[6].split()[:2]))))
