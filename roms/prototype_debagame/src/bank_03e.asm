; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $3E. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $03e", ROMX[$4000], BANK[$3e]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_3E_4000::
    db $3e

; I: leftover: 511 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_3E_4001::
    db $c4, $88, $05, $47, $c3, $57, $58, $32, $20, $20, $20, $20, $20, $57, $58, $32
    db $54, $58, $20, $20, $20, $12, $13, $14, $15, $3a, $0e, $10, $11, $16, $17, $ff
    db $36, $66, $25, $e8, $39, $fe, $73, $0e, $3d, $13, $00, $77, $08, $3d, $05, $00
    db $74, $03, $b8, $00, $01, $f9, $c3, $06, $8e, $06, $52, $0d, $e8, $e0, $ff, $73
    db $03, $e9, $2b, $01, $83, $3e, $6c, $25, $00, $74, $03, $e9, $12, $01, $b0, $00
    db $a2, $7d, $25, $a2, $7e, $25, $6a, $00, $6a, $00, $e8, $bc, $fe, $73, $03, $e9
    db $0d, $01, $a1, $68, $25, $b9, $00, $01, $03, $c1, $a3, $6a, $25, $2b, $06, $50
    db $0d, $3b, $06, $5a, $0d, $76, $03, $e9, $ec, $00, $ff, $36, $ae, $04, $68, $b0
    db $04, $51, $e8, $bb, $fe, $73, $03, $e9, $e4, $00, $3b, $d1, $74, $03, $e9, $da
    db $00, $1e, $8e, $1e, $ae, $04, $be, $b0, $04, $36, $8b, $3e, $68, $25, $b9, $80
    db $00, $f3, $a5, $06, $0e, $07, $be, $b0, $04, $bf, $06, $90, $b9, $08, $00, $f3
    db $a6, $74, $0a, $be, $b0, $04, $03, $f9, $b9, $08, $00, $f3, $a6, $07, $1f, $75
    db $cd, $8b, $3e, $68, $25, $6a, $00, $26, $ff, $75, $0e, $e8, $4b, $fe, $73, $03
    db $e9, $9c, $00, $26, $8b, $4d, $12, $26, $2b, $4d, $0e, $a1, $6a, $25, $03, $c1
    db $2b, $06, $50, $0d, $3b, $06, $5a, $0d, $77, $7c, $b8, $00, $01, $03, $c1, $a3
    db $6c, $25, $8b, $d9, $8b, $3e, $6a, $25, $b8, $00, $08, $3b, $d8, $73, $02, $00
    db $20, $5c, $c2, $36, $ae, $04, $68, $b0, $04, $50, $e8, $33, $fe, $5b, $72, $5e
    db $3b, $d1, $75, $57, $1e, $8e, $1e, $ae, $04, $be, $b0, $04, $d1, $e9, $f3, $a5
    db $1f, $2b, $da, $75, $d3, $8b, $36, $68, $25, $83, $c6, $40, $bf, $88, $24, $b9
    db $18, $00, $1e, $06, $1e, $06, $1f, $07, $f3, $a5, $07, $1f, $8b, $3e, $68, $25
    db $26, $8b, $45, $14, $a3, $6f, $25, $26, $8a, $45, $16, $a2, $6e, $25, $b8, $00
    db $04, $26, $8a, $4d, $17, $d3, $e0, $a3, $77, $25, $2d, $04, $00, $a3, $79, $25
    db $f8, $a1, $6c, $25, $eb, $09, $b8, $04, $01, $eb, $03, $b8, $01, $01, $f9, $07
    db $c3, $8b, $0e, $cc, $25, $2b, $0e, $50, $0d, $a1, $5a, $0d, $2b, $c1, $72, $58
    db $33, $d2, $8b, $0e, $77, $25, $f7, $f1, $3d, $02, $00, $72, $4b, $3d, $1f, $00
    db $7e, $03, $b8, $1f, $00, $a3, $c6, $26, $bb, $ce, $25, $89, $1e, $c8, $26, $a1
    db $c6, $26, $48, $6b, $c0, $08, $03, $c3, $8b, $f0, $33, $c9, $3b, $0e, $c6, $26
    db $73, $20, $89, $77, $02, $8b, $f3, $83, $c6, $08, $89, $37, $c7, $47, $04, $ff
    db $ff, $a1, $77, $25, $f7, $e1, $03, $06, $cc, $25, $89, $47, $06, $87, $f3, $41
    db $eb, $da, $c7, $04, $ce, $25, $eb, $06, $b8, $04, $01, $e8, $ec, $fa, $c3, $06
    db $8e, $06, $52, $0d, $83, $3e, $6c, $25, $00, $74, $25, $e8, $28, $00, $a3, $81
    db $25, $a3, $83, $25, $e8, $7d, $00, $72, $1b, $e8, $5e, $03, $73, $16, $3d

    ; padding
    ds $e00, $00

    db $08, $30, $df, $00, $f0

    ; padding
    ds $f3, $00

    db $ff

    ; padding
    ds $f07, $00

    db $08, $40, $df, $00, $f0

    ; padding
    ds $f3, $00

    db $ff

    ; padding
    ds $f07, $00

    db $08, $50, $df, $00, $f0

    ; padding
    ds $f3, $00

    db $ff

    ; padding
    ds $f06, $00

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_3E_7FFF::
    db $3e
