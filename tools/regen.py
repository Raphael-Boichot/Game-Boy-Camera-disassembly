#!/usr/bin/env python3
"""Regenerate every derived file of a ROM, in dependency order, with one command (2026-11-14, owner: "something fishy with updating").

  tools/regen.py --kitty KITTY.gb --jp JP.gb [--from STEP] [--dry]
  tools/regen.py --proto PROTO.gb
  tools/regen.py --trees

Why: a new run (a coverage file, a BGB hit table, a forced run) changes the trace, the types, the names, the never-run tables, their
verdicts, the maps, the sheets, the doubts list and the figures the READMEs quote, and each has its own tool. Run by hand, a step
gets forgotten or runs in the wrong order (the verdict column of trace/red_kitty.csv needs red_classify, the verdicts, then
red_classify again), and a stale file or figure turns up days later. This tool runs the whole chain; then
tools/check_repo_consistency.py compares everything and tools/facts.py lists the figures to quote (tag them <!--f:KEY-->).

The expensive producers (core corpora, BGB campaigns, tools/kitty_core_paths.py, tools/kitty_puzzle.py --bgb) are not rerun: they
are the evidence. The deterministic core ones are (kitty_forced_runs.py, kitty_puzzle.py --core), and the checker reruns them too.
"""
import sys, os, glob, subprocess, argparse, time
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
ap = argparse.ArgumentParser(); ap.add_argument('--kitty'); ap.add_argument('--jp'); ap.add_argument('--proto'); ap.add_argument('--trees', action='store_true')
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
        ('sym', lambda: [PY, 'tools/sym_build.py', K, '--names', KD + 'disasm/sym_names_kitty.csv', '--types', KD + 'disasm/sym_types_kitty.csv', '--trace', KD + 'trace/trace_kitty.json',
                         '--out', KD + 'pocketcamera_kitty.sym', '--report']),
        ('doubts', lambda: [PY, 'tools/kitty_doubts.py']),
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
    ]

def proto_steps(Q):
    PD = 'roms/prototype_debagame/'
    return [
        ('red_classify', lambda: [PY, 'tools/red_classify.py', '--tag', 'proto', Q, '--out', PD + 'trace/red_proto.csv']),
        ('reach_map', lambda: [PY, 'tools/reach_map.py', '--tag', 'proto', Q, PD + 'proto_rom_reachability_map.png']),
        ('layout_map', lambda: [PY, 'tools/status_maps.py', '--proto', Q]),
        ('unused_table', lambda: [PY, 'tools/unused_table.py']),
        ('trees', lambda: [PY, 'tools/make_screen_trees.py']),
    ]

steps = []
if a.kitty:
    if not a.jp: sys.exit('regen: --kitty needs --jp (the Japanese ROM: the match tables and the names)')
    steps += [('kitty.' + n, f) for n, f in kitty_steps(a.kitty, a.jp)]
if a.proto: steps += [('proto.' + n, f) for n, f in proto_steps(a.proto)]
if a.trees and not (a.kitty or a.proto): steps += [('trees', lambda: [PY, 'tools/make_screen_trees.py'])]
if not steps: ap.error('nothing to do: give --kitty / --proto / --trees')
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
print('regen: done; now run tools/check_repo_consistency.py, and tools/facts.py for the figures to quote (tagged <!--f:KEY-->)')
