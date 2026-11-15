; Pocket Camera Hello Kitty (Japan), bank $15. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $015", ROMX[$4000], BANK[$15]

; C: read in the runs by Copy_DEtoHL; first read on the screen Mode03_ViewAlbum_State00
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_15_4000_Mode03_ViewAlbum_State00::
    INCBIN "data/bank_15/Gfx_15_4000_Mode03_ViewAlbum_State00.2bpp" ; $4000, 1216 bytes
; C: named by the code of Album_LoadTilesBank15 (05:6F53); read in the runs by Copy_DEtoHL; first read on the screen
; Mode03_ViewAlbum_State00 (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_15_44C0_Album_LoadTilesBank15::
    INCBIN "data/bank_15/Gfx_15_44C0_Album_LoadTilesBank15.2bpp" ; $44C0, 192 bytes
; C: named by the code of Album_LoadTilesBank15 (05:6F61); read in the runs by Copy_DEtoHL; first read on the screen
; Mode03_ViewAlbum_State00 (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_15_4580_Album_LoadTilesBank15::
    INCBIN "data/bank_15/Gfx_15_4580_Album_LoadTilesBank15.2bpp" ; $4580, 192 bytes
; C: named by the code of Album_LoadTilesBank15 (05:6F6C); read in the runs by Copy_DEtoHL; first read on the screen
; Mode03_ViewAlbum_State00 (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_15_4640_Album_LoadTilesBank15::
    INCBIN "data/bank_15/Gfx_15_4640_Album_LoadTilesBank15.2bpp" ; $4640, 2496 bytes
; C: read in the runs by Copy_DEtoHL; first read on the screen Mode03_ViewAlbum_State02
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_15_5000_Mode03_ViewAlbum_State02::
    INCBIN "data/bank_15/Gfx_15_5000_Mode03_ViewAlbum_State02.2bpp" ; $5000, 896 bytes
; C: read in the runs by Copy_DEtoHL; first read on the screen Mode03_ViewAlbum_State02
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_15_5380_Mode03_ViewAlbum_State02::
    INCBIN "data/bank_15/Gfx_15_5380_Mode03_ViewAlbum_State02.2bpp" ; $5380, 192 bytes
; C: named by the code of Album_LoadTilesBank15 (05:6F3D); read in the runs by Copy_DEtoHL; first read on the screen
; Mode03_ViewAlbum_State02 (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_15_5440_Album_LoadTilesBank15::
    INCBIN "data/bank_15/Gfx_15_5440_Album_LoadTilesBank15.2bpp" ; $5440, 192 bytes
; C: named by the code of Album_LoadTilesBank15 (05:6F48); read in the runs by Copy_DEtoHL; first read on the screen
; Mode03_ViewAlbum_State02 (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_15_5500_Album_LoadTilesBank15::
    INCBIN "data/bank_15/Gfx_15_5500_Album_LoadTilesBank15.2bpp" ; $5500, 768 bytes
; C: read in the runs by Copy_DEtoHL; first read on the screen Mode00_BootAndTitle_State00
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_15_5800_Mode00_BootAndTitle_State00::
    INCBIN "data/bank_15/Gfx_15_5800_Mode00_BootAndTitle_State00.2bpp" ; $5800, 6144 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode03_ViewAlbum_State03
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py; the rest of Gfx_15_5800
; after a leftover stretch
Map_15_7000_Mode03_ViewAlbum_State03::
    INCBIN "data/bank_15/Map_15_7000_Mode03_ViewAlbum_State03.tilemap" ; $7000, 1024 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode03_ViewAlbum_State03
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_15_7400_Mode03_ViewAlbum_State03::
    INCBIN "data/bank_15/Map_15_7400_Mode03_ViewAlbum_State03.tilemap" ; $7400, 1024 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode03_ViewAlbum_State03
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_15_7800_Mode03_ViewAlbum_State03::
    INCBIN "data/bank_15/Map_15_7800_Mode03_ViewAlbum_State03.tilemap" ; $7800, 1024 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode03_ViewAlbum_State03
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_15_7C00_Mode03_ViewAlbum_State03::
    INCBIN "data/bank_15/Map_15_7C00_Mode03_ViewAlbum_State03.tilemap" ; $7C00, 1024 bytes
