; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $35. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $035", ROMX[$4000], BANK[$35]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_35_4000::
    db $35

; I: leftover: an exact copy of 255 bytes of Unused_TCRF_FacePhoto8_HOI_D_Gfx (from 05:4F59, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_35_4001_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part4F59::
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $7f, $ff, $ff, $ff, $fd, $ff, $ff, $ff, $77, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fd, $ff, $ff, $ff, $f7, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $dd, $ff, $ff, $ff, $77, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $77, $ff, $c0, $80, $c0, $c0, $a0, $e0, $10, $f0
    db $f0, $f8, $dc, $f0, $fc, $f8, $54, $fc, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $0a, $07, $09, $07, $03, $0f, $15, $0f
    db $2f, $1f, $57, $3f, $7f, $3f, $1f, $7f, $ff, $ff, $ff, $ff, $bf, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $5f, $ff
    db $bf, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

; I: leftover PC memory: 4 bytes (35:4100-4103), the 512-byte blocks of a leftover run that hold the dword $C216E000,
; a 4 KB-aligned address of the Windows 9x system arena ($C0000000 up), at offset $100 of the bank, as in the other
; banks that hold one; nothing in this build reads, runs or explains them; ...
Leftover_35_4100_PcRam::
    db $00, $e0, $16, $c2

; I: leftover: an exact copy of 252 bytes of Unused_TCRF_FacePhoto8_HOI_D_Gfx (from 05:505C, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_35_4104_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part505C::
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $f7, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $77, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $77, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f7, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $7f, $ff, $f8, $fe, $ff, $fc, $ff, $fe, $74, $ff, $fe, $ff, $fd
    db $ff, $fe, $ff, $77, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
    db $00, $00, $80, $00, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01
    db $00, $01, $00, $00, $01, $bf, $7f, $17, $7f, $bf, $7f, $1f, $7f, $7f, $ff, $5f
    db $ff, $ff, $ff, $5f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

; I: leftover: an exact copy of 273 bytes of Unused_TCRF_FaceDrawing4_FACE8_Gfx (from 06:70E4, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_35_4200_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part70E4::
    INCBIN "data/bank_35/Leftover_35_4200_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part70E4.bin" ; $4200, 273 bytes
; I: leftover load-record header, 6 bytes: 01 06 F5 71 FA 03 = type 1, bank $06, load address $71F5, $03FA (1018) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 53 records (owner 2026-11-22: part of the surrounding assets)
Leftover_35_4311_LoadRecord::
    db $01, $06, $f5, $71, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FaceDrawing4_FACE8_Gfx (from 06:71F5, a part of the block),
; placed by the load-record header before it (35:4311); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_35_4317_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part71F5::
    INCBIN "data/bank_35/Leftover_35_4317_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part71F5.bin" ; $4317, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 06 EF 75 12 02 = type 1, bank $06, load address $75EF, $0212 (530) data
; bytes after it (equal to this build's bytes there); a record of a build's image as a download stream, in a chain of
; 53 records (owner 2026-11-22: part of the surrounding assets)
Leftover_35_4711_LoadRecord::
    db $01, $06, $ef, $75, $12, $02

; I: leftover: an exact copy of 530 bytes of Unused_TCRF_FaceDrawing4_FACE8_Gfx (from 06:75EF, a part of the block),
; placed by the load-record header before it (35:4711); nothing in this build reads, runs or explains it (never read
; nor run in the L2 runs)
Leftover_35_4717_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part75EF::
    INCBIN "data/bank_35/Leftover_35_4717_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part75EF.bin" ; $4717, 530 bytes
; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 06 FF 7F 01 00 = type 1, bank $06, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4929_LoadRecord::
    db $01, $06, $ff, $7f, $01, $00, $06

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 07 00 40 01 00 = type 1, bank $07, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4930_LoadRecord::
    db $01, $07, $00, $40, $01, $00, $07

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 07 FF 7F 01 00 = type 1, bank $07, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4937_LoadRecord::
    db $01, $07, $ff, $7f, $01, $00, $07

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 08 00 40 01 00 = type 1, bank $08, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_493E_LoadRecord::
    db $01, $08, $00, $40, $01, $00, $08

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 08 FF 7F 01 00 = type 1, bank $08, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4945_LoadRecord::
    db $01, $08, $ff, $7f, $01, $00, $08

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 09 00 40 01 00 = type 1, bank $09, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_494C_LoadRecord::
    db $01, $09, $00, $40, $01, $00, $09

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 09 FF 7F 01 00 = type 1, bank $09, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4953_LoadRecord::
    db $01, $09, $ff, $7f, $01, $00, $09

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 0A 00 40 01 00 = type 1, bank $0A, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_495A_LoadRecord::
    db $01, $0a, $00, $40, $01, $00, $0a

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 0A FF 7F 01 00 = type 1, bank $0A, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4961_LoadRecord::
    db $01, $0a, $ff, $7f, $01, $00, $0a

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 0B 00 40 01 00 = type 1, bank $0B, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4968_LoadRecord::
    db $01, $0b, $00, $40, $01, $00, $0b

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 0B FF 7F 01 00 = type 1, bank $0B, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_496F_LoadRecord::
    db $01, $0b, $ff, $7f, $01, $00, $0b

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 0C 00 40 01 00 = type 1, bank $0C, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4976_LoadRecord::
    db $01, $0c, $00, $40, $01, $00, $0c

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 0C FF 7F 01 00 = type 1, bank $0C, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_497D_LoadRecord::
    db $01, $0c, $ff, $7f, $01, $00, $0c

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 0D 00 40 01 00 = type 1, bank $0D, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4984_LoadRecord::
    db $01, $0d, $00, $40, $01, $00, $0d

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 0D FF 7F 01 00 = type 1, bank $0D, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_498B_LoadRecord::
    db $01, $0d, $ff, $7f, $01, $00, $0d

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 0E 00 40 01 00 = type 1, bank $0E, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4992_LoadRecord::
    db $01, $0e, $00, $40, $01, $00, $0e

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 0E FF 7F 01 00 = type 1, bank $0E, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4999_LoadRecord::
    db $01, $0e, $ff, $7f, $01, $00, $0e

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 0F 00 40 01 00 = type 1, bank $0F, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_49A0_LoadRecord::
    db $01, $0f, $00, $40, $01, $00, $0f

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 0F FF 7F 01 00 = type 1, bank $0F, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_49A7_LoadRecord::
    db $01, $0f, $ff, $7f, $01, $00, $0f

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 10 00 40 01 00 = type 1, bank $10, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_49AE_LoadRecord::
    db $01, $10, $00, $40, $01, $00, $10

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 10 FF 7F 01 00 = type 1, bank $10, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_49B5_LoadRecord::
    db $01, $10, $ff, $7f, $01, $00, $10

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 11 00 40 01 00 = type 1, bank $11, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_49BC_LoadRecord::
    db $01, $11, $00, $40, $01, $00, $11

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 11 FF 7F 01 00 = type 1, bank $11, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_49C3_LoadRecord::
    db $01, $11, $ff, $7f, $01, $00, $11

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 12 00 40 01 00 = type 1, bank $12, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_49CA_LoadRecord::
    db $01, $12, $00, $40, $01, $00, $12

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 12 FF 7F 01 00 = type 1, bank $12, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_49D1_LoadRecord::
    db $01, $12, $ff, $7f, $01, $00, $12

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 13 00 40 01 00 = type 1, bank $13, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_49D8_LoadRecord::
    db $01, $13, $00, $40, $01, $00, $13

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 13 FF 7F 01 00 = type 1, bank $13, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_49DF_LoadRecord::
    db $01, $13, $ff, $7f, $01, $00, $13

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 14 00 40 01 00 = type 1, bank $14, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_49E6_LoadRecord::
    db $01, $14, $00, $40, $01, $00, $14

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 14 FF 7F 01 00 = type 1, bank $14, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_49ED_LoadRecord::
    db $01, $14, $ff, $7f, $01, $00, $14

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 15 00 40 01 00 = type 1, bank $15, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_49F4_LoadRecord::
    db $01, $15, $00, $40, $01, $00, $15

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 15 FF 7F 01 00 = type 1, bank $15, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_49FB_LoadRecord::
    db $01, $15, $ff, $7f, $01, $00, $15

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 16 00 40 01 00 = type 1, bank $16, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4A02_LoadRecord::
    db $01, $16, $00, $40, $01, $00, $16

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 16 FF 7F 01 00 = type 1, bank $16, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4A09_LoadRecord::
    db $01, $16, $ff, $7f, $01, $00, $16

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 17 00 40 01 00 = type 1, bank $17, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4A10_LoadRecord::
    db $01, $17, $00, $40, $01, $00, $17

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 17 FF 7F 01 00 = type 1, bank $17, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4A17_LoadRecord::
    db $01, $17, $ff, $7f, $01, $00, $17

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 18 00 40 01 00 = type 1, bank $18, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4A1E_LoadRecord::
    db $01, $18, $00, $40, $01, $00, $18

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 18 FF 7F 01 00 = type 1, bank $18, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4A25_LoadRecord::
    db $01, $18, $ff, $7f, $01, $00, $18

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 19 00 40 01 00 = type 1, bank $19, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4A2C_LoadRecord::
    db $01, $19, $00, $40, $01, $00, $19

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 19 FF 7F 01 00 = type 1, bank $19, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4A33_LoadRecord::
    db $01, $19, $ff, $7f, $01, $00, $19

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 1A 00 40 01 00 = type 1, bank $1A, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4A3A_LoadRecord::
    db $01, $1a, $00, $40, $01, $00, $1a

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 1A FF 7F 01 00 = type 1, bank $1A, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4A41_LoadRecord::
    db $01, $1a, $ff, $7f, $01, $00, $1a

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 1B 00 40 01 00 = type 1, bank $1B, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4A48_LoadRecord::
    db $01, $1b, $00, $40, $01, $00, $1b

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 1B FF 7F 01 00 = type 1, bank $1B, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4A4F_LoadRecord::
    db $01, $1b, $ff, $7f, $01, $00, $1b

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 1C 00 40 01 00 = type 1, bank $1C, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4A56_LoadRecord::
    db $01, $1c, $00, $40, $01, $00, $1c

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 1C FF 7F 01 00 = type 1, bank $1C, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4A5D_LoadRecord::
    db $01, $1c, $ff, $7f, $01, $00, $1c

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 1D 00 40 01 00 = type 1, bank $1D, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4A64_LoadRecord::
    db $01, $1d, $00, $40, $01, $00, $1d

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 1D FF 7F 01 00 = type 1, bank $1D, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4A6B_LoadRecord::
    db $01, $1d, $ff, $7f, $01, $00, $1d

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 1E 00 40 01 00 = type 1, bank $1E, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4A72_LoadRecord::
    db $01, $1e, $00, $40, $01, $00, $1e

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 1E FF 7F 01 00 = type 1, bank $1E, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4A79_LoadRecord::
    db $01, $1e, $ff, $7f, $01, $00, $1e

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 1F 00 40 01 00 = type 1, bank $1F, load address
; $4000, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4A80_LoadRecord::
    db $01, $1f, $00, $40, $01, $00, $1f

; I: leftover load-record header, 6 bytes and its payload, 1 bytes: 01 1F FF 7F 01 00 = type 1, bank $1F, load address
; $7FFF, $0001 (1) data bytes after it (equal to this build's bytes there); a record of a build's image as a download
; stream, in a chain of 53 records (owner 2026-11-22: part of the ...
Leftover_35_4A87_LoadRecord::
    db $01, $1f, $ff, $7f, $01, $00, $1f, $04, $c1, $02

; C: binary symbol table of an older build, 705 records (tools/proto_symtab.py)
OldSymbolTable_35_4A91::
    INCBIN "data/bank_35/OldSymbolTable_35_4A91.bin" ; $4A91, 8843 bytes
; I: leftover: 2276 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_35_6D1C::
    INCBIN "data/bank_35/Leftover_35_6D1C.bin" ; $6D1C, 2276 bytes
; I: leftover: an exact copy of 925 bytes of Unused_TCRF_FacePhoto1_KAO_1_Gfx (from 30:4E5E, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_35_7600_Unused_TCRF_FacePhoto1_KAO_1_Gfx_Part4E5E::
    INCBIN "data/bank_35/Leftover_35_7600_Unused_TCRF_FacePhoto1_KAO_1_Gfx_Part4E5E.bin" ; $7600, 925 bytes
; I: leftover load-record header, 6 bytes: 01 04 FB 51 FA 03 = type 1, bank $04, load address $51FB, $03FA (1018) data
; bytes after it (the next header follows them); a record of an older build's image as a download stream in the PC's
; memory, that nothing in this build reads
Leftover_35_799D_LoadRecord::
    db $01, $04, $fb, $51, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto1_KAO_1_Gfx (from 30:51FB, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_35_79A3_Unused_TCRF_FacePhoto1_KAO_1_Gfx_Part51FB::
    INCBIN "data/bank_35/Leftover_35_79A3_Unused_TCRF_FacePhoto1_KAO_1_Gfx_Part51FB.bin" ; $79A3, 1018 bytes
; I: leftover load-record header, 6 bytes: 01 04 F5 55 FA 03 = type 1, bank $04, load address $55F5, $03FA (1018) data
; bytes after it (they run past the end of the bank); a record of an older build's image as a download stream in the
; PC's memory, that nothing in this build reads
Leftover_35_7D9D_LoadRecord::
    db $01, $04, $f5, $55, $fa, $03

; I: leftover: an exact copy of 604 bytes of Unused_TCRF_FacePhoto1_KAO_1_Gfx (from 30:55F5, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_35_7DA3_Unused_TCRF_FacePhoto1_KAO_1_Gfx_Part55F5::
    INCBIN "data/bank_35/Leftover_35_7DA3_Unused_TCRF_FacePhoto1_KAO_1_Gfx_Part55F5.bin" ; $7DA3, 604 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_35_7FFF::
    db $35
