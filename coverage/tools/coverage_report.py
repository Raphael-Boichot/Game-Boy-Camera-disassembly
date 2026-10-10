#!/usr/bin/env python3
"""Merge coverage checkpoints and compare with the static trace. Usage: coverage_report.py OUTDIR cov1.npz [cov2.npz ...]"""
import sys as _s, os as _o
_s.path.insert(0, _o.path.join(_o.path.dirname(_o.path.abspath(__file__)), '..', 'src'))
import paths
import sys, os, json, csv, collections
import numpy as np
OUT = sys.argv[1]; files = sys.argv[2:]
os.makedirs(OUT, exist_ok=True)
TRACE = paths.TRACE
ROOTS = paths.ROOTS
ROMSZ = 1 << 20

def flat(b, a): return a if b == 0 and a < 0x4000 else b * 0x4000 + (a - 0x4000)
def unflat(f): return (0, f) if f < 0x4000 else (f >> 14, 0x4000 + (f & 0x3FFF))
def fmt(f): b, a = unflat(f); return '%02X:%04X' % (b, a)

# ---- merge
ex = np.zeros(ROMSZ, np.uint8); dr = np.zeros(ROMSZ, np.uint8); rdr = np.zeros(ROMSZ, np.uint32); ram = np.zeros(0x10000, np.uint8)
oex = np.zeros(ROMSZ, np.uint8); odr = np.zeros(ROMSZ, np.uint8); oram = np.zeros(0x10000, np.uint8)
bsel = collections.Counter(); bsel_o = collections.Counter(); cs = collections.Counter(); cs_o = collections.Counter()
for f in files:
    d = np.load(f)
    e = d['ex']; ex = np.where((ex == 1) | (e == 1), 1, np.where((ex | e) != 0, 2, 0)).astype(np.uint8)
    dr |= d['dr']; ram |= d['ram']
    e2 = d['oex'] if 'oex' in d.files else d['ex']; oex = np.where((oex == 1) | (e2 == 1), 1, np.where((oex | e2) != 0, 2, 0)).astype(np.uint8)
    odr |= (d['odr'] if 'odr' in d.files else d['dr']); oram |= (d['oram'] if 'oram' in d.files else d['ram'])
    for wb, pc, nb, c in (d['bsel_org'] if 'bsel_org' in d.files else d['bsel']): bsel_o[(int(wb), int(pc), int(nb))] += int(c)
    if 'csite' in d.files:
        for k, c in d['csite']: cs[int(k)] += int(c)
        for k, c in d['csite_org']: cs_o[int(k)] += int(c)
    r = d['rdr']; rdr = np.where(rdr != 0, rdr, r)
    for wb, pc, nb, c in d['bsel']: bsel[(int(wb), int(pc), int(nb))] += int(c)

# ---- trace
t = json.load(open(TRACE))
code = t['code']
instr = np.zeros(ROMSZ, bool); inbytes = np.zeros(ROMSZ, bool); tabbytes = np.zeros(ROMSZ, bool)
for k, n in code.items():
    b, a = k.split(':'); f = flat(int(b, 16), int(a, 16))
    if n > 0: instr[f] = True; inbytes[f:f + n] = True
    else: tabbytes[f:f + (-n)] = True
roots = json.load(open(ROOTS))
ROM = open(paths.ROM, 'rb').read()

lines = []
def P(s=''): lines.append(s)

# ---- 1. per-bank executed vs traced
P('# Coverage report (merged from %d checkpoint(s))\n' % len(files))
P('Executed ROM bytes (opcode+operand): **%d**; ROM bytes read as data: **%d**; RAM addresses executed: **%d**\n' % ((ex != 0).sum(), (dr != 0).sum(), (ram != 0).sum()))
P('Static trace: %d instruction starts, %d code bytes, %d table-word bytes.\n' % (instr.sum(), inbytes.sum(), tabbytes.sum()))
P('## 1. Traced instructions executed, per bank\n')
P('| bank | traced instr | executed (any) | % | organic (inputs only) | forced-state only | never | traced code bytes |')
P('|---|---|---|---|---|---|---|---|')
tot_i = tot_e = 0
for b in range(64):
    lo = 0 if b == 0 else b * 0x4000; hi = lo + 0x4000
    ti = int(instr[lo:hi].sum())
    if ti == 0 and not (ex[lo:hi] != 0).any(): continue
    ee = int(((ex[lo:hi] == 1) & instr[lo:hi]).sum()); oo = int(((oex[lo:hi] == 1) & instr[lo:hi]).sum()); tot_i += ti; tot_e += ee; tot_o = globals().get('tot_o', 0) + oo; globals()['tot_o'] = tot_o
    P('| %02X | %d | %d | %.1f | %d (%.1f%%) | %d | %d | %d |' % (b, ti, ee, 100.0 * ee / max(ti, 1), oo, 100.0 * oo / max(ti, 1), ee - oo, ti - ee, int(inbytes[lo:hi].sum())))
P('| **all** | %d | %d | %.1f | %d (%.1f%%) | %d | %d | |\n' % (tot_i, tot_e, 100.0 * tot_e / max(tot_i, 1), tot_o, 100.0 * tot_o / max(tot_i, 1), tot_e - tot_o, tot_i - tot_e))
P('*organic* = reached by button input only from a real save (no memory pokes in the lineage); *forced-state only* = executed only after a run poked a RAM variable to satisfy/flip a logged exit condition or forced a mode (reachability not proven). Forced-state runs that left the known code were discarded, so the forced-state set contains no executed opcode outside the trace by construction.\n')

# ---- 2. executed but not in trace
opcode_exec = np.nonzero(oex == 1)[0]
notin = [f for f in opcode_exec if not instr[f]]
mid = [f for f in notin if inbytes[f]]
outside = [f for f in notin if not inbytes[f]]
P('## 2. Organically executed opcodes NOT at a traced instruction start\n')
P('Total %d: %d fall inside a traced instruction (mis-aligned entry / overlapping code), %d are outside any traced code (tracer gaps).\n' % (len(notin), len(mid), len(outside)))
with open(os.path.join(OUT, 'exec_not_in_trace.csv'), 'w', newline='') as fh:
    w = csv.writer(fh); w.writerow(['addr', 'flat', 'opcode', 'class', 'first_fetch_pc'])
    for f in notin:
        r = int(rdr[f]); fp = '%02X:%04X' % ((r >> 16) & 0xFF, r & 0xFFFF) if r else ''
        w.writerow([fmt(f), '%05X' % f, '%02X' % ROM[f], 'inside_instr' if inbytes[f] else 'outside', fp])
if outside:
    P('First outside-trace executed opcodes: ' + ', '.join(fmt(f) for f in outside[:40]) + ('…' if len(outside) > 40 else '') + '\n')

# ---- 3. roots
P('## 3. Static roots (extra_roots.json): executed or not\n')
hit = []; miss = []
for b, a, note in roots:
    f = flat(b, a)
    (hit if ex[f] == 1 else miss).append((b, a, note))
    org_hit = globals().setdefault('org_hit', set());
    if oex[f] == 1: org_hit.add((b, a))
P('%d roots executed (%d organically), %d never executed.\n' % (len(hit), len(org_hit), len(miss)))
P('| root | executed | note |'); P('|---|---|---|')
for b, a, note in sorted(hit + miss, key=lambda x: (x[0], x[1])):
    P('| %02X:%04X | %s | %s |' % (b, a, ('yes (organic)' if oex[flat(b, a)] == 1 else 'forced-state only') if ex[flat(b, a)] == 1 else '**no**', note.replace('|', '/')[:140]))
P()
with open(os.path.join(OUT, 'roots_status.csv'), 'w', newline='') as fh:
    w = csv.writer(fh); w.writerow(['root', 'executed', 'organic', 'note'])
    for b, a, note in sorted(hit + miss, key=lambda x: (x[0], x[1])): w.writerow(['%02X:%04X' % (b, a), int(ex[flat(b, a)] == 1), int(oex[flat(b, a)] == 1), note])

# ---- 4. never-executed traced instructions: group into functions? list contiguous runs per bank
P('## 4. Traced code never executed (contiguous runs of instruction starts, >= 16 bytes)\n')
unex = instr & (ex != 1)
runs = []; f = 0
idx = np.nonzero(unex)[0]
if len(idx):
    start = idx[0]; prev = idx[0]
    # extend by instruction length using code table
    for f in idx[1:]:
        if f - prev > 12: runs.append((start, prev)); start = f
        prev = f
    runs.append((start, prev))
big = [(s, e) for s, e in runs if e - s >= 16]
P('%d runs total, %d of >=16 bytes; bytes in never-executed traced instructions: %d\n' % (len(runs), len(big), int(sum(1 for f in idx))))
with open(os.path.join(OUT, 'unexecuted_traced_runs.csv'), 'w', newline='') as fh:
    w = csv.writer(fh); w.writerow(['start', 'end', 'span_bytes'])
    for s, e in runs: w.writerow([fmt(s), fmt(e), int(e - s + 1)])

# ---- 5. data reads outside traced code
data = (dr != 0) & ~inbytes
P('## 5. ROM bytes read as data (outside traced code)\n')
P('%d bytes in total.\n' % int(data.sum()))
def extents(mask, gap):
    idx = np.nonzero(mask)[0]; res = []
    if not len(idx): return res
    s = p = idx[0]
    for f in idx[1:]:
        if f - p > gap + 1 or (f >> 14) != (p >> 14) and not (f < 0x4000 and p < 0x4000): res.append((s, p)); s = f
        p = f
    res.append((s, p)); return res
ext = extents(data, 16)
with open(os.path.join(OUT, 'data_extents.csv'), 'w', newline='') as fh:
    w = csv.writer(fh); w.writerow(['start', 'end', 'span', 'bytes_read', 'bytes_read_organic', 'first_reader_of_first_byte', 'in_table_bytes'])
    for s, e in ext:
        r = int(rdr[s]); fp = '%02X:%04X' % ((r >> 16) & 0xFF, r & 0xFFFF) if r else ''
        w.writerow([fmt(s), fmt(e), int(e - s + 1), int(data[s:e + 1].sum()), int(((odr[s:e + 1] != 0) & ~inbytes[s:e + 1]).sum()), fp, int(tabbytes[s:e + 1].sum())])
P('Extents (gap<=16): %d, written to data_extents.csv.\n' % len(ext))
P('| bank | data-read bytes | extents | traced-code bytes | untraced&unread bytes |'); P('|---|---|---|---|---|')
for b in range(64):
    lo = 0 if b == 0 else b * 0x4000; hi = lo + 0x4000 if b else 0x4000
    dd = int(data[lo:hi].sum()); ne = sum(1 for s, e in ext if lo <= s < hi)
    other = int(((~inbytes[lo:hi]) & (~data[lo:hi])).sum())
    P('| %02X | %d | %d | %d | %d |' % (b, dd, ne, int(inbytes[lo:hi].sum()), other))
P()

# ---- 6. bank selects
P('## 6. ROM bank selection\n')
selected = collections.defaultdict(list)
for (wb, pc, nb), c in bsel.items(): selected[nb].append((wb, pc, c))
selected_o = collections.defaultdict(list)
for (wb, pc, nb), c in bsel_o.items(): selected_o[nb].append((wb, pc, c))
P('Banks selected at least once: %s\n' % ' '.join('%02X' % b for b in sorted(selected)))
P('Banks selected organically: %s\n' % ' '.join('%02X' % b for b in sorted(selected_o)))
P('Banks never selected: %s\n' % ' '.join('%02X' % b for b in range(64) if b not in selected))
nore = [0x2B, 0x2D, 0x2E, 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x37, 0x3A, 0x3B, 0x3C, 0x3D]
P('D1 banks (no static reference): ' + ', '.join('%02X:%s' % (b, ('%d site(s), %d organic' % (len(selected[b]), len(selected_o[b]))) if b in selected else 'NEVER') for b in nore) + '\n')
with open(os.path.join(OUT, 'bank_select.csv'), 'w', newline='') as fh:
    w = csv.writer(fh); w.writerow(['new_bank', 'writer_bank', 'writer_pc', 'count', 'count_organic'])
    for (wb, pc, nb), c in sorted(bsel.items(), key=lambda kv: (kv[0][2], kv[0][0], kv[0][1])): w.writerow(['%02X' % nb, '%02X' % wb, '%04X' % pc, c, bsel_o.get((wb, pc, nb), 0)])
P('| new bank | sites (writer bank:pc xcount) |'); P('|---|---|')
for b in sorted(selected): P('| %02X | %s |' % (b, ', '.join('%02X:%04X x%d' % (wb, pc, c) for wb, pc, c in sorted(selected[b])[:6]) + (' …' if len(selected[b]) > 6 else '')))
P()
# ---- 6b. call sites
def dec(k): return (k >> 30, (k >> 24) & 0x3F, (k >> 8) & 0xFFFF, k & 0xFF)
by_new = collections.defaultdict(list)
for k, c in cs.items():
    lv, cb, pc, nb = dec(k)
    if lv == 0: by_new[nb].append((cb, pc, c, cs_o.get(k, 0)))
with open(os.path.join(OUT, 'bank_callsites.csv'), 'w', newline='') as fh:
    w = csv.writer(fh); w.writerow(['new_bank', 'level', 'caller_bank', 'call_pc', 'count', 'count_organic'])
    for k, c in sorted(cs.items(), key=lambda kv: (dec(kv[0])[3], dec(kv[0])[0], dec(kv[0])[1], dec(kv[0])[2])):
        lv, cb, pc, nb = dec(k); w.writerow(['%02X' % nb, lv, '%02X' % cb if cb != 0x3F or lv == 0 else '?', '%04X' % pc, c, cs_o.get(k, 0)])
P('### 6b. Call sites that selected each D1 data bank (level 0 = nearest `call` on the stack when the bank register was written)\n')
P('| bank | call sites (caller bank:pc, count, organic count) |'); P('|---|---|')
for b in nore:
    sites = sorted(by_new.get(b, []), key=lambda x: -x[2])
    P('| %02X | %s |' % (b, '; '.join('%02X:%04X x%d (%d)' % (cb, pc, c, co) for cb, pc, c, co in sites[:8]) + (' …' if len(sites) > 8 else '') if sites else '(none recorded)'))
P()
# ---- 7. RAM exec
P('## 7. Code executed from RAM/HRAM\n')
P(', '.join('%04X' % a for a in np.nonzero(oram)[0]) or '(none)')
open(os.path.join(OUT, 'coverage_report.md'), 'w').write('\n'.join(lines) + '\n')
np.savez_compressed(os.path.join(OUT, 'merged_cov.npz'), ex=ex, dr=dr, rdr=rdr, ram=ram, oex=oex, odr=odr, oram=oram)
print('\n'.join(lines[:60]))
