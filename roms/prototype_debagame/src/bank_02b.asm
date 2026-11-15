; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $2B. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $02b", ROMX[$4000], BANK[$2b]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_2B_4000::
    db $2b

; I: leftover text: 255 bytes of the developers' assembler source in clear (0 listing lines, 6 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_2B_4001_AsmSource::
    db "0,$00,$00,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00", $09, ";0031", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00", $09, ";0032", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00", $09, ";0033", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$"

; I: leftover PC memory: 4 bytes (2B:4100-4103), the 512-byte blocks of a leftover run that hold the dword $C25CD000,
; a 4 KB-aligned address of the Windows 9x system arena ($C0000000 up), at offset $100 of the bank, as in the other
; banks that hold one; nothing in this build reads, runs or explains them; ...
Leftover_2B_4100_PcRam::
    db $00, $d0, $5c, $c2

; I: leftover text: 252 bytes of the developers' assembler source in clear (0 listing lines, 6 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_2B_4104_AsmSource::
    db "00,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00", $09, ";0034", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00", $09, ";0035", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00", $09, ";0036", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$"

; I: leftover PC memory: 512 bytes (2B:4200-43FF), the 512-byte blocks of a leftover run that hold 2 strings of the
; development PC's RAM (WINDOWS VMM 4.0 / PIFMGR.DLL ...); nothing in this build reads, runs or explains them; only
; those proofs are proven, the rest of each block is taken as the same memory
Leftover_2B_4200_PcRam::
    db $00, $00, $00, $00, $00, $57, $49, $4e, $44, $4f, $57, $53, $20, $56, $4d, $4d
    db $20, $34, $2e, $30, $00, $ff, $ff, $1b, $02, $ac, $01

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
    ds $23, $00

    db $43, $00, $00, $43, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $43
    db $00, $43, $00, $00, $00, $43, $00

; I: leftover: 15359 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs); no proof of PC memory in them
Leftover_2B_4400::
    INCBIN "data/bank_2b/Leftover_2B_4400.bin" ; $4400, 15359 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_2B_7FFF::
    db $2b
