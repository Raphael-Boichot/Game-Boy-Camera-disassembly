# Pocket Camera (Hello Kitty)

MD5 `0a323bddc4f0159cea76cf44ed0c1a3c`. A late leaked prototype.

![What each byte of the Hello Kitty ROM is](kitty_rom_layout_map.png)

The map above is drawn by `tools/status_maps.py` (grey-blue = not analysed yet; it fills in as names, types and a trace are added here; per-bank counts in `assets/layout_by_bank_kitty.csv`).

Notes kept for when this ROM is started (2026-11-01; the owner asked to finish the international and Gold ROMs first):

* **A different program, not a port.** Bank 0 shares only 2,698 of its 16,384 bytes with the Japanese ROM: it switches banks through `$2100` with the current bank in `$FF8B` (Japanese: `$2000`, `hRomBank`), and its far-call and table helpers are its own (`RST $18` is a jump-table dispatcher; far-call helpers near `00:0151-0194`). No bank is identical to a Japanese bank, and the internal title is `POCKETCAMERA_SN`. `tools/port_build.py` stops at the tracer here (the Japanese bank-0 entry points do not map); this ROM needs its own trace configuration, like a new ROM ([`HOWTO_NEW_ROM.md`](../../HOWTO_NEW_ROM.md)).
* **The save** (owner's [Inject-pictures repository](https://github.com/Raphael-Boichot/Inject-pictures-in-your-Game-Boy-Camera-saves#2021-07-01-update-structure-of-the-hello-kitty-pocket-camera-save), checked against a clean save that BGB made: Kitty ROM booted on an all-$00 SRAM for 1,200 frames): `$1000-$1009` the counters (taken, erased, transferred, printed, received), `$100A-$100C` the **Kitt** counter (3 x 2 BCD digits, low byte first), `$100D` = `$60` after formatting, `$1012-$1016` "Magic" followed by `$00` (no checksum: the game formats the block without one), `$11B2-$11D6` the photo vector state as in the other ROMs (with its echo after it). A clean save has no CoroCoro tag at `$1FFD-$1FFF`.
* **Unlocks.** The Kitts unlock the Strawberry Channel animations (TCRF: animation 1 and the credits are open, the others at Kitt milestones), and pay for the scratch cards (10) and the sliding puzzles (25). Emulator runs of this ROM must start from a save with the Kitt counter raised (`99 99 99`, 999,999 Kitts; made from the clean save, kept outside the repository), and the milestones are to be read in the code.

Not started: this folder will hold the symbol file and the tables of this ROM, built with the tools of the repository and the playbook [`HOWTO_NEW_ROM.md`](../../HOWTO_NEW_ROM.md). The ROM is not in the repository (supplied by the owner outside it; md5 `0a323bddc4f0159cea76cf44ed0c1a3c`).
