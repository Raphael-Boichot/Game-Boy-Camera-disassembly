; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $02. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $002", ROMX[$4000], BANK[$2]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_02_4000::
    db $02

; C: FNTOOE2 in both old symbol tables (same bank and address); this build copies the block here: Gfx: 2bpp tiles
; copied to VRAM by 00:06C0, 00:0797, 00:094E, 00:0A85, 00:0D57, 00:19C9
Gfx_02_4001_FNTOOE2::
    INCBIN "data/bank_02/Gfx_02_4001_FNTOOE2.2bpp" ; $4001, 736 bytes
; I: TCRF Proto:Game Boy Camera (Debagame Tester) unused graphic: the arrow-on-a-string cursor, top row (tiles $2E-$2F
; of the sheet Gfx_02_4001_FNTOOE2; bottom row at 02:43E1); exact match of the TCRF image; copied to VRAM with the
; sheet in the L2 runs, but no map or sprite of this build is known to ...
Unused_TCRF_ArrowCursor_TopRow_Gfx::
    INCBIN "data/bank_02/Unused_TCRF_ArrowCursor_TopRow_Gfx.2bpp" ; $42E1, 32 bytes
; C: the sheet Gfx_02_4001_FNTOOE2 again after the cursor top row (the Japanese convention for the tiles around an
; unused row: Gfx_BB_AAAA_<sheet>_TilesXXtoYY)
Gfx_02_4301_FNTOOE2_Tiles30to3D::
    INCBIN "data/bank_02/Gfx_02_4301_FNTOOE2_Tiles30to3D.2bpp" ; $4301, 224 bytes
; I: TCRF Proto:Game Boy Camera (Debagame Tester) unused graphic: the arrow-on-a-string cursor, bottom row (tiles
; $3E-$3F of Gfx_02_4001_FNTOOE2; top row at 02:42E1)
Unused_TCRF_ArrowCursor_BottomRow_Gfx::
    INCBIN "data/bank_02/Unused_TCRF_ArrowCursor_BottomRow_Gfx.2bpp" ; $43E1, 32 bytes
; C: the sheet Gfx_02_4001_FNTOOE2 again after the cursor bottom row, to its end
Gfx_02_4401_FNTOOE2_Tiles40to17F::
    INCBIN "data/bank_02/Gfx_02_4401_FNTOOE2_Tiles40to17F.2bpp" ; $4401, 5120 bytes
; C: BG_BANK in both old symbol tables (same bank and address); this build copies the block here: Map: tile-map rows
; copied to the BG map by 00:06CC
Map_02_5801_BG_BANK::
    INCBIN "data/bank_02/Map_02_5801_BG_BANK.tilemap" ; $5801, 576 bytes
; C: BGSRAM1 in both old symbol tables (same bank and address); this build copies the block here: Map: tile-map rows
; copied to the BG map by 00:07A3
Map_02_5A41_BGSRAM1::
    INCBIN "data/bank_02/Map_02_5A41_BGSRAM1.tilemap" ; $5A41, 576 bytes
; C: BGSRAM2 in both old symbol tables (same bank and address); this build copies the block here: Map: tile-map rows
; copied to the BG map by 00:095A
Map_02_5C81_BGSRAM2::
    INCBIN "data/bank_02/Map_02_5C81_BGSRAM2.tilemap" ; $5C81, 576 bytes
; C: BGSRAM3 in both old symbol tables (same bank and address); this build copies the block here: Map: tile-map rows
; copied to the BG map by 00:0A91
Map_02_5EC1_BGSRAM3::
    INCBIN "data/bank_02/Map_02_5EC1_BGSRAM3.tilemap" ; $5EC1, 576 bytes
; C: BG_DUMP in both old symbol tables (same bank and address); this build copies the block here: Map: tile-map rows
; copied to the BG map by 00:0D63
Map_02_6101_BG_DUMP::
    INCBIN "data/bank_02/Map_02_6101_BG_DUMP.tilemap" ; $6101, 576 bytes
; C: BGPROTEC in both old symbol tables (same bank and address); this build copies the block here: Map: tile-map rows
; copied to the BG map by 00:19D5
Map_02_6341_BGPROTEC::
    INCBIN "data/bank_02/Map_02_6341_BGPROTEC.tilemap" ; $6341, 576 bytes
; I: PROGRAM in both old symbol tables at this bank and address; this build neither copies nor reads it (L2 runs):
; kind not settled
Data_02_6581_PROGRAM::
    db $00, $00, $00, $00, $07, $00, $0f, $07, $18, $08, $30, $10, $30, $10, $30, $10
    db $30, $10, $30, $10, $30, $10, $30, $10, $18, $08, $0f, $07, $07, $00, $00, $00
    db $00, $00, $00, $00, $e0, $00, $f0, $e0, $18, $10, $0c, $08, $0c, $08, $0c, $08
    db $0c, $08, $0c, $08, $0c, $08, $0c, $08, $18, $10, $f0, $e0, $e0

    ; padding
    ds $7c3, $00

; I: leftover: an exact copy of 256 bytes of Gfx_03_4001_FNTOOE3 (from 03:4001, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_02_6D81_Gfx_03_4001_FNTOOE3_Part4001::
    INCBIN "data/bank_02/Leftover_02_6D81_Gfx_03_4001_FNTOOE3_Part4001.bin" ; $6D81, 256 bytes
; I: leftover: an exact copy of 32 bytes of Gfx_01_4001_FNTOOE1 (from 01:4901, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_02_6E81_Gfx_01_4001_FNTOOE1_Part4901::
    db $00, $00, $44, $66, $44, $66, $44, $66, $47, $65, $39, $2d, $39, $29, $10, $18
    db $00, $00, $00, $00, $00, $00, $ce, $eb, $3c, $ae, $e8, $fc, $08, $8c, $c8, $ec

; I: leftover: 15 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_02_6EA1::
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $38, $ef, $28, $ff

; I: leftover: an exact copy of 227 bytes of Gfx_01_4001_FNTOOE1 (from 01:4930, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_02_6EB0_Gfx_01_4001_FNTOOE1_Part4930::
    db $38, $00, $00, $00, $00, $10, $18, $00, $00, $00, $00, $10, $18, $00, $00, $00
    db $00, $00, $00, $00, $00, $10, $18, $00, $00, $00, $00, $10, $18, $20, $30, $00
    db $00, $00, $00, $08, $0c, $10, $18, $20, $30, $20, $30, $20, $30, $10, $18, $08
    db $0c, $00, $00, $20, $30, $10, $18, $08, $0c, $08, $0c, $08, $0c, $10, $18, $20
    db $30, $00, $00, $08, $0c, $10, $18, $20, $30, $40, $60, $20, $30, $10, $18, $08
    db $0c, $00, $00, $20, $30, $10, $18, $08, $0c, $04, $06, $08, $0c, $10, $18, $20
    db $30, $00, $00, $38, $3c, $20, $30, $20, $30, $20, $30, $20, $30, $20, $30, $38
    db $3c, $00, $00, $38, $3c, $08, $0c, $08, $0c, $08, $0c, $08, $0c, $08, $0c, $38
    db $3c, $00, $00, $00, $00, $10, $18, $10, $18, $7c, $7e, $10, $18, $10, $18, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $7c, $7e, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $7c, $7e, $00, $00, $7c, $7e, $00, $00, $00
    db $00, $00, $00, $00, $00, $44, $66, $38, $2c, $10, $18, $38, $2c, $44, $66, $00
    db $00, $00, $00, $02, $03, $04, $06, $08, $0c, $10, $18, $20, $30, $40, $60, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00

; I: leftover: 350 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_02_6F93::
    INCBIN "data/bank_02/Leftover_02_6F93.bin" ; $6F93, 350 bytes
; I: leftover: an exact copy of 1168 bytes of Gfx_01_4001_FNTOOE1 (from 01:4B71, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_02_70F1_Gfx_01_4001_FNTOOE1_Part4B71::
    INCBIN "data/bank_02/Leftover_02_70F1_Gfx_01_4001_FNTOOE1_Part4B71.bin" ; $70F1, 1168 bytes
; C: TCRF Proto:Game Boy Camera (Debagame Tester) unused graphic: the editor UI (LP, SEQ, LPE, TO END, EDIT, A + ...
; CHANGE), 128 tiles in row order (a 128 x 64 sheet, 2,048 B); pixel match against the TCRF image, 0 differing tiles;
; never read nor run in the L2 runs (trace/cov_proto_runs.npz); no type ...
Unused_TCRF_EditorUI_Gfx::
    INCBIN "data/bank_02/Unused_TCRF_EditorUI_Gfx.bin" ; $7581, 2686 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_02_7FFF::
    db $02
