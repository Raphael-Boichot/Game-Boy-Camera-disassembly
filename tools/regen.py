#!/usr/bin/env python3
"""Regenerate every derived file of a ROM, in dependency order, with one command (2026-11-14, owner: "something fishy with updating").

  tools/regen.py --kitty KITTY.gb --jp JP.gb [--from STEP] [--dry]
  tools/regen.py --proto PROTO.gb
  tools/regen.py --trees
  tools/regen.py --maps --jp JP.gb [--us US.gb] [--gold GOLD.gb] [--kitty KITTY.gb] [--proto PROTO.gb]   (only the maps)

Why: a new run (a coverage file, a BGB hit table, a forced run) changes the trace, the types, the names, the never-run tables, their
verdicts, the maps, the sheets, the doubts list and the figures the READMEs quote, and each has its own tool. Run by hand, a step
gets forgotten or runs in the wrong order (the verdict column of trace/red_kitty.csv needs red_classify, the verdicts, then
red_classify again), and a stale file or figure turns up days later. This tool runs the whole chain, then rewrites every tagged
figure of README.md, ROADMAP.md and roms/*/README.md (tools/facts.py --fix); tools/check_repo_consistency.py compares everything.

The expensive producers (core corpora, BGB campaigns, tools/kitty_core_paths.py, tools/kitty_puzzle.py --bgb) are not rerun: they
are the evidence. The deterministic core ones are (kitty_forced_runs.py, kitty_puzzle.py --core), and the checker reruns them too.
"""
import sys, os, glob, subprocess, argparse, time
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
ap = argparse.ArgumentParser(); ap.add_argument('--kitty'); ap.add_argument('--jp'); ap.add_argument('--proto'); ap.add_argument('--trees', action='store_true')
ap.add_argument('--maps', action='store_true', help='redraw only the layout and reachability maps of every ROM given (one set of rules: tools/rom_layout_map.py, tools/reach_draw.py)')
ap.add_argument('--us'); ap.add_argument('--gold')
ap.add_argument('--from', dest='start', default=None, help='skip the steps before this one'); ap.add_argument('--dry', action='store_true')
a = ap.parse_args()
PY = sys.executable

def kitty_steps(K, J):
    KD = 'roms/hello_kitty/'
    def obs(): return [x for f in sorted(glob.glob(os.path.join(REPO, KD, 'trace', 'cov_kitty_*.npz'))) for x in ('--observed', os.path.relpath(f, REPO))]
    return [
        ('forced_runs', lambda: [PY, 'tools/kitty_forced_runs.py', K]),
        ('puzzle_core', lambda: [PY, 'tools/kitty_puzzle.py', K, '--core']),
        ('trace', lambda: [PY, 'tools/kitty_trace.py', K, KD + 'trace/trace_kitty.json', '--roots', KD + 'trace/extra_roots_kitty.json', '--report', KD + 'trace/trace_kitty_unresolved.md'] + obs()),
        ('types', lambda: [PY, 'tools/kitty_types.py', K, KD + 'trace/trace_kitty.json', '--types', KD + 'disasm/sym_types_kitty.csv', '--sites', KD + 'assets/copy_sites_kitty.csv',
                           '--rommap', KD + 'trace/rom_map_kitty.csv', '--names', KD + 'disasm/layers/sym_names_kitty_auto.csv'] + obs()),
        ('match_jp', lambda: [PY, 'tools/kitty_match_jp.py', J, K, KD + 'disasm/match_jp_kitty.csv']),
        ('similar_jp', lambda: [PY, 'tools/kitty_similar_jp.py', J, K, KD + 'disasm/similar_jp_kitty.csv']),
        ('names', lambda: [PY, 'tools/kitty_names.py', '--rom', K, '--jp', J]),
        ('charset', lambda: [PY, 'tools/kitty_charset.py', K, J]),          # L6: the name / comment character set, checked glyph by glyph
        ('sym', lambda: [PY, 'tools/sym_build.py', K, '--names', KD + 'disasm/sym_names_kitty.csv', '--types', KD + 'disasm/sym_types_kitty.csv', '--trace', KD + 'trace/trace_kitty.json',
                         '--out', KD + 'pocketcamera_kitty.sym', '--report']),
        ('doubts', lambda: [PY, 'tools/kitty_doubts.py']),
        ('jp_counterparts', lambda: [PY, 'tools/kitty_jp_counterparts.py', K, J]),     # the Japanese counterpart of each name (owner's validation, 2026-11-22)
        ('l4', lambda: [PY, 'tools/kitty_l4.py', K, J]),                      # RAM / SRAM tables, RAM names, constants, the save checks
        ('red_classes', lambda: [PY, 'tools/kitty_red_classes.py', K]),
        ('red_classify', lambda: [PY, 'tools/red_classify.py', '--tag', 'kitty', K, '--out', KD + 'trace/red_kitty.csv']),
        ('verdicts', lambda: [PY, 'tools/kitty_red_verdicts.py']),
        ('red_classify_2', lambda: [PY, 'tools/red_classify.py', '--tag', 'kitty', K, '--out', KD + 'trace/red_kitty.csv']),     # the verdict column
        ('jp_crosscheck', lambda: [PY, 'tools/kitty_jp_crosscheck.py']),
        ('reach_map', lambda: [PY, 'tools/reach_map.py', '--tag', 'kitty', K, KD + 'kitty_rom_reachability_map.png']),
        ('layout_kinds', lambda: [PY, 'tools/kitty_layout_kinds.py', K]),
        ('layout_map', lambda: [PY, 'tools/status_maps.py', '--kitty', K]),
        ('unused_table', lambda: [PY, 'tools/unused_table.py']),
        ('unused_sheet', lambda: [PY, 'tools/kitty_unused_sheet.py', K]),
        ('highlights', lambda: [PY, 'tools/kitty_unused_highlights.py', K]),
        ('trees', lambda: [PY, 'tools/make_screen_trees.py']),
        ('source', lambda: [PY, 'tools/make_source.py', '--tree', 'hello_kitty', '--rom', K, '--check']),   # L5: the source tree (rgbds on the PATH)
    ]

def proto_steps(Q):
    PD = 'roms/prototype_debagame/'
    J = a.jp or '/root/work/roms/pocketcamera_jp.gb'                            # the printer library is matched against the Japanese ROM
    D = PD + 'disasm/'
    return [   # the chain of the checker (tools/check_repo_consistency.py, prototype), in its order (2026-11-15: regen had skipped the first steps)
        ('symtab', lambda: [PY, 'tools/proto_symtab.py', Q, '--out', D + 'leftover_symtab_proto.csv', '--out-mem', D + 'leftover_symtab_mem_proto.csv']),
        ('trace', lambda: [PY, 'tools/proto_trace.py', Q, PD + 'trace/trace_proto.json', '--roots', PD + 'trace/extra_roots_proto.json', '--report', PD + 'trace/trace_proto_unresolved.md']),
        ('types', lambda: [PY, 'tools/proto_types.py', Q, PD + 'trace/trace_proto.json', '--types', PD + 'disasm/sym_types_proto.csv', '--sites', PD + 'assets/copy_sites_proto.csv',
                           '--rommap', PD + 'trace/rom_map_proto.csv', '--names', PD + 'disasm/layers/sym_names_proto_auto.csv', '--symtab', PD + 'disasm/leftover_symtab_proto.csv']),   # with the hand type layer
        ('match_old', lambda: [PY, 'tools/proto_match_old.py', Q, D + 'leftover_symtab_proto.csv', PD + 'trace/trace_proto.json', D + 'match_old_proto.csv']),
        ('printer_lib', lambda: [PY, 'tools/proto_printer_lib.py', Q, J, '--symtab', D + 'leftover_symtab_proto.csv', '--out', D + 'printer_lib_proto.csv']),
        ('oldbuilds', lambda: [PY, 'tools/proto_oldbuilds.py', Q, '--symtab', D + 'leftover_symtab_proto.csv', '--printer-lib', D + 'printer_lib_proto.csv', '--out', D + 'oldbuilds_proto.csv']),
        ('names', lambda: [PY, 'tools/proto_names.py', '--rom', Q]),            # the name layers (the hand layer last) -> names, doubts, leftovers
        ('text', lambda: [PY, 'tools/proto_text.py', Q]),                     # L6: the menu font's character set and the screen texts
        ('history', lambda: [PY, 'tools/proto_build_history.py', Q]),         # L6: titles, routine sizes and addresses of the older builds
        ('ram_names', lambda: [PY, 'tools/proto_ram_names.py', Q, '--out', D + 'ram_names_proto.csv']),     # the RAM names (they quote routine names)
        ('ram_inc', lambda: [PY, 'tools/ram_names.py', '--names', D + 'ram_names_proto.csv', '--inc', D + 'ram_proto.inc', '--sym', PD + 'pocketcamera_proto_ram.sym']),
        ('sym', lambda: [PY, 'tools/sym_build.py', Q, '--names', PD + 'disasm/sym_names_proto.csv', '--types', PD + 'disasm/sym_types_proto.csv', '--trace', PD + 'trace/trace_proto.json',
                         '--out', PD + 'pocketcamera_proto.sym', '--report']),
        ('source', lambda: [PY, 'tools/make_source.py', '--tree', 'prototype_debagame', '--rom', Q, '--check']),   # L5: the source tree (rgbds on the PATH)
        ('red_classify', lambda: [PY, 'tools/red_classify.py', '--tag', 'proto', Q, '--out', PD + 'trace/red_proto.csv']),
        ('reach_map', lambda: [PY, 'tools/reach_map.py', '--tag', 'proto', Q, PD + 'proto_rom_reachability_map.png']),
        ('layout_map', lambda: [PY, 'tools/status_maps.py', '--proto', Q]),
        ('unused_table', lambda: [PY, 'tools/unused_table.py']),
        ('trees', lambda: [PY, 'tools/make_screen_trees.py']),
    ]

def map_steps():
    """Every layout and reachability map of the ROMs given, drawn by the two shared tools (owner 2026-11-15: one set of rules for every map:
    the same kind has the same colour in every ROM, a kind with no byte in a ROM leaves its legend, a few bytes read <0.1 %, never 0.0 %)."""
    st = []
    if a.jp:
        st += [('jp.layout_map', lambda: [PY, 'tools/rom_layout_map.py', 'roms/jp_rev_a/jp_rom_layout_map.png', '--rom', a.jp, '--csv', 'roms/jp_rev_a/assets/layout_by_bank_jp.csv']),
               ('jp.reach_map', lambda: [PY, 'tools/rom_reach_map.py', '--rom', a.jp, 'roms/jp_rev_a/jp_rom_reachability_map.png'])]
    if a.us:
        U = 'roms/us_eu/'
        st += [('us.layout_map', lambda: [PY, 'tools/rom_layout_map.py', U + 'us_rom_layout_map.png', '--rom', a.us, '--map', U + 'trace/rom_map_us.csv', '--assets', 'none', '--witness', 'none',
                                          '--reach', 'none', '--unused', 'none', '--kinds', U + 'assets/layout_kind_overrides_us.csv', '--names', U + 'disasm/sym_names_us.csv',
                                          '--types', U + 'disasm/sym_types_us.csv', '--diff', U + 'port/diff_us.npz', '--cov', U + 'port/cov_jp_in_us.npz', '--csv', U + 'assets/layout_by_bank_us.csv',
                                          '--outline', 'none', '--title', 'Game Boy Camera (USA, Europe): what is in each of the 64 banks (the ROM drawn as 2bpp tiles)']),
               ('us.reach_map', lambda: [PY, 'tools/reach_map.py', '--tag', 'us', a.us, U + 'us_rom_reachability_map.png'])]
    for t, f, r in (('gold', 'gold', a.gold), ('kitty', 'hello_kitty', a.kitty), ('proto', 'prototype_debagame', a.proto)):
        if r: st += [(t + '.layout_map', lambda t=t, r=r: [PY, 'tools/status_maps.py', '--' + t, r]),
                     (t + '.reach_map', lambda t=t, f=f, r=r: [PY, 'tools/reach_map.py', '--tag', t, r, 'roms/%s/%s_rom_reachability_map.png' % (f, t)])]
    return st
steps = []
if a.maps: steps = map_steps()
elif a.kitty:
    if not a.jp: sys.exit('regen: --kitty needs --jp (the Japanese ROM: the match tables and the names)')
    steps += [('kitty.' + n, f) for n, f in kitty_steps(a.kitty, a.jp)]
if a.proto and not a.maps: steps += [('proto.' + n, f) for n, f in proto_steps(a.proto)]
if a.trees and not (a.kitty or a.proto): steps += [('trees', lambda: [PY, 'tools/make_screen_trees.py'])]
if not steps: ap.error('nothing to do: give --kitty / --proto / --trees / --maps')
on = a.start is None
for name, cmd in steps:
    if not on and name.split('.')[-1] != a.start and name != a.start: continue
    on = True
    c = cmd(); print('regen: %-22s %s' % (name, ' '.join(c[1:])[:150]), flush=True)
    if a.dry: continue
    t = time.time(); r = subprocess.run(c, cwd=REPO, capture_output=True, text=True)
    last = (r.stdout.strip().split('\n') or [''])[-1][:160]
    if r.returncode: sys.exit('regen: %s failed:\n%s' % (name, (r.stderr or r.stdout)[-800:]))
    print('        %.0f s  %s' % (time.time() - t, last), flush=True)
if not a.dry:                                   # the tagged figures of the docs follow the files (tools/facts.py --fix, 2026-11-15)
    docs = ['README.md', 'ROADMAP.md'] + sorted(os.path.relpath(f, REPO) for f in glob.glob(os.path.join(REPO, 'roms', '*', 'README.md')))
    fx = [PY, 'tools/facts.py'] + (['--rom-kitty', a.kitty] if a.kitty else []) + (['--rom-proto', a.proto] if a.proto else []) + ['--fix'] + docs
    r = subprocess.run(fx, cwd=REPO, capture_output=True, text=True)
    for l in r.stdout.strip().split('\n'):
        if l and ' 0 figure(s)' not in l: print('regen: ' + l)
print('regen: done; now run tools/check_repo_consistency.py; a new figure to quote: tools/facts.py lists the keys (tag it <!--f:KEY-->)')
