## WRAM `$DA00-$DBFF` (region `da00`)

*Status: first complete pass on the v2 tables. Coverage: all 129 addresses of this range that appear in `wram/wram_summary.csv` are covered by one of the 102 rows below (129 of 129); the bytes that never appear in the summary are listed at the end. Tags C/I/U/? as in README §2.0; "unproven code" means code that is not in `wram/trace_jp.json`.*


### 0. What this range really is

The range is **not one structure**: it is a stack of unrelated overlays plus two SRAM mirrors, a statistics block and the print engine state. Mode banks are overlays, so the same page is reused by different banks with different meanings (listed per address in the tables).

| Range | What | Bank / mode |
|---|---|---|
| `$DA00-$DA0C`, `$DBCE` | link-cable exchange screen: cable characters, transfer animation, photo-pick dialog, time-out counter | bank 7 mode `$0E` (`7:4000`) |
| `$DA0F-$DA13` | "copied" counter and marker of the album copy screen | bank 4 mode `$0F` |
| `$DA16-$DA30` | main menu cursor, icon animators, transition stamp | bank 7 mode `$00` (`7:71AF`) |
| `$DA31-$DA32` | cursor-at-edge detector of pen and stamp | bank 4 modes `$10`/`$11` |
| `$DA33-$DA43` | owner registration: decorative sprites, on-screen keyboard | bank 9 mode `$08` |
| `$DA44-$DA48` | SHOOT image-effect vector | bank 6 |
| `$DA49-$DA5A` | owner block buffer (SRAM `FB8-FC9`), 18 bytes | banks 2, 7, 9 |
| `$DA5B-$DA90` | tag-head buffer (SRAM tag offsets `F00-F35`), `$36` bytes | banks 0, 2, 9 |
| `$DA91-$DA95` | comment editor state | bank 9, 4, 8 |
| `$DA96-$DAAB` | camera statistics and game records (SRAM `10BB-10D0`), also the bonus-picture lock | banks 0, 2, 4, 5, 6, 7, 8, 9 |
| `$DAAC-$DB4C`, `$DBCD` | delete-photo scatter effect | bank 4 mode `$0F` |
| `$DB4D-$DBCA` | print engine tables and state | bank 0 mode `$1D` (+ banks 6, 8) |
| `$DBCB-$DBCF` | shared print/result flags | banks 0, 3, 4, 6, 7, 8, 9 |
| `$DBD0-$DBFE` | printer-link leftovers (write-only / dead path) | bank 0 |

Where the previous README spoke of a "bank-007 frame/stamp picker" (`$DA00-$DA42`), a "sound editor byte" at `$DA96` or "UI scratch" at `$DAA0-$DB80`, the code shows the objects above; see "Corrections".

### Method and evidence

Every row's "Used by" column is generated mechanically from `wram/wram_access.csv` (proven instructions only: W/R/P with `bank:pc`); accesses through HL/DE/BC are not in that table, so for arrays and buffers the roles were read from the code around the P rows and are named in the Meaning column. The routines were disassembled from the ROM bytes with a private SM83 disassembler that marks instructions outside the proven set (`trace_jp.json` `code`) as data. Where I had to decode bytes that are **not** in the proven set (the bank 7 menu callbacks `7:7AF1-7B43` and the transition helpers `7:7BF4-7D30`, reached only through `jp hl`), I say so in the row and tag the status I. The OAM byte order (Y, X) used to name X/Y coordinates was checked in the sprite helper `0:247D-24E4` (`C` is added to the first OAM byte, `B` to the second). Bank numbers are shown with two hex digits when auto-generated; hand-written citations use the bank number as written in the code.


### 1. `$DA00-$DA0C` and `$DBCE`: bank 7 mode `$0E` (link-cable exchange, `07:4000`)

**Overlay of bank 7 mode `$0E`** (`07:4000`, the link-cable photo exchange). No other mode touches these bytes (every access is inside `07:4000-5200`). Content:

* **Cable characters (`DA00/DA01`).** Four two-sprite animators. Slots 0/1 use `$D9FD/$D9FC` as frame and `$D9FB/$D9FA` as tick (region d800); slots 2/3 use `DA00/DA01` as *frame index* and `$D9FE/$D9FF` as *tick*. One step is `07:4329`: entry = 3 bytes of table `07:4354` (`sprite_a, sprite_b, duration`; a sprite id of 0 is skipped; both are drawn with `00:2496` at the anchor BC = `$3353` for slot 2 and `$6D52` for slot 3, `07:4304/4319`). When the tick reaches `duration` the frame advances, or jumps to the loop target after an `FF` entry (`FF,loop,00` at the end of the table). `D5F5` (0/1) is the Left/Right choice made on the screen (`07:4272`: Left -> 0, Right -> 1, sound `$0A`) and selects which pair of frames runs: `D5F5`=0 -> `DA00/DA01` = `$0A/$10`, `D5F5`=1 -> `$0E/$0C`; on confirmation `07:41CE` forces `DA01 := $15` (`D5F5`=0) or `DA00 := $12` (`D5F5`=1), and `07:4231` then tests exactly these two values to choose the text tile block copied to `$9820` (`07:7A60` vs `07:77A0`/`07:79C0`).
* **Transfer animation (`DA02-DA08`)** in states 6-8, 10-12 and 16: a pair of bar sprites moving in opposite directions (`07:49C3`) and three "lamps" lit according to a script (`07:4906`), the third lamp flickering randomly (`07:4948`).
* **Photo-pick dialog (`DA09-DA0A`)** and the **time-out counter `DA0B:DA0C`** of the waiting states.

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$DA00` | 1 | `link_anim2_frame` | u8, index into `07:4354` (3-byte entries) | W `07:405A`, `07:40B3`, `07:40CD`, `07:41ED`, `07:4292`, `07:42B2`, `07:430B`; R `07:424D`, `07:42FC`; step routine `07:4329`, called from `07:42D0`; `07:41CE`, `07:4231`, `07:4272` are the writers/readers listed above | Frame index of animator slot 2 (anchor `$3353`). `$0A` at mode init (`07:405A`); then `$0A` or `$0E` by `D5F5` (`07:40B3`/`40CD`, `07:4292`/`42B2`); `$12` = confirmed pose (`07:41ED`, only when `D5F5`=1); stepped and written back by `07:42FC-430B`. Read as a test at `07:424D` (`cp $12`). | C |
| `$DA01` | 1 | `link_anim3_frame` | u8, index into `07:4354` | W `07:405F`, `07:40B8`, `07:40D2`, `07:41DB`, `07:4297`, `07:42B7`, `07:4321`; R `07:4237`, `07:4312` | Same for slot 3 (anchor `$6D52`). Init `$0C` (`07:405F`); `$10` or `$0C` by `D5F5` (`07:40B8`/`40D2`, `07:4297`/`42B7`); `$15` = confirmed pose (`07:41DB`, only when `D5F5`=0); stepped at `07:4312-4321`; tested at `07:4237` (`cp $15`). | C |
| `$DA02` | 1 | `link_bar_x` | u8 (B argument = X of the sprite call) | W `07:44F9`, `07:464A`; R `07:49F7`, `07:4A05`; P `07:49C3` | X position of the first bar sprite (Y = `$24`, sprite `$A8+DA04`); the second bar sprite is at X = `$A0 - DA02`, Y = `$54` (`07:49F7-4A13`). `07:49C3` increments it while `DA04`=0 and decrements it while `DA04`=1, once per frame. Cleared at `07:44F9` and `07:464A` (state entry). The OAM byte order (Y first, then X) was checked in the sprite helper `00:24CB-24DA`, where `C` is added to the first OAM byte (Y) and `B` to the second (X). | C |
| `$DA03` | 1 | `link_bar_phase` | u8 0..`$37` | W `07:44FC`, `07:464D`, `07:49D9`; R `07:49D0` | Frame counter of the bar animation, wraps at `$38` (`07:49D0-49D9`). While it is `< 8` and `DA04`=0 the routine writes `$FFB0 := $E4` and `$FFB3 := $90`, otherwise `$FFB0 := $1B` and `$FFB3 := $50` (`07:49E6-49F5`; two HRAM shadows described in `wram_hram`: a short flash). Cleared at `07:44FC`, `07:464D`. | C |
| `$DA04` | 1 | `link_bar_dir` | u8 0/1 | W `07:459B`, `07:45D3`, `07:46BE`, `07:472F`, `07:4877`; R `07:49C6`, `07:49E0`, `07:49FD`, `07:4A0E` | Direction of the bars (and sprite variant: `$A8` + value). `:=1` in states 7 and 11 (`07:459B`, `07:46BE`), `:=0` in states 8, 12 and 16 (`07:45D3`, `07:472F`, `07:4877`). Only `07:49C3` reads it. | C (values); I (which role each state has) |
| `$DA05-$DA06` | 2 | `link_lamp_script` | 2 x u8: `DA05` = step, `DA06` = tick | `$DA05`: W `07:44FF`, `07:4650`, `07:493F`; R `07:4906`, `07:493B` / `$DA06`: W `07:4502`, `07:4653`, `07:4944`; R `07:4930` | Step index (`DA05`) and tick (`DA06`) into the 2-byte script `07:499E` (`flags, duration`; `FF` at the end loops to step 0). `07:4906` draws lamp sprites `$A5` (flag bit 2, at X=`$35`, Y=`$8C`), `$A6` (bit 1, X=`$65`) and `$A7` (bit 0, X=`$95`, through the flicker routine `07:4948`); when the tick reaches `duration` it advances the step (`07:4930-4944`). Both cleared at `07:44FF/4502` and `07:4650/4653`. | C |
| `$DA07-$DA08` | 2 | `link_flicker` | 2 x u8: `DA07` = threshold, `DA08` = accumulator | `$DA07`: W `07:4984`, `07:4997`; R `07:497D`, `07:498E`; P `07:4964` / `$DA08`: W `07:4950`, `07:495E`, `07:4972`; R `07:4955`, `07:4961`, `07:496A` | Random flicker of lamp 3 (`07:4948-499D`). If lamp bit 0 is clear: `DA08 := 0`, `DA07 += 8` (cap `$80`). If set: `DA08 += 9` (cap `$FF`); while `DA08 < DA07` the lamp stays dark and `DA07 += 8`; otherwise the lamp is drawn, `DA08 -= $23` (floor 0) and `DA07 -= (RNG & 3) + 10` (floor 0), RNG = `00:08F9`. Never initialised explicitly (zero from boot/clear). | C |
| `$DA09` | 1 | `link_pick_count` | u8 (0..`$7F`, or `$DC58`) | W `07:4CF1`, `07:4CF8`; P `07:4F58`, `07:515A` | Number of selectable photos in the "choose the photo" dialog: `DC55 & $7F` if `DC52` = 0, else `DC58` (`07:4CE6-4CF8`). A slot `S` is valid iff `S < DA09` (`07:4F58` for the grid of 8, `07:5157` for the cursor `D5D8`). `DC52/55/58` are in region dc00 (meaning not verified here). | C (use); ? (what `DC52`/`DC58` are) |
| `$DA0A` | 1 | `link_cancel_latch` | u8 0 / `$EF` | W `07:4C2C`, `07:4D2A`; R `07:4CFC` | Cleared at dialog entry (`07:4C2C`). When B alone is pressed (`$FFA2 == 2`) `DC56 := $EF` and `DA0A := $EF` (`07:4D18-4D2A`); with `DA0A` non-zero the dialog waits until the peer's `DC59` equals `$EF`, then goes to the next state (`07:4CFC-4D15`). So: local cancel sent, waiting for the peer's acknowledgement. | C |
| `$DA0B-$DA0C` | 2 | `link_timeout` | u16 little endian (`DA0B` low, `DA0C` high) | `$DA0B`: W `07:4568`, `07:46EF`, `07:4705`, `07:518B`; P `07:4ACB` / `$DA0C`: W `07:456D`, `07:46F3`, `07:470A`, `07:518F` | Watchdog of the waiting states. `07:4ACB`: `dec [DA0B]`, borrow into `DA0C`, returns Z when both are 0 (callers `07:45E0`, `07:473C`, `07:4884`, `07:5196`). Reloaded to `$0200` (`07:4568/456D` state 6, `07:4705/470A` state 11), `$00B4` (`07:46EF/46F3`, `07:518B/518F`). On expiry: `DBCF := $0C` and `D5CF := $12` (`07:45EA`, `07:4746`, `07:488E`). Units are frames if the states run once per frame (`$200` = 512 frames, about 8.6 s; `$B4` = 180 frames, 3 s): I. | C (mechanics); I (durations) |
| `$DBCE` | 1 | `link_setup_done` | u8 0/1 | W `07:40A5`, `07:4115`; R `07:410E` | Cleared at mode init (`07:40A5`), set to 1 in the first frame of state 1 which then runs `00:2D5F` once (`07:410E-4118`, `07:4115`). | C |

### 2. `$DA0F-$DA13`: bank 4 mode `$0F` copy screen (`04:4649`)

**Overlay of bank 4 mode `$0F`** (album with copy / delete / erase-all, `04:4649`); nothing else touches these bytes. When a photo is copied (state 14, `04:4F3A`) the counter of copies of this photo is incremented and shown as two tile digits (tens at VRAM `$8130`, units at `$8140`, digit graphics from bank `$13` `$5950`, 16 bytes each, `04:4FAF`), and a small marker sprite (`$22`, drawn with `00:24AF`) rises for `$26` frames next to the photo.

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$DA0F` | 1 | `copies_of_photo` | u8 (binary; drawn as tens/units by repeated subtraction of 10) | W `04:46A2`, `04:474D`, `04:4E5F`; R `04:4FB1`; P `04:4F42` | Copies made of the selected photo `D5D8` during this visit of the screen. Cleared at the mode entry (`04:46A2` state 0, `04:474D` state 11) and whenever `D5D8 != DA13` (`04:4E5F`); `inc` in state 14 (`04:4F45`) then drawn by `04:4FAF`. No cap was found in the code (the two-digit drawing is valid for 0..99). | C |
| `$DA10-$DA11` | 2 | `copied_marker_xy` | 2 x u8 (`DA10` = X, `DA11` = Y) | `$DA10`: W `04:4FFC`; R `04:5036` / `$DA11`: W `04:5000`; R `04:503A`; P `04:5022` | Position of the marker sprite: `04:4FAF` copies a pair from table `04:5009` (8 pairs `(X,Y)` = `4B 0B / 73 0B / 23 33 / 4B 33 / 73 33 / 23 5B / 4B 5B / 73 5B`, i.e. 8 positions on a grid of 3 columns (X = `$23/$4B/$73`) and 3 rows (Y = `$0B/$33/$5B`) of the album screen, index = `D5D8` (+2 if `D5D8 >= $1E`) AND 7) into `DA10`/`DA11` (`04:4FFC/5000`). `04:5019` draws it with `00:24AF` (B = `DA10`, C = `DA11`) and moves it up: `DA11 -= 2` at countdown `$24` and `$21`, `-= 1` at `$1C` (`04:5025-5035`). B = X and C = Y per the helper (`00:24CB-24DA`). | C |
| `$DA12` | 1 | `copied_marker_timer` | u8 `$26` .. 0 | W `04:46A5`, `04:4750`, `04:4E62`, `04:5005`, `04:501F`; R `04:5019` | Marker countdown: set to `$26` by `04:4FAF` (`04:5005`), decremented every frame by `04:5019` (`04:501F`); the marker is drawn while it is non-zero. Cleared with `DA0F` at entry (`04:46A5`, `04:4750`) and on photo change (`04:4E62`). | C |
| `$DA13` | 1 | `last_photo_seen` | u8 photo index | W `04:46AB`, `04:4756`; P `04:4E57` | Value of `D5D8` when `DA0F` was last reset (`04:46AB`, `04:4756`: `:= D5D8`); state 12 compares `D5D8` with it through HL (`04:4E54-4E5D`: `ld hl,$da13; cp [hl]`; on difference `DA13 := D5D8`, `DA0F := 0`, `DA12 := 0`). | C |

### 3. `$DA16-$DA30`: bank 7 mode `$00`, the main menu (`07:71AF`)

**Overlay of bank 7 mode `$00`** (main menu: an upper page with items 0-2 and a lower page with items 3-6). `DA16` (current item) is cleared together with `DA17/DA18` at the start of the main loop (`00:2EE9/2EEC/2EEF`), so every return to the main loop starts on item 0. A press of A/B/Start stores the pressed bits in `D5DF` (`07:7269`) and `07:77AF` branches: A (bit 0) -> mode `[07:7804 + DA16]` with state 0 (table `01 02 07 04 06 03 05 FF`, i.e. items 0..6 -> modes `$01` 04:6F96, `$02` 07:51AC, `$07` 07:54ED, `$04` 03:7AA8, `$06` 03:7695, `$03` 07:53BE, `$05` 03:7BFD by the mode table (README §2.3); `FF` is refused with sound `$0B` and the state is restored from `DA30`), B (bit 1) -> mode `$19` state 2, otherwise (Start) -> mode `$08` state 0 (owner registration/statistics, section 5). Select (bit 2) calls `07:73EF` (shake + transition) and `07:774C` returns to the page remembered in `DA18`/`DA19`.

**Icon animators (`DA1A-DA2D`)**: five slots of the same kind as the link animators. `07:7900` is called with HL = a table of 6-byte entries `frame_lo, frame_hi, Y, X, callback` (upper page: `07:7985`/`07:79E5`, 3 entries; the lower page uses 5 entries, calls at `07:7A3F-7ACF`). For slot *i* it clamps the frame `DA1F+i` into `[frame_lo, frame_hi)` (looping to `frame_lo`), copies `Y` into `DA24+i` and `X` into `DA29+i`, then jumps to the callback (`jp hl` at `07:792C`). The five callbacks `07:7AF1/7AF6/7AFB/7B00/7B05` (`ld de,i` then the common code `07:7B08`) draw sprite `[07:7B44 + 2*frame]` at (B = `DA29+i`, C = `DA24+i`) with `00:247D` and step tick `DA1A+i` against the duration in the next table byte, then the frame (`FF` = loop target). **These callbacks are reached only through `jp hl` and are not in the proven set of `trace_jp.json`; I decoded them by hand from the ROM bytes (`07:7AF1-7B43`, byte-exact), so their writes are tagged I.** The same applies to `07:7BF4-7D30` (transition helpers, `DA2E`).

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$DA16` | 1 | `menu_item` | u8 0..6 (7 only through the `FF` table entry) | W `00:2EE9`, `07:72A2`, `07:72C5`, `07:732B`, `07:733F`, `07:73B7`, `07:73D4`, `07:744D`, `07:746A`, `07:7487`, `07:74A0`, `07:74E9`, `07:7511`, `07:7539`, `07:7591`, `07:75B9`, `07:75E1`, `07:763A`, `07:7662`, `07:768A`, `07:76E3`, `07:770B`, `07:7733`, `07:778C`, `07:779B`, `07:77A6`; R `07:724A`, `07:77B6`, `07:780C`, `07:7843`, `07:78A1`, `07:78B5` | Current menu item (0-2 upper page, 3-6 lower page); moved by the D-pad handlers in `07:7260-77A6` (25 writes, mostly the constants of the next item); `07:71C5` restores `D5CF` from the table `07:7259` after returning from another mode; indexes `07:7804` at `07:77B6`. Cleared at `00:2EE9` (main loop start). | C |
| `$DA17` | 1 | `menu_up_col` | u8 0/1 | W `00:2EEC`, `07:71DB`, `07:72C0`, `07:733A`; R `07:73E7` | Remembered upper-row column (0/1): which upper-row item the player came from when moving down to item 2. Cleared at main-loop start (`00:2EEC`) and at menu entry (`07:71DB`, A = 0 from the `xor a` at `07:71D6`); `:= 0` at `07:72C0` and `:= 1` at `07:733A` when Down is pressed (item 1 -> item 2, `DA16 := 2`); read by the state of item 2 (`07:73E7`) to choose which upper-row item Up returns to. | C (writes/read); I (the exact items 0/1 stand for) |
| `$DA18` | 1 | `menu_sel_upper` | u8 0..2 | W `00:2EEF`, `07:72E6`, `07:7357`, `07:7390`; R `07:7775` | Upper-page item from which Select was pressed (`07:72E6` := 0, `07:7357` := 1, `07:7390` := 2; read at `07:7775`). Cleared at `00:2EEF`. | C |
| `$DA19` | 1 | `menu_sel_lower` | u8 0..3 | W `07:754A`, `07:75F3`, `07:769C`, `07:7745`; R `07:7437` | Lower-page item from which Select was pressed (`07:754A`, `07:75F3`, `07:769C`, `07:7745`; read at `07:7437`). | C |
| `$DA1A-$DA1E` | 5 | `menu_anim_tick[5]` | 5 x u8 | `$DA1A`: R `07:7947`, `07:79A7` | Tick of each icon animator, incremented by the callback stubs (`07:7B25-7B42`); proven reads only in the page set-up code (`07:7947`, `07:79A7`: icon 0 tick == 1 triggers the tile-block copy to `$8000`/`$8100`). | I (writes only in the unproven callbacks) |
| `$DA1F-$DA23` | 5 | `menu_anim_frame[5]` | 5 x u8, index into `07:7B44` (2-byte entries `sprite, duration`; `FF` = loop target in the next byte) | `$DA1F`: R `07:794D`, `07:79AD`; P `07:7900` | Frame of each icon animator, clamped by `07:7900`, stepped by the callbacks. In the set-up code the first icon's frame selects which of three tile blocks is copied to VRAM (`07:794D`: frames `$39` / `$3B` and others `07:7950-797E`; `07:79AD`: `$3E` / `$40`). | I (writes in the unproven callbacks; clamp write `07:7900-790F` is proven) |
| `$DA24-$DA28` | 5 | `menu_anim_y[5]` | 5 x u8 | no proven access | Y of each icon (`ld c,[DA24+i]` at `07:7B1D-7B21`), loaded by `07:7900` from byte 2 of the 6-byte entry (`07:7919`). Values e.g. `$29`, `$14`, `$5F` on the upper page. | I (the loads/uses are in hand-decoded code; OAM order checked at `00:24CB`) |
| `$DA29-$DA2D` | 5 | `menu_anim_x[5]` | 5 x u8 | no proven access | X of each icon (`ld b,[DA29+i]` at `07:7B18-7B1C`), loaded from byte 3 of the entry (`07:7922`). Values e.g. `$8D`, `$64`, `$7C`. | I (as above) |
| `$DA2E` | 1 | `menu_trans_stamp` | u8 copy of `[$FFC8]` (frame counter) | W `07:7BE9`, `07:7C58`, `07:7CC7` | Frame-pacing stamp of the four-step page transition routines `07:7BDC`, `07:7C4C`, `07:7CBB` (entered with HL = a draw callback and DE = a table of 3-byte `(addr, bank)` entries, e.g. `07:7C27`; each step copies a 512-byte tile block from that table to VRAM `$9100` through `00:05F8`, runs the callback, `07:7BEC-7C18`): each step stores `$FFC8` here (`07:7BE9`, `07:7C58`, `07:7CC7`; proven writes). The reader is `07:7D14` (hand-decoded: `a := DA2E - $FFC8 + 4`, then the step callback is run that many more frames), so each step lasts about 4 frames in total. | I (reader only in hand-decoded code) |
| `$DA2F` | 1 | `menu_item3_phase` | u8 0..39 | W `07:7A00`; R `07:79F7` | Phase counter of an icon animation of the lower page (`07:79F7`: `+1` mod `$28`); at phases `$18`, `$20`, `$26` the 512-byte tile block `$15:4E00` is copied to VRAM `$8300` (`07:7A1C-7A27`), at phases `0`, `$1C`, `$24` the block `$15:5000` (`07:7A2C-7A37`), then the lower-page animators are run (`07:7A3F`). Bank number `$15` is hexadecimal. Wrapped to 0 at `07:79FF-7A00`. | C (counter); I (what the tile blocks show) |
| `$DA30` | 1 | `menu_state_copy` | u8 copy of `D5CF` | W `07:726F`, `07:72F9`, `07:736A`, `07:74B8`, `07:7560`, `07:7609`, `07:76B2`; R `07:77CC` | Menu state at the moment A/B/Start was pressed (`07:726F` and six more write sites, one per page position); read only at `07:77CC`, which restores `D5CF` from it when the mode byte of the chosen item is `>= $22` (the `FF` entry). | C |

### 4. `$DA31-$DA32`: bank 4 pen (mode `$10`) and stamp (mode `$11`) edge detector

**Overlay shared by two bank 4 modes**: pen (`04:604B`, routines `04:618D`, `04:6454`) and stamp (`04:56F9`, routines `04:5C47`, `04:5D92`). In both, the cursor is clamped to the work area; if the player keeps pushing against the same edge the mode leaves the drawing state.

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$DA31` | 1 | `edge_dir` | u8 bit mask (`$10` right, `$20` left, `$40` up, `$80` down: the D-pad bits of `$FFA2`) | W `04:5D93`, `04:5E1B`, `04:5E29`, `04:646C`, `04:655C`, `04:656A`; R `04:5C64`, `04:61A7`; P `04:5C55`, `04:6198` | Direction in which the cursor was clamped this frame. Cleared every frame at the top of the cursor routine (`04:5D93`, `04:646C`), set by the clamp code (`04:5E1B/5E29`, `04:655C/656A`), read at `04:5C64`, `04:61A7` (P rows `04:5C55`, `04:6198` are `ld hl,$da31`). | C |
| `$DA32` | 1 | `edge_count` | u8 0..10 | W `04:5C5B`, `04:5C6E`, `04:619E`, `04:61B1`; R `04:5C6A`, `04:61AD` | Number of consecutive frames the pressed direction equals `DA31`: incremented/cleared at `04:5C5B/5C6E` and `04:619E/61B1`, tested at `04:5C6A`, `04:61AD`. At `>= 10` frames the mode goes to its state 3 (`04:5C75-5C97`, `04:66DB`). The exact label of state 3 (options panel?) is not verified here. | C (mechanics); ? (what state 3 is) |

### 5. `$DA33-$DA43`: bank 9 mode `$08` owner registration (`09:4883`)

**Overlay of bank 9 mode `$08`** (`09:4883`: owner registration and the statistics screens). States 0/1 animate four decorative sprites of the registration screen (`DA33-DA3A`, routine `09:5219` called from `09:5202`); states 6-10 run the on-screen keyboard that types the owner name (9 characters), the birth date (8 digits) and the gender/blood type (`DA3B-DA43`). Three character pages (pointer table `09:5C0E` = `53D3/53F5/5417`, used by `09:545F`) plus the special pages (3 = confirm, 4/5 = birth/blood). Nothing outside bank 9 touches these bytes.

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$DA33-$DA36` | 4 | `deco_tick[4]` | 4 x u8 | `$DA33`: P `09:5219` | Tick counters of four decorative sprites. `09:5219`: for each pair `i`, `tick+1`; if `< limit[i]` store, else tick := 0 and `phase[i] := (phase[i] + 1) AND 3`. Limits (table `09:5269`) = `0D 10 07 17` (13, 16, 7, 23 frames). | C |
| `$DA37-$DA3A` | 4 | `deco_phase[4]` | 4 x u8 (0..3) | `$DA37`: R `09:523D`; P `09:521C` / `$DA38`: R `09:5248` / `$DA39`: R `09:5255` / `$DA3A`: R `09:5260` | Phase of the four sprites, drawn at fixed positions BC = `$4550`, `$7049`, `$6D6C`, `$9177` with sprite ids `$61 + DA37`, `$65 + (DA38 & 1)`, `$6B + DA39`, `$67 + DA3A` (`09:523A-5265`, `00:247D`). | C |
| `$DA3B` | 1 | `kb_cursor` | u8 0..8 (0..7 in the birth-date page) | W `09:4B12`, `09:5C0A`, `09:5C1D`, `09:5C2E`, `09:5CC0`, `09:5CD4`, `09:5CFD`, `09:5D64`, `09:5D8A`, `09:5E0E`, `09:5E1A`, `09:5E2C`, `09:5E46`, `09:5E6E`, `09:5ED8`, `09:5F0E`; R `09:57F3`, `09:580B`, `09:5BED`, `09:5C03`, `09:5C14`, `09:5C28`, `09:5C9B`, `09:5CCD`, `09:5DC4`, `09:5E07`, `09:5E12`, `09:5E25`, `09:5F08`, `09:5F1E`, `09:5F2A` | Character position being edited in the field (name buffer `DA4D` + cursor, or the 8 date digits). Cleared at state 6 entry (`09:4B12`); 15 reads and 16 writes in `09:57F3-5F2A` (arrows, typing, delete). | C |
| `$DA3C` | 1 | `kb_key` | u8 | W `09:4B15`, `09:5D10`, `09:5D6C`, `09:5D99`, `09:5E4B`, `09:5E81`, `09:5EDD`; R `09:58C2`, `09:5B3B`, `09:5BA2`, `09:5BCA`, `09:5BE6`, `09:5D00`, `09:5D29`, `09:5D8D`, `09:5DB2`, `09:5DD6`, `09:5DEF`, `09:5E71`, `09:5E9A`, `09:5EB2`; P `09:5B61`, `09:5D40` | Key under the keyboard cursor. Gender: keys 0..2 are stored directly in `DA56` bits 0-1 (`09:5D3B-5D44`); blood type: keys 0..5 are accepted (`09:5EA7`) and stored shifted left twice into `DA56` bits 2-4 (`09:5EB2-5EBA`); thresholds `$3E/$41/$44/$47/$4A/$4D` on this value select the special keys on the character pages (delete, left, right, confirm...: exact labels I). | C (data flow); I (labels of special keys) |
| `$DA3D` | 1 | `kb_page` | u8 0..5 | W `09:4B18`, `09:5C3F`, `09:5C54`, `09:5C69`, `09:5D15`, `09:5D67`, `09:5D9E`, `09:5E50`, `09:5E86`, `09:5EE2`; R `09:57B4`, `09:57E1`, `09:586A`, `09:5BC3`, `09:5BD7` | Keyboard/tab page: 0..2 = character pages (pointer table `09:5C0E`), 3 = confirm page, 4 = birth-date page, 5 = blood-type page; written when a tab is selected (`09:5C3F`, `09:5C54`, `09:5C69`: := 0, 1, 2). | C (values); I (page names) |
| `$DA3E-$DA40` | 3 | `kb_tab_tick[3]` | 3 x u8 | `$DA3E`: P `09:5893`, `09:58AD` | Tick of the 'tab pressed' animation of tab C = 0..2 (`09:5881`: `add hl,bc`). | C |
| `$DA41-$DA43` | 3 | `kb_tab_frame[3]` | 3 x u8 0..6 | `$DA41`: W `09:4B1B`, `09:5C3B`; P `09:5883`, `09:589C` / `$DA42`: W `09:4B1E`, `09:5C4F` / `$DA43`: W `09:4B21`, `09:5C64` | Frame of the tab animation: 0 = idle, set to 1 when the tab is selected (`09:5C3B`, `09:5C4F`, `09:5C64`), then stepped by `09:5881` through table `09:58B4` = `(variant,duration)` pairs `00 04, 00 04, 01 04, 00 03, 01 03, 00 02, 01 02` and back to 0 at 7 (blink with shortening period). Cleared at state 6 entry (`09:4B1B/4B1E/4B21`). The returned `variant` bit chooses the sprite. | C |

### 6. `$DA44-$DA48`: bank 6 SHOOT image-effect vector

**Overlay used by bank 6** (SHOOT, modes `$14-$18`). `06:6C54` copies 5 bytes from `06:6C74 + 5*[$D7E9]` (six entries: `00 00 00 00 00`, `FF FF 00 00 00`, `FF FF 00 00 FF`, `00 00 00 00 FF`, `00 00 00 FF 00`, `00 FF 00 FF 00`). The vector is consumed by the pixel passes `06:747F-7784` (through `06:738F`, dispatch `06:60DB/06:73AF`).

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$DA44-$DA48` | 5 | `shoot_fx_vector[5]` | 5 x u8 (`$00` / `$FF` masks) | `$DA44`: R `06:7484`, `06:7591`, `06:76C2`; P `06:6C61` / `$DA45`: R `06:7488`, `06:7595`, `06:76C6` / `$DA46`: R `06:74C7`, `06:75E0`, `06:7711` / `$DA47`: R `06:74CB`, `06:75E4`, `06:7715` / `$DA48`: R `06:752E`, `06:7653`, `06:7784` | Block-copied by `06:6C54` (P row `06:6C61`), then read byte-wise: `DA44/DA45` at `06:7484/7488`, `06:7591/7595`, `06:76C2/76C6`; `DA46/DA47` at `06:74C7/74CB`, `06:75E0/75E4`, `06:7711/7715`; `DA48` at `06:752E`, `06:7653`, `06:7784`. Each is used as a mask applied to tile-row bytes of the work image `$C000`: the data flow is solid, but what each of the six effects looks like on screen was not decoded. | C (data flow); ? (visual effect) |

### 7. `$DA49-$DA5A`: owner block buffer (mirror of SRAM slot-1 `FB8-FC9`)

WRAM buffer of the owner block: **18 bytes** (`$12`, SRAM slot-1 offsets `FB8-FC9`). The SRAM block is 25 bytes (README §3.3: ID 4, name 9, gender/blood 1, birth 4, then Magic and checksum); the magic and the checksum are not kept in WRAM, only the first 18 bytes are (the checksum length `$17` used by `02:4BF4` = the 18 buffer bytes + the 5 magic bytes, from README §3.3's 25-byte layout with a 2-byte checksum). Loaded by `02:5054` from SRAM `$AFB8` (checked first) and saved by `02:4BF4` to `$AFB8` and the echo copy at `+$19` (checksum over `$17` bytes), called from `09:4BC8` (state 11 of mode `$08`) after registration. Other readers: `02:46F0`, `02:462F`, `07:4409` and `07:477D` (copy `$DA56` to `$CFFF` before the link exchange). Digits are stored as digit+1 and 0 = blank (`09:5605/5618` `dec a`). `09:4972` (state 2): after `02:5054`, the OR of the 14 bytes from `$DA4D` decides: 0 -> state 6 (new registration), else state 3 (display).

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$DA49-$DA4C` | 4 | `owner_id` | 4 bytes = 8 digit nibbles (digit+1) | `$DA49`: P `02:4742`, `02:4C0B`, `02:505C`, `02:51DB`, `02:51E9`, `09:548C` | Owner ID number (8 digits). Accessed only as a block (`02:5054` load, `02:4BF4` save, `02:46F0`) and by the draw/edit routines of bank 9 through HL. | C |
| `$DA4D-$DA55` | 9 | `owner_name` | 9 chars (keyboard grid code + 1, 0 = blank) | `$DA4D`: P `09:49B9`, `09:54BC`, `09:54D5`, `09:5BF3`, `09:5CA1`, `09:5F24` | Owner name, 9 characters, edited with cursor `DA3B`. Drawn by `09:49B9`, `09:54BC/54D5`, edited at `09:5BF3`, `09:5CA1`, `09:5F24` (all through HL). | C |
| `$DA56` | 1 | `owner_gender_blood` | u8: bits 0-1 gender key (0..2), bits 2-4 blood-type key | W `09:5D44`, `09:5EBA`; R `02:4664`, `07:4409`, `07:477D`, `09:54EE`, `09:550C`, `09:55AE`, `09:55D7`, `09:5D3B`, `09:5EAC` | Written by `09:5D44` (`and $FC` then `or key`) and `09:5EBA` (`key<<2 or gender`). Bit 0 and bit 1 are used as two independent flags elsewhere: `02:462F` adds 1 (cap 99) to `$CF12` if bit 0, to `$CF13` if bit 1, and always to `$CF14` of the received photo's tag (both tag copies: two passes of the loop at `02:465E-46B3`, the second at `+$5C`, each followed by the checksum `02:432F` over `$5A` bytes); `07:4A17` adds 1 to `$DA9E` / `$DA9F` for bit 0 / bit 1 of the *sender's* byte, which arrives in `$CFFF` (`07:4409`/`07:477D` copy `DA56` there). README §3.3 codes the field as 0 none / 1 male / 2 female; no instruction states which key or bit is which gender, so the naming stays I. | C (layout and flows); I (male/female) |
| `$DA57-$DA58` | 2 | `owner_birth_year` | 2 bytes = 4 digit nibbles (digit+1) | `$DA57`: P `09:552B`, `09:5574`, `09:5DCE`, `09:5DE7` | Birth year. | C |
| `$DA59` | 1 | `owner_birth_month` | 2 digit nibbles (digit+1) | P `09:5536`, `09:557C` | Birth month. | C |
| `$DA5A` | 1 | `owner_birth_day` | 2 digit nibbles (digit+1) | P `09:5541`, `09:5584` | Birth day. | C |

### 8. `$DA5B-$DA90`: tag-head buffer (mirror of SRAM slot offsets `F00-F35`)

`$36`-byte mirror of the first bytes of one photo's tag (SRAM slot offsets `F00-F35`, README §3.3). Loaded by `02:4E5F`: slot `< $1E` from SRAM `$AF00` (slot stride), slot `>= $1E` from ROM through the table `02:5218` (3 bytes per entry; locked bonus images are replaced, see section 10); saved by `02:494B` (both tag copies, echo at `+$5C`, checksum length `$5A`). The photo is the one in `DA95`. Displayed by the bank 9 owner-card routines (`09:461E-4750`) and edited by the comment editor (section 9). The photo-info card (`09:461E-4750`) therefore shows the owner stored in the photo's tag (I), not the camera's current owner.

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$DA5B-$DA5E` | 4 | `tag_owner_id` | 4 bytes (SRAM F00-F03) | `$DA5B`: P `02:4979`, `02:4E7E`, `02:4EA2` | ID of the camera owner that took the photo. Only block-copied (`02:4979`, `02:4E7E`, `02:4EA2`); no proven instruction reads a byte of it. | I (no reader found) |
| `$DA5F-$DA67` | 9 | `tag_owner_name` | 9 chars (SRAM F04-F0C) | `$DA5F`: P `09:47B6` | Name of the owner of the camera that took the photo; drawn by `09:47B6` through HL. | C |
| `$DA68` | 1 | `tag_gender_blood` | u8 (SRAM F0D): bits 0-1 gender, bits 2-4 blood type | R `09:463F`, `09:465F` | Same layout as `DA56`. `09:463F` takes bits 0-1 and picks a 64-byte picture from `09:56D0` (4 pictures, copied to VRAM `$8B80`); `09:465F` takes bits 2-4 and picks one from `09:54E0` (8 pictures, to `$9450`). | C |
| `$DA69-$DA6C` | 4 | `tag_birth` | 4 bytes (SRAM F0E-F11): year (2 bytes), month, day | `$DA69`: P `09:468A` / `$DA6B`: P `09:4692` / `$DA6C`: P `09:469A` | Birth date of the camera owner; `09:4687` draws year (`DA69`, 2 bytes), month (`DA6B`), day (`DA6C`) with `09:46A5`, which draws a placeholder when all bytes of the field are 0. | C |
| `$DA6D` | 1 | `tag_count_a` | u8 0..99 (SRAM F12) | R `09:46C9` | Reception counter bumped by `02:462F` when the receiver's `DA56` has bit 0 set (cap 99); drawn as two digits by `09:46C6` (`DA6D`, then `DA6E`). | C (flow); I (name) |
| `$DA6E` | 1 | `tag_count_b` | u8 0..99 (SRAM F13) | R `09:46D8` | Same for bit 1 (`02:4674`). | C (flow); I (name) |
| `$DA6F` | 1 | `tag_count_total` | u8 0..99 (SRAM F14) | R `09:470C` | Bumped on every reception (`02:467E-4684`); drawn by `09:4706`. | C (flow); I (name) |
| `$DA70-$DA8A` | 27 | `tag_comment` | 27 x u8 (SRAM F15-F2F), chars = grid code + 1, 0 = blank | `$DA70`: P `09:4405`, `09:4426`, `09:45F1`, `09:461E` | Comment text, 27 editable cells (cursor `DA91` is limited to `$1A`); drawn by `09:461E` (B = `$1E`: it draws 30 cells, the last three are the next row), edited by `09:4281-45FF`, all through HL. | C |
| `$DA8B-$DA8D` | 3 | `tag_comment_tail` | 3 x u8 (SRAM F30-F32) | no proven access | Three bytes after the 27 comment cells. README §3.3 records them as `00` except in three `1A`-filled slots of one save; no proven instruction names them, the comment drawing routine `09:461E` covers them (30 cells) and the editor never moves the cursor onto them. | I |
| `$DA8E` | 1 | `tag_copy_flag` | u8 (SRAM F33) | R `09:471B`, `09:4728`, `09:474D` | Read by `09:471B/4728` (digit tile set of the counters) and `09:474D` (chooses tile data `$5870` vs `$5790` for VRAM `$92B0`), i.e. it changes how the card is drawn. No proven instruction writes it in WRAM: it comes with the loaded tag. README §3.3 documents it as the *copy flag* (`01` = created by the album Copy function, set by `02:45A1` in both SRAM tag copies); I did not re-verify that writer. | C (readers); I (meaning taken from README §3.3) |
| `$DA8F-$DA90` | 2 | `tag_image_check` | 2 x u8 (SRAM F34, F35) | `$DA8F`: W `02:402E`; R `00:16F4`, `00:16FE`, `02:4755` / `$DA90`: W `02:405A`; R `00:1706`, `00:1710`, `02:4759` | Two 8-bit checksums of the 3584-byte image `$C000-$CDFF`: `DA8F` = additive sum (`02:4005-402E`, `add a,[hl]` over `$E00` bytes), `DA90` = XOR (`02:4031-405A`), computed just before a shot is saved, stored into the new tag (`$CF34/$CF35`, `02:4755/4759`) and re-read by `00:16F4`, which splits both bytes into four nibbles in `$DD03-$DD06` and plays sound `$10` through `00:2A7C`. `00:16F4` is called after saving a shot (`06:514C`, `06:53AE`, `06:639A`, `06:63C6`, `06:6404`) and from the album viewer (`07:717B`, after `02:4E5F`). | C |

### 9. `$DA91-$DA95`: bank 9 comment editor (far entry `09:4281`)

State of the comment editor (far entry `09:4281`, called from bank 4 at `04:6DB8` and `04:7B82`; the print info page `08:46A3` reuses the draw helpers). Before entering, bank 4 sets `DA95 := [$D5EE]` / `[$D5ED]` and loads the tag head (`04:6D8F`, `04:7B59` -> `02:4E5F`); on exit `04:6DC3` / `04:7B8D` call `02:494B` to save the buffer.

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$DA91` | 1 | `cmt_cursor` | u8 0..26 | W `09:42A6`, `09:4435`, `09:444C`, `09:4462`; R `09:43FF`, `09:4420`, `09:442F`, `09:443E`, `09:4455`, `09:4474`, `09:45EB`, `09:45F7` | Position of the text cursor in the comment (limit `$1A`, `09:4435-4462`); 8 reads / 4 writes in `09:42A6-4474`, `09:45EB/45F7`. | C |
| `$DA92` | 1 | `cmt_grid_cell` | u8 | W `09:42A9`; R `09:4409`, `09:44A3`, `09:4531`, `09:4558`; P `09:4582` | Cell of the character grid under the cursor (grid of 5 columns: `09:4409`, `09:44A3`, `09:4531`, `09:4558`, `09:4582`). | C (use); I (5 columns) |
| `$DA93` | 1 | `cmt_ctrl` | u8 0..3 | W `09:42AC`, `09:452B`, `09:454E`; R `09:43DB`, `09:449A`, `09:44F8` | Selected control: 0 = grid, 1 = delete, 2 = left arrow, 3 = right arrow (table `09:43EB`; `09:43DB`, `09:449A`, `09:44F8`). | C |
| `$DA94` | 1 | `cmt_grid_row` | u8 (scroll row) | W `09:42A3`, `09:4598`, `09:45A8`; R `09:44B2`, `09:4591`, `09:45A1`, `09:4866` | Scroll row of the character grid: `09:4866` copies `$A0 * page` bytes from bank `$2A` `$4000` to VRAM `$8E60`. | C |
| `$DA95` | 1 | `cmt_photo_index` | u8 0..`$3B` | W `04:6DA2`, `04:7B6C`, `08:46AA`; R `09:4778` | Photo whose tag is edited/displayed. Written by `04:6DA2`, `04:7B6C` (from `D5EE/D5ED`) and `08:46AA` (print info page); read by `09:4778`, which shows `index - $1E + 1` for album B. | C |

### 10. `$DA96-$DAAB`: statistics and best scores (shadow of SRAM `$10BB-$10D0`)

Flat **22-byte** shadow of SRAM `$10BB-$10D0`, the second half of the settings block. It is loaded by `02:503F` (from `$B0BB`, both copies, checksum length `$D7`) and saved by `02:4BB2` (`02:4BC4-4BD1`); field order checked against both routines. Counters are BCD, little endian. **These bytes are not part of the sound pack/unpack**: `02:4A6B` packs `$D93D-$D9D2` into SRAM `$B061-$B0BA` and `02:4F2B` unpacks, which ends before `$B0BB`. One might expect sound bytes here; they are the camera statistics and the three game records.

**They also gate bonus pictures.** The ROM-photo loaders `02:4CC7` and `02:51A5` (album B, slot `$2E-$35`) call `02:4D05`, which builds a bit mask from this block and tests bit `slot-$2E` (table `02:4D80` = `01 02 04 08 10 20 40 80`): a locked slot loads the placeholder from bank `$36` `$4000` instead of the table entry of `02:5218`. Bit 0: taken `>= 60` (`DA97 != 0` or `DA96 >= $60`); bit 1: printed `>= 30` (`DA9C >= $30`); bit 2: transferred `>= 15` (`DA9A >= $15`); bit 3: ball record `DAA5 >= $07`; bit 4: `DAA5 >= $10` (also sets bit 3); bit 5: shooter record `DAA1 >= $30` or `DAA2 | DAA3 != 0`; bit 6: `DAA1 >= $50` or `DAA2 | DAA3 != 0` (also sets bit 5); bit 7: `DAA7 >= $82`. All thresholds are BCD values.

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$DA96-$DA97` | 2 | `cnt_taken` | u16 BCD LE (SRAM 10BB-10BC) | `$DA96`: R `02:4D19`, `09:5317`; P `02:4BC8`, `02:5046`, `06:7825` / `$DA97`: R `02:4D13`, `09:5311` | Photos taken: `+1` BCD (`00:0F9C`, B=2) by `06:7823`; read by `09:5317` (statistics screen `09:530E`) and `02:4D13/4D19` (unlock test). Saved by `02:4BB2` (P `02:4BC8`), loaded by `02:503F` (P `02:5046`). | C |
| `$DA98-$DA99` | 2 | `cnt_erased` | u16 BCD LE (10BD-10BE) | `$DA98`: R `09:5326`; P `04:50F1` / `$DA99`: R `09:5320` | Photos erased: `04:50E5` loads the block (`02:503F`), adds 1 in BCD with `00:0F9C` (`ld hl,$da98`, B=2, `04:50F1-50F6`) and saves it with `02:4BB2`; read by `09:5320/5326`. | C |
| `$DA9A-$DA9B` | 2 | `cnt_sent` | u16 BCD LE (10BF-10C0) | `$DA9A`: R `02:4D37`, `09:5335`; P `07:4AE6` / `$DA9B`: R `02:4D31`, `09:532F` | Photos transferred: incremented by `07:4ADA` (P `07:4AE6`), called from `07:4603` (state 9) and `07:48A7` (state 17); read by `09:532F/5335`, `02:4D31/4D37`. | C |
| `$DA9C-$DA9D` | 2 | `cnt_printed` | u16 BCD LE (10C1-10C2) | `$DA9C`: R `02:4D28`, `09:5354`; P `00:3559` / `$DA9D`: R `02:4D22`, `09:534E` | Photos printed: incremented by `00:354D` (P `00:3559`) when the last page of a job is done (`00:33DC` state 6 with `DBC5`); read by `09:534E/5354`, `02:4D22/4D28`. | C |
| `$DA9E` | 1 | `cnt_recv_a` | u8 BCD (10C3) | R `09:533E`; P `07:4A21` | Photos received from a camera whose owner byte has bit 0: `07:4A17` (P `07:4A21`), called from `07:460C`, `07:48B0`; reads `$CFFF` bit 0, cap `$99`. Read by `09:533E`. | C (flow); I (male/female) |
| `$DA9F` | 1 | `cnt_recv_b` | u8 BCD (10C4) | R `09:5345` | Same for bit 1; read by `09:5345`. | C (flow); I (male/female) |
| `$DAA0-$DAA3` | 4 | `best_shooter` | u32 BCD LE, 8 digits (10C5-10C8) | `$DAA0`: R `09:5387`; P `07:67AD` / `$DAA1`: R `02:4D49`, `07:5A05`, `09:5381` / `$DAA2`: R `07:59FF`, `09:537B`; P `02:4D43` / `$DAA3`: R `02:4D40`, `07:59F9`, `09:5375`; P `07:679A`, `07:685A` | Best score of the mode-`$07` shooter (called "Space Fever II" in the manual; I). `07:6797` compares the current score `$D868-$D86B` with it (P `07:679A`, `07:67AD`) and copies it on a new record, saved by `02:4BB2` from `07:56D7`, `07:56F5`, `07:5713`, `07:591E`. Read by `09:5375-5387` (statistics), by `02:4D40-4D49` (unlock test) and by the shooter's start code `07:59F9-5A0E`, which sets `D831 := $40` when the stored best is below 2000 (`DAA3` = `DAA2` = 0 and `DAA1 < $20`). | C (flow); I (game name) |
| `$DAA4-$DAA5` | 2 | `best_ball` | u16 BCD LE (10C9-10CA) | `$DAA4`: R `09:5396`; P `05:7E9F` / `$DAA5`: R `02:4D58`, `04:5827`, `09:5390`; P `05:7E8C` | Best score of mode `$20` (`05:74CC`; the "Ball" game, I): `05:7E89` compares `$D9E6/$D9E7` through HL (P `05:7E8C`, `05:7E9F`) and saves with `02:4BB2`. Read by `09:5390/5396`, `04:5827` (caps `DAA5` to 5 for `$D642`), `02:4D58` (unlock). | C (flow); I (game name) |
| `$DAA6-$DAA7` | 2 | `best_run` | u16 (10CB-10CC): `DAA7` = first digit pair, `DAA6` = second pair, stored as the nine's complement of the displayed digits | `$DAA6`: R `09:4D06`, `09:53A9`; P `09:7277` / `$DAA7`: R `02:4D67`, `09:4CFC`, `09:539F`; P `09:7261` | Best result of mode `$21` (`09:5FE3`; the "Run! Run! Run!" game, I). `09:5372-53AD` displays `DAA7` then `DAA6` as `$99 - byte` (`cpl; add a,$9A`), so a cleared block reads `99 99`; written by `09:725E`, which computes `$99 - [$D029]` (`09:7266-7268`) and `$99 - [$D028]` (`09:727C-727E`), compares high byte first against `DAA7`/`DAA6` and copies only if the new complement is larger (`09:726A-726C`; P `09:7261`, `09:7277`), then `02:4BB2` saves. So the game result in `$D029:$D028` (BCD, `$D029` high) is better when *smaller*, and a smaller displayed number is the better result: `02:4D67` unlocks bit 7 when the stored `DAA7 >= $82` (displayed `<= 17`), and state 18 (`09:4CFC-4D0B`) takes the second scene when the stored word is `>= $7799` (displayed `<= 22 00`). Whether the number is a time is not stated by the code (I). | C (flow and complement display); I (game name, time reading) |
| `$DAA8-$DAAA` | 3 | `stats_spare` | 3 x u8 (10CD-10CF) | no proven access | No proven instruction touches them individually; they only travel with the block copy of `02:503F`/`02:4BB2`. | U |
| `$DAAB` | 1 | `print_intensity` | u8 0..`$7F` (SRAM 10D0) | W `08:4457`; R `00:1BDB`, `08:4441`, `08:4467` | Printer density: changed by Left/Right in the print options (`08:4441`, cap `$7F`, sound `$22`; W `08:4457`), saved on exit by `08:4427`, read by `00:1BDB` into `$DC34` (4th data byte of the PRNT packet, `$DC2D` block). Loaded by `02:503F` like the rest. | C |

### 11. `$DAAC-$DB4C`: bank 4 delete-photo effect (`04:5121`)

**Overlay of bank 4 states 9 and 10 of mode `$0F`** (`04:4C8D` single photo, `04:4D1B` erase all), through the effect routine `04:5121`. Sixteen sprites (e = 0..15, OAM tile `$70+e`, attribute 0, written by `04:5307/531A`) are animated in two phases, all with one byte per sprite in 16-byte arrays accessed through HL/DE (`add hl,de`), so only the array bases appear as P rows in the access table.

* **Phase 1 (`04:5172-5182`, one step per frame, `04:522D`/`04:525C`)**: spiral into the photo position. `DAEC[e] += 2` (angle) and `DAFC[e]` (radius) counts down to 0; the position is the centre plus `radius x trig(angle)` computed with the multiply `00:0F4F` (8 x 8 -> 16 bit) and the quarter-wave lookups `00:0FB2` / `00:0FC7` (table at `00:0FCB`; sine/cosine-like, I): `DACC[e] = H(product) + DAAC[e]` (X) and `DADC[e] = H(product) + DABC[e]` (Y), with the product negated when the lookup says so (`04:52A1`). It ends when all 16 radii are 0 (`04:5248-524E` sets `DB4C`).
* **Phase 2 (`04:518C-519A`, `04:52AB`; every frame if `DBCD` is non-zero, else every second frame by `$FFC8` bit 0)**: ballistic burst. First `DB0C[0..31] += DB2C[0..31]` (velocity += acceleration, 32 bytes), then `DACC[e] += DB0C[e]` and `DADC[e] += DB1C[e]`; a sprite whose X is in `$A4..$FB` (Y in `$94..$FB`) stops moving; when no sprite moves any more `DB4C := 1` (`04:52E6`, `04:5303`).

`04:5121` first fills `DAAC[e]` with the high byte and `DABC[e]` with the low byte of the word at `04:519D + 2*(D5D8 & 7)` (8 words `L,H` = `28 58 / 28 80 / 50 30 / 50 58 / 50 80 / 78 30 / 78 58 / 78 80`, i.e. 3 rows `$28/$50/$78` and 3 columns `$30/$58/$80`: the screen position of the photo `D5D8 & 7` in the album page), then copies 96 bytes from `04:51CD` into `DAEC-DB4B` (six 16-byte tables, listed per row below), and plays sound `$3B` (single photo, `04:515A`) or `$05` (erase all, `04:5163`).

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$DAAC-$DABB` | 16 | `del_cx[16]` | 16 x u8 | `$DAAC`: P `04:5130`, `04:5275` | Centre X of the swirl: all 16 entries = high byte of the word at `04:519D + 2*(D5D8 & 7)` (`04:5121-513D`); added to the X offset in `04:5275-527E`. | C |
| `$DABC-$DACB` | 16 | `del_cy[16]` | 16 x u8 | `$DABC`: P `04:5133`, `04:5295` | Centre Y: all 16 entries = low byte of the same word (`04:5133`); added to the Y offset in `04:5295-529E`. | C |
| `$DACC-$DADB` | 16 | `del_x[16]` | 16 x u8 | `$DACC`: P `04:527A`, `04:52C9`, `04:5326` | Current X of each sprite, written to OAM byte 1 (`04:5326-532B`). Phase 1: `H(radius x trig(angle)) + DAAC[e]` (`04:527A`); phase 2: `+= DB0C[e]` unless X is in `$A4..$FB` (`04:52C9-52DB`). | C |
| `$DADC-$DAEB` | 16 | `del_y[16]` | 16 x u8 | `$DADC`: P `04:529A`, `04:531D` | Current Y minus 8; OAM byte 0 = value + 8 (`04:531D-5324`). Phase 1 at `04:529A`; phase 2: `+= DB1C[e]` unless Y is in `$94..$FB` (`04:52EC-52FB`). | C |
| `$DAEC-$DAFB` | 16 | `del_angle[16]` | 16 x u8 | `$DAEC`: P `04:5148`, `04:522D`, `04:525F`, `04:527F` | Angle of each sprite, `+= 2` per phase-1 frame (`04:522D-5236`). Initial values (`04:51CD`) = `A0 B3 CD E0 8D A0 E0 F3 73 60 20 0D 60 4D 33 20`. | C (use); I (angle units: a full turn of 256 is assumed from the `$3F`-masked quarter-wave table) |
| `$DAFC-$DB0B` | 16 | `del_radius[16]` | 16 x u8 | `$DAFC`: P `04:5238`, `04:5268`, `04:5288` | Radius, decremented to 0 once per phase-1 frame (`04:5238-5246`); initial values `11 0C 0C 11 0C 08 08 0C 0C 08 08 0C 11 0C 0C 11` (17, 12 or 8 frames of spiral). All zero -> phase 1 done. | C |
| `$DB0C-$DB2B` | 32 | `del_vel[2][16]` | 32 x s8: `DB0C-DB1B` = X velocity, `DB1C-DB2B` = Y velocity | `$DB0C`: P `04:52B9`, `04:52C6` | Initial X velocities `FC FE 02 04` repeated 4 times, initial Y velocities `F8 F8 F8 F8 FC FC FC FC FE FE FE FE FF FF FF FF` (all negative). `+= acceleration` each phase-2 step (`04:52B6-52C4`, 32 bytes), then added to the position. | C (data flow); I (negative = up/left) |
| `$DB2C-$DB4B` | 32 | `del_acc[2][16]` | 32 x s8: `DB2C-DB3B` = X acceleration, `DB3C-DB4B` = Y acceleration | `$DB2C`: P `04:52B6` | Initial values: X acceleration 0 (16 x `00`), Y acceleration 2 (16 x `02`): a downward pull, so the burst falls back. | C (values); I (gravity reading) |
| `$DB4C` | 1 | `del_done` | u8 0/1 | W `04:516A`, `04:5185`, `04:524E`, `04:52E6`, `04:5303`; R `04:517E`, `04:5196` | Phase-finished flag: cleared at `04:516A` (before phase 1) and `04:5185` (before phase 2), set at `04:524E` (all radii 0), `04:52E6` and `04:5303` (X and Y loops of phase 2); read at `04:517E`, `04:5196` as the loop exits. | C |
| `$DBCD` | 1 | `del_variant` | u8 0/1 | W `04:4C8E`, `04:4D78`; R `04:5153`, `04:52AB` | `:= 0` in state 9 (`04:4C8E`, single photo), `:= 1` in state 10 (`04:4D78`, erase all); read at `04:5153` (sound `$3B` vs `$05`) and `04:52AB` (phase 2 every frame vs every other frame). | C |

### 12. `$DB4D-$DBCA`: print engine (bank 0 mode `$1D` = `00:3015`)

The print engine is a state machine in the **fixed bank** (mode `$1D`, `00:3015`); bank 8 (mode `$1C`, `08:40F8`, and mode `$1E`, `08:4887`) and bank 6 (`06:5AE0`, the 4-photo job) set the job tables up. The engine renders one band (40 tiles = 640 bytes) at a time into `$CF00`, sends it as printer packets built in `$DC2D` (`$DC08` = 1, `$DC09` = margin, `$DC0A` = `$E4`, `$DC34` = `DAAB`; these four are the data bytes of the Game Boy Printer PRINT command: sheets, margins, palette, density; the packet protocol itself is from my knowledge of the printer, I) and updates the progress picture. Margin: `00:3339` (state 5) builds `$DC09` from `$D801/$D802` and `DBC4/DBC5`. State 6 (`00:33DC`) calls `00:354D` (counter `DA9C`) when `DBC5` is non-zero. The descriptor table is reloaded per band from bank 8 by `00:3214` (80 bytes).

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$DB4D-$DB5C` | 16 | `print_src_table[4]` | 4 entries x 4 bytes (lo, hi, bank, pad) | `$DB4D`: W `08:461F`, `08:466B`, `08:475A`, `08:4AEE`; P `00:3178` / `$DB4E`: W `08:461B`, `08:4667`, `08:4755`, `08:4AEA` / `$DB4F`: W `08:4617`, `08:4663`, `08:4750`, `08:4AE6` / `$DB51`: P `08:5111`, `08:5420` / `$DB5B`: P `06:5AE3` | Sources of band data. Entry 0 = the photo address given by `02:517B` (A=bank, B=hi, C=lo), stored at `08:4617-461F`, `08:4663-466B`, `08:4750-475A` (info page: `$C000`, bank 0) and `08:4AE6-4AEE`; `08:540D` fills entries 1..3 (`DB51/DB55/DB59`: three consecutive 2 KiB graphic chunks, `hi += 8` each, wrapping to the next bank via table `08:54C6`); `06:5AE0` fills entries 3..0 for a 4-photo SHOOT job (`06:5AE3`; an absent photo = `FF FF FF`, zero-filled by `00:3214`). Read by `00:31E2` with index = descriptor flags & 3 (P `00:3178`). | C |
| `$DB5D-$DB6C` | 16 | `print_src_table2[4]` | 4 entries x 4 bytes (same layout) | `$DB5D`: P `00:31A5` / `$DB61`: P `08:5106` | Second table. The only proven writer is `08:50F6`/`08:5106` (`DB61`, the first triple of the border graphics table `08:511F`, 6 bytes per border number `D7C1`; the second triple goes to `DB51`). The base `DB5D` is loaded at `00:31A5` (reader through HL, selected by descriptor bit 5?). Entries 0, 2 and 3 are never written by proven code. | ? (only entry 1 written; reader through HL) |
| `$DB6D` | 1 | `print_layout_type` | u8 0..4 | W `06:5B22`, `08:462D`, `08:467A`, `08:475F`, `08:4B09`; R `00:30DD`, `00:311B` | Page layout: 0 plain (`08:462D`), 1 framed (`08:467A`), 4 info page (`08:475F`), `08:4B09` := 0, `06:5B22` := `($D5EA xor 1) + 2` (2 or 3, the 4-photo layouts). Read at `00:30DD` (table `00:30F9`) and `00:311B` (table `00:32E8`). | C |
| `$DB6E` | 1 | `print_return_idx` | u8 0..4 | W `06:5B25`, `08:4630`, `08:467D`, `08:4763`, `08:4B0E`; R `00:346E` | Return-target index: table `00:3483` = `1C 08, 1C 08, 18 00, 18 00, 1E 05` (mode, state) used when the job ends (`00:346E`). Written by `08:4630`, `08:467D`, `08:4763`, `08:4B0E` (:= 4), `06:5B25`. | C (use); I (the pairs are (mode,state)) |
| `$DB6F` | 1 | `print_pages` | u8 (0 = not set) | W `06:5B18`, `08:4637`, `08:4684`, `08:4771`, `08:4B16`; R `00:3321` | Number of pages of the job (`08:4637`, `08:4684`, `08:4771`, `08:4B16`, `06:5B18`); `00:3321`: after `DBC3` is incremented, equality with `DB6F` sets `DBC5 := 1` (last page). | C |
| `$DB70-$DBBF` | 80 | `print_band_desc[40]` | 40 x (byte 0 tile index/offset, byte 1 flags) | `$DB70`: P `00:3136`, `00:3161` | Band descriptors, copied from bank 8 by `00:3214`; rendered by `00:3161` (P `00:3136`, `00:3161`) into `$CF00`. Flags: bits 0-1 source entry, bit 3 -> `DBC5 := 1` (`00:31C4`), bit 4 -> 1bpp expansion (`00:3249`), bit 5 -> indirect/second source (purpose not proven), bit 6 -> blank tile, bit 7 -> `DBC6 := 1` (`00:3188`). | C (bits 0-4, 6, 7); ? (bit 5) |
| `$DBC0-$DBC1` | 2 | `print_script_off` | u16 LE | `$DBC0`: W `00:3035`, `00:3144`; R `00:312A` / `$DBC1`: W `00:3038`, `00:3148`; R `00:312E` | Byte offset into the layout script (`+$50` per band; read `00:312A/312E`, advanced `00:3144/3148`). Cleared at `00:3035/3038`. | C |
| `$DBC2` | 1 | `print_band_no` | u8 0..9 | W `00:30C9`; P `00:314E` | Band counter of the current page: cleared at `00:30C9` (state `00:30AB`, run once per page after the printer answered with `$81` in `$DC28`), incremented through HL once per band (P `00:314E`, `00:3151`); when it reaches 9 `DBC6 := 1` (`00:3153-3159`). 9 bands x 2 tile rows = the 18 tile rows (144 lines) of one image. | C |
| `$DBC3` | 1 | `print_page_no` | u8 | W `00:303B`; R `00:30E9`; P `00:331D` | Page index: cleared `00:303B`, incremented `00:3320` (P `00:331D`), read `00:30E9`, `00:3321`. | C |
| `$DBC4` | 1 | `print_first_page` | u8 0/1 | W `00:3043`, `00:33FB`; R `00:3359` | Top-margin flag: `:= 1` at `00:3043`, `:= 0` at `00:33FB`; read at `00:3359`. | C |
| `$DBC5` | 1 | `print_last_page` | u8 0/1 | W `00:3032`, `00:31C4`, `00:332C`; R `00:3360`, `00:33EE` | Bottom-margin flag: cleared `00:3032`, set by descriptor bit 3 (`00:31C4`) and by `00:332C`; read `00:3360` (margin) and `00:33EE` (triggers `00:354D`). | C |
| `$DBC6` | 1 | `print_last_band` | u8 0/1 | W `00:30CC`, `00:3159`, `00:3188`; R `00:32F5`, `00:3317` | Cleared with `DBC2` at the start of each page (`00:30CC`); set to 1 when the band counter reaches 9 (`00:3159`, in the band set-up `00:3118`) and by descriptor bit 7 (`00:3188`); read `00:32F5` (copied to `$DC3D`) and `00:3317`. | C |
| `$DBC7-$DBC8` | 2 | `print_progress_step` | u16 LE | `$DBC7`: W `00:30F1`; P `00:3522` / `$DBC8`: W `00:30F5` | Loaded at `00:30F1/30F5` (called from `00:30D5`, start of each page) from the table `00:30F9` (offset byte per layout `DB6D`, then one word per page index `DBC3`); read through HL at `00:3522`. | C (load); I (use) |
| `$DBC9-$DBCA` | 2 | `print_progress_acc` | u16 LE | `$DBC9`: W `00:30CF`; P `00:351F` / `$DBCA`: W `00:30D2` | Accumulator: cleared `00:30CF/30D2` at the start of each page, advanced by the step at `00:3515-3522`; `(hi >> 3)` capped at 15 selects `$54DE + 5*a` for `call $0A8A` (progress picture). | C (flow); I (visual) |

### 13. `$DBCB-$DBCC`, `$DBCF`: shared print/result flags

These are **shared between banks** (not an overlay of one mode).

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$DBCB` | 1 | `print_layout_flag` | u8 0 plain / 1 framed | W `04:6C80`, `04:79E9`, `08:412B`, `08:47B6`, `08:47E7`; R `08:4218`, `08:4602`, `08:480C` | Cleared at `08:412B`, `04:6C80`, `04:79E9`, `08:47B6` (state 11, after `02:48F7`); set to 1 at `08:47E7` (state 14); read at `08:4218` (0 = plain path, loads the photo with `02:4E31`/`02:517B`; non-zero = framed path `08:424D`), `08:4602` (after `D803` is incremented), `08:480C`. This is the flag the previous README meant by "the shared flag `$dbcb`" that chooses between the two layout templates. | C |
| `$DBCC` | 1 | `border_normalised` | u8 0/1 | W `04:6C83`, `04:79EC`, `08:412E`, `08:423E`, `08:4832`; R `08:421E`, `08:4812` | Latch so that a border number `$D7C1 == $12` is normalised only once: in the plain-layout path (`DBCB` = 0) `08:4231-423E` replaces `$D7C1` by 0 and sets this latch to 1 (same in `08:4832`); read at `08:421E`, `08:4812`; cleared at `04:6C83`, `04:79EC`, `08:412E`. | C (flow); I (name) |
| `$DBCF` | 1 | `result_msg_id` | u8 | W `00:343B`, `03:62FA`, `04:71BD`, `04:71C9`, `04:71FA`, `06:53FB`, `06:726F`, `07:417D`, `07:45EA`, `07:4746`, `07:488E`, `07:7122`; R `04:71E0`, `09:7346`, `09:737F` | Message id of the shared result/error screen `09:7290`, which looks it up in the table `09:739E` (3 bytes per entry) -> text tiles `$8900`; id `$0E` forces picture set 3, otherwise a random set 0..2 (`09:7346`). Writers: `00:343B` (printer status mapping: bit 7 -> 0, bit 6 -> 3, bit 5 -> 2, otherwise 1), `03:62FA` := 6, `04:71BD/71C9/71FA` := `0E/04/08`, `06:53FB` := 9, `06:726F` := `0D`, `07:417D` (from `$DC50` through the table `07:4186` = `09 09 0A 0B`), `07:45EA/4746/488E` := `0C`, `07:7122` := 5. Readers: `04:71E0`, `09:7346`, `09:737F`. | C (flow); ? (the texts and which printer condition each status bit is) |

### 14. `$DBD0-$DBFE`: printer-link leftovers (bank 0 `00:18A3`, `00:19EB`)

Written or read only by the printer serial routines of bank 0.

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$DBD0-$DBD1` | 2 | `printer_prev_status` | 2 x u8 (`DBD0`, `DBD1`) | `$DBD0`: W `00:18CD` / `$DBD1`: W `00:18C6` | At every received printer byte `00:18BD-18D2`: `DBD1 := [$DC27]` (previous reply byte, `00:18C6`) and `DBD0 := [$DC27]` unless it is `$FF` (`00:18CD`); then `$DC27 := [$FF01]`. Never read by any proven instruction. | U (write-only) |
| `$DBEC-$DBFD` | 18 | `printer_len_table` | 9 x u16 LE (assumed) | `$DBEC`: P `00:1A3D`, `00:1AA0` | Packet-length table of `00:19EB`: `bc := [DBEC + 2*(DC3E-2)]` (`00:1A3D`, `00:1AA0`), used only when `$DC0B != 0`. `DC0B` has no proven writer (only reads at `00:1A1B`, `00:1A7E`), so the default `bc := $0280` is always taken. The size 18 is only the distance to `DBFE`. | U (dead path; no proven writer of `DC0B` or of the table) |
| `$DBFE-$DBFF` | 2 | `printer_dc0c_table` | bytes indexed by `DC3E-2`; extends into `$DC00` (dc00 region) | `$DBFE`: P `00:1A2E`, `00:1A91` | Feeds `$DC0C` (`00:1A2E`, `00:1A91`) in the same dead path. Only the first 2 bytes are in my range. | U (dead path) |

### 15. Bytes of the page with no proven access

These ranges never appear in `wram_summary.csv` and no row above covers them. No proven instruction reads or writes them; an access through HL/DE/BC or a block copy cannot be excluded, so they are **not** claimed to be unused.

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$DA0D-$DA0E` | 2 | `gap_da0d` | unknown | no proven access | Between the link-screen variables (`DA00-DA0C`) and the copy-screen variables (`DA0F-DA13`). No proven access, no P row pointing into it. Possibly spare/padding of the allocation; no evidence either way. | ? |
| `$DA14-$DA15` | 2 | `gap_da14` | unknown | no proven access | Between the copy-screen variables and the main-menu variables (`DA16-`). No proven access; `DA16-DA18` are cleared one by one at `00:2EE9-2EEF`, which does not include these two. | ? |
| `$DBD2-$DBEB` | 26 | `gap_dbd2` | unknown | no proven access | After the two write-only printer status bytes (`DBD0/DBD1`) and before the `DBEC` table. No proven access and no P row inside; the `DBEC` table (`9 x u16`, row above) ends at `DBFD`, so this gap is also not part of it. | ? |

### Corrections to the previous README

1. `$DA00-$DA42` "bank-007 frame/stamp picker, working theory ... not yet traced": it is five unrelated overlays: link animators and timers (`$DA00-$DA0C`, bank 7 mode `$0E`), album copy marker (`$DA0F-$DA13`, bank 4), main-menu state and icon animators (`$DA16-$DA30`, bank 7 mode `$00`), pen/stamp edge detector (`$DA31-$DA32`, bank 4) and owner-registration animation and keyboard (`$DA33-$DA43`, bank 9).
2. `$DA3B-$DA42` "bank 9 cursor/dispatch mechanism, purpose unconfirmed": identified. It is the keyboard of the owner registration screen: `$DA3C` = key, `$DA3D` = keyboard page (doubled index into the pointer table `9:5C0E`), `$DA3B` = character position in the name buffer `$DA4D`. (The README's `$DA4D` "second array" is the owner name.)
3. `$DA49-$DA5A` owner buffer is 18 bytes (consistent with README §3.3), and `$DA5B-$DA90` is `$36` bytes = tag offsets `F00-F35`; `F15-F2F` is the 27-cell comment (`$DA70-$DA8A`), `F30-F32` = `$DA8B-$DA8D`.
4. `$DA96-$DAAB` is the 22-byte shadow of SRAM `$10BB-$10D0` (README §3 already says so), **not** part of the sound pack/unpack (`2:4A6B` / `2:4F2B` handle `$D93D-$D9D2` <-> SRAM `$B061-$B0BA`), as the first-round map had assumed. New: it also decides which of the eight bonus pictures of album B (slots `$2E-$35`) are unlocked (`2:4D05`, thresholds in section 10).
5. `$DAA0-$DB80` "UI scratch": actually the game records (`$DAA0-$DAA7`), the bank 4 delete effect (`$DAAC-$DB4C`) and the print source tables and state (`$DB4D-$DB6F`, band descriptors `$DB70-$DBBF`).
6. `$D803` (print job index, see `wram_d800.md`) is only a pass/job counter; the flag that actually selects the plain (0) or framed (1) layout is `$DBCB` itself, written by the mode-`$1C`/`$1E` states (`8:412B`, `8:47B6`, `8:47E7`) and by bank 4 (`4:6C80`, `4:79E9`).
7. `$DBCF` is the message id of the shared result/error screen `9:7290` (written from banks 0, 3, 4, 6, 7), not only a result code.
8. `$DC00-$DC5E` "sound engine": the `$DC2D` block is the printer packet (`$DC08` = 1, `$DC09` margin, `$DC0A` = `$E4`, `$DC34` = print density `DAAB`).
9. `$CFFF` is not an alias of `$DA56` (already corrected in `wram_lowwram`); it is the exchange byte carrying the sender's `DA56` during the link exchange (`7:4409`, `7:477D`, `7:4A17`).

### Still inconclusive

* `$DBCF`: the on-screen texts of the ids and which GB Printer condition each status bit of `0:343B` means.
* Purpose of print descriptor flag bit 5, and why only `$DB61` of the table `$DB5D-$DB6C` is ever written.
* `$DA5B-$DA5E` (tag owner ID): no proven reader; and `$DA8E` (tag flag F33): its meaning is unknown.
* `$DA07/$DA08`: mechanism fully decoded, but the visual effect on screen was not observed.
* `$DA44-$DA48`: data flow decoded, visual meaning of the six effects not known.
* Which of the two bits of `$DA56` is male and which female (README §3.3 says bit 0 = male, bit 1 = female, status B; no instruction states it), and what gender key 0 means.
* `$DA1A-$DA2E` writers and the `DA2E` reader are in hand-decoded code that the tracer does not reach (`7:7AF1-7B43`, `7:7BF4-7D30`).
* Units of the link time-outs `$DA0B:DA0C` (frames assumed).
* `$DAA6-$DAA7`: what the number measures (a time? lower is better; `$D028/$D029` is in the d000 region).
* Exact meaning of `DA32`'s state 3 (edge-push exit target) in bank 4 pen/stamp.
* Length of the table at `$DBFE` (runs into `$DC00`) and `$DBEC` (18 is the distance to `$DBFE`).

### Access-count index (every `$DA00-$DBFF` address of `wram_summary.csv`)

R = proven reads, W = proven writes, P = `ld rr,nn` pointer loads of that address (array/buffer bases); `row` = the table row (section) that explains it. This is the list used for the mechanical coverage check.

| Address | R | W | P | Banks (summary) | Row |
|---|---|---|---|---|---|
| `$DA00` | 2 | 7 | 0 | 07:9 | `link_anim2_frame (§1)` |
| `$DA01` | 2 | 7 | 0 | 07:9 | `link_anim3_frame (§1)` |
| `$DA02` | 2 | 2 | 1 | 07:5 | `link_bar_x (§1)` |
| `$DA03` | 1 | 3 | 0 | 07:4 | `link_bar_phase (§1)` |
| `$DA04` | 4 | 5 | 0 | 07:9 | `link_bar_dir (§1)` |
| `$DA05` | 2 | 3 | 0 | 07:5 | `link_lamp_script (§1)` |
| `$DA06` | 1 | 3 | 0 | 07:4 | `link_lamp_script (§1)` |
| `$DA07` | 2 | 2 | 1 | 07:5 | `link_flicker (§1)` |
| `$DA08` | 3 | 3 | 0 | 07:6 | `link_flicker (§1)` |
| `$DA09` | 0 | 2 | 2 | 07:4 | `link_pick_count (§1)` |
| `$DA0A` | 1 | 2 | 0 | 07:3 | `link_cancel_latch (§1)` |
| `$DA0B` | 0 | 4 | 1 | 07:5 | `link_timeout (§1)` |
| `$DA0C` | 0 | 4 | 0 | 07:4 | `link_timeout (§1)` |
| `$DA0F` | 1 | 3 | 1 | 04:5 | `copies_of_photo (§2)` |
| `$DA10` | 1 | 1 | 0 | 04:2 | `copied_marker_xy (§2)` |
| `$DA11` | 1 | 1 | 1 | 04:3 | `copied_marker_xy (§2)` |
| `$DA12` | 1 | 5 | 0 | 04:6 | `copied_marker_timer (§2)` |
| `$DA13` | 0 | 2 | 1 | 04:3 | `last_photo_seen (§2)` |
| `$DA16` | 6 | 26 | 0 | 00:1 07:31 | `menu_item (§3)` |
| `$DA17` | 1 | 4 | 0 | 00:1 07:4 | `menu_up_col (§3)` |
| `$DA18` | 1 | 4 | 0 | 00:1 07:4 | `menu_sel_upper (§3)` |
| `$DA19` | 1 | 4 | 0 | 07:5 | `menu_sel_lower (§3)` |
| `$DA1A` | 2 | 0 | 0 | 07:2 | `menu_anim_tick[5] (§3)` |
| `$DA1F` | 2 | 0 | 1 | 07:3 | `menu_anim_frame[5] (§3)` |
| `$DA2E` | 0 | 3 | 0 | 07:3 | `menu_trans_stamp (§3)` |
| `$DA2F` | 1 | 1 | 0 | 07:2 | `menu_item3_phase (§3)` |
| `$DA30` | 1 | 7 | 0 | 07:8 | `menu_state_copy (§3)` |
| `$DA31` | 2 | 6 | 2 | 04:10 | `edge_dir (§4)` |
| `$DA32` | 2 | 4 | 0 | 04:6 | `edge_count (§4)` |
| `$DA33` | 0 | 0 | 1 | 09:1 | `deco_tick[4] (§5)` |
| `$DA37` | 1 | 0 | 1 | 09:2 | `deco_phase[4] (§5)` |
| `$DA38` | 1 | 0 | 0 | 09:1 | `deco_phase[4] (§5)` |
| `$DA39` | 1 | 0 | 0 | 09:1 | `deco_phase[4] (§5)` |
| `$DA3A` | 1 | 0 | 0 | 09:1 | `deco_phase[4] (§5)` |
| `$DA3B` | 15 | 16 | 0 | 09:31 | `kb_cursor (§5)` |
| `$DA3C` | 14 | 7 | 2 | 09:23 | `kb_key (§5)` |
| `$DA3D` | 5 | 10 | 0 | 09:15 | `kb_page (§5)` |
| `$DA3E` | 0 | 0 | 2 | 09:2 | `kb_tab_tick[3] (§5)` |
| `$DA41` | 0 | 2 | 2 | 09:4 | `kb_tab_frame[3] (§5)` |
| `$DA42` | 0 | 2 | 0 | 09:2 | `kb_tab_frame[3] (§5)` |
| `$DA43` | 0 | 2 | 0 | 09:2 | `kb_tab_frame[3] (§5)` |
| `$DA44` | 3 | 0 | 1 | 06:4 | `shoot_fx_vector[5] (§6)` |
| `$DA45` | 3 | 0 | 0 | 06:3 | `shoot_fx_vector[5] (§6)` |
| `$DA46` | 3 | 0 | 0 | 06:3 | `shoot_fx_vector[5] (§6)` |
| `$DA47` | 3 | 0 | 0 | 06:3 | `shoot_fx_vector[5] (§6)` |
| `$DA48` | 3 | 0 | 0 | 06:3 | `shoot_fx_vector[5] (§6)` |
| `$DA49` | 0 | 0 | 6 | 02:5 09:1 | `owner_id (§7)` |
| `$DA4D` | 0 | 0 | 6 | 09:6 | `owner_name (§7)` |
| `$DA56` | 9 | 2 | 0 | 02:1 07:2 09:8 | `owner_gender_blood (§7)` |
| `$DA57` | 0 | 0 | 4 | 09:4 | `owner_birth_year (§7)` |
| `$DA59` | 0 | 0 | 2 | 09:2 | `owner_birth_month (§7)` |
| `$DA5A` | 0 | 0 | 2 | 09:2 | `owner_birth_day (§7)` |
| `$DA5B` | 0 | 0 | 3 | 02:3 | `tag_owner_id (§8)` |
| `$DA5F` | 0 | 0 | 1 | 09:1 | `tag_owner_name (§8)` |
| `$DA68` | 2 | 0 | 0 | 09:2 | `tag_gender_blood (§8)` |
| `$DA69` | 0 | 0 | 1 | 09:1 | `tag_birth (§8)` |
| `$DA6B` | 0 | 0 | 1 | 09:1 | `tag_birth (§8)` |
| `$DA6C` | 0 | 0 | 1 | 09:1 | `tag_birth (§8)` |
| `$DA6D` | 1 | 0 | 0 | 09:1 | `tag_count_a (§8)` |
| `$DA6E` | 1 | 0 | 0 | 09:1 | `tag_count_b (§8)` |
| `$DA6F` | 1 | 0 | 0 | 09:1 | `tag_count_total (§8)` |
| `$DA70` | 0 | 0 | 4 | 09:4 | `tag_comment (§8)` |
| `$DA8E` | 3 | 0 | 0 | 09:3 | `tag_copy_flag (§8)` |
| `$DA8F` | 3 | 1 | 0 | 00:2 02:2 | `tag_image_check (§8)` |
| `$DA90` | 3 | 1 | 0 | 00:2 02:2 | `tag_image_check (§8)` |
| `$DA91` | 8 | 4 | 0 | 09:12 | `cmt_cursor (§9)` |
| `$DA92` | 4 | 1 | 1 | 09:6 | `cmt_grid_cell (§9)` |
| `$DA93` | 3 | 3 | 0 | 09:6 | `cmt_ctrl (§9)` |
| `$DA94` | 4 | 3 | 0 | 09:7 | `cmt_grid_row (§9)` |
| `$DA95` | 1 | 3 | 0 | 04:2 08:1 09:1 | `cmt_photo_index (§9)` |
| `$DA96` | 2 | 0 | 3 | 02:3 06:1 09:1 | `cnt_taken (§10)` |
| `$DA97` | 2 | 0 | 0 | 02:1 09:1 | `cnt_taken (§10)` |
| `$DA98` | 1 | 0 | 1 | 04:1 09:1 | `cnt_erased (§10)` |
| `$DA99` | 1 | 0 | 0 | 09:1 | `cnt_erased (§10)` |
| `$DA9A` | 2 | 0 | 1 | 02:1 07:1 09:1 | `cnt_sent (§10)` |
| `$DA9B` | 2 | 0 | 0 | 02:1 09:1 | `cnt_sent (§10)` |
| `$DA9C` | 2 | 0 | 1 | 00:1 02:1 09:1 | `cnt_printed (§10)` |
| `$DA9D` | 2 | 0 | 0 | 02:1 09:1 | `cnt_printed (§10)` |
| `$DA9E` | 1 | 0 | 1 | 07:1 09:1 | `cnt_recv_a (§10)` |
| `$DA9F` | 1 | 0 | 0 | 09:1 | `cnt_recv_b (§10)` |
| `$DAA0` | 1 | 0 | 1 | 07:1 09:1 | `best_shooter (§10)` |
| `$DAA1` | 3 | 0 | 0 | 02:1 07:1 09:1 | `best_shooter (§10)` |
| `$DAA2` | 2 | 0 | 1 | 02:1 07:1 09:1 | `best_shooter (§10)` |
| `$DAA3` | 3 | 0 | 2 | 02:1 07:3 09:1 | `best_shooter (§10)` |
| `$DAA4` | 1 | 0 | 1 | 05:1 09:1 | `best_ball (§10)` |
| `$DAA5` | 3 | 0 | 1 | 02:1 04:1 05:1 09:1 | `best_ball (§10)` |
| `$DAA6` | 2 | 0 | 1 | 09:3 | `best_run (§10)` |
| `$DAA7` | 3 | 0 | 1 | 02:1 09:3 | `best_run (§10)` |
| `$DAAB` | 3 | 1 | 0 | 00:1 08:3 | `print_intensity (§10)` |
| `$DAAC` | 0 | 0 | 2 | 04:2 | `del_cx[16] (§11)` |
| `$DABC` | 0 | 0 | 2 | 04:2 | `del_cy[16] (§11)` |
| `$DACC` | 0 | 0 | 3 | 04:3 | `del_x[16] (§11)` |
| `$DADC` | 0 | 0 | 2 | 04:2 | `del_y[16] (§11)` |
| `$DAEC` | 0 | 0 | 4 | 04:4 | `del_angle[16] (§11)` |
| `$DAFC` | 0 | 0 | 3 | 04:3 | `del_radius[16] (§11)` |
| `$DB0C` | 0 | 0 | 2 | 04:2 | `del_vel[2][16] (§11)` |
| `$DB2C` | 0 | 0 | 1 | 04:1 | `del_acc[2][16] (§11)` |
| `$DB4C` | 2 | 5 | 0 | 04:7 | `del_done (§11)` |
| `$DB4D` | 0 | 4 | 1 | 00:1 08:4 | `print_src_table[4] (§12)` |
| `$DB4E` | 0 | 4 | 0 | 08:4 | `print_src_table[4] (§12)` |
| `$DB4F` | 0 | 4 | 0 | 08:4 | `print_src_table[4] (§12)` |
| `$DB51` | 0 | 0 | 2 | 08:2 | `print_src_table[4] (§12)` |
| `$DB5B` | 0 | 0 | 1 | 06:1 | `print_src_table[4] (§12)` |
| `$DB5D` | 0 | 0 | 1 | 00:1 | `print_src_table2[4] (§12)` |
| `$DB61` | 0 | 0 | 1 | 08:1 | `print_src_table2[4] (§12)` |
| `$DB6D` | 2 | 5 | 0 | 00:2 06:1 08:4 | `print_layout_type (§12)` |
| `$DB6E` | 1 | 5 | 0 | 00:1 06:1 08:4 | `print_return_idx (§12)` |
| `$DB6F` | 1 | 5 | 0 | 00:1 06:1 08:4 | `print_pages (§12)` |
| `$DB70` | 0 | 0 | 2 | 00:2 | `print_band_desc[40] (§12)` |
| `$DBC0` | 1 | 2 | 0 | 00:3 | `print_script_off (§12)` |
| `$DBC1` | 1 | 2 | 0 | 00:3 | `print_script_off (§12)` |
| `$DBC2` | 0 | 1 | 1 | 00:2 | `print_band_no (§12)` |
| `$DBC3` | 1 | 1 | 1 | 00:3 | `print_page_no (§12)` |
| `$DBC4` | 1 | 2 | 0 | 00:3 | `print_first_page (§12)` |
| `$DBC5` | 2 | 3 | 0 | 00:5 | `print_last_page (§12)` |
| `$DBC6` | 2 | 3 | 0 | 00:5 | `print_last_band (§12)` |
| `$DBC7` | 0 | 1 | 1 | 00:2 | `print_progress_step (§12)` |
| `$DBC8` | 0 | 1 | 0 | 00:1 | `print_progress_step (§12)` |
| `$DBC9` | 0 | 1 | 1 | 00:2 | `print_progress_acc (§12)` |
| `$DBCA` | 0 | 1 | 0 | 00:1 | `print_progress_acc (§12)` |
| `$DBCB` | 3 | 5 | 0 | 04:2 08:6 | `print_layout_flag (§13)` |
| `$DBCC` | 2 | 5 | 0 | 04:2 08:5 | `border_normalised (§13)` |
| `$DBCD` | 2 | 2 | 0 | 04:4 | `del_variant (§11)` |
| `$DBCE` | 1 | 2 | 0 | 07:3 | `link_setup_done (§1)` |
| `$DBCF` | 3 | 12 | 0 | 00:1 03:1 04:4 06:2 07:5 09:2 | `result_msg_id (§13)` |
| `$DBD0` | 0 | 1 | 0 | 00:1 | `printer_prev_status (§14)` |
| `$DBD1` | 0 | 1 | 0 | 00:1 | `printer_prev_status (§14)` |
| `$DBEC` | 0 | 0 | 2 | 00:2 | `printer_len_table (§14)` |
| `$DBFE` | 0 | 0 | 2 | 00:2 | `printer_dc0c_table (§14)` |


### Update after the v3 trace (callbacks proven live)

The bank 7 callbacks `07:7AF1-7B43` and the transition helpers `07:7BF4-7D30` are reached through the 6-byte-entry tables at `07:7985-7AD3` and are rooted by `tools/extra_roots.json`. The accesses of `$DA1A`, `$DA1F`, `$DA24`, `$DA29` and `$DA2E` are therefore on proven-live code; their status is raised from I to C (the on-screen meaning remains an inference).
