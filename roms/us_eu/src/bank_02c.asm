; Game Boy Camera (USA, Europe), bank $2C. Written by tools/make_source.py from roms/us_eu/gbcam_us.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $02c", ROMX[$4000], BANK[$2c]

; C: stamp category 0 (small face parts): the stamp tiles, 128 bytes per stamp; the block runs to the next set or name
; (2C:6000), room for 64 stamps (an upper bound)
StampCat00_SmallFace_Gfx::
    INCBIN "data/bank_2c/StampCat00_SmallFace_Gfx.2bpp" ; $4000, 8192 bytes
; C: stamp category 2 (Pokemon): the stamp tiles, 400 bytes per stamp; the block runs to the next set or name
; (2C:8000), room for 20 stamps (an upper bound); the set holds 6 stamps, drawn from the ROM: Charmander, Bulbasaur,
; Squirtle, Pikachu, Meowth, Mew
StampCat02_Pokemon_Gfx::
    INCBIN "data/bank_2c/StampCat02_Pokemon_Gfx.2bpp" ; $6000, 8192 bytes
