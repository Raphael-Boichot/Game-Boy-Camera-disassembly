# Unconclusive names of the Pocket Camera (Japan) Rev A symbol file

Generated from `sym_names_jp.csv` by `tools/make_doubts.py` (companion: `sym_unconclusive_jp.csv`, same rows with evidence and "what would settle it"). It lists every label whose name is a guess I could not settle from the code, the README, the WRAM map, TCRF, the Spriters Resource sheets or the bank pictures, plus the `I` (inferred) names in the groups below that deserve a second look. **Nothing here blocks the disassembly**: the `.sym` is complete (every ROM byte is typed and every routine or table has a name) and builds the exact ROM; the names below are the ones most likely to be renamed later.

Reading the names: `Gfx_BB_AAAA_*` = 2bpp tile data, `Map_BB_AAAA_*` = tile map rows (32 bytes per row, 20 visible), `Src_BB_AAAA_*` = data loaded through a far pointer whose destination class is not known, `*_Aux` = same family as the neighbouring named asset (consumer not found), `*_Unref` = no neighbouring consumer at all, `Data_BB_AAAA` = small unread block.

Bank pictures of the unresolved data: `sym_unconclusive_banks/bank_BB.png` (every 2bpp tile of the bank, 32 tiles per row, row label = address of the first tile; grey = typed and named, orange = unreferenced span (name ends `_Aux` / `_Unref`, listed in "content-classified span" unless settled as unused, as the four ball-head frames of bank 16 are), blue = other `?` assets).

| group | rows | bytes (of the block) | what would help |
|---|---|---|---|
| visually identified range | 0 | 0 | a yes/no on the family name |
| far-pointer asset, extent unknown | 0 | 0 | where each block ends (the length copied at run time) and what it is |
| content-classified span | 13 | 4246 | what each span is: look at the bank image, or tell me the screen it belongs to |
| unknown data (no reader found) | 0 | 0 | nothing urgent: small leftovers; a VRAM-viewer look would settle them |
| auto-named table | 0 | 0 | what the table indexes |
| hand name, unconfirmed | 0 | 0 | a check of the guess |
| mode state | 0 | 0 | the screen / state names seen in the real game (compare with TCRF or Funtography) |
| effect slot | 0 | 0 | which visible effect each slot gives |
| SFX tag | 95 | 2528 | the sound each id plays |
| Run minigame | 0 | 0 | variable roles during play |
| keyboard / glyph | 0 | 0 | which glyph page each loader fills |
| main-menu slide | 0 | 0 | which transition each slide is |
| arrow drawing | 0 | 0 | which cursor / arrow each routine draws |
| dead code | 0 | 0 | whether the code or data is truly unused, or for a TCRF graphic the owner's check of the match |

Not counted above: 36 rows proven unused, whose tag is final (I for most: the verdict is that nothing uses them, so no run or screen can confirm it; C for the four ball-head frames) (`doubts_overrides_jp.csv`, status `final`); they are listed with the proof in the last section and in `sym_settled_unused_jp.csv`.

## content-classified span (13)

_Why doubtful:_ type confirmed by the owner (review page, by eye); role and consumer not found. _To settle:_ the role only: the owner naming the picture from the bank image, or a reader caught by a BGB read watchpoint on the span over the organic corpus.

- `0C:6C00` instead: _why_ type chosen from the bytes (map rows vs tiles), consumer not found; _to settle_ view the bank image, then find the reader with a breakpoint on the bank number write.
- `23:58C0` instead: _why_ type chosen from the bytes (map rows vs tiles), consumer not found; _to settle_ view the bank image, then find the reader with a breakpoint on the bank number write.

- bank 0C: `6C00` Mode12_State1D_SortDialogOpen_Aux (48 B)
- bank 15: `5200` MainMenu_DrawUpperItem2_Aux (512 B), `5500` SlidePlay_ReadKeys_Aux (256 B)
- bank 18: `7D80` Mode0F_State04_LeaveSelected_Aux (256 B)
- bank 1A: `5182` Unref (90 B), `7E00` Unref (501 B)
- bank 1C: `5C20` Mode09_State02_PhotoArrows_Aux (64 B)
- bank 1D: `7B41` Tbl539D_Aux (63 B)
- bank 1E: `7D00` Unref (184 B)
- bank 21: `6AC7` Unref (177 B), `6B91` Unref (47 B)
- bank 23: `58C0` Mode0F_ConfirmFrameStrip_Unref (1024 B), `5CC0` Mode0E_ExchangeAlt_Unref (1024 B)

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
| 1F:47F4 | `Sfx1_Step_09_MenuPageUp` | 30 | sound-effect slot of the sound engine (bank 1F); the number is the effect id or a step of its state machine | channel-1 effect step handler of ids 09 (table $4276) |
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

## settled as unused, final I (36)

_Why not doubtful:_ the name and the kind are not in question and no reader can exist; nothing more can be learnt about them.

| address | name | bytes | group it left | proof |
|---|---|---|---|---|
| 16:7380 | `Gfx_16_7380_MainMenu_BallHeadAnim_F5_Unref` | 512 | content-classified span | listed only by MainMenu_SlideA_Tbl3, which no code loads; BGB (2026-10-14): the main-menu transitions read frames 0-4 only |
| 16:7580 | `Gfx_16_7580_MainMenu_BallHeadAnim_F6_Unref` | 512 | content-classified span | listed only by MainMenu_SlideA_Tbl2 / Tbl3, which no code loads; BGB (2026-10-14): the transitions read frames 0-4 only |
| 16:7780 | `Gfx_16_7780_MainMenu_BallHeadAnim_F7_Unref` | 512 | content-classified span | listed only by MainMenu_SlideA_Tbl2 / Tbl3, which no code loads; BGB (2026-10-14): the transitions read frames 0-4 only |
| 16:7980 | `Gfx_16_7980_MainMenu_BallHeadAnim_F8_Unref` | 512 | content-classified span | listed only by MainMenu_SlideA_Tbl2 / Tbl3, which no code loads; BGB (2026-10-14): the transitions read frames 0-4 only |
| 00:2E88 | `Unused_Str_MainPass` | 10 | dead code | no load of its address in the trace, which has 0 unresolved indirect jumps (README 1.3, L2) |
| 02:46E6 | `Unused_Photo_SaveReceived_Far_Stray46E6` | 3 | dead code | no pointer targets it, 0 unresolved indirect jumps; BGB link exchange with logging watchpoints: 0 reads and 0 executions while the jp before it ran twice |
| 04:4D09 | `Unused_Mode0F_State09_EraseOne_Tbl4D09` | 18 | dead code | no instruction loads an address in 04:4D09-4D1A, 0 unresolved indirect jumps; BGB replay of erase-one-photo: 0 reads, control watchpoint 12 hits |
| 04:6403 | `Unused_LoadTilemap24_7120` | 15 | dead code | UNREFERENCED in assets/reach_components_jp.csv (no call / jp / jr / pointer word reaches it) and the trace has 0 unresolved indirect jumps |
| 04:6412 | `Unused_LoadTilemap25_4B00` | 15 | dead code | UNREFERENCED in assets/reach_components_jp.csv and the trace has 0 unresolved indirect jumps |
| 04:7C9D | `Unused_Mode0A_PhotoStepWrap` | 55 | dead code | UNREFERENCED in assets/reach_components_jp.csv and the trace has 0 unresolved indirect jumps |
| 05:622D | `Unused_DjEd_LoadPerformerTiles9100` | 23 | dead code | UNREFERENCED in assets/reach_components_jp.csv and the trace has 0 unresolved indirect jumps |
| 05:7F1C | `Unused_Ball_LoadGfx9100` | 23 | dead code | UNREFERENCED in assets/reach_components_jp.csv and the trace has 0 unresolved indirect jumps |
| 05:7F33 | `Unused_Ball_LoadGfx9480` | 23 | dead code | UNREFERENCED in assets/reach_components_jp.csv and the trace has 0 unresolved indirect jumps |
| 06:71CC | `Unused_Shoot_TimerKeys` | 66 | dead code | UNREFERENCED in assets/reach_components_jp.csv and the trace has 0 unresolved indirect jumps |
| 07:41C8 | `Unused_Mode0E_GotoState12` | 6 | dead code | UNREFERENCED in assets/reach_components_jp.csv and the trace has 0 unresolved indirect jumps |
| 07:4A4D | `Unused_Link_DrawPhotoNumber` | 65 | dead code | UNREFERENCED in assets/reach_components_jp.csv and the trace has 0 unresolved indirect jumps |
| 07:4BC3 | `Unused_Link_LoadTiles` | 26 | dead code | UNREFERENCED in assets/reach_components_jp.csv (one component 07:4BC3-4BE9 with 07:4BDD and 07:4BE4) and the trace has 0 unresolved indirect jumps |
| 07:4BDD | `Unused_Link_WriteHexByte` | 7 | dead code | part of the UNREFERENCED component 07:4BC3-4BE9 (assets/reach_components_jp.csv); called only from it |
| 07:4BE4 | `Unused_Link_WriteHexNibble` | 6 | dead code | part of the UNREFERENCED component 07:4BC3-4BE9 (assets/reach_components_jp.csv); called only from it |
| 07:4BEA | `Unused_Link_SumSlotBuffer` | 30 | dead code | UNREFERENCED in assets/reach_components_jp.csv and the trace has 0 unresolved indirect jumps |
| 07:503D | `Unused_LinkPick_LoadPhotoIndexB` | 3 | dead code | UNREFERENCED in assets/reach_components_jp.csv and the trace has 0 unresolved indirect jumps |
| 0D:7660 | `Unused_TCRF_KanjiMiddleBeforeAfterHave_Gfx` | 384 | dead code | never on screen in organic runs (README 16.24); TCRF match confirmed by the owner by eye (owner_answers_jp.csv) |
| 15:4480 | `Unused_TCRF_JapaneseMenuTile_CircledX_Gfx` | 16 | dead code | on screen only in forced runs (README 16.24); TCRF match confirmed by the owner by eye |
| 15:4500 | `Unused_TCRF_JapaneseMenuTile_CircledX_Copy2_Gfx` | 16 | dead code | never on screen in organic runs, on screen only in forced runs (README 16.24); TCRF match confirmed by the owner by eye |
| 15:4580 | `Unused_TCRF_JapaneseMenuTile_CircledX_Copy3_Gfx` | 16 | dead code | never on screen in organic runs, on screen only in forced runs (README 16.24); TCRF match confirmed by the owner by eye |
| 18:5A50 | `Unused_TCRF_MarginPrint_BFilmRoll_Gfx` | 96 | dead code | loaded with the option screen, never stably on screen (README 16.24); TCRF match confirmed by the owner by eye |
| 18:5F90 | `Unused_TCRF_MarginPrint_OutlinedText_Gfx` | 192 | dead code | never stably on screen (README 16.24); TCRF match confirmed by the owner by eye |
| 1C:5920 | `Unused_TCRF_HotSpotEffectIcons_Extra_Gfx` | 512 | dead code | on screen only when the effect number is forced above 7 (README 16.8, 16.24); TCRF match confirmed by the owner by eye |
| 1F:46DD | `Unused_Sfx1_Init_46DD` | 8 | dead code | UNREFERENCED in assets/reach_components_jp.csv; no sound-effect table lists it |
| 1F:4A61 | `Unused_Sfx1_Step_4A61` | 8 | dead code | UNREFERENCED in assets/reach_components_jp.csv; no sound-effect table lists it |
| 1F:4FBC | `Unused_Snd_SetFreeze` | 6 | dead code | UNREFERENCED in assets/reach_components_jp.csv and the trace has 0 unresolved indirect jumps |
| 1F:53B9 | `Unused_Snd_SongPan_Load` | 46 | dead code | UNREFERENCED in assets/reach_components_jp.csv and the trace has 0 unresolved indirect jumps |
| 1F:53E7 | `Unused_Snd_Pan_Step` | 40 | dead code | UNREFERENCED in assets/reach_components_jp.csv and the trace has 0 unresolved indirect jumps |
| 1F:5743 | `Unused_Snd_Vib_Tail` | 46 | dead code | dead tail after an unconditional jr (UNREFERENCED in assets/reach_components_jp.csv) |
| 07:7C33 | `MainMenu_SlideA_Tbl2` | 12 | main-menu slide | no ld de of its address in either ROM (only Tbl0 / Tbl1 are loaded, 07:7297-7782) and the step code adds no offset |
| 07:7C3F | `MainMenu_SlideA_Tbl3` | 12 | main-menu slide | no ld de of its address in either ROM and the step code adds no offset |
