#!/usr/bin/env python3
"""newcov.py NEW.npz BASE.npz [ex|oex]: list the bytes (grouped in runs) executed in NEW but not in BASE."""
import sys as _s, os as _o
_s.path.insert(0, _o.path.join(_o.path.dirname(_o.path.abspath(__file__)), '..', 'src'))
import paths
import sys, numpy as np
k = sys.argv[3] if len(sys.argv) > 3 else 'ex'
a = np.load(sys.argv[1]); b = np.load(sys.argv[2])
idx = np.nonzero((a[k] == 1) & (b[k] != 1))[0]
def fmt(f): return '%02X:%04X' % ((0, f) if f < 0x4000 else (f >> 14, 0x4000 + (f & 0x3fff)))
runs = []; s = p = None
for i in idx:
    if s is None: s = p = i
    elif i <= p + 6: p = i
    else: runs.append((s, p)); s = p = i
if s is not None: runs.append((s, p))
print(len(idx), 'bytes in', len(runs), 'runs:', ', '.join('%s+%d' % (fmt(s), e - s + 1) for s, e in runs))
