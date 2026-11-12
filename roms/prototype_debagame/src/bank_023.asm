; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $23. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $023", ROMX[$4000], BANK[$23]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_23_4000::
    db $23

; I: leftover text: 255 bytes of the developers' assembler source in clear (0 listing lines, 6 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_23_4001_AsmSource::
    db "4,$89,$8D,$82,$8A", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$C0,$C0,$20,$70", $09, ";0031", $0d, $0a, $09, "DEFB", $09, "$10,$18,$08,$0C,$84,$84,$04,$04", $0d, $0a, $09, "DEFB", $09, "$00,$00,$38,$38,$47,$6F,$80,$C0", $09, ";0032", $0d, $0a, $09, "DEFB", $09, "$80,$80,$AC,$AC,$90,$B0,$C4,$C4", $0d, $0a, $09, "DEFB", $09, "$00,$00,$18,$3C,$E4,$E6,$02,$03", $09, ";0033", $0d, $0a, $09, "DEFB", $09, "$01,$01,$19,$19,$"

; I: leftover: 4 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_4100::
    db $00, $e0, $21, $c2

; I: leftover text: 252 bytes of the developers' assembler source in clear (0 listing lines, 6 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_23_4104_AsmSource::
    db "05,$13,$13", $0d, $0a, $09, "DEFB", $09, "$00,$00,$38,$38,$47,$6F,$80,$C0", $09, ";0034", $0d, $0a, $09, "DEFB", $09, "$8C,$8C,$A0,$A0,$84,$A4,$00,$C0", $0d, $0a, $09, "DEFB", $09, "$00,$00,$18,$3C,$E4,$E6,$02,$03", $09, ";0035", $0d, $0a, $09, "DEFB", $09, "$18,$19,$01,$01,$15,$15,$02,$03", $0d, $0a, $09, "DEFB", $09, "$00,$00,$00,$00,$18,$3C,$67,$6F", $09, ";0036", $0d, $0a, $09, "DEFB", $09, "$80,$C0,$80,$A0,$4C,$"

    ; padding
    ds $115, $00

; I: leftover: an exact copy of 82 bytes of Unused_TCRF_FacePhoto9_HOI_L_Gfx (from 05:60E1, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_4315_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part60E1::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $01, $03

; I: leftover: 4 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_4367::
    db $3b, $5e, $fa, $03

    ; padding
    ds $3aa, $00

; I: leftover: an exact copy of 82 bytes of Unused_TCRF_FacePhoto9_HOI_L_Gfx (from 05:60E1, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_4715_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part60E1::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $01, $03

; I: leftover: 4 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_4767::
    db $35, $62, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Gfx_03_5A41_CONF2 (from 03:6235, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_476B_Gfx_03_5A41_CONF2_Part6235::
    INCBIN "data/bank_23/Leftover_23_476B_Gfx_03_5A41_CONF2_Part6235.bin" ; $476B, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_4B65::
    db $01, $03, $2f, $66, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Gfx_03_5A41_CONF2 (from 03:662F, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_4B6B_Gfx_03_5A41_CONF2_Part662F::
    INCBIN "data/bank_23/Leftover_23_4B6B_Gfx_03_5A41_CONF2_Part662F.bin" ; $4B6B, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_4F65::
    db $01, $03, $29, $6a, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Gfx_03_5A41_CONF2 (from 03:6A29, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_4F6B_Gfx_03_5A41_CONF2_Part6A29::
    INCBIN "data/bank_23/Leftover_23_4F6B_Gfx_03_5A41_CONF2_Part6A29.bin" ; $4F6B, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_5365::
    db $01, $03, $23, $6e, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Gfx_03_5A41_CONF2 (from 03:6E23, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_536B_Gfx_03_5A41_CONF2_Part6E23::
    INCBIN "data/bank_23/Leftover_23_536B_Gfx_03_5A41_CONF2_Part6E23.bin" ; $536B, 1018 bytes
; I: leftover: 5 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_5765::
    db $01, $03, $1d, $72, $24

; I: leftover: an exact copy of 39 bytes of Unused_TCRF_FacePhoto9_HOI_L_Gfx (from 05:610C, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_576A_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part610C::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $01, $03

; I: leftover: 4 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_5791::
    db $41, $72, $40, $02

; I: leftover: an exact copy of Map_03_7241_BG_CONF (03:7241, 576 bytes) that nothing in this build reads, runs or
; explains (never read nor run in the L2 runs)
Leftover_23_5795_Map_03_7241_BG_CONF::
    INCBIN "data/bank_23/Leftover_23_5795_Map_03_7241_BG_CONF.bin" ; $5795, 576 bytes
; I: leftover: 1804 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_59D5::
    db $01, $03, $81, $74, $40, $02, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
    db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
    db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $80, $81, $82, $83, $84, $85, $86, $87
    db $88, $89, $8a, $8b, $8c, $8d, $8e, $8f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
    db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $90, $91, $92, $93, $94, $95, $96, $97
    db $98, $99, $9a, $9b, $9c, $9d, $9e, $9f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
    db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $a0, $a1, $a2, $a3, $a4, $a5, $a6, $a7
    db $a8, $a9, $aa, $ab, $ac, $ad, $ae, $af, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
    db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $b0, $b1, $b2, $b3, $b4, $b5, $b6, $b7
    db $b8, $b9, $ba, $bb, $bc, $bd, $be, $bf, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
    db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $c0, $c1, $c2, $c3, $c4, $c5, $c6, $c7
    db $c8, $c9, $ca, $cb, $cc, $cd, $ce, $cf, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
    db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $d0, $d1, $d2, $d3, $d4, $d5, $d6, $d7
    db $d8, $d9, $da, $db, $dc, $dd, $de, $df, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
    db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $e0, $e1, $e2, $e3, $e4, $e5, $e6, $e7
    db $e8, $e9, $ea, $eb, $ec, $ed, $ee, $ef, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
    db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $f0, $f1, $f2, $f3, $f4, $f5, $f6, $f7
    db $f8, $f9, $fa, $fb, $fc, $fd, $fe, $ff, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
    db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $00, $01, $02, $03, $04, $05, $06, $07
    db $08, $09, $0a, $0b, $0c, $0d, $0e, $0f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
    db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $10, $11, $12, $13, $14, $15, $16, $17
    db $18, $19, $1a, $1b, $1c, $1d, $1e, $1f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
    db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $20, $21, $22, $23, $24, $25, $26, $27
    db $28, $29, $2a, $2b, $2c, $2d, $2e, $2f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
    db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $30, $31, $32, $33, $34, $35, $36, $37
    db $38, $39, $3a, $3b, $3c, $3d, $3e, $3f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
    db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $40, $41, $42, $43, $44, $45, $46, $47
    db $48, $49, $4a, $4b, $4c, $4d, $4e, $4f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
    db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $50, $51, $52, $53, $54, $55, $56, $57
    db $58, $59, $5a, $5b, $5c, $5d, $5e, $5f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
    db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $60, $61, $62, $63, $64, $65, $66, $67
    db $68, $69, $6a, $6b, $6c, $6d, $6e, $6f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
    db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $70, $71, $72, $73, $74, $75, $76, $77
    db $78, $79, $7a, $7b, $7c, $7d, $7e, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
    db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
    db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
    db $7f, $7f, $7f, $7f, $7f, $7f, $01, $03, $c1, $76, $fa, $03, $aa, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $0d, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0f, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $1d, $80, $80, $a0, $81, $81, $a0, $a0, $a0, $a0, $a0, $a0, $1f, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $1d, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $1f, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $1d, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $1f, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $b4
    db $1d, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $1f, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $1d, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $1f, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $1d, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $1f, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $1d, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $1f, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $2d, $2e, $2e, $2e, $2e, $2e, $2e, $2e, $2e, $2e, $2e, $2e, $2f, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $0d, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0f, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $1d, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $1f, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $1d, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $1f, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $1d, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $1f, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $b5
    db $1d, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $1f, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $1d, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $1f, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $1d, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $1f, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $1d, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $1f, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $2d, $2e, $2e, $2e, $2e, $2e, $2e, $2e, $2e, $2e, $2e, $2e, $2f, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $0d, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0f, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $1d, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $1f, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $1d, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $1f, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $1d, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $1f, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $b6
    db $1d, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $1f, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $1d, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $1f, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $1d, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $1f, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $1d, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $1f, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $2d, $2e, $2e, $2e, $2e, $2e, $2e, $2e, $2e, $2e, $2e, $2e, $2f, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    db $aa, $aa, $aa, $aa, $aa, $aa, $01, $03, $bb, $7a, $06, $00, $aa, $aa, $aa, $aa
    db $aa, $aa, $01, $03, $c1, $7a, $a0, $00, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
    db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
    db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $68
    db $69, $6a, $6b, $6c, $6d, $6e, $6f, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
    db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $78
    db $79, $7a, $7b, $7c, $7d, $7e, $7f, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
    db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $47, $48
    db $49, $4a, $4b, $4c, $4d, $4e, $4f, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
    db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $57, $58
    db $59, $5a, $5b, $5c, $5d, $5e, $5f, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
    db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $01, $03, $ff, $7f, $01, $00, $03, $01
    db $04, $00, $40, $01, $00, $04, $01, $04, $01, $40, $fa, $03

    ; padding
    ds $4e, $00

    db $05, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $51, $04, $d7, $28
    db $75, $ff, $00, $00, $00, $00, $00, $00, $40, $00, $e1, $00, $2d, $d0, $61, $be
    db $40, $ff, $03, $00, $00, $07, $03, $0f, $73, $1f, $cb, $3f, $97, $7f, $2f, $ff
    db $7f, $ff, $be, $ff, $54, $ff, $ea, $ff, $fd, $ff, $bf, $ff, $75, $ff, $bf, $ff
    db $7f, $ff, $ae, $f8, $76, $fd, $be, $ff, $5f, $ff, $ff, $ff, $d5, $ff, $bf, $ff
    db $55, $ff, $00, $00, $00, $00, $20, $80, $4c, $f0, $fc, $f8, $d5, $fe, $fe, $ff
    db $7f, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $80
    db $50, $e0

    ; padding
    ds $7a, $00

    db $01, $00, $00, $01, $03, $01, $0b, $07, $05, $1f, $0f, $3f, $17, $7f, $bf, $7f
    db $5f, $ff, $ff, $ff, $7f, $ff, $ef, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $f7, $ff, $fa, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7d, $ff, $fb, $ff, $57, $ff, $ff, $ff
    db $f7, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f5, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $df, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $5f, $ff, $ff, $ff, $f7, $ff, $ff, $ff
    db $dd, $ff, $ff, $ff, $fd, $ff, $f8, $e0, $d4, $f8, $fe, $f8, $f5, $fe, $ff, $fe
    db $fd, $ff, $ff, $ff, $fd, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $80, $00
    db $40, $80, $e0, $80

; I: leftover: an exact copy of 88 bytes of Unused_TCRF_FacePhoto9_HOI_L_Gfx (from 05:61DF, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_62AF_Unused_TCRF_FacePhoto9_HOI_L_Gfx_Part61DF::
    db $c0, $e0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00

; I: leftover: an exact copy of 468 bytes of Unused_TCRF_FacePhoto6_Rows2To13_Gfx (from 30:4227, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_6307_Unused_TCRF_FacePhoto6_Rows2To13_Gfx_Part4227::
    INCBIN "data/bank_23/Leftover_23_6307_Unused_TCRF_FacePhoto6_Rows2To13_Gfx_Part4227.bin" ; $6307, 468 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_64DB::
    db $01, $04, $fb, $43, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto6_Rows2To13_Gfx (from 30:43FB, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_64E1_Unused_TCRF_FacePhoto6_Rows2To13_Gfx_Part43FB::
    INCBIN "data/bank_23/Leftover_23_64E1_Unused_TCRF_FacePhoto6_Rows2To13_Gfx_Part43FB.bin" ; $64E1, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_68DB::
    db $01, $04, $f5, $47, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto6_Rows2To13_Gfx (from 30:47F5, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_68E1_Unused_TCRF_FacePhoto6_Rows2To13_Gfx_Part47F5::
    INCBIN "data/bank_23/Leftover_23_68E1_Unused_TCRF_FacePhoto6_Rows2To13_Gfx_Part47F5.bin" ; $68E1, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_6CDB::
    db $01, $04, $ef, $4b, $12, $02

; I: leftover: an exact copy of 530 bytes of Unused_TCRF_FacePhoto6_Rows2To13_Gfx (from 30:4BEF, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_6CE1_Unused_TCRF_FacePhoto6_Rows2To13_Gfx_Part4BEF::
    INCBIN "data/bank_23/Leftover_23_6CE1_Unused_TCRF_FacePhoto6_Rows2To13_Gfx_Part4BEF.bin" ; $6CE1, 530 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_6EF3::
    db $01, $04, $01, $4e, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto1_Gfx (from 30:4E01, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_6EF9_Unused_TCRF_FacePhoto1_Gfx_Part4E01::
    INCBIN "data/bank_23/Leftover_23_6EF9_Unused_TCRF_FacePhoto1_Gfx_Part4E01.bin" ; $6EF9, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_72F3::
    db $01, $04, $fb, $51, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto1_Gfx (from 30:51FB, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_72F9_Unused_TCRF_FacePhoto1_Gfx_Part51FB::
    INCBIN "data/bank_23/Leftover_23_72F9_Unused_TCRF_FacePhoto1_Gfx_Part51FB.bin" ; $72F9, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_76F3::
    db $01, $04, $f5, $55, $fa, $03

; I: leftover: an exact copy of 1018 bytes of Unused_TCRF_FacePhoto1_Gfx (from 30:55F5, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_76F9_Unused_TCRF_FacePhoto1_Gfx_Part55F5::
    INCBIN "data/bank_23/Leftover_23_76F9_Unused_TCRF_FacePhoto1_Gfx_Part55F5.bin" ; $76F9, 1018 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_7AF3::
    db $01, $04, $ef, $59, $12, $02

; I: leftover: an exact copy of 530 bytes of Unused_TCRF_FacePhoto1_Gfx (from 30:59EF, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_7AF9_Unused_TCRF_FacePhoto1_Gfx_Part59EF::
    INCBIN "data/bank_23/Leftover_23_7AF9_Unused_TCRF_FacePhoto1_Gfx_Part59EF.bin" ; $7AF9, 530 bytes
; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_23_7D0B::
    db $01, $04, $01, $5c, $fa, $03

; I: leftover: an exact copy of 750 bytes of Unused_TCRF_FacePhoto2_Gfx (from 30:5C01, a part of the block) that
; nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_23_7D11_Unused_TCRF_FacePhoto2_Gfx_Part5C01::
    INCBIN "data/bank_23/Leftover_23_7D11_Unused_TCRF_FacePhoto2_Gfx_Part5C01.bin" ; $7D11, 750 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_23_7FFF::
    db $23
