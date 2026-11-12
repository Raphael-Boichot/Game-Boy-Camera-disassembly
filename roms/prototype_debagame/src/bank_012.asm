; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $12. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $012", ROMX[$4000], BANK[$12]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_12_4000::
    db $12

; I: leftover text: 255 bytes of the developers' assembler source in clear (3 listing lines, 4 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_12_4001_AsmSource::
    db ": BufPointer", $09, $09, "ds", $09, "2", $09, ";", $91, $97, $90, "M", $83, "o", $83, "b", $83, "t", $83, "@", $83, "|", $83, "C", $83, $93, $83, "^", $0d, $0a, "siowork.dmg(51) : BufPointer_base", $09, $09, "ds", $09, "2", $09, ";", $91, $97, $90, "M", $83, "o", $83, "b", $83, "t", $83, "@", $83, "A", $83, "h", $83, $8c, $83, "X", $0d, $0a, "siowork.dmg(52) : BufPointer_base1", $09, "ds", $09, "2", $09, ";", $91, $97, $90, "M", $83, "o", $83, "b", $83, "t", $83, "@", $83, "A", $83, "h", $83, $8c, $83, "X", $91, $d2, $94, $f0, $82, "P", $0d, $0a, "siowork.dmg(53) : BufPointer_base2", $09, "ds", $09, "2", $09, ";", $91, $97, $90, "M", $83, "o", $83, "b", $83, "t", $83, "@", $83, "A", $83, "h", $83, $8c, $83, "X", $91, $d2, $94, $f0, $82, "Q", $0d, $0a, "siowork.dmg("

; I: leftover: 4 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_12_4100::
    db $00, $40, $60, $c2

; I: leftover text: 496 bytes of the developers' assembler source in clear (4 listing lines, 4 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_12_4104_AsmSource::
    db ": PrnDataAddress", $09, $09, "ds", $09, "2", $09, ";------", $82, "m", $82, $8f, $82, $94, $82, "t", $82, $93, $82, $85, $82, $84, $0d, $0a, "siowork.dmg(55) : SioCheckSum_S", $09, $09, "ds", $09, "2", $09, ";", $91, $97, $90, "M", $83, "`", $83, "F", $83, "b", $83, "N", $83, "T", $83, $80, $0d, $0a, "siowork.dmg(56) : EndofTrans", $09, $09, "ds", $09, "1", $09, ";", $82, "P", $83, "p", $83, "P", $83, "b", $83, "g", $91, $97, $90, "M", $8f, "I", $97, $b9, $81, "A", $82, "Q", $81, $81, $8a, $ae, $91, "S", $0d, $0a, "siowork.dmg(57) : DummySendF", $09, $09, "ds", $09, "1", $09, ";", $83, "_", $83, "~", $81, "[", $83, "o", $83, "C", $83, "g", $91, $97, $90, "M", $8d, $cf, $82, $dd, $0d, $0a, "siowork.dmg(58) : Printer0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"

; I: leftover: 15627 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_12_42F4::
    INCBIN "data/bank_12/Leftover_12_42F4.bin" ; $42F4, 15627 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_12_7FFF::
    db $12
