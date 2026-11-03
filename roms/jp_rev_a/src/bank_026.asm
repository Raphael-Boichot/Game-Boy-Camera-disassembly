; Pocket Camera (Japan) (Rev A), bank $26. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $026", ROMX[$4000], BANK[$26]

; C: frame 6 of the staff-roll dancer (a dancing girl, not identified): {lo,hi,bank,duration} table 09:509C (13
; records, 12 frames each), 0x500 bytes copied alternately to $8000 / $8500 by Mode08_State15_CreditsScroll
Gfx_26_4000_CreditsGirlFrame06::
    INCBIN "data/bank_26/Gfx_26_4000_CreditsGirlFrame06.2bpp" ; $4000, 1280 bytes
; I: 18-row map: 16x14 photo-area ramp (00-8F, 00-4F) with icon columns and icon blocks in rows 14-17, then $FF fill;
; no copy site and no table entry reaches it (README 16.25)
Map_26_4500_Unused_IconFrame::
    INCBIN "data/bank_26/Map_26_4500_Unused_IconFrame.tilemap" ; $4500, 896 bytes
; C: far pointer loaded by Mode1A_State03_Browse (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 1024 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
Gfx_26_4880_Mode1A_State03_Browse::
    INCBIN "data/bank_26/Gfx_26_4880_Mode1A_State03_Browse.2bpp" ; $4880, 1024 bytes
; C: 20 x 18 map of the ending picture (0x240 bytes to $9800)
Map_26_4C80_CreditsEndingPlate_Map::
    INCBIN "data/bank_26/Map_26_4C80_CreditsEndingPlate_Map.tilemap" ; $4C80, 576 bytes
; C: copied to VRAM/WRAM by ResultScreen_Substate0_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in 31 replay(s) of the organic corpus, modes 01 14 17 1D (tcrf_check/assets/l3_names/)
Map_26_4EC0_ResultScreen_Substate0_Init::
    INCBIN "data/bank_26/Map_26_4EC0_ResultScreen_Substate0_Init.tilemap" ; $4EC0, 576 bytes
; C: copied to VRAM/WRAM by Mode08_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 15 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Map_26_5100_Mode08_State00_Init::
    INCBIN "data/bank_26/Map_26_5100_Mode08_State00_Init.tilemap" ; $5100, 576 bytes
; C: copied to VRAM/WRAM by Link_ShowScreenA (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: no organic run
; reached it (BGB replays, BGB scenarios, core organic runs); C from the code: map loaded by Link_ShowScreenA
Map_26_5340_Link_ShowScreenA::
    INCBIN "data/bank_26/Map_26_5340_Link_ShowScreenA.tilemap" ; $5340, 576 bytes
; C: far pointer loaded by Mode02_State00_Init (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 704 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 35 replay(s) of the organic corpus, modes 02
; (tcrf_check/assets/l3_names/)
Map_26_5580_Mode02_State00_Init::
    INCBIN "data/bank_26/Map_26_5580_Mode02_State00_Init.tilemap" ; $5580, 64 bytes
; C: target 0 of the {lo,hi,bank} table 07:53A6; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: read in BGB in 35 replay(s) of the organic corpus, modes 02 (tcrf_check/assets/l3_names/)
Src_26_55C0_Tbl53A6_0::
    INCBIN "data/bank_26/Src_26_55C0_Tbl53A6_0.bin" ; $55C0, 512 bytes
; C: copied to VRAM/WRAM by Mode1E_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 36 replay(s) of the organic corpus, modes 02 1E (tcrf_check/assets/l3_names/)
Map_26_57C0_Mode1E_State00_Init::
    INCBIN "data/bank_26/Map_26_57C0_Mode1E_State00_Init.tilemap" ; $57C0, 576 bytes
; C: copied to VRAM/WRAM by MainMenu_LoadBackground (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 203 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Map_26_5A00_MainMenu_LoadBackground::
    INCBIN "data/bank_26/Map_26_5A00_MainMenu_LoadBackground.tilemap" ; $5A00, 96 bytes
; C: target 7 of the {lo,hi,bank} table 07:7CF9. L3 pass 2026-10-26: read in BGB in 203 replay(s) of the organic
; corpus, modes 00 (tcrf_check/assets/l3_names/)
Src_26_5A60_Tbl7CF9_7::
    INCBIN "data/bank_26/Src_26_5A60_Tbl7CF9_7.bin" ; $5A60, 480 bytes
; C: copied to VRAM/WRAM by Mode1D_State06_LoadWaitScreen (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in the scenarios err_card_inq80 1D:06, print_batch_1E 1D:06, print_card_1C 1D:06, print_single_1C 1D:06
; (tcrf_check/assets/l3_names/scen_hits*.csv)
Map_26_5C40_Mode1D_State06_LoadWaitScreen::
    INCBIN "data/bank_26/Map_26_5C40_Mode1D_State06_LoadWaitScreen.tilemap" ; $5C40, 576 bytes
; C: map 0 of the dancing man (Kentaro Nishimura) (table 09:517D, 0x240 bytes to $9800), cycled by
; Credits_NextDancingFrame
Map_26_5E80_CreditsNishimuraDanceMap0::
    INCBIN "data/bank_26/Map_26_5E80_CreditsNishimuraDanceMap0.tilemap" ; $5E80, 576 bytes
; C: copied to VRAM/WRAM by WildFrame_LoadForPrintScreen, WildFrame_LoadForOptionScreen
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes
; 1C (tcrf_check/assets/l3_names/)
Map_26_60C0_WildFrame_LoadForPrintScreen::
    INCBIN "data/bank_26/Map_26_60C0_WildFrame_LoadForPrintScreen.tilemap" ; $60C0, 576 bytes
; C: copied to VRAM/WRAM by Mode08_State0C_RecordInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 3 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Map_26_6300_Mode08_State0C_RecordInit::
    INCBIN "data/bank_26/Map_26_6300_Mode08_State0C_RecordInit.tilemap" ; $6300, 576 bytes
; C: copied to VRAM/WRAM by Link_ShowScreenB (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: no organic run
; reached it (BGB replays, BGB scenarios, core organic runs); C from the code: map loaded by Link_ShowScreenB
; (07:4B9E)
Map_26_6540_Link_ShowScreenB::
    INCBIN "data/bank_26/Map_26_6540_Link_ShowScreenB.tilemap" ; $6540, 576 bytes
; C: copied to VRAM/WRAM by Mode1F_State00_TitleInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not
; reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1F)
Map_26_6780_Mode1F_State00_TitleInit::
    INCBIN "data/bank_26/Map_26_6780_Mode1F_State00_TitleInit.tilemap" ; $6780, 576 bytes
; C: copied to VRAM/WRAM by Mode19_State00_CopyrightScreens (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in 205 replay(s) of the organic corpus, modes 19 (tcrf_check/assets/l3_names/)
Map_26_69C0_Mode19_State00_CopyrightScreens::
    INCBIN "data/bank_26/Map_26_69C0_Mode19_State00_CopyrightScreens.tilemap" ; $69C0, 576 bytes
; C: copied to VRAM/WRAM by Mode21_State0B_ResultSetup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in the scenarios run_race_fast 21:0B, run_race_result 21:0B, run_race_slow 21:0B
; (tcrf_check/assets/l3_names/scen_hits*.csv)
Map_26_6C00_Mode21_State0B_ResultSetup::
    INCBIN "data/bank_26/Map_26_6C00_Mode21_State0B_ResultSetup.tilemap" ; $6C00, 576 bytes
; C: copied to VRAM/WRAM by Mode16_State08_StartShoot (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not
; reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 14)
Map_26_6E40_Mode16_State08_StartShoot::
    INCBIN "data/bank_26/Map_26_6E40_Mode16_State08_StartShoot.tilemap" ; $6E40, 576 bytes
; I: full-screen picture map (18 rows of 32, picture in columns 0-19, $A5 filler in 20-31; 245 distinct ids: 4-column
; side strip, 16-column picture and two small blocks DB-F5); no copy site reaches it and no tile block of either ROM
; fits it (tile_seam_search.py against a shuffled-map control: whole map ...
Map_26_7080_Unused_Picture::
    INCBIN "data/bank_26/Map_26_7080_Unused_Picture.tilemap" ; $7080, 576 bytes
; C: copied to VRAM/WRAM by Mode08_State13_CreditsPageA (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in 4 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Map_26_72C0_Mode08_State13_CreditsPageA::
    INCBIN "data/bank_26/Map_26_72C0_Mode08_State13_CreditsPageA.tilemap" ; $72C0, 576 bytes
; C: map 2 of the dancing man (Kentaro Nishimura) (table 09:517D, 0x240 bytes to $9800), cycled by
; Credits_NextDancingFrame
Map_26_7500_CreditsNishimuraDanceMap2::
    INCBIN "data/bank_26/Map_26_7500_CreditsNishimuraDanceMap2.tilemap" ; $7500, 576 bytes
; C: map 3 of the dancing man (Kentaro Nishimura) (table 09:517D, 0x240 bytes to $9800), cycled by
; Credits_NextDancingFrame
Map_26_7740_CreditsNishimuraDanceMap3::
    INCBIN "data/bank_26/Map_26_7740_CreditsNishimuraDanceMap3.tilemap" ; $7740, 576 bytes
; C: map 4 of the dancing man (Kentaro Nishimura) (table 09:517D, 0x240 bytes to $9800), cycled by
; Credits_NextDancingFrame
Map_26_7980_CreditsNishimuraDanceMap4::
    INCBIN "data/bank_26/Map_26_7980_CreditsNishimuraDanceMap4.tilemap" ; $7980, 576 bytes
; C: map of page 2 of the SHOOT parlor (04:7460 list): 18 rows of 32 bytes (0x240 up to 26:7E00); Parlor_LoadPage
; (04:73EF) ends each page list ($FF) with {lo,hi,bank} stored in $D7D9-$D7DB, which Parlor_SpiralWipeIn (04:7479)
; hands to Map_SpiralWipeIn (00:0DA0); the coverage shows columns 0-19 of 18 ...
Map_26_7BC0_Parlor_Page2::
    INCBIN "data/bank_26/Map_26_7BC0_Parlor_Page2.tilemap" ; $7BC0, 576 bytes
; C: numeral table: Album_LoadNumeralTileB (04:7D21) copies 32 bytes from $7E00 + A x 32 (the second digit set of the
; album); same layout as Gfx_0C_7E00_Album_LoadNumeralTile; was Gfx_26_7E20_..._Aux
Gfx_26_7E00_Album_LoadNumeralTileB::
    db $ff, $ff, $ff, $00, $ff, $3c, $ff, $7e, $ff, $66, $ff, $66, $ff, $66, $ff, $7e
    db $ff, $7e, $ff, $66, $ff, $66, $ff, $66, $ff, $66, $ff, $66, $ff, $00, $ff, $ff
    db $ff, $ff, $ff, $00, $ff, $7c, $ff, $7e, $ff, $66, $ff, $66, $ff, $66, $ff, $7c
    db $ff, $7c, $ff, $66, $ff, $66, $ff, $66, $ff, $7e, $ff, $7c, $ff, $00, $ff, $ff
    db $ff, $ff, $ff, $00, $ff, $3c, $ff, $7e, $ff, $66, $ff, $66, $ff, $66, $ff, $66
    db $ff, $66, $ff, $66, $ff, $66, $ff, $66, $ff, $7e, $ff, $3c, $ff, $00, $ff, $ff
    db $ff, $ff, $ff, $00, $ff, $1c, $ff, $1c, $ff, $0c, $ff, $0c, $ff, $0c, $ff, $0c
    db $ff, $0c, $ff, $0c, $ff, $0c, $ff, $0c, $ff, $0c, $ff, $0c, $ff, $00, $ff, $ff
    db $ff, $ff, $ff, $00, $ff, $7c, $ff, $7e, $ff, $06, $ff, $06, $ff, $06, $ff, $3e
    db $ff, $7c, $ff, $60, $ff, $60, $ff, $60, $ff, $7e, $ff, $7e, $ff, $00, $ff, $ff
    db $ff, $ff, $ff, $00, $ff, $7c, $ff, $7e, $ff, $06, $ff, $06, $ff, $06, $ff, $7e
    db $ff, $7e, $ff, $06, $ff, $06, $ff, $06, $ff, $7e, $ff, $7c, $ff, $00, $ff, $ff
    db $ff, $ff, $ff, $00, $ff, $66, $ff, $66, $ff, $66, $ff, $66, $ff, $66, $ff, $7e
    db $ff, $3e, $ff, $06, $ff, $06, $ff, $06, $ff, $06, $ff, $06, $ff, $00, $ff, $ff
    db $ff, $ff, $ff, $00, $ff, $3e, $ff, $7e, $ff, $60, $ff, $60, $ff, $60, $ff, $7c
    db $ff, $3e, $ff, $06, $ff, $06, $ff, $06, $ff, $7e, $ff, $7c, $ff, $00, $ff, $ff
    db $ff, $ff, $ff, $00, $ff, $3c, $ff, $7c, $ff, $60, $ff, $60, $ff, $60, $ff, $7c
    db $ff, $7e, $ff, $66, $ff, $66, $ff, $66, $ff, $7e, $ff, $3c, $ff, $00, $ff, $ff
    db $ff, $ff, $ff, $00, $ff, $7e, $ff, $7e, $ff, $06, $ff, $06, $ff, $06, $ff, $0e
    db $ff, $0c, $ff, $0c, $ff, $0c, $ff, $0c, $ff, $0c, $ff, $0c, $ff, $00, $ff, $ff
    db $ff, $ff, $ff, $00, $ff, $3c, $ff, $7e, $ff, $66, $ff, $66, $ff, $66, $ff, $7e
    db $ff, $7e, $ff, $66, $ff, $66, $ff, $66, $ff, $7e, $ff, $3c, $ff, $00, $ff, $ff
    db $ff, $ff, $ff, $00, $ff, $3c, $ff, $7e, $ff, $66, $ff, $66, $ff, $66, $ff, $7e
    db $ff, $3e, $ff, $06, $ff, $06, $ff, $06, $ff, $3e, $ff, $3c, $ff, $00, $ff, $ff

    ; padding
    ds $80, $00
