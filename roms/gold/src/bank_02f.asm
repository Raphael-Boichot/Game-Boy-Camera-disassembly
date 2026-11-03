; Game Boy Camera Gold (USA), bank $2F. Written by tools/make_source.py from roms/gold/gbcam_gold.sym and the tables of
; roms/gold/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $02f", ROMX[$4000], BANK[$2f]

; C: stamp category 1 (big stamps): the 1bpp masks, 128 bytes per stamp; block to 2F:5800, room for 48 stamps (an
; upper bound)
StampCat01_BigStamps_Mask::
    INCBIN "data/bank_2f/StampCat01_BigStamps_Mask.bin" ; $4000, 6144 bytes
; C: stamp category 14 (symbols): the stamp tiles, 64 bytes per stamp; block to 2F:8000, room for 160 stamps (an upper
; bound)
StampCat14_Symbols_Gfx::
    INCBIN "data/bank_2f/StampCat14_Symbols_Gfx.2bpp" ; $5800, 10240 bytes
