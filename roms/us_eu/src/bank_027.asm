; Game Boy Camera (USA, Europe), bank $27. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $027", ROMX[$4000], BANK[$27]

; C: loaded by Mem_CopyFromBank at 00:317A: Gfx $800 bytes to $9000 (this build's trace)
Gfx_27_4000_Mode1D_State01_LoadScreen::
    INCBIN "data/bank_27/Gfx_27_4000_Mode1D_State01_LoadScreen.2bpp" ; $4000, 2048 bytes
; C: loaded by Mem_CopyFromBank at 00:3188: Gfx $400 bytes to $8800 (this build's trace)
Gfx_27_4800_Mode1D_State01_LoadScreen::
    INCBIN "data/bank_27/Gfx_27_4800_Mode1D_State01_LoadScreen.2bpp" ; $4800, 1024 bytes
; C: frame 2 of the dancing man (Kentaro Nishimura, credited CORDINATOR (sic) and SOUND COMPOSER; the "Miyamoto"
; attribution found on the web is an error: owner) of the short credits: {lo,hi,bank,duration} table 09:5145 (4
; records, 8 frames each), 0x470 bytes copied to $9000 by ...
Gfx_27_4C00_CreditsNishimuraDanceFrame02::
    INCBIN "data/bank_27/Gfx_27_4C00_CreditsNishimuraDanceFrame02.2bpp" ; $4C00, 1136 bytes
; I: copied to VRAM/WRAM by Album_ShowPageScreen, Album_ShowPageScreenB, Mode0A_State03_SliderBrowse,
; Album_LoadSliderScreen, Album_LoadBorderScreen, Mode0D_State06_PlayInit (roms/jp_rev_a/assets/catalog_jp.csv). L3
; pass 2026-10-26: read in BGB in 71 replay(s) of the organic corpus, modes 09 0A ...
Map_27_5070_Mode0D_State06_PlayInit::
    INCBIN "data/bank_27/Map_27_5070_Mode0D_State06_PlayInit.tilemap" ; $5070, 2 bytes
; I: far pointer loaded by Mode1C_DrawOptionScreen, Mode1C_DrawPrintScreen (ld a,BANK; ld hl,ADDR; call banked
; copy/far call). L3 pass 2026-10-26: read in BGB in 71 replay(s) of the organic corpus, modes 09 0A 1C
; (tcrf_check/assets/l3_names/)
Map_27_5072_Mode1C_DrawOptionScreen::
    INCBIN "data/bank_27/Map_27_5072_Mode1C_DrawOptionScreen.tilemap" ; $5072, 64 bytes
; I: far pointer loaded by Mode17_State08_Split_Build, Mode17_State0E_Fusion_Build, Mode0E_State04_PickDone,
; Mode0E_State0D_PickSecond (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass 2026-10-26: read in BGB in 71
; replay(s), modes 09 0A 1C (states 09:01 0A:03 09:02 1C:03 0A:04), not only by ...
Map_27_50B2_Mode17_State08_Split_Build::
    INCBIN "data/bank_27/Map_27_50B2_Mode17_State08_Split_Build.tilemap" ; $50B2, 126 bytes
; C: loaded by Vram_CopyFromBank at 09:617D: Map $40 bytes to $98C0 (this build's trace)
Map_27_5130_Mode21_State01_PickCharacter::
    INCBIN "data/bank_27/Map_27_5130_Mode21_State01_PickCharacter.tilemap" ; $5130, 384 bytes
; C: loaded by Vram_CopyFromBank at 09:618C: Map $40 bytes to $98C0 (this build's trace)
Map_27_52B0_Mode21_State01_PickCharacter::
    INCBIN "data/bank_27/Map_27_52B0_Mode21_State01_PickCharacter.tilemap" ; $52B0, 64 bytes
; C: loaded by Vram_CopyFromBank at 09:4E62: Map $240 bytes to $9800 (this build's trace)
Map_27_52F0_Mode08_State13_CreditsPageA::
    INCBIN "data/bank_27/Map_27_52F0_Mode08_State13_CreditsPageA.tilemap" ; $52F0, 128 bytes
; C: loaded by Vram_CopyFromBank at 09:4EBC: Map $40 bytes to $9880 (this build's trace)
Map_27_5370_Mode08_State14_CreditsPageA2::
    INCBIN "data/bank_27/Map_27_5370_Mode08_State14_CreditsPageA2.tilemap" ; $5370, 256 bytes
; C: loaded by Vram_CopyFromBank at 09:4EE3: Map $40 bytes to $9980 (this build's trace)
Map_27_5470_Mode08_State14_CreditsPageA2::
    INCBIN "data/bank_27/Map_27_5470_Mode08_State14_CreditsPageA2.tilemap" ; $5470, 32 bytes
; I: copied to VRAM/WRAM by Compose_Fusion_DrawMakeBlink, Compose_Split_DrawMakeBlink, Mode0E_State02_MessageStrip
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 6 replay(s), modes 1C (states 1C:03), not
; only by the consumer the name gives: a shared asset or table; first ...
Map_27_50B2_Compose_Split_DrawMakeBlink_Part5490::
    INCBIN "data/bank_27/Map_27_50B2_Compose_Split_DrawMakeBlink_Part5490.tilemap" ; $5490, 66 bytes
; I: eight blank rows ($FD) after the 22-row map copied from 27:44B2 and before the map copied from 27:4870; filler
Map_27_54D2_BlankRows::
    INCBIN "data/bank_27/Map_27_54D2_BlankRows.tilemap" ; $54D2, 94 bytes
; C: loaded by Vram_CopyFromBank at 09:4ECC: Map $40 bytes to $9880 (this build's trace)
Map_27_5530_Mode08_State14_CreditsPageA2::
    INCBIN "data/bank_27/Map_27_5530_Mode08_State14_CreditsPageA2.tilemap" ; $5530, 64 bytes
; C: loaded by Vram_CopyFromBank at 09:4EF3: Map $40 bytes to $9980 (this build's trace)
Map_27_5570_Mode08_State14_CreditsPageA2::
    INCBIN "data/bank_27/Map_27_5570_Mode08_State14_CreditsPageA2.tilemap" ; $5570, 64 bytes
; C: loaded by Vram_CopyFromBank at 09:4F2D: Map $40 bytes to $9800 (this build's trace)
Map_27_55B0_Mode08_State14_CreditsPageA2::
    INCBIN "data/bank_27/Map_27_55B0_Mode08_State14_CreditsPageA2.tilemap" ; $55B0, 32 bytes
; I: copied to VRAM/WRAM by Mode04_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 37 replay(s) of the organic corpus, modes 04 (tcrf_check/assets/l3_names/)
Map_27_55D0_Mode04_State00_Init::
    INCBIN "data/bank_27/Map_27_55D0_Mode04_State00_Init.tilemap" ; $55D0, 352 bytes
; C: loaded by Vram_CopyFromBank at 09:4F81: Map $C0 bytes to $9980 (this build's trace)
Map_27_5730_Mode08_State14_CreditsPageA2::
    INCBIN "data/bank_27/Map_27_5730_Mode08_State14_CreditsPageA2.tilemap" ; $5730, 192 bytes
; C: loaded by Vram_CopyFromBank at 09:5004: Map $20 bytes to $9980 (this build's trace)
Map_27_57F0_Mode08_State15_CreditsPageB::
    INCBIN "data/bank_27/Map_27_57F0_Mode08_State15_CreditsPageB.tilemap" ; $57F0, 32 bytes
; C: small 2bpp tile set (round shapes, then $FF / $00 filler) read in part only by forced runs; it start. L3 pass
; 2026-10-26: read in BGB in 4 replay(s) of the organic corpus, modes 10 (tcrf_check/assets/l3_names/)
TileSet_27_5810::
    INCBIN "data/bank_27/TileSet_27_5810.bin" ; $5810, 512 bytes
; C: far pointer loaded by PhotoPicker_PageTransitionNext, PhotoPicker_PageTransitionPrev, LinkPick_PageTurnNext,
; LinkPick_PageTurnPrev (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 512 from the nearby ld bc. L3 pass
; 2026-10-26: read in BGB in 31 replay(s) of the organic corpus, modes 0F 11 ...
Map_27_5A10_PhotoPicker_PageTransitionPrev::
    INCBIN "data/bank_27/Map_27_5A10_PhotoPicker_PageTransitionPrev.tilemap" ; $5A10, 512 bytes
; C: far pointer loaded by PhotoPicker_PageTransitionNext, PhotoPicker_PageTransitionPrev, LinkPick_PageTurnNext,
; LinkPick_PageTurnPrev (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 512 from the nearby ld bc. L3 pass
; 2026-10-26: read in BGB in 31 replay(s) of the organic corpus, modes 0F 11 ...
Map_27_5C10_PhotoPicker_PageTransitionPrev::
    INCBIN "data/bank_27/Map_27_5C10_PhotoPicker_PageTransitionPrev.tilemap" ; $5C10, 512 bytes
; C: far pointer loaded by PhotoPicker_PageTransitionNext, PhotoPicker_PageTransitionPrev, LinkPick_PageTurnNext,
; LinkPick_PageTurnPrev (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 512 from the nearby ld bc. L3 pass
; 2026-10-26: read in BGB in 31 replay(s) of the organic corpus, modes 0F 11 ...
Map_27_5E10_PhotoPicker_PageTransitionPrev::
    INCBIN "data/bank_27/Map_27_5E10_PhotoPicker_PageTransitionPrev.tilemap" ; $5E10, 512 bytes
; C: far pointer loaded by PhotoPicker_PageTransitionNext, PhotoPicker_PageTransitionPrev, LinkPick_PageTurnNext,
; LinkPick_PageTurnPrev (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 512 from the nearby ld bc. L3 pass
; 2026-10-26: read in BGB in 31 replay(s) of the organic corpus, modes 0F 11 ...
Map_27_6010_PhotoPicker_PageTransitionPrev::
    INCBIN "data/bank_27/Map_27_6010_PhotoPicker_PageTransitionPrev.tilemap" ; $6010, 512 bytes
; C: 448 bytes = 56 tile masks x 8 bytes (one mask byte per tile row, the same byte for both bit planes), 8 x 7 tiles
; = 64 x 56 pixels; read by Img_AndMaskTiles_Bank27 (00:1569, ld hl,$5BB0) which ANDs it into one quadrant of the
; image buffer ($C000 / $C080 / $C700 / $C780 chosen by $D7E4); drawn as 1 ...
Mask_27_6210_Img_AndMaskTiles_Oval::
    INCBIN "data/bank_27/Mask_27_6210_Img_AndMaskTiles_Oval.bin" ; $6210, 448 bytes
; I: far pointer loaded by Mode1F_State05_Performance (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 224
; from the nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz, first read in mode 1F)
Map_27_63D0_Mode1F_State05_Performance::
    INCBIN "data/bank_27/Map_27_63D0_Mode1F_State05_Performance.tilemap" ; $63D0, 224 bytes
; I: far pointer loaded by Mode1F_State06_SavePanel (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 224
; from the nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz, first read in mode 1F)
Map_27_64B0_Mode1F_State06_SavePanel::
    INCBIN "data/bank_27/Map_27_64B0_Mode1F_State06_SavePanel.tilemap" ; $64B0, 224 bytes
; I: copied to VRAM/WRAM by MainMenu_LoadBackground (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 72 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Map_27_6590_MainMenu_LoadBackground::
    INCBIN "data/bank_27/Map_27_6590_MainMenu_LoadBackground.tilemap" ; $6590, 448 bytes
; I: target 7 of the {lo,hi,bank} table 07:53A6; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: read in BGB in 19 replay(s) of the organic corpus, modes 02 (tcrf_check/assets/l3_names/)
Src_27_6750_Tbl53A6_7::
    INCBIN "data/bank_27/Src_27_6750_Tbl53A6_7.bin" ; $6750, 384 bytes
; I: target 6 of the {lo,hi,bank} table 07:53A6; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: read in BGB in 19 replay(s) of the organic corpus, modes 02 (tcrf_check/assets/l3_names/)
Src_27_68D0_Tbl53A6_6::
    INCBIN "data/bank_27/Src_27_68D0_Tbl53A6_6.bin" ; $68D0, 384 bytes
; I: target 1 of the {lo,hi,bank} table 07:53A6; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: read in BGB in 35 replay(s) of the organic corpus, modes 02 (tcrf_check/assets/l3_names/)
Src_27_6A50_Tbl53A6_1::
    INCBIN "data/bank_27/Src_27_6A50_Tbl53A6_1.bin" ; $6A50, 384 bytes
; I: target 2 of the {lo,hi,bank} table 07:53A6; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: read in BGB in 34 replay(s) of the organic corpus, modes 02 (tcrf_check/assets/l3_names/)
Src_27_6BD0_Tbl53A6_2::
    INCBIN "data/bank_27/Src_27_6BD0_Tbl53A6_2.bin" ; $6BD0, 384 bytes
; I: target 5 of the {lo,hi,bank} table 07:53A6; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: read in BGB in 31 replay(s) of the organic corpus, modes 02 07 (tcrf_check/assets/l3_names/)
Src_27_6D50_Tbl53A6_5::
    db $f0, $eb, $eb, $eb, $f4, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $f6
    db $eb, $eb, $eb, $ee, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb
    db $f1, $f2, $f2, $f3, $f4, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $f6
    db $fe, $f2, $f2, $ff, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb
    db $f1, $f2, $f2, $f3, $f4, $d0, $d0, $4f, $4e, $4d, $4c, $4b, $d0, $d0, $d0, $f6
    db $fe, $f2, $f2, $ff, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb
    db $f1, $f2, $f2, $f3, $f4, $d0, $4a, $49, $d1, $d1, $d1, $48, $47, $d0, $d0, $f6
    db $fe, $f2, $f2, $ff, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb
    db $f0, $eb, $eb, $eb, $f4, $46, $45, $d1, $d1, $d1, $d1, $d1, $44, $43, $d0, $f6
    db $eb, $eb, $eb, $ee, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb
    db $f0, $ec, $ed, $eb, $f4, $a2, $d1, $d1, $d1, $41, $40, $3f, $d1, $3e, $d0, $f6
    db $eb, $ec, $ed, $ee, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb
    db $e7, $e8, $e9, $ea, $f4, $a2, $d1, $d1, $d1, $3d, $3c, $3b, $d1, $3a, $39, $f6
    db $d2, $d3, $d4, $d5, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb
    db $f7, $f8, $f9, $fa, $f4, $a2, $d1, $d1, $d1, $ac, $c1, $cb, $d1, $b0, $8d, $f6
    db $d6, $d7, $d8, $d9, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb
    db $f0, $da, $db, $eb, $f4, $a5, $d1, $d1, $d1, $bc, $ae, $91, $d1, $b0, $8d, $f6
    db $eb, $da, $db, $ee, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb
    db $f0, $eb, $eb, $eb, $f4, $4b, $1c, $39, $39, $39, $39, $39, $39, $1b, $4b, $f6
    db $eb, $eb, $eb, $ee, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb
    db $f0, $eb, $eb, $eb, $f4, $4b, $1a, $19, $39, $39, $39, $39, $18, $17, $4b, $f6
    db $eb, $eb, $eb, $ee, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb
    db $f0, $55, $65, $eb, $f4, $4b, $4b, $16, $15, $14, $14, $13, $12, $4b, $4b, $f6
    db $eb, $55, $65, $ee, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb, $cb
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

; I: far pointer loaded by Mode12_State1D_SortDialogOpen (ld a,BANK; ld hl,ADDR; call banked copy/far call); length
; 288 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 3 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
Map_27_7150_Mode12_State1D_SortDialogOpen::
    db $fb, $fc, $fc, $fc, $fc, $cb, $cc, $cd, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc
    db $fc, $fc, $fc, $fb, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
    db $fb, $d6, $d6, $d6, $d6, $ce, $cf, $d0, $d1, $d2, $d3, $d4, $d5, $d6, $d6, $d6
    db $d6, $d6, $d6, $fb, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
    db $fb, $d6, $d6, $d6, $d6, $d6, $d7, $d6, $d6, $d6, $d6, $d6, $d6, $d6, $d6, $d6
    db $d6, $d6, $d6, $fb, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
    db $fb, $d6, $d6, $d6, $d6, $d6, $d8, $d9, $d6, $d6, $d6, $d6, $d6, $d6, $d6, $d6
    db $d6, $d6, $d6, $fb, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
    db $fb, $d6, $d6, $d6, $d6, $d6, $da, $db, $dc, $d6, $d6, $d6, $d6, $d6, $d6, $d6
    db $d6, $d6, $d6, $fb, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
    db $fb, $dd, $de, $df, $e0, $e1, $d6, $c9, $e5, $e6, $e7, $e8, $e9, $ea, $eb, $ec
    db $ed, $ee, $ef, $fb, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
    db $fb, $e2, $e3, $e4, $c7, $c8, $d6, $ca, $f0, $f1, $f2, $f3, $f4, $f5, $f6, $f7
    db $f8, $f9, $fa, $fb, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
    db $fb, $d6, $d6, $d6, $d6, $d6, $d6, $d6, $d6, $d6, $d6, $d6, $d6, $d6, $d6, $d6
    db $d6, $d6, $d6, $fb

    ; padding
    ds $2c, $0f

; I: far pointer loaded by Mode12_State17_ExitDialogOpen (ld a,BANK; ld hl,ADDR; call banked copy/far call); length
; 288 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
Map_27_7270_Mode12_State17_ExitDialogOpen::
    db $da, $db, $db, $db, $db, $db, $db, $db, $dc, $dd, $de, $df, $e0, $db, $db, $db
    db $db, $db, $db, $da, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $da, $fe, $fe, $fe, $fe, $fe, $fe, $e1, $e2, $e3, $e4, $e5, $e6, $fe, $fe, $fe
    db $fe, $fe, $fe, $da, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $da, $fe, $fe, $fe, $fe, $fe, $e7, $e8, $e9, $ea, $eb, $ec, $ed, $fe, $fe, $fe
    db $fe, $fe, $fe, $da, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $da, $fe, $fe, $fe, $fe, $fe, $fe, $ee, $fe, $ef, $f0, $fe, $fe, $fe, $fe, $fe
    db $fe, $fe, $fe, $da, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $da, $fe, $c0, $c1, $c2, $c3, $c4, $c5, $fe, $f1, $f2, $fe, $cc, $cd, $ce, $cf
    db $d0, $d1, $d2, $da, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $da, $fe, $c6, $c7, $c8, $c9, $ca, $cb, $fe, $f3, $f4, $f5, $d3, $d4, $d5, $d6
    db $d7, $d8, $d9, $da, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $da, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $f6, $f7, $fe, $fe, $fe, $fe, $fe
    db $fe, $fe, $fe, $da, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $da, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $fe, $fe, $fe, $da

    ; padding
    ds $2c, $fe

; C: target 36 of the {lo,hi,bank} table 04:539D; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 11)
Src_27_7390_Tbl539D_36::
    INCBIN "data/bank_27/Src_27_7390_Tbl539D_36.bin" ; $7390, 288 bytes
; I: far pointer loaded by SaveDialog_Substate0_Init (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 288
; from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the organic corpus, modes 10 11 1A
; (tcrf_check/assets/l3_names/)
Map_27_74B0_SaveDialog_Substate0_Init::
    INCBIN "data/bank_27/Map_27_74B0_SaveDialog_Substate0_Init.tilemap" ; $74B0, 288 bytes
; C: far pointer loaded by Stamp_ReloadTilemapIfDifferent (ld a,BANK; ld hl,ADDR; call banked copy/far call); length
; 288 from the nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the
; core emulator (coverage/results/merged_state/cov.npz, first read in mode ...
Map_27_75D0_Stamp_ReloadTilemapIfDifferent::
    INCBIN "data/bank_27/Map_27_75D0_Stamp_ReloadTilemapIfDifferent.tilemap" ; $75D0, 288 bytes
; C: target 34 of the {lo,hi,bank} table 04:539D; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 11 (tcrf_check/assets/l3_names/)
Src_27_76F0_Tbl539D_34::
    INCBIN "data/bank_27/Src_27_76F0_Tbl539D_34.bin" ; $76F0, 288 bytes
; C: target 37 of the {lo,hi,bank} table 04:539D; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code: target 37 of
; the stamp-category table 04:539D (Stamp_CatMapSrcTbl)
Src_27_7810_Tbl539D_37::
    INCBIN "data/bank_27/Src_27_7810_Tbl539D_37.bin" ; $7810, 288 bytes
; I: far pointer loaded by Mode12_State14_SaveDialogOpen (ld a,BANK; ld hl,ADDR; call banked copy/far call); length
; 288 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
Map_27_7930_Mode12_State14_SaveDialogOpen::
    db $c0, $c1, $c1, $c1, $c1, $c1, $c1, $c1, $c2, $c3, $c4, $c5, $c6, $c7, $c1, $c1
    db $c1, $c1, $c1, $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $c0, $fe, $fe, $fe, $fe, $fe, $c8, $c9, $ca, $cb, $cc, $cd, $ce, $fe, $fe, $fe
    db $fe, $fe, $fe, $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $c0, $fe, $fe, $fe, $fe, $fe, $cf, $d0, $d1, $d2, $d3, $d4, $d5, $fe, $fe, $fe
    db $fe, $fe, $fe, $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $c0, $fe, $fe, $fe, $fe, $fe, $fe, $d6, $d7, $d8, $d9, $db, $fe, $fe, $fe, $fe
    db $fe, $fe, $fe, $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $c0, $fe, $e4, $e5, $e6, $e7, $e8, $e9, $fe, $dc, $dd, $fe, $f0, $f1, $f2, $f3
    db $f4, $f5, $f6, $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $c0, $fe, $ea, $eb, $ec, $ed, $ee, $ef, $fe, $de, $df, $e0, $f7, $f8, $f9, $fa
    db $fb, $fc, $fd, $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $e1, $e2, $e3, $fe, $fe, $fe, $fe
    db $fe, $fe, $fe, $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $fe, $fe, $fe, $c0

    ; padding
    ds $2c, $fe

; C: far pointer loaded by Mode1A_State09_ExitDialog (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 288
; from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
Map_27_7A50_Mode1A_State09_ExitDialog::
    INCBIN "data/bank_27/Map_27_7A50_Mode1A_State09_ExitDialog.tilemap" ; $7A50, 128 bytes
; I: far pointer loaded by HotSpotEd_DialogChoiceB (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 64 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
Map_27_7AD0_HotSpotEd_DialogChoiceB::
    INCBIN "data/bank_27/Map_27_7AD0_HotSpotEd_DialogChoiceB.tilemap" ; $7AD0, 96 bytes
; I: far pointer loaded by HotSpotEd_DialogChoiceB, Mode1A_State09_ExitDialog (ld a,BANK; ld hl,ADDR; call banked
; copy/far call); length 64 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic
; corpus, modes 1A (tcrf_check/assets/l3_names/)
Map_27_7B30_Mode1A_State09_ExitDialog::
    INCBIN "data/bank_27/Map_27_7B30_Mode1A_State09_ExitDialog.tilemap" ; $7B30, 64 bytes
; C: far pointer loaded by Mode1A_State03_Browse (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 288 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
Map_27_7B70_Mode1A_State03_Browse::
    INCBIN "data/bank_27/Map_27_7B70_Mode1A_State03_Browse.tilemap" ; $7B70, 128 bytes
; C: far pointer loaded by HotSpotEd_DialogChoiceA (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 64 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
Map_27_7BF0_HotSpotEd_DialogChoiceA::
    INCBIN "data/bank_27/Map_27_7BF0_HotSpotEd_DialogChoiceA.tilemap" ; $7BF0, 96 bytes
; C: far pointer loaded by HotSpotEd_DialogChoiceA (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 64 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
Map_27_7C50_HotSpotEd_DialogChoiceA::
    INCBIN "data/bank_27/Map_27_7C50_HotSpotEd_DialogChoiceA.tilemap" ; $7C50, 64 bytes
; I: far pointer loaded by Mode12_State1A_ClearDialogOpen (ld a,BANK; ld hl,ADDR; call banked copy/far call); length
; 288 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 3 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
Map_27_7C90_Mode12_State1A_ClearDialogOpen::
    db $c0, $c1, $c1, $c1, $c1, $c1, $c1, $c1, $c1, $c2, $c3, $c4, $c1, $c1, $c1, $c1
    db $c1, $c1, $c1, $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $c0, $fe, $fe, $fe, $fe, $fe, $fe, $c5, $c6, $c7, $c8, $c9, $ca, $fe, $fe, $fe
    db $fe, $fe, $fe, $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $c0, $fe, $fe, $fe, $fe, $fe, $fe, $cb, $cc, $cd, $ce, $cf, $d0, $fe, $fe, $fe
    db $fe, $fe, $fe, $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $d1, $d2, $d3, $fe, $fe, $fe, $fe, $fe
    db $fe, $fe, $fe, $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $c0, $fe, $dd, $de, $df, $e0, $e1, $e2, $d4, $d5, $d6, $fe, $e9, $ea, $eb, $ec
    db $ed, $ee, $ef, $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $c0, $fe, $e3, $e4, $e5, $e6, $e7, $e8, $d7, $d8, $fe, $fe, $f0, $f1, $f2, $f3
    db $f4, $f5, $f6, $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $d9, $da, $fe, $fe, $fe, $fe, $fe, $fe
    db $fe, $fe, $fe, $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $c0, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $fe, $fe, $fe, $c0

    ; padding
    ds $2c, $fe

; I: copied to VRAM/WRAM by Mode1F_State08_EditPagesSetup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1F)
Map_27_7DB0_Mode1F_State08_EditPagesSetup::
    db $60, $61, $62, $63, $64, $65, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $66, $67, $68, $69, $6a, $6b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $8d, $8e, $8f, $9d, $9e, $9f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $3b, $3c, $3d, $3e, $fe, $ef, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $4b, $4c, $4d, $4e, $4f, $bd, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $fa, $fa, $fa, $fa, $fa, $fb, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

    ; padding
    ds $190, $00
