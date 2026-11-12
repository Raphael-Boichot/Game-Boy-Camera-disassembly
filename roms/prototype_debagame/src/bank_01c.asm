; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $1C. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $01c", ROMX[$4000], BANK[$1c]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_1C_4000::
    db $1c

; I: leftover: 32 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_1C_4001::
    INCBIN "data/bank_1c/Leftover_1C_4001.bin" ; $4001, 509 bytes
; I: leftover: an exact copy of 88 bytes of Unused_TCRF_FacePhoto9_HOI_L_Gfx (from 05:61DF, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_1C_41FE_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part61DF::
    db $c0, $e0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $daa, $00

; I: leftover: 5 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_1C_5000::
    db $08, $60, $8e, $00, $f0

    ; padding
    ds $f3, $00

    db $ff

    ; padding
    ds $f07, $00

    db $08, $70, $8e, $00, $f0

    ; padding
    ds $f3, $00

    db $ff

    ; padding
    ds $f07, $00

    db $08, $80, $8e, $00, $f0

    ; padding
    ds $f3, $00

    db $ff

    ; padding
    ds $f06, $00

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_1C_7FFF::
    db $1c
