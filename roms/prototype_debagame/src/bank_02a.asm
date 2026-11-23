; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $2A. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $02a", ROMX[$4000], BANK[$2a]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_2A_4000::
    db $2a

; I: leftover text: 255 bytes of the developers' assembler source in clear (0 listing lines, 6 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_2A_4001_AsmSource::
    db ",$00,$FF,$00", $09, ";0092", $0d, $0a, $09, "DEFB", $09, "$FF,$00,$FF,$38,$EF,$28,$FF,$38", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$10,$18,$00,$00", $09, ";0093", $0d, $0a, $09, "DEFB", $09, "$00,$00,$10,$18,$00,$00,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$10,$18,$00,$00", $09, ";0094", $0d, $0a, $09, "DEFB", $09, "$00,$00,$10,$18,$20,$30,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,$00,$08,$0C,$10,$1"

; I: leftover PC memory: 4 bytes (2A:4100-4103), a leftover run that holds the dword $C25D3000, a 4 KB-aligned address
; of the Windows 9x system arena ($C0000000 up), at offset $100 of the bank, as in the other banks that hold one;
; nothing in this build reads, runs or explains it; only those proofs are ...
Leftover_2A_4100_PcRam::
    db $00, $30, $5d, $c2

; I: leftover text: 252 bytes of the developers' assembler source in clear (0 listing lines, 6 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_2A_4104_AsmSource::
    db "0,$30", $09, ";0095", $0d, $0a, $09, "DEFB", $09, "$20,$30,$20,$30,$10,$18,$08,$0C", $0d, $0a, $09, "DEFB", $09, "$00,$00,$20,$30,$10,$18,$08,$0C", $09, ";0096", $0d, $0a, $09, "DEFB", $09, "$08,$0C,$08,$0C,$10,$18,$20,$30", $0d, $0a, $09, "DEFB", $09, "$00,$00,$08,$0C,$10,$18,$20,$30", $09, ";0097", $0d, $0a, $09, "DEFB", $09, "$40,$60,$20,$30,$10,$18,$08,$0C", $0d, $0a, $09, "DEFB", $09, "$00,$00,$20,$30,$10,$18,$0"

; I: leftover: an exact copy of 103 bytes of Unused_TCRF_FaceDrawing1_FACE5_Gfx (from 06:44D0, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_2A_4200_Unused_TCRF_FaceDrawing1_FACE5_Gfx_Part44D0::
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $01, $ff, $01

; I: leftover: an exact copy of 408 bytes of Unused_TCRF_FaceDrawing4_FACE8_Gfx (from 06:705D, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_2A_4267_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part705D::
    INCBIN "data/bank_2a/Leftover_2A_4267_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part705D.bin" ; $4267, 408 bytes
; I: leftover load-record header, 6 bytes: 01 06 F5 71 FA 03 = type 1, bank $06, load address $71F5, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 53 records (owner 2026-11-22: part of the surrounding assets)
Leftover_2A_43FF_LoadRecord::
    db $01, $06, $f5, $71, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FaceDrawing4_FACE8_Gfx (from 06:71F5, a part of the block),
; placed by the load-record header before it (2A:43FF); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_2A_4405_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part71F5::
    INCBIN "data/bank_2a/Leftover_2A_4405_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part71F5.bin" ; $4405, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 06 EF 75 12 02 = type 1, bank $06, load address $75EF, $0212 (530) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 53 records (owner 2026-11-22: part of the surrounding assets)
Leftover_2A_47FF_LoadRecord::
    db $01, $06, $ef, $75, $12, $02

; I: leftover: an exact copy of 530 bytes of Unused_TCRF_FaceDrawing4_FACE8_Gfx (from 06:75EF, a part of the block),
; placed by the load-record header before it (2A:47FF); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_2A_4805_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part75EF::
    INCBIN "data/bank_2a/Leftover_2A_4805_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part75EF.bin" ; $4805, 530 bytes
; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 06 FF 7F 01 00 = type 1, bank $06, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4A17_LoadRecord::
    db $01, $06, $ff, $7f, $01, $00, $06

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 07 00 40 01 00 = type 1, bank $07, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4A1E_LoadRecord::
    db $01, $07, $00, $40, $01, $00, $07

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 07 FF 7F 01 00 = type 1, bank $07, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4A25_LoadRecord::
    db $01, $07, $ff, $7f, $01, $00, $07

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 08 00 40 01 00 = type 1, bank $08, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4A2C_LoadRecord::
    db $01, $08, $00, $40, $01, $00, $08

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 08 FF 7F 01 00 = type 1, bank $08, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4A33_LoadRecord::
    db $01, $08, $ff, $7f, $01, $00, $08

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 09 00 40 01 00 = type 1, bank $09, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4A3A_LoadRecord::
    db $01, $09, $00, $40, $01, $00, $09

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 09 FF 7F 01 00 = type 1, bank $09, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4A41_LoadRecord::
    db $01, $09, $ff, $7f, $01, $00, $09

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 0A 00 40 01 00 = type 1, bank $0A, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4A48_LoadRecord::
    db $01, $0a, $00, $40, $01, $00, $0a

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 0A FF 7F 01 00 = type 1, bank $0A, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4A4F_LoadRecord::
    db $01, $0a, $ff, $7f, $01, $00, $0a

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 0B 00 40 01 00 = type 1, bank $0B, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4A56_LoadRecord::
    db $01, $0b, $00, $40, $01, $00, $0b

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 0B FF 7F 01 00 = type 1, bank $0B, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4A5D_LoadRecord::
    db $01, $0b, $ff, $7f, $01, $00, $0b

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 0C 00 40 01 00 = type 1, bank $0C, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4A64_LoadRecord::
    db $01, $0c, $00, $40, $01, $00, $0c

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 0C FF 7F 01 00 = type 1, bank $0C, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4A6B_LoadRecord::
    db $01, $0c, $ff, $7f, $01, $00, $0c

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 0D 00 40 01 00 = type 1, bank $0D, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4A72_LoadRecord::
    db $01, $0d, $00, $40, $01, $00, $0d

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 0D FF 7F 01 00 = type 1, bank $0D, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4A79_LoadRecord::
    db $01, $0d, $ff, $7f, $01, $00, $0d

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 0E 00 40 01 00 = type 1, bank $0E, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4A80_LoadRecord::
    db $01, $0e, $00, $40, $01, $00, $0e

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 0E FF 7F 01 00 = type 1, bank $0E, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4A87_LoadRecord::
    db $01, $0e, $ff, $7f, $01, $00, $0e

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 0F 00 40 01 00 = type 1, bank $0F, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4A8E_LoadRecord::
    db $01, $0f, $00, $40, $01, $00, $0f

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 0F FF 7F 01 00 = type 1, bank $0F, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4A95_LoadRecord::
    db $01, $0f, $ff, $7f, $01, $00, $0f

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 10 00 40 01 00 = type 1, bank $10, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4A9C_LoadRecord::
    db $01, $10, $00, $40, $01, $00, $10

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 10 FF 7F 01 00 = type 1, bank $10, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4AA3_LoadRecord::
    db $01, $10, $ff, $7f, $01, $00, $10

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 11 00 40 01 00 = type 1, bank $11, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4AAA_LoadRecord::
    db $01, $11, $00, $40, $01, $00, $11

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 11 FF 7F 01 00 = type 1, bank $11, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4AB1_LoadRecord::
    db $01, $11, $ff, $7f, $01, $00, $11

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 12 00 40 01 00 = type 1, bank $12, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4AB8_LoadRecord::
    db $01, $12, $00, $40, $01, $00, $12

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 12 FF 7F 01 00 = type 1, bank $12, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4ABF_LoadRecord::
    db $01, $12, $ff, $7f, $01, $00, $12

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 13 00 40 01 00 = type 1, bank $13, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4AC6_LoadRecord::
    db $01, $13, $00, $40, $01, $00, $13

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 13 FF 7F 01 00 = type 1, bank $13, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4ACD_LoadRecord::
    db $01, $13, $ff, $7f, $01, $00, $13

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 14 00 40 01 00 = type 1, bank $14, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4AD4_LoadRecord::
    db $01, $14, $00, $40, $01, $00, $14

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 14 FF 7F 01 00 = type 1, bank $14, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4ADB_LoadRecord::
    db $01, $14, $ff, $7f, $01, $00, $14

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 15 00 40 01 00 = type 1, bank $15, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4AE2_LoadRecord::
    db $01, $15, $00, $40, $01, $00, $15

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 15 FF 7F 01 00 = type 1, bank $15, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4AE9_LoadRecord::
    db $01, $15, $ff, $7f, $01, $00, $15

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 16 00 40 01 00 = type 1, bank $16, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4AF0_LoadRecord::
    db $01, $16, $00, $40, $01, $00, $16

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 16 FF 7F 01 00 = type 1, bank $16, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4AF7_LoadRecord::
    db $01, $16, $ff, $7f, $01, $00, $16

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 17 00 40 01 00 = type 1, bank $17, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4AFE_LoadRecord::
    db $01, $17, $00, $40, $01, $00, $17

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 17 FF 7F 01 00 = type 1, bank $17, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4B05_LoadRecord::
    db $01, $17, $ff, $7f, $01, $00, $17

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 18 00 40 01 00 = type 1, bank $18, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4B0C_LoadRecord::
    db $01, $18, $00, $40, $01, $00, $18

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 18 FF 7F 01 00 = type 1, bank $18, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4B13_LoadRecord::
    db $01, $18, $ff, $7f, $01, $00, $18

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 19 00 40 01 00 = type 1, bank $19, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4B1A_LoadRecord::
    db $01, $19, $00, $40, $01, $00, $19

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 19 FF 7F 01 00 = type 1, bank $19, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4B21_LoadRecord::
    db $01, $19, $ff, $7f, $01, $00, $19

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 1A 00 40 01 00 = type 1, bank $1A, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4B28_LoadRecord::
    db $01, $1a, $00, $40, $01, $00, $1a

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 1A FF 7F 01 00 = type 1, bank $1A, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4B2F_LoadRecord::
    db $01, $1a, $ff, $7f, $01, $00, $1a

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 1B 00 40 01 00 = type 1, bank $1B, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4B36_LoadRecord::
    db $01, $1b, $00, $40, $01, $00, $1b

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 1B FF 7F 01 00 = type 1, bank $1B, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4B3D_LoadRecord::
    db $01, $1b, $ff, $7f, $01, $00, $1b

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 1C 00 40 01 00 = type 1, bank $1C, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4B44_LoadRecord::
    db $01, $1c, $00, $40, $01, $00, $1c

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 1C FF 7F 01 00 = type 1, bank $1C, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4B4B_LoadRecord::
    db $01, $1c, $ff, $7f, $01, $00, $1c

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 1D 00 40 01 00 = type 1, bank $1D, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4B52_LoadRecord::
    db $01, $1d, $00, $40, $01, $00, $1d

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 1D FF 7F 01 00 = type 1, bank $1D, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4B59_LoadRecord::
    db $01, $1d, $ff, $7f, $01, $00, $1d

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 1E 00 40 01 00 = type 1, bank $1E, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4B60_LoadRecord::
    db $01, $1e, $00, $40, $01, $00, $1e

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 1E FF 7F 01 00 = type 1, bank $1E, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4B67_LoadRecord::
    db $01, $1e, $ff, $7f, $01, $00, $1e

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 1F 00 40 01 00 = type 1, bank $1F, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4B6E_LoadRecord::
    db $01, $1f, $00, $40, $01, $00, $1f

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 1F FF 7F 01 00 = type 1, bank $1F, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_2A_4B75_LoadRecord::
    db $01, $1f, $ff, $7f, $01, $00, $1f, $04, $a2, $02

; C: binary symbol table of an older build, 674 records (tools/proto_symtab.py)
OldSymbolTable_2A_4B7F::
    INCBIN "data/bank_2a/OldSymbolTable_2A_4B7F.bin" ; $4B7F, 8522 bytes
; I: leftover PC memory: 4918 bytes (2A:6CC9-7FFE), a leftover run that shares a 16-byte piece (at 2A:6D0D) with the
; PC memory at 35:6D54 (Leftover_35_6D1C_PcRam); nothing in this build reads, runs or explains it (owner 2026-11-23: a
; similarity with PC memory elsewhere makes the run PC memory)
Leftover_2A_6CC9_PcRam::
    INCBIN "data/bank_2a/Leftover_2A_6CC9_PcRam.bin" ; $6CC9, 4918 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_2A_7FFF::
    db $2a
