; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $03. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $003", ROMX[$4000], BANK[$3]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_03_4000::
    db $03

; C: FNTOOE3 in both old symbol tables (same bank and address); this build copies the block here: Gfx: 2bpp tiles
; copied to VRAM by 00:0EBF, 00:1D7D, 00:3217
Gfx_03_4001_FNTOOE3::
    INCBIN "data/bank_03/Gfx_03_4001_FNTOOE3.2bpp" ; $4001, 6144 bytes
; C: BG_MOVIE in both old symbol tables (same bank and address); this build copies the block here: Map: tile-map rows
; copied to the BG map by 00:0ECB, 00:1D89, 00:3223
Map_03_5801_BG_MOVIE::
    INCBIN "data/bank_03/Map_03_5801_BG_MOVIE.tilemap" ; $5801, 576 bytes
; C: CONF2 in both old symbol tables (same bank and address); this build copies the block here: Gfx: 2bpp tiles copied
; to VRAM by 00:1291
Gfx_03_5A41_CONF2::
    INCBIN "data/bank_03/Gfx_03_5A41_CONF2.2bpp" ; $5A41, 6144 bytes
; C: BG_CONF in both old symbol tables (same bank and address); this build copies the block here: Map: tile-map rows
; copied to the BG map by 00:129D
Map_03_7241_BG_CONF::
    INCBIN "data/bank_03/Map_03_7241_BG_CONF.tilemap" ; $7241, 576 bytes
; I: BG_F_SCR in both old symbol tables at this bank and address; this build neither copies nor reads it (L2 runs); a
; BG map by its name (every BG_ block this build copies is one) and its bytes (tile numbers, the common ones of the
; menu maps)
Map_03_7481_BG_F_SCR::
    INCBIN "data/bank_03/Map_03_7481_BG_F_SCR.tilemap" ; $7481, 576 bytes
; I: BG_EDIT in both old symbol tables at this bank and address; this build neither copies nor reads it (L2 runs); a
; BG map by its name (every BG_ block this build copies is one) and its bytes (tile numbers, the common ones of the
; menu maps)
Map_03_76C1_BG_EDIT::
    INCBIN "data/bank_03/Map_03_76C1_BG_EDIT.tilemap" ; $76C1, 1024 bytes
; I: BG_EDITW in both old symbol tables at this bank and address; this build neither copies nor reads it (L2 runs); a
; BG map by its name (every BG_ block this build copies is one) and its bytes (tile numbers, the common ones of the
; menu maps)
Map_03_7AC1_BG_EDITW::
    INCBIN "data/bank_03/Map_03_7AC1_BG_EDITW.tilemap" ; $7AC1, 1342 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_03_7FFF::
    db $03
