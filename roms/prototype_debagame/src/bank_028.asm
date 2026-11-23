; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $28. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $028", ROMX[$4000], BANK[$28]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_28_4000::
    db $28

; C: leftover text: 255 bytes of the developers' assembler source in clear, piece 3 of the listing 2 that TCRF shows
; (Proto:Game Boy Camera, section Source Code: 657 of 657 lines found here in order, 27:4001-28:4200,
; assets/tcrf_source_proto.csv); nothing in this build reads it
Unused_TCRF_AsmSource2_Part3::
    db ",$5C,$5C", $09, ";0155", $0d, $0a, $09, "DEFB", $09, "$98,$98,$18,$18,$1E,$1E,$00,$00", $0d, $0a, $09, "DEFB", $09, "$1B,$18,$1B,$18,$1C,$18,$1C,$18", $09, ";0156", $0d, $0a, $09, "DEFB", $09, "$1B,$18,$1B,$18,$1C,$18,$1C,$18", $0d, $0a, $09, "DEFB", $09, "$FF,$09,$FF,$0F,$FF,$09,$FF,$00", $09, ";0157", $0d, $0a, $09, "DEFB", $09, "$FF,$00,$FF,$00,$FF,$00,$FF,$00", $0d, $0a, $09, "DEFB", $09, "$FF,$1F,$FF,$04,$FF,$04,$F"

; I: leftover PC memory: 4 bytes (28:4100-4103), a leftover run that holds the dword $C21BD000, a 4 KB-aligned address
; of the Windows 9x system arena ($C0000000 up), at offset $100 of the bank, as in the other banks that hold one;
; nothing in this build reads, runs or explains it; only those proofs are ...
Leftover_28_4100_PcRam::
    db $00, $d0, $1b, $c2

; C: leftover text: 252 bytes of the developers' assembler source in clear, piece 4 of the listing 2 that TCRF shows
; (Proto:Game Boy Camera, section Source Code: 657 of 657 lines found here in order, 27:4001-28:4200,
; assets/tcrf_source_proto.csv); nothing in this build reads it
Unused_TCRF_AsmSource2_Part4::
    db "0", $09, ";0158", $0d, $0a, $09, "DEFB", $09, "$FF,$00,$FF,$00,$FF,$00,$FF,$00", $0d, $0a, $09, "DEFB", $09, "$E0,$1F,$FC,$03,$FC,$03,$FC,$03", $09, ";0159", $0d, $0a, $09, "DEFB", $09, "$FF,$00,$FF,$00,$FF,$00,$FF,$00", $0d, $0a, $09, "DEFB", $09, "$1F,$E0,$FF,$00,$FF,$00,$FF,$00", $09, ";015A", $0d, $0a, $09, "DEFB", $09, "$FF,$00,$FF,$00,$FF,$00,$FF,$00", $0d, $0a, $09, "DEFB", $09, "$FF,$A8,$FF,$00,$FF,$00,$FF,$0"

; I: leftover: an exact copy of 779 bytes of Unused_TCRF_FacePhoto2_KAO_2_Gfx (from 30:60EA, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_28_4200_Unused_TCRF_FacePhoto2_KAO_2_Gfx_Part60EA::
    INCBIN "data/bank_28/Leftover_28_4200_Unused_TCRF_FacePhoto2_KAO_2_Gfx_Part60EA.bin" ; $4200, 779 bytes
; I: leftover load-record header, 6 bytes: 01 04 F5 63 FA 03 = type 1, bank $04, load address $63F5, $03FA (1018) data
; bytes after it (the next header follows them); a record of an older build's image as a download stream in the PC's
; memory, that nothing in this build reads
Leftover_28_450B_LoadRecord::
    db $01, $04, $f5, $63, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto2_KAO_2_Gfx (from 30:63F5, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_28_4511_Unused_TCRF_FacePhoto2_KAO_2_Gfx_Part63F5::
    INCBIN "data/bank_28/Leftover_28_4511_Unused_TCRF_FacePhoto2_KAO_2_Gfx_Part63F5.bin" ; $4511, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 04 EF 67 12 02 = type 1, bank $04, load address $67EF, $0212 (530) data
; bytes after it (the next header follows them); a record of an older build's image as a download stream in the PC's
; memory, that nothing in this build reads
Leftover_28_490B_LoadRecord::
    db $01, $04, $ef, $67, $12, $02

; I: leftover: an exact copy of 530 bytes of Unused_TCRF_FacePhoto2_KAO_2_Gfx (from 30:67EF, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_28_4911_Unused_TCRF_FacePhoto2_KAO_2_Gfx_Part67EF::
    INCBIN "data/bank_28/Leftover_28_4911_Unused_TCRF_FacePhoto2_KAO_2_Gfx_Part67EF.bin" ; $4911, 530 bytes
; I: leftover load-record header, 6 bytes: 01 04 01 6A FA 03 = type 1, bank $04, load address $6A01, $03FA (1018) data
; bytes after it (the next header follows them); a record of an older build's image as a download stream in the PC's
; memory, that nothing in this build reads
Leftover_28_4B23_LoadRecord::
    db $01, $04, $01, $6a, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto3_KAO_3_Gfx (from 30:6A01, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_28_4B29_Unused_TCRF_FacePhoto3_KAO_3_Gfx_Part6A01::
    INCBIN "data/bank_28/Leftover_28_4B29_Unused_TCRF_FacePhoto3_KAO_3_Gfx_Part6A01.bin" ; $4B29, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 04 FB 6D FA 03 = type 1, bank $04, load address $6DFB, $03FA (1018) data
; bytes after it (the next header follows them); a record of an older build's image as a download stream in the PC's
; memory, that nothing in this build reads
Leftover_28_4F23_LoadRecord::
    db $01, $04, $fb, $6d, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto3_KAO_3_Gfx (from 30:6DFB, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_28_4F29_Unused_TCRF_FacePhoto3_KAO_3_Gfx_Part6DFB::
    INCBIN "data/bank_28/Leftover_28_4F29_Unused_TCRF_FacePhoto3_KAO_3_Gfx_Part6DFB.bin" ; $4F29, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 04 F5 71 FA 03 = type 1, bank $04, load address $71F5, $03FA (1018) data
; bytes after it (the next header follows them); a record of an older build's image as a download stream in the PC's
; memory, that nothing in this build reads
Leftover_28_5323_LoadRecord::
    db $01, $04, $f5, $71, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto3_KAO_3_Gfx (from 30:71F5, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_28_5329_Unused_TCRF_FacePhoto3_KAO_3_Gfx_Part71F5::
    INCBIN "data/bank_28/Leftover_28_5329_Unused_TCRF_FacePhoto3_KAO_3_Gfx_Part71F5.bin" ; $5329, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 04 EF 75 12 02 = type 1, bank $04, load address $75EF, $0212 (530) data
; bytes after it (the next header follows them); a record of an older build's image as a download stream in the PC's
; memory, that nothing in this build reads
Leftover_28_5723_LoadRecord::
    db $01, $04, $ef, $75, $12, $02

; I: leftover: an exact copy of 530 bytes of Unused_TCRF_FacePhoto3_KAO_3_Gfx (from 30:75EF, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_28_5729_Unused_TCRF_FacePhoto3_KAO_3_Gfx_Part75EF::
    INCBIN "data/bank_28/Leftover_28_5729_Unused_TCRF_FacePhoto3_KAO_3_Gfx_Part75EF.bin" ; $5729, 530 bytes
; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 04 FF 7F 01 00 = type 1, bank $04, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 19 records (owner 2026-11-22: part of the ...
Leftover_28_593B_LoadRecord::
    db $01, $04, $ff, $7f, $01, $00, $04

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 05 00 40 01 00 = type 1, bank $05, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 19 records (owner 2026-11-22: part of the ...
Leftover_28_5942_LoadRecord::
    db $01, $05, $00, $40, $01, $00, $05

; I: leftover load-record header, 6 bytes: 01 05 01 40 FA 03 = type 1, bank $05, load address $4001, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 19 records (owner 2026-11-22: part of the surrounding assets)
Leftover_28_5949_LoadRecord::
    db $01, $05, $01, $40, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto7_HOI_U_Gfx (from 05:4001, a part of the block),
; placed by the load-record header before it (28:5949); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_28_594F_Unused_TCRF_FacePhoto7_HOI_U_Gfx_Part4001::
    INCBIN "data/bank_28/Leftover_28_594F_Unused_TCRF_FacePhoto7_HOI_U_Gfx_Part4001.bin" ; $594F, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 05 FB 43 FA 03 = type 1, bank $05, load address $43FB, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 19 records (owner 2026-11-22: part of the surrounding assets)
Leftover_28_5D49_LoadRecord::
    db $01, $05, $fb, $43, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto7_HOI_U_Gfx (from 05:43FB, a part of the block),
; placed by the load-record header before it (28:5D49); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_28_5D4F_Unused_TCRF_FacePhoto7_HOI_U_Gfx_Part43FB::
    INCBIN "data/bank_28/Leftover_28_5D4F_Unused_TCRF_FacePhoto7_HOI_U_Gfx_Part43FB.bin" ; $5D4F, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 05 F5 47 FA 03 = type 1, bank $05, load address $47F5, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 19 records (owner 2026-11-22: part of the surrounding assets)
Leftover_28_6149_LoadRecord::
    db $01, $05, $f5, $47, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto7_HOI_U_Gfx (from 05:47F5, a part of the block),
; placed by the load-record header before it (28:6149); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_28_614F_Unused_TCRF_FacePhoto7_HOI_U_Gfx_Part47F5::
    INCBIN "data/bank_28/Leftover_28_614F_Unused_TCRF_FacePhoto7_HOI_U_Gfx_Part47F5.bin" ; $614F, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 05 EF 4B 12 02 = type 1, bank $05, load address $4BEF, $0212 (530) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 19 records (owner 2026-11-22: part of the surrounding assets)
Leftover_28_6549_LoadRecord::
    db $01, $05, $ef, $4b, $12, $02

; I: leftover: an exact copy of 530 bytes of Unused_TCRF_FacePhoto7_HOI_U_Gfx (from 05:4BEF, a part of the block),
; placed by the load-record header before it (28:6549); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_28_654F_Unused_TCRF_FacePhoto7_HOI_U_Gfx_Part4BEF::
    INCBIN "data/bank_28/Leftover_28_654F_Unused_TCRF_FacePhoto7_HOI_U_Gfx_Part4BEF.bin" ; $654F, 530 bytes
; I: leftover load-record header, 6 bytes: 01 05 01 4E FA 03 = type 1, bank $05, load address $4E01, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 19 records (owner 2026-11-22: part of the surrounding assets)
Leftover_28_6761_LoadRecord::
    db $01, $05, $01, $4e, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto8_HOI_D_Gfx (from 05:4E01, a part of the block),
; placed by the load-record header before it (28:6761); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_28_6767_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part4E01::
    INCBIN "data/bank_28/Leftover_28_6767_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part4E01.bin" ; $6767, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 05 FB 51 FA 03 = type 1, bank $05, load address $51FB, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 19 records (owner 2026-11-22: part of the surrounding assets)
Leftover_28_6B61_LoadRecord::
    db $01, $05, $fb, $51, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto8_HOI_D_Gfx (from 05:51FB, a part of the block),
; placed by the load-record header before it (28:6B61); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_28_6B67_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part51FB::
    INCBIN "data/bank_28/Leftover_28_6B67_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part51FB.bin" ; $6B67, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 05 F5 55 FA 03 = type 1, bank $05, load address $55F5, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 19 records (owner 2026-11-22: part of the surrounding assets)
Leftover_28_6F61_LoadRecord::
    db $01, $05, $f5, $55, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto8_HOI_D_Gfx (from 05:55F5, a part of the block),
; placed by the load-record header before it (28:6F61); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_28_6F67_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part55F5::
    INCBIN "data/bank_28/Leftover_28_6F67_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part55F5.bin" ; $6F67, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 05 EF 59 12 02 = type 1, bank $05, load address $59EF, $0212 (530) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 19 records (owner 2026-11-22: part of the surrounding assets)
Leftover_28_7361_LoadRecord::
    db $01, $05, $ef, $59, $12, $02

; I: leftover: an exact copy of 530 bytes of Unused_TCRF_FacePhoto8_HOI_D_Gfx (from 05:59EF, a part of the block),
; placed by the load-record header before it (28:7361); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_28_7367_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part59EF::
    INCBIN "data/bank_28/Leftover_28_7367_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part59EF.bin" ; $7367, 530 bytes
; I: leftover load-record header, 6 bytes: 01 05 01 5C FA 03 = type 1, bank $05, load address $5C01, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 19 records (owner 2026-11-22: part of the surrounding assets)
Leftover_28_7579_LoadRecord::
    db $01, $05, $01, $5c, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto9_HOI_L_Gfx (from 05:5C01, a part of the block),
; placed by the load-record header before it (28:7579); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_28_757F_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part5C01::
    INCBIN "data/bank_28/Leftover_28_757F_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part5C01.bin" ; $757F, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 05 FB 5F FA 03 = type 1, bank $05, load address $5FFB, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 19 records (owner 2026-11-22: part of the surrounding assets)
Leftover_28_7979_LoadRecord::
    db $01, $05, $fb, $5f, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto9_HOI_L_Gfx (from 05:5FFB, a part of the block),
; placed by the load-record header before it (28:7979); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_28_797F_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part5FFB::
    INCBIN "data/bank_28/Leftover_28_797F_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part5FFB.bin" ; $797F, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 05 F5 63 FA 03 = type 1, bank $05, load address $63F5, $03FA (1018) data
; bytes after it (they run past the end of the bank); a record of an older build's image as a download stream in the
; PC's memory, that nothing in this build reads
Leftover_28_7D79_LoadRecord::
    db $01, $05, $f5, $63, $fa, $03

; I: leftover: an exact copy of 640 bytes of Unused_TCRF_FacePhoto9_HOI_L_Gfx (from 05:63F5, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_28_7D7F_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part63F5::
    INCBIN "data/bank_28/Leftover_28_7D7F_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part63F5.bin" ; $7D7F, 640 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_28_7FFF::
    db $28
