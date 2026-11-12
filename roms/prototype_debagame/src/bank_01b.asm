; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $1B. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $01b", ROMX[$4000], BANK[$1b]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_1B_4000::
    db $1b

; I: leftover text: 255 bytes of the developers' assembler source in clear (0 listing lines, 4 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_1B_4001_AsmSource::
    db "FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF", $0d, $0a, $09, "DEFB", $09, "$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF", $0d, $0a, $09, "DEFB", $09, "$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF", $0d, $0a, $09, "DEFB", $09, "$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF", $0d, $0a, $09, "DEFB", $09, "$80,"

; I: leftover: 4 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_1B_4100::
    db $00, $00, $1d, $c2

; I: leftover text: 252 bytes of the developers' assembler source in clear (0 listing lines, 3 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_1B_4104_AsmSource::
    db "$C0,$C0,$E0,$C0,$E0,$C0,$E0,$C0,$E0,$C0,$80,$E0,$E0,$C0", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00", $0d, $0a, $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$"

    ; padding
    ds $e00, $00

; I: leftover: 5 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_1B_5000::
    db $08, $20, $8e, $00, $f0

    ; padding
    ds $f3, $00

    db $ff

    ; padding
    ds $f07, $00

    db $08, $30, $8e, $00, $f0

    ; padding
    ds $f3, $00

    db $ff

    ; padding
    ds $f07, $00

    db $08, $40, $8e, $00, $f0

    ; padding
    ds $f3, $00

    db $ff

    ; padding
    ds $f06, $00

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_1B_7FFF::
    db $1b
