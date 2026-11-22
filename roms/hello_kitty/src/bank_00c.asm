; Pocket Camera Hello Kitty (Japan), bank $0C. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $00c", ROMX[$4000], BANK[$c]

; C: read in the runs by Vram_CopyHBlank, Copy_DEtoHL; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0C_4000_Mode05_StampWindow_State06::
    INCBIN "data/bank_0c/Gfx_0C_4000_Mode05_StampWindow_State06.2bpp" ; $4000, 14464 bytes
; I: leftover: 160 bytes (0C:7880-791F) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_0C_7880::
    db $7f, $4a, $7f, $4a, $ff, $ee, $7f, $42, $ff, $e2, $7f, $70, $1f, $1f, $00, $00
    db $7f, $4e, $7f, $48, $ff, $ee, $7f, $42, $ff, $ee, $7f, $70, $1f, $1f, $00, $00
    db $7f, $4e, $7f, $48, $ff, $ee, $7f, $4a, $ff, $ee, $7f, $70, $1f, $1f, $00, $00
    db $7f, $4e, $7f, $42, $ff, $e2, $7f, $42, $ff, $e2, $7f, $70, $1f, $1f, $00, $00
    db $7f, $4e, $7f, $4a, $ff, $ee, $7f, $4a, $ff, $ee, $7f, $70, $1f, $1f, $00, $00
    db $7f, $4e, $7f, $4a, $ff, $ee, $7f, $42, $ff, $ee, $7f, $70, $1f, $1f, $00, $00
    db $7f, $40, $7f, $40, $ff, $e8, $7f, $48, $ff, $e1, $7f, $70, $1f, $1f

    ; padding
    ds $32, $00

; C: read in the runs by Vram_CopyHBlank, Copy_DEtoHL; first read on the screen Mode02_TakePhotos_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0C_7920_Mode02_TakePhotos_State06::
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $fa, $e6, $fe, $a2, $ff, $a7, $fe, $a2, $ff, $e7, $fe, $0e, $f8, $f8, $00, $00
    db $fa, $46, $fe, $c2, $ff, $47, $fe, $42, $ff, $e7, $fe, $0e, $f8, $f8, $00, $00
    db $fa, $e6, $fe, $22, $ff, $e7, $fe, $82, $ff, $e7, $fe, $0e, $f8, $f8, $00, $00
    db $fa, $e6, $fe, $22, $ff, $e7, $fe, $22, $ff, $e7, $fe, $0e, $f8, $f8, $00, $00
    db $fa, $a6, $fe, $a2, $ff, $e7, $fe, $22, $ff, $27, $fe, $0e, $f8, $f8, $00, $00
    db $fa, $e6, $fe, $82, $ff, $e7, $fe, $22, $ff, $e7, $fe, $0e, $f8, $f8, $00, $00
    db $fa, $e6, $fe, $82, $ff, $e7, $fe, $a2, $ff, $e7, $fe, $0e, $f8, $f8, $00, $00
    db $fa, $e6, $fe, $22, $ff, $27, $fe, $22, $ff, $27, $fe, $0e, $f8, $f8, $00, $00
    db $fa, $e6, $fe, $a2, $ff, $e7, $fe, $a2, $ff, $e7, $fe, $0e, $f8, $f8, $00, $00
    db $fa, $e6, $fe, $a2, $ff, $e7, $fe, $22, $ff, $e7, $fe, $0e, $f8, $f8, $00, $00

    db $fa, $06, $fe, $02, $ff, $17, $fe, $12, $ff, $87, $fe, $0e, $f8, $f8

    ; padding
    ds $52, $00

; C: read in the runs by Copy_DEtoHL; first read on the screen Mode03_ViewAlbum_State0B
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0C_7A40_Mode03_ViewAlbum_State0B::
    INCBIN "data/bank_0c/Gfx_0C_7A40_Mode03_ViewAlbum_State0B.2bpp" ; $7A40, 32 bytes
; I: leftover: 128 bytes (0C:7A60-7ADF) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_0C_7A60::
    db $01, $03, $07, $03, $02, $06, $06, $06, $07, $07, $06, $06, $06, $06, $00, $00
    db $80, $c0, $e0, $c0, $40, $60, $60, $60, $e0, $e0, $60, $60, $60, $60, $00, $00
    db $07, $07, $06, $06, $06, $06, $07, $07, $06, $06, $06, $06, $07, $07, $00, $00
    db $40, $80, $60, $60, $40, $60, $80, $c0, $40, $60, $60, $60, $a0, $c0, $00, $00
    db $01, $03, $03, $06, $06, $06, $06, $06, $06, $06, $03, $06, $01, $03, $00, $00
    db $80, $c0, $c0, $60, $60, $60, $60, $60, $60, $60, $c0, $60, $80, $c0, $00, $00
    db $0c, $1e, $3f, $1e, $12, $33, $33, $33, $3f, $3f, $33, $33, $33, $33, $00, $00
    db $74, $78, $66, $66, $64, $66, $78, $7c, $64, $66, $66, $66, $7a, $7c, $00, $00

; C: read in the runs by Copy_DEtoHL; first read on the screen Mode03_ViewAlbum_State0B
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0C_7AE0_Mode03_ViewAlbum_State0B::
    INCBIN "data/bank_0c/Gfx_0C_7AE0_Mode03_ViewAlbum_State0B.bin" ; $7AE0, 37 bytes
; I: leftover: 59 bytes (0C:7B05-7B3F) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_0C_7B05::
    db $00, $03, $03, $04, $06, $04, $04, $04, $06, $03, $03, $3c, $7c, $0c, $1c, $1c
    db $34, $f4, $e4, $20, $64, $20, $20, $20, $60, $c0, $c0, $00, $00, $01, $01, $01
    db $09, $0d, $0d, $03, $07, $07, $03, $06, $0d, $0c, $18, $f0, $f0, $08, $98, $08
    db $08, $08, $98, $f0, $f0, $80, $00, $c0, $80, $40, $c0

; C: read in the runs by Copy_DEtoHL; first read on the screen Mode03_ViewAlbum_State0B
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0C_7B40_Mode03_ViewAlbum_State0B::
    INCBIN "data/bank_0c/Gfx_0C_7B40_Mode03_ViewAlbum_State0B.bin" ; $7B40, 17 bytes
; I: leftover: 239 bytes (0C:7B51-7C3F) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_0C_7B51::
    db $00, $2d, $1e, $12, $33, $33, $33, $33, $33, $33, $33, $12, $33, $2d, $1e, $00
    db $00, $1c, $0c, $3c, $3c, $38, $3c, $1c, $08, $08, $18, $18, $18, $18, $18, $00
    db $00, $5a, $3c, $66, $66, $06, $06, $2a, $1c, $70, $38, $30, $70, $7e, $7e, $00
    db $00, $5a, $3c, $66, $66, $06, $06, $08, $1c, $06, $06, $66, $66, $5a, $3c, $00
    db $00, $0e, $1e, $1e, $36, $34, $66, $46, $6c, $7f, $7f, $18, $18, $18, $18, $00
    db $00, $30, $18, $1e, $3e, $20, $70, $7a, $7c, $0e, $06, $7e, $3c, $3c, $78, $00
    db $00, $38, $18, $18, $38, $30, $30, $3c, $7c, $66, $66, $66, $66, $5a, $3c, $00
    db $00, $3e, $7e, $66, $66, $1c, $0e, $38, $1c, $18, $30, $30, $30, $30, $30, $00
    db $00, $5a, $3c, $66, $66, $66, $66, $3c, $3c, $66, $66, $66, $66, $5a, $3c, $00
    db $00, $5a, $3c, $66, $66, $66, $66, $3c, $3e, $0c, $0c, $18, $1c, $1c, $18

    ; padding
    ds $50, $00

; C: read in the runs by Vram_CopyHBlank, Copy_DEtoHL; first read on the screen Mode0A_NameCard_State01
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0C_7C40_Mode0A_NameCard_State01::
    INCBIN "data/bank_0c/Gfx_0C_7C40_Mode0A_NameCard_State01.2bpp" ; $7C40, 160 bytes
; C: read in the runs by Copy_DEtoHL, Vram_CopyHBlank; first read on the screen Mode0C_RecordBook_State01
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0C_7CE0_Mode0C_RecordBook_State01::
    INCBIN "data/bank_0c/Gfx_0C_7CE0_Mode0C_RecordBook_State01.2bpp" ; $7CE0, 160 bytes
; I: leftover: 160 bytes (0C:7D80-7E1F) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_0C_7D80::
    db $00, $ff, $00, $ff, $0c, $f3, $00, $f3, $10, $e3, $08, $e3, $28, $c3, $48, $93
    db $08, $93, $3a, $81, $00, $81, $08, $f3, $08, $f3, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $83, $3c, $83, $20, $9f, $30, $8f, $00, $87, $68, $93
    db $08, $f3, $08, $f3, $28, $93, $34, $83, $08, $c7, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $04, $c3, $5a, $81, $22, $99, $20, $9f, $20, $9f, $04, $83
    db $1a, $81, $22, $99, $22, $99, $5a, $81, $24, $c3, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $81, $7a, $81, $08, $f3, $04, $f3, $04, $f3, $10, $e7
    db $08, $e7, $08, $e7, $20, $cf, $20, $cf, $20, $cf, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $24, $c3, $5a, $81, $42, $99, $42, $99, $24, $c3, $42, $81
    db $18, $81, $24, $99, $00, $99, $42, $81, $3c, $c3, $00, $ff, $00, $ff, $00, $ff

; C: read in the runs by Copy_DEtoHL, Vram_CopyHBlank; kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0C_7E20_Copy_DEtoHL::
    INCBIN "data/bank_0c/Gfx_0C_7E20_Copy_DEtoHL.bin" ; $7E20, 65 bytes
; I: leftover: 287 bytes (0C:7E61-7F7F) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_0C_7E61::
    INCBIN "data/bank_0c/Leftover_0C_7E61.bin" ; $7E61, 287 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode02_TakePhotos_State08
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0C_7F80_Mode02_TakePhotos_State08::
    INCBIN "data/bank_0c/Gfx_0C_7F80_Mode02_TakePhotos_State08.2bpp" ; $7F80, 128 bytes
