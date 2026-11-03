; Pocket Camera (Japan) (Rev A), bank $0F. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $00f", ROMX[$4000], BANK[$f]

; C: copied to VRAM/WRAM by Mode08_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 15 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Gfx_0F_4000_Mode08_State00_Init::
    INCBIN "data/bank_0f/Gfx_0F_4000_Mode08_State00_Init.2bpp" ; $4000, 2048 bytes
; C: copied to VRAM/WRAM by Mode08_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 15 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Gfx_0F_4800_Mode08_State00_Init::
    INCBIN "data/bank_0f/Gfx_0F_4800_Mode08_State00_Init.2bpp" ; $4800, 2048 bytes
; C: copied to VRAM/WRAM by Mode08_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 15 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Gfx_0F_5000_Mode08_State00_Init::
    INCBIN "data/bank_0f/Gfx_0F_5000_Mode08_State00_Init.2bpp" ; $5000, 1280 bytes
; C: far pointer loaded by UserMap_LoadPlanetTiles (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 15 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Gfx_0F_5500_UserMap_LoadPlanetTiles::
    INCBIN "data/bank_0f/Gfx_0F_5500_UserMap_LoadPlanetTiles.2bpp" ; $5500, 640 bytes
; C: 40 tiles (640 bytes) copied whole to $8500 by UserMap_LoadPlanetTiles (copy site 09:51DC,
; roms/jp_rev_a/assets/copy_sites_jp.csv); the four planet sets are 5500 / 5780 / 5A00 / 5C80; the labels 5800 (Aux),
; 5904 (Unref), 596C and 5984 (Data) inside it were fill-run splits
Gfx_0F_5780_UserMap_LoadPlanetTiles::
    INCBIN "data/bank_0f/Gfx_0F_5780_UserMap_LoadPlanetTiles.2bpp" ; $5780, 640 bytes
; C: far pointer loaded by UserMap_LoadPlanetTiles (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 640 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 8 replay(s) of the organic corpus, modes 08
; (tcrf_check/assets/l3_names/)
Gfx_0F_5A00_UserMap_LoadPlanetTiles::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $01, $02, $07, $04, $02, $05, $06, $05, $06, $05
    db $03, $02, $06, $05, $02, $05, $01, $02, $01, $01, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $e1, $22, $32, $55, $26, $10, $2c, $1a, $94, $ba
    db $dc, $3a, $a4, $da, $74, $42, $56, $b5, $02, $c3, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $83, $44, $64, $ab, $4c, $20, $28, $54, $48, $74
    db $08, $14, $58, $74, $27, $4b, $63, $a4, $40, $c0, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $0e, $81, $8c, $43, $4c, $80, $4c, $a0, $44, $a8
    db $44, $ab, $60, $af, $80, $4c, $08, $84, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $08, $8f, $87, $48, $44, $a2, $44, $a2, $67, $a0
    db $84, $43, $84, $4a, $64, $ab, $2f, $48, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $c0, $e0, $20, $00, $00, $00, $00, $80, $40
    db $40, $c0, $00, $00, $40, $c0, $80, $40, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $01, $01, $03, $00, $03, $03, $00, $00, $00, $00
    db $00, $00, $01, $01, $05, $06, $07, $05, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $70, $88, $8d, $75, $08, $10, $38, $28, $20, $10
    db $38, $48, $cc, $14, $8f, $83, $02, $06, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $1c, $62, $e3, $1c, $c1, $c0, $01, $00, $01, $00
    db $01, $00, $01, $02, $0f, $f0, $f0, $0f, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $01, $01, $2f, $30, $f7, $cf, $a4, $a2, $84, $82, $86, $8b
    db $89, $85, $0c, $14, $b8, $a8, $00, $10, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $c0, $00, $e0, $a0, $e0, $a0, $00, $c0, $80

    ; padding
    ds $71, $00

; C: far pointer loaded by UserMap_LoadPlanetTiles (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 640 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 7 replay(s) of the organic corpus, modes 08
; (tcrf_check/assets/l3_names/)
Gfx_0F_5C80_UserMap_LoadPlanetTiles::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $0e, $11, $39, $22, $11, $28, $11, $28
    db $34, $2d, $1e, $11, $3d, $2e, $13, $2a, $0a, $15, $08, $0e, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $05, $7c, $7f, $82, $13, $aa, $32, $a9
    db $93, $89, $92, $8d, $13, $8c, $94, $0a, $96, $8a, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $c8, $4f, $87, $48, $44, $8a, $44, $8a
    db $c4, $ab, $47, $a8, $e4, $0a, $24, $4a, $34, $5a, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $61, $ff, $9e, $61, $10, $28, $10, $28
    db $51, $ef, $9e, $61, $30, $28, $10, $28, $10, $28, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $0e, $01, $0c, $03, $0c, $00, $0c, $00
    db $04, $08, $04, $0b, $02, $0f, $00, $0c, $08, $04, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $07, $84, $8e, $49, $44, $aa, $4c, $a0
    db $6c, $a0, $8c, $40, $84, $48, $6c, $aa, $25, $46, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $4a, $ce, $c4, $0a, $c4, $aa, $64, $0a
    db $64, $0a, $6c, $0a, $c4, $a2, $64, $a3, $c7, $40, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $50, $70, $20, $50, $20, $50, $20, $50
    db $20, $50, $60, $50, $20, $10, $20, $9c, $bc, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $17, $18, $38, $07, $30, $31, $03, $02, $02, $01
    db $07, $00, $18, $15, $58, $68, $40, $60, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $01, $87, $cf, $48, $87, $0b, $9c, $94, $1c, $0a
    db $87, $84, $c1, $40, $e1, $22, $27, $65, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $60, $80, $98, $68, $18, $0b, $3b, $2a, $71, $50
    db $41, $a1, $80, $40, $00, $80, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $41, $41, $40, $0c, $48, $24, $9c, $f4
    db $80, $98, $18, $28, $d0, $b0, $c0, $40, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $2c, $32, $73, $8c, $23, $e2, $01, $02, $03, $01
    db $02, $04, $06, $0a, $2c, $34, $00, $30, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $6f, $50, $f7, $cf, $e0, $c0, $60, $40, $60, $40
    db $60, $40, $60, $40, $7c, $43, $03, $3c, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $c0, $40, $60, $a0, $60, $20, $6f, $2f, $7f, $30
    db $ef, $af, $00, $c0, $80, $40, $40, $c0, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $01, $01, $00, $01, $01, $00, $f1, $f0, $fb, $0a
    db $f1, $f2, $03, $01, $06, $04, $04, $06, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $10, $a0, $10, $a0, $10, $20, $90, $20, $90, $20, $90
    db $20, $10, $20, $16, $24, $1a, $00, $38

    ; padding
    ds $28, $00

; C: entry 0 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_0F_5F00_Head::
    INCBIN "data/bank_0f/Gfx_0F_5F00_Head.2bpp" ; $5F00, 896 bytes
; C: entry 1 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_0F_6280_Head::
    INCBIN "data/bank_0f/Gfx_0F_6280_Head.2bpp" ; $6280, 896 bytes
; C: entry 2 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_0F_6600_Head::
    INCBIN "data/bank_0f/Gfx_0F_6600_Head.2bpp" ; $6600, 896 bytes
; C: entry 3 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_0F_6980_Head::
    INCBIN "data/bank_0f/Gfx_0F_6980_Head.2bpp" ; $6980, 896 bytes
; C: entry 4 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_0F_6D00_Head::
    INCBIN "data/bank_0f/Gfx_0F_6D00_Head.2bpp" ; $6D00, 896 bytes
; C: entry 5 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_0F_7080_Head::
    INCBIN "data/bank_0f/Gfx_0F_7080_Head.2bpp" ; $7080, 896 bytes
; C: entry 6 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_0F_7400_Head::
    INCBIN "data/bank_0f/Gfx_0F_7400_Head.2bpp" ; $7400, 896 bytes
; C: entry 7 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_0F_7780_Head::
    INCBIN "data/bank_0f/Gfx_0F_7780_Head.2bpp" ; $7780, 896 bytes
; C: copied to VRAM/WRAM by Boot_EraseAllPrompt_Far (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 2 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Gfx_0F_7B00_Boot_EraseAllPrompt_Far::
    INCBIN "data/bank_0f/Gfx_0F_7B00_Boot_EraseAllPrompt_Far.2bpp" ; $7B00, 1280 bytes
