; Pocket Camera (Japan) (Rev A), bank $27. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $027", ROMX[$4000], BANK[$27]

; C: frame 2 of the dancing man (Kentaro Nishimura, credited CORDINATOR (sic) and SOUND COMPOSER; the "Miyamoto"
; attribution found on the web is an error: owner) of the short credits: {lo,hi,bank,duration} table 09:5145 (4
; records, 8 frames each), 0x470 bytes copied to $9000 by ...
Gfx_27_4000_CreditsNishimuraDanceFrame02::
    INCBIN "data/bank_27/Gfx_27_4000_CreditsNishimuraDanceFrame02.2bpp" ; $4000, 1136 bytes
; C: copied to VRAM/WRAM by Album_ShowPageScreen, Album_ShowPageScreenB, Mode0A_State03_SliderBrowse,
; Album_LoadSliderScreen, Album_LoadBorderScreen, Mode0D_State06_PlayInit (roms/jp_rev_a/assets/catalog_jp.csv). L3
; pass 2026-10-26: read in BGB in 71 replay(s) of the organic corpus, modes 09 0A ...
Map_27_4470_Mode0D_State06_PlayInit::
    INCBIN "data/bank_27/Map_27_4470_Mode0D_State06_PlayInit.tilemap" ; $4470, 2 bytes
; C: far pointer loaded by Mode1C_DrawOptionScreen, Mode1C_DrawPrintScreen (ld a,BANK; ld hl,ADDR; call banked
; copy/far call). L3 pass 2026-10-26: read in BGB in 71 replay(s) of the organic corpus, modes 09 0A 1C
; (tcrf_check/assets/l3_names/)
Map_27_4472_Mode1C_DrawOptionScreen::
    INCBIN "data/bank_27/Map_27_4472_Mode1C_DrawOptionScreen.tilemap" ; $4472, 64 bytes
; C: far pointer loaded by Mode17_State08_Split_Build, Mode17_State0E_Fusion_Build, Mode0E_State04_PickDone,
; Mode0E_State0D_PickSecond (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass 2026-10-26: read in BGB in 71
; replay(s), modes 09 0A 1C (states 09:01 0A:03 09:02 1C:03 0A:04), not only by ...
Map_27_44B2_Mode17_State08_Split_Build::
    INCBIN "data/bank_27/Map_27_44B2_Mode17_State08_Split_Build.tilemap" ; $44B2, 638 bytes
; C: copied to VRAM/WRAM by Compose_Fusion_DrawMakeBlink, Compose_Split_DrawMakeBlink, Mode0E_State02_MessageStrip
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 6 replay(s), modes 1C (states 1C:03), not
; only by the consumer the name gives: a shared asset or table; first ...
Map_27_44B2_Compose_Split_DrawMakeBlink_Part4730::
    INCBIN "data/bank_27/Map_27_44B2_Compose_Split_DrawMakeBlink_Part4730.tilemap" ; $4730, 66 bytes
; I: eight blank rows ($FD) after the 22-row map copied from 27:44B2 and before the map copied from 27:4870; filler
Map_27_4772_BlankRows::
    INCBIN "data/bank_27/Map_27_4772_BlankRows.tilemap" ; $4772, 254 bytes
; C: copied to VRAM/WRAM by Mode04_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 37 replay(s) of the organic corpus, modes 04 (tcrf_check/assets/l3_names/)
Map_27_4870_Mode04_State00_Init::
    INCBIN "data/bank_27/Map_27_4870_Mode04_State00_Init.tilemap" ; $4870, 576 bytes
; C: small 2bpp tile set (round shapes, then $FF / $00 filler) read in part only by forced runs; it start. L3 pass
; 2026-10-26: read in BGB in 4 replay(s) of the organic corpus, modes 10 (tcrf_check/assets/l3_names/)
TileSet_27_4AB0::
    INCBIN "data/bank_27/TileSet_27_4AB0.bin" ; $4AB0, 512 bytes
; C: far pointer loaded by PhotoPicker_PageTransitionNext, PhotoPicker_PageTransitionPrev, LinkPick_PageTurnNext,
; LinkPick_PageTurnPrev (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 512 from the nearby ld bc. L3 pass
; 2026-10-26: read in BGB in 31 replay(s) of the organic corpus, modes 0F 11 ...
Map_27_4CB0_PhotoPicker_PageTransitionPrev::
    INCBIN "data/bank_27/Map_27_4CB0_PhotoPicker_PageTransitionPrev.tilemap" ; $4CB0, 512 bytes
; C: far pointer loaded by PhotoPicker_PageTransitionNext, PhotoPicker_PageTransitionPrev, LinkPick_PageTurnNext,
; LinkPick_PageTurnPrev (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 512 from the nearby ld bc. L3 pass
; 2026-10-26: read in BGB in 31 replay(s) of the organic corpus, modes 0F 11 ...
Map_27_4EB0_PhotoPicker_PageTransitionPrev::
    INCBIN "data/bank_27/Map_27_4EB0_PhotoPicker_PageTransitionPrev.tilemap" ; $4EB0, 512 bytes
; C: far pointer loaded by PhotoPicker_PageTransitionNext, PhotoPicker_PageTransitionPrev, LinkPick_PageTurnNext,
; LinkPick_PageTurnPrev (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 512 from the nearby ld bc. L3 pass
; 2026-10-26: read in BGB in 31 replay(s) of the organic corpus, modes 0F 11 ...
Map_27_50B0_PhotoPicker_PageTransitionPrev::
    INCBIN "data/bank_27/Map_27_50B0_PhotoPicker_PageTransitionPrev.tilemap" ; $50B0, 512 bytes
; C: far pointer loaded by PhotoPicker_PageTransitionNext, PhotoPicker_PageTransitionPrev, LinkPick_PageTurnNext,
; LinkPick_PageTurnPrev (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 512 from the nearby ld bc. L3 pass
; 2026-10-26: read in BGB in 31 replay(s) of the organic corpus, modes 0F 11 ...
Map_27_52B0_PhotoPicker_PageTransitionPrev::
    INCBIN "data/bank_27/Map_27_52B0_PhotoPicker_PageTransitionPrev.tilemap" ; $52B0, 512 bytes
; C: target 0 of the {lo,hi,bank} table 07:7CF9; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: read in BGB in 72 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Src_27_54B0_Tbl7CF9_0::
    INCBIN "data/bank_27/Src_27_54B0_Tbl7CF9_0.bin" ; $54B0, 448 bytes
; C: target 2 of the {lo,hi,bank} table 07:7CF9; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: read in BGB in 72 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Src_27_5670_Tbl7CF9_2::
    INCBIN "data/bank_27/Src_27_5670_Tbl7CF9_2.bin" ; $5670, 448 bytes
; C: target 1 of the {lo,hi,bank} table 07:7CF9; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: read in BGB in 72 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Src_27_5830_Tbl7CF9_1::
    INCBIN "data/bank_27/Src_27_5830_Tbl7CF9_1.bin" ; $5830, 448 bytes
; C: copied to VRAM/WRAM by Mode1F_State04_PerformanceSetup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1F)
Map_27_59F0_Mode1F_State04_PerformanceSetup::
    INCBIN "data/bank_27/Map_27_59F0_Mode1F_State04_PerformanceSetup.tilemap" ; $59F0, 192 bytes
; C: far pointer loaded by DjPerf_Equaliser (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass 2026-10-26:
; not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1F)
Src_27_5AB0_DjPerf_Equaliser::
    INCBIN "data/bank_27/Src_27_5AB0_DjPerf_Equaliser.bin" ; $5AB0, 256 bytes
; C: 448 bytes = 56 tile masks x 8 bytes (one mask byte per tile row, the same byte for both bit planes), 8 x 7 tiles
; = 64 x 56 pixels; read by Img_AndMaskTiles_Bank27 (00:1569, ld hl,$5BB0) which ANDs it into one quadrant of the
; image buffer ($C000 / $C080 / $C700 / $C780 chosen by $D7E4); drawn as 1 ...
Mask_27_5BB0_Img_AndMaskTiles_Oval::
    INCBIN "data/bank_27/Mask_27_5BB0_Img_AndMaskTiles_Oval.bin" ; $5BB0, 448 bytes
; C: far pointer loaded by Mode1F_State05_Performance (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 224
; from the nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz, first read in mode 1F)
Map_27_5D70_Mode1F_State05_Performance::
    INCBIN "data/bank_27/Map_27_5D70_Mode1F_State05_Performance.tilemap" ; $5D70, 224 bytes
; C: far pointer loaded by Mode1F_State06_SavePanel (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 224
; from the nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz, first read in mode 1F)
Map_27_5E50_Mode1F_State06_SavePanel::
    INCBIN "data/bank_27/Map_27_5E50_Mode1F_State06_SavePanel.tilemap" ; $5E50, 224 bytes
; C: copied to VRAM/WRAM by MainMenu_LoadBackground (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 72 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Map_27_5F30_MainMenu_LoadBackground::
    INCBIN "data/bank_27/Map_27_5F30_MainMenu_LoadBackground.tilemap" ; $5F30, 448 bytes
; C: target 7 of the {lo,hi,bank} table 07:53A6; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: read in BGB in 19 replay(s) of the organic corpus, modes 02 (tcrf_check/assets/l3_names/)
Src_27_60F0_Tbl53A6_7::
    INCBIN "data/bank_27/Src_27_60F0_Tbl53A6_7.bin" ; $60F0, 384 bytes
; C: target 6 of the {lo,hi,bank} table 07:53A6; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: read in BGB in 19 replay(s) of the organic corpus, modes 02 (tcrf_check/assets/l3_names/)
Src_27_6270_Tbl53A6_6::
    INCBIN "data/bank_27/Src_27_6270_Tbl53A6_6.bin" ; $6270, 384 bytes
; C: target 1 of the {lo,hi,bank} table 07:53A6; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: read in BGB in 35 replay(s) of the organic corpus, modes 02 (tcrf_check/assets/l3_names/)
Src_27_63F0_Tbl53A6_1::
    INCBIN "data/bank_27/Src_27_63F0_Tbl53A6_1.bin" ; $63F0, 384 bytes
; C: target 2 of the {lo,hi,bank} table 07:53A6; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: read in BGB in 34 replay(s) of the organic corpus, modes 02 (tcrf_check/assets/l3_names/)
Src_27_6570_Tbl53A6_2::
    INCBIN "data/bank_27/Src_27_6570_Tbl53A6_2.bin" ; $6570, 384 bytes
; C: target 5 of the {lo,hi,bank} table 07:53A6; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: read in BGB in 31 replay(s) of the organic corpus, modes 02 07 (tcrf_check/assets/l3_names/)
Src_27_66F0_Tbl53A6_5::
    db $f0, $eb, $eb, $eb, $f4, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $f6
    db $eb, $eb, $eb, $ee, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f1, $f2, $f2, $f3, $f4, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $f6
    db $fe, $f2, $f2, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f1, $f2, $f2, $f3, $f4, $d0, $d0, $4f, $4e, $4d, $4c, $4b, $d0, $d0, $d0, $f6
    db $fe, $f2, $f2, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f1, $f2, $f2, $f3, $f4, $d0, $4a, $49, $d1, $d1, $d1, $48, $47, $d0, $d0, $f6
    db $fe, $f2, $f2, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f0, $eb, $eb, $eb, $f4, $46, $45, $d1, $d1, $d1, $d1, $d1, $44, $43, $d0, $f6
    db $eb, $eb, $eb, $ee, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f0, $ec, $ed, $eb, $f4, $a2, $d1, $d1, $d1, $41, $40, $3f, $d1, $3e, $d0, $f6
    db $eb, $ec, $ed, $ee, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e7, $e8, $e9, $ea, $f4, $a2, $d1, $d1, $d1, $3d, $3c, $3b, $d1, $3a, $39, $f6
    db $d2, $d3, $d4, $d5, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f7, $f8, $f9, $fa, $f4, $a2, $d1, $d1, $d1, $ac, $c1, $cb, $d1, $b0, $8d, $f6
    db $d6, $d7, $d8, $d9, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f0, $da, $db, $eb, $f4, $a5, $d1, $d1, $d1, $bc, $ae, $91, $d1, $b0, $8d, $f6
    db $eb, $da, $db, $ee, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f0, $eb, $eb, $eb, $f4, $4b, $1c, $39, $39, $39, $39, $39, $39, $1b, $4b, $f6
    db $eb, $eb, $eb, $ee, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f0, $eb, $eb, $eb, $f4, $4b, $1a, $19, $39, $39, $39, $39, $18, $17, $4b, $f6
    db $eb, $eb, $eb, $ee, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f0, $eb, $eb, $eb, $f4, $4b, $4b, $16, $15, $14, $14, $13, $12, $4b, $4b, $f6
    db $eb, $eb, $eb, $ee, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $70, $71, $72, $73, $74, $6b, $6c, $6d, $6e, $6f, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $80, $81, $82, $83, $84, $7b, $7c, $7d, $7e, $7f, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $29, $2a, $2b, $2c, $2d, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $2e, $2f, $39, $3a, $bf, $bf, $3b, $3c, $3d, $3e, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $75, $76, $77, $78, $79, $7a, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $85, $86, $87, $88, $89, $8a, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $49, $4a, $29, $2a, $2b, $2c, $2d, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $2e, $2f, $39, $3a, $bf, $bf, $3b, $3c, $3d, $3e, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f

    ; padding
    ds $16, $bf

; C: target 38 of the {lo,hi,bank} table 04:539D; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 11)
Src_27_6AF0_Tbl539D_38::
    INCBIN "data/bank_27/Src_27_6AF0_Tbl539D_38.bin" ; $6AF0, 288 bytes
; C: target 35 of the {lo,hi,bank} table 04:539D; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 11)
Src_27_6C10_Tbl539D_35::
    INCBIN "data/bank_27/Src_27_6C10_Tbl539D_35.bin" ; $6C10, 288 bytes
; C: far pointer loaded by Mode12_State1D_SortDialogOpen (ld a,BANK; ld hl,ADDR; call banked copy/far call); length
; 288 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 3 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
Map_27_6D30_Mode12_State1D_SortDialogOpen::
    db $fb, $fc, $fc, $fc, $fc, $cb, $cc, $cd, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc
    db $fc, $fc, $fc, $fb, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
    db $fb, $fd, $fd, $fd, $fd, $ce, $cf, $d0, $d1, $d2, $d3, $d4, $d5, $d6, $fd, $fd
    db $fd, $fd, $fd, $fb, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
    db $fb, $fd, $fd, $fd, $fd, $fd, $d7, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd
    db $fd, $fd, $fd, $fb, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
    db $fb, $fd, $fd, $fd, $fd, $fd, $d8, $d9, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd
    db $fd, $fd, $fd, $fb, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
    db $fb, $fd, $fd, $fd, $fd, $fd, $da, $db, $dc, $fd, $fd, $fd, $fd, $fd, $fd, $fd
    db $fd, $fd, $fd, $fb, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
    db $fb, $dd, $de, $df, $e0, $c9, $fd, $fd, $e5, $e6, $e7, $e8, $e9, $ea, $eb, $ec
    db $ed, $ee, $ef, $fb, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
    db $fb, $e1, $e2, $e3, $e4, $ca, $c7, $c8, $f0, $f1, $f2, $f3, $f4, $f5, $f6, $f7
    db $f8, $f9, $fa, $fb, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
    db $fb, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd
    db $fd, $fd, $fd, $fb

    ; padding
    ds $2c, $0f

; C: far pointer loaded by Mode12_State17_ExitDialogOpen (ld a,BANK; ld hl,ADDR; call banked copy/far call); length
; 288 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
Map_27_6E50_Mode12_State17_ExitDialogOpen::
    db $da, $db, $db, $db, $db, $db, $db, $dc, $dd, $de, $df, $e0, $e1, $db, $db, $db
    db $db, $db, $db, $da, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $da, $fe, $fe, $fe, $fe, $fe, $fe, $e2, $e3, $e4, $e5, $e6, $e7, $fe, $fe, $fe
    db $fe, $fe, $fe, $da, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $da, $fe, $fe, $fe, $fe, $fe, $e8, $e9, $ea, $eb, $ec, $ed, $ee, $fe, $fe, $fe
    db $fe, $fe, $fe, $da, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $da, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ef, $f0, $f1, $f2, $fe, $fe, $fe, $fe
    db $fe, $fe, $fe, $da, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $da, $fe, $c0, $c1, $c2, $c3, $c4, $c5, $fe, $f3, $f4, $fe, $cc, $cd, $ce, $cf
    db $d0, $d1, $d2, $da, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $da, $fe, $c6, $c7, $c8, $c9, $ca, $cb, $fe, $f5, $f6, $f7, $d3, $d4, $d5, $d6
    db $d7, $d8, $d9, $da, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $da, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $fe, $fe, $fe, $da, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $da, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $fe, $fe, $fe, $da

    ; padding
    ds $2c, $fe

; C: target 36 of the {lo,hi,bank} table 04:539D; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 11)
Src_27_6F70_Tbl539D_36::
    INCBIN "data/bank_27/Src_27_6F70_Tbl539D_36.bin" ; $6F70, 288 bytes
; C: far pointer loaded by SaveDialog_Substate0_Init (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 288
; from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the organic corpus, modes 10 11 1A
; (tcrf_check/assets/l3_names/)
Map_27_7090_SaveDialog_Substate0_Init::
    INCBIN "data/bank_27/Map_27_7090_SaveDialog_Substate0_Init.tilemap" ; $7090, 288 bytes
; C: far pointer loaded by Stamp_ReloadTilemapIfDifferent (ld a,BANK; ld hl,ADDR; call banked copy/far call); length
; 288 from the nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the
; core emulator (coverage/results/merged_state/cov.npz, first read in mode ...
Map_27_71B0_Stamp_ReloadTilemapIfDifferent::
    INCBIN "data/bank_27/Map_27_71B0_Stamp_ReloadTilemapIfDifferent.tilemap" ; $71B0, 288 bytes
; C: target 34 of the {lo,hi,bank} table 04:539D; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 11 (tcrf_check/assets/l3_names/)
Src_27_72D0_Tbl539D_34::
    INCBIN "data/bank_27/Src_27_72D0_Tbl539D_34.bin" ; $72D0, 288 bytes
; C: target 37 of the {lo,hi,bank} table 04:539D; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code: target 37 of
; the stamp-category table 04:539D (Stamp_CatMapSrcTbl)
Src_27_73F0_Tbl539D_37::
    INCBIN "data/bank_27/Src_27_73F0_Tbl539D_37.bin" ; $73F0, 288 bytes
; C: far pointer loaded by Mode12_State14_SaveDialogOpen (ld a,BANK; ld hl,ADDR; call banked copy/far call); length
; 288 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
Map_27_7510_Mode12_State14_SaveDialogOpen::
    db $c0, $c1, $c1, $c1, $c1, $c1, $c1, $c2, $c3, $c4, $c5, $c6, $c7, $c1, $c1, $c1
    db $c1, $c1, $c1, $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $c0, $fe, $fe, $fe, $fe, $fe, $c8, $c9, $ca, $cb, $cc, $cd, $ce, $fe, $fe, $fe
    db $fe, $fe, $fe, $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $c0, $fe, $fe, $fe, $fe, $fe, $cf, $d0, $d1, $d2, $d3, $d4, $d5, $fe, $fe, $fe
    db $fe, $fe, $fe, $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $c0, $fe, $fe, $fe, $fe, $fe, $d6, $d7, $d8, $d9, $da, $db, $fe, $fe, $fe, $fe
    db $fe, $fe, $fe, $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $c0, $fe, $e4, $e5, $e6, $e7, $e8, $e9, $dc, $dd, $fe, $fe, $f0, $f1, $f2, $f3
    db $f4, $f5, $f6, $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $c0, $fe, $ea, $eb, $ec, $ed, $ee, $ef, $de, $df, $e0, $e1, $f7, $f8, $f9, $fa
    db $fb, $fc, $fd, $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $e2, $e3, $fe, $fe, $fe, $fe, $fe
    db $fe, $fe, $fe, $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $fe, $fe, $fe, $c0

    ; padding
    ds $2c, $fe

; C: far pointer loaded by Mode1A_State09_ExitDialog (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 288
; from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
Map_27_7630_Mode1A_State09_ExitDialog::
    INCBIN "data/bank_27/Map_27_7630_Mode1A_State09_ExitDialog.tilemap" ; $7630, 128 bytes
; C: far pointer loaded by HotSpotEd_DialogChoiceB (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 64 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
Map_27_76B0_HotSpotEd_DialogChoiceB::
    INCBIN "data/bank_27/Map_27_76B0_HotSpotEd_DialogChoiceB.tilemap" ; $76B0, 96 bytes
; C: far pointer loaded by HotSpotEd_DialogChoiceB, Mode1A_State09_ExitDialog (ld a,BANK; ld hl,ADDR; call banked
; copy/far call); length 64 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic
; corpus, modes 1A (tcrf_check/assets/l3_names/)
Map_27_7710_Mode1A_State09_ExitDialog::
    INCBIN "data/bank_27/Map_27_7710_Mode1A_State09_ExitDialog.tilemap" ; $7710, 64 bytes
; C: far pointer loaded by Mode1A_State03_Browse (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 288 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
Map_27_7750_Mode1A_State03_Browse::
    INCBIN "data/bank_27/Map_27_7750_Mode1A_State03_Browse.tilemap" ; $7750, 128 bytes
; C: far pointer loaded by HotSpotEd_DialogChoiceA (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 64 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
Map_27_77D0_HotSpotEd_DialogChoiceA::
    INCBIN "data/bank_27/Map_27_77D0_HotSpotEd_DialogChoiceA.tilemap" ; $77D0, 96 bytes
; C: far pointer loaded by HotSpotEd_DialogChoiceA (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 64 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
Map_27_7830_HotSpotEd_DialogChoiceA::
    INCBIN "data/bank_27/Map_27_7830_HotSpotEd_DialogChoiceA.tilemap" ; $7830, 64 bytes
; C: far pointer loaded by Mode12_State1A_ClearDialogOpen (ld a,BANK; ld hl,ADDR; call banked copy/far call); length
; 288 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 3 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
Map_27_7870_Mode12_State1A_ClearDialogOpen::
    db $c0, $c1, $c1, $c1, $c1, $c1, $c1, $c1, $c2, $c3, $c4, $c5, $c6, $c1, $c1, $c1
    db $c1, $c1, $c1, $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $c0, $fe, $fe, $fe, $fe, $fe, $fe, $c7, $c8, $c9, $ca, $cb, $cc, $fe, $fe, $fe
    db $fe, $fe, $fe, $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $cd, $ce, $cf, $d0, $fe, $fe, $fe, $fe
    db $fe, $fe, $fe, $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $d1, $d2, $d3, $d4, $d5, $fe, $fe, $fe
    db $fe, $fe, $fe, $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $c0, $fe, $dd, $de, $df, $e0, $e1, $e2, $d6, $d7, $d8, $fe, $e9, $ea, $eb, $ec
    db $ed, $ee, $ef, $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $c0, $fe, $e3, $e4, $e5, $e6, $e7, $e8, $d9, $da, $fe, $fe, $f0, $f1, $f2, $f3
    db $f4, $f5, $f6, $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $db, $dc, $fe, $fe, $fe, $fe, $fe, $fe
    db $fe, $fe, $fe, $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $fe, $fe, $fe, $c0

    ; padding
    ds $2c, $fe

; C: copied to VRAM/WRAM by Mode1F_State08_EditPagesSetup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1F)
Map_27_7990_Mode1F_State08_EditPagesSetup::
    db $60, $61, $62, $63, $64, $65, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $66, $67, $68, $69, $6a, $6b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $8d, $8e, $8f, $9d, $9e, $9f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $3b, $3c, $3d, $3e, $fe, $ef, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $4b, $4c, $4d, $4e, $4f, $bd, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $fa, $fa, $fa, $fa, $fa, $fb, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

    ; padding
    ds $5b0, $00
