; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $2E. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $02e", ROMX[$4000], BANK[$2e]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_2E_4000::
    db $2e

; I: leftover: an exact copy of 92 bytes of Unused_TCRF_FaceDrawing1_FACE5_Gfx (from 06:44DB, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_2E_4001_Unused_TCRF_FaceDrawing1_FACE5_Gfx_Part44DB::
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $01, $ff, $01

; I: leftover: an exact copy of 164 bytes of Unused_TCRF_FaceDrawing4_FACE8_Gfx (from 06:705D, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_2E_405D_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part705D::
    db $ff, $03, $ff, $03, $c0, $c0, $83, $83, $86, $86, $88, $88, $88, $88, $08, $08
    db $04, $04, $07, $07, $00, $00, $ff, $ff, $7c, $7c, $fe, $fe, $fe, $fe, $fe, $fe
    db $fc, $fc, $00, $00, $00, $00, $c0, $c0, $30, $30, $10, $10, $08, $08, $08, $08
    db $08, $08, $f8, $f8, $00, $00, $00, $00, $01, $01, $03, $03, $02, $02, $01, $01
    db $00, $00, $00, $00, $00, $00, $1f, $1f, $f3, $f3, $07, $07, $07, $07, $07, $07
    db $e7, $e7, $1d, $1d, $00, $00, $f0, $f0, $fc, $fc, $f2, $f2, $f9, $f9, $f9, $f9
    db $f1, $f1, $f7, $f7, $03, $02, $03, $02, $03, $02, $03, $02, $03, $02, $03, $02
    db $03, $02, $03, $02, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00

; I: leftover: 3 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_2E_4101::
    db $10, $61, $c2

; I: leftover: an exact copy of 253 bytes of Unused_TCRF_FaceDrawing4_FACE8_Gfx (from 06:7104, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_2E_4104_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part7104::
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $02, $fe
    db $02, $fe, $02, $fe, $02, $fe, $06, $fc, $04, $fc, $04, $fc, $04, $01, $01, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $00
    db $00, $00, $00, $00, $00, $00, $00, $04, $04, $0c, $0c, $08, $08, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $f8, $f8, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $02, $03
    db $02, $03, $02, $03, $02, $03, $02, $03, $02, $03, $02, $03, $02, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00

; I: leftover: an exact copy of 224 bytes of Gfx_02_4001_FNTOOE2 (from 02:4201, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_2E_4201_Gfx_02_4001_FNTOOE2_Part4201::
    db $00, $00, $00, $00, $03, $03, $0e, $0c, $18, $10, $10, $10, $34, $24, $20, $20
    db $00, $00, $00, $00, $c0, $c0, $70, $30, $18, $08, $08, $08, $2c, $24, $04, $04
    db $00, $00, $00, $00, $03, $03, $0e, $0c, $18, $10, $10, $10, $31, $21, $20, $20
    db $00, $00, $00, $00, $c0, $c0, $70, $30, $18, $08, $08, $08, $0c, $0c, $04, $04
    db $00, $00, $00, $00, $03, $03, $0e, $0c, $18, $10, $10, $10, $30, $20, $20, $20
    db $00, $00, $00, $00, $c0, $c0, $70, $30, $18, $08, $08, $08, $4c, $44, $04, $04
    db $00, $00, $00, $00, $03, $03, $0e, $0c, $18, $10, $10, $10, $30, $20, $20, $20
    db $00, $00, $00, $00, $c0, $c0, $70, $30, $18, $08, $08, $08, $2c, $24, $04, $04
    db $00, $00, $00, $00, $03, $03, $0e, $0c, $18, $10, $10, $10, $30, $20, $20, $20
    db $00, $00, $00, $00, $c0, $c0, $70, $30, $18, $08, $08, $08, $1c, $14, $04, $04
    db $00, $00, $00, $00, $03, $03, $0e, $0c, $18, $10, $10, $10, $30, $20, $20, $20
    db $00, $00, $00, $00, $c0, $c0, $70, $30, $18, $08, $08, $08, $0c, $04, $04, $04
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; I: leftover: an exact copy of Unused_TCRF_ArrowCursor_TopRow_Gfx (02:42E1, 32 bytes) that nothing in this build
; reads, runs or explains (never read nor run in the L2 runs)
Leftover_2E_42E1_Unused_TCRF_ArrowCursor_TopRow_Gfx::
    INCBIN "data/bank_2e/Leftover_2E_42E1_Unused_TCRF_ArrowCursor_TopRow_Gfx.2bpp" ; $42E1, 32 bytes
; I: leftover: an exact copy of Gfx_02_4301_FNTOOE2_Tiles30to3D (02:4301, 224 bytes) that nothing in this build reads,
; runs or explains (never read nor run in the L2 runs)
Leftover_2E_4301_Gfx_02_4301_FNTOOE2_Tiles30to3D::
    db $20, $20, $30, $20, $13, $13, $18, $10, $0e, $0c, $03, $03, $00, $00, $00, $00
    db $04, $04, $0c, $04, $c8, $c8, $18, $08, $70, $30, $c0, $c0, $00, $00, $00, $00
    db $20, $20, $30, $20, $10, $10, $18, $10, $0e, $0c, $03, $03, $00, $00, $00, $00
    db $04, $04, $0c, $04, $f8, $f8, $18, $08, $70, $30, $c0, $c0, $00, $00, $00, $00
    db $20, $20, $30, $20, $10, $10, $18, $10, $0e, $0c, $03, $03, $00, $00, $00, $00
    db $04, $04, $0c, $04, $38, $38, $18, $08, $70, $30, $c0, $c0, $00, $00, $00, $00
    db $20, $20, $30, $20, $10, $10, $18, $10, $0e, $0c, $03, $03, $00, $00, $00, $00
    db $04, $04, $0c, $04, $18, $18, $18, $08, $70, $30, $c0, $c0, $00, $00, $00, $00
    db $20, $20, $30, $20, $10, $10, $18, $10, $0e, $0c, $03, $03, $00, $00, $00, $00
    db $04, $04, $0c, $04, $08, $08, $18, $08, $70, $30, $c0, $c0, $00, $00, $00, $00
    db $20, $20, $30, $20, $10, $10, $18, $10, $0e, $0c, $03, $03, $00, $00, $00, $00
    db $04, $04, $0c, $04, $08, $08, $18, $08, $70, $30, $c0, $c0, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; I: leftover: an exact copy of Unused_TCRF_ArrowCursor_BottomRow_Gfx (02:43E1, 32 bytes) that nothing in this build
; reads, runs or explains (never read nor run in the L2 runs)
Leftover_2E_43E1_Unused_TCRF_ArrowCursor_BottomRow_Gfx::
    INCBIN "data/bank_2e/Leftover_2E_43E1_Unused_TCRF_ArrowCursor_BottomRow_Gfx.2bpp" ; $43E1, 32 bytes
; I: leftover: an exact copy of Gfx_02_4401_FNTOOE2_Tiles40to17F (02:4401, 5120 bytes) that nothing in this build
; reads, runs or explains (never read nor run in the L2 runs)
Leftover_2E_4401_Gfx_02_4401_FNTOOE2_Tiles40to17F::
    INCBIN "data/bank_2e/Leftover_2E_4401_Gfx_02_4401_FNTOOE2_Tiles40to17F.bin" ; $4401, 5120 bytes
; I: leftover: an exact copy of Map_02_5801_BG_BANK (02:5801, 576 bytes) that nothing in this build reads, runs or
; explains (never read nor run in the L2 runs)
Leftover_2E_5801_Map_02_5801_BG_BANK::
    INCBIN "data/bank_2e/Leftover_2E_5801_Map_02_5801_BG_BANK.bin" ; $5801, 576 bytes
; I: leftover: an exact copy of Map_02_5A41_BGSRAM1 (02:5A41, 576 bytes) that nothing in this build reads, runs or
; explains (never read nor run in the L2 runs)
Leftover_2E_5A41_Map_02_5A41_BGSRAM1::
    INCBIN "data/bank_2e/Leftover_2E_5A41_Map_02_5A41_BGSRAM1.bin" ; $5A41, 576 bytes
; I: leftover: an exact copy of Map_02_5C81_BGSRAM2 (02:5C81, 576 bytes) that nothing in this build reads, runs or
; explains (never read nor run in the L2 runs)
Leftover_2E_5C81_Map_02_5C81_BGSRAM2::
    INCBIN "data/bank_2e/Leftover_2E_5C81_Map_02_5C81_BGSRAM2.bin" ; $5C81, 576 bytes
; I: leftover: an exact copy of Map_02_5EC1_BGSRAM3 (02:5EC1, 576 bytes) that nothing in this build reads, runs or
; explains (never read nor run in the L2 runs)
Leftover_2E_5EC1_Map_02_5EC1_BGSRAM3::
    INCBIN "data/bank_2e/Leftover_2E_5EC1_Map_02_5EC1_BGSRAM3.bin" ; $5EC1, 576 bytes
; I: leftover: an exact copy of Map_02_6101_BG_DUMP (02:6101, 576 bytes) that nothing in this build reads, runs or
; explains (never read nor run in the L2 runs)
Leftover_2E_6101_Map_02_6101_BG_DUMP::
    INCBIN "data/bank_2e/Leftover_2E_6101_Map_02_6101_BG_DUMP.bin" ; $6101, 576 bytes
; I: leftover: an exact copy of Map_02_6341_BGPROTEC (02:6341, 576 bytes) that nothing in this build reads, runs or
; explains (never read nor run in the L2 runs)
Leftover_2E_6341_Map_02_6341_BGPROTEC::
    INCBIN "data/bank_2e/Leftover_2E_6341_Map_02_6341_BGPROTEC.bin" ; $6341, 576 bytes
; I: leftover: 61 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_2E_6581::
    db $00, $00, $00, $00, $07, $00, $0f, $07, $18, $08, $30, $10, $30, $10, $30, $10
    db $30, $10, $30, $10, $30, $10, $30, $10, $18, $08, $0f, $07, $07, $00, $00, $00
    db $00, $00, $00, $00, $e0, $00, $f0, $e0, $18, $10, $0c, $08, $0c, $08, $0c, $08
    db $0c, $08, $0c, $08, $0c, $08, $0c, $08, $18, $10, $f0, $e0, $e0

    ; padding
    ds $7c3, $00

; I: leftover: an exact copy of 256 bytes of Gfx_03_4001_FNTOOE3 (from 03:4001, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_2E_6D81_Gfx_03_4001_FNTOOE3_Part4001::
    INCBIN "data/bank_2e/Leftover_2E_6D81_Gfx_03_4001_FNTOOE3_Part4001.bin" ; $6D81, 256 bytes
; I: leftover: an exact copy of 32 bytes of Gfx_01_4001_FNTOOE1 (from 01:4901, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_2E_6E81_Gfx_01_4001_FNTOOE1_Part4901::
    db $00, $00, $44, $66, $44, $66, $44, $66, $47, $65, $39, $2d, $39, $29, $10, $18
    db $00, $00, $00, $00, $00, $00, $ce, $eb, $3c, $ae, $e8, $fc, $08, $8c, $c8, $ec

; I: leftover: 15 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_2E_6EA1::
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $38, $ef, $28, $ff

; I: leftover: an exact copy of 227 bytes of Gfx_01_4001_FNTOOE1 (from 01:4930, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_2E_6EB0_Gfx_01_4001_FNTOOE1_Part4930::
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
Leftover_2E_6F93::
    INCBIN "data/bank_2e/Leftover_2E_6F93.bin" ; $6F93, 350 bytes
; I: leftover: an exact copy of 1168 bytes of Gfx_01_4001_FNTOOE1 (from 01:4B71, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_2E_70F1_Gfx_01_4001_FNTOOE1_Part4B71::
    INCBIN "data/bank_2e/Leftover_2E_70F1_Gfx_01_4001_FNTOOE1_Part4B71.bin" ; $70F1, 1168 bytes
; I: leftover: an exact copy of Unused_TCRF_EditorUI_Gfx (02:7581, 2048 bytes) that nothing in this build reads, runs
; or explains (never read nor run in the L2 runs)
Leftover_2E_7581_Unused_TCRF_EditorUI_Gfx::
    INCBIN "data/bank_2e/Leftover_2E_7581_Unused_TCRF_EditorUI_Gfx.bin" ; $7581, 2686 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_2E_7FFF::
    db $2e
