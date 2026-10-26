; Pocket Camera (Japan) (Rev A), bank $24. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $024", ROMX[$4000], BANK[$24]

; C: frame 1 of the staff-roll dancer (a dancing girl, not identified): {lo,hi,bank,duration} table 09:509C (13
; records, 12 frames each), 0x500 bytes copied alternately to $8000 / $8500 by Mode08_State15_CreditsScroll
Gfx_24_4000_CreditsGirlFrame01::
    INCBIN "data/bank_24/Gfx_24_4000_CreditsGirlFrame01.2bpp" ; $4000, 1152 bytes
; C: far pointer loaded by Mode20_State00_MenuInit (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 8 replay(s) of the organic corpus, modes 08 20 (tcrf_check/assets/l3_names/)
Map_24_4480_Mode20_State00_MenuInit::
    INCBIN "data/bank_24/Map_24_4480_Mode20_State00_MenuInit.tilemap" ; $4480, 128 bytes
; C: copied to VRAM/WRAM by Ball_MenuLoadRow (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in
; 6 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Map_24_4480_Ball_MenuLoadRow_Part4500::
    INCBIN "data/bank_24/Map_24_4480_Ball_MenuLoadRow_Part4500.tilemap" ; $4500, 448 bytes
; C: far pointer loaded by Ball_MenuLoadRow (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 256 from the
; nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 20)
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
; (tcrf_check/assets/l3_names/)
Map_24_4B00_PenMenu_BuildSize::
    INCBIN "data/bank_24/Map_24_4B00_PenMenu_BuildSize.tilemap" ; $4B00, 32 bytes
; C: target 0 of the word table 04:67A5 (indexed by the page builder: 4 panels of 192 bytes); length 192 from the
; nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 10)
Map_24_4B20_PenMenuSizePanel0::
    INCBIN "data/bank_24/Map_24_4B20_PenMenuSizePanel0.tilemap" ; $4B20, 192 bytes
; C: far pointer loaded by PenMenu_BuildPattern, PenMenu_BuildSize (ld a,BANK; ld hl,ADDR; call banked copy/far call);
; length 32 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the organic corpus, modes 10
; (tcrf_check/assets/l3_names/)
Map_24_4BE0_PenMenu_BuildSize::
    INCBIN "data/bank_24/Map_24_4BE0_PenMenu_BuildSize.tilemap" ; $4BE0, 32 bytes
; C: target 1 of the word table 04:67A5 (indexed by the page builder: 4 panels of 192 bytes); length 192 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the organic corpus, modes 10
; (tcrf_check/assets/l3_names/)
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
; I: 7th row of the pen-menu panel 24:4D80 (the page builder copies 192 bytes = 6 rows, table 04:67A5): the bottom
; border row, not copied; was Data_24_4E40
Map_24_4E40_PenMenuSizePanel3_ExtraRow::
    INCBIN "data/bank_24/Map_24_4E40_PenMenuSizePanel3_ExtraRow.tilemap" ; $4E40, 32 bytes
; C: target 0 of the word table 04:67EF (indexed by the page builder: 4 panels of 192 bytes); length 192 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 10
; (tcrf_check/assets/l3_names/)
Map_24_4E60_PenMenuPatternPanel0::
    INCBIN "data/bank_24/Map_24_4E60_PenMenuPatternPanel0.tilemap" ; $4E60, 192 bytes
; I: 7th row of the pen-menu panel 24:4E60 (the page builder copies 192 bytes = 6 rows, table 04:67EF): the bottom
; border row, not copied; was Data_24_4F20
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
; link_exchange 0E:0A (tcrf_check/assets/l3_names/scen_hits*.csv)
Map_24_5180_Mode0E_State06_ExchangeSetup::
    INCBIN "data/bank_24/Map_24_5180_Mode0E_State06_ExchangeSetup.tilemap" ; $5180, 576 bytes
; C: copied to VRAM/WRAM by Mode0E_State06_ExchangeSetup, Mode0E_State0A_ExchangeSetupB
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in the scenarios link_exchange 0E:06,
; link_exchange 0E:0A (tcrf_check/assets/l3_names/scen_hits*.csv)
Map_24_53C0_Mode0E_State06_ExchangeSetup::
    INCBIN "data/bank_24/Map_24_53C0_Mode0E_State06_ExchangeSetup.tilemap" ; $53C0, 256 bytes
; C: copied to VRAM/WRAM by PhotoPicker_Init, Mode0F_State00_Init, Mode0F_State01_ReInit, LinkPick_Substate0_Init
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 83 replay(s) of the organic corpus, modes
; 0A 0F 10 11 1A 1C (tcrf_check/assets/l3_names/)
Map_24_54C0_Mode0F_State00_Init::
    INCBIN "data/bank_24/Map_24_54C0_Mode0F_State00_Init.tilemap" ; $54C0, 64 bytes
; C: far pointer loaded by PhotoPicker_PageTransitionNext, PhotoPicker_PageTransitionPrev, LinkPick_PageTurnNext,
; LinkPick_PageTurnPrev (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass 2026-10-26: read in BGB in 83
; replay(s) of the organic corpus, modes 0A 0F 10 11 1A 1C ...
Map_24_5500_PhotoPicker_PageTransitionPrev::
    db $e0, $e1, $e2, $e2, $e2, $e2, $e2, $e2, $e2, $e2, $e2, $e2, $e2, $e2, $e2, $e2, $e2, $e2, $e2, $fa, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e3, $e4, $e5, $ef, $b0, $b1, $b2, $b3, $ef, $00, $01, $02, $03, $ef, $10, $11, $12, $13, $ef, $eb, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e6, $e7, $f0, $f1, $b4, $b5, $b6, $b7, $ef, $04, $05, $06, $07, $ef, $14, $15, $16, $17, $f7, $f8, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $dc, $dd, $ef, $f2, $b8, $b9, $ba, $bb, $ef, $08, $09, $0a, $0b, $ef, $18, $19, $1a, $1b, $f9, $eb, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $dc, $dd, $ef, $ef, $bc, $bd, $be, $bf, $ef, $0c, $0d, $0e, $0f, $ef, $1c, $1d, $1e, $1f, $ef, $eb, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e3, $e4, $e5, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $eb, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e6, $e7, $e8, $ef, $20, $21, $22, $23, $ef, $30, $31, $32, $33, $ef, $40, $41, $42, $43, $ef, $eb, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $dc, $dd, $f3, $f1, $24, $25, $26, $27, $ef, $34, $35, $36, $37, $ef, $44, $45, $46, $47, $f7, $f8, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $dc, $dd, $ef, $f2, $28, $29, $2a, $2b, $ef, $38, $39, $3a, $3b, $ef, $48, $49, $4a, $4b, $f9, $eb, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e3, $e4, $e5, $ef, $2c, $2d, $2e, $2f, $ef, $3c, $3d, $3e, $3f, $ef, $4c, $4d, $4e, $4f, $ef, $eb, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e6, $e7, $e8, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $eb, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $dc, $dd, $ef, $ef, $50, $51, $52, $53, $ef, $60, $61, $62, $63, $ef, $70, $71, $72, $73, $ef, $eb, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $dc, $dd, $f3, $f1, $54, $55, $56, $57, $ef, $64, $65, $66, $67, $ef, $74, $75, $76, $77, $f7, $f8, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e3, $e4, $e5, $f2, $58, $59, $5a, $5b, $ef, $68, $69, $6a, $6b, $ef, $78, $79, $7a, $7b, $f9, $eb, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e6, $e7, $e8, $ef, $5c, $5d, $5e, $5f, $ef, $6c, $6d, $6e, $6f, $ef, $7c, $7d, $7e, $7f, $ef, $eb, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f4, $f5, $f6, $f6, $f6, $f6, $f6, $f6, $f6, $fc, $de, $df, $fd, $f6, $f6, $f6, $f6, $f6, $f6, $fb, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

    ; padding
    ds $e0, $ff

; C: copied to VRAM/WRAM by Unused_Link_LoadTiles, Cam_FactoryDiag_AllButtonsExceptB, Cam_FirstBoot_StorePleaseWait
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic
; runs of the core emulator (coverage/results/merged_state/cov.npz, first ...
Gfx_24_57E0_Unused_Link_LoadTiles::
    INCBIN "data/bank_24/Gfx_24_57E0_Unused_Link_LoadTiles.2bpp" ; $57E0, 256 bytes
; C: copied to VRAM/WRAM by Cam_FactoryDiag_AllButtonsExceptB, Cam_FirstBoot_StorePleaseWait
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic
; runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 00)
Gfx_24_57E0_Cam_FactoryDiag_AllButtonsExceptB_Part58E0::
    INCBIN "data/bank_24/Gfx_24_57E0_Cam_FactoryDiag_AllButtonsExceptB_Part58E0.2bpp" ; $58E0, 512 bytes
; C: copied to VRAM/WRAM by Mode08_State03_CardInit, OwnerCard_BlinkTitle (roms/jp_rev_a/assets/catalog_jp.csv). L3
; pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Map_24_5AE0_Mode08_State03_CardInit::
    INCBIN "data/bank_24/Map_24_5AE0_Mode08_State03_CardInit.tilemap" ; $5AE0, 544 bytes
; C: far pointer loaded by OwnerCard_BlinkTitle (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Map_24_5D00_OwnerCard_BlinkTitle::
    INCBIN "data/bank_24/Map_24_5D00_OwnerCard_BlinkTitle.tilemap" ; $5D00, 32 bytes
; C: far pointer loaded by OwnerCard_BlinkTitle (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 128 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 08
; (tcrf_check/assets/l3_names/)
Map_24_5D20_OwnerCard_BlinkTitle::
    INCBIN "data/bank_24/Map_24_5D20_OwnerCard_BlinkTitle.tilemap" ; $5D20, 128 bytes
; C: far pointer loaded by OwnerCard_BlinkTitle (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 32 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 08
; (tcrf_check/assets/l3_names/)
Map_24_5DA0_OwnerCard_BlinkTitle::
    INCBIN "data/bank_24/Map_24_5DA0_OwnerCard_BlinkTitle.tilemap" ; $5DA0, 32 bytes
; C: far pointer loaded by Kb_Page1_PressSex, Kb_Page3_PressBloodType (ld a,BANK; ld hl,ADDR; call banked copy/far
; call); length 320 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes
; 08 (tcrf_check/assets/l3_names/)
Map_24_5DC0_Kb_Page1_PressSex::
    INCBIN "data/bank_24/Map_24_5DC0_Kb_Page1_PressSex.tilemap" ; $5DC0, 320 bytes
; I: 2 rows after the 10 rows (0x140) of the map 24:5DC0 that Kb_Page1_PressSex copies; the last one is the descending
; id ramp $36-$23 seen after the other keyboard maps; no copy reads it; was Data_24_5F00
Map_24_5F00_Kb_Page1_PressSex_ExtraRows::
    INCBIN "data/bank_24/Map_24_5F00_Kb_Page1_PressSex_ExtraRows.tilemap" ; $5F00, 64 bytes
; C: far pointer loaded by Kb_Page2_PressBirthDate (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 320 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 08
; (tcrf_check/assets/l3_names/)
Map_24_5F40_Kb_Page2_PressBirthDate::
    INCBIN "data/bank_24/Map_24_5F40_Kb_Page2_PressBirthDate.tilemap" ; $5F40, 320 bytes
; I: row 10 and the start of row 11 of the map 24:5F40 (0x140 copied by Kb_Page2_PressBirthDate): the id ramp $36-$23
; then fill; no copy reads it; was Data_24_6080 | the 32 bytes 6080-609F are one whole map row; the 2 bytes of the old
; 60A0-60A1 tail belong to the Parlor page 0 map (24:60A0)
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
; (tcrf_check/assets/l3_names/)
Map_24_61C0_Mode01_State02_ApplyPageA::
    INCBIN "data/bank_24/Map_24_61C0_Mode01_State02_ApplyPageA.tilemap" ; $61C0, 288 bytes
; C: 0x40 bytes: second entry of Parlor_AnimQueenTiles_Tbl72CA, copied from bank $24 to $98A0 (rows 5-6 of the BG map)
; by Parlor_AnimQueenTiles (04:728C); the changed tiles ($CB-$CE, row 5) are the blink / mouth frame of the queen
Map_24_62E0_Parlor_Page0_QueenFrameB::
    INCBIN "data/bank_24/Map_24_62E0_Parlor_Page0_QueenFrameB.tilemap" ; $62E0, 64 bytes
; C: far pointer loaded by Mode01_State00_Intro (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 64 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 88 replay(s) of the organic corpus, modes 01
; (tcrf_check/assets/l3_names/)
Map_24_6320_Mode01_State00_Intro::
    INCBIN "data/bank_24/Map_24_6320_Mode01_State00_Intro.tilemap" ; $6320, 64 bytes
; C: rows 0-1 (ramp 00-27) of the option-page map of mode $16 whose rows 2-17 are 24:63A0; Mode16_BuildOptionList
; (06:4B39) copies 24:63A0 to $9840 (row 2), so these two rows are never loaded
Map_24_6360_Mode16_OptionPage2_HeadRows::
    INCBIN "data/bank_24/Map_24_6360_Mode16_OptionPage2_HeadRows.tilemap" ; $6360, 64 bytes
; C: option page 2: 16 rows to $9840 (table entry 2), then Mode16_BuildList4 reads pieces from 24:6507 and 24:65A0
Map_24_63A0_Mode16_OptionPage2::
    INCBIN "data/bank_24/Map_24_63A0_Mode16_OptionPage2.tilemap" ; $63A0, 504 bytes
; C: far pointer loaded by Mode17_State00_Init (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 8 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 10 replay(s), modes 16 (states 16:05 16:01), not only by the
; consumer the name gives: a shared asset or table; first organic loader in the ...
Gfx_24_6598_Mode17_State00_Init::
    INCBIN "data/bank_24/Gfx_24_6598_Mode17_State00_Init.bin" ; $6598, 8 bytes
; C: far pointer loaded by Mode16_BuildList4 (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 128 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 10 replay(s) of the organic corpus, modes 16
; (tcrf_check/assets/l3_names/)
Map_24_65A0_Mode16_BuildList4::
    INCBIN "data/bank_24/Map_24_65A0_Mode16_BuildList4.tilemap" ; $65A0, 128 bytes
; C: copied to VRAM/WRAM by Mode1A_State02_Setup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 10 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
Map_24_6620_Mode1A_State02_Setup::
    INCBIN "data/bank_24/Map_24_6620_Mode1A_State02_Setup.tilemap" ; $6620, 704 bytes
; C: copied to VRAM/WRAM by Mode17_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 19 replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Map_24_68E0_Mode17_State00_Init::
    INCBIN "data/bank_24/Map_24_68E0_Mode17_State00_Init.tilemap" ; $68E0, 320 bytes
; C: far pointer loaded by Compose_DrawLayoutPreview (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 19 replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Map_24_6A20_Compose_DrawLayoutPreview::
    INCBIN "data/bank_24/Map_24_6A20_Compose_DrawLayoutPreview.tilemap" ; $6A20, 256 bytes
; C: far pointer loaded by Compose_DrawLayoutPreview (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 128
; from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the organic corpus, modes 17
; (tcrf_check/assets/l3_names/)
Map_24_6B20_Compose_DrawLayoutPreview::
    INCBIN "data/bank_24/Map_24_6B20_Compose_DrawLayoutPreview.tilemap" ; $6B20, 128 bytes
; C: copied to VRAM/WRAM by Mode1C_State02_ShowPrintScreen, Mode1C_DrawOptionScreen
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 9 replay(s) of the organic corpus, modes
; 1C (tcrf_check/assets/l3_names/)
Map_24_6BA0_Mode1C_State02_ShowPrintScreen::
    INCBIN "data/bank_24/Map_24_6BA0_Mode1C_State02_ShowPrintScreen.tilemap" ; $6BA0, 704 bytes
; C: far pointer loaded by Shoot_DrawOptionPanel (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 704 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the organic corpus, modes 14
; (tcrf_check/assets/l3_names/)
Map_24_6E60_Shoot_DrawOptionPanel::
    INCBIN "data/bank_24/Map_24_6E60_Shoot_DrawOptionPanel.tilemap" ; $6E60, 704 bytes
; C: copied to VRAM/WRAM by Mode10_State02_Setup, Unused_LoadTilemap24_7120 (roms/jp_rev_a/assets/catalog_jp.csv). L3
; pass 2026-10-26: read in BGB in 7 replay(s) of the organic corpus, modes 10 (tcrf_check/assets/l3_names/)
Map_24_7120_Mode10_State02_Setup::
    INCBIN "data/bank_24/Map_24_7120_Mode10_State02_Setup.tilemap" ; $7120, 704 bytes
; C: far pointer loaded by Album_LoadBorderScreen, Album_ShowPageScreenB (ld a,BANK; ld hl,ADDR; call banked copy/far
; call); length 704 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 71 replay(s) of the organic corpus,
; modes 09 0A (tcrf_check/assets/l3_names/)
Map_24_73E0_Album_ShowPageScreenB::
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $9c, $9d, $90, $91, $ea, $eb, $ec, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $9e, $9f, $a0, $a1, $ff, $ed, $ee, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $b0, $b1, $b2, $b3, $b4, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $c0, $c1, $c2, $c3, $c4, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $9c, $9d, $ff, $ff, $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b
    db $0c, $0d, $0e, $0f, $ff, $ff, $9c, $9d, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $9e, $9f, $ff, $ff, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1a, $1b
    db $1c, $1d, $1e, $1f, $ff, $ff, $9e, $9f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $94, $95, $cd, $ce, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $2a, $2b
    db $2c, $2d, $2e, $2f, $e0, $e1, $98, $99, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $a4, $a5, $bf, $cf, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b
    db $3c, $3d, $3e, $3f, $e2, $e3, $a8, $a9, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f3, $f4, $d0, $d1, $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4a, $4b
    db $4c, $4d, $4e, $4f, $e4, $e5, $f9, $fa, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $fb, $f6, $d2, $d3, $50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5a, $5b
    db $5c, $5d, $5e, $5f, $e6, $e7, $ef, $f0, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f5, $f6, $d4, $d5, $60, $61, $62, $63, $64, $65, $66, $67, $68, $69, $6a, $6b
    db $6c, $6d, $6e, $6f, $e8, $e9, $f1, $f2, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $70, $71, $72, $73, $74, $75, $76, $77, $78, $79, $7a, $7b
    db $7c, $7d, $7e, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $9c, $9d, $ff, $ff, $80, $81, $82, $83, $84, $85, $86, $87, $88, $89, $8a, $8b
    db $8c, $8d, $8e, $8f, $ff, $ff, $9c, $9d, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $9e, $9f, $ff, $ff, $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b
    db $0c, $0d, $0e, $0f, $ff, $ff, $9e, $9f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $96, $97, $b9, $ba, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1a, $1b
    db $1c, $1d, $1e, $1f, $d6, $d7, $9a, $9b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $a6, $a7, $c9, $ca, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $2a, $2b
    db $2c, $2d, $2e, $2f, $d8, $d9, $aa, $ab, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $bb, $bc, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b
    db $3c, $3d, $3e, $3f, $da, $db, $fd, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f7, $f8, $cb, $cc, $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4a, $4b
    db $4c, $4d, $4e, $4f, $dc, $dd, $ef, $f0, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $bd, $be, $ff, $ff, $ff, $ff, $ff, $ff, $b5, $b6, $b7, $b8, $ff, $ff
    db $ff, $ff, $ff, $ff, $de, $df, $f1, $f2, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $c5, $c6, $c7, $c8, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $9c, $9d, $ef, $fc, $ea, $92, $93, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $9e, $9f, $f1, $f2, $ff, $a2, $a3

    ; padding
    ds $11, $ff

; C: far pointer loaded by PenMenu_BuildSpeed (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 32 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 10
; (tcrf_check/assets/l3_names/)
Map_24_76A0_PenMenu_BuildSpeed::
    INCBIN "data/bank_24/Map_24_76A0_PenMenu_BuildSpeed.tilemap" ; $76A0, 32 bytes
; C: target 0 of the word table 04:6839 (indexed by the page builder: 3 panels of 192 bytes); length 192 from the
; nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 10)
Map_24_76C0_PenMenuSpeedPanel0::
    INCBIN "data/bank_24/Map_24_76C0_PenMenuSpeedPanel0.tilemap" ; $76C0, 96 bytes
; C: far pointer loaded by PenMenu_BuildSpeed (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 128 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 10
; (tcrf_check/assets/l3_names/)
Map_24_7720_PenMenu_BuildSpeed::
    INCBIN "data/bank_24/Map_24_7720_PenMenu_BuildSpeed.tilemap" ; $7720, 128 bytes
; C: target 1 of the word table 04:6839 (indexed by the page builder: 3 panels of 192 bytes); length 192 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 10
; (tcrf_check/assets/l3_names/)
Map_24_77A0_PenMenuSpeedPanel1::
    INCBIN "data/bank_24/Map_24_77A0_PenMenuSpeedPanel1.tilemap" ; $77A0, 96 bytes
; C: target 2 of the word table 04:6839 (indexed by the page builder: 3 panels of 192 bytes); length 192 from the
; nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 10)
Map_24_7800_PenMenuSpeedPanel2::
    INCBIN "data/bank_24/Map_24_7800_PenMenuSpeedPanel2.tilemap" ; $7800, 96 bytes
; C: far pointer loaded by PenMenu_Build (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 256 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the organic corpus, modes 10
; (tcrf_check/assets/l3_names/)
Map_24_7860_PenMenu_Build::
    INCBIN "data/bank_24/Map_24_7860_PenMenu_Build.tilemap" ; $7860, 256 bytes
; C: far pointer loaded by Shoot_DrawOptionPanel, Shoot_RestoreViewScreen (ld a,BANK; ld hl,ADDR; call banked copy/far
; call); length 704 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the organic corpus, modes
; 14 (tcrf_check/assets/l3_names/)
Map_24_7960_Shoot_RestoreViewScreen::
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $fe, $fe, $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b
    db $0c, $0d, $0e, $0f, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $fe, $fe, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1a, $1b
    db $1c, $1d, $1e, $1f, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $fe, $fe, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $2a, $2b
    db $2c, $2d, $2e, $2f, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $fe, $fe, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b
    db $3c, $3d, $3e, $3f, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $fe, $fe, $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4a, $4b
    db $4c, $4d, $4e, $4f, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $fe, $fe, $50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5a, $5b
    db $5c, $5d, $5e, $5f, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $fe, $fe, $60, $61, $62, $63, $64, $65, $66, $67, $68, $69, $6a, $6b
    db $6c, $6d, $6e, $6f, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $fe, $fe, $70, $71, $72, $73, $74, $75, $76, $77, $78, $79, $7a, $7b
    db $7c, $7d, $7e, $7f, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $fe, $fe, $80, $81, $82, $83, $84, $85, $86, $87, $88, $89, $8a, $8b
    db $8c, $8d, $8e, $8f, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $fe, $fe, $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b
    db $0c, $0d, $0e, $0f, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $fe, $fe, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1a, $1b
    db $1c, $1d, $1e, $1f, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $fe, $fe, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $2a, $2b
    db $2c, $2d, $2e, $2f, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $fe, $fe, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b
    db $3c, $3d, $3e, $3f, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $fe, $fe, $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4a, $4b
    db $4c, $4d, $4e, $4f, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $fe, $fe, $fe, $fe, $fe, $fe

    ; padding
    ds $4a, $ff

; C: copied to VRAM/WRAM by Mode12_State11_TestStart, Mode13_State03_PlayPrepare, Mode09_State00_Init,
; Album_ShowPageScreen, Mode0A_State02_Setup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in
; 76 replay(s) of the organic corpus, modes 09 0A 12 (tcrf_check/assets/l3_names/)
Map_24_7C20_Mode12_State11_TestStart::
    INCBIN "data/bank_24/Map_24_7C20_Mode12_State11_TestStart.tilemap" ; $7C20, 704 bytes
; C: copied to VRAM/WRAM by SaveDialog_Substate3_FullInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in 2 replay(s) of the organic corpus, modes 10 12 (tcrf_check/assets/l3_names/)
Map_24_7C20_SaveDialog_Substate3_FullInit_Part7EE0::
    INCBIN "data/bank_24/Map_24_7C20_SaveDialog_Substate3_FullInit_Part7EE0.tilemap" ; $7EE0, 288 bytes
