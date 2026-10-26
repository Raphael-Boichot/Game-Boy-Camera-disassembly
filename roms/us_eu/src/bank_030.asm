; Game Boy Camera (USA, Europe), bank $30. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $030", ROMX[$4000], BANK[$30]

; I: stamp categories 8 and 9 (same graphics, different mask fill): katakana, 85 items x $40 B
StampCat08_09_Katakana_Gfx::
    db $00
    db $00
    db $00
    db $00

    db $01, $00, $01, $01, $03, $01, $00, $03, $03, $02, $02, $06, $00, $00, $00, $00
    db $80, $00, $80, $80, $c0, $80, $40, $c0, $40, $60, $70, $20, $04, $06, $06, $04
    db $0c, $07, $06, $0f, $08, $0c, $1c, $08, $08, $18, $18, $00, $20, $30, $30, $10
    db $f0, $f8, $08, $f8, $0c, $08, $04, $0c, $00, $04, $00, $00, $00, $00, $00, $00
    db $07, $00, $0f, $0f, $18, $08, $0c, $08, $08, $0c, $05, $0c, $00, $00, $00, $00
    db $00, $00, $c0, $80, $60, $c0, $40, $60, $c0, $60, $80, $c0, $0f, $07, $0c, $07
    db $04, $04, $06, $04, $04, $06, $00, $06, $0b, $07, $04, $0f, $a0, $c0, $b0, $60
    db $10, $30, $38, $10, $20, $30, $60, $60, $c0, $c0, $80, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $01, $03, $03, $02, $06, $06, $04, $00, $00, $00, $00
    db $00, $00, $00, $00, $c0, $80, $80, $00, $00, $00, $00, $00, $0c, $04, $00, $0c
    db $0c, $08, $0c, $08, $04, $0c, $06, $07, $04, $03, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $18, $30, $60, $f0, $40, $80, $00, $00, $00, $00, $00, $00
    db $00, $00, $16, $0f, $17, $19, $10, $18, $10, $18, $00, $18, $00, $00, $00, $00
    db $00, $00, $00, $00, $80, $c0, $40, $e0, $70, $20, $00, $30, $00, $18, $00, $18
    db $08, $18, $18, $08, $1e, $09, $1f, $0f, $04, $08, $00, $00, $10, $30, $20, $30
    db $70, $20, $c0, $60, $80, $c0, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $3f, $0f, $37, $38, $30, $10, $30, $10, $30, $10, $31, $1f, $00, $00, $a0, $40
    db $c0, $e0, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $80, $38, $1f, $30, $10
    db $18, $10, $18, $10, $1f, $10, $1f, $1f, $08, $10, $00, $00, $00, $80, $00, $00
    db $00, $00, $00, $00, $80, $70, $f8, $f0, $00, $00, $00, $00, $00, $00, $00, $00
    db $07, $00, $0f, $07, $04, $06, $06, $04, $06, $04, $06, $04, $00, $00, $00, $00
    db $7c, $fe, $3e, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $04, $04, $05, $07
    db $06, $07, $06, $04, $04, $06, $04, $06, $04, $06, $00, $06, $c0, $38, $e8, $f0
    db $80

    ; padding
    ds $13, $00

    db $03, $01, $02, $07, $06, $0c, $18, $08, $00, $00, $00, $00, $00, $00, $80, $00
    db $80, $c0, $00, $00, $00, $00, $00, $00, $10, $18, $39, $10, $10, $31, $10, $30
    db $39, $10, $0f, $1b, $05, $0e, $00, $00, $00, $00, $80, $70, $98, $f0, $50, $38
    db $70, $f8, $48, $98, $18, $08, $08, $08, $00, $00, $00, $00, $00, $00, $18, $08
    db $18, $08, $18, $08, $18, $08, $19, $08, $00, $00, $30, $00, $00, $30, $10, $30
    db $30, $10, $18, $10, $10, $18, $e0, $18, $0f, $0f, $0b, $0c, $0c, $08, $0c, $08
    db $08, $0c, $00, $0c, $00, $00, $00, $00, $c8, $f8, $18, $08, $18, $08, $0c, $08
    db $0c, $08, $08, $0c, $00, $0c, $0c, $00, $00, $00, $01, $0e, $1f, $0e, $06, $02
    db $07, $02, $03, $02, $03, $02, $03, $02

    ; padding
    ds $11, $00

    db $03, $00, $03, $00, $03, $01, $03, $07, $03, $01, $06, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $c0, $e0, $80, $60

    ; padding
    ds $14, $00

    db $78, $f0, $b0, $60, $60, $20, $30, $20, $30, $20, $60, $20, $20, $60, $00, $60
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $1b, $11, $0e, $1f, $0e, $00
    db $00, $60, $60, $40, $c0, $40, $40, $c0, $c0, $80, $80, $80, $00, $00, $00, $00
    db $00, $00, $00, $00, $18, $08, $18, $08, $18, $08, $08, $18, $00, $19, $01, $1b
    db $00, $00, $00, $00, $30, $00, $20, $30, $20, $60, $60, $c0, $c0, $80, $80, $00
    db $03, $1f, $0d, $1f, $0c, $18, $10, $18, $10, $18, $10, $18, $00, $18, $00, $00
    db $00, $00, $80, $c0, $f0, $60, $18, $30, $08, $1c, $08, $04, $00, $00, $00, $00
    db $00, $00, $00, $00, $04, $02, $02, $06, $02, $06, $00, $06, $00, $06, $00, $06

    ; padding
    ds $10, $00

    db $04, $06, $04, $06, $04, $06, $06, $04, $07, $04, $07, $07, $07, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $e0, $00, $fc, $f8, $00, $00, $00, $00
    db $00, $00, $00, $00, $10, $00

    db $18
    db $18
    db $18
    db $1c
    db $16
    db $1c
    db $02
    db $1e
    db $02
    db $1b
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $70
    db $20
    db $60
    db $70
    db $f8
    db $50
    db $48
    db $d8
    db $dc
    db $88
    db $03
    db $19
    db $09
    db $19
    db $19
    db $08
    db $18
    db $08
    db $18
    db $08
    db $10
    db $08
    db $00
    db $00
    db $00
    db $00
    db $88
    db $8c
    db $0c
    db $84
    db $06
    db $04
    db $00
    db $06
    db $04
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
    db $18
    db $08
    db $0c
    db $0c
    db $0e
    db $0e
    db $09
    db $0f
    db $0d
    db $09
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $08
    db $00
    db $1c
    db $08
    db $18
    db $08
    db $0c
    db $08
    db $88
    db $8c
    db $0c
    db $08
    db $08
    db $0c
    db $08
    db $0c
    db $08
    db $0c
    db $08
    db $0c
    db $00
    db $0c
    db $00
    db $00
    db $00
    db $00
    db $c0
    db $cc
    db $40
    db $6c
    db $60
    db $3c
    db $38
    db $1c
    db $10
    db $0c
    db $08
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
    db $07
    db $03
    db $0c
    db $07
    db $1c
    db $08
    db $10
    db $18
    db $30
    db $10
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $80
    db $00
    db $c0
    db $e0
    db $b0
    db $70
    db $10
    db $18
    db $1c
    db $08
    db $10
    db $30
    db $10
    db $30
    db $30
    db $10
    db $10
    db $18
    db $18
    db $0c
    db $0f
    db $07
    db $03
    db $00
    db $00
    db $00
    db $00
    db $0c
    db $04
    db $0c
    db $00
    db $0c
    db $1c
    db $08
    db $50
    db $38
    db $e0
    db $f0
    db $c0
    db $00
    db $00
    db $00
    db $00
    db $04
    db $0e
    db $05
    db $0d
    db $07
    db $0c
    db $04
    db $0c
    db $04
    db $0c
    db $04
    db $04
    db $04
    db $0e
    db $04
    db $00
    db $00
    db $30
    db $c0
    db $30
    db $f8
    db $1c
    db $08
    db $04
    db $0c
    db $06
    db $04
    db $04
    db $0c
    db $dc
    db $38
    db $0f
    db $07
    db $0f
    db $04
    db $0c
    db $04
    db $0c
    db $04
    db $0c
    db $04
    db $08
    db $04
    db $00
    db $00
    db $00
    db $00
    db $d0
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
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $02
    db $01
    db $02
    db $07
    db $06
    db $0c
    db $08
    db $18
    db $10
    db $30
    db $00
    db $30
    db $20
    db $30
    db $00
    db $00
    db $c0
    db $c0
    db $70
    db $e0
    db $10
    db $30
    db $10
    db $18
    db $18
    db $08
    db $0c
    db $08
    db $0c
    db $08
    db $30
    db $20
    db $20
    db $30
    db $39
    db $10
    db $1f
    db $0f
    db $0d
    db $02
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $c8
    db $18
    db $58
    db $f0
    db $60
    db $f0
    db $b0
    db $d8
    db $18
    db $0c
    db $0e
    db $04
    db $06
    db $00
    db $00
    db $00
    db $00
    db $00
    db $3e
    db $11
    db $3e
    db $1f
    db $38
    db $10
    db $30
    db $10
    db $30
    db $10
    db $30
    db $10
    db $3d
    db $13
    db $00
    db $00
    db $00
    db $c0
    db $70
    db $e0
    db $20
    db $30
    db $00
    db $30
    db $30
    db $20
    db $c0
    db $60
    db $80
    db $c0
    db $3f
    db $1f
    db $32
    db $11
    db $30
    db $10
    db $18
    db $10
    db $18
    db $10
    db $00
    db $10
    db $00
    db $00
    db $00
    db $00
    db $00
    db $80
    db $80
    db $c0
    db $d0
    db $60
    db $30
    db $38
    db $0c
    db $18
    db $08
    db $04
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $04
    db $03
    db $1e
    db $0f
    db $34
    db $18
    db $00
    db $30
    db $10
    db $30
    db $37
    db $18
    db $1f
    db $0f
    db $00
    db $00
    db $60
    db $80
    db $f0
    db $e0
    db $10
    db $20
    db $00
    db $00
    db $00
    db $00
    db $f0
    db $00
    db $f0
    db $f8
    db $00
    db $00
    db $00
    db $00
    db $00
    db $0c
    db $0c
    db $06
    db $07
    db $03
    db $00
    db $01
    db $00
    db $00
    db $00
    db $00
    db $1c
    db $08
    db $00
    db $0c
    db $04
    db $0c
    db $08
    db $0c
    db $6c
    db $98
    db $e8
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
    db $07
    db $3f
    db $03
    db $3c
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $78
    db $00
    db $f8
    db $f8
    db $80
    db $c0
    db $00
    db $c0
    db $00
    db $c0
    db $40
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
    db $40
    db $c0
    db $40
    db $c0
    db $00
    db $c0
    db $00
    db $c0
    db $00
    db $c0
    db $00
    db $c0
    db $40
    db $c0
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $04
    db $00
    db $04
    db $0c
    db $00
    db $0c
    db $00
    db $0c
    db $00
    db $0c
    db $08
    db $0c
    db $00
    db $00
    db $00
    db $00
    db $08
    db $00
    db $08
    db $18
    db $08
    db $18
    db $18
    db $08
    db $18
    db $08
    db $18
    db $08
    db $00
    db $0c
    db $00
    db $0c
    db $04
    db $0c
    db $0c
    db $06
    db $07
    db $03
    db $01
    db $00
    db $00
    db $00
    db $00
    db $00
    db $18
    db $08
    db $18
    db $08
    db $00
    db $18
    db $38
    db $10
    db $e0
    db $f0
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
    db $10
    db $08
    db $08
    db $18
    db $1c
    db $08
    db $08
    db $0c
    db $0c
    db $04
    db $00
    db $00
    db $00
    db $00
    db $04
    db $08
    db $1c
    db $08
    db $08
    db $18
    db $18
    db $10
    db $30
    db $10
    db $20
    db $30
    db $06
    db $04
    db $02
    db $06
    db $07
    db $02
    db $02
    db $03
    db $03
    db $01
    db $01
    db $00
    db $00
    db $00
    db $00
    db $00
    db $70
    db $20
    db $60
    db $20
    db $00
    db $60
    db $60
    db $40
    db $80
    db $c0
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
    db $44
    db $02
    db $66
    db $42
    db $07
    db $62
    db $22
    db $67
    db $37
    db $27
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $04
    db $06
    db $06
    db $04
    db $0c
    db $04
    db $08
    db $0c
    db $35
    db $27
    db $0e
    db $35
    db $3d
    db $1c
    db $1c
    db $18
    db $00
    db $18
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $9c
    db $08
    db $08
    db $98
    db $f8
    db $90
    db $60
    db $f0
    db $00
    db $60
    db $00
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
    db $08
    db $18
    db $08
    db $08
    db $0c
    db $0e
    db $04
    db $04
    db $06
    db $07
    db $02
    db $00
    db $00
    db $00
    db $00
    db $18
    db $00
    db $10
    db $18
    db $10
    db $30
    db $20
    db $30
    db $20
    db $60
    db $e0
    db $40
    db $01
    db $03
    db $01
    db $01
    db $01
    db $03
    db $02
    db $06
    db $0e
    db $04
    db $04
    db $0c
    db $00
    db $00
    db $00
    db $00
    db $80
    db $c0
    db $80
    db $80
    db $80
    db $c0
    db $c0
    db $60
    db $70
    db $20
    db $00
    db $30
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $30
    db $20
    db $18
    db $30
    db $08
    db $18
    db $08
    db $0c
    db $0e
    db $04
    db $02
    db $07
    db $00
    db $00
    db $10
    db $00
    db $18
    db $30
    db $20
    db $30
    db $20
    db $60
    db $60
    db $40
    db $40
    db $c0
    db $80
    db $80
    db $01
    db $03
    db $03
    db $01
    db $03
    db $01
    db $03
    db $01
    db $01
    db $01
    db $01
    db $01
    db $01
    db $00
    db $00
    db $00
    db $80
    db $00
    db $00
    db $00
    db $00
    db $00
    db $80
    db $00
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
    db $06
    db $01
    db $16
    db $0f
    db $14
    db $38
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
    db $10
    db $e0
    db $30
    db $e0
    db $20
    db $60
    db $60
    db $40
    db $80
    db $c0
    db $80
    db $80
    db $03
    db $01
    db $07
    db $02
    db $04
    db $06
    db $0e
    db $0d
    db $0f
    db $1f
    db $14
    db $08
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
    db $64
    db $f8
    db $0c
    db $fc
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
    db $01
    db $01
    db $00
    db $00
    db $01
    db $03
    db $01

    db $01, $03, $03, $02, $20, $60, $c0, $e0, $00, $80, $80, $00, $80, $80, $c0, $80
    db $40, $c0, $40, $60, $02, $06, $04, $06, $04, $07, $0e, $07, $06, $0c, $08, $0c
    db $1c, $08, $18, $00, $70, $20, $20, $30, $f0, $f0, $10, $f8, $08, $18, $0c, $08
    db $04, $0c, $00, $00, $02, $01, $03, $07, $00, $06, $01, $00, $00, $01, $03, $01
    db $01, $03, $03, $02, $40, $80, $c0, $e0, $20, $60, $80, $00, $80, $80, $c0, $80
    db $40, $c0, $40, $60, $02, $06, $04, $06, $04, $07, $0e, $07, $06, $0c, $08, $0c
    db $1c, $08, $18, $00, $70, $20, $20, $30, $f0, $f0, $10, $f8, $08, $18, $0c, $08
    db $04, $0c, $00, $00, $02, $03, $01, $03, $00, $00, $01, $00, $00, $01, $03, $01
    db $01, $03, $03, $02, $00, $00, $c0, $80, $00, $c0, $80, $00, $80, $80, $c0, $80
    db $40, $c0, $40, $60, $02, $06, $04, $06, $04, $07, $0e, $07, $06, $0c, $08, $0c
    db $1c, $08, $18, $00, $70, $20, $20, $30, $f0, $f0, $10, $f8, $08, $18, $0c, $08
    db $04, $0c, $00, $00, $00, $00, $04, $0c, $0c, $0c, $01, $00, $00, $01, $03, $01
    db $01, $03, $03, $02, $00, $00, $10, $30, $30, $30, $80, $00, $80, $80, $c0, $80
    db $40, $c0, $40, $60, $02, $06, $04, $06, $04, $07, $0e, $07, $06, $0c, $08, $0c
    db $1c, $08, $18, $00, $70, $20, $20, $30, $f0, $f0, $10, $f8, $08, $18, $0c, $08
    db $04, $0c, $00, $00, $00, $00, $01, $00, $00, $01, $00, $00, $13, $0f, $08, $1f
    db $18, $08, $18, $08, $20, $60, $c0, $e0, $00, $80, $70, $00, $e0, $f0, $70, $80
    db $00, $00, $00, $00, $18, $0f, $1e, $0f, $18, $08, $0c, $08, $0f, $08, $0f, $0f
    db $01, $0e, $00, $00, $e0, $c0, $20, $c0, $00, $00, $00, $00, $c0, $38, $fc, $f8
    db $c0, $00, $00, $00, $02, $01, $03, $07, $00, $06, $00, $00, $13, $0f, $08, $1f
    db $18, $08, $18, $08, $40, $80, $c0, $e0, $20, $60, $70, $00, $e0, $f0, $70, $80
    db $00, $00, $00, $00, $18, $0f, $1e, $0f, $18, $08, $0c, $08, $0f, $08, $0f, $0f
    db $01, $0e, $00, $00, $e0, $c0, $20, $c0, $00, $00, $00, $00, $c0, $38, $fc, $f8
    db $c0, $00, $00, $00, $02, $03, $01, $03, $00, $00, $00, $00, $13, $0f, $08, $1f
    db $18, $08, $18, $08, $00, $00, $c0, $80, $00, $c0, $70, $00, $e0, $f0, $70, $80
    db $00, $00, $00, $00, $18, $0f, $1e, $0f, $18, $08, $0c, $08, $0f, $08, $0f, $0f
    db $01, $0e, $00, $00, $e0, $c0, $20, $c0, $00, $00, $00, $00, $c0, $38, $fc, $f8
    db $c0, $00, $00, $00, $00, $00, $04, $0c, $0c, $0c, $00, $00, $13, $0f, $08, $1f
    db $18, $08, $18, $08, $00, $00, $10, $30, $30, $30, $70, $00, $e0, $f0, $70, $80
    db $00, $00, $00, $00, $18, $0f, $1e, $0f, $18, $08, $0c, $08, $0f, $08, $0f, $0f
    db $01, $0e, $00, $00, $e0, $c0, $20, $c0, $00, $00, $00, $00, $c0, $38, $fc, $f8
    db $c0, $00, $00, $00, $00, $00, $03, $01, $00, $03, $00, $00, $00, $03, $03, $03
    db $03, $01, $01, $01, $40, $c0, $80, $c0, $00, $00, $00, $00, $40, $80, $40, $80
    db $00, $80, $00, $80, $01, $01, $00, $01, $00, $01, $00, $01, $05, $03, $04, $03
    db $00, $00, $00, $00, $00, $80, $00, $80, $00, $80, $80, $80, $c0, $c0, $00, $c0
    db $00, $00, $00, $00, $00, $00, $04, $0c, $0c, $0c, $00, $00, $00, $03, $03, $03
    db $03, $01, $01, $01, $00, $00, $10, $30, $30, $30, $00, $00, $40, $80, $40, $80
    db $00, $80, $00, $80, $01, $01, $00, $01, $00, $01, $00, $01, $05, $03, $04, $03
    db $00, $00, $00, $00, $00, $80, $00, $80, $00, $80, $80, $80, $c0, $c0, $00, $c0
    db $00, $00, $00, $00, $00, $00, $03, $01, $03, $00, $07, $03, $0c, $07, $1c, $08
    db $10, $18, $30, $10, $40, $c0, $40, $80, $00, $00, $80, $00, $c0, $e0, $b0, $70
    db $10, $18, $1c, $08, $10, $30, $10, $30, $30, $10, $10, $18, $18, $0c, $0f, $07
    db $03, $00, $00, $00, $00, $0c, $04, $0c, $00, $0c, $1c, $08, $50, $38, $e0, $f0
    db $c0, $00, $00, $00, $00, $00, $04, $0c, $0c, $0c, $07, $03, $0c, $07, $1c, $08
    db $10, $18, $30, $10, $00, $00, $10, $30, $30, $30, $80, $00, $c0, $e0, $b0, $70
    db $10, $18, $1c, $08, $10, $30, $10, $30, $30, $10, $10, $18, $18, $0c, $0f, $07
    db $03, $00, $00, $00, $00, $0c, $04, $0c, $00, $0c, $1c, $08, $50, $38, $e0, $f0
    db $c0, $00, $00, $00, $00, $00, $03, $01, $03, $00, $08, $00, $08, $18, $00, $18
    db $00, $18, $10, $18, $40, $c0, $40, $80, $00, $00, $08, $00, $08, $18, $08, $18
    db $18, $08, $18, $08, $00, $18, $00, $18, $08, $18, $18, $0c, $0f, $07, $03, $00
    db $00, $00, $00, $00, $18, $08, $18, $08, $00, $18, $38, $10, $e0, $f0, $c0, $00
    db $00, $00, $00, $00, $00, $00, $04, $0c, $0c, $0c, $04, $00, $08, $18, $00, $18
    db $00, $18, $10, $18, $00, $00, $10, $30, $30, $30, $08, $00, $08, $18, $08, $18
    db $18, $08, $18, $08, $00, $18, $00, $18, $08, $18, $18, $0c, $0f, $07, $03, $00
    db $00, $00, $00, $00, $18, $08, $18, $08, $00, $18, $38, $10, $e0, $f0, $c0, $00
    db $00, $00, $00, $00, $00, $03, $03, $07, $02, $04, $04, $08, $0c, $0c, $0e, $0e
    db $09, $0f, $0d, $09, $08, $90, $98, $f0, $60, $60, $08, $00, $1c, $08, $1c, $08
    db $0c, $08, $88, $8c, $0c, $08, $08, $0c, $08, $0c, $08, $0c, $08, $0c, $00, $0c
    db $00, $00, $00, $00, $c0, $cc, $40, $6c, $60, $3c, $38, $1c, $10, $0c, $08, $04
    db $00, $00, $00, $00, $00, $00, $00, $00, $08, $1c, $0c, $1c, $04, $0c, $08, $0c

    db $00
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
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
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
    db $08
    db $08
    db $18
    db $10
    db $18
    db $10
    db $30
    db $10
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
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $18
    db $30
    db $18
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
    db $00
    db $00
    db $00
    db $00
    db $e0
    db $07
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
    db $00
    db $00
    db $00
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
    db $00
    db $00
    db $00
    db $00
    db $01
    db $06
    db $03
    db $07
    db $00
    db $00
    db $00
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
    db $80
    db $c0
    db $e0
    db $60
    db $e0
    db $70
    db $90
    db $f0
    db $02
    db $07
    db $06
    db $0c
    db $0c
    db $08
    db $08
    db $0c
    db $06
    db $07
    db $00
    db $03
    db $00
    db $00
    db $00
    db $00
    db $10
    db $18
    db $00
    db $18
    db $08
    db $18
    db $38
    db $18
    db $68
    db $f0
    db $20
    db $c0
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $04
    db $08
    db $08
    db $0c
    db $08
    db $0c
    db $00
    db $0c
    db $00
    db $0c
    db $05
    db $0f
    db $0f
    db $06
    db $00
    db $00
    db $00
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
    db $e0
    db $e0
    db $30
    db $06
    db $04
    db $06
    db $04
    db $04
    db $06
    db $00
    db $06
    db $03
    db $06
    db $03
    db $03
    db $03
    db $00
    db $00
    db $00
    db $00
    db $30
    db $20
    db $30
    db $70
    db $20
    db $c0
    db $60
    db $80
    db $c0
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
    db $05
    db $02
    db $07
    db $0e
    db $1c
    db $08
    db $10
    db $18
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
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
    db $10
    db $30
    db $10
    db $30
    db $10
    db $17
    db $18
    db $1f
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
    db $10
    db $08
    db $b0
    db $78
    db $a0
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
    db $02
    db $01
    db $0f
    db $07
    db $00
    db $00
    db $40
    db $00
    db $c0
    db $40
    db $40
    db $40
    db $60
    db $40
    db $60
    db $40
    db $60
    db $40
    db $e0
    db $40
    db $18
    db $0c
    db $10
    db $18
    db $30
    db $10
    db $00
    db $30
    db $1d
    db $33
    db $0e
    db $1f
    db $00
    db $00
    db $00
    db $00
    db $60
    db $40
    db $40
    db $60
    db $00
    db $60
    db $b0
    db $70
    db $f0
    db $e0
    db $70
    db $20
    db $10
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
    db $05
    db $03
    db $0d
    db $06
    db $18
    db $0c
    db $1d
    db $1f
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $80
    db $00
    db $c0
    db $e0
    db $20
    db $60
    db $c0
    db $60
    db $80
    db $c0
    db $19
    db $16
    db $18
    db $10
    db $10
    db $18
    db $1c
    db $08
    db $06
    db $0f
    db $04
    db $03
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $04
    db $00
    db $0c
    db $0c
    db $38
    db $18
    db $60
    db $f0
    db $20
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
    db $00
    db $01
    db $01
    db $03
    db $07
    db $0f
    db $20
    db $10
    db $20
    db $70
    db $60
    db $c0
    db $c0
    db $80
    db $80
    db $80
    db $40
    db $b0
    db $d0
    db $e0
    db $00
    db $80
    db $04
    db $09
    db $00
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
    db $80
    db $00
    db $80
    db $80
    db $80
    db $80
    db $80
    db $c0
    db $80
    db $c0
    db $80
    db $80
    db $c0
    db $40
    db $80
    db $01
    db $00
    db $07
    db $03
    db $04
    db $0e
    db $0c
    db $08
    db $18
    db $08
    db $0c
    db $08
    db $04
    db $0f
    db $03
    db $07
    db $c0
    db $00
    db $c0
    db $e0
    db $20
    db $60
    db $30
    db $60
    db $20
    db $60
    db $60
    db $60
    db $f0
    db $e0
    db $20
    db $b0
    db $00
    db $00
    db $00
    db $00
    db $04
    db $08
    db $1c
    db $08
    db $18
    db $08
    db $08
    db $0f
    db $0a
    db $07
    db $00
    db $00
    db $30
    db $10
    db $18
    db $10
    db $18
    db $10
    db $10
    db $30
    db $30
    db $60
    db $e0
    db $c0
    db $40
    db $80
    db $00
    db $00
    db $00
    db $00
    db $10
    db $00
    db $18
    db $10
    db $18
    db $10
    db $18
    db $10
    db $00
    db $18
    db $00
    db $18
    db $08
    db $18
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $1b
    db $0f
    db $1c
    db $0f
    db $1c
    db $0c
    db $1c
    db $08
    db $0c
    db $08
    db $00
    db $08
    db $00
    db $00
    db $00
    db $00
    db $40
    db $80
    db $40
    db $c0
    db $40
    db $60
    db $20
    db $30
    db $10
    db $30
    db $18
    db $10
    db $08
    db $18
    db $08
    db $00
    db $00
    db $00
    db $00
    db $00
    db $03
    db $00
    db $03
    db $01
    db $00
    db $00
    db $00
    db $00
    db $00
    db $01
    db $01
    db $01
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $80
    db $80
    db $80
    db $00
    db $00
    db $00
    db $80
    db $00
    db $80
    db $00
    db $01
    db $01
    db $00
    db $01
    db $00
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
    db $80
    db $00
    db $80
    db $00
    db $80
    db $80
    db $80
    db $80
    db $80
    db $c0
    db $80
    db $40
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
    db $e0
    db $40
    db $00
    db $60
    db $00
    db $00
    db $00
    db $00
    db $20
    db $00
    db $60
    db $20
    db $70
    db $20
    db $30
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
    db $0b
    db $07
    db $09
    db $06
    db $30
    db $20
    db $20
    db $30
    db $20
    db $30
    db $30
    db $20
    db $20
    db $60
    db $60
    db $c0
    db $c0
    db $80
    db $00
    db $00
    db $00
    db $00
    db $08
    db $04
    db $0c
    db $04
    db $0c
    db $04
    db $0c
    db $04
    db $0c
    db $04
    db $0c
    db $04
    db $0c
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
    db $10
    db $00
    db $0e
    db $04
    db $06
    db $04
    db $00
    db $07
    db $07
    db $03
    db $06
    db $03
    db $00
    db $02
    db $00
    db $00
    db $00
    db $00
    db $10
    db $30
    db $70
    db $60
    db $80
    db $c0
    db $c0
    db $80
    db $68
    db $f0
    db $3c
    db $18
    db $00
    db $00
    db $00
    db $00
    db $00
    db $01
    db $03
    db $01
    db $03
    db $01
    db $01
    db $01
    db $01
    db $01
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
    db $80
    db $00
    db $80
    db $00
    db $80
    db $00
    db $00
    db $80
    db $00
    db $80
    db $01
    db $00
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
    db $00
    db $80
    db $80
    db $80
    db $80
    db $80
    db $80
    db $c0
    db $80
    db $00
    db $c0
    db $40
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
    db $00
    db $00
    db $00
    db $00
    db $32
    db $4c
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $70
    db $00
    db $70
    db $f8
    db $0b
    db $7f
    db $3b
    db $73
    db $71
    db $33
    db $33
    db $31
    db $13
    db $31
    db $21
    db $10
    db $00
    db $00
    db $00
    db $00
    db $dc
    db $88
    db $80
    db $0c
    db $0e
    db $04
    db $00
    db $06
    db $06
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
    db $1b
    db $10
    db $1b
    db $13
    db $00
    db $00
    db $00
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
    db $c0
    db $80
    db $02
    db $1e
    db $1c
    db $0e
    db $0e
    db $0c
    db $04
    db $0c
    db $08
    db $04
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $e0
    db $40
    db $20
    db $60
    db $20
    db $30
    db $10
    db $30
    db $38
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
    db $03
    db $01
    db $02
    db $07
    db $0e
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
    db $80
    db $c0
    db $e0
    db $f0
    db $70
    db $18
    db $04
    db $0c
    db $00
    db $0c
    db $00
    db $0c
    db $0d
    db $06
    db $07
    db $03
    db $01
    db $00
    db $00
    db $00
    db $00
    db $00
    db $08
    db $18
    db $18
    db $08
    db $00
    db $18
    db $b8
    db $70
    db $c0
    db $e0
    db $80
    db $00
    db $00
    db $00
    db $00
    db $00
    db $04
    db $00
    db $0d
    db $07
    db $0f
    db $06
    db $0c
    db $04
    db $0c
    db $04
    db $0c
    db $04
    db $0c
    db $04
    db $0e
    db $05
    db $00
    db $00
    db $c0
    db $80
    db $40
    db $e0
    db $60
    db $20
    db $70
    db $20
    db $30
    db $20
    db $70
    db $20
    db $c0
    db $e0
    db $0f
    db $07
    db $0e
    db $04
    db $04
    db $04
    db $0c
    db $04
    db $06
    db $04
    db $06
    db $04
    db $04
    db $00
    db $00
    db $00
    db $40
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
    db $03
    db $00
    db $0f
    db $07
    db $0a
    db $0c
    db $08
    db $18
    db $18
    db $10
    db $18
    db $10
    db $1e
    db $19
    db $1f
    db $0f
    db $80
    db $00
    db $c0
    db $80
    db $40
    db $c0
    db $40
    db $c0
    db $40
    db $c0
    db $80
    db $c0
    db $80
    db $c0
    db $80
    db $c0
    db $06
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
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
    db $80
    db $d8
    db $88
    db $cc
    db $88
    db $c0
    db $8c
    db $80
    db $cc
    db $5c
    db $c8
    db $70
    db $78
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
    db $08
    db $0d
    db $08
    db $0f
    db $09
    db $02
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
    db $10
    db $e0
    db $98
    db $f0
    db $00
    db $18
    db $06
    db $0e
    db $0c
    db $06
    db $0c
    db $06
    db $04
    db $06
    db $04
    db $06
    db $06
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
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
    db $07
    db $03
    db $0e
    db $04
    db $04
    db $0c
    db $0e
    db $07
    db $01
    db $03
    db $00
    db $00
    db $00
    db $00
    db $50
    db $e0
    db $90
    db $e0
    db $00
    db $00
    db $00
    db $00
    db $10
    db $e0
    db $18
    db $f0
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $09
    db $07
    db $00
    db $0f
    db $00
    db $00
    db $00
    db $00
    db $08
    db $18
    db $08
    db $18
    db $30
    db $18
    db $20
    db $70
    db $c0
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
    db $01
    db $01
    db $01
    db $03
    db $01
    db $01
    db $01
    db $03
    db $01
    db $0f
    db $0f
    db $05
    db $09
    db $00
    db $00
    db $80
    db $00
    db $80
    db $00
    db $00
    db $00
    db $80
    db $00
    db $e0
    db $f0
    db $60
    db $80
    db $80
    db $00
    db $01
    db $01
    db $01
    db $01
    db $01
    db $01
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
    db $80
    db $00
    db $80
    db $00
    db $80
    db $00
    db $80
    db $00
    db $00
    db $80
    db $e0
    db $f0
    db $90
    db $60
    db $00
    db $00
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
    db $0c
    db $08
    db $18
    db $08
    db $18
    db $08
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $10
    db $20
    db $20
    db $30
    db $10
    db $30
    db $30
    db $10
    db $18
    db $08
    db $0c
    db $08
    db $08
    db $0c
    db $06
    db $0c
    db $03
    db $07
    db $03
    db $00
    db $00
    db $00
    db $00
    db $00
    db $30
    db $10
    db $10
    db $30
    db $20
    db $30
    db $30
    db $60
    db $e0
    db $c0
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
    db $18
    db $08
    db $0c
    db $08
    db $04
    db $0c
    db $0e
    db $04
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $30
    db $10
    db $10
    db $30
    db $20
    db $30
    db $70
    db $20
    db $04
    db $06
    db $02
    db $06
    db $02
    db $03
    db $03
    db $01
    db $01
    db $01
    db $01
    db $00
    db $00
    db $00
    db $00
    db $00
    db $40
    db $60
    db $c0
    db $40
    db $40
    db $c0
    db $c0
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
    db $01
    db $00
    db $19
    db $11
    db $11
    db $19
    db $01
    db $19
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $04
    db $80
    db $84
    db $8c
    db $c0
    db $8c
    db $8c
    db $c8
    db $1b
    db $09
    db $0c
    db $0b
    db $03
    db $0e
    db $06
    db $0e
    db $0e
    db $06
    db $00
    db $06
    db $00
    db $00
    db $00
    db $00
    db $9c
    db $c8
    db $58
    db $c8
    db $e8
    db $58
    db $30
    db $78
    db $38
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
    db $08
    db $00
    db $1c
    db $08
    db $04
    db $0c
    db $04
    db $06
    db $06
    db $03
    db $03
    db $01
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $20
    db $10
    db $20
    db $30
    db $20
    db $60
    db $40
    db $60
    db $80
    db $c0
    db $00
    db $01
    db $03
    db $01
    db $02
    db $03
    db $02
    db $06
    db $04
    db $06
    db $04
    db $00
    db $00
    db $00
    db $00
    db $00
    db $c0
    db $c0
    db $40
    db $e0
    db $30
    db $30
    db $10
    db $18
    db $00
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
    db $00
    db $08
    db $0c
    db $04
    db $0c
    db $04
    db $06
    db $02
    db $03
    db $03
    db $01
    db $01
    db $00
    db $00
    db $00
    db $00
    db $00
    db $10
    db $08
    db $00
    db $18
    db $18
    db $10
    db $38
    db $10
    db $10
    db $b0
    db $e0
    db $b0
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
    db $01
    db $03
    db $01
    db $00
    db $03
    db $e0
    db $60
    db $40
    db $60
    db $c0
    db $40
    db $80
    db $c0
    db $80
    db $80
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
    db $01
    db $00
    db $07
    db $1f
    db $06
    db $18
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
    db $c0
    db $e0
    db $60
    db $c0
    db $80
    db $c0
    db $01
    db $03
    db $07
    db $06
    db $04
    db $0c
    db $19
    db $0c
    db $0f
    db $1f
    db $17
    db $08
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
    db $80
    db $78
    db $c0
    db $f8
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
    db $01

    db $00
    db $00
    db $01
    db $06
    db $03
    db $07
    db $00
    db $00
    db $00
    db $00
    db $20
    db $60
    db $c0
    db $e0
    db $00
    db $80
    db $00
    db $00
    db $00
    db $00
    db $80
    db $c0
    db $60
    db $e0
    db $e0
    db $70
    db $03
    db $01
    db $02
    db $07
    db $06
    db $0c
    db $08
    db $0c
    db $06
    db $07
    db $00
    db $03
    db $00
    db $00
    db $00
    db $00
    db $90
    db $f0
    db $10
    db $18
    db $10
    db $18
    db $30
    db $18
    db $68
    db $f8
    db $38
    db $c8
    db $00
    db $00
    db $00
    db $00
    db $02
    db $01
    db $03
    db $07
    db $00
    db $06
    db $00
    db $00
    db $01
    db $06
    db $03
    db $07
    db $00
    db $00
    db $00
    db $00
    db $40
    db $80
    db $c0
    db $e0
    db $20
    db $60
    db $00
    db $00
    db $00
    db $00
    db $80
    db $c0
    db $60
    db $e0
    db $e0
    db $70
    db $03
    db $01
    db $02
    db $07
    db $06
    db $0c
    db $08
    db $0c
    db $06
    db $07
    db $00
    db $03
    db $00
    db $00
    db $00
    db $00
    db $90
    db $f0
    db $10
    db $18
    db $10
    db $18
    db $30
    db $18
    db $68
    db $f8
    db $38
    db $c8
    db $00
    db $00
    db $00
    db $00
    db $02
    db $03
    db $01
    db $03
    db $00
    db $00
    db $00
    db $00
    db $01
    db $06
    db $03
    db $07
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $c0
    db $80
    db $00
    db $c0
    db $00
    db $00
    db $00
    db $00
    db $80
    db $c0
    db $60
    db $e0
    db $e0
    db $70
    db $03
    db $01
    db $02
    db $07
    db $06
    db $0c
    db $08
    db $0c
    db $06
    db $07
    db $00
    db $03
    db $00
    db $00
    db $00
    db $00
    db $90
    db $f0
    db $10
    db $18
    db $10
    db $18
    db $30
    db $18
    db $68
    db $f8
    db $38
    db $c8
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $04
    db $0c
    db $0c
    db $0c
    db $00
    db $00
    db $01
    db $06
    db $03
    db $07
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $10
    db $30
    db $30
    db $30
    db $00
    db $00
    db $00
    db $00
    db $80
    db $c0
    db $60
    db $e0
    db $e0
    db $70
    db $03
    db $01
    db $02
    db $07
    db $06
    db $0c
    db $08
    db $0c
    db $06
    db $07
    db $00
    db $03
    db $00
    db $00
    db $00
    db $00
    db $90
    db $f0
    db $10
    db $18
    db $10
    db $18
    db $30
    db $18
    db $68
    db $f8
    db $38
    db $c8
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $01
    db $00
    db $00
    db $01
    db $00
    db $00
    db $00
    db $00
    db $05
    db $03
    db $0d
    db $06
    db $18
    db $0c
    db $20
    db $60
    db $c0
    db $e0
    db $00
    db $80
    db $00
    db $00
    db $80
    db $00
    db $c0
    db $e0
    db $20
    db $60
    db $c0
    db $60
    db $1d
    db $1f
    db $19
    db $16
    db $10
    db $18
    db $1c
    db $08
    db $06
    db $0f
    db $04
    db $03
    db $00
    db $00
    db $00
    db $00
    db $80
    db $c0
    db $04
    db $00
    db $0c
    db $08
    db $38
    db $18
    db $60
    db $f0
    db $20
    db $c0
    db $00
    db $00
    db $00
    db $00
    db $02
    db $01
    db $03
    db $07
    db $00
    db $06
    db $00
    db $00
    db $00
    db $00
    db $05
    db $03
    db $0d
    db $06
    db $18
    db $0c
    db $40
    db $80
    db $c0
    db $e0
    db $20
    db $60
    db $00
    db $00
    db $80
    db $00
    db $c0
    db $e0
    db $20
    db $60
    db $c0
    db $60
    db $1d
    db $1f
    db $19
    db $16
    db $10
    db $18
    db $1c
    db $08
    db $06
    db $0f
    db $04
    db $03
    db $00
    db $00
    db $00
    db $00
    db $80
    db $c0
    db $04
    db $00
    db $0c
    db $08
    db $38
    db $18
    db $60
    db $f0
    db $20
    db $c0
    db $00
    db $00
    db $00
    db $00
    db $02
    db $03
    db $01
    db $03
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $05
    db $03
    db $0d
    db $06
    db $18
    db $0c
    db $00
    db $00
    db $c0
    db $80
    db $00
    db $c0
    db $00
    db $00
    db $80
    db $00
    db $c0
    db $e0
    db $20
    db $60
    db $c0
    db $60
    db $1d
    db $1f
    db $19
    db $16
    db $10
    db $18
    db $1c
    db $08
    db $06
    db $0f
    db $04
    db $03
    db $00
    db $00
    db $00
    db $00
    db $80
    db $c0
    db $04
    db $00
    db $0c
    db $08
    db $38
    db $18
    db $60
    db $f0
    db $20
    db $c0
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $02
    db $06
    db $06
    db $06
    db $00
    db $00
    db $00
    db $00
    db $05
    db $03
    db $0d
    db $06
    db $18
    db $0c
    db $00
    db $00
    db $10
    db $30
    db $30
    db $30
    db $00
    db $00
    db $80
    db $00
    db $c0
    db $e0
    db $20
    db $60
    db $c0
    db $60
    db $1d
    db $1f
    db $19
    db $16
    db $10
    db $18
    db $1c
    db $08
    db $06
    db $0f
    db $04
    db $03
    db $00
    db $00
    db $00
    db $00
    db $80
    db $c0
    db $04
    db $00
    db $0c
    db $08
    db $38
    db $18
    db $60
    db $f0
    db $20
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
    db $00
    db $00
    db $01
    db $00
    db $00
    db $00
    db $00
    db $00
    db $01
    db $01
    db $01
    db $00
    db $60
    db $20
    db $e0
    db $c0
    db $c0
    db $00
    db $80
    db $00
    db $00
    db $00
    db $00
    db $80
    db $00
    db $80
    db $00
    db $01
    db $01
    db $00
    db $01
    db $00
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
    db $80
    db $00
    db $80
    db $00
    db $80
    db $80
    db $80
    db $80
    db $80
    db $c0
    db $80
    db $40
    db $80
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $04
    db $0c
    db $0c
    db $0c
    db $00
    db $00
    db $00
    db $00
    db $00
    db $01
    db $01
    db $01
    db $00
    db $00
    db $00
    db $00
    db $20
    db $60
    db $60
    db $60
    db $00
    db $00
    db $00
    db $00
    db $80
    db $00
    db $80
    db $00
    db $01
    db $01
    db $00
    db $01
    db $00
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
    db $80
    db $00
    db $80
    db $00
    db $80
    db $80
    db $80
    db $80
    db $80
    db $c0
    db $80
    db $40
    db $80
    db $00
    db $00
    db $00
    db $00
    db $00
    db $01
    db $03
    db $01
    db $00
    db $03
    db $00
    db $00
    db $03
    db $01
    db $02
    db $07
    db $0e
    db $04
    db $00
    db $c0
    db $40
    db $c0
    db $80
    db $80
    db $00
    db $00
    db $00
    db $00
    db $80
    db $c0
    db $e0
    db $f0
    db $70
    db $18
    db $04
    db $0c
    db $00
    db $0c
    db $00
    db $0c
    db $0d
    db $06
    db $07
    db $03
    db $01
    db $00
    db $00
    db $00
    db $00
    db $00
    db $08
    db $18
    db $18
    db $08
    db $00
    db $18
    db $b8
    db $70
    db $c0
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
    db $02
    db $06
    db $06
    db $06
    db $00
    db $00
    db $03
    db $01
    db $02
    db $07
    db $0e
    db $04
    db $00
    db $00
    db $00
    db $00
    db $10
    db $30
    db $30
    db $30
    db $00
    db $00
    db $80
    db $c0
    db $e0
    db $f0
    db $70
    db $18
    db $04
    db $0c
    db $00
    db $0c
    db $00
    db $0c
    db $0d
    db $06
    db $07
    db $03
    db $01
    db $00
    db $00
    db $00
    db $00
    db $00
    db $08
    db $18
    db $18
    db $08
    db $00
    db $18
    db $b8
    db $70
    db $c0
    db $e0
    db $80
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $01
    db $00
    db $01
    db $01
    db $02
    db $01
    db $00
    db $08
    db $0c
    db $08
    db $18
    db $08
    db $18
    db $08
    db $00
    db $c0
    db $80
    db $c0
    db $00
    db $80
    db $00
    db $00
    db $10
    db $20
    db $20
    db $30
    db $10
    db $30
    db $30
    db $10
    db $18
    db $08
    db $0c
    db $08
    db $08
    db $0c
    db $06
    db $0c
    db $03
    db $07
    db $03
    db $00
    db $00
    db $00
    db $00
    db $00
    db $30
    db $10
    db $10
    db $30
    db $20
    db $30
    db $30
    db $60
    db $e0
    db $c0
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
    db $04
    db $0c
    db $04
    db $0c
    db $08
    db $00
    db $0c
    db $08
    db $1c
    db $08
    db $18
    db $08
    db $00
    db $00
    db $00
    db $00
    db $40
    db $60
    db $40
    db $60
    db $30
    db $00
    db $20
    db $30
    db $10
    db $30
    db $30
    db $10
    db $18
    db $08
    db $1c
    db $08
    db $08
    db $0c
    db $06
    db $0c
    db $03
    db $07
    db $03
    db $00
    db $00
    db $00
    db $00
    db $00
    db $30
    db $10
    db $10
    db $30
    db $20
    db $30
    db $30
    db $60
    db $e0
    db $c0
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
    db $07
    db $07
    db $0f
    db $04
    db $08
    db $00
    db $00
    db $1b
    db $10
    db $1b
    db $13
    db $00
    db $00
    db $00
    db $00
    db $10
    db $20
    db $30
    db $e0
    db $c0
    db $c0
    db $00
    db $00
    db $80
    db $00
    db $c0
    db $80
    db $02
    db $1e
    db $1c
    db $0e
    db $0e
    db $0c
    db $04
    db $0c
    db $08
    db $04
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $e0
    db $40
    db $20
    db $60
    db $20
    db $30
    db $10
    db $30
    db $38
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
    db $02
    db $01
    db $03
    db $07
    db $0e
    db $04
    db $08
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
    db $c0
    db $80
    db $e0
    db $00
    db $00
    db $00
    db $00
    db $1c
    db $08
    db $18
    db $08
    db $0b
    db $0c
    db $0f
    db $07
    db $00
    db $00
    db $04
    db $06
    db $03
    db $07
    db $00
    db $07
    db $00
    db $00
    db $00
    db $00
    db $d0
    db $30
    db $e0
    db $f0
    db $40
    db $c0
    db $40
    db $60
    db $c0
    db $e0
    db $00
    db $80
    db $00
    db $00
    db $00
    db $00
    db $02
    db $01
    db $03
    db $07
    db $05
    db $0e
    db $18
    db $0c
    db $18
    db $0c
    db $08
    db $18
    db $00
    db $00
    db $00
    db $00
    db $40
    db $80
    db $c0
    db $e0
    db $a0
    db $70
    db $10
    db $30
    db $10
    db $30
    db $e0
    db $30
    db $08
    db $19
    db $08
    db $19
    db $08
    db $18
    db $08
    db $1b
    db $0b
    db $1b
    db $0a
    db $1b
    db $09
    db $19
    db $00
    db $18
    db $c0
    db $e0
    db $30
    db $e0
    db $10
    db $30
    db $10
    db $30
    db $10
    db $30
    db $20
    db $f0
    db $c0
    db $e0
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $01
    db $00
    db $01
    db $00
    db $01
    db $00
    db $01
    db $00
    db $01
    db $01
    db $01
    db $00
    db $00
    db $00
    db $00
    db $80
    db $c0
    db $c0
    db $80
    db $c0
    db $80
    db $80
    db $80
    db $80
    db $80
    db $00
    db $80
    db $01
    db $01
    db $00
    db $01
    db $01
    db $00
    db $03
    db $00
    db $00
    db $03
    db $03
    db $03
    db $00
    db $00
    db $00
    db $00
    db $00
    db $80
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
    db $0b
    db $07
    db $0b
    db $1c
    db $38
    db $10
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
    db $80
    db $c0
    db $40
    db $e0
    db $70
    db $20
    db $70
    db $20
    db $b0
    db $60
    db $e0
    db $c0
    db $03
    db $01
    db $00
    db $03
    db $03
    db $00
    db $00
    db $00
    db $00
    db $03
    db $03
    db $03
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
    db $02
    db $01
    db $02
    db $07
    db $06
    db $0c
    db $1c
    db $08
    db $0c
    db $18
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $40
    db $80
    db $a0
    db $c0
    db $b0
    db $60
    db $00
    db $30
    db $38
    db $10
    db $08
    db $18
    db $08
    db $18
    db $1c
    db $08
    db $07
    db $0c
    db $0b
    db $07
    db $03
    db $00
    db $00
    db $00
    db $00
    db $00
    db $18
    db $10
    db $38
    db $10
    db $60
    db $30
    db $40
    db $e0
    db $40
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
    db $02
    db $01
    db $01
    db $03
    db $07
    db $03
    db $03
    db $07
    db $05
    db $07
    db $06
    db $01
    db $00
    db $00
    db $00
    db $00
    db $80
    db $00
    db $80
    db $00
    db $80
    db $00
    db $80
    db $00
    db $80
    db $00
    db $00
    db $80
    db $00
    db $01
    db $00
    db $01
    db $01
    db $00
    db $01
    db $00
    db $02
    db $01
    db $00
    db $03
    db $02
    db $00
    db $00
    db $00
    db $00
    db $80
    db $00
    db $80
    db $80
    db $80
    db $c0
    db $80
    db $d0
    db $e0
    db $30
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
    db $10
    db $0f
    db $09
    db $1f
    db $09
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $40
    db $80
    db $80
    db $c0
    db $00
    db $c0
    db $00
    db $c0
    db $00
    db $00
    db $01
    db $00
    db $03
    db $01
    db $00
    db $03
    db $03
    db $07
    db $0c
    db $07
    db $04
    db $00
    db $00
    db $00
    db $80
    db $c0
    db $c0
    db $80
    db $00
    db $80
    db $e0
    db $00
    db $f0
    db $f8
    db $ec
    db $18
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $07
    db $00
    db $07
    db $0f
    db $09
    db $04
    db $00
    db $00
    db $00
    db $00
    db $01
    db $00
    db $03
    db $01
    db $00
    db $00
    db $80
    db $00
    db $80
    db $c0
    db $e0
    db $40
    db $00
    db $60
    db $c0
    db $60
    db $60
    db $c0
    db $c0
    db $e0
    db $01
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $07
    db $00
    db $0f
    db $07
    db $07
    db $00
    db $00
    db $00
    db $e0
    db $30
    db $10
    db $30
    db $00
    db $30
    db $70
    db $20
    db $40
    db $e0
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
    db $02
    db $01
    db $00
    db $03
    db $07
    db $02
    db $00
    db $06
    db $06
    db $04
    db $0e
    db $04
    db $00
    db $00
    db $00
    db $00
    db $80
    db $00
    db $a0
    db $40
    db $e0
    db $40
    db $40
    db $c0
    db $00
    db $c0
    db $00
    db $c0
    db $04
    db $0f
    db $06
    db $0f
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
    db $f8
    db $f0
    db $78
    db $c0
    db $e0
    db $40
    db $e0
    db $40
    db $e0
    db $40
    db $20
    db $40
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $0b
    db $04
    db $07
    db $0f
    db $0f
    db $04
    db $0e
    db $04
    db $0e
    db $04
    db $04
    db $07
    db $00
    db $00
    db $00
    db $00
    db $e0
    db $00
    db $f0
    db $e0
    db $f0
    db $00
    db $00
    db $00
    db $00
    db $00
    db $40
    db $80
    db $07
    db $07
    db $02
    db $04
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $06
    db $03
    db $07
    db $00
    db $00
    db $00
    db $40
    db $e0
    db $60
    db $30
    db $10
    db $30
    db $38
    db $10
    db $60
    db $30
    db $c0
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
    db $03
    db $07
    db $02
    db $00
    db $06
    db $0e
    db $04
    db $06
    db $0d
    db $00
    db $00
    db $80
    db $00
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
    db $20
    db $c0

    db $07, $0f, $0e, $0c, $08, $0c, $08, $0c, $0f, $04, $03, $07, $03, $00, $00, $00
    db $e0, $f0, $10, $30, $00, $30, $30, $60, $60, $c0, $40, $80, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $10, $0f, $0c, $1f, $1c, $08, $0c, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $10, $e0, $10, $f0, $00, $30, $60, $30, $70, $20
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $01, $00, $00, $00
    db $00, $60, $e0, $40, $c0, $40, $00, $c0, $80, $c0, $c0, $80, $00, $80, $80, $00
    db $00, $00, $00, $00, $00, $00, $05, $03, $0d, $06, $18, $0c, $08, $18, $08, $1f
    db $00, $00, $00, $00, $00, $00, $c0, $80, $40, $e0, $20, $60, $a0, $60, $e0, $c0
    db $13, $0f, $03, $06, $0e, $04, $08, $04, $0c, $04, $0d, $06, $05, $03, $00, $00
    db $e0, $c0, $b0, $60, $18, $30, $38, $10, $38, $10, $a0, $70, $a0, $c0, $00, $00
    db $00, $00, $00, $00, $00, $00, $04, $03, $0e, $07, $02, $0c, $0c, $08, $0c, $08
    db $00, $00, $00, $00, $00, $00, $20, $c0, $a0, $40, $10, $20, $70, $20, $30, $60
    db $00, $0c, $04, $0f, $00, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $e0, $70, $c0, $f0, $40, $b0, $10, $30, $38, $10, $38, $10, $08, $10, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $05, $03, $0d, $06, $06, $0c
    db $00, $00, $00, $00, $00, $00, $00, $00, $c0, $e0, $20, $f0, $30, $18, $1c, $08
    db $00, $0c, $04, $0c, $0d, $06, $07, $03, $03, $00, $00, $00, $00, $00, $00, $00
    db $1c, $08, $0c, $18, $d8, $30, $f0, $e0, $c0

    ; padding
    ds $6d1, $00

    db $01, $01, $01, $03, $03, $07, $00, $00, $00, $00, $00, $00, $70, $70, $f0, $f0
    db $f0, $f0, $f0, $b0, $70, $30, $0f, $06, $0f, $0f, $1f, $1f, $3c, $38, $38, $70
    db $00, $00, $00, $00, $00, $00, $70, $30, $f0, $f0, $f0, $f0, $70, $30, $70, $30
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $07, $03, $03, $07
    db $0e, $07, $07, $0e, $1f, $0f, $00, $00, $00, $00, $00, $00, $f8, $f0, $fc, $f8
    db $2c, $1c, $1c, $1c, $f8, $f8, $0f, $1f, $38, $1c, $1c, $38, $7f, $3f, $3f, $7f
    db $00, $00, $00, $00, $00, $00, $f8, $f0, $18, $38, $78, $38, $f8, $f0, $d0, $e0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $03, $07, $0f
    db $1e, $0f, $0e, $1c, $38, $1c, $00, $00, $00, $00, $00, $00, $d0, $e0, $f8, $f0
    db $b0, $78, $70, $38, $00, $00, $1c, $38, $1c, $38, $1a, $3d, $3f, $1f, $17, $0f
    db $00, $00, $00, $00, $00, $00, $00, $00, $e0, $70, $f0, $e0, $c0, $e0, $40, $80
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $07, $03, $03, $07
    db $0e, $07, $07, $0e, $1c, $0e, $00, $00, $00, $00, $00, $00, $f0, $e0, $f8, $f0
    db $18, $38, $38, $18, $10, $38, $0e, $1c, $38, $1c, $1e, $39, $7f, $3f, $3f, $7f
    db $00, $00, $00, $00, $00, $00, $78, $30, $e0, $70, $f0, $e0, $a0, $c0, $80, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $07, $03, $03, $07
    db $0e, $07, $07, $0e, $1f, $0f, $00, $00, $00, $00, $00, $00, $fc, $fe, $fe, $fc
    db $00, $00, $00, $00, $e0, $f0, $0f, $1f, $38, $1c, $1c, $38, $7f, $3f, $3f, $7f
    db $00, $00, $00, $00, $00, $00, $f0, $e0, $00, $00, $00, $00, $c0, $e0, $e0, $c0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $07, $03, $03, $07
    db $0e, $07, $07, $0e, $1f, $0f, $00, $00, $00, $00, $00, $00, $fc, $fe, $fe, $fc
    db $00, $00, $00, $00, $e0, $f0, $0f, $1f, $38, $1c, $1c, $38, $70, $38, $38, $70
    db $00, $00, $00, $00, $00, $00, $f0, $e0

    ; padding
    ds $14, $00

    db $05, $03, $07, $0f, $1f, $0e, $0e, $1c, $39, $1c, $00, $00, $00, $00, $00, $00
    db $d0, $e0, $f8, $f0, $70, $38, $00, $00, $f8, $f0, $1c, $39, $1c, $38, $1b, $3d
    db $3f, $1f, $17, $0f, $00, $00, $00, $00, $00, $00, $f8, $f0, $e0, $70, $f0, $e0
    db $c0, $e0, $40, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $07, $03, $03, $07, $0e, $07, $07, $0e, $1f, $0f, $00, $00, $00, $00, $00, $00
    db $1c, $8e, $8e, $1c, $38, $1c, $1c, $38, $f0, $f8, $0f, $1f, $38, $1c, $1c, $38
    db $71, $38, $38, $71, $00, $00, $00, $00, $00, $00, $f8, $f0, $e0, $70, $70, $e0
    db $c0, $e0, $e0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $03, $01, $01, $03, $03, $01, $01, $03, $07, $03, $00, $00, $00, $00, $00, $00
    db $e0, $f0, $f0, $e0, $80, $c0, $c0, $80, $00, $80, $03, $07, $0e, $07, $07, $0e
    db $3e, $1f, $1f, $3e, $00, $00, $00, $00, $00, $00, $80

    ; padding
    ds $1d, $00

    db $30, $38, $00, $00, $00, $00, $00, $00, $fc, $7e, $7e, $fc, $70, $38, $38, $70
    db $e0, $70, $78, $30, $39, $70, $35, $7b, $7f, $3f, $2e, $1f, $00, $00, $00, $00
    db $00, $00, $70, $e0, $c0, $e0, $e0, $c0, $80, $c0, $80, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $07, $03, $03, $07, $0e, $07, $07, $0e
    db $1f, $0f, $00, $00, $00, $00, $00, $00, $0c, $8e, $be, $1c, $30, $78, $f0, $e0
    db $c0, $c0, $0f, $1f, $3b, $1d, $1c, $39, $71, $38, $38, $70, $00, $00, $00, $00
    db $00, $00, $c0, $80, $80, $c0, $e0, $c0, $c0, $e0, $40, $e0, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $07, $03, $03, $07, $0e, $07, $07, $0e
    db $1c, $0e, $00, $00, $00, $00, $00, $00, $00, $80, $80, $00, $00, $00, $00, $00
    db $00, $00, $0e, $1c, $38, $1c, $1c, $38, $7f, $3f, $3f, $7f, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $c0, $e0, $e0, $c0, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $0f, $06, $06, $0f, $1f, $0f, $0f, $1f
    db $3b, $1f, $00, $00, $00, $00, $00, $00, $1c, $0e, $3e, $1c, $78, $7c, $fc, $f8
    db $f0, $f8, $1b, $3f, $75, $3b, $38, $70, $e1, $70, $70, $e1, $00, $00, $00, $00
    db $00, $00, $b8, $f0, $e0, $70, $70, $e0, $c0, $e0, $e0, $c0, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $0e, $07, $06, $0f, $1f, $0f, $0f, $1f
    db $3b, $1f, $00, $00, $00, $00, $00, $00, $1c, $0e, $0e, $1c, $38, $1c, $9c, $38
    db $70, $b8, $1d, $3b, $71, $3b, $3b, $71, $e1, $71, $70, $e1, $00, $00, $00, $00
    db $00, $00, $b8, $f0, $e0, $f0, $f0, $e0, $c0, $e0, $e0, $c0, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $05, $03, $07, $0f, $1e, $0f, $0e, $1c
    db $38, $1c, $00, $00, $00, $00, $00, $00, $d0, $e0, $f8, $f0, $b0, $78, $70, $38
    db $70, $38, $1c, $38, $1c, $38, $1a, $3d, $3f, $1f, $17, $0f, $00, $00, $00, $00
    db $00, $00, $38, $70, $e0, $70, $f0, $e0, $c0, $e0, $40, $80, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $07, $03, $03, $07, $0e, $07, $07, $0e
    db $1c, $0e, $00, $00, $00, $00, $00, $00, $f8, $f0, $fc, $f8, $2c, $1c, $0c, $1c
    db $58, $3c, $0f, $1f, $3f, $1f, $1c, $38, $70, $38, $38, $70, $00, $00, $00, $00
    db $00, $00, $f0, $f8, $f0, $e0

    ; padding
    ds $12, $00

    db $05, $03, $07, $0f, $1e, $0f, $0e, $1c, $38, $1c, $00, $00, $00, $00, $00, $00
    db $d0, $e0, $f8, $f0, $b0, $78, $70, $38, $70, $38, $1d, $39, $1d, $39, $1a, $3d
    db $3f, $1f, $17, $0f, $00, $00, $00, $00, $00, $00, $b8, $f0, $e0, $f0, $c0, $e0
    db $f0, $e0, $70, $e0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $07, $03, $03, $07, $0e, $07, $07, $0e, $1f, $0f, $00, $00, $00, $00, $00, $00
    db $f8, $f0, $fc, $f8, $2c, $1c, $1c, $1c, $fc, $f8, $0f, $1f, $38, $1c, $1c, $38
    db $70, $38, $38, $70, $00, $00, $00, $00, $00, $00, $f8, $f0, $40, $e0, $60, $e0
    db $e0, $60, $e0, $60, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $05, $03, $07, $0f, $1e, $0f, $1e, $0e, $0f, $07, $00, $00, $00, $00, $00, $00
    db $d0, $e0, $f8, $f0, $b0, $78, $70, $38, $40, $80, $01, $03, $1d, $38, $1a, $3d
    db $3f, $1f, $17, $0f, $00, $00, $00, $00, $00, $00, $e0, $c0, $f0, $e0, $f0, $e0
    db $c0, $e0, $40, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $07, $03, $03, $07, $01, $00, $00, $01, $03, $01, $00, $00, $00, $00, $00, $00
    db $fc, $fe, $fe, $fc, $c0, $e0, $e0, $c0, $80, $c0, $01, $03, $07, $03, $03, $07
    db $0e, $07, $07, $0e, $00, $00, $00, $00, $00, $00, $c0, $80, $00, $80, $80

    ; padding
    ds $11, $00

    db $0e, $07, $07, $0e, $1c, $0e, $0e, $1c, $1c, $1c, $00, $00, $00, $00, $00, $00
    db $1c, $0e, $0e, $1c, $38, $1c, $1c, $38, $70, $38, $38, $1c, $1c, $38, $1a, $3d
    db $3f, $1f, $17, $0f, $00, $00, $00, $00, $00, $00, $38, $70, $e0, $70, $f0, $e0
    db $c0, $e0, $40, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $0e, $06, $0e, $06, $0e, $06, $0e, $06, $0e, $06, $00, $00, $00, $00, $00, $00
    db $0e, $0e, $0c, $1e, $38, $1c, $78, $38, $78, $70, $0e, $06, $0f, $07, $0f, $07
    db $0f, $07, $0f, $07, $00, $00, $00, $00, $00, $00, $f0, $e0, $c0, $e0, $80, $c0
    db $80, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $07, $03, $03, $07, $06, $07, $0f, $06, $07, $0f, $00, $00, $00, $00, $00, $00
    db $0e, $87, $87, $0e, $9c, $6e, $ec, $dc, $dc, $f8, $0f, $0f, $1f, $0f, $0f, $1e
    db $1e, $1c, $38, $1c, $00, $00, $00, $00, $00, $00, $f0, $f8, $f0, $f0, $f0, $e0
    db $e0, $e0, $e0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $07, $06, $06, $07, $03, $07, $07, $03, $03, $03, $00, $00, $00, $00, $00, $00
    db $1e, $0e, $1c, $3c, $70, $78, $f0, $e0, $c0, $c0, $07, $07, $1f, $0f, $1d, $3d
    db $70, $79, $f1, $e0, $00, $00, $00, $00, $00, $00, $80, $80, $c0, $80, $80, $c0
    db $c0, $c0, $c0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $07, $06, $06, $07, $03, $07, $07, $03, $03, $03, $00, $00, $00, $00, $00, $00
    db $1e, $0e, $1c, $3c, $70, $78, $f0, $e0, $c0, $c0, $03, $07, $0e, $07, $07, $0e
    db $1c, $0e, $0e, $1c, $00, $00, $00, $00, $00, $00, $80

    ; padding
    ds $15, $00

    db $07, $03, $03, $07, $00, $00, $00, $00, $01, $01, $00, $00, $00, $00, $00, $00
    db $fc, $fe, $fe, $fc, $78, $38, $60, $f0, $e0, $c0, $07, $03, $06, $0f, $1c, $1e
    db $7f, $3f, $3f, $7f, $00, $00, $00, $00, $00, $00, $80, $80, $00, $00, $00, $00
    db $c0, $e0, $e0, $c0

    ; padding
    ds $10, $00

    db $01, $01, $01, $03, $03, $07, $04, $0c, $18, $10, $00, $00, $70, $70, $f0, $f0
    db $f0, $f0, $f0, $b0, $70, $30, $0f, $06, $0f, $0f, $1f, $1f, $3c, $38, $38, $70
    db $00, $00, $00, $00, $00, $00, $70, $30, $f0, $f0, $f0, $f0, $70, $30, $70, $30

    ; padding
    ds $10, $00

    db $01, $01, $01, $03, $03, $07, $20, $70, $50, $88, $00, $00, $70, $70, $f0, $f0
    db $f0, $f0, $f0, $b0, $70, $30, $0f, $06, $0f, $0f, $1f, $1f, $3c, $38, $38, $70
    db $00, $00, $00, $00, $00, $00, $70, $30, $f0, $f0, $f0, $f0, $70, $30, $70, $30

    ; padding
    ds $10, $00

    db $01, $01, $01, $03, $03, $07, $40, $c0, $40, $20, $00, $00, $70, $70, $f0, $f0
    db $f0, $f0, $f0, $b0, $70, $30, $0f, $06, $0f, $0f, $1f, $1f, $3c, $38, $38, $70
    db $00, $00, $00, $00, $00, $00, $70, $30, $f0, $f0, $f0, $f0, $70, $30, $70, $30

    ; padding
    ds $10, $00

    db $01, $01, $01, $03, $03, $07, $00, $cc, $88, $cc, $00, $00, $70, $70, $f0, $f0
    db $f0, $f0, $f0, $b0, $70, $30, $0f, $06, $0f, $0f, $1f, $1f, $3c, $38, $38, $70
    db $00, $00, $00, $00, $00, $00, $70, $30, $f0, $f0, $f0, $f0, $70, $30, $70, $30
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $07, $03, $03, $07
    db $0e, $07, $07, $0e, $1f, $0f, $04, $0c, $18, $10, $00, $00, $fc, $fe, $fe, $fc
    db $00, $00, $00, $00, $e0, $f0, $0f, $1f, $38, $1c, $1c, $38, $7f, $3f, $3f, $7f
    db $00, $00, $00, $00, $00, $00, $f0, $e0, $00, $00, $00, $00, $c0, $e0, $e0, $c0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $07, $03, $03, $07
    db $0e, $07, $07, $0e, $1f, $0f, $20, $70, $50, $88, $00, $00, $fc, $fe, $fe, $fc
    db $00, $00, $00, $00, $e0, $f0, $0f, $1f, $38, $1c, $1c, $38, $7f, $3f, $3f, $7f
    db $00, $00, $00, $00, $00, $00, $f0, $e0, $00, $00, $00, $00, $c0, $e0, $e0, $c0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $07, $03, $03, $07
    db $0e, $07, $07, $0e, $1f, $0f, $40, $c0, $40, $20, $00, $00, $fc, $fe, $fe, $fc
    db $00, $00, $00, $00, $e0, $f0, $0f, $1f, $38, $1c, $1c, $38, $7f, $3f, $3f, $7f
    db $00, $00, $00, $00, $00, $00, $f0, $e0, $00, $00, $00, $00, $c0, $e0, $e0, $c0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $07, $03, $03, $07
    db $0e, $07, $07, $0e, $1f, $0f, $00, $cc, $88, $cc, $00, $00, $fc, $fe, $fe, $fc
    db $00, $00, $00, $00, $e0, $f0, $0f, $1f, $38, $1c, $1c, $38, $7f, $3f, $3f, $7f
    db $00, $00, $00, $00, $00, $00, $f0, $e0, $00, $00, $00, $00, $c0, $e0, $e0, $c0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $01, $01, $03
    db $03, $01, $01, $03, $07, $03, $10, $30, $60, $40, $00, $00, $e0, $f0, $f0, $e0
    db $80, $c0, $c0, $80, $00, $80, $03, $07, $0e, $07, $07, $0e, $3e, $1f, $1f, $3e
    db $00, $00, $00, $00, $00, $00, $80

    ; padding
    ds $10, $00

    db $01, $01, $01, $00, $00, $03, $01, $01, $03, $03, $01, $01, $03, $07, $03, $00
    db $98, $10, $98, $00, $00, $e0, $f0, $f0, $e0, $80, $c0, $c0, $80, $00, $80, $03
    db $07, $0e, $07, $07, $0e, $3e, $1f, $1f, $3e, $00, $00, $00, $00, $00, $00, $80

    ; padding
    ds $15, $00

    db $05, $03, $07, $0f, $1e, $0f, $0e, $1c, $38, $1c, $10, $30, $60, $40, $00, $00
    db $d0, $e0, $f8, $f0, $b0, $78, $70, $38, $70, $38, $1c, $38, $1c, $38, $1a, $3d
    db $3f, $1f, $17, $0f, $00, $00, $00, $00, $00, $00, $38, $70, $e0, $70, $f0, $e0
    db $c0, $e0, $40, $80, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $00, $00
    db $05, $03, $07, $0f, $1e, $0f, $0e, $1c, $38, $1c, $00, $98, $10, $98, $00, $00
    db $d0, $e0, $f8, $f0, $b0, $78, $70, $38, $70, $38, $1c, $38, $1c, $38, $1a, $3d
    db $3f, $1f, $17, $0f, $00, $00, $00, $00, $00, $00, $38, $70, $e0, $70, $f0, $e0
    db $c0, $e0, $40, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $0e, $07, $07, $0e, $1c, $0e, $0e, $1c, $1c, $1c, $10, $30, $60, $40, $00, $00
    db $1c, $0e, $0e, $1c, $38, $1c, $1c, $38, $70, $38, $38, $1c, $1c, $38, $1a, $3d
    db $3f, $1f, $17, $0f, $00, $00, $00, $00, $00, $00, $38, $70, $e0, $70, $f0, $e0
    db $c0, $e0, $40, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $0e, $07, $07, $0e, $1c, $0e, $0e, $1c, $1c, $1c, $00, $cc, $88, $cc, $00, $00
    db $1c, $0e, $0e, $1c, $38, $1c, $1c, $38, $70, $38, $38, $1c, $1c, $38, $1a, $3d
    db $3f, $1f, $17, $0f, $00, $00, $00, $00, $00, $00, $38, $70, $e0, $70, $f0, $e0
    db $c0, $e0, $40, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00
    db $0e, $07, $06, $0f, $1f, $0f, $0f, $1f, $3b, $1f, $e8, $64, $90, $98, $00, $00
    db $1c, $0e, $0e, $1c, $38, $1c, $9c, $38, $70, $b8, $1d, $3b, $71, $3b, $3b, $71
    db $e1, $71, $70, $e1, $00, $00, $00, $00, $00, $00, $b8, $f0, $e0, $f0, $f0, $e0
    db $c0, $e0, $e0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $0c, $18, $18, $1c
    db $08, $0c, $08, $18, $10

    ; padding
    ds $59, $00

    db $0c, $18, $18, $1c, $08, $0c, $08, $18, $10

    ; padding
    ds $37, $00

    db $20, $60, $60, $60

    ; padding
    ds $26, $00

    db $1f, $0f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $e0, $f0, $0f, $1f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $f0, $e0

    ; padding
    ds $1a, $00

    db $02, $01, $0b, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $d8, $f8, $f8, $f8, $0d, $1e, $38, $1c, $1b, $3c, $3f, $1f, $17, $0f, $00, $00
    db $00, $00, $00, $00, $f8, $30, $60, $70, $70, $e0, $f0, $f0, $70, $b0, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $07, $03, $03, $07, $0e, $07
    db $07, $0f, $1f, $0f, $00, $00, $00, $00, $00, $00, $00, $80, $80, $00, $00, $00
    db $a0, $c0, $f0, $e0, $0e, $1c, $38, $1c, $1d, $38, $7f, $3f, $3f, $7f, $00, $00
    db $00, $00, $00, $00, $b0, $70, $30, $70, $70, $e0, $e0, $c0, $40, $80

    ; padding
    ds $12, $00

    db $02, $01, $0b, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $d0, $e0, $f8, $f0, $0c, $1f, $38, $1c, $1a, $3c, $3f, $1f, $17, $0f, $00, $00
    db $00, $00, $00, $00, $98, $38, $00, $00, $b8, $70, $f0, $e0, $a0, $c0

    ; padding
    ds $12, $00

    db $03, $07, $1f, $0f, $00, $00, $00, $00, $00, $00, $38, $1c, $1c, $38, $70, $38
    db $f8, $f0, $e0, $f0, $18, $3c, $71, $38, $34, $79, $7f, $3f, $2f, $1f, $00, $00
    db $00, $00, $00, $00, $70, $e0, $c0, $e0, $e0, $c0, $80, $c0, $c0, $80

    ; padding
    ds $12, $00

    db $02, $01, $0b, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $d0, $e0, $38, $f0, $0d, $1e, $3f, $1f, $1a, $3c, $3c, $1f, $17, $0f, $00, $00
    db $00, $00, $00, $00, $58, $38, $f8, $f8, $00, $00, $70, $e0, $a0, $c0, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $03, $01
    db $01, $03, $1f, $0f, $00, $00, $00, $00, $00, $00, $b0, $78, $f8, $f0, $e0, $c0
    db $c0, $80, $e0, $f0, $0f, $1f, $0e, $07, $07, $0e, $1c, $0e, $0e, $1c, $00, $00
    db $00, $00, $00, $00, $f0, $e0

    ; padding
    ds $1a, $00

    db $02, $01, $0b, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $f8, $fc, $fc, $f8, $0d, $1e, $38, $1c, $1a, $3c, $3f, $1f, $17, $0f, $00, $01
    db $7f, $3f, $7e, $3f, $30, $78, $38, $70, $e0, $70, $f0, $e0, $c0, $e0, $e0, $c0
    db $80, $c0, $80, $00, $00, $00, $00, $00, $00, $00, $07, $03, $03, $07, $0e, $07
    db $07, $0f, $1f, $0f, $00, $00, $00, $00, $00, $00, $00, $80, $80, $00, $00, $00
    db $80, $c0, $c0, $e0, $0f, $1c, $38, $1c, $1c, $38, $71, $38, $38, $71, $00, $00
    db $00, $00, $00, $00, $70, $e0, $e0, $70, $70, $e0, $c0, $e0, $e0, $c0

    ; padding
    ds $13, $00

    db $01, $03, $01, $00, $00, $00, $00, $00, $00, $e0, $70, $70, $e0, $00, $00, $e0
    db $c0, $80, $c0, $01, $03, $07, $03, $03, $07, $0e, $07, $07, $0e, $00, $00, $00
    db $00, $00, $00, $c0, $80, $00, $80, $80

    ; padding
    ds $21, $00

    db $1c, $0e, $0e, $1c, $00, $00, $70, $38, $38, $70, $00, $00, $00, $00, $01, $00
    db $78, $31, $3b, $71, $33, $7f, $7f, $3f, $2d, $1e, $e0, $70, $70, $e0, $c0, $e0
    db $e0, $c0, $80, $c0, $c0, $80, $00, $80, $00, $00, $00, $00, $00, $00, $00, $00
    db $07, $03, $03, $07, $0e, $07, $07, $0e, $1e, $0f, $00, $00, $00, $00, $00, $00
    db $00, $80, $80, $00, $00, $00, $b8, $78, $e0, $f0, $0f, $1f, $3b, $1f, $1d, $3b
    db $73, $39, $38, $71, $00, $00, $00, $00, $00, $00, $80, $c0, $00, $80, $c0, $80
    db $80, $c0, $80, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $01, $00, $00, $01, $03, $01, $01, $03, $07, $03, $00, $00, $00, $00, $00, $00
    db $c0, $e0, $e0, $c0, $80, $c0, $c0, $80, $00, $80, $03, $07, $0e, $07, $07, $0e
    db $1c, $0e, $0e, $1c, $00, $00, $00, $00, $00, $00, $80

    ; padding
    ds $1b, $00

    db $0d, $1e, $3f, $1f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $f0, $60, $f8, $f0, $13, $3f, $7f, $33, $2b, $76, $fd, $66, $5f, $ec, $00, $00
    db $00, $00, $00, $00, $b8, $f0, $a0, $70, $f0, $60, $40, $e0, $e0, $c0

    ; padding
    ds $12, $00

    db $06, $0f, $1f, $0f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $40, $80, $c0, $e0, $0d, $1e, $38, $1c, $1c, $38, $71, $38, $38, $71, $00, $00
    db $00, $00, $00, $00, $f0, $60, $f0, $60, $70, $e0, $c0, $e0, $e0, $c0

    ; padding
    ds $12, $00

    db $02, $01, $0b, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $d0, $e0, $f8, $f0, $1d, $0e, $08, $1c, $3a, $1c, $3f, $1f, $17, $0f, $00, $00
    db $00, $00, $00, $00, $70, $38, $30, $38, $e8, $70, $d0, $e0, $a0, $c0

    ; padding
    ds $12, $00

    db $03, $07, $0f, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $c0, $e0, $e0, $f0, $07, $0e, $1c, $0e, $0e, $1c, $3f, $1f, $1f, $3f, $70, $38
    db $38, $70, $e0, $70, $b8, $70, $70, $38, $b8, $70, $e0, $f0, $a0, $c0

    ; padding
    ds $12, $00

    db $01, $03, $0f, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $fc, $f8, $f0, $f8, $0c, $1e, $38, $1c, $1a, $3c, $3f, $1f, $17, $0f, $03, $01
    db $01, $03, $07, $03, $38, $70, $e0, $70, $70, $e0, $c0, $e0, $e0, $c0, $80, $c0
    db $c0, $80, $00, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $07, $0e, $1d, $0f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $f0, $70, $e0, $f0, $0f, $1f, $3d, $1e, $1c, $38, $70, $38, $38, $70, $00, $00
    db $00, $00, $00, $00, $c0, $80

    ; padding
    ds $1a, $00

    db $05, $03, $17, $0f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $a0, $c0, $f0, $e0, $0f, $1e, $0b, $07, $39, $71, $7f, $3f, $2f, $1f, $00, $00
    db $00, $00, $00, $00, $30, $70, $40, $80, $c0, $e0, $e0, $c0, $40, $80, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $01, $03, $01
    db $1f, $0f, $0f, $1f, $00, $00, $00, $00, $00, $00, $c0, $e0, $e0, $c0, $80, $c0
    db $e0, $f0, $f0, $e0, $03, $07, $0e, $07, $07, $0e, $07, $0f, $0b, $07, $00, $00
    db $00, $00, $00, $00, $80, $00, $00, $00, $00, $00, $80, $80, $80, $80

    ; padding
    ds $12, $00

    db $0e, $1c, $38, $1c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $70, $38, $b8, $70, $1c, $38, $71, $38, $7f, $39, $3f, $3f, $3e, $1f, $00, $00
    db $00, $00, $00, $00, $70, $e0, $c0, $e0, $e0, $c0, $e0, $e0, $c0, $e0

    ; padding
    ds $12, $00

    db $39, $18, $39, $19, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $e0, $e0, $e0, $c0, $39, $1b, $3b, $1f, $3e, $1f, $3e, $1e, $3c, $1c, $00, $00
    db $00, $00, $00, $00, $c0, $80, $00, $80

    ; padding
    ds $18, $00

    db $38, $19, $39, $19, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $88, $9c, $bc, $98, $39, $1b, $3b, $1f, $3e, $1f, $3d, $1e, $38, $1c, $00, $00
    db $00, $00, $00, $00, $d8, $b0, $a0, $f0, $f0, $e0, $c0, $e0, $e0, $c0

    ; padding
    ds $12, $00

    db $0c, $0e, $06, $0e, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $30, $70, $e0, $f0, $0f, $07, $07, $07, $0f, $0f, $3f, $1f, $39, $7b, $00, $00
    db $00, $00, $00, $00, $e0, $c0, $80, $80, $00, $00, $80, $00, $00, $80

    ; padding
    ds $12, $00

    db $18, $1c, $0c, $1c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $f0, $70, $e0, $e0, $1e, $0d, $07, $0f, $0f, $07, $07, $07, $07, $0e, $1c, $0e
    db $3c, $1c, $38, $38, $e0, $c0, $80, $c0, $80, $80

    ; padding
    ds $16, $00

    db $0f, $1f, $3f, $1f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $fc, $f8, $f0, $f8, $05, $03, $0f, $07, $3d, $1e, $ff, $7f, $7f, $ff, $00, $00
    db $00, $00, $00, $00, $c0, $e0, $00, $80, $00, $00, $c0, $e0, $e0, $c0

    ; padding
    ds $12, $00

    db $02, $01, $0b, $07, $00, $00, $00, $00, $02, $06, $0c, $08, $00, $00, $00, $00
    db $d8, $f8, $f8, $f8, $0d, $1e, $38, $1c, $1b, $3c, $3f, $1f, $17, $0f, $00, $00
    db $00, $00, $00, $00, $f8, $30, $60, $70, $70, $e0, $f0, $f0, $70, $b0

    ; padding
    ds $12, $00

    db $02, $01, $0b, $07, $00, $00, $00, $00, $10, $38, $28, $44, $00, $00, $00, $00
    db $d8, $f8, $f8, $f8, $0d, $1e, $38, $1c, $1b, $3c, $3f, $1f, $17, $0f, $00, $00
    db $00, $00, $00, $00, $f8, $30, $60, $70, $70, $e0, $f0, $f0, $70, $b0

    ; padding
    ds $12, $00

    db $02, $01, $0b, $07, $00, $00, $00, $00, $20, $60, $20, $10, $00, $00, $00, $00
    db $d8, $f8, $f8, $f8, $0d, $1e, $38, $1c, $1b, $3c, $3f, $1f, $17, $0f, $00, $00
    db $00, $00, $00, $00, $f8, $30, $60, $70, $70, $e0, $f0, $f0, $70, $b0

    ; padding
    ds $12, $00

    db $02, $01, $0b, $07, $00, $00, $00, $00, $00, $66, $44, $66, $00, $00, $00, $00
    db $d8, $f8, $f8, $f8, $0d, $1e, $38, $1c, $1b, $3c, $3f, $1f, $17, $0f, $00, $00
    db $00, $00, $00, $00, $f8, $30, $60, $70, $70, $e0, $f0, $f0, $70, $b0

    ; padding
    ds $12, $00

    db $02, $01, $0b, $07, $00, $00, $00, $00, $04, $0c, $18, $10, $00, $00, $00, $00
    db $d0, $e0, $38, $f0, $0d, $1e, $3f, $1f, $1a, $3c, $3c, $1f, $17, $0f, $00, $00
    db $00, $00, $00, $00, $58, $38, $f8, $f8, $00, $00, $70, $e0, $a0, $c0

    ; padding
    ds $12, $00

    db $02, $01, $0b, $07, $00, $00, $00, $00, $20, $70, $50, $88, $00, $00, $00, $00
    db $d0, $e0, $38, $f0, $0d, $1e, $3f, $1f, $1a, $3c, $3c, $1f, $17, $0f, $00, $00
    db $00, $00, $00, $00, $58, $38, $f8, $f8, $00, $00, $70, $e0, $a0, $c0

    ; padding
    ds $12, $00

    db $02, $01, $0b, $07, $00, $00, $00, $00, $40, $c0, $40, $20, $00, $00, $00, $00
    db $d0, $e0, $38, $f0, $0d, $1e, $3f, $1f, $1a, $3c, $3c, $1f, $17, $0f, $00, $00
    db $00, $00, $00, $00, $58, $38, $f8, $f8, $00, $00, $70, $e0, $a0, $c0

    ; padding
    ds $12, $00

    db $02, $01, $0b, $07, $00, $00, $00, $00, $00, $cc, $88, $cc, $00, $00, $00, $00
    db $d0, $e0, $38, $f0, $0d, $1e, $3f, $1f, $1a, $3c, $3c, $1f, $17, $0f, $00, $00
    db $00, $00, $00, $00, $58, $38, $f8, $f8, $00, $00, $70, $e0, $a0, $c0

    ; padding
    ds $13, $00

    db $01, $03, $01, $00, $00, $00, $00, $10, $30, $60, $40, $00, $00, $00, $00, $e0
    db $c0, $80, $c0, $01, $03, $07, $03, $03, $07, $0e, $07, $07, $0e, $00, $00, $00
    db $00, $00, $00, $c0, $80, $00, $80, $80

    ; padding
    ds $12, $00

    db $01, $01, $01, $00, $00, $00, $01, $03, $01, $00, $00, $00, $00, $00, $00, $00
    db $98, $10, $98, $00, $00, $e0, $c0, $80, $c0, $01, $03, $07, $03, $03, $07, $0e
    db $07, $07, $0e, $00, $00, $00, $00, $00, $00, $c0, $80, $00, $80, $80

    ; padding
    ds $17, $00

    db $02, $01, $0b, $07, $00, $00, $00, $00, $10, $30, $60, $40, $00, $00, $00, $00
    db $d0, $e0, $f8, $f0, $1d, $0e, $08, $1c, $3a, $1c, $3f, $1f, $17, $0f, $00, $00
    db $00, $00, $00, $00, $70, $38, $30, $38, $e8, $70, $d0, $e0, $a0, $c0, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $00, $00, $00, $00
    db $02, $01, $0b, $07, $00, $00, $00, $00, $00, $98, $10, $98, $00, $00, $00, $00
    db $d0, $e0, $f8, $f0, $1d, $0e, $08, $1c, $3a, $1c, $3f, $1f, $17, $0f, $00, $00
    db $00, $00, $00, $00, $70, $38, $30, $38, $e8, $70, $d0, $e0, $a0, $c0, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $00, $00, $00, $00
    db $0e, $1c, $38, $1c, $00, $00, $00, $00, $40, $c0, $80, $00, $00, $00, $00, $00
    db $70, $38, $b8, $70, $1c, $38, $71, $38, $7f, $39, $3f, $3f, $3e, $1f, $00, $00
    db $00, $00, $00, $00, $70, $e0, $c0, $e0, $e0, $c0, $e0, $e0, $c0, $e0, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $02, $03, $00, $00, $00, $00
    db $0e, $1c, $38, $1c, $00, $00, $00, $00, $00, $30, $20, $30, $00, $00, $00, $00
    db $70, $38, $b8, $70, $1c, $38, $71, $38, $7f, $39, $3f, $3f, $3e, $1f, $00, $00
    db $00, $00, $00, $00, $70, $e0, $c0, $e0, $e0, $c0, $e0, $e0, $c0, $e0, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $01, $03, $00, $00, $08, $06
    db $06, $0f, $1f, $0f, $00, $00, $00, $00, $d0, $c8, $20, $30, $00, $00, $00, $00
    db $40, $80, $c0, $e0, $0d, $1e, $38, $1c, $1c, $38, $71, $38, $38, $71, $00, $00
    db $00, $00, $00, $00, $f0, $60, $f0, $60, $70, $e0, $c0, $e0, $e0, $c0

    ; padding
    ds $10, $00

    db $02, $01, $0b, $07, $0d, $1e, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $d0, $e0, $f8, $f0, $18, $38, $38, $1c, $1c, $38, $38, $1f, $0f, $1f, $07, $06
    db $03, $03, $23, $1f, $1f, $3e, $00, $00, $70, $00, $70, $e0, $a0, $c0, $00, $00
    db $80, $00, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $02, $01, $03, $07
    db $0f, $07, $07, $0e, $1c, $0e, $00, $00, $00, $00, $00, $00, $f8, $f0, $fc, $f8
    db $ac, $1c, $1c, $1c, $f8, $78, $0e, $1c, $38, $1c, $1c, $38, $73, $39, $b9, $73
    db $00, $00, $00, $00, $00, $00, $78, $f0, $18, $38, $78, $38, $f8, $f0, $d0, $e0

    ; padding
    ds $10, $00

    db $01, $00, $00, $01, $03, $01, $00, $00, $00, $00, $00, $00, $e0, $70, $70, $e0
    db $c0, $e0, $e0, $c0, $80, $c0, $01, $03, $07, $03, $00, $00, $0e, $07, $07, $0e
    db $00, $00, $00, $00, $00, $00, $c0, $80, $00, $80

    ; padding
    ds $12, $00

    db $02, $01, $03, $07, $0e, $07, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00
    db $f8, $f0, $fc, $f8, $ac, $1c, $3c, $1c, $fc, $f8, $01, $03, $03, $03, $00, $00
    db $0e, $07, $07, $0e, $00, $00, $00, $00, $00, $00, $e8, $f0, $00, $80

    ; padding
    ds $12, $00

    db $01, $03, $07, $07, $0f, $0f, $0e, $1e, $0c, $1c, $00, $00, $00, $00, $00, $00
    db $d0, $e0, $f8, $f0, $30, $f8, $70, $38, $70, $38, $18, $3c, $1c, $38, $1a, $3d
    db $1f, $1f, $07, $0f, $00, $00, $00, $00, $00, $00, $70, $70, $e0, $f0, $e0, $e0
    db $c0, $c0, $00, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $01, $03, $03, $00, $01, $03, $01, $00, $00, $00, $00, $00, $00
    db $e0, $70, $f0, $e0, $c0, $e0, $e0, $c0, $80, $c0, $01, $03, $07, $03, $03, $07
    db $3f, $1f, $1f, $3f, $00, $00, $00, $00, $00, $00, $c0, $80, $00, $80, $00, $00
    db $80, $c0, $c0, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $05, $03, $07, $0f, $1e, $0f, $1c, $0e, $00, $00, $00, $00, $00, $00, $00, $00
    db $d0, $e0, $f8, $f0, $b0, $78, $70, $38, $70, $70, $01, $03, $07, $0f, $3c, $1e
    db $7f, $3f, $3f, $7f, $00, $00, $00, $00, $00, $00, $e0, $e0, $80, $c0, $00, $00
    db $c0, $e0, $e0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $05, $03, $07, $0f, $1e, $0f, $1c, $0e, $01, $00, $00, $00, $00, $00, $00, $00
    db $d0, $e0, $f8, $f0, $b0, $78, $70, $38, $f0, $f0, $00, $01, $38, $1c, $18, $3c
    db $0f, $1f, $07, $0f, $00, $00, $00, $00, $00, $00, $f0, $e0, $60, $70, $60, $f0
    db $f0, $e0, $a0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $07, $03, $03, $07, $0e, $07, $07, $0e, $1f, $0f, $00, $00, $00, $00, $00, $00
    db $38, $9c, $9c, $38, $70, $38, $38, $70, $f0, $f8, $0f, $1f, $01, $00, $00, $01
    db $03, $01, $01, $03, $00, $00, $00, $00, $00, $00, $f8, $f0, $c0, $e0, $e0, $c0
    db $80, $c0, $c0, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $07, $03, $03, $07, $0f, $07, $07, $0f, $1f, $0f, $00, $00, $00, $00, $00, $00
    db $f8, $fc, $fc, $f8, $80, $00, $80, $c0, $c0, $e0, $00, $00, $38, $1c, $18, $3c
    db $0f, $1f, $07, $0f, $00, $00, $00, $00, $00, $00, $60, $f0, $e0, $70, $60, $f0
    db $c0, $e0, $80, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $05, $03, $07, $0f, $1e, $0f, $0c, $1e, $3f, $1f, $00, $00, $00, $00, $00, $00
    db $d0, $e0, $f8, $f0, $b0, $78, $00, $00, $c0, $c0, $1f, $3f, $1c, $38, $18, $3c
    db $0f, $1f, $07, $0f, $00, $00, $00, $00, $00, $00, $f0, $e0, $e0, $70, $60, $f0
    db $f0, $e0, $a0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $1f, $0f, $0f, $1f, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00
    db $f0, $f8, $f8, $f0, $e0, $70, $70, $e0, $c0, $e0, $00, $01, $03, $01, $01, $03
    db $07, $03, $03, $07, $00, $00, $00, $00, $00, $00, $e0, $c0, $80, $c0, $c0, $80
    db $00, $80, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $05, $03, $07, $0f, $1e, $0f, $1c, $0e, $07, $0f, $00, $00, $00, $00, $00, $00
    db $d0, $e0, $f8, $f0, $b0, $78, $70, $38, $f0, $f0, $0f, $1f, $38, $1c, $18, $3c
    db $0f, $1f, $07, $0f, $00, $00, $00, $00, $00, $00, $f0, $e0, $60, $70, $60, $f0
    db $f0, $e0, $a0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $05, $03, $07, $0f, $1e, $0f, $1c, $0e, $07, $0f, $00, $00, $00, $00, $00, $00
    db $d0, $e0, $f8, $f0, $b0, $78, $78, $38, $f0, $f8, $03, $07, $00, $00, $38, $1c
    db $0f, $1f, $07, $0f, $00, $00, $00, $00, $00, $00, $f8, $f0, $70, $70, $60, $f0
    db $f0, $e0, $a0, $c0

    ; padding
    ds $706, $00
