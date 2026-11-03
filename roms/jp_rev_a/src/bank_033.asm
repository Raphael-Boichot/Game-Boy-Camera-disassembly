; Pocket Camera (Japan) (Rev A), bank $33. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $033", ROMX[$4000], BANK[$33]

; C: sheet tiles 128-279 of wild frame 06 (idx 5, starts at 32:7800): continues WildFrame5_Tiles across the bank 32/33
; boundary (tile 128 = byte $800)
WildFrame5_TilesPart2::
    INCBIN "data/bank_33/WildFrame5_TilesPart2.bin" ; $4000, 2432 bytes
; C: sheet tiles 280-335: 4 x 14 lateral strips, all $FF (README 16.13), tested by blanking (frame 06)
WildFrame5_LateralStrips::
    INCBIN "data/bank_33/WildFrame5_LateralStrips.bin" ; $4980, 896 bytes
; C: sheet tiles 336-383: 48 blank tiles ($00, 33:4FF4-4FFF included)
WildFrame5_TilesTail::
    INCBIN "data/bank_33/WildFrame5_TilesTail.bin" ; $4D00, 768 bytes
; C: sheet tiles 0-279
WildFrame6_Tiles::
    INCBIN "data/bank_33/WildFrame6_Tiles.2bpp" ; $5000, 4480 bytes
; C: sheet tiles 280-335: 4 x 14 lateral strips (README 16.13)
WildFrame6_LateralStrips::
    INCBIN "data/bank_33/WildFrame6_LateralStrips.bin" ; $6180, 896 bytes
; C: sheet tiles 336-383
WildFrame6_TilesTail::
    INCBIN "data/bank_33/WildFrame6_TilesTail.bin" ; $6500, 768 bytes
; C: sheet tiles 0-279
WildFrame7_Tiles::
    INCBIN "data/bank_33/WildFrame7_Tiles.2bpp" ; $6800, 4480 bytes
; C: sheet tiles 280-335: 4 x 14 lateral strips (README 16.13)
WildFrame7_LateralStrips::
    INCBIN "data/bank_33/WildFrame7_LateralStrips.bin" ; $7980, 896 bytes
; C: sheet tiles 336-383
WildFrame7_TilesTail::
    INCBIN "data/bank_33/WildFrame7_TilesTail.bin" ; $7D00, 768 bytes
