# WRAM $D600-$D7FF map

**Coverage.** All 165 addresses of this range that appear in `wram_summary.csv` lie inside a table row below (arrays and tables are one row with a size; the per-address access counts and the row that covers each address are in the appendix). Status of the 165 addresses (= status of the covering row): **C 156**, **I 4**, **U 5**, **? 0**. Twelve of the C addresses (`$D60D`, `$D641`, `$D642`, `$D675`, `$D7D2`, `$D7E3`, `$D7E4`, `$D7E9`, `$D7EB`, `$D7EE-$D7F1`) are code-traced as to data flow but keep an open sub-question about what the value *looks like on screen* or what an inferred step does; they are collected under "Still inconclusive". Rows are in address order; section titles name the bank(s) that use the sub-range.

## Overlay structure

Only one *mode bank* is active at a time (`$D5CE` = mode, `$D5CF` = state, both dispatched with `rst $18` tables), and boot clears `$C000-$DFFE` once (00:0181-0187). Nothing clears `$D600-$D7FF` when a mode ends, so each mode initialises the bytes it uses in its first states and the range is reused as follows (banks 2, 3, 4, 5, 6, 7, 8 all touch it; banks 0, 9 and 0A do not write it):

| Sub-range | Bank / mode that uses it | Role |
|---|---|---|
| `$D600` | bank 6, mode `$17` | layout flag of the 4-photo / 2-photo composition screen |
| `$D602-$D614` | bank 4, modes `$10` (pen) and `$11` (stamp) | cursor position + velocity, pen option panel, stamp palette focus |
| `$D615-$D642` | bank 4, mode `$11` (stamp) | stamp category, per-category page / item memory, rotation timer |
| `$D643-$D660` | **shared, banks 2/3/4** | hotspot block of the current photo (mirror of SRAM slot bytes F36-F53) |
| `$D661-$D66C`, `$D66E-$D672` | bank 3 mode `$1A` (hotspot editor), bank 3 mode `$0C` (hotspot viewer), bank 7 save routine `07:699C` (with banks 3/4 as callers) | edit copies, cursors, pickers, save-dialog parameters |
| `$D66D` | banks 3, 4, 5 | shared "modified" flag (decides whether leaving an editor asks to save) |
| `$D673` | bank 3 mode `$12` | auto-fill option |
| `$D674-$D675` | banks 4, 6, 7, 8 | two choice cursors, a different meaning in each bank |
| `$D678-$D679` | bank 7 mode `$02` | animated-background frame / speed mask |
| `$D67A` | banks 4, 8 | "who launched this tool" code |
| `$D67B-$D67E` | bank 4 modes `$09` / `$0A` | photo-number slider |
| `$D680-$D6E3` | **shared, banks 2/3/4** | slide-show (animation) list mirror of SRAM 1000-1060 |
| `$D6E4-$D72D` | bank 3 mode `$12` | coroutine contexts, cursor and player state of the slide-show editor |
| `$D73D-$D7BC` | bank 3 mode `$12` | 16 spark sprites (position / velocity words) |
| `$D7BD-$D7C0` | bank 3 modes `$13` (`$D7BD`, `$D7BE`), `$05` (`$D7BF`), `$04` (`$D7C0`) | player pause / music, decoration-sprite X counter, blink hold |
| `$D7C1` | **shared, banks 2/3/4/8** | border (frame) number, mirror of SRAM slot byte F54 |
| `$D7C2-$D7D6` | bank 7 mode `$0D` | two wandering sprites; options and timer of the auto-play viewer |
| `$D7D7-$D7FF` | bank 6 modes `$14-$18` ( $D7D8-$D7DB: bank 4 mode `$01`) | SHOOT state: timer, options, burst list, compose screens |

**Buffers that mirror SRAM (all three are loaded / saved by bank 2).** (1) Hotspot block `$D643-$D660` = 30 bytes of the photo slot footer (slot bytes `F36-F53`): `02:4D88` (raw read, `HL=$AF36+slot`), `02:4DD7` (read + conversion of the 5 jump targets with `$15ED`), `02:4832` (raw write) and `02:488F` (write, conversion back with `$1600`); stock pictures (number >= `$1E`) come from the ROM table `02:5218`. (2) Slide-show data `$D680-$D6E3` = SRAM `1000-1060` (list 47 + loop flag, timing 47, speed, border), not per photo: `02:4EAE` / `02:4EE8` (load; the second converts the 47 entries slot -> photo number with `$15ED`), `02:49A8` / `02:4A07` (save, `$1600`). (3) Border `$D7C1` = slot byte `F54`: `02:4E31` (load, photo >= `$1E` -> default `$12`), `02:48F7` (save). Nothing else in this range is persistent. **Arrays indexed by album slot:** none live here (the per-slot tables are in `$D563+`, see the d500 file); the only slot numbers in this range are *values* (list entries `$D681[]`, hotspot jump targets `$D65C[]`, `$D671`, `$D7EE/$D7F7/$D7F9` photo numbers). The two 20-byte arrays `$D615/$D629` are indexed by *stamp category*, not by photo.

**Bank 4, mode `$11` (04:56F9) = stamp tool.** State 2 (04:5733) initialises the cursor at (64,56) and loads the category graphics; the user moves a stamp cursor with the D-pad (04:5D92, about 1 px per frame), holding A for 3 s runs bit-transposition routines on the stamp bitmaps (04:5E4C-5FE1; a 90-degree rotation, inferred; timer `$D641`), releasing A stamps it into the picture with the software blitter 00:1EA4 (04:5FE2; sets the dirty flag `$D66D`), Start or pushing against the picture edge for 10 frames opens the palette (state 3, 04:596D) in which Left/Right change page (`$D63E`), the D-pad moves in the stamp grid (`$D63F`) and moving onto the category column (`$D614`) lets Up/Down change category (`$D63D`, 17 categories; category 3 only if the CoroCoro flag `$D582` = 1). The last page and stamp of each category are remembered in `$D629[cat]` / `$D615[cat]` for the next visit (no other bank writes them, so they survive mode changes but not a reset). B leaves (state 5) or, when `$D66D` is set, goes through the bank-7 save dialog (states 6-8, `$D66E-$D671`).

**Bank 4, mode `$10` (04:604B) = pen tool.** Same skeleton (init 04:6089, drawing state 3 = 04:618D, option panel states 4-6, exit states 7-10) but a floating pen with inertia: 8.8 fixed-point position `$D602-$D605` and velocity `$D606-$D609`, updated by 04:6454 at a rate chosen by the speed option `$D60B`; A held draws the brush (blit data selected by size `$D60C` and pattern `$D60D`) at the cursor and sets `$D66D`. The option panel has three rows (size 4 choices, pattern 4, speed 3) navigated with `$D610` (row), `$D611` (focus), `$D612` (item), `$D613` (row shown).

**Bank 4, modes `$09` / `$0A` / `$0F` / `$01`.** Mode `$09` (04:683F) is the photo-option menu of the album: a photo-number slider (`$D67B-$D67E`, `$D5EE`) and four directional sub-menus: Left (04:6AC0, choice `$D674`: 0 = pen mode `$10`, 1 = stamp mode `$11`), Right (04:6B72, choice `$D675`: far calls 08:4DF2 / 09:4281), Up (04:6BF5: mode `$1C`, print) and Down (04:6C94: mode `$0F`, erase viewer); mode `$0A` (04:7488) is the same with the photo fixed (`$D5ED`). Before jumping to a tool they set `$D67A` to 1 (mode `$09`) or 2 (mode `$0A`) so the tool knows where to return (04:4C0B, 04:5CF8, 04:6389, 08:45B5). Mode `$01` (04:6F96, main menu) has three pages (states 0/2/4); each loads graphics and a tile-map pointer `$D7D9-$D7DB` for 00:0DA0.

**Bank 3 (modes `$12`, `$13`, `$1A`, `$0C`, `$04`, `$05`).** Mode `$12` (03:4000, 35 states) is the *slide-show (animation) editor*, not an owner-registration screen: it edits the 47-entry list `$D681` with timing / loop markers `$D6B2` (cursor `$D717/$D718`, Select menu `$D719`, range editing `$D71B-$D71E`), runs three cooperative drawing contexts (`$D6E4-$D714`, switched by 03:5649), previews the entry under the cursor after a short delay (`$D72B`) and draws spark sprites (`$D72C-$D7BC`); mode `$13` (03:5FA0) plays the show (`$D725-$D72A`, `$D7BD`, `$D7BE`). Mode `$1A` (03:69F5) edits the five hotspots of a photo (`$D643` block, working copies `$D661-$D664`, pointer `$D665-$D668`, number picker `$D669/$D66A`, dialogs `$D66B/$D66C`), mode `$0C` (03:6310) is the viewer that tests the pointer position against the hotspots. Dirty flag `$D66D` and the save-dialog parameters `$D66E-$D671` are shared with banks 4/5/7. Modes `$04` (03:7AA8) and `$05` (03:7BFD) use only `$D7C0` (cursor blink hold) and `$D7BF` (decoration sprite X).

**Bank 6, modes `$14-$18` (SHOOT).** `$D7DC-$D7FF` (+ `$D600`) are the working set of the shooting modes: `$14` (06:5DE6, live view / shot), `$15` (06:4000, self-timer and interval parameter screens), `$16` (06:44D9, option screens), `$17` (06:4C9F, photo composition), `$18` (06:598E, 4-photo list). `$D7E3` is the shooting *variant* (0 plain, 1 self-timer, 2 interval, 3-`$0B`, `$0C-$12`, `$13/$14` = 4-shot sequences, `$15`), `$D7DC-$D7E2` the countdown (frames / seconds / minutes derived from `$FFC9` deltas), `$D7E9-$D7EC` the four options of the option cross (shared with `$D674` as working copy), `$D7ED/$D7EE` the burst list, `$D7F3-$D7FF` cursor animation and photo pickers of the compose / list screens.

**Bank 7 (mode `$02`, mode `$0D`, save routine).** Mode `$02` (07:51AC) is a two-choice screen with a background tile-map animation (`$D678/$D679`, choice in `$D5EC`, next mode `$0A` or `$0B`). Mode `$0D` (07:6B03) is an *auto-play viewer*: a hub screen with two randomly wandering animated sprites (`$D7C2-$D7D1`, stepped by 07:6C10 / 6CCB / 6CF9), two options chosen with the working cursors `$D674` / `$D675` and committed to `$D7D2` / `$D7D3`, then a photo show with interval `$D7D4` (`$D7D5` countdown, `$D7D6` direction) that picks the next photo at random or in sequence (`$D5FC`, 07:7138). The save routine 07:699C takes its parameters from `$D66E-$D671` (shared with banks 3 and 4).

**Bank 8 (print).** Mode `$1C` (08:40F8) uses `$D674` as a 0/1 option cursor (08:452C, 08:4489), `$D67A` as return code (08:4128 / 08:45B5) and `$D7C1` as the border being picked (08:4F45-4FA0 Left/Right, 08:4EF9 shows `$D7C1+1` as two digits, 08:5037 loads it; a value `$12` is replaced by 0 and `$DBCC` := 1 at 08:4231-423E and 08:4825-4832).


### A. $D600-$D642 - bank 6 compose layout ($D600) + bank 4 pen / stamp tool state (modes $10 / $11)

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$D600` | 1 | compose_layout | u8 0/1 | 06:4E24-4E37 (Left -> 0, Right -> 1, written through HL=$D600, sound $19), reads 06:4D7F, 06:4E02, 06:4E45 | Mode $17 (06:4C9F, photo-composition screen): 0 = four-photo layout (2x2: photos $D7F9-$D7FC, tile builders 06:5414/5491/5512/5593, drawn at 06:4D85-4DB2), 1 = two-photo layout (photos $D7F7/$D7F8, 06:5614/5657). A/Start goes to state 2 (4-up picker) or state $0A (2-up picker) accordingly (06:4DF4-4E10). Zero at boot (00:0181-0187 clears $C000-$DFFE). Never touched by bank 4: the old "album state" reading of $D600 is wrong. | C |
| `$D602` | 1 | cursor_x_frac | u8 (fraction of d603) | 04:5733 / 04:6089 (:=0 at tool entry), 04:5D92-5DDD (modes $11: += / -= $FF), 04:6517-6529 (mode $10: += velocity) | Low byte (1/256 px) of the 16-bit X position of the pen / stamp cursor; $D603 is the integer part. Position pairs are little-endian words (frac, int): $D602/$D603 = X, $D604/$D605 = Y. Used by modes $10 (pen) and $11 (stamp) only. | C |
| `$D603` | 1 | cursor_x | u8 px (init $40) | 04:5766 / 04:60BC (:=$40), 04:5D80 / 04:6421 / 04:65FE / 04:5FF6 (read: sprite X = d603+$10; blit origin), 04:5E05-5E3A and 04:6546-657B (clamp) | Integer X (pixels inside the 128x112 image) of the pen / stamp cursor; starts at $40 = mid image. Clamped each frame by a (min,max) table: stamp mode 04:5648 (4 bytes per category, range $F0..$70 or so, i.e. may stick out of the picture by up to 16 px), pen mode 04:657C (per brush size: X $FF..$81, Y $FF..$71 for size 0). When the clamp bites it sets the edge flag $DA31 (mask $60 / $90), which after 10 frames of pushing opens the palette / option panel (04:5C64-5C73, 04:61A7-61B6). | C |
| `$D604` | 1 | cursor_y_frac | u8 | 04:5733 / 04:6089 (:=0), 04:5D92, 04:6517 | Fraction byte of the cursor Y position (see $D602). | C |
| `$D605` | 1 | cursor_y | u8 px (init $38) | 04:576B / 04:60C1 (:=$38), 04:5D86 / 04:6441 / 04:662C / 04:5FFC (read, sprite Y = d605+$10) | Integer Y of the pen / stamp cursor; starts at $38 = mid image. | C |
| `$D606` | 2 | cursor_vx | mode $11: u8 code; mode $10: s8.8 velocity | mode $11: 04:5D9E-5DB7 (writes), 04:5DCB-5DE9 (reads); mode $10: 04:6483-64E2 (accelerate / brake), 04:651E, 04:650F-6516 (clear 4 bytes) | X velocity. Mode $11 (stamp, 04:5D92): one byte at $D606 = $00 (key released), $FD (Right held) or $FE (Left held); the position is moved by +$00FF or -$00FF (about 1 px per frame) in 04:5DC8-5DEA ($D607 is skipped, never used). Mode $10 (pen, 04:6454): a signed 8.8 word $D606/$D607: Left subtracts, Right adds the step b (table 04:658C, entry [$D60E]: b=$0D), clamped to +-$00FF (04:649A / 04:64AF); with no horizontal key the magnitude decays by c=1 per update (04:64B9-64E2). | C |
| `$D608` | 2 | cursor_vy | same format as $D606 | 04:5778 / 04:60CE (:=0), 04:5DF1, 04:652D-6531, 04:64E3-64F6 | Y velocity, same as $D606: $D608 byte code for mode $11 (Down held = $FD, Up held = $FE via the swap code at 04:5DB9-5DC6), signed word $D608/$D609 for mode $10 ($D609 is read at 04:652D). | C |
| `$D60A` | 1 | pen_idle_timer | u8 0..3 | 04:64FE (:=3 while any direction key is held), 04:6503-650A (decrement), 04:6510 (clear velocities at 0) | Mode $10 (pen): 3 while a direction key is held; counts down to 0 once the keys are released, then the four velocity bytes $D606-$D609 are cleared (04:650F-6516). So the pen glides for 3 updates after release and then stops dead. | C |
| `$D60B` | 1 | pen_speed | u8 0..2 | 04:6263 (commit from $D612 in the 3rd option page, state 6 = 04:6248), 04:6454-6460 (throttle test), 04:6805/682D (page display), 04:67F7 | Third option row of the pen panel. Throttles the pen update: 0 = every frame, 1 = every 2nd frame ($FFC8 bit 0 clear), 2 = every 4th frame ($FFC8 & 3 == 0) (04:6454-6469). Default (never initialised): 0 at boot. | C |
| `$D60C` | 1 | pen_size | u8 0..3 | 04:61F9 (commit from $D612 in the 1st option page, state 4 = 04:61DE), 04:6421 / 04:6538 / 04:6615 / 04:6633 / 04:6772 (read) | First option row of the pen panel: brush size / shape, 4 choices. Selects the cursor sprite pair 04:644C ($2B/$2C, $2D/$2E, $2F/$30, $31/$32 alternating every 8 frames), the clamp limits 04:657C, the blit offset (dx,dy) table 04:6648 and the brush bitmap row (with $D60D) of table 04:6650 passed to the software blitter 00:1EA4 (04:6641-6644). Boot value 0. | C |
| `$D60D` | 1 | pen_pattern | u8 0..3 | 04:622E (commit from $D612 in the 2nd option page, state 5 = 04:6213), 04:6630-663B, 04:67BB / 04:67E3 | Second option row: brush pattern (4 variants per size): the blit data pointer is table[04:6650 + 4*[$D60C] + [$D60D]] (04:6630-6644). Which texture each variant is: ? (data are bitmaps, not rendered here). | C |
| `$D60E` | 1 | pen_ramp_index | u8 (const $38) | 04:60D6 (:=$38, only write), 04:646F (read) | Index (x2) into the speed table 04:658C used by the pen update (04:646F-647D: c = friction, b = acceleration). Always $38 -> entry (c=$01, b=$0D). The other 56 entries (decreasing from $FF/$FF) are never selected by proven code: leftover of a variable-speed design. | C |
| `$D60F` | 1 | pen_keys | u8 | 04:6480 (:= [$FFA1]), 04:6486 / 04:64E6 (read) | Copy of the held-button byte $FFA1 taken at the start of a pen update; decoded in 04:6486-64F4 (bits 5/4 horizontal, 7/6 vertical). | C |
| `$D610` | 1 | pen_menu_row | u8 0..2 | 04:60D1 (:=0), 04:62BF-62FE (Up/Down), 04:6715 (select panel), 04:66F9 | Pen option panel (opened from the drawing state 3 = 04:618D with Start, or by pushing the cursor against the picture edge for 10 frames, 04:61A1-61BC): which of the 3 rows (size / pattern / speed) is highlighted. Up = dec (stops at 0), Down = inc (stops at 2); 04:66F9 then loads the panel for that row and switches to state 4, 5 or 6. | C |
| `$D611` | 1 | pen_menu_focus | u8 0/1 | 04:627D-62CE (tests, set 1 at 04:62B8 when Right is pressed on the last item, cleared at 04:62CE on Left), 04:61EA / 04:621F / 04:6254 (A ignored while 1), 04:630C | Panel focus: 0 = cursor inside the item strip of the current row ($D612), 1 = cursor on the row selector ($D610). A is only accepted when 0. | C |
| `$D612` | 1 | pen_menu_item | u8 0..max | 04:6291-62B2 (Left/Right), 04:62DC, 04:679D / 04:67E6 / 04:6830 (:= current value of the row), 04:61F6 / 04:622B / 04:6260 (read on A) | Highlighted item inside the current row (limit = table 04:6309 by row: 3, 3, 2). On A the code stores it into $D60C / $D60D / $D60B (04:61F9, 04:622E, 04:6263). | C |
| `$D613` | 1 | pen_menu_page | u8 0..2 | 04:67A1 (:=0), 04:67EB (:=1), 04:6835 (:=2), 04:6283 / 04:62D1 / 04:6312 / 04:6328 (read) | Which row (page) is currently expanded: written by the three page builders 04:6764 (size), 04:67AD (pattern), 04:67F7 (speed); selects the item count (04:6309) and the cursor sprite position table 04:6354. | C |
| `$D614` | 1 | stamp_palette_focus | u8 0/1 | 04:577C / 04:5BB4 (:=0), 04:5C22 (:=1), reads 04:5973, 04:59F7, 04:5B4D, 04:5BA1 | Mode $11 palette (state 3 = 04:596D): 0 = cursor in the stamp grid, 1 = cursor on the category column (set when the key table entry has code 3 at 04:5C1C-5C25; cleared by A or B, 04:5BA7-5BB4). While 1, Up/Down change $D63D (04:5979-59E7). | C |
| `$D615` | 20 | category_pos_A[20] | u8[20] | 04:5733 (load), 04:596d (save/load), 04:5cc1 | Per-category saved value, index = $D63D (category 0..16). Copied to $D63F when a category is entered (04:57c5, 04:59df) and written back from $D63F on Up/Down (04:5994). | C |
| `$D629` | 20 | category_pos_B[20] | u8[20] | 04:5733, 04:596d, 04:5cc1 | Same, second array; copied to/from $D63E (04:57bd, 04:59d7, 04:598c). | C |
| `$D63D` | 1 | category_index | u8 0..16 | 04:596d, 04:589e, 04:5b4d, 04:5ba1, 04:5922 | Current category (17 categories: tables of 3-byte (lo,hi,bank) at 04:539d/53d0/5403 have 17 entries). Up = dec (stops at 0), Down = inc (stops at $10); value 3 is skipped unless [$D582]==1. | C |
| `$D63E` | 1 | stamp_page | u8 0..max | 04:57C2 (load from d629[cat]), 04:59DC, 04:5BEF / 04:5C11-5C17 (Left/Right), 04:589E (read), 04:5C04-5C0F (limit), 04:562D-563D (P: reads) | Current page of stamps inside the category $D63D: 04:589E uploads the page graphics (base = table 04:5337 + $D63E * page size) to VRAM $8A00 / $8510. Left = dec to 0, Right = inc up to table 04:55FA[cat] (or $D642 for category 2). Saved to d629[cat] on category change and on exit (04:5994, 04:5CD1). | C |
| `$D63F` | 1 | stamp_item | u8 | 04:57CA (load from d615[cat]), 04:59E4, 04:5C30-5C34 (+= signed step from the key table 04:5584[cat]), 04:5A8B (bitmap select), 04:5B79 / 04:5BCB (cursor position) | Currently selected stamp inside the category (absolute index, not page-relative; the page-relative position is $D63F minus the page base from 04:5C36 / table 04:560B). 04:5A73 copies bitmap number $D63F of the category into the working buffers $C000.. / $C1E0.. and $C3C0.. / $C5A0.. (04:5A3E-5B49) and 04:5FE2 blits it into the picture when A is released. | C |
| `$D640` | 1 | stamp_return_state | u8 (always 4) | 04:5CB8 (write [$D5CF] = 4 from state 4), 04:5D5C (read) | State to return to when the save dialog launched by B in the placement state (04:5CAC-5CBD) is cancelled: only written in state 4 so it always holds 4; the comparison with 3 at 04:5D5F (go back to the palette) can therefore never be true. Cosmetic generality. | C |
| `$D641` | 1 | stamp_rotate_timer | u8 180 / 100 | 04:5A17 / 04:5FE9 (:=$B4 at entry and when A is released), 04:5E3B-5E48 (decrement while A held; reload $64), rotate routines 04:5E4C-5FE1 | Hold-A countdown of the placement state: $B4 = 180 frames after each stamp / palette close; while A is held it counts down and when it reaches 0 it is reloaded with $64 (100 frames) and routines 04:5E85 / 04:5EF8 / 04:5F6B rotate the 4 working bitmaps (bit shuffles that transpose each 8x8 tile: a 90 degree turn) and re-upload them to VRAM $8A00 / $8520. So holding A rotates the stamp: first after 3 s, then every 1.7 s. The "rotation" reading is I (the shift/rotate sequences are code-traced, the visual result is inferred). | C |
| `$D642` | 1 | stamp_page_limit_c2 | u8 4..9 | 04:5832 (write: min([$DAA5],5)+4), 04:5C04 (P: used as limit when category = 2) | Highest page index of category 2 of the stamp palette: depends on the owner-profile byte $DAA5 (clamped to 5, plus 4). For the other categories the limit comes from the ROM table 04:55FA. What $DAA5 holds (owner data shown as 2 digits by 09:5390): ? . | C |

### B. $D643-$D664 - hotspot block of the current photo (mirror of SRAM slot F36-F53) - banks 2/3/4

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$D643` | 30 | hotspot_block | 5 x 6 arrays | 02:4d88 (read raw), 02:4dd7 (read, jump conv), 02:4832/488f (write), 02:452a, 03:6bc1.., 04:4b62 | Mirror of SRAM slot bytes F36-F53 (30 bytes). d643[5] enabled flags, d648[5] X, d64d[5] Y, d652[5] sound, d657[5] effect, d65c[5] jump target (photo number in RAM, slot index in SRAM). | C |
| `$D661` | 1 | hs_edit_sound | u8 0..3F/FF | 03:6c15 (load from d652[i]), 03:6cf5 (store back), 03:6be3 (new: FF) | Hotspot editor (mode $1A) working copy of the selected hotspot sound (0..63, $FF = off); loaded by 03:6c0a, committed by 03:6ceb. | C |
| `$D662` | 1 | hs_edit_effect | u8 0..6/FF | 03:6c1d, 03:6cfd, 03:6beb | Working copy of the selected hotspot visual effect (d657[i]). | C |
| `$D663` | 1 | hs_edit_jump | u8 | 03:6c25, 03:6d05, 03:6bf3 | Working copy of the jump-target photo (d65c[i]); $FF = none. | C |
| `$D664` | 1 | hs_is_new | u8 0/1 | 03:6c06 (:=1 when a hotspot is created, 03:6bc1), 03:6c29 (:=0 when an existing one is loaded), 03:6d09 (tested) | "hotspot just created" flag: decides which state follows the value dialogs (03:6cd6-6cde: 0 -> state 3, 1 -> state 4). | C |

### C. $D665-$D67E - hotspot-editor / save-dialog bytes (bank 3, 7), choice cursors and caller code (banks 4/6/7/8), photo-number slider (bank 4)

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$D665` | 1 | hs_selected | u8 0..4, FF | 03:6a7f (:=FF), 03:6b31/7231/71be (set), 03:6bc1, 03:6c0a, 03:73a7.. (index into d643/d648/..) | Index (0..4) of the hotspot under the cursor / being edited; $FF = none (03:6b2c, 03:71bc). | C |
| `$D666` | 1 | hs_cursor_mode | u8 0/1 | 03:6a77 (:=1), 03:7220 (:=1 when Down past last row), 03:7271 (:=0 on Up) | 0 = free pointer cursor on the photo grid (03:7117), 1 = cursor on the 5-slot hotspot list (03:7162/7225). | C |
| `$D667` | 1 | cursor_x | u8 0..14 (list: 0..4) | 03:71aa-71b0 (Left/Right clamp 0..$0E), 03:6a6d (init 2), 03:6369 (viewer init 8), 03:7117/7162/649b (sprite X = 8*x+$18), 03:72df (hit test vs d648[i]) | Pointer cell X (grid of 15 columns, cell = 8 px) used by hotspot editor (mode $1A) and hotspot viewer (mode $0C). In list mode (d666=1) it indexes the 5 hotspot slots (03:71c9-71d5 reduces it modulo 3 -> row). | C |
| `$D668` | 1 | cursor_y | u8 0..12 | 03:71b3-71b9 (Up/Down clamp 0..$0C), 03:6a72 (init 12), 03:636e (viewer init 7), 03:72e9 (hit test vs d64d[i]) | Pointer cell Y (13 rows). Sprite Y = 8*y+$20. | C |
| `$D669` | 1 | picker_scroll_phase | u8 0..$12 step 2 | 03:7573 (write 03:7596), 03:75b0 (+/-2), 03:74a0 | Phase of the scrolling number picker of the hotspot value dialogs: Up/Down starts a scroll, 03:75b0 steps it by 2 per frame and increments/decrements the edited value ([HL] = d661/d662/d663 or d652+i/d657+i/d65c+i) when it wraps through 0/$12. | C |
| `$D66A` | 1 | picker_dir | u8 ($40/$80) | 03:7579 (latch of $FFA1&$C0), 03:7589 | Latched direction (Up=$40, Down=$80) of the picker scroll in progress. | C |
| `$D66B` | 1 | picker_button_anim | u8 0/1/2 | 03:6d94 (:=1), 03:6dcf (:=2), 03:6dfc (:=0), 03:7407 | Selects the OK-arrow sprite ($D2 idle/blink, $D3 pressed, $D2/$D3 alternating when 2) in the jump dialog. | C |
| `$D66C` | 1 | dialog_choice | u8 0/1 | 03:6ea4/6f3e (Left -> 0, Right -> 1), 03:6e0e, 03:6eea, 03:6ba3 (:=0), 03:6e8c (:=1) | Left/Right choice of the 2-option confirm dialogs of the hotspot editor (State10/State11); tile strip at $9C80 is swapped on change. | C |
| `$D66D` | 1 | dirty_flag | u8 0 / non-zero (bit0 set, or inc, or $B4) | 03: 40a1 (:=0), 4bb4/42f6/41af (set 0), 5d92 (inc), 6ae7 (:=0), 6c03/6e59/6f18 (:=1), reads 413e/4254/434b/5231 (exit -> save prompt $14 if set else main), 6baf; 04: 581a (:=0), 5ca0, 5ff3, 615e (:=0), 61c5, 6612 (:=1); 05: 428d (:=0), 444a | "edited since load" flag shared by the editors of bank 3 (slide-show, hotspots) and read by banks 4/5; tested on leaving the editor to choose between the save dialog and a plain exit. Same meaning in bank 4 (modes $10/$11: set by pen drawing 04:6612 and stamp placement 04:5FF3, cleared at tool entry 04:615E / 04:581A; B tests it at 04:61C5 / 04:5CA0 -> state 8 / 6 = save dialog if set, plain exit if clear) and bank 5 (mode $1F: cleared 05:428D, incremented at 05:5577 when the edited value changes, set at 05:459F; B tests it at 05:444A). It is a generic per-session modified flag; the byte is never saved. | C |
| `$D66E` | 1 | save_dialog_what | u8 bit0/bit1 | 03:6f94 (:=2), 04:5d25 (:=1), 04:63c6 (:=1), 07:6a12/6a62 (read) | Parameter of the bank-7 save routine 07:699c: bit 0 = write the edited image + thumbnail ($47C4, or Game Face $4C37 when [$D800]!=0), bit 1 = write hotspot block ($488F). | C |
| `$D66F` | 1 | save_dialog_scratch | u8 | 07:69d8, 07:6a93 (:=0) | Written 0 at dialog init, never read. | U |
| `$D670` | 1 | save_dialog_result | u8 0/FF | 07:6ac3 (0 if A pressed, $FF if B), 03:6fb1, 04:5d42, 04:63e3 (read) | Result of the bank-7 save dialog: 0 = confirmed (saved), $FF = refused/cancelled; bank 3 then goes to state $0C (exit) or back to state 3 (03:6fb1-6fbf). | C |
| `$D671` | 1 | save_target_photo | u8 | 03:6f9a (:=[$D5F8]), 04:5d2b, 04:63cc (write), 07:69ac/6a03/6a49/6a68 (read; >=$1E -> refuse) | Photo slot/number to which the bank-7 save routine writes. | C |
| `$D673` | 1 | autofill_mode | u8 0..2 | 03:5099 (Left/Right edit), 03:50ba (draw), State29/30/31 | Slide-show editor auto-fill dialog (State29-31): 0 = cancel, 1 = fill list from cursor with 0,1,2.. up to [$D561] photos (03:5154), 2 = same then shuffle (03:51a1, 10 swaps with rand $09D4). Left/Right clamp 0..2 (03:50a1-50ae); State29 init 0 (03:5068). | C |
| `$D674` | 1 | choice_cursor_a | u8 0/1 (bank 6: 0..5) | 04: 685F / 74F9 (:=0), 04:7817-7829 (Up -> 0, Down -> 1), reads 04:6AF7 / 6B56 / 779C / 77FB / 7832; 06: option cross working value (writes 06:65CC / 6623 / 667A / 66D5 / 685D / 692B / 6A6B, reads 06:674A..6AAD); 07: 6DA3 (load), 6E1F / 6E8B / 6E99; 08: 4545, 4508, 44F6, write 453A | Working cursor of a two-or-more-way choice, re-used by four banks (each with its own meaning): bank 4 modes $09 / $0A, Left sub-menu (04:6AC0 / 04:7765): Up / Down select 0 or 1; on A: 0 -> mode $10 (pen), 1 -> mode $11 (stamp) (04:6B56-6B71, 04:77FB-7816). Bank 6 (SHOOT option cross): copy of the option being edited ($D7EA / $D7EC / $D7EB / $D7E9), committed on A, dropped on B. Bank 7 mode $0D: working copy of $D7D2 (state 3, 07:6E7D-6E98). Bank 8 (print option screen, 08:4489): Left / Right toggle 0 / 1, then state 9 / $0C. | C |
| `$D675` | 1 | choice_cursor_b | u8 0/1 | 04: 685F / 74F9 (:=0), 04:78FC-791A (Left/Right), reads 04:6BA8 / 6BE3 / 78AF / 78EA; 07: write 6DA9, reads 6F31 / 6FB0 | Second choice cursor. Bank 4 modes $09 / $0A, Right sub-menu (04:6B72 / 04:7879): on A, 0 -> state 8 (far call 08:4DF2), 1 -> state $0B (far call 09:4281) (04:6BE3-6BF4; what those two sub-programs are: ?). Bank 7 mode $0D: working copy of $D7D3 (state 4). | C |
| `$D678` | 1 | bg_anim_frame | u8 0..7 | 07:51CC (:=0 in mode $02 state 0), 07:5376-537C (inc, direction [$D5EC]=0), 07:5381-5387 (dec, direction [$D5EC]=1) | Mode $02 (07:51AC): frame 0..7 of the animated background. Each step uploads 384 bytes ($180) of tile map from the 8 three-byte (lo,hi,bank) pointers at 07:53A6 (bank:address 26:55C0, 27:63F0, 27:6570, 23:7E80, 19:7E60, 27:66F0, 27:6270, 27:60F0) to VRAM $9840 (07:538A-53A5). Runs forward while the left choice [$D5EC]=0 is selected and backward for the right choice, so the picture appears to scroll in the direction of the highlighted choice. | C |
| `$D679` | 1 | bg_anim_mask | u8 $07/$03/$0F | 07:51D1 (:=$07), 07:5317 (:= $03 while Up held, $0F while Down held, else $07), 07:536B (P: tested against $FFC8) | Speed of the mode-$02 background animation: the frame advances when ([$FFC8] AND mask) == 0: every 8 frames normally, every 4 with Up, every 16 with Down (07:5304-5317, 07:5369-536F). | C |
| `$D67A` | 1 | caller_code | u8 0/1/2 | writes: 04:4674 (mode $0F state 0), 04:5720 (mode $11 st.0), 04:6073 (mode $10 st.0), 08:4128 (mode $1C st.), :=1 at 04:6B4F / 6C7C / 6D25 (mode $09), :=2 at 04:77F4 / 79E5 / 7AC5 (mode $0A); reads 04:4C0B / 4C5A (mode $0F state 7), 04:5CF8 (mode $11 exit), 04:6389 (mode $10 exit), 08:45B5 (mode $1C exit) | Return address code for the photo tools (modes $0F erase viewer, $10 pen, $11 stamp, $1C print): 0 = launched from the main menu path (exit returns to state 0 of the same mode, i.e. the photo picker), 1 = launched from the photo option menu mode $09 (exit: mode $09 state 0), 2 = launched from mode $0A (exit: D5DF := 1, mode $0A state 2). Cleared in the first state of each tool; modes $09 / $0A set it just before jumping into state 2/5 of a tool, which skips that clearing. | C |
| `$D67B` | 1 | slider_timer | u8 (0..$B4) | 04:6880 (:=0 mode $09), 04:7504 (:=$B4 mode $0A), 04:6EA6 / 04:6F58 (:=$40), 04:6EA9-6ECC (dec), 04:7C6C-7C72 (dec, mode $0A) | Frame countdown of the photo-number slider: mode $09 reloads it with $40 after every move / arrival (the pointer sprite is drawn in its moving form while it is non-zero, then switches to the blinking arrow, 04:6EA9-6EC7); mode $0A uses 04:7C6C to flicker a sprite ($0E at random +-1 px, RNG $08F9) for $B4 = 180 frames after entry. | C |
| `$D67C` | 1 | slider_target | u8 0..$3A (even) | 04:6F37 (write, = 2*photo, wraps $3C -> 0, below 0 -> $3A), 04:6E81 / 04:6EFD (read) | Mode $09 (04:6911): target position of the photo-number slider = 2 x photo number (30 photos, $3C = wrap). Set by Left / Right (key-repeat byte $FFA7 bits 5/4, 04:6F11-6F37) together with D5EE. | C |
| `$D67D` | 1 | slider_pos | u8 0..$3A | 04:6F3F / 04:6F49 (write), 04:6E84-6E93 (step +-1 toward $D67C each frame), 04:6F00 (P) | Displayed slider position: moves one unit per frame toward $D67C (04:6E81-6E93); when it arrives D5EE := $D67D>>1 (04:6E9A-6E9C), $D67E := 1, $D67B := $40. The sprite X = 4*D5EE + $17 (04:6EAF-6EB8), y = $86, 4 frames $09-$0C animated by $FFC8 bits 3-4. | C |
| `$D67E` | 1 | slider_redraw | u8 0/1 | 04:687D (:=0), 04:6EA1 / 04:6F53 (:=1 on arrival / key), 04:691A (test), 04:6940 (:=0); mode $0A: 04:74FF (:=0), 04:7596 (test), 04:75E5 (:=0) | Request to redraw the photo and the "x/30" counter after the slider settled (mode $09 state 1: 04:691A-6943 reloads the photo with 02:5110 and redraws). In mode $0A the same flag is tested at 04:7596 but nothing ever sets it, so that branch is dead (U in mode $0A). | C |

### D. $D680-$D714 - slide-show (animation) list mirror of SRAM 1000-1060 + bank-3 coroutine contexts

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$D680` | 1 | anim_list_guard | u8 | 02:4eae, 02:4ee8 (write 0 after loading list) | Cleared to 0 when the slide-show list is loaded; no proven reader (the byte just below the list). Likely just a guard. | U |
| `$D681` | 47 | anim_list[47] | u8[47] | 02:4eae/4ee8 (SRAM 1000..102E -> RAM), 02:49a8/4a07 (RAM -> SRAM), 02:452a (delete photo: entries == deleted slot -> $FE), 03:5599/54f4/4115/4c7f..., 04:4e30 | Slide-show entry i = photo number (bit 7 = album B = stock pictures, value+$1E for bank-2 helpers 03:5bdc), $FE = empty, $FF = end. Mirror of SRAM 1000-102E. 4ee8 converts each entry through $15ED ([$D563+n], slot index -> photo number) and 4a07 back through $1600; the raw pair 4eae/49a8 is only used by 02:452a. | C |
| `$D6B0` | 1 | anim_loop_flag | u8 0/FF | 03:42b4 (toggle xor $FF, State04), 03:5691 (glyph), 03:4e16/6280 (loop at end of list), 02:49a8 | Slide-show "repeat" flag = SRAM 102F (0 / $FF). Copied raw by 02:4ee8 / 4a07 as 48th byte of the list. | C |
| `$D6B1` | 1 | anim_timing_guard_lo | u8 | 02:4ed4/4f13 (:=$FF), 03:5d76, 03:48f6 (bit 6 test via d6b1+idx) | Sentinel $FF in the byte before the timing array (not stored in SRAM); read through HL (bit 6) when moving the range end left (03:48f6). | I |
| `$D6B2` | 47 | anim_timing[47] | u8[47] | 02:4eae/4ee8 (SRAM 1030..105E), 02:49a8/4a07, 03:5337 (draw), 03:4b84.., 03:4cd1, 03:4d43, 03:6292 | Per-entry timing marker: 0 = none; range start = $80+t, interior = t, end = $40+t (t = repeat 1..50): bit 7 start, bit 6 end, low 6 bits t. Draw routine 03:5337 turns the three kinds into glyph tiles $A4/$A5/$A6 (03:534f-536a). Player 03:6256-62ba: repeats a range t times via $D727/$D728. | C |
| `$D6E1` | 1 | anim_timing_guard_hi | u8 | 02:4ed7/4f16 (:=$FF) | Sentinel $FF after the timing array (bit 6 stops the scan loops 03:4b8d/4bd4); not stored in SRAM. | I |
| `$D6E2` | 1 | anim_speed | u8 0..99 | 02:4ede/4f1d (SRAM 105F), 02:49df/4a43, 03:41d0..41e9 (Up/Down wraps 0..99), 03:5d53 (shows 99-value), 03:4de3/624d (frame delay) | Slide-show speed: number of frames per entry compared with the player tick $D726. Default 9 after clear (03:5d86). | C |
| `$D6E3` | 1 | anim_border | u8 | 02:4ee1/4f20 (SRAM 1060), 02:49e3/4a46, 03:4da2/51ec/61b0 (-> $D7C1), 03:528d | Slide-show border number (SRAM 1060). Copied to $D7C1 (border to display) when previewing/playing; State34 writes back $D7C1 if the border picker changed it and sets dirty. | C |
| `$D6E4` | 1 | coro_index | u8 0..2 | 03:5649, 03:59af, 03:5614, 03:5900 | Index of the running cooperative context (0..2). | C |
| `$D6E5` | 48 | coro_context[3x16] | 3 x (5 words + pad) | 03:5649/03:59af (save+restore), init 03:5614/03:5900 | Context switcher used by the slide-show editor to run 3 drawing/animation routines. A call to 03:5649 pushes AF,BC,DE,HL, copies HL,DE,BC,AF and the return address (5 words, 10 bytes) into ctx[d6e4] = $D6E5/$D6F5/$D705, increments d6e4 mod 3 (waits one frame, 08A4+rst 08, when it wraps) and pops the next context from its slot (reading backwards from $D6EF+16*idx) then returns into it. Only 10 of the 16 bytes of each slot are used. | C |
| `$D6ED` | 2 | ctx0_ret | u16 (code ptr) | 03:5614 ($5691), 03:5900 ($59F7) | Saved return address of context 0 = start of the grid/list drawer ($5691) in editor mode, or $59F7 when 03:5900 re-initialises it. | C |
| `$D6EF` | 6 | ctx0_pad | - | 03:5649 (P: end pointer) | Unused tail of context-0 slot ($D6EF-$D6F4); likewise $D6FF-$D704 and $D70F-$D714. | U |
| `$D6FD` | 2 | ctx1_ret | u16 (code ptr) | 03:5614 ($57BE), 03:5900 ($5A7A) | Context 1 start = title banner animation loop at $57BE (never returns). | C |
| `$D70D` | 2 | ctx2_ret | u16 (code ptr) | 03:5614 ($5847), 03:5900 ($5B00) | Context 2 start = second animation loop at $5847. | C |

### E. $D715-$D7C0 - bank 3 slide-show editor scratch, spark-sprite arrays, player state

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$D715` | 1 | spr_x_tmp | u8 | 03:5691/59f7 (write), 03:5700 (read) | Scratch sprite X offset (register B) passed to the OAM metasprite adder 00:24AF (B added to X byte, C to Y byte, 00:24D5-24D9). | C |
| `$D716` | 1 | spr_y_tmp | u8 | 03:56c3/5a04 (write), 03:5711 (read) | Scratch sprite Y offset (register C of 00:24AF). | C |
| `$D717` | 1 | cur_entry_value | u8 | 03:5394, 03:54f4 (Left/Right changes it), 03:5bc9 (thumbnail), 03:5c9a | Value of the list entry under the cursor (= [$D681+cursor]): photo number, bit 7 = album B, $FE empty. | C |
| `$D718` | 1 | cur_entry_index | u8 0..2E (+bit 7) | 03:5599, 03:4115.., 03:5d00 | Cursor position in the list (0..$2E, 47 entries, 16 columns, 3 rows; 03:5599-5613: Left/Right +-1, Up/Down +-$10, off-the-edge returns carry). Bit 7 = entry picked up: set by State01 when A is pressed (03:412D, set 7,[hl]) and cleared by State02 when A is released (03:4173, res 7,[hl]); while it is set the entry value $D717 is being changed with Left/Right (03:54F4). Cleared by 03:5D9B (list init) and rewritten by 03:46BD / 03:49BA (cursor jumps). | C |
| `$D719` | 1 | editor_menu_option | u8 0..4 | 03:44a2 (Left/Right), 03:44c3, 03:448e (jump table at 03:449d: states 09,1D,10,11,1A) | Select-button menu of the slide-show editor (State07/08): option -> next state (timing 09, auto-fill 1D, tidy 10, play 11, clear all 1A). | C |
| `$D71B` | 1 | editor_range_mode | u8 0/1 | State01 (:=0), State09 (:=1), 03:53fd (picks cursor tables 54C4/54DC), 03:5d94 | 0 = list editing, 1 = timing/loop-range editing. | C |
| `$D71C` | 1 | range_anchor | u8 | State09/10/11/12/13, 03:48d8 | Index where the loop range was started (A press in State09, 03:4555). | C |
| `$D71D` | 1 | range_moving_end | u8 | 03:48d8, State10..13 | Other end of the loop range being edited (moved with Left/Right). | C |
| `$D71E` | 1 | range_direction | u8 0/1/$FF | 03:4559 / 456F (:=0), 03:4581 (:=1), 03:4955-4979 in 03:48D8 (recomputed after every move of the end), reads State10-13 (03:45EF, 463A, 4679, 483A-487C, 4A85, 4B3E) | Side of the moving end $D71D relative to the anchor $D71C: 0 = end after the anchor, 1 = end before it, $FF = end == anchor (03:4955-4971: cp [$D71C]). State10-13 use it to pick the marker sprite animation and the direction of the timing-marker redraw. | C |
| `$D71F` | 4 | range_cursor_xy | u8[4] | 03:45cc/462f/4992/49ac (write), 03:46f6/4720 (read via hl=$D71F+idx), 03:48c1 | Two range-marker sprites: X at $D71F/$D720, Y at $D721/$D722 (b=[d71f+i], c=[d71f+i+2], 03:470e-4715). Positions = (index&15)*8+16, (index&$F0)+$5A..$5F. | C |
| `$D723` | 2 | range_anim_done | u8[2] | 03:4720 (clear/inc), 03:45e9, 03:466f | Per-marker "animation finished" flags polled by State10 (03:45e9, 03:466f). | C |
| `$D725` | 1 | play_entry | u8 | 03:4d37/4e46/6141/62b0, 03:531e | Entry value currently shown by the slide-show player/preview (passed to bank-2 $5110 via $FF9E at 03:531e). | C |
| `$D726` | 1 | play_tick | u8 | 03:4de0/624a, 03:4d1b, 03:611a | Frame counter since the last entry change; compared with speed $D6E2 (03:4de3, 03:624d). | C |
| `$D727` | 1 | play_loop_start | u8 | 03:4d4b/4e39/6155/62a3 | Index of the first entry of the loop range being repeated. | C |
| `$D728` | 1 | play_loop_count | u8 | 03:4d1e/4dfd/4e04/6267 | Repeat counter of the current range (compared with the low 6 bits of the end marker). | C |
| `$D729` | 1 | play_flags | u8 bit0 | 03:4d58/4e0c/4e33/6162/6276 | bit 0 = range end reached (jump back to loop start on next entry); init 1 or 0 depending on whether entry 0 starts a range. | C |
| `$D72A` | 1 | play_done | u8 | 03:4d21/4dda/4e1f/6286 | Non-zero when the whole list has been played (then the player waits for B). | C |
| `$D72B` | 1 | preview_wait | u8 0..6, FF | 03:5bca, 03:5c2d-5c3c, 03:5c68 | Preview delay counter of the slide-show editor: reset to 0 whenever the cursor moves (03:5BC9); 03:5C2D increments it each frame; when it equals 5 the preview of the entry under the cursor is loaded by bank 2 02:517B into $C000.. and uploaded to VRAM $9100 (03:5C40-5C83). The load is interruptible (00:2656 returns carry when a key press arrives): then the counter is cleared again and the current keys $FFA7-$FFA9 are copied to $FFA1-$FFA3 so the interrupting press is not lost (03:5C67-5C77). After the load it keeps counting up to $FF and stops (no further loads). Cleared by 03:5DB0. | C |
| `$D72C` | 1 | spark_ring_idx | u8 0..15 | 03:5e1a | Next slot of the 16-entry spark ring buffer (incremented and masked, 03:5e21-5e27). | C |
| `$D72D` | 16 | spark_life[16] | u8[16] | 03:5e1a (:=$20), 03:5eea (dec, draw while !=0), 03:5d94/5e0f (clear) | Remaining frames of each spark sprite (tiles $7B/$7C at 03:5f0f/5f15, y offset table $5F1B). | C |
| `$D73D` | 32 | spark_x[16] | s8.8 LE | 03:5e1a, 03:5ec7 (+= $D77D), 03:5eea (high byte $D73E+2i read) | Spark X position, 16 words little-endian 8.8 fixed point (integer part at $D73E+2i). | C |
| `$D75D` | 32 | spark_y[16] | s8.8 LE | 03:5e1a, 03:5ec7, 03:5eea ($D75E+2i) | Spark Y position. | C |
| `$D77D` | 32 | spark_vx[16] | s8.8 LE | 03:5e1a (computes (target-x)/32), 03:5ec7 | Spark X velocity. | C |
| `$D79D` | 32 | spark_vy[16] | s8.8 LE | 03:5e1a, 03:5ec7 | Spark Y velocity (end of range $D7BC). | C |
| `$D7BD` | 1 | player_pause | u8 0/FF | 03:623d (read), 03:62d6 (cpl on Start) | Slide-show player (mode $13) pause flag toggled by Start ($FFA8 bit 3). | C |
| `$D7BE` | 1 | player_music | u8 0..31 | 03:6025/604c (Select: +1 and $1F), 03:6089 (shows d7be+1 as 2 digits), 03:602b/605b/61e9 -> 00:2A4B with table $61FD | Number of the sound/music of the slide show, edited with Select (wraps at 32) and played through 00:2A4B; not saved in SRAM (never written outside bank 3). | I |
| `$D7BF` | 1 | sprite_x_counter | u8 free-running | 03:7d9f (inc [hl], then used as X of sprite $E7); callers 03:7c7f, 03:7d05 | Free-running X position of the bank-3 mode $05 (03:7BFD) decoration sprite: 03:7D9F (called from 03:7C7F and 03:7D05) increments it on every call and, when $FFC8 bit 3 is set, draws sprite $E7 at X=[$D7BF], Y=$3F with 00:24AF. Never initialised by proven code (starts from whatever was there, 0 after boot). | I |
| `$D7C0` | 1 | blink_hold | u8 0..$20 | 03:7ac9 (:=0), 03:7b90 (dec), 03:7bdc (:=$20) | Mode $04 (2-option screen, option in $D5F0): countdown after a cursor move; while non-zero the cursor sprite blinks (drawn only if $FFC8 bit 3). | C |

### F. $D7C1-$D7D6 - border number (shared) and the state of bank 7 mode $0D

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$D7C1` | 1 | border_number | u8 | 02:4e31 (load from SRAM F54; >=$1E photo -> $12), 02:48f7 (store to F54), 03:4da5/51ef/61b3 (:= $D6E3), 03:528d, 08:5037 border loader, 08:4f12.. | Border (frame) number of the current photo / slide show; NOT a one-shot signal. Corrects README. | C |
| `$D7C2` | 2 | actor_frame[2] | u8[2] | 07:6B37 (cleared with $D7C3..$D7C9 by a 8-byte loop), 07:6C1A / 07:6C6A (P) | Mode $0D hub screen (07:6BBB): index of the current frame of each of the two wandering sprites inside the animation table at 07:6C7B (pairs: sprite code, duration; $FF = loop marker followed by the restart frame). Updated by the animation stepper 07:6C10; the sprite is placed with 00:2496. | C |
| `$D7C4` | 2 | actor_tick[2] | u8[2] | 07:6C1F / 07:6C6F (P) | Ticks spent in the current frame; compared with the duration byte of the table (07:6C3C-6C3E); reset to 0 when the frame changes. | C |
| `$D7C6` | 2 | actor_phase[2] | u8[2] | 07:6C61 (P, += speed [$D7CE]) | 8-bit phase accumulator: each frame it adds the actor speed $D7CE; a carry out (07:6C65-6C69) adds one tick to $D7C4. So the animation rate is speed/256 ticks per frame. | C |
| `$D7C8` | 2 | actor_cycle_flag[2] | u8[2] | 07:6C14 (P, cleared each update), 07:6C4A (P, inc when the animation wrapped), 07:6CCE (P, tested) | Set (non-zero) for one update when an actor completes its animation loop; the random speed changer 07:6CCB runs only then. When the loop restarts there is a 1-in-5 chance ([$08F9] < $32) of going back to frame 0 instead of the loop-back frame stored after the $FF marker. | C |
| `$D7CA` | 2 | actor_x[2] | u8 px (init $20,$70) | initialised from ROM 07:6BB3 by 07:6B40-6B4A, read 07:6C2F, random walk 07:6D06-6D1C (P) | X position of the two sprites; each does a random walk of -1,0,0,+1 per frame (07:6CFC-6D1D) and is confined to $10..$30 (first actor) and $60..$80 (second) by the limit bytes at 07:6D40-6D43. | C |
| `$D7CC` | 2 | actor_y[2] | u8 px (init $36,$36) | ROM init 07:6BB3, 07:6D28 / 07:6D35 (P) | Y position of the two sprites; random walk as above, confined to $2E..$3D. | C |
| `$D7CE` | 2 | actor_speed[2] | u8 (init $55,$55) | ROM init 07:6BB3, 07:6CEE (P: random value, at least $55), 07:6C5C (P read) | Animation speed (added into the phase accumulator $D7C6); re-rolled to a random value >= $55 each time the speed timer expires. | C |
| `$D7D0` | 2 | actor_speed_timer[2] | u8 (init 5,5) | ROM init 07:6BB3, 07:6CD6-6CE4 (P: dec, reload rand AND 7 + 2) | Counts animation loops (decremented only when $D7C8 is set) until the speed is re-rolled; reload value 2..9. | C |
| `$D7D2` | 1 | play_opt_a | u8 0/1 | 07:6E22 (commit from $D674 on A in state 3), 07:6DA0 (load into $D674), reads 07:6EE0, 07:70BE, 07:7169 | Mode $0D (07:6B03, auto-play viewer): first option (screen opened with Up in state 2; Left/Right toggle $D674; A commits). 0: background music $21 starts (07:70BE-70CB) and nothing else; 1: music is silenced ($FF) and after every photo bank-2 routine 02:4E5F loads the photo metadata record (54 bytes from the slot footer, or the ROM table for stock pictures, to $DA5B-$DA90) and 00:16F4 splits $DA8F/$DA90 into four digits $DD03-$DD06 and plays sound $10 (07:7169-717E), i.e. the picture code is shown / spoken. Reset: 0 at boot, kept between plays. | C |
| `$D7D3` | 1 | play_opt_b | u8 0/1 | 07:6F34 (commit from $D675 on A in state 4), 07:6DA6, reads 07:6FF7, 07:7078, 07:7138 | Second option (Down in state 2): 0 = next photo is a random one in [0,$D561) (RNG via 00:09D4 / $08F9) at every interval; 1 = sequential: $D5FC += $D7D6 with wrap inside 0..$D561-1 (07:7138-7154). | C |
| `$D7D4` | 1 | play_interval | u8 1..$FA (init $3C) | 07:7089 (:=$3C when the show starts), 07:70E2 (reload source), 07:7196-71AB (Up = dec to 1, Down = inc to $FA, key-repeat $FFA7) | Frames between two photos of the auto-play show (60 = 1 s at start); adjustable while playing: Up shorter, Down longer. | C |
| `$D7D5` | 1 | play_countdown | u8 | 07:708C (:=$3C), 07:70DC (dec), 07:70E5 (reload from $D7D4) | Frame countdown to the next photo; at 0 it is reloaded from $D7D4 and 07:7138 selects and shows the next photo. | C |
| `$D7D6` | 1 | play_direction | s8 $01 / $FF | 07:7091 (:=1), 07:7190 (:=$FF on Left, $01 on Right via $FFA8 bits 5/4), 07:7141 (P, read) | Step of the sequential mode: +1 or -1 (Right / Left pressed during the show). | C |

### G. $D7D7-$D7FF - bank 6 SHOOT state (modes $14-$18), bank 4 main-menu bytes ($D7D8-$D7DB)

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$D7D7` | 1 | shoot_init_flag | u8 | 06:5F62 (write 1 in mode $14 state 0) | Written 1 once per SHOOT entry, no proven reader anywhere. | U |
| `$D7D8` | 1 | menu_page_shadow | u8 0/1/2 | 04:6FCA (:=0), 04:709A (:=1), 04:7141 (:=2) | Write-only: the main menu (mode $01) has three pages loaded by states 0, 2 and 4 (04:6FB2, 04:708E, 04:7135); each stores its page number here and then passes the same number in A to 04:73EF. No reader anywhere: the byte is redundant. | U |
| `$D7D9` | 3 | menu_map_ptr | 3 bytes (lo,hi,bank) | 04:741A-7422 (write from the page table 04:7436 after the $FF terminator of each page list), 04:7479-7481 (read -> 00:0DA0) | Far pointer of the background tile map of the current main-menu page (page 0: 24:60A0, page 1: 23:7040, page 2: 26:7BC0). Stored by the page loader 04:73EF and used by 04:7479 which calls the tile-map drawer 00:0DA0 (HL = pointer, A = bank). $D7D9 = low, $D7DA = high, $D7DB = bank. | C |
| `$D7DC` | 1 | timer_running | u8 0/1 | 06:5E4B (:=0), 06:6035 (test), 06:608F-6094 (toggle on A when variant 1), 06:60A9 (:=1 when variant 2), 06:6378/637C, 06:63AC/63B0, 06:64DE/6504 (:=0), 06:7283, 06:720E (test) | Countdown flag of the SHOOT timer: self-timer (variant $D7E3=1: A toggles it) and interval shooting (variant 2: set to 1 at the first shot). 06:720E does nothing while it is 0. | C |
| `$D7DD` | 1 | timer_last_vbl | u8 | 06:609A, 06:60AE, 06:6378, 06:63AC, 06:64F6, 06:6500 (write = [$FFC9]), 06:720E-721C (read, then updated) | Snapshot of the VBlank counter $FFC9 (incremented once per frame in the VBlank handler, 00:0328-032B). 06:720E computes c = $FFC9 - [$D7DD] = frames elapsed since the previous call and subtracts them from the countdown. | C |
| `$D7DE` | 1 | timer_frames | u8 0..59 | 06:7159 (:=0), 06:723B-7241 (sub c, borrow +$3C), 06:7220 (test), 06:724F | Low byte of the 3-byte countdown $D7DE-$D7E0: frames (1/60 s units, borrow at 60). Together with $D7DF (seconds) and $D7E0 (minutes) it is zeroed when it underflows (06:724E-7255). Timer expired when all three are 0 (06:6041-6045, 06:7220-7224). | C |
| `$D7DF` | 1 | timer_seconds | u8 0..59 | 06:7160/7170 (init), 06:7170 (:= [$D7E6] self-timer), 06:718x (interval table), 06:7242-7249, 06:70DE (display) | Middle byte of the countdown: seconds. For variant 1 initialised to the self-timer delay [$D7E6]; for variant 2 to the interval [$D7E7] (1..14 s as is, 15..24 -> 15,20,..,60 s via 5*n-60, 06:7189-7195). | C |
| `$D7E0` | 1 | timer_minutes | u8 0..60 | 06:7185 (init from table 06:7199 = 5,10,15,30,60), 06:7245-724B, 06:70CA-70F4 (display) | High byte of the countdown: minutes; only used for the interval choices >= 25 (index 25..29 -> 5,10,15,30,60 min). The display routine 06:70CA shows minutes (glyph strip $4BE0) when non-zero, else seconds (glyph strip $4950). | C |
| `$D7E1` | 1 | timer_beep_acc | u8 0..14 | 06:7159 (:=0), 06:7225-7235 | Frames accumulated since the last countdown beep; when it reaches 15 the code plays sound $0B (06:722E: ld a,$0B / call $2A7C) and clears it: a tick sound every 15 frames while the timer runs. | C |
| `$D7E2` | 1 | shots_left | u8 | 06:5E51-5E54 (:= [$D7E8] at SHOOT entry), 06:60A2 (test), 06:64D7 (dec), 06:64E1-64EE (reload min(30-[$D561], [$D7E8])), 06:7106 (display) | Interval shooting (variant 2): number of pictures still to be taken. A press is ignored when it is 0 (06:60A2-60A6). After each capture it is decremented; at 0 the timer stops ($D7DC := 0) and it is reloaded with min(free album slots, $D7E8). | C |
| `$D7E3` | 1 | shoot_variant | u8 0..$15 | writes only 06:4019 (0), 06:415C (1), 06:4369 (2), 06:496C (3..$15); 30 reads in bank 6 (06:5E2F, 5FB1, 5FFE, 604D-607A, 6296, 6317, 634D-63A0, 6462, 6493, 64D0, 6522, 6779, 6937, 69F9, 6A7A, 6B25, 6CEF-6D2B, 6E06, 7166, 719E, 738F, 7804) | Shooting variant chosen before mode $14 starts: 0 = plain shot (mode $15 state 0 sets it), 1 = self-timer (mode $15 state 4 on A), 2 = interval shooting (mode $15 state 9 on A), $03+d5e5 (3..$0B, 9 choices), $0C+d5e7 (7 choices), $13/$14 = $13+(d5e9^1) (4-shot sequences, 06:6317, 63BC/63FA), $15 = fourth menu item (06:496A). Mode $14 state 9 (06:6B25) returns to the screen that launched it using table 06:6B4A: variant 0 -> mode 1 state 0, 1 -> mode $15 state 1, 2 -> mode $15 state 5, >=3 -> mode $16 state 1. Entry routes: mode $15 state 0 (plain shot) is the first main-menu item (table 04:7084 = (15,0)); states 1 (self-timer) and 5 (interval shooting) are the two items of the third page of the main menu, selected by [$D5E1] through the data table 04:71B1 = (15,1),(15,5) (04:719C-71AD; found only as data, the tracer lists it as non-proven bytes). What each variant looks like on screen: ? (only the dispatch is traced). | C |
| `$D7E4` | 1 | shoot_phase | u8 0..3 | 06:5E4E (:=0), 06:6346 (:=0 on A in state 2), 06:71E7-7205 (A: +1 up to max c, B: -1), 06:738F/7804 (index), 00:1569 (read, variant $15) | Step within a multi-step variant: the maximum c comes from the variant (06:719E: 1 for variants $0C,$0D,$0E,$10,$12; 2 for $11; 3 for $0B,$0F,$15; no stepping for the others). [$D7E3]*4+[$D7E4] indexes the 88-byte table at 06:60DB (one byte per variant/phase) which selects (a) the routine of the jump table 06:73AF (image-region operations on $C000/$C080/$C700/$C780, 7 or 14 tile rows) and (b) with [$D7EB] the argument of the bank-0A call 0A:7CFE. For variant $15 bank 0 routine 00:1569 masks the image buffer region chosen by [$D7E4] (pointer table $15E5) with a mask from bank $27 ($5BB0). What the phases look like on screen: ? | C |
| `$D7E6` | 1 | selftimer_delay | u8 1..25 | 06:40B1 (:=5 at mode $15 state 1), 06:40C2-40EB (Left/Right edit, limits 1..25 via 06:44BC), 06:7166-7173 (copied to $D7DF) | Self-timer delay in seconds (default 5) edited on the first mode-$15 screen (states 1-4), shown as 2 digits (06:43BC). | C |
| `$D7E7` | 1 | interval_index | u8 0..29 | 06:41F4 (:=0 at mode $15 state 5), 06:4222-4256 (edit: limits 0..$1D, Left/Right; auto-repeat only below $18), 06:7174-7199, 06:42CC, 06:4311 | Interval choice of interval shooting: index into the display table 06:4289 = 0..15 (seconds), 20,25,30,35,40,45,50,55,60 (seconds), then 5,10,15,30,60 (minutes). The countdown value is derived by 06:7159: 1..14 s direct, 15..24 -> 5*n-60 s, >=25 -> minutes from 06:7199. | C |
| `$D7E8` | 1 | interval_shots | u8 0..30 | 06:4209 (:= 30-[$D561] = free album slots at mode $15 state 5), 06:42A7-42C3 (Left/Right 0..free), 06:5E51, 06:64E7 | Number of pictures to take in interval shooting; default = number of free album slots; also the reload value of $D7E2. | C |
| `$D7E9` | 1 | shoot_effect_sel | u8 0..5 | 06:5E29 (:=0), 06:6A55-6A6B (Left/Right clamp 0..5), 06:6A35-6A53 (commit from $D674 on A), 06:6C51/6C54 (-> $DA44-$DA48), 06:66D2, 06:69ED | Fourth option of the SHOOT option cross (Down key, state 8 = 06:69B4): selects one of 6 five-byte vectors at 06:6C74 that 06:6C54-6C72 copies to $DA44-$DA48. Those bytes are read by the image-region routines 06:747F-7784 (XOR masks per bit plane = colour inversion, plane exchange). Meaning on screen (negative/positive, mirror ...): I (6 choices, value 0 = all zero = no processing). | C |
| `$D7EA` | 1 | shoot_ramp_sel | u8 0..2 | 06:5E44 (:= 2 for variants $0A,$0B,$15 else 1), 06:5E47 (-> $D59C), 06:65C9 (menu preset), 06:6740-6753 (commit from $D674, also -> $D59C), 06:6769-678E | First option of the SHOOT option cross (Left key, state 5 = 06:66F6; a 3-position selector, Up = 2 or 1, Down = 0, 06:6769-678E). The value is copied to $D59C (camera dither mode: 0 = flat fill, 1 = ramp A, else ramp B, read at 0A:42F9) and to $D674 when the menu opens. | C |
| `$D7EB` | 1 | shoot_capture_sel | u8 0..2 | 06:5E26 (:=0), 06:6915-692B (Left/Right clamp 0..2), 06:68F5-6913 (commit from $D674 on A), 06:6677, 06:77F3 | Third option of the SHOOT option cross (Up key, state 7 = 06:68B2). 06:77F1 ORs 0/$20/$40 (for 0/1/2) into the byte table[06:60DB + variant*4 + phase] and passes it in $FF9E to 0A:7CFE -> 0A:5406 (jump table of capture/processing routines). What the three settings mean photographically: ? . | C |
| `$D7EC` | 1 | shutter_sound | u8 0..4 | 06:6620 (menu preset), 06:6840-6845 (commit from $D674), 06:6847-6860 (Up/Down clamp 0..4), 06:7838 (play) | Second option of the option cross (Right key, state 6 = 06:67E2): shutter-sound choice. 06:7838 plays entry [$D7EC] of the 4-entry (sound id, channel) table at 06:7845 = ($28,1) ($06,3) ($05,3) ($03,4) through 00:2A4B (writes the id into $DD60/$DD68/$DD70/$DD78); value 4 = no sound (06:783B). Called when a picture is taken (06:6047-604A, 607A..). | C |
| `$D7ED` | 1 | burst_count | u8 0..3 | 06:5E2C (:=0), 06:63BC/63FA (inc mod 4), 06:6009, 06:6B76, 06:6CF6, 06:6D07, 06:6DAD, 06:6DD3 | Number of pictures already taken in the current 4-shot sequence (variants $13/$14); wraps to 0 after the fourth, which ends the sequence (state 9). Also the ring index into $D7EE. | C |
| `$D7EE` | 4 | burst_photos[4] | u8[4] photo numbers, bit 7 = none | 06:63D2-63DA, 06:6410-6418 (store [$D561]-1 = just-taken photo at index $D7ED), 06:6DB6/6DDC (read latest for the preview strip), mode $18: 06:5A0A, 06:5AE0, 06:5B2D-5BBE, 06:5C9C | Array $D7EE-$D7F1 (only $D7EE and $D7F1 appear in the access table; the middle two are reached through HL). Mode $14 stores into it the number of each photo of a 4-shot sequence. Mode $18 (06:598E) shows the four, lets the user change each with Up/Down (value $FF = empty; wraps at $1E+[$D562]) and, on A, packs them (06:5AE0: loop over $D7F1 down to $D7EE, far call 02:517B per entry) into the 4-byte records at $DB4B-$DB5B and the count in $DB6F for the print mode ($1D). Zero at boot (so all four read as photo 0 until written); no initialisation to $FF was found. | C |
| `$D7F3` | 1 | cursor_anim_frame | u8 | 06:4A79-4A94 | Mode $16 (option screens): frame counter of the pulsating cursor sprite: [$D7F3]&3 selects the sprite template from the table at 06:4A9B ($30,$31,$32,$31, each held 9 ticks); incremented when [$D7F4] reaches the hold time. | C |
| `$D7F4` | 1 | cursor_anim_tick | u8 | 06:4A8B-4A97 | Tick counter of that animation: compared with the hold byte (9) of the current frame; reset to 0 on advance, incremented every call. | C |
| `$D7F5` | 1 | compose4_cursor | u8 0..3 (bit0 row, bit1 column) | 06:4E62-4F28 (Up/Down toggle bit 0, Left/Right toggle bit 1), 06:4EAC, 06:4EBA, 06:4F2C (sprite position table 06:4F4B) | Mode $17 four-photo layout (d600=0), state 2: which of the four quadrants is selected; A jumps to the picker state of that quadrant (table 06:4ED9 = states 3,4,5,6). | C |
| `$D7F6` | 1 | compose2_cursor | u8 0/1 | 06:51DD-5204 (Left/Right), 06:51AE, 06:51BC | Mode $17 two-photo layout (d600=1), state $0A: which of the two pictures is selected; A jumps to state $0B/$0C (table 06:51DB). | C |
| `$D7F7` | 2 | compose2_photos[2] | u8[2] | 06:4DC4, 06:4DCD (read), 06:5172-51B8 ([$D7F7+[$D7F6]]), 06:522B, 06:5266, 06:5614 / 06:5657 (reducers), 06:57C3, writes through HL in states $0B/$0C | Photo numbers (0..$1D own, $1E+n stock) of the two pictures of the 2-up layout; edited with the picker 06:5750 (Up = +1, Down = -1, wrap at $1E+[$D562], reading $FFA9 key-repeat). Zero at boot, never re-initialised by bank 6. | C |
| `$D7F9` | 4 | compose4_photos[4] | u8[4] | 06:4D85-4DA0, 06:4F56/4F8E/4FC9/5004 (pickers, write through HL), 06:5414/5491/5512/5593, 06:5871-588C | Photo numbers of the four quadrants of the 4-up layout (top-left, top-right, bottom-left, bottom-right = $D7F9,$D7FA,$D7FB,$D7FC as read by the builders 06:5414, 5491, 5512, 5593; the low-WRAM map (`wram_lowwram`) maps them to $C000/$C080/$C700/$C780 pieces at 06:5871). Same picker and wrap as $D7F7. | C |
| `$D7FD` | 1 | sel_cursor_tick | u8 | 06:5BFF-5C35, 06:5C45-5C7B, 06:599A (:=0) | Mode $18: tick counter of the 3-frame selection-cursor animation (sprites $54,$55,$56, 5 ticks each; table 06:5C3E / 06:5C84). | C |
| `$D7FE` | 1 | sel_cursor_frame | u8 0..2 | 06:5C0E-5C73, 06:599A (:=0) | Mode $18: current frame of that animation (0..2; the table is terminated by $FF, then the frame restarts at 0). | C |
| `$D7FF` | 1 | sel_slot | u8 0..3 | 06:5B2D-5B3E / 06:5B96-5BA7 (Left/Right move, max 3), 06:5BFF/5C45 (cursor position table 06:5C36 / 06:5C7C), 06:599A (:=0) | Mode $18: which of the four photo slots of $D7EE is selected (cursor at (x,y) = (8*..)); Up/Down changes the photo number of that slot. | C |

## Corrections to the previous README

1. **"$D600-$D643 - bank $004 (VIEW/Album) core state / the album browser's central bookkeeping" is wrong.** `$D600` is a bank-6 (SHOOT, mode `$17`) layout flag; `$D602-$D614` is the cursor / option state of the *pen* (mode `$10`) and *stamp* (mode `$11`) editing tools; `$D615-$D642` is the stamp palette. No album-browser state lives here.
2. **`$D63D` is a stamp category index with 17 values (0..16), not a "3-way selector".** It does not cycle: Up stops at 0 and Down stops at `$10` (04:59AA, 04:59BF). The claim that category 3 only exists when `$D582` = 1 is **confirmed** (04:59AB-59BA, 04:59C3-59D0: the index jumps over 3 otherwise); `$D582` is the CoroCoro flag documented in the d500 file.
3. **`$D615` / `$D629` are not "(min,max) or (count,flags)".** They are the *last selected stamp* and *last palette page* of each category (loaded into `$D63F` / `$D63E` at 04:57BD-57CA and 04:59D7-59E4, written back at 04:5990-599B and 04:5CD1-5CDC).
4. **"$D665-$D72D - bank 3 owner registration / keyboard" is wrong.** Bank 3 mode `$12` is the slide-show (animation) editor, mode `$13` its player, mode `$1A` the hotspot editor, mode `$0C` the hotspot viewer. Owner registration is in bank 9 (it writes `$DA49..`). `$D665-$D67E` are not "dense scalar cursor/field state of a keyboard": `$D665-$D672` are hotspot-editor / save-dialog bytes, `$D674/$D675/$D67A/$D67B-$D67E` belong to banks 4, 6, 7 and 8 (see the overlay table).
5. **`$D681` and `$D6B2` are not keyboard layout table bases.** They are the 47-byte slide-show list (`$D681`, mirror of SRAM 1000-102E) and the 47-byte timing / loop-marker array (`$D6B2`, SRAM 1030-105E); the "pure-pointer" pattern comes from indexing through HL.
6. **`$D7C1` is the border (frame) number, not a "one-shot signal $12".** It is loaded from slot byte F54 (02:4E31), stored back to F54 (02:48F7), copied from the slide-show border `$D6E3` by bank 3 and displayed / edited by bank 8; `$12` is the default for pictures >= `$1E` (02:4E51-4E59). The `cp $12 ... clear, set $DBCC` pattern exists (08:4231-423E, 08:4825-4832) but it only replaces that default border by 0 before printing / displaying.
7. **"$D7D2-$D7FF - bank $006 (SHOOT) ... exclusively" and "zoom / retake-count style state" are not right.** `$D7D2-$D7D6` are bank 7 (auto-play viewer), `$D7D8-$D7DB` bank 4 (main menu), `$D7DC-$D7FF` bank 6 but with no zoom or retake counter: it is the timer (`$D7DC-$D7E2`), the variant `$D7E3` / phase `$D7E4`, the self-timer and interval settings (`$D7E6-$D7E8`), the four option-cross values (`$D7E9-$D7EC`), the burst list (`$D7ED/$D7EE`), and the cursors / photo numbers of the compose and 4-photo list screens (`$D7F3-$D7FF`).
8. `$D7E3` having "30 reads" is right (30 read sites in bank 6) but only 4 write sites exist (06:4019, 06:415C, 06:4369, 06:496C); it is a variant selector, not a counter.

## Still inconclusive

* **Photographic / visual meaning of the SHOOT variants and options.** `$D7E3` values 3-`$15`, the `$D7E4` phases (up to 3), `$D7E9` (6 five-byte vectors copied to `$DA44-$DA48`), `$D7EA` (3-position selector copied to `$D59C`), `$D7EB` (0/`$20`/`$40` added to the table byte passed to 0A:7CFE) and `$D7EC` (4 shutter sounds + off) are code-traced as to dispatch and data flow, but which on-screen choice each one is (image-region operations on `$C000`.. with the XOR masks of 06:6C74 and the bank-0A routines) is not established. Names in the table describe position / data flow only.
* **`$D7EE-$D7F1`** is shown by mode `$18` before any 4-shot sequence has written it; no initialisation to `$FF` was found, so after boot it reads as photo 0 (the table says "zero at boot"). Whether mode `$18` is reachable without a prior sequence was not checked.
* **`$D60D` brush patterns** and **`$D642`** (category-2 page count depends on owner-profile byte `$DAA5`, shown by 09:5390 as a number): what they look like / what the profile byte is, not determined.
* **Bank 4 mode `$09` Right sub-menu (`$D675`)**: the two far-called sub-programs 08:4DF2 and 09:4281 were not analysed.
* **Bank 7 mode `$0D`**: the in-game name, what the two wandering sprites are, and what `$D7D2` = 1 displays (the 4-digit photo code `$DD03-$DD06` + 54-byte record at `$DA5B`) are unverified; `$D7D2/$D7D3` semantics are by data flow only.
* **`$D6B1`, `$D6E1`** (sentinel `$FF` bytes around the timing array) and **`$D7BE`, `$D7BF`** are status I: consistent use, no instruction states the purpose.
* **Write-only / dead**: `$D680` (cleared with the list, never read), `$D66F` (written 0 at dialog init, never read), `$D6EF`-style padding of the context slots (never touched), `$D7D7` (written once per SHOOT entry, never read), `$D7D8` (three writes, no reader), mode `$0A`'s test of `$D67E` (nothing sets it), `$D640` (always 4, so the `cp 3` branch at 04:5D5F is dead), `$D60E` (constant `$38`, the other 56 entries of table 04:658C are unused).
* **Bank 8's use of `$D7C1`** (border picker in the print screens, 08:4EF9-50F6) was only skimmed: reads / writes were located but the print border semantics (which values are printable) were not traced.

## Appendix: every address of the range present in `wram_summary.csv` (165)

Columns: address, covering row (name, start address), status of that row, reads / writes / pointer loads from the summary, banks. All 165 are inside a table row above; the access counts only include code the tracer proved (see README §2.0), so reads through HL/DE/BC are under the base address of the table.

| Address | Row (start) | Status | r | w | p | Banks (bank:count) |
|---|---|---|---|---|---|---|
| `$D600` | compose_layout (`$D600`) | C | 3 | 0 | 1 | 06:4 |
| `$D602` | cursor_x_frac (`$D602`) | C | 0 | 2 | 2 | 04:4 |
| `$D603` | cursor_x (`$D603`) | C | 4 | 2 | 2 | 04:8 |
| `$D604` | cursor_y_frac (`$D604`) | C | 0 | 2 | 2 | 04:4 |
| `$D605` | cursor_y (`$D605`) | C | 4 | 2 | 0 | 04:6 |
| `$D606` | cursor_vx (`$D606`) | C | 2 | 2 | 3 | 04:7 |
| `$D607` | cursor_vx (`$D606`) | C | 1 | 0 | 0 | 04:1 |
| `$D608` | cursor_vy (`$D608`) | C | 2 | 2 | 1 | 04:5 |
| `$D609` | cursor_vy (`$D608`) | C | 1 | 0 | 0 | 04:1 |
| `$D60A` | pen_idle_timer (`$D60A`) | C | 1 | 2 | 0 | 04:3 |
| `$D60B` | pen_speed (`$D60B`) | C | 3 | 1 | 0 | 04:4 |
| `$D60C` | pen_size (`$D60C`) | C | 6 | 1 | 0 | 04:7 |
| `$D60D` | pen_pattern (`$D60D`) | C | 2 | 1 | 1 | 04:4 |
| `$D60E` | pen_ramp_index (`$D60E`) | C | 1 | 1 | 0 | 04:2 |
| `$D60F` | pen_keys (`$D60F`) | C | 2 | 1 | 0 | 04:3 |
| `$D610` | pen_menu_row (`$D610`) | C | 2 | 2 | 0 | 04:4 |
| `$D611` | pen_menu_focus (`$D611`) | C | 5 | 2 | 0 | 04:7 |
| `$D612` | pen_menu_item (`$D612`) | C | 5 | 5 | 0 | 04:10 |
| `$D613` | pen_menu_page (`$D613`) | C | 4 | 3 | 0 | 04:7 |
| `$D614` | stamp_palette_focus (`$D614`) | C | 4 | 3 | 0 | 04:7 |
| `$D615` | category_pos_A[20] (`$D615`) | C | 0 | 0 | 4 | 04:4 |
| `$D629` | category_pos_B[20] (`$D629`) | C | 0 | 0 | 4 | 04:4 |
| `$D63D` | category_index (`$D63D`) | C | 20 | 1 | 0 | 04:21 |
| `$D63E` | stamp_page (`$D63E`) | C | 7 | 3 | 1 | 04:11 |
| `$D63F` | stamp_item (`$D63F`) | C | 5 | 2 | 1 | 04:8 |
| `$D640` | stamp_return_state (`$D640`) | C | 1 | 1 | 0 | 04:2 |
| `$D641` | stamp_rotate_timer (`$D641`) | C | 1 | 3 | 0 | 04:4 |
| `$D642` | stamp_page_limit_c2 (`$D642`) | C | 0 | 1 | 1 | 04:2 |
| `$D643` | hotspot_block (`$D643`) | C | 0 | 0 | 14 | 02:7 03:7 |
| `$D648` | hotspot_block (`$D643`) | C | 0 | 0 | 4 | 03:4 |
| `$D64D` | hotspot_block (`$D643`) | C | 0 | 0 | 4 | 03:4 |
| `$D652` | hotspot_block (`$D643`) | C | 0 | 0 | 9 | 03:9 |
| `$D657` | hotspot_block (`$D643`) | C | 0 | 0 | 9 | 03:9 |
| `$D65C` | hotspot_block (`$D643`) | C | 0 | 0 | 10 | 02:1 03:9 |
| `$D661` | hs_edit_sound (`$D661`) | C | 1 | 2 | 0 | 03:3 |
| `$D662` | hs_edit_effect (`$D662`) | C | 1 | 2 | 0 | 03:3 |
| `$D663` | hs_edit_jump (`$D663`) | C | 1 | 2 | 0 | 03:3 |
| `$D664` | hs_is_new (`$D664`) | C | 1 | 2 | 0 | 03:3 |
| `$D665` | hs_selected (`$D665`) | C | 22 | 4 | 0 | 03:26 |
| `$D666` | hs_cursor_mode (`$D666`) | C | 3 | 3 | 0 | 03:6 |
| `$D667` | cursor_x (`$D667`) | C | 9 | 7 | 0 | 03:16 |
| `$D668` | cursor_y (`$D668`) | C | 5 | 4 | 0 | 03:9 |
| `$D669` | picker_scroll_phase (`$D669`) | C | 8 | 2 | 0 | 03:10 |
| `$D66A` | picker_dir (`$D66A`) | C | 1 | 3 | 0 | 03:4 |
| `$D66B` | picker_button_anim (`$D66B`) | C | 1 | 4 | 0 | 03:5 |
| `$D66C` | dialog_choice (`$D66C`) | C | 2 | 2 | 2 | 03:6 |
| `$D66D` | dirty_flag (`$D66D`) | C | 8 | 10 | 10 | 03:18 04:6 05:4 |
| `$D66E` | save_dialog_what (`$D66E`) | C | 2 | 3 | 0 | 03:1 04:2 07:2 |
| `$D66F` | save_dialog_scratch (`$D66F`) | U | 0 | 2 | 0 | 07:2 |
| `$D670` | save_dialog_result (`$D670`) | C | 3 | 1 | 0 | 03:1 04:2 07:1 |
| `$D671` | save_target_photo (`$D671`) | C | 4 | 3 | 0 | 03:1 04:2 07:4 |
| `$D673` | autofill_mode (`$D673`) | C | 4 | 2 | 0 | 03:6 |
| `$D674` | choice_cursor_a (`$D674`) | C | 22 | 11 | 3 | 04:8 06:20 07:4 08:4 |
| `$D675` | choice_cursor_b (`$D675`) | C | 7 | 3 | 2 | 04:8 07:4 |
| `$D678` | bg_anim_frame (`$D678`) | C | 2 | 3 | 0 | 07:5 |
| `$D679` | bg_anim_mask (`$D679`) | C | 0 | 2 | 1 | 07:3 |
| `$D67A` | caller_code (`$D67A`) | C | 5 | 10 | 0 | 04:13 08:2 |
| `$D67B` | slider_timer (`$D67B`) | C | 2 | 6 | 0 | 04:8 |
| `$D67C` | slider_target (`$D67C`) | C | 3 | 1 | 1 | 04:5 |
| `$D67D` | slider_pos (`$D67D`) | C | 0 | 2 | 2 | 04:4 |
| `$D67E` | slider_redraw (`$D67E`) | C | 2 | 6 | 0 | 04:8 |
| `$D680` | anim_list_guard (`$D680`) | U | 0 | 2 | 0 | 02:2 |
| `$D681` | anim_list[47] (`$D681`) | C | 0 | 0 | 28 | 02:5 03:22 04:1 |
| `$D6AF` | anim_list[47] (`$D681`) | C | 0 | 0 | 1 | 03:1 |
| `$D6B0` | anim_loop_flag (`$D6B0`) | C | 6 | 1 | 0 | 03:7 |
| `$D6B1` | anim_timing_guard_lo (`$D6B1`) | I | 0 | 2 | 2 | 02:2 03:2 |
| `$D6B2` | anim_timing[47] (`$D6B2`) | C | 0 | 0 | 18 | 02:4 03:14 |
| `$D6B3` | anim_timing[47] (`$D6B2`) | C | 0 | 0 | 1 | 03:1 |
| `$D6E1` | anim_timing_guard_hi (`$D6E1`) | I | 0 | 2 | 0 | 02:2 |
| `$D6E2` | anim_speed (`$D6E2`) | C | 6 | 4 | 0 | 02:4 03:6 |
| `$D6E3` | anim_border (`$D6E3`) | C | 6 | 3 | 1 | 02:4 03:6 |
| `$D6E4` | coro_index (`$D6E4`) | C | 4 | 4 | 0 | 03:8 |
| `$D6E5` | coro_context[3x16] (`$D6E5`) | C | 0 | 0 | 2 | 03:2 |
| `$D6ED` | ctx0_ret (`$D6ED`) | C | 0 | 2 | 0 | 03:2 |
| `$D6EE` | ctx0_ret (`$D6ED`) | C | 0 | 2 | 0 | 03:2 |
| `$D6EF` | ctx0_pad (`$D6EF`) | U | 0 | 0 | 2 | 03:2 |
| `$D6FD` | ctx1_ret (`$D6FD`) | C | 0 | 2 | 0 | 03:2 |
| `$D6FE` | ctx1_ret (`$D6FD`) | C | 0 | 2 | 0 | 03:2 |
| `$D70D` | ctx2_ret (`$D70D`) | C | 0 | 2 | 0 | 03:2 |
| `$D70E` | ctx2_ret (`$D70D`) | C | 0 | 2 | 0 | 03:2 |
| `$D715` | spr_x_tmp (`$D715`) | C | 4 | 2 | 0 | 03:6 |
| `$D716` | spr_y_tmp (`$D716`) | C | 2 | 2 | 0 | 03:4 |
| `$D717` | cur_entry_value (`$D717`) | C | 8 | 9 | 2 | 03:19 |
| `$D718` | cur_entry_index (`$D718`) | C | 15 | 3 | 4 | 03:22 |
| `$D719` | editor_menu_option (`$D719`) | C | 4 | 1 | 0 | 03:5 |
| `$D71B` | editor_range_mode (`$D71B`) | C | 3 | 3 | 0 | 03:6 |
| `$D71C` | range_anchor (`$D71C`) | C | 15 | 2 | 3 | 03:20 |
| `$D71D` | range_moving_end (`$D71D`) | C | 13 | 4 | 2 | 03:19 |
| `$D71E` | range_direction (`$D71E`) | C | 12 | 4 | 1 | 03:17 |
| `$D71F` | range_cursor_xy (`$D71F`) | C | 0 | 2 | 2 | 03:4 |
| `$D720` | range_cursor_xy (`$D71F`) | C | 0 | 5 | 1 | 03:6 |
| `$D721` | range_cursor_xy (`$D71F`) | C | 0 | 2 | 0 | 03:2 |
| `$D722` | range_cursor_xy (`$D71F`) | C | 0 | 5 | 0 | 03:5 |
| `$D723` | range_anim_done (`$D723`) | C | 1 | 0 | 2 | 03:3 |
| `$D724` | range_anim_done (`$D723`) | C | 2 | 0 | 0 | 03:2 |
| `$D725` | play_entry (`$D725`) | C | 1 | 4 | 0 | 03:5 |
| `$D726` | play_tick (`$D726`) | C | 0 | 2 | 4 | 03:6 |
| `$D727` | play_loop_start (`$D727`) | C | 2 | 4 | 0 | 03:6 |
| `$D728` | play_loop_count (`$D728`) | C | 0 | 6 | 2 | 03:8 |
| `$D729` | play_flags (`$D729`) | C | 0 | 2 | 4 | 03:6 |
| `$D72A` | play_done (`$D72A`) | C | 2 | 2 | 4 | 03:8 |
| `$D72B` | preview_wait (`$D72B`) | C | 1 | 5 | 0 | 03:6 |
| `$D72C` | spark_ring_idx (`$D72C`) | C | 1 | 1 | 0 | 03:2 |
| `$D72D` | spark_life[16] (`$D72D`) | C | 0 | 0 | 4 | 03:4 |
| `$D73D` | spark_x[16] (`$D73D`) | C | 0 | 0 | 2 | 03:2 |
| `$D73E` | spark_x[16] (`$D73D`) | C | 0 | 0 | 3 | 03:3 |
| `$D75D` | spark_y[16] (`$D75D`) | C | 0 | 0 | 1 | 03:1 |
| `$D75E` | spark_y[16] (`$D75D`) | C | 0 | 0 | 3 | 03:3 |
| `$D77D` | spark_vx[16] (`$D77D`) | C | 0 | 0 | 3 | 03:3 |
| `$D79D` | spark_vy[16] (`$D79D`) | C | 0 | 0 | 2 | 03:2 |
| `$D7BD` | player_pause (`$D7BD`) | C | 2 | 2 | 0 | 03:4 |
| `$D7BE` | player_music (`$D7BE`) | I | 5 | 1 | 0 | 03:6 |
| `$D7BF` | sprite_x_counter (`$D7BF`) | I | 0 | 0 | 1 | 03:1 |
| `$D7C0` | blink_hold (`$D7C0`) | C | 1 | 3 | 0 | 03:4 |
| `$D7C1` | border_number (`$D7C1`) | C | 12 | 9 | 0 | 02:3 03:4 04:2 08:12 |
| `$D7C2` | actor_frame[2] (`$D7C2`) | C | 0 | 0 | 3 | 07:3 |
| `$D7C4` | actor_tick[2] (`$D7C4`) | C | 0 | 0 | 2 | 07:2 |
| `$D7C6` | actor_phase[2] (`$D7C6`) | C | 0 | 0 | 1 | 07:1 |
| `$D7C8` | actor_cycle_flag[2] (`$D7C8`) | C | 0 | 0 | 3 | 07:3 |
| `$D7CA` | actor_x[2] (`$D7CA`) | C | 0 | 0 | 3 | 07:3 |
| `$D7CC` | actor_y[2] (`$D7CC`) | C | 0 | 0 | 2 | 07:2 |
| `$D7CE` | actor_speed[2] (`$D7CE`) | C | 0 | 0 | 2 | 07:2 |
| `$D7D0` | actor_speed_timer[2] (`$D7D0`) | C | 0 | 0 | 1 | 07:1 |
| `$D7D2` | play_opt_a (`$D7D2`) | C | 4 | 1 | 0 | 07:5 |
| `$D7D3` | play_opt_b (`$D7D3`) | C | 4 | 1 | 0 | 07:5 |
| `$D7D4` | play_interval (`$D7D4`) | C | 2 | 2 | 0 | 07:4 |
| `$D7D5` | play_countdown (`$D7D5`) | C | 0 | 1 | 1 | 07:2 |
| `$D7D6` | play_direction (`$D7D6`) | C | 0 | 2 | 1 | 07:3 |
| `$D7D7` | shoot_init_flag (`$D7D7`) | U | 0 | 1 | 0 | 06:1 |
| `$D7D8` | menu_page_shadow (`$D7D8`) | U | 0 | 3 | 0 | 04:3 |
| `$D7D9` | menu_map_ptr (`$D7D9`) | C | 1 | 1 | 0 | 04:2 |
| `$D7DA` | menu_map_ptr (`$D7D9`) | C | 1 | 1 | 0 | 04:2 |
| `$D7DB` | menu_map_ptr (`$D7D9`) | C | 1 | 1 | 0 | 04:2 |
| `$D7DC` | timer_running (`$D7DC`) | C | 3 | 8 | 0 | 06:11 |
| `$D7DD` | timer_last_vbl (`$D7DD`) | C | 0 | 6 | 1 | 06:7 |
| `$D7DE` | timer_frames (`$D7DE`) | C | 0 | 2 | 3 | 06:5 |
| `$D7DF` | timer_seconds (`$D7DF`) | C | 1 | 4 | 0 | 06:5 |
| `$D7E0` | timer_minutes (`$D7E0`) | C | 2 | 3 | 0 | 06:5 |
| `$D7E1` | timer_beep_acc (`$D7E1`) | C | 1 | 2 | 0 | 06:3 |
| `$D7E2` | shots_left (`$D7E2`) | C | 2 | 2 | 1 | 06:5 |
| `$D7E3` | shoot_variant (`$D7E3`) | C | 30 | 4 | 0 | 06:34 |
| `$D7E4` | shoot_phase (`$D7E4`) | C | 2 | 3 | 2 | 00:1 06:6 |
| `$D7E6` | selftimer_delay (`$D7E6`) | C | 5 | 1 | 1 | 06:7 |
| `$D7E7` | interval_index (`$D7E7`) | C | 10 | 1 | 1 | 06:12 |
| `$D7E8` | interval_shots (`$D7E8`) | C | 2 | 1 | 2 | 06:5 |
| `$D7E9` | shoot_effect_sel (`$D7E9`) | C | 3 | 1 | 1 | 06:5 |
| `$D7EA` | shoot_ramp_sel (`$D7EA`) | C | 1 | 1 | 1 | 06:3 |
| `$D7EB` | shoot_capture_sel (`$D7EB`) | C | 2 | 1 | 1 | 06:4 |
| `$D7EC` | shutter_sound (`$D7EC`) | C | 2 | 0 | 1 | 06:3 |
| `$D7ED` | burst_count (`$D7ED`) | C | 10 | 3 | 0 | 06:13 |
| `$D7EE` | burst_photos[4] (`$D7EE`) | C | 1 | 0 | 7 | 06:8 |
| `$D7F1` | burst_photos[4] (`$D7EE`) | C | 0 | 0 | 1 | 06:1 |
| `$D7F3` | cursor_anim_frame (`$D7F3`) | C | 1 | 0 | 1 | 06:2 |
| `$D7F4` | cursor_anim_tick (`$D7F4`) | C | 1 | 1 | 0 | 06:2 |
| `$D7F5` | compose4_cursor (`$D7F5`) | C | 6 | 1 | 0 | 06:7 |
| `$D7F6` | compose2_cursor (`$D7F6`) | C | 4 | 1 | 0 | 06:5 |
| `$D7F7` | compose2_photos[2] (`$D7F7`) | C | 4 | 0 | 2 | 06:6 |
| `$D7F8` | compose2_photos[2] (`$D7F7`) | C | 4 | 0 | 1 | 06:5 |
| `$D7F9` | compose4_photos[4] (`$D7F9`) | C | 4 | 0 | 2 | 06:6 |
| `$D7FA` | compose4_photos[4] (`$D7F9`) | C | 4 | 0 | 1 | 06:5 |
| `$D7FB` | compose4_photos[4] (`$D7F9`) | C | 4 | 0 | 1 | 06:5 |
| `$D7FC` | compose4_photos[4] (`$D7F9`) | C | 4 | 0 | 1 | 06:5 |
| `$D7FD` | sel_cursor_tick (`$D7FD`) | C | 2 | 3 | 0 | 06:5 |
| `$D7FE` | sel_cursor_frame (`$D7FE`) | C | 4 | 3 | 0 | 06:7 |
| `$D7FF` | sel_slot (`$D7FF`) | C | 2 | 1 | 2 | 06:5 |

### Incidental / single-use addresses (total accesses <= 2)

These are all inside a row above (none is left outside the tables); listed with their access counts for the mechanical check: `$D607` (1; cursor_vx), `$D609` (1; cursor_vy), `$D60E` (2; pen_ramp_index), `$D640` (2; stamp_return_state), `$D642` (2; stamp_page_limit_c2), `$D66F` (2; save_dialog_scratch), `$D680` (2; anim_list_guard), `$D6AF` (1; anim_list[47]), `$D6B3` (1; anim_timing[47]), `$D6E1` (2; anim_timing_guard_hi), `$D6E5` (2; coro_context[3x16]), `$D6ED` (2; ctx0_ret), `$D6EE` (2; ctx0_ret), `$D6EF` (2; ctx0_pad), `$D6FD` (2; ctx1_ret), `$D6FE` (2; ctx1_ret), `$D70D` (2; ctx2_ret), `$D70E` (2; ctx2_ret), `$D721` (2; range_cursor_xy), `$D724` (2; range_anim_done), `$D72C` (2; spark_ring_idx), `$D73D` (2; spark_x[16]), `$D75D` (1; spark_y[16]), `$D79D` (2; spark_vy[16]), `$D7BF` (1; sprite_x_counter), `$D7C4` (2; actor_tick[2]), `$D7C6` (1; actor_phase[2]), `$D7CC` (2; actor_y[2]), `$D7CE` (2; actor_speed[2]), `$D7D0` (1; actor_speed_timer[2]), `$D7D5` (2; play_countdown), `$D7D7` (1; shoot_init_flag), `$D7D9` (2; menu_map_ptr), `$D7DA` (2; menu_map_ptr), `$D7DB` (2; menu_map_ptr), `$D7F1` (1; burst_photos[4]), `$D7F3` (2; cursor_anim_frame), `$D7F4` (2; cursor_anim_tick).
