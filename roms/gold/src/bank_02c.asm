; Game Boy Camera Gold (USA), bank $2C. Written by tools/make_source.py from roms/gold/gbcam_gold.sym and the tables of
; roms/gold/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $02c", ROMX[$4000], BANK[$2c]

; C: stamp category 0 (small face parts): the stamp tiles, 128 bytes per stamp; block to 2C:6000, room for 64 stamps
; (an upper bound)
StampCat00_SmallFace_Gfx::
    INCBIN "data/bank_2c/StampCat00_SmallFace_Gfx.2bpp" ; $4000, 8192 bytes
; C: stamp category 2 (Zelda: Ocarina of Time items (eyes, elf ears, Triforce, Navi; 6 stamps) in place of the 6
; Pokemon of the international ROM): the stamp tiles, 400 bytes per stamp; block to 2C:8000 (6 stamps)
StampCat02_ZeldaSmall_Gfx::
    INCBIN "data/bank_2c/StampCat02_ZeldaSmall_Gfx.2bpp" ; $6000, 8192 bytes
