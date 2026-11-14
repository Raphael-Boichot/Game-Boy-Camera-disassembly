# Japanese ROM: experiments and their results

AI slop, do not trust until human validation.

The results of the runs, probes and checks made on the Japanese Rev A ROM (and its international twin where a folder compares them),
moved here from `tcrf_check/assets/` on 2026-11-14 (owner: `tcrf_check/` keeps TCRF material only). The scripts that write them are in
[`tools/jp/`](../../../tools/jp/); the sensor recordings and calibration saves are in [`sensor/`](../../../sensor/). The docs section of each
folder is given where it is read (`docs/index.md`).

* `BGB_TEST_SHEET.md`: the first eight BGB confirmations (credits gate, CoroCoro tag, Pokémon stamp pages, stamp mirroring, hot-spot
  effects, link exchange, gender bits) and their result files (`bgb/results/`).
* `bgb/`, `bgb_retrace/`, `bgb_printer/`, `printer_status/`, `mode_state_wp/`, `span_reads/`, `wram_probe/`: BGB harness results
  (watchpoint retraces, printer runs, WRAM probes); docs §16, §17, §2.
* `l3_names/`, `l3_by_eye/`, `port_witness/`: the evidence behind the L3 names (docs §1).
* `forced/`, `easy_wins/`, `reach_bfs/`, `display_run/`, `effect_slots/`, `hotspot_effects/`, `play_effects/`, `stamp_hold/`: forced
  runs, reachability searches, display tracking, effect slots (docs §16.21-§16.28).
* Mini-games and counters: `ball/`, `run_race/`, `run_record/`, `sf2/`, `dj_fields/`, `dj_se/`, `score_caps/`, `counters/`,
  `cheat_checks/`, `credits_parlor/`.
* Japan / international comparisons: `atlas2/`, `intl_compare/`, `us_jp_compare/`, `corocoro_intl/`, `credits_intl/`.
* `albumb_thresholds/`, `jofamo_article/`, `secret/` (the factory screens of the boot calibration), and the parts of `frames/`,
  `guide_walk/`, `never_read/`, `screens/`, `stamps/`, `stamps_rom/`, `unidentified/` (the display-tracking census, `really_unused.*`),
  `unused/` that no TCRF row cites (the cited files stay in `tcrf_check/assets/` under the same folder name).
