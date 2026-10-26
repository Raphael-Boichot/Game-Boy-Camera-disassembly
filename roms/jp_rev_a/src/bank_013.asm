; Pocket Camera (Japan) (Rev A), bank $13. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $013", ROMX[$4000], BANK[$13]

; C: copied to VRAM/WRAM by Mode02_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 35 replay(s) of the organic corpus, modes 02 (tcrf_check/assets/l3_names/)
Gfx_13_4000_Mode02_State00_Init::
    INCBIN "data/bank_13/Gfx_13_4000_Mode02_State00_Init.2bpp" ; $4000, 2048 bytes
; C: copied to VRAM/WRAM by Mode02_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 35 replay(s) of the organic corpus, modes 02 (tcrf_check/assets/l3_names/)
Gfx_13_4800_Mode02_State00_Init::
    INCBIN "data/bank_13/Gfx_13_4800_Mode02_State00_Init.2bpp" ; $4800, 2048 bytes
; C: copied to VRAM/WRAM by Mode02_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 35 replay(s) of the organic corpus, modes 02 (tcrf_check/assets/l3_names/)
Gfx_13_5000_Mode02_State00_Init::
    INCBIN "data/bank_13/Gfx_13_5000_Mode02_State00_Init.2bpp" ; $5000, 2048 bytes
; C: copied to VRAM/WRAM by PhotoPicker_Init, PhotoPicker_LoadPageTabsFor, PhotoPicker_LoadPageTabs2For,
; Mode0F_State00_Init, Mode0F_State01_ReInit, LinkPick_Substate0_Init, LinkPick_PageTilesRight, LinkPick_PageTilesLeft
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 83 ...
Gfx_13_5800_Mode0F_State00_Init::
    INCBIN "data/bank_13/Gfx_13_5800_Mode0F_State00_Init.2bpp" ; $5800, 48 bytes
; C: far pointer loaded by PhotoPicker_LoadPageTabsFor, PhotoPicker_LoadPageTabs2For, LinkPick_PageTilesRight,
; LinkPick_PageTilesLeft (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass 2026-10-26: read in BGB in 83
; replay(s) of the organic corpus, modes 0A 0F 10 11 1A 1C ...
Gfx_13_5830_PhotoPicker_LoadPageTabsFor::
    INCBIN "data/bank_13/Gfx_13_5830_PhotoPicker_LoadPageTabsFor.2bpp" ; $5830, 80 bytes
; C: far pointer loaded by Mode0F_State0A_EraseAll (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 83 replay(s) of the organic corpus, modes 0A 0F 10 11 1A 1C (tcrf_check/assets/l3_names/)
Gfx_13_5880_Mode0F_State0A_EraseAll::
    INCBIN "data/bank_13/Gfx_13_5880_Mode0F_State0A_EraseAll.2bpp" ; $5880, 208 bytes
; C: far pointer loaded by Mode0F_DrawCopyCount (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 83 replay(s) of the organic corpus, modes 0A 0F 10 11 1A 1C (tcrf_check/assets/l3_names/)
Gfx_13_5950_Mode0F_DrawCopyCount::
    INCBIN "data/bank_13/Gfx_13_5950_Mode0F_DrawCopyCount.2bpp" ; $5950, 848 bytes
; C: TCRF unused hand gestures, exact match: the TCRF picture (Game_Boy_Camera_Unused_Album_Hand_Gestures.png, a 2x
; enlargement) is 31 cells of 8 x 8 plus the left half of 13:5A50, every one an exact tile of the sheet 13:5A00-5FFF
; (13:5CA0-5CF0 / 5DA0-5DF0 / 5EA0-5EF0 as a 6 x 3 block, 5AE0-5AF0, ...
Unused_TCRF_AlbumHandGestures_Gfx::
    INCBIN "data/bank_13/Unused_TCRF_AlbumHandGestures_Gfx.2bpp" ; $5CA0, 96 bytes
; C: continues the sheet 13:5800-67FF that the album loaders copy whole to $8000 (copy site 04:403B, 4,096 B); the
; label before is the TCRF hand-gesture block 13:5CA0. L3 pass 2026-10-26: read in BGB in 83 replay(s) of the organic
; corpus, modes 0A 0F 10 11 1A 1C (tcrf_check/assets/l3_names/)
Gfx_13_5D00_Mode0F_State00_Init_Cont::
    INCBIN "data/bank_13/Gfx_13_5D00_Mode0F_State00_Init_Cont.2bpp" ; $5D00, 1792 bytes
; C: far pointer loaded by LinkPick_LoadPageThumbs, PhotoPicker_LoadPageThumbs (ld a,BANK; ld hl,ADDR; call banked
; copy/far call). L3 pass 2026-10-26: read in BGB in 83 replay(s) of the organic corpus, modes 0A 0F 10 11 1A 1C
; (tcrf_check/assets/l3_names/)
Src_13_6400_PhotoPicker_LoadPageThumbs::
    INCBIN "data/bank_13/Src_13_6400_PhotoPicker_LoadPageThumbs.bin" ; $6400, 1024 bytes
; C: entry 0 of the {lo,hi,bank} table 04:44DC, 256 bytes each (constant pitch)
Gfx_13_6800_Icon04_44DC::
    INCBIN "data/bank_13/Gfx_13_6800_Icon04_44DC.2bpp" ; $6800, 256 bytes
; C: entry 1 of the {lo,hi,bank} table 04:44DC, 256 bytes each (constant pitch)
Gfx_13_6900_Icon04_44DC::
    INCBIN "data/bank_13/Gfx_13_6900_Icon04_44DC.2bpp" ; $6900, 256 bytes
; C: entry 2 of the {lo,hi,bank} table 04:44DC, 256 bytes each (constant pitch)
Gfx_13_6A00_Icon04_44DC::
    INCBIN "data/bank_13/Gfx_13_6A00_Icon04_44DC.2bpp" ; $6A00, 256 bytes
; C: entry 3 of the {lo,hi,bank} table 04:44DC, 256 bytes each (constant pitch)
Gfx_13_6B00_Icon04_44DC::
    INCBIN "data/bank_13/Gfx_13_6B00_Icon04_44DC.2bpp" ; $6B00, 256 bytes
; C: entry 4 of the {lo,hi,bank} table 04:44DC, 256 bytes each (constant pitch)
Gfx_13_6C00_Icon04_44DC::
    INCBIN "data/bank_13/Gfx_13_6C00_Icon04_44DC.2bpp" ; $6C00, 256 bytes
; C: entry 5 of the {lo,hi,bank} table 04:44DC, 256 bytes each (constant pitch)
Gfx_13_6D00_Icon04_44DC::
    INCBIN "data/bank_13/Gfx_13_6D00_Icon04_44DC.2bpp" ; $6D00, 256 bytes
; C: entry 6 of the {lo,hi,bank} table 04:44DC, 256 bytes each (constant pitch)
Gfx_13_6E00_Icon04_44DC::
    db $00, $00, $04, $0e, $0a, $0a, $25, $2f, $21, $21, $3d, $3d, $3d, $3d, $20, $20
    db $00, $00, $00, $00, $00, $00, $e8, $e8, $e8, $e8, $28, $28, $2e, $2e, $2e, $2e
    db $00, $00, $00, $00, $00, $00, $90, $90, $90, $90, $90, $90, $95, $95, $15, $15
    db $00, $00, $08, $1c, $14, $14, $f8, $fc, $f8, $f8, $08, $08, $08, $08, $88, $88
    db $20, $20, $1c, $3c, $0c, $1c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $28, $28, $48, $68, $88, $c8, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $11, $30, $61, $77, $46, $67, $00, $00, $00, $80, $00, $84, $00, $88, $00, $10
    db $98, $88, $30, $b8, $b0, $30, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $1f, $00, $10, $07, $10, $07, $11, $05, $13, $07, $13, $07, $13, $05, $13
    db $00, $ff, $00, $00, $77, $f8, $8e, $8d, $35, $37, $36, $37, $8f, $8e, $75, $76
    db $00, $c0, $00, $4e, $00, $40, $ff, $ff, $1c, $08, $f0, $f0, $13, $53, $16, $53
    db $00, $00, $00, $00, $00, $00, $80, $80, $e0, $60, $18, $1c, $14, $14, $14, $94
    db $07, $11, $07, $10, $00, $10, $00, $1f, $00, $00, $07, $00, $1f, $00, $00, $00
    db $8f, $8c, $77, $f8, $00, $00, $00, $ff, $00, $00, $ff, $00, $ff, $00, $00, $00
    db $1c, $5c, $0c, $48, $07, $44, $03, $c3, $00, $00, $8f, $00, $ff, $00, $07, $00
    db $bc, $d4, $fc, $94, $f8, $ec, $80, $80, $00, $00, $f8, $00, $f8, $00, $f0, $00

    ; padding
    ds $100, $00

; C: copied to VRAM/WRAM by Mode08_CreditsReal (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 6 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Gfx_13_7000_Mode08_CreditsReal::
    INCBIN "data/bank_13/Gfx_13_7000_Mode08_CreditsReal.2bpp" ; $7000, 2048 bytes
; C: copied to VRAM/WRAM by Mode08_CreditsReal (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 6 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Gfx_13_7800_Mode08_CreditsReal::
    INCBIN "data/bank_13/Gfx_13_7800_Mode08_CreditsReal.2bpp" ; $7800, 2048 bytes
