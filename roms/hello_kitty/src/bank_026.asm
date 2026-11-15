; Pocket Camera Hello Kitty (Japan), bank $26. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $026", ROMX[$4000], BANK[$26]

; C: read in the runs by Copy_Unrolled_B; first read on the screen Mode11_StrawberryChannel_State07
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_26_4000_Mode11_StrawberryChannel_State07::
    INCBIN "data/bank_26/Gfx_26_4000_Mode11_StrawberryChannel_State07.2bpp" ; $4000, 7168 bytes
; C: named by the code of Mode03_State0A, Print_LoadFrameGfx (05:6614 01:6969); read in the runs by Copy_DEtoHL; first
; read on the screen Mode03_ViewAlbum_State0B (trace/read_screens_kitty.npz); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_26_5C00_Mode03_ViewAlbum_State0A::
    INCBIN "data/bank_26/Gfx_26_5C00_Mode03_ViewAlbum_State0A.2bpp" ; $5C00, 2304 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode01_MainMenu_State05
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py; the rest of Data_26_5C00
; after a leftover stretch
Map_26_6500_Mode01_MainMenu_State05::
    INCBIN "data/bank_26/Map_26_6500_Mode01_MainMenu_State05.tilemap" ; $6500, 1280 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode01_MainMenu_State05
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_26_6A00_Mode01_MainMenu_State05::
    INCBIN "data/bank_26/Map_26_6A00_Mode01_MainMenu_State05.tilemap" ; $6A00, 384 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode0A_NameCard_State01
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py; the rest of Map_26_6A00
; after a leftover stretch
Gfx_26_6B80_Mode0A_NameCard_State01::
    INCBIN "data/bank_26/Gfx_26_6B80_Mode0A_NameCard_State01.2bpp" ; $6B80, 1632 bytes
; C: named by the code of Mode07_State00 (06:61B9); read in the runs by Copy_DEtoHL; first read on the screen
; Mode07_Exchange_State02 (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_26_71E0_Mode07_Exchange_State00::
    INCBIN "data/bank_26/Map_26_71E0_Mode07_Exchange_State00.tilemap" ; $71E0, 1024 bytes
; C: named by the code of Mode07_State00 (06:61C3); read in the runs by Copy_DEtoHL; first read on the screen
; Mode07_Exchange_State02 (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_26_75E0_Mode07_Exchange_State00::
    INCBIN "data/bank_26/Map_26_75E0_Mode07_Exchange_State00.tilemap" ; $75E0, 576 bytes
; C: named by the code of Puzzle15_LoadGfx (07:5AF2); read in the runs by Copy_DEtoHL; first read on the screen
; Mode0F_FifteenPuzzle_State00 (trace/read_screens_kitty.npz); kind MAP from the evidence of
; tools/kitty_layout_kinds.py
Map_26_7820_Puzzle15_LoadGfx::
    INCBIN "data/bank_26/Map_26_7820_Puzzle15_LoadGfx.tilemap" ; $7820, 32 bytes
; C: read in the runs by Copy_DEtoHL; first read on the screen Mode0F_FifteenPuzzle_State00
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_26_7840_Mode0F_FifteenPuzzle_State00::
    INCBIN "data/bank_26/Map_26_7840_Mode0F_FifteenPuzzle_State00.tilemap" ; $7840, 544 bytes
; I: leftover: 448 bytes (26:7A60-7C1F) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_26_7A60::
    INCBIN "data/bank_26/Leftover_26_7A60.bin" ; $7A60, 448 bytes
; C: read in the runs by Map_CopyColumnToD810, Map_CopyRect, Vram_CopyHBlank; first read on the screen
; Mode0A_NameCard_State01 (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_26_7C20_Mode0A_NameCard_State01::
    INCBIN "data/bank_26/Map_26_7C20_Mode0A_NameCard_State01.tilemap" ; $7C20, 992 bytes
