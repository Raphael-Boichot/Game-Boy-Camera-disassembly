#!/usr/bin/env python3
"""Is there an untagged pointer table that points at the still-open (untagged) asset spans?  README §16.24, "Tables that point at the open assets".

Targets: the exact start of each of the 162 rows of tcrf_check/assets/unidentified/open_assets.csv (35,549 B).
Search domain: bytes typed `data` in pocketcamera_jp.sym, banks 00-28, NOT covered by an asset label (Map_/Gfx_/Photo/Sgb/Src_/Unused_TCRF/Sheet/OamList/
Song/Sfx/Snd_/Banner) and not inside an open span (33,590 B) -- i.e. every data byte that could still hide a table nobody named.

Part 1 pointer clusters.  Forms: a split table (low bytes at p, high bytes at p+d, stride s = 1, d = -1024..1024) and interleaved records
(stride 2..8, high byte at p+1), a word being a target when its high byte is 0x40-0x7F and (high << 8 | low) equals the start of an open span.
A cluster = at least 3 hits in the same bank, at most 40 bytes apart, with at least 85 % of the entries having a high byte in 0x40-0x7F.
Null model: every span start is moved to a random address of the same bank with the same alignment (the largest power of two dividing the start, at most 0x100)
and the scan is repeated; if real tables existed, the real count would stand out of the null counts, in particular at the larger hit numbers.
Part 2 evenly spaced series: runs of >= 4 span starts of one bank with a constant gap (a base + n * stride lookup done by code instead of a table).
A series of spans of 2-10 bytes at a gap of 0x20 / 0x40 is the leftover end of fixed-size tile slots (the layout of the sheet around them), not an index.
Part 3 bank switching: for the bank of each open span, how often the bank is selected (coverage/v8/report_v8/bank_select.csv, "organic" = joypad and save only).

usage: table_scan.py [ROM] [trials]    (env GBCAM_ROM, GBCAM_REPO; writes tcrf_check/assets/unidentified/table_scan.txt)
"""
import sys, os, re, csv, random, bisect, collections
import numpy as np
REPO = os.environ.get('GBCAM_REPO', os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
ROMF = sys.argv[1] if len(sys.argv) > 1 else os.environ.get('GBCAM_ROM', '/home/claude/gbcam_jp/pocketcamera_jp.gb')
TRIALS = int(sys.argv[2]) if len(sys.argv) > 2 else 40
rom = np.frombuffer(open(ROMF, 'rb').read(), dtype=np.uint8)
N = len(rom)
def off(b, a): return a if b == 0 else b * 0x4000 + (a - 0x4000)
def rev(o): return (0, o) if o < 0x4000 else (o // 0x4000, 0x4000 + o % 0x4000)
out = []
def say(s=''):
    print(s); out.append(s)

# ---- sym: directives give the byte type, labels give the covering name
typ = np.zeros(N, np.uint8)       # 0 data, 1 code, 2 padding, 3 text
labels = {}
K = {'code': 1, 'data': 0, 'padding': 2, 'text': 3}
for l in open(REPO + '/pocketcamera_jp.sym'):
    p = l.split()
    if len(p) < 2: continue
    b, a = p[0].split(':'); b = int(b, 16); a = int(a, 16)
    if p[1].startswith('.'):
        d = p[1][1:].split(':'); typ[off(b, a):off(b, a) + int(d[1], 16)] = K[d[0]]
    else: labels[off(b, a)] = p[1]
lab = sorted(labels.items()); lab_o = [x[0] for x in lab]
ASSETP = re.compile(r'^(Map_|Gfx_|Photo|Sgb|Src_|Unused_TCRF|Sheet|OamList|Song|Sfx|Snd_|Banner)')
cov = []; j = 0; last = ''
for i in range(N):
    while j < len(lab) and lab[j][0] <= i: last = lab[j][1]; j += 1
    cov.append(last)
opens = []
for r in csv.DictReader(open(REPO + '/tcrf_check/assets/unidentified/open_assets.csv', encoding='utf-8')):
    opens.append((int(r['bank'], 16), int(r['addr'], 16), int(r['bytes']), r['group'], r['name']))
dom = (typ == 0) & np.array([not ASSETP.match(n) for n in cov])
for b, a, n, g, nm in opens: dom[off(b, a):off(b, a) + n] = False
dom[0x29 * 0x4000:] = False
P = np.nonzero(dom)[0]
rom16 = rom.astype(np.uint16)
say('Targets: %d open spans, %d B.  Domain: %d B of untyped-as-asset data, banks 00-28.' % (len(opens), sum(o[2] for o in opens), len(P)))

def alignment(a):
    for al in (0x100, 0x80, 0x40, 0x20, 0x10, 8, 4, 2, 1):
        if a % al == 0: return al
def starts_of(spans):
    isst = np.zeros(65536, bool); w2b = collections.defaultdict(set)
    for b, a, n in spans: isst[a] = True; w2b[a].add(b)
    return isst, w2b
def scan(isst, w2b, minhits=3, validfrac=0.85):
    found = []
    for s, dl in ((1, range(-1024, 1025)), (2, [1]), (3, [1]), (4, [1]), (5, [1]), (6, [1]), (8, [1])):
        for d in dl:
            if s == 1 and d == 0: continue
            q = P + d; ok = (q >= 0) & (q < N); p = P[ok]; q = q[ok]
            m = dom[q]; p = p[m]; q = q[m]
            H = rom16[q]; L = rom16[p]
            valid = (H >= 0x40) & (H < 0x80)
            w = (H << 8) | L
            hit = valid & isst[w]
            if not hit.any(): continue
            hp = p[hit]; hw = w[hit]
            vset = set(p[valid].tolist())
            order = np.argsort(hp); hp = hp[order].tolist(); hw = hw[order].tolist()
            i = 0
            while i < len(hp):
                k = i
                while k + 1 < len(hp) and hp[k + 1] - hp[k] <= 40 * s and (hp[k + 1] - hp[k]) % s == 0: k += 1
                if k - i + 1 >= minhits:
                    first, lastp = hp[i], hp[k]
                    pos = range(first, lastp + 1, s)
                    vf = sum(1 for x in pos if x in vset) / len(pos)
                    cnt = collections.Counter(); seen = set()
                    for m_ in range(i, k + 1):
                        for b in w2b[hw[m_]]:
                            if (hp[m_], b) not in seen: seen.add((hp[m_], b)); cnt[b] += 1
                    b, c = cnt.most_common(1)[0]
                    if c >= minhits and vf >= validfrac: found.append((s, d, first, lastp, b, c, len(pos)))
                i = k + 1
    return found
def hist(f): return [sum(1 for x in f if x[5] >= h) for h in (3, 4, 5, 6, 8, 10)]

say()
say('Part 1: pointer clusters (hits >= 3, 4, 5, 6, 8, 10 in one bank)')
real = [(b, a, n) for b, a, n, g, nm in opens]
obs = scan(*starts_of(real))
ho = hist(obs)
random.seed(7)
nh = []
for t in range(TRIALS):
    sp = []
    for b, a, n in real:
        al = min(alignment(a), 0x100)
        k = random.randrange(0x4000 // al, (0x8000 - n) // al + 1) * al
        if k < 0x4000: k += al
        sp.append((b, k, n))
    nh.append(hist(scan(*starts_of(sp))))
say('  real starts          : ' + '  '.join('%5d' % x for x in ho))
say('  null mean (%d trials): ' % TRIALS + '  '.join('%5.1f' % (sum(h[i] for h in nh) / TRIALS) for i in range(6)))
say('  null max             : ' + '  '.join('%5d' % max(h[i] for h in nh) for i in range(6)))
say('  null min             : ' + '  '.join('%5d' % min(h[i] for h in nh) for i in range(6)))
say('  strongest real clusters (stride, distance, first byte, entries, bank, hits, covering label):')
for s, d, f, l, b, c, n in sorted(obs, key=lambda x: (-x[5], x[2]))[:12]:
    bb, aa = rev(f)
    say('    s=%d d=%+d at %02X:%04X entries=%d target bank %02X hits=%d  %s' % (s, d, bb, aa, n, b, c, cov[f]))

say()
say('Part 2: evenly spaced series of open-span starts (>= 4 terms, one bank, constant gap)')
byb = collections.defaultdict(list)
for b, a, n, g, nm in opens: byb[b].append(a)
def series(starts_by_bank):
    res = []
    for b, al in starts_by_bank.items():
        al = sorted(set(al)); sset = set(al)
        for i, x in enumerate(al):
            for y in al[i + 1:]:
                g = y - x
                if g < 0x10: continue
                if (x - g) in sset: continue          # not the first term
                t = [x, y]
                while t[-1] + g in sset: t.append(t[-1] + g)
                if len(t) >= 4: res.append((b, g, t))
    return res
rs = series(byb)
say('  real: %d series' % len(rs))
szs = {(b, a): n for b, a, n, g_, nm in opens}
for b, g, t in rs: say('    bank %02X gap 0x%X terms %d span sizes %s: %s' % (b, g, len(t), sorted({szs[(b, x)] for x in t}), ' '.join('%04X' % x for x in t)))
random.seed(11)
nc = []
for t_ in range(200):
    sb = collections.defaultdict(list)
    for b, a, n, g, nm in opens:
        al = min(alignment(a), 0x100)
        k = random.randrange(0x4000 // al, (0x8000 - n) // al + 1) * al
        sb[b].append(max(k, 0x4000))
    nc.append(len(series(sb)))
say('  null (200 shifted-start trials): mean %.2f, max %d' % (sum(nc) / 200, max(nc)))

say()
say('Part 3: how often the bank of each open span is selected')
sel = collections.defaultdict(lambda: [0, 0])
for r in csv.DictReader(open(REPO + '/coverage/v8/report_v8/bank_select.csv')):
    b = int(r['new_bank'], 16); sel[b][0] += int(r['count']); sel[b][1] += int(r['count_organic'])
ext = []
for r in csv.DictReader(open(REPO + '/coverage/v8/report_v8/data_extents.csv')):
    s = r['start'].split(':'); e = r['end'].split(':')
    ext.append((off(int(s[0], 16), int(s[1], 16)), off(int(e[0], 16), int(e[1], 16)), int(r['bytes_read']), int(r['bytes_read_organic'])))
tot = collections.defaultdict(lambda: [0, 0, 0, 0])
for b, a, n, g, nm in opens:
    o0 = off(b, a); rd = ro = 0
    for s, e, br, bo in ext:
        if s <= o0 + n - 1 and e >= o0:
            # extents are runs of read data; count only the overlap when the extent is fully inside the span
            if s >= o0 and e < o0 + n: rd += br; ro += bo
    t = tot[g]; t[0] += 1
    if sel[b][1] == 0: t[1] += 1
    if sel[b][0] == 0: t[2] += 1
    if rd: t[3] += 1
say('  group                                   spans  bank never selected organically  bank never selected at all  with read bytes inside')
for g, t in sorted(tot.items()): say('  %-40s %4d %20d %28d %20d' % (g, t[0], t[1], t[2], t[3]))
bl = sorted({b for b, a, n, g, nm in opens})
say('  per bank (selected total / organic): ' + ', '.join('%02X %d/%d' % (b, sel[b][0], sel[b][1]) for b in bl))
open(REPO + '/tcrf_check/assets/unidentified/table_scan.txt', 'w').write('\n'.join(out) + '\n')
