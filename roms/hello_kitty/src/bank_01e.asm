; Pocket Camera Hello Kitty (Japan), bank $1E. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $01e", ROMX[$4000], BANK[$1e]

; C: read in the runs by Copy_Unrolled_B; first read on the screen Mode11_StrawberryChannel_State07
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_1E_4000_Mode11_StrawberryChannel_State07::
    INCBIN "data/bank_1e/Gfx_1E_4000_Mode11_StrawberryChannel_State07.2bpp" ; $4000, 14336 bytes
; C: named by the code of Mode00_State04, Mode06_State17 (05:420A 01:71FE); read in the runs by Copy_DEtoHL; first
; read on the screen Mode00_BootAndTitle_State00 (trace/read_screens_kitty.npz); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_1E_7800_Mode00_BootAndTitle_State04::
    INCBIN "data/bank_1e/Gfx_1E_7800_Mode00_BootAndTitle_State04.2bpp" ; $7800, 2048 bytes
