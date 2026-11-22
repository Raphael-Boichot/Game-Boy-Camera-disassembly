; Pocket Camera Hello Kitty (Japan), bank $32. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $032", ROMX[$4000], BANK[$32]

; C: read in the runs by Copy_Unrolled_B; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty.npz); kind T_FRM from the evidence of tools/kitty_layout_kinds.py
Frame_32_4000_Mode02_TakePhotos_State01::
    INCBIN "data/bank_32/Frame_32_4000_Mode02_TakePhotos_State01.bin" ; $4000, 14336 bytes
; C: named by the code of Mode1B_State00 (07:40AD); read in the runs by Vram_CopyHBlank; kind MAP from the evidence of
; tools/kitty_layout_kinds.py
Map_32_7800_Mode1B_PrintingAppleGame_State00::
    INCBIN "data/bank_32/Map_32_7800_Mode1B_PrintingAppleGame_State00.tilemap" ; $7800, 576 bytes
; C: named by the code of Mode0A_State00 (06:563A); read in the runs by Copy_DEtoHL; first read on the screen
; Mode0A_NameCard_State00 (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_32_7A40_Mode0A_NameCard_State00::
    INCBIN "data/bank_32/Map_32_7A40_Mode0A_NameCard_State00.tilemap" ; $7A40, 576 bytes
; C: named by the code of Mode09_State03, Exchange_InitScreen (06:685A 06:6A08); read in the runs by Copy_DEtoHL; read
; in BGB by a read watchpoint (trace/bgb_reads_kitty.csv: exchange); kind MAP from the evidence of
; tools/kitty_layout_kinds.py
Map_32_7C80_Mode09_ExchangeCommunicating_State03::
    INCBIN "data/bank_32/Map_32_7C80_Mode09_ExchangeCommunicating_State03.tilemap" ; $7C80, 576 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode02_TakePhotos_State08
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py; the rest of Map_32_7C80
; after a leftover stretch
Gfx_32_7EC0_Mode02_TakePhotos_State08::
    INCBIN "data/bank_32/Gfx_32_7EC0_Mode02_TakePhotos_State08.2bpp" ; $7EC0, 320 bytes
