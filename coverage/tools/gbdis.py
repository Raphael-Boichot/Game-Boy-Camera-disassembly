#!/usr/bin/env python3
"""Tiny trace-guided disassembler: dis.py BB:AAAA [count] [cov.npz]  (marks executed instructions with '*')."""
import sys as _s, os as _o
_s.path.insert(0, _o.path.join(_o.path.dirname(_o.path.abspath(__file__)), '..', 'src'))
import paths
import sys, os, json, numpy as np
src = open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'gating_branches.py')).read()
a = src.index('# ---- decoder'); b = src.index('# predecessor on the linear path')
def env(k, d): return os.environ.get(k, d)
rom = open(env('GBCAM_ROM', paths.ROM), 'rb').read(); N = len(rom); rom += b'\0' * 8
def flat(b, a): return a if b == 0 and a < 0x4000 else b * 0x4000 + (a - 0x4000)
exec(src[a:b])
t = json.load(open(env('GBCAM_TRACE', paths.TRACE)))
bank, addr = [int(x, 16) for x in sys.argv[1].split(':')]; cnt = int(sys.argv[2]) if len(sys.argv) > 2 else 40
ex = np.load(sys.argv[3])['ex'] if len(sys.argv) > 3 else None
f = flat(bank, addr)
for _ in range(cnt):
    n = t['code'].get('%02x:%04x' % (bank, addr), 0)
    if n <= 0: print('%02X:%04X  .db $%02X   ; not an instruction start in the trace' % (bank, addr, rom[f])); n = 1
    else: print('%02X:%04X %s %-22s %s' % (bank, addr, '*' if ex is not None and ex[f] else ' ', mnem(f), rom[f:f + n].hex()))
    f += n; addr += n
