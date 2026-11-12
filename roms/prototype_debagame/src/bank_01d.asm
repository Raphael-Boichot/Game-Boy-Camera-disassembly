; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $1D. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $01d", ROMX[$4000], BANK[$1d]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_1D_4000::
    db $1d

    ; padding
    ds $20, $00

; I: leftover: 35 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_1D_4021::
    db $08, $07, $0b, $05, $03, $0f, $19, $07, $27, $1f, $77, $1f, $4f, $3f, $1f, $7f
    db $ff, $ff, $fd, $ff, $bf, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $df

; I: leftover: an exact copy of 55 bytes of Unused_TCRF_FacePhoto8_HOI_D_Gfx (from 05:5044, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_1D_4044_Unused_TCRF_FacePhoto8_HOI_D_Gfx_Part5044::
    db $ff, $ff, $ff, $5f, $ff, $bf, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff

; I: leftover: 1 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_1D_407B::
    db $fd, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $f7, $ff, $ff, $ff, $dd, $ff, $ff, $ff, $77, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $77, $ff, $ff, $ff, $fd, $ff, $ff, $ff, $f7, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $7f, $ff, $f8, $fe, $c7, $fc, $ff, $fe, $74, $ff, $fe, $ff
    db $d4, $ff, $fe, $ff, $77, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $80, $00, $80, $00, $00, $80, $0f, $0f, $07, $07, $00, $00, $00, $00, $00, $00
    db $01, $01, $01, $01, $01, $01, $fc, $fc, $f8, $f8, $00, $00, $07, $07, $0f, $0f
    db $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $e0, $e0
    db $f0, $f0, $f8, $f8, $78, $00, $90, $da, $c1

    ; padding
    ds $17, $00

    db $01, $00, $01, $00, $00, $01, $9f, $7f, $37, $5f, $8f, $7f, $1f, $7f, $3f, $ff
    db $5f, $ff, $ff, $ff, $df, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $fe, $ff, $dd, $ff, $ff, $ff, $f7, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $80, $80, $00, $c0, $c0, $80, $20, $c0, $80, $e0
    db $50, $e0, $f0, $e0, $40, $f0, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $f7, $f7, $c7, $c7, $cf, $cf, $0f, $0f
    db $1f, $1f, $1e, $1e, $1c, $1c, $38, $38, $38, $38, $78, $78, $f8, $f8, $f8, $f8
    db $f0, $f0, $00, $00, $00, $3d, $18, $f9, $11, $06, $98, $01, $03, $00, $cd, $bf
    db $02, $11, $26, $98, $01, $03, $00, $cd, $bf, $02, $c9, $29, $2a, $2b, $39, $3a
    db $3b, $81, $60, $60, $91, $60, $60, $82, $60, $60, $92, $60, $60, $83, $60, $60
    db $93, $60, $60, $84, $60, $60, $94, $60, $60, $85, $60, $60, $95, $60, $60, $86
    db $60, $60, $96, $60, $60, $87, $60, $60, $97, $60, $60, $88, $60, $60, $98, $60
    db $60, $89, $60, $60, $99, $60, $60, $81, $80, $60, $91, $90, $60, $81, $81, $60
    db $91, $91, $60, $2e, $2f, $46, $47, $48, $49, $60, $60, $60, $60, $60, $60, $3e
    db $3f, $56, $57, $58, $59, $60, $60, $60, $60, $60, $60, $0a, $0b, $20, $21, $22
    db $23, $24, $25, $26, $60, $60, $60, $1a, $1b, $30, $31, $32, $33, $34, $35, $36
    db $60, $60, $60, $0c, $0d, $20, $21, $22, $23, $24, $25, $26, $60, $60, $60, $1c
    db $1d, $30, $31, $32, $33, $34, $35, $36, $60, $60, $60, $00, $01, $02, $03, $04
    db $20, $21, $22, $23, $24, $25, $26, $10, $11, $12, $13, $14, $30, $31, $32, $33
    db $34, $35, $36, $0a, $0b, $20, $21, $22, $60, $60, $60, $60, $60, $60, $60, $1a
    db $1b, $30, $31, $32, $60, $60, $60, $60, $60, $60, $60, $0c, $0d, $20, $21, $22
    db $60, $60, $60, $60, $60, $60, $60, $1c, $1d, $30, $31, $32, $60, $60, $60, $60
    db $60, $60, $60, $00, $01, $02, $03, $04, $20, $21, $22, $60, $60, $60, $60, $10
    db $11, $12, $13, $14, $30, $31, $32, $60, $60, $60, $60, $85, $80, $44, $60, $95
    db $90, $54, $60, $87, $85, $44, $60, $97, $95, $54, $60, $81, $80, $80, $44, $91
    db $90, $90, $54, $81, $82, $85, $44, $91, $92, $95, $54, $82, $80, $80, $44, $92
    db $90, $90, $54, $83, $80, $80, $44, $93, $90, $90, $54, $84, $80, $80, $44, $94
    db $90, $90, $54, $85, $80, $80, $44, $95, $90, $90, $54, $80, $42, $80, $43, $90
    db $52, $90, $53, $80, $42, $85, $43, $90, $52, $95, $53, $81, $42, $80, $43, $91
    db $52, $90, $53, $81, $42, $85, $43, $91, $52, $95, $53, $82, $42, $80, $43, $92
    db $52, $90, $53, $82, $42, $85, $43, $92, $52, $95, $53, $83, $42, $80, $43, $93
    db $52, $90, $53, $83, $42, $85, $43, $93, $52, $95, $53, $4a, $4b, $4c, $4d, $60
    db $60, $60, $60, $60, $60, $60, $60, $60, $60, $5a, $5b, $5c, $5d, $60, $60, $60
    db $60, $60, $60, $60, $60, $60, $60, $2c, $2d, $46, $47, $48, $49, $ac, $ad, $ae
    db $af, $0e, $0f, $2c, $2d, $3c, $3d, $56, $57, $58, $59, $bc, $bd, $be, $bf, $1e
    db $1f, $3c, $3d, $2e, $2f, $46, $47, $48, $49, $ac, $ad, $ae, $af, $0e, $0f, $2c
    db $2d, $3e, $3f, $56, $57, $58, $59, $bc, $bd, $be, $bf, $1e, $1f, $3c, $3d, $4e
    db $4f, $cc, $cd, $ce, $cf, $5e, $5f, $dc, $dd, $de, $df, $cc, $cd, $ce, $cf, $60
    db $60, $dc, $dd, $de, $df, $60, $60

; I: leftover: an exact copy of CONF_OBJ_PAT (00:197D, 48 bytes) that nothing in this build reads, runs or explains
; (never read nor run in the L2 runs)
Leftover_1D_43F2_CONF_OBJ_PAT::
    db $70, $80, $80, $00, $70, $88, $80, $00, $78, $80, $80, $00, $78, $88, $80, $00
    db $80, $80, $80, $00, $80, $88, $80, $00, $88, $80, $80, $00, $88, $88, $80, $00
    db $90, $80, $80, $00, $90, $88, $80, $00, $98, $80, $80, $00, $98, $88, $80, $00

; I: leftover: 8 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_1D_4422::
    db $ce, $a0, $0a, $02, $d0, $05, $7f, $19

; I: leftover: 96 bytes of code MK_PROTECT of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_442A_MK_PROTECT::
    db $cd, $d3, $02, $cd, $41, $03, $cd, $c8, $02, $f0, $fd, $f5, $3e, $02, $e0, $fd
    db $ea, $00, $21, $21, $00, $00, $11, $00, $80, $01, $00, $18, $cd, $bf, $02, $21
    db $00, $00, $11, $00, $98, $01, $40, $02, $cd, $bf, $02, $21, $00, $c0, $3e, $3c
    db $22, $3e, $29, $22, $af, $22, $22, $3e, $3c, $22, $3e, $31, $22, $3e, $02, $22
    db $af, $22, $e0, $a6, $ea, $d9, $c0, $cd, $34, $04, $cd, $19, $04, $cd, $26, $04
    db $3e, $c7, $e0, $40, $3e, $0a, $ea, $a0, $c0, $f1, $e0, $fd, $ea, $00, $21, $c9

; I: leftover: 112 bytes of code PROTECT_TEST of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_448A_PROTECT_TEST::
    db $f0, $81, $cb, $27, $38, $41, $cb, $27, $38, $4c, $cb, $27, $cb, $27, $cb, $27
    db $cb, $27, $cb, $27, $38, $09, $cb, $27, $38, $0f, $cd, $eb, $09, $18, $50, $3e
    db $02, $ea, $bd, $c0, $cd, $4a, $05, $18, $46, $fa, $00, $c0, $fe, $3c, $20, $05
    db $cd, $4f, $1a, $18, $10, $fe, $4c, $20, $05, $cd, $89, $1a, $18, $07, $fe, $5c
    db $20, $03, $cd, $c8, $1a, $18, $28, $fa, $00, $c0, $fe, $5c, $20, $04, $d6, $20
    db $18, $13, $c6, $10, $18, $0f, $fa, $00, $c0, $fe, $3c, $20, $04, $c6, $20, $18
    db $04, $d6, $10, $18, $00, $ea, $00, $c0, $ea, $04, $c0, $af, $ea, $d9, $c0, $c9

; I: leftover: 58 bytes of code PROT_TEST of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_44FA_PROT_TEST::
    db $f3, $16, $00, $3e, $01, $ea, $00, $60, $7a, $ea, $00, $40, $21, $00, $a0, $7e
    db $47, $ee, $ff, $77, $7e, $b8, $20, $1b, $21, $ff, $bf, $7e, $47, $ee, $ff, $77
    db $7e, $b8, $20, $0f, $7a, $fe, $0f, $28, $03, $14, $18, $dc, $3e, $01, $ea, $d9
    db $c0, $fb, $c9, $3e, $02, $ea, $d9, $c0, $fb, $c9

; I: leftover: 63 bytes of code OFF_TEST of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_4534_OFF_TEST::
    db $f3, $16, $00, $3e, $01, $ea, $00, $60, $3e, $0a, $ea, $00, $00, $7a, $ea, $00
    db $40, $21, $00, $a0, $7e, $ee, $ff, $47, $77, $7e, $b8, $20, $1b, $21, $ff, $bf
    db $7e, $ee, $ff, $47, $77, $7e, $b8, $20, $0f, $7a, $fe, $0f, $28, $03, $14, $18
    db $dc, $3e, $03, $ea, $d9, $c0, $fb, $c9, $3e, $04, $ea, $d9, $c0, $fb, $c9

; I: leftover: 63 bytes of code ON_TEST of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_4573_ON_TEST::
    db $f3, $16, $00, $3e, $01, $ea, $00, $60, $3e, $00, $ea, $00, $00, $7a, $ea, $00
    db $40, $21, $00, $a0, $7e, $47, $ee, $ff, $77, $7e, $b8, $20, $1b, $21, $ff, $bf
    db $7e, $47, $ee, $ff, $77, $7e, $b8, $20, $0f, $7a, $fe, $0f, $28, $03, $14, $18
    db $dc, $3e, $05, $ea, $d9, $c0, $fb, $c9, $3e, $06, $ea, $d9, $c0, $fb, $c9

; I: leftover: 125 bytes of code VB_PROTECT of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_45B2_VB_PROTECT::
    db $fa, $d9, $c0, $b7, $20, $16, $3e, $a0, $ea, $ce, $98, $ea, $cf, $98, $ea, $0e
    db $99, $ea, $0f, $99, $ea, $4e, $99, $ea, $4f, $99, $18, $60, $fe, $01, $20, $0c
    db $3e, $cf, $ea, $ce, $98, $3e, $cb, $ea, $cf, $98, $18, $50, $fe, $02, $20, $0c
    db $3e, $ce, $ea, $ce, $98, $3e, $c7, $ea, $cf, $98, $18, $40, $fe, $03, $20, $0c
    db $3e, $cf, $ea, $0e, $99, $3e, $cb, $ea, $0f, $99, $18, $30, $fe, $04, $20, $0c
    db $3e, $ce, $ea, $0e, $99, $3e, $c7, $ea, $0f, $99, $18, $20, $fe, $05, $20, $0c
    db $3e, $cf, $ea, $4e, $99, $3e, $cb, $ea, $4f, $99, $18, $10, $fe, $06, $20, $0c
    db $3e, $ce, $ea, $4e, $99, $3e, $c7, $ea, $4f, $99, $18, $00, $c9

; I: leftover: 20 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_1D_462F::
    db $fd, $9c, $09, $00, $88, $14, $05, $00, $88, $20, $05, $06, $07, $a0, $b4, $01
    db $d0, $05, $84, $1b

; I: leftover: 24 bytes of code MK_PIC_SAVE of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_4643_MK_PIC_SAVE::
    db $3e, $0c, $ea, $a0, $c0, $cd, $c8, $02, $21, $cf, $1c, $11, $00, $c0, $01, $28
    db $00, $cd, $bf, $02, $af, $ea, $cb, $c0

; I: leftover: 67 bytes of code PIC_SAVE of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_465B_PIC_SAVE::
    db $fa, $cb, $c0, $b7, $28, $0a, $fe, $01, $28, $5d, $fe, $02, $ca, $6d, $1c, $c9
    db $f0, $81, $cb, $3f, $38, $11, $cb, $3f, $38, $2f, $cb, $3f, $cb, $3f, $cb, $3f
    db $38, $2b, $cb, $3f, $38, $34, $c9, $fa, $1a, $c0, $fe, $36, $20, $1b, $cd, $c8
    db $02, $21, $07, $1d, $11, $00, $c0, $01, $14, $00, $cd, $bf, $02, $fa, $cc, $c0
    db $cd, $9e, $1c

; I: leftover: 6 bytes of code MEN_FADE_SET of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_469E_MEN_FADE_SET::
    db $3e, $01, $ea, $cb, $c0, $c9

; I: leftover: a variant of 147 bytes of PIC_SAVE (from 00:1C13): 90 % of the bytes equal at that shift, an older or
; edited version; nothing in this build reads, runs or explains it (never read nor run in the L2 runs)
Leftover_1D_46A4_PIC_SAVE_VariantPart1C13::
    db $cd, $a5, $0e, $c9, $21, $f7, $1c, $11, $18, $c0, $01, $10, $00, $cd, $bf, $02
    db $c9, $21, $e7, $1c, $11, $18, $c0, $01, $10, $00, $cd, $bf, $02, $c9, $f0, $81
    db $cb, $3f, $38, $15, $cb, $3f, $38, $3a, $cb, $3f, $cb, $3f, $cb, $3f, $cb, $3f
    db $cb, $3f, $38, $32, $cb, $3f, $38, $3f, $c9, $cd, $78, $1c, $cd, $c8, $02, $21
    db $1b, $1d, $11, $00, $c0, $01, $18, $00, $cd, $bf, $02, $3e, $02, $ea, $cb, $c0
    db $3e, $30, $e0, $88, $fa, $cc, $c0, $3c, $fe, $1e, $20, $02, $3e, $00, $ea, $cc
    db $c0, $c9, $cd, $a5, $0e, $c9, $fa, $cc, $c0, $fe, $1d, $20, $02, $3e, $ff, $3c
    db $ea, $cc, $c0, $cd, $9e, $1c, $c9, $fa, $cc, $c0, $fe, $00, $20, $02, $3e, $1e
    db $3d, $ea, $cc, $c0, $cd, $9e, $1c, $c9, $f0, $88, $3d, $e0, $88, $b7, $c0, $cd
    db $a5, $0e, $c9

; I: leftover: 38 bytes of code PICT_SAVE_GO of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_4737_PICT_SAVE_GO::
    db $21, $00, $d0, $11, $00, $a0, $01, $00, $10, $fa, $cc, $c0, $cb, $3f, $30, $03
    db $11, $00, $b0, $c6, $01, $ea, $00, $40, $3e, $0a, $ea, $00, $00, $cd, $e7, $26
    db $3e, $00, $ea, $00, $00, $c9

; I: leftover: 49 bytes of code PUT_BYTE_OBJ2 of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_475D_PUT_BYTE_OBJ2::
    db $4f, $af, $47, $79, $b7, $28, $0b, $af, $3c, $fe, $0a, $20, $02, $04, $af, $0d
    db $20, $f6, $e0, $88, $78, $e0, $89, $21, $14, $c0, $3e, $96, $22, $3e, $70, $22
    db $f0, $89, $22, $af, $22, $3e, $96, $22, $3e, $78, $22, $f0, $88, $22, $af, $22
    db $c9

; I: leftover: 108 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_1D_478E::
    db $96, $38, $30, $00, $96, $40, $31, $00, $96, $48, $32, $00, $96, $50, $33, $00
    db $96, $58, $34, $00, $96, $60, $35, $00, $96, $68, $36, $00, $96, $70, $37, $00
    db $96, $78, $38, $00, $96, $80, $39, $00, $96, $68, $3a, $00, $96, $70, $3b, $00
    db $96, $78, $3c, $00, $96, $80, $3d, $00, $96, $40, $40, $00, $96, $48, $41, $00
    db $96, $50, $42, $00, $96, $58, $43, $00, $96, $60, $44, $00, $96, $40, $45, $00
    db $96, $48, $46, $00, $96, $50, $47, $00, $96, $58, $48, $00, $96, $60, $49, $00
    db $96, $68, $4a, $00, $17, $a0, $99, $02, $d0, $05, $33, $1d

; I: leftover: 88 bytes of code MAKE_GALLERY of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_47FA_MAKE_GALLERY::
    db $cd, $d3, $02, $cd, $41, $03, $cd, $c8, $02, $f0, $fd, $f5, $3e, $03, $e0, $fd
    db $ea, $00, $21, $21, $00, $00, $11, $00, $80, $01, $00, $18, $cd, $bf, $02, $21
    db $00, $00, $11, $00, $98, $01, $40, $02, $cd, $bf, $02, $21, $00, $a0, $fa, $cc
    db $c0, $b7, $20, $02, $3e, $1e, $3d, $ea, $cc, $c0, $cb, $3f, $30, $03, $21, $00
    db $b0, $c6, $01, $ea, $00, $40, $11, $00, $88, $01, $00, $0e, $cd, $bf, $02, $cd
    db $96, $1e, $f1, $e0, $fd, $ea, $00, $21

; I: leftover: 9 bytes of code MAKE_BANK of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_4852_MAKE_BANK::
    db $cd, $34, $04, $cd, $19, $04, $cd, $26, $04

; I: leftover: 27 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_1D_485B::
    db $3e, $01, $ea, $c9, $c0, $3e, $01, $e0, $ff, $af, $ea, $c2, $c0, $3e, $08, $e0
    db $41, $3e, $0d, $ea, $a0, $c0, $3e, $c3, $e0, $40, $c9

; I: leftover: 131 bytes of code GALLERY_MODE of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_4876_GALLERY_MODE::
    db $fa, $cd, $c0, $b7, $20, $7d, $f0, $81, $cb, $2f, $38, $19, $f0, $80, $cb, $2f
    db $cb, $2f, $38, $15, $cb, $2f, $cb, $2f, $cb, $2f, $cb, $2f, $cb, $2f, $38, $1e
    db $cb, $2f, $38, $28, $c9, $cd, $c7, $1f, $c9, $fa, $cc, $c0, $3c, $fe, $1e, $20
    db $01, $af, $ea, $cc, $c0, $3e, $04, $ea, $bd, $c0, $cd, $4a, $05, $c9, $fa, $cc
    db $c0, $3c, $fe, $1e, $20, $01, $af, $ea, $cc, $c0, $18, $0f, $fa, $cc, $c0, $3d
    db $fe, $ff, $20, $02, $3e, $1d, $ea, $cc, $c0, $18, $00, $cd, $96, $1e, $21, $c4
    db $c0, $af, $22, $3e, $88, $77, $16, $a0, $fa, $cc, $c0, $cb, $3f, $30, $02, $16
    db $b0, $c6, $01, $ea, $00, $40, $21, $c6, $c0, $af, $22, $7a, $22, $3e, $01, $ea
    db $cd, $c0, $c9

; I: leftover: 15 bytes of code PUT_PICTURE of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_48F9_PUT_PICTURE::
    db $fa, $c5, $c0, $d6, $96, $30, $04, $cd, $42, $1e, $c9, $af, $ea, $cd, $c0

; I: leftover: 1 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_1D_4908::
    db $c9

; I: leftover: 84 bytes of code H_BLANK_TX2 of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_4909_H_BLANK_TX2::
    db $f3, $3e, $80, $e0, $88, $3e, $10, $3d, $c2, $49, $1e, $3e, $02, $e0, $ff, $fa
    db $c7, $c0, $67, $fa, $c6, $c0, $6f, $2a, $47, $2a, $4f, $2a, $57, $2a, $5f, $7c
    db $ea, $c7, $c0, $7d, $ea, $c6, $c0, $fa, $c5, $c0, $67, $fa, $c4, $c0, $6f, $fb
    db $fa, $c2, $c0, $a7, $28, $fa, $f3, $af, $ea, $c2, $c0, $7c, $ea, $c5, $c0, $7d
    db $ea, $c4, $c0, $f0, $88, $3d, $e0, $88, $20, $c5, $3e, $01, $e0, $ff, $fb, $f0
    db $44, $e0, $8b, $c9

; I: leftover: 53 bytes of code GALLERY_OBJ_SET of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_495D_GALLERY_OBJ_SET::
    db $fa, $cc, $c0, $4f, $af, $47, $79, $b7, $28, $0b, $af, $3c, $fe, $0a, $20, $02
    db $04, $af, $0d, $20, $f6, $e0, $88, $78, $e0, $89, $47, $21, $00, $c0, $3e, $10
    db $22, $3e, $30, $22, $f0, $89, $22, $af, $22, $3e, $10, $22, $3e, $38, $22, $f0
    db $88, $22, $af, $22, $c9

; I: leftover: 252 bytes of code VB_GALLERY of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_4992_VB_GALLERY::
    db $cd, $b6, $ff, $c9, $fa, $c7, $c0, $67, $fa, $c6, $c0, $6f, $fa, $c5, $c0, $47
    db $fa, $c4, $c0, $4f, $3e, $00, $57, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c
    db $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a
    db $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02
    db $0c, $2a, $02, $0c, $2a, $02, $0c, $79, $82, $20, $01, $04, $2a, $02, $0c, $2a
    db $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02
    db $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c
    db $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $79, $82, $20, $01
    db $04, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c
    db $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a
    db $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02
    db $0c, $79, $82, $20, $01, $04, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a
    db $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02
    db $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c
    db $2a, $02, $0c, $2a, $02, $0c, $79, $82, $20, $01, $04, $78, $ea, $c5, $c0, $79
    db $ea, $c4, $c0, $7c, $ea, $c7, $c0, $7d, $ea, $c6, $c0, $c9

; I: leftover: 20 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_1D_4A8E::
    db $89, $9c, $09, $00, $88, $14, $05, $08, $88, $20, $05, $09, $fc, $a0, $5c, $00
    db $d0, $05, $c7, $1f

; I: leftover: 67 bytes of code PRINT_GO_GO of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_4AA2_PRINT_GO_GO::
    db $c9, $cd, $d3, $02, $cd, $a2, $2c, $3e, $c3, $e0, $40, $af, $ea, $6c, $c3, $21
    db $00, $c8, $3e, $09, $cd, $b8, $2d, $fe, $ff, $28, $28, $fe, $f0, $28, $05, $cd
    db $64, $12, $18, $f0, $3e, $01, $ea, $6c, $c3, $3e, $01, $ea, $39, $c3, $3e, $e4
    db $ea, $3b, $c3, $cd, $85, $2d, $fe, $ff, $28, $09, $fe, $f0, $28, $05, $cd, $64
    db $12, $18, $f0

; I: leftover: 1 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_1D_4AE5::
    db $c9

; I: leftover: 19 bytes of code SIOWATCHDOG2 of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_4AE6_SIOWATCHDOG2::
    db $fa, $6c, $c3, $a7, $c0, $21, $6f, $c3, $34, $7e, $fe, $06, $d8, $af, $77, $cd
    db $e9, $2e, $c9

; I: leftover: 8 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_1D_4AF9::
    db $1e, $a0, $ff, $03, $d0, $05, $1e, $20

; I: leftover: 32 bytes of code TENSOU_YOKO of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_4B01_TENSOU_YOKO::
    db $fa, $c3, $c0, $f5, $3e, $00, $ea, $c3, $c0, $ea, $00, $40, $21, $00, $a7, $11
    db $00, $d7, $01, $00, $07, $cd, $e7, $26, $f1, $ea, $c3, $c0, $ea, $00, $40, $c9

; I: leftover: 188 bytes of code TENSOU_TATE of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_4B21_TENSOU_TATE::
    db $fa, $c3, $c0, $f5, $3e, $00, $ea, $c3, $c0, $ea, $00, $40, $21, $00, $a0, $11
    db $00, $d0, $01, $80, $00, $cd, $bf, $02, $21, $00, $a1, $11, $00, $d1, $01, $80
    db $00, $cd, $bf, $02, $21, $00, $a2, $11, $00, $d2, $01, $80, $00, $cd, $bf, $02
    db $21, $00, $a3, $11, $00, $d3, $01, $80, $00, $cd, $bf, $02, $21, $00, $a4, $11
    db $00, $d4, $01, $80, $00, $cd, $bf, $02, $21, $00, $a5, $11, $00, $d5, $01, $80
    db $00, $cd, $bf, $02, $21, $00, $a6, $11, $00, $d6, $01, $80, $00, $cd, $bf, $02
    db $21, $00, $a7, $11, $00, $d7, $01, $80, $00, $cd, $bf, $02, $21, $00, $a8, $11
    db $00, $d8, $01, $80, $00, $cd, $bf, $02, $21, $00, $a9, $11, $00, $d9, $01, $80
    db $00, $cd, $bf, $02, $21, $00, $aa, $11, $00, $da, $01, $80, $00, $cd, $bf, $02
    db $21, $00, $ab, $11, $00, $db, $01, $80, $00, $cd, $bf, $02, $21, $00, $ac, $11
    db $00, $dc, $01, $80, $00, $cd, $bf, $02, $21, $00, $ad, $11, $00, $dd, $01, $80
    db $00, $cd, $bf, $02, $f1, $ea, $c3, $c0, $ea, $00, $40, $c9

; I: leftover: 290 bytes of code MIRROR_MODE of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_4BDD_MIRROR_MODE::
    INCBIN "data/bank_1d/Leftover_1D_4BDD_MIRROR_MODE.bin" ; $4BDD, 290 bytes
; I: leftover: 78 bytes of code MIRROR_LINE of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_4CFF_MIRROR_LINE::
    db $3e, $f0, $e0, $8b, $cd, $6a, $22, $3e, $d0, $e0, $8b, $cd, $6a, $22, $3e, $b0
    db $e0, $8b, $cd, $6a, $22, $3e, $90, $e0, $8b, $cd, $6a, $22, $3e, $70, $e0, $8b
    db $cd, $6a, $22, $3e, $50, $e0, $8b, $cd, $6a, $22, $3e, $30, $e0, $8b, $cd, $6a
    db $22, $3e, $10, $e0, $8b, $cd, $6a, $22, $01, $80, $00, $62, $6b, $09, $54, $5d
    db $f0, $88, $67, $f0, $89, $6f, $09, $7c, $e0, $88, $7d, $e0, $89, $c9

; I: leftover: 39 bytes of code MIRROR_CHR of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_4D4D_MIRROR_CHR::
    db $3e, $10, $e0, $8a, $f0, $88, $67, $f0, $89, $6f, $2a, $12, $47, $7c, $e0, $88
    db $7d, $e0, $89, $cd, $91, $22, $62, $6b, $f0, $8b, $85, $6f, $78, $77, $13, $f0
    db $8a, $3d, $e0, $8a, $20, $de, $c9

; I: leftover: 6 bytes of code NARABEKAE of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_4D74_NARABEKAE::
    db $26, $3d, $68, $7e, $47, $c9

; I: leftover: 213 bytes of code MABIKI_MODE of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_4D7A_MABIKI_MODE::
    db $fa, $c3, $c0, $f5, $3e, $00, $ea, $c3, $c0, $ea, $00, $40, $21, $00, $a0, $11
    db $00, $d0, $3e, $07, $ea, $bf, $c0, $3e, $08, $ea, $be, $c0, $cd, $6c, $23, $23
    db $13, $cd, $6c, $23, $23, $23, $23, $13, $cd, $6c, $23, $23, $13, $cd, $6c, $23
    db $23, $23, $23, $13, $cd, $6c, $23, $23, $13, $cd, $6c, $23, $23, $23, $23, $13
    db $cd, $6c, $23, $23, $13, $cd, $6c, $23, $23, $23, $23, $13, $01, $10, $00, $09
    db $13, $13, $13, $13, $13, $13, $13, $13, $fa, $be, $c0, $3d, $ea, $be, $c0, $c2
    db $b3, $22, $e5, $62, $6b, $01, $88, $ff, $09, $54, $5d, $e1, $3e, $08, $ea, $be
    db $c0, $cd, $6c, $23, $23, $13, $cd, $6c, $23, $23, $23, $23, $13, $cd, $6c, $23
    db $23, $13, $cd, $6c, $23, $23, $23, $23, $13, $cd, $6c, $23, $23, $13, $cd, $6c
    db $23, $23, $23, $23, $13, $cd, $6c, $23, $23, $13, $cd, $6c, $23, $23, $23, $23
    db $13, $01, $10, $00, $09, $13, $13, $13, $13, $13, $13, $13, $13, $fa, $be, $c0
    db $3d, $ea, $be, $c0, $c2, $08, $23, $fa, $bf, $c0, $3d, $28, $10, $ea, $bf, $c0
    db $e5, $62, $6b, $01, $78, $00, $09, $54, $5d, $e1, $c3, $ae, $22, $f1, $ea, $c3
    db $c0, $ea, $00, $40, $c9

; I: leftover: 94 bytes of code MABIKI_BYTE of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_4E4F_MABIKI_BYTE::
    db $7e, $e0, $88, $01, $10, $00, $09, $7e, $e0, $89, $01, $f0, $ff, $09, $f0, $88
    db $07, $cb, $10, $07, $07, $cb, $10, $07, $07, $cb, $10, $07, $07, $cb, $10, $f0
    db $89, $07, $cb, $10, $07, $07, $cb, $10, $07, $07, $cb, $10, $07, $07, $cb, $10
    db $78, $12, $e5, $62, $6b, $01, $80, $00, $09, $77, $01, $80, $06, $09, $77, $01
    db $80, $00, $09, $77, $01, $80, $f8, $09, $54, $5d, $e1, $c9, $01, $80, $07, $09
    db $77, $01, $80, $00, $09, $77, $01, $80, $f7, $09, $54, $5d, $e1, $c9

; I: leftover: 261 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_1D_4EAD::
    INCBIN "data/bank_1d/Leftover_1D_4EAD.bin" ; $4EAD, 261 bytes
; I: leftover: 51 bytes of code MABIKI_BYTE2 of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_4FB2_MABIKI_BYTE2::
    db $7e, $e0, $88, $01, $10, $00, $09, $7e, $e0, $89, $01, $f0, $ff, $09, $f0, $88
    db $07, $cb, $10, $07, $07, $cb, $10, $07, $07, $cb, $10, $07, $07, $cb, $10, $f0
    db $89, $07, $cb, $10, $07, $07, $cb, $10, $07, $07, $cb, $10, $07, $07, $cb, $10
    db $78, $12, $c9

; I: leftover: 59 bytes of code TATE_NOBASI_MODE of the bank 0 of an older build (bank $1D); found by its bytes
; (16-bit operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_4FE5_TATE_NOBASI_MODE::
    db $fa, $c3, $c0, $f5, $3e, $00, $ea, $c3, $c0, $ea, $00, $40, $21, $00, $a4, $11
    db $00, $d0, $3e, $07, $e0, $8a, $3e, $10, $e0, $89, $cd, $35, $25, $f0, $89, $3d
    db $e0, $89, $20, $f6, $e5, $21, $00, $01, $19, $54, $5d, $e1, $f0, $8a, $3d, $e0
    db $8a, $20, $e3, $f1, $ea, $c3, $c0, $ea, $00, $40, $c9

; I: leftover: 71 bytes of code TN_CHARACTER of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_5020_TN_CHARACTER::
    db $3e, $04, $e0, $88, $2a, $47, $2a, $4f, $78, $12, $13, $79, $12, $13, $78, $12
    db $13, $79, $12, $13, $f0, $88, $3d, $e0, $88, $20, $e9, $e5, $21, $f0, $00, $19
    db $54, $5d, $e1, $3e, $04, $e0, $88, $2a, $47, $2a, $4f, $78, $12, $13, $79, $12
    db $13, $78, $12, $13, $79, $12, $13, $f0, $88, $3d, $e0, $88, $20, $e9, $e5, $21
    db $00, $ff, $19, $54, $5d, $e1, $c9

; I: leftover: 57 bytes of code YOKO_NOBASI_MODE of the bank 0 of an older build (bank $1D); found by its bytes
; (16-bit operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_5067_YOKO_NOBASI_MODE::
    db $fa, $c3, $c0, $f5, $3e, $00, $ea, $c3, $c0, $ea, $00, $40, $21, $40, $a0, $11
    db $00, $d0, $3e, $0e, $e0, $8a, $3e, $08, $e0, $89, $cd, $b5, $25, $f0, $89, $3d
    db $e0, $89, $20, $f6, $d5, $11, $80, $00, $19, $d1, $f0, $8a, $3d, $e0, $8a, $20
    db $e5, $f1, $ea, $c3, $c0, $ea, $00, $40, $c9

; I: leftover: 23 bytes of code YN_CHARACTER of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_50A0_YN_CHARACTER::
    db $3e, $10, $e0, $88, $cd, $cc, $25, $f0, $88, $3d, $e0, $88, $20, $f6, $e5, $21
    db $10, $00, $19, $54, $5d, $e1, $c9

; I: leftover: 79 bytes of code YN_BYTE of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_50B7_YN_BYTE::
    db $2a, $e5, $67, $6f, $cb, $14, $cb, $10, $cb, $15, $cb, $10, $cb, $14, $cb, $10
    db $cb, $15, $cb, $10, $cb, $14, $cb, $10, $cb, $15, $cb, $10, $cb, $14, $cb, $10
    db $cb, $15, $cb, $10, $cb, $14, $cb, $11, $cb, $15, $cb, $11, $cb, $14, $cb, $11
    db $cb, $15, $cb, $11, $cb, $14, $cb, $11, $cb, $15, $cb, $11, $cb, $14, $cb, $11
    db $cb, $15, $cb, $11, $78, $12, $21, $10, $00, $19, $79, $77, $13, $e1, $c9

; I: leftover: 65 bytes of code KAKUDAI_MODE of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_5106_KAKUDAI_MODE::
    db $fa, $c3, $c0, $f5, $3e, $00, $ea, $c3, $c0, $ea, $00, $40, $21, $40, $a4, $11
    db $00, $d0, $3e, $07, $e0, $8a, $3e, $08, $e0, $89, $cd, $5c, $26, $f0, $89, $3d
    db $e0, $89, $20, $f6, $d5, $11, $80, $00, $19, $d1, $e5, $21, $00, $01, $19, $54
    db $5d, $e1, $f0, $8a, $3d, $e0, $8a, $20, $dd, $f1, $ea, $c3, $c0, $ea, $00, $40
    db $c9

; I: leftover: 55 bytes of code KD_CHARACTER of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_5147_KD_CHARACTER::
    db $3e, $04, $e0, $88, $cd, $93, $26, $1b, $cd, $93, $26, $13, $f0, $88, $3d, $e0
    db $88, $20, $f1, $e5, $21, $f0, $00, $19, $54, $5d, $e1, $3e, $04, $e0, $88, $cd
    db $93, $26, $1b, $cd, $93, $26, $13, $f0, $88, $3d, $e0, $88, $20, $f1, $e5, $21
    db $10, $ff, $19, $54, $5d, $e1, $c9

; I: leftover: 84 bytes of code KD_BYTE of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_517E_KD_BYTE::
    db $2a, $e5, $67, $6f, $cb, $14, $cb, $10, $cb, $15, $cb, $10, $cb, $14, $cb, $10
    db $cb, $15, $cb, $10, $cb, $14, $cb, $10, $cb, $15, $cb, $10, $cb, $14, $cb, $10
    db $cb, $15, $cb, $10, $cb, $14, $cb, $11, $cb, $15, $cb, $11, $cb, $14, $cb, $11
    db $cb, $15, $cb, $11, $cb, $14, $cb, $11, $cb, $15, $cb, $11, $cb, $14, $cb, $11
    db $cb, $15, $cb, $11, $78, $12, $13, $13, $12, $21, $0e, $00, $19, $79, $77, $23
    db $23, $77, $e1, $c9

; I: leftover: an exact copy of 48 bytes of ImageCopy_Mode13 (from 00:2968, a part of the block) that nothing in this
; build reads, runs or explains (never read nor run in the L2 runs)
Leftover_1D_51D2_ImageCopy_Mode13_Part2968::
    db $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a
    db $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12
    db $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c

; I: leftover: an exact copy of 48 bytes of ImageCopy_Mode13 (from 00:2968, a part of the block) that nothing in this
; build reads, runs or explains (never read nor run in the L2 runs)
Leftover_1D_5202_ImageCopy_Mode13_Part2968::
    db $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a
    db $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12
    db $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c

; I: leftover: an exact copy of 48 bytes of ImageCopy_Mode13 (from 00:2968, a part of the block) that nothing in this
; build reads, runs or explains (never read nor run in the L2 runs)
Leftover_1D_5232_ImageCopy_Mode13_Part2968::
    db $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a
    db $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12
    db $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c

; I: leftover: an exact copy of 48 bytes of ImageCopy_Mode13 (from 00:2968, a part of the block) that nothing in this
; build reads, runs or explains (never read nor run in the L2 runs)
Leftover_1D_5262_ImageCopy_Mode13_Part2968::
    db $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a
    db $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12
    db $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c

; I: leftover: an exact copy of 48 bytes of ImageCopy_Mode13 (from 00:2968, a part of the block) that nothing in this
; build reads, runs or explains (never read nor run in the L2 runs)
Leftover_1D_5292_ImageCopy_Mode13_Part2968::
    db $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a
    db $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12
    db $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c

; I: leftover: an exact copy of 48 bytes of ImageCopy_Mode13 (from 00:2968, a part of the block) that nothing in this
; build reads, runs or explains (never read nor run in the L2 runs)
Leftover_1D_52C2_ImageCopy_Mode13_Part2968::
    db $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a
    db $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12
    db $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c

; I: leftover: 19 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_1D_52F2::
    db $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $3f, $a0, $e0, $01, $d0
    db $05, $12, $28

; I: leftover: an exact copy of 46 bytes of ImageCopy_Mode13 (from 00:296A, a part of the block) that nothing in this
; build reads, runs or explains (never read nor run in the L2 runs)
Leftover_1D_5305_ImageCopy_Mode13_Part296A::
    db $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c
    db $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a
    db $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c

; I: leftover: an exact copy of 48 bytes of ImageCopy_Mode13 (from 00:2968, a part of the block) that nothing in this
; build reads, runs or explains (never read nor run in the L2 runs)
Leftover_1D_5333_ImageCopy_Mode13_Part2968::
    db $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a
    db $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12
    db $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c

; I: leftover: an exact copy of 48 bytes of ImageCopy_Mode13 (from 00:2968, a part of the block) that nothing in this
; build reads, runs or explains (never read nor run in the L2 runs)
Leftover_1D_5363_ImageCopy_Mode13_Part2968::
    db $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a
    db $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12
    db $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c

; I: leftover: an exact copy of 48 bytes of ImageCopy_Mode13 (from 00:2968, a part of the block) that nothing in this
; build reads, runs or explains (never read nor run in the L2 runs)
Leftover_1D_5393_ImageCopy_Mode13_Part2968::
    db $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a
    db $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12
    db $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c

; I: leftover: an exact copy of 48 bytes of ImageCopy_Mode13 (from 00:2968, a part of the block) that nothing in this
; build reads, runs or explains (never read nor run in the L2 runs)
Leftover_1D_53C3_ImageCopy_Mode13_Part2968::
    db $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a
    db $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12
    db $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c

; I: leftover: an exact copy of 48 bytes of ImageCopy_Mode13 (from 00:2968, a part of the block) that nothing in this
; build reads, runs or explains (never read nor run in the L2 runs)
Leftover_1D_53F3_ImageCopy_Mode13_Part2968::
    db $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a
    db $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12
    db $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c

; I: leftover: an exact copy of 48 bytes of ImageCopy_Mode13 (from 00:2968, a part of the block) that nothing in this
; build reads, runs or explains (never read nor run in the L2 runs)
Leftover_1D_5423_ImageCopy_Mode13_Part2968::
    db $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a
    db $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12
    db $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c

; I: leftover: an exact copy of 48 bytes of ImageCopy_Mode13 (from 00:2968, a part of the block) that nothing in this
; build reads, runs or explains (never read nor run in the L2 runs)
Leftover_1D_5453_ImageCopy_Mode13_Part2968::
    db $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a
    db $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12
    db $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c

; I: leftover: an exact copy of 48 bytes of ImageCopy_Mode13 (from 00:2968, a part of the block) that nothing in this
; build reads, runs or explains (never read nor run in the L2 runs)
Leftover_1D_5483_ImageCopy_Mode13_Part2968::
    db $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a
    db $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12
    db $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c

; I: leftover: an exact copy of 39 bytes of ImageCopy_Mode13 (from 00:2968, a part of the block) that nothing in this
; build reads, runs or explains (never read nor run in the L2 runs)
Leftover_1D_54B3_ImageCopy_Mode13_Part2968::
    db $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a
    db $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12
    db $1c, $2a, $12, $1c, $2a, $12, $1c

; I: leftover: 14 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_1D_54DA::
    db $14, $05, $c2, $e7, $26, $c9, $03, $a0, $ed, $00, $d0, $05, $ed, $29

; I: leftover: 115 bytes of code MAKE_EMI of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_54E8_MAKE_EMI::
    db $cd, $d3, $02, $cd, $41, $03, $cd, $c8, $02, $f0, $fd, $f5, $3e, $03, $e0, $fd
    db $ea, $00, $21, $21, $00, $00, $11, $00, $80, $01, $00, $18, $cd, $e7, $26, $21
    db $00, $00, $11, $00, $98, $01, $40, $02, $cd, $bf, $02, $f1, $e0, $fd, $ea, $00
    db $21, $3e, $80, $e0, $02, $3e, $fe, $e0, $01, $af, $e0, $4a, $e0, $42, $e0, $a1
    db $e0, $43, $e0, $a0, $3e, $e4, $e0, $48, $e0, $47, $e0, $ac, $e0, $ae, $3e, $d0
    db $e0, $49, $e0, $ad, $3e, $0b, $ea, $a0, $c0, $af, $ea, $d4, $c0, $3e, $c3, $e0
    db $40, $3e, $58, $ea, $d5, $c0, $3e, $5d, $ea, $d6, $c0, $af, $ea, $d7, $c0, $ea
    db $d4, $c0, $c9

; I: leftover: 39 bytes of code EMI_MAIN of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_555B_EMI_MAIN::
    db $f0, $81, $cb, $4f, $28, $09, $3e, $05, $ea, $bd, $c0, $cd, $4a, $05, $c9, $fa
    db $d4, $c0, $fe, $02, $28, $11, $cd, $9a, $2a, $cd, $aa, $2a, $fa, $d7, $c0, $a7
    db $c8, $3e, $02, $ea, $d4, $c0, $c9

; I: leftover: 19 bytes of code N_TU_SIN of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_5582_N_TU_SIN::
    db $fa, $d7, $c0, $a7, $c8, $cd, $b8, $2a, $fa, $d7, $c0, $fe, $02, $c0, $3e, $81
    db $e0, $02, $c9

; I: leftover: 16 bytes of code N_KEY_INPUT of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_5595_N_KEY_INPUT::
    db $f0, $81, $cb, $47, $20, $01, $c9, $3e, $00, $e0, $01, $3e, $81, $e0, $02, $c9

; I: leftover: 14 bytes of code N_OBJ_HYOUJI of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_55A5_N_OBJ_HYOUJI::
    db $21, $00, $c0, $3e, $54, $22, $3e, $50, $22, $3e, $00, $22, $77, $c9

; I: leftover: 29 bytes of code N_OBJ_HYOUJI2 of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_55B3_N_OBJ_HYOUJI2::
    db $21, $02, $c0, $fa, $dd, $c0, $cb, $3f, $cb, $3f, $cb, $3f, $cb, $3f, $22, $23
    db $3e, $54, $22, $3e, $58, $22, $fa, $dd, $c0, $e6, $0f, $22, $c9

; I: leftover: 20 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_1D_55D0::
    db $8d, $9c, $09, $00, $88, $14, $05, $08, $88, $20, $05, $09, $fc, $a0, $3b, $00
    db $d0, $05, $d5, $2a

; I: leftover: 23 bytes of code SIOINT of the printer library of an older build, the Japanese Prn_SerialIrq (00:0F16,
; exact match, instruction ratio 1.00); found by its bytes (16-bit operands masked) in the order of bank $2C; code
; that this build never runs (typed data)
Leftover_1D_55E4_SIOINT::
    db $f5, $f0, $02, $cb, $7f, $20, $0e, $c5, $d5, $e5, $3e, $01, $ea, $5b, $c3, $cd
    db $0b, $2b, $e1, $d1, $c1, $f1, $d9

; I: leftover: 39 bytes of code SIOWATCHDOG of the printer library of an older build, the Japanese Prn_VBlankPoll
; (00:0F2D, near match, instruction ratio 0.97); found by its bytes (16-bit operands masked) in the order of bank $2C;
; code that this build never runs (typed data)
Leftover_1D_55FB_SIOWATCHDOG::
    db $fa, $3e, $c3, $fe, $01, $c0, $fa, $58, $c3, $fe, $ff, $c8, $fa, $6c, $c3, $a7
    db $c0, $21, $6f, $c3, $34, $7e, $fe, $06, $d8, $af, $77, $cd, $e9, $2e, $c9, $14
    db $a0, $9c, $01, $d0, $05, $0b, $2b

; I: leftover: 62 bytes of code SIOPROC of the printer library of an older build, the Japanese Prn_SerialStep
; (00:176F, exact match, instruction ratio 1.00); found by its bytes (16-bit operands masked) in the order of bank
; $2C; code that this build never runs (typed data)
Leftover_1D_5622_SIOPROC::
    db $fa, $6d, $c3, $a7, $c2, $9d, $2c, $fa, $3e, $c3, $fe, $07, $ca, $59, $2c, $fa
    db $40, $c3, $a7, $20, $06, $cd, $49, $2b, $c3, $a1, $2c, $fa, $41, $c3, $a7, $28
    db $17, $fa, $42, $c3, $a7, $28, $11, $fa, $43, $c3, $fe, $02, $28, $05, $cd, $28
    db $2c, $18, $08, $cd, $3f, $2c, $18, $03, $cd, $6e, $2b, $c3, $a1, $2c

; I: leftover: 37 bytes of code PREAMBLETRANS of the printer library of an older build, the Japanese Prn_SendSyncByte
; (00:17AD, exact match, instruction ratio 1.00); found by its bytes (16-bit operands masked) in the order of bank
; $2C; code that this build never runs (typed data)
Leftover_1D_5660_PREAMBLETRANS::
    db $21, $4a, $c3, $4e, $34, $06, $00, $21, $3c, $2f, $09, $7e, $e0, $01, $3e, $01
    db $e0, $02, $3e, $81, $e0, $02, $fa, $4a, $c3, $fe, $02, $c0, $af, $ea, $4a, $c3
    db $3c, $ea, $40, $c3, $c9

; I: leftover: 142 bytes of code TRANSMIT of the printer library of an older build, the Japanese Prn_SendPacketByte
; (00:17D2, near match, instruction ratio 0.95); found by its bytes (16-bit operands masked) in the order of bank $2C;
; code that this build never runs (typed data)
Leftover_1D_5685_TRANSMIT::
    db $fa, $4a, $c3, $4f, $fa, $4b, $c3, $47, $fa, $4c, $c3, $6f, $fa, $4d, $c3, $67
    db $09, $f0, $01, $ea, $5a, $c3, $7e, $e0, $01, $6f, $fa, $54, $c3, $85, $ea, $54
    db $c3, $fa, $55, $c3, $ce, $00, $ea, $55, $c3, $3e, $01, $e0, $02, $3e, $81, $e0
    db $02, $21, $4a, $c3, $34, $20, $02, $23, $34, $21, $4a, $c3, $fa, $44, $c3, $be
    db $20, $07, $23, $fa, $45, $c3, $be, $28, $02, $18, $3e, $21, $41, $c3, $7e, $a7
    db $28, $03, $21, $42, $c3, $34, $fa, $5d, $c3, $a7, $28, $32, $fa, $3e, $c3, $fe
    db $06, $28, $2b, $21, $42, $c3, $7e, $a7, $20, $20, $af, $ea, $4a, $c3, $ea, $4b
    db $c3, $fa, $50, $c3, $ea, $4c, $c3, $fa, $51, $c3, $ea, $4d, $c3, $fa, $48, $c3
    db $ea, $44, $c3, $fa, $49, $c3, $ea, $45, $c3, $c9, $cd, $0f, $2c, $c9

; I: leftover: 6 bytes of code SETENDOFTRANS of the printer library of an older build, no Japanese counterpart of 0.8
; or more; found by its bytes (16-bit operands masked) in the order of bank $2C; code that this build never runs
; (typed data)
Leftover_1D_5713_SETENDOFTRANS::
    db $fa, $5a, $c3, $ea, $59, $c3

; I: leftover: 13 bytes of code SETENDOFTRANS_DATA of the printer library of an older build, no Japanese counterpart
; of 0.8 or more; found by its bytes (16-bit operands masked) in the order of bank $2C; code that this build never
; runs (typed data)
Leftover_1D_5719_SETENDOFTRANS_DATA::
    db $3e, $07, $ea, $3e, $c3, $3e, $01, $ea, $56, $c3, $cd, $07, $2d

; I: leftover: 25 bytes of code FORRETRY_DATATRANS of the printer library of an older build, the Japanese
; Prn_RestoreHeaderPtr (00:1873, exact match, instruction ratio 1.00); found by its bytes (16-bit operands masked) in
; the order of bank $2C; code that this build never runs (typed data)
Leftover_1D_5726_FORRETRY_DATATRANS::
    db $fa, $46, $c3, $ea, $44, $c3, $fa, $47, $c3, $ea, $45, $c3, $fa, $4e, $c3, $ea
    db $4c, $c3, $fa, $4f, $c3, $ea, $4d, $c3, $c9

; I: leftover: 23 bytes of code TRANSCHECKSUM of the printer library of an older build, the Japanese
; Prn_SendChecksumByte (00:188C, exact match, instruction ratio 1.00); found by its bytes (16-bit operands masked) in
; the order of bank $2C; code that this build never runs (typed data)
Leftover_1D_573F_TRANSCHECKSUM::
    db $4f, $06, $00, $21, $54, $c3, $09, $7e, $e0, $01, $3e, $01, $e0, $02, $3e, $81
    db $e0, $02, $21, $43, $c3, $34, $c9

; I: leftover: 26 bytes of code TRANSDUMMY of the printer library of an older build, the Japanese Prn_SendTrailerByte
; (00:18A3, exact match, instruction ratio 1.00); found by its bytes (16-bit operands masked) in the order of bank
; $2C; code that this build never runs (typed data)
Leftover_1D_5756_TRANSDUMMY::
    db $f0, $01, $ea, $59, $c3, $af, $e0, $01, $3e, $01, $e0, $02, $3e, $81, $e0, $02
    db $21, $57, $c3, $34, $7e, $fe, $02, $28, $aa, $c9

; I: leftover: 68 bytes of code GETPRINTERSTATUS of the printer library of an older build, the Japanese
; Prn_ReceiveStatus (00:18BD, near match, instruction ratio 0.90); found by its bytes (16-bit operands masked) in the
; order of bank $2C; code that this build never runs (typed data)
Leftover_1D_5770_GETPRINTERSTATUS::
    db $fa, $5c, $c3, $ea, $3f, $c3, $fa, $58, $c3, $ea, $01, $c3, $fe, $ff, $28, $03
    db $ea, $00, $c3, $f0, $01, $ea, $58, $c3, $fe, $ff, $20, $0c, $3e, $00, $ea, $6c
    db $c3, $ea, $3e, $c3, $3e, $02, $18, $0f, $cb, $67, $3e, $00, $ea, $3e, $c3, $3e
    db $01, $20, $03, $ea, $3e, $c3, $3c, $ea, $56, $c3, $fa, $5d, $c3, $a7, $20, $04
    db $af, $ea, $6c, $c3

; I: leftover: 1 bytes of code SIOFORCEEND of the printer library of an older build, too short to pair with a Japanese
; routine; found by its bytes (16-bit operands masked) in the order of bank $2C; code that this build never runs
; (typed data)
Leftover_1D_57B4_SIOFORCEEND::
    db $c9

; I: leftover: 3 bytes of code SIOERRORRET of the printer library of an older build, too short to pair with a Japanese
; routine; found by its bytes (16-bit operands masked) in the order of bank $2C; code that this build never runs
; (typed data)
Leftover_1D_57B5_SIOERRORRET::
    db $af, $e0, $02

; I: leftover: 9 bytes of code SIOINTRET of the printer library of an older build, too short to pair with a Japanese
; routine; found by its bytes (16-bit operands masked) in the order of bank $2C; code that this build never runs
; (typed data)
Leftover_1D_57B8_SIOINTRET::
    db $c9, $33, $a0, $43, $00, $d0, $05, $a2, $2c

; I: leftover: 70 bytes of code PRINT_PICTURE_MAKE of the printer library of an older build, no Japanese counterpart
; of 0.8 or more; found by its bytes (16-bit operands masked) in the order of bank $2C; code that this build never
; runs (typed data)
Leftover_1D_57C1_PRINT_PICTURE_MAKE::
    db $21, $00, $c8, $01, $80, $16, $af, $22, $0d, $20, $fc, $05, $20, $f9, $cd, $b4
    db $2c, $c9, $21, $00, $90, $11, $a0, $ca, $06, $08, $cd, $cc, $2c, $21, $00, $88
    db $06, $01, $cd, $cc, $2c, $21, $00, $80, $06, $05, $0e, $00, $2a, $12, $13, $0d
    db $20, $fa, $e5, $21, $40, $00, $19, $5d, $54, $e1, $05, $20, $ed, $c9, $fc, $a0
    db $86, $03, $d0, $05, $e0, $2c

; I: leftover: 5 bytes of code SIOHIBERNATE of the printer library of an older build, too short to pair with a
; Japanese routine; found by its bytes (16-bit operands masked) in the order of bank $2C; code that this build never
; runs (typed data)
Leftover_1D_5807_SIOHIBERNATE::
    db $af, $e0, $02, $e0, $01

; I: leftover: 24 bytes of code SIOINITIALIZE of the printer library of an older build, the Japanese Prn_EngineStop
; (00:1914, near match, instruction ratio 0.90); found by its bytes (16-bit operands masked) in the order of bank $2C;
; code that this build never runs (typed data)
Leftover_1D_580C_SIOINITIALIZE::
    db $af, $e0, $01, $e0, $02, $ea, $3e, $c3, $3d, $ea, $58, $c3, $ea, $59, $c3, $3e
    db $80, $ea, $38, $c3, $cd, $fd, $2c, $c9

; I: leftover: 10 bytes of code SIOFLAGINIT of the printer library of an older build, the Japanese Prn_ClearTxFlags
; (00:1927, exact match, instruction ratio 1.00); found by its bytes (16-bit operands masked) in the order of bank
; $2C; code that this build never runs (typed data)
Leftover_1D_5824_SIOFLAGINIT::
    db $af, $ea, $56, $c3, $ea, $5b, $c3, $ea, $6c, $c3

; I: leftover: 32 bytes of code CLEARFLAGS of the printer library of an older build, the Japanese Prn_ResetPacketState
; (00:1931, near match, instruction ratio 0.96); found by its bytes (16-bit operands masked) in the order of bank $2C;
; code that this build never runs (typed data)
Leftover_1D_582E_CLEARFLAGS::
    db $af, $ea, $40, $c3, $ea, $41, $c3, $ea, $42, $c3, $ea, $43, $c3, $ea, $57, $c3
    db $ea, $54, $c3, $ea, $55, $c3, $ea, $4a, $c3, $ea, $4b, $c3, $ea, $6d, $c3, $c9

; I: leftover: 27 bytes of code CONNECTPRN of the printer library of an older build, the Japanese Prn_SendInit
; (00:1954, exact match, instruction ratio 1.00); found by its bytes (16-bit operands masked) in the order of bank
; $2C; code that this build never runs (typed data)
Leftover_1D_584E_CONNECTPRN::
    db $fa, $6c, $c3, $a7, $28, $04, $cd, $42, $2d, $d0, $fa, $3f, $c3, $fe, $01, $20
    db $04, $cd, $42, $2d, $d0, $cd, $62, $2f, $c3, $25, $30

; I: leftover: 67 bytes of code CHECKENDOFTRANS of the printer library of an older build, the Japanese Prn_CheckTxDone
; (00:196F, near match, instruction ratio 0.81); found by its bytes (16-bit operands masked) in the order of bank $2C;
; code that this build never runs (typed data)
Leftover_1D_5869_CHECKENDOFTRANS::
    db $fa, $56, $c3, $fe, $02, $20, $38, $af, $ea, $6f, $c3, $ea, $3f, $c3, $3c, $ea
    db $3e, $c3, $fa, $58, $c3, $fe, $ff, $28, $1f, $cb, $47, $20, $14, $cb, $4f, $20
    db $10, $cb, $67, $28, $18, $af, $ea, $3e, $c3, $ea, $3f, $c3, $fa, $58, $c3, $18
    db $0c, $37, $c9, $af, $ea, $3f, $c3, $3d, $3c, $ea, $3e, $c3, $3d, $a7, $c9, $af
    db $3e, $f0, $c9

; I: leftover: 51 bytes of code INSTRUCTPRN of the printer library of an older build, the Japanese Prn_SendPrint
; (00:19B2, near match, instruction ratio 0.94); found by its bytes (16-bit operands masked) in the order of bank $2C;
; code that this build never runs (typed data)
Leftover_1D_58AC_INSTRUCTPRN::
    db $fa, $3e, $c3, $fe, $01, $28, $0b, $fe, $02, $28, $07, $a7, $3e, $ff, $c8, $3e
    db $f0, $c9, $fa, $6c, $c3, $a7, $28, $04, $cd, $42, $2d, $d0, $fa, $3f, $c3, $fe
    db $02, $20, $04, $cd, $42, $2d, $d0, $fa, $58, $c3, $fe, $ff, $c8, $cd, $6f, $2f
    db $c3, $25, $30

; I: leftover: 254 bytes of code DATATRANSPRN of the printer library of an older build, no Japanese counterpart of 0.8
; or more; found by its bytes (16-bit operands masked) in the order of bank $2C; code that this build never runs
; (typed data)
Leftover_1D_58DF_DATATRANSPRN::
    db $4f, $fa, $3e, $c3, $a7, $fa, $58, $c3, $c8, $fa, $3e, $c3, $fe, $01, $28, $07
    db $fe, $03, $28, $03, $3e, $f0, $c9, $fa, $6c, $c3, $a7, $20, $50, $79, $3c, $ea
    db $6e, $c3, $7d, $ea, $52, $c3, $7c, $ea, $53, $c3, $fa, $58, $c3, $fe, $ff, $c8
    db $fa, $3c, $c3, $ea, $3d, $c3, $a7, $28, $26, $3e, $0a, $ea, $6e, $c3, $3d, $3d
    db $f5, $4f, $06, $00, $e5, $21, $2e, $c3, $09, $7e, $e1, $ea, $3d, $c3, $f1, $87
    db $4f, $06, $00, $e5, $21, $1c, $c3, $09, $2a, $46, $e1, $4f, $c3, $1f, $2e, $01
    db $80, $02, $3e, $0a, $ea, $6e, $c3, $cd, $c9, $2f, $c3, $25, $30, $fa, $56, $c3
    db $fe, $02, $3e, $f0, $c2, $af, $2e, $21, $6e, $c3, $fa, $58, $c3, $cb, $67, $c2
    db $9f, $2e, $cb, $4f, $c2, $4a, $2e, $cb, $47, $c2, $4a, $2e, $35, $fa, $58, $c3
    db $28, $5c, $7e, $fe, $01, $28, $61, $01, $80, $02, $fa, $3c, $c3, $ea, $3d, $c3
    db $a7, $28, $21, $fa, $6e, $c3, $3d, $3d, $f5, $4f, $06, $00, $e5, $21, $2e, $c3
    db $09, $7e, $e1, $ea, $3d, $c3, $f1, $87, $4f, $06, $00, $e5, $21, $1c, $c3, $09
    db $2a, $46, $e1, $4f, $fa, $58, $c3, $cb, $4f, $c2, $94, $2e, $fa, $50, $c3, $c6
    db $80, $ea, $50, $c3, $fa, $51, $c3, $ce, $02, $ea, $51, $c3, $fa, $50, $c3, $6f
    db $fa, $51, $c3, $67, $c3, $1f, $2e, $f5, $3e, $01, $ea, $6d, $c3, $f1, $f5, $af
    db $ea, $5d, $c3, $ea, $6c, $c3, $f1, $c9, $cd, $17, $30, $c3, $25, $30

; I: leftover: 51 bytes of code BREAKPRN of the printer library of an older build, the Japanese Prn_SendBreak_Dead
; (00:1AEB, exact match, instruction ratio 1.00); found by its bytes (16-bit operands masked) in the order of bank
; $2C; code that this build never runs (typed data)
Leftover_1D_59DD_BREAKPRN::
    db $fa, $3e, $c3, $fe, $01, $28, $0b, $fe, $03, $28, $07, $a7, $3e, $ff, $c8, $3e
    db $f0, $c9, $fa, $6c, $c3, $a7, $28, $04, $cd, $42, $2d, $d0, $fa, $3f, $c3, $fe
    db $04, $20, $04, $cd, $42, $2d, $d0, $fa, $58, $c3, $fe, $ff, $c8, $cd, $fd, $2f
    db $c3, $25, $30

; I: leftover: 40 bytes of code NULTRANSPRN of the printer library of an older build, the Japanese Prn_SendInquiry
; (00:1B1E, exact match, instruction ratio 1.00); found by its bytes (16-bit operands masked) in the order of bank
; $2C; code that this build never runs (typed data)
Leftover_1D_5A10_NULTRANSPRN::
    db $fa, $3e, $c3, $fe, $01, $28, $0b, $fe, $03, $28, $07, $a7, $3e, $ff, $c8, $3e
    db $f0, $c9, $fa, $6c, $c3, $a7, $28, $04, $cd, $42, $2d, $d0, $fa, $58, $c3, $fe
    db $ff, $c8, $cd, $0a, $30, $c3, $25, $30

; I: leftover: 43 bytes of code INITDATATRANS of the printer library of an older build, the Japanese Prn_QueuePacket
; (00:1B46, exact match, instruction ratio 1.00); found by its bytes (16-bit operands masked) in the order of bank
; $2C; code that this build never runs (typed data)
Leftover_1D_5A38_INITDATATRANS::
    db $ea, $5c, $c3, $7a, $ea, $5d, $c3, $7d, $ea, $4c, $c3, $ea, $4e, $c3, $7c, $ea
    db $4d, $c3, $ea, $4f, $c3, $79, $ea, $44, $c3, $ea, $46, $c3, $78, $ea, $45, $c3
    db $ea, $47, $c3, $af, $ea, $56, $c3, $cd, $07, $2d, $c9

; I: leftover: 2 bytes of data PREAMBLEDATA of the printer library of an older build, the Japanese Prn_SyncBytes
; (00:1B71, exact match, instruction ratio 1.00); found by its bytes (16-bit operands masked) in the order of bank
; $2C; nothing in this build reads it
Leftover_1D_5A63_PREAMBLEDATA::
    db $88, $33

; I: leftover: 8 bytes of data PACKET1 of the printer library of an older build, the Japanese Prn_PktInit (00:1B73,
; exact match, instruction ratio 1.00); found by its bytes (16-bit operands masked) in the order of bank $2C; nothing
; in this build reads it
Leftover_1D_5A65_PACKET1::
    db $01, $00, $00, $00, $01, $00, $00, $00

; I: leftover: 4 bytes of data PACKET2 of the printer library of an older build, the Japanese Prn_PktPrintHdr
; (00:1B7B, exact match, instruction ratio 1.00); found by its bytes (16-bit operands masked) in the order of bank
; $2C; nothing in this build reads it
Leftover_1D_5A6D_PACKET2::
    db $02, $00, $04, $00

; I: leftover: 8 bytes of data PACKET6 of the printer library of an older build, the Japanese Prn_PktDataEnd (00:1B7F,
; exact match, instruction ratio 1.00); found by its bytes (16-bit operands masked) in the order of bank $2C; nothing
; in this build reads it
Leftover_1D_5A71_PACKET6::
    db $04, $00, $00, $00, $04, $00, $00, $00

; I: leftover: 8 bytes of data PACKET4 of the printer library of an older build, the Japanese Prn_PktBreak (00:1B87,
; exact match, instruction ratio 1.00); found by its bytes (16-bit operands masked) in the order of bank $2C; nothing
; in this build reads it
Leftover_1D_5A79_PACKET4::
    db $08, $00, $00, $00, $08, $00, $00, $00

; I: leftover: 8 bytes of data PACKET5 of the printer library of an older build, the Japanese Prn_PktInquiry (00:1B8F,
; exact match, instruction ratio 1.00); found by its bytes (16-bit operands masked) in the order of bank $2C; nothing
; in this build reads it
Leftover_1D_5A81_PACKET5::
    db $0f, $00, $00, $00, $0f, $00, $00, $00

; I: leftover: 13 bytes of code PREPAREPACKET1 of the printer library of an older build, the Japanese Prn_QueueInit
; (00:1B97, exact match, instruction ratio 1.00); found by its bytes (16-bit operands masked) in the order of bank
; $2C; code that this build never runs (typed data)
Leftover_1D_5A89_PREPAREPACKET1::
    db $3e, $01, $16, $00, $21, $3e, $2f, $01, $08, $00, $c3, $11, $2f

; I: leftover: 90 bytes of code PREPAREPACKET2 of the printer library of an older build, the Japanese Prn_QueuePrint
; (00:1BA4, near match, instruction ratio 0.83); found by its bytes (16-bit operands masked) in the order of bank $2C;
; code that this build never runs (typed data)
Leftover_1D_5A96_PREPAREPACKET2::
    db $3e, $02, $16, $00, $21, $5e, $c3, $01, $0c, $00, $cd, $11, $2f, $21, $46, $2f
    db $11, $5e, $c3, $01, $04, $00, $2a, $12, $13, $0d, $20, $fa, $11, $06, $00, $fa
    db $39, $c3, $ea, $62, $c3, $cd, $c2, $2f, $fa, $3a, $c3, $ea, $63, $c3, $cd, $c2
    db $2f, $fa, $3b, $c3, $ea, $64, $c3, $cd, $c2, $2f, $fa, $38, $c3, $ea, $65, $c3
    db $cd, $c2, $2f, $7b, $ea, $66, $c3, $7a, $ea, $67, $c3, $af, $ea, $68, $c3, $ea
    db $69, $c3, $c9, $83, $5f, $7a, $ce, $00, $57, $c9

; I: leftover: 52 bytes of code PREPAREPACKET3 of the printer library of an older build, the Japanese Prn_QueueData
; (00:1BFB, exact match, instruction ratio 1.00); found by its bytes (16-bit operands masked) in the order of bank
; $2C; code that this build never runs (typed data)
Leftover_1D_5AF0_PREPAREPACKET3::
    db $7d, $ea, $50, $c3, $7c, $ea, $51, $c3, $79, $ea, $48, $c3, $78, $ea, $49, $c3
    db $c5, $3e, $03, $16, $01, $21, $5e, $c3, $01, $04, $00, $cd, $11, $2f, $fa, $4a
    db $2f, $ea, $5e, $c3, $fa, $3d, $c3, $ea, $5f, $c3, $c1, $79, $ea, $60, $c3, $78
    db $ea, $61, $c3, $c9

; I: leftover: 13 bytes of code PREPAREPACKET4 of the printer library of an older build, the Japanese Prn_QueueInit
; (00:1B97, near match, instruction ratio 0.80); found by its bytes (16-bit operands masked) in the order of bank $2C;
; code that this build never runs (typed data)
Leftover_1D_5B24_PREPAREPACKET4::
    db $3e, $04, $16, $00, $21, $52, $2f, $01, $08, $00, $c3, $11, $2f

; I: leftover: 13 bytes of code PREPAREPACKET5 of the printer library of an older build, the Japanese Prn_QueueInquiry
; (00:1C3C, exact match, instruction ratio 1.00); found by its bytes (16-bit operands masked) in the order of bank
; $2C; code that this build never runs (typed data)
Leftover_1D_5B31_PREPAREPACKET5::
    db $3e, $05, $16, $00, $21, $5a, $2f, $01, $08, $00, $c3, $11, $2f

; I: leftover: 14 bytes of code PREPAREPACKET6 of the printer library of an older build, the Japanese Prn_QueueDataEnd
; (00:1C49, near match, instruction ratio 0.91); found by its bytes (16-bit operands masked) in the order of bank $2C;
; code that this build never runs (typed data)
Leftover_1D_5B3E_PREPAREPACKET6::
    db $3e, $06, $16, $01, $21, $4a, $2f, $01, $08, $00, $c3, $11, $2f, $c9

; I: leftover: 68 bytes of code STARTSTRINGTRANS of the printer library of an older build, the Japanese
; Prn_StartTransmit (00:1C57, exact match, instruction ratio 1.00); found by its bytes (16-bit operands masked) in the
; order of bank $2C; code that this build never runs (typed data)
Leftover_1D_5B4C_STARTSTRINGTRANS::
    db $fa, $3e, $c3, $fe, $01, $28, $0c, $a7, $20, $07, $fa, $5c, $c3, $fe, $01, $28
    db $0c, $37, $c9, $fa, $5c, $c3, $fe, $01, $28, $f7, $ea, $3e, $c3, $af, $ea, $56
    db $c3, $ea, $3f, $c3, $3e, $01, $ea, $4a, $c3, $ea, $6c, $c3, $fa, $3c, $2f, $e0
    db $01, $3e, $01, $e0, $02, $3e, $81, $e0, $02, $3e, $f0, $c9, $6d, $a0, $ff, $03
    db $d0, $05, $61, $30

; I: leftover: 182 bytes of code CHG_AUTO_SET of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_5B90_CHG_AUTO_SET::
    db $ea, $64, $c1, $3e, $00, $ea, $00, $40, $fa, $fa, $c0, $ea, $d2, $c0, $fa, $fb
    db $c0, $ea, $d3, $c0, $01, $00, $00, $11, $00, $a0, $cd, $4b, $31, $fa, $64, $c1
    db $57, $cb, $21, $cb, $10, $cb, $21, $cb, $10, $cb, $21, $cb, $10, $78, $92, $30
    db $2f, $2f, $3c, $47, $ea, $d1, $c0, $fa, $fa, $c0, $67, $57, $fa, $fb, $c0, $6f
    db $5f, $78, $01, $5f, $39, $81, $4f, $30, $01, $04, $0a, $fe, $00, $28, $07, $cb
    db $3a, $cb, $1b, $3d, $18, $f5, $7a, $2f, $57, $7b, $2f, $5f, $13, $19, $18, $2c
    db $47, $ea, $d1, $c0, $fa, $fa, $c0, $67, $57, $fa, $fb, $c0, $6f, $5f, $78, $fe
    db $00, $c8, $01, $b6, $38, $81, $4f, $30, $01, $04, $0a, $fe, $00, $28, $07, $cb
    db $3a, $cb, $1b, $3d, $18, $f5, $19, $30, $03, $21, $ff, $ff, $7c, $ea, $fa, $c0
    db $7d, $ea, $fb, $c0, $11, $df, $ff, $19, $38, $0a, $3e, $00, $ea, $fa, $c0, $3e
    db $21, $ea, $fb, $c0, $3e, $10, $ea, $00, $40, $fa, $fa, $c0, $ea, $02, $a0, $fa
    db $fb, $c0, $ea, $03, $a0, $c9

; I: leftover: 52 bytes of code LINE_CHECK of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_5C46_LINE_CHECK::
    db $3e, $04, $e0, $88, $cd, $9f, $31, $13, $13, $cd, $9f, $31, $13, $13, $cd, $9f
    db $31, $13, $13, $cd, $9f, $31, $13, $13, $13, $13, $cd, $9f, $31, $13, $13, $cd
    db $9f, $31, $13, $13, $cd, $9f, $31, $13, $13, $cd, $9f, $31, $f0, $88, $3d, $c8
    db $e0, $88, $18, $d0

; I: leftover: 84 bytes of code SCREEN_CHECK of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_5C7A_SCREEN_CHECK::
    db $3e, $1c, $e0, $88, $cd, $9f, $31, $21, $14, $00, $19, $54, $5d, $cd, $9f, $31
    db $21, $14, $00, $19, $54, $5d, $cd, $9f, $31, $21, $04, $00, $19, $54, $5d, $cd
    db $9f, $31, $21, $14, $00, $19, $54, $5d, $cd, $9f, $31, $21, $14, $00, $19, $54
    db $5d, $cd, $9f, $31, $21, $04, $00, $19, $54, $5d, $cd, $9f, $31, $21, $14, $00
    db $19, $54, $5d, $cd, $9f, $31, $21, $04, $00, $19, $54, $5d, $f0, $88, $3d, $c8
    db $e0, $88, $18, $b0

; I: leftover: 25 bytes of code BIT_COUNT of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_5CCE_BIT_COUNT::
    db $26, $3e, $1a, $13, $6f, $6e, $26, $00, $09, $44, $4d, $26, $3e, $1a, $13, $6f
    db $6e, $cb, $25, $26, $00, $09, $44, $4d, $c9

; I: leftover: 374 bytes of code SET_DITH_MATRIX of the bank 0 of an older build (bank $1D); found by its bytes
; (16-bit operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_5CE7_SET_DITH_MATRIX::
    INCBIN "data/bank_1d/Leftover_1D_5CE7_SET_DITH_MATRIX.bin" ; $5CE7, 374 bytes
; I: leftover: 199 bytes of code REGISTER_SETTING of the bank 0 of an older build (bank $1D); found by its bytes
; (16-bit operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_5E5D_REGISTER_SETTING::
    db $47, $e6, $0f, $fe, $00, $28, $1a, $fe, $01, $28, $2c, $fe, $02, $28, $51, $fe
    db $03, $28, $66, $fe, $04, $ca, $d8, $33, $fe, $05, $ca, $d9, $33, $c3, $da, $33
    db $c9, $3e, $02, $ea, $f8, $c0, $3e, $02, $ea, $01, $a0, $ea, $f9, $c0, $3e, $02
    db $ea, $04, $a0, $ea, $fc, $c0, $c9, $3e, $02, $ea, $f8, $c0, $3e, $22, $ea, $f9
    db $c0, $ea, $01, $a0, $78, $e6, $f0, $fe, $00, $28, $0c, $fe, $10, $28, $08, $fe
    db $20, $28, $04, $c6, $06, $18, $02, $c6, $03, $ea, $04, $a0, $ea, $fc, $c0, $c9
    db $3e, $00, $ea, $f8, $c0, $3e, $c2, $ea, $01, $a0, $ea, $f9, $c0, $78, $e6, $f0
    db $c6, $03, $ea, $04, $a0, $ea, $fc, $c0, $c9, $3e, $00, $ea, $f8, $c0, $3e, $e2
    db $ea, $f9, $c0, $ea, $01, $a0, $78, $e6, $f0, $fe, $00, $28, $10, $fe, $10, $28
    db $0c, $fe, $20, $28, $08, $fe, $30, $28, $08, $c6, $06, $18, $06, $c6, $03, $18
    db $02, $c6, $04, $ea, $04, $a0, $ea, $fc, $c0, $c9, $c9, $c9, $3e, $00, $ea, $f8
    db $c0, $3e, $e2, $ea, $01, $a0, $ea, $f9, $c0, $78, $e6, $f0, $c6, $03, $cb, $ff
    db $ea, $04, $a0, $ea, $fc, $c0, $c9

; I: leftover: 28 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_1D_5F24::
    db $3e, $10, $ea, $00, $40, $06, $70, $fa, $f2, $c0, $fe, $06, $20, $02, $06, $55
    db $21, $06, $a0, $11, $30, $00, $70, $1b, $7a, $b3, $20, $fa

; I: leftover: an exact copy of 74 bytes of Sensor_FillDitherFlat (from 00:3751, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_1D_5F40_Sensor_FillDitherFlat_Part3751::
    db $af, $ea, $02, $a0, $3e, $21, $ea, $03, $a0, $fa, $fd, $c0, $e6, $c0, $06, $3f
    db $b0, $ea, $fd, $c0, $ea, $05, $a0, $3e, $10, $ea, $00, $40, $fa, $f8, $c0, $cb
    db $c7, $ea, $00, $a0, $fa, $00, $a0, $cb, $47, $20, $f9, $fa, $f8, $c0, $cb, $c7
    db $ea, $00, $a0, $fa, $00, $a0, $cb, $47, $20, $f9, $3e, $10, $ea, $00, $40, $fa
    db $f8, $c0, $cb, $c7, $ea, $00, $a0, $fa, $00, $a0

; I: leftover: 37 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_1D_5F8A::
    db $1a, $a0, $ff, $03, $d0, $05, $5b, $34, $cb, $47, $20, $f9, $cd, $78, $34, $b7
    db $20, $06, $cd, $98, $34, $b7, $28, $e0, $fa, $fa, $c0, $ea, $02, $a0, $fa, $fb
    db $c0, $ea, $03, $a0, $c9

; I: leftover: 32 bytes of code CHECK_BLACK of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_5FAF_CHECK_BLACK::
    db $af, $ea, $00, $40, $21, $70, $a7, $1e, $10, $2a, $fe, $ff, $20, $0b, $1d, $20
    db $f8, $3e, $10, $ea, $00, $40, $3e, $01, $c9, $3e, $10, $ea, $00, $40, $af, $c9

; I: leftover: 52 bytes of code OFFSET_DOWN of the bank 0 of an older build (bank $1D); found by its bytes (16-bit
; operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_5FCF_OFFSET_DOWN::
    db $fa, $fd, $c0, $cb, $6f, $28, $11, $e6, $3f, $fe, $20, $28, $05, $3d, $06, $00
    db $18, $13, $3e, $01, $06, $00, $18, $0d, $e6, $1f, $fe, $1f, $20, $04, $06, $01
    db $18, $03, $3c, $06, $00, $4f, $fa, $fd, $c0, $e6, $c0, $b1, $ea, $fd, $c0, $ea
    db $05, $a0, $78, $c9

; I: leftover: 100 bytes of code TRANSFER_TO_BUF of the bank 0 of an older build (bank $1D); found by its bytes
; (16-bit operands masked) near its place in bank $2C; code that this build never runs (typed data)
Leftover_1D_6003_TRANSFER_TO_BUF::
    db $e6, $1f, $fe, $0d, $20, $06, $cd, $3e, $20, $c3, $2f, $35, $fe, $10, $20, $06
    db $cd, $1e, $20, $c3, $2f, $35, $fe, $02, $20, $06, $cd, $fa, $20, $c3, $2f, $35
    db $fe, $08, $20, $06, $cd, $97, $22, $c3, $2f, $35, $fe, $09, $20, $06, $cd, $ca
    db $23, $c3, $2f, $35, $fe, $05, $20, $06, $cd, $fa, $24, $c3, $2f, $35, $fe, $06
    db $20, $06, $cd, $7c, $25, $c3, $2f, $35, $fe, $07, $20, $06, $cd, $1b, $26, $c3
    db $2f, $35, $af, $ea, $00, $40, $21, $00, $a1, $11, $00, $d0, $06, $0e, $cd, $e7
    db $26, $18, $00, $c9

; I: leftover: 1014 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_1D_6067::
    db $3e, $20, $1e, $20, $fa, $20, $97, $22, $58, $70, $98, $03, $03, $04, $59, $70
    db $87, $03, $03, $04, $5a, $70, $86, $03, $03, $04, $5b, $70, $85, $03, $03, $04
    db $5c, $70, $84, $03, $03, $04, $5d, $70, $83, $03, $03, $04, $5e, $70, $82, $03
    db $03, $04, $5f, $70, $81, $03, $03, $04, $60, $70, $80, $02, $02, $03, $61, $70
    db $7f, $02, $02, $03, $62, $70, $7e, $02, $02, $03, $63, $70, $7d, $02, $02, $03
    db $64, $70, $7c, $02, $02, $03, $65, $70, $7b, $02, $02, $03, $66, $70, $7a, $02
    db $02, $03, $67, $70, $79, $02, $02, $03, $68, $70, $78, $02, $02, $03, $69, $70
    db $77, $02, $02, $03, $6a, $70, $76, $02, $02, $03, $6b, $70, $75, $02, $02, $03
    db $6c, $70, $74, $02, $02, $03, $6d, $70, $73, $02, $02, $03, $6e, $70, $72, $02
    db $02, $03, $6f, $70, $71, $02, $02, $03, $70, $70, $70, $03, $03, $03, $60, $78
    db $a0, $03, $04, $04, $60, $74, $98, $03, $04, $04, $60, $70, $90, $02, $03, $04
    db $60, $6c, $84, $02, $03, $04, $60, $68, $78, $02, $02, $03, $68, $78, $98, $02
    db $03, $04, $70, $80, $a0, $02, $03, $04, $78, $88, $a8, $02, $03, $04, $80, $90
    db $b0, $02, $03, $04, $40, $60, $a0, $03, $05, $05, $41, $60, $9e, $03, $05, $05
    db $42, $60, $9c, $03, $05, $05, $43, $60, $9a, $03, $05, $05, $44, $60, $98, $03
    db $05, $05, $45, $60, $96, $03, $05, $05, $46, $60, $94, $03, $05, $05, $47, $60
    db $92, $03, $05, $05, $48, $60, $90, $03, $04, $05, $49, $60, $8e, $03, $04, $05
    db $4a, $60, $8c, $03, $04, $05, $4b, $60, $8a, $03, $04, $05, $4c, $60, $88, $03
    db $04, $05, $4d, $60, $86, $03, $04, $05, $4e, $60, $84, $03, $04, $05, $4f, $60
    db $82, $03, $04, $05, $50, $60, $80, $03, $04, $05, $51, $60, $7e, $03, $04, $05
    db $52, $60, $7c, $03, $04, $05, $53, $60, $7a, $03, $04, $05, $54, $60, $78, $03
    db $04, $05, $55, $60, $76, $03, $04, $05, $56, $60, $74, $03, $04, $05, $57, $60
    db $72, $03, $04, $05, $58, $60, $70, $03, $04, $05, $59, $60, $6e, $03, $04, $05
    db $5a, $60, $6c, $03, $04, $05, $5b, $60, $6a, $03, $04, $05, $5c, $60, $68, $03
    db $04, $05, $5d, $60, $66, $03, $04, $05, $5e, $60, $64, $03, $04, $05, $5f, $60
    db $62, $03, $04, $05, $60, $60, $60, $04, $04, $04, $40, $58, $88, $03, $04, $05
    db $41, $58, $86, $03, $04, $05, $42, $58, $84, $03, $04, $05, $43, $58, $82, $03
    db $04, $05, $44, $58, $80, $03, $04, $05, $45, $58, $8e, $03, $04, $05, $46, $58
    db $7c, $03, $04, $05, $47, $58, $7a, $03, $04, $05, $48, $58, $78, $02, $03, $05
    db $49, $58, $76, $02, $03, $05, $4a, $58, $74, $02, $03, $05, $4b, $58, $72, $02
    db $03, $05, $4c, $58, $70, $02, $03, $05, $4d, $58, $6e, $02, $03, $05, $4e, $58
    db $6c, $02, $03, $05, $4f, $58, $6a, $02, $03, $05, $50, $58, $68, $02, $02, $04
    db $51, $58, $66, $02, $02, $04, $52, $58, $64, $02, $02, $04, $53, $58, $62, $02
    db $02, $04, $54, $58, $60, $02, $02, $04, $55, $58, $5e, $02, $02, $04, $56, $58
    db $5c, $02, $02, $04, $57, $58, $5a, $02, $02, $04, $58, $58, $58, $04, $04, $04
    db $40, $58, $a0, $03, $06, $05, $41, $58, $9d, $03, $06, $05, $42, $58, $9a, $03
    db $06, $05, $43, $58, $97, $03, $05, $05, $44, $58, $94, $03, $05, $05, $45, $58
    db $91, $03, $05, $05, $46, $58, $8e, $03, $05, $05, $47, $58, $8b, $03, $05, $05
    db $48, $58, $88, $02, $04, $05, $49, $58, $85, $02, $04, $05, $4a, $58, $82, $02
    db $04, $05, $4b, $58, $7f, $02, $04, $05, $4c, $58, $7c, $02, $04, $05, $4d, $58
    db $79, $02, $04, $05, $4e, $58, $76, $02, $03, $05, $4f, $58, $73, $02, $03, $05
    db $50, $58, $70, $02, $03, $04, $51, $58, $6d, $02, $03, $04, $52, $58, $6a, $02
    db $03, $04, $53, $58, $67, $02, $02, $04, $54, $58, $64, $02, $02, $04, $55, $58
    db $61, $02, $02, $04, $56, $58, $5e, $02, $02, $04, $57, $58, $5b, $02, $02, $04
    db $58, $58, $58, $04, $04, $04, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
    db $08, $08, $08, $08, $08, $08, $00, $08, $02, $0a, $0c, $04, $0e, $06, $03, $0b
    db $01, $09, $0f, $07, $0d, $05, $0a, $04, $06, $08, $0c, $00, $01, $0e, $07, $09
    db $0b, $05, $03, $0f, $0d, $01, $0d, $07, $06, $0c, $08, $01, $00, $05, $09, $02
    db $03, $04, $0e, $0a, $0b, $0f, $0f, $04, $08, $0c, $0b, $00, $01, $05, $07, $03
    db $02, $09, $0e, $0a, $06, $0d, $0c, $04, $08, $0e, $0b, $00, $02, $06, $07, $03
    db $01, $0a, $0f, $09, $05, $95, $a0, $b8, $01, $d0, $05, $55, $38, $0d, $0d, $04
    db $08, $0e, $0a, $00, $01, $07, $06, $03, $02, $0b, $0f, $09, $05, $0c, $0f, $00
    db $0f, $00, $0f, $0f, $0f, $00, $0f, $00, $0f, $00, $00, $00, $00, $00, $08, $00
    db $08, $0f, $00, $08, $0f, $08, $08, $0f, $08, $00, $0f, $08, $00, $08, $0f, $00
    db $00, $00, $00, $0f, $00, $0f, $00, $00, $0f, $00, $00, $0f, $00, $0f, $07, $03
    db $07, $0b, $03, $00, $03, $07, $07, $03, $07, $0b, $0b, $07, $0b, $0f, $08, $08
    db $08, $00, $08, $0f, $08, $00, $08, $08, $08, $00, $00, $00, $00, $00, $10, $07
    db $06, $06, $06, $05, $05, $05, $05, $05, $04, $04, $04, $04, $04, $04, $03, $03
    db $03, $03, $03, $03, $03, $03, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
    db $02, $02, $02, $02, $02, $02, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01

    ; padding
    ds $41, $00

    db $10, $07, $06, $06, $06, $05, $05, $05, $05, $05, $04, $04, $04, $04, $04, $04
    db $03, $03, $03, $03, $03, $03, $03, $03, $02, $02, $02, $02, $02, $02, $02, $02
    db $02, $02, $02, $02, $02, $02, $02, $02, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $dc, $a0, $05, $01, $d0, $05, $00
    db $3d, $00, $80, $40, $c0, $20, $a0, $60, $e0, $10, $90, $50, $d0, $30, $b0, $70
    db $f0, $08, $88, $48, $c8, $28, $a8, $68, $e8, $18, $98, $58, $d8, $38, $b8, $78
    db $f8, $04, $84, $44, $c4, $24, $a4, $64, $e4, $14, $94, $54, $d4, $34, $b4, $74
    db $f4, $0c, $8c, $4c, $cc, $2c, $ac, $6c, $ec, $1c, $9c, $5c, $dc, $3c, $bc, $7c
    db $fc, $02, $82, $42, $c2, $22, $a2, $62, $e2, $12, $92, $52, $d2, $32, $b2, $72
    db $f2, $0a, $8a, $4a, $ca, $2a, $aa, $6a, $ea, $1a, $9a, $5a, $da, $3a, $ba, $7a
    db $fa, $06, $86, $46, $c6, $26, $a6, $66, $e6, $16, $96, $56, $d6, $36, $b6, $76
    db $f6, $0e, $8e, $4e, $ce, $2e, $ae, $6e, $ee, $1e, $9e, $5e, $de, $3e, $be, $7e
    db $fe, $01, $81, $41, $c1, $21, $a1, $61, $e1, $11, $91, $51, $d1, $31, $b1, $71
    db $f1, $09, $89, $49, $c9, $29, $a9, $69, $e9, $19, $99, $59, $d9, $39, $b9, $79
    db $f9, $05, $85, $45, $c5, $25, $a5, $65, $e5, $15, $95, $55, $d5, $35, $b5, $75
    db $f5, $0d, $8d, $4d, $cd, $2d, $ad, $6d, $ed, $1d, $9d, $5d, $dd, $3d, $bd, $7d
    db $fd, $03, $83, $43, $c3, $23, $a3, $63, $e3, $13, $93, $53, $d3, $33, $b3, $73
    db $f3, $0b, $8b, $4b, $cb, $2b, $ab, $6b, $eb, $1b, $9b, $5b, $db, $3b, $bb, $7b
    db $fb, $07, $87, $47, $c7, $27, $a7, $67, $e7, $17, $97, $57, $d7, $37, $b7, $77
    db $f7, $0f, $8f, $4f, $cf, $2f, $af, $6f, $ef, $1f, $9f, $5f, $df, $3f, $bf, $7f
    db $ff, $c8, $a0, $05, $01, $d0, $05, $00, $3e, $00, $01, $01, $02, $01, $02, $02
    db $03, $01, $02, $02, $03, $02, $03, $03, $04, $01, $02, $02, $03, $02, $03, $03
    db $04, $02, $03, $03, $04, $03, $04, $04, $05, $01, $02, $02, $03, $02, $03, $03
    db $04, $02, $03, $03, $04, $03, $04, $04, $05, $02, $03, $03, $04, $03, $04, $04
    db $05, $03, $04, $04, $05, $04, $05, $05, $06, $01, $02, $02, $03, $02, $03, $03
    db $04, $02, $03, $03, $04, $03, $04, $04, $05, $02, $03, $03, $04, $03, $04, $04
    db $05, $03, $04, $04, $05, $04, $05, $05, $06, $02, $03, $03, $04, $03, $04, $04
    db $05, $03, $04, $04, $05, $04, $05, $05, $06, $03, $04, $04, $05, $04, $05, $05
    db $06, $04, $05, $05, $06, $05, $06, $06, $07, $01, $02, $02, $03, $02, $03, $03
    db $04, $02, $03, $03, $04, $03, $04, $04, $05, $02, $03, $03, $04, $03, $04, $04
    db $05, $03, $04, $04, $05, $04, $05, $05, $06, $02, $03, $03, $04, $03, $04, $04
    db $05, $03, $04, $04, $05, $04, $05, $05, $06, $03, $04, $04, $05, $04, $05, $05
    db $06, $04, $05, $05, $06, $05, $06, $06, $07, $02, $03, $03, $04, $03, $04, $04
    db $05, $03, $04, $04, $05, $04, $05, $05, $06, $03, $04, $04, $05, $04, $05, $05
    db $06, $04, $05, $05, $06, $05, $06, $06, $07, $03, $04, $04, $05, $04, $05, $05
    db $06, $04, $05, $05, $06, $05, $06, $06, $07, $04, $05, $05, $06, $05, $06, $06
    db $07, $05, $06, $06, $07, $06, $07, $07, $08, $47, $a0, $06, $00, $d0, $05, $ff
    db $3f, $00, $47, $a0, $06, $00, $d0, $06, $00, $40, $01, $43, $a0, $ff, $03, $d0
    db $06, $01, $40

; I: leftover: an exact copy of 1018 bytes of Gfx_01_4001_FNTOOE1 (from 01:4001, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_1D_6771_Gfx_01_4001_FNTOOE1_Part4001::
    INCBIN "data/bank_1d/Leftover_1D_6771_Gfx_01_4001_FNTOOE1_Part4001.bin" ; $6771, 1018 bytes
; I: leftover: 8 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_1D_6B6B::
    db $7d, $a0, $ff, $03, $d0, $06, $fb, $43

; I: leftover: an exact copy of 1018 bytes of Gfx_01_4001_FNTOOE1 (from 01:43FB, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_1D_6B73_Gfx_01_4001_FNTOOE1_Part43FB::
    INCBIN "data/bank_1d/Leftover_1D_6B73_Gfx_01_4001_FNTOOE1_Part43FB.bin" ; $6B73, 1018 bytes
; I: leftover: 8 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_1D_6F6D::
    db $ac, $a0, $ff, $03, $d0, $06, $f5, $47

; I: leftover: an exact copy of 1018 bytes of Gfx_01_4001_FNTOOE1 (from 01:47F5, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_1D_6F75_Gfx_01_4001_FNTOOE1_Part47F5::
    INCBIN "data/bank_1d/Leftover_1D_6F75_Gfx_01_4001_FNTOOE1_Part47F5.bin" ; $6F75, 1018 bytes
; I: leftover: 8 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_1D_736F::
    db $74, $a0, $ff, $03, $d0, $06, $ef, $4b

; I: leftover: an exact copy of 1018 bytes of Gfx_01_4001_FNTOOE1 (from 01:4BEF, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_1D_7377_Gfx_01_4001_FNTOOE1_Part4BEF::
    INCBIN "data/bank_1d/Leftover_1D_7377_Gfx_01_4001_FNTOOE1_Part4BEF.bin" ; $7377, 1018 bytes
; I: leftover: 8 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_1D_7771::
    db $19, $a0, $ff, $03, $d0, $06, $e9, $4f

; I: leftover: an exact copy of 1018 bytes of Gfx_01_4001_FNTOOE1 (from 01:4FE9, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_1D_7779_Gfx_01_4001_FNTOOE1_Part4FE9::
    INCBIN "data/bank_1d/Leftover_1D_7779_Gfx_01_4001_FNTOOE1_Part4FE9.bin" ; $7779, 1018 bytes
; I: leftover: 8 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_1D_7B73::
    db $dd, $a0, $ff, $03, $d0, $06, $e3, $53

; I: leftover: an exact copy of 1018 bytes of Gfx_01_4001_FNTOOE1 (from 01:53E3, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_1D_7B7B_Gfx_01_4001_FNTOOE1_Part53E3::
    INCBIN "data/bank_1d/Leftover_1D_7B7B_Gfx_01_4001_FNTOOE1_Part53E3.bin" ; $7B7B, 1018 bytes
; I: leftover: 8 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_1D_7F75::
    db $3e, $a0, $29, $00, $d0, $06, $dd, $57

    ; padding
    ds $24, $00

    db $2d, $a0, $45, $02, $d0, $06, $01, $58

; I: leftover: an exact copy of 86 bytes of Map_01_5801_TITLE1 (from 01:5801, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_1D_7FA9_Map_01_5801_TITLE1_Part5801::
    db $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0
    db $a0, $a0, $a0, $a0, $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0
    db $a0, $a0, $a0, $a0, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1a, $1b, $1c, $a0, $a0, $a0, $a0, $a0

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_1D_7FFF::
    db $1d
