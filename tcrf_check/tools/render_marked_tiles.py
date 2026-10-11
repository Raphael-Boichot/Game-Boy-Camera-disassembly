#!/usr/bin/env python3
"""Render a ROM range as 2bpp Game Boy tiles (contact sheet) with the never-read data bytes
(class U of the byte-class map coverage/results/report_v8/rom_map.csv, padding excluded) tinted red.

usage: render_marked_tiles.py ROM ROM_MAP.csv OUT.png BANK:START-END [BANK:START-END ...]
                       [--ctx N] [--cols N] [--scale N] [--bpp 1|2]
  START/END are CPU addresses ($4000-$7FFF for banks >= 1), hex without prefix.
  --ctx N   : show N extra bytes before and after the range (default 0x100)
  --bpp 1   : 1bpp tiles (8 bytes per tile, shades 0 and 3), as read by the nibble expander 00:289C
"""
import sys, struct, zlib

SHADES = [(255, 255, 255), (170, 170, 170), (85, 85, 85), (0, 0, 0)]


def load_classes(path, size=1 << 20):
    """byte class per ROM offset from rom_map.csv (bank,start,length,class; start is $4000-based for banks >= 1)"""
    import csv
    cls = bytearray(size)
    for r in csv.DictReader(open(path)):
        b = int(r['bank'], 16); a = int(r['start'], 16); o = b * 0x4000 + (a - 0x4000 if b else a)
        cls[o:o + int(r['length'])] = r['class'].encode() * int(r['length'])
    return bytes(cls)


def png(path, w, h, rgb):
    raw = b''.join(b'\x00' + bytes(rgb[y * w * 3:(y + 1) * w * 3]) for y in range(h))

    def chunk(t, d):
        c = struct.pack('>I', len(d)) + t + d
        return c + struct.pack('>I', zlib.crc32(t + d) & 0xffffffff)
    open(path, 'wb').write(b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', struct.pack('>IIBBBBB', w, h, 8, 2, 0, 0, 0))
                           + chunk(b'IDAT', zlib.compress(raw, 6)) + chunk(b'IEND', b''))


def padmask(rom):
    pad = bytearray(len(rom))
    i = 0
    while i < len(rom):
        if rom[i] in (0, 0xFF):
            j = i
            while j < len(rom) and rom[j] == rom[i]:
                j += 1
            if j - i >= 16:
                pad[i:j] = b'\x01' * (j - i)
            i = j
        else:
            i += 1
    return pad


def main(a):
    ctx, cols, scale, bpp = 0x100, 16, 3, 2
    args = []
    i = 0
    while i < len(a):
        if a[i] == '--ctx': ctx = int(a[i + 1], 0); i += 2
        elif a[i] == '--cols': cols = int(a[i + 1]); i += 2
        elif a[i] == '--scale': scale = int(a[i + 1]); i += 2
        elif a[i] == '--bpp': bpp = int(a[i + 1]); i += 2
        else: args.append(a[i]); i += 1
    rom = open(args[0], 'rb').read()
    cls = load_classes(args[1])
    out = args[2]
    pad = padmask(rom)
    panels = []
    for spec in args[3:]:
        b, r = spec.split(':')
        s, e = [int(x, 16) for x in r.split('-')]
        base = b_off = int(b, 16) * 0x4000 - (0x4000 if int(b, 16) else 0)
        al = 16 if bpp == 2 else 8
        lo = max((s - ctx) & ~(al - 1), 0x4000 if int(b, 16) else 0)
        hi = min((e + ctx + al) & ~(al - 1), 0x8000 if int(b, 16) else 0x4000)
        panels.append((b, s, e, lo, hi, base))
    tiles = []
    for b, s, e, lo, hi, base in panels:
        for ad in range(lo, hi, 16 if bpp == 2 else 8):
            tiles.append((b, ad, base + ad))
    nrows = (len(tiles) + cols - 1) // cols
    T = 8 * scale
    G = 1
    W = cols * (T + G) + G
    H = nrows * (T + G) + G
    rgb = bytearray([40, 40, 60] * (W * H))
    for n, (b, ad, off) in enumerate(tiles):
        cx = G + (n % cols) * (T + G)
        cy = G + (n // cols) * (T + G)
        inr = any(p[0] == b and p[1] <= ad <= p[2] for p in panels)
        nb = 16 if bpp == 2 else 8
        unt = sum(1 for k in range(nb) if cls[off + k] in (ord('U'), ord('N')) and not pad[off + k])
        ispad = sum(pad[off + k] for k in range(nb)) >= nb * 3 // 4
        for y in range(8):
            if bpp == 2:
                lo_b, hi_b = rom[off + 2 * y], rom[off + 2 * y + 1]
            else:
                lo_b = hi_b = rom[off + y]
            for x in range(8):
                v = ((lo_b >> (7 - x)) & 1) | (((hi_b >> (7 - x)) & 1) << 1)
                col = SHADES[v]
                if unt >= nb // 2:
                    col = (min(255, col[0] // 2 + 128), col[1] // 2, col[2] // 2)
                elif ispad:
                    col = (col[0] // 2 + 100, col[1] // 2 + 100, min(255, col[2] // 2 + 140))
                for dy in range(scale):
                    for dx in range(scale):
                        p = ((cy + y * scale + dy) * W + cx + x * scale + dx) * 3
                        rgb[p:p + 3] = bytes(min(255, max(0, c)) for c in col)
    png(out, W, H, rgb)
    print('wrote', out, W, 'x', H, 'tiles', len(tiles))


if __name__ == '__main__':
    main(sys.argv[1:])
