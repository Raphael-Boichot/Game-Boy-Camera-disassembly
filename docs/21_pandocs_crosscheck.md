[README](../README.md) · [Section index](index.md)

# 21. The project against Pan Docs

The owner asked (2026-11-22) to check every claim, comment and name of the project against [Pan Docs](https://gbdev.io/pandocs/), with Pan Docs as the reference. Pan Docs was read from its source (github.com/gbdev/pandocs, commit `f7f7b064`, 2026-11-20). The pages that bear on this project are [Game Boy Camera](https://gbdev.io/pandocs/Gameboy_Camera.html), [Game Boy Printer](https://gbdev.io/pandocs/Gameboy_Printer.html), the SGB pages ([Command Summary](https://gbdev.io/pandocs/SGB_Command_Summary.html), [Palette Commands](https://gbdev.io/pandocs/SGB_Command_Palettes.html), [Border Commands](https://gbdev.io/pandocs/SGB_Command_Border.html)), [The Cartridge Header](https://gbdev.io/pandocs/The_Cartridge_Header.html), [Window](https://gbdev.io/pandocs/Window.html), [Serial Data Transfer](https://gbdev.io/pandocs/Serial_Data_Transfer_(Link_Cable).html), [Timer and Divider Registers](https://gbdev.io/pandocs/Timer_and_Divider_Registers.html), [Interrupts](https://gbdev.io/pandocs/Interrupts.html), [OAM DMA Transfer](https://gbdev.io/pandocs/OAM_DMA_Transfer.html) and [Audio Registers](https://gbdev.io/pandocs/Audio_Registers.html). Checked: the docs, the ROM source comments and names, the tools' texts, and the printer protocol document of the project. The I/O register names of the source come from the community `hardware.inc` (rev 4.8.0), not from this project, and were not reviewed one by one.

Three outcomes: (A) the project agreed, (B) the project was wrong or imprecise by Pan Docs and has been corrected, (C) the project and Pan Docs differ and the project has its own evidence: Pan Docs is wrong on these points (owner, 2026-11-23: settled, not an open question; the project keeps its own values). One point (21.4), the exposure step, was settled by the owner: both values are now given.

### 21.1 Agreement (A)

| Topic | Project | Pan Docs |
|---|---|---|
| MAC-GBD map | registers in RAM bank `$10`, `$A000` control, `$A001` = sensor reg 1, `$A002/$A003` = regs 2/3 (high, low), `$A004` = reg 7, `$A005` = reg 0, `$A006-$A035` = 16 cells × 3 thresholds (§18.2) | the same |
| `$A000` | bit 0 starts the capture and reads 1 while busy; bits 2-1 select P and M; the ROM writes `$03` (§18.2) | the same (already cross-checked in §18.2) |
| Sensor fields | N, VH, G (reg 1); E3, E (ratio 50 % … 500 %), I, V (reg 7); Z, O (reg 0); gains 14.0-51.5 dB with +6 dB for G4 (§18.2) | the same bit layout and gain table |
| N = 1 and short exposures | band 1 (N = 1) leaves for band 0 below `$0031` (§10) | "if N = 1, exposure should be ≥ `$0030`" |
| Matrix order | cell n at `$A006 + 3n`, rows of four (§7) | "sorted by rows", cell `6 + (y·4 + x)·3`; the citation is now in §7 |
| Photo in SRAM | the 112-line photo at `$A100-$AEFF` of RAM bank 0 (§18.3) | its sample code writes the picture at SRAM `0x100` |
| Compression | the camera never compresses: `wPrnCompEnable` is never written, the compressed path is dead (§2) | "The GB Camera doesn't use it" |
| Printer packets | sync `88 33`, command, compression, length low byte first, checksum of everything but the sync bytes, reply `81` + status; status bits 0x01 … 0x80; the empty DATA packet before PRINT; the statuses of Pan Docs' example (INIT `00`, DATA `00`, then `08` for the status poll, the empty DATA and PRINT, `06` while printing, `04` when done) (printer doc §1, §4, §6) | the same |
| PRINT defaults | margins `$13` for a plain single print, exposure `$40`, palette `$E4` (§17.3, §17.5a) | "GB Camera sends `$13` by default", `$40`, `$E4` |
| SGB packets | header = command × 8 + 1 for MASK_EN `$B9`, PAL_SET `$51`, PAL_TRN `$59`, DATA_SND `$79`, MLT_REQ `$89`, CHR_TRN `$99`, PCT_TRN `$A1`, ATTR_TRN `$A9`; MASK_EN 1 = freeze, 0 = cancel; CHR_TRN byte 1 bit 0 = tiles `$80-$FF`; MLT_REQ 0 / 1 = one / two players; DATA_SND up to 11 bytes (§16) | the same |
| Header | `$0147` = `$FC` Pocket Camera, `$0148` = `$05` 1 MiB, `$0149` = `$04` 128 KiB, `$0146` = `$03` SGB, old licensee `$33` with new licensee `"01"`; prototype `$03` = 256 KiB, `$00` = no RAM (prototype README) | the same codes |
| Serial and timer | master `SC = $81` (8,192 Hz, one byte = 4,096 clocks, 0.98 ms), slave `$80`; `TAC = $06` = on, 65,536 Hz; `TIMA = $EE` = 18 ticks = 275 µs; `IE` bits 2 (timer) and 3 (serial); serial vector `$0058` (§14) | the same |
| OAM DMA, interrupts, audio | the HRAM routine `ld a,$D4 / ldh [$46],a / ld a,$28 / dec a / jr nz` (160 M-cycles of waiting); `IE` bit 1 = STAT; STAT bit 6 = LYC interrupt; NR21 duty in bits 7-6, NR22 volume in bits 7-4 and direction in bit 3, NR43 bit 3 = LFSR width; the D.J. editor's SOUND I / SOUND II / NOISE = channels 2 / 3 / 4 (§2) | the same |
| Frame | 70,224 clocks per frame, 59.7 frames per second (§13, §16.6) | the same |

### 21.2 Corrected by Pan Docs (B)

| # | Was | Pan Docs | Changed in |
|---|---|---|---|
| 1 | PAL_SET flag byte `$80` = "cancel mask" | PAL_SET byte 9: bit 7 = apply ATF (here ATF 0), bit 6 = cancel MASK_EN | `tools/jp/asset_map_build.py`, `roms/jp_rev_a/assets/asset_map_jp.csv` (regenerated; it also had four stale "README" references), §16 table |
| 2 | the ATTR_TRN data "not used by this sequence" | with flag `$80`, PAL_SET applies ATF 0 = the first 90 bytes of the ATTR_TRN data; here all zero, so palette 0 everywhere: used, with no visible effect | §16 table, asset map |
| 3 | PCT_TRN: "map 32 × 32 words, palettes 4-7 at `6986-6A05`" | map 32 × 28 words + one extra row (`$000-$73F`), `$740-$7FF` not used; palettes **4-6** at `$800-$85F`; `$860-$FFF` not used. The border map uses palettes 4 and 5; the DATA_SND packets sit in the unused part | §16 table, `tools/jp/sgb_border_check.py` text (its rendering already used 28 rows) |
| 4 | WX `$A6` / `$A5` "hidden" | WX 0-166 is the visible range; WX = 166 on a DMG shows a full-width window one line lower. In the core, every sampled frame with WX = `$A6` also has the window off in LCDC (bit 5) and WY = `$8F`: the window is hidden by LCDC, not by WX | §2 rows `$FF4B`, `$FFB4` |
| 5 | MAME's capture-time constant "has no stated source (?)" | the Game Boy Camera timings give the same formula: `32,446 + (N ? 0 : 512) + 16 × exposure` M-cycles, from AntonioND's hardware measurements | §18.12 |
| 6 | "the registers exist only with bank `$10` (I)" | any RAM bank value with bit 4 set selects them, and they repeat every `$80` bytes (`$A080-$A0B5` would be a mirror the ROM never uses) | §18.11 |
| 7 | "AntonioND's documentation only says 128×126 or so" | the same source also says that the transfer is 128 × 128 with corrupted top and bottom rows, and that the controller ignores the first and last 8 rows; see 21.3 for what this ROM shows | §9 |
| 8 | §17.10 "the length of one revolution is still open on the printer side" | (not Pan Docs: the project's own printer document gives about 1 s, the owner's timing) | §17.10 |
| 9 | README: the SGB page "address not recorded" | the page is [Border Commands](https://gbdev.io/pandocs/SGB_Command_Border.html) | README |

### 21.3 Where Pan Docs is wrong (C, settled)

Settled (owner, 2026-11-23): on each point below Pan Docs is wrong and the project's evidence stands; the project keeps its values and does not follow Pan Docs there. Point 4 rests on the printer's ROM run in an emulator: the figure in real time may still be measured on hardware, which would refine the value, not reopen the point.

| # | Pan Docs says | The project shows | Evidence |
|---|---|---|---|
| 1 | Register 1: "The Game Boy Camera uses `$00`, `$04`, `$08` and `$0A`" (gains 14, 20, 26, 32 dB) | the gain probe at boot chooses g = 0-3, so bands 0-1 run at 14-18.5 dB and band 2 at 20 or 21.5 dB (G = 4 or 5); `$08` and `$0A` for bands 3 and 4 | bus recordings of a real camera and the ROM (§18.15, §10) |
| 2 | The controller "ignores the first 8 rows and the last 8 rows"; the sample code writes only lines 8-119, from SRAM `0x100` | the camera writes all 128 lines to `$A000-$AFFF`: the calibration reads lines 1-4 (`$A002-$A008`, `$A082-$A088`) at every boot, and a full frame of the owner's camera has data down to line 127 (lines 122-127 saturated). An emulator that follows the sample code leaves `$A000-$A0FF` unwritten, and the boot then measures stale data | ROM (§18.3), the owner's frame (§9) |
| 3 | Game Boy Printer: "8 KiB of RAM … a maximum bitmap area of 160\*200 pixels between prints" | the firmware uses `$1680` bytes = 9 bands = 160 × 144; a 10th data packet is acknowledged but not stored | the printer's ROM, run in an emulator (printer doc §7, §14) |
| 4 | "The printer has a timeout of 100 ms for packets" | the idle reset clears the job after 12-13 main-loop ticks, about 125-133 ms: a 100 ms pause before PRINT still prints, 140 ms does not | printer ROM in the emulator (printer doc §9, §14); the real-time value is still to be measured on hardware |
| 5 | Commands 1, 2, 4, `$F` only; compression "some sort of RLE?" | command `$08` (break) and unknown commands acknowledged; the RLE format: control byte < `$80` → c + 1 literal bytes, ≥ `$80` → next byte (c & `$7F`) + 2 times | printer ROM (printer doc §1, §5, §7) |
| 6 | "Optionally send 16 zero bytes to clear the printer's receive buffer (GB Camera does it)" | the Japanese ROM sends two bytes after each checksum (`Prn_SendTrailerByte`: `cp $02`) and nothing else: in three BGB print jobs every byte received by the printer is inside a packet (6,114 of 6,114, 18,342 of 18,342, 12,218 of 12,218) | ROM and BGB (`roms/jp_rev_a/experiments/bgb_printer/print_options/`); the other ROMs were not checked |
| 7 | Game Boy Printer, "Detection": "Send these 9 bytes" followed by eight | (a slip inside Pan Docs) | |
| 8 | Game Boy Camera: the first row of the gain table reads `0 0 0 1` for 14.0 (it is `0000`); the matrix table's third row reads `02 12 23 33`; "M6438FP" for M64282FP | (slips inside Pan Docs) | |

### 21.4 The exposure step: both values (settled)

Pan Docs: one exposure step is 16 PHI clocks of the cartridge = 15.26 µs ("a bit less than the 16 µs the datasheet says"); MAME, quoted in §18.12, uses the same step. The project used to convert with the datasheet's nominal 16 µs, which makes every time 4.9 % too long at the camera's clock. **Settled by the owner (2026-11-22):** the sensor accepts small variations of its timing and runs on the clock it is given, so the real value is the camera's; the docs now give both, the real one first: `$0010` = 0.244 ms (datasheet: 0.256 ms), `$0030` = 0.732 ms (0.768), `$1000` = 62.5 ms (65.5), `$FFFF` = 1,000.0 ms (1,048.6), C1 step 3.906 ms (4.096). Figures that the datasheet itself states (its 0.768 ms minimum for the edge modes, its 1,044.5 + 4.08 ms maximum) stay in its units, with the camera's equivalent next to them. Changed: §2 (`$D596`), §5, §7, §9, §10, §18, §19; the recordings' CSVs (`sensor/{boot,calibration,live}_rows.csv`: `C_ms` is now the real time, `C_ms_datasheet` the old column), `tools/jp/sensor_decode.py`, `tools/jp/sensor_plots.py` (and `sensor/live_exposure_bands.png`), `tools/jp/sensor_sites.py` (and `sensor/register_sites.csv`). One old figure was neither value: `$0CDD` was given as 51 ms in §5; it is 50.2 ms (datasheet: 52.7 ms).
