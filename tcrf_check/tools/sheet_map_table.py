#!/usr/bin/env python3
"""Turn the output of sheet_tile_match.py into a table: which ROM range holds the tiles of which community sprite sheet.
usage: sheet_map_table.py MATCH.json ROM_MAP.csv CATALOG.csv OUT.csv [--min-tiles N]
Clusters of one sheet that overlap or lie within 64 bytes of each other are merged. Columns:
sheet, bank, start, end, tiles (matched 8x8 windows inside the merged range), bytes_read (share of the range executed/read by the coverage run, classes C R T F r),
bytes_never_read (class U or N), copy_site (catalog_jp.csv rows that copy from inside the range: dst/length/caller)."""
import sys, os, json, csv, re


def bank_addr(off):
    b = off // 0x4000
    return b, (0x4000 + off % 0x4000) if b else off


def main(a):
    mn = 30
    if '--min-tiles' in a:
        i = a.index('--min-tiles'); mn = int(a[i + 1]); del a[i:i + 2]
    match = json.load(open(a[0]))
    N = 1 << 20
    cls = bytearray(N)
    for r in csv.DictReader(open(a[1])):
        b = int(r['bank'], 16); s = int(r['start'], 16)
        o = b * 0x4000 + (s - 0x4000 if b else s)
        cls[o:o + int(r['length'])] = r['class'].encode() * int(r['length'])
    cat = list(csv.DictReader(open(a[2])))
    for r in cat:
        b = int(r['src_bank'], 16); s = int(r['src'], 16)
        r['_off'] = b * 0x4000 + (s - 0x4000 if b else s); r['_len'] = int(r['length'], 16)
    out = []
    for name, r in match.items():
        title = re.sub(r'^.*Game Boy Camera - ', '', name).replace('.png', '')
        if re.search(r' \(\d+\)$', title):
            continue                                       # a re-upload of the same sheet (Album B Photos (1) is byte-identical)
        cl = sorted((c['start'], c['end'] + 1, c['tiles']) for c in r['clusters'])
        merged = []
        for s, e, t in cl:
            if merged and s - merged[-1][1] <= 64:
                merged[-1][1] = max(merged[-1][1], e); merged[-1][2] += t
            else:
                merged.append([s, e, t])
        for s, e, t in merged:
            if t < mn:
                continue
            rd = sum(1 for o in range(s, e) if chr(cls[o]) in 'CRTFr')
            nv = sum(1 for o in range(s, e) if chr(cls[o]) in 'UN')
            sites = ['%s>%s' % (c['length'], c['dst']) for c in cat if s <= c['_off'] < e or c['_off'] <= s < c['_off'] + c['_len']]
            b, ad = bank_addr(s); b2, ad2 = bank_addr(e - 1)
            out.append([title, '%02X' % b, '%04X' % ad, '%02X:%04X' % (b2, ad2), t, rd, nv, ' '.join(sorted(set(sites))[:6])])
    out.sort(key=lambda r: (r[0], r[1], r[2]))
    with open(a[3], 'w', newline='') as f:
        w = csv.writer(f, lineterminator='\n')
        w.writerow(['sheet', 'bank', 'start', 'end', 'tiles', 'bytes_read', 'bytes_never_read', 'copy_site'])
        w.writerows(out)
    print(len(out), 'ranges')


if __name__ == '__main__':
    main(sys.argv[1:])
