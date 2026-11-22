; Pocket Camera Hello Kitty (Japan), bank $0E. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $00e", ROMX[$4000], BANK[$e]

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty*.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0E_4000_Mode05_StampWindow_State06::
    INCBIN "data/bank_0e/Gfx_0E_4000_Mode05_StampWindow_State06.2bpp" ; $4000, 10240 bytes
; C: named by the code of Mode06_State18, Mode06_State19 (01:7226 01:7283); read in the runs by Copy_DEtoHL; first
; read on the screen Mode14_MessageScreen_State01 (trace/read_screens_kitty*.npz); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_0E_6800_Mode06_Printing_State18::
    INCBIN "data/bank_0e/Gfx_0E_6800_Mode06_Printing_State18.2bpp" ; $6800, 6144 bytes
