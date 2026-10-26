; Game Boy Camera (USA, Europe), bank $0D. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $00d", ROMX[$4000], BANK[$d]

; I: copied to VRAM/WRAM by Mode16_State00_Init, Mode16_State01_Redraw (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass
; 2026-10-26: read in BGB in 13 replay(s) of the organic corpus, modes 16 (tcrf_check/assets/l3_names/)
Gfx_0D_4000_Mode16_State00_Init::
    INCBIN "data/bank_0d/Gfx_0D_4000_Mode16_State00_Init.2bpp" ; $4000, 2048 bytes
; I: copied to VRAM/WRAM by Mode16_State00_Init, Mode16_State01_Redraw (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass
; 2026-10-26: read in BGB in 13 replay(s) of the organic corpus, modes 16 (tcrf_check/assets/l3_names/)
Gfx_0D_4800_Mode16_State00_Init::
    INCBIN "data/bank_0d/Gfx_0D_4800_Mode16_State00_Init.2bpp" ; $4800, 2048 bytes
; I: copied to VRAM/WRAM by Mode16_State00_Init, Mode16_State01_Redraw (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass
; 2026-10-26: read in BGB in 13 replay(s) of the organic corpus, modes 16 (tcrf_check/assets/l3_names/)
Gfx_0D_5000_Mode16_State00_Init::
    INCBIN "data/bank_0d/Gfx_0D_5000_Mode16_State00_Init.2bpp" ; $5000, 768 bytes
; I: entry 3 of the {lo,hi,bank} table 06:4B17, 640 bytes each (constant pitch)
Gfx_0D_5300_Strip06_4B06::
    INCBIN "data/bank_0d/Gfx_0D_5300_Strip06_4B06.2bpp" ; $5300, 640 bytes
; I: entry 2 of the {lo,hi,bank} table 06:4B17, 640 bytes each (constant pitch)
Gfx_0D_5580_Strip06_4B06::
    INCBIN "data/bank_0d/Gfx_0D_5580_Strip06_4B06.2bpp" ; $5580, 640 bytes
; I: entry 1 of the {lo,hi,bank} table 06:4B17, 640 bytes each (constant pitch)
Gfx_0D_5800_Strip06_4B06::
    INCBIN "data/bank_0d/Gfx_0D_5800_Strip06_4B06.2bpp" ; $5800, 640 bytes
; I: entry 0 of the {lo,hi,bank} table 06:4B17, 640 bytes each (constant pitch)
Gfx_0D_5A80_Strip06_4B06::
    INCBIN "data/bank_0d/Gfx_0D_5A80_Strip06_4B06.2bpp" ; $5A80, 640 bytes
; I: entry 13 of the {lo,hi,bank} table 04:4493, 640 bytes each (constant pitch)
Gfx_0D_5D00_MsgStrip::
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $fc, $fe, $fc, $fe, $fc
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $ff, $9e, $1c, $5d, $08, $eb, $c9
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $ff, $3f, $7f, $bf, $3f, $1f, $bf
    db $ff, $ff, $ff, $ff, $f7, $ef, $e7, $ef, $e7, $ef, $ee, $e1, $e1, $e0, $e4, $ee
    db $ff, $ff, $ff, $ff, $ff, $cf, $ef, $cf, $ef, $cf, $ee, $ce, $ef, $ce, $6e, $cf
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $3f, $ff, $3d, $18, $dc, $18, $cd, $19
    db $ff, $ff, $ff, $ff, $f7, $f3, $f7, $f3, $f7, $f3, $36, $32, $b6, $10, $d5, $90
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7e, $7e, $fe, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $9f, $9f, $1f, $5f, $3f, $7b, $12, $1a, $10, $79, $30
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f3, $ff, $e3, $61, $fd, $61, $ec, $f1
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ed, $ff, $a9, $80, $96, $80, $b2, $96
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f3, $ff, $f3, $e1, $4c, $e1, $60, $cd
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $87, $c7, $bb, $83, $af, $9f
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $fe, $fc, $fe, $fc, $fe, $fc, $fe, $fc, $ff, $fc, $ff, $ff, $ff, $ff, $ff, $ff
    db $eb, $c9, $eb, $c9, $eb, $c9, $ed, $c8, $fa, $cc, $ff, $ff, $ff, $ff, $ff, $ff
    db $1f, $bf, $1f, $bf, $1f, $bf, $5f, $3f, $bf, $7f, $ff, $ff, $ff, $ff, $ff, $ff
    db $ec, $ee, $cc, $ee, $c0, $ec, $c0, $e1, $fd, $e3, $ff, $ff, $ff, $ff, $ff, $ff
    db $6c, $ce, $6d, $cc, $ed, $cc, $ee, $cc, $ed, $ce, $ff, $ff, $ff, $ff, $ff, $ff
    db $0d, $19, $8d, $d9, $4d, $99, $1d, $19, $bf, $59, $ff, $ff, $ff, $ff, $ff, $ff
    db $d2, $91, $d1, $90, $d4, $92, $d3, $96, $f2, $97, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $7f, $7f, $7f, $7f, $7f, $ff, $ff, $ff, $ff, $ff, $ff
    db $7b, $31, $7b, $33, $7b, $33, $7b, $33, $bb, $73, $ff, $ff, $ff, $ff, $ff, $ff
    db $c0, $e1, $d8, $cd, $d4, $c9, $e1, $c1, $db, $e5, $ff, $ff, $ff, $ff, $ff, $ff
    db $b2, $96, $b2, $96, $b2, $96, $b2, $96, $fb, $96, $ff, $ff, $ff, $ff, $ff, $ff
    db $61, $c1, $6d, $cf, $40, $ed, $73, $e1, $6d, $f3, $ff, $ff, $ff, $ff, $ff, $ff
    db $83, $c7, $e7, $f3, $cb, $b3, $b6, $82, $ce, $c6, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $7f, $7f, $7f, $7f, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

    ; padding
    ds $30, $00

    db $20, $20

    ; padding
    ds $4e, $00

; C: entry 0 of the {lo,hi,bank} table 06:46EF, 256 bytes each (constant pitch)
Gfx_0D_6000_Icon06_46E6::
    INCBIN "data/bank_0d/Gfx_0D_6000_Icon06_46E6.2bpp" ; $6000, 256 bytes
; C: entry 1 of the {lo,hi,bank} table 06:46EF, 256 bytes each (constant pitch)
Gfx_0D_6100_Icon06_46E6::
    INCBIN "data/bank_0d/Gfx_0D_6100_Icon06_46E6.2bpp" ; $6100, 256 bytes
; C: entry 3 of the {lo,hi,bank} table 06:46EF, 256 bytes each (constant pitch)
Gfx_0D_6200_Icon06_46E6::
    INCBIN "data/bank_0d/Gfx_0D_6200_Icon06_46E6.2bpp" ; $6200, 256 bytes
; C: entry 2 of the {lo,hi,bank} table 06:46EF, 256 bytes each (constant pitch)
Gfx_0D_6300_Icon06_46E6::
    INCBIN "data/bank_0d/Gfx_0D_6300_Icon06_46E6.2bpp" ; $6300, 256 bytes
; C: entry 4 of the {lo,hi,bank} table 06:46EF, 256 bytes each (constant pitch)
Gfx_0D_6400_Icon06_46E6::
    INCBIN "data/bank_0d/Gfx_0D_6400_Icon06_46E6.2bpp" ; $6400, 256 bytes
; C: entry 5 of the {lo,hi,bank} table 06:46EF, 256 bytes each (constant pitch)
Gfx_0D_6500_Icon06_46E6::
    INCBIN "data/bank_0d/Gfx_0D_6500_Icon06_46E6.2bpp" ; $6500, 256 bytes
; C: entry 6 of the {lo,hi,bank} table 06:46EF, 256 bytes each (constant pitch)
Gfx_0D_6600_Icon06_46E6::
    INCBIN "data/bank_0d/Gfx_0D_6600_Icon06_46E6.2bpp" ; $6600, 256 bytes
; C: entry 7 of the {lo,hi,bank} table 06:46EF, 256 bytes each (constant pitch)
Gfx_0D_6700_Icon06_46E6::
    INCBIN "data/bank_0d/Gfx_0D_6700_Icon06_46E6.2bpp" ; $6700, 256 bytes
; C: entry 8 of the {lo,hi,bank} table 06:46EF, 256 bytes each (constant pitch)
Gfx_0D_6800_Icon06_46E6::
    INCBIN "data/bank_0d/Gfx_0D_6800_Icon06_46E6.2bpp" ; $6800, 256 bytes
; C: entry 0 of the {lo,hi,bank} table 06:478F, 256 bytes each (constant pitch)
Gfx_0D_6900_Icon06_4786::
    INCBIN "data/bank_0d/Gfx_0D_6900_Icon06_4786.2bpp" ; $6900, 256 bytes
; C: entry 1 of the {lo,hi,bank} table 06:478F, 256 bytes each (constant pitch)
Gfx_0D_6A00_Icon06_4786::
    INCBIN "data/bank_0d/Gfx_0D_6A00_Icon06_4786.2bpp" ; $6A00, 256 bytes
; C: entry 2 of the {lo,hi,bank} table 06:478F, 256 bytes each (constant pitch)
Gfx_0D_6B00_Icon06_4786::
    INCBIN "data/bank_0d/Gfx_0D_6B00_Icon06_4786.2bpp" ; $6B00, 256 bytes
; C: entry 3 of the {lo,hi,bank} table 06:478F, 256 bytes each (constant pitch)
Gfx_0D_6C00_Icon06_4786::
    INCBIN "data/bank_0d/Gfx_0D_6C00_Icon06_4786.2bpp" ; $6C00, 256 bytes
; C: entry 4 of the {lo,hi,bank} table 06:478F, 256 bytes each (constant pitch)
Gfx_0D_6D00_Icon06_4786::
    INCBIN "data/bank_0d/Gfx_0D_6D00_Icon06_4786.2bpp" ; $6D00, 256 bytes
; I: entry 5 of the {lo,hi,bank} table 06:478F, 256 bytes each (constant pitch)
Gfx_0D_6E00_Icon06_4786::
    INCBIN "data/bank_0d/Gfx_0D_6E00_Icon06_4786.2bpp" ; $6E00, 256 bytes
; C: entry 6 of the {lo,hi,bank} table 06:478F, 256 bytes each (constant pitch)
Gfx_0D_6F00_Icon06_4786::
    INCBIN "data/bank_0d/Gfx_0D_6F00_Icon06_4786.2bpp" ; $6F00, 256 bytes
; I: dot, crosshatch and dither fill tiles plus a few glyph pieces (by eye); owner (review page, 2026-10-13, by eye):
; the span matches the TCRF "Magic bank tile" picture (a dither tile that occurs at many offsets of 0D:7000-765F,
; README 16.24, not a TCRF checklist item). No loader in either ROM ...
Gfx_0D_7000_FillPatternTiles::
    INCBIN "data/bank_0d/Gfx_0D_7000_FillPatternTiles.2bpp" ; $7000, 1632 bytes
; I: TCRF unused graphic: the four kanji 中 前 後 持 as one strip of 16 tiles; pixel match against the TCRF image (15 of
; 16 unique); never on screen (README 16.24)
Unused_TCRF_KanjiMiddleBeforeAfterHave_Gfx::
    INCBIN "data/bank_0d/Unused_TCRF_KanjiMiddleBeforeAfterHave_Gfx.2bpp" ; $7660, 384 bytes
; I: continues the span of Gfx_0D_7000_FillPatternTiles (the label before the TCRF-unused block)
Gfx_0D_77E0_FillPatternTiles_Cont::
    INCBIN "data/bank_0d/Gfx_0D_77E0_FillPatternTiles_Cont.2bpp" ; $77E0, 288 bytes
; C: copied to VRAM/WRAM by Mode0F_State05_ConfirmInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 33 replay(s) of the organic corpus, modes 0F (tcrf_check/assets/l3_names/)
Gfx_0D_7900_Mode0F_State05_ConfirmInit::
    INCBIN "data/bank_0d/Gfx_0D_7900_Mode0F_State05_ConfirmInit.2bpp" ; $7900, 1792 bytes
