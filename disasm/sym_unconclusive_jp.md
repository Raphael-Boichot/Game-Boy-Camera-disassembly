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
| SFX tag | 1 | 1 | nothing from the owner: sounds are tagged by caller (2026-10-26) |
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

## SFX tag (1)

_Why doubtful:_ no reader found. _To settle:_ a BGB read watchpoint on the byte; sounds themselves are tagged by function / caller, never by ear (owner rule 2026-10-26).

| address | name | bytes | best guess | evidence |
|---|---|---|---|---|
| 1F:4362 | `Sfx1_Data_4362` | 1 | sound-engine label of bank 1F that is not the handler of a named id (the handlers carry the caller name of their id, C) | one byte $C9 before the first register block |

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
