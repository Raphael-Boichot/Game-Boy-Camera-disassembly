#!/usr/bin/env python3
"""L1 typing of the Hello Kitty ROM from its trace: tables, inline arguments and the sources of the copy routines.

  tools/kitty_types.py ROM roms/hello_kitty/trace/trace_kitty.json --types roms/hello_kitty/disasm/sym_types_kitty.csv \
                       --sites roms/hello_kitty/assets/copy_sites_kitty.csv

Writes (both generated, never edit them; hand rows go in sym_types_kitty_hand.csv, applied after these by sym_build.py):
  copy_sites_kitty.csv  every traced call of a copy routine with the constants found on the straight line before it
                        (bank, source, destination, length; '' = not a constant), the routine and the kind of destination
  --observed COV.npz    (repeatable) bytes the core read as data and no other row types: one `data` row per run of read bytes (gaps of up
                        to 16 unread bytes bridged; the reader routines are in the note), written first so that the code-read rows win
  --names FILE          one label per typed block start, named by kind and address only (Gfx_BB_AAAA tiles, Map_BB_AAAA
                        tile map, Data_BB_AAAA other copy source, JumpTable_BB_AAAA / FarJumpTable_BB_AAAA), tag C: the kind is
                        what the traced code does with the bytes (constant arguments of a copy routine, a dispatcher); no meaning yet (L3)
  --rommap FILE         the byte classes of the trace in the format of the port's rom_map_*.csv (C code, T inline tables
                        and arguments, R the rest), read by tools/status_maps.py for the layout picture
  sym_types_kitty.csv   bank,start,end,type,width,note rows:
                        * jump tables read by the trace: `data,2` (word tables, $0189 / $0194 / rst $18) and `data,3` ({lo, hi, bank}, $01A0)
                        * inline argument bytes after the calls of tools/kitty_trace.py INLINE_ARGS: `data,N`
                        * copy sources with a constant bank, source and length: 2bpp tiles (`data,16`, note `Gfx: ...`) when the destination
                          is $8000-$97FF, tile-map rows (`data,32`, or `data,20` when the length is a multiple of 20 and not of 32)
                          when it is $9800-$9FFF (note `Map: ...`), plain `data` for WRAM / OAM / other destinations
Copy routines (bank 0, read in the listing 2026-11-07):
  $0726  A = bank, DE = source, HL = destination, BC = byte count (VRAM copy in H-blank steps through $066E)
  $066E  the same in the current bank;  $0260  A = bank, DE / HL / BC as above (plain copy through $021C);  $021C  current bank
  $0245  inline {source lo, hi, bank, destination lo, hi, count lo, hi};  $0206  inline {source, destination, count} (current bank)
A source is in bank 0 when below $4000, else in the given bank (or the caller's own bank for the current-bank routines).
"""
import sys, json, csv, argparse, collections, os
ap = argparse.ArgumentParser()
ap.add_argument('rom'); ap.add_argument('trace'); ap.add_argument('--types', required=True); ap.add_argument('--sites', required=True)
ap.add_argument('--observed', action='append', default=[], help='cov.npz of tools/kitty_coverage.py: ROM bytes the core read as data, typed by their reader (L2)')
ap.add_argument('--names', default=None, help='write the generated block labels (Gfx_ / Map_ / Data_ / JumpTable_ / FarJumpTable_ BB_AAAA, tag C) here')
ap.add_argument('--rommap', default=None, help='byte classes of the trace (bank,start,length,class: C code, T inline table / arguments, R rest) for tools/status_maps.py')
a = ap.parse_args()
ROM = open(a.rom, 'rb').read(); T = json.load(open(a.trace))
def off(b, ad): return ad if ad < 0x4000 else b * 0x4000 + ad - 0x4000
def byte(b, ad): return ROM[off(b, ad)]
def word(b, ad): return byte(b, ad) | byte(b, ad + 1) << 8
def K(s): b, ad = s.split(':'); return int(b, 16), int(ad, 16)
code = {K(k): n for k, n in T['code'].items() if n > 0}
args = {K(k): n for k, n in T.get('args', {}).items()}
# fall-through predecessors and jump targets, rebuilt from the trace
ENDS = {0xC3, 0xC9, 0xD9, 0xE9, 0x18}
pred = {}; targets = set(K(k) for k in T['entries'])
for (b, ad), n in code.items():
    op = byte(b, ad); nx = ad + n + args.get((b, ad), 0)
    if op in (0x18, 0x20, 0x28, 0x30, 0x38): targets.add((b, (ad + 2 + (byte(b, ad + 1) ^ 0x80) - 0x80) & 0xFFFF))
    if op in (0xC2, 0xC3, 0xCA, 0xD2, 0xDA): targets.add((0 if word(b, ad + 1) < 0x4000 else b, word(b, ad + 1)))
    if op not in ENDS and not (op == 0xCD and word(b, ad + 1) in (0x0155,)) and (b, nx) in code: pred[(b, nx)] = (b, ad)
def writes(op, op2):
    R = ['b', 'c', 'd', 'e', 'h', 'l', None, 'a']
    if op == 0xCB: return {R[op2 & 7]} - {None} if op2 >> 6 != 1 else set()
    w = set()
    if 0x40 <= op <= 0x7F and op != 0x76 and R[(op >> 3) & 7]: w.add(R[(op >> 3) & 7])
    if 0x80 <= op <= 0xB7: w.add('a')
    for o, r in {0x01: 'bc', 0x11: 'de', 0x21: 'hl', 0xC1: 'bc', 0xD1: 'de', 0xE1: 'hl', 0xF1: 'a', 0x03: 'bc', 0x0B: 'bc', 0x13: 'de', 0x1B: 'de', 0x23: 'hl',
                 0x2B: 'hl', 0x09: 'hl', 0x19: 'hl', 0x29: 'hl', 0x39: 'hl', 0xF8: 'hl', 0x22: 'hl', 0x2A: 'hla', 0x32: 'hl', 0x3A: 'hla', 0x04: 'b', 0x05: 'b',
                 0x06: 'b', 0x0C: 'c', 0x0D: 'c', 0x0E: 'c', 0x14: 'd', 0x15: 'd', 0x16: 'd', 0x1C: 'e', 0x1D: 'e', 0x1E: 'e', 0x24: 'h', 0x25: 'h', 0x26: 'h',
                 0x2C: 'l', 0x2D: 'l', 0x2E: 'l', 0x3C: 'a', 0x3D: 'a', 0x3E: 'a'}.items():
        if op == o: w |= set(r)
    if op in (0x0A, 0x1A, 0x07, 0x0F, 0x17, 0x1F, 0x27, 0x2F, 0xC6, 0xCE, 0xD6, 0xDE, 0xE6, 0xEE, 0xF6, 0xF0, 0xF2, 0xFA): w.add('a')
    return w
def const(b, ad, reg):
    """value of reg (a, bc, de, hl) at the instruction (b, ad), from the straight line before it, else None"""
    cur = pred.get((b, ad)); n = 0
    while cur is not None and n < 40:
        cb, ca = cur; op = byte(cb, ca); op2 = byte(cb, ca + 1)
        if op in (0xCD, 0xC4, 0xCC, 0xD4, 0xDC) or (op >= 0xC7 and op & 7 == 7): return None
        w = writes(op, op2)
        if reg == 'a' and 'a' in w: return byte(cb, ca + 1) if op == 0x3E else 0 if op == 0xAF else None
        if len(reg) == 2 and (reg[0] in w or reg[1] in w):
            return word(cb, ca + 1) if op == {'bc': 0x01, 'de': 0x11, 'hl': 0x21}[reg] else None
        if cur in targets: return None
        cur = pred.get(cur); n += 1
    return None
REG = {0x0726: 'bank', 0x0260: 'bank', 0x066E: 'cur', 0x021C: 'cur'}
sites = []
for (b, ad), n in sorted(code.items()):
    if byte(b, ad) != 0xCD: continue
    t = word(b, ad + 1)
    if t in REG:
        bank = const(b, ad, 'a') if REG[t] == 'bank' else b
        src, dst, ln = const(b, ad, 'de'), const(b, ad, 'hl'), const(b, ad, 'bc')
    elif t == 0x0245: src, bank, dst, ln = word(b, ad + 3), byte(b, ad + 5), word(b, ad + 6), word(b, ad + 8)
    elif t == 0x0206: src, bank, dst, ln = word(b, ad + 3), b, word(b, ad + 5), word(b, ad + 7)
    else: continue
    if src is not None and src < 0x4000: bank = 0
    kind = '' if dst is None else 'tiles' if 0x8000 <= dst < 0x9800 else 'map' if 0x9800 <= dst < 0xA000 else 'oam' if 0xFE00 <= dst < 0xFEA0 else 'wram' if 0xC000 <= dst < 0xE000 else 'other'
    sites.append({'bank': '%02X' % b, 'site': '%04X' % ad, 'routine': '%04X' % t, 'src_bank': '' if bank is None else '%02X' % bank,
                  'src': '' if src is None else '%04X' % src, 'dst': '' if dst is None else '%04X' % dst, 'len': '' if ln is None else '%04X' % ln, 'dst_kind': kind})
os.makedirs(os.path.dirname(a.sites), exist_ok=True)
with open(a.sites, 'w', newline='') as f:
    w = csv.DictWriter(f, ['bank', 'site', 'routine', 'src_bank', 'src', 'dst', 'len', 'dst_kind']); w.writeheader(); w.writerows(sites)
rows = []
def add(b, s, e, typ, width, note):
    if e > s: rows.append([b, s, e, typ, width, note])
obs_rows = []
if a.observed:
    import numpy as np
    dr = None; rdr = None
    for f in a.observed:
        z = np.load(f); d_ = z['dr'] > 0; r_ = z['rdr'].astype(np.uint64)
        if dr is None: dr, rdr = d_.copy(), r_.copy()
        else: rdr = np.where(rdr == 0, r_, rdr); dr |= d_
    # the reader routine of an instruction = the nearest trace entry at or below it in its bank (unrolled copies read
    # neighbouring bytes with different instructions of one routine)
    import bisect
    ents = collections.defaultdict(list)
    for k in T['entries']: eb, ea = K(k); ents[eb].append(ea)
    for eb in ents: ents[eb].sort()
    def routine(v):
        v = int(v) & 0x3FFFFF; rb, rp = v >> 16, v & 0xFFFF; rb = 0 if rp < 0x4000 else rb
        L = ents.get(rb, []); i_ = bisect.bisect_right(L, rp) - 1
        return (rb, L[i_]) if i_ >= 0 else (rb, rp)
    rkey = {}
    def rk(v): return rkey.get(v) or rkey.setdefault(v, routine(v))
    # one block per run of read bytes, bridging gaps of up to 16 unread bytes; the note names up to 4 reader routines
    i = 0; N = len(ROM); cur = None
    for i in np.nonzero(dr)[0]:
        i = int(i); b = i >> 14; ad = i if b == 0 else (i & 0x3FFF) + 0x4000
        if cur and cur[0] == b and ad - cur[2] <= 16: cur[2] = ad + 1; cur[3][rk(int(rdr[i]))] += 1
        else:
            if cur: obs_rows.append(cur)
            cur = [b, ad, ad + 1, collections.Counter({rk(int(rdr[i])): 1})]
    if cur: obs_rows.append(cur)
    exb = None
    for f in a.observed:
        e_ = np.load(f)['ex'] > 0; exb = e_ if exb is None else (exb | e_)
    nexe = sum(1 for (b_, ad_), n_ in code.items() for i_ in range(n_) if exb[off(b_, ad_ + i_)])
    print('observed: %d of %d code bytes executed in the runs (core, and BGB breakpoints on block heads), %d ROM bytes read as data in the core' % (nexe, sum(code.values()), int(dr.sum())))
    obs_rows = [[b, s0, e0, 'data', '', 'read in the core runs by %s%s' % (', '.join('%02X:%04X' % r for r, _ in c.most_common(4)), ' ...' if len(c) > 4 else '')]
                for b, s0, e0, c in obs_rows]
for k, v in T['ctables'].items():
    b, s = K(k); rows and None
    add(b, s, s + v['width'] * len(v['records']), 'data', v['width'], 'jump table read through %s at %s (%d records; tools/kitty_trace.py)' % ('$01A0' if v['width'] == 3 else '$0189', v['site'], len(v['records'])))
for k, v in T['tables'].items():
    b, s = K(k); add(b, s, s + 2 * len(v), 'data', 2, 'inline jump table (%d words; tools/kitty_trace.py)' % len(v))
for k, n in T.get('args', {}).items():
    b, s = K(k); add(b, s + 3, s + 3 + n, 'data', n, 'inline arguments of the call at %s' % k)
done = set()
for x in sites:
    if not (x['src_bank'] and x['src'] and x['len']): continue
    b, s, n = int(x['src_bank'], 16), int(x['src'], 16), int(x['len'], 16)
    if s >= 0x8000 or n == 0 or (b, s, n) in done: continue
    end = min(s + n, 0x4000 if s < 0x4000 else 0x8000); done.add((b, s, n))
    if x['dst_kind'] == 'tiles': add(b, s, end, 'data', 16, 'Gfx: tiles copied to %s by %s:%s ($%s, %d bytes)' % (x['dst'], x['bank'], x['site'], x['routine'], n))
    elif x['dst_kind'] == 'map':
        wd = 32 if n % 32 == 0 else 20 if n % 20 == 0 else ''
        add(b, s, end, 'data', wd, 'Map: tile map copied to %s by %s:%s ($%s, %d bytes)' % (x['dst'], x['bank'], x['site'], x['routine'], n))
    else: add(b, s, end, 'data', '', '%s data copied to %s by %s:%s ($%s, %d bytes)' % (x['dst_kind'], x['dst'], x['bank'], x['site'], x['routine'], n))
# a code byte is never re-typed as data: drop rows that overlap proven code
cbytes = set()
for (b, ad), n in code.items():
    for i in range(n): cbytes.add((b, ad + i))
out = []; dropped = 0
for b, s, e, t, wd, note in sorted(rows, key=lambda r: (r[0], r[1], -r[2])):
    if any((b, i) in cbytes for i in range(s, e)): dropped += 1; continue
    out.append(['%02X' % b, '%04X' % s, '%04X' % e, t, wd, note])
# observed rows: only the parts that no code byte holds (a read of an instruction byte is the code itself, or an inline table)
obs_out = []
for b, s, e, t, wd, note in obs_rows:
    i = s
    while i < e:
        if (b, i) in cbytes: i += 1; continue
        j = i
        while j < e and (b, j) not in cbytes: j += 1
        obs_out.append(['%02X' % b, '%04X' % i, '%04X' % j, t, wd, note]); i = j
out = obs_out + out
with open(a.types, 'w', newline='') as f:
    w = csv.writer(f); w.writerow(['bank', 'start', 'end', 'type', 'width', 'note']); w.writerows(out)
c = collections.Counter(x['dst_kind'] or '?' for x in sites); full = sum(1 for x in sites if x['src_bank'] and x['src'] and x['len'])
print('kitty_types: %d copy sites (%s), %d with constant bank / source / length; %d type rows written, %d dropped (overlap code)' % (len(sites), dict(c), full, len(out), dropped))

if a.rommap:
    N = len(ROM); cls = bytearray(b'R' * N)
    for (b, ad) in (K(k) for k in T.get('inline', {})): cls[off(b, ad)] = ord('T')
    for (b, ad), n in code.items():
        for i in range(n): cls[off(b, ad) + i] = ord('C')
    with open(a.rommap, 'w', newline='') as f:
        w = csv.writer(f, lineterminator='\n'); w.writerow(['bank', 'start', 'length', 'class']); i = 0
        while i < N:
            j = i
            while j < N and cls[j] == cls[i] and (j >> 14) == (i >> 14): j += 1
            b = i >> 14; ad = i if b == 0 else (i & 0x3FFF) + 0x4000
            w.writerow(['%02x' % b, '%04x' % ad, j - i, chr(cls[i])]); i = j

if a.names:
    lab = {}
    for b, s_, e, t, wd, note in sorted(rows + [[int(r[0], 16), int(r[1], 16), int(r[2], 16), r[3], r[4], r[5]] for r in obs_out], key=lambda r: (r[0], r[1], -r[2])):
        if any((b, i) in cbytes for i in range(s_, e)): continue
        kind = note.split(':')[0]
        nm = ('Gfx' if kind == 'Gfx' else 'Map' if kind == 'Map' else 'FarJumpTable' if note.startswith('jump table read through $01A0') else
              'JumpTable' if 'jump table' in note else None if note.startswith('inline arguments') else 'Data')
        if nm and (b, s_) not in lab: lab[(b, s_)] = ('%s_%02X_%04X' % (nm, b, s_), note)
    lab[(0, 0x0D00)] = ('ModeTable', 'the 31 {lo, hi, bank} mode entries read by the main loop through $01A0 at 00:0CFD (hFF8D = mode)')
    with open(a.names, 'w', newline='') as f:
        w = csv.writer(f); w.writerow(['bank', 'addr', 'name', 'conf', 'note', 'source'])
        for (b, s_), (nm, note) in sorted(lab.items()): w.writerow(['%02X' % b, '%04X' % s_, nm, 'C', note, 'kitty_types'])
    print('names: %d block labels' % len(lab))
