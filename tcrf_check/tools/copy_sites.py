#!/usr/bin/env python3
"""List EVERY banked copy call of the disassembly, live or dead, with the source bank / address, destination and length when they are load-immediates just before the call.
Unlike assets/catalog_jp.csv (asset_catalog.py: three helper names, 386 rows) this reads the helpers by their current names (Mem_CopyFromBank, Vram_CopyFromBank,
Vram_CopyFromBankAuto, Vram_CopyFromBank_4, Vram_CopyFromBank_8) and keeps the sites whose registers are not all immediates (the value is then empty).
usage: copy_sites.py DISASM_DIR OUT.csv      (DISASM_DIR = the mgbdis output with the sym applied, e.g. the `fixed` folder of tools/sym_fix.py; run from any directory)
Result of 2026-10-13 on the Japanese ROM: 941 sites, 791 with all four values, 150 incomplete; 290 of the complete ones are not in catalog_jp.csv (README 16.25)."""
import re, sys, glob, os, csv
D, OUT = sys.argv[1], sys.argv[2]
COPY = {'Mem_CopyFromBank', 'Vram_CopyFromBank', 'Vram_CopyFromBankAuto', 'Vram_CopyFromBank_4', 'Vram_CopyFromBank_8'}
imm = lambda s: int(s.replace('$', ''), 16)
rows = []
for fn in sorted(glob.glob(os.path.join(D, 'bank_*.asm'))):
    bank = int(re.search(r'bank_([0-9a-f]+)\.asm', fn).group(1), 16)
    L = [l.rstrip() for l in open(fn, encoding='utf-8', errors='replace')]
    label = ''
    for i, l in enumerate(L):
        m = re.match(r'^([A-Za-z_][A-Za-z0-9_]*)::?$', l)
        if m: label = m.group(1)
        m = re.match(r'\s+(call|jp) (\S+)\s+;', l)
        if not m or m.group(2) not in COPY: continue
        vals = {}
        for j in range(i - 1, max(i - 14, 0), -1):
            t = L[j].strip()
            if t.endswith(':'): break
            for reg, pat in (('a', r'ld a, (\$[0-9a-f]+)\s'), ('hl', r'ld hl, (\$[0-9a-f]+)\s'), ('de', r'ld de, (\$[0-9a-f]+)\s'), ('bc', r'ld bc, (\$[0-9a-f]+)\s')):
                mm = re.match(pat, t)
                if mm and reg not in vals: vals[reg] = imm(mm.group(1))
        at = re.search(r'; \$([0-9a-f]{4}):', l)
        f = lambda k, w: ('%0*X' % (w, vals[k])) if k in vals else ''
        rows.append(dict(caller_bank='%02X' % bank, call_addr=at.group(1).upper() if at else '', caller_label=label, helper=m.group(2),
                         src_bank=f('a', 2), src=f('hl', 4), dst=f('de', 4), length=f('bc', 4), complete=int(len(vals) == 4)))
with open(OUT, 'w', newline='') as fh:
    w = csv.DictWriter(fh, fieldnames=list(rows[0].keys()), lineterminator='\n'); w.writeheader(); w.writerows(rows)
print(len(rows), 'sites,', sum(r['complete'] for r in rows), 'complete ->', OUT)
