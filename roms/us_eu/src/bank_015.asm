; Game Boy Camera (USA, Europe), bank $15. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $015", ROMX[$4000], BANK[$15]

; C: copied to VRAM/WRAM by MainMenu_LoadBackground (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 203 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Gfx_15_4000_MainMenu_LoadBackground::
    INCBIN "data/bank_15/Gfx_15_4000_MainMenu_LoadBackground.2bpp" ; $4000, 1152 bytes
; I: TCRF unused graphic: the circled X tile of the Japanese main-menu bank (copy 1 of 3, same tile at 15:4500 and
; 15:4580); on screen only in forced runs (README 16.24). L3 pass 2026-10-26: copied to VRAM with the block around it
; (read in BGB in 203 replay(s) of the organic corpus, modes 00) but never ...
Unused_TCRF_JapaneseMenuTile_CircledX_Gfx::
    INCBIN "data/bank_15/Unused_TCRF_JapaneseMenuTile_CircledX_Gfx.2bpp" ; $4480, 16 bytes
; C: continues the span of Gfx_15_4000_MainMenu_LoadBackground (the label before the TCRF-unused block). L3 pass
; 2026-10-26: read in BGB in 203 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Gfx_15_4490_MainMenu_LoadBackground_Cont::
    INCBIN "data/bank_15/Gfx_15_4490_MainMenu_LoadBackground_Cont.2bpp" ; $4490, 112 bytes
; I: TCRF unused graphic: circled X, copy 2 of 3. L3 pass 2026-10-26: copied to VRAM with the block around it (read in
; BGB in 203 replay(s) of the organic corpus, modes 00) but never displayed, as TCRF says; the verdict stays final I
Unused_TCRF_JapaneseMenuTile_CircledX_Copy2_Gfx::
    INCBIN "data/bank_15/Unused_TCRF_JapaneseMenuTile_CircledX_Copy2_Gfx.2bpp" ; $4500, 16 bytes
; C: continues the span of Gfx_15_4000_MainMenu_LoadBackground (the label before the TCRF-unused block). L3 pass
; 2026-10-26: read in BGB in 203 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Gfx_15_4510_MainMenu_LoadBackground_Cont::
    INCBIN "data/bank_15/Gfx_15_4510_MainMenu_LoadBackground_Cont.2bpp" ; $4510, 112 bytes
; I: TCRF unused graphic: circled X, copy 3 of 3. L3 pass 2026-10-26: copied to VRAM with the block around it (read in
; BGB in 203 replay(s) of the organic corpus, modes 00) but never displayed, as TCRF says; the verdict stays final I
Unused_TCRF_JapaneseMenuTile_CircledX_Copy3_Gfx::
    INCBIN "data/bank_15/Unused_TCRF_JapaneseMenuTile_CircledX_Copy3_Gfx.2bpp" ; $4580, 16 bytes
; C: continues the span of Gfx_15_4000_MainMenu_LoadBackground (the label before the TCRF-unused block). L3 pass
; 2026-10-26: read in BGB in 203 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Gfx_15_4590_MainMenu_LoadBackground_Cont::
    INCBIN "data/bank_15/Gfx_15_4590_MainMenu_LoadBackground_Cont.2bpp" ; $4590, 112 bytes
; I: copied to VRAM/WRAM by Mode00_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 203 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Gfx_15_4600_Mode00_State00_Init::
    INCBIN "data/bank_15/Gfx_15_4600_Mode00_State00_Init.2bpp" ; $4600, 768 bytes
; I: copied to VRAM/WRAM by Mode00_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 203 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Gfx_15_4900_Mode00_State00_Init::
    INCBIN "data/bank_15/Gfx_15_4900_Mode00_State00_Init.2bpp" ; $4900, 256 bytes
; I: copied to VRAM/WRAM by MainMenu_TransitionToLowerPage, Mode00_State04_Item3_Doodle, Mode00_State06_Item5_Special,
; Mode00_State07_Item6_Edit, MainMenu_LoadBackground (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 13 replay(s) of the organic corpus, modes 00 ...
Gfx_15_4A00_MainMenu_LoadBackground::
    INCBIN "data/bank_15/Gfx_15_4A00_MainMenu_LoadBackground.2bpp" ; $4A00, 256 bytes
; I: copied to VRAM/WRAM by MainMenu_TransitionToLowerPage, Mode00_State04_Item3_Doodle, Mode00_State05_Item4_Link,
; Mode00_State07_Item6_Edit, MainMenu_LoadBackground (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 26 replay(s) of the organic corpus, modes 00 ...
Gfx_15_4B00_MainMenu_LoadBackground::
    INCBIN "data/bank_15/Gfx_15_4B00_MainMenu_LoadBackground.2bpp" ; $4B00, 256 bytes
; I: copied to VRAM/WRAM by MainMenu_TransitionToLowerPage, Mode00_State04_Item3_Doodle, Mode00_State05_Item4_Link,
; Mode00_State06_Item5_Special, MainMenu_LoadBackground (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in 33 replay(s) of the organic corpus, modes 00 ...
Gfx_15_4C00_MainMenu_LoadBackground::
    INCBIN "data/bank_15/Gfx_15_4C00_MainMenu_LoadBackground.2bpp" ; $4C00, 256 bytes
; I: copied to VRAM/WRAM by MainMenu_TransitionToLowerPage, Mode00_State05_Item4_Link, Mode00_State06_Item5_Special,
; Mode00_State07_Item6_Edit, MainMenu_LoadBackground (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 72 replay(s) of the organic corpus, modes 00 ...
Gfx_15_4D00_MainMenu_LoadBackground::
    INCBIN "data/bank_15/Gfx_15_4D00_MainMenu_LoadBackground.2bpp" ; $4D00, 256 bytes
; I: copied to VRAM/WRAM by Mode00_State03_Item2_Arcade, MainMenu_LoadBaseTiles, MainMenu_DrawUpperItem2
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 203 replay(s) of the organic corpus, modes
; 00 (tcrf_check/assets/l3_names/)
Gfx_15_4E00_MainMenu_LoadBaseTiles::
    INCBIN "data/bank_15/Gfx_15_4E00_MainMenu_LoadBaseTiles.2bpp" ; $4E00, 512 bytes
; I: far pointer loaded by MainMenu_DrawUpperItem2 (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 512 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 14 replay(s) of the organic corpus, modes 00
; (tcrf_check/assets/l3_names/)
Gfx_15_5000_MainMenu_DrawUpperItem2::
    INCBIN "data/bank_15/Gfx_15_5000_MainMenu_DrawUpperItem2.2bpp" ; $5000, 512 bytes
; I: tile data with no direct pointer in the code (, same bank/neighbour of MainMenu_DrawUpperItem2); classified from
; its content - see sym_unconclusive. Owner (review page, 2026-10-13): graphic, by eye.
Gfx_15_5200_MainMenu_DrawUpperItem2_Aux::
    INCBIN "data/bank_15/Gfx_15_5200_MainMenu_DrawUpperItem2_Aux.2bpp" ; $5200, 512 bytes
; I: copied to VRAM/WRAM by Mode00_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 203 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Gfx_15_5400_Mode00_State00_Init::
    INCBIN "data/bank_15/Gfx_15_5400_Mode00_State00_Init.2bpp" ; $5400, 256 bytes
; I: tile data with no direct pointer in the code (, same bank/neighbour of SlidePlay_ReadKeys); classified from its
; content - see sym_unconclusive. Owner (review page, 2026-10-13): graphic, by eye.
Gfx_15_5500_SlidePlay_ReadKeys_Aux::
    INCBIN "data/bank_15/Gfx_15_5500_SlidePlay_ReadKeys_Aux.2bpp" ; $5500, 256 bytes
; C: copied to VRAM/WRAM by Mode00_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 203 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Gfx_15_5600_Mode00_State00_Init::
    INCBIN "data/bank_15/Gfx_15_5600_Mode00_State00_Init.2bpp" ; $5600, 256 bytes
; C: copied to VRAM/WRAM by Mode04_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 37 replay(s) of the organic corpus, modes 04 (tcrf_check/assets/l3_names/)
Gfx_15_5700_Mode04_State00_Init::
    INCBIN "data/bank_15/Gfx_15_5700_Mode04_State00_Init.2bpp" ; $5700, 2048 bytes
; C: copied to VRAM/WRAM by Mode04_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 37 replay(s) of the organic corpus, modes 04 (tcrf_check/assets/l3_names/)
Gfx_15_5F00_Mode04_State00_Init::
    INCBIN "data/bank_15/Gfx_15_5F00_Mode04_State00_Init.2bpp" ; $5F00, 2048 bytes
; I: copied to VRAM/WRAM by Mode04_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 37 replay(s) of the organic corpus, modes 04 (tcrf_check/assets/l3_names/)
Gfx_15_6700_Mode04_State00_Init::
    INCBIN "data/bank_15/Gfx_15_6700_Mode04_State00_Init.2bpp" ; $6700, 1280 bytes
; I: far pointer loaded by Mode0E_State06_ExchangeSetup, Mode0E_State0A_ExchangeSetupB (ld a,BANK; ld hl,ADDR; call
; banked copy/far call). L3 pass 2026-10-26: read in BGB in 37 replay(s), modes 04 (states 04:00), not only by the
; consumer the name gives: a shared asset or table; first organic loader in ...
Gfx_15_6C00_Mode0E_State06_ExchangeSetup::
    INCBIN "data/bank_15/Gfx_15_6C00_Mode0E_State06_ExchangeSetup.2bpp" ; $6C00, 768 bytes
; I: copied to VRAM/WRAM by Mode0E_State06_ExchangeSetup, Mode0E_State0A_ExchangeSetupB
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in the scenarios link_exchange 0E:06,
; link_exchange 0E:0A (tcrf_check/assets/l3_names/scen_hits*.csv)
Gfx_15_6C00_Mode0E_State06_ExchangeSetup_Part6F00::
    INCBIN "data/bank_15/Gfx_15_6C00_Mode0E_State06_ExchangeSetup_Part6F00.2bpp" ; $6F00, 1280 bytes
; I: copied to VRAM/WRAM by Mode0E_State06_ExchangeSetup, Mode0E_State0A_ExchangeSetupB
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in the scenarios link_exchange 0E:06,
; link_exchange 0E:0A (tcrf_check/assets/l3_names/scen_hits*.csv)
Gfx_15_7400_Mode0E_State06_ExchangeSetup::
    db $e3, $ff, $f1, $ff, $ff, $ff, $bf, $7f, $5f, $3f, $0f, $1f, $a7, $0f, $47, $03
    db $e3, $ff, $f7, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f9, $fe, $fa, $fd, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $cf, $ff, $c7, $c7
    db $08, $ff, $a4, $5f, $2a, $ff, $5f, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $fc, $fe
    db $15, $ea, $2a, $d5, $00, $ff, $08, $f7, $a0, $ff, $80, $7f, $31, $0e, $17, $00
    db $aa, $00, $45, $00, $aa, $00, $00, $00, $aa, $00, $00, $00, $aa, $00, $00, $00
    db $aa, $00, $51, $00, $aa, $00, $10, $00, $aa, $00, $00, $00, $aa, $00, $00, $00
    db $0a, $ff, $55, $0f, $ab, $00, $10, $00, $aa, $00, $00, $00, $a2, $00, $01, $00
    db $af, $ff, $5d, $ff, $be, $0f, $18, $07, $b5, $0a, $7f, $00, $de, $20, $f0, $00
    db $ea, $ff, $c5, $ff, $a8, $ff, $4e, $f1, $54, $ab, $5c, $03, $ac, $03, $07, $00
    db $99, $ee, $58, $e7, $9d, $e2, $3f, $c0, $97, $e8, $3f, $c0, $7f, $80, $fd, $00
    db $40, $bf, $20, $df, $c1, $3e, $ff, $00, $fe, $00, $d4, $00, $a0, $00, $00, $00
    db $95, $ea, $2b, $d4, $c5, $3a, $ef, $10, $f5, $0a, $7a, $05, $3d, $02, $1e, $01
    db $60, $80, $c0, $00, $fb, $00, $fd, $00, $54, $a8, $b0, $40, $50, $a0, $b0, $40
    db $d4, $2b, $7a, $05, $d4, $2b, $ea, $15, $30, $0f, $1a, $05, $02, $0f, $00, $07
    db $32, $f8, $18, $f0, $3a, $f0, $98, $70, $3a, $f0, $20, $f0, $32, $e0, $50, $e0
    db $ad, $03, $42, $01, $ab, $00, $11, $00, $a8, $00, $00, $00, $80, $00, $01, $00
    db $af, $ff, $47, $ff, $22, $ff, $ae, $51, $17, $e8, $3f, $40, $c5, $3a, $8b, $74
    db $81, $c3, $40, $80, $80, $00, $80, $00, $00, $80, $80, $00, $40, $80, $f0, $00
    db $fe, $fc, $78, $fc, $78, $38, $28, $10, $00, $00, $00, $00, $00, $00, $00, $00
    db $0d, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $aa, $00, $00, $00, $aa, $00, $00, $00, $2a, $00, $00, $00, $00, $00, $00, $00
    db $a9, $00, $01, $00, $2b, $00, $01, $00, $ab, $00, $01, $00, $23, $00, $01, $00
    db $68, $80, $c0, $00, $e0, $00, $d0, $00, $68, $80, $d0, $00, $f8, $00, $f0, $00
    db $05, $02, $03, $04, $05, $02, $03, $04, $01, $06, $03, $04, $0d, $02, $03, $04
    db $7e, $80, $c0, $00, $c0, $00, $80, $00, $84, $38, $5f, $3c, $3a, $7f, $32, $7d
    db $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $81, $00, $18, $00
    db $0f, $00, $87, $00, $cd, $02, $27, $40, $17, $e8, $84, $78, $49, $be, $e1, $1f
    db $10, $e0, $b0, $40, $40, $a0, $e0, $00, $8a, $00, $00, $00, $d0, $28, $13, $fc
    db $04, $03, $02, $01, $00, $03, $7e, $01, $f0, $0f, $7a, $05, $34, $0b, $fa, $05
    db $ca, $e0, $80, $c0, $42, $80, $80, $00, $88, $00, $80, $00, $80, $00, $80, $00
    db $83, $00, $06, $01, $0d, $02, $1a, $05, $b5, $0a, $2b, $14, $45, $3a, $4f, $30
    db $09, $fe, $a4, $5f, $52, $af, $fa, $05, $75, $8a, $ff, $00, $ff, $00, $ff, $00
    db $50, $a8, $3f, $c0, $85, $fa, $02, $fd, $0e, $ff, $a7, $5f, $d3, $2f, $fd, $03
    db $00, $00, $80, $00, $6a, $80, $ff, $00, $57, $a8, $3f, $c0, $9d, $e2, $ef, $d0
    db $00, $00, $10, $00, $b8, $00, $c0, $00, $ea, $00, $ff, $00, $5f, $a0, $fc, $00
    db $7e, $80, $fd, $00, $5f, $a0, $ff, $00, $55, $2a, $1f, $00, $0d, $02, $06, $01
    db $89, $06, $5b, $04, $fd, $02, $fb, $04, $51, $ae, $e6, $1d, $3d, $fe, $7c, $ff
    db $78, $7c, $5c, $7c, $2a, $7c, $54, $3c, $8e, $3c, $9e, $1c, $5e, $8e, $c7, $0e
    db $00, $08, $0c, $00, $84, $00, $46, $00, $41, $22, $33, $01, $01, $31, $30, $19
    db $3f, $ff, $3f, $7f, $7f, $3f, $1f, $3f, $1f, $3f, $9f, $1f, $bf, $ff, $ff, $ff
    db $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $15, $ff
    db $94, $eb, $d2, $fd, $fe, $ff, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $80, $00, $80, $00, $80, $00, $00, $00, $00, $80, $80, $c0, $e0, $c0, $e0, $e0
    db $97, $68, $af, $50, $15, $ea, $af, $50, $17, $e8, $af, $50, $01, $fe, $80, $7f
    db $77, $88, $ff, $00, $df, $20, $ff, $00, $55, $aa, $fb, $04, $d5, $2a, $ff, $00
    db $74, $8b, $fe, $01, $df, $20, $ff, $00, $55, $aa, $ff, $00, $57, $a8, $f2, $01
    db $f5, $ea, $4b, $f4, $25, $fa, $92, $7d, $48, $bf, $a2, $5d, $f0, $00, $00, $00
    db $68, $80, $c0, $00, $e0, $00, $ff, $00, $10, $ef, $05, $ff, $2b, $07, $00, $01
    db $00, $00, $00, $00, $60, $00, $3a, $45, $0a, $7f, $00, $7f, $22, $7f, $00, $7f
    db $00, $00, $00, $00, $00, $00, $00, $00, $40, $80, $20, $c0, $00, $e0, $10, $e0
    db $01, $03, $03, $07, $0b, $07, $1f, $07, $1f, $0f, $0f, $1f, $0f, $1f, $3f, $1f
    db $fa, $ff, $d5, $ff, $ef, $ff, $c5, $ff, $8f, $ff, $1d, $ff, $bf, $ff, $37, $ff
    db $0e, $ff, $3f, $df, $bf, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $0b, $1f, $8e, $1f, $88, $9f, $a9, $d0, $e0, $f0, $c8, $f0, $f4, $f8, $f3, $fc
    db $ba, $ff, $00, $ff, $0a, $ff, $00, $ff, $8a, $ff, $40, $ff, $0a, $ff, $11, $ff
    db $ab, $ff, $05, $ff, $af, $ff, $17, $ff, $af, $ff, $45, $ff, $7b, $ff, $7d, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ef, $ff, $47, $ff
    db $f0, $e0, $f0, $f0, $f8, $f0, $f8, $f0, $f0, $f8, $f0, $f8, $f0, $f8, $f8, $f8
    db $6a, $ff, $e4, $5f, $12, $ef, $a9, $57, $12, $ef, $a9, $57, $16, $eb, $a9, $57
    db $54, $aa, $3c, $c0, $98, $e0, $30, $c0, $81, $e0, $03, $c1, $c0, $83, $42, $80
    db $04, $08, $30, $00, $60, $00, $40, $00, $c0, $80, $00, $80, $00, $00, $00, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $55, $aa, $bf, $40, $55, $aa, $fe, $01, $55, $aa, $fa, $05, $d5, $2a, $fe, $01
    db $55, $aa, $bb, $44, $55, $aa, $ff, $00, $55, $aa, $ab, $54, $54, $ab, $aa, $55
    db $55, $aa, $fa, $05, $d4, $2b, $ea, $15, $50, $af, $aa, $55, $54, $ab, $ea, $15
    db $10, $ef, $a0, $5f, $40, $bf, $a9, $57, $02, $ff, $a1, $5f, $03, $ff, $85, $7f
    db $57, $a8, $7e, $81, $5b, $a0, $f2, $01, $79, $82, $32, $c1, $e0, $83, $46, $81
    db $55, $aa, $bb, $44, $55, $aa, $ff, $00, $55, $aa, $ff, $00, $d5, $2a, $ff, $00
    db $51, $ae, $aa, $54, $5c, $a2, $fe, $00, $7e, $80, $dc, $00, $f8, $00, $70, $00
    db $6f, $3f, $31, $1f, $23, $1f, $01, $1f, $02, $1f, $09, $17, $33, $1f, $31, $1f
    db $e4, $83, $44, $83, $cd, $82, $09, $c6, $c0, $ee, $46, $fc, $ea, $fc, $f0, $fc
    db $d5, $2a, $7f, $00, $1d, $22, $3f, $00, $35, $0a, $1f, $00, $3d, $02, $1f, $00
    db $80, $00, $00, $00, $00, $00, $00, $01, $02, $01, $04, $00, $00, $00, $00, $00
    db $38, $3f, $3a, $7d, $7c, $fb, $f6, $f9, $f5, $fa, $aa, $55, $b5, $4a, $5f, $00
    db $fc, $f8, $70, $fc, $61, $fe, $8b, $77, $3b, $ff, $9d, $7f, $4f, $bf, $e5, $1f
    db $35, $0a, $7b, $04, $5d, $a2, $fb, $04, $a7, $cc, $f7, $cc, $db, $ec, $5b, $fc
    db $87, $08, $0f, $00, $15, $0a, $1f, $00, $17, $08, $3f, $00, $62, $00, $40, $00
    db $53, $af, $ab, $55, $54, $ab, $fa, $05, $71, $8e, $f4, $0f, $fe, $0f, $67, $1f
    db $fb, $fc, $7b, $fc, $fd, $fa, $ff, $78, $7f, $f8, $7b, $fc, $fd, $fa, $f7, $f8
    db $00, $00, $00, $00, $00, $00, $00, $00, $06, $08, $22, $1d, $04, $fb, $aa, $55
    db $80, $00, $00, $00, $06, $00, $04, $07, $0f, $07, $c5, $0f, $0f, $ef, $8d, $7f
    db $cf, $3f, $6f, $1f, $cf, $3f, $9f, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $fd, $fa, $f3, $fc, $f5, $fa, $f2, $fc, $f8, $fe, $d0, $fc, $80, $fc, $80, $fc
    db $15, $ea, $2f, $d0, $06, $f8, $8b, $74, $01, $fe, $a2, $5d, $00, $ff, $a8, $57
    db $0f, $ff, $a7, $5f, $cf, $3f, $e7, $1f, $0f, $ff, $a7, $5f, $0f, $ff, $9f, $7f
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $de, $ef, $8d, $c0, $c0, $80, $80, $80
    db $88, $fc, $21, $dc, $f5, $88, $f1, $0c, $71, $8c, $f8, $05, $dc, $23, $7e, $01
    db $00, $ff, $a1, $5f, $43, $bf, $a9, $57, $43, $bf, $a1, $5f, $41, $be, $a2, $5c
    db $bf, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $ff, $c6, $3f, $02, $04
    db $80, $80, $00, $80, $00, $80, $00, $00, $00, $00, $00, $00, $01, $00, $01, $00
    db $5c, $22, $7e, $00, $dc, $22, $6e, $10, $5c, $a2, $a7, $50, $59, $a2, $96, $61
    db $08, $fe, $a0, $5c, $06, $f8, $8c, $70, $be, $e0, $3c, $c0, $d8, $20, $f0, $00
    db $04, $00, $08, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $03, $00, $03, $00, $05, $02, $06, $01, $05, $0a, $1f, $00, $1d, $22, $5f, $00
    db $18, $e3, $b6, $41, $18, $e1, $b1, $40, $28, $c0, $b0, $40, $00, $e0, $a0, $40
    db $a0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $01, $00, $07, $00, $04, $08, $30, $00, $01, $80, $03, $00, $05, $02, $0f, $00
    db $35, $8a, $3b, $04, $55, $2a, $ff, $00, $57, $a8, $f7, $00, $e5, $02, $06, $01
    db $00, $e0, $a0, $40, $00, $e0, $a0, $40, $00, $e1, $a1, $43, $03, $c7, $0f, $c7
    db $00, $00, $00, $00, $00, $00, $07, $00, $f6, $08, $fc, $00, $a0, $00, $02, $01
    db $36, $08, $7c, $00, $f0, $00, $40, $00, $03, $00, $7a, $05, $c2, $3f, $00, $ff
    db $0c, $03, $18, $07, $33, $0e, $62, $1c, $0c, $f8, $08, $f0, $90, $e0, $e0, $00
    db $4f, $8f, $8f, $1f, $1f, $1f, $1f, $1f, $0f, $1f, $0f, $1f, $2f, $1f, $27, $1f
    db $0c, $03, $18, $07, $c2, $3f, $80, $7f, $eb, $fe, $f3, $fc, $f9, $fe, $54, $ff
    db $89, $fe, $2b, $d4, $5f, $a0, $ff, $00, $77, $88, $ff, $00, $ff, $00, $ff, $00
    db $40, $80, $00, $00, $83, $00, $07, $00, $ad, $02, $de, $01, $f4, $0b, $f8, $07
    db $de, $2f, $e0, $1f, $c0, $3f, $88, $77, $00, $ff, $00, $ff, $20, $ff, $00, $ff
    db $be, $7f, $2d, $1f, $17, $0f, $01, $07, $07, $03, $02, $01, $00, $00, $00, $00
    db $a7, $c8, $6f, $d0, $a5, $fa, $42, $fd, $e8, $ff, $64, $df, $4e, $83, $02, $01
    db $52, $af, $a4, $5f, $2a, $ff, $10, $ff, $ea, $ff, $55, $ff, $3b, $ff, $55, $ff

    db $a8, $ff, $00, $ff, $a2, $ff, $01, $ff, $aa, $ff, $55, $ff, $ff, $ff, $55

    ; padding
    ds $11, $ff

    ; padding
    ds $64, $00

    db $07, $07, $07, $04, $ff, $ff, $ff, $24, $ff, $04, $ff, $1c, $f7, $34, $e7, $24
    db $e7, $24, $e7, $24, $e7, $24, $e7, $e7, $00, $00, $00, $00, $00, $00, $00, $00
    db $80, $80, $80, $80, $ff, $ff, $ff, $91, $ff, $80, $ff, $8c, $ff, $9c, $f7, $94
    db $f7, $94, $f7, $94, $f7, $94, $f7, $f7, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $7f, $7f, $ff, $c1, $ff, $81, $ff, $99, $ff, $99, $ff, $99
    db $ff, $81, $ff, $c1, $ff, $f9, $ff, $c1, $7f, $43, $7e, $7e

    ; padding
    ds $20, $00

; I: copied to VRAM/WRAM by Mode0E_State06_ExchangeSetup, Mode0E_State0A_ExchangeSetupB
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in the scenarios link_exchange 0E:06,
; link_exchange 0E:0A (tcrf_check/assets/l3_names/scen_hits*.csv)
Gfx_15_7C00_Mode0E_State06_ExchangeSetup::
    INCBIN "data/bank_15/Gfx_15_7C00_Mode0E_State06_ExchangeSetup.2bpp" ; $7C00, 1024 bytes
