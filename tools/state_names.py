#!/usr/bin/env python3
"""State constants of Pocket Camera (Japan) Rev A: one group per mode (`state_0e` ...), named from the state tables.

  tools/state_names.py [--rom pocketcamera_jp.gb] [--out roms/jp_rev_a/disasm/state_names_jp.csv] [--check]

For every mode the table `ModeNN_StateTable` (the `rst $18` word table of its state handlers; its length is the `.data` block of the symbol file) gives
one handler per state number.  A state gets a name only when the label at its handler is `ModeNN_StateSS_Name` with the same mode NN and the same
state SS: the constant is `STATE_NN_NAME` (CamelCase -> UPPER_SNAKE), with the tag of that label; a name that several states of one mode share
takes the state number (`STATE_21_UNUSED_08`).  A state past the end of its table, a handler shared
by several states or a handler without such a label stays a number, unless roms/jp_rev_a/disasm/state_shared_jp.csv names it (mode, state, name, tag, desc).  Inputs: roms/jp_rev_a/disasm/sym_names_jp.csv (labels and tags), pocketcamera_jp.sym (table
lengths), the ROM (the words of the tables).  Output: group,value,name,tag,desc in the format of roms/jp_rev_a/disasm/const_names_jp.csv, read by tools/const_names.py
(const_jp.inc) and tools/sym_fix.py --const.  Never edit the output by hand: rename the handler label and rerun this script."""
import csv, os, re, sys, argparse
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)

def snake(s):
    s = re.sub(r'([a-z0-9])([A-Z])', r'\1_\2', s)
    s = re.sub(r'([A-Z]+)([A-Z][a-z])', r'\1_\2', s)
    return s.upper()

def build(rom, names_csv, sym_path):
    N = list(csv.DictReader(open(names_csv, encoding='utf-8')))
    lab = {(int(r['bank'], 16), int(r['addr'], 16)): r for r in N}
    blk = {}
    for l in open(sym_path):
        p = l.split()
        if len(p) == 2 and p[1].startswith('.data:'):
            b, a = p[0].split(':'); blk[(int(b, 16), int(a, 16))] = int(p[1].split(':')[1], 16)
    def off(b, a): return a if a < 0x4000 else b * 0x4000 + a - 0x4000
    rows = []
    for (b, a), r in sorted(lab.items()):
        m = re.match(r'^Mode([0-9A-F]{2})_StateTable$', r['name'])
        if not m: continue
        mode = int(m.group(1), 16); n = blk.get((b, a), 0) // 2
        if not n: raise SystemExit('no .data block at %02X:%04X (%s)' % (b, a, r['name']))
        for s in range(n):
            w = rom[off(b, a + 2 * s)] | rom[off(b, a + 2 * s) + 1] << 8
            h = lab.get((0 if w < 0x4000 else b, w))
            if not h: continue
            mh = re.match(r'^Mode([0-9A-F]{2})_State([0-9A-F]{2})_(\w+)$', h['name'])
            if not mh or int(mh.group(1), 16) != mode or int(mh.group(2), 16) != s: continue
            rows.append(dict(group='state_%02x' % mode, value='%02x' % s, name='STATE_%02X_%s' % (mode, snake(mh.group(3))), tag=h['conf'],
                             desc='%s (%02X:%04X)' % (h['name'], 0 if w < 0x4000 else b, w)))
    sp = os.path.join(os.path.dirname(names_csv), 'state_shared_jp.csv')      # states whose handler is shared with another state: named by hand, with the reason
    if os.path.exists(sp):
        have = {(r['group'], r['value']) for r in rows}
        for x in csv.DictReader(open(sp, encoding='utf-8')):
            k = ('state_%s' % x['mode'].lower(), x['state'].lower())
            if k in have: raise SystemExit('state_shared_jp.csv: %s %s already has a name' % k)
            pos = max([i + 1 for i, r in enumerate(rows) if r['group'] == k[0] and r['value'] < k[1]] or [len(rows)])
            rows.insert(pos, dict(group=k[0], value=k[1], name=x['name'], tag=x['tag'], desc=x['desc']))
    cnt = {}
    for r in rows: cnt[r['name']] = cnt.get(r['name'], 0) + 1
    for r in rows:
        if cnt[r['name']] > 1: r['name'] += '_' + r['value'].upper()      # a suffix used by several states of one mode (Mode21_State08/09/0A/0D_Unused) takes the state number
    if len({r['name'] for r in rows}) != len(rows): raise SystemExit('duplicate state constant')
    return rows

def text(rows):
    import io
    o = io.StringIO(); w = csv.DictWriter(o, fieldnames=['group', 'value', 'name', 'tag', 'desc'], lineterminator='\n'); w.writeheader(); w.writerows(rows)
    return o.getvalue()

if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('--rom', default=os.path.join(ROOT, 'pocketcamera_jp.gb'))
    ap.add_argument('--names', default=os.path.join(ROOT, 'roms', 'jp_rev_a', 'disasm', 'sym_names_jp.csv'))
    ap.add_argument('--sym', default=os.path.join(ROOT, 'roms', 'jp_rev_a', 'pocketcamera_jp.sym'))
    ap.add_argument('--out', default=os.path.join(ROOT, 'roms', 'jp_rev_a', 'disasm', 'state_names_jp.csv'))
    ap.add_argument('--check', action='store_true')
    a = ap.parse_args()
    t = text(build(open(a.rom, 'rb').read(), a.names, a.sym))
    if a.check:
        sys.exit(0 if os.path.exists(a.out) and open(a.out, encoding='utf-8', newline='').read() == t else 1)
    open(a.out, 'w', encoding='utf-8', newline='\n').write(t)
    print('%d state constants: %s' % (t.count('\n') - 1, a.out))
