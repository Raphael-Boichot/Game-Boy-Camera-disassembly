; Pocket Camera (Japan) (Rev A), bank $0D. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $00d", ROMX[$4000], BANK[$d]

; C: copied to VRAM/WRAM by Mode16_State00_Init, Mode16_State01_Redraw (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass
; 2026-10-26: read in BGB in 13 replay(s) of the organic corpus, modes 16 (tcrf_check/assets/l3_names/)
Gfx_0D_4000_Mode16_State00_Init::
    INCBIN "data/bank_0d/Gfx_0D_4000_Mode16_State00_Init.2bpp" ; $4000, 2048 bytes
; C: copied to VRAM/WRAM by Mode16_State00_Init, Mode16_State01_Redraw (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass
; 2026-10-26: read in BGB in 13 replay(s) of the organic corpus, modes 16 (tcrf_check/assets/l3_names/)
Gfx_0D_4800_Mode16_State00_Init::
    INCBIN "data/bank_0d/Gfx_0D_4800_Mode16_State00_Init.2bpp" ; $4800, 2048 bytes
; C: copied to VRAM/WRAM by Mode16_State00_Init, Mode16_State01_Redraw (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass
; 2026-10-26: read in BGB in 13 replay(s) of the organic corpus, modes 16 (tcrf_check/assets/l3_names/)
Gfx_0D_5000_Mode16_State00_Init::
    INCBIN "data/bank_0d/Gfx_0D_5000_Mode16_State00_Init.2bpp" ; $5000, 768 bytes
; C: entry 3 of the {lo,hi,bank} table 06:4B17, 640 bytes each (constant pitch)
Gfx_0D_5300_Strip06_4B17::
    INCBIN "data/bank_0d/Gfx_0D_5300_Strip06_4B17.2bpp" ; $5300, 640 bytes
; C: entry 2 of the {lo,hi,bank} table 06:4B17, 640 bytes each (constant pitch)
Gfx_0D_5580_Strip06_4B17::
    INCBIN "data/bank_0d/Gfx_0D_5580_Strip06_4B17.2bpp" ; $5580, 640 bytes
; C: entry 1 of the {lo,hi,bank} table 06:4B17, 640 bytes each (constant pitch)
Gfx_0D_5800_Strip06_4B17::
    INCBIN "data/bank_0d/Gfx_0D_5800_Strip06_4B17.2bpp" ; $5800, 640 bytes
; C: entry 0 of the {lo,hi,bank} table 06:4B17, 640 bytes each (constant pitch)
Gfx_0D_5A80_Strip06_4B17::
    INCBIN "data/bank_0d/Gfx_0D_5A80_Strip06_4B17.2bpp" ; $5A80, 640 bytes
; C: entry 13 of the {lo,hi,bank} table 04:4493, 640 bytes each (constant pitch)
Gfx_0D_5D00_MsgStrip::
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $ff, $fa, $fc, $f9, $fc, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f7, $0f, $07, $03, $7b, $f3, $f3, $f3
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $ff, $f8, $fc, $fb, $f1
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f5, $fa, $f1, $fa, $fa, $f2, $f6, $f2
    db $ff, $ff, $ff, $ff, $ff, $ff, $7f, $ff, $7f, $7f, $7f, $7f, $ff, $7e, $fe, $7e
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $1f, $bf, $3f, $3f, $3f, $7f, $ff, $67
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $08, $b0, $8a, $24, $fd, $38, $7f, $39
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fa, $7c, $41, $e0, $c0, $e9, $c0, $e3
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $8f, $7f, $1e, $0c, $3d, $4e, $4c, $08
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $9b, $27, $11, $0f, $d3, $01, $0f, $03
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $e8, $c2, $e4, $c9, $88, $00, $09, $cc
    db $ff, $ff, $ff, $ff, $ff, $ff, $7f, $ff, $ac, $31, $34, $61, $75, $a1, $f5, $61
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $78, $3c, $5c, $3f, $d8, $8c, $a8, $1d
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $01, $01, $83, $2f, $03, $01, $83, $29
    db $ff, $ff, $ff, $ff, $ff, $ff, $fe, $ff, $fc, $fe, $00, $fe, $00, $80, $fa, $f1
    db $ff, $ff, $ff, $ff, $ff, $ff, $bf, $ff, $3f, $bf, $3e, $bf, $a0, $60, $63, $fc
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $7f, $1f, $07, $4f, $3f
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e7, $f3, $c7, $e7, $8f, $cf, $1f, $9f, $7f, $3f, $ff, $ff, $ff, $ff, $ff, $ff
    db $e7, $c3, $07, $93, $b7, $f3, $f7, $f3, $f7, $f3, $f3, $ff, $ff, $ff, $ff, $ff
    db $e2, $f6, $f6, $e6, $e6, $e6, $c6, $ee, $de, $ef, $ff, $ff, $ff, $ff, $ff, $ff
    db $fe, $7c, $fd, $7c, $dd, $69, $5d, $08, $df, $3c, $ff, $ff, $ff, $ff, $ff, $ff
    db $f7, $e7, $f7, $f3, $e3, $f3, $c1, $03, $dd, $3b, $ff, $ff, $ff, $ff, $ff, $ff
    db $7f, $2f, $67, $0f, $5f, $0f, $2f, $00, $ef, $30, $ff, $ff, $ff, $ff, $ff, $ff
    db $fc, $f3, $f0, $e0, $7c, $fe, $7e, $60, $5f, $e0, $ff, $ff, $ff, $ff, $ff, $ff
    db $ed, $1f, $0c, $1e, $7e, $fc, $fe, $0c, $fe, $0f, $ff, $ff, $ff, $ff, $ff, $ff
    db $63, $87, $77, $03, $f9, $ff, $8d, $73, $83, $03, $ff, $ff, $ff, $ff, $ff, $ff
    db $8d, $dc, $9d, $9c, $38, $9d, $19, $21, $3d, $e3, $ff, $ff, $ff, $ff, $ff, $ff
    db $e9, $e4, $e8, $e4, $e5, $f8, $f8, $e1, $e4, $e0, $ff, $ff, $ff, $ff, $ff, $ff
    db $58, $0c, $ec, $4e, $c0, $ec, $3c, $ce, $0f, $1e, $ff, $ff, $ff, $ff, $ff, $ff
    db $03, $01, $85, $73, $03, $01, $15, $e3, $01, $03, $f7, $ef, $ff, $ff, $ff, $ff
    db $f3, $e7, $cf, $e7, $c7, $ef, $db, $e7, $e8, $f0, $f0, $ff, $ff, $ff, $ff, $ff
    db $f0, $f8, $f3, $f2, $f0, $f0, $ff, $f8, $7e, $7e, $7f, $fe, $ff, $ff, $ff, $ff
    db $3f, $7f, $7f, $3f, $3e, $3c, $7c, $3d, $7e, $7c, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $7f, $7f, $7f, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

    ; padding
    ds $80, $00

; C: entry 0 of the {lo,hi,bank} table 06:46EF, 256 bytes each (constant pitch)
Gfx_0D_6000_Icon06_46EF::
    INCBIN "data/bank_0d/Gfx_0D_6000_Icon06_46EF.2bpp" ; $6000, 256 bytes
; C: entry 1 of the {lo,hi,bank} table 06:46EF, 256 bytes each (constant pitch)
Gfx_0D_6100_Icon06_46EF::
    INCBIN "data/bank_0d/Gfx_0D_6100_Icon06_46EF.2bpp" ; $6100, 256 bytes
; C: entry 3 of the {lo,hi,bank} table 06:46EF, 256 bytes each (constant pitch)
Gfx_0D_6200_Icon06_46EF::
    INCBIN "data/bank_0d/Gfx_0D_6200_Icon06_46EF.2bpp" ; $6200, 256 bytes
; C: entry 2 of the {lo,hi,bank} table 06:46EF, 256 bytes each (constant pitch)
Gfx_0D_6300_Icon06_46EF::
    INCBIN "data/bank_0d/Gfx_0D_6300_Icon06_46EF.2bpp" ; $6300, 256 bytes
; C: entry 4 of the {lo,hi,bank} table 06:46EF, 256 bytes each (constant pitch)
Gfx_0D_6400_Icon06_46EF::
    INCBIN "data/bank_0d/Gfx_0D_6400_Icon06_46EF.2bpp" ; $6400, 256 bytes
; C: entry 5 of the {lo,hi,bank} table 06:46EF, 256 bytes each (constant pitch)
Gfx_0D_6500_Icon06_46EF::
    INCBIN "data/bank_0d/Gfx_0D_6500_Icon06_46EF.2bpp" ; $6500, 256 bytes
; C: entry 6 of the {lo,hi,bank} table 06:46EF, 256 bytes each (constant pitch)
Gfx_0D_6600_Icon06_46EF::
    INCBIN "data/bank_0d/Gfx_0D_6600_Icon06_46EF.2bpp" ; $6600, 256 bytes
; C: entry 7 of the {lo,hi,bank} table 06:46EF, 256 bytes each (constant pitch)
Gfx_0D_6700_Icon06_46EF::
    INCBIN "data/bank_0d/Gfx_0D_6700_Icon06_46EF.2bpp" ; $6700, 256 bytes
; C: entry 8 of the {lo,hi,bank} table 06:46EF, 256 bytes each (constant pitch)
Gfx_0D_6800_Icon06_46EF::
    INCBIN "data/bank_0d/Gfx_0D_6800_Icon06_46EF.2bpp" ; $6800, 256 bytes
; C: entry 0 of the {lo,hi,bank} table 06:478F, 256 bytes each (constant pitch)
Gfx_0D_6900_Icon06_478F::
    INCBIN "data/bank_0d/Gfx_0D_6900_Icon06_478F.2bpp" ; $6900, 256 bytes
; C: entry 1 of the {lo,hi,bank} table 06:478F, 256 bytes each (constant pitch)
Gfx_0D_6A00_Icon06_478F::
    INCBIN "data/bank_0d/Gfx_0D_6A00_Icon06_478F.2bpp" ; $6A00, 256 bytes
; C: entry 2 of the {lo,hi,bank} table 06:478F, 256 bytes each (constant pitch)
Gfx_0D_6B00_Icon06_478F::
    INCBIN "data/bank_0d/Gfx_0D_6B00_Icon06_478F.2bpp" ; $6B00, 256 bytes
; C: entry 3 of the {lo,hi,bank} table 06:478F, 256 bytes each (constant pitch)
Gfx_0D_6C00_Icon06_478F::
    INCBIN "data/bank_0d/Gfx_0D_6C00_Icon06_478F.2bpp" ; $6C00, 256 bytes
; C: entry 4 of the {lo,hi,bank} table 06:478F, 256 bytes each (constant pitch)
Gfx_0D_6D00_Icon06_478F::
    INCBIN "data/bank_0d/Gfx_0D_6D00_Icon06_478F.2bpp" ; $6D00, 256 bytes
; C: entry 5 of the {lo,hi,bank} table 06:478F, 256 bytes each (constant pitch)
Gfx_0D_6E00_Icon06_478F::
    INCBIN "data/bank_0d/Gfx_0D_6E00_Icon06_478F.2bpp" ; $6E00, 256 bytes
; C: entry 6 of the {lo,hi,bank} table 06:478F, 256 bytes each (constant pitch)
Gfx_0D_6F00_Icon06_478F::
    INCBIN "data/bank_0d/Gfx_0D_6F00_Icon06_478F.2bpp" ; $6F00, 256 bytes
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
