#!/usr/bin/env python3
"""L0 intake of a ROM (HOWTO_NEW_ROM.md section 1): header, per-bank comparison with sibling ROMs, no-symbol round trip.

  tools/rom_intake.py ROM --out DIR [--ref NAME=ROM ...] [--exclusive A,B ...] [--mgbdis /home/claude/tc/mgbdis/mgbdis.py] [--no-roundtrip]

The Hello Kitty run (2026-11-07):
  tools/rom_intake.py $R/pocketcamera_kitty.gb --out roms/hello_kitty/intake --ref jp=$R/pocketcamera_jp.gb --ref proto=$R/pocketcamera_proto.gb \
      --ref us=$R/gbcam_usa_eu.gb --ref gold=$R/gbcam_gold.gb --exclusive jp,us --exclusive jp,proto

Writes into DIR:
  intake_header.csv   field, offset, raw bytes, value (the cartridge header $0100-$014F, checksums recomputed)
  intake_banks.csv    one row per bank: padding bytes (runs of 16+ equal $00 / $FF), and per reference ROM
                      same_<ref>    bytes equal to the same offset of the same bank of the reference (a plain overlay)
                      shared_<ref>  bytes of the bank covered by a 16-byte window that occurs anywhere in the reference ROM
                                    (windows made of one repeated byte are ignored), i.e. content shared at any address
                      best_<ref>    the reference bank that holds most of those windows, and how many bytes it covers
  intake_roundtrip.txt the mgbdis + rgbasm round trip with no symbol file (md5 of the rebuilt ROM)
Prints a summary. The numbers are counts of bytes, recomputed from the files each run: quote them from the CSV.
"""
import argparse, csv, hashlib, os, shutil, subprocess, sys, tempfile, collections

ap = argparse.ArgumentParser()
ap.add_argument('rom'); ap.add_argument('--out', required=True)
ap.add_argument('--ref', action='append', default=[], help='NAME=PATH of a sibling ROM')
ap.add_argument('--mgbdis', default='/home/claude/tc/mgbdis/mgbdis.py')
ap.add_argument('--no-roundtrip', action='store_true')
ap.add_argument('--exclusive', action='append', default=[], help='A,B: also count the bytes shared with reference A and not with B, and the reverse')
a = ap.parse_args()
rom = open(a.rom, 'rb').read(); os.makedirs(a.out, exist_ok=True)
NB = len(rom) // 0x4000; W = 16

# --- header
def hx(b): return ' '.join('%02X' % x for x in b)
hc = 0
for x in rom[0x134:0x14D]: hc = (hc - x - 1) & 0xFF
gc = (sum(rom) - rom[0x14E] - rom[0x14F]) & 0xFFFF
CART = {0x00: 'ROM only', 0x01: 'MBC1', 0x03: 'MBC1+RAM+BATTERY', 0x13: 'MBC3+RAM+BATTERY', 0x1B: 'MBC5+RAM+BATTERY', 0xFC: 'POCKET CAMERA (MAC-GBD)'}
rows = [('md5', '', '', hashlib.md5(rom).hexdigest()), ('size', '', '', '%d bytes = %d banks of 16 KiB' % (len(rom), NB)),
        ('entry', '0100', hx(rom[0x100:0x104]), ''), ('logo_ok', '0104', '', str(rom[0x104:0x134] == bytes.fromhex(
            'CEED6666CC0D000B03730083000C000D0008111F8889000EDCCC6EE6DDDDD999BBBB67636E0EECCCDDDC999FBBB9333E'))),
        ('title', '0134', hx(rom[0x134:0x144]), rom[0x134:0x144].split(b'\0')[0].decode('ascii', 'replace')),
        ('cgb_flag', '0143', '%02X' % rom[0x143], ''), ('new_licensee', '0144', hx(rom[0x144:0x146]), rom[0x144:0x146].decode('ascii', 'replace')),
        ('sgb_flag', '0146', '%02X' % rom[0x146], 'SGB functions' if rom[0x146] == 3 else 'no SGB'),
        ('cart_type', '0147', '%02X' % rom[0x147], CART.get(rom[0x147], '?')), ('rom_size', '0148', '%02X' % rom[0x148], '%d KiB' % (32 << rom[0x148])),
        ('ram_size', '0149', '%02X' % rom[0x149], {0: 'none', 2: '8 KiB', 3: '32 KiB', 4: '128 KiB', 5: '64 KiB'}.get(rom[0x149], '?')),
        ('dest', '014A', '%02X' % rom[0x14A], 'Japan' if rom[0x14A] == 0 else 'overseas'), ('old_licensee', '014B', '%02X' % rom[0x14B], ''),
        ('version', '014C', '%02X' % rom[0x14C], ''),
        ('header_checksum', '014D', '%02X' % rom[0x14D], 'ok' if hc == rom[0x14D] else 'computed %02X' % hc),
        ('global_checksum', '014E', hx(rom[0x14E:0x150]), 'ok' if gc == (rom[0x14E] << 8 | rom[0x14F]) else 'computed %04X' % gc)]
with open(os.path.join(a.out, 'intake_header.csv'), 'w', newline='') as f:
    w = csv.writer(f); w.writerow(['field', 'offset', 'raw', 'value']); w.writerows(rows)

# --- per-bank comparison
def pad_bytes(b):
    n = i = 0
    while i < len(b):
        j = i
        while j < len(b) and b[j] == b[i]: j += 1
        if j - i >= 16 and b[i] in (0x00, 0xFF): n += j - i
        i = j
    return n
refs = []
for r in a.ref:
    name, path = r.split('=', 1); data = open(path, 'rb').read()
    idx = collections.defaultdict(collections.Counter)      # window -> Counter(bank)
    for i in range(len(data) - W + 1):
        win = data[i:i + W]
        if win.count(win[0]) == W: continue
        idx[win][i // 0x4000] += 1
    refs.append((name, data, idx))
out = []
for b in range(NB):
    bank = rom[b * 0x4000:(b + 1) * 0x4000]
    row = {'bank': '%02X' % b, 'pad': pad_bytes(bank)}
    for name, data, idx in refs:
        rb = data[b * 0x4000:(b + 1) * 0x4000]
        row['same_' + name] = sum(x == y for x, y in zip(bank, rb))
        cov = bytearray(0x4000); per = collections.Counter()
        for i in range(0x4000 - W + 1):
            win = bank[i:i + W]
            if win in idx:
                cov[i:i + W] = b'\1' * W
                for rbk in idx[win]: per[rbk] += 1
        row['shared_' + name] = sum(cov)
        if per:
            bb = per.most_common(1)[0][0]
            # bytes covered by windows that occur in that one bank
            c2 = bytearray(0x4000)
            for i in range(0x4000 - W + 1):
                win = bank[i:i + W]
                if win in idx and bb in idx[win]: c2[i:i + W] = b'\1' * W
            row['best_' + name] = '%02X:%d' % (bb, sum(c2))
        else: row['best_' + name] = '-'
    out.append(row)
cols = ['bank', 'pad'] + [p + n for n, _, _ in refs for p in ('same_', 'shared_', 'best_')]
# --exclusive A,B: bytes covered by windows found in reference A and not in B (and the reverse): what one sibling explains and the other does not
for pair in a.exclusive:
    x, y = pair.split(','); ix = {n: i for n, _, i in refs}
    for p, q in ((x, y), (y, x)):
        cov = bytearray(len(rom))
        for i in range(len(rom) - W + 1):
            win = rom[i:i + W]
            if win in ix[p] and win not in ix[q]: cov[i:i + W] = b'\1' * W
        c = 'only_%s_not_%s' % (p, q); cols.append(c)
        for b, row in enumerate(out): row[c] = sum(cov[b * 0x4000:(b + 1) * 0x4000])
with open(os.path.join(a.out, 'intake_banks.csv'), 'w', newline='') as f:
    w = csv.DictWriter(f, cols); w.writeheader(); w.writerows(out)

print('header: %s' % ' | '.join('%s=%s' % (r[0], r[3] or r[2]) for r in rows))
for name, _, _ in refs:
    print('vs %-6s same offset %7d  shared (16-byte windows anywhere) %7d  of %d bytes, padding %d' % (
        name, sum(r['same_' + name] for r in out), sum(r['shared_' + name] for r in out), len(rom), sum(r['pad'] for r in out)))
for c in cols:
    if c.startswith('only_'): print('%-22s %7d bytes' % (c, sum(r[c] for r in out)))

# --- no-symbol round trip
if not a.no_roundtrip:
    tmp = tempfile.mkdtemp(); base = os.path.join(tmp, 'rom.gb'); shutil.copy(a.rom, base)
    r = subprocess.run([sys.executable, a.mgbdis, '--output-dir', os.path.join(tmp, 'out'), base], capture_output=True, text=True)
    r2 = subprocess.run(['make'], cwd=os.path.join(tmp, 'out'), capture_output=True, text=True) if not r.returncode else r
    built = os.path.join(tmp, 'out', 'game.gb')
    md5 = hashlib.md5(open(built, 'rb').read()).hexdigest() if os.path.exists(built) else 'no ROM built'
    txt = 'mgbdis %s (no symbol file) + rgbasm %s: rebuilt md5 %s, original %s: %s\n' % (
        subprocess.run(['git', '-C', os.path.dirname(a.mgbdis), 'rev-parse', '--short', 'HEAD'], capture_output=True, text=True).stdout.strip() or '?',
        subprocess.run(['rgbasm', '--version'], capture_output=True, text=True).stdout.strip(), md5, hashlib.md5(rom).hexdigest(),
        'byte-exact' if md5 == hashlib.md5(rom).hexdigest() else 'DIFFERENT')
    if r2.returncode: txt += (r2.stderr or r2.stdout)[-1500:]
    open(os.path.join(a.out, 'intake_roundtrip.txt'), 'w').write(txt); print(txt.strip())
    shutil.rmtree(tmp)
