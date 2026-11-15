; Pocket Camera Hello Kitty (Japan), bank $27. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $027", ROMX[$4000], BANK[$27]

; C: read in the runs by Copy_Unrolled_B, Copy_DEtoHL; first read on the screen Mode11_StrawberryChannel_State07
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_27_4000_Mode11_StrawberryChannel_State07::
    INCBIN "data/bank_27/Gfx_27_4000_Mode11_StrawberryChannel_State07.bin" ; $4000, 12308 bytes
; I: leftover: 1484 bytes (27:7014-75DF) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_27_7014::
    INCBIN "data/bank_27/Leftover_27_7014.bin" ; $7014, 1484 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode0A_NameCard_State03
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_27_75E0_Mode0A_NameCard_State03::
    INCBIN "data/bank_27/Gfx_27_75E0_Mode0A_NameCard_State03.2bpp" ; $75E0, 2592 bytes
