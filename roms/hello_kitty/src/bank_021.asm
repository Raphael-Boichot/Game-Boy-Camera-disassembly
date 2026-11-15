; Pocket Camera Hello Kitty (Japan), bank $21. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $021", ROMX[$4000], BANK[$21]

; C: read in the runs by Copy_Unrolled_B; first read on the screen Mode11_StrawberryChannel_State07
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_21_4000_Mode11_StrawberryChannel_State07::
    INCBIN "data/bank_21/Gfx_21_4000_Mode11_StrawberryChannel_State07.2bpp" ; $4000, 14336 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode03_ViewAlbum_State03
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py; the rest of Data_21_4000
; after a leftover stretch
Map_21_7800_Mode03_ViewAlbum_State03::
    INCBIN "data/bank_21/Map_21_7800_Mode03_ViewAlbum_State03.tilemap" ; $7800, 1024 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode03_ViewAlbum_State03
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_21_7C00_Mode03_ViewAlbum_State03::
    INCBIN "data/bank_21/Map_21_7C00_Mode03_ViewAlbum_State03.tilemap" ; $7C00, 1024 bytes
