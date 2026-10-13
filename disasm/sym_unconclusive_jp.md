# Unconclusive names of the Pocket Camera (Japan) Rev A symbol file

Generated from `sym_names_jp.csv` by `tools/make_doubts.py` (companion: `sym_unconclusive_jp.csv`, same rows with evidence and "what would settle it"). It lists every label whose name is a guess I could not settle from the code, the README, the WRAM map, TCRF, the Spriters Resource sheets or the bank pictures, plus the `I` (inferred) names in the groups below that deserve a second look. **Nothing here blocks the disassembly**: the `.sym` is complete (every ROM byte is typed and every routine or table has a name) and builds the exact ROM; the names below are the ones most likely to be renamed later.

Reading the names: `Gfx_BB_AAAA_*` = 2bpp tile data, `Map_BB_AAAA_*` = tile map rows (32 bytes per row, 20 visible), `Src_BB_AAAA_*` = data loaded through a far pointer whose destination class is not known, `*_Aux` = same family as the neighbouring named asset (consumer not found), `*_Unref` = no neighbouring consumer at all, `Data_BB_AAAA` = small unread block.

Bank pictures of the unresolved data: `sym_unconclusive_banks/bank_BB.png` (every 2bpp tile of the bank, 32 tiles per row, row label = address of the first tile; grey = typed and named, orange = span listed in the groups "content-classified span" / "unknown data", blue = other `?` assets).

| group | rows | bytes (of the block) | what would help |
|---|---|---|---|
| visually identified range | 10 | 9698 | a yes/no on the family name |
| far-pointer asset, extent unknown | 17 | 213 | where each block ends (the length copied at run time) and what it is |
| content-classified span | 53 | 13538 | what each span is: look at the bank image, or tell me the screen it belongs to |
| unknown data (no reader found) | 75 | 812 | nothing urgent: small leftovers; a VRAM-viewer look would settle them |
| auto-named table | 16 | 925 | what the table indexes |
| hand name, unconfirmed | 12 | 686 | a check of the guess |
| mode state | 106 | 5954 | the screen / state names seen in the real game (compare with TCRF or Funtography) |
| effect slot | 88 | 11689 | which visible effect each slot gives |
| SFX tag | 95 | 2536 | the sound each id plays |
| Run minigame | 43 | 1755 | variable roles during play |
| keyboard / glyph | 36 | 1336 | which glyph page each loader fills |
| main-menu slide | 18 | 1234 | which transition each slide is |
| arrow drawing | 12 | 593 | which cursor / arrow each routine draws |
| dead code | 29 | 6175 | whether the code is truly dead (TCRF unused-content notes) |

## visually identified range (10)

_Why doubtful:_ identified from the picture and the neighbouring assets only; no code reads it directly. _To settle:_ check against the Spriters Resource sheet or a VRAM view while the screen runs.

| address | name | bytes | best guess | evidence |
|---|---|---|---|---|
| 0C:5800 | `Gfx_0C_5800_AnimEdMenuLabelsAlt` | 832 | second copy of the Animation-editor menu labels (クリア ループ ここから テスト プレイ オール PHOTO MOVIE FRAME PLAY) at 4A00-5000; the bank | second copy of the Animation-editor menu labels (クリア ループ ここから テスト プレイ オール PHOTO MOVIE FRAME PLAY) at 4A00-5000 |
| 0C:68D0 | `Gfx_0C_68D0_AnimEdKanaStrips` | 864 | kana strips of the Animation-editor dialogs, same style as 6000-68CF | kana strips of the Animation-editor dialogs, same style as 6000-68CF (visual) |
| 0D:7000 | `Gfx_0D_7000_FillPatternTiles` | 1632 | dot, crosshatch and dither fill tiles plus a few glyph pieces | dot, crosshatch and dither fill tiles plus a few glyph pieces (visual); no direct pointer, probably indexed by |
| 10:7602 | `Gfx_10_7602_DjLetterGlyphStrip` | 678 | Latin letter / digit glyph strip | Latin letter / digit glyph strip (visual); bank 10 also holds the DJ screens' numeral tiles at 7400-7420 |
| 11:5400 | `Gfx_11_5400_MainMenuUpperItemFramesA` | 256 | gap inside the animation tiles of the main-menu upper item (neighbours Gfx_11_5300 / Gfx_11_5500 are loaded by MainMenu_ | gap inside the animation tiles of the main-menu upper item (neighbours Gfx_11_5300 / Gfx_11_5500 are loaded by |
| 14:4554 | `Gfx_14_4554_Mode0E_ExchangeAlt_StrayPtr` | 2780 | tiles 85 (from its 5th byte) to 258 of the same unreferenced screen (tile set 14:4000, map 23:5CC0). Only reader seen: t | tiles 85 (from its 5th byte) to 258 of the same unreferenced screen (tile set 14:4000, map 23:5CC0). Only read |
| 17:4000 | `Gfx_17_4000_ShootMenuIconsA` | 320 | icon row of the SHOOT-menu tile bank | icon row of the SHOOT-menu tile bank (visual); neighbours are loaded by Mode14_State00_Init |
| 17:4200 | `Gfx_17_4200_ShootCounterIcons` | 1152 | digit / counter / clock icons (1 2 3 4, 1 2 2 1) of the SHOOT screens | digit / counter / clock icons (1 2 3 4, 1 2 2 1) of the SHOOT screens (visual); neighbours Shoot_LoadBurstIcon |
| 17:4820 | `Gfx_17_4820_ShootMenuIconsB` | 288 | icon strip between Compose_DrawFreeCount and Mode14_State00_Init sets | icon strip between Compose_DrawFreeCount and Mode14_State00_Init sets (visual) |
| 21:4D00 | `Gfx_21_4D00_SpaceFeverFont` | 896 | large letter / digit glyph rows of the Space Fever II screens (SCORE, BEST, GAME OVER, CONGRATULATIONS lines; blue neigh | large letter / digit glyph rows of the Space Fever II screens (SCORE, BEST, GAME OVER, CONGRATULATIONS lines;  |

## far-pointer asset, extent unknown (17)

_Why doubtful:_ end taken as the next pointer or asset. _To settle:_ read the copy length at run time (breakpoint on the helper).

| address | name | bytes | best guess | evidence |
|---|---|---|---|---|
| 2A:44D4 | `Sheet_MiscellaneousStampsJpn_2A_44D4_Gap` | 6 | data loaded through a banked copy helper; length not stated at the load site | unread gap between two parts of the Spriters sheet MiscellaneousStampsJpn: same family on both sides (not matc |
| 2A:44F4 | `Sheet_MiscellaneousStampsJpn_2A_44F4_Gap` | 16 | data loaded through a banked copy helper; length not stated at the load site | unread gap between two parts of the Spriters sheet MiscellaneousStampsJpn: same family on both sides (not matc |
| 2A:4A23 | `Sheet_MiscellaneousStampsJpn_2A_4A23_Gap` | 23 | data loaded through a banked copy helper; length not stated at the load site | unread gap between two parts of the Spriters sheet MiscellaneousStampsJpn: same family on both sides (not matc |
| 2A:4A4E | `Sheet_MiscellaneousStampsJpn_2A_4A4E_Gap` | 12 | data loaded through a banked copy helper; length not stated at the load site | unread gap between two parts of the Spriters sheet MiscellaneousStampsJpn: same family on both sides (not matc |
| 2A:5401 | `Sheet_MiscellaneousStampsJpn_2A_5401_Gap` | 25 | data loaded through a banked copy helper; length not stated at the load site | unread gap between two parts of the Spriters sheet MiscellaneousStampsJpn: same family on both sides (not matc |
| 2A:5430 | `Sheet_MiscellaneousStampsJpn_2A_5430_Gap` | 10 | data loaded through a banked copy helper; length not stated at the load site | unread gap between two parts of the Spriters sheet MiscellaneousStampsJpn: same family on both sides (not matc |
| 2A:5452 | `Sheet_MiscellaneousStampsJpn_2A_5452_Gap` | 8 | data loaded through a banked copy helper; length not stated at the load site | unread gap between two parts of the Spriters sheet MiscellaneousStampsJpn: same family on both sides (not matc |
| 2A:5470 | `Sheet_MiscellaneousStampsJpn_2A_5470_Gap` | 10 | data loaded through a banked copy helper; length not stated at the load site | unread gap between two parts of the Spriters sheet MiscellaneousStampsJpn: same family on both sides (not matc |
| 2A:5492 | `Sheet_MiscellaneousStampsJpn_2A_5492_Gap` | 2 | data loaded through a banked copy helper; length not stated at the load site | unread gap between two parts of the Spriters sheet MiscellaneousStampsJpn: same family on both sides (not matc |
| 2A:54B0 | `Sheet_MiscellaneousStampsJpn_2A_54B0_Gap` | 10 | data loaded through a banked copy helper; length not stated at the load site | unread gap between two parts of the Spriters sheet MiscellaneousStampsJpn: same family on both sides (not matc |
| 2A:54D0 | `Sheet_MiscellaneousStampsJpn_2A_54D0_Gap` | 10 | data loaded through a banked copy helper; length not stated at the load site | unread gap between two parts of the Spriters sheet MiscellaneousStampsJpn: same family on both sides (not matc |
| 2A:54F0 | `Sheet_MiscellaneousStampsJpn_2A_54F0_Gap` | 10 | data loaded through a banked copy helper; length not stated at the load site | unread gap between two parts of the Spriters sheet MiscellaneousStampsJpn: same family on both sides (not matc |
| 2A:5512 | `Sheet_MiscellaneousStampsJpn_2A_5512_Gap` | 8 | data loaded through a banked copy helper; length not stated at the load site | unread gap between two parts of the Spriters sheet MiscellaneousStampsJpn: same family on both sides (not matc |
| 2A:585B | `Sheet_MiscellaneousStampsJpn_2A_585B_Gap` | 31 | data loaded through a banked copy helper; length not stated at the load site | unread gap between two parts of the Spriters sheet MiscellaneousStampsJpn: same family on both sides (not matc |
| 2A:5898 | `Sheet_MiscellaneousStampsJpn_2A_5898_Gap` | 22 | data loaded through a banked copy helper; length not stated at the load site | unread gap between two parts of the Spriters sheet MiscellaneousStampsJpn: same family on both sides (not matc |
| 2A:58D6 | `Sheet_MiscellaneousStampsJpn_2A_58D6_Gap` | 6 | data loaded through a banked copy helper; length not stated at the load site | unread gap between two parts of the Spriters sheet MiscellaneousStampsJpn: same family on both sides (not matc |
| 2A:58F6 | `Sheet_MiscellaneousStampsJpn_2A_58F6_Gap` | 4 | data loaded through a banked copy helper; length not stated at the load site | unread gap between two parts of the Spriters sheet MiscellaneousStampsJpn: same family on both sides (not matc |

## content-classified span (53)

_Why doubtful:_ type chosen from the bytes (map rows vs tiles), consumer not found. _To settle:_ view the bank image, then find the reader with a breakpoint on the bank number write.

- bank 0C: `7E20` Album_LoadNumeralTile_Aux (352 B)
- bank 0F: `5800` UserMap_LoadPlanetTiles_Aux (122 B), `5904` Unref (84 B)
- bank 10: `7420` DjTitle_LoadNumeralTile_Aux (128 B), `74A3` Unref (157 B), `78B8` Unref (24 B), `7908` Unref (238 B), `7A24` Unref (92 B), `7ADE` Unref (162 B), `7BF8` Unref (345 B), `7D52` Unref (366 B), `7F00` Unref (184 B)
- bank 14: `7A01` PenMenu_Build_Aux (95 B)
- bank 15: `5200` MainMenu_DrawUpperItem2_Aux (512 B), `5500` SlidePlay_ReadKeys_Aux (256 B)
- bank 18: `7D80` Mode0F_State04_LeaveSelected_Aux (256 B)
- bank 1A: `4D80` DjPerf_DrawTempo_Aux (128 B), `5182` Unref (90 B), `7E00` Unref (501 B)
- bank 1B: `6EBA` Unref (176 B), `6F7C` Unref (68 B)
- bank 1C: `4241` MenusShootMenu_Aux (607 B), `44B0` Unref (448 B), `5670` HotSpotEd_CopyNumberTile_Aux (158 B), `57A0` HotSpotEd_CopyNumberTile_Aux (256 B), `5C20` Mode09_State02_PhotoArrows_Aux (64 B)
- bank 1D: `6D11` MenusShootMenu_Aux (1315 B), `724E` Unref (82 B), `7631` MenusShootMenu_Aux (341 B), `7796` Unref (330 B), `7B41` Tbl539D_Aux (63 B)
- bank 1E: `64E0` Compose_DrawPhotoNumber_Aux (144 B), `6590` Mode16_DrawCaptionBlink_Aux (61 B), `7D00` Unref (184 B)
- bank 20: `64E0` OwnerCard_LoadGenderTiles_Aux (64 B), `66C0` Unref (256 B), `70F0` Mode15_DrawTwoDigitsInterval_Aux (144 B), `71A0` Mode15_DrawTwoDigits_Aux (288 B)
- bank 21: `5C31` MenusShootMenu_Aux (927 B), `6566` Unref (69 B), `6AC7` Unref (177 B), `6B91` Unref (47 B), `7BC0` BorderPicker_AnimateIcon_Aux (63 B)
- bank 23: `5CC0` Mode0E_ExchangeAlt_Unref (580 B), `7180` CreditsGirlFrame12_Aux (608 B), `7DC0` ShowMenu_LoadHighlightTiles_Aux (192 B)
- bank 24: `60B2` Unref (270 B), `6200` Mode01_State02_ApplyPageA_Aux (288 B), `78C0` PenMenu_Build_Aux (66 B), `7913` Unref (77 B)
- bank 26: `7BC0` CreditsNishimuraDanceMap4_Aux (576 B), `7E20` Album_LoadNumeralTileB_Aux (352 B)
- bank 2A: `59FF` MiscellaneousStampsJpn_Aux (105 B)

## unknown data (no reader found) (75)

_Why doubtful:_ no pointer, table or sheet covers it. _To settle:_ VRAM viewer / read breakpoint in an emulator.

- bank 0F: `596C` 6 B, `5984` 20 B
- bank 10: `78E8` 8 B, `7A08` 8 B, `7BC2` 10 B, `7BE4` 4 B
- bank 1A: `5160` 3 B
- bank 1B: `6EA0` 10 B
- bank 1C: `5620` 2 B, `5623` 42 B, `564E` 18 B, `5720` 16 B, `5BC0` 26 B, `5CC0` 11 B, `5CD3` 13 B, `5D20` 39 B, `5D48` 24 B
- bank 1E: `64C0` 16 B
- bank 20: `667D` 3 B
- bank 22: `7F40` 10 B, `7F61` 5 B, `7F81` 5 B, `7FA4` 6 B, `7FC4` 6 B, `7FE0` 10 B
- bank 23: `58C0` 2 B, `58E0` 2 B, `5900` 2 B, `5920` 2 B, `5940` 2 B, `5960` 2 B, `5980` 2 B, `59A0` 2 B, `59C0` 2 B, `59E0` 2 B, `5A00` 2 B, `5A20` 2 B, `5A40` 2 B, `5A60` 2 B, `5A80` 2 B, `5AA0` 2 B, `5AC0` 2 B, `5AE0` 2 B, `5F1C` 8 B, `5F3C` 8 B, `5F5C` 8 B, `5F94` 12 B, `7760` 32 B, `7D54` 12 B
- bank 24: `4E40` 32 B, `4F20` 32 B, `5F00` 20 B, `6080` 34 B, `7780` 32 B
- bank 25: `5834` 12 B, `75F4` 12 B, `77F4` 12 B
- bank 27: `5BB0` 22 B, `5BD8` 16 B, `5BF8` 8 B, `5C20` 8 B, `5C38` 8 B, `5C60` 8 B, `5C78` 8 B, `5CA0` 8 B, `5CB8` 8 B, `5CE0` 8 B, `5CF8` 8 B, `5D20` 8 B, `5D40` 31 B, `76F0` 1 B, `7703` 13 B, `7810` 1 B, `7823` 13 B
- bank 2A: `5A7A` 12 B

## auto-named table (16)

_Why doubtful:_ no code loads it directly (indexed or computed access). _To settle:_ breakpoint on reads of the address.

| address | name | bytes | best guess | evidence |
|---|---|---|---|---|
| 00:36F1 | `Img_NibbleMapTbl_Data36F1` | 15 | table or word list found by pattern; no immediate reference | auto: 15 bytes, bytes; referenced by no immediate load found |
| 02:46E6 | `Photo_SaveReceived_Far_Data46E6` | 3 | table or word list found by pattern; no immediate reference | auto: 3 bytes, bytes; referenced by no immediate load found |
| 03:568B | `AnimEd_CoroYield_PtrTbl568B` | 6 | table or word list found by pattern; no immediate reference | auto: 6 bytes, word table; referenced by no immediate load found |
| 03:59F1 | `AnimEd_CoroYield_B_PtrTbl59F1` | 6 | table or word list found by pattern; no immediate reference | auto: 6 bytes, word table; referenced by no immediate load found |
| 04:4D09 | `Mode0F_State09_EraseOne_Data4D09` | 18 | table or word list found by pattern; no immediate reference | auto: 18 bytes, bytes; referenced by no immediate load found |
| 05:5AE8 | `DjPrintRow_Text1_Data5AE8` | 1 | table or word list found by pattern; no immediate reference | auto: 1 bytes, bytes; referenced by no immediate load found |
| 08:4E88 | `BorderPicker_FillPatternTbl_Data4E88` | 12 | table or word list found by pattern; no immediate reference | auto: 12 bytes, bytes; referenced by no immediate load found |
| 09:5A0A | `Kb_Page1_Navigate_Data5A0A` | 9 | table or word list found by pattern; no immediate reference | auto: 9 bytes, bytes; referenced by no immediate load found |
| 09:5A72 | `Kb_Page2_Navigate_Data5A72` | 23 | table or word list found by pattern; no immediate reference | auto: 23 bytes, bytes; referenced by no immediate load found |
| 09:5AF8 | `Kb_Page3_Navigate_Data5AF8` | 17 | table or word list found by pattern; no immediate reference | auto: 17 bytes, bytes; referenced by no immediate load found |
| 09:68E3 | `Run_SpeedLevelTbl_Data68E3` | 16 | table or word list found by pattern; no immediate reference | auto: 16 bytes, bytes; referenced by no immediate load found |
| 09:6AC6 | `Run_FlagHoistKeys_Data6AC6` | 16 | table or word list found by pattern; no immediate reference | auto: 16 bytes, bytes; referenced by no immediate load found |
| 0A:7301 | `Cam_PopcountTable256_Data7301` | 255 | table or word list found by pattern; no immediate reference | auto: 255 bytes, bytes; referenced by no immediate load found |
| 0A:7600 | `Cam_BitReverseTbl_Data7600` | 256 | table or word list found by pattern; no immediate reference | auto: 256 bytes, bytes; referenced by no immediate load found |
| 0A:7740 | `Cam_BitReverseTbl_Data7740` | 16 | table or word list found by pattern; no immediate reference | auto: 16 bytes, bytes; referenced by no immediate load found |
| 0A:7800 | `Cam_BitReverseTbl_Data7800` | 256 | table or word list found by pattern; no immediate reference | auto: 256 bytes, bytes; referenced by no immediate load found |

## hand name, unconfirmed (12)

_Why doubtful:_ named from neighbours only. _To settle:_ emulator trace.

| address | name | bytes | best guess | evidence |
|---|---|---|---|---|
| 00:0486 | `Map_CopyRectAddTile_LcdOff` | 109 | copies a 20-wide tilemap block adding C to each tile; LCD off variant | copies a 20-wide tilemap block adding C to each tile; LCD off variant |
| 00:04F3 | `Map_CopyRectAddTile_Safe` | 140 | same with STAT waits | same with STAT waits |
| 00:09D4 | `Rng_Scaled` | 26 | index into 09EE table; combines Rng_Next with 0F4F and returns the high bits | index into 09EE table; combines Rng_Next with 0F4F and returns the high bits |
| 00:1569 | `Img_AndMaskTiles_Bank27` | 124 | ANDs a 7x8-tile image (pointer by shoot_phase table 15E5) with the mask at 27:5BB0; caller | ANDs a 7x8-tile image (pointer by shoot_phase table 15E5) with the mask at 27:5BB0; callers in bank 6 |
| 00:15E5 | `Img_AndMaskTiles_Ptrs` | 8 | see name |  |
| 00:1720 | `Prn_CopyBandRecords` | 79 | copies 18-byte records HL(bank A) -> DE until a terminator; returns the row count in B | copies 18-byte records HL(bank A) -> DE until a terminator; returns the row count in B |
| 00:29F9 | `Thumb_ApplyCornerPatches` | 24 | 6 records {offset | 6 records {offset |
| 00:2A11 | `Thumb_CornerPatchTbl` | 18 | 6 x 3 bytes | 6 x 3 bytes |
| 13:5CA0 | `Unused_TCRF_AlbumHandGestures_Gfx` | 96 | candidate for the TCRF unused hand gestures: the TCRF image is a crop of the 16-tile-wide  | candidate for the TCRF unused hand gestures: the TCRF image is a crop of the 16-tile-wide sheet 13:5A00-5FFF ( |
| 1A:7C90 | `Unused_TCRF_PhotoOptionIcon_Candidate_Gfx` | 32 | exact pixel match of the TCRF "photo option icon" (2 tiles, 16x8) but these tiles are ON S | exact pixel match of the TCRF "photo option icon" (2 tiles, 16x8) but these tiles are ON SCREEN in normal play |
| 1F:43E4 | `Sfx1_Init_24_SpaceFeverII` | 19 | channel-1 effect init handler of id 24: owner hears a Space Fever II sound (by ear, no con | channel-1 effect init handler of id 24: owner hears a Space Fever II sound (by ear, no confidence given); no r |
| 1F:43EC | `Sfx1_Step_24_SpaceFeverII` | 11 | channel-1 effect step handler of id 24 (owner: Space Fever II sound) | channel-1 effect step handler of id 24 (owner: Space Fever II sound) |

## mode state (106)

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
| 00:3818 | `Mode16_DrawPanoramaToggles_Gfx3818` | 96 | state handler or helper of a screen mode | auto: 96 bytes, tile data; referenced by Mode16_DrawPanoramaToggles |
| 00:3F78 | `Mode1A_State06_PickEffect_Tbl3F78` | 136 | state handler or helper of a screen mode | auto: 136 bytes, bytes; referenced by DjPerf_DrawPlayIcon, Mode1A_State06_PickEffect |
| 03:6C2D | `Mode1A_State04_PlaceOrDelete` | 105 | state handler or helper of a screen mode | A opens the sound picker |
| 03:6DAD | `Mode1A_State08_PickConfirm` | 87 | state handler or helper of a screen mode | A confirms with the button animation |
| 03:6E04 | `Mode1A_State09_ExitDialog` | 160 | state handler or helper of a screen mode | keep / discard dialog |
| 03:6EE1 | `Mode1A_State0A_DeleteDialog` | 93 | state handler or helper of a screen mode | delete this hot spot? dialog |
| 04:5009 | `Mode0F_DrawCopyCount_Tbl5009` | 15 | state handler or helper of a screen mode | auto: 15 bytes, bytes; referenced by Mode0F_DrawCopyCount |
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
| 06:7034 | `Mode18_DrawArrows_Tbl7034` | 56 | state handler or helper of a screen mode | auto: 56 bytes, bytes; referenced by Mode18_DrawArrows |
| 06:706C | `Mode18_DrawArrows_Tbl706C` | 70 | state handler or helper of a screen mode | auto: 70 bytes, bytes; referenced by Mode18_DrawArrows |
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

## effect slot (88)

_Why doubtful:_ slot roles inferred from the first instructions, not from the visible screen effect. _To settle:_ run each effect id in an emulator and look at the screen.

| address | name | bytes | best guess | evidence |
|---|---|---|---|---|
| 03:669F | `HotSpotFx_00_Checkerboard_Gfx669F` | 16 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | auto: 16 bytes, tile data; referenced by HotSpotFx_00_Checkerboard |
| 03:6872 | `HotSpotFx_FlipDE` | 9 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | D ^= $0F |
| 03:687B | `HotSpotFx_ColumnPassA` | 23 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) |  |
| 03:6892 | `HotSpotFx_ColumnPassB` | 18 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) |  |
| 03:68C3 | `HotSpotFx_SpiralStepUp` | 12 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) |  |
| 03:68CF | `HotSpotFx_SpiralStepRight` | 12 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) |  |
| 03:68DB | `HotSpotFx_SpiralStepDown` | 15 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) |  |
| 03:68EA | `HotSpotFx_SpiralStepLeft` | 15 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) |  |
| 03:68F9 | `HotSpotFx_Delay` | 8 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) |  |
| 03:695D | `HotSpotFx_WaveTbl` | 32 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | SCY offsets for the wave |
| 03:697D | `HotSpotFx_Delay2` | 106 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) |  |
| 03:69A3 | `HotSpotFx_PageFlipRamp` | 68 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | SCY ramp per scanline |
| 03:69E7 | `HotSpotFx_PageFlipTbl` | 8 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) |  |
| 03:69EF | `HotSpotFx_Delay3` | 10 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) |  |
| 0A:54DA | `Fx00_CopyRows_A100toC000` | 5891 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 00; scratch FF8A-FF8D loops |
| 0A:54E6 | `Fx01_MirrorCopy_A180toC080` | 72 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 01;22; scratch FF8A-FF8D loops |
| 0A:552E | `Fx02_MirrorCopy_A100toC000` | 73 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 02;21; scratch FF8A-FF8D loops |
| 0A:5577 | `Fx03_Copy_A800toC60E` | 67 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 03;44; scratch FF8A-FF8D loops |
| 0A:55BA | `Fx04_Copy_A100toC000` | 67 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 04;43; scratch FF8A-FF8D loops |
| 0A:55FD | `Fx05_Copy_A400toC000` | 84 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 05; scratch FF8A-FF8D loops |
| 0A:5651 | `Fx06_Copy_A140toC000` | 68 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 06; scratch FF8A-FF8D loops |
| 0A:5695 | `Fx07_Copy_A440toC000` | 167 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 07; scratch FF8A-FF8D loops |
| 0A:573C | `Fx08_Reduce79_A100toC000` | 255 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 08; scratch FF8A-FF8D loops |
| 0A:583B | `Fx09_Reduce_A100_toward_C000` | 6 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | stub: DE := C000; then shared body 0A:6866 (b=$79 reduce table); slots 09 |
| 0A:5841 | `Fx0A_Reduce_A100_toward_C080` | 6 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | stub: DE := C080; then shared body 0A:6866 (b=$79 reduce table); slots 0A |
| 0A:5847 | `Fx0B_Reduce_A100_toward_C700` | 6 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | stub: DE := C700; then shared body 0A:6866 (b=$79 reduce table); slots 0B |
| 0A:584D | `Fx0C_Reduce_A100_toward_C780` | 6 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | stub: DE := C780; then shared body 0A:6866 (b=$79 reduce table); slots 0C |
| 0A:5853 | `Fx0D_Copy_A100toC000` | 87 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 0D; scratch FF8A-FF8D loops |
| 0A:58AA | `Fx0E_Copy_A180toC080` | 86 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 0E; scratch FF8A-FF8D loops |
| 0A:5900 | `Fx0F_CopyRows_A100toC000` | 12 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 0F; scratch FF8A-FF8D loops |
| 0A:590C | `Fx10_CopyRows_A800toC700` | 12 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 10; scratch FF8A-FF8D loops |
| 0A:5918 | `Fx11_Copy_A180toC080` | 137 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 11; scratch FF8A-FF8D loops |
| 0A:59A1 | `Fx12_Copy_A180toC080` | 72 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 12; scratch FF8A-FF8D loops |
| 0A:59E9 | `Fx13_CopyRows_A100toC000` | 12 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 13; scratch FF8A-FF8D loops |
| 0A:59F5 | `Fx14_CopyRows_AB00toCA00` | 12 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 14; scratch FF8A-FF8D loops |
| 0A:5A01 | `Fx15_CopyRows_A100toC000` | 12 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 15; scratch FF8A-FF8D loops |
| 0A:5A0D | `Fx16_CopyRows_A500toC400` | 12 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 16; scratch FF8A-FF8D loops |
| 0A:5A19 | `Fx17_Copy_A430toC330` | 87 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 17; scratch FF8A-FF8D loops |
| 0A:5A70 | `Fx18_Copy_A880toC780` | 70 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 18; scratch FF8A-FF8D loops |
| 0A:5ABD | `Fx20_MirrorCopy_A100toC0F0` | 122 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 20; scratch FF8A-FF8D loops |
| 0A:5B37 | `Fx23_Copy_A800toC7F0` | 79 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 23; scratch FF8A-FF8D loops |
| 0A:5B86 | `Fx24_Copy_A100toC0F0` | 79 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 24; scratch FF8A-FF8D loops |
| 0A:5BD5 | `Fx25_MirrorCopy_A400toC0F0` | 101 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 25; scratch FF8A-FF8D loops |
| 0A:5C3A | `Fx26_Copy_A140toC0F0` | 70 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 26; scratch FF8A-FF8D loops |
| 0A:5C80 | `Fx27_Copy_A440toC0F0` | 167 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 27; scratch FF8A-FF8D loops |
| 0A:5D27 | `Fx28_Reduce7A_A100toC070` | 257 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 28; scratch FF8A-FF8D loops |
| 0A:5E28 | `Fx29_Reduce_A100_toward_C070` | 6 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | stub: DE := C070; then shared body 0A:6906 (b=$79 reduce table); slots 29 |
| 0A:5E2E | `Fx2A_Reduce_A100_toward_C0F0` | 6 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | stub: DE := C0F0; then shared body 0A:6906 (b=$79 reduce table); slots 2A |
| 0A:5E34 | `Fx2B_Reduce_A100_toward_C770` | 6 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | stub: DE := C770; then shared body 0A:6906 (b=$79 reduce table); slots 2B |
| 0A:5E3A | `Fx2C_Reduce_A100_toward_C7F0` | 6 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | stub: DE := C7F0; then shared body 0A:6906 (b=$79 reduce table); slots 2C |
| 0A:5E40 | `Fx2D_MirrorCopy_A180toC070` | 63 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 2D; scratch FF8A-FF8D loops |
| 0A:5E7F | `Fx2E_MirrorCopy_A100toC0F0` | 64 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 2E; scratch FF8A-FF8D loops |
| 0A:5EBF | `Fx2F_MirrorCopy_A100toC0F0` | 61 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 2F; scratch FF8A-FF8D loops |
| 0A:5EFC | `Fx30_MirrorCopy_A800toC7F0` | 61 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 30; scratch FF8A-FF8D loops |
| 0A:5F39 | `Fx31_MirrorCopy_A100toC0F0` | 128 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 31; scratch FF8A-FF8D loops |
| 0A:5FB9 | `Fx32_MirrorCopy_A100toC0F0` | 126 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 32; scratch FF8A-FF8D loops |
| 0A:6037 | `Fx33_MirrorCopy_A100toC0F0` | 61 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 33; scratch FF8A-FF8D loops |
| 0A:6074 | `Fx34_MirrorCopy_AB00toCAF0` | 61 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 34; scratch FF8A-FF8D loops |
| 0A:60B1 | `Fx35_MirrorCopy_A100toC0F0` | 61 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 35; scratch FF8A-FF8D loops |
| 0A:60EE | `Fx36_MirrorCopy_A500toC4F0` | 61 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 36; scratch FF8A-FF8D loops |
| 0A:612B | `Fx37_MirrorCopy_A430toC3C0` | 64 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 37; scratch FF8A-FF8D loops |
| 0A:616B | `Fx38_MirrorCopy_A800toC7F0` | 64 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 38; scratch FF8A-FF8D loops |
| 0A:61B2 | `Fx40_Copy_A100toCD0E` | 105 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 40; scratch FF8A-FF8D loops |
| 0A:621B | `Fx41_MirrorCopy_A180toCD8E` | 78 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 41; scratch FF8A-FF8D loops |
| 0A:6269 | `Fx42_MirrorCopy_A100toCD0E` | 79 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 42; scratch FF8A-FF8D loops |
| 0A:62B8 | `Fx45_Copy_A400toCD0C` | 96 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 45; scratch FF8A-FF8D loops |
| 0A:6318 | `Fx46_Copy_A140toCD0E` | 82 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 46; scratch FF8A-FF8D loops |
| 0A:636A | `Fx47_Copy_A440toCD0C` | 167 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 47; scratch FF8A-FF8D loops |
| 0A:6411 | `Fx48_Reduce79_A100toC60E` | 261 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 48; scratch FF8A-FF8D loops |
| 0A:6516 | `Fx49_Reduce_A100_toward_C60E` | 6 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | stub: DE := C60E; then shared body 0A:69AA (b=$79 reduce table); slots 49 |
| 0A:651C | `Fx4A_Reduce_A100_toward_C68E` | 6 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | stub: DE := C68E; then shared body 0A:69AA (b=$79 reduce table); slots 4A |
| 0A:6522 | `Fx4B_Reduce_A100_toward_CD0E` | 6 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | stub: DE := CD0E; then shared body 0A:69AA (b=$79 reduce table); slots 4B |
| 0A:6528 | `Fx4C_Reduce_A100_toward_CD8E` | 6 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | stub: DE := CD8E; then shared body 0A:69AA (b=$79 reduce table); slots 4C |
| 0A:652E | `Fx4D_Copy_A100toCD0E` | 60 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 4D; scratch FF8A-FF8D loops |
| 0A:656A | `Fx4E_Copy_A180toCD8E` | 59 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 4E; scratch FF8A-FF8D loops |
| 0A:65A5 | `Fx4F_Copy_A800toC60E` | 57 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 4F; scratch FF8A-FF8D loops |
| 0A:65DE | `Fx50_Copy_A100toCD0E` | 57 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 50; scratch FF8A-FF8D loops |
| 0A:6617 | `Fx51_Copy_A100toCD0E` | 120 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 51; scratch FF8A-FF8D loops |
| 0A:668F | `Fx52_Copy_A100toCD0E` | 117 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 52; scratch FF8A-FF8D loops |
| 0A:6704 | `Fx53_Copy_A500toC90E` | 57 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 53; scratch FF8A-FF8D loops |
| 0A:673D | `Fx54_Copy_A100toCD0E` | 57 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 54; scratch FF8A-FF8D loops |
| 0A:6776 | `Fx55_Copy_AB00toC30E` | 57 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 55; scratch FF8A-FF8D loops |
| 0A:67AF | `Fx56_Copy_A100toCD0E` | 57 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 56; scratch FF8A-FF8D loops |
| 0A:67E8 | `Fx57_Copy_A430toCA3E` | 60 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 57; scratch FF8A-FF8D loops |
| 0A:6824 | `Fx58_Copy_A180toCD8E` | 59 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | effect table slot(s) 58; scratch FF8A-FF8D loops |
| 0A:6866 | `FxShared_ReduceBody_G0` | 160 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | shared body of slots 09-0C (b=$79) |
| 0A:6906 | `FxShared_ReduceBody_G1` | 164 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | shared body of slots 29-2C |
| 0A:69AA | `FxShared_ReduceBody_G2` | 151 | one of the transition / hot-spot effect routines of bank 0A (80 effect slots) | shared body of slots 49-4C |

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

## Run minigame (43)

_Why doubtful:_ role of several state variables guessed. _To settle:_ play the game with a watch on the named variables.

| address | name | bytes | best guess | evidence |
|---|---|---|---|---|
| 09:624D | `Run_PlaceRunner0` | 35 | Run (marathon) mini-game routine or table | place check of runner 0 |
| 09:6270 | `Run_PlaceRunner1` | 35 | Run (marathon) mini-game routine or table |  |
| 09:6293 | `Run_PlaceRunner2` | 27 | Run (marathon) mini-game routine or table |  |
| 09:62AE | `Run_PlaceRunner3` | 19 | Run (marathon) mini-game routine or table | unused fourth slot? |
| 09:6604 | `Run_ConfettiInit` | 221 | Run (marathon) mini-game routine or table | random confetti x positions |
| 09:66A5 | `Run_FlagLanded` | 22 | Run (marathon) mini-game routine or table |  |
| 09:67BE | `Run_PlayerRun_Tbl67BE` | 7 | Run (marathon) mini-game routine or table | auto: 7 bytes, bytes; referenced by Run_PlayerRun |
| 09:67FC | `Run_PlayerJump_Tbl67FC` | 52 | Run (marathon) mini-game routine or table | auto: 52 bytes, bytes; referenced by Run_PlayerJump |
| 09:685A | `Run_PlayerAirB_Tbl685A` | 26 | Run (marathon) mini-game routine or table | auto: 26 bytes, bytes; referenced by Run_PlayerAirB |
| 09:68F3 | `Run_PlayerSpeedFromCounter_Tbl68F3` | 7 | Run (marathon) mini-game routine or table | auto: 7 bytes, bytes; referenced by Run_PlayerSpeedFromCounter |
| 09:68FA | `Run_PlayerFrameFromSpeed` | 116 | Run (marathon) mini-game routine or table |  |
| 09:6916 | `Run_PlayerLanding` | 88 | Run (marathon) mini-game routine or table |  |
| 09:696E | `Run_PlayerLanding_Tbl696E` | 32 | Run (marathon) mini-game routine or table | auto: 32 bytes, bytes; referenced by Run_PlayerLanding |
| 09:6A6E | `Run_FlagHoistKeys_Tbl6A6E` | 52 | Run (marathon) mini-game routine or table | auto: 52 bytes, bytes; referenced by Run_FlagHoistKeys |
| 09:6AA2 | `Run_FlagHoistKeys_Tbl6AA2` | 20 | Run (marathon) mini-game routine or table | auto: 20 bytes, bytes; referenced by Run_FlagHoistKeys |
| 09:6B72 | `Run_MoveRunner3X` | 10 | Run (marathon) mini-game routine or table |  |
| 09:6B7C | `Run_ScrollCamera` | 41 | Run (marathon) mini-game routine or table |  |
| 09:6BA5 | `Run_CopyPlayerPos` | 12 | Run (marathon) mini-game routine or table |  |
| 09:6BE1 | `Run_ConfettiUpdate` | 14 | Run (marathon) mini-game routine or table |  |
| 09:6BEF | `Run_ConfettiParticle` | 140 | Run (marathon) mini-game routine or table |  |
| 09:6C7B | `Run_ConfettiRespawn` | 38 | Run (marathon) mini-game routine or table |  |
| 09:6D9C | `Run_DrawPlayer_Tbl6D9C` | 8 | Run (marathon) mini-game routine or table | auto: 8 bytes, bytes; referenced by Run_DrawPlayer |
| 09:6DA4 | `Run_DrawPlayer_Tbl6DA4` | 4 | Run (marathon) mini-game routine or table | auto: 4 bytes, bytes; referenced by Run_DrawPlayer |
| 09:6DA8 | `Run_DrawPlayer_Tbl6DA8` | 52 | Run (marathon) mini-game routine or table | auto: 52 bytes, bytes; referenced by Run_DrawPlayer |
| 09:6DDC | `Run_DrawPlayer_Tbl6DDC` | 42 | Run (marathon) mini-game routine or table | auto: 42 bytes, bytes; referenced by Run_DrawPlayer |
| 09:6E34 | `Run_DrawChick_Tbl6E34` | 98 | Run (marathon) mini-game routine or table | auto: 98 bytes, bytes; referenced by Run_DrawChick |
| 09:6EC4 | `Run_DrawMoleAndScene_Tbl6EC4` | 70 | Run (marathon) mini-game routine or table | auto: 70 bytes, bytes; referenced by Run_DrawMoleAndScene |
| 09:6F0A | `Run_DrawRunner3` | 42 | Run (marathon) mini-game routine or table |  |
| 09:6F25 | `Run_DrawPodiumBanner` | 15 | Run (marathon) mini-game routine or table |  |
| 09:6F34 | `Run_BannerSpriteTbl` | 28 | Run (marathon) mini-game routine or table |  |
| 09:6F50 | `Run_DrawBackgroundScroll` | 75 | Run (marathon) mini-game routine or table |  |
| 09:6FB3 | `Run_DrawHurdles_Tbl6FB3` | 12 | Run (marathon) mini-game routine or table | auto: 12 bytes, bytes; referenced by Run_DrawHurdles |
| 09:6FBF | `Run_DrawFinishLine` | 39 | Run (marathon) mini-game routine or table |  |
| 09:6FE6 | `Run_DrawFinishLine_Tbl6FE6` | 8 | Run (marathon) mini-game routine or table | auto: 8 bytes, bytes; referenced by Run_DrawFinishLine |
| 09:7000 | `Run_FlagSpriteTbl` | 8 | Run (marathon) mini-game routine or table |  |
| 09:702E | `Run_DrawConfettiSprite` | 27 | Run (marathon) mini-game routine or table |  |
| 09:707C | `Run_DrawPickCharacterSprite_Tbl707C` | 56 | Run (marathon) mini-game routine or table | auto: 56 bytes, bytes; referenced by Run_DrawPickCharacterSprite |
| 09:70E1 | `Run_SplitScreenLine` | 70 | Run (marathon) mini-game routine or table | LYC split from the player position |
| 09:7127 | `Run_ScaledPosition` | 23 | Run (marathon) mini-game routine or table |  |
| 09:7173 | `Run_DrawTimerDigit` | 11 | Run (marathon) mini-game routine or table |  |
| 09:717E | `Run_DrawTimerDigitB` | 22 | Run (marathon) mini-game routine or table |  |
| 09:723F | `Run_CharacterToGfxIndex` | 28 | Run (marathon) mini-game routine or table | Game Face present test (D581) |
| 09:725B | `Run_CharacterToGfxIndex_Tbl725B` | 3 | Run (marathon) mini-game routine or table | auto: 3 bytes, bytes; referenced by Run_CharacterToGfxIndex |

## keyboard / glyph (36)

_Why doubtful:_ glyph set identity (kana / Latin / symbol page) deduced from tile addresses. _To settle:_ view the loaded tiles in a VRAM viewer.

| address | name | bytes | best guess | evidence |
|---|---|---|---|---|
| 09:53CA | `Kb_LoadGlyphSetA` | 9 | character-input page or glyph-set loader | glyph list at 09:53D3 to $8800 |
| 09:53D3 | `Kb_LoadGlyphSetA_Gfx53D3` | 25 | character-input page or glyph-set loader | auto: 25 bytes, tile data; referenced by Kb_LoadGlyphSetA |
| 09:53EC | `Kb_LoadGlyphSetB` | 9 | character-input page or glyph-set loader | list at 09:53F5 |
| 09:53F5 | `Kb_LoadGlyphSetB_Gfx53F5` | 25 | character-input page or glyph-set loader | auto: 25 bytes, tile data; referenced by Kb_LoadGlyphSetB |
| 09:540E | `Kb_LoadGlyphSetC` | 9 | character-input page or glyph-set loader | list at 09:5417 |
| 09:5417 | `Kb_LoadGlyphSetC_Gfx5417` | 13 | character-input page or glyph-set loader | auto: 13 bytes, tile data; referenced by Kb_LoadGlyphSetC |
| 09:5424 | `Kb_LoadGlyphList` | 229 | character-input page or glyph-set loader |  |
| 09:5450 | `Kb_GlyphOffset` | 15 | character-input page or glyph-set loader |  |
| 09:545F | `Kb_FindCharInList` | 42 | character-input page or glyph-set loader |  |
| 09:5685 | `Kb_Page0_Draw_Tbl5685` | 160 | character-input page or glyph-set loader | auto: 160 bytes, bytes; referenced by Kb_Page0_Draw, Run_DrawPickCharacterSprite |
| 09:5732 | `Kb_Page1_Draw_Tbl5732` | 20 | character-input page or glyph-set loader | auto: 20 bytes, bytes; referenced by Kb_Page1_Draw |
| 09:5753 | `Kb_Page2_Draw_Tbl5753` | 48 | character-input page or glyph-set loader | auto: 48 bytes, bytes; referenced by Kb_Page2_Draw |
| 09:5790 | `Kb_Page3_Draw_Tbl5790` | 36 | character-input page or glyph-set loader | auto: 36 bytes, bytes; referenced by Kb_Page3_Draw |
| 09:57D7 | `Kb_DrawTabs_Tbl57D7` | 6 | character-input page or glyph-set loader | auto: 6 bytes, bytes; referenced by Kb_DrawTabs |
| 09:57DD | `Kb_DrawTabs_Tbl57DD` | 4 | character-input page or glyph-set loader | auto: 4 bytes, bytes; referenced by Kb_DrawTabs |
| 09:5827 | `Kb_DrawCursor_Tbl5827` | 12 | character-input page or glyph-set loader | auto: 12 bytes, bytes; referenced by Kb_DrawCursor |
| 09:5833 | `Kb_DrawCursor_Tbl5833` | 16 | character-input page or glyph-set loader | auto: 16 bytes, bytes; referenced by Kb_DrawCursor |
| 09:5843 | `Kb_DrawTabPages` | 113 | character-input page or glyph-set loader |  |
| 09:58B4 | `Kb_TabAnimFrame_Tbl58B4` | 14 | character-input page or glyph-set loader | auto: 14 bytes, bytes; referenced by Kb_TabAnimFrame |
| 09:58EA | `Kb_Page0_Navigate_Tbl58EA` | 81 | character-input page or glyph-set loader | auto: 81 bytes, bytes; referenced by Kb_Page0_Navigate |
| 09:593B | `Kb_Page0_Navigate_Tbl593B` | 80 | character-input page or glyph-set loader | auto: 80 bytes, bytes; referenced by Kb_Page0_Navigate |
| 09:598B | `Kb_Page0_Navigate_Tbl598B` | 80 | character-input page or glyph-set loader | auto: 80 bytes, bytes; referenced by Kb_Page0_Navigate |
| 09:59E8 | `Kb_Page1_Navigate_Tbl59E8` | 6 | character-input page or glyph-set loader | auto: 6 bytes, bytes; referenced by Kb_Page1_Navigate |
| 09:5A13 | `Kb_Page1_Navigate_Tbl5A13` | 32 | character-input page or glyph-set loader | auto: 32 bytes, bytes; referenced by Kb_Page1_Navigate |
| 09:5A40 | `Kb_Page2_Navigate_Tbl5A40` | 25 | character-input page or glyph-set loader | auto: 25 bytes, bytes; referenced by Kb_Page2_Navigate |
| 09:5A89 | `Kb_Page2_Navigate_Tbl5A89` | 48 | character-input page or glyph-set loader | auto: 48 bytes, bytes; referenced by Kb_Page2_Navigate |
| 09:5AC6 | `Kb_Page3_Navigate_Tbl5AC6` | 23 | character-input page or glyph-set loader | auto: 23 bytes, bytes; referenced by Kb_Page3_Navigate |
| 09:5B09 | `Kb_Page3_Navigate_Tbl5B09` | 48 | character-input page or glyph-set loader | auto: 48 bytes, bytes; referenced by Kb_Page3_Navigate |
| 09:5B6F | `Kb_NavigateVertical` | 18 | character-input page or glyph-set loader |  |
| 09:5B81 | `Kb_NavigateHorizontal` | 28 | character-input page or glyph-set loader |  |
| 09:5C0E | `Kb_Page0_Press_PtrTbl5C0E` | 6 | character-input page or glyph-set loader | auto: 6 bytes, word table; referenced by Kb_Page0_Press |
| 09:5C7D | `Kb_Page0_Press_Tbl5C7D` | 16 | character-input page or glyph-set loader | auto: 16 bytes, bytes; referenced by Kb_Page0_Press |
| 09:5C93 | `Kb_Page0_Press_Tbl5C93` | 7 | character-input page or glyph-set loader | auto: 7 bytes, bytes; referenced by Kb_Page0_Press |
| 09:5F03 | `Kb_BackspaceOnB` | 15 | character-input page or glyph-set loader |  |
| 09:5F12 | `Kb_BlinkBackground` | 12 | character-input page or glyph-set loader | BGP xor $3C every 4th frame |
| 09:6874 | `Kb_DrawTabPages_Gfx6874` | 6 | character-input page or glyph-set loader | auto: 6 bytes, tile data; referenced by Kb_DrawTabPages |

## main-menu slide (18)

_Why doubtful:_ slide A/B split by code layout only. _To settle:_ watch the menu transition frame by frame.

| address | name | bytes | best guess | evidence |
|---|---|---|---|---|
| 07:7BDC | `MainMenu_SlideA_Begin` | 63 | slide animation between main-menu pages | four-step page transition (HL = draw callback; DE = table of 3-byte steps) |
| 07:7BF4 | `MainMenu_SlideA_Step` | 39 | slide animation between main-menu pages |  |
| 07:7C1B | `MainMenu_SlideA_Tbl0` | 48 | slide animation between main-menu pages |  |
| 07:7C27 | `MainMenu_SlideA_Tbl1` | 12 | slide animation between main-menu pages |  |
| 07:7C33 | `MainMenu_SlideA_Tbl2` | 12 | slide animation between main-menu pages |  |
| 07:7C3F | `MainMenu_SlideA_Tbl3` | 12 | slide animation between main-menu pages |  |
| 07:7C4B | `MainMenu_SlideB_Begin` | 63 | slide animation between main-menu pages |  |
| 07:7C63 | `MainMenu_SlideB_Step` | 39 | slide animation between main-menu pages |  |
| 07:7C8A | `MainMenu_SlideB_Tbl0` | 12 | slide animation between main-menu pages |  |
| 07:7C96 | `MainMenu_SlideB_Tbl1` | 12 | slide animation between main-menu pages |  |
| 07:7CA2 | `MainMenu_SlideB_Tbl2` | 12 | slide animation between main-menu pages |  |
| 07:7CAE | `MainMenu_SlideB_Tbl3` | 12 | slide animation between main-menu pages |  |
| 07:7CBA | `MainMenu_SlideC_Begin` | 63 | slide animation between main-menu pages |  |
| 07:7CD2 | `MainMenu_SlideC_Step` | 39 | slide animation between main-menu pages |  |
| 07:7CF9 | `MainMenu_SlideC_Tbl0` | 24 | slide animation between main-menu pages |  |
| 07:7D05 | `MainMenu_SlideC_Tbl1` | 12 | slide animation between main-menu pages |  |
| 07:7D11 | `MainMenu_SlideWait` | 32 | slide animation between main-menu pages | shared wait step: pacing by menu_trans_stamp |
| 07:7D28 | `MainMenu_SlideWaitLoop` | 728 | slide animation between main-menu pages |  |

## arrow drawing (12)

_Why doubtful:_ direction and owner inferred from the table index. _To settle:_ single-step with the cursor on screen.

| address | name | bytes | best guess | evidence |
|---|---|---|---|---|
| 00:3E54 | `DjTitle_DrawArrowUp2_Tbl3E54` | 292 | small arrow / cursor sprite or tile drawing routine | auto: 292 bytes, bytes; referenced by DjTitle_DrawArrowUp2 |
| 03:75C6 | `HotSpotEd_DrawArrows` | 19 | small arrow / cursor sprite or tile drawing routine | up / down arrow sprites |
| 05:412A | `DjTitle_DrawArrowLeft` | 27 | small arrow / cursor sprite or tile drawing routine |  |
| 05:4145 | `DjTitle_DrawArrowRight` | 29 | small arrow / cursor sprite or tile drawing routine |  |
| 05:41DA | `DjTitle_DrawArrowUp2` | 23 | small arrow / cursor sprite or tile drawing routine |  |
| 05:41F1 | `DjTitle_DrawArrowDown2` | 23 | small arrow / cursor sprite or tile drawing routine |  |
| 05:4321 | `DjTitle_DrawArrowLeft3` | 23 | small arrow / cursor sprite or tile drawing routine |  |
| 05:4338 | `DjTitle_DrawArrowRight3` | 23 | small arrow / cursor sprite or tile drawing routine |  |
| 07:6E99 | `SlideOptA_DrawArrow` | 61 | small arrow / cursor sprite or tile drawing routine |  |
| 07:6EDA | `SlideOptA_DrawArrow_Tbl6EDA` | 6 | small arrow / cursor sprite or tile drawing routine | auto: 6 bytes, bytes; referenced by SlideOptA_DrawArrow |
| 07:6FB0 | `SlideOptB_DrawArrow` | 61 | small arrow / cursor sprite or tile drawing routine |  |
| 07:6FF1 | `SlideOptB_DrawArrow_Tbl6FF1` | 6 | small arrow / cursor sprite or tile drawing routine | auto: 6 bytes, bytes; referenced by SlideOptB_DrawArrow |

## dead code (29)

_Why doubtful:_ never executed in the static trace; purpose read from the instructions only. _To settle:_ TCRF note, or a debugger test with a forced jump.

| address | name | bytes | best guess | evidence |
|---|---|---|---|---|
| 00:2E88 | `Unused_Str_MainPass` | 10 | code or data that no trace path and no table reaches (left over from earlier versions) | ASCII 'MAIN PASS',0 right after Delay_BC; no immediate load of its address in the trace |
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
