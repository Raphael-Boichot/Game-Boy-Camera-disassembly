#!/usr/bin/env python3
"""Vertical tree of the screens (mode, state) of a ROM, each with its BGB screenshot: boot at the top, dead ends at the bottom.

  tools/screen_tree.py OUT.png --title TITLE --explore DIR [--explore DIR ...] [--extra DIR/forced.csv ...]
                       [--names roms/<rom>/disasm/screen_names_<s>.csv] [--modes 31] [--leaves-at-bottom]

--explore DIR   a folder of tools/kitty_bgb_explore.py: explore.csv (mode, state, keys, bgb_mode, bgb_state, same, picture, parent,
                key) and the pictures. Only rows where BGB ended in the (mode, state) the core found are drawn (same = yes); the
                first folder that gives a (mode, state) wins. An edge parent -> child is labelled with the key that led there.
--extra CSV     more screens without a key path (mode, state, picture, how), e.g. boot scenarios or forced runs; drawn with a
                dashed border and the `how` text, linked from the boot node with a dashed edge.
--names CSV     mode, state, name: the screen's name under its picture (state `*` = every state of the mode)
--modes N       modes $00..N-1 exist (the mode table): the ones with no screen are listed in a box at the bottom, NOT REACHED
Graphviz `dot` draws it (rankdir TB). The picture is the evidence: a screen counts as reached only when BGB shows it.
"""
import argparse, csv, os, subprocess, tempfile, collections, html
ap = argparse.ArgumentParser()
ap.add_argument('out'); ap.add_argument('--title', required=True); ap.add_argument('--explore', action='append', default=[])
ap.add_argument('--extra', action='append', default=[]); ap.add_argument('--names', default=None); ap.add_argument('--modes', type=int, default=None)
ap.add_argument('--leaves-at-bottom', action='store_true'); ap.add_argument('--scale', type=float, default=1.0)
a = ap.parse_args()
names = {}
if a.names and os.path.exists(a.names):
    for r in csv.DictReader(open(a.names)): names[(r['mode'].upper(), r['state'].upper())] = r['name']
def nm(m, s): return names.get((m, s)) or names.get((m, '*')) or ''
nodes = {}; edges = []; extra = {}; start = None
for d in a.explore:
    for r in csv.DictReader(open(os.path.join(d, 'explore.csv'))):
        if r['same'] != 'yes': continue
        k = (r['mode'], r['state'])
        if k in nodes: continue
        nodes[k] = os.path.join(d, r['picture'])
        if r.get('keys') == '-' and start is None: start = k      # the screen at the end of the boot, no key pressed
        if r.get('parent'): edges.append((tuple(r['parent'].split(':')), k, r.get('key', '')))
for f in a.extra:
    for r in csv.DictReader(open(f)):
        k = (r['mode'], r['state'])
        if k in nodes or k in extra: continue
        extra[k] = (os.path.join(os.path.dirname(f), r['picture']), r.get('how', ''))
seen_e = set(); E = []
for p, c, key in edges:
    if p in nodes and (p, c) not in seen_e and p != c: seen_e.add((p, c)); E.append((p, c, key))
children = collections.Counter(p for p, _, _ in E)
root = start or (min(nodes) if nodes else None)
W = int(160 * a.scale); H = int(144 * a.scale)
tmp = tempfile.mkdtemp()
def png_for(path, key):
    if not os.path.exists(path): return None
    from PIL import Image
    q = os.path.join(tmp, '%s_%s.png' % key); Image.open(path).convert('RGB').resize((W, H), Image.NEAREST).save(q); return q
dot = ['digraph G {', 'rankdir=TB; ranksep=0.5; nodesep=0.25; bgcolor="white";',
       'labelloc="t"; fontsize=28; fontname="Helvetica"; label="%s";' % html.escape(a.title),
       'node [shape=plaintext, fontname="Helvetica", fontsize=11]; edge [fontname="Helvetica", fontsize=11, color="#555555"];']
def node(k, path, dashed=False, how=''):
    img = png_for(path, k)
    cell = '<TD FIXEDSIZE="TRUE" WIDTH="%d" HEIGHT="%d"><IMG SRC="%s"/></TD>' % (W, H, img) if img else '<TD WIDTH="%d" HEIGHT="%d">no picture</TD>' % (W, H)
    t = 'mode $%s state $%s' % k; n = nm(*k)
    lab = '<<TABLE BORDER="%d" CELLBORDER="0" CELLSPACING="2" STYLE="%s" COLOR="%s"><TR>%s</TR><TR><TD><B>%s</B></TD></TR>%s%s</TABLE>>' % (
        2, 'dashed' if dashed else 'rounded', '#aa5500' if dashed else '#336699', cell, html.escape(t),
        '<TR><TD>%s</TD></TR>' % html.escape(n) if n else '', '<TR><TD><I>%s</I></TD></TR>' % html.escape(how) if how else '')
    dot.append('"%s:%s" [label=%s];' % (k[0], k[1], lab))
for k, p in sorted(nodes.items()): node(k, p)
for k, (p, how) in sorted(extra.items()): node(k, p, True, how)
for p, c, key in E: dot.append('"%s:%s" -> "%s:%s" [label="%s"];' % (p[0], p[1], c[0], c[1], key))
boot_x = sorted(k for k in extra if not extra[k][1].startswith('forced'))
forced_x = sorted(k for k in extra if extra[k][1].startswith('forced'))
if root:
    for k in boot_x: dot.append('"%s:%s" -> "%s:%s" [style=dashed, color="#aa5500", label="boot condition"];' % (root[0], root[1], k[0], k[1]))
    dot.append('{rank=source; "%s:%s";}' % root)
# forced-only screens: a grid of 6 per row in a box at the bottom (invisible edges stack the rows under the tree)
if forced_x:
    rows_ = [forced_x[i:i + 6] for i in range(0, len(forced_x), 6)]
    dot.append('subgraph cluster_forced { label="Forced only (evidence I): what these modes draw when ModeTable is patched; no key path reaches them yet"; fontsize=18; style=dashed; color="#aa5500";')
    for r in rows_: dot.append('{rank=same; %s}' % ' '.join('"%s:%s";' % k for k in r))
    for r1, r2 in zip(rows_, rows_[1:]): dot.append('"%s:%s" -> "%s:%s" [style=invis];' % (r1[0] + r2[0]))
    for r in rows_:
        for x, y in zip(r, r[1:]): dot.append('"%s:%s" -> "%s:%s" [style=invis];' % (x + y))
    dot.append('}')
    leaves_ = [k for k in nodes if children[k] == 0 and k != root]
    for k in leaves_[:1]: dot.append('"%s:%s" -> "%s:%s" [style=invis];' % (k + rows_[0][0]))
if a.leaves_at_bottom:
    leaves = [k for k in nodes if children[k] == 0 and k != root]
    if leaves: dot.append('{rank=same; %s}' % ' '.join('"%s:%s";' % k for k in leaves))
if a.modes:
    seen_m = {m for m, _ in list(nodes) + list(extra)}
    miss = ['$%02X' % i for i in range(a.modes) if '%02X' % i not in seen_m]
    if miss:
        dot.append('missing [shape=box, style="filled", fillcolor="#fde2e2", fontsize=14, label="NOT REACHED YET (no BGB screen): modes %s"];' % ', '.join(miss))
        dot.append('{rank=sink; missing;}')
        if forced_x: dot.append('"%s:%s" -> missing [style=invis];' % forced_x[-1])
dot.append('}')
src = os.path.join(tmp, 'tree.dot'); open(src, 'w').write('\n'.join(dot))
r = subprocess.run(['dot', '-Tpng', '-o', a.out, src], capture_output=True, text=True)
if r.returncode: raise SystemExit(r.stderr)
print('%s: %d screens with a key path, %d by boot condition or forcing, %d edges' % (a.out, len(nodes), len(extra), len(E)))
