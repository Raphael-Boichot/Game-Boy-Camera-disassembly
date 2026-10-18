# Unconclusive names of the Pocket Camera (Japan) Rev A symbol file

Generated from `sym_names_jp.csv` by `tools/make_doubts.py` (companion: `sym_unconclusive_jp.csv`, same rows with evidence and "what would settle it"). It lists every label whose name is a guess I could not settle from the code, the README, the WRAM map, TCRF, the Spriters Resource sheets or the bank pictures, plus the `I` (inferred) names in the groups below that deserve a second look. **Nothing here blocks the disassembly**: the `.sym` is complete (every ROM byte is typed and every routine or table has a name) and builds the exact ROM; the names below are the ones most likely to be renamed later.

Reading the names: `Gfx_BB_AAAA_*` = 2bpp tile data, `Map_BB_AAAA_*` = tile map rows (32 bytes per row, 20 visible), `Src_BB_AAAA_*` = data loaded through a far pointer whose destination class is not known, `*_Aux` = same family as the neighbouring named asset (consumer not found), `*_Unref` = no neighbouring consumer at all, `Data_BB_AAAA` = small unread block.

Bank pictures of the unresolved data: `sym_unconclusive_banks/bank_BB.png` (every 2bpp tile of the bank, 32 tiles per row, row label = address of the first tile; grey = typed and named, orange = span listed in the groups "content-classified span" / "unknown data", blue = other `?` assets).

| group | rows | bytes (of the block) | what would help |
|---|---|---|---|
| visually identified range | 1 | 2780 | a yes/no on the family name |
| far-pointer asset, extent unknown | 0 | 0 | where each block ends (the length copied at run time) and what it is |
| content-classified span | 17 | 6294 | what each span is: look at the bank image, or tell me the screen it belongs to |
| unknown data (no reader found) | 0 | 0 | nothing urgent: small leftovers; a VRAM-viewer look would settle them |
| auto-named table | 0 | 0 | what the table indexes |
| hand name, unconfirmed | 4 | 158 | a check of the guess |
| mode state | 102 | 5597 | the screen / state names seen in the real game (compare with TCRF or Funtography) |
| effect slot | 0 | 0 | which visible effect each slot gives |
| SFX tag | 95 | 2536 | the sound each id plays |
| Run minigame | 1 | 22 | variable roles during play |
| keyboard / glyph | 0 | 0 | which glyph page each loader fills |
| main-menu slide | 2 | 24 | which transition each slide is |
| arrow drawing | 0 | 0 | which cursor / arrow each routine draws |
| dead code | 31 | 6196 | whether the code is truly dead (TCRF unused-content notes) |

## visually identified range (1)

_Why doubtful:_ identified from the picture and the neighbouring assets only; no code reads it directly. _To settle:_ check against the Spriters Resource sheet or a VRAM view while the screen runs.

| address | name | bytes | best guess | evidence |
|---|---|---|---|---|
| 14:4554 | `Gfx_14_4554_Mode0E_ExchangeAlt_StrayPtr` | 2780 | tiles 85 (from its 5th byte) to 258 of the same unreferenced screen (tile set 14:4000, map 23:5CC0). Only reader seen: t | tiles 85 (from its 5th byte) to 258 of the same unreferenced screen (tile set 14:4000, map 23:5CC0). Only read |

## content-classified span (17)

_Why doubtful:_ type chosen from the bytes (map rows vs tiles), consumer not found. _To settle:_ view the bank image, then find the reader with a breakpoint on the bank number write.

- bank 0C: `6C00` Mode12_State1D_SortDialogOpen_Aux (48 B)
- bank 15: `5200` MainMenu_DrawUpperItem2_Aux (512 B), `5500` SlidePlay_ReadKeys_Aux (256 B)
- bank 16: `7380` MainMenu_BallHeadAnim_F5_Unref (512 B), `7580` MainMenu_BallHeadAnim_F6_Unref (512 B), `7780` MainMenu_BallHeadAnim_F7_Unref (512 B), `7980` MainMenu_BallHeadAnim_F8_Unref (512 B)
- bank 18: `7D80` Mode0F_State04_LeaveSelected_Aux (256 B)
- bank 1A: `5182` Unref (90 B), `7E00` Unref (501 B)
- bank 1C: `5C20` Mode09_State02_PhotoArrows_Aux (64 B)
- bank 1D: `7B41` Tbl539D_Aux (63 B)
- bank 1E: `7D00` Unref (184 B)
- bank 21: `6AC7` Unref (177 B), `6B91` Unref (47 B)
- bank 23: `58C0` Mode0F_ConfirmFrameStrip_Unref (1024 B), `5CC0` Mode0E_ExchangeAlt_Unref (1024 B)

## hand name, unconfirmed (4)

_Why doubtful:_ named from neighbours only. _To settle:_ emulator trace.

| address | name | bytes | best guess | evidence |
|---|---|---|---|---|
| 13:5CA0 | `Unused_TCRF_AlbumHandGestures_Gfx` | 96 | candidate for the TCRF unused hand gestures: the TCRF image is a crop of the 16-tile-wide  | candidate for the TCRF unused hand gestures: the TCRF image is a crop of the 16-tile-wide sheet 13:5A00-5FFF ( |
| 1A:7C90 | `Unused_TCRF_PhotoOptionIcon_Candidate_Gfx` | 32 | exact pixel match of the TCRF "photo option icon" (2 tiles, 16x8) but these tiles are ON S | exact pixel match of the TCRF "photo option icon" (2 tiles, 16x8) but these tiles are ON SCREEN in normal play |
| 1F:43E4 | `Sfx1_Init_24_SpaceFeverII` | 19 | channel-1 effect init handler of id 24: owner hears a Space Fever II sound (by ear, no con | channel-1 effect init handler of id 24: owner hears a Space Fever II sound (by ear, no confidence given); no r |
| 1F:43EC | `Sfx1_Step_24_SpaceFeverII` | 11 | channel-1 effect step handler of id 24 (owner: Space Fever II sound) Re-checked 2026-10-18 | channel-1 effect step handler of id 24 (owner: Space Fever II sound) Re-checked 2026-10-18 (hex id $24 = 36):  |

## mode state (102)

_Why doubtful:_ state purpose read from the data it writes; screen function partly guessed. _To settle:_ play the screen in an emulator; match with the TCRF / Funtography screen name.

| address | name | bytes | best guess | evidence |
|---|---|---|---|---|
| 00:31CF | `Mode1D_SplitNibbles` | 13 | state handler or helper of a screen mode | A -> D (high nibble) and E (low nibble << 4) |
| 00:31DC | `Mode1D_ByteToDE` | 6 | state handler or helper of a screen mode | A -> DE |
| 00:31E2 | `Mode1D_ReadSrcEntry` | 16 | state handler or helper of a screen mode | A and 3 selects a 4-byte entry of a source table; returns DE |
| 00:31F2 | `Mode1D_ReadByteFromBank` | 34 | state handler or helper of a screen mode | reads [HL] of bank A into C |
| 00:3249 | `Mode1D_InterleaveTileRows` | 146 | state handler or helper of a screen mode | interleaves bitplanes of a row of 8x8 tiles into the band buffer |
| 00:32DB | `Mode1D_FillBlank` | 13 | state handler or helper of a screen mode | fills the band buffer with zero bytes |
| 00:34B3 | `Mode1D_DrawBusyIcon` | 19 | state handler or helper of a screen mode | blinking sprite while printing |
| 00:34C6 | `Mode1D_DrawTvAnimation` | 49 | state handler or helper of a screen mode | 15 sprite pieces of the TV animation |
| 00:34F7 | `Mode1D_TvAnimTbl` | 30 | state handler or helper of a screen mode | 15 x {x |
| 03:6C2D | `Mode1A_State04_PlaceOrDelete` | 105 | state handler or helper of a screen mode | A opens the sound picker |
| 03:6DAD | `Mode1A_State08_PickConfirm` | 87 | state handler or helper of a screen mode | A confirms with the button animation |
| 03:6E04 | `Mode1A_State09_ExitDialog` | 160 | state handler or helper of a screen mode | keep / discard dialog |
| 03:6EE1 | `Mode1A_State0A_DeleteDialog` | 93 | state handler or helper of a screen mode | delete this hot spot? dialog |
| 04:5009 | `Mode0F_DrawCopyCount_Tbl5009` | 16 | state handler or helper of a screen mode | auto: 15 bytes, bytes; referenced by Mode0F_DrawCopyCount |
| 04:5044 | `Mode0F_EraseJingleTiles` | 91 | state handler or helper of a screen mode | plays sound $45 and builds four quadrant tiles of the erase animation |
| 04:509F | `Mode0F_EraseTileTbl` | 16 | state handler or helper of a screen mode | table read by 5044 |
| 04:50AF | `Mode0F_CopyPieceToVram` | 238 | state handler or helper of a screen mode | copies one tile piece from a bank to VRAM (A bit 7 selects $9000 or $8800) |
| 04:7023 | `Mode01_State01_MenuPageA_Tbl7023` | 10 | state handler or helper of a screen mode | auto: 10 bytes, bytes; referenced by Mode01_State01_MenuPageA |
| 04:7084 | `Mode01_State02_ApplyPageA_Tbl7084` | 10 | state handler or helper of a screen mode | auto: 10 bytes, bytes; referenced by Mode01_State02_ApplyPageA |
| 04:70DB | `Mode01_State04_MenuPageB_Tbl70DB` | 10 | state handler or helper of a screen mode | auto: 10 bytes, bytes; referenced by Mode01_State04_MenuPageB |
| 04:712B | `Mode01_State05_ApplyPageB_Tbl712B` | 10 | state handler or helper of a screen mode | auto: 10 bytes, bytes; referenced by Mode01_State05_ApplyPageB |
| 04:7182 | `Mode01_State07_MenuPageC_Tbl7182` | 4 | state handler or helper of a screen mode | auto: 4 bytes, bytes; referenced by Mode01_State07_MenuPageC |
| 04:71B1 | `Mode01_State08_ApplyPageC_Tbl71B1` | 4 | state handler or helper of a screen mode | auto: 4 bytes, bytes; referenced by Mode01_State08_ApplyPageC |
| 04:724F | `Mode01_State01_MenuPageA_Map724F` | 34 | state handler or helper of a screen mode | auto: 34 bytes, tile map; referenced by Mode01_State01_MenuPageA, Mode01_State04_MenuPageB |
| 04:7271 | `Mode01_State07_MenuPageC_Tbl7271` | 8 | state handler or helper of a screen mode | auto: 8 bytes, bytes; referenced by Mode01_State07_MenuPageC |
| 05:44A8 | `Mode1F_State06_SavePanel` | 80 | state handler or helper of a screen mode | A: stores the tune (02:4A6B); slides the panel away |
| 05:44F8 | `Mode1F_State07_QuitPanel` | 89 | state handler or helper of a screen mode | A: back to the title; B: back to the performance |
| 06:4289 | `Mode15_State06_IntervalChoose_Gfx4289` | 30 | state handler or helper of a screen mode | auto: 30 bytes, tile data; referenced by Mode15_State06_IntervalChoose |
| 06:4377 | `Mode15_DrawArrows` | 37 | state handler or helper of a screen mode | Left / Right arrow sprites |
| 06:439C | `Mode15_DrawSecondsSprite` | 10 | state handler or helper of a screen mode |  |
| 06:43A6 | `Mode15_DrawOkSprite` | 6 | state handler or helper of a screen mode |  |
| 06:43AC | `Mode15_DrawBlinkSprite` | 16 | state handler or helper of a screen mode |  |
| 06:43F3 | `Mode15_DrawTwoDigitsInterval` | 47 | state handler or helper of a screen mode |  |
| 06:4422 | `Mode15_DrawIntervalText` | 154 | state handler or helper of a screen mode | interval text in tile writes |
| 06:4603 | `Mode16_State01_Redraw_Gfx4603` | 4 | state handler or helper of a screen mode | auto: 4 bytes, tile data; referenced by Mode16_State01_Redraw |
| 06:4659 | `Mode16_State02_MainMenu_Tbl4659` | 4 | state handler or helper of a screen mode | auto: 4 bytes, bytes; referenced by Mode16_State02_MainMenu |
| 06:465D | `Mode16_State02_MainMenu_Tbl465D` | 8 | state handler or helper of a screen mode | auto: 8 bytes, bytes; referenced by Mode16_State02_MainMenu |
| 06:4665 | `Mode16_State03_TrickLensesMenu` | 114 | state handler or helper of a screen mode | option 1 (opt1_row / opt1_value) |
| 06:46D7 | `Mode16_State03_TrickLensesMenu_Gfx46D7` | 6 | state handler or helper of a screen mode | auto: 6 bytes, tile data; referenced by Mode16_State03_TrickLensesMenu |
| 06:46DD | `Mode16_State03_TrickLensesMenu_Gfx46DD` | 18 | state handler or helper of a screen mode | auto: 18 bytes, tile data; referenced by Mode16_State03_TrickLensesMenu |
| 06:46EF | `Mode16_State00_Init_Gfx46EF` | 15 | state handler or helper of a screen mode | auto: 27 bytes, tile data; referenced by Mode16_State00_Init, Mode16_State01_Redraw, Mode16_State03_TrickLense |
| 06:470A | `Mode16_State04_MontageMenu` | 113 | state handler or helper of a screen mode | option 2 (opt2_row / opt2_value) |
| 06:477B | `Mode16_State04_MontageMenu_Gfx477B` | 6 | state handler or helper of a screen mode | auto: 6 bytes, tile data; referenced by Mode16_State04_MontageMenu |
| 06:4781 | `Mode16_State04_MontageMenu_Gfx4781` | 14 | state handler or helper of a screen mode | auto: 14 bytes, tile data; referenced by Mode16_State04_MontageMenu |
| 06:478F | `Mode16_State00_Init_Gfx478F` | 21 | state handler or helper of a screen mode | auto: 21 bytes, tile data; referenced by Mode16_State00_Init, Mode16_State01_Redraw, Mode16_State04_MontageMen |
| 06:47A4 | `Mode16_State05_PanoramaMenu` | 206 | state handler or helper of a screen mode | option 3 (two toggles) |
| 06:480B | `Mode16_DrawPanoramaHint` | 40 | state handler or helper of a screen mode |  |
| 06:4833 | `Mode16_DrawPanoramaToggles` | 63 | state handler or helper of a screen mode |  |
| 06:4872 | `Mode16_State05_PanoramaMenu_Tbl4872` | 8 | state handler or helper of a screen mode | auto: 8 bytes, bytes; referenced by Mode16_State05_PanoramaMenu |
| 06:487A | `Mode16_State06_GameFaceMenu` | 164 | state handler or helper of a screen mode | option 4: game or Game Face editor |
| 06:491E | `Mode16_State06_GameFaceMenu_Tbl491E` | 6 | state handler or helper of a screen mode | auto: 6 bytes, bytes; referenced by Mode16_State06_GameFaceMenu |
| 06:4A9B | `Mode16_DrawCursorFromTable_Tbl4A9B` | 8 | state handler or helper of a screen mode | auto: 8 bytes, bytes; referenced by Mode16_DrawCursorFromTable |
| 06:4AA3 | `Mode16_DrawIcon` | 116 | state handler or helper of a screen mode |  |
| 06:4AF8 | `Mode16_LoadPageTiles` | 31 | state handler or helper of a screen mode |  |
| 06:4B17 | `Mode16_LoadPageTiles_Gfx4B17` | 12 | state handler or helper of a screen mode | auto: 12 bytes, tile data; referenced by Mode16_LoadPageTiles |
| 06:4B23 | `Mode16_LoadIconTiles` | 68 | state handler or helper of a screen mode |  |
| 06:4B67 | `Mode16_BuildOptionList_Map4B67` | 12 | state handler or helper of a screen mode | auto: 12 bytes, tile map; referenced by Mode16_BuildOptionList |
| 06:4B7C | `Mode16_BuildList2` | 84 | state handler or helper of a screen mode | two rows |
| 06:4BD0 | `Mode16_BuildList4` | 84 | state handler or helper of a screen mode | four rows |
| 06:4C24 | `Mode16_BuildList6` | 99 | state handler or helper of a screen mode | six rows |
| 06:4C87 | `Mode16_DrawCaptionBlink` | 24 | state handler or helper of a screen mode |  |
| 06:5ACE | `Mode18_DrawPrintLabel` | 9 | state handler or helper of a screen mode |  |
| 06:5AD7 | `Mode18_DrawCancelLabel` | 9 | state handler or helper of a screen mode |  |
| 06:5B56 | `Mode18_Pick1_Left` | 30 | state handler or helper of a screen mode |  |
| 06:5B74 | `Mode18_Pick1_Right` | 34 | state handler or helper of a screen mode |  |
| 06:5BBF | `Mode18_Pick2_Up` | 30 | state handler or helper of a screen mode |  |
| 06:5BDD | `Mode18_Pick2_Down` | 34 | state handler or helper of a screen mode |  |
| 06:5BFF | `Mode18_Pick1_DrawCursor` | 55 | state handler or helper of a screen mode |  |
| 06:5C36 | `Mode18_Pick1_DrawCursor_Tbl5C36` | 8 | state handler or helper of a screen mode | auto: 8 bytes, bytes; referenced by Mode18_Pick1_DrawCursor |
| 06:5C3E | `Mode18_Pick1_DrawCursor_Tbl5C3E` | 7 | state handler or helper of a screen mode | auto: 7 bytes, bytes; referenced by Mode18_Pick1_DrawCursor |
| 06:5C45 | `Mode18_Pick2_DrawCursor` | 55 | state handler or helper of a screen mode |  |
| 06:5C7C | `Mode18_Pick2_DrawCursor_PtrTbl5C7C` | 8 | state handler or helper of a screen mode | auto: 8 bytes, word table; referenced by Mode18_Pick2_DrawCursor |
| 06:5C84 | `Mode18_Pick2_DrawCursor_Tbl5C84` | 7 | state handler or helper of a screen mode | auto: 7 bytes, bytes; referenced by Mode18_Pick2_DrawCursor |
| 06:5C8B | `Mode18_DrawArrows` | 185 | state handler or helper of a screen mode |  |
| 06:5C9C | `Mode18_LoadAllThumbs` | 22 | state handler or helper of a screen mode |  |
| 06:5D44 | `Mode18_LoadThumb_Tbl5D44` | 16 | state handler or helper of a screen mode | auto: 16 bytes, bytes; referenced by Mode18_LoadThumb |
| 06:5D54 | `Mode18_LoadThumb_Tbl5D54` | 24 | state handler or helper of a screen mode | auto: 24 bytes, bytes; referenced by Mode18_LoadThumb |
| 06:5D6C | `Mode18_DrawThumbFrame` | 126 | state handler or helper of a screen mode |  |
| 06:5DD7 | `Mode18_LoadTileIndexed` | 15 | state handler or helper of a screen mode |  |
| 07:4186 | `Mode0E_State01_Handshake_Tbl4186` | 4 | state handler or helper of a screen mode | auto: 4 bytes, bytes; referenced by Mode0E_State01_Handshake |
| 07:43D6 | `Mode0E_State04_PickDone` | 231 | state handler or helper of a screen mode | after the dialog: loads the chosen photo into the link buffer |
| 07:44BD | `Mode0E_State05_AbortWait` | 55 | state handler or helper of a screen mode | jitter sprite; A leaves |
| 07:44F4 | `Mode0E_State06_ExchangeSetup` | 165 | state handler or helper of a screen mode | bars and lamps for the exchange (first direction) |
| 07:4599 | `Mode0E_State07_ExchangeBarsA` | 57 | state handler or helper of a screen mode | progress bars; direction 1 |
| 07:45D2 | `Mode0E_State08_ExchangeWaitA` | 43 | state handler or helper of a screen mode | bars; direction 0; watchdog |
| 07:4645 | `Mode0E_State0A_ExchangeSetupB` | 119 | state handler or helper of a screen mode | second direction |
| 07:46BC | `Mode0E_State0B_ExchangeBarsB` | 114 | state handler or helper of a screen mode |  |
| 07:472E | `Mode0E_State0C_ExchangeWaitB` | 43 | state handler or helper of a screen mode |  |
| 07:4759 | `Mode0E_State0D_PickSecond` | 216 | state handler or helper of a screen mode | clears the slot buffer and prepares the second photo |
| 07:4831 | `Mode0E_State0E_AbortWait2` | 60 | state handler or helper of a screen mode |  |
| 07:486D | `Mode0E_State0F_Ready` | 9 | state handler or helper of a screen mode | lnk_ready_tx := 1 |
| 07:4876 | `Mode0E_State10_ExchangeWaitC` | 43 | state handler or helper of a screen mode |  |
| 08:4291 | `Mode1C_State03_PrintMain` | 82 | state handler or helper of a screen mode | Select = option page; Start = toggle extra copy; A/B = leave |
| 08:42E3 | `Mode1C_DrawJitterSprite` | 70 | state handler or helper of a screen mode | random 1-px jitter of sprite $79/$7A |
| 08:4329 | `Mode1C_State04_OptionsMenu` | 184 | state handler or helper of a screen mode | Up -> density; Down -> second option; B/Select back |
| 08:4489 | `Mode1C_State06_OptionToggle` | 127 | state handler or helper of a screen mode | Left/Right toggles D674; two tile variants |
| 08:4508 | `Mode1C_LoadToggleTiles` | 36 | state handler or helper of a screen mode |  |
| 08:4545 | `Mode1C_DrawToggleArrow` | 62 | state handler or helper of a screen mode |  |
| 08:4583 | `Mode1C_ToggleArrowPosTbl` | 4 | state handler or helper of a screen mode |  |
| 08:4587 | `Mode1C_DrawToggleArrow_Tbl4587` | 6 | state handler or helper of a screen mode | auto: 6 bytes, bytes; referenced by Mode1C_DrawToggleArrow |
| 08:47ED | `Mode1C_DrawPrintScreen` | 94 | state handler or helper of a screen mode | tilemap 27:4472 and border tiles |
| 08:484B | `Mode1C_DrawOptionScreen` | 60 | state handler or helper of a screen mode |  |

## SFX tag (95)

_Why doubtful:_ tag chosen from the routine that triggers the id (key press, erase, shutter...), not by listening. _To settle:_ play the effect id in an emulator and compare with the tag.

| address | name | bytes | best guess | evidence |
|---|---|---|---|---|
| 1F:4362 | `Sfx1_Data_4362` | 1 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | one byte $C9 before the first register block |
| 1F:4368 | `Sfx1_Init_04_KeyB` | 15 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 04 (table $41FA) |
| 1F:437C | `Sfx1_Init_3B_EraseAnim` | 21 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 3B (table $41FA) |
| 1F:4384 | `Sfx1_Step_3B_EraseAnim` | 13 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 3B (table $4276) |
| 1F:43C2 | `Sfx1_Init_2A_ChooseC` | 29 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 2A (table $41FA) |
| 1F:43CA | `Sfx1_Step_2A_ChooseC` | 21 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 2A (table $4276) |
| 1F:4401 | `Sfx1_Init_1E_26_Choose` | 38 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 1E 26 (table $41FA). Owner (review page, 2026-10-13, by ear): sfx1 26: us |
| 1F:4409 | `Sfx1_Step_26_BossHit` | 30 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 26 (table $4276) |
| 1F:4431 | `Sfx1_Init_25_SpaceFeverStart` | 33 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 25 (table $41FA) |
| 1F:4439 | `Sfx1_Step_25_SpaceFeverStart` | 25 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 25 (table $4276) |
| 1F:4457 | `Sfx1_Init_27_Shot` | 8 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 27 (table $41FA) |
| 1F:4464 | `Sfx1_Init_0E_Hit` | 43 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 0E (table $41FA) |
| 1F:4475 | `Sfx1_Step_0E_Hit` | 26 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 0E (table $4276) |
| 1F:44A1 | `Sfx1_Step_1A_1E_Choose` | 31 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 1A 1E (table $4276) |
| 1F:44CA | `Sfx1_Init_03_KeyA` | 36 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 03 (table $41FA) |
| 1F:44D2 | `Sfx1_Step_03_KeyA` | 28 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 03 (table $4276) |
| 1F:44F3 | `Sfx1_Init_0B_Select` | 9 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 0B (table $41FA) |
| 1F:4511 | `Sfx1_Init_1B_TargetMenu` | 25 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 1B (table $41FA) |
| 1F:451E | `Sfx1_Step_1B_TargetMenu` | 12 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 1B (table $4276) |
| 1F:4530 | `Sfx1_Init_16_OptionChange` | 25 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 16 (table $41FA) |
| 1F:453D | `Sfx1_Step_16_OptionChange` | 12 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 16 (table $4276) |
| 1F:4554 | `Sfx1_Init_3C_3D_3E_StopMusic` | 33 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 3C 3D 3E (table $41FA). Owner (review page, 2026-10-13, by ear): sfx1 3D: |
| 1F:4569 | `Sfx1_Step_3C_3D_3E_Mode07Play` | 12 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 3C 3D 3E (table $4276) |
| 1F:45C1 | `Sfx1_Init_29_ChooseB` | 39 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 29 (table $41FA) |
| 1F:45C9 | `Sfx1_Step_29_ChooseB` | 31 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 29 (table $4276) |
| 1F:45F7 | `Sfx1_Init_05_ModeEnter` | 48 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 05 (table $41FA) |
| 1F:45FF | `Sfx1_Step_05_ModeEnter` | 40 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 05 (table $4276) |
| 1F:463E | `Sfx1_Init_0A_MenuPageTurn` | 50 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 0A (table $41FA) |
| 1F:4646 | `Sfx1_Step_0A_MenuPageTurn` | 42 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 0A (table $4276) |
| 1F:467A | `Sfx1_Init_02_CursorMove` | 29 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 02 (table $41FA) |
| 1F:4682 | `Sfx1_Step_02_CursorMove` | 21 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 02 (table $4276) |
| 1F:469C | `Sfx1_Init_20_StepFast` | 8 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 20 (table $41FA) |
| 1F:46A9 | `Sfx1_Init_21_StepValue` | 8 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 21 (table $41FA) |
| 1F:46B6 | `Sfx1_Init_22_DirectionKey` | 8 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 22 (table $41FA) |
| 1F:46C3 | `Sfx1_Init_23_2B_BallPoint` | 8 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 23 2B (table $41FA) |
| 1F:46D0 | `Sfx1_Init_01_ValueTick` | 8 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 01 (table $41FA) |
| 1F:4745 | `Sfx1_Init_10_TagJingle` | 54 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 10 (table $41FA) |
| 1F:474D | `Sfx1_Step_10_TagJingle` | 28 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 10 (table $4276) |
| 1F:47B4 | `Sfx1_Init_06_0D_SliderStep` | 37 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 06 0D (table $41FA) |
| 1F:47C0 | `Sfx1_Step_06_0D_SliderStep` | 25 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 06 0D (table $4276) |
| 1F:47EC | `Sfx1_Init_09_MenuPageUp` | 46 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 09 (table $41FA) |
| 1F:47F4 | `Sfx1_Step_09_MenuPageUp` | 38 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 09 (table $4276) |
| 1F:481F | `Sfx1_Init_14_HotSpot` | 32 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of id 14: hot-spot related (owner, by ear: sure) |
| 1F:482C | `Sfx1_Step_14_HotSpot` | 19 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of id 14 (hot spot) |
| 1F:4844 | `Sfx1_Init_15_HotSpot` | 32 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of id 15: hot-spot related (owner, by ear: sure) |
| 1F:4851 | `Sfx1_Step_15_HotSpot` | 19 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of id 15 (hot spot) |
| 1F:4871 | `Sfx1_Init_12_1D_WindowSlideIn` | 8 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 12 1D (table $41FA) |
| 1F:4883 | `Sfx1_Init_0C_EnemyKill` | 12 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 0C (table $41FA) |
| 1F:4894 | `Sfx1_Init_07_MainMenuPick` | 21 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 07 (table $41FA) |
| 1F:4A6E | `Sfx1_Init_30_Celebration` | 34 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 30 (table $41FA) |
| 1F:4A7E | `Sfx1_Step_30_Celebration` | 18 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 30 (table $4276) |
| 1F:4AC7 | `Sfx1_Init_38_Move` | 24 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 38 (table $41FA) |
| 1F:4AD4 | `Sfx1_Step_38_Move` | 11 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 38 (table $4276) |
| 1F:4AEE | `Sfx1_Init_37_CopyBrowse` | 23 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 37 (table $41FA) |
| 1F:4AFB | `Sfx1_Step_37_CopyBrowse` | 10 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 37 (table $4276) |
| 1F:4B17 | `Sfx1_Init_39_MenuChoose` | 23 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 39 (table $41FA) |
| 1F:4B24 | `Sfx1_Step_39_MenuChoose` | 10 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 39 (table $4276) |
| 1F:4B3D | `Sfx1_Init_36_PageStep` | 23 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 36 (table $41FA) |
| 1F:4B4A | `Sfx1_Step_36_PageStep` | 10 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 36 (table $4276) |
| 1F:4B64 | `Sfx1_Init_35_Jump` | 46 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 35 (table $41FA) |
| 1F:4B71 | `Sfx1_Step_35_Jump` | 8 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 35 (table $4276) |
| 1F:4BA6 | `Sfx1_Init_0F_EnemyKillC` | 25 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 0F (table $41FA) |
| 1F:4BAE | `Sfx1_Step_0F_EnemyKillC` | 17 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 0F (table $4276) |
| 1F:4BCE | `Sfx1_Init_11_Confirm` | 41 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 11 (table $41FA) |
| 1F:4BD6 | `Sfx1_Step_11_Confirm` | 33 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 11 (table $4276) |
| 1F:4C09 | `Sfx1_Init_13_WindowSlideOut` | 33 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 13 (table $41FA) |
| 1F:4C11 | `Sfx1_Step_13_WindowSlideOut` | 25 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 13 (table $4276) |
| 1F:4C3B | `Sfx1_Init_19_3A_LayoutKey` | 33 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 19 3A (table $41FA) |
| 1F:4C43 | `Sfx1_Step_19_3A_LayoutKey` | 25 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 19 3A (table $4276) |
| 1F:4C61 | `Sfx1_Init_08_MenuPageDown` | 80 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect init handler of ids 08 (table $41FA) |
| 1F:4C6F | `Sfx1_Step_08_MenuPageDown` | 66 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 08 (table $4276) |
| 1F:4D28 | `Sfx4_Init_05_EraseAnim` | 74 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-4 effect init handler of ids 05 (table $431A). Owner (review page, 2026-10-13, by ear): sfx4 05: used  |
| 1F:4D86 | `Sfx4_Init_01_StampCommit` | 34 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-4 effect init handler of ids 01 (table $431A) |
| 1F:4D8E | `Sfx4_Step_01_StampCommit` | 26 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-4 effect step handler of ids 01 (table $433E) |
| 1F:4E21 | `Sfx4_Init_07_FireShots` | 32 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-4 effect init handler of ids 07 (table $431A) |
| 1F:4E29 | `Sfx4_Step_07_FireShots` | 24 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-4 effect step handler of ids 07 (table $433E) |
| 1F:4E49 | `Sfx4_Init_0A_LinkChoose` | 29 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-4 effect init handler of ids 0A (table $431A) |
| 1F:4E57 | `Sfx4_Step_0A_LinkChoose` | 15 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-4 effect step handler of ids 0A (table $433E) |
| 1F:4E6E | `Sfx4_Init_12_MusicSelect` | 33 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-4 effect init handler of ids 12 (table $431A) |
| 1F:4E76 | `Sfx4_Step_12_MusicSelect` | 25 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-4 effect step handler of ids 12 (table $433E) |
| 1F:4E97 | `Sfx4_Init_04_HurdleCollision` | 33 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-4 effect init handler of ids 04 (table $431A) |
| 1F:4E9F | `Sfx4_Step_04_HurdleCollision` | 25 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-4 effect step handler of ids 04 (table $433E) |
| 1F:4EBC | `Sfx4_Init_11_FlagHeight` | 29 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-4 effect init handler of ids 11 (table $431A) |
| 1F:4EC4 | `Sfx4_Step_11_FlagHeight` | 21 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-4 effect step handler of ids 11 (table $433E) |
| 1F:4EDD | `Sfx4_Init_08_StopMusic` | 11 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-4 effect init handler of ids 08 (table $431A) |
| 1F:4FCB | `Sfx3_Step_09_DeleteDialogB` | 31 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-3 effect step handler of ids 09 (table $4306) |
| 1F:4FE1 | `Sfx3_Init_09_DeleteDialogB` | 9 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-3 effect init handler of ids 09 (table $42F2) |
| 1F:4FF5 | `Sfx3_Step_08_DeleteDialogA` | 50 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-3 effect step handler of ids 08 (table $4306) |
| 1F:501E | `Sfx3_Init_08_DeleteDialogA` | 9 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-3 effect init handler of ids 08 (table $42F2) |
| 1F:502C | `Sfx3_Step_03_BossHit` | 40 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-3 effect step handler of ids 03 (table $4306) |
| 1F:5046 | `Sfx3_Init_03_BossHit` | 14 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-3 effect init handler of ids 03 (table $42F2) |
| 1F:5059 | `Sfx3_Step_02_ViewArcadeSelect` | 50 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-3 effect step handler of ids 02 (table $4306) |
| 1F:507D | `Sfx3_Init_02_ViewArcadeSelect` | 14 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-3 effect init handler of ids 02 (table $42F2) |
| 1F:50BE | `Sfx3_Step_01_ShootSelect` | 39 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-3 effect step handler of ids 01 (table $4306) |
| 1F:50D7 | `Sfx3_Init_01_ShootSelect` | 14 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-3 effect init handler of ids 01 (table $42F2) |

## Run minigame (1)

_Why doubtful:_ role of several state variables guessed. _To settle:_ play the game with a watch on the named variables.

| address | name | bytes | best guess | evidence |
|---|---|---|---|---|
| 09:66A5 | `Run_FlagLanded` | 22 | Run (marathon) mini-game routine or table | returns Z when the flag counter $D048 is 2 and the y byte (record + 2, from $D054, step 6) of all 10 confetti  |

## main-menu slide (2)

_Why doubtful:_ slide A/B split by code layout only. _To settle:_ watch the menu transition frame by frame.

| address | name | bytes | best guess | evidence |
|---|---|---|---|---|
| 07:7C33 | `MainMenu_SlideA_Tbl2` | 12 | slide animation between main-menu pages | 4 x {lo,hi,bank} = 16:7580, 7780, 7980, 7B80 (frames 6-9 of the camera ball head animation, forward; the secon |
| 07:7C3F | `MainMenu_SlideA_Tbl3` | 12 | slide animation between main-menu pages | 4 x {lo,hi,bank} = 16:7980, 7780, 7580, 7380 (frames 8, 7, 6, 5 of the camera ball head animation, backward).  |

## dead code (31)

_Why doubtful:_ never executed in the static trace; purpose read from the instructions only. _To settle:_ TCRF note, or a debugger test with a forced jump.

| address | name | bytes | best guess | evidence |
|---|---|---|---|---|
| 00:2E88 | `Unused_Str_MainPass` | 10 | code or data that no trace path and no table reaches (left over from earlier versions) | ASCII 'MAIN PASS',0 right after Delay_BC; no immediate load of its address in the trace |
| 02:46E6 | `Unused_Photo_SaveReceived_Far_Stray46E6` | 3 | code or data that no trace path and no table reaches (left over from earlier versions) | 3 bytes 00 C0 00 between the jp of Photo_SaveReceived_Far (02:46E3) and Sram_ZeroTagBytes (02:46E9); read as c |
| 04:4D09 | `Unused_Mode0F_State09_EraseOne_Tbl4D09` | 18 | code or data that no trace path and no table reaches (left over from earlier versions) | 18 bytes 05 0F 06 05 07 05 06 05 07 05 08 05 0B 05 0C 05 0E 14 right after the ret of Mode0F_State09_EraseOne; |
| 04:6403 | `Unused_LoadTilemap24_7120` | 15 | code or data that no trace path and no table reaches (left over from earlier versions) | dead code: copies the tilemap 24:7120 to $9800 (UNREFERENCED, README 16.15) |
| 04:6412 | `Unused_LoadTilemap25_4B00` | 15 | code or data that no trace path and no table reaches (left over from earlier versions) | dead code: copies the tilemap 25:4B00 to $9800 (UNREFERENCED, README 16.15) |
| 04:7C9D | `Unused_Mode0A_PhotoStepWrap` | 55 | code or data that no trace path and no table reaches (left over from earlier versions) | UNREFERENCED: Left / Right steps copy_photo_idx_a with wrap in 0..29 / 30..59 |
| 05:622D | `Unused_DjEd_LoadPerformerTiles9100` | 23 | code or data that no trace path and no table reaches (left over from earlier versions) | UNREFERENCED |
| 05:7F1C | `Unused_Ball_LoadGfx9100` | 23 | code or data that no trace path and no table reaches (left over from earlier versions) | UNREFERENCED |
| 05:7F33 | `Unused_Ball_LoadGfx9480` | 23 | code or data that no trace path and no table reaches (left over from earlier versions) | UNREFERENCED |
| 06:71CC | `Unused_Shoot_TimerKeys` | 66 | code or data that no trace path and no table reaches (left over from earlier versions) | UNREFERENCED |
| 07:41C8 | `Unused_Mode0E_GotoState12` | 6 | code or data that no trace path and no table reaches (left over from earlier versions) | UNREFERENCED: state := $12 |
| 07:4A4D | `Unused_Link_DrawPhotoNumber` | 65 | code or data that no trace path and no table reaches (left over from earlier versions) | UNREFERENCED |
| 07:4BC3 | `Unused_Link_LoadTiles` | 26 | code or data that no trace path and no table reaches (left over from earlier versions) | UNREFERENCED |
| 07:4BDD | `Unused_Link_WriteHexByte` | 7 | code or data that no trace path and no table reaches (left over from earlier versions) | UNREFERENCED |
| 07:4BE4 | `Unused_Link_WriteHexNibble` | 6 | code or data that no trace path and no table reaches (left over from earlier versions) | UNREFERENCED |
| 07:4BEA | `Unused_Link_SumSlotBuffer` | 30 | code or data that no trace path and no table reaches (left over from earlier versions) | UNREFERENCED: 16-bit sum of the $1000 byte buffer |
| 07:503D | `Unused_LinkPick_LoadPhotoIndexB` | 3 | code or data that no trace path and no table reaches (left over from earlier versions) | entry of arbitrary address (README 16.14) |
| 0D:7660 | `Unused_TCRF_KanjiMiddleBeforeAfterHave_Gfx` | 384 | code or data that no trace path and no table reaches (left over from earlier versions) | TCRF unused graphic: the four kanji 中 前 後 持 as one strip of 16 tiles; pixel match against the TCRF image (15 o |
| 11:5800 | `Unused_TCRF_HandNewspaperFrames_Gfx` | 4416 | code or data that no trace path and no table reaches (left over from earlier versions) | nine sprite frames of a hand flipping a newspaper (TCRF B16, Unused Graphic Bank 11): 25 tiles per frame in 51 |
| 15:4480 | `Unused_TCRF_JapaneseMenuTile_CircledX_Gfx` | 16 | code or data that no trace path and no table reaches (left over from earlier versions) | TCRF unused graphic: the circled X tile of the Japanese main-menu bank (copy 1 of 3, same tile at 15:4500 and  |
| 15:4500 | `Unused_TCRF_JapaneseMenuTile_CircledX_Copy2_Gfx` | 16 | code or data that no trace path and no table reaches (left over from earlier versions) | TCRF unused graphic: circled X, copy 2 of 3 |
| 15:4580 | `Unused_TCRF_JapaneseMenuTile_CircledX_Copy3_Gfx` | 16 | code or data that no trace path and no table reaches (left over from earlier versions) | TCRF unused graphic: circled X, copy 3 of 3 |
| 18:5A50 | `Unused_TCRF_MarginPrint_BFilmRoll_Gfx` | 96 | code or data that no trace path and no table reaches (left over from earlier versions) | TCRF unused graphic: film roll with a B for the margin-print option (6 tiles); loaded with the option screen b |
| 18:5F90 | `Unused_TCRF_MarginPrint_OutlinedText_Gfx` | 192 | code or data that no trace path and no table reaches (left over from earlier versions) | TCRF unused graphic: outlined Japanese text of the margin-print option (12 tiles); never stably on screen (REA |
| 1C:5920 | `Unused_TCRF_HotSpotEffectIcons_Extra_Gfx` | 512 | code or data that no trace path and no table reaches (left over from earlier versions) | TCRF unused graphics: the 8 extra hot-spot effect icons (32 tiles); on screen only in runs that force the effe |
| 1F:46DD | `Unused_Sfx1_Init_46DD` | 8 | code or data that no trace path and no table reaches (left over from earlier versions) | channel-1 init handler in the id 20-23 series that no table lists (dead) |
| 1F:4A61 | `Unused_Sfx1_Step_4A61` | 8 | code or data that no trace path and no table reaches (left over from earlier versions) | step handler that no table lists (effect $34 uses the generic step; dead) |
| 1F:4FBC | `Unused_Snd_SetFreeze` | 6 | code or data that no trace path and no table reaches (left over from earlier versions) | sets $DD0D (snd_freeze) = 1; no caller |
| 1F:53B9 | `Unused_Snd_SongPan_Load` | 46 | code or data that no trace path and no table reaches (left over from earlier versions) | loads a 6-byte record at $5856 + 6 * (song - 1) into $DD55..; no caller (UNREFERENCED; README 16.21) |
| 1F:53E7 | `Unused_Snd_Pan_Step` | 40 | code or data that no trace path and no table reaches (left over from earlier versions) | steps a panning sequence (NR51) from the $DD55 record; no caller (UNREFERENCED) |
| 1F:5743 | `Unused_Snd_Vib_Tail` | 46 | code or data that no trace path and no table reaches (left over from earlier versions) | dead tail after an unconditional jr in Snd_Trk_Vibrato; the bytes of a removed branch |
