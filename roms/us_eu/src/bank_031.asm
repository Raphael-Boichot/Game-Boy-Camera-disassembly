; Game Boy Camera (USA, Europe), bank $31. Written by tools/make_source.py from roms/us_eu/gbcam_us.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $031", ROMX[$4000], BANK[$31]

; C: sheet tiles 0-279; C: entry 0 of WildFrame_PageSrcTbl points to this page
WildFrame0_Tiles::
    INCBIN "data/bank_31/WildFrame0_Tiles.2bpp" ; $4000, 4480 bytes
; C: sheet tiles 280-335: 4 x 14 lateral strips (README 16.13)
WildFrame0_LateralStrips::
    INCBIN "data/bank_31/WildFrame0_LateralStrips.bin" ; $5180, 896 bytes
; C: sheet tiles 336-383
WildFrame0_TilesTail::
    INCBIN "data/bank_31/WildFrame0_TilesTail.bin" ; $5500, 768 bytes
; C: sheet tiles 0-279; C: entry 1 of WildFrame_PageSrcTbl points to this page
WildFrame1_Tiles::
    INCBIN "data/bank_31/WildFrame1_Tiles.2bpp" ; $5800, 4480 bytes
; C: sheet tiles 280-335: 4 x 14 lateral strips (README 16.13); C: entry 1 of WildFrame_PageSrcTbl points to this page
WildFrame1_LateralStrips::
    INCBIN "data/bank_31/WildFrame1_LateralStrips.bin" ; $6980, 896 bytes
; C: sheet tiles 336-383
WildFrame1_TilesTail::
    INCBIN "data/bank_31/WildFrame1_TilesTail.bin" ; $6D00, 768 bytes
; C: sheet tiles 0-279; C: entry 2 of WildFrame_PageSrcTbl points to this page
WildFrame2_Tiles::
    INCBIN "data/bank_31/WildFrame2_Tiles.2bpp" ; $7000, 4096 bytes
