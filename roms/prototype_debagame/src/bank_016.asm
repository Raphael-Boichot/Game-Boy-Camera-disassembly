; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $16. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $016", ROMX[$4000], BANK[$16]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_16_4000::
    db $16

; I: leftover text: 255 bytes of the developers' assembler source in clear (0 listing lines, 4 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_16_4001_AsmSource::
    db "0,$00,$00,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00", $0d, $0a, $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00"

; I: leftover PC memory: 4 bytes (16:4100-4103), the 512-byte blocks of a leftover run that hold the dword $C264A000,
; a 4 KB-aligned address of the Windows 9x system arena ($C0000000 up), at offset $100 of the bank, as in the other
; banks that hold one; nothing in this build reads, runs or explains them; ...
Leftover_16_4100_PcRam::
    db $00, $a0, $64, $c2

; I: leftover text: 251 bytes of the developers' assembler source in clear (0 listing lines, 3 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_16_4104_AsmSource::
    db ",$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$"

; I: leftover: 15872 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_16_41FF::
    INCBIN "data/bank_16/Leftover_16_41FF.bin" ; $41FF, 15872 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_16_7FFF::
    db $16
