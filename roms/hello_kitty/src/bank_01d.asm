; Pocket Camera Hello Kitty (Japan), bank $1D. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $01d", ROMX[$4000], BANK[$1d]

; C: named by the code of Mode12_State00 (07:48D4); read in the runs by Copy_DEtoHL; first read on the screen
; Mode12_SlideShow_State01 (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_1D_4000_Mode12_SlideShow_State00::
    INCBIN "data/bank_1d/Gfx_1D_4000_Mode12_SlideShow_State00.2bpp" ; $4000, 5632 bytes
; I: named by the code of Mode09_State03, Exchange_InitScreen (06:6850 06:69FE); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_1D_5600_Mode09_ExchangeCommunicating_State03::
    INCBIN "data/bank_1d/Gfx_1D_5600_Mode09_ExchangeCommunicating_State03.2bpp" ; $5600, 5376 bytes
; C: named by the code of Mode07_State00 (06:61AF); read in the runs by Copy_DEtoHL; first read on the screen
; Mode07_Exchange_State00 (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_1D_6B00_Mode07_Exchange_State00::
    INCBIN "data/bank_1d/Gfx_1D_6B00_Mode07_Exchange_State00.2bpp" ; $6B00, 5184 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode0B_NameCardEdit_State0A
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_1D_7F40_Mode0B_NameCardEdit_State0A::
    INCBIN "data/bank_1d/Gfx_1D_7F40_Mode0B_NameCardEdit_State0A.2bpp" ; $7F40, 192 bytes
