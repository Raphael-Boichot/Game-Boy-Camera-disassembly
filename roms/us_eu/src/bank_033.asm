; Game Boy Camera (USA, Europe), bank $33. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $033", ROMX[$4000], BANK[$33]

; C: tiles 128-279 of wild frame page 5 (No. 06), continued from 32:7800 as in Japan; the picture is new (2,168 of
; 2,432 bytes differ): TCRF, No. 06 Pikachu / Clefairy -> Wario Land (sheets_jp_vs_intl.png)
WildFrame5_TilesPart2::
    INCBIN "data/bank_33/WildFrame5_TilesPart2.bin" ; $4000, 2432 bytes
; C: the 4 x 14 lateral strips of wild frame page 5: real strip tiles here, all $FF (black) in the Japanese block (704
; of 896 bytes differ; sheets_jp_vs_intl.png)
WildFrame5_LateralStrips::
    INCBIN "data/bank_33/WildFrame5_LateralStrips.bin" ; $4980, 896 bytes
; C: sheet tiles 336-383: 48 blank tiles ($00, 33:4FF4-4FFF included)
WildFrame5_TilesTail::
    INCBIN "data/bank_33/WildFrame5_TilesTail.bin" ; $4D00, 768 bytes
; C: sheet tiles 0-279; C: entry 6 of WildFrame_PageSrcTbl points to this page
WildFrame6_Tiles::
    INCBIN "data/bank_33/WildFrame6_Tiles.2bpp" ; $5000, 4480 bytes
; C: sheet tiles 280-335: 4 x 14 lateral strips (README 16.13); C: entry 6 of WildFrame_PageSrcTbl points to this page
WildFrame6_LateralStrips::
    INCBIN "data/bank_33/WildFrame6_LateralStrips.bin" ; $6180, 896 bytes
; C: sheet tiles 336-383
WildFrame6_TilesTail::
    INCBIN "data/bank_33/WildFrame6_TilesTail.bin" ; $6500, 768 bytes
; I: sheet tiles 0-279 of wild page 7: the Super Mario World frame of page 1 (31:5800) without the TM mark (18 bytes
; in 4 tiles differ). WildFrame_PageSrcTbl lists 8 pages but WildFramePicker_ReadKeys offers at most 7 (6, or 7 with
; wCoroFlag, which Mode19_State00_CopyrightScreens sets to 1 at every ...
Unused_WildFrame7_Tiles::
    INCBIN "data/bank_33/Unused_WildFrame7_Tiles.2bpp" ; $6800, 4480 bytes
; I: sheet tiles 280-335 of the unused wild page 7; evidence I (2026-11-02): the name says it is unused / never
; loaded; that something is never used rests on the absence of evidence (the Japanese convention)
Unused_WildFrame7_LateralStrips::
    INCBIN "data/bank_33/Unused_WildFrame7_LateralStrips.bin" ; $7980, 896 bytes
; I: sheet tiles 336-383 of the unused wild page 7; evidence I (2026-11-02): the name says it is unused / never
; loaded; that something is never used rests on the absence of evidence (the Japanese convention)
Unused_WildFrame7_TilesTail::
    INCBIN "data/bank_33/Unused_WildFrame7_TilesTail.bin" ; $7D00, 768 bytes
