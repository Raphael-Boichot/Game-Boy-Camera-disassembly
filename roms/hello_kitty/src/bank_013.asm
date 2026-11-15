; Pocket Camera Hello Kitty (Japan), bank $13. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $013", ROMX[$4000], BANK[$13]

; C: named by the code of Sram_Format (01:49B7); read in the runs by Copy_DEtoHL; first read on the screen
; Mode05_StampWindow_State06 (trace/read_screens_kitty.npz); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_13_4000_Sram_Format::
    INCBIN "data/bank_13/Gfx_13_4000_Sram_Format.2bpp" ; $4000, 8064 bytes
; C: named by the code of KittHost_InitScreen (07:675B); read in the runs by Copy_DEtoHL; first read on the screen
; Mode0E_KittGamesHost_State03 (trace/read_screens_kitty.npz); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_13_5F80_KittHost_InitScreen::
    INCBIN "data/bank_13/Gfx_13_5F80_KittHost_InitScreen.2bpp" ; $5F80, 6144 bytes
; C: named by the code of Mode0E_State01 (07:67C1); read in the runs by Copy_DEtoHL; first read on the screen
; Mode0E_KittGamesHost_State03 (trace/read_screens_kitty.npz); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_13_7780_Mode0E_KittGamesHost_State01::
    INCBIN "data/bank_13/Gfx_13_7780_Mode0E_KittGamesHost_State01.2bpp" ; $7780, 896 bytes
; C: named by the code of Mode10_State00, Mode10_State01 (07:60B5 07:613A); read in the runs by Copy_DEtoHL,
; Vram_CopyHBlank; first read on the screen Mode10_ScratchCard_State02 (trace/read_screens_kitty.npz); kind MAP from
; the evidence of tools/kitty_layout_kinds.py
Map_13_7B00_Mode10_ScratchCard_State00::
    INCBIN "data/bank_13/Map_13_7B00_Mode10_ScratchCard_State00.tilemap" ; $7B00, 628 bytes
; I: leftover: 396 bytes (13:7D74-7EFF) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_13_7D74::
    INCBIN "data/bank_13/Leftover_13_7D74.bin" ; $7D74, 396 bytes
; C: read in the runs by Map_CopyRect; first read on the screen Mode10_ScratchCard_State02
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_13_7F00_Mode10_ScratchCard_State02::
    INCBIN "data/bank_13/Map_13_7F00_Mode10_ScratchCard_State02.tilemap" ; $7F00, 64 bytes
; C: read in the runs by Map_CopyRect; first read on the screen Mode10_ScratchCard_State02
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_13_7F40_Mode10_ScratchCard_State02::
    INCBIN "data/bank_13/Map_13_7F40_Mode10_ScratchCard_State02.tilemap" ; $7F40, 64 bytes
; C: read in the runs by Map_CopyRect; first read on the screen Mode10_ScratchCard_State02
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_13_7F80_Mode10_ScratchCard_State02::
    INCBIN "data/bank_13/Map_13_7F80_Mode10_ScratchCard_State02.tilemap" ; $7F80, 35 bytes
; I: leftover: 93 bytes (13:7FA3-7FFF) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_13_7FA3::
    db $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7
    db $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $5d, $5e, $5f
    db $60, $61, $62, $63, $64, $65, $66, $67, $68, $69, $6a, $6b, $6c, $6d, $6e, $6f
    db $70, $71, $72, $73, $74, $75, $76, $77, $78, $79, $7a, $b3, $b4, $b4, $b5, $b6
    db $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7
    db $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7
