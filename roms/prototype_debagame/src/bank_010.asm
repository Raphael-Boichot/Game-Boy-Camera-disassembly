; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $10. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $010", ROMX[$4000], BANK[$10]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_10_4000::
    db $10

; I: leftover: 1 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_10_4001::
    db $84

; I: leftover: an exact copy of 18 bytes of CAMECO_INIT (from 37:4700, under the label Leftover_37_4677_CAMECO_INIT),
; a part of the block; step 4b-4: a run of 239 bytes, 78 % equal at that shift; nothing in this build reads, runs or
; explains it (never read nor run in the L2 runs); code that this build ...
Leftover_10_4002_CAMECO_INIT_Part4700::
    db $07, $3e, $04, $e0, $4b, $3e, $60, $e0, $4a, $3e, $01, $ea, $a0, $c0, $3e, $c7
    db $e0, $40

; I: leftover: an exact copy of 1 byte of INIT_END (from 37:4712, under the label Leftover_37_4712_INIT_END); step
; 4b-4: a run of 239 bytes, 78 % equal at that shift; nothing in this build reads, runs or explains it (never read nor
; run in the L2 runs); code that this build never runs (typed data)
Leftover_10_4014_INIT_END::
    db $c9

; I: leftover: an exact copy of 13 bytes of OBJP_DEF_SET (from 37:4713, under the label
; Leftover_37_4713_OBJP_DEF_SET); step 4b-4: a run of 239 bytes, 78 % equal at that shift; nothing in this build
; reads, runs or explains it (never read nor run in the L2 runs); code that this build never runs (typed ...
Leftover_10_4015_OBJP_DEF_SET::
    db $3e, $e4, $e0, $48, $e0, $ac, $3e, $e4, $e0, $49, $e0, $ad, $c9

; I: leftover: an exact copy of 2 bytes of BGP_DEF_SET (from 37:4720, under the label Leftover_37_4720_BGP_DEF_SET);
; step 4b-4: a run of 239 bytes, 78 % equal at that shift; nothing in this build reads, runs or explains it (never
; read nor run in the L2 runs); code that this build never runs (typed data)
Leftover_10_4022_BGP_DEF_SET::
    db $3e, $e4

; I: leftover: an exact copy of 5 bytes of BGP_SET (from 37:4722, under the label Leftover_37_4722_BGP_SET); step
; 4b-4: a run of 239 bytes, 78 % equal at that shift; nothing in this build reads, runs or explains it (never read nor
; run in the L2 runs); code that this build never runs (typed data)
Leftover_10_4024_BGP_SET::
    db $e0, $47, $e0, $ae, $c9

; I: leftover: 7 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_10_4029::
    db $f0, $ae, $0f, $cd, $86, $07, $c9

; I: leftover: an exact copy of 15 bytes of SCYX_SET0 (from 37:472E, under the label Leftover_37_472E_SCYX_SET0); step
; 4b-4: a run of 239 bytes, 78 % equal at that shift; nothing in this build reads, runs or explains it (never read nor
; run in the L2 runs); code that this build never runs (typed data)
Leftover_10_4030_SCYX_SET0::
    db $3e, $00, $e0, $42, $e0, $a1, $e0, $a2, $3e, $00, $e0, $43, $e0, $a0, $c9

; I: leftover: an exact copy of 6 bytes of SOUND_P (from 37:473D, under the label Leftover_37_473D_SOUND_P); step
; 4b-4: a run of 239 bytes, 78 % equal at that shift; nothing in this build reads, runs or explains it (never read nor
; run in the L2 runs)
Leftover_10_403F_SOUND_P::
    db $3e, $3e, $ea, $60, $dc, $c9

; I: leftover: an exact copy of 6 bytes of SOUND_PE (from 37:4743, under the label Leftover_37_4743_SOUND_PE); step
; 4b-4: a run of 239 bytes, 78 % equal at that shift; nothing in this build reads, runs or explains it (never read nor
; run in the L2 runs)
Leftover_10_4045_SOUND_PE::
    db $3e, $3f, $ea, $60, $dc, $c9

; I: leftover: an exact copy of 17 bytes of MEN_FADE_CLR (from 37:4749, under the label
; Leftover_37_4749_MEN_FADE_CLR); step 4b-4: a run of 239 bytes, 78 % equal at that shift; nothing in this build
; reads, runs or explains it (never read nor run in the L2 runs)
Leftover_10_404B_MEN_FADE_CLR::
    db $af, $ea, $a1, $c0, $ea, $a2, $c0, $ea, $a3, $c0, $ea, $a4, $c0, $ea, $a5, $c0
    db $c9

; I: leftover: an exact copy of 6 bytes of MEN_FADE_SET (from 37:475A, under the label Leftover_37_475A_MEN_FADE_SET);
; step 4b-4: a run of 239 bytes, 78 % equal at that shift; nothing in this build reads, runs or explains it (never
; read nor run in the L2 runs); code that this build never runs (typed ...
Leftover_10_405C_MEN_FADE_SET::
    db $3e, $01, $ea, $a1, $c0, $c9

; I: leftover: a variant (93 % of the bytes equal) of 54 bytes of MEN_FADE (from 37:4760, under the label
; Leftover_37_4760_MEN_FADE); step 4b-4: a run of 239 bytes, 78 % equal at that shift; nothing in this build reads,
; runs or explains it (never read nor run in the L2 runs); code that this build never ...
Leftover_10_4062_MEN_FADE_Variant::
    db $fa, $a1, $c0, $a7, $c8, $fa, $a2, $c0, $a7, $28, $07, $3d, $ea, $a2, $c0, $28
    db $25, $c9, $21, $a3, $c0, $34, $7e, $fe, $04, $c0, $36, $00, $f0, $ac, $cd, $04
    db $08, $e0, $ac, $e0, $48, $f0, $ae, $cd, $04, $08, $e0, $ae, $e0, $47, $a7, $c0
    db $3e, $05, $ea, $a2, $c0, $c9

; I: leftover: an exact copy of 10 bytes of MEN_FADE_END (from 37:4796, under the label
; Leftover_37_4796_MEN_FADE_END); step 4b-4: a run of 239 bytes, 78 % equal at that shift; nothing in this build
; reads, runs or explains it (never read nor run in the L2 runs); code that this build never runs (typed ...
Leftover_10_4098_MEN_FADE_END::
    db $af, $ea, $a1, $c0, $3e, $01, $ea, $a4, $c0, $c9

; I: leftover: an exact copy of 26 bytes of MEN_FADE_DEC (from 37:47A0, under the label
; Leftover_37_47A0_MEN_FADE_DEC); step 4b-4: a run of 239 bytes, 78 % equal at that shift; nothing in this build
; reads, runs or explains it (never read nor run in the L2 runs); code that this build never runs (typed ...
Leftover_10_40A2_MEN_FADE_DEC::
    db $4f, $1e, $04, $06, $00, $79, $e6, $03, $28, $01, $3d, $b0, $47, $cb, $08, $cb
    db $08, $cb, $09, $cb, $09, $1d, $20, $ed, $78, $c9

; I: leftover: 72 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_10_40BC::
    db $78, $a0, $ef, $01, $d0, $05, $1e, $08, $21, $01, $40, $11, $00, $80, $01, $00
    db $18, $cd, $03, $03, $21, $01, $58, $11, $00, $98, $01, $40, $02, $cd, $03, $03
    db $21, $43, $08, $11, $00, $c0, $01, $10, $00, $cd, $03, $03, $c9, $60, $4c, $10
    db $00, $60, $54, $12, $00, $60, $5c, $14, $00, $60, $64, $16, $00, $fa, $a6, $c0
    db $3c, $ea, $a6, $c0, $00, $40, $1b, $c2

; I: leftover: an exact copy of 55 bytes of GAME_TITL (from 00:04FA, a part of the block) that nothing in this build
; reads, runs or explains (never read nor run in the L2 runs)
Leftover_10_4104_GAME_TITL_Part04FA::
    db $fe, $10, $20, $2e, $3e, $10, $ea, $02, $c0, $3e, $12, $ea, $06, $c0, $3e, $14
    db $ea, $0a, $c0, $3e, $16, $ea, $0e, $c0, $af, $ea, $a6, $c0, $18, $14, $3e, $18
    db $ea, $02, $c0, $3e, $1a, $ea, $06, $c0, $3e, $1c, $ea, $0a, $c0, $3e, $1e, $ea
    db $0e, $c0, $f0, $81, $e6, $0f, $c4

; I: leftover: 62 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_10_413B::
    db $be, $07, $cd, $c4, $07, $fa, $a4, $c0, $a7, $28, $07, $af, $ea, $bd, $c0, $cd
    db $a8, $08, $c9, $cd, $1e, $06, $cd, $8c, $06, $cd, $13, $06, $f0, $fd, $f5, $3e
    db $01, $e0, $fd, $ea, $00, $21, $21, $01, $40, $11, $00, $80, $01, $00, $18, $cd
    db $03, $03, $21, $41, $5a, $11, $00, $98, $01, $40, $02, $cd, $03, $03

; I: leftover: an exact copy of 46 bytes of WANKO (from 00:056F, a part of the block) that nothing in this build
; reads, runs or explains (never read nor run in the L2 runs)
Leftover_10_4179_WANKO_Part056F::
    db $fa, $bd, $c0, $47, $3e, $34, $e0, $88, $78, $b7, $28, $08, $3d, $47, $f0, $88
    db $c6, $10, $18, $f2, $21, $00, $c0, $f0, $88, $22, $3e, $1e, $22, $3e, $04, $22
    db $af, $22, $f0, $88, $22, $3e, $26, $22, $3e, $06, $22, $af, $22, $cd

; I: leftover: 89 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_10_41A7::
    db $92, $07, $cd, $77, $07, $cd, $84, $07, $3e, $c7, $e0, $40, $3e, $02, $ea, $a0
    db $c0, $f1, $e0, $fd, $ea, $00, $21, $c9, $f0, $81, $cb, $27, $da, $8e, $09, $cb
    db $27, $da, $9d, $09, $cb, $27, $cb, $27, $cb, $27, $cb, $27, $cb, $27, $cb, $27
    db $38, $06, $cd, $bf, $09, $c3, $be, $09, $3e, $08, $ea, $02, $c0, $3e, $0a, $ea
    db $06, $c0, $3e, $08, $e0, $a5, $af, $ea, $bd, $c0, $3e, $20, $e0, $88, $f0, $88
    db $b7, $28, $17, $3d, $e0, $88, $cd, $bf, $09

; I: 15871 bytes: structured array of unknown kind (owner, 2026-11-23: set aside as typed data of unknown kind): part
; of the first of the two arrays of 381 columns laid through the image before the bank heads (banks $08-$10, one value
; a byte, mostly $00 / $01 / $03 / $80 / $81; tools/proto_grids.py, ...
Leftover_10_4200_Grid381Binary::
    INCBIN "data/bank_10/Leftover_10_4200_Grid381Binary.bin" ; $4200, 15871 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_10_7FFF::
    db $10
