# Roadmap: what is left for L0-L6, every ROM

Written 2026-11-09, after the consistency audit (steps 1-5) and step 6 items 1-2. The levels and the status words are those of `HOWTO_NEW_ROM.md` section 0: `done` only when the level's test holds in full for that ROM, `partial` with what is left, `not started`. The **Status** column of each table must equal the Levels table of the ROM's README; `tools/check_repo_consistency.py` compares them, and the summary at the top of `README.md` too. Update the three together.

## Pocket Camera (Japan) (Rev A): the reference

| Level | Status | Left to do |
|---|---|---|
| L0 | done | - |
| L1 | done | - (2026-11-10: the last 32 uncertain bytes, `19:7FE0-7FFF`, are the four masks of the large pen, `Pen_LargeMask0`-`3`; 0 uncertain bytes) |
| L2 | done | Nothing that a run can prove: the 45 dead roots and the 1,192 never-run bytes, all classified, stay evidence I (docs §16.21, §16.26). |
| L3 | done | - |
| L4 | done | - |
| L5 | done | - |
| L6 | partial | 1. The record format of the 1,713 data bytes still on the default typing (`docs/01` §1.2, refreshed 2026-11-10). 2. The open questions of `docs/12`: the F34-F35 checksum mismatches, who writes `1B 13`, the meaning of the sound ids, the sensor items. 3. Owner validation of names (`disasm/owner_answers_jp.csv`). 4. **One source for the three retail builds** (Japanese, international, Gold) with build switches instead of three generated trees: the largest L6 item, shared with the international and Gold ROMs. |

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
| L1 | done | Every byte is typed, but 204,703 bytes (19.5 %) are of uncertain kind on the layout map (`UNC`): settled in L3. |
| L2 | done | 7,607 bytes of proven code that no run executed and nothing explains (red on the reachability map): classify them (dead, gated, forced only), as the 1,192 Japanese bytes were. |
| L3 | partial | 1. The kinds of the 204,703 uncertain bytes (loaders, copy sites, the display tracker). 2. The 822 placeholder names, named by kind and consumer. 3. The 15 doubts (`disasm/sym_unconclusive_kitty.csv`). |
| L4 | not started | 1. The WRAM access and summary tables (`tools/wram_db.py` reads this trace format). 2. RAM names with a scope per row. 3. Constants: modes and states (`disasm/mode_names_kitty.csv` exists), keys, sound ids. 4. The SRAM access table and map (`tools/sram_db.py` reads this trace format; the layout needs real Kitty saves; the Kitt counter and its unlock thresholds belong here). |
| L5 | not started | A `tools/make_source.py` preset for this ROM; a source tree that builds byte-exact. |
| L6 | not started | 1. Its character set (kana; the image-effect names drawn as sprite text). 2. The Kitt unlock milestones read in the code. 3. Owner validation of names. |

## Pocket Camera Prototype (Japan) ("DEBAGAME")

| Level | Status | Left to do |
|---|---|---|
| L0 | done | - |
| L1 | done | 526,606 bytes (50 %) of uncertain kind, almost all in the leftover banks of the older builds: settled in L3 or by the owner's rule below. |
| L2 | done | 398 red bytes, all in bank `$00` (the timer interrupt, the self-test error paths, the link code): classify them. |
| L3 | partial | 1. **The owner's rule first**: how to name the 110 leftover byte runs that nothing reads (for example `Leftover_BB_AAAA`), and whether the leftover banks get one block name per old bank. 2. The 52 I names (developers' names matched from the two older builds): confirm them in the code or in BGB. |
| L4 | not started | Small: the WRAM table (`GAME_SEQ` and the test variables), the constants, the SRAM map of the test patterns (AGING, PROTECT). |
| L5 | not started | A `tools/make_source.py` preset whose build skips rgbfix, so that the image as dumped rebuilds byte-exact. |
| L6 | not started | 1. Its text (the title screen in kana). 2. Its relation to the two older builds (the leftover symbol tables). |

## Order of work, across ROMs

1. ~~**Quick consistency**~~ done 2026-11-10: `docs/01` §1.2 refreshed; 0 red bytes on the international and Gold maps; their WRAM summaries and `INDEX.md`; the 32 uncertain Japanese bytes named.
2. **The owner's naming rule for the prototype's leftover bytes**, then the prototype's L3 (small; closes one ROM's L3).
3. **Hello Kitty L3**: the data kinds, then the 822 placeholder names (the largest naming job, about 3-4 sessions).
4. **L2 red classification of Hello Kitty and the prototype** (7,607 and 398 bytes; easier once the L3 names exist).
5. **The tools L4 relies on** (step 7 of the audit): one convention for the arrays of the coverage files (`ex` / `dr` in the Japanese, international and Gold files, `exec` / `dread` in Hello Kitty and the prototype), `tools/wram_db.py` checked on every trace format, the BGB scripts with dead `package/` paths; otherwise each L4 grows new one-off scripts.
6. **Hello Kitty L4** (WRAM, RAM names, constants, SRAM with real saves; several sessions), then **the prototype's L4** (about one).
7. **Hello Kitty and prototype L5**: source trees through new `make_source.py` presets (about one session each).
8. **L6 everywhere** (open-ended): the shared retail source, character sets and texts, the open questions of `docs/12`, owner validation of names.
