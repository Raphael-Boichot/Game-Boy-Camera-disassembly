# How to disassemble the next Game Boy ROM (playbook written from the Pocket Camera (Japan) Rev A work)

Written 2026-10-14 for the next Claude session that gets a new ROM. Everything here was done at least once on `fdcfe686cf4df461e870b6e53b2b5a8b`
(README §1-§18); what was *not* done is marked **not done here**. Read `CLAUDE.md` first (standing rules, gotchas), then this file.
The ROM is never in the repository: ask for it, and for every sibling ROM (other region, revision, edition).
A condensed copy of this playbook, in skill format, is `skills/gb-rom-disassembly/SKILL.md`.

## 0. What "done" means: six levels

Say which level a claim is about. The Pocket Camera status is in README §1.3.

| Level | Definition | Test |
|---|---|---|
| L0 | The listing reassembles to the same md5 | `make` prints the md5 |
| L1 | Every byte typed (code / data with row width / text / padding) | the `.sym` covers 100 % of the ROM, builder reports no hole |
| L2 | Code *proven* (recursive descent, 0 unresolved indirect jumps) and **observed** (emulator coverage, forced runs) | `rom_trace.py` + coverage report |
| L3 | Every routine and asset has a name with an evidence tag; the doubts are listed | `sym_names_*.csv`, `sym_unconclusive_*.csv` |
| L4 | RAM variables and constants applied in the source (`wMode`, `hOamOffset`, `MODE_*`), no raw `[$D5CE]` | `grep` for raw RAM operands is empty |
| L5 | A source tree a person can build and edit: split files, assets as `INCBIN` / PNG / text sources, a `make` that checks the md5 | tree in git, CI check |
| L6 | Understanding: charset / text table (the Pocket Camera's name / comment table came from the font bank by rendering it and checking BGB screenshots pixel for pixel: README 16.27), sibling ROMs sharing one source, owner-validated names | owner answers file |

Do L0-L2 first (a few passes), but **start L4 and L5 as soon as L2 exists**: this project left them to the end and they are still open.

## 1. Intake (before any tool)

1. `md5sum`, header `$0100-$014F` (title, CGB / SGB flags, cartridge type = MBC, ROM and RAM size, header and global checksum), file size = 2^n x 32 KiB.
2. Collect every sibling ROM and diff them byte-wise per bank. The Pocket Camera pair differs in 44 % of its bytes (§16.1): static traces and coverage numbers **do not transfer** between builds, only the structure (mode numbers, flow) does. Do not assume a diff of two regions is small.
3. Toolchain, pin the versions: `rgbds v1.0.4` (the 1.0 syntax wants `ldh a, [$FFxx]`, not `ldh a, [$xx]`), `mgbdis v3.0` (`github.com/mattcurrie/mgbdis`). `pip` and `npm` work in the sandbox, other hosts do not (the shell is allow-listed).
4. Round trip with **no** symbols first: `python3 mgbdis.py --output-dir out rom.gb && cd out && make`. If the md5 differs here, fix this before anything else (header, global checksum, bank size).
5. Emulators: write a small SM83 core you own (this project: `coverage/src/gbcov.c`, ~460 lines + a `ctypes` wrapper; `gbcov_display.c` adds ROM-to-screen tracking and the forcing interface) for speed and instrumentation, **and keep BGB (Windows exe under `xvfb-run wine`) as the reference** for every screenshot, VRAM comparison and sound clip. The core draws some screens wrongly (README §15.8); BGB is not cycle-exact either but it is the judge.

## 2. Stage A: symbol file, the one source of truth for L1-L3

mgbdis v3.0 has **no `--sym` option**: it reads `<rom basename>.sym` from the ROM's folder. Syntax: `BB:AAAA Name` (hex), and block lines `BB:AAAA .code:LEN`, `.data:LEN[:WIDTH]`, `.text:LEN`, `.padding:LEN` (LEN in hex).

Never edit the `.sym` by hand. Keep two layered tables and a builder (`tools/sym_build.py`, copy it):

* `disasm/sym_names_<rom>.csv`: `bank,addr,name,conf,note,source`. Layers, later wins: `assets` < `auto` < `hand` < `fixes`. Name `-` deletes a label.
* `disasm/sym_types_<rom>.csv`: `bank,start,end,type,width,note`.
* the trace file (`wram/trace_*.json`, instruction starts and lengths).
* The builder makes every contiguous run of proven instructions a `.code` block, every other byte data (fill runs of 16+ bytes = padding), then the types table carves its ranges out. It **aborts** on a duplicate name, a label inside an instruction, a hole or overlap, a non-uniform padding block. These checks caught real mistakes, keep them.

Naming: `Module_Verb` PascalCase (`Album_DrawPage`); assets carry type, bank, address, consumer (`Gfx_17_5500_...` 2bpp tiles, `Map_24_4B20_...` tile map rows, `Src_BB_AAAA_...` far-pointer source of unknown class, `Sheet_..._BB_AAAA`, `*_Part<addr>` continuation). Every name has a tag **C** (code read, emulator or BGB confirmed) / **I** (inferred from caller, neighbour, table) / **?** (doubt). `tools/make_doubts.py` regenerates the doubts list after every rename.

**mgbdis artefact to fix right away**: it prints a label for *any* operand equal to a label of the current bank (or of bank 0 below `$4000`): `ld bc, Label` for a byte count, `ld [Label], a` for an MBC register write, far-pointer loads in the wrong bank, word tables as `db`. `tools/sym_fix.py --tables` repairs what the instruction bytes decide (bytes unchanged, md5 unchanged). Expect to extend its rules for every ROM.

## 3. Stage B: the static tracer (`tools/rom_trace.py`)

Recursive descent from: the vectors and the entry point, every code label, the mode / state tables, then **hand roots** (`tools/extra_roots.json`, each with a reason). Order of work that paid off:

1. Find the engine's *helpers* before anything else: banked call (`call $08C1`, A = bank, HL = target), one-way far jump, banked copy to RAM / VRAM (`$0450`, `$0586`...), the `rst` tables (`rst $18` = jump table, words inline), wait loops (`rst $08`, `rst $10`). Teach the tracer each helper once: that resolved 276 far calls.
2. Run it, list the **unresolved indirect jumps** (`jp hl`, computed `call`), resolve each by hand (table idiom, split immediates `ld a,lo; ld [var],a; ...`, cooperative task entries, callbacks stored in RAM), add roots, repeat until **0**. Do not stop at "few".
3. Consistency checks: no overlapping instructions, every callback ends in `ret`/`jp`, no invalid opcode on a proven path.
4. Known trap: an inline `rst` table read one word too long swallows the first instruction of the next handler (`05:48C4`): bytes were right, labelling wrong. Cap table length by the lowest target seen.
5. Separate **reachable** from **live**: 45 roots decode cleanly but nothing calls them. Keep them as "dead roots", never as code that runs.
6. Give the tracer only the first-pass labels (`tools/rom_trace_labels.sym`, 183 names), not the finished symbol file: it takes every name that does not start with `.data` as a code root, so a file that also names tables and tiles gives a different (wrong) trace.

`tools/rom_coverage.py` then says per bank: proven code, inline tables, referenced data, padding, unreferenced. The "unreferenced" bytes inside code banks are the hand-work list; a bank-0 `ld hl,nn` with nn >= `$4000` is credited to every bank, so treat that number as an upper bound.

## 4. Stage C: data and assets

1. **Copy-site catalogue**: every call of the banked copy helper with constant bank / source / destination / length (`tools/asset_catalog.py`, `tcrf_check/tools/copy_sites.py`). A far pointer counts only if the immediate reaches the helper unchanged; `ld hl,TABLE; add hl,bc; ld a,[hl+]` is a local pointer table, not a far pointer.
2. Render everything: 2bpp tile sheets 16 tiles wide (`tools/render_tiles.py`, `tcrf_check/tools/bank_sheet.py`), tile maps 32 bytes wide. Typing by picture is allowed but tagged (`visually identified range`).
3. Match against outside sources (TCRF, Spriters Resource) with care: pictures can be **2x enlargements**, palettes fold, tiles flip; a 1-2 tile exact match is weak evidence.
4. Data banks nobody references are found by the **emulator ROM-read log** (which routine reads which range), not by static analysis.
5. Table-driven extents (message strips, head tables, credits rows) give the exact size of an asset: read the loop count.

## 5. Stage D: RAM map (do this early, and wire it into the source)

1. `tools/wram_db.py ROM trace SYM OUT`: every instruction touching `$C000-$DFFF`, `$FF80-$FFFE`, `$FF00-$FF7F`, with R / W / P (pointer load) kinds and written constants. `tools/ram_census.py` does the same on a listing. Read-modify-write through HL is invisible: read the code.
2. Write one table per region (`wram/wram_<region>.csv`, address, name, type, writers, readers, evidence tag C/I/U) and the narrative beside it. Real saves of the cartridge RAM (SRAM) are worth more than any guess for the SRAM layout: use as many as you can get, and look for checksums, mirrors, magic strings.
3. The modes and states variables (`$D5CE` / `$D5CF`) tell you the screen flow: record it first.
4. **Apply the names (L4). Tested 2026-10-14: mgbdis accepts RAM labels in the `.sym`** (`00:d5ce wMode`, `00:ff9a hOamOffset`, bank 00 so they apply to every bank) and substitutes them everywhere; the assembler then fails with "undefined symbol" until an include defines them (`DEF wMode EQU $D5CE` or `SECTION "WRAM"` + `ds`). The same false-positive class as in section 2 applies (`ld bc, $D5CE` as a length): extend `sym_fix.py`. **Not done here** for the Pocket Camera (0 RAM labels in the sym).

## 6. Stage E: dynamic evidence

Order: own core with instrumentation first (fast, millions of frames), BGB second (truth).

1. **Coverage run**: fuzz joypad sequences (taps, 8 single keys, **chords** of 34 keys), seed with real saves, keep a replayable corpus (`coverage/tools/coverage_run.py`, `replay_corpus.py`). 95.3 % of the proven instructions executed this way (82.7 % by joypad + save only).
2. What is left is gated by **data or chords**, not single keys: a direction pressed while A is held, counter wraps, filled tables, out-of-range cursors, save contents, race state. Poke WRAM / SRAM between frames to force them (`tcrf_check/tools/force_open.py`). Two limits: a poke lands between frames (a value the main loop recomputes every frame cannot be forced), and a value known only inside the frame needs a two-pass snapshot / restore.
3. **Table overruns** (a state number past the end of its word table) run garbage words: count them as `state_overrun`, never as designed paths.
4. **Forcing** (README §16.26): a core with `gb_jump`, `gb_set_stop`, `gb_force_flip`, register get / set and a write log. Enter an unreferenced function by a jump at a **safe idle point** (the main thread's `halt` / wait call; 30 base modes here, 4 modes had none), flip a gating branch to enter an unreachable block. Replay in BGB through a hook assembled into free bank-0 bytes and called from the main loop. Forced code that is proven dead stays **evidence I**: a patched PC or branch is not a way the game can run.
5. Display tracking: a core that follows every ROM byte to the screen says which assets are *really* never shown (README §16.24).
6. BGB harness (`tcrf_check/tools/bgb_run.py`): a demo file = one joypad byte per frame (A=1 B=2 Select=4 Start=8 Right=$10 Left=$20 Up=$40 Down=$80), 250-frame boot hold, run headless (`BGB_HF=-headless` if a linked run stalls), `-stateonexit` for RAM / VRAM / OAM, `-screenonexit` (160 x 144 only), breakpoints with `-br`. About 250 runs in 4 minutes on two CPUs. Long jobs: `setsid nohup`, a foreground call over 120 s is killed.

## 7. BGB pitfalls (all hit once)

* BGB refuses VRAM writes in PPU mode 3 (161 of 256 bytes landed in one test); write when the LCD is off or in mode 0 / 1.
* BGB logs numbers in hex. Its WAV clock is not a constant offset from the frame count (up to ~1 s): find a sound by content.
* BGB needs 3 more boot frames than the core.
* Read register writes at the right pc (`1F:525F`), not the last write of the register: later engine writes overwrite what you wanted.
* A sym parser that expects upper-case hex silently found nothing: the claim "no open asset is displayed" was wrong for that reason. Parse hex case-insensitively and test the parser on a known label.
* `pkill -f PATTERN` kills your own shell if PATTERN is in its command line: kill by PID.
* Pictures from the core are not evidence of a screen (VIEW band, one stamp slot wrong): take BGB screenshots.

## 8. Evidence discipline (what kept the README honest)

* Tag every claim **C / I / ?**; "never guess" means write `?` and say what was not checked.
* Recompute any number before quoting it; regenerate derived tables with the tool, not by hand. Real corrections made in this project: `$D92E` "never written" (the D.J. editor writes 1-8; only the *reader* is dead), flips that "keep a menu on screen" described backwards, a gate-hit range quoted from the wrong column, the "TAILS" set over-claimed.
* L3 lessons (Pocket Camera L3 pass of 2026-10-14: 169 `?` -> 5, 610 doubtful rows -> 341, log in `disasm/renamed_jp.csv`): (1) asset names that embed a caller (`Gfx_BB_AAAA_Caller`) go stale when function labels are refined: refresh them in one batch and keep an old -> new CSV; (2) a run of 16+ equal bytes becomes `.padding` and hides the extent of the table or map around it, so read the loader before trusting a split, and give maps their fill rows; (3) before calling a block unreferenced, check the copy-site ranges **and** the custom loaders: lists of `{src,bank,dst,len}` records (here `Parlor_PageTbl`), tables indexed by a value (`swap a` = x16, plus `sla c; rl b` = x32), glyph fonts indexed by char code (`Glyph_LoadFromCharCode`, list loaders); (4) a far pointer whose bank is loaded into `C` or sits in a record is invisible to a scan for `ld a,BANK`; (5) an auto label made by `ld hl,imm` for a far bank can cut a real table in two (`09:6000`), and the same address can be a real local table in the current bank and a far target elsewhere: read both; (6) a "really unused" verdict is evidence I and can fall when a loader is found (`10:74A3`); regenerate the derived pictures or say they are snapshots; (7) compare hex addresses in Python, not awk (`6E80` is a number to awk); (8) **sprite positions create false labels**: `ld bc,$xxxx` before an OAM meta-sprite call is a position (B = x, C = y), and the auto labeller turns any executed 16-bit immediate that equals a ROM address into a data label (19 here, six of them cutting one 2 KB shift table): teach the labeller the callee list, and re-read every table that was cut at an odd place; (9) **indexed font and record-list loaders** hide whole banks from a copy-site scan (a font addressed by character code, `7600 + 16 k`, lists of `{meta id, duration}` or `{src, bank, dst, len}` records): find the routine that walks the list before calling a span unused, and withdraw the verdict in the derived lists; (10) **a read check on the real emulator** is cheap: replay one corpus entry with logging watchpoints (a write per hit, emulation goes on) and a control watchpoint on bytes that certainly are read, then a count of 0 means "not read" (`tcrf_check/tools/bgb_wp_probe.py`).
* **Audit lessons (Pocket Camera: re-check of the `?` labels and consistency audit, 2026-10-18; no count here, the numbers live in the README):** (1) the same figure was quoted in 5-8 places (README §1.1.1 / §1.3 / the L-table, CLAUDE.md, the skill, this file) and drifted: write `tools/check_repo_consistency.py` as soon as a second copy of a number exists. One regex per quoted figure compared with the file it comes from (`need=` makes a reworded sentence a failure, not a silent pass); regenerate-and-diff every generated file (`.sym`, doubts list and bank pictures, layout map and per-bank CSV, reachability map); check that quoted `§` numbers and asset labels exist, that a name carries its own address, and the md5 round trip. Validate a new pattern on the OLD file and the OLD sentence first: it must reproduce the figure the doc already states (this caught a wrong regex that matched another table's total). (2) **A `?`, `_Aux` or `_Unref` label, or a "by eye" note, is a hypothesis.** Three of the eight `?` labels changed when re-derived: `0C:6AB0` "kana strips" was 336 B of `$00` and 3 tiles, `0C:5800` is 23 exact tile copies of a loaded block, and the loader of `0D:7000` is absent from both ROMs. Re-derive: exact match of every tile over the whole ROM and the sibling ROM, a loader scan (immediates with the bank, pointer tables, the copy-site CSV), then the display tracker, which is value-matched, so look for duplicates of the tiles first. (3) **Tile maps** are blocks of fixed-width rows (here 18 rows of 32 bytes = 0x240 B, 20 visible columns and 12 hidden) laid out in chains 0x240 apart: check both neighbours and the hidden columns before fixing a start, and type the rows as a map (`data,32,Map`; five head rows were typed as tile sets). In the types CSV the rows are applied in order and the last row wins. (4) A name that carries an address must carry its own (`Gfx_BB_AAAA_...`); a continuation of a parent asset is `_Part<addr>` with its own address. (5) A generator that overwrites a hand-kept paragraph (`display_report.py` and the tail of `really_unused.md`), or an input list that is a frozen snapshot (`open_assets.csv`), must say so in its docstring and in the README, or it gets regenerated and loses information. (6) A seam search with a shuffled-neighbour control is evidence only for whole maps and lower halves; an upper half does not recover true blocks.
* Keep the owner's answers in a CSV (`disasm/owner_answers_jp.csv`); names the owner confirmed move from I to C.
* README and checklist CSV / MD are updated **together**; the README says what was done and what was not.
* Deliver one commit per batch; `git fetch origin`, `git merge-base --is-ancestor origin/main HEAD`, `git push origin <branch>:main`.

## 9. Recommended order for the next ROM (with this project's lessons applied)

1. Intake, no-symbol round trip (section 1). Header, sibling diff.
2. Copy the builder (`sym_build.py`), `sym_fix.py`, `rom_trace.py`, `make_doubts.py`; adapt the helper list of the tracer to the new engine (banked call, copy, rst tables).
3. Trace to 0 unresolved, build the first complete `.sym` (L1), md5 check in a script that you run after **every** CSV change. Add the consistency checker (section 8) as soon as the docs quote a number twice.
4. WRAM / HRAM access database, then **apply the RAM labels at once** and extend `sym_fix.py` for false positives. Commit the include file.
5. Name the engine, then the mode / state handlers, then assets by consumer. Tag as you go; run `make_doubts.py`.
6. Write the core, run coverage, build the reach map (code / data / never touched) and a ledger of what each run proved.
7. BGB confirmation of the mode list and of every asset class; screenshots in BGB only.
8. Text: find the font tile bank early, build the charmap from the glyph sheets and confirm it on BGB screenshots (done here for the name and comment fields only: `disasm/charset_jp.csv`, README §16.27; the other texts are **not done here**).
9. Split the tree (L5): per-bank `.asm` files committed, assets as `INCBIN`, constants file, a `make check` that rebuilds and compares the md5. **Not done here**: the listing is regenerated by mgbdis and not committed.
10. Second ROM (other region): trace it separately; the Pocket Camera pair differs in 44 % of its bytes (§1 step 2), so names do not port automatically. **Not done here** (the international ROM has no `.sym`).

## 10. Files to copy from this repository

`tools/sym_build.py`, `tools/sym_fix.py`, `tools/rom_trace.py` (+ `tools/extra_roots.json` as a template), `tools/rom_coverage.py`, `tools/wram_db.py`, `tools/ram_census.py`, `tools/asset_catalog.py`, `tools/make_doubts.py`, `tools/check_repo_consistency.py` (adapt its patterns to the new docs), `tools/bank_pics.py`, `tools/render_tiles.py`, `tcrf_check/tools/bank_sheet.py`; `coverage/src/gbcov.c` + `gbcov.py` (core), `coverage/tools/coverage_run.py`, `replay_corpus.py`; `tcrf_check/tools/bgb_run.py`, `bgbgrab.py`, `bgb_dead_hook.py`, `gbcov_display.c`, `dead_jump.py`, `dead_flip.py`. Paths and constants inside them are specific to the Japanese Pocket Camera (the far-call helper addresses, the bank list, `GBCAM_*` environment variables): read each header before use.
