; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $32. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $032", ROMX[$4000], BANK[$32]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_32_4000::
    db $32

; I: leftover: an exact copy of 255 bytes of Unused_TCRF_FaceDrawing4_FACE8_Gfx (from 06:6F12, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_32_4001_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part6F12::
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $f0
    db $30, $e0, $20, $e0, $60, $c0, $40, $c0, $40, $c0, $40, $c0, $40, $c0, $c0, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0f
    db $08, $0f, $08, $0f, $08, $07, $04, $07, $04, $07, $06, $03, $02, $03, $02, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00

; I: leftover: 4 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_32_4100::
    db $00, $10, $dc, $c1

; I: leftover: an exact copy of 72 bytes of Unused_TCRF_FaceDrawing1_FACE5_Gfx (from 06:44EF, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_32_4104_Unused_TCRF_FaceDrawing1_FACE5_Gfx_Part44EF::
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $01, $ff, $01

; I: leftover: an exact copy of 180 bytes of Unused_TCRF_FaceDrawing4_FACE8_Gfx (from 06:705D, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_32_414C_Unused_TCRF_FaceDrawing4_FACE8_Gfx_Part705D::
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
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00

; I: leftover: an exact copy of 3073 bytes of Unused_TCRF_FaceDrawing1_FACE5_Gfx (from 06:4200, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_32_4200_Unused_TCRF_FaceDrawing1_FACE5_Gfx_Part4200::
    INCBIN "data/bank_32/Leftover_32_4200_Unused_TCRF_FaceDrawing1_FACE5_Gfx_Part4200.bin" ; $4200, 3073 bytes
; I: leftover: an exact copy of Unused_TCRF_FaceDrawing2_FACE6_Gfx (06:4E01, 3584 bytes) that nothing in this build
; reads, runs or explains (never read nor run in the L2 runs)
Leftover_32_4E01_Unused_TCRF_FaceDrawing2_FACE6_Gfx::
    INCBIN "data/bank_32/Leftover_32_4E01_Unused_TCRF_FaceDrawing2_FACE6_Gfx.2bpp" ; $4E01, 3584 bytes
; I: leftover: an exact copy of Unused_TCRF_FaceDrawing3_FACE7_Gfx (06:5C01, 3584 bytes) that nothing in this build
; reads, runs or explains (never read nor run in the L2 runs)
Leftover_32_5C01_Unused_TCRF_FaceDrawing3_FACE7_Gfx::
    INCBIN "data/bank_32/Leftover_32_5C01_Unused_TCRF_FaceDrawing3_FACE7_Gfx.2bpp" ; $5C01, 3584 bytes
; I: leftover: an exact copy of Unused_TCRF_FaceDrawing4_FACE8_Gfx (06:6A01, 3584 bytes) that nothing in this build
; reads, runs or explains (never read nor run in the L2 runs)
Leftover_32_6A01_Unused_TCRF_FaceDrawing4_FACE8_Gfx::
    INCBIN "data/bank_32/Leftover_32_6A01_Unused_TCRF_FaceDrawing4_FACE8_Gfx.2bpp" ; $6A01, 3584 bytes
; I: leftover: an exact copy of 243 bytes of Unused_TCRF_FacePhoto10_HOI_R_Gfx (from 05:7102, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_32_7801_Unused_TCRF_FacePhoto10_HOI_R_Gfx_Part7102::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7f
    db $ff, $1f, $7f, $3f, $7f, $1f, $3f, $1f, $3f, $1f, $1f, $3f, $1f, $17, $0f, $fe
    db $ff, $ff, $fc, $f8, $ff, $f6, $f9, $fc, $fb, $fb, $fd, $fc, $fb, $f2, $fd, $50
    db $af, $93, $7c, $09, $fe, $10, $ff, $88, $ff, $24, $df, $42, $bf, $25, $df, $0a
    db $ff, $aa, $55, $40, $bf, $aa, $55, $08, $ff, $2a, $d5, $14, $eb, $6f, $90, $f8
    db $ff, $51, $fe, $a8, $ff, $ae, $51, $01, $fe, $ab, $54, $45, $ba, $ff, $00, $77
    db $88, $97, $40, $7f, $80, $ff, $00, $5f, $a0, $fb, $04, $5d, $a2, $ff, $00, $ff
    db $00, $75, $00, $ea, $00, $75, $00, $ee, $00, $f5, $00, $ff, $00, $7f, $00, $55
    db $aa, $55, $00, $aa, $00, $51, $00, $ee, $00, $d5, $00, $ea, $00, $77, $00, $d7
    db $28, $45, $00, $aa, $00, $01, $00, $aa, $00, $44, $00, $ab, $00, $52, $01, $aa
    db $00, $00, $00, $28, $00, $10, $00, $ce, $20, $fc, $00, $7e, $80, $f5, $00, $88
    db $00, $00, $00, $00, $00, $00, $00, $80, $00, $10, $00, $a0, $00, $00, $00, $00
    db $00, $00, $00

; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_32_78F4::
    db $01, $05, $f5, $71, $fa, $03

; I: leftover: an exact copy of 262 bytes of Unused_TCRF_FacePhoto10_HOI_R_Gfx (from 05:71F5, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_32_78FA_Unused_TCRF_FacePhoto10_HOI_R_Gfx_Part71F5::
    INCBIN "data/bank_32/Leftover_32_78FA_Unused_TCRF_FacePhoto10_HOI_R_Gfx_Part71F5.bin" ; $78FA, 262 bytes
; I: leftover: 11 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_32_7A00::
    db $a0, $34, $c0, $98, $e0, $01, $04, $ef, $59, $12, $02

; I: leftover: an exact copy of 530 bytes of Unused_TCRF_FacePhoto1_Gfx (from 30:59EF, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_32_7A0B_Unused_TCRF_FacePhoto1_Gfx_Part59EF::
    INCBIN "data/bank_32/Leftover_32_7A0B_Unused_TCRF_FacePhoto1_Gfx_Part59EF.bin" ; $7A0B, 530 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_32_7C1D::
    db $01, $04, $01, $5c, $fa, $03

; I: leftover: an exact copy of 988 bytes of Unused_TCRF_FacePhoto2_Gfx (from 30:5C01, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_32_7C23_Unused_TCRF_FacePhoto2_Gfx_Part5C01::
    INCBIN "data/bank_32/Leftover_32_7C23_Unused_TCRF_FacePhoto2_Gfx_Part5C01.bin" ; $7C23, 988 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_32_7FFF::
    db $32
