#!/usr/bin/env python3
"""Port the Japanese symbol tables to the international ROM (or another sibling build), in one run.

  tools/port_build.py JP.gb OTHER.gb [--dir roms/us_eu] [--suffix us] [--sym gbcam_us.sym] [--mgbdis /home/claude/tc/mgbdis/mgbdis.py]

Steps (each writes into --dir; see each script's docstring):
  1. tools/port_map.py           byte map JP -> other (port/map_segments_<s>.csv, port/map_inserted_<s>.csv, port/map_<s>.npy, not committed)
  2. tools/port_trace_config.py  tracer addresses, roots and first-pass labels through the map (trace/trace_config_<s>.json,
                                 trace/extra_roots_<s>.json (+ trace/extra_roots_<s>_hand.json), trace/rom_trace_labels_<s>.sym)
  3. tools/rom_trace.py          static trace of the other ROM with that config (trace/trace_<s>.json)
  4. tools/port_code_map.py      instruction pairs JP -> other (port/code_map_<s>.csv)
  5. tools/port_syms.py          the port layer of names and type rows (disasm/layers/sym_names_<s>_port.csv, sym_types_<s>_port.csv,
                                 port/port_report_<s>.csv)
  5b. tools/port_assets.py      names and type rows of the blocks this build's own copy calls load (disasm/layers/sym_*_<s>_loaders.csv)
      (the reads, checked and hand layers of disasm/layers/ are written by hand runs of tools/port_reads.py, tools/port_check_names*.py
      and by hand, never here; they are kept across re-ports)
  6. tools/merge_name_layers.py  the final tables disasm/sym_names_<s>.csv / sym_types_<s>.csv (port < loaders < reads < checked < hand);
     tools/sym_build.py          the symbol file (<dir>/<sym>) from them
  7a. tools/port_diff_bytes.py, tools/port_layout_kinds.py, tcrf_check/tools/rom_layout_map.py: the picture <dir>/<s>_rom_layout_map.png
      (kind of every byte, no outline: the differences go to a text summary) and layout_by_bank_<s>.csv
  7. tools/port_queue.py         hand-work queue (port/hand_queue_<s>.csv); tools/port_cov.py: the Japanese coverage through the maps (port/cov_jp_in_<s>.npz)
  7b. tools/wram_db.py + tools/port_l4.py (L4 tables: RAM names, access sites, constants) and tools/state_names.py (the state constants
      of this build's own state tables and handler labels)
  8. with --mgbdis: mgbdis + rgbasm round trip, plain, after `sym_fix.py --tables`, and after `--tables --const` with this build's L4 tables;
     prints the md5 and the raw RAM operands left (rgbds in PATH or RGBDS=)
Hand corrections of names go into disasm/layers/sym_names_<s>_hand.csv (the last layer; also read by state_names.py), type rows into
disasm/layers/sym_types_<s>_hand.csv; never edit disasm/sym_names_<s>.csv / sym_types_<s>.csv or the port layer (regenerated).
"""
import argparse, subprocess, sys, os, shutil, hashlib, csv, tempfile
ap = argparse.ArgumentParser()
ap.add_argument('jp'); ap.add_argument('other')
ap.add_argument('--dir', default='roms/us_eu'); ap.add_argument('--suffix', default='us'); ap.add_argument('--sym', default='gbcam_us.sym')
ap.add_argument('--title', default='Game Boy Camera (USA, Europe)'); ap.add_argument('--no-map', action='store_true', help='do not draw the layout map (tools/status_maps.py draws it for the Gold, Hello Kitty and prototype folders)')
ap.add_argument('--mgbdis', default=None); ap.add_argument('--keep', default=None, help='directory for the round-trip listings')
a = ap.parse_args()
D, S = a.dir, a.suffix; P = os.path.join(D, 'port'); TP = os.path.join(D, 'trace'); LY = os.path.join(D, 'disasm', 'layers')
for _d in (P, TP, LY): os.makedirs(_d, exist_ok=True)
py = sys.executable
def run(*args):
    print('$', ' '.join(args), flush=True); r = subprocess.run(args)
    if r.returncode: sys.exit('failed: %s' % args[1])
npy = os.path.join(P, 'map_%s.npy' % S)
run(py, 'tools/port_map.py', a.jp, a.other, '--out', os.path.join(P, 'map_segments_%s.csv' % S), '--inserted', os.path.join(P, 'map_inserted_%s.csv' % S), '--npz', npy)
run(py, 'tools/port_trace_config.py', a.jp, a.other, npy, TP)
roots, labels, tconf = (os.path.join(TP, f % S) for f in ('extra_roots_%s.json', 'rom_trace_labels_%s.sym', 'trace_config_%s.json'))
for _f, _t in (('extra_roots.json', roots), ('rom_trace_labels.sym', labels), ('trace_config.json', tconf)): os.replace(os.path.join(TP, _f), _t)
hroots = os.path.join(TP, 'extra_roots_%s_hand.json' % S)              # hand roots of this build (dead leftovers), kept across re-ports
if os.path.exists(hroots):
    import json as _j
    _r = _j.load(open(roots)) + _j.load(open(hroots)); _j.dump(_r, open(roots, 'w'), indent=0)
trace = os.path.join(TP, 'trace_%s.json' % S)
run(py, 'tools/rom_trace.py', a.other, labels, trace, '--roots', roots, '--config', tconf)
cmap = os.path.join(P, 'code_map_%s.csv' % S)
run(py, 'tools/port_code_map.py', a.jp, a.other, 'roms/jp_rev_a/trace/trace_jp.json', trace, cmap)
run(py, 'tools/port_syms.py', a.jp, a.other, npy, cmap, trace, LY, '--suffix', S)
os.replace(os.path.join(LY, 'port_report_%s.csv' % S), os.path.join(P, 'port_report_%s.csv' % S))
for _k in ('names', 'types'): os.replace(os.path.join(LY, 'sym_%s_%s.csv' % (_k, S)), os.path.join(LY, 'sym_%s_%s_port.csv' % (_k, S)))
portn = os.path.join(LY, 'sym_names_%s_port.csv' % S)
sym = os.path.join(D, a.sym)
hand = os.path.join(LY, 'sym_names_%s_hand.csv' % S)          # hand layer: kept across re-ports, applied last
extra = ['--extra-names', hand] if os.path.exists(hand) else []
ldn, ldt = os.path.join(LY, 'sym_names_%s_loaders.csv' % S), os.path.join(LY, 'sym_types_%s_loaders.csv' % S)
run(py, 'tools/port_assets.py', a.other, trace, cmap, portn, *([hand] if extra else []), '--out-names', ldn, '--out-types', ldt)
run(py, 'tools/merge_name_layers.py', '--tag', S, '--dir', D)                # final tables: every layer of disasm/layers/ in the fixed order
finaln, finalt = os.path.join(D, 'disasm', 'sym_names_%s.csv' % S), os.path.join(D, 'disasm', 'sym_types_%s.csv' % S)
run(py, 'tools/sym_build.py', a.other, '--names', finaln, '--types', finalt, '--trace', trace, '--out', sym, '--report')
# L4: RAM access table of this build's own trace (added for the new code), the carried L4 tables, the state constants of this build's tables
run(py, 'tools/wram_db.py', a.other, trace, labels, os.path.join(P, 'wram_fresh_%s' % S))
run(py, 'tools/port_l4.py', a.jp, a.other, npy, cmap, D, '--suffix', S, '--fresh-access', os.path.join(P, 'wram_fresh_%s_access.csv' % S))
for f in ('wram_fresh_%s_access.csv' % S, 'wram_fresh_%s_summary.csv' % S): os.remove(os.path.join(P, f))
run(py, 'tools/state_names.py', '--rom', a.other, '--names', portn, *extra, '--sym', sym,
    '--shared', os.path.join(D, 'disasm', 'state_shared_%s.csv' % S), '--out', os.path.join(D, 'disasm', 'state_names_%s.csv' % S))
run(py, 'tools/port_cov.py', npy, cmap, os.path.join(P, 'cov_jp_in_%s.npz' % S))        # the Japanese runs through the maps, for rom_operands.py (L5)
run(py, 'tools/port_diff_bytes.py', a.jp, a.other, npy, cmap, trace, os.path.join(P, 'diff_%s.npz' % S), '--rommap', os.path.join(TP, 'rom_map_%s.csv' % S))
os.makedirs(os.path.join(D, 'assets'), exist_ok=True)
run(py, 'tools/port_layout_kinds.py', a.jp, a.other, os.path.join(P, 'port_report_%s.csv' % S), os.path.join(D, 'assets', 'layout_kind_overrides_%s.csv' % S))
if not a.no_map:
  run(py, 'tcrf_check/tools/rom_layout_map.py', os.path.join(D, '%s_rom_layout_map.png' % S), '--rom', a.other, '--map', os.path.join(TP, 'rom_map_%s.csv' % S), '--assets', 'none',
    '--witness', 'none', '--reach', 'none', '--unused', 'none', '--kinds', os.path.join(D, 'assets', 'layout_kind_overrides_%s.csv' % S),
      '--names', finaln, '--types', finalt,
      *(['--cov', os.path.join(P, 'cov_jp_in_%s.npz' % S)] if os.path.exists(os.path.join(P, 'cov_jp_in_%s.npz' % S)) else []),
      '--diff', os.path.join(P, 'diff_%s.npz' % S), '--csv', os.path.join(D, 'assets', 'layout_by_bank_%s.csv' % S),
      '--outline', 'none', '--title', a.title + ': what is in each of the 64 banks (the ROM drawn as 2bpp tiles)')
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
          '--const-sounds', dd % 'sound_names', '--state-names', dd % 'state_names', '--state-helpers', dd % 'state_helpers']
    if os.path.exists(dd % 'text_tables') and os.path.exists(os.path.join(D, 'disasm', 'charmap_%s.inc' % S)):     # L6: the text tables of this build, its charmap and the Japanese kana one (leftovers)
        l4 += ['--text-tables', dd % 'text_tables', '--charmap', os.path.join(D, 'disasm', 'charmap_%s.inc' % S) + ',' + os.path.join('roms', 'jp_rev_a', 'disasm', 'charmap_jp.inc')]
    else: l4 += ['--text-tables', 'none']
    def raw_ram(d):
        import re, glob
        w = h = 0
        for fn in glob.glob(os.path.join(d, 'bank_*.asm')):
            for l in open(fn, encoding='utf-8'):
                if re.match(r'^\s+(?!db|dw)[a-z].*\$[cd][0-9a-f]{3}\b', l) and 'not a RAM address' not in l: w += 1      # the ram_exclude constants are marked by sym_fix.py
                if re.match(r'^\s+ldh? .*\[\$ff[89a-f][0-9a-f]\]', l): h += 1
        return w, h
    for tag, fix in (('plain', None), ('tables', ['--tables', '--far-helpers', helpers]), ('const', ['--tables', '--far-helpers', helpers] + l4)):
        out = os.path.join(work, 'out_' + tag); shutil.rmtree(out, ignore_errors=True)
        subprocess.run([py, a.mgbdis, '--overwrite', '--print-hex', '--output-dir', out, os.path.join(work, base + '.gb')], check=True, capture_output=True)
        if fix: run(py, 'tools/sym_fix.py', out, '--rom', os.path.join(work, base + '.gb'), '--sym', os.path.join(work, a.sym), '--trace', trace, *fix)
        if tag == 'const': print('L4 listing: %d raw WRAM operands and %d raw HRAM operands left (the ram_exclude constants not counted)' % raw_ram(out))
        env = dict(os.environ); env['PATH'] = (rgb + os.pathsep if rgb else '') + env['PATH']
        subprocess.run(['make'], cwd=out, env=env, check=True, capture_output=True)
        print('round trip %-6s md5 %s' % (tag, hashlib.md5(open(os.path.join(out, 'game.gb'), 'rb').read()).hexdigest()))
