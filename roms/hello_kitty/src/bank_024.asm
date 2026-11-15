; Pocket Camera Hello Kitty (Japan), bank $24. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $024", ROMX[$4000], BANK[$24]

; C: read in the runs by Copy_Unrolled_B; first read on the screen Mode11_StrawberryChannel_State07
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_24_4000_Mode11_StrawberryChannel_State07::
    INCBIN "data/bank_24/Gfx_24_4000_Mode11_StrawberryChannel_State07.2bpp" ; $4000, 10752 bytes
; C: named by the code of Puzzle15_LoadGfx (07:5ACA); read in the runs by Copy_DEtoHL; first read on the screen
; Mode0F_FifteenPuzzle_State00 (trace/read_screens_kitty.npz); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_24_6A00_Puzzle15_LoadGfx::
    INCBIN "data/bank_24/Gfx_24_6A00_Puzzle15_LoadGfx.2bpp" ; $6A00, 448 bytes
; C: read in the runs by Copy_DEtoHL; first read on the screen Mode0F_FifteenPuzzle_State00
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_24_6BC0_Mode0F_FifteenPuzzle_State00::
    INCBIN "data/bank_24/Gfx_24_6BC0_Mode0F_FifteenPuzzle_State00.2bpp" ; $6BC0, 1088 bytes
; C: named by the code of Puzzle15_LoadGfx (07:5AD4); read in the runs by Copy_DEtoHL; first read on the screen
; Mode0F_FifteenPuzzle_State00 (trace/read_screens_kitty.npz); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_24_7000_Puzzle15_LoadGfx::
    INCBIN "data/bank_24/Gfx_24_7000_Puzzle15_LoadGfx.2bpp" ; $7000, 512 bytes
; C: named by the code of Puzzle15_LoadGfx (07:5ADE 07:5AE8); read in the runs by Copy_DEtoHL; first read on the
; screen Mode0F_FifteenPuzzle_State00 (trace/read_screens_kitty.npz); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_24_7200_Puzzle15_LoadGfx::
    INCBIN "data/bank_24/Gfx_24_7200_Puzzle15_LoadGfx.2bpp" ; $7200, 512 bytes
; C: named by the code of Mode00_State01 (05:40DF); read in the runs by Copy_DEtoHL, Vram_CopyHBlank; first read on
; the screen Mode02_TakePhotos_State08 (trace/read_screens_kitty.npz); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_24_7400_Mode00_BootAndTitle_State01::
    INCBIN "data/bank_24/Gfx_24_7400_Mode00_BootAndTitle_State01.2bpp" ; $7400, 3072 bytes
