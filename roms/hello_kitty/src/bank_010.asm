; Pocket Camera Hello Kitty (Japan), bank $10. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $010", ROMX[$4000], BANK[$10]

; C: named by the code of Mode0B_State04, Mode02_State01, Mode0F_State0C (05:4AC4 06:52FF 06:5342); read in the runs
; by Vram_CopyHBlank; first read on the screen Mode02_TakePhotos_State01 (trace/read_screens_kitty.npz); kind T_UI
; from the evidence of tools/kitty_layout_kinds.py
Gfx_10_4000_Mode0B_NameCardEdit_State04::
    db $3f, $00, $7f, $3f, $df, $60, $ff, $40, $ff, $40, $ff, $4e, $ff, $49, $ff, $4c
    db $ff, $48, $ff, $4a, $ff, $48, $ff, $47, $ff, $40, $ff, $40, $ff, $7f, $ff, $40
    db $ff, $40, $ff, $40, $ff, $4e, $ff, $49, $ff, $4c, $ff, $48, $ff, $4a, $ff, $48
    db $ff, $47, $ff, $40, $df, $60, $7f, $3f, $3f, $1f, $1f, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $ff, $01, $ff, $01, $ff, $01, $ff, $71, $ff, $d1, $ff, $71
    db $ff, $31, $ff, $51, $ff, $11, $ff, $e1, $ff, $01, $ff, $01, $ff, $ff, $ff, $01
    db $ff, $01, $ff, $01, $ff, $71, $ff, $d1, $ff, $71, $ff, $31, $ff, $51, $ff, $11
    db $ff, $e1, $ff, $01, $ff, $01, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $39, $ff, $27, $ff, $31
    db $ff, $20, $ff, $29, $ff, $20, $ff, $1f, $ff, $00, $ff, $00, $ff, $ff, $ff, $00
    db $ff, $00, $ff, $00, $ff, $39, $ff, $27, $ff, $31, $ff, $20, $ff, $29, $ff, $20
    db $ff, $1f, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $f8, $00, $fc, $f8, $f6, $0c, $ff, $06, $ff, $06, $ff, $c6, $ff, $46, $ff, $c6
    db $ff, $c6, $ff, $46, $ff, $46, $ff, $86, $ff, $06, $ff, $06, $ff, $fe, $ff, $06
    db $ff, $06, $ff, $06, $ff, $c6, $ff, $46, $ff, $c6, $ff, $c6, $ff, $46, $ff, $46
    db $ff, $86, $ff, $06, $f7, $0e, $ff, $fe, $fe, $fc, $fc, $00, $00, $00, $00, $00
    db $3f, $00, $7f, $3f, $df, $63, $ff, $43, $ff, $40, $ff, $40, $ff, $40, $ff, $40
    db $cf, $70, $cf, $70, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40
    db $ff, $40, $ff, $40, $ff, $43, $ff, $43, $ff, $43, $ff, $43, $ff, $40, $ff, $40
    db $cf, $70, $cf, $70, $dc, $7f, $7f, $3f, $3f, $1f, $1f, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $fc, $c3, $fc, $c3, $ff, $3f, $ff, $3f, $ff, $03, $ff, $03
    db $fc, $03, $fc, $03, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $03, $ff, $03
    db $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $ff, $fc, $ff, $fc, $03, $ff, $03, $ff, $0c, $ff, $0c, $ff
    db $fc, $ff, $fc, $ff, $f3, $0f, $f3, $0f, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $f0, $0f, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $f8, $00, $fc, $f8, $f6, $0c, $ff, $0e, $cf, $3e, $cf, $3e, $ff, $fe, $ff, $fe
    db $c7, $fe, $c7, $fe, $c7, $fe, $c7, $fe, $3f, $fe, $3f, $fe, $f7, $0e, $f7, $0e
    db $ff, $0e, $ff, $0e, $f7, $0e, $f7, $0e, $ff, $0e, $ff, $0e, $f7, $0e, $f7, $0e
    db $cf, $3e, $cf, $3e, $f7, $fe, $ff, $fe, $fe, $fc, $fc, $00, $00, $00, $00, $00
    db $3f, $00, $7f, $3f, $df, $60, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $7c
    db $ff, $43, $ff, $40, $ff, $40, $cf, $70, $ff, $40, $ff, $40, $ff, $40, $ff, $40
    db $ff, $43, $ff, $43, $ff, $40, $cf, $70, $fc, $7f, $ff, $43, $ff, $40, $ff, $40
    db $ff, $40, $ff, $40, $df, $60, $7f, $3f, $3f, $1f, $1f, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $fc, $c3, $ff, $3f, $ff, $03, $fc, $03, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $03, $ff, $00, $ff, $00, $ff, $ff, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $03
    db $ff, $fc, $03, $ff, $0c, $ff, $fc, $ff, $f3, $0f, $ff, $00, $ff, $00, $ff, $00
    db $ff, $03, $ff, $03, $ff, $00, $ff, $00, $f0, $0f, $ff, $ff, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $f8, $00, $fc, $f8, $f6, $0c, $ff, $06, $ff, $06, $ff, $06, $ff, $06, $ff, $f6
    db $ff, $0e, $cf, $3e, $ff, $fe, $c7, $fe, $c7, $fe, $3f, $fe, $f7, $0e, $ff, $0e
    db $f7, $0e, $ff, $0e, $f7, $0e, $cf, $3e, $ff, $f6, $ff, $06, $ff, $06, $ff, $06
    db $ff, $06, $ff, $06, $f7, $0e, $ff, $fe, $fe, $fc, $fc, $00, $00, $00, $00, $00
    db $3f, $00, $7f, $3f, $df, $60, $ff, $40, $ff, $40, $ff, $40, $ff, $41, $ff, $41
    db $ff, $41, $ff, $41, $ff, $40, $ff, $40, $ff, $41, $ff, $41, $ff, $41, $ff, $41
    db $ff, $41, $ff, $41, $ff, $47, $ff, $47, $ff, $41, $ff, $41, $ff, $43, $ff, $43
    db $ff, $40, $ff, $40, $df, $61, $7f, $3f, $3f, $1f, $1f, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $fe, $99, $fe, $99, $ff, $87, $ff, $87, $ff, $01, $ff, $01
    db $be, $41, $be, $41, $ff, $80, $ff, $80, $7f, $80, $7f, $80, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $90, $ff, $90, $ff, $10, $ff, $10, $ff, $81, $ff, $81
    db $bf, $c0, $bf, $c0, $ef, $70, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $ff, $e2, $ff, $e2, $1b, $f6, $1b, $f6, $2e, $ff, $2e, $ff
    db $e9, $ff, $e9, $ff, $d9, $3f, $d9, $3f, $f7, $0f, $f7, $0f, $fd, $03, $fd, $03
    db $ff, $03, $ff, $03, $fd, $13, $fd, $13, $ff, $13, $ff, $13, $fd, $03, $fd, $03
    db $fb, $06, $fb, $06, $cf, $3d, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $f8, $00, $fc, $f8, $f6, $0c, $ff, $06, $ff, $06, $ff, $06, $ff, $06, $ff, $06
    db $ff, $06, $ff, $06, $ff, $06, $ff, $06, $ff, $06, $ff, $06, $ff, $06, $ff, $06
    db $ff, $c6, $ff, $c6, $ff, $06, $ff, $06, $ff, $86, $ff, $86, $ff, $06, $ff, $06
    db $ff, $06, $ff, $06, $f7, $0e, $ff, $fe, $fe, $fc, $fc, $00, $00, $00, $00, $00
    db $3f, $00, $7f, $3f, $df, $60, $ff, $40, $ff, $4b, $fd, $46, $ff, $5c, $ff, $48
    db $df, $7c, $ff, $48, $ff, $48, $fb, $4c, $ff, $44, $fd, $4a, $ff, $7f, $fd, $4a
    db $ff, $44, $fb, $4c, $ff, $48, $ff, $48, $df, $7c, $ff, $48, $ff, $5c, $fd, $46
    db $ff, $4b, $ff, $40, $df, $60, $7f, $3f, $3f, $1f, $1f, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $ff, $00, $ff, $ff, $7e, $81, $ff, $00, $ff, $08, $ff, $80
    db $ff, $80, $ff, $00, $ff, $00, $ff, $00, $fe, $01, $f7, $0f, $ff, $ff, $f7, $0f
    db $fe, $01, $ff, $00, $ff, $00, $ff, $00, $ff, $80, $ff, $80, $ff, $08, $ff, $00
    db $7e, $81, $ff, $ff, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $ff, $00, $ff, $80, $7f, $e8, $df, $30, $ef, $18, $ff, $9d
    db $ef, $98, $ff, $1e, $ef, $18, $bf, $78, $cf, $f8, $4f, $f8, $ff, $ff, $4f, $f8
    db $cf, $f8, $bf, $78, $ef, $18, $ff, $1e, $ef, $98, $ff, $9c, $ef, $18, $df, $30
    db $7f, $e8, $ff, $80, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $f8, $00, $fc, $f8, $f6, $0c, $ff, $06, $ff, $06, $ff, $46, $ff, $c6, $ef, $f6
    db $ff, $d6, $ff, $56, $ff, $16, $ff, $16, $ff, $16, $ff, $16, $ff, $fe, $ff, $16
    db $ff, $16, $ff, $16, $ff, $16, $ff, $16, $ff, $16, $ff, $16, $ef, $76, $ff, $06
    db $ff, $06, $ff, $06, $f7, $0e, $ff, $fe, $fe, $fc, $fc, $00, $00, $00, $00, $00
    db $3f, $00, $7f, $3f, $df, $60, $ff, $41, $ff, $42, $ff, $42, $ff, $44, $fe, $45
    db $ff, $42, $fd, $46, $ff, $44, $ff, $44, $ff, $5e, $ff, $44, $ff, $7f, $ff, $44
    db $ff, $5e, $ff, $44, $ff, $44, $fd, $46, $ff, $42, $fe, $45, $ff, $44, $ff, $42
    db $ff, $42, $ff, $41, $df, $60, $7f, $3f, $3f, $1f, $1f, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $ff, $00, $ff, $80, $fb, $67, $fc, $1f, $fc, $07, $fb, $07
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $40, $ff, $40, $ff, $ff, $ff, $40
    db $ff, $40, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $fb, $07, $fc, $07, $fc, $1f
    db $fb, $67, $ff, $80, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $ff, $00, $ff, $70, $ff, $88, $6f, $d8, $bb, $fc, $a7, $fc
    db $67, $fc, $df, $3c, $f7, $0c, $ff, $0f, $f7, $4c, $ff, $4e, $ff, $ff, $ff, $4e
    db $f7, $4c, $ff, $0f, $f7, $0c, $df, $3c, $67, $fc, $a7, $fd, $bb, $fc, $6f, $d8
    db $ff, $88, $ff, $70, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $f8, $00, $fc, $f8, $f6, $0c, $ff, $06, $ff, $06, $ff, $06, $ef, $76, $ff, $16
    db $ff, $16, $ff, $16, $ff, $16, $ff, $16, $ff, $16, $ff, $16, $ff, $fe, $ff, $16
    db $ff, $16, $ff, $16, $ff, $16, $ff, $56, $ff, $d6, $ef, $f6, $ff, $c6, $ff, $46
    db $ff, $06, $ff, $06, $f7, $0e, $ff, $fe, $fe, $fc, $fc, $00, $00, $00, $00, $00
    db $3f, $00, $7f, $3f, $df, $60, $ff, $40, $ff, $40, $ff, $40, $ff, $43, $ff, $41
    db $ff, $40, $ff, $40, $ff, $41, $ff, $42, $fe, $43, $fb, $47, $fc, $47, $fc, $47
    db $ff, $47, $fd, $46, $ff, $5e, $fd, $46, $ff, $4e, $fd, $46, $fe, $43, $ff, $45
    db $ff, $40, $ff, $40, $df, $60, $7f, $3f, $3f, $1f, $1f, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $ff, $01, $ff, $01, $7f, $ff, $ff, $81, $ff, $e1, $ff, $c1
    db $ff, $81, $ff, $01, $ff, $c1, $fb, $3d, $c7, $7f, $a7, $fd, $bb, $fd, $df, $e1
    db $7f, $81, $ff, $01, $ff, $01, $ff, $41, $ff, $41, $ff, $05, $ff, $01, $9f, $e1
    db $ff, $7f, $ff, $01, $ff, $01, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $fd, $fe, $ff, $02, $ff, $02, $ff, $00
    db $ff, $00, $ff, $00, $ff, $07, $bf, $78, $c6, $fd, $cb, $7f, $ba, $7f, $f6, $0f
    db $fd, $03, $ff, $00, $ff, $00, $ff, $04, $ff, $04, $ff, $40, $fe, $01, $f3, $0f
    db $ff, $fc, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $f8, $00, $fc, $f8, $f6, $0c, $ff, $06, $ff, $06, $ff, $06, $ff, $06, $ff, $06
    db $ff, $06, $ff, $06, $ff, $06, $ff, $86, $ff, $86, $bf, $c6, $7f, $c6, $7f, $c6
    db $ff, $c6, $7f, $c6, $ff, $f6, $7f, $c6, $ff, $e6, $7f, $c6, $ff, $86, $ff, $46
    db $ff, $06, $ff, $06, $f7, $0e, $ff, $fe, $fe, $fc, $fc, $00, $00, $00, $00, $00
    db $3f, $00, $7f, $3f, $df, $60, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40
    db $ff, $40, $ff, $40, $ff, $41, $ff, $42, $ff, $42, $ff, $44, $fe, $45, $ff, $42
    db $fd, $46, $ff, $44, $ff, $44, $ff, $5e, $ff, $44, $ff, $4e, $fe, $43, $ff, $45
    db $ff, $40, $ff, $40, $df, $60, $7f, $3f, $3f, $1f, $1f, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $ff, $01, $ff, $01, $7f, $ff, $ff, $81, $ff, $81, $ff, $01
    db $ff, $01, $ff, $01, $ff, $81, $fb, $67, $fd, $1d, $fd, $07, $fb, $07, $ff, $01
    db $ff, $01, $ff, $01, $ff, $01, $ff, $41, $ff, $41, $ff, $05, $ff, $01, $bf, $c1
    db $ff, $7f, $ff, $01, $ff, $01, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $fd, $fe, $ff, $02, $ff, $0f, $ff, $07
    db $ff, $02, $ff, $00, $ff, $03, $bf, $cc, $7f, $70, $7f, $c0, $be, $c1, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $04, $ff, $04, $ff, $40, $fe, $01, $fb, $07
    db $ff, $fc, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $f8, $00, $fc, $f8, $f6, $0c, $ff, $06, $ff, $06, $ff, $06, $ff, $86, $ff, $06
    db $ff, $06, $ff, $06, $ff, $06, $ff, $86, $ff, $86, $ff, $46, $ff, $46, $ff, $86
    db $7f, $c6, $ff, $46, $ff, $46, $ff, $f6, $ff, $46, $ff, $e6, $ff, $86, $ff, $46
    db $ff, $06, $ff, $06, $f7, $0e, $ff, $fe, $fe, $fc, $fc, $00, $00, $00, $00, $00
    db $3f, $00, $7f, $3f, $df, $60, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40
    db $ff, $40, $ff, $40, $ff, $41, $ff, $41, $ff, $40, $ff, $41, $ff, $41, $ff, $41
    db $ff, $47, $ff, $41, $ff, $43, $ff, $40, $ff, $41, $ff, $40, $ff, $40, $ff, $40
    db $ff, $40, $ff, $40, $df, $60, $7f, $3f, $3f, $1f, $1f, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $60
    db $fe, $99, $ff, $87, $ff, $01, $be, $41, $ff, $80, $7f, $80, $ff, $00, $ff, $00
    db $ff, $90, $ff, $10, $ff, $81, $bf, $c0, $ef, $70, $ff, $1f, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $1c
    db $ff, $e2, $1b, $f6, $2e, $ff, $e9, $ff, $d9, $3f, $f7, $0f, $fd, $03, $ff, $03
    db $fd, $13, $ff, $13, $fd, $03, $fb, $06, $cf, $3d, $ff, $f0, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $f8, $00, $fc, $f8, $f6, $0c, $ff, $06, $ff, $06, $ff, $06, $ff, $06, $ff, $06
    db $ff, $06, $ff, $06, $ff, $06, $ff, $06, $ff, $06, $ff, $06, $ff, $06, $ff, $c6
    db $ff, $06, $ff, $86, $ff, $06, $ff, $06, $ff, $06, $ff, $06, $ff, $06, $ff, $06
    db $ff, $06, $ff, $06, $f7, $0e, $ff, $fe, $fe, $fc, $fc, $00, $00, $00, $00, $00
    db $3f, $00, $7f, $3f, $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f
    db $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f
    db $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f
    db $c0, $7f, $c0, $7f, $c0, $7f, $7f, $3f, $3f, $1f, $1f, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $00, $ff, $00, $ff, $07, $ff, $1f, $f8, $3f, $e0, $7f, $c7
    db $78, $cf, $78, $cf, $30, $ff, $00, $ff, $01, $ff, $03, $fe, $07, $fc, $07, $fc
    db $07, $fc, $07, $fc, $03, $ff, $00, $ff, $03, $ff, $07, $fc, $07, $fc, $03, $ff
    db $00, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $00, $ff, $00, $ff, $80, $ff, $e0, $7f, $f0, $1f, $f8, $8f
    db $78, $cf, $78, $cf, $78, $cf, $f8, $8f, $f0, $1f, $e0, $3f, $c0, $7f, $80, $ff
    db $80, $ff, $80, $ff, $00, $ff, $00, $ff, $00, $ff, $80, $ff, $80, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $f8, $00, $fc, $f8, $06, $fc, $07, $fe, $07, $fe, $07, $fe, $07, $fe, $07, $fe
    db $07, $fe, $07, $fe, $07, $fe, $07, $fe, $07, $fe, $07, $fe, $07, $fe, $07, $fe
    db $07, $fe, $07, $fe, $07, $fe, $07, $fe, $07, $fe, $07, $fe, $07, $fe, $07, $fe
    db $07, $fe, $07, $fe, $07, $fe, $ff, $fe, $fe, $fc, $fc, $00, $00, $00, $00, $00
    db $3f, $00, $7f, $3f, $df, $60, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40
    db $ff, $40, $df, $7c, $ff, $63, $f7, $68, $ff, $70, $ff, $60, $ff, $60, $ff, $74
    db $ef, $70, $f7, $58, $ff, $6f, $ff, $40, $ff, $40, $ff, $40, $ff, $41, $ff, $40
    db $ff, $40, $ff, $40, $df, $60, $7f, $3f, $3f, $1f, $1f, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $fe, $01, $fe, $01, $fe, $01, $fe, $01, $fe, $01, $fe, $01
    db $fe, $01, $fc, $1f, $fe, $f3, $f2, $7f, $fe, $1f, $fe, $0f, $fe, $03, $fe, $17
    db $7a, $87, $f6, $0d, $fe, $fb, $fe, $01, $fe, $01, $fe, $81, $fe, $81, $fe, $81
    db $fe, $81, $fe, $81, $fe, $01, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $70, $8f, $ff, $a0, $ff, $80, $ff, $c0, $7f, $80, $ff, $90, $ff, $87, $ff
    db $8d, $fa, $cf, $78, $ff, $3f, $ff, $00, $ff, $00, $ff, $07, $ff, $01, $ff, $07
    db $ff, $04, $ff, $07, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $f8, $00, $fc, $f8, $f6, $0c, $ff, $06, $ff, $06, $ff, $06, $ff, $06, $ff, $06
    db $ff, $76, $8f, $fe, $2f, $fe, $0f, $fe, $1f, $f6, $0f, $fe, $4f, $fe, $0f, $fe
    db $8f, $fe, $9f, $f6, $ff, $e6, $ff, $06, $ff, $06, $ff, $06, $ff, $06, $ff, $06
    db $ff, $06, $ff, $06, $f7, $0e, $ff, $fe, $fe, $fc, $fc, $00, $00, $00, $00, $00
    db $3f, $00, $7f, $3f, $df, $60, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40
    db $ff, $40, $df, $7c, $ff, $63, $f7, $68, $ff, $70, $ff, $60, $ff, $60, $ff, $74
    db $ef, $70, $f7, $58, $ff, $6f, $ff, $40, $ff, $40, $ff, $40, $ff, $41, $ff, $40
    db $ff, $40, $ff, $40, $df, $60, $7f, $3f, $3f, $1f, $1f, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $fe, $01, $fe, $01, $fe, $01, $fe, $01, $fe, $01, $fe, $01
    db $fe, $01, $fc, $1f, $fe, $f3, $f2, $7f, $fe, $1f, $fe, $0f, $fe, $03, $fe, $17
    db $7a, $87, $f6, $0d, $fe, $fb, $fe, $01, $fe, $01, $fe, $81, $fe, $81, $fe, $81
    db $fe, $81, $fe, $81, $fe, $01, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $1f, $ff, $3f, $e0
    db $7f, $cf, $79, $cf, $33, $fe, $07, $fc, $0f, $f9, $0f, $f9, $06, $ff, $00, $ff
    db $06, $ff, $0f, $f9, $06, $ff, $00, $ff, $00, $ff, $07, $ff, $01, $ff, $07, $ff
    db $04, $ff, $07, $ff, $00, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $f8, $00, $fc, $f8, $06, $fc, $07, $fe, $07, $fe, $07, $fe, $87, $fe, $c7, $7e
    db $e7, $3e, $e7, $3e, $c7, $7e, $87, $fe, $07, $fe, $07, $fe, $07, $fe, $07, $fe
    db $07, $fe, $07, $fe, $07, $fe, $07, $fe, $07, $fe, $07, $fe, $07, $fe, $07, $fe
    db $07, $fe, $07, $fe, $07, $fe, $ff, $fe, $fe, $fc, $fc, $00, $00, $00, $00, $00
    db $3f, $00, $7f, $3f, $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $c3, $7f, $c7, $7c
    db $cf, $79, $cf, $79, $c6, $7f, $c0, $7f, $c1, $7f, $c1, $7f, $c0, $7f, $c0, $7f
    db $c0, $7f, $c1, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $c1, $7f, $c0, $7f
    db $c0, $7f, $c0, $7f, $c0, $7f, $7f, $3f, $3f, $1f, $1f, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $f0, $ff, $f8, $0f
    db $fc, $e7, $3c, $e7, $78, $cf, $f0, $9f, $e0, $3f, $e0, $3f, $c0, $ff, $00, $ff
    db $c0, $ff, $e0, $3f, $c0, $ff, $00, $ff, $00, $ff, $80, $ff, $80, $ff, $80, $ff
    db $80, $ff, $80, $ff, $00, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $7f, $f0, $ff, $8f, $df, $a1, $ff, $c0, $ff, $80, $ff, $80, $ff, $d0
    db $bd, $c2, $df, $60, $ff, $bf, $ff, $00, $ff, $00, $ff, $07, $ff, $01, $ff, $07
    db $ff, $04, $ff, $07, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $f8, $00, $fc, $f8, $f6, $0c, $ff, $06, $ff, $06, $ff, $06, $ff, $06, $ff, $06
    db $ff, $06, $f7, $7e, $ff, $ce, $cf, $fe, $ff, $7e, $ff, $3e, $ff, $0e, $ff, $5e
    db $ef, $1e, $df, $36, $ff, $ee, $ff, $06, $ff, $06, $ff, $06, $ff, $06, $ff, $06
    db $ff, $06, $ff, $06, $f7, $0e, $ff, $fe, $fe, $fc, $fc, $00, $00, $00, $00, $00
    db $3f, $00, $7f, $3f, $df, $60, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40
    db $ff, $41, $ff, $40, $ff, $41, $ff, $40, $ff, $40, $ff, $40, $c0, $7f, $ff, $40
    db $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40
    db $ff, $40, $ff, $40, $df, $60, $7f, $3f, $3f, $1f, $1f, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $ff, $00, $7f, $f0, $ff, $8f, $df, $a1, $ff, $c0, $ff, $80
    db $ff, $80, $ff, $d0, $bd, $c2, $df, $60, $ff, $bf, $ff, $00, $00, $ff, $ff, $70
    db $8f, $ff, $a0, $ff, $80, $ff, $c0, $7f, $80, $ff, $90, $ff, $87, $ff, $8d, $fa
    db $cf, $78, $ff, $3f, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $ff, $00, $f7, $78, $ff, $c8, $cf, $f8, $ff, $78, $ff, $38
    db $ff, $0c, $ff, $58, $ef, $1c, $df, $30, $ff, $e8, $ff, $00, $00, $ff, $ff, $70
    db $8f, $f8, $2f, $f8, $0f, $f8, $1f, $f0, $0f, $f8, $4f, $f8, $0f, $f8, $8f, $f8
    db $9f, $f0, $ff, $e0, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $f8, $00, $fc, $f8, $f6, $0c, $ff, $06, $ff, $06, $ff, $06, $ff, $46, $ff, $c6
    db $ff, $46, $ff, $46, $ff, $46, $ff, $06, $ff, $06, $ff, $06, $07, $fe, $ff, $06
    db $ff, $06, $ff, $06, $ff, $06, $ff, $e6, $ff, $26, $ff, $e6, $ff, $86, $ff, $e6
    db $ff, $06, $ff, $06, $f7, $0e, $ff, $fe, $fe, $fc, $fc, $00, $00, $00, $00, $00
    db $3f, $00, $7f, $3f, $df, $60, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40
    db $ff, $41, $ff, $40, $ff, $41, $ff, $40, $ff, $40, $ff, $40, $c0, $7f, $c0, $7f
    db $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f
    db $c0, $7f, $c0, $7f, $c0, $7f, $7f, $3f, $3f, $1f, $1f, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $ff, $00, $7f, $f0, $ff, $8f, $df, $a1, $ff, $c0, $ff, $80
    db $ff, $80, $ff, $d0, $bd, $c2, $df, $60, $ff, $bf, $ff, $00, $00, $ff, $0f, $ff
    db $1f, $f0, $3f, $e7, $3c, $e7, $1b, $ff, $07, $fc, $07, $fc, $03, $ff, $03, $ff
    db $07, $fc, $03, $ff, $00, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $ff, $00, $f7, $78, $ff, $c8, $cf, $f8, $ff, $78, $ff, $38
    db $ff, $0c, $ff, $58, $ef, $1c, $df, $30, $ff, $e8, $ff, $00, $00, $ff, $c0, $ff
    db $e0, $3f, $f0, $9f, $f0, $9f, $e0, $3f, $c0, $ff, $80, $ff, $00, $ff, $00, $ff
    db $80, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $f8, $00, $fc, $f8, $f6, $0c, $ff, $06, $ff, $06, $ff, $06, $ff, $46, $ff, $c6
    db $ff, $46, $ff, $46, $ff, $46, $ff, $06, $ff, $06, $ff, $06, $07, $fe, $07, $fe
    db $07, $fe, $07, $fe, $07, $fe, $e7, $fe, $27, $fe, $e7, $fe, $87, $fe, $e7, $fe
    db $07, $fe, $07, $fe, $07, $fe, $ff, $fe, $fe, $fc, $fc, $00, $00, $00, $00, $00
    db $3f, $00, $7f, $3f, $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f
    db $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $ff, $40
    db $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $41, $ff, $40, $ff, $41
    db $ff, $40, $ff, $40, $df, $60, $7f, $3f, $3f, $1f, $1f, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $00, $ff, $0f, $ff, $1f, $f0, $3f, $e7, $3c, $e7, $1b, $ff
    db $07, $fc, $07, $fc, $03, $ff, $03, $ff, $07, $fc, $03, $ff, $00, $ff, $ff, $00
    db $7f, $f0, $ff, $8f, $df, $a1, $ff, $c0, $ff, $80, $ff, $80, $ff, $d0, $bd, $c2
    db $df, $60, $ff, $bf, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $00, $ff, $c0, $ff, $e0, $3f, $f0, $9f, $f0, $9f, $e0, $3f
    db $c0, $ff, $80, $ff, $00, $ff, $00, $ff, $80, $ff, $00, $ff, $00, $ff, $ff, $00
    db $f7, $78, $ff, $c8, $cf, $f8, $ff, $78, $ff, $38, $ff, $0c, $ff, $58, $ef, $1c
    db $df, $30, $ff, $e8, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $f8, $00, $fc, $f8, $06, $fc, $07, $fe, $07, $fe, $07, $fe, $47, $fe, $c7, $fe
    db $47, $fe, $47, $fe, $47, $fe, $07, $fe, $07, $fe, $07, $fe, $07, $fe, $ff, $06
    db $ff, $06, $ff, $06, $ff, $06, $ff, $e6, $ff, $26, $ff, $e6, $ff, $86, $ff, $e6
    db $ff, $06, $ff, $06, $f7, $0e, $ff, $fe, $fe, $fc, $fc, $00, $00, $00, $00, $00
    db $3f, $00, $7f, $3f, $df, $60, $ff, $48, $ff, $58, $ff, $48, $ff, $4b, $ff, $4a
    db $ff, $43, $ff, $42, $ff, $42, $ff, $42, $ff, $41, $ff, $40, $c0, $7f, $ff, $40
    db $ff, $41, $fe, $43, $fe, $43, $ff, $41, $ff, $41, $ff, $5c, $ff, $44, $ff, $5c
    db $ff, $44, $ff, $5c, $df, $60, $7f, $3f, $3f, $1f, $1f, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $fe, $01, $fe, $01, $fe, $01, $fe, $01, $fe, $9d, $fe, $75
    db $fe, $1d, $fe, $0d, $fe, $95, $fe, $05, $fe, $f9, $fe, $01, $00, $ff, $fe, $d9
    db $26, $fd, $da, $27, $8a, $77, $06, $fd, $56, $fd, $8e, $f9, $fe, $71, $fe, $21
    db $fe, $01, $fe, $01, $fe, $01, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $e7, $bd, $ff
    db $c3, $ff, $81, $ff, $a5, $ff, $99, $e7, $ff, $7e, $ff, $00, $00, $ff, $ff, $14
    db $ff, $2a, $ff, $2a, $ff, $2e, $df, $67, $fd, $43, $ff, $55, $ff, $41, $ff, $3e
    db $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $f8, $00, $fc, $f8, $f6, $0c, $ff, $76, $ff, $16, $ff, $76, $ff, $46, $ff, $76
    db $ff, $06, $ff, $06, $ff, $06, $ff, $06, $ff, $06, $ff, $06, $07, $fe, $ff, $06
    db $ff, $06, $ff, $06, $ff, $06, $ff, $06, $ff, $06, $ff, $56, $ff, $56, $ff, $76
    db $ff, $16, $ff, $16, $f7, $0e, $ff, $fe, $fe, $fc, $fc, $00, $00, $00, $00, $00
    db $3f, $00, $7f, $3f, $df, $60, $ff, $48, $ff, $58, $ff, $48, $ff, $4b, $ff, $4a
    db $ff, $43, $ff, $42, $ff, $42, $ff, $42, $ff, $41, $ff, $40, $c0, $7f, $c0, $7f
    db $c0, $7f, $c0, $7f, $c1, $7f, $c1, $7f, $c0, $7f, $dc, $7f, $c4, $7f, $dc, $7f
    db $c4, $7f, $dc, $7f, $c0, $7f, $7f, $3f, $3f, $1f, $1f, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $9c, $ff, $74
    db $ff, $1c, $ff, $0c, $ff, $94, $ff, $04, $ff, $f8, $ff, $00, $00, $ff, $00, $ff
    db $70, $ff, $f8, $8f, $fc, $77, $dc, $77, $b8, $ef, $70, $df, $70, $df, $20, $ff
    db $70, $df, $20, $ff, $00, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $00, $ff, $1c, $ff, $3e, $e3, $7f, $dd, $77, $dd, $2e, $fb
    db $1c, $f7, $1c, $f7, $08, $ff, $1c, $f7, $08, $ff, $00, $ff, $ff, $00, $ff, $00
    db $ff, $00, $ff, $e7, $bd, $ff, $c3, $ff, $81, $ff, $a5, $ff, $99, $e7, $ff, $7e
    db $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $f8, $00, $fc, $f8, $06, $fc, $77, $fe, $17, $fe, $77, $fe, $47, $fe, $77, $fe
    db $07, $fe, $07, $fe, $07, $fe, $07, $fe, $07, $fe, $07, $fe, $ff, $06, $ff, $06
    db $ff, $06, $ff, $06, $ff, $06, $ff, $06, $ff, $06, $ff, $56, $ff, $56, $ff, $76
    db $ff, $16, $ff, $16, $f7, $0e, $ff, $fe, $fe, $fc, $fc, $00, $00, $00, $00, $00
    db $3f, $00, $7f, $3f, $c0, $7f, $c8, $7f, $d8, $7f, $c9, $7f, $c9, $7f, $c8, $7f
    db $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $ff, $40, $ff, $40
    db $ff, $40, $ff, $41, $ff, $41, $ff, $41, $ff, $41, $ff, $5d, $ff, $45, $ff, $5c
    db $ff, $44, $ff, $5c, $df, $60, $7f, $3f, $3f, $1f, $1f, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $01, $fe, $71, $fe, $f9, $8e, $fd, $76, $dd, $76, $b9, $ee
    db $71, $de, $71, $de, $21, $fe, $71, $de, $21, $fe, $01, $fe, $fe, $01, $fe, $01
    db $fe, $01, $fe, $cf, $7a, $ff, $86, $ff, $02, $ff, $4a, $ff, $32, $cf, $fe, $fd
    db $fe, $01, $fe, $01, $fe, $01, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $e7, $ff, $9d
    db $ff, $c7, $ff, $83, $ff, $a5, $ff, $81, $ff, $7e, $ff, $00, $00, $ff, $00, $ff
    db $1c, $ff, $3e, $e3, $7f, $dd, $77, $dd, $2e, $fb, $1c, $f7, $1c, $f7, $08, $ff
    db $1c, $f7, $08, $ff, $00, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $f8, $00, $fc, $f8, $f6, $0c, $ff, $76, $ff, $16, $ff, $76, $ff, $46, $ff, $76
    db $ff, $06, $ff, $06, $ff, $06, $ff, $06, $ff, $06, $ff, $06, $07, $fe, $07, $fe
    db $07, $fe, $07, $fe, $07, $fe, $07, $fe, $07, $fe, $57, $fe, $57, $fe, $77, $fe
    db $17, $fe, $17, $fe, $07, $fe, $ff, $fe, $fe, $fc, $fc, $00, $00, $00, $00, $00
    db $3f, $00, $7f, $3f, $c0, $7f, $c8, $7f, $d8, $7f, $c9, $7f, $c9, $7f, $c8, $7f
    db $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $ff, $40, $c0, $7f
    db $c0, $7f, $c0, $7f, $c1, $7f, $c1, $7f, $c0, $7f, $dc, $7f, $c4, $7f, $dc, $7f
    db $c4, $7f, $dc, $7f, $c0, $7f, $7f, $3f, $3f, $1f, $1f, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $01, $fe, $71, $fe, $f9, $8e, $fd, $76, $dd, $76, $b9, $ee
    db $71, $de, $71, $de, $21, $fe, $71, $de, $21, $fe, $01, $fe, $ff, $00, $01, $fe
    db $71, $fe, $f9, $8e, $fd, $76, $dd, $76, $b9, $ee, $71, $de, $71, $de, $21, $fe
    db $71, $de, $21, $fe, $01, $fe, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $ff, $00, $ff, $1c, $ff, $3e, $e3, $7f, $dd, $77, $dd, $2e, $fb
    db $1c, $f7, $1c, $f7, $08, $ff, $1c, $f7, $08, $ff, $00, $ff, $ff, $00, $00, $ff
    db $1c, $ff, $3e, $e3, $7f, $dd, $77, $dd, $2e, $fb, $1c, $f7, $1c, $f7, $08, $ff
    db $1c, $f7, $08, $ff, $00, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $f8, $00, $fc, $f8, $06, $fc, $77, $fe, $17, $fe, $77, $fe, $47, $fe, $77, $fe
    db $07, $fe, $07, $fe, $07, $fe, $07, $fe, $07, $fe, $07, $fe, $ff, $06, $07, $fe
    db $07, $fe, $07, $fe, $07, $fe, $07, $fe, $07, $fe, $57, $fe, $57, $fe, $77, $fe
    db $17, $fe, $17, $fe, $07, $fe, $ff, $fe, $fe, $fc, $fc, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $07, $00, $0b, $07, $17, $0e, $1f, $0c, $2f, $19, $3f, $19
    db $3f, $18, $2f, $19, $1f, $09, $17, $0f, $0d, $03, $03, $00, $00, $00, $00, $00
    db $00, $00, $07, $00, $e7, $03, $d7, $e2, $ef, $72, $ff, $32, $f7, $9a, $ff, $9a
    db $ff, $1a, $f7, $9a, $ff, $92, $ef, $f2, $b7, $c3, $c7, $01, $03, $00, $00, $00
    db $00, $00, $df, $00, $ff, $8f, $ff, $fb, $ff, $c0, $ff, $fb, $ff, $8a, $ff, $8a
    db $ff, $fb, $df, $e1, $ff, $d8, $f6, $5b, $db, $67, $ff, $fc, $fe, $00, $00, $00
    db $00, $00, $be, $00, $be, $1c, $ff, $94, $ff, $94, $ff, $94, $ff, $14, $ff, $14
    db $ff, $14, $ff, $94, $ff, $d6, $ff, $52, $ff, $da, $ff, $0e, $1f, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $f0, $00, $f8, $e0, $f8, $b0, $f8, $90, $f8, $d0
    db $f8, $50, $f8, $50, $f8, $70, $f8, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $60, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode02_TakePhotos_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_10_5500_Mode02_TakePhotos_State06::
    db $00, $00, $00, $00, $1f, $00, $3e, $1f, $7f, $20, $bf, $66, $ff, $66, $ff, $60
    db $ff, $66, $bf, $66, $7f, $20, $5f, $3f, $36, $0f, $0f, $00, $00, $00, $00, $00
    db $00, $00, $0f, $00, $3f, $07, $ff, $1d, $bf, $d0, $ff, $5d, $df, $65, $ff, $e5
    db $ff, $65, $df, $65, $ff, $45, $af, $c5, $cf, $05, $0f, $07, $0f, $00, $00, $00
    db $00, $00, $ef, $00, $ff, $e7, $ff, $75, $ff, $1d, $df, $6c, $de, $69, $df, $ea
    db $df, $ea, $ee, $9b, $ff, $fb, $fb, $0d, $9d, $0e, $9f, $07, $8f, $00, $00, $00
    db $00, $00, $ff, $00, $ff, $3b, $ff, $2a, $ff, $eb, $f7, $0f, $cb, $f6, $f7, $db
    db $7f, $db, $de, $3b, $77, $ba, $ba, $77, $7f, $e7, $ff, $fd, $ff, $00, $00, $00
    db $00, $00, $fe, $00, $fe, $fc, $fe, $04, $de, $ec, $be, $dc, $f7, $0e, $eb, $f6
    db $f7, $fa, $d7, $3a, $f7, $da, $eb, $56, $77, $8e, $fe, $fc, $fe, $00, $00, $00

    ; padding
    ds $60, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode03_ViewAlbum_State11
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_10_5600_Mode03_ViewAlbum_State11::
    db $00, $00, $00, $00, $1f, $00, $3e, $1f, $7f, $20, $bf, $66, $ff, $66, $ff, $60
    db $ff, $66, $bf, $66, $7f, $20, $5f, $3f, $36, $0f, $0f, $00, $00, $00, $00, $00
    db $00, $00, $1f, $00, $1f, $0e, $df, $0a, $bf, $ca, $ff, $4a, $df, $6a, $ff, $ea
    db $ff, $6a, $df, $6a, $ff, $4b, $bf, $c9, $df, $0d, $1f, $07, $0f, $00, $00, $00
    db $00, $00, $1f, $00, $1f, $0e, $ff, $0a, $ff, $7a, $ff, $5a, $ff, $4a, $ff, $6a
    db $ff, $2a, $ff, $2a, $ff, $3b, $ff, $09, $9f, $0d, $9f, $07, $8f, $00, $00, $00
    db $07, $00, $07, $03, $07, $02, $ff, $03, $ff, $77, $ff, $5c, $ff, $4f, $ff, $68
    db $ff, $28, $ff, $29, $fe, $3f, $ff, $04, $8f, $04, $8f, $07, $8f, $00, $00, $00
    db $f0, $00, $d8, $e0, $fc, $38, $be, $c8, $fe, $fc, $fe, $04, $fe, $cc, $fe, $58
    db $ec, $98, $5c, $a8, $ff, $68, $ff, $6e, $ef, $b2, $ff, $1e, $9f, $00, $00, $00

    ; padding
    ds $60, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode02_TakePhotos_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_10_5700_Mode02_TakePhotos_State06::
    db $00, $00, $00, $00, $1f, $00, $2f, $1f, $5f, $39, $7f, $30, $bf, $66, $ff, $66
    db $ff, $60, $bf, $66, $7f, $26, $5f, $3f, $36, $0f, $0f, $00, $00, $00, $00, $00
    db $00, $00, $03, $00, $9f, $01, $5f, $8e, $bf, $c8, $ff, $c7, $df, $6f, $ff, $68
    db $ff, $6f, $df, $67, $fd, $4b, $bd, $cb, $db, $0c, $1f, $07, $0f, $00, $00, $00
    db $00, $00, $ef, $00, $ff, $c7, $7f, $fc, $ff, $0f, $bf, $73, $bf, $72, $ff, $0b
    db $7f, $b8, $78, $a0, $f3, $c0, $f7, $e3, $f7, $22, $f7, $e3, $f7, $00, $00, $00
    db $00, $00, $fc, $00, $fc, $f8, $fc, $08, $bf, $d8, $7f, $bb, $ee, $1f, $d7, $ee
    db $ee, $37, $6f, $37, $ef, $34, $d7, $ec, $ee, $1c, $fe, $f8, $fc, $00, $00, $00
    db $00, $00, $7e, $00, $7e, $3c, $be, $64, $56, $ec, $fc, $88, $dc, $30, $f8, $60
    db $f8, $20, $7c, $90, $be, $c8, $d6, $6c, $fe, $24, $7e, $3c, $7e, $00, $00, $00

    ; padding
    ds $60, $00

; C: read in the runs by Copy_DEtoHL
Src_10_5800_Copy_DEtoHL::
    db $00, $00, $00, $00, $1f, $00, $2f, $1f, $5f, $39, $7f, $30, $bf, $66, $ff, $66
    db $ff, $60, $bf, $66, $7f, $26, $5f, $3f, $36, $0f, $0f, $00, $00, $00, $00, $00
    db $07, $00, $1f, $03, $9f, $0e, $5f, $88, $bf, $ce, $ff, $c6, $df, $6c, $fd, $6a
    db $ff, $6a, $df, $6a, $ff, $4a, $bd, $ca, $df, $0d, $1f, $07, $0f, $00, $00, $00
    db $c0, $00, $ff, $80, $ff, $ff, $ff, $0d, $ef, $dd, $df, $bd, $ef, $1d, $d7, $ad
    db $ef, $b5, $ef, $b5, $6f, $b5, $ef, $74, $ff, $4e, $ff, $f3, $ff, $00, $00, $00
    db $7f, $00, $ff, $3f, $ff, $2a, $ff, $ea, $ff, $07, $ff, $ef, $ff, $2a, $ff, $2b
    db $ff, $2b, $fe, $2b, $ff, $ea, $fe, $cb, $ff, $db, $ff, $f1, $fb, $00, $00, $00
    db $e0, $00, $ff, $80, $ff, $fe, $ff, $82, $ef, $f6, $df, $ec, $f7, $0e, $eb, $f6
    db $f7, $fa, $d7, $3a, $f7, $da, $eb, $56, $77, $8e, $ff, $fc, $fe, $00, $00, $00

    ; padding
    ds $60, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode0A_NameCard_State02
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_10_5900_Mode0A_NameCard_State02::
    INCBIN "data/bank_10/Gfx_10_5900_Mode0A_NameCard_State02.bin" ; $5900, 259 bytes
; I: leftover: 253 bytes (10:5A03-5AFF) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_10_5A03::
    db $00

    db $1f, $00, $2f, $1f, $5f, $39, $7f, $30, $bf, $66, $ff, $66, $ff, $60, $bf, $66
    db $7f, $26, $5f, $3f, $36, $0f, $0f, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $8f, $00, $4f, $87, $af, $c5, $fa, $cd, $df, $6a, $ff, $6a, $ff, $6a, $db, $77
    db $ff, $57, $bf, $dd, $df, $01, $03, $00, $03, $00, $00, $00, $00, $00, $1f, $00
    db $9f, $0e, $9f, $0a, $ff, $1a, $f7, $9e, $ff, $b4, $eb, $f6, $7f, $eb, $df, $6b
    db $ff, $5b, $fd, $5b, $ff, $dc, $ff, $77, $ff, $00, $00, $00, $00, $00, $7f, $00
    db $7f, $3e, $7f, $23, $7b, $3d, $7f, $0b, $1f, $0f, $ff, $01, $ff, $f8, $ff, $68
    db $ef, $5b, $fd, $5e, $ff, $e1, $ff, $bf, $ff, $00, $00, $00, $00, $00, $fe, $00
    db $fe, $fc, $fe, $84, $ff, $fc, $ff, $86, $b7, $7a, $ff, $ca, $ff, $0a, $ff, $0a
    db $f7, $9a, $ee, $f4, $fc, $c8, $f8, $70, $f0

    ; padding
    ds $63, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode03_ViewAlbum_State09
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_10_5B00_Mode03_ViewAlbum_State09::
    db $00, $00, $00, $00, $1f, $00, $2f, $1f, $5f, $39, $7f, $30, $bf, $66, $ff, $66
    db $ff, $60, $bf, $66, $7f, $26, $5f, $3f, $36, $0f, $0f, $00, $00, $00, $00, $00
    db $00, $00, $7f, $00, $ff, $3f, $7f, $a0, $bf, $fe, $ff, $c2, $df, $62, $ff, $62
    db $ff, $62, $df, $62, $ff, $42, $bf, $fe, $ff, $20, $7f, $3f, $7f, $00, $00, $00
    db $07, $00, $c7, $03, $c7, $82, $cf, $82, $ff, $86, $fd, $f6, $ee, $dd, $fb, $e5
    db $f7, $bb, $fd, $93, $ee, $b5, $df, $ee, $ff, $db, $ff, $f0, $f8, $00, $00, $00
    db $c1, $00, $cf, $80, $cf, $87, $ff, $85, $ff, $f5, $ff, $cd, $df, $ed, $ff, $35
    db $ff, $05, $ff, $85, $fb, $8d, $f5, $fb, $fb, $c7, $ff, $7e, $ff, $00, $00, $00
    db $f0, $00, $f0, $e0, $f0, $a0, $f0, $a0, $f0, $a0, $fc, $a0, $df, $b8, $f7, $8e
    db $ff, $b2, $ff, $ae, $ff, $a0, $f0, $a0, $f0, $a0, $f0, $e0, $f0, $00, $00, $00

    ; padding
    ds $60, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode06_Printing_State0A
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_10_5C00_Mode06_Printing_State0A::
    db $00, $00, $00, $00, $0f, $00, $37, $0f, $5f, $3f, $7f, $38, $bf, $73, $ff, $71
    db $ff, $78, $bf, $7c, $7f, $31, $5f, $3f, $37, $0f, $0f, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $86, $ff, $cc, $ff, $cc
    db $ff, $cc, $ff, $cc, $ff, $cc, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $63, $ff, $a5, $ff, $a5
    db $ff, $23, $ff, $a5, $ff, $a5, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $f0, $00, $ec, $f0, $fa, $fc, $fe, $0c, $fd, $9e, $ff, $9e
    db $ff, $9e, $fd, $9e, $ff, $9c, $fb, $fc, $ed, $f0, $f0, $00, $00, $00, $00, $00
    db $00, $00, $7e, $00, $7e, $3c, $7e, $24, $db, $66, $ef, $5a, $ff, $5a, $ff, $db
    db $dd, $bb, $dd, $bb, $fb, $bd, $ff, $e5, $ff, $05, $0f, $07, $0f, $00, $00, $00
    db $00, $00, $3e, $00, $3e, $1c, $7e, $14, $ee, $34, $de, $6c, $be, $c8, $d7, $ac
    db $7f, $b7, $ff, $36, $bf, $76, $fb, $76, $ff, $79, $ff, $ef, $ff, $00, $00, $00
    db $00, $00, $ff, $00, $ff, $7e, $ff, $43, $fb, $7d, $ff, $0b, $1f, $0f, $ff, $01
    db $ff, $f8, $ff, $c8, $cf, $bb, $fd, $be, $ff, $c1, $ff, $7f, $ff, $00, $00, $00
    db $00, $00, $ff, $00, $ff, $fe, $ff, $82, $ff, $fe, $ff, $83, $bb, $7d, $ff, $c5
    db $ff, $05, $ff, $05, $fb, $8d, $f7, $fa, $fe, $c4, $fd, $78, $f9, $00, $00, $00
    db $00, $00, $00, $00, $0f, $00, $37, $0f, $5f, $3f, $7f, $38, $bf, $73, $ff, $71
    db $ff, $78, $bf, $7c, $7f, $31, $5f, $3f, $37, $0f, $0f, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $86, $ff, $cc, $ff, $cc
    db $ff, $cc, $ff, $cc, $ff, $cc, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $63, $ff, $a5, $ff, $a5
    db $ff, $23, $ff, $a5, $ff, $a5, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
    db $00, $00, $03, $00, $f3, $01, $ef, $f1, $fb, $fd, $ff, $0c, $fd, $9e, $ff, $9e
    db $ff, $9e, $fd, $9e, $ff, $9c, $fa, $fc, $ec, $f0, $f0, $00, $00, $00, $00, $00
    db $1f, $00, $fe, $0f, $f5, $fb, $ff, $15, $f5, $fb, $ff, $0f, $1f, $0b, $1f, $0b
    db $3f, $0b, $77, $1a, $eb, $36, $d7, $6c, $ef, $58, $fd, $70, $f9, $00, $00, $00
    db $80, $00, $fe, $00, $fe, $dc, $ff, $54, $ff, $57, $ff, $56, $fe, $77, $ff, $35
    db $ff, $b4, $ff, $f4, $ef, $34, $d7, $ed, $ef, $9d, $ff, $f9, $ff, $00, $00, $00
    db $00, $00, $1f, $00, $1f, $0f, $df, $0b, $ff, $8b, $ff, $4b, $bf, $6b, $7f, $ab
    db $ff, $cb, $ff, $0b, $f7, $1b, $ef, $f3, $ff, $07, $ff, $fd, $ff, $00, $00, $00
    db $00, $00, $e0, $00, $e1, $c0, $e1, $40, $e3, $40, $fb, $41, $ff, $71, $df, $3d
    db $f7, $4d, $ff, $7d, $ff, $40, $e3, $40, $e7, $41, $e7, $c3, $e7, $00, $00, $00
    db $3f, $00, $ff, $1f, $ff, $60, $ff, $80, $ff, $80, $eb, $36, $ff, $00, $f7, $3d
    db $ff, $00, $ff, $3a, $ff, $80, $ff, $80, $ff, $30, $ff, $cf, $ff, $00, $00, $00
    db $e0, $00, $f8, $c0, $fc, $30, $fc, $08, $fe, $08, $fe, $a4, $fe, $04, $fe, $a4
    db $fe, $04, $be, $c4, $fe, $08, $fc, $08, $fc, $30, $f8, $c0, $e0, $00, $00, $00

    ; padding
    ds $a0, $00

; C: read in the runs by Copy_DEtoHL, Vram_CopyHBlank; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_10_5EE0_Mode05_StampWindow_State06::
    INCBIN "data/bank_10/Gfx_10_5EE0_Mode05_StampWindow_State06.2bpp" ; $5EE0, 8480 bytes
