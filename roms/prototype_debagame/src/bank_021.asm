; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $21. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $021", ROMX[$4000], BANK[$21]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_21_4000::
    db $21

; I: leftover text: 255 bytes of the developers' assembler source in clear (0 listing lines, 6 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_21_4001_AsmSource::
    db "D,$ED,$6D,$6D", $0d, $0a, $09, "DEFB", $09, "$00,$00,$06,$06,$0F,$0F,$E6,$E6", $09, ";00F4", $0d, $0a, $09, "DEFB", $09, "$36,$B6,$36,$B6,$36,$B6,$36,$B6", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$73,$73", $09, ";00F5", $0d, $0a, $09, "DEFB", $09, "$8A,$DB,$FA,$FB,$82,$C3,$7A,$7B", $0d, $0a, $09, "DEFB", $09, "$00,$00,$01,$01,$01,$01,$C7,$C7", $09, ";00F6", $0d, $0a, $09, "DEFB", $09, "$6D,$6D,$6D,$6D,$6D,$"

; I: leftover: 4 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_21_4100::
    db $00, $a0, $1c, $c2

; I: leftover text: 252 bytes of the developers' assembler source in clear (0 listing lines, 6 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_21_4104_AsmSource::
    db "67,$67", $0d, $0a, $09, "DEFB", $09, "$00,$00,$80,$80,$80,$80,$9C,$9C", $09, ";00F7", $0d, $0a, $09, "DEFB", $09, "$B6,$B6,$B6,$B6,$B6,$B6,$9C,$9C", $0d, $0a, $09, "DEFB", $09, "$00,$00,$0C,$1E,$12,$12,$12,$16", $09, ";00F8", $0d, $0a, $09, "DEFB", $09, "$1C,$3C,$24,$34,$22,$27,$22,$22", $0d, $0a, $09, "DEFB", $09, "$00,$00,$01,$03,$42,$E2,$A2,$A2", $09, ";00F9", $0d, $0a, $09, "DEFB", $09, "$43,$67,$A4,$B6,$A4,$E4,$"

; I: leftover: an exact copy of 531 bytes of Gfx_01_4001_FNTOOE1 (from 01:45E2, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_21_4200_Gfx_01_4001_FNTOOE1_Part45E2::
    INCBIN "data/bank_21/Leftover_21_4200_Gfx_01_4001_FNTOOE1_Part45E2.bin" ; $4200, 531 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_21_4413::
    db $01, $01, $f5, $47, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Gfx_01_4001_FNTOOE1 (from 01:47F5, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_21_4419_Gfx_01_4001_FNTOOE1_Part47F5::
    INCBIN "data/bank_21/Leftover_21_4419_Gfx_01_4001_FNTOOE1_Part47F5.bin" ; $4419, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_21_4813::
    db $01, $01, $ef, $4b, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Gfx_01_4001_FNTOOE1 (from 01:4BEF, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_21_4819_Gfx_01_4001_FNTOOE1_Part4BEF::
    INCBIN "data/bank_21/Leftover_21_4819_Gfx_01_4001_FNTOOE1_Part4BEF.bin" ; $4819, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_21_4C13::
    db $01, $01, $e9, $4f, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Gfx_01_4001_FNTOOE1 (from 01:4FE9, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_21_4C19_Gfx_01_4001_FNTOOE1_Part4FE9::
    INCBIN "data/bank_21/Leftover_21_4C19_Gfx_01_4001_FNTOOE1_Part4FE9.bin" ; $4C19, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_21_5013::
    db $01, $01, $e3, $53, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Gfx_01_4001_FNTOOE1 (from 01:53E3, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_21_5019_Gfx_01_4001_FNTOOE1_Part53E3::
    INCBIN "data/bank_21/Leftover_21_5019_Gfx_01_4001_FNTOOE1_Part53E3.bin" ; $5019, 1018 bytes
; I: leftover: 5 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_21_5413::
    db $01, $01, $dd, $57, $24

    ; padding
    ds $25, $00

    db $01, $01, $01, $58, $40, $02

; I: leftover: an exact copy of 239 bytes of Unused_TCRF_TitleLogoNEO_Map (from 38:5801, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_21_5443_Unused_TCRF_TitleLogoNEO_Map_Part5801::
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
Leftover_21_5532::
    db $82

; I: leftover: an exact copy of 336 bytes of Unused_TCRF_TitleLogoNEO_Map (from 38:58F1, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_21_5533_Unused_TCRF_TitleLogoNEO_Map_Part58F1::
    INCBIN "data/bank_21/Leftover_21_5533_Unused_TCRF_TitleLogoNEO_Map_Part58F1.bin" ; $5533, 336 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_21_5683::
    db $01, $01, $41, $5a, $40, $02

; I: leftover: an exact copy of Map_01_5A41_MENU1 (01:5A41, 576 bytes) that nothing in this build reads, runs or
; explains (never read nor run in the L2 runs)
Leftover_21_5689_Map_01_5A41_MENU1::
    INCBIN "data/bank_21/Leftover_21_5689_Map_01_5A41_MENU1.bin" ; $5689, 576 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_21_58C9::
    db $01, $01, $81, $5c, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto5_SIMO_Gfx (from 01:5C81, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_21_58CF_Unused_TCRF_FacePhoto5_SIMO_Gfx_Part5C81::
    INCBIN "data/bank_21/Leftover_21_58CF_Unused_TCRF_FacePhoto5_SIMO_Gfx_Part5C81.bin" ; $58CF, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_21_5CC9::
    db $01, $01, $7b, $60, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto5_SIMO_Gfx (from 01:607B, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_21_5CCF_Unused_TCRF_FacePhoto5_SIMO_Gfx_Part607B::
    INCBIN "data/bank_21/Leftover_21_5CCF_Unused_TCRF_FacePhoto5_SIMO_Gfx_Part607B.bin" ; $5CCF, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_21_60C9::
    db $01, $01, $75, $64, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto5_SIMO_Gfx (from 01:6475, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_21_60CF_Unused_TCRF_FacePhoto5_SIMO_Gfx_Part6475::
    INCBIN "data/bank_21/Leftover_21_60CF_Unused_TCRF_FacePhoto5_SIMO_Gfx_Part6475.bin" ; $60CF, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_21_64C9::
    db $01, $01, $6f, $68, $12, $02

; I: leftover: an exact copy of 530 bytes of Unused_TCRF_FacePhoto5_SIMO_Gfx (from 01:686F, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_21_64CF_Unused_TCRF_FacePhoto5_SIMO_Gfx_Part686F::
    INCBIN "data/bank_21/Leftover_21_64CF_Unused_TCRF_FacePhoto5_SIMO_Gfx_Part686F.bin" ; $64CF, 530 bytes
; I: leftover: 20 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_21_66E1::
    db $01, $01, $ff, $7f, $01, $00, $01, $01, $02, $00, $40, $01, $00, $02, $01, $02
    db $01, $40, $fa, $03

; I: leftover: an exact copy of Gfx_02_4001_FNTOOE2 (02:4001, 736 bytes) that nothing in this build reads, runs or
; explains (never read nor run in the L2 runs)
Leftover_21_66F5_Gfx_02_4001_FNTOOE2::
    INCBIN "data/bank_21/Leftover_21_66F5_Gfx_02_4001_FNTOOE2.bin" ; $66F5, 736 bytes
; I: leftover: an exact copy of Unused_TCRF_ArrowCursor_TopRow_Gfx (02:42E1, 32 bytes) that nothing in this build
; reads, runs or explains (never read nor run in the L2 runs)
Leftover_21_69D5_Unused_TCRF_ArrowCursor_TopRow_Gfx::
    INCBIN "data/bank_21/Leftover_21_69D5_Unused_TCRF_ArrowCursor_TopRow_Gfx.2bpp" ; $69D5, 32 bytes
; I: leftover: an exact copy of Gfx_02_4301_FNTOOE2_Tiles30to3D (02:4301, 224 bytes) that nothing in this build reads,
; runs or explains (never read nor run in the L2 runs)
Leftover_21_69F5_Gfx_02_4301_FNTOOE2_Tiles30to3D::
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

; I: leftover: 38 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_21_6AD5::
    db $01, $00, $05, $00, $00, $03, $7e, $7f, $7e, $7f, $7e, $7f, $01, $00, $00, $00
    db $00, $80, $30, $a0, $38, $b0, $fe, $7c, $ff, $7f, $01, $02, $fb, $43, $fa, $03
    db $fe, $7c, $38, $b0, $30, $20

; I: leftover: an exact copy of 1012 bytes of Gfx_02_4401_FNTOOE2_Tiles40to17F (from 02:4401, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_21_6AFB_Gfx_02_4401_FNTOOE2_Tiles40to17F_Part4401::
    INCBIN "data/bank_21/Leftover_21_6AFB_Gfx_02_4401_FNTOOE2_Tiles40to17F_Part4401.bin" ; $6AFB, 1012 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_21_6EEF::
    db $01, $02, $f5, $47, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Gfx_02_4401_FNTOOE2_Tiles40to17F (from 02:47F5, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_21_6EF5_Gfx_02_4401_FNTOOE2_Tiles40to17F_Part47F5::
    INCBIN "data/bank_21/Leftover_21_6EF5_Gfx_02_4401_FNTOOE2_Tiles40to17F_Part47F5.bin" ; $6EF5, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_21_72EF::
    db $01, $02, $ef, $4b, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Gfx_02_4401_FNTOOE2_Tiles40to17F (from 02:4BEF, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_21_72F5_Gfx_02_4401_FNTOOE2_Tiles40to17F_Part4BEF::
    INCBIN "data/bank_21/Leftover_21_72F5_Gfx_02_4401_FNTOOE2_Tiles40to17F_Part4BEF.bin" ; $72F5, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_21_76EF::
    db $01, $02, $e9, $4f, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Gfx_02_4401_FNTOOE2_Tiles40to17F (from 02:4FE9, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_21_76F5_Gfx_02_4401_FNTOOE2_Tiles40to17F_Part4FE9::
    INCBIN "data/bank_21/Leftover_21_76F5_Gfx_02_4401_FNTOOE2_Tiles40to17F_Part4FE9.bin" ; $76F5, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_21_7AEF::
    db $01, $02, $e3, $53, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Gfx_02_4401_FNTOOE2_Tiles40to17F (from 02:53E3, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_21_7AF5_Gfx_02_4401_FNTOOE2_Tiles40to17F_Part53E3::
    INCBIN "data/bank_21/Leftover_21_7AF5_Gfx_02_4401_FNTOOE2_Tiles40to17F_Part53E3.bin" ; $7AF5, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_21_7EEF::
    db $01, $02, $dd, $57, $24, $00

; I: leftover: an exact copy of 36 bytes of Gfx_02_4401_FNTOOE2_Tiles40to17F (from 02:57DD, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_21_7EF5_Gfx_02_4401_FNTOOE2_Tiles40to17F_Part57DD::
    db $48, $48, $70, $70, $00, $00, $78, $78, $40, $40, $40, $40, $70, $70, $40, $40
    db $40, $40, $78, $78, $00, $00, $78, $78, $40, $40, $40, $40, $70, $70, $40, $40
    db $40, $40, $40, $40

; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_21_7F19::
    db $01, $02, $01, $58, $40, $02

; I: leftover: an exact copy of 224 bytes of Map_02_5801_BG_BANK (from 02:5801, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_21_7F1F_Map_02_5801_BG_BANK_Part5801::
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $00, $01, $02, $03, $04, $05, $06, $07, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $10, $11, $12, $13, $14, $15, $16, $17, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $a2, $a3, $a3, $a3, $a3, $a3, $a3, $a3, $a3, $a3, $a3, $a4, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $a5, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a6, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $a5, $a0, $88, $cd, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a6, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_21_7FFF::
    db $21
