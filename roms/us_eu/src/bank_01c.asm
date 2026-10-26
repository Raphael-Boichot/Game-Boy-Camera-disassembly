; Game Boy Camera (USA, Europe), bank $1C. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $01c", ROMX[$4000], BANK[$1c]

    ; padding
    ds $10, $00

; I: Spriter's Resource sheet "Menus - Shoot Menu", 49 tiles | also inside record 1 of page 1 of Parlor_PageTbl
; (1C:4000 +$0800 -> $9000, C). L3 pass 2026-10-26: read in BGB in 24 replay(s) of the organic corpus, modes 01
; (tcrf_check/assets/l3_names/)
Sheet_MenusShootMenu_1C_4010::
    INCBIN "data/bank_1c/Sheet_MenusShootMenu_1C_4010.bin" ; $4010, 561 bytes
; I: inside record 1 of page 1 (1C:4000 +$0800 -> $9000, VRAM $9241 onward) of Parlor_PageTbl (04:7436), loaded by
; Parlor_LoadPage; load extent from the code and the coverage log (every byte of the record is read), content = tile
; data by its look (I)
Gfx_1C_4241_Parlor_Page1::
    INCBIN "data/bank_1c/Gfx_1C_4241_Parlor_Page1.bin" ; $4241, 623 bytes
; I: inside record 1 of page 1 (1C:4000 +$0800 -> $9000, VRAM $94B0 onward) of Parlor_PageTbl (04:7436), loaded by
; Parlor_LoadPage; load extent from the code and the coverage log (every byte of the record is read), content = tile
; data by its look (I)
Gfx_1C_44B0_Parlor_Page1::
    INCBIN "data/bank_1c/Gfx_1C_44B0_Parlor_Page1.2bpp" ; $44B0, 448 bytes
; I: Spriter's Resource sheet "Menus - Shoot Menu", 151 tiles | also inside record 1 of page 1 of Parlor_PageTbl
; (1C:4000 +$0800 -> $9000, C). L3 pass 2026-10-26: read in BGB in 24 replay(s) of the organic corpus, modes 01
; (tcrf_check/assets/l3_names/)
Sheet_MenusShootMenu_1C_4670::
    db $3f, $87, $30, $88, $30, $88, $30, $88, $30, $88, $30, $88, $30, $88, $30, $88
    db $80, $ff, $40, $ff, $20, $7f, $40, $ff, $c0, $7f, $00, $00, $ff, $00, $ff, $00
    db $33, $3f, $00, $60, $d1, $fa, $ff, $7f, $b5, $6e, $00, $00, $ff, $00, $ff, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $01, $02, $00, $00, $ff, $00, $ff, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $00, $ff, $00
    db $00, $00, $00, $00, $00, $00, $11, $02, $3a, $17, $00, $00, $ff, $00, $ff, $00
    db $00, $18, $18, $08, $70, $78, $78, $d0, $d8, $d0, $00, $00, $ff, $00, $ff, $00
    db $04, $fe, $04, $fc, $0a, $fc, $0e, $fe, $07, $fd, $00, $00, $ff, $00, $ff, $00
    db $04, $03, $04, $03, $f0, $0f, $00, $ff, $00, $ff, $00, $00, $ff, $00, $ff, $00
    db $e0, $00, $ee, $10, $d0, $0f, $88, $07, $02, $c1, $00, $00, $ff, $00, $ff, $00
    db $0f, $00, $ef, $10, $0f, $e0, $43, $84, $00, $0c, $00, $00, $ff, $00, $ff, $00
    db $00, $c0, $20, $c0, $00, $ff, $00, $ff, $01, $fe, $00, $00, $ff, $00, $ff, $00
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00, $ff, $00
    db $38, $8f, $30, $8f, $38, $87, $3c, $83, $3e, $81, $3f, $80, $3f, $80, $3f, $80
    db $0c, $07, $0c, $07, $0c, $07, $08, $0f, $18, $0f, $10, $1f, $60, $3f, $40, $ff
    db $14, $c0, $7c, $9c, $9c, $bc, $00, $ac, $40, $80, $80, $40, $40, $40, $15, $68
    db $00, $00, $00, $00, $00, $00, $20, $40, $6c, $78, $fc, $78, $c8, $48, $00, $00
    db $50, $f0, $f0, $f0, $e8, $f8, $f8, $f8, $d0, $f0, $d0, $70, $10, $e0, $00, $00
    db $01, $03, $07, $03, $03, $07, $03, $03, $03, $01, $01, $01, $80, $01, $00, $00
    db $30, $10, $10, $10, $08, $10, $08, $10, $1e, $11, $37, $1f, $b5, $6f, $a1, $fc
    db $bc, $be, $b6, $84, $80, $80, $40, $c0, $40, $e0, $30, $f0, $1d, $f8, $03, $ff
    db $10, $0f, $20, $1f, $40, $3f, $00, $ff, $00, $ff, $00, $ff, $10, $0f, $04, $03
    db $00, $38, $48, $30, $40, $30, $01, $60, $04, $43, $d0, $0f, $ee, $10, $e0, $00
    db $00, $1c, $12, $0c, $02, $0c, $80, $06, $20, $c2, $07, $f0, $cf, $30, $0f, $00
    db $78, $ff, $20, $7f, $20, $3f, $50, $1f, $50, $ff, $e8, $ff, $98, $2f, $0c, $07
    db $9a, $cd, $f8, $70, $30, $10, $00, $00, $00, $00, $00, $00, $00, $60, $c0, $40
    db $01, $03, $00, $00, $1a, $10, $1e, $3e, $3e, $3e, $24, $06, $00, $00, $00, $00
    db $08, $3c, $30, $f8, $b8, $50, $30, $10, $00, $30, $30, $20, $a0, $20, $b0, $e0
    db $3d, $0b, $0c, $07, $08, $04, $44, $84, $c2, $84, $c0, $86, $c3, $02, $01, $03
    db $38, $70, $40, $e0, $80, $80, $02, $86, $83, $47, $63, $47, $04, $62, $10, $20
    db $f4, $f8, $19, $fe, $31, $e1, $40, $c0, $80, $c0, $80, $80, $ac, $86, $bc, $be
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $1f, $10, $0f, $10, $0f
    db $00, $ff, $00, $ff, $80, $7f, $40, $3f, $00, $3f, $01, $3e, $02, $3c, $04, $38
    db $00, $ff, $00, $ff, $01, $fe, $02, $fc, $00, $fc, $00, $fc, $80, $7c, $00, $3c
    db $08, $f0, $04, $f8, $02, $fc, $00, $ff, $00, $ff, $00, $ff, $21, $c0, $00, $c0
    db $10, $9f, $10, $9f, $50, $9f, $08, $df, $88, $5f, $58, $4f, $18, $0f, $28, $1f
    db $40, $24, $00, $24, $02, $24, $10, $26, $06, $32, $12, $32, $23, $10, $01, $16
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $80, $88, $f0, $2d, $1e
    db $00, $60, $20, $60, $00, $60, $00, $60, $3f, $7f, $43, $e1, $47, $83, $07, $06
    db $02, $03, $02, $03, $03, $02, $03, $02, $02, $ff, $81, $ff, $01, $80, $58, $f8
    db $40, $20, $20, $40, $40, $40, $80, $40, $01, $c0, $c1, $81, $07, $83, $1e, $4c
    db $02, $62, $24, $42, $42, $44, $84, $44, $4c, $84, $c0, $8c, $88, $80, $c0, $80
    db $06, $fc, $04, $fc, $08, $fc, $08, $f8, $08, $f8, $10, $f8, $18, $f0, $0f, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $07, $f8, $08, $f0, $08, $f0
    db $60, $3f, $20, $3f, $20, $3f, $20, $3f, $20, $3f, $b0, $1f, $10, $9f, $10, $9f
    db $80, $12, $09, $92, $12, $89, $00, $89, $41, $89, $84, $49, $44, $49, $29, $44
    db $09, $0d, $00, $19, $61, $30, $e0, $c0, $80, $00, $00, $00, $00, $00, $00, $00
    db $c0, $80, $80, $80, $80, $00, $01, $00, $00, $ff, $38, $e0, $00, $20, $40, $20
    db $01, $01, $00, $01, $00, $00, $a0, $c0, $41, $3e, $07, $03, $00, $03, $02, $03
    db $08, $d0, $0c, $d8, $d8, $96, $92, $91, $20, $90, $00, $30, $10, $20, $00, $20
    db $c4, $88, $80, $88, $10, $88, $89, $10, $10, $11, $01, $31, $12, $21, $21, $22
    db $00, $ff, $00, $ff, $01, $ff, $01, $ff, $01, $ff, $02, $ff, $03, $fe, $04, $fe
    db $42, $81, $00, $c1, $20, $c1, $10, $e1, $0c, $f3, $00, $ff, $00, $ff, $00, $ff
    db $80, $ff, $80, $ff, $80, $ff, $c0, $7f, $40, $7f, $40, $7f, $40, $7f, $60, $3f
    db $00, $80, $08, $84, $84, $04, $00, $04, $02, $24, $14, $22, $24, $12, $10, $12
    db $f1, $f0, $f0, $f1, $f1, $f1, $13, $e1, $00, $03, $43, $02, $66, $c3, $05, $07
    db $0f, $0f, $0f, $0f, $0f, $0f, $08, $07, $00, $00, $00, $00, $00, $00, $80, $c0
    db $f0, $f8, $f2, $f9, $f3, $fa, $06, $02, $03, $00, $00, $00, $00, $00, $03, $01
    db $cf, $4f, $4f, $4f, $47, $4f, $40, $40, $20, $40, $46, $22, $07, $22, $00, $30
    db $10, $f1, $20, $f3, $33, $e2, $26, $e2, $44, $e2, $62, $c4, $44, $c4, $88, $c4
    db $00, $ff, $00, $ff, $c0, $3f, $10, $0f, $08, $07, $08, $07, $08, $07, $70, $8f
    db $f0, $0f, $e6, $01, $f0, $00, $88, $30, $24, $18, $12, $0c, $01, $86, $00, $83
    db $04, $83, $80, $07, $88, $07, $80, $0f, $60, $9f, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $80, $ff, $80, $ff
    db $04, $87, $02, $83, $02, $83, $03, $81, $81, $81, $81, $81, $00, $81, $00, $80
    db $45, $00, $59, $80, $e8, $d0, $f0, $f8, $fc, $f8, $f0, $f8, $f0, $f8, $f9, $d0
    db $04, $0e, $20, $14, $35, $1e, $2f, $1f, $1d, $0c, $1d, $0c, $1f, $0f, $1f, $0e
    db $80, $c3, $19, $10, $b0, $f0, $f8, $f0, $f8, $f0, $f8, $f0, $f8, $f0, $f8, $d0
    db $01, $d8, $04, $c9, $5f, $a5, $5f, $9f, $1d, $cc, $8d, $cc, $8f, $cf, $4f, $ce
    db $02, $fe, $06, $fc, $04, $fc, $04, $fc, $08, $fc, $08, $f8, $10, $f8, $18, $f0
    db $00, $ff, $00, $ff, $70, $8f, $08, $07, $08, $07, $08, $07, $30, $0f, $80, $7f
    db $04, $83, $08, $87, $90, $0f, $21, $1e, $04, $38, $d8, $20, $e0, $00, $f3, $00
    db $3f, $c0, $8f, $00, $1f, $00, $27, $10, $13, $60, $00, $e3, $00, $c3, $44, $83
    db $00, $ff, $03, $fc, $18, $e0, $20, $c0, $20, $c0, $20, $c0, $12, $e1, $00, $ff
    db $c0, $7f, $c0, $ff, $20, $7f, $30, $1f, $18, $0f, $08, $8f, $04, $8f, $04, $87
    db $46, $3f, $82, $01, $80, $98, $10, $90, $91, $10, $18, $91, $08, $99, $cd, $6c
    db $00, $00, $04, $08, $1d, $08, $00, $19, $00, $19, $18, $09, $08, $08, $0c, $08
    db $c0, $00, $87, $c2, $06, $84, $00, $0c, $0c, $08, $0c, $08, $00, $0c, $82, $04
    db $b6, $f8, $a0, $d8, $11, $b1, $22, $21, $02, $63, $c1, $62, $82, $61, $40, $b1
    db $00, $ff, $00, $ff, $01, $ff, $01, $ff, $01, $ff, $03, $fe, $03, $fe, $02, $fe
    db $00, $ff, $00, $ff, $00, $ff, $12, $e1, $20, $c1, $00, $c1, $42, $81, $42, $81
    db $00, $c3, $22, $c1, $12, $e1, $88, $71, $49, $30, $27, $18, $0f, $00, $8f, $00
    db $00, $ff, $1c, $e3, $23, $c0, $00, $c0, $00, $c0, $20, $c0, $0c, $f0, $01, $fe
    db $c0, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $39, $f9, $e6, $c3, $0c, $07, $08, $0f, $18, $8f, $d0, $9f, $b0, $9f, $60, $3f
    db $00, $ff, $03, $ff, $9d, $fe, $78, $e0, $01, $00, $01, $01, $01, $01, $18, $e0
    db $c6, $e3, $e1, $33, $38, $71, $78, $f0, $d0, $f0, $90, $f0, $e0, $e0, $6d, $ff
    db $38, $f1, $43, $e1, $c1, $82, $03, $02, $01, $03, $03, $01, $00, $01, $ff, $ff
    db $00, $3f, $00, $3f, $c1, $bf, $ff, $7e, $34, $08, $40, $60, $e0, $60, $11, $6f
    db $88, $88, $6c, $64, $13, $73, $09, $78, $8c, $78, $04, $fc, $02, $fe, $01, $ff
    db $00, $78, $80, $78, $00, $f8, $00, $f8, $04, $f8, $03, $fc, $00, $ff, $00, $ff
    db $00, $f0, $00, $f0, $09, $f0, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $38, $8f, $38, $8f, $38, $8f, $38, $8f, $38, $8f, $38, $8f, $38, $8f, $38, $8f
    db $00, $ff, $00, $ff, $70, $8f, $88, $07, $80, $07, $84, $03, $84, $03, $40, $83
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $c0, $ff, $20, $3f, $20, $3f, $20, $3f
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $01, $ff, $02, $fe, $02, $fe, $06, $fe
    db $10, $1f, $30, $1f, $a0, $bf, $e0, $bf, $b0, $3f, $10, $1f, $08, $0f, $c4, $07
    db $01, $ff, $01, $ff, $00, $ff, $00, $ff, $01, $ff, $03, $fe, $04, $fe, $08, $fc
    db $04, $03, $04, $03, $f0, $0f, $00, $ff, $00, $ff, $00, $ff, $00, $7f, $40, $3f
    db $e0, $00, $ee, $10, $d0, $0f, $88, $07, $02, $c1, $f0, $70, $88, $88, $88, $88
    db $0f, $00, $ef, $10, $0f, $e0, $43, $84, $00, $0c, $04, $18, $24, $18, $00, $38
    db $00, $c0, $20, $c0, $00, $ff, $00, $ff, $01, $fe, $00, $fc, $00, $f8, $00, $f0
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $3c, $87, $38, $8f, $38, $8f, $38, $8f, $38, $8f, $38, $8f, $38, $8f, $38, $8f
    db $00, $ff, $00, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff, $e0, $ff, $10, $1f
    db $00, $ff, $00, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff, $00, $ff, $01, $ff
    db $00, $ff, $00, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff, $10, $0f, $04, $03
    db $00, $ff, $00, $00, $ff, $00, $ff, $00, $ff, $ff, $d0, $0f, $ee, $10, $e0, $00
    db $00, $ff, $00, $00, $ff, $00, $ff, $00, $ff, $ff, $07, $f0, $cf, $30, $0f, $00
    db $00, $ff, $00, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff, $21, $c0, $00, $c0
    db $00, $ff, $00, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $c0, $3f, $80, $3f, $80, $3f, $80, $3f, $81, $3e, $83, $3c, $87
    db $00, $ff, $00, $00, $ff, $00, $ff, $00, $ff, $ff, $20, $c0, $0c, $f0, $01, $fe
    db $00, $ff, $00, $00, $ff, $00, $ff, $00, $ff, $ff, $27, $18, $0f, $00, $8f, $00
    db $00, $ff, $00, $00, $ff, $00, $ff, $00, $ff, $ff, $d8, $20, $e0, $00, $f3, $00
    db $00, $ff, $00, $00, $ff, $00, $ff, $00, $ff, $ff, $08, $07, $30, $0f, $80, $7f
    db $f0, $0f, $e6, $01, $f0, $00, $88, $30, $24, $18, $72, $7c, $89, $8e, $88, $8b
    db $8a, $89, $6c, $e5, $33, $d3, $19, $e8, $0c, $f8, $04, $fc, $02, $fe, $01, $ff
    db $00, $ff, $00, $ff, $81, $ff, $ff, $7e, $34, $08, $40, $60, $e0, $60, $11, $6f
    db $00, $ff, $03, $fc, $18, $e0, $20, $c0, $20, $c0, $00, $00, $ff, $00, $ff, $00
    db $00, $00, $00, $00, $00, $00, $80, $80, $c0, $c0, $e0, $e0, $f0, $f0, $f8, $f8
    db $f0, $0f, $e6, $01, $f0, $00, $88, $30, $24, $18, $00, $00, $ff, $00, $ff, $00
    db $00, $ff, $00, $ff, $c0, $3f, $10, $0f, $08, $07, $00, $00, $ff, $00, $ff, $00
    db $3f, $c0, $8f, $00, $1f, $00, $27, $10, $13, $60, $00, $00, $ff, $00, $ff, $00
    db $89, $89, $00, $00, $00, $ff, $00, $00, $ff

    db $00, $ff, $ff, $00, $00, $00, $00, $d3, $d3, $00, $00, $00, $ff, $00, $00, $ff
    db $00, $ff, $ff, $00, $00, $00, $00, $99, $99, $00, $00, $00, $ff, $00, $00, $ff
    db $00, $ff, $ff, $00, $00, $00, $00, $53, $53, $00, $00, $00, $ff, $00, $00, $ff
    db $00, $ff, $ff, $00, $00, $00, $00, $81, $81, $00, $00, $00, $ff, $00, $00, $ff
    db $00, $ff, $ff, $00, $00, $00, $00, $98, $98, $00, $00, $00, $ff, $00, $00, $ff
    db $00, $ff, $ff, $00, $00, $00, $00, $2a, $2a, $00, $00, $00, $ff, $00, $00, $ff
    db $00, $ff, $ff, $00, $00, $00, $00, $20, $20, $c0, $c0, $00, $ff, $00, $00, $ff
    db $00, $ff, $ff, $00, $00, $00, $00, $e3, $e3, $80, $80, $00, $ff, $00, $00, $ff
    db $00, $ff, $ff, $00, $00, $00, $00, $50, $50, $00, $00, $00, $ff, $00, $00, $ff
    db $00, $ff, $ff, $00, $00, $00, $00, $99, $99, $00, $00, $00, $ff, $00, $00, $ff
    db $00, $ff, $ff, $00, $00, $00, $00, $08, $08, $00, $00, $00, $ff, $00, $00, $ff
    db $00, $ff, $ff

    ; padding
    ds $14, $00

    db $ff, $ff, $00, $00, $a8, $a8, $a8, $a8, $a9, $a9, $aa, $aa, $ab, $ab, $da, $da
    db $ff, $ff, $00, $00, $10, $10, $10, $10, $93, $93, $54, $54, $d4, $d4, $14, $14
    db $ff, $ff, $00, $00, $00, $00, $00, $00, $19, $19, $a5, $a5, $25, $25, $25, $25
    db $ff, $ff, $00, $00, $00, $00, $00, $00, $e3, $e3, $54, $54, $57, $57, $54, $54
    db $ff, $ff, $00, $00, $02, $02, $07, $07, $02, $02, $82, $82, $82, $82, $02, $02
    db $ff, $ff, $00, $00, $00, $00, $80, $80, $18, $18, $24, $24, $24, $24, $24, $24

; I: copied to VRAM/WRAM by Mode1A_State02_Setup (roms/jp_rev_a/assets/catalog_jp.csv) | also inside record 2 of page
; 1 of Parlor_PageTbl (1C:4800 +$0800 -> $8800, C). L3 pass 2026-10-26: read in BGB in 24 replay(s) of the organic
; corpus, modes 01 1A (tcrf_check/assets/l3_names/)
Gfx_1C_4F60_Mode1A_State02_Setup::
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $bb, $99, $bb, $99, $bb, $99, $bb, $99, $bb, $81, $83, $81
    db $ff, $ff, $ff, $ff, $e7, $c3, $db, $81, $bd, $99, $bd, $99, $bd, $99, $bd, $99
    db $ff, $ff, $ff, $ff, $ff, $81, $81, $81, $81, $e7, $e7, $e7, $e7, $e7, $e7, $e7
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $e7, $c3, $c3, $81, $93, $99, $9f, $9f, $cb, $87, $e1, $c3
    db $ff, $ff, $ff, $ff, $fd, $03, $83, $01, $bd, $01, $bd, $39, $bd, $39, $83, $01
    db $ff, $ff, $ff, $ff, $e7, $c3, $db, $81, $bd, $99, $bd, $99, $bd, $99, $bd, $99
    db $ff, $ff, $ff, $ff, $ff, $81, $81, $81, $81, $e7, $e7, $e7, $e7, $e7, $e7, $e7
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $bb, $99, $3b, $99, $3b, $99, $3b, $99, $37, $99, $ff, $ff, $ff, $ff, $ff, $ff
    db $bd, $99, $bd, $99, $bd, $99, $db, $81, $e7, $c3, $ff, $ff, $ff, $ff, $ff, $ff
    db $e7, $e7, $e7, $e7, $e7, $e7, $e7, $e7, $e7, $e7, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f1, $f1, $b9, $f9, $99, $81, $81, $83, $a3, $c7, $ff, $ff, $ff, $ff, $ff, $ff
    db $83, $03, $bf, $3f, $bf, $3f, $bf, $3f, $bf, $3f, $ff, $ff, $ff, $ff, $ff, $ff
    db $bd, $99, $bd, $99, $bd, $99, $db, $81, $e7, $c3, $ff, $ff, $ff, $ff, $ff, $ff
    db $e7, $e7, $e7, $e7, $e7, $e7, $e7, $e7, $e7, $e7, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $fc, $fc, $fd, $fc, $fd, $fc, $fd, $fc, $fd, $fc, $fd, $fc, $fd, $fc, $fd, $fc
    db $00, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $7c, $3c, $bd, $7c, $bd, $7c, $bd, $7c, $bd, $7c, $bd, $7c, $bd, $7c, $bd, $7c
    db $7f, $3f, $bf, $7f, $bf, $7f, $bf, $7f, $bf, $7f, $bf, $7f, $bf, $7f, $bf, $7f
    db $fd, $fc, $fd, $fc, $fd, $fc, $fd, $fc, $fd, $fc, $fd, $fc, $fd, $fc, $fe, $fd
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff
    db $bd, $7c, $bd, $7c, $bd, $7c, $bd, $7c, $bd, $7c, $bd, $7c, $bd, $7c, $3e, $fd
    db $bf, $7f, $bf, $7f, $bf, $7f, $bf, $7f, $bf, $7f, $bf, $7f, $bf, $7f, $3f, $ff

    ; padding
    ds $40, $00

; I: bytes of a 2bpp tile block that no copy reads (organic readers on both sides)
TileGap_1C_5160::
    INCBIN "data/bank_1c/TileGap_1C_5160.2bpp" ; $5160, 64 bytes
; C: far pointer loaded by Mode1A_State04_PlaceOrDelete, Mode1A_State09_ExitDialog (ld a,BANK; ld hl,ADDR; call banked
; copy/far call); length 512 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 6 replay(s) of the organic
; corpus, modes 1A (tcrf_check/assets/l3_names/)
Gfx_1C_51A0_Mode1A_State04_PlaceOrDelete::
    INCBIN "data/bank_1c/Gfx_1C_51A0_Mode1A_State04_PlaceOrDelete.2bpp" ; $51A0, 512 bytes
; C: copied to VRAM/WRAM by Mode1A_State02_Setup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 10 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
Gfx_1C_53A0_Mode1A_State02_Setup::
    INCBIN "data/bank_1c/Gfx_1C_53A0_Mode1A_State02_Setup.2bpp" ; $53A0, 608 bytes
; C: far pointer loaded by Album_ShowPageScreenB, Album_LoadBorderScreen, Shoot_DrawOptionPanel,
; Mode1C_DrawOptionScreen (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass 2026-10-26: read in BGB in 76
; replay(s) of the organic corpus, modes 09 0A 14 1A 1C (tcrf_check/assets/l3_names/)
Gfx_1C_5600_Album_ShowPageScreenB::
    INCBIN "data/bank_1c/Gfx_1C_5600_Album_ShowPageScreenB.2bpp" ; $5600, 32 bytes
; I: 64 bytes of tile-like data between the loaded 5600 block (32 bytes copied) and the digit table 5660: never
; copied; was Data_1C_5620 + TileGap_1C_5622 + Data_1C_5623 + TileGap_1C_564D + Data_1C_564E (fill-run splits)
TileGap_1C_5620::
    INCBIN "data/bank_1c/TileGap_1C_5620.2bpp" ; $5620, 64 bytes
; C: digit table: HotSpotEd_CopyNumberTile (03:74C7) copies 16 bytes (1 tile) from $5660 + digit x 16 (+ B, 0 or a
; small offset); 10 entries = 5660-5700; was followed by Gfx_1C_5670_..._Aux
Gfx_1C_5660_HotSpotEd_CopyNumberTile::
    INCBIN "data/bank_1c/Gfx_1C_5660_HotSpotEd_CopyNumberTile.bin" ; $5660, 174 bytes
; I: bytes of a 2bpp tile block that no copy reads (organic readers on both sides)
TileGap_1C_570E::
    INCBIN "data/bank_1c/TileGap_1C_570E.bin" ; $570E, 2 bytes
; C: far pointer loaded by HotSpotEd_ShowJump (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 16 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 6 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
Gfx_1C_5710_HotSpotEd_ShowJump::
    INCBIN "data/bank_1c/Gfx_1C_5710_HotSpotEd_ShowJump.2bpp" ; $5710, 16 bytes
; I: 64 bytes of tile-like data between Gfx_1C_5710_HotSpotEd_ShowJump (16 bytes copied) and the icon table 5760; no
; copy reads it; was Data_1C_5720
TileGap_1C_5720::
    INCBIN "data/bank_1c/TileGap_1C_5720.2bpp" ; $5720, 64 bytes
; C: 64-byte entries: 03:74EA-7504 copies 64 bytes from $5760 + A x 64 to $8CF0 (A = byte of the table $D657 indexed
; by $D665, swap a then two shifts left); the icons of the hot-spot editor; the block 57A0-58A0 was
; Gfx_1C_57A0_..._Aux. Extent of the table not known (the extra icons at 5920 are ...
Gfx_1C_5760_HotSpotEd_ShowEffectIcon::
    INCBIN "data/bank_1c/Gfx_1C_5760_HotSpotEd_ShowEffectIcon.2bpp" ; $5760, 320 bytes
; C: copied to VRAM/WRAM by Mode0C_State02_Setup, Mode0F_State05_ConfirmInit (roms/jp_rev_a/assets/catalog_jp.csv). L3
; pass 2026-10-26: read in BGB in 33 replay(s) of the organic corpus, modes 0F 1A (tcrf_check/assets/l3_names/)
Gfx_1C_58A0_Mode0C_State02_Setup::
    INCBIN "data/bank_1c/Gfx_1C_58A0_Mode0C_State02_Setup.2bpp" ; $58A0, 128 bytes
; I: TCRF unused graphics: the 8 extra hot-spot effect icons (32 tiles); on screen only in runs that force the effect
; number above 7 (README 16.8, 16.24). L3 pass 2026-10-26: copied to VRAM with the block around it (read in BGB in 33
; replay(s) of the organic corpus, modes 0F) but never displayed, as ...
Unused_TCRF_HotSpotEffectIcons_Extra_Gfx::
    INCBIN "data/bank_1c/Unused_TCRF_HotSpotEffectIcons_Extra_Gfx.2bpp" ; $5920, 512 bytes
; I: continues the span of Gfx_1C_58A0_Mode0C_State02_Setup (the label before the TCRF-unused block)
Gfx_1C_5B20_Mode0C_State02_Setup_Cont::
    INCBIN "data/bank_1c/Gfx_1C_5B20_Mode0C_State02_Setup_Cont.2bpp" ; $5B20, 64 bytes
; C: copied to VRAM/WRAM by Mode0C_State02_Setup, Mode0F_State05_ConfirmInit (roms/jp_rev_a/assets/catalog_jp.csv). L3
; pass 2026-10-26: read in BGB in 33 replay(s) of the organic corpus, modes 0F (tcrf_check/assets/l3_names/)
Gfx_1C_5B60_Mode0C_State02_Setup::
    INCBIN "data/bank_1c/Gfx_1C_5B60_Mode0C_State02_Setup.2bpp" ; $5B60, 32 bytes
; C: far pointer loaded by Mode1A_State02_Setup, Mode09_State02_PhotoArrows, Mode0A_State04_PhotoArrows,
; Mode14_State04_OptionsPage, Mode1C_State04_OptionsMenu (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 66 replay(s) of the organic corpus, modes 09 0A 0F 14 1A ...
Gfx_1C_5B80_Mode09_State02_PhotoArrows::
    INCBIN "data/bank_1c/Gfx_1C_5B80_Mode09_State02_PhotoArrows.2bpp" ; $5B80, 64 bytes
; I: 32 bytes of tile-like data between two loaded PhotoArrows blocks (5B80+0x40 and 5BE0): no copy reads it; was
; Data_1C_5BC0 + TileGap_1C_5BDA
TileGap_1C_5BC0::
    INCBIN "data/bank_1c/TileGap_1C_5BC0.2bpp" ; $5BC0, 32 bytes
; C: far pointer loaded by Mode09_State02_PhotoArrows, Mode0A_State04_PhotoArrows, Mode14_State04_OptionsPage (ld
; a,BANK; ld hl,ADDR; call banked copy/far call); length 64 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in
; 48 replay(s) of the organic corpus, modes 09 0A 14 ...
Gfx_1C_5BE0_Mode09_State02_PhotoArrows::
    INCBIN "data/bank_1c/Gfx_1C_5BE0_Mode09_State02_PhotoArrows.2bpp" ; $5BE0, 64 bytes
; C: tile data with no direct pointer in the code (, same bank/neighbour of Mode09_State02_PhotoArrows); classified
; from its content - see sym_unconclusive. Owner (review page, 2026-10-13): graphic, by eye.
Gfx_1C_5C20_Mode09_State02_PhotoArrows_Aux::
    INCBIN "data/bank_1c/Gfx_1C_5C20_Mode09_State02_PhotoArrows_Aux.2bpp" ; $5C20, 64 bytes
; C: copied to VRAM/WRAM by Mode0C_State02_Setup, Mode0F_State05_ConfirmInit (roms/jp_rev_a/assets/catalog_jp.csv). L3
; pass 2026-10-26: read in BGB in 33 replay(s) of the organic corpus, modes 0F (tcrf_check/assets/l3_names/)
Gfx_1C_5C60_Mode0C_State02_Setup::
    INCBIN "data/bank_1c/Gfx_1C_5C60_Mode0C_State02_Setup.2bpp" ; $5C60, 32 bytes
; C: far pointer loaded by Mode1A_State02_Setup, Mode09_State02_PhotoArrows, Mode0A_State04_PhotoArrows,
; Mode14_State04_OptionsPage, Mode1C_State04_OptionsMenu (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 66 replay(s) of the organic corpus, modes 09 0A 0F 14 1A ...
Gfx_1C_5C80_Mode09_State02_PhotoArrows::
    INCBIN "data/bank_1c/Gfx_1C_5C80_Mode09_State02_PhotoArrows.2bpp" ; $5C80, 64 bytes
; I: 32 bytes of tile-like data between two loaded PhotoArrows blocks (5C80+0x40 and 5CE0): no copy reads it; was
; Data_1C_5CC0 + TileGap_1C_5CCB + Data_1C_5CD3
TileGap_1C_5CC0::
    INCBIN "data/bank_1c/TileGap_1C_5CC0.2bpp" ; $5CC0, 32 bytes
; C: far pointer loaded by Mode09_State02_PhotoArrows, Mode0A_State04_PhotoArrows, Mode14_State04_OptionsPage (ld
; a,BANK; ld hl,ADDR; call banked copy/far call); length 64 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in
; 48 replay(s) of the organic corpus, modes 09 0A 14 ...
Gfx_1C_5CE0_Mode09_State02_PhotoArrows::
    INCBIN "data/bank_1c/Gfx_1C_5CE0_Mode09_State02_PhotoArrows.2bpp" ; $5CE0, 64 bytes
; I: 64 bytes of tile-like data after the PhotoArrows block 5CE0 (0x40 copied) and before Gfx_1C_5D60: no copy reads
; it; was Data_1C_5D20 + TileGap_1C_5D47 + Data_1C_5D48
TileGap_1C_5D20::
    INCBIN "data/bank_1c/TileGap_1C_5D20.2bpp" ; $5D20, 64 bytes
; C: far pointer loaded by HotSpotEd_ShowJumpThumb, Mode1A_State04_PlaceOrDelete, Mode1A_State09_ExitDialog (ld
; a,BANK; ld hl,ADDR; call banked copy/far call); length 192 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in
; 6 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
Gfx_1C_5D60_Mode1A_State04_PlaceOrDelete::
    INCBIN "data/bank_1c/Gfx_1C_5D60_Mode1A_State04_PlaceOrDelete.2bpp" ; $5D60, 192 bytes
; C: far pointer loaded by HotSpotEd_ShowJumpThumb, Mode1A_State04_PlaceOrDelete, Mode1A_State09_ExitDialog (ld
; a,BANK; ld hl,ADDR; call banked copy/far call); length 64 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in
; 6 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
Gfx_1C_5E20_Mode1A_State04_PlaceOrDelete::
    INCBIN "data/bank_1c/Gfx_1C_5E20_Mode1A_State04_PlaceOrDelete.2bpp" ; $5E20, 64 bytes
; I: copied to VRAM/WRAM by Link_ShowScreenA, Link_ShowScreenB (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass
; 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code: tiles loaded
; by Link_ShowScreenA and Link_ShowScreenB (07:4B0F / 4B74, $800 B to $9000)
Gfx_1C_5E60_Link_ShowScreenA::
    INCBIN "data/bank_1c/Gfx_1C_5E60_Link_ShowScreenA.2bpp" ; $5E60, 1808 bytes
; I: copied to VRAM/WRAM by Link_ShowScreenA, Link_ShowScreenB (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass
; 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code: tiles loaded
; by Link_ShowScreenA and Link_ShowScreenB (07:4B1D / 4B82, $700 B to $8800)
Gfx_1C_6570_Link_ShowScreenA::
    INCBIN "data/bank_1c/Gfx_1C_6570_Link_ShowScreenA.2bpp" ; $6570, 240 bytes
; C: loaded by Mem_CopyFromBank at 07:4AE3: Gfx $700 bytes to $8800 (this build's trace)
Gfx_1C_6660_Link_ShowScreenA::
    INCBIN "data/bank_1c/Gfx_1C_6660_Link_ShowScreenA.2bpp" ; $6660, 1776 bytes
; C: far pointer loaded by Link_ShowScreenA, Link_ShowScreenB (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3
; pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code: tile
; loaded by Link_ShowScreenA and Link_ShowScreenB (07:4B2B / 4B90, 16 B to ...
Gfx_1C_6D50_Link_ShowScreenB::
    INCBIN "data/bank_1c/Gfx_1C_6D50_Link_ShowScreenB.2bpp" ; $6D50, 16 bytes
; C: copied to VRAM/WRAM by Mode1F_State08_EditPagesSetup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1F)
Data_1C_6D60_Mode1F_State07_QuitPanel::
    db $00, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff
    db $00, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff

; C: copied to VRAM/WRAM by Mode1F_State07_QuitPanel (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not
; reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1F)
Gfx_1C_6D60_Mode1F_State07_QuitPanel_Part6DE0::
    INCBIN "data/bank_1c/Gfx_1C_6D60_Mode1F_State07_QuitPanel_Part6DE0.2bpp" ; $6DE0, 128 bytes
; C: far pointer loaded by Mode1F_State08_EditPagesSetup (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1F)
Src_1C_6E60_Mode1F_State08_EditPagesSetup::
    INCBIN "data/bank_1c/Src_1C_6E60_Mode1F_State08_EditPagesSetup.bin" ; $6E60, 256 bytes
; C: far pointer loaded by Mode1F_State08_EditPagesSetup (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1F)
Src_1C_6F60_Mode1F_State08_EditPagesSetup::
    INCBIN "data/bank_1c/Src_1C_6F60_Mode1F_State08_EditPagesSetup.bin" ; $6F60, 256 bytes
; C: far pointer loaded by Mode1F_State08_EditPagesSetup (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1F)
Src_1C_7060_Mode1F_State08_EditPagesSetup::
    INCBIN "data/bank_1c/Src_1C_7060_Mode1F_State08_EditPagesSetup.bin" ; $7060, 512 bytes
; C: copied to VRAM/WRAM by Mode1F_State08_EditPagesSetup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1F)
Gfx_1C_7260_Mode1F_State08_EditPagesSetup::
    INCBIN "data/bank_1c/Gfx_1C_7260_Mode1F_State08_EditPagesSetup.2bpp" ; $7260, 1536 bytes
; I: copied to VRAM/WRAM by Mode1F_State08_EditPagesSetup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1F)
Gfx_1C_7860_Mode1F_State08_EditPagesSetup::
    INCBIN "data/bank_1c/Gfx_1C_7860_Mode1F_State08_EditPagesSetup.2bpp" ; $7860, 1024 bytes
; C: copied to VRAM/WRAM by Mode08_CreditsReal (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 6 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Map_1C_7C60_Mode08_CreditsReal::
    INCBIN "data/bank_1c/Map_1C_7C60_Mode08_CreditsReal.tilemap" ; $7C60, 160 bytes
; C: far pointer loaded by Mode08_State13_CreditsPageA (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 6 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Map_1C_7D00_Mode08_State13_CreditsPageA::
    INCBIN "data/bank_1c/Map_1C_7D00_Mode08_State13_CreditsPageA.tilemap" ; $7D00, 416 bytes
; C: far pointer loaded by Mode08_State13_CreditsPageA (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 352
; from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the organic corpus, modes 08
; (tcrf_check/assets/l3_names/)
Map_1C_7EA0_Mode08_State13_CreditsPageA::
    INCBIN "data/bank_1c/Map_1C_7EA0_Mode08_State13_CreditsPageA.tilemap" ; $7EA0, 352 bytes
