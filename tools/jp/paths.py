"""Where the tcrf_check tools find their inputs (2026-11-12, roadmap step 6): the repository layout first, the old working tree second.

The tools were written for a working tree laid out as <ROOT>/{package/coverage/src, package/trace/trace_jp.json, saves, saves_unl}
(CLAUDE.md). In the repository the core is coverage/src and the Japanese trace roms/jp_rev_a/trace/trace_jp.json; the saves are the
owner's and stay outside it. Each function returns the first path that exists; GBCAM_ROOT (the old working root, default the parent of
tcrf_check) and GBCAM_SAVES (a folder of .sav files) override.
"""
import os
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(os.path.dirname(HERE))
ROOT = os.environ.get('GBCAM_ROOT', os.path.dirname(HERE))
def _first(*cands):
    for c in cands:
        if os.path.exists(c): return c
    return cands[0]
def core_dir():
    return _first(os.path.join(ROOT, 'package', 'coverage', 'src'), os.path.join(REPO, 'coverage', 'src'))
def trace_jp():
    return _first(os.path.join(ROOT, 'package', 'trace', 'trace_jp.json'), os.path.join(REPO, 'roms', 'jp_rev_a', 'trace', 'trace_jp.json'))
def saves_dir():
    return _first(os.environ.get('GBCAM_SAVES', os.path.join(ROOT, 'package', 'coverage', 'saves')), os.path.join(ROOT, 'saves'), os.path.join(REPO, 'coverage', 'saves'))
