; Game Boy Camera Gold (USA), bank $2D. Written by tools/make_source.py from roms/gold/gbcam_gold.sym and the tables of
; roms/gold/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $02d", ROMX[$4000], BANK[$2d]

; C: stamp category 1 (big stamps): the stamp tiles, 256 bytes per stamp; block to 2D:7000, room for 48 stamps (an
; upper bound)
StampCat01_BigStamps_Gfx::
    INCBIN "data/bank_2d/StampCat01_BigStamps_Gfx.2bpp" ; $4000, 12288 bytes
; C: stamp category 0 (small face parts): the 1bpp masks, 64 bytes per stamp; block to 2D:8000, room for 64 stamps (an
; upper bound)
StampCat00_SmallFace_Mask::
    INCBIN "data/bank_2d/StampCat00_SmallFace_Mask.bin" ; $7000, 4096 bytes
