# Handoff for a new Claude session (read this first)

Project: reverse engineering of the Game Boy Camera / Pocket Camera ROMs, owner Raphaël Boichot. Primary target **Pocket Camera (Japan) Rev A**,
md5 `fdcfe686cf4df461e870b6e53b2b5a8b`; the international ROM is md5 `42d2f65e2549be9d1d126a6828b5d1c1`. **The ROMs are not in the repository:** ask for them.

## Rules of the work
* `README.md` is headed "AI slop, do not trust until human validation". Evidence tags: **C** = code-traced, screenshot, or reproduced in an emulator / BGB; **I** = inferred;
  **?** = inconclusive. Never guess; say what was not checked. Update README and `tcrf_check/TCRF_CHECKLIST.{md,csv}` together.
* Use **BGB** (not the Python core) for every screenshot or asset comparison: the core draws the VIEW-screen band and one stamp slot wrongly (README §15.9).
* The two ROMs are different builds (44 % of the bytes differ, §16.1): the Japanese static trace and coverage numbers do not transfer. The main menu is mirrored
  (VIEW = Left on the Japanese ROM, Right on the international one).
* Delivery: when GitHub is linked to the session, `git push origin <branch>:main` works (the owner confirmed main; earlier sessions had no write access). Always
  `git fetch origin` first and check that the push is a fast-forward (main moves); one squashed commit per batch on top of current upstream main; say in the answer
  where it was pushed (main or a feature branch). Do not push scratch branches the stop hook asks about. If a push is refused, fall back to `git format-patch --binary`
  files tested with `git am --keep-cr` on a clean `git clone -c core.autocrlf=false` of upstream main, and give PowerShell commands. Commit trailers:
  `Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>` and the session URL line the harness gives; committer `Claude <noreply@anthropic.com>`.
  When asked to "merge the patches", deliver one commit on top of current main.

## What is in the repository, and what is not
* In git: `README.md` (§1-18), `tools/`, `tcrf_check/` (checklist, `tools/`, `assets/`), `coverage/` (core sources `coverage/src`, fuzzer and report tools, `results/report_v6`,
  `results/report_v8`), `wram/`, `link_protocol/`, `disasm/`, `cameras/`, `pocketcamera_jp.sym`.
* **Not in git, must be recreated or supplied:** the ROMs; BGB (a Windows binary run headless under Wine; helpers `tcrf_check/tools/bgb_run.py`,
  `bgb_us_jp_job.py`, `guide_bgb_walk.py`, `bgb_corocoro_intl.py`; `BGB_DIR` points to it); the save files (unlocking saves in `saves_unl/`, the 14 real cameras' SRAM);
  the built core library (`coverage/build.sh`).
* The helper tools were written for a working directory laid out as `<ROOT>/{tools, package/coverage/src, roms/gbcam_usa_eu.gb, pocketcamera_jp.gb, saves_unl, report_v8, work}`
  (`tcrf_check/tools/lib.py` finds the core under `<ROOT>/package/coverage/src`). In git they sit under `tcrf_check/tools/` and `coverage/src/`: recreate that layout (symlinks) before running them.

## Gotchas learned
* BGB runs a demo (one joypad byte per frame; 250-frame boot hold, then free frames) and gives a screenshot and the state at the end; mode `$D5CE`, state `$D5CF`.
  BGB needs 3 more boot frames than the core. Message states advance by themselves: use long waits and no extra key. Two CPUs: use 2 workers (about 250 BGB runs in 4 minutes).
* `-screenonexit` in BGB saves only the 160 x 144 LCD; to see the Super Game Boy border run BGB with `SystemMode=2` in a visible window under Xvfb and capture the screen (`tcrf_check/tools/bgb_sgb_capture.sh`).
* Long jobs in the background (`setsid nohup`); a foreground tool call over 120 s is killed. Never `pkill -f` a pattern that appears in your own command line (use the `[x]` trick).
* Linked BGB runs (printer helper, `-connect`) stalled at the handshake with `-hf` in the sandbox: set `BGB_HF=-headless` (`bgb_run.py` reads it). `PRN_ERR=CMD:N:HEX` makes the helper answer a chosen status byte (§16.16).
* Do not recompute what the README already states; check the section list at the top and §16.10 / §12 for open items.

## Where things stand
* Japanese ROM coverage (v8): 95.3 % of the 60,449 traced instructions executed, 82.7 % by joypad and save only; 1.5 % of the ROM (15,288 B) never executed nor read
  (map at the top of the README): 5,268 B are code that never ran (**3,434 of them were run afterwards** by later runs: SGB sender, printer-only code and printer error-status handlers, hot-spot effects, hold-A stamp mirror, music-editor fields, Game Face hidden choice, RUN! race podium and flag code, the APU branch, the D.J. sound effects 4 / 8 / 9, the Space Fever II boss code, both copies of the Select+Start+Up erase-all shortcut, the link receive counters and the `$55` hello, the blank-calibration loader loops, nine D.J. page handlers, the editor copy badge, the hidden Game Face editor and its save-back; green on the map, §16.14, §16.18, §16.19, `assets/witness_jp.csv`; the 1,834 B left are sorted in §16.15 / `assets/reach_components_jp.csv`: 917 B unreferenced, 454 B unreachable (effect slots, three printer-engine pieces and three RUN! state pieces), 419 B still open, all "cannot run" verdicts being I; 1,837 B stay red), 10,020 B are data that no run read, and **10,017 of those are identified** (wild-frame side strips, kana
  glyph banks, BG tilemaps, SGB data, tile-set gaps: §16.13, `assets/asset_map_jp.csv`, orange on the map). The SGB border of both ROMs is rebuilt from bank `$0B` and equals BGB's (C, §16.13 (5)). Reassembles byte-exact; about 57 kB of data inside the code banks and most of the 52 data banks are still untyped (§1.2).
* International ROM: no instrumented coverage run (a fuzz was started and stopped; `coverage/tools/coverage_run.py` needs a variant without the Japanese trace).
  Behavioural parity checked in BGB: all menu nodes of the five Funtography flowcharts on both ROMs (§16.11); CoroCoro content absent (§16.12).
* Sensor registers (README §18, `tcrf_check/assets/sensor/`, `tcrf_check/tools/sensor_*.py`): what the ROM sends to the MAC-GBD / M64282FP, in datasheet names, for boot, calibration and normal use, checked against the owner's bus-analyser recordings (`Search_for_sensor_at_boot.xlsx`, `Calibration_procedure.xlsx`, `Exposure_strategy_regular_camera_volts.xlsx`; **not in git**, ask for them; their decoded rows are in `assets/sensor/*_rows.csv`) and the M64282FP datasheet (not in git). BGB's fake sensor is not a sensor model (its pixel sum drifts at fixed registers): it reproduces the code path and constants, not pixel-dependent decisions (§18.9 lists what is open). The symbol-file edits of that pass were not re-assembled (no mgbdis / rgbasm in that sandbox).
* Totaka's Song (https://nintendo.fandom.com/wiki/Totaka%27s_Song): sound `$29` (6 notes, then the first 5 one semitone higher, in unison over three octaves) is asked for by the shared result / error screen `09:7290` one time in three (random picture and tune `$28 $29 $30` by `floor(3R/256)`, `$2A` only for message `$0E`; "no blank frames" is message `$0D`) and by the NG branch of the hidden factory test; pitches not compared with the real song (§16.20).
* Closed by the owner: names of the 16 hot-spot icons, effect timing, CoroCoro on a real international camera (§16.12).
* GameFAQs cheats page (https://gamefaqs.gamespot.com/gameboy/564359-game-boy-camera/cheats): every line tried in the core and BGB, Space Fever II and BALL played with the joypad only to 7,113 / 1,100 points, all Album B gates run at the exact threshold on both ROMs, RUN! gates run with real races: §16.18. Page vs code: B19 needs 15 transferred pictures (page: 5), the "5 males / 5 females" counters count received pictures by the sender's gender bit, "17 / 16 seconds" = displayed below 18:00 / 17:00. Cite the page in the README wherever a finding matches it. Space Fever II cannot be replayed in BGB (random wave offsets); BALL can.
* Next runs for the never-run code (§16.15, "what is not proven"): the third Space Fever II boss played with a stored Game Face (`07:693A`; `06:48E6` ran in §16.19), the sound-engine handlers `1F:5234` / `522A`, the 46 OPEN components (10 of them in bank 5, the D.J. pages: no key path found by the 34-key search), the international credits and 16 s gates.
* Still open: §12 (SRAM and WRAM lists), §18.9 (sensor: A000 bit 1 = P/M selector or status bit, to be settled with a bus test; the `print` sheet, printing paths, the recorded unit's SRAM), §16.10 (18 sweep paths where BGB and the core disagree; F12 / F13 gender counters in BGB; link byte timing in BGB),
  §16.11 "what this walk does not prove" (panorama print, COMPOSE result, animation tools, transfer exchange), the other pages of the international stamp category 3,
  naming of the ~130 new code roots, no charset table.
