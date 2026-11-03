; Pocket Camera (Japan) (Rev A), bank $15. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


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
; C: copied to VRAM/WRAM by Mode00_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 203 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Gfx_15_4600_Mode00_State00_Init::
    INCBIN "data/bank_15/Gfx_15_4600_Mode00_State00_Init.2bpp" ; $4600, 768 bytes
; C: copied to VRAM/WRAM by Mode00_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 203 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Gfx_15_4900_Mode00_State00_Init::
    INCBIN "data/bank_15/Gfx_15_4900_Mode00_State00_Init.2bpp" ; $4900, 256 bytes
; C: copied to VRAM/WRAM by MainMenu_TransitionToLowerPage, Mode00_State04_Item3_Doodle, Mode00_State06_Item5_Special,
; Mode00_State07_Item6_Edit, MainMenu_LoadBackground (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 13 replay(s) of the organic corpus, modes 00 ...
Gfx_15_4A00_MainMenu_LoadBackground::
    INCBIN "data/bank_15/Gfx_15_4A00_MainMenu_LoadBackground.2bpp" ; $4A00, 256 bytes
; C: copied to VRAM/WRAM by MainMenu_TransitionToLowerPage, Mode00_State04_Item3_Doodle, Mode00_State05_Item4_Link,
; Mode00_State07_Item6_Edit, MainMenu_LoadBackground (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 26 replay(s) of the organic corpus, modes 00 ...
Gfx_15_4B00_MainMenu_LoadBackground::
    INCBIN "data/bank_15/Gfx_15_4B00_MainMenu_LoadBackground.2bpp" ; $4B00, 256 bytes
; C: copied to VRAM/WRAM by MainMenu_TransitionToLowerPage, Mode00_State04_Item3_Doodle, Mode00_State05_Item4_Link,
; Mode00_State06_Item5_Special, MainMenu_LoadBackground (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in 33 replay(s) of the organic corpus, modes 00 ...
Gfx_15_4C00_MainMenu_LoadBackground::
    INCBIN "data/bank_15/Gfx_15_4C00_MainMenu_LoadBackground.2bpp" ; $4C00, 256 bytes
; C: copied to VRAM/WRAM by MainMenu_TransitionToLowerPage, Mode00_State05_Item4_Link, Mode00_State06_Item5_Special,
; Mode00_State07_Item6_Edit, MainMenu_LoadBackground (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 72 replay(s) of the organic corpus, modes 00 ...
Gfx_15_4D00_MainMenu_LoadBackground::
    INCBIN "data/bank_15/Gfx_15_4D00_MainMenu_LoadBackground.2bpp" ; $4D00, 256 bytes
; C: copied to VRAM/WRAM by Mode00_State03_Item2_Arcade, MainMenu_LoadBaseTiles, MainMenu_DrawUpperItem2
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 203 replay(s) of the organic corpus, modes
; 00 (tcrf_check/assets/l3_names/)
Gfx_15_4E00_MainMenu_LoadBaseTiles::
    INCBIN "data/bank_15/Gfx_15_4E00_MainMenu_LoadBaseTiles.2bpp" ; $4E00, 512 bytes
; C: far pointer loaded by MainMenu_DrawUpperItem2 (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 512 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 14 replay(s) of the organic corpus, modes 00
; (tcrf_check/assets/l3_names/)
Gfx_15_5000_MainMenu_DrawUpperItem2::
    INCBIN "data/bank_15/Gfx_15_5000_MainMenu_DrawUpperItem2.2bpp" ; $5000, 512 bytes
; C: tile data with no direct pointer in the code (, same bank/neighbour of MainMenu_DrawUpperItem2); classified from
; its content - see sym_unconclusive. Owner (review page, 2026-10-13): graphic, by eye.
Gfx_15_5200_MainMenu_DrawUpperItem2_Aux::
    INCBIN "data/bank_15/Gfx_15_5200_MainMenu_DrawUpperItem2_Aux.2bpp" ; $5200, 512 bytes
; C: copied to VRAM/WRAM by Mode00_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 203 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Gfx_15_5400_Mode00_State00_Init::
    INCBIN "data/bank_15/Gfx_15_5400_Mode00_State00_Init.2bpp" ; $5400, 256 bytes
; C: tile data with no direct pointer in the code (, same bank/neighbour of SlidePlay_ReadKeys); classified from its
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
; C: copied to VRAM/WRAM by Mode04_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 37 replay(s) of the organic corpus, modes 04 (tcrf_check/assets/l3_names/)
Gfx_15_6700_Mode04_State00_Init::
    INCBIN "data/bank_15/Gfx_15_6700_Mode04_State00_Init.2bpp" ; $6700, 1280 bytes
; C: far pointer loaded by Mode0E_State06_ExchangeSetup, Mode0E_State0A_ExchangeSetupB (ld a,BANK; ld hl,ADDR; call
; banked copy/far call). L3 pass 2026-10-26: read in BGB in 37 replay(s), modes 04 (states 04:00), not only by the
; consumer the name gives: a shared asset or table; first organic loader in ...
Gfx_15_6C00_Mode0E_State06_ExchangeSetup::
    INCBIN "data/bank_15/Gfx_15_6C00_Mode0E_State06_ExchangeSetup.2bpp" ; $6C00, 768 bytes
; C: copied to VRAM/WRAM by Mode0E_State06_ExchangeSetup, Mode0E_State0A_ExchangeSetupB
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in the scenarios link_exchange 0E:06,
; link_exchange 0E:0A (tcrf_check/assets/l3_names/scen_hits*.csv)
Gfx_15_6C00_Mode0E_State06_ExchangeSetup_Part6F00::
    INCBIN "data/bank_15/Gfx_15_6C00_Mode0E_State06_ExchangeSetup_Part6F00.2bpp" ; $6F00, 1280 bytes
; C: copied to VRAM/WRAM by Mode0E_State06_ExchangeSetup, Mode0E_State0A_ExchangeSetupB
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in the scenarios link_exchange 0E:06,
; link_exchange 0E:0A (tcrf_check/assets/l3_names/scen_hits*.csv)
Gfx_15_7400_Mode0E_State06_ExchangeSetup::
    db $20, $c0, $00, $c0, $c0, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $0f, $01, $01, $0f, $05, $0f, $1a, $0f, $02, $1f, $0f, $3f, $5f, $3f, $be, $7f
    db $f8, $fc, $f8, $fc, $f8, $fc, $70, $ec, $aa, $74, $50, $bc, $9a, $fc, $40, $fc
    db $07, $03, $06, $03, $08, $07, $09, $06, $17, $0c, $1b, $0c, $0b, $1c, $16, $39
    db $d4, $00, $fe, $00, $e9, $00, $aa, $00, $b5, $00, $55, $00, $50, $00, $a0, $00
    db $d0, $00, $21, $00, $44, $00, $08, $00, $40, $00, $28, $00, $00, $00, $00, $00
    db $20, $00, $a0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $08, $00, $06, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $00
    db $20, $00, $c8, $00, $64, $00, $20, $00, $42, $00, $11, $40, $d0, $00, $00, $40
    db $00, $00, $10, $00, $00, $00, $40, $00, $00, $00, $50, $00, $03, $01, $07, $03
    db $01, $00, $a3, $01, $0b, $07, $1e, $0f, $7a, $3c, $70, $f8, $d2, $e1, $85, $c3
    db $75, $f8, $d1, $e3, $8b, $c7, $1f, $0e, $5e, $3c, $fc, $78, $e2, $f1, $a1, $c7
    db $c0, $e1, $e1, $83, $97, $03, $09, $07, $16, $0f, $9f, $7f, $7f, $ff, $ff, $ff
    db $fb, $f7, $e7, $ff, $bb, $ff, $74, $fb, $87, $7a, $26, $fb, $02, $ff, $25, $df
    db $b0, $c0, $f8, $ff, $fe, $ff, $f5, $fa, $72, $fd, $f9, $76, $ea, $75, $3c, $f3
    db $02, $01, $a3, $5f, $0f, $ff, $70, $8f, $7a, $87, $1e, $e3, $c5, $3b, $dd, $3f
    db $fb, $fc, $f8, $ff, $ff, $ff, $0d, $fe, $0c, $f8, $0c, $f8, $00, $fc, $86, $fc
    db $28, $f0, $e0, $c0, $c0, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $01, $00, $00, $00, $00, $01, $03, $01, $15, $03, $01, $07, $16, $0f
    db $6f, $30, $3d, $62, $de, $61, $76, $c9, $bd, $c3, $7b, $87, $74, $8f, $e4, $1f
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $3f, $7f, $7f, $3f, $6f, $3f, $1f, $3f, $1f, $3f, $3f, $1f, $2f, $1f, $3f, $1f
    db $df, $ff, $f8, $ff, $fe, $fd, $6f, $ff, $ff, $ff, $f7, $ff, $bf, $ff, $ed, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $7f, $ff, $ff, $ff, $7f, $ff, $ff, $ff, $bf, $ff
    db $9f, $ff, $bf, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $cd, $fe, $ea, $f7
    db $fd, $fe, $f8, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $79, $ff, $fb, $7c
    db $ca, $3d, $3d, $ff, $ff, $ff, $dd, $ff, $af, $dd, $ba, $cd, $ae, $d1, $28, $d7
    db $9f, $3f, $ff, $ff, $3f, $1f, $1f, $3f, $3f, $1f, $1f, $3f, $1f, $3f, $1f, $3f
    db $39, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $ff, $fc, $ff, $ff, $ff, $ff, $ff
    db $f7, $ff, $33, $ff, $e1, $ff, $04, $ff, $cd, $3e, $0f, $ff, $b3, $cf, $7e, $81
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $ff, $7f, $ff, $df, $ff, $bf, $ff
    db $1f, $ff, $ff, $ff, $ff, $7f, $7f, $7f, $ff, $7f, $3f, $7f, $bf, $7f, $bf, $7f
    db $fe, $ff, $fd, $fe, $fb, $fc, $f7, $f8, $ef, $f0, $cd, $f2, $9f, $60, $f6, $09
    db $ff, $00, $db, $24, $fc, $03, $6d, $93, $fb, $07, $a7, $5f, $eb, $1f, $ff, $39
    db $7b, $ff, $fd, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $7f, $ff, $ff, $ff, $8f, $ff, $af, $df, $ed, $df, $9f, $ff
    db $ff, $7f, $ff, $7f, $7f, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $df, $ff, $ff, $ff
    db $7f, $80, $6e, $91, $fc, $03, $d9, $27, $f2, $0f, $74, $8f, $ed, $1e, $d2, $3d
    db $ca, $7d, $4c, $ff, $bf, $ff, $3f, $ff, $5f, $bf, $7f, $ff, $bf, $7f, $7f, $bf
    db $ff, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $df, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fd, $ff, $fe, $fd
    db $7f, $ff, $df, $ff, $ff, $ff, $67, $ff, $ff, $ff, $b7, $ff, $ff, $ff, $f7, $fb
    db $8a, $75, $ed, $72, $4d, $f3, $bb, $f7, $b7, $ff, $1f, $ff, $df, $bf, $df, $bf
    db $7f, $bf, $9f, $7f, $ff, $3f, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ef, $df, $dd, $ef, $d4, $ef, $0e, $fd, $65, $9e, $c8, $ff, $c0, $ff, $89, $f7
    db $fc, $ff, $f8, $ff, $f8, $ff, $3d, $fe, $5e, $bd, $da, $bd, $be, $dd, $5b, $fc
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $3f, $c0, $3f, $c0, $3f, $c0, $00, $ff, $00, $ff, $03, $fc, $03, $fc, $03, $fc
    db $fe, $01, $fe, $01, $fe, $01, $0e, $f1, $0e, $f1, $bc, $43, $bc, $43, $b0, $4f
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $01, $fe, $03, $fc, $07, $f8
    db $20, $df, $30, $cf, $78, $87, $f0, $0f, $e1, $1e, $c1, $3e, $c1, $3e, $80, $7f
    db $3f, $c0, $3f, $c0, $3f, $c0, $00, $ff, $ff, $00, $ff, $00, $ff, $00, $0e, $f1
    db $b6, $49, $b6, $49, $b6, $49, $00, $ff, $f0, $0f, $f0, $0f, $f0, $0f, $00, $ff
    db $00, $ff, $0c, $f3, $0c, $f3, $0c, $f3, $7f, $80, $7f, $80, $0c, $f3, $0c, $f3
    db $09, $f6, $0c, $f3, $04, $fb, $18, $e7, $9c, $63, $ce, $31, $c6, $39, $c6, $39
    db $00, $ff, $18, $e7, $18, $e7, $38, $c7, $30, $cf, $30, $cf, $30, $cf, $30, $cf
    db $00, $ff, $00, $ff, $18, $e7, $1c, $e3, $0c, $f3, $06, $f9, $06, $f9, $07, $f8
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $03, $fc, $0f, $f0, $3e, $c1
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $f0, $0f, $f8, $07, $9c, $63, $0c, $f3
    db $30, $cf, $30, $cf, $70, $8f, $60, $9f, $67, $98, $67, $98, $60, $9f, $60, $9f
    db $0e, $f1, $6a, $95, $6e, $91, $60, $9f, $f8, $07, $f8, $07, $60, $9f, $60, $9f
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $36, $c9, $36, $c9
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $03, $fc, $03, $fc, $03, $fc, $07, $f8, $0f, $f0, $0e, $f1, $0c, $f3, $00, $ff
    db $80, $7f, $80, $7f, $80, $7f, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $1f, $e0, $7d, $82, $79, $86, $61, $9e, $01, $fe, $01, $fe, $01, $fe, $01, $fe
    db $80, $7f, $80, $7f, $80, $7f, $80, $7f, $80, $7f, $80, $7f, $80, $7f, $80, $7f
    db $0e, $f1, $0e, $f1, $0e, $f1, $1e, $e1, $1c, $e3, $7c, $83, $78, $87, $38, $c7
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $0c, $f3, $1c, $e3, $18, $e7, $39, $c6, $77, $88, $67, $98, $00, $ff, $00, $ff
    db $c0, $3f, $c0, $3f, $c0, $3f, $c0, $3f, $80, $7f, $00, $ff, $00, $ff, $00, $ff
    db $30, $cf, $38, $c7, $18, $e7, $1d, $e2, $0f, $f0, $06, $f9, $00, $ff, $00, $ff
    db $03, $fc, $03, $fc, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $18, $e7, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $01, $fe, $01, $fe, $00, $ff
    db $0c, $f3, $0c, $f3, $1c, $e3, $38, $c7, $70, $8f, $e0, $1f, $80, $7f, $00, $ff
    db $60, $9f, $60, $9f, $60, $9f, $61, $9e, $63, $9c, $63, $9c, $33, $cc, $31, $ce
    db $60, $9f, $60, $9f, $60, $9f, $e0, $1f, $f8, $07, $7c, $83, $cc, $33, $80, $7f
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $02, $fd, $03, $fc
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $c0, $3f, $c0, $3f, $c0, $3f, $ff, $00, $ff, $00, $fc, $03, $fc, $03, $fc, $03
    db $01, $fe, $01, $fe, $01, $fe, $f1, $0e, $f1, $0e, $43, $bc, $43, $bc, $4f, $b0
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $fe, $01, $fc, $03, $f8, $07
    db $df, $20, $cf, $30, $87, $78, $0f, $f0, $1e, $e1, $3e, $c1, $3e, $c1, $7f, $80
    db $c0, $3f, $c0, $3f, $c0, $3f, $ff, $00, $00, $ff, $00, $ff, $00, $ff, $f1, $0e
    db $49, $b6, $49, $b6, $49, $b6, $ff, $00, $0f, $f0, $0f, $f0, $0f, $f0, $ff, $00
    db $ff, $00, $f3, $0c, $f3, $0c, $f3, $0c, $80, $7f, $80, $7f, $f3, $0c, $f3, $0c
    db $f6, $09, $f3, $0c, $fb, $04, $e7, $18, $63, $9c, $31, $ce, $39, $c6, $39, $c6
    db $ff, $00, $e7, $18, $e7, $18, $c7, $38, $cf, $30, $cf, $30, $cf, $30, $cf, $30
    db $ff, $00, $ff, $00, $e7, $18, $e3, $1c, $f3, $0c, $f9, $06, $f9, $06, $f8, $07
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $fc, $03, $f0, $0f, $c1, $3e
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $0f, $f0, $07, $f8, $63, $9c, $f3, $0c
    db $cf, $30, $cf, $30, $8f, $70, $9f, $60, $98, $67, $98, $67, $9f, $60, $9f, $60
    db $f1, $0e, $95, $6a, $91, $6e, $9f, $60, $07, $f8, $07, $f8, $9f, $60, $9f, $60
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $c9, $36, $c9, $36
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $fc, $03, $fc, $03, $fc, $03, $f8, $07, $f0, $0f, $f1, $0e, $f3, $0c, $ff, $00
    db $7f, $80, $7f, $80, $7f, $80, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $e0, $1f, $82, $7d, $86, $79, $9e, $61, $fe, $01, $fe, $01, $fe, $01, $fe, $01
    db $7f, $80, $7f, $80, $7f, $80, $7f, $80, $7f, $80, $7f, $80, $7f, $80, $7f, $80
    db $f1, $0e, $f1, $0e, $f1, $0e, $e1, $1e, $e3, $1c, $83, $7c, $87, $78, $c7, $38
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $f3, $0c, $e3, $1c, $e7, $18, $c6, $39, $88, $77, $98, $67, $ff, $00, $ff, $00
    db $3f, $c0, $3f, $c0, $3f, $c0, $3f, $c0, $7f, $80, $ff, $00, $ff, $00, $ff, $00
    db $cf, $30, $c7, $38, $e7, $18, $e2, $1d, $f0, $0f, $f9, $06, $ff, $00, $ff, $00
    db $fc, $03, $fc, $03, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $e7, $18, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $fe, $01, $fe, $01, $ff, $00
    db $f3, $0c, $f3, $0c, $e3, $1c, $c7, $38, $8f, $70, $1f, $e0, $7f, $80, $ff, $00
    db $9f, $60, $9f, $60, $9f, $60, $9e, $61, $9c, $63, $9c, $63, $cc, $33, $ce, $31
    db $9f, $60, $9f, $60, $9f, $60, $1f, $e0, $07, $f8, $83, $7c, $33, $cc, $7f, $80
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $fd, $02, $fc, $03
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $100, $00

; C: copied to VRAM/WRAM by Mode0E_State06_ExchangeSetup, Mode0E_State0A_ExchangeSetupB
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in the scenarios link_exchange 0E:06,
; link_exchange 0E:0A (tcrf_check/assets/l3_names/scen_hits*.csv)
Gfx_15_7C00_Mode0E_State06_ExchangeSetup::
    INCBIN "data/bank_15/Gfx_15_7C00_Mode0E_State06_ExchangeSetup.2bpp" ; $7C00, 1024 bytes
