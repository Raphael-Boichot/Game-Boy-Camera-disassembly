#!/usr/bin/env python3
"""Constants of Pocket Camera (Japan) Rev A: table loader, expression builder and generator of disasm/const_jp.inc.

  tools/const_names.py [--names disasm/const_names_jp.csv] [--sounds disasm/sound_names_jp.csv] [--inc disasm/const_jp.inc] [--check]

Sources of truth (hand-edited):
  disasm/const_names_jp.csv   group,value,name,tag,desc   one row per named value of a group (group `mode`: the 34 modes of the table 00:2F3F, taken from the
                              entry labels `ModeNN_Name`, plus MODE_COUNT and MODE_NONE; group `sndch`: the channel byte of the sound lists)
  disasm/sound_names_jp.csv   channel,id,name,tag,sites,desc,evidence   one row per sound id (162) plus the two control requests of the song mailbox; a row without a name has none yet.
                              The channel (`music`, `sfx1`, `sfx3`, `sfx4`) is the group: the four id spaces are separate. `sites` = number of `ld a, id` / request pairs in the ROM
  disasm/const_types_jp.csv   variable,group,note         which RAM / register operands hold a value of which group (`wMode` -> mode, `hKeysNew` -> pad, `hLcdcShadow` -> lcdc ...)
  disasm/const_tables_jp.csv  bank,addr,len,layout,group,note   byte tables whose bytes are values of a group (`M` = a mode, `S` = a state, left as a number; `K` = a sound id of the channel
                              given by the next byte, `C` = that channel byte (group `sndch`): the (id, channel) lists read by Snd_PlayFromList)
Derived, never edited by hand:
  disasm/const_jp.inc         `DEF MODE_MAIN_MENU EQU $00` lines and the two key-mask groups; INCLUDEd by game.asm after ram_jp.inc

Groups: `mode` (names from the table), `sndch` and the four sound groups `music` / `sfx1` / `sfx3` / `sfx4` (names of disasm/sound_names_jp.csv; the call target `Snd_Music` / `Snd_Sfx1` / ... types its
`ld a, id`), the flag groups `pad` (PADF_*), `lcdc` (LCDCF_*), `ie` (IEF_*), `sc` (SCF_*) whose names are the ones of hardware.inc (a value is written as
the OR of the flags it sets), and `p1` (P1F_GET_*, exact values). `tools/sym_fix.py --const` applies them; only where the operand is proven to hold a value of the group."""
import csv, os, re, sys, argparse

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)

# flag groups: (bit, name) in the order they are written; the names come from hardware.inc
FLAGS = {
    'pad':  [(0x01, 'PADF_A'), (0x02, 'PADF_B'), (0x04, 'PADF_SELECT'), (0x08, 'PADF_START'), (0x10, 'PADF_RIGHT'), (0x20, 'PADF_LEFT'), (0x40, 'PADF_UP'), (0x80, 'PADF_DOWN')],
    'lcdc': [(0x80, 'LCDCF_ON'), (0x40, 'LCDCF_WIN9C00'), (0x20, 'LCDCF_WINON'), (0x10, 'LCDCF_BLK01'), (0x08, 'LCDCF_BG9C00'), (0x04, 'LCDCF_OBJ16'), (0x02, 'LCDCF_OBJON'), (0x01, 'LCDCF_BGON')],
    'ie':   [(0x01, 'IEF_VBLANK'), (0x02, 'IEF_STAT'), (0x04, 'IEF_TIMER'), (0x08, 'IEF_SERIAL'), (0x10, 'IEF_HILO')],
    'sc':   [(0x80, 'SCF_START'), (0x02, 'SCF_SPEED'), (0x01, 'SCF_SOURCE')],
}
ZERO = {'lcdc': 'LCDCF_OFF'}                                  # the value 0 has a name only here
EXACT = {'p1': {0x10: 'P1F_GET_BTN', 0x20: 'P1F_GET_DPAD', 0x30: 'P1F_GET_NONE'}}
PAD_GROUPS = {0x0F: 'PADF_BUTTONS', 0xF0: 'PADF_DPAD'}      # defined by const_jp.inc (hardware.inc has the eight single keys only)
PAD_INC = ['; Key masks (the eight single keys PADF_A .. PADF_DOWN come from hardware.inc).',
           'DEF PADF_BUTTONS EQU PADF_A | PADF_B | PADF_SELECT | PADF_START',
           'DEF PADF_DPAD    EQU PADF_RIGHT | PADF_LEFT | PADF_UP | PADF_DOWN']
BITNAMES = {'pad': ['PADB_A', 'PADB_B', 'PADB_SELECT', 'PADB_START', 'PADB_RIGHT', 'PADB_LEFT', 'PADB_UP', 'PADB_DOWN']}


class Const:
    __slots__ = ('group', 'value', 'name', 'tag', 'desc')

    def __init__(self, d):
        self.group = d['group']; self.value = int(d['value'], 16); self.name = d['name']; self.tag = d['tag']; self.desc = d['desc']


def load_names(path=None):
    path = path or os.path.join(ROOT, 'disasm', 'const_names_jp.csv')
    rows = [Const(d) for d in csv.DictReader(open(path, encoding='utf-8'))]
    check_unique(rows)
    return rows


def check_unique(rows):
    """no name twice, no value of a group twice (the sound groups are separate value spaces)"""
    seen = set(); vals = set()
    for r in rows:
        if r.name in seen: raise ValueError('duplicate constant name %s' % r.name)
        if (r.group, r.value) in vals: raise ValueError('two names for %s $%02x' % (r.group, r.value))
        seen.add(r.name); vals.add((r.group, r.value))


SOUND_GROUPS = ('music', 'sfx1', 'sfx3', 'sfx4')
SNDCH_GROUP = {1: 'sfx1', 2: 'music', 3: 'sfx3', 4: 'sfx4'}      # the channel byte of a sound list (Snd_PlayFromList, 00:2A4B) -> the id space of the byte before it


def load_sounds(path=None):
    """the named rows of disasm/sound_names_jp.csv as Const rows (group = channel)"""
    path = path or os.path.join(ROOT, 'disasm', 'sound_names_jp.csv')
    rows = []
    for d in csv.DictReader(open(path, encoding='utf-8')):
        if d['name']: rows.append(Const({'group': d['channel'], 'value': d['id'], 'name': d['name'], 'tag': d['tag'], 'desc': d['desc']}))
    check_unique(rows)
    return rows


def load_types(path=None):
    path = path or os.path.join(ROOT, 'disasm', 'const_types_jp.csv')
    return {d['variable']: d['group'] for d in csv.DictReader(open(path, encoding='utf-8'))}


def load_tables(path=None):
    path = path or os.path.join(ROOT, 'disasm', 'const_tables_jp.csv')
    out = []
    for d in csv.DictReader(open(path, encoding='utf-8')):
        out.append({'bank': int(d['bank'], 16), 'addr': int(d['addr'], 16), 'len': int(d['len']), 'layout': d['layout'], 'group': d['group'], 'note': d['note']})
    return out


class Namer:
    """text of a value of a group: a name of the table, a flag expression, or None when the value has no name"""

    def __init__(self, rows):
        self.by = {(r.group, r.value): r.name for r in rows}

    def value(self, group, v):
        n = self.by.get((group, v))
        if n: return n
        if group in EXACT: return EXACT[group].get(v)
        if group in FLAGS:
            if v == 0: return ZERO.get(group)
            if group == 'pad' and v in PAD_GROUPS: return PAD_GROUPS[v]
            names = []; rest = v
            for bit, nm in FLAGS[group]:
                if v & bit: names.append(nm); rest &= ~bit
            if rest: return None
            return ' | '.join(names)
        return None

    def bit(self, group, n):
        """name of bit n (for `bit n, a`) of a flag group that has bit names"""
        return BITNAMES.get(group, [None] * 8)[n] if 0 <= n < 8 else None


def inc_text(rows):
    out = ['; Pocket Camera (Japan) Rev A: constants. Generated by tools/const_names.py from disasm/const_names_jp.csv, do not edit.',
           '; INCLUDE after hardware.inc and ram_jp.inc. Tags: C code-traced, I inferred.', '']
    for r in sorted(rows, key=lambda r: (r.group, r.value)):
        out.append('DEF %-26s EQU $%02x ; %s %s: %s' % (r.name, r.value, r.tag, r.group, r.desc.replace('\n', ' ')[:90]))
    out.append('')
    out += PAD_INC
    return '\n'.join(out) + '\n'


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('--names', default=os.path.join(ROOT, 'disasm', 'const_names_jp.csv'))
    ap.add_argument('--sounds', default=os.path.join(ROOT, 'disasm', 'sound_names_jp.csv'))
    ap.add_argument('--inc', default=os.path.join(ROOT, 'disasm', 'const_jp.inc'))
    ap.add_argument('--check', action='store_true')
    a = ap.parse_args()
    rows = load_names(a.names) + load_sounds(a.sounds)
    check_unique(rows)
    t = inc_text(rows)
    if a.check:
        if not os.path.exists(a.inc) or open(a.inc, encoding='utf-8', newline='').read() != t: print('differs:', a.inc); sys.exit(1)
        sys.exit(0)
    with open(a.inc, 'w', encoding='utf-8', newline='\n') as f: f.write(t)
    print('%d constants: %s' % (len(rows), a.inc))
