# Handoff for a new Claude session (read this first)

Project: reverse engineering of the Game Boy Camera / Pocket Camera ROMs, owner Raphaël Boichot (Dr. BOICHOT on GitHub). Primary target **Pocket Camera (Japan) Rev A**,
md5 `fdcfe686cf4df461e870b6e53b2b5a8b`; the international ROM is md5 `42d2f65e2549be9d1d126a6828b5d1c1`. **The ROMs are not in the repository:** ask for them.
This file holds the rules and the layout. Numbers and findings live in `README.md` (check its section list); do not copy them here, they go stale.

## Rules of the work
* Evidence tags: **C** = code-traced, screenshot, or reproduced in an emulator / BGB; **I** = inferred; **?** = inconclusive. Never guess and never invent an address; say what was not
  checked. Everything in `README.md` is AI work waiting for human validation (the owner's header says "Work in progress, stay tuned"). Update `README.md` and
  `tcrf_check/TCRF_CHECKLIST.{md,csv}` (generator `tcrf_check/tools/tcrf_checklist.py`) together. TCRF flags in answers come from that checklist only.
* The README states the current finding, not the history of how it was found: when a statement turns out wrong, correct it in place and do not keep "earlier version said" notes,
  struck-through items, "withdrawn" paragraphs, questions to the owner or other conversation leftovers; git history has them. Recompute a number before quoting it.
* Use **BGB** (not the Python core) for every screenshot or asset comparison: the core draws the VIEW-screen band and one stamp slot wrongly (README §15.8).
* The two ROMs are different builds (44 % of the bytes differ, §16.1): the Japanese static trace and coverage numbers do not transfer. The main menu is mirrored
  (VIEW = Left on the Japanese ROM, Right on the international one).
* Delivery: `git fetch origin`; `git merge-base --is-ancestor origin/main HEAD` (if the owner pushed, `git rebase origin/main` first); `git push origin <branch>:main`. One commit per batch,
  say in the answer where it was pushed. Do not push scratch branches the stop hook asks about. If a push is refused, fall back to `git format-patch --binary` files tested with
  `git am --keep-cr` on a clean `git clone -c core.autocrlf=false` of upstream main, and give PowerShell commands. Commit as `Claude <noreply@anthropic.com>` with the
  trailers the harness gives (`Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>` and the session URL line).
* Answers: plain text, a short summary of the outcome. Do not paste the URL of a published page (the app shows a card), do not describe the owner's images back to him, quote
  outside sources with at most one short sentence, and do not go around a site that the fetch tool blocks.

## What is in the repository, and what is not
* In git, at the top: `README.md` (§1-18, appendix), `HOWTO_NEW_ROM.md` (playbook for the next ROM, levels L0-L6), `skills/gb-rom-disassembly/SKILL.md` (the same playbook as a skill, keep the two in step),
  `pocketcamera_jp.sym`, `jp_rom_reachability_map.png` (what the runs reached) and `jp_rom_layout_map.png` (what each byte is; both drawn by `tcrf_check/tools/rom_reach_map.py` / `rom_layout_map.py`, regenerate both when the coverage, witness, reach or label data change).
* `disasm/`: `sym_names_jp.csv` + `sym_types_jp.csv` (the source of the symbol file), `sym_unconclusive_jp.{md,csv}` (doubtful names, regenerate with `tools/make_doubts.py`), `renamed_jp.csv` (every label change of the L3 pass),
  `owner_answers_jp.csv`, `charset_jp.csv`, `code_gaps.md`, `coverage_jp_v3.csv`, `sym_unconclusive_banks/` (pictures behind the doubtful rows).
* `tools/`: the pipeline (`sym_build.py`, `sym_fix.py`, `make_doubts.py`, `rom_trace.py` + `extra_roots.json` + `rom_trace_labels.sym`, `rom_coverage.py`, `wram_db.py`, `ram_census.py`, `asset_catalog.py`, `sram_analyze.py`, renderers).
  `tcrf_check/tools/` holds the other scripts (BGB harness, TCRF checks, sensor, forcing); they import `sram_analyze` from `tools/`. One copy of each script only.
* `coverage/` (core `coverage/src`, fuzzer and report tools, `results/`, `v8/`, see its README), `wram/` (WRAM / HRAM / trace), `link_protocol/` (cable sniff logs and their format), `cameras/` (the 14 real cameras' SRAM summary),
  `assets/` (catalog, reach and per-bank layout CSVs, bank atlas), `tcrf_check/` (checklist, `assets/` evidence, `tools/`, `work/`, `shots/`, `BGB_TEST_SHEET.md`), `captures/` (three emulator screens of the erase-all dialog),
  `Spriter_ressources_check/` (the owner's Spriters Resource sheets, used for matching: his data, leave it alone).
* The symbol file is **generated**: edit `disasm/sym_names_jp.csv` / `sym_types_jp.csv` and run `tools/sym_build.py` (README §1.1.1); never edit `pocketcamera_jp.sym` by hand. mgbdis v3.0 reads `<rom basename>.sym` beside the ROM
  (no `--sym` option); check every change with mgbdis + rgbasm 1.0.4 (md5 `fdcfe686cf4df461e870b6e53b2b5a8b`), plain and after `tools/sym_fix.py --tables`. Regenerate the doubts list after renames. When a count changes
  (labels per tag, doubtful rows), fix it in README §1.1.1 / §1.3, `skills/gb-rom-disassembly/SKILL.md` and `HOWTO_NEW_ROM.md` too.
* **Not in git, must be recreated or supplied:** the ROMs; BGB (a Windows binary run headless under Wine; `BGB_DIR` points to it; helpers `tcrf_check/tools/bgb_run.py`, `bgb_us_jp_job.py`, `guide_bgb_walk.py`,
  `bgb_corocoro_intl.py`); the save files (unlocking saves in `saves_unl/`, the real cameras' SRAM); the built core library (`coverage/build.sh`); the owner's bus-analyser sheets (`Search_for_sensor_at_boot.xlsx`,
  `Calibration_procedure.xlsx`, `Exposure_strategy_regular_camera_volts.xlsx`; decoded rows are in `tcrf_check/assets/sensor/*_rows.csv`); the M64282FP datasheet; the BGB state files.
* The helper tools were written for a working directory laid out as `<ROOT>/{tools, package/coverage/src, roms/gbcam_usa_eu.gb, pocketcamera_jp.gb, saves_unl, report_v8, work}`
  (`tcrf_check/tools/lib.py` finds the core under `<ROOT>/package/coverage/src`). In git they sit under `tools/`, `tcrf_check/tools/` and `coverage/src/`: recreate that layout (symlinks) before running them.

## Gotchas learned
* BGB runs a demo (one joypad byte per frame; 250-frame boot hold, then free frames) and gives a screenshot and the state at the end; mode `$D5CE`, state `$D5CF`. BGB needs 3 more boot frames than the core.
  Message states advance by themselves: use long waits and no extra key. Two CPUs: use 2 workers (about 250 BGB runs in 4 minutes). The live camera view needs title A and two more A presses.
  BGB's sensor picture is fake (§18.9): it reproduces the code path, not pixel-dependent decisions.
* `-screenonexit` in BGB saves only the 160 x 144 LCD; to see the Super Game Boy border run BGB with `SystemMode=2` in a visible window under Xvfb (`tcrf_check/tools/bgb_sgb_capture.sh`).
* Long jobs in the background (`setsid nohup`); a foreground tool call over 120 s is killed. Never `pkill -f` a pattern that appears in your own command line (use the `[x]` trick or kill by PID).
* Linked BGB runs (printer helper, `-connect`) stalled at the handshake with `-hf` in the sandbox: set `BGB_HF=-headless` (`bgb_run.py` reads it). `PRN_ERR=CMD:N:HEX` makes the helper answer a chosen status byte (§16.16).
* Other BGB and core pitfalls (VRAM writes in PPU mode 3, hex logs, WAV time, forcing, two-pass snapshots): `HOWTO_NEW_ROM.md` §6 and §7.
* **TCRF pictures can be 2x enlargements:** reduce them before matching (`tcrf_check/tools/tcrf_exact_match.py`), allow palette folds and tile flips, and remember that ROM tile sheets are 16 tiles wide with rows 0x100 bytes apart.
  A 1-tile or 2-tile exact match is weak: check the display evidence.
* A load site `ld hl,TABLE; add hl,bc; ld a,[hl+]` before a banked copy is a local pointer table, not a far pointer. The auto labeller turns any executed 16-bit immediate equal to a ROM address into a label
  (`ld bc,$xxxx` before an OAM meta-sprite call is a position): read the code before trusting a label that cuts a table.
* Do not recompute what the README already states; check the section list at the top, §12 (open items) and §16.10 first.

## Where things stand (pointers, not numbers)
* Disassembly levels L0-L6 and the measured counts: README §1.3. The symbol file (§1.1.1) types every ROM byte and carries 5,240 names tagged C / I / ? (3,695 / 1,536 / 9); 344 doubtful rows are listed with evidence
  in `disasm/sym_unconclusive_jp.md`. L4 (RAM names in the source), L5 (committed buildable tree) are not done; L6 is partial (name / comment charset only, §16.27).
* Coverage of the Japanese ROM: §13 (core), §16.14-§16.21 and §16.26 (later runs, forcing), `assets/witness_jp.csv`, the map `jp_rom_reachability_map.png`. The international ROM has no instrumented coverage run
  (`coverage/tools/coverage_run.py` needs a variant without the Japanese trace); behavioural parity was checked in BGB (§16.11, §16.12).
* Sensor (§18, `tcrf_check/assets/sensor/`, `tcrf_check/tools/sensor_*.py`): register traffic, calibration, exposure, the dither matrix (§7, §18.12), checked against the owner's recordings. Open points: §18.9.
* Link cable (§14, `link_protocol/`), printer (§16.16, §17), Album B and the unlock gates (§15, §16.18), stamps and CoroCoro (§16.8, §16.9, §16.12), credits and parlor (§16.22), really unused assets (§16.24, §16.25).
  The owner's answers are in `disasm/owner_answers_jp.csv`.
* Never-run code is closed as far as keys, saves and WRAM / SRAM pokes go (§16.21, §16.26); the proven-dead pieces stay evidence I. Lessons for forcing: `HOWTO_NEW_ROM.md` §6.
* Still open: §12 (SRAM and WRAM lists), §18.9 (sensor), §16.10 (sweep paths where BGB and the core disagree, link byte timing in BGB), §16.11 "what this walk does not prove", the other pages of the
  international stamp category 3, naming of the ~130 new code roots, texts other than the name / comment fields.
