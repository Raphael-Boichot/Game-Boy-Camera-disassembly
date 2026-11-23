; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $0C. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $00c", ROMX[$4000], BANK[$c]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_0C_4000::
    db $0c

; I: leftover text: 255 bytes of the developers' assembler source in clear (0 listing lines, 19 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_0C_4001_AsmSource::
    db $09, ";43", $0d, $0a, $09, "LD", $09, "(BC),A", $0d, $0a, $09, "INC", $09, "C", $0d, $0a, $0d, $0a, $09, "LD", $09, "A,(HLI)", $09, $09, ";44", $0d, $0a, $09, "LD", $09, "(BC),A", $0d, $0a, $09, "INC", $09, "C", $0d, $0a, $09, $0d, $0a, $09, "LD", $09, "A,(HLI)", $09, $09, ";45", $0d, $0a, $09, "LD", $09, "(BC),A", $0d, $0a, $09, "INC", $09, "C", $0d, $0a, $09, $0d, $0a, $09, "LD", $09, "A,(HLI)", $09, $09, ";46", $0d, $0a, $09, "LD", $09, "(BC),A", $0d, $0a, $09, "INC", $09, "C", $0d, $0a, $09, $0d, $0a, $09, "LD", $09, "A,(HLI)", $09, $09, ";47", $0d, $0a, $09, "LD", $09, "(BC),A", $0d, $0a, $09, "INC", $09, "C", $0d, $0a, $0d, $0a, $09, "LD", $09, "A,(HLI)", $09, $09, ";48", $0d, $0a, $09, "LD", $09, "(BC),A", $0d, $0a, $09, "INC", $09, "C", $0d, $0a, $09, $0d, $0a, $09, "LD", $09, "A,(HLI)", $09, $09, ";49", $0d, $0a, $09, "LD", $09, "("

; I: leftover PC memory: 4 bytes (0C:4100-4103), the 512-byte blocks of a leftover run that hold the dword $C25E2000,
; a 4 KB-aligned address of the Windows 9x system arena ($C0000000 up), at offset $100 of the bank, as in the other
; banks that hold one; nothing in this build reads, runs or explains them; ...
Leftover_0C_4100_PcRam::
    db $00, $20, $5e, $c2

; I: leftover text: 252 bytes of the developers' assembler source in clear (0 listing lines, 19 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_0C_4104_AsmSource::
    db "A", $0d, $0a, $09, "INC", $09, "C", $0d, $0a, $09, $0d, $0a, $09, "LD", $09, "A,(HLI)", $09, $09, ";4A", $0d, $0a, $09, "LD", $09, "(BC),A", $0d, $0a, $09, "INC", $09, "C", $0d, $0a, $0d, $0a, $09, "LD", $09, "A,(HLI)", $09, $09, ";4B", $0d, $0a, $09, "LD", $09, "(BC),A", $0d, $0a, $09, "INC", $09, "C", $0d, $0a, $0d, $0a, $09, "LD", $09, "A,(HLI)", $09, $09, ";4C", $0d, $0a, $09, "LD", $09, "(BC),A", $0d, $0a, $09, "INC", $09, "C", $0d, $0a, $09, $0d, $0a, $09, "LD", $09, "A,(HLI)", $09, $09, ";4D", $0d, $0a, $09, "LD", $09, "(BC),A", $0d, $0a, $09, "INC", $09, "C", $0d, $0a, $09, $0d, $0a, $09, "LD", $09, "A,(HLI)", $09, $09, ";4E", $0d, $0a, $09, "LD", $09, "(BC),A", $0d, $0a, $09, "INC", $09, "C", $0d, $0a, $09, $0d, $0a, $09, "LD", $09, "A,(HLI)", $09, $09, ";4F", $0d, $0a, $09, "LD", $09, "(BC),A", $0d, $0a, $09, "INC", $09

; I: 15871 bytes: structured array of unknown kind (owner, 2026-11-23: set aside as typed data of unknown kind): part
; of the first of the two arrays of 381 columns laid through the image before the bank heads (banks $08-$10, one value
; a byte, mostly $00 / $01 / $03 / $80 / $81; tools/proto_grids.py, ...
Leftover_0C_4200_Grid381Binary::
    INCBIN "data/bank_0c/Leftover_0C_4200_Grid381Binary.bin" ; $4200, 15871 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_0C_7FFF::
    db $0c
