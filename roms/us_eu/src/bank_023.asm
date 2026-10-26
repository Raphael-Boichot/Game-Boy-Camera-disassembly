; Game Boy Camera (USA, Europe), bank $23. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $023", ROMX[$4000], BANK[$23]

; C: frame 9 of the staff-roll dancer (a dancing girl, not identified): {lo,hi,bank,duration} table 09:509C (13
; records, 12 frames each), 0x500 bytes copied alternately to $8000 / $8500 by Mode08_State15_CreditsScroll
Gfx_23_4000_CreditsGirlFrame09::
    INCBIN "data/bank_23/Gfx_23_4000_CreditsGirlFrame09.2bpp" ; $4000, 1216 bytes
; I: far pointer loaded by Mode06_State00_Init (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass 2026-10-26:
; read in BGB in 10 replay(s) of the organic corpus, modes 06 08 (tcrf_check/assets/l3_names/)
Map_23_44C0_Mode06_State00_Init::
    INCBIN "data/bank_23/Map_23_44C0_Mode06_State00_Init.tilemap" ; $44C0, 64 bytes
; I: copied to VRAM/WRAM by HotSpotEd_SoundList (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 9 replay(s) of the organic corpus, modes 06 (tcrf_check/assets/l3_names/)
Map_23_44C0_HotSpotEd_SoundList_Part4500::
    INCBIN "data/bank_23/Map_23_44C0_HotSpotEd_SoundList_Part4500.tilemap" ; $4500, 960 bytes
; I: copied to VRAM/WRAM by Mode13_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not reached
; by the 206 BGB replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first
; read in mode 13)
Map_23_48C0_Mode13_State00_Init::
    INCBIN "data/bank_23/Map_23_48C0_Mode13_State00_Init.tilemap" ; $48C0, 288 bytes
; I: far pointer loaded by Mode13_State02_Start (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 13)
Map_23_49E0_Mode13_State02_Start::
    INCBIN "data/bank_23/Map_23_49E0_Mode13_State02_Start.tilemap" ; $49E0, 288 bytes
; I: far pointer loaded by Mode13_State02_Start (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 96 from the
; nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 13)
Map_23_4B00_Mode13_State02_Start::
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf

    ; padding
    ds $160, $00

; I: copied to VRAM/WRAM by Mode20_State09_ResultInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 1 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Map_23_4CC0_Mode20_State09_ResultInit::
    INCBIN "data/bank_23/Map_23_4CC0_Mode20_State09_ResultInit.tilemap" ; $4CC0, 1024 bytes
; I: copied to VRAM/WRAM by Mode16_State08_StartShoot (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not
; reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 14)
Gfx_23_50C0_Mode16_State08_StartShoot::
    INCBIN "data/bank_23/Gfx_23_50C0_Mode16_State08_StartShoot.2bpp" ; $50C0, 656 bytes
; I: copied to VRAM/WRAM by Mode16_State08_StartShoot (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not
; reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 14)
Gfx_23_5350_Mode16_State08_StartShoot::
    db $00, $00, $03, $03, $0f, $0f, $1f, $1e, $3e, $3f, $3d, $3e, $7d, $7b, $79, $7f
    db $00, $00, $e0, $e0, $f8, $f8, $7c, $bc, $3e, $fe, $de, $be, $df, $ef, $cf, $ff
    db $00, $00, $00, $00, $7f, $7f, $4c, $7f, $4c, $7f, $4c, $7f, $6d, $5e, $61, $7f
    db $00, $00, $00, $00, $ff, $ff, $83, $ff, $83, $fe, $9e, $ff, $9e, $ff, $9f, $fe
    db $00, $00, $00, $00, $f8, $f8, $88, $78, $08, $f8, $78, $f8, $70, $f0, $38, $d8
    db $00, $00, $07, $07, $1f, $1f, $30, $3f, $77, $78, $77, $7b, $f7, $fb, $f7, $f8
    db $00, $00, $c0, $c0, $f1, $f1, $79, $b9, $bd, $5d, $dd, $bd, $df, $bf, $bf, $5f
    db $00, $00, $00, $00, $de, $de, $33, $ff, $33, $ff, $33, $df, $13, $ff, $13, $ef
    db $00, $00, $00, $00, $fc, $fc, $ce, $b6, $86, $7a, $32, $fe, $32, $fe, $32, $fe
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $7b, $74, $70, $7f, $37, $2b, $2f, $37, $1f, $1f, $0f, $0f, $03, $03, $00, $00
    db $ef, $17, $07, $ff, $f6, $ea, $fa, $f6, $fc, $fc, $f8, $f8, $e0, $e0, $00, $00
    db $33, $2d, $33, $3f, $13, $1f, $13, $1f, $13, $1f, $13, $1f, $1f, $1f, $00, $00
    db $87, $ff, $87, $ff, $9f, $ff, $9f, $ff, $82, $ff, $82, $ff, $ff, $ff, $00, $00
    db $98, $68, $c8, $f8, $c8, $f8, $c8, $f8, $18, $e8, $38, $d8, $f0, $f0, $00, $00
    db $f0, $ff, $f7, $fb, $77, $7b, $77, $78, $30, $3f, $1f, $1f, $07, $07, $00, $00
    db $1f, $ef, $cf, $ff, $cd, $fd, $dd, $2d, $39, $d9, $f1, $f1, $c1, $c1, $00, $00
    db $03, $ff, $23, $df, $23, $ff, $33, $ef, $33, $ff, $33, $ff, $fe, $fe, $00, $00
    db $32, $fe, $32, $fe, $32, $fe, $32, $fe, $86, $7a, $ce, $b6, $fc, $fc, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $30, $00

; C: copied to VRAM/WRAM by Mode0F_State05_ConfirmInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 33 replay(s) of the organic corpus, modes 0F (tcrf_check/assets/l3_names/)
Map_23_54C0_Mode0F_State05_ConfirmInit::
    INCBIN "data/bank_23/Map_23_54C0_Mode0F_State05_ConfirmInit.tilemap" ; $54C0, 1024 bytes
; I: 1024 bytes = a 32 x 32 map whose only non-zero tiles are columns 0-1 of rows 0-17: aa 90 / 9c ab, 14 rows of 98
; 99 / a8 a9, 9b 91 / a0 90; these are the right-border tiles of the photo frame in the map 23:54C0 (its columns
; 20-21, rows 2-19, which Mode0F_State05_ConfirmInit copies to $9800); no code ...
Map_23_58C0_Mode0F_ConfirmFrameStrip_Unref::
    INCBIN "data/bank_23/Map_23_58C0_Mode0F_ConfirmFrameStrip_Unref.tilemap" ; $58C0, 1024 bytes
; C: map (tile indices) of the alternate link-exchange stand-by screen whose tiles are 14:4000: 18 rows x 32 columns
; (576 B) + 4 trailing $16 bytes; ids index 14:4000 directly; columns 0-19 = the visible 20x18 screen (print +
; 'アイデアがいっぱい' + 任天堂), 20-27 = $0F, 28-31 = $16; drawn by ...
Map_23_5CC0_Mode0E_ExchangeAlt_Unref::
    INCBIN "data/bank_23/Map_23_5CC0_Mode0E_ExchangeAlt_Unref.tilemap" ; $5CC0, 1024 bytes
; I: far pointer loaded by Mode1A_State09_ExitDialog (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 1024
; from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
Gfx_23_60C0_Mode1A_State09_ExitDialog::
    db $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $ff, $ff, $00, $00, $00, $00, $00, $07, $01, $06, $00, $01, $00, $00, $00, $00
    db $ff, $ff, $00, $00, $00, $00, $0c, $9c, $0e, $72, $16, $8a, $1a, $66, $1b, $1d
    db $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
    db $00, $00, $00, $07, $02, $04, $07, $07, $01, $02, $01, $02, $01, $02, $01, $02
    db $06, $07, $01, $ff, $3c, $03, $ff, $ff, $2e, $ff, $5b, $ae, $5b, $ae, $1b, $ae
    db $40, $c0, $40, $c0, $c0, $c0, $00, $80, $00, $80, $00, $80, $00, $80, $00, $80
    db $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $00, $01, $00, $00, $00, $00
    db $1b, $ae, $1b, $ae, $1b, $ae, $1b, $ae, $5a, $af, $3f, $ff, $00, $ff, $00, $0f
    db $00, $80, $00, $80, $00, $80, $00, $80, $80, $80, $00, $f0, $00, $f8, $00, $f0
    db $00, $00, $00, $00, $00, $00, $07, $0f, $04, $0f, $04, $0c, $04, $0c, $04, $0c
    db $00, $00, $00, $00, $00, $00, $e1, $c3, $31, $e3, $11, $33, $11, $33, $11, $33
    db $00, $00, $00, $00, $00, $00, $f8, $f9, $00, $f9, $00, $01, $f8, $f9, $00, $f9
    db $00, $00, $00, $00, $00, $00, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
    db $00, $00, $00, $00, $00, $00, $7e, $fe, $40, $fe, $40, $c0, $7e, $fe, $40, $fe
    db $00, $00, $00, $00, $00, $00, $7e, $fe, $10, $fe, $10, $18, $10, $18, $10, $18
    db $00, $00, $00, $00, $00, $00, $7e, $fe, $40, $fe, $40, $c0, $7e, $fe, $40, $fe
    db $00, $00, $00, $00, $00, $00, $0e, $1f, $11, $3f, $10, $31, $30, $01, $07, $03
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $80, $80, $80, $80, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $04, $0c, $07, $0c, $07, $0f, $0f, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $11, $33, $f1, $23, $e1, $c3, $c3, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $01, $f8, $01, $f8, $f9, $f9, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $80, $80, $fc, $80, $fc, $fc, $fc, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $40, $c0, $7e, $c0, $7e, $fe, $fe, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $10, $18, $10, $18, $10, $18, $18, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $40, $c0, $7e, $c0, $7e, $fe, $fe, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $04, $06, $04, $00, $04, $06, $06, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $87, $c2, $42, $c6, $44, $66, $28, $3c, $10, $18
    db $00, $00, $00, $00, $00, $00, $7e, $fe, $40, $fe, $40, $c0, $40, $c0, $7e, $fe
    db $00, $00, $00, $00, $00, $00, $3e, $7c, $42, $fe, $42, $c6, $e0, $40, $3e, $7c
    db $10, $18, $10, $18, $10, $18, $10, $18, $18, $00, $00, $00, $00, $00, $00, $00
    db $40, $fe, $40, $c0, $7e, $c0, $7e, $fe, $fe, $00, $00, $00, $00, $00, $00, $00
    db $22, $1e, $02, $02, $7e, $c2, $bc, $7e, $3c, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $62, $c6, $62, $e6, $72, $e6, $52, $f6, $5a, $d6
    db $00, $00, $00, $00, $00, $00, $0f, $1f, $10, $3f, $10, $31, $10, $31, $10, $31
    db $00, $00, $00, $00, $00, $00, $80, $00, $80, $80, $80, $80, $80, $80, $80, $80
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $4a, $de, $4a, $ce, $46, $ce, $46, $c6, $c6, $00, $00, $00, $00, $00, $00, $00
    db $10, $31, $10, $31, $1e, $31, $2f, $1f, $0f, $00, $00, $00, $00, $00, $00, $00
    db $80, $80, $80, $80, $80, $80, $00, $80, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $ff, $ff, $80, $80, $81, $81, $7f, $7f, $03, $03, $05, $05
    db $00, $00, $7c, $7c, $83, $83, $80, $80, $10, $10, $10, $10, $30, $30, $c8, $c8
    db $00, $00, $00, $00, $00, $00, $b0, $b0, $48, $48, $48, $48, $08, $08, $08, $08
    db $04, $04, $03, $03, $02, $02, $02, $02, $01, $01, $00, $00, $00, $00, $00, $00
    db $0e, $0e, $f5, $f5, $06, $06, $1a, $1a, $e4, $e4, $8f, $8f, $70, $70, $00, $00
    db $08, $08, $88, $88, $08, $08, $48, $48, $b0, $b0, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $0d, $0d, $12, $12, $12, $12, $10, $10, $10, $10
    db $00, $00, $3e, $3e, $c1, $c1, $01, $01, $08, $08, $08, $08, $0c, $0c, $13, $13
    db $00, $00, $00, $00, $ff, $ff, $01, $01, $81, $81, $fe, $fe, $c0, $c0, $a0, $a0
    db $10, $10, $11, $11, $10, $10, $12, $12, $0d, $0d, $00, $00, $00, $00, $00, $00
    db $70, $70, $af, $af, $60, $60, $58, $58, $27, $27, $f1, $f1, $0e, $0e, $00, $00
    db $20, $20, $c0, $c0, $40, $40, $40, $40, $80, $80, $00, $00, $00, $00, $00, $00
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $ff, $ff

    ; padding
    ds $4e, $00

; I: copied to VRAM/WRAM by Mode03_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 23 replay(s) of the organic corpus, modes 03 (tcrf_check/assets/l3_names/)
Map_23_64C0_Mode03_State00_Init::
    INCBIN "data/bank_23/Map_23_64C0_Mode03_State00_Init.tilemap" ; $64C0, 32 bytes
; I: far pointer loaded by SpecialMenu_DrawCursor (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 23 replay(s) of the organic corpus, modes 03 1A (tcrf_check/assets/l3_names/)
Map_23_64E0_SpecialMenu_DrawCursor::
    INCBIN "data/bank_23/Map_23_64E0_SpecialMenu_DrawCursor.tilemap" ; $64E0, 544 bytes
; I: far pointer loaded by SpecialMenu_DrawCursor (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 224 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 20 replay(s) of the organic corpus, modes 03 17
; (tcrf_check/assets/l3_names/)
Map_23_6700_SpecialMenu_DrawCursor::
    INCBIN "data/bank_23/Map_23_6700_SpecialMenu_DrawCursor.tilemap" ; $6700, 224 bytes
; I: far pointer loaded by SpecialMenu_DrawCursor (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 224 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 23 replay(s) of the organic corpus, modes 03 17 1A
; (tcrf_check/assets/l3_names/)
Map_23_67E0_SpecialMenu_DrawCursor::
    INCBIN "data/bank_23/Map_23_67E0_SpecialMenu_DrawCursor.tilemap" ; $67E0, 224 bytes
; C: copied to VRAM/WRAM by Mode1F_State08_EditPagesSetup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1F)
Map_23_68C0_Mode1F_State08_EditPagesSetup::
    INCBIN "data/bank_23/Map_23_68C0_Mode1F_State08_EditPagesSetup.tilemap" ; $68C0, 64 bytes
; C: far pointer loaded by Mode1F_State0B_PageNoise (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1F)
Map_23_6900_Mode1F_State0B_PageNoise::
    INCBIN "data/bank_23/Map_23_6900_Mode1F_State0B_PageNoise.tilemap" ; $6900, 512 bytes
; C: far pointer loaded by Mode1F_State09_PageSound1 (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1F)
Map_23_6B00_Mode1F_State09_PageSound1::
    INCBIN "data/bank_23/Map_23_6B00_Mode1F_State09_PageSound1.tilemap" ; $6B00, 128 bytes
; C: far pointer loaded by Mode1F_State0A_PageSound2 (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 128
; from the nearby ld bc. L3 pass 2026-10-26: read in BGB in the scenarios dj_perf_start_noise 1F:0A, dj_print_noise
; 1F:0A (tcrf_check/assets/l3_names/scen_hits*.csv)
Map_23_6B80_Mode1F_State0A_PageSound2::
    INCBIN "data/bank_23/Map_23_6B80_Mode1F_State0A_PageSound2.tilemap" ; $6B80, 128 bytes
; C: far pointer loaded by Mode1F_State0A_PageSound2 (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 128
; from the nearby ld bc. L3 pass 2026-10-26: read in BGB in the scenarios dj_perf_start_noise 1F:0A, dj_print_noise
; 1F:0A (tcrf_check/assets/l3_names/scen_hits*.csv)
Map_23_6C00_Mode1F_State0A_PageSound2::
    INCBIN "data/bank_23/Map_23_6C00_Mode1F_State0A_PageSound2.tilemap" ; $6C00, 128 bytes
; C: frame 12 of the staff-roll dancer (a dancing girl, not identified): {lo,hi,bank,duration} table 09:509C (13
; records, 12 frames each), 0x500 bytes copied alternately to $8000 / $8500 by Mode08_State15_CreditsScroll | the real
; tile data stops at 23:7040 (the parlor map starts there): ...
Gfx_23_6C80_CreditsGirlFrame12::
    INCBIN "data/bank_23/Gfx_23_6C80_CreditsGirlFrame12.2bpp" ; $6C80, 960 bytes
; I: map of page 1 of the SHOOT parlor (04:744E list): 18 rows of 32 bytes (0x240 up to 23:7280); Parlor_LoadPage
; (04:73EF) ends each page list ($FF) with {lo,hi,bank} stored in $D7D9-$D7DB, which Parlor_SpiralWipeIn (04:7479)
; hands to Map_SpiralWipeIn (00:0DA0); the coverage shows columns 0-19 of 18 ...
Map_23_7040_Parlor_Page1::
    INCBIN "data/bank_23/Map_23_7040_Parlor_Page1.tilemap" ; $7040, 576 bytes
; C: 0x160 bytes (11 rows): second entry of Parlor_AnimateB_PtrTbl7372, copied from bank $23 to $9800 by
; Parlor_AnimateB (04:7366) every 20 frames, alternating with the first 11 rows of 23:7040; only 4 tiles of row 0
; differ ($D7-$DA instead of $D4-$D1): a blink of the face
Map_23_7280_Parlor_Page1_AltTopRows::
    INCBIN "data/bank_23/Map_23_7280_Parlor_Page1_AltTopRows.tilemap" ; $7280, 352 bytes
; I: copied to VRAM/WRAM by Mode08_State06_EditorInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 4 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Map_23_73E0_Mode08_State06_EditorInit::
    INCBIN "data/bank_23/Map_23_73E0_Mode08_State06_EditorInit.tilemap" ; $73E0, 192 bytes
; I: far pointer loaded by Kb_Page1_PressSex (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass 2026-10-26:
; read in BGB in 4 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Map_23_74A0_Kb_Page1_PressSex::
    INCBIN "data/bank_23/Map_23_74A0_Kb_Page1_PressSex.tilemap" ; $74A0, 384 bytes
; C: far pointer loaded by Kb_Page0_Press, Kb_Page2_PressBirthDate (ld a,BANK; ld hl,ADDR; call banked copy/far call);
; length 320 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 3 replay(s) of the organic corpus, modes 08
; (tcrf_check/assets/l3_names/)
Map_23_7620_Kb_Page0_Press::
    INCBIN "data/bank_23/Map_23_7620_Kb_Page0_Press.tilemap" ; $7620, 320 bytes
; I: one row of 32: 20 descending tile ids $36-$23 then $FF x 4...; the 11th row of the map 23:7620 (Kb_Page0_Press
; copies 0x140 = 10 rows to $98C0): not copied; was Data_23_7760
Map_23_7760_Kb_Page0_Press_ExtraRow::
    INCBIN "data/bank_23/Map_23_7760_Kb_Page0_Press_ExtraRow.tilemap" ; $7760, 32 bytes
; I: copied to VRAM/WRAM by Mode0E_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 2 replay(s) of the organic corpus, modes 0E (tcrf_check/assets/l3_names/)
Map_23_7780_Mode0E_State00_Init::
    INCBIN "data/bank_23/Map_23_7780_Mode0E_State00_Init.tilemap" ; $7780, 32 bytes
; I: far pointer loaded by Mode0E_State00_Init, Link_DrawPressAText, Link_AnimateStep3, Link_ChooseSendReceive (ld
; a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass 2026-10-26: read in BGB in 2 replay(s) of the organic
; corpus, modes 0E (tcrf_check/assets/l3_names/)
Map_23_77A0_Mode0E_State00_Init::
    INCBIN "data/bank_23/Map_23_77A0_Mode0E_State00_Init.tilemap" ; $77A0, 544 bytes
; I: far pointer loaded by Mode0E_State00_Init, Link_DrawPressAText, Link_AnimateStep3, Link_ChooseSendReceive (ld
; a,BANK; ld hl,ADDR; call banked copy/far call); length 160 from the nearby ld bc. L3 pass 2026-10-26: not reached by
; the 206 BGB replays; read in the organic runs of the core emulator ...
Map_23_79C0_Mode0E_State00_Init::
    INCBIN "data/bank_23/Map_23_79C0_Mode0E_State00_Init.tilemap" ; $79C0, 160 bytes
; I: far pointer loaded by Link_AnimateStep3, Link_DrawPressAText (ld a,BANK; ld hl,ADDR; call banked copy/far call);
; length 160 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 0E
; (tcrf_check/assets/l3_names/)
Map_23_7A60_Link_DrawPressAText::
    INCBIN "data/bank_23/Map_23_7A60_Link_DrawPressAText.tilemap" ; $7A60, 160 bytes
; C: copied to VRAM/WRAM by Mode0B_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not reached
; by the 206 BGB replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first
; read in mode 0B)
Map_23_7B00_Mode0B_State00_Init::
    INCBIN "data/bank_23/Map_23_7B00_Mode0B_State00_Init.tilemap" ; $7B00, 256 bytes
; C: far pointer loaded by ShowMenu_LoadNormalTiles (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 01 03 0B)
Map_23_7C00_ShowMenu_LoadNormalTiles::
    INCBIN "data/bank_23/Map_23_7C00_ShowMenu_LoadNormalTiles.tilemap" ; $7C00, 352 bytes
; C: far pointer loaded by ShowMenu_LoadHighlightTiles (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 96
; from the nearby ld bc | item 0 of 3: ShowMenu_LoadHighlightTiles (03:7A62) copies 0x60 bytes (3 map rows) from $7D60
; + 0x60 x item ([$D5EF] = 0-2) to the BG map at $9900 + 0x60 x item ...
Map_23_7D60_ShowMenu_LoadHighlightTiles::
    INCBIN "data/bank_23/Map_23_7D60_ShowMenu_LoadHighlightTiles.tilemap" ; $7D60, 96 bytes
; C: item 1 of 3 highlighted menu strips (3 map rows of 32, 0x60 bytes): ShowMenu_LoadHighlightTiles (03:7A62) copies
; $7D60 + 0x60 x item to $9900 + 0x60 x item through Vram_CopyFromBank (copy site 03:7A80), item = [$D5EF] limited to
; 0-2 by the cp $02 test of the caller (03:7A48); 7DC0-7E1F; was ...
Map_23_7DC0_ShowMenu_LoadHighlightTiles_Item1::
    INCBIN "data/bank_23/Map_23_7DC0_ShowMenu_LoadHighlightTiles_Item1.tilemap" ; $7DC0, 96 bytes
; C: item 2 of 3 highlighted menu strips (3 map rows of 32, 0x60 bytes) 7E20-7E7F, same loader as Map_23_7D60 /
; Map_23_7DC0 (ShowMenu_LoadHighlightTiles, 03:7A62)
Map_23_7E20_ShowMenu_LoadHighlightTiles_Item2::
    INCBIN "data/bank_23/Map_23_7E20_ShowMenu_LoadHighlightTiles_Item2.tilemap" ; $7E20, 96 bytes
; I: target 3 of the {lo,hi,bank} table 07:53A6; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: read in BGB in 34 replay(s) of the organic corpus, modes 02 (tcrf_check/assets/l3_names/)
Src_23_7E80_Tbl53A6_3::
    INCBIN "data/bank_23/Src_23_7E80_Tbl53A6_3.bin" ; $7E80, 384 bytes
