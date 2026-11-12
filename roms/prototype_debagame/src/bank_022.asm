; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $22. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $022", ROMX[$4000], BANK[$22]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_22_4000::
    db $22

; I: leftover text: 255 bytes of the developers' assembler source in clear (0 listing lines, 6 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_22_4001_AsmSource::
    db ",$00,$00,$00", $09, ";0092", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$30,$38,$30,$38", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$10,$18,$00,$00", $09, ";0093", $0d, $0a, $09, "DEFB", $09, "$00,$00,$10,$18,$00,$00,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$10,$18,$00,$00", $09, ";0094", $0d, $0a, $09, "DEFB", $09, "$00,$00,$10,$18,$20,$30,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,$00,$08,$0C,$10,$1"

; I: leftover: 4 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_22_4100::
    db $00, $60, $60, $c2

; I: leftover text: 252 bytes of the developers' assembler source in clear (0 listing lines, 6 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_22_4104_AsmSource::
    db "0,$30", $09, ";0095", $0d, $0a, $09, "DEFB", $09, "$20,$30,$20,$30,$10,$18,$08,$0C", $0d, $0a, $09, "DEFB", $09, "$00,$00,$20,$30,$10,$18,$08,$0C", $09, ";0096", $0d, $0a, $09, "DEFB", $09, "$08,$0C,$08,$0C,$10,$18,$20,$30", $0d, $0a, $09, "DEFB", $09, "$00,$00,$08,$0C,$10,$18,$20,$30", $09, ";0097", $0d, $0a, $09, "DEFB", $09, "$40,$60,$20,$30,$10,$18,$08,$0C", $0d, $0a, $09, "DEFB", $09, "$00,$00,$20,$30,$10,$18,$0"

; I: leftover: an exact copy of 421 bytes of Map_02_5A41_BGSRAM1 (from 02:5ADC, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_22_4200_Map_02_5A41_BGSRAM1_Part5ADC::
    INCBIN "data/bank_22/Leftover_22_4200_Map_02_5A41_BGSRAM1_Part5ADC.bin" ; $4200, 421 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_22_43A5::
    db $01, $02, $81, $5c, $40, $02

; I: leftover: an exact copy of Map_02_5C81_BGSRAM2 (02:5C81, 576 bytes) that nothing in this build reads, runs or
; explains (never read nor run in the L2 runs)
Leftover_22_43AB_Map_02_5C81_BGSRAM2::
    INCBIN "data/bank_22/Leftover_22_43AB_Map_02_5C81_BGSRAM2.bin" ; $43AB, 576 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_22_45EB::
    db $01, $02, $c1, $5e, $40, $02

; I: leftover: an exact copy of Map_02_5EC1_BGSRAM3 (02:5EC1, 576 bytes) that nothing in this build reads, runs or
; explains (never read nor run in the L2 runs)
Leftover_22_45F1_Map_02_5EC1_BGSRAM3::
    INCBIN "data/bank_22/Leftover_22_45F1_Map_02_5EC1_BGSRAM3.bin" ; $45F1, 576 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_22_4831::
    db $01, $02, $01, $61, $40, $02

; I: leftover: an exact copy of Map_02_6101_BG_DUMP (02:6101, 576 bytes) that nothing in this build reads, runs or
; explains (never read nor run in the L2 runs)
Leftover_22_4837_Map_02_6101_BG_DUMP::
    INCBIN "data/bank_22/Leftover_22_4837_Map_02_6101_BG_DUMP.bin" ; $4837, 576 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_22_4A77::
    db $01, $02, $41, $63, $40, $02

; I: leftover: an exact copy of Map_02_6341_BGPROTEC (02:6341, 576 bytes) that nothing in this build reads, runs or
; explains (never read nor run in the L2 runs)
Leftover_22_4A7D_Map_02_6341_BGPROTEC::
    INCBIN "data/bank_22/Leftover_22_4A7D_Map_02_6341_BGPROTEC.bin" ; $4A7D, 576 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_22_4CBD::
    db $01, $02, $81, $65, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_PROGRAM_Gfx (from 02:6581, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_22_4CC3_Unused_PROGRAM_Gfx_Part6581::
    INCBIN "data/bank_22/Leftover_22_4CC3_Unused_PROGRAM_Gfx_Part6581.bin" ; $4CC3, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_22_50BD::
    db $01, $02, $7b, $69, $fa, $03

    ; padding
    ds $3fa, $00

    db $01, $02, $75, $6d, $fa, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00

; I: leftover: an exact copy of 256 bytes of Gfx_03_4001_FNTOOE3 (from 03:4001, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_22_54CF_Gfx_03_4001_FNTOOE3_Part4001::
    INCBIN "data/bank_22/Leftover_22_54CF_Gfx_03_4001_FNTOOE3_Part4001.bin" ; $54CF, 256 bytes
; I: leftover: an exact copy of 32 bytes of Gfx_01_4001_FNTOOE1 (from 01:4901, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_22_55CF_Gfx_01_4001_FNTOOE1_Part4901::
    db $00, $00, $44, $66, $44, $66, $44, $66, $47, $65, $39, $2d, $39, $29, $10, $18
    db $00, $00, $00, $00, $00, $00, $ce, $eb, $3c, $ae, $e8, $fc, $08, $8c, $c8, $ec

; I: leftover: 15 bytes between two pieces of a copy of Gfx_01_4001_FNTOOE1 at the same shift, where this copy differs
; from the block (01:4921; 33 % of the bytes equal): an edited version; nothing in this build reads, runs or explains
; it (never read nor run in the L2 runs)
Leftover_22_55EF_Gfx_01_4001_FNTOOE1_VariantPart4921::
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $38, $ef, $28, $ff

; I: leftover: an exact copy of 227 bytes of Gfx_01_4001_FNTOOE1 (from 01:4930, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_22_55FE_Gfx_01_4001_FNTOOE1_Part4930::
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

; I: leftover: 482 bytes between two pieces of a copy of Gfx_01_4001_FNTOOE1 at the same shift, where this copy
; differs from the block (01:4A13; 52 % of the bytes equal): an edited version; nothing in this build reads, runs or
; explains it (never read nor run in the L2 runs)
Leftover_22_56E1_Gfx_01_4001_FNTOOE1_VariantPart4A13::
    INCBIN "data/bank_22/Leftover_22_56E1_Gfx_01_4001_FNTOOE1_VariantPart4A13.bin" ; $56E1, 482 bytes
; I: leftover: an exact copy of 1018 bytes of Gfx_01_4001_FNTOOE1 (from 01:4BEF, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_22_58C3_Gfx_01_4001_FNTOOE1_Part4BEF::
    INCBIN "data/bank_22/Leftover_22_58C3_Gfx_01_4001_FNTOOE1_Part4BEF.bin" ; $58C3, 1018 bytes
; I: leftover: 14 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_22_5CBD::
    db $01, $02, $69, $75, $fa, $03, $ff, $ff, $ff, $ff, $7e, $7e, $3c, $3c

    ; padding
    ds $10, $00

; I: leftover: an exact copy of 994 bytes of Unused_TCRF_EditorUI_Gfx (from 02:7581, a part of the block) that nothing
; in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_22_5CDB_Unused_TCRF_EditorUI_Gfx_Part7581::
    INCBIN "data/bank_22/Leftover_22_5CDB_Unused_TCRF_EditorUI_Gfx_Part7581.bin" ; $5CDB, 994 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_22_60BD::
    db $01, $02, $63, $79, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_EditorUI_Gfx (from 02:7963, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_22_60C3_Unused_TCRF_EditorUI_Gfx_Part7963::
    INCBIN "data/bank_22/Leftover_22_60C3_Unused_TCRF_EditorUI_Gfx_Part7963.bin" ; $60C3, 1018 bytes
; I: leftover: 5 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_22_64BD::
    db $01, $02, $5d, $7d, $24

; I: leftover: an exact copy of 37 bytes of Unused_TCRF_EditorUI_Gfx (from 02:7D5C, a part of the block) that nothing
; in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_22_64C2_Unused_TCRF_EditorUI_Gfx_Part7D5C::
    db $00, $ff, $00, $ff, $00, $cf, $c0, $cf, $c0, $cf, $c0, $cf, $c0, $cf, $c0, $cf
    db $00, $cf, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00

; I: leftover: 20 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_22_64E7::
    db $01, $02, $ff, $7f, $01, $00, $02, $01, $03, $00, $40, $01, $00, $03, $01, $03
    db $01, $40, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Gfx_03_4001_FNTOOE3 (from 03:4001, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_22_64FB_Gfx_03_4001_FNTOOE3_Part4001::
    INCBIN "data/bank_22/Leftover_22_64FB_Gfx_03_4001_FNTOOE3_Part4001.bin" ; $64FB, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_22_68F5::
    db $01, $03, $fb, $43, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Gfx_03_4001_FNTOOE3 (from 03:43FB, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_22_68FB_Gfx_03_4001_FNTOOE3_Part43FB::
    INCBIN "data/bank_22/Leftover_22_68FB_Gfx_03_4001_FNTOOE3_Part43FB.bin" ; $68FB, 1018 bytes
; I: leftover: 944 bytes between two pieces of a copy of Gfx_03_4001_FNTOOE3 at the same shift, where this copy
; differs from the block (03:47F5; 99 % of the bytes equal): an edited version; nothing in this build reads, runs or
; explains it (never read nor run in the L2 runs)
Leftover_22_6CF5_Gfx_03_4001_FNTOOE3_VariantPart47F5::
    INCBIN "data/bank_22/Leftover_22_6CF5_Gfx_03_4001_FNTOOE3_VariantPart47F5.bin" ; $6CF5, 944 bytes
; I: leftover: an exact copy of 82 bytes of Unused_TCRF_FacePhoto9_HOI_L_Gfx (from 05:60E1, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_22_70A5_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part60E1::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $01, $03

; I: leftover: 942 bytes between two pieces of a copy of Unused_TCRF_FacePhoto9_HOI_L_Gfx at the same shift, where
; this copy differs from the block (05:6133; 45 % of the bytes equal): an edited version; nothing in this build reads,
; runs or explains it (never read nor run in the L2 runs)
Leftover_22_70F7_Unused_TCRF_FacePhoto9_HOI_L_Gfx_VariantPart6133::
    INCBIN "data/bank_22/Leftover_22_70F7_Unused_TCRF_FacePhoto9_HOI_L_Gfx_VariantPart6133.bin" ; $70F7, 942 bytes
; I: leftover: an exact copy of 82 bytes of Unused_TCRF_FacePhoto9_HOI_L_Gfx (from 05:60E1, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_22_74A5_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part60E1::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $01, $03

; I: leftover: 942 bytes between two pieces of a copy of Unused_TCRF_FacePhoto9_HOI_L_Gfx at the same shift, where
; this copy differs from the block (05:6133; 45 % of the bytes equal): an edited version; nothing in this build reads,
; runs or explains it (never read nor run in the L2 runs)
Leftover_22_74F7_Unused_TCRF_FacePhoto9_HOI_L_Gfx_VariantPart6133::
    INCBIN "data/bank_22/Leftover_22_74F7_Unused_TCRF_FacePhoto9_HOI_L_Gfx_VariantPart6133.bin" ; $74F7, 942 bytes
; I: leftover: an exact copy of 82 bytes of Unused_TCRF_FacePhoto9_HOI_L_Gfx (from 05:60E1, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_22_78A5_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part60E1::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $01, $03

; I: leftover: 4 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_22_78F7::
    db $e3, $53, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Gfx_03_4001_FNTOOE3 (from 03:53E3, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_22_78FB_Gfx_03_4001_FNTOOE3_Part53E3::
    INCBIN "data/bank_22/Leftover_22_78FB_Gfx_03_4001_FNTOOE3_Part53E3.bin" ; $78FB, 1018 bytes
; I: leftover: 5 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_22_7CF5::
    db $01, $03, $dd, $57, $24

; I: leftover: an exact copy of 40 bytes of Unused_TCRF_FacePhoto9_HOI_L_Gfx (from 05:610C, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_22_7CFA_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part610C::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $01, $03, $01

; I: leftover: 3 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_22_7D22::
    db $58, $40, $02

; I: leftover: an exact copy of Map_03_5801_BG_MOVIE (03:5801, 576 bytes) that nothing in this build reads, runs or
; explains (never read nor run in the L2 runs)
Leftover_22_7D25_Map_03_5801_BG_MOVIE::
    INCBIN "data/bank_22/Leftover_22_7D25_Map_03_5801_BG_MOVIE.bin" ; $7D25, 576 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_22_7F65::
    db $01, $03, $41, $5a, $fa, $03

; I: leftover: an exact copy of 148 bytes of Gfx_03_5A41_CONF2 (from 03:5A41, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_22_7F6B_Gfx_03_5A41_CONF2_Part5A41::
    db $00, $00, $70, $70, $78, $78, $7c, $7c, $7e, $7e, $7c, $7c, $78, $78, $70, $70
    db $78, $78, $7c, $7c, $78, $78, $70, $70, $60, $60, $40, $40, $00, $00, $00, $00
    db $00, $00, $0f, $0f, $18, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10
    db $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $18, $10, $0f, $0f
    db $00, $00, $f0, $f0, $18, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
    db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $18, $08, $f0, $f0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_22_7FFF::
    db $22
