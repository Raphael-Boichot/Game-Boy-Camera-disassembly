# wram/ - WRAM and HRAM of Game Boy Camera Gold (USA)

| File | Content |
|---|---|
| `wram_access_gold.csv` | every proven access site to `$C000-$DFFF`, `$FE00-$FF7F`, `$FF80-$FFFE` (10,522 rows; `tools/port_build.py`: the Japanese rows carried through the code map plus the rows of `tools/wram_db.py` on this build's own code) |
| `wram_summary_gold.csv` | one row per address (1,152 addresses): reads, writes, pointer loads, banks, routines, written constants; the columns of `roms/jp_rev_a/wram/wram_summary_jp.csv` (`tools/port_wram_index.py`) |

**The layout is the Japanese one.** The names, sizes and scopes are those of the Japanese map (`roms/jp_rev_a/wram/`, docs §2), carried in `disasm/ram_names_gold.csv`.
No address is used here that the Japanese code does not use; one address is used only by the Japanese code (`$C006`).

Access sites: 10,395 of 10,522 (98.8 %) pair through `port/code_map_gold.csv` with a Japanese site of the same kind at the same address. The 127 others are where this build's code differs: 107 sites have no Japanese pair (new or changed code) and 20 use another Japanese address than the Japanese site they pair with. By routine:

| Routine | Sites |
|---|---|
| `DjSnd_AdvancePlaySteps` | 25 |
| `Mode08_State14_CreditsSheriffHelp` | 12 |
| `Mode08_State15_CreditsSheriffBonus` | 9 |
| `Vram_CopyFromBank4_Padded` | 8 |
| `AlbumB_CheckGate` | 6 |
| `AnimEd_StartExitTransition` | 4 |
| `CommentEditor_Sub0_Init` | 4 |
| `Bank009_State19` | 3 |
| `Mode21_State00_Init` | 3 |
| `Mode0D_State06_PlayInit` | 3 |
| `HotSpotEd_ShowSoundTile` | 3 |
| `Kb_Page0_Press` | 3 |
| `Vram_WaitHBlankInBand` | 3 |
| `Credits_PageA_FadeOut` | 3 |
| `Credits_PageA_FadeIn` | 3 |
| `Credits_PageB_FadeOut` | 3 |
| `Credits_PageB_FadeIn` | 3 |
| `Mode14_State01_LiveView` | 2 |
| `DjEd_ApplyStepIncrement` | 2 |
| `DjS2_DrawValueRow` | 2 |
| `DjS2_WaveRedrawTick` | 2 |
| `DjNs_DrawPlayCursor` | 2 |
| `Mode1D_State06_LoadWaitScreen` | 2 |
| `PickCharacter_BlinkRows` | 2 |
| `Photo_FindSlot_Far` | 1 |
| `Shoot_DrawBrightnessMark` | 1 |
| `Shoot_BrightnessMarkAddr` | 1 |
| `Mode20_State05_PlayDemo` | 1 |
| `Kb_Page2_PressBirthDate` | 1 |
| `Bank003_State21` | 1 |
| `Bank003_State24` | 1 |
| `Bank003_State16` | 1 |
| `Mode13_State01_MusicSelect` | 1 |
| `DjEd_Tick` | 1 |
| `Run_DrawPickedCharacter` | 1 |
| `Kb_DrawPageTabSprite` | 1 |
| `LinkPick_RequestRemotePage` | 1 |
| `DjPrint_SendInitWait` | 1 |
| `Link_DrawProgressBars` | 1 |
