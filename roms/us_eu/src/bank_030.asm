; Game Boy Camera (USA, Europe), bank $30. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $030", ROMX[$4000], BANK[$30]

; C: stamp category 10/11 (letters, set D): the stamp tiles, 64 bytes per stamp; the block runs to the next set or
; name (30:6000), room for 128 stamps (an upper bound)
StampCat10_11_LettersD_Gfx::
    INCBIN "data/bank_30/StampCat10_11_LettersD_Gfx.2bpp" ; $4000, 8192 bytes
; C: stamp category 8/9 (letters, set C): the stamp tiles, 64 bytes per stamp; the block runs to the next set or name
; (30:8000), room for 128 stamps (an upper bound)
StampCat08_09_LettersC_Gfx::
    INCBIN "data/bank_30/StampCat08_09_LettersC_Gfx.2bpp" ; $6000, 8192 bytes
