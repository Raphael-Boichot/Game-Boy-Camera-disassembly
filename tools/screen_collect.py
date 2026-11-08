#!/usr/bin/env python3
"""Collect the BGB screens of several explorations into one folder of the repository (the input of tools/screen_tree.py).

  tools/screen_collect.py OUT_DIR --explore DIR [--explore DIR ...] [--extra CSV ...]

Copies, for each (mode, state), the first BGB picture where BGB ended in the (mode, state) the core found (same = yes),
in the order of the --explore folders, into OUT_DIR as screen_MM_SS.png, and writes OUT_DIR/explore.csv (mode, state, keys,
frames, bgb_mode, bgb_state, same, picture, parent, key: the edges of the tree). --extra CSV (mode, state, picture, how[, parent, key]: boot
conditions, forced runs, runs with a printer; parent = the screen it comes from, key = the edge label) is copied the same way into OUT_DIR/extra.csv, its pictures as extra_MM_SS.png.
The pictures are BGB screenshots (its fake sensor picture where a camera view shows): no photo of a person is copied.
"""
import argparse, csv, os, shutil
ap = argparse.ArgumentParser(); ap.add_argument('out'); ap.add_argument('--explore', action='append', default=[]); ap.add_argument('--extra', action='append', default=[])
a = ap.parse_args(); os.makedirs(a.out, exist_ok=True)
rows = {}; cols = ['mode', 'state', 'keys', 'frames', 'bgb_mode', 'bgb_state', 'same', 'picture', 'parent', 'key']
for d in a.explore:
    for r in csv.DictReader(open(os.path.join(d, 'explore.csv'))):
        k = (r['mode'], r['state'])
        if r['same'] != 'yes' or k in rows: continue
        pic = 'screen_%s_%s.png' % k; shutil.copy(os.path.join(d, r['picture']), os.path.join(a.out, pic))
        r = {c: r.get(c, '') for c in cols}; r['picture'] = pic; rows[k] = r
# a branch exploration (--prefix) gives its first screen no parent: take the (mode, state) of any row, in any folder, whose key
# path is the longest prefix of this one (the screen before; the edge is labelled with the keys after it)
bykeys = {}
for d in a.explore:
    for r in csv.DictReader(open(os.path.join(d, 'explore.csv'))):
        if r['same'] == 'yes': bykeys.setdefault(r['keys'], (r['mode'], r['state']))
for k, r in rows.items():
    if not r['parent'] and r['keys'] not in ('-', ''):
        ks = r['keys'].split()
        for j in range(len(ks) - 1, -1, -1):      # the longest recorded prefix; the edge then carries the keys after it
            pk = ' '.join(ks[:j]) or '-'
            if pk in bykeys and bykeys[pk] != k:
                r['parent'] = '%s:%s' % bykeys[pk]; r['key'] = ' '.join(ks[j:]) if len(ks) - j <= 4 else '%s ... (%d keys)' % (' '.join(ks[j:j + 3]), len(ks) - j); break
with open(os.path.join(a.out, 'explore.csv'), 'w', newline='') as f:
    w = csv.DictWriter(f, cols); w.writeheader(); w.writerows(rows[k] for k in sorted(rows))
ex = {}
for fn in a.extra:
    for r in csv.DictReader(open(fn)):
        k = (r['mode'], r['state'])
        if k in rows or k in ex: continue
        pic = 'extra_%s_%s.png' % k; shutil.copy(os.path.join(os.path.dirname(fn), r['picture']), os.path.join(a.out, pic))
        ex[k] = [r['mode'], r['state'], pic, r['how'], r.get('parent', ''), r.get('key', '')]
if ex:
    with open(os.path.join(a.out, 'extra.csv'), 'w', newline='') as f:
        w = csv.writer(f); w.writerow(['mode', 'state', 'picture', 'how', 'parent', 'key']); w.writerows(ex[k] for k in sorted(ex))
print('%s: %d screens with a key path, %d extra' % (a.out, len(rows), len(ex)))
