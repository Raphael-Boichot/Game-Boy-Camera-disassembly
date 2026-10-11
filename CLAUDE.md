# Handoff for a new Claude session (read this first)

Project: reverse engineering of the Game Boy Camera / Pocket Camera ROMs, owner Raphaël Boichot. Primary target **Pocket Camera (Japan) Rev A**,
md5 `fdcfe686cf4df461e870b6e53b2b5a8b`; the international ROM is md5 `42d2f65e2549be9d1d126a6828b5d1c1`. **The ROMs are not in the repository:** ask for them.

## Rules of the work
* `README.md` is headed "AI slop, do not trust until human validation". Evidence tags: **C** = code-traced, screenshot, or reproduced in an emulator / BGB; **I** = inferred;
  **?** = inconclusive. Never guess; say what was not checked. Update README and `tcrf_check/TCRF_CHECKLIST.{md,csv}` together.
* Use **BGB** (not the Python core) for every screenshot or asset comparison: the core draws the VIEW-screen band and one stamp slot wrongly (README §15.9).
* The two ROMs are different builds (44 % of the bytes differ, §16.1): the Japanese static trace and coverage numbers do not transfer. The main menu is mirrored
  (VIEW = Left on the Japanese ROM, Right on the international one).
* Delivery: the owner pushes. Claude has no write access to GitHub; deliver `git format-patch --binary` files, tested with `git am` on a clean
  `git clone -c core.autocrlf=false` of upstream main (fetch first: main moves), and give PowerShell commands. Commit trailers:
  `Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>` and the session URL line the harness gives; committer `Claude <noreply@anthropic.com>`.
  When asked to "merge the patches", deliver one commit on top of current main.

## What is in the repository, and what is not
* In git: `README.md` (§1-17), `tools/`, `tcrf_check/` (checklist, `tools/`, `assets/`), `coverage/` (core sources `coverage/src`, fuzzer and report tools, `results/report_v6`,
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
* Do not recompute what the README already states; check the section list at the top and §16.10 / §12 for open items.

## Where things stand
* Japanese ROM coverage (v8): 95.3 % of the 60,449 traced instructions executed, 82.7 % by joypad and save only; 1.5 % of the ROM (15,288 B) never executed nor read
  (map at the top of the README): 5,268 B are code that never ran (**3,013 of them were run afterwards** by eight later runs: SGB sender, printer-only code, hot-spot effects, hold-A stamp mirror, music-editor fields, Game Face hidden choice, RUN! race result, the APU branch; green on the map, §16.14, `assets/witness_jp.csv`; the 2,255 B left are sorted in §16.15 / `assets/reach_components_jp.csv`: 917 B unreferenced, 394 B unreachable effect slots, 773 B still open, all "cannot run" verdicts being I; 2,258 B stay red), 10,020 B are data that no run read, and **10,017 of those are identified** (wild-frame side strips, kana
  glyph banks, BG tilemaps, SGB data, tile-set gaps: §16.13, `assets/asset_map_jp.csv`, orange on the map). The SGB border of both ROMs is rebuilt from bank `$0B` and equals BGB's (C, §16.13 (5)). Reassembles byte-exact; about 57 kB of data inside the code banks and most of the 52 data banks are still untyped (§1.2).
* International ROM: no instrumented coverage run (a fuzz was started and stopped; `coverage/tools/coverage_run.py` needs a variant without the Japanese trace).
  Behavioural parity checked in BGB: all menu nodes of the five Funtography flowcharts on both ROMs (§16.11); CoroCoro content absent (§16.12).
* Closed by the owner: names of the 16 hot-spot icons, effect timing, CoroCoro on a real international camera (§16.12).
* Next runs for the never-run code (§16.15, "what is not proven"): printer status variants for `00:1A7B`, a save with a Game Face for `06:48E6`, the RUN! place branches, the sound-command handlers of `1F:431A` / `1F:433E`.
* Still open: §12 (SRAM and WRAM lists), §16.10 (18 sweep paths where BGB and the core disagree; F12 / F13 gender counters in BGB; link byte timing in BGB),
  §16.11 "what this walk does not prove" (panorama print, COMPOSE result, animation tools, transfer exchange), the other pages of the international stamp category 3,
  naming of the ~130 new code roots, no charset table.
