; Pocket Camera Hello Kitty (Japan), bank $0B. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $00b", ROMX[$4000], BANK[$b]

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_0B_4000_Mode05_StampWindow_State06::
    INCBIN "data/bank_0b/Gfx_0B_4000_Mode05_StampWindow_State06.2bpp" ; $4000, 16128 bytes
; C: named by the code of Mode0A_State00, Print_LoadItemPicture (06:5626 01:69AA); read in the runs by Copy_DEtoHL;
; first read on the screen Mode0A_NameCard_State00 (trace/read_screens_kitty.npz); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_0B_7F00_Mode0A_NameCard_State00::
    INCBIN "data/bank_0b/Gfx_0B_7F00_Mode0A_NameCard_State00.2bpp" ; $7F00, 256 bytes
