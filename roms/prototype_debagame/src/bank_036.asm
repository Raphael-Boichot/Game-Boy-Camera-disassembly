; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $36. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $036", ROMX[$4000], BANK[$36]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_36_4000::
    db $36

; I: leftover: 511 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs); no proof of PC memory in them
Leftover_36_4001::
    db $c0, $8e, $00, $f0

    ; padding
    ds $f3, $00

    db $ff, $00, $00, $00, $00, $00, $00, $00, $00, $80, $f6, $c1

    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; I: leftover PC memory: 512 bytes (36:4200-43FF), the 512-byte blocks of a leftover run that hold 2 strings of the
; development PC's RAM (WINDOWS VMM 4.0 / PIFMGR.DLL ...); nothing in this build reads, runs or explains them; only
; those proofs are proven, the rest of each block is taken as the same memory
Leftover_36_4200_PcRam::
    db $00, $00, $00, $00, $00

    db $57, $49, $4e, $44, $4f, $57, $53, $20, $56, $4d, $4d, $20, $34, $2e, $30, $00
    db $ff, $ff, $1b, $02, $ac, $01

    ; padding
    ds $58, $00

    db $50, $49, $46, $4d, $47, $52, $2e, $44, $4c, $4c

    ; padding
    ds $48, $00

    db $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $32, $00, $01, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $05, $00
    db $19, $00, $03, $00, $c8, $00, $e8, $03, $02, $00, $0a, $00, $01, $00, $00, $00
    db $00, $00, $00, $00, $1c, $00, $00, $00, $00, $00, $00, $00, $0a, $00, $16, $00
    db $54, $65, $72, $6d, $69, $6e, $61, $6c

    ; padding
    ds $18, $00

    db $82, $6c, $82, $72, $20, $83, $53, $83, $56, $83, $62, $83, $4e

    ; padding
    ds $13, $00

    db $a4, $03, $03, $00, $00, $00, $50, $00, $19, $00, $20, $03, $26, $02, $2c, $03
    db $6e, $02, $16, $00, $00, $00, $01, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $bd, $00, $bd, $00, $e9, $03, $2b, $03, $00, $00, $00, $00, $44, $4f, $53, $49
    db $4d, $45

    ; padding
    ds $4e, $00

    db $01

    ; padding
    ds $3a, $00

; I: leftover: an exact copy of 949 bytes of Unused_TCRF_FacePhoto2_KAO_2_Gfx (from 30:5C46, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_36_4400_Unused_TCRF_FacePhoto2_KAO_2_Gfx_Part5C46::
    INCBIN "data/bank_36/Leftover_36_4400_Unused_TCRF_FacePhoto2_KAO_2_Gfx_Part5C46.bin" ; $4400, 949 bytes
; I: leftover load-record header, 6 bytes: 01 04 FB 5F FA 03 = type 1, bank $04, load address $5FFB, $03FA (1018) data
; bytes after it (the next header follows them); a record of an older build's image as a download stream in the PC's
; memory, that nothing in this build reads
Leftover_36_47B5_LoadRecord::
    db $01, $04, $fb, $5f, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto2_KAO_2_Gfx (from 30:5FFB, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_36_47BB_Unused_TCRF_FacePhoto2_KAO_2_Gfx_Part5FFB::
    INCBIN "data/bank_36/Leftover_36_47BB_Unused_TCRF_FacePhoto2_KAO_2_Gfx_Part5FFB.bin" ; $47BB, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 04 F5 63 FA 03 = type 1, bank $04, load address $63F5, $03FA (1018) data
; bytes after it (the next header follows them); a record of an older build's image as a download stream in the PC's
; memory, that nothing in this build reads
Leftover_36_4BB5_LoadRecord::
    db $01, $04, $f5, $63, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto2_KAO_2_Gfx (from 30:63F5, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_36_4BBB_Unused_TCRF_FacePhoto2_KAO_2_Gfx_Part63F5::
    INCBIN "data/bank_36/Leftover_36_4BBB_Unused_TCRF_FacePhoto2_KAO_2_Gfx_Part63F5.bin" ; $4BBB, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 04 EF 67 12 02 = type 1, bank $04, load address $67EF, $0212 (530) data
; bytes after it (the next header follows them); a record of an older build's image as a download stream in the PC's
; memory, that nothing in this build reads
Leftover_36_4FB5_LoadRecord::
    db $01, $04, $ef, $67, $12, $02

; I: leftover: an exact copy of 530 bytes of Unused_TCRF_FacePhoto2_KAO_2_Gfx (from 30:67EF, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_36_4FBB_Unused_TCRF_FacePhoto2_KAO_2_Gfx_Part67EF::
    INCBIN "data/bank_36/Leftover_36_4FBB_Unused_TCRF_FacePhoto2_KAO_2_Gfx_Part67EF.bin" ; $4FBB, 530 bytes
; I: leftover load-record header, 6 bytes: 01 04 01 6A FA 03 = type 1, bank $04, load address $6A01, $03FA (1018) data
; bytes after it (the next header follows them); a record of an older build's image as a download stream in the PC's
; memory, that nothing in this build reads
Leftover_36_51CD_LoadRecord::
    db $01, $04, $01, $6a, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto3_KAO_3_Gfx (from 30:6A01, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_36_51D3_Unused_TCRF_FacePhoto3_KAO_3_Gfx_Part6A01::
    INCBIN "data/bank_36/Leftover_36_51D3_Unused_TCRF_FacePhoto3_KAO_3_Gfx_Part6A01.bin" ; $51D3, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 04 FB 6D FA 03 = type 1, bank $04, load address $6DFB, $03FA (1018) data
; bytes after it (the next header follows them); a record of an older build's image as a download stream in the PC's
; memory, that nothing in this build reads
Leftover_36_55CD_LoadRecord::
    db $01, $04, $fb, $6d, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto3_KAO_3_Gfx (from 30:6DFB, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_36_55D3_Unused_TCRF_FacePhoto3_KAO_3_Gfx_Part6DFB::
    INCBIN "data/bank_36/Leftover_36_55D3_Unused_TCRF_FacePhoto3_KAO_3_Gfx_Part6DFB.bin" ; $55D3, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 04 F5 71 FA 03 = type 1, bank $04, load address $71F5, $03FA (1018) data
; bytes after it (the next header follows them); a record of an older build's image as a download stream in the PC's
; memory, that nothing in this build reads
Leftover_36_59CD_LoadRecord::
    db $01, $04, $f5, $71, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto3_KAO_3_Gfx (from 30:71F5, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_36_59D3_Unused_TCRF_FacePhoto3_KAO_3_Gfx_Part71F5::
    INCBIN "data/bank_36/Leftover_36_59D3_Unused_TCRF_FacePhoto3_KAO_3_Gfx_Part71F5.bin" ; $59D3, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 04 EF 75 12 02 = type 1, bank $04, load address $75EF, $0212 (530) data
; bytes after it (the next header follows them); a record of an older build's image as a download stream in the PC's
; memory, that nothing in this build reads
Leftover_36_5DCD_LoadRecord::
    db $01, $04, $ef, $75, $12, $02

; I: leftover: an exact copy of 530 bytes of Unused_TCRF_FacePhoto3_KAO_3_Gfx (from 30:75EF, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_36_5DD3_Unused_TCRF_FacePhoto3_KAO_3_Gfx_Part75EF::
    INCBIN "data/bank_36/Leftover_36_5DD3_Unused_TCRF_FacePhoto3_KAO_3_Gfx_Part75EF.bin" ; $5DD3, 530 bytes
; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 04 FF 7F 01 00 = type 1, bank $04, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 18 records (owner 2026-11-22: part of the ...
Leftover_36_5FE5_LoadRecord::
    db $01, $04, $ff, $7f, $01, $00, $04

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 05 00 40 01 00 = type 1, bank $05, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 18 records (owner 2026-11-22: part of the ...
Leftover_36_5FEC_LoadRecord::
    db $01, $05, $00, $40, $01, $00, $05

; I: leftover load-record header, 6 bytes: 01 05 01 40 FA 03 = type 1, bank $05, load address $4001, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 18 records (owner 2026-11-22: part of the surrounding assets)
Leftover_36_5FF3_LoadRecord::
    db $01, $05, $01, $40, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto7_HOI_U_Gfx (from 05:4001, a part of the block),
; placed by the load-record header before it (36:5FF3); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_36_5FF9_Unused_TCRF_FacePhoto7_HOI_U_Gfx_Part4001::
    INCBIN "data/bank_36/Leftover_36_5FF9_Unused_TCRF_FacePhoto7_HOI_U_Gfx_Part4001.bin" ; $5FF9, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 05 FB 43 FA 03 = type 1, bank $05, load address $43FB, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 18 records (owner 2026-11-22: part of the surrounding assets)
Leftover_36_63F3_LoadRecord::
    db $01, $05, $fb, $43, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto7_HOI_U_Gfx (from 05:43FB, a part of the block),
; placed by the load-record header before it (36:63F3); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_36_63F9_Unused_TCRF_FacePhoto7_HOI_U_Gfx_Part43FB::
    INCBIN "data/bank_36/Leftover_36_63F9_Unused_TCRF_FacePhoto7_HOI_U_Gfx_Part43FB.bin" ; $63F9, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 05 F5 47 FA 03 = type 1, bank $05, load address $47F5, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 18 records (owner 2026-11-22: part of the surrounding assets)
Leftover_36_67F3_LoadRecord::
    db $01, $05, $f5, $47, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto7_HOI_U_Gfx (from 05:47F5, a part of the block),
; placed by the load-record header before it (36:67F3); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_36_67F9_Unused_TCRF_FacePhoto7_HOI_U_Gfx_Part47F5::
    INCBIN "data/bank_36/Leftover_36_67F9_Unused_TCRF_FacePhoto7_HOI_U_Gfx_Part47F5.bin" ; $67F9, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 05 EF 4B 12 02 = type 1, bank $05, load address $4BEF, $0212 (530) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 18 records (owner 2026-11-22: part of the surrounding assets)
Leftover_36_6BF3_LoadRecord::
    db $01, $05, $ef, $4b, $12, $02

; I: leftover: an exact copy of 530 bytes of Unused_TCRF_FacePhoto7_HOI_U_Gfx (from 05:4BEF, a part of the block),
; placed by the load-record header before it (36:6BF3); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_36_6BF9_Unused_TCRF_FacePhoto7_HOI_U_Gfx_Part4BEF::
    INCBIN "data/bank_36/Leftover_36_6BF9_Unused_TCRF_FacePhoto7_HOI_U_Gfx_Part4BEF.bin" ; $6BF9, 530 bytes
; I: leftover load-record header, 6 bytes: 01 05 01 4E FA 03 = type 1, bank $05, load address $4E01, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 18 records (owner 2026-11-22: part of the surrounding assets)
Leftover_36_6E0B_LoadRecord::
    db $01, $05, $01, $4e, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto8_HOI_D_Gfx (from 05:4E01, a part of the block),
; placed by the load-record header before it (36:6E0B); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_36_6E11_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part4E01::
    INCBIN "data/bank_36/Leftover_36_6E11_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part4E01.bin" ; $6E11, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 05 FB 51 FA 03 = type 1, bank $05, load address $51FB, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 18 records (owner 2026-11-22: part of the surrounding assets)
Leftover_36_720B_LoadRecord::
    db $01, $05, $fb, $51, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto8_HOI_D_Gfx (from 05:51FB, a part of the block),
; placed by the load-record header before it (36:720B); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_36_7211_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part51FB::
    INCBIN "data/bank_36/Leftover_36_7211_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part51FB.bin" ; $7211, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 05 F5 55 FA 03 = type 1, bank $05, load address $55F5, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 18 records (owner 2026-11-22: part of the surrounding assets)
Leftover_36_760B_LoadRecord::
    db $01, $05, $f5, $55, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto8_HOI_D_Gfx (from 05:55F5, a part of the block),
; placed by the load-record header before it (36:760B); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_36_7611_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part55F5::
    INCBIN "data/bank_36/Leftover_36_7611_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part55F5.bin" ; $7611, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 05 EF 59 12 02 = type 1, bank $05, load address $59EF, $0212 (530) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 18 records (owner 2026-11-22: part of the surrounding assets)
Leftover_36_7A0B_LoadRecord::
    db $01, $05, $ef, $59, $12, $02

; I: leftover: an exact copy of 530 bytes of Unused_TCRF_FacePhoto8_HOI_D_Gfx (from 05:59EF, a part of the block),
; placed by the load-record header before it (36:7A0B); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_36_7A11_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part59EF::
    INCBIN "data/bank_36/Leftover_36_7A11_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part59EF.bin" ; $7A11, 530 bytes
; I: leftover load-record header, 6 bytes: 01 05 01 5C FA 03 = type 1, bank $05, load address $5C01, $03FA (1018) data
; bytes after it (they run past the end of the bank); a record of an older build's image as a download stream in the
; PC's memory, that nothing in this build reads
Leftover_36_7C23_LoadRecord::
    db $01, $05, $01, $5c, $fa, $03

; I: leftover: an exact copy of 982 bytes of Unused_TCRF_FacePhoto9_HOI_L_Gfx (from 05:5C01, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_36_7C29_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part5C01::
    INCBIN "data/bank_36/Leftover_36_7C29_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part5C01.bin" ; $7C29, 982 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_36_7FFF::
    db $36
