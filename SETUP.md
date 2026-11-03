# Setting up a session (read before anything else; do not rediscover)

One command prepares a fresh session; rerun it any time, it skips what already exists:

```bash
bash tools/setup_env.sh          # about 2 minutes on a fresh container (Wine is the slow part); --no-wine for static work only
export PATH=/home/claude/tc/rgbds:$PATH BGB_DIR=/home/claude/bgbx WINEDEBUG=-all
```

What it does, and what it leaves where:

| Step | Result | Notes |
|---|---|---|
| rgbds 1.0.4 | `/home/claude/tc/rgbds/` | release binaries from GitHub (reachable through the proxy) |
| mgbdis master `95d951a` | `/home/claude/tc/mgbdis/mgbdis.py` | not the v3.0 tag: it ignores row widths and `.padding` |
| the five ROMs | `/root/work/roms/` as `pocketcamera_jp.gb`, `gbcam_usa_eu.gb`, `gbcam_gold.gb`, `pocketcamera_kitty.gb`, `pocketcamera_proto.gb` (+ short links `jp.gb`, `intl.gb`, `gold.gb`, `kitty.gb`, `proto.gb`) | taken from the session attachments (`/mnt/user-data/...`) or the project files (Projects tool, `project_read`: `Pocket Camera Japan Rev A SGB Enhanced.gb` and the four others), matched by md5; **no Game Boy Camera ROM is in the repository** (removed from the owner's pack 2026-11-03); never committed |
| Wine 9.0 | `apt-get install wine64` | the Ubuntu archive is reachable; the docker.com apt source is refused and can be ignored |
| BGB | `/home/claude/bgbx/bgb.exe` (md5 `ada2cb39e40de88051b589010a26acdc`) + `bgb.ini` | the attachment is named `<hash>-bgb.exe`; the ini comes from the owner's pack with `SystemMode=0` forced (his desktop ini says 3 = automatic, which boots this ROM as a Super Game Boy and the harness sees a white screen at mode 0:0) |
| smoke test | a 160 x 144 screenshot | if it fails, see "BGB" below |

The repository itself: `/root/work/repo` (a clone of `Raphael-Boichot/Game-Boy-Camera-disassembly`; pushing needs the repository attached to the session with push access).

## Which tool for which question (token budget)

* **Reading the ROM** (what a routine does, where a table is read, which bytes differ between builds): the listing and the tables, not BGB.
  `make check` / `make TREE=us_eu check` rebuild the trees; `tools/rom_trace.py`, `tools/port_*.py`, `tools/wram_db.py`, `grep` over `roms/*/src/` and `roms/*/disasm/*.csv`.
  For behaviour, the project's own core (`coverage/src/gbcov.c`, built by `coverage/build.sh`) runs thousands of frames a second and logs reads / writes / executions.
* **BGB** is the judge for what the screen shows and what is heard: screenshots (`-screenonexit`), sound (WAV), and logging watchpoints when the core's
  answer must be confirmed (`tcrf_check/tools/bgb_wp_probe.py`; CLAUDE.md "BGB, used efficiently"). Do not explore the ROM in BGB.
* Driving BGB: `tcrf_check/tools/bgb_run.py ROM SAV OUTPREFIX 'KEYS:hold:wait,...' [--combo N] [--free F]` (one demo file = one joypad byte per frame; a step `-:1:0` is a no-op;
  `--combo` is held through the 250-frame boot hold). BGB reads a demo byte of `$FF` (every button) as no key: a power-on with every button held cannot be replayed.
  Two workers at most (two CPUs); long batches with `setsid nohup`, polled with short calls.

## Routine procedures

* **Full check** (before every commit): `python3 tools/check_repo_consistency.py --rom $R/pocketcamera_jp.gb --rom-us $R/gbcam_usa_eu.gb --rom-gold $R/gbcam_gold.gb --rom-kitty $R/pocketcamera_kitty.gb --rom-proto $R/pocketcamera_proto.gb --roundtrip > check.log` (R=/root/work/roms; 15-25 minutes: run it in the background).
* **Counts that moved**: `python3 tools/fix_quoted.py check.log` rewrites, in the cited file and line, every number the checker reports as changed; a count that is a sum of two quoted numbers is fixed by hand (it prints NOT FOUND). Rerun the check.
* **International port**: `python3 tools/port_build.py $R/pocketcamera_jp.gb $R/gbcam_usa_eu.gb --mgbdis /home/claude/tc/mgbdis/mgbdis.py` (about 2 minutes, three byte-exact round trips), then `python3 tools/make_source.py --tree us_eu --rom $R/gbcam_usa_eu.gb --check` and `python3 tools/status_maps.py ...` for the other ROMs' maps. Hand work goes in `roms/us_eu/disasm/*_hand.csv` and `roms/us_eu/port/extra_roots_us_hand.json` (kept across re-ports).
* **Coverage of the international ROM** (the project's core): `coverage/build.sh`, then `coverage/tools/coverage_run.py` with `GBCAM_ROM`, `GBCAM_TRACE=roms/us_eu/port/trace_us.json`, `GBCAM_ROOTS=roms/us_eu/port/extra_roots.json`, `GBCAM_SYM=roms/us_eu/gbcam_usa_eu.sym` (no ROM address is hard-coded in the core); about 80,000 code bytes reached in 4 minutes.

* **Reads layer (untyped bytes named from the coverage)**: copy a coverage state dir, zero `site`, `site2`, `rmode` in its `cov.npz`, replay it with `GBCAM_SITE_ALL=1 coverage_run.py --hours 0.05 --state <copy>` (the core then records the call site and mode of every read, forced runs too; 15 minutes), then `python3 tools/port_reads.py ROM <copy>/cov.npz <the names csv> --queue roms/us_eu/port/hand_queue_us.csv --out-names roms/us_eu/disasm/sym_names_us_reads.csv --out-types roms/us_eu/disasm/sym_types_us_reads.csv --skip-types roms/us_eu/disasm/sym_types_us_hand.csv`, then the international port. Run it on a queue made without the reads layer (move the two files aside and re-port first), or it only sees what is still untyped.
* **Checked layer**: `python3 tools/port_check_names.py JP.gb OTHER.gb roms/<f>/port/map_<s>.npy roms/jp_rev_a/disasm/sym_names_jp.csv roms/<f>/disasm/sym_names_<s>.csv <coverage cov.npz> roms/<f>/port/trace_<s>.json --out roms/<f>/disasm/sym_names_<s>_checked.csv`, then the port (the layer is applied before the hand layer). Second pass: `python3 tools/port_check_names2.py JP.gb OTHER.gb roms/<f>/port/map_<s>.npy roms/<f>/disasm <s> <coverage cov.npz> [--skip-banks 02]` (appends to the same file; Gold borrows the international coverage, so bank 02 is skipped). Third pass (context): `python3 tools/port_check_names3.py JP.gb OTHER.gb roms/<f>/disasm <s>`.
* **Kitty test saves**: a clean save is the SRAM of a BGB boot from an all-$00 save (1,200 frames, read from the `.sna`: `bgb_run.read_state(...)['SRAM']`); the Kitt counter is `$100A-$100C` (roms/hello_kitty/README.md). Saves stay outside the repository.
* **Long coverage runs and container loss**: the container is reclaimed after inactivity and detached jobs stop a few minutes after a reply, so a multi-hour run is never trusted to finish alone. Its state dir (`cov.npz`, `corpus.jsonl`, `stats.json`, ~1 MB) is pushed to the side branch `wip/intl-coverage-state` (force-pushed, orphan); `git fetch origin wip/intl-coverage-state` and rerun `coverage_run.py --state <that dir>` to resume (it replays the corpus). Most of the gain comes in the first 20 minutes: harvest early.

* **Read sites for L3** (2026-11-02): the core's read sites are interrupt-safe and drop stale sites since this date; fresh ones come from `GBCAM_SITE_ALL=1 GBCAM_ROM=ROM python3 tools/port_queue_origin.py roms/us_eu/gbcam_usa_eu.sym CORPUS OUT.npz` (8 minutes for the 13,175-entry corpus; OUT also holds the copy-queue origins), and passes 4-5 take those files instead of an older coverage state.
* **L3 pass 4 (names left at I)**: after a port and `make_source.py`, `python3 tools/port_check_names4.py roms/us_eu us /root/work/port/covus/sites/cov.npz /root/work/port/covus/unl/cov.npz` (rerunnable: replaces its own rows; `--dry` prints), then `python3 tools/port_check_names5.py roms/us_eu us INTL.gb` (static copy extents and table entries; rerunnable), then `python3 tools/port_check_names4_copy.py roms/us_eu us INTL.gb roms/gold gold GOLD.gb`, then the port again (`/root/work/port/all.sh`-style rebuild: port_build, make_source, gold port, status_maps, check).
* **Gold source tree (L5)**: after the Gold port (`tools/port_build.py ... --dir roms/gold --suffix gold ...`), `python3 tools/make_source.py --tree gold --rom gbcam_gold.gb --check` rewrites `roms/gold/src/`; `make TREE=gold check` builds it. Order: write the Japanese tree first (`--tree jp_rev_a`): the international and Gold trees read `roms/jp_rev_a/src/` for its `{lo, hi, bank}` records (`jp_far_records`), so a half-written or stale Japanese tree changes theirs. `make_source.py` needs `rgbgfx` on `PATH`.
* **International / Gold character set (L6)**: `python3 tools/charset_us.py $R/pocketcamera_jp.gb $R/gbcam_usa_eu.gb roms/us_eu/disasm/charset_us.csv` (the same with `gbcam_gold.gb` and `roms/gold/disasm/charset_gold.csv`), then `python3 tools/charmap_jp.py --csv roms/us_eu/disasm/charset_us.csv --out roms/us_eu/disasm/charmap_us.inc --name intl --title 'Game Boy Camera (USA, Europe)'` (Gold: `charmap_gold.inc`, title 'Game Boy Camera Gold (USA)'). The text tables to write are listed in `text_tables_<s>.csv` (layout letters: `c` character, `n` number, `s` glyph slot = code - 1; column `charmap` = `intl` or `kana`); `port_build.py` and `make_source.py` pick them up.
* **Targeted scenarios on the international / Gold ROMs (L2 observed)**: `python3 tools/port_bgb_witness.py - SCEN.json OUTDIR [--worker K/2]` (BGB, logging breakpoints on every never-run block head + a control breakpoint on `00:0150`; printer helper or a second linked instance; the scenario file format is in the docstring, the runs of 2026-11-01 in `tcrf_check/assets/port_witness/bgb_scenarios.json`); `--merge` turns the heads hit into an `ex` file. Core side: `tools/port_core_scen.py` (D.J. pages and score print), `tools/port_hotspot_forced.py` (forced), `tools/port_printer_status.py` (status injection), `tools/port_l2_rest.py` (the last differing code: album B gate with a 5,000-point save, the RUN! crown, the hot-spot sound `$1F`, the forced slider redraw), all with `PYTHONPATH=coverage/src:tcrf_check/tools` and `GBCAM_ROM`; `coverage/build.sh` first. The corpus tools read saves from `tcrf_check/saves` / `saves_unl`: link the save folders there for the run and remove the links before committing. Then `python3 tools/port_never_run.py roms/us_eu us roms/us_eu/port/never_run_us.csv roms/us_eu/port/cov_us_runs.npz roms/us_eu/port/cov_us_witness.npz --rom ROM` (`--rom` adds the `JP_EQUIV` class). Two BGB instances on one machine must not share a BGB directory: BGB writes `debugmsg.txt` next to `bgb.exe`.
* **International menu routes (core, 2026-11-01)**: title A → main menu `00:01`; Right A → VIEW; Down A → PLAY (Space Fever II `07`); Select → second page: Up A → LINK (`06:01`), then Up A → print menu `1B`, Down A → exchange `0E`; in `1B`, A → photo picker `1C:01`, Right A → multi-photo print `1E:01`. PRINT screen `1C:03`: Start toggles the comment card, Select opens the options (Up exposure, Down frames).

## Working rules (owner, 2026-10-31)

* Script the long work and run it in the background; wait for the result instead of reasoning through it. Spend reasoning on the hard questions only.
* Write down every procedure that works (here, in CLAUDE.md, or in the docstring of the script) instead of rediscovering it next session.
* Push at the end of every large task and before a session ends (the owner's standing order since 2026-10-26), after `python3 tools/check_repo_consistency.py --rom ROM --rom-us ROM_US --roundtrip` reports 0 failures.

* **Evidence tags (L3, international / Gold)**: after the naming passes and any hand row, `python3 tools/port_evidence_tags.py roms/us_eu us` (and `roms/gold gold`) sets I on every name whose claim is that something is unused, dead, unreferenced or never loaded, or whose Japanese counterpart is I (the Japanese convention); then rebuild (`/root/work/port/all.sh`).
* **Save files** (none in git since 2026-11-02, owner: they hold photos): put the real cameras' saves in `coverage/saves/` and the link-exchange images in `link_protocol/saves/` (the tools read them there), and rebuild the unlocking saves with `tools/make_unlocked_saves.py`; the checker does not need them. `*.sav` is in `.gitignore`.
