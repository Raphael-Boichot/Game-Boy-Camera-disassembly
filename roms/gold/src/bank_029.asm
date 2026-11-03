; Game Boy Camera Gold (USA), bank $29. Written by tools/make_source.py from roms/gold/gbcam_gold.sym and the tables of
; roms/gold/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $029", ROMX[$4000], BANK[$29]

Credits_ScrollRowTbl::
    db $01, $00, $03, $04, $01, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $04, $04, $01, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $03, $00, $00, $fe, $fe, $fe, $fe, $fe, $fe, $0e, $08, $16, $16, $1c, $34, $34, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $05, $00, $00, $fe, $5c, $44, $36, $50, $4a, $fe, $66, $52, $5e, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $06, $00, $00, $ff, $5d, $45, $37, $51, $4b, $ff, $67, $53, $5f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $07, $00, $00, $fe, $fe, $40, $52, $58, $fe, $5e, $5a, $46, $50, $42, $fe, $5c, $44, $3e, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $08, $00, $00, $ff, $ff, $41, $53, $59, $ff, $5f, $5b, $47, $51, $43, $ff, $5d, $45, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $09, $00, $00, $fe, $fe, $fe, $42, $36, $4e, $3e, $fe, $38, $52, $66, $fe, $3a, $36, $4e, $3e, $58, $36, $6a, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0a, $00, $00, $ff, $ff, $ff, $43, $37, $4f, $3f, $ff, $39, $53, $67, $ff, $3b, $37, $4f, $3f, $59, $37, $6b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0b, $00, $00, $fe, $54, $4c, $3e, $36, $5a, $3e, $fe, $5c, $36, $4a, $3e, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0c, $00, $00, $ff, $55, $4d, $3f, $37, $5b, $3f, $ff, $5d, $37, $4b, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0d, $00, $00, $fe, $fe, $42, $52, $52, $3c, $fe, $3a, $36, $58, $3e, $fe, $52, $40, $fe, $46, $5c, $6a, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0e, $00, $00, $ff, $ff, $43, $53, $53, $3d, $ff, $3b, $37, $59, $3f, $ff, $53, $41, $ff, $47, $5d, $6b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0f, $08, $01, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $5c, $44, $3e, $fe, $5a, $5c, $36, $40, $40, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $10, $08, $01, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $5d, $45, $3f, $ff, $5b, $5d, $37, $41, $41, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $02, $00, $00, $fe, $fe, $fe, $26, $0e, $00, $1a, $14, $24, $fe, $26, $1c, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $03, $00, $00, $fe, $fe, $fe, $fe, $08, $2a, $08, $22, $30, $1c, $1a, $08, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $04, $00, $00, $fe, $fe, $fe, $fe, $fe, $10, $1a, $2a, $1c, $16, $2a, $08, $06, $fe, $10, $1a, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $05, $00, $00, $fe, $fe, $fe, $fe, $fe, $fe, $26, $0e, $10, $24, $fe, $1e, $22, $1c, $12, $08, $04, $26, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $07, $00, $00, $fe, $50, $46, $50, $5c, $3e, $50, $3c, $52, $fe, $52, $40, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $08, $00, $00, $ff, $51, $47, $51, $5d, $3f, $51, $3d, $53, $ff, $53, $41, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $00, $00, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $36, $4e, $3e, $58, $46, $3a, $36, $fe, $46, $50, $3a, $6a, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0a, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $37, $4f, $3f, $59, $47, $3b, $37, $ff, $47, $51, $3b, $6b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0c, $00, $00, $fe, $50, $46, $50, $5c, $3e, $50, $3c, $52, $fe, $52, $40, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0d, $00, $00, $ff, $51, $47, $51, $5d, $3f, $51, $3d, $53, $ff, $53, $41, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0e, $06, $02, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $3e, $5e, $58, $52, $54, $3e, $fe, $42, $4e, $38, $44, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0f, $06, $02, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $3f, $5f, $59, $53, $55, $3f, $ff, $43, $4f, $39, $45, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $07, $00, $00, $fe, $50, $46, $50, $5c, $3e, $50, $3c, $52, $fe, $3a, $52, $6a, $6e, $4c, $5c, $3c, $6a, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $08, $00, $00, $ff, $51, $47, $51, $5d, $3f, $51, $3d, $53, $ff, $3b, $53, $6b, $6f, $4d, $5d, $3d, $6b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0a, $00, $00, $fe, $5c, $44, $36, $50, $4a, $fe, $66, $52, $5e, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0b, $00, $00, $ff, $5d, $45, $37, $51, $4b, $ff, $67, $53, $5f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0c, $00, $00, $fe, $fe, $60, $3e, $58, $66, $fe, $4e, $5e, $3a, $44, $fe, $40, $52, $58, $fe, $36, $4c, $4c, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0d, $00, $00, $ff, $ff, $61, $3f, $59, $67, $ff, $4f, $5f, $3b, $45, $ff, $41, $53, $59, $ff, $37, $4d, $4d, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0e, $06, $01, $fe, $fe, $fe, $66, $52, $5e, $58, $fe, $44, $36, $58, $3c, $fe, $62, $52, $58, $4a, $6a, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0f, $06, $01, $ff, $ff, $ff, $67, $53, $5f, $59, $ff, $45, $37, $59, $3d, $ff, $63, $53, $59, $4b, $6b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $03, $02, $01, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $04, $02, $01, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $07, $00, $00, $fe, $fe, $0c, $00, $18, $08, $fe, $02, $1c, $30, $fe, $04, $00, $18, $08, $22, $00, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $08, $06, $01, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $24, $26, $00, $0a, $0a, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $06, $00, $00, $fe, $fe, $fe, $fe, $06, $10, $22, $08, $04, $26, $1c, $22, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $08, $06, $01, $fe, $fe, $44, $46, $58, $52, $4a, $36, $68, $5e, $fe, $5c, $36, $50, $36, $4a, $36, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $09, $06, $01, $ff, $ff, $45, $47, $59, $53, $4b, $37, $69, $5f, $ff, $5d, $37, $51, $37, $4b, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $06, $00, $00, $fe, $fe, $0e, $00, $22, $06, $2c, $00, $22, $08, $fe, $06, $08, $24, $10, $0c, $1a, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $08, $06, $01, $fe, $fe, $4e, $36, $5a, $36, $5c, $52, $fe, $4a, $5e, $62, $36, $44, $36, $58, $36, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $09, $06, $01, $ff, $ff, $4f, $37, $5b, $37, $5d, $53, $ff, $4b, $5f, $63, $37, $45, $37, $59, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $03, $00, $00, $fe, $fe, $fe, $fe, $00, $24, $24, $10, $24, $26, $00, $1a, $26, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $04, $00, $00, $fe, $fe, $fe, $fe, $06, $10, $22, $08, $04, $26, $1c, $22, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $06, $00, $00, $fe, $fe, $58, $66, $5e, $46, $3a, $44, $46, $fe, $50, $36, $4a, $36, $3c, $36, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $07, $00, $00, $ff, $ff, $59, $67, $5f, $47, $3b, $45, $47, $ff, $51, $37, $4b, $37, $3d, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $09, $00, $00, $fe, $fe, $5c, $36, $4a, $36, $5a, $44, $46, $fe, $52, $50, $52, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0a, $00, $00, $ff, $ff, $5d, $37, $4b, $37, $5b, $45, $47, $ff, $53, $51, $53, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $0c, $00, $00, $fe, $fe, $fe, $fe, $04, $1c, $1c, $22, $06, $10, $1a, $00, $26, $1c, $22, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0e, $06, $01, $fe, $fe, $4a, $3e, $50, $5c, $36, $58, $52, $fe, $50, $46, $5a, $44, $46, $4e, $5e, $58, $36, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0f, $06, $01, $ff, $ff, $4b, $3f, $51, $5d, $37, $59, $53, $ff, $51, $47, $5b, $45, $47, $4f, $5f, $59, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $06, $00, $00, $fe, $fe, $18, $00, $10, $1a, $fe, $1e, $22, $1c, $0c, $22, $00, $18, $18, $08, $22, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $08, $06, $01, $fe, $fe, $50, $52, $58, $46, $36, $4a, $46, $fe, $5c, $3e, $58, $36, $4e, $52, $5c, $52, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $09, $06, $01, $ff, $ff, $51, $53, $59, $47, $37, $4b, $47, $ff, $5d, $3f, $59, $37, $4f, $53, $5d, $53, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $03, $00, $00, $fe, $fe, $0c, $22, $00, $1e, $0e, $10, $04, $fe, $06, $08, $24, $10, $0c, $1a, $08, $22, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $05, $00, $00, $fe, $fe, $5a, $44, $46, $50, $48, $46, $fe, $5c, $36, $4a, $36, $4e, $46, $50, $3e, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $ff, $ff, $5b, $45, $47, $51, $49, $47, $ff, $5d, $37, $4b, $37, $4f, $47, $51, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $08, $00, $00, $fe, $fe, $58, $66, $5e, $46, $3a, $44, $46, $fe, $50, $36, $4a, $36, $3c, $36, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $00, $00, $ff, $ff, $59, $67, $5f, $47, $3b, $45, $47, $ff, $51, $37, $4b, $37, $3d, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0b, $06, $02, $fe, $fe, $5c, $36, $4a, $36, $5a, $44, $46, $fe, $52, $50, $52, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0c, $06, $02, $ff, $ff, $5d, $37, $4b, $37, $5b, $45, $47, $ff, $53, $51, $53, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $05, $00, $00, $fe, $fe, $44, $46, $58, $52, $4a, $36, $68, $5e, $fe, $5c, $36, $50, $36, $4a, $36, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $06, $00, $00, $ff, $ff, $45, $47, $59, $53, $4b, $37, $69, $5f, $ff, $5d, $37, $51, $37, $4b, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $08, $06, $01, $fe, $fe, $46, $5a, $5a, $44, $46, $50, $fe, $5a, $44, $46, $4e, $46, $68, $5e, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $09, $06, $01, $ff, $ff, $47, $5b, $5b, $45, $47, $51, $ff, $5b, $45, $47, $4f, $47, $69, $5f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $03, $00, $00, $fe, $fe, $fe, $00, $06, $06, $10, $26, $10, $1c, $1a, $00, $16, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $04, $00, $00, $fe, $fe, $fe, $1e, $22, $1c, $0c, $22, $00, $18, $18, $08, $22, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $fe, $fe, $44, $36, $5c, $36, $52, $fe, $52, $42, $36, $5c, $36, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $07, $00, $00, $ff, $ff, $45, $37, $5d, $37, $53, $ff, $53, $43, $37, $5d, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $06, $02, $fe, $fe, $44, $46, $5c, $52, $5a, $44, $46, $fe, $66, $36, $4e, $36, $42, $36, $4e, $46, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0a, $06, $02, $ff, $ff, $45, $47, $5d, $53, $5b, $45, $47, $ff, $67, $37, $4f, $37, $43, $37, $4f, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $fe, $fe, $5c, $52, $58, $5e, $fe, $52, $3e, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $07, $00, $00, $ff, $ff, $5d, $53, $59, $5f, $ff, $53, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $06, $01, $fe, $fe, $66, $52, $5a, $44, $46, $50, $52, $58, $46, $fe, $4a, $36, $5c, $5a, $5e, $4a, $46, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0a, $06, $01, $ff, $ff, $67, $53, $5b, $45, $47, $51, $53, $59, $47, $ff, $4b, $37, $5d, $5b, $5f, $4b, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $03, $00, $00, $fe, $fe, $fe, $24, $1c, $28, $1a, $06, $fe, $04, $1c, $18, $1e, $1c, $24, $08, $22, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $05, $00, $00, $fe, $fe, $44, $46, $58, $52, $4a, $36, $68, $5e, $fe, $5c, $36, $50, $36, $4a, $36, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $06, $00, $00, $ff, $ff, $45, $47, $59, $53, $4b, $37, $69, $5f, $ff, $5d, $37, $51, $37, $4b, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $08, $00, $00, $fe, $fe, $4e, $46, $50, $36, $4a, $52, $fe, $44, $36, $4e, $36, $50, $52, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $09, $00, $00, $ff, $ff, $4f, $47, $51, $37, $4b, $53, $ff, $45, $37, $4f, $37, $51, $53, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0b, $06, $01, $fe, $fe, $4a, $3e, $50, $5c, $36, $58, $52, $fe, $50, $46, $5a, $44, $46, $4e, $5e, $58, $36, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0c, $06, $01, $ff, $ff, $4b, $3f, $51, $5d, $37, $59, $53, $ff, $51, $47, $5b, $45, $47, $4f, $5f, $59, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $03, $00, $00, $fe, $fe, $fe, $fe, $fe, $fe, $00, $06, $2a, $10, $24, $1c, $22, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $05, $00, $00, $fe, $fe, $54, $44, $46, $4c, $fe, $5a, $36, $50, $3c, $44, $52, $54, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $06, $00, $00, $ff, $ff, $55, $45, $47, $4d, $ff, $5b, $37, $51, $3d, $45, $53, $55, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $08, $06, $01, $fe, $fe, $3e, $58, $46, $3a, $44, $fe, $62, $36, $36, $5a, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $09, $06, $01, $ff, $ff, $3f, $59, $47, $3b, $45, $ff, $63, $37, $37, $5b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $03, $00, $00, $fe, $fe, $fe, $16, $1c, $04, $00, $16, $10, $32, $00, $26, $10, $1c, $1a, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $04, $00, $00, $fe, $fe, $fe, $04, $1c, $1c, $22, $06, $10, $1a, $00, $26, $1c, $22, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $06, $00, $00, $fe, $fe, $66, $5e, $5a, $5e, $4a, $3e, $fe, $3e, $3c, $36, $5a, $36, $62, $36, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $07, $00, $00, $ff, $ff, $67, $5f, $5b, $5f, $4b, $3f, $ff, $3f, $3d, $37, $5b, $37, $63, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $09, $06, $01, $fe, $fe, $44, $46, $58, $52, $66, $5e, $4a, $46, $fe, $5e, $3e, $5a, $5e, $42, $46, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0a, $06, $01, $ff, $ff, $45, $47, $59, $53, $67, $5f, $4b, $47, $ff, $5f, $3f, $5b, $5f, $43, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $03, $00, $00, $fe, $fe, $00, $06, $06, $10, $26, $10, $1c, $1a, $00, $16, $fe, $24, $26, $00, $0a, $0a, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $05, $00, $00, $fe, $fe, $58, $66, $52, $48, $46, $fe, $66, $52, $5a, $44, $46, $5c, $52, $4e, $46, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $06, $00, $00, $ff, $ff, $59, $67, $53, $49, $47, $ff, $67, $53, $5b, $45, $47, $5d, $53, $4f, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $08, $00, $00, $fe, $fe, $4a, $3e, $50, $48, $46, $fe, $66, $36, $4e, $36, $4e, $52, $5c, $52, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $09, $00, $00, $ff, $ff, $4b, $3f, $51, $49, $47, $ff, $67, $37, $4f, $37, $4f, $53, $5d, $53, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0b, $00, $00, $fe, $fe, $66, $52, $5a, $44, $46, $52, $fe, $5a, $36, $4a, $36, $4e, $52, $5c, $52, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0c, $00, $00, $ff, $ff, $67, $53, $5b, $45, $47, $53, $ff, $5b, $37, $4b, $37, $4f, $53, $5d, $53, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0e, $08, $01, $fe, $fe, $50, $52, $58, $46, $4a, $52, $fe, $4e, $36, $46, $5a, $44, $46, $42, $46, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0f, $08, $01, $ff, $ff, $51, $53, $59, $47, $4b, $53, $ff, $4f, $37, $47, $5b, $45, $47, $43, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $03, $00, $00, $fe, $fe, $fe, $fe, $1e, $0e, $1c, $26, $1c, $fe, $18, $1c, $06, $08, $16, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $05, $00, $00, $fe, $fe, $36, $5a, $36, $4a, $52, $fe, $4a, $52, $68, $5e, $4a, $46, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $ff, $ff, $37, $5b, $37, $4b, $53, $ff, $4b, $53, $69, $5f, $4b, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $08, $00, $00, $fe, $fe, $4a, $52, $5c, $36, $fe, $40, $5e, $4a, $5e, $46, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $00, $00, $ff, $ff, $4b, $53, $5d, $37, $ff, $41, $5f, $4b, $5f, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0b, $06, $02, $fe, $fe, $36, $5c, $5a, $5e, $5a, $44, $46, $fe, $4a, $36, $66, $36, $4e, $36, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0c, $06, $02, $ff, $ff, $37, $5d, $5b, $5f, $5b, $45, $47, $ff, $4b, $37, $67, $37, $4f, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $05, $00, $00, $fe, $fe, $58, $52, $50, $50, $66, $fe, $42, $3e, $50, $5a, $46, $3a, $4a, $3e, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $ff, $ff, $59, $53, $51, $51, $67, $ff, $43, $3f, $51, $5b, $47, $3b, $4b, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $08, $06, $02, $fe, $fe, $4e, $36, $58, $4a, $52, $fe, $44, $3e, $46, $50, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $06, $02, $ff, $ff, $4f, $37, $59, $4b, $53, $ff, $45, $3f, $47, $51, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $05, $00, $00, $fe, $fe, $4e, $36, $58, $3a, $5e, $5a, $fe, $4e, $3e, $50, $52, $4c, $3c, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $ff, $ff, $4f, $37, $59, $3b, $5f, $5b, $ff, $4f, $3f, $51, $53, $4d, $3d, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $08, $00, $00, $fe, $fe, $44, $36, $50, $5a, $fe, $4a, $52, $44, $58, $5a, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $00, $00, $ff, $ff, $45, $37, $51, $5b, $ff, $4b, $53, $45, $59, $5b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0b, $06, $01, $fe, $fe, $50, $52, $36, $fe, $40, $36, $3a, $3e, $fe, $4e, $52, $3c, $3e, $4c, $5a, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0c, $06, $01, $ff, $ff, $51, $53, $37, $ff, $41, $37, $3b, $3f, $ff, $4f, $53, $3d, $3f, $4d, $5b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $03, $00, $00, $fe, $fe, $fe, $0e, $00, $22, $06, $2c, $00, $22, $08, $fe, $24, $26, $00, $0a, $0a, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $05, $00, $00, $fe, $fe, $4a, $36, $68, $5e, $52, $fe, $66, $52, $50, $3e, $66, $36, $4e, $36, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $ff, $ff, $4b, $37, $69, $5f, $53, $ff, $67, $53, $51, $3f, $67, $37, $4f, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $08, $00, $00, $fe, $fe, $5c, $36, $4a, $36, $5a, $44, $46, $fe, $52, $50, $52, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $00, $00, $ff, $ff, $5d, $37, $4b, $37, $5b, $45, $47, $ff, $53, $51, $53, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0b, $06, $02, $fe, $fe, $4e, $36, $5a, $36, $44, $46, $4a, $52, $fe, $52, $5c, $36, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0c, $06, $02, $ff, $ff, $4f, $37, $5b, $37, $45, $47, $4b, $53, $ff, $53, $5d, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $05, $00, $00, $fe, $fe, $66, $36, $5a, $5e, $66, $5e, $4a, $46, $fe, $36, $5a, $36, $3c, $36, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $ff, $ff, $67, $37, $5b, $5f, $67, $5f, $4b, $47, $ff, $37, $5b, $37, $3d, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $08, $00, $00, $fe, $fe, $4a, $3e, $46, $68, $52, $fe, $5c, $36, $4a, $36, $42, $46, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $00, $00, $ff, $ff, $4b, $3f, $47, $69, $53, $ff, $5d, $37, $4b, $37, $43, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0b, $06, $02, $fe, $fe, $4a, $52, $48, $46, $fe, $40, $5e, $48, $46, $4e, $52, $5c, $52, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0c, $06, $02, $ff, $ff, $4b, $53, $49, $47, $ff, $41, $5f, $49, $47, $4f, $53, $5d, $53, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $05, $00, $00, $fe, $fe, $4e, $36, $50, $36, $38, $5e, $fe, $5a, $44, $46, $4e, $52, $4a, $36, $62, $36, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $ff, $ff, $4f, $37, $51, $37, $39, $5f, $ff, $5b, $45, $47, $4f, $53, $4b, $37, $63, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $08, $00, $00, $fe, $fe, $5c, $52, $58, $5e, $fe, $52, $3e, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $00, $00, $ff, $ff, $5d, $53, $59, $5f, $ff, $53, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0b, $00, $00, $fe, $fe, $66, $52, $5a, $5e, $4a, $3e, $fe, $44, $36, $5c, $36, $66, $36, $4e, $36, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0c, $00, $00, $ff, $ff, $67, $53, $5b, $5f, $4b, $3f, $ff, $45, $37, $5d, $37, $67, $37, $4f, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0e, $08, $01, $fe, $fe, $5c, $3e, $5c, $5a, $5e, $66, $36, $fe, $4e, $52, $4e, $46, $50, $52, $4a, $46, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0f, $08, $01, $ff, $ff, $5d, $3f, $5d, $5b, $5f, $67, $37, $ff, $4f, $53, $4f, $47, $51, $53, $4b, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $03, $00, $00, $fe, $fe, $fe, $fe, $00, $22, $26, $fe, $2c, $1c, $22, $14, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $05, $00, $00, $fe, $fe, $40, $5e, $48, $46, $4a, $52, $fe, $50, $52, $4e, $5e, $58, $36, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $06, $00, $00, $ff, $ff, $41, $5f, $49, $47, $4b, $53, $ff, $51, $53, $4f, $5f, $59, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $08, $00, $00, $fe, $fe, $50, $52, $58, $46, $66, $5e, $4a, $46, $fe, $5a, $36, $5c, $52, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $09, $00, $00, $ff, $ff, $51, $53, $59, $47, $67, $5f, $4b, $47, $ff, $5b, $37, $5d, $53, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0b, $00, $00, $fe, $fe, $46, $50, $52, $5e, $3e, $fe, $66, $36, $5a, $5e, $52, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0c, $00, $00, $ff, $ff, $47, $51, $53, $5f, $3f, $ff, $67, $37, $5b, $5f, $53, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0e, $08, $01, $fe, $fe, $4e, $46, $3a, $44, $46, $5c, $36, $4a, $36, $fe, $5c, $36, $44, $36, $58, $36, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0f, $08, $01, $ff, $ff, $4f, $47, $3b, $45, $47, $5d, $37, $4b, $37, $ff, $5d, $37, $45, $37, $59, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $03, $00, $00, $fe, $fe, $fe, $24, $1e, $08, $04, $10, $00, $16, $fe, $26, $0e, $00, $1a, $14, $24, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $05, $00, $00, $fe, $fe, $5c, $36, $4a, $36, $5a, $44, $46, $fe, $4a, $36, $62, $36, $42, $5e, $3a, $44, $46, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $ff, $ff, $5d, $37, $4b, $37, $5b, $45, $47, $ff, $4b, $37, $63, $37, $43, $5f, $3b, $45, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $08, $06, $02, $fe, $fe, $36, $4a, $46, $5c, $5a, $5e, $42, $5e, $fe, $4e, $5e, $58, $36, $5e, $3a, $44, $46, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $06, $02, $ff, $ff, $37, $4b, $47, $5d, $5b, $5f, $43, $5f, $ff, $4f, $5f, $59, $37, $5f, $3b, $45, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $fe, $fe, $5c, $5a, $5e, $50, $3e, $4a, $36, $68, $5e, $fe, $46, $5a, $44, $46, $44, $36, $58, $36, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $07, $00, $00, $ff, $ff, $5d, $5b, $5f, $51, $3f, $4b, $37, $69, $5f, $ff, $47, $5b, $45, $47, $45, $37, $59, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $06, $02, $fe, $fe, $50, $46, $58, $60, $36, $50, $36, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0a, $06, $02, $ff, $ff, $51, $47, $59, $61, $37, $51, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $fe, $fe, $5a, $36, $5c, $52, $5a, $44, $46, $fe, $5c, $36, $48, $46, $58, $46, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $07, $00, $00, $ff, $ff, $5b, $37, $5d, $53, $5b, $45, $47, $ff, $5d, $37, $49, $47, $59, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $06, $02, $fe, $fe, $4a, $3e, $50, $fe, $5a, $5e, $42, $46, $4e, $52, $58, $46, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0a, $06, $02, $ff, $ff, $4b, $3f, $51, $ff, $5b, $5f, $43, $47, $4f, $53, $59, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $05, $00, $00, $fe, $fe, $5a, $44, $46, $42, $3e, $4a, $46, $fe, $4e, $52, $58, $46, $4e, $52, $5c, $52, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $ff, $ff, $5b, $45, $47, $43, $3f, $4b, $47, $ff, $4f, $53, $59, $47, $4f, $53, $5d, $53, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $08, $00, $00, $fe, $fe, $4e, $52, $5c, $52, $40, $5e, $4e, $46, $fe, $40, $5e, $48, $46, $62, $36, $58, $36, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $00, $00, $ff, $ff, $4f, $53, $5d, $53, $41, $5f, $4f, $47, $ff, $41, $5f, $49, $47, $63, $37, $59, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0b, $06, $02, $fe, $fe, $36, $5c, $5a, $5e, $4a, $52, $fe, $50, $46, $5a, $44, $46, $3c, $36, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0c, $06, $02, $ff, $ff, $37, $5d, $5b, $5f, $4b, $53, $ff, $51, $47, $5b, $45, $47, $3d, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $05, $00, $00, $fe, $46, $fe, $36, $4c, $62, $36, $66, $5a, $fe, $5c, $44, $36, $50, $4a, $fe, $66, $52, $5e, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $ff, $47, $ff, $37, $4d, $63, $37, $67, $5b, $ff, $5d, $45, $37, $51, $4b, $ff, $67, $53, $5f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $07, $00, $00, $fe, $fe, $40, $52, $58, $fe, $66, $52, $5e, $58, $fe, $44, $3e, $4c, $54, $6a, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $08, $00, $00, $ff, $ff, $41, $53, $59, $ff, $67, $53, $5f, $59, $ff, $45, $3f, $4d, $55, $6b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0a, $00, $00, $fe, $fe, $4e, $46, $4a, $46, $4a, $52, $fe, $50, $36, $4a, $36, $3c, $36, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0b, $00, $00, $ff, $ff, $4f, $47, $4b, $47, $4b, $53, $ff, $51, $37, $4b, $37, $3d, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0c, $00, $00, $fe, $fe, $66, $36, $5a, $5e, $4a, $52, $fe, $50, $46, $5a, $44, $46, $4e, $5e, $58, $36, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0d, $00, $00, $ff, $ff, $67, $37, $5b, $5f, $4b, $53, $ff, $51, $47, $5b, $45, $47, $4f, $5f, $59, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0e, $06, $02, $fe, $fe, $5c, $36, $4a, $36, $4a, $52, $fe, $5c, $36, $46, $58, $36, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0f, $06, $02, $ff, $ff, $5d, $37, $4b, $37, $4b, $53, $ff, $5d, $37, $47, $59, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $05, $00, $00, $fe, $fe, $66, $52, $5a, $44, $46, $44, $46, $58, $52, $fe, $5c, $36, $50, $36, $4a, $36, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $ff, $ff, $67, $53, $5b, $45, $47, $45, $47, $59, $53, $ff, $5d, $37, $51, $37, $4b, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $08, $00, $00, $fe, $fe, $5a, $3e, $46, $4a, $46, $fe, $46, $5a, $44, $46, $44, $36, $58, $36, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $00, $00, $ff, $ff, $5b, $3f, $47, $4b, $47, $ff, $47, $5b, $45, $47, $45, $37, $59, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0a, $00, $00, $fe, $fe, $58, $66, $5e, $46, $3a, $44, $46, $fe, $66, $52, $5a, $44, $46, $3c, $36, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0b, $00, $00, $ff, $ff, $59, $67, $5f, $47, $3b, $45, $47, $ff, $67, $53, $5b, $45, $47, $3d, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0c, $00, $00, $fe, $fe, $44, $46, $5c, $52, $5a, $44, $46, $fe, $50, $36, $4a, $36, $46, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $0d, $00, $00, $ff, $ff, $45, $47, $5d, $53, $5b, $45, $47, $ff, $51, $37, $4b, $37, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0e, $08, $02, $fe, $fe, $5a, $44, $46, $50, $66, $36, $fe, $5a, $36, $50, $52, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0f, $08, $02, $ff, $ff, $5b, $45, $47, $51, $67, $37, $ff, $5b, $37, $51, $53, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $05, $00, $00, $fe, $fe, $fe, $fe, $fe, $5c, $44, $36, $50, $4a, $5a, $fe, $5c, $52, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $06, $00, $00, $ff, $ff, $ff, $ff, $ff, $5d, $45, $37, $51, $4b, $5b, $ff, $5d, $53, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $08, $00, $00, $fe, $fe, $48, $46, $4e, $fe, $62, $52, $58, $50, $3e, $4c, $4c, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $02, $09, $00, $00, $ff, $ff, $49, $47, $4f, $ff, $63, $53, $59, $51, $3f, $4d, $4d, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0a, $06, $02, $fe, $fe, $48, $46, $4e, $fe, $44, $52, $4c, $3c, $3e, $4e, $36, $50, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $0b, $06, $02, $ff, $ff, $49, $47, $4f, $ff, $45, $53, $4d, $3d, $3f, $4f, $37, $51, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $08, $08, $02, $fe, $fe, $5a, $5e, $54, $3e, $58, $fe, $4e, $36, $58, $46, $52, $fe, $3a, $4c, $5e, $38, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $09, $08, $02, $ff, $ff, $5b, $5f, $55, $3f, $59, $ff, $4f, $37, $59, $47, $53, $ff, $3b, $4d, $5f, $39, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $08, $06, $02, $fe, $fe, $48, $5e, $54, $46, $5c, $3e, $58, $fe, $3a, $52, $6a, $6e, $4c, $5c, $3c, $6a, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $01, $09, $06, $02, $ff, $ff, $49, $5f, $55, $47, $5d, $3f, $59, $ff, $3b, $53, $6b, $6f, $4d, $5d, $3d, $6b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $08, $06, $01, $fe, $fe, $42, $5e, $4e, $54, $3e, $46, $fe, $66, $52, $4a, $52, $46, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $09, $06, $01, $ff, $ff, $43, $5f, $4f, $55, $3f, $47, $ff, $67, $53, $4b, $53, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $04, $00, $00, $fe, $fe, $fe, $fe, $1e, $22, $1c, $06, $28, $04, $08, $22, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $06, $00, $00, $fe, $fe, $5a, $36, $5c, $52, $58, $5e, $fe, $52, $4a, $36, $3c, $36, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $07, $00, $00, $ff, $ff, $5b, $37, $5d, $53, $59, $5f, $ff, $53, $4b, $37, $3d, $37, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $09, $06, $01, $fe, $fe, $5c, $36, $4a, $3e, $44, $46, $58, $52, $fe, $46, $68, $5e, $5a, $44, $46, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $0a, $06, $01, $ff, $ff, $5d, $37, $4b, $3f, $45, $47, $59, $53, $ff, $47, $69, $5f, $5b, $45, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $05, $00, $00, $fe, $fe, $fe, $fe, $08, $2e, $08, $04, $28, $26, $10, $2a, $08, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $06, $00, $00, $fe, $fe, $fe, $fe, $1e, $22, $1c, $06, $28, $04, $08, $22, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $08, $06, $01, $fe, $fe, $44, $46, $58, $52, $5a, $44, $46, $fe, $66, $36, $4e, $36, $5e, $3a, $44, $46, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $00, $09, $06, $01, $ff, $ff, $45, $47, $59, $53, $5b, $45, $47, $ff, $67, $37, $4f, $37, $5f, $3b, $45, $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $08, $00, $00, $fe, $fe, $fe, $fe, $1e, $22, $08, $24, $08, $1a, $26, $08, $06, $fe, $02, $30, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $0a, $06, $03, $fe, $fe, $fe, $fe, $fe, $fe, $1a, $10, $1a, $26, $08, $1a, $06, $1c, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff

; C: 42 zero records after the 214 rows (29:5AC0-6000); read past the end of the table in forced runs, so not padding
Credits_ScrollRowTbl_ZeroRows::
    INCBIN "data/bank_29/Credits_ScrollRowTbl_ZeroRows.bin" ; $5AC0, 1344 bytes
; C: stock face set 6, expression 0 of 4 (56 tiles, $380 bytes; StockFace_GfxTbl entry 6/0); not in the Japanese ROM;
; used as: Run! Run! Run!, first face option (Run_CharacterToGfxIndex_Tbl72C6 = 6, 3, 8)
Gfx_29_6000_StockFace6_Expr0::
    INCBIN "data/bank_29/Gfx_29_6000_StockFace6_Expr0.2bpp" ; $6000, 896 bytes
; C: stock face set 6, expression 1 of 4 (56 tiles, $380 bytes; StockFace_GfxTbl entry 6/1); not in the Japanese ROM;
; used as: Run! Run! Run!, first face option (Run_CharacterToGfxIndex_Tbl72C6 = 6, 3, 8)
Gfx_29_6380_StockFace6_Expr1::
    INCBIN "data/bank_29/Gfx_29_6380_StockFace6_Expr1.2bpp" ; $6380, 896 bytes
; C: stock face set 6, expression 2 of 4 (56 tiles, $380 bytes; StockFace_GfxTbl entry 6/2); not in the Japanese ROM;
; used as: Run! Run! Run!, first face option (Run_CharacterToGfxIndex_Tbl72C6 = 6, 3, 8)
Gfx_29_6700_StockFace6_Expr2::
    INCBIN "data/bank_29/Gfx_29_6700_StockFace6_Expr2.2bpp" ; $6700, 896 bytes
; C: stock face set 6, expression 3 (StockFace_GfxTbl entry 6/3; $380 B): the face shown when the ball is missed
; (Mode20_State06_GameOver: Ball_LoadGfx8D80 with C = 3); not in the Japanese ROM
Gfx_29_6A80_StockFace6_Expr3::
    INCBIN "data/bank_29/Gfx_29_6A80_StockFace6_Expr3.2bpp" ; $6A80, 896 bytes
; C: stock face set 7, expression 0 of 4 (56 tiles, $380 bytes; StockFace_GfxTbl entry 7/0); not in the Japanese ROM;
; used as: Ball, second face option, the drawn heads (Ball_PickGfxBank_Tbl7F4E = 0, 7, 8); the owner's "default Ball
; head" in bank $29
Gfx_29_6E00_StockFace7_Expr0::
    INCBIN "data/bank_29/Gfx_29_6E00_StockFace7_Expr0.2bpp" ; $6E00, 896 bytes
; C: stock face set 7, expression 1 of 4 (56 tiles, $380 bytes; StockFace_GfxTbl entry 7/1); not in the Japanese ROM;
; used as: Ball, second face option, the drawn heads (Ball_PickGfxBank_Tbl7F4E = 0, 7, 8); the owner's "default Ball
; head" in bank $29
Gfx_29_7180_StockFace7_Expr1::
    INCBIN "data/bank_29/Gfx_29_7180_StockFace7_Expr1.2bpp" ; $7180, 896 bytes
; C: stock face set 7, expression 2 of 4 (56 tiles, $380 bytes; StockFace_GfxTbl entry 7/2); not in the Japanese ROM;
; used as: Ball, second face option, the drawn heads (Ball_PickGfxBank_Tbl7F4E = 0, 7, 8); the owner's "default Ball
; head" in bank $29
Gfx_29_7500_StockFace7_Expr2::
    INCBIN "data/bank_29/Gfx_29_7500_StockFace7_Expr2.2bpp" ; $7500, 896 bytes
; C: stock face set 7, expression 3 (StockFace_GfxTbl entry 7/3; $380 B): the face shown when the ball is missed
; (Mode20_State06_GameOver: Ball_LoadGfx8D80 with C = 3); not in the Japanese ROM
Gfx_29_7880_StockFace7_Expr3::
    INCBIN "data/bank_29/Gfx_29_7880_StockFace7_Expr3.2bpp" ; $7880, 896 bytes
; C: entry 0 of DjEd_SetFieldCursor_Tbl6257 (05:6257): an 89-byte D.J. tune record copied to wSettingsPreset and
; played through Dj_LoadTune_FromDE_Far; in the Japanese build these records sit at 29:6000 (Map_29_6000_Map05_62A3
; ...), here they moved to the end of the bank, after the stock faces
DjPresetTune0_29_7C00::
    db $09
    db $8f
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $55
    db $55
    db $55
    db $55
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $ff
    db $ff
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $ff
    db $ff
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
    db $00
    db $00
    db $00
    db $00
    db $00
    db $55
    db $55
    db $55
    db $55
    db $ff
    db $8f
    db $5f
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $55
    db $55
    db $55
    db $55
    db $00
    db $00
    db $78

; C: entry 1 of DjEd_SetFieldCursor_Tbl6257 (05:6257): an 89-byte D.J. tune record copied to wSettingsPreset and
; played through Dj_LoadTune_FromDE_Far; in the Japanese build these records sit at 29:6000 (Map_29_6000_Map05_62A3
; ...), here they moved to the end of the bank, after the stock faces
DjPresetTune1_29_7C59::
    db $15
    db $8f
    db $09
    db $00
    db $11
    db $1d
    db $01
    db $19
    db $00
    db $00
    db $1b
    db $00
    db $00
    db $06
    db $0b
    db $0f
    db $12
    db $17
    db $1b
    db $1e
    db $55
    db $55
    db $55
    db $55
    db $00
    db $11
    db $22
    db $33
    db $44
    db $55
    db $66
    db $77
    db $88
    db $99
    db $a4
    db $bb
    db $cc
    db $4d
    db $e4
    db $ff
    db $27
    db $04
    db $81
    db $01
    db $0d
    db $0b
    db $14
    db $01
    db $14
    db $16
    db $0d
    db $01
    db $0b
    db $0d
    db $08
    db $01
    db $12
    db $17
    db $1b
    db $55
    db $55
    db $55
    db $55
    db $ff
    db $8f
    db $4f
    db $16
    db $24
    db $23
    db $16
    db $0a
    db $22
    db $14
    db $0a
    db $24
    db $23
    db $16
    db $00
    db $0a
    db $16
    db $25
    db $24
    db $55
    db $55
    db $55
    db $55
    db $2b
    db $4b
    db $78

; C: entry 4 of DjEd_SetFieldCursor_Tbl6257 (05:6257): an 89-byte D.J. tune record copied to wSettingsPreset and
; played through Dj_LoadTune_FromDE_Far; in the Japanese build these records sit at 29:6000 (Map_29_6000_Map05_62A3
; ...), here they moved to the end of the bank, after the stock faces
DjPresetTune4_29_7CB2::
    db $20
    db $ef
    db $00
    db $00
    db $22
    db $00
    db $1b
    db $00
    db $1d
    db $00
    db $22
    db $00
    db $22
    db $00
    db $1b
    db $00
    db $1d
    db $00
    db $20
    db $00
    db $55
    db $55
    db $55
    db $55
    db $00
    db $00
    db $ff
    db $ff
    db $00
    db $00
    db $ff
    db $ff
    db $00
    db $00
    db $ff
    db $ff
    db $00
    db $00
    db $ff
    db $ff
    db $27
    db $8f
    db $00
    db $20
    db $1d
    db $00
    db $00
    db $19
    db $1b
    db $00
    db $00
    db $22
    db $1d
    db $00
    db $00
    db $19
    db $1b
    db $00
    db $00
    db $55
    db $55
    db $55
    db $55
    db $ff
    db $8f
    db $5f
    db $0e
    db $00
    db $08
    db $00
    db $08
    db $00
    db $1f
    db $00
    db $1d
    db $1a
    db $00
    db $13
    db $1e
    db $1a
    db $00
    db $00
    db $55
    db $55
    db $55
    db $55
    db $a8
    db $00
    db $3c

; C: entry 3 of DjEd_SetFieldCursor_Tbl6257 (05:6257): an 89-byte D.J. tune record copied to wSettingsPreset and
; played through Dj_LoadTune_FromDE_Far; in the Japanese build these records sit at 29:6000 (Map_29_6000_Map05_62A3
; ...), here they moved to the end of the bank, after the stock faces
DjPresetTune3_29_7D0B::
    db $17
    db $8f
    db $a5
    db $08
    db $01
    db $00
    db $01
    db $01
    db $20
    db $00
    db $00
    db $00
    db $06
    db $00
    db $00
    db $00
    db $0d
    db $00
    db $00
    db $00
    db $55
    db $55
    db $55
    db $55
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $ff
    db $ff
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $ff
    db $ff
    db $19
    db $94
    db $00
    db $0d
    db $00
    db $0d
    db $0d
    db $0d
    db $00
    db $08
    db $00
    db $0b
    db $00
    db $0b
    db $00
    db $0d
    db $00
    db $00
    db $00
    db $55
    db $55
    db $55
    db $55
    db $ff
    db $8f
    db $8f
    db $00
    db $00
    db $20
    db $00
    db $00
    db $08
    db $1d
    db $00
    db $00
    db $00
    db $05
    db $00
    db $03
    db $00
    db $00
    db $00
    db $55
    db $55
    db $55
    db $55
    db $04
    db $28
    db $3c

; C: entry 2 of DjEd_SetFieldCursor_Tbl6257 (05:6257): an 89-byte D.J. tune record copied to wSettingsPreset and
; played through Dj_LoadTune_FromDE_Far; in the Japanese build these records sit at 29:6000 (Map_29_6000_Map05_62A3
; ...), here they moved to the end of the bank, after the stock faces
DjPresetTune2_29_7D64::
    db $27
    db $af
    db $00
    db $00
    db $01
    db $04
    db $00
    db $13
    db $00
    db $00
    db $07
    db $00
    db $00
    db $00
    db $00
    db $19
    db $00
    db $21
    db $00
    db $00
    db $55
    db $55
    db $55
    db $55
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $ff
    db $ff
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $ff
    db $ff
    db $17
    db $1c
    db $0d
    db $03
    db $1c
    db $00
    db $00
    db $15
    db $00
    db $00
    db $00
    db $00
    db $1d
    db $00
    db $00
    db $23
    db $00
    db $04
    db $00
    db $55
    db $55
    db $55
    db $55
    db $ff
    db $8d
    db $2f
    db $09
    db $20
    db $00
    db $23
    db $00
    db $21
    db $00
    db $23
    db $12
    db $1c
    db $11
    db $23
    db $20
    db $00
    db $23
    db $25
    db $55
    db $55
    db $55
    db $55
    db $44
    db $a8
    db $78

    ; padding
    ds $243, $00
