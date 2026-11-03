; Game Boy Camera Gold (USA), bank $2E. Written by tools/make_source.py from roms/gold/gbcam_gold.sym and the tables of
; roms/gold/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $02e", ROMX[$4000], BANK[$2e]

; C: stamp category 6/7 (letters, set B): the stamp tiles, 64 bytes per stamp; block to 2E:6000, room for 128 stamps
; (an upper bound)
StampCat06_07_LettersB_Gfx::
    INCBIN "data/bank_2e/StampCat06_07_LettersB_Gfx.2bpp" ; $4000, 8192 bytes
; C: stamp category 12/13 (kanji): the stamp tiles, 64 bytes per stamp; block to 2E:8000, room for 128 stamps (an
; upper bound)
StampCat12_13_Kanji_Gfx::
    INCBIN "data/bank_2e/StampCat12_13_Kanji_Gfx.2bpp" ; $6000, 8192 bytes
