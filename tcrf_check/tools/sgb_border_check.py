#!/usr/bin/env python3
"""Decode the Super Game Boy transfers of a Game Boy Camera ROM and rebuild the SGB border from bank $0B.

usage: sgb_border_check.py ROM [--map ROM_MAP.csv] [--capture PNG [--crop X,Y,W,H]] [--sheet PNG] [--out PNG]
  ROM       pocketcamera_jp.gb or roms/gbcam_usa_eu.gb (same packet layout, same bank $0B addresses; the sender code sits at other 00: addresses)
  --map     coverage/results/report_v8/rom_map.csv (JP only): counts the byte classes inside every transfer block
  --capture a BGB screenshot of a Super Game Boy run (SystemMode=2, no -hf, Xvfb + `import -window root`); --crop X,Y,W,H cuts the
            256x224 border window out of a larger screenshot (a 512x448 crop is scaled down by 2); the border pixels are compared with the rebuilt ones
  --sheet   a community picture (Spriters Resource "Super Game Boy Borders"): searched for the rebuilt border at every offset
  --out     side by side PNG, rebuilt border (left) and capture or sheet window (right), at 2x

What it does: (1) scans the first 16 KB of bank 0 for the sender's calls `ld a,$0B / ld hl,ADDR / call F` (ADDR in $4000-$7FFF) and decodes the 16-byte
packet found at ADDR (command = header >> 3, length = header & 7). CHR_TRN ($13), PCT_TRN ($14), PAL_TRN ($0B) and ATTR_TRN ($15) are sent by the
transfer routine, which copies the $1000 bytes that follow the packet to $8800 and shows them as tiles, so the SGB reads ADDR+$10 ... ADDR+$100F.
(2) renders the border (Pan Docs, "SGB Border"): CHR_TRN data byte 0 bit 0 selects tiles 0-127 or 128-255 (4 bpp, 32 bytes: planes 0/1 in the first 16,
planes 2/3 in the second 16), PCT_TRN = 32 x 32 map words (tile, attribute: bits 2-4 palette 4-7, bit 6 / 7 flips) followed by 4 palettes of 16 BGR555 words.
(3) compares with a capture or a sheet outside the 160 x 144 window in the middle (x 48-207, y 40-183 of the 256 x 224 picture)."""
import sys, os, re, collections
from PIL import Image
import numpy as np

CMD = {0x0A: 'PAL_SET', 0x0B: 'PAL_TRN', 0x0F: 'DATA_SND', 0x11: 'MLT_REQ', 0x13: 'CHR_TRN', 0x14: 'PCT_TRN', 0x15: 'ATTR_TRN', 0x17: 'MASK_EN'}
TRN = (0x0B, 0x13, 0x14, 0x15)
WIN = (48, 40, 208, 184)   # GB screen inside the 256 x 224 picture


def b0(addr):  # bank $0B, CPU address $4000-$7FFF -> file offset
    return 0x0B * 0x4000 + addr - 0x4000


def scan(rom):
    """Sender calls in bank 0: ld a,$0B ; ld hl,ADDR ; call F"""
    out = []
    for m in re.finditer(rb'\x3e\x0b\x21(.)([\x40-\x7f])\xcd(.)(.)', rom[:0x4000], re.S):
        addr = m.group(1)[0] | m.group(2)[0] << 8
        hdr = rom[b0(addr)]
        if (hdr & 7) == 0 or (hdr >> 3) not in CMD:
            continue
        out.append((m.start(), addr, m.group(3)[0] | m.group(4)[0] << 8, hdr))
    return out


def bgr(w):
    r, g, b = w & 31, (w >> 5) & 31, (w >> 10) & 31
    return ((r << 3) | (r >> 2), (g << 3) | (g >> 2), (b << 3) | (b >> 2))


def tile(rom, base):
    px = np.zeros((8, 8), np.uint8)
    for y in range(8):
        p0, p1, p2, p3 = rom[base + 2 * y], rom[base + 2 * y + 1], rom[base + 16 + 2 * y], rom[base + 17 + 2 * y]
        for x in range(8):
            s = 7 - x
            px[y, x] = ((p0 >> s) & 1) | (((p1 >> s) & 1) << 1) | (((p2 >> s) & 1) << 2) | (((p3 >> s) & 1) << 3)
    return px


def build(rom, sends):
    chr_at = {}; pct = None
    for _, addr, _, hdr in sends:
        if hdr >> 3 == 0x13:
            chr_at[rom[b0(addr) + 1] & 1] = addr + 0x10
        elif hdr >> 3 == 0x14:
            pct = addr + 0x10
    tiles = {}
    for half, a in chr_at.items():
        for t in range(128):
            tiles[half * 128 + t] = (a + t * 32, tile(rom, b0(a + t * 32)))
    pal = [[bgr(rom[b0(pct + 0x800 + p * 32 + i * 2)] | rom[b0(pct + 0x800 + p * 32 + i * 2 + 1)] << 8) for i in range(16)] for p in range(4)]
    img = np.zeros((224, 256, 3), np.uint8); used_t = set(); used_map = []; used_pal = set()
    for r in range(28):
        for c in range(32):
            o = pct + (r * 32 + c) * 2
            t, a = rom[b0(o)], rom[b0(o + 1)]
            p = (a >> 2) & 7; pi = max(p - 4, 0); px = tiles[t][1]
            if a & 0x40: px = px[:, ::-1]
            if a & 0x80: px = px[::-1, :]
            used_t.add(t); used_pal.add(p)
            used_map += [o, o + 1]
            for y in range(8):
                for x in range(8):
                    img[r * 8 + y, c * 8 + x] = pal[pi][px[y, x]]
    return img, tiles, used_t, used_map, used_pal, pct


def load_classes(path):
    import csv
    cls = {}
    for r in csv.DictReader(open(path)):
        if r['bank'].upper() != '0B': continue
        s = int(r['start'], 16); n = int(r['length'])
        for i in range(n): cls[s + i] = r['class']
    return cls


def window_of(png, crop):
    im = Image.open(png).convert('RGB')
    if crop:
        x, y, w, h = crop; im = im.crop((x, y, x + w, y + h))
    if im.size != (256, 224): im = im.resize((256, 224), Image.NEAREST)
    return np.array(im)


def main(a):
    def opt(n, d=None):
        if n in a: i = a.index(n); v = a[i + 1]; del a[i:i + 2]; return v
        return d
    mp = opt('--map'); cap = opt('--capture'); crop = opt('--crop'); sheet = opt('--sheet'); out = opt('--out')
    crop = tuple(int(v) for v in crop.split(',')) if crop else None
    rom = open(a[0], 'rb').read()
    sends = scan(rom)
    print('sender calls found in bank 0 (ld a,$0B / ld hl,ADDR / call): %d' % len(sends))
    cls = load_classes(mp) if mp else None
    print('%-8s %-6s %-9s %-9s %s' % ('at', 'ADDR', 'call', 'command', 'header + data window'))
    for at, addr, call, hdr in sends:
        cmd = hdr >> 3
        win = ''
        if cmd in TRN:
            win = '%04X-%04X (4 KB after the packet)' % (addr + 0x10, addr + 0x100F)
        print('00:%04X %04X   %04X      %-9s %02X %s' % (at, addr, call, CMD[cmd], hdr, win +
              ('' if cmd not in TRN else '' )))
    img, tiles, used_t, used_map, used_pal, pct = build(rom, sends)
    used = set()
    for t in used_t:
        for k in range(32): used.add(tiles[t][0] + k)
    used.update(used_map)
    chr_off = sorted(a2 for a2 in (tiles[0][0], tiles[128][0]))
    print('\nborder: %d of 256 tiles are used by the map, palettes %s' % (len(used_t), sorted(p for p in used_pal)))
    print('bytes the picture needs: %d tile bytes + %d map bytes (rows 0-27 of the 32 x 32 map) + palettes' % (len(used_t) * 32, len(used_map)))
    if cls:
        cnt = collections.Counter(cls.get(x, '?') for x in used)
        print('their coverage classes in the v8 run: %s (U = never read, r = read only in forced runs, R = read organically)' % dict(cnt))
    if sheet or cap:
        mask = np.ones((224, 256), bool); mask[WIN[1]:WIN[3], WIN[0]:WIN[2]] = False
        tgt = None
        if cap:
            tgt = window_of(cap, crop); name = 'BGB capture'
            d = np.abs(img.astype(int) - tgt.astype(int)).sum(axis=2)
            print('\n%s: %d of %d border pixels identical (max channel sum difference %d)' % (name, int((d[mask] == 0).sum()), int(mask.sum()), int(d[mask].max())))
            lcd = tgt[WIN[1]:WIN[3], WIN[0]:WIN[2]].reshape(-1, 3)
            cc = collections.Counter(map(tuple, lcd.tolist())).most_common(6)
            print('  colours in the game window:', [('%02X%02X%02X' % c, n) for c, n in cc])
        if sheet:
            sh = np.array(Image.open(sheet).convert('RGBA')).astype(int)[:, :, :3]
            best = (0, 0, 0)
            for oy in range(sh.shape[0] - 223):
                for ox in range(sh.shape[1] - 255):
                    if (np.abs(sh[oy + 3, ox:ox + 40] - img[3, :40].astype(int)).sum() > 0): continue
                    d = np.abs(sh[oy:oy + 224, ox:ox + 256] - img.astype(int)).sum(axis=2)
                    n = int((d[mask] == 0).sum())
                    if n > best[0]: best = (n, ox, oy)
            print('\nsheet %s: best offset x=%d y=%d, %d of %d border pixels identical' % (os.path.basename(sheet), best[1], best[2], best[0], int(mask.sum())))
            if tgt is None: tgt = sh[best[2]:best[2] + 224, best[1]:best[1] + 256].astype(np.uint8)
        if out and tgt is not None:
            sbs = Image.new('RGB', (256 * 2 + 8, 224), (255, 0, 255))
            sbs.paste(Image.fromarray(img), (0, 0)); sbs.paste(Image.fromarray(tgt), (264, 0))
            sbs.resize((sbs.width * 2, sbs.height * 2), Image.NEAREST).save(out)
            print('wrote', out)
    elif out:
        Image.fromarray(img).save(out); print('wrote', out)


if __name__ == '__main__':
    main(sys.argv[1:])
