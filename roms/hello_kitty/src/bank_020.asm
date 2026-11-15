; Pocket Camera Hello Kitty (Japan), bank $20. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $020", ROMX[$4000], BANK[$20]

; C: named by the code of IdCard_NameGlyphAddr (06:4C3A); read in the runs by Copy_Unrolled_B; first read on the
; screen Mode11_StrawberryChannel_State07 (trace/read_screens_kitty.npz); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_20_4000_IdCard_NameGlyphAddr::
    INCBIN "data/bank_20/Gfx_20_4000_IdCard_NameGlyphAddr.2bpp" ; $4000, 14336 bytes
; C: read in the runs by Copy_DEtoHL; first read on the screen Mode06_Printing_State02 (trace/read_screens_kitty.npz);
; kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_20_7800_Mode06_Printing_State02::
    INCBIN "data/bank_20/Map_20_7800_Mode06_Printing_State02.tilemap" ; $7800, 96 bytes
; C: named by the code of Mode06_State0F (01:6F09); read in the runs by Vram_CopyHBlank, Copy_DEtoHL; first read on
; the screen Mode06_Printing_State05 (trace/read_screens_kitty.npz); kind MAP from the evidence of
; tools/kitty_layout_kinds.py
Map_20_7860_Mode06_Printing_State0F::
    INCBIN "data/bank_20/Map_20_7860_Mode06_Printing_State0F.tilemap" ; $7860, 512 bytes
; C: named by the code of Mode06_State02, Mode06_State0F (01:6BA4 01:6F17); read in the runs by Copy_DEtoHL; first
; read on the screen Mode06_Printing_State02 (trace/read_screens_kitty.npz); kind MAP from the evidence of
; tools/kitty_layout_kinds.py
Map_20_7A60_Mode06_Printing_State02::
    INCBIN "data/bank_20/Map_20_7A60_Mode06_Printing_State02.tilemap" ; $7A60, 288 bytes
; I: leftover: 128 bytes (20:7B80-7BFF) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_20_7B80::
    db $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f
    db $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f
    db $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f
    db $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f
    db $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f
    db $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f
    db $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f
    db $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f

; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode06_Printing_State07
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_20_7C00_Mode06_Printing_State07::
    INCBIN "data/bank_20/Map_20_7C00_Mode06_Printing_State07.tilemap" ; $7C00, 1024 bytes
