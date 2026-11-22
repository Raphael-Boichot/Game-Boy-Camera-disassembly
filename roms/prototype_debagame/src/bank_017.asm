; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $17. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $017", ROMX[$4000], BANK[$17]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_17_4000::
    db $17

; I: leftover text: 255 bytes of the developers' assembler source in clear (0 listing lines, 4 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_17_4001_AsmSource::
    db "9C,$2E,$D0,$0F,$EA,$07,$64,$03", $0d, $0a, $09, "DEFB", $09, "$C0,$80,$80,$40,$40,$00,$60,$00,$C0,$20,$80,$70,$28,$F0,$14,$F8", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,"

; I: leftover PC memory: 4 bytes (17:4100-4103), the 512-byte blocks of a leftover run that hold the dword $C2171000,
; a 4 KB-aligned address of the Windows 9x system arena ($C0000000 up), at offset $100 of the bank, as in the other
; banks that hold one; nothing in this build reads, runs or explains them; ...
Leftover_17_4100_PcRam::
    db $00, $10, $17, $c2

; I: leftover text: 252 bytes of the developers' assembler source in clear (0 listing lines, 3 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_17_4104_AsmSource::
    db "$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00", $0d, $0a, $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$"

; I: leftover: 15871 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_17_4200::
    INCBIN "data/bank_17/Leftover_17_4200.bin" ; $4200, 15871 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_17_7FFF::
    db $17
