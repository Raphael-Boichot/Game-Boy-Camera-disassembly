#!/usr/bin/env python3
"""The SRAM map files of a ROM (HOWTO_NEW_ROM.md section 0.1, rule 5): check the Japanese map, carry it to the ported builds.

  tools/sram_map.py --tag jp|us|gold|proto [--check]

proto roms/prototype_debagame/sram/sram_map_proto.csv is a hand table of its own (2026-11-12): checked and indexed as the Japanese one.

jp    roms/jp_rev_a/sram/sram_map_jp.csv is the hand table (transcribed from docs §3 on 2026-11-09; edit it with the notes). The script
      checks it (no two rows overlap; every SRAM access site of roms/jp_rev_a/sram/sram_access_jp.csv whose RAM bank is known falls
      inside a row, slots 2-30 read through the layout of slot 1) and writes roms/jp_rev_a/sram/INDEX.md.
us, gold  writes roms/<folder>/sram/sram_map_<tag>.csv: the Japanese rows, with each routine of the `routines` column at its address in
      this build (looked up by name in disasm/sym_names_<tag>.csv), and roms/<folder>/sram/INDEX.md. The layout is carried only when
      every SRAM access site of this build (sram/sram_access_<tag>.csv) pairs, through port/code_map_<tag>.csv, with a Japanese site of
      the same kind at the same SRAM address; otherwise the script stops and lists the sites that differ.
The access tables are written by tools/sram_db.py. --check compares the files with a fresh run and exits 1 when one differs.
"""
import argparse, collections, csv, io, os, re, sys
FOLDER = {'jp': 'jp_rev_a', 'us': 'us_eu', 'gold': 'gold', 'proto': 'prototype_debagame'}
TITLE = {'jp': 'Pocket Camera (Japan) (Rev A)', 'us': 'Game Boy Camera (USA, Europe)', 'gold': 'Game Boy Camera Gold (USA)', 'proto': 'Pocket Camera Prototype (Japan) ("DEBAGAME")'}
OWN = ('jp', 'proto')        # the ROMs whose map is a hand table of their own (the prototype's layout is not the Japanese one, 2026-11-12)
ap = argparse.ArgumentParser(); ap.add_argument('--tag', required=True, choices=sorted(FOLDER)); ap.add_argument('--check', action='store_true')
a = ap.parse_args(); T = a.tag; D = os.path.join('roms', FOLDER[T]); SD = os.path.join(D, 'sram')
JM = os.path.join(SD, 'sram_map_%s.csv' % T) if T in OWN else os.path.join('roms', 'jp_rev_a', 'sram', 'sram_map_jp.csv')
rows = list(csv.DictReader(open(JM, encoding='utf-8'))); COLS = list(rows[0].keys())
acc = list(csv.DictReader(open(os.path.join(SD, 'sram_access_%s.csv' % T))))
out = {}; fail = []
span = sorted((int(r['flat_start'], 16), int(r['flat_end'], 16)) for r in rows)
fail += ['rows overlap at %05X' % b[0] for a_, b in zip(span, span[1:]) if b[0] <= a_[1]]
def inside(f):
    if T == 'jp' and 0x2000 <= f < 0x20000 and not any(s <= f <= e for s, e in span): f = 0x2000 + (f - 0x2000) % 0x1000
    return any(s <= f <= e for s, e in span)
known = [r for r in acc if r['flat'] not in ('', 'sensor')]
fail += ['site %s:%s (%s) at flat %s is outside every row' % (r['bank'], r['pc'], r['function'], r['flat']) for r in known if not inside(int(r['flat'], 16))]
pairs = None
if T not in OWN:
    cm = {(r['bank'].lower(), r['other'].lower()): r['jp'].lower() for r in csv.DictReader(open(os.path.join(D, 'port', 'code_map_%s.csv' % T)))}
    J = {(r['bank'], r['pc']): r for r in csv.DictReader(open(os.path.join('roms', 'jp_rev_a', 'sram', 'sram_access_jp.csv')))}
    same = 0
    for r in acc:
        jp = cm.get((r['bank'], r['pc'])); j = J.get((r['bank'], jp)) if jp else None
        if j and j['addr'] == r['addr'] and j['kind'] == r['kind']: same += 1
        else: fail.append('site %s:%s (%s, %s $%s) has no Japanese site of the same kind at the same address' % (r['bank'], r['pc'], r['function'], r['kind'], r['addr']))
    pairs = same
    names = {}
    for r in csv.DictReader(open(os.path.join(D, 'disasm', 'sym_names_%s.csv' % T), encoding='utf-8')): names.setdefault(r['name'], (int(r['bank'], 16), int(r['addr'], 16)))
    def here(m):
        nm = m.group(2)
        if nm in names: return '%s%s (%02X:%04X)' % (m.group(1) or '', nm, *names[nm])
        fail.append('routine %s of the Japanese map has no label in sym_names_%s.csv' % (nm, T)); return m.group(0)
    new = [dict(r, routines=re.sub(r'(in )?(\w+) \([0-9A-F]{2}:[0-9A-F]{4}\)', here, r['routines'])) for r in rows]
    s = io.StringIO(); w = csv.DictWriter(s, COLS, lineterminator='\n'); w.writeheader(); w.writerows(new)
    out[os.path.join(SD, 'sram_map_%s.csv' % T)] = s.getvalue()
if fail: sys.exit('sram_map %s: %d problems:\n  ' % (T, len(fail)) + '\n  '.join(fail[:20]))
k = collections.Counter(r['kind'] for r in acc); kb = len(known); se = sum(1 for r in acc if r['flat'] == 'sensor')
md = ['# sram/ - cartridge RAM of %s' % TITLE[T], '',
      'The 128 KB cartridge RAM (RAM banks $00-$0F at `$A000-$BFFF`; flat offset = bank x $2000 + (address - $A000)). RAM bank $10 is the sensor register window, not memory (docs §18).', '',
      '| File | Content |', '|---|---|']
if T == 'proto':
    md += ['| `sram_map_proto.csv` | the map, one row per block (%d rows): flat range, RAM bank and CPU range, block, field, tag, routines, note. The hand table (2026-11-12, roadmap step 7), from the access sites and the README (the tester: AGING, PROTECT, GALLERY); the layout is this build\'s own, not the Japanese one |' % len(rows)]
elif T == 'jp':
    md += ['| `sram_map_jp.csv` | the map, one row per block or field (%d rows): flat range, RAM bank and CPU range, block, field, tag C / I / B / F / N / ?, the routines that write or read it, note. The hand table: transcribed from docs §3 (2026-11-09), which keeps the full text, the save evidence (docs §11) and the checksum rules; edit both together |' % len(rows)]
else:
    md += ['| `sram_map_%s.csv` | the map of the Japanese ROM (`roms/jp_rev_a/sram/sram_map_jp.csv`, docs §3), with each routine at its address in this build; written by `tools/sram_map.py --tag %s`, never edit it |' % (T, T)]
md += ['| `sram_access_%s.csv` | every proven instruction whose operand is an SRAM address: kind (R read, W write, P pointer load), bank, pc, routine, the RAM bank when the straight-line code before it selects a constant one, the flat offset (`tools/sram_db.py`) |' % T, '',
       'Access sites: %d (P %d, R %d, W %d); RAM bank known statically for %d (%d of them the sensor window; the %d others all fall inside a row of the map). '
       % (len(acc), k['P'], k['R'], k['W'], kb + se, se, kb) +
       ('The bank of the other sites comes from a register argument or a caller (the storage manager of bank 2 selects it before the copies; docs §3.5).' if T != 'proto' else 'The bank of the other sites comes from a register or a caller: the image-copy modes, PICT_SAVE_GO and MAKE_GALLERY (the photo number), the tests (a loop over the 16 banks).')]
if T not in OWN:
    md += ['', 'Same layout as the Japanese ROM (C, static): each of the %d access sites of this build pairs, through `port/code_map_%s.csv`, with a Japanese site of the same kind at the same SRAM address, and no site is new. ' % (pairs, T) +
           ('The one routine of the Gold edition that differs, `Photo_RenumberVector` (02:4466), repairs the state vector it reads: the layout is the same, the rule for a damaged vector is not (docs §16.34).' if T == 'gold' else
            'What differs is content, not layout: the owner name and the comments are codes of the international character set (`disasm/charset_us.csv`), and the English owner card has no blood-type field (`Unused_OwnerCard_DrawBloodType` is dead code, docs §1.5).')]
out[os.path.join(SD, 'INDEX.md')] = '\n'.join(md) + '\n'
bad = 0
for f, t in out.items():
    if a.check:
        if not os.path.exists(f) or open(f, encoding='utf-8').read() != t: print('stale: %s (rerun tools/sram_map.py --tag %s)' % (f, T)); bad = 1
    else: open(f, 'w', encoding='utf-8').write(t)
print('sram_map %s: %d rows, %d access sites, %d with a known bank inside the map%s%s' % (T, len(rows), len(acc), kb, '' if pairs is None else ', %d paired with the Japanese sites' % pairs, ' (check)' if a.check else ''))
sys.exit(bad)
