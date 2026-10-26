; Pocket Camera (Japan) (Rev A), bank $23. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $023", ROMX[$4000], BANK[$23]

; C: frame 9 of the staff-roll dancer (a dancing girl, not identified): {lo,hi,bank,duration} table 09:509C (13
; records, 12 frames each), 0x500 bytes copied alternately to $8000 / $8500 by Mode08_State15_CreditsScroll
Gfx_23_4000_CreditsGirlFrame09::
    INCBIN "data/bank_23/Gfx_23_4000_CreditsGirlFrame09.2bpp" ; $4000, 1216 bytes
; C: far pointer loaded by Mode06_State00_Init (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass 2026-10-26:
; read in BGB in 10 replay(s) of the organic corpus, modes 06 08 (tcrf_check/assets/l3_names/)
Map_23_44C0_Mode06_State00_Init::
    INCBIN "data/bank_23/Map_23_44C0_Mode06_State00_Init.tilemap" ; $44C0, 64 bytes
; C: copied to VRAM/WRAM by HotSpotEd_SoundList (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 9 replay(s) of the organic corpus, modes 06 (tcrf_check/assets/l3_names/)
Map_23_44C0_HotSpotEd_SoundList_Part4500::
    INCBIN "data/bank_23/Map_23_44C0_HotSpotEd_SoundList_Part4500.tilemap" ; $4500, 960 bytes
; C: copied to VRAM/WRAM by Mode13_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not reached
; by the 206 BGB replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first
; read in mode 13)
Map_23_48C0_Mode13_State00_Init::
    INCBIN "data/bank_23/Map_23_48C0_Mode13_State00_Init.tilemap" ; $48C0, 288 bytes
; C: far pointer loaded by Mode13_State02_Start (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 13)
Map_23_49E0_Mode13_State02_Start::
    INCBIN "data/bank_23/Map_23_49E0_Mode13_State02_Start.tilemap" ; $49E0, 288 bytes
; C: far pointer loaded by Mode13_State02_Start (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 96 from the
; nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 13)
Map_23_4B00_Mode13_State02_Start::
    db $91, $91, $91, $35, $34, $33, $32, $31, $30, $b2, $b3, $b4, $2c, $2b, $2a, $29, $03, $02, $01, $69, $ba, $ba, $ba, $ba, $ba, $ba, $ba, $ba, $ba, $ba, $ba, $ba
    db $94, $90, $91, $28, $27, $26, $25, $24, $23, $ba, $b5, $b6, $1f, $1e, $1d, $1c, $00, $91, $91, $66, $ba, $ba, $ba, $ba, $ba, $ba, $ba, $ba, $ba, $ba, $ba, $ba
    db $93, $82, $91, $95, $96, $97, $98, $99, $9a, $b7, $b8, $b9, $9e, $9f, $a0, $a1, $a2, $94, $90, $91, $ba, $ba, $ba, $ba, $ba, $ba, $ba, $ba, $ba, $ba, $ba, $ba

    ; padding
    ds $160, $00

; C: copied to VRAM/WRAM by Mode20_State09_ResultInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 1 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Map_23_4CC0_Mode20_State09_ResultInit::
    INCBIN "data/bank_23/Map_23_4CC0_Mode20_State09_ResultInit.tilemap" ; $4CC0, 1024 bytes
; C: copied to VRAM/WRAM by Mode16_State08_StartShoot (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not
; reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 14)
Gfx_23_50C0_Mode16_State08_StartShoot::
    INCBIN "data/bank_23/Gfx_23_50C0_Mode16_State08_StartShoot.2bpp" ; $50C0, 656 bytes
; C: copied to VRAM/WRAM by Mode16_State08_StartShoot (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not
; reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 14)
Gfx_23_5350_Mode16_State08_StartShoot::
    db $00, $00, $03, $03, $0f, $0f, $1f, $1e, $3e, $3f, $3e, $3d, $7d, $7b, $7d, $7b
    db $00, $00, $e0, $e0, $f8, $f8, $7c, $bc, $be, $7e, $be, $de, $df, $ef, $df, $ef
    db $00, $00, $3b, $3b, $6c, $5f, $6c, $5f, $60, $5f, $6c, $53, $6e, $5d, $6e, $5d
    db $00, $00, $18, $18, $fd, $e5, $ee, $f7, $6e, $b7, $6f, $96, $ef, $de, $ef, $df
    db $00, $00, $00, $00, $80, $80, $c0, $40, $40, $c0, $40, $c0, $60, $a0, $60, $a0
    db $00, $00, $07, $07, $1f, $1f, $38, $37, $7b, $74, $7b, $77, $fb, $f7, $f8, $f7
    db $00, $00, $c0, $c0, $f0, $f0, $78, $b8, $bc, $5c, $dd, $bd, $df, $bf, $3f, $df
    db $00, $00, $60, $60, $f6, $96, $bb, $dd, $b9, $df, $bd, $5b, $bd, $7a, $bd, $7e
    db $00, $00, $60, $60, $f6, $96, $bb, $dd, $b9, $df, $bd, $5b, $bd, $7a, $bd, $7e
    db $00, $00, $7c, $7c, $86, $fa, $82, $fe, $fc, $f4, $c2, $be, $92, $ee, $f6, $fa
    db $78, $77, $7b, $74, $37, $2b, $37, $2f, $1f, $1f, $0f, $0f, $03, $03, $00, $00
    db $0f, $f7, $ef, $17, $f6, $ea, $f6, $fa, $fc, $fc, $f8, $f8, $e0, $e0, $00, $00
    db $68, $57, $60, $5f, $64, $5f, $69, $57, $6f, $59, $3e, $3e, $00, $00, $00, $00
    db $ef, $df, $ef, $5f, $6b, $bf, $f2, $2e, $f6, $ea, $1c, $1c, $00, $00, $00, $00
    db $60, $a0, $e0, $20, $60, $e0, $c0, $c0, $00, $00, $00, $00, $00, $00, $00, $00
    db $fb, $f4, $fb, $f7, $7b, $77, $78, $77, $3f, $30, $1f, $1f, $07, $07, $00, $00
    db $df, $3f, $df, $ef, $dd, $ad, $1c, $fc, $f8, $38, $f0, $f0, $c0, $c0, $00, $00
    db $bd, $7e, $bf, $7c, $ad, $ff, $cb, $bb, $d8, $a8, $70, $70, $00, $00, $00, $00
    db $bd, $7e, $bf, $7c, $ad, $ff, $cb, $bb, $d9, $a9, $70, $70, $00, $00, $00, $00
    db $e4, $dc, $c4, $fc, $86, $fe, $31, $ff, $db, $d5, $0e, $0e, $00, $00, $00, $00

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
; C: far pointer loaded by Mode1A_State09_ExitDialog (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 1024
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
    db $00, $00, $00, $00, $00, $00, $06, $00, $1a, $07, $1f, $1f, $00, $01, $07, $0f
    db $00, $00, $00, $00, $00, $00, $00, $00, $40, $e0, $63, $81, $05, $8e, $ea, $cc
    db $00, $00, $00, $00, $00, $00, $34, $02, $a0, $76, $a0, $c6, $04, $06, $04, $06
    db $00, $00, $00, $00, $00, $00, $20, $50, $20, $50, $00, $00, $00, $00, $08, $00
    db $00, $00, $00, $00, $00, $00, $02, $01, $c0, $03, $00, $f3, $52, $e3, $02, $c3
    db $00, $00, $00, $00, $00, $00, $00, $00, $01, $03, $00, $00, $01, $03, $07, $00
    db $00, $00, $00, $00, $00, $00, $50, $20, $fd, $ff, $31, $20, $fe, $fc, $ec, $30
    db $00, $00, $00, $00, $00, $00, $10, $08, $ff, $fe, $ee, $18, $f8, $78, $8c, $d8
    db $00, $00, $00, $00, $00, $00, $2e, $14, $1a, $37, $7c, $ff, $b6, $64, $04, $66
    db $00, $00, $00, $00, $00, $00, $12, $0c, $6e, $33, $61, $03, $01, $03, $0f, $06
    db $0c, $18, $00, $18, $1d, $0f, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $cb, $07, $f1, $20, $a0, $c0, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $44, $86, $54, $e6, $57, $33, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $12, $09, $5a, $33, $c3, $e3, $83, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $62, $c3, $fa, $f3, $db, $81, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $08, $05, $2f, $19, $e3, $f1, $c1, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $e8, $f0, $b8, $7c, $4c, $e4, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $9c, $f8, $8c, $78, $39, $10, $10, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $e4, $46, $ae, $c4, $d8, $bc, $18, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $08, $0c, $14, $08, $1c, $08, $08, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $40, $00, $20, $41, $60, $41, $cf, $5f, $c0, $41, $81, $40
    db $00, $00, $00, $00, $00, $00, $00, $86, $02, $84, $f6, $e4, $0c, $84, $08, $84
    db $00, $00, $00, $00, $00, $00, $08, $00, $1c, $08, $00, $0c, $0c, $04, $06, $04
    db $87, $40, $9b, $4f, $d8, $51, $d0, $51, $6a, $5f, $6a, $04, $00, $00, $00, $00
    db $08, $84, $00, $8c, $88, $c4, $8e, $64, $12, $27, $03, $00, $00, $00, $00, $00
    db $00, $06, $06, $02, $03, $02, $81, $42, $c0, $80, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $0c, $04, $08, $0c, $08, $18, $08, $10, $08
    db $00, $00, $00, $00, $00, $00, $10, $00, $38, $10, $00, $18, $19, $08, $0d, $08
    db $00, $00, $00, $00, $00, $00, $01, $c0, $43, $81, $c0, $81, $81, $80, $00, $80
    db $00, $00, $00, $00, $00, $00, $03, $07, $83, $00, $01, $80, $83, $87, $ca, $84
    db $00, $00, $00, $00, $00, $00, $e8, $f0, $e0, $10, $90, $60, $18, $f0, $10, $30
    db $10, $08, $00, $18, $10, $08, $1d, $08, $05, $0f, $06, $00, $00, $00, $00, $00
    db $01, $0c, $0c, $05, $07, $04, $03, $84, $80, $00, $00, $00, $00, $00, $00, $00
    db $00, $80, $00, $80, $00, $80, $d0, $88, $58, $f0, $60, $00, $00, $00, $00, $00
    db $00, $c0, $c1, $40, $61, $43, $2d, $46, $18, $0c, $08, $00, $00, $00, $00, $00
    db $90, $60, $80, $c0, $40, $e0, $00, $60, $64, $3c, $3c, $00, $00, $00, $00, $00
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

; C: copied to VRAM/WRAM by Mode03_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 23 replay(s) of the organic corpus, modes 03 (tcrf_check/assets/l3_names/)
Map_23_64C0_Mode03_State00_Init::
    INCBIN "data/bank_23/Map_23_64C0_Mode03_State00_Init.tilemap" ; $64C0, 32 bytes
; C: far pointer loaded by SpecialMenu_DrawCursor (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 23 replay(s) of the organic corpus, modes 03 1A (tcrf_check/assets/l3_names/)
Map_23_64E0_SpecialMenu_DrawCursor::
    INCBIN "data/bank_23/Map_23_64E0_SpecialMenu_DrawCursor.tilemap" ; $64E0, 544 bytes
; C: far pointer loaded by SpecialMenu_DrawCursor (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 224 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 20 replay(s) of the organic corpus, modes 03 17
; (tcrf_check/assets/l3_names/)
Map_23_6700_SpecialMenu_DrawCursor::
    INCBIN "data/bank_23/Map_23_6700_SpecialMenu_DrawCursor.tilemap" ; $6700, 224 bytes
; C: far pointer loaded by SpecialMenu_DrawCursor (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 224 from
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
; C: map of page 1 of the SHOOT parlor (04:744E list): 18 rows of 32 bytes (0x240 up to 23:7280); Parlor_LoadPage
; (04:73EF) ends each page list ($FF) with {lo,hi,bank} stored in $D7D9-$D7DB, which Parlor_SpiralWipeIn (04:7479)
; hands to Map_SpiralWipeIn (00:0DA0); the coverage shows columns 0-19 of 18 ...
Map_23_7040_Parlor_Page1::
    INCBIN "data/bank_23/Map_23_7040_Parlor_Page1.tilemap" ; $7040, 576 bytes
; C: 0x160 bytes (11 rows): second entry of Parlor_AnimateB_PtrTbl7372, copied from bank $23 to $9800 by
; Parlor_AnimateB (04:7366) every 20 frames, alternating with the first 11 rows of 23:7040; only 4 tiles of row 0
; differ ($D7-$DA instead of $D4-$D1): a blink of the face
Map_23_7280_Parlor_Page1_AltTopRows::
    INCBIN "data/bank_23/Map_23_7280_Parlor_Page1_AltTopRows.tilemap" ; $7280, 352 bytes
; C: copied to VRAM/WRAM by Mode08_State06_EditorInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 4 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Map_23_73E0_Mode08_State06_EditorInit::
    INCBIN "data/bank_23/Map_23_73E0_Mode08_State06_EditorInit.tilemap" ; $73E0, 192 bytes
; C: far pointer loaded by Kb_Page1_PressSex (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass 2026-10-26:
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
; C: copied to VRAM/WRAM by Mode0E_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 2 replay(s) of the organic corpus, modes 0E (tcrf_check/assets/l3_names/)
Map_23_7780_Mode0E_State00_Init::
    INCBIN "data/bank_23/Map_23_7780_Mode0E_State00_Init.tilemap" ; $7780, 32 bytes
; C: far pointer loaded by Mode0E_State00_Init, Link_DrawPressAText, Link_AnimateStep3, Link_ChooseSendReceive (ld
; a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass 2026-10-26: read in BGB in 2 replay(s) of the organic
; corpus, modes 0E (tcrf_check/assets/l3_names/)
Map_23_77A0_Mode0E_State00_Init::
    INCBIN "data/bank_23/Map_23_77A0_Mode0E_State00_Init.tilemap" ; $77A0, 544 bytes
; C: far pointer loaded by Mode0E_State00_Init, Link_DrawPressAText, Link_AnimateStep3, Link_ChooseSendReceive (ld
; a,BANK; ld hl,ADDR; call banked copy/far call); length 160 from the nearby ld bc. L3 pass 2026-10-26: not reached by
; the 206 BGB replays; read in the organic runs of the core emulator ...
Map_23_79C0_Mode0E_State00_Init::
    INCBIN "data/bank_23/Map_23_79C0_Mode0E_State00_Init.tilemap" ; $79C0, 160 bytes
; C: far pointer loaded by Link_AnimateStep3, Link_DrawPressAText (ld a,BANK; ld hl,ADDR; call banked copy/far call);
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
; C: target 3 of the {lo,hi,bank} table 07:53A6; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: read in BGB in 34 replay(s) of the organic corpus, modes 02 (tcrf_check/assets/l3_names/)
Src_23_7E80_Tbl53A6_3::
    INCBIN "data/bank_23/Src_23_7E80_Tbl53A6_3.bin" ; $7E80, 384 bytes
