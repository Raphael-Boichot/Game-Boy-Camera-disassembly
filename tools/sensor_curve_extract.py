#!/usr/bin/env python3
"""The light response of the M64283FP, read from its Japanese datasheet (owner, 2026-11-22: "a sensor with a very similar light behaviour
as the M64282FP; the datasheet contains exposure in lumens examples").

  tools/sensor_curve_extract.py "Mitsubishi Integrated Circuit M64283FP Image Sensor (Original in Japanese).pdf" [--out sensor/m64283fp_sensitivity_curve.csv]

The PDF is in the owner's repository github.com/Raphael-Boichot/Mitsubishi-M64282FP-dashcam, folder "Docs and research/Bibliography"
(not copied here). Page 20, 特性曲線 (characteristic curves), first graph: 感度特性 (sensitivity), clamp off, 25 C, infrared-cut filter;
measuring conditions on the page: Vdd = 5 V, CLK = 500 kHz, Vref = 1.5 V, gain 04h (20 dB); x = 入射光照度 (incident illuminance, lx,
log), y = 出力電圧 - 黒レベル (output voltage minus the black level, mV, log); one series per exposure (蓄積時間): 16 us, 128 us, 1 ms,
10 ms, 100 ms, 1 s (legend order). The graph is vector drawing: every marker is read at its centre (C, exact to the drawing), the axes
from the decade grid lines (x: 10 / 100 / 1,000 lx lines; y: 10 / 100 / 1,000 mV lines). Series by marker and line: circle, square,
triangle on solid lines = 16 us, 128 us, 1 ms; on dotted lines = 10 ms, 100 ms, 1 s. A marker is given to the dotted series when it sits
on that series' polyline (the points of a series lie on its own line; at the top, the saturation plateau of each series is its own row).
The Japanese labels need fonts the PDF does not embed; pdfplumber gives the text and the coordinates.
"""
import argparse, csv, os, math
import pdfplumber
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
ap = argparse.ArgumentParser(); ap.add_argument('pdf'); ap.add_argument('--out', default=os.path.join(REPO, 'sensor', 'm64283fp_sensitivity_curve.csv'))
a = ap.parse_args()
p = pdfplumber.open(a.pdf).pages[19]
vl = sorted({round(l['x0'], 2) for l in p.lines if abs(l['x0'] - l['x1']) < 0.1 and 175 < l['top'] < 370})
hl = sorted({round(l['top'], 2) for l in p.lines if abs(l['top'] - l['bottom']) < 0.1 and 175 < l['top'] < 370 and l['x1'] - l['x0'] > 100})
assert len(vl) == 3 and len(hl) == 3, (vl, hl)
dx = (vl[2] - vl[0]) / 2; dy = (hl[2] - hl[0]) / 2                  # one decade
X = lambda x: 10 ** (1 + (x - vl[0]) / dx); Y = lambda y: 10 ** (3 - (y - hl[0]) / dy)
leg = lambda x, y: x > 338 and y > 288                               # the legend box, lower right
def graph(x, y): return 120 < x < 400 and 180 < y < 345 and not leg(x, y)
M = []
for c in p.curves:
    q = c['pts']
    if q[0] == q[-1] and len(q) <= 8:
        xs = [u[0] for u in q]; ys = [u[1] for u in q]; cx = (max(xs) + min(xs)) / 2; cy = (max(ys) + min(ys)) / 2
        if graph(cx, cy): M.append(('circle' if len(q) == 6 else 'triangle', cx, cy))
for r in p.rects:
    cx = (r['x0'] + r['x1']) / 2; cy = (r['top'] + r['bottom']) / 2
    if graph(cx, cy) and r['width'] < 8: M.append(('square', cx, cy))
segs = []                                                            # the series lines: (dotted, [points])
for c in p.curves:
    q = c['pts']
    if q[0] == q[-1] and len(q) <= 8: continue
    if 175 < c['top'] and c['bottom'] < 345: segs.append((bool(c.get('dash') and c['dash'][0]), q))
for l in p.lines:
    if not (175 < l['top'] and l['bottom'] < 345) or max(l['x1'] - l['x0'], l['bottom'] - l['top']) > 100 and (abs(l['x0'] - l['x1']) < 0.1 or abs(l['top'] - l['bottom']) < 0.1): continue
    segs.append((bool(l.get('dash') and l['dash'][0]), l['pts']))
def dist(px, py, q):
    best = 1e9
    for (x0, y0), (x1, y1) in zip(q, q[1:]):
        vx, vy = x1 - x0, y1 - y0; L2 = vx * vx + vy * vy or 1e-9; t = max(0, min(1, ((px - x0) * vx + (py - y0) * vy) / L2))
        best = min(best, math.hypot(px - x0 - t * vx, py - y0 - t * vy))
    return best
SER = {('circle', False): '16us', ('square', False): '128us', ('triangle', False): '1ms', ('circle', True): '10ms', ('square', True): '100ms', ('triangle', True): '1s'}
rows = []
for shape, cx, cy in M:
    dd = min((dist(cx, cy, q), dot) for dot, q in segs)               # the nearest line decides solid / dotted
    rows.append([SER[(shape, dd[1])], shape, 'dotted' if dd[1] else 'solid', '%.4g' % X(cx), '%.4g' % Y(cy), '%.2f' % dd[0]])
order = ['16us', '128us', '1ms', '10ms', '100ms', '1s']
rows.sort(key=lambda r: (order.index(r[0]), float(r[3])))
os.makedirs(os.path.dirname(a.out), exist_ok=True)
with open(a.out, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['exposure', 'marker', 'line', 'lux', 'mV_above_black', 'distance_to_its_line_pt']); w.writerows(rows)
print('sensor_curve_extract: %d markers -> %s' % (len(rows), os.path.relpath(a.out, REPO)))
for s in order: print('  %-6s %s' % (s, ' '.join('%s:%s' % (r[3], r[4]) for r in rows if r[0] == s)))
