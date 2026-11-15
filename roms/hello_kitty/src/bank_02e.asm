; Pocket Camera Hello Kitty (Japan), bank $2E. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $02e", ROMX[$4000], BANK[$2e]

; C: read in the runs by Copy_Unrolled_B; first read on the screen Mode11_StrawberryChannel_State07
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_2E_4000_Mode11_StrawberryChannel_State07::
    INCBIN "data/bank_2e/Gfx_2E_4000_Mode11_StrawberryChannel_State07.bin" ; $4000, 10782 bytes
; C: read in the runs by Copy_Unrolled_B; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty.npz); kind T_FRM from the evidence of tools/kitty_layout_kinds.py; the rest of
; Data_2E_4000 after a leftover stretch
Frame_2E_6A1E_Mode02_TakePhotos_State01::
    INCBIN "data/bank_2e/Frame_2E_6A1E_Mode02_TakePhotos_State01.bin" ; $6A1E, 3554 bytes
; C: map of the Pompompurin picture copied to $9800 by Unused_Mode18_State00 (06:413D, 1,024 bytes); no other loader
Map_2E_7800_PompompurinPicture::
    INCBIN "data/bank_2e/Map_2E_7800_PompompurinPicture.tilemap" ; $7800, 1024 bytes
; C: named by the code of Mode00_State06 (05:4283); read in the runs by Copy_DEtoHL; first read on the screen
; Mode00_BootAndTitle_State00 (trace/read_screens_kitty.npz); kind MAP from the evidence of
; tools/kitty_layout_kinds.py
Map_2E_7C00_Mode00_BootAndTitle_State06::
    INCBIN "data/bank_2e/Map_2E_7C00_Mode00_BootAndTitle_State06.tilemap" ; $7C00, 128 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode00_BootAndTitle_State00
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_2E_7C80_Mode00_BootAndTitle_State00::
    INCBIN "data/bank_2e/Map_2E_7C80_Mode00_BootAndTitle_State00.tilemap" ; $7C80, 448 bytes
; C: named by the code of Mode00_State06 (05:428D); read in the runs by Copy_DEtoHL; first read on the screen
; Mode00_BootAndTitle_State00 (trace/read_screens_kitty.npz); kind MAP from the evidence of
; tools/kitty_layout_kinds.py
Map_2E_7E40_Mode00_BootAndTitle_State06::
    INCBIN "data/bank_2e/Map_2E_7E40_Mode00_BootAndTitle_State06.tilemap" ; $7E40, 448 bytes
