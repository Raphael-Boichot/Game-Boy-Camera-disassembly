#!/usr/bin/env python3
"""Write the editable source tree of the Japanese Rev A ROM (L5): roms/jp_rev_a/src/.

usage: python3 tools/make_source.py --rom pocketcamera_jp.gb [--mgbdis /path/to/mgbdis.py] [--out roms/jp_rev_a/src] [--check]

Steps: mgbdis (master, `--print-hex`) disassembles the ROM with roms/jp_rev_a/pocketcamera_jp.sym beside a copy of it; tools/sym_fix.py --tables --const
writes the word / far-pointer tables, the RAM names, the constants, the state names and the character map into the listing; this script then
  * keeps one file per bank (`bank_000.asm` ... `bank_03f.asm`) and `game.asm`, which includes them after hardware.inc, ram_jp.inc, const_jp.inc and charmap_jp.inc;
  * moves every graphics, map or font block, and every other block of plain `db` rows of at least BIG bytes, into its own file under `data/bank_BB/`
    (`.2bpp` tiles, `.tilemap` tile maps, `.bin` anything else) and writes `INCBIN` in its place, after checking that the file holds exactly the ROM bytes;
  * keeps the ROM address of every instruction as a comment (`; $4A0B`) and drops the raw opcode bytes;
  * writes the tag and the note of every label of roms/jp_rev_a/disasm/sym_names_jp.csv above it (cut at NOTE characters; the CSV has the full text).
Everything in src/ is overwritten: edit the tables of roms/jp_rev_a/disasm/ and run this again, or edit src/ by hand and stop regenerating it.
`--check` assembles the new tree with rgbasm / rgblink / rgbfix (rgbds 1.0.4 in PATH, or RGBDS=dir) and requires md5 fdcfe686cf4df461e870b6e53b2b5a8b.
The Makefile at the top of the repository builds it: `make` (build/jp_rev_a/pocketcamera_jp.gb), `make check`, `make source ROM=... MGBDIS=...`."""
import argparse, csv, hashlib, os, re, shutil, subprocess, sys, tempfile, textwrap

HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
JP = os.path.join(REPO, 'roms', 'jp_rev_a')
MD5 = 'fdcfe686cf4df461e870b6e53b2b5a8b'
BIG = 256          # a plain db block of this size or more goes to a .bin file even when it is not an asset
NOTE = 300         # characters of a label note kept in the source
TILES = ('Gfx_', 'Sheet_', 'Font_', 'Kana_', 'TileGap_', 'DjPrintFont_')
MAPS = ('Map_', 'BgMap_')
ASSET = TILES + MAPS + ('Src_',)


def kind(name, size=16):
    if size % 16 == 0 and (name.startswith(TILES) or (name.startswith('Unused_TCRF_') and name.endswith('_Gfx')) or name.endswith(('_Tiles', '_Gfx'))): return '2bpp'
    if name.startswith(MAPS) or name.endswith('_Map'): return 'tilemap'
    return 'bin'


def run(cmd, **kw):
    p = subprocess.run(cmd, capture_output=True, text=True, **kw)
    if p.returncode: sys.exit('make_source: %s failed:\n%s' % (' '.join(cmd[:3]), (p.stderr or p.stdout)[-2000:]))
    return p.stdout


def gfx_shape(size):
    """(width in tiles, tiles to trim from the last row) of the PNG of a tile block: 16 tiles wide like the ROM sheets."""
    n = size // 16; w = min(16, n)
    return w, (w - n % w) % w


def gfx_list(src):
    """[(png, 2bpp, trim)] read from src/gfx.mk."""
    return re.findall(r'^\$\(BUILD\)/(\S+\.2bpp): \$\(SRC\)/(\S+\.png)\n\t\$\(RGBGFX\) -x (\d+)', open(os.path.join(src, 'gfx.mk')).read(), re.M)


def build(src, rom_out, rgbds=None):
    """What the Makefile does: PNG -> 2bpp (rgbgfx), assemble, link, fix; returns the md5."""
    env = dict(os.environ)
    if rgbds: env['PATH'] = rgbds + os.pathsep + env['PATH']
    o = rom_out + '.o'; b = rom_out + '.d'
    for out2, png, x in gfx_list(src):
        os.makedirs(os.path.dirname(os.path.join(b, out2)), exist_ok=True)
        run(['rgbgfx', '-x', x, '-o', os.path.join(b, out2), os.path.join(src, png)], env=env)
    run(['rgbasm', '-I', b + os.sep, '-I', src + os.sep, '-o', o, os.path.join(src, 'game.asm')], env=env)
    shutil.rmtree(b)
    run(['rgblink', '-o', rom_out, o], env=env)
    run(['rgbfix', '-v', '-p', '255', rom_out], env=env)
    os.remove(o)
    return hashlib.md5(open(rom_out, 'rb').read()).hexdigest()


FAR = ('Vram_CopyFromBank', 'Vram_CopyFromBankAuto', 'Vram_CopyFromBank_4', 'Mem_CopyFromBank', 'Far_Call', 'Sgb_SendPacket', 'Sgb_SendVramTransfer',
       'SpaceFever_CopyTextRows')


def far_labels(out):
    """`ld a, $BB` + `ld hl, $XXXX` before a call to a routine of FAR (a = bank, hl = address): write `ld a, BANK(Label)` / `ld hl, Label`
    when a label of the tree sits at BB:XXXX. Same bytes; the data or code can then move and the call follows it."""
    files = sorted(f for f in os.listdir(out) if re.match(r'bank_[0-9a-f]{3}\.asm$', f))
    defined = set()
    for f in files:
        defined.update(re.findall(r'^([A-Za-z_]\w*)::?\s*$', open(os.path.join(out, f), encoding='utf-8').read(), re.M))
    at = {}
    for l in open(os.path.join(JP, 'pocketcamera_jp.sym'), encoding='utf-8'):
        m = re.match(r'([0-9a-fA-F]{2}):([0-9a-fA-F]{4}) (\S+)', l)
        if m and m.group(3) in defined: at.setdefault((int(m.group(1), 16), int(m.group(2), 16)), m.group(3))
    done = left = 0
    for f in files:
        p = os.path.join(out, f); L = open(p, encoding='utf-8').read().split('\n'); ch = False
        for i, l in enumerate(L):
            m = re.match(r'(\s+ld a, )\$([0-9a-f]{2})(\s.*)?$', l)
            if not m: continue
            for k in range(1, 4):
                if i + k >= len(L) or re.match(r'\s+ld a,', L[i + k]): break
                m2 = re.match(r'(\s+ld hl, )\$([4-7][0-9a-f]{3})(\s.*)?$', L[i + k])
                if not m2: continue
                call = next((L[i + q] for q in range(k + 1, k + 5) if i + q < len(L) and re.search(r'\b(call|jp) ', L[i + q])), '')
                if not any(re.search(r'\b(call|jp) %s\b' % x, call) for x in FAR): break
                lab = at.get((int(m.group(2), 16), int(m2.group(2), 16)))
                if not lab: left += 1; break
                L[i] = (m.group(1) + 'BANK(%s)' % lab).ljust(50) + (m.group(3) or '').strip()
                L[i + k] = (m2.group(1) + lab).ljust(50) + (m2.group(3) or '').strip()
                L[i] = L[i].rstrip(); L[i + k] = L[i + k].rstrip(); done += 1; ch = True
                break
        if ch: open(p, 'w', encoding='utf-8', newline='\n').write('\n'.join(L))
    return dict(far=done, far_left=left)


MACROS = """; Macros of the Pocket Camera source tree, written by tools/make_source.py. Each one assembles to the same bytes as the lines it replaces.

; farcopy ROUTINE, SOURCE, DEST, LENGTH: copy LENGTH bytes from SOURCE (any bank) to DEST with a banked copy routine
; (Mem_CopyFromBank, Vram_CopyFromBank, Vram_CopyFromBankAuto, Vram_CopyFromBank_4)
MACRO farcopy
    ld a, BANK(\\2)
    ld hl, \\2
    ld de, \\3
    ld bc, \\4
    call \\1
ENDM

; farcall TARGET: call TARGET in its own bank through Far_Call
MACRO farcall
    ld a, BANK(\\1)
    ld hl, \\1
    call Far_Call
ENDM

; dwb LABEL: a 3-byte far pointer {lo, hi, bank}
MACRO dwb
    dw \\1
    db BANK(\\1)
ENDM

; set_state STATE: the state of the current mode (leaves A = STATE)
MACRO set_state
    ld a, \\1
    ld [wState], a
ENDM

; next_state: the next state of the current mode (leaves HL = wState)
MACRO next_state
    ld hl, wState
    inc [hl]
ENDM
"""
COPIERS = ('Mem_CopyFromBank', 'Vram_CopyFromBank', 'Vram_CopyFromBankAuto', 'Vram_CopyFromBank_4')


def use_macros(out):
    """Rewrite the five patterns of MACROS (on adjacent lines only, so no label can sit inside one); the first line's address comment stays."""
    cnt = dict(farcopy=0, farcall=0, dwb=0, set_state=0, next_state=0)
    def code(l): return l.split(';')[0].strip()
    def addr(l): m = re.search(r'; \$[0-9A-F]{4}', l); return m.group(0) if m else ''
    def put(text, l): return ('    ' + text).ljust(49) + ' ' + addr(l) if addr(l) else '    ' + text
    for f in sorted(os.listdir(out)):
        if not re.match(r'bank_[0-9a-f]{3}\.asm$', f): continue
        p = os.path.join(out, f); L = open(p, encoding='utf-8').read().split('\n'); R = []; i = 0
        while i < len(L):
            c = [code(x) for x in L[i:i + 5]] + [''] * 5
            m = re.match(r'ld a, BANK\((\w+)\)$', c[0])
            if m and c[1] == 'ld hl, ' + m.group(1):
                x = m.group(1)
                if c[2].startswith('ld de, ') and c[3].startswith('ld bc, ') and c[4].startswith('call ') and c[4][5:] in COPIERS:
                    R.append(put('farcopy %s, %s, %s, %s' % (c[4][5:], x, c[2][7:], c[3][7:]), L[i])); cnt['farcopy'] += 1; i += 5; continue
                if c[2] == 'call Far_Call':
                    R.append(put('farcall ' + x, L[i])); cnt['farcall'] += 1; i += 3; continue
            m = re.match(r'dw (\w+)$', c[0])
            if m and c[1] == 'db BANK(%s)' % m.group(1):
                R.append(put('dwb ' + m.group(1), L[i])); cnt['dwb'] += 1; i += 2; continue
            m = re.match(r'ld a, (STATE_\w+)$', c[0])
            if m and c[1] == 'ld [wState], a':
                R.append(put('set_state ' + m.group(1), L[i])); cnt['set_state'] += 1; i += 2; continue
            if c[0] == 'ld hl, wState' and c[1] == 'inc [hl]':
                R.append(put('next_state', L[i])); cnt['next_state'] += 1; i += 2; continue
            R.append(L[i]); i += 1
        open(p, 'w', encoding='utf-8', newline='\n').write('\n'.join(R))
    open(os.path.join(out, 'macros.inc'), 'w', encoding='utf-8', newline='\n').write(MACROS)
    return cnt


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--rom', required=True); ap.add_argument('--mgbdis', default=os.environ.get('MGBDIS', '/home/claude/tc/mgbdis/mgbdis.py'))
    ap.add_argument('--out', default=os.path.join(JP, 'src')); ap.add_argument('--check', action='store_true'); ap.add_argument('--rgbds', default=os.environ.get('RGBDS'))
    a = ap.parse_args()
    rom = open(a.rom, 'rb').read()
    if hashlib.md5(rom).hexdigest() != MD5: sys.exit('make_source: %s is not the Pocket Camera (Japan) (Rev A) ROM (md5 %s)' % (a.rom, MD5))
    tmp = tempfile.mkdtemp(prefix='make_source_')
    try:
        os.makedirs(os.path.join(tmp, 'in'))
        shutil.copy(a.rom, os.path.join(tmp, 'in', 'pocketcamera_jp.gb')); shutil.copy(os.path.join(JP, 'pocketcamera_jp.sym'), os.path.join(tmp, 'in'))
        lst = os.path.join(tmp, 'lst')
        run([sys.executable, a.mgbdis, os.path.join(tmp, 'in', 'pocketcamera_jp.gb'), '--output-dir', lst, '--overwrite', '--print-hex'])
        run([sys.executable, os.path.join(HERE, 'sym_fix.py'), lst, '--tables', '--const', '--rom', a.rom,
             '--sym', os.path.join(JP, 'pocketcamera_jp.sym'), '--trace', os.path.join(JP, 'wram', 'trace_jp_v3.json')], cwd=REPO)
        names = {}
        for r in csv.DictReader(open(os.path.join(JP, 'disasm', 'sym_names_jp.csv'), encoding='utf-8')):
            names[r['name']] = r
        out = a.out
        if os.path.isdir(out): shutil.rmtree(out)
        os.makedirs(os.path.join(out, 'data'))
        stats = dict(incbin=0, incbin_bytes=0, notes=0, banks=0, png=0); gfx = []
        env = dict(os.environ)
        if a.rgbds: env['PATH'] = a.rgbds + os.pathsep + env['PATH']
        for f in sorted(os.listdir(lst)):
            m = re.match(r'bank_([0-9a-f]{3})\.asm$', f)
            if not m: continue
            bank = int(m.group(1), 16); stats['banks'] += 1
            L = open(os.path.join(lst, f), encoding='utf-8').read().split('\n')
            outl = ['; Pocket Camera (Japan) (Rev A), bank $%02X. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of' % bank,
                    '; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.', '']
            i = 0
            while i < len(L):
                line = L[i]
                if i < 5 and line.startswith(';'): i += 1; continue          # mgbdis' banner
                lm = re.match(r'^([A-Za-z_]\w*)::?\s*$', line)
                if lm and not lm.group(1).startswith('jr_'):
                    name = lm.group(1); r = names.get(name)
                    if r and r['note'].strip():
                        note = re.sub(r'\s+', ' ', r['note'].strip())
                        if len(note) > NOTE: note = note[:NOTE].rsplit(' ', 1)[0] + ' ...'
                        for w in textwrap.wrap('%s: %s' % (r['conf'], note), 116): outl.append('; ' + w)
                        stats['notes'] += 1
                    elif r: outl.append('; %s' % r['conf'])
                    # a block of plain db rows up to the next label / section
                    j = i + 1; nbytes = 0; ok = True
                    while j < len(L) and not re.match(r'^([A-Za-z_]\w*):', L[j]) and not L[j].startswith('SECTION'):
                        s = L[j].strip()
                        if s.startswith('db '):
                            ops = [x.strip() for x in s[3:].split(',')]
                            if not all(re.match(r'^\$[0-9a-f]{2}$', x) for x in ops): ok = False; break
                            nbytes += len(ops)
                        elif s and not s.startswith(';'): ok = False; break
                        j += 1
                    if ok and r and nbytes and (name.startswith(ASSET) or kind(name) != 'bin' or nbytes >= BIG):
                        ad = int(r['addr'], 16); off = ad if bank == 0 else bank * 0x4000 + ad - 0x4000
                        blob = rom[off:off + nbytes]
                        want = bytes(int(x.strip()[1:], 16) for s2 in L[i + 1:j] if s2.strip().startswith('db ') for x in s2.strip()[3:].split(','))
                        if blob != want: sys.exit('make_source: %s: listing bytes differ from the ROM' % name)
                        rel = 'data/bank_%02x/%s.%s' % (bank, name, kind(name, nbytes))
                        os.makedirs(os.path.dirname(os.path.join(out, rel)), exist_ok=True)
                        if kind(name, nbytes) == '2bpp':         # the source is a PNG; the .2bpp is built from it (gfx.mk)
                            w, x = gfx_shape(nbytes); png = rel[:-5] + '.png'
                            t2 = os.path.join(tmp, 't.2bpp'); open(t2, 'wb').write(blob)
                            run(['rgbgfx', '-r', str(w), '-x', str(x), '-o', t2, os.path.join(out, png)], env=env)
                            run(['rgbgfx', '-x', str(x), '-o', t2 + 'b', os.path.join(out, png)], env=env)
                            if open(t2 + 'b', 'rb').read() != blob: sys.exit('make_source: %s: the PNG does not give the ROM bytes back' % name)
                            gfx.append('$(BUILD)/%s: $(SRC)/%s\n\t$(RGBGFX) -x %d -o $@ $<' % (rel, png, x)); stats['png'] += 1
                        else:
                            open(os.path.join(out, rel), 'wb').write(blob)
                        outl.append(line); outl.append('    INCBIN "%s" ; $%04X, %d bytes' % (rel, ad, nbytes))
                        stats['incbin'] += 1; stats['incbin_bytes'] += nbytes
                        i = j; continue
                    outl.append(line); i += 1; continue
                # keep the address, drop the opcode bytes
                line = re.sub(r';\s*\$([0-9a-f]{4}):(?: \$[0-9a-f]{2})+\s*$', lambda mm: '; $' + mm.group(1).upper(), line)
                outl.append(line.rstrip()); i += 1
            open(os.path.join(out, f), 'w', encoding='utf-8', newline='\n').write('\n'.join(outl).rstrip('\n') + '\n')
        stats.update(far_labels(out)); stats.update(use_macros(out))
        open(os.path.join(out, 'gfx.mk'), 'w', newline='\n').write('# Written by tools/make_source.py: one rule per tile PNG (width 16 tiles; -x = blank tiles at the end of the last row).\n'
                                                                  'GFX := %s\n\n%s\n' % (' '.join('$(BUILD)/' + g.split(':')[0][9:] for g in gfx), '\n\n'.join(gfx)))
        for inc in ('hardware.inc', 'ram_jp.inc', 'const_jp.inc', 'charmap_jp.inc'):
            shutil.copy(os.path.join(lst, inc), os.path.join(out, inc))
        g = open(os.path.join(lst, 'game.asm'), encoding='utf-8').read().split('\n')
        g = ['; Pocket Camera (Japan) (Rev A) (SGB Enhanced), md5 %s.' % MD5,
             '; The editable source tree (L5), written by tools/make_source.py; build it with `make` at the top of the repository.', ''] + [l for l in g if l.startswith('INCLUDE')]
        g.insert(g.index('INCLUDE "charmap_jp.inc"') + 1, 'INCLUDE "macros.inc"')
        open(os.path.join(out, 'game.asm'), 'w', encoding='utf-8', newline='\n').write('\n'.join(g) + '\n')
        print('make_source: %(banks)d banks, %(incbin)d INCBIN files (%(incbin_bytes)d bytes, %(png)d tile blocks as PNG), %(notes)d label notes, %(far)d far pointers as labels (%(far_left)d left as numbers); macros: farcopy %(farcopy)d, farcall %(farcall)d, dwb %(dwb)d, set_state %(set_state)d, next_state %(next_state)d ->' % stats, os.path.relpath(out, REPO))
        if a.check:
            md5 = build(out, os.path.join(tmp, 'check.gb'), a.rgbds)
            print('make_source: rebuilt md5', md5, 'OK' if md5 == MD5 else 'DIFFERS')
            if md5 != MD5: sys.exit(1)
    finally:
        shutil.rmtree(tmp, ignore_errors=True)


if __name__ == '__main__':
    main()
