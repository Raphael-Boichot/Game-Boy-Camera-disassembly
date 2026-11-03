#!/usr/bin/env python3
"""Apply the number corrections that tools/check_repo_consistency.py reports, so a batch that changes counts needs no hand edits.

  python3 tools/fix_quoted.py CHECK_LOG [--dry]

Reads the `FAIL  quoted  FILE:LINE NAME says (a, b, ...), the files say (x, y, ...)` lines of a checker log (and the README-located
form `README.md (§N) ...` is skipped: those need a reading). In line LINE of FILE, each number that differs is replaced by its new
value, in order, written with thousands separators when the old one had them; a number that occurs more than once in the line is
replaced at its first occurrence after the previous replacement. Prints every change; --dry changes nothing. Rerun the checker after.
"""
import re, sys, collections
log = open(sys.argv[1], encoding='utf-8').read().split('\n'); dry = '--dry' in sys.argv
pat = re.compile(r'^FAIL\s+quoted\s+(\S+?):(\d+) .*? says \(([^)]*)\), the files say \(([^)]*)\)')
edits = collections.defaultdict(list)
for l in log:
    m = pat.match(l)
    if not m: continue
    old = [x.strip() for x in m.group(3).split(',') if x.strip()]; new = [x.strip() for x in m.group(4).split(',') if x.strip()]
    if len(old) != len(new): print('skip (lengths differ):', l[:120]); continue
    edits[(m.group(1), int(m.group(2)))].append(list(zip(old, new)))
files = {}
for (fn, ln), groups in edits.items():
    L = files.setdefault(fn, open(fn, encoding='utf-8').read().split('\n'))
    line = L[ln - 1]
    for pairs in groups:
        pos = 0
        for o, n in pairs:
            if o == n: continue
            oi, ni = int(o), int(n)
            for form in ('{:,}'.format(oi), str(oi)):
                m = re.search(r'(?<![\d,.])' + re.escape(form) + r'(?![\d,]\d)', line[pos:])
                if m:
                    rep = '{:,}'.format(ni) if ',' in form or (oi >= 1000 and form == '{:,}'.format(oi)) else str(ni)
                    a = pos + m.start(); line = line[:a] + rep + line[a + len(form):]; pos = a + len(rep)
                    print('%s:%d  %s -> %s' % (fn, ln, form, rep)); break
            else: print('%s:%d  NOT FOUND %s' % (fn, ln, o))
    L[ln - 1] = line
if not dry:
    for fn, L in files.items(): open(fn, 'w', encoding='utf-8').write('\n'.join(L))
