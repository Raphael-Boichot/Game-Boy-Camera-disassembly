; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $23. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $023", ROMX[$4000], BANK[$23]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_23_4000::
    db $23

; I: leftover text: 255 bytes of the developers' assembler source in clear (0 listing lines, 6 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_23_4001_AsmSource::
    db "4,$89,$8D,$82,$8A", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$C0,$C0,$20,$70", $09, ";0031", $0d, $0a, $09, "DEFB", $09, "$10,$18,$08,$0C,$84,$84,$04,$04", $0d, $0a, $09, "DEFB", $09, "$00,$00,$38,$38,$47,$6F,$80,$C0", $09, ";0032", $0d, $0a, $09, "DEFB", $09, "$80,$80,$AC,$AC,$90,$B0,$C4,$C4", $0d, $0a, $09, "DEFB", $09, "$00,$00,$18,$3C,$E4,$E6,$02,$03", $09, ";0033", $0d, $0a, $09, "DEFB", $09, "$01,$01,$19,$19,$"

; I: leftover: 4 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_4100::
    db $00, $e0, $21, $c2

; I: leftover text: 252 bytes of the developers' assembler source in clear (0 listing lines, 6 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_23_4104_AsmSource::
    db "05,$13,$13", $0d, $0a, $09, "DEFB", $09, "$00,$00,$38,$38,$47,$6F,$80,$C0", $09, ";0034", $0d, $0a, $09, "DEFB", $09, "$8C,$8C,$A0,$A0,$84,$A4,$00,$C0", $0d, $0a, $09, "DEFB", $09, "$00,$00,$18,$3C,$E4,$E6,$02,$03", $09, ";0035", $0d, $0a, $09, "DEFB", $09, "$18,$19,$01,$01,$15,$15,$02,$03", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$18,$3C,$67,$6F", $09, ";0036", $0d, $0a, $09, "DEFB", $09, "$80,$C0,$80,$A0,$4C,$"

    ; padding
    ds $115, $00

; I: leftover: an exact copy of 82 bytes of Unused_TCRF_FacePhoto9_HOI_L_Gfx (from 05:60E1, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_4315_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part60E1::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $01, $03

; I: leftover: 942 bytes between two pieces of a copy of Unused_TCRF_FacePhoto9_HOI_L_Gfx at the same shift, where
; this copy differs from the block (05:6133; 45 % of the bytes equal): an edited version; nothing in this build reads,
; runs or explains it (never read nor run in the L2 runs)
Leftover_23_4367_Unused_TCRF_FacePhoto9_HOI_L_Gfx_VariantPart6133::
    INCBIN "data/bank_23/Leftover_23_4367_Unused_TCRF_FacePhoto9_HOI_L_Gfx_VariantPart6133.bin" ; $4367, 942 bytes
; I: leftover: an exact copy of 82 bytes of Unused_TCRF_FacePhoto9_HOI_L_Gfx (from 05:60E1, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_4715_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part60E1::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $01, $03

; I: leftover: 4 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_4767::
    db $35, $62, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Gfx_03_5A41_CONF2 (from 03:6235, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_476B_Gfx_03_5A41_CONF2_Part6235::
    INCBIN "data/bank_23/Leftover_23_476B_Gfx_03_5A41_CONF2_Part6235.bin" ; $476B, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_4B65::
    db $01, $03, $2f, $66, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Gfx_03_5A41_CONF2 (from 03:662F, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_4B6B_Gfx_03_5A41_CONF2_Part662F::
    INCBIN "data/bank_23/Leftover_23_4B6B_Gfx_03_5A41_CONF2_Part662F.bin" ; $4B6B, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_4F65::
    db $01, $03, $29, $6a, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Gfx_03_5A41_CONF2 (from 03:6A29, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_4F6B_Gfx_03_5A41_CONF2_Part6A29::
    INCBIN "data/bank_23/Leftover_23_4F6B_Gfx_03_5A41_CONF2_Part6A29.bin" ; $4F6B, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_5365::
    db $01, $03, $23, $6e, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Gfx_03_5A41_CONF2 (from 03:6E23, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_536B_Gfx_03_5A41_CONF2_Part6E23::
    INCBIN "data/bank_23/Leftover_23_536B_Gfx_03_5A41_CONF2_Part6E23.bin" ; $536B, 1018 bytes
; I: leftover: 5 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_5765::
    db $01, $03, $1d, $72, $24

; I: leftover: an exact copy of 39 bytes of Unused_TCRF_FacePhoto9_HOI_L_Gfx (from 05:610C, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_576A_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part610C::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $01, $03

; I: leftover: 4 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_5791::
    db $41, $72, $40, $02

; I: leftover: an exact copy of Map_03_7241_BG_CONF (03:7241, 576 bytes) that nothing in this build reads, runs or
; explains (never read nor run in the L2 runs)
Leftover_23_5795_Map_03_7241_BG_CONF::
    INCBIN "data/bank_23/Leftover_23_5795_Map_03_7241_BG_CONF.bin" ; $5795, 576 bytes
; I: leftover: 1804 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_59D5::
    INCBIN "data/bank_23/Leftover_23_59D5.bin" ; $59D5, 1804 bytes
; I: leftover: tile rows 0-1 of face photo 6 (the top of the head, 512 bytes); rows 2-13 are
; Unused_TCRF_FacePhoto6_Rows2To13_Gfx (30:4201), whose rows 0-1 bank $30 lost under source text; here the rows that
; follow (23:62E1-63E0) equal 30:4201-42FF byte for byte, so these two rows complete the picture ...
Leftover_23_60E1_Unused_TCRF_FacePhoto6_Rows0To1_Gfx::
    INCBIN "data/bank_23/Leftover_23_60E1_Unused_TCRF_FacePhoto6_Rows0To1_Gfx.2bpp" ; $60E1, 512 bytes
; I: leftover: an exact copy of 506 bytes of Unused_TCRF_FacePhoto6_Rows2To13_Gfx (from 30:4201, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_62E1_Unused_TCRF_FacePhoto6_Rows2To13_Gfx_Part4201::
    INCBIN "data/bank_23/Leftover_23_62E1_Unused_TCRF_FacePhoto6_Rows2To13_Gfx_Part4201.bin" ; $62E1, 506 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_64DB::
    db $01, $04, $fb, $43, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto6_Rows2To13_Gfx (from 30:43FB, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_64E1_Unused_TCRF_FacePhoto6_Rows2To13_Gfx_Part43FB::
    INCBIN "data/bank_23/Leftover_23_64E1_Unused_TCRF_FacePhoto6_Rows2To13_Gfx_Part43FB.bin" ; $64E1, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_68DB::
    db $01, $04, $f5, $47, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto6_Rows2To13_Gfx (from 30:47F5, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_68E1_Unused_TCRF_FacePhoto6_Rows2To13_Gfx_Part47F5::
    INCBIN "data/bank_23/Leftover_23_68E1_Unused_TCRF_FacePhoto6_Rows2To13_Gfx_Part47F5.bin" ; $68E1, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_6CDB::
    db $01, $04, $ef, $4b, $12, $02

; I: leftover: an exact copy of 530 bytes of Unused_TCRF_FacePhoto6_Rows2To13_Gfx (from 30:4BEF, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_6CE1_Unused_TCRF_FacePhoto6_Rows2To13_Gfx_Part4BEF::
    INCBIN "data/bank_23/Leftover_23_6CE1_Unused_TCRF_FacePhoto6_Rows2To13_Gfx_Part4BEF.bin" ; $6CE1, 530 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_6EF3::
    db $01, $04, $01, $4e, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto1_Gfx (from 30:4E01, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_6EF9_Unused_TCRF_FacePhoto1_Gfx_Part4E01::
    INCBIN "data/bank_23/Leftover_23_6EF9_Unused_TCRF_FacePhoto1_Gfx_Part4E01.bin" ; $6EF9, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_72F3::
    db $01, $04, $fb, $51, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto1_Gfx (from 30:51FB, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_72F9_Unused_TCRF_FacePhoto1_Gfx_Part51FB::
    INCBIN "data/bank_23/Leftover_23_72F9_Unused_TCRF_FacePhoto1_Gfx_Part51FB.bin" ; $72F9, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_76F3::
    db $01, $04, $f5, $55, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto1_Gfx (from 30:55F5, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_76F9_Unused_TCRF_FacePhoto1_Gfx_Part55F5::
    INCBIN "data/bank_23/Leftover_23_76F9_Unused_TCRF_FacePhoto1_Gfx_Part55F5.bin" ; $76F9, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_7AF3::
    db $01, $04, $ef, $59, $12, $02

; I: leftover: an exact copy of 530 bytes of Unused_TCRF_FacePhoto1_Gfx (from 30:59EF, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_7AF9_Unused_TCRF_FacePhoto1_Gfx_Part59EF::
    INCBIN "data/bank_23/Leftover_23_7AF9_Unused_TCRF_FacePhoto1_Gfx_Part59EF.bin" ; $7AF9, 530 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_7D0B::
    db $01, $04, $01, $5c, $fa, $03

; I: leftover: an exact copy of 750 bytes of Unused_TCRF_FacePhoto2_Gfx (from 30:5C01, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_7D11_Unused_TCRF_FacePhoto2_Gfx_Part5C01::
    INCBIN "data/bank_23/Leftover_23_7D11_Unused_TCRF_FacePhoto2_Gfx_Part5C01.bin" ; $7D11, 750 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_23_7FFF::
    db $23
