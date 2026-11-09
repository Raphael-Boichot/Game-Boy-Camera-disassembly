# Pocket Camera Prototype (Japan)

MD5 `19b50a5f67ef4f0d015e7d813370756e` as dumped (`1d8097de3497db8b182bcd2a984b6063`: the header-patched copy for BGB, see "Two images" below). An early leaked development ROM. Its header title is blank, but its title screen reads デバガメテスター ("Debagame Tester"), SECOND IMPACT, Ver10.24, 1997 Nintendo R&D Dept. (C, BGB), and its menu offers SRAM, bank and protect tests, a movie test, a gallery and a link (COM) entry: a test program for the camera cartridge hardware rather than an early camera program (I, from its screens, L2 below). The development paths `C:\DEBAGAME\TOOL` and `C:\DEBAGAME\ISD` left in the ROM (file offsets `$6B382`, `$F50FF`, `$F6322`) carry the same name, and SECOND IMPACT matches the name of the dump, `GBD-IMPACT8M`. TCRF documents it, and the owner's copy of the TCRF pages holds two assembly listings of it with Japanese comments (`source/Unused_graphics_TCRF/TCRF_Prototype_*_big_chunk_assembly_code.txt`).

![What each byte of the early prototype ROM is](proto_rom_layout_map.png)

The map above is drawn by `tools/status_maps.py` (grey-blue = not analysed yet; it fills in as names, types and a trace are added here; per-bank counts in `assets/layout_by_bank_proto.csv`).

This folder will hold the symbol file and the tables of this ROM, built with the tools of the repository and the playbook [`HOWTO_NEW_ROM.md`](../../HOWTO_NEW_ROM.md). The ROM is not in the repository (supplied by the owner outside it).

| Level | Status | Evidence |
|---|---|---|
| L0 | done (2026-11-08) | `intake/intake_roundtrip.txt`: mgbdis `95d951a` with no symbol file + rgbasm / rgblink 1.0.4 rebuild md5 `19b50a5f67ef4f0d015e7d813370756e`, **without rgbfix** |
| L1 | done (2026-11-08) | `pocketcamera_proto.sym` types every byte (`tools/sym_build.py` finds no hole or overlap); mgbdis + rgbasm / rgblink rebuild md5 `19b50a5f67ef4f0d015e7d813370756e` with it, without rgbfix (the checker's `proto` lines) |
| L2 | done (2026-11-09) | 0 indirect sites unresolved (L1); 7,711 of the 7,915 traced instructions ran in the core (`port/observed_proto.md`), 0 executed bytes outside the trace; every `GAME_SEQ` reached in the core reached again in BGB (`port/bgb_game_seq_proto.csv`, 26 of 26) |
| L3-L6 | not started | |

* **Round trip (C).** The standard mgbdis Makefile ends with `rgbfix -v -p 255`, which rebuilds the image as dumped with four header bytes changed: the ROM-size byte `$0148` (`$03` -> `$05`, the size of the padded file) and the three checksum bytes (`$014D` `$4C` -> `$4A`, `$014E-$014F` `$0000` -> `$6145`). The header bytes are data in the listing, so linking without rgbfix gives the image as dumped byte for byte (`tools/rom_intake.py --no-rgbfix`). The BGB copy rebuilds byte-exact with the standard Makefile (rgbfix leaves its already correct header unchanged). Any later build of this ROM (L1 checks, an L5 tree) must skip rgbfix too.
* **Intake (C, `intake/intake_banks.csv`, `intake_header.csv`).** Command in `tools/rom_intake.py`; references: the Japanese, international, Gold and Hello Kitty ROMs. Of the 1,048,576 bytes, 348,519 are padding (runs of 16 or more equal `$00` / `$FF`); 177,724 are covered by a 16-byte window that also occurs somewhere in the Japanese ROM, 161,081 in the Hello Kitty ROM. Shared content is not shared code: much of the prototype is leftover text and copies of its own banks (the section on the source text above and the symbol tables below), and a 16-byte window can be a tile or a table.

## L1: the trace and the symbol file (2026-11-08)

Pipeline (seconds; SETUP.md, prototype): `tools/proto_symtab.py`, `tools/proto_trace.py` (with the hand file `disasm/extra_roots_proto.json`), `tools/proto_types.py`, then `tools/sym_build.py`. Every generated file is rebuilt and compared by the checker (`--rom-proto`).

* **The running program is bank `$00` alone (C, static trace).** The trace from the entry and the four interrupt vectors proves 7,915 instructions, 12,893 bytes of proven code, all in bank `$00`, with 0 indirect sites left unresolved (`port/trace_proto_unresolved.md`). No traced instruction calls or jumps into `$4000-$7FFF`: the other banks are only read as data. The eight hand entries (one jump table; the two bank writes of the ROM self-test; the call of the OAM DMA stub in HRAM; four call sites of two callees, `00:0780` and `00:32E3`, that select a bank without restoring it, which matters only for banked calls and there are none) are in `disasm/extra_roots_proto.json`, each with its reason.
* **Engine (C, read in the listing; `tools/proto_trace.py` docstring).** No banked-call helper: every switch is written inline (`ldh a,[$FFFD]; push af`, `ld a,N; ldh [$FFFD],a; ld [$2100],a`, the work, then the saved bank back). `rst $00` / `rst $08` restart at `$0150`; `rst $28` is a jump table of words placed after the `rst` (not used by the traced code); `rst $38` is the fill byte. The main loop calls `00:01FE`, which dispatches on `GAME_SEQ` (`$C0A0`) with a chain of `cp n` tests. A second dispatcher, `00:380C`, masks A to 0-31 and jumps through the 32-word table `JumpTable_00_3822`.
* **ROM self-test (C).** `00:06F5` selects banks `$01` to `$3F` one after the other and compares the bytes at `$4000` and `$7FFF` with the bank number (a second pass at `00:0737`). That is why every bank starts and ends with its own number: the 126 bytes are typed as data with this reason.
* **Banks `$01`-`$03`: tiles and screens (C, the copy calls).** The copy routine `00:02B9` (HL source, DE destination, BC count, the bank mapped at the call) loads a 6 KB tile set from `$4001` of banks `$01`, `$02` and `$03` (bank `$03` has a second one at `$5A41`) and full-screen maps of 576 bytes (18 rows of 32) after it: 12 tile-set copies and 12 map copies with a constant source; the 11 other copies to VRAM take their source from a register (all 50 copy calls are listed in `assets/copy_sites_proto.csv`). The other copy routine, `00:2EF5` (B pages of 256 bytes, unrolled), copies SRAM photo buffers (`$A100`...) to WRAM.
* **What the bytes are.** Of the 1,048,576 bytes: 12,893 bytes of proven code; 181,351 bytes of leftover text in 53 blocks (typed `.text` by the bytes alone: printable ASCII and Shift-JIS lines ending in CR LF, outside the code and the copy sources: the assembly source and listings with Japanese comments); 275,970 bytes of padding (runs of 16 or more `$00`); 48,065 bytes of data typed by a reason (copy sources, the two symbol tables, the self-test bytes, the jump table, the DMA stub); 530,297 bytes of data on the default typing (no reason yet: the rest of the leftover banks, tables of bank `$00`, the tile sets nothing copies). Runs of printable bytes without a line end stay data on purpose: bank `$00` has byte tables in the printable range (`00:17A1`, `00:1904`).
* **Names: 23, tag C.** One label per typed block, named by kind and address (`Gfx_BB_AAAA`, `Map_BB_AAAA`, `Data_BB_AAAA`, `JumpTable_00_3822`); the routines keep the mgbdis labels (`Call_000_xxxx`) until L3.

## L2: what runs (2026-11-09)

Runs (SETUP.md, prototype L2): the project's core (`tools/proto_coverage.py`, novelty search over key presses, 25 minutes each) on the image as dumped, from blank SRAM and from the owner's prototype save (not in git); then BGB, the judge, on the header-patched copy (`tools/proto_bgb_replay.py`), which replays for every `GAME_SEQ` value the key history that first reached it in the core. The histories are in `port/runs/*/modes.csv`, the union of the executed bytes in `port/cov_proto_runs.npz`.

* **Coverage (C, core).** 7,711 of the 7,915 traced instructions ran, 12,495 of the 12,893 bytes of proven code; 0 executed bytes lie outside the trace, and nothing ran outside bank `$00`: the trace's finding holds. The 29 blocks of traced code that never ran (398 bytes) are listed in `port/observed_proto.md`.
* **What is behind the blocks that never ran** (read in the code; not run is not dead). The timer interrupt (`00:0050`, handler `00:1266`): the constants written to the interrupt-enable register are `$09`, `$01` and `$02`, never the timer bit, and two writes copy a variable (I: probably never enabled). The error branches of the ROM self-test (`00:0713`, `00:076A`): taken only when a bank does not hold its number (`cp d; jr nz`), never on a sound ROM (C, by the code). Link-cable code (`00:036A-0386`, `00:130B-1364`: serial registers, a link-role byte at `$C0D7`): it needs a second Game Boy, which these runs do not have. The others are not investigated yet.
* **Screens (C, BGB; 26 of 26 replays end on the `GAME_SEQ` the core reached, from both start saves).** `GAME_SEQ` (`$C0A0`) selects the screen; the main loop's dispatcher `00:01FE` has 14 cases, `$00` to `$0D`, and the runs reached `$01` to `$0D`. In BGB: `$01` title, `$02` MENU (SRAM TEST, BANK TEST, PROTECT TEST, MOVIE TEST, GALLERY, COM), `$03` BANK (`8M OK`, `4M NG` in BGB; bank `$20` mapped at the end: the self-test is running), `$04` SRAM (VERIFY, WRITE, AGING, DUMP), `$05` DATA SELECT (fill patterns), `$06` a live sensor picture with counters (bank `$04` mapped), `$07` AGING (with an ERROR box), `$08` DUMP (hex dump of SRAM bank 00), `$09` the sensor settings (dither, mode, edge, VREF, zero point, gain, offset, exposure, palette), `$0A` PROTECT, `$0B` and `$0D` a blank frame with a number, `$0C` a capture with a test pattern and セーブする? ("save?") Yes / No (bank `$04` mapped). Which menu entry leads to which value is not recorded yet (I). The picture below comes from the blank-SRAM run only (a run from a real save can show its photos).

![The screens of GAME_SEQ $01-$0D, BGB](proto_game_seq_screens.png)

## Two images: as dumped, and patched for BGB

The owner's rule (2026-11-08): **the patched copy for BGB, the image as dumped for everything else** (the disassembly, the md5 round trip, the static trace, the project's core, every script). `tools/setup_env.sh` installs both.

| Installed as | Owner's file | md5 | Use |
|---|---|---|---|
| `pocketcamera_proto.gb` (`proto.gb`) | `GBD-IMPACT8M.gb` | `19b50a5f67ef4f0d015e7d813370756e` | as dumped from the cartridge: the disassembly target |
| `pocketcamera_proto_bgb.gb` (`proto_bgb.gb`) | `GBD-IMPACT8M_FIX.gb` (= `Pocket Camera Prototype Japan.gb`) | `1d8097de3497db8b182bcd2a984b6063` | BGB runs only (BGB refuses the header as dumped) |

The two files differ in six bytes, all in the cartridge header (C, byte comparison):

| Address | Field | As dumped | BGB copy |
|---|---|---|---|
| `$0147` | cartridge type | `$01` (MBC1) | `$FC` (Pocket Camera) |
| `$0148` | ROM size | `$03` (256 KB) | `$05` (1 MB) |
| `$0149` | cartridge RAM size | `$00` (none) | `$04` (128 KB) |
| `$014D` | header checksum | `$4C` | `$4B` |
| `$014E-$014F` | global checksum | `$0000` | `$6245` |

Both header checksums are right for their own header; the global checksum is not filled in the image as dumped (its bytes sum to `$6145`) and is right in the copy (C, recomputed). The header as dumped describes a plain 256 KB MBC1 cartridge without RAM, which the 1 MB image with the camera mapper and 128 KB of SRAM is not: probably values never updated during development (I).

## Leftover linker symbol tables (2026-11-08)

Besides the source text, two binary symbol tables survive: bank `$2A` (file `$A8B7F`, 674 records) and bank `$35` (file `$D4A91`, 705 records), both sorted by name from `ABORTFLAG` to `ZERO0`. A record is a length byte, the name, a kind byte (`$10` label, `$18` EQU constant, `$00` for the two `REM` records), a byte 0..6 (not decoded) and a little-endian value (C, read from the bytes). [`disasm/leftover_symtab_proto.csv`](disasm/leftover_symtab_proto.csv) lists every record; it is written by `python3 tools/proto_symtab.py $R/pocketcamera_proto.gb`.

* **Older builds, not this one (C).** The two tables disagree on most code addresses (bank-0 labels in table `$2A`: 188 with another value in table `$35`, 28 absent from it, 8 equal), and under 2 % of their bank-0 code addresses are a `call` / `jp` target of this ROM's bank-0 code. The code labels cannot be applied by address.
* **HRAM, I/O and constants are stable (C for the agreement).** All 84 HRAM / I/O names of table `$2A` have the same value in table `$35`, and so do its 51 numeric constants and its 31 banked labels; 98 of its 283 WRAM names agree (166 differ, 19 are absent).
* **Names confirmed by this build's code (C).** The main loop `00:01C8-01DD` and the VBlank handler `00:01E3` use the addresses the tables give: `FLMCNT` (`$FFAA`, incremented by the routine called at `00:01D0`, which then dispatches on `GAME_SEQ`, `$C0A0`), `MAIN_AFURE` (`$FFA9`, set to `$FF` by the main loop at `00:01D5`, read by the VBlank handler at `00:01EA`), `VBFLG` (`$FF85`, set by the VBlank handler at `00:01F4`, awaited and cleared by the main loop at `00:01D7-01DD`) and `BANK_BUF` (`$FFFD`, the copy of the ROM bank number kept next to the writes to the bank register `$2100`: 21 occurrences of the bytes of `ldh [$FFFD], a` in bank 0 (a byte search, not a trace), e.g. `00:0552` just before `ld [$2100], a` at `00:0554`). What each variable means beyond these accesses is I.
* **Every other row is a candidate (I)** until the trace of this build confirms it. `DEBA_BROWSE` is a code label in both tables (`$06A7` in `$2A`, `$09A1` in `$35`): a routine of the older builds, not located in this one yet.

**Leftover source text (2026-10-26).** About 160 KB of the developers' build files survive as Shift-JIS text in the ROM: assembly source with Japanese comments in banks `$1E`, `$1F` and `$24`-`$27` (the sensor driver, the exposure loop, the dither tables; several copies at different stages), symbol listings of the source files (`siowork.dmg`, `f_screen.dmg`, `gallery.dmg`, `def.dmg`, `equ.dmg`, `bk7.dmg`) in banks `$12`-`$15`, and `DEFB` data tables. The sensor routines and how they differ from the retail ROM are in [`docs/18_sensor_registers.md`](../../docs/18_sensor_registers.md) §18.14 and [`docs/19_sensor_guide.md`](../../docs/19_sensor_guide.md) §19.9: a linear offset search until a whole 8 x 8 tile in the middle of the picture is black, one register set, an exposure floor of `$21`. The running copy of that code is compiled in bank 0 (`CHECK_BLACK` at `00:37B8`).

