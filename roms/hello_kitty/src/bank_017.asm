; Pocket Camera Hello Kitty (Japan), bank $17. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $017", ROMX[$4000], BANK[$17]

; C: named by the code of Photos_LoadPage8 (01:4F54); read in the runs by Copy_DEtoHL; first read on the screen
; Mode0B_NameCardEdit_State0F (trace/read_screens_kitty*.npz); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_17_4000_Photos_LoadPage8::
    INCBIN "data/bank_17/Gfx_17_4000_Photos_LoadPage8.2bpp" ; $4000, 6144 bytes
; C: read in the runs by Copy_DEtoHL; first read on the screen Mode01_MainMenu_State00
; (trace/read_screens_kitty*.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_17_5800_Mode01_MainMenu_State00::
    INCBIN "data/bank_17/Gfx_17_5800_Mode01_MainMenu_State00.2bpp" ; $5800, 6144 bytes
; C: named by the code of Mode08_State00 (06:65DF); read in the runs by Copy_DEtoHL; first read on the screen
; Mode08_ExchangePhotoTrain_State00 (trace/read_screens_kitty*.npz); read in BGB by a read watchpoint
; (trace/bgb_reads_kitty.csv: exchange); kind T_UI from the evidence of ...
Gfx_17_7000_Mode08_ExchangePhotoTrain_State00::
    INCBIN "data/bank_17/Gfx_17_7000_Mode08_ExchangePhotoTrain_State00.2bpp" ; $7000, 2048 bytes
; C: read in the runs by Copy_DEtoHL, Copy_Unrolled; first read on the screen Mode08_ExchangePhotoTrain_State00
; (trace/read_screens_kitty*.npz); read in BGB by a read watchpoint (trace/bgb_reads_kitty.csv: exchange); kind T_UI
; from the evidence of tools/kitty_layout_kinds.py
Gfx_17_7800_Mode08_ExchangePhotoTrain_State00::
    INCBIN "data/bank_17/Gfx_17_7800_Mode08_ExchangePhotoTrain_State00.2bpp" ; $7800, 2048 bytes
