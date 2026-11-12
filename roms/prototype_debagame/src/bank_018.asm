; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $18. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $018", ROMX[$4000], BANK[$18]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_18_4000::
    db $18

; I: leftover: an exact copy of 92 bytes of Unused_TCRF_FaceDrawing1_FACE5_Gfx (from 06:44DB, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_18_4001_Unused_TCRF_FaceDrawing1_FACE5_Gfx_Part44DB::
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $01, $ff, $01

; I: leftover: an exact copy of 164 bytes of Unused_TCRF_FaceDrawing4_FACE8_Gfx (from 06:705D, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_18_405D_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part705D::
    db $ff, $03, $ff, $03, $c0, $c0, $83, $83, $86, $86, $88, $88, $88, $88, $08, $08
    db $04, $04, $07, $07, $00, $00, $ff, $ff, $7c, $7c, $fe, $fe, $fe, $fe, $fe, $fe
    db $fc, $fc, $00, $00, $00, $00, $c0, $c0, $30, $30, $10, $10, $08, $08, $08, $08
    db $08, $08, $f8, $f8, $00, $00, $00, $00, $01, $01, $03, $03, $02, $02, $01, $01
    db $00, $00, $00, $00, $00, $00, $1f, $1f, $f3, $f3, $07, $07, $07, $07, $07, $07
    db $e7, $e7, $1d, $1d, $00, $00, $f0, $f0, $fc, $fc, $f2, $f2, $f9, $f9, $f9, $f9
    db $f1, $f1, $f7, $f7, $03, $02, $03, $02, $03, $02, $03, $02, $03, $02, $03, $02
    db $03, $02, $03, $02, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00

; I: leftover: 3 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_18_4101::
    db $20, $1a, $c2

; I: leftover: an exact copy of 252 bytes of Unused_TCRF_FaceDrawing4_FACE8_Gfx (from 06:7104, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_18_4104_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part7104::
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $02, $fe
    db $02, $fe, $02, $fe, $02, $fe, $06, $fc, $04, $fc, $04, $fc, $04, $01, $01, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $00
    db $00, $00, $00, $00, $00, $00, $00, $04, $04, $0c, $0c, $08, $08, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $f8, $f8, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $02, $03
    db $02, $03, $02, $03, $02, $03, $02, $03, $02, $03, $02, $03, $02, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff

; I: leftover: 15871 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_18_4200::
    INCBIN "data/bank_18/Leftover_18_4200.bin" ; $4200, 15871 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_18_7FFF::
    db $18
