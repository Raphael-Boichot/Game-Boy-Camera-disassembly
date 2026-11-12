; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $1C. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $01c", ROMX[$4000], BANK[$1c]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_1C_4000::
    db $1c

; I: leftover tiles: two tile rows (512 bytes) of a head, hair against a textured background, that no picture of this
; ROM holds (compared with the 14 pictures at every row and shift, plain and inverted); the rest of that picture is
; not in the ROM; nothing in this build reads it ...
Leftover_1C_4001_Tiles::
    db $02, $01, $01, $00, $01, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $ff, $ff, $ff, $bf, $ff, $bf, $7f, $7f, $ff, $bf, $7f, $ff, $3f, $7f, $3f
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $ff, $aa, $55
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $05, $ff, $0b, $ff, $eb, $15
    db $fe, $ff, $fc, $ff, $fe, $ff, $c2, $fd, $aa, $ff, $f4, $ff, $fa, $ff, $74, $ff
    db $55, $aa, $bf, $40, $55, $aa, $af, $50, $11, $ee, $b9, $44, $55, $aa, $f7, $00
    db $55, $aa, $fd, $00, $ff, $00, $fd, $00, $7f, $80, $ff, $00, $df, $20, $57, $00
    db $51, $ae, $fb, $04, $f5, $0a, $ff, $00, $75, $8a, $7f, $00, $fd, $02, $7f, $00
    db $11, $8e, $5e, $05, $b1, $0e, $5e, $01, $f1, $0e, $7e, $00, $bd, $02, $7c, $00
    db $7e, $80, $d5, $00, $3d, $82, $5f, $00, $e3, $0c, $c5, $00, $e2, $00, $80, $00
    db $82, $00, $00, $00, $02, $00, $02, $00, $ea, $00, $04, $00, $22, $00, $40, $00
    db $60, $60, $60, $60, $60, $60, $60, $60, $70, $70, $30, $30, $30, $30, $30, $30
    db $63, $63, $67, $67, $66, $66, $6e, $6e, $6f, $6f, $67, $67, $63, $63, $00, $00
    db $f0, $f0, $ff, $ff, $1f, $1f, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $00
    db $00, $00, $c0, $c0, $c0, $c0, $e0, $e0, $60, $60, $e0, $e0, $e0, $e0, $00, $00
    db $a0, $51, $c2, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ef, $3f, $3f, $1f, $0f, $3f, $1f, $1f, $2f, $1f, $17, $0f, $0b, $0f, $03, $07
    db $fe, $ff, $fc, $ff, $fd, $fe, $ff, $fc, $fd, $fe, $fe, $fd, $fd, $fe, $fe, $fd
    db $55, $aa, $87, $7c, $49, $be, $a2, $5d, $8a, $ff, $39, $c7, $52, $af, $a9, $57
    db $10, $ef, $aa, $55, $55, $aa, $ea, $15, $01, $fe, $2f, $d0, $15, $ea, $3f, $c0
    db $fc, $ff, $56, $fd, $29, $fe, $aa, $55, $15, $ea, $bf, $40, $45, $ba, $ea, $15
    db $1f, $e0, $ff, $00, $5d, $a2, $d7, $00, $57, $a8, $ff, $00, $57, $a8, $ff, $00
    db $7f, $80, $d5, $00, $fe, $00, $55, $00, $7e, $80, $dd, $00, $ff, $00, $f7, $00
    db $d5, $2a, $5d, $00, $ba, $00, $41, $00, $ea, $00, $d5, $00, $fa, $00, $77, $00
    db $77, $88, $55, $00, $bb, $00, $01, $00, $aa, $00, $44, $00, $aa, $00, $51, $00
    db $a8, $00, $04, $00, $a8, $00, $11, $00, $be, $00, $7d, $00, $de, $20, $f7, $00
    db $e2, $00, $40, $00, $22, $00, $00, $00, $82, $00, $58, $00, $98, $00, $10, $00
    db $38, $38, $38, $38, $18, $18, $18, $18, $18, $18, $19, $19, $19, $19, $19, $19
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $c0, $ff, $ff, $ff, $ff
    db $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $ff, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $c0, $e0, $00

    ; padding
    ds $dff, $00

; I: leftover: 5 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_1C_5000::
    db $08, $60, $8e, $00, $f0

    ; padding
    ds $f3, $00

    db $ff

    ; padding
    ds $f07, $00

    db $08, $70, $8e, $00, $f0

    ; padding
    ds $f3, $00

    db $ff

    ; padding
    ds $f07, $00

    db $08, $80, $8e, $00, $f0

    ; padding
    ds $f3, $00

    db $ff

    ; padding
    ds $f06, $00

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_1C_7FFF::
    db $1c
