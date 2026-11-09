# Emulator coverage run (docs §13)

A purpose-built SM83 core plus the scripts that drove it over the Pocket Camera (Japan) Rev A ROM, and every result table.
**You must supply the ROM**: `src/paths.py` looks for `pocketcamera_jp.gb` (md5 `fdcfe686cf4df461e870b6e53b2b5a8b`) at the top of the repository; set `GBCAM_ROM` to use another path (and `GBCAM_TRACE`, `GBCAM_ROOTS`, `GBCAM_SYM` for another ROM: its `roms/<folder>/trace/` files).

This folder is the shared core and the archive of the Japanese runs; the merged result of each ROM's runs is copied into its own folder (`roms/jp_rev_a/trace/cov_jp_runs.npz`, `roms/<folder>/trace/cov_<tag>_runs.npz`; `HOWTO_NEW_ROM.md` section 0.1).

## Layout

| folder / file | content |
|---|---|
| `src/gbcov.c`, `src/gbcov.py`, `src/paths.py` | the core (C, ~460 lines), its `ctypes` wrapper, default paths (override with `GBCAM_ROM`, `GBCAM_TRACE`, `GBCAM_ROOTS`, `GBCAM_SYM`, `GBCAM_SAVES`) |
| `src/gbcov8.c` | the same core with a link-cable partner interface instead of the printer stand-in (`gb_link_enable`, `gb_run_link`, `gb_link_out`, `gb_link_sc`, `gb_link_sb`, `gb_link_set_rx`, `gb_link_deliver`): two instances driven by a host script exchange serial bytes; it produced the link runs of docs §14 and §15.1 (the host script is not kept) |
| `build.sh` | builds the shared library (Linux / macOS `cc`; Windows MinGW `gcc`, see the comment in the script) |
| `tools/` | 19 scripts: `coverage_run.py` (fuzzer), `sweep_auto.py`, `sweep_vars.py`, `settle_runs.py`, `long_runs.py`, `damaged_saves.py`, `make_hotspot_saves.py`, `replay_corpus.py`, `merge_states.py`, `coverage_report.py`, `rom_map.py`, `d1_map.py`, `gating_branches.py`, `state_graph.py`, `forced_legit.py`, `unexec_by_symbol.py`, `validate_calib.py`, `newcov.py`, `gbdis.py` |
| `final_merge.sh` | merge of pass folders + every report in one go |
| `saves/` | the 14 camera saves used as seeds (the 9 saves with hotspot bytes are written by `tools/make_hotspot_saves.py`); **not in the repository** (`.sav` files are never committed: they hold photos): make the folder and put the saves there, or set `GBCAM_SAVES` |
| `results/passes/*` | per pass: `cov.npz` (coverage), `stats.json`, `log.txt` |
| `results/corpus/*.jsonl.gz` | replayable key-sequence / poke entries (unzip a file to `corpus.jsonl` in its pass folder to resume or replay) |
| `results/merged_state/` | merged coverage of passes 1-9 |
| `results/report_v6/` | all tables of the merge of passes 1-9 (docs §13): `coverage_report.md`, `roots_status.csv`, `rom_map*.csv/.md`, `data_bank_map.md/.csv`, `data_extents.csv`, `bank_callsites.csv`, `gating_*`, `unexec_components*.csv`, `state_graph.md`, `forced_legit.md`, `unexecuted_traced_runs.csv`, `merged_cov.npz` |
| `v8/` | the final merge (docs §15.1): `merged_v8/` (merged coverage, corpus), `report_v8/` (the same tables as `report_v6/`; 57,582 of 60,449 traced instructions executed), `unlock_fuzz/` and `unlock_replay/` (runs from the unlocking saves, with `stats.json`) |
| `d1sheets/` | rendered 2bpp tile sheets of the 14 unreferenced data banks (and two montages) |

## Quick start

```bash
./build.sh                                           # core
python3 tools/validate_calib.py                      # expect: 16 match, 0 differ
python3 tools/gbdis.py 0A:6A52 12 results/report_v6/merged_cov.npz   # disassembly, executed instructions marked with *
./final_merge.sh /tmp/merged /tmp/report results/passes/*            # rebuild every table (about 10 s)
python3 tools/coverage_run.py --hours 1 --state /tmp/mystate         # a fresh fuzz run (resumable; state in the folder)
```

Definitions: **organic** = joypad input and an SRAM image only; **forced** = a RAM variable was written from outside or the mode byte was set. The core models the CPU, interrupts, timers, LCD timing (no rendering), joypad, serial with a minimal printer and the Pocket Camera mapper with a synthetic sensor image; it has no link partner, SGB or sound and has **not** been compared cycle-exactly with BGB or hardware.
The static trace it is compared against is `roms/jp_rev_a/trace/trace_jp.json` (from `tools/rom_trace.py --roots roms/jp_rev_a/trace/extra_roots_jp.json`; paths from the top of the repository).
Results and caveats: docs §13.
