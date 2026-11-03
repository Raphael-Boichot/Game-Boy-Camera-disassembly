; Game Boy Camera (USA, Europe), bank $2B. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $02b", ROMX[$4000], BANK[$2b]

; C: stamp category 3 (Mario (international only, TCRF)): the stamp tiles, 480 bytes per stamp; the block runs to the
; next set or name (2B:5800), room for 12 stamps (an upper bound); the set holds 6 stamps, drawn from the ROM: Mario,
; Luigi, Donkey Kong, Toad, Lakitu on his cloud, a moustache
StampCat03_Mario_Gfx::
    INCBIN "data/bank_2b/StampCat03_Mario_Gfx.2bpp" ; $4000, 6144 bytes
; C: stamp category 2 (Pokemon): the 1bpp masks, 200 bytes per stamp; the block runs to the next set or name
; (2B:6800), room for 20 stamps (an upper bound); the set holds 6 stamps, drawn from the ROM: Charmander, Bulbasaur,
; Squirtle, Pikachu, Meowth, Mew
StampCat02_Pokemon_Mask::
    INCBIN "data/bank_2b/StampCat02_Pokemon_Mask.bin" ; $5800, 4096 bytes
; C: stamp category 3 (Mario (international only, TCRF)): the 1bpp masks, 240 bytes per stamp; the block runs to the
; next set or name (2B:7400), room for 12 stamps (an upper bound); the set holds 6 stamps, drawn from the ROM: Mario,
; Luigi, Donkey Kong, Toad, Lakitu on his cloud, a moustache
StampCat03_Mario_Mask::
    INCBIN "data/bank_2b/StampCat03_Mario_Mask.bin" ; $6800, 3072 bytes
; C: stamp category 14 (symbols): the 1bpp masks, 32 bytes per stamp; the block runs to the next set or name
; (2B:8000), room for 96 stamps (an upper bound)
StampCat14_Symbols_Mask::
    INCBIN "data/bank_2b/StampCat14_Symbols_Mask.bin" ; $7400, 3072 bytes
