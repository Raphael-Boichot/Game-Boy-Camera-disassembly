; Game Boy Camera (USA, Europe), bank $34. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $034", ROMX[$4000], BANK[$34]

; I: entry 0 of Border_SrcTbl (08:511F)
Border00_Tiles::
    INCBIN "data/bank_34/Border00_Tiles.2bpp" ; $4000, 1536 bytes
; I: entry 0 of Border_SrcTbl (08:511F)
Border00_Map::
    INCBIN "data/bank_34/Border00_Map.tilemap" ; $4600, 136 bytes
; I: entry 1 of Border_SrcTbl (08:511F)
Border01_Tiles::
    INCBIN "data/bank_34/Border01_Tiles.2bpp" ; $4688, 1536 bytes
; I: entry 1 of Border_SrcTbl (08:511F)
Border01_Map::
    INCBIN "data/bank_34/Border01_Map.tilemap" ; $4C88, 136 bytes
; C: entry 2 of Border_SrcTbl (08:511F)
Border02_Tiles::
    INCBIN "data/bank_34/Border02_Tiles.2bpp" ; $4D10, 1536 bytes
; C: entry 2 of Border_SrcTbl (08:511F)
Border02_Map::
    INCBIN "data/bank_34/Border02_Map.tilemap" ; $5310, 136 bytes
; C: entry 3 of Border_SrcTbl (08:511F)
Border03_Tiles::
    INCBIN "data/bank_34/Border03_Tiles.2bpp" ; $5398, 1536 bytes
; C: entry 3 of Border_SrcTbl (08:511F)
Border03_Map::
    INCBIN "data/bank_34/Border03_Map.tilemap" ; $5998, 136 bytes
; C: entry 4 of Border_SrcTbl (08:511F)
Border04_Tiles::
    INCBIN "data/bank_34/Border04_Tiles.2bpp" ; $5A20, 1536 bytes
; C: entry 4 of Border_SrcTbl (08:511F)
Border04_Map::
    INCBIN "data/bank_34/Border04_Map.tilemap" ; $6020, 136 bytes
; C: entry 5 of Border_SrcTbl (08:511F)
Border05_Tiles::
    INCBIN "data/bank_34/Border05_Tiles.2bpp" ; $60A8, 1536 bytes
; C: entry 5 of Border_SrcTbl (08:511F)
Border05_Map::
    INCBIN "data/bank_34/Border05_Map.tilemap" ; $66A8, 136 bytes
; I: entry 6 of Border_SrcTbl (08:511F)
Border06_Tiles::
    INCBIN "data/bank_34/Border06_Tiles.2bpp" ; $6730, 1536 bytes
; I: entry 6 of Border_SrcTbl (08:511F)
Border06_Map::
    INCBIN "data/bank_34/Border06_Map.tilemap" ; $6D30, 136 bytes
; C: entry 7 of Border_SrcTbl (08:511F)
Border07_Tiles::
    INCBIN "data/bank_34/Border07_Tiles.2bpp" ; $6DB8, 1536 bytes
; C: entry 7 of Border_SrcTbl (08:511F)
Border07_Map::
    INCBIN "data/bank_34/Border07_Map.tilemap" ; $73B8, 136 bytes
; I: entry 8 of Border_SrcTbl (08:511F)
Border08_Tiles::
    INCBIN "data/bank_34/Border08_Tiles.2bpp" ; $7440, 1536 bytes
; C: entry 8 of Border_SrcTbl (08:511F)
Border08_Map::
    db $00, $01, $02, $03, $01, $02, $03, $01
    db $02, $03, $01, $02, $03, $01, $02, $03
    db $01, $02, $03, $24, $04, $05, $06, $07
    db $08, $06, $07, $08, $06, $07, $08, $06
    db $07, $08, $06, $07, $08, $06, $25, $0d
    db $04, $0e, $01, $02, $03, $0f, $10, $11
    db $12, $13, $14, $15, $16, $17, $18, $02
    db $03, $01, $26, $0d, $19, $07, $08, $06
    db $07, $1a, $1b, $1c, $1d, $1e, $1f, $20
    db $21, $22, $23, $06, $07, $08, $06, $27
    db $09, $0a, $09, $0a, $0b, $0c, $0b, $0c
    db $04, $0d, $04, $0d, $09, $0a, $09, $0a
    db $0b, $0c, $0b, $0c, $04, $0d, $04, $0d
    db $09, $0a, $09, $0a, $0b, $0c, $0b, $0c
    db $04, $0d, $04, $0d, $09, $0a, $09, $0a
    db $0b, $0c, $0b, $0c, $04, $0d, $04, $0d
    db $09, $0a, $09, $0a, $0b, $0c, $0b, $0c

    ; padding
    ds $538, $00
