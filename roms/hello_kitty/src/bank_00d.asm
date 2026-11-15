; Pocket Camera Hello Kitty (Japan), bank $0D. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $00d", ROMX[$4000], BANK[$d]

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0D_4000_Mode05_StampWindow_State06::
    db $00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $04, $07, $08, $0f, $08, $0f
    db $00, $00, $00, $00, $00, $00, $00, $00, $f0, $f0, $08, $f8, $08, $f8, $e8, $f8
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $09, $0f, $09, $0f, $08, $0f, $07, $07, $00, $00, $00, $00, $00, $00, $00, $00
    db $38, $f8, $44, $fc, $82, $fe, $83, $ff, $82, $ff, $4d, $7f, $39, $3f, $26, $3f
    db $00, $00, $00, $00, $00, $00, $c0, $c0, $20, $e0, $10, $f0, $10, $f0, $10, $f0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $20, $3f, $10, $1f, $0f, $0f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $10, $f0, $20, $e0, $c0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $40, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0D_4100_Mode05_StampWindow_State06::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $01, $03, $02, $02, $02, $02, $03, $03, $02, $02, $06, $06, $03, $03, $06, $07
    db $c1, $c1, $3f, $3f, $07, $87, $01, $01, $00, $00, $00, $00, $41, $41, $00, $08
    db $c0, $e0, $20, $20, $20, $e0, $e0, $e0, $e0, $e0, $30, $30, $60, $60, $30, $70
    db $01, $01, $02, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $80, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $40, $c0, $a0, $a0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $40, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0D_4200_Mode05_StampWindow_State06::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $07, $06, $08, $09, $19, $08
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $9c, $9f, $73, $ff
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $c0, $60, $20, $20, $20
    db $10, $18, $18, $10, $08, $18, $18, $10, $10, $10, $10, $10, $79, $79, $11, $11
    db $12, $1f, $0e, $0f, $01, $03, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01
    db $60, $f0, $50, $f0, $90, $f0, $f0, $70, $10, $10, $3c, $3c, $10, $10, $38, $38
    db $38, $38, $0c, $08, $15, $16, $02, $01, $00, $00, $00, $00, $00, $00, $00, $00
    db $10, $10, $00, $00, $01, $00, $fe, $ff, $00, $00, $00, $00, $00, $00, $00, $00
    db $10, $10, $60, $20, $50, $d0, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $40, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0D_4300_Mode05_StampWindow_State06::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $20, $20, $fc, $fc, $28, $28, $38, $38, $6c, $6c, $aa, $aa, $aa, $aa, $b2, $b2
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $54, $54, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $40, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0D_4400_Mode05_StampWindow_State06::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $20, $30
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $fe, $fc, $32, $fc, $24, $30, $36, $3c, $7c, $7e, $d7, $fe, $bf, $da, $b3, $fe
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $6c, $fe, $00, $0c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $40, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0D_4500_Mode05_StampWindow_State06::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $e0, $40
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $02, $01, $00, $03, $00, $00, $00, $00, $02, $01, $01, $03, $07, $02
    db $58, $60, $78, $f0, $00, $e0, $5c, $20, $3d, $fe, $fd, $e7, $e0, $2d, $6d, $38
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $c0, $80, $00, $c0
    db $06, $02, $06, $03, $01, $03, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $18, $38, $d8, $30, $e0, $f0, $e0, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $40, $c0, $40, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $40, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode03_ViewAlbum_State02
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0D_4600_Mode03_ViewAlbum_State02::
    db $ff, $ff, $ff, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $c3, $ff, $c7, $fc
    db $ff, $ff, $ff, $ff, $03, $ff, $0d, $fe, $17, $f8, $2f, $f0, $3f, $e0, $5f, $e0
    db $ff, $ff, $ff, $ff, $f0, $ff, $ec, $1f, $fa, $07, $fd, $03, $e7, $19, $fe, $19
    db $ff, $ff, $ff, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $83, $ff
    db $c7, $fc, $cb, $fc, $d7, $f8, $df, $f0, $fb, $fd, $df, $f1, $fb, $fc, $cf, $f8
    db $ff, $40, $ff, $40, $ff, $40, $ff, $40, $df, $78, $bb, $64, $ff, $38, $f7, $18
    db $ff, $18, $ff, $19, $e7, $18, $ff, $00, $fe, $01, $ff, $01, $fd, $03, $fa, $07
    db $83, $ff, $83, $ff, $83, $ff, $83, $ff, $83, $ff, $03, $ff, $03, $ff, $83, $ff
    db $d5, $fe, $c3, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $ff, $ff, $ff, $ff
    db $fd, $0e, $f3, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff
    db $ec, $1f, $f2, $ff, $01, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff
    db $43, $ff, $23, $ff, $13, $ff, $93, $ff, $63, $ff, $03, $ff, $ff, $ff, $ff, $ff

    ; padding
    ds $40, $00

; C: named by the code of Album_LoadTilesBank0D (05:6EF2); read in the runs by Vram_CopyHBlank; first read on the
; screen Mode03_ViewAlbum_State02 (trace/read_screens_kitty.npz); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_0D_4700_Album_LoadTilesBank0D::
    db $ff, $ff, $ff, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $c0, $ff
    db $ff, $ff, $ff, $ff, $00, $ff, $0f, $ff, $17, $f8, $2f, $f0, $3f, $e0, $2f, $f0
    db $ff, $ff, $ff, $ff, $00, $ff, $c0, $ff, $20, $ff, $90, $7f, $90, $7f, $90, $7f
    db $ff, $ff, $ff, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff
    db $c0, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $c1, $ff, $c1, $ff
    db $1f, $f0, $0e, $f9, $17, $f8, $17, $f8, $60, $ff, $bf, $c0, $7f, $80, $ff, $00
    db $20, $ff, $40, $ff, $a0, $7f, $a0, $7f, $18, $ff, $e4, $1f, $f2, $0f, $f2, $0f
    db $03, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff
    db $c1, $ff, $c1, $ff, $c1, $ff, $c1, $ff, $c0, $ff, $c0, $ff, $ff, $ff, $ff, $ff
    db $ff, $00, $ff, $ff, $ff, $00, $ff, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff
    db $f2, $0f, $fe, $ff, $f2, $0f, $fe, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff
    db $03, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $ff, $ff, $ff, $ff

    ; padding
    ds $40, $00

; C: named by the code of Album_LoadTilesBank0D (05:6EFD); read in the runs by Vram_CopyHBlank; first read on the
; screen Mode03_ViewAlbum_State02 (trace/read_screens_kitty.npz); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_0D_4800_Album_LoadTilesBank0D::
    db $ff, $ff, $ff, $ff, $cf, $ff, $d8, $f7, $df, $f4, $ff, $f4, $ff, $d4, $fc, $d7
    db $ff, $ff, $ff, $ff, $fe, $ff, $03, $fd, $ff, $05, $ff, $05, $ff, $05, $07, $fd
    db $ff, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $87, $ff, $9f, $fc, $a7, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $fb, $87, $fb, $bf, $fb, $a7, $fb, $a7, $fb, $a7
    db $fb, $d4, $ff, $d7, $fc, $d7, $fc, $d7, $fc, $d7, $ff, $d7, $ff, $d0, $ff, $d6
    db $fb, $05, $ff, $fd, $07, $fd, $07, $fd, $07, $fd, $ff, $fd, $ff, $01, $ff, $1d
    db $a0, $ff, $9c, $ff, $82, $ff, $82, $ff, $f2, $ff, $fc, $9f, $f0, $ff, $80, $ff
    db $fb, $a7, $fb, $a7, $fb, $a7, $fb, $bf, $e3, $bf, $fb, $bf, $fb, $87, $fb, $87
    db $f9, $df, $f9, $df, $ff, $d6, $df, $ff, $ef, $f0, $df, $ff, $ff, $ff, $ff, $ff
    db $ff, $15, $ff, $15, $ff, $1d, $ff, $fe, $fe, $01, $ff, $ff, $ff, $ff, $ff, $ff
    db $80, $ff, $80, $ff, $80, $ff, $80, $ff, $80, $ff, $00, $ff, $ff, $ff, $ff, $ff
    db $fb, $97, $fb, $bf, $fb, $97, $fb, $87, $fb, $87, $83, $ff, $ff, $ff, $ff, $ff

    ; padding
    ds $40, $00

; C: named by the code of Album_LoadTilesBank0D (05:6F08); read in the runs by Vram_CopyHBlank; first read on the
; screen Mode03_ViewAlbum_State02 (trace/read_screens_kitty.npz); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_0D_4900_Album_LoadTilesBank0D::
    db $ff, $ff, $ff, $ff, $c0, $ff, $c0, $ff, $df, $ff, $df, $f0, $d8, $f7, $db, $f4
    db $ff, $ff, $ff, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $00, $00, $ff, $ff, $00
    db $ff, $ff, $ff, $ff, $0f, $ff, $3f, $f0, $ff, $c0, $ff, $40, $e5, $9a, $ff, $80
    db $ff, $ff, $ff, $ff, $c3, $ff, $f3, $3f, $fb, $0f, $fb, $0f, $1f, $e7, $ff, $07
    db $db, $f4, $db, $f4, $db, $f4, $db, $f4, $db, $f4, $db, $f4, $db, $f4, $db, $f4
    db $ff, $01, $ff, $06, $ff, $07, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $e2, $9d, $ff, $00, $e4, $db, $ff, $40, $ff, $30, $ff, $1f, $ee, $17, $ee, $17
    db $9f, $67, $ff, $07, $5b, $af, $fb, $0f, $f3, $3f, $c3, $ff, $03, $ff, $03, $ff
    db $d8, $f7, $df, $f0, $df, $ff, $cf, $ff, $c0, $ff, $c0, $ff, $ff, $ff, $ff, $ff
    db $00, $ff, $ff, $00, $ff, $ff, $ff, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff
    db $0e, $f7, $fe, $07, $fe, $ff, $fe, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff
    db $03, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $ff, $ff, $ff, $ff

    ; padding
    ds $40, $00

; C: named by the code of Album_LoadTilesBank0D (05:6F16); read in the runs by Vram_CopyHBlank; first read on the
; screen Mode03_ViewAlbum_State02 (trace/read_screens_kitty.npz); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_0D_4A00_Album_LoadTilesBank0D::
    db $ff, $ff, $ff, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $c1, $ff
    db $ff, $ff, $ff, $ff, $1e, $ff, $1f, $f3, $1f, $f1, $1e, $f1, $7d, $f2, $bf, $f2
    db $ff, $ff, $ff, $ff, $f0, $ff, $fc, $9f, $fc, $07, $fc, $0f, $fc, $1f, $fa, $3f
    db $ff, $ff, $ff, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff
    db $c1, $ff, $c1, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $c0, $ff
    db $1f, $ff, $a7, $d8, $bf, $ff, $db, $a4, $db, $a4, $db, $a4, $db, $a4, $db, $a4
    db $e2, $ff, $26, $df, $f4, $ff, $6c, $97, $6c, $97, $6c, $97, $6c, $97, $6c, $97
    db $03, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff
    db $c0, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $ff, $ff, $ff, $ff
    db $db, $a4, $db, $a4, $db, $a4, $db, $e4, $7f, $ff, $00, $ff, $ff, $ff, $ff, $ff
    db $6c, $97, $6c, $97, $6c, $97, $6c, $9f, $f8, $ff, $00, $ff, $ff, $ff, $ff, $ff
    db $03, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $ff, $ff, $ff, $ff

    ; padding
    ds $40, $00

; C: named by the code of Album_LoadTilesBank0D (05:6F21); read in the runs by Vram_CopyHBlank; first read on the
; screen Mode03_ViewAlbum_State02 (trace/read_screens_kitty.npz); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_0D_4B00_Album_LoadTilesBank0D::
    db $ff, $ff, $ff, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $c0, $ff
    db $ff, $ff, $ff, $ff, $00, $ff, $3f, $ff, $3f, $e4, $3f, $e4, $3b, $ec, $37, $f8
    db $ff, $ff, $ff, $ff, $00, $ff, $ff, $ff, $7f, $fe, $ff, $0f, $ff, $03, $ff, $03
    db $ff, $ff, $ff, $ff, $03, $ff, $f3, $ff, $f3, $9f, $f3, $df, $f3, $df, $f3, $ff
    db $c0, $ff, $ff, $ff, $ff, $e4, $ff, $e4, $fb, $ec, $f7, $f8, $ff, $f0, $fb, $fd
    db $3f, $f0, $fb, $bd, $7f, $b1, $fb, $3c, $ff, $28, $fd, $36, $ff, $3f, $ff, $00
    db $ff, $00, $ff, $02, $ff, $02, $ff, $20, $ff, $00, $fe, $01, $ff, $ff, $f0, $0f
    db $b3, $7f, $f3, $3f, $73, $ff, $f3, $3f, $f3, $5f, $f3, $bf, $f3, $ff, $03, $ff
    db $ff, $f1, $fb, $fc, $ff, $e8, $fd, $f6, $ff, $ff, $c0, $ff, $ff, $ff, $ff, $ff
    db $ff, $02, $ff, $20, $ff, $00, $fe, $01, $ff, $ff, $00, $ff, $ff, $ff, $ff, $ff
    db $70, $ff, $f0, $3f, $f0, $5f, $f0, $bf, $f0, $ff, $00, $ff, $ff, $ff, $ff, $ff
    db $03, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $ff, $ff, $ff, $ff

    ; padding
    ds $40, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0D_4C00_Mode05_StampWindow_State06::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $02
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $5d, $33, $7f, $7f
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $00, $c0, $c0
    db $01, $03, $03, $01, $07, $02, $07, $03, $03, $01, $00, $01, $03, $01, $01, $03
    db $91, $7f, $74, $0f, $7f, $7f, $d5, $6e, $7f, $ff, $04, $ff, $bf, $7f, $ca, $3f
    db $00, $c0, $80, $00, $80, $c0, $80, $c0, $80, $c0, $40, $80, $c0, $c0, $40, $80
    db $06, $03, $03, $06, $02, $06, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $7f, $ff, $e1, $3f, $41, $60, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $e0, $c0, $40, $80, $80, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $40, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0D_4D00_Mode05_StampWindow_State06::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $1c, $1c
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $02, $01, $02, $00, $03, $00, $03, $00, $03, $00, $03
    db $3e, $22, $7f, $41, $7f, $41, $7f, $41, $3e, $22, $9c, $1c, $00, $80, $47, $87
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $c0
    db $00, $03, $00, $03, $00, $03, $00, $03, $00, $00, $00, $00, $00, $00, $00, $00
    db $04, $c4, $24, $c4, $04, $e4, $17, $e7, $00, $00, $00, $00, $00, $00, $00, $00
    db $40, $40, $40, $40, $40, $40, $c0, $c0, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $40, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0D_4E00_Mode05_StampWindow_State06::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $08, $08, $7e, $7e, $28, $28, $38, $38, $6c, $6c, $aa, $aa, $aa, $aa, $9a, $9a
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $06, $06, $0e, $0a, $1f, $13
    db $54, $54, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $60, $60, $70, $50, $f8, $c8
    db $3f, $20, $3f, $20, $1f, $13, $0e, $0a, $06, $06, $00, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $00, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $fc, $04, $fc, $04, $f8, $c8, $70, $50, $60, $60, $00, $00, $00, $00, $00, $00

    ; padding
    ds $40, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0D_4F00_Mode05_StampWindow_State06::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $04, $0c
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $7f, $3f, $4c, $3f, $24, $0c, $6c, $3c, $3e, $7e, $eb, $7f, $fd, $5b, $cd, $7f
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $06, $06, $0e, $0a, $1f, $13
    db $36, $7f, $00, $30, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $60, $60, $70, $50, $f8, $c8
    db $3f, $20, $3f, $20, $1f, $13, $0e, $0a, $06, $06, $00, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $00, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $fc, $04, $fc, $04, $f8, $c8, $70, $50, $60, $60, $00, $00, $00, $00, $00, $00

    ; padding
    ds $40, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0D_5000_Mode05_StampWindow_State06::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0e, $04
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $01, $03, $06, $03, $01, $06
    db $34, $0c, $3c, $1f, $00, $0f, $74, $08, $78, $fe, $7e, $cf, $0f, $69, $6d, $38
    db $00, $00, $80, $00, $00, $80, $00, $00, $00, $00, $80, $00, $00, $80, $c0, $80
    db $04, $06, $04, $06, $00, $00, $00, $00, $00, $00, $06, $06, $0e, $0a, $1f, $13
    db $30, $38, $36, $19, $0f, $1f, $0f, $00, $00, $00, $00, $00, $00, $00, $ff, $ff
    db $c0, $80, $c0, $80, $00, $80, $00, $00, $00, $00, $60, $60, $70, $50, $f8, $c8
    db $3f, $20, $3f, $20, $1f, $13, $0e, $0a, $06, $06, $00, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $00, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $fc, $04, $fc, $04, $f8, $c8, $70, $50, $60, $60, $00, $00, $00, $00, $00, $00

    ; padding
    ds $40, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0D_5100_Mode05_StampWindow_State06::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $00, $03, $03
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ba, $cc, $fe, $fe
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $40
    db $00, $03, $01, $00, $01, $03, $01, $03, $01, $03, $02, $01, $03, $03, $02, $01
    db $89, $fe, $2e, $f0, $fe, $fe, $ab, $76, $fe, $ff, $20, $ff, $fd, $fe, $53, $fc
    db $80, $c0, $c0, $80, $e0, $40, $e0, $c0, $c0, $80, $00, $80, $c0, $80, $80, $c0
    db $07, $03, $02, $01, $01, $03, $00, $00, $00, $00, $06, $06, $0e, $0a, $1f, $13
    db $fe, $ff, $87, $fc, $82, $06, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff
    db $60, $c0, $c0, $60, $40, $60, $00, $00, $00, $00, $60, $60, $70, $50, $f8, $c8
    db $3f, $20, $3f, $20, $1f, $13, $0e, $0a, $06, $06, $00, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $00, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $fc, $04, $fc, $04, $f8, $c8, $70, $50, $60, $60, $00, $00, $00, $00, $00, $00

    ; padding
    ds $40, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0D_5200_Mode05_StampWindow_State06::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $1c, $1c
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01
    db $3e, $22, $7f, $41, $7f, $41, $7f, $41, $3e, $22, $1c, $1c, $00, $00, $f1, $f0
    db $00, $00, $00, $00, $00, $20, $40, $20, $00, $60, $80, $60, $00, $e0, $00, $e0
    db $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $06, $06, $0e, $0a, $1f, $13
    db $10, $11, $12, $11, $10, $13, $f4, $f3, $00, $00, $00, $00, $00, $00, $ff, $ff
    db $00, $e0, $00, $e0, $00, $e0, $00, $e0, $00, $00, $60, $60, $70, $50, $f8, $c8
    db $3f, $20, $3f, $20, $1f, $13, $0e, $0a, $06, $06, $00, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $00, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $fc, $04, $fc, $04, $f8, $c8, $70, $50, $60, $60, $00, $00, $00, $00, $00, $00

    ; padding
    ds $40, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0D_5300_Mode05_StampWindow_State06::
    db $00, $00, $00, $00, $00, $00, $3f, $3f, $3f, $3f, $30, $30, $30, $30, $30, $30
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $fc, $fc, $fc, $fc, $0c, $0c, $0c, $0c, $0c, $0c
    db $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30
    db $20, $20, $fc, $fc, $28, $28, $38, $38, $6c, $6c, $aa, $aa, $aa, $aa, $b2, $b2
    db $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c
    db $30, $30, $30, $30, $30, $30, $30, $30, $3f, $3f, $3f, $3f, $00, $00, $00, $00
    db $54, $54, $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $00, $00, $00
    db $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $fc, $fc, $fc, $fc, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $40, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0D_5400_Mode05_StampWindow_State06::
    INCBIN "data/bank_0d/Gfx_0D_5400_Mode05_StampWindow_State06.bin" ; $5400, 255 bytes
; I: leftover: 2049 bytes (0D:54FF-5CFF) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_0D_54FF::
    db $00

    db $7f, $ff, $60, $c0, $6f, $c0, $68, $c0, $68, $c0, $69, $c1, $69, $c1, $69, $c1
    db $ff, $ff, $1e, $1e, $33, $21, $47, $42, $cf, $84, $df, $88, $fe, $90, $fe, $a8
    db $ff, $ff, $01, $01, $3d, $01, $85, $81, $c5, $41, $e5, $21, $35, $11, $39, $09
    db $69, $c1, $68, $c0, $68, $c0, $6f, $c0, $60, $c0, $7f, $c0, $7f, $ff, $00, $ff
    db $fe, $c4, $ff, $e2, $7f, $71, $bf, $38, $1f, $1c, $ff, $0f, $ff, $ff, $00, $ff
    db $3d, $05, $f9, $09, $f5, $11, $ed, $a1, $c1, $41, $ff, $81, $ff, $ff, $00, $ff
    db $7f, $ff, $60, $c0, $6f, $c0, $68, $c0, $69, $c1, $6b, $c2, $6f, $c4, $6f, $c6
    db $ff, $ff, $00, $00, $77, $70, $f0, $90, $ff, $1f, $ff, $00, $ff, $00, $ff, $00
    db $ff, $ff, $01, $01, $fd, $01, $05, $01, $c5, $c1, $c5, $41, $c5, $41, $c5, $41
    db $6f, $c7, $6b, $c3, $69, $c1, $6e, $c0, $60, $c0, $7f, $c0, $7f, $ff, $00, $ff
    db $ff, $1f, $ff, $9f, $ff, $ff, $f7, $f0, $00, $00, $ff, $00, $ff, $ff, $00, $ff
    db $c5, $c1, $c5, $c1, $c5, $c1, $fd, $01, $01, $01, $ff, $01, $ff, $ff, $00, $ff

    ; padding
    ds $40, $00

    db $7f, $ff, $60, $c0, $6f, $c0, $68, $c0, $68, $c0, $68, $c0, $68, $c0, $68, $c0
    db $ff, $ff, $00, $00, $fb, $03, $03, $02, $ff, $fe, $ff, $80, $ff, $80, $ff, $80
    db $ff, $ff, $01, $01, $bd, $81, $c5, $41, $e5, $21, $f5, $11, $fd, $09, $fd, $19
    db $68, $c0, $68, $c0, $68, $c0, $6f, $c0, $60, $c0, $7f, $c0, $7f, $ff, $00, $ff
    db $ff, $fe, $ff, $fe, $ff, $ff, $fb, $03, $00, $00, $ff, $00, $ff, $ff, $00, $ff
    db $fd, $39, $f5, $71, $e5, $e1, $dd, $c1, $01, $01, $ff, $01, $ff, $ff, $00, $ff
    db $7f, $ff, $60, $c0, $7f, $df, $70, $d0, $70, $d0, $70, $d1, $70, $d0, $70, $d0
    db $ff, $ff, $00, $00, $ff, $ff, $45, $45, $41, $45, $c1, $c1, $41, $41, $41, $41
    db $ff, $ff, $01, $01, $fd, $fd, $05, $0d, $15, $15, $15, $15, $15, $15, $15, $15
    db $70, $d1, $70, $d0, $70, $d0, $7f, $df, $60, $c0, $7f, $c0, $7f, $ff, $00, $ff
    db $c1, $c1, $41, $51, $51, $51, $ff, $ff, $00, $00, $ff, $00, $ff, $ff, $00, $ff
    db $15, $15, $15, $15, $05, $0d, $fd, $fd, $01, $01, $ff, $01, $ff, $ff, $00, $ff

    ; padding
    ds $40, $00

    db $7f, $ff, $40, $ff, $7f, $c0, $61, $de, $6f, $d1, $6f, $d1, $6f, $d1, $6f, $d1
    db $ff, $ff, $3c, $ff, $e7, $42, $8f, $85, $9f, $08, $bf, $10, $fc, $20, $fc, $50
    db $fe, $ff, $02, $ff, $fa, $07, $8a, $77, $ea, $97, $ea, $57, $7a, $27, $7a, $17
    db $6f, $d1, $6f, $d0, $6f, $d0, $6f, $d0, $60, $df, $7f, $c0, $7f, $ff, $00, $ff
    db $fc, $88, $ff, $c4, $ff, $62, $ff, $31, $3f, $d8, $ff, $0f, $ff, $ff, $00, $ff
    db $7a, $0f, $fa, $17, $fa, $27, $ea, $57, $ca, $b7, $fa, $07, $fe, $ff, $00, $ff
    db $7f, $ff, $40, $ff, $7f, $c0, $61, $de, $6f, $d1, $6f, $d2, $6f, $d4, $6f, $d8
    db $ff, $ff, $00, $ff, $ff, $00, $f0, $ef, $ff, $20, $ff, $3f, $ff, $00, $ff, $00
    db $fe, $ff, $02, $ff, $fa, $07, $0a, $f7, $ea, $17, $ea, $97, $ea, $97, $ea, $97
    db $6f, $dc, $6f, $d6, $6f, $d3, $6f, $d1, $61, $de, $7f, $c0, $7f, $ff, $00, $ff
    db $ff, $00, $ff, $3f, $ff, $3f, $ff, $e0, $f0, $ef, $ff, $00, $ff, $ff, $00, $ff
    db $ea, $97, $ea, $97, $ea, $97, $ea, $17, $0a, $f7, $fa, $07, $fe, $ff, $00, $ff

    ; padding
    ds $40, $00

    db $7f, $ff, $40, $ff, $7f, $c0, $60, $df, $6f, $d0, $6f, $d1, $6f, $d1, $6f, $d1
    db $ff, $ff, $00, $ff, $ff, $00, $0f, $f7, $ff, $04, $ff, $fc, $ff, $00, $ff, $00
    db $fe, $ff, $02, $ff, $fa, $07, $8a, $77, $ea, $97, $fa, $47, $fa, $27, $fa, $17
    db $6f, $d1, $6f, $d1, $6f, $d1, $6f, $d0, $60, $df, $7f, $c0, $7f, $ff, $00, $ff
    db $ff, $00, $ff, $fc, $ff, $fc, $ff, $07, $0f, $f7, $ff, $00, $ff, $ff, $00, $ff
    db $fa, $37, $fa, $67, $ea, $d7, $ea, $97, $8a, $77, $fa, $07, $fe, $ff, $00, $ff
    db $7f, $ff, $40, $ff, $7f, $c0, $7f, $ff, $7f, $e0, $7f, $e0, $7d, $e3, $7f, $e0
    db $ff, $ff, $00, $ff, $ff, $00, $ff, $ff, $ff, $8a, $f7, $8a, $ff, $82, $ff, $82
    db $fe, $ff, $02, $ff, $fa, $07, $fa, $ff, $ea, $1f, $fa, $2f, $fa, $2f, $fa, $2f
    db $7f, $e0, $7d, $e3, $7f, $e0, $7f, $e0, $7f, $ff, $7f, $c0, $7f, $ff, $00, $ff
    db $ff, $82, $ff, $82, $df, $a2, $ff, $a2, $ff, $ff, $ff, $00, $ff, $ff, $00, $ff
    db $fa, $2f, $fa, $2f, $fa, $2f, $ea, $1f, $fa, $ff, $fa, $07, $fe, $ff, $00, $ff

    ; padding
    ds $40, $00

    db $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $fe, $00, $fc, $00, $f8, $00, $f0
    db $ff, $ff, $00, $ff, $00, $ff, $00, $3f, $00, $1f, $00, $0f, $00, $07, $00, $03
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $f9, $00, $f9
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $27, $00, $27
    db $00, $f9, $00, $f8, $00, $f8, $00, $ff, $00, $ff, $00, $f8, $00, $f8, $00, $fc
    db $00, $27, $00, $07, $00, $07, $00, $ff, $00, $ff, $00, $07, $00, $07, $00, $7f
    db $00, $fe, $00, $fc, $00, $f8, $00, $f8, $00, $ff, $00, $ff, $00, $fe, $00, $fc
    db $00, $07, $00, $7f, $00, $07, $00, $07, $00, $ff, $00, $ff, $00, $07, $00, $07
    db $00, $f9, $00, $f9, $00, $fc, $00, $fe, $00, $ff, $00, $ff, $00, $f8, $00, $f8
    db $00, $bf, $00, $bf, $00, $07, $00, $07, $00, $ff, $00, $ff, $00, $07, $00, $07
    db $00, $ff, $00, $fe, $00, $f8, $00, $f8, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $1f, $00, $3f, $00, $07, $00, $07, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $f0, $00, $f8, $00, $fc, $00, $fe, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $03, $00, $07, $00, $0f, $00, $1f, $00, $3f, $00, $ff

    ; padding
    ds $20, $00

    db $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $fe, $00, $fc, $00, $f8, $00, $f0
    db $ff, $ff, $00, $ff, $00, $ff, $00, $3f, $00, $1f, $00, $0f, $00, $07, $00, $03
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $f8, $00, $f8, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $07, $00, $07, $00, $7f
    db $00, $ff, $00, $f8, $00, $f8, $00, $ff, $00, $ff, $00, $fb, $00, $f8, $00, $f8
    db $00, $7f, $00, $07, $00, $07, $00, $ff, $00, $ff, $00, $ff, $00, $07, $00, $07
    db $00, $fb, $00, $ff, $00, $ff, $00, $fc, $00, $f8, $00, $fb, $00, $f8, $00, $f8
    db $00, $ff, $00, $ff, $00, $ff, $00, $87, $00, $07, $00, $3f, $00, $07, $00, $07
    db $00, $ff, $00, $ff, $00, $fb, $00, $f8, $00, $f8, $00, $fb, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $f7, $00, $07, $00, $07, $00, $f7, $00, $ff, $00, $ff
    db $00, $fc, $00, $f8, $00, $fb, $00, $f8, $00, $f8, $00, $ff, $00, $ff, $00, $ff
    db $00, $8f, $00, $07, $00, $37, $00, $07, $00, $07, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $f0, $00, $f8, $00, $fc, $00, $fe, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $03, $00, $07, $00, $0f, $00, $1f, $00, $3f, $00, $ff

    ; padding
    ds $20, $00

    db $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $fc, $00, $f8, $00, $f9, $00, $f8
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $0f, $00, $07, $00, $e7, $00, $07
    db $00, $f8, $00, $ff, $00, $ff, $00, $fc, $00, $f8, $00, $f9, $00, $f8, $00, $fc
    db $00, $07, $00, $ff, $00, $ff, $00, $0f, $00, $07, $00, $e7, $00, $07, $00, $0f
    db $00, $ff, $00, $ff, $00, $fc, $00, $f8, $00, $f9, $00, $f8, $00, $fc, $00, $ff
    db $00, $ff, $00, $ff, $00, $0f, $00, $07, $00, $e7, $00, $07, $00, $0f, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $f8, $00, $f8, $00, $ff, $00, $ff
    db $00, $ff, $00, $e7, $00, $e7, $00, $e7, $00, $07, $00, $07, $00, $ff, $00, $ff
    db $00, $fc, $00, $f8, $00, $fb, $00, $f8, $00, $f8, $00, $ff, $00, $ff, $00, $ff
    db $00, $8f, $00, $07, $00, $37, $00, $07, $00, $07, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff

    ; padding
    ds $20, $00

    db $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $f9, $00, $f8, $00, $fe, $00, $ff, $00, $fe, $00, $f8
    db $00, $ff, $00, $ff, $00, $e7, $00, $c7, $00, $1f, $00, $3f, $00, $1f, $00, $c7
    db $00, $f9, $00, $ff, $00, $ff, $00, $f9, $00, $f9, $00, $f9, $00, $f8, $00, $f8
    db $00, $e7, $00, $ff, $00, $ff, $00, $27, $00, $27, $00, $27, $00, $07, $00, $07
    db $00, $ff, $00, $ff, $00, $fc, $00, $f8, $00, $f9, $00, $f9, $00, $f9, $04, $f8
    db $00, $ff, $00, $ff, $40, $8f, $08, $87, $80, $27, $00, $27, $40, $27, $00, $47
    db $00, $fc, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $80, $4f, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff

    ; padding
    ds $20, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0D_5D00_Mode05_StampWindow_State06::
    db $00, $00, $00, $00, $00, $00, $3f, $3f, $3f, $3f, $30, $30, $30, $30, $30, $30
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $e0, $40
    db $00, $00, $00, $00, $00, $00, $fc, $fc, $fc, $fc, $0c, $0c, $0c, $0c, $0c, $0c
    db $30, $30, $32, $31, $30, $33, $30, $30, $30, $30, $32, $31, $31, $33, $37, $32
    db $58, $60, $78, $f0, $00, $e0, $5c, $20, $3d, $fe, $fd, $e7, $e0, $2d, $6d, $38
    db $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $8c, $cc, $8c, $0c, $cc
    db $36, $32, $36, $33, $31, $33, $31, $30, $3f, $3f, $3f, $3f, $00, $00, $00, $00
    db $18, $38, $d8, $30, $e0, $f0, $e0, $00, $ff, $ff, $ff, $ff, $00, $00, $00, $00
    db $4c, $cc, $4c, $cc, $0c, $0c, $0c, $0c, $fc, $fc, $fc, $fc, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $40, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0D_5E00_Mode05_StampWindow_State06::
    db $00, $00, $00, $00, $00, $00, $3f, $3f, $3f, $3f, $30, $30, $30, $30, $33, $32
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $00, $5d, $33, $7f, $7f
    db $00, $00, $00, $00, $00, $00, $fc, $fc, $fc, $fc, $0c, $0c, $cc, $0c, $cc, $cc
    db $31, $33, $33, $31, $37, $32, $37, $33, $33, $31, $30, $31, $33, $31, $31, $33
    db $91, $7f, $74, $0f, $7f, $7f, $d5, $6e, $7f, $ff, $04, $ff, $bf, $7f, $ca, $3f
    db $0c, $cc, $8c, $0c, $8c, $cc, $8c, $cc, $8c, $cc, $4c, $8c, $cc, $cc, $4c, $8c
    db $36, $33, $33, $36, $32, $36, $30, $30, $3f, $3f, $3f, $3f, $00, $00, $00, $00
    db $7f, $ff, $e1, $3f, $41, $60, $00, $00, $ff, $ff, $ff, $ff, $00, $00, $00, $00
    db $ec, $cc, $4c, $8c, $8c, $cc, $0c, $0c, $fc, $fc, $fc, $fc, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $40, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0D_5F00_Mode05_StampWindow_State06::
    db $00, $00, $00, $00, $00, $00, $3f, $3f, $3f, $3f, $30, $30, $30, $30, $30, $30
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $fc, $fc, $fc, $fc, $0c, $0c, $0c, $0c, $0c, $0c
    db $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30
    db $08, $08, $7e, $7e, $28, $28, $38, $38, $6c, $6c, $aa, $aa, $aa, $aa, $9a, $9a
    db $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c
    db $30, $30, $30, $30, $30, $30, $30, $30, $3f, $3f, $3f, $3f, $00, $00, $06, $06
    db $54, $54, $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $00, $00, $00
    db $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $fc, $fc, $fc, $fc, $00, $00, $60, $60
    db $0e, $0a, $1f, $13, $3f, $20, $3f, $20, $1f, $13, $0e, $0a, $06, $06, $00, $00
    db $00, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $ff, $00, $00, $00, $00, $00, $00
    db $70, $50, $f8, $c8, $fc, $04, $fc, $04, $f8, $c8, $70, $50, $60, $60, $00, $00

    ; padding
    ds $40, $00

; I: named by the code of Mode03_State0A, Print_LoadFrameGfx (05:662F 01:697A); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_0D_6000_Mode03_ViewAlbum_State0A::
    INCBIN "data/bank_0d/Gfx_0D_6000_Mode03_ViewAlbum_State0A.2bpp" ; $6000, 1024 bytes
; C: named by the code of Mode03_State0A, Print_LoadFrameGfx (05:6645 01:6986); read in the runs by Copy_DEtoHL; first
; read on the screen Mode03_ViewAlbum_State0B (trace/read_screens_kitty.npz); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_0D_6400_Mode03_ViewAlbum_State0A::
    db $06, $0e, $1b, $1f, $19, $30, $60, $30, $00, $60, $e0, $40, $40, $c0, $c0, $c0
    db $00, $00, $80, $00, $80, $c0, $e0, $60, $20, $70, $3b, $3f, $1f, $3f, $3a, $1c
    db $00, $00, $00, $00, $01, $00, $03, $01, $07, $03, $ff, $ff, $fe, $ff, $06, $07
    db $5a, $3c, $7d, $fe, $c2, $ff, $81, $ff, $01, $ff, $00, $ff, $0e, $ff, $13, $ff
    db $0b, $07, $2e, $1f, $7a, $3c, $68, $f0, $e0, $c0, $80, $c0, $c0, $c0, $f4, $f8
    db $a0, $c0, $c0, $60, $30, $60, $64, $38, $3c, $36, $3f, $32, $3d, $33, $3f, $31
    db $ff, $c1, $3f, $c1, $ff, $01, $ff, $01, $fe, $01, $fe, $01, $fd, $03, $fe, $03
    db $80, $c0, $c0, $80, $e0, $80, $c0, $e0, $e0, $c0, $80, $c0, $00, $80, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $06, $07, $06, $07, $02, $07, $07, $03, $01, $03, $01, $00, $00, $00, $00, $00
    db $11, $ff, $1a, $ff, $0e, $ff, $06, $ff, $fe, $ff, $73, $ff, $05, $03, $01, $00
    db $0f, $ff, $07, $ff, $04, $ff, $06, $ff, $07, $ff, $09, $ff, $f9, $ff, $fe, $ff
    db $ff, $f1, $f7, $f9, $1f, $f9, $0f, $f9, $0e, $f9, $0f, $f8, $1f, $f8, $1f, $f8
    db $fb, $06, $fc, $06, $f6, $0c, $bc, $cc, $f8, $6c, $0c, $18, $18, $18, $38, $38
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $30, $3f, $10, $3f, $38, $1f, $0f, $0f, $0a, $07, $00, $00, $00, $00, $00, $00
    db $3b, $fc, $6f, $fc, $c5, $ce, $8e, $87, $03, $06, $06, $03, $03, $03, $07, $03
    db $e8, $18, $f8, $10, $b0, $60, $e0, $c0, $80, $00, $00, $00, $00, $00, $fa, $fc
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $01, $05, $06
    db $18, $18, $18, $18, $18, $18, $18, $18, $1f, $1f, $bc, $78, $48, $98, $1c, $08
    db $00, $00, $00, $00, $01, $01, $01, $03, $01, $83, $01, $03, $01, $01, $00, $00
    db $00, $00, $00, $00, $80, $80, $80, $c0, $80, $c0, $80, $c0, $80, $80, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0e, $0e
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $30, $30, $30, $78, $30, $78, $30, $78, $30, $30, $00, $00
    db $17, $0f, $5f, $33, $a3, $43, $03, $03, $07, $03, $27, $1f, $07, $03, $03, $07
    db $0d, $02, $00, $00, $00, $00, $00, $00, $00, $00, $a0, $c0, $c8, $30, $04, $08
    db $08, $0c, $05, $0e, $07, $0f, $0f, $1a, $13, $33, $21, $21, $00, $00, $00, $00
    db $00, $00, $c0, $c0, $80, $00, $00, $00, $80, $00, $d0, $b0, $f0, $e0, $fa, $fc
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $1f, $11, $1f, $11, $0e, $0e, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $02, $01, $17, $0f
    db $06, $07, $bf, $7e, $07, $0f, $0e, $1d, $38, $18, $b0, $70, $c0, $e0, $40, $80
    db $00, $00, $00, $00, $40, $80, $a0, $c0, $30, $60, $18, $10, $08, $08, $00, $00
    db $01, $01, $03, $02, $06, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $2f, $9f, $0b, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $60, $80, $ff, $ff, $9f, $7f, $01, $03, $02, $07, $07, $06, $0c, $06, $06, $0c
    db $00, $00, $ff, $ff, $ff, $ff, $06, $87, $0e, $07, $07, $0f, $1a, $0c, $3c, $18
    db $00, $00, $ff, $ff, $fe, $ff, $18, $f8, $18, $f8, $d8, $f8, $bc, $78, $78, $3c
    db $bd, $7e, $e8, $f0, $40, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $0b, $07, $0f, $0f, $1a, $1c, $10, $38, $38, $30, $30, $30, $30, $30, $30, $30
    db $4c, $8c, $dd, $ec, $af, $7f, $1e, $3c, $3c, $1c, $3e, $1c, $1f, $3f, $1b, $3f
    db $78, $38, $68, $f8, $c8, $f8, $68, $38, $38, $38, $60, $30, $e0, $e0, $f0, $e0
    db $3e, $3c, $34, $3e, $37, $3e, $32, $3f, $33, $3f, $31, $3f, $31, $3f, $31, $3f
    db $00, $00, $00, $00, $00, $00, $00, $00, $80, $00, $00, $80, $80, $80, $80, $80
    db $30, $30, $30, $30, $30, $30, $38, $30, $10, $38, $3a, $1c, $1f, $0f, $0b, $07
    db $30, $3f, $30, $3f, $30, $3f, $30, $3f, $30, $3f, $70, $3f, $ff, $ff, $ff, $ff
    db $3c, $f8, $08, $fc, $07, $ff, $03, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff
    db $21, $7f, $e1, $7f, $c3, $ff, $82, $ff, $05, $fe, $1a, $fc, $ff, $ff, $ff, $ff
    db $80, $80, $f4, $f8, $6c, $9e, $07, $06, $06, $03, $06, $07, $ff, $fe, $fa, $fc
    db $00, $00, $00, $00, $00, $00, $01, $00, $01, $03, $07, $02, $01, $06, $0f, $0c
    db $00, $00, $00, $00, $00, $00, $74, $f8, $fc, $06, $ff, $02, $fd, $03, $3f, $c1
    db $0f, $34, $3f, $24, $17, $1c, $0d, $0e, $03, $06, $05, $06, $07, $04, $07, $04
    db $ff, $c1, $3f, $c1, $ff, $01, $ff, $01, $fe, $01, $ff, $00, $ff, $00, $ff, $00
    db $00, $00, $00, $00, $00, $00, $78, $f8, $b4, $cc, $fc, $04, $f8, $04, $f4, $08
    db $03, $04, $07, $02, $02, $03, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $00, $ff, $00, $be, $c1, $fe, $7f, $08, $0c, $08, $0c, $38, $3c
    db $e8, $18, $f8, $10, $b0, $60, $e0, $c0, $80, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $2e, $1f, $3f, $60, $ff, $40, $bf, $c0, $fc, $83
    db $00, $00, $00, $00, $00, $00, $80, $00, $80, $c0, $e0, $40, $80, $60, $f0, $30
    db $00, $00, $00, $00, $00, $00, $1e, $1f, $2d, $33, $3f, $20, $1f, $20, $2f, $10
    db $ff, $83, $fc, $83, $ff, $80, $ff, $80, $7f, $80, $ff, $00, $ff, $00, $ff, $00
    db $f0, $2c, $fc, $24, $e8, $38, $b0, $70, $c0, $60, $a0, $60, $e0, $20, $e0, $20
    db $17, $18, $1f, $08, $0d, $06, $07, $03, $01, $00, $00, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $00, $ff, $00, $7d, $83, $7f, $fe, $10, $30, $10, $30, $1c, $3c
    db $c0, $20, $e0, $40, $40, $c0, $80, $80, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $a0, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0D_6900_Mode05_StampWindow_State06::
    db $00, $00, $00, $00, $00, $00, $3f, $3f, $3f, $3f, $30, $30, $30, $30, $30, $30
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $04, $0c
    db $00, $00, $00, $00, $00, $00, $fc, $fc, $fc, $fc, $0c, $0c, $0c, $0c, $0c, $0c
    db $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30
    db $7f, $3f, $4c, $3f, $24, $0c, $6c, $3c, $3e, $7e, $eb, $7f, $fd, $5b, $cd, $7f
    db $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c
    db $30, $30, $30, $30, $30, $30, $30, $30, $3f, $3f, $3f, $3f, $00, $00, $06, $06
    db $36, $7f, $00, $30, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $00, $00, $00
    db $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $fc, $fc, $fc, $fc, $00, $00, $60, $60
    db $0e, $0a, $1f, $13, $3f, $20, $3f, $20, $1f, $13, $0e, $0a, $06, $06, $00, $00
    db $00, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $ff, $00, $00, $00, $00, $00, $00
    db $70, $50, $f8, $c8, $fc, $04, $fc, $04, $f8, $c8, $70, $50, $60, $60, $00, $00

    ; padding
    ds $40, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0D_6A00_Mode05_StampWindow_State06::
    db $00, $00, $00, $00, $00, $00, $3f, $3f, $3f, $3f, $30, $30, $30, $30, $30, $30
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $0e, $04
    db $00, $00, $00, $00, $00, $00, $fc, $fc, $fc, $fc, $0c, $0c, $0c, $0c, $0c, $0c
    db $30, $30, $30, $30, $30, $30, $30, $30, $31, $30, $31, $33, $36, $33, $31, $36
    db $34, $0c, $3c, $1f, $00, $0f, $74, $08, $78, $fe, $7e, $cf, $0f, $69, $6d, $38
    db $0c, $0c, $8c, $0c, $0c, $8c, $0c, $0c, $0c, $0c, $8c, $0c, $0c, $8c, $cc, $8c
    db $34, $36, $34, $36, $30, $30, $30, $30, $3f, $3f, $3f, $3f, $00, $00, $06, $06
    db $30, $38, $36, $19, $0f, $1f, $0f, $00, $ff, $ff, $ff, $ff, $00, $00, $00, $00
    db $cc, $8c, $cc, $8c, $0c, $8c, $0c, $0c, $fc, $fc, $fc, $fc, $00, $00, $60, $60
    db $0e, $0a, $1f, $13, $3f, $20, $3f, $20, $1f, $13, $0e, $0a, $06, $06, $00, $00
    db $00, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $ff, $00, $00, $00, $00, $00, $00
    db $70, $50, $f8, $c8, $fc, $04, $fc, $04, $f8, $c8, $70, $50, $60, $60, $00, $00

    ; padding
    ds $40, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0D_6B00_Mode05_StampWindow_State06::
    db $00, $00, $00, $00, $00, $00, $3f, $3f, $3f, $3f, $30, $30, $33, $30, $33, $33
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $00, $ba, $cc, $fe, $fe
    db $00, $00, $00, $00, $00, $00, $fc, $fc, $fc, $fc, $0c, $0c, $0c, $0c, $cc, $4c
    db $30, $33, $31, $30, $31, $33, $31, $33, $31, $33, $32, $31, $33, $33, $32, $31
    db $89, $fe, $2e, $f0, $fe, $fe, $ab, $76, $fe, $ff, $20, $ff, $fd, $fe, $53, $fc
    db $8c, $cc, $cc, $8c, $ec, $4c, $ec, $cc, $cc, $8c, $0c, $8c, $cc, $8c, $8c, $cc
    db $37, $33, $32, $31, $31, $33, $30, $30, $3f, $3f, $3f, $3f, $00, $00, $06, $06
    db $fe, $ff, $87, $fc, $82, $06, $00, $00, $ff, $ff, $ff, $ff, $00, $00, $00, $00
    db $6c, $cc, $cc, $6c, $4c, $6c, $0c, $0c, $fc, $fc, $fc, $fc, $00, $00, $60, $60
    db $0e, $0a, $1f, $13, $3f, $20, $3f, $20, $1f, $13, $0e, $0a, $06, $06, $00, $00
    db $00, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $ff, $00, $00, $00, $00, $00, $00
    db $70, $50, $f8, $c8, $fc, $04, $fc, $04, $f8, $c8, $70, $50, $60, $60, $00, $00

    ; padding
    ds $40, $00

; C: read in the runs by Copy_DEtoHL; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz)
Src_0D_6C00_Mode05_StampWindow_State06::
    INCBIN "data/bank_0d/Src_0D_6C00_Mode05_StampWindow_State06.bin" ; $6C00, 736 bytes
; C: read in the runs by Copy_DEtoHL; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz)
Src_0D_6EE0_Mode05_StampWindow_State06::
    INCBIN "data/bank_0d/Src_0D_6EE0_Mode05_StampWindow_State06.bin" ; $6EE0, 224 bytes
; C: read in the runs by Copy_DEtoHL; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz)
Src_0D_6FC0_Mode05_StampWindow_State06::
    INCBIN "data/bank_0d/Src_0D_6FC0_Mode05_StampWindow_State06.bin" ; $6FC0, 96 bytes
; C: read in the runs by Copy_DEtoHL; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz)
Src_0D_7020_Mode05_StampWindow_State06::
    INCBIN "data/bank_0d/Src_0D_7020_Mode05_StampWindow_State06.bin" ; $7020, 544 bytes
; C: read in the runs by Copy_DEtoHL; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz)
Src_0D_7240_Mode05_StampWindow_State06::
    INCBIN "data/bank_0d/Src_0D_7240_Mode05_StampWindow_State06.bin" ; $7240, 64 bytes
; I: leftover: 64 bytes (0D:7280-72BF) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_0D_7280::
    db $f8, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $1f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
    db $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f8, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $1f
    db $f8, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $1f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
    db $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f8, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $1f

; C: read in the runs by Copy_DEtoHL; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz)
Src_0D_72C0_Mode05_StampWindow_State06::
    INCBIN "data/bank_0d/Src_0D_72C0_Mode05_StampWindow_State06.bin" ; $72C0, 32 bytes
; I: leftover: 96 bytes (0D:72E0-733F) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_0D_72E0::
    db $80, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $80, $00, $00, $00, $00, $00, $00, $00, $01
    db $80, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $80, $00, $00, $00, $00, $00, $00, $00, $01
    db $3f, $1f, $0f, $07, $03, $01, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7f
    db $00, $00, $00, $00, $00, $00, $00, $00, $3f, $1f, $0f, $07, $03, $01, $00, $00

; C: read in the runs by Copy_DEtoHL; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz)
Src_0D_7340_Mode05_StampWindow_State06::
    INCBIN "data/bank_0d/Src_0D_7340_Mode05_StampWindow_State06.bin" ; $7340, 128 bytes
; C: read in the runs by Copy_DEtoHL; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz)
Src_0D_73C0_Mode05_StampWindow_State06::
    INCBIN "data/bank_0d/Src_0D_73C0_Mode05_StampWindow_State06.bin" ; $73C0, 32 bytes
; I: leftover: 128 bytes (0D:73E0-745F) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_0D_73E0::
    db $f8, $e0, $c0, $80, $80, $00, $00, $00, $1f, $07, $03, $01, $01, $00, $00, $00
    db $00, $00, $00, $80, $80, $c0, $e0, $f8, $00, $00, $00, $01, $01, $03, $07, $1f
    db $f8, $e0, $c0, $80, $80, $00, $00, $00, $1f, $07, $03, $01, $01, $00, $00, $00
    db $00, $00, $00, $80, $80, $c0, $e0, $f8, $00, $00, $00, $01, $01, $03, $07, $1f
    db $f8, $e0, $c0, $80, $80, $00, $00, $00, $1f, $07, $03, $01, $01, $00, $00, $00
    db $00, $00, $00, $80, $80, $c0, $e0, $f8, $00, $00, $00, $01, $01, $03, $07, $1f
    db $ff, $ff, $ff, $ff, $f3, $f1, $f0, $f0, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7f
    db $f0, $f0, $f0, $f0, $ff, $ff, $ff, $ff, $3f, $1f, $0f, $0f, $ff, $ff, $ff, $ff

; C: read in the runs by Copy_DEtoHL
Src_0D_7460_Copy_DEtoHL::
    INCBIN "data/bank_0d/Src_0D_7460_Copy_DEtoHL.bin" ; $7460, 35 bytes
; I: leftover: 125 bytes (0D:7483-74FF) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_0D_7483::
    db $ff, $f3, $f1, $f0, $f0, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $f0, $f0, $f0
    db $f0, $ff, $ff, $ff, $ff, $3f, $1f, $0f, $0f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $f0, $f0, $f0, $f0, $ff, $ff, $ff, $ff, $0f, $0f, $1f, $3f, $f0, $f0, $f1
    db $f3, $ff, $ff, $ff, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $f0, $f0, $f0, $f0, $ff, $ff, $ff, $ff, $0f, $0f, $1f, $3f, $f0, $f0, $f1
    db $f3, $ff, $ff, $ff, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $f0, $f0, $f0, $f0, $ff, $ff, $ff, $ff, $0f, $0f, $1f, $3f, $f0, $f0, $f1
    db $f3, $ff, $ff, $ff, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff

; C: read in the runs by Copy_DEtoHL; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz)
Src_0D_7500_Mode05_StampWindow_State06::
    INCBIN "data/bank_0d/Src_0D_7500_Mode05_StampWindow_State06.bin" ; $7500, 320 bytes
; C: read in the runs by Copy_DEtoHL
Src_0D_7640_Copy_DEtoHL::
    INCBIN "data/bank_0d/Src_0D_7640_Copy_DEtoHL.bin" ; $7640, 38 bytes
; I: leftover: 58 bytes (0D:7666-769F) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_0D_7666::
    db $ff, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $fe, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $fe, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff

; C: read in the runs by Copy_DEtoHL; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz)
Src_0D_76A0_Mode05_StampWindow_State06::
    INCBIN "data/bank_0d/Src_0D_76A0_Mode05_StampWindow_State06.bin" ; $76A0, 101 bytes
; I: leftover: 59 bytes (0D:7705-773F) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_0D_7705::
    db $ff, $fe, $fc, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $3f, $fc, $fe, $ff, $ff, $ff
    db $ff, $ff, $ff, $3f, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $fe, $fc, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $3f, $fc, $fe, $ff, $ff, $ff
    db $ff, $ff, $ff, $3f, $7f, $ff, $ff, $ff, $ff, $ff, $ff

; C: read in the runs by Copy_DEtoHL; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz)
Src_0D_7740_Mode05_StampWindow_State06::
    INCBIN "data/bank_0d/Src_0D_7740_Mode05_StampWindow_State06.bin" ; $7740, 160 bytes
; C: read in the runs by Copy_DEtoHL; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz)
Src_0D_77E0_Mode05_StampWindow_State06::
    INCBIN "data/bank_0d/Src_0D_77E0_Mode05_StampWindow_State06.bin" ; $77E0, 67 bytes
; I: leftover: 61 bytes (0D:7823-785F) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_0D_7823::
    db $ff, $fc, $f8, $f0, $f0, $ff, $ff, $ff, $ff, $3f, $1f, $0f, $0f, $f0, $f0, $f8
    db $fc, $ff, $ff, $ff, $ff, $0f, $0f, $1f, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $fc, $f8, $f0, $f0, $ff, $ff, $ff, $ff, $3f, $1f, $0f, $0f, $f0, $f0, $f8
    db $fc, $ff, $ff, $ff, $ff, $0f, $0f, $1f, $3f, $ff, $ff, $ff, $ff

; C: read in the runs by Copy_DEtoHL; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz)
Src_0D_7860_Mode05_StampWindow_State06::
    INCBIN "data/bank_0d/Src_0D_7860_Mode05_StampWindow_State06.bin" ; $7860, 96 bytes
; C: read in the runs by Copy_DEtoHL; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz)
Src_0D_78C0_Mode05_StampWindow_State06::
    INCBIN "data/bank_0d/Src_0D_78C0_Mode05_StampWindow_State06.bin" ; $78C0, 96 bytes
; C: read in the runs by Copy_DEtoHL; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz)
Src_0D_7920_Mode05_StampWindow_State06::
    INCBIN "data/bank_0d/Src_0D_7920_Mode05_StampWindow_State06.bin" ; $7920, 160 bytes
; C: read in the runs by Copy_DEtoHL; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz)
Src_0D_79C0_Mode05_StampWindow_State06::
    INCBIN "data/bank_0d/Src_0D_79C0_Mode05_StampWindow_State06.bin" ; $79C0, 32 bytes
; I: leftover: 32 bytes (0D:79E0-79FF) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_0D_79E0::
    db $ff, $80, $80, $80, $80, $80, $80, $80, $ff, $01, $01, $01, $01, $01, $01, $01
    db $80, $80, $80, $80, $80, $80, $80, $ff, $01, $01, $01, $01, $01, $01, $01, $ff

; C: read in the runs by Copy_DEtoHL; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz)
Src_0D_7A00_Mode05_StampWindow_State06::
    INCBIN "data/bank_0d/Src_0D_7A00_Mode05_StampWindow_State06.bin" ; $7A00, 32 bytes
; I: leftover: 64 bytes (0D:7A20-7A5F) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_0D_7A20::
    db $ff, $80, $80, $80, $80, $80, $80, $80, $ff, $01, $01, $01, $01, $01, $01, $01
    db $80, $80, $80, $80, $80, $80, $80, $ff, $01, $01, $01, $01, $01, $01, $01, $ff
    db $ff, $80, $80, $80, $80, $80, $80, $80, $ff, $01, $01, $01, $01, $01, $01, $01
    db $80, $80, $80, $80, $80, $80, $80, $ff, $01, $01, $01, $01, $01, $01, $01, $ff

; C: read in the runs by Copy_DEtoHL; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz)
Src_0D_7A60_Mode05_StampWindow_State06::
    INCBIN "data/bank_0d/Src_0D_7A60_Mode05_StampWindow_State06.bin" ; $7A60, 32 bytes
; I: leftover: 96 bytes (0D:7A80-7ADF) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_0D_7A80::
    db $ff, $e0, $c0, $80, $80, $80, $80, $80, $ff, $ff, $3f, $1f, $0f, $07, $03, $03
    db $c0, $c0, $e0, $f0, $f8, $fc, $ff, $ff, $01, $01, $01, $01, $01, $03, $07, $ff
    db $ff, $e0, $c0, $80, $80, $80, $80, $80, $ff, $ff, $3f, $1f, $0f, $07, $03, $03
    db $c0, $c0, $e0, $f0, $f8, $fc, $ff, $ff, $01, $01, $01, $01, $01, $03, $07, $ff
    db $ff, $e0, $c0, $80, $80, $80, $80, $80, $ff, $ff, $3f, $1f, $0f, $07, $03, $03
    db $c0, $c0, $e0, $f0, $f8, $fc, $ff, $ff, $01, $01, $01, $01, $01, $03, $07, $ff

; C: read in the runs by Copy_DEtoHL; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz)
Src_0D_7AE0_Mode05_StampWindow_State06::
    INCBIN "data/bank_0d/Src_0D_7AE0_Mode05_StampWindow_State06.bin" ; $7AE0, 129 bytes
; I: leftover: 63 bytes (0D:7B61-7B9F) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_0D_7B61::
    db $ff, $cf, $c7, $e3, $f1, $f8, $fc, $ff, $ff, $f3, $e3, $c7, $8f, $1f, $3f, $fc
    db $f8, $f1, $e3, $c7, $cf, $ff, $ff, $3f, $1f, $8f, $c7, $e3, $f3, $ff, $ff, $ff
    db $ff, $cf, $c7, $e3, $f1, $f8, $fc, $ff, $ff, $f3, $e3, $c7, $8f, $1f, $3f, $fc
    db $f8, $f1, $e3, $c7, $cf, $ff, $ff, $3f, $1f, $8f, $c7, $e3, $f3, $ff, $ff

; C: read in the runs by Copy_DEtoHL; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz)
Src_0D_7BA0_Mode05_StampWindow_State06::
    INCBIN "data/bank_0d/Src_0D_7BA0_Mode05_StampWindow_State06.bin" ; $7BA0, 96 bytes
; C: read in the runs by Copy_DEtoHL; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz)
Src_0D_7C00_Mode05_StampWindow_State06::
    INCBIN "data/bank_0d/Src_0D_7C00_Mode05_StampWindow_State06.bin" ; $7C00, 224 bytes
; C: read in the runs by Copy_DEtoHL; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz)
Src_0D_7CE0_Mode05_StampWindow_State06::
    INCBIN "data/bank_0d/Src_0D_7CE0_Mode05_StampWindow_State06.bin" ; $7CE0, 160 bytes
; C: read in the runs by Copy_DEtoHL; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0D_7D80_Mode05_StampWindow_State06::
    INCBIN "data/bank_0d/Gfx_0D_7D80_Mode05_StampWindow_State06.2bpp" ; $7D80, 224 bytes
; I: leftover: 32 bytes (0D:7E60-7E7F) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_0D_7E60::
    db $7f, $7f, $7f, $bf, $bf, $df, $df, $ef, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ef, $f7, $fb, $fd, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $9f, $e7, $f8

; C: read in the runs by Copy_DEtoHL; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz)
Src_0D_7E80_Mode05_StampWindow_State06::
    INCBIN "data/bank_0d/Src_0D_7E80_Mode05_StampWindow_State06.bin" ; $7E80, 32 bytes
; I: leftover: 32 bytes (0D:7EA0-7EBF) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_0D_7EA0::
    db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $7f, $bf, $bf, $bf, $df, $ef, $f1, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00

; C: read in the runs by Copy_DEtoHL; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0D_7EC0_Mode05_StampWindow_State06::
    INCBIN "data/bank_0d/Gfx_0D_7EC0_Mode05_StampWindow_State06.2bpp" ; $7EC0, 320 bytes
