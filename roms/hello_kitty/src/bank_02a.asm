; Pocket Camera Hello Kitty (Japan), bank $2A. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $02a", ROMX[$4000], BANK[$2a]

; C: read in the runs by Copy_Unrolled_B, Vram_CopyHBlank; first read on the screen Mode11_StrawberryChannel_State07
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_2A_4000_Mode11_StrawberryChannel_State07::
    INCBIN "data/bank_2a/Gfx_2A_4000_Mode11_StrawberryChannel_State07.2bpp" ; $4000, 16144 bytes
; C: read in the runs by Map_CopyColumnToD810, Vram_CopyHBlank, Print_StreamFromD3F4; first read on the screen
; Mode0A_NameCard_State03 (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py;
; the rest of Data_2A_4000 after a leftover stretch
Map_2A_7F10_Mode0A_NameCard_State03::
    INCBIN "data/bank_2a/Map_2A_7F10_Mode0A_NameCard_State03.tilemap" ; $7F10, 240 bytes
