; Pocket Camera Hello Kitty (Japan), bank $25. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $025", ROMX[$4000], BANK[$25]

; C: read in the runs by Copy_Unrolled_B; first read on the screen Mode11_StrawberryChannel_State07
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_25_4000_Mode11_StrawberryChannel_State07::
    INCBIN "data/bank_25/Gfx_25_4000_Mode11_StrawberryChannel_State07.2bpp" ; $4000, 7168 bytes
; C: named by the code of Mode11_State00, Mode11_State0A (07:4F9B 07:51EA); read in the runs by Copy_DEtoHL; first
; read on the screen Mode11_StrawberryChannel_State00 (trace/read_screens_kitty.npz); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_25_5C00_Mode11_StrawberryChannel_State00::
    INCBIN "data/bank_25/Gfx_25_5C00_Mode11_StrawberryChannel_State00.2bpp" ; $5C00, 2032 bytes
; C: read in the runs by Copy_DEtoHL; first read on the screen Mode11_StrawberryChannel_State00
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_25_63F0_Mode11_StrawberryChannel_State00::
    INCBIN "data/bank_25/Gfx_25_63F0_Mode11_StrawberryChannel_State00.2bpp" ; $63F0, 528 bytes
; C: named by the code of Mode05_State00 (05:5FE0); read in the runs by Copy_DEtoHL; first read on the screen
; Mode05_StampWindow_State00 (trace/read_screens_kitty.npz); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_25_6600_Mode05_StampWindow_State00::
    INCBIN "data/bank_25/Gfx_25_6600_Mode05_StampWindow_State00.2bpp" ; $6600, 512 bytes
; C: read in the runs by Copy_DEtoHL; first read on the screen Mode05_StampWindow_State00
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_25_6800_Mode05_StampWindow_State00::
    INCBIN "data/bank_25/Gfx_25_6800_Mode05_StampWindow_State00.2bpp" ; $6800, 2048 bytes
; C: named by the code of Mode0C_State00 (06:5CF3); read in the runs by Copy_DEtoHL; first read on the screen
; Mode0C_RecordBook_State01 (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_25_7000_Mode0C_RecordBook_State00::
    INCBIN "data/bank_25/Gfx_25_7000_Mode0C_RecordBook_State00.2bpp" ; $7000, 2304 bytes
; C: named by the code of Mode12_State00 (07:48DE); read in the runs by Copy_DEtoHL, Map_CopyRect, Vram_CopyHBlank;
; first read on the screen Mode12_SlideShow_State01 (trace/read_screens_kitty.npz); kind MAP from the evidence of
; tools/kitty_layout_kinds.py
Map_25_7900_Mode12_SlideShow_State00::
    INCBIN "data/bank_25/Map_25_7900_Mode12_SlideShow_State00.tilemap" ; $7900, 1024 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode12_SlideShow_State01
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_25_7D00_Mode12_SlideShow_State01::
    INCBIN "data/bank_25/Map_25_7D00_Mode12_SlideShow_State01.tilemap" ; $7D00, 768 bytes
