#!/usr/bin/env python3
"""Replay core coverage runs of the early prototype in BGB (the judge) and check each GAME_SEQ value there.

  tools/proto_bgb_replay.py PROTO_BGB.gb COV_DIR [COV_DIR ...] --out OUT_DIR [--save NAME=SAVE.sav ...] [--csv roms/prototype_debagame/trace/bgb_game_seq_proto.csv]

PROTO_BGB.gb is the header-patched BGB copy (md5 1d8097de3497db8b182bcd2a984b6063; owner's rule 2026-11-08: BGB only, BGB
refuses the image as dumped). COV_DIR is an output folder of tools/proto_coverage.py (modes.csv); its start save is given by --save
DIRNAME=FILE (default: 128 KiB of $00, written to OUT_DIR). For every GAME_SEQ value ($C0A0) the key history that first reached it
in the core is replayed: that history (from a cold boot, direction keys in the low nibble) becomes a BGB demo
(nibbles swapped, 3 more boot frames: BGB needs them, CLAUDE.md), followed by 60 free frames. BGB writes its end state and the
screen; the row records GAME_SEQ read from BGB's WRAM, the bank register, and whether it equals the value the core reached.
The history ends right after the input that reached the value, and BGB runs 60 more frames: a value that the game leaves by itself
within 60 frames gives `no` without any disagreement between the emulators (the timing differs by a few frames).
Writes OUT_DIR/<dir>_seq_XX.png (160 x 144, BGB) and the CSV (dir, game_seq, frames, bgb_game_seq, bgb_rombank, match).
--sheet DIR=PNG draws the screenshots of one run folder as a captioned sheet (5 columns, 1x). Only a run from blank SRAM goes into
the repository: a run from a real save can show its photos (CLAUDE.md).
"""
import sys, os, json, csv, argparse, subprocess, hashlib
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, os.path.join(HERE, '..', 'tools', 'jp'))
import bgb_run as B
from PIL import Image
ap = argparse.ArgumentParser()
ap.add_argument('rom'); ap.add_argument('dirs', nargs='+'); ap.add_argument('--out', required=True)
ap.add_argument('--save', action='append', default=[]); ap.add_argument('--csv', default=None); ap.add_argument('--sheet', default=None)
a = ap.parse_args(); os.makedirs(a.out, exist_ok=True)
if hashlib.md5(open(a.rom, 'rb').read()).hexdigest() != '1d8097de3497db8b182bcd2a984b6063': sys.exit('proto_bgb_replay: expected the BGB copy (md5 1d8097de...)')
saves = dict(s.split('=', 1) for s in a.save)
blank = os.path.join(a.out, 'blank.sav'); open(blank, 'wb').write(bytes(0x20000))
def swap(k): return ((k & 0x0F) << 4) | (k >> 4)
def bgb(prefix, keys, sav):
    dem, sna, bmp = prefix + '.dem', prefix + '.sna', prefix + '.bmp'
    open(dem, 'wb').write(bytes(3) + bytes(swap(k) for k in keys) + bytes(60))
    sv = prefix + '.sav'; open(sv, 'wb').write(open(sav, 'rb').read())
    for f in (sna, bmp):
        if os.path.exists(f): os.remove(f)
    cmd = ['xvfb-run', '-a', 'wine', os.path.join(B.BGB, 'bgb.exe'), os.environ.get('BGB_HF', '-hf'), '-nowarn', '-nowriteini', '-nobattsave',
           '-ini', os.path.join(B.BGB, 'bgb.ini'), '-rom', os.path.abspath(a.rom), '-demoplay', os.path.abspath(dem),
           '-stateonexit', os.path.abspath(sna), '-screenonexit', os.path.abspath(bmp), '-loadbatt', os.path.abspath(sv)]
    subprocess.run(cmd, env=dict(os.environ, WINEDEBUG='-all', WINEPREFIX='/root/wineprefix'), capture_output=True, timeout=900)
    return (B.read_state(sna) if os.path.exists(sna) else {}), bmp
rows = []
for d in a.dirs:
    name = os.path.basename(d.rstrip('/')); sav = saves.get(name, blank)
    for r in csv.DictReader(open(os.path.join(d, 'modes.csv'))):
        seq = int(r['game_seq'], 16); keys = bytes.fromhex(r['keys'])
        prefix = os.path.join(a.out, '%s_seq_%02X' % (name, seq))
        st, bmp = bgb(prefix, keys, sav)
        g = st['WRAM'][0xA0] if 'WRAM' in st else None
        rb = st['ROMB'][0] if 'ROMB' in st else None
        if os.path.exists(bmp): Image.open(bmp).save(prefix + '.png')
        rows.append({'dir': name, 'game_seq': '%02X' % seq, 'frames': len(keys), 'bgb_game_seq': '' if g is None else '%02X' % g,
                     'bgb_rombank': '' if rb is None else '%02X' % rb, 'match': 'yes' if g == seq else 'no'})
        print(rows[-1], flush=True)
if a.csv:
    with open(a.csv, 'w', newline='') as f:
        w = csv.DictWriter(f, ['dir', 'game_seq', 'frames', 'bgb_game_seq', 'bgb_rombank', 'match'], lineterminator='\n'); w.writeheader(); w.writerows(rows)
if a.sheet:
    from PIL import ImageDraw
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__))); import gb_palette
    dname, png = a.sheet.split('=', 1)
    shots = [(r['game_seq'], os.path.join(a.out, '%s_seq_%s.png' % (dname, r['game_seq']))) for r in rows if r['dir'] == dname]
    shots = [(s_, p_) for s_, p_ in shots if os.path.exists(p_)]
    W, H, cols, pad = 160, 144, 5, 18
    sheet = Image.new('RGB', (cols * (W + 8) + 8, ((len(shots) + cols - 1) // cols) * (H + pad + 8) + 8), 'white'); d = ImageDraw.Draw(sheet)
    for i, (s_, p_) in enumerate(shots):
        x = 8 + (i % cols) * (W + 8); y = 8 + (i // cols) * (H + pad + 8)
        d.text((x, y), 'GAME_SEQ $' + s_, fill='black'); sheet.paste(gb_palette.gray(Image.open(p_)), (x, y + pad))     # BGB greens -> the project's greys
    sheet.save(png)
