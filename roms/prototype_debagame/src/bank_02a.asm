; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $2A. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $02a", ROMX[$4000], BANK[$2a]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_2A_4000::
    db $2a

; I: leftover text: 255 bytes of the developers' assembler source in clear (0 listing lines, 6 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_2A_4001_AsmSource::
    db ",$00,$FF,$00", $09, ";0092", $0d, $0a, $09, "DEFB", $09, "$FF,$00,$FF,$38,$EF,$28,$FF,$38", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$10,$18,$00,$00", $09, ";0093", $0d, $0a, $09, "DEFB", $09, "$00,$00,$10,$18,$00,$00,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$10,$18,$00,$00", $09, ";0094", $0d, $0a, $09, "DEFB", $09, "$00,$00,$10,$18,$20,$30,$00,$00", $0d, $0a, $09, "DEFB", $09, "$00,$00,$08,$0C,$10,$1"

; I: leftover: 4 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_2A_4100::
    db $00, $30, $5d, $c2

; I: leftover text: 252 bytes of the developers' assembler source in clear (0 listing lines, 6 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_2A_4104_AsmSource::
    db "0,$30", $09, ";0095", $0d, $0a, $09, "DEFB", $09, "$20,$30,$20,$30,$10,$18,$08,$0C", $0d, $0a, $09, "DEFB", $09, "$00,$00,$20,$30,$10,$18,$08,$0C", $09, ";0096", $0d, $0a, $09, "DEFB", $09, "$08,$0C,$08,$0C,$10,$18,$20,$30", $0d, $0a, $09, "DEFB", $09, "$00,$00,$08,$0C,$10,$18,$20,$30", $09, ";0097", $0d, $0a, $09, "DEFB", $09, "$40,$60,$20,$30,$10,$18,$08,$0C", $0d, $0a, $09, "DEFB", $09, "$00,$00,$20,$30,$10,$18,$0"

; I: leftover: an exact copy of 103 bytes of Unused_TCRF_FaceDrawing1_FACE5_Gfx (from 06:44D0, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_2A_4200_Unused_TCRF_FaceDrawing1_FACE5_Gfx_Part44D0::
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $01, $ff, $01

; I: leftover: an exact copy of 408 bytes of Unused_TCRF_FaceDrawing4_FACE8_Gfx (from 06:705D, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_2A_4267_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part705D::
    INCBIN "data/bank_2a/Leftover_2A_4267_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part705D.bin" ; $4267, 408 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_2A_43FF::
    db $01, $06, $f5, $71, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FaceDrawing4_FACE8_Gfx (from 06:71F5, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_2A_4405_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part71F5::
    INCBIN "data/bank_2a/Leftover_2A_4405_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part71F5.bin" ; $4405, 1018 bytes
; I: leftover: 5 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_2A_47FF::
    db $01, $06, $ef, $75, $12

; I: leftover: an exact copy of 132 bytes of Unused_TCRF_FaceDrawing4_FACE8_Gfx (from 06:6FD0, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_2A_4804_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part6FD0::
    db $02, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff

; I: leftover: an exact copy of 399 bytes of Unused_TCRF_FaceDrawing4_FACE8_Gfx (from 06:7672, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_2A_4888_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part7672::
    INCBIN "data/bank_2a/Leftover_2A_4888_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part7672.bin" ; $4888, 399 bytes
; I: leftover: 360 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_2A_4A17::
    INCBIN "data/bank_2a/Leftover_2A_4A17.bin" ; $4A17, 360 bytes
; C: binary symbol table of an older build, 674 records (tools/proto_symtab.py)
OldSymbolTable_2A_4B7F::
    INCBIN "data/bank_2a/OldSymbolTable_2A_4B7F.bin" ; $4B7F, 8522 bytes
; I: leftover: 2359 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_2A_6CC9::
    INCBIN "data/bank_2a/Leftover_2A_6CC9.bin" ; $6CC9, 4918 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_2A_7FFF::
    db $2a
