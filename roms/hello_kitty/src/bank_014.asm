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
    INCBIN "data/bank_14/Map_14_7000_Mode02_TakePhotos_State08.tilemap" ; $7000, 1024 bytes
; I: leftover: 1024 bytes (14:7400-77FF), a BG map of 32 x 32, rows 4-17 holding tile numbers $00-$7F then $00-$5F in
; columns 4-19, by its layout (rows of 32 bytes, 20 columns used, the rest $FF: tile number 255, the $FF runs are map
; data, owner 2026-11-22); no run reads it and no code names it
Leftover_14_7400_Map::
    INCBIN "data/bank_14/Leftover_14_7400_Map.tilemap" ; $7400, 1024 bytes
; I: leftover: 1024 bytes (14:7800-7BFF) all $FF, the place of a BG map of 32 x 32 as in banks $15 and $19 (an empty
; map: tile number 255 everywhere); no run reads it and no code names it
Leftover_14_7800_Map::
    INCBIN "data/bank_14/Leftover_14_7800_Map.tilemap" ; $7800, 1024 bytes
; I: leftover: 1024 bytes (14:7C00-7FFF) all $FF, the place of a BG map of 32 x 32 as in banks $15 and $19 (an empty
; map: tile number 255 everywhere); no run reads it and no code names it
Leftover_14_7C00_Map::
    INCBIN "data/bank_14/Leftover_14_7C00_Map.tilemap" ; $7C00, 1024 bytes
