; Pocket Camera Hello Kitty (Japan), bank $1C. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $01c", ROMX[$4000], BANK[$1c]

; C: read in the runs by Vram_CopyHBlank, Copy_DEtoHL; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty*.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_1C_4000_Mode05_StampWindow_State06::
    INCBIN "data/bank_1c/Gfx_1C_4000_Mode05_StampWindow_State06.2bpp" ; $4000, 8640 bytes
; C: the picture strips of messages 0 / 8, 1, 2 and 3 of the message screen (mode $14), $280 bytes each at 1C:57C0 +
; the offsets of 06:4450 ($0A00, $0C80, $0F00, $1180), copied to $8800 by Mode14_State00 (06:44E1); white kana on
; black; read in the core: message 0 in tools/kitty_rare_runs.py (album full ...
Gfx_1C_61C0_MessageStrips::
    INCBIN "data/bank_1c/Gfx_1C_61C0_MessageStrips.2bpp" ; $61C0, 4224 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode03_ViewAlbum_State03
; (trace/read_screens_kitty*.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_1C_7240_Mode03_ViewAlbum_State03::
    INCBIN "data/bank_1c/Map_1C_7240_Mode03_ViewAlbum_State03.tilemap" ; $7240, 1024 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode03_ViewAlbum_State03
; (trace/read_screens_kitty*.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_1C_7640_Mode03_ViewAlbum_State03::
    INCBIN "data/bank_1c/Map_1C_7640_Mode03_ViewAlbum_State03.tilemap" ; $7640, 1024 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode03_ViewAlbum_State03
; (trace/read_screens_kitty*.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_1C_7A40_Mode03_ViewAlbum_State03::
    INCBIN "data/bank_1c/Map_1C_7A40_Mode03_ViewAlbum_State03.tilemap" ; $7A40, 1024 bytes
; C: read in the runs by Map_CopyColumnToD810, Vram_CopyHBlank; first read on the screen Mode0A_NameCard_State03
; (trace/read_screens_kitty*.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_1C_7E40_Mode0A_NameCard_State03::
    INCBIN "data/bank_1c/Gfx_1C_7E40_Mode0A_NameCard_State03.2bpp" ; $7E40, 32 bytes
; C: read in the runs by Map_CopyColumnToD810, Vram_CopyHBlank, Print_StreamFromD3F4; first read on the screen
; Mode0A_NameCard_State03 (trace/read_screens_kitty*.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py;
; the rest of Data_1C_7E40 after a leftover stretch
Map_1C_7E60_Mode0A_NameCard_State03::
    INCBIN "data/bank_1c/Map_1C_7E60_Mode0A_NameCard_State03.tilemap" ; $7E60, 416 bytes
