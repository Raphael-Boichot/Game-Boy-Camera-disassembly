; Pocket Camera Hello Kitty (Japan), bank $2D. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $02d", ROMX[$4000], BANK[$2d]

; C: read in the runs by Copy_Unrolled_B, Vram_CopyHBlank; first read on the screen Mode11_StrawberryChannel_State07
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_2D_4000_Mode11_StrawberryChannel_State07::
    INCBIN "data/bank_2d/Gfx_2D_4000_Mode11_StrawberryChannel_State07.2bpp" ; $4000, 14368 bytes
; C: named by the code of Mode17_State00 (06:40D7); read in the runs by Vram_CopyHBlank; first read on the screen
; Mode02_TakePhotos_State08 (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_2D_7820_Mode17_PrintError_State00::
    INCBIN "data/bank_2d/Gfx_2D_7820_Mode17_PrintError_State00.2bpp" ; $7820, 480 bytes
; I: read in the runs by Copy_DEtoHL; kind MAP from the evidence of tools/kitty_layout_kinds.py; the rest of
; Map_2D_7820 after a leftover stretch
Map_2D_7A00_Copy_DEtoHL::
    INCBIN "data/bank_2d/Map_2D_7A00_Copy_DEtoHL.tilemap" ; $7A00, 544 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode02_TakePhotos_State08
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_2D_7C20_Mode02_TakePhotos_State08::
    INCBIN "data/bank_2d/Gfx_2D_7C20_Mode02_TakePhotos_State08.2bpp" ; $7C20, 992 bytes
