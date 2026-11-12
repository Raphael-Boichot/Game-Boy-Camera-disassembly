#!/usr/bin/env python3
"""The unused bytes of each ROM in two categories (owner 2026-11-12): documented by TCRF, or not documented by TCRF.

  tools/unused_table.py [--tag jp|us|gold|kitty|proto ...] [--check]

Writes roms/<folder>/assets/unused_<tag>.csv: one row per label that names bytes this build never uses, with its span (to the next
label of the bank, as tcrf_check/tools/rom_layout_map.py counts it), its kind (code: proven instructions, else data) and its category:
  tcrf       the content is documented on a TCRF page: the row of tcrf_check/tcrf_documented.csv whose pattern matches the name gives
             the page and its section (TCRF is credited only there: the repository holds no copy of TCRF's pages or pictures, only links)
  not_tcrf   unused in this build and not documented by TCRF: found by this project
Unused = the name says so: `Unused_*` (code or data this build never runs or reads, docs §16.24), `Leftover_*` (Hello Kitty and the
prototype: bytes nothing in the build reads, owner rule 2026-11-11), the names a TCRF row matches (they are unused by that row), and for
the Japanese ROM the really unused assets of docs §16.24 (tcrf_check/assets/unidentified/really_unused.csv, tiers 'no loader', 'never
shown', 'forced only': the red outline of its layout picture).
A copy or part of a TCRF-documented block is tcrf; a variant (`_Variant`: an edited version, not the content TCRF shows) is not_tcrf.
tcrf_check/tools/rom_layout_map.py reads the table and outlines both categories on the layout picture of the ROM.
"""
import argparse, csv, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
ROMS = {'jp': 'jp_rev_a', 'us': 'us_eu', 'gold': 'gold', 'kitty': 'hello_kitty', 'proto': 'prototype_debagame'}
ap = argparse.ArgumentParser(); ap.add_argument('--tag', nargs='*', default=list(ROMS)); ap.add_argument('--check', action='store_true'); a = ap.parse_args()
DOC = list(csv.DictReader(open(os.path.join(REPO, 'tcrf_check', 'tcrf_documented.csv'), encoding='utf-8')))
def fl(b, ad): return ad if b == 0 else b * 0x4000 + ad - 0x4000
bad = 0
for tag in a.tag:
    D = os.path.join(REPO, 'roms', ROMS[tag])
    rows = [r for r in csv.DictReader(open(os.path.join(D, 'disasm', 'sym_names_%s.csv' % tag), encoding='utf-8')) if r['name'] not in ('', '-')]
    labs = sorted((fl(int(r['bank'], 16), int(r['addr'], 16)), int(r['bank'], 16), int(r['addr'], 16), r['name']) for r in rows)
    code = set()
    rm = os.path.join(D, 'trace', 'rom_map_%s.csv' % tag)
    if os.path.exists(rm):
        for r in csv.DictReader(open(rm)):
            if r['class'] == 'C': code.add(fl(int(r['bank'], 16), int(r['start'], 16)))
    docs = [d for d in DOC if tag in d['roms'].split()]
    really = set()
    if tag == 'jp':
        for r in csv.DictReader(open(os.path.join(REPO, 'tcrf_check', 'assets', 'unidentified', 'really_unused.csv'), encoding='utf-8')):
            if r['tier'] in ('no loader', 'never shown', 'forced only'): really.add(r['name'])
    out = []
    for i, (o, b, ad, nm) in enumerate(labs):
        hit = next((d for d in docs if re.search(d['pattern'], nm)), None)
        if not (nm.startswith(('Unused_', 'Leftover_')) or hit or nm in really): continue
        nb = labs[i + 1] if i + 1 < len(labs) else None
        end = nb[0] if nb and nb[1] == b and (b != 0 or nb[0] < 0x4000) else fl(b, 0x8000 if b else 0x4000)
        if nb and nb[0] >> 14 != o >> 14: end = (o >> 14 << 14) + 0x4000
        out.append(['%02X' % b, '%04X' % ad, '%04X' % (ad + end - o), end - o, nm, 'code' if o in code else 'data',
                    'tcrf' if hit else 'not_tcrf', hit['page'] if hit else '', hit['section'] if hit else '', hit['what'] if hit else ''])
    path = os.path.join(D, 'assets', 'unused_%s.csv' % tag)
    txt = 'bank,addr,end,bytes,name,kind,category,tcrf_page,tcrf_section,tcrf_what\n'
    import io; buf = io.StringIO(); csv.writer(buf, lineterminator='\n').writerows(out); txt += buf.getvalue()
    t_ = sum(r[3] for r in out if r[6] == 'tcrf'); n_ = sum(r[3] for r in out if r[6] == 'not_tcrf')
    msg = 'unused %s: %d labels; documented by TCRF %d labels, %d bytes; not documented by TCRF %d labels, %d bytes' % (
        tag, len(out), sum(1 for r in out if r[6] == 'tcrf'), t_, sum(1 for r in out if r[6] == 'not_tcrf'), n_)
    if a.check:
        if not os.path.exists(path) or open(path, encoding='utf-8').read() != txt: print('differs: %s (rerun tools/unused_table.py)' % path); bad += 1
        else: print(msg + ' (check)')
    else:
        with open(path, 'w', encoding='utf-8', newline='') as f: f.write(txt)
        print(msg)
sys.exit(1 if bad else 0)
