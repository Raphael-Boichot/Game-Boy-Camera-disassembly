; Game Boy Camera (USA, Europe), bank $3E. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $03e", ROMX[$4000], BANK[$3e]

; I: entry 0 of the {lo,hi,bank} table 08:74DC, 3584 bytes each (constant pitch)
Gfx_3E_4000_TitleScene::
    INCBIN "data/bank_3e/Gfx_3E_4000_TitleScene.2bpp" ; $4000, 3584 bytes
; I: entry 1 of the {lo,hi,bank} table 08:74DC, 3584 bytes each (constant pitch)
Gfx_3E_4E00_TitleScene::
    INCBIN "data/bank_3e/Gfx_3E_4E00_TitleScene.2bpp" ; $4E00, 3584 bytes
; I: entry 2 of the {lo,hi,bank} table 08:74DC, 3584 bytes each (constant pitch)
Gfx_3E_5C00_TitleScene::
    INCBIN "data/bank_3e/Gfx_3E_5C00_TitleScene.2bpp" ; $5C00, 3584 bytes
; I: entry 3 of the {lo,hi,bank} table 08:74DC, 3584 bytes each (constant pitch)
Gfx_3E_6A00_TitleScene::
    INCBIN "data/bank_3e/Gfx_3E_6A00_TitleScene.2bpp" ; $6A00, 3584 bytes
; I: entry 18 of Border_SrcTbl (08:511F)
Border18_Tiles::
    INCBIN "data/bank_3e/Border18_Tiles.2bpp" ; $7800, 1536 bytes
; I: entry 18 of Border_SrcTbl (08:511F)
Border18_Map::
    db $00, $01, $01, $01, $01, $02, $03, $04
    db $01, $05, $06, $07, $08, $09, $0a, $01
    db $01, $01, $01, $20, $0b, $0c, $0d, $0d
    db $0d, $0e, $0f, $10, $11, $12, $13, $14
    db $15, $16, $17, $0d, $0d, $0d, $21, $22
    db $1a, $1c, $1d, $1d, $1d, $1d, $1d, $1d
    db $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d
    db $1d, $1d, $28, $27, $1e, $1f, $1f, $1f
    db $1f, $1f, $1f, $1f, $1f, $1f, $1f, $1f
    db $1f, $1f, $1f, $1f, $1f, $1f, $1f, $29
    db $0b, $18, $23, $22, $0b, $18, $23, $22
    db $0b, $18, $23, $22, $0b, $18, $23, $22
    db $0b, $18, $23, $22, $0b, $18, $23, $22
    db $19, $18, $24, $25, $1a, $1b, $26, $27
    db $1a, $1b, $26, $27, $1a, $1b, $26, $27
    db $1a, $1b, $26, $27, $1a, $1b, $26, $27
    db $1a, $1b, $26, $27, $1a, $1b, $26, $27

    ; padding
    ds $178, $00
