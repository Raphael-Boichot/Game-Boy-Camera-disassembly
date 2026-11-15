; Pocket Camera Hello Kitty (Japan), bank $14. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $014", ROMX[$4000], BANK[$14]

; I: read in the runs by Copy_DEtoHL; kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_14_4000_Copy_DEtoHL::
    INCBIN "data/bank_14/Gfx_14_4000_Copy_DEtoHL.2bpp" ; $4000, 6144 bytes
; C: tiles of the Pompompurin picture copied to $8000 by Unused_Mode18_State00 (06:4133, 6,144 bytes); no other loader
Gfx_14_5800_PompompurinPicture::
    INCBIN "data/bank_14/Gfx_14_5800_PompompurinPicture.2bpp" ; $5800, 6144 bytes
; C: read in the runs by Vram_CopyHBlank; first read on the screen Mode02_TakePhotos_State08
; (trace/read_screens_kitty.npz); kind MAP from the evidence of tools/kitty_layout_kinds.py
Map_14_7000_Mode02_TakePhotos_State08::
    INCBIN "data/bank_14/Map_14_7000_Mode02_TakePhotos_State08.tilemap" ; $7000, 1155 bytes
; I: leftover: 2941 bytes (14:7483-7FFF) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_14_7483::
    INCBIN "data/bank_14/Leftover_14_7483.bin" ; $7483, 2941 bytes
