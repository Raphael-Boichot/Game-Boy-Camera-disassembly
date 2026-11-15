#!/usr/bin/env python3
"""Hello Kitty: BGB read watchpoints on the first byte of data blocks read only in forced runs (roadmap step 12, 2026-11-15).

  BGB_HF=-headless tools/kitty_bgb_reads.py KITTY.gb [--only NAME ...] [--work DIR]

The doubt "read only in forced runs" (disasm/sym_unconclusive_kitty.md) is settled when an organic run reads the block. The core
cannot play two linked units or a Super Game Boy, and BGB records no data reads by itself; a logging read watchpoint on the
block's first byte does (BB:AAAA//r/NAME, CLAUDE.md), one short run per scenario:
  sgb       power-on as a Super Game Boy (SystemMode=2) from a blank save: Sgb_VramTransferInline sends the border
  exchange  two linked units (tools/kitty_bgb_link.py, the key paths of SETUP.md 2026-11-08): the giver takes and keeps a photo, both
            open the exchange (mode $07), the giver sends it (modes $08 / $09), the receiver waits
  exchange_full the same exchange with a receiver whose album is full (30 photos, taken in the core): the link aborts with reason 2
            (00:1374: the partner's info has bit 6, album full) and the giver shows message 8 (06:43BC, Mode14_State01_Tbl43FF)
  print_game print a photo just taken with the printer helper on the link (tools/kitty_bgb_print.py, its default path), A pressed
            again and again during the fruit game shown while printing: the object script 02:7686 (PrintGame, 02:74C5)
  album_even the album photo view of photo 2 (an even number) from a save with two photos, A on it, A on the prompt: the text
            screen (mode $03 state $0A) loads the even-photo tiles and map (the core runs had opened only odd photos)
A range BB:AAAA-BB:EEEE watches every byte the reader is known to read: the 3 sound pairs (6 bytes) of a key-prompt record
(KeyPrompt_LoadSounds reads 3 x 2 bytes), the whole text of a message (Mode14_State01 reads it byte by byte up to its $FF, watched
alone as well). Every scenario has a CONTROL execution watchpoint on code it certainly runs, so 0 hits means "not read", not a broken watchpoint.
Writes roms/hello_kitty/trace/bgb_reads_kitty.csv (scenario, watchpoint, bank, addr, end, kind r / x, hits). tools/kitty_data_names.py
counts the bytes addr-end of a read row with hits as read in an organic run (their block becomes C). --only reruns some scenarios and keeps the others' rows.
"""
import argparse, collections, csv, os, shutil, subprocess, sys
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); KD = os.path.join(REPO, 'roms', 'hello_kitty')
sys.path.insert(0, os.path.join(HERE, 'jp')); sys.path.insert(0, os.path.join(REPO, 'coverage', 'src'))
ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('--only', nargs='*'); ap.add_argument('--work', default='/tmp/kitty_bgb_reads')
a = ap.parse_args(); os.makedirs(a.work, exist_ok=True)
OUT = os.path.join(KD, 'trace', 'bgb_reads_kitty.csv')
SC = {
    'sgb': ['08:6AE4//x/CONTROL_Sgb_VramTransferInline', '08:4247//r/R_08_4247', '08:6226//r/R_08_6226', '08:6A26//r/R_08_6A26'],
    'exchange': ['06:6256//x/CONTROL_Mode07_State02', '06:65B6//x/X_Mode08_State00', '06:6827//x/X_Mode09_State03', '06:6AD4//x/X_Mode09_State0C',
                 '06:5FF8//x/X_KeyPrompt_LoadSoundsB', '17:7000//r/R_17_7000', '1D:5600//r/R_1D_5600', '2C:7AB0//r/R_2C_7AB0', '32:7C80//r/R_32_7C80',
                 '02:47CC//r/R_02_47CC', '02:4810//r/R_02_4810', '03:6BEC//r/R_03_6BEC', '03:6C5C//r/R_03_6C5C', '03:6D34//r/R_03_6D34',
                 '0F:7A96//r/R_0F_7A96', '17:7800//r/R_17_7800', '06:5E8E-06:5E93//r/R_06_5E8E', '06:5F55-06:5F5A//r/R_06_5F55'],
    'exchange_full': ['06:6256//x/CONTROL_Mode07_State02', '00:1374//x/X_Link_AbortReason2', '06:43BC-06:43FE//r/R_06_43BC', '06:43FE//r/R_06_43FE_End'],
    'print_game': ['02:74B7//x/CONTROL_PrintGame_KeyCheck', '02:74C5//x/X_PrintGame_A', '02:7686//r/R_02_7686'],
    'album_even': ['05:65FD//x/CONTROL_Mode03_State0A', '05:662F//x/X_Mode03_State0A_EvenPhoto', '0D:6000//r/R_0D_6000', '23:5B50//r/R_23_5B50'],
}
def two_photo_save():
    import gbcov as G
    BIT = dict(A=1, B=2, Down=0x80)
    def cm(b): return ((b << 4) | (b >> 4)) & 0xFF
    def press(k, w): G.keys(cm(BIT[k])); G.run(8); G.keys(0); G.run(w)
    G.load_rom(a.rom); G.reset(bytes(0x20000)); G.run(600); s0 = bytes(G.sram())
    G.reset(s0); G.run(700); press('A', 150)
    for _ in range(2):
        for k in 'A A A B'.split(): press(k, 150)
    p = os.path.join(a.work, 'two_photos.sav'); open(p, 'wb').write(bytes(G.sram())[:0x20000]); return p
def full_album_save():
    import gbcov as G
    BIT = dict(A=1, B=2)
    def cm(b): return ((b << 4) | (b >> 4)) & 0xFF
    def press(k, w): G.keys(cm(BIT[k])); G.run(8); G.keys(0); G.run(w)
    G.load_rom(a.rom); G.reset(bytes(0x20000)); G.run(600); s0 = bytearray(bytes(G.sram())); s0[0x100A:0x100D] = b'\x99\x99\x99'
    G.reset(bytes(s0)); G.run(700); press('A', 150)
    for _ in range(32):                                          # 30 slots; the last two takes find the album full
        for k in 'A A A B'.split(): press(k, 150)
    s = bytes(G.sram())[:0x20000]
    if sum(b != 0xFF for b in s[0x11B2:0x11D0]) != 30: sys.exit('kitty_bgb_reads: the full-album save has not 30 photos')
    p = os.path.join(a.work, 'full_album.sav'); open(p, 'wb').write(s); return p
def count(log):
    return collections.Counter(l.strip() for l in open(log, errors='replace') if l.strip()) if os.path.exists(log) else collections.Counter()
def bgb_dir():
    d = os.path.join(a.work, 'bgb')
    if not os.path.isdir(d): shutil.copytree('/home/claude/bgbx', d)
    return d
res = {}
for name, wps in SC.items():
    if a.only and name not in a.only: continue
    print('kitty_bgb_reads: %s ...' % name, flush=True)
    if name in ('exchange', 'exchange_full'):
        wf = os.path.join(a.work, 'wp_%s.txt' % name); open(wf, 'w').write('\n'.join(wps) + '\n')
        out = os.path.join(a.work, name)
        r = subprocess.run([sys.executable, os.path.join(HERE, 'kitty_bgb_link.py'), a.rom, out, '--wp-file', wf, '--give', 'A A A A B Start Up A A - - - - - - A - - A - - A',
                            '--take', 'A Start Up A Right - - - - - - - - - A', '--frames-after', '2500'] + (['--save-take', full_album_save()] if name == 'exchange_full' else []),
                           capture_output=True, text=True, env=dict(os.environ, BGB_HF=os.environ.get('BGB_HF', '-headless')))
        c = collections.Counter()
        for role in ('giver', 'receiver'):
            p = os.path.join(out, 'hits_%s.csv' % role)
            if os.path.exists(p):
                for row in csv.DictReader(open(p)): c[row['name']] += int(row['hits'])
        res[name] = c
    elif name == 'print_game':
        out = os.path.join(a.work, 'print_game'); d = bgb_dir()
        r = subprocess.run([sys.executable, os.path.join(HERE, 'kitty_bgb_print.py'), a.rom, out, '--save', two_photo_save(), '--frames', '2400', '--port', '8797',
                            '--play', 'A:4,Left:12,A:4,Right:12'], capture_output=True, text=True,
                           env=dict(os.environ, BGB_WP=','.join(wps), KITTY_BGB_DIR=d, BGB_HF=os.environ.get('BGB_HF', '-headless')))
        res[name] = count(os.path.join(out, 'run_02400', 'debugmsg.txt'))
    else:
        import bgb_run
        d = bgb_dir(); os.environ['BGB_DIR'] = d; os.environ['BGB_WP'] = ','.join(wps); bgb_run.BGB = d
        if name == 'sgb':
            sav = os.path.join(a.work, 'blank.sav'); open(sav, 'wb').write(bytes(0x20000))
            bgb_run.run(a.rom, sav, os.path.join(a.work, 'sgb'), [('A', 8, 300)], free=900, extra=['-setting', 'SystemMode=2'], timeout=600)
        else:
            seq = [('A', 8, 200), ('Down', 8, 200), ('A', 8, 400), ('Down', 8, 200), ('Down', 8, 200), ('Down', 8, 200), ('A', 8, 300), ('A', 8, 300), ('A', 8, 400)]
            bgb_run.run(a.rom, two_photo_save(), os.path.join(a.work, 'album_even'), seq, free=500, timeout=600)
        res[name] = count(os.path.join(d, 'debugmsg.txt'))
    ctl = [w.split('/')[-1] for w in wps if w.split('/')[-1].startswith('CONTROL')]
    if not any(res[name][c] for c in ctl): sys.exit('kitty_bgb_reads: %s: the CONTROL watchpoint was not hit (BGB or the key path failed): nothing written' % name)
rows = [dict(r, end=r.get('end') or r['addr']) for r in csv.DictReader(open(OUT, encoding='utf-8'))] if os.path.exists(OUT) else []
rows = [r for r in rows if r['scenario'] not in res]
for name, c in res.items():
    for w in SC[name]:
        loc, _, kind, nm = w.split('/'); lo, hi = (loc.split('-') + [loc])[:2]; b, ad = lo.split(':'); en = hi.split(':')[1]
        rows.append(dict(scenario=name, watchpoint=nm, bank=b, addr=ad, end=en, kind=kind, hits=c[nm]))
rows.sort(key=lambda r: (list(SC).index(r['scenario']) if r['scenario'] in SC else 99, r['bank'], r['addr']))
with open(OUT, 'w', newline='', encoding='utf-8') as f:
    w = csv.DictWriter(f, ['scenario', 'watchpoint', 'bank', 'addr', 'end', 'kind', 'hits'], lineterminator='\n'); w.writeheader(); w.writerows(rows)
for r in rows: print('  %-13s %-36s %s:%s-%s %s %s' % (r['scenario'], r['watchpoint'], r['bank'], r['addr'], r['end'], r['kind'], r['hits']))
print('kitty_bgb_reads: %d watchpoints, %d hit -> %s' % (len(rows), sum(1 for r in rows if int(r['hits'])), os.path.relpath(OUT, REPO)))
