#!/usr/bin/env python3
"""Port the Japanese symbol tables to the international ROM (or another sibling build), in one run.

  tools/port_build.py JP.gb OTHER.gb [--dir roms/us_eu] [--suffix us] [--sym gbcam_usa_eu.sym] [--mgbdis /home/claude/tc/mgbdis/mgbdis.py]

Steps (each writes into --dir; see each script's docstring):
  1. tools/port_map.py           byte map JP -> other (port/map_segments_<s>.csv, port/map_inserted_<s>.csv, port/map_<s>.npy, not committed)
  2. tools/port_trace_config.py  tracer addresses, roots and first-pass labels through the map (port/)
  3. tools/rom_trace.py          static trace of the other ROM with that config (port/trace_<s>.json)
  4. tools/port_code_map.py      instruction pairs JP -> other (port/code_map_<s>.csv)
  5. tools/port_syms.py          names and type rows (disasm/sym_names_<s>.csv, disasm/sym_types_<s>.csv, port/port_report_<s>.csv)
  6. tools/sym_build.py          the symbol file (<dir>/<sym>)
  7. tools/port_queue.py         hand-work queue (port/hand_queue_<s>.csv)
  8. with --mgbdis: mgbdis + rgbasm round trip, plain and after `sym_fix.py --tables`; prints the md5 (rgbds in PATH or RGBDS=)
Later edits go into disasm/sym_names_<s>.csv / sym_types_<s>.csv by hand (rerunning step 5 overwrites them).
"""
import argparse, subprocess, sys, os, shutil, hashlib, csv, tempfile
ap = argparse.ArgumentParser()
ap.add_argument('jp'); ap.add_argument('other')
ap.add_argument('--dir', default='roms/us_eu'); ap.add_argument('--suffix', default='us'); ap.add_argument('--sym', default='gbcam_usa_eu.sym')
ap.add_argument('--mgbdis', default=None); ap.add_argument('--keep', default=None, help='directory for the round-trip listings')
a = ap.parse_args()
D, S = a.dir, a.suffix; P = os.path.join(D, 'port')
os.makedirs(P, exist_ok=True); os.makedirs(os.path.join(D, 'disasm'), exist_ok=True)
py = sys.executable
def run(*args):
    print('$', ' '.join(args), flush=True); r = subprocess.run(args)
    if r.returncode: sys.exit('failed: %s' % args[1])
npy = os.path.join(P, 'map_%s.npy' % S)
run(py, 'tools/port_map.py', a.jp, a.other, '--out', os.path.join(P, 'map_segments_%s.csv' % S), '--inserted', os.path.join(P, 'map_inserted_%s.csv' % S), '--npz', npy)
run(py, 'tools/port_trace_config.py', a.jp, a.other, npy, P)
trace = os.path.join(P, 'trace_%s.json' % S)
run(py, 'tools/rom_trace.py', a.other, os.path.join(P, 'rom_trace_labels.sym'), trace, '--roots', os.path.join(P, 'extra_roots.json'), '--config', os.path.join(P, 'trace_config.json'))
cmap = os.path.join(P, 'code_map_%s.csv' % S)
run(py, 'tools/port_code_map.py', a.jp, a.other, 'roms/jp_rev_a/wram/trace_jp_v3.json', trace, cmap)
run(py, 'tools/port_syms.py', a.jp, a.other, npy, cmap, trace, os.path.join(D, 'disasm'), '--suffix', S)
os.replace(os.path.join(D, 'disasm', 'port_report_%s.csv' % S), os.path.join(P, 'port_report_%s.csv' % S))
sym = os.path.join(D, a.sym)
run(py, 'tools/sym_build.py', a.other, '--names', os.path.join(D, 'disasm', 'sym_names_%s.csv' % S), '--types', os.path.join(D, 'disasm', 'sym_types_%s.csv' % S), '--trace', trace, '--out', sym, '--report')
run(py, 'tools/port_queue.py', a.other, trace, cmap, os.path.join(P, 'port_report_%s.csv' % S), sym, os.path.join(P, 'hand_queue_%s.csv' % S))
if a.mgbdis:
    far = {}
    for r in csv.DictReader(open(cmap)):
        if r['bank'] == '00': far[int(r['jp'], 16)] = r['other']
    helpers = ','.join(far[x] for x in (0x0450, 0x0479, 0x0586, 0x05F8, 0x069F, 0x08BB, 0x08C1))
    work = a.keep or tempfile.mkdtemp(); os.makedirs(work, exist_ok=True)
    base = os.path.splitext(a.sym)[0]
    shutil.copy(a.other, os.path.join(work, base + '.gb')); shutil.copy(sym, os.path.join(work, a.sym))
    rgb = os.environ.get('RGBDS', '')
    for tag, fix in (('plain', None), ('tables', ['--tables', '--far-helpers', helpers])):
        out = os.path.join(work, 'out_' + tag); shutil.rmtree(out, ignore_errors=True)
        subprocess.run([py, a.mgbdis, '--overwrite', '--print-hex', '--output-dir', out, os.path.join(work, base + '.gb')], check=True, capture_output=True)
        if fix: run(py, 'tools/sym_fix.py', out, '--rom', os.path.join(work, base + '.gb'), '--sym', os.path.join(work, a.sym), '--trace', trace, *fix)
        env = dict(os.environ); env['PATH'] = (rgb + os.pathsep if rgb else '') + env['PATH']
        subprocess.run(['make'], cwd=out, env=env, check=True, capture_output=True)
        print('round trip %-6s md5 %s' % (tag, hashlib.md5(open(os.path.join(out, 'game.gb'), 'rb').read()).hexdigest()))
