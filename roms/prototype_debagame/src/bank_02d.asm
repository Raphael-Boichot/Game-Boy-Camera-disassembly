; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $2D. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $02d", ROMX[$4000], BANK[$2d]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_2D_4000::
    db $2d

; I: leftover: 511 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_2D_4001::
    INCBIN "data/bank_2d/Leftover_2D_4001.bin" ; $4001, 511 bytes
; I: leftover: an exact copy of 5633 bytes of Gfx_01_4001_FNTOOE1 (from 01:4200, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_2D_4200_Gfx_01_4001_FNTOOE1_Part4200::
    INCBIN "data/bank_2d/Leftover_2D_4200_Gfx_01_4001_FNTOOE1_Part4200.bin" ; $4200, 5633 bytes
; I: leftover: an exact copy of 239 bytes of Unused_TCRF_TitleLogoNEO_Map (from 38:5801, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_2D_5801_Unused_TCRF_TitleLogoNEO_Map_Part5801::
    db $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0
    db $a0, $a0, $a0, $a0, $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0
    db $a0, $a0, $a0, $a0, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1a, $1b, $1c, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0
    db $a0, $a0, $a0, $a0, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $2a, $2b, $2c, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0
    db $a0, $a0, $a0, $a0, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c, $3d, $3e, $3f, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0
    db $a0, $a0, $a0, $a0, $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4a, $4b, $4c, $4d, $4e, $4f, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0
    db $a0, $a0, $a0, $a0, $50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5a, $5b, $5c, $5d, $5e, $5f, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0
    db $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $90, $91

; I: leftover: 1 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_2D_58F0::
    db $82

; I: leftover: an exact copy of 336 bytes of Unused_TCRF_TitleLogoNEO_Map (from 38:58F1, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_2D_58F1_Unused_TCRF_TitleLogoNEO_Map_Part58F1::
    INCBIN "data/bank_2d/Leftover_2D_58F1_Unused_TCRF_TitleLogoNEO_Map_Part58F1.bin" ; $58F1, 336 bytes
; I: leftover: an exact copy of Map_01_5A41_MENU1 (01:5A41, 576 bytes) that nothing in this build reads, runs or
; explains (never read nor run in the L2 runs)
Leftover_2D_5A41_Map_01_5A41_MENU1::
    INCBIN "data/bank_2d/Leftover_2D_5A41_Map_01_5A41_MENU1.bin" ; $5A41, 576 bytes
; I: leftover: an exact copy of Unused_TCRF_FacePhoto5_SIMO_Gfx (01:5C81, 3584 bytes) that nothing in this build
; reads, runs or explains (never read nor run in the L2 runs)
Leftover_2D_5C81_Unused_TCRF_FacePhoto5_SIMO_Gfx::
    INCBIN "data/bank_2d/Leftover_2D_5C81_Unused_TCRF_FacePhoto5_SIMO_Gfx.bin" ; $5C81, 9086 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_2D_7FFF::
    db $2d
