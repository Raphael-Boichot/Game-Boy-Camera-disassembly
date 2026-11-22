; Pocket Camera Hello Kitty (Japan), bank $2C. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $02c", ROMX[$4000], BANK[$2c]

; C: read in the runs by Vram_CopyHBlank, Copy_Unrolled_B; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_2C_4000_Mode02_TakePhotos_State01::
    INCBIN "data/bank_2c/Gfx_2C_4000_Mode02_TakePhotos_State01.2bpp" ; $4000, 14544 bytes
; C: named by the code of Mode09_State0C (06:6B13); read in the runs by Vram_CopyHBlank; first read on the screen
; Mode02_TakePhotos_State08 (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_2C_78D0_Mode09_ExchangeCommunicating_State0C::
    INCBIN "data/bank_2c/Gfx_2C_78D0_Mode09_ExchangeCommunicating_State0C.2bpp" ; $78D0, 480 bytes
; C: read in the runs by Copy_DEtoHL; kind MAP from the evidence of tools/kitty_layout_kinds.py; the rest of
; Map_2C_78D0 after a leftover stretch
Map_2C_7AB0_Copy_DEtoHL::
    INCBIN "data/bank_2c/Map_2C_7AB0_Copy_DEtoHL.tilemap" ; $7AB0, 544 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py; the rest of Map_2C_78D0
; after a leftover stretch
Gfx_2C_7CD0_Mode02_TakePhotos_State01::
    INCBIN "data/bank_2c/Gfx_2C_7CD0_Mode02_TakePhotos_State01.2bpp" ; $7CD0, 816 bytes
