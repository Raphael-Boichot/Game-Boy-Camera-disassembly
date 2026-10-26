; Game Boy Camera (USA, Europe), bank $29. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $029", ROMX[$4000], BANK[$29]

    db $01, $00, $03, $04, $01

    ; padding
    ds $14, $fe

    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $01, $00, $04, $04, $01

    ; padding
    ds $1b, $ff

    db $00, $00, $03, $00, $00, $fe, $fe, $fe, $fe, $fe, $fe, $0e, $08, $16, $16, $1c
    db $34, $34, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $05, $00, $00, $fe, $5c, $44, $36, $50, $4a, $fe, $66, $52, $5e, $fe
    db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $06, $00, $00, $ff, $5d, $45, $37, $51, $4b, $ff, $67, $53, $5f

    ; padding
    ds $11, $ff

    db $01, $00, $07, $00, $00, $fe, $fe, $40, $52, $58, $fe, $5e, $5a, $46, $50, $42
    db $fe, $5c, $44, $3e, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $08, $00, $00, $ff, $ff, $41, $53, $59, $ff, $5f, $5b, $47, $51, $43
    db $ff, $5d, $45, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $09, $00, $00, $fe, $fe, $fe, $42, $36, $4e, $3e, $fe, $38, $52, $66
    db $fe, $3a, $36, $4e, $3e, $58, $36, $6a, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0a, $00, $00, $ff, $ff, $ff, $43, $37, $4f, $3f, $ff, $39, $53, $67
    db $ff, $3b, $37, $4f, $3f, $59, $37, $6b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0b, $00, $00, $fe, $54, $4c, $3e, $36, $5a, $3e, $fe, $5c, $36, $4a
    db $3e, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0c, $00, $00, $ff, $55, $4d, $3f, $37, $5b, $3f, $ff, $5d, $37, $4b
    db $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0d, $00, $00, $fe, $fe, $42, $52, $52, $3c, $fe, $3a, $36, $58, $3e
    db $fe, $52, $40, $fe, $46, $5c, $6a, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0e, $00, $00, $ff, $ff, $43, $53, $53, $3d, $ff, $3b, $37, $59, $3f
    db $ff, $53, $41, $ff, $47, $5d, $6b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0f, $08, $01, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $5c
    db $44, $3e, $fe, $5a, $5c, $36, $40, $40, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $10, $08, $01, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $5d
    db $45, $3f, $ff, $5b, $5d, $37, $41, $41, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $02, $00, $00, $fe, $fe, $fe, $26, $0e, $00, $1a, $14, $24, $fe, $26
    db $1c, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $03, $00, $00, $fe, $fe, $fe, $fe, $08, $2a, $08, $22, $30, $1c, $1a
    db $08, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $04, $00, $00, $fe, $fe, $fe, $fe, $fe, $10, $1a, $2a, $1c, $16, $2a
    db $08, $06, $fe, $10, $1a, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $05, $00, $00, $fe, $fe, $fe, $fe, $fe, $fe, $26, $0e, $10, $24, $fe
    db $1e, $22, $1c, $12, $08, $04, $26, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $07, $00, $00, $fe, $50, $46, $50, $5c, $3e, $50, $3c, $52, $fe, $52
    db $40, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $08, $00, $00, $ff, $51, $47, $51, $5d, $3f, $51, $3d, $53, $ff, $53
    db $41, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $00, $00, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $36, $4e, $3e, $58
    db $46, $3a, $36, $fe, $46, $50, $3a, $6a, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0a, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $37, $4f, $3f, $59
    db $47, $3b, $37, $ff, $47, $51, $3b, $6b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0c, $00, $00, $fe, $50, $46, $50, $5c, $3e, $50, $3c, $52, $fe, $52
    db $40, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0d, $00, $00, $ff, $51, $47, $51, $5d, $3f, $51, $3d, $53, $ff, $53
    db $41, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0e, $06, $02, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $3e, $5e, $58, $52
    db $54, $3e, $fe, $42, $4e, $38, $44, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0f, $06, $02, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $3f, $5f, $59, $53
    db $55, $3f, $ff, $43, $4f, $39, $45, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $07, $00, $00, $fe, $50, $46, $50, $5c, $3e, $50, $3c, $52, $fe, $3a
    db $52, $6a, $6e, $4c, $5c, $3c, $6a, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $08, $00, $00, $ff, $51, $47, $51, $5d, $3f, $51, $3d, $53, $ff, $3b
    db $53, $6b, $6f, $4d, $5d, $3d, $6b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0a, $00, $00, $fe, $5c, $44, $36, $50, $4a, $fe, $66, $52, $5e, $fe
    db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0b, $00, $00, $ff, $5d, $45, $37, $51, $4b, $ff, $67, $53, $5f

    ; padding
    ds $11, $ff

    db $01, $01, $0c, $00, $00, $fe, $fe, $60, $3e, $58, $66, $fe, $4e, $5e, $3a, $44
    db $fe, $40, $52, $58, $fe, $36, $4c, $4c, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0d, $00, $00, $ff, $ff, $61, $3f, $59, $67, $ff, $4f, $5f, $3b, $45
    db $ff, $41, $53, $59, $ff, $37, $4d, $4d, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0e, $06, $01, $fe, $fe, $fe, $66, $52, $5e, $58, $fe, $44, $36, $58
    db $3c, $fe, $62, $52, $58, $4a, $6a, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0f, $06, $01, $ff, $ff, $ff, $67, $53, $5f, $59, $ff, $45, $37, $59
    db $3d, $ff, $63, $53, $59, $4b, $6b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $03, $02, $01

    ; padding
    ds $14, $fe

    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $01, $00, $04, $02, $01

    ; padding
    ds $1b, $ff

    db $00, $00, $07, $00, $00, $fe, $fe, $0c, $00, $18, $08, $fe, $02, $1c, $30, $fe
    db $04, $00, $18, $08, $22, $00, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $08, $06, $01, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $24, $26, $00, $0a
    db $0a, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $06, $00, $00, $fe, $fe, $fe, $fe, $06, $10, $22, $08, $04, $26, $1c
    db $22, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $08, $06, $01, $fe, $fe, $44, $46, $58, $52, $4a, $36, $68, $5e, $fe
    db $5c, $36, $50, $36, $4a, $36, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $09, $06, $01, $ff, $ff, $45, $47, $59, $53, $4b, $37, $69, $5f, $ff
    db $5d, $37, $51, $37, $4b, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $06, $00, $00, $fe, $fe, $0e, $00, $22, $06, $2c, $00, $22, $08, $fe
    db $06, $08, $24, $10, $0c, $1a, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $08, $06, $01, $fe, $fe, $4e, $36, $5a, $36, $5c, $52, $fe, $4a, $5e
    db $62, $36, $44, $36, $58, $36, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $09, $06, $01, $ff, $ff, $4f, $37, $5b, $37, $5d, $53, $ff, $4b, $5f
    db $63, $37, $45, $37, $59, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $03, $00, $00, $fe, $fe, $fe, $fe, $00, $24, $24, $10, $24, $26, $00
    db $1a, $26, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $04, $00, $00, $fe, $fe, $fe, $fe, $06, $10, $22, $08, $04, $26, $1c
    db $22, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $06, $00, $00, $fe, $fe, $58, $66, $5e, $46, $3a, $44, $46, $fe, $50
    db $36, $4a, $36, $3c, $36, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $07, $00, $00, $ff, $ff, $59, $67, $5f, $47, $3b, $45, $47, $ff, $51
    db $37, $4b, $37, $3d, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $09, $00, $00, $fe, $fe, $5c, $36, $4a, $36, $5a, $44, $46, $fe, $52
    db $50, $52, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0a, $00, $00, $ff, $ff, $5d, $37, $4b, $37, $5b, $45, $47, $ff, $53
    db $51, $53, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $0c, $00, $00, $fe, $fe, $fe, $fe, $04, $1c, $1c, $22, $06, $10, $1a
    db $00, $26, $1c, $22, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0e, $06, $01, $fe, $fe, $4a, $3e, $50, $5c, $36, $58, $52, $fe, $50
    db $46, $5a, $44, $46, $4e, $5e, $58, $36, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0f, $06, $01, $ff, $ff, $4b, $3f, $51, $5d, $37, $59, $53, $ff, $51
    db $47, $5b, $45, $47, $4f, $5f, $59, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $06, $00, $00, $fe, $fe, $18, $00, $10, $1a, $fe, $1e, $22, $1c, $0c
    db $22, $00, $18, $18, $08, $22, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $08, $06, $01, $fe, $fe, $50, $52, $58, $46, $36, $4a, $46, $fe, $5c
    db $3e, $58, $36, $4e, $52, $5c, $52, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $09, $06, $01, $ff, $ff, $51, $53, $59, $47, $37, $4b, $47, $ff, $5d
    db $3f, $59, $37, $4f, $53, $5d, $53, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $03, $00, $00, $fe, $fe, $0c, $22, $00, $1e, $0e, $10, $04, $fe, $06
    db $08, $24, $10, $0c, $1a, $08, $22, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $05, $00, $00, $fe, $fe, $5a, $44, $46, $50, $48, $46, $fe, $5c, $36
    db $4a, $36, $4e, $46, $50, $3e, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $ff, $ff, $5b, $45, $47, $51, $49, $47, $ff, $5d, $37
    db $4b, $37, $4f, $47, $51, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $08, $00, $00, $fe, $fe, $58, $66, $5e, $46, $3a, $44, $46, $fe, $50
    db $36, $4a, $36, $3c, $36, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $00, $00, $ff, $ff, $59, $67, $5f, $47, $3b, $45, $47, $ff, $51
    db $37, $4b, $37, $3d, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0b, $06, $02, $fe, $fe, $5c, $36, $4a, $36, $5a, $44, $46, $fe, $52
    db $50, $52, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0c, $06, $02, $ff, $ff, $5d, $37, $4b, $37, $5b, $45, $47, $ff, $53
    db $51, $53, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $05, $00, $00, $fe, $fe, $44, $46, $58, $52, $4a, $36, $68, $5e, $fe
    db $5c, $36, $50, $36, $4a, $36, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $06, $00, $00, $ff, $ff, $45, $47, $59, $53, $4b, $37, $69, $5f, $ff
    db $5d, $37, $51, $37, $4b, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $08, $06, $01, $fe, $fe, $46, $5a, $5a, $44, $46, $50, $fe, $5a, $44
    db $46, $4e, $46, $68, $5e, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $09, $06, $01, $ff, $ff, $47, $5b, $5b, $45, $47, $51, $ff, $5b, $45
    db $47, $4f, $47, $69, $5f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $03, $00, $00, $fe, $fe, $fe, $00, $06, $06, $10, $26, $10, $1c, $1a
    db $00, $16, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $04, $00, $00, $fe, $fe, $fe, $1e, $22, $1c, $0c, $22, $00, $18, $18
    db $08, $22, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $fe, $fe, $44, $36, $5c, $36, $52, $fe, $52, $42, $36
    db $5c, $36, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $07, $00, $00, $ff, $ff, $45, $37, $5d, $37, $53, $ff, $53, $43, $37
    db $5d, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $06, $02, $fe, $fe, $44, $46, $5c, $52, $5a, $44, $46, $fe, $66
    db $36, $4e, $36, $42, $36, $4e, $46, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0a, $06, $02, $ff, $ff, $45, $47, $5d, $53, $5b, $45, $47, $ff, $67
    db $37, $4f, $37, $43, $37, $4f, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $fe, $fe, $5c, $52, $58, $5e, $fe, $52, $3e, $fe, $fe
    db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $07, $00, $00, $ff, $ff, $5d, $53, $59, $5f, $ff, $53, $3f

    ; padding
    ds $12, $ff

    db $01, $02, $09, $06, $01, $fe, $fe, $66, $52, $5a, $44, $46, $50, $52, $58, $46
    db $fe, $4a, $36, $5c, $5a, $5e, $4a, $46, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0a, $06, $01, $ff, $ff, $67, $53, $5b, $45, $47, $51, $53, $59, $47
    db $ff, $4b, $37, $5d, $5b, $5f, $4b, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $03, $00, $00, $fe, $fe, $fe, $24, $1c, $28, $1a, $06, $fe, $04, $1c
    db $18, $1e, $1c, $24, $08, $22, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $05, $00, $00, $fe, $fe, $44, $46, $58, $52, $4a, $36, $68, $5e, $fe
    db $5c, $36, $50, $36, $4a, $36, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $06, $00, $00, $ff, $ff, $45, $47, $59, $53, $4b, $37, $69, $5f, $ff
    db $5d, $37, $51, $37, $4b, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $08, $00, $00, $fe, $fe, $4e, $46, $50, $36, $4a, $52, $fe, $44, $36
    db $4e, $36, $50, $52, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $09, $00, $00, $ff, $ff, $4f, $47, $51, $37, $4b, $53, $ff, $45, $37
    db $4f, $37, $51, $53, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0b, $06, $01, $fe, $fe, $4a, $3e, $50, $5c, $36, $58, $52, $fe, $50
    db $46, $5a, $44, $46, $4e, $5e, $58, $36, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0c, $06, $01, $ff, $ff, $4b, $3f, $51, $5d, $37, $59, $53, $ff, $51
    db $47, $5b, $45, $47, $4f, $5f, $59, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $03, $00, $00, $fe, $fe, $fe, $fe, $fe, $fe, $00, $06, $2a, $10, $24
    db $1c, $22, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $05, $00, $00, $fe, $fe, $54, $44, $46, $4c, $fe, $5a, $36, $50, $3c
    db $44, $52, $54, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $06, $00, $00, $ff, $ff, $55, $45, $47, $4d, $ff, $5b, $37, $51, $3d
    db $45, $53, $55, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $08, $06, $01, $fe, $fe, $3e, $58, $46, $3a, $44, $fe, $62, $36, $36
    db $5a, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $09, $06, $01, $ff, $ff, $3f, $59, $47, $3b, $45, $ff, $63, $37, $37
    db $5b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $03, $00, $00, $fe, $fe, $fe, $16, $1c, $04, $00, $16, $10, $32, $00
    db $26, $10, $1c, $1a, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $04, $00, $00, $fe, $fe, $fe, $04, $1c, $1c, $22, $06, $10, $1a, $00
    db $26, $1c, $22, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $06, $00, $00, $fe, $fe, $66, $5e, $5a, $5e, $4a, $3e, $fe, $3e, $3c
    db $36, $5a, $36, $62, $36, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $07, $00, $00, $ff, $ff, $67, $5f, $5b, $5f, $4b, $3f, $ff, $3f, $3d
    db $37, $5b, $37, $63, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $09, $06, $01, $fe, $fe, $44, $46, $58, $52, $66, $5e, $4a, $46, $fe
    db $5e, $3e, $5a, $5e, $42, $46, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0a, $06, $01, $ff, $ff, $45, $47, $59, $53, $67, $5f, $4b, $47, $ff
    db $5f, $3f, $5b, $5f, $43, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $03, $00, $00, $fe, $fe, $00, $06, $06, $10, $26, $10, $1c, $1a, $00
    db $16, $fe, $24, $26, $00, $0a, $0a, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $05, $00, $00, $fe, $fe, $58, $66, $52, $48, $46, $fe, $66, $52, $5a
    db $44, $46, $5c, $52, $4e, $46, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $06, $00, $00, $ff, $ff, $59, $67, $53, $49, $47, $ff, $67, $53, $5b
    db $45, $47, $5d, $53, $4f, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $08, $00, $00, $fe, $fe, $4a, $3e, $50, $48, $46, $fe, $66, $36, $4e
    db $36, $4e, $52, $5c, $52, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $09, $00, $00, $ff, $ff, $4b, $3f, $51, $49, $47, $ff, $67, $37, $4f
    db $37, $4f, $53, $5d, $53, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0b, $00, $00, $fe, $fe, $66, $52, $5a, $44, $46, $52, $fe, $5a, $36
    db $4a, $36, $4e, $52, $5c, $52, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0c, $00, $00, $ff, $ff, $67, $53, $5b, $45, $47, $53, $ff, $5b, $37
    db $4b, $37, $4f, $53, $5d, $53, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0e, $08, $01, $fe, $fe, $50, $52, $58, $46, $4a, $52, $fe, $4e, $36
    db $46, $5a, $44, $46, $42, $46, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0f, $08, $01, $ff, $ff, $51, $53, $59, $47, $4b, $53, $ff, $4f, $37
    db $47, $5b, $45, $47, $43, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $03, $00, $00, $fe, $fe, $fe, $fe, $1e, $0e, $1c, $26, $1c, $fe, $18
    db $1c, $06, $08, $16, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $05, $00, $00, $fe, $fe, $36, $5a, $36, $4a, $52, $fe, $4a, $52, $68
    db $5e, $4a, $46, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $ff, $ff, $37, $5b, $37, $4b, $53, $ff, $4b, $53, $69
    db $5f, $4b, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $08, $00, $00, $fe, $fe, $4a, $52, $5c, $36, $fe, $40, $5e, $4a, $5e
    db $46, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $00, $00, $ff, $ff, $4b, $53, $5d, $37, $ff, $41, $5f, $4b, $5f
    db $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0b, $06, $02, $fe, $fe, $36, $5c, $5a, $5e, $5a, $44, $46, $fe, $4a
    db $36, $66, $36, $4e, $36, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0c, $06, $02, $ff, $ff, $37, $5d, $5b, $5f, $5b, $45, $47, $ff, $4b
    db $37, $67, $37, $4f, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $05, $00, $00, $fe, $fe, $58, $52, $50, $50, $66, $fe, $42, $3e, $50
    db $5a, $46, $3a, $4a, $3e, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $ff, $ff, $59, $53, $51, $51, $67, $ff, $43, $3f, $51
    db $5b, $47, $3b, $4b, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $08, $06, $02, $fe, $fe, $4e, $36, $58, $4a, $52, $fe, $44, $3e, $46
    db $50, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $06, $02, $ff, $ff, $4f, $37, $59, $4b, $53, $ff, $45, $3f, $47
    db $51, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $05, $00, $00, $fe, $fe, $4e, $36, $58, $3a, $5e, $5a, $fe, $4e, $3e
    db $50, $52, $4c, $3c, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $ff, $ff, $4f, $37, $59, $3b, $5f, $5b, $ff, $4f, $3f
    db $51, $53, $4d, $3d, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $08, $00, $00, $fe, $fe, $44, $36, $50, $5a, $fe, $4a, $52, $44, $58
    db $5a, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $00, $00, $ff, $ff, $45, $37, $51, $5b, $ff, $4b, $53, $45, $59
    db $5b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0b, $06, $01, $fe, $fe, $50, $52, $36, $fe, $40, $36, $3a, $3e, $fe
    db $4e, $52, $3c, $3e, $4c, $5a, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0c, $06, $01, $ff, $ff, $51, $53, $37, $ff, $41, $37, $3b, $3f, $ff
    db $4f, $53, $3d, $3f, $4d, $5b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $03, $00, $00, $fe, $fe, $fe, $0e, $00, $22, $06, $2c, $00, $22, $08
    db $fe, $24, $26, $00, $0a, $0a, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $05, $00, $00, $fe, $fe, $4a, $36, $68, $5e, $52, $fe, $66, $52, $50
    db $3e, $66, $36, $4e, $36, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $ff, $ff, $4b, $37, $69, $5f, $53, $ff, $67, $53, $51
    db $3f, $67, $37, $4f, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $08, $00, $00, $fe, $fe, $5c, $36, $4a, $36, $5a, $44, $46, $fe, $52
    db $50, $52, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $00, $00, $ff, $ff, $5d, $37, $4b, $37, $5b, $45, $47, $ff, $53
    db $51, $53, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0b, $06, $02, $fe, $fe, $4e, $36, $5a, $36, $44, $46, $4a, $52, $fe
    db $52, $5c, $36, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0c, $06, $02, $ff, $ff, $4f, $37, $5b, $37, $45, $47, $4b, $53, $ff
    db $53, $5d, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $05, $00, $00, $fe, $fe, $66, $36, $5a, $5e, $66, $5e, $4a, $46, $fe
    db $36, $5a, $36, $3c, $36, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $ff, $ff, $67, $37, $5b, $5f, $67, $5f, $4b, $47, $ff
    db $37, $5b, $37, $3d, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $08, $00, $00, $fe, $fe, $4a, $3e, $46, $68, $52, $fe, $5c, $36, $4a
    db $36, $42, $46, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $00, $00, $ff, $ff, $4b, $3f, $47, $69, $53, $ff, $5d, $37, $4b
    db $37, $43, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0b, $06, $02, $fe, $fe, $4a, $52, $48, $46, $fe, $40, $5e, $48, $46
    db $4e, $52, $5c, $52, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0c, $06, $02, $ff, $ff, $4b, $53, $49, $47, $ff, $41, $5f, $49, $47
    db $4f, $53, $5d, $53, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $05, $00, $00, $fe, $fe, $4e, $36, $50, $36, $38, $5e, $fe, $5a, $44
    db $46, $4e, $52, $4a, $36, $62, $36, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $ff, $ff, $4f, $37, $51, $37, $39, $5f, $ff, $5b, $45
    db $47, $4f, $53, $4b, $37, $63, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $08, $00, $00, $fe, $fe, $5c, $52, $58, $5e, $fe, $52, $3e, $fe, $fe
    db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $00, $00, $ff, $ff, $5d, $53, $59, $5f, $ff, $53, $3f

    ; padding
    ds $12, $ff

    db $01, $01, $0b, $00, $00, $fe, $fe, $66, $52, $5a, $5e, $4a, $3e, $fe, $44, $36
    db $5c, $36, $66, $36, $4e, $36, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0c, $00, $00, $ff, $ff, $67, $53, $5b, $5f, $4b, $3f, $ff, $45, $37
    db $5d, $37, $67, $37, $4f, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0e, $08, $01, $fe, $fe, $5c, $3e, $5c, $5a, $5e, $66, $36, $fe, $4e
    db $52, $4e, $46, $50, $52, $4a, $46, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0f, $08, $01, $ff, $ff, $5d, $3f, $5d, $5b, $5f, $67, $37, $ff, $4f
    db $53, $4f, $47, $51, $53, $4b, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $03, $00, $00, $fe, $fe, $fe, $fe, $00, $22, $26, $fe, $2c, $1c, $22
    db $14, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $05, $00, $00, $fe, $fe, $40, $5e, $48, $46, $4a, $52, $fe, $50, $52
    db $4e, $5e, $58, $36, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $06, $00, $00, $ff, $ff, $41, $5f, $49, $47, $4b, $53, $ff, $51, $53
    db $4f, $5f, $59, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $08, $00, $00, $fe, $fe, $50, $52, $58, $46, $66, $5e, $4a, $46, $fe
    db $5a, $36, $5c, $52, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $09, $00, $00, $ff, $ff, $51, $53, $59, $47, $67, $5f, $4b, $47, $ff
    db $5b, $37, $5d, $53, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0b, $00, $00, $fe, $fe, $46, $50, $52, $5e, $3e, $fe, $66, $36, $5a
    db $5e, $52, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0c, $00, $00, $ff, $ff, $47, $51, $53, $5f, $3f, $ff, $67, $37, $5b
    db $5f, $53, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0e, $08, $01, $fe, $fe, $4e, $46, $3a, $44, $46, $5c, $36, $4a, $36
    db $fe, $5c, $36, $44, $36, $58, $36, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0f, $08, $01, $ff, $ff, $4f, $47, $3b, $45, $47, $5d, $37, $4b, $37
    db $ff, $5d, $37, $45, $37, $59, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $03, $00, $00, $fe, $fe, $fe, $24, $1e, $08, $04, $10, $00, $16, $fe
    db $26, $0e, $00, $1a, $14, $24, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $05, $00, $00, $fe, $fe, $5c, $36, $4a, $36, $5a, $44, $46, $fe, $4a
    db $36, $62, $36, $42, $5e, $3a, $44, $46, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $ff, $ff, $5d, $37, $4b, $37, $5b, $45, $47, $ff, $4b
    db $37, $63, $37, $43, $5f, $3b, $45, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $08, $06, $02, $fe, $fe, $36, $4a, $46, $5c, $5a, $5e, $42, $5e, $fe
    db $4e, $5e, $58, $36, $5e, $3a, $44, $46, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $06, $02, $ff, $ff, $37, $4b, $47, $5d, $5b, $5f, $43, $5f, $ff
    db $4f, $5f, $59, $37, $5f, $3b, $45, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $fe, $fe, $5c, $5a, $5e, $50, $3e, $4a, $36, $68, $5e
    db $fe, $46, $5a, $44, $46, $44, $36, $58, $36, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $07, $00, $00, $ff, $ff, $5d, $5b, $5f, $51, $3f, $4b, $37, $69, $5f
    db $ff, $47, $5b, $45, $47, $45, $37, $59, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $06, $02, $fe, $fe, $50, $46, $58, $60, $36, $50, $36, $fe, $fe
    db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0a, $06, $02, $ff, $ff, $51, $47, $59, $61, $37, $51, $37

    ; padding
    ds $12, $ff

    db $01, $01, $06, $00, $00, $fe, $fe, $5a, $36, $5c, $52, $5a, $44, $46, $fe, $5c
    db $36, $48, $46, $58, $46, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $07, $00, $00, $ff, $ff, $5b, $37, $5d, $53, $5b, $45, $47, $ff, $5d
    db $37, $49, $47, $59, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $06, $02, $fe, $fe, $4a, $3e, $50, $fe, $5a, $5e, $42, $46, $4e
    db $52, $58, $46, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0a, $06, $02, $ff, $ff, $4b, $3f, $51, $ff, $5b, $5f, $43, $47, $4f
    db $53, $59, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $05, $00, $00, $fe, $fe, $5a, $44, $46, $42, $3e, $4a, $46, $fe, $4e
    db $52, $58, $46, $4e, $52, $5c, $52, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $ff, $ff, $5b, $45, $47, $43, $3f, $4b, $47, $ff, $4f
    db $53, $59, $47, $4f, $53, $5d, $53, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $08, $00, $00, $fe, $fe, $4e, $52, $5c, $52, $40, $5e, $4e, $46, $fe
    db $40, $5e, $48, $46, $62, $36, $58, $36, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $00, $00, $ff, $ff, $4f, $53, $5d, $53, $41, $5f, $4f, $47, $ff
    db $41, $5f, $49, $47, $63, $37, $59, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0b, $06, $02, $fe, $fe, $36, $5c, $5a, $5e, $4a, $52, $fe, $50, $46
    db $5a, $44, $46, $3c, $36, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0c, $06, $02, $ff, $ff, $37, $5d, $5b, $5f, $4b, $53, $ff, $51, $47
    db $5b, $45, $47, $3d, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $05, $00, $00, $fe, $46, $fe, $36, $4c, $62, $36, $66, $5a, $fe, $5c
    db $44, $36, $50, $4a, $fe, $66, $52, $5e, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $ff, $47, $ff, $37, $4d, $63, $37, $67, $5b, $ff, $5d
    db $45, $37, $51, $4b, $ff, $67, $53, $5f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $07, $00, $00, $fe, $fe, $40, $52, $58, $fe, $66, $52, $5e, $58, $fe
    db $44, $3e, $4c, $54, $6a, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $08, $00, $00, $ff, $ff, $41, $53, $59, $ff, $67, $53, $5f, $59, $ff
    db $45, $3f, $4d, $55, $6b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0a, $00, $00, $fe, $fe, $4e, $46, $4a, $46, $4a, $52, $fe, $50, $36
    db $4a, $36, $3c, $36, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0b, $00, $00, $ff, $ff, $4f, $47, $4b, $47, $4b, $53, $ff, $51, $37
    db $4b, $37, $3d, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0c, $00, $00, $fe, $fe, $66, $36, $5a, $5e, $4a, $52, $fe, $50, $46
    db $5a, $44, $46, $4e, $5e, $58, $36, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0d, $00, $00, $ff, $ff, $67, $37, $5b, $5f, $4b, $53, $ff, $51, $47
    db $5b, $45, $47, $4f, $5f, $59, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0e, $06, $02, $fe, $fe, $5c, $36, $4a, $36, $4a, $52, $fe, $5c, $36
    db $46, $58, $36, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0f, $06, $02, $ff, $ff, $5d, $37, $4b, $37, $4b, $53, $ff, $5d, $37
    db $47, $59, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $05, $00, $00, $fe, $fe, $66, $52, $5a, $44, $46, $44, $46, $58, $52
    db $fe, $5c, $36, $50, $36, $4a, $36, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $ff, $ff, $67, $53, $5b, $45, $47, $45, $47, $59, $53
    db $ff, $5d, $37, $51, $37, $4b, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $08, $00, $00, $fe, $fe, $5a, $3e, $46, $4a, $46, $fe, $46, $5a, $44
    db $46, $44, $36, $58, $36, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $00, $00, $ff, $ff, $5b, $3f, $47, $4b, $47, $ff, $47, $5b, $45
    db $47, $45, $37, $59, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0a, $00, $00, $fe, $fe, $58, $66, $5e, $46, $3a, $44, $46, $fe, $66
    db $52, $5a, $44, $46, $3c, $36, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0b, $00, $00, $ff, $ff, $59, $67, $5f, $47, $3b, $45, $47, $ff, $67
    db $53, $5b, $45, $47, $3d, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0c, $00, $00, $fe, $fe, $44, $46, $5c, $52, $5a, $44, $46, $fe, $50
    db $36, $4a, $36, $46, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0d, $00, $00, $ff, $ff, $45, $47, $5d, $53, $5b, $45, $47, $ff, $51
    db $37, $4b, $37, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0e, $08, $02, $fe, $fe, $5a, $44, $46, $50, $66, $36, $fe, $5a, $36
    db $50, $52, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0f, $08, $02, $ff, $ff, $5b, $45, $47, $51, $67, $37, $ff, $5b, $37
    db $51, $53, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $05, $00, $00, $fe, $fe, $fe, $fe, $fe, $5c, $44, $36, $50, $4a, $5a
    db $fe, $5c, $52, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $ff, $ff, $ff, $ff, $ff, $5d, $45, $37, $51, $4b, $5b
    db $ff, $5d, $53, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $08, $00, $00, $fe, $fe, $48, $46, $4e, $fe, $62, $52, $58, $50, $3e
    db $4c, $4c, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $00, $00, $ff, $ff, $49, $47, $4f, $ff, $63, $53, $59, $51, $3f
    db $4d, $4d, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0a, $06, $02, $fe, $fe, $48, $46, $4e, $fe, $44, $52, $4c, $3c, $3e
    db $4e, $36, $50, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0b, $06, $02, $ff, $ff, $49, $47, $4f, $ff, $45, $53, $4d, $3d, $3f
    db $4f, $37, $51, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $08, $08, $02, $fe, $fe, $5a, $5e, $54, $3e, $58, $fe, $4e, $36, $58
    db $46, $52, $fe, $3a, $4c, $5e, $38, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $09, $08, $02, $ff, $ff, $5b, $5f, $55, $3f, $59, $ff, $4f, $37, $59
    db $47, $53, $ff, $3b, $4d, $5f, $39, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $08, $06, $02, $fe, $fe, $48, $5e, $54, $46, $5c, $3e, $58, $fe, $3a
    db $52, $6a, $6e, $4c, $5c, $3c, $6a, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $09, $06, $02, $ff, $ff, $49, $5f, $55, $47, $5d, $3f, $59, $ff, $3b
    db $53, $6b, $6f, $4d, $5d, $3d, $6b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $08, $06, $01, $fe, $fe, $42, $5e, $4e, $54, $3e, $46, $fe, $66, $52
    db $4a, $52, $46, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $09, $06, $01, $ff, $ff, $43, $5f, $4f, $55, $3f, $47, $ff, $67, $53
    db $4b, $53, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $04, $00, $00, $fe, $fe, $fe, $fe, $1e, $22, $1c, $06, $28, $04, $08
    db $22, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $06, $00, $00, $fe, $fe, $5a, $36, $5c, $52, $58, $5e, $fe, $52, $4a
    db $36, $3c, $36, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $07, $00, $00, $ff, $ff, $5b, $37, $5d, $53, $59, $5f, $ff, $53, $4b
    db $37, $3d, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $09, $06, $01, $fe, $fe, $5c, $36, $4a, $3e, $44, $46, $58, $52, $fe
    db $46, $68, $5e, $5a, $44, $46, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0a, $06, $01, $ff, $ff, $5d, $37, $4b, $3f, $45, $47, $59, $53, $ff
    db $47, $69, $5f, $5b, $45, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $05, $00, $00, $fe, $fe, $fe, $fe, $08, $2e, $08, $04, $28, $26, $10
    db $2a, $08, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $06, $00, $00, $fe, $fe, $fe, $fe, $1e, $22, $1c, $06, $28, $04, $08
    db $22, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $08, $06, $01, $fe, $fe, $44, $46, $58, $52, $5a, $44, $46, $fe, $66
    db $36, $4e, $36, $5e, $3a, $44, $46, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $09, $06, $01, $ff, $ff, $45, $47, $59, $53, $5b, $45, $47, $ff, $67
    db $37, $4f, $37, $5f, $3b, $45, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $08, $00, $00, $fe, $fe, $fe, $fe, $1e, $22, $08, $24, $08, $1a, $26
    db $08, $06, $fe, $02, $30, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $0a, $06, $03, $fe, $fe, $fe, $fe, $fe, $fe, $1a, $10, $1a, $26, $08
    db $1a, $06, $1c, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff

    ; padding
    ds $140, $00

; I: 234 records of 32 bytes (5-byte header + tile numbers, $FF/$FE = blank): ScrollEngine_Sub1_FetchRow loads bank
; $29 and addresses $4000 + row*32 (ScrollEngine_RowToOffset). L3 pass 2026-10-26: read in BGB in 2 replay(s) of the
; organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Credits_ScrollRowTbl::
    db $00
    db $00

    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00

    ; padding
    ds $2c0, $00

; I: entry 0 of the {lo,hi,bank} table 05:62A3, 89 bytes each (constant pitch)
Map_29_6000_Map05_6257::
    INCBIN "data/bank_29/Map_29_6000_Map05_6257.tilemap" ; $6000, 89 bytes
; I: entry 1 of the {lo,hi,bank} table 05:62A3, 89 bytes each (constant pitch)
Map_29_6059_Map05_6257::
    INCBIN "data/bank_29/Map_29_6059_Map05_6257.tilemap" ; $6059, 89 bytes
; I: entry 4 of the {lo,hi,bank} table 05:62A3, 89 bytes each (constant pitch)
Map_29_60B2_Map05_6257::
    INCBIN "data/bank_29/Map_29_60B2_Map05_6257.tilemap" ; $60B2, 89 bytes
; I: entry 3 of the {lo,hi,bank} table 05:62A3, 89 bytes each (constant pitch)
Map_29_610B_Map05_6257::
    INCBIN "data/bank_29/Map_29_610B_Map05_6257.tilemap" ; $610B, 89 bytes
; I: entry 2 of the {lo,hi,bank} table 05:62A3, 89 bytes each (constant pitch)
Map_29_6164_Map05_6257::
    db $c0, $c0, $c0, $c0, $80, $c0, $80, $c0
    db $c0, $80, $c0, $80, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $01, $02, $00, $07
    db $02, $07, $00, $07, $06, $03, $06, $03
    db $02, $03, $07, $03, $a1, $fe, $3e, $c1
    db $63, $80, $c0, $00, $e8, $80, $41, $80
    db $e1, $82, $38, $c7, $0e, $f8, $ac, $50
    db $c6, $38, $40, $30, $e8, $00, $84, $40
    db $14

    db $e8, $f3, $7c, $80, $7f, $72, $0d, $1c, $23, $0d, $10, $2e, $00, $00, $04, $5a
    db $24, $d2, $7d, $bc, $ff, $a8, $57, $6e, $83, $08, $07, $8a, $07, $19, $07, $23
    db $1f, $1d, $07, $c0, $80, $80, $80, $80, $80, $40, $c0, $c0, $c0, $40, $c0, $c0
    db $c0, $80, $c0

    ; padding
    ds $20, $00

    db $07, $07, $07, $07, $0f, $03, $05, $03, $00, $03, $03, $01, $01, $03, $01, $01
    db $89, $fe, $42, $fd, $e6, $fb, $67, $ff, $af, $ff, $46, $ff, $2a, $ff, $5c, $f7
    db $79, $fe, $7c, $ff, $fa, $ff, $43, $fc, $87, $f8, $78, $80, $aa, $00, $02, $00
    db $f9, $fe, $fa, $fd, $f8, $ff, $91, $7f, $0f, $ff, $77, $0f, $2e, $07, $00, $07
    db $77, $8f, $a7, $5f, $2f, $ff, $b7, $7f, $ef, $ff, $cf, $ff, $8f, $ff, $17, $ff
    db $c0, $80, $c0, $80, $80, $80, $00, $80, $80, $80

    ; padding
    ds $27, $00

    db $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $eb
    db $fe, $50, $ff, $b8, $ff, $50, $ff, $7a, $ff, $76, $7d, $78, $3f, $1c, $3f, $01
    db $fa, $08, $77, $04, $bb, $17, $c0, $18, $e0, $8d, $70, $28, $ff, $27, $df, $5e
    db $ab, $50, $ff, $2a, $f7, $d6, $0d, $a8, $1f, $80, $7f, $20, $ff, $41, $ff, $3f
    db $fe, $1e, $fe, $3c, $fe, $fc, $7c, $fc, $fc, $dc, $f8, $f8, $f0, $f0, $e0

    ; padding
    ds $40, $00

    db $0e, $1f, $0f, $0f, $0f, $07, $07, $03, $03, $03, $01, $01, $00, $00, $00, $00
    db $92, $ef, $0a, $f5, $a5, $fa, $5e, $f1, $ff, $f8, $d2, $fd, $ff, $ff, $5f, $3f
    db $8b, $ff, $89, $77, $23, $ff, $d6, $7f, $be, $fe, $7c, $fc, $f0, $f8, $30, $c0
    db $c0, $e0, $80, $c0, $00, $80

    ; padding
    ds $4e, $00

    db $03, $03, $0f, $07, $0f, $1f, $1f, $3f, $7f, $7f, $7f, $ff, $1a, $0f, $ff, $7f
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $80, $e0, $f4, $f8
    db $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00
    db $00, $00, $40, $80, $c0, $e0, $e0, $f0, $f8, $f8, $f8, $fc

    ; padding
    ds $30, $00

    db $01, $00, $01, $01, $01, $03, $03, $03, $03, $03, $07, $03, $03, $03, $07, $03
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fd, $ff, $fe, $ff, $d0, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fb, $ff, $3f, $c0, $ea, $00, $f5, $00
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $8f, $ff, $65, $1f, $f0, $0f, $68, $17
    db $fe, $fc, $fc, $fe, $fe, $fe, $fe, $ff, $fe, $ff, $ff, $ff, $bf, $ff, $1f, $ff
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80

    ; padding
    ds $23, $00

    db $07, $03, $03, $07, $07, $03, $07, $03, $07, $03, $07, $03, $03, $03, $03, $03
    db $e8, $ff, $d4, $ff, $a2, $ff, $d0, $ff, $e1, $fe, $ca, $f5, $8f, $ff, $12, $fd
    db $6a, $80, $f5, $00, $6a, $80, $c0, $00, $7c, $82, $2c, $d3, $e2, $f9, $0d, $f0
    db $f0, $0f, $5a, $05, $bd, $02, $5f, $00, $ab, $00, $3f, $40, $38, $ff, $15, $f8
    db $3f, $ff, $1f, $ff, $3f, $ff, $9f, $7f, $cf, $3f, $67, $1f, $4b, $bf, $83, $7f
    db $00, $80, $80, $00, $00, $80, $80, $00, $00, $80, $80, $00, $00, $80, $80

    ; padding
    ds $21, $00

    db $01, $03, $00, $01, $02, $03, $02, $03, $00, $03, $03, $01, $02, $01, $00, $01
    db $27, $f8, $cb, $74, $0b, $fe, $9b, $7d, $b8, $ff, $02, $fd, $5f, $a0, $91, $40
    db $0f, $f8, $c1, $7c, $6c, $b8, $e4, $18, $40, $f8, $e4, $10, $fe, $00, $4c, $10
    db $87, $f8, $4a, $f5, $5b, $f6, $c8, $77, $93, $6c, $7f, $00, $0a, $20, $20, $10
    db $29, $ff, $43, $fd, $e1, $ff, $49, $f7, $7c, $83, $07, $01, $0c, $03, $19, $07
    db $c0, $00, $80, $40, $80, $c0, $00, $c0, $40, $80, $40, $80, $c0, $80, $00, $80

    ; padding
    ds $20, $00

    db $02, $01, $00, $01, $00, $01, $01, $01, $02, $01, $01, $00, $00, $00, $00, $00
    db $2a, $c0, $34, $c0, $1a, $e0, $c0, $70, $a6, $f8, $4b, $f4, $25, $fa, $13, $7c
    db $b4, $08, $00, $10, $18, $20, $00, $04, $fb, $0c, $72, $1d, $c1, $3e, $60, $1f
    db $38, $00, $18, $00, $24, $08, $5c, $20, $8a, $78, $1d, $f0, $3b, $e0, $cf, $70
    db $02, $0f, $15, $0f, $3b, $0f, $65, $1f, $cf, $3f, $35, $5f, $ef, $3f, $94, $7f
    db $80, $80, $40, $80, $00, $80, $80, $00, $80

    ; padding
    ds $37, $00

    db $e9, $7e, $50, $7f, $6a, $3f, $04, $3f, $0e, $3f, $15, $1f, $1a, $0f, $01, $0f
    db $0b, $fe, $c3, $7c, $e5, $fa, $4b, $f4, $af, $f0, $0c, $f0, $a7, $f8, $07, $ff
    db $e4, $7b, $a5, $5f, $c3, $3f, $ed, $17, $f2, $0f, $14, $0f, $c8, $3f, $f0, $ff
    db $3f, $fe, $1e, $fe, $be, $fe, $94, $fe, $be, $fc, $50, $fc, $fc, $f8, $78, $f8

    ; padding
    ds $40, $00

    db $0e, $07, $07, $03, $01, $03, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00
    db $c2, $ff, $40, $ff, $aa, $ff, $f7, $ff, $7f, $ff, $75, $3f, $3f, $1f, $01, $07
    db $aa, $ff, $15, $ff, $3b, $ff, $5f, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $cc, $f0
    db $f8, $f8, $70, $f0, $f0, $e0, $e0, $c0, $c0, $80, $00, $80

    ; padding
    ds $48, $00

    db $01, $00, $07, $03, $0f, $0f, $1f, $1f, $3f, $3f, $7f, $7f, $0c, $03, $5f, $3f
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $60, $80, $f4, $f8
    db $ff, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00
    db $00, $00, $40, $80, $c0, $e0, $e0, $f0, $f0, $f8, $fc, $f8

    ; padding
    ds $32, $00

    db $01, $00, $00, $01, $01, $01, $03, $01, $03, $01, $01, $03, $01, $03, $ff, $ff
    db $ff, $ff, $fe, $ff, $f5, $fe, $e9, $fe, $c2, $fd, $e1, $fe, $ca, $f5, $ff, $ff
    db $c4, $fb, $7a, $80, $51, $00, $fa, $00, $d5, $00, $aa, $00, $54, $00, $ff, $ff
    db $cf, $3f, $b3, $0f, $5a, $05, $f0, $0f, $5e, $01, $bc, $03, $16, $01, $fc, $fc
    db $fe, $fc, $fe, $fe, $7f, $fe, $ff, $fe, $7e, $ff, $3f, $ff, $ff, $7f

    ; padding
    ds $30, $00

    db $03, $03, $01, $03, $03, $03, $01, $03, $01, $03, $03, $01, $02, $01, $00, $01
    db $e1, $fe, $c2, $fd, $95, $ea, $a5, $df, $89, $ff, $87, $7f, $ce, $7b, $9c, $73
    db $a2, $00, $f4, $00, $fc, $02, $36, $d3, $f7, $fb, $d1, $fb, $f3, $79, $18, $71
    db $ff, $00, $55, $00, $b5, $0a, $7e, $f1, $f5, $fa, $5d, $ef, $a4, $cd, $f4, $cd
    db $3f, $ff, $9f, $7f, $df, $3f, $8f, $7f, $af, $ff, $4e, $f7, $a2, $ff, $ca, $f7

    ; padding
    ds $31, $00

    db $01, $00, $01, $00, $03, $01, $01, $02, $01, $01, $01, $00, $01, $01, $01, $ba
    db $ff, $45, $fe, $15, $ea, $f7, $00, $6a, $80, $34, $c0, $9a, $e0, $09, $f0, $38
    db $e0, $98, $60, $18, $e0, $70, $00, $a8, $40, $d0, $00, $41, $b8, $f3, $7d, $11
    db $ee, $9b, $44, $ea, $00, $60, $00, $b8, $00, $c8, $10, $82, $f8, $3d, $f0, $13
    db $ee, $5e, $07, $33, $0f, $1a, $07, $b3, $0e, $64, $1f, $ca, $3f, $95, $7f, $00
    db $80, $00, $80, $00, $80, $80, $00, $80, $00, $00, $00, $80, $00, $80

    ; padding
    ds $21, $00

    db $01, $01, $00, $01, $01, $01, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00
    db $b7, $e8, $4f, $f0, $e5, $fa, $52, $fd, $e8, $ff, $57, $fd, $f9, $7f, $51, $7f
    db $78, $ff, $df, $7d, $38, $ff, $4f, $f0, $d7, $e8, $30, $c0, $a2, $c0, $c5, $90
    db $ef, $f0, $d7, $e0, $b4, $eb, $62, $1d, $4c, $bf, $84, $1f, $ca, $3f, $ae, $53
    db $2e, $ff, $9e, $7f, $3f, $fe, $5e, $fe, $be, $fe, $5c, $fe, $3e, $fc, $74, $fc
    db $80, $00, $80

    ; padding
    ds $3d, $00

    db $3a, $7f, $7d, $3f, $3a, $3f, $34, $1f, $1e, $1f, $14, $0f, $06, $0f, $04, $07
    db $fe, $80, $9d, $40, $5d, $a2, $67, $90, $03, $d8, $68, $c0, $3a, $e0, $0c, $f0
    db $f2, $0f, $7c, $03, $fe, $03, $f6, $05, $a8, $07, $52, $0d, $28, $1f, $50, $3f
    db $f8, $fc, $78, $fc, $f8, $f8, $78, $f8, $f8, $f8, $50, $f8, $f8, $f0, $f0, $f0

    ; padding
    ds $40, $00

    db $02, $07, $07, $03, $01, $03, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00
    db $8a, $ff, $07, $ff, $a2, $ff, $d0, $ff, $e9, $fe, $7c, $7f, $3f, $3f, $17, $0f
    db $ea, $ff, $51, $ff, $23, $ff, $87, $7f, $3e, $fe, $5e, $fc, $fc, $f8, $d0, $e0
    db $e0, $e0, $c0, $c0, $80, $80

    ; padding
    ds $4e, $00

    db $02, $01, $03, $07, $1f, $0f, $3f, $1f, $7f, $3f, $7f, $7f, $0a, $07, $5f, $3f
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $a8, $c0, $f8, $fc
    db $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00
    db $80, $00, $80, $c0, $f0, $e0, $f0, $f0, $f8, $f8, $fc, $fc

    ; padding
    ds $33, $00

    db $01, $01, $01, $03, $01, $01, $03, $01, $03, $03, $03, $03, $03, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fc, $ff, $e9, $fe, $c3, $fc, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $eb, $ff, $3e, $c1, $ba, $00, $51, $00, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $9f, $7f, $83, $3f, $5b, $05, $fc, $fe, $fe
    db $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $ff, $00, $00, $00
    db $00, $00, $00, $00, $00, $80, $00, $80, $00, $80, $00, $80

    ; padding
    ds $21, $00

    db $03, $03, $07, $03, $03, $03, $07, $03, $03, $03, $01, $03, $03, $02, $00, $03
    db $a1, $fe, $03, $fc, $a5, $fa, $0f, $f0, $84, $fa, $2b, $d4, $5b, $a0, $93, $7c
    db $aa, $00, $45, $00, $aa, $00, $15, $00, $ae, $00, $04, $00, $aa, $00, $05, $40
    db $f0, $0f, $5a, $05, $bc, $03, $56, $01, $bc, $03, $5f, $00, $eb, $00, $1f, $00
    db $bf, $ff, $bf, $7f, $3f, $ff, $7f, $ff, $3f, $ff, $df, $7f, $2f, $ff, $9f, $7f
    db $00, $80, $80, $00, $80, $00, $00, $00, $80

    ; padding
    ds $27, $00

    db $01, $02, $06, $01, $00, $03, $00, $03, $02, $03, $00, $03, $01, $02, $00, $03
    db $e6, $ff, $17, $ff, $b3, $ee, $6d, $f6, $8a, $ff, $22, $dd, $54, $ab, $f4, $01
    db $09, $e6, $f1, $e7, $aa, $f7, $67, $f3, $e3, $e3, $01, $c1, $22, $c1, $01, $c0
    db $20, $ff, $f2, $fd, $8b, $ff, $85, $db, $b0, $ef, $2a, $d5, $5e, $a0, $80, $00
    db $ae, $ff, $46, $ff, $a7, $fe, $07, $ff, $cf, $ff, $a5, $5e, $f2, $0e, $64, $1f
    db $00, $00, $80, $00, $80, $80, $00, $80, $80, $80, $00, $80, $80

    ; padding
    ds $23, $00

    db $02, $03, $00, $03, $06, $03, $01, $03, $01, $03, $03, $01, $01, $03, $03, $01
    db $6a, $81, $35, $c0, $9b, $e0, $2e, $d1, $e1, $fe, $4a, $f5, $e6, $f9, $4e, $f1
    db $80, $00, $40, $00, $62, $00, $92, $61, $f2, $ef, $45, $ff, $f3, $ff, $7f, $f7
    db $c0, $00, $01, $40, $6d, $22, $b4, $43, $b4, $cb, $18, $c7, $f0, $8f, $78, $87
    db $8e, $7f, $95, $7e, $3d, $fe, $16, $fd, $fe, $fc, $fc, $fc, $f8, $fc, $7c, $f8

    ; padding
    ds $30, $00

    db $01, $01, $01, $01, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $c6, $fb, $4b, $f7, $e7, $ff, $e5, $ff, $ea, $ff, $d1, $7e, $7a, $7f, $30, $7f
    db $e3, $ff, $08, $f7, $80, $ff, $49, $00, $00, $80, $41, $00, $aa, $00, $16, $c1
    db $80, $ff, $10, $ff, $38, $ff, $d9, $7f, $af, $7f, $15, $6f, $3f, $ef, $47, $ff
    db $f8, $f8, $70, $f8, $f8, $f0, $d0, $f0, $e0, $f0, $c0, $e0, $e0, $c0, $c0, $80

    ; padding
    ds $40, $00

    db $3a, $3f, $1d, $1f, $0a, $1f, $04, $0f, $02, $07, $01, $03, $00, $01, $00, $00
    db $eb, $ff, $7f, $ff, $80, $ff, $2a, $d5, $d4, $eb, $c9, $f7, $ff, $ff, $1c, $7f
    db $af, $ff, $6f, $df, $8f, $fe, $5e, $be, $bc, $fc, $78, $f0, $c0, $e0, $80, $00
    db $80, $80

    ; padding
    ds $5d, $00

    db $c0, $00, $00, $00, $00, $00, $01, $00, $01, $02, $02, $02, $04, $08, $04, $00
    db $08, $00, $00, $00, $00, $80, $80, $80, $40, $00, $60, $10, $20, $00, $10, $18
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $03, $07, $09, $1a, $50
    db $22

    ; padding
    ds $3a, $00

    db $0c, $30, $16, $3b, $00, $08, $c8, $b0, $8e, $44, $00, $43, $41, $20, $30, $20
    db $00, $10, $30, $d8, $70, $18, $10, $08, $10, $10, $10, $20, $00, $e0, $20, $60
    db $00, $00, $00, $00, $00, $00, $08, $08, $01, $05, $06, $06, $04, $00, $00, $00
    db $00, $00, $00, $00, $14, $0f, $82, $c4, $08, $04, $08, $08, $18, $00, $18, $10
    db $30, $1f, $00, $00, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $20, $00
    db $10, $f0, $30, $20, $20, $40

    ; padding
    ds $20, $00

    db $02, $04, $02, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $0c, $03, $17, $0f, $7f, $bf, $7c, $ff, $7b, $ff, $5f, $7f, $3f, $7f, $7f, $ff
    db $eb, $f0, $ff, $ff, $ff, $ff, $77, $8f, $e1, $f8, $ff, $ff, $ff, $ff, $97, $0f
    db $7f, $ff, $ff, $ff, $e5, $fb, $84, $1f, $ff, $ff, $ff, $ff, $ff, $ff, $41, $f7
    db $d0, $e0, $ff, $fd, $fe, $ff, $9f, $7e, $d6, $ee, $fc, $f8, $fe, $fe, $fe, $fc
    db $c0, $80

    ; padding
    ds $3c, $00

    db $06, $01, $ff, $7c, $7c, $73, $60, $8c, $90, $08, $01, $98, $89, $10, $00, $98
    db $80, $08, $59, $a0, $15, $09, $02, $07, $03, $02, $c1, $e2, $c0, $e3, $23, $c3
    db $00, $03, $80, $80, $00, $00, $00, $00, $10, $0c, $0c, $1e, $04, $0c, $00, $00
    db $00, $80, $fc, $bc, $54, $4c, $06, $62, $00, $22, $22, $22, $01, $22, $21, $23
    db $20, $43, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $00, $48, $b0
    db $00, $08

    ; padding
    ds $20, $00

    db $0e, $09, $10, $11, $33, $26, $01, $24, $0e, $21, $03, $20, $22, $21, $31, $00
    db $08, $84, $83, $00, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $00
    db $06, $0c, $88, $70, $20, $60, $40, $40, $00, $c0, $40, $80, $80, $80, $80, $40
    db $00, $e0, $2a, $15, $00, $00, $00, $00, $08, $04, $06, $00, $02, $02, $00, $06
    db $83, $c0, $81, $01, $00, $01, $00, $00, $00, $00, $00, $00, $01, $00, $01, $00
    db $c8, $a4, $84, $14, $10, $c6, $42, $24, $22, $24, $04, $64, $0c, $c8, $38, $10

    ; padding
    ds $20, $00

    db $08, $10, $00, $0d, $05, $03, $00, $01, $01, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $40, $30, $c0, $2e, $82, $21, $10, $a0, $08, $90, $c4, $88, $05, $42
    db $40, $40, $50, $20, $08, $1f, $47, $80, $88, $7f, $00, $00, $00, $00, $00, $00
    db $0c, $04, $0c, $18, $b1, $e0, $1b, $07, $a4, $f8, $00, $00, $00, $00, $00, $00
    db $0a, $1b, $20, $7e, $e0, $ce, $04, $0a, $0a, $1a, $14, $12, $20, $26, $e4, $44
    db $00, $e0

    ; padding
    ds $3e, $00

    db $20, $41, $00, $20, $30, $10, $00, $18, $00, $0c, $05, $02, $02, $01, $00, $00
    db $40, $80, $0c, $70, $0c, $03, $00, $00, $00, $00, $00, $00, $50, $a0, $60, $1f
    db $01, $03, $6d, $1e, $50, $a0, $00, $00, $00, $00, $00, $01, $13, $0e, $08, $f0
    db $88, $8c, $18, $08, $30, $10, $30, $20, $e0, $40, $40, $80

    ; padding
    ds $4c, $00

    db $10, $30, $30, $18, $10, $2c, $22, $14, $06, $04, $0c, $06, $0a, $0a, $12, $09
    db $09, $11, $00, $11, $30, $00, $20, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $80, $00, $81, $81, $41, $82, $00, $00, $00, $00, $20, $10, $70, $30
    db $d0, $60, $a0, $80, $a0, $20, $40, $20, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $40, $c0

    ; padding
    ds $22, $00

    db $10, $18, $08, $1e, $01, $0b, $00, $0c, $04, $04, $06, $02, $03, $02, $23, $12
    db $11, $11, $10, $10, $10, $10, $88, $d0, $18, $70, $18, $18, $08, $00, $20, $20
    db $00, $20, $a0, $c0, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $46
    db $48, $44, $48, $28, $30, $30, $00, $30, $10, $10, $00, $00, $00, $00, $62, $01
    db $00, $46, $0c, $48, $10, $50, $e1, $60, $41, $c1, $82, $01, $03, $00, $00, $c0
    db $80, $40, $80, $80, $00, $80, $80

    ; padding
    ds $27, $00

    db $02, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $b8, $10, $bc, $be, $3f, $df, $47, $4f, $70, $61, $78, $fe, $ff, $7f
    db $07, $0f, $1f, $1f, $3f, $3f, $ff, $ff, $ff, $ff, $fc, $fc, $3e, $7c, $ff, $ff
    db $80, $80, $c0, $e0, $f0, $f0, $fb, $f1, $ff, $ff, $ff, $ff, $f9, $fe, $fa, $f1
    db $02, $02, $04, $02, $3a, $3c, $fc, $fc, $f8, $fc, $c6, $fe, $ff, $3e, $fe, $ff

    ; padding
    ds $40, $00

    db $1f, $7f, $05, $43, $80, $43, $c0, $04, $8c, $88, $00, $88, $80, $88, $00, $88
    db $ff, $ff, $ff, $ff, $cf, $3f, $02, $05, $02, $03, $60, $c3, $e1, $e2, $40, $03
    db $ff, $ff, $ff, $ff, $fa, $ff, $00, $81, $00, $00, $0c, $18, $1c, $1c, $18, $0c
    db $f8, $fe, $f0, $c2, $01, $02, $80, $01, $00, $c1, $01, $41, $40, $21, $21, $41
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $20, $00, $08, $f0

    ; padding
    ds $18, $00

    db $01, $00, $00, $01, $00, $01, $01, $00, $0c, $00, $05, $33, $e1, $40, $60, $9c
    db $8e, $ae, $9a, $10, $20, $90, $a0, $10, $84, $88, $02, $84, $82, $81, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $06, $03, $0d, $04, $40, $b8, $00, $30
    db $20, $20, $60, $00, $40, $20, $60, $00, $00, $00, $00, $80, $9d, $63, $14, $00
    db $00, $00, $00, $00, $00, $00, $00, $04, $41, $41, $00, $c1, $80, $00, $01, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $80, $0c, $02, $64, $82, $92, $59, $82
    db $e9, $22, $01, $12, $02, $12, $00, $12

    ; padding
    ds $20, $00

    db $a4, $90, $91, $4c, $33, $21, $19, $07, $00, $01, $01, $01, $00, $01, $01, $00
    db $00, $00, $00, $00, $06, $03, $00, $1c, $30, $20, $40, $00, $00, $80, $00, $80
    db $20, $20, $60, $30, $60, $98, $00, $07, $00, $00, $00, $00, $00, $00, $00, $00
    db $04, $08, $1c, $08, $2e, $33, $00, $c0, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $01, $81, $01, $81, $41, $30, $21, $00, $11, $00, $03, $01, $02
    db $66, $a4, $00, $0c, $68, $b0, $40

    ; padding
    ds $39, $00

    db $80, $80, $c0, $40, $00, $60, $10, $20, $00, $18, $04, $0c, $06, $03, $01, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $00, $90, $7f
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $1e, $0f, $4c, $f0
    db $02, $02, $02, $04, $0c, $04, $08, $08, $38, $10, $c0, $60, $00, $80

    ; padding
    ds $3e, $00

    db $08, $00, $0a, $0c

    ; padding
    ds $14, $00

    db $02, $06, $00, $09, $09, $10, $10, $20, $20, $40, $c0, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $80, $00, $80, $80, $40, $20, $40, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $02, $03, $12, $0c, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $40, $80, $c0, $00, $80

    ; padding
    ds $20, $00

    db $02, $0d, $00, $04, $02, $02, $00, $01, $01, $00, $00, $00, $00, $00, $7e, $01
    db $41, $80, $10, $61, $02, $0e, $00, $00, $80, $80, $00, $c0, $20, $40, $a0, $60
    db $00, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $20, $20, $21, $10, $0f, $12, $00, $0c, $00, $00, $00, $00, $00, $00, $00, $00
    db $68, $31, $02, $c1, $02, $02, $04, $04, $04, $08, $10, $08, $04, $1b, $00, $00
    db $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $56, $ae, $08, $04

    ; padding
    ds $20, $00

    db $b8, $c0, $00, $40, $00, $30, $14, $08, $02, $06, $01, $01, $00, $00, $00, $00
    db $2c, $03, $ff, $7f, $7f, $ff, $77, $7f, $0a, $00, $7f, $ff, $ff, $ff, $ff, $7f
    db $a8, $ff, $ff, $ff, $ff, $ff, $7f, $ff, $f5, $0a, $ff, $ff, $ff, $ff, $ff, $ff
    db $68, $80, $ff, $ff, $ff, $ff, $ff, $ff, $17, $e8, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $e0, $c0, $e0, $e0, $e2, $e1, $48, $a6, $f0, $f8, $f0, $f0, $f0, $f0
    db $00, $18, $50, $20, $c0, $80

    ; padding
    ds $32, $00

    db $01, $00, $01, $00, $01, $00, $00, $01, $46, $ff, $08, $84, $08, $88, $88, $10
    db $10, $88, $80, $08, $00, $8c, $87, $00, $5f, $bb, $08, $06, $04, $06, $c6, $84
    db $c4, $86, $04, $06, $08, $09, $d0, $30, $6e, $82, $00, $01, $00, $01, $01, $30
    db $30, $00, $00, $01, $03, $01, $b0, $46, $10, $08, $00, $08, $80, $08, $80, $08
    db $00, $88, $8c, $00, $00, $0c, $04, $07, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $a0, $40

    ; padding
    ds $20, $00

    db $19, $0f, $00, $11, $2d, $20, $2d, $53, $19, $66, $00, $48, $00, $48, $0c, $40
    db $00, $80, $80, $00, $00, $80, $80, $00, $00, $80, $00, $00, $00, $00, $00, $00
    db $e0, $60, $40, $40, $00, $80, $00, $80, $80, $80, $40, $80, $00, $40, $50, $20
    db $24, $18, $00, $00, $00, $00, $00, $00, $00, $18, $08, $10, $30, $10, $00, $60
    db $0c, $04, $04, $04, $08, $07, $04, $06, $04, $07, $00, $04, $00, $00, $00, $00
    db $00, $30, $08, $10, $a8, $48, $00, $28, $a0, $08, $00, $88, $c8, $08, $00, $48

    ; padding
    ds $20, $00

    db $64, $22, $10, $20, $09, $18, $01, $07, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $80, $00, $80, $00, $00, $80, $00, $80, $00, $80, $80, $40
    db $1f, $0f, $08, $05, $00, $09, $00, $09, $08, $09, $00, $09, $08, $09, $01, $09
    db $c0, $80

    ; padding
    ds $10, $00

    db $02, $05, $00, $00, $10, $00, $08, $1f, $10, $10, $10, $10, $20, $10, $80, $98
    db $b0, $10, $20, $20, $c0, $40, $00, $80

    ; padding
    ds $36, $00

    db $40, $40, $40, $20, $30, $20, $00, $18, $0c, $0c, $04, $03, $00, $00, $00, $00
    db $09, $09, $01, $09, $02, $09, $01, $06, $04, $02, $00, $00, $68, $f0, $21, $1f
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $03, $2a, $1c, $50, $e0
    db $20, $20, $40, $20, $60, $40, $00, $c0, $80, $80

    ; padding
    ds $44, $00

    db $04, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $b0, $40, $00, $00, $00, $00, $00, $00, $00, $07, $18, $08, $30, $10, $60, $20
    db $40, $40, $00, $00, $00, $00, $80, $00, $a0, $40, $10, $20, $10, $10, $00, $18
    db $00, $09, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $64, $3a
    db $c0, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $80

    ; padding
    ds $20, $00

    db $1a, $0c, $14, $38, $22, $01, $00, $00, $00, $00, $05, $03, $0a, $0c, $10, $10
    db $00, $0e, $02, $01, $80, $00, $80, $40, $a0, $60, $10, $f0, $00, $00, $00, $00
    db $80, $40, $00, $c0, $c0, $80, $40, $00, $00, $00, $00, $00, $00, $00, $04, $03
    db $0e, $0e, $04, $0c, $04, $08, $0c, $00, $00, $00, $00, $00, $00, $00, $00, $c0
    db $01, $02, $0c, $04, $18, $08, $10, $10, $7a, $3f, $c0, $00, $00, $00, $00, $00
    db $80, $80, $00, $00, $00, $00, $00, $00, $80, $00, $00, $c0, $60, $20, $30, $10

    ; padding
    ds $20, $00

    db $20, $20, $60, $40, $a4, $5b, $41, $e0, $80, $c0, $80, $80, $00, $00, $00, $00
    db $00, $00, $00, $00, $80, $00, $41, $80, $6b, $47, $3f, $7f, $3f, $7e, $3f, $01
    db $07, $0f, $0f, $1f, $3d, $3e, $7d, $fb, $f7, $e7, $9f, $cf, $7f, $3f, $ff, $ff
    db $e0, $e0, $f8, $f0, $be, $7c, $1f, $ff, $ff, $ef, $ff, $f7, $fa, $fd, $fe, $ff
    db $00, $00, $00, $00, $00, $00, $9b, $04, $f8, $f0, $f0, $f8, $f8, $f8, $a8, $50
    db $00, $18, $08, $08, $8c, $00, $ec, $14, $04, $0c

    ; padding
    ds $36, $00

    db $4f, $3f, $ff, $7f, $ff, $7f, $73, $7f, $62, $02, $02, $44, $02, $44, $03, $44
    db $fc, $fe, $f0, $f8, $90, $ec, $00, $06, $01, $03, $01, $01, $c2, $3d, $41, $01
    db $7f, $3f, $3f, $1f, $a7, $43, $01, $80, $80, $00, $00, $00, $c0, $3f, $01, $00
    db $f8, $fc, $fe, $fc, $fe, $fe, $fc, $fe, $c1, $42, $40, $41, $40, $e1, $40, $41
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80

    ; padding
    ds $2b, $00

    db $01, $00, $02, $04, $00, $08, $04, $c2, $81, $42, $40, $81, $c0, $00, $40, $80
    db $40, $80, $00, $c0, $00, $40, $01, $01, $03, $01, $e0, $86, $74, $18, $10, $10
    db $10, $20, $20, $20, $00, $20, $00, $80, $40, $80, $36, $63, $18, $04, $00, $00
    db $00, $00, $00, $00, $00, $00, $41, $40, $01, $c0, $81, $00, $00, $00, $00, $00
    db $01, $00, $01, $00, $00, $00, $00, $80, $00, $80, $a0, $b8, $e0, $c4, $82, $82
    db $2a, $91, $81, $ed, $70, $c5

    ; padding
    ds $20, $00

    db $11, $0a, $02, $15, $02, $11, $10, $12, $0a, $12, $19, $02, $09, $08, $02, $04
    db $40, $c0, $c0, $80, $00, $00, $00, $00, $00, $01, $01, $02, $82, $04, $c4, $40
    db $20, $20, $10, $20, $08, $10, $8a, $05, $01, $e0, $01, $30, $19, $0b, $00, $06
    db $00, $0c, $00, $0c, $08, $18, $a0, $50, $40, $e0, $e1, $90, $0f, $09, $00, $06
    db $00, $00, $00, $00, $00, $00, $00, $00, $e0, $60, $f0, $90, $81, $18, $04, $09
    db $00, $19, $04, $09, $04, $09, $41, $09, $00, $7b, $04, $02, $8a, $fc, $30, $80
    db $80, $00, $80, $00, $80

    ; padding
    ds $1c, $00

    db $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40
    db $a0, $00, $20, $00, $30, $08, $10, $0c, $08, $06, $04, $01, $03, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $e0, $80, $97, $7f, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $03, $03, $fc, $08
    db $05, $01, $01, $03, $02, $06, $04, $1c, $08, $50, $30, $a0, $c0, $00, $00, $80

    ; padding
    ds $1f, $00

    db $09, $8f

    ; padding
    ds $12, $00

    db $55, $55, $55, $55, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $00, $00, $00
    db $ff, $ff, $ff, $ff, $09

    ; padding
    ds $12, $00

    db $55, $55, $55, $55, $ff, $8f, $5f

    ; padding
    ds $10, $00

    db $55, $55, $55, $55, $00, $00, $78, $15, $8f, $09, $00, $11, $1d, $01, $19, $00
    db $00, $1b, $00, $00, $06, $0b, $0f, $12, $17, $1b, $1e, $55, $55, $55, $55, $00
    db $11, $22, $33, $44, $55, $66, $77, $88, $99, $a4, $bb, $cc, $4d, $e4, $ff, $27
    db $04, $81, $01, $0d, $0b, $14, $01, $14, $16, $0d, $01, $0b, $0d, $08, $01, $12
    db $17, $1b, $55, $55, $55, $55, $ff, $8f, $4f, $16, $24, $23, $16, $0a, $22, $14
    db $0a, $24, $23, $16, $00, $0a, $16, $25, $24, $55, $55, $55, $55, $2b, $4b, $78
    db $20, $ef, $00, $00, $22, $00, $1b, $00, $1d, $00, $22, $00, $22, $00, $1b, $00
    db $1d, $00, $20, $00, $55, $55, $55, $55, $00, $00, $ff, $ff, $00, $00, $ff, $ff
    db $00, $00, $ff, $ff, $00, $00, $ff, $ff, $27, $8f, $00, $20, $1d, $00, $00, $19
    db $1b, $00, $00, $22, $1d, $00, $00, $19, $1b, $00, $00, $55, $55, $55, $55, $ff
    db $8f, $5f, $0e, $00, $08, $00, $08, $00, $1f, $00, $1d, $1a, $00, $13, $1e, $1a
    db $00, $00, $55, $55, $55, $55, $a8, $00, $3c, $17, $8f, $a5, $08, $01, $00, $01
    db $01, $20, $00, $00, $00, $06, $00, $00, $00, $0d, $00, $00, $00, $55, $55, $55
    db $55, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $ff, $ff, $ff
    db $ff, $19, $94, $00, $0d, $00, $0d, $0d, $0d, $00, $08, $00, $0b, $00, $0b, $00
    db $0d, $00, $00, $00, $55, $55, $55, $55, $ff, $8f, $8f, $00, $00, $20, $00, $00
    db $08, $1d, $00, $00, $00, $05, $00, $03, $00, $00, $00, $55, $55, $55, $55, $04
    db $28, $3c, $27, $af, $00, $00, $01, $04, $00, $13, $00, $00, $07, $00, $00, $00
    db $00, $19, $00, $21, $00, $00, $55, $55, $55, $55, $00, $00, $00, $00, $ff, $ff
    db $ff, $ff, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $17, $1c, $0d, $03, $1c, $00
    db $00, $15, $00, $00, $00, $00, $1d, $00, $00, $23, $00, $04, $00, $55, $55, $55
    db $55, $ff, $8d, $2f, $09, $20, $00, $23, $00, $21, $00, $23, $12, $1c, $11, $23
    db $20, $00, $23, $25, $55, $55, $55, $55, $44, $a8, $78

    ; padding
    ds $243, $00
