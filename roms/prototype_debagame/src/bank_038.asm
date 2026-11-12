; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $38. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $038", ROMX[$4000], BANK[$38]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_38_4000::
    db $38

; I: leftover: an exact copy of 256 bytes of Unused_TCRF_FacePhoto10_HOI_R_Gfx (from 05:6F11, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_38_4001_Unused_TCRF_FacePhoto10_HOI_R_Gfx_Part6F11::
    INCBIN "data/bank_38/Leftover_38_4001_Unused_TCRF_FacePhoto10_HOI_R_Gfx_Part6F11.bin" ; $4001, 256 bytes
; I: leftover: 3 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_38_4101::
    db $80, $60, $c2

; I: leftover: an exact copy of 301 bytes of Unused_TCRF_FacePhoto10_HOI_R_Gfx (from 05:7014, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_38_4104_Unused_TCRF_FacePhoto10_HOI_R_Gfx_Part7014::
    INCBIN "data/bank_38/Leftover_38_4104_Unused_TCRF_FacePhoto10_HOI_R_Gfx_Part7014.bin" ; $4104, 301 bytes
; I: leftover: an exact copy of 3536 bytes of Gfx_01_4001_FNTOOE1 (from 01:4231, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_38_4231_Gfx_01_4001_FNTOOE1_Part4231::
    INCBIN "data/bank_38/Leftover_38_4231_Gfx_01_4001_FNTOOE1_Part4231.bin" ; $4231, 3536 bytes
; C: TCRF Proto:Game Boy Camera (Debagame Tester) unused graphic: the title logo DEBAGAME TESTER NEO, the 96 tiles
; that a title screen loads as tiles $00-$5F (a 16 x 6 block, 1,536 B; the logo is its left 11 x 6); drawn by
; Unused_TCRF_TitleLogoNEO_Map (38:5801); pixel match against the TCRF image, 0 ...
Unused_TCRF_TitleLogoNEO_Gfx::
    INCBIN "data/bank_38/Unused_TCRF_TitleLogoNEO_Gfx.2bpp" ; $5001, 1536 bytes
; I: leftover: an exact copy of 512 bytes of Gfx_01_4001_FNTOOE1 (from 01:5601, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_38_5601_Gfx_01_4001_FNTOOE1_Part5601::
    INCBIN "data/bank_38/Leftover_38_5601_Gfx_01_4001_FNTOOE1_Part5601.bin" ; $5601, 512 bytes
; C: TCRF Proto:Game Boy Camera (Debagame Tester): the tile map of the NEO title, an old title screen "Ver1.00" (32 x
; 18, 576 B; the layout of the live Map_01_5801_TITLE1): with Unused_TCRF_TitleLogoNEO_Gfx as tiles $00-$5F it draws
; the TCRF logo at row 1, column 4 (rendered 2026-11-11); as stored, ...
Unused_TCRF_TitleLogoNEO_Map::
    INCBIN "data/bank_38/Unused_TCRF_TitleLogoNEO_Map.tilemap" ; $5801, 576 bytes
; I: leftover: an exact copy of 485 bytes of Map_01_5A41_MENU1 (from 01:5A41, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_38_5A41_Map_01_5A41_MENU1_Part5A41::
    INCBIN "data/bank_38/Leftover_38_5A41_Map_01_5A41_MENU1_Part5A41.bin" ; $5A41, 485 bytes
; I: leftover: 9 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_38_5C26::
    db $c8, $cf, $c9, $a0, $a0, $a0, $a0, $a0, $a0

; I: leftover: an exact copy of 51 bytes of Map_01_5A41_MENU1 (from 01:5AEF, a part of the block) that nothing in this
; build reads, runs or explains (never read nor run in the L2 runs)
Leftover_38_5C2F_Map_01_5A41_MENU1_Part5AEF::
    db $a0, $a0, $a0, $a0, $a6, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $a5, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0
    db $a0, $a0, $a0, $a0, $a6, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa

; I: leftover: 31 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_38_5C62::
    db $a7, $a8, $a8, $a8, $a8, $a8, $a8, $a8, $a8, $a8, $a8, $a8, $a8, $a8, $a8, $a8
    db $a8, $a9, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa

; I: leftover: an exact copy of Unused_TCRF_FacePhoto5_SIMO_Gfx (01:5C81, 3584 bytes) that nothing in this build
; reads, runs or explains (never read nor run in the L2 runs)
Leftover_38_5C81_Unused_TCRF_FacePhoto5_SIMO_Gfx::
    INCBIN "data/bank_38/Leftover_38_5C81_Unused_TCRF_FacePhoto5_SIMO_Gfx.bin" ; $5C81, 9086 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_38_7FFF::
    db $38
