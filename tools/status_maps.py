#!/usr/bin/env python3
"""Draw the layout picture of each ROM whose work is not done by the port pipeline, so that its progress shows in the README.

  tools/status_maps.py [--gold GOLD.gb] [--kitty KITTY.gb] [--proto PROTO.gb] [--out-dir DIR]

Each ROM given is drawn by tcrf_check/tools/rom_layout_map.py into roms/<folder>/<prefix>_rom_layout_map.png (and
roms/<folder>/assets/layout_by_bank_<prefix>.csv), with --unclaimed: every byte that no label owns and no trace runs is
NOT ANALYSED YET (grey-blue), padding (runs of 16+ x 00 / FF) is shown as padding. The inputs are read when they exist, so the
picture fills in by itself as the work lands, with no change to this script:
  roms/<folder>/disasm/sym_names_<prefix>.csv (and _hand), roms/<folder>/disasm/sym_types_<prefix>.csv  names and type rows
  roms/<folder>/port/rom_map_<prefix>.csv                                                              byte classes of a trace
  roms/<folder>/port/diff_<prefix>.npz                                                                 outline: what differs from JP
The Japanese picture (roms/jp_rev_a/jp_rom_layout_map.png) and the international one (roms/us_eu/us_rom_layout_map.png) are drawn by
their own pipelines (tcrf_check/tools/rom_layout_map.py defaults; tools/port_build.py).
"""
import argparse, os, subprocess, sys
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
ROMS = {   # option: (folder, prefix, title, md5)
    'gold':  ('gold', 'gold', 'Game Boy Camera Gold (USA)', 'b2999cfb6dacb439f501a71f30f91762'),
    'kitty': ('hello_kitty', 'kitty', 'Pocket Camera (Hello Kitty) (prototype)', '0a323bddc4f0159cea76cf44ed0c1a3c'),
    'proto': ('prototype_debagame', 'proto', 'Pocket Camera Prototype (Japan) ("DEBAGAME")', '1d8097de3497db8b182bcd2a984b6063'),
}
ap = argparse.ArgumentParser()
for k in ROMS: ap.add_argument('--' + k)
ap.add_argument('--out-dir', default=None, help='write the pictures and csv files here instead of roms/<folder>/ (the checker compares them)')
a = ap.parse_args()
import hashlib
for k, (folder, pre, title, md5) in ROMS.items():
    rom = getattr(a, k)
    if not rom: continue
    if hashlib.md5(open(rom, 'rb').read()).hexdigest() != md5: sys.exit('%s: md5 is not %s' % (rom, md5))
    D = os.path.join(REPO, 'roms', folder); E = lambda *p: os.path.join(D, *p)
    names = [f for f in (E('disasm', 'sym_names_%s.csv' % pre), E('disasm', 'sym_names_%s_hand.csv' % pre)) if os.path.exists(f)]
    types = [f for f in (E('disasm', 'sym_types_%s.csv' % pre),) if os.path.exists(f)]
    rmap = E('port', 'rom_map_%s.csv' % pre); diff = E('port', 'diff_%s.npz' % pre)
    started = bool(names or os.path.exists(rmap))
    out = a.out_dir or D; os.makedirs(os.path.join(out, 'assets') if not a.out_dir else out, exist_ok=True)
    png = os.path.join(out, '%s_rom_layout_map.png' % pre); csv_ = os.path.join(out, 'assets', 'layout_by_bank_%s.csv' % pre) if not a.out_dir else os.path.join(out, 'layout_by_bank_%s.csv' % pre)
    cmd = [sys.executable, os.path.join(REPO, 'tcrf_check', 'tools', 'rom_layout_map.py'), png, '--rom', rom, '--map', rmap if os.path.exists(rmap) else 'none',
           '--assets', 'none', '--witness', 'none', '--reach', 'none', '--unused', 'none', '--kinds', 'none', '--unclaimed',
           '--names', ','.join(names) or 'none', '--types', ','.join(types) or 'none', '--csv', csv_,
           '--title', '%s: what is in each of the 64 banks (the ROM drawn as 2bpp tiles)%s' % (title, '' if started else ': NOT STARTED YET'),
           '--note1', 'Each bank = 32 x 32 tiles = 16,384 bytes, banks $00..$3F left to right, top to bottom, in the colours of the Japanese map. The shade inside a colour is the tile pixel (2 bits).',
           '--note2', ('Grey-blue: bytes that no name, type row or trace of this ROM explains yet. ' if True else '') +
                      ('Nothing is analysed for this ROM so far: only the padding is shown; the picture fills in as the work lands (roms/%s/).' % folder if not started else
                       'Names and types: roms/%s/disasm/; the code colour is what the trace of this ROM proves.' % folder)]
    if os.path.exists(diff): cmd += ['--diff', diff]
    else: cmd += ['--outline', 'none']
    r = subprocess.run(cmd, capture_output=True, text=True, cwd=REPO)
    if r.returncode: sys.exit('%s: %s' % (k, (r.stderr or r.stdout)[-800:]))
    tot = [l for l in r.stdout.splitlines() if l.startswith(('NONE', 'PAD'))]
    print('%-6s -> %s   %s' % (k, os.path.relpath(png, REPO), ' | '.join(' '.join(t.split()[:3]) for t in tot)))
