; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $37. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $037", ROMX[$4000], BANK[$37]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_37_4000::
    db $37

; I: leftover: 91 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_37_4001::
    db $00, $7d, $00, $06, $00, $00, $a0, $04, $08, $00, $a0, $80, $5f, $01, $10, $a0
    db $5f, $01, $10, $c0, $5f, $01, $10, $e0, $5f, $01, $10, $00, $60, $01, $10, $20
    db $60, $01, $10, $40, $60, $01, $10, $60, $60, $01, $10, $80, $60, $01, $10, $a0
    db $60, $01, $10, $c0, $60, $01, $10, $e0, $60, $01, $10, $00, $61, $01, $10, $20
    db $61, $01, $10, $40, $61, $01, $10, $60, $61, $01, $10, $80, $61, $01, $10, $a0
    db $61, $01, $10, $c0, $61, $01, $10, $e0, $61, $01, $10

    ; padding
    ds $a5, $00

    db $80, $17, $c2

    ; padding
    ds $4c, $00

; C: leftover: 119 bytes of code RESET of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; code that this build never runs (typed data)
Leftover_37_4150_RESET::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00

; C: leftover: 19 bytes of code MAIN of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; code that this build never runs (typed data)
Leftover_37_41C7_MAIN::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00

; C: leftover: 12 bytes of code VBWAIT of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; code that this build never runs (typed data)
Leftover_37_41DA_VBWAIT::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; C: leftover: 30 bytes of code VBLK of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; code that this build never runs (typed data)
Leftover_37_41E6_VBLK::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $d1, $c1, $f1, $d9

; C: leftover: 124 bytes of code MAIN_SUB of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_4204_MAIN_SUB::
    db $21, $aa, $ff, $34, $fa, $a0, $c0, $b7, $20, $04, $cd, $58, $06, $c9, $fe, $01
    db $20, $04, $cd, $ef, $07, $c9, $fe, $02, $20, $04, $cd, $b5, $08, $c9, $fe, $03
    db $20, $04, $cd, $e2, $09, $c9, $fe, $04, $20, $04, $cd, $e9, $0a, $c9, $fe, $05
    db $20, $04, $cd, $8f, $0c, $c9, $fe, $06, $20, $04, $cd, $69, $12, $c9, $fe, $07
    db $20, $04, $cd, $41, $0e, $c9, $fe, $08, $20, $04, $cd, $82, $10, $c9, $fe, $09
    db $20, $04, $cd, $d4, $19, $c9, $fe, $0a, $20, $04, $cd, $db, $25, $c9, $fe, $0b
    db $20, $04, $cd, $25, $35, $c9, $fe, $0c, $20, $04, $cd, $98, $27, $c9, $fe, $0d
    db $20, $04, $cd, $ab, $29, $c9, $fe, $0e, $20, $01, $c9, $c9

; C: leftover: 63 bytes of code VBLANK_SUB of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_4280_VBLANK_SUB::
    db $cd, $b6, $ff, $fa, $a0, $c0, $fe, $06, $20, $04, $cd, $ba, $18, $c9, $fe, $04
    db $20, $04, $cd, $63, $0b, $c9, $fe, $07, $20, $04, $cd, $0b, $10, $c9, $fe, $0a
    db $20, $04, $cd, $03, $27, $c9, $fe, $09, $20, $04, $cd, $62, $1c, $c9, $fe, $0b
    db $20, $01, $c9, $fe, $0d, $20, $03, $cd, $c7, $2a, $fe, $0e, $20, $00, $c9

; C: leftover: 9 bytes of code DATA_MOV of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_42BF_DATA_MOV::
    db $2a, $12, $13, $0b, $78, $b1, $20, $f8, $c9

; C: leftover: 775 bytes of code DATA_MOV_F of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_42C8_DATA_MOV_F::
    INCBIN "data/bank_37/Leftover_37_42C8_DATA_MOV_F.bin" ; $42C8, 775 bytes
; C: leftover: 11 bytes of code DMACLR of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_45CF_DMACLR::
    db $af, $21, $00, $c0, $06, $a0, $22, $05, $20, $fc, $c9

; C: leftover: 25 bytes of code LCDCOFF of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_45DA_LCDCOFF::
    db $f0, $ff, $e0, $89, $cb, $87, $e0, $ff, $f0, $44, $fe, $91, $20, $fa, $f0, $40
    db $e6, $7f, $e0, $40, $f0, $89, $e0, $ff, $c9

; C: leftover: 49 bytes of code INKEY of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; code that this build never runs (typed data)
Leftover_37_45F3_INKEY::
    db $3e, $20, $e0, $00, $f0, $00, $f0, $00, $2f, $e6, $0f, $cb, $37, $47, $3e, $10
    db $e0, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $2f, $e6
    db $0f, $b0, $4f, $f0, $80, $a9, $a1, $e0, $81, $79, $e0, $80, $3e, $30, $e0, $00
    db $c9

; C: leftover: 10 bytes of data DMADATA of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; nothing in this build reads it
Leftover_37_4624_DMADATA::
    db $3e, $c0, $e0, $46, $3e, $40, $3d, $20, $fd, $c9

; C: leftover: 26 bytes of data CLRCHR_SET of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; nothing in this build reads it
Leftover_37_462E_CLRCHR_SET::
    db $21, $00, $c0, $11, $a5, $ff, $1a, $87, $87, $06, $00, $4f, $09, $1a, $fe, $28
    db $c8, $3c, $12, $af, $22, $22, $22, $22, $18, $f3

; C: leftover: 16 bytes of code VRAM_CLR of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_4648_VRAM_CLR::
    db $21, $00, $98, $3e, $ff, $01, $00, $08, $22, $0d, $20, $fc, $05, $20, $f9, $c9

; C: leftover: 31 bytes of code GAME_INIT of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_4658_GAME_INIT::
    db $cd, $da, $05, $cd, $48, $06, $cd, $cf, $05, $21, $d0, $c0, $af, $22, $7d, $fe
    db $f0, $20, $f9, $3e, $a0, $ea, $db, $c0, $af, $ea, $dc, $c0, $ea, $dd, $c0

; C: leftover: 155 bytes of code CAMECO_INIT of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35; code that this build never runs (typed data)
Leftover_37_4677_CAMECO_INIT::
    db $3e, $01, $ea, $e2, $c0, $21, $0b, $23, $cd, $85, $2d, $21, $24, $c1, $3e, $90
    db $16, $10, $22, $15, $20, $fc, $3e, $a0, $16, $10, $22, $15, $20, $fc, $3e, $b0
    db $16, $10, $22, $15, $20, $fc, $af, $ea, $e3, $c0, $3e, $04, $ea, $e5, $c0, $3e
    db $00, $ea, $e6, $c0, $3e, $03, $ea, $e7, $c0, $3e, $02, $ea, $e8, $c0, $3e, $00
    db $ea, $e9, $c0, $3e, $18, $ea, $eb, $c0, $3e, $00, $ea, $ea, $c0, $3e, $20, $ea
    db $ec, $c0, $3e, $08, $ea, $ed, $c0, $3e, $01, $ea, $57, $c1, $ea, $59, $c1, $3e
    db $02, $ea, $5b, $c1, $3e, $03, $ea, $5a, $c1, $af, $ea, $a6, $c0, $ea, $5c, $c1
    db $ea, $5e, $c1, $ea, $d0, $c0, $ea, $5d, $c1, $3e, $15, $ea, $e0, $c0, $cd, $ba
    db $07, $cd, $2e, $07, $cd, $13, $07, $cd, $20, $07, $3e, $04, $e0, $4b, $3e, $60
    db $e0, $4a, $3e, $01, $ea, $a0, $c0, $3e, $c7, $e0, $40

; C: leftover: 1 bytes of code INIT_END of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_4712_INIT_END::
    db $c9

; C: leftover: 13 bytes of code OBJP_DEF_SET of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_4713_OBJP_DEF_SET::
    db $3e, $e4, $e0, $48, $e0, $ac, $3e, $e4, $e0, $49, $e0, $ad, $c9

; C: leftover: 2 bytes of code BGP_DEF_SET of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_4720_BGP_DEF_SET::
    db $3e, $e4

; C: leftover: 5 bytes of code BGP_SET of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_4722_BGP_SET::
    db $e0, $47, $e0, $ae, $c9

; C: leftover: 7 bytes of code BGP_CHG of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; code that this build never runs (typed data)
Leftover_37_4727_BGP_CHG::
    db $f0, $ae, $0f, $cd, $22, $07, $c9

; C: leftover: 15 bytes of code SCYX_SET0 of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_472E_SCYX_SET0::
    db $3e, $00, $e0, $42, $e0, $a1, $e0, $a2, $3e, $00, $e0, $43, $e0, $a0, $c9

; C: leftover: 6 bytes of data SOUND_P of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; nothing in this build reads it
Leftover_37_473D_SOUND_P::
    db $3e, $3e, $ea, $60, $dc, $c9

; C: leftover: 6 bytes of data SOUND_PE of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; nothing in this build reads it
Leftover_37_4743_SOUND_PE::
    db $3e, $3f, $ea, $60, $dc, $c9

; C: leftover: 17 bytes of data MEN_FADE_CLR of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35; nothing in this build reads it
Leftover_37_4749_MEN_FADE_CLR::
    db $af, $ea, $a1, $c0, $ea, $a2, $c0, $ea, $a3, $c0, $ea, $a4, $c0, $ea, $a5, $c0
    db $c9

; C: leftover: 6 bytes of code MEN_FADE_SET of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_475A_MEN_FADE_SET::
    db $3e, $01, $ea, $a1, $c0, $c9

; C: leftover: 54 bytes of code MEN_FADE of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_4760_MEN_FADE::
    db $fa, $a1, $c0, $a7, $c8, $fa, $a2, $c0, $a7, $28, $07, $3d, $ea, $a2, $c0, $28
    db $25, $c9, $21, $a3, $c0, $34, $7e, $fe, $04, $c0, $36, $00, $f0, $ac, $cd, $a0
    db $07, $e0, $ac, $e0, $48, $f0, $ae, $cd, $a0, $07, $e0, $ae, $e0, $47, $a7, $c0
    db $3e, $05, $ea, $a2, $c0, $c9

; C: leftover: 10 bytes of code MEN_FADE_END of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35; code that this build never runs (typed data)
Leftover_37_4796_MEN_FADE_END::
    db $af, $ea, $a1, $c0, $3e, $01, $ea, $a4, $c0, $c9

; C: leftover: 26 bytes of code MEN_FADE_DEC of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_47A0_MEN_FADE_DEC::
    db $4f, $1e, $04, $06, $00, $79, $e6, $03, $28, $01, $3d, $b0, $47, $cb, $08, $cb
    db $08, $cb, $09, $cb, $09, $1d, $20, $ed, $78, $c9

; C: leftover: 37 bytes of code TITL_GAMEN of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_47BA_TITL_GAMEN::
    db $21, $01, $40, $11, $00, $80, $01, $00, $18, $cd, $bf, $02, $21, $01, $58, $11
    db $00, $98, $01, $40, $02, $cd, $bf, $02, $21, $df, $07, $11, $00, $c0, $01, $10
    db $00, $cd, $bf, $02, $c9

; C: leftover: 16 bytes of data TITLE_OBJ of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; nothing in this build reads it
Leftover_37_47DF_TITLE_OBJ::
    db $60, $4c, $10, $00, $60, $54, $12, $00, $60, $5c, $14, $00, $60, $64, $16, $00

; C: leftover: 84 bytes of code GAME_TITL of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_47EF_GAME_TITL::
    db $fa, $a6, $c0, $3c, $ea, $a6, $c0, $fe, $08, $28, $1e, $fe, $10, $20, $2e, $3e
    db $10, $ea, $02, $c0, $3e, $12, $ea, $06, $c0, $3e, $14, $ea, $0a, $c0, $3e, $16
    db $ea, $0e, $c0, $af, $ea, $a6, $c0, $18, $14, $3e, $18, $ea, $02, $c0, $3e, $1a
    db $ea, $06, $c0, $3e, $1c, $ea, $0a, $c0, $3e, $1e, $ea, $0e, $c0, $f0, $81, $e6
    db $0f, $c4, $5a, $07, $cd, $60, $07, $fa, $a4, $c0, $a7, $28, $07, $af, $ea, $bd
    db $c0, $cd, $44, $08

; C: leftover: 1 bytes of code TITL_END of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_4843_TITL_END::
    db $c9

; C: leftover: 43 bytes of code MAKE_MENU of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_4844_MAKE_MENU::
    db $cd, $da, $05, $cd, $48, $06, $cd, $cf, $05, $f0, $fd, $f5, $3e, $01, $e0, $fd
    db $ea, $00, $21, $21, $01, $40, $11, $00, $80, $01, $00, $18, $cd, $bf, $02, $21
    db $41, $5a, $11, $00, $98, $01, $40, $02, $cd, $bf, $02

; C: leftover: 58 bytes of code WANKO of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; code that this build never runs (typed data)
Leftover_37_486F_WANKO::
    db $fa, $bd, $c0, $47, $3e, $34, $e0, $88, $78, $b7, $28, $08, $3d, $47, $f0, $88
    db $c6, $10, $18, $f2, $21, $00, $c0, $f0, $88, $22, $3e, $1e, $22, $3e, $04, $22
    db $af, $22, $f0, $88, $22, $3e, $26, $22, $3e, $06, $22, $af, $22, $cd, $2e, $07
    db $cd, $13, $07, $cd, $20, $07, $3e, $c7, $e0, $40

; C: leftover: 12 bytes of code MKMENU_END of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_48A9_MKMENU_END::
    db $3e, $02, $ea, $a0, $c0, $f1, $e0, $fd, $ea, $00, $21, $c9

; C: leftover: 166 bytes of code MAIN_MENU of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_48B5_MAIN_MENU::
    db $f0, $81, $cb, $27, $da, $2a, $09, $cb, $27, $da, $39, $09, $cb, $27, $cb, $27
    db $cb, $27, $cb, $27, $cb, $27, $cb, $27, $38, $06, $cd, $5b, $09, $c3, $5a, $09
    db $3e, $08, $ea, $02, $c0, $3e, $0a, $ea, $06, $c0, $3e, $08, $e0, $a5, $af, $ea
    db $bd, $c0, $3e, $20, $e0, $88, $f0, $88, $b7, $28, $17, $3d, $e0, $88, $cd, $5b
    db $09, $f6, $ff, $e0, $a9, $76, $f0, $85, $a7, $28, $fa, $af, $e0, $85, $e0, $a9
    db $18, $e4, $fa, $00, $c0, $fe, $34, $cc, $80, $0a, $fe, $44, $cc, $a4, $09, $fe
    db $54, $cc, $7b, $25, $fe, $64, $cc, $9f, $11, $fe, $74, $cc, $2f, $29, $fe, $84
    db $cc, $c9, $34, $18, $30, $fa, $00, $c0, $fe, $84, $20, $04, $d6, $50, $18, $11
    db $c6, $10, $18, $0d, $fa, $00, $c0, $fe, $34, $20, $04, $c6, $50, $18, $02, $d6
    db $10, $ea, $00, $c0, $ea, $04, $c0, $3e, $00, $ea, $02, $c0, $3e, $02, $ea, $06
    db $c0, $3e, $18, $e0, $a5, $c9

; C: leftover: 70 bytes of code DOG_ANIME of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_495B_DOG_ANIME::
    db $f0, $a5, $a7, $20, $2f, $f0, $a6, $a7, $20, $05, $3e, $21, $e0, $a6, $c9, $21
    db $a6, $ff, $35, $f0, $a6, $fe, $20, $28, $05, $fe, $10, $28, $0c, $c9, $3e, $04
    db $ea, $02, $c0, $3e, $06, $ea, $06, $c0, $c9, $3e, $0c, $ea, $02, $c0, $3e, $0e
    db $ea, $06, $c0, $c9, $3d, $e0, $a5, $b7, $28, $01, $c9, $3e, $04, $ea, $02, $c0
    db $3e, $06, $ea, $06, $c0, $c9

; C: leftover: 1 bytes of code DEBA_BROWSE of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_49A1_DEBA_BROWSE::
    db $c9

; C: leftover: 1 bytes of code VBLK_TITL of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_49A2_VBLK_TITL::
    db $c9

; C: leftover: 1 bytes of code VBLK_MAIN of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_49A3_VBLK_MAIN::
    db $c9

; C: leftover: 9 bytes of code MAKE_BANK of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_49A4_MAKE_BANK::
    db $cd, $da, $05, $cd, $48, $06, $cd, $cf, $05

; C: leftover: 53 bytes of code CB2 of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; code that this build never runs (typed data)
Leftover_37_49AD_CB2::
    db $f0, $fd, $f5, $3e, $02, $e0, $fd, $ea, $00, $21, $21, $01, $40, $11, $00, $80
    db $01, $00, $18, $cd, $bf, $02, $21, $01, $58, $11, $00, $98, $01, $40, $02, $cd
    db $bf, $02, $3e, $c7, $e0, $40, $3e, $03, $ea, $a0, $c0, $af, $e0, $88, $f1, $e0
    db $fd, $ea, $00, $21, $c9

; C: leftover: 85 bytes of code BANK_TEST of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_49E2_BANK_TEST::
    db $f0, $81, $cb, $3f, $cb, $3f, $38, $02, $18, $09, $3e, $01, $ea, $bd, $c0, $cd
    db $44, $08, $c9, $f0, $88, $b7, $c0, $16, $01, $7a, $ea, $00, $20, $fa, $00, $40
    db $ba, $20, $0e, $fa, $ff, $7f, $ba, $20, $08, $7a, $fe, $3f, $28, $16, $14, $18
    db $e8, $cd, $da, $05, $3e, $ce, $ea, $cc, $98, $3e, $c7, $ea, $cd, $98, $3e, $c1
    db $e0, $40, $18, $11, $cd, $da, $05, $3e, $cf, $ea, $cc, $98, $3e, $cb, $ea, $cd
    db $98, $3e, $c1, $e0, $40

; C: leftover: 72 bytes of code TEST4M of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; code that this build never runs (typed data)
Leftover_37_4A37_TEST4M::
    db $16, $01, $0e, $01, $7a, $ea, $00, $20, $fa, $00, $40, $b9, $20, $12, $fa, $ff
    db $7f, $b9, $20, $0c, $7a, $fe, $3f, $28, $1a, $14, $7a, $e6, $1f, $4f, $18, $e4
    db $cd, $da, $05, $3e, $ce, $ea, $0c, $99, $3e, $c7, $ea, $0d, $99, $3e, $c1, $e0
    db $40, $18, $11, $cd, $da, $05, $3e, $cf, $ea, $0c, $99, $3e, $cb, $ea, $0d, $99
    db $3e, $c1, $e0, $40, $3e, $ff, $e0, $88

; C: leftover: 1 bytes of code B_T_END of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; code that this build never runs (typed data)
Leftover_37_4A7F_B_T_END::
    db $c9

; C: leftover: 105 bytes of code MK_SRAM_MENU of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_4A80_MK_SRAM_MENU::
    db $cd, $da, $05, $cd, $48, $06, $cd, $cf, $05, $3e, $02, $ea, $00, $20, $21, $01
    db $40, $11, $00, $80, $01, $00, $18, $cd, $bf, $02, $21, $41, $5a, $11, $00, $98
    db $01, $40, $02, $cd, $bf, $02, $fa, $bd, $c0, $47, $3e, $3c, $e0, $88, $78, $b7
    db $28, $08, $3d, $47, $f0, $88, $c6, $10, $18, $f2, $21, $00, $c0, $f0, $88, $22
    db $3e, $2e, $22, $af, $22, $22, $f0, $88, $22, $3e, $36, $22, $3e, $02, $22, $af
    db $22, $e0, $a6, $ea, $d2, $c0, $cd, $2e, $07, $cd, $13, $07, $cd, $20, $07, $3e
    db $c7, $e0, $40, $3e, $04, $ea, $a0, $c0, $c9

; C: leftover: 122 bytes of code SRAM_MENU of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_4AE9_SRAM_MENU::
    db $f0, $81, $cb, $27, $38, $4d, $cb, $27, $38, $58, $cb, $27, $cb, $27, $cb, $27
    db $cb, $27, $cb, $27, $38, $09, $cb, $27, $38, $0e, $cd, $e5, $0c, $18, $5a, $af
    db $ea, $bd, $c0, $cd, $44, $08, $18, $51, $af, $ea, $d2, $c0, $fa, $00, $c0, $fe
    db $3c, $20, $05, $cd, $b2, $0b, $18, $19, $fe, $4c, $20, $05, $cd, $fa, $0b, $18
    db $10, $fe, $5c, $20, $09, $3e, $35, $e0, $88, $cd, $32, $0c, $18, $03, $cd, $3b
    db $10, $18, $26, $fa, $00, $c0, $fe, $6c, $20, $04, $d6, $30, $18, $11, $c6, $10
    db $18, $0d, $fa, $00, $c0, $fe, $3c, $20, $04, $c6, $30, $18, $02, $d6, $10, $ea
    db $00, $c0, $ea, $04, $c0, $af, $ea, $d2, $c0, $c9

; C: leftover: 78 bytes of code VB_SRAM_MENU of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_4B63_VB_SRAM_MENU::
    db $fa, $d2, $c0, $b7, $20, $13, $3e, $a0, $ea, $ce, $98, $ea, $cf, $98, $ea, $0d
    db $99, $ea, $0e, $99, $ea, $0f, $99, $18, $35, $fe, $01, $20, $0c, $3e, $cf, $ea
    db $ce, $98, $3e, $cb, $ea, $cf, $98, $18, $25, $fe, $02, $20, $0c, $3e, $ce, $ea
    db $ce, $98, $3e, $c7, $ea, $cf, $98, $18, $15, $fe, $03, $20, $11, $3e, $38, $ea
    db $0d, $99, $3e, $39, $ea, $0e, $99, $3e, $3a, $ea, $0f, $99, $18, $00

; C: leftover: 1 bytes of code SRAM_VB_END of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_4BB1_SRAM_VB_END::
    db $c9

; C: leftover: 72 bytes of code SRAM_VERIFY of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_4BB2_SRAM_VERIFY::
    db $16, $00, $01, $aa, $55, $3e, $01, $ea, $00, $60, $f6, $ff, $e0, $a9, $f0, $85
    db $a7, $28, $fb, $af, $e0, $85, $e0, $a9, $21, $00, $a0, $7a, $ea, $00, $40, $2a
    db $b8, $20, $1f, $2a, $b9, $20, $1b, $0d, $79, $fe, $ff, $20, $01, $05, $7c, $fe
    db $c0, $20, $ec, $7a, $fe, $0f, $28, $03, $14, $18, $cf, $3e, $01, $ea, $d2, $c0
    db $fb, $c9, $3e, $02, $ea, $d2, $c0, $c9

; C: leftover: 56 bytes of code SRAM_WRITE of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_4BFA_SRAM_WRITE::
    db $16, $00, $01, $aa, $55, $f6, $ff, $e0, $a9, $f0, $85, $a7, $28, $fb, $af, $e0
    db $85, $e0, $a9, $21, $00, $a0, $7a, $ea, $00, $40, $78, $22, $79, $22, $0d, $79
    db $fe, $ff, $20, $01, $05, $7c, $fe, $c0, $20, $f0, $7a, $fe, $0f, $28, $03, $14
    db $18, $d3, $3e, $03, $ea, $d2, $c0, $c9

; C: leftover: 93 bytes of code MK_SRAM_DATA of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_4C32_MK_SRAM_DATA::
    db $cd, $da, $05, $cd, $48, $06, $cd, $cf, $05, $f0, $fd, $f5, $3e, $02, $e0, $fd
    db $ea, $00, $21, $21, $01, $40, $11, $00, $80, $01, $00, $18, $cd, $bf, $02, $21
    db $81, $5c, $11, $00, $98, $01, $40, $02, $cd, $bf, $02, $21, $00, $c0, $f0, $88
    db $22, $3e, $1e, $22, $af, $22, $22, $f0, $88, $22, $3e, $26, $22, $3e, $02, $22
    db $af, $22, $e0, $a6, $cd, $2e, $07, $cd, $13, $07, $cd, $20, $07, $3e, $c7, $e0
    db $40, $3e, $05, $ea, $a0, $c0, $f1, $e0, $fd, $ea, $00, $21, $c9

; C: leftover: 86 bytes of code SRAM_DATA_SEL of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_4C8F_SRAM_DATA_SEL::
    db $f0, $81, $cb, $27, $38, $2d, $cb, $27, $38, $38, $cb, $27, $cb, $27, $cb, $27
    db $cb, $27, $cb, $27, $38, $09, $cb, $27, $38, $0f, $cd, $e5, $0c, $18, $36, $3e
    db $02, $ea, $bd, $c0, $cd, $80, $0a, $18, $2c, $fa, $00, $c0, $e0, $88, $cd, $69
    db $0d, $18, $22, $fa, $00, $c0, $fe, $75, $20, $04, $d6, $40, $18, $11, $c6, $10
    db $18, $0d, $fa, $00, $c0, $fe, $35, $20, $04, $c6, $40, $18, $02, $d6, $10, $ea
    db $00, $c0, $ea, $04, $c0, $c9

; C: leftover: 132 bytes of code KAO_ANIME of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_4CE5_KAO_ANIME::
    db $f0, $a6, $3c, $fe, $40, $20, $01, $af, $e0, $a6, $fe, $00, $20, $0d, $0e, $00
    db $16, $02, $af, $ea, $03, $c0, $ea, $07, $c0, $18, $60, $fe, $04, $20, $06, $0e
    db $04, $16, $06, $18, $56, $fe, $08, $20, $06, $0e, $08, $16, $0a, $18, $4c, $fe
    db $0c, $20, $06, $0e, $0c, $16, $0e, $18, $42, $fe, $10, $20, $06, $0e, $10, $16
    db $12, $18, $38, $fe, $14, $20, $06, $0e, $14, $16, $16, $18, $2e, $fe, $30, $20
    db $0e, $0e, $12, $16, $10, $3e, $20, $ea, $03, $c0, $ea, $07, $c0, $18, $1c, $fe
    db $34, $20, $06, $0e, $0e, $16, $0c, $18, $12, $fe, $38, $20, $06, $0e, $0a, $16
    db $08, $18, $08, $fe, $3c, $20, $0c, $0e, $06, $16, $04, $79, $ea, $02, $c0, $7a
    db $ea, $06, $c0, $c9

; C: leftover: 95 bytes of code MK_SRAM_AGING of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_4D69_MK_SRAM_AGING::
    db $cd, $da, $05, $cd, $48, $06, $cd, $cf, $05, $f0, $fd, $f5, $3e, $02, $e0, $fd
    db $ea, $00, $21, $21, $01, $40, $11, $00, $80, $01, $00, $18, $cd, $bf, $02, $21
    db $c1, $5e, $11, $00, $98, $01, $40, $02, $cd, $bf, $02, $01, $a7, $98, $f0, $88
    db $fe, $35, $20, $05, $21, $0a, $0e, $18, $26, $fe, $45, $20, $05, $21, $15, $0e
    db $18, $1d, $fe, $55, $20, $05, $21, $20, $0e, $18, $14, $fe, $65, $20, $05, $21
    db $2b, $0e, $18, $0b, $fe, $75, $20, $05, $21, $36, $0e, $18, $02, $18, $0a

; C: leftover: 10 bytes of code PAT_SET of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_4DC8_PAT_SET::
    db $16, $0b, $2a, $02, $03, $15, $7a, $b7, $20, $f8

; C: leftover: 56 bytes of code PAT_END of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_4DD2_PAT_END::
    db $cd, $2e, $07, $cd, $13, $07, $cd, $20, $07, $0e, $00, $06, $aa, $21, $00, $9c
    db $78, $22, $0c, $79, $b7, $20, $f9, $af, $e0, $4b, $3e, $50, $e0, $4a, $3e, $e7
    db $e0, $40, $3e, $07, $ea, $a0, $c0, $af, $ea, $d4, $c0, $ea, $d3, $c0, $ea, $da
    db $c0, $f1, $e0, $fd, $ea, $00, $21, $c9

; C: leftover: 11 bytes of data PAT_DEC of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; nothing in this build reads it
Leftover_37_4E0A_PAT_DEC::
    db $c4, $c5, $c3, $d2, $c5, $cd, $c5, $ce, $d4, $a0, $a0

; C: leftover: 11 bytes of data PAT_0F of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; nothing in this build reads it
Leftover_37_4E15_PAT_0F::
    db $80, $80, $ab, $80, $80, $ab, $8f, $8f, $ab, $8f, $8f

; C: leftover: 11 bytes of data PAT_5A of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; nothing in this build reads it
Leftover_37_4E20_PAT_5A::
    db $85, $85, $ab, $85, $85, $ab, $8a, $8a, $ab, $8a, $8a

; C: leftover: 11 bytes of data PAT_00 of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; nothing in this build reads it
Leftover_37_4E2B_PAT_00::
    db $c1, $cc, $cc, $a0, $80, $80, $a0, $a0, $a0, $a0, $a0

; C: leftover: 11 bytes of data PAT_FF of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; nothing in this build reads it
Leftover_37_4E36_PAT_FF::
    db $c1, $cc, $cc, $a0, $8f, $8f, $a0, $a0, $a0, $a0, $a0

; C: leftover: 148 bytes of code SRAM_AGING of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_4E41_SRAM_AGING::
    db $f0, $81, $cb, $3f, $cb, $3f, $38, $02, $18, $04, $cd, $32, $0c, $c9, $fa, $da
    db $c0, $b7, $c0, $f0, $88, $fe, $35, $20, $05, $cd, $d5, $0e, $18, $34, $fe, $45
    db $20, $09, $06, $00, $0e, $ff, $cd, $50, $0f, $18, $27, $fe, $55, $20, $09, $06
    db $55, $0e, $aa, $cd, $50, $0f, $18, $1a, $fe, $65, $20, $09, $06, $00, $0e, $00
    db $cd, $50, $0f, $18, $0d, $fe, $75, $20, $09, $06, $ff, $0e, $ff, $cd, $50, $0f
    db $18, $00, $fa, $da, $c0, $b7, $20, $3b, $fa, $d4, $c0, $67, $fa, $d3, $c0, $6f
    db $23, $7c, $ea, $d4, $c0, $7d, $ea, $d3, $c0, $06, $5a, $16, $00, $3e, $01, $ea
    db $00, $60, $21, $00, $a0, $7a, $ea, $00, $40, $78, $22, $22, $22, $22, $22, $22
    db $22, $22, $7d, $b7, $20, $f3, $7c, $fe, $c0, $20, $ee, $7a, $fe, $0f, $28, $03
    db $14, $18, $df, $c9

; C: leftover: 123 bytes of code AGE_DEC of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_4ED5_AGE_DEC::
    db $16, $00, $01, $aa, $55, $3e, $01, $ea, $00, $60, $21, $00, $a0, $7a, $ea, $00
    db $40, $78, $22, $79, $22, $0d, $79, $fe, $ff, $20, $01, $05, $7d, $b7, $20, $f1
    db $7c, $fe, $c0, $20, $ec, $7a, $fe, $0f, $28, $03, $14, $18, $dd, $16, $00, $01
    db $aa, $55, $21, $00, $a0, $7a, $ea, $00, $40, $2a, $b8, $20, $1e, $2a, $b9, $20
    db $23, $0d, $79, $fe, $ff, $20, $01, $05, $7d, $b7, $20, $ed, $7c, $fe, $c0, $20
    db $e8, $7a, $fe, $0f, $28, $03, $14, $18, $d9, $fb, $c9, $ea, $d5, $c0, $78, $ea
    db $d6, $c0, $18, $07, $ea, $d5, $c0, $79, $ea, $d6, $c0, $7a, $ea, $d7, $c0, $2b
    db $7c, $ea, $d8, $c0, $7d, $ea, $d9, $c0, $c3, $c1, $0f

; C: leftover: 113 bytes of code AGE_OTHER of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_4F50_AGE_OTHER::
    db $16, $00, $3e, $01, $ea, $00, $60, $21, $00, $a0, $7a, $ea, $00, $40, $78, $22
    db $22, $79, $22, $22, $7d, $b7, $20, $f6, $7c, $fe, $c0, $20, $f1, $7a, $fe, $0f
    db $28, $03, $14, $18, $e2, $16, $00, $21, $00, $a0, $7a, $ea, $00, $40, $2a, $b8
    db $20, $1e, $2a, $b8, $20, $1a, $2a, $b9, $20, $1f, $2a, $b9, $20, $1b, $7d, $b7
    db $20, $ec, $7c, $fe, $c0, $20, $e7, $7a, $fe, $0f, $28, $03, $14, $18, $d8, $c9
    db $ea, $d5, $c0, $78, $ea, $d6, $c0, $18, $07, $ea, $d5, $c0, $79, $ea, $d6, $c0
    db $7a, $ea, $d7, $c0, $2b, $7c, $ea, $d8, $c0, $7d, $ea, $d9, $c0, $c3, $c1, $0f
    db $c9

; C: leftover: 55 bytes of code AGING_ERROR of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_4FC1_AGING_ERROR::
    db $cd, $da, $05, $21, $c3, $99, $fa, $d7, $c0, $47, $cd, $f8, $0f, $23, $fa, $d8
    db $c0, $47, $cd, $f8, $0f, $fa, $d9, $c0, $47, $cd, $f8, $0f, $23, $23, $fa, $d6
    db $c0, $47, $cd, $f8, $0f, $23, $fa, $d5, $c0, $47, $cd, $f8, $0f, $3e, $c7, $e0
    db $40, $3e, $ff, $ea, $da, $c0, $c9

; C: leftover: 19 bytes of code PUT_BYTE of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_4FF8_PUT_BYTE::
    db $78, $cb, $3f, $cb, $3f, $cb, $3f, $cb, $3f, $c6, $80, $22, $78, $e6, $0f, $c6
    db $80, $22, $c9

; C: leftover: 48 bytes of code VB_SRAM_AGING of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_500B_VB_SRAM_AGING::
    db $21, $e8, $98, $fa, $d4, $c0, $cb, $3f, $cb, $3f, $cb, $3f, $cb, $3f, $c6, $80
    db $22, $fa, $d4, $c0, $e6, $0f, $c6, $80, $22, $fa, $d3, $c0, $cb, $3f, $cb, $3f
    db $cb, $3f, $cb, $3f, $c6, $80, $22, $fa, $d3, $c0, $e6, $0f, $c6, $80, $22, $c9

; C: leftover: 71 bytes of code MK_SRAM_DUMP of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_503B_MK_SRAM_DUMP::
    db $cd, $da, $05, $cd, $48, $06, $cd, $cf, $05, $f0, $fd, $f5, $3e, $02, $e0, $fd
    db $ea, $00, $21, $21, $01, $40, $11, $00, $80, $01, $00, $18, $cd, $bf, $02, $21
    db $01, $61, $11, $00, $98, $01, $40, $02, $cd, $bf, $02, $cd, $2e, $07, $cd, $13
    db $07, $cd, $20, $07, $3e, $c7, $e0, $40, $3e, $08, $ea, $a0, $c0, $f1, $e0, $fd
    db $ea, $00, $21, $cd, $4f, $11, $c9

; C: leftover: 167 bytes of code SRAM_DUMP of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_5082_SRAM_DUMP::
    db $f0, $81, $cb, $27, $38, $24, $cb, $27, $38, $4b, $cb, $27, $38, $72, $cb, $27
    db $da, $15, $11, $cb, $27, $cb, $27, $cb, $27, $38, $05, $cb, $27, $c3, $28, $11
    db $3e, $03, $ea, $bd, $c0, $cd, $80, $0a, $18, $7c, $fa, $db, $c0, $67, $fa, $dc
    db $c0, $6f, $7c, $fe, $bf, $20, $0d, $7d, $fe, $80, $20, $08, $3e, $a0, $67, $3e
    db $00, $6f, $18, $04, $01, $80, $00, $09, $7c, $ea, $db, $c0, $7d, $ea, $dc, $c0
    db $cd, $4f, $11, $18, $51, $fa, $db, $c0, $67, $fa, $dc, $c0, $6f, $7c, $fe, $a0
    db $20, $0d, $7d, $fe, $00, $20, $08, $3e, $bf, $67, $3e, $80, $6f, $18, $04, $01
    db $80, $ff, $09, $7c, $ea, $db, $c0, $7d, $ea, $dc, $c0, $cd, $4f, $11, $18, $26
    db $fa, $dd, $c0, $b7, $20, $04, $3e, $0f, $18, $01, $3d, $ea, $dd, $c0, $cd, $4f
    db $11, $18, $13, $fa, $dd, $c0, $fe, $0f, $20, $03, $af, $18, $01, $3c, $ea, $dd
    db $c0, $cd, $4f, $11, $18, $00, $c9

; C: leftover: 19 bytes of code PUT_BYTE2 of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_5129_PUT_BYTE2::
    db $78, $cb, $3f, $cb, $3f, $cb, $3f, $cb, $3f, $c6, $50, $22, $78, $e6, $0f, $c6
    db $50, $22, $c9

; C: leftover: 19 bytes of code PUT_BYTE3 of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_513C_PUT_BYTE3::
    db $78, $cb, $3f, $cb, $3f, $cb, $3f, $cb, $3f, $c6, $60, $22, $78, $e6, $0f, $c6
    db $70, $22, $c9

; C: leftover: 80 bytes of code DUMP_1MEN of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_514F_DUMP_1MEN::
    db $cd, $da, $05, $fa, $dd, $c0, $47, $21, $11, $98, $cd, $f8, $0f, $fa, $db, $c0
    db $57, $fa, $dc, $c0, $5f, $21, $40, $98, $fa, $dd, $c0, $ea, $00, $40, $3e, $10
    db $e0, $89, $42, $cd, $29, $11, $43, $cd, $29, $11, $0e, $08, $1a, $47, $cd, $3c
    db $11, $13, $0d, $79, $b7, $20, $f5, $23, $23, $23, $23, $23, $23, $23, $23, $23
    db $23, $23, $23, $f0, $89, $3d, $e0, $89, $b7, $20, $d7, $3e, $c7, $e0, $40, $c9

; C: leftover: 110 bytes of code MAKE_MOVIE of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_519F_MAKE_MOVIE::
    db $cd, $da, $05, $cd, $48, $06, $cd, $cf, $05, $f0, $fd, $f5, $3e, $03, $e0, $fd
    db $ea, $00, $21, $21, $01, $40, $11, $00, $80, $01, $00, $18, $cd, $bf, $02, $21
    db $01, $58, $11, $00, $98, $01, $40, $02, $cd, $bf, $02, $fa, $5a, $c1, $cd, $94
    db $16, $fa, $5b, $c1, $cd, $a5, $16, $fa, $5d, $c1, $cd, $b6, $16, $fa, $d1, $c0
    db $cd, $cd, $16, $f1, $e0, $fd, $ea, $00, $21, $cd, $2e, $07, $cd, $13, $07, $cd
    db $20, $07, $21, $c4, $c0, $af, $22, $3e, $88, $77, $21, $c6, $c0, $af, $22, $3e
    db $d0, $22, $fa, $c3, $c0, $f5, $3e, $10, $ea, $c3, $c0, $ea, $00, $40

; C: leftover: 92 bytes of code PARA_SET of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_520D_PARA_SET::
    db $cd, $ec, $16, $f0, $88, $ea, $ee, $c0, $f0, $89, $ea, $01, $a0, $f0, $8a, $ea
    db $02, $a0, $f0, $8b, $ea, $03, $a0, $f0, $8c, $ea, $04, $a0, $f0, $8d, $ea, $05
    db $a0, $cd, $33, $2d, $cd, $2c, $15, $fa, $ee, $c0, $f6, $01, $ea, $00, $a0, $f1
    db $ea, $c3, $c0, $ea, $00, $40, $3e, $e4, $e0, $47, $cd, $95, $13, $3e, $01, $ea
    db $c9, $c0, $3e, $01, $e0, $ff, $af, $ea, $c2, $c0, $3e, $08, $e0, $41, $3e, $06
    db $ea, $a0, $c0, $3e, $c3, $e0, $40, $af, $ea, $de, $c0, $c9

; C: leftover: 300 bytes of code MOVIE_MODE of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_5269_MOVIE_MODE::
    INCBIN "data/bank_37/Leftover_37_5269_MOVIE_MODE.bin" ; $5269, 300 bytes
; C: leftover: 225 bytes of code GET_A_IMMAGE of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_5395_GET_A_IMMAGE::
    db $f3, $fa, $c3, $c0, $f5, $3e, $10, $ea, $c3, $c0, $ea, $00, $40, $fa, $00, $a0
    db $e6, $01, $20, $f9, $f1, $ea, $c3, $c0, $ea, $00, $40, $fa, $5d, $c1, $fe, $11
    db $20, $06, $cd, $f2, $2e, $c3, $27, $14, $fe, $21, $20, $06, $cd, $d2, $2e, $c3
    db $27, $14, $e6, $f0, $fe, $30, $20, $06, $cd, $ae, $2f, $c3, $27, $14, $fe, $40
    db $20, $06, $cd, $79, $30, $c3, $27, $14, $fe, $50, $20, $06, $cd, $ac, $31, $c3
    db $27, $14, $fe, $60, $20, $06, $cd, $dc, $32, $c3, $27, $14, $fe, $70, $20, $06
    db $cd, $5e, $33, $c3, $27, $14, $fe, $80, $20, $06, $cd, $fd, $33, $c3, $27, $14
    db $fa, $c3, $c0, $f5, $3e, $00, $ea, $c3, $c0, $ea, $00, $40, $21, $00, $a0, $11
    db $00, $d0, $01, $00, $0e, $cd, $c8, $02, $f1, $ea, $c3, $c0, $ea, $00, $40, $c3
    db $27, $14, $fa, $c3, $c0, $f5, $3e, $10, $ea, $c3, $c0, $ea, $00, $40, $cd, $1a
    db $2c, $fa, $e3, $c0, $b7, $28, $03, $cd, $76, $14, $fa, $e1, $c0, $b7, $28, $10
    db $fa, $eb, $c0, $ea, $02, $a0, $fa, $ea, $c0, $ea, $03, $a0, $af, $ea, $e1, $c0
    db $fa, $5c, $c1, $b7, $28, $07, $cd, $2c, $15, $af, $ea, $5c, $c1, $fa, $ee, $c0
    db $f6, $01, $ea, $00, $a0, $f1, $ea, $c3, $c0, $ea, $00, $40, $fb, $cd, $ad, $18
    db $c9

; C: leftover: 94 bytes of code SET_YURAGI of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_5476_SET_YURAGI::
    db $fa, $56, $c1, $b7, $20, $58, $fa, $e4, $c0, $b7, $20, $29, $fa, $e2, $c0, $b7
    db $c8, $fe, $01, $20, $05, $21, $6b, $23, $18, $0f, $fe, $02, $20, $05, $21, $2b
    db $24, $18, $06, $fe, $03, $c0, $21, $eb, $24, $cd, $85, $2d, $cd, $2c, $15, $3e
    db $01, $ea, $e4, $c0, $c9, $fa, $e2, $c0, $b7, $c8, $fe, $01, $20, $05, $21, $db
    db $22, $18, $0f, $fe, $02, $20, $05, $21, $fb, $23, $18, $06, $fe, $03, $c0, $21
    db $bb, $24, $cd, $85, $2d, $cd, $2c, $15, $3e, $00, $ea, $e4, $c0, $c9

; C: leftover: 88 bytes of code YURAGI_DARK_MODE of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35; code that this build never runs (typed data)
Leftover_37_54D4_YURAGI_DARK_MODE::
    db $fa, $e4, $c0, $b7, $20, $29, $fa, $e2, $c0, $b7, $c8, $fe, $01, $20, $05, $21
    db $cb, $23, $18, $0f, $fe, $02, $20, $05, $21, $8b, $24, $18, $06, $fe, $03, $c0
    db $21, $4b, $25, $cd, $85, $2d, $cd, $2c, $15, $3e, $01, $ea, $e4, $c0, $c9, $fa
    db $e2, $c0, $b7, $c8, $fe, $01, $20, $05, $21, $9b, $23, $18, $0f, $fe, $02, $20
    db $05, $21, $5b, $24, $18, $06, $fe, $03, $c0, $21, $1b, $25, $cd, $85, $2d, $cd
    db $2c, $15, $3e, $00, $ea, $e4, $c0, $c9

; C: leftover: 196 bytes of code SET_TH of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_552C_SET_TH::
    db $21, $06, $a0, $fa, $f4, $c0, $22, $fa, $04, $c1, $22, $fa, $14, $c1, $22, $fa
    db $f5, $c0, $22, $fa, $05, $c1, $22, $fa, $15, $c1, $22, $fa, $f6, $c0, $22, $fa
    db $06, $c1, $22, $fa, $16, $c1, $22, $fa, $f7, $c0, $22, $fa, $07, $c1, $22, $fa
    db $17, $c1, $22, $fa, $f8, $c0, $22, $fa, $08, $c1, $22, $fa, $18, $c1, $22, $fa
    db $f9, $c0, $22, $fa, $09, $c1, $22, $fa, $19, $c1, $22, $fa, $fa, $c0, $22, $fa
    db $0a, $c1, $22, $fa, $1a, $c1, $22, $fa, $fb, $c0, $22, $fa, $0b, $c1, $22, $fa
    db $1b, $c1, $22, $fa, $fc, $c0, $22, $fa, $0c, $c1, $22, $fa, $1c, $c1, $22, $fa
    db $fd, $c0, $22, $fa, $0d, $c1, $22, $fa, $1d, $c1, $22, $fa, $fe, $c0, $22, $fa
    db $0e, $c1, $22, $fa, $1e, $c1, $22, $fa, $ff, $c0, $22, $fa, $0f, $c1, $22, $fa
    db $1f, $c1, $22, $fa, $00, $c1, $22, $fa, $10, $c1, $22, $fa, $20, $c1, $22, $fa
    db $01, $c1, $22, $fa, $11, $c1, $22, $fa, $21, $c1, $22, $fa, $02, $c1, $22, $fa
    db $12, $c1, $22, $fa, $22, $c1, $22, $fa, $03, $c1, $22, $fa, $13, $c1, $22, $fa
    db $23, $c1, $22, $c9

; C: leftover: 129 bytes of code MOVIE_OBJ_SET of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35; code that this build never runs (typed data)
Leftover_37_55F0_MOVIE_OBJ_SET::
    db $11, $00, $c0, $01, $14, $00, $fa, $57, $c1, $b7, $20, $05, $21, $c4, $18, $18
    db $2d, $fe, $01, $20, $05, $21, $d8, $18, $18, $24, $fe, $02, $20, $05, $21, $ec
    db $18, $18, $1b, $fe, $03, $20, $05, $21, $00, $19, $18, $12, $fe, $04, $20, $05
    db $21, $14, $19, $18, $09, $fe, $05, $20, $08, $21, $28, $19, $18, $00, $cd, $bf
    db $02, $fa, $57, $c1, $b7, $20, $02, $18, $37, $fe, $01, $20, $07, $fa, $ef, $c0
    db $cd, $71, $16, $c9, $fe, $02, $20, $07, $fa, $f0, $c0, $cd, $71, $16, $c9, $fe
    db $03, $20, $07, $fa, $f1, $c0, $cd, $71, $16, $c9, $fe, $04, $20, $07, $fa, $f2
    db $c0, $cd, $71, $16, $c9, $fe, $05, $20, $07, $fa, $f3, $c0, $cd, $71, $16, $c9
    db $c9

; C: leftover: 35 bytes of data PUT_BYTE_OBJ of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; nothing in this build reads it
Leftover_37_5671_PUT_BYTE_OBJ::
    db $47, $21, $14, $c0, $3e, $10, $22, $3e, $30, $22, $78, $cb, $3f, $cb, $3f, $cb
    db $3f, $cb, $3f, $22, $af, $22, $3e, $10, $22, $3e, $38, $22, $78, $e6, $0f, $22
    db $af, $22, $c9

; C: leftover: 17 bytes of code AKARUSA_HYOUJI of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_5694_AKARUSA_HYOUJI::
    db $47, $21, $1c, $c0, $3e, $54, $22, $3e, $0c, $22, $78, $e6, $0f, $22, $af, $22
    db $c9

; C: leftover: 17 bytes of code CONTRAST_HYOUJI of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_56A5_CONTRAST_HYOUJI::
    db $47, $21, $20, $c0, $3e, $95, $22, $3e, $58, $22, $78, $e6, $0f, $22, $af, $22
    db $c9

; C: leftover: 23 bytes of code BUNKATU_HYOUJI of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_56B6_BUNKATU_HYOUJI::
    db $47, $21, $24, $c0, $3e, $10, $22, $3e, $90, $22, $78, $cb, $3f, $cb, $3f, $cb
    db $3f, $cb, $3f, $22, $af, $22, $c9

; C: leftover: 31 bytes of code TEST_HYOUJI of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_56CD_TEST_HYOUJI::
    db $47, $21, $28, $c0, $3e, $10, $22, $3e, $30, $22, $78, $cb, $37, $e6, $0f, $22
    db $af, $22, $3e, $10, $22, $3e, $38, $22, $78, $e6, $0f, $22, $af, $22, $c9

; C: leftover: 238 bytes of code PARAMETER_SETTING of the bank 0 of an older build (the build of table $35); address
; and name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_56EC_PARAMETER_SETTING::
    db $af, $e0, $88, $e0, $89, $e0, $8a, $e0, $8b, $e0, $8c, $e0, $8d, $fa, $e5, $c0
    db $fe, $00, $20, $02, $18, $6a, $fe, $01, $20, $06, $3e, $02, $e0, $88, $18, $60
    db $fe, $02, $20, $0a, $3e, $02, $e0, $88, $3e, $20, $e0, $89, $18, $52, $fe, $03
    db $20, $0a, $3e, $02, $e0, $88, $3e, $c0, $e0, $89, $18, $44, $fe, $04, $20, $06
    db $3e, $e0, $e0, $89, $18, $3a, $fe, $05, $20, $0e, $3e, $02, $e0, $88, $3e, $20
    db $e0, $89, $3e, $80, $e0, $8c, $18, $28, $fe, $06, $20, $0e, $3e, $02, $e0, $88
    db $3e, $c0, $e0, $89, $3e, $80, $e0, $8c, $18, $16, $fe, $07, $20, $0e, $3e, $02
    db $e0, $88, $3e, $e0, $e0, $89, $3e, $80, $e0, $8c, $18, $04, $3e, $40, $e0, $88
    db $fa, $e6, $c0, $cb, $37, $47, $f0, $8c, $b0, $e0, $8c, $fa, $e7, $c0, $47, $f0
    db $8c, $b0, $e0, $8c, $fa, $e8, $c0, $cb, $37, $cb, $27, $cb, $27, $e0, $8d, $fa
    db $e9, $c0, $cb, $27, $cb, $27, $cb, $27, $47, $f0, $8c, $b0, $e0, $8c, $fa, $eb
    db $c0, $e0, $8a, $fa, $ea, $c0, $e0, $8b, $fa, $ec, $c0, $47, $f0, $8d, $b0, $e0
    db $8d, $fa, $ed, $c0, $47, $f0, $89, $b0, $e0, $89, $c9, $fa, $c8, $c0, $fe, $00
    db $28, $1c, $fe, $01, $28, $24, $fe, $02, $28, $2f, $fe, $03, $28, $3a, $fe, $04
    db $28, $45, $fe, $05, $28, $50, $fe, $06, $28, $5b, $fe, $07, $28, $66

; C: leftover: 12 bytes of code PICT0 of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; code that this build never runs (typed data)
Leftover_37_57DA_PICT0::
    db $3e, $04, $ea, $00, $20, $3e, $01, $ea, $c8, $c0, $18, $67

; C: leftover: 15 bytes of code PICT1 of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; code that this build never runs (typed data)
Leftover_37_57E6_PICT1::
    db $3e, $04, $ea, $00, $20, $21, $01, $4e, $3e, $02, $ea, $c8, $c0, $18, $58

; C: leftover: 15 bytes of code PICT2 of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; code that this build never runs (typed data)
Leftover_37_57F5_PICT2::
    db $3e, $04, $ea, $00, $20, $21, $01, $5c, $3e, $03, $ea, $c8, $c0, $18, $49

; C: leftover: 15 bytes of code PICT3 of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; code that this build never runs (typed data)
Leftover_37_5804_PICT3::
    db $3e, $04, $ea, $00, $20, $21, $01, $6a, $3e, $04, $ea, $c8, $c0, $18, $3a

; C: leftover: 15 bytes of code PICT4 of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; code that this build never runs (typed data)
Leftover_37_5813_PICT4::
    db $3e, $04, $ea, $00, $20, $21, $01, $5c, $3e, $05, $ea, $c8, $c0, $18, $2b

; C: leftover: 15 bytes of code PICT5 of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; code that this build never runs (typed data)
Leftover_37_5822_PICT5::
    db $3e, $04, $ea, $00, $20, $21, $01, $4e, $3e, $00, $ea, $c8, $c0, $18, $1c

; C: leftover: 15 bytes of code PICT6 of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; code that this build never runs (typed data)
Leftover_37_5831_PICT6::
    db $3e, $06, $ea, $00, $20, $21, $01, $5c, $3e, $07, $ea, $c8, $c0, $18, $0d

; C: leftover: 13 bytes of code PICT7 of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; code that this build never runs (typed data)
Leftover_37_5840_PICT7::
    db $3e, $06, $ea, $00, $20, $21, $01, $6a, $3e, $00, $ea, $c8, $c0

; C: leftover: 10 bytes of code NC_PICT of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_584D_NC_PICT::
    db $11, $00, $d0, $01, $00, $10, $cd, $c8, $02, $c9

; C: leftover: 72 bytes of code H_BLANK_TX of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_5857_H_BLANK_TX::
    db $3e, $80, $e0, $88, $fa, $c7, $c0, $67, $fa, $c6, $c0, $6f, $2a, $47, $2a, $4f
    db $2a, $57, $2a, $5f, $7c, $ea, $c7, $c0, $7d, $ea, $c6, $c0, $fa, $c5, $c0, $67
    db $fa, $c4, $c0, $6f, $f0, $41, $e6, $03, $28, $fa, $f0, $41, $e6, $03, $20, $fa
    db $78, $22, $79, $22, $7a, $22, $7b, $22, $7c, $ea, $c5, $c0, $7d, $ea, $c4, $c0
    db $f0, $88, $3d, $e0, $88, $20, $bd, $c9

; C: leftover: 14 bytes of code HBLK of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; code that this build never runs (typed data)
Leftover_37_589F_HBLK::
    db $78, $22, $79, $22, $7a, $22, $7b, $22, $3e, $01, $ea, $c2, $c0, $d9

; C: leftover: 8 bytes of code WAIT_DONE_VBLNK of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_58AD_WAIT_DONE_VBLNK::
    db $f0, $44, $fe, $00, $c2, $ad, $18, $c9

; C: leftover: 5 bytes of code TIMER_INT of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_58B5_TIMER_INT::
    db $21, $cf, $c0, $34, $d9

; C: leftover: 10 bytes of code VB_MOVIE of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_58BA_VB_MOVIE::
    db $cd, $b6, $ff, $fa, $c9, $c0, $e6, $ff, $c8, $c9

; C: leftover: 20 bytes of code OBJ_TH of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; code that this build never runs (typed data)
Leftover_37_58C4_OBJ_TH::
    db $70, $10, $10, $00, $50, $10, $11, $00, $30, $10, $12, $00, $10, $0c, $18, $00
    db $10, $14, $19, $00

; C: leftover: 20 bytes of code OBJ_CHG0 of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_58D8_OBJ_CHG0::
    db $00, $00, $00, $00, $10, $08, $20, $00, $10, $10, $21, $00, $10, $18, $22, $00
    db $00, $00, $00, $00

; C: leftover: 20 bytes of code OBJ_CHG1 of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_58EC_OBJ_CHG1::
    db $00, $00, $00, $00, $10, $08, $23, $00, $10, $10, $24, $00, $10, $18, $25, $00
    db $00, $00, $00, $00

; C: leftover: 20 bytes of code OBJ_CHG2 of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_5900_OBJ_CHG2::
    db $00, $00, $00, $00, $10, $08, $26, $00, $10, $10, $27, $00, $10, $18, $28, $00
    db $00, $00, $00, $00

; C: leftover: 20 bytes of code OBJ_VR of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; code that this build never runs (typed data)
Leftover_37_5914_OBJ_VR::
    db $00, $00, $00, $00, $10, $08, $15, $00, $10, $10, $16, $00, $10, $18, $17, $00
    db $00, $00, $00, $00

; C: leftover: 20 bytes of code OBJ_GA1 of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_5928_OBJ_GA1::
    db $00, $00, $00, $00, $10, $08, $1a, $00, $10, $10, $1b, $00, $10, $18, $1c, $00
    db $00, $00, $00, $00

; C: leftover: 20 bytes of code OBJ_GA2 of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_593C_OBJ_GA2::
    db $00, $00, $00, $00, $10, $08, $1d, $00, $10, $10, $1e, $00, $10, $18, $1f, $00
    db $00, $00, $00, $00

; C: leftover: 132 bytes of code MAKE_CONFIG of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_5950_MAKE_CONFIG::
    db $cd, $da, $05, $cd, $48, $06, $cd, $cf, $05, $f0, $fd, $f5, $3e, $03, $e0, $fd
    db $ea, $00, $21, $21, $41, $5a, $11, $00, $80, $01, $00, $18, $cd, $bf, $02, $21
    db $41, $72, $11, $00, $98, $01, $40, $02, $cd, $bf, $02, $21, $00, $c0, $fa, $e0
    db $c0, $22, $3e, $08, $22, $3e, $00, $22, $af, $22, $21, $eb, $21, $11, $04, $c0
    db $01, $30, $00, $cd, $bf, $02, $cd, $b1, $1e, $cd, $d4, $1e, $cd, $f7, $1e, $cd
    db $1a, $1f, $cd, $3d, $1f, $cd, $60, $1f, $cd, $a1, $1f, $cd, $d7, $1f, $cd, $f8
    db $1f, $f1, $e0, $fd, $ea, $00, $21, $cd, $2e, $07, $cd, $13, $07, $cd, $20, $07
    db $3e, $01, $e0, $ff, $3e, $09, $ea, $a0, $c0, $3e, $c3, $e0, $40, $af, $ea, $58
    db $c1, $e0, $88, $c9

; C: leftover: 654 bytes of code CONFIG of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_59D4_CONFIG::
    INCBIN "data/bank_37/Leftover_37_59D4_CONFIG.bin" ; $59D4, 654 bytes
; C: leftover: 87 bytes of code VB_CONFIG of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_5C62_VB_CONFIG::
    db $f0, $88, $fe, $01, $20, $07, $cd, $f8, $1f, $18, $48, $18, $46, $fe, $02, $20
    db $05, $cd, $b1, $1e, $18, $3d, $fe, $03, $20, $05, $cd, $d4, $1e, $18, $34, $fe
    db $04, $20, $05, $cd, $f7, $1e, $18, $2b, $fe, $05, $20, $05, $cd, $1a, $1f, $18
    db $22, $fe, $06, $20, $05, $cd, $d7, $1f, $18, $19, $fe, $07, $20, $05, $cd, $a1
    db $1f, $18, $10, $fe, $08, $20, $05, $cd, $60, $1f, $18, $07, $fe, $09, $20, $03
    db $cd, $3d, $1f, $af, $e0, $88, $c9

; C: leftover: 139 bytes of code CONF_SET_OBJ of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_5CB9_CONF_SET_OBJ::
    db $cd, $ec, $16, $21, $06, $c0, $f0, $88, $cb, $37, $e6, $0f, $c6, $e0, $22, $23
    db $23, $23, $f0, $88, $e6, $0f, $c6, $e0, $22, $23, $23, $23, $f0, $89, $cb, $37
    db $e6, $0f, $c6, $e0, $22, $23, $23, $23, $f0, $89, $e6, $0f, $c6, $e0, $22, $23
    db $23, $23, $f0, $8a, $cb, $37, $e6, $0f, $c6, $e0, $22, $23, $23, $23, $f0, $8a
    db $e6, $0f, $c6, $e0, $22, $23, $23, $23, $f0, $8b, $cb, $37, $e6, $0f, $c6, $e0
    db $22, $23, $23, $23, $f0, $8b, $e6, $0f, $c6, $e0, $22, $23, $23, $23, $f0, $8c
    db $cb, $37, $e6, $0f, $c6, $e0, $22, $23, $23, $23, $f0, $8c, $e6, $0f, $c6, $e0
    db $22, $23, $23, $23, $f0, $8d, $cb, $37, $e6, $0f, $c6, $e0, $22, $23, $23, $23
    db $f0, $8d, $e6, $0f, $c6, $e0, $22, $23, $23, $23, $c9

; C: leftover: 108 bytes of code DITHER_SET of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_5D44_DITHER_SET::
    db $fa, $56, $c1, $b7, $20, $33, $fa, $e2, $c0, $b7, $20, $05, $21, $1b, $22, $18
    db $24, $fe, $01, $20, $05, $21, $db, $22, $18, $1b, $fe, $02, $20, $05, $21, $fb
    db $23, $18, $12, $fe, $03, $20, $05, $21, $bb, $24, $18, $09, $fe, $04, $20, $08
    db $21, $24, $c1, $18, $00, $cd, $85, $2d, $c9, $fa, $e2, $c0, $b7, $20, $05, $21
    db $ab, $22, $18, $24, $fe, $01, $20, $05, $21, $9b, $23, $18, $1b, $fe, $02, $20
    db $05, $21, $5b, $24, $18, $12, $fe, $03, $20, $05, $21, $1b, $25, $18, $09, $fe
    db $04, $20, $08, $21, $24, $c1, $18, $00, $cd, $85, $2d, $c9

; C: leftover: 61 bytes of code PUT_DITHER of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_5DB0_PUT_DITHER::
    db $21, $00, $cf, $fa, $e2, $c0, $b7, $20, $0d, $3e, $0e, $22, $3c, $22, $3e, $ac
    db $22, $3e, $ac, $22, $18, $26, $fe, $01, $20, $03, $af, $18, $18, $fe, $02, $20
    db $04, $3e, $04, $18, $10, $fe, $03, $20, $04, $3e, $08, $18, $08, $fe, $04, $20
    db $0b, $3e, $2c, $18, $00, $22, $3c, $22, $3c, $22, $3c, $22, $c9

; C: leftover: 29 bytes of code PUT_YURAGI of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_5DED_PUT_YURAGI::
    db $21, $04, $cf, $fa, $e3, $c0, $fe, $00, $20, $07, $3e, $0e, $22, $3c, $22, $18
    db $0b, $fe, $01, $20, $07, $3e, $0c, $22, $3c, $22, $18, $00, $c9

; C: leftover: 34 bytes of code PUT_STA of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_5E0A_PUT_STA::
    db $21, $06, $cf, $fa, $ee, $c0, $e6, $06, $fe, $00, $20, $04, $3e, $10, $18, $0c
    db $fe, $02, $20, $04, $3e, $13, $18, $04, $3e, $16, $18, $00, $22, $3c, $22, $3c
    db $22, $c9

; C: leftover: 31 bytes of code PUT_CHG of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_5E2C_PUT_CHG::
    db $fa, $ef, $c0, $47, $21, $09, $cf, $cd, $f8, $0f, $fa, $f0, $c0, $47, $21, $0b
    db $cf, $cd, $f8, $0f, $fa, $f1, $c0, $47, $21, $0d, $cf, $cd, $f8, $0f, $c9

; C: leftover: 11 bytes of code PUT_V_REF of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_5E4B_PUT_V_REF::
    db $fa, $f2, $c0, $47, $21, $0f, $cf, $cd, $f8, $0f, $c9

; C: leftover: 30 bytes of code PUT_TH of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; code that this build never runs (typed data)
Leftover_37_5E56_PUT_TH::
    db $21, $13, $cf, $fa, $56, $c1, $fe, $00, $20, $04, $3e, $23, $18, $08, $fe, $01
    db $20, $0b, $3e, $27, $18, $00, $22, $3c, $22, $3c, $22, $3c, $22, $c9

; C: leftover: 61 bytes of code YURAGI_SET of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_5E74_YURAGI_SET::
    db $fa, $e4, $c0, $b7, $20, $09, $cd, $44, $1d, $3e, $01, $ea, $e4, $c0, $c9, $fa
    db $e2, $c0, $b7, $20, $05, $21, $1b, $22, $18, $1b, $fe, $01, $20, $05, $21, $6b
    db $23, $18, $12, $fe, $02, $20, $05, $21, $2b, $24, $18, $09, $fe, $03, $20, $08
    db $21, $eb, $24, $18, $00, $cd, $85, $2d, $af, $ea, $e4, $c0, $c9

; C: leftover: 35 bytes of code PUT_MODE of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_5EB1_PUT_MODE::
    db $21, $27, $20, $11, $18, $00, $fa, $e5, $c0, $b7, $28, $04, $19, $3d, $18, $f9
    db $11, $46, $98, $01, $0c, $00, $cd, $bf, $02, $11, $66, $98, $01, $0c, $00, $cd
    db $bf, $02, $c9

; C: leftover: 35 bytes of code PUT_EDGE of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_5ED4_PUT_EDGE::
    db $21, $ff, $20, $11, $08, $00, $fa, $e6, $c0, $b7, $28, $04, $19, $3d, $18, $f9
    db $11, $86, $98, $01, $04, $00, $cd, $bf, $02, $11, $a6, $98, $01, $04, $00, $cd
    db $bf, $02, $c9

; C: leftover: 35 bytes of code PUT_VREF of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_5EF7_PUT_VREF::
    db $21, $3f, $21, $11, $08, $00, $fa, $e7, $c0, $b7, $28, $04, $19, $3d, $18, $f9
    db $11, $c6, $98, $01, $04, $00, $cd, $bf, $02, $11, $e6, $98, $01, $04, $00, $cd
    db $bf, $02, $c9

; C: leftover: 35 bytes of code PUT_ZERO of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_5F1A_PUT_ZERO::
    db $21, $7f, $21, $11, $1c, $00, $fa, $e8, $c0, $b7, $28, $04, $19, $3d, $18, $f9
    db $11, $06, $99, $01, $0e, $00, $cd, $bf, $02, $11, $26, $99, $01, $0e, $00, $cd
    db $bf, $02, $c9

; C: leftover: 35 bytes of code PUT_REV of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_5F3D_PUT_REV::
    db $21, $d3, $21, $11, $0c, $00, $fa, $e9, $c0, $b7, $28, $04, $19, $3d, $18, $f9
    db $11, $06, $9a, $01, $06, $00, $cd, $bf, $02, $11, $26, $9a, $01, $06, $00, $cd
    db $bf, $02, $c9

; C: leftover: 65 bytes of code PUT_CHG_T of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_5F60_PUT_CHG_T::
    db $fa, $eb, $c0, $cb, $37, $e6, $0f, $c6, $80, $ea, $c6, $99, $c6, $10, $ea, $e6
    db $99, $fa, $eb, $c0, $e6, $0f, $c6, $80, $ea, $c7, $99, $c6, $10, $ea, $e7, $99
    db $fa, $ea, $c0, $cb, $37, $e6, $0f, $c6, $80, $ea, $c8, $99, $c6, $10, $ea, $e8
    db $99, $fa, $ea, $c0, $e6, $0f, $c6, $80, $ea, $c9, $99, $c6, $10, $ea, $e9, $99
    db $c9

; C: leftover: 54 bytes of code PUT_OFS of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_5FA1_PUT_OFS::
    db $fa, $ec, $c0, $cb, $6f, $28, $04, $3e, $40, $18, $02, $3e, $41, $ea, $86, $99
    db $c6, $10, $ea, $a6, $99, $fa, $ec, $c0, $cb, $37, $e6, $01, $c6, $80, $ea, $87
    db $99, $c6, $10, $ea, $a7, $99, $fa, $ec, $c0, $e6, $0f, $c6, $80, $ea, $88, $99
    db $c6, $10, $ea, $a8, $99, $c9

; C: leftover: 33 bytes of code PUT_GAIN of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_5FD7_PUT_GAIN::
    db $fa, $ed, $c0, $cb, $37, $e6, $01, $c6, $80, $ea, $46, $99, $c6, $10, $ea, $66
    db $99, $fa, $ed, $c0, $e6, $0f, $c6, $80, $ea, $47, $99, $c6, $10, $ea, $67, $99
    db $c9

; C: leftover: 35 bytes of code PUT_DITH_PAT of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_5FF8_PUT_DITH_PAT::
    db $21, $1b, $20, $11, $06, $00, $fa, $e2, $c0, $b7, $28, $04, $19, $3d, $18, $f9
    db $11, $06, $98, $01, $03, $00, $cd, $bf, $02, $11, $26, $98, $01, $03, $00, $cd
    db $bf, $02, $c9

; C: leftover: 12 bytes of data DITH_P0 of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; nothing in this build reads it
Leftover_37_601B_DITH_P0::
    db $29, $2a, $2b, $39, $3a, $3b, $27, $28, $60, $37, $38, $60

; C: leftover: 216 bytes of code MOVE0 of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; code that this build never runs (typed data)
Leftover_37_6027_MOVE0::
    db $2c, $2d, $46, $47, $48, $49, $60, $60, $60, $60, $60, $60, $3c, $3d, $56, $57
    db $58, $59, $60, $60, $60, $60, $60, $60, $2e, $2f, $46, $47, $48, $49, $60, $60
    db $60, $60, $60, $60, $3e, $3f, $56, $57, $58, $59, $60, $60, $60, $60, $60, $60
    db $0a, $0b, $20, $21, $22, $23, $24, $25, $26, $60, $60, $60, $1a, $1b, $30, $31
    db $32, $33, $34, $35, $36, $60, $60, $60, $0c, $0d, $20, $21, $22, $23, $24, $25
    db $26, $60, $60, $60, $1c, $1d, $30, $31, $32, $33, $34, $35, $36, $60, $60, $60
    db $00, $01, $02, $03, $04, $20, $21, $22, $23, $24, $25, $26, $10, $11, $12, $13
    db $14, $30, $31, $32, $33, $34, $35, $36, $0a, $0b, $20, $21, $22, $60, $60, $60
    db $60, $60, $60, $60, $1a, $1b, $30, $31, $32, $60, $60, $60, $60, $60, $60, $60
    db $0c, $0d, $20, $21, $22, $60, $60, $60, $60, $60, $60, $60, $1c, $1d, $30, $31
    db $32, $60, $60, $60, $60, $60, $60, $60, $00, $01, $02, $03, $04, $20, $21, $22
    db $60, $60, $60, $60, $10, $11, $12, $13, $14, $30, $31, $32, $60, $60, $60, $60
    db $05, $06, $07, $08, $09, $0c, $0d, $20, $21, $22, $60, $60, $15, $16, $17, $18
    db $19, $1c, $1d, $30, $31, $32, $60, $60

; C: leftover: 64 bytes of data EDGE0 of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; nothing in this build reads it
Leftover_37_60FF_EDGE0::
    db $85, $80, $44, $60, $95, $90, $54, $60, $87, $85, $44, $60, $97, $95, $54, $60
    db $81, $80, $80, $44, $91, $90, $90, $54, $81, $82, $85, $44, $91, $92, $95, $54
    db $82, $80, $80, $44, $92, $90, $90, $54, $83, $80, $80, $44, $93, $90, $90, $54
    db $84, $80, $80, $44, $94, $90, $90, $54, $85, $80, $80, $44, $95, $90, $90, $54

; C: leftover: 64 bytes of data VREF0 of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; nothing in this build reads it
Leftover_37_613F_VREF0::
    db $80, $42, $80, $43, $90, $52, $90, $53, $80, $42, $85, $43, $90, $52, $95, $53
    db $81, $42, $80, $43, $91, $52, $90, $53, $81, $42, $85, $43, $91, $52, $95, $53
    db $82, $42, $80, $43, $92, $52, $90, $53, $82, $42, $85, $43, $92, $52, $95, $53
    db $83, $42, $80, $43, $93, $52, $90, $53, $83, $42, $85, $43, $93, $52, $95, $53

; C: leftover: 84 bytes of data ZERO0 of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; nothing in this build reads it
Leftover_37_617F_ZERO0::
    db $4a, $4b, $4c, $4d, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $5a, $5b
    db $5c, $5d, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $2c, $2d, $46, $47
    db $48, $49, $ac, $ad, $ae, $af, $0e, $0f, $2c, $2d, $3c, $3d, $56, $57, $58, $59
    db $bc, $bd, $be, $bf, $1e, $1f, $3c, $3d, $2e, $2f, $46, $47, $48, $49, $ac, $ad
    db $ae, $af, $0e, $0f, $2c, $2d, $3e, $3f, $56, $57, $58, $59, $bc, $bd, $be, $bf
    db $1e, $1f, $3c, $3d

; C: leftover: 24 bytes of data REV0 of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; nothing in this build reads it
Leftover_37_61D3_REV0::
    db $4e, $4f, $cc, $cd, $ce, $cf, $5e, $5f, $dc, $dd, $de, $df, $cc, $cd, $ce, $cf
    db $60, $60, $dc, $dd, $de, $df, $60, $60

; C: leftover: 48 bytes of data CONF_OBJ_PAT of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35; nothing in this build reads it
Leftover_37_61EB_CONF_OBJ_PAT::
    db $70, $80, $80, $00, $70, $88, $80, $00, $78, $80, $80, $00, $78, $88, $80, $00
    db $80, $80, $80, $00, $80, $88, $80, $00, $88, $80, $80, $00, $88, $88, $80, $00
    db $90, $80, $80, $00, $90, $88, $80, $00, $98, $80, $80, $00, $98, $88, $80, $00

; C: leftover: 48 bytes of code NO_DITHER of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_621B_NO_DITHER::
    db $48, $48, $48, $48, $48, $48, $48, $48, $48, $48, $48, $48, $48, $48, $48, $48
    db $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60
    db $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98

; C: leftover: 48 bytes of code NO_DITHER_M of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_624B_NO_DITHER_M::
    db $4c, $4c, $4c, $4c, $4c, $4c, $4c, $4c, $4c, $4c, $4c, $4c, $4c, $4c, $4c, $4c
    db $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60
    db $90, $90, $90, $90, $90, $90, $90, $90, $90, $90, $90, $90, $90, $90, $90, $90

; C: leftover: 48 bytes of code NO_DITHER_H of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_627B_NO_DITHER_H::
    db $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28
    db $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40
    db $78, $78, $78, $78, $78, $78, $78, $78, $78, $78, $78, $78, $78, $78, $78, $78

; C: leftover: 48 bytes of code NO_DITHER_D of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_62AB_NO_DITHER_D::
    db $90, $90, $90, $90, $90, $90, $90, $90, $90, $90, $90, $90, $90, $90, $90, $90
    db $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0
    db $b0, $b0, $b0, $b0, $b0, $b0, $b0, $b0, $b0, $b0, $b0, $b0, $b0, $b0, $b0, $b0

; C: leftover: 48 bytes of data DEFAULT_BAYER of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35; nothing in this build reads it
Leftover_37_62DB_DEFAULT_BAYER::
    db $40, $48, $42, $4a, $4c, $44, $4e, $46, $43, $4b, $41, $49, $4f, $47, $4d, $45
    db $50, $60, $54, $64, $68, $58, $6c, $5c, $56, $66, $52, $62, $6e, $5e, $6a, $5a
    db $70, $98, $7a, $a2, $ac, $84, $b6, $8e, $7f, $a7, $75, $9d, $bb, $93, $b1, $89

; C: leftover: 48 bytes of data BAYER_CONTRAST_M of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35; nothing in this build reads it
Leftover_37_630B_BAYER_CONTRAST_M::
    db $44, $4c, $46, $4e, $50, $48, $52, $4a, $47, $4f, $45, $4d, $53, $4b, $51, $49
    db $50, $60, $54, $64, $68, $58, $6c, $5c, $56, $66, $52, $62, $6e, $5e, $6a, $5a
    db $68, $88, $70, $90, $98, $78, $a0, $80, $74, $94, $6c, $8c, $a4, $84, $9c, $7c

; C: leftover: 48 bytes of data BAYER_CONTRAST_H of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35; nothing in this build reads it
Leftover_37_633B_BAYER_CONTRAST_H::
    db $20, $28, $22, $2a, $2c, $24, $2e, $26, $23, $2b, $21, $29, $2f, $27, $2d, $25
    db $30, $40, $34, $44, $48, $38, $4c, $3c, $36, $46, $32, $42, $4e, $3e, $4a, $3a
    db $50, $78, $5a, $82, $8c, $64, $96, $6e, $5f, $87, $55, $7d, $9b, $73, $91, $69

; C: leftover: 48 bytes of data BAYER1 of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; nothing in this build reads it
Leftover_37_636B_BAYER1::
    db $9c, $a8, $98, $ac, $a2, $96, $a6, $92, $9a, $ae, $9e, $60, $a4, $90, $a0, $94
    db $bc, $c8, $b8, $cc, $c2, $b6, $c6, $b2, $ba, $ce, $be, $ca, $c4, $b0, $c0, $b4
    db $dc, $e8, $d8, $ec, $e2, $d6, $e6, $d2, $da, $ee, $de, $ea, $e4, $d0, $e0, $d4

; C: leftover: 48 bytes of data DEFAULT_BAYER_D of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35; nothing in this build reads it
Leftover_37_639B_DEFAULT_BAYER_D::
    db $88, $90, $8a, $92, $94, $8c, $96, $8e, $8b, $93, $89, $91, $97, $8f, $95, $8d
    db $98, $a0, $9a, $a2, $a4, $9c, $a6, $9e, $9b, $a3, $99, $a1, $a7, $9f, $a5, $9d
    db $a8, $b0, $60, $b2, $b4, $ac, $b6, $ae, $ab, $b3, $a9, $b1, $b7, $af, $b5, $ad

; C: leftover: 48 bytes of data BAYER1_D of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; nothing in this build reads it
Leftover_37_63CB_BAYER1_D::
    db $8e, $94, $8c, $96, $91, $8b, $93, $89, $8d, $97, $8f, $95, $92, $88, $90, $8a
    db $9e, $a4, $9c, $a6, $a1, $9b, $a3, $99, $9c, $a7, $9f, $a5, $a2, $98, $a0, $9a
    db $ae, $b4, $ac, $b6, $b1, $ab, $b3, $a9, $ad, $b7, $af, $b5, $b2, $a8, $b0, $60

; C: leftover: 48 bytes of data DEFAULT_HALF of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35; nothing in this build reads it
Leftover_37_63FB_DEFAULT_HALF::
    db $a4, $98, $9c, $a0, $a8, $90, $94, $ac, $9e, $a2, $a6, $9a, $96, $ae, $60, $92
    db $c4, $b8, $bc, $c0, $c8, $b0, $b4, $cc, $be, $c2, $c6, $ba, $b6, $ce, $ca, $b2
    db $e4, $d8, $dc, $e0, $e8, $d0, $d4, $ec, $de, $e2, $e6, $da, $d6, $ee, $ea, $d2

; C: leftover: 48 bytes of data HALF1 of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; nothing in this build reads it
Leftover_37_642B_HALF1::
    db $ac, $a8, $90, $94, $9a, $9e, $a2, $a6, $92, $96, $ae, $60, $a0, $a4, $98, $9c
    db $cc, $c8, $b0, $b4, $ba, $be, $c2, $c6, $b2, $b6, $ce, $ca, $c0, $c4, $b8, $bc
    db $ec, $e8, $d0, $d4, $da, $de, $e2, $e6, $d2, $d6, $ee, $ea, $e0, $e4, $d8, $dc

; C: leftover: 48 bytes of data DEFAULT_HALF_D of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35; nothing in this build reads it
Leftover_37_645B_DEFAULT_HALF_D::
    db $92, $8c, $8e, $90, $94, $88, $8a, $96, $8f, $91, $93, $8d, $8b, $97, $95, $89
    db $a2, $9c, $9e, $a0, $a4, $98, $9a, $a6, $9f, $a1, $a3, $9d, $9b, $a7, $a5, $99
    db $b2, $ac, $ae, $b0, $b4, $a8, $60, $b6, $af, $b1, $b3, $ad, $ab, $b7, $b5, $a9

; C: leftover: 48 bytes of data HALF1_D of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; nothing in this build reads it
Leftover_37_648B_HALF1_D::
    db $96, $94, $88, $8a, $8d, $8f, $91, $93, $89, $8b, $97, $95, $90, $92, $8c, $8e
    db $a6, $a4, $98, $9a, $9d, $9f, $a1, $a3, $99, $9b, $a7, $a5, $a0, $a2, $9c, $9e
    db $b6, $b4, $a8, $60, $ad, $af, $b1, $b3, $a9, $ab, $b7, $b5, $b0, $b2, $ac, $ae

; C: leftover: 48 bytes of data DEFAULT_SCREW of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35; nothing in this build reads it
Leftover_37_64BB_DEFAULT_SCREW::
    db $60, $9e, $9c, $a8, $a0, $92, $90, $9a, $a2, $94, $96, $98, $ac, $a4, $a6, $ae
    db $ca, $be, $bc, $c8, $c0, $b2, $b0, $ba, $c2, $b4, $b6, $b8, $cc, $c4, $c6, $ce
    db $ea, $de, $dc, $e8, $e0, $d2, $d0, $da, $e2, $d4, $d6, $d8, $ec, $e4, $e6, $ee

; C: leftover: 48 bytes of data SCREW1 of the bank 0 of an older build (the build of table $35); address and name from
; symbol table $35; nothing in this build reads it
Leftover_37_64EB_SCREW1::
    db $9a, $a0, $92, $90, $98, $a2, $94, $96, $ae, $ac, $a4, $a6, $a8, $60, $9e, $9c
    db $ba, $c0, $b2, $b0, $b8, $c2, $b4, $b6, $ce, $cc, $c4, $c6, $c8, $ca, $be, $bc
    db $da, $e0, $d2, $d0, $d8, $e2, $d4, $d6, $ee, $ec, $e4, $e6, $e8, $ea, $de, $dc

; C: leftover: 48 bytes of data DEFAULT_SCREW_D of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35; nothing in this build reads it
Leftover_37_651B_DEFAULT_SCREW_D::
    db $95, $8f, $8e, $94, $90, $89, $88, $8d, $91, $8a, $8b, $8c, $96, $92, $93, $97
    db $a5, $9f, $9e, $a4, $a0, $99, $98, $9d, $a1, $9a, $9b, $9c, $a6, $a2, $a3, $a7
    db $b5, $af, $ae, $b4, $b0, $a9, $a8, $ad, $b1, $60, $ab, $ac, $b6, $b2, $b3, $b7

; C: leftover: 48 bytes of data SCREW1_D of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; nothing in this build reads it
Leftover_37_654B_SCREW1_D::
    db $8d, $90, $89, $88, $8c, $91, $8a, $8b, $97, $96, $92, $93, $94, $95, $8f, $8e
    db $9d, $a0, $99, $98, $9c, $a1, $9a, $9b, $a7, $a6, $a2, $a3, $a4, $a5, $9f, $9e
    db $ad, $b0, $a9, $a8, $ac, $b1, $60, $ab, $b7, $b6, $b2, $b3, $b4, $b5, $af, $ae

; C: leftover: 96 bytes of code MK_PROTECT of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_657B_MK_PROTECT::
    db $cd, $da, $05, $cd, $48, $06, $cd, $cf, $05, $f0, $fd, $f5, $3e, $02, $e0, $fd
    db $ea, $00, $21, $21, $01, $40, $11, $00, $80, $01, $00, $18, $cd, $bf, $02, $21
    db $41, $63, $11, $00, $98, $01, $40, $02, $cd, $bf, $02, $21, $00, $c0, $3e, $3c
    db $22, $3e, $29, $22, $af, $22, $22, $3e, $3c, $22, $3e, $31, $22, $3e, $02, $22
    db $af, $22, $e0, $a6, $ea, $d2, $c0, $cd, $2e, $07, $cd, $13, $07, $cd, $20, $07
    db $3e, $c7, $e0, $40, $3e, $0a, $ea, $a0, $c0, $f1, $e0, $fd, $ea, $00, $21, $c9

; C: leftover: 112 bytes of code PROTECT_TEST of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_65DB_PROTECT_TEST::
    db $f0, $81, $cb, $27, $38, $41, $cb, $27, $38, $4c, $cb, $27, $cb, $27, $cb, $27
    db $cb, $27, $cb, $27, $38, $09, $cb, $27, $38, $0f, $cd, $e5, $0c, $18, $50, $3e
    db $02, $ea, $bd, $c0, $cd, $44, $08, $18, $46, $fa, $00, $c0, $fe, $3c, $20, $05
    db $cd, $4b, $26, $18, $10, $fe, $4c, $20, $05, $cd, $85, $26, $18, $07, $fe, $5c
    db $20, $03, $cd, $c4, $26, $18, $28, $fa, $00, $c0, $fe, $5c, $20, $04, $d6, $20
    db $18, $13, $c6, $10, $18, $0f, $fa, $00, $c0, $fe, $3c, $20, $04, $c6, $20, $18
    db $04, $d6, $10, $18, $00, $ea, $00, $c0, $ea, $04, $c0, $af, $ea, $d2, $c0, $c9

; C: leftover: 58 bytes of code PROT_TEST of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_664B_PROT_TEST::
    db $f3, $16, $00, $3e, $01, $ea, $00, $60, $7a, $ea, $00, $40, $21, $00, $a0, $7e
    db $47, $ee, $ff, $77, $7e, $b8, $20, $1b, $21, $ff, $bf, $7e, $47, $ee, $ff, $77
    db $7e, $b8, $20, $0f, $7a, $fe, $0f, $28, $03, $14, $18, $dc, $3e, $01, $ea, $d2
    db $c0, $fb, $c9, $3e, $02, $ea, $d2, $c0, $fb, $c9

; C: leftover: 63 bytes of code OFF_TEST of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_6685_OFF_TEST::
    db $f3, $16, $00, $3e, $01, $ea, $00, $60, $3e, $0a, $ea, $00, $00, $7a, $ea, $00
    db $40, $21, $00, $a0, $7e, $ee, $ff, $47, $77, $7e, $b8, $20, $1b, $21, $ff, $bf
    db $7e, $ee, $ff, $47, $77, $7e, $b8, $20, $0f, $7a, $fe, $0f, $28, $03, $14, $18
    db $dc, $3e, $03, $ea, $d2, $c0, $fb, $c9, $3e, $04, $ea, $d2, $c0, $fb, $c9

; C: leftover: 63 bytes of code ON_TEST of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_66C4_ON_TEST::
    db $f3, $16, $00, $3e, $01, $ea, $00, $60, $3e, $00, $ea, $00, $00, $7a, $ea, $00
    db $40, $21, $00, $a0, $7e, $47, $ee, $ff, $77, $7e, $b8, $20, $1b, $21, $ff, $bf
    db $7e, $47, $ee, $ff, $77, $7e, $b8, $20, $0f, $7a, $fe, $0f, $28, $03, $14, $18
    db $dc, $3e, $05, $ea, $d2, $c0, $fb, $c9, $3e, $06, $ea, $d2, $c0, $fb, $c9

; C: leftover: 125 bytes of code VB_PROTECT of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_6703_VB_PROTECT::
    db $fa, $d2, $c0, $b7, $20, $16, $3e, $a0, $ea, $ce, $98, $ea, $cf, $98, $ea, $0e
    db $99, $ea, $0f, $99, $ea, $4e, $99, $ea, $4f, $99, $18, $60, $fe, $01, $20, $0c
    db $3e, $cf, $ea, $ce, $98, $3e, $cb, $ea, $cf, $98, $18, $50, $fe, $02, $20, $0c
    db $3e, $ce, $ea, $ce, $98, $3e, $c7, $ea, $cf, $98, $18, $40, $fe, $03, $20, $0c
    db $3e, $cf, $ea, $0e, $99, $3e, $cb, $ea, $0f, $99, $18, $30, $fe, $04, $20, $0c
    db $3e, $ce, $ea, $0e, $99, $3e, $c7, $ea, $0f, $99, $18, $20, $fe, $05, $20, $0c
    db $3e, $cf, $ea, $4e, $99, $3e, $cb, $ea, $4f, $99, $18, $10, $fe, $06, $20, $0c
    db $3e, $ce, $ea, $4e, $99, $3e, $c7, $ea, $4f, $99, $18, $00, $c9

; C: leftover: 24 bytes of code MK_PIC_SAVE of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_6780_MK_PIC_SAVE::
    db $3e, $0c, $ea, $a0, $c0, $cd, $cf, $05, $21, $cb, $28, $11, $00, $c0, $01, $28
    db $00, $cd, $bf, $02, $af, $ea, $cb, $c0

; C: leftover: 220 bytes of code PIC_SAVE of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_6798_PIC_SAVE::
    db $fa, $cb, $c0, $b7, $28, $0a, $fe, $01, $28, $5d, $fe, $02, $ca, $69, $28, $c9
    db $f0, $81, $cb, $3f, $38, $11, $cb, $3f, $38, $2f, $cb, $3f, $cb, $3f, $cb, $3f
    db $38, $2b, $cb, $3f, $38, $34, $c9, $fa, $1a, $c0, $fe, $36, $20, $1b, $cd, $cf
    db $05, $21, $03, $29, $11, $00, $c0, $01, $14, $00, $cd, $bf, $02, $fa, $cc, $c0
    db $cd, $9a, $28, $3e, $01, $ea, $cb, $c0, $c9, $cd, $9f, $11, $c9, $21, $f3, $28
    db $11, $18, $c0, $01, $10, $00, $cd, $bf, $02, $c9, $21, $e3, $28, $11, $18, $c0
    db $01, $10, $00, $cd, $bf, $02, $c9, $f0, $81, $cb, $3f, $38, $15, $cb, $3f, $38
    db $3a, $cb, $3f, $cb, $3f, $cb, $3f, $cb, $3f, $cb, $3f, $38, $32, $cb, $3f, $38
    db $3f, $c9, $cd, $74, $28, $cd, $cf, $05, $21, $17, $29, $11, $00, $c0, $01, $18
    db $00, $cd, $bf, $02, $3e, $02, $ea, $cb, $c0, $3e, $30, $e0, $88, $fa, $cc, $c0
    db $3c, $fe, $1e, $20, $02, $3e, $00, $ea, $cc, $c0, $c9, $cd, $9f, $11, $c9, $fa
    db $cc, $c0, $fe, $1d, $20, $02, $3e, $ff, $3c, $ea, $cc, $c0, $cd, $9a, $28, $c9
    db $fa, $cc, $c0, $fe, $00, $20, $02, $3e, $1e, $3d, $ea, $cc, $c0, $cd, $9a, $28
    db $c9, $f0, $88, $3d, $e0, $88, $b7, $c0, $cd, $9f, $11, $c9

; C: leftover: 38 bytes of code PICT_SAVE_GO of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_6874_PICT_SAVE_GO::
    db $21, $00, $d0, $11, $00, $a0, $01, $00, $10, $fa, $cc, $c0, $cb, $3f, $30, $03
    db $11, $00, $b0, $c6, $01, $ea, $00, $40, $3e, $0a, $ea, $00, $00, $cd, $c8, $02
    db $3e, $00, $ea, $00, $00, $c9

; C: leftover: 49 bytes of code PUT_BYTE_OBJ2 of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_689A_PUT_BYTE_OBJ2::
    db $4f, $af, $47, $79, $b7, $28, $0b, $af, $3c, $fe, $0a, $20, $02, $04, $af, $0d
    db $20, $f6, $e0, $88, $78, $e0, $89, $21, $14, $c0, $3e, $96, $22, $3e, $70, $22
    db $f0, $89, $22, $af, $22, $3e, $96, $22, $3e, $78, $22, $f0, $88, $22, $af, $22
    db $c9

; C: leftover: 24 bytes of data SAVE_SURU of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; nothing in this build reads it
Leftover_37_68CB_SAVE_SURU::
    db $96, $38, $30, $00, $96, $40, $31, $00, $96, $48, $32, $00, $96, $50, $33, $00
    db $96, $58, $34, $00, $96, $60, $35, $00

; C: leftover: 16 bytes of data SAVE_YES of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; nothing in this build reads it
Leftover_37_68E3_SAVE_YES::
    db $96, $68, $36, $00, $96, $70, $37, $00, $96, $78, $38, $00, $96, $80, $39, $00

; C: leftover: 16 bytes of data SAVE_NO of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; nothing in this build reads it
Leftover_37_68F3_SAVE_NO::
    db $96, $68, $3a, $00, $96, $70, $3b, $00, $96, $78, $3c, $00, $96, $80, $3d, $00

; C: leftover: 20 bytes of data NANBANNI of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; nothing in this build reads it
Leftover_37_6903_NANBANNI::
    db $96, $40, $40, $00, $96, $48, $41, $00, $96, $50, $42, $00, $96, $58, $43, $00
    db $96, $60, $44, $00

; C: leftover: 24 bytes of data SAVESIMASITA of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35; nothing in this build reads it
Leftover_37_6917_SAVESIMASITA::
    db $96, $40, $45, $00, $96, $48, $46, $00, $96, $50, $47, $00, $96, $58, $48, $00
    db $96, $60, $49, $00, $96, $68, $4a, $00

; C: leftover: 124 bytes of code MAKE_GALLERY of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_692F_MAKE_GALLERY::
    db $cd, $da, $05, $cd, $48, $06, $cd, $cf, $05, $f0, $fd, $f5, $3e, $03, $e0, $fd
    db $ea, $00, $21, $21, $01, $40, $11, $00, $80, $01, $00, $18, $cd, $bf, $02, $21
    db $01, $58, $11, $00, $98, $01, $40, $02, $cd, $bf, $02, $21, $00, $a0, $fa, $cc
    db $c0, $b7, $20, $02, $3e, $1e, $3d, $ea, $cc, $c0, $cb, $3f, $30, $03, $21, $00
    db $b0, $c6, $01, $ea, $00, $40, $11, $00, $88, $01, $00, $0e, $cd, $bf, $02, $cd
    db $92, $2a, $f1, $e0, $fd, $ea, $00, $21, $cd, $2e, $07, $cd, $13, $07, $cd, $20
    db $07, $3e, $01, $ea, $c9, $c0, $3e, $01, $e0, $ff, $af, $ea, $c2, $c0, $3e, $08
    db $e0, $41, $3e, $0d, $ea, $a0, $c0, $3e, $c3, $e0, $40, $c9

; C: leftover: 131 bytes of code GALLERY_MODE of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_69AB_GALLERY_MODE::
    db $fa, $cd, $c0, $b7, $20, $7d, $f0, $81, $cb, $2f, $38, $19, $f0, $80, $cb, $2f
    db $cb, $2f, $38, $15, $cb, $2f, $cb, $2f, $cb, $2f, $cb, $2f, $cb, $2f, $38, $1e
    db $cb, $2f, $38, $28, $c9, $cd, $c3, $2b, $c9, $fa, $cc, $c0, $3c, $fe, $1e, $20
    db $01, $af, $ea, $cc, $c0, $3e, $04, $ea, $bd, $c0, $cd, $44, $08, $c9, $fa, $cc
    db $c0, $3c, $fe, $1e, $20, $01, $af, $ea, $cc, $c0, $18, $0f, $fa, $cc, $c0, $3d
    db $fe, $ff, $20, $02, $3e, $1d, $ea, $cc, $c0, $18, $00, $cd, $92, $2a, $21, $c4
    db $c0, $af, $22, $3e, $88, $77, $16, $a0, $fa, $cc, $c0, $cb, $3f, $30, $02, $16
    db $b0, $c6, $01, $ea, $00, $40, $21, $c6, $c0, $af, $22, $7a, $22, $3e, $01, $ea
    db $cd, $c0, $c9

; C: leftover: 15 bytes of code PUT_PICTURE of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_6A2E_PUT_PICTURE::
    db $fa, $c5, $c0, $d6, $96, $30, $04, $cd, $3e, $2a, $c9, $af, $ea, $cd, $c0

; C: leftover: 1 bytes of code TENSOU_END of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_6A3D_TENSOU_END::
    db $c9

; C: leftover: 84 bytes of code H_BLANK_TX2 of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_6A3E_H_BLANK_TX2::
    db $f3, $3e, $80, $e0, $88, $3e, $10, $3d, $c2, $45, $2a, $3e, $02, $e0, $ff, $fa
    db $c7, $c0, $67, $fa, $c6, $c0, $6f, $2a, $47, $2a, $4f, $2a, $57, $2a, $5f, $7c
    db $ea, $c7, $c0, $7d, $ea, $c6, $c0, $fa, $c5, $c0, $67, $fa, $c4, $c0, $6f, $fb
    db $fa, $c2, $c0, $a7, $28, $fa, $f3, $af, $ea, $c2, $c0, $7c, $ea, $c5, $c0, $7d
    db $ea, $c4, $c0, $f0, $88, $3d, $e0, $88, $20, $c5, $3e, $01, $e0, $ff, $fb, $f0
    db $44, $e0, $8b, $c9

; C: leftover: 53 bytes of code GALLERY_OBJ_SET of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_6A92_GALLERY_OBJ_SET::
    db $fa, $cc, $c0, $4f, $af, $47, $79, $b7, $28, $0b, $af, $3c, $fe, $0a, $20, $02
    db $04, $af, $0d, $20, $f6, $e0, $88, $78, $e0, $89, $47, $21, $00, $c0, $3e, $10
    db $22, $3e, $30, $22, $f0, $89, $22, $af, $22, $3e, $10, $22, $3e, $38, $22, $f0
    db $88, $22, $af, $22, $c9

; C: leftover: 252 bytes of code VB_GALLERY of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_6AC7_VB_GALLERY::
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

; C: leftover: 67 bytes of code PRINT_GO_GO of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_6BC3_PRINT_GO_GO::
    db $c9, $cd, $da, $05, $cd, $61, $37, $3e, $c3, $e0, $40, $af, $ea, $6c, $c3, $21
    db $00, $c8, $3e, $09, $cd, $77, $38, $fe, $ff, $28, $28, $fe, $f0, $28, $05, $cd
    db $ad, $18, $18, $f0, $3e, $01, $ea, $6c, $c3, $3e, $01, $ea, $39, $c3, $3e, $e4
    db $ea, $3b, $c3, $cd, $44, $38, $fe, $ff, $28, $09, $fe, $f0, $28, $05, $cd, $ad
    db $18, $18, $f0

; C: leftover: 1 bytes of code MY_PRINT_END of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; code that this build never runs (typed data)
Leftover_37_6C06_MY_PRINT_END::
    db $c9

; C: leftover: 19 bytes of code SIOWATCHDOG2 of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35; code that this build never runs (typed data)
Leftover_37_6C07_SIOWATCHDOG2::
    db $fa, $6c, $c3, $a7, $c0, $21, $6f, $c3, $34, $7e, $fe, $06, $d8, $af, $77, $cd
    db $a8, $39, $c9

; C: leftover: 189 bytes of code CHG_AUTO_SET of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_6C1A_CHG_AUTO_SET::
    db $01, $00, $00, $11, $40, $d3, $cd, $d7, $2c, $11, $40, $d4, $cd, $d7, $2c, $11
    db $40, $d5, $cd, $d7, $2c, $11, $40, $d6, $cd, $d7, $2c, $11, $40, $d7, $cd, $d7
    db $2c, $11, $40, $d8, $cd, $d7, $2c, $11, $40, $d9, $cd, $d7, $2c, $11, $40, $da
    db $cd, $d7, $2c, $cb, $21, $cb, $10, $cb, $21, $cb, $10, $fa, $5a, $c1, $cb, $27
    db $cb, $27, $c6, $04, $4f, $78, $91, $30, $38, $ee, $ff, $3c, $47, $fa, $eb, $c0
    db $67, $57, $fa, $ea, $c0, $6f, $5f, $78, $fe, $00, $28, $53, $fe, $01, $20, $04
    db $0e, $04, $18, $0a, $fe, $02, $20, $04, $0e, $02, $18, $02, $0e, $01, $cb, $3a
    db $cb, $1b, $0d, $20, $f9, $7a, $ee, $ff, $57, $7b, $ee, $ff, $5f, $13, $19, $18
    db $2e, $47, $fa, $eb, $c0, $67, $57, $fa, $ea, $c0, $6f, $5f, $78, $fe, $00, $20
    db $04, $0e, $06, $18, $12, $fe, $01, $20, $04, $0e, $04, $18, $0a, $fe, $02, $20
    db $04, $0e, $02, $18, $02, $0e, $01, $cb, $3a, $cb, $1b, $0d, $20, $f9, $19, $7c
    db $ea, $eb, $c0, $7d, $ea, $ea, $c0, $3e, $01, $ea, $e1, $c0, $c9

; C: leftover: 76 bytes of code LINE_CHECK of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_6CD7_LINE_CHECK::
    db $3e, $04, $e0, $88, $cd, $23, $2d, $cd, $23, $2d, $13, $13, $cd, $23, $2d, $cd
    db $23, $2d, $13, $13, $cd, $23, $2d, $cd, $23, $2d, $13, $13, $cd, $23, $2d, $cd
    db $23, $2d, $13, $13, $13, $13, $cd, $23, $2d, $cd, $23, $2d, $13, $13, $cd, $23
    db $2d, $cd, $23, $2d, $13, $13, $cd, $23, $2d, $cd, $23, $2d, $13, $13, $cd, $23
    db $2d, $cd, $23, $2d, $f0, $88, $3d, $c8, $e0, $88, $18, $b8

; C: leftover: 16 bytes of code BIT_COUNT of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_6D23_BIT_COUNT::
    db $21, $91, $2d, $1a, $13, $85, $6f, $30, $01, $24, $7e, $81, $4f, $d0, $04, $c9

; C: leftover: 82 bytes of code SET_DITH_MATRIX of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_6D33_SET_DITH_MATRIX::
    db $3e, $01, $ea, $5c, $c1, $fa, $e2, $c0, $fe, $01, $28, $23, $fa, $5b, $c1, $fe
    db $01, $20, $07, $21, $1b, $22, $cd, $85, $2d, $c9, $fe, $02, $20, $07, $21, $4b
    db $22, $cd, $85, $2d, $c9, $fe, $03, $c0, $21, $7b, $22, $cd, $85, $2d, $c9, $fa
    db $5b, $c1, $fe, $01, $20, $07, $21, $db, $22, $cd, $85, $2d, $c9, $fe, $02, $20
    db $07, $21, $0b, $23, $cd, $85, $2d, $c9, $fe, $03, $c0, $21, $3b, $23, $cd, $85
    db $2d, $c9

; C: leftover: 12 bytes of code TR_MATRIX of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_6D85_TR_MATRIX::
    db $01, $f4, $c0, $16, $30, $2a, $02, $03, $15, $20, $fa, $c9

; C: leftover: 256 bytes of data COUNT_TABLE of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35; nothing in this build reads it
Leftover_37_6D91_COUNT_TABLE::
    INCBIN "data/bank_37/Leftover_37_6D91_COUNT_TABLE.bin" ; $6D91, 256 bytes
; C: leftover: 65 bytes of data CHG_TIME of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35; nothing in this build reads it
Leftover_37_6E91_CHG_TIME::
    db $01, $00, $01, $10, $01, $20, $01, $30, $01, $40, $01, $50, $01, $60, $01, $70
    db $01, $80, $01, $90, $01, $a0, $01, $b0, $01, $c0, $01, $d0, $01, $e0, $01, $f0
    db $02, $00, $02, $20, $02, $40, $02, $60, $02, $80, $02, $02, $00, $02, $18, $02
    db $30, $02, $48, $02, $60, $02, $78, $02, $90, $02, $a8, $02, $c0, $02, $d8, $02
    db $f0

; C: leftover: 32 bytes of code TENSOU_YOKO of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_6ED2_TENSOU_YOKO::
    db $fa, $c3, $c0, $f5, $3e, $00, $ea, $c3, $c0, $ea, $00, $40, $21, $00, $a7, $11
    db $00, $d7, $01, $00, $07, $cd, $c8, $02, $f1, $ea, $c3, $c0, $ea, $00, $40, $c9

; C: leftover: 188 bytes of code TENSOU_TATE of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_6EF2_TENSOU_TATE::
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

; C: leftover: 74 bytes of code MIRROR_MODE of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_6FAE_MIRROR_MODE::
    db $fa, $c3, $c0, $f5, $3e, $00, $ea, $c3, $c0, $ea, $00, $40, $21, $00, $a0, $7c
    db $e0, $88, $7d, $e0, $89, $11, $00, $d0, $cd, $f8, $2f, $cd, $f8, $2f, $cd, $f8
    db $2f, $cd, $f8, $2f, $cd, $f8, $2f, $cd, $f8, $2f, $cd, $f8, $2f, $cd, $f8, $2f
    db $cd, $f8, $2f, $cd, $f8, $2f, $cd, $f8, $2f, $cd, $f8, $2f, $cd, $f8, $2f, $cd
    db $f8, $2f, $f1, $ea, $c3, $c0, $ea, $00, $40, $c9

; C: leftover: 78 bytes of code MIRROR_LINE of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_6FF8_MIRROR_LINE::
    db $3e, $f0, $e0, $8b, $cd, $46, $30, $3e, $d0, $e0, $8b, $cd, $46, $30, $3e, $b0
    db $e0, $8b, $cd, $46, $30, $3e, $90, $e0, $8b, $cd, $46, $30, $3e, $70, $e0, $8b
    db $cd, $46, $30, $3e, $50, $e0, $8b, $cd, $46, $30, $3e, $30, $e0, $8b, $cd, $46
    db $30, $3e, $10, $e0, $8b, $cd, $46, $30, $01, $80, $00, $62, $6b, $09, $54, $5d
    db $f0, $88, $67, $f0, $89, $6f, $09, $7c, $e0, $88, $7d, $e0, $89, $c9

; C: leftover: 39 bytes of code MIRROR_CHR of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_7046_MIRROR_CHR::
    db $3e, $10, $e0, $8a, $f0, $88, $67, $f0, $89, $6f, $2a, $12, $47, $7c, $e0, $88
    db $7d, $e0, $89, $cd, $6d, $30, $62, $6b, $f0, $8b, $85, $6f, $78, $77, $13, $f0
    db $8a, $3d, $e0, $8a, $20, $de, $c9

; C: leftover: 12 bytes of code NARABEKAE of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_706D_NARABEKAE::
    db $78, $0e, $08, $06, $ff, $1f, $cb, $10, $0d, $20, $fa, $c9

; C: leftover: 213 bytes of code MABIKI_MODE of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_7079_MABIKI_MODE::
    db $fa, $c3, $c0, $f5, $3e, $00, $ea, $c3, $c0, $ea, $00, $40, $21, $00, $a0, $11
    db $00, $d0, $3e, $07, $ea, $bf, $c0, $3e, $08, $ea, $be, $c0, $cd, $4e, $31, $23
    db $13, $cd, $4e, $31, $23, $23, $23, $13, $cd, $4e, $31, $23, $13, $cd, $4e, $31
    db $23, $23, $23, $13, $cd, $4e, $31, $23, $13, $cd, $4e, $31, $23, $23, $23, $13
    db $cd, $4e, $31, $23, $13, $cd, $4e, $31, $23, $23, $23, $13, $01, $10, $00, $09
    db $13, $13, $13, $13, $13, $13, $13, $13, $fa, $be, $c0, $3d, $ea, $be, $c0, $c2
    db $95, $30, $e5, $62, $6b, $01, $88, $ff, $09, $54, $5d, $e1, $3e, $08, $ea, $be
    db $c0, $cd, $4e, $31, $23, $13, $cd, $4e, $31, $23, $23, $23, $13, $cd, $4e, $31
    db $23, $13, $cd, $4e, $31, $23, $23, $23, $13, $cd, $4e, $31, $23, $13, $cd, $4e
    db $31, $23, $23, $23, $13, $cd, $4e, $31, $23, $13, $cd, $4e, $31, $23, $23, $23
    db $13, $01, $10, $00, $09, $13, $13, $13, $13, $13, $13, $13, $13, $fa, $be, $c0
    db $3d, $ea, $be, $c0, $c2, $ea, $30, $fa, $bf, $c0, $3d, $28, $10, $ea, $bf, $c0
    db $e5, $62, $6b, $01, $78, $00, $09, $54, $5d, $e1, $c3, $90, $30, $f1, $ea, $c3
    db $c0, $ea, $00, $40, $c9

; C: leftover: 94 bytes of code MABIKI_BYTE of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_714E_MABIKI_BYTE::
    db $7e, $e0, $88, $01, $10, $00, $09, $7e, $e0, $89, $01, $f0, $ff, $09, $f0, $88
    db $07, $cb, $10, $07, $07, $cb, $10, $07, $07, $cb, $10, $07, $07, $cb, $10, $f0
    db $89, $07, $cb, $10, $07, $07, $cb, $10, $07, $07, $cb, $10, $07, $07, $cb, $10
    db $78, $12, $e5, $62, $6b, $01, $80, $00, $09, $77, $01, $80, $06, $09, $77, $01
    db $80, $00, $09, $77, $01, $80, $f8, $09, $54, $5d, $e1, $c9, $01, $80, $07, $09
    db $77, $01, $80, $00, $09, $77, $01, $80, $f7, $09, $54, $5d, $e1, $c9

; C: leftover: 253 bytes of code MABIKI_MODE2 of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_71AC_MABIKI_MODE2::
    db $fa, $c3, $c0, $f5, $3e, $00, $ea, $c3, $c0, $ea, $00, $40, $fa, $d0, $c0, $fe
    db $00, $20, $05, $11, $00, $d0, $18, $15, $fe, $01, $20, $05, $11, $80, $d0, $18
    db $0c, $fe, $02, $20, $05, $11, $80, $d7, $18, $03, $11, $00, $d7, $21, $00, $a0
    db $3c, $fe, $04, $20, $02, $3e, $00, $ea, $d0, $c0, $3e, $07, $ea, $bf, $c0, $3e
    db $08, $ea, $be, $c0, $cd, $a9, $32, $23, $13, $cd, $a9, $32, $23, $23, $23, $13
    db $cd, $a9, $32, $23, $13, $cd, $a9, $32, $23, $23, $23, $13, $cd, $a9, $32, $23
    db $13, $cd, $a9, $32, $23, $23, $23, $13, $cd, $a9, $32, $23, $13, $cd, $a9, $32
    db $23, $23, $23, $13, $01, $10, $00, $09, $13, $13, $13, $13, $13, $13, $13, $13
    db $fa, $be, $c0, $3d, $ea, $be, $c0, $c2, $f0, $31, $e5, $62, $6b, $01, $88, $ff
    db $09, $54, $5d, $e1, $3e, $08, $ea, $be, $c0, $cd, $a9, $32, $23, $13, $cd, $a9
    db $32, $23, $23, $23, $13, $cd, $a9, $32, $23, $13, $cd, $a9, $32, $23, $23, $23
    db $13, $cd, $a9, $32, $23, $13, $cd, $a9, $32, $23, $23, $23, $13, $cd, $a9, $32
    db $23, $13, $cd, $a9, $32, $23, $23, $23, $13, $01, $10, $00, $09, $13, $13, $13
    db $13, $13, $13, $13, $13, $fa, $be, $c0, $3d, $ea, $be, $c0, $c2, $45, $32, $fa
    db $bf, $c0, $3d, $28, $10, $ea, $bf, $c0, $e5, $62, $6b, $01, $78, $00, $09, $54
    db $5d, $e1, $c3, $eb, $31, $f1, $ea, $c3, $c0, $ea, $00, $40, $c9

; C: leftover: 51 bytes of code MABIKI_BYTE2 of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_72A9_MABIKI_BYTE2::
    db $7e, $e0, $88, $01, $10, $00, $09, $7e, $e0, $89, $01, $f0, $ff, $09, $f0, $88
    db $07, $cb, $10, $07, $07, $cb, $10, $07, $07, $cb, $10, $07, $07, $cb, $10, $f0
    db $89, $07, $cb, $10, $07, $07, $cb, $10, $07, $07, $cb, $10, $07, $07, $cb, $10
    db $78, $12, $c9

; C: leftover: 59 bytes of code TATE_NOBASI_MODE of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_72DC_TATE_NOBASI_MODE::
    db $fa, $c3, $c0, $f5, $3e, $00, $ea, $c3, $c0, $ea, $00, $40, $21, $00, $a4, $11
    db $00, $d0, $3e, $07, $e0, $8a, $3e, $10, $e0, $89, $cd, $17, $33, $f0, $89, $3d
    db $e0, $89, $20, $f6, $e5, $21, $00, $01, $19, $54, $5d, $e1, $f0, $8a, $3d, $e0
    db $8a, $20, $e3, $f1, $ea, $c3, $c0, $ea, $00, $40, $c9

; C: leftover: 71 bytes of code TN_CHARACTER of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_7317_TN_CHARACTER::
    db $3e, $04, $e0, $88, $2a, $47, $2a, $4f, $78, $12, $13, $79, $12, $13, $78, $12
    db $13, $79, $12, $13, $f0, $88, $3d, $e0, $88, $20, $e9, $e5, $21, $f0, $00, $19
    db $54, $5d, $e1, $3e, $04, $e0, $88, $2a, $47, $2a, $4f, $78, $12, $13, $79, $12
    db $13, $78, $12, $13, $79, $12, $13, $f0, $88, $3d, $e0, $88, $20, $e9, $e5, $21
    db $00, $ff, $19, $54, $5d, $e1, $c9

; C: leftover: 57 bytes of code YOKO_NOBASI_MODE of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_735E_YOKO_NOBASI_MODE::
    db $fa, $c3, $c0, $f5, $3e, $00, $ea, $c3, $c0, $ea, $00, $40, $21, $40, $a0, $11
    db $00, $d0, $3e, $0e, $e0, $8a, $3e, $08, $e0, $89, $cd, $97, $33, $f0, $89, $3d
    db $e0, $89, $20, $f6, $d5, $11, $80, $00, $19, $d1, $f0, $8a, $3d, $e0, $8a, $20
    db $e5, $f1, $ea, $c3, $c0, $ea, $00, $40, $c9

; C: leftover: 23 bytes of code YN_CHARACTER of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_7397_YN_CHARACTER::
    db $3e, $10, $e0, $88, $cd, $ae, $33, $f0, $88, $3d, $e0, $88, $20, $f6, $e5, $21
    db $10, $00, $19, $54, $5d, $e1, $c9

; C: leftover: 79 bytes of code YN_BYTE of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_73AE_YN_BYTE::
    db $2a, $e5, $67, $6f, $cb, $14, $cb, $10, $cb, $15, $cb, $10, $cb, $14, $cb, $10
    db $cb, $15, $cb, $10, $cb, $14, $cb, $10, $cb, $15, $cb, $10, $cb, $14, $cb, $10
    db $cb, $15, $cb, $10, $cb, $14, $cb, $11, $cb, $15, $cb, $11, $cb, $14, $cb, $11
    db $cb, $15, $cb, $11, $cb, $14, $cb, $11, $cb, $15, $cb, $11, $cb, $14, $cb, $11
    db $cb, $15, $cb, $11, $78, $12, $21, $10, $00, $19, $79, $77, $13, $e1, $c9

; C: leftover: 65 bytes of code KAKUDAI_MODE of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_73FD_KAKUDAI_MODE::
    db $fa, $c3, $c0, $f5, $3e, $00, $ea, $c3, $c0, $ea, $00, $40, $21, $40, $a4, $11
    db $00, $d0, $3e, $07, $e0, $8a, $3e, $08, $e0, $89, $cd, $3e, $34, $f0, $89, $3d
    db $e0, $89, $20, $f6, $d5, $11, $80, $00, $19, $d1, $e5, $21, $00, $01, $19, $54
    db $5d, $e1, $f0, $8a, $3d, $e0, $8a, $20, $dd, $f1, $ea, $c3, $c0, $ea, $00, $40
    db $c9

; C: leftover: 55 bytes of code KD_CHARACTER of the bank 0 of an older build (the build of table $35); address and
; name from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_743E_KD_CHARACTER::
    db $3e, $04, $e0, $88, $cd, $75, $34, $1b, $cd, $75, $34, $13, $f0, $88, $3d, $e0
    db $88, $20, $f1, $e5, $21, $f0, $00, $19, $54, $5d, $e1, $3e, $04, $e0, $88, $cd
    db $75, $34, $1b, $cd, $75, $34, $13, $f0, $88, $3d, $e0, $88, $20, $f1, $e5, $21
    db $10, $ff, $19, $54, $5d, $e1, $c9

; C: leftover: 84 bytes of code KD_BYTE of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_7475_KD_BYTE::
    db $2a, $e5, $67, $6f, $cb, $14, $cb, $10, $cb, $15, $cb, $10, $cb, $14, $cb, $10
    db $cb, $15, $cb, $10, $cb, $14, $cb, $10, $cb, $15, $cb, $10, $cb, $14, $cb, $10
    db $cb, $15, $cb, $10, $cb, $14, $cb, $11, $cb, $15, $cb, $11, $cb, $14, $cb, $11
    db $cb, $15, $cb, $11, $cb, $14, $cb, $11, $cb, $15, $cb, $11, $cb, $14, $cb, $11
    db $cb, $15, $cb, $11, $78, $12, $13, $13, $12, $21, $0e, $00, $19, $79, $77, $23
    db $23, $77, $e1, $c9

; C: leftover: 92 bytes of code MAKE_HOI of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_74C9_MAKE_HOI::
    db $cd, $da, $05, $cd, $48, $06, $cd, $cf, $05, $f0, $fd, $f5, $3e, $03, $e0, $fd
    db $ea, $00, $21, $21, $01, $40, $11, $00, $80, $01, $00, $18, $cd, $c8, $02, $21
    db $01, $58, $11, $00, $98, $01, $40, $02, $cd, $bf, $02, $f1, $e0, $fd, $ea, $00
    db $21, $cd, $2e, $07, $cd, $13, $07, $cd, $20, $07, $21, $c4, $c0, $af, $22, $3e
    db $88, $77, $21, $01, $40, $7d, $ea, $c6, $c0, $7c, $ea, $c7, $c0, $3e, $0b, $ea
    db $a0, $c0, $3e, $04, $ea, $00, $20, $3e, $c3, $e0, $40, $c9

; C: leftover: 111 bytes of code HOI_MAIN of the bank 0 of an older build (the build of table $35); address and name
; from symbol table $35, called in its bank; code that this build never runs (typed data)
Leftover_37_7525_HOI_MAIN::
    db $fa, $c5, $c0, $d6, $96, $30, $09, $3e, $01, $ea, $c9, $c0, $cd, $57, $18, $c9
    db $3e, $05, $ea, $00, $20, $f0, $80, $cb, $2f, $cb, $2f, $38, $1e, $cb, $2f, $cb
    db $2f, $cb, $2f, $38, $1f, $cb, $2f, $38, $20, $cb, $2f, $38, $21, $cb, $2f, $38
    db $22, $3e, $04, $ea, $00, $20, $21, $01, $40, $18, $1b, $3e, $05, $ea, $bd, $c0
    db $cd, $44, $08, $c9, $21, $01, $6a, $18, $0d, $21, $01, $5c, $18, $08, $21, $01
    db $40, $18, $03, $21, $01, $4e, $7d, $ea, $c6, $c0, $7c, $ea, $c7, $c0, $3e, $00
    db $ea, $c4, $c0, $3e, $88, $ea, $c5, $c0, $cd, $ad, $18, $c3, $2c, $35, $c9

; C: leftover: 23 bytes of code SIOINT of the printer library of an older build, the Japanese Prn_SerialIrq (00:0F16,
; exact match, instruction ratio 1.00); address and name from symbol table $35; code that this build never runs (typed
; data)
Leftover_37_7594_SIOINT::
    db $f5, $f0, $02, $cb, $7f, $20, $0e, $c5, $d5, $e5, $3e, $01, $ea, $5b, $c3, $cd
    db $ca, $35, $e1, $d1, $c1, $f1, $d9

; C: leftover: 31 bytes of code SIOWATCHDOG of the printer library of an older build, the Japanese Prn_VBlankPoll
; (00:0F2D, near match, instruction ratio 0.97); address and name from symbol table $35; code that this build never
; runs (typed data)
Leftover_37_75AB_SIOWATCHDOG::
    db $fa, $3e, $c3, $fe, $01, $c0, $fa, $58, $c3, $fe, $ff, $c8, $fa, $6c, $c3, $a7
    db $c0, $21, $6f, $c3, $34, $7e, $fe, $06, $d8, $af, $77, $cd, $a8, $39, $c9

; C: leftover: 62 bytes of code SIOPROC of the printer library of an older build, the Japanese Prn_SerialStep
; (00:176F, exact match, instruction ratio 1.00); address and name from symbol table $35; code that this build never
; runs (typed data)
Leftover_37_75CA_SIOPROC::
    db $fa, $6d, $c3, $a7, $c2, $5c, $37, $fa, $3e, $c3, $fe, $07, $ca, $18, $37, $fa
    db $40, $c3, $a7, $20, $06, $cd, $08, $36, $c3, $60, $37, $fa, $41, $c3, $a7, $28
    db $17, $fa, $42, $c3, $a7, $28, $11, $fa, $43, $c3, $fe, $02, $28, $05, $cd, $e7
    db $36, $18, $08, $cd, $fe, $36, $18, $03, $cd, $2d, $36, $c3, $60, $37

; C: leftover: 37 bytes of code PREAMBLETRANS of the printer library of an older build, the Japanese Prn_SendSyncByte
; (00:17AD, exact match, instruction ratio 1.00); address and name from symbol table $35; code that this build never
; runs (typed data)
Leftover_37_7608_PREAMBLETRANS::
    db $21, $4a, $c3, $4e, $34, $06, $00, $21, $fb, $39, $09, $7e, $e0, $01, $3e, $01
    db $e0, $02, $3e, $81, $e0, $02, $fa, $4a, $c3, $fe, $02, $c0, $af, $ea, $4a, $c3
    db $3c, $ea, $40, $c3, $c9

; C: leftover: 142 bytes of code TRANSMIT of the printer library of an older build, the Japanese Prn_SendPacketByte
; (00:17D2, near match, instruction ratio 0.95); address and name from symbol table $35; code that this build never
; runs (typed data)
Leftover_37_762D_TRANSMIT::
    db $fa, $4a, $c3, $4f, $fa, $4b, $c3, $47, $fa, $4c, $c3, $6f, $fa, $4d, $c3, $67
    db $09, $f0, $01, $ea, $5a, $c3, $7e, $e0, $01, $6f, $fa, $54, $c3, $85, $ea, $54
    db $c3, $fa, $55, $c3, $ce, $00, $ea, $55, $c3, $3e, $01, $e0, $02, $3e, $81, $e0
    db $02, $21, $4a, $c3, $34, $20, $02, $23, $34, $21, $4a, $c3, $fa, $44, $c3, $be
    db $20, $07, $23, $fa, $45, $c3, $be, $28, $02, $18, $3e, $21, $41, $c3, $7e, $a7
    db $28, $03, $21, $42, $c3, $34, $fa, $5d, $c3, $a7, $28, $32, $fa, $3e, $c3, $fe
    db $06, $28, $2b, $21, $42, $c3, $7e, $a7, $20, $20, $af, $ea, $4a, $c3, $ea, $4b
    db $c3, $fa, $50, $c3, $ea, $4c, $c3, $fa, $51, $c3, $ea, $4d, $c3, $fa, $48, $c3
    db $ea, $44, $c3, $fa, $49, $c3, $ea, $45, $c3, $c9, $cd, $ce, $36, $c9

; C: leftover: 6 bytes of code SETENDOFTRANS of the printer library of an older build, no Japanese counterpart of 0.8
; or more; address and name from symbol table $35; code that this build never runs (typed data)
Leftover_37_76BB_SETENDOFTRANS::
    db $fa, $5a, $c3, $ea, $59, $c3

; C: leftover: 13 bytes of code SETENDOFTRANS_DATA of the printer library of an older build, no Japanese counterpart
; of 0.8 or more; address and name from symbol table $35; code that this build never runs (typed data)
Leftover_37_76C1_SETENDOFTRANS_DATA::
    db $3e, $07, $ea, $3e, $c3, $3e, $01, $ea, $56, $c3, $cd, $c6, $37

; C: leftover: 25 bytes of code FORRETRY_DATATRANS of the printer library of an older build, the Japanese
; Prn_RestoreHeaderPtr (00:1873, exact match, instruction ratio 1.00); address and name from symbol table $35; code
; that this build never runs (typed data)
Leftover_37_76CE_FORRETRY_DATATRANS::
    db $fa, $46, $c3, $ea, $44, $c3, $fa, $47, $c3, $ea, $45, $c3, $fa, $4e, $c3, $ea
    db $4c, $c3, $fa, $4f, $c3, $ea, $4d, $c3, $c9

; C: leftover: 23 bytes of code TRANSCHECKSUM of the printer library of an older build, the Japanese
; Prn_SendChecksumByte (00:188C, exact match, instruction ratio 1.00); address and name from symbol table $35; code
; that this build never runs (typed data)
Leftover_37_76E7_TRANSCHECKSUM::
    db $4f, $06, $00, $21, $54, $c3, $09, $7e, $e0, $01, $3e, $01, $e0, $02, $3e, $81
    db $e0, $02, $21, $43, $c3, $34, $c9

; C: leftover: 26 bytes of code TRANSDUMMY of the printer library of an older build, the Japanese Prn_SendTrailerByte
; (00:18A3, exact match, instruction ratio 1.00); address and name from symbol table $35; code that this build never
; runs (typed data)
Leftover_37_76FE_TRANSDUMMY::
    db $f0, $01, $ea, $59, $c3, $af, $e0, $01, $3e, $01, $e0, $02, $3e, $81, $e0, $02
    db $21, $57, $c3, $34, $7e, $fe, $02, $28, $aa, $c9

; C: leftover: 68 bytes of code GETPRINTERSTATUS of the printer library of an older build, the Japanese
; Prn_ReceiveStatus (00:18BD, near match, instruction ratio 0.90); address and name from symbol table $35; code that
; this build never runs (typed data)
Leftover_37_7718_GETPRINTERSTATUS::
    db $fa, $5c, $c3, $ea, $3f, $c3, $fa, $58, $c3, $ea, $01, $c3, $fe, $ff, $28, $03
    db $ea, $00, $c3, $f0, $01, $ea, $58, $c3, $fe, $ff, $20, $0c, $3e, $00, $ea, $6c
    db $c3, $ea, $3e, $c3, $3e, $02, $18, $0f, $cb, $67, $3e, $00, $ea, $3e, $c3, $3e
    db $01, $20, $03, $ea, $3e, $c3, $3c, $ea, $56, $c3, $fa, $5d, $c3, $a7, $20, $04
    db $af, $ea, $6c, $c3

; C: leftover: 1 bytes of code SIOFORCEEND of the printer library of an older build, too short to pair with a Japanese
; routine; address and name from symbol table $35; code that this build never runs (typed data)
Leftover_37_775C_SIOFORCEEND::
    db $c9

; C: leftover: 3 bytes of code SIOERRORRET of the printer library of an older build, too short to pair with a Japanese
; routine; address and name from symbol table $35; code that this build never runs (typed data)
Leftover_37_775D_SIOERRORRET::
    db $af, $e0, $02

; C: leftover: 1 bytes of code SIOINTRET of the printer library of an older build, too short to pair with a Japanese
; routine; address and name from symbol table $35; code that this build never runs (typed data)
Leftover_37_7760_SIOINTRET::
    db $c9

; C: leftover: 62 bytes of code PRINT_PICTURE_MAKE of the printer library of an older build, no Japanese counterpart
; of 0.8 or more; address and name from symbol table $35; code that this build never runs (typed data)
Leftover_37_7761_PRINT_PICTURE_MAKE::
    db $21, $00, $c8, $01, $80, $16, $af, $22, $0d, $20, $fc, $05, $20, $f9, $cd, $73
    db $37, $c9, $21, $00, $90, $11, $a0, $ca, $06, $08, $cd, $8b, $37, $21, $00, $88
    db $06, $01, $cd, $8b, $37, $21, $00, $80, $06, $05, $0e, $00, $2a, $12, $13, $0d
    db $20, $fa, $e5, $21, $40, $00, $19, $5d, $54, $e1, $05, $20, $ed, $c9

; C: leftover: 5 bytes of code SIOHIBERNATE of the printer library of an older build, too short to pair with a
; Japanese routine; address and name from symbol table $35; code that this build never runs (typed data)
Leftover_37_779F_SIOHIBERNATE::
    db $af, $e0, $02, $e0, $01

; C: leftover: 24 bytes of code SIOINITIALIZE of the printer library of an older build, the Japanese Prn_EngineStop
; (00:1914, near match, instruction ratio 0.90); address and name from symbol table $35; code that this build never
; runs (typed data)
Leftover_37_77A4_SIOINITIALIZE::
    db $af, $e0, $01, $e0, $02, $ea, $3e, $c3, $3d, $ea, $58, $c3, $ea, $59, $c3, $3e
    db $80, $ea, $38, $c3, $cd, $bc, $37, $c9

; C: leftover: 10 bytes of code SIOFLAGINIT of the printer library of an older build, the Japanese Prn_ClearTxFlags
; (00:1927, exact match, instruction ratio 1.00); address and name from symbol table $35; code that this build never
; runs (typed data)
Leftover_37_77BC_SIOFLAGINIT::
    db $af, $ea, $56, $c3, $ea, $5b, $c3, $ea, $6c, $c3

; C: leftover: 32 bytes of code CLEARFLAGS of the printer library of an older build, the Japanese Prn_ResetPacketState
; (00:1931, near match, instruction ratio 0.96); address and name from symbol table $35; code that this build never
; runs (typed data)
Leftover_37_77C6_CLEARFLAGS::
    db $af, $ea, $40, $c3, $ea, $41, $c3, $ea, $42, $c3, $ea, $43, $c3, $ea, $57, $c3
    db $ea, $54, $c3, $ea, $55, $c3, $ea, $4a, $c3, $ea, $4b, $c3, $ea, $6d, $c3, $c9

; C: leftover: 27 bytes of code CONNECTPRN of the printer library of an older build, the Japanese Prn_SendInit
; (00:1954, exact match, instruction ratio 1.00); address and name from symbol table $35; code that this build never
; runs (typed data)
Leftover_37_77E6_CONNECTPRN::
    db $fa, $6c, $c3, $a7, $28, $04, $cd, $01, $38, $d0, $fa, $3f, $c3, $fe, $01, $20
    db $04, $cd, $01, $38, $d0, $cd, $21, $3a, $c3, $e4, $3a

; C: leftover: 67 bytes of code CHECKENDOFTRANS of the printer library of an older build, the Japanese Prn_CheckTxDone
; (00:196F, near match, instruction ratio 0.81); address and name from symbol table $35; code that this build never
; runs (typed data)
Leftover_37_7801_CHECKENDOFTRANS::
    db $fa, $56, $c3, $fe, $02, $20, $38, $af, $ea, $6f, $c3, $ea, $3f, $c3, $3c, $ea
    db $3e, $c3, $fa, $58, $c3, $fe, $ff, $28, $1f, $cb, $47, $20, $14, $cb, $4f, $20
    db $10, $cb, $67, $28, $18, $af, $ea, $3e, $c3, $ea, $3f, $c3, $fa, $58, $c3, $18
    db $0c, $37, $c9, $af, $ea, $3f, $c3, $3d, $3c, $ea, $3e, $c3, $3d, $a7, $c9, $af
    db $3e, $f0, $c9

; C: leftover: 51 bytes of code INSTRUCTPRN of the printer library of an older build, the Japanese Prn_SendPrint
; (00:19B2, near match, instruction ratio 0.94); address and name from symbol table $35; code that this build never
; runs (typed data)
Leftover_37_7844_INSTRUCTPRN::
    db $fa, $3e, $c3, $fe, $01, $28, $0b, $fe, $02, $28, $07, $a7, $3e, $ff, $c8, $3e
    db $f0, $c9, $fa, $6c, $c3, $a7, $28, $04, $cd, $01, $38, $d0, $fa, $3f, $c3, $fe
    db $02, $20, $04, $cd, $01, $38, $d0, $fa, $58, $c3, $fe, $ff, $c8, $cd, $2e, $3a
    db $c3, $e4, $3a

; C: leftover: 254 bytes of code DATATRANSPRN of the printer library of an older build, no Japanese counterpart of 0.8
; or more; address and name from symbol table $35; code that this build never runs (typed data)
Leftover_37_7877_DATATRANSPRN::
    db $4f, $fa, $3e, $c3, $a7, $fa, $58, $c3, $c8, $fa, $3e, $c3, $fe, $01, $28, $07
    db $fe, $03, $28, $03, $3e, $f0, $c9, $fa, $6c, $c3, $a7, $20, $50, $79, $3c, $ea
    db $6e, $c3, $7d, $ea, $52, $c3, $7c, $ea, $53, $c3, $fa, $58, $c3, $fe, $ff, $c8
    db $fa, $3c, $c3, $ea, $3d, $c3, $a7, $28, $26, $3e, $0a, $ea, $6e, $c3, $3d, $3d
    db $f5, $4f, $06, $00, $e5, $21, $2e, $c3, $09, $7e, $e1, $ea, $3d, $c3, $f1, $87
    db $4f, $06, $00, $e5, $21, $1c, $c3, $09, $2a, $46, $e1, $4f, $c3, $de, $38, $01
    db $80, $02, $3e, $0a, $ea, $6e, $c3, $cd, $88, $3a, $c3, $e4, $3a, $fa, $56, $c3
    db $fe, $02, $3e, $f0, $c2, $6e, $39, $21, $6e, $c3, $fa, $58, $c3, $cb, $67, $c2
    db $5e, $39, $cb, $4f, $c2, $09, $39, $cb, $47, $c2, $09, $39, $35, $fa, $58, $c3
    db $28, $5c, $7e, $fe, $01, $28, $61, $01, $80, $02, $fa, $3c, $c3, $ea, $3d, $c3
    db $a7, $28, $21, $fa, $6e, $c3, $3d, $3d, $f5, $4f, $06, $00, $e5, $21, $2e, $c3
    db $09, $7e, $e1, $ea, $3d, $c3, $f1, $87, $4f, $06, $00, $e5, $21, $1c, $c3, $09
    db $2a, $46, $e1, $4f, $fa, $58, $c3, $cb, $4f, $c2, $53, $39, $fa, $50, $c3, $c6
    db $80, $ea, $50, $c3, $fa, $51, $c3, $ce, $02, $ea, $51, $c3, $fa, $50, $c3, $6f
    db $fa, $51, $c3, $67, $c3, $de, $38, $f5, $3e, $01, $ea, $6d, $c3, $f1, $f5, $af
    db $ea, $5d, $c3, $ea, $6c, $c3, $f1, $c9, $cd, $d6, $3a, $c3, $e4, $3a

; C: leftover: 51 bytes of code BREAKPRN of the printer library of an older build, the Japanese Prn_SendBreak_Dead
; (00:1AEB, exact match, instruction ratio 1.00); address and name from symbol table $35; code that this build never
; runs (typed data)
Leftover_37_7975_BREAKPRN::
    db $fa, $3e, $c3, $fe, $01, $28, $0b, $fe, $03, $28, $07, $a7, $3e, $ff, $c8, $3e
    db $f0, $c9, $fa, $6c, $c3, $a7, $28, $04, $cd, $01, $38, $d0, $fa, $3f, $c3, $fe
    db $04, $20, $04, $cd, $01, $38, $d0, $fa, $58, $c3, $fe, $ff, $c8, $cd, $bc, $3a
    db $c3, $e4, $3a

; C: leftover: 40 bytes of code NULTRANSPRN of the printer library of an older build, the Japanese Prn_SendInquiry
; (00:1B1E, exact match, instruction ratio 1.00); address and name from symbol table $35; code that this build never
; runs (typed data)
Leftover_37_79A8_NULTRANSPRN::
    db $fa, $3e, $c3, $fe, $01, $28, $0b, $fe, $03, $28, $07, $a7, $3e, $ff, $c8, $3e
    db $f0, $c9, $fa, $6c, $c3, $a7, $28, $04, $cd, $01, $38, $d0, $fa, $58, $c3, $fe
    db $ff, $c8, $cd, $c9, $3a, $c3, $e4, $3a

; C: leftover: 43 bytes of code INITDATATRANS of the printer library of an older build, the Japanese Prn_QueuePacket
; (00:1B46, exact match, instruction ratio 1.00); address and name from symbol table $35; code that this build never
; runs (typed data)
Leftover_37_79D0_INITDATATRANS::
    db $ea, $5c, $c3, $7a, $ea, $5d, $c3, $7d, $ea, $4c, $c3, $ea, $4e, $c3, $7c, $ea
    db $4d, $c3, $ea, $4f, $c3, $79, $ea, $44, $c3, $ea, $46, $c3, $78, $ea, $45, $c3
    db $ea, $47, $c3, $af, $ea, $56, $c3, $cd, $c6, $37, $c9

; C: leftover: 2 bytes of data PREAMBLEDATA of the printer library of an older build, the Japanese Prn_SyncBytes
; (00:1B71, exact match, instruction ratio 1.00); address and name from symbol table $35; nothing in this build reads
; it
Leftover_37_79FB_PREAMBLEDATA::
    db $88, $33

; C: leftover: 8 bytes of data PACKET1 of the printer library of an older build, the Japanese Prn_PktInit (00:1B73,
; exact match, instruction ratio 1.00); address and name from symbol table $35; nothing in this build reads it
Leftover_37_79FD_PACKET1::
    db $01, $00, $00, $00, $01, $00, $00, $00

; C: leftover: 4 bytes of data PACKET2 of the printer library of an older build, the Japanese Prn_PktPrintHdr
; (00:1B7B, exact match, instruction ratio 1.00); address and name from symbol table $35; nothing in this build reads
; it
Leftover_37_7A05_PACKET2::
    db $02, $00, $04, $00

; C: leftover: 8 bytes of data PACKET6 of the printer library of an older build, the Japanese Prn_PktDataEnd (00:1B7F,
; exact match, instruction ratio 1.00); address and name from symbol table $35; nothing in this build reads it
Leftover_37_7A09_PACKET6::
    db $04, $00, $00, $00, $04, $00, $00, $00

; C: leftover: 8 bytes of data PACKET4 of the printer library of an older build, the Japanese Prn_PktBreak (00:1B87,
; exact match, instruction ratio 1.00); address and name from symbol table $35; nothing in this build reads it
Leftover_37_7A11_PACKET4::
    db $08, $00, $00, $00, $08, $00, $00, $00

; C: leftover: 8 bytes of data PACKET5 of the printer library of an older build, the Japanese Prn_PktInquiry (00:1B8F,
; exact match, instruction ratio 1.00); address and name from symbol table $35; nothing in this build reads it
Leftover_37_7A19_PACKET5::
    db $0f, $00, $00, $00, $0f, $00, $00, $00

; C: leftover: 13 bytes of code PREPAREPACKET1 of the printer library of an older build, the Japanese Prn_QueueInit
; (00:1B97, exact match, instruction ratio 1.00); address and name from symbol table $35; code that this build never
; runs (typed data)
Leftover_37_7A21_PREPAREPACKET1::
    db $3e, $01, $16, $00, $21, $fd, $39, $01, $08, $00, $c3, $d0, $39

; C: leftover: 90 bytes of code PREPAREPACKET2 of the printer library of an older build, the Japanese Prn_QueuePrint
; (00:1BA4, near match, instruction ratio 0.83); address and name from symbol table $35; code that this build never
; runs (typed data)
Leftover_37_7A2E_PREPAREPACKET2::
    db $3e, $02, $16, $00, $21, $5e, $c3, $01, $0c, $00, $cd, $d0, $39, $21, $05, $3a
    db $11, $5e, $c3, $01, $04, $00, $2a, $12, $13, $0d, $20, $fa, $11, $06, $00, $fa
    db $39, $c3, $ea, $62, $c3, $cd, $81, $3a, $fa, $3a, $c3, $ea, $63, $c3, $cd, $81
    db $3a, $fa, $3b, $c3, $ea, $64, $c3, $cd, $81, $3a, $fa, $38, $c3, $ea, $65, $c3
    db $cd, $81, $3a, $7b, $ea, $66, $c3, $7a, $ea, $67, $c3, $af, $ea, $68, $c3, $ea
    db $69, $c3, $c9, $83, $5f, $7a, $ce, $00, $57, $c9

; C: leftover: 52 bytes of code PREPAREPACKET3 of the printer library of an older build, the Japanese Prn_QueueData
; (00:1BFB, exact match, instruction ratio 1.00); address and name from symbol table $35; code that this build never
; runs (typed data)
Leftover_37_7A88_PREPAREPACKET3::
    db $7d, $ea, $50, $c3, $7c, $ea, $51, $c3, $79, $ea, $48, $c3, $78, $ea, $49, $c3
    db $c5, $3e, $03, $16, $01, $21, $5e, $c3, $01, $04, $00, $cd, $d0, $39, $fa, $09
    db $3a, $ea, $5e, $c3, $fa, $3d, $c3, $ea, $5f, $c3, $c1, $79, $ea, $60, $c3, $78
    db $ea, $61, $c3, $c9

; C: leftover: 13 bytes of code PREPAREPACKET4 of the printer library of an older build, the Japanese Prn_QueueInit
; (00:1B97, near match, instruction ratio 0.80); address and name from symbol table $35; code that this build never
; runs (typed data)
Leftover_37_7ABC_PREPAREPACKET4::
    db $3e, $04, $16, $00, $21, $11, $3a, $01, $08, $00, $c3, $d0, $39

; C: leftover: 13 bytes of code PREPAREPACKET5 of the printer library of an older build, the Japanese Prn_QueueInquiry
; (00:1C3C, exact match, instruction ratio 1.00); address and name from symbol table $35; code that this build never
; runs (typed data)
Leftover_37_7AC9_PREPAREPACKET5::
    db $3e, $05, $16, $00, $21, $19, $3a, $01, $08, $00, $c3, $d0, $39

; C: leftover: 14 bytes of code PREPAREPACKET6 of the printer library of an older build, the Japanese Prn_QueueDataEnd
; (00:1C49, near match, instruction ratio 0.91); address and name from symbol table $35; code that this build never
; runs (typed data)
Leftover_37_7AD6_PREPAREPACKET6::
    db $3e, $06, $16, $01, $21, $09, $3a, $01, $08, $00, $c3, $d0, $39, $c9

; C: leftover: 60 bytes of code STARTSTRINGTRANS of the printer library of an older build, the Japanese
; Prn_StartTransmit (00:1C57, exact match, instruction ratio 1.00); address and name from symbol table $35; code that
; this build never runs (typed data)
Leftover_37_7AE4_STARTSTRINGTRANS::
    INCBIN "data/bank_37/Leftover_37_7AE4_STARTSTRINGTRANS.bin" ; $7AE4, 1307 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_37_7FFF::
    db $37
