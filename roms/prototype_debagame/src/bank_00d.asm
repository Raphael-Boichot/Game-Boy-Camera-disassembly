; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $0D. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $00d", ROMX[$4000], BANK[$d]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_0D_4000::
    db $0d

; I: leftover text: 255 bytes of the developers' assembler source in clear (0 listing lines, 14 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_0D_4001_AsmSource::
    db ";", $09, "LD", $09, "($2000),A", $0d, $0a, ";", $09, "LD", $09, "HL,FACE3", $09, ";1", $96, $87, $96, $da, $82, $cc, $8a, "G", $82, $f0, $83, "o", $83, "b", $83, "t", $83, "@", $82, $c9, $0d, $0a, $0d, $0a, $09, "ld", $09, "a,$4", $0d, $0a, $09, "ld", $09, "($2000),a", $0d, $0a, $09, "ld", $09, "hl,kao_2", $0d, $0a, $0d, $0a, $09, "LD", $09, "A,03", $0d, $0a, $09, "LD", $09, "(PICTURE_F),A", $0d, $0a, $09, "JR", $09, "NC_PICT", $0d, $0a, $0d, $0a, "PICT3", $0d, $0a, ";", $09, "LD", $09, "A,$05", $0d, $0a, ";", $09, "LD", $09, "($2000),A", $0d, $0a, ";", $09, "LD", $09, "HL,FACE4", $09, ";2", $96, $87, $96, $da, $82, $cc, $8a, "G", $82, $f0, $83, "o", $83, "b", $83, "t", $83, "@", $82, $c9, $0d, $0a, $0d, $0a, $09, "ld", $09, "a,$04", $0d, $0a, $09, "ld", $09, "($2000),a", $0d, $0a, $09, "ld", $09, "hl,kao_3", $0d

; I: leftover PC memory: 4 bytes (0D:4100-4103), a leftover run that holds the dword $C2610000, a 4 KB-aligned address
; of the Windows 9x system arena ($C0000000 up), at offset $100 of the bank, as in the other banks that hold one;
; nothing in this build reads, runs or explains it; only those proofs are ...
Leftover_0D_4100_PcRam::
    db $00, $00, $61, $c2

; I: leftover text: 252 bytes of the developers' assembler source in clear (0 listing lines, 15 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_0D_4104_AsmSource::
    db $09, "LD", $09, "A,04", $0d, $0a, $09, "LD", $09, "(PICTURE_F),A", $0d, $0a, $09, "JR", $09, "NC_PICT", $0d, $0a, $0d, $0a, "PICT4", $0d, $0a, ";", $09, "LD", $09, "A,$06", $0d, $0a, ";", $09, "LD", $09, "($2000),A", $0d, $0a, ";", $09, "LD", $09, "HL,FACE5", $09, ";1", $96, $87, $96, $da, $82, $cc, $8a, "G", $82, $f0, $83, "o", $83, "b", $83, "t", $83, "@", $82, $c9, $0d, $0a, $0d, $0a, $09, "ld", $09, "a,$4", $0d, $0a, $09, "ld", $09, "($2000),a", $0d, $0a, $09, "ld", $09, "hl,kao_2", $0d, $0a, $09, $0d, $0a, $09, "LD", $09, "A,05", $0d, $0a, $09, "LD", $09, "(PICTURE_F),A", $0d, $0a, $09, "JR", $09, "NC_PICT", $0d, $0a, $0d, $0a, "PICT5", $0d, $0a, ";", $09, "LD", $09, "A,$06", $0d, $0a, ";", $09, "LD", $09, "($2000),A", $0d, $0a, ";", $09, "LD", $09, "HL,FACE"

; I: 15871 bytes: structured array of unknown kind (owner, 2026-11-23: set aside as typed data of unknown kind): part
; of the first of the two arrays of 381 columns laid through the image before the bank heads (banks $08-$10, one value
; a byte, mostly $00 / $01 / $03 / $80 / $81; tools/proto_grids.py, ...
Leftover_0D_4200_Grid381Binary::
    INCBIN "data/bank_0d/Leftover_0D_4200_Grid381Binary.bin" ; $4200, 15871 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_0D_7FFF::
    db $0d
