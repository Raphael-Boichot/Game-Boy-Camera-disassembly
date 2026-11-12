#!/usr/bin/env python3
"""Screen tree of a ROM: one panel per screen group (a mode, or part of one), its BGB screenshots side by side, arrows labelled with keys.

  tools/screen_tree.py OUT.png --title TITLE --explore DIR [--explore DIR ...] [--extra DIR/extra.csv ...] --names CSV
                       [--panels CSV] [--modes N] [--scale 2] [--cols 4]

--explore DIR   a folder of tools/kitty_bgb_explore.py: explore.csv (mode, state, keys, bgb_mode, bgb_state, same, picture, parent, key);
                only rows where BGB ended in the (mode, state) the core found are drawn (same = yes); first folder wins
--extra CSV     more screens (mode, state, picture, how[, parent, key, name]): boot conditions, printer runs, forced runs ('how' starting
                with 'forced' = seen only with a patched mode table: drawn in a box of their own, evidence I); a screen that is not a
                (mode, state) of the mode table (the factory screens of the retail ROMs run before it) takes a word as mode and state
                and its caption from `name`
                a forced row with a `parent` (the screen the code says leads there) is drawn in the tree instead, panel and
                arrow dashed in orange (evidence I); a `note` column adds a line under its screenshot
--cancel CSV    tools/screen_cancel.py: B back to the panel it came from = a two-headed arrow; B elsewhere = a note under the screenshot
--lr            left to right (power-on at the left), columns = steps from power-on, packed top-down; else graphviz top-down
--names CSV     mode, state, name: the caption of each screenshot; the text before ':' of the first name titles the panel
--panels CSV    panel, title, mode, states, row, how: groups that are not one whole mode (states = space-separated list or *);
                row = boot puts the panel on the top row beside the boot screen, linked from the 'Power on' box by the text 'how'
--modes N       modes $00..N-1 exist: the ones with no screen are listed at the bottom (NOT REACHED)
The picture is drawn with PIL, screenshots scaled by an integer --scale with nearest neighbour, so every Game Boy pixel stays a
sharp square; the forced screens go into the first empty area big enough for them. --font scales the text (default 1.3).
"""
import argparse, csv, os, subprocess, tempfile, collections, shlex, textwrap
import os as _os, sys as _sys; _sys.path.insert(0, _os.path.dirname(_os.path.abspath(__file__))); import gb_palette
from PIL import Image, ImageDraw, ImageFont
ap = argparse.ArgumentParser()
ap.add_argument('out'); ap.add_argument('--title', required=True); ap.add_argument('--explore', action='append', default=[])
ap.add_argument('--extra', action='append', default=[]); ap.add_argument('--names', default=None); ap.add_argument('--panels', default=None)
ap.add_argument('--modes', type=int, default=None); ap.add_argument('--scale', type=int, default=2); ap.add_argument('--cols', type=int, default=4); ap.add_argument('--lr', action='store_true'); ap.add_argument('--font', type=float, default=1.3); ap.add_argument('--ranksep', type=float, default=None); ap.add_argument('--cancel', action='append', default=[]); ap.add_argument('--mode-titles', default=None); ap.add_argument('--aspect', type=float, default=2.0)
a = ap.parse_args()
def font(sz, bold=False):
    for p in ('/usr/share/fonts/truetype/dejavu/DejaVuSans%s.ttf' % ('-Bold' if bold else ''),):
        if os.path.exists(p): return ImageFont.truetype(p, sz)
    return ImageFont.load_default(size=sz)
FT = FP = FC = FK = None
names = {}
if a.names and os.path.exists(a.names):
    for r in csv.DictReader(open(a.names)): names.setdefault((r['mode'].upper(), r['state'].upper()), r['name'])
# ---- screens and how each was reached
shots = {}; parent = {}; forced = {}; how = {}
pall = {}                     # every row's parent, pictures or not: a screen whose parent has no picture links to the nearest ancestor that has one
for d in a.explore:
    for r in csv.DictReader(open(os.path.join(d, 'explore.csv'))):
        k = (r['mode'], r['state'])
        if r.get('parent') and k not in pall: pall[k] = (tuple(r['parent'].split(':')), r.get('key', ''))
        if r['same'] != 'yes' or k in shots: continue
        shots[k] = os.path.join(d, r['picture'])
for k in shots:
    if k not in pall: continue
    (pk, key), seen = pall[k], {k}
    while pk not in shots and pk in pall and pk not in seen:
        seen.add(pk); pk, key = pall[pk][0], pall[pk][1] + ' ' + key
    if pk in shots: parent[k] = (pk, key)
# no ancestor with a picture: the longest prefix of the key path that ends on a pictured screen
bykeys = {}; kp = {}
for d in a.explore:
    for r in csv.DictReader(open(os.path.join(d, 'explore.csv'))):
        k = (r['mode'], r['state'])
        if r['same'] == 'yes' and k in shots and k not in kp: kp[k] = r['keys'].split() if r['keys'] != '-' else []; bykeys.setdefault(' '.join(kp[k]), k)
for k in shots:
    if k in parent or k not in kp or not kp[k]: continue
    ks = kp[k]
    for n in range(len(ks) - 1, -1, -1):
        q = bykeys.get(' '.join(ks[:n]))
        if q and q != k: parent[k] = (q, ' '.join(ks[n:])); break
hyp = set(); xnote = {}
for f in a.extra:
    for r in csv.DictReader(open(f)):
        k = (r['mode'], r['state'])
        if k in shots or k in forced: continue
        p = os.path.join(os.path.dirname(f), r['picture'])
        if r.get('note'): xnote[k] = r['note']
        if r.get('how', '').startswith('forced') and not r.get('parent'): forced[k] = p; continue
        if r.get('how', '').startswith('forced'): hyp.add(k)        # reached only when forced, drawn where the code says it belongs: dashed
        shots[k] = p; how[k] = r.get('how', '')
        if r.get('name'): names.setdefault(k, r['name'])        # screens outside the mode table (boot gates) carry their own name
        if r.get('parent'): parent[k] = (tuple(r['parent'].split(':')), r.get('key', ''))
# ---- panels
MT = {}                       # --mode-titles: the mode constants table (group, value, name, tag, desc): the panel title is desc up to ' (' or ':'
if a.mode_titles:
    for r in csv.DictReader(open(a.mode_titles)):
        if r.get('group') == 'mode' and len(r['value']) == 2: MT[r['value'].upper()] = r['desc'].split(' (')[0].split(':')[0].split(';')[0].strip()
panel_of = {}; P = collections.OrderedDict()
if a.panels:
    for r in csv.DictReader(open(a.panels)):
        st = r['states'].split() if r['states'] != '*' else None
        P[r['panel']] = dict(title=r['title'], row=r.get('row', ''), how=r.get('how', ''), cells=[])
        for k in sorted(shots):
            if k[0].upper() == r['mode'].upper() and (st is None or k[1] in st) and k not in panel_of: panel_of[k] = r['panel']
for k in sorted(shots):
    if k not in panel_of:
        pid = 'm' + k[0]
        if pid not in P:
            t_ = MT.get(k[0]) or names.get(k, '').split(':')[0].split(' (')[0].split(' - ')[0] or 'Mode'
            P[pid] = dict(title='%s ($%s)' % (t_, k[0]), row='', how='', cells=[])
        panel_of[k] = pid
for k in sorted(shots): P[panel_of[k]]['cells'].append(k)
for pid in list(P):
    if not P[pid]['cells']: del P[pid]
    else: P[pid]['hyp'] = all(k in hyp for k in P[pid]['cells'])
# ---- cell and panel geometry
S = a.scale; IW, IH = 160 * S, 144 * S; Z = (1 if S == 1 else 1.4) * a.font
FT, FP, FC, FK = font(int(26 * Z), True), font(int(14 * Z), True), font(int(11 * Z)), font(int(11 * Z), True)
PADC = int(6 * Z); CAPH = int(29 * Z); FROMH = int(14 * Z); TITH = int(22 * Z); LH = int(13 * Z)
_M = ImageDraw.Draw(Image.new('RGB', (8, 8)))
def caption(k):
    n = names.get(k, ''); n = n.split(':', 1)[1].strip() if ':' in n else (n.split(' - ', 1)[1].strip() if ' - ' in n else n)
    out, line = [], ''
    lead = ('$%s  ' % k[1]) if len(k[1]) == 2 and all(ch in '0123456789ABCDEF' for ch in k[1]) else ''
    for w_ in (lead + n).split():
        c_ = (line + ' ' + w_).strip()
        if _M.textlength(c_, font=FC) <= IW - 2 or not line: line = c_
        else: out.append(line); line = w_
    return (out + [line])[:2]
def came_from(k):
    out = []
    if k in parent:
        (pm, ps), key = parent[k]
        if panel_of.get((pm, ps)) == panel_of[k]: out.append('%s from $%s' % (key, ps))   # an arrow between panels says the others
    if k in note: out.append(note[k])
    if not out: return []
    if _M.textlength('   '.join(out), font=FC) <= IW: return ['   '.join(out)]
    return [o if _M.textlength(o, font=FC) <= IW else o[:int(len(o) * IW / _M.textlength(o, font=FC)) - 1] + '\u2026' for o in out]
# ---- edges between panels (keys gathered)
E = collections.OrderedDict()
for k, ((pm, ps), key) in parent.items():
    a_, b_ = panel_of.get((pm, ps)), panel_of[k]
    if a_ and a_ != b_:
        lab = key if k == P[b_]['cells'][0] or len(P[b_]['cells']) == 1 else '%s (to $%s)' % (key, k[1])
        E.setdefault((a_, b_), [])
        if lab not in E[(a_, b_)]: E[(a_, b_)].append(lab)
boot = [pid for pid, p in P.items() if p['row'] == 'boot']
# two panels that lead to each other: one two-headed arrow from the one met first, labelled 'forward keys <-> back keys'
back = {}
for (x, y) in list(E):
    if (y, x) in E and (x, y) in E and list(P).index(x) < list(P).index(y):
        back[(x, y)] = ' / '.join(E.pop((y, x)))
# ---- cancel edges (tools/screen_cancel.py): B from a screen back to the panel it came from = a two-headed arrow
cancel_x = []; note = dict(xnote)
for f in a.cancel:
    for r in csv.DictReader(open(f)):
        if r['ok'] != 'yes' or r['to'] == r['base'] or ':' not in r['to']: continue
        src, dst = panel_of.get((r['mode'], r['state'])), panel_of.get(tuple(r['to'].split(':')))
        if not src or not dst: continue
        k = (r['mode'], r['state']); tk = tuple(r['to'].split(':'))
        if src == dst: note[k] = '%s \u2192 $%s' % (r['key'], tk[1]); continue           # back to another screen of the same panel
        if (dst, src) in E: back.setdefault((dst, src), r['key'])                        # back where it came from: two-headed arrow
        else: note[k] = '%s \u2192 %s' % (r['key'], P[dst]['title'].split(' (')[0])       # elsewhere: a note under the screenshot
for pid, p in P.items():
    n = len(p['cells']); r = -(-n // a.cols); c = -(-n // r)        # balanced rows: 9 screens with --cols 5 = 5 + 4, 6 = 3 + 3
    p['fromh'] = max([len(came_from(k)) for k in p['cells']] + [0]) * LH + 4
    p['grid'] = (c, r); p['w'] = max(c * IW + (c + 1) * PADC, _M.textlength(p['title'], font=FP) + 24); p['h'] = TITH + r * (CAPH + IH + p['fromh']) + (r + 1) * 3
M = 20; TOP = int(48 * Z) + int(26 * Z); INK = (40, 40, 40); EDGE = (70, 90, 130); LW = max(3, int(3 * Z)); AH = int(16 * Z)
boxes = {}; draw_edges = []; dashes = []      # boxes: pid -> (x0, y0, w, h) in picture pixels; draw_edges: (points, label, two_heads, label_pos)
def bez(p0, p1, p2, p3, n=20):
    return [((1 - t) ** 3 * p0[0] + 3 * (1 - t) ** 2 * t * p1[0] + 3 * (1 - t) * t ** 2 * p2[0] + t ** 3 * p3[0],
             (1 - t) ** 3 * p0[1] + 3 * (1 - t) ** 2 * t * p1[1] + 3 * (1 - t) * t ** 2 * p2[1] + t ** 3 * p3[1]) for t in [i / n for i in range(n + 1)]]
def lab_of(x, y):
    l = ' / '.join(E[(x, y)]) if (x, y) in E else ''
    return l + ('  ⇄ ' + back[(x, y)] if (x, y) in back else '')
PW = int(140 * Z); PH = int(34 * Z)
if a.lr:
    # columns = steps from power-on; each panel at the height of its parent (or just under the previous panel of its column)
    kids = collections.defaultdict(list)
    for (x, y) in E: kids[x].append(y)
    root = 'power' if boot else next(iter(P)); depth = {root: 0}; order = [root]; par = {}
    if boot: kids['power'] = list(boot)
    q = [root]
    while q:
        n = q.pop(0)
        for c in kids[n]:
            if c not in depth: depth[c] = depth[n] + 1; par[c] = n; order.append(c); q.append(c)
    for pid in P:
        if pid not in depth: depth[pid] = 1; order.append(pid)
    size = {pid: (P[pid]['w'], P[pid]['h']) for pid in P}; size['power'] = (PW, PH)
    cols = collections.defaultdict(list)
    for n in order: cols[depth[n]].append(n)
    VG = int(14 * Z)
    def place(HMAX):
        bx = {}; sub = {}; x = M
        for c in sorted(cols):
            labs = [(P[n]['how'] if par[n] == 'power' else lab_of(par[n], n)) for n in cols[c] if n in par]
            labw = max([_M.textlength(l, font=FK) for l in labs] + [0])
            if c: x += int(labw + AH + 30 * Z)
            cur = TOP; subw = 0
            for n in cols[c]:
                w, h = size[n]
                want = bx[par[n]][1] if n in par and par[n] != 'power' and par[n] in bx else TOP
                y0 = max(cur, want)
                if y0 + h > TOP + HMAX and subw:          # the column goes on in a sub-column of the same step
                    x += subw + int(labw + AH + 30 * Z); cur = TOP; subw = 0; y0 = max(TOP, min(want, TOP + HMAX - h))
                bx[n] = (x, y0, w, h); cur = y0 + h + VG; subw = max(subw, w); sub[n] = x + w
            x += subw
        W_ = max(b[0] + b[2] for b in bx.values()); H_ = max(b[1] + b[3] for b in bx.values())
        return bx, sub, W_, H_
    # the most compact layout among wrap heights from the tallest panel to no wrap, not wider than --aspect times its height
    hmin = max(h for _, h in size.values()); best = None
    for f in [1 + i * 0.25 for i in range(40)]:
        bx, sub, W_, H_ = place(hmin * f)
        if W_ <= a.aspect * H_ and (best is None or W_ * H_ < best[2] * best[3]): best = (bx, sub, W_, H_)
    if best is None: best = place(1e9)
    boxes.update(best[0]); sub_of = best[1]
    if boot:          # power-on box: centred on the boot panels
        ys = [boxes[b][1] + boxes[b][3] / 2 for b in boot]; x0, _, w, h = boxes['power']; boxes['power'] = (x0, (min(ys) + max(ys)) / 2 - h / 2, w, h)
    GW = max(b[0] + b[2] for b in boxes.values()) - M; GH = max(b[1] + b[3] for b in boxes.values()) - TOP
    out_n = collections.Counter(); out_i = collections.Counter(); in_n = collections.Counter(); in_i = collections.Counter()
    pairs = [('power', b) for b in boot] + list(E) + [(s_, d_) for s_, d_, _ in cancel_x]
    for s_, d_ in pairs: out_n[s_] += 1; in_n[d_] += 1
    for s_, d_ in sorted(pairs, key=lambda e: (boxes[e[1]][1], boxes[e[1]][0])):
        sx, sy, sw, sh = boxes[s_]; dx, dy, dw, dh = boxes[d_]
        out_i[s_] += 1; in_i[d_] += 1
        y_s = sy + sh * out_i[s_] / (out_n[s_] + 1) if s_ != 'power' else sy + sh / 2
        y_d = dy + TITH / 2 + (in_i[d_] - 1) * 20 * Z
        if dx > sx:
            cr = sub_of.get(s_, sx + sw) + 6 * Z; p0, p3 = (cr, y_s), (dx, y_d); mid = (p3[0] - p0[0]) / 2
            pts = [(sx + sw, y_s)] + bez(p0, (p0[0] + mid, p0[1]), (p3[0] - mid, p3[1]), p3)
        else:              # an arrow back to an earlier column: around the bottom of both
            yb = max(sy + sh, dy + dh) + 14 * Z
            pts = bez((sx + sw / 2, sy + sh), (sx + sw / 2, yb), (dx + dw / 2, yb), (dx + dw / 2, dy + dh))
        if s_ == 'power': lab = P[d_]['how']
        elif (s_, d_) in E: lab = lab_of(s_, d_)
        else: lab = next(k for x_, y_, k in cancel_x if (x_, y_) == (s_, d_))
        draw_edges.append((pts, lab, (s_, d_) in back, None)); dashes.append(P.get(d_, {}).get('hyp', False))
else:
    DPI = 72.0
    dot = ['digraph G {', 'rankdir=TB; nodesep=0.15; ranksep=%s; splines=true; newrank=true;' % (a.ranksep or 0.35), 'node [shape=box, fixedsize=true, label=""];',
           'edge [fontname="DejaVu Sans Bold", fontsize=%d];' % int(11 * Z)]
    for pid, p in P.items(): dot.append('"%s" [width=%.3f, height=%.3f];' % (pid, p['w'] / DPI, p['h'] / DPI))
    if boot:
        dot.append('"power" [width=%.3f, height=%.3f];' % (PW / DPI, PH / DPI))
        for pid in boot: dot.append('"power" -> "%s" [label="%s"];' % (pid, P[pid]['how'].replace('"', "'")))
        dot.append('{rank=same; %s}' % ' '.join('"%s";' % b for b in boot))
    for (x, y) in E: dot.append('"%s" -> "%s" [label="%s"];' % (x, y, lab_of(x, y)))
    for x, y, k in cancel_x: dot.append('"%s" -> "%s" [label="%s"];' % (x, y, k))
    dot.append('}')
    tmp = tempfile.mkdtemp(); src = os.path.join(tmp, 't.dot'); open(src, 'w').write('\n'.join(dot))
    plain = subprocess.run(['dot', '-Tplain', src], capture_output=True, text=True, check=True).stdout
    GW = GH = 0; raw = []; nb = {}
    for line in plain.splitlines():
        t = shlex.split(line)
        if t[0] == 'graph': GW, GH = float(t[2]) * DPI, float(t[3]) * DPI
        elif t[0] == 'node': nb[t[1]] = tuple(float(v) * DPI for v in t[2:6])
        elif t[0] == 'edge':
            n = int(t[3]); raw.append((t[1], t[2], [(float(t[4 + 2 * i]) * DPI, float(t[5 + 2 * i]) * DPI) for i in range(n)], t[4 + 2 * n:]))
    gx = lambda x: M + x; gy = lambda y: TOP + (GH - y)
    boxes = {k: (gx(cx - w / 2), gy(cy + h / 2), w, h) for k, (cx, cy, w, h) in nb.items()}
    for s_, d_, pts, rest in raw:
        poly = []
        for i in range(0, len(pts) - 3, 3): poly += bez(*pts[i:i + 4])
        has = len(rest) >= 5
        draw_edges.append(([(gx(x), gy(y)) for x, y in poly], rest[0] if has else '', (s_, d_) in back,
                           (gx(float(rest[1]) * DPI), gy(float(rest[2]) * DPI)) if has else None)); dashes.append(P.get(d_, {}).get('hyp', False))
def label_at(pts, lab, lp):
    tw = _M.textlength(lab, font=FK)
    return (lp if lp else (pts[-1][0] - AH - tw / 2 - 8, pts[-1][1] - 13 * Z)), tw
rects = [(x0, y0, x0 + w, y0 + h) for x0, y0, w, h in boxes.values()]
pts_all = [q for e in draw_edges for q in e[0]]
for pts, lab, two, lp in draw_edges:
    if lab:
        (lx, ly), tw = label_at(pts, lab, lp); pts_all += [(lx - tw / 2, ly), (lx + tw / 2, ly)]
fk = sorted(forced); seen_m = {m for m, _ in list(shots) + list(forced)}
miss = ['$%02X' % i for i in range(a.modes or 0) if '%02X' % i not in seen_m]
MISSH = int(30 * Z) if miss else 0
def box(fc):
    fr = (len(fk) + fc - 1) // fc
    return fc * (IW + PADC) + PADC, int(52 * Z) + fr * (CAPH + IH + 12)
# the forced screens go into the first empty area of the graph big enough for them (no panel, arrow or label inside), the most
# columns first; when none is big enough they go under the graph
import numpy as np
PT = np.array(pts_all) if pts_all else np.zeros((0, 2)); RC = np.array(rects) if rects else np.zeros((0, 4)); place = None
for fc in range(len(fk), 2, -1):
    bw, bh = box(fc); bh += MISSH
    for y0 in range(TOP, int(TOP + GH - bh) + 1, 12):
        for x0 in range(M, int(M + GW - bw) + 1, 12):
            x1, y1 = x0 + bw + 16, y0 + bh + 16; xa, ya = x0 - 16, y0 - 16
            if len(RC) and ((RC[:, 2] >= xa) & (RC[:, 0] <= x1) & (RC[:, 3] >= ya) & (RC[:, 1] <= y1)).any(): continue
            if len(PT) and ((PT[:, 0] >= xa) & (PT[:, 0] <= x1) & (PT[:, 1] >= ya) & (PT[:, 1] <= y1)).any(): continue
            place = ('in', fc, x0, y0); break
        if place: break
    if place: break
if fk and place is None: place = ('bottom', min(len(fk), max(6, int(GW // (IW + PADC)))), M, None)
fc = place[1] if fk else 0; FW, FH = box(fc) if fk else (0, 0)
below = FH + 30 if fk and place[0] == 'bottom' else 0
W = int(max(GW, FW) + 2 * M); H = int(TOP + GH + 30 + below + (MISSH if not (fk and place[0] == 'in') else 0) + M)
img = Image.new('RGB', (W, H), 'white'); d = ImageDraw.Draw(img)
d.text((M, int(16 * Z)), a.title, fill='black', font=FT)
import math
def head(p_from, p_to):
    (x1, y1), (x2, y2) = p_from, p_to; ang = math.atan2(y2 - y1, x2 - x1)
    d.polygon([(x2, y2), (x2 - AH * math.cos(ang - 0.42), y2 - AH * math.sin(ang - 0.42)), (x2 - AH * math.cos(ang + 0.42), y2 - AH * math.sin(ang + 0.42))], fill=EDGE)
HYP = (170, 100, 30)
def dashed(pts, col, on=14, off=9):
    run, draw_ = 0.0, True
    for (x1, y1), (x2, y2) in zip(pts, pts[1:]):
        L = math.hypot(x2 - x1, y2 - y1); t = 0.0
        while t < L:
            step = min((on if draw_ else off) - run, L - t)
            if draw_: d.line([(x1 + (x2 - x1) * t / L, y1 + (y2 - y1) * t / L), (x1 + (x2 - x1) * (t + step) / L, y1 + (y2 - y1) * (t + step) / L)], fill=col, width=LW)
            t += step; run += step
            if run >= (on if draw_ else off): run = 0.0; draw_ = not draw_
for (pts, lab, two, lp), dsh in zip(draw_edges, dashes):
    if dsh: dashed(pts, HYP)
    else: d.line(pts, fill=EDGE, width=LW, joint='curve')
    EDGE_ = EDGE; head(pts[-3], pts[-1])
    if two: head(pts[2], pts[0])
for (pts, lab, two, lp), dsh in zip(draw_edges, dashes):
    if not lab: continue
    (lx, ly), tw = label_at(pts, lab, lp); c_ = HYP if dsh else EDGE
    d.rounded_rectangle([lx - tw / 2 - 5, ly - 9 * Z, lx + tw / 2 + 5, ly + 9 * Z], radius=4, fill='white', outline=c_, width=2)
    d.text((lx - tw / 2, ly - 8 * Z), lab, fill=c_, font=FK)
def draw_cell(k, path, x, y, dashed=False):
    for i, l in enumerate(caption(k)): d.text((x, y + i * LH), l, fill=INK, font=FC)
    im = gb_palette.gray(Image.open(path)).resize((IW, IH), Image.NEAREST)      # BGB greens -> the project's greys (tools/gb_palette.py)
    img.paste(im, (int(x), int(y + CAPH)))
    d.rectangle([x - 1, y + CAPH - 1, x + IW, y + CAPH + IH], outline=(150, 150, 150))
    for i, l in enumerate(came_from(k)): d.text((x, y + CAPH + IH + 2 + i * LH), l, fill=(110, 110, 110), font=FC)
for pid, p in P.items():
    x0, y0, w, h = boxes[pid]
    col = (170, 100, 30) if p['row'] == 'boot' or p.get('hyp') else (50, 90, 150)
    d.rounded_rectangle([x0, y0, x0 + w, y0 + h], radius=8, outline=None if p.get('hyp') else col, width=2, fill=(253, 248, 240) if p.get('hyp') else (247, 249, 252))
    if p.get('hyp'): dashed([(x0, y0), (x0 + w, y0), (x0 + w, y0 + h), (x0, y0 + h), (x0, y0)], col, 10, 7)
    d.rounded_rectangle([x0, y0, x0 + w, y0 + TITH - 4], radius=8, fill=col)
    d.text((x0 + 6, y0 + 3 * Z), p['title'], fill='white', font=FP)
    c, r = p['grid']
    for i, k in enumerate(p['cells']):
        cx_ = x0 + PADC + (i % c) * (IW + PADC); cy_ = y0 + TITH + 3 + (i // c) * (CAPH + IH + p['fromh'] + 3)
        draw_cell(k, shots[k], cx_, cy_)
if boot:
    x0, y0, w, h = boxes['power']
    d.rounded_rectangle([x0, y0, x0 + w, y0 + h], radius=int(16 * Z), fill=(60, 60, 60)); tw = d.textlength('Power on', font=FP)
    d.text((x0 + (w - tw) / 2, y0 + 9 * Z), 'Power on', fill='white', font=FP)
y = place[3] if fk and place[0] == 'in' else TOP + GH + 30
FX = place[2] if fk else M
if fk:
    d.rounded_rectangle([FX, y, FX + FW, y + FH - 10], radius=8, outline=(170, 100, 30), width=2)
    for i, l in enumerate(['Seen only with a patched mode table (evidence I):', 'what these screens draw, no key path reaches them yet'] if FW < 900 * Z else ['Seen only with a patched mode table (evidence I): what these screens draw, no key path reaches them yet']):
        d.text((FX + 8, y + 6 + i * int(15 * Z)), l, fill=(170, 100, 30), font=FP)
    top_ = int(40 * Z) if FW >= 900 * Z else int(52 * Z)
    for i, k in enumerate(fk): draw_cell(k, forced[k], FX + PADC + (i % fc) * (IW + PADC), y + top_ + (i // fc) * (CAPH + IH + 12))
    y += FH
if miss:
    d.text((FX, y + 4), 'NOT REACHED YET (no BGB screen): modes ' + ', '.join(miss), fill=(180, 30, 30), font=FP)
img.save(a.out, optimize=True)
print('%s: %d panels, %d screens with a key path or a boot condition, %d forced, %d arrows, %dx%d' % (a.out, len(P), len(shots), len(forced), len(draw_edges), W, H))
