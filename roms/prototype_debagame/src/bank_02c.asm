; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $2C. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $02c", ROMX[$4000], BANK[$2c]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_2C_4000::
    db $2c

; I: leftover PC memory: 747 bytes (2C:4001-42EB) that hold 3 x86 function prologues (55 8B EC: push bp / mov bp,sp;
; $EC is no Game Boy opcode), and that nothing in this build reads, runs or explains; only those are proven, the rest
; of the run is taken as the same memory
Leftover_2C_4001_PcRam::
    INCBIN "data/bank_2c/Leftover_2C_4001_PcRam.bin" ; $4001, 747 bytes
; C: leftover: 49 bytes of code INKEY of the bank 0 of an older build (the build of table $2A); address and name from
; symbol table $2A; code that this build never runs (typed data)
Leftover_2C_42EC_INKEY::
    db $3e, $20, $e0, $00, $f0, $00, $f0, $00, $2f, $e6, $0f, $cb, $37, $47, $3e, $10
    db $e0, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $2f, $e6
    db $0f, $b0, $4f, $f0, $80, $a9, $a1, $e0, $81, $79, $e0, $80, $3e, $30, $e0, $00
    db $c9

; C: leftover: 10 bytes of data DMADATA of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; nothing in this build reads it
Leftover_2C_431D_DMADATA::
    db $3e, $c0, $e0, $46, $3e, $40, $3d, $20, $fd, $c9

; C: leftover: 26 bytes of data CLRCHR_SET of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; nothing in this build reads it
Leftover_2C_4327_CLRCHR_SET::
    db $21, $00, $c0, $11, $a5, $ff, $1a, $87, $87, $06, $00, $4f, $09, $1a, $fe, $28
    db $c8, $3c, $12, $af, $22, $22, $22, $22, $18, $f3

; C: leftover: 16 bytes of code VRAM_CLR of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_4341_VRAM_CLR::
    db $21, $00, $98, $3e, $ff, $01, $00, $08, $22, $0d, $20, $fc, $05, $20, $f9, $c9

; C: leftover: 65 bytes of code SIO_INT of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; code that this build never runs (typed data)
Leftover_2C_4351_SIO_INT::
    db $f5, $c5, $d5, $e5, $3e, $80, $e0, $02, $fa, $d7, $c0, $a7, $20, $23, $f0, $01
    db $fe, $00, $28, $12, $fe, $fe, $28, $07, $3e, $fe, $e0, $01, $c3, $8d, $03, $3e
    db $02, $ea, $d7, $c0, $18, $05, $3e, $01, $ea, $d7, $c0, $af, $e0, $01, $ea, $d8
    db $c0, $f0, $01, $ea, $dd, $c0, $3c, $ea, $d8, $c0, $e0, $01, $e1, $d1, $c1, $f1
    db $d9

; C: leftover: 31 bytes of code GAME_INIT of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_4392_GAME_INIT::
    db $cd, $d3, $02, $cd, $41, $03, $cd, $c8, $02, $21, $d0, $c0, $af, $22, $7d, $fe
    db $f0, $20, $f9, $3e, $a0, $ea, $e2, $c0, $af, $ea, $e3, $c0, $ea, $e4, $c0

; C: leftover: 103 bytes of code CAMECO_INIT of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A; code that this build never runs (typed data)
Leftover_2C_43B1_CAMECO_INIT::
    db $3e, $01, $ea, $e9, $c0, $3e, $0a, $ea, $65, $c1, $cd, $b8, $31, $af, $ea, $ea
    db $c0, $3e, $03, $ea, $f2, $c0, $3e, $18, $ea, $fa, $c0, $3e, $00, $ea, $fb, $c0
    db $3e, $a0, $ea, $fd, $c0, $3e, $01, $ea, $61, $c1, $ea, $63, $c1, $3e, $3a, $ea
    db $64, $c1, $af, $ea, $a6, $c0, $ea, $66, $c1, $ea, $68, $c1, $ea, $d0, $c0, $ea
    db $f7, $c0, $ea, $67, $c1, $3e, $15, $ea, $e7, $c0, $cd, $c0, $04, $cd, $34, $04
    db $cd, $19, $04, $cd, $26, $04, $3e, $04, $e0, $4b, $3e, $60, $e0, $4a, $3e, $01
    db $ea, $a0, $c0, $3e, $c7, $e0, $40

; C: leftover: 1 bytes of code INIT_END of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; code that this build never runs (typed data)
Leftover_2C_4418_INIT_END::
    db $c9

; C: leftover: 13 bytes of code OBJP_DEF_SET of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_4419_OBJP_DEF_SET::
    db $3e, $e4, $e0, $48, $e0, $ac, $3e, $e4, $e0, $49, $e0, $ad, $c9

; C: leftover: 2 bytes of code BGP_DEF_SET of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_4426_BGP_DEF_SET::
    db $3e, $e4

; C: leftover: 5 bytes of code BGP_SET of the bank 0 of an older build (the build of table $2A); address and name from
; symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_4428_BGP_SET::
    db $e0, $47, $e0, $ae, $c9

; C: leftover: 7 bytes of code BGP_CHG of the bank 0 of an older build (the build of table $2A); address and name from
; symbol table $2A; code that this build never runs (typed data)
Leftover_2C_442D_BGP_CHG::
    db $f0, $ae, $0f, $cd, $28, $04, $c9

; C: leftover: 15 bytes of code SCYX_SET0 of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_4434_SCYX_SET0::
    db $3e, $00, $e0, $42, $e0, $a1, $e0, $a2, $3e, $00, $e0, $43, $e0, $a0, $c9

; C: leftover: 6 bytes of data SOUND_P of the bank 0 of an older build (the build of table $2A); address and name from
; symbol table $2A; nothing in this build reads it
Leftover_2C_4443_SOUND_P::
    db $3e, $3e, $ea, $60, $dc, $c9

; C: leftover: 6 bytes of data SOUND_PE of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; nothing in this build reads it
Leftover_2C_4449_SOUND_PE::
    db $3e, $3f, $ea, $60, $dc, $c9

; C: leftover: 17 bytes of data MEN_FADE_CLR of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A; nothing in this build reads it
Leftover_2C_444F_MEN_FADE_CLR::
    db $af, $ea, $a1, $c0, $ea, $a2, $c0, $ea, $a3, $c0, $ea, $a4, $c0, $ea, $a5, $c0
    db $c9

; C: leftover: 6 bytes of code MEN_FADE_SET of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_4460_MEN_FADE_SET::
    db $3e, $01, $ea, $a1, $c0, $c9

; C: leftover: 54 bytes of code MEN_FADE of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_4466_MEN_FADE::
    db $fa, $a1, $c0, $a7, $c8, $fa, $a2, $c0, $a7, $28, $07, $3d, $ea, $a2, $c0, $28
    db $25, $c9, $21, $a3, $c0, $34, $7e, $fe, $04, $c0, $36, $00, $f0, $ac, $cd, $a6
    db $04, $e0, $ac, $e0, $48, $f0, $ae, $cd, $a6, $04, $e0, $ae, $e0, $47, $a7, $c0
    db $3e, $05, $ea, $a2, $c0, $c9

; C: leftover: 10 bytes of code MEN_FADE_END of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A; code that this build never runs (typed data)
Leftover_2C_449C_MEN_FADE_END::
    db $af, $ea, $a1, $c0, $3e, $01, $ea, $a4, $c0, $c9

; C: leftover: 26 bytes of code MEN_FADE_DEC of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_44A6_MEN_FADE_DEC::
    db $4f, $1e, $04, $06, $00, $79, $e6, $03, $28, $01, $3d, $b0, $47, $cb, $08, $cb
    db $08, $cb, $09, $cb, $09, $1d, $20, $ed, $78, $c9

; C: leftover: 37 bytes of code TITL_GAMEN of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_44C0_TITL_GAMEN::
    db $21, $01, $40, $11, $00, $80, $01, $00, $18, $cd, $bf, $02, $21, $01, $58, $11
    db $00, $98, $01, $40, $02, $cd, $bf, $02, $21, $e5, $04, $11, $00, $c0, $01, $10
    db $00, $cd, $bf, $02, $c9

; C: leftover: 16 bytes of data TITLE_OBJ of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; nothing in this build reads it
Leftover_2C_44E5_TITLE_OBJ::
    db $60, $4c, $10, $00, $60, $54, $12, $00, $60, $5c, $14, $00, $60, $64, $16, $00

; C: leftover: 84 bytes of code GAME_TITL of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_44F5_GAME_TITL::
    db $fa, $a6, $c0, $3c, $ea, $a6, $c0, $fe, $08, $28, $1e, $fe, $10, $20, $2e, $3e
    db $10, $ea, $02, $c0, $3e, $12, $ea, $06, $c0, $3e, $14, $ea, $0a, $c0, $3e, $16
    db $ea, $0e, $c0, $af, $ea, $a6, $c0, $18, $14, $3e, $18, $ea, $02, $c0, $3e, $1a
    db $ea, $06, $c0, $3e, $1c, $ea, $0a, $c0, $3e, $1e, $ea, $0e, $c0, $f0, $81, $e6
    db $0f, $c4, $60, $04, $cd, $66, $04, $fa, $a4, $c0, $a7, $28, $07, $af, $ea, $bd
    db $c0, $cd, $4a, $05

; C: leftover: 1 bytes of code TITL_END of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; code that this build never runs (typed data)
Leftover_2C_4549_TITL_END::
    db $c9

; C: leftover: 43 bytes of code MAKE_MENU of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_454A_MAKE_MENU::
    db $cd, $d3, $02, $cd, $41, $03, $cd, $c8, $02, $f0, $fd, $f5, $3e, $01, $e0, $fd
    db $ea, $00, $21, $21, $01, $40, $11, $00, $80, $01, $00, $18, $cd, $bf, $02, $21
    db $41, $5a, $11, $00, $98, $01, $40, $02, $cd, $bf, $02

; C: leftover: 58 bytes of code WANKO of the bank 0 of an older build (the build of table $2A); address and name from
; symbol table $2A; code that this build never runs (typed data)
Leftover_2C_4575_WANKO::
    db $fa, $bd, $c0, $47, $3e, $34, $e0, $88, $78, $b7, $28, $08, $3d, $47, $f0, $88
    db $c6, $10, $18, $f2, $21, $00, $c0, $f0, $88, $22, $3e, $1e, $22, $3e, $04, $22
    db $af, $22, $f0, $88, $22, $3e, $26, $22, $3e, $06, $22, $af, $22, $cd, $34, $04
    db $cd, $19, $04, $cd, $26, $04, $3e, $c7, $e0, $40

; C: leftover: 12 bytes of code MKMENU_END of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; code that this build never runs (typed data)
Leftover_2C_45AF_MKMENU_END::
    db $3e, $02, $ea, $a0, $c0, $f1, $e0, $fd, $ea, $00, $21, $c9

; C: leftover: 166 bytes of code MAIN_MENU of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_45BB_MAIN_MENU::
    db $f0, $81, $cb, $27, $da, $30, $06, $cb, $27, $da, $3f, $06, $cb, $27, $cb, $27
    db $cb, $27, $cb, $27, $cb, $27, $cb, $27, $38, $06, $cd, $61, $06, $c3, $60, $06
    db $3e, $08, $ea, $02, $c0, $3e, $0a, $ea, $06, $c0, $3e, $08, $e0, $a5, $af, $ea
    db $bd, $c0, $3e, $20, $e0, $88, $f0, $88, $b7, $28, $17, $3d, $e0, $88, $cd, $61
    db $06, $f6, $ff, $e0, $a9, $76, $f0, $85, $a7, $28, $fa, $af, $e0, $85, $e0, $a9
    db $18, $e4, $fa, $00, $c0, $fe, $34, $cc, $86, $07, $fe, $44, $cc, $aa, $06, $fe
    db $54, $cc, $7f, $19, $fe, $64, $cc, $a5, $0e, $fe, $74, $cc, $33, $1d, $fe, $84
    db $cc, $ed, $29, $18, $30, $fa, $00, $c0, $fe, $84, $20, $04, $d6, $50, $18, $11
    db $c6, $10, $18, $0d, $fa, $00, $c0, $fe, $34, $20, $04, $c6, $50, $18, $02, $d6
    db $10, $ea, $00, $c0, $ea, $04, $c0, $3e, $00, $ea, $02, $c0, $3e, $02, $ea, $06
    db $c0, $3e, $18, $e0, $a5, $c9

; C: leftover: 70 bytes of code DOG_ANIME of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_4661_DOG_ANIME::
    db $f0, $a5, $a7, $20, $2f, $f0, $a6, $a7, $20, $05, $3e, $21, $e0, $a6, $c9, $21
    db $a6, $ff, $35, $f0, $a6, $fe, $20, $28, $05, $fe, $10, $28, $0c, $c9, $3e, $04
    db $ea, $02, $c0, $3e, $06, $ea, $06, $c0, $c9, $3e, $0c, $ea, $02, $c0, $3e, $0e
    db $ea, $06, $c0, $c9, $3d, $e0, $a5, $b7, $28, $01, $c9, $3e, $04, $ea, $02, $c0
    db $3e, $06, $ea, $06, $c0, $c9

; C: leftover: 1 bytes of code DEBA_BROWSE of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; code that this build never runs (typed data)
Leftover_2C_46A7_DEBA_BROWSE::
    db $c9

; C: leftover: 1 bytes of code VBLK_TITL of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; code that this build never runs (typed data)
Leftover_2C_46A8_VBLK_TITL::
    db $c9

; C: leftover: 1 bytes of code VBLK_MAIN of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; code that this build never runs (typed data)
Leftover_2C_46A9_VBLK_MAIN::
    db $c9

; C: leftover: 9 bytes of code MAKE_BANK of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_46AA_MAKE_BANK::
    db $cd, $d3, $02, $cd, $41, $03, $cd, $c8, $02

; C: leftover: 53 bytes of code CB2 of the bank 0 of an older build (the build of table $2A); address and name from
; symbol table $2A; code that this build never runs (typed data)
Leftover_2C_46B3_CB2::
    db $f0, $fd, $f5, $3e, $02, $e0, $fd, $ea, $00, $21, $21, $01, $40, $11, $00, $80
    db $01, $00, $18, $cd, $bf, $02, $21, $01, $58, $11, $00, $98, $01, $40, $02, $cd
    db $bf, $02, $3e, $c7, $e0, $40, $3e, $03, $ea, $a0, $c0, $af, $e0, $88, $f1, $e0
    db $fd, $ea, $00, $21, $c9

; C: leftover: 85 bytes of code BANK_TEST of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_46E8_BANK_TEST::
    db $f0, $81, $cb, $3f, $cb, $3f, $38, $02, $18, $09, $3e, $01, $ea, $bd, $c0, $cd
    db $4a, $05, $c9, $f0, $88, $b7, $c0, $16, $01, $7a, $ea, $00, $20, $fa, $00, $40
    db $ba, $20, $0e, $fa, $ff, $7f, $ba, $20, $08, $7a, $fe, $3f, $28, $16, $14, $18
    db $e8, $cd, $d3, $02, $3e, $ce, $ea, $cc, $98, $3e, $c7, $ea, $cd, $98, $3e, $c1
    db $e0, $40, $18, $11, $cd, $d3, $02, $3e, $cf, $ea, $cc, $98, $3e, $cb, $ea, $cd
    db $98, $3e, $c1, $e0, $40

; C: leftover: 72 bytes of code TEST4M of the bank 0 of an older build (the build of table $2A); address and name from
; symbol table $2A; code that this build never runs (typed data)
Leftover_2C_473D_TEST4M::
    db $16, $01, $0e, $01, $7a, $ea, $00, $20, $fa, $00, $40, $b9, $20, $12, $fa, $ff
    db $7f, $b9, $20, $0c, $7a, $fe, $3f, $28, $1a, $14, $7a, $e6, $1f, $4f, $18, $e4
    db $cd, $d3, $02, $3e, $ce, $ea, $0c, $99, $3e, $c7, $ea, $0d, $99, $3e, $c1, $e0
    db $40, $18, $11, $cd, $d3, $02, $3e, $cf, $ea, $0c, $99, $3e, $cb, $ea, $0d, $99
    db $3e, $c1, $e0, $40, $3e, $ff, $e0, $88

; C: leftover: 1 bytes of code B_T_END of the bank 0 of an older build (the build of table $2A); address and name from
; symbol table $2A; code that this build never runs (typed data)
Leftover_2C_4785_B_T_END::
    db $c9

; C: leftover: 105 bytes of code MK_SRAM_MENU of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_4786_MK_SRAM_MENU::
    db $cd, $d3, $02, $cd, $41, $03, $cd, $c8, $02, $3e, $02, $ea, $00, $20, $21, $01
    db $40, $11, $00, $80, $01, $00, $18, $cd, $bf, $02, $21, $41, $5a, $11, $00, $98
    db $01, $40, $02, $cd, $bf, $02, $fa, $bd, $c0, $47, $3e, $3c, $e0, $88, $78, $b7
    db $28, $08, $3d, $47, $f0, $88, $c6, $10, $18, $f2, $21, $00, $c0, $f0, $88, $22
    db $3e, $2e, $22, $af, $22, $22, $f0, $88, $22, $3e, $36, $22, $3e, $02, $22, $af
    db $22, $e0, $a6, $ea, $d9, $c0, $cd, $34, $04, $cd, $19, $04, $cd, $26, $04, $3e
    db $c7, $e0, $40, $3e, $04, $ea, $a0, $c0, $c9

; C: leftover: 122 bytes of code SRAM_MENU of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_47EF_SRAM_MENU::
    db $f0, $81, $cb, $27, $38, $4d, $cb, $27, $38, $58, $cb, $27, $cb, $27, $cb, $27
    db $cb, $27, $cb, $27, $38, $09, $cb, $27, $38, $0e, $cd, $eb, $09, $18, $5a, $af
    db $ea, $bd, $c0, $cd, $4a, $05, $18, $51, $af, $ea, $d9, $c0, $fa, $00, $c0, $fe
    db $3c, $20, $05, $cd, $b8, $08, $18, $19, $fe, $4c, $20, $05, $cd, $00, $09, $18
    db $10, $fe, $5c, $20, $09, $3e, $35, $e0, $88, $cd, $38, $09, $18, $03, $cd, $41
    db $0d, $18, $26, $fa, $00, $c0, $fe, $6c, $20, $04, $d6, $30, $18, $11, $c6, $10
    db $18, $0d, $fa, $00, $c0, $fe, $3c, $20, $04, $c6, $30, $18, $02, $d6, $10, $ea
    db $00, $c0, $ea, $04, $c0, $af, $ea, $d9, $c0, $c9

; C: leftover: 78 bytes of code VB_SRAM_MENU of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_4869_VB_SRAM_MENU::
    db $fa, $d9, $c0, $b7, $20, $13, $3e, $a0, $ea, $ce, $98, $ea, $cf, $98, $ea, $0d
    db $99, $ea, $0e, $99, $ea, $0f, $99, $18, $35, $fe, $01, $20, $0c, $3e, $cf, $ea
    db $ce, $98, $3e, $cb, $ea, $cf, $98, $18, $25, $fe, $02, $20, $0c, $3e, $ce, $ea
    db $ce, $98, $3e, $c7, $ea, $cf, $98, $18, $15, $fe, $03, $20, $11, $3e, $38, $ea
    db $0d, $99, $3e, $39, $ea, $0e, $99, $3e, $3a, $ea, $0f, $99, $18, $00

; C: leftover: 1 bytes of code SRAM_VB_END of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; code that this build never runs (typed data)
Leftover_2C_48B7_SRAM_VB_END::
    db $c9

; C: leftover: 72 bytes of code SRAM_VERIFY of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_48B8_SRAM_VERIFY::
    db $16, $00, $01, $aa, $55, $3e, $01, $ea, $00, $60, $f6, $ff, $e0, $a9, $f0, $85
    db $a7, $28, $fb, $af, $e0, $85, $e0, $a9, $21, $00, $a0, $7a, $ea, $00, $40, $2a
    db $b8, $20, $1f, $2a, $b9, $20, $1b, $0d, $79, $fe, $ff, $20, $01, $05, $7c, $fe
    db $c0, $20, $ec, $7a, $fe, $0f, $28, $03, $14, $18, $cf, $3e, $01, $ea, $d9, $c0
    db $fb, $c9, $3e, $02, $ea, $d9, $c0, $c9

; C: leftover: 56 bytes of code SRAM_WRITE of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_4900_SRAM_WRITE::
    db $16, $00, $01, $aa, $55, $f6, $ff, $e0, $a9, $f0, $85, $a7, $28, $fb, $af, $e0
    db $85, $e0, $a9, $21, $00, $a0, $7a, $ea, $00, $40, $78, $22, $79, $22, $0d, $79
    db $fe, $ff, $20, $01, $05, $7c, $fe, $c0, $20, $f0, $7a, $fe, $0f, $28, $03, $14
    db $18, $d3, $3e, $03, $ea, $d9, $c0, $c9

; C: leftover: 93 bytes of code MK_SRAM_DATA of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_4938_MK_SRAM_DATA::
    db $cd, $d3, $02, $cd, $41, $03, $cd, $c8, $02, $f0, $fd, $f5, $3e, $02, $e0, $fd
    db $ea, $00, $21, $21, $01, $40, $11, $00, $80, $01, $00, $18, $cd, $bf, $02, $21
    db $81, $5c, $11, $00, $98, $01, $40, $02, $cd, $bf, $02, $21, $00, $c0, $f0, $88
    db $22, $3e, $1e, $22, $af, $22, $22, $f0, $88, $22, $3e, $26, $22, $3e, $02, $22
    db $af, $22, $e0, $a6, $cd, $34, $04, $cd, $19, $04, $cd, $26, $04, $3e, $c7, $e0
    db $40, $3e, $05, $ea, $a0, $c0, $f1, $e0, $fd, $ea, $00, $21, $c9

; C: leftover: 86 bytes of code SRAM_DATA_SEL of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_4995_SRAM_DATA_SEL::
    db $f0, $81, $cb, $27, $38, $2d, $cb, $27, $38, $38, $cb, $27, $cb, $27, $cb, $27
    db $cb, $27, $cb, $27, $38, $09, $cb, $27, $38, $0f, $cd, $eb, $09, $18, $36, $3e
    db $02, $ea, $bd, $c0, $cd, $86, $07, $18, $2c, $fa, $00, $c0, $e0, $88, $cd, $6f
    db $0a, $18, $22, $fa, $00, $c0, $fe, $75, $20, $04, $d6, $40, $18, $11, $c6, $10
    db $18, $0d, $fa, $00, $c0, $fe, $35, $20, $04, $c6, $40, $18, $02, $d6, $10, $ea
    db $00, $c0, $ea, $04, $c0, $c9

; C: leftover: 132 bytes of code KAO_ANIME of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_49EB_KAO_ANIME::
    db $f0, $a6, $3c, $fe, $40, $20, $01, $af, $e0, $a6, $fe, $00, $20, $0d, $0e, $00
    db $16, $02, $af, $ea, $03, $c0, $ea, $07, $c0, $18, $60, $fe, $04, $20, $06, $0e
    db $04, $16, $06, $18, $56, $fe, $08, $20, $06, $0e, $08, $16, $0a, $18, $4c, $fe
    db $0c, $20, $06, $0e, $0c, $16, $0e, $18, $42, $fe, $10, $20, $06, $0e, $10, $16
    db $12, $18, $38, $fe, $14, $20, $06, $0e, $14, $16, $16, $18, $2e, $fe, $30, $20
    db $0e, $0e, $12, $16, $10, $3e, $20, $ea, $03, $c0, $ea, $07, $c0, $18, $1c, $fe
    db $34, $20, $06, $0e, $0e, $16, $0c, $18, $12, $fe, $38, $20, $06, $0e, $0a, $16
    db $08, $18, $08, $fe, $3c, $20, $0c, $0e, $06, $16, $04, $79, $ea, $02, $c0, $7a
    db $ea, $06, $c0, $c9

; C: leftover: 95 bytes of code MK_SRAM_AGING of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_4A6F_MK_SRAM_AGING::
    db $cd, $d3, $02, $cd, $41, $03, $cd, $c8, $02, $f0, $fd, $f5, $3e, $02, $e0, $fd
    db $ea, $00, $21, $21, $01, $40, $11, $00, $80, $01, $00, $18, $cd, $bf, $02, $21
    db $c1, $5e, $11, $00, $98, $01, $40, $02, $cd, $bf, $02, $01, $a7, $98, $f0, $88
    db $fe, $35, $20, $05, $21, $10, $0b, $18, $26, $fe, $45, $20, $05, $21, $1b, $0b
    db $18, $1d, $fe, $55, $20, $05, $21, $26, $0b, $18, $14, $fe, $65, $20, $05, $21
    db $31, $0b, $18, $0b, $fe, $75, $20, $05, $21, $3c, $0b, $18, $02, $18, $0a

; C: leftover: 10 bytes of code PAT_SET of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; code that this build never runs (typed data)
Leftover_2C_4ACE_PAT_SET::
    db $16, $0b, $2a, $02, $03, $15, $7a, $b7, $20, $f8

; C: leftover: 56 bytes of code PAT_END of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; code that this build never runs (typed data)
Leftover_2C_4AD8_PAT_END::
    db $cd, $34, $04, $cd, $19, $04, $cd, $26, $04, $0e, $00, $06, $aa, $21, $00, $9c
    db $78, $22, $0c, $79, $b7, $20, $f9, $af, $e0, $4b, $3e, $50, $e0, $4a, $3e, $e7
    db $e0, $40, $3e, $07, $ea, $a0, $c0, $af, $ea, $db, $c0, $ea, $da, $c0, $ea, $e1
    db $c0, $f1, $e0, $fd, $ea, $00, $21, $c9

; C: leftover: 11 bytes of data PAT_DEC of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; nothing in this build reads it
Leftover_2C_4B10_PAT_DEC::
    db $c4, $c5, $c3, $d2, $c5, $cd, $c5, $ce, $d4, $a0, $a0

; C: leftover: 11 bytes of data PAT_0F of the bank 0 of an older build (the build of table $2A); address and name from
; symbol table $2A; nothing in this build reads it
Leftover_2C_4B1B_PAT_0F::
    db $80, $80, $ab, $80, $80, $ab, $8f, $8f, $ab, $8f, $8f

; C: leftover: 11 bytes of data PAT_5A of the bank 0 of an older build (the build of table $2A); address and name from
; symbol table $2A; nothing in this build reads it
Leftover_2C_4B26_PAT_5A::
    db $85, $85, $ab, $85, $85, $ab, $8a, $8a, $ab, $8a, $8a

; C: leftover: 11 bytes of data PAT_00 of the bank 0 of an older build (the build of table $2A); address and name from
; symbol table $2A; nothing in this build reads it
Leftover_2C_4B31_PAT_00::
    db $c1, $cc, $cc, $a0, $80, $80, $a0, $a0, $a0, $a0, $a0

; C: leftover: 11 bytes of data PAT_FF of the bank 0 of an older build (the build of table $2A); address and name from
; symbol table $2A; nothing in this build reads it
Leftover_2C_4B3C_PAT_FF::
    db $c1, $cc, $cc, $a0, $8f, $8f, $a0, $a0, $a0, $a0, $a0

; C: leftover: 148 bytes of code SRAM_AGING of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_4B47_SRAM_AGING::
    db $f0, $81, $cb, $3f, $cb, $3f, $38, $02, $18, $04, $cd, $38, $09, $c9, $fa, $e1
    db $c0, $b7, $c0, $f0, $88, $fe, $35, $20, $05, $cd, $db, $0b, $18, $34, $fe, $45
    db $20, $09, $06, $00, $0e, $ff, $cd, $56, $0c, $18, $27, $fe, $55, $20, $09, $06
    db $55, $0e, $aa, $cd, $56, $0c, $18, $1a, $fe, $65, $20, $09, $06, $00, $0e, $00
    db $cd, $56, $0c, $18, $0d, $fe, $75, $20, $09, $06, $ff, $0e, $ff, $cd, $56, $0c
    db $18, $00, $fa, $e1, $c0, $b7, $20, $3b, $fa, $db, $c0, $67, $fa, $da, $c0, $6f
    db $23, $7c, $ea, $db, $c0, $7d, $ea, $da, $c0, $06, $5a, $16, $00, $3e, $01, $ea
    db $00, $60, $21, $00, $a0, $7a, $ea, $00, $40, $78, $22, $22, $22, $22, $22, $22
    db $22, $22, $7d, $b7, $20, $f3, $7c, $fe, $c0, $20, $ee, $7a, $fe, $0f, $28, $03
    db $14, $18, $df, $c9

; C: leftover: 123 bytes of code AGE_DEC of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_4BDB_AGE_DEC::
    db $16, $00, $01, $aa, $55, $3e, $01, $ea, $00, $60, $21, $00, $a0, $7a, $ea, $00
    db $40, $78, $22, $79, $22, $0d, $79, $fe, $ff, $20, $01, $05, $7d, $b7, $20, $f1
    db $7c, $fe, $c0, $20, $ec, $7a, $fe, $0f, $28, $03, $14, $18, $dd, $16, $00, $01
    db $aa, $55, $21, $00, $a0, $7a, $ea, $00, $40, $2a, $b8, $20, $1e, $2a, $b9, $20
    db $23, $0d, $79, $fe, $ff, $20, $01, $05, $7d, $b7, $20, $ed, $7c, $fe, $c0, $20
    db $e8, $7a, $fe, $0f, $28, $03, $14, $18, $d9, $fb, $c9, $ea, $dc, $c0, $78, $ea
    db $dd, $c0, $18, $07, $ea, $dc, $c0, $79, $ea, $dd, $c0, $7a, $ea, $de, $c0, $2b
    db $7c, $ea, $df, $c0, $7d, $ea, $e0, $c0, $c3, $c7, $0c

; C: leftover: 113 bytes of code AGE_OTHER of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_4C56_AGE_OTHER::
    db $16, $00, $3e, $01, $ea, $00, $60, $21, $00, $a0, $7a, $ea, $00, $40, $78, $22
    db $22, $79, $22, $22, $7d, $b7, $20, $f6, $7c, $fe, $c0, $20, $f1, $7a, $fe, $0f
    db $28, $03, $14, $18, $e2, $16, $00, $21, $00, $a0, $7a, $ea, $00, $40, $2a, $b8
    db $20, $1e, $2a, $b8, $20, $1a, $2a, $b9, $20, $1f, $2a, $b9, $20, $1b, $7d, $b7
    db $20, $ec, $7c, $fe, $c0, $20, $e7, $7a, $fe, $0f, $28, $03, $14, $18, $d8, $c9
    db $ea, $dc, $c0, $78, $ea, $dd, $c0, $18, $07, $ea, $dc, $c0, $79, $ea, $dd, $c0
    db $7a, $ea, $de, $c0, $2b, $7c, $ea, $df, $c0, $7d, $ea, $e0, $c0, $c3, $c7, $0c
    db $c9

; C: leftover: 55 bytes of code AGING_ERROR of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_4CC7_AGING_ERROR::
    db $cd, $d3, $02, $21, $c3, $99, $fa, $de, $c0, $47, $cd, $fe, $0c, $23, $fa, $df
    db $c0, $47, $cd, $fe, $0c, $fa, $e0, $c0, $47, $cd, $fe, $0c, $23, $23, $fa, $dd
    db $c0, $47, $cd, $fe, $0c, $23, $fa, $dc, $c0, $47, $cd, $fe, $0c, $3e, $c7, $e0
    db $40, $3e, $ff, $ea, $e1, $c0, $c9

; C: leftover: 19 bytes of code PUT_BYTE of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_4CFE_PUT_BYTE::
    db $78, $cb, $3f, $cb, $3f, $cb, $3f, $cb, $3f, $c6, $80, $22, $78, $e6, $0f, $c6
    db $80, $22, $c9

; C: leftover: 48 bytes of code VB_SRAM_AGING of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_4D11_VB_SRAM_AGING::
    db $21, $e8, $98, $fa, $db, $c0, $cb, $3f, $cb, $3f, $cb, $3f, $cb, $3f, $c6, $80
    db $22, $fa, $db, $c0, $e6, $0f, $c6, $80, $22, $fa, $da, $c0, $cb, $3f, $cb, $3f
    db $cb, $3f, $cb, $3f, $c6, $80, $22, $fa, $da, $c0, $e6, $0f, $c6, $80, $22, $c9

; C: leftover: 71 bytes of code MK_SRAM_DUMP of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_4D41_MK_SRAM_DUMP::
    db $cd, $d3, $02, $cd, $41, $03, $cd, $c8, $02, $f0, $fd, $f5, $3e, $02, $e0, $fd
    db $ea, $00, $21, $21, $01, $40, $11, $00, $80, $01, $00, $18, $cd, $bf, $02, $21
    db $01, $61, $11, $00, $98, $01, $40, $02, $cd, $bf, $02, $cd, $34, $04, $cd, $19
    db $04, $cd, $26, $04, $3e, $c7, $e0, $40, $3e, $08, $ea, $a0, $c0, $f1, $e0, $fd
    db $ea, $00, $21, $cd, $55, $0e, $c9

; C: leftover: 167 bytes of code SRAM_DUMP of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_4D88_SRAM_DUMP::
    db $f0, $81, $cb, $27, $38, $24, $cb, $27, $38, $4b, $cb, $27, $38, $72, $cb, $27
    db $da, $1b, $0e, $cb, $27, $cb, $27, $cb, $27, $38, $05, $cb, $27, $c3, $2e, $0e
    db $3e, $03, $ea, $bd, $c0, $cd, $86, $07, $18, $7c, $fa, $e2, $c0, $67, $fa, $e3
    db $c0, $6f, $7c, $fe, $bf, $20, $0d, $7d, $fe, $80, $20, $08, $3e, $a0, $67, $3e
    db $00, $6f, $18, $04, $01, $80, $00, $09, $7c, $ea, $e2, $c0, $7d, $ea, $e3, $c0
    db $cd, $55, $0e, $18, $51, $fa, $e2, $c0, $67, $fa, $e3, $c0, $6f, $7c, $fe, $a0
    db $20, $0d, $7d, $fe, $00, $20, $08, $3e, $bf, $67, $3e, $80, $6f, $18, $04, $01
    db $80, $ff, $09, $7c, $ea, $e2, $c0, $7d, $ea, $e3, $c0, $cd, $55, $0e, $18, $26
    db $fa, $e4, $c0, $b7, $20, $04, $3e, $0f, $18, $01, $3d, $ea, $e4, $c0, $cd, $55
    db $0e, $18, $13, $fa, $e4, $c0, $fe, $0f, $20, $03, $af, $18, $01, $3c, $ea, $e4
    db $c0, $cd, $55, $0e, $18, $00, $c9

; C: leftover: 19 bytes of code PUT_BYTE2 of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_4E2F_PUT_BYTE2::
    db $78, $cb, $3f, $cb, $3f, $cb, $3f, $cb, $3f, $c6, $50, $22, $78, $e6, $0f, $c6
    db $50, $22, $c9

; C: leftover: 19 bytes of code PUT_BYTE3 of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_4E42_PUT_BYTE3::
    db $78, $cb, $3f, $cb, $3f, $cb, $3f, $cb, $3f, $c6, $60, $22, $78, $e6, $0f, $c6
    db $70, $22, $c9

; C: leftover: 80 bytes of code DUMP_1MEN of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_4E55_DUMP_1MEN::
    db $cd, $d3, $02, $fa, $e4, $c0, $47, $21, $11, $98, $cd, $fe, $0c, $fa, $e2, $c0
    db $57, $fa, $e3, $c0, $5f, $21, $40, $98, $fa, $e4, $c0, $ea, $00, $40, $3e, $10
    db $e0, $89, $42, $cd, $2f, $0e, $43, $cd, $2f, $0e, $0e, $08, $1a, $47, $cd, $42
    db $0e, $13, $0d, $79, $b7, $20, $f5, $23, $23, $23, $23, $23, $23, $23, $23, $23
    db $23, $23, $23, $f0, $89, $3d, $e0, $89, $b7, $20, $d7, $3e, $c7, $e0, $40, $c9

; C: leftover: 107 bytes of code MAKE_MOVIE of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_4EA5_MAKE_MOVIE::
    db $cd, $d3, $02, $cd, $41, $03, $cd, $c8, $02, $af, $ea, $e5, $c0, $f0, $fd, $f5
    db $3e, $03, $e0, $fd, $ea, $00, $21, $21, $01, $40, $11, $00, $80, $01, $00, $18
    db $cd, $bf, $02, $21, $01, $58, $11, $00, $98, $01, $40, $02, $cd, $bf, $02, $fa
    db $64, $c1, $cd, $4f, $11, $fa, $65, $c1, $cd, $6e, $11, $fa, $67, $c1, $cd, $90
    db $11, $fa, $d1, $c0, $cd, $b2, $11, $f1, $e0, $fd, $ea, $00, $21, $cd, $34, $04
    db $cd, $19, $04, $cd, $26, $04, $21, $c4, $c0, $af, $22, $3e, $88, $77, $21, $c6
    db $c0, $af, $22, $3e, $d0, $22, $3e, $10, $ea, $00, $40

; C: leftover: 102 bytes of code PARA_SET of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; code that this build never runs (typed data)
Leftover_2C_4F10_PARA_SET::
    db $fa, $f2, $c0, $cd, $2e, $33, $cd, $f5, $33, $3e, $10, $ea, $00, $40, $fa, $e9
    db $c0, $47, $fa, $65, $c1, $4f, $cd, $b8, $31, $3e, $10, $ea, $00, $40, $fa, $f8
    db $c0, $f6, $01, $ea, $00, $a0, $fa, $00, $a0, $e6, $01, $20, $f9, $fa, $f8, $c0
    db $f6, $01, $ea, $00, $a0, $fa, $00, $a0, $e6, $01, $20, $f9, $fa, $f8, $c0, $f6
    db $01, $ea, $00, $a0, $cd, $9a, $10, $3e, $e4, $e0, $47, $3e, $01, $ea, $c9, $c0
    db $3e, $01, $e0, $ff, $3e, $06, $ea, $a0, $c0, $af, $ea, $c2, $c0, $3e, $08, $e0
    db $41, $3e, $c3, $e0, $40, $c9

; C: leftover: 292 bytes of code MOVIE_MODE of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_4F76_MOVIE_MODE::
    INCBIN "data/bank_2c/Leftover_2C_4F76_MOVIE_MODE.bin" ; $4F76, 292 bytes
; C: leftover: 49 bytes of code GET_A_IMMAGE of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_509A_GET_A_IMMAGE::
    db $f3, $3e, $10, $ea, $00, $40, $fa, $00, $a0, $e6, $01, $20, $f9, $fa, $64, $c1
    db $cd, $61, $30, $fa, $67, $c1, $cd, $cc, $34, $3e, $10, $ea, $00, $40, $fa, $f8
    db $c0, $f6, $01, $ea, $00, $a0, $fa, $f7, $c0, $cd, $cb, $10, $fb, $cd, $64, $12
    db $c9

; C: leftover: 97 bytes of code CHANGE_PALETTE of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_50CB_CHANGE_PALETTE::
    db $21, $00, $d0, $fe, $00, $c8, $fe, $01, $28, $11, $fe, $02, $28, $19, $fe, $03
    db $28, $23, $fe, $04, $28, $2e, $fe, $05, $28, $3a, $c9, $11, $00, $0e, $7e, $2f
    db $22, $1b, $7a, $b3, $20, $f8, $c9, $11, $00, $07, $2a, $46, $a8, $2f, $22, $1b
    db $7a, $b3, $20, $f6, $c9, $11, $00, $07, $2a, $46, $2b, $70, $23, $22, $1b, $7a
    db $b3, $20, $f5, $c9, $11, $00, $07, $7e, $4f, $2f, $22, $7e, $a9, $22, $1b, $7a
    db $b3, $20, $f4, $c9, $11, $00, $07, $2a, $46, $a8, $22, $1b, $7a, $b3, $20, $f7
    db $c9

; C: leftover: 35 bytes of data PUT_BYTE_OBJ of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A; nothing in this build reads it
Leftover_2C_512C_PUT_BYTE_OBJ::
    db $47, $21, $14, $c0, $3e, $10, $22, $3e, $30, $22, $78, $cb, $3f, $cb, $3f, $cb
    db $3f, $cb, $3f, $22, $af, $22, $3e, $10, $22, $3e, $38, $22, $78, $e6, $0f, $22
    db $af, $22, $c9

; C: leftover: 31 bytes of code AKARUSA_HYOUJI of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_514F_AKARUSA_HYOUJI::
    db $47, $21, $1c, $c0, $3e, $10, $22, $3e, $0c, $22, $78, $cb, $37, $e6, $0f, $22
    db $af, $22, $3e, $10, $22, $3e, $14, $22, $78, $e6, $0f, $22, $af, $22, $c9

; C: leftover: 34 bytes of code CONTRAST_HYOUJI of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_516E_CONTRAST_HYOUJI::
    db $47, $21, $24, $c0, $3e, $95, $22, $3e, $58, $22, $78, $cb, $37, $e6, $0f, $22
    db $af, $22, $21, $44, $c0, $3e, $95, $22, $3e, $60, $22, $78, $e6, $0f, $22, $af
    db $22, $c9

; C: leftover: 34 bytes of code BUNKATU_HYOUJI of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_5190_BUNKATU_HYOUJI::
    db $47, $21, $28, $c0, $3e, $10, $22, $3e, $90, $22, $78, $cb, $37, $e6, $0f, $22
    db $af, $22, $21, $48, $c0, $3e, $10, $22, $3e, $98, $22, $78, $e6, $0f, $22, $af
    db $77, $c9

; C: leftover: 92 bytes of code TEST_HYOUJI of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_51B2_TEST_HYOUJI::
    db $47, $21, $2c, $c0, $3e, $10, $22, $3e, $30, $22, $78, $cb, $37, $e6, $0f, $22
    db $af, $22, $3e, $10, $22, $3e, $38, $22, $78, $e6, $0f, $22, $af, $22, $fa, $d2
    db $c0, $47, $3e, $95, $22, $3e, $20, $22, $78, $cb, $37, $e6, $0f, $22, $af, $22
    db $3e, $95, $22, $3e, $28, $22, $78, $e6, $0f, $22, $af, $22, $fa, $d3, $c0, $47
    db $3e, $95, $22, $3e, $30, $22, $78, $cb, $37, $e6, $0f, $22, $af, $22, $3e, $95
    db $22, $3e, $38, $22, $78, $e6, $0f, $22, $af, $22, $c9, $c9

; C: leftover: 72 bytes of code H_BLANK_TX of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_520E_H_BLANK_TX::
    db $3e, $80, $e0, $88, $fa, $c7, $c0, $67, $fa, $c6, $c0, $6f, $2a, $47, $2a, $4f
    db $2a, $57, $2a, $5f, $7c, $ea, $c7, $c0, $7d, $ea, $c6, $c0, $fa, $c5, $c0, $67
    db $fa, $c4, $c0, $6f, $f0, $41, $e6, $03, $28, $fa, $f0, $41, $e6, $03, $20, $fa
    db $78, $22, $79, $22, $7a, $22, $7b, $22, $7c, $ea, $c5, $c0, $7d, $ea, $c4, $c0
    db $f0, $88, $3d, $e0, $88, $20, $bd, $c9

; C: leftover: 14 bytes of code HBLK of the bank 0 of an older build (the build of table $2A); address and name from
; symbol table $2A; code that this build never runs (typed data)
Leftover_2C_5256_HBLK::
    db $78, $22, $79, $22, $7a, $22, $7b, $22, $3e, $01, $ea, $c2, $c0, $d9

; C: leftover: 8 bytes of code WAIT_DONE_VBLNK of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_5264_WAIT_DONE_VBLNK::
    db $f0, $44, $fe, $00, $c2, $64, $12, $c9

; C: leftover: 5 bytes of code TIMER_INT of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; code that this build never runs (typed data)
Leftover_2C_526C_TIMER_INT::
    db $21, $cf, $c0, $34, $d9

; C: leftover: 10 bytes of code VB_MOVIE of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_5271_VB_MOVIE::
    db $cd, $b6, $ff, $fa, $c9, $c0, $e6, $ff, $c8, $c9

; C: leftover: 135 bytes of code MAKE_CONFIG of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_527B_MAKE_CONFIG::
    db $cd, $d3, $02, $cd, $41, $03, $cd, $c8, $02, $f0, $fd, $f5, $3e, $03, $e0, $fd
    db $ea, $00, $21, $21, $41, $5a, $11, $00, $80, $01, $00, $18, $cd, $bf, $02, $21
    db $41, $72, $11, $00, $98, $01, $40, $02, $cd, $bf, $02, $21, $00, $c0, $fa, $e7
    db $c0, $22, $3e, $08, $22, $3e, $00, $22, $af, $22, $21, $4f, $19, $11, $04, $c0
    db $01, $30, $00, $cd, $bf, $02, $cd, $69, $15, $cd, $17, $16, $cd, $3c, $16, $cd
    db $63, $16, $cd, $88, $16, $cd, $aa, $16, $cd, $b8, $16, $cd, $f9, $16, $cd, $2f
    db $17, $cd, $50, $17, $f1, $e0, $fd, $ea, $00, $21, $cd, $34, $04, $cd, $19, $04
    db $cd, $26, $04, $3e, $01, $e0, $ff, $3e, $09, $ea, $a0, $c0, $3e, $c3, $e0, $40
    db $af, $ea, $62, $c1, $e0, $88, $c9

; C: leftover: 514 bytes of code CONFIG of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_5302_CONFIG::
    INCBIN "data/bank_2c/Leftover_2C_5302_CONFIG.bin" ; $5302, 514 bytes
; C: leftover: 101 bytes of code VB_CONFIG of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_5504_VB_CONFIG::
    db $f0, $88, $fe, $01, $20, $07, $cd, $50, $17, $18, $56, $18, $54, $fe, $02, $20
    db $0b, $cd, $17, $16, $cd, $63, $16, $cd, $2f, $17, $18, $45, $fe, $03, $20, $0b
    db $cd, $3c, $16, $cd, $63, $16, $cd, $2f, $17, $18, $36, $fe, $04, $20, $05, $cd
    db $63, $16, $18, $2d, $fe, $05, $20, $05, $cd, $88, $16, $18, $24, $fe, $06, $20
    db $05, $cd, $2f, $17, $18, $1b, $fe, $07, $20, $05, $cd, $f9, $16, $18, $12, $fe
    db $08, $20, $05, $cd, $b8, $16, $18, $09, $fe, $09, $20, $05, $cd, $aa, $16, $18
    db $00, $af, $e0, $88, $c9

; C: leftover: 173 bytes of code CONF_SET_OBJ of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_5569_CONF_SET_OBJ::
    db $fa, $c3, $c0, $f5, $3e, $10, $ea, $c3, $c0, $ea, $00, $40, $fa, $f2, $c0, $cd
    db $2e, $33, $f1, $ea, $c3, $c0, $ea, $00, $40, $21, $06, $c0, $fa, $f8, $c0, $cb
    db $37, $e6, $0f, $c6, $e0, $22, $23, $23, $23, $fa, $f8, $c0, $e6, $0f, $c6, $e0
    db $22, $23, $23, $23, $fa, $f9, $c0, $cb, $37, $e6, $0f, $c6, $e0, $22, $23, $23
    db $23, $fa, $f9, $c0, $e6, $0f, $c6, $e0, $22, $23, $23, $23, $fa, $fa, $c0, $cb
    db $37, $e6, $0f, $c6, $e0, $22, $23, $23, $23, $fa, $fa, $c0, $e6, $0f, $c6, $e0
    db $22, $23, $23, $23, $fa, $fb, $c0, $cb, $37, $e6, $0f, $c6, $e0, $22, $23, $23
    db $23, $fa, $fb, $c0, $e6, $0f, $c6, $e0, $22, $23, $23, $23, $fa, $fc, $c0, $cb
    db $37, $e6, $0f, $c6, $e0, $22, $23, $23, $23, $fa, $fc, $c0, $e6, $0f, $c6, $e0
    db $22, $23, $23, $23, $fa, $fd, $c0, $cb, $37, $e6, $0f, $c6, $e0, $22, $23, $23
    db $23, $fa, $fd, $c0, $e6, $0f, $c6, $e0, $22, $23, $23, $23, $c9

; C: leftover: 1 bytes of code DITHER_SET of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_5616_DITHER_SET::
    db $c9

; C: leftover: 37 bytes of code PUT_MODE of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_5617_PUT_MODE::
    db $21, $bb, $17, $11, $18, $00, $fa, $f2, $c0, $e6, $0f, $b7, $28, $04, $19, $3d
    db $18, $f9, $11, $46, $98, $01, $0c, $00, $cd, $bf, $02, $11, $66, $98, $01, $0c
    db $00, $cd, $bf, $02, $c9

; C: leftover: 39 bytes of code PUT_EDGE of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_563C_PUT_EDGE::
    db $21, $63, $18, $11, $08, $00, $fa, $f2, $c0, $cb, $37, $e6, $0f, $b7, $28, $04
    db $19, $3d, $18, $f9, $11, $86, $98, $01, $04, $00, $cd, $bf, $02, $11, $a6, $98
    db $01, $04, $00, $cd, $bf, $02, $c9

; C: leftover: 37 bytes of code PUT_VREF of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_5663_PUT_VREF::
    db $21, $a3, $18, $11, $08, $00, $fa, $fc, $c0, $e6, $07, $b7, $28, $04, $19, $3d
    db $18, $f9, $11, $c6, $98, $01, $04, $00, $cd, $bf, $02, $11, $e6, $98, $01, $04
    db $00, $cd, $bf, $02, $c9

; C: leftover: 34 bytes of code PUT_ZERO of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_5688_PUT_ZERO::
    db $21, $e3, $18, $11, $1c, $00, $3e, $02, $b7, $28, $04, $19, $3d, $18, $f9, $11
    db $06, $99, $01, $0e, $00, $cd, $bf, $02, $11, $26, $99, $01, $0e, $00, $cd, $bf
    db $02, $c9

; C: leftover: 14 bytes of code PUT_PALETTE of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_56AA_PUT_PALETTE::
    db $fa, $f7, $c0, $c6, $80, $ea, $06, $9a, $c6, $10, $ea, $26, $9a, $c9

; C: leftover: 65 bytes of code PUT_CHG_T of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_56B8_PUT_CHG_T::
    db $fa, $fa, $c0, $cb, $37, $e6, $0f, $c6, $80, $ea, $c6, $99, $c6, $10, $ea, $e6
    db $99, $fa, $fa, $c0, $e6, $0f, $c6, $80, $ea, $c7, $99, $c6, $10, $ea, $e7, $99
    db $fa, $fb, $c0, $cb, $37, $e6, $0f, $c6, $80, $ea, $c8, $99, $c6, $10, $ea, $e8
    db $99, $fa, $fb, $c0, $e6, $0f, $c6, $80, $ea, $c9, $99, $c6, $10, $ea, $e9, $99
    db $c9

; C: leftover: 54 bytes of code PUT_OFS of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_56F9_PUT_OFS::
    db $fa, $fd, $c0, $cb, $6f, $28, $04, $3e, $40, $18, $02, $3e, $41, $ea, $86, $99
    db $c6, $10, $ea, $a6, $99, $fa, $fd, $c0, $cb, $37, $e6, $01, $c6, $80, $ea, $87
    db $99, $c6, $10, $ea, $a7, $99, $fa, $fd, $c0, $e6, $0f, $c6, $80, $ea, $88, $99
    db $c6, $10, $ea, $a8, $99, $c9

; C: leftover: 33 bytes of code PUT_GAIN of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_572F_PUT_GAIN::
    db $fa, $f9, $c0, $cb, $37, $e6, $01, $c6, $80, $ea, $46, $99, $c6, $10, $ea, $66
    db $99, $fa, $f9, $c0, $e6, $0f, $c6, $80, $ea, $47, $99, $c6, $10, $ea, $67, $99
    db $c9

; C: leftover: 35 bytes of code PUT_DITH_PAT of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_5750_PUT_DITH_PAT::
    db $21, $73, $17, $11, $06, $00, $fa, $e9, $c0, $b7, $28, $04, $19, $3d, $18, $f9
    db $11, $06, $98, $01, $03, $00, $cd, $bf, $02, $11, $26, $98, $01, $03, $00, $cd
    db $bf, $02, $c9

; C: leftover: 72 bytes of data DITH_P0 of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; nothing in this build reads it
Leftover_2C_5773_DITH_P0::
    db $29, $2a, $2b, $39, $3a, $3b, $81, $60, $60, $91, $60, $60, $82, $60, $60, $92
    db $60, $60, $83, $60, $60, $93, $60, $60, $84, $60, $60, $94, $60, $60, $85, $60
    db $60, $95, $60, $60, $86, $60, $60, $96, $60, $60, $87, $60, $60, $97, $60, $60
    db $88, $60, $60, $98, $60, $60, $89, $60, $60, $99, $60, $60, $81, $80, $60, $91
    db $90, $60, $81, $81, $60, $91, $91, $60

; C: leftover: 168 bytes of data MODE0 of the bank 0 of an older build (the build of table $2A); address and name from
; symbol table $2A; nothing in this build reads it
Leftover_2C_57BB_MODE0::
    db $2e, $2f, $46, $47, $48, $49, $60, $60, $60, $60, $60, $60, $3e, $3f, $56, $57
    db $58, $59, $60, $60, $60, $60, $60, $60, $0a, $0b, $20, $21, $22, $23, $24, $25
    db $26, $60, $60, $60, $1a, $1b, $30, $31, $32, $33, $34, $35, $36, $60, $60, $60
    db $0c, $0d, $20, $21, $22, $23, $24, $25, $26, $60, $60, $60, $1c, $1d, $30, $31
    db $32, $33, $34, $35, $36, $60, $60, $60, $00, $01, $02, $03, $04, $20, $21, $22
    db $23, $24, $25, $26, $10, $11, $12, $13, $14, $30, $31, $32, $33, $34, $35, $36
    db $0a, $0b, $20, $21, $22, $60, $60, $60, $60, $60, $60, $60, $1a, $1b, $30, $31
    db $32, $60, $60, $60, $60, $60, $60, $60, $0c, $0d, $20, $21, $22, $60, $60, $60
    db $60, $60, $60, $60, $1c, $1d, $30, $31, $32, $60, $60, $60, $60, $60, $60, $60
    db $00, $01, $02, $03, $04, $20, $21, $22, $60, $60, $60, $60, $10, $11, $12, $13
    db $14, $30, $31, $32, $60, $60, $60, $60

; C: leftover: 64 bytes of data EDGE0 of the bank 0 of an older build (the build of table $2A); address and name from
; symbol table $2A; nothing in this build reads it
Leftover_2C_5863_EDGE0::
    db $85, $80, $44, $60, $95, $90, $54, $60, $87, $85, $44, $60, $97, $95, $54, $60
    db $81, $80, $80, $44, $91, $90, $90, $54, $81, $82, $85, $44, $91, $92, $95, $54
    db $82, $80, $80, $44, $92, $90, $90, $54, $83, $80, $80, $44, $93, $90, $90, $54
    db $84, $80, $80, $44, $94, $90, $90, $54, $85, $80, $80, $44, $95, $90, $90, $54

; C: leftover: 64 bytes of data VREF0 of the bank 0 of an older build (the build of table $2A); address and name from
; symbol table $2A; nothing in this build reads it
Leftover_2C_58A3_VREF0::
    db $80, $42, $80, $43, $90, $52, $90, $53, $80, $42, $85, $43, $90, $52, $95, $53
    db $81, $42, $80, $43, $91, $52, $90, $53, $81, $42, $85, $43, $91, $52, $95, $53
    db $82, $42, $80, $43, $92, $52, $90, $53, $82, $42, $85, $43, $92, $52, $95, $53
    db $83, $42, $80, $43, $93, $52, $90, $53, $83, $42, $85, $43, $93, $52, $95, $53

; C: leftover: 84 bytes of data ZERO0 of the bank 0 of an older build (the build of table $2A); address and name from
; symbol table $2A; nothing in this build reads it
Leftover_2C_58E3_ZERO0::
    db $4a, $4b, $4c, $4d, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $5a, $5b
    db $5c, $5d, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $2c, $2d, $46, $47
    db $48, $49, $ac, $ad, $ae, $af, $0e, $0f, $2c, $2d, $3c, $3d, $56, $57, $58, $59
    db $bc, $bd, $be, $bf, $1e, $1f, $3c, $3d, $2e, $2f, $46, $47, $48, $49, $ac, $ad
    db $ae, $af, $0e, $0f, $2c, $2d, $3e, $3f, $56, $57, $58, $59, $bc, $bd, $be, $bf
    db $1e, $1f, $3c, $3d

; C: leftover: 24 bytes of data REV0 of the bank 0 of an older build (the build of table $2A); address and name from
; symbol table $2A; nothing in this build reads it
Leftover_2C_5937_REV0::
    db $4e, $4f, $cc, $cd, $ce, $cf, $5e, $5f, $dc, $dd, $de, $df, $cc, $cd, $ce, $cf
    db $60, $60, $dc, $dd, $de, $df, $60, $60

; C: leftover: 48 bytes of data CONF_OBJ_PAT of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A; nothing in this build reads it
Leftover_2C_594F_CONF_OBJ_PAT::
    db $70, $80, $80, $00, $70, $88, $80, $00, $78, $80, $80, $00, $78, $88, $80, $00
    db $80, $80, $80, $00, $80, $88, $80, $00, $88, $80, $80, $00, $88, $88, $80, $00
    db $90, $80, $80, $00, $90, $88, $80, $00, $98, $80, $80, $00, $98, $88, $80, $00

; C: leftover: 96 bytes of code MK_PROTECT of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_597F_MK_PROTECT::
    db $cd, $d3, $02, $cd, $41, $03, $cd, $c8, $02, $f0, $fd, $f5, $3e, $02, $e0, $fd
    db $ea, $00, $21, $21, $01, $40, $11, $00, $80, $01, $00, $18, $cd, $bf, $02, $21
    db $41, $63, $11, $00, $98, $01, $40, $02, $cd, $bf, $02, $21, $00, $c0, $3e, $3c
    db $22, $3e, $29, $22, $af, $22, $22, $3e, $3c, $22, $3e, $31, $22, $3e, $02, $22
    db $af, $22, $e0, $a6, $ea, $d9, $c0, $cd, $34, $04, $cd, $19, $04, $cd, $26, $04
    db $3e, $c7, $e0, $40, $3e, $0a, $ea, $a0, $c0, $f1, $e0, $fd, $ea, $00, $21, $c9

; C: leftover: 112 bytes of code PROTECT_TEST of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_59DF_PROTECT_TEST::
    db $f0, $81, $cb, $27, $38, $41, $cb, $27, $38, $4c, $cb, $27, $cb, $27, $cb, $27
    db $cb, $27, $cb, $27, $38, $09, $cb, $27, $38, $0f, $cd, $eb, $09, $18, $50, $3e
    db $02, $ea, $bd, $c0, $cd, $4a, $05, $18, $46, $fa, $00, $c0, $fe, $3c, $20, $05
    db $cd, $4f, $1a, $18, $10, $fe, $4c, $20, $05, $cd, $89, $1a, $18, $07, $fe, $5c
    db $20, $03, $cd, $c8, $1a, $18, $28, $fa, $00, $c0, $fe, $5c, $20, $04, $d6, $20
    db $18, $13, $c6, $10, $18, $0f, $fa, $00, $c0, $fe, $3c, $20, $04, $c6, $20, $18
    db $04, $d6, $10, $18, $00, $ea, $00, $c0, $ea, $04, $c0, $af, $ea, $d9, $c0, $c9

; C: leftover: 58 bytes of code PROT_TEST of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_5A4F_PROT_TEST::
    db $f3, $16, $00, $3e, $01, $ea, $00, $60, $7a, $ea, $00, $40, $21, $00, $a0, $7e
    db $47, $ee, $ff, $77, $7e, $b8, $20, $1b, $21, $ff, $bf, $7e, $47, $ee, $ff, $77
    db $7e, $b8, $20, $0f, $7a, $fe, $0f, $28, $03, $14, $18, $dc, $3e, $01, $ea, $d9
    db $c0, $fb, $c9, $3e, $02, $ea, $d9, $c0, $fb, $c9

; C: leftover: 63 bytes of code OFF_TEST of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_5A89_OFF_TEST::
    db $f3, $16, $00, $3e, $01, $ea, $00, $60, $3e, $0a, $ea, $00, $00, $7a, $ea, $00
    db $40, $21, $00, $a0, $7e, $ee, $ff, $47, $77, $7e, $b8, $20, $1b, $21, $ff, $bf
    db $7e, $ee, $ff, $47, $77, $7e, $b8, $20, $0f, $7a, $fe, $0f, $28, $03, $14, $18
    db $dc, $3e, $03, $ea, $d9, $c0, $fb, $c9, $3e, $04, $ea, $d9, $c0, $fb, $c9

; C: leftover: 63 bytes of code ON_TEST of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_5AC8_ON_TEST::
    db $f3, $16, $00, $3e, $01, $ea, $00, $60, $3e, $00, $ea, $00, $00, $7a, $ea, $00
    db $40, $21, $00, $a0, $7e, $47, $ee, $ff, $77, $7e, $b8, $20, $1b, $21, $ff, $bf
    db $7e, $47, $ee, $ff, $77, $7e, $b8, $20, $0f, $7a, $fe, $0f, $28, $03, $14, $18
    db $dc, $3e, $05, $ea, $d9, $c0, $fb, $c9, $3e, $06, $ea, $d9, $c0, $fb, $c9

; C: leftover: 125 bytes of code VB_PROTECT of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_5B07_VB_PROTECT::
    db $fa, $d9, $c0, $b7, $20, $16, $3e, $a0, $ea, $ce, $98, $ea, $cf, $98, $ea, $0e
    db $99, $ea, $0f, $99, $ea, $4e, $99, $ea, $4f, $99, $18, $60, $fe, $01, $20, $0c
    db $3e, $cf, $ea, $ce, $98, $3e, $cb, $ea, $cf, $98, $18, $50, $fe, $02, $20, $0c
    db $3e, $ce, $ea, $ce, $98, $3e, $c7, $ea, $cf, $98, $18, $40, $fe, $03, $20, $0c
    db $3e, $cf, $ea, $0e, $99, $3e, $cb, $ea, $0f, $99, $18, $30, $fe, $04, $20, $0c
    db $3e, $ce, $ea, $0e, $99, $3e, $c7, $ea, $0f, $99, $18, $20, $fe, $05, $20, $0c
    db $3e, $cf, $ea, $4e, $99, $3e, $cb, $ea, $4f, $99, $18, $10, $fe, $06, $20, $0c
    db $3e, $ce, $ea, $4e, $99, $3e, $c7, $ea, $4f, $99, $18, $00, $c9

; C: leftover: 24 bytes of code MK_PIC_SAVE of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_5B84_MK_PIC_SAVE::
    db $3e, $0c, $ea, $a0, $c0, $cd, $c8, $02, $21, $cf, $1c, $11, $00, $c0, $01, $28
    db $00, $cd, $bf, $02, $af, $ea, $cb, $c0

; C: leftover: 220 bytes of code PIC_SAVE of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_5B9C_PIC_SAVE::
    db $fa, $cb, $c0, $b7, $28, $0a, $fe, $01, $28, $5d, $fe, $02, $ca, $6d, $1c, $c9
    db $f0, $81, $cb, $3f, $38, $11, $cb, $3f, $38, $2f, $cb, $3f, $cb, $3f, $cb, $3f
    db $38, $2b, $cb, $3f, $38, $34, $c9, $fa, $1a, $c0, $fe, $36, $20, $1b, $cd, $c8
    db $02, $21, $07, $1d, $11, $00, $c0, $01, $14, $00, $cd, $bf, $02, $fa, $cc, $c0
    db $cd, $9e, $1c, $3e, $01, $ea, $cb, $c0, $c9, $cd, $a5, $0e, $c9, $21, $f7, $1c
    db $11, $18, $c0, $01, $10, $00, $cd, $bf, $02, $c9, $21, $e7, $1c, $11, $18, $c0
    db $01, $10, $00, $cd, $bf, $02, $c9, $f0, $81, $cb, $3f, $38, $15, $cb, $3f, $38
    db $3a, $cb, $3f, $cb, $3f, $cb, $3f, $cb, $3f, $cb, $3f, $38, $32, $cb, $3f, $38
    db $3f, $c9, $cd, $78, $1c, $cd, $c8, $02, $21, $1b, $1d, $11, $00, $c0, $01, $18
    db $00, $cd, $bf, $02, $3e, $02, $ea, $cb, $c0, $3e, $30, $e0, $88, $fa, $cc, $c0
    db $3c, $fe, $1e, $20, $02, $3e, $00, $ea, $cc, $c0, $c9, $cd, $a5, $0e, $c9, $fa
    db $cc, $c0, $fe, $1d, $20, $02, $3e, $ff, $3c, $ea, $cc, $c0, $cd, $9e, $1c, $c9
    db $fa, $cc, $c0, $fe, $00, $20, $02, $3e, $1e, $3d, $ea, $cc, $c0, $cd, $9e, $1c
    db $c9, $f0, $88, $3d, $e0, $88, $b7, $c0, $cd, $a5, $0e, $c9

; C: leftover: 38 bytes of code PICT_SAVE_GO of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_5C78_PICT_SAVE_GO::
    db $21, $00, $d0, $11, $00, $a0, $01, $00, $10, $fa, $cc, $c0, $cb, $3f, $30, $03
    db $11, $00, $b0, $c6, $01, $ea, $00, $40, $3e, $0a, $ea, $00, $00, $cd, $e7, $26
    db $3e, $00, $ea, $00, $00, $c9

; C: leftover: 49 bytes of code PUT_BYTE_OBJ2 of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_5C9E_PUT_BYTE_OBJ2::
    db $4f, $af, $47, $79, $b7, $28, $0b, $af, $3c, $fe, $0a, $20, $02, $04, $af, $0d
    db $20, $f6, $e0, $88, $78, $e0, $89, $21, $14, $c0, $3e, $96, $22, $3e, $70, $22
    db $f0, $89, $22, $af, $22, $3e, $96, $22, $3e, $78, $22, $f0, $88, $22, $af, $22
    db $c9

; C: leftover: 24 bytes of data SAVE_SURU of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; nothing in this build reads it
Leftover_2C_5CCF_SAVE_SURU::
    db $96, $38, $30, $00, $96, $40, $31, $00, $96, $48, $32, $00, $96, $50, $33, $00
    db $96, $58, $34, $00, $96, $60, $35, $00

; C: leftover: 16 bytes of data SAVE_YES of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; nothing in this build reads it
Leftover_2C_5CE7_SAVE_YES::
    db $96, $68, $36, $00, $96, $70, $37, $00, $96, $78, $38, $00, $96, $80, $39, $00

; C: leftover: 16 bytes of data SAVE_NO of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; nothing in this build reads it
Leftover_2C_5CF7_SAVE_NO::
    db $96, $68, $3a, $00, $96, $70, $3b, $00, $96, $78, $3c, $00, $96, $80, $3d, $00

; C: leftover: 20 bytes of data NANBANNI of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; nothing in this build reads it
Leftover_2C_5D07_NANBANNI::
    db $96, $40, $40, $00, $96, $48, $41, $00, $96, $50, $42, $00, $96, $58, $43, $00
    db $96, $60, $44, $00

; C: leftover: 24 bytes of data SAVESIMASITA of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A; nothing in this build reads it
Leftover_2C_5D1B_SAVESIMASITA::
    db $96, $40, $45, $00, $96, $48, $46, $00, $96, $50, $47, $00, $96, $58, $48, $00
    db $96, $60, $49, $00, $96, $68, $4a, $00

; C: leftover: 124 bytes of code MAKE_GALLERY of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_5D33_MAKE_GALLERY::
    db $cd, $d3, $02, $cd, $41, $03, $cd, $c8, $02, $f0, $fd, $f5, $3e, $03, $e0, $fd
    db $ea, $00, $21, $21, $01, $40, $11, $00, $80, $01, $00, $18, $cd, $bf, $02, $21
    db $01, $58, $11, $00, $98, $01, $40, $02, $cd, $bf, $02, $21, $00, $a0, $fa, $cc
    db $c0, $b7, $20, $02, $3e, $1e, $3d, $ea, $cc, $c0, $cb, $3f, $30, $03, $21, $00
    db $b0, $c6, $01, $ea, $00, $40, $11, $00, $88, $01, $00, $0e, $cd, $bf, $02, $cd
    db $96, $1e, $f1, $e0, $fd, $ea, $00, $21, $cd, $34, $04, $cd, $19, $04, $cd, $26
    db $04, $3e, $01, $ea, $c9, $c0, $3e, $01, $e0, $ff, $af, $ea, $c2, $c0, $3e, $08
    db $e0, $41, $3e, $0d, $ea, $a0, $c0, $3e, $c3, $e0, $40, $c9

; C: leftover: 131 bytes of code GALLERY_MODE of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_5DAF_GALLERY_MODE::
    db $fa, $cd, $c0, $b7, $20, $7d, $f0, $81, $cb, $2f, $38, $19, $f0, $80, $cb, $2f
    db $cb, $2f, $38, $15, $cb, $2f, $cb, $2f, $cb, $2f, $cb, $2f, $cb, $2f, $38, $1e
    db $cb, $2f, $38, $28, $c9, $cd, $c7, $1f, $c9, $fa, $cc, $c0, $3c, $fe, $1e, $20
    db $01, $af, $ea, $cc, $c0, $3e, $04, $ea, $bd, $c0, $cd, $4a, $05, $c9, $fa, $cc
    db $c0, $3c, $fe, $1e, $20, $01, $af, $ea, $cc, $c0, $18, $0f, $fa, $cc, $c0, $3d
    db $fe, $ff, $20, $02, $3e, $1d, $ea, $cc, $c0, $18, $00, $cd, $96, $1e, $21, $c4
    db $c0, $af, $22, $3e, $88, $77, $16, $a0, $fa, $cc, $c0, $cb, $3f, $30, $02, $16
    db $b0, $c6, $01, $ea, $00, $40, $21, $c6, $c0, $af, $22, $7a, $22, $3e, $01, $ea
    db $cd, $c0, $c9

; C: leftover: 15 bytes of code PUT_PICTURE of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; code that this build never runs (typed data)
Leftover_2C_5E32_PUT_PICTURE::
    db $fa, $c5, $c0, $d6, $96, $30, $04, $cd, $42, $1e, $c9, $af, $ea, $cd, $c0

; C: leftover: 1 bytes of code TENSOU_END of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; code that this build never runs (typed data)
Leftover_2C_5E41_TENSOU_END::
    db $c9

; C: leftover: 84 bytes of code H_BLANK_TX2 of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_5E42_H_BLANK_TX2::
    db $f3, $3e, $80, $e0, $88, $3e, $10, $3d, $c2, $49, $1e, $3e, $02, $e0, $ff, $fa
    db $c7, $c0, $67, $fa, $c6, $c0, $6f, $2a, $47, $2a, $4f, $2a, $57, $2a, $5f, $7c
    db $ea, $c7, $c0, $7d, $ea, $c6, $c0, $fa, $c5, $c0, $67, $fa, $c4, $c0, $6f, $fb
    db $fa, $c2, $c0, $a7, $28, $fa, $f3, $af, $ea, $c2, $c0, $7c, $ea, $c5, $c0, $7d
    db $ea, $c4, $c0, $f0, $88, $3d, $e0, $88, $20, $c5, $3e, $01, $e0, $ff, $fb, $f0
    db $44, $e0, $8b, $c9

; C: leftover: 53 bytes of code GALLERY_OBJ_SET of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_5E96_GALLERY_OBJ_SET::
    db $fa, $cc, $c0, $4f, $af, $47, $79, $b7, $28, $0b, $af, $3c, $fe, $0a, $20, $02
    db $04, $af, $0d, $20, $f6, $e0, $88, $78, $e0, $89, $47, $21, $00, $c0, $3e, $10
    db $22, $3e, $30, $22, $f0, $89, $22, $af, $22, $3e, $10, $22, $3e, $38, $22, $f0
    db $88, $22, $af, $22, $c9

; C: leftover: 252 bytes of code VB_GALLERY of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_5ECB_VB_GALLERY::
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

; C: leftover: 67 bytes of code PRINT_GO_GO of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_5FC7_PRINT_GO_GO::
    db $c9, $cd, $d3, $02, $cd, $a2, $2c, $3e, $c3, $e0, $40, $af, $ea, $6c, $c3, $21
    db $00, $c8, $3e, $09, $cd, $b8, $2d, $fe, $ff, $28, $28, $fe, $f0, $28, $05, $cd
    db $64, $12, $18, $f0, $3e, $01, $ea, $6c, $c3, $3e, $01, $ea, $39, $c3, $3e, $e4
    db $ea, $3b, $c3, $cd, $85, $2d, $fe, $ff, $28, $09, $fe, $f0, $28, $05, $cd, $64
    db $12, $18, $f0

; C: leftover: 1 bytes of code MY_PRINT_END of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; code that this build never runs (typed data)
Leftover_2C_600A_MY_PRINT_END::
    db $c9

; C: leftover: 19 bytes of code SIOWATCHDOG2 of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A; code that this build never runs (typed data)
Leftover_2C_600B_SIOWATCHDOG2::
    db $fa, $6c, $c3, $a7, $c0, $21, $6f, $c3, $34, $7e, $fe, $06, $d8, $af, $77, $cd
    db $e9, $2e, $c9

; C: leftover: 32 bytes of code TENSOU_YOKO of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_601E_TENSOU_YOKO::
    db $fa, $c3, $c0, $f5, $3e, $00, $ea, $c3, $c0, $ea, $00, $40, $21, $00, $a7, $11
    db $00, $d7, $01, $00, $07, $cd, $e7, $26, $f1, $ea, $c3, $c0, $ea, $00, $40, $c9

; C: leftover: 188 bytes of code TENSOU_TATE of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_603E_TENSOU_TATE::
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

; C: leftover: 290 bytes of code MIRROR_MODE of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_60FA_MIRROR_MODE::
    INCBIN "data/bank_2c/Leftover_2C_60FA_MIRROR_MODE.bin" ; $60FA, 290 bytes
; C: leftover: 78 bytes of code MIRROR_LINE of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_621C_MIRROR_LINE::
    db $3e, $f0, $e0, $8b, $cd, $6a, $22, $3e, $d0, $e0, $8b, $cd, $6a, $22, $3e, $b0
    db $e0, $8b, $cd, $6a, $22, $3e, $90, $e0, $8b, $cd, $6a, $22, $3e, $70, $e0, $8b
    db $cd, $6a, $22, $3e, $50, $e0, $8b, $cd, $6a, $22, $3e, $30, $e0, $8b, $cd, $6a
    db $22, $3e, $10, $e0, $8b, $cd, $6a, $22, $01, $80, $00, $62, $6b, $09, $54, $5d
    db $f0, $88, $67, $f0, $89, $6f, $09, $7c, $e0, $88, $7d, $e0, $89, $c9

; C: leftover: 39 bytes of code MIRROR_CHR of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_626A_MIRROR_CHR::
    db $3e, $10, $e0, $8a, $f0, $88, $67, $f0, $89, $6f, $2a, $12, $47, $7c, $e0, $88
    db $7d, $e0, $89, $cd, $91, $22, $62, $6b, $f0, $8b, $85, $6f, $78, $77, $13, $f0
    db $8a, $3d, $e0, $8a, $20, $de, $c9

; C: leftover: 6 bytes of code NARABEKAE of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_6291_NARABEKAE::
    db $26, $3d, $68, $7e, $47, $c9

; C: leftover: 213 bytes of code MABIKI_MODE of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_6297_MABIKI_MODE::
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

; C: leftover: 94 bytes of code MABIKI_BYTE of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_636C_MABIKI_BYTE::
    db $7e, $e0, $88, $01, $10, $00, $09, $7e, $e0, $89, $01, $f0, $ff, $09, $f0, $88
    db $07, $cb, $10, $07, $07, $cb, $10, $07, $07, $cb, $10, $07, $07, $cb, $10, $f0
    db $89, $07, $cb, $10, $07, $07, $cb, $10, $07, $07, $cb, $10, $07, $07, $cb, $10
    db $78, $12, $e5, $62, $6b, $01, $80, $00, $09, $77, $01, $80, $06, $09, $77, $01
    db $80, $00, $09, $77, $01, $80, $f8, $09, $54, $5d, $e1, $c9, $01, $80, $07, $09
    db $77, $01, $80, $00, $09, $77, $01, $80, $f7, $09, $54, $5d, $e1, $c9

; C: leftover: 253 bytes of code MABIKI_MODE2 of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_63CA_MABIKI_MODE2::
    db $fa, $c3, $c0, $f5, $3e, $00, $ea, $c3, $c0, $ea, $00, $40, $fa, $d0, $c0, $fe
    db $00, $20, $05, $11, $00, $d0, $18, $15, $fe, $01, $20, $05, $11, $80, $d0, $18
    db $0c, $fe, $02, $20, $05, $11, $80, $d7, $18, $03, $11, $00, $d7, $21, $00, $a0
    db $3c, $fe, $04, $20, $02, $3e, $00, $ea, $d0, $c0, $3e, $07, $ea, $bf, $c0, $3e
    db $08, $ea, $be, $c0, $cd, $c7, $24, $23, $13, $cd, $c7, $24, $23, $23, $23, $13
    db $cd, $c7, $24, $23, $13, $cd, $c7, $24, $23, $23, $23, $13, $cd, $c7, $24, $23
    db $13, $cd, $c7, $24, $23, $23, $23, $13, $cd, $c7, $24, $23, $13, $cd, $c7, $24
    db $23, $23, $23, $13, $01, $10, $00, $09, $13, $13, $13, $13, $13, $13, $13, $13
    db $fa, $be, $c0, $3d, $ea, $be, $c0, $c2, $0e, $24, $e5, $62, $6b, $01, $88, $ff
    db $09, $54, $5d, $e1, $3e, $08, $ea, $be, $c0, $cd, $c7, $24, $23, $13, $cd, $c7
    db $24, $23, $23, $23, $13, $cd, $c7, $24, $23, $13, $cd, $c7, $24, $23, $23, $23
    db $13, $cd, $c7, $24, $23, $13, $cd, $c7, $24, $23, $23, $23, $13, $cd, $c7, $24
    db $23, $13, $cd, $c7, $24, $23, $23, $23, $13, $01, $10, $00, $09, $13, $13, $13
    db $13, $13, $13, $13, $13, $fa, $be, $c0, $3d, $ea, $be, $c0, $c2, $63, $24, $fa
    db $bf, $c0, $3d, $28, $10, $ea, $bf, $c0, $e5, $62, $6b, $01, $78, $00, $09, $54
    db $5d, $e1, $c3, $09, $24, $f1, $ea, $c3, $c0, $ea, $00, $40, $c9

; C: leftover: 51 bytes of code MABIKI_BYTE2 of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_64C7_MABIKI_BYTE2::
    db $7e, $e0, $88, $01, $10, $00, $09, $7e, $e0, $89, $01, $f0, $ff, $09, $f0, $88
    db $07, $cb, $10, $07, $07, $cb, $10, $07, $07, $cb, $10, $07, $07, $cb, $10, $f0
    db $89, $07, $cb, $10, $07, $07, $cb, $10, $07, $07, $cb, $10, $07, $07, $cb, $10
    db $78, $12, $c9

; C: leftover: 59 bytes of code TATE_NOBASI_MODE of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_64FA_TATE_NOBASI_MODE::
    db $fa, $c3, $c0, $f5, $3e, $00, $ea, $c3, $c0, $ea, $00, $40, $21, $00, $a4, $11
    db $00, $d0, $3e, $07, $e0, $8a, $3e, $10, $e0, $89, $cd, $35, $25, $f0, $89, $3d
    db $e0, $89, $20, $f6, $e5, $21, $00, $01, $19, $54, $5d, $e1, $f0, $8a, $3d, $e0
    db $8a, $20, $e3, $f1, $ea, $c3, $c0, $ea, $00, $40, $c9

; C: leftover: 71 bytes of code TN_CHARACTER of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_6535_TN_CHARACTER::
    db $3e, $04, $e0, $88, $2a, $47, $2a, $4f, $78, $12, $13, $79, $12, $13, $78, $12
    db $13, $79, $12, $13, $f0, $88, $3d, $e0, $88, $20, $e9, $e5, $21, $f0, $00, $19
    db $54, $5d, $e1, $3e, $04, $e0, $88, $2a, $47, $2a, $4f, $78, $12, $13, $79, $12
    db $13, $78, $12, $13, $79, $12, $13, $f0, $88, $3d, $e0, $88, $20, $e9, $e5, $21
    db $00, $ff, $19, $54, $5d, $e1, $c9

; C: leftover: 57 bytes of code YOKO_NOBASI_MODE of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_657C_YOKO_NOBASI_MODE::
    db $fa, $c3, $c0, $f5, $3e, $00, $ea, $c3, $c0, $ea, $00, $40, $21, $40, $a0, $11
    db $00, $d0, $3e, $0e, $e0, $8a, $3e, $08, $e0, $89, $cd, $b5, $25, $f0, $89, $3d
    db $e0, $89, $20, $f6, $d5, $11, $80, $00, $19, $d1, $f0, $8a, $3d, $e0, $8a, $20
    db $e5, $f1, $ea, $c3, $c0, $ea, $00, $40, $c9

; C: leftover: 23 bytes of code YN_CHARACTER of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_65B5_YN_CHARACTER::
    db $3e, $10, $e0, $88, $cd, $cc, $25, $f0, $88, $3d, $e0, $88, $20, $f6, $e5, $21
    db $10, $00, $19, $54, $5d, $e1, $c9

; C: leftover: 79 bytes of code YN_BYTE of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_65CC_YN_BYTE::
    db $2a, $e5, $67, $6f, $cb, $14, $cb, $10, $cb, $15, $cb, $10, $cb, $14, $cb, $10
    db $cb, $15, $cb, $10, $cb, $14, $cb, $10, $cb, $15, $cb, $10, $cb, $14, $cb, $10
    db $cb, $15, $cb, $10, $cb, $14, $cb, $11, $cb, $15, $cb, $11, $cb, $14, $cb, $11
    db $cb, $15, $cb, $11, $cb, $14, $cb, $11, $cb, $15, $cb, $11, $cb, $14, $cb, $11
    db $cb, $15, $cb, $11, $78, $12, $21, $10, $00, $19, $79, $77, $13, $e1, $c9

; C: leftover: 65 bytes of code KAKUDAI_MODE of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_661B_KAKUDAI_MODE::
    db $fa, $c3, $c0, $f5, $3e, $00, $ea, $c3, $c0, $ea, $00, $40, $21, $40, $a4, $11
    db $00, $d0, $3e, $07, $e0, $8a, $3e, $08, $e0, $89, $cd, $5c, $26, $f0, $89, $3d
    db $e0, $89, $20, $f6, $d5, $11, $80, $00, $19, $d1, $e5, $21, $00, $01, $19, $54
    db $5d, $e1, $f0, $8a, $3d, $e0, $8a, $20, $dd, $f1, $ea, $c3, $c0, $ea, $00, $40
    db $c9

; C: leftover: 55 bytes of code KD_CHARACTER of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_665C_KD_CHARACTER::
    db $3e, $04, $e0, $88, $cd, $93, $26, $1b, $cd, $93, $26, $13, $f0, $88, $3d, $e0
    db $88, $20, $f1, $e5, $21, $f0, $00, $19, $54, $5d, $e1, $3e, $04, $e0, $88, $cd
    db $93, $26, $1b, $cd, $93, $26, $13, $f0, $88, $3d, $e0, $88, $20, $f1, $e5, $21
    db $10, $ff, $19, $54, $5d, $e1, $c9

; C: leftover: 84 bytes of code KD_BYTE of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_6693_KD_BYTE::
    db $2a, $e5, $67, $6f, $cb, $14, $cb, $10, $cb, $15, $cb, $10, $cb, $14, $cb, $10
    db $cb, $15, $cb, $10, $cb, $14, $cb, $10, $cb, $15, $cb, $10, $cb, $14, $cb, $10
    db $cb, $15, $cb, $10, $cb, $14, $cb, $11, $cb, $15, $cb, $11, $cb, $14, $cb, $11
    db $cb, $15, $cb, $11, $cb, $14, $cb, $11, $cb, $15, $cb, $11, $cb, $14, $cb, $11
    db $cb, $15, $cb, $11, $78, $12, $13, $13, $12, $21, $0e, $00, $19, $79, $77, $23
    db $23, $77, $e1, $c9

; C: leftover: 774 bytes of code DATA_MOV_F of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_66E7_DATA_MOV_F::
    INCBIN "data/bank_2c/Leftover_2C_66E7_DATA_MOV_F.bin" ; $66E7, 774 bytes
; C: leftover: 115 bytes of code MAKE_EMI of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_69ED_MAKE_EMI::
    db $cd, $d3, $02, $cd, $41, $03, $cd, $c8, $02, $f0, $fd, $f5, $3e, $03, $e0, $fd
    db $ea, $00, $21, $21, $01, $40, $11, $00, $80, $01, $00, $18, $cd, $e7, $26, $21
    db $01, $58, $11, $00, $98, $01, $40, $02, $cd, $bf, $02, $f1, $e0, $fd, $ea, $00
    db $21, $3e, $80, $e0, $02, $3e, $fe, $e0, $01, $af, $e0, $4a, $e0, $42, $e0, $a1
    db $e0, $43, $e0, $a0, $3e, $e4, $e0, $48, $e0, $47, $e0, $ac, $e0, $ae, $3e, $d0
    db $e0, $49, $e0, $ad, $3e, $0b, $ea, $a0, $c0, $af, $ea, $d4, $c0, $3e, $c3, $e0
    db $40, $3e, $58, $ea, $d5, $c0, $3e, $5d, $ea, $d6, $c0, $af, $ea, $d7, $c0, $ea
    db $d4, $c0, $c9

; C: leftover: 39 bytes of code EMI_MAIN of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_6A60_EMI_MAIN::
    db $f0, $81, $cb, $4f, $28, $09, $3e, $05, $ea, $bd, $c0, $cd, $4a, $05, $c9, $fa
    db $d4, $c0, $fe, $02, $28, $11, $cd, $9a, $2a, $cd, $aa, $2a, $fa, $d7, $c0, $a7
    db $c8, $3e, $02, $ea, $d4, $c0, $c9

; C: leftover: 19 bytes of code N_TU_SIN of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; code that this build never runs (typed data)
Leftover_2C_6A87_N_TU_SIN::
    db $fa, $d7, $c0, $a7, $c8, $cd, $b8, $2a, $fa, $d7, $c0, $fe, $02, $c0, $3e, $81
    db $e0, $02, $c9

; C: leftover: 16 bytes of code N_KEY_INPUT of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_6A9A_N_KEY_INPUT::
    db $f0, $81, $cb, $47, $20, $01, $c9, $3e, $00, $e0, $01, $3e, $81, $e0, $02, $c9

; C: leftover: 14 bytes of code N_OBJ_HYOUJI of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_6AAA_N_OBJ_HYOUJI::
    db $21, $00, $c0, $3e, $54, $22, $3e, $50, $22, $3e, $00, $22, $77, $c9

; C: leftover: 29 bytes of code N_OBJ_HYOUJI2 of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_6AB8_N_OBJ_HYOUJI2::
    db $21, $02, $c0, $fa, $dd, $c0, $cb, $3f, $cb, $3f, $cb, $3f, $cb, $3f, $22, $23
    db $3e, $54, $22, $3e, $58, $22, $fa, $dd, $c0, $e6, $0f, $22, $c9

; C: leftover: 23 bytes of code SIOINT of the printer library of an older build, the Japanese Prn_SerialIrq (00:0F16,
; exact match, instruction ratio 1.00); address and name from symbol table $2A; code that this build never runs (typed
; data)
Leftover_2C_6AD5_SIOINT::
    db $f5, $f0, $02, $cb, $7f, $20, $0e, $c5, $d5, $e5, $3e, $01, $ea, $5b, $c3, $cd
    db $0b, $2b, $e1, $d1, $c1, $f1, $d9

; C: leftover: 31 bytes of code SIOWATCHDOG of the printer library of an older build, the Japanese Prn_VBlankPoll
; (00:0F2D, near match, instruction ratio 0.97); address and name from symbol table $2A; code that this build never
; runs (typed data)
Leftover_2C_6AEC_SIOWATCHDOG::
    db $fa, $3e, $c3, $fe, $01, $c0, $fa, $58, $c3, $fe, $ff, $c8, $fa, $6c, $c3, $a7
    db $c0, $21, $6f, $c3, $34, $7e, $fe, $06, $d8, $af, $77, $cd, $e9, $2e, $c9

; C: leftover: 62 bytes of code SIOPROC of the printer library of an older build, the Japanese Prn_SerialStep
; (00:176F, exact match, instruction ratio 1.00); address and name from symbol table $2A; code that this build never
; runs (typed data)
Leftover_2C_6B0B_SIOPROC::
    db $fa, $6d, $c3, $a7, $c2, $9d, $2c, $fa, $3e, $c3, $fe, $07, $ca, $59, $2c, $fa
    db $40, $c3, $a7, $20, $06, $cd, $49, $2b, $c3, $a1, $2c, $fa, $41, $c3, $a7, $28
    db $17, $fa, $42, $c3, $a7, $28, $11, $fa, $43, $c3, $fe, $02, $28, $05, $cd, $28
    db $2c, $18, $08, $cd, $3f, $2c, $18, $03, $cd, $6e, $2b, $c3, $a1, $2c

; C: leftover: 37 bytes of code PREAMBLETRANS of the printer library of an older build, the Japanese Prn_SendSyncByte
; (00:17AD, exact match, instruction ratio 1.00); address and name from symbol table $2A; code that this build never
; runs (typed data)
Leftover_2C_6B49_PREAMBLETRANS::
    db $21, $4a, $c3, $4e, $34, $06, $00, $21, $3c, $2f, $09, $7e, $e0, $01, $3e, $01
    db $e0, $02, $3e, $81, $e0, $02, $fa, $4a, $c3, $fe, $02, $c0, $af, $ea, $4a, $c3
    db $3c, $ea, $40, $c3, $c9

; C: leftover: 142 bytes of code TRANSMIT of the printer library of an older build, the Japanese Prn_SendPacketByte
; (00:17D2, near match, instruction ratio 0.95); address and name from symbol table $2A; code that this build never
; runs (typed data)
Leftover_2C_6B6E_TRANSMIT::
    db $fa, $4a, $c3, $4f, $fa, $4b, $c3, $47, $fa, $4c, $c3, $6f, $fa, $4d, $c3, $67
    db $09, $f0, $01, $ea, $5a, $c3, $7e, $e0, $01, $6f, $fa, $54, $c3, $85, $ea, $54
    db $c3, $fa, $55, $c3, $ce, $00, $ea, $55, $c3, $3e, $01, $e0, $02, $3e, $81, $e0
    db $02, $21, $4a, $c3, $34, $20, $02, $23, $34, $21, $4a, $c3, $fa, $44, $c3, $be
    db $20, $07, $23, $fa, $45, $c3, $be, $28, $02, $18, $3e, $21, $41, $c3, $7e, $a7
    db $28, $03, $21, $42, $c3, $34, $fa, $5d, $c3, $a7, $28, $32, $fa, $3e, $c3, $fe
    db $06, $28, $2b, $21, $42, $c3, $7e, $a7, $20, $20, $af, $ea, $4a, $c3, $ea, $4b
    db $c3, $fa, $50, $c3, $ea, $4c, $c3, $fa, $51, $c3, $ea, $4d, $c3, $fa, $48, $c3
    db $ea, $44, $c3, $fa, $49, $c3, $ea, $45, $c3, $c9, $cd, $0f, $2c, $c9

; C: leftover: 6 bytes of code SETENDOFTRANS of the printer library of an older build, no Japanese counterpart of 0.8
; or more; address and name from symbol table $2A; code that this build never runs (typed data)
Leftover_2C_6BFC_SETENDOFTRANS::
    db $fa, $5a, $c3, $ea, $59, $c3

; C: leftover: 13 bytes of code SETENDOFTRANS_DATA of the printer library of an older build, no Japanese counterpart
; of 0.8 or more; address and name from symbol table $2A; code that this build never runs (typed data)
Leftover_2C_6C02_SETENDOFTRANS_DATA::
    db $3e, $07, $ea, $3e, $c3, $3e, $01, $ea, $56, $c3, $cd, $07, $2d

; C: leftover: 25 bytes of code FORRETRY_DATATRANS of the printer library of an older build, the Japanese
; Prn_RestoreHeaderPtr (00:1873, exact match, instruction ratio 1.00); address and name from symbol table $2A; code
; that this build never runs (typed data)
Leftover_2C_6C0F_FORRETRY_DATATRANS::
    db $fa, $46, $c3, $ea, $44, $c3, $fa, $47, $c3, $ea, $45, $c3, $fa, $4e, $c3, $ea
    db $4c, $c3, $fa, $4f, $c3, $ea, $4d, $c3, $c9

; C: leftover: 23 bytes of code TRANSCHECKSUM of the printer library of an older build, the Japanese
; Prn_SendChecksumByte (00:188C, exact match, instruction ratio 1.00); address and name from symbol table $2A; code
; that this build never runs (typed data)
Leftover_2C_6C28_TRANSCHECKSUM::
    db $4f, $06, $00, $21, $54, $c3, $09, $7e, $e0, $01, $3e, $01, $e0, $02, $3e, $81
    db $e0, $02, $21, $43, $c3, $34, $c9

; C: leftover: 26 bytes of code TRANSDUMMY of the printer library of an older build, the Japanese Prn_SendTrailerByte
; (00:18A3, exact match, instruction ratio 1.00); address and name from symbol table $2A; code that this build never
; runs (typed data)
Leftover_2C_6C3F_TRANSDUMMY::
    db $f0, $01, $ea, $59, $c3, $af, $e0, $01, $3e, $01, $e0, $02, $3e, $81, $e0, $02
    db $21, $57, $c3, $34, $7e, $fe, $02, $28, $aa, $c9

; C: leftover: 68 bytes of code GETPRINTERSTATUS of the printer library of an older build, the Japanese
; Prn_ReceiveStatus (00:18BD, near match, instruction ratio 0.90); address and name from symbol table $2A; code that
; this build never runs (typed data)
Leftover_2C_6C59_GETPRINTERSTATUS::
    db $fa, $5c, $c3, $ea, $3f, $c3, $fa, $58, $c3, $ea, $01, $c3, $fe, $ff, $28, $03
    db $ea, $00, $c3, $f0, $01, $ea, $58, $c3, $fe, $ff, $20, $0c, $3e, $00, $ea, $6c
    db $c3, $ea, $3e, $c3, $3e, $02, $18, $0f, $cb, $67, $3e, $00, $ea, $3e, $c3, $3e
    db $01, $20, $03, $ea, $3e, $c3, $3c, $ea, $56, $c3, $fa, $5d, $c3, $a7, $20, $04
    db $af, $ea, $6c, $c3

; C: leftover: 1 bytes of code SIOFORCEEND of the printer library of an older build, too short to pair with a Japanese
; routine; address and name from symbol table $2A; code that this build never runs (typed data)
Leftover_2C_6C9D_SIOFORCEEND::
    db $c9

; C: leftover: 3 bytes of code SIOERRORRET of the printer library of an older build, too short to pair with a Japanese
; routine; address and name from symbol table $2A; code that this build never runs (typed data)
Leftover_2C_6C9E_SIOERRORRET::
    db $af, $e0, $02

; C: leftover: 1 bytes of code SIOINTRET of the printer library of an older build, too short to pair with a Japanese
; routine; address and name from symbol table $2A; code that this build never runs (typed data)
Leftover_2C_6CA1_SIOINTRET::
    db $c9

; C: leftover: 62 bytes of code PRINT_PICTURE_MAKE of the printer library of an older build, no Japanese counterpart
; of 0.8 or more; address and name from symbol table $2A; code that this build never runs (typed data)
Leftover_2C_6CA2_PRINT_PICTURE_MAKE::
    db $21, $00, $c8, $01, $80, $16, $af, $22, $0d, $20, $fc, $05, $20, $f9, $cd, $b4
    db $2c, $c9, $21, $00, $90, $11, $a0, $ca, $06, $08, $cd, $cc, $2c, $21, $00, $88
    db $06, $01, $cd, $cc, $2c, $21, $00, $80, $06, $05, $0e, $00, $2a, $12, $13, $0d
    db $20, $fa, $e5, $21, $40, $00, $19, $5d, $54, $e1, $05, $20, $ed, $c9

; C: leftover: 5 bytes of code SIOHIBERNATE of the printer library of an older build, too short to pair with a
; Japanese routine; address and name from symbol table $2A; code that this build never runs (typed data)
Leftover_2C_6CE0_SIOHIBERNATE::
    db $af, $e0, $02, $e0, $01

; C: leftover: 24 bytes of code SIOINITIALIZE of the printer library of an older build, the Japanese Prn_EngineStop
; (00:1914, near match, instruction ratio 0.90); address and name from symbol table $2A; code that this build never
; runs (typed data)
Leftover_2C_6CE5_SIOINITIALIZE::
    db $af, $e0, $01, $e0, $02, $ea, $3e, $c3, $3d, $ea, $58, $c3, $ea, $59, $c3, $3e
    db $80, $ea, $38, $c3, $cd, $fd, $2c, $c9

; C: leftover: 10 bytes of code SIOFLAGINIT of the printer library of an older build, the Japanese Prn_ClearTxFlags
; (00:1927, exact match, instruction ratio 1.00); address and name from symbol table $2A; code that this build never
; runs (typed data)
Leftover_2C_6CFD_SIOFLAGINIT::
    db $af, $ea, $56, $c3, $ea, $5b, $c3, $ea, $6c, $c3

; C: leftover: 32 bytes of code CLEARFLAGS of the printer library of an older build, the Japanese Prn_ResetPacketState
; (00:1931, near match, instruction ratio 0.96); address and name from symbol table $2A; code that this build never
; runs (typed data)
Leftover_2C_6D07_CLEARFLAGS::
    db $af, $ea, $40, $c3, $ea, $41, $c3, $ea, $42, $c3, $ea, $43, $c3, $ea, $57, $c3
    db $ea, $54, $c3, $ea, $55, $c3, $ea, $4a, $c3, $ea, $4b, $c3, $ea, $6d, $c3, $c9

; C: leftover: 27 bytes of code CONNECTPRN of the printer library of an older build, the Japanese Prn_SendInit
; (00:1954, exact match, instruction ratio 1.00); address and name from symbol table $2A; code that this build never
; runs (typed data)
Leftover_2C_6D27_CONNECTPRN::
    db $fa, $6c, $c3, $a7, $28, $04, $cd, $42, $2d, $d0, $fa, $3f, $c3, $fe, $01, $20
    db $04, $cd, $42, $2d, $d0, $cd, $62, $2f, $c3, $25, $30

; C: leftover: 67 bytes of code CHECKENDOFTRANS of the printer library of an older build, the Japanese Prn_CheckTxDone
; (00:196F, near match, instruction ratio 0.81); address and name from symbol table $2A; code that this build never
; runs (typed data)
Leftover_2C_6D42_CHECKENDOFTRANS::
    db $fa, $56, $c3, $fe, $02, $20, $38, $af, $ea, $6f, $c3, $ea, $3f, $c3, $3c, $ea
    db $3e, $c3, $fa, $58, $c3, $fe, $ff, $28, $1f, $cb, $47, $20, $14, $cb, $4f, $20
    db $10, $cb, $67, $28, $18, $af, $ea, $3e, $c3, $ea, $3f, $c3, $fa, $58, $c3, $18
    db $0c, $37, $c9, $af, $ea, $3f, $c3, $3d, $3c, $ea, $3e, $c3, $3d, $a7, $c9, $af
    db $3e, $f0, $c9

; C: leftover: 51 bytes of code INSTRUCTPRN of the printer library of an older build, the Japanese Prn_SendPrint
; (00:19B2, near match, instruction ratio 0.94); address and name from symbol table $2A; code that this build never
; runs (typed data)
Leftover_2C_6D85_INSTRUCTPRN::
    db $fa, $3e, $c3, $fe, $01, $28, $0b, $fe, $02, $28, $07, $a7, $3e, $ff, $c8, $3e
    db $f0, $c9, $fa, $6c, $c3, $a7, $28, $04, $cd, $42, $2d, $d0, $fa, $3f, $c3, $fe
    db $02, $20, $04, $cd, $42, $2d, $d0, $fa, $58, $c3, $fe, $ff, $c8, $cd, $6f, $2f
    db $c3, $25, $30

; C: leftover: 254 bytes of code DATATRANSPRN of the printer library of an older build, no Japanese counterpart of 0.8
; or more; address and name from symbol table $2A; code that this build never runs (typed data)
Leftover_2C_6DB8_DATATRANSPRN::
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

; C: leftover: 51 bytes of code BREAKPRN of the printer library of an older build, the Japanese Prn_SendBreak_Dead
; (00:1AEB, exact match, instruction ratio 1.00); address and name from symbol table $2A; code that this build never
; runs (typed data)
Leftover_2C_6EB6_BREAKPRN::
    db $fa, $3e, $c3, $fe, $01, $28, $0b, $fe, $03, $28, $07, $a7, $3e, $ff, $c8, $3e
    db $f0, $c9, $fa, $6c, $c3, $a7, $28, $04, $cd, $42, $2d, $d0, $fa, $3f, $c3, $fe
    db $04, $20, $04, $cd, $42, $2d, $d0, $fa, $58, $c3, $fe, $ff, $c8, $cd, $fd, $2f
    db $c3, $25, $30

; C: leftover: 40 bytes of code NULTRANSPRN of the printer library of an older build, the Japanese Prn_SendInquiry
; (00:1B1E, exact match, instruction ratio 1.00); address and name from symbol table $2A; code that this build never
; runs (typed data)
Leftover_2C_6EE9_NULTRANSPRN::
    db $fa, $3e, $c3, $fe, $01, $28, $0b, $fe, $03, $28, $07, $a7, $3e, $ff, $c8, $3e
    db $f0, $c9, $fa, $6c, $c3, $a7, $28, $04, $cd, $42, $2d, $d0, $fa, $58, $c3, $fe
    db $ff, $c8, $cd, $0a, $30, $c3, $25, $30

; C: leftover: 43 bytes of code INITDATATRANS of the printer library of an older build, the Japanese Prn_QueuePacket
; (00:1B46, exact match, instruction ratio 1.00); address and name from symbol table $2A; code that this build never
; runs (typed data)
Leftover_2C_6F11_INITDATATRANS::
    db $ea, $5c, $c3, $7a, $ea, $5d, $c3, $7d, $ea, $4c, $c3, $ea, $4e, $c3, $7c, $ea
    db $4d, $c3, $ea, $4f, $c3, $79, $ea, $44, $c3, $ea, $46, $c3, $78, $ea, $45, $c3
    db $ea, $47, $c3, $af, $ea, $56, $c3, $cd, $07, $2d, $c9

; C: leftover: 2 bytes of data PREAMBLEDATA of the printer library of an older build, the Japanese Prn_SyncBytes
; (00:1B71, exact match, instruction ratio 1.00); address and name from symbol table $2A; nothing in this build reads
; it
Leftover_2C_6F3C_PREAMBLEDATA::
    db $88, $33

; C: leftover: 8 bytes of data PACKET1 of the printer library of an older build, the Japanese Prn_PktInit (00:1B73,
; exact match, instruction ratio 1.00); address and name from symbol table $2A; nothing in this build reads it
Leftover_2C_6F3E_PACKET1::
    db $01, $00, $00, $00, $01, $00, $00, $00

; C: leftover: 4 bytes of data PACKET2 of the printer library of an older build, the Japanese Prn_PktPrintHdr
; (00:1B7B, exact match, instruction ratio 1.00); address and name from symbol table $2A; nothing in this build reads
; it
Leftover_2C_6F46_PACKET2::
    db $02, $00, $04, $00

; C: leftover: 8 bytes of data PACKET6 of the printer library of an older build, the Japanese Prn_PktDataEnd (00:1B7F,
; exact match, instruction ratio 1.00); address and name from symbol table $2A; nothing in this build reads it
Leftover_2C_6F4A_PACKET6::
    db $04, $00, $00, $00, $04, $00, $00, $00

; C: leftover: 8 bytes of data PACKET4 of the printer library of an older build, the Japanese Prn_PktBreak (00:1B87,
; exact match, instruction ratio 1.00); address and name from symbol table $2A; nothing in this build reads it
Leftover_2C_6F52_PACKET4::
    db $08, $00, $00, $00, $08, $00, $00, $00

; C: leftover: 8 bytes of data PACKET5 of the printer library of an older build, the Japanese Prn_PktInquiry (00:1B8F,
; exact match, instruction ratio 1.00); address and name from symbol table $2A; nothing in this build reads it
Leftover_2C_6F5A_PACKET5::
    db $0f, $00, $00, $00, $0f, $00, $00, $00

; C: leftover: 13 bytes of code PREPAREPACKET1 of the printer library of an older build, the Japanese Prn_QueueInit
; (00:1B97, exact match, instruction ratio 1.00); address and name from symbol table $2A; code that this build never
; runs (typed data)
Leftover_2C_6F62_PREPAREPACKET1::
    db $3e, $01, $16, $00, $21, $3e, $2f, $01, $08, $00, $c3, $11, $2f

; C: leftover: 90 bytes of code PREPAREPACKET2 of the printer library of an older build, the Japanese Prn_QueuePrint
; (00:1BA4, near match, instruction ratio 0.83); address and name from symbol table $2A; code that this build never
; runs (typed data)
Leftover_2C_6F6F_PREPAREPACKET2::
    db $3e, $02, $16, $00, $21, $5e, $c3, $01, $0c, $00, $cd, $11, $2f, $21, $46, $2f
    db $11, $5e, $c3, $01, $04, $00, $2a, $12, $13, $0d, $20, $fa, $11, $06, $00, $fa
    db $39, $c3, $ea, $62, $c3, $cd, $c2, $2f, $fa, $3a, $c3, $ea, $63, $c3, $cd, $c2
    db $2f, $fa, $3b, $c3, $ea, $64, $c3, $cd, $c2, $2f, $fa, $38, $c3, $ea, $65, $c3
    db $cd, $c2, $2f, $7b, $ea, $66, $c3, $7a, $ea, $67, $c3, $af, $ea, $68, $c3, $ea
    db $69, $c3, $c9, $83, $5f, $7a, $ce, $00, $57, $c9

; C: leftover: 52 bytes of code PREPAREPACKET3 of the printer library of an older build, the Japanese Prn_QueueData
; (00:1BFB, exact match, instruction ratio 1.00); address and name from symbol table $2A; code that this build never
; runs (typed data)
Leftover_2C_6FC9_PREPAREPACKET3::
    db $7d, $ea, $50, $c3, $7c, $ea, $51, $c3, $79, $ea, $48, $c3, $78, $ea, $49, $c3
    db $c5, $3e, $03, $16, $01, $21, $5e, $c3, $01, $04, $00, $cd, $11, $2f, $fa, $4a
    db $2f, $ea, $5e, $c3, $fa, $3d, $c3, $ea, $5f, $c3, $c1, $79, $ea, $60, $c3, $78
    db $ea, $61, $c3, $c9

; C: leftover: 13 bytes of code PREPAREPACKET4 of the printer library of an older build, the Japanese Prn_QueueInit
; (00:1B97, near match, instruction ratio 0.80); address and name from symbol table $2A; code that this build never
; runs (typed data)
Leftover_2C_6FFD_PREPAREPACKET4::
    db $3e, $04, $16, $00, $21, $52, $2f, $01, $08, $00, $c3, $11, $2f

; C: leftover: 13 bytes of code PREPAREPACKET5 of the printer library of an older build, the Japanese Prn_QueueInquiry
; (00:1C3C, exact match, instruction ratio 1.00); address and name from symbol table $2A; code that this build never
; runs (typed data)
Leftover_2C_700A_PREPAREPACKET5::
    db $3e, $05, $16, $00, $21, $5a, $2f, $01, $08, $00, $c3, $11, $2f

; C: leftover: 14 bytes of code PREPAREPACKET6 of the printer library of an older build, the Japanese Prn_QueueDataEnd
; (00:1C49, near match, instruction ratio 0.91); address and name from symbol table $2A; code that this build never
; runs (typed data)
Leftover_2C_7017_PREPAREPACKET6::
    db $3e, $06, $16, $01, $21, $4a, $2f, $01, $08, $00, $c3, $11, $2f, $c9

; C: leftover: 60 bytes of code STARTSTRINGTRANS of the printer library of an older build, the Japanese
; Prn_StartTransmit (00:1C57, exact match, instruction ratio 1.00); address and name from symbol table $2A; code that
; this build never runs (typed data)
Leftover_2C_7025_STARTSTRINGTRANS::
    db $fa, $3e, $c3, $fe, $01, $28, $0c, $a7, $20, $07, $fa, $5c, $c3, $fe, $01, $28
    db $0c, $37, $c9, $fa, $5c, $c3, $fe, $01, $28, $f7, $ea, $3e, $c3, $af, $ea, $56
    db $c3, $ea, $3f, $c3, $3e, $01, $ea, $4a, $c3, $ea, $6c, $c3, $fa, $3c, $2f, $e0
    db $01, $3e, $01, $e0, $02, $3e, $81, $e0, $02, $3e, $f0, $c9

; C: leftover: 182 bytes of code CHG_AUTO_SET of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_7061_CHG_AUTO_SET::
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

; C: leftover: 52 bytes of code LINE_CHECK of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; code that this build never runs (typed data)
Leftover_2C_7117_LINE_CHECK::
    db $3e, $04, $e0, $88, $cd, $9f, $31, $13, $13, $cd, $9f, $31, $13, $13, $cd, $9f
    db $31, $13, $13, $cd, $9f, $31, $13, $13, $13, $13, $cd, $9f, $31, $13, $13, $cd
    db $9f, $31, $13, $13, $cd, $9f, $31, $13, $13, $cd, $9f, $31, $f0, $88, $3d, $c8
    db $e0, $88, $18, $d0

; C: leftover: 84 bytes of code SCREEN_CHECK of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_714B_SCREEN_CHECK::
    db $3e, $1c, $e0, $88, $cd, $9f, $31, $21, $14, $00, $19, $54, $5d, $cd, $9f, $31
    db $21, $14, $00, $19, $54, $5d, $cd, $9f, $31, $21, $04, $00, $19, $54, $5d, $cd
    db $9f, $31, $21, $14, $00, $19, $54, $5d, $cd, $9f, $31, $21, $14, $00, $19, $54
    db $5d, $cd, $9f, $31, $21, $04, $00, $19, $54, $5d, $cd, $9f, $31, $21, $14, $00
    db $19, $54, $5d, $cd, $9f, $31, $21, $04, $00, $19, $54, $5d, $f0, $88, $3d, $c8
    db $e0, $88, $18, $b0

; C: leftover: 25 bytes of code BIT_COUNT of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_719F_BIT_COUNT::
    db $26, $3e, $1a, $13, $6f, $6e, $26, $00, $09, $44, $4d, $26, $3e, $1a, $13, $6f
    db $6e, $cb, $25, $26, $00, $09, $44, $4d, $c9

; C: leftover: 374 bytes of code SET_DITH_MATRIX of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_71B8_SET_DITH_MATRIX::
    INCBIN "data/bank_2c/Leftover_2C_71B8_SET_DITH_MATRIX.bin" ; $71B8, 374 bytes
; C: leftover: 199 bytes of code REGISTER_SETTING of the bank 0 of an older build (the build of table $2A); address
; and name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_732E_REGISTER_SETTING::
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

; C: leftover: 131 bytes of code GET_OFFSET of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_73F5_GET_OFFSET::
    db $3e, $10, $ea, $00, $40, $06, $70, $fa, $f2, $c0, $fe, $06, $20, $02, $06, $55
    db $21, $06, $a0, $11, $30, $00, $70, $1b, $7a, $b3, $20, $fa, $af, $ea, $02, $a0
    db $3e, $21, $ea, $03, $a0, $fa, $fd, $c0, $e6, $c0, $06, $3f, $b0, $ea, $fd, $c0
    db $ea, $05, $a0, $3e, $10, $ea, $00, $40, $fa, $f8, $c0, $cb, $c7, $ea, $00, $a0
    db $fa, $00, $a0, $cb, $47, $20, $f9, $fa, $f8, $c0, $cb, $c7, $ea, $00, $a0, $fa
    db $00, $a0, $cb, $47, $20, $f9, $3e, $10, $ea, $00, $40, $fa, $f8, $c0, $cb, $c7
    db $ea, $00, $a0, $fa, $00, $a0, $cb, $47, $20, $f9, $cd, $78, $34, $b7, $20, $06
    db $cd, $98, $34, $b7, $28, $e0, $fa, $fa, $c0, $ea, $02, $a0, $fa, $fb, $c0, $ea
    db $03, $a0, $c9

; C: leftover: 32 bytes of code CHECK_BLACK of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_7478_CHECK_BLACK::
    db $af, $ea, $00, $40, $21, $70, $a7, $1e, $10, $2a, $fe, $ff, $20, $0b, $1d, $20
    db $f8, $3e, $10, $ea, $00, $40, $3e, $01, $c9, $3e, $10, $ea, $00, $40, $af, $c9

; C: leftover: 52 bytes of code OFFSET_DOWN of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_7498_OFFSET_DOWN::
    db $fa, $fd, $c0, $cb, $6f, $28, $11, $e6, $3f, $fe, $20, $28, $05, $3d, $06, $00
    db $18, $13, $3e, $01, $06, $00, $18, $0d, $e6, $1f, $fe, $1f, $20, $04, $06, $01
    db $18, $03, $3c, $06, $00, $4f, $fa, $fd, $c0, $e6, $c0, $b1, $ea, $fd, $c0, $ea
    db $05, $a0, $78, $c9

; C: leftover: 100 bytes of code TRANSFER_TO_BUF of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A, called in its bank; code that this build never runs (typed data)
Leftover_2C_74CC_TRANSFER_TO_BUF::
    db $e6, $1f, $fe, $0d, $20, $06, $cd, $3e, $20, $c3, $2f, $35, $fe, $10, $20, $06
    db $cd, $1e, $20, $c3, $2f, $35, $fe, $02, $20, $06, $cd, $fa, $20, $c3, $2f, $35
    db $fe, $08, $20, $06, $cd, $97, $22, $c3, $2f, $35, $fe, $09, $20, $06, $cd, $ca
    db $23, $c3, $2f, $35, $fe, $05, $20, $06, $cd, $fa, $24, $c3, $2f, $35, $fe, $06
    db $20, $06, $cd, $7c, $25, $c3, $2f, $35, $fe, $07, $20, $06, $cd, $1b, $26, $c3
    db $2f, $35, $af, $ea, $00, $40, $21, $00, $a1, $11, $00, $d0, $06, $0e, $cd, $e7
    db $26, $18, $00, $c9

; C: leftover: 8 bytes of data TRA_BUF_J_TBL of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A; nothing in this build reads it
Leftover_2C_7530_TRA_BUF_J_TBL::
    db $3e, $20, $1e, $20, $fa, $20, $97, $22

; C: leftover: 702 bytes of data CONT_PATTERN of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A; nothing in this build reads it
Leftover_2C_7538_CONT_PATTERN::
    INCBIN "data/bank_2c/Leftover_2C_7538_CONT_PATTERN.bin" ; $7538, 702 bytes
; C: leftover: 16 bytes of data NO_DITHER_PAT of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A; nothing in this build reads it
Leftover_2C_77F6_NO_DITHER_PAT::
    db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08

; C: leftover: 16 bytes of data BAYER_PAT of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; nothing in this build reads it
Leftover_2C_7806_BAYER_PAT::
    db $00, $08, $02, $0a, $0c, $04, $0e, $06, $03, $0b, $01, $09, $0f, $07, $0d, $05

; C: leftover: 16 bytes of data HARF_PAT of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; nothing in this build reads it
Leftover_2C_7816_HARF_PAT::
    db $0a, $04, $06, $08, $0c, $00, $01, $0e, $07, $09, $0b, $05, $03, $0f, $0d, $01

; C: leftover: 16 bytes of data SCREW_PAT of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; nothing in this build reads it
Leftover_2C_7826_SCREW_PAT::
    db $0d, $07, $06, $0c, $08, $01, $00, $05, $09, $02, $03, $04, $0e, $0a, $0b, $0f

; C: leftover: 16 bytes of data SCREW2_PAT of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; nothing in this build reads it
Leftover_2C_7836_SCREW2_PAT::
    db $0f, $04, $08, $0c, $0b, $00, $01, $05, $07, $03, $02, $09, $0e, $0a, $06, $0d

; C: leftover: 16 bytes of data TYUUKAN_PAT of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; nothing in this build reads it
Leftover_2C_7846_TYUUKAN_PAT::
    db $0c, $04, $08, $0e, $0b, $00, $02, $06, $07, $03, $01, $0a, $0f, $09, $05, $0d

; C: leftover: 96 bytes of data CONCENT_PAT of the bank 0 of an older build (the build of table $2A); address and name
; from symbol table $2A; nothing in this build reads it
Leftover_2C_7856_CONCENT_PAT::
    db $0d, $04, $08, $0e, $0a, $00, $01, $07, $06, $03, $02, $0b, $0f, $09, $05, $0c
    db $0f, $00, $0f, $00, $0f, $0f, $0f, $00, $0f, $00, $0f, $00, $00, $00, $00, $00
    db $08, $00, $08, $0f, $00, $08, $0f, $08, $08, $0f, $08, $00, $0f, $08, $00, $08
    db $0f, $00, $00, $00, $00, $0f, $00, $0f, $00, $00, $0f, $00, $00, $0f, $00, $0f
    db $07, $03, $07, $0b, $03, $00, $03, $07, $07, $03, $07, $0b, $0b, $07, $0b, $0f
    db $08, $08, $08, $00, $08, $0f, $08, $00, $08, $08, $08, $00, $00, $00, $00, $00

; C: leftover: 169 bytes of data CHG_TIME_TBL_U of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A; nothing in this build reads it
Leftover_2C_78B6_CHG_TIME_TBL_U::
    db $10, $07, $06, $06, $06, $05, $05, $05, $05, $05, $04, $04, $04, $04, $04, $04
    db $03, $03, $03, $03, $03, $03, $03, $03, $02, $02, $02, $02, $02, $02, $02, $02
    db $02, $02, $02, $02, $02, $02, $02, $02, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00

; C: leftover: 929 bytes of data CHG_TIME_TBL_D of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A; nothing in this build reads it
Leftover_2C_795F_CHG_TIME_TBL_D::
    INCBIN "data/bank_2c/Leftover_2C_795F_CHG_TIME_TBL_D.bin" ; $795F, 929 bytes
; C: leftover: 256 bytes of data MIRROR_TABLE of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A; nothing in this build reads it
Leftover_2C_7D00_MIRROR_TABLE::
    INCBIN "data/bank_2c/Leftover_2C_7D00_MIRROR_TABLE.bin" ; $7D00, 256 bytes
; C: leftover: 512 bytes of data COUNT_TABLE of the bank 0 of an older build (the build of table $2A); address and
; name from symbol table $2A; nothing in this build reads it
Leftover_2C_7E00_COUNT_TABLE::
    INCBIN "data/bank_2c/Leftover_2C_7E00_COUNT_TABLE.bin" ; $7E00, 511 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_2C_7FFF::
    db $2c
