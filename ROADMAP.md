# Roadmap: what is left for L0-L6, every ROM

Written 2026-11-09, after the consistency audit (steps 1-5) and step 6 items 1-2; regenerated 2026-11-12, after items 1-3 of the order of work below and the prototype's leftover analysis (TCRF assets, copies, parts and variants, PC memory, the older builds' printer library). The levels and the status words are those of `HOWTO_NEW_ROM.md` section 0: `done` only when the level's test holds in full for that ROM, `partial` with what is left, `not started`. The **Status** column of each table must equal the Levels table of the ROM's README; `tools/check_repo_consistency.py` compares them, and the summary at the top of `README.md` too. Update the three together.

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
| L1 | done | Every byte is typed; 51,557 bytes (4.9 %) stay of uncertain kind on the layout map (2026-11-12, 204,703 before the data names): the `Src_` blocks copied into WRAM buffers and never seen in VRAM, and the 110 leftovers. Their kinds are an L6 question. |
| L2 | done | 7,607 bytes of proven code that no run executed and nothing explains (red on the reachability map, checked 2026-11-12; the other 5,682 never-run bytes are already classified: 4,155 effect, 670 gate, 857 forced-mode): classify them (dead, gated, forced only), as the 1,192 Japanese bytes were; most are in bank `$06` (the exchange states that need a follower) and bank `$00` (`Link_Irq_Connected`, branches of `Prn_SendData`). |
| L3 | done | - (2026-11-12: 0 placeholder; every data block named by kind and consumer, `tools/kitty_data_names.py`; 110 leftovers `Leftover_BB_AAAA`, I, owner rule; 40 doubts in `disasm/sym_unconclusive_kitty.md`, 14 of them final). |
| L4 | not started | 1. The WRAM access and summary tables (`tools/wram_db.py` reads this trace format). 2. RAM names with a scope per row. 3. Constants: modes and states (`disasm/mode_names_kitty.csv` exists), keys, sound ids. 4. The SRAM access table and map (`tools/sram_db.py` reads this trace format; the layout needs real Kitty saves; the Kitt counter and its unlock thresholds belong here). |
| L5 | not started | A `tools/make_source.py` preset for this ROM; a source tree that builds byte-exact. |
| L6 | not started | 1. Its character set (kana; the image-effect names drawn as sprite text). 2. The Kitt unlock milestones read in the code. 3. The kinds of the 51,557 uncertain bytes (L1: `Src_` blocks copied into WRAM buffers, the leftovers) and the 27 data names whose context is only the engine that reads them (runs that reach their screens). 4. Owner validation of names. |

## Pocket Camera Prototype (Japan) ("DEBAGAME")

| Level | Status | Left to do |
|---|---|---|
| L0 | done | - |
| L1 | done | 171,154 bytes (16 %) of uncertain kind on the layout map (2026-11-12; 526,366 on 2026-11-10): the 364 unidentified leftover runs (109,647 B, `Leftover_BB_AAAA`) and the old builds' assets named from their symbol tables (`Data_BB_AAAA_<name>`, I). Settled since: the TCRF assets, 467 copies and 10 variants of identified blocks (any offset, any alignment), the source text, 14 PC-memory runs (strings, x86 code, in-memory symbol records), the printer library. What stays is an L6 question (below). |
| L2 | done | 398 red bytes, all in bank `$00` (the timer interrupt, the self-test error paths, the link code; checked 2026-11-12): classify them. |
| L3 | done | - (2026-11-11, extended 2026-11-12: 0 placeholder; 1,064 leftovers `Leftover_BB_AAAA[_<what>]`, 986 of them I and 78 C (the printer library routines whose address and name a symbol table gives), owner rule; the TCRF unused assets named `Unused_TCRF_*`). Optional: confirm the 45 I names (developers' names matched from the two older builds) in the code or in BGB. |
| L4 | not started | Small: the WRAM table (`GAME_SEQ` and the test variables), the constants, the SRAM map of the test patterns (AGING, PROTECT). |
| L5 | not started | A `tools/make_source.py` preset whose build skips rgbfix, so that the image as dumped rebuilds byte-exact. |
| L6 | not started | 1. Its text (the title screen in kana). 2. **The rest of the older builds' bank-0 code**: banks `$2C` and `$37` hold the bank 0 of the builds of tables `$2A` / `$35`, banks `$1D` and `$20` two more builds; only the printer library is named so far (`disasm/printer_lib_proto.csv`): the other labels of the two tables can name the rest the same way (C in `$2C` / `$37`, copies found by their bytes in `$1D` / `$20`). 3. **Three builds, not two**: the in-memory symbol records of bank `$11` (`disasm/leftover_symtab_mem_proto.csv`) belong to a third build; place the four code banks and the three symbol lists in one build history. 4. The 364 unidentified leftover runs: byte-per-pixel buffers in rows of 381 bytes (banks `$0C`-`$10`, the same rows as the PC memory of `$08`-`$0B`), ASCII-digit buffers (`$12`-`$19`), bank `$3C`: no counterpart among this ROM's assets, no proof of PC memory; not aging patterns (the aging code computes them). 5. The kinds of the old builds' assets named from their symbol tables (`PROGRAM`, `BG_F_SCR`, `BG_EDIT`, `BG_EDITW`, `HOI_0`, `KAO_1`-`3`). |

## Order of work, across ROMs

1. ~~**Quick consistency**~~ done 2026-11-10: `docs/01` §1.2 refreshed; 0 red bytes on the international and Gold maps; their WRAM summaries and `INDEX.md`; the 32 uncertain Japanese bytes named.
2. ~~**The prototype's L3**~~ done 2026-11-11 (owner rule: `Leftover_BB_AAAA`, tag I).
3. ~~**Hello Kitty L3**~~ done 2026-11-12 (data names by kind and consumer; leftovers by the owner rule).
   - ~~**The prototype's leftovers**~~ (owner requests, 2026-11-11 / 12): the TCRF unused assets located and named; copies, parts and variants of identified blocks; PC memory by strings, x86 code and in-memory symbol records; the printer library of the older builds. Uncertain bytes 526,366 -> 171,154.
4. **L2 red classification of Hello Kitty and the prototype** (7,607 and 398 bytes; the L3 names now exist).
5. **The prototype's older builds** (L6 items 2-3 of the prototype, about one session): name the rest of their bank-0 code from tables `$2A` / `$35` as the printer library was, find the copies in banks `$1D` / `$20`, and place the third build of bank `$11`. Cheap now that the tools exist, and it settles more uncertain bytes.
6. **The tools L4 relies on** (step 7 of the audit): one convention for the arrays of the coverage files (`ex` / `dr` in the Japanese, international and Gold files, `exec` / `dread` in Hello Kitty and the prototype), `tools/wram_db.py` checked on every trace format, the BGB scripts with dead `package/` paths; otherwise each L4 grows new one-off scripts.
7. **Hello Kitty L4** (WRAM, RAM names, constants, SRAM with real saves; several sessions), then **the prototype's L4** (about one).
8. **Hello Kitty and prototype L5**: source trees through new `make_source.py` presets (about one session each).
9. **L6 everywhere** (open-ended): the shared retail source, character sets and texts, the open questions of `docs/12`, owner validation of names (with the printer routines' developers' names), the remaining uncertain bytes of Hello Kitty and the prototype.
