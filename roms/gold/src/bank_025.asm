; Game Boy Camera Gold (USA), bank $25. Written by tools/make_source.py from roms/gold/gbcam_gold.sym and the tables of
; roms/gold/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $025", ROMX[$4000], BANK[$25]

; C: frame 5 of the staff-roll dancer (a dancing girl, not identified): {lo,hi,bank,duration} table 09:509C (13
; records, 12 frames each), 0x500 bytes copied alternately to $8000 / $8500 by Mode08_State15_CreditsScroll
Gfx_25_4000_CreditsGirlFrame05::
    INCBIN "data/bank_25/Gfx_25_4000_CreditsGirlFrame05.2bpp" ; $4000, 1152 bytes
; C: far pointer loaded by Mode08_State14_CreditsPageB (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 08 (roms/jp_rev_a/experiments/l3_names/)
Gfx_25_4480_Mode08_State14_CreditsPageB::
    INCBIN "data/bank_25/Gfx_25_4480_Mode08_State14_CreditsPageB.2bpp" ; $4480, 128 bytes
; C: frame 0 of the staff-roll dancer (a dancing girl, not identified): {lo,hi,bank,duration} table 09:509C (13
; records, 12 frames each), 0x500 bytes copied alternately to $8000 / $8500 by Mode08_State15_CreditsScroll
Gfx_25_4480_CreditsGirlFrame00_Part4500::
    INCBIN "data/bank_25/Gfx_25_4480_CreditsGirlFrame00_Part4500.2bpp" ; $4500, 704 bytes
; C: far pointer loaded by Mode14_State00_Init, Mode14_State0C_Reinit, Shoot_RestoreViewScreen (ld a,BANK; ld hl,ADDR;
; call banked copy/far call). L3 pass 2026-10-26: read in BGB in 74 replay(s) of the organic corpus, modes 08 14
; (roms/jp_rev_a/experiments/l3_names/); L3 same: the readers here ...
Map_25_47C0_Mode14_State0C_Reinit::
    INCBIN "data/bank_25/Map_25_47C0_Mode14_State0C_Reinit.tilemap" ; $47C0, 448 bytes
; C: copied to VRAM/WRAM by Mode14_State00_Init, Shoot_TimerTick (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass
; 2026-10-26: read in BGB in 72 replay(s) of the organic corpus, modes 14 (roms/jp_rev_a/experiments/l3_names/); C:
; the bytes changed but Mode14_State00_Init reads them in this build (coverage ...
Map_25_47C0_Mode14_State00_Init_Part4980::
    INCBIN "data/bank_25/Map_25_47C0_Mode14_State00_Init_Part4980.tilemap" ; $4980, 256 bytes
; I: four map rows of $FF between the map 25:47C0 (22 rows, copied to $9800) and the map 25:4B00; filler; nothing in
; the code points to it (no instruction operand with its address after a load of its bank, no table word, no copy
; whose range covers it; 2026-11-02); evidence I (2026-11-02): the Japanese ...
Map_25_4A80_BlankRows::
    INCBIN "data/bank_25/Map_25_4A80_BlankRows.tilemap" ; $4A80, 128 bytes
; I: 22-row map (0x2C0 bytes): 16x14 photo-area ramp (00-8F, 00-4F) with icon blocks (A0-DF) and two icon; L3 same:
; the readers here (Unused_LoadTilemap25_4B00) are the readers of the same name in the Japanese listing; bytes equal
; to us_eu 25:4B00; evidence I (2026-11-02): the Japanese label ...
BgMap_25_4B00::
    INCBIN "data/bank_25/BgMap_25_4B00.tilemap" ; $4B00, 704 bytes
; C: copied to VRAM/WRAM by Mode11_State02_Setup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 35 replay(s) of the organic corpus, modes 11 (roms/jp_rev_a/experiments/l3_names/)
Map_25_4DC0_Mode11_State02_Setup::
    INCBIN "data/bank_25/Map_25_4DC0_Mode11_State02_Setup.tilemap" ; $4DC0, 704 bytes
; I: rows 0-1 (ramp 00-27) of option page 1 (rows 2-17 = 25:50C0); never loaded; L3 module: read here by
; Mode16_BuildOptionList (64), Mode1B_State00_Init (16), Mode14_State00_Init (1), of the module its name gives (read
; sites, bytes per routine); bytes equal to us_eu 25:5080; evidence I (2026-11-02): ...
Map_25_5080_Mode16_OptionPage1_HeadRows::
    INCBIN "data/bank_25/Map_25_5080_Mode16_OptionPage1_HeadRows.tilemap" ; $5080, 64 bytes
; C: option page 1: 16 rows to $9840 (table entry 1), then Mode16_BuildList2 reads 8-byte pieces from 25:51E7 and
; 25:52C0; L3 same: the readers here (Mode16_BuildList2) are the readers of the same name in the Japanese listing;
; bytes equal to us_eu 25:50C0
Map_25_50C0_Mode16_OptionPage1::
    INCBIN "data/bank_25/Map_25_50C0_Mode16_OptionPage1.tilemap" ; $50C0, 512 bytes
; C: far pointer loaded by Mode16_BuildList2 (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 96 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 16
; (roms/jp_rev_a/experiments/l3_names/); C: the bytes changed but Mode16_BuildList2 reads them in ...
Map_25_52C0_Mode16_BuildList2::
    INCBIN "data/bank_25/Map_25_52C0_Mode16_BuildList2.tilemap" ; $52C0, 96 bytes
; I: rows 0-1 (ramp 00-27) of option page 3 (rows 2-17 = 25:5360); never loaded; L3 module: read here by
; Mode16_BuildOptionList (55), Mode1D_State01_LoadScreen (12), Mode14_State00_Init (10), Mode1B_State00_Init (4), of
; the module its name gives (read sites, bytes per routine); bytes equal to us_eu ...
Map_25_5320_Mode16_OptionPage3_HeadRows::
    INCBIN "data/bank_25/Map_25_5320_Mode16_OptionPage3_HeadRows.tilemap" ; $5320, 64 bytes
; C: option page 3: 16 rows to $9840 (table entry 3), then Mode16_BuildList6 reads pieces from 25:5507 and 25:5560; L3
; same: the readers here (Mode16_BuildList6) are the readers of the same name in the Japanese listing; bytes equal to
; us_eu 25:5360
Map_25_5360_Mode16_OptionPage3::
    INCBIN "data/bank_25/Map_25_5360_Mode16_OptionPage3.tilemap" ; $5360, 512 bytes
; C: far pointer loaded by Mode16_BuildList6 (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 96 from the
; nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 16); C: the ...
Map_25_5560_Mode16_BuildList6::
    INCBIN "data/bank_25/Map_25_5560_Mode16_BuildList6.tilemap" ; $5560, 96 bytes
; C: copied to VRAM/WRAM by Mode07_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 13 replay(s) of the organic corpus, modes 07 (roms/jp_rev_a/experiments/l3_names/)
Map_25_55C0_Mode07_State00_Init::
    INCBIN "data/bank_25/Map_25_55C0_Mode07_State00_Init.tilemap" ; $55C0, 192 bytes
; C: far pointer loaded by SpaceFever_Boss_EndB (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 13 replay(s) of the organic corpus, modes 07 (roms/jp_rev_a/experiments/l3_names/)
Map_25_5680_SpaceFever_Boss_EndB::
    INCBIN "data/bank_25/Map_25_5680_SpaceFever_Boss_EndB.tilemap" ; $5680, 416 bytes
; C: far pointer loaded by SpaceFever_Boss_EndA, SpaceFever_Boss_EndB (ld a,BANK; ld hl,ADDR; call banked copy/far
; call); length 20 from the nearby ld bc. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios,
; core organic runs); C from the code: map loaded by SpaceFever_Boss_EndB ...
Map_25_5820_SpaceFever_Boss_EndB::
    INCBIN "data/bank_25/Map_25_5820_SpaceFever_Boss_EndB.tilemap" ; $5820, 32 bytes
; C: copied to VRAM/WRAM by Cam_CalibSanityCheck (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not
; reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 00)
Map_25_5840_Cam_CalibSanityCheck::
    INCBIN "data/bank_25/Map_25_5840_Cam_CalibSanityCheck.tilemap" ; $5840, 576 bytes
; C: copied to VRAM/WRAM by Cam_CalibSanityCheck (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not
; reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 00)
Map_25_5A80_Cam_CalibSanityCheck_OkRow::
    INCBIN "data/bank_25/Map_25_5A80_Cam_CalibSanityCheck_OkRow.tilemap" ; $5A80, 32 bytes
; C: copied to VRAM/WRAM by Cam_CalibSanityCheck (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not
; reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 00)
Map_25_5AA0_Cam_CalibSanityCheck_NgRow::
    INCBIN "data/bank_25/Map_25_5AA0_Cam_CalibSanityCheck_NgRow.tilemap" ; $5AA0, 32 bytes
; C: copied to VRAM/WRAM by Cam_FactoryCalibration (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not
; reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 00)
Map_25_5AC0_Cam_FactoryCalibration::
    INCBIN "data/bank_25/Map_25_5AC0_Cam_FactoryCalibration.tilemap" ; $5AC0, 576 bytes
; C: copied to VRAM/WRAM by Cam_FactoryCalibration (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not
; reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 00)
Map_25_5D00_Cam_FactoryCalibration::
    INCBIN "data/bank_25/Map_25_5D00_Cam_FactoryCalibration.tilemap" ; $5D00, 32 bytes
; C: copied to VRAM/WRAM by Mode08_State0F_HiScoreInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 2 replay(s) of the organic corpus, modes 08 (roms/jp_rev_a/experiments/l3_names/); C: the bytes changed
; but Mode08_State0F_HiScoreInit reads them in this build (coverage call ...
Map_25_5D20_Mode08_State0F_HiScoreInit::
    INCBIN "data/bank_25/Map_25_5D20_Mode08_State0F_HiScoreInit.tilemap" ; $5D20, 576 bytes
; C: copied to VRAM/WRAM by Mode21_State02_RaceSceneInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 21)
Map_25_5F60_Mode21_State02_RaceSceneInit::
    INCBIN "data/bank_25/Map_25_5F60_Mode21_State02_RaceSceneInit.tilemap" ; $5F60, 576 bytes
; C: copied to VRAM/WRAM by Mode1D_State01_LoadScreen (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 11 replay(s) of the organic corpus, modes 1D (roms/jp_rev_a/experiments/l3_names/); C: the bytes changed
; but Mode1D_State01_LoadScreen reads them in this build (coverage call ...
Map_25_61A0_Mode1D_State01_LoadScreen::
    INCBIN "data/bank_25/Map_25_61A0_Mode1D_State01_LoadScreen.tilemap" ; $61A0, 576 bytes
; C: copied to VRAM/WRAM by Mode15_State01_TimerInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 25 replay(s) of the organic corpus, modes 15 (roms/jp_rev_a/experiments/l3_names/); C: the bytes changed
; but Mode15_State01_TimerInit reads them in this build (coverage call ...
Map_25_63E0_Mode15_State01_TimerInit::
    INCBIN "data/bank_25/Map_25_63E0_Mode15_State01_TimerInit.tilemap" ; $63E0, 576 bytes
; C: map 1 of the dancing man (Kentaro Nishimura) (table 09:517D, 0x240 bytes to $9800), cycled by
; Credits_NextDancingFrame
Map_25_6620_CreditsNishimuraDanceMap1::
    INCBIN "data/bank_25/Map_25_6620_CreditsNishimuraDanceMap1.tilemap" ; $6620, 576 bytes
; C: copied to VRAM/WRAM by Mode15_State05_IntervalInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in 6 replay(s) of the organic corpus, modes 15 (roms/jp_rev_a/experiments/l3_names/); C: the bytes
; changed but Mode15_State05_IntervalInit reads them in this build (coverage ...
Map_25_6860_Mode15_State05_IntervalInit::
    INCBIN "data/bank_25/Map_25_6860_Mode15_State05_IntervalInit.tilemap" ; $6860, 576 bytes
; C: copied to VRAM/WRAM by WildFramePicker_Substate0_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in 2 replay(s) of the organic corpus, modes 1C (roms/jp_rev_a/experiments/l3_names/)
Map_25_6AA0_WildFramePicker_Substate0_Init::
    INCBIN "data/bank_25/Map_25_6AA0_WildFramePicker_Substate0_Init.tilemap" ; $6AA0, 576 bytes
; C: copied to VRAM/WRAM by Mode05_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 32 replay(s) of the organic corpus, modes 05 (roms/jp_rev_a/experiments/l3_names/)
Map_25_6CE0_Mode05_State00_Init::
    INCBIN "data/bank_25/Map_25_6CE0_Mode05_State00_Init.tilemap" ; $6CE0, 576 bytes
; I: rows 0-1 (ramp 00-27) of option page 0 (rows 2-17 = 25:71A0); never loaded, as for every page; L3 module: read
; here by Mode16_BuildOptionList (73), Mode16_State00_Init (8), Mode07_State00_Init (3), Mode11_State02_Setup (2), of
; the module its name gives (read sites, bytes per routine); bytes equal ...
Map_25_6F20_Mode16_OptionPage0_HeadRows::
    INCBIN "data/bank_25/Map_25_6F20_Mode16_OptionPage0_HeadRows.tilemap" ; $6F20, 64 bytes
; C: option page 0 of mode $16: 16 rows of 32 copied to $9840 by Mode16_BuildOptionList (table 06:4B67 entry 0); its
; builder Mode16_BuildList0 is a bare ret; L3 module: read here by Mode16_BuildOptionList (1024), of the module its
; name gives (read sites, bytes per routine); bytes equal to us_eu 25:6F60
Map_25_6F60_Mode16_OptionPage0::
    INCBIN "data/bank_25/Map_25_6F60_Mode16_OptionPage0.tilemap" ; $6F60, 512 bytes
; C: copied to VRAM/WRAM by Mode16_State00_Init, Mode16_State01_Redraw, Mode16_State03_TrickLensesMenu,
; Mode16_State04_MontageMenu, Mode16_State05_PanoramaMenu, Mode16_State06_GameFaceMenu
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 13 replay(s) of the organic corpus, modes
; ...
Map_25_7160_Mode16_State00_Init::
    INCBIN "data/bank_25/Map_25_7160_Mode16_State00_Init.tilemap" ; $7160, 72 bytes
; C: BG map: BGB, menu walk node H30 (tools/jp/guide_nodes.py, the international ROM, same bytes here): its first 16
; bytes are in VRAM map; read by Mode16_State03_TrickLensesMenu
Map_25_71A8_Mode16_State03_TrickLensesMenu::
    INCBIN "data/bank_25/Map_25_71A8_Mode16_State03_TrickLensesMenu.tilemap" ; $71A8, 504 bytes
; I: tile map (18 rows of 32) of an unused photo screen: rows 0-1 and 16-17 are $E0 across the 20 visible columns,
; rows 2-15 are $E0 $E0, the straight 16-wide photo ramp $00-$DF and $E0 $E0, columns 20-31 are the hidden $FF; the
; layout of the used hot-spot viewer map 3F:7D00 (mode 0C, which loads the ...
Map_25_73A0_Unused_PhotoScreen::
    INCBIN "data/bank_25/Map_25_73A0_Unused_PhotoScreen.tilemap" ; $73A0, 576 bytes
; C: tile map (18 rows of 32) of the unused one-page main menu: the picture is in columns 0-19, the 12 hidden columns
; are $29; ids 00-E9 de-duplicated and descending (16-column picture E9-2C, 4-column strip 2B-00); drawn with the
; tiles 17:5500 (BGB, README 16.25.1); no copy site reaches it. Identical in ...
Map_25_75E0_Unused_MainMenu::
    INCBIN "data/bank_25/Map_25_75E0_Unused_MainMenu.tilemap" ; $75E0, 576 bytes
; C: copied to VRAM/WRAM by Boot_EraseAllPrompt_Far (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 2 replay(s) of the organic corpus, modes 00 (roms/jp_rev_a/experiments/l3_names/); C: the bytes changed but
; Boot_EraseAllPrompt_Far reads them in this build (coverage call site ...
Map_25_7820_Boot_EraseAllPrompt_Far::
    INCBIN "data/bank_25/Map_25_7820_Boot_EraseAllPrompt_Far.tilemap" ; $7820, 576 bytes
; C: copied to VRAM/WRAM by Mode1B_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 9 replay(s) of the organic corpus, modes 1B (roms/jp_rev_a/experiments/l3_names/); C: the bytes changed but
; Mode1B_State00_Init reads them in this build (coverage call site or loader ...
Map_25_7A60_Mode1B_State00_Init::
    INCBIN "data/bank_25/Map_25_7A60_Mode1B_State00_Init.tilemap" ; $7A60, 576 bytes
; C: BG map: Mode08_State16_CreditsScroll copies it to $9800 (farcopy); also target 40 of the stamp table 04:539D. Was
; Src_25_7CA0_Mode08_State16_CreditsScroll
Map_25_7CA0_Mode08_State16_CreditsScroll::
    INCBIN "data/bank_25/Map_25_7CA0_Mode08_State16_CreditsScroll.tilemap" ; $7CA0, 288 bytes
; C: $240 B = 18 rows of 32: a BG map read through Vram_CopyFromBank by Mode16_BuildOptionList (SHUTTERBUG / option
; pages) and Mode14_State00_Init; new in this build (no Japanese block has these bytes)
Map_25_7DC0_OptionScreens::
    INCBIN "data/bank_25/Map_25_7DC0_OptionScreens.tilemap" ; $7DC0, 576 bytes
