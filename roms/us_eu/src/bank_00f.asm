; Game Boy Camera (USA, Europe), bank $0F. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $00f", ROMX[$4000], BANK[$f]

; I: copied to VRAM/WRAM by Mode08_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
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
; I: far pointer loaded by UserMap_LoadPlanetTiles (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 15 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Gfx_0F_5500_UserMap_LoadPlanetTiles::
    INCBIN "data/bank_0f/Gfx_0F_5500_UserMap_LoadPlanetTiles.2bpp" ; $5500, 640 bytes
; I: 40 tiles (640 bytes) copied whole to $8500 by UserMap_LoadPlanetTiles (copy site 09:51DC,
; roms/jp_rev_a/assets/copy_sites_jp.csv); the four planet sets are 5500 / 5780 / 5A00 / 5C80; the labels 5800 (Aux),
; 5904 (Unref), 596C and 5984 (Data) inside it were fill-run splits
Gfx_0F_5780_UserMap_LoadPlanetTiles::
    INCBIN "data/bank_0f/Gfx_0F_5780_UserMap_LoadPlanetTiles.2bpp" ; $5780, 640 bytes
; I: far pointer loaded by UserMap_LoadPlanetTiles (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 640 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 8 replay(s) of the organic corpus, modes 08
; (tcrf_check/assets/l3_names/)
Gfx_0F_5A00_UserMap_LoadPlanetTiles::
    db $00, $00, $00, $00, $04, $02, $04, $02, $04, $02, $04, $02, $04, $03, $07, $00
    db $04, $02, $04, $02, $04, $02, $04, $02, $04, $02, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $47, $20, $42, $25, $42, $21, $42, $21, $42, $a1, $c2, $21
    db $42, $21, $42, $21, $42, $21, $42, $25, $07, $60, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $80, $00, $00, $80, $00, $00, $00, $00, $00, $00, $0f, $10
    db $0f, $10, $00, $00, $00, $00, $00, $80, $80, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $06, $09, $0f, $10, $1b, $02, $18, $00, $0d, $13, $87, $08
    db $83, $00, $11, $10, $19, $06, $1f, $00, $17, $19, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $03, $04, $07, $88, $1c, $93, $08, $14, $1c, $04, $90, $88
    db $90, $08, $8c, $14, $9a, $16, $84, $8b, $03, $04, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $83, $84, $84, $0b, $88, $44, $48, $84, $08, $c4, $08, $04
    db $08, $04, $c8, $84, $48, $84, $84, $4b, $03, $84, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $0f, $80, $88, $47, $48, $84, $48, $84, $48, $84, $4f, $80
    db $49, $86, $48, $84, $48, $84, $88, $44, $08, $84, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $80, $47, $43, $a4, $a2, $c4, $22, $44, $a2, $c5, $c3, $24
    db $82, $44, $42, $a4, $42, $24, $43, $24, $40, $27, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $e0, $e0, $00, $00, $00, $00, $00, $00, $c0, $c0, $00
    db $00, $00, $00, $00, $00, $00, $e0, $00, $00, $e0, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $04, $02, $04, $02, $04, $02, $04, $02, $04, $03, $07, $00
    db $04, $02, $04, $02, $04, $02, $04, $02, $04, $02, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $47, $20, $42, $25, $42, $21, $42, $21, $42, $a1, $c2, $21
    db $42, $21, $42, $21, $42, $21, $42, $25, $07, $60, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $80, $00, $00, $80, $00, $00, $00, $00, $00, $00, $0f, $10
    db $0f, $10, $00, $00, $00, $00, $00, $80, $80, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $06, $09, $0f, $10, $1b, $02, $18, $00, $0d, $13, $87, $08
    db $83, $00, $11, $10, $19, $06, $1f, $00, $17, $19, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $03, $04, $07, $88, $1c, $93, $08, $14, $1c, $04, $90, $88
    db $90, $08, $8c, $14, $9a, $16, $84, $8b, $03, $04, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $83, $84, $84, $0b, $88, $44, $48, $84, $08, $c4, $08, $04
    db $08, $04, $c8, $84, $48, $84, $84, $4b, $03, $84, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $0f, $80, $88, $47, $48, $84, $48, $84, $48, $84, $4f

    db $80, $49, $86, $48, $84, $48, $84, $88, $44, $08, $84, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $80, $47, $43, $a4, $a2, $c4, $22, $44, $a2, $c5, $c3
    db $24, $82, $44, $42, $a4, $42, $24, $43, $24, $40, $27, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $e0, $e0, $00, $00, $00, $00, $00, $00, $c0, $c0
    db $00, $00, $00, $00, $00, $00, $00, $e0, $00, $00, $e0

    ; padding
    ds $26, $00

; I: far pointer loaded by UserMap_LoadPlanetTiles (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 640 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 7 replay(s) of the organic corpus, modes 08
; (tcrf_check/assets/l3_names/)
Gfx_0F_5C80_UserMap_LoadPlanetTiles::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $0e, $12, $1e, $20, $72, $4d, $21, $52, $70, $13, $40, $20
    db $40, $20, $33, $52, $69, $5a, $12, $2d, $0c, $12, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $3e, $01, $21, $1e, $22, $13, $20, $11, $22, $13, $3f, $00
    db $26, $19, $21, $12, $21, $10, $21, $10, $21, $10, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $1f, $0f, $90, $88, $10, $88, $10, $88, $17, $0f, $90
    db $08, $10, $08, $90, $08, $90, $0f, $90, $00, $9f, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $1c, $82, $9e, $01, $17, $0c, $13, $0a, $11, $08, $10, $09
    db $10, $09, $13, $0a, $15, $0e, $96, $09, $0c, $92, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $1e, $00, $08, $16, $88, $84, $08, $84, $88, $04, $88, $04
    db $88, $04, $88, $04, $08, $84, $08, $16, $1e, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $7e, $7e, $00, $7e, $66, $18, $00, $18, $00, $18, $00
    db $18, $00, $18, $00, $18, $00, $18, $00, $18, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $18, $24, $3c, $42, $6c, $0a, $60, $00, $34, $4c, $1e, $22
    db $0e, $00, $46, $40, $66, $18, $7e, $02, $5c, $64, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $0e, $12, $1e, $20, $72, $4d, $21, $52, $70, $13, $40, $20
    db $40, $20, $33, $52, $69, $5a, $12, $2d, $0c, $12, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $3e, $01, $21, $1e, $22, $13, $20, $11, $22, $13, $3f, $00
    db $26, $19, $21, $12, $21, $10, $21, $10, $21, $10, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $1f, $0f, $90, $88, $10, $88, $10, $88, $17, $0f, $90
    db $08, $10, $08, $90, $08, $90, $0f, $90, $00, $9f, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $1c, $82, $9e, $01, $17, $0c, $13, $0a, $11, $08, $10, $09
    db $10, $09, $13, $0a, $15, $0e, $96, $09, $0c, $92, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $1e, $00, $08, $16, $88, $84, $08, $84, $88, $04, $88, $04
    db $88, $04, $88, $04, $08, $84, $08, $16, $1e, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $7e, $7e, $00, $7e, $66, $18, $00, $18, $00, $18, $00
    db $18, $00, $18, $00, $18, $00, $18, $00, $18, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $18, $24, $3c, $42, $6c, $0a, $60, $00, $34, $4c, $1e, $22
    db $0e, $00, $46, $40, $66, $18, $7e, $02, $5c, $64, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $28, $00

; I: entry 0 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_0F_5F00_Head::
    INCBIN "data/bank_0f/Gfx_0F_5F00_Head.2bpp" ; $5F00, 896 bytes
; I: entry 1 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_0F_6280_Head::
    INCBIN "data/bank_0f/Gfx_0F_6280_Head.2bpp" ; $6280, 896 bytes
; I: entry 2 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_0F_6600_Head::
    INCBIN "data/bank_0f/Gfx_0F_6600_Head.2bpp" ; $6600, 896 bytes
; I: entry 3 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_0F_6980_Head::
    INCBIN "data/bank_0f/Gfx_0F_6980_Head.2bpp" ; $6980, 896 bytes
; I: entry 4 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_0F_6D00_Head::
    INCBIN "data/bank_0f/Gfx_0F_6D00_Head.2bpp" ; $6D00, 896 bytes
; I: entry 5 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_0F_7080_Head::
    INCBIN "data/bank_0f/Gfx_0F_7080_Head.2bpp" ; $7080, 896 bytes
; I: entry 6 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_0F_7400_Head::
    INCBIN "data/bank_0f/Gfx_0F_7400_Head.2bpp" ; $7400, 896 bytes
; I: entry 7 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_0F_7780_Head::
    INCBIN "data/bank_0f/Gfx_0F_7780_Head.2bpp" ; $7780, 896 bytes
; I: copied to VRAM/WRAM by Boot_EraseAllPrompt_Far (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 2 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Gfx_0F_7B00_Boot_EraseAllPrompt_Far::
    INCBIN "data/bank_0f/Gfx_0F_7B00_Boot_EraseAllPrompt_Far.2bpp" ; $7B00, 1280 bytes
