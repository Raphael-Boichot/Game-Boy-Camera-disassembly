; Pocket Camera Hello Kitty (Japan), bank $2F. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $02f", ROMX[$4000], BANK[$2f]

; C: read in the runs by Copy_Unrolled_B; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty.npz); kind T_FRM from the evidence of tools/kitty_layout_kinds.py
Frame_2F_4000_Mode02_TakePhotos_State01::
    INCBIN "data/bank_2f/Frame_2F_4000_Mode02_TakePhotos_State01.bin" ; $4000, 7168 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode02_TakePhotos_State08
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py; the rest of Data_2F_4000
; after a leftover stretch
Gfx_2F_5C00_Mode02_TakePhotos_State08::
    INCBIN "data/bank_2f/Gfx_2F_5C00_Mode02_TakePhotos_State08.bin" ; $5C00, 1505 bytes
; I: leftover: 511 bytes (2F:61E1-63DF) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_2F_61E1::
    INCBIN "data/bank_2f/Leftover_2F_61E1.bin" ; $61E1, 511 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_2F_63E0_Mode02_TakePhotos_State01::
    INCBIN "data/bank_2f/Gfx_2F_63E0_Mode02_TakePhotos_State01.2bpp" ; $63E0, 976 bytes
; C: named by the code of Mode06_State18, Mode06_State19 (01:7230 01:728D); read in the runs by Copy_DEtoHL; first
; read on the screen Mode14_MessageScreen_State01 (trace/read_screens_kitty.npz); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_2F_67B0_Mode06_Printing_State18::
    INCBIN "data/bank_2f/Gfx_2F_67B0_Mode06_Printing_State18.2bpp" ; $67B0, 448 bytes
; C: named by the code of Mode06_State18, Mode06_State19 (01:7252 01:72AF); read in the runs by Copy_DEtoHL; first
; read on the screen Mode14_MessageScreen_State01 (trace/read_screens_kitty.npz); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_2F_6970_Mode06_Printing_State18::
    INCBIN "data/bank_2f/Gfx_2F_6970_Mode06_Printing_State18.2bpp" ; $6970, 80 bytes
; C: read in the runs by Copy_DEtoHL; first read on the screen Mode14_MessageScreen_State01
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py; the rest of Map_2F_6970
; after a leftover stretch
Map_2F_69C0_Mode14_MessageScreen_State01::
    INCBIN "data/bank_2f/Map_2F_69C0_Mode14_MessageScreen_State01.tilemap" ; $69C0, 48 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode06_Printing_State1F
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py; the rest of Map_2F_6970
; after a leftover stretch
Gfx_2F_69F0_Mode06_Printing_State1F::
    INCBIN "data/bank_2f/Gfx_2F_69F0_Mode06_Printing_State1F.2bpp" ; $69F0, 32 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode06_Printing_State1F
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py; the rest of Map_2F_6970
; after a leftover stretch
Map_2F_6A10_Mode06_Printing_State1F::
    INCBIN "data/bank_2f/Map_2F_6A10_Mode06_Printing_State1F.tilemap" ; $6A10, 96 bytes
; C: named by the code of Mode06_State18, Mode06_State19 (01:7246 01:72A3); read in the runs by Copy_DEtoHL; kind MAP
; from the evidence of tools/kitty_layout_kinds.py
Map_2F_6A70_Mode06_Printing_State18::
    INCBIN "data/bank_2f/Map_2F_6A70_Mode06_Printing_State18.tilemap" ; $6A70, 256 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode0A_NameCard_State01
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_2F_6B70_Mode0A_NameCard_State01::
    INCBIN "data/bank_2f/Gfx_2F_6B70_Mode0A_NameCard_State01.2bpp" ; $6B70, 5264 bytes
