; Pocket Camera (Japan) (Rev A), bank $32. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $032", ROMX[$4000], BANK[$32]

; C: sheet tiles 256-279 of wild frame 03 (idx 2, starts at 31:7000): continues WildFrame2_Tiles across the bank 31/32
; boundary (tile 256 = byte $1000)
WildFrame2_TilesPart2::
    INCBIN "data/bank_32/WildFrame2_TilesPart2.bin" ; $4000, 384 bytes
; C: sheet tiles 280-335: 4 x 14 lateral strips (README 16.13), tested by blanking (frame 03)
WildFrame2_LateralStrips::
    INCBIN "data/bank_32/WildFrame2_LateralStrips.bin" ; $4180, 896 bytes
; C: sheet tiles 336-383: 48 blank tiles
WildFrame2_TilesTail::
    INCBIN "data/bank_32/WildFrame2_TilesTail.bin" ; $4500, 768 bytes
; C: sheet tiles 0-279
WildFrame3_Tiles::
    INCBIN "data/bank_32/WildFrame3_Tiles.2bpp" ; $4800, 4480 bytes
; C: sheet tiles 280-335: 4 x 14 lateral strips (README 16.13)
WildFrame3_LateralStrips::
    INCBIN "data/bank_32/WildFrame3_LateralStrips.bin" ; $5980, 896 bytes
; C: sheet tiles 336-383
WildFrame3_TilesTail::
    INCBIN "data/bank_32/WildFrame3_TilesTail.bin" ; $5D00, 768 bytes
; C: sheet tiles 0-279
WildFrame4_Tiles::
    INCBIN "data/bank_32/WildFrame4_Tiles.2bpp" ; $6000, 4480 bytes
; C: sheet tiles 280-335: 4 x 14 lateral strips (README 16.13)
WildFrame4_LateralStrips::
    INCBIN "data/bank_32/WildFrame4_LateralStrips.bin" ; $7180, 896 bytes
; C: sheet tiles 336-383
WildFrame4_TilesTail::
    INCBIN "data/bank_32/WildFrame4_TilesTail.bin" ; $7500, 768 bytes
; C: sheet tiles 0-279
WildFrame5_Tiles::
    INCBIN "data/bank_32/WildFrame5_Tiles.2bpp" ; $7800, 2048 bytes
