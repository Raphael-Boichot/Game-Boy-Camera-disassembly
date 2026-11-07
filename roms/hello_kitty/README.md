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
| L1-L6 | not started | |

## L0: intake (2026-11-07)

Made by `tools/rom_intake.py` (command in its header); all numbers are byte counts read from [`intake/intake_header.csv`](intake/intake_header.csv) and [`intake/intake_banks.csv`](intake/intake_banks.csv).

* **Header (C).** 1,048,576 bytes = 64 banks; entry `00 C3 6A 17` (`nop; jp $176A`); title `POCKETCAMERA_SN`; cartridge type `$FC` (Pocket Camera mapper), 128 KiB SRAM, SGB flag `$03`, no CGB flag, destination Japan, licensee `33` / `01`, version `$00`; logo, header checksum and global checksum all valid.
* **Round trip (C).** mgbdis with no symbol file and rgbasm 1.0.4 rebuild the ROM byte-exact (L0).
* **Shared content with the sibling ROMs (C for the counts, I for what they mean).** A byte counts as shared when a 16-byte window holding it (not one repeated byte) occurs anywhere in the sibling ROM, at any address. Out of 1,048,576 bytes (226,227 of them padding runs of 16+ `$00` / `$FF`): 262,118 shared with the Japanese Rev A ROM, 263,035 with the international ROM, 263,164 with Gold, 119,140 with the early prototype. 217,204 bytes are shared with the Japanese ROM and not with the prototype, 12,264 the reverse: the Kitty build is much closer to the retail line than to `DEBAGAME`, which fits the owner's hypothesis of a build made from the Japanese version (I, to be tested on the code at L2-L3).
* **Where the Japanese ROM is closest.** Kitty banks `$09` / `$0A` (14,600 / 15,059 shared bytes, the best single Japanese bank being `$30`), `$12` (14,549, best Japanese bank `$2A`), `$11` (11,171, `$2A`), `$1C` (9,426, `$2E`), `$0E` (7,249, `$2F`) and `$04` (5,503, best Japanese bank `$0A`, the Japanese sensor bank). Bank 0 shares 4,155 bytes with the Japanese bank 0 (the README note above: a different bank-0 program).
* **Open (?).** In banks `$1E-$3D` the Kitty ROM shares more with the international ROM than with the Japanese one (60,423 bytes shared with the international ROM and not the Japanese one, mostly there; 65,363 the reverse, mostly in banks `$09-$12` and `$1C`). What these blocks are (pictures, frames, tiles common to the international build) is for L1 / L3; it is not yet evidence for or against a port from the Japanese build.

The ROM is not in the repository (supplied by the owner outside it; md5 `0a323bddc4f0159cea76cf44ed0c1a3c`).
