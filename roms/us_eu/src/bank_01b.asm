; Game Boy Camera (USA, Europe), bank $1B. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $01b", ROMX[$4000], BANK[$1b]

; I: copied to VRAM/WRAM by Mode1C_State08_PrintJob, CommentEditor_Sub0_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3
; pass 2026-10-26: read in BGB in 2 replay(s), modes 09 0A (states 09:0C 0A:0E), not only by the consumer the name
; gives: a shared asset or table; first organic loader in the core: 09:42CC
Gfx_1B_4000_Mode1C_State08_PrintJob::
    INCBIN "data/bank_1b/Gfx_1B_4000_Mode1C_State08_PrintJob.2bpp" ; $4000, 2048 bytes
; I: copied to VRAM/WRAM by Mode1C_State08_PrintJob, CommentEditor_Sub0_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3
; pass 2026-10-26: read in BGB in 2 replay(s), modes 09 0A (states 09:0C 0A:0E), not only by the consumer the name
; gives: a shared asset or table; first organic loader in the core: 09:42DA
Gfx_1B_4800_Mode1C_State08_PrintJob::
    INCBIN "data/bank_1b/Gfx_1B_4800_Mode1C_State08_PrintJob.2bpp" ; $4800, 2048 bytes
; C: copied to VRAM/WRAM by CommentEditor_Sub0_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 2 replay(s) of the organic corpus, modes 09 0A (tcrf_check/assets/l3_names/)
Gfx_1B_5000_CommentEditor_Sub0_Init::
    db $00, $00, $7c, $7c, $7c, $44, $7c, $5c, $70, $50, $70, $70, $00, $00, $00, $00
    db $00, $00, $00, $00, $1f, $00, $0f, $00, $07, $00, $03, $00, $01, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff

    ; padding
    ds $d0, $00

; I: copied to VRAM/WRAM by Mode20_State09_ResultInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 1 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Gfx_1B_5100_Mode20_State09_ResultInit::
    INCBIN "data/bank_1b/Gfx_1B_5100_Mode20_State09_ResultInit.2bpp" ; $5100, 4096 bytes
; I: copied to VRAM/WRAM by Mode21_State02_RaceSceneInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 21)
Gfx_1B_6100_Mode21_State02_RaceSceneInit::
    INCBIN "data/bank_1b/Gfx_1B_6100_Mode21_State02_RaceSceneInit.2bpp" ; $6100, 1408 bytes
; C: copied to VRAM/WRAM by Mode21_State02_RaceSceneInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 21)
Gfx_1B_6680_Mode21_State02_RaceSceneInit::
    INCBIN "data/bank_1b/Gfx_1B_6680_Mode21_State02_RaceSceneInit.2bpp" ; $6680, 2048 bytes
; C: 10 digits 0-9 of 32 bytes (2 tiles, 8 x 16 pixels), rendered; Run_DrawTimerDigitB (09:717E) copies 32 bytes from
; $6E80 + digit x 32 to VRAM; the last 8 digits were Data_1B_6EA0 / Gfx_1B_6EBA_Unref / Gfx_1B_6F7C_Unref (never shown
; in a run)
Gfx_1B_6E80_Run_DrawTimerDigitB::
    INCBIN "data/bank_1b/Gfx_1B_6E80_Run_DrawTimerDigitB.2bpp" ; $6E80, 320 bytes
; I: copied to VRAM/WRAM by Mode21_State05_ReadySteadyGo (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 21)
Gfx_1B_6FC0_Mode21_State05_ReadySteadyGo::
    db $00, $00, $c1, $c1, $ff, $3e, $ff, $00, $ff, $41, $ff, $7b, $ff, $7a, $ff, $42
    db $ff, $5a, $ff, $4b, $ff, $7b, $ff, $3a, $ff, $00, $ff, $c1, $3e, $3e, $00, $00
    db $7c, $7c, $ff, $83, $ff, $00, $ff, $5c, $ff, $de, $ff, $d2, $ff, $5e, $ff, $52
    db $ff, $52, $ff, $d2, $ff, $82, $ff, $00, $ff, $7c, $83, $83, $00, $00, $00, $00
    db $00, $00, $0c, $0c, $fc, $f4, $fc, $04, $fc, $04, $fc, $84, $fc, $84, $fc, $84
    db $fc, $84, $fc, $84, $fc, $f4, $fc, $f4, $fc, $04, $fc, $0c, $f0, $f0, $00, $00
    db $00, $00, $c0, $c0, $ff, $3f, $ff, $00, $ff, $c0, $ff, $de, $ff, $5e, $ff, $52
    db $ff, $5e, $ff, $d2, $ff, $d2, $ff, $12, $ff, $00, $ff, $c0, $3f, $3f, $00, $00
    db $1c, $1c, $fc, $e4, $fc, $04, $fc, $04, $fc, $84, $fc, $84, $fc, $84, $fc, $84
    db $fc, $94, $fc, $f4, $fc, $e4, $fc, $04, $fc, $1c, $e0, $e0, $00, $00, $00, $00

    ; padding
    ds $a0, $00

; I: copied to VRAM/WRAM by Mode1D_State06_LoadWaitScreen (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in the scenarios err_card_inq80 1D:06, print_batch_1E 1D:06, print_card_1C 1D:06, print_single_1C 1D:06
; (tcrf_check/assets/l3_names/scen_hits*.csv)
Gfx_1B_7100_Mode1D_State06_LoadWaitScreen::
    INCBIN "data/bank_1b/Gfx_1B_7100_Mode1D_State06_LoadWaitScreen.2bpp" ; $7100, 2048 bytes
; I: copied to VRAM/WRAM by Mode1D_State06_LoadWaitScreen (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in the scenarios err_card_inq80 1D:06, print_batch_1E 1D:06, print_card_1C 1D:06, print_single_1C 1D:06
; (tcrf_check/assets/l3_names/scen_hits*.csv)
Gfx_1B_7900_Mode1D_State06_LoadWaitScreen::
    db $f4, $fb, $f5, $fa, $f8, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f7, $0f, $f7, $ff, $ff, $f7, $fb, $f7, $fb, $f7, $f9, $f7, $fd, $f3, $ff, $f0
    db $fb, $fc, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $77, $0f, $37, $0f, $7f, $07, $77, $0f, $7f, $07, $37, $0f, $7f, $07, $7f, $07
    db $68, $30, $04, $40, $91, $42, $92, $12, $12, $00, $11, $00, $20, $21, $21, $00
    db $a3, $4c, $f3, $00, $f3, $0c, $f1, $3c, $5a, $81, $07, $78, $4e, $0c, $5f, $0e
    db $06, $05, $07, $02, $00, $01, $00, $00, $00, $00, $01, $00, $01, $02, $02, $0c
    db $80, $00, $80, $00, $80, $00, $80, $00, $80, $00, $80, $00, $80, $00, $80, $00
    db $00, $00, $00, $00, $00, $00, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $81, $81
    db $00, $00, $00, $00, $00, $00, $80, $80, $e0, $e0, $f0, $f0, $f0, $f0, $f8, $f8
    db $80, $80, $00, $00, $00, $00, $8f, $8f, $bf, $bf, $ff, $ff, $fc, $fc, $f0, $f0
    db $78, $78, $78, $78, $00, $00, $7b, $7b, $7b, $7b, $7b, $7b, $7b, $7b, $7b, $7b
    db $00, $00, $00, $00, $00, $00, $fc, $fc, $ff, $ff, $ff, $ff, $ff, $ff, $c7, $c7
    db $1f, $1f, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $9e, $9e, $9e, $9e, $de, $de
    db $de, $de, $1e, $1e, $00, $00, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e
    db $fa, $fd, $fb, $fc, $fb, $fc, $fa, $fd, $fb, $fc, $fb, $fc, $fa, $fd, $fb, $fc
    db $77, $0f, $7f, $07, $77, $0f, $7f, $07, $77, $0f, $7f, $07, $77, $0f, $7f, $07
    db $70, $c0, $58, $40, $b8, $40, $98, $40, $20, $d0, $30, $80, $30, $80, $b0, $00
    db $2a, $00, $a1, $00, $42, $1c, $95, $38, $da, $1c, $4b, $91, $15, $2a, $5b, $c1
    db $70, $10, $28, $20, $35, $20, $32, $10, $09, $16, $05, $0b, $03, $0f, $04, $04
    db $80, $00, $80, $00, $00, $00, $80, $00, $00, $00, $80, $00, $80, $00, $80, $00
    db $8f, $8f, $8f, $8f, $8f, $8f, $8f, $8f, $8f, $8f, $8f, $8f, $8f, $8f, $8f, $8f
    db $ff, $ff, $80, $80, $80, $80, $8f, $8f, $8f, $8f, $8f, $8f, $8f, $8f, $8f, $8f
    db $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
    db $80, $80, $80, $80, $80, $80, $80, $80, $81, $81, $ff, $ff, $ff, $ff, $ff, $ff
    db $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f0, $f0, $f0, $f0, $e0, $e0
    db $e0, $e0, $c0, $c0, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
    db $7b, $7b, $7b, $7b, $7b, $7b, $7b, $7b, $7b, $7b, $7b, $7b, $7b, $7b, $7b, $7b
    db $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3
    db $de, $de, $de, $de, $de, $de, $de, $de, $df, $df, $df, $df, $cf, $cf, $c7, $c7
    db $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $de, $de, $de, $de, $de, $de
    db $00, $00, $00, $00, $00, $00, $40, $80, $80, $40, $e0, $20, $80, $20, $50, $a0
    db $18, $f0, $f2, $0c, $50, $03, $0b, $00, $2d, $02, $96, $02, $2a, $01, $57, $00
    db $00, $00, $01, $02, $02, $04, $0c, $00, $10, $08, $04, $10, $10, $30, $04, $30
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $00, $00, $00, $80, $00
    db $00, $00, $00, $00, $00, $00, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
    db $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0
    db $f7, $f7, $f7, $f7, $f7, $f7, $f7, $f7, $f3, $f3, $f3, $f3, $f1, $f1, $f0, $f0
    db $87, $87, $87, $87, $87, $87, $c7, $c7, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $7f
    db $80, $80, $9c, $9c, $9c, $9c, $9c, $9c, $80, $80, $80, $80, $80, $80, $80, $80
    db $00, $00, $e7, $e7, $e7, $e7, $e7, $e7, $00, $00, $00, $00, $00, $00, $00, $00
    db $07, $07, $0f, $0f, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $fe, $00, $00, $00, $00
    db $80, $80, $80, $80, $80, $80, $80, $80, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7f, $00, $7f, $00, $5d, $22
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $70, $f0, $8f, $ff, $bf, $e0, $ff, $c9, $77, $cf, $7f, $46
    db $00, $00, $00, $00, $00, $00, $fb, $fd, $fa, $07, $de, $31, $ef, $f0, $ff, $c0
    db $00, $00, $00, $00, $00, $00, $c0, $c0, $a0, $60, $20, $e0, $b0, $e0, $60, $e0
    db $0e, $06, $09, $0f, $0f, $09, $0f, $09, $0f, $09, $0f, $0d, $07, $07, $01, $01
    db $bf, $ff, $ae, $ce, $00, $80, $80, $00, $00, $80, $80, $c6, $e0, $e0, $5c, $bf
    db $ee, $f1, $1f, $08, $03, $0c, $07, $04, $07, $04, $03, $0c, $1f, $08, $f7, $f8
    db $c0, $80, $9c, $98, $6c, $f4, $bc, $44, $fc, $04, $f4, $0c, $9c, $78, $70, $e0
    db $05, $06, $03, $06, $03, $02, $03, $01, $01, $00, $00, $00, $00, $00, $00, $00
    db $f1, $0e, $ff, $00, $ff, $00, $ff, $00, $ff, $80, $e7, $78, $5f, $60, $7f, $40
    db $ff, $02, $ff, $02, $fc, $06, $fc, $04, $f8, $08, $f8, $18, $c8, $78, $48, $f8
    db $00, $00, $00, $00, $01, $00, $03, $01, $02, $07, $0f, $0e, $1d, $0a, $1d, $12
    db $1b, $1f, $e1, $7f, $e7, $c0, $20, $c0, $80, $60, $e0, $20, $f0, $20, $f0, $10
    db $fe, $fc, $4e, $bf, $7f, $c3, $5f, $30, $1f, $08, $0b, $04, $03, $02, $00, $01
    db $00, $00, $00, $00, $00, $00, $80, $c0, $e0, $60, $f0, $30, $f8, $18, $fc, $08
    db $31, $36, $31, $26, $65, $62, $43, $62, $c0, $63, $c3, $e1, $81, $e1, $c1, $a0
    db $f8, $10, $f8, $08, $f0, $0c, $fc, $04, $fa, $06, $ff, $02, $ff, $01, $ff, $80
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $00, $80, $80
    db $fc, $84, $fe, $44, $1e, $62, $2f, $32, $3c, $13, $07, $19, $1f, $09, $07, $09
    db $f0, $a0, $c0, $b0, $b0, $d0, $78, $d0, $78, $48, $7c, $48, $3c, $64, $38, $26
    db $ff, $80, $ff, $40, $1f, $60, $3f, $20, $3f, $10, $0f, $18, $03, $0c, $01, $06
    db $00, $c0, $e0, $40, $f0, $20, $d0, $30, $e8, $18, $f0, $0c, $f8, $06, $fc, $03
    db $0b, $05, $07, $05, $07, $05, $05, $03, $06, $03, $02, $06, $06, $06, $06, $04
    db $00, $00, $20, $00, $20, $00, $22, $00, $20, $02, $00, $22, $00, $22, $62, $22
    db $1f, $32, $17, $19, $0f, $08, $07, $04, $02, $03, $01, $01, $00, $00, $00, $00
    db $02, $03, $80, $01, $c0, $80, $c0, $60, $f8, $30, $aa, $dc, $6b, $77, $0f, $1f
    db $fe, $01, $ff, $80, $df, $60, $17, $38, $12, $0f, $03, $01, $0e, $fe, $f8, $f8
    db $84, $8c, $78, $c8, $f8, $30, $e0, $30, $e0, $c0, $80, $80, $00, $00, $00, $00
    db $66, $00, $44, $44, $40, $88, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $07, $0f, $08, $0f, $0b, $0e, $0f, $0d, $06, $0d, $07, $04, $37, $37, $68, $5c
    db $00, $00, $ff, $ff, $ff, $00, $fb, $26, $fd, $fe, $ff, $d8, $fe, $ff, $e1, $e0
    db $00, $00, $7c, $bc, $5a, $e6, $e2, $1e, $fb, $0e, $fe, $0e, $f4, $0c, $ff, $85
    db $0e, $0b, $0f, $0a, $0e, $0b, $0f, $0d, $07, $07, $01, $01, $01, $01, $03, $01
    db $00, $00, $00, $00, $00, $00, $00, $8c, $e0, $c0, $59, $bf, $78, $87, $7f, $80
    db $0f, $08, $03, $0c, $0b, $0c, $0f, $08, $37, $18, $ef, $f0, $ff, $00, $ff, $00
    db $70, $f8, $78, $c8, $fc, $08, $f8, $08, $e8, $18, $f0, $f8, $c0, $80, $80, $80
    db $1d, $3e, $7a, $27, $5f, $20, $6f, $30, $37, $18, $1d, $0f, $07, $03, $0f, $06
    db $ff, $00, $ff, $00, $bf, $40, $fe, $7f, $60, $c1, $df, $ff, $94, $ef, $f7, $18
    db $f6, $0c, $fe, $0a, $fe, $03, $ee, $13, $af, $f2, $fe, $e6, $3c, $fc, $3c, $18
    db $01, $03, $07, $06, $0f, $0c, $1f, $18, $3f, $10, $3f, $21, $7f, $22, $78, $46
    db $fa, $0c, $f8, $10, $d0, $20, $c0, $40, $00, $80, $00, $00, $00, $00, $00, $00
    db $04, $03, $01, $06, $07, $04, $0f, $04, $0f, $08, $1f, $08, $1f, $10, $0f, $30
    db $c0, $80, $40, $e0, $f0, $70, $b8, $50, $b8, $48, $8c, $6c, $8c, $64, $a6, $46
    db $f4, $4c, $3c, $c8, $e0, $98, $f8, $90, $e0, $90, $d0, $a0, $e0, $a0, $e0, $a0
    db $00, $00, $00, $00, $00, $00, $01, $00, $01, $01, $00, $03, $07, $02, $0f, $04
    db $3f, $20, $5f, $60, $ff, $40, $ff, $80, $ff, $01, $ff, $01, $ff, $02, $f8, $06
    db $c2, $46, $03, $c6, $c3, $87, $81, $87, $83, $05, $0f, $05, $03, $0d, $0d, $0b
    db $a0, $c0, $60, $c0, $40, $60, $60, $60, $60, $20, $21, $31, $1e, $13, $1f, $0c
    db $0b, $0c, $17, $18, $0f, $30, $1f, $60, $3f, $c0, $7f, $80, $ff, $01, $fb, $06
    db $fc, $04, $fc, $08, $f0, $18, $c0, $30, $80, $60, $40, $c0, $01, $80, $03, $01
    db $1e, $0b, $1e, $12, $3e, $12, $3c, $26, $1c, $64, $f8, $4c, $e8, $98, $f0, $10
    db $07, $0c, $07, $03, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $e8, $1c, $48, $f0, $c0, $80, $f0, $7f, $3f, $1f, $00, $00, $00, $00, $00, $00
    db $03, $06, $1f, $0c, $55, $3b, $d7, $ee, $f0, $f8, $00, $00, $00, $00, $00, $00
    db $e0, $20, $40, $c0, $80, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $70, $78, $08, $88, $38, $30, $00, $00, $00, $00, $16, $0c, $32, $12, $0c, $0e

    ; padding
    ds $b0, $00
