[README](../README.md) · [Section index](index.md)

## 12. Open questions

Only what is still open; what was answered is in the sections named in the contents. Evidence tags as elsewhere.

**SRAM** (§3.8, §11.9)
- The origin of the 2005 layout (shifted calibration record and 6 stray bytes per slot in the camera `CE10550742`), of the `00 39` and `80 44 2A 40` patterns and of the single-bit flips in the photo area of 14 slots is not established. The 2005 layout is not a ROM revision (the camera holds the standard USA/EU ROM and the retail code ignores the shifted record). The owner's cameras went through injections of synthetic saves, battery replacements and save swaps and no record says what was done to which unit: every provenance statement about these cartridges (`1B 13` present or absent, identical vectors, repeated owner IDs, the `CE10866859` case) is **I**; only the ROM-behaviour findings are firm.
- NOISE editor: which control feeds `$D9AD` (`10A1` bits 6-4, value 5 seen once) and what the per-step LFSR-width flag of `10B7-10B8` is called on screen (its hardware effect, NR43 bit 3, is settled).
- `F34-F35`: 52 non-zero mismatches among 369 used slots (25 in one save); no code that compares the value was found; `bank0:$16F4` splits it into 4 nibbles for the sound driver (the P.VOICE, §16.30); no screen shows them.
- Who writes `1B 13` in a real camera (the Hello Kitty ROM does, at the end of its SRAM-initialisation routine; the retail ROMs never do), and why the factory test needs two tolerances (27 and 19) for the `AFFC` / `AFFD` pair.

**WRAM / HRAM** (the complete lists are in §2.12)
- The visible effect of the SHOOT variants (`$D7E3` values 3-`$15`, the option cross `$D7E9-$D7EC`, the option screens `$D5E3-$D5EB`): dispatch, data flow and names are known (§16.2); the picture every effect slot writes is measured in BGB (§16.28); what is open is the match of the lens numbers 1-7 and the montage layouts with their on-screen icons.
- The message texts behind `$DBCF`; the visible effect of the five-byte vectors `$DA44-$DA48`.
- The meaning of the individual sound ids. (The printer checksum-retry path that advances `$DC1F:20` by `$0280` is explained by the printer's firmware, which reports a checksum error one packet late: §17.10.)

**Disassembly** (§1.2)
- The type and extent of the 56,947 non-padding bytes of the data banks that no run of §13 read (§13.5-§13.7). The index / pointer tables behind the six reader routines `04:58DE`, `04:5A9D`, `08:5400`, `08:5055`, `02:4CFF` and `06:5CFF` are decoded and typed (2026-10-19): those addresses are bank-selecting copy calls, the tables are the stamp tables of §2.6, `Border_SrcTbl` (`08:511F`), `WildFrame_PageSrcTbl` (`08:54C6`), `AlbumB_SlotTbl` (`02:5218`) and the thumbnail tables `Mode18_LoadThumb_Tbl5D44` / `Tbl5D54` (`06:5D44`, `06:5D54`).

**Sensor and calibration** (§18.9)
- The calibration vector: one black-level reference per register set, so the five live bands join without a visible jump (§18.13, I, with real-camera evidence); the factory step needs darkness (a strong light changes it completely, §18.13, C). Still open: the vector a strong-light calibration stores, and what the photos of a camera calibrated that way look like.
- Bit 1 of the `$03` written to `$A000` (P/M selector or status bit; a bus test would settle it); why the first test capture of the gain probe uses the matrix byte `$D5`; which SHOOT variants freeze the auto-exposure (`$D7E3 >= $13`); what the extra `print` sheet of the owner's workbooks recorded; the printing menus (no extra captures seen in BGB, the printer helper was not attached); the SRAM of the recorded unit, to compare with the vector implied by its threshold scans (§18.5).
- The masked pixel lines (§9): a datasheet pointer or probing data is needed to say why lines 123-128 (y = 122-127) read the clipping level 225 in the one frame measured (§9) and whether they do in every mode (MAME's header says 128 x 123 pixels, §18.12: it supports the 123-line figure, not the content of those lines).

**Other**
- The international ROM only: whether its code compares the owner name with a fixed string (a hidden feature triggered by a user name). In the Japanese ROM none does (C, code read 2026-10-26): every instruction that touches the owner block `$DA49-$DA5A` or its tag copy `$DA5B-$DA6F` is in `Owner_Load_Far` / `Owner_Store_Far` (SRAM copy at `$AFB8`), `Photo_SaveShot_Far` / `Photo_SaveReceived_Far` / `Photo_LoadTagFields_Far` / `Photo_StoreTagFields_Far` (copies to and from the photo tag), the keyboard (`Kb_*`), the owner and comment cards (`OwnerCard_*`, `CommentCard_*`, drawing), `Mode0E_State04_PickDone` / `State0D_PickSecond` (the gender byte for the reception counters) and two tests that the field is empty (`Owner_GenerateId_Far`: an all-zero ID gets 8 random digits; `Mode08_State02_PlanetOpen`: an empty name opens the editor); the ID is random, and no routine compares the name, the ID or the birth date with ROM bytes.
- TCRF items that keep an open point (`tcrf_check/TCRF_CHECKLIST.md`, the 8 rows tagged `?`): B02, B03 (songs not checked by ear), B08 (the two placeholder tiles), B15 (what the printed icon means), B17 (the "and more"), C04 (the STAFF ROLL label), C17 (the exit-only menu), C18 (the third error face). B14, B18, C06, C12 and C16 are settled (§16.29).
- The open points of the BGB comparison (§16.10, §16.11 "what this walk does not prove", §17).

---
