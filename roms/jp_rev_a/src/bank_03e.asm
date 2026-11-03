; Pocket Camera (Japan) (Rev A), bank $3E. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $03e", ROMX[$4000], BANK[$3e]

; C: entry 0 of the {lo,hi,bank} table 08:74DC, 3584 bytes each (constant pitch)
Gfx_3E_4000_TitleScene::
    INCBIN "data/bank_3e/Gfx_3E_4000_TitleScene.2bpp" ; $4000, 3584 bytes
; C: entry 1 of the {lo,hi,bank} table 08:74DC, 3584 bytes each (constant pitch)
Gfx_3E_4E00_TitleScene::
    INCBIN "data/bank_3e/Gfx_3E_4E00_TitleScene.2bpp" ; $4E00, 3584 bytes
; C: entry 2 of the {lo,hi,bank} table 08:74DC, 3584 bytes each (constant pitch)
Gfx_3E_5C00_TitleScene::
    INCBIN "data/bank_3e/Gfx_3E_5C00_TitleScene.2bpp" ; $5C00, 3584 bytes
; C: entry 3 of the {lo,hi,bank} table 08:74DC, 3584 bytes each (constant pitch)
Gfx_3E_6A00_TitleScene::
    INCBIN "data/bank_3e/Gfx_3E_6A00_TitleScene.2bpp" ; $6A00, 3584 bytes
; C: entry 18 of Border_SrcTbl (08:511F)
Border18_Tiles::
    INCBIN "data/bank_3e/Border18_Tiles.2bpp" ; $7800, 1536 bytes
; C: entry 18 of Border_SrcTbl (08:511F)
Border18_Map::
    db $00, $01, $01, $01, $02, $01, $03, $04
    db $05, $06, $07, $08, $09, $0a, $0b, $0c
    db $01, $01, $01, $3c, $0d, $0e, $0f, $0f
    db $10, $11, $12, $13, $14, $15, $16, $17
    db $18, $19, $1a, $1b, $0f, $0f, $3d, $3e
    db $1e, $20, $21, $21, $22, $23, $24, $25
    db $26, $27, $28, $29, $2a, $2b, $2c, $2d
    db $21, $21, $44, $43, $2e, $2f, $2f, $2f
    db $30, $31, $32, $33, $34, $35, $36, $37
    db $38, $39, $3a, $3b, $2f, $2f, $2f, $45
    db $0d, $1c, $3f, $3e, $0d, $1c, $3f, $3e
    db $0d, $1c, $3f, $3e, $0d, $1c, $3f, $3e
    db $0d, $1c, $3f, $3e, $0d, $1c, $3f, $3e
    db $1d, $1c, $40, $41, $1e, $1f, $42, $43
    db $1e, $1f, $42, $43, $1e, $1f, $42, $43
    db $1e, $1f, $42, $43, $1e, $1f, $42, $43
    db $1e, $1f, $42, $43, $1e, $1f, $42, $43

    ; padding
    ds $178, $00
