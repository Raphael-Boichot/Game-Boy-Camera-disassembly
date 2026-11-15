; Pocket Camera Hello Kitty (Japan), bank $23. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $023", ROMX[$4000], BANK[$23]

; C: read in the runs by Copy_Unrolled_B; first read on the screen Mode11_StrawberryChannel_State07
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_23_4000_Mode11_StrawberryChannel_State07::
    INCBIN "data/bank_23/Gfx_23_4000_Mode11_StrawberryChannel_State07.2bpp" ; $4000, 3584 bytes
; C: read in the runs by Copy_DEtoHL; first read on the screen Mode10_ScratchCard_State02
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_23_4E00_Mode10_ScratchCard_State02::
    INCBIN "data/bank_23/Gfx_23_4E00_Mode10_ScratchCard_State02.2bpp" ; $4E00, 3408 bytes
; C: named by the code of Mode03_State0A (05:6639); read in BGB by a read watchpoint (trace/bgb_reads_kitty.csv:
; album_even); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_23_5B50_Mode03_ViewAlbum_State0A::
    INCBIN "data/bank_23/Map_23_5B50_Mode03_ViewAlbum_State0A.tilemap" ; $5B50, 1024 bytes
; C: named by the code of Mode03_State0A (05:664F); read in the runs by Copy_DEtoHL; first read on the screen
; Mode03_ViewAlbum_State0B (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_23_5F50_Mode03_ViewAlbum_State0A::
    INCBIN "data/bank_23/Map_23_5F50_Mode03_ViewAlbum_State0A.tilemap" ; $5F50, 1024 bytes
; C: named by the code of Mode03_State0A (05:661E); read in the runs by Copy_DEtoHL; first read on the screen
; Mode03_ViewAlbum_State0B (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_23_6350_Mode03_ViewAlbum_State0A::
    INCBIN "data/bank_23/Map_23_6350_Mode03_ViewAlbum_State0A.tilemap" ; $6350, 1024 bytes
; C: named by the code of Mode05_State00 (05:5FEA); read in the runs by Copy_DEtoHL; first read on the screen
; Mode05_StampWindow_State00 (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_23_6750_Mode05_StampWindow_State00::
    INCBIN "data/bank_23/Map_23_6750_Mode05_StampWindow_State00.tilemap" ; $6750, 1024 bytes
; C: named by the code of Mode05_State00 (05:5FF4); read in the runs by Copy_DEtoHL; first read on the screen
; Mode05_StampWindow_State00 (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_23_6B50_Mode05_StampWindow_State00::
    INCBIN "data/bank_23/Map_23_6B50_Mode05_StampWindow_State00.tilemap" ; $6B50, 288 bytes
; I: leftover: 224 bytes (23:6C70-6D4F) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_23_6C70::
    db $82, $83, $7e, $7e, $a0, $a1, $a2, $a3, $a4, $7e, $b9, $ba, $bb, $bc, $bd, $7e
    db $7e, $93, $94, $95, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $84, $85, $7e, $7e, $a5, $a6, $a7, $a8, $a9, $7e, $be, $bf, $c0, $c1, $c2, $7e
    db $7e, $60, $61, $62, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $86, $87, $7e, $7e, $aa, $ab, $ac, $ad, $ae, $7e, $c3, $c4, $c5, $c6, $c7, $7e
    db $7e, $63, $64, $65, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $88, $89, $7e, $7e, $af, $b0, $b1, $b2, $b3, $7e, $c8, $c9, $ca, $cb, $cc, $7e
    db $7e, $66, $67, $68, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $8a, $8b, $7e, $7e, $b4, $b5, $b6, $b7, $b8, $7e, $cd, $ce, $cf, $d0, $d1, $7e
    db $7e, $69, $6a, $6b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $8c, $8d, $7e, $7e, $7e, $7e, $7e, $7e, $7e, $7e, $7e, $7e, $7e, $7e, $7e, $7e
    db $7e, $96, $97, $98, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $8e, $8e, $7e, $7e, $7e, $7e, $7e, $7e, $7e, $7e, $7e, $7e, $7e, $7e, $7e, $7e
    db $7e, $8e, $8e, $8e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_23_6D50_Mode05_StampWindow_State06::
    INCBIN "data/bank_23/Map_23_6D50_Mode05_StampWindow_State06.tilemap" ; $6D50, 1024 bytes
; C: named by the code of Stamp_LoadWindowMapDefault (05:54EA); read in the runs by Vram_CopyHBlank; first read on the
; screen Mode05_StampWindow_State06 (trace/read_screens_kitty.npz); kind MAP from the evidence of
; tools/kitty_layout_kinds.py
Map_23_7150_Stamp_LoadWindowMapDefault::
    INCBIN "data/bank_23/Map_23_7150_Stamp_LoadWindowMapDefault.tilemap" ; $7150, 512 bytes
; C: named by the code of Mode02_State00, Mode02_State04, Mode03_State04 (05:49B1 05:4B32 05:7334); read in the runs
; by Copy_DEtoHL; first read on the screen Mode02_TakePhotos_State00 (trace/read_screens_kitty.npz)
Gfx_23_7350_Mode02_TakePhotos_State00::
    INCBIN "data/bank_23/Gfx_23_7350_Mode02_TakePhotos_State00.2bpp" ; $7350, 256 bytes
; C: named by the code of Mode0A_State00 (06:5630); read in the runs by Copy_DEtoHL; first read on the screen
; Mode02_TakePhotos_State00 (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_23_7450_Mode0A_NameCard_State00::
    INCBIN "data/bank_23/Gfx_23_7450_Mode0A_NameCard_State00.2bpp" ; $7450, 224 bytes
; C: read in the runs by Copy_DEtoHL; first read on the screen Mode02_TakePhotos_State00
; (trace/read_screens_kitty.npz)
Gfx_23_7530_Mode02_TakePhotos_State00::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

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
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $200, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_23_7950_Mode02_TakePhotos_State01::
    db $00, $00, $00, $00, $0f, $0f, $1f, $1f, $eb, $f7, $ff, $e0, $df, $e0, $7f, $40
    db $ff, $c0, $7f, $40, $ff, $c0, $5f, $60, $6f, $70, $18, $1f, $3f, $27, $2f, $3f
    db $00, $00, $00, $00, $00, $00, $38, $38, $d4, $ec, $fc, $04, $fa, $06, $fe, $02
    db $ff, $03, $fe, $02, $ff, $03, $fa, $06, $f6, $0e, $18, $f8, $fc, $e4, $f4, $fc
    db $3f, $3f, $7f, $5f, $7f, $5f, $5d, $7e, $3d, $3e, $07, $07, $00, $00, $00, $00
    db $fc, $fc, $fe, $fa, $fe, $fa, $ba, $7e, $bc, $7c, $e0, $e0, $00, $00, $00, $00
    db $00, $00, $00, $00, $1c, $1c, $1c, $1c, $7b, $77, $7f, $70, $7f, $70, $5f, $60
    db $7f, $60, $7f, $40, $7f, $60, $5f, $60, $33, $3c, $1e, $1f, $3f, $27, $2f, $3f
    db $00, $00, $00, $00, $00, $00, $78, $78, $d4, $ec, $fc, $04, $fa, $06, $fe, $02
    db $fe, $02, $fe, $02, $fe, $02, $fa, $06, $f4, $0c, $1c, $fc, $fc, $e4, $f4, $fc
    db $3f, $3f, $7f, $5f, $7f, $5f, $5d, $7e, $3d, $3e, $07, $07, $00, $00, $00, $00
    db $fc, $fc, $fe, $fa, $fe, $fa, $ba, $7e, $bc, $7c, $e0, $e0, $00, $00, $00, $00
    db $00, $00, $00, $00, $03, $03, $07, $07, $07, $07, $1b, $1d, $2f, $31, $3f, $20
    db $5f, $65, $7f, $44, $7f, $60, $7f, $40, $2f, $31, $1b, $1c, $3f, $27, $2f, $3f
    db $00, $00, $00, $00, $e0, $e0, $d0, $b0, $f0, $90, $f8, $d8, $f4, $cc, $fa, $06
    db $fe, $e2, $fe, $02, $fe, $c2, $fa, $06, $f4, $0c, $d8, $b8, $fc, $e4, $f4, $fc
    db $3f, $3f, $7f, $5f, $7f, $5f, $5d, $7e, $3d, $3e, $07, $07, $00, $00, $00, $00
    db $fc, $fc, $fe, $fa, $fe, $fa, $ba, $7e, $bc, $7c, $e0, $e0, $00, $00, $00, $00
    db $00, $00, $00, $00, $01, $01, $1d, $1d, $2b, $37, $3f, $20, $5f, $60, $7f, $40
    db $ff, $e0, $7f, $60, $f7, $cc, $5f, $60, $af, $b0, $1b, $1c, $3f, $27, $2f, $3f
    db $00, $00, $00, $00, $c0, $c0, $f8, $f8, $dc, $e4, $fc, $74, $fa, $76, $fe, $02
    db $ff, $9f, $fe, $82, $ff, $0f, $fa, $06, $f4, $0c, $9a, $7a, $fc, $e4, $f4, $fc
    db $3f, $3f, $7f, $5f, $7f, $5f, $5d, $7e, $3d, $3e, $07, $07, $00, $00, $00, $00
    db $fc, $fc, $fe, $fa, $fe, $fa, $ba, $7e, $bc, $7c, $e0, $e0, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $0f, $0f, $1f, $1f, $eb, $f7, $ff, $e0, $df, $e0
    db $7f, $40, $ff, $c0, $7f, $40, $ff, $c0, $5f, $60, $7f, $70, $3f, $2f, $1f, $1f
    db $00, $00, $00, $00, $00, $00, $00, $00, $38, $38, $d4, $ec, $fc, $04, $fa, $06
    db $fe, $02, $ff, $03, $fe, $02, $ff, $03, $fa, $06, $fe, $0e, $fc, $f4, $f8, $f8
    db $3f, $3f, $3f, $3f, $5d, $7e, $7d, $5e, $6f, $5f, $38, $38, $00, $00, $00, $00
    db $fc, $fc, $fc, $fc, $ba, $7e, $be, $7a, $f6, $fa, $1c, $1c, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $0f, $0f, $1f, $1f, $eb, $f7, $ff, $e0, $df, $e0
    db $7f, $40, $ff, $c0, $7f, $40, $ff, $c0, $5f, $60, $77, $7f, $1f, $1f, $2f, $3f
    db $00, $00, $00, $00, $00, $00, $00, $00, $38, $38, $d4, $ec, $fc, $04, $fa, $06
    db $fe, $02, $ff, $03, $fe, $02, $ff, $03, $fa, $06, $ee, $fe, $f8, $f8, $f4, $fc
    db $3f, $3f, $7d, $5e, $5d, $7e, $3f, $3f, $00, $00, $00, $00, $00, $00, $00, $00
    db $fc, $fc, $be, $7a, $ba, $7e, $fc, $fc, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $03, $03, $1c, $1f, $24, $3f, $42, $7f, $41, $7e, $23, $3c
    db $1f, $1c, $23, $3c, $41, $7e, $42, $7f, $24, $3f, $1c, $1f, $03, $03, $00, $00
    db $00, $00, $00, $00, $c0, $c0, $38, $f8, $24, $fc, $42, $fe, $82, $7e, $c4, $3c
    db $f8, $38, $c4, $3c, $82, $7e, $42, $fe, $24, $fc, $38, $f8, $c0, $c0, $00, $00
    db $00, $00, $07, $07, $38, $3f, $48, $7f, $84, $ff, $80, $ff, $83, $fc, $47, $78
    db $3f, $38, $47, $78, $83, $fc, $80, $ff, $84, $ff, $48, $7f, $38, $3f, $07, $07
    db $00, $00, $e0, $e0, $1c, $fc, $12, $fe, $21, $ff, $01, $ff, $c1, $3f, $e6, $1e
    db $fc, $1c, $e2, $1e, $c1, $3f, $01, $ff, $21, $ff, $12, $fe, $1c, $fc, $e0, $e0
    db $00, $00, $00, $00, $00, $00, $03, $03, $0c, $0f, $14, $1f, $22, $3f, $21, $3e
    db $1b, $1c, $21, $3e, $22, $3f, $14, $1f, $0c, $0f, $03, $03, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $c0, $c0, $30, $f0, $28, $f8, $44, $fc, $84, $7c
    db $d8, $38, $84, $7c, $44, $fc, $28, $f8, $30, $f0, $c0, $c0, $00, $00, $00, $00

    ; padding
    ds $100, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode02_TakePhotos_State08
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_23_7D50_Mode02_TakePhotos_State08::
    INCBIN "data/bank_23/Gfx_23_7D50_Mode02_TakePhotos_State08.2bpp" ; $7D50, 688 bytes
