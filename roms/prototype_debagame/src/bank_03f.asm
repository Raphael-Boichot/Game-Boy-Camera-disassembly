; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $3F. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $03f", ROMX[$4000], BANK[$3f]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_3F_4000::
    db $3f

; I: leftover: 511 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_3F_4001::
    db $72, $1f, $26, $8b, $5d, $08, $c1, $eb, $0d, $80, $fb, $01, $74, $22, $80, $fb
    db $05, $74, $1d, $06, $0e, $07, $bf, $c3, $6f, $b9, $10, $00, $f2, $af, $07, $74
    db $0f, $f8, $eb, $0d, $26, $8b, $45, $07, $25, $ff, $01, $3d, $50, $00, $73, $f1
    db $f9, $c9, $c2, $02, $00, $c8, $00, $00, $00, $b0, $01, $83, $7e, $06, $00, $74
    db $1e, $ff, $76, $06, $e8, $ed, $fc, $8a, $87, $7f, $18, $3b, $1e, $f2, $20, $72
    db $0d, $50, $ff, $76, $06, $ff, $76, $04, $e8, $ee, $05, $58, $73, $01, $40, $c9
    db $c2, $04, $00, $c8, $02, $00, $00, $a1, $08, $21, $88, $46, $fe, $8b, $76, $06
    db $8b, $7e, $08, $83, $ff, $00, $75, $1e, $8a, $5c, $0c, $80, $fb, $00, $76, $14
    db $b7, $00, $d1, $e3, $8b, $bf, $1f, $16, $83, $ff, $00, $74, $07, $26, $8a, $65
    db $06, $00, $66, $fe, $eb, $23, $26, $8a, $65, $06, $00, $66, $fe, $8b, $0e, $8e
    db $12, $80, $e1, $03, $80, $f9, $01, $74, $10, $f6, $06, $f8, $20, $10, $75, $09
    db $83, $7e, $04, $01, $75, $03, $fe, $46, $fe, $8b, $44, $07, $25, $ff, $01, $e8
    db $90, $01, $02, $46, $fe, $c9, $c2, $06, $00, $c8, $02, $00, $00, $ff, $76, $06
    db $ff, $76, $04, $e8, $73, $05, $b8, $00, $00, $d1, $d0, $89, $46, $fe, $8b, $76
    db $04, $8b, $7e, $06, $8b, $54, $07, $81, $e2, $ff, $01, $83, $ff, $00, $75, $26
    db $56, $6a, $00, $57, $52, $e8, $1a, $01, $5e, $8a, $5c, $0c, $80, $fb, $00, $00
    db $00, $be, $c1, $d1, $e3, $36, $8b, $bf, $1f, $16, $83, $ff, $00, $74, $04, $26
    db $02, $45, $06, $e9, $cd, $00, $8a, $44, $05, $24, $38, $3c, $30, $75, $0f, $26
    db $8a, $45, $05, $24, $38, $3c, $30, $75, $05, $b0, $00, $e9, $b1, $00, $26, $8b
    db $45, $08, $8b, $c8, $25, $f0, $1f, $c1, $e8, $04, $c1, $e9, $0d, $57, $36, $8b
    db $1e, $8e, $12, $80, $e3, $03, $80, $fb, $01, $74, $66, $36, $f6, $06, $f8, $20
    db $10, $75, $5e, $36, $8a, $1e, $30, $00, $80, $e3, $03, $80, $fb, $03, $74, $51
    db $3d, $15, $00, $72, $4c, $3d, $19, $00, $77, $47, $83, $fa, $15, $72, $42, $83
    db $fa, $19, $77, $3d, $60, $57, $57, $e8, $21, $fc, $96, $5f, $2b, $c7, $26, $2a
    db $45, $04, $3c, $fc, $61, $75, $2a, $60, $56, $06, $1e, $07, $56, $e8, $0b, $fc
    db $07, $96, $5e, $2b, $c6, $2a, $44, $04, $3c, $fc, $61, $75, $0a, $36, $f6, $06
    db $30, $00, $02, $74, $14, $eb, $0a, $76, $08, $36, $f6, $06, $30, $00, $01, $74
    db $08, $50, $51, $52, $e8, $5b, $00, $eb, $07, $50, $51, $52, $e8, $53, $00, $48
    db $5f, $36, $8b, $0e, $8e, $12, $80, $e1, $03, $80, $f9, $01, $74, $0b, $36, $f6
    db $06, $f8, $20, $10, $75, $03, $03, $46, $fe, $a8, $80, $74, $02, $b0, $00, $26
    db $02, $45, $06, $8b, $76, $04, $8a, $54, $05, $80, $e2, $38, $80, $fa, $18, $75
    db $1a, $50, $56, $06, $1e, $07, $56, $e8, $a1, $fb, $07, $8b, $d6, $5e, $2b

    ; padding
    ds $e00, $00

    db $08, $70, $df, $00, $f0

    ; padding
    ds $f3, $00

    db $ff

    ; padding
    ds $f07, $00

    db $08, $80, $df, $00, $f0

    ; padding
    ds $f3, $00

    db $ff

    ; padding
    ds $f07, $00

    db $08, $90, $df, $00, $f0

    ; padding
    ds $f3, $00

    db $ff

    ; padding
    ds $f06, $00

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_3F_7FFF::
    db $3f
