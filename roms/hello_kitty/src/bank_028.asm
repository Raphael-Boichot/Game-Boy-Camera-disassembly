; Pocket Camera Hello Kitty (Japan), bank $28. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $028", ROMX[$4000], BANK[$28]

; C: read in the runs by Copy_Unrolled_B, Vram_CopyHBlank; first read on the screen Mode11_StrawberryChannel_State07
; (trace/read_screens_kitty*.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_28_4000_Mode11_StrawberryChannel_State07::
    INCBIN "data/bank_28/Gfx_28_4000_Mode11_StrawberryChannel_State07.2bpp" ; $4000, 16144 bytes
; C: read in the runs by Vram_CopyHBlank, Print_StreamFromD3F4; first read on the screen Mode0A_NameCard_State01
; (trace/read_screens_kitty*.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py; the rest of Data_28_4000
; after a leftover stretch
Map_28_7F10_Mode0A_NameCard_State01::
    INCBIN "data/bank_28/Map_28_7F10_Mode0A_NameCard_State01.tilemap" ; $7F10, 240 bytes
