#!/usr/bin/env python3
"""Every ASCII string of the prototype's PC-memory leftovers (Leftover_*_PcRam: RAM of the development PC that the build tool wrote into
unused ROM space; tools/proto_names.py step 5b), for the main README (owner 2026-11-23: "collect any ascii in these leftovers (like
filenames) and list them in the main readme").

  tools/proto_pcram_strings.py PROTO.gb [--csv roms/prototype_debagame/assets/pcram_strings_proto.csv] [--readme README.md]

A string: 6+ printable bytes ($20-$7E), at least half of them letters (shorter runs and runs of x86 code bytes are noise). The same string
in several leftovers is one row with every address. Categories, by the string: file name or path (a drive letter path, or a name with a
DOS / Windows extension), environment variable (NAME=value), symbol name (a name of the older builds' symbol tables,
disasm/leftover_symtab_proto.csv), other. The README block lies between <!-- pcram_strings:begin --> and <!-- pcram_strings:end -->.
No string is the developers' source text (those leftovers are _AsmSource / _SrcListing, measured only).
"""
import argparse, csv, os, re, collections
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); PD = os.path.join(REPO, 'roms', 'prototype_debagame')
ap = argparse.ArgumentParser(); ap.add_argument('rom')
ap.add_argument('--names', default=os.path.join(PD, 'disasm', 'sym_names_proto.csv')); ap.add_argument('--symtab', default=os.path.join(PD, 'disasm', 'leftover_symtab_proto.csv'))
ap.add_argument('--csv', default=os.path.join(PD, 'assets', 'pcram_strings_proto.csv')); ap.add_argument('--readme', default=os.path.join(REPO, 'README.md'))
a = ap.parse_args()
R = open(a.rom, 'rb').read()
def fl(b, ad): return ad if b == 0 else b * 0x4000 + ad - 0x4000
SYMN = {r['name'] for r in csv.DictReader(open(a.symtab))}
FILE = re.compile(r'[A-Za-z]:\\|\b[A-Za-z0-9_~$-]{1,8}\.(?i:dll|exe|vxd|drv|sys|com|bat|ini|txt|dmg|asm|inc|obj|lib|map|sym|lnk|bin|cpp|c|h)\b')
def cat(s):
    if re.match(r'[A-Za-z_][A-Za-z0-9_]*=', s): return 'environment variable'
    if FILE.search(s): return 'file name or path'
    if s in SYMN: return 'symbol name'
    return 'other'
seen = collections.OrderedDict()                    # string -> [(bank, addr, label)]
for r in csv.DictReader(open(a.names)):
    if not r['name'].endswith('_PcRam'): continue
    b, ad = int(r['bank'], 16), int(r['addr'], 16); n = int(re.search(r'(\d+) bytes', r['note']).group(1))
    t = R[fl(b, ad):fl(b, ad) + n]
    for m in re.finditer(rb'[\x20-\x7e]{6,}', t):
        x = m.group().decode('ascii')
        if sum(ch.isalpha() for ch in x) * 2 < len(x): continue
        seen.setdefault(x.strip(), []).append((b, ad + m.start(), r['name']))
rows = sorted(((cat(s), s, w) for s, w in seen.items()), key=lambda k: (['file name or path', 'environment variable', 'symbol name', 'other'].index(k[0]), k[2][0][:2]))
os.makedirs(os.path.dirname(a.csv), exist_ok=True)
with open(a.csv, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['category', 'string', 'bytes', 'where', 'labels'])
    for c, s, wh in rows: w.writerow([c, s, len(s), ' '.join('%02X:%04X' % (b, o) for b, o, _ in wh), ' '.join(sorted({l for _, _, l in wh}))])
cnt = collections.Counter(c for c, _, _ in rows)
def md(s): return '`' + s.replace('`', "'") + '`'
L = ['<!-- pcram_strings:begin -->',
     '*The development PC in the spare banks* (2026-11-23, `tools/proto_pcram_strings.py`; C for the bytes, I for "PC memory"): every ASCII string of the PC-memory leftovers (`Leftover_*_PcRam`, %d labels), %d distinct strings: %d file names or paths, %d environment variables, %d symbol names, %d other (every address in [`assets/pcram_strings_proto.csv`](roms/prototype_debagame/assets/pcram_strings_proto.csv)). A Japanese Windows 95 PC (`WINDOWS VMM 4.0`, `msime95.ini`, `NWLANGUAGE=NIHONGO`, `TZ=JST-9`) whose PATH names `C:\\DEBAGAME\\TOOL` and `C:\\DEBAGAME\\ISD`, Borland C++ (`D:\\BC5\\BIN`, C++Builder) and OrCAD. Symbol name: a name of the older builds' symbol tables (`disasm/leftover_symtab_proto.csv`); the strings are only listed, what each program is is not checked.' % (
         sum(1 for r in csv.DictReader(open(a.names)) if r['name'].endswith('_PcRam')), len(rows), cnt['file name or path'], cnt['environment variable'], cnt['symbol name'], cnt['other']),
     '', '| Category | String | Where (bank:address) |', '|---|---|---|']
for c, s, wh in rows:
    at = ', '.join('`%02X:%04X`' % (b, o) for b, o, _ in wh[:4]) + (' (+%d)' % (len(wh) - 4) if len(wh) > 4 else '')
    L.append('| %s | %s | %s |' % (c, md(s), at))
L.append('<!-- pcram_strings:end -->')
txt = open(a.readme, encoding='utf-8').read()
i0, i1 = txt.find('<!-- pcram_strings:begin -->'), txt.find('<!-- pcram_strings:end -->')
assert i0 >= 0 and i1 > i0, 'README.md has no pcram_strings block'
open(a.readme, 'w', encoding='utf-8').write(txt[:i0] + '\n'.join(L) + txt[i1 + len('<!-- pcram_strings:end -->'):])
print('proto_pcram_strings: %d strings (%s) -> %s, README block' % (len(rows), ', '.join('%s %d' % kv for kv in cnt.items()), os.path.relpath(a.csv, REPO)))
