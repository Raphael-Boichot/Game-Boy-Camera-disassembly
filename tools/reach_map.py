#!/usr/bin/env python3
"""The reachability map of a ROM other than the Japanese one: the whole ROM drawn as 2bpp tiles, coloured by what its runs reached.

  tools/reach_map.py --tag us|gold|kitty|proto ROM.gb [OUT.png]     (default roms/<folder>/<tag>_rom_reachability_map.png)

The legend, the colours and the drawing are those of the Japanese map (tools/reach_draw.py; tcrf_check/tools/rom_reach_map.py), so a
colour means the same thing in every map. The inputs are the files of the ROM folder (HOWTO_NEW_ROM.md section 0.1); a category the ROM
has no evidence for stays empty:
  blue        executed or read in a run: every trace/cov_<tag>_*.npz (core runs, BGB runs, witness and key-path replays) and
              trace/wp_exec_<tag>.npz (blocks the BGB watchpoint runs executed); arrays exec / ex and dread / dr
  light blue  executed or read only in a forced run: trace/forced_*.npz
  GREEN       (ported builds) never run here but the same code as a Japanese routine that ran: class JP_EQUIV of port/never_run_<tag>.csv
  PURPLE      (ported builds) never run and proven dead, unused or unreachable: classes JP_DEAD, UNUSED and UNREACHABLE of
              port/never_run_<tag>.csv
  RED         proven code (class C of trace/rom_map_<tag>.csv) that no run executed and nothing above explains (a code byte that a
              run only read, never executed, is red too)
  YELLOW      asset data that no organic run read and that the ROM's never-reached table calls unused (assets/never_reached_<tag>.csv:
              ported builds, the rows found at the same address or moved; Hello Kitty, the verdicts `unused...`)
  ORANGE      data never read but explained by a type row of disasm/sym_types_<tag>.csv or an inline table of the trace (class T),
              or (Hello Kitty) by a `used...` verdict of assets/never_reached_kitty.csv (read in BGB or on a Super Game Boy, not in the runs)
  GREY-BLUE   data never read and explained by nothing yet
  muted red / beige  never-read runs of 16+ x $00 (padding) / $FF (fill)
Prints one line `<tag>_reach: blue N, red N, grey-blue N, orange N, padding N, fill N, light blue N, green N, purple N, yellow N bytes`
(the checker compares the counts that the ROM's README quotes).
"""
import argparse, csv, glob, os, sys
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); sys.path.insert(0, HERE)
import reach_draw as RD
ROMS = {'us': ('us_eu', 'Game Boy Camera (USA, Europe)'), 'gold': ('gold', 'Game Boy Camera Gold (USA)'),
        'kitty': ('hello_kitty', 'Pocket Camera (Hello Kitty) (prototype)'), 'proto': ('prototype_debagame', 'Pocket Camera Prototype (Japan) ("DEBAGAME")')}
RUNS = {'us': 'core runs of the international ROM (a fresh start, the unlocking saves) and its BGB witness scenarios',
        'gold': 'core runs of the Gold ROM (a fresh start, the unlocking saves, a third seed) and its BGB witness scenarios',
        'kitty': 'core runs with the unlocking save, the printer and the boot conditions; BGB watchpoint runs of the exchange; the BGB key paths of the album print, the printer errors and the Strawberry Channel without Kitts replayed in the core',
        'proto': 'the core runs of tools/proto_coverage.py on the image as dumped: blank SRAM and the owner\'s save'}
FORCED = {'kitty': 'a patched mode table for the ten modes no key path reaches, one sensor gate inverted, each picture effect forced; evidence I for any use'}
ap = argparse.ArgumentParser(); ap.add_argument('--tag', required=True, choices=sorted(ROMS)); ap.add_argument('rom'); ap.add_argument('out', nargs='?')
a = ap.parse_args(); T = a.tag; folder, title = ROMS[T]; D = os.path.join(REPO, 'roms', folder)
OUT = a.out or os.path.join(D, '%s_rom_reachability_map.png' % T)
rom = np.frombuffer(open(a.rom, 'rb').read(), np.uint8); N = len(rom)
def off(b, ad): return ad if b == 0 else b * 0x4000 + ad - 0x4000
def arr(z, *keys):
    for k in keys:
        if k in z.files: return z[k][:N] > 0
    return np.zeros(N, bool)
ex = np.zeros(N, bool); rd = np.zeros(N, bool)
for f in sorted(glob.glob(os.path.join(D, 'trace', 'cov_%s_*.npz' % T))) + sorted(glob.glob(os.path.join(D, 'trace', 'wp_exec_%s.npz' % T))):
    z = np.load(f); ex |= arr(z, 'ex'); rd |= arr(z, 'dr')
hit = ex | rd
forced = np.zeros(N, bool)
for f in sorted(glob.glob(os.path.join(D, 'trace', 'forced_*.npz'))):
    z = np.load(f); forced |= arr(z, 'ex') | arr(z, 'dr')
forced &= ~hit
code = np.zeros(N, bool); typed = np.zeros(N, bool)
for r in csv.DictReader(open(os.path.join(D, 'trace', 'rom_map_%s.csv' % T))):
    o = off(int(r['bank'], 16), int(r['start'], 16)); n = int(r['length'])
    if r['class'] == 'C': code[o:o + n] = True
    elif r['class'] == 'T': typed[o:o + n] = True
for r in csv.DictReader(open(os.path.join(D, 'disasm', 'sym_types_%s.csv' % T))):
    b = int(r['bank'], 16); typed[off(b, int(r['start'], 16)):off(b, int(r['end'], 16))] = True
green = np.zeros(N, bool); dead = np.zeros(N, bool)
nr = os.path.join(D, 'port', 'never_run_%s.csv' % T)
if os.path.exists(nr):
    for r in csv.DictReader(open(nr)):
        b = int(r['bank'], 16); o1, o2 = off(b, int(r['start'], 16)), off(b, int(r['end'], 16)) + 1
        if r['class'] == 'JP_EQUIV': green[o1:o2] = True
        elif r['class'] in ('JP_DEAD', 'UNUSED', 'UNREACHABLE'): dead[o1:o2] = True
unused = np.zeros(N, bool); used_x = np.zeros(N, bool)
nrc = os.path.join(D, 'assets', 'never_reached_%s.csv' % T)
if os.path.exists(nrc):
    for r in csv.DictReader(open(nrc, encoding='utf-8')):
        if '%s_status' % T in r:          # ported builds: a Japanese never-reached asset found here, never read organically
            if r['%s_status' % T] in ('same address', 'moved') and int(r['%s_bytes_read_organic' % T] or 0) == 0:
                b, ad = r['%s_addr' % T].split(':'); o = off(int(b, 16), int(ad, 16)); unused[o:o + int(r['bytes'])] = True
        elif r.get('verdict', '').startswith('unused'):
            b = int(r['bank'], 16); unused[off(b, int(r['start'], 16)):off(b, int(r['end'], 16))] = True
        elif r.get('verdict', '').startswith('used'):    # Hello Kitty: never read in the runs, shown used elsewhere (BGB, SGB): explained
            b = int(r['bank'], 16); used_x[off(b, int(r['start'], 16)):off(b, int(r['end'], 16))] = True
pad, fill = RD.runs16(rom)
cat = np.zeros(N, np.uint8)                                  # 0 blue
nh = ~hit
cat[nh & ~code & (typed | used_x)] = 4                        # orange
cat[nh & ~code & ~typed & ~used_x] = 9                                  # grey-blue
cat[nh & ~code & ~typed & ~used_x & pad] = 3; cat[nh & ~code & ~typed & ~used_x & fill] = 8
cat[nh & unused] = 7                                          # yellow
nx = ~ex & code                                               # proven code counts as reached only when executed (a read of code bytes is not a run)
cat[nx] = 2                                                   # red
cat[nx & green] = 5; cat[nx & dead] = 6                       # green / purple (ported builds)
cat[forced] = 1                                               # light blue: only in forced runs
n = lambda m: int(m.sum()); cnt = {c: n(cat == c) for c in range(10)}
pc = lambda v: '%s B, %.1f %%' % (format(v, ','), 100 * v / N)
c_code = n(code); c_ran = n(code & ex)
items = [(0, 'blue: executed or read in a run (%s)  (%s)' % (RUNS[T], pc(cnt[0])))]
if cnt[1] or T in FORCED: items.append((1, 'light blue: executed or read only in forced runs (%s)  (%s)' % (FORCED.get(T, 'state pokes'), pc(cnt[1]))))
if os.path.exists(nr):
    items.append((5, 'GREEN: code no run of this ROM executed, the same code as a Japanese routine that ran (credited by equivalence)  (%s)' % pc(cnt[5])))
    items.append((6, 'PURPLE: code that never ran and is proven dead or unused (as in the Japanese ROM, or unused here)  (%s)' % pc(cnt[6])))
items.append((2, 'RED: proven code that no run executed and nothing explains  (%s): %s of the %s bytes of proven code ran' % (pc(cnt[2]), format(c_ran, ','), format(c_code, ','))))
if os.path.exists(nrc): items.append((7, 'YELLOW: asset data that no organic run read and that %s calls unused  (%s)' % ('assets/never_reached_%s.csv' % T, pc(cnt[7]))))
items += [(4, 'ORANGE: data that no run read, explained by a loader site, a table length or an inline table of the trace  (%s)' % pc(cnt[4])),
          (9, 'GREY-BLUE: data that no run read and nothing explains yet (no loader, no table, still on the default typing)  (%s)' % pc(cnt[9])),
          (3, 'muted red: never-read runs of 16+ x $00, padding  (%s)' % pc(cnt[3])),
          (8, 'beige: never-read runs of 16+ x $FF, fill  (%s)' % pc(cnt[8]))]
note = ('Shade inside a colour = the tile pixel (2 bits), so graphics, text and code all stay visible. A 2-byte tile row takes the worst colour of its two bytes '
        '(red > purple > grey-blue > yellow > orange > fill > padding > green > light blue > blue).' + (' Light blue is not a way the game runs.' if T in FORCED else ''))
RD.draw(rom, cat, '%s: what the runs reached, the whole ROM drawn as 2bpp tiles, 64 banks of 16 KB' % title,
        'Each bank = 16 x 64 tiles = 16,384 bytes, banks $00..$3F left to right, top to bottom, 8 banks per row, in the colours of the Japanese reachability map (tools/reach_draw.py). Red and grey-blue are what is still missing.',
        items, note, OUT)
print('%s_reach: blue %d, red %d, grey-blue %d, orange %d, padding %d, fill %d, light blue %d, green %d, purple %d, yellow %d bytes'
      % (T, cnt[0], cnt[2], cnt[9], cnt[4], cnt[3], cnt[8], cnt[1], cnt[5], cnt[6], cnt[7]))
per_bank = [(b, n(cat[b * 0x4000:(b + 1) * 0x4000] == 2), n(cat[b * 0x4000:(b + 1) * 0x4000] == 9)) for b in range(N // 0x4000)]
print('most red (code never run):', ', '.join('$%02X %d' % (b, r) for b, r, _ in sorted(per_bank, key=lambda x: -x[1])[:8]))
print('most grey-blue (data unexplained):', ', '.join('$%02X %d' % (b, g) for b, _, g in sorted(per_bank, key=lambda x: -x[2])[:8]))
