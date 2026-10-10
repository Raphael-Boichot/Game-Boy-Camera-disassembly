# What is lacking for a confident, round-trip-verifiable disassembly -- code side

Pocket Camera (Japan) Rev A, md5 `fdcfe686cf4df461e870b6e53b2b5a8b`.  Written against `tools/rom_trace.py` (not edited) and `work/trace_jp.json` (not edited).

Files produced:
* `work/rom_trace_try.py` -- copy of the tracer.  Without `--roots` it reproduces `work/trace_jp.json` exactly (checked: `code` and `unresolved` identical).  With `--roots` it switches on four rules (see C) and the 23-entry `RESOLVED_JPHL` table.
* `work/extra_roots.json` -- 134 roots `[[bank, addr, reason], ...]`: 89 live (reachable by a mechanism the tracer lacks) + 45 whose reason starts with `DEAD-CODE (unreferenced)`.
* `work/trace_jp_v3.json` -- trace with all 134 roots.  `work/coverage_jp_v3.csv` -- `rom_coverage.py` on it.
* Reproduce: `python3 -I work/rom_trace_try.py pocketcamera_jp.gb pocketcamera_jp.sym work/trace_jp_v3.json --roots work/extra_roots.json`

## 0. Result

| | proven instructions | proven code bytes (banks 00,02-0A,1F) | `unresolved` | unreferenced bytes in code banks |
|---|---|---|---|---|
| baseline `trace_jp.json` | 56,799 | 111,808 | 14 | 3,710 |
| + 89 live roots + rules | 59,866 | 116,613 | 0 | |
| + 45 dead-code roots (`trace_jp_v3.json`) | 60,449 | 117,627 | 0 | 2,400 |

Gain from the live roots/rules, measured one category at a time: tracer rules + the 23-entry `RESOLVED_JPHL` table alone +214 instr (this alone clears the 14 `unresolved`), bank-0 helper bodies +62, bank 3 +298, bank 7 +48, **bank 0A jump table +2,444** (96 entries, tracer capped it at 32; 60 new targets), total +3,067 (parts overlap by 1).  The dead-code roots add 583 instr / 1,014 B that no path reaches: they are "decodes cleanly, nobody calls it", not "proven live".  Keep that distinction when counting.

Per bank (code bytes before -> after / unreferenced before -> after): 00 11,177->11,896 / 485->47; 03 14,063->14,701 / 210->12; 04 13,354->13,474 / 138->18; 05 14,727->14,798 / 69->0; 06 12,810->12,834 / 24->0; 07 13,254->13,639 / 88->0; 09 10,919->10,971 / 52->0; **0A 7,408->11,091 / 2,440->2,251**; 1F 3,918->4,045 / 201->69; 02 and 08 unchanged.

Consistency checks on v3: 0 overlapping instructions (no start inside another instruction or table word); every one of the 72 distinct far-call targets, 140 sound-table targets, 96 0A-table entries and all callbacks decodes to a `ret`/`jp` without an invalid opcode (the one non-terminating target is the main loop 00:2E92); all 276 `call $08C1` sites resolve.

## A. Indirect control flow resolved (site, mechanism, roots, evidence)

| site | mechanism | resolution / evidence |
|---|---|---|
| 03:5F68, 5F76, 5F91, 5F9F | `ld hl,pc+1; push hl; ... ; jp hl` (callback helper, DE = per-step routine) | continuations 5F69 / 5F92 rooted; every DE target in the 36-step callers is an already proven `ret` or 50BA |
| 07:792C, 7BF3, 7C1A, 7C62, 7C89, 7CD1, 7CF8, 7D27 | callbacks from 6-byte-entry tables (7985, 79E5, 7A43, 7A5E, 7A85, 7AAC, 7AD3) and animation helpers 7BDC/7C4B/7CBA, return address pushed first | callbacks 7AF1/7AF6/7AFB/7B00/7B05, continuations 792D/7BF4/7C63/7CD2/7D28, wait helper 7D11 rooted; all callbacks end in `ret` (`terms.py` walk) |
| 0A:5419 | `jp hl` via table 0A:541A, index A = `[06:60DB+idx]` OR 0/$20/$40 (far call 06:781D -> 0A:7CFE -> 5406) | 96 entries, 92 distinct targets, 60 new; all valid |
| 1F:52E9, 52F7, 5309, 5317, 5329, 5337 | sound driver pointer tables 41FA..433E guarded by `cp N; ret nc` | 140 targets, all already rooted by `manual_roots` |
| 00:02A7 `call $FF80` | OAM DMA stub copied by 00:03E2 from 00:03F0 into HRAM | root 00:03F0 (the ROM image of the stub) |
| 00:0026, 03A5, 08C0, 08CF | `rst $18` body, `$038A` dispatcher tail, far-call trampolines | bodies rooted: 0008, 0010, 0018, 038A, 03A6, 0380, 08BB, 08C1, 0060 |
| 00:031A | `ld hl,$0210; push hl; reti` soft reset | root 00:0210 |
| 03:562D, 5637, 5919, 5923 | cooperative tasks: PC stored as split immediates (`ld a,lo; ld [$D6FD],a; ld a,hi; ld [$D6FE],a`, also $D70D, $D6ED), resumed by `pop..; ret` | roots 03:57BE, 5847, 5A7A, 5B00; word tables of task entries at 03:568B (5691/57BE/5847) and 03:59F1 (59F7/5A7A/5B00) |

Rules in the try copy (all verified against the whole ROM): (1) `ld rr,pc+1 ... push rr ... jp hl|ret` => continuation is code (10 sites, 0 false hits after requiring a `push` before the `ret`); (2) `ld rr,nn; push rr; ret|reti` => nn is code (1 site); (3) a call to $8000+ is recorded in `ramcalls` and the RAM image is rooted (1 site); (4) an `rst $18` table stops at a `.sym` code label (fixes one over-run, below).

## B. The 15 unreferenced regions >= 32 B (baseline list) -- final verdict

| region | verdict | evidence |
|---|---|---|
| 00:0004-003f | LIVE: rst $08/$10/$18 bodies; $20-$38 are `00` padding | bodies rooted |
| 00:069f-06d5 | DEAD code | no operand/table/split-immediate reference anywhere in the ROM; clean decode to ret/jp |
| 00:0751-077f | DEAD code (4 entries) | same |
| 00:10ac-10ff | DEAD code 10AC-10CF (writes NR10-NR14 from a preset table indexed by [$D92E]) + DATA 10D0-10FF (8 offsets + 8 five-byte NR10-14 presets) | nothing calls 10AC; table is `ld hl,$10D0` inside it |
| 00:1aeb-1b1d | DEAD code | same |
| 00:2523-2552 | DEAD code (2523, 253C; 24F1 before it) | same |
| 03:5a7a-5b3f | LIVE: cooperative task entries 5A7A, 5B00 | split-immediate stores at 03:5919/5923 |
| 04:7c9d-7cf6 | DEAD code | same as 00:069f |
| 05:7f1c-7f49 | DEAD code, byte-identical twin of 09:721D | same |
| 07:4bc3-4bff | DEAD code | same |
| 09:721d-723e | DEAD code (twin of 05:7F1C) | same |
| 0a:6906-69b2 | LIVE: target of `jp $6906` from table-0A entries (5E28...) | proven after the 0A table fix |
| 0a:6bdd-74a7 | DATA/padding: 6BDD-72FF = 1,827 B of `00`; 7300-73FF popcount table; 7400-74FF bit-reverse table | both tables verified byte-exact; used by `ld h/b,$73/$74` page loads (0A:5091, 509C, 54EC, 5AC3, 5E46...) which `rom_coverage` cannot see |
| 1f:4000-4036 | DATA: sound parameter tables in front of the note-period table at 4037 (`ld hl,$4037`, 1F:563D) | does not decode as code; consumer is an index computed from the song stream, not statically visible |
| 1f:53b9-540e | DEAD code | same as 00:069f |

Beyond the 15 regions: 28 smaller dead fragments rooted (library stubs: IE bit 0 clear/set 00:03D4/03DB, delay loops, serial helpers, sound-effect starters 1F:46DD and the sound entry stub 1F:7FF3, an unreferenced alternate entry 07:503D, a lone `reti` 00:0367 and `ret` 00:1C56, `inc b` 0A:4C53).  Note 0A:4C51: `bit 3,a; jr $4C54` is an *unconditional* jr that skips `inc b`; it looks like a ROM bug (`jr z` intended) but the bytes are what they are.

What is left unreferenced in code banks after v3 (2,400 B, none of it unknown code): 0A:6bdd-74a7 2,251 B (above); 1F:4000-4036 55 B; five-byte sound presets 1F:4879, 4F28, 5054 (14 B); 04:4D09 18 B data; 00:0104-0118 (Nintendo logo, header); 00:1EDE mask table 16 B; 00:2E88 string `MAIN PASS`; 03:568B and 03:59F1 task-entry word tables; 02:46E6 3 B.

## C. What still blocks a confident round-trip disassembly

Indirect flow, after this work (sites in proven code):

| kind | sites | status |
|---|---|---|
| `jp hl` | 31 | 8 by jump-table idiom, 23 by hand/rule, **0 unresolved** |
| `rst $18` inline tables | 46 | all end exactly at a proven instruction (43 at the lowest target, 2 at a word >= $8000 followed by proven code, 1 fixed), 0 unresolved |
| `call $08C1` far calls | 276 | all resolved, 72 distinct targets, all sane |
| `call $08BB` / `call $038A` | 2 / 1 | main loop 00:2E92 / mode table (34 entries) |
| `push; ret/reti` computed return | 1 (+10 continuation pushes) | rule |
| `call $FF80` (RAM) | 1 | by hand |
| cooperative-task PCs, split immediates | 6 entries | found by a scan for `ld a,n; ld [$D6xx],a` pairs: heuristic, not proof of completeness |
| interrupt vectors | 5 | `$60` was missing in the baseline list |

Systematic tracer weaknesses found:
1. **`rst $18` over-run (real bug, baseline)**: 05:48C4 is traced with 9 entries; the 9th "word" `3E 04` at 05:48D4 is the first instruction of `Bank005_State12` (a `.sym` label).  `ld a,$04` is swallowed as table data (the table is shown as 9 words) and 00:043E is rooted by accident (it is a legitimate `ret`, so no wrong code resulted).  Bytes are unchanged, labelling is wrong.  Cause: the length rule stops at the lowest target or at a word outside $0100-$7FFF, and handlers in a different part of the bank never lower the limit.  Fixed in the try copy; belongs in `tools/rom_trace.py`.
2. **`rom_coverage.py` overstates "referenced data"**: (a) any `ld rr,nn` constant smears "referenced" over every following unknown byte; (b) a bank-0 `ld hl,nn` with nn >= $4000 is credited to *every* bank, so banks 0B, 29, 2A show 16,384 B "referenced" with no catalog entry at all; (c) 8-bit page loads are invisible; (d) constants that are pointers into *another* bank (e.g. `ld a,2; ld hl,$503F; call $08C1` credits bank 7 at 07:503F) create false references.  Treat 590,504 B "referenced data" as an upper bound.  The only known-extent data is the 254,344 B copied through `call $0450` with a constant length.
3. Reachability is not liveness: 45 roots are unreferenced code.  Only a runtime log can say whether they ever run.
4. Hand-resolved callbacks (23) are not generalised; `CALLBACK_HELPERS` still only knows 07:7BDC.  The `ld rr,pc+1/push` rule covers the pattern, other helpers taking code pointers were not found (`call $0450` is a copy routine, 378 sites, never a code pointer).
5. Far-call resolution looks back for `ld a,n`; stale-constant risk checked only indirectly (all 72 targets decode sanely).

Blockers, by importance:
1. **Data banks 0B-3F (52 banks, 851,968 B) are not structured.** The asset catalog (`assets/catalog_jp.csv`, 385 copy sites) accounts for 254,546 B = 29.9 %.  25 banks have no catalogued byte (0B, 0E, 1F-code, 28-35, 37-3E).  14 banks (2B, 2D, 2E, 30-35, 37, 3A-3D = 229,376 B) have no static reference at all yet hold real content (entropy 2.5-5.8 bits/B, not padding); 28, 2F, 39, 3E, 3F are mostly unreferenced.  They are reached through computed bank numbers / pointer tables that the tracer cannot follow.  Without them an assembly source cannot name sections, only `INCBIN` them.
2. **~56.8 KB of data inside the code banks has no type or extent** (bank 02 11.9 KB, 1F 12.3 KB sound data, 08 10 KB, 09 5.3 KB, 00 4.1 KB, 06 3.4 KB...).  Round trip itself is easy by construction (instructions where proven, `db` elsewhere: the whole ROM is covered), so byte identity does not need this; *confidence in labels and types* does: word tables vs strings vs tiles vs song streams.
3. **Dead vs live code** (45 roots, 1,014 B) is static judgement.
4. **Cooperative-task and callback pointers** found by heuristics (split immediates, word tables) may be incomplete.
5. 0A:4C51 and other quirks are real ROM behaviour that a rebuilt source must keep bit-exact (it will, as `jr`).

Needs emulator/hardware confirmation (PyBoy is already used in `emu/drv.py`; its `hook_register` can log PC and bank):
* PC + bank coverage over a scripted tour of every mode: any executed PC outside `trace_jp_v3.json` is a tracer gap; the 45 dead roots must never execute.
* ROM read log (address + bank) for the 14 unreferenced banks to find which tables select them.
* Index ranges: 0A table 64-95 (third block, A | $40) and every `rst $18` table maximum index.
* Cross-ROM check: 67 % of the newly proven bytes are byte-identical at the same bank:addr in `gbcam_usa_eu.gb` and `gbcam_gold.gb` (Hello Kitty 0 %, different layout); a diff of code that is dead in JP but live in USA/EU (or the reverse) would settle several dead-code verdicts.

Owner must decide / supply:
* Policy for the 45 dead roots: assemble as code tagged `unreferenced`, or leave as `db`.
* Whether to adopt the four rules, the `RESOLVED_JPHL` table and `extra_roots.json` into `tools/rom_trace.py` (I did not touch it) and to fix `rom_coverage.py` (items 1-2 above).
* A scripted emulator coverage run (input sequences for every mode), or permission for me to write it.
* Charset/text table for strings (`MAIN PASS` is ASCII; the rest is unknown to me) and label-naming convention for the ~130 new roots.


## Addendum: bank 01 is fully typed (sprite-composition lists)

`00:24AF` (A = list number, table `01:4000`) and `00:2496` (table `01:5D47`) select ROM bank 1, read a word pointer indexed by `2*A`, and copy 4-byte records
(Y + C, X + B, tile, attribute) to the OAM shadow (`$D400 + [FF9A]`) until a record starts with `$80`. `00:2464` (table `02:6E4B`) and `00:247D` (table `02:5272`) are the same adder for bank 2.
Parsing both bank-1 tables: 249 + 246 lists, 3,247 records, 14,473 bytes (`$4000-$7888`) with no gap, then 1,911 zero bytes (`$7889-$7FFF`).
In `coverage_jp_v3.csv` bank 01 therefore reads "13,719 referenced / 2,665 unreferenced" only because the coverage tool sees just the two table base addresses.


## Addendum: emulator coverage run (README section 13)

Run with a native SM83 core (`coverage/`), 197.7 M frames in the fuzz-style passes plus settle / sweep / long / damaged-save / hotspot-save passes; no BGB, no hardware.

* **Tracer completeness:** 0 executed instructions outside `trace_jp_v3.json` (0 mis-aligned entries). 55,935 of 60,449 traced instructions (92.5 %) executed; 47,862 (79.2 %) from joypad input + an SRAM image alone; 8,073 only in forced-state runs (52 of them suspect: entered through an edge that is not in the static control flow); 4,514 (8,773 bytes) never executed.
* **Dead roots (blocker 3 above):** none of the 45 executed from joypad input; `00:0751` (3 instrs) ran once in a forced run through a non-CFG edge (artefact). Recommendation: assemble as code tagged `unreferenced`; owner decides.
* **Data banks (blocker 1 above):** all 64 banks selected; all 14 unreferenced banks (2B 2D 2E 30-35 37 3A-3D) are read, with the reading mode, calling routine and byte ranges logged (`coverage/results/report_v6/data_bank_map.md`, `data_extents.csv`, table in README 13.5). Open: type and extent of each asset inside a bank (needs the index tables of the reader routines `04:58DE`, `04:5A9D`, `08:5400`, `08:5055`, `02:4CFF`, `06:5CFF`); 56,947 non-padding bytes were never read by any run.
* **Never-executed code, by cause** (`unexec_components.csv`, `gating_summary.md`): link cable (`$DC44`, `$DC51`, `$DC59`, `$DC43`), Super Game Boy (`$FFC3`), printer statuses the stand-in never returns, SHOOT boss branch (`$D865`), 10 state-table slots never entered (bank 04 st.10, 06 st.18/19, 07 st.9/15/17, 09 st.9/11/12/13), effect-table entries 45, 51, 53, 83 and eleven `ret` slots of `0A:541A`, and `04:5E4C` (255 instrs, gating variable not identified).
* **Labels:** `Cam_BootHiddenCombo_Check` (`0A:6A41`) is the tail of a block-copy outer loop, not the hidden-combination test (that is `0A:6A52`, already `Cam_BootSelfTest_Entry`); not renamed here because rgbds is not available in the session to re-verify the md5 after regenerating.
* **Limits:** core not compared cycle-exactly with BGB / hardware; no link partner, SGB, printer faults.
