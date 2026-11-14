; Game Boy Camera (USA, Europe), bank $24. Written by tools/make_source.py from roms/us_eu/gbcam_us.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $024", ROMX[$4000], BANK[$24]

; C: frame 1 of the staff-roll dancer (a dancing girl, not identified): {lo,hi,bank,duration} table 09:509C (13
; records, 12 frames each), 0x500 bytes copied alternately to $8000 / $8500 by Mode08_State15_CreditsScroll
Gfx_24_4000_CreditsGirlFrame01::
    INCBIN "data/bank_24/Gfx_24_4000_CreditsGirlFrame01.2bpp" ; $4000, 1152 bytes
; C: far pointer loaded by Mode20_State00_MenuInit (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 8 replay(s) of the organic corpus, modes 08 20 (roms/jp_rev_a/experiments/l3_names/)
Map_24_4480_Mode20_State00_MenuInit::
    INCBIN "data/bank_24/Map_24_4480_Mode20_State00_MenuInit.tilemap" ; $4480, 128 bytes
; C: copied to VRAM/WRAM by Ball_MenuLoadRow (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in
; 6 replay(s) of the organic corpus, modes 20 (roms/jp_rev_a/experiments/l3_names/); L3 same: the readers here
; (Ball_MenuLoadRow) are the readers of the same name in the Japanese listing
Map_24_4480_Ball_MenuLoadRow_Part4500::
    INCBIN "data/bank_24/Map_24_4480_Ball_MenuLoadRow_Part4500.tilemap" ; $4500, 448 bytes
; C: far pointer loaded by Ball_MenuLoadRow (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 256 from the
; nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 20); C: the ...
Map_24_46C0_Ball_MenuLoadRow::
    INCBIN "data/bank_24/Map_24_46C0_Ball_MenuLoadRow.tilemap" ; $46C0, 256 bytes
; C: far pointer loaded by Mode0D_State01_Hub (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 128 from the
; nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 0D)
Map_24_47C0_Mode0D_State01_Hub::
    INCBIN "data/bank_24/Map_24_47C0_Mode0D_State01_Hub.tilemap" ; $47C0, 128 bytes
; C: copied to VRAM/WRAM by Mode0D_State00_Init, Mode0D_State02_OptionsMenu, Mode0D_State03_OptionA,
; Mode0D_State04_OptionB (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, ...
Map_24_4840_Mode0D_State00_Init::
    INCBIN "data/bank_24/Map_24_4840_Mode0D_State00_Init.tilemap" ; $4840, 512 bytes
; C: far pointer loaded by Mode0D_State02_OptionsMenu, Mode0D_State03_OptionA, Mode0D_State04_OptionB (ld a,BANK; ld
; hl,ADDR; call banked copy/far call). L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic
; runs of the core emulator (coverage/results/merged_state/cov.npz, first ...
Map_24_4A40_Mode0D_State02_OptionsMenu::
    INCBIN "data/bank_24/Map_24_4A40_Mode0D_State02_OptionsMenu.tilemap" ; $4A40, 64 bytes
; C: far pointer loaded by Mode0D_State01_Hub (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 128 from the
; nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 0D)
Map_24_4A80_Mode0D_State01_Hub::
    INCBIN "data/bank_24/Map_24_4A80_Mode0D_State01_Hub.tilemap" ; $4A80, 128 bytes
; C: far pointer loaded by PenMenu_BuildPattern, PenMenu_BuildSize (ld a,BANK; ld hl,ADDR; call banked copy/far call);
; length 32 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the organic corpus, modes 10
; (roms/jp_rev_a/experiments/l3_names/)
Map_24_4B00_PenMenu_BuildSize::
    INCBIN "data/bank_24/Map_24_4B00_PenMenu_BuildSize.tilemap" ; $4B00, 32 bytes
; C: target 0 of the word table 04:67A5 (indexed by the page builder: 4 panels of 192 bytes); length 192 from the
; nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 10)
Map_24_4B20_PenMenuSizePanel0::
    INCBIN "data/bank_24/Map_24_4B20_PenMenuSizePanel0.tilemap" ; $4B20, 192 bytes
; C: far pointer loaded by PenMenu_BuildPattern, PenMenu_BuildSize (ld a,BANK; ld hl,ADDR; call banked copy/far call);
; length 32 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the organic corpus, modes 10
; (roms/jp_rev_a/experiments/l3_names/)
Map_24_4BE0_PenMenu_BuildSize::
    INCBIN "data/bank_24/Map_24_4BE0_PenMenu_BuildSize.tilemap" ; $4BE0, 32 bytes
; C: target 1 of the word table 04:67A5 (indexed by the page builder: 4 panels of 192 bytes); length 192 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the organic corpus, modes 10
; (roms/jp_rev_a/experiments/l3_names/)
Map_24_4C00_PenMenuSizePanel1::
    INCBIN "data/bank_24/Map_24_4C00_PenMenuSizePanel1.tilemap" ; $4C00, 192 bytes
; C: target 2 of the word table 04:67A5 (indexed by the page builder: 4 panels of 192 bytes); length 192 from the
; nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 10)
Map_24_4CC0_PenMenuSizePanel2::
    INCBIN "data/bank_24/Map_24_4CC0_PenMenuSizePanel2.tilemap" ; $4CC0, 192 bytes
; C: target 3 of the word table 04:67A5 (indexed by the page builder: 4 panels of 192 bytes); length 192 from the
; nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 10)
Map_24_4D80_PenMenuSizePanel3::
    INCBIN "data/bank_24/Map_24_4D80_PenMenuSizePanel3.tilemap" ; $4D80, 192 bytes
; I: 7th row of the pen-menu panel 24:4D80: the page builder copies 192 bytes = 6 rows (table 04:67A5) and stops right
; before it (the bottom border row); bytes equal to the Japanese ones; nothing in the code points to it (no
; instruction operand with its address after a load of its bank, no table word, ...
Map_24_4E40_PenMenuSizePanel3_ExtraRow::
    INCBIN "data/bank_24/Map_24_4E40_PenMenuSizePanel3_ExtraRow.tilemap" ; $4E40, 32 bytes
; C: target 0 of the word table 04:67EF (indexed by the page builder: 4 panels of 192 bytes); length 192 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 10
; (roms/jp_rev_a/experiments/l3_names/)
Map_24_4E60_PenMenuPatternPanel0::
    INCBIN "data/bank_24/Map_24_4E60_PenMenuPatternPanel0.tilemap" ; $4E60, 192 bytes
; I: 7th row of the pen-menu panel 24:4E60 (6 rows copied, table 04:67EF); the bottom border row; bytes equal to the
; Japanese ones; nothing in the code points to it (no instruction operand with its address after a load of its bank,
; no table word, no copy whose range covers it; 2026-11-02); evidence I ...
Map_24_4F20_PenMenuPatternPanel0_ExtraRow::
    INCBIN "data/bank_24/Map_24_4F20_PenMenuPatternPanel0_ExtraRow.tilemap" ; $4F20, 32 bytes
; C: target 1 of the word table 04:67EF (indexed by the page builder: 4 panels of 192 bytes); length 192 from the
; nearby ld bc. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from
; the code: panel 1 of the word table 04:67EF read by the pattern page ...
Map_24_4F40_PenMenuPatternPanel1::
    INCBIN "data/bank_24/Map_24_4F40_PenMenuPatternPanel1.tilemap" ; $4F40, 192 bytes
; C: target 2 of the word table 04:67EF (indexed by the page builder: 4 panels of 192 bytes); length 192 from the
; nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 10)
Map_24_5000_PenMenuPatternPanel2::
    INCBIN "data/bank_24/Map_24_5000_PenMenuPatternPanel2.tilemap" ; $5000, 192 bytes
; C: target 3 of the word table 04:67EF (indexed by the page builder: 4 panels of 192 bytes); length 192 from the
; nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 10)
Map_24_50C0_PenMenuPatternPanel3::
    INCBIN "data/bank_24/Map_24_50C0_PenMenuPatternPanel3.tilemap" ; $50C0, 192 bytes
; C: copied to VRAM/WRAM by Mode0E_State06_ExchangeSetup, Mode0E_State0A_ExchangeSetupB
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in the scenarios link_exchange 0E:06,
; link_exchange 0E:0A (roms/jp_rev_a/experiments/l3_names/scen_hits*.csv); L3 same: the readers here ...
Map_24_5180_Mode0E_State06_ExchangeSetup::
    INCBIN "data/bank_24/Map_24_5180_Mode0E_State06_ExchangeSetup.tilemap" ; $5180, 576 bytes
; C: copied to VRAM/WRAM by Mode0E_State06_ExchangeSetup, Mode0E_State0A_ExchangeSetupB
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in the scenarios link_exchange 0E:06,
; link_exchange 0E:0A (roms/jp_rev_a/experiments/l3_names/scen_hits*.csv); L3 copy-loader: ...
Map_24_53C0_Mode0E_State06_ExchangeSetup::
    INCBIN "data/bank_24/Map_24_53C0_Mode0E_State06_ExchangeSetup.tilemap" ; $53C0, 256 bytes
; C: copied to VRAM/WRAM by PhotoPicker_Init, Mode0F_State00_Init, Mode0F_State01_ReInit, LinkPick_Substate0_Init
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 83 replay(s) of the organic corpus, modes
; 0A 0F 10 11 1A 1C (roms/jp_rev_a/experiments/l3_names/)
Map_24_54C0_Mode0F_State00_Init::
    INCBIN "data/bank_24/Map_24_54C0_Mode0F_State00_Init.tilemap" ; $54C0, 64 bytes
; C: far pointer loaded by PhotoPicker_PageTransitionNext, PhotoPicker_PageTransitionPrev, LinkPick_PageTurnNext,
; LinkPick_PageTurnPrev (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass 2026-10-26: read in BGB in 83
; replay(s) of the organic corpus, modes 0A 0F 10 11 1A 1C ...
Map_24_5500_PhotoPicker_PageTransitionPrev::
    INCBIN "data/bank_24/Map_24_5500_PhotoPicker_PageTransitionPrev.tilemap" ; $5500, 736 bytes
; C: copied to VRAM/WRAM by Unused_Link_LoadTiles, Cam_CalibSanityCheck, Cam_FactoryCalibration
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic
; runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 00)
Gfx_24_57E0_Unused_Link_LoadTiles::
    INCBIN "data/bank_24/Gfx_24_57E0_Unused_Link_LoadTiles.2bpp" ; $57E0, 256 bytes
; C: copied to VRAM/WRAM by Cam_CalibSanityCheck, Cam_FactoryCalibration (roms/jp_rev_a/assets/catalog_jp.csv). L3
; pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 00)
Gfx_24_57E0_Cam_CalibSanityCheck_Part58E0::
    INCBIN "data/bank_24/Gfx_24_57E0_Cam_CalibSanityCheck_Part58E0.2bpp" ; $58E0, 512 bytes
; C: copied to VRAM/WRAM by Mode08_State03_CardInit, OwnerCard_BlinkTitle (roms/jp_rev_a/assets/catalog_jp.csv). L3
; pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 08 (roms/jp_rev_a/experiments/l3_names/);
; C: the bytes changed but Mode08_State03_CardInit reads them in this build ...
Map_24_5AE0_Mode08_State03_CardInit::
    INCBIN "data/bank_24/Map_24_5AE0_Mode08_State03_CardInit.tilemap" ; $5AE0, 544 bytes
; C: far pointer loaded by OwnerCard_BlinkTitle (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 08 (roms/jp_rev_a/experiments/l3_names/)
Map_24_5D00_OwnerCard_BlinkTitle::
    INCBIN "data/bank_24/Map_24_5D00_OwnerCard_BlinkTitle.tilemap" ; $5D00, 32 bytes
; C: far pointer loaded by OwnerCard_BlinkTitle (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 128 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 08
; (roms/jp_rev_a/experiments/l3_names/); C: the bytes changed but OwnerCard_BlinkTitle reads ...
Map_24_5D20_OwnerCard_BlinkTitle::
    INCBIN "data/bank_24/Map_24_5D20_OwnerCard_BlinkTitle.tilemap" ; $5D20, 128 bytes
; C: far pointer loaded by OwnerCard_BlinkTitle (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 32 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 08
; (roms/jp_rev_a/experiments/l3_names/)
Map_24_5DA0_OwnerCard_BlinkTitle::
    INCBIN "data/bank_24/Map_24_5DA0_OwnerCard_BlinkTitle.tilemap" ; $5DA0, 32 bytes
; C: far pointer loaded by Kb_Page1_PressSex, Kb_Page3_PressBloodType (ld a,BANK; ld hl,ADDR; call banked copy/far
; call); length 320 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes
; 08 (roms/jp_rev_a/experiments/l3_names/)
Map_24_5DC0_Kb_Page1_PressSex::
    INCBIN "data/bank_24/Map_24_5DC0_Kb_Page1_PressSex.tilemap" ; $5DC0, 320 bytes
; I: 2 rows after the 10 rows ($140) of the map 24:5DC0 that Kb_Page1_PressSex copies; bytes equal to the Japanese
; ones; nothing in the code points to it (no instruction operand with its address after a load of its bank, no table
; word, no copy whose range covers it; 2026-11-02); evidence I (2026-11-02): ...
Map_24_5F00_Kb_Page1_PressSex_ExtraRows::
    INCBIN "data/bank_24/Map_24_5F00_Kb_Page1_PressSex_ExtraRows.tilemap" ; $5F00, 64 bytes
; C: far pointer loaded by Kb_Page2_PressBirthDate (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 320 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 08
; (roms/jp_rev_a/experiments/l3_names/)
Map_24_5F40_Kb_Page2_PressBirthDate::
    INCBIN "data/bank_24/Map_24_5F40_Kb_Page2_PressBirthDate.tilemap" ; $5F40, 320 bytes
; I: row 10 of the map 24:5F40 ($140 copied by Kb_Page2_PressBirthDate); bytes equal to the Japanese ones; nothing in
; the code points to it (no instruction operand with its address after a load of its bank, no table word, no copy
; whose range covers it; 2026-11-02); evidence I (2026-11-02): the Japanese ...
Map_24_6080_Kb_Page2_PressBirthDate_ExtraRows::
    INCBIN "data/bank_24/Map_24_6080_Kb_Page2_PressBirthDate_ExtraRows.tilemap" ; $6080, 32 bytes
; C: map of page 0 of the SHOOT parlor (04:743C list): 18 rows of 32 bytes (0x240 up to 24:62E0); Parlor_LoadPage
; (04:73EF) ends each page list ($FF) with {lo,hi,bank} stored in $D7D9-$D7DB, which Parlor_SpiralWipeIn (04:7479)
; hands to Map_SpiralWipeIn (00:0DA0); the coverage shows columns 0-19 of 18 ...
Map_24_60A0_Parlor_Page0::
    INCBIN "data/bank_24/Map_24_60A0_Parlor_Page0.tilemap" ; $60A0, 160 bytes
; C: rows 5-6 of the page 0 map (0x40 bytes): first entry of Parlor_AnimQueenTiles_Tbl72CA, copied from bank $24 to
; $98A0 by Parlor_AnimQueenTiles (04:728C) every few frames; the neutral face of the queen (frame B is 24:62E0)
Map_24_6140_Parlor_Page0_QueenFrameA::
    INCBIN "data/bank_24/Map_24_6140_Parlor_Page0_QueenFrameA.tilemap" ; $6140, 128 bytes
; C: far pointer loaded by Mode01_State02_ApplyPageA (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 64
; from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 89 replay(s) of the organic corpus, modes 01
; (roms/jp_rev_a/experiments/l3_names/); C: the 64 bytes of the Japanese type row are ...
Map_24_61C0_Mode01_State02_ApplyPageA::
    INCBIN "data/bank_24/Map_24_61C0_Mode01_State02_ApplyPageA.tilemap" ; $61C0, 288 bytes
; C: 0x40 bytes: second entry of Parlor_AnimQueenTiles_Tbl72CA, copied from bank $24 to $98A0 (rows 5-6 of the BG map)
; by Parlor_AnimQueenTiles (04:728C); the changed tiles ($CB-$CE, row 5) are the blink / mouth frame of the queen
Map_24_62E0_Parlor_Page0_QueenFrameB::
    INCBIN "data/bank_24/Map_24_62E0_Parlor_Page0_QueenFrameB.tilemap" ; $62E0, 64 bytes
; C: far pointer loaded by Mode01_State00_Intro (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 64 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 88 replay(s) of the organic corpus, modes 01
; (roms/jp_rev_a/experiments/l3_names/)
Map_24_6320_Mode01_State00_Intro::
    INCBIN "data/bank_24/Map_24_6320_Mode01_State00_Intro.tilemap" ; $6320, 64 bytes
; I: two head rows of the option-page map of mode $16: here Mode16_OptionMapSrcTbl entry 2 is this label + $20, so
; Mode16_BuildOptionList copies from 24:6380 (row 1) and only row 0 (24:6360-637F) is never loaded; evidence I
; (2026-11-02): the name says it is unused / never loaded; that something is never ...
Map_24_6360_Mode16_OptionPage2_HeadRows::
    INCBIN "data/bank_24/Map_24_6360_Mode16_OptionPage2_HeadRows.tilemap" ; $6360, 64 bytes
; C: option page 2: 16 rows to $9840 (table entry 2), then Mode16_BuildList4 reads pieces from 24:6507 and 24:65A0; L3
; same: the readers here (Mode16_BuildList4) are the readers of the same name in the Japanese listing
Map_24_63A0_Mode16_OptionPage2::
    INCBIN "data/bank_24/Map_24_63A0_Mode16_OptionPage2.tilemap" ; $63A0, 504 bytes
; C: far pointer loaded by Mode17_State00_Init (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 8 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 10 replay(s), modes 16 (states 16:05 16:01), not only by the
; consumer the name gives: a shared asset or table; first organic loader in the ...
Gfx_24_6598_Mode17_State00_Init::
    INCBIN "data/bank_24/Gfx_24_6598_Mode17_State00_Init.bin" ; $6598, 8 bytes
; C: far pointer loaded by Mode16_BuildList4 (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 128 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 10 replay(s) of the organic corpus, modes 16
; (roms/jp_rev_a/experiments/l3_names/); C: the bytes changed but Mode16_BuildList4 reads them ...
Map_24_65A0_Mode16_BuildList4::
    INCBIN "data/bank_24/Map_24_65A0_Mode16_BuildList4.tilemap" ; $65A0, 128 bytes
; C: copied to VRAM/WRAM by Mode1A_State02_Setup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 10 replay(s) of the organic corpus, modes 1A (roms/jp_rev_a/experiments/l3_names/)
Map_24_6620_Mode1A_State02_Setup::
    INCBIN "data/bank_24/Map_24_6620_Mode1A_State02_Setup.tilemap" ; $6620, 704 bytes
; C: copied to VRAM/WRAM by Mode17_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 19 replay(s) of the organic corpus, modes 17 (roms/jp_rev_a/experiments/l3_names/)
Map_24_68E0_Mode17_State00_Init::
    INCBIN "data/bank_24/Map_24_68E0_Mode17_State00_Init.tilemap" ; $68E0, 320 bytes
; C: far pointer loaded by Compose_DrawLayoutPreview (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 19 replay(s) of the organic corpus, modes 17 (roms/jp_rev_a/experiments/l3_names/); L3
; same: the readers here (Compose_DrawLayoutPreview) are the readers of the ...
Map_24_6A20_Compose_DrawLayoutPreview::
    INCBIN "data/bank_24/Map_24_6A20_Compose_DrawLayoutPreview.tilemap" ; $6A20, 256 bytes
; C: far pointer loaded by Compose_DrawLayoutPreview (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 128
; from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the organic corpus, modes 17
; (roms/jp_rev_a/experiments/l3_names/)
Map_24_6B20_Compose_DrawLayoutPreview::
    INCBIN "data/bank_24/Map_24_6B20_Compose_DrawLayoutPreview.tilemap" ; $6B20, 128 bytes
; C: copied to VRAM/WRAM by Mode1C_State02_ShowPrintScreen, Mode1C_DrawOptionScreen
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 9 replay(s) of the organic corpus, modes
; 1C (roms/jp_rev_a/experiments/l3_names/)
Map_24_6BA0_Mode1C_State02_ShowPrintScreen::
    INCBIN "data/bank_24/Map_24_6BA0_Mode1C_State02_ShowPrintScreen.tilemap" ; $6BA0, 704 bytes
; C: far pointer loaded by Shoot_DrawOptionPanel (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 704 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the organic corpus, modes 14
; (roms/jp_rev_a/experiments/l3_names/); C: the bytes changed but Shoot_DrawOptionPanel ...
Map_24_6E60_Shoot_DrawOptionPanel::
    INCBIN "data/bank_24/Map_24_6E60_Shoot_DrawOptionPanel.tilemap" ; $6E60, 704 bytes
; C: copied to VRAM/WRAM by Mode10_State02_Setup, Unused_LoadTilemap24_7120 (roms/jp_rev_a/assets/catalog_jp.csv). L3
; pass 2026-10-26: read in BGB in 7 replay(s) of the organic corpus, modes 10 (roms/jp_rev_a/experiments/l3_names/);
; C: the bytes changed but Mode10_State02_Setup reads them in this build ...
Map_24_7120_Mode10_State02_Setup::
    INCBIN "data/bank_24/Map_24_7120_Mode10_State02_Setup.tilemap" ; $7120, 704 bytes
; C: far pointer loaded by Album_LoadBorderScreen, Album_ShowPageScreenB (ld a,BANK; ld hl,ADDR; call banked copy/far
; call); length 704 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 71 replay(s) of the organic corpus,
; modes 09 0A (roms/jp_rev_a/experiments/l3_names/); C: the bytes changed ...
Map_24_73E0_Album_ShowPageScreenB::
    INCBIN "data/bank_24/Map_24_73E0_Album_ShowPageScreenB.tilemap" ; $73E0, 687 bytes
; C: tile-map rows read by Album_ShowPageScreenB and Album_LoadBorderScreen (the album screens of modes $09 / $0A)
Map_24_768F_Mode09_State01::
    INCBIN "data/bank_24/Map_24_768F_Mode09_State01.tilemap" ; $768F, 17 bytes
; C: far pointer loaded by PenMenu_BuildSpeed (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 32 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 10
; (roms/jp_rev_a/experiments/l3_names/)
Map_24_76A0_PenMenu_BuildSpeed::
    INCBIN "data/bank_24/Map_24_76A0_PenMenu_BuildSpeed.tilemap" ; $76A0, 32 bytes
; C: target 0 of the word table 04:6839 (indexed by the page builder: 3 panels of 192 bytes); length 192 from the
; nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 10)
Map_24_76C0_PenMenuSpeedPanel0::
    INCBIN "data/bank_24/Map_24_76C0_PenMenuSpeedPanel0.tilemap" ; $76C0, 96 bytes
; C: far pointer loaded by PenMenu_BuildSpeed (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 128 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 10
; (roms/jp_rev_a/experiments/l3_names/)
Map_24_7720_PenMenu_BuildSpeed::
    INCBIN "data/bank_24/Map_24_7720_PenMenu_BuildSpeed.tilemap" ; $7720, 128 bytes
; C: target 1 of the word table 04:6839 (indexed by the page builder: 3 panels of 192 bytes); length 192 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 10
; (roms/jp_rev_a/experiments/l3_names/)
Map_24_77A0_PenMenuSpeedPanel1::
    INCBIN "data/bank_24/Map_24_77A0_PenMenuSpeedPanel1.tilemap" ; $77A0, 96 bytes
; C: target 2 of the word table 04:6839 (indexed by the page builder: 3 panels of 192 bytes); length 192 from the
; nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 10)
Map_24_7800_PenMenuSpeedPanel2::
    INCBIN "data/bank_24/Map_24_7800_PenMenuSpeedPanel2.tilemap" ; $7800, 96 bytes
; C: far pointer loaded by PenMenu_Build (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 256 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the organic corpus, modes 10
; (roms/jp_rev_a/experiments/l3_names/)
Map_24_7860_PenMenu_Build::
    INCBIN "data/bank_24/Map_24_7860_PenMenu_Build.tilemap" ; $7860, 256 bytes
; C: far pointer loaded by Shoot_DrawOptionPanel, Shoot_RestoreViewScreen (ld a,BANK; ld hl,ADDR; call banked copy/far
; call); length 704 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the organic corpus, modes
; 14 (roms/jp_rev_a/experiments/l3_names/)
Map_24_7960_Shoot_RestoreViewScreen::
    INCBIN "data/bank_24/Map_24_7960_Shoot_RestoreViewScreen.tilemap" ; $7960, 704 bytes
; C: copied to VRAM/WRAM by Mode12_State11_TestStart, Mode13_State03_PlayPrepare, Mode09_State00_Init,
; Album_ShowPageScreen, Mode0A_State02_Setup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in
; 76 replay(s) of the organic corpus, modes 09 0A 12 ...
Map_24_7C20_Mode12_State11_TestStart::
    INCBIN "data/bank_24/Map_24_7C20_Mode12_State11_TestStart.tilemap" ; $7C20, 704 bytes
; C: copied to VRAM/WRAM by SaveDialog_Substate3_FullInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in 2 replay(s) of the organic corpus, modes 10 12 (roms/jp_rev_a/experiments/l3_names/); C: the bytes
; changed but SaveDialog_Substate3_FullInit reads them in this build ...
Map_24_7C20_SaveDialog_Substate3_FullInit_Part7EE0::
    INCBIN "data/bank_24/Map_24_7C20_SaveDialog_Substate3_FullInit_Part7EE0.tilemap" ; $7EE0, 288 bytes
