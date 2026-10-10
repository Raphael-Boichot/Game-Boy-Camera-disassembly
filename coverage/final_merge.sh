#!/bin/bash
# Rebuild the merged coverage and every report table from the per-pass results.
# Usage (from this folder):  ./final_merge.sh MERGED_DIR REPORT_DIR PASS_DIR...
#   e.g.  ./final_merge.sh /tmp/merged /tmp/report results/passes/*
# PASS_DIR = a folder with cov.npz (the order only decides which pass is credited as "first reader" of a byte).
set -e
cd "$(dirname "$0")"
M=$1; R=$2; shift 2
python3 tools/merge_states.py "$M" "$@"
mkdir -p "$R"
python3 tools/coverage_report.py "$R" "$M/cov.npz" > "$R/coverage_report.stdout"
python3 tools/rom_map.py "$R" "$R/merged_cov.npz"
python3 tools/d1_map.py "$R" "$M/cov.npz"
python3 tools/unexec_by_symbol.py "$M/cov.npz" > "$R/unexec_by_symbol.txt" || true
python3 tools/gating_branches.py "$R" "$M/cov.npz" > /dev/null
GBCAM_BASE=oex python3 tools/gating_branches.py "$R" "$M/cov.npz" > /dev/null
python3 tools/state_graph.py "$R" "$M/cov.npz" > "$R/state_graph.stdout"
python3 tools/forced_legit.py "$R" "$M/cov.npz" > /dev/null
echo "reports in $R"
