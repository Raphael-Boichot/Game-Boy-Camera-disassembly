; Game Boy Camera (USA, Europe), bank $2F. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $02f", ROMX[$4000], BANK[$2f]

    db $e0, $c0, $80, $00, $0f, $0f, $0f, $9f, $3f, $1f, $0f, $00, $80, $c0, $c0, $c0
    db $fc, $f8, $f0, $00, $01, $03, $03, $03, $07, $03, $01, $00, $f0, $f0, $f0, $f9
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $c0, $c0, $c0, $c0, $c0, $80, $00, $00
    db $03, $03, $03, $03, $03, $01, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7f
    db $fc, $f8, $f8, $f8, $f8, $f8, $fc, $fe

    ; padding
    ds $10, $00

    db $3f, $1f, $1f, $1f, $1f, $1f, $3f, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $80, $e0, $f0, $e0, $c0, $e0, $ff, $00, $01, $03, $07, $03, $01, $03, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $fc, $f8, $f0, $f0, $e0
    db $e0, $80, $00, $00, $00, $00, $00, $00, $0f, $03, $00, $00, $00, $00, $00, $00
    db $ff, $ff, $ff, $7f, $3f, $1f, $1f, $0f, $e0, $c0, $c0, $c0, $80, $80, $80, $80

    ; padding
    ds $10, $00

    db $0f, $07, $07, $07, $07, $03, $03, $03, $80, $80, $80, $80, $c0, $c0, $c0, $e0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01
    db $03, $03, $07, $1f, $7f, $ff, $ff, $ff, $e0, $f0, $f8, $fc, $fe, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $80, $f0, $ff, $03, $03, $07, $07, $07, $0f, $1f, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $fc, $f8, $f8, $f0
    db $f0, $c0, $00, $00, $00, $00, $00, $00, $07, $01, $00, $00, $00, $00, $00, $00
    db $ff, $ff, $7f, $3f, $1f, $0f, $0f, $07, $f0, $e0, $e0, $e0, $e0, $c0, $c0, $c0

    ; padding
    ds $10, $00

    db $07, $03, $03, $03, $01, $01, $01, $01, $c0, $c0, $e0, $f8, $fe, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $80, $80, $00, $00, $00, $00, $00, $00, $00, $00
    db $01, $01, $01, $01, $03, $03, $03, $07, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $c0, $c0, $e0, $e0, $e0, $f0, $f8, $ff, $00, $00, $00, $00, $00, $01, $0f, $ff
    db $07, $0f, $1f, $3f, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f8
    db $fe, $f8, $f0, $e0, $e0, $e0, $e0, $00, $3f, $1f, $1f, $0f, $0f, $07, $07, $00
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $3f, $f0, $e0, $c0, $c0, $c0, $c0, $c0, $c0

    ; padding
    ds $10, $00

    db $1f, $0f, $07, $07, $07, $07, $07, $07, $c0, $e0, $e0, $e0, $e0, $e0, $c0, $80

    ; padding
    ds $10, $00

    db $07, $07, $0f, $0f, $0f, $07, $03, $01, $00, $00, $00, $00, $80, $c0, $e0, $f8

    ; padding
    ds $14, $00

    db $01, $03, $07, $1f, $8f, $03, $00, $00, $00, $80, $80, $80, $ff, $ff, $7f, $07
    db $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $3f, $0f, $03, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $c0, $c0, $c0, $e0, $e0, $f0, $f0, $f8, $00, $00, $00, $00
    db $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $3f, $1f
    db $0f, $07, $01, $00, $fc, $fc, $fe, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00
    db $00, $80, $80, $c0, $00, $00, $00, $00, $03, $07, $0f, $1f, $00, $07, $3f, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $c0, $e0, $e0, $f1
    db $f3, $f3, $ff, $ff, $3f, $7f

    ; padding
    ds $1b, $ff

    db $fc, $f0, $c0, $ff, $ff, $fe, $e0, $00, $00, $00, $00, $f1, $c0, $00, $00, $00
    db $01, $01, $01, $ff, $ff, $fc, $f8, $f0, $e0, $80, $00, $80, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $03, $07, $07
    db $0f, $0f, $1f, $00, $e0, $fc, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $c0
    db $e0, $f0, $f8, $00, $00, $00, $00, $00, $01, $01, $03, $3f, $3f, $7f, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fc, $fe, $ff, $ff, $ff
    db $ff, $ff, $ff, $03, $07, $07, $8f, $cf, $cf

    ; padding
    ds $16, $ff

    db $fc, $fc, $f8, $f8, $ff, $ff, $ff, $ff, $7f, $7f, $3f, $3f, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $e0, $e0, $e0, $f0, $f0, $f0, $e0, $e0
    db $00, $00, $00, $00, $1f, $1f, $0f, $0f, $00, $00, $00, $00, $ff, $ff, $ff, $ff
    db $0f, $0f, $0f, $1f, $f8, $fc, $fe, $ff, $ff, $ff, $fe, $fe, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $00, $00, $3f, $7f, $ff, $ff
    db $ff, $ff, $ff, $ff, $fe, $fc, $fc, $fc, $fc, $ff, $ff, $ff, $03, $07, $1f, $3f
    db $7f, $ff, $ff, $ff, $80, $c0, $f0, $f8, $fc, $ff, $ff, $ff, $ff, $7f, $7f, $7f
    db $7f, $ff, $ff, $ff, $ff, $ff, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $83, $03, $03
    db $0f, $f0, $c0, $80, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $3f, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $80, $80, $c0, $80, $00, $00, $00
    db $80, $c0, $40, $00, $1f, $1f, $1f, $1f, $3f, $00, $00, $00, $ff, $ff, $f3, $e3
    db $c3, $03, $03, $03, $c0, $c0, $e0, $f8, $fc, $fe, $fe, $fe, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $07, $0f, $1f, $1f, $0f, $07, $43, $e3, $f3, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $80, $c0
    db $e1, $ff, $ff, $ff, $00, $00, $00, $00, $80, $f0, $fc, $ff, $ff, $ff, $ff, $0f
    db $0f, $1f, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $cf, $c7, $ff, $ff, $ff, $83, $00, $80, $e0, $ff, $ff, $ff, $ff, $ff
    db $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ef, $e3, $e2, $c0, $c4
    db $84, $86, $84, $84, $07, $03, $01, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff
    db $ff, $ff, $0f, $01, $c0, $80, $c0, $ef, $ff, $ff, $ff, $ff, $00, $00, $00, $80
    db $80, $80, $87, $c7, $00, $00, $00, $00, $00, $00, $80, $c0, $01, $01, $03, $07
    db $1f, $1f, $0f, $0f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $c3, $e3, $e3, $c7
    db $cf, $ff, $ff, $ff, $c0, $c0, $c0, $e0, $f0, $f0, $f0, $f1, $0f, $0f, $03, $01
    db $01, $61, $e1, $f3, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $ff, $fc, $f8, $f0
    db $f0, $80, $00, $00, $ff, $3f, $1f, $0f, $0f, $0f, $01, $00, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00
    db $80, $c0, $80, $80, $00, $00, $00, $00, $00, $00, $01, $03, $7f, $7f, $7f, $7f
    db $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $80, $c0, $e2, $fe
    db $fe, $fe, $fe, $0e, $03, $07, $8f, $ff, $ff, $c3, $81, $00, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $fe, $fc, $fc, $fe, $ff, $ff, $ff, $ff, $02, $00, $00, $00
    db $06, $fe, $ff, $ff, $00, $01, $c3

    ; padding
    ds $14, $ff

    db $f3

    ; padding
    ds $18, $ff

    db $f0, $f0, $f0, $f0, $f8, $f8, $f8, $fc, $ff, $0f, $01, $00, $00, $00, $00, $00
    db $ff, $ff, $ff, $3f, $07, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $3f, $1f
    db $fc, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $80, $c0, $e0
    db $00, $00, $00, $00, $01, $03, $07, $0f, $0f, $1f, $7f, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f0, $f8, $fe, $ff, $ff, $ff, $ff, $ff
    db $1f, $3f, $3f, $7f

    ; padding
    ds $2b, $ff

    db $cf, $ff, $ff, $ff, $ff, $ff, $ff, $fc, $f8, $ff, $ff, $ff, $fc, $e0, $00, $00
    db $00, $ff, $f0, $80, $00, $00, $00, $00, $00, $0f, $0f, $0f, $0f, $1f, $1f, $1f
    db $3f, $f0, $f8, $fe, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $80, $c0, $e0
    db $f0, $00, $00, $00, $00, $00, $01, $03, $07, $3f, $7f, $7f, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f8, $fc, $fc, $fe, $ff, $ff, $ff
    db $ff, $0f, $1f, $7f

    ; padding
    ds $11, $ff

    db $fc, $f8, $f8, $f0, $ff, $f8, $80, $00, $00, $00, $00, $00, $ff, $07, $01, $00
    db $00, $00, $00, $00, $ff, $ff, $ff, $ff, $7f, $7f, $3f, $1f, $f0, $f0, $e0, $20
    db $00, $00, $80, $80

    ; padding
    ds $10, $00

    db $1f, $0f, $07, $07, $07, $07, $07, $07, $80, $80, $c0, $c0, $e0, $c0, $c0, $e0

    ; padding
    ds $10, $00

    db $07, $07, $0f, $0f, $1f, $3f, $1f, $0f, $c0, $80, $80, $00, $00, $0f, $3f, $ff
    db $00, $0f, $1f, $1f, $7f, $ff, $ff, $ff, $30, $f0, $f0, $f8, $fc, $fc, $fe, $ff
    db $07, $07, $03, $03, $01, $61, $f1, $fb

; I: 1bpp mask of stamp category 1 (45 items x $80 B), record 1 of 04:548B
StampCat01_Mask::
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
    db $f8
    db $e0
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $3f
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
    db $fe
    db $fc
    db $fc
    db $f8
    db $f8
    db $f8
    db $80
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $07
    db $03
    db $01
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
    db $7f
    db $7f
    db $7f
    db $f8
    db $f8
    db $f8
    db $f8
    db $f8
    db $f8
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
    db $00
    db $00
    db $03
    db $07
    db $07
    db $0f
    db $7f
    db $7f
    db $7f
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $fe
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $00
    db $00
    db $c0
    db $f0
    db $ff
    db $ff
    db $ff
    db $ff
    db $0f
    db $1f
    db $1f
    db $3f
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
    db $ff
    db $ff
    db $ff
    db $ff
    db $fc
    db $f0
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $1f
    db $07
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
    db $fe
    db $fe
    db $e0
    db $c0
    db $80
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
    db $ff
    db $ff
    db $7f
    db $3f
    db $3f
    db $1f
    db $1f
    db $1f
    db $fe
    db $fe
    db $fe
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $00
    db $00
    db $00
    db $00
    db $c0
    db $e0
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
    db $1f
    db $1f
    db $1f
    db $1f
    db $1f
    db $1f
    db $3f
    db $3f
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $f0
    db $f8
    db $f8
    db $fc
    db $ff
    db $ff
    db $ff
    db $ff
    db $00
    db $00
    db $03
    db $0f
    db $ff
    db $ff
    db $ff
    db $ff
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
    db $e3
    db $c1
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $c7
    db $83
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
    db $f3
    db $e1
    db $e1
    db $c0
    db $c0
    db $c0
    db $c1
    db $81
    db $81
    db $81
    db $81
    db $c1
    db $e3
    db $ff
    db $83
    db $81
    db $81
    db $81
    db $81
    db $83
    db $c7
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $cf
    db $87
    db $87
    db $07
    db $e0
    db $e0
    db $f1
    db $ff
    db $fe
    db $fe
    db $fc
    db $fc
    db $f0
    db $c0
    db $80
    db $00
    db $00
    db $00
    db $00
    db $00
    db $1f
    db $07
    db $03
    db $01
    db $00
    db $00
    db $00
    db $00
    db $07
    db $07
    db $8f
    db $ff
    db $ff
    db $ff
    db $7f
    db $7f
    db $fc
    db $fe
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $00
    db $00
    db $80
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $00
    db $00
    db $03
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
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
    db $fe
    db $fc
    db $fc
    db $f8
    db $f8
    db $ff
    db $c3
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $ff
    db $7f
    db $3f
    db $3f
    db $1f
    db $1f
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $f8
    db $fc
    db $fc
    db $fe
    db $ff
    db $ff
    db $ff
    db $ff
    db $00
    db $00
    db $00
    db $00
    db $00
    db $c0
    db $e0
    db $e0
    db $1f
    db $3f
    db $3f
    db $7f
    db $3f
    db $3f
    db $1f
    db $1f
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
    db $f0
    db $f0
    db $f0
    db $f8
    db $f8
    db $f8
    db $fc
    db $fc
    db $0f
    db $0f
    db $07
    db $07
    db $03
    db $03
    db $01
    db $01
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
    db $fc
    db $fe
    db $fe
    db $fe
    db $ff
    db $ff
    db $ff
    db $ff
    db $00
    db $00
    db $00
    db $00
    db $0f
    db $1f
    db $3f
    db $ff
    db $ff
    db $ff
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
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $fe
    db $fc
    db $fc
    db $f8
    db $f8
    db $ff
    db $c3
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $ff
    db $7f
    db $3f
    db $3f
    db $1f
    db $1f
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $f8
    db $fc
    db $fc
    db $fe
    db $fc
    db $fc
    db $f8
    db $f8
    db $00
    db $00
    db $00
    db $00
    db $00
    db $03
    db $07
    db $07
    db $1f
    db $3f
    db $3f
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
    db $ff
    db $ff
    db $f0
    db $f0
    db $e0
    db $e0
    db $c0
    db $c0
    db $80
    db $80
    db $0f
    db $0f
    db $0f
    db $1f
    db $1f
    db $1f
    db $3f
    db $3f
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
    db $fe
    db $ff
    db $ff
    db $ff
    db $ff
    db $00
    db $00
    db $00
    db $00
    db $f0
    db $f8
    db $fc
    db $ff
    db $3f
    db $7f
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
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $fe
    db $fc
    db $f8
    db $f0
    db $ff
    db $ff
    db $ff
    db $81
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $ff
    db $ff
    db $7f
    db $3f
    db $1f
    db $0f
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $f0
    db $f0
    db $e0
    db $e0
    db $e0
    db $e0
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
    db $0f
    db $0f
    db $07
    db $07
    db $07
    db $07
    db $07
    db $07
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
    db $c0
    db $80
    db $80
    db $80
    db $c0
    db $fc
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
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $ff
    db $7f
    db $3f
    db $39
    db $01
    db $01
    db $fe
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $00
    db $80
    db $f0
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $03
    db $0f
    db $7f
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $03
    db $87
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $80
    db $00
    db $00
    db $00
    db $80
    db $80
    db $ff
    db $ff
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $3f
    db $0f
    db $07
    db $03
    db $01
    db $01
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $c0
    db $e0
    db $c0
    db $80
    db $80
    db $80
    db $c0
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
    db $00
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $7f
    db $7f
    db $3f
    db $3f
    db $3f
    db $1f
    db $f8
    db $f8
    db $f0
    db $f0
    db $f8
    db $fc
    db $fe
    db $ff
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
    db $1f
    db $1f
    db $0f
    db $0f
    db $0f
    db $0f
    db $07
    db $07
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $f0
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $00
    db $fe
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $07
    db $07
    db $03
    db $03
    db $83
    db $c7
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
    db $fc
    db $f0
    db $e0
    db $c0
    db $80
    db $80
    db $ff
    db $ff
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $01
    db $00
    db $00
    db $00
    db $01
    db $01
    db $ff
    db $ff
    db $fe
    db $fe
    db $fc
    db $fc
    db $fc
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
    db $03
    db $07
    db $03
    db $01
    db $01
    db $01
    db $03
    db $07
    db $f8
    db $f8
    db $f0
    db $f0
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
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $01
    db $1f
    db $1f
    db $0f
    db $0f
    db $1f
    db $3f
    db $7f
    db $ff
    db $e0
    db $e0
    db $c0
    db $c0
    db $c1
    db $e3
    db $ff
    db $ff
    db $00
    db $7f
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
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
    db $fc
    db $f8
    db $fc
    db $ff
    db $ff
    db $ff
    db $ff
    db $cf
    db $03
    db $01
    db $00
    db $ff
    db $ff
    db $ff
    db $ff
    db $8f
    db $07
    db $07
    db $0f
    db $ff
    db $ff
    db $ff
    db $c1
    db $80
    db $80
    db $80
    db $c0
    db $ff
    db $ff
    db $ff
    db $ff
    db $3e
    db $00
    db $00
    db $00
    db $c8
    db $fc
    db $c0
    db $00
    db $00
    db $00
    db $00
    db $00
    db $0f
    db $03
    db $01
    db $01
    db $01
    db $03
    db $0f
    db $0f
    db $c0
    db $80
    db $80
    db $80
    db $80
    db $c0
    db $c0
    db $c0
    db $00
    db $00
    db $00
    db $00
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
    db $0f
    db $07
    db $03
    db $03
    db $01
    db $01
    db $01
    db $01
    db $c0
    db $c0
    db $c0
    db $e0
    db $e0
    db $f8
    db $ff
    db $ff
    db $00
    db $04
    db $0f
    db $0f
    db $1f
    db $3f
    db $ff
    db $ff
    db $00
    db $20
    db $f0
    db $f0
    db $f8
    db $fc
    db $ff
    db $ff
    db $01
    db $01
    db $03
    db $03
    db $07
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
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $fe
    db $f8
    db $f0
    db $c0
    db $ff
    db $fb
    db $c7
    db $07
    db $07
    db $0f
    db $0f
    db $1f
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $df
    db $8e
    db $0e
    db $06
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
    db $3f
    db $3f
    db $7f
    db $ff
    db $ff
    db $7f
    db $7f
    db $ff
    db $ff
    db $fe
    db $fc
    db $f8
    db $f0
    db $f0
    db $f8
    db $fe
    db $80
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $19
    db $0f
    db $07
    db $01
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $ff
    db $ff
    db $7f
    db $1f
    db $0f
    db $1f
    db $fc
    db $f0
    db $e0
    db $e0
    db $e0
    db $c1
    db $cf
    db $ff
    db $08
    db $58
    db $7c
    db $fc
    db $fc
    db $ff
    db $ff
    db $ff
    db $20
    db $3c
    db $3f
    db $7f
    db $ff
    db $ff
    db $ff
    db $ff
    db $3f
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
    db $80
    db $00
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $07
    db $03
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $fe
    db $fe
    db $fc
    db $fc
    db $f8
    db $f8
    db $e0
    db $c0
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
    db $0f
    db $03
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
    db $01
    db $01
    db $01
    db $01
    db $01
    db $00
    db $00
    db $00
    db $00
    db $f0
    db $f8
    db $fc
    db $ff
    db $ff
    db $ff
    db $ff
    db $00
    db $07
    db $0f
    db $1f
    db $ff
    db $ff
    db $ff
    db $ff
    db $00
    db $c0
    db $e0
    db $f0
    db $ff
    db $ff
    db $ff
    db $ff
    db $00
    db $1f
    db $3f
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
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $fe
    db $fc
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $7f
    db $3f
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
    db $fc
    db $f0
    db $e0
    db $c0
    db $80
    db $80
    db $f8
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $1f
    db $07
    db $03
    db $01
    db $01
    db $01
    db $01
    db $00
    db $ff
    db $ff
    db $ff
    db $ff
    db $f1
    db $c1
    db $83
    db $03
    db $e0
    db $f0
    db $e0
    db $c0
    db $e0
    db $f0
    db $fc
    db $ff
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
    db $01
    db $01
    db $01
    db $03
    db $03
    db $03
    db $03
    db $03
    db $83
    db $c1
    db $f1
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $c0
    db $e0
    db $f3
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $87
    db $cf
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
    db $81
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
    db $fc
    db $f8
    db $f0
    db $e0
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
    db $7f
    db $3f
    db $1f
    db $1f
    db $0f
    db $0f
    db $07
    db $07
    db $fc
    db $f0
    db $e0
    db $c0
    db $c0
    db $c0
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
    db $00
    db $00
    db $00
    db $01
    db $03
    db $07
    db $0f
    db $0f
    db $1f
    db $3f
    db $ff
    db $ff
    db $ff
    db $ff
    db $e0
    db $f0
    db $fc
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $00
    db $00
    db $01
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $1f
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
    db $81
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
    db $fc
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
    db $ff
    db $7f
    db $3f
    db $1f
    db $0f
    db $07
    db $01
    db $00
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $f0
    db $f0
    db $f8
    db $fc
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
    db $c0
    db $e0
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $3f
    db $0f
    db $07
    db $03
    db $03
    db $03
    db $03
    db $03
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $f8
    db $fe
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $00
    db $00
    db $80
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $07
    db $0f
    db $3f
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff

    db $ff, $ff, $ff, $ff, $f8, $f0, $e0, $c0, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $ff, $ff, $ff, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $1f, $0f, $07, $03
    db $c0, $80, $80, $00, $00, $00, $00, $80, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $03, $01, $01, $00, $00, $00, $00, $01
    db $80, $c0, $e0, $e0, $f0, $f0, $f8, $f8, $00, $00, $00, $00, $00, $40, $3f, $0f
    db $00, $00, $00, $00, $00, $02, $fc, $f0, $01, $03, $07, $07, $0f, $0f, $1f, $1f
    db $fc, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $c0, $f0, $ff, $ff, $ff
    db $00, $00, $00, $03, $0f, $ff, $ff, $ff, $3f, $7f, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $fe, $fc, $f8, $f0, $f0, $e0, $e0, $e0, $0f, $03, $01, $71, $f9, $f9, $f3, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $1f
    db $e0, $f0, $f0, $fc, $fe, $ff, $ff, $ff, $7f, $1f, $00, $00, $00, $00, $e0, $fe
    db $fc, $f0, $00, $00, $00, $00, $00, $00, $0f, $0f, $0f, $0f, $0f, $1f, $3f, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f8, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7f
    db $f0, $c0, $80, $8e, $9f, $9f, $cf, $ff, $7f, $3f, $1f, $0f, $0f, $07, $07, $07
    db $f0, $f0, $f0, $f0, $f0, $f8, $fc, $ff, $3f, $0f, $00, $00, $00, $00, $00, $00
    db $fe, $f8, $00, $00, $00, $00, $07, $7f, $07, $0f, $0f, $3f, $7f, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
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
    ds $175, $00

; I: Spriter's Resource sheet "Miscellaneous - Stamps (JPN)", 116 tiles
Sheet_MiscellaneousStampsJpn_2F_57F5::
    INCBIN "data/bank_2f/Sheet_MiscellaneousStampsJpn_2F_57F5.bin" ; $57F5, 11 bytes
; I: stamp category 16: symbols (suits, stars, currency, line pieces, arrows), 65 items x $40 B
StampCat16_Symbols_Gfx::
    db $00, $00, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
    db $00, $00, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
    db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $00, $00
    db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $00, $00
    db $00, $00, $7f, $7f, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40
    db $00, $00, $fe, $fe, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
    db $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $7f, $7f, $00, $00
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $fe, $fe, $00, $00
    db $00, $00, $07, $07, $1f, $1f, $3f, $3f, $7f, $7f, $7f, $7f, $ff, $ff, $ff, $ff
    db $00, $00, $c0, $c0, $f0, $f0, $f8, $f8, $fc, $fc, $fc, $fc, $fe, $fe, $fe, $fe
    db $ff, $ff, $ff, $ff, $ff, $ff, $7f, $7f, $7f, $7f, $3f, $3f, $1f, $1f, $07, $07
    db $fe, $fe, $fe, $fe, $fe, $fe, $fc, $fc, $fc, $fc, $f8, $f8, $f0, $f0, $c0, $c0
    db $00, $00, $07, $07, $18, $18, $20, $20, $47, $47, $48, $48, $90, $90, $90, $90
    db $00, $00, $c0, $c0, $30, $30, $08, $08, $c4, $c4, $24, $24, $12, $12, $12, $12
    db $90, $90, $90, $90, $90, $90, $48, $48, $47, $47, $20, $20, $18, $18, $07, $07
    db $12, $12, $12, $12, $12, $12, $24, $24, $c4, $c4, $08, $08, $30, $30, $c0, $c0
    db $00, $00, $00, $00, $01, $01, $03, $03, $03, $03, $07, $07, $0f, $0f, $0f, $0f
    db $00, $00, $00, $00, $00, $00, $80, $80, $80, $80, $c0, $c0, $e0, $e0, $e0, $e0
    db $1f, $1f, $3f, $3f, $3f, $3f, $7f, $7f, $ff, $ff, $ff, $ff, $00, $00, $00, $00
    db $f0, $f0, $f8, $f8, $f8, $f8, $fc, $fc, $fe, $fe, $fe, $fe, $00, $00, $00, $00
    db $00, $00, $00, $00, $01, $01, $02, $02, $02, $02, $04, $04, $08, $08, $08, $08
    db $00, $00, $00, $00, $00, $00, $80, $80, $80, $80, $40, $40, $20, $20, $20, $20
    db $10, $10, $20, $20, $20, $20, $40, $40, $80, $80, $ff, $ff, $00, $00, $00, $00
    db $10, $10, $08, $08, $08, $08, $04, $04, $02, $02, $fe, $fe, $00, $00, $00, $00
    db $00, $00, $01, $01, $01, $01, $03, $03, $03, $03, $07, $07, $ff, $ff, $7f, $7f
    db $00, $00, $00, $00, $00, $00, $80, $80, $80, $80, $c0, $c0, $fe, $fe, $fc, $fc
    db $1f, $1f, $0f, $0f, $0f, $0f, $1e, $1e, $1c, $1c, $18, $18, $30, $30, $20, $20
    db $f0, $f0, $e0, $e0, $e0, $e0, $f0, $f0, $70, $70, $30, $30, $18, $18, $08, $08
    db $00, $00, $01, $01, $02, $02, $02, $02, $04, $04, $04, $04, $f8, $f8, $40, $40
    db $00, $00, $00, $00, $80, $80, $80, $80, $40, $40, $40, $40, $3e, $3e, $04, $04
    db $20, $20, $10, $10, $08, $08, $11, $11, $12, $12, $24, $24, $28, $28, $30, $30
    db $08, $08, $10, $10, $20, $20, $10, $10, $90, $90, $48, $48, $28, $28, $18, $18
    db $00, $00, $01, $01, $01, $01, $03, $03, $07, $07, $0f, $0f, $1f, $1f, $3f, $3f
    db $00, $00, $00, $00, $00, $00, $80, $80, $c0, $c0, $e0, $e0, $f0, $f0, $f8, $f8
    db $7f, $7f, $7f, $7f, $7f, $7f, $3f, $3f, $1f, $1f, $03, $03, $07, $07, $0f, $0f
    db $fc, $fc, $fc, $fc, $fc, $fc, $f8, $f8, $f0, $f0, $80, $80, $c0, $c0, $e0, $e0
    db $00, $00, $01, $01, $01, $01, $02, $02, $04, $04, $08, $08, $10, $10, $20, $20
    db $00, $00, $00, $00, $00, $00, $80, $80, $40, $40, $20, $20, $10, $10, $08, $08
    db $40, $40, $40, $40, $40, $40, $20, $20, $1c, $1c, $02, $02, $04, $04, $0f, $0f
    db $04, $04, $04, $04, $04, $04, $08, $08, $70, $70, $80, $80, $40, $40, $e0, $e0
    db $00, $00, $03, $03, $07, $07, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $37, $37
    db $00, $00, $80, $80, $c0, $c0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $d8, $d8
    db $7b, $7b, $ff, $ff, $ff, $ff, $ff, $ff, $7b, $7b, $33, $33, $07, $07, $0f, $0f
    db $bc, $bc, $fe, $fe, $fe, $fe, $fe, $fe, $bc, $bc, $98, $98, $c0, $c0, $e0, $e0
    db $00, $00, $03, $03, $04, $04, $08, $08, $08, $08, $08, $08, $08, $08, $34, $34
    db $00, $00, $80, $80, $40, $40, $20, $20, $20, $20, $20, $20, $20, $20, $58, $58
    db $4a, $4a, $86, $86, $80, $80, $86, $86, $4a, $4a, $32, $32, $04, $04, $0f, $0f
    db $a4, $a4, $c2, $c2, $02, $02, $c2, $c2, $a4, $a4, $98, $98, $40, $40, $e0, $e0
    db $00, $00, $00, $00, $00, $00, $1c, $1c, $3e, $3e, $7f, $7f, $7f, $7f, $7f, $7f
    db $00, $00, $00, $00, $00, $00, $70, $70, $f8, $f8, $fc, $fc, $fc, $fc, $fc, $fc
    db $7f, $7f, $3f, $3f, $1f, $1f, $0f, $0f, $07, $07, $03, $03, $01, $01, $00, $00
    db $fc, $fc, $f8, $f8, $f0, $f0, $e0, $e0, $c0, $c0, $80, $80, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $1c, $1c, $22, $22, $41, $41, $40, $40, $40, $40
    db $00, $00, $00, $00, $00, $00, $70, $70, $88, $88, $04, $04, $04, $04, $04, $04
    db $40, $40, $20, $20, $10, $10, $08, $08, $04, $04, $02, $02, $01, $01, $00, $00
    db $04, $04, $08, $08, $10, $10, $20, $20, $40, $40, $80, $80, $00, $00, $00, $00
    db $00, $00, $01, $01, $03, $03, $07, $07, $0f, $0f, $1f, $1f, $3f, $3f, $7f, $7f
    db $00, $00, $00, $00, $80, $80, $c0, $c0, $e0, $e0, $f0, $f0, $f8, $f8, $fc, $fc
    db $ff, $ff, $7f, $7f, $3f, $3f, $1f, $1f, $0f, $0f, $07, $07, $03, $03, $01, $01
    db $fe, $fe, $fc, $fc, $f8, $f8, $f0, $f0, $e0, $e0, $c0, $c0, $80, $80, $00, $00
    db $00, $00, $01, $01, $02, $02, $04, $04, $08, $08, $10, $10, $20, $20, $40, $40
    db $00, $00, $00, $00, $80, $80, $40, $40, $20, $20, $10, $10, $08, $08, $04, $04
    db $80, $80, $40, $40, $20, $20, $10, $10, $08, $08, $04, $04, $02, $02, $01, $01
    db $02, $02, $04, $04, $08, $08, $10, $10, $20, $20, $40, $40, $80, $80, $00, $00
    db $00, $00, $06, $06, $1f, $1f, $3f, $3f, $76, $76, $66, $66, $76, $76, $3f, $3f
    db $00, $00, $c0, $c0, $f8, $f8, $fc, $fc, $cc, $cc, $c0, $c0, $c0, $c0, $f0, $f0
    db $1f, $1f, $06, $06, $06, $06, $66, $66, $7f, $7f, $3f, $3f, $06, $06, $00, $00
    db $f8, $f8, $dc, $dc, $cc, $cc, $dc, $dc, $f8, $f8, $f0, $f0, $c0, $c0, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $07, $07, $0f, $0f, $1c, $1c, $18, $18
    db $00, $00, $00, $00, $60, $60, $60, $60, $f0, $f0, $f8, $f8, $d8, $d8, $c0, $c0
    db $19, $19, $19, $19, $1d, $1d, $0f, $0f, $07, $07, $03, $03, $03, $03, $00, $00
    db $c0, $c0, $80, $80, $98, $98, $f8, $f8, $f0, $f0, $00, $00, $00, $00, $00, $00
    db $00, $00, $03, $03, $07, $07, $06, $06, $06, $06, $06, $06, $3f, $3f, $3f, $3f
    db $00, $00, $e0, $e0, $f0, $f0, $30, $30, $00, $00, $00, $00, $c0, $c0, $c0, $c0
    db $06, $06, $06, $06, $3e, $3e, $7f, $7f, $6f, $6f, $7c, $7c, $38, $38, $00, $00
    db $00, $00, $00, $00, $00, $00, $80, $80, $e6, $e6, $fe, $fe, $7c, $7c, $00, $00
    db $00, $00, $00, $00, $0f, $0f, $3f, $3f, $7f, $7f, $ff, $ff, $ec, $ec, $ec, $ec
    db $00, $00, $00, $00, $e0, $e0, $f8, $f8, $fc, $fc, $fe, $fe, $6e, $6e, $6e, $6e
    db $1f, $1f, $3a, $3a, $7f, $7f, $7a, $7a, $7f, $7f, $7a, $7a, $3f, $3f, $00, $00
    db $f0, $f0, $b8, $b8, $fc, $fc, $bc, $bc, $fc, $fc, $bc, $bc, $f8, $f8, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $80, $80
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $ff, $ff
    db $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $ff, $ff
    db $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $ff, $ff
    db $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $ff, $ff
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $ff, $ff, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $ff, $ff
    db $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
    db $ff, $ff, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $ff, $ff
    db $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
    db $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $80, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $03, $02, $06, $04
    db $00, $00, $00, $00, $00, $00, $00, $00, $7f, $7f, $ff, $80, $80, $00, $00, $00
    db $06, $04, $0c, $08, $0c, $08, $0c, $08, $0c, $08, $0c, $08, $0c, $08, $0c, $08
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $fe, $fe, $ff, $01, $01, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $c0, $40, $60, $20
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $60, $20, $30, $10, $30, $10, $30, $10, $30, $10, $30, $10, $30, $10, $30, $10
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $03, $02
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80
    db $03, $02, $06, $04, $06, $04, $0c, $08, $38, $30, $30, $00, $00, $00, $00, $00
    db $80, $80, $c0, $40, $c0, $40, $70, $30, $3c, $0c, $0c, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $30, $00, $38, $30, $0c, $08, $06, $04, $06, $04, $03, $02
    db $00, $00, $00, $00, $0c, $00, $3c, $0c, $70, $30, $c0, $40, $c0, $40, $80, $80
    db $03, $02, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $80, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $0c, $08, $0c, $08, $0c, $08, $0c, $08, $0c, $08, $0c, $08, $0c, $08, $0c, $08
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $0c, $08, $0c, $08, $0c, $08, $0c, $08, $0c, $08, $0c, $08, $0c, $08, $0c, $08
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $30, $10, $30, $10, $30, $10, $30, $10, $30, $10, $30, $10, $30, $10, $30, $10
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $30, $10, $30, $10, $30, $10, $30, $10, $30, $10, $30, $10, $30, $10, $30, $10
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $07, $06
    db $00, $00, $00, $00, $30, $20, $30, $20, $30, $20, $60, $40, $c0, $80, $00, $00
    db $1e, $18, $07, $06, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $80, $00, $e0, $80, $60, $40, $30, $20, $30, $20, $30, $20, $00, $00
    db $00, $00, $00, $00, $0c, $04, $0c, $04, $0c, $04, $06, $02, $03, $01, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $e0, $60
    db $00, $00, $01, $00, $07, $01, $06, $02, $0c, $04, $0c, $04, $0c, $04, $00, $00
    db $78, $18, $e0, $60, $80, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $0c, $08, $0c, $08, $0c, $08, $0c, $08, $0c, $08, $0c, $08, $0c, $08, $06, $04
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $06, $04, $03, $02, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $80, $00, $ff, $80, $7f, $7f, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $ff, $00, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $ff, $00, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $30, $10, $30, $10, $30, $10, $30, $10, $30, $10, $30, $10, $30, $10, $60, $20
    db $00, $00, $01, $00, $ff, $01, $fe, $fe, $00, $00, $00, $00, $00, $00, $00, $00
    db $60, $20, $c0, $40, $80, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $03, $03, $07, $04, $0c, $08, $18, $10, $18, $10
    db $00, $00, $00, $00, $00, $00, $c0, $c0, $e0, $20, $30, $10, $18, $08, $18, $08
    db $18, $10, $18, $10, $0c, $08, $07, $04, $03, $03, $00, $00, $00, $00, $00, $00
    db $18, $08, $18, $08, $30, $10, $e0, $20, $c0, $c0, $00, $00, $00, $00, $00, $00
    db $00, $00, $03, $03, $0f, $0c, $18, $10, $30, $20, $30, $20, $60, $40, $60, $40
    db $00, $00, $80, $80, $e0, $60, $70, $10, $18, $08, $18, $08, $0c, $04, $0c, $04
    db $60, $40, $30, $20, $30, $20, $18, $10, $0f, $0c, $03, $03, $00, $00, $00, $00
    db $0c, $04, $18, $08, $18, $08, $70, $10, $e0, $60, $80, $80, $00, $00, $00, $00
    db $00, $00, $03, $03, $0e, $0c, $18, $10, $20, $20, $60, $40, $4c, $4c, $cc, $8c
    db $00, $00, $c0, $c0, $70, $30, $18, $08, $04, $04, $06, $02, $32, $32, $33, $31
    db $80, $80, $c0, $80, $47, $47, $60, $40, $20, $20, $18, $10, $0e, $0c, $03, $03
    db $01, $01, $03, $01, $e2, $e2, $06, $02, $04, $04, $18, $08, $70, $30, $c0, $c0
    db $00, $00, $03, $03, $0e, $0c, $18, $10, $20, $20, $60, $40, $4c, $4c, $cc, $8c
    db $00, $00, $c0, $c0, $70, $30, $18, $08, $04, $04, $06, $02, $32, $32, $33, $31
    db $80, $80, $c7, $83, $4e, $44, $68, $48, $20, $20, $18, $10, $0e, $0c, $03, $03
    db $01, $01, $e3, $c1, $72, $22, $16, $12, $04, $04, $18, $08, $70, $30, $c0, $c0
    db $00, $00, $03, $03, $0e, $0c, $18, $10, $20, $20, $60, $40, $4c, $4c, $cc, $8c
    db $00, $00, $c0, $c0, $70, $30, $18, $08, $04, $04, $06, $02, $32, $32, $33, $31
    db $80, $80, $c0, $80, $48, $48, $6c, $44, $21, $23, $18, $10, $0e, $0c, $03, $03
    db $01, $01, $03, $01, $12, $12, $36, $22, $a4, $c4, $18, $08, $70, $30, $c0, $c0
    db $00, $00, $03, $03, $0c, $0c, $10, $10, $23, $23, $46, $46, $4c, $4c, $8c, $8c
    db $00, $00, $c0, $c0, $30, $30, $08, $08, $c4, $c4, $62, $62, $32, $32, $01, $01
    db $8c, $8c, $8c, $8c, $4c, $4c, $46, $46, $23, $23, $10, $10, $0c, $0c, $03, $03
    db $01, $01, $31, $31, $32, $32, $62, $62, $c4, $c4, $08, $08, $30, $30, $c0, $c0
    db $7f, $7f, $80, $80, $81, $83, $83, $87, $87, $87, $87, $87, $83, $87, $83, $83
    db $fe, $fe, $03, $01, $83, $c1, $c3, $e1, $e3, $e1, $e3, $e1, $c3, $e1, $c3, $c1
    db $81, $81, $80, $81, $80, $80, $81, $83, $83, $83, $81, $83, $ff, $80, $7f, $7f
    db $83, $81, $03, $81, $03, $01, $83, $c1, $c3, $c1, $83, $c1, $ff, $01, $fe, $fe
    db $00, $00, $00, $00, $00, $00, $1f, $1f, $10, $10, $10, $10, $10, $10, $10, $10
    db $00, $00, $00, $00, $00, $00, $e0, $e0, $40, $40, $80, $80, $40, $40, $20, $20
    db $14, $14, $1a, $1a, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $10, $10, $08, $08, $04, $04, $88, $88, $50, $50, $20, $20, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $1f, $1f, $1f, $1f, $1f, $1f, $1f, $1f, $1f, $1f
    db $00, $00, $00, $00, $00, $00, $e0, $e0, $c0, $c0, $80, $80, $c0, $c0, $e0, $e0
    db $1f, $1f, $1b, $1b, $11, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $f0, $f0, $f8, $f8, $fc, $fc, $f8, $f8, $70, $70, $20, $20, $00, $00, $00, $00
    db $00, $00, $01, $01, $02, $02, $04, $04, $08, $08, $10, $10, $20, $20, $3c, $3c
    db $00, $00, $00, $00, $80, $80, $40, $40, $20, $20, $10, $10, $08, $08, $78, $78
    db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $07, $07, $00, $00, $00, $00
    db $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $c0, $c0, $00, $00, $00, $00
    db $00, $00, $01, $01, $03, $03, $07, $07, $0f, $0f, $1f, $1f, $3f, $3f, $3f, $3f
    db $00, $00, $00, $00, $80, $80, $c0, $c0, $e0, $e0, $f0, $f0, $f8, $f8, $f8, $f8
    db $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $00, $00, $00, $00
    db $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $00, $00, $00, $00
    db $00, $00, $00, $00, $03, $03, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
    db $00, $00, $00, $00, $e0, $e0, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    db $1e, $1e, $10, $10, $08, $08, $04, $04, $02, $02, $01, $01, $00, $00, $00, $00
    db $3c, $3c, $04, $04, $08, $08, $10, $10, $20, $20, $40, $40, $80, $80, $00, $00
    db $00, $00, $00, $00, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03
    db $00, $00, $00, $00, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0
    db $1f, $1f, $1f, $1f, $0f, $0f, $07, $07, $03, $03, $01, $01, $00, $00, $00, $00
    db $fc, $fc, $fc, $fc, $f8, $f8, $f0, $f0, $e0, $e0, $c0, $c0, $80, $80, $00, $00
    db $00, $00, $00, $00, $00, $00, $03, $03, $05, $05, $09, $09, $11, $11, $20, $20
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $fc, $fc, $04, $04
    db $40, $40, $20, $20, $11, $11, $09, $09, $05, $05, $03, $03, $00, $00, $00, $00
    db $04, $04, $04, $04, $fc, $fc, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $03, $03, $07, $07, $0f, $0f, $1f, $1f, $3f, $3f
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $fc, $fc, $fc, $fc
    db $7f, $7f, $3f, $3f, $1f, $1f, $0f, $0f, $07, $07, $03, $03, $00, $00, $00, $00
    db $fc, $fc, $fc, $fc, $fc, $fc, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3f, $3f, $20, $20
    db $00, $00, $00, $00, $00, $00, $c0, $c0, $a0, $a0, $90, $90, $88, $88, $04, $04
    db $20, $20, $20, $20, $3f, $3f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $02, $02, $04, $04, $88, $88, $90, $90, $a0, $a0, $c0, $c0, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3f, $3f, $3f, $3f, $3f, $3f
    db $00, $00, $00, $00, $c0, $c0, $e0, $e0, $f0, $f0, $f8, $f8, $fc, $fc, $fe, $fe
    db $3f, $3f, $3f, $3f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $fc, $fc, $f8, $f8, $f0, $f0, $e0, $e0, $c0, $c0, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $1a, $1a, $14, $14
    db $00, $00, $00, $00, $20, $20, $50, $50, $88, $88, $04, $04, $08, $08, $10, $10
    db $10, $10, $10, $10, $10, $10, $10, $10, $1f, $1f, $00, $00, $00, $00, $00, $00
    db $20, $20, $40, $40, $80, $80, $40, $40, $e0, $e0, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $1b, $1b, $1f, $1f
    db $00, $00, $00, $00, $20, $20, $70, $70, $f8, $f8, $fc, $fc, $f8, $f8, $f0, $f0
    db $1f, $1f, $1f, $1f, $1f, $1f, $1f, $1f, $1f, $1f, $00, $00, $00, $00, $00, $00
    db $e0, $e0, $c0, $c0, $80, $80, $c0, $c0, $e0, $e0, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $20, $20, $10, $10, $08, $08, $04, $04, $02, $02, $01, $01
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $80, $80, $40, $40, $20, $20, $10, $10, $08, $08, $04, $04, $00, $00, $00, $00
    db $00, $00, $00, $00, $01, $01, $01, $01, $00, $00, $00, $00, $01, $01, $01, $01
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $01, $01, $01, $01, $00, $00, $00, $00, $01, $01, $01, $01
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $cc, $cc
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $cc, $cc
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $2, $00

    db $0a, $0c, $05, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $40, $80, $b0, $60

    ; padding
    ds $2c, $00

    db $02, $01, $0d, $06, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $30
    db $a0, $c0

    ; padding
    ds $2c, $00

    db $04, $0c, $02, $06, $01, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $20, $30, $40, $60, $80, $c0

    ; padding
    ds $2c, $00

    db $0f, $0f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $f0, $f0

    ; padding
    ds $2c, $00

    db $03, $03, $0e, $0c, $18, $10, $33, $20, $45, $63, $4e, $47, $84, $cc, $00, $00
    db $c0, $c0, $70, $30, $18, $08, $24, $ec, $e2, $e6, $26, $62, $41, $63, $88, $cc
    db $88, $cc, $48, $4c, $44, $6e, $33, $27, $18, $10, $0e, $0c, $03, $03, $41, $63
    db $41, $63, $46, $62, $62, $f6, $bc, $dc, $00, $00, $70, $30, $c0, $c0

    ; padding
    ds $42, $00

    db $04, $00, $41, $00, $08, $00, $04, $00, $21, $00, $04, $00, $ab, $00, $00, $00
    db $40, $00, $00, $00, $04, $00, $90, $00, $24, $00, $88, $00, $52, $00, $15, $00
    db $0b, $00, $22, $00, $01, $00, $44, $00, $11, $00, $00, $00, $00, $00, $a4, $00
    db $50, $00, $84, $00, $10, $00, $42, $00, $00, $00, $08, $00, $80, $00, $00, $00
    db $00, $04, $00, $41, $00, $08, $00, $04, $00, $21, $00, $04, $00, $ab, $00, $00
    db $00, $40, $00, $00, $00, $04, $00, $90, $00, $24, $00, $88, $00, $52, $00, $15
    db $00, $0b, $00, $22, $00, $01, $00, $44, $00, $11, $00, $00, $00, $00, $00, $a4
    db $00, $50, $00, $84, $00, $10, $00, $42, $00, $00, $00, $08, $00, $80, $00, $00
    db $04, $04, $41, $41, $08, $08, $04, $04, $21, $21, $04, $04, $ab, $ab, $00, $00
    db $40, $40, $00, $00, $04, $04, $90, $90, $24, $24, $88, $88, $52, $52, $15, $15
    db $0b, $0b, $22, $22, $01, $01, $44, $44, $11, $11, $00, $00, $00, $00, $a4, $a4
    db $50, $50, $84, $84, $10, $10, $42, $42, $00, $00, $08, $08, $80, $80, $c0, $c0
    db $c0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $03, $03
    db $03, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $01, $01
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $c0, $c0, $c0, $80, $80
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $03, $03

    ; padding
    ds $540, $00

; C: stamp categories 10 and 11 (same graphics, different mask fill): digits 0-9 and kanji numerals, 20 items x $40 B
StampCat10_11_Digits_Gfx::
    db $00, $00, $00, $00, $00, $00, $02, $01, $02, $07, $06, $0c, $1c, $08, $0c, $18
    db $00, $00, $00, $00, $00, $00, $40, $80, $a0, $c0, $b0, $60, $00, $30, $38, $10
    db $08, $18, $08, $18, $1c, $08, $07, $0c, $0b, $07, $03, $00, $00, $00, $00, $00
    db $18, $10, $38, $10, $60, $30, $40, $e0, $40, $80, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $02, $01, $01, $03, $07, $03, $03, $07, $05, $07, $06, $01
    db $00, $00, $00, $00, $80, $00, $80, $00, $80, $00, $80, $00, $80, $00, $00, $80
    db $00, $01, $00, $01, $01, $00, $01, $00, $02, $01, $00, $03, $02, $00, $00, $00
    db $00, $80, $00, $80, $80, $80, $c0, $80, $d0, $e0, $30, $c0, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $10, $0f, $09, $1f, $09, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $40, $80, $80, $c0, $00, $c0, $00, $c0
    db $00, $00, $01, $00, $03, $01, $00, $03, $03, $07, $0c, $07, $04, $00, $00, $00
    db $80, $c0, $c0, $80, $00, $80, $e0, $00, $f0, $f8, $ec, $18, $00, $00, $00, $00
    db $00, $00, $07, $00, $07, $0f, $09, $04, $00, $00, $00, $00, $01, $00, $03, $01
    db $00, $00, $80, $00, $80, $c0, $e0, $40, $00, $60, $c0, $60, $60, $c0, $c0, $e0
    db $01, $00, $00, $00, $00, $00, $00, $00, $07, $00, $0f, $07, $07, $00, $00, $00
    db $e0, $30, $10, $30, $00, $30, $70, $20, $40, $e0, $80, $c0, $00, $00, $00, $00
    db $00, $00, $00, $00, $02, $01, $00, $03, $07, $02, $00, $06, $06, $04, $0e, $04
    db $00, $00, $00, $00, $80, $00, $a0, $40, $e0, $40, $40, $c0, $00, $c0, $00, $c0
    db $04, $0f, $06, $0f, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $f8, $f0, $78, $c0, $e0, $40, $e0, $40, $e0, $40, $20, $40, $00, $00, $00, $00
    db $00, $00, $00, $00, $0b, $04, $07, $0f, $0f, $04, $0e, $04, $0e, $04, $04, $07
    db $00, $00, $00, $00, $e0, $00, $f0, $e0, $f0, $00, $00, $00, $00, $00, $40, $80
    db $07, $07, $02, $04, $00, $00, $00, $00, $00, $00, $06, $03, $07, $00, $00, $00
    db $40, $e0, $60, $30, $10, $30, $38, $10, $60, $30, $c0, $e0, $c0, $00, $00, $00
    db $00, $00, $00, $00, $00, $01, $01, $03, $07, $02, $00, $06, $0e, $04, $06, $0d
    db $00, $00, $80, $00, $c0, $80, $80, $00, $00, $00, $00, $00, $00, $00, $20, $c0
    db $07, $0f, $0e, $0c, $08, $0c, $08, $0c, $0f, $04, $03, $07, $03, $00, $00, $00
    db $e0, $f0, $10, $30, $00, $30, $30, $60, $60, $c0, $40, $80, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $10, $0f, $0c, $1f, $1c, $08, $0c, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $10, $e0, $10, $f0, $00, $30, $60, $30, $70, $20
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $01, $00, $00, $00
    db $00, $60, $e0, $40, $c0, $40, $00, $c0, $80, $c0, $c0, $80, $00, $80, $80, $00
    db $00, $00, $00, $00, $00, $00, $02, $01, $06, $03, $0c, $06, $04, $0c, $04, $0f
    db $00, $00, $00, $00, $00, $00, $e0, $c0, $a0, $70, $10, $30, $50, $30, $70, $e0
    db $09, $07, $01, $03, $07, $02, $04, $02, $06, $02, $06, $03, $02, $01, $00, $00
    db $f0, $e0, $d8, $30, $0c, $18, $1c, $08, $1c, $08, $d0, $38, $d0, $e0, $00, $00
    db $00, $00, $00, $00, $00, $00, $04, $03, $0e, $07, $02, $0c, $0c, $08, $0c, $08
    db $00, $00, $00, $00, $00, $00, $20, $c0, $a0, $40, $10, $20, $70, $20, $30, $60
    db $00, $0c, $04, $0f, $00, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $e0, $70, $c0, $f0, $40, $b0, $10, $30, $38, $10, $38, $10, $08, $10, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $05, $03, $0d, $06, $06, $0c
    db $00, $00, $00, $00, $00, $00, $00, $00, $c0, $e0, $20, $f0, $30, $18, $1c, $08
    db $00, $0c, $04, $0c, $0d, $06, $07, $03, $03, $00, $00, $00, $00, $00, $00, $00
    db $1c, $08, $0c, $18, $d8, $30, $f0, $e0, $c0, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $04, $03, $04, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $60, $f0, $70, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $04, $03, $0c, $07, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $e0, $10, $e0, $00, $00
    db $00, $00, $00, $00, $01, $00, $03, $0f, $01, $0e, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $f0, $00, $fc, $f8, $f8, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $07, $0f, $0b, $04, $00, $00, $03, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $f0, $e0, $d0, $20, $00, $00, $20, $c0
    db $00, $03, $00, $00, $00, $00, $07, $00, $02, $07, $00, $00, $00, $00, $00, $00
    db $60, $c0, $00, $00, $00, $00, $f0, $00, $20, $f0, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $07, $00, $07, $3f, $0a, $34, $06, $34, $1e, $34
    db $00, $00, $00, $00, $00, $00, $e0, $00, $e0, $f0, $f8, $90, $d8, $90, $c0, $98
    db $3e, $14, $3e, $10, $38, $10, $0b, $10, $0b, $07, $0b, $04, $00, $00, $00, $00
    db $c0, $98, $a8, $d8, $1c, $e8, $fc, $08, $f0, $f8, $18, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $1f, $00, $06, $1f, $00, $06, $06, $04, $04, $07
    db $00, $00, $00, $00, $00, $00, $e0, $00, $70, $e0, $50, $20, $00, $00, $60, $80
    db $06, $0f, $0e, $04, $0e, $04, $0f, $04, $17, $0f, $33, $1c, $00, $00, $00, $00
    db $40, $e0, $00, $60, $00, $60, $80, $60, $e4, $f8, $cc, $38, $00, $00, $00, $00
    db $00, $00, $00, $00, $01, $00, $01, $01, $00, $01, $00, $00, $13, $0f, $13, $0c
    db $00, $00, $00, $00, $00, $00, $00, $80, $c0, $80, $80, $00, $c0, $f8, $f0, $08
    db $00, $00, $05, $02, $03, $06, $0c, $06, $0a, $04, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $30, $18, $30, $00, $18, $1c, $08, $04, $08, $00, $00, $00, $00
    db $00, $00, $00, $00, $02, $00, $07, $02, $00, $06, $1e, $07, $3c, $1f, $1e, $04
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $10, $e0, $18, $f0, $10, $00
    db $0e, $04, $0e, $04, $0e, $04, $04, $07, $04, $03, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $f0, $10, $e0, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $04, $02, $0c, $06
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $10, $20, $20, $30
    db $0c, $04, $00, $0c, $00, $0c, $0c, $08, $08, $00, $00, $00, $00, $00, $00, $00
    db $10, $30, $30, $18, $08, $18, $1c, $08, $04, $08, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $02, $01, $01, $03, $1c, $03, $0f, $1f, $1f, $02, $06, $02
    db $00, $00, $00, $00, $80, $00, $00, $00, $00, $00, $d0, $e0, $f0, $20, $70, $20
    db $00, $06, $00, $06, $06, $04, $0e, $04, $0e, $04, $0c, $00, $00, $00, $00, $00
    db $00, $60, $00, $60, $10, $60, $74, $38, $10, $08, $00, $00, $00, $00, $00, $00

    db $00, $00, $00

    ; padding
    ds $afd, $00
