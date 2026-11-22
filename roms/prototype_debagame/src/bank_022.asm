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

; I: leftover PC memory: 4 bytes (22:4100-4103), the 512-byte blocks of a leftover run that hold the dword $C2606000,
; a 4 KB-aligned address of the Windows 9x system arena ($C0000000 up), at offset $100 of the bank, as in the other
; banks that hold one; nothing in this build reads, runs or explains them; ...
Leftover_22_4100_PcRam::
    db $00, $60, $60, $c2

; I: leftover text: 261 bytes of the developers' assembler source in clear (0 listing lines, 6 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_22_4104_AsmSource::
    db "0,$30", $09, ";0095", $0d, $0a, $09, "DEFB", $09, "$20,$30,$20,$30,$10,$18,$08,$0C", $0d, $0a, $09, "DEFB", $09, "$00,$00,$20,$30,$10,$18,$08,$0C", $09, ";0096", $0d, $0a, $09, "DEFB", $09, "$08,$0C,$08,$0C,$10,$18,$20,$30", $0d, $0a, $09, "DEFB", $09, "$00,$00,$08,$0C,$10,$18,$20,$30", $09, ";0097", $0d, $0a, $09, "DEFB", $09, "$40,$60,$20,$30,$10,$18,$08,$0C", $0d, $0a, $09, "DEFB", $09, "$00,$00,$20,$30,$10,$18,$0", $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $a5

; I: leftover: an exact copy of 412 bytes of Map_02_5A41_BGSRAM1 (from 02:5AE5, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_22_4209_Map_02_5A41_BGSRAM1_Part5AE5::
    INCBIN "data/bank_22/Leftover_22_4209_Map_02_5A41_BGSRAM1_Part5AE5.bin" ; $4209, 412 bytes
; I: leftover load-record header, 6 bytes: 01 02 81 5C 40 02 = type 1, bank $02, load address $5C81, $0240 (576) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 22 records (owner 2026-11-22: part of the surrounding assets)
Leftover_22_43A5_LoadRecord::
    db $01, $02, $81, $5c, $40, $02

; I: leftover: an exact copy of 576 bytes of Map_02_5C81_BGSRAM2 (from 02:5C81), placed by the load-record header
; before it (22:43A5); nothing in this build reads, runs or explains it (never read nor run in the L2 runs)
Leftover_22_43AB_Map_02_5C81_BGSRAM2::
    INCBIN "data/bank_22/Leftover_22_43AB_Map_02_5C81_BGSRAM2.bin" ; $43AB, 576 bytes
; I: leftover load-record header, 6 bytes: 01 02 C1 5E 40 02 = type 1, bank $02, load address $5EC1, $0240 (576) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 22 records (owner 2026-11-22: part of the surrounding assets)
Leftover_22_45EB_LoadRecord::
    db $01, $02, $c1, $5e, $40, $02

; I: leftover: an exact copy of 576 bytes of Map_02_5EC1_BGSRAM3 (from 02:5EC1), placed by the load-record header
; before it (22:45EB); nothing in this build reads, runs or explains it (never read nor run in the L2 runs)
Leftover_22_45F1_Map_02_5EC1_BGSRAM3::
    INCBIN "data/bank_22/Leftover_22_45F1_Map_02_5EC1_BGSRAM3.bin" ; $45F1, 576 bytes
; I: leftover load-record header, 6 bytes: 01 02 01 61 40 02 = type 1, bank $02, load address $6101, $0240 (576) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 22 records (owner 2026-11-22: part of the surrounding assets)
Leftover_22_4831_LoadRecord::
    db $01, $02, $01, $61, $40, $02

; I: leftover: an exact copy of 576 bytes of Map_02_6101_BG_DUMP (from 02:6101), placed by the load-record header
; before it (22:4831); nothing in this build reads, runs or explains it (never read nor run in the L2 runs)
Leftover_22_4837_Map_02_6101_BG_DUMP::
    INCBIN "data/bank_22/Leftover_22_4837_Map_02_6101_BG_DUMP.bin" ; $4837, 576 bytes
; I: leftover load-record header, 6 bytes: 01 02 41 63 40 02 = type 1, bank $02, load address $6341, $0240 (576) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 22 records (owner 2026-11-22: part of the surrounding assets)
Leftover_22_4A77_LoadRecord::
    db $01, $02, $41, $63, $40, $02

; I: leftover: an exact copy of 576 bytes of Map_02_6341_BGPROTEC (from 02:6341), placed by the load-record header
; before it (22:4A77); nothing in this build reads, runs or explains it (never read nor run in the L2 runs)
Leftover_22_4A7D_Map_02_6341_BGPROTEC::
    INCBIN "data/bank_22/Leftover_22_4A7D_Map_02_6341_BGPROTEC.bin" ; $4A7D, 576 bytes
; I: leftover load-record header, 6 bytes: 01 02 81 65 FA 03 = type 1, bank $02, load address $6581, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 22 records (owner 2026-11-22: part of the surrounding assets)
Leftover_22_4CBD_LoadRecord::
    db $01, $02, $81, $65, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_PROGRAM_Gfx (from 02:6581, a part of the block), placed by the
; load-record header before it (22:4CBD); nothing in this build reads, runs or explains it (never read nor run in the
; L2 runs)
Leftover_22_4CC3_Unused_PROGRAM_Gfx_Part6581::
    INCBIN "data/bank_22/Leftover_22_4CC3_Unused_PROGRAM_Gfx_Part6581.bin" ; $4CC3, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 02 7B 69 FA 03 = type 1, bank $02, load address $697B, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 22 records (owner 2026-11-22: part of the surrounding assets)
Leftover_22_50BD_LoadRecord::
    db $01, $02, $7b, $69, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_PROGRAM_Gfx (from 02:697B, a part of the block), placed by the
; load-record header before it (22:50BD); nothing in this build reads, runs or explains it (never read nor run in the
; L2 runs)
Leftover_22_50C3_Unused_PROGRAM_Gfx_Part697B::
    INCBIN "data/bank_22/Leftover_22_50C3_Unused_PROGRAM_Gfx_Part697B.bin" ; $50C3, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 02 75 6D FA 03 = type 1, bank $02, load address $6D75, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 22 records (owner 2026-11-22: part of the surrounding assets)
Leftover_22_54BD_LoadRecord::
    db $01, $02, $75, $6d, $fa, $03

; I: leftover: an exact copy of 12 bytes of Unused_PROGRAM_Gfx (from 02:6D75, a part of the block), placed by the
; load-record header before it (22:54BD); nothing in this build reads, runs or explains it (never read nor run in the
; L2 runs)
Leftover_22_54C3_Unused_PROGRAM_Gfx_Part6D75::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

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
    INCBIN "data/bank_22/Leftover_22_56E1_Gfx_01_4001_FNTOOE1_VariantPart4A13.bin" ; $56E1, 476 bytes
; I: leftover load-record header, 6 bytes: 01 02 6F 71 FA 03 = type 1, bank $02, load address $716F, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 22 records (owner 2026-11-22: part of the surrounding assets)
Leftover_22_58BD_LoadRecord::
    db $01, $02, $6f, $71, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Gfx_01_4001_FNTOOE1 (from 01:4BEF, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_22_58C3_Gfx_01_4001_FNTOOE1_Part4BEF::
    INCBIN "data/bank_22/Leftover_22_58C3_Gfx_01_4001_FNTOOE1_Part4BEF.bin" ; $58C3, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 02 69 75 FA 03 = type 1, bank $02, load address $7569, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 22 records (owner 2026-11-22: part of the surrounding assets)
Leftover_22_5CBD_LoadRecord::
    db $01, $02, $69, $75, $fa, $03, $ff, $ff, $ff, $ff, $7e, $7e, $3c, $3c

    ; padding
    ds $10, $00

; I: leftover: an exact copy of 994 bytes of Unused_TCRF_EditorUI_Gfx (from 02:7581, a part of the block), placed by
; the load-record header before it (22:5CBD); nothing in this build reads, runs or explains it (never read nor run in
; the L2 runs)
Leftover_22_5CDB_Unused_TCRF_EditorUI_Gfx_Part7581::
    INCBIN "data/bank_22/Leftover_22_5CDB_Unused_TCRF_EditorUI_Gfx_Part7581.bin" ; $5CDB, 994 bytes
; I: leftover load-record header, 6 bytes: 01 02 63 79 FA 03 = type 1, bank $02, load address $7963, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 22 records (owner 2026-11-22: part of the surrounding assets)
Leftover_22_60BD_LoadRecord::
    db $01, $02, $63, $79, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_EditorUI_Gfx (from 02:7963, a part of the block), placed by
; the load-record header before it (22:60BD); nothing in this build reads, runs or explains it (never read nor run in
; the L2 runs)
Leftover_22_60C3_Unused_TCRF_EditorUI_Gfx_Part7963::
    INCBIN "data/bank_22/Leftover_22_60C3_Unused_TCRF_EditorUI_Gfx_Part7963.bin" ; $60C3, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 02 5D 7D 24 00 = type 1, bank $02, load address $7D5D, $0024 (36) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 22 records (owner 2026-11-22: part of the surrounding assets)
Leftover_22_64BD_LoadRecord::
    db $01, $02, $5d, $7d, $24, $00

; I: leftover: an exact copy of 36 bytes of Unused_TCRF_EditorUI_Gfx (from 02:7D5D, a part of the block), placed by
; the load-record header before it (22:64BD); nothing in this build reads, runs or explains it (never read nor run in
; the L2 runs)
Leftover_22_64C3_Unused_TCRF_EditorUI_Gfx_Part7D5D::
    db $ff, $00, $ff, $00, $cf, $c0, $cf, $c0, $cf, $c0, $cf, $c0, $cf, $c0, $cf, $00
    db $cf, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 02 FF 7F 01 00 = type 1, bank $02, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 22 records (owner 2026-11-22: part of the ...
Leftover_22_64E7_LoadRecord::
    db $01, $02, $ff, $7f, $01, $00, $02

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 03 00 40 01 00 = type 1, bank $03, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 22 records (owner 2026-11-22: part of the ...
Leftover_22_64EE_LoadRecord::
    db $01, $03, $00, $40, $01, $00, $03

; I: leftover load-record header, 6 bytes: 01 03 01 40 FA 03 = type 1, bank $03, load address $4001, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 22 records (owner 2026-11-22: part of the surrounding assets)
Leftover_22_64F5_LoadRecord::
    db $01, $03, $01, $40, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Gfx_03_4001_FNTOOE3 (from 03:4001, a part of the block), placed by the
; load-record header before it (22:64F5); nothing in this build reads, runs or explains it (never read nor run in the
; L2 runs)
Leftover_22_64FB_Gfx_03_4001_FNTOOE3_Part4001::
    INCBIN "data/bank_22/Leftover_22_64FB_Gfx_03_4001_FNTOOE3_Part4001.bin" ; $64FB, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 03 FB 43 FA 03 = type 1, bank $03, load address $43FB, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 22 records (owner 2026-11-22: part of the surrounding assets)
Leftover_22_68F5_LoadRecord::
    db $01, $03, $fb, $43, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Gfx_03_4001_FNTOOE3 (from 03:43FB, a part of the block), placed by the
; load-record header before it (22:68F5); nothing in this build reads, runs or explains it (never read nor run in the
; L2 runs)
Leftover_22_68FB_Gfx_03_4001_FNTOOE3_Part43FB::
    INCBIN "data/bank_22/Leftover_22_68FB_Gfx_03_4001_FNTOOE3_Part43FB.bin" ; $68FB, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 03 F5 47 FA 03 = type 1, bank $03, load address $47F5, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 22 records (owner 2026-11-22: part of the surrounding assets)
Leftover_22_6CF5_LoadRecord::
    db $01, $03, $f5, $47, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Gfx_03_4001_FNTOOE3 (from 03:47F5, a part of the block), placed by the
; load-record header before it (22:6CF5); nothing in this build reads, runs or explains it (never read nor run in the
; L2 runs)
Leftover_22_6CFB_Gfx_03_4001_FNTOOE3_Part47F5::
    INCBIN "data/bank_22/Leftover_22_6CFB_Gfx_03_4001_FNTOOE3_Part47F5.bin" ; $6CFB, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 03 EF 4B FA 03 = type 1, bank $03, load address $4BEF, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 22 records (owner 2026-11-22: part of the surrounding assets)
Leftover_22_70F5_LoadRecord::
    db $01, $03, $ef, $4b, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Gfx_03_4001_FNTOOE3 (from 03:4BEF, a part of the block), placed by the
; load-record header before it (22:70F5); nothing in this build reads, runs or explains it (never read nor run in the
; L2 runs)
Leftover_22_70FB_Gfx_03_4001_FNTOOE3_Part4BEF::
    INCBIN "data/bank_22/Leftover_22_70FB_Gfx_03_4001_FNTOOE3_Part4BEF.bin" ; $70FB, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 03 E9 4F FA 03 = type 1, bank $03, load address $4FE9, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 22 records (owner 2026-11-22: part of the surrounding assets)
Leftover_22_74F5_LoadRecord::
    db $01, $03, $e9, $4f, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Gfx_03_4001_FNTOOE3 (from 03:4FE9, a part of the block), placed by the
; load-record header before it (22:74F5); nothing in this build reads, runs or explains it (never read nor run in the
; L2 runs)
Leftover_22_74FB_Gfx_03_4001_FNTOOE3_Part4FE9::
    INCBIN "data/bank_22/Leftover_22_74FB_Gfx_03_4001_FNTOOE3_Part4FE9.bin" ; $74FB, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 03 E3 53 FA 03 = type 1, bank $03, load address $53E3, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 22 records (owner 2026-11-22: part of the surrounding assets)
Leftover_22_78F5_LoadRecord::
    db $01, $03, $e3, $53, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Gfx_03_4001_FNTOOE3 (from 03:53E3, a part of the block), placed by the
; load-record header before it (22:78F5); nothing in this build reads, runs or explains it (never read nor run in the
; L2 runs)
Leftover_22_78FB_Gfx_03_4001_FNTOOE3_Part53E3::
    INCBIN "data/bank_22/Leftover_22_78FB_Gfx_03_4001_FNTOOE3_Part53E3.bin" ; $78FB, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 03 DD 57 24 00 = type 1, bank $03, load address $57DD, $0024 (36) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 22 records (owner 2026-11-22: part of the surrounding assets)
Leftover_22_7CF5_LoadRecord::
    db $01, $03, $dd, $57, $24

    ; padding
    ds $1, $00

; I: leftover: an exact copy of 36 bytes of Gfx_03_4001_FNTOOE3 (from 03:57DD, a part of the block), placed by the
; load-record header before it (22:7CF5); nothing in this build reads, runs or explains it (never read nor run in the
; L2 runs)
Leftover_22_7CFB_Gfx_03_4001_FNTOOE3_Part57DD::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00

; I: leftover load-record header, 6 bytes: 01 03 01 58 40 02 = type 1, bank $03, load address $5801, $0240 (576) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 22 records (owner 2026-11-22: part of the surrounding assets)
Leftover_22_7D1F_LoadRecord::
    db $01, $03, $01, $58, $40, $02

; I: leftover: an exact copy of 576 bytes of Map_03_5801_BG_MOVIE (from 03:5801), placed by the load-record header
; before it (22:7D1F); nothing in this build reads, runs or explains it (never read nor run in the L2 runs)
Leftover_22_7D25_Map_03_5801_BG_MOVIE::
    INCBIN "data/bank_22/Leftover_22_7D25_Map_03_5801_BG_MOVIE.bin" ; $7D25, 576 bytes
; I: leftover load-record header, 6 bytes: 01 03 41 5A FA 03 = type 1, bank $03, load address $5A41, $03FA (1018) data
; bytes after it (they run past the end of the bank); a record of an older build's image as a download stream in the
; PC's memory, that nothing in this build reads
Leftover_22_7F65_LoadRecord::
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
