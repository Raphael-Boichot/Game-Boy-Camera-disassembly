[README](../README.md) · [Section index](index.md)

## 13. Emulator coverage run: what executes, what never does, and what reads the data banks

This section closes the points that §1.2 listed as "needs the emulator": a scripted tour of every mode (D3), a ROM-read log for the 14 unreferenced data banks (D1), a check of the tracer for gaps, and a runtime verdict on the 45 dead-code roots (D2).
Evidence tags as elsewhere: **F** = fact observed in a run or read from a ROM byte; **I** = inference; anything inconclusive is listed in §13.7 and not smoothed over.

**Scope of the numbers.** §13.2-§13.7 report the merge of the nine fuzz, replay, sweep and damaged-save passes of §13.2 (`coverage/results/report_v6/`, rebuilt by `coverage/final_merge.sh`). The final merge adds the unlocking and link runs (§15.1; `coverage/v8/report_v8/`): it executes 57,582 (95.3 %) of the 60,449 traced instructions, 50,008 (82.7 %) from joypad and SRAM only, 7,574 only in forced runs, and leaves 2,867 never run; it is the one drawn on the reachability map and used from §15 on.

**Result in one paragraph (passes 1-9).** Of the 60,449 traced instructions, **55,935 (92.5 %) were executed**; **47,862 (79.2 %) were reached by joypad input and an SRAM image alone** (no RAM was written from outside); the other 8,073 only after a run forced a RAM variable or a mode.
**No instruction was ever executed outside the static trace** (0 tracer gaps, 0 mis-aligned entries), so the trace is complete for everything the camera did in this run. **None of the 45 dead-code roots ran organically** (one, `00:0751`, 3 instructions, ran in a forced run; §13.3).
The 4,514 instructions (8,773 bytes, 7.5 % of the code) that never ran are explained in §13.4: almost all of them sit behind a named hardware condition (link cable, Super Game Boy, printer states the stand-in printer never produces) or behind a dispatch-table slot no input reached.
All 64 ROM banks were selected at least once, and all 14 banks that no code references statically are read (§13.5).

### 13.1 The emulator: a purpose-built core, and what it does not model

Neither PyBoy nor BGB was used for the bulk of the work: a search over hundreds of millions of frames with cheap snapshot-and-branch needs a core that does the bookkeeping itself (about 8,000 frames per second per worker, roughly 135 times real time).
So the run uses a small native SM83 core written for this purpose (`coverage/src/gbcov.c`, 462 lines of C, driven from Python through `ctypes`). It records, per ROM byte, **executed as opcode / executed as operand / read as data** (and by which call site and mode), every write to the bank-select registers, and every call site; it can snapshot and restore the complete machine state, which makes the search deterministic and resumable.
What it implements: the SM83 instruction set, interrupts, `halt`, the timers, LCD timing (LY / STAT / VBlank / LYC, without any rendering), the joypad, the serial port with a simple printer on the far end, and the Pocket Camera mapper (ROM bank, RAM bank, camera-register bank, the capture-start bit and a capture-complete countdown). A **synthetic sensor image** lets "shoot" and the exposure loop run; the **minimal Game Boy Printer** answers the handshake, accepts the data and reports a clean status, so the print modes run.
What it does **not** model: any picture output, sound, a link-cable partner (two cores can be wired together, §14), Super Game Boy commands, and cycle-exact behaviour. It was **not** compared cycle by cycle with BGB or with hardware (**limit**, §13.7).

Validation that the core behaves like the console where it matters for this analysis: (1) booting each of the 14 real saves and the two synthetic battery-loss saves (all `00`, all `FF`) for 240 frames leaves in WRAM `$D5B5-$D5C0` exactly the 12-byte calibration vector that the rule of §6 predicts from the SRAM image (primary record / echo / default vector): **16 of 16 cases agree** (`tools/validate_calib.py`); (2) the real saves boot to the main menu (`$D5CE = $00`); (3) **0 executed opcodes fall outside the static trace**, which a faulty core would almost certainly produce (wild jumps) and which the guard described below also checks.

### 13.2 Method: organic versus forced, and how branches were flipped

**Organic coverage** is the strict one: the run started from a real save (or one of the synthetic ones) and only joypad presses were applied afterwards. SRAM images used: the 14 real cameras (`saves/`), the all-`00` and all-`FF` images (battery loss), damaged copies of the real saves (flipped bytes inside the protected blocks, the calibration record, the tag block and its echo; 3,400 variants) and nine saves whose photo slots carry the "hotspot" bytes `F36-F53` (a viewer mode, `$0C`, that only shows when they are present).
**Forced coverage** is any run in which a RAM variable was written from outside, or the mode byte `$D5CE` was set directly. Forced coverage proves that the code is **decodable and executes without a crash from that state**, not that the state can be reached with the buttons. It is reported separately everywhere.

Instead of recording what the screen shows, the search follows **the conditions that keep the program in a state** (the owner's suggestion): the core logs, for every compare and bit test, which RAM byte was read and what it was compared with; the fuzzer then pokes that byte with the value that flips the branch and continues (a "compare-log" search, as in fuzzers). Before each forced run the snapshot is checked by a **wild guard**: a run that starts executing at an address that is not an instruction start of the trace is discarded, so the forced set cannot contain an opcode outside the trace by construction.
One contamination was found and removed: early sweeps also poked the stack (`$DE00-$DFFF`), which corrupts return addresses and produced spurious "coverage" of unrelated code (for example the dead root `00:069F`). The stack and the HRAM DMA stub are now excluded from pokes, the affected sweeps were repeated, and the contaminated outputs were left out of the final merge. Forced-only code is further classified by `forced_legit.py`: **credible** if static control flow reaches it from organic code or it is entered at a table / root entry, **suspect** otherwise (§13.3).

Passes (each row is the coverage of that pass alone, including the replay of the corpus it started from; "organic" is not available for the first pass, which predates the split):

| pass | what it did | instr. executed | of which organic |
|---|---|---:|---:|
| 1 | random key sequences from the main menu, two workers, 18.5 M frames | 41,797 | - |
| 2 | + compare-log pokes, input pool, read-set mutation (two workers, 45 M frames; the row is worker a) | 49,192 | 42,884 |
| 3 | longer run of the same fuzzer (worker a: 52.8 M frames, 13,293 corpus entries) | 51,023 | 43,019 |
| 4 | final fuzz generation, stack excluded (worker a: 64.9 M frames, 18,785 entries) | 52,718 | 43,563 |
| 5 | **settle runs**: replay of the corpus with long idle / tap waits (some states only change after thousands of frames) | 52,665 | 44,054 |
| 6 | **sweeps**: in 488 selected states, up to 500 of the variables the state reads, each set to up to 13 chosen values | 53,298 | 43,201 |
| 6b | **SHOOT-variable sweep** (forced, mode `$14`: `$D7EB` = 0-2, `$D7E3` = 0-32, `$D7E4` = 0-3), stand-alone | 11,502 | 0 |
| 7 | **long boot runs**: 192 power-on runs of up to 9,000 frames with held-key combinations (the hidden factory test needs about 3,900 frames, then spins on its OK / NG tile) | 3,998 | 3,998 |
| 8 | **damaged saves**: boots with 3,400 corrupted SRAM images (repair paths of §3) | 39,533 | 39,533 |
| 9 | **hotspot saves** (19,902 iterations, 9.8 M frames) | 48,155 | 17,362 |
| | **merged** (union of all passes) | **55,935** | **47,862** |

Totals over the passes that count iterations and frames (1-4, 8, 9): 435,746 iterations and 197,716,188 frames (about 38 days of console time at 59.7 frames per second), 35,705 s of CPU time; the settle, sweep, long-run and replay passes are not included in that count. Pass folders (coverage, logs, stats) are in `coverage/results/passes/`, the replayable corpora in `coverage/results/corpus/`.

### 13.3 Results

**Per bank** (instructions of the static trace; "forced-state only" = executed only after a poke or forced mode; "never" = in no run):

| bank | traced instr. | executed | % | organic | forced-state only | never |
|---|---:|---:|---:|---:|---:|---:|
| 00 | 6800 | 6016 | 88.5 | 5324 (78.3%) | 692 | 784 |
| 02 | 2467 | 2352 | 95.3 | 2037 (82.6%) | 315 | 115 |
| 03 | 7324 | 6760 | 92.3 | 6551 (89.4%) | 209 | 564 |
| 04 | 6615 | 6063 | 91.7 | 5938 (89.8%) | 125 | 552 |
| 05 | 7233 | 6498 | 89.8 | 3628 (50.2%) | 2870 | 735 |
| 06 | 6466 | 6355 | 98.3 | 6297 (97.4%) | 58 | 111 |
| 07 | 6509 | 6032 | 92.7 | 4716 (72.5%) | 1316 | 477 |
| 08 | 2758 | 2656 | 96.3 | 2639 (95.7%) | 17 | 102 |
| 09 | 5367 | 4756 | 88.6 | 4592 (85.6%) | 164 | 611 |
| 0A | 6778 | 6493 | 95.8 | 4363 (64.4%) | 2130 | 285 |
| 1F | 2132 | 1954 | 91.7 | 1777 (83.3%) | 177 | 178 |
| **all** | 60449 | 55935 | 92.5 | 47862 (79.2%) | 8073 | 4514 |

- **Tracer gaps: none.** 0 executed opcodes outside the 60,449 traced instruction starts, 0 that fall inside a traced instruction (F). The only code executed outside the ROM is the OAM-DMA stub copied to HRAM `$FF80-$FF89` (the 10 bytes at `00:03F0`, which are data in ROM; they never "execute" at their ROM address, which is why that live root shows as not executed).
- **Roots** (the 134 hand-resolved roots of `tools/extra_roots.json`): 89 live roots, **73 executed (32 organically)**, 16 not executed: the OAM-DMA stub image above, and 15 entries of the bank `$0A` effect table `$541A`. Eleven of them (indices 57, 59-61, 63, 89, 91-95) point into runs of bare `ret` bytes (`0A:61AB-61B1`, `0A:685F-6865`): no-op slots, i.e. effect numbers with nothing behind them (F: the bytes are `C9`). Four (indices 45, 51, 53, 83 at `0A:5E40`, `6037`, `60B1`, `6704`) are real effect code that no index sequence selected. **45 dead-code roots: 0 executed organically.** One of them, `00:0751` (3 instructions), executed in a forced run; it is one of the 6 suspect runs below, i.e. entered by an edge that is not in the static control flow, so I treat it as a poke artefact, **not** as evidence of use (I).
- **Forced-only code: 8,073 instructions; 8,021 are credible, 52 suspect.** Credible = reachable along static control flow from organic code, or entered at a dispatch-table / root entry; suspect = entered by an edge that is not in the static control flow (a poke made the program land in the middle of a routine, or return to a corrupted address). The six suspect runs (instruction start, last instruction, count, contains a dead root):

| first | last | instr. | dead root |
|---|---|---:|---|
| 00:06CA | 00:06F4 | 38 |  |
| 00:0751 | 00:0755 | 3 | yes |
| 00:0771 | 00:0772 | 2 |  |
| 09:6BDB | 09:6BE0 | 3 |  |
| 0A:5900 | 0A:590B | 5 |  |
| 0A:5AB7 | 0A:5AB7 | 1 |  |

- **Bank selection.** Every ROM bank `$00-$3F` was selected at least once (1,621 distinct (writer address, new bank) pairs, 296 of them in organic runs); the selecting code is a handful of helpers: `00:0333` (the bulk graphics copy, which accounts for most of the traffic), `00:2F2D`, `00:0AD7`, `00:020D`, `02:4CFF`, `06:5CFF`, `08:5400`, `04:58DE`, `04:5A9D` and a few per-mode readers. The per-bank table with the first reading mode and the main call sites is `coverage/results/report_v6/data_bank_map.md`.
- **State machines.** The 34 mode tables hold 374 state slots; **364 were entered, 10 never**: bank 04 state 10 (130 instructions, `04:4D1B`), bank 06 states 18 and 19, bank 07 states 9, 15, 17, bank 09 states 9, 11, 12, 13 (state 11 is the 525-instruction component at `09:6441`). Bank 07 states 9 and 17 are the only callers of `bank2:$462F` (the `F12-F14` and `10C3` / `10C4` counters); **no single-camera run of this section reached them, forced or not**: the link-cable photo exchange of two emulated cameras does (§14).
- **Byte classes of the whole ROM** (`rom_map_summary.md`): organically executed code 93,480 B; code executed only in forced runs 15,374 B; code never executed 8,773 B; inline jump tables 1,256 B; bytes read as data 813,687 B (642,342 B in organic runs); **bytes neither executed nor read: 116,006 B (11.1 % of the ROM)**, of which 59,059 B are runs of 16 or more `00`/`FF` bytes (padding, F) and **56,947 B are content that no run touched** (mostly in data banks `3B` 9,587 B, `0B` 5,564 B, `33` 5,476 B, `3C` 5,116 B, `2B` 4,457 B, `17`, `2A`, `10`, `19`; see §13.7).

### 13.4 Code that never ran, and why

Every never-executed instruction was grouped into connected components and classified by what keeps it out (`gating_branches.py`; `unexec_components.csv` has all 305 components):

| class | components | instructions | bytes | of which forced-executed |
|---|---:|---:|---:|---:|
| GATED | 196 | 1620 | 3235 | 0 |
| TABLE | 62 | 2340 | 4547 | 0 |
| DEAD | 43 | 527 | 942 | 0 |
| RAMCODE | 1 | 6 | 10 | 0 |
| ORPHAN | 3 | 21 | 39 | 0 |

(Total 4,514 instructions, 8,773 bytes.) **GATED**: entered only through a conditional branch or `ret` whose condition never came true; **TABLE**: entered only from a dispatch-table slot (state table, effect table, `jp hl` table) that was never selected; **DEAD**: reachable only from a dead-code root; **RAMCODE**: the OAM-DMA stub image; **ORPHAN**: no entry found.
The 22 largest components hold 2,858 of the 4,514 instructions (the 40 largest hold 3,373):

| first address | class | instrs | entered by (executed gating branch / dispatch-table entry) |
|---|---|---:|---|
| 09:6441 | TABLE | 525 | 09:5FE7[11];09:5FE7[12] |
| 05:5EC0 | TABLE | 262 | 05:5A67[23];05:5A67[24];05:5A67[25];05:5A67[26] |
| 04:5E4C | GATED | 255 | 04:5E4B(ft) |
| 03:657F | TABLE | 252 | 03:655D[1];03:655D[6];03:655D[7] |
| 00:2B3A | GATED | 219 | 00:2AF1;00:2AF8 |
| 07:45FD | TABLE | 179 | 07:4004[17];07:4004[9] |
| 04:4D1B | TABLE | 143 | 04:464D[10] |
| 00:1D45 | GATED | 130 | 00:1DA0(ft) |
| 02:462F | TABLE | 107 | call:1;far:1;flow:7 |
| 08:46A3 | GATED | 87 | 08:45F5 |
| 05:6670 | TABLE | 73 | 05:475F[7] |
| 05:6A82 | TABLE | 71 | 05:4806[1] |
| 0A:5853 | TABLE | 70 | 0A:541A[13] effect table |
| 00:0781 | DEAD | 69 | flow:8;root:1 |
| 03:65B3 | TABLE | 67 | 03:655D[2] |
| 05:7149 | TABLE | 60 | 05:48C4[2] |
| 03:6983 | TABLE | 56 | 03:655D[10];03:655D[11];03:655D[12];03:655D[13] |
| 03:6901 | TABLE | 52 | 03:655D[8] |
| 05:71C3 | TABLE | 51 | 05:48C4[3] |
| 04:7C9D | DEAD | 49 | call:1;flow:7;root:1 |
| 00:1A7B | GATED | 42 | 00:1A79(ft) |
| 0A:5E40 | TABLE | 39 | 0A:541A[45] effect table |

The gates that keep the most code out, with the variable they test (names from the WRAM map of §2; "(no memory read just before)" = the flag is in a register, I could not name it):

| branch | instruction | gated target | instrs behind | variable it tests |
|---|---|---|---:|---|
| 04:5E4B | `ret nz` | 04:5E4C | 255 | (no memory read just before) |
| 00:2AF1 | `jp nz,$2bc6` | 00:2BC6 | 160 | $DC44 lnk_connected |
| 00:1DA0 | `ret z` | 00:1DA1 | 130 | $FFC3 sgb_present |
| 08:45F5 | `jp nz,$46a3` | 08:46A3 | 87 | $D806 `print_extra_flag` (bit 0) |
| 00:2AF8 | `jr nz,$2b3a` | 00:2B3A | 86 | $DC51 lnk_stage |
| 00:1A79 | `jr z,$1adc` | 00:1A7B | 42 | $DC27 prn_status |
| 07:6744 | `jr nc,$6759` | 07:6759 | 35 | $D865 `shoot_boss_hits` |
| 07:46CC | `jr z,$46fb` | 07:46CE | 24 | $DC59 lnk_cmd_rx |
| 09:63F7 | `ret c` | 09:63F8 | 24 | $D047 ([7] collision mask 1+7) |
| 06:48AE | `jr nz,$48cb` | 06:48CB | 23 | (no memory read just before) |
| 04:6115 | `jr nz,$6129` | 04:6129 | 19 | $D800 `extras_launch_flag` (return-to-mode-4 flag) |
| 0A:427A | `jr c,$42ad` | 0A:427C | 19 | (no memory read just before) |
| 00:33F2 | `jr nz,$3404` | 00:3404 | 18 | $DBC5 print_last_page |
| 00:2E1C | `ret z` | 00:2E1D | 17 | $DC43 lnk_turn |
| 07:46FD | `ret z` | 07:46FE | 17 | (no memory read just before) |
| 00:05D5 | `jr z,$05e0` | 00:05E0 | 16 | (no memory read just before) |
| 09:5CBA | `jr nc,$5cd8` | 09:5CBC | 16 | (no memory read just before) |
| 05:517B | `jr z,$519c` | 05:517D | 14 | $FF26 NR52 |
| 07:625D | `ret c` | 07:625E | 14 | $D502 (sprite_anim_frame[15]+2) |
| 00:1E87 | `ret z` | 00:1E88 | 13 | $FFC3 sgb_present |
| 04:485D | `jr nz,$4877` | 04:485F | 13 | $FFA1 keys_held |
| 04:4918 | `ret nz` | 04:4919 | 13 | $FFA1 keys_held |
| 07:584F | `ret z` | 07:5850 | 13 | $FFA1 keys_held |
| 0A:470B | `jr nz,$4724` | 0A:470D | 13 | (no memory read just before) |

What this says, grouped by cause (I where marked):
1. **Link cable** (mode `$0E` and the serial helpers): `00:2AF1`/`00:2AF8` (`$DC44` link connected, `$DC51` stage) gate 00:2B3A and its 219 instructions, `07:46CC` (`$DC59` command received) and `00:2E1C` (`$DC43` turn) gate more. The single-camera core has no partner, so none of this runs in these passes; two cores wired together run it (§14, final merge). This and the SGB item are limits of the tool, not properties of the ROM.
2. **Super Game Boy**: `00:1DA0` and `00:1E87` test `$FFC3` (sgb present) and gate 130 + 13 instructions (the SGB packet code). The core has no SGB, so the ROM's own detection finds none.
3. **Printer states beyond the stand-in**: `00:1A79` (`$DC27` printer status), `00:33F2` (`$DBC5` last page), `08:45F5` (`$D806` extra flag, 87 instructions): the stand-in printer always returns a clean status, so branches that test other status values or later pages (I: that is what these three variables carry) never ran. The extended-printer states are not exercised (**limit**).
4. **SHOOT**: `07:6744` (`$D865` boss hits): the branch taken once enough boss hits are counted (35 instructions; I: the boss-defeated path) needs a long play-through; plausibly reachable by input, not found by the search.
5. **Dispatch slots nobody selected**: `09:6441` (525 instructions behind states 11 and 12 of bank 9), `05:5EC0` (262, states 23-26 of the `05:5A67` table), `03:657F` (252, slots 1, 6, 7 of the effect-handler table `03:655D` used by the hotspot viewer, mode `$0C`), `07:45FD`, `04:4D1B`, and 24 entries of the `0A:541A` effect table whose handler contains never-executed code (indices 13, 19, 21, 25, 27-31, 45, 51, 53, 57, 59-61, 63, 83, 89, 91-95; the whole-handler case is `0A:5853` = index 13 and the like). For the hotspot effect table the handlers were executed in forced runs (they are in the forced-only count), never from a save with hotspot bytes by buttons alone, so **"which on-screen effect is it" is not answered** (**limit**).
6. **`04:5E4C`** (255 instructions, a stamp-tool routine behind a `ret nz` at `04:5E4B`): the condition is a register, the variable was not identified; **inconclusive** (§13.7).
7. **Dead code**: 43 components, 527 instructions (942 bytes), all behind the dead-code roots. Library stubs and twin routines, as predicted in §1.2.

**Later status.** The final merge leaves 5,268 B of this code never run; later runs executed 4,076 B of them (the SGB sender of item 2, the printer-only code of item 3 for `08:46A3` and the retry code `00:1A7B`, the slots of item 5 for `05:5EC0`, `03:657F` and the end of the race `09:6441`, the stamp routine of item 6; §16.14, §16.16, §16.18, §16.19, §16.21); the rest is sorted by cause in §16.15 and §16.21.

### 13.5 The 14 data banks that no code references

All 14 are read. They are reached through computed bank numbers and pointer tables that static tracing could not follow; the log gives, per bank, the bytes read, the mode and state that first read them, and the call sites (level 0 = the routine that executed the copy; `00:0333` is the generic bulk copy and says nothing about the asset, so the next call site up is the informative one). Content column = what the bytes look like when rendered as 2bpp tiles (`d1sheets/`); **inferred (I)**, not read from a table.

| bank | bytes read (organic) | read first by (mode:state, bytes) | through call sites (level 0) | content seen in the rendered tile sheet (inferred, **I**) |
|---|---:|---|---|---|
| `2B` | 1,234 (0) | $14:00 SHOOT (12 B); $14:01 SHOOT (10 B) |  | sprite-like tile art at the start (first 960 B read); rest unread / noise (see footnote c) |
| `2D` | 15,572 (15,424) | $11:03 stamp tool (14,849 B); $11:02 stamp tool (65 B) | 04:58DE (11264); 04:5A9D (3394); 00:0333 (256) | stamp icons / characters (sprite-like 8x8 tiles) |
| `2E` | 16,384 (13,920) | $11:03 stamp tool (9,760 B); $0B:17 ? (6,624 B) | 04:58DE (7222); 00:0333 (6200); 04:5A9D (2400) | hand-drawn kana / kanji glyph sheets |
| `30` | 16,384 (6,976) | $11:03 stamp tool (5,374 B); $14:01 SHOOT (37 B); $14:00 SHOOT (34 B) | 04:58DE (4800); 04:5A9D (576) | kana glyph sheets and tile sets |
| `31` | 15,574 (13,056) | $1C:0D print one photo (13,056 B) | 00:0333 (7932); 08:5400 (5124) | scene artwork / tile sets (a logo is legible) |
| `32` | 11,398 (11,392) | $1C:0D print one photo (11,392 B); $14:00 SHOOT (2 B); $14:01 SHOOT (2 B) | 00:0333 (6512); 08:5400 (4880) | scene artwork / tile sets |
| `33` | 6,935 (2,432) | $1C:0D print one photo (2,432 B); $14:00 SHOOT (11 B); $14:01 SHOOT (2 B) | 00:0333 (1594); 08:5400 (838); 05:41C5 (1) | tile sets with logos and small text strips |
| `34` | 15,940 (15,048) | $12:21 slide-show editor (5,016 B); $0F:05 album copy/erase viewer (3,344 B); $09:09 album photo-option menu (3,344 B) | 08:5055 (4767); 00:0333 (3944); 08:50E2 (2412) | UI / frame (border) tiles and small text strips |
| `35` | 15,194 (15,048) | $1C:0A print one photo (5,016 B); $0A:02 photo-option menu (fixed photo) (3,344 B); $12:21 slide-show editor (3,344 B) | 00:0333 (5430); 08:509D (4938); 08:5055 (3093) | frame (border) tiles and pattern tiles |
| `37` | 16,097 (4,792) | $09:01 album photo-option menu (7,536 B); $09:00 album photo-option menu (3,768 B); $1C:02 print one photo (3,768 B) | 02:4CFF (9729); 00:0333 (5289); 06:5CFF (800) | full-size pictures (stock pictures, 128x112) |
| `3A` | 16,168 (7,840) | $1D:03 print engine (7,168 B); $09:01 album photo-option menu (4,228 B); $18:01 4-photo list (900 B) | 00:31B4 (7010); 00:0333 (3293); 02:4CFF (1093) | full-size pictures |
| `3B` | 6,797 (224) | $00:00 main menu (6,463 B); $18:01 4-photo list (224 B); $14:00 SHOOT (11 B) | 06:5CFF (200); 06:5D15 (8); 06:5D2B (8) | full-size pictures (mostly unread) |
| `3C` | 9,048 (4,248) | $12:01 slide-show editor (7,168 B); $18:02 4-photo list (224 B); $12:02 slide-show editor (224 B) | 00:0333 (7120); 03:5BF4 (328); 03:5C60 (320) | full-size pictures |
| `3D` | 16,211 (3,808) | $00:00 main menu (4,851 B); $12:01 slide-show editor (3,584 B); $18:01 4-photo list (584 B) | 00:0333 (3428); 06:5CFF (600); 03:5BF4 (188) | full-size pictures |

Footnotes. (a) "bytes read (organic)": bytes of the bank read at least once as data; in parentheses, read in a run with no forced state. (b) Banks `2D 2E 30` (stamps, kana) are read by the stamp tool (mode `$11`) through `04:58DE` / `04:5A9D`; banks `31-33` are read while printing a photo (mode `$1C`) through `00:0333` and `08:5400`; banks `34 35` are the frame (border) graphics of the album, photo-option and slide-show screens; `37 3A-3D` hold full-size 128x112 pictures read by the album and photo-option menus, the slide-show editor, the print engine (`3A`, mode `$1D`) and the main menu (`3B`, `3D`). (c) Bank `2B` is read for 1,234 bytes **only in forced runs of mode `$14` (SHOOT)**: one 960-byte range `4000-43BF` (60 tiles' worth) plus about 270 scattered bytes. The sheet shows sprite-like tile art at the start of the bank and noise further on; the rest of the bank (15,150 bytes) is untouched. Which SHOOT variant uses it is not established (I: SHOOT sprite or effect graphics). (d) The mode:state `$0B:17` listed for bank `2E` (6,624 B) comes from a forced mode and is not evidence of a real screen. The per-asset extents (967 read ranges with gap <= 16 bytes) are in `coverage/results/report_v6/data_extents.csv`; they are exact for what was read and say nothing about bytes that were not read.

### 13.6 Consequences for the disassembly (D1-D4)

- **D1 (data banks): partly resolved.** The bank selected by each reader, the reader modes and the byte ranges read are known for all 52 data banks (736,678 of their 851,968 bytes were read as data; 115,290 were not). What the log alone cannot give is the **type and extent of each asset inside a bank**: it shows ranges that were copied, not the index tables that select them. Those tables of the six reader routines (`04:58DE`, `04:5A9D`, `08:5400`, `08:5055`, `02:4CFF`, `06:5CFF`) were decoded on 2026-10-19 (§2.6 for the stamp tables, the list in §12): the addresses are copy calls, the tables are typed in the symbol file and the assets they select are its `StampCat*`, `Border*`, wild-frame, Album B and thumbnail rows. A rebuilt source can `INCBIN` each bank in labelled sections along the read extents; what stays open are the bytes that no run read.
- **D2 (dead roots): decided (owner, 2026-10-26).** None of the 45 ran organically; one ran in a forced run through a non-CFG edge (artefact). They are assembled as code tagged unused: the symbol file types them `.code` and every one of them carries the `Unused_` prefix (14 were renamed for it, e.g. `Unused_Irq_DisableVBlank`, `Unused_Delay_BC`, `Unused_Vram_CopyFromBank_8`; `roms/jp_rev_a/disasm/renamed_jp.csv`); the 527-instruction DEAD components keep the same tag. A build that strips them (conditional assembly, a ROM that no longer matches) is left to L5.
- **D3 (coverage run): done**, with the limits of §13.7. Tracer complete on everything reached (0 gaps).
- **D4 (character table): untouched.** The run does not produce text. (The kana sheets of banks `2D 2E 30` are the natural source; extracting them is a separate step. The name / comment table came later from bank `$2A`, §16.27.)
- **Boot labels** (checked against the code): `0A:6A41` is the tail of the outer loop of the block reduction `FxShared_ReduceBody_G2` (`FxShared_ReduceBody_G2_OuterLoopTail`: `ldh a,[$ff8a] ; dec a ; ret z …`), not a hidden-combination test. The test is at `0A:6A52` (`ldh a,[$ffa1] ; cp $fd` = all keys but B held, jump to the factory test; `cp $ff` = all keys held, jump to `0A:6B73`), `Cam_BootSelfTest_Entry`. `0A:7D04` and `0A:7D10` are the far stubs `Cam_FarStub_ValidityCheck` and `Cam_FarStub_LiveInit` of `Cam_Calib_ValidityCheck` and `Cam_LiveInit` (they are not pings), and `0A:6B73` is `Cam_FirstBoot_StorePleaseWait` (the STORE PLEASE WAIT first-boot calibration); `Cam_ExposureBandSelect` (`0A:4859`) is the gain probe, not an exposure-band selector (name kept: it is used throughout this README). And symbol-based statistics are misleading wherever one label precedes a large unlabelled region: `Cam_PopcountSampleLoop_inner` (`0A:5091`) "contains" 4,581 instructions of effect code, `Bank005_State12` 6,283.

### 13.7 Caveats and inconclusive points

1. **Core fidelity.** Not compared cycle-exactly with BGB or hardware. Timing-dependent code (STAT / LY loops, serial, sensor timing, DMA timing) was exercised only as far as the approximations allow. Every covered path should be confirmed in BGB before it is quoted as a hardware fact. For hypotheses that matter, the BGB check is cheap: load the same save, press the same keys (the corpus entries are replayable key sequences).
2. **Forced is not reachable.** The 8,073 forced-only instructions show the code runs from a plausible state; they do not show that the buttons reach it. 52 instructions are suspect (6 runs, table above).
3. **Never executed is not dead.** 4,514 instructions never ran, almost all behind a named gate (§13.4). Only the 43 DEAD components are unreferenced by construction.
4. **Not modelled:** link partner, SGB, printer faults, real sensor noise, real lighting (a fixed synthetic image), real time-of-day / RTC-like state (none exists on the camera). Anything those gate stays open.
5. **`04:5E4C`** (255 instructions, stamp tool, bank 4): the gating variable is not identified.
6. **Bank 07 states 9 and 17** (callers of `bank2:$462F`; the link runs of §14 enter them) and the other seven states never entered by a run of this section: no input sequence or poke entered them. Unknown whether they are reachable on a real camera.
7. **56,947 bytes of non-padding content were never read in passes 1-9** (banks `3B`, `0B`, `33`, `3C`, `2B`, …; 10,020 B in the final merge, largest in banks `0B`, `2A`, `33`, `14`, `32`, §15.1). They may be pictures that only appear in modes or conditions not exercised (the 128x112 stock pictures of `3B`-`3D` are read only in part), or genuinely unused assets. The log cannot tell which.
8. **"Read" means the CPU copied or read the byte**, not that it was displayed. A bulk copy of 2 KB into VRAM marks 2 KB as read.
9. Hotspot effect handlers (`03:655D`, `0A:541A` slots): run only in forced states; their on-screen meaning is in §16.8.

### 13.8 Files and how to reproduce

In the package, folder `coverage/` (see its `README.md`):
- `src/` the C core (`gbcov.c`), its Python wrapper and `build.sh`; `tools/` the 19 driver and analysis scripts (fuzzer, sweeps, settle / long / damaged-save runs, hotspot-save generator, merge, report, ROM-byte-class map, data-bank map, gating-branch analysis, state graph, forced-coverage classifier, disassembler with execution marks `gbdis.py BB:AAAA [n]`); `final_merge.sh` rebuilds every report from the run states.
- `results/report_v6/` (passes 1-9) and `v8/report_v8/` (final merge): `coverage_report.md` (the tables of §13.3), `roots_status.csv`, `rom_map.csv` / `rom_map_summary.md`, `data_bank_map.md` / `.csv`, `data_extents.csv`, `bank_callsites.csv`, `bank_select.csv`, `gating_branches*.csv`, `unexec_components*.csv`, `gating_summary*.md`, `state_graph.md`, `forced_legit.md`, `forced_suspects.csv`, `unexecuted_traced_runs.csv`, `merged_cov.npz`.
- `results/` also holds the corpus (replayable key sequences) and the logs of every pass; `saves/` the 14 real saves; `d1sheets/` the rendered tile sheets of the data banks.
- Re-run: `build.sh` (needs a C compiler; the ROM is not in the repository, md5 `fdcfe686cf4df461e870b6e53b2b5a8b`), then `tools/coverage_run.py` (fuzz), the pass scripts, `./final_merge.sh MERGED REPORT results/passes/*`. All runs are deterministic from (ROM, save, key sequence).
- **Checked:** rebuilding the merge from the shipped pass folders reproduces the executed, organic and data-read bits of the merged coverage bit for bit (55,935 / 47,862 instructions, 909,137 data-read bytes) and every table of §13.3-§13.4. Only the "first reader" tags and the per-site bank-select counts (section 6 of `coverage_report.md`) depend on the merge order and on how often replays were counted. `tools/validate_calib.py` reproduces the 16 / 16 calibration check (§13.1).

---
