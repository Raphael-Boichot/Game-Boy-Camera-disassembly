; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $19. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $019", ROMX[$4000], BANK[$19]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_19_4000::
    db $19

; I: leftover: 259 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_19_4001::
    INCBIN "data/bank_19/Leftover_19_4001.bin" ; $4001, 259 bytes
; I: leftover: an exact copy of 252 bytes of Unused_TCRF_FaceDrawing2_FACE6_Gfx (from 06:5104, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_19_4104_Unused_TCRF_FaceDrawing2_FACE6_Gfx_Part5104::
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $03, $ff, $07, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $03, $fe, $3e, $e8, $e8, $e7, $e7, $ff, $00, $ff
    db $00, $ff, $00, $ff, $01, $ff, $ff, $00, $00, $07, $07, $ff, $ff, $ff, $00, $ff
    db $60, $df, $d0, $8f, $8c, $ff, $ff, $00, $00, $fe, $fe, $ff, $ff, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $c0, $ff, $f8, $1f, $1c, $cf, $c7, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff

; I: leftover: 15871 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_19_4200::
    INCBIN "data/bank_19/Leftover_19_4200.bin" ; $4200, 15871 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_19_7FFF::
    db $19
