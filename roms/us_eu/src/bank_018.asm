; Game Boy Camera (USA, Europe), bank $18. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $018", ROMX[$4000], BANK[$18]

; C: copied to VRAM/WRAM by Mode05_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 32 replay(s) of the organic corpus, modes 05 (tcrf_check/assets/l3_names/)
Gfx_18_4000_Mode05_State00_Init::
    INCBIN "data/bank_18/Gfx_18_4000_Mode05_State00_Init.2bpp" ; $4000, 2048 bytes
; C: copied to VRAM/WRAM by Mode05_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 32 replay(s) of the organic corpus, modes 05 (tcrf_check/assets/l3_names/)
Gfx_18_4800_Mode05_State00_Init::
    INCBIN "data/bank_18/Gfx_18_4800_Mode05_State00_Init.2bpp" ; $4800, 2048 bytes
; I: copied to VRAM/WRAM by Mode05_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 32 replay(s) of the organic corpus, modes 05 (tcrf_check/assets/l3_names/)
Gfx_18_5000_Mode05_State00_Init::
    INCBIN "data/bank_18/Gfx_18_5000_Mode05_State00_Init.2bpp" ; $5000, 1136 bytes
; I: copied to VRAM/WRAM by Mode1E_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 1 replay(s) of the organic corpus, modes 1E (tcrf_check/assets/l3_names/)
Gfx_18_5470_Mode1E_State00_Init::
    INCBIN "data/bank_18/Gfx_18_5470_Mode1E_State00_Init.2bpp" ; $5470, 1504 bytes
; I: TCRF unused graphic: film roll with a B for the margin-print option (6 tiles); loaded with the option screen but
; never stably on screen (README 16.24). L3 pass 2026-10-26: copied to VRAM with the block around it (read in BGB in 1
; replay(s) of the organic corpus, modes 1E) but never displayed, as ...
Unused_TCRF_MarginPrint_BFilmRoll_Gfx::
    INCBIN "data/bank_18/Unused_TCRF_MarginPrint_BFilmRoll_Gfx.2bpp" ; $5A50, 96 bytes
; I: continues the span of Gfx_18_5470_Mode1C_DrawOptionScreen (the label before the TCRF-unused block). L3 pass
; 2026-10-26: read in BGB in 1 replay(s), modes 1E (states 1E:00), not only by the consumer the name gives: a shared
; asset or table; first organic loader in the core: 08:48C5
Gfx_18_5AB0_Mode1C_DrawOptionScreen_Cont::
    INCBIN "data/bank_18/Gfx_18_5AB0_Mode1C_DrawOptionScreen_Cont.2bpp" ; $5AB0, 448 bytes
; I: copied to VRAM/WRAM by Mode1E_State00_Init, Print_LoadDigitTile (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass
; 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 1E (tcrf_check/assets/l3_names/)
Gfx_18_5C70_Mode1E_State00_Init::
    INCBIN "data/bank_18/Gfx_18_5C70_Mode1E_State00_Init.2bpp" ; $5C70, 800 bytes
; I: TCRF unused graphic: outlined Japanese text of the margin-print option (12 tiles); never stably on screen (README
; 16.24). L3 pass 2026-10-26: copied to VRAM with the block around it (read in BGB in 1 replay(s) of the organic
; corpus, modes 1E) but never displayed, as TCRF says; the verdict stays ...
Unused_TCRF_MarginPrint_OutlinedText_Gfx::
    INCBIN "data/bank_18/Unused_TCRF_MarginPrint_OutlinedText_Gfx.2bpp" ; $5F90, 192 bytes
; C: continues the span of Gfx_18_5C70_Mode1C_DrawOptionScreen (the label before the TCRF-unused block). L3 pass
; 2026-10-26: read in BGB in 1 replay(s), modes 1E (states 1E:00), not only by the consumer the name gives: a shared
; asset or table; first organic loader in the core: 08:48D3
Gfx_18_6050_Mode1C_DrawOptionScreen_Cont::
    INCBIN "data/bank_18/Gfx_18_6050_Mode1C_DrawOptionScreen_Cont.2bpp" ; $6050, 1056 bytes
; I: copied to VRAM/WRAM by Mode1B_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 9 replay(s) of the organic corpus, modes 1B (tcrf_check/assets/l3_names/)
Gfx_18_6470_Mode1B_State00_Init::
    INCBIN "data/bank_18/Gfx_18_6470_Mode1B_State00_Init.2bpp" ; $6470, 2048 bytes
; I: copied to VRAM/WRAM by Mode1B_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 9 replay(s) of the organic corpus, modes 1B (tcrf_check/assets/l3_names/)
Gfx_18_6C70_Mode1B_State00_Init::
    INCBIN "data/bank_18/Gfx_18_6C70_Mode1B_State00_Init.2bpp" ; $6C70, 1936 bytes
; C: far pointer loaded by Mode1C_DrawOptionScreen, Mode1C_State02_ShowPrintScreen (ld a,BANK; ld hl,ADDR; call banked
; copy/far call). L3 pass 2026-10-26: read in BGB in 18 replay(s) of the organic corpus, modes 1B 1C
; (tcrf_check/assets/l3_names/)
Gfx_18_7400_Mode1C_State02_ShowPrintScreen::
    INCBIN "data/bank_18/Gfx_18_7400_Mode1C_State02_ShowPrintScreen.2bpp" ; $7400, 112 bytes
; I: copied to VRAM/WRAM by Mode1C_State02_ShowPrintScreen (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in 9 replay(s) of the organic corpus, modes 1C (tcrf_check/assets/l3_names/)
Gfx_18_7400_Mode1C_State02_ShowPrintScreen_Part7470::
    INCBIN "data/bank_18/Gfx_18_7400_Mode1C_State02_ShowPrintScreen_Part7470.2bpp" ; $7470, 1168 bytes
; I: far pointer loaded by Mode1C_LoadToggleTiles (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 192 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 1C
; (tcrf_check/assets/l3_names/)
Gfx_18_7900_Mode1C_LoadToggleTiles::
    INCBIN "data/bank_18/Gfx_18_7900_Mode1C_LoadToggleTiles.2bpp" ; $7900, 192 bytes
; I: far pointer loaded by Mode1C_LoadToggleTiles (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 192 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 1C
; (tcrf_check/assets/l3_names/)
Gfx_18_79C0_Mode1C_LoadToggleTiles::
    INCBIN "data/bank_18/Gfx_18_79C0_Mode1C_LoadToggleTiles.2bpp" ; $79C0, 192 bytes
; C: copied to VRAM/WRAM by Mode1C_State02_ShowPrintScreen, Mode1C_State04_OptionsMenu
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 9 replay(s) of the organic corpus, modes
; 1C (tcrf_check/assets/l3_names/)
Gfx_18_7A80_Mode1C_State02_ShowPrintScreen::
    INCBIN "data/bank_18/Gfx_18_7A80_Mode1C_State02_ShowPrintScreen.2bpp" ; $7A80, 128 bytes
; I: copied to VRAM/WRAM by Mode1C_State02_ShowPrintScreen (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in 9 replay(s) of the organic corpus, modes 1C (tcrf_check/assets/l3_names/)
Gfx_18_7B00_Mode1C_State02_ShowPrintScreen::
    INCBIN "data/bank_18/Gfx_18_7B00_Mode1C_State02_ShowPrintScreen.2bpp" ; $7B00, 160 bytes
; I: copied to VRAM/WRAM by Mode0E_State04_PickDone, Mode0E_State0D_PickSecond (roms/jp_rev_a/assets/catalog_jp.csv).
; L3 pass 2026-10-26: read in BGB in the scenarios link_exchange 0E:04 (tcrf_check/assets/l3_names/scen_hits*.csv)
Gfx_18_7BA0_Mode0E_State04_PickDone::
    INCBIN "data/bank_18/Gfx_18_7BA0_Mode0E_State04_PickDone.2bpp" ; $7BA0, 160 bytes
; I: copied to VRAM/WRAM by Mode0F_State05_ConfirmInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 33 replay(s) of the organic corpus, modes 0F (tcrf_check/assets/l3_names/)
Gfx_18_7C40_Mode0F_State05_ConfirmInit::
    INCBIN "data/bank_18/Gfx_18_7C40_Mode0F_State05_ConfirmInit.2bpp" ; $7C40, 288 bytes
; I: copied to VRAM/WRAM by Mode0F_State05_ConfirmInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 33 replay(s) of the organic corpus, modes 0F (tcrf_check/assets/l3_names/)
Gfx_18_7D60_Mode0F_State05_ConfirmInit::
    INCBIN "data/bank_18/Gfx_18_7D60_Mode0F_State05_ConfirmInit.2bpp" ; $7D60, 32 bytes
; C: tile data with no direct pointer in the code (, same bank/neighbour of Mode0F_State04_LeaveSelected); classified
; from its content - see sym_unconclusive. Owner (review page, 2026-10-13): graphic, by eye.
Gfx_18_7D80_Mode0F_State04_LeaveSelected_Aux::
    INCBIN "data/bank_18/Gfx_18_7D80_Mode0F_State04_LeaveSelected_Aux.2bpp" ; $7D80, 256 bytes
; I: copied to VRAM/WRAM by Mode0F_State05_ConfirmInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 33 replay(s) of the organic corpus, modes 0F (tcrf_check/assets/l3_names/)
Gfx_18_7E80_Mode0F_State05_ConfirmInit::
    INCBIN "data/bank_18/Gfx_18_7E80_Mode0F_State05_ConfirmInit.2bpp" ; $7E80, 224 bytes
; I: copied to VRAM/WRAM by Mode1C_State02_ShowPrintScreen, Mode1C_DrawPrintScreen
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 9 replay(s) of the organic corpus, modes
; 1C (tcrf_check/assets/l3_names/)
Gfx_18_7F60_Mode1C_State02_ShowPrintScreen::
    db $0f, $0f, $3f, $38, $7f, $60, $7f, $40, $ff, $c5, $ff, $80, $ff, $80, $ff, $9a
    db $f0, $f0, $fc, $1c, $fe, $06, $fe, $02, $ff, $b3, $ff, $01, $ff, $01, $ff, $a9
    db $ff, $80, $ff, $80, $ff, $cb, $7f, $40, $7f, $60, $3f, $30, $3f, $3e, $7f, $67
    db $ff, $01, $ff, $01, $ff, $51, $ff, $03, $fe, $02, $fe, $06, $fc, $3c, $e0, $e0
    db $7e, $42, $7e, $66, $3e, $3e, $1e, $12, $1e, $12, $1f, $1f, $07, $05, $07, $07

    ; padding
    ds $50, $00
