# Pocket Camera (Hello Kitty)

MD5 `0a323bddc4f0159cea76cf44ed0c1a3c`. A late leaked prototype.

![What each byte of the Hello Kitty ROM is](kitty_rom_layout_map.png)

The map above is drawn by `tools/status_maps.py` (grey-blue = not analysed yet; it fills in as names, types and a trace are added here; per-bank counts in `assets/layout_by_bank_kitty.csv`).

Notes made before the work started (2026-11-01):

* **A different program, not a port.** Bank 0 shares only 2,698 of its 16,384 bytes with the Japanese ROM: it switches banks through `$2100` with the current bank in `$FF8B` (Japanese: `$2000`, `hRomBank`), and its far-call and table helpers are its own (`RST $18` is a jump-table dispatcher; far-call helpers near `00:0151-0194`). No bank is identical to a Japanese bank, and the internal title is `POCKETCAMERA_SN`. `tools/port_build.py` stops at the tracer here (the Japanese bank-0 entry points do not map); this ROM needs its own trace configuration, like a new ROM ([`HOWTO_NEW_ROM.md`](../../HOWTO_NEW_ROM.md)).
* **The save** (owner's [Inject-pictures repository](https://github.com/Raphael-Boichot/Inject-pictures-in-your-Game-Boy-Camera-saves#2021-07-01-update-structure-of-the-hello-kitty-pocket-camera-save), checked against a clean save that BGB made: Kitty ROM booted on an all-$00 SRAM for 1,200 frames): `$1000-$1009` the counters (taken, erased, transferred, printed, received), `$100A-$100C` the **Kitt** counter (3 x 2 BCD digits, low byte first), `$100D` = `$60` after formatting, `$1012-$1016` "Magic" followed by `$00` (no checksum: the game formats the block without one), `$11B2-$11D6` the photo vector state as in the other ROMs (with its echo after it). A clean save has no CoroCoro tag at `$1FFD-$1FFF`.
* **Unlocks.** The Kitts unlock the Strawberry Channel animations (TCRF: animation 1 and the credits are open, the others at Kitt milestones), and pay for the scratch cards (10) and the sliding puzzles (25). Emulator runs of this ROM must start from a save with the Kitt counter raised (`99 99 99`, 999,999 Kitts; made from the clean save, kept outside the repository), and the milestones are to be read in the code.

## Levels

| Level | Status | Evidence |
|---|---|---|
| L0 | done (2026-11-07) | `intake/intake_roundtrip.txt`: mgbdis `95d951a` with no symbol file + rgbasm 1.0.4 rebuild md5 `0a323bddc4f0159cea76cf44ed0c1a3c` |
| L1 | done (2026-11-07) | `pocketcamera_kitty.sym` types every byte (`tools/sym_build.py` finds no hole or overlap); mgbdis + rgbasm rebuild md5 `0a323bddc4f0159cea76cf44ed0c1a3c` with it (the checker's `kitty` lines) |
| L2-L6 | not started | |

## L0: intake (2026-11-07)

Made by `tools/rom_intake.py` (command in its header); all numbers are byte counts read from [`intake/intake_header.csv`](intake/intake_header.csv) and [`intake/intake_banks.csv`](intake/intake_banks.csv).

* **Header (C).** 1,048,576 bytes = 64 banks; entry `00 C3 6A 17` (`nop; jp $176A`); title `POCKETCAMERA_SN`; cartridge type `$FC` (Pocket Camera mapper), 128 KiB SRAM, SGB flag `$03`, no CGB flag, destination Japan, licensee `33` / `01`, version `$00`; logo, header checksum and global checksum all valid.
* **Round trip (C).** mgbdis with no symbol file and rgbasm 1.0.4 rebuild the ROM byte-exact (L0).
* **Shared content with the sibling ROMs (C for the counts, I for what they mean).** A byte counts as shared when a 16-byte window holding it (not one repeated byte) occurs anywhere in the sibling ROM, at any address. Out of 1,048,576 bytes (226,227 of them padding runs of 16+ `$00` / `$FF`): 262,118 shared with the Japanese Rev A ROM, 263,035 with the international ROM, 263,164 with Gold, 119,140 with the early prototype. 217,204 bytes are shared with the Japanese ROM and not with the prototype, 12,264 the reverse: the Kitty build is much closer to the retail line than to `DEBAGAME`, which fits the owner's hypothesis of a build made from the Japanese version (I, to be tested on the code at L2-L3).
* **Where the Japanese ROM is closest.** Kitty banks `$09` / `$0A` (14,600 / 15,059 shared bytes, the best single Japanese bank being `$30`), `$12` (14,549, best Japanese bank `$2A`), `$11` (11,171, `$2A`), `$1C` (9,426, `$2E`), `$0E` (7,249, `$2F`) and `$04` (5,503, best Japanese bank `$0A`, the Japanese sensor bank). Bank 0 shares 4,155 bytes with the Japanese bank 0 (the README note above: a different bank-0 program).
* **Open (?).** In banks `$1E-$3D` the Kitty ROM shares more with the international ROM than with the Japanese one (60,423 bytes shared with the international ROM and not the Japanese one, mostly there; 65,363 the reverse, mostly in banks `$09-$12` and `$1C`). The owner's view (2026-11-07): the Kitty build is its own port, with its own assets, music and menus; only the sensor, printer and SRAM organisation are expected to be close to the Japanese ROM. Whether these shared windows are whole assets or small common pieces (blank or plain tiles, glyphs, fills) is checked asset by asset at L3; shared bytes are not used as evidence that an asset is shared.

## L1: every byte typed (2026-11-07)

The Kitty engine is not the Japanese one, so this ROM has its own tracer, `tools/kitty_trace.py` (its docstring lists the engine conventions read in the listing: ROM bank register `$2100` with shadow `hFF8B`, SRAM bank register `$4000` with shadow `hFF8C`, far call `$015B` / `$0165` with B = bank and HL = target and the callee returning through `jp $0173`, one-way far jump `$0155`, jump tables `$0189` / `$0194` / `rst $18`, far jump table `$01A0`, routines that take inline arguments after the call, the two LCDC-callback setters, the far callback given to `$1AB7`). Pipeline (SETUP.md, Hello Kitty): `kitty_trace.py` -> `port/trace_kitty.json` and `port/trace_kitty_unresolved.md`; `tools/kitty_types.py` -> `disasm/sym_types_kitty.csv`, `assets/copy_sites_kitty.csv`, `port/rom_map_kitty.csv`, `disasm/sym_names_kitty.csv`; `tools/sym_build.py` -> `pocketcamera_kitty.sym`. All seven files are generated; hand input goes in `disasm/extra_roots_kitty.json`.

* **Code (C).** 39,824 bytes of proven code (recursive descent from the entry, the five interrupt vectors, the rst and bank-0 helpers; 563 far calls resolved from constants on the straight line before the call). The main loop (`00:0CF2`) calls the mode routine through the far jump table `ModeTable` (`00:0D00`, 31 `{lo, hi, bank}` entries, mode in `hFF8D`); each mode dispatches its state (`hFF8E`) through a word table read by `$0189`. Mode and state are set by `$01B2` (mode = A), `$01BD` (state = A), `$01C8` (B, C) and `$01D1` (two inline bytes).
* **Table lengths (I where cut by hand).** A word table is read up to the lowest target seen; 9 tables are cut by hand in `disasm/extra_roots_kitty.json`, each with its reason (a word that lands inside an instruction or inside argument bytes, a next table that starts there, a mode whose code sets no higher state). The trace also reports, per state table, the states that the code sets for that mode (`state_check` in the trace file).
* **Left for L2.** 14 indirect sites left unresolved (`port/trace_kitty_unresolved.md`): calls through HL / BC taken from RAM records (`00:20C4`, `00:2113`, `00:212F`, `01:59E7`, `01:59FE`), indexed `jp hl` in banks `$04`, `$07` and the sound driver of bank `$0F`, and one LCDC callback passed in DE. Code reached only through them is typed as data until L2.
* **Data typed by a reason (C).** 139,058 bytes of data typed by a code-read reason: the jump tables (width 2 or 3), the inline argument bytes after the calls, and the sources of 227 of the 306 traced copy-routine calls whose bank, source and length are constants (`assets/copy_sites_kitty.csv`): tiles (`data,16`, destination `$8000-$97FF`), tile maps (`data,32` / `data,20`, destination `$9800-$9FFF`), WRAM / OAM data. Each block start carries a label named by kind and address only (`Gfx_BB_AAAA`, `Map_BB_AAAA`, `Data_BB_AAAA`, `JumpTable_BB_AAAA`, `FarJumpTable_BB_AAAA`, `ModeTable`).
* **The rest.** 165,647 bytes of padding (runs of 16+ `$00`); 704,047 bytes of data on the default typing (`.data`, 16 per row): the sources of the copies whose arguments come from tables or RAM, and the picture banks `$1E-$3F`. They are typed by the emulator ROM-read log at L2 and named at L3 (HOWTO Stage C item 4); the layout picture shows them grey-blue.

The ROM is not in the repository (supplied by the owner outside it; md5 `0a323bddc4f0159cea76cf44ed0c1a3c`).
