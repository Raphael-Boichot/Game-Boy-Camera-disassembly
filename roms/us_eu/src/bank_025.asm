; Game Boy Camera (USA, Europe), bank $25. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $025", ROMX[$4000], BANK[$25]

; C: frame 5 of the staff-roll dancer (a dancing girl, not identified): {lo,hi,bank,duration} table 09:509C (13
; records, 12 frames each), 0x500 bytes copied alternately to $8000 / $8500 by Mode08_State15_CreditsScroll
Gfx_25_4000_CreditsGirlFrame05::
    INCBIN "data/bank_25/Gfx_25_4000_CreditsGirlFrame05.2bpp" ; $4000, 1152 bytes
; C: far pointer loaded by Mode08_State14_CreditsPageB (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Gfx_25_4480_Mode08_State14_CreditsPageB::
    INCBIN "data/bank_25/Gfx_25_4480_Mode08_State14_CreditsPageB.2bpp" ; $4480, 128 bytes
; C: frame 0 of the staff-roll dancer (a dancing girl, not identified): {lo,hi,bank,duration} table 09:509C (13
; records, 12 frames each), 0x500 bytes copied alternately to $8000 / $8500 by Mode08_State15_CreditsScroll
Gfx_25_4480_CreditsGirlFrame00_Part4500::
    INCBIN "data/bank_25/Gfx_25_4480_CreditsGirlFrame00_Part4500.2bpp" ; $4500, 704 bytes
; I: far pointer loaded by Mode14_State00_Init, Mode14_State0C_Reinit, Shoot_RestoreViewScreen (ld a,BANK; ld hl,ADDR;
; call banked copy/far call). L3 pass 2026-10-26: read in BGB in 74 replay(s) of the organic corpus, modes 08 14
; (tcrf_check/assets/l3_names/)
Map_25_47C0_Mode14_State0C_Reinit::
    INCBIN "data/bank_25/Map_25_47C0_Mode14_State0C_Reinit.tilemap" ; $47C0, 448 bytes
; I: copied to VRAM/WRAM by Mode14_State00_Init, Shoot_TimerTick (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass
; 2026-10-26: read in BGB in 72 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Map_25_47C0_Mode14_State00_Init_Part4980::
    INCBIN "data/bank_25/Map_25_47C0_Mode14_State00_Init_Part4980.tilemap" ; $4980, 256 bytes
; I: four blank rows ($FE) between the map copied from 25:47C0 (22 rows) and the map at 25:4B00; filler
Map_25_4A80_BlankRows::
    INCBIN "data/bank_25/Map_25_4A80_BlankRows.tilemap" ; $4A80, 128 bytes
; I: 22-row map (0x2C0 bytes): 16x14 photo-area ramp (00-8F, 00-4F) with icon blocks (A0-DF) and two icon
BgMap_25_4B00::
    INCBIN "data/bank_25/BgMap_25_4B00.tilemap" ; $4B00, 704 bytes
; C: copied to VRAM/WRAM by Mode11_State02_Setup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 35 replay(s) of the organic corpus, modes 11 (tcrf_check/assets/l3_names/)
Map_25_4DC0_Mode11_State02_Setup::
    INCBIN "data/bank_25/Map_25_4DC0_Mode11_State02_Setup.tilemap" ; $4DC0, 704 bytes
; I: rows 0-1 (ramp 00-27) of option page 1 (rows 2-17 = 25:50C0); never loaded
Map_25_5080_Mode16_OptionPage1_HeadRows::
    INCBIN "data/bank_25/Map_25_5080_Mode16_OptionPage1_HeadRows.tilemap" ; $5080, 64 bytes
; I: option page 1: 16 rows to $9840 (table entry 1), then Mode16_BuildList2 reads 8-byte pieces from 25:51E7 and
; 25:52C0
Map_25_50C0_Mode16_OptionPage1::
    INCBIN "data/bank_25/Map_25_50C0_Mode16_OptionPage1.tilemap" ; $50C0, 512 bytes
; I: far pointer loaded by Mode16_BuildList2 (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 96 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 16
; (tcrf_check/assets/l3_names/)
Map_25_52C0_Mode16_BuildList2::
    INCBIN "data/bank_25/Map_25_52C0_Mode16_BuildList2.tilemap" ; $52C0, 96 bytes
; I: rows 0-1 (ramp 00-27) of option page 3 (rows 2-17 = 25:5360); never loaded
Map_25_5320_Mode16_OptionPage3_HeadRows::
    INCBIN "data/bank_25/Map_25_5320_Mode16_OptionPage3_HeadRows.tilemap" ; $5320, 64 bytes
; I: option page 3: 16 rows to $9840 (table entry 3), then Mode16_BuildList6 reads pieces from 25:5507 and 25:5560
Map_25_5360_Mode16_OptionPage3::
    INCBIN "data/bank_25/Map_25_5360_Mode16_OptionPage3.tilemap" ; $5360, 512 bytes
; I: far pointer loaded by Mode16_BuildList6 (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 96 from the
; nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 16)
Map_25_5560_Mode16_BuildList6::
    INCBIN "data/bank_25/Map_25_5560_Mode16_BuildList6.tilemap" ; $5560, 96 bytes
; C: copied to VRAM/WRAM by Mode07_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 13 replay(s) of the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
Map_25_55C0_Mode07_State00_Init::
    INCBIN "data/bank_25/Map_25_55C0_Mode07_State00_Init.tilemap" ; $55C0, 192 bytes
; C: far pointer loaded by SpaceFever_Boss_EndB (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 13 replay(s) of the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
Map_25_5680_SpaceFever_Boss_EndB::
    db $4b, $b1, $b3, $4c, $4c, $4c, $4c, $1f, $4b, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $4b, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $4b, $b4, $b6, $bf, $bf, $09, $0a, $0b, $4b, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $4b, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $4b, $b5, $b7, $4c, $4c, $19, $1a, $1b, $4b, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $4b, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $4b, $b8, $ba, $bf, $bf, $0c, $0d, $0e, $4b, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $4b, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $4b, $b9, $bb, $4c, $4c, $1c, $1d, $1e, $4b, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $4b, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $4b, $bf, $bf, $bf, $bf, $bf, $64, $60, $4b, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $4b, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $4b, $bc, $be, $4c, $4c, $4c, $66, $61, $4b, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $4b, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $4b, $bf, $bf, $bf, $bf, $bf, $62, $60, $4b, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $4b, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $4b, $90, $92, $4c, $4c, $4c, $63, $61, $4b, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $4b, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $4b, $bf, $bf, $bf, $bf, $bf, $bf, $69, $4b, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $4b, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $4b, $94, $96, $4c, $4c, $4c, $4c, $6a, $4b, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $4b, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $4b, $59, $5a, $5b, $5c, $5d, $5e, $5f, $4b, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $4b, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf

    ; padding
    ds $20, $bf

; C: far pointer loaded by SpaceFever_Boss_EndA, SpaceFever_Boss_EndB (ld a,BANK; ld hl,ADDR; call banked copy/far
; call); length 20 from the nearby ld bc. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios,
; core organic runs); C from the code: map loaded by SpaceFever_Boss_EndB ...
Map_25_5820_SpaceFever_Boss_EndB::
    INCBIN "data/bank_25/Map_25_5820_SpaceFever_Boss_EndB.tilemap" ; $5820, 32 bytes
; C: copied to VRAM/WRAM by Cam_FactoryDiag_AllButtonsExceptB (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass
; 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 00)
Map_25_5840_Cam_FactoryDiag_AllButtonsExceptB::
    INCBIN "data/bank_25/Map_25_5840_Cam_FactoryDiag_AllButtonsExceptB.tilemap" ; $5840, 576 bytes
; C: copied to VRAM/WRAM by Cam_FactoryDiag_AllButtonsExceptB (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass
; 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 00)
Map_25_5A80_Cam_FactoryDiag_AllButtonsExceptB::
    INCBIN "data/bank_25/Map_25_5A80_Cam_FactoryDiag_AllButtonsExceptB.tilemap" ; $5A80, 32 bytes
; C: copied to VRAM/WRAM by Cam_FactoryDiag_AllButtonsExceptB (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass
; 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 00)
Map_25_5AA0_Cam_FactoryDiag_AllButtonsExceptB::
    INCBIN "data/bank_25/Map_25_5AA0_Cam_FactoryDiag_AllButtonsExceptB.tilemap" ; $5AA0, 32 bytes
; C: copied to VRAM/WRAM by Cam_FirstBoot_StorePleaseWait (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 00)
Map_25_5AC0_Cam_FirstBoot_StorePleaseWait::
    INCBIN "data/bank_25/Map_25_5AC0_Cam_FirstBoot_StorePleaseWait.tilemap" ; $5AC0, 576 bytes
; C: copied to VRAM/WRAM by Cam_FirstBoot_StorePleaseWait (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 00)
Map_25_5D00_Cam_FirstBoot_StorePleaseWait::
    INCBIN "data/bank_25/Map_25_5D00_Cam_FirstBoot_StorePleaseWait.tilemap" ; $5D00, 32 bytes
; I: copied to VRAM/WRAM by Mode08_State0F_HiScoreInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 2 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Map_25_5D20_Mode08_State0F_HiScoreInit::
    INCBIN "data/bank_25/Map_25_5D20_Mode08_State0F_HiScoreInit.tilemap" ; $5D20, 576 bytes
; C: copied to VRAM/WRAM by Mode21_State02_RaceSceneInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 21)
Map_25_5F60_Mode21_State02_RaceSceneInit::
    INCBIN "data/bank_25/Map_25_5F60_Mode21_State02_RaceSceneInit.tilemap" ; $5F60, 576 bytes
; I: copied to VRAM/WRAM by Mode1D_State01_LoadScreen (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 11 replay(s) of the organic corpus, modes 1D (tcrf_check/assets/l3_names/)
Map_25_61A0_Mode1D_State01_LoadScreen::
    INCBIN "data/bank_25/Map_25_61A0_Mode1D_State01_LoadScreen.tilemap" ; $61A0, 576 bytes
; I: copied to VRAM/WRAM by Mode15_State01_TimerInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 25 replay(s) of the organic corpus, modes 15 (tcrf_check/assets/l3_names/)
Map_25_63E0_Mode15_State01_TimerInit::
    INCBIN "data/bank_25/Map_25_63E0_Mode15_State01_TimerInit.tilemap" ; $63E0, 576 bytes
; C: map 1 of the dancing man (Kentaro Nishimura) (table 09:517D, 0x240 bytes to $9800), cycled by
; Credits_NextDancingFrame
Map_25_6620_CreditsNishimuraDanceMap1::
    INCBIN "data/bank_25/Map_25_6620_CreditsNishimuraDanceMap1.tilemap" ; $6620, 576 bytes
; I: copied to VRAM/WRAM by Mode15_State05_IntervalInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in 6 replay(s) of the organic corpus, modes 15 (tcrf_check/assets/l3_names/)
Map_25_6860_Mode15_State05_IntervalInit::
    INCBIN "data/bank_25/Map_25_6860_Mode15_State05_IntervalInit.tilemap" ; $6860, 576 bytes
; C: copied to VRAM/WRAM by WildFramePicker_Substate0_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in 2 replay(s) of the organic corpus, modes 1C (tcrf_check/assets/l3_names/)
Map_25_6AA0_WildFramePicker_Substate0_Init::
    INCBIN "data/bank_25/Map_25_6AA0_WildFramePicker_Substate0_Init.tilemap" ; $6AA0, 576 bytes
; C: copied to VRAM/WRAM by Mode05_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 32 replay(s) of the organic corpus, modes 05 (tcrf_check/assets/l3_names/)
Map_25_6CE0_Mode05_State00_Init::
    INCBIN "data/bank_25/Map_25_6CE0_Mode05_State00_Init.tilemap" ; $6CE0, 576 bytes
; I: rows 0-1 (ramp 00-27) of option page 0 (rows 2-17 = 25:71A0); never loaded, as for every page
Map_25_6F20_Mode16_OptionPage0_HeadRows::
    INCBIN "data/bank_25/Map_25_6F20_Mode16_OptionPage0_HeadRows.tilemap" ; $6F20, 64 bytes
; I: option page 0 of mode $16: 16 rows of 32 copied to $9840 by Mode16_BuildOptionList (table 06:4B67 entry 0); its
; builder Mode16_BuildList0 is a bare ret
Map_25_6F60_Mode16_OptionPage0::
    INCBIN "data/bank_25/Map_25_6F60_Mode16_OptionPage0.tilemap" ; $6F60, 512 bytes
; I: copied to VRAM/WRAM by Mode16_State00_Init, Mode16_State01_Redraw, Mode16_State03_TrickLensesMenu,
; Mode16_State04_MontageMenu, Mode16_State05_PanoramaMenu, Mode16_State06_GameFaceMenu
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 13 replay(s) of the organic corpus, modes
; ...
Map_25_7160_Mode16_State00_Init::
    INCBIN "data/bank_25/Map_25_7160_Mode16_State00_Init.tilemap" ; $7160, 576 bytes
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
; I: copied to VRAM/WRAM by Boot_EraseAllPrompt_Far (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 2 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Map_25_7820_Boot_EraseAllPrompt_Far::
    INCBIN "data/bank_25/Map_25_7820_Boot_EraseAllPrompt_Far.tilemap" ; $7820, 576 bytes
; I: copied to VRAM/WRAM by Mode1B_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 9 replay(s) of the organic corpus, modes 1B (tcrf_check/assets/l3_names/)
Map_25_7A60_Mode1B_State00_Init::
    INCBIN "data/bank_25/Map_25_7A60_Mode1B_State00_Init.tilemap" ; $7A60, 576 bytes
; I: target 40 of the {lo,hi,bank} table 04:539D; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 11)
Src_25_7CA0_Tbl539D_40::
    db $00, $01, $00, $02, $00, $02, $00, $02, $00, $02, $00, $02, $00, $02, $00, $02
    db $00, $02, $00, $dc, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $03, $00, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0c, $0c, $0d, $0e, $0f
    db $dd, $de, $03, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $10, $11, $12, $13, $14, $14, $14, $15, $16, $17, $18, $18, $19, $08, $1a
    db $df, $e0, $00, $10, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $03, $00, $1b, $1c, $1d, $1e, $1f, $20, $21, $22, $23, $24, $25, $26, $27, $28
    db $e1, $0c, $03, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $10, $29, $2a, $2b, $2c, $2d, $2e, $2f, $30, $31, $32, $33, $34, $35, $15
    db $27, $18, $00, $10, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $03, $00, $2a, $36, $37, $38, $39, $3a, $3b, $3c, $3d, $3e, $3f, $40, $41, $42
    db $e2, $2a, $03, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $10, $43, $44, $45, $46, $47, $48, $49, $4a, $4b, $4c, $4d, $4e, $4f, $50
    db $e3, $26, $00, $10, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $03, $00, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5a, $5b, $5c, $5d, $5e
    db $e4, $1e, $03, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $10, $5f, $60, $61, $62, $63, $64, $65, $66, $67, $68, $69, $6a, $6b, $6c
    db $e5, $e6, $00, $10, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

    db $03, $00, $6d, $6e, $6f, $70, $71, $72, $73, $74, $75, $76, $77, $78, $79, $7a
    db $e7, $40, $03, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $10, $7b, $7c, $7d, $7e, $7f, $80, $81, $82, $83, $84, $85, $86, $87, $88
    db $e8, $e9, $00, $10, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $03, $00, $89, $8a, $8b, $8c, $8d, $8e, $8f, $90, $91, $92, $93, $94, $95, $96
    db $1e, $15, $03, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $10, $97, $98, $99, $9a, $9b, $9c, $9d, $9e, $9f, $a0, $a1, $a2, $a3, $a4
    db $ea, $eb, $00, $10, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $03, $00, $a5, $a6, $a7, $a8, $a9, $aa, $ab, $ac, $ad, $ae, $af, $b0, $b1, $b2
    db $ec, $ed, $03, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $10, $b3, $b4, $b5, $b6, $b7, $b8, $b9, $b9, $ba, $bb, $af, $bc, $bd, $be
    db $ee, $ef, $00, $10, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $03, $00, $bf, $c0, $c1, $c2, $c3, $c4, $c5, $c6, $c7, $c8, $c9, $ca, $cb, $cc
    db $f0, $f1, $03, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $10, $18, $cd, $ce, $cf, $d0, $d1, $d2, $d3, $d4, $d5, $d6, $d7, $d8, $d9
    db $f2, $f3, $00, $10, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $da, $00, $02, $00, $02, $00, $02, $00, $02, $00, $02, $00, $02, $00, $02, $00
    db $02, $00, $f4, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $fc, $d7, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd
    db $fd, $e6, $e7, $e8, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $d8, $d9, $a0, $a1, $fe, $a4, $a5, $fe, $a8, $a9, $fe, $ac, $ad, $fe, $b0, $b1
    db $fe, $e9, $ea, $eb, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $da, $db, $a2, $a3, $fe, $a6, $a7, $fe, $aa, $ab, $fe, $ae, $af, $fe, $b2, $b3
    db $fe, $f0, $f1, $f2, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $dc, $dd, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $e4, $f3, $f4, $f5, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $de, $df, $b4, $b5, $fe, $b8, $b9, $fe, $bc, $bd, $fe, $c0, $c1, $fe, $c4, $c5
    db $e5, $f6, $f7, $f8, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e0, $e1, $b6, $b7, $fe, $ba, $bb, $fe, $be, $bf, $fe, $c2, $c3, $fe, $c6, $c7
    db $fe, $f9, $fa, $fb, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e2, $e3, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $fe, $ec, $ed, $ee, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ee, $ee, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $fe, $ee, $ee, $ee, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ee, $ee, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $fe, $ee, $ee, $ee

    ; padding
    ds $c, $ff
