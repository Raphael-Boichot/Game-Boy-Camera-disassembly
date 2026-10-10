#!/usr/bin/env python3
"""Cross-check of the custom core against the documented calibration-record rule (README section 6 / 3.6): boot every real save for 200 frames and compare the
12-byte vector the ROM leaves in WRAM $D5B5-$D5C0 with the vector predicted from the SRAM image by the rule
   primary ($04FF2, checksum (sum+$0D, xor+$23)) valid and echo ($11FF2) equal or bad -> primary;  primary bad and echo valid -> echo;  both valid but different or both bad -> default vector."""
import sys as _s, os as _o
_s.path.insert(0, _o.path.join(_o.path.dirname(_o.path.abspath(__file__)), '..', 'src'))
import paths
import sys, os, glob
import gbcov as g
g.load_rom(paths.ROM)
DEFAULT = bytes.fromhex('7E7F7F7F7E7D7E7E7D7E7D6A')
def rec(b, off):
    v = b[off:off + 12]; s = (sum(v) + 0x0D) & 255; x = 0
    for c in v: x ^= c
    x = (x + 0x23) & 255
    return bytes(v), bytes(b[off + 12:off + 14]) == bytes((s, x))
ok = bad = 0
for f in sorted(glob.glob(os.path.join(paths.SAVES, '*.sav'))) + ['_zero', '_ff']:
    b = open(f, 'rb').read() if f[0] != '_' else (bytes(0x20000) if f == '_zero' else b'\xff' * 0x20000)
    p, pv = rec(b, 0x4FF2); e, ev = rec(b, 0x11FF2)
    pred = p if pv and (not ev or p == e) else e if ev and not pv else DEFAULT
    g.reset(b); g.run(240)
    got = bytes(g.peek(0xD5B5 + i) for i in range(12))
    st = 'OK ' if got == pred else 'DIFF'
    ok += got == pred; bad += got != pred
    print('%s %-12s primary %s echo %s -> predicted %s  emulator %s' % (st, (os.path.basename(f)[:-4] if f[0] != '_' else f), 'valid' if pv else 'bad', 'valid' if ev else 'bad', 'primary' if pred == p and pv else 'echo' if pred == e and ev else 'default', 'primary' if got == p and pv else 'echo' if got == e and ev else 'default' if got == DEFAULT else got.hex()))
print(ok, 'match,', bad, 'differ')
