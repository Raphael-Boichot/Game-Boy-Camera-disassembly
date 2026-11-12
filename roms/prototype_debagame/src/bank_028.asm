; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $28. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $028", ROMX[$4000], BANK[$28]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_28_4000::
    db $28

; I: leftover text: 255 bytes of the developers' assembler source in clear (0 listing lines, 6 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_28_4001_AsmSource::
    db ",$5C,$5C", $09, ";0155", $0d, $0a, $09, "DEFB", $09, "$98,$98,$18,$18,$1E,$1E,$00,$00", $0d, $0a, $09, "DEFB", $09, "$1B,$18,$1B,$18,$1C,$18,$1C,$18", $09, ";0156", $0d, $0a, $09, "DEFB", $09, "$1B,$18,$1B,$18,$1C,$18,$1C,$18", $0d, $0a, $09, "DEFB", $09, "$FF,$09,$FF,$0F,$FF,$09,$FF,$00", $09, ";0157", $0d, $0a, $09, "DEFB", $09, "$FF,$00,$FF,$00,$FF,$00,$FF,$00", $0d, $0a, $09, "DEFB", $09, "$FF,$1F,$FF,$04,$FF,$04,$F"

; I: leftover: 4 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_28_4100::
    db $00, $d0, $1b, $c2

; I: leftover text: 252 bytes of the developers' assembler source in clear (0 listing lines, 6 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_28_4104_AsmSource::
    db "0", $09, ";0158", $0d, $0a, $09, "DEFB", $09, "$FF,$00,$FF,$00,$FF,$00,$FF,$00", $0d, $0a, $09, "DEFB", $09, "$E0,$1F,$FC,$03,$FC,$03,$FC,$03", $09, ";0159", $0d, $0a, $09, "DEFB", $09, "$FF,$00,$FF,$00,$FF,$00,$FF,$00", $0d, $0a, $09, "DEFB", $09, "$1F,$E0,$FF,$00,$FF,$00,$FF,$00", $09, ";015A", $0d, $0a, $09, "DEFB", $09, "$FF,$00,$FF,$00,$FF,$00,$FF,$00", $0d, $0a, $09, "DEFB", $09, "$FF,$A8,$FF,$00,$FF,$00,$FF,$0"

; I: leftover: an exact copy of 779 bytes of Unused_TCRF_FacePhoto2_Gfx (from 30:60EA, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_28_4200_Unused_TCRF_FacePhoto2_Gfx_Part60EA::
    INCBIN "data/bank_28/Leftover_28_4200_Unused_TCRF_FacePhoto2_Gfx_Part60EA.bin" ; $4200, 779 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_28_450B::
    db $01, $04, $f5, $63, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto2_Gfx (from 30:63F5, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_28_4511_Unused_TCRF_FacePhoto2_Gfx_Part63F5::
    INCBIN "data/bank_28/Leftover_28_4511_Unused_TCRF_FacePhoto2_Gfx_Part63F5.bin" ; $4511, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_28_490B::
    db $01, $04, $ef, $67, $12, $02

; I: leftover: an exact copy of 530 bytes of Unused_TCRF_FacePhoto2_Gfx (from 30:67EF, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_28_4911_Unused_TCRF_FacePhoto2_Gfx_Part67EF::
    INCBIN "data/bank_28/Leftover_28_4911_Unused_TCRF_FacePhoto2_Gfx_Part67EF.bin" ; $4911, 530 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_28_4B23::
    db $01, $04, $01, $6a, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto3_Gfx (from 30:6A01, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_28_4B29_Unused_TCRF_FacePhoto3_Gfx_Part6A01::
    INCBIN "data/bank_28/Leftover_28_4B29_Unused_TCRF_FacePhoto3_Gfx_Part6A01.bin" ; $4B29, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_28_4F23::
    db $01, $04, $fb, $6d, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto3_Gfx (from 30:6DFB, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_28_4F29_Unused_TCRF_FacePhoto3_Gfx_Part6DFB::
    INCBIN "data/bank_28/Leftover_28_4F29_Unused_TCRF_FacePhoto3_Gfx_Part6DFB.bin" ; $4F29, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_28_5323::
    db $01, $04, $f5, $71, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto3_Gfx (from 30:71F5, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_28_5329_Unused_TCRF_FacePhoto3_Gfx_Part71F5::
    INCBIN "data/bank_28/Leftover_28_5329_Unused_TCRF_FacePhoto3_Gfx_Part71F5.bin" ; $5329, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_28_5723::
    db $01, $04, $ef, $75, $12, $02

; I: leftover: an exact copy of 530 bytes of Unused_TCRF_FacePhoto3_Gfx (from 30:75EF, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_28_5729_Unused_TCRF_FacePhoto3_Gfx_Part75EF::
    INCBIN "data/bank_28/Leftover_28_5729_Unused_TCRF_FacePhoto3_Gfx_Part75EF.bin" ; $5729, 530 bytes
; I: leftover: 20 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_28_593B::
    db $01, $04, $ff, $7f, $01, $00, $04, $01, $05, $00, $40, $01, $00, $05, $01, $05
    db $01, $40, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto7_HOI_U_Gfx (from 05:4001, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_28_594F_Unused_TCRF_FacePhoto7_HOI_U_Gfx_Part4001::
    INCBIN "data/bank_28/Leftover_28_594F_Unused_TCRF_FacePhoto7_HOI_U_Gfx_Part4001.bin" ; $594F, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_28_5D49::
    db $01, $05, $fb, $43, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto7_HOI_U_Gfx (from 05:43FB, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_28_5D4F_Unused_TCRF_FacePhoto7_HOI_U_Gfx_Part43FB::
    INCBIN "data/bank_28/Leftover_28_5D4F_Unused_TCRF_FacePhoto7_HOI_U_Gfx_Part43FB.bin" ; $5D4F, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_28_6149::
    db $01, $05, $f5, $47, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto7_HOI_U_Gfx (from 05:47F5, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_28_614F_Unused_TCRF_FacePhoto7_HOI_U_Gfx_Part47F5::
    INCBIN "data/bank_28/Leftover_28_614F_Unused_TCRF_FacePhoto7_HOI_U_Gfx_Part47F5.bin" ; $614F, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_28_6549::
    db $01, $05, $ef, $4b, $12, $02

; I: leftover: an exact copy of 530 bytes of Unused_TCRF_FacePhoto7_HOI_U_Gfx (from 05:4BEF, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_28_654F_Unused_TCRF_FacePhoto7_HOI_U_Gfx_Part4BEF::
    INCBIN "data/bank_28/Leftover_28_654F_Unused_TCRF_FacePhoto7_HOI_U_Gfx_Part4BEF.bin" ; $654F, 530 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_28_6761::
    db $01, $05, $01, $4e, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto8_HOI_D_Gfx (from 05:4E01, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_28_6767_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part4E01::
    INCBIN "data/bank_28/Leftover_28_6767_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part4E01.bin" ; $6767, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_28_6B61::
    db $01, $05, $fb, $51, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto8_HOI_D_Gfx (from 05:51FB, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_28_6B67_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part51FB::
    INCBIN "data/bank_28/Leftover_28_6B67_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part51FB.bin" ; $6B67, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_28_6F61::
    db $01, $05, $f5, $55, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto8_HOI_D_Gfx (from 05:55F5, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_28_6F67_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part55F5::
    INCBIN "data/bank_28/Leftover_28_6F67_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part55F5.bin" ; $6F67, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_28_7361::
    db $01, $05, $ef, $59, $12, $02

; I: leftover: an exact copy of 530 bytes of Unused_TCRF_FacePhoto8_HOI_D_Gfx (from 05:59EF, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_28_7367_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part59EF::
    INCBIN "data/bank_28/Leftover_28_7367_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part59EF.bin" ; $7367, 530 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_28_7579::
    db $01, $05, $01, $5c, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto9_HOI_L_Gfx (from 05:5C01, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_28_757F_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part5C01::
    INCBIN "data/bank_28/Leftover_28_757F_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part5C01.bin" ; $757F, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_28_7979::
    db $01, $05, $fb, $5f, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto9_HOI_L_Gfx (from 05:5FFB, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_28_797F_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part5FFB::
    INCBIN "data/bank_28/Leftover_28_797F_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part5FFB.bin" ; $797F, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_28_7D79::
    db $01, $05, $f5, $63, $fa, $03

; I: leftover: an exact copy of 640 bytes of Unused_TCRF_FacePhoto9_HOI_L_Gfx (from 05:63F5, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_28_7D7F_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part63F5::
    INCBIN "data/bank_28/Leftover_28_7D7F_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part63F5.bin" ; $7D7F, 640 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_28_7FFF::
    db $28
