; Pocket Camera Hello Kitty (Japan), bank $31. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $031", ROMX[$4000], BANK[$31]

; C: read in the runs by Copy_Unrolled_B; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty*.npz); kind T_FRM from the evidence of tools/kitty_layout_kinds.py
Frame_31_4000_Mode02_TakePhotos_State01::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $07, $03, $07, $07, $04, $0c, $0c, $08, $08, $18, $10, $18, $18, $10
    db $00, $00, $80, $00, $c0, $e0, $39, $70, $3f, $1d, $07, $0f, $03, $06, $07, $04
    db $00, $00, $00, $00, $50, $20, $f8, $f8, $fc, $88, $f4, $0c, $ff, $07, $fe, $07
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $f9, $07
    db $00, $00, $00, $00, $01, $03, $0e, $07, $0e, $1c, $30, $18, $f0, $e0, $e0, $c0
    db $00, $00, $e0, $70, $98, $f8, $18, $0c, $0c, $0c, $04, $04, $04, $06, $02, $06
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $01, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00
    db $10, $38, $ff, $7f, $df, $e3, $fe, $81, $7d, $83, $fb, $07, $7f, $86, $bb, $c7
    db $3d, $3e, $67, $ff, $bf, $c3, $ff, $81, $ff, $81, $ff, $81, $bd, $c3, $ea, $f7
    db $7a, $86, $fb, $c6, $5f, $e2, $ff, $c2, $ff, $82, $7f, $82, $96, $ee, $f8, $7c
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $06, $02, $06, $02, $02, $06, $04, $06, $0e, $0c, $0e, $04, $06, $02, $02, $03
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $01, $00, $01, $01, $03, $01, $03, $01, $02, $03, $02, $03
    db $fc, $c3, $5f, $e0, $ef, $f0, $b7, $98, $0d, $9f, $0f, $07, $00, $00, $00, $00
    db $3e, $fc, $a8, $70, $c0, $60, $c0, $c0, $80, $80, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $01, $03, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $80, $80, $80, $80, $c0, $40, $c0, $c0, $40, $60, $40, $40, $60, $20, $60
    db $03, $02, $03, $02, $03, $02, $03, $02, $03, $02, $07, $03, $3f, $1f, $61, $73
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $f0, $50, $a0, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $60, $70, $e0, $70, $e0, $70, $e0, $60, $60
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $06, $07, $0f, $07, $07, $07, $07, $07, $05, $02
    db $00, $00, $05, $03, $0d, $06, $00, $00, $00, $00, $00, $00, $03, $03, $01, $00
    db $20, $60, $fc, $fe, $ec, $22, $60, $20, $20, $60, $40, $60, $e0, $e0, $fc, $78

    ; padding
    ds $1e, $00

    db $01, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $c0, $80

    ; padding
    ds $3e, $00

    db $78, $30

    ; padding
    ds $20, $00

    db $06, $07, $06, $0c, $0c, $0c, $08, $08, $08, $18, $10, $18, $18, $10, $18, $10
    db $60, $f0, $1c, $38, $1c, $0e, $03, $06, $03, $01, $01, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $e7, $f8, $c0, $00, $00, $00
    db $02, $01, $07, $07, $0c, $07, $08, $0f, $f8, $ff, $d8, $3f, $10, $1f, $30, $1f
    db $80, $01, $e7, $c3, $7f, $ee, $38, $fc, $10, $f8, $08, $f8, $0f, $ff, $f9, $ff
    db $f8, $f8, $08, $8c, $0c, $04, $04, $06, $02, $06, $06, $02, $02, $07, $bf, $ff
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $80

    ; padding
    ds $10, $00

    db $10, $18, $08, $18, $1c, $0c, $1c, $08, $18, $10, $10, $30, $20, $70, $60, $60

    ; padding
    ds $20, $00

    db $30, $1f, $30, $1f, $30, $1f, $30, $1f, $18, $1f, $07, $0f, $00, $00, $00, $00
    db $b0, $ff, $e0, $ff, $60, $ff, $20, $ff, $60, $ff, $d1, $bf, $1f, $0f, $05, $03
    db $70, $ff, $40, $ff, $60, $ff, $70, $ff, $58, $ff, $f0, $ff, $00, $ff, $00, $ff
    db $e0, $c0, $60, $e0, $20, $e0, $20, $e0, $20, $e0, $60, $c0, $c0, $c0, $80, $c0
    db $00, $00, $00, $00, $00, $00, $01, $00, $01, $01, $01, $01, $01, $01, $01, $01
    db $60, $c0, $80, $c0, $c0, $80, $80, $80, $00, $80, $00, $80, $80, $00, $80

    ; padding
    ds $32, $00

    db $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $81
    db $ff, $c3, $fe, $6c, $7e, $3c, $38, $00, $00, $00, $00, $00, $00, $02, $01, $e0
    db $c0, $60, $60, $30, $60, $30, $20, $20, $30, $10, $30, $10, $30, $fe, $ff, $01
    db $01, $01, $01, $01, $01, $03, $01, $1f, $0f, $30, $39, $40, $01, $00, $00, $80
    db $00, $80, $00, $80, $00, $e0, $f8, $a8, $d0, $80, $80, $c0, $80, $80, $c0, $00
    db $00, $00, $30, $38, $70, $38, $70, $38, $70, $30, $30

    ; padding
    ds $11, $00

    db $01, $01, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $10
    db $e0, $e0, $10, $00, $00, $01, $03, $07, $03, $07, $03, $03, $03, $02, $01, $00
    db $00, $00, $00, $06, $03, $00, $80, $80, $80, $80, $80, $81, $81, $80, $00, $00
    db $00, $00, $00, $f6, $11, $30, $10, $10, $30, $20, $30, $f0, $f0, $fe, $3c, $24
    db $63, $60, $60, $00, $00, $00, $00, $03, $01, $03, $02, $00, $00, $00, $00, $00
    db $00, $00, $00, $6c, $d0, $f0, $e0, $f0, $e0, $28, $30, $1b, $1e, $0c, $0e, $0f
    db $1f, $02, $31, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40
    db $80, $f3, $fc, $02, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $10, $e0, $e0

    ; padding
    ds $19, $00

    db $02, $01, $67, $1f, $03, $07, $00, $01, $01, $01, $07, $03, $1e, $0e, $7c, $38
    db $f0, $f0, $e0, $80, $e0, $c0, $f0, $e0, $bc, $98, $04, $0e, $01

    ; padding
    ds $17, $00

    db $60, $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $3f, $7f, $0b, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $80, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $01, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $fd, $fe, $e8, $f0

    ; padding
    ds $2c, $00

; C: read in the runs by Copy_Unrolled_B; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty*.npz); kind T_FRM from the evidence of tools/kitty_layout_kinds.py
Frame_31_4700_Mode02_TakePhotos_State01::
    db $81, $03, $01, $01, $00, $01, $01, $01, $07, $03, $06, $04, $00, $00, $00, $00
    db $80, $00, $00, $80, $d8, $a0, $e0, $c0, $e0, $c0, $50, $60, $36, $3c, $18, $1c
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $03, $03, $04, $04, $03, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $20, $c0, $c0, $20, $20, $c0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $07, $0f, $01, $03, $03, $03, $0e, $06, $3c, $1c, $f8, $70
    db $48, $c6, $c0, $c0, $c0, $80, $e0, $c0, $78, $30, $08, $1c, $02, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $1e, $3f, $05, $63, $c0, $40, $00, $00, $00, $00, $00, $00, $01, $00, $01, $01
    db $80, $00, $e6, $f8, $7f, $ff, $1f, $1f, $7e, $3f, $7c, $e7, $bc, $c7, $7d, $8f
    db $00, $00, $00, $00, $80, $ff, $ff, $ff, $7f, $e0, $6f, $f0, $3f, $ff, $cf, $ff
    db $00, $00, $00, $00, $03, $ff, $ff, $ff, $fc, $0f, $fc, $0f, $f8, $ff, $e3, $ff
    db $05, $03, $cf, $3f, $f0, $f8, $f8, $f8, $6e, $fc, $3f, $e6, $3f, $e3, $bf, $e1
    db $e0, $e0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $07, $03, $06, $0e, $0c, $18, $30, $10, $38, $10, $08, $18, $18, $08, $0c, $08
    db $bb, $ce, $4a, $fe, $7b, $3e, $11, $1f, $10, $1f, $30, $1f, $20, $3f, $60, $3f
    db $60, $3f, $23, $3f, $6c, $3f, $cf, $f8, $17, $f8, $1b, $f6, $7b, $f6, $f7, $98
    db $06, $fc, $84, $fc, $66, $fc, $b3, $7f, $d0, $3f, $d0, $3f, $d0, $3f, $f0, $3f
    db $ff, $73, $55, $7e, $d8, $7c, $90, $f8, $08, $f8, $08, $f8, $0c, $f8, $04, $fc
    db $80, $c0, $60, $70, $10, $38, $08, $18, $08, $18, $18, $10, $10, $10, $10, $10
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $08, $0c, $06, $07, $01, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $20, $7f, $e0, $7f, $c0, $ff, $40, $7f, $c0, $7f, $40, $ff, $40, $ff, $40, $ff
    db $6b, $dc, $3f, $ff, $04, $ff, $0b, $fd, $0f, $f9, $0b, $fd, $0d, $fe, $06, $ff
    db $63, $ff, $fc, $ff, $ff, $e0, $df, $30, $fa, $0d, $6b, $9d, $fe, $f3, $64, $9f
    db $84, $fc, $87, $ff, $83, $ff, $82, $fe, $82, $fe, $02, $fe, $02, $fe, $02, $fe
    db $10, $30, $60, $e0, $c0, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $40, $ff, $40, $ff, $e0, $7f, $f8, $7f, $4f, $7f, $67, $40, $40, $60, $40, $60
    db $03, $ff, $00, $ff, $01, $ff, $07, $ff, $ff, $ff, $f9, $01, $00, $01, $01, $01
    db $f8, $ff, $00, $ff, $00, $ff, $c0, $ff, $ff, $ff, $3f, $00, $00, $00, $00, $00
    db $02, $fe, $02, $fe, $04, $fe, $1e, $fc, $f4, $fc, $ec, $04, $0c, $04, $0c, $04
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $60, $60, $70, $20, $38, $30, $3c, $1f, $17, $0f, $00, $00, $00, $00, $00, $00
    db $03, $01, $01, $03, $03, $07, $0e, $fe, $f0, $fc, $00, $00, $00, $00, $00, $00
    db $80, $00, $00, $80, $a0, $c0, $f0, $ff, $5f, $3f, $00, $00, $00, $00, $00, $00
    db $08, $0c, $1c, $08, $18, $38, $f8, $f0, $90, $e0, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $1e, $00

    db $03, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $c0, $80

    ; padding
    ds $3e, $00

    db $70, $38

    ; padding
    ds $20, $00

    db $03, $03, $02, $06, $06, $04, $04, $0c, $08, $0c, $0c, $08, $08, $1c, $7f, $3f
    db $e0, $f0, $1c, $38, $1f, $0e, $03, $07, $01, $03, $03, $02, $1e, $1f, $b3, $ff
    db $28, $10, $fc, $7c, $fe, $c4, $fa, $86, $ff, $03, $ff, $03, $bd, $43, $fd, $e3
    db $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $7c, $83, $00, $00, $80, $00
    db $00, $01, $07, $03, $07, $0e, $18, $0c, $f8, $f0, $f0, $e0, $60, $00, $00, $00
    db $cc, $fc, $0c, $86, $06, $06, $02, $02, $02, $03, $01, $03, $03, $01, $03, $01

    ; padding
    ds $20, $00

    db $ef, $71, $ff, $c0, $be, $c1, $fd, $83, $bf, $c3, $dd, $63, $7e, $61, $2f, $70
    db $df, $e1, $7f, $c0, $ff, $c0, $ff, $c0, $de, $61, $f5, $fb, $1f, $fe, $d4, $38
    db $af, $f1, $ff, $e1, $ff, $c1, $bf, $c1, $cb, $f7, $7c, $be, $00, $00, $00, $00
    db $80, $00, $80, $00, $80, $00, $80

    ; padding
    ds $19, $00

    db $01, $03, $02, $03, $07, $06, $07, $02, $03, $01, $01, $01, $00, $01, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $c0, $c0, $c0
    db $00, $00, $00, $00, $01, $00, $01, $00, $01, $01, $01, $01, $01, $01, $01, $01
    db $f7, $78, $db, $cc, $86, $cf, $87, $83, $00, $80, $00, $80, $80, $00, $80, $00
    db $e0, $30, $e0, $60, $c0, $c0, $80, $80

    ; padding
    ds $46, $00

    db $02, $01, $c0, $60, $20, $60, $60, $20, $30, $20, $20, $30, $10, $30, $10, $30
    db $fe, $ff, $01, $01, $01, $01, $01, $01, $03, $01, $1f, $0f, $30, $39, $40, $01
    db $00, $00, $80, $00, $80, $00, $80, $00, $e0, $f8, $a8, $d0, $80, $80, $c0, $80
    db $80, $c0, $00, $00, $00, $30, $38, $70, $38, $70, $38, $70, $30, $30

    ; padding
    ds $11, $00

    db $01, $01, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $10
    db $e0, $e0, $10, $00, $00, $03, $03, $07, $03, $03, $03, $03, $03, $02, $01, $00
    db $00, $00, $00, $06, $03, $00, $80, $80, $80, $80, $80, $81, $81, $80, $00, $00
    db $00, $00, $00, $f6, $11, $30, $10, $10, $30, $20, $30, $f0, $f0, $fe, $3c, $24
    db $63, $60, $60, $00, $00, $00, $00, $03, $01, $03, $02, $00, $00, $00, $00, $00
    db $00, $00, $00, $6c, $d0, $f0, $e0, $f0, $e0, $28, $30, $1b, $1e, $0c, $0e, $0f
    db $1f, $02, $31, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40
    db $80, $f3, $fc, $02, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $10, $e0, $e0

    ; padding
    ds $19, $00

    db $02, $01, $67, $1f, $03, $07, $00, $01, $01, $01, $07, $03, $1e, $0e, $7c, $38
    db $f0, $f0, $e0, $80, $e0, $c0, $f0, $e0, $bc, $98, $04, $0e, $01

    ; padding
    ds $17, $00

    db $60, $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $3f, $7f, $0b, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $80, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $01, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $fd, $fe, $e8, $f0

    ; padding
    ds $2c, $00

; C: read in the runs by Copy_Unrolled_B, Vram_CopyHBlank; first read on the screen Mode02_TakePhotos_State08
; (trace/read_screens_kitty*.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_31_4E00_Mode02_TakePhotos_State08::
    INCBIN "data/bank_31/Gfx_31_4E00_Mode02_TakePhotos_State08.2bpp" ; $4E00, 5872 bytes
; C: the same 640 bytes as the Japanese Gfx_24_57E0_Unused_Link_LoadTiles (24:57E0); named by the code of
; Mode0D_State00, Mode0D_State03 (05:439C 05:44B6); read in the runs by Vram_CopyHBlank; first read on the screen
; Mode11_StrawberryChannel_State00 (trace/read_screens_kitty*.npz)
Gfx_31_64F0_Unused_Link_LoadTiles::
    INCBIN "data/bank_31/Gfx_31_64F0_Unused_Link_LoadTiles.2bpp" ; $64F0, 640 bytes
; C: named by the code of Mode00_State04 (05:4214); read in the runs by Copy_DEtoHL; first read on the screen
; Mode00_BootAndTitle_State00 (trace/read_screens_kitty*.npz); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_31_6770_Mode00_BootAndTitle_State04::
    INCBIN "data/bank_31/Gfx_31_6770_Mode00_BootAndTitle_State04.2bpp" ; $6770, 128 bytes
; C: read in the runs by Copy_DEtoHL, Print_StreamFromD3F4; first read on the screen Mode00_BootAndTitle_State00
; (trace/read_screens_kitty*.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py; the rest of Map_31_6770
; after a leftover stretch
Map_31_67F0_Mode00_BootAndTitle_State00::
    INCBIN "data/bank_31/Map_31_67F0_Mode00_BootAndTitle_State00.tilemap" ; $67F0, 512 bytes
; C: the same 576 bytes as the Japanese Map_25_5840_Cam_CalibSanityCheck (25:5840); named by the code of
; Mode0D_State00 (05:43A6); read in the runs by Copy_DEtoHL
Map_31_69F0_Cam_CalibSanityCheck::
    INCBIN "data/bank_31/Map_31_69F0_Cam_CalibSanityCheck.tilemap" ; $69F0, 576 bytes
; C: the same 32 bytes as the Japanese Map_25_5A80_Cam_CalibSanityCheck_OkRow (25:5A80)
Map_31_6C30_Cam_CalibSanityCheck_OkRow::
    INCBIN "data/bank_31/Map_31_6C30_Cam_CalibSanityCheck_OkRow.tilemap" ; $6C30, 32 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty*.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_31_6C50_Mode02_TakePhotos_State01::
    INCBIN "data/bank_31/Gfx_31_6C50_Mode02_TakePhotos_State01.bin" ; $6C50, 41 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty*.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py; the rest of
; Data_31_6C50 after a leftover stretch
Gfx_31_6C79_Mode02_TakePhotos_State01::
    INCBIN "data/bank_31/Gfx_31_6C79_Mode02_TakePhotos_State01.bin" ; $6C79, 615 bytes
; C: named by the code of Mode0C_State00 (06:5CFD); read in the runs by Vram_CopyHBlank; first read on the screen
; Mode02_TakePhotos_State01 (trace/read_screens_kitty*.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_31_6EE0_Mode0C_RecordBook_State00::
    INCBIN "data/bank_31/Map_31_6EE0_Mode0C_RecordBook_State00.tilemap" ; $6EE0, 32 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty*.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py; the rest of Map_31_6EE0
; after a leftover stretch
Gfx_31_6F00_Mode02_TakePhotos_State01::
    INCBIN "data/bank_31/Gfx_31_6F00_Mode02_TakePhotos_State01.bin" ; $6F00, 468 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty*.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py; the rest of Map_31_6EE0
; after a leftover stretch
Map_31_70D4_Mode02_TakePhotos_State01::
    INCBIN "data/bank_31/Map_31_70D4_Mode02_TakePhotos_State01.tilemap" ; $70D4, 108 bytes
; C: the same 576 bytes as the Japanese Map_25_5AC0_Cam_FactoryCalibration (25:5AC0); named by the code of
; Mode0D_State03 (05:44C0); read in the runs by Copy_DEtoHL, Vram_CopyHBlank; first read on the screen
; Mode02_TakePhotos_State01 (trace/read_screens_kitty*.npz)
Map_31_7140_Cam_FactoryCalibration::
    INCBIN "data/bank_31/Map_31_7140_Cam_FactoryCalibration.tilemap" ; $7140, 576 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode02_TakePhotos_State08
; (trace/read_screens_kitty*.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_31_7380_Mode02_TakePhotos_State08::
    INCBIN "data/bank_31/Map_31_7380_Mode02_TakePhotos_State08.tilemap" ; $7380, 64 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode02_TakePhotos_State08
; (trace/read_screens_kitty*.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py; the rest of Map_31_7380
; after a leftover stretch
Gfx_31_73C0_Mode02_TakePhotos_State08::
    INCBIN "data/bank_31/Gfx_31_73C0_Mode02_TakePhotos_State08.2bpp" ; $73C0, 560 bytes
; C: named by the code of Mode02_State00, Mode02_State04, Mode03_State04 (05:49BB 05:4B3C 05:733E); read in the runs
; by Copy_DEtoHL; first read on the screen Mode02_TakePhotos_State00 (trace/read_screens_kitty*.npz); kind T_UI from
; the evidence of tools/kitty_layout_kinds.py
Gfx_31_75F0_Mode02_TakePhotos_State00::
    INCBIN "data/bank_31/Gfx_31_75F0_Mode02_TakePhotos_State00.2bpp" ; $75F0, 576 bytes
; C: named by the code of Mode00_State01 (05:40E9); read in the runs by Copy_DEtoHL; first read on the screen
; Mode02_TakePhotos_State00 (trace/read_screens_kitty*.npz); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_31_7830_Mode00_BootAndTitle_State01::
    INCBIN "data/bank_31/Gfx_31_7830_Mode00_BootAndTitle_State01.2bpp" ; $7830, 336 bytes
; C: read in the runs by Copy_DEtoHL; first read on the screen Mode02_TakePhotos_State00
; (trace/read_screens_kitty*.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py; the rest of Map_31_7830
; after a leftover stretch
Map_31_7980_Mode02_TakePhotos_State00::
    INCBIN "data/bank_31/Map_31_7980_Mode02_TakePhotos_State00.tilemap" ; $7980, 240 bytes
; C: named by the code of Mode01_State00, Mode01_State03 (05:4558 05:46CF); read in the runs by Copy_DEtoHL; first
; read on the screen Mode01_MainMenu_State02 (trace/read_screens_kitty*.npz); kind MAP from the evidence of
; tools/kitty_layout_kinds.py
Map_31_7A70_Mode01_MainMenu_State00::
    INCBIN "data/bank_31/Map_31_7A70_Mode01_MainMenu_State00.tilemap" ; $7A70, 576 bytes
; I: leftover: 576 bytes (31:7CB0-7EEF) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_31_7CB0::
    INCBIN "data/bank_31/Leftover_31_7CB0.bin" ; $7CB0, 576 bytes
; C: read in the runs by MapRows_Copy13, Map_Write5PlusA0Safe, FrameRec_LoadMap; first read on the screen
; Mode02_TakePhotos_State01 (trace/read_screens_kitty*.npz)
Src_31_7EF0_Mode02_TakePhotos_State01::
    INCBIN "data/bank_31/Src_31_7EF0_Mode02_TakePhotos_State01.bin" ; $7EF0, 272 bytes
