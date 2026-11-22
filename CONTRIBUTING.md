# Contributing

This is the human entry point to the project: how to check it, where the truth lives, and the rules a change must follow. It does not depend on any AI tool. `CLAUDE.md` is the hand-off file of the AI sessions that do most of the work; everything in it that a person needs is here or in `SETUP.md`, and the two are kept in step.

## The first ten minutes: rebuild the ROMs

No ROM image is needed: every source tree carries its own data (`roms/<rom>/src/data/`). With [rgbds 1.0.4](https://github.com/gbdev/rgbds/releases/tag/v1.0.4) and Python 3:

```bash
make check                          # roms/jp_rev_a/src/  -> build/jp_rev_a/pocketcamera_jp.gb, md5 compared
make check TREE=us_eu               # the international ROM
make check TREE=gold                # Game Boy Camera Gold
make check TREE=hello_kitty         # Pocket Camera Hello Kitty
make check TREE=prototype_debagame  # the DEBAGAME prototype (no rgbfix: its header was never fixed)
# or RGBDS=/path/to/rgbds/ make check, with the trailing slash
```

Each line ends with `OK` when the build is byte-identical to the original (tested on a clean clone on 2026-11-22: about 2 seconds per tree).

## The ROMs, for everything else

The ROM images are not in the repository and never will be. The analysis tools take them from your own copies, identified by their hashes; by default they look in `/root/work/roms/` under the short names below (`tools/setup_env.sh` puts them there), or in the file named by `GBCAM_ROM`.

| Short name | ROM | MD5 | SHA-256 |
|---|---|---|---|
| `pocketcamera_jp.gb` | Pocket Camera (Japan) (Rev A), the main target | `fdcfe686cf4df461e870b6e53b2b5a8b` | `b179a1db02e540547f0ac78b09ebc4085a84f806a97857bc863d5ac41f07a9a2` |
| `gbcam_us.gb` | Game Boy Camera (USA, Europe) | `42d2f65e2549be9d1d126a6828b5d1c1` | `d4d4338bed6938a7aa3c1788bd8a870a954c3676fdc4829b8fb410f4e39ac900` |
| `gbcam_gold.gb` | Game Boy Camera Gold (USA) | `b2999cfb6dacb439f501a71f30f91762` | `b772951adf58dff025e05722c2aa179e0c874b7cb0b844c5cda44f6194df6299` |
| `pocketcamera_kitty.gb` | Pocket Camera (Hello Kitty) | `0a323bddc4f0159cea76cf44ed0c1a3c` | `fa4253a45037bcf5d09fb9f99c432fd70dee6db9f9cb024dcd5bd36fcf3d1df3` |
| `pocketcamera_proto.gb` | DEBAGAME prototype, the image as dumped (`GBD-IMPACT8M.gb`) | `19b50a5f67ef4f0d015e7d813370756e` | `e65d758628f46109cafb579295c4baefc5c8377ee138879fe7a7d73a17f7aa68` |
| `pocketcamera_proto_bgb.gb` | the same with six header bytes patched so that BGB runs it; BGB only | `1d8097de3497db8b182bcd2a984b6063` | `d2eee064c439f9dd4df10ae0c8b28e7e24e1313ed7a4eea518d1e590f3726516` |

`SETUP.md` lists the rest of the toolchain (mgbdis commit, Wine, BGB, the project's emulator core) and every routine procedure.

## Where the truth lives

| Kind | Edit this | Never edit (generated from it) | Regenerate with |
|---|---|---|---|
| ROM byte types and routine / asset names | `roms/<rom>/disasm/sym_names_*.csv`, `sym_types_*.csv` (or their hand layers under `disasm/layers/`) | the `.sym` files, `roms/<rom>/src/` | `tools/sym_build.py`, `make source`, or `tools/regen.py` for the whole chain |
| RAM names, constants, sound ids | `roms/<rom>/disasm/ram_names_*.csv`, `const_names_*.csv`, `sound_names_*.csv` | `ram_*.inc`, `const_*.inc`, the `_ram.sym` | `tools/ram_names.py`, `tools/const_names.py` |
| Figures quoted in the READMEs and the roadmap | nothing by hand: they carry a key, `<!--f:KEY-->figure` | | `tools/facts.py --fix` |
| Findings | `docs/*.md` (one file per section, `docs/index.md` maps every `§N.M`) | | |

`make source` overwrites `src/` on purpose: a hand edit there is lost at the next regeneration. Put it in the tables.

## Before every commit

```bash
python3 tools/check_repo_consistency.py --rom pocketcamera_jp.gb --rom-us gbcam_us.gb --rom-gold gbcam_gold.gb \
    --rom-kitty pocketcamera_kitty.gb --rom-proto pocketcamera_proto.gb --roundtrip     # 15-25 minutes; 0 failures required
```

It rebuilds every generated file and compares it with the committed one, compares every figure the docs quote with the file it comes from, checks the links and the `§` references, and does the disassembler round trip. A failure names the file or the sentence to fix.

## Evidence rules

Every finding carries a tag.

* **C**, confirmed, and **the sentence says by what**: `code` (read in the ROM's straight-line code or tables), `core` (run in the project's own emulator, `coverage/src/`), `BGB` (run in the BGB emulator), `hardware` (the owner's cameras, bus recordings, printers or saves). Add `forced` when the run poked RAM, set a register or patched the ROM to get there: a forced run shows that code works, not that a player can reach it. Example: "C (BGB, forced: `$D581` poked)". The rule applies to new text from 2026-11-22; older text usually says it in words.
* **I**, inferred: say from what. Every negative claim ("never read", "unused", "cannot run", "unreachable") is **I** unless a proof covers it, and says what was searched and how ("no reference found by the scan of direct operands; a computed jump is not excluded"). "Not observed" is not "cannot occur".
* **?**, open: say what would settle it.

Never guess an address or a value. A figure is recomputed before it is quoted. A statement that turns out wrong is corrected in place; git keeps the history.

## What stays out of the repository

* ROM images (above), and the owner's material in `source/` stays as it is.
* Save files: they hold photos (the exception: the photo-free calibration examples in `sensor/calibration_saves/`). Save files lent for one analysis are described in words, never stored.
* Photos of people taken with the owner's cameras, and anything derived from them that shows them (numbers derived from them are fine).
* TCRF content: the repository links to the TCRF pages, it does not copy them (`tcrf_check/TCRF_SOURCES.md`).

## Known limits of the tools

* The project's emulator core draws the VIEW-screen band and one stamp slot wrongly (`docs/15_tcrf_and_unlocks.md`, §15.8): use BGB for every screenshot.
* The core keeps one internal value across resets inside a process, so a batch of replays can differ from the same replays run one per process (docs §16.6, row 1).
* BGB's camera sensor is a made-up picture that does not behave like a sensor (docs §18, "Where this comes from"): it reproduces the code path, not decisions that depend on the image.
* The sensor recordings are in the repository as the owner's workbooks (`sensor/recordings/`); their raw logic-analyser captures (`.sal`) stay in his sensor repository.
* In this project's sandbox a linked BGB run (printer helper) needs `BGB_HF=-headless` and `PRN_SYNC3_PERIOD=0.002`, and no Xvfb or Wine process left over from an earlier run (docs §17.1).

## Where to read next

`README.md` (front page and status), `docs/index.md` (every section), `ROADMAP.md` (what is left for each ROM), `HOWTO_NEW_ROM.md` (the method, levels L0-L6), `SETUP.md` (toolchain and procedures).
