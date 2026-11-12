; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $29. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $029", ROMX[$4000], BANK[$29]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_29_4000::
    db $29

; I: leftover text: 255 bytes of the developers' assembler source in clear (0 listing lines, 6 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_29_4001_AsmSource::
    db "D,$ED,$6D,$6D", $0d, $0a, $09, "DEFB", $09, "$00,$00,$06,$06,$0F,$0F,$E6,$E6", $09, ";00F4", $0d, $0a, $09, "DEFB", $09, "$36,$B6,$36,$B6,$36,$B6,$36,$B6", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$73,$73", $09, ";00F5", $0d, $0a, $09, "DEFB", $09, "$8A,$DB,$FA,$FB,$82,$C3,$7A,$7B", $0d, $0a, $09, "DEFB", $09, "$00,$00,$01,$01,$01,$01,$C7,$C7", $09, ";00F6", $0d, $0a, $09, "DEFB", $09, "$6D,$6D,$6D,$6D,$6D,$"

; I: leftover: 4 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_29_4100::
    db $00, $20, $52, $c2

; I: leftover text: 253 bytes of the developers' assembler source in clear (0 listing lines, 6 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_29_4104_AsmSource::
    db "67,$67", $0d, $0a, $09, "DEFB", $09, "$00,$00,$80,$80,$80,$80,$9C,$9C", $09, ";00F7", $0d, $0a, $09, "DEFB", $09, "$B6,$B6,$B6,$B6,$B6,$B6,$9C,$9C", $0d, $0a, $09, "DEFB", $09, "$00,$00,$0C,$1E,$12,$12,$12,$16", $09, ";00F8", $0d, $0a, $09, "DEFB", $09, "$1C,$3C,$24,$34,$22,$27,$22,$22", $0d, $0a, $09, "DEFB", $09, "$00,$00,$01,$03,$42,$E2,$A2,$A2", $09, ";00F9", $0d, $0a, $09, "DEFB", $09, "$43,$67,$A4,$B6,$A4,$E4,$]"

; I: leftover: an exact copy of 400 bytes of Unused_TCRF_FacePhoto9_HOI_L_Gfx (from 05:6871, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_29_4201_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part6871::
    INCBIN "data/bank_29/Leftover_29_4201_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part6871.bin" ; $4201, 400 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_29_4391::
    db $01, $05, $01, $6a, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto10_HOI_R_Gfx (from 05:6A01, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_29_4397_Unused_TCRF_FacePhoto10_HOI_R_Gfx_Part6A01::
    INCBIN "data/bank_29/Leftover_29_4397_Unused_TCRF_FacePhoto10_HOI_R_Gfx_Part6A01.bin" ; $4397, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_29_4791::
    db $01, $05, $fb, $6d, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto10_HOI_R_Gfx (from 05:6DFB, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_29_4797_Unused_TCRF_FacePhoto10_HOI_R_Gfx_Part6DFB::
    INCBIN "data/bank_29/Leftover_29_4797_Unused_TCRF_FacePhoto10_HOI_R_Gfx_Part6DFB.bin" ; $4797, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_29_4B91::
    db $01, $05, $f5, $71, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto10_HOI_R_Gfx (from 05:71F5, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_29_4B97_Unused_TCRF_FacePhoto10_HOI_R_Gfx_Part71F5::
    INCBIN "data/bank_29/Leftover_29_4B97_Unused_TCRF_FacePhoto10_HOI_R_Gfx_Part71F5.bin" ; $4B97, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_29_4F91::
    db $01, $05, $ef, $75, $12, $02

; I: leftover: an exact copy of 530 bytes of Unused_TCRF_FacePhoto10_HOI_R_Gfx (from 05:75EF, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_29_4F97_Unused_TCRF_FacePhoto10_HOI_R_Gfx_Part75EF::
    INCBIN "data/bank_29/Leftover_29_4F97_Unused_TCRF_FacePhoto10_HOI_R_Gfx_Part75EF.bin" ; $4F97, 530 bytes
; I: leftover: 20 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_29_51A9::
    db $01, $05, $ff, $7f, $01, $00, $05, $01, $06, $00, $40, $01, $00, $06, $01, $06
    db $01, $40, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FaceDrawing1_FACE5_Gfx (from 06:4001, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_29_51BD_Unused_TCRF_FaceDrawing1_FACE5_Gfx_Part4001::
    INCBIN "data/bank_29/Leftover_29_51BD_Unused_TCRF_FaceDrawing1_FACE5_Gfx_Part4001.bin" ; $51BD, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_29_55B7::
    db $01, $06, $fb, $43, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FaceDrawing1_FACE5_Gfx (from 06:43FB, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_29_55BD_Unused_TCRF_FaceDrawing1_FACE5_Gfx_Part43FB::
    INCBIN "data/bank_29/Leftover_29_55BD_Unused_TCRF_FaceDrawing1_FACE5_Gfx_Part43FB.bin" ; $55BD, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_29_59B7::
    db $01, $06, $f5, $47, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FaceDrawing1_FACE5_Gfx (from 06:47F5, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_29_59BD_Unused_TCRF_FaceDrawing1_FACE5_Gfx_Part47F5::
    INCBIN "data/bank_29/Leftover_29_59BD_Unused_TCRF_FaceDrawing1_FACE5_Gfx_Part47F5.bin" ; $59BD, 1018 bytes
; I: leftover: 5 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_29_5DB7::
    db $01, $06, $ef, $4b, $12

; I: leftover: an exact copy of 99 bytes of Unused_TCRF_FaceDrawing1_FACE5_Gfx (from 06:44C0, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_29_5DBC_Unused_TCRF_FaceDrawing1_FACE5_Gfx_Part44C0::
    db $02, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00

; I: leftover: an exact copy of 432 bytes of Unused_TCRF_FaceDrawing1_FACE5_Gfx (from 06:4C51, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_29_5E1F_Unused_TCRF_FaceDrawing1_FACE5_Gfx_Part4C51::
    INCBIN "data/bank_29/Leftover_29_5E1F_Unused_TCRF_FaceDrawing1_FACE5_Gfx_Part4C51.bin" ; $5E1F, 432 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_29_5FCF::
    db $01, $06, $01, $4e, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FaceDrawing2_FACE6_Gfx (from 06:4E01, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_29_5FD5_Unused_TCRF_FaceDrawing2_FACE6_Gfx_Part4E01::
    INCBIN "data/bank_29/Leftover_29_5FD5_Unused_TCRF_FaceDrawing2_FACE6_Gfx_Part4E01.bin" ; $5FD5, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_29_63CF::
    db $01, $06, $fb, $51, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FaceDrawing2_FACE6_Gfx (from 06:51FB, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_29_63D5_Unused_TCRF_FaceDrawing2_FACE6_Gfx_Part51FB::
    INCBIN "data/bank_29/Leftover_29_63D5_Unused_TCRF_FaceDrawing2_FACE6_Gfx_Part51FB.bin" ; $63D5, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_29_67CF::
    db $01, $06, $f5, $55, $fa, $03

; I: leftover: an exact copy of 124 bytes of Unused_TCRF_FaceDrawing2_FACE6_Gfx (from 06:53F5, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_29_67D5_Unused_TCRF_FaceDrawing2_FACE6_Gfx_Part53F5::
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $03, $ff, $03
    db $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

; I: leftover: an exact copy of 894 bytes of Unused_TCRF_FaceDrawing2_FACE6_Gfx (from 06:5671, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_29_6851_Unused_TCRF_FaceDrawing2_FACE6_Gfx_Part5671::
    INCBIN "data/bank_29/Leftover_29_6851_Unused_TCRF_FaceDrawing2_FACE6_Gfx_Part5671.bin" ; $6851, 894 bytes
; I: leftover: 5 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_29_6BCF::
    db $01, $06, $ef, $59, $12

; I: leftover: an exact copy of 100 bytes of Unused_TCRF_FaceDrawing1_FACE5_Gfx (from 06:44C0, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_29_6BD4_Unused_TCRF_FaceDrawing1_FACE5_Gfx_Part44C0::
    db $02, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff

; I: leftover: an exact copy of 431 bytes of Unused_TCRF_FaceDrawing2_FACE6_Gfx (from 06:5A52, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_29_6C38_Unused_TCRF_FaceDrawing2_FACE6_Gfx_Part5A52::
    INCBIN "data/bank_29/Leftover_29_6C38_Unused_TCRF_FaceDrawing2_FACE6_Gfx_Part5A52.bin" ; $6C38, 431 bytes
; I: leftover: 1030 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_29_6DE7::
    INCBIN "data/bank_29/Leftover_29_6DE7.bin" ; $6DE7, 1030 bytes
; I: leftover: an exact copy of 133 bytes of Unused_TCRF_FaceDrawing2_FACE6_Gfx (from 06:50DB, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_29_71ED_Unused_TCRF_FaceDrawing2_FACE6_Gfx_Part50DB::
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $03, $ff

; I: leftover: an exact copy of 885 bytes of Unused_TCRF_FaceDrawing3_FACE7_Gfx (from 06:6080, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_29_7272_Unused_TCRF_FaceDrawing3_FACE7_Gfx_Part6080::
    INCBIN "data/bank_29/Leftover_29_7272_Unused_TCRF_FaceDrawing3_FACE7_Gfx_Part6080.bin" ; $7272, 885 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_29_75E7::
    db $01, $06, $f5, $63, $fa, $03

; I: leftover: an exact copy of 108 bytes of Unused_TCRF_FaceDrawing2_FACE6_Gfx (from 06:53D5, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_29_75ED_Unused_TCRF_FaceDrawing2_FACE6_Gfx_Part53D5::
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $03, $ff, $03
    db $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $03

; I: leftover: an exact copy of 910 bytes of Unused_TCRF_FaceDrawing3_FACE7_Gfx (from 06:6461, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_29_7659_Unused_TCRF_FaceDrawing3_FACE7_Gfx_Part6461::
    INCBIN "data/bank_29/Leftover_29_7659_Unused_TCRF_FaceDrawing3_FACE7_Gfx_Part6461.bin" ; $7659, 910 bytes
; I: leftover: 5 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_29_79E7::
    db $01, $06, $ef, $67, $12

; I: leftover: an exact copy of 138 bytes of Unused_TCRF_FaceDrawing4_FACE8_Gfx (from 06:6FD0, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_29_79EC_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part6FD0::
    db $02, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff

; I: leftover: 431 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_29_7A76::
    INCBIN "data/bank_29/Leftover_29_7A76.bin" ; $7A76, 431 bytes
; I: leftover: an exact copy of 862 bytes of Unused_TCRF_FaceDrawing2_FACE6_Gfx (from 06:4E01, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_29_7C25_Unused_TCRF_FaceDrawing2_FACE6_Gfx_Part4E01::
    INCBIN "data/bank_29/Leftover_29_7C25_Unused_TCRF_FaceDrawing2_FACE6_Gfx_Part4E01.bin" ; $7C25, 862 bytes
; I: leftover: an exact copy of 124 bytes of Unused_TCRF_FaceDrawing4_FACE8_Gfx (from 06:6D7F, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_29_7F83_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part6D7F::
    db $fc, $0c, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $07, $f8, $f8, $80, $80
    db $00, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $00, $00, $00
    db $00, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $c0, $7f, $7f, $01, $01
    db $00, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $c0
    db $7f, $60, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_29_7FFF::
    db $29
