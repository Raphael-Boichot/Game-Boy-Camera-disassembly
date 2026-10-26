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
  7b. tools/wram_db.py + tools/port_l4.py (L4 tables: RAM names, access sites, constants) and tools/state_names.py (the state constants
      of this build's own state tables and handler labels)
  8. with --mgbdis: mgbdis + rgbasm round trip, plain, after `sym_fix.py --tables`, and after `--tables --const` with this build's L4 tables;
     prints the md5 and the raw RAM operands left (rgbds in PATH or RGBDS=)
Hand corrections of names go into disasm/sym_names_<s>_hand.csv (applied last by sym_build.py --extra-names and by state_names.py).
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
hand = os.path.join(D, 'disasm', 'sym_names_%s_hand.csv' % S)          # hand layer: kept across re-ports, applied last
extra = ['--extra-names', hand] if os.path.exists(hand) else []
run(py, 'tools/sym_build.py', a.other, '--names', os.path.join(D, 'disasm', 'sym_names_%s.csv' % S), '--types', os.path.join(D, 'disasm', 'sym_types_%s.csv' % S), '--trace', trace, '--out', sym, '--report', *extra)
# L4: RAM access table of this build's own trace (added for the new code), the carried L4 tables, the state constants of this build's tables
run(py, 'tools/wram_db.py', a.other, trace, os.path.join(P, 'rom_trace_labels.sym'), os.path.join(P, 'wram_fresh_%s' % S))
run(py, 'tools/port_l4.py', a.jp, a.other, npy, cmap, D, '--suffix', S, '--fresh-access', os.path.join(P, 'wram_fresh_%s_access.csv' % S))
for f in ('wram_fresh_%s_access.csv' % S, 'wram_fresh_%s_summary.csv' % S): os.remove(os.path.join(P, f))
run(py, 'tools/state_names.py', '--rom', a.other, '--names', os.path.join(D, 'disasm', 'sym_names_%s.csv' % S), *extra, '--sym', sym,
    '--shared', os.path.join(D, 'disasm', 'state_shared_%s.csv' % S), '--out', os.path.join(D, 'disasm', 'state_names_%s.csv' % S))
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
    dd = os.path.join(D, 'disasm', '%s_' + S + '.csv')
    l4 = ['--const', '--ram-names', dd % 'ram_names', '--ram-access', os.path.join(D, 'wram', 'wram_access_%s.csv' % S), '--ram-exclude', dd % 'ram_exclude',
          '--ram-highbyte', dd % 'ram_highbyte', '--const-names', dd % 'const_names', '--const-types', dd % 'const_types', '--const-tables', dd % 'const_tables',
          '--const-sounds', dd % 'sound_names', '--state-names', dd % 'state_names', '--state-helpers', dd % 'state_helpers', '--text-tables', 'none']
    def raw_ram(d):
        import re, glob
        w = h = 0
        for fn in glob.glob(os.path.join(d, 'bank_*.asm')):
            for l in open(fn, encoding='utf-8'):
                if re.match(r'^\s+(?!db|dw)[a-z].*\$[cd][0-9a-f]{3}\b', l): w += 1
                if re.match(r'^\s+ldh? .*\[\$ff[89a-f][0-9a-f]\]', l): h += 1
        return w, h
    for tag, fix in (('plain', None), ('tables', ['--tables', '--far-helpers', helpers]), ('const', ['--tables', '--far-helpers', helpers] + l4)):
        out = os.path.join(work, 'out_' + tag); shutil.rmtree(out, ignore_errors=True)
        subprocess.run([py, a.mgbdis, '--overwrite', '--print-hex', '--output-dir', out, os.path.join(work, base + '.gb')], check=True, capture_output=True)
        if fix: run(py, 'tools/sym_fix.py', out, '--rom', os.path.join(work, base + '.gb'), '--sym', os.path.join(work, a.sym), '--trace', trace, *fix)
        if tag == 'const': print('L4 listing: %d raw WRAM operands and %d raw HRAM operands left' % raw_ram(out))
        env = dict(os.environ); env['PATH'] = (rgb + os.pathsep if rgb else '') + env['PATH']
        subprocess.run(['make'], cwd=out, env=env, check=True, capture_output=True)
        print('round trip %-6s md5 %s' % (tag, hashlib.md5(open(os.path.join(out, 'game.gb'), 'rb').read()).hexdigest()))
