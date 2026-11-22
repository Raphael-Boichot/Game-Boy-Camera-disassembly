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

; I: leftover PC memory: 4 bytes (23:4100-4103), the 512-byte blocks of a leftover run that hold the dword $C221E000,
; a 4 KB-aligned address of the Windows 9x system arena ($C0000000 up), at offset $100 of the bank, as in the other
; banks that hold one; nothing in this build reads, runs or explains them; ...
Leftover_23_4100_PcRam::
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
; I: leftover load-record header, 6 bytes: 01 03 2F 66 FA 03 = type 1, bank $03, load address $662F, $03FA (1018) data
; bytes after it (the next header follows them); a record of an older build's image as a download stream in the PC's
; memory, that nothing in this build reads
Leftover_23_4B65_LoadRecord::
    db $01, $03, $2f, $66, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Gfx_03_5A41_CONF2 (from 03:662F, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_4B6B_Gfx_03_5A41_CONF2_Part662F::
    INCBIN "data/bank_23/Leftover_23_4B6B_Gfx_03_5A41_CONF2_Part662F.bin" ; $4B6B, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 03 29 6A FA 03 = type 1, bank $03, load address $6A29, $03FA (1018) data
; bytes after it (the next header follows them); a record of an older build's image as a download stream in the PC's
; memory, that nothing in this build reads
Leftover_23_4F65_LoadRecord::
    db $01, $03, $29, $6a, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Gfx_03_5A41_CONF2 (from 03:6A29, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_4F6B_Gfx_03_5A41_CONF2_Part6A29::
    INCBIN "data/bank_23/Leftover_23_4F6B_Gfx_03_5A41_CONF2_Part6A29.bin" ; $4F6B, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 03 23 6E FA 03 = type 1, bank $03, load address $6E23, $03FA (1018) data
; bytes after it (the next header follows them); a record of an older build's image as a download stream in the PC's
; memory, that nothing in this build reads
Leftover_23_5365_LoadRecord::
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
; I: leftover load-record header, 6 bytes: 01 03 81 74 40 02 = type 1, bank $03, load address $7481, $0240 (576) data
; bytes after it (the next header follows them); a record of an older build's image as a download stream in the PC's
; memory, that nothing in this build reads
Leftover_23_59D5_LoadRecord::
    db $01, $03, $81, $74, $40, $02

; I: leftover: an exact copy of 576 bytes of Map_03_7481_BG_F_SCR (from 03:7481); step 4b-4: a run of 1752 bytes, 73 %
; equal at that shift; nothing in this build reads, runs or explains it (never read nor run in the L2 runs)
Leftover_23_59DB_Map_03_7481_BG_F_SCR::
    INCBIN "data/bank_23/Leftover_23_59DB_Map_03_7481_BG_F_SCR.bin" ; $59DB, 576 bytes
; I: leftover load-record header, 6 bytes: 01 03 C1 76 FA 03 = type 1, bank $03, load address $76C1, $03FA (1018) data
; bytes after it (the next header follows them); a record of an older build's image as a download stream in the PC's
; memory, that nothing in this build reads
Leftover_23_5C1B_LoadRecord::
    db $01, $03, $c1, $76, $fa, $03

; I: leftover: a variant (99 % of the bytes equal) of 1024 bytes of Map_03_76C1_BG_EDIT (from 03:76C1); step 4b-4: a
; run of 1184 bytes, 93 % equal at that shift; nothing in this build reads, runs or explains it (never read nor run in
; the L2 runs)
Leftover_23_5C21_Map_03_76C1_BG_EDIT_Variant::
    INCBIN "data/bank_23/Leftover_23_5C21_Map_03_76C1_BG_EDIT_Variant.bin" ; $5C21, 1024 bytes
; I: leftover: 12 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_6021::
    db $aa, $aa, $aa, $aa, $aa, $aa, $01, $03, $c1, $7a, $a0, $00

; I: leftover: an exact copy of 160 bytes of Map_03_7AC1_BG_EDITW (from 03:7AC1); step 4b-4: a run of 172 bytes, 97 %
; equal at that shift; nothing in this build reads, runs or explains it (never read nor run in the L2 runs)
Leftover_23_602D_Map_03_7AC1_BG_EDITW::
    db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
    db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
    db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $68, $69, $6a, $6b, $6c, $6d, $6e, $6f, $ac
    db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
    db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $78, $79, $7a, $7b, $7c, $7d, $7e, $7f, $ac
    db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
    db $ac, $ac, $ac, $ac, $ac, $ac, $47, $48, $49, $4a, $4b, $4c, $4d, $4e, $4f, $ac
    db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
    db $ac, $ac, $ac, $ac, $ac, $ac, $57, $58, $59, $5a, $5b, $5c, $5d, $5e, $5f, $ac
    db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac

; I: leftover: 20 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_60CD::
    db $01, $03, $ff, $7f, $01, $00, $03, $01, $04, $00, $40, $01, $00, $04, $01, $04
    db $01, $40, $fa, $03

; I: leftover: tile rows 0-1 of face photo 6 (the top of the head, 512 bytes); rows 2-13 are
; Unused_TCRF_FacePhoto6_HOI_0_Rows2To13_Gfx (30:4201), whose rows 0-1 bank $30 lost under source text; here the rows
; that follow (23:62E1-63E0) equal 30:4201-42FF byte for byte, so these two rows complete the ...
Leftover_23_60E1_Unused_TCRF_FacePhoto6_HOI_0_Rows0To1_Gfx::
    INCBIN "data/bank_23/Leftover_23_60E1_Unused_TCRF_FacePhoto6_HOI_0_Rows0To1_Gfx.2bpp" ; $60E1, 512 bytes
; I: leftover: an exact copy of 506 bytes of Unused_TCRF_FacePhoto6_HOI_0_Rows2To13_Gfx (from 30:4201, a part of the
; block) that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_62E1_Unused_TCRF_FacePhoto6_HOI_0_Rows2To13_Gfx_Part4201::
    INCBIN "data/bank_23/Leftover_23_62E1_Unused_TCRF_FacePhoto6_HOI_0_Rows2To13_Gfx_Part4201.bin" ; $62E1, 506 bytes
; I: leftover load-record header, 6 bytes: 01 04 FB 43 FA 03 = type 1, bank $04, load address $43FB, $03FA (1018) data
; bytes after it (the next header follows them); a record of an older build's image as a download stream in the PC's
; memory, that nothing in this build reads
Leftover_23_64DB_LoadRecord::
    db $01, $04, $fb, $43, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto6_HOI_0_Rows2To13_Gfx (from 30:43FB, a part of the
; block) that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_64E1_Unused_TCRF_FacePhoto6_HOI_0_Rows2To13_Gfx_Part43FB::
    INCBIN "data/bank_23/Leftover_23_64E1_Unused_TCRF_FacePhoto6_HOI_0_Rows2To13_Gfx_Part43FB.bin" ; $64E1, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 04 F5 47 FA 03 = type 1, bank $04, load address $47F5, $03FA (1018) data
; bytes after it (the next header follows them); a record of an older build's image as a download stream in the PC's
; memory, that nothing in this build reads
Leftover_23_68DB_LoadRecord::
    db $01, $04, $f5, $47, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto6_HOI_0_Rows2To13_Gfx (from 30:47F5, a part of the
; block) that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_68E1_Unused_TCRF_FacePhoto6_HOI_0_Rows2To13_Gfx_Part47F5::
    INCBIN "data/bank_23/Leftover_23_68E1_Unused_TCRF_FacePhoto6_HOI_0_Rows2To13_Gfx_Part47F5.bin" ; $68E1, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 04 EF 4B 12 02 = type 1, bank $04, load address $4BEF, $0212 (530) data
; bytes after it (the next header follows them); a record of an older build's image as a download stream in the PC's
; memory, that nothing in this build reads
Leftover_23_6CDB_LoadRecord::
    db $01, $04, $ef, $4b, $12, $02

; I: leftover: an exact copy of 530 bytes of Unused_TCRF_FacePhoto6_HOI_0_Rows2To13_Gfx (from 30:4BEF, a part of the
; block) that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_6CE1_Unused_TCRF_FacePhoto6_HOI_0_Rows2To13_Gfx_Part4BEF::
    INCBIN "data/bank_23/Leftover_23_6CE1_Unused_TCRF_FacePhoto6_HOI_0_Rows2To13_Gfx_Part4BEF.bin" ; $6CE1, 530 bytes
; I: leftover load-record header, 6 bytes: 01 04 01 4E FA 03 = type 1, bank $04, load address $4E01, $03FA (1018) data
; bytes after it (the next header follows them); a record of an older build's image as a download stream in the PC's
; memory, that nothing in this build reads
Leftover_23_6EF3_LoadRecord::
    db $01, $04, $01, $4e, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto1_KAO_1_Gfx (from 30:4E01, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_6EF9_Unused_TCRF_FacePhoto1_KAO_1_Gfx_Part4E01::
    INCBIN "data/bank_23/Leftover_23_6EF9_Unused_TCRF_FacePhoto1_KAO_1_Gfx_Part4E01.bin" ; $6EF9, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 04 FB 51 FA 03 = type 1, bank $04, load address $51FB, $03FA (1018) data
; bytes after it (the next header follows them); a record of an older build's image as a download stream in the PC's
; memory, that nothing in this build reads
Leftover_23_72F3_LoadRecord::
    db $01, $04, $fb, $51, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto1_KAO_1_Gfx (from 30:51FB, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_72F9_Unused_TCRF_FacePhoto1_KAO_1_Gfx_Part51FB::
    INCBIN "data/bank_23/Leftover_23_72F9_Unused_TCRF_FacePhoto1_KAO_1_Gfx_Part51FB.bin" ; $72F9, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 04 F5 55 FA 03 = type 1, bank $04, load address $55F5, $03FA (1018) data
; bytes after it (the next header follows them); a record of an older build's image as a download stream in the PC's
; memory, that nothing in this build reads
Leftover_23_76F3_LoadRecord::
    db $01, $04, $f5, $55, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto1_KAO_1_Gfx (from 30:55F5, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_76F9_Unused_TCRF_FacePhoto1_KAO_1_Gfx_Part55F5::
    INCBIN "data/bank_23/Leftover_23_76F9_Unused_TCRF_FacePhoto1_KAO_1_Gfx_Part55F5.bin" ; $76F9, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 04 EF 59 12 02 = type 1, bank $04, load address $59EF, $0212 (530) data
; bytes after it (the next header follows them); a record of an older build's image as a download stream in the PC's
; memory, that nothing in this build reads
Leftover_23_7AF3_LoadRecord::
    db $01, $04, $ef, $59, $12, $02

; I: leftover: an exact copy of 530 bytes of Unused_TCRF_FacePhoto1_KAO_1_Gfx (from 30:59EF, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_7AF9_Unused_TCRF_FacePhoto1_KAO_1_Gfx_Part59EF::
    INCBIN "data/bank_23/Leftover_23_7AF9_Unused_TCRF_FacePhoto1_KAO_1_Gfx_Part59EF.bin" ; $7AF9, 530 bytes
; I: leftover load-record header, 6 bytes: 01 04 01 5C FA 03 = type 1, bank $04, load address $5C01, $03FA (1018) data
; bytes after it (they run past the end of the bank); a record of an older build's image as a download stream in the
; PC's memory, that nothing in this build reads
Leftover_23_7D0B_LoadRecord::
    db $01, $04, $01, $5c, $fa, $03

; I: leftover: an exact copy of 750 bytes of Unused_TCRF_FacePhoto2_KAO_2_Gfx (from 30:5C01, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_7D11_Unused_TCRF_FacePhoto2_KAO_2_Gfx_Part5C01::
    INCBIN "data/bank_23/Leftover_23_7D11_Unused_TCRF_FacePhoto2_KAO_2_Gfx_Part5C01.bin" ; $7D11, 750 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_23_7FFF::
    db $23
