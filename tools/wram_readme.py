#!/usr/bin/env python3
"""Render the per-region WRAM/HRAM CSV files (work/wram_<region>.csv) as condensed README tables.

usage: wram_readme.py <dir-with-wram_*.csv> [limit]    (writes the Markdown to stdout)

One row per object: Address | Size | Name | Type | Banks | Meaning (condensed to ~limit characters at a sentence boundary) | Status.
Status: C = code-traced, I = inferred, U = unused/dead, ? = inconclusive (same legend as the SRAM map).
The full, evidence-citing rows are kept in the CSV files and in the region .md files (wram/ in the package)."""
import csv, re, sys

REGIONS = ['lowwram', 'd500', 'd600', 'd800', 'da00', 'dc00', 'hram']


def condense(note, limit):
    n = note.strip()
    if '||' in n:                                   # dc00 style: "<access list> || <meaning>"
        n = n.split('||', 1)[1].strip()
    m = re.match(r'Used by:.*?\.\s+(?=[A-Z$`(*0-9])', n, re.S)   # hram style: drop the leading access list if a meaning follows
    if m and len(n) > m.end() + 10:
        n = n[m.end():]
    n = re.sub(r'\s+', ' ', n)
    sents = re.split(r'(?<=[.!?])\s+(?=[A-Z$`(*0-9])', n)
    out = ''
    used = 0
    for s in sents:
        if not out:
            out = s
        elif len(out) + len(s) + 1 <= limit:
            out += ' ' + s
        else:
            break
        used += 1
    trunc = used < len(sents)
    if len(out) > limit:
        out = out[:limit].rsplit(' ', 1)[0]
        trunc = True
    if trunc:
        out = out.rstrip('.;,: ') + ' …'
    return out


def cell(s):
    return s.replace('|', '\\|').replace('\n', ' ').strip()


def addr_str(a, size):
    a = int(a, 16)
    try:
        n = int(re.match(r'\s*(\d+)', size).group(1))
    except Exception:
        n = 1
    return ('$%04X' % a) if n <= 1 else ('$%04X-$%04X' % (a, a + n - 1)), n


def table(path, limit):
    rows = list(csv.DictReader(open(path, encoding='utf-8')))
    rows.sort(key=lambda r: int(r['addr'], 16))
    out = ['| Address | Size | Name | Type / format | Banks | Meaning | St |', '|---|---:|---|---|---|---|---|']
    for r in rows:
        a, n = addr_str(r['addr'], r['size'])
        out.append('| `%s` | %d | %s | %s | %s | %s | %s |' % (
            a, n, cell(r['name']), cell(r['type']), cell(r['owner']), cell(condense(r['notes'], limit)), cell(r['status'])))
    return '\n'.join(out), len(rows)


if __name__ == '__main__':
    d = sys.argv[1]
    lim = int(sys.argv[2]) if len(sys.argv) > 2 else 160
    for reg in REGIONS:
        t, n = table('%s/wram_%s.csv' % (d, reg), lim)
        print('<!-- region %s: %d rows -->' % (reg, n))
        print(t)
        print()
