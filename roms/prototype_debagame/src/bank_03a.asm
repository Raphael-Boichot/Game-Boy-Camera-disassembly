; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $3A. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $03a", ROMX[$4000], BANK[$3a]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_3A_4000::
    db $3a

; I: leftover: 511 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_3A_4001::
    INCBIN "data/bank_3a/Leftover_3A_4001.bin" ; $4001, 511 bytes
; I: leftover: an exact copy of 5633 bytes of Gfx_03_4001_FNTOOE3 (from 03:4200, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_3A_4200_Gfx_03_4001_FNTOOE3_Part4200::
    INCBIN "data/bank_3a/Leftover_3A_4200_Gfx_03_4001_FNTOOE3_Part4200.bin" ; $4200, 5633 bytes
; I: leftover: an exact copy of Map_03_5801_BG_MOVIE (03:5801, 576 bytes) that nothing in this build reads, runs or
; explains (never read nor run in the L2 runs)
Leftover_3A_5801_Map_03_5801_BG_MOVIE::
    INCBIN "data/bank_3a/Leftover_3A_5801_Map_03_5801_BG_MOVIE.bin" ; $5801, 576 bytes
; I: leftover: an exact copy of 3268 bytes of Gfx_03_5A41_CONF2 (from 03:5A41, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_3A_5A41_Gfx_03_5A41_CONF2_Part5A41::
    INCBIN "data/bank_3a/Leftover_3A_5A41_Gfx_03_5A41_CONF2_Part5A41.bin" ; $5A41, 3268 bytes
; I: leftover: 60 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_3A_6705::
    db $30, $31, $1f, $3f, $1c, $1e, $18, $18, $18, $19, $1f, $3f, $00, $00, $00, $20
    db $e0, $f0, $f1, $f9, $00, $00, $00, $00, $c1, $e3, $e1, $f1, $00, $00, $40, $40
    db $60, $68, $f9, $fb, $61, $f1, $60, $68, $fe, $fe, $ff, $ef, $00, $00, $00, $00
    db $30, $38, $f8, $fc, $80, $c0, $00, $0c, $3c, $7e, $f6, $fe

; I: leftover: an exact copy of 192 bytes of Gfx_03_5A41_CONF2 (from 03:6741, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_3A_6741_Gfx_03_5A41_CONF2_Part6741::
    db $30, $30, $23, $73, $61, $61, $61, $61, $21, $73, $33, $3b, $0e, $1f, $00, $00
    db $09, $19, $91, $99, $91, $b1, $bf, $bf, $21, $b1, $21, $61, $61, $61, $00, $00
    db $99, $99, $99, $99, $91, $99, $91, $b3, $b3, $b3, $b3, $b3, $b3, $b3, $00, $00
    db $a4, $b6, $94, $bc, $1c, $9c, $0c, $1c, $0c, $0c, $0c, $0c, $08, $0c, $00, $00
    db $1c, $3c, $3c, $3c, $4c, $6c, $8c, $cc, $0c, $8c, $0c, $1c, $04, $0c, $00, $00
    db $1b, $1f, $11, $1b, $20, $30, $40, $60, $00, $40, $00, $80, $00, $00, $00, $00
    db $e8, $ec, $d0, $d0, $c5, $c5, $c5, $c5, $48, $f8, $31, $71, $02, $02, $00, $00
    db $3e, $3e, $32, $37, $73, $73, $70, $70, $b0, $f0, $30, $b0, $00, $10, $00, $00
    db $30, $30, $20, $70, $60, $60, $60, $60, $20, $71, $33, $3b, $0c, $1e, $00, $00
    db $18, $18, $1f, $1f, $10, $18, $10, $b0, $b0, $b0, $30, $30, $30, $30, $00, $00
    db $46, $66, $c4, $ce, $cc, $cc, $cc, $cc, $c4, $ce, $c6, $c7, $81, $c3, $00, $00
    db $00, $00, $70, $70, $30, $30, $30, $30, $20, $70, $60, $60, $c0, $e0, $00, $00

; I: leftover: 60 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_3A_6801::
    db $30, $38, $34, $36, $32, $33, $21, $71, $63, $63, $44, $66, $88, $d8, $00, $00
    db $61, $71, $41, $e1, $81, $c1, $00, $80, $e1, $e1, $38, $7c, $08, $18, $00, $00
    db $eb, $fb, $f8, $78, $e1, $e1, $7b, $7f, $f3, $fb, $61, $61, $20, $20, $00, $00
    db $c0, $c0, $d0, $d8, $88, $8c, $bc, $be, $e4, $e6, $86, $c6

; I: leftover: an exact copy of 262 bytes of Gfx_01_4001_FNTOOE1 (from 01:47FD, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_3A_683D_Gfx_01_4001_FNTOOE1_Part47FD::
    INCBIN "data/bank_3a/Leftover_3A_683D_Gfx_01_4001_FNTOOE1_Part47FD.bin" ; $683D, 262 bytes
; I: leftover: an exact copy of 2302 bytes of Gfx_03_5A41_CONF2 (from 03:6943, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_3A_6943_Gfx_03_5A41_CONF2_Part6943::
    INCBIN "data/bank_3a/Leftover_3A_6943_Gfx_03_5A41_CONF2_Part6943.bin" ; $6943, 2302 bytes
; I: leftover: an exact copy of Map_03_7241_BG_CONF (03:7241, 576 bytes) that nothing in this build reads, runs or
; explains (never read nor run in the L2 runs)
Leftover_3A_7241_Map_03_7241_BG_CONF::
    INCBIN "data/bank_3a/Leftover_3A_7241_Map_03_7241_BG_CONF.bin" ; $7241, 576 bytes
; I: leftover: 1760 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_3A_7481::
    INCBIN "data/bank_3a/Leftover_3A_7481.bin" ; $7481, 2942 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_3A_7FFF::
    db $3a
