# Code side of the Japanese Pocket Camera disassembly: indirect flow, dead code, unreferenced regions

Pocket Camera (Japan) Rev A, md5 `fdcfe686cf4df461e870b6e53b2b5a8b`.  Report behind README §1.2.  The runtime counterpart (what executes, what never does) is README §13 and `coverage/`.

Files:
* `tools/rom_trace.py` -- the tracer.  Without `--roots` it gives the first trace (56,799 instructions, 14 `unresolved`).  With `--roots` it switches on four rules (see A) and the 23-entry `RESOLVED_JPHL` table.  Its symbol input is `tools/rom_trace_labels.sym` (183 first-pass labels).
* `tools/extra_roots.json` -- 134 roots `[[bank, addr, reason], ...]`: 89 live (reachable by a mechanism the tracer lacks) + 45 whose reason starts with `DEAD-CODE (unreferenced)`.
* `roms/jp_rev_a/wram/trace_jp_v3.json` -- trace with all 134 roots.  `roms/jp_rev_a/disasm/coverage_jp_v3.csv` -- `tools/rom_coverage.py` on it.
* Reproduce: `python3 -I tools/rom_trace.py pocketcamera_jp.gb tools/rom_trace_labels.sym roms/jp_rev_a/wram/trace_jp_v3.json --roots tools/extra_roots.json` (checked: `code` and `unresolved` identical to the committed file).

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
| 07:792C, 7BF3, 7C1A, 7C62, 7C89, 7CD1, 7CF8, 7D27 | callbacks from 6-byte-entry tables (7985, 79E5, 7A43, 7A5E, 7A85, 7AAC, 7AD3) and animation helpers 7BDC/7C4B/7CBA, return address pushed first | callbacks 7AF1/7AF6/7AFB/7B00/7B05, continuations 792D/7BF4/7C63/7CD2/7D28, wait helper 7D11 rooted; all callbacks end in `ret` (checked by walking each callback to its terminator) |
| 0A:5419 | `jp hl` via table 0A:541A, index A = `[06:60DB+idx]` OR 0/$20/$40 (far call 06:781D -> 0A:7CFE -> 5406) | 96 entries, 92 distinct targets, 60 new; all valid |
| 1F:52E9, 52F7, 5309, 5317, 5329, 5337 | sound driver pointer tables 41FA..433E guarded by `cp N; ret nc` | 140 targets, all already rooted by `manual_roots` |
| 00:02A7 `call $FF80` | OAM DMA stub copied by 00:03E2 from 00:03F0 into HRAM | root 00:03F0 (the ROM image of the stub) |
| 00:0026, 03A5, 08C0, 08CF | `rst $18` body, `$038A` dispatcher tail, far-call trampolines | bodies rooted: 0008, 0010, 0018, 038A, 03A6, 0380, 08BB, 08C1, 0060 |
| 00:031A | `ld hl,$0210; push hl; reti` soft reset | root 00:0210 |
| 03:562D, 5637, 5919, 5923 | cooperative tasks: PC stored as split immediates (`ld a,lo; ld [$D6FD],a; ld a,hi; ld [$D6FE],a`, also $D70D, $D6ED), resumed by `pop..; ret` | roots 03:57BE, 5847, 5A7A, 5B00; word tables of task entries at 03:568B (5691/57BE/5847) and 03:59F1 (59F7/5A7A/5B00) |

Rules switched on by `--roots` (all verified against the whole ROM): (1) `ld rr,pc+1 ... push rr ... jp hl|ret` => continuation is code (10 sites, 0 false hits after requiring a `push` before the `ret`); (2) `ld rr,nn; push rr; ret|reti` => nn is code (1 site); (3) a call to $8000+ is recorded in `ramcalls` and the RAM image is rooted (1 site); (4) an `rst $18` table stops at a `.sym` code label (fixes one over-run, below).

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

## Addendum: bank 01 is fully typed (sprite-composition lists)

`00:24AF` (A = list number, table `01:4000`) and `00:2496` (table `01:5D47`) select ROM bank 1, read a word pointer indexed by `2*A`, and copy 4-byte records
(Y + C, X + B, tile, attribute) to the OAM shadow (`$D400 + [FF9A]`) until a record starts with `$80`. `00:2464` (table `02:6E4B`) and `00:247D` (table `02:5272`) are the same adder for bank 2.
Parsing both bank-1 tables: 249 + 246 lists, 3,247 records, 14,473 bytes (`$4000-$7888`) with no gap, then 1,911 zero bytes (`$7889-$7FFF`).
In `coverage_jp_v3.csv` bank 01 therefore reads "13,719 referenced / 2,665 unreferenced" only because the coverage tool sees just the two table base addresses.
