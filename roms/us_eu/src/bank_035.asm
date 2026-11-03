; Game Boy Camera (USA, Europe), bank $35. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $035", ROMX[$4000], BANK[$35]

; C: entry 9 of Border_SrcTbl (08:511F)
Border09_Tiles::
    INCBIN "data/bank_35/Border09_Tiles.2bpp" ; $4000, 1536 bytes
; C: entry 9 of Border_SrcTbl (08:511F)
Border09_Map::
    INCBIN "data/bank_35/Border09_Map.tilemap" ; $4600, 136 bytes
; C: entry 10 of Border_SrcTbl (08:511F)
Border10_Tiles::
    INCBIN "data/bank_35/Border10_Tiles.2bpp" ; $4688, 1536 bytes
; C: entry 10 of Border_SrcTbl (08:511F)
Border10_Map::
    INCBIN "data/bank_35/Border10_Map.tilemap" ; $4C88, 136 bytes
; C: entry 11 of Border_SrcTbl (08:511F)
Border11_Tiles::
    INCBIN "data/bank_35/Border11_Tiles.2bpp" ; $4D10, 1536 bytes
; C: entry 11 of Border_SrcTbl (08:511F)
Border11_Map::
    INCBIN "data/bank_35/Border11_Map.tilemap" ; $5310, 136 bytes
; C: entry 12 of Border_SrcTbl (08:511F)
Border12_Tiles::
    INCBIN "data/bank_35/Border12_Tiles.2bpp" ; $5398, 1536 bytes
; C: entry 12 of Border_SrcTbl (08:511F)
Border12_Map::
    INCBIN "data/bank_35/Border12_Map.tilemap" ; $5998, 136 bytes
; C: entry 13 of Border_SrcTbl (08:511F)
Border13_Tiles::
    INCBIN "data/bank_35/Border13_Tiles.2bpp" ; $5A20, 1536 bytes
; C: entry 13 of Border_SrcTbl (08:511F)
Border13_Map::
    INCBIN "data/bank_35/Border13_Map.tilemap" ; $6020, 136 bytes
; C: entry 14 of Border_SrcTbl (08:511F)
Border14_Tiles::
    INCBIN "data/bank_35/Border14_Tiles.2bpp" ; $60A8, 1536 bytes
; C: entry 14 of Border_SrcTbl (08:511F)
Border14_Map::
    INCBIN "data/bank_35/Border14_Map.tilemap" ; $66A8, 136 bytes
; C: entry 15 of Border_SrcTbl (08:511F)
Border15_Tiles::
    INCBIN "data/bank_35/Border15_Tiles.2bpp" ; $6730, 1536 bytes
; C: entry 15 of Border_SrcTbl (08:511F)
Border15_Map::
    INCBIN "data/bank_35/Border15_Map.tilemap" ; $6D30, 136 bytes
; C: entry 16 of Border_SrcTbl (08:511F)
Border16_Tiles::
    INCBIN "data/bank_35/Border16_Tiles.2bpp" ; $6DB8, 1536 bytes
; C: entry 16 of Border_SrcTbl (08:511F)
Border16_Map::
    INCBIN "data/bank_35/Border16_Map.tilemap" ; $73B8, 136 bytes
; C: entry 17 of Border_SrcTbl (08:511F)
Border17_Tiles::
    INCBIN "data/bank_35/Border17_Tiles.2bpp" ; $7440, 1536 bytes
; C: entry 17 of Border_SrcTbl (08:511F)
Border17_Map::
    db $00, $01, $02, $03, $04, $05, $06, $07
    db $08, $09, $09, $0a, $0b, $0c, $0d, $0e
    db $3b, $3c, $3d, $3e, $0f, $10, $11, $12
    db $13, $14, $15, $16, $17, $18, $19, $1a
    db $1b, $15, $1c, $1d, $3f, $40, $10, $41
    db $37, $38, $02, $03, $04, $05, $06, $07
    db $08, $09, $09, $0a, $0b, $0c, $0d, $0e
    db $3b, $3c, $5b, $5c, $39, $3a, $11, $12
    db $13, $14, $15, $16, $17, $18, $19, $1a
    db $1b, $15, $1c, $1d, $3f, $40, $5d, $5e
    db $1e, $1f, $42, $43, $20, $21, $44, $45
    db $22, $23, $46, $47, $24, $25, $48, $49
    db $26, $27, $4a, $4b, $28, $29, $4c, $4d
    db $2a, $2b, $4e, $4f, $2c, $2d, $50, $51
    db $28, $29, $4c, $4d, $2e, $27, $4a, $52
    db $2f, $30, $53, $54, $31, $32, $55, $56
    db $33, $34, $57, $58, $35, $36, $59, $5a

    ; padding
    ds $538, $00
