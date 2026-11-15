; Pocket Camera Hello Kitty (Japan), bank $1C. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $01c", ROMX[$4000], BANK[$1c]

; C: read in the runs by Vram_CopyHBlank, Copy_DEtoHL; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_1C_4000_Mode05_StampWindow_State06::
    INCBIN "data/bank_1c/Gfx_1C_4000_Mode05_StampWindow_State06.bin" ; $4000, 8666 bytes
; I: leftover: 2534 bytes (1C:61DA-6BBF) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_1C_61DA::
    INCBIN "data/bank_1c/Leftover_1C_61DA.bin" ; $61DA, 2534 bytes
; C: read in the runs by Copy_DEtoHL; first read on the screen Mode14_MessageScreen_State01
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_1C_6BC0_Mode14_MessageScreen_State01::
    INCBIN "data/bank_1c/Gfx_1C_6BC0_Mode14_MessageScreen_State01.2bpp" ; $6BC0, 640 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode03_ViewAlbum_State03
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py; the rest of Data_1C_6BC0
; after a leftover stretch
Map_1C_6E40_Mode03_ViewAlbum_State03::
    INCBIN "data/bank_1c/Map_1C_6E40_Mode03_ViewAlbum_State03.tilemap" ; $6E40, 1024 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode03_ViewAlbum_State03
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_1C_7240_Mode03_ViewAlbum_State03::
    INCBIN "data/bank_1c/Map_1C_7240_Mode03_ViewAlbum_State03.tilemap" ; $7240, 1024 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode03_ViewAlbum_State03
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_1C_7640_Mode03_ViewAlbum_State03::
    INCBIN "data/bank_1c/Map_1C_7640_Mode03_ViewAlbum_State03.tilemap" ; $7640, 1024 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode03_ViewAlbum_State03
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_1C_7A40_Mode03_ViewAlbum_State03::
    INCBIN "data/bank_1c/Map_1C_7A40_Mode03_ViewAlbum_State03.tilemap" ; $7A40, 1024 bytes
; C: read in the runs by Map_CopyColumnToD810, Vram_CopyHBlank; first read on the screen Mode0A_NameCard_State03
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_1C_7E40_Mode0A_NameCard_State03::
    INCBIN "data/bank_1c/Gfx_1C_7E40_Mode0A_NameCard_State03.2bpp" ; $7E40, 32 bytes
; C: read in the runs by Map_CopyColumnToD810, Vram_CopyHBlank, Print_StreamFromD3F4; first read on the screen
; Mode0A_NameCard_State03 (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py;
; the rest of Data_1C_7E40 after a leftover stretch
Map_1C_7E60_Mode0A_NameCard_State03::
    INCBIN "data/bank_1c/Map_1C_7E60_Mode0A_NameCard_State03.tilemap" ; $7E60, 416 bytes
