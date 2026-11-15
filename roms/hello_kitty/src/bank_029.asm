; Pocket Camera Hello Kitty (Japan), bank $29. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $029", ROMX[$4000], BANK[$29]

; C: read in the runs by Copy_Unrolled_B, Vram_CopyHBlank, Map_CopyColumnToD810; first read on the screen
; Mode11_StrawberryChannel_State07 (trace/read_screens_kitty.npz); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_29_4000_Mode11_StrawberryChannel_State07::
    INCBIN "data/bank_29/Gfx_29_4000_Mode11_StrawberryChannel_State07.2bpp" ; $4000, 16160 bytes
; C: read in the runs by Map_CopyColumnToD810, Vram_CopyHBlank, Print_StreamFromD3F4; first read on the screen
; Mode0A_NameCard_State01 (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py;
; the rest of Data_29_4000 after a leftover stretch
Map_29_7F20_Mode0A_NameCard_State01::
    INCBIN "data/bank_29/Map_29_7F20_Mode0A_NameCard_State01.tilemap" ; $7F20, 224 bytes
