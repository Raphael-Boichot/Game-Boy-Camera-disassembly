# Emulator coverage run (README section 13)

A purpose-built SM83 core plus the scripts that drove it over the Pocket Camera (Japan) Rev A ROM, and every result table.
**You must supply the ROM** (`../pocketcamera_jp.gb`, md5 `fdcfe686cf4df461e870b6e53b2b5a8b`) or set `GBCAM_ROM`.

## Layout

| folder / file | content |
|---|---|
| `src/gbcov.c`, `src/gbcov.py`, `src/paths.py` | the core (C, ~460 lines), its `ctypes` wrapper, default paths (override with `GBCAM_ROM`, `GBCAM_TRACE`, `GBCAM_ROOTS`, `GBCAM_SYM`, `GBCAM_SAVES`) |
| `build.sh` | builds the shared library (Linux / macOS `cc`; Windows MinGW `gcc`, see the comment in the script) |
| `tools/` | 19 scripts: `coverage_run.py` (fuzzer), `sweep_auto.py`, `sweep_vars.py`, `settle_runs.py`, `long_runs.py`, `damaged_saves.py`, `make_hotspot_saves.py`, `replay_corpus.py`, `merge_states.py`, `coverage_report.py`, `rom_map.py`, `d1_map.py`, `gating_branches.py`, `state_graph.py`, `forced_legit.py`, `unexec_by_symbol.py`, `validate_calib.py`, `newcov.py`, `gbdis.py` |
| `final_merge.sh` | merge of pass folders + every report in one go |
| `saves/` | the 14 camera saves used as seeds; `saves_hotspot/`: the 9 saves with hotspot bytes (`make_hotspot_saves.py`) |
| `results/passes/*` | per pass: `cov.npz` (coverage), `stats.json`, `log.txt` |
| `results/corpus/*.jsonl.gz` | replayable key-sequence / poke entries (unzip a file to `corpus.jsonl` in its pass folder to resume or replay) |
| `results/merged_state/` | merged coverage of all passes |
| `results/report_v6/` | all tables: `coverage_report.md`, `roots_status.csv`, `rom_map*.csv/.md`, `data_bank_map.md/.csv`, `data_extents.csv`, `bank_callsites.csv`, `gating_*`, `unexec_components*.csv`, `state_graph.md`, `forced_legit.md`, `unexecuted_traced_runs.csv`, `merged_cov.npz` |
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
The static trace it is compared against is `../wram/trace_jp_v3.json` (from `../tools/rom_trace.py --roots ../tools/extra_roots.json`).
Results and caveats: README section 13.
