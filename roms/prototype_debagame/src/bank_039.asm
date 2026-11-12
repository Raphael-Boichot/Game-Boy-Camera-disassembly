; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $39. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $039", ROMX[$4000], BANK[$39]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_39_4000::
    db $39

    ; padding
    ds $79, $00

; I: leftover: 8 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_39_407A::
    db $55, $a0, $ff, $03, $d0, $00, $e8, $4f

    ; padding
    ds $7f, $00

    db $f0, $18, $c2

    ; padding
    ds $79, $00

; I: leftover: an exact copy of 356 bytes of Gfx_02_4001_FNTOOE2 (from 02:417D, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_39_417D_Gfx_02_4001_FNTOOE2_Part417D::
    INCBIN "data/bank_39/Leftover_39_417D_Gfx_02_4001_FNTOOE2_Part417D.bin" ; $417D, 356 bytes
; I: leftover: an exact copy of Unused_TCRF_ArrowCursor_TopRow_Gfx (02:42E1, 32 bytes) that nothing in this build
; reads, runs or explains (never read nor run in the L2 runs)
Leftover_39_42E1_Unused_TCRF_ArrowCursor_TopRow_Gfx::
    INCBIN "data/bank_39/Leftover_39_42E1_Unused_TCRF_ArrowCursor_TopRow_Gfx.2bpp" ; $42E1, 32 bytes
; I: leftover: an exact copy of Gfx_02_4301_FNTOOE2_Tiles30to3D (02:4301, 224 bytes) that nothing in this build reads,
; runs or explains (never read nor run in the L2 runs)
Leftover_39_4301_Gfx_02_4301_FNTOOE2_Tiles30to3D::
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
Leftover_39_43E1_Unused_TCRF_ArrowCursor_BottomRow_Gfx::
    INCBIN "data/bank_39/Leftover_39_43E1_Unused_TCRF_ArrowCursor_BottomRow_Gfx.2bpp" ; $43E1, 32 bytes
; I: leftover: an exact copy of Gfx_02_4401_FNTOOE2_Tiles40to17F (02:4401, 5120 bytes) that nothing in this build
; reads, runs or explains (never read nor run in the L2 runs)
Leftover_39_4401_Gfx_02_4401_FNTOOE2_Tiles40to17F::
    INCBIN "data/bank_39/Leftover_39_4401_Gfx_02_4401_FNTOOE2_Tiles40to17F.bin" ; $4401, 5120 bytes
; I: leftover: an exact copy of Map_02_5801_BG_BANK (02:5801, 576 bytes) that nothing in this build reads, runs or
; explains (never read nor run in the L2 runs)
Leftover_39_5801_Map_02_5801_BG_BANK::
    INCBIN "data/bank_39/Leftover_39_5801_Map_02_5801_BG_BANK.bin" ; $5801, 576 bytes
; I: leftover: an exact copy of Map_02_5A41_BGSRAM1 (02:5A41, 576 bytes) that nothing in this build reads, runs or
; explains (never read nor run in the L2 runs)
Leftover_39_5A41_Map_02_5A41_BGSRAM1::
    INCBIN "data/bank_39/Leftover_39_5A41_Map_02_5A41_BGSRAM1.bin" ; $5A41, 576 bytes
; I: leftover: an exact copy of Map_02_5C81_BGSRAM2 (02:5C81, 576 bytes) that nothing in this build reads, runs or
; explains (never read nor run in the L2 runs)
Leftover_39_5C81_Map_02_5C81_BGSRAM2::
    INCBIN "data/bank_39/Leftover_39_5C81_Map_02_5C81_BGSRAM2.bin" ; $5C81, 576 bytes
; I: leftover: an exact copy of Map_02_5EC1_BGSRAM3 (02:5EC1, 576 bytes) that nothing in this build reads, runs or
; explains (never read nor run in the L2 runs)
Leftover_39_5EC1_Map_02_5EC1_BGSRAM3::
    INCBIN "data/bank_39/Leftover_39_5EC1_Map_02_5EC1_BGSRAM3.bin" ; $5EC1, 576 bytes
; I: leftover: an exact copy of Map_02_6101_BG_DUMP (02:6101, 576 bytes) that nothing in this build reads, runs or
; explains (never read nor run in the L2 runs)
Leftover_39_6101_Map_02_6101_BG_DUMP::
    INCBIN "data/bank_39/Leftover_39_6101_Map_02_6101_BG_DUMP.bin" ; $6101, 576 bytes
; I: leftover: an exact copy of Map_02_6341_BGPROTEC (02:6341, 576 bytes) that nothing in this build reads, runs or
; explains (never read nor run in the L2 runs)
Leftover_39_6341_Map_02_6341_BGPROTEC::
    INCBIN "data/bank_39/Leftover_39_6341_Map_02_6341_BGPROTEC.bin" ; $6341, 576 bytes
; I: leftover: 61 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_39_6581::
    db $00, $00, $00, $00, $07, $00, $0f, $07, $18, $08, $30, $10, $30, $10, $30, $10
    db $30, $10, $30, $10, $30, $10, $30, $10, $18, $08, $0f, $07, $07, $00, $00, $00
    db $00, $00, $00, $00, $e0, $00, $f0, $e0, $18, $10, $0c, $08, $0c, $08, $0c, $08
    db $0c, $08, $0c, $08, $0c, $08, $0c, $08, $18, $10, $f0, $e0, $e0

    ; padding
    ds $7c3, $00

; I: leftover: an exact copy of 256 bytes of Gfx_03_4001_FNTOOE3 (from 03:4001, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_39_6D81_Gfx_03_4001_FNTOOE3_Part4001::
    INCBIN "data/bank_39/Leftover_39_6D81_Gfx_03_4001_FNTOOE3_Part4001.bin" ; $6D81, 256 bytes
; I: leftover: an exact copy of 32 bytes of Gfx_01_4001_FNTOOE1 (from 01:4901, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_39_6E81_Gfx_01_4001_FNTOOE1_Part4901::
    db $00, $00, $44, $66, $44, $66, $44, $66, $47, $65, $39, $2d, $39, $29, $10, $18
    db $00, $00, $00, $00, $00, $00, $ce, $eb, $3c, $ae, $e8, $fc, $08, $8c, $c8, $ec

; I: leftover: 15 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_39_6EA1::
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $38, $ef, $28, $ff

; I: leftover: an exact copy of 227 bytes of Gfx_01_4001_FNTOOE1 (from 01:4930, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_39_6EB0_Gfx_01_4001_FNTOOE1_Part4930::
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
Leftover_39_6F93::
    INCBIN "data/bank_39/Leftover_39_6F93.bin" ; $6F93, 350 bytes
; I: leftover: an exact copy of 1168 bytes of Gfx_01_4001_FNTOOE1 (from 01:4B71, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_39_70F1_Gfx_01_4001_FNTOOE1_Part4B71::
    INCBIN "data/bank_39/Leftover_39_70F1_Gfx_01_4001_FNTOOE1_Part4B71.bin" ; $70F1, 1168 bytes
; I: leftover: an exact copy of Unused_TCRF_EditorUI_Gfx (02:7581, 2048 bytes) that nothing in this build reads, runs
; or explains (never read nor run in the L2 runs)
Leftover_39_7581_Unused_TCRF_EditorUI_Gfx::
    INCBIN "data/bank_39/Leftover_39_7581_Unused_TCRF_EditorUI_Gfx.bin" ; $7581, 2686 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_39_7FFF::
    db $39
