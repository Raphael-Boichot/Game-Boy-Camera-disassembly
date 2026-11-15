; Pocket Camera Hello Kitty (Japan), bank $22. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $022", ROMX[$4000], BANK[$22]

; C: read in the runs by Copy_Unrolled_B; first read on the screen Mode11_StrawberryChannel_State07
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_22_4000_Mode11_StrawberryChannel_State07::
    INCBIN "data/bank_22/Gfx_22_4000_Mode11_StrawberryChannel_State07.2bpp" ; $4000, 3584 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode03_ViewAlbum_State13
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py; the rest of Data_22_4000
; after a leftover stretch
Map_22_4E00_Mode03_ViewAlbum_State13::
    INCBIN "data/bank_22/Map_22_4E00_Mode03_ViewAlbum_State13.tilemap" ; $4E00, 3136 bytes
; C: named by the code of Mode03_State00, Mode03_State01 (05:6FAE 05:70EB); read in the runs by Copy_DEtoHL; first
; read on the screen Mode03_ViewAlbum_State02 (trace/read_screens_kitty.npz); kind MAP from the evidence of
; tools/kitty_layout_kinds.py
Map_22_5A40_Mode03_ViewAlbum_State00::
    INCBIN "data/bank_22/Map_22_5A40_Mode03_ViewAlbum_State00.tilemap" ; $5A40, 1024 bytes
; C: named by the code of Mode03_State01, Mode03_State00 (05:70D1 05:6FBA 05:70F7); read in the runs by Copy_DEtoHL;
; first read on the screen Mode03_ViewAlbum_State00 (trace/read_screens_kitty.npz); kind MAP from the evidence of
; tools/kitty_layout_kinds.py
Map_22_5E40_Mode03_ViewAlbum_State01::
    INCBIN "data/bank_22/Map_22_5E40_Mode03_ViewAlbum_State01.tilemap" ; $5E40, 1024 bytes
; C: named by the code of Mode03_State00, Mode03_State01 (05:6F9B 05:70DB); read in the runs by Copy_DEtoHL,
; Vram_CopyHBlank; first read on the screen Mode03_ViewAlbum_State02 (trace/read_screens_kitty.npz); kind T_UI from
; the evidence of tools/kitty_layout_kinds.py
Gfx_22_6240_Mode03_ViewAlbum_State00::
    INCBIN "data/bank_22/Gfx_22_6240_Mode03_ViewAlbum_State00.2bpp" ; $6240, 1552 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py; the rest of Map_22_6240
; after a leftover stretch
Gfx_22_6850_Mode05_StampWindow_State06::
    INCBIN "data/bank_22/Gfx_22_6850_Mode05_StampWindow_State06.2bpp" ; $6850, 2544 bytes
; C: named by the code of NameCardEdit_RedrawScreen (06:5098); read in the runs by Copy_DEtoHL; first read on the
; screen Mode0B_NameCardEdit_State10 (trace/read_screens_kitty.npz); kind MAP from the evidence of
; tools/kitty_layout_kinds.py
Map_22_7240_NameCardEdit_RedrawScreen::
    INCBIN "data/bank_22/Map_22_7240_NameCardEdit_RedrawScreen.tilemap" ; $7240, 1024 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode0B_NameCardEdit_State04
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_22_7640_Mode0B_NameCardEdit_State04::
    INCBIN "data/bank_22/Map_22_7640_Mode0B_NameCardEdit_State04.tilemap" ; $7640, 352 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode0B_NameCardEdit_State0E
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_22_77A0_Mode0B_NameCardEdit_State0E::
    INCBIN "data/bank_22/Map_22_77A0_Mode0B_NameCardEdit_State0E.tilemap" ; $77A0, 672 bytes
; C: named by the code of Mode0B_State03 (06:5278); read in the runs by Vram_CopyHBlank; first read on the screen
; Mode0B_NameCardEdit_State04 (trace/read_screens_kitty.npz); kind MAP from the evidence of
; tools/kitty_layout_kinds.py
Map_22_7A40_Mode0B_NameCardEdit_State03::
    INCBIN "data/bank_22/Map_22_7A40_Mode0B_NameCardEdit_State03.tilemap" ; $7A40, 256 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode0B_NameCardEdit_State08
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_22_7B40_Mode0B_NameCardEdit_State08::
    INCBIN "data/bank_22/Map_22_7B40_Mode0B_NameCardEdit_State08.tilemap" ; $7B40, 256 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode0B_NameCardEdit_State0C
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_22_7C40_Mode0B_NameCardEdit_State0C::
    INCBIN "data/bank_22/Map_22_7C40_Mode0B_NameCardEdit_State0C.tilemap" ; $7C40, 256 bytes
; C: read in the runs by Vram_CopyHBlank, Map_CopyColumnToD810; first read on the screen Mode0B_NameCardEdit_State0A
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_22_7D40_Mode0B_NameCardEdit_State0A::
    INCBIN "data/bank_22/Map_22_7D40_Mode0B_NameCardEdit_State0A.tilemap" ; $7D40, 672 bytes
; I: leftover: 32 bytes (22:7FE0-7FFF) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_22_7FE0::
    db $a8, $a8, $a8, $a8, $a8, $a8, $a8, $a8, $a8, $a8, $a8, $a8, $a8, $a8, $a8, $a8
    db $a8, $a8, $a8, $a8, $a8, $a8, $a8, $a8, $a8, $a8, $a8, $a8, $a8, $a8, $a8, $a8
