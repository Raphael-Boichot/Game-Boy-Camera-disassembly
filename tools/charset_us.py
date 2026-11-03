#!/usr/bin/env python3
"""Character table of the international (and Gold) name / comment fields (L6 text table; the Japanese one is roms/jp_rev_a/disasm/charset_jp.csv, README 16.27).

  tools/charset_us.py JP.gb ROM.gb OUT.csv [--check]

The glyph of code c is the 8 x 16 pair of 2bpp tiles at 2A:4000 + (c-1) x 32 in every build (Glyph_LoadFromCharCode, international 09:4806; the
keyboard lists of Kb_LoadGlyphList hold slot = code - 1).  A code whose glyph bytes equal a Japanese glyph takes that glyph's character (C, the
bytes; where two Japanese codes share one glyph, O / 0 and the long-vowel mark / hyphen, the place in the run decides); the 33 glyphs that are not
in the Japanese font (the accented capitals and small letters, ß, &, a third face icon) were read by eye from tcrf_check/assets/l3_by_eye/font_2A_4000_intl.png
(C, by eye).  Codes typed by the international keyboard (lists A and B, 09:54C6 / 54DE) keep the plain character; a second code with the same
glyph gets a tag in angle brackets (`<jp_a>`: the Japanese Latin block $C9-$F5 and two marks of the kana block kept unchanged, `<blank_A5>`; the keyboard's codes first, then the international block $56-$C8), since a charmap entry is one string.
The comment editor types from a grid of 5 per row over the codes $56-$C8 (CommentEditor_ReadDirections 09:44F9 keeps the cell in $55-$C7, CommentEditor_CtrlGrid 09:43F7 stores cell + 1).
Columns: code, char, class, glyph_rom, keyboard (A / B: on that list of the name keyboard), comment_grid (yes: typeable in a comment), jp_glyph (the Japanese code with the same glyph bytes), evidence."""
import sys, csv, os
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
def flat(b, a): return b * 0x4000 + a - 0x4000
BY_EYE = {0x74: 'Á', 0x75: 'Â', 0x76: 'À', 0x77: 'Ä', 0x78: 'É', 0x79: 'Ê', 0x7A: 'È', 0x7B: 'Ë', 0x7C: 'Í', 0x7D: 'Ï', 0x7E: 'Ó', 0x7F: 'Ö', 0x80: 'Ú', 0x81: 'Ü', 0x82: 'Ñ',
          0x84: '&', 0xA6: 'á', 0xA7: 'â', 0xA8: 'à', 0xA9: 'ä', 0xAA: 'é', 0xAB: 'ê', 0xAC: 'è', 0xAD: 'ë', 0xAE: 'í', 0xAF: 'ï', 0xB0: 'ó', 0xB1: 'ö', 0xB2: 'ú',
          0xB3: 'ü', 0xB4: 'ñ', 0xB5: 'ç', 0xB6: 'ß', 0xB8: '[face3]'}
SHARED = {0x64: 0xB9, 0xBA: 0xE7, 0x83: 0xE6, 0xE6: 0xE6, 0xE7: 0xE7}     # O vs 0, ー vs -: the Japanese code whose character the place in the run gives
# the keyboard lists of this build (Kb_GlyphListA / B, pairs {n, slot}, slot = code - 1): read from the ROM below
def lists(R):
    out = {}
    for name, a in (('A', 0x54C6), ('B', 0x54DE)):
        o = flat(9, a)
        while R[o]:
            n, s = R[o], R[o + 1]; o += 2
            if s == 0xFF: continue
            for k in ([s] if n & 0x80 else range(s, s + n)): out.setdefault(k + 1, name)
    return out
def klass(c, ch):
    if c <= 0x55: return 'hiragana (Japanese, kept)'
    if ch.startswith('<jp_'): return 'Japanese Latin block (kept)'
    if ch.startswith('['): return 'icon'
    if len(ch) == 1 and ch.isdigit(): return 'digit'
    if len(ch) == 1 and ch.isalpha() and ch.isascii(): return 'latin upper' if ch.isupper() else 'latin lower'
    if len(ch) == 1 and ch.isalpha(): return 'latin upper accented' if ch.isupper() else 'latin lower accented'
    return 'blank' if ch in (' ', '<blank_A5>') else 'punctuation / symbol'
def build(J, R):
    js = {int(r['code'], 16): r for r in csv.DictReader(open(os.path.join(ROOT, 'roms', 'jp_rev_a', 'disasm', 'charset_jp.csv'), encoding='utf-8'))}
    g = lambda X, c: X[flat(0x2A, 0x4000) + (c - 1) * 32: flat(0x2A, 0x4000) + c * 32]
    jg = {}
    for c in sorted(js): jg.setdefault(g(J, c), []).append(c)
    kb = lists(R); rows = []; used = set()
    order = sorted(range(1, 0xF6), key=lambda c: (c not in kb, not 0x56 <= c <= 0xC8, c))      # the keyboard's codes take the plain character first, then the international block $56-$C8
    for c in order:
        m = jg.get(g(R, c), [])
        if c in BY_EYE: ch, jc, ev = BY_EYE[c], '', 'C, by eye (not in the Japanese font)'
        elif m:
            jc = SHARED.get(c, m[0]) if len(m) > 1 else m[0]; ch = js[jc]['char']
            ev = 'C, the glyph bytes equal the Japanese glyph $%02X' % jc + (' (the same glyph serves %s; the place in the run decides)' % ' / '.join(js[k]['char'] for k in m) if len(m) > 1 else '')
        else: sys.exit('charset_us: code $%02X has no reading' % c)
        if ch in used:
            ch = '<blank_%02X>' % c if ch == ' ' else '<jp_%s>' % ch
        used.add(ch)
        rows.append(dict(code='%02X' % c, char=ch, cls=klass(c, ch), glyph_rom='2A:%04X' % (0x4000 + (c - 1) * 32), keyboard=kb.get(c, ''), comment='yes' if 0x56 <= c <= 0xC8 else '', jp_glyph=('%02X' % jc) if jc else '', evidence=ev))
    return sorted(rows, key=lambda r: r['code'])
if __name__ == '__main__':
    a = [x for x in sys.argv[1:] if not x.startswith('--')]; J, R = open(a[0], 'rb').read(), open(a[1], 'rb').read()
    rows = build(J, R)
    lines = ['code,char,class,glyph_rom,keyboard,comment_grid,jp_glyph,evidence']
    import io; buf = io.StringIO(); w = csv.writer(buf, lineterminator='\n'); w.writerow(lines[0].split(','))
    for r in rows: w.writerow([r['code'], r['char'], r['cls'], r['glyph_rom'], r['keyboard'], r['comment'], r['jp_glyph'], r['evidence']])
    t = buf.getvalue()
    if '--check' in sys.argv: sys.exit(0 if os.path.exists(a[2]) and open(a[2], encoding='utf-8').read() == t else 1)
    open(a[2], 'w', encoding='utf-8', newline='\n').write(t)
    print('%d codes (%d on the keyboard lists, %d by eye, %d tagged duplicates) -> %s' % (len(rows), sum(1 for r in rows if r['keyboard']), sum(1 for r in rows if 'by eye' in r['evidence']), sum(1 for r in rows if r['char'].startswith('<')), a[2]))
