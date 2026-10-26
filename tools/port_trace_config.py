#!/usr/bin/env python3
"""Carry the Japanese tracer inputs to another build through the address map of tools/port_map.py.

  tools/port_trace_config.py JP.gb OTHER.gb MAP.npy OUTDIR [--roots tools/extra_roots.json] [--labels tools/rom_trace_labels.sym]

Writes OUTDIR/trace_config.json (the CFG addresses of tools/rom_trace.py, the callback helpers, the hand-resolved `jp hl`
sites and the HRAM image), OUTDIR/extra_roots.json and OUTDIR/rom_trace_labels.sym, and prints every input that does not
map. A code address is carried only if the byte it points to is the same opcode in both ROMs (checked); a table address
only needs to map (its content may differ).
"""
import sys, json, re, argparse
import numpy as np
sys.path.insert(0, __import__('os').path.dirname(__file__))
import rom_trace as RT

ap = argparse.ArgumentParser()
ap.add_argument('jp'); ap.add_argument('other'); ap.add_argument('map'); ap.add_argument('outdir')
ap.add_argument('--roots', default='tools/extra_roots.json'); ap.add_argument('--labels', default='tools/rom_trace_labels.sym')
a = ap.parse_args()
JP = open(a.jp, 'rb').read(); OT = open(a.other, 'rb').read(); M = np.load(a.map)
def off(b, ad): return ad if ad < 0x4000 else b * 0x4000 + ad - 0x4000
lost = []
def mp(b, ad, code=True, why=''):
    if ad < 0x4000: b = 0
    o = off(b, ad); t = int(M[o])
    if t < 0 or (code and JP[o] != OT[t]):
        lost.append('%02X:%04X %s %s' % (b, ad, 'unmapped' if t < 0 else 'opcode %02X -> %02X' % (JP[o], OT[t]), why)); return None
    return t if t < 0x4000 else (t & 0x3FFF) + 0x4000

C = RT.CFG; cfg = {}
for k in ('farcall', 'farjump', 'modecall'): cfg[k] = mp(0, C[k], True, k)
for k in ('modetable', 'irq_table', 'serial_table'): cfg[k] = mp(0, C[k], False, k)
cfg['irq_table_n'] = C['irq_table_n']
b0, t0 = C['bank0a_table']; cfg['bank0a_table'] = [b0, mp(b0, t0, False, 'bank0a_table')]
cfg['sound_bank'] = C['sound_bank']; cfg['sound_tables'] = [[mp(C['sound_bank'], t, False, 'sound table'), n] for t, n in C['sound_tables']]
cfg['callback_helpers'] = {str(b): {str(mp(b, ad, True, 'callback helper')): op for ad, op in d.items()} for b, d in RT.CALLBACK_HELPERS.items()}
cfg['resolved_jphl'] = []
for (b, ad), why in RT.RESOLVED_JPHL.items():
    t = mp(b, ad, True, 'resolved jp hl')
    if t is not None: cfg['resolved_jphl'].append([b, t, 'JP %02X:%04X: %s' % (b, ad, why)])
cfg['ram_images'] = {str(k): [v[0], mp(v[0], v[1], True, 'ram image')] for k, v in RT.RAM_IMAGES.items()}
roots = []
for r in json.load(open(a.roots)):
    t = mp(r[0], r[1], True, 'root: ' + r[2][:60])
    if t is not None: roots.append([r[0] if t >= 0x4000 else 0, t, 'JP %02X:%04X: %s' % (r[0], r[1], r[2])])
labs = []
for l in open(a.labels):
    m = re.match(r'([0-9a-f]+):([0-9a-f]{4}) (\S+)$', l.strip())
    if not m: continue
    b, ad, nm = int(m[1], 16), int(m[2], 16), m[3]
    t = mp(b, ad, not nm.startswith('.data'), 'label ' + nm)
    if t is not None: labs.append('%02x:%04x %s' % (b if t >= 0x4000 else 0, t, nm))
import os; os.makedirs(a.outdir, exist_ok=True)
json.dump(cfg, open(os.path.join(a.outdir, 'trace_config.json'), 'w'), indent=1)
json.dump(roots, open(os.path.join(a.outdir, 'extra_roots.json'), 'w'), indent=0)
open(os.path.join(a.outdir, 'rom_trace_labels.sym'), 'w').write('\n'.join(labs) + '\n')
print('config', {k: (hex(v) if isinstance(v, int) else v) for k, v in cfg.items() if k in ('farcall', 'farjump', 'modecall', 'modetable', 'irq_table', 'serial_table', 'bank0a_table')})
print('roots %d, labels %d, not carried %d' % (len(roots), len(labs), len(lost)))
for x in lost: print('  not carried:', x)
