; Pocket Camera (Japan) (Rev A), bank $11. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $011", ROMX[$4000], BANK[$11]

; C: frame 4 of 7 of the menu strip B (0x500 bytes = 80 tiles, copied to $9200 by the page transition B; frames 0-3 in
; bank $16 at pitch 0x500, frames 4-6 in bank $11): Tbl0 step 4 and Tbl3 steps 3-4
Gfx_11_4000_MainMenu_IconStripB_F4::
    INCBIN "data/bank_11/Gfx_11_4000_MainMenu_IconStripB_F4.2bpp" ; $4000, 1280 bytes
; C: frame 5 of 7 of the menu strip B (0x500 bytes = 80 tiles, copied to $9200 by the page transition B; frames 0-3 in
; bank $16 at pitch 0x500, frames 4-6 in bank $11): Tbl2 steps 1-2 and Tbl3 steps 1-2
Gfx_11_4500_MainMenu_IconStripB_F5::
    INCBIN "data/bank_11/Gfx_11_4500_MainMenu_IconStripB_F5.2bpp" ; $4500, 1280 bytes
; C: frame 6 of 7 of the menu strip B (0x500 bytes = 80 tiles, copied to $9200 by the page transition B; frames 0-3 in
; bank $16 at pitch 0x500, frames 4-6 in bank $11): Tbl2 steps 3-4; resting tiles when $DA16 >= 3
; (MainMenu_LoadIconTilesB, 07:785B)
Gfx_11_4A00_MainMenu_IconStripB_F6::
    INCBIN "data/bank_11/Gfx_11_4A00_MainMenu_IconStripB_F6.2bpp" ; $4A00, 1280 bytes
; C: copied to VRAM/WRAM by MainMenu_LoadBaseTiles, MainMenu_DrawUpperItem0 (roms/jp_rev_a/assets/catalog_jp.csv). L3
; pass 2026-10-26: read in BGB in 203 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Gfx_11_4F00_MainMenu_LoadBaseTiles::
    INCBIN "data/bank_11/Gfx_11_4F00_MainMenu_LoadBaseTiles.2bpp" ; $4F00, 256 bytes
; C: far pointer loaded by MainMenu_DrawUpperItem1 (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 203 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Gfx_11_5000_MainMenu_DrawUpperItem1::
    INCBIN "data/bank_11/Gfx_11_5000_MainMenu_DrawUpperItem1.2bpp" ; $5000, 512 bytes
; C: far pointer loaded by MainMenu_DrawUpperItem0 (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 512 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 203 replay(s) of the organic corpus, modes 00
; (tcrf_check/assets/l3_names/)
Gfx_11_5200_MainMenu_DrawUpperItem0::
    INCBIN "data/bank_11/Gfx_11_5200_MainMenu_DrawUpperItem0.2bpp" ; $5200, 256 bytes
; C: far pointer loaded by MainMenu_DrawUpperItem1 (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 512 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 203 replay(s) of the organic corpus, modes 00
; (tcrf_check/assets/l3_names/)
Gfx_11_5300_MainMenu_DrawUpperItem1::
    INCBIN "data/bank_11/Gfx_11_5300_MainMenu_DrawUpperItem1.2bpp" ; $5300, 256 bytes
; C: inside the 512-byte block 5300-5500 that MainMenu_DrawUpperItem1 copies (copy site 07:79E1); what the frames show
; is by eye. L3 pass 2026-10-26: read in BGB in 77 replay(s) of the organic corpus, modes 00
; (tcrf_check/assets/l3_names/)
Gfx_11_5400_MainMenuUpperItemFramesA::
    INCBIN "data/bank_11/Gfx_11_5400_MainMenuUpperItemFramesA.2bpp" ; $5400, 256 bytes
; C: far pointer loaded by MainMenu_DrawUpperItem0 (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 512 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 203 replay(s) of the organic corpus, modes 00
; (tcrf_check/assets/l3_names/)
Gfx_11_5500_MainMenu_DrawUpperItem0::
    INCBIN "data/bank_11/Gfx_11_5500_MainMenu_DrawUpperItem0.2bpp" ; $5500, 256 bytes
; C: far pointer loaded by MainMenu_DrawUpperItem1 (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 512 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 203 replay(s) of the organic corpus, modes 00
; (tcrf_check/assets/l3_names/)
Gfx_11_5600_MainMenu_DrawUpperItem1::
    INCBIN "data/bank_11/Gfx_11_5600_MainMenu_DrawUpperItem1.2bpp" ; $5600, 512 bytes
; C: nine sprite frames of a hand flipping a newspaper (TCRF B16, Unused Graphic Bank 11): 25 tiles per frame in
; 512-byte slots at 11:5800 + $200*j (j 0-8, the last one cut at 11:693F); arranged by OAM list $BA
; (OamList_B01_4000_BA, 01:5504, 5 x 5 sprites 40 x 40 px, attr $10, tile T of slot j = ...
Unused_TCRF_HandNewspaperFrames_Gfx::
    db $7f, $00, $ff, $7f, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40
    db $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $e0, $00, $f0, $e0, $f0, $20, $f0, $20, $f0, $20, $f0, $20, $f0, $20, $f0, $20
    db $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $f0, $20, $f0, $20, $f0, $20, $f0, $20, $f0, $20, $f0, $20, $f0, $20, $f0, $20
    db $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40
    db $ff, $00, $ff, $00, $ff, $01, $ff, $01, $ff, $01, $ff, $01, $ff, $01, $ff, $01
    db $ff, $00, $ff, $e0, $3f, $f8, $2f, $fc, $27, $ff, $25, $ff, $25, $ff, $24, $ff
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $80, $ff, $80
    db $f0, $20, $f0, $20, $f0, $20, $f0, $20, $f0, $20, $f0, $20, $f0, $20, $f0, $20
    db $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $7f, $7f, $00, $00, $00
    db $ff, $01, $ff, $01, $ff, $01, $ff, $01, $ff, $03, $ff, $ff, $f2, $3f, $10, $1f
    db $24, $ff, $00, $ff, $00, $d5, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $ff, $c0, $ff, $c0, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $ff, $7f, $c0, $40, $c0
    db $f0, $20, $f0, $20, $f0, $20, $f0, $20, $f0, $20, $f0, $e0, $f0, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $08, $0f, $06, $07, $03, $03, $02, $03, $02, $03, $01, $01, $00, $00, $00, $00
    db $00, $ff, $cb, $ff, $01, $ff, $00, $ff, $00, $ff, $7d, $ff, $ff, $ff, $7f, $7f
    db $c0, $c0, $80, $80, $00, $00, $80, $80, $80, $80, $c0, $c0, $80, $80, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $7f, $00, $ff, $7f, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40
    db $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $e0, $00, $f0, $e0, $f0, $20, $f0, $20, $fc, $2c, $fc, $2c, $fc, $2c, $fc, $2c
    db $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $fc, $2c, $fc, $2c, $fc, $2c, $fc, $2c, $fc, $2c, $fc, $2c, $fc, $2c, $fc, $2c
    db $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40
    db $ff, $00, $ff, $00, $ff, $00, $ff, $01, $fe, $03, $fc, $07, $fc, $07, $fe, $07
    db $ff, $00, $ff, $00, $ff, $00, $ff, $b8, $4f, $f8, $27, $fe, $25, $ff, $24, $ff
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $80
    db $fc, $2c, $fc, $2c, $fc, $2c, $fc, $2c, $fc, $2c, $fc, $2c, $fc, $2c, $fc, $2c
    db $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $40, $ff, $7f, $7f, $00, $1f, $1f
    db $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $ff, $f2, $3f, $f0, $ff
    db $24, $ff, $00, $ff, $00, $ea, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $ff, $80, $ff, $80, $7f, $c0, $7f, $c0, $7f, $c0, $7f, $ff, $7f, $c0, $7f, $ff
    db $fc, $2c, $fc, $2c, $fc, $2c, $fc, $2c, $fc, $2c, $fc, $ec, $fc, $0c, $fc, $fc
    db $1f, $1f, $1f, $1f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $f8, $ff, $fe, $ff, $03, $03, $01, $01, $02, $03, $01, $01, $00, $00, $00, $00
    db $00, $ff, $01, $ff, $8b, $ff, $01, $ff, $00, $ff, $01, $ff, $ff, $ff, $7f, $7f
    db $ff, $ff, $ff, $ff, $80, $80, $80, $80, $80, $80, $c0, $c0, $80, $80, $00, $00
    db $fc, $fc, $fc, $fc, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $0f, $00, $1f, $0f, $1f, $08, $1f, $08, $1f, $08, $1f, $08, $1f, $08, $1f, $08
    db $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $00, $00, $f8, $f8, $08, $08, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $1f, $08, $1f, $08, $1f, $08, $1f, $08, $1f, $08, $1f, $08, $1f, $08, $1f, $08
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $1f, $08, $1f, $08, $1f, $08, $1f, $08, $1f, $08, $1f, $08, $1f, $08, $1f, $08
    db $ff, $00, $ff, $00, $ff, $00, $ff, $01, $fe, $03, $fe, $03, $ff, $03, $ff, $01
    db $ff, $00, $ff, $00, $ff, $c0, $7f, $f8, $2f, $fc, $07, $fe, $07, $ff, $85, $ff
    db $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $8a, $8a
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $1f, $08, $1f, $08, $1f, $08, $1f, $08, $1f, $08, $1f, $0f, $1f, $00, $01, $01
    db $ff, $01, $ff, $00, $ff, $00, $ff, $00, $ff, $01, $ff, $ff, $f1, $1f, $f0, $ff
    db $85, $ff, $c0, $ff, $c0, $fa, $c0, $ff, $c0, $ff, $80, $ff, $00, $ff, $00, $ff
    db $8a, $8a, $8a, $8a, $8a, $8a, $8a, $8a, $8a, $8a, $fa, $fa, $82, $82, $fe, $fe
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $f8, $ff, $fe, $ff, $03, $03, $01, $01, $02, $03, $01, $01, $00, $00, $00, $00
    db $01, $ff, $03, $ff, $a3, $ff, $01, $ff, $00, $ff, $01, $ff, $ff, $ff, $7f, $7f
    db $fe, $fe, $fe, $fe, $80, $80, $80, $80, $80, $80, $c0, $c0, $80, $80, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $01, $00, $03, $01, $03, $01, $03, $01, $03, $01, $03, $01, $03, $01, $03, $01
    db $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $e0, $00, $ff, $ff, $e0, $00, $e0, $00, $e0, $00, $e0, $00, $e0, $00, $e0, $00
    db $00, $00, $e0, $e0, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $03, $01, $03, $01, $03, $01, $03, $01, $03, $01, $03, $01, $03, $01, $03, $01
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $e0, $00, $e0, $00, $e0, $00, $e0, $00, $e0, $00, $e0, $00, $e0, $00, $e0, $00
    db $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $03, $01, $03, $01, $03, $01, $03, $01, $03, $01, $03, $01, $03, $01, $03, $01
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $e0, $00, $e0, $00, $e0, $00, $f8, $38, $ec, $7c, $c6, $7e, $c2, $7e, $c1, $7f
    db $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $03, $01, $03, $01, $03, $01, $03, $01, $03, $01, $03, $01, $03, $00, $00, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $fc, $0f, $3c, $3f
    db $e1, $7f, $e0, $7f, $e0, $7a, $c0, $7f, $c0, $ff, $e0, $ff, $40, $ff, $00, $ff
    db $20, $20, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $e0, $e0, $80, $80, $e0, $e0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $3e, $3f, $3f, $3f, $01, $01, $01, $01, $02, $03, $01, $01, $00, $00, $00, $00
    db $01, $ff, $03, $ff, $eb, $ff, $01, $ff, $00, $ff, $01, $ff, $ff, $ff, $7f, $7f
    db $e0, $e0, $e0, $e0, $80, $80, $80, $80, $80, $80, $c0, $c0, $80, $80, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $c0, $c0, $fe, $fe, $c2, $42, $c2, $42, $c2, $42, $c2, $42, $c2, $42, $c2, $42
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $c2, $42, $c2, $42, $c2, $42, $c2, $42, $c2, $42, $c2, $42, $c2, $42, $c2, $42
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $c2, $42, $c2, $42, $c2, $42, $da, $5a, $e6, $7e, $e2, $7e, $e2, $7e, $e1, $7f
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $01, $01, $01, $01, $01, $01, $03, $03, $05, $07, $04, $07, $04, $07, $04, $07
    db $f1, $7f, $f0, $7f, $f0, $7e, $f0, $7f, $f0, $ff, $e0, $ff, $00, $ff, $00, $ff
    db $00, $00, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $02, $03, $03, $03, $01, $01, $01, $01, $02, $03, $01, $01, $00, $00, $00, $00
    db $01, $ff, $03, $ff, $eb, $ff, $01, $ff, $00, $ff, $01, $ff, $ff, $ff, $7f, $7f
    db $80, $80, $00, $00, $00, $00, $80, $80, $c0, $c0, $c0, $c0, $80, $80, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $03, $03, $02, $03, $02, $03, $02, $03, $02, $03, $02, $03, $02, $03, $02, $03
    db $ff, $ff, $00, $ff, $00, $ff, $7e, $ff, $7e, $ff, $7e, $ff, $7e, $ff, $7e, $ff
    db $ff, $ff, $00, $ff, $00, $ff, $f8, $ff, $f8, $ff, $00, $ff, $00, $ff, $00, $ff
    db $f0, $f0, $10, $f0, $10, $f0, $10, $f0, $10, $f0, $10, $f0, $10, $f0, $10, $f0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $02, $03, $02, $03, $02, $03, $02, $03, $02, $03, $02, $03, $02, $03, $02, $03
    db $7e, $ff, $7e, $ff, $7e, $ff, $7e, $ff, $7e, $ff, $7e, $ff, $00, $ff, $00, $ff
    db $7e, $ff, $00, $ff, $7e, $ff, $00, $ff, $7e, $ff, $00, $ff, $00, $ff, $00, $ff
    db $10, $f0, $10, $f0, $10, $f0, $10, $f0, $10, $f0, $10, $f0, $10, $f0, $10, $f0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $02, $03, $02, $03, $02, $03, $02, $03, $02, $03, $02, $03, $02, $03, $02, $03
    db $00, $ff, $00, $ff, $1f, $ff, $00, $ff, $00, $ff, $00, $ff, $1f, $ff, $00, $ff
    db $00, $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $f5, $ff, $00, $ff
    db $10, $f0, $10, $f0, $10, $f0, $10, $f0, $10, $f0, $10, $f0, $10, $f0, $10, $f0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $02, $03, $02, $03, $02, $03, $02, $03, $02, $03, $02, $03, $03, $03, $00, $00
    db $00, $ff, $00, $ff, $1f, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $ff, $3c, $3f
    db $00, $ff, $03, $ff, $c4, $ff, $08, $ff, $09, $ff, $09, $ff, $f0, $ff, $20, $ff
    db $10, $f0, $10, $f0, $90, $f0, $90, $f0, $10, $f0, $10, $f0, $f0, $f0, $e0, $e0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $3e, $3f, $3f, $3f, $01, $01, $01, $01, $02, $03, $01, $01, $00, $00, $00, $00
    db $01, $ff, $03, $ff, $eb, $ff, $01, $ff, $00, $ff, $01, $ff, $ff, $ff, $7f, $7f
    db $e0, $e0, $e0, $e0, $80, $80, $80, $80, $80, $80, $c0, $c0, $80, $80, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $1f, $1f, $10, $1f, $10, $1f, $11, $1f, $11, $1f, $11, $1f, $11, $1f, $11, $1f
    db $ff, $ff, $00, $ff, $00, $ff, $fd, $ff, $fd, $ff, $fc, $ff, $fc, $ff, $fc, $ff
    db $ff, $ff, $00, $ff, $00, $ff, $fc, $ff, $fc, $ff, $00, $ff, $00, $ff, $00, $ff
    db $fc, $fc, $04, $fc, $06, $fe, $06, $fe, $06, $fe, $06, $fe, $06, $fe, $06, $fe
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $11, $1f, $11, $1f, $11, $1f, $11, $1f, $11, $1f, $11, $1f, $10, $1f, $10, $1f
    db $fc, $ff, $fc, $ff, $fc, $ff, $fc, $ff, $fc, $ff, $fc, $ff, $00, $ff, $00, $ff
    db $7f, $ff, $00, $ff, $7f, $ff, $00, $ff, $7f, $ff, $00, $ff, $00, $ff, $00, $ff
    db $06, $fe, $06, $fe, $06, $fe, $06, $fe, $06, $fe, $06, $fe, $06, $fe, $06, $fe
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $10, $1f, $10, $1f, $10, $1f, $10, $1f, $10, $1f, $10, $1f, $10, $1f, $10, $1f
    db $00, $ff, $00, $ff, $7f, $ff, $00, $ff, $00, $ff, $00, $ff, $7f, $ff, $00, $ff
    db $00, $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $f2, $ff, $00, $ff
    db $06, $fe, $06, $fe, $86, $fe, $06, $fe, $06, $fe, $06, $fe, $86, $fe, $06, $fe
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $10, $1f, $10, $1f, $10, $1f, $10, $1f, $10, $1f, $10, $1f, $1f, $1f, $01, $01
    db $00, $ff, $00, $ff, $7f, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $ff, $f8, $ff
    db $00, $ff, $03, $ff, $c6, $ff, $0c, $ff, $0c, $ff, $0c, $ff, $fc, $ff, $10, $ff
    db $06, $fe, $c6, $fe, $26, $fe, $26, $fe, $46, $fe, $46, $fe, $3e, $fe, $3e, $fe
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $fc, $ff, $fe, $ff, $03, $03, $01, $01, $02, $03, $01, $01, $00, $00, $00, $00
    db $00, $ff, $00, $ff, $a3, $ff, $01, $ff, $00, $ff, $01, $ff, $ff, $ff, $7f, $7f
    db $7e, $fe, $fe, $fe, $80, $80, $80, $80, $80, $80, $c0, $c0, $80, $80, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $ff, $80, $ff, $80, $ff, $87, $ff, $87, $ff, $87, $ff, $87, $ff, $87, $ff
    db $ff, $ff, $00, $ff, $00, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff
    db $ff, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff
    db $ff, $ff, $00, $ff, $00, $ff, $c0, $ff, $c0, $ff, $00, $ff, $00, $ff, $00, $ff
    db $f0, $f0, $10, $f0, $10, $f0, $1c, $fc, $1c, $fc, $1c, $fc, $1c, $fc, $1c, $fc
    db $87, $ff, $87, $ff, $87, $ff, $87, $ff, $87, $ff, $87, $ff, $80, $ff, $80, $ff
    db $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $00, $ff, $00, $ff
    db $1f, $ff, $00, $ff, $1f, $ff, $00, $ff, $1f, $ff, $00, $ff, $00, $ff, $00, $ff
    db $f0, $ff, $00, $ff, $f0, $ff, $00, $ff, $f0, $ff, $00, $ff, $00, $ff, $00, $ff
    db $1c, $fc, $1c, $fc, $1c, $fc, $1c, $fc, $1c, $fc, $1c, $fc, $1c, $fc, $1c, $fc
    db $80, $ff, $80, $ff, $80, $ff, $80, $ff, $80, $ff, $80, $ff, $80, $ff, $80, $ff
    db $00, $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $ff, $00, $ff
    db $00, $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $fe, $ff, $00, $ff
    db $00, $ff, $00, $ff, $fc, $ff, $00, $ff, $00, $ff, $00, $ff, $2c, $ff, $00, $ff
    db $1c, $fc, $1c, $fc, $1c, $fc, $1c, $fc, $1c, $fc, $1c, $fc, $1c, $fc, $1c, $fc
    db $80, $ff, $80, $ff, $80, $ff, $80, $ff, $80, $ff, $80, $ff, $ff, $ff, $1f, $1f
    db $00, $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $ff, $f0, $ff
    db $00, $ff, $01, $ff, $f2, $ff, $04, $ff, $04, $ff, $04, $ff, $f8, $ff, $10, $ff
    db $00, $ff, $c0, $ff, $20, $ff, $20, $ff, $40, $ff, $40, $ff, $3f, $ff, $3f, $ff
    db $1c, $fc, $1c, $fc, $1c, $fc, $1c, $fc, $1c, $fc, $1c, $fc, $fc, $fc, $fc, $fc
    db $1f, $1f, $1f, $1f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $f8, $fb, $fe, $ff, $03, $03, $01, $01, $02, $03, $01, $01, $00, $00, $00, $00
    db $00, $ff, $00, $ff, $8b, $ff, $01, $ff, $00, $ff, $01, $ff, $ff, $ff, $7f, $7f
    db $7f, $ff, $ff, $ff, $80, $80, $80, $80, $80, $80, $c0, $c0, $80, $80, $00, $00
    db $fc, $fc, $fc, $fc, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $ff, $80, $ff, $80, $ff, $87, $ff, $87, $ff, $87, $ff, $87, $ff, $87, $ff
    db $ff, $ff, $00, $ff, $00, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff
    db $ff, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff
    db $ff, $ff, $00, $ff, $00, $ff, $c0, $ff, $c0, $ff, $00, $ff, $00, $ff, $00, $ff
    db $f0, $f0, $10, $f0, $10, $f0, $10, $f0, $10, $f0, $10, $f0, $10, $f0, $10, $f0
    db $87, $ff, $87, $ff, $87, $ff, $87, $ff, $87, $ff, $87, $ff, $80, $ff, $80, $ff
    db $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $00, $ff, $00, $ff
    db $1f, $ff, $00, $ff, $1f, $ff, $00, $ff, $1f, $ff, $00, $ff, $00, $ff, $00, $ff
    db $f0, $ff, $00, $ff, $f0, $ff, $00, $ff, $f0, $ff, $00, $ff, $00, $ff, $00, $ff
    db $10, $f0, $10, $f0, $10, $f0, $10, $f0, $10, $f0, $10, $f0, $10, $f0, $10, $f0
    db $87, $ff, $87, $ff, $87, $ff, $87, $ff, $87, $ff, $87, $ff, $80, $ff, $80, $ff
    db $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $00, $ff, $00, $ff
    db $1f, $ff, $00, $ff, $1f, $ff, $00, $ff, $1f, $ff, $00, $ff, $00, $ff, $00, $ff
    db $f0, $ff, $00, $ff, $f0, $ff, $00, $ff, $f0, $ff, $00, $ff, $00, $ff, $00, $ff
    db $10, $f0, $10, $f0, $10, $f0, $10, $f0, $10, $f0, $10, $f0, $10, $f0, $10, $f0
    db $80, $ff, $80, $ff, $80, $ff, $80, $ff, $80, $ff, $80, $ff, $ff, $ff, $00, $00
    db $00, $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $ff, $00, $00
    db $00, $ff, $00, $ff, $f0, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $ff, $00, $00
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $ff, $00, $00
    db $10, $f0, $10, $f0, $10, $f0, $10, $f0, $10, $f0, $10, $f0, $f0, $f0, $00, $00

    ; padding
    ds $6c0, $00

; C: copied to VRAM/WRAM by Mode18_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 9 replay(s) of the organic corpus, modes 18 (tcrf_check/assets/l3_names/)
Gfx_11_7000_Mode18_State00_Init::
    INCBIN "data/bank_11/Gfx_11_7000_Mode18_State00_Init.2bpp" ; $7000, 512 bytes
; C: entry 0 of the {lo,hi,bank} table 06:5D54, 256 bytes each (constant pitch)
Gfx_11_7200_Icon06_5D54::
    INCBIN "data/bank_11/Gfx_11_7200_Icon06_5D54.2bpp" ; $7200, 256 bytes
; C: entry 1 of the {lo,hi,bank} table 06:5D54, 256 bytes each (constant pitch)
Gfx_11_7300_Icon06_5D54::
    INCBIN "data/bank_11/Gfx_11_7300_Icon06_5D54.2bpp" ; $7300, 256 bytes
; C: entry 2 of the {lo,hi,bank} table 06:5D54, 256 bytes each (constant pitch)
Gfx_11_7400_Icon06_5D54::
    INCBIN "data/bank_11/Gfx_11_7400_Icon06_5D54.2bpp" ; $7400, 256 bytes
; C: entry 3 of the {lo,hi,bank} table 06:5D54, 256 bytes each (constant pitch)
Gfx_11_7500_Icon06_5D54::
    INCBIN "data/bank_11/Gfx_11_7500_Icon06_5D54.2bpp" ; $7500, 256 bytes
; C: entry 6 of the {lo,hi,bank} table 06:5D54, 256 bytes each (constant pitch)
Gfx_11_7600_Icon06_5D54::
    INCBIN "data/bank_11/Gfx_11_7600_Icon06_5D54.2bpp" ; $7600, 256 bytes
; C: copied to VRAM/WRAM by Compose_DrawJitter (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 9 replay(s) of the organic corpus, modes 18 (tcrf_check/assets/l3_names/)
Gfx_11_7000_Compose_DrawJitter_Part7700::
    INCBIN "data/bank_11/Gfx_11_7000_Compose_DrawJitter_Part7700.2bpp" ; $7700, 256 bytes
; C: copied to VRAM/WRAM by Mode18_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 9 replay(s) of the organic corpus, modes 18 (tcrf_check/assets/l3_names/)
Gfx_11_7800_Mode18_State00_Init::
    INCBIN "data/bank_11/Gfx_11_7800_Mode18_State00_Init.2bpp" ; $7800, 1088 bytes
; C: far pointer loaded by Mode18_DrawThumbFrame (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 9 replay(s) of the organic corpus, modes 18 (tcrf_check/assets/l3_names/)
Gfx_11_7C40_Mode18_DrawThumbFrame::
    INCBIN "data/bank_11/Gfx_11_7C40_Mode18_DrawThumbFrame.2bpp" ; $7C40, 192 bytes
; C: entry 5 of the {lo,hi,bank} table 06:5D54, 256 bytes each (constant pitch)
Gfx_11_7D00_Icon06_5D54::
    INCBIN "data/bank_11/Gfx_11_7D00_Icon06_5D54.2bpp" ; $7D00, 256 bytes
; C: entry 7 of the {lo,hi,bank} table 06:5D54, 256 bytes each (constant pitch)
Gfx_11_7E00_Icon06_5D54::
    INCBIN "data/bank_11/Gfx_11_7E00_Icon06_5D54.2bpp" ; $7E00, 256 bytes
; C: copied to VRAM/WRAM by Compose_DrawJitter (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 9 replay(s) of the organic corpus, modes 18 (tcrf_check/assets/l3_names/)
Gfx_11_7800_Compose_DrawJitter_Part7F00::
    INCBIN "data/bank_11/Gfx_11_7800_Compose_DrawJitter_Part7F00.2bpp" ; $7F00, 256 bytes
