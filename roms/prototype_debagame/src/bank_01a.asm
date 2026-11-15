; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $1A. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $01a", ROMX[$4000], BANK[$1a]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_1A_4000::
    db $1a

; I: leftover text: 255 bytes of the developers' assembler source in clear (0 listing lines, 4 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_1A_4001_AsmSource::
    db "0,$00,$00,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00", $0d, $0a, $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00"

; I: leftover PC memory: 4 bytes (1A:4100-4103), the 512-byte blocks of a leftover run that hold the dword $C25D0000,
; a 4 KB-aligned address of the Windows 9x system arena ($C0000000 up), at offset $100 of the bank, as in the other
; banks that hold one; nothing in this build reads, runs or explains them; ...
Leftover_1A_4100_PcRam::
    db $00, $00, $5d, $c2

; I: leftover text: 252 bytes of the developers' assembler source in clear (0 listing lines, 3 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_1A_4104_AsmSource::
    db ",$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0"

; I: leftover: 12288 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs); no proof of PC memory in them
Leftover_1A_4200::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $f9, $7d, $09, $a0
    db $0c, $00, $59, $00, $3c, $00, $59

    ; padding
    ds $1e9, $00

    db $48, $80, $5f, $00, $8a, $0c, $00, $f0

    ; padding
    ds $bf9, $00

    db $10, $10, $00, $00, $00, $00, $00, $20, $00, $00, $00, $01, $00, $00, $a0, $1c
    db $00, $7d, $00, $74, $00, $7d, $00, $80, $00, $00, $00, $01, $00, $00, $a0, $2c
    db $00, $7d, $00, $0c, $00, $7d, $00, $00, $02, $00, $00, $01, $00, $00, $a0, $3c
    db $00, $7d, $00, $1c, $00, $7d, $00, $ff, $ff, $ff, $ff, $01, $00, $00, $a0, $0c
    db $08, $8d, $00, $2c, $00, $7d, $00, $00, $00, $59

    ; padding
    ds $25, $00

    db $41, $00, $48, $49, $91, $ff, $0f, $a0, $0c, $00, $7d, $00, $0c, $08, $8d

    ; padding
    ds $f81, $00

    db $74, $00, $7d, $00, $06, $00, $00, $a0, $04, $08, $00, $a0, $80, $5f, $01, $10
    db $a0, $5f, $01, $10, $c0, $5f, $01, $10, $e0, $5f, $01, $10, $00, $60, $01, $10
    db $20, $60, $01, $10, $40, $60, $01, $10, $60, $60, $01, $10, $80, $60, $01, $10
    db $a0, $60, $01, $10, $c0, $60, $01, $10, $e0, $60, $01, $10, $00, $61, $01, $10
    db $20, $61, $01, $10, $40, $61, $01, $10, $60, $61, $01, $10, $80, $61, $01, $10
    db $a0, $61, $01, $10, $c0, $61, $01, $10, $e0, $61, $01, $10

    ; padding
    ds $7b0, $00

    db $f1, $07, $00, $a0, $74, $00, $7d, $00, $3c, $00, $7d

    ; padding
    ds $7e1, $00

    db $0c, $08, $8d, $00, $02, $00, $00, $a0, $4a, $00, $8e, $00, $ae, $00, $00, $00
    db $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $03, $00, $00, $05, $00, $00, $00, $00, $02, $00, $02, $00, $01, $12

    ; padding
    ds $11, $00

    db $01, $01, $01, $02, $00, $02, $00, $02, $00, $02, $00, $02, $00, $01, $01, $01
    db $01, $02

    ; padding
    ds $af, $00

    db $ff, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $c1, $0a, $00, $00
    db $ff, $ff, $ff, $ff, $c1, $0a, $00, $00, $ff, $ff, $ff, $ff, $c1, $0a, $00, $00
    db $ff, $ff, $ff, $ff, $00, $0a, $00, $00, $ff, $ff, $ff, $ff, $00, $0a, $00, $00
    db $ff, $ff, $ff, $ff, $00, $0a, $00, $00, $ff, $ff, $ff, $ff, $00, $0a, $00, $00
    db $ff, $ff, $ff, $ff, $00, $0a, $00, $00, $ff, $ff, $ff, $ff, $00, $0a, $00, $00
    db $ff, $ff, $ff, $ff, $00, $0a, $00, $00, $ff, $ff, $ff, $ff, $00, $0a, $00, $00
    db $ff, $ff, $ff, $ff, $00, $0a, $00, $00, $ff, $ff, $ff, $ff, $00, $0a, $00, $00
    db $ff, $ff, $ff, $ff, $00, $0a, $00, $00, $ff, $ff, $ff, $ff, $00, $0a, $00, $00
    db $ff, $ff, $ff, $ff, $00, $0a, $00, $00, $ff, $ff, $ff, $ff, $00, $0a, $00, $00
    db $ff, $ff, $ff, $ff, $00, $0a, $00, $00, $ff, $ff, $ff, $ff, $00, $0a, $00, $00
    db $ff, $ff, $ff, $ff, $00, $0a, $00, $00, $ff, $ff, $ff, $ff, $00, $0a, $00, $00
    db $ff, $ff, $ff, $ff, $00, $0a, $00, $00, $ff, $ff, $ff, $ff, $00, $0a, $00, $00
    db $ff, $ff, $ff, $ff, $00, $0a, $00, $00, $ff, $ff, $ff, $ff, $00, $0a, $00, $00
    db $ff, $ff, $ff, $ff, $00, $0a, $00, $00, $ff, $ff, $ff, $ff, $00, $0a, $00, $00
    db $ff, $ff, $ff, $ff, $00, $0a, $00, $00, $ff, $ff, $ff, $ff, $00, $0a, $00, $00
    db $ff, $ff, $ff, $ff, $00, $0a, $00, $00, $ff, $ff, $ff, $ff, $00, $0a, $00, $00
    db $ff, $ff, $ff, $ff, $00, $0a, $00, $00

; I: leftover PC memory: 1024 bytes (1A:7200-75FF), the 512-byte blocks of a leftover run that hold 11 strings of the
; development PC's RAM (C:\Program Files\TAC95\TAC32.EXE / winbootdir=C:\WINDOWS / COMSPEC=C:\WINDOWS\COMMAND.COM
; ...); nothing in this build reads, runs or explains them; only those ...
Leftover_1A_7200_PcRam::
    INCBIN "data/bank_1a/Leftover_1A_7200_PcRam.bin" ; $7200, 1024 bytes
; I: leftover: 2559 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs); no proof of PC memory in them
Leftover_1A_7600::
    INCBIN "data/bank_1a/Leftover_1A_7600.bin" ; $7600, 2559 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_1A_7FFF::
    db $1a
