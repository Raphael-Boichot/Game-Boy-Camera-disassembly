# WRAM `$D500-$D5FF` (Pocket Camera JP Rev A)

Status tags: **C** code-traced (instructions cited as `bank:addr`), **I** inferred, **U** unused/dead, **?** inconclusive. Companion table: `wram_d500.csv`. All claims were checked against proven code (`wram/trace_jp.json` key `code`), not against labels. Joypad convention used below: `$FFA1` held, `$FFA2` newly pressed, `$FFA3` newly pressed or repeating; bits 0..7 = A, B, Select, Start, Right, Left, Up, Down.

**Coverage.** All 156 addresses of the page present in `wram_summary.csv` are in a table row below (arrays and tables are one row with a size; the per-address access counts are in the appendix). Status of those 156 addresses: **C 95**, **I 57**, **U 3**, **? 1**.

**Overlays.** `$D500-$D51F` and `$D5D0-$D5FF` are reused with a different meaning by each mode bank (a bank only runs while its mode is active); every row names the bank(s). `$D5CE` (mode) and `$D5CF` (state) are the only truly shared bytes besides the palette targets, `D5D8` and the cursor helpers.


## $D500-$D51F: sprite-animation pairs

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$D500-$D50E` | 15 | `sprite_anim_frame[15]` | u8[15]; slot n = $D500+n (slots 0-14) | bank 0 `00:100B` clears $D500-$D51F (only callers 03:6371, 07:558F); bank 3 (30 acc.), 8 (15), 7 (14), 4 (10) | Frame index of a table-driven sprite animation; the partner byte `$D510+n` is the tick counter (see overlay notes). Mechanism C, per-slot sprite identity I. Bank 3: d500/d501 cursor blink (reset to 2 at 03:7A5E), d502-d505 sprite loops, d506 = a tile id (consts $75/$76, no tick partner), d507/d508 two-actor script step (states 10/12), d50b-d50d one-shot effects (states 20/23/26/29). Bank 7: d500, d502-d504. Bank 8: d500 = print animation frame 0..4 (wraps at 5). Bank 4: d500 (mode 1 cursor menu, `04:728C` indexes a 4-byte table with it), d501 | I |
| `$D50F` | 1 | `arrow_anim_frame` | u8 0,1,2 (2 = finished) | 04:7832, 04:7917, 04:79FD, 04:7AD3 (and the twin routines 06:6734-06:6979); reset to 0 at 04:69C2 | Frame index of a 2-frame pointer-arrow flash: table `04:7873` = (sprite group, duration) pairs `($BC,$10) ($BD,$0B)`; at frame 2 the routine returns without drawing. Position row picked by D674 (`04:786F`). Partner tick = `$D51F`. Pair is reset to 0,0 when a direction key is pressed (04:69BF/69C2). Which on-screen arrow this is: ? (picker screens of mode $0A / $09) | I |
| `$D510-$D51E` | 15 | `sprite_anim_tick[15]` | u8[15]; partner of $D500+n | same routines as the matching frame byte (03:649B, 03:7117, 03:7162, 03:7774 ...) | Tick counter: incremented once per call, compared with the frame duration read from the animation table; on equality the frame byte advances and the tick is zeroed. `$D519`/`$D51A` have no frame partner in use (`$D509`/`$D50A` absent from the access table): bank 3 states 9/12/13 and 17/18 use them as bare delay counters; `$D517/$D518` pair with d507/d508, `$D51B-$D51D` with d50b-d50d | I |
| `$D51F` | 1 | `arrow_anim_tick` | u8 | same routines as `$D50F` | Tick partner of `$D50F` (compared with the duration byte of the current frame at 04:7857; written 0 on advance) | I |

## $D520-$D560: VRAM queue, soft-reset flag, palette targets, RNG

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$D520` | 1 | `vq_write_idx` | u8 (low byte of $D300+x) | 00:0A8A enqueue (callers 08:4EE9, 08:5290); boot zeroings 00:01B6, 00:0256 (write); 00:0A9E/0AA3 (enqueue), 00:0AB9 (empty test) | Write index of the VBlank VRAM-transfer queue `$D300-$D3FF`: `$0A8A` stores a 4-byte record `[$FF marker, C = descriptor lo, B = descriptor hi, A = ROM bank of the descriptor]` at `$D300+idx`, zeroes the next head byte, `idx += 4` (the low byte wraps: 64 records); if the LCD is off (`$FF40` bit 7 clear) it drains the queue at once. NOT a sound sequencer (old README §2) | C |
| `$D521` | 1 | `vq_read_idx` | u8 (low byte of $D300+x) | 00:0AB9 (read at 0ABC pointer load; stop index written at 0AE3), called from VBlank 00:02AB; boot zeroings 00:01B9, 00:0259 | Read index. `$0AB9` executes records (descriptor in ROM bank A or WRAM through `$0AE7`: hi,lo VRAM address, flags/length, data; flag bit 7 = column stride $20, bit 6 = fill) until a 0 head byte, then stores the stop index (00:0AE3). Queue empty when d520 == d521 (test at 00:0ABF) | C |
| `$D522` | 1 | `unused_d522` | u8 | boot zeroings 00:01BC, 00:025C only | Only ever written (0) at boot, never read, no pointer load | U |
| `$D523` | 1 | `soft_reset_enable` | u8 flag | VBlank 00:02F3 (read); boot zeroings 00:01CA, 00:026A; set to 1 at 00:2F20 (main-loop prologue, not in trace_jp.json, see notes) | If non-zero and the held buttons are exactly A+B+Select+Start (`$FFA1 == $0F`) with a newly pressed one (`$FFA2 & $0F`), the VBlank handler blanks the palettes, disables SRAM/serial/IE/sound and re-enters boot via `ld hl,$0210; push hl; reti`. It is 0 during boot and set to 1 by the main-loop prologue (`ld a,$01; ld [$D523],a` at 00:2F20, just before the loop `00:2F2D`), so the A+B+Select+Start soft reset works once the main loop runs. That write is in code the tracer never reached (see 'Main loop' note); the bytes are plain code reached by the far-jump `call $08BB` at 00:020D / 00:02A0 | C |
| `$D524-$D526` | 3 | `palette_target[3]` | BGP, OBP0, OBP1 (3 x u8) | writers: every screen-entry routine (banks 3-9, 0A; 185 writes); readers: fade-in 00:0D18 (DE=$D524, ptr loads 0D1B/0D38/0D51) and 00:0DBB | Target palettes of the next screen. Constants written: `$E4` (BGP and OBP0, normal), `$D2` (OBP1 normal), also `$1B`, `$FF`, `$E1`, `$F3`, `$C6`, `$93`, `$D3`. `00:0D18` builds the fade-in in 3 stages of 2 frames each (`$08DF` BC=2) into HRAM shadows `$FFB0-$FFB2` (copied to BGP/OBP0/OBP1 by VBlank): with l = t&$55 and h = (t&$AA)>>1 per palette byte t: stage 1 = l&h, stage 2 = stage 1 + h, stage 3 = stage 2 + (h\|l) = t (cumulative, so the last stage equals the target); `00:0D6D` is the 3-step fade-out; `00:0D10` zeroes `$FFB0-$FFB2` | C |
| `$D527` | 1 | `rng_seed_tmp` | u8 | 00:091A (writes 092C/094D, reads 0944) | Temporary of the boot seed generator (the 'mj' of Knuth's subtractive generator) | C |
| `$D528` | 1 | `rng_modulus` | u8 = $FF | boot 00:01F7, 00:0289 (write $FF); 00:091A, 00:09AD (read) | Modulus M of the subtractive generator (255) | C |
| `$D529` | 1 | `rng_index` | u8 0..54 | 00:08F9 | Read pointer into the table: `$08F9` returns table[d529], increments, and on reaching `$37` (55) calls `$09AD` and wraps to 0 | C |
| `$D52A-$D560` | 55 | `rng_table[55]` | u8[55] ($D52A-$D560), values 0..254 | 00:091A (fill), 00:09AD (advance), 00:08F9 (draw); 54 call sites of 00:08F9 in banks 3-9 | Knuth / Numerical-Recipes 'ran3' subtractive table. Filled at boot by `$091A` at positions `(21*i mod 55)-1`, last element (d560) = seed mod 255; `$09AD` only touches entries 0 and 24 (the pointers of its two warm-up loops are never advanced). Seed = boot counter SRAM flat `$02FFF` (README §3.8 boot-seed cycle). Note: the range ends at `$D560` (55 bytes), not `$D55F` | C |

## $D561-$D582: photo count, state vector copy, flags

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$D561` | 1 | `photo_count` | u8 0..30 | writer: bank 2 `$44A9` (end of the renumbering routine `$4466`); readers 02:45A1, 02:462F, 02:46F0, 03:5525, 04, 06, 07 (random-photo pick `07:7037`) | Number of used slots = entries != $FF in `$D563`. Already valid at the main menu (README §8 correction stands) | C |
| `$D562` | 1 | `stock_picture_count` | u8 ($18 or $1E) | writer 08:7263 ($18) and 08:72BE ($1E) in mode $19 init 08:724F; readers 04:41FB-4201, 03:554C, 06:5750 | Number of built-in 'stock' pictures that may be browsed after the user's photos: indices `$1E+n` are valid for n < d562 (04:41F6-4202); wrap size of the 06:5751 picker = d562+$1E. $18 (24) normally, $1E (30) when the CoroCoro tag test succeeds. SRAM mirror: CoroCoro tag flat `$01FFC-$01FFF` (README §3.3) | C |
| `$D563-$D580` | 30 | `photo_vector_ram[30]` | u8[30], slot -> rank | bank 2 `$4466` (load+renumber), `$444D`, `$44FB` (delete), `$45A1` (insert), `$462F`, `$43F9` (write-back) | RAM copy of the SRAM state vector (flat `$011B2-$011CF`, bank 0 `$B1B2`, 30 bytes + Magic + checksum, echo at `$011D7`) renumbered to a dense 0..n-1 order by `$4466`, which also counts the non-$FF entries into `$D561`. $FF = unused slot. Edited by `$44FB`/`$45A1`/`$462F` and written back (both copies) by `$43F9` | C |
| `$D581` | 1 | `gameface_present` | u8 0/1 | writers 02:506A (02:5071) / 02:508C (02:5093): `ld a,[$B0D1]; ld [$D581],a`; readers Bank005_State00 (05:403E), 06:487A (06:48D8), 06:4935 (06:497C); pointer loads 00:16AE, 05:6263, 07:693A | Copy of settings byte SRAM `$B0D1` (flat `$010D1`, Game Face present flag; README §3.4), taken before the Game Face image is copied to `$C000`. If non-zero the screens also copy `$B1FC...` (Game Face tiles) to `$C000` (506A: $0E00 bytes; 508C: 4 x $380) | C |
| `$D582` | 1 | `coro_flag` | u8 0/1 | writers 08:725E ($00) / 08:72B9 ($01) in mode $19 init (08:723E), result of the tag test `08:72E0`; readers 04:596D (twice), 08:52DB | 1 when at least 2 of the 3 bytes SRAM bank 0 `$BFFD-$BFFF` equal the ROM constant `56 56 53` (08:7319; the same routine then rewrites the 3 bytes, i.e. it self-repairs the tag), else 0. Effects: album category list (04:59B1-59CD) skips index 3 unless d582 == 1; the bank-8 paged screen at 08:52DB has 8 pages instead of 6 (see `$D5FF`). SRAM mirror: CoroCoro tag flat `$01FFD-$01FFF` | C |

## $D583-$D5CD: camera / exposure / dither / calibration working set (bank 0A)

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$D583-$D586` | 4 | `dither_params[4]` | u8[4] | Cam_BuildDitherMatrix 0a:42EB-42F8 (write through DE), reads 0a:4306-4507 | 4-byte row copied from table `0a:7C20` (if B == d588, or B == 8, or default) or `0a:7C60` (if B == d589); row = register C - 1 (4 bytes per row; C = d59b). d583 = base ('black'), d584 = top, `swap(d584-d583)` = ramp step, d585 = third byte (flat mode pattern and ramp parameter), d586 = fourth byte (only read at 43B8 and 44F7) | C |
| `$D587` | 1 | `cam_gain_sel` | u8 | Cam_MainDispatch (13 acc.), Cam_ExposureBandSelect, 0a:50AA, 06:5F8B/615E/6734 | Active REG1 gain selector: 0,1,2 during the coarse search (0a:485F, 48CE), forced to `$08` / `$0A` for the special band captures (0a:417F, 420A, 427E). Compared with d588/d589 to choose the dither table | C |
| `$D588` | 1 | `cam_gain_committed` | u8 0..3 | writer 0a:48D9 (Cam_ExposureBandSelect); readers Cam_MainDispatch, Cam_BuildDitherMatrix, Cam_Calib_BootMeasureSeq (474A, 4790) | Gain candidate that ended the coarse search (3 = fallback) | C |
| `$D589` | 1 | `cam_gain_alt` | u8 = 4 or 5 | writers 0a:48E1, 48FD, 4919, 4931; readers Cam_MainDispatch, Cam_BuildDitherMatrix, BootMeasureSeq 47C7 | `$04` when gain 0 or 1 won, `$05` when gain 2 or the fallback won. Selects the second dither table (`$7C60`) and the REG1 value used for the 3rd boot measurement. (Old README: '$04 only when candidate 0 wins' is imprecise) | C |
| `$D594` | 1 | `cam_a000_shadow` | u8 (only value ever stored: $02) | 0a:4745, 4864 (writes $02); read by Cam_ThresholdConverge / Cam_ORegister_SAR_Search / Cam_ExposureBandSelect | Shadow of REG0 `$A000` (bit 0, start, is ORed in when the capture is triggered) | C |
| `$D595` | 1 | `cam_a001_shadow` | u8 | 38 writes (Cam_FactoryMeasure1/2, Cam_MainDispatch, BootMeasureSeq) | Shadow of REG1 `$A001` (gain/edge byte, ORed with `$20`/`$E0` per band) | C |
| `$D596-$D597` | 2 | `cam_exposure_shadow` | u16 big-endian (d596 hi, d597 lo) | Cam_MainDispatch (writes 0a:407C/407F), FactoryMeasure1, BootMeasureSeq | Shadow of REG2/REG3 `$A002/$A003` = 16-bit exposure time; adjusted by the shift table at `0a:7B00` in Cam_MainDispatch | C |
| `$D598` | 1 | `cam_a004_shadow` | u8 | 59 accesses (FactoryMeasure1/2, BootMeasureSeq, MainDispatch) | Shadow of REG4 `$A004`; after a measurement `& 7` is stored in `$D5C1+n` (see below) | C |
| `$D599` | 1 | `cam_a005_shadow` | u8 | 46 accesses | Shadow of REG5 `$A005`; after a measurement `& $7F` is stored in `$D5C6+n` | C |
| `$D59A` | 1 | `cam_meter_divisor` | u8 ($54 seen) | writers 0a:4000 (entry parameter A of Cam_MainDispatch), 06:5F67, 06:615A, 0a:50EA; reader 0a:4011 | Divisor of the metering loop `0a:4018-402B`: the 16-bit measurement returned by `0a:4FBD` (DE=$A320) is divided by it by repeated subtraction (quotient capped at `$9F`) to give a level index. Old README calls it 'exposure-band index'; the code uses it as a divisor | C |
| `$D59B` | 1 | `cam_dither_row` | u8 (1-based row) | writers 06:5F6C ($08), 06:6183, 0a:50F4; readers Cam_MainDispatch (4 sites), 06:615E, 06:6254 | Row index (register C) passed to Cam_BuildDitherMatrix; row = C-1 in the 4-byte table | C |
| `$D59C` | 1 | `cam_dither_mode` | u8 | writers 06:5E47, 06:6753, 0a:50EF ($01); reader 0a:42F9 | 0 = flat fill (jp `0a:440C`), 1 = ramp A (jp `0a:4427`), else ramp B (normal photos) | C |
| `$D59D-$D5B4` | 24 | `cam_factory_raw[24]` | u8[24] = $D59D-$D5B4 | Cam_FactoryMeasure1 (one write each), Cam_FactoryMeasure2 (one read each) | 12 + 12 raw results of the factory sweep: first 12 = REG4 low bits, next 12 = O-register results (README §6); consumed once by Cam_FactoryMeasure2 to build the calibration vector. Old README §2 gave `$D5A0-$D5B4` (21 bytes); README §6 (`$D59D-$D5A8` + `$D5A9-$D5B4`) is the right extent | I |
| `$D5B5-$D5C0` | 12 | `cam_calib_vector[12]` | u8[12] | Cam_Calib_ValidityCheck (default `7E 7F 7F 7F 7E 7D 7E 7E 7D 7E 7D 6A`), Cam_CommitVectorToSRAM, ExposureBandSelect, FactoryMeasure2, BootMeasureSeq | Working copy of the 12-byte calibration vector (SRAM flat `$04FF2-$04FFD` and `$11FF2-$11FFD`, README §3.8): bytes 0-3 / 4-7 / 8-9 feed D5CB / D5CC / D5CD by winning gain; bytes 10,11 (`$D5BF`, `$D5C0`) are the two values re-measured by the hidden factory test and are also the 4th/5th measurement levels of Cam_Calib_BootMeasureSeq (0a:47ED, 4823) | C |
| `$D5C1-$D5C5` | 5 | `cam_boot_reg4[5]` | u8[5] (values 0..7) | writers Cam_Calib_BootMeasureSeq 0a:4774/47AB/47E2/4818/484C; readers Cam_MainDispatch 40D7-42A1 | `$D598 & 7` read back after the 5 boot measurements (REG4 low 3 bits found by the search at `0a:4B6A`); one entry per measurement level (D5CB, D5CC, D5CD, D5BF, D5C0). Used by Cam_MainDispatch to load REG4 per band | C |
| `$D5C6-$D5CA` | 5 | `cam_boot_reg5[5]` | u8[5] (values 0..$7F) | writers Cam_Calib_BootMeasureSeq 0a:477C/47B3/47EA/4820/4854; readers Cam_MainDispatch | `$D599 & $7F` (bit 7 cleared) after the same 5 measurements = REG5 offset found for each level. Together with `$D5C1+n` they replace the old README's 'per-band REG4/REG5 lookup `$D5C1-$D5C9`' (the range is $D5C1-$D5CA, 2 x 5 bytes, written at boot by 0a:4774-4854, not constants) | C |
| `$D5CB-$D5CD` | 3 | `cam_targets[3]` | u8[3] | writers Cam_ExposureBandSelect (4 x 3, 0a:48E7-4943); read by BootMeasureSeq 0a:4734, 477F, 47B6 | Active reference targets: copied from the vector by winning gain, `d5cb`/`d5cc`/`d5cd` <- (b0,b4,b8) if gain 0; (b1,b5,b8) gain 1; (b2,b6,b9) gain 2; (b3,b7,b9) fallback (README §6 table is correct). In BootMeasureSeq each is used as the fill value of `$A006-$A035` for a boot measurement. Old README claim 'copy of b0,b4,b8 only' is only the gain-0 row | C |

## $D5CE-$D5FF: shared UI state and per-screen cursors

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$D5CE` | 1 | `mode` | u8 $00-$21 | 83 writes in banks 3 (14), 4 (28), 5, 6 (15), 7 (14), 8 (9), 9; first write `D5CE := $19` at 00:2EA6; reads 04:7077, 04:711E, 08:4EF9 and (missing from the access table) the dispatcher `00:2F39` (`ld a,[$D5CE]; call $038A`, table `$2F3F`) | Current mode (first mode after boot = `$19`, the CoroCoro-tag check, 00:2EA4-2EAD): index into the 34-entry table at `$2F3F` (3-byte entries lo,hi,bank): 00 7:71AF, 01 4:6F96, 02 7:51AC, 03 7:53BE, 04 3:7AA8, 05 3:7BFD, 06 3:7695, 07 7:54ED, 08 9:4883, 09 4:683F, 0A 4:7488, 0B 3:78E9, 0C 3:6310, 0D 7:6B03, 0E 7:4000, 0F 4:4649, 10 4:604B, 11 4:56F9, 12 3:4000, 13 3:5FA0, 14 6:5DE6, 15 6:4000, 16 6:44D9, 17 6:4C9F, 18 6:598E, 19 8:723E, 1A 3:69F5, 1B 8:4000, 1C 8:40F8, **1D 0:3015, 1E 8:4887, 1F 5:4000, 20 5:74CC, 21 9:5FE3** (verified by reading the table bytes) | C |
| `$D5CF` | 1 | `state` | u8 | 42 reads, 395 writes (banks 3: 139, 4: 131, 7: 131, 6: 114, 5: 26, 8: 38, 9: 38); `ld a,[$D5CF]; rst $18` | State inside the mode; the dispatcher of every mode bank indexes an inline pointer table with it. States advance with `inc [hl]`, go back with `dec [hl]` (e.g. 07:5476) or are set from tables (04:70E4) | C |
| `$D5D0` | 1 | `substate` | u8 | dispatchers `ld a,[$D5D0]; rst $18` at 04:4000 (3), 07:4C08 (3), 07:699C (4), 08:4DF2 (3), 08:5191 (3), 09:4281 (4), 09:7290 (3); zeroed by 25 writes at screen entry (banks 3,4,6,7,8); `inc [hl]` by the sub-states (04:40CB, 04:40FD, ...); set to 3 at 07:69B5 and 09:43A4 | Second-level state used by the multi-phase screens of banks 4, 7, 8, 9 (phase 0 = build screen and fade in, then browse, then confirm/exit). Banks 3 and 6 only write 0 (to hand over to bank 4/7 screens cleanly) | C |
| `$D5D1` | 1 | `jitter_x` | u8 (bit 0 used) | 04:4BCA/4BD3, 04:4DF9/4E02, 04:7C6C, 06:4935, 06:5932, 06:6448, 06:6510, 07:4A8E, 08:42E3 | Random jitter bit: refreshed from the RNG `$08F9` on even frames (`$FFC8` bit 0 = 0), then `(d5d1 & 1)` is added to the X of the two sprite groups drawn with `$247D` (`$C5` at x=$50+j, `$C9` at x=$4C+(j^1) at 04:4BEC-4C07): a 1-pixel shaking of the pair of sprites (probably the big 'A はい / B いいえ' answer lettering of the confirm dialogs, cf. README §8 for the twin routine 04:4DF9; I) | C |
| `$D5D2` | 1 | `jitter_y` | u8 (bit 0 used) | same routines as D5D1 | Same, for the Y coordinate (`$6B+j`, `$30+(j^1)`) | C |
| `$D5D3` | 1 | `blink_counter` | u8 | inc at 04:6972, 04:7617, 06:6542, 07:6D44, 08:4329; zeroed at 03:4A6C | Free-running frame counter; bit 4 toggles the four corner sprites `$A2-$A5` at (x,y) = ($50,$78) ($50,$18) ($18,$48) ($88,$48) (04:697D-699A; same code in 04:7617, 06:6542, 07:6D44, 08:4329) | C |
| `$D5D5` | 1 | `page_is_stock` | u8 0/1 | 04:440B-4445 (pointer-based, only P rows) | Set to 1 by the thumbnail-page draw routine `04:440B` when the first index of the page (A & $3F) is >= $1E (stock-picture page), else 0; bounds the page to indices < $3C when set | C |
| `$D5D6` | 1 | `msg_strip_sel` | u8 $00-$0E | writers 03:6320, 03:6A1B, 04:466D, 04:4802, 04:4824, 04:49FA, 04:4A36, 04:4C28, ..., 07:43A4, 07:43B7, 08:411C; readers 04:4474, 07:4F8B | Selects the 40-tile (`$280`-byte) message strip loaded to VRAM `$8800` by `04:4474` from the 3-byte (ptr,bank) table at `04:4493` (bank `$0E`, last entry in bank `$0D`; one prompt each; e.g. 1 = 'どの写真を見ますか？' of mode $0A, 2 = erase prompt of mode $0F per README §8). Bank 7 reads it at 07:4F8B (own table, not decoded) | C |
| `$D5D7` | 1 | `icon_sel` | u8 $00-$06 | writers 03:6325, 03:6A20, 04:4671, 04:49FF, 04:5716, 04:606C, 04:6D20, 04:74B3, 04:7AC0, 07:43A9, 07:43BC, 08:4121; readers 04:44BD, 07:4FD7 | Selects the 16-tile (`$100`-byte) icon loaded to VRAM `$8B00` by `04:44BD` from the table at `04:44DC` (bank `$13`, one icon each; 2 = みる, 0 = けす per README §8) | C |
| `$D5D8` | 1 | `photo_index` | u8 (0..29 own photos, $1E+n stock) | 65 reads / 16 writes: 04:4099, 04:4243 (from D5D9), 04:4682, 04:4943, 04:6B45, 04:6C72, 04:6D11, 04:77EA, 04:79DB, 04:7AB1, 07:4700, 07:4C8E, 07:4E1F; P at 04:5117 | Index of the photo currently selected/shown in the album screens (cursor on the thumbnail grid and photo viewer); copied to `D5ED`, `D5F3`, `D5F6-D5F9`, `D5FB`, `D671` and passed in `$FF9E` to bank 2 loaders (`02:5110`, `02:4DD7`, `02:4E31`, `02:4C80`). Reset to 0 when it holds a stock index and `D5DB` = 0 (04:4093-4099, 04:467A-4682); also 0 at start (00:2EAD) and when `D561 == 0` before the main loop (00:2F23-2F2A) | C |
| `$D5D9` | 1 | `neighbor_or_page_target` | u8 ($FF = none; bit 7 = page flip) | 04:41CD-41E8 (write), 04:4234-4243, 07:4DC0 (own copy); reads in cursor-movement routines 04:4561-45CF, 07:506F/50E3 | Two uses. (1) Target photo index of a cursor step: `table[04:4281 + 4*(D5D8&$3F) + dir-1]`, $FF = no neighbour; an index >= $1E is accepted only if `D5DB` != 0 and `idx-$1E < d562` (04:41CD-4201). (2) Page-flip target written at 04:4992 / 04:49B1 / 04:49D0 from `D5D8 & $F8` (previous page: `((D5D8&$F8)-8)\|1\|$80`; other variants `\|2`, clamped below $20) and consumed as page start by 04:4561 (`call $452C`, `call $440B`) and 04:45CF/04:4626. Exact encoding of the low bits: ? | I |
| `$D5DA` | 1 | `cursor_sprite_var` | u8 ($00,$01,$0F,$10,$11) | 04:40AF, 04:40B6, 04:41B4 (read), 07:4DA7 (read), 04:4FA6; 37 writes | Sprite-group id of the selection cursor = D5DA + `$0F` (`$24AF`), drawn at the thumbnail cell given by `D5D8 & 7` (table `04:41BD`, (x,y) in hex: ($48,$18) ($70,$18) ($20,$40) ($48,$40) ($70,$40) ($20,$68) ($48,$68) ($70,$68)) | C |
| `$D5DB` | 1 | `stock_nav_allowed` | u8 0/1 | writers 03:632C, 03:6A27, 04:4677, 04:4A02, 04:4A3D, 04:571D, 04:6076, 04:74BC (=1), 08:4136 (=1); readers 04:4093, 04:41F1 | 1 when the current screen may navigate to stock pictures (`$1E+`): set by 04:74AC (mode $0A) and 08:411A; cleared by the other entries | C |
| `$D5DC` | 1 | `scroll_wobble_phase` | u8 0..15 | 04:4161-416F (read/modify), writers 04:4024, 04:469F, 04:474A | Phase of a 16-step table `04:417D` of (SCX, SCY) pairs written to shadows `$FFAE/$FFAD`, advanced every second frame (`$FFC8` bit 1): small screen wobble in the album screens | C |
| `$D5DF` | 1 | `ab_result` | u8: 1 = A, 2 = B (0 = none) | 66 writes / 43 reads in 6 banks; typical writer `ldh a,[$FFA2]; and 3; ret z; cp 3 -> 1; ld [$D5DF],a` (e.g. 04:40D2-40DE, 04:700C, 07:5246) | Latch of the button that answered a confirm/choice state: newly pressed A -> 1, B -> 2 (A+B -> 1; a few writers store the constant directly: 04:4C6E, 07:4D0B = 2). The next state tests bit 0 (A, 'yes/forward') versus else ('no/back', e.g. 04:410D, 04:704F, 07:5260, 03:7CA4). The reading 'last input shadow' is thus precise: it holds the A/B edge only | C |
| `$D5E0` | 1 | `mode1_cursor_a` | u8 0..4 | 04:6FF0 (via 04:720D, DE=$D5E0), 04:70A8, 04:702D, 04:7063 (read) | (`$D5E0-$D600` are cleared once at start by 00:2EB0-2EB5, so every UI byte below starts at 0.) 5-position cursor of mode 1 (04:6F96): generic cursor helper `04:720D` (DE = cursor byte, HL = table of (button mask, new index) pairs `04:724F`; plays the move sound) moves it; positions `04:7023` = 3 items left column + 2 items right column, sprite `$DC` (`$DF` in the second state); the confirm table `04:7084` maps index -> (mode,state) | C |
| `$D5E1` | 1 | `mode1_cursor_b` | u8 0..? | 04:714F (via 04:720D, table `04:7271`, positions `04:7182`) | Cursor of another menu of mode 1 (same helper, sprite `$DF`) | C |
| `$D5E3` | 1 | `opt_menu_cursor` | u8 0..3 | 06:4607 (helper `06:4ABC`, max 3), 06:4612, 06:462B, 06:4945, 06:4AF8, 06:4B39 | Vertical cursor (4 items) of the bank-6 option menu = mode $16 (06:44D9); `06:4659` gives the target state per item (a value >= $22 plays the 'not available' sound `$0B`); on exit (06:4935) selects which of D5E5/D5E7/D5E9 forms the result stored in `D7E3` (3+d5e5, $0C+d5e7, $13+(d5e9^1), else $15) | C |
| `$D5E4` | 1 | `opt1_row` | u8 (always 0) | 06:4665-46B4: `ld hl,$D5E4; ld c,0; call 06:4ABC` | Row cursor whose maximum is passed as 0 (`06:466B`), so it can never leave 0; the branches for a non-zero row are unreachable | U |
| `$D5E5` | 1 | `opt1_value` | u8 0..8 | 06:4676 (helper `06:4ADA`, C=8), 06:4553, 06:45D6, 06:467E, 06:4693, 06:494B | Horizontal value of option sub-screen 1 (9 choices); left/right changes it; selects the tile image at VRAM `$9300` from table `06:46EF`; becomes `D7E3 = 3 + d5e5` on exit (06:494B) | C |
| `$D5E6` | 1 | `opt2_row` | u8 (always 0) | 06:470A-4750 (`ld c,0` at 06:4710) | Same as D5E4 for sub-screen 2 | U |
| `$D5E7` | 1 | `opt2_value` | u8 0..6 | 06:471B (C=6), 06:455F, 06:45E2, 06:4723, 06:4956 | Horizontal value of sub-screen 2 (7 choices); tile image at `$9400` from `06:478F`; `D7E3 = $0C + d5e7` on exit | C |
| `$D5E8` | 1 | `opt3_cursor` | u8 0..1 | 06:47A7 (helper `06:4ABC`, C=1), 06:47AF, 06:47D7, 06:4852 | Row cursor (2 rows) of sub-screen 3; selects which of the toggles D5E9 / D5EA is edited (`ld hl,$D5E9; add hl,bc`) | C |
| `$D5E9` | 1 | `opt3_toggle_a` | u8 0/1 | 06:47B5 (via `06:4ADA`), 06:4833, 06:4858, 06:4961 | Toggle 0/1 shown with sprite `$35`/`$36` (06:4833); on exit `D7E3 = $13 + (d5e9 ^ 1)` | C |
| `$D5EA` | 1 | `opt3_toggle_b` | u8 0/1 | read at 06:4840, 06:599A, 06:59E3, 06:5A16, 06:5AE0, 06:5B1B, 06:5CB2, 06:5CB4, 06:5CE1 (written only through `D5E9+D5E8`) | Second toggle, edited through the pointer arithmetic of D5E8 (hence no direct write in the access table); also read by later bank-6 states (06:599A-5CE1): which setting this is: ? | C |
| `$D5EB` | 1 | `opt4_cursor` | u8 0..2 | 06:487A (C=1, or 2 while Select is held: `$FFA1` bit 2), 06:488A, 06:48A0 | Vertical cursor of a further bank-6 option screen; 0 -> state 8 (06:48A6) | C |
| `$D5EC` | 1 | `yesno_h` | u8 0/1 | 07:52E7-5304 (write via HL), 07:5260-5282, 07:531B, 07:5348, 07:5369 | Horizontal 2-way choice (left = 0, right = 1) of mode 2 (07:51AC): table `07:52E5` = ($0A, $0B): confirm with A goes to mode `$0A` (4:7488) or `$0B` (3:78E9); B / D5DF != A goes back to mode 0. Also writes `D679` from Up/Down | C |
| `$D5ED` | 1 | `copy_photo_idx_a` | u8 | write 04:753F (mode $0A state 2); reads 04:754C, 04:759F, 04:75B1, 04:75F5, 04:77E7, 04:79D8, 04:7AAE, 04:7B44-7CF7 | Copy of D5D8 made at the init of mode $0A (04:7488); passed in `$FF9E` to the photo display `02:5110` and `02:4E31`. On 'A = yes' 04:77E7-77EA / 04:7AAE-7AB1 write D5D8 := D5ED, then D5DF := 1, D5D6 := 2, D5D7 := 0, mode := $0F, state := 5 (04:7AC8) = README §8 route to the erase viewer | C |
| `$D5EE` | 1 | `photo_number_sel` | u8 0..29 | writers 04:6E9C, 04:6F4E (mode $09 slider), 04:7060 and 04:7107 (mode 1: `D561-1` or 0); reads 04:68D4-6F5C | 0-based photo number chosen with Left/Right in mode $09 (04:683F): `D67C = 2*D5EE` is the slider target, `D67D` steps toward it, `D5EE = D67D>>1` when it arrives; shown as `D5EE+1` in two digits (04:6F5C). Mode 1 presets it to the last photo (`D561-1`, 0 if empty) before entering mode 9. On 'A = yes' D5D8 := D5EE (04:6D0E-6D11, 04:6C6F-6C72) and, at 04:6D28, mode := $0F, state := 5 with D5D6 := 2, D5D7 := 0 (README §8 route) | C |
| `$D5EF` | 1 | `reg_cursor_a` | u8 0..2 | 03:7A2F (vertical, Up/Down via `$FFA3`), 03:7987, 03:79E3, 03:7A63, 03:7A85 | 3-item vertical cursor of bank-3 mode 4 (03:7AA8); `03:7A5E` resets animation frame `D500` to 2 on a move. Which screen: ? (registration keyboard family) | I |
| `$D5F0` | 1 | `reg_cursor_b` | u8 0..1 | 03:7BAB (Up/Right = dec, Down/Left = inc), 03:7B5B, 03:7BA2, 03:7BE5 | 2-item cursor of bank-3 mode 5 (03:7BFD); writes `$D7C0 = $20` on a move. Which screen: ? | I |
| `$D5F1` | 1 | `reg_cursor_c` | u8 0..1 | 03:7DB1 (same scheme), 03:7C07, 03:7C71, 03:7CA4/7CBC, 03:7CDE | 2-item cursor of another bank-3 mode-5 state; `03:7D17` maps it to the next mode (a value >= $22 = 'not available' sound `$0B`, state decremented) | I |
| `$D5F2` | 1 | `reg_cursor_d` | u8 | 03:769F-7745 (mode 6), 03:77E1, 03:783B, 03:7844-7873, 03:789C, 03:78C3 | Cursor-like index of bank-3 mode 6 (03:7695) / mode $0B region; read 6 times, written 3 times (03:7734, 03:773B, 03:7873). Range and screen not established | ? |
| `$D5F3` | 1 | `copy_photo_idx_b` | u8 | write 08:4215, reads 08:4224, 08:4257, 08:460A, 08:4656, 08:46A7, 08:47A3, 08:4818 | Copy of D5D8 at the init of the bank-8 print screen (08:4149, 08:45E0, 08:47ED); passed in `$FF9E` to `02:4E31` | C |
| `$D5F5` | 1 | `saved_dc52` | u8 | write 07:418D (`ld a,[$DC52]`), reads 07:413E-4231, 07:439C, 07:43DE, 07:4570, 07:4606, 07:470D, 07:48AA, 07:516A | Copy of `$DC52` taken in bank-7 state 1; when non-zero sets bit 7 of `$DC55` (07:4141-414C) and selects the 'store as new photo' branch of states 9 and 17 (README §3.3 `F12-F14`) | I |
| `$D5F6` | 1 | `copy_photo_idx_c` | u8 | 04:4B4B (copy of D5D8), reads 04:4B4B-4BBF | Copy of D5D8 in Bank004_State05; passed in `$FF9E` to far calls `02:5110`, `02:4DD7`, `02:4E31` | C |
| `$D5F7` | 1 | `copy_photo_idx_d` | u8 | 04:57D6 (only if `D800 == 0`), read 04:5D28 | Copy of D5D8; stored into `D671` at 04:5D28 | C |
| `$D5F8` | 1 | `copy_photo_idx_e` | u8 | 03:6AD9 (write), reads 03:6AEA, 03:6F97 | Copy of D5D8 in bank 3 (03:6A19) | C |
| `$D5F9` | 1 | `copy_photo_idx_f` | u8 | 04:611A (only if `D800 == 0`), read 04:63C9 | Copy of D5D8; stored into `D671` at 04:63C9 | C |
| `$D5FA` | 1 | `yesno_h8` | u8 0/1 | 08:40B3 (draw), 08:40DC (Left = 0 / Right = 1 from `$FFA2`), Bank008_State02 | 2-way horizontal choice cursor of bank 8: sprite `$F6` at (x,y) = ($08,$30) or ($39,$30) from table `08:40D8`, nudged +-2 pixels by Up/Down | C |
| `$D5FB` | 1 | `photo_arg_b3` | u8 | writers 03:63D4 (= D5D8), 03:6534 (= `D65C[bc]`); readers 03:63FD, 03:6460, 03:646D, 03:6731, 03:676C, 03:67AB | Photo index kept across the bank-3 loader calls: passed in `$FF9E` to `02:4C80` / `02:4DD7`. Code lies after the entry of mode $0C (03:6310); which screen: ? | I |
| `$D5FC` | 1 | `slideshow_idx` | u8 | 07:7037-70A0, 07:7138-717E (writers 07:7075, 07:7084, 07:715C) | Photo index shown by the bank-7 slideshow-like routine: if `D7D3 == 0` a random value in [0, D561) from `00:09D4` (via `$08F9`), else `D5FC += D7D6` (+1/-1, wrapped into 0..D561-1); passed in `$FF9E` to `02:5110` (display) and `02:4E5F` when `D7D2 != 0`. With D561 = 0 the state jumps to state 9 (07:703D) | C |
| `$D5FD` | 1 | `choice4_cursor` | u8 0..3 | 09:5198 (Left/Right via `$FFA3`, plays sound $38), 09:526D (draw), Bank009_State00 (09:4938), Bank009_State02 (09:499A) | 4-way horizontal cursor of bank 9 (mode $08, 09:4883): sprite group `$6F/$6F/$6F/$71 + blink` at the positions of table `09:5293`; State02 uses `09:49CB[d5fd]` as the next `D5CF`; choice 0 takes a different branch at 09:51BB | C |
| `$D5FE` | 1 | `yesno_v7` | u8 0/1 | 07:5497 (Up/Down via `$FFA3`, sound $38), 07:544C, 07:54B8 | 2-way vertical choice of mode 7 (07:54ED): `07:5495` = ($1A, $17) gives the next mode (mode `$1A` or `$17`); without A (`D5DF` bit 0 clear) returns to mode 0 | C |
| `$D5FF` | 1 | `page_index_8` | u8 0..5 (0..7 if D582 = 1) | 08:52A0 (draw `D5FF+1` as two digits), 08:52DB (Left/Right via `$FFA3`, wrap at 6 or 8), 08:5315 / 08:5365 (write + 10-step slide), 08:53BC-5481 | Page number of a paged bank-8 screen: 6 pages, 8 when the CoroCoro flag `D582` is set (08:52E0-52E7); a 10-step transition slides to the new page. Which screen it is: ? | C |

## Notes per overlay / mechanism

**`$D500-$D51F` sprite-animation pairs.** Slot n has a frame byte at `$D500+n` and a tick byte at `$D510+n`. A per-frame routine draws the sprite group of the current frame, increments the tick, and when the tick equals the duration stored with the frame in a ROM table it advances the frame and zeroes the tick (verified for the `$D50F/$D51F` pair at `04:7832-786E`; the other pairs use the same pattern, e.g. `03:649B`, `03:7117`, `03:7162`, `03:7774`, `07:55BA`, `07:620F`, `04:72E3`). `00:100B` clears the whole 32-byte area (callers `03:6371`, `07:558F`); other screens zero individual slots on entry. Which sprite each slot drives is only inferred (bank 3: cursor blink, sprite loops and two-actor scripts of the registration screens; bank 7: frame/stamp screens; bank 8: print animation, frame 0..4; bank 4: mode-1 cursor and the pointer-arrow `$D50F`). `$D509`, `$D50A`, `$D50E`, `$D516`, `$D51E` do not appear in the access table; `$D506` has no tick partner.

**`$D520-$D529` and the table.** Not a sound sequencer. The sound engine is bank `$1F` with its own state in `$DC00-$DC5E` and `$D9xx` (other regions). `$D520/$D521` are the write/read indices of the VBlank VRAM-transfer queue; the queue has only two writers (`08:4EE9`, `08:5290`), so most screens upload through direct copies (`$0450`, `$05F8`, `$0721`) instead. `$D524-$D526` are loaded with the constants of the next screen and faded in by `00:0D18`.

**Camera chain (bank 0A), partial answer to README §6 'how are the 12 bytes used'.** (1) Factory sweep `Cam_FactoryMeasure1` fills `$D59D-$D5B4` (12 REG4-bit results, 12 O-register results); `Cam_FactoryMeasure2` turns them into the 12-byte vector `$D5B5-$D5C0`, which `Cam_CommitVectorToSRAM` writes to SRAM (`$AFF2` bank 2 and `$BFF2` bank 8). (2) At normal start `Cam_Calib_ValidityCheck` loads the vector from SRAM, or the default `7E 7F 7F 7F 7E 7D 7E 7E 7D 7E 7D 6A`, into `$D5B5-$D5C0`. (3) Unless both SRAM copies are blank (`Cam_Calib_Loader`, see Corrections 11), `Cam_Calib_BootMeasureSeq` (`0a:4724`) first calls `Cam_ExposureBandSelect` (`0a:4859`), which tries gains 0, 1, 2 (`$D587`), stores the winner in `$D588`, sets `$D589` (4 or 5) and copies three vector bytes into `$D5CB-$D5CD`; it then fills the sensor array `$A006-$A035` with each of five reference levels (`$D5CB`, `$D5CC`, `$D5CD`, `$D5BF`, `$D5C0`) in turn, runs the register search `0a:4B6A` and records REG4 & 7 in `$D5C1-$D5C5` and REG5 & $7F in `$D5C6-$D5CA`. (4) `Cam_MainDispatch` (auto-exposure step; A = `$D59A`) reads `$D5C1-$D5CA` and `$D587-$D589` per band, builds the dither matrix with `Cam_BuildDitherMatrix` (`$D583-$D586` from `0a:7C20`/`0a:7C60`) and updates `$D596/$D597` from the shift table `0a:7B00`.

**Photo-index family.** `$D5D8` is the album's current photo index (0..29, `$1E+n` stock pictures when `$D5DB` != 0). Bank-local copies: `$D5ED` (mode `$0A`), `$D5EE` (mode `$09` slider), `$D5F3` (print, bank 8), `$D5F6` (04 State05), `$D5F7`, `$D5F9` (via `$D671`), `$D5F8` (bank 3), `$D5FB` (bank 3), `$D5FC` (bank 7 random/slideshow). They are passed in `$FF9E` to bank-2 routines (`$5110` draw, `$4DD7`, `$4E31`, `$4C80`, `$4E5F`). Modes `$09` and `$0A` on 'A = yes' write `D5D8 := D5ED/D5EE`, `D5DF := 1`, `D5D6 := 2`, `D5D7 := 0`, `D5CE := $0F`, `D5CF := 5` (`04:6D28`, `04:7AC8`): this confirms the README §8 route into the erase viewer. `D5D6`/`D5D7` choose the prompt strip (`$8800`, 40 tiles) and the icon (`$8B00`, 16 tiles) of those pickers.

**`$D5D0` sub-states.** Seven dispatchers read it with `rst $18`: `04:4000` (3 sub-states `$400A` build/draw, `$40CF` browse, `$410D` confirm/exit), `07:4C08` (3), `07:699C` (4), `08:4DF2` (3), `08:5191` (3), `09:4281` (4), `09:7290` (3). Banks 3 and 6 only write 0 to it (`03:51F3`, `03:62F5`, `03:6329`, `03:6A24`, `03:6F9E`, `06:53F6`, `06:726A`).

**Bank 6 mode `$16` (option screens, `06:44D9`).** `D5E3` is the 4-item menu cursor; each item opens one of three sub-screens whose widgets are `D5E4/D5E5`, `D5E6/D5E7`, `D5E8/D5E9/D5EA`, plus a fourth screen with `D5EB`. All use two generic helpers: `06:4ABC` (vertical, HL = cursor byte, C = maximum) and `06:4ADA` (horizontal). The 'row' bytes `D5E4` and `D5E6` are called with maximum 0 so they never leave 0. On exit `06:4935` writes a selection code 3..`$15` to `D7E3` and sets mode `$14`. What the choices mean on the screen is not established (the strips are graphics in bank `$0D`).

**Bank 4 mode 1 (`04:6F96`).** `D5E0` and `D5E1` use the generic menu helper `04:720D` (DE = cursor byte, HL = table of (button mask, new index)); `04:7084` maps the chosen index to `(D5CE, D5CF)` = (`$15`,0), (`$01`,6), (`$16`,0), (`$09`,0), (`$01`,9). Selecting the `$09` entry goes through `04:7059`, which presets `D5EE := D561-1`.

**Cursor/choice bytes of other banks.** Bank 3: `D5EF` (mode 4), `D5F0`, `D5F1` (mode 5), `D5F2` (mode 6): Up/Down or Left/Right via `$FFA3`, bounded by compare constants, sound `$02` on a move. Bank 7: `D5EC` (mode 2, left/right), `D5FE` (mode 7, up/down). Bank 8: `D5FA` (2-way), `D5FF` (6-8 pages). Bank 9: `D5FD` (4-way, mode `$08`).

## `$D5CE` / `$D5CF` and the mode table

The mode table at `$2F3F` has **34** entries (`$00-$21`), not 29: entries `$1D-$21` (`0:3015`, `8:4887`, `5:4000`, `5:74CC`, `9:5FE3`) are read from the ROM bytes at `$2F3F+3*i` (the entry `$1D` lives in bank 0, which is why `tools/rom_trace.py` `mode_table()` stops there). With those five roots **and the main loop `00:2E92`** traced (see below), 122 more accesses to `$D5xx` appear (banks 0: 29, 5: 38, 8: 24, 9: 31): `D523` (1 W), `D524-D526` (8 W each), `D561` (1 R, 1 P), `D581` (2 R, 2 P), `D5CE` (8 W, 2 R), `D5CF` (31 W, 33 P, 4 R), `D5D0` (1 W), `D5D8` (2 W), `D5DF` (6 W, 3 R), `D5E0` (1 P). All fall on addresses already in the summary, so no row is added; the counts in the appendix are low by those amounts.

**Main loop (`00:2E92-2F37`) is missing from `trace_jp.json`.** `00:020D` and `00:02A0` do `ld a,$00; ld hl,$2E92; call $08BB`; `$08BB` is a far-*jump* helper (`ldh [$FF9B],a; ld [$2000],a; jp hl`) that the tracer does not resolve (it only knows `call $08C1`), so the prologue and the loop were never decoded. The prologue (only the part touching this page): self-test far call (`call $08C1`, bank 0A `$6A52`) at 00:2EA1; `D5CE := $19`, `D5CF := 0`, `D5D8 := 0` (00:2EA4-2EAD); clear of `$D5E0-$D600` (33 bytes, 00:2EB0-2EB5); other WRAM inits; `D523 := 1` (00:2F20); `D5D8 := 0` if `D561 == 0` (00:2F23-2F2A); then the loop `00:2F2D`: `call $2F39` (mode dispatch), `call $08A4` (OAM tail clear), `call $0A82`, `rst $08`, `jr $2F2D`. Seeding the root `(0, $2E92)` in the tracer fixes this.

## Settings block and WRAM

The 217-byte settings block (SRAM bank 0 `$B000-$B0D8`, flat `$01000`) has **no flat WRAM image**. Bank 2 moves it field by field: `$B000-$B02F` <- `$D681-$D6B0`, `$B030-$B05E` <- `$D6B2-$D6E0` (47 bytes each, `02:4A19-4A3C`), `$B05F/$B060` <- `$D6E2/$D6E3`, `$B061...` <- sound editor shadows `$D93D...` (`02:4A7D-`), `$B0BB-$B0D0` <-> `$DA96-$DAAB` (22 bytes, `02:5043`), owner block `$AFB8...` -> `$DA49-$DA5A` (`02:5054`). The only byte of it in `$D500-$D5FF` is `$D581` (= `$B0D1`, Game Face present). The `$D6xx`, `$D9xx` and `$DAxx` region files cover the other pieces; the table above is from a short look at those bank-2 routines (not a full audit).

## SRAM cross-references for this page

| WRAM | SRAM | Relation |
|---|---|---|
| `$D52A-$D560` | flat `$02FFF` (boot counter, README §3.8) | seed of the table at boot (`00:091A`); the new draw is written back by `00:096D` |
| `$D561`, `$D563-$D580` | state vector flat `$011B2-$011D6` (+ echo `$011D7`) | `$4466` loads, renumbers, counts; `$43F9` writes back both copies |
| `$D562`, `$D582` | CoroCoro tag flat `$01FFD-$01FFF` = `56 56 53` | `08:72E0`: >= 2 of 3 bytes match -> `D582 = 1`, `D562 = $1E`; the routine also rewrites the three bytes |
| `$D581` | settings flat `$010D1` | direct copy (`02:506A`, `02:508C`) |
| `$D5B5-$D5C0` | calibration record flat `$04FF2-$04FFD` (+ `$11FF2-$11FFD`) | loader/commit `Cam_Calib_ValidityCheck` / `Cam_CommitVectorToSRAM` |
| `$D5D8` and the copies | photo number / slot | argument of bank-2 loaders; a photo is stored with `02:462F` (see `$D5F5`) |

## Corrections to the previous README

1. **§2 `$D520-$D530ish` 'sound/sequencer area' is wrong.** `$D520/$D521` = VRAM transfer queue indices, `$D522` unused, `$D523` = soft-reset enable (never set), `$D524-$D526` = palette targets, `$D527-$D529` = RNG state, `$D52A-$D560` = the 55-byte RNG table (it ends at `$D560`, 55 bytes, not `$D55F`).
2. **Mode count.** 34 modes (`$00-$21`); the first-round count of 29 and the first-round README's `$00-$19` are both short. `tools/rom_trace.py mode_table()` stops at `$1D` (entry in bank 0): add roots `0:3015`, `8:4887`, `5:4000`, `5:74CC`, `9:5FE3` and the main loop `0:2E92` (target of the far-jump helper `call $08BB`, which the tracer does not follow): 122 `$D5xx` accesses (and about 4450 instructions in all) are absent from `wram_access.csv`.
3. **`$D589`**: `4` when gain 0 **or 1** wins, `5` when gain 2 or the fallback wins (`0a:48DF/48FB/4917/4931`), not only 'set to 4 when candidate 0 wins'.
4. **`$D59A`**: not an 'exposure-band index'; it is the divisor of the metering loop `0a:4018-402B` (value `$54` seen). **`$D59B`** is a 1-based row (`C-1` is used).
5. **§2 `$D5A0-$D5B4` '21 single-use scratch bytes'**: the run is `$D59D-$D5B4` (24 bytes; §6 already says so) and holds the factory sweep results (12 + 12: first writes at `0a:49A1`/`0a:49A9`, last at `0a:4B5E`/`0a:4B66`), consumed once by `Cam_FactoryMeasure2` (`0a:4C8D-4E30`).
6. **`$D5C1-$D5C9` 'per-band REG4/REG5 lookup values'**: the range is `$D5C1-$D5CA`; they are **not constants** but the 2 x 5 measurement results written by `Cam_Calib_BootMeasureSeq` (`REG4 & 7` in `$D5C1-$D5C5`, `REG5 & $7F` in `$D5C6-$D5CA`).
7. **`$D5CB-$D5CD` 'copy of `$D5B5,$D5B9,$D5BD`'** (§2) is incomplete: it is only the gain-0 row; the full four-row table in README §6 is correct (`0a:48DF-4943`). They are also fill levels for the boot measurement.
8. **`$D5BF/$D5C0`**: besides the factory-test role (README §6/§8) they are the 4th and 5th reference levels of `Cam_Calib_BootMeasureSeq` (`0a:47ED`, `0a:4823`).
9. **§2 describes `$D5CE` as a 'cross-bank flag, likely screen transition'**: it is the mode (the later §8 text and the code agree). **`$D5DF` 'last input shadow'** holds only the A/B edge of a confirm state (1 = A, 2 = B).
10. **`$D5D6/$D5D7`** are the prompt-strip and icon selectors (not 'scratch'); **`$D5D8`** is the album photo index; **`$D5ED/$D5EE`** are bank-local copies/selections (README §8 route verified at `04:6D28`, `04:7AC8`).
11. **README §6 'If either copy is all-`$AA`, [the loader] returns immediately'** is imprecise. `Cam_Calib_Loader` (`0a:46FD-4723`) tests the primary first (`0a:4705-470E`): if **any** of its 12 bytes is not `$AA` it falls straight into `Cam_Calib_BootMeasureSeq` (`0a:4724`) without looking at the echo; only if the primary is all-`$AA` is the echo tested (`0a:4715-471F`), and only if **both** are all-`$AA` does it return `A = $FF` without measuring (then `$D5C1-$D5CD` are never written). So the skip needs both copies blank, not either.

## Still inconclusive

- **Per-slot identity of `$D500-$D51F`** (which sprite each slot drives) and of `$D50F/$D51F` (which arrow); `$D506` role (consts `$75/$76`, 3 accesses).
- **`$D5EA`** (second toggle of the bank-6 option screen, also read at `06:599A-5CE1`), the on-screen meaning of `D5E3-D5EB` choices, and `D5FF` (6/8-page screen of bank 8): known only mechanically.
- **`$D5EF-$D5F2`** (bank 3 cursors): which registration/menu screens they belong to; `$D5F2` range and writers (`03:7734`, `03:773B`, `03:7873`).
- **`$D5D9`** page-flip encoding (low bits), **`$D5FB`** (bank 3), **`$D5FC`** which screen (bank 7 `07:7037/7138`).
- **`$D5D6` / `$D5D7` bank-7 tables** (`07:4F8B`, `07:4FD7`) not decoded.
- **`$D5F5`**: README §3.3 attributes states 9/17 to a link-cable receive path; the WRAM copy itself (`$DC52`) is another region's.


## Appendix: every address of the page, with access counts (r / w / ptr-loads) from `wram_summary.csv`

Counts are of proven instructions only; accesses through `HL/DE` after a pointer load appear as ptr-loads. Row = the table row that explains the address.

| Address | r | w | p | banks | Row |
|---|---|---|---|---|---|
| `$D500` | 32 | 29 | 9 | 00:1 03:30 04:10 07:14 08:15 | `sprite_anim_frame[15]` |
| `$D501` | 2 | 7 | 6 | 03:11 04:4 | `sprite_anim_frame[15]` |
| `$D502` | 10 | 8 | 11 | 03:5 07:24 | `sprite_anim_frame[15]` |
| `$D503` | 3 | 4 | 0 | 03:5 07:2 | `sprite_anim_frame[15]` |
| `$D504` | 5 | 4 | 0 | 03:7 07:2 | `sprite_anim_frame[15]` |
| `$D505` | 2 | 3 | 0 | 03:5 | `sprite_anim_frame[15]` |
| `$D506` | 1 | 2 | 0 | 03:3 | `sprite_anim_frame[15]` |
| `$D507` | 0 | 4 | 4 | 03:8 | `sprite_anim_frame[15]` |
| `$D508` | 0 | 3 | 0 | 03:3 | `sprite_anim_frame[15]` |
| `$D50B` | 0 | 2 | 0 | 03:2 | `sprite_anim_frame[15]` |
| `$D50C` | 0 | 1 | 0 | 03:1 | `sprite_anim_frame[15]` |
| `$D50D` | 2 | 1 | 1 | 03:4 | `sprite_anim_frame[15]` |
| `$D50F` | 43 | 5 | 26 | 04:34 06:21 07:13 08:6 | `arrow_anim_frame` |
| `$D510` | 10 | 26 | 8 | 03:25 04:7 07:5 08:7 | `sprite_anim_tick[15]` |
| `$D511` | 1 | 7 | 5 | 03:10 04:3 | `sprite_anim_tick[15]` |
| `$D512` | 3 | 7 | 12 | 03:6 07:16 | `sprite_anim_tick[15]` |
| `$D513` | 2 | 4 | 0 | 03:6 | `sprite_anim_tick[15]` |
| `$D514` | 4 | 5 | 0 | 03:9 | `sprite_anim_tick[15]` |
| `$D515` | 2 | 4 | 0 | 03:6 | `sprite_anim_tick[15]` |
| `$D517` | 0 | 4 | 3 | 03:7 | `sprite_anim_tick[15]` |
| `$D518` | 0 | 3 | 0 | 03:3 | `sprite_anim_tick[15]` |
| `$D519` | 3 | 3 | 0 | 03:6 | `sprite_anim_tick[15]` |
| `$D51A` | 4 | 4 | 0 | 03:8 | `sprite_anim_tick[15]` |
| `$D51B` | 0 | 2 | 0 | 03:2 | `sprite_anim_tick[15]` |
| `$D51C` | 0 | 1 | 0 | 03:1 | `sprite_anim_tick[15]` |
| `$D51D` | 1 | 3 | 0 | 03:4 | `sprite_anim_tick[15]` |
| `$D51F` | 11 | 16 | 11 | 04:14 06:13 07:7 08:4 | `arrow_anim_tick` |
| `$D520` | 2 | 3 | 1 | 00:6 | `vq_write_idx` |
| `$D521` | 0 | 3 | 1 | 00:4 | `vq_read_idx` |
| `$D522` | 0 | 2 | 0 | 00:2 | `unused_d522` |
| `$D523` | 1 | 2 | 0 | 00:3 | `soft_reset_enable` |
| `$D524` | 1 | 64 | 3 | 00:4 03:12 04:10 05:3 06:8 07:10 08:6 09:13 0a:2 | `palette_target[3]` |
| `$D525` | 0 | 59 | 0 | 03:12 04:8 05:3 06:8 07:10 08:4 09:12 0a:2 | `palette_target[3]` |
| `$D526` | 0 | 62 | 0 | 03:12 04:8 05:3 06:11 07:10 08:4 09:12 0a:2 | `palette_target[3]` |
| `$D527` | 1 | 2 | 0 | 00:3 | `rng_seed_tmp` |
| `$D528` | 2 | 2 | 0 | 00:4 | `rng_modulus` |
| `$D529` | 1 | 1 | 0 | 00:2 | `rng_index` |
| `$D52A` | 0 | 0 | 4 | 00:4 | `rng_table[55]` |
| `$D542` | 0 | 0 | 1 | 00:1 | `rng_table[55]` |
| `$D549` | 0 | 0 | 1 | 00:1 | `rng_table[55]` |
| `$D560` | 0 | 1 | 0 | 00:1 | `rng_table[55]` |
| `$D561` | 30 | 1 | 15 | 02:10 03:6 04:13 06:11 07:6 | `photo_count` |
| `$D562` | 3 | 2 | 2 | 03:1 04:1 06:3 08:2 | `stock_picture_count` |
| `$D563` | 0 | 0 | 8 | 00:1 02:7 | `photo_vector_ram[30]` |
| `$D581` | 3 | 2 | 3 | 00:1 02:2 05:2 06:2 07:1 | `gameface_present` |
| `$D582` | 3 | 2 | 0 | 04:2 08:3 | `coro_flag` |
| `$D583` | 5 | 0 | 1 | 0a:6 | `dither_params[4]` |
| `$D584` | 7 | 0 | 0 | 0a:7 | `dither_params[4]` |
| `$D585` | 7 | 0 | 0 | 0a:7 | `dither_params[4]` |
| `$D586` | 2 | 0 | 0 | 0a:2 | `dither_params[4]` |
| `$D587` | 12 | 11 | 0 | 06:3 0a:20 | `cam_gain_sel` |
| `$D588` | 6 | 1 | 0 | 0a:7 | `cam_gain_committed` |
| `$D589` | 6 | 4 | 0 | 0a:10 | `cam_gain_alt` |
| `$D594` | 11 | 5 | 0 | 06:2 0a:14 | `cam_a000_shadow` |
| `$D595` | 1 | 38 | 0 | 0a:39 | `cam_a001_shadow` |
| `$D596` | 2 | 17 | 0 | 0a:19 | `cam_exposure_shadow` |
| `$D597` | 2 | 18 | 0 | 0a:20 | `cam_exposure_shadow` |
| `$D598` | 19 | 40 | 0 | 0a:59 | `cam_a004_shadow` |
| `$D599` | 19 | 27 | 0 | 0a:46 | `cam_a005_shadow` |
| `$D59A` | 4 | 4 | 0 | 06:5 0a:3 | `cam_meter_divisor` |
| `$D59B` | 8 | 3 | 0 | 06:6 0a:5 | `cam_dither_row` |
| `$D59C` | 1 | 3 | 0 | 06:2 0a:2 | `cam_dither_mode` |
| `$D59D` | 1 | 1 | 0 | 0a:2 | `cam_factory_raw[24]` |
| `$D59E` | 1 | 1 | 0 | 0a:2 | `cam_factory_raw[24]` |
| `$D59F` | 1 | 1 | 0 | 0a:2 | `cam_factory_raw[24]` |
| `$D5A0` | 1 | 1 | 0 | 0a:2 | `cam_factory_raw[24]` |
| `$D5A1` | 1 | 1 | 0 | 0a:2 | `cam_factory_raw[24]` |
| `$D5A2` | 1 | 1 | 0 | 0a:2 | `cam_factory_raw[24]` |
| `$D5A3` | 1 | 1 | 0 | 0a:2 | `cam_factory_raw[24]` |
| `$D5A4` | 1 | 1 | 0 | 0a:2 | `cam_factory_raw[24]` |
| `$D5A5` | 1 | 1 | 0 | 0a:2 | `cam_factory_raw[24]` |
| `$D5A6` | 1 | 1 | 0 | 0a:2 | `cam_factory_raw[24]` |
| `$D5A7` | 1 | 1 | 0 | 0a:2 | `cam_factory_raw[24]` |
| `$D5A8` | 1 | 1 | 0 | 0a:2 | `cam_factory_raw[24]` |
| `$D5A9` | 1 | 1 | 0 | 0a:2 | `cam_factory_raw[24]` |
| `$D5AA` | 1 | 1 | 0 | 0a:2 | `cam_factory_raw[24]` |
| `$D5AB` | 1 | 1 | 0 | 0a:2 | `cam_factory_raw[24]` |
| `$D5AC` | 1 | 1 | 0 | 0a:2 | `cam_factory_raw[24]` |
| `$D5AD` | 1 | 1 | 0 | 0a:2 | `cam_factory_raw[24]` |
| `$D5AE` | 1 | 1 | 0 | 0a:2 | `cam_factory_raw[24]` |
| `$D5AF` | 1 | 1 | 0 | 0a:2 | `cam_factory_raw[24]` |
| `$D5B0` | 1 | 1 | 0 | 0a:2 | `cam_factory_raw[24]` |
| `$D5B1` | 1 | 1 | 0 | 0a:2 | `cam_factory_raw[24]` |
| `$D5B2` | 1 | 1 | 0 | 0a:2 | `cam_factory_raw[24]` |
| `$D5B3` | 1 | 1 | 0 | 0a:2 | `cam_factory_raw[24]` |
| `$D5B4` | 1 | 1 | 0 | 0a:2 | `cam_factory_raw[24]` |
| `$D5B5` | 1 | 2 | 4 | 0a:7 | `cam_calib_vector[12]` |
| `$D5B6` | 1 | 2 | 0 | 0a:3 | `cam_calib_vector[12]` |
| `$D5B7` | 1 | 2 | 0 | 0a:3 | `cam_calib_vector[12]` |
| `$D5B8` | 1 | 2 | 0 | 0a:3 | `cam_calib_vector[12]` |
| `$D5B9` | 1 | 2 | 0 | 0a:3 | `cam_calib_vector[12]` |
| `$D5BA` | 1 | 2 | 0 | 0a:3 | `cam_calib_vector[12]` |
| `$D5BB` | 1 | 2 | 0 | 0a:3 | `cam_calib_vector[12]` |
| `$D5BC` | 1 | 2 | 0 | 0a:3 | `cam_calib_vector[12]` |
| `$D5BD` | 2 | 2 | 0 | 0a:4 | `cam_calib_vector[12]` |
| `$D5BE` | 2 | 2 | 0 | 0a:4 | `cam_calib_vector[12]` |
| `$D5BF` | 3 | 2 | 0 | 0a:5 | `cam_calib_vector[12]` |
| `$D5C0` | 3 | 2 | 0 | 0a:5 | `cam_calib_vector[12]` |
| `$D5C1` | 1 | 1 | 0 | 0a:2 | `cam_boot_reg4[5]` |
| `$D5C2` | 2 | 1 | 0 | 0a:3 | `cam_boot_reg4[5]` |
| `$D5C3` | 3 | 1 | 0 | 0a:4 | `cam_boot_reg4[5]` |
| `$D5C4` | 2 | 1 | 0 | 0a:3 | `cam_boot_reg4[5]` |
| `$D5C5` | 1 | 1 | 0 | 0a:2 | `cam_boot_reg4[5]` |
| `$D5C6` | 1 | 1 | 0 | 0a:2 | `cam_boot_reg5[5]` |
| `$D5C7` | 2 | 1 | 0 | 0a:3 | `cam_boot_reg5[5]` |
| `$D5C8` | 3 | 1 | 0 | 0a:4 | `cam_boot_reg5[5]` |
| `$D5C9` | 2 | 1 | 0 | 0a:3 | `cam_boot_reg5[5]` |
| `$D5CA` | 1 | 1 | 0 | 0a:2 | `cam_boot_reg5[5]` |
| `$D5CB` | 1 | 4 | 0 | 0a:5 | `cam_targets[3]` |
| `$D5CC` | 1 | 4 | 0 | 0a:5 | `cam_targets[3]` |
| `$D5CD` | 1 | 4 | 0 | 0a:5 | `cam_targets[3]` |
| `$D5CE` | 3 | 83 | 0 | 03:14 04:30 05:1 06:15 07:14 08:10 09:2 | `mode` |
| `$D5CF` | 42 | 395 | 180 | 03:139 04:131 05:26 06:114 07:131 08:38 09:38 | `state` |
| `$D5D0` | 7 | 27 | 19 | 03:5 04:14 06:2 07:15 08:9 09:8 | `substate` |
| `$D5D1` | 16 | 9 | 0 | 04:7 06:12 07:3 08:3 | `jitter_x` |
| `$D5D2` | 16 | 9 | 0 | 04:7 06:12 07:3 08:3 | `jitter_y` |
| `$D5D3` | 5 | 6 | 1 | 03:2 04:4 06:2 07:2 08:2 | `blink_counter` |
| `$D5D5` | 0 | 0 | 2 | 04:2 | `page_is_stock` |
| `$D5D6` | 4 | 21 | 0 | 03:2 04:19 07:3 08:1 | `msg_strip_sel` |
| `$D5D7` | 2 | 13 | 0 | 03:2 04:9 07:3 08:1 | `icon_sel` |
| `$D5D8` | 65 | 16 | 1 | 03:2 04:57 07:22 08:1 | `photo_index` |
| `$D5D9` | 18 | 5 | 3 | 04:15 07:11 | `neighbor_or_page_target` |
| `$D5DA` | 3 | 37 | 3 | 04:32 07:11 | `cursor_sprite_var` |
| `$D5DB` | 2 | 9 | 0 | 03:2 04:8 08:1 | `stock_nav_allowed` |
| `$D5DC` | 1 | 4 | 0 | 04:5 | `scroll_wobble_phase` |
| `$D5DF` | 43 | 66 | 0 | 03:24 04:31 06:10 07:25 08:11 09:8 | `ab_result` |
| `$D5E0` | 2 | 0 | 2 | 04:4 | `mode1_cursor_a` |
| `$D5E1` | 1 | 0 | 1 | 04:2 | `mode1_cursor_b` |
| `$D5E3` | 7 | 0 | 1 | 06:8 | `opt_menu_cursor` |
| `$D5E4` | 3 | 0 | 1 | 06:4 | `opt1_row` |
| `$D5E5` | 5 | 0 | 1 | 06:6 | `opt1_value` |
| `$D5E6` | 3 | 0 | 1 | 06:4 | `opt2_row` |
| `$D5E7` | 5 | 0 | 1 | 06:6 | `opt2_value` |
| `$D5E8` | 4 | 0 | 1 | 06:5 | `opt3_cursor` |
| `$D5E9` | 2 | 0 | 2 | 06:4 | `opt3_toggle_a` |
| `$D5EA` | 6 | 0 | 0 | 06:6 | `opt3_toggle_b` |
| `$D5EB` | 2 | 0 | 1 | 06:3 | `opt4_cursor` |
| `$D5EC` | 5 | 0 | 1 | 07:6 | `yesno_h` |
| `$D5ED` | 12 | 1 | 0 | 04:13 | `copy_photo_idx_a` |
| `$D5EE` | 15 | 4 | 0 | 04:19 | `photo_number_sel` |
| `$D5EF` | 5 | 1 | 0 | 03:6 | `reg_cursor_a` |
| `$D5F0` | 4 | 1 | 0 | 03:5 | `reg_cursor_b` |
| `$D5F1` | 4 | 1 | 0 | 03:5 | `reg_cursor_c` |
| `$D5F2` | 6 | 3 | 0 | 03:9 | `reg_cursor_d` |
| `$D5F3` | 7 | 1 | 0 | 08:8 | `copy_photo_idx_b` |
| `$D5F5` | 12 | 1 | 1 | 07:14 | `saved_dc52` |
| `$D5F6` | 2 | 1 | 0 | 04:3 | `copy_photo_idx_c` |
| `$D5F7` | 1 | 1 | 0 | 04:2 | `copy_photo_idx_d` |
| `$D5F8` | 2 | 1 | 0 | 03:3 | `copy_photo_idx_e` |
| `$D5F9` | 1 | 1 | 0 | 04:2 | `copy_photo_idx_f` |
| `$D5FA` | 2 | 0 | 1 | 08:3 | `yesno_h8` |
| `$D5FB` | 6 | 2 | 0 | 03:8 | `photo_arg_b3` |
| `$D5FC` | 3 | 3 | 0 | 07:6 | `slideshow_idx` |
| `$D5FD` | 5 | 0 | 1 | 09:6 | `choice4_cursor` |
| `$D5FE` | 3 | 1 | 0 | 07:4 | `yesno_v7` |
| `$D5FF` | 6 | 2 | 0 | 08:8 | `page_index_8` |
