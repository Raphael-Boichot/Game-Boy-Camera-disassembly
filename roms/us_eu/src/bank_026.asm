; Game Boy Camera (USA, Europe), bank $26. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $026", ROMX[$4000], BANK[$26]

; C: frame 6 of the staff-roll dancer (a dancing girl, not identified): {lo,hi,bank,duration} table 09:509C (13
; records, 12 frames each), 0x500 bytes copied alternately to $8000 / $8500 by Mode08_State15_CreditsScroll
Gfx_26_4000_CreditsGirlFrame06::
    INCBIN "data/bank_26/Gfx_26_4000_CreditsGirlFrame06.2bpp" ; $4000, 1280 bytes
; I: 18-row map: 16x14 photo-area ramp (00-8F, 00-4F) with icon columns and icon blocks in rows 14-17, then $FF fill;
; no copy site and no table entry reaches it (README 16.25)
Map_26_4500_Unused_IconFrame::
    INCBIN "data/bank_26/Map_26_4500_Unused_IconFrame.tilemap" ; $4500, 896 bytes
; I: far pointer loaded by Mode1A_State03_Browse (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 1024 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
Gfx_26_4880_Mode1A_State03_Browse::
    INCBIN "data/bank_26/Gfx_26_4880_Mode1A_State03_Browse.2bpp" ; $4880, 1024 bytes
; C: copied to VRAM/WRAM by ResultScreen_Substate0_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in 31 replay(s) of the organic corpus, modes 01 14 17 1D (tcrf_check/assets/l3_names/)
Map_26_4C80_ResultScreen_Substate0_Init::
    INCBIN "data/bank_26/Map_26_4C80_ResultScreen_Substate0_Init.tilemap" ; $4C80, 576 bytes
; I: copied to VRAM/WRAM by Mode08_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 15 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Map_26_4EC0_Mode08_State00_Init::
    INCBIN "data/bank_26/Map_26_4EC0_Mode08_State00_Init.tilemap" ; $4EC0, 576 bytes
; I: copied to VRAM/WRAM by Link_ShowScreenA (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: no organic run
; reached it (BGB replays, BGB scenarios, core organic runs); C from the code: map loaded by Link_ShowScreenA
Map_26_5100_Link_ShowScreenA::
    INCBIN "data/bank_26/Map_26_5100_Link_ShowScreenA.tilemap" ; $5100, 576 bytes
; I: far pointer loaded by Mode02_State00_Init (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 704 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 35 replay(s) of the organic corpus, modes 02
; (tcrf_check/assets/l3_names/)
Map_26_5340_Mode02_State00_Init::
    INCBIN "data/bank_26/Map_26_5340_Mode02_State00_Init.tilemap" ; $5340, 64 bytes
; I: target 0 of the {lo,hi,bank} table 07:53A6; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: read in BGB in 35 replay(s) of the organic corpus, modes 02 (tcrf_check/assets/l3_names/)
Src_26_5380_Tbl53A6_0::
    INCBIN "data/bank_26/Src_26_5380_Tbl53A6_0.bin" ; $5380, 512 bytes
; C: copied to VRAM/WRAM by Mode1E_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 36 replay(s) of the organic corpus, modes 02 1E (tcrf_check/assets/l3_names/)
Map_26_5580_Mode1E_State00_Init::
    INCBIN "data/bank_26/Map_26_5580_Mode1E_State00_Init.tilemap" ; $5580, 576 bytes
; I: copied to VRAM/WRAM by MainMenu_LoadBackground (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 203 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Map_26_57C0_MainMenu_LoadBackground::
    INCBIN "data/bank_26/Map_26_57C0_MainMenu_LoadBackground.tilemap" ; $57C0, 96 bytes
; I: target 7 of the {lo,hi,bank} table 07:7CF9. L3 pass 2026-10-26: read in BGB in 203 replay(s) of the organic
; corpus, modes 00 (tcrf_check/assets/l3_names/)
Src_26_5820_Tbl7CF9_7::
    INCBIN "data/bank_26/Src_26_5820_Tbl7CF9_7.bin" ; $5820, 480 bytes
; I: copied to VRAM/WRAM by Mode1D_State06_LoadWaitScreen (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in the scenarios err_card_inq80 1D:06, print_batch_1E 1D:06, print_card_1C 1D:06, print_single_1C 1D:06
; (tcrf_check/assets/l3_names/scen_hits*.csv)
Map_26_5A00_Mode1D_State06_LoadWaitScreen::
    INCBIN "data/bank_26/Map_26_5A00_Mode1D_State06_LoadWaitScreen.tilemap" ; $5A00, 576 bytes
; C: map 0 of the dancing man (Kentaro Nishimura) (table 09:517D, 0x240 bytes to $9800), cycled by
; Credits_NextDancingFrame
Map_26_5C40_CreditsNishimuraDanceMap0::
    INCBIN "data/bank_26/Map_26_5C40_CreditsNishimuraDanceMap0.tilemap" ; $5C40, 576 bytes
; C: copied to VRAM/WRAM by WildFrame_LoadForPrintScreen, WildFrame_LoadForOptionScreen
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes
; 1C (tcrf_check/assets/l3_names/)
Map_26_5E80_WildFrame_LoadForPrintScreen::
    INCBIN "data/bank_26/Map_26_5E80_WildFrame_LoadForPrintScreen.tilemap" ; $5E80, 576 bytes
; I: copied to VRAM/WRAM by Mode08_State0C_RecordInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 3 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Map_26_60C0_Mode08_State0C_RecordInit::
    INCBIN "data/bank_26/Map_26_60C0_Mode08_State0C_RecordInit.tilemap" ; $60C0, 576 bytes
; I: copied to VRAM/WRAM by Link_ShowScreenB (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: no organic run
; reached it (BGB replays, BGB scenarios, core organic runs); C from the code: map loaded by Link_ShowScreenB
; (07:4B9E)
Map_26_6300_Link_ShowScreenB::
    INCBIN "data/bank_26/Map_26_6300_Link_ShowScreenB.tilemap" ; $6300, 576 bytes
; I: copied to VRAM/WRAM by Mode1F_State00_TitleInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not
; reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1F)
Map_26_6540_Mode1F_State00_TitleInit::
    INCBIN "data/bank_26/Map_26_6540_Mode1F_State00_TitleInit.tilemap" ; $6540, 576 bytes
; C: copied to VRAM/WRAM by Mode19_State00_CopyrightScreens (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in 205 replay(s) of the organic corpus, modes 19 (tcrf_check/assets/l3_names/)
Map_26_6780_Mode19_State00_CopyrightScreens::
    INCBIN "data/bank_26/Map_26_6780_Mode19_State00_CopyrightScreens.tilemap" ; $6780, 576 bytes
; C: copied to VRAM/WRAM by Mode21_State0B_ResultSetup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in the scenarios run_race_fast 21:0B, run_race_result 21:0B, run_race_slow 21:0B
; (tcrf_check/assets/l3_names/scen_hits*.csv)
Map_26_69C0_Mode21_State0B_ResultSetup::
    INCBIN "data/bank_26/Map_26_69C0_Mode21_State0B_ResultSetup.tilemap" ; $69C0, 576 bytes
; C: copied to VRAM/WRAM by Mode16_State08_StartShoot (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not
; reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 14)
Map_26_6C00_Mode16_State08_StartShoot::
    INCBIN "data/bank_26/Map_26_6C00_Mode16_State08_StartShoot.tilemap" ; $6C00, 576 bytes
; I: full-screen picture map (18 rows of 32, picture in columns 0-19, $A5 filler in 20-31; 245 distinct ids: 4-column
; side strip, 16-column picture and two small blocks DB-F5); no copy site reaches it and no tile block of either ROM
; fits it (tile_seam_search.py against a shuffled-map control: whole map ...
Map_26_6E40_Unused_Picture::
    INCBIN "data/bank_26/Map_26_6E40_Unused_Picture.tilemap" ; $6E40, 576 bytes
; C: map 2 of the dancing man (Kentaro Nishimura) (table 09:517D, 0x240 bytes to $9800), cycled by
; Credits_NextDancingFrame
Map_26_7080_CreditsNishimuraDanceMap2::
    INCBIN "data/bank_26/Map_26_7080_CreditsNishimuraDanceMap2.tilemap" ; $7080, 576 bytes
; C: map 3 of the dancing man (Kentaro Nishimura) (table 09:517D, 0x240 bytes to $9800), cycled by
; Credits_NextDancingFrame
Map_26_72C0_CreditsNishimuraDanceMap3::
    INCBIN "data/bank_26/Map_26_72C0_CreditsNishimuraDanceMap3.tilemap" ; $72C0, 576 bytes
; C: map 4 of the dancing man (Kentaro Nishimura) (table 09:517D, 0x240 bytes to $9800), cycled by
; Credits_NextDancingFrame
Map_26_7500_CreditsNishimuraDanceMap4::
    INCBIN "data/bank_26/Map_26_7500_CreditsNishimuraDanceMap4.tilemap" ; $7500, 576 bytes
; I: map of page 2 of the SHOOT parlor (04:7460 list): 18 rows of 32 bytes (0x240 up to 26:7E00); Parlor_LoadPage
; (04:73EF) ends each page list ($FF) with {lo,hi,bank} stored in $D7D9-$D7DB, which Parlor_SpiralWipeIn (04:7479)
; hands to Map_SpiralWipeIn (00:0DA0); the coverage shows columns 0-19 of 18 ...
Map_26_7740_Parlor_Page2::
    INCBIN "data/bank_26/Map_26_7740_Parlor_Page2.tilemap" ; $7740, 576 bytes
; C: loaded by Mem_CopyFromBank at 03:7B3D: Map $240 bytes to $9800 (this build's trace)
Map_26_7980_Mode04_State00_Init::
    INCBIN "data/bank_26/Map_26_7980_Mode04_State00_Init.tilemap" ; $7980, 576 bytes
; I: numeral table: Album_LoadNumeralTileB (04:7D21) copies 32 bytes from $7E00 + A x 32 (the second digit set of the
; album); same layout as Gfx_0C_7E00_Album_LoadNumeralTile; was Gfx_26_7E20_..._Aux
Gfx_26_7BC0_Album_LoadNumeralTileB::
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

    db $fc, $d7, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd
    db $fd, $e6, $e7, $e8, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $d8, $d9, $fe, $a0, $fe, $fe, $a2, $fe, $fe, $a4, $fe, $fe, $a6, $fe, $fe, $a8
    db $fe, $e9, $ea, $eb, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $da, $db, $fe, $a1, $fe, $fe, $a3, $fe, $fe, $a5, $fe, $fe, $a7, $fe, $fe, $a9
    db $fe, $f0, $f1, $f2, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $dc, $dd, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $e4, $f3, $f4, $f5, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $de, $df, $fe, $aa, $fe, $fe, $ac, $fe, $fe, $ae, $fe, $fe, $b0, $fe, $fe, $b2
    db $e5, $f6, $f7, $f8, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e0, $e1, $fe, $ab, $fe, $fe, $ad, $fe, $fe, $af, $fe, $fe, $b1, $fe, $fe, $b3
    db $fe, $f9, $fa, $fb, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e2, $e3, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $fe, $ec, $ed, $ee, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ee, $ee, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $fe, $ee, $ee, $ee, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ee, $ee, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $fe, $ee, $ee, $ee, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $fc, $d7, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd
    db $fd, $e6, $e7, $e8, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $d8, $d9, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $fe, $e9, $ea, $eb, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $da, $db, $fe, $a0, $a1, $a2, $a3, $b0, $b1, $b2, $b3, $c0, $c1, $c2, $c3, $fe
    db $fe, $f0, $f1, $f2, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $dc, $dd, $fe, $a4, $a5, $a6, $a7, $b4, $b5, $b6, $b7, $c4, $c5, $c6, $c7, $fe
    db $e4, $f3, $f4, $f5, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $de, $df, $fe, $a8, $a9, $aa, $ab, $b8, $b9, $ba, $bb, $c8, $c9, $ca, $cb, $fe
    db $e5, $f6, $f7, $f8, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e0, $e1, $fe, $ac, $ad, $ae, $af, $bc, $bd, $be, $bf, $cc, $cd, $ce, $cf, $fe
    db $fe, $f9, $fa, $fb, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e2, $e3, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $fe, $ec, $ed, $ee, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ee, $ee, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $fe, $ee, $ee, $ee, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ee, $ee, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $fe, $ee, $ee, $ee

    ; padding
    ds $c, $ff
