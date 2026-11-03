; Game Boy Camera Gold (USA), bank $2B. Written by tools/make_source.py from roms/gold/gbcam_gold.sym and the tables of
; roms/gold/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $02b", ROMX[$4000], BANK[$2b]

; C: stamp category 3 (Zelda: Ocarina of Time characters (Link x3, Zelda, Ganondorf, Hylian Shield; 6 stamps) in place
; of the 6 Mario stamps): the stamp tiles, 480 bytes per stamp; block to 2B:5800 (6 stamps)
StampCat03_ZeldaOoT_Gfx::
    INCBIN "data/bank_2b/StampCat03_ZeldaOoT_Gfx.2bpp" ; $4000, 6144 bytes
; C: stamp category 2 (Zelda: Ocarina of Time items (eyes, elf ears, Triforce, Navi; 6 stamps) in place of the 6
; Pokemon of the international ROM): the 1bpp masks, 200 bytes per stamp; block to 2B:6800 (6 stamps)
StampCat02_ZeldaSmall_Mask::
    INCBIN "data/bank_2b/StampCat02_ZeldaSmall_Mask.bin" ; $5800, 4096 bytes
; C: stamp category 3 (Zelda: Ocarina of Time characters (Link x3, Zelda, Ganondorf, Hylian Shield; 6 stamps) in place
; of the 6 Mario stamps): the 1bpp masks, 240 bytes per stamp; block to 2B:7400 (6 stamps)
StampCat03_ZeldaOoT_Mask::
    INCBIN "data/bank_2b/StampCat03_ZeldaOoT_Mask.bin" ; $6800, 3072 bytes
; C: stamp category 14 (symbols): the 1bpp masks, 32 bytes per stamp; block to 2B:8000, room for 96 stamps (an upper
; bound)
StampCat14_Symbols_Mask::
    INCBIN "data/bank_2b/StampCat14_Symbols_Mask.bin" ; $7400, 3072 bytes
