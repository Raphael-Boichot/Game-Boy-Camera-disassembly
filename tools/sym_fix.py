#!/usr/bin/env python3
"""Post-process an mgbdis disassembly of Pocket Camera (Japan) Rev A so that the numbers mgbdis turns into labels read as numbers again.

  mgbdis --print-hex --output-dir disasm_out pocketcamera_jp.gb          # pocketcamera_jp.sym must sit beside the ROM
  tools/sym_fix.py disasm_out [--rom pocketcamera_jp.gb] [--sym pocketcamera_jp.sym] [--trace wram/trace_jp_v3.json] [--tables] [--ram] [--const] [--strip-hex]
  cd disasm_out && make && md5sum game.gb                                # must still be fdcfe686cf4df461e870b6e53b2b5a8b

Why: mgbdis v3.0 prints a symbol for ANY 16-bit operand that equals the address of a label of the current bank (or of bank 0 below $4000),
whatever the operand means. The bytes are identical either way (the file still assembles to the same ROM); only the reading is wrong. This script
repairs the cases that can be told from the code (every decision uses the instruction bytes in the `; $ADDR: $xx $yy $zz` comment and the static trace):

  1. `ld [Label], a`  (opcode EA, operand < $8000)  -> `ld [$xxxx], a`      MBC register write (RAM enable, ROM bank, RAM bank, mode): never a label
  2. `ld bc, Label`  (opcode 01)                    -> `ld bc, $xxxx`       BC holds a byte count unless the value is above $2000, the code is in bank $1F (sound),
                                                                           or a [bc] access follows before BC is reloaded; a value above $2000 is also a number when the next call
                                                                           is Oam_AddMeta* / Run_DrawMeta / HotSpotEd_DrawArrows (BC = a sprite position, B = x and C = y offset: L3 pass 2026-10-14)
  3. `ld hl|de, Label` whose pointer feeds a banked helper (the banked copy and call helpers 00:0450, 00:0479, 00:0586, 00:05F8, 00:069F, 00:08BB, 00:08C1) with `ld a, BANK` -> the label of that
                                                                           bank at that address, or the plain number when the target has no label
  4. `--tables`: a `.data:LEN:2` block (word table) is written as `dw Label` / `dw $xxxx` instead of `db $lo, $hi` (the label is used only when a
                                                                           label sits exactly at that address in bank 0 or in the table's own bank); a `.data:LEN:3` block of
                                                                           {lo,hi,bank} far pointers is written `dw Label` + `db BANK(Label)` for every row whose target has a label
  5. `--ram` (L4): every instruction that uses a RAM address is written with the name of disasm/ram_names_jp.csv (tools/ram_names.py): `ld a, [$d5ce]` -> `ld a, [wMode]`,
                                                                           `ldh [$ff9a], a` -> `ldh [hOamCursor], a`, `ld hl, $d52a` -> `ld hl, wRngTable`, an address inside a range -> `name + $off`; `ld hl, $ffff` before
                                                                           `set|res n, [hl]` -> `ld hl, rIE`. A `mem` / `ldh` operand is always an address; a 16-bit immediate only when the access table (wram/wram_access.csv)
                                                                           holds a pointer load (kind P) at that instruction and it is not listed in disasm/ram_exclude_jp.csv (byte counts, offsets, coordinate pairs
                                                                           that happen to equal an address). The names are defined in disasm/ram_jp.inc, which is copied to the listing and INCLUDEd by game.asm.
  6. `--const` (L4, implies --ram): values of a group are written with their constant (disasm/const_names_jp.csv, tools/const_names.py): `ld a, $19 / ld [wMode], a` -> `ld a, MODE_TITLE_SCREENS`,
                                                                           `ld a, [wMode] / cp $01` -> `cp MODE_SHOOT_PARLOR`, `ldh a, [hKeysNew] / bit 0, a` -> `bit PADB_A, a`, `and $0f` -> `and PADF_BUTTONS`,
                                                                           `ld a, $43 / ldh [hLcdcShadow], a` -> `ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON`, and the bytes of the mode tables of disasm/const_tables_jp.csv
                                                                           (`db $1c, $1e` -> `db MODE_PRINT_PHOTO_PICKER, MODE_PRINT_OPTION`). Which operand holds which group is in disasm/const_types_jp.csv; the rewrite
                                                                           is made only on a straight line (no label between): a store right after `ld a, imm`, a compare / `bit` / `and` after a load of a typed variable (or of a
                                                                           byte of a mode table) while A is untouched. disasm/const_jp.inc defines the names and is INCLUDEd by game.asm.
                                                                           Sound ids (disasm/sound_names_jp.csv): `ld a, $0C / call Snd_Sfx1` -> `ld a, SFX1_SPACE_FEVER_ENEMY_KILL` (also `call nz, ...`, and a store into a request mailbox),
                                                                           the four id spaces being told apart by the call target (Snd_Music / Snd_Sfx1 / Snd_Sfx3 / Snd_Sfx4); the (id, channel) lists of Snd_PlayFromList
                                                                           (layout `KC` of const_tables_jp.csv) read `db SFX1_HOTSPOT_SOUND_01, SNDCH_SFX1`.
  Not repaired (kept as the label mgbdis chose): `ld hl|de, Label` that is really a number (e.g. `ld de, $4000` used as an offset), and
  `ld a, [Label]` reads of ROM bytes (3 of them, all real table reads).
Stats are printed. Every rewrite keeps the operand value, so the ROM is byte-identical; check with the md5 above."""
import sys, os, re, json, argparse, collections, glob, csv
ap = argparse.ArgumentParser()
ap.add_argument('dir'); ap.add_argument('--rom', default=None); ap.add_argument('--sym', default=None)
ap.add_argument('--trace', default='wram/trace_jp_v3.json'); ap.add_argument('--tables', '--words', dest='tables', action='store_true'); ap.add_argument('--strip-hex', action='store_true')
ap.add_argument('--ram', action='store_true', help='write RAM operands with the names of disasm/ram_names_jp.csv and add disasm/ram_jp.inc to the listing')
ap.add_argument('--ram-names', default=None); ap.add_argument('--ram-access', default=None); ap.add_argument('--ram-exclude', default=None)
ap.add_argument('--const', action='store_true', help='write the values of the constant groups (modes, key masks, LCDC / IE / SC / P1 flags) with their names; implies --ram')
ap.add_argument('--const-names', default=None); ap.add_argument('--const-types', default=None); ap.add_argument('--const-tables', default=None); ap.add_argument('--const-sounds', default=None)
a = ap.parse_args()
if a.const: a.ram = True
rom_path = a.rom or (glob.glob(os.path.join(a.dir, '..', '*.gb')) or glob.glob(os.path.join(a.dir, '..', '..', '*.gb')) or ['pocketcamera_jp.gb'])[0]
sym_path = a.sym or os.path.splitext(rom_path)[0] + '.sym'
ROM = open(rom_path, 'rb').read()
T = json.load(open(a.trace))
def off(b, ad): return ad if b == 0 else b * 0x4000 + (ad - 0x4000)
code = collections.defaultdict(dict)
for k, n in T['code'].items():
    b, ad = k.split(':')
    if n > 0: code[int(b, 16)][int(ad, 16)] = n
PREV = {(cb, ca + n): ca for cb, m in code.items() for ca, n in m.items()}
FAR_HELPERS = {0x0450, 0x0479, 0x0586, 0x05F8, 0x069F, 0x08BB, 0x08C1}
# ---- symbols
bynm = {}; byad = {}; words = []; trips = []     # (bank,start,end) of .data blocks of width 2 (word tables) and width 3 ({lo,hi,bank} far pointers)
for l in open(sym_path):
    l = l.strip()
    if not l or l.startswith(';'): continue
    loc, nm = l.split()[:2]; b, ad = loc.split(':'); b = int(b, 16); ad = int(ad, 16)
    if nm.startswith('.'):
        p = nm[1:].split(':')
        if p[0] == 'data' and len(p) == 3 and int(p[2], 16) == 2: words.append((b, ad, ad + int(p[1], 16)))
        if p[0] == 'data' and len(p) == 3 and int(p[2], 16) == 3: trips.append((b, ad, ad + int(p[1], 16)))
    else: bynm[nm] = (b, ad); byad[(b, ad)] = nm
# ---- evidence helpers (same rules as the naming pass)
def bc_deref(b, ad, window=40):
    p = ad + code[b].get(ad, 3)
    for _ in range(window):
        n = code[b].get(p)
        if not n: return False
        o = ROM[off(b, p)]
        if o in (0x0A, 0x02): return True
        if o == 0x01 or o in (0xC9, 0xD9, 0xC3, 0x18, 0xE9): return False
        p += n
    return False
COORD_CALLEES = ('Oam_AddMeta', 'Run_DrawMeta', 'HotSpotEd_DrawArrows')   # routines that take a sprite position in BC (the meta-sprite bytes are added as y + C and x + B: B = x offset, C = y offset)
def bc_coords(b, ad, window=8):
    """`ld bc, imm` whose BC is consumed as a sprite position by the next call (BC is not reloaded before it): the immediate is a position (B = x, C = y), not an address"""
    p = ad + code[b].get(ad, 3)
    for _ in range(window):
        n = code[b].get(p)
        if not n: return False
        o = ROM[off(b, p)]
        if o == 0xCD:
            t = ROM[off(b, p) + 1] | ROM[off(b, p) + 2] << 8
            nm = byad.get((0, t)) if t < 0x4000 else byad.get((b, t))
            return bool(nm and nm.startswith(COORD_CALLEES))
        if o in (0x01, 0xC9, 0xD9, 0xC3, 0x18, 0xE9, 0xC4, 0xCC, 0xD4, 0xDC) or o in (0x20, 0x28, 0x30, 0x38, 0xC2, 0xCA, 0xD2, 0xDA): return False
        p += n
    return False
HL_MOD={0x2A,0x3A,0x7E,0x46,0x4E,0x56,0x5E,0x66,0x6E,0xE1,0x21,0xF8}      # [HL] is read (HL is a pointer to a pointer table of the current bank), HL reloaded or popped
def far_bank(cb, ca):
    """bank loaded into A for the banked helper call that consumes the `ld hl, imm` at cb:ca (None when there is none)"""
    p = ca; found = False
    for _ in range(9):
        n = code[cb].get(p)
        if not n: return None
        o = ROM[off(cb, p)]
        if o == 0xCD:
            if (ROM[off(cb, p) + 1] | ROM[off(cb, p) + 2] << 8) in FAR_HELPERS: found = True; break
            return None
        if o in (0xC3, 0xC9, 0x18): return None
        if p != ca and o in HL_MOD: return None      # [HL] is read or HL reloaded before the call: the immediate is a local pointer-table base
        p += n
    if not found: return None
    p = ca
    for _ in range(8):
        q = PREV.get((cb, p))
        if q is None: break
        if ROM[off(cb, q)] == 0x3E: return ROM[off(cb, q) + 1]
        p = q
    p = ca
    for _ in range(9):
        n = code[cb].get(p)
        if not n: break
        if ROM[off(cb, p)] == 0x3E: return ROM[off(cb, p) + 1]
        p += n
    return None
# ---- rewrite
LINE = re.compile(r'^(\s+)(\S.*?)(\s*)(; \$([0-9a-f]{4}): ((?:\$[0-9a-f]{2} ?)+))\s*$')
stats = collections.Counter()
# ---- L4: RAM names
RAMR = None
if a.ram:
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    import ram_names
    ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    RAM_ROWS = ram_names.load(a.ram_names or os.path.join(ROOT, 'disasm', 'ram_names_jp.csv'))
    RAMR = ram_names.Resolver(RAM_ROWS)
    RACC = collections.defaultdict(dict)       # (bank, pc) -> {addr: kind}, and the routine of the instruction
    RFUN = {}
    for r in csv.DictReader(open(a.ram_access or os.path.join(ROOT, 'wram', 'wram_access.csv'), encoding='utf-8')):
        k = (int(r['bank'], 16), int(r['pc'], 16)); RACC[k].setdefault(int(r['addr'], 16), set()).add(r['kind']); RFUN[k] = r['function']
    RAM_EXCL = set()
    for r in csv.DictReader(open(a.ram_exclude or os.path.join(ROOT, 'disasm', 'ram_exclude_jp.csv'), encoding='utf-8')):
        RAM_EXCL.add((int(r['bank'], 16), int(r['pc'], 16)))
    RAM_INC = ram_names.inc_text(RAM_ROWS)
    RAM_TOK = re.compile(r'\$[0-9a-f]{4}\b')
# ---- L4: constants
CONST = None
if a.const:
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    import const_names
    ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    C_ROWS = const_names.load_names(a.const_names or os.path.join(ROOT, 'disasm', 'const_names_jp.csv')) + const_names.load_sounds(a.const_sounds or os.path.join(ROOT, 'disasm', 'sound_names_jp.csv'))
    const_names.check_unique(C_ROWS)
    CONST = const_names.Namer(C_ROWS)
    C_TYPES = const_names.load_types(a.const_types or os.path.join(ROOT, 'disasm', 'const_types_jp.csv'))
    C_TABS = const_names.load_tables(a.const_tables or os.path.join(ROOT, 'disasm', 'const_tables_jp.csv'))
    C_INC = const_names.inc_text(C_ROWS)
    C_BYTES = collections.defaultdict(dict)        # bank -> {address: group} of the bytes of the typed tables that are values (layout letters M, K, C)
    C_TABLE_LABEL = {}                             # label of a mode table -> group
    C_PAIRS = collections.defaultdict(list)        # bank -> [(start, end)] of the (id, channel) sound lists (layout KC): written one entry per line
    for t in C_TABS:
        if t['layout'] == 'KC': C_PAIRS[t['bank']].append((t['addr'], t['addr'] + t['len']))
        for i in range(t['len']):
            lt = t['layout'][i % len(t['layout'])]
            if lt == 'M': C_BYTES[t['bank']][t['addr'] + i] = t['group']
            elif lt == 'K': C_BYTES[t['bank']][t['addr'] + i] = const_names.SNDCH_GROUP.get(ROM[off(t['bank'], t['addr'] + i + 1)])     # a sound id: its id space is named by the channel byte that follows
            elif lt == 'C': C_BYTES[t['bank']][t['addr'] + i] = 'sndch'
        lab = byad.get((t['bank'], t['addr']))
        if lab and 'M' in t['layout']: C_TABLE_LABEL[lab] = t['group']
    C_CALL = re.compile(r'^call (?:(?:nz|z|c|nc), )?(\w+)$')
    C_LDA = re.compile(r'^ld a, \$([0-9a-f]{2})$'); C_ST = re.compile(r'^(?:ld|ldh) \[(\w+)\], a$'); C_LD = re.compile(r'^(?:ld|ldh) a, \[(\w+)\]$')
    C_CPAND = re.compile(r'^(cp|and) \$([0-9a-f]{2})$'); C_BIT = re.compile(r'^bit ([0-7]), a$'); C_LDHL = re.compile(r'^ld a, \[hl\+?\]$')
    C_KEEP = re.compile(r'^(?:bit [0-7], a|cp \S.*|(?:jr|jp) (?:nz|z|nc|c), \S+|ret (?:nz|z|nc|c)|ld [bcdehl], a|ld \[[^\]]+\], a|ldh \[[^\]]+\], a|push af)$')
    C_HLADD = re.compile(r'^add hl, (?:bc|de)$'); C_LDHLLAB = re.compile(r'^ld hl, ([A-Za-z_]\w*)$')
def const_code_pass(bank, out):
    """constants in the instructions of one bank (out = its lines, already renamed by the RAM pass); straight-line rules, see the docstring (6)"""
    P = []
    for i, l in enumerate(out):
        m = LINE.match(l)
        if m: P.append({'i': i, 'ind': m.group(1), 'ins': m.group(2), 'pad': m.group(3), 'cm': m.group(4), 'by': [int(x[1:], 16) for x in m.group(6).split()], 'old': m.group(2)})
    n = len(P)
    brk = [True] * n                                    # brk[k]: something that is not an instruction (a label, data) sits between P[k-1] and P[k]
    for k in range(1, n):
        brk[k] = any(x.strip() and not x.strip().startswith(';') for ln in out[P[k - 1]['i'] + 1:P[k]['i']] for x in ln.split('\n')) or '\n' in out[P[k - 1]['i']]
    def put(k, new, key):
        if P[k]['ins'] != new: P[k]['ins'] = new; stats['const_' + key] += 1
    def window(k, g):
        j = k + 1
        while j < n and not brk[j]:
            t = P[j]['ins']; m = C_BIT.match(t)
            if m:
                nm = CONST.bit(g, int(m.group(1)))
                if nm: put(j, 'bit %s, a' % nm, g)
                j += 1; continue
            m = C_CPAND.match(t)
            if m:
                nm = CONST.value(g, int(m.group(2), 16))
                if nm and (m.group(1) == 'cp' or g in const_names.FLAGS): put(j, '%s %s' % (m.group(1), nm), g)
                if m.group(1) == 'and': break
                j += 1; continue
            if C_KEEP.match(t): j += 1; continue
            break
    for k in range(n):
        t = P[k]['ins']
        m = C_LDA.match(t)
        if m and P[k]['by'][0] == 0x3E and k + 1 < n and not brk[k + 1]:
            ms = C_ST.match(P[k + 1]['ins']) or C_CALL.match(P[k + 1]['ins'])       # a store into a typed variable, or a call of a routine whose A is typed (Snd_Sfx1 ...)
            if ms and ms.group(1) in C_TYPES:
                nm = CONST.value(C_TYPES[ms.group(1)], int(m.group(1), 16))
                if nm: put(k, 'ld a, ' + nm, C_TYPES[ms.group(1)])
            continue
        m = C_LD.match(t)
        if m and m.group(1) in C_TYPES: window(k, C_TYPES[m.group(1)]); continue
        if C_LDHL.match(t):
            j = k - 1
            while j >= 0 and not brk[j + 1] and C_HLADD.match(P[j]['ins']): j -= 1
            if j >= 0 and not brk[j + 1]:
                ml = C_LDHLLAB.match(P[j]['ins'])
                if ml and ml.group(1) in C_TABLE_LABEL: window(k, C_TABLE_LABEL[ml.group(1)])
    for p in P:
        if p['ins'] != p['old']:
            pad = ' ' * max(1, len(p['old']) + len(p['pad']) - len(p['ins']))
            out[p['i']] = p['ind'] + p['ins'] + pad + p['cm']
def is_ram(v): return 0xC000 <= v < 0xE000 or 0xFF80 <= v <= 0xFFFE
def ram_rewrite(bank, ad, by, ins, nxt):
    """new text of the instruction at bank:ad whose RAM operand is written as a name (None: leave it); nxt = text of the next instruction"""
    o = by[0]
    if o in (0xEA, 0xFA, 0x08) and len(by) == 3: v = by[1] | by[2] << 8; kind = 'ram_mem'
    elif o in (0xE0, 0xF0) and len(by) == 2: v = 0xFF00 + by[1]; kind = 'ram_ldh'
    elif o in (0x01, 0x11, 0x21, 0x31) and len(by) == 3: v = by[1] | by[2] << 8; kind = 'ram_ptr'
    else: return None
    if v == 0xFFFF and o == 0x21 and nxt and re.match(r'^(set|res) \d, \[hl\]$', nxt):
        stats['ram_ie'] += 1; return re.sub(r'\$ffff\b', 'rIE', ins)
    if not is_ram(v): return None
    pc = (bank, ad)
    if kind == 'ram_ptr':
        if pc in RAM_EXCL: stats['ram_excluded'] += 1; return None
        if o == 0x31: pass                                                 # ld sp: always an address
        elif 'P' not in RACC.get(pc, {}).get(v, ()): stats['ram_imm_not_pointer'] += 1; return None
    elif v not in RACC.get(pc, {}): stats['ram_unproven'] += 1; return None
    r = RAMR.resolve(bank, ad, RFUN.get(pc), v)
    if r is None: stats['ram_unnamed'] += 1; return None
    txt = ram_names.ref(*r)
    new, n = RAM_TOK.subn(lambda m: txt if int(m.group(0)[1:], 16) == v else m.group(0), ins, count=1)
    if not n: stats['ram_no_token'] += 1; return None
    stats[kind + ('_off' if r[1] else '')] += 1
    return new
def word_target(bank, w):
    if w < 0x4000: return byad.get((0, w))
    return byad.get((bank, w))
def in_blocks(lst, bank, ad):
    for b, s, e in lst:
        if b == bank and s <= ad < e: return True
    return False
for fn in sorted(glob.glob(os.path.join(a.dir, 'bank_*.asm'))):
    bank = int(re.search(r'bank_([0-9a-f]+)\.asm', fn).group(1), 16)
    out = []; cur = None
    src = open(fn, encoding='utf-8').read().split('\n')
    for li, line in enumerate(src):
        m = LINE.match(line)
        if m:
            ind, ins, pad, cm, ad, hx = m.groups(); ad = int(ad, 16); by = [int(x[1:], 16) for x in hx.split()]
            cur = ad + len(by); new = ins
            mm = re.match(r'^ld \[([A-Za-z_]\w*)\], a$', ins)
            if mm and by[0] == 0xEA and len(by) == 3:
                v = by[1] | by[2] << 8
                if v < 0x8000: new = 'ld [$%04x], a' % v; stats['mbc_write'] += 1
            mm = re.match(r'^ld (hl|de|bc), ([A-Za-z_]\w*)$', ins)
            if mm and len(by) == 3 and by[0] in (0x21, 0x11, 0x01):
                v = by[1] | by[2] << 8
                if by[0] == 0x01:
                    if not (v > 0x2000 or bank == 0x1F or bc_deref(bank, ad)):
                        new = 'ld bc, $%04x' % v; stats['bc_count'] += 1
                    elif v > 0x2000 and bank != 0x1F and bc_coords(bank, ad):
                        new = 'ld bc, $%04x' % v; stats['bc_coords'] += 1
                elif 0x4000 <= v < 0x8000:
                    bk = far_bank(bank, ad)
                    if bk is not None and bk != bank:
                        t = byad.get((bk, v))
                        new = 'ld %s, %s' % (mm.group(1), t if t else '$%04x' % v); stats['far_ptr' if t else 'far_ptr_numeric'] += 1
            if RAMR is not None:
                nxt = None
                for lj in range(li + 1, min(li + 4, len(src))):
                    mn = LINE.match(src[lj])
                    if mn: nxt = mn.group(2); break
                r2 = ram_rewrite(bank, ad, by, new, nxt)
                if r2 is not None: new = r2
            if new != ins and len(new) != len(ins): pad = ' ' * max(1, len(ins) + len(pad) - len(new))      # keep the comment column
            line = ind + new + (pad + cm if not a.strip_hex else '') if new != ins or a.strip_hex else line
            out.append(line); continue
        s = line.strip()
        ml = re.match(r'^([A-Za-z_]\w*)::?$', s)
        if ml:
            if ml.group(1) in bynm: cur = bynm[ml.group(1)][1]
            else:
                mj = re.match(r'^(?:Call|Jump|jr)_[0-9a-f]{3}_([0-9a-f]{4})$', ml.group(1))
                cur = int(mj.group(1), 16) if mj else None
            out.append(line); continue
        md = re.match(r'^db (.*)$', s)
        if md and cur is not None:
            items = [x.strip() for x in md.group(1).split(',')]
            nb = sum(len(x) - 2 for x in items if x.startswith('"') and x.endswith('"')) + sum(1 for x in items if x.startswith('$'))
            handled = False
            if CONST is not None and bank in C_BYTES and nb == len(items) and all(x.startswith('$') for x in items):
                new_items = list(items)
                for j, x in enumerate(items):
                    g = C_BYTES[bank].get(cur + j)
                    if g:
                        nm = CONST.value(g, int(x[1:], 16))
                        snd = g != 'mode'
                        if nm: new_items[j] = nm; stats['const_sound_table' if snd else 'const_table'] += 1
                        else: stats['const_sound_unnamed' if snd else 'const_table_unnamed'] += 1
                if new_items != items:
                    ind = line[:len(line) - len(line.lstrip())]
                    tab = next(((s0, e0) for s0, e0 in C_PAIRS.get(bank, ()) if s0 <= cur < e0), None)
                    if tab and len(items) % 2 == 0 and (cur - tab[0]) % 2 == 0:       # a sound list: one (id, channel) entry per line, numbered from 1 as the player and the hot-spot picker show them
                        line = '\n'.join('%sdb %s, %s  ; #%d' % (ind, new_items[j], new_items[j + 1], (cur + j - tab[0]) // 2 + 1) for j in range(0, len(items), 2))
                    else: line = ind + 'db ' + ', '.join(new_items)
                    handled = True
            if handled: pass
            elif a.tables and nb == 2 and len(items) == 2 and all(x.startswith('$') for x in items) and in_blocks(words, bank, cur):
                w = int(items[0][1:], 16) | int(items[1][1:], 16) << 8
                t = word_target(bank, w); ind = line[:len(line) - len(line.lstrip())]
                line = '%sdw %s' % (ind, t if t else '$%04x' % w); stats['dw_label' if t else 'dw_numeric'] += 1
            elif a.tables and nb == 3 and len(items) == 3 and all(x.startswith('$') for x in items) and in_blocks(trips, bank, cur):
                w = int(items[0][1:], 16) | int(items[1][1:], 16) << 8; bk = int(items[2][1:], 16)
                t = byad.get((bk, w)) if bk < 0x40 and (0x4000 <= w < 0x8000 or (bk == 0 and w < 0x4000)) else None
                if t:
                    ind = line[:len(line) - len(line.lstrip())]
                    line = '%sdw %s\n%sdb BANK(%s)' % (ind, t, ind, t); stats['far_ptr_row'] += 1
            cur += nb
        elif re.match(r'^ds \$[0-9a-f]+', s) and cur is not None:
            cur += int(re.match(r'^ds \$([0-9a-f]+)', s).group(1), 16)
        out.append(line)
    if CONST is not None: const_code_pass(bank, out)
    open(fn, 'w', encoding='utf-8').write('\n'.join(out))
if RAMR is not None:
    open(os.path.join(a.dir, 'ram_jp.inc'), 'w', encoding='utf-8', newline='\n').write(RAM_INC)
    ga = os.path.join(a.dir, 'game.asm'); gt = open(ga, encoding='utf-8').read()
    if 'ram_jp.inc' not in gt:
        gt2 = re.sub(r'(INCLUDE "hardware\.inc"[^\n]*\n)', r'\1INCLUDE "ram_jp.inc"\n', gt, count=1)
        if gt2 == gt: sys.exit('sym_fix: game.asm has no INCLUDE "hardware.inc" line')
        open(ga, 'w', encoding='utf-8', newline='\n').write(gt2)
    mk = os.path.join(a.dir, 'Makefile')
    if os.path.exists(mk):
        mt = open(mk, encoding='utf-8').read()
        if 'ram_jp.inc' not in mt: open(mk, 'w', encoding='utf-8', newline='\n').write(mt.replace('game.o: game.asm bank_*.asm', 'game.o: game.asm ram_jp.inc bank_*.asm'))
if CONST is not None:
    open(os.path.join(a.dir, 'const_jp.inc'), 'w', encoding='utf-8', newline='\n').write(C_INC)
    ga = os.path.join(a.dir, 'game.asm'); gt = open(ga, encoding='utf-8').read()
    if 'const_jp.inc' not in gt:
        gt2 = gt.replace('INCLUDE "ram_jp.inc"\n', 'INCLUDE "ram_jp.inc"\nINCLUDE "const_jp.inc"\n', 1)
        if gt2 == gt: sys.exit('sym_fix: game.asm has no INCLUDE "ram_jp.inc" line')
        open(ga, 'w', encoding='utf-8', newline='\n').write(gt2)
    mk = os.path.join(a.dir, 'Makefile')
    if os.path.exists(mk):
        mt = open(mk, encoding='utf-8').read()
        if 'const_jp.inc' not in mt: open(mk, 'w', encoding='utf-8', newline='\n').write(mt.replace('ram_jp.inc bank_*.asm', 'ram_jp.inc const_jp.inc bank_*.asm'))
print('sym_fix: ' + ', '.join('%s=%d' % kv for kv in sorted(stats.items())))
