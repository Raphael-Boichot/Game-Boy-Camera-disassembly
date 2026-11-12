; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $3B. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $03b", ROMX[$4000], BANK[$3b]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_3B_4000::
    db $3b

; I: leftover: 511 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_3B_4001::
    db $07, $e8, $a7, $ff, $c3, $c8, $00, $00, $00, $06, $56, $57, $1e, $07, $8b, $76
    db $06, $8b, $7e, $04, $33, $c9, $80, $3c, $00, $74, $2e, $83, $f9, $1e, $77, $29
    db $ac, $e8, $b3, $1b, $72, $1f, $8a, $e0, $ac, $e8, $89, $27, $8b, $c2, $e8, $50
    db $2b, $3c, $00, $74, $05, $b9, $ff, $ff, $eb, $12, $8b, $c2, $80, $fc, $20, $74
    db $04, $aa, $8a, $c4, $41, $aa, $41, $eb, $cd, $b0, $00, $aa, $5f, $5e, $07, $c9
    db $c2, $04, $00, $c8, $00, $00, $00, $ff, $76, $04, $6a, $0c, $68, $47, $10, $68
    db $99, $10, $6a, $40, $e8, $07, $14, $c7, $06, $66, $0e, $3e, $00, $68, $35, $05
    db $6a, $0c, $68, $88, $10, $68, $d9, $10, $6a, $10, $e8, $f1, $13, $c7, $06, $5c
    db $0e, $10, $00, $c9, $c2, $02, $00, $1b, $5b, $3e, $31, $68, $00, $1b, $5b, $3e
    db $31, $6c, $00, $3d, $40, $85, $72, $0a, $3d, $9e, $86, $77, $05, $b8, $01, $00
    db $eb, $03, $b8, $02, $00, $c3, $c8, $00, $00, $00, $ff, $76, $06, $ff, $76, $04
    db $e8, $c4, $08, $80, $3e, $85, $0c, $02, $76, $07, $80, $3e, $50, $14, $01, $74
    db $53, $50, $a1, $04, $04, $8a, $dc, $b4, $00, $b7, $00, $53, $50, $e8, $a7, $08
    db $8b, $d8, $58, $8b, $f0, $2b, $f3, $8b, $d8, $8a, $76, $06, $8a, $56, $04, $8b
    db $f3, $2b, $36, $66, $07, $80, $3e, $85, $0c, $02, $75, $1a, $06, $1e, $07, $55
    db $b8, $21, $13, $c1, $e6, $02, $8d, $ac, $4d, $09, $b9, $01, $00, $b7, $00, $00
    db $b0, $19, $c2, $07, $eb, $0b, $8a, $84, $e7, $0a, $8a, $9c, $b4, $0b, $e8, $02
    db $06, $e9, $c1, $00, $6a, $40, $07, $50, $26, $a0, $85, $00, $b4, $00, $a2, $8c
    db $0c, $8b, $c8, $58, $2b, $06, $66, $07, $f7, $e1, $80, $3e, $85, $0c, $04, $75
    db $07, $51, $b9, $04, $00, $f7, $e1, $59, $8b, $d8, $8a, $76, $06, $8a, $56, $04
    db $8b, $fa, $81, $e7, $ff, $00, $a0, $8c, $0c, $b4, $00, $f6, $e6, $8b, $36, $83
    db $0c, $f7, $e6, $50, $25, $0f, $00, $03, $f8, $58, $c1, $e8, $04, $c1, $ca, $04
    db $0b, $c2, $80, $c4, $a0, $8e, $c0, $80, $3e, $85, $0c, $04, $75, $15, $b0, $01
    db $a2, $8b, $0c, $b4, $05, $e8, $be, $02, $a2, $86, $0c, $b4, $01, $e8, $b6, $02
    db $a2, $88, $0c, $8b, $36, $64, $07, $8b, $16, $83, $0c, $4a, $8a, $0e, $8c, $0c
    db $b5, $00, $80, $3e, $85, $0c, $04, $75, $1d, $b4, $05, $b0, $00, $e8, $a3, $02
    db $b4, $01, $b0, $00, $e8, $9c, $02, $fa, $52, $ba, $c4, $03, $b0, $02, $ee, $42
    db $a0, $8b, $0c, $ee, $5a, $fb, $57, $2e, $8a, $00, $aa, $03, $fa, $43, $e2, $f7
    db $5f, $80, $3e, $85, $0c, $04, $75, $0d, $80, $3e, $8b, $0c, $08, $74, $06, $d0
    db $26, $8b, $0c, $eb, $b7, $80, $3e, $85, $0c, $04, $75, $10, $b4, $05, $a0, $86
    db $0c, $e8, $52, $02, $b4, $01, $a0, $88, $0c, $e8, $57, $02, $c9, $c2, $04, $00
    db $c8, $00, $00, $00, $ff, $76, $06, $ff, $76, $04, $e8, $7a, $07, $50, $a1

    ; padding
    ds $e00, $00

    db $08, $a0, $8e, $00, $f0

    ; padding
    ds $f3, $00

    db $ff

    ; padding
    ds $f07, $00

    db $08, $b0, $8e, $00, $f0

    ; padding
    ds $f3, $00

    db $ff

    ; padding
    ds $f07, $00

    db $08, $c0, $8e, $00, $f0

    ; padding
    ds $f3, $00

    db $ff

    ; padding
    ds $f06, $00

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_3B_7FFF::
    db $3b
