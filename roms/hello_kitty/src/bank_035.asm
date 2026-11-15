; Pocket Camera Hello Kitty (Japan), bank $35. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $035", ROMX[$4000], BANK[$35]

; C: read in the runs by Copy_Unrolled_B; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty.npz); kind T_FRM from the evidence of tools/kitty_layout_kinds.py
Frame_35_4000_Mode02_TakePhotos_State01::
    INCBIN "data/bank_35/Frame_35_4000_Mode02_TakePhotos_State01.bin" ; $4000, 10752 bytes
; C: read in the runs by Copy_Unrolled_B, MapRows_Copy13, Map_Write5PlusA0Safe; first read on the screen
; Mode11_StrawberryChannel_State07 (trace/read_screens_kitty.npz); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py; the rest of Data_35_4000 after a leftover stretch
Gfx_35_6A00_Mode11_StrawberryChannel_State07::
    INCBIN "data/bank_35/Gfx_35_6A00_Mode11_StrawberryChannel_State07.2bpp" ; $6A00, 4400 bytes
; I: leftover: 136 bytes (35:7B30-7BB7) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_35_7B30::
    db $00

    db $01, $00, $02, $03, $00, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $47
    db $48, $00, $00, $00, $0e, $0f, $10, $11, $0f, $12, $13, $14, $15, $16, $17, $18
    db $19, $1a, $1b, $49, $4a, $4b, $00, $28, $29, $2a, $2b, $2c, $2d, $2e, $2f, $30
    db $31, $32, $33, $34, $00, $35, $36, $48, $58, $59, $5a, $37, $38, $39, $3a, $3b
    db $3c, $3d, $3e, $3f, $40, $41, $42, $43, $44, $45, $46, $4a, $5b, $5c, $5d

    ; padding
    ds $10, $00

    db $1c, $1d, $4c, $4d, $1e, $1f, $4e, $4f, $20, $21, $50, $51, $22, $23, $52, $53
    db $24, $25, $54, $55, $26, $27, $56, $57

    ; padding
    ds $10, $00

; C: read in the runs by Map_Write5PlusA0Safe, FrameRec_LoadMap; first read on the screen Mode06_Printing_State0D
; (trace/read_screens_kitty.npz)
Src_35_7BB8_Mode06_Printing_State0D::
    INCBIN "data/bank_35/Src_35_7BB8_Mode06_Printing_State0D.bin" ; $7BB8, 136 bytes
; I: leftover: 136 bytes (35:7C40-7CC7) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_35_7C40::
    db $00, $01, $02, $03, $04, $05, $06, $04, $07, $08, $09, $0a, $0b, $0c, $0d, $0e
    db $2b, $2c, $2d, $2e, $0f, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1a
    db $1b, $1c, $1d, $1e, $2f, $30, $31, $32, $04, $04, $04, $04, $04, $04, $04, $04
    db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
    db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
    db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
    db $1f, $20, $33, $34, $21, $22, $35, $36, $23, $24, $37, $38, $25, $26, $39, $3a
    db $27, $28, $3b, $3c, $29, $2a, $3d, $3e, $04, $04, $04, $04, $04, $04, $04, $04
    db $04, $04, $04, $04, $04, $04, $04, $04

; C: read in the runs by Map_Write5PlusA0Safe, FrameRec_LoadMap, MapRows_Copy13; first read on the screen
; Mode03_ViewAlbum_State11 (trace/read_screens_kitty.npz)
Src_35_7CC8_Mode03_ViewAlbum_State11::
    INCBIN "data/bank_35/Src_35_7CC8_Mode03_ViewAlbum_State11.bin" ; $7CC8, 277 bytes
; I: leftover: 131 bytes (35:7DDD-7E5F) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_35_7DDD::
    db $00, $01, $02, $03, $04, $05, $06, $07, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $08, $09, $0a, $0b, $0c, $0d, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $0e, $00, $00, $0f, $10, $11, $12, $13, $14, $15, $16
    db $17, $00, $00, $00, $20, $00, $00, $00, $00, $00, $00, $00, $00, $18, $19, $1a
    db $1b, $1c, $1d, $1e, $1f

    ; padding
    ds $3e, $00

; C: read in the runs by Map_Write5PlusA0Safe, FrameRec_LoadMap; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_35_7E60_Mode02_TakePhotos_State01::
    INCBIN "data/bank_35/Gfx_35_7E60_Mode02_TakePhotos_State01.bin" ; $7E60, 141 bytes
; I: leftover: 131 bytes (35:7EED-7F6F) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_35_7EED::
    db $00, $01, $02, $03, $04, $05, $06, $07, $08, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $09, $0a, $0b, $0c, $0d, $0e, $0f, $10, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1a
    db $1b, $1c, $1d, $1e

    ; padding
    ds $4f, $00

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode02_TakePhotos_State08
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_35_7F70_Mode02_TakePhotos_State08::
    INCBIN "data/bank_35/Gfx_35_7F70_Mode02_TakePhotos_State08.2bpp" ; $7F70, 144 bytes
