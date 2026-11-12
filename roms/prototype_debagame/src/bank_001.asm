; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $01. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $001", ROMX[$4000], BANK[$1]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_01_4000::
    db $01

; C: FNTOOE1 in both old symbol tables (same bank and address); this build copies the block here: Gfx: 2bpp tiles
; copied to VRAM by 00:04C3, 00:0560
Gfx_01_4001_FNTOOE1::
    INCBIN "data/bank_01/Gfx_01_4001_FNTOOE1.2bpp" ; $4001, 6144 bytes
; C: TITLE1 in both old symbol tables (same bank and address); this build copies the block here: Map: tile-map rows
; copied to the BG map by 00:04CF
Map_01_5801_TITLE1::
    INCBIN "data/bank_01/Map_01_5801_TITLE1.tilemap" ; $5801, 576 bytes
; C: MENU1 in both old symbol tables (same bank and address); this build copies the block here: Map: tile-map rows
; copied to the BG map by 00:056C
Map_01_5A41_MENU1::
    INCBIN "data/bank_01/Map_01_5A41_MENU1.tilemap" ; $5A41, 576 bytes
; C: TCRF Proto:Game Boy Camera (Debagame Tester) unused graphic: face photo 5 of 10 (SIMO in both old symbol tables),
; a 128 x 112 camera picture (224 tiles in row order, 3,584 B); TCRF photo 4 is the same bytes shown with the palette
; inverted (exact match with shades 3-2-1-0); pixel match against the ...
Unused_TCRF_FacePhoto5_SIMO_Gfx::
    INCBIN "data/bank_01/Unused_TCRF_FacePhoto5_SIMO_Gfx.bin" ; $5C81, 9086 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_01_7FFF::
    db $01
