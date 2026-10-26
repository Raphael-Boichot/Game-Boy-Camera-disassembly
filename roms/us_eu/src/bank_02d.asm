; Game Boy Camera (USA, Europe), bank $2D. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $02d", ROMX[$4000], BANK[$2d]

    db $1f, $1f, $3f, $3f, $7f, $7f, $ff, $ff, $f0, $f0, $f0, $f0, $f0, $f0, $60, $60
    db $c0, $c0, $e0, $e0, $f0, $f0, $ff, $ef, $7f, $40, $3f, $20, $3f, $20, $3f, $20
    db $03, $03, $07, $07, $0f, $0f, $ff, $f7, $fe, $02, $fc, $04, $fc, $04, $fc, $04
    db $f8, $f8, $fc, $fc, $fe, $fe, $ff, $ff, $0f, $0f, $0f, $0f, $0f, $0f, $06, $06
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01
    db $3f, $20, $39, $20, $31, $20, $31, $20, $37, $26, $77, $66, $ff, $80, $ff, $00
    db $fc, $04, $9c, $04, $8c, $04, $8c, $04, $ec, $64, $ee, $66, $ff, $01, $ff, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80
    db $03, $02, $07, $04, $07, $04, $07, $04, $07, $04, $07, $04, $03, $02, $01, $01
    db $ff, $00, $ff, $00, $ff, $03, $ff, $07, $ff, $07, $ff, $07, $ff, $03, $ff, $00
    db $ff, $00, $ff, $00, $ff, $e0, $ff, $f0, $bf, $b0, $ff, $f0, $ff, $e0, $ff, $80
    db $c0, $40, $e0, $20, $e0, $20, $e0, $20, $e0, $20, $e0, $20, $c0, $40, $80, $80

    ; padding
    ds $10, $00

    db $ff, $81, $7f, $7e, $1f, $10, $0f, $08, $1f, $1f, $20, $3f, $1f, $1f, $00, $00
    db $ff, $41, $fe, $3e, $fc, $04, $f8, $08, $fc, $fc, $02, $fe, $fc, $fc

    ; padding
    ds $16, $00

    db $01, $01, $03, $03, $06, $07, $0d, $0f, $0b, $0f, $17, $1f, $1f, $1f, $70, $7f
    db $c7, $ff, $1f, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f0, $f0, $1c, $fc
    db $c7, $ff, $f1, $ff, $fc, $ff, $fe, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00
    db $00, $00, $80, $80, $c0, $c0, $60, $e0, $20, $e0, $b0, $f0, $1f, $1f, $3f, $3f
    db $3f, $3f, $3f, $3f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f

    ; padding
    ds $20, $ff

    db $d0, $f0, $d8, $f8, $e8, $f8, $e8, $f8, $f8, $f8, $fc, $fc, $fc, $fc, $fc, $fc
    db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $3f, $3f, $3f, $3f, $3f, $3f, $1f, $1f

    ; padding
    ds $1c, $ff

    db $fe, $fe, $fe, $fe, $fc, $fc, $fc, $fc, $f8, $f8, $e0, $e0, $80, $80, $00, $00
    db $00, $00, $00, $00, $1f, $1f, $0f, $0f, $07, $07, $03, $03, $01, $01, $00, $00
    db $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $7f
    db $0f, $0f, $00, $00, $fc, $fc, $fc, $fc, $f8, $f8, $f8, $f8, $f8, $f8, $f0, $f0
    db $e0, $e0

    ; padding
    ds $18, $00

    db $01, $01, $03, $03, $06, $07, $04, $07, $0d, $0f, $0f, $0f, $38, $3f, $e1, $ff
    db $8f, $ff, $3f, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $f8, $f8, $0e, $fe, $e3, $ff
    db $f8, $ff, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $80, $80
    db $c0, $c0, $60, $e0, $b0, $f0, $d0, $f0, $e8, $f8, $0b, $0f, $1b, $1f, $17, $1f
    db $17, $1f, $1f, $1f, $3f, $3f, $3f, $3f, $3f, $3f

    ; padding
    ds $20, $ff

    db $f8, $f8, $fc, $fc, $fc, $fc, $fc, $fc, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $3f, $3f, $3f, $3f, $1f, $1f, $07, $07, $01, $01, $00, $00, $00, $00, $00, $00
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $7f, $7f, $7f

    ; padding
    ds $10, $ff

    db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fc, $fc, $fc, $fc, $fc, $fc, $f8, $f8

    ; padding
    ds $10, $00

    db $3f, $3f, $3f, $3f, $1f, $1f, $1f, $1f, $1f, $1f, $0f, $0f, $07, $07, $00, $00
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $fe, $f0, $f0, $00, $00
    db $f8, $f8, $f0, $f0, $e0, $e0, $c0, $c0, $80, $80

    ; padding
    ds $14, $00

    db $07, $07, $01, $01, $06, $07, $08, $0f, $10, $1f, $10, $1f, $10, $1f, $10, $1f
    db $f0, $ff, $c0, $c0, $20, $e0, $20, $e0, $10, $70, $10, $70, $08, $f8, $08, $78
    db $1f, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $c0, $c0, $08, $08, $10, $10, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    db $30, $20, $18, $0f, $0f, $07, $07, $00, $00, $00, $00, $00, $00, $00, $01, $00
    db $01, $01, $30, $e0, $e0, $c0, $c0, $00, $00, $00, $00, $00, $00, $00, $80, $00
    db $c0, $80, $20, $20, $10, $10, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
    db $c8, $08, $30, $20, $19, $10, $19, $10, $19, $11, $1f, $19, $1f, $16, $1f, $30
    db $1b, $54, $63, $42, $f7, $a4, $ff, $a4, $7e, $99, $ff, $00, $f7, $08, $7f, $80
    db $ff, $00, $e0, $40, $b1, $61, $f1, $21, $ff, $12, $fe, $0d, $ff, $00, $ef, $10
    db $bd, $42, $e8, $c8, $f8, $28, $b0, $50, $f0, $10, $f0, $10, $f0, $18, $b0, $54
    db $f0, $12, $0e, $89, $07, $87, $00, $80, $00, $80, $00, $40, $00, $20, $00, $18
    db $00, $07, $f7, $08, $ff, $ff, $00, $80, $00, $7f, $00, $00, $00, $00, $00, $00
    db $00, $ff, $ff, $00, $ff, $ff, $00, $01, $00, $fe, $00, $00, $00, $00, $00, $00
    db $00, $ff, $e0, $21, $c0, $c1, $00, $01, $00, $01, $00, $02, $00, $04, $00, $18
    db $00, $e0, $70, $70, $fc, $cc, $bf, $b3, $8f, $8c, $83, $83, $40, $40, $40, $40
    db $40, $40, $00, $00, $00, $00, $80, $80, $f8, $78, $ff, $07, $ff, $e0, $1f, $18
    db $07, $06, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $c0, $f0, $30
    db $fc, $0c

    ; padding
    ds $10, $00

    db $20, $20, $20, $20, $20, $20, $10, $10, $10, $10, $08, $08, $08, $08, $04, $04
    db $01, $01, $00, $00, $01, $01, $00, $00, $00, $00, $03, $03, $01, $01, $00, $00
    db $fe, $82, $7f, $41, $7f, $60, $9f, $90, $4f, $48, $cf, $c8, $07, $04, $87, $84
    db $00, $00, $00, $00, $c0, $c0, $e0, $20, $f0, $10, $f8, $08, $fe, $06, $ff, $01
    db $02, $02, $02, $02, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $07, $07, $02, $02, $01, $01, $80, $80, $80, $80, $40, $40, $40, $40, $20, $20
    db $c7, $c4, $07, $04, $87, $84, $6f, $68, $0c, $08, $18, $10, $10, $10, $20, $20
    db $ff, $00, $f8, $00, $c0

    ; padding
    ds $1b, $00

    db $20, $20, $10, $10, $10, $10, $08, $08, $08, $08, $08, $08, $00, $00, $00, $00
    db $40, $40

    ; padding
    ds $38, $00

    db $03, $03, $0f, $0c, $3f, $30, $00, $00, $00, $00, $01, $01, $1f, $1e, $ff, $e0
    db $ff, $07, $f8, $18, $e0, $60, $0e, $0e, $3f, $33, $fd, $cd, $f1, $31, $c1, $c1
    db $02, $02, $02, $02, $02, $02, $00, $00, $00, $00, $03, $03, $07, $04, $0f, $08
    db $1f, $10, $7f, $60, $ff, $80, $7f, $41, $fe, $82, $fe, $06, $f9, $09, $f2, $12
    db $f3, $13, $e0, $20, $e1, $21, $80, $80, $00, $00, $80, $80, $00, $00, $00, $00
    db $c0, $c0, $80, $80, $00, $00, $04, $04, $04, $04, $04, $04, $08, $08, $08, $08
    db $10, $10, $10, $10, $20, $20, $ff, $00, $1f, $00, $03, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $e3, $23, $e0, $20, $e1, $21, $f6, $16, $30, $10
    db $18, $08, $08, $08, $04, $04, $e0, $e0, $40, $40, $80, $80, $01, $01, $01, $01
    db $02, $02, $02, $02, $04, $04, $40, $40, $40, $40, $80, $80

    ; padding
    ds $1a, $00

    db $02, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $04, $04, $08, $08, $08, $08, $10, $10, $10, $10, $10, $10

    ; padding
    ds $2c, $00

    db $01, $03, $03, $02, $06, $04, $04, $04, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $80, $80, $80, $c0, $40, $40, $40

    ; padding
    ds $18, $00

    db $0f, $1f, $18, $10, $18, $10, $0c, $08, $0c, $08, $08, $08, $18, $10, $10, $10
    db $f0, $e0, $00, $00, $00, $00, $00, $00, $60, $20, $20, $20, $30, $10, $10, $10
    db $1f, $0f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $e0, $f0, $30, $10, $30, $10, $60, $20, $06, $04, $03, $02, $01, $01, $00, $00
    db $00, $00, $00, $00, $01, $01, $01, $01, $00, $00, $00, $00, $80, $00, $c0, $80
    db $c0, $80, $80, $80, $83, $00, $87, $03, $00, $00, $01, $00, $03, $01, $06, $02
    db $06, $02, $02, $02, $83, $01, $c3, $81, $c0, $40, $80, $80, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $03, $02, $02, $02, $03, $02
    db $01, $03, $00, $00, $00, $00, $00, $00, $0c, $04, $18, $18, $60, $20, $c0, $40
    db $80, $80, $00, $00, $00, $00, $00, $00, $61, $41, $31, $30, $0c, $08, $06, $04
    db $03, $03, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $80, $80, $80, $80
    db $00, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $01, $01
    db $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7c, $38, $c4, $c4, $1c, $18
    db $f0, $e0, $0f, $0f, $3f, $30, $7f, $40, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $80, $80, $c0, $40

    ; padding
    ds $1a, $00

    db $7f, $7f, $42, $42, $21, $21, $6e, $40, $f3, $80, $ff, $85, $ff, $d7, $69, $69
    db $30, $30, $b8, $b8, $47, $47, $e0, $20, $e0, $20, $e0, $a0, $60, $60, $40, $40
    db $7f, $7f, $f0, $a0, $ff, $ff, $00, $00, $00, $00, $0c, $0c, $14, $14, $24, $24
    db $c4, $c4, $04, $04, $e4, $c4, $38, $30, $21, $20, $19, $19, $07, $05, $03, $03
    db $01, $01, $01, $01, $01, $01, $83, $81, $a0, $80, $b0, $30, $08, $08, $06, $06
    db $03, $03, $0c, $0c, $80, $00, $c6, $46, $87, $87, $18, $08, $30, $10, $60, $20
    db $e0, $e0, $10, $10, $18, $08, $b4, $a4, $1c, $14, $0c, $0c

    ; padding
    ds $1a, $00

    db $80, $80, $c0, $80, $61, $41, $3f, $23, $1e, $1e, $00, $00, $00, $00, $00, $00
    db $0f, $07, $81, $81, $e1, $c1, $e7, $e6, $7f, $78, $0f, $0c, $03, $03, $00, $00
    db $00, $00, $00, $00, $00, $00, $f0, $f0, $f0, $10, $e0, $60, $80, $80

    ; padding
    ds $1e, $00

    db $30, $30, $28, $28, $00, $00, $00, $00, $00, $00, $7c, $78, $87, $87, $70, $70
    db $1f, $0f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80

    ; padding
    ds $12, $00

    db $10, $10, $14, $14, $15, $15, $2f, $26, $2b, $2a, $5b, $4a, $59, $49, $5a, $4a
    db $7a, $7a, $f8, $f8, $fc, $04, $7e, $02, $9f, $01, $e3, $81, $7f, $61, $5f, $51
    db $1f, $13, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $f0, $f0
    db $1e, $1e, $2f, $2f, $40, $40, $2f, $2f, $10, $10, $00, $00, $00, $00, $00, $00
    db $00, $00, $cf, $cf, $47, $43, $e0, $c0, $70, $70, $5c, $58, $5f, $4f, $58, $48
    db $28, $28, $3e, $32, $bc, $ac, $00, $00, $03, $03, $80, $80, $88, $80, $50, $50
    db $30, $30, $12, $12, $26, $26, $4c, $4c, $b8, $b8, $e0, $e0, $20, $20, $10, $10
    db $90, $10

    ; padding
    ds $10, $00

    db $2c, $24, $14, $14, $14, $14, $28, $28, $30, $30, $00, $00, $00, $00, $00, $00
    db $21, $20, $27, $21, $23, $23, $11, $11, $08, $08, $09, $08, $0b, $09, $0e, $0e
    db $90, $90, $90, $10, $8c, $0c, $c2, $82, $f2, $e2, $92, $92, $16, $12, $0c, $0c
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01
    db $00, $00, $03, $03, $04, $04, $08, $08, $08, $08, $78, $78, $88, $88, $00, $00
    db $00, $00, $c0, $c0, $20, $20, $10, $10, $10, $10, $10, $10, $1e, $1e, $21, $21

    ; padding
    ds $10, $00

    db $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $03, $03, $07, $04, $07, $04, $87, $84, $73, $73, $20, $20, $40, $40, $41, $41
    db $80, $80, $c0, $40, $c0, $40, $c0, $40, $80, $80, $09, $09, $06, $06, $04, $04
    db $80, $80, $80, $80, $80, $80, $80, $80, $80, $80

    ; padding
    ds $16, $00

    db $41, $41, $23, $23, $1d, $1d, $01, $01, $01, $01, $01, $01, $01, $01, $f1, $f1
    db $04, $04, $88, $88, $70, $70, $00, $00, $00, $00, $3c, $3c, $42, $7e, $81, $ff

    ; padding
    ds $10, $00

    db $01, $01, $02, $03, $02, $03, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00
    db $0d, $fd, $03, $ff, $01, $ff, $07, $ff, $f9, $f9, $01, $01, $00, $00, $00, $00
    db $01, $ff, $c2, $fe, $3c, $3c

    ; padding
    ds $28, $00

    db $0c, $0c

    ; padding
    ds $30, $00

    db $0f, $0b, $0f, $0c, $0b, $0b, $08, $08, $04, $04, $04, $04, $04, $04, $02, $02
    db $00, $00, $f0, $f0, $fe, $0e, $ff, $e1, $3f, $1c, $07, $03, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $c0, $c0, $f8, $38, $ff, $87, $ff, $70, $3f, $0c
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $c0, $e0, $20
    db $02, $02, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $07, $00, $01, $00, $00, $00, $81, $80, $82, $80, $40, $40, $20, $20, $10, $10
    db $ef, $02, $03, $01, $c3, $01, $03, $01, $02, $02, $c4, $04, $38, $08, $10, $10
    db $f0, $10, $e0, $60, $80, $80

    ; padding
    ds $1a, $00

    db $08, $08, $06, $06, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $20, $20, $40, $40, $40, $40, $80, $80

    ; padding
    ds $56, $00

    db $30, $30, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $03
    db $07, $04, $00, $00, $00, $00, $00, $00, $03, $03, $1f, $1c, $ff, $e1, $ff, $0e
    db $fc, $30, $00, $00, $0f, $0f, $7f, $70, $ff, $87, $fc, $38, $e0, $c0, $00, $00
    db $00, $00, $f0, $d0, $f0, $30, $d0, $d0, $10, $10, $20, $20, $20, $20, $20, $20
    db $40, $40, $0f, $08, $07, $06, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $f7, $40, $c0, $80, $c3, $80, $c0, $80, $40, $40, $23, $20, $1c, $10
    db $08, $08, $e0, $00, $80, $00, $00, $00, $81, $01, $41, $01, $02, $02, $04, $04
    db $08, $08, $40, $40, $80, $80, $80, $80

    ; padding
    ds $1a, $00

    db $04, $04, $02, $02, $02, $02, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00
    db $10, $10, $60, $60, $80, $80

    ; padding
    ds $24, $00

    db $03, $03, $03, $03, $07, $07, $00, $00, $00, $00, $03, $03, $7c, $7c, $ff, $ff
    db $ff, $ff, $f8, $f8, $ef, $ef, $00, $00, $00, $00, $f8, $f8, $fe, $fe, $7f, $7f
    db $bf, $bf, $df, $df, $07, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $80, $80, $c0, $c0, $07, $07, $07, $07, $0f, $0f, $0e, $0e, $4d, $4d
    db $6d, $6d, $35, $35, $35, $35, $df, $df, $9f, $9f, $3c, $3c, $bb, $bb, $bb, $bb
    db $da, $da, $c2, $c2, $e8, $e8, $bb, $bb, $dd, $dd, $6d, $6d, $8e, $8e, $6e, $6e
    db $ee, $ee, $ee, $ee, $de, $de, $c0, $c0, $e0, $e0, $f0, $f0, $f0, $f0, $f0, $f0
    db $f0, $f0, $f0, $f0, $f0, $f0, $39, $39, $3d, $3d, $1d, $1d, $0e, $0e, $02, $02
    db $10, $10, $1c, $1c, $0f, $0f, $ef, $ef, $f7, $f7, $f3, $f3, $fd, $fd, $fe, $fe
    db $7f, $7f, $3f, $3f, $8f, $8f, $3e, $3e, $fd, $fd, $fb, $fb, $e7, $e7, $1f, $1f
    db $7f, $7f, $81, $81, $e4, $e4, $f0, $f0, $f0, $f0, $e0, $e0, $e0, $e0, $c0, $c0
    db $00, $00, $c0, $c0, $e0, $e0, $1c, $1c, $33, $33, $2f, $2f, $7f, $7f, $70, $70
    db $40, $40, $00, $00, $00, $00, $60, $60, $e0, $e0, $c0, $c0, $80, $80, $00, $00
    db $00, $00, $00, $00, $00, $00, $07, $07, $07, $07, $07, $07, $03, $03, $01, $01
    db $01, $01, $00, $00, $00, $00, $70, $70, $b0, $b0, $f8, $f8, $f8, $f8, $9c, $9c
    db $0c, $0c, $04, $04

    ; padding
    ds $2, $00

; I: stamp category 1: icons (wings, flowers, paw, dog, stars...), 45 items x $100 B (16 tiles 2bpp)
StampCat01_Icons_Gfx::
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $07
    db $07
    db $1f
    db $1f
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $80
    db $c0
    db $e0
    db $f0
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $01
    db $01
    db $03
    db $03
    db $03
    db $03
    db $07
    db $03
    db $07
    db $07
    db $07
    db $60
    db $7f
    db $9f
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $38
    db $f8
    db $cc
    db $fc
    db $f6
    db $fe
    db $fa
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $80
    db $80
    db $80
    db $80
    db $80
    db $07
    db $07
    db $07
    db $07
    db $07
    db $07
    db $07
    db $07
    db $03
    db $07
    db $03
    db $07
    db $01
    db $03
    db $01
    db $03
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $fe
    db $ff
    db $fc
    db $fc
    db $f8
    db $f8
    db $f0
    db $f8
    db $f0
    db $f0
    db $80
    db $80
    db $80
    db $80
    db $00
    db $80
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $01
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $7f
    db $ff
    db $1f
    db $3f
    db $03
    db $0f
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $e0
    db $f0
    db $e0
    db $e0
    db $c0
    db $e0
    db $00
    db $c0
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $01
    db $03
    db $07
    db $0f
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $e0
    db $e0
    db $f8
    db $f8
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $01
    db $01
    db $01
    db $01
    db $01
    db $1c
    db $1f
    db $33
    db $3f
    db $6f
    db $7f
    db $5f
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $06
    db $fe
    db $f9
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $00
    db $00
    db $00
    db $00
    db $00
    db $80
    db $80
    db $c0
    db $c0
    db $c0
    db $c0
    db $e0
    db $c0
    db $e0
    db $e0
    db $e0
    db $01
    db $01
    db $01
    db $01
    db $00
    db $01
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $7f
    db $ff
    db $3f
    db $3f
    db $1f
    db $1f
    db $0f
    db $1f
    db $0f
    db $0f
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $e0
    db $e0
    db $e0
    db $e0
    db $e0
    db $e0
    db $e0
    db $e0
    db $c0
    db $e0
    db $c0
    db $e0
    db $80
    db $c0
    db $80
    db $c0
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $07
    db $0f
    db $07
    db $07
    db $03
    db $07
    db $00
    db $03
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $fe
    db $ff
    db $f8
    db $fc
    db $c0
    db $f0
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $80
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $1c
    db $1c
    db $3e
    db $3e
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $38
    db $38
    db $7c
    db $7c
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $0c
    db $0c
    db $1e
    db $1e
    db $1e
    db $1e
    db $3f
    db $3f
    db $3f
    db $3f
    db $3f
    db $3f
    db $3e
    db $3e
    db $7e
    db $7e
    db $7e
    db $7e
    db $7e
    db $7e
    db $7e
    db $7e
    db $3e
    db $3e
    db $1c
    db $1c
    db $00
    db $00
    db $7c
    db $7c
    db $7e
    db $7e
    db $7e
    db $7e
    db $7e
    db $7e
    db $7e
    db $7e
    db $7c
    db $7c
    db $38
    db $38
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $30
    db $30
    db $78
    db $78
    db $78
    db $78
    db $f8
    db $f8
    db $1f
    db $1f
    db $1f
    db $1f
    db $0e
    db $0e
    db $00
    db $00
    db $01
    db $01
    db $01
    db $01
    db $03
    db $03
    db $03
    db $03
    db $0f
    db $0f
    db $3f
    db $3f
    db $7f
    db $7f
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $e0
    db $e0
    db $f8
    db $f8
    db $fc
    db $fc
    db $fe
    db $fe
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $f8
    db $f8
    db $f8
    db $f8
    db $70
    db $70
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $80
    db $80
    db $80
    db $80
    db $03
    db $03
    db $01
    db $01
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $ff
    db $ff
    db $7f
    db $7f
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $ff
    db $ff
    db $fc
    db $fc
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $80
    db $80
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $01
    db $01
    db $02
    db $02
    db $02
    db $02
    db $06
    db $04
    db $06
    db $04
    db $00
    db $00
    db $3c
    db $3c
    db $c3
    db $c3
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $80
    db $80
    db $40
    db $40
    db $40
    db $40
    db $20
    db $20
    db $20
    db $20
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $06
    db $04
    db $03
    db $02
    db $03
    db $02
    db $01
    db $01
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $80
    db $00
    db $c3
    db $00
    db $ff
    db $c3
    db $3f
    db $3c
    db $1f
    db $10
    db $1e
    db $10
    db $20
    db $20
    db $40
    db $40
    db $c0
    db $40
    db $80
    db $80
    db $c0
    db $40
    db $c0
    db $40
    db $20
    db $20
    db $20
    db $20
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $0e
    db $08
    db $0f
    db $08
    db $0f
    db $08
    db $07
    db $04
    db $07
    db $04
    db $07
    db $04
    db $03
    db $02
    db $03
    db $02
    db $10
    db $10
    db $10
    db $10
    db $08
    db $08
    db $08
    db $08
    db $84
    db $04
    db $84
    db $04
    db $c2
    db $02
    db $c2
    db $02
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $03
    db $02
    db $01
    db $01
    db $01
    db $01
    db $01
    db $01
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $c1
    db $01
    db $e1
    db $01
    db $e0
    db $00
    db $f0
    db $00
    db $f0
    db $80
    db $e0
    db $80
    db $c0
    db $80
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $80
    db $80
    db $80
    db $80
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $01
    db $01
    db $02
    db $02
    db $02
    db $02
    db $04
    db $04
    db $04
    db $04
    db $00
    db $00
    db $3c
    db $3c
    db $c3
    db $c3
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $80
    db $80
    db $40
    db $40
    db $40
    db $40
    db $60
    db $20
    db $60
    db $20
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $04
    db $04
    db $02
    db $02
    db $03
    db $02
    db $01
    db $01
    db $03
    db $02
    db $03
    db $02
    db $04
    db $04
    db $04
    db $04
    db $00
    db $00
    db $00
    db $00
    db $01
    db $00
    db $c3
    db $00
    db $ff
    db $c3
    db $fc
    db $3c
    db $f8
    db $08
    db $78
    db $08
    db $60
    db $20
    db $c0
    db $40
    db $c0
    db $40
    db $80
    db $80
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $08
    db $08
    db $08
    db $08
    db $10
    db $10
    db $10
    db $10
    db $21
    db $20
    db $21
    db $20
    db $43
    db $40
    db $43
    db $40
    db $70
    db $10
    db $f0
    db $10
    db $f0
    db $10
    db $e0
    db $20
    db $e0
    db $20
    db $e0
    db $20
    db $c0
    db $40
    db $c0
    db $40
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $01
    db $01
    db $01
    db $01
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $83
    db $80
    db $87
    db $80
    db $07
    db $00
    db $0f
    db $00
    db $0f
    db $01
    db $07
    db $01
    db $03
    db $01
    db $00
    db $00
    db $c0
    db $40
    db $80
    db $80
    db $80
    db $80
    db $80
    db $80
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $01
    db $01
    db $02
    db $02
    db $04
    db $04
    db $08
    db $08
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $7e
    db $7e
    db $81
    db $81
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $80
    db $80
    db $40
    db $40
    db $20
    db $20
    db $10
    db $10
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $08
    db $08
    db $08
    db $08
    db $11
    db $11
    db $11
    db $11
    db $11
    db $11
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $00
    db $00
    db $00
    db $00
    db $86
    db $86
    db $86
    db $86
    db $86
    db $86
    db $00
    db $00
    db $00
    db $00
    db $78
    db $78
    db $10
    db $10
    db $10
    db $10
    db $08
    db $08
    db $08
    db $08
    db $08
    db $08
    db $08
    db $08
    db $08
    db $08
    db $08
    db $08
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $10
    db $10
    db $10
    db $10
    db $20
    db $20
    db $40
    db $40
    db $40
    db $40
    db $44
    db $44
    db $3c
    db $3c
    db $02
    db $02
    db $00
    db $00
    db $00
    db $00
    db $01
    db $01
    db $02
    db $02
    db $02
    db $02
    db $02
    db $02
    db $01
    db $01
    db $00
    db $00
    db $08
    db $08
    db $88
    db $88
    db $07
    db $07
    db $00
    db $00
    db $00
    db $00
    db $40
    db $40
    db $80
    db $80
    db $03
    db $03
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $80
    db $80
    db $40
    db $40
    db $46
    db $46
    db $3a
    db $3a
    db $02
    db $02
    db $01
    db $01
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $80
    db $80
    db $70
    db $70
    db $0f
    db $0f
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $0c
    db $0c
    db $70
    db $70
    db $80
    db $80
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $84
    db $84
    db $78
    db $78
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $7f
    db $7f
    db $c0
    db $80
    db $c0
    db $80
    db $c0
    db $80
    db $60
    db $40
    db $70
    db $40
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $c0
    db $c0
    db $30
    db $30
    db $08
    db $08
    db $04
    db $04
    db $02
    db $02
    db $02
    db $02
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $38
    db $20
    db $1f
    db $18
    db $3f
    db $3f
    db $60
    db $40
    db $60
    db $40
    db $70
    db $60
    db $38
    db $30
    db $1e
    db $18
    db $00
    db $00
    db $00
    db $00
    db $e0
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $01
    db $01
    db $01
    db $01
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $80
    db $80
    db $80
    db $80
    db $c0
    db $40
    db $40
    db $40
    db $40
    db $40
    db $60
    db $20
    db $07
    db $06
    db $07
    db $07
    db $0c
    db $08
    db $0c
    db $08
    db $06
    db $04
    db $03
    db $02
    db $01
    db $01
    db $00
    db $00
    db $e0
    db $00
    db $fe
    db $f8
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $80
    db $00
    db $f8
    db $80
    db $7f
    db $70
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $00
    db $20
    db $20
    db $20
    db $20
    db $30
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $18
    db $08
    db $08
    db $08
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $0f
    db $0f
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $fe
    db $01
    db $01
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $88
    db $08
    db $c8
    db $08
    db $cc
    db $84
    db $cc
    db $84
    db $7c
    db $44
    db $38
    db $38
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $03
    db $03
    db $0c
    db $0c
    db $10
    db $10
    db $20
    db $20
    db $40
    db $40
    db $40
    db $40
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $fe
    db $fe
    db $03
    db $01
    db $03
    db $01
    db $03
    db $01
    db $06
    db $02
    db $0e
    db $02
    db $00
    db $00
    db $00
    db $00
    db $01
    db $01
    db $01
    db $01
    db $03
    db $02
    db $02
    db $02
    db $02
    db $02
    db $06
    db $04
    db $80
    db $80
    db $80
    db $80
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $07
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $1c
    db $04
    db $f8
    db $18
    db $fc
    db $fc
    db $06
    db $02
    db $06
    db $02
    db $0e
    db $06
    db $1c
    db $0c
    db $78
    db $18
    db $04
    db $04
    db $04
    db $04
    db $0c
    db $08
    db $08
    db $08
    db $08
    db $08
    db $08
    db $08
    db $18
    db $10
    db $10
    db $10
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $00
    db $07
    db $00
    db $7f
    db $1f
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $01
    db $00
    db $1f
    db $01
    db $fe
    db $0e
    db $e0
    db $60
    db $e0
    db $e0
    db $30
    db $10
    db $30
    db $10
    db $60
    db $20
    db $c0
    db $40
    db $80
    db $80
    db $00
    db $00
    db $10
    db $10
    db $11
    db $10
    db $33
    db $21
    db $33
    db $21
    db $3e
    db $22
    db $1c
    db $1c
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $7f
    db $80
    db $80
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $f0
    db $f0
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00

    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $03
    db $03
    db $03
    db $07
    db $03
    db $03
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $30
    db $30
    db $fc
    db $fc
    db $e2
    db $e2
    db $f9
    db $f9
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $70
    db $70
    db $f8
    db $f8
    db $d8
    db $d8
    db $50
    db $50
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $3e
    db $3e
    db $63
    db $7f
    db $7c
    db $7f
    db $7f
    db $7f
    db $2f
    db $3f
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $c1
    db $c1
    db $7e
    db $ff
    db $8c
    db $ff
    db $ec
    db $ff
    db $35
    db $35
    db $03
    db $03
    db $3e
    db $3f
    db $fe
    db $c3
    db $c2
    db $3f
    db $03
    db $ff
    db $52
    db $0e
    db $06
    db $fe
    db $50
    db $50
    db $fc
    db $fc
    db $e2
    db $a2
    db $f6
    db $a2
    db $ea
    db $a2
    db $fc
    db $fc
    db $d0
    db $d0
    db $50
    db $d0
    db $21
    db $3f
    db $7e
    db $7f
    db $5f
    db $4f
    db $5f
    db $5f
    db $7b
    db $7c
    db $3f
    db $3b
    db $34
    db $3c
    db $34
    db $3c
    db $fc
    db $ff
    db $1f
    db $ff
    db $e1
    db $ff
    db $fe
    db $ff
    db $fa
    db $fb
    db $ff
    db $ff
    db $8f
    db $89
    db $8f
    db $89
    db $0e
    db $fe
    db $ff
    db $f7
    db $fe
    db $0f
    db $fe
    db $ff
    db $fc
    db $9f
    db $ff
    db $fd
    db $7f
    db $5d
    db $3f
    db $3d
    db $f0
    db $70
    db $f8
    db $f8
    db $f8
    db $7c
    db $fc
    db $7c
    db $fc
    db $5e
    db $ce
    db $de
    db $5e
    db $4e
    db $de
    db $ce
    db $33
    db $3b
    db $3d
    db $38
    db $18
    db $3c
    db $1f
    db $1f
    db $0f
    db $1f
    db $03
    db $07
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $f1
    db $7b
    db $70
    db $f0
    db $e0
    db $f0
    db $e0
    db $e0
    db $80
    db $c0
    db $00
    db $00
    db $00
    db $00
    db $fc
    db $fe
    db $8e
    db $de
    db $0e
    db $0f
    db $07
    db $0f
    db $07
    db $07
    db $01
    db $03
    db $00
    db $00
    db $00
    db $00
    db $0e
    db $1e
    db $1c
    db $1e
    db $1c
    db $3c
    db $f8
    db $fc
    db $f8
    db $f8
    db $e0
    db $f0
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $01
    db $01
    db $07
    db $06
    db $0f
    db $08
    db $37
    db $38
    db $00
    db $00
    db $04
    db $04
    db $38
    db $38
    db $e8
    db $c8
    db $d8
    db $08
    db $50
    db $90
    db $b0
    db $50
    db $60
    db $20
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $20
    db $20
    db $51
    db $71
    db $91
    db $f1
    db $89
    db $f9
    db $87
    db $ff
    db $84
    db $ff
    db $49
    db $7e
    db $53
    db $7c
    db $ef
    db $c8
    db $ce
    db $88
    db $9d
    db $08
    db $3b
    db $13
    db $f5
    db $e5
    db $ee
    db $08
    db $de
    db $10
    db $9d
    db $19
    db $40
    db $40
    db $c0
    db $40
    db $80
    db $80
    db $00
    db $00
    db $00
    db $00
    db $80
    db $80
    db $80
    db $80
    db $00
    db $00
    db $00
    db $00
    db $01
    db $01
    db $02
    db $02
    db $07
    db $04
    db $09
    db $0e
    db $0e
    db $0f
    db $07
    db $07
    db $01
    db $01
    db $67
    db $78
    db $fe
    db $f0
    db $1d
    db $11
    db $fb
    db $22
    db $f7
    db $44
    db $af
    db $e4
    db $9f
    db $f7
    db $ac
    db $ff
    db $26
    db $26
    db $f0
    db $d0
    db $d8
    db $18
    db $e6
    db $06
    db $f9
    db $01
    db $fe
    db $00
    db $ff
    db $00
    db $ff
    db $e0
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $80
    db $80
    db $60
    db $60
    db $90
    db $10
    db $a0
    db $20
    db $00
    db $03
    db $08
    db $04
    db $10
    db $08
    db $08
    db $11
    db $0d
    db $12
    db $12
    db $2c
    db $00
    db $30
    db $00
    db $00
    db $d4
    db $77
    db $24
    db $a7
    db $02
    db $83
    db $02
    db $03
    db $03
    db $03
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $5f
    db $dc
    db $43
    db $c3
    db $40
    db $c0
    db $80
    db $80
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $40
    db $40
    db $80
    db $80
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $7f
    db $7f
    db $ff
    db $80
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $f8
    db $f8
    db $fc
    db $04
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $01
    db $01
    db $01
    db $01
    db $03
    db $02
    db $03
    db $02
    db $07
    db $04
    db $07
    db $05
    db $1f
    db $19
    db $3f
    db $21
    db $ff
    db $3c
    db $cf
    db $45
    db $c7
    db $45
    db $87
    db $85
    db $b7
    db $cd
    db $07
    db $fd
    db $07
    db $fd
    db $ff
    db $f9
    db $fe
    db $f2
    db $1e
    db $0a
    db $0f
    db $09
    db $07
    db $05
    db $27
    db $9c
    db $0f
    db $fe
    db $0f
    db $f9
    db $ff
    db $f9
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $80
    db $80
    db $80
    db $80
    db $f0
    db $70
    db $fc
    db $0c
    db $7f
    db $40
    db $7f
    db $70
    db $5f
    db $70
    db $7f
    db $70
    db $5f
    db $60
    db $e7
    db $fb
    db $9f
    db $97
    db $f7
    db $9e
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $e0
    db $f8
    db $f7
    db $78
    db $37
    db $ff
    db $0e
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $df
    db $20
    db $bf
    db $4f
    db $3f
    db $df
    db $5d
    db $f8
    db $fe
    db $02
    db $fe
    db $3e
    db $f2
    db $2a
    db $f2
    db $2a
    db $fe
    db $3e
    db $ff
    db $87
    db $f9
    db $c9
    db $e9
    db $d9
    db $ff
    db $fe
    db $0f
    db $0f
    db $07
    db $07
    db $03
    db $03
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $7f
    db $3f
    db $f8
    db $f8
    db $f0
    db $f0
    db $e0
    db $e0
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $fd
    db $f8
    db $3f
    db $3f
    db $1f
    db $1f
    db $0f
    db $0f
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $e0
    db $e0
    db $c0
    db $c0
    db $80
    db $80
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $01
    db $01
    db $02
    db $02
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $80
    db $80
    db $40
    db $40
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $03
    db $03
    db $0e
    db $0c
    db $19
    db $10
    db $25
    db $21
    db $5f
    db $43
    db $7d
    db $63
    db $04
    db $04
    db $fe
    db $fe
    db $83
    db $01
    db $7c
    db $00
    db $df
    db $20
    db $6b
    db $94
    db $ed
    db $92
    db $6b
    db $94
    db $20
    db $20
    db $18
    db $18
    db $84
    db $84
    db $62
    db $62
    db $92
    db $12
    db $6a
    db $8a
    db $be
    db $46
    db $6f
    db $91
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $0e
    db $0e
    db $3e
    db $32
    db $7c
    db $5c
    db $fc
    db $84
    db $1f
    db $10
    db $0f
    db $08
    db $17
    db $10
    db $2f
    db $20
    db $13
    db $1c
    db $0c
    db $0f
    db $03
    db $03
    db $00
    db $00
    db $ef
    db $1c
    db $f3
    db $12
    db $f3
    db $12
    db $df
    db $2e
    db $bd
    db $42
    db $7b
    db $84
    db $80
    db $ff
    db $7f
    db $7f
    db $b5
    db $4a
    db $6e
    db $91
    db $b5
    db $4a
    db $6f
    db $90
    db $b9
    db $47
    db $0e
    db $fe
    db $72
    db $f2
    db $86
    db $86
    db $fc
    db $3c
    db $fc
    db $04
    db $fc
    db $3c
    db $fc
    db $04
    db $fc
    db $bc
    db $7c
    db $44
    db $3e
    db $32
    db $0e
    db $0e
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $21
    db $21
    db $13
    db $13
    db $0c
    db $0c
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $48
    db $48
    db $30
    db $30
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $7e
    db $7e
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $01
    db $01
    db $03
    db $02
    db $07
    db $04
    db $0f
    db $08
    db $1f
    db $10
    db $7f
    db $60
    db $ff
    db $80
    db $ff
    db $c1
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $80
    db $80
    db $c0
    db $40
    db $e0
    db $20
    db $e0
    db $20
    db $f0
    db $10
    db $f0
    db $10
    db $f8
    db $08
    db $f8
    db $08
    db $03
    db $03
    db $0f
    db $0c
    db $1f
    db $10
    db $3f
    db $20
    db $3f
    db $20
    db $3f
    db $20
    db $3f
    db $20
    db $3f
    db $20
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $01
    db $fe
    db $02
    db $fc
    db $04
    db $f8
    db $18
    db $f0
    db $00
    db $f0
    db $00
    db $e0
    db $00
    db $c0
    db $80
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $1f
    db $10
    db $0f
    db $0c
    db $03
    db $03
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $00
    db $ff
    db $01
    db $fe
    db $fe
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $e0
    db $60
    db $80
    db $80
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $7e
    db $7e
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $01
    db $01
    db $03
    db $02
    db $07
    db $04
    db $07
    db $04
    db $0f
    db $08
    db $0f
    db $08
    db $1f
    db $10
    db $1f
    db $10
    db $ff
    db $83
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $00
    db $00
    db $80
    db $80
    db $c0
    db $40
    db $e0
    db $20
    db $f0
    db $10
    db $f8
    db $08
    db $fe
    db $06
    db $ff
    db $01
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $0f
    db $00
    db $0f
    db $00
    db $07
    db $00
    db $03
    db $01
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $80
    db $7f
    db $40
    db $3f
    db $20
    db $1f
    db $18
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $c0
    db $c0
    db $f0
    db $30
    db $f8
    db $08
    db $fc
    db $04
    db $fc
    db $04
    db $fc
    db $04
    db $fc
    db $04
    db $fc
    db $04
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $07
    db $06
    db $01
    db $01
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $00
    db $ff
    db $80
    db $7f
    db $7f
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $f8
    db $08
    db $f0
    db $30
    db $c0
    db $c0
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00

    db $00, $00, $00, $00, $00, $00, $00, $00, $07, $07, $08, $08, $10, $10, $20, $20
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $e0, $e0, $10, $10, $08, $08, $04, $04
    db $20, $20, $47, $43, $4f, $4f, $de, $8e, $c5, $84, $eb, $89, $ea, $8a, $76, $52
    db $00, $00, $c0, $80, $e0, $c0, $e0, $60, $f0, $e0, $f0, $70, $f0, $30, $70, $10
    db $00, $00, $01, $00, $07, $03, $07, $06, $0f, $07, $0f, $0e, $0e, $0c, $0c, $08
    db $04, $04, $f2, $e2, $f2, $f2, $73, $71, $a3, $21, $d3, $91, $57, $51, $5e, $4a
    db $76, $52, $37, $32, $1b, $12, $1b, $11, $0d, $09, $0c, $08, $06, $04, $07, $04
    db $30, $10, $00, $00, $80, $00, $f0, $80, $ff, $e0, $bf, $bf, $40, $40, $30, $30
    db $08, $08, $00, $00, $03, $00, $0f, $01, $ff, $07, $fd, $fd, $02, $02, $0c, $0c
    db $5e, $4a, $dc, $4c, $d8, $48, $98, $88, $b0, $90, $30, $10, $60, $20, $e0, $20
    db $03, $02, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $8f, $0f, $f0, $00, $ff, $c0, $3f, $30, $0f, $0f, $00, $00, $00, $00, $00, $00
    db $f1, $f0, $0f, $00, $ff, $03, $fc, $0c, $f0, $f0, $00, $00, $00, $00, $00, $00
    db $c0, $40, $80, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $01, $01, $03, $03, $07, $07, $0f, $0f, $0f, $0f, $1f, $1f, $1f, $1f, $1f, $1f
    db $f0, $f0, $fc, $fc, $fe, $fe, $8e, $8e, $06, $06, $06, $06, $0c, $0c, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $e0, $e0
    db $1f, $1f, $0f, $0f, $0f, $0f, $03, $03, $01, $01, $00, $00, $00, $00, $00, $00
    db $80, $80, $e0, $e0, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $1f, $1f, $01, $01
    db $03, $03, $0f, $0f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $e0, $e0, $c0, $c0, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $07, $07
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80
    db $0f, $0f, $3f, $3f, $7f, $7f, $71, $71, $60, $60, $60, $60, $30, $30, $00, $00
    db $80, $80, $c0, $c0, $e0, $e0, $f0, $f0, $f0, $f0, $f8, $f8, $f8, $f8, $f8, $f8
    db $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $07, $07, $03, $03, $00, $00
    db $c0, $c0, $f0, $f0, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $07, $07, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f8, $f8, $80, $80
    db $f8, $f8, $f0, $f0, $f0, $f0, $c0, $c0, $80, $80, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $300, $00

; I: 1bpp mask of stamp category 0 (63 items x $40 B), copied by Stamp_PrepareBuffers (record 0 of 04:548B)
StampCat00_Mask::
    db $ff, $ff, $ff, $fd, $f6, $fa, $fc, $f8, $ff, $da, $6a, $a0, $80, $00, $00, $00
    db $ff, $b7, $ad, $0b, $02, $00, $00, $00, $ff, $ff, $ff, $7f, $df, $bf, $7f, $3f
    db $f8, $fc, $fe, $fd, $fb, $fe, $ff, $ff, $00, $00, $00, $00, $40, $d5, $ff, $ff
    db $00, $00, $00, $01, $06, $57, $ff, $ff, $3f, $7f, $bf, $df, $ff, $7f, $ff, $ff
    db $ff, $ff, $ff, $fe, $fc, $f8, $e0, $80, $e3, $81, $00, $00, $00, $00, $00, $00
    db $8f, $03, $01, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $7f, $3f, $0f, $03
    db $c0, $e0, $f0, $f8, $fc, $fe, $ff, $ff, $00, $00, $00, $00, $00, $00, $80, $e0
    db $00, $00, $00, $00, $00, $00, $03, $0f, $07, $0f, $1f, $3f, $7f, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $80, $00, $00
    db $ff, $ff, $ff, $ff, $ff, $01, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $df, $e0, $c0, $c0
    db $ff, $ff, $ff, $ff, $ff, $07, $03, $01, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $c0, $e0, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $03, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $e0, $c0, $80
    db $ff, $ff, $ff, $ff, $fb, $07, $03, $03, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $80, $c0, $ff, $ff, $ff, $ff, $ff, $ff
    db $03, $07, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $fe, $fc, $fc, $ff, $f0, $e0, $80, $00, $00, $00, $00
    db $ff, $1f, $0f, $03, $01, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7f
    db $f8, $f8, $f8, $f8, $fc, $fe, $ff, $ff, $00, $00, $00, $00, $00, $00, $87, $ff
    db $00, $00, $00, $00, $00, $00, $c1, $ff, $7f, $7f, $7f, $7f, $7f, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f8, $e0, $c0, $80, $98
    db $ff, $ff, $ff, $3f, $0e, $02, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $be, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $83, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fc, $70, $40, $00, $00
    db $ff, $ff, $ff, $1f, $07, $03, $01, $19, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $80, $80, $c1, $ff, $ff, $ff, $ff, $ff
    db $7d, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f8, $f0, $f0, $f0, $e0, $c0, $c0, $80
    db $1f, $0f, $0f, $0f, $07, $03, $03, $01, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $80, $00, $00, $00, $00, $94, $d5, $f7
    db $01, $00, $00, $00, $00, $41, $e7, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $fe, $ff, $fc, $fe, $fa, $df, $60, $80, $80, $00, $00, $00, $00
    db $ff, $00, $00, $00, $00, $00, $00, $00, $ff, $7f, $6f, $1f, $1f, $07, $0f, $1f
    db $fc, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $c0, $c0, $c0, $c0, $e0, $d0, $f5
    db $00, $00, $00, $00, $00, $00, $01, $b5, $3f, $7f, $7f, $3f, $7f, $ff, $7f, $bf
    db $ff, $ff, $fb, $fc, $fc, $f0, $f8, $fc, $ff, $00, $00, $00, $00, $00, $00, $00
    db $fd, $03, $00, $00, $00, $00, $00, $00, $ff, $7f, $ff, $bf, $7f, $1f, $3f, $2f
    db $fe, $ff, $ff, $fe, $ff, $ff, $ff, $fe, $00, $00, $00, $00, $00, $80, $40, $d6
    db $00, $01, $01, $01, $01, $03, $05, $d7, $1f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f0
    db $3f, $3f, $3f, $3f, $3f, $3f, $3f, $1f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $e0, $80, $00, $00, $00, $80, $e3, $ff
    db $0f, $03, $01, $01, $01, $03, $8f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $fc, $e0, $f8, $fc, $ff, $fc, $e0, $00, $00, $00, $00, $00
    db $ff, $01, $0c, $03, $00, $00, $00, $00, $ff, $ff, $3f, $0f, $cf, $7f, $3f, $ff
    db $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $80, $c0, $80, $70, $ff, $ff, $ff
    db $00, $00, $01, $01, $03, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $fc, $f0, $f3, $fe, $fc, $ff, $ff, $80, $30, $c0, $00, $00, $00, $00
    db $ff, $3f, $07, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $3f, $07, $1f, $3f
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $80, $80, $c0, $ff, $ff, $ff
    db $00, $01, $03, $01, $0e, $ff, $ff, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fd, $fd, $fd, $f9, $f9, $f1, $e1
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $c3, $c3, $e3, $f1, $f9, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $9f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $fe, $fc, $f8, $f8, $ff, $e0, $80, $00, $00, $00, $00, $00
    db $ff, $0f, $01, $00, $00, $00, $00, $00, $ff, $ff, $ff, $7f, $3f, $1f, $1f, $1f
    db $f8, $f8, $f8, $fc, $fe, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00, $ff, $ff
    db $00, $00, $00, $00, $00, $07, $ff, $ff, $1f, $1f, $1f, $3f, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $fe, $fc, $f8, $f8, $f8, $ff, $f0, $80, $00, $00, $00, $00, $00
    db $ff, $07, $01, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $7f, $3f, $1f, $1f
    db $f8, $f8, $f8, $fc, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $e0, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $1f, $1f, $1f, $3f, $7f, $ff, $ff, $ff
    db $ff, $ff, $c7, $c0, $c0, $c0, $c0, $c1, $ff, $ff, $ff, $3f, $7f, $ff, $ff, $ff
    db $ff, $ff, $ff, $fc, $fe, $ff, $ff, $ff, $ff, $ff, $e3, $03, $03, $03, $03, $83
    db $c1, $e1, $e1, $f1, $f1, $f9, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $83, $87, $87, $8f, $8f, $9f, $ff, $ff
    db $ff, $ff, $ff, $ff, $fc, $f0, $e0, $c7, $ff, $ff, $e1, $00, $00, $00, $fc, $ff
    db $ff, $ff, $ff, $3f, $07, $00, $00, $c0, $ff, $ff, $ff, $ff, $ff, $ff, $1d, $03
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f8, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $07, $0f, $9f, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $b8, $c0, $ff, $ff, $ff, $fc, $e0, $00, $00, $03
    db $ff, $ff, $87, $00, $00, $00, $3f, $ff, $ff, $ff, $ff, $ff, $3f, $0f, $07, $e3
    db $e0, $f0, $f9, $ff, $ff, $ff, $ff, $ff, $1f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fb, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $fc, $fc, $fc, $f8, $f8, $f8, $f0
    db $ff, $7f, $7f, $7f, $3f, $3f, $3f, $1f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f0, $f0, $f0, $f0, $f0, $f8, $ff, $ff
    db $1f, $1f, $1f, $1f, $1f, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $fe, $f8, $ff, $ff, $ff, $ff, $ff, $c0, $00, $0f
    db $ff, $ff, $ff, $ff, $ff, $1f, $01, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $3f
    db $e1, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f8, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $1f, $87, $e3, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fc, $ff, $ff, $ff, $ff, $ff, $f8, $80, $00
    db $ff, $ff, $ff, $ff, $ff, $03, $00, $f0, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $1f
    db $f8, $e1, $c7, $ff, $ff, $ff, $ff, $ff, $1f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $87, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fc, $f8, $f0, $f0, $f0, $e0
    db $ff, $ff, $7f, $3f, $1f, $1f, $1f, $0f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $fe, $ff, $ff, $ff, $ff, $d8, $b5, $6d, $ed, $dd, $dd, $fd, $ff
    db $27, $5b, $6d, $b7, $b7, $db, $df, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $f7, $e3, $e0, $80, $ff, $ff, $fe, $be, $be, $1c, $00, $00
    db $7f, $7b, $3b, $31, $31, $31, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $1f, $01
    db $e0, $e7, $f7, $f7, $ff, $ff, $ff, $ff, $00, $1c, $1e, $be, $be, $ff, $ff, $ff
    db $00, $30, $31, $31, $31, $7b, $ff, $ff, $0f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f0, $e0, $e0, $e0, $e0, $f0, $ff, $ff, $00, $00, $00, $00, $00, $00, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $0f, $0f, $0f, $0f, $0f, $0f, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $c0, $c0, $c0, $c0, $c0, $c0, $ff, $ff, $00, $00, $00, $00, $00, $00, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $03, $03, $03, $03, $03, $03, $87, $03
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $03, $03, $03, $03, $03, $03, $03, $87
    db $fd, $fe, $ff, $ff, $fe, $fe, $fe, $fe, $ff, $3f, $00, $00, $00, $00, $00, $00
    db $ff, $f8, $01, $01, $00, $00, $00, $00, $bf, $7f, $ff, $ff, $ff, $ff, $ff, $ff
    db $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $80, $c0, $f0
    db $00, $00, $00, $01, $01, $03, $07, $1f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $e0, $c0, $c0, $c0, $c0
    db $ff, $ff, $ff, $03, $03, $03, $03, $03, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $c0, $c0, $c0, $c0, $e0, $ff, $ff, $ff
    db $03, $03, $03, $03, $03, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $c0, $80, $80, $00, $00, $00, $00, $00, $ff, $7f, $7f, $7f, $7f, $7f, $7f, $7f
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $80, $80, $c0, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f0, $c0, $80, $80
    db $ff, $ff, $ff, $ff, $0f, $03, $01, $01, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $0f, $3f, $7f, $ff, $ff, $ff, $ff
    db $00, $f0, $fc, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f0, $c0, $8f, $98, $13, $37, $37, $3b
    db $3f, $0f, $c7, $73, $31, $99, $99, $99, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $1f, $87, $c0, $f0, $ff, $ef, $f0, $ff
    db $99, $11, $33, $63, $c7, $1f, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ce, $e0, $f9
    db $ff, $ff, $9f, $97, $2f, $5f, $df, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $c7, $f8, $fe, $fe, $ff, $ff, $ff, $ff
    db $bf, $df, $5f, $2f, $37, $1f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $fe, $fe, $f8, $e0, $c0, $80, $00, $00, $00, $00
    db $1f, $07, $03, $01, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $7f
    db $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $80, $c0, $e0, $c2
    db $00, $00, $00, $00, $01, $03, $07, $a3, $7f, $7f, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $fe, $fc, $f0, $80
    db $7f, $7f, $7f, $3f, $3f, $1f, $07, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f0, $fc, $fe, $fe, $ff, $ff, $ff, $ff
    db $07, $1f, $3f, $3f, $7f, $7f, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f8, $fc, $fc, $fc, $fc, $fc, $fc, $fc
    db $3f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f8, $f0, $e0, $e0, $e0, $f0, $f8, $fc
    db $3f, $1f, $0f, $0f, $0f, $1f, $3f, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $fe, $fc, $f0, $c0, $80, $f8, $c0, $80, $00, $00, $00, $00, $00
    db $1f, $03, $01, $00, $00, $00, $00, $00, $ff, $ff, $ff, $7f, $3f, $0f, $03, $01
    db $c0, $f0, $fc, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $80, $c0, $f0, $ff
    db $00, $00, $00, $00, $01, $03, $0f, $ff, $03, $0f, $3f, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $fe, $ff, $fe, $e3, $80, $c3, $00, $83, $00, $83, $00
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $77, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $fe, $ff, $fe, $ff, $ff, $ff, $ff, $83, $00, $81, $00, $80, $00, $c0, $f0
    db $fb, $fb, $f3, $c3, $07, $0f, $1f, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ee
    db $c7, $01, $c3, $00, $c1, $00, $c1, $00, $ff, $ff, $ff, $ff, $ff, $7f, $ff, $7f
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $df, $df, $cf, $c3, $e0, $f0, $f8, $fe
    db $c1, $00, $81, $00, $01, $00, $03, $0f, $ff, $7f, $ff, $7f, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fc, $f8, $f0, $f0, $f0
    db $ff, $ff, $ff, $1f, $0f, $07, $07, $07, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f0, $f0, $f8, $fc, $ff, $ff, $ff, $ff
    db $07, $07, $0f, $1f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $fe, $fe, $fe, $fe, $fe, $c0, $80, $03, $07, $0f, $0f, $1f, $1f
    db $3f, $ff, $ff, $ff, $ff, $ff, $ff, $df, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $1f, $1f, $0f, $0f, $87, $c1, $e0, $f8
    db $cf, $e7, $e7, $e7, $c7, $0f, $1f, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00
    db $ff, $ff, $ff, $ff, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $7f, $7f, $7f, $7f
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $80, $c1, $ff
    db $00, $00, $00, $00, $00, $81, $c3, $ff, $7f, $7f, $7f, $7f, $ff, $ff, $ff, $ff
    db $ff, $ff, $fc, $fc, $fc, $f8, $f0, $f0, $fc, $08, $00, $00, $00, $00, $00, $00
    db $7f, $3f, $0f, $0f, $07, $07, $07, $07, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f8, $f8, $fc, $f8, $f8, $f8, $fe, $fe, $00, $00, $00, $00, $00, $00, $00, $27
    db $0f, $0f, $07, $07, $0f, $0f, $0f, $1f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $c7, $80, $00, $00, $00, $00, $00, $00, $ff, $ff, $1f, $07, $00, $00, $00, $00
    db $ff, $ff, $f8, $e0, $00, $00, $00, $00, $e3, $01, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $80, $c3, $ff, $00, $00, $00, $04, $0f, $7f, $ff, $ff
    db $00, $00, $00, $20, $f0, $fe, $ff, $ff, $00, $00, $00, $00, $00, $01, $c3, $ff
    db $ff, $ff, $e1, $c0, $c0, $c0, $c0, $c0, $ff, $ff, $ff, $3f, $08, $00, $00, $00
    db $ff, $ff, $fc, $e0, $80, $00, $00, $00, $ff, $ff, $3f, $1f, $1f, $1f, $1f, $1f
    db $c0, $c0, $c0, $c0, $e1, $ff, $ff, $ff, $00, $08, $1f, $7f, $ff, $ff, $ff, $ff
    db $00, $80, $c0, $f0, $fc, $ff, $ff, $ff, $1f, $1f, $1f, $1f, $3f, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $80
    db $ff, $ff, $ff, $ff, $ff, $07, $07, $0f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $c0, $f0, $ff, $ff, $ff, $ff, $ff, $ff
    db $1f, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f0, $c0, $80, $00
    db $ff, $ff, $ff, $ff, $0f, $03, $01, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $80, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $01, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $f0, $e0, $e0, $e0, $e0, $f8, $e0, $c0, $00, $00, $00, $00, $00
    db $3f, $0f, $07, $00, $00, $00, $00, $00, $ff, $ff, $ff, $1f, $0f, $0f, $0f, $0f
    db $e0, $e0, $e0, $f0, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $c0, $e0, $f8, $ff
    db $00, $00, $00, $00, $07, $0f, $3f, $ff, $0f, $0f, $0f, $1f, $ff, $ff, $ff, $ff
    db $cf, $c1, $c0, $c0, $e0, $e0, $e0, $f0, $ff, $ff, $3f, $00, $00, $00, $00, $00
    db $ff, $ff, $fc, $00, $00, $00, $00, $00, $f3, $83, $03, $03, $07, $07, $07, $0f
    db $f0, $f8, $fc, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $c0, $f8, $ff, $ff
    db $00, $00, $00, $00, $03, $1f, $ff, $ff, $0f, $1f, $3f, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $fb, $fd, $fc, $ff, $ff, $ff, $fb, $bb, $99, $80, $00
    db $ff, $ff, $ff, $bf, $bb, $33, $03, $00, $ff, $ff, $ff, $ff, $ff, $bf, $7f, $7f
    db $f6, $f8, $f8, $ff, $ff, $ff, $ff, $ff, $07, $3f, $ff, $ff, $ff, $ff, $ff, $ff
    db $c0, $f8, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $3f, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $f1, $f0, $ec, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $0f
    db $ff, $ff, $ff, $ff, $ff, $fe, $f0, $81, $ff, $ff, $ff, $ff, $ff, $7f, $7f, $ff
    db $f8, $fb, $f7, $ff, $ff, $ff, $ff, $ff, $00, $00, $32, $77, $f7, $ff, $ff, $ff
    db $00, $06, $67, $77, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fd, $f6, $d0
    db $ff, $ff, $ff, $ff, $ff, $b7, $8d, $57, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $e8, $b5, $fe, $ff, $ff, $ff, $ff, $ff
    db $8b, $57, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fc, $f8, $f0, $f0
    db $ff, $ff, $ff, $ff, $1f, $0f, $07, $07, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f0, $f8, $ff, $ff, $ff, $ff, $ff, $ff
    db $07, $0f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $fc, $f0, $c0, $ff, $e3, $c0, $80, $00, $00, $00, $00
    db $ff, $1f, $0f, $07, $03, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $3f, $0f
    db $f8, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $80, $c0, $f0, $ff, $ff
    db $00, $01, $03, $07, $0f, $3f, $ff, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fc, $f8, $88, $00, $00, $00, $80
    db $ff, $7f, $3f, $23, $01, $01, $01, $03, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $c0, $e0, $c0, $80, $80, $80, $c6, $ff
    db $07, $03, $01, $01, $01, $03, $0f, $1f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $f3, $f8, $fc, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $1f
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f8, $ff, $ff, $ff, $ff, $ff, $cf, $1f, $3f
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $80, $f0, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $0f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fc, $f0, $e0, $c0, $80, $80, $00, $00
    db $3f, $0f, $07, $03, $01, $01, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $80, $80, $c0, $e0, $f0, $fc
    db $00, $00, $01, $01, $03, $07, $0f, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f8, $f0, $e0, $e0
    db $ff, $ff, $ff, $ff, $3f, $1f, $0f, $0f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $e0, $e0, $f0, $f8, $ff, $ff, $ff, $ff
    db $0f, $0f, $1f, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $fc, $f0, $e0, $c0, $80, $80, $00, $00, $30, $00, $00, $00, $00, $00, $00, $00
    db $18, $00, $00, $00, $00, $00, $00, $00, $7f, $1f, $0f, $07, $03, $03, $01, $01
    db $00, $00, $00, $80, $c0, $e0, $ff, $ff, $01, $01, $03, $07, $0f, $3f, $ff, $ff
    db $00, $00, $80, $c0, $e0, $f8, $ff, $ff, $01, $01, $01, $03, $07, $0f, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $fe, $f8, $f0, $f0, $e0, $e0, $c0, $c0, $00, $00, $00
    db $0f, $07, $07, $03, $03, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $7f, $1f, $0f
    db $e0, $e0, $e0, $e0, $f0, $f8, $ff, $ff, $00, $00, $00, $00, $00, $00, $e0, $fc
    db $00, $00, $00, $00, $00, $00, $07, $3f, $07, $07, $07, $07, $0f, $1f, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $e0, $e0, $e0, $ef, $ef, $ef, $ef, $ef
    db $3f, $00, $00, $80, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $fe, $fe, $ff, $ff, $ef, $ef, $ef, $0f, $0f, $0f, $1f, $ff
    db $fe, $fe, $fe, $fe, $f0, $e0, $e0, $f1, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $ff, $7f, $3f, $3f, $9f, $cf, $cf, $cf, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $fe, $fe, $fe, $f0, $e0, $e0, $f1
    db $df, $bf, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $bf, $bf, $bf, $bf, $bf, $bf, $bf, $bf, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fc, $f8, $f8, $fc
    db $bf, $bf, $bf, $bf, $3f, $3f, $3f, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

    ; padding
    ds $40, $00
