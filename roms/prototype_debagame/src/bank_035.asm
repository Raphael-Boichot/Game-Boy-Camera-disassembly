; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $35. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $035", ROMX[$4000], BANK[$35]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_35_4000::
    db $35

; I: leftover: an exact copy of 255 bytes of Unused_TCRF_FacePhoto8_HOI_D_Gfx (from 05:4F59, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_35_4001_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part4F59::
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $7f, $ff, $ff, $ff, $fd, $ff, $ff, $ff, $77, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fd, $ff, $ff, $ff, $f7, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $dd, $ff, $ff, $ff, $77, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $77, $ff, $c0, $80, $c0, $c0, $a0, $e0, $10, $f0
    db $f0, $f8, $dc, $f0, $fc, $f8, $54, $fc, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $0a, $07, $09, $07, $03, $0f, $15, $0f
    db $2f, $1f, $57, $3f, $7f, $3f, $1f, $7f, $ff, $ff, $ff, $ff, $bf, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $5f, $ff
    db $bf, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

; I: leftover: 4 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_35_4100::
    db $00, $e0, $16, $c2

; I: leftover: an exact copy of 252 bytes of Unused_TCRF_FacePhoto8_HOI_D_Gfx (from 05:505C, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_35_4104_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part505C::
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $f7, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $77, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $77, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f7, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $7f, $ff, $f8, $fe, $ff, $fc, $ff, $fe, $74, $ff, $fe, $ff, $fd
    db $ff, $fe, $ff, $77, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
    db $00, $00, $80, $00, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01
    db $00, $01, $00, $00, $01, $bf, $7f, $17, $7f, $bf, $7f, $1f, $7f, $7f, $ff, $5f
    db $ff, $ff, $ff, $5f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

; I: leftover: an exact copy of 273 bytes of Unused_TCRF_FaceDrawing4_FACE8_Gfx (from 06:70E4, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_35_4200_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part70E4::
    INCBIN "data/bank_35/Leftover_35_4200_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part70E4.bin" ; $4200, 273 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_35_4311::
    db $01, $06, $f5, $71, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FaceDrawing4_FACE8_Gfx (from 06:71F5, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_35_4317_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part71F5::
    INCBIN "data/bank_35/Leftover_35_4317_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part71F5.bin" ; $4317, 1018 bytes
; I: leftover: 5 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_35_4711::
    db $01, $06, $ef, $75, $12

; I: leftover: an exact copy of 132 bytes of Unused_TCRF_FaceDrawing4_FACE8_Gfx (from 06:6FD0, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_35_4716_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part6FD0::
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
Leftover_35_479A_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part7672::
    INCBIN "data/bank_35/Leftover_35_479A_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part7672.bin" ; $479A, 399 bytes
; I: leftover: 360 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_35_4929::
    INCBIN "data/bank_35/Leftover_35_4929.bin" ; $4929, 360 bytes
; C: binary symbol table of an older build, 705 records (tools/proto_symtab.py)
OldSymbolTable_35_4A91::
    INCBIN "data/bank_35/OldSymbolTable_35_4A91.bin" ; $4A91, 8843 bytes
; I: leftover: 2276 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_35_6D1C::
    INCBIN "data/bank_35/Leftover_35_6D1C.bin" ; $6D1C, 2276 bytes
; I: leftover: an exact copy of 925 bytes of Unused_TCRF_FacePhoto1_Gfx (from 30:4E5E, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_35_7600_Unused_TCRF_FacePhoto1_Gfx_Part4E5E::
    INCBIN "data/bank_35/Leftover_35_7600_Unused_TCRF_FacePhoto1_Gfx_Part4E5E.bin" ; $7600, 925 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_35_799D::
    db $01, $04, $fb, $51, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto1_Gfx (from 30:51FB, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_35_79A3_Unused_TCRF_FacePhoto1_Gfx_Part51FB::
    INCBIN "data/bank_35/Leftover_35_79A3_Unused_TCRF_FacePhoto1_Gfx_Part51FB.bin" ; $79A3, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_35_7D9D::
    db $01, $04, $f5, $55, $fa, $03

; I: leftover: an exact copy of 604 bytes of Unused_TCRF_FacePhoto1_Gfx (from 30:55F5, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_35_7DA3_Unused_TCRF_FacePhoto1_Gfx_Part55F5::
    INCBIN "data/bank_35/Leftover_35_7DA3_Unused_TCRF_FacePhoto1_Gfx_Part55F5.bin" ; $7DA3, 604 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_35_7FFF::
    db $35
