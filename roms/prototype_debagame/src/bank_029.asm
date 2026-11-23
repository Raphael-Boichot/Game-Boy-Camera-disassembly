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

; I: leftover PC memory: 4 bytes (29:4100-4103), a leftover run that holds the dword $C2522000, a 4 KB-aligned address
; of the Windows 9x system arena ($C0000000 up), at offset $100 of the bank, as in the other banks that hold one;
; nothing in this build reads, runs or explains it; only those proofs are ...
Leftover_29_4100_PcRam::
    db $00, $20, $52, $c2

; I: leftover text: 253 bytes of the developers' assembler source in clear (0 listing lines, 6 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_29_4104_AsmSource::
    db "67,$67", $0d, $0a, $09, "DEFB", $09, "$00,$00,$80,$80,$80,$80,$9C,$9C", $09, ";00F7", $0d, $0a, $09, "DEFB", $09, "$B6,$B6,$B6,$B6,$B6,$B6,$9C,$9C", $0d, $0a, $09, "DEFB", $09, "$00,$00,$0C,$1E,$12,$12,$12,$16", $09, ";00F8", $0d, $0a, $09, "DEFB", $09, "$1C,$3C,$24,$34,$22,$27,$22,$22", $0d, $0a, $09, "DEFB", $09, "$00,$00,$01,$03,$42,$E2,$A2,$A2", $09, ";00F9", $0d, $0a, $09, "DEFB", $09, "$43,$67,$A4,$B6,$A4,$E4,$]"

; I: leftover: an exact copy of 400 bytes of Unused_TCRF_FacePhoto9_HOI_L_Gfx (from 05:6871, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_29_4201_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part6871::
    INCBIN "data/bank_29/Leftover_29_4201_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part6871.bin" ; $4201, 400 bytes
; I: leftover load-record header, 6 bytes: 01 05 01 6A FA 03 = type 1, bank $05, load address $6A01, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 19 records (owner 2026-11-22: part of the surrounding assets)
Leftover_29_4391_LoadRecord::
    db $01, $05, $01, $6a, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto10_HOI_R_Gfx (from 05:6A01, a part of the block),
; placed by the load-record header before it (29:4391); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_29_4397_Unused_TCRF_FacePhoto10_HOI_R_Gfx_Part6A01::
    INCBIN "data/bank_29/Leftover_29_4397_Unused_TCRF_FacePhoto10_HOI_R_Gfx_Part6A01.bin" ; $4397, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 05 FB 6D FA 03 = type 1, bank $05, load address $6DFB, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 19 records (owner 2026-11-22: part of the surrounding assets)
Leftover_29_4791_LoadRecord::
    db $01, $05, $fb, $6d, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto10_HOI_R_Gfx (from 05:6DFB, a part of the block),
; placed by the load-record header before it (29:4791); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_29_4797_Unused_TCRF_FacePhoto10_HOI_R_Gfx_Part6DFB::
    INCBIN "data/bank_29/Leftover_29_4797_Unused_TCRF_FacePhoto10_HOI_R_Gfx_Part6DFB.bin" ; $4797, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 05 F5 71 FA 03 = type 1, bank $05, load address $71F5, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 19 records (owner 2026-11-22: part of the surrounding assets)
Leftover_29_4B91_LoadRecord::
    db $01, $05, $f5, $71, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto10_HOI_R_Gfx (from 05:71F5, a part of the block),
; placed by the load-record header before it (29:4B91); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_29_4B97_Unused_TCRF_FacePhoto10_HOI_R_Gfx_Part71F5::
    INCBIN "data/bank_29/Leftover_29_4B97_Unused_TCRF_FacePhoto10_HOI_R_Gfx_Part71F5.bin" ; $4B97, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 05 EF 75 12 02 = type 1, bank $05, load address $75EF, $0212 (530) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 19 records (owner 2026-11-22: part of the surrounding assets)
Leftover_29_4F91_LoadRecord::
    db $01, $05, $ef, $75, $12, $02

; I: leftover: an exact copy of 530 bytes of Unused_TCRF_FacePhoto10_HOI_R_Gfx (from 05:75EF, a part of the block),
; placed by the load-record header before it (29:4F91); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_29_4F97_Unused_TCRF_FacePhoto10_HOI_R_Gfx_Part75EF::
    INCBIN "data/bank_29/Leftover_29_4F97_Unused_TCRF_FacePhoto10_HOI_R_Gfx_Part75EF.bin" ; $4F97, 530 bytes
; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 05 FF 7F 01 00 = type 1, bank $05, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 19 records (owner 2026-11-22: part of the ...
Leftover_29_51A9_LoadRecord::
    db $01, $05, $ff, $7f, $01, $00, $05

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 06 00 40 01 00 = type 1, bank $06, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 19 records (owner 2026-11-22: part of the ...
Leftover_29_51B0_LoadRecord::
    db $01, $06, $00, $40, $01, $00, $06

; I: leftover load-record header, 6 bytes: 01 06 01 40 FA 03 = type 1, bank $06, load address $4001, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 19 records (owner 2026-11-22: part of the surrounding assets)
Leftover_29_51B7_LoadRecord::
    db $01, $06, $01, $40, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FaceDrawing1_FACE5_Gfx (from 06:4001, a part of the block),
; placed by the load-record header before it (29:51B7); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_29_51BD_Unused_TCRF_FaceDrawing1_FACE5_Gfx_Part4001::
    INCBIN "data/bank_29/Leftover_29_51BD_Unused_TCRF_FaceDrawing1_FACE5_Gfx_Part4001.bin" ; $51BD, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 06 FB 43 FA 03 = type 1, bank $06, load address $43FB, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 19 records (owner 2026-11-22: part of the surrounding assets)
Leftover_29_55B7_LoadRecord::
    db $01, $06, $fb, $43, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FaceDrawing1_FACE5_Gfx (from 06:43FB, a part of the block),
; placed by the load-record header before it (29:55B7); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_29_55BD_Unused_TCRF_FaceDrawing1_FACE5_Gfx_Part43FB::
    INCBIN "data/bank_29/Leftover_29_55BD_Unused_TCRF_FaceDrawing1_FACE5_Gfx_Part43FB.bin" ; $55BD, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 06 F5 47 FA 03 = type 1, bank $06, load address $47F5, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 19 records (owner 2026-11-22: part of the surrounding assets)
Leftover_29_59B7_LoadRecord::
    db $01, $06, $f5, $47, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FaceDrawing1_FACE5_Gfx (from 06:47F5, a part of the block),
; placed by the load-record header before it (29:59B7); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_29_59BD_Unused_TCRF_FaceDrawing1_FACE5_Gfx_Part47F5::
    INCBIN "data/bank_29/Leftover_29_59BD_Unused_TCRF_FaceDrawing1_FACE5_Gfx_Part47F5.bin" ; $59BD, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 06 EF 4B 12 02 = type 1, bank $06, load address $4BEF, $0212 (530) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 19 records (owner 2026-11-22: part of the surrounding assets)
Leftover_29_5DB7_LoadRecord::
    db $01, $06, $ef, $4b, $12, $02

; I: leftover: an exact copy of 530 bytes of Unused_TCRF_FaceDrawing1_FACE5_Gfx (from 06:4BEF, a part of the block),
; placed by the load-record header before it (29:5DB7); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_29_5DBD_Unused_TCRF_FaceDrawing1_FACE5_Gfx_Part4BEF::
    INCBIN "data/bank_29/Leftover_29_5DBD_Unused_TCRF_FaceDrawing1_FACE5_Gfx_Part4BEF.bin" ; $5DBD, 530 bytes
; I: leftover load-record header, 6 bytes: 01 06 01 4E FA 03 = type 1, bank $06, load address $4E01, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 19 records (owner 2026-11-22: part of the surrounding assets)
Leftover_29_5FCF_LoadRecord::
    db $01, $06, $01, $4e, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FaceDrawing2_FACE6_Gfx (from 06:4E01, a part of the block),
; placed by the load-record header before it (29:5FCF); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_29_5FD5_Unused_TCRF_FaceDrawing2_FACE6_Gfx_Part4E01::
    INCBIN "data/bank_29/Leftover_29_5FD5_Unused_TCRF_FaceDrawing2_FACE6_Gfx_Part4E01.bin" ; $5FD5, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 06 FB 51 FA 03 = type 1, bank $06, load address $51FB, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 19 records (owner 2026-11-22: part of the surrounding assets)
Leftover_29_63CF_LoadRecord::
    db $01, $06, $fb, $51, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FaceDrawing2_FACE6_Gfx (from 06:51FB, a part of the block),
; placed by the load-record header before it (29:63CF); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_29_63D5_Unused_TCRF_FaceDrawing2_FACE6_Gfx_Part51FB::
    INCBIN "data/bank_29/Leftover_29_63D5_Unused_TCRF_FaceDrawing2_FACE6_Gfx_Part51FB.bin" ; $63D5, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 06 F5 55 FA 03 = type 1, bank $06, load address $55F5, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 19 records (owner 2026-11-22: part of the surrounding assets)
Leftover_29_67CF_LoadRecord::
    db $01, $06, $f5, $55, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FaceDrawing2_FACE6_Gfx (from 06:55F5, a part of the block),
; placed by the load-record header before it (29:67CF); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_29_67D5_Unused_TCRF_FaceDrawing2_FACE6_Gfx_Part55F5::
    INCBIN "data/bank_29/Leftover_29_67D5_Unused_TCRF_FaceDrawing2_FACE6_Gfx_Part55F5.bin" ; $67D5, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 06 EF 59 12 02 = type 1, bank $06, load address $59EF, $0212 (530) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 19 records (owner 2026-11-22: part of the surrounding assets)
Leftover_29_6BCF_LoadRecord::
    db $01, $06, $ef, $59, $12, $02

; I: leftover: an exact copy of 530 bytes of Unused_TCRF_FaceDrawing2_FACE6_Gfx (from 06:59EF, a part of the block),
; placed by the load-record header before it (29:6BCF); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_29_6BD5_Unused_TCRF_FaceDrawing2_FACE6_Gfx_Part59EF::
    INCBIN "data/bank_29/Leftover_29_6BD5_Unused_TCRF_FaceDrawing2_FACE6_Gfx_Part59EF.bin" ; $6BD5, 530 bytes
; I: leftover load-record header, 6 bytes: 01 06 01 5C FA 03 = type 1, bank $06, load address $5C01, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 19 records (owner 2026-11-22: part of the surrounding assets)
Leftover_29_6DE7_LoadRecord::
    db $01, $06, $01, $5c, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FaceDrawing3_FACE7_Gfx (from 06:5C01, a part of the block),
; placed by the load-record header before it (29:6DE7); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_29_6DED_Unused_TCRF_FaceDrawing3_FACE7_Gfx_Part5C01::
    INCBIN "data/bank_29/Leftover_29_6DED_Unused_TCRF_FaceDrawing3_FACE7_Gfx_Part5C01.bin" ; $6DED, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 06 FB 5F FA 03 = type 1, bank $06, load address $5FFB, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 19 records (owner 2026-11-22: part of the surrounding assets)
Leftover_29_71E7_LoadRecord::
    db $01, $06, $fb, $5f, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FaceDrawing3_FACE7_Gfx (from 06:5FFB, a part of the block),
; placed by the load-record header before it (29:71E7); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_29_71ED_Unused_TCRF_FaceDrawing3_FACE7_Gfx_Part5FFB::
    INCBIN "data/bank_29/Leftover_29_71ED_Unused_TCRF_FaceDrawing3_FACE7_Gfx_Part5FFB.bin" ; $71ED, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 06 F5 63 FA 03 = type 1, bank $06, load address $63F5, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 19 records (owner 2026-11-22: part of the surrounding assets)
Leftover_29_75E7_LoadRecord::
    db $01, $06, $f5, $63, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FaceDrawing3_FACE7_Gfx (from 06:63F5, a part of the block),
; placed by the load-record header before it (29:75E7); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_29_75ED_Unused_TCRF_FaceDrawing3_FACE7_Gfx_Part63F5::
    INCBIN "data/bank_29/Leftover_29_75ED_Unused_TCRF_FaceDrawing3_FACE7_Gfx_Part63F5.bin" ; $75ED, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 06 EF 67 12 02 = type 1, bank $06, load address $67EF, $0212 (530) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 19 records (owner 2026-11-22: part of the surrounding assets)
Leftover_29_79E7_LoadRecord::
    db $01, $06, $ef, $67, $12, $02

; I: leftover: an exact copy of 530 bytes of Unused_TCRF_FaceDrawing3_FACE7_Gfx (from 06:67EF, a part of the block),
; placed by the load-record header before it (29:79E7); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_29_79ED_Unused_TCRF_FaceDrawing3_FACE7_Gfx_Part67EF::
    INCBIN "data/bank_29/Leftover_29_79ED_Unused_TCRF_FaceDrawing3_FACE7_Gfx_Part67EF.bin" ; $79ED, 530 bytes
; I: leftover load-record header, 6 bytes: 01 06 01 6A FA 03 = type 1, bank $06, load address $6A01, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 19 records (owner 2026-11-22: part of the surrounding assets)
Leftover_29_7BFF_LoadRecord::
    db $01, $06, $01, $6a, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FaceDrawing4_FACE8_Gfx (from 06:6A01, a part of the block),
; placed by the load-record header before it (29:7BFF); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_29_7C05_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part6A01::
    INCBIN "data/bank_29/Leftover_29_7C05_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part6A01.bin" ; $7C05, 1018 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_29_7FFF::
    db $29
