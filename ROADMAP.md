# Roadmap: what is left for L0-L6, every ROM

Written 2026-11-09, after the consistency audit (steps 1-5) and step 6 items 1-2; regenerated 2026-11-12, after items 1-3 of the order of work below and the prototype's leftover analysis (TCRF assets, copies, parts and variants, PC memory, the older builds' printer library); updated 2026-11-12 evening after the owner-guided BGB session on Hello Kitty (print screens, wild frames, the おもしろレンズ slide show). The levels and the status words are those of `HOWTO_NEW_ROM.md` section 0: `done` only when the level's test holds in full for that ROM, `partial` with what is left, `not started`. The **Status** column of each table must equal the Levels table of the ROM's README; `tools/check_repo_consistency.py` compares them, and the summary at the top of `README.md` too. Update the three together.

## Pocket Camera (Japan) (Rev A): the reference

| Level | Status | Left to do |
|---|---|---|
| L0 | done | - |
| L1 | done | - (2026-11-10: the last 32 uncertain bytes, `19:7FE0-7FFF`, are the four masks of the large pen, `Pen_LargeMask0`-`3`; 0 uncertain bytes) |
| L2 | done | Nothing that a run can prove: the 45 dead roots and the 1,192 never-run bytes, all classified, stay evidence I (docs §16.21, §16.26). |
| L3 | done | - |
| L4 | done | - |
| L5 | done | - |
| L6 | partial | 1. The record format of the 1,713 data bytes still on the default typing (`docs/01` §1.2, refreshed 2026-11-10). 2. The open questions of `docs/12`: the F34-F35 checksum mismatches, who writes `1B 13`, the meaning of the sound ids, the sensor items. 3. Owner validation of names (`disasm/owner_answers_jp.csv`), now with the developers' names of the printer routines found in the prototype's older builds (`SIOINT` = `Prn_SerialIrq`, `CONNECTPRN` = `Prn_SendInit` ...: 21 exact and 10 near pairs in `roms/prototype_debagame/disasm/printer_lib_proto.csv`; I for this ROM, the builds are older) as candidate aliases. 4. **One source for the three retail builds** (Japanese, international, Gold) with build switches instead of three generated trees: the largest L6 item, shared with the international and Gold ROMs. |

## Game Boy Camera (USA, Europe)

| Level | Status | Left to do |
|---|---|---|
| L0 | done | - |
| L1 | done | - |
| L2 | done | - (2026-11-10: 0 red bytes; the 45 B of bank `$00` are `UNREACHABLE`, `port/unreachable_us.csv`, and `09:54ED` is `Unused_Kb_LoadGlyphSetC`) |
| L3 | done | - |
| L4 | done | - (2026-11-10: `wram/wram_summary_us.csv` and `wram/INDEX.md`: the layout is the Japanese one, 98.8 % of the access sites pair as in Japan) |
| L5 | done | - |
| L6 | partial | 1. Display replays to confirm whether the Japanese leftover blocks ever reach the screen (README, never-reached assets). 2. The shared retail source (see the Japanese ROM). |

## Game Boy Camera Gold (USA)

| Level | Status | Left to do |
|---|---|---|
| L0 | done | - |
| L1 | done | - |
| L2 | done | - (2026-11-10: 0 red bytes, as the international ROM) |
| L3 | done | - |
| L4 | done | - (2026-11-10: `wram/wram_summary_gold.csv` and `wram/INDEX.md`, as the international ROM) |
| L5 | done | - |
| L6 | partial | 1. Targeted runs that show its own assets (the Zelda stamps and the album B pictures, read so far only in forced runs; `assets/gold_own_never_read.csv`). 2. The shared retail source. |

## Pocket Camera (Hello Kitty)

| Level | Status | Left to do |
|---|---|---|
| L0 | done | - |
| L1 | done | Every byte is typed; 17,198 bytes (1.6 %) stay of uncertain kind on the layout map (2026-11-12: 23,319 before the two pictures of bank `$11` were named, 51,557 before the owner's kinds by eye, 204,703 before the data names; the largest rest is the bottom half of bank `$0D`, 4,576 B): the `Src_` blocks copied into WRAM buffers and never seen in VRAM, and the 109 leftovers. Their kinds are an L6 question. |
| L2 | done | - (2026-11-12: the 7,607 red bytes classified by their way in, `trace/red_kitty.csv`: GATE 4,310, BEHIND 1,573, TABLE 1,438, FORCED 263, HAND 20, VECTOR 3; I). Optional: hand verdicts (dead / reachable) for the largest gates, the linked exchange first, as the Japanese ones (docs §16.21). New (2026-11-12 evening): the owner-guided BGB paths (wild-frame print, the print intensity, the four print-error pictures, the おもしろレンズ slide show) reach code and data the core runs never did; they are screenshots and printed pages only, not yet coverage (replay them in the core, `tools/kitty_core_paths.py`, so that the reachability map credits them). |
| L3 | done | - (2026-11-12: 0 placeholder; every data block named by kind and consumer, `tools/kitty_data_names.py`; 109 leftovers `Leftover_BB_AAAA`, I, owner rule; 40 doubts in `disasm/sym_unconclusive_kitty.md`, 14 of them final). |
| L4 | not started | 1. The WRAM access and summary tables (`tools/wram_db.py` reads this trace format). 2. RAM names with a scope per row. 3. Constants: modes and states (`disasm/mode_names_kitty.csv` exists), keys, sound ids. 4. The SRAM access table and map (`tools/sram_db.py` reads this trace format; the layout needs real Kitty saves; the Kitt counter and its unlock thresholds belong here). |
| L5 | not started | A `tools/make_source.py` preset for this ROM; a source tree that builds byte-exact. |
| L6 | not started | 0. Done 2026-11-12 evening (owner-guided, BGB): the six print-frame tails are the side borders of the six wild frames (`Frame_BB_AAAA_WildFrameSides`, used); the print intensity screen; the four print-error pictures picked by `Rng_Next & 3`; the おもしろレンズ "?" lens slide show. Then the stamps (album stamp icon, mode `$05` reached by keys, 8 pages, `screens/stamps_kitty.png`). Left: the no-photo picture `11:7000` (no key path found: it needs a photo number with no slot). 1. Its character set (kana; the image-effect names drawn as sprite text). 2. The Kitt unlock milestones read in the code. 3. The kinds of the 17,198 uncertain bytes (L1: `Src_` blocks copied into WRAM buffers, the leftovers) and the 27 data names whose context is only the engine that reads them (runs that reach their screens). 4. Owner validation of names. |

## Pocket Camera Prototype (Japan) ("DEBAGAME")

| Level | Status | Left to do |
|---|---|---|
| L0 | done | - |
| L1 | done | 136,182 bytes (13 %) of uncertain kind on the layout map (2026-11-12, after the head rows of banks `$1C` (an edited strip of face photo 10, owner), `$1D` (an edited strip of face photo 8), `$23`, `PROGRAM` and the edited glyphs; 526,366 on 2026-11-10): the 250 unidentified leftover runs (82,860 B, `Leftover_BB_AAAA`: byte-per-pixel and ASCII-digit buffers of banks `$0C`-`$10` and `$12`-`$19`, no counterpart among this ROM's assets, no proof of PC memory) and the old builds' assets known only by name (`PROGRAM`, `HOI_0`, `KAO_1`-`3`). Settled: the TCRF assets, copies, parts and variants, the source text, 14 PC-memory runs, the older builds' bank-0 code and data (step 5). |
| L2 | done | - (2026-11-12: the 398 red bytes classified, `trace/red_proto.csv`: GATE 354, BEHIND 41, VECTOR 3; I). Optional: credit the BGB runs of the tester (they are not in the coverage arrays). |
| L3 | done | - (2026-11-11, extended 2026-11-12: 0 placeholder; 1,346 leftovers `Leftover_BB_AAAA[_<what>]`, 887 of them I and 459 C (the older builds' routines and data whose address and name a symbol table gives), owner rule; the TCRF unused assets named `Unused_TCRF_*`). Optional: confirm the 45 I names (developers' names matched from the two older builds) in the code or in BGB. |
| L4 | done | - (2026-11-12: 163 RAM names, C 126 / I 37; `wram/`, `sram/`, `SEQ_*` constants; 0 raw RAM operand). Optional: the `$B000-$BFFF` SRAM area (?) confirmed in BGB. |
| L5 | done | - (2026-11-12: `src/`, `make TREE=prototype_debagame check`, no rgbfix). |
| L6 | not started | 1. Its text (the title screen in kana). 2. **The rest of the older builds' bank-0 code**: banks `$2C` and `$37` hold the bank 0 of the builds of tables `$2A` / `$35`, banks `$1D` and `$20` two more builds; only the printer library is named so far (`disasm/printer_lib_proto.csv`): the other labels of the two tables can name the rest the same way (C in `$2C` / `$37`, copies found by their bytes in `$1D` / `$20`). 3. **Three builds, not two**: the in-memory symbol records of bank `$11` (`disasm/leftover_symtab_mem_proto.csv`) belong to a third build; place the four code banks and the three symbol lists in one build history. 4. The 364 unidentified leftover runs: byte-per-pixel buffers in rows of 381 bytes (banks `$0C`-`$10`, the same rows as the PC memory of `$08`-`$0B`), ASCII-digit buffers (`$12`-`$19`), bank `$3C`: no counterpart among this ROM's assets, no proof of PC memory; not aging patterns (the aging code computes them). 5. The kinds of the old builds' assets named from their symbol tables (`PROGRAM`, `BG_F_SCR`, `BG_EDIT`, `BG_EDITW`, `HOI_0`, `KAO_1`-`3`). |

## Target: the Japanese ROM's depth at every level (owner, 2026-11-12)

The owner wants Hello Kitty and the prototype taken as far as the Japanese ROM at each level, not only to the test of `HOWTO_NEW_ROM.md` §0. What the Japanese ROM has at each level, and what each of the two ROMs still lacks for it:

| Level | The Japanese ROM has | Hello Kitty lacks | The prototype lacks |
|---|---|---|---|
| L1 | 0 bytes of uncertain kind on the layout map | 17,198 uncertain bytes: the `Src_` blocks copied into WRAM buffers (their consumer not seen), the 109 leftovers | 136,182 uncertain bytes: the unidentified buffers (a decision for the owner), the old builds' assets known only by name |
| L2 | every never-run byte either run by a forced run (WRAM / SRAM pokes, `force_open.py`) or given a hand verdict (dead / unreachable, purple on the map: docs §16.21, §16.26) | the 7,607 red bytes are classified by their gate (I) but not opened: no forced runs on the gates, no hand verdicts, nothing purple | the 398 red bytes: same; and the BGB runs of the tester (aging error, `4M NG`) are not recorded as coverage |
| L3 | every name with its tag, the doubts list with verdicts, owner answers | the 40 doubts, settled where a BGB run can | the 45 doubts (the developers' names matched from the older builds), settled in the code or BGB |
| L4 | `wram/` (access tables per area, summary, `INDEX.md`), `sram/` (access table, map), `pocketcamera_jp_ram.sym`, constants (modes, keys, sounds) applied in the source | all of it (not started) | - (done 2026-11-12) |
| L5 | `src/`: split files, assets as sources, `make` checks the md5 | a `make_source.py` preset and its tree | - (done 2026-11-12) |
| L6 | partial: charset and texts, owner validation, open questions of `docs/12` | the kana set, the Kitt milestones, owner validation | the title text, the history of the four older builds and their three symbol lists |

## Order of work, across ROMs

Done: 1. quick consistency (2026-11-10); 2. the prototype's L3 (2026-11-11); 3. Hello Kitty L3 (2026-11-12); the prototype's leftovers (2026-11-11 / 12: TCRF assets, copies, parts, variants, PC memory, the printer library; uncertain bytes 526,366 -> 171,154); 4. the red bytes of both ROMs classified (2026-11-12, `tools/red_classify.py`).

The parity program, cheapest and most enabling first (sessions are estimates):

5. ~~**Prototype L1**~~ done 2026-11-12 (`tools/proto_oldbuilds.py`: 708 labels of the older builds' bank 0; the in-memory records of bank `$11` are a fifth build whose code is not in the ROM; the `BG_` assets are maps). Left for the owner: the unidentified buffers (139,718 uncertain bytes).
6. ~~**The tools L4 relies on**~~ done 2026-11-12: the coverage files of Hello Kitty and the prototype use the Japanese keys (`ex` / `dr` / `rdr`; 8 files and 21 tools converted); `tools/wram_db.py` and `tools/sram_db.py` run unchanged on both traces (Hello Kitty: 5,687 WRAM / HRAM / I/O accesses on 704 addresses, 423 SRAM sites; the prototype: 982 accesses on 180 addresses, 83 SRAM sites), in the Japanese tables' convention; `tcrf_check/tools/paths.py` replaces the dead `package/` paths of seven tools.
7. ~~**Prototype L4 and L5**~~ done 2026-11-12: `tools/proto_ram_names.py` (163 RAM names, 126 C from the older builds' tables checked by a shared routine), the SRAM map (`tools/sram_map.py --tag proto`), the `SEQ_*` constants (the constant pass of `tools/sym_fix.py` now follows compare chains `cp / jr nz / ... / ret / next: cp`, which also named 3 more key compares in each retail tree), the preset `--tree prototype_debagame` and `make TREE=prototype_debagame check` without rgbfix: the first ROM after the three retail ones to reach L5.
8. **Prototype L2 to the Japanese depth** (about 1 session): record the tester's BGB runs as coverage (execution watchpoints, as for Hello Kitty), then hand verdicts or forced runs for the rest of the 398 bytes.
9. **Hello Kitty L2 to the Japanese depth** (2-3 sessions): forced runs on the gates of `trace/red_kitty.csv` (WRAM / SRAM pokes; the linked exchange with two BGB instances; every sound id requested), then hand verdicts (dead / unreachable, purple) for what cannot run.
10. **Hello Kitty L1 to 0 uncertain bytes** (1-2 sessions): follow the `Src_` blocks into their WRAM buffers (who reads the buffer, what it becomes on screen), and the kinds of the leftovers.
11. **Hello Kitty L4** (3-4 sessions: WRAM, HRAM, SRAM with real saves, RAM names, constants), then **Hello Kitty L5** (1-2 sessions).
12. **L3 doubts of both ROMs** settled by BGB runs where a run can (alongside 8-9).
13a. **Hello Kitty, owner-guided screens** (about 1 session, BGB; the stamps done 2026-11-12): the おもしろレンズ lenses one by one (the slide show is one of them), the no-photo picture `11:7000` from a save with a gap in the photo numbers (forced, I). Run printer-linked BGB jobs alone: with the CPU shared, the link handshake stalls (2026-11-12).
13b. **Credit the BGB-only paths** (about 1 session): replay the owner's key paths of 13a and of 2026-11-12 (wild-frame print, print intensity, print without a printer, the lens slide show) in the core with `tools/kitty_core_paths.py`, so that the reachability map and the doubts list count them.
13. **L6 everywhere** (open-ended): the shared retail source, character sets and texts, the open questions of `docs/12`, owner validation of names (with the printer routines' developers' names), the build history of the prototype.
